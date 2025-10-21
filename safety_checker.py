class SafetyChecker:
    def __init__(self):
        self.crisis_words = ['suicide', 'kill myself', 'end my life', 'want to die']
        self.warning_words = ['hopeless', 'can\'t go on', 'nothing matters']
    
    def check_message(self, message):
        message_lower = message.lower()
        for word in self.crisis_words:
            if word in message_lower:
                return "CRISIS", "I'm very concerned about your safety. Please contact emergency services or crisis helpline: 1-800-273-8255"
        for word in self.warning_words:
            if word in message_lower:
                return "WARNING", "It sounds like you're going through an extremely difficult time. I strongly encourage you to speak with a mental health professional."
        return "SAFE", ""

if __name__ == "__main__":
    checker = SafetyChecker()
    test_messages = ["I'm feeling stressed", "I want to die", "I feel hopeless"]
    for msg in test_messages:
        level, response = checker.check_message(msg)
        print(f"'{msg}' -> {level}: {response}")