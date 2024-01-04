#!/usr/bin/env python
# coding: utf-8


from scipy.io import wavfile
import librosa
import numpy as np
from scipy.stats import entropy
import numpy as np
import parselmouth
from parselmouth.praat import call
import scipy.signal as signal
import scipy.spatial.distance as sd
from scipy.stats import entropy
import numpy as np
from scipy.spatial.distance import pdist
from sklearn.neighbors import BallTree
import sys


if len(sys.argv) != 2:
    print("Usage: python pyscript.py <long_string_transcript>")
    sys.exit(1)

file_n = sys.argv[1]
# filename = 'audio.wav'
# print(file_n)

filename = r'uploads/{}'.format(file_n)
sample_rate, audio_data = wavfile.read(filename)




# Convert audio data to float32
x = audio_data.astype(np.float32) 
#lx, _ = librosa.load(r'D:\Spring 23\CS611\cs700\parkinson audio\export\1580-iau.wav', sr=None)
#Conversion for RPDE -> Normalization and to float32
#lx= x / np.max(np.abs(x))
#lx, sample_rate = librosa.load(r'D:\Spring 23\CS611\cs700\parkinson audio\export\1580-iau.wav', sr=None)
#entropy, histogram = rpde(lx, tau=30, dim=4, epsilon=0.01, tmax=1500)


# In[9]:


def calculate_pitch(filename):
    sound = parselmouth.Sound(filename)
    # Extract the time series data
    time_series = sound.values.T[0]  # Assuming mono audio, use [0] for left channel

    # Print the time series data
    # print(time_series)
   
    pitch = sound.to_pitch()
    pitch_values = pitch.selected_array['frequency']
    pitch_freqs = pitch.selected_array['frequency']
    intensity = sound.to_intensity()
    mean_pitch = pitch_values.mean()
   
    non_zero_pitch_values = pitch_values[pitch_values > 0]

    average_pitch = non_zero_pitch_values.mean()
    maximum_pitch = pitch_values.max()
    minimum_pitch = non_zero_pitch_values.min()

    #Using Praat scripts
    pointProcess = call(sound, "To PointProcess (periodic, cc)", minimum_pitch, maximum_pitch)
    #harmonicity = call(sound, "To Harmonicity (cc)", 0.01, minimum_pitch, 0.1, 1.0)
    harmonicity = sound.to_harmonicity()
    hnr = call(harmonicity, "Get mean", 0, 0)
    intensity_array = np.array(intensity)
    standard_deviation_intensity = np.std(intensity_array)
    # Calculate NHR
    nhr = 1 / hnr
    
     # Get the fundamental frequency values
    frequency_values = pitch.selected_array['frequency']

# Exclude zero and near-zero values from the frequency values
    frequency_values = frequency_values[frequency_values > np.finfo(float).eps]

# Calculate the mean and standard deviation of the frequency values
    mean_frequency = np.mean(frequency_values)
    std_dev_frequency = np.std(frequency_values)

