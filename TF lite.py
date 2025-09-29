
import numpy as np
import tensorflow as tf
def load_tflite_model(model_path):
    interpreter = tf.lite.Interpreter(model_path=model_path)
    interpreter.allocate_tensors()
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    return interpreter, input_details, output_details
def run_tflite_inference(interpreter, input_details, output_details, input_data):
    input_data = np.array(input_data, dtype=np.float32).reshape(input_details[0]['shape'])
    interpreter.set_tensor(input_details[0]['index'], input_data)
    interpreter.invoke()
    output_data = interpreter.get_tensor(output_details[0]['index'])
    return output_data
def rule_based_sentiment_analysis(text):
    positive_keywords = ['happy', 'joy', 'love', 'excited', 'great','good','fantastic','wonderful']
    negative_keywords = ['sad', 'angry', 'hate', 'terrible', 'bad','awful','poor','fear',]
    neutrL_keywords = ['okay', 'fine', 'average', 'neutral']
    text = text.lower()
    if any(word in text for word in positive_keywords):
        return 'Positive(Rule-Based)'
    elif any(word in text for word in negative_keywords):
        return 'Negative(Rule-Based)'
    else:
        return 'Neutral(Rule-Based)'    
if __name__ == "__main__":
    sample_text = ["I am very happy with the service",
                   "This ia a bad idea",
                   "This movie is terrible",
                   "I love this product",
                   "she is angry about the delay",
                   "It's an average day",
                   "The food was awful and bad",
                   "I feel fantastic today"]                
    for txt in sample_text:
        print(txt, "->", rule_based_sentiment_analysis(txt))
