import sys
from keras.preprocessing.text import Tokenizer
from keras.preprocessing import sequence
from keras.models import load_model
import pickle


def process_long_string(long_string_transcript):

    loaded_model = load_model('data/alzheimer_detection_nnmodel.h5')
    tokenizer_filename = 'data/tokenizer.pkl'
    # Load the fitted tokenizer using pickle
    with open(tokenizer_filename, 'rb') as file:
        loaded_tokenizer = pickle.load(file)
    # Here you can process the long string as needed.
    # For this example, we will just return it as is.
    
    new_transcript = long_string_transcript
    new_transcript_seq = loaded_tokenizer.texts_to_sequences([new_transcript])
    new_transcript_padded = sequence.pad_sequences(new_transcript_seq, maxlen=100)

    predicted_prob = loaded_model.predict(new_transcript_padded, verbose = 0)[0][0]
    

    # Classify based on probability threshold (you can adjust this threshold as needed)
    threshold = 0.95
    if predicted_prob >= threshold:
        classification = 'AD'
        return 1
    else:
        classification = 'Non-AD'
        return 0


def main():
    if len(sys.argv) != 2:
        print("Usage: python pyscript.py <long_string_transcript>")
        sys.exit(1)

    long_string_transcript = sys.argv[1]
    result = process_long_string(long_string_transcript)
    print(result, end = "")

if __name__ == "__main__":
    main()