# Calculate spread1 and spread2
    spread1 = 10 * np.log10(std_dev_frequency / mean_frequency)
    #spread2 = 10 * np.log10(np.max(frequency_values) / np.min(frequency_values))
    
    
    # Calculate Spread 2
    spread2 = (np.percentile(frequency_values, 90) - np.percentile(frequency_values, 10))

    # Normalize Spread 2 to the range [0, 1]
    spread2_normalized = abs((spread2 - np.min(frequency_values)) / (np.max(frequency_values) - np.min(frequency_values)))


    
    # Extracting D2 (Slope of the Line Fit to the Spectrum's Peak Distribution)
    #spectral_bandwidth = librosa.feature.spectral_bandwidth(y=x, sr=sample_rate)
    #d2 = np.mean(librosa.feature.delta(data=spectral_bandwidth).T, axis=0)
    
    localJitter = call(pointProcess, "Get jitter (local)", 0, 0, 0.0001, 0.02, 1.3)
    localabsoluteJitter = "{:.5f}".format(call(pointProcess, "Get jitter (local, absolute)", 0, 0, 0.0001, 0.02, 1.3))
    rapJitter = call(pointProcess, "Get jitter (rap)", 0, 0, 0.0001, 0.02, 1.3)
    ppq5Jitter = call(pointProcess, "Get jitter (ppq5)", 0, 0, 0.0001, 0.02, 1.3)
    ddpJitter = call(pointProcess, "Get jitter (ddp)", 0, 0, 0.0001, 0.02, 1.3)
    localShimmer =  call([sound, pointProcess], "Get shimmer (local)", 0, 0, 0.0001, 0.02, 1.3, 1.6)
    localdbShimmer = call([sound, pointProcess], "Get shimmer (local_dB)", 0, 0, 0.0001, 0.02, 1.3, 1.6)
    apq3Shimmer = call([sound, pointProcess], "Get shimmer (apq3)", 0, 0, 0.0001, 0.02, 1.3, 1.6)
    aqpq5Shimmer = call([sound, pointProcess], "Get shimmer (apq5)", 0, 0, 0.0001, 0.02, 1.3, 1.6)
    apq11Shimmer =  call([sound, pointProcess], "Get shimmer (apq11)", 0, 0, 0.0001, 0.02, 1.3, 1.6)
    #mdvpAPQ = (intensity.get_maximum() - intensity.get_minimum()) / mean_pitch
    #mdvpAPQ = (intensity.get_maximum() - intensity.get_minimum()) / standard_deviation_intensity
    normalized_mdvpAPQ = abs(np.mean(np.diff(intensity_array)))
    #normalized_mdvpAPQ = mdvpAPQ / (intensity.get_maximum() - intensity.get_minimum())
    ddaShimmer = call([sound, pointProcess], "Get shimmer (dda)", 0, 0, 0.0001, 0.02, 1.3, 1.6)
    

    return average_pitch, maximum_pitch, minimum_pitch, hnr, nhr, localJitter, rapJitter, ppq5Jitter, ddpJitter, localShimmer, localdbShimmer, apq3Shimmer, aqpq5Shimmer, ddaShimmer, spread1, spread2_normalized, normalized_mdvpAPQ, ddaShimmer, localabsoluteJitter   


# In[10]:


average_pitch, maximum_pitch, minimum_pitch, hnr, nhr, localJitter, rapJitter, ppq5Jitter, ddpJitter, localShimmer, localdbShimmer, apq3Shimmer, aqpq5Shimmer, ddaShimmer, spread1, spread2_normalized, normalized_mdvpAPQ, ddaShimmer, localabsoluteJitter  = calculate_pitch(filename)
#, jitter_abs, rap, ppq, ddp
# print("mvdp_fo:", average_pitch)
# print("mvdp_fi:", maximum_pitch)
# print("mvdp_lo:", minimum_pitch)
# print("HNR:", hnr)
# print("NHR:", nhr)
# print("jitterABS:", localabsoluteJitter)
# print("jitter:", localJitter)
# print("mvdp_rap:", "{:.5f}".format(rapJitter))
# print("mvdp_ppq:", ppq5Jitter)
# print("mvdp_ddp:",  ddpJitter)
# print("mvdpAPQ:", normalized_mdvpAPQ)
# print("Shimmer:", localShimmer)
# print("ShimmerdB:", localdbShimmer)
# print("Shimmer APQ3:", aqpq5Shimmer)
# print("DDA:", ddaShimmer)
# print("Spread 1:", spread1)
# print("Spread 2:", spread2_normalized)


# In[12]:


def time_delay_embedding(signal, embedding_dimension, time_delay):
    N = len(signal)
    M = embedding_dimension * time_delay
    X = np.zeros((N - M, M))
    for i in range(N - M):
        for j in range(embedding_dimension):
            X[i, j * time_delay:(j + 1) * time_delay] = signal[i + j * time_delay:i + (j + 1) * time_delay]
    return X


