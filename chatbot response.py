from ast import main


class SentimentAnalyzer:
    # Simple keyword-based sentiment detector
    @staticmethod
    def detectMood(input):
        text = input.lower()

        # Angry / negative words
        angryWords = ["hate", "angry", "stupid", "annoyed", "bad", "frustrated"]
        # Happy / positive words
        happyWords = ["love", "happy", "great", "awesome", "amazing", "good"]
        # Sad words
        sadWords = ["sad", "upset", "depressed", "lonely", "cry"]

        if any(w in text for w in angryWords):
            return "angry"
        elif any(w in text for w in happyWords):
            return "happy"
        elif any(w in text for w in sadWords):
            return "sad"
        else:
            return "neutral"

    # Adjust chatbot tone based on mood
    @staticmethod
    def chatbotReply(userInput):
        mood = SentimentAnalyzer.detectMood(userInput)

        if mood == "angry":
            return "😌 I understand you’re upset. Let’s try to work through this calmly."
        elif mood == "happy":
            return "🎉 That’s wonderful! I’m really glad to hear that."
        elif mood == "sad":
            return "💙 I’m sorry you’re feeling down. You’re not alone in this."
        else:
            return "🙂 Thanks for sharing. Tell me more!"
def main():
    testInputs = [
        "I hate this app!",
        "This is amazing, I love it!",
        "I feel so sad today",
        "Just another normal day"
    ]

    for input in testInputs:
        reply = SentimentAnalyzer.chatbotReply(input)
        print(f"User: {input}")
        print(f"Bot: {reply}\n")
if __name__ == "__main__":
    main()
