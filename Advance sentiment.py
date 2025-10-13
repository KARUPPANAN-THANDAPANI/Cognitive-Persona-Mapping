from transformers import pipeline
import matplotlib.pyplot as plt
from datetime import datetime, timedelta

# Load pre-trained emotion classifier
classifier = pipeline("text-classification", model="j-hartmann/emotion-english-distilroberta-base", return_all_scores=True)

# Sample user messages
Sample_texts = [
    "I am very happy today!",
    "I am so sad and depressed.",
    "I am going to kill Lakshya.",
    "I am excited about the new project.",
    "I am angry about the delay.",
    "I am scared of the dark.",
    "I don't know what to do anymore.",
    "This is frustrating and exhausting."
]

# Crisis detection function
def is_crisis(text, emotion_label, intensity_score):
    negative_emotions = ["sadness", "anger", "fear"]
    crisis_keywords = ["kill", "suicide", "end it", "hopeless", "hurt", "die", "destroy", "murder"]
    text_lower = text.lower()
    keyword_trigger = any(word in text_lower for word in crisis_keywords)

    # Crisis if keyword is present OR emotion is negative and intensity is high
    if keyword_trigger:
        return True
    if emotion_label in negative_emotions and intensity_score > 0.75:
        return True
    return False

# Analyze messages
emotion_log = []
for i, msg in enumerate(Sample_texts):
    result = classifier(msg)[0]
    top_emotion = max(result, key=lambda x: x['score'])
    timestamp = datetime.now() - timedelta(days=len(Sample_texts) - i)

    # Emotion intensity detection
    intensity_score = top_emotion['score']
    if intensity_score > 0.75:
        intensity = 'High'
    elif intensity_score > 0.3:
        intensity = 'Medium'
    else:
        intensity = 'Low'

    # Crisis flag detection
    crisis_flag = is_crisis(msg, top_emotion['label'], intensity_score)

    # Store results
    emotion_log.append({
        "timestamp": timestamp,
        "text": msg,
        "emotion": top_emotion['label'],
        "intensity": intensity,
        "score": intensity_score,
        "crisis": crisis_flag
    })

# Print results
for entry in emotion_log:
    print(f"{entry['timestamp'].strftime('%d-%m-%Y')} | {entry['emotion']} ({entry['intensity']}, {entry['score']:.3f}) | Crisis: {entry['crisis']}")

# Mood trend analysis plot
dates = [e['timestamp'].strftime('%d-%m-%Y') for e in emotion_log]
emotions = [e['emotion'] for e in emotion_log]
scores = [e["score"] for e in emotion_log]

plt.figure(figsize=(10, 5))
plt.plot(dates, scores, marker='o', linestyle='-', color='red')
for i, txt in enumerate(emotions):
    plt.annotate(txt, (dates[i], scores[i]), textcoords="offset points", xytext=(0, 10), ha='center')
plt.title("Mood Trend Analysis")
plt.xlabel("Date")
plt.ylabel("Emotion Intensity Score")
plt.xticks(rotation=45)
plt.tight_layout()
plt.grid(True)
plt.show()