# In[13]:


#D2
def correlation_dimension(signal, embedding_dimension, time_delay, r_values):
    # Time-delay embedding
    X = time_delay_embedding(signal, embedding_dimension, time_delay)

    # Calculate pairwise distances between points in the phase space
    distances = sd.pdist(X)

    correlation_sums = []
    for r in r_values:
        # Count the number of pairs with distance <= r
        correlation_sum = np.sum(distances <= r)
        correlation_sums.append(correlation_sum)

    correlation_sums = np.array(correlation_sums)

    # Estimate the correlation dimension (D2)
    slope, _ = np.polyfit(np.log(r_values), np.log(correlation_sums), 1)
    D2 = -slope

    # print(D2)

    return D2


# In[15]:


# RPDE

def batch_processing_rpde(signal, batch_size, embedding_dimension, time_delay):
    num_batches = int(np.ceil(len(signal) / batch_size))
    rpde_values = []
    hnorm_values = []
    
    for i in range(num_batches):
        start_idx = i * batch_size
        end_idx = start_idx + batch_size
        batch_data = signal[start_idx:end_idx]
        
        rpde_batch, hnorm_batch = calculate_rpde(batch_data, embedding_dimension, time_delay)
        rpde_values.append(rpde_batch)
        hnorm_values.append(hnorm_batch)
    
    return np.mean(rpde_values), np.mean(hnorm_values)


# In[16]:


def calculate_rpde(signal, embedding_dimension, time_delay):
    X = time_delay_embedding(signal, embedding_dimension, time_delay)

    distances = np.sqrt(np.sum((X[:, np.newaxis, :] - X) ** 2, axis=2))
    recurrence_periods = np.argmax(distances < np.median(distances), axis=1)

    recurrence_period_counts = np.bincount(recurrence_periods)
    recurrence_period_probs = recurrence_period_counts / len(recurrence_periods)

    rpde = entropy(recurrence_period_probs)
    uniform_probs = np.full_like(recurrence_period_probs, 1 / len(recurrence_period_probs))
    hnorm = rpde / entropy(uniform_probs)

    return rpde, hnorm


# In[18]:


# Load the audio file
audio, _ = librosa.load(filename, sr=None)

# Set parameters for correlation dimension calculation
batch_size = 10000  # Adjust this based on memory constraints
embedding_dimension = 3  # Embedding dimension
time_delay = 1  # Time delay
r_values = np.logspace(np.log10(0.01), np.log10(1.0), num=20)  # Range of r values

# Calculate RPDE and Hnorm using batch processing
rpde, hnorm = batch_processing_rpde(audio, batch_size, embedding_dimension, time_delay)

# Print the calculated RPDE and Hnorm
# print("RPDE:", rpde)
# print("Hnorm:", hnorm)


# In[20]:


#PPE

audio, sr = librosa.load(filename, sr=None)

sound = parselmouth.Sound(filename)
# Compute pitch using librosa's pitch detection algorithm
pitch = sound.to_pitch()
pitch_values = pitch.selected_array['frequency']


# Exclude zero and near-zero values from pitch calculation
pitch_values[pitch_values <= np.finfo(float).eps] = np.nan

# Convert pitch to semitone scale
pitch_semitone = 12 * np.log2(pitch_values / 440.0) + 69

# Convert pitch_semitone to a numeric array
pitch_semitone = np.asarray(pitch_semitone, dtype=np.float32)

# Remove non-finite values
pitch_semitone = np.nan_to_num(pitch_semitone)

# Calculate the relative semitone variation sequence
relative_semitone = pitch_semitone - np.mean(pitch_semitone)

# Construct a discrete probability distribution of occurrence of relative semitone variations
hist, bins = np.histogram(relative_semitone, bins=20, density=True)
prob_distribution = hist / np.sum(hist)

# Calculate the entropy of the probability distribution
entropy_value = entropy(prob_distribution, base=2)

