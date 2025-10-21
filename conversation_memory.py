import json
import datetime
from collections import deque

class ConversationMemory:
    def __init__(self, max_history=50):
        self.conversation_history = deque(maxlen=max_history)
        self.user_profile = {
            'frequent_emotions': {},
            'common_topics': {},
            'trust_level': 0,
            'session_count': 0
        }
    
    def add_interaction(self, user_message, bot_response, emotion_analysis, safety_level):
        timestamp = datetime.datetime.now().isoformat()
        
        interaction = {
            'timestamp': timestamp,
            'user_message': user_message,
            'bot_response': bot_response,
            'emotion': emotion_analysis['primary_emotion'],
            'intensity': emotion_analysis['intensity'],
            'safety_level': safety_level
        }
        
        self.conversation_history.append(interaction)
        self._update_user_profile(emotion_analysis, user_message)
    
    def _update_user_profile(self, emotion_analysis, user_message):
        emotion = emotion_analysis['primary_emotion']
        self.user_profile['frequent_emotions'][emotion] = self.user_profile['frequent_emotions'].get(emotion, 0) + 1
        
        topics = self._extract_topics(user_message)
        for topic in topics:
            self.user_profile['common_topics'][topic] = self.user_profile['common_topics'].get(topic, 0) + 1
        
        if emotion_analysis['primary_emotion'] != 'crisis':
            self.user_profile['trust_level'] = min(100, self.user_profile['trust_level'] + 2)
    
    def _extract_topics(self, message):
        topics = []
        topic_keywords = {
            'work': ['work', 'job', 'career', 'office', 'boss', 'colleague'],
            'relationships': ['friend', 'family', 'partner', 'relationship', 'boyfriend', 'girlfriend'],
            'health': ['health', 'sick', 'pain', 'doctor', 'hospital', 'medical'],
            'school': ['school', 'college', 'exam', 'study', 'homework', 'teacher'],
            'finance': ['money', 'financial', 'bill', 'debt', 'expensive', 'cost']
        }
        
        message_lower = message.lower()
        for topic, keywords in topic_keywords.items():
            if any(keyword in message_lower for keyword in keywords):
                topics.append(topic)
        
        return topics
    
    def get_conversation_summary(self):
        if not self.conversation_history:
            return "No conversation history yet."
        
        recent_emotions = [interaction['emotion'] for interaction in list(self.conversation_history)[-5:]]
        emotion_summary = {}
        for emotion in recent_emotions:
            emotion_summary[emotion] = emotion_summary.get(emotion, 0) + 1
        
        return {
            'total_interactions': len(self.conversation_history),
            'recent_emotions': emotion_summary,
            'trust_level': self.user_profile['trust_level'],
            'frequent_topics': dict(sorted(self.user_profile['common_topics'].items(), key=lambda x: x[1], reverse=True)[:3])
        }
    
    def save_conversation(self, filename='conversation_history.json'):
        data = {
            'conversation_history': list(self.conversation_history),
            'user_profile': self.user_profile,
            'exported_at': datetime.datetime.now().isoformat()
        }
        
        with open(filename, 'w') as f:
            json.dump(data, f, indent=2)
        
        print(f"Conversation saved to {filename}")

if __name__ == "__main__":
    memory = ConversationMemory()
    test_interactions = [
        ("I'm stressed about work", "Let's try some breathing exercises.", {'primary_emotion': 'anxious', 'intensity': 'high'}, 'SAFE'),
        ("My friend made me angry", "I hear your frustration.", {'primary_emotion': 'angry', 'intensity': 'medium'}, 'SAFE'),
        ("I have money problems", "Financial stress is really challenging.", {'primary_emotion': 'anxious', 'intensity': 'high'}, 'SAFE')
    ]
    
    for user_msg, bot_resp, emotion, safety in test_interactions:
        memory.add_interaction(user_msg, bot_resp, emotion, safety)
    
    summary = memory.get_conversation_summary()
    print("Conversation Summary:")
    print(json.dumps(summary, indent=2))
    memory.save_conversation()