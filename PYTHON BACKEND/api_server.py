from flask import Flask, request, jsonify
from flask_cors import CORS
from complete_chatbot import CompleteChatbot
import json

app = Flask(__name__)
CORS(app)  # Enable CORS for Flutter app

# Initialize chatbot
chatbot = CompleteChatbot()

@app.route('/api/chat', methods=['POST'])
def chat():
    try:
        data = request.get_json()
        user_message = data.get('message', '')
        
        if not user_message:
            return jsonify({'error': 'No message provided'}), 400
        
        # Process message through chatbot
        result = chatbot.process_message(user_message)
        
        response_data = {
            'response': result['response'],
            'emotion': result['emotion_analysis']['primary_emotion'],
            'intensity': result['emotion_analysis']['intensity'],
            'stage': result['conversation_stage'],
            'safety_level': result['safety_level']
        }
        
        return jsonify(response_data)
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/session_report', methods=['GET'])
def session_report():
    try:
        report = chatbot.get_session_report()
        return jsonify(report)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/save_conversation', methods=['POST'])
def save_conversation():
    try:
        chatbot.save_conversation()
        return jsonify({'message': 'Conversation saved successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/health', methods=['GET'])
def health():
    return jsonify({'status': 'healthy', 'message': 'Chatbot API is running'})

if __name__ == '__main__':
    print("🤖 Digital Psychologist API Server Starting...")
    print("📡 Endpoints:")
    print("  POST /api/chat - Send message to chatbot")
    print("  GET  /api/session_report - Get session summary")
    print("  POST /api/save_conversation - Save conversation history")
    print("  GET  /api/health - Health check")
    print("\n🚀 Server running on http://localhost:5000")
    
    app.run(debug=True, host='0.0.0.0', port=5000)