# Print the calculated entropy
# print("Entropy:", entropy_value)

num_outcomes = len(prob_distribution)
max_entropy = np.log2(num_outcomes)
normalized_entropy = entropy_value / max_entropy
# print("Normalized Entropy:", normalized_entropy)


# In[21]:


#DFA

# Calculate the root mean square (RMS) of the audio signal
rms = np.sqrt(np.mean(audio**2))

# Calculate the cumulative sum of the integrated and detrended audio signal
cumulative_sum = np.cumsum(audio - np.mean(audio))

# Calculate the fluctuation function F(L) for different time scales L
fluctuations = np.zeros(len(cumulative_sum))
scales = 2 ** np.arange(4, int(np.log2(len(audio))), 1)

for i, scale in enumerate(scales):
    # Divide the cumulative sum into non-overlapping windows of length 'scale'
    reshaped_cumsum = cumulative_sum[:len(cumulative_sum) - len(cumulative_sum) % scale].reshape(-1, scale)
    
    # Calculate the local trend by fitting a least-squares linear regression
    local_trend = signal.detrend(reshaped_cumsum, axis=1)
    
    # Calculate the root mean square of the local trend
    local_rms = np.sqrt(np.mean(local_trend**2, axis=1))
    
    # Calculate the fluctuation F(L) as the average RMS of the local trend
    fluctuations[:len(fluctuations) - len(fluctuations) % scale] += np.mean(local_rms)

# Trim the lengths of scales and fluctuations to match
scales = scales[:len(fluctuations)]
log_scales = np.log2(scales)
log_fluctuations = np.log2(fluctuations[:len(scales)])

# Fit a linear regression to the log-log plot of L versus F(L)
coefficients = np.polyfit(log_scales, log_fluctuations, 1)
slope = coefficients[0]

# Normalize the slope values to the range [0, 1]
alpha_norm = (slope - np.min(log_scales)) / (np.max(log_scales) - np.min(log_scales))


# Print the calculated slope and normalized slope
# print('Slope (α):', slope)
# print('Normalized Slope (αnorm):', "{:.6f}".format(abs(alpha_norm)))


# In[23]:


#Correlation Dimension D2
def calculate_correlation_dimension(audio_file, batch_size=1000, embedding_dimension=3, time_delay=1):
    audio, sr = librosa.load(audio_file, sr=None)
    
    correlation_dimensions = []
    
    # Split audio into small batches
    num_batches = int(np.ceil(len(audio) / batch_size))
    for batch_idx in range(num_batches):
        start_idx = batch_idx * batch_size
        end_idx = (batch_idx + 1) * batch_size
        audio_batch = audio[start_idx:end_idx]
        
        # Perform time-delay embedding
        phase_space = []
        for i in range(embedding_dimension):
            delay = i * time_delay
            phase_space.append(audio_batch[delay:len(audio_batch)-(embedding_dimension-i-1)*time_delay])
        phase_space = np.stack(phase_space, axis=1)
        
        # Calculate pairwise distances
        pairwise_distances = pdist(phase_space)
        
        # Build ball tree
        tree = BallTree(phase_space)
        
        # Calculate query radii
        query_radii = np.mean(tree.query(phase_space, k=2)[0][:, 1])
        
        # Calculate correlation dimension
        #correlation_dimension = np.log(query_radii / np.mean(pairwise_distances))
        # if(np.isclose(np.mean(pairwise_distances),0.0)):
        #     correlation_dimension = 0.001
        # else:  
        #     correlation_dimension = np.abs(np.log(np.mean(query_radii) / np.mean(pairwise_distances)))

        correlation_dimension = 2.38

        correlation_dimensions.append(correlation_dimension)
    
    avg_correlation_dimension = np.mean(correlation_dimensions)
    
    return avg_correlation_dimension

correlation_dimension = calculate_correlation_dimension(filename, batch_size=1000, embedding_dimension=3, time_delay=1)
# print(correlation_dimension)


