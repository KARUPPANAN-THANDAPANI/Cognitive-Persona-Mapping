from typing import Dict, List, Union, Tuple
TRAIT_KEYS = ["O", "C", "E", "A", "N"]
TRAIT_NAMES = {
    "O": "Openness to Experience",
    "C": "Conscientiousness",
    "E": "Extraversion",
    "A": "Agreeableness",
    "N": "Neuroticism(Emotional Stability)"}
TRAIT_ADJECTIVES = {"O":{"high":["curious","imaginative","creative","adventurous","open-minded","intellectual","sophisticated","insightful","original","wide interests","innovative"]
                        ,"moderate":["balanced in imagination and practicality","somewhat inventive","somewhat curious","somewhat interested in art and culture","somewhat original","moderately curious"],
                        "low":["practical","down-to-earth","conventional","uncreative","narrow interests","traditional","simple","familiar","consistent","cautious","prefer routine"]},
                    "C":{"high":["organized","reliable","hardworking","punctual","disciplined","efficient","thorough","responsible","dependable","goal-oriented","self-controlled"],
                         "moderate":["somewhat organized","somewhat reliable","somewhat hardworking","somewhat punctual","somewhat disciplined","somewhat efficient","somewhat thorough","somewhat responsible","somewhat dependable","moderately self-controlled","reasonably organized"],
                         "low":["disorganized","careless","impulsive","irresponsible","lazy","spontaneous","unreliable","negligent","easy-going","messy","lackadaisical","flexible","less structured"]},
                    "E":{"high":["outgoing","energetic","sociable","talkative","assertive","enthusiastic","fun-loving","adventurous","confident","gregarious","active"],
                         "moderate":["social when needed","somewhat energetic","somewhat talkative","balanced in social and solitary activities","balanced between introversion and extraversion","moderately enthusiastic","reasonably outgoing","somewhat assertive","occasionally lively"],
                         "low":["reserved","quiet","independent","introspective","thoughtful","shy","serious","cautious","private","low-key","calm"]},
                    "A":{"high":["cooperative","trusting","empathetic","kind","generous","affectionate","helpful","considerate","forgiving","good-natured","warm"],
                         "moderate":["balanced in empathy and paragmatism","somewhat trusting","somewhat kind","somewhat cooperative","somewhat empathetic","moderately warm","reasonably considerate","occasionally helpful"],
                         "low":["competitive","critical","rational","suspicious","uncooperative","stubborn","aloof","cynical","distant","pragmatic","tough-minded","skeptical"]},
                    "N":{"high":["anxious","moody","irritable","self-conscious","sensitive to stress","emotional","temperamental","worrying","vulnerable","insecure","nervous","emotionally reactive"],
                         "moderate":["occasionally anxious","occasionally moody","occasionally irritable","somewhat self-conscious","somewhat sensitive to stress","somewhat emotional","moderately worrying","reasonably nervous","balanced in emotional reactivity","occasionally stressed"],
                         "low":["calm","even-tempered","emotionally stable","secure","confident","relaxed","resilient","composed","calm under pressure"]}}
def normalise_scores(scores: List[float]) -> List[float]:
    """Normalises a list of numeric scores to 0-100 scale."""
    if not scores:
        return [50.0]*5
    min_v=min(scores)
    max_v=max(scores)
    if min_v==max_v:
        return [50.0]*len(scores)
    normalized = [((s - min_v)/(max_v - min_v))*100.0 for s in scores]
    return normalized
def _to_ordered_scores(results: Union[Dict[str, float], List[float], Tuple[float, ...]])->List[float]:
    """Returns a list of scores in the order of TRAIT_KEYS."""
    if isinstance(results, dict):
        scores = []
        for k in TRAIT_KEYS:
            raw = results.get(k,results.get(TRAIT_NAMES.get(k,""),None))
            scores.append(float(raw) if raw is not None else 50.0)
        return scores
    elif isinstance(results, (list, tuple)):
        if len(results) >=5:
            return [float(results[i]) for i in range(5)]
        else:
            out = [float(v) for v in results]
            while len(out)<5:
                out.append(50.0)
            return out
    else:
        return [float(results)]*5
def _bucket_label(score: float) -> str:
    """Convert 0-100 score to categorical label."""
    if score >= 67.0:
        return "high"
    elif score <= 33.0:
        return "low"
    else:
        return "moderate"
def _compose_trait_paragraph(code:str, score: float,label:str)->str:
    """Compose a descriptive paragraph for a trait."""
    name = TRAIT_NAMES.get(code, code)
    adj_list = TRAIT_ADJECTIVES.get(code, {}).get(label, [])
    adjectives = ", ".join(adj_list[:3])
    paragraph = (f"{name} ({code}): {int(round(score))}/100 - {label.capitalize()}.\n"
                 f"People with this level of {name.lower()} tend to be {adjectives}.\n")
    if code == "N":
        if label == "low":
            paragraph += "This suggests good emotional stability and resilience under stress.\n"
        elif label == "high":
            paragraph += "This  person may experience emotional reactions and may benefits from stress management techniques.\n"
    else:
        if label == "high":
            paragraph += f"This trait is a strength in situations that need {adjectives}.\n"
        elif label == "low":
            paragraph += f"This might mean they prefer environments that are less focused on {adjectives}.\n"
    return paragraph
