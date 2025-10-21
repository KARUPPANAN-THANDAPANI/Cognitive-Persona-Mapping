import pandas as pd
import json
import random
from safety_checker import SafetyChecker
from emotional_analyzer import EmotionalAnalyzer

class ChatbotEngine:
    def __init__(self):
        self.safety_checker = SafetyChecker()
        self.emotion_analyzer = EmotionalAnalyzer()
        self.companion_responses = None
        self.psychologist_interventions = None
        self.load_datasets()
    
    def load_datasets(self):
        self.companion_responses = pd.read_csv('companion_responses.csv')
        with open('psychologist_interventions.json', 'r') as f:
            self.psychologist_interventions = json.load(f)
        print('Datasets loaded')
    
    def get_response(self, user_message, conversation_stage="companion"):
        # First check safety
        safety_level, crisis_response = self.safety_checker.check_message(user_message)
        if safety_level != "SAFE":
            return crisis_response, safety_level, {"emotion": "crisis", "intensity": "high"}
        
        # Analyze emotion
        emotion_analysis = self.emotion_analyzer.analyze_emotion(user_message)
        
        # Get appropriate response based on stage
        if conversation_stage == "companion":
            response = self._get_emotion_aware_companion_response(user_message, emotion_analysis)
        elif conversation_stage == "psychologist":
            response = self._get_psychologist_response(user_message)
        else:
            response = self._get_emotion_aware_companion_response(user_message, emotion_analysis)
            
        return response, "SAFE", emotion_analysis
    
    def _get_emotion_aware_companion_response(self, user_message, emotion_analysis):
        emotion = emotion_analysis['primary_emotion']
        intensity = emotion_analysis['intensity']
        
        # Emotion-specific responses
        emotion_responses = {
            'happy': [
                "I'm so glad you're feeling happy! What's bringing you joy today?",
                "It's wonderful to hear you're feeling good! Celebrate these moments.",
                "Happiness is contagious! Thanks for sharing your positive energy."
            ],
            'sad': [
                "I hear your sadness. It's okay to feel this way. I'm here with you.",
                "Your feelings are valid. Would you like to talk about what's making you sad?",
                "I can sense your sadness. Remember, this feeling won't last forever."
            ],
            'anxious': [
                "I understand that anxiety can feel overwhelming. Let's breathe through this together.",
                "That worry sounds really intense. Would grounding techniques help right now?",
                "Anxiety is tough. Let's break this down into smaller, manageable pieces."
            ],
            'angry': [
                "I hear the anger in your words. That must be really frustrating.",
                "Anger tells us something important. Want to explore what's beneath it?",
                "That sounds really maddening. Would physical release help right now?"
            ]
        }
        
        # Use emotion-specific responses if available
        if emotion in emotion_responses and emotion != 'neutral':
            return random.choice(emotion_responses[emotion])
        
        # Fallback to original keyword matching
        return self._get_companion_response(user_message)
    
    def _get_companion_response(self, user_message):
        user_message_lower = user_message.lower()
        
        # Check for keywords in user message
        for _, row in self.companion_responses.iterrows():
            input_text = row['input_text'].lower()
            # Simple contains matching
            if any(word in user_message_lower for word in input_text.split()):
                return row['response_text']
        
        # Default empathetic response if no match
        default_responses = [
            "Thank you for sharing that with me. I'm here to listen.",
            "I hear what you're saying. Would you like to talk more about that?",
            "That sounds really important. Tell me more about how you're feeling."
        ]
        return random.choice(default_responses)
    
    def _get_psychologist_response(self, user_message):
        # Check for CBT technique triggers
        user_message_lower = user_message.lower()
        
        for technique in self.psychologist_interventions['cbt_techniques']:
            for keyword in technique['trigger_keywords']:
                if keyword in user_message_lower:
                    steps = "\n".join([f"{i+1}. {step}" for i, step in enumerate(technique['steps'])])
                    return f"Let's try {technique['technique']}:\n{steps}"
        
        # Fallback to companion response
        return self._get_companion_response(user_message)

# Test the chatbot engine
if __name__ == "__main__":
    chatbot = ChatbotEngine()
    
    test_conversations = [
        ("I'm feeling really happy today!", "companion"),
        ("I'm so anxious about my presentation", "companion"),
        ("I feel incredibly sad and lonely", "companion"),
        ("I always fail at everything", "psychologist"),
        ("I should be perfect all the time", "psychologist")
    ]
    
    for user_msg, stage in test_conversations:
        print(f"\n🧠 User ({stage}): {user_msg}")
        response, safety, emotion = chatbot.get_response(user_msg, stage)
        print(f"🎭 Emotion: {emotion['primary_emotion']} ({emotion['intensity']} intensity)")
        print(f"🤖 Bot: {response}")
        if safety != "SAFE":
            print(f"🚨 Safety: {safety}")