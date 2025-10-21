import re
from collections import Counter

class EmotionalAnalyzer:
    def __init__(self):
        self.emotion_keywords = {
            'happy': ['happy', 'joy', 'excited', 'good', 'great', 'wonderful', 'amazing'],
            'sad': ['sad', 'unhappy', 'depressed', 'miserable', 'hopeless', 'tearful'],
            'angry': ['angry', 'mad', 'furious', 'annoyed', 'frustrated', 'irritated'],
            'anxious': ['anxious', 'nervous', 'worried', 'stressed', 'panicked', 'overwhelmed'],
            'calm': ['calm', 'peaceful', 'relaxed', 'serene', 'content', 'balanced']
        }
        
        self.intensity_indicators = {
            'high': ['extremely', 'very', 'really', 'so', 'incredibly', 'terribly'],
            'medium': ['quite', 'pretty', 'somewhat', 'kinda', 'a bit'],
            'low': ['slightly', 'a little', 'mildly']
        }
    
    def analyze_emotion(self, text):
        text_lower = text.lower()
        
        # Count emotion keywords
        emotion_scores = {}
        for emotion, keywords in self.emotion_keywords.items():
            count = sum(1 for keyword in keywords if keyword in text_lower)
            if count > 0:
                emotion_scores[emotion] = count
        
        # Determine primary emotion
        if emotion_scores:
            primary_emotion = max(emotion_scores.items(), key=lambda x: x[1])[0]
        else:
            primary_emotion = 'neutral'
        
        # Analyze intensity
        intensity = self._analyze_intensity(text_lower)
        
        # Get emotional context
        context = self._get_emotional_context(primary_emotion, intensity)
        
        return {
            'primary_emotion': primary_emotion,
            'intensity': intensity,
            'emotion_scores': emotion_scores,
            'context': context
        }
    
    def _analyze_intensity(self, text):
        for intensity, indicators in self.intensity_indicators.items():
            if any(indicator in text for indicator in indicators):
                return intensity
        return 'medium'
    
    def _get_emotional_context(self, emotion, intensity):
        contexts = {
            'happy': {
                'low': 'Content and satisfied',
                'medium': 'Joyful and positive', 
                'high': 'Ecstatic and elated'
            },
            'sad': {
                'low': 'Feeling down',
                'medium': 'Sad and low',
                'high': 'Deeply distressed'
            },
            'anxious': {
                'low': 'Mildly concerned',
                'medium': 'Anxious and worried', 
                'high': 'Panicked and overwhelmed'
            },
            'angry': {
                'low': 'Irritated',
                'medium': 'Angry and frustrated',
                'high': 'Furious and enraged'
            }
        }
        
        return contexts.get(emotion, {}).get(intensity, 'Neutral')
    
    def get_emotion_summary(self, text):
        analysis = self.analyze_emotion(text)
        return f"Emotion: {analysis['primary_emotion'].upper()} ({analysis['intensity']} intensity) - {analysis['context']}"

# Test the emotional analyzer
if __name__ == "__main__":
    analyzer = EmotionalAnalyzer()
    
    test_texts = [
        "I'm feeling really happy today!",
        "I'm so anxious about my presentation",
        "I feel a bit sad but it's okay",
        "I'm extremely angry about what happened"
    ]
    
    for text in test_texts:
        print(f"\nText: {text}")
        result = analyzer.analyze_emotion(text)
        print(f"Analysis: {result}")
        print(f"Summary: {analyzer.get_emotion_summary(text)}")