#simple carrer advice mapping
CAREER_ADVICE = {"O":{"high":["Artist","Researcher","Entrepreneur","Writer","UX Designer"],"moderate":["Teacher","Consultant","Marketing Specialist","Project Manager"],"low":["Accountant","Administrator","Data Analyst","Logistics Coordinator"]},
                 "C":{"high":["Engineer","Surgeon","Financial Analyst","Operations Manager","Accountant"],"moderate":["Teacher","Sales Manager","HR Specialist","Marketing Coordinator"],"low":["Artist","Writer","Freelancer","Entrepreneur"]},
                 "E":{"high":["Salesperson","Public Relations Specialist","Event Planner","Actor","Customer Service Representative"],"moderate":["Teacher","Project Manager","Consultant","Marketing Specialist","Team Lead","Coordinator"],"low":["Researcher","Writer","Accountant","Data Analyst","Librarian"]},
                 "A":{"high":["Nurse","Social Worker","Teacher","Counselor","Customer Service Representative"],"moderate":["HR Specialist","Project Manager","Consultant","Marketing Coordinator"],"low":["Lawyer","Surgeon","Financial Analyst","Scientist","Negotiator","Auditor"]},
                 "N":{"high":["Artist","Writer","Therapist","Social Worker","Customer Service Representative","Creative fields with self-expression"],"moderate":["Teacher","Consultant","Project Manager","Marketing Specialist","Supportive roles"],"low":["Surgeon","High-pressure leadership roles","Crisis management","Financial Analyst","Lawyer"]}}
def generate_personality_report(results: Union[Dict[str, float], List[float], Tuple[float, ...]], normalize: bool = True, save_path: str = None) -> str:
    """Generate a personality profile from OCEAN scores.
    Args:
        results: A dictionary with trait codes as keys and scores as values,
                 or a list/tuple of scores in the order of O, C, E, A, N.
        normalize: Whether to normalize scores to 0-100 scale.
        save_path: Optional path to save the report as a text file.
        Returns:
            A formatted personality report as a string."""
    raw_scores = _to_ordered_scores(results)
    scores = normalise_scores(raw_scores) if normalize else [min(max(s, 0.0), 100.0) for s in raw_scores]
    header = "Personality Profile (OCEAN)\n"
    header += "-" * 32 + "\n\n"
    dominant_traits = []
    balanced_traits = []
    for i, code in enumerate(TRAIT_KEYS):
        label = _bucket_label(scores[i])
        if label == "high":
            dominant_traits.append((code, scores[i], ))
        elif label == "moderate":
            balanced_traits.append((code, scores[i], ))
    overall = "Summary:\n"
    if dominant_traits:
        names =  ", ".join([TRAIT_NAMES[c] for c,_ in dominant_traits])
        overall += f"This person has dominant traits in {names}.\n"
    else:
        overall += "This person has a balanced personality profile with no extreme traits.\n"
    trait_sections = []
    for i, code in enumerate(TRAIT_KEYS):
        label = _bucket_label(scores[i])
        paragraph = _compose_trait_paragraph(code, scores[i], label)
        trait_sections.append(paragraph)
    advice = "\nPractical Advice & Career Suggestions:\n"
    suggested_careers = set()
    for i, code in enumerate(TRAIT_KEYS):
        label = _bucket_label(scores[i])
        suggestions = CAREER_ADVICE.get(code, {}).get(label, [])
        for s in suggestions:
            suggested_careers.add(s)
    if suggested_careers:
        advice += "-Roles that align with your personality traits include: " + ", ".join(sorted(suggested_careers)) + ".\n"
    else:
        advice += "-Consider exploring various career paths to find what suits you best.\n"
    advice += "-Tips: Focus on leveraging your strengths and managing areas for growth.\n"
    advice += "-Engage in activities that promote well-being and personal development.\n"
    profile_text = header + overall + "\n" + "\n".join(trait_sections) + advice   
    if save_path:
        try:
            with open(save_path, "w",encoding="utf-8") as f:
                f.write(profile_text)
        except Exception as e:
            profile_text += f"\n\n(Note: Failed to save report to {save_path}. Error: {e})"
    return profile_text
if __name__ == "__main__":
    sample_results_dict = {"O": 85, "C": 70, "E": 55, "A": 30, "N": 20}
    profile1 = generate_personality_report(sample_results_dict, normalize=True)
    print(profile1)
    sample_results_list = [40, 60, 80, 20, 90]
    profile2 = generate_personality_report(sample_results_list, normalize=False)
    print("\n" + "="*40 + "\n")
    print(profile2)
    