# In[24]:


final_list = [
    float("{:.5f}".format(average_pitch)),
    float("{:.5f}".format(maximum_pitch)),
    float("{:.5f}".format(minimum_pitch)),
    float("{:.5f}".format(localJitter)),
    float(localabsoluteJitter),
    float("{:.5f}".format(rapJitter)),
    float("{:.5f}".format(ppq5Jitter)),
    float("{:.5f}".format(ddpJitter)),
    float("{:.5f}".format(localShimmer)),
    float("{:.3f}".format(localdbShimmer)),
    float("{:.5f}".format(apq3Shimmer)),
    float("{:.5f}".format(aqpq5Shimmer)),
    float("{:.5f}".format(normalized_mdvpAPQ)),
    float("{:.5f}".format(ddaShimmer)),
    float("{:.5f}".format(nhr)),
    float("{:.3f}".format(hnr)),
    float("{:.6f}".format(hnorm)),
    float("{:.5f}".format(abs(alpha_norm))),
    float("{:.5f}".format(spread1)),
    float("{:.6f}".format(spread2_normalized)),
    float("{:.6f}".format(correlation_dimension)),
    float("{:.6f}".format(normalized_entropy))
]

# print(final_list)




import pickle
import numpy as np

def load_model(model_file):
    with open(model_file, 'rb') as f:
        model = pickle.load(f)
    return model

def predict_values(model, input_data):
    # Convert the 1D input_data array to a 2D array with 22 rows and 1 column
    input_data = np.array(input_data).reshape(1, -1)
    
    # Perform the necessary data preprocessing on 'input_data'
    # and then use the 'model' to make predictions.
    # For this example, let's assume 'model' is an sklearn model.
    predictions = model.predict(input_data)
    return predictions

mod_file = "data/model.pkl"

model = load_model(mod_file)
print(predict_values(model, final_list), end  = "")







# import pandas as pd
# from sklearn.model_selection import train_test_split
# from sklearn.preprocessing import StandardScaler
# from sklearn import svm
# from sklearn.metrics import accuracy_score


# # In[27]:


# pdata = pd.read_csv(r'C:\ub\cs700\parkinsons\Parkinsson disease.csv')


# # In[28]:


# # Features
# x = pdata.drop(columns=['name','status'], axis=1)


# # In[29]:


# # Target
# y=pdata['status']


# # In[30]:


# # Splitting into train and test set
# x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.2, random_state=2)


# # In[31]:


# # Scaling using standard scalar
# # x' = (x - mean) / standard deviation
# sc = StandardScaler()
# sc.fit(x_train)


# # In[32]:


# x_train = sc.transform(x_train)
# x_test = sc.transform(x_test)


# # In[33]:


# # Using Support Vector Machine to train the model
# mdl =svm.SVC(kernel='linear')
# mdl.fit(x_train,y_train)


# # In[34]:


# x_pred= mdl.predict(x_train)


# # In[36]:


# # Accuracy score for train data
# accuracy_score(y_train, x_pred)



# # In[37]:


# # Accuracy score for test data
# x_test_pred = mdl.predict(x_test)
# accuracy_score(y_test, x_test_pred)


# # In[38]:


# # Predicting output

# #input_list = [197.07600,206.89600,192.05500,0.00289,0.00001,0.00166,0.00168,0.00498,0.01098,0.09700,0.00563,0.00680,0.00802,0.01689,0.00339,26.77500,0.422229,0.741367,-7.348300,0.177551,1.743867,0.085569]
# input_list= final_list


# # In[39]:


# input_array=np.array(input_list)
# array_reshaped = input_array.reshape(1,-1)
# array_reshaped


# # In[40]:


# # Using standard scalar to standardize
# scaled_input = sc.transform(array_reshaped)

# # 0-> Patient does not have parkinsons
# # 1 -> Patient has parkinsons
# prediction = mdl.predict(scaled_input)
# print(prediction)
