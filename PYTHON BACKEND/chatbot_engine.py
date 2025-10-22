from chatbot_engine import ChatbotEngine
from conversation_memory import ConversationMemory
import json

class CompleteChatbot:
    def __init__(self):
        self.chatbot = ChatbotEngine()
        self.memory = ConversationMemory()
        self.conversation_stage = "companion"
        self.session_interactions = 0
        
    def process_message(self, user_message):
        # Get chatbot response with emotion analysis
        response, safety, emotion_analysis = self.chatbot.get_response(user_message, self.conversation_stage)
        
        # Store in memory
        self.memory.add_interaction(user_message, response, emotion_analysis, safety)
        
        # Update session count
        self.session_interactions += 1
        
        # Check for stage transition
        self._update_conversation_stage()
        
        return {
            'response': response,
            'safety_level': safety,
            'emotion_analysis': emotion_analysis,
            'conversation_stage': self.conversation_stage,
            'session_summary': self.memory.get_conversation_summary()
        }
    
    def _update_conversation_stage(self):
        profile = self.memory.user_profile
        
        # Transition rules
        if self.conversation_stage == "companion":
            if profile['trust_level'] >= 30 and self.session_interactions >= 5:
                self.conversation_stage = "assessment"
                print("🔄 Transitioning to ASSESSMENT stage")
                
        elif self.conversation_stage == "assessment":
            if profile['trust_level'] >= 60 and self.session_interactions >= 10:
                self.conversation_stage = "psychologist"
                print("🔄 Transitioning to PSYCHOLOGIST stage")
    
    def get_session_report(self):
        return self.memory.get_conversation_summary()
    
    def save_conversation(self):
        self.memory.save_conversation()

# Test the complete chatbot system
if __name__ == "__main__":
    chatbot = CompleteChatbot()
    
    print("🤖 Digital Psychologist Chatbot - Session Started")
    print("Type 'quit' to end the session\n")
    
    test_messages = [
        "Hi, I'm feeling a bit anxious today",
        "I have a big work presentation coming up",
        "I'm worried I'll mess it up and everyone will judge me",
        "I should be more confident but I always doubt myself",
        "What if I fail and lose my job?",
        "I feel like I'm not good enough for this position"
    ]
    
    for i, message in enumerate(test_messages, 1):
        print(f"\n--- Message {i} ---")
        print(f"🧠 User: {message}")
        
        result = chatbot.process_message(message)
        
        print(f"🎭 Emotion: {result['emotion_analysis']['primary_emotion']} ({result['emotion_analysis']['intensity']})")
        print(f"📊 Stage: {result['conversation_stage']}")
        print(f"🤖 Bot: {result['response']}")
        
        if i % 3 == 0:
            print(f"\n📈 Progress: {result['session_summary']}")
    
    print(f"\n🎯 Final Session Report:")
    final_report = chatbot.get_session_report()
    print(json.dumps(final_report, indent=2))
    
    chatbot.save_conversation()