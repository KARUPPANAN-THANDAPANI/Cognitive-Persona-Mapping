
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
    neutraL_keywords = ['okay', 'fine', 'average', 'neutral']
    text = text.lower()
    if any(word in text for word in positive_keywords):
        return 'Positive(Rule-Based)'
    elif any(word in text for word in negative_keywords):
        return 'Negative(Rule-Based)'
    else:
        return 'Neutral(Rule-Based)'               
#Combined Sentiment Detection
def combined_sentiment_analysis(text, interpreter, input_details, output_details, preprocess_fn):
    rule_result = rule_based_sentiment_analysis(text)
    if rule_result is not None:
        return rule_result
    processed_input = preprocess_fn(text)
    output = run_tflite_inference(interpreter, input_details, output_details, processed_input)
    predicted_class = np.argmax(output)
    if predicted_class == 0:
        return 'Negative(TF-Lite)'
    elif predicted_class == 1:
        return 'Neutral(TF-Lite)'
    else:
        return 'Positive(TF-Lite)'
if __name__ == "__main__":
    model_path = 'model.tflite'
    interpreter, input_details, output_details = load_tflite_model(model_path)
    def dummy_preprocess(text):
        return [len(text.split())]
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