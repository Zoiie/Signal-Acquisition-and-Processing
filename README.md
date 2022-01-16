```matlab
# SAP – Signal Acquisition and Processing


Project description

The project is structured in three parts:

Part I: generate a full scale consisting of 12 semitones

For the first part of our project, we are asked to generate a range of music, starting from note La3 at 440 Hz. To do that, we can address the following steps:

• Start from 𝑓0=440 𝐻𝑧 and multiply this frequency by r = 1.05946 to go to the next frequency (semitone),
• Generate the full scale made up of 12 semitones, each of duration equal to few hundreds of 𝑚𝑠, and listen to the signal,
• Up / down two ranges,
• Play two consecutive scales with both hands, ...

Matlab plays music by the sound (Y, fs, bits) function. The three parameters of this function represent the input signal, sampling rate, and bit rate. Let me talk about the setting of the sampling rate fs, the sound range that the human ear can hear is 20 ~ 20000Hz. According to the sampling theorem, fs only needs to be greater than 40,000. The sampling rate is set here using the MP3 standard, that is, fs = 44.1k. Besides, the input signal Y, Y is generally a sine wave, such as A \* sin (2 \* pi \* w \* t). Among them, A controls the size of the sound, w controls the level of the sound, and the range of t controls the length of the sound. Therefore, in theory, any sound can be produced using this formula, but the tone and quality cannot be controlled. The default bit rate is sufficient, and this parameter is omitted.

Therefore, the standard sound la can be played using the following formula:

fs=44100;
t=0: 1/fs: 0.5;
la = sin(2\*pi\*440\*t);
sound(la, fs)
Based on the above, we can get all the tones of the piano.
clc
clear

fs=44100;
t=0:1/fs:0.5;
c4\_2=key(60, 2, fs); %make 12 semitones
cup4\_2=key(61, 2, fs);
d4\_2=key(62, 2, fs);
dup4\_2=key(63, 2, fs);
e4\_2=key(64, 2, fs);
f4\_2=key(65, 2, fs);
fup4\_2=key(66, 2, fs);
g4\_2=key(67, 2, fs);
gup4\_2=key(68, 2, fs);
a4\_2=key(69, 2, fs);
aup4\_2=key(70, 2, fs);
b4\_2=key(71, 2, fs);

part1=[c4\_2 cup4\_2]; % Make two consecutive scales into a group
part2=[d4\_2 dup4\_2];
part3=[e4\_2 f4\_2];
part4=[fup4\_2 g4\_2];
part5=[gup4\_2 a4\_2];
part6=[aup4\_2 b4\_2]

legend1=[part1];

sound(legend1,fs) % Play two consecutive scales

function g=key(p, n, fs)
t=0 : 1/fs : 2/n;
g=sin(2\*pi\* fre(p) \*t);
end

function f = fre(p)
f=440\*2^((p-69)/12);
end

Part II: transcript the music notes from some audio input recording

This part aims to transcript piano music at the basic level. That is, one note is played at a certain time. The piano audio samples provided come from a real source (piano recording), therefore the audio file itself is not perfectly sound in tune. Some of the problems needed to solve are overtone analysis, noise reduction and frequency separation.

Fast Fourier Transform (spectrogram) or wavelet analysis (scalogram) should be used for time-frequency analysis (a good explanation of these two analysis methods can be found at: http://mudasir.hubpages.com/hub/wavelets1).

For example, using Matlab, we will be able to create a spectrogram/scalogram of the audio signal.

HINT: we may need to perform low-pass filtering before the time-frequency analysis.

we will need to write algorithms for frequency quantization and de-noising, and finally plot the extracted notes against their duration. In Figure 5 we have an example of such transcription obtained for the sample audio file _piano.wav._



Note/time transcription obtained for the audio file &quot;Piano.wav&quot;.

Perform spectrum analysis (take ech1 as an example)

clear sound
[audio, fs] = audioread (&#39;ech1.wav&#39;);% sound readin
audio = audio (:, 1);% dual channel to single channel

n = length (audio);
T = 1 / fs;% sampling interval
t = (0: n-1) \* T;% time axis
f = (0: n-1) / n \* fs;% frequency axis

% Fast Fourier Transform
audio\_fft = fft (audio, n) \* T;
% sound (audio, fs);
% Design IIR low-pass filter

rp = 1;
rs = 60;
Ft = fs;
Fp = 250;
Fs = 500;
wp = 2 \* pi \* Fp / Ft;
ws = 2 \* pi \* Fs / Ft;% find the boundary frequency of the analog filter to be designed

[N, wn] = buttord (wp, ws, rp, rs, &#39;s&#39;);% low-pass filter order and cutoff frequency
[b, a] = butter (N, wn, &#39;s&#39;); %The parameters of the frequency response in the% S domain are: the transfer function of the filter

[bz, az] = bilinear (b, a, 0.5);% Using bilinear transformation to realize the transformation from frequency domain S domain to Z domain

figure (2);% low-pass filter characteristics
[h, w] = freqz (bz, az);
title (&#39;IIR low-pass filter&#39;);
plot (w \* fs / (2 \* pi), abs (h));
grid;

% Filtering

z = filter (bz, az, s);
z\_fft = fft (z);% filtered signal spectrum
figure (1);

% Draw the original audio time-domain wave

subplot (2,3,1);
plot (t, audio);
xlabel (&#39;time / s&#39;);
ylabel (&#39;amplitude&#39;);
title (&#39;Initial signal waveform&#39;);
grid;

% Draw the original audio frequency domain spectrum

subplot (2,3,4);
audiof = abs (audio\_fft);
plot (f (1: (n-1) / 2), audiof (1: (n-1) / 2));
title (&#39;Initial signal spectrum&#39;);
xlabel (&#39;frequency / Hz&#39;);
ylabel (&#39;amplitude&#39;);
grid;

% Plot the filtered audio time-domain wave

subplot (2,3,3);
plot (t, z);
title (&#39;Low-pass filtered signal waveform&#39;);
xlabel (&#39;time / s&#39;);
ylabel (&#39;amplitude&#39;);
grid;

% Plot the filtered audio frequency wave

subplot (2,3,6);
zf = abs (z\_fft);
plot (f (1: (n-1) / 2), zf (1: (n-1) / 2));
title (&#39;Spectrum of low-pass filtered signal&#39;);
xlabel (&#39;frequency / Hz&#39;);
ylabel (&#39;amplitude&#39;);

y = z;
% info = audioinfo (&#39;ech1.wav&#39;);% get the audio format, number of bits, frequency, etc.
% sound (y, fs);
T = 1 / fs;% sampling time
t = (0: length (y) -1) \* T;% time
f = (0: length (y) -1) \* fs / length (y);
yz = y (:, 1);% left channel
n = length (yz);% points to transform
y1 = fft (yz, n);% Fourier transform n points to frequency domain
F = fs / length (yz);% spectral resolution, spectral interval
grid on
figure (2)
subplot (211);

Pyy = y1 (1: 1100 + 1);% according to the way of processing vector to get the range of the required sound signal
f = (1: 1100 + 1);

plot (f, 20 \* log10 (abs (Pyy)))% energy spectrum
xlabel (&#39;Frequency (Hz)&#39;)
ylabel (&#39;Power (dB)&#39;)
subplot (212)
bar (f, abs (Pyy))% energy graph

![](RackMultipart20220116-4-1h3fgu7_html_9297e6d48e27f34e.png)

LPF

The cutoff frequency is around 200 Hz.

![](RackMultipart20220116-4-1h3fgu7_html_1550a1ac2c15c391.png)

The filtering effect is very obvious.

![](RackMultipart20220116-4-1h3fgu7_html_e7e44a88f1c43faf.png)

According to the way of processing vector to get the range of the required sound signal
Time-frequency analysis of audio after noise reduction (base on &quot;piano.wav&quot;)

clear sound

timestart = 0;

[audio, fs] = audioread (&#39;ech7.wav&#39;);% sound reading
audio = audio (:, 1);% dual channel to single channel
n = length (audio);

T = 1 / fs;% sampling interval
t = (0: n-1) \* T;% time axis
f = (0: n-1) / n \* fs;% frequency axis

% Fast Fourier Transform

audio\_fft = fft (audio, n) \* T;
timeend = t;
wlen = 20480;% sets the window length. The longer the window, the worse the resolution, and the better the frequency resolution.
hop = 2000;% The step size of each translation, the minimum is 1. The smaller the image, the better the time accuracy, but the amount of calculation is large.
audio\_fft = wkeep1 (audio\_fft, n + 1 \* wlen);% intermediate truncation

% Design IIR low-pass filter

rp = 1;
rs = 60;
Ft = fs;
Fp = 500;
Fs = 900;
wp = 2 \* pi \* Fp / Ft;
ws = 2 \* pi \* Fs / Ft;% find the boundary frequency of the analog filter to be designed

[N, wn] = buttord (wp, ws, rp, rs, &#39;s&#39;);% low-pass filter order and cutoff frequency
[b, a] = butter (N, wn, &#39;s&#39;); %The parameters of the frequency response in the S domain are: the transfer function of the filter
[bz, az] = bilinear (b, a, 0.5);% Using bilinear transformation to realize the transformation from frequency domain S domain to Z domain

figure (2);% low-pass filter characteristics

[h, w] = freqz (bz, az);
title (&#39;IIR low-pass filter&#39;);
plot (w \* fs / (2 \* pi), abs (h));
grid;

% In order to make the sound without high-frequency noise in the subsequent processing, I designed a high-pass filter and added it behind the low-pass filter.

% Design IIR high-pass filter

Fp = 150;
Fs1 = 240;
Ft = fs;
As = 100;
Ap = 1;
wp = 2 \* pi \* Fp / Ft;
ws = 2 \* pi \* Fs1 / Ft;

[n, wn] = ellipord (wp, ws, Ap, As, &#39;s&#39;);
[b, a] = ellip (n, Ap, As, wn, &#39;high&#39;, &#39;s&#39;);
[B, A] = bilinear (b, a, 1);
[h, w] = freqz (B, A);

figure (4);
plot (w \* Ft / pi / 2, abs (h));
title (&#39;IIR high-pass filter&#39;);
xlabel (&#39;frequency&#39;);
ylabel (&#39;amplitude&#39;);
grid on;

% Filtering

z = filter (bz, az, audio);
z = filter (B, A, z);
z\_fft = fft (z);% filtered signal spectrum

audiowrite(&#39;ech7\_filter.wav&#39;,z,fs);
sound (z, fs);% playback

% Do Short Time Fourier
h = hamming (wlen);% set the window length of Hamming window
f = 220: 1: 500;% set frequency scale
[tfr2, f, t2] = spectrogram (z, h, wlen-hop, f, fs, &#39;MinThreshold&#39;,-1000, &#39;reassigned&#39;, &#39;yaxis&#39;);% spectrum

axis xy;
tfr2 = tfr2 \* 2 / wlen \* 2;
figure

imagesc (t2 + timestart-wlen / fs / 2, f, abs (tfr2))% change of each frequency
shi = abs (tfr2);
clims = [50 100];
shi = shi.\* 10000;
shi (shi \&lt;3800) = 0;

plot (shi&#39;);
imagesc (t2 + timestart-wlen / fs / 2, f, shi, clims);
axis xy;
set (gca, &#39;ytick&#39;, [262 277 294 311 330 349 370 392 415 440 466 494]);
set (gca, &#39;yticklabel&#39;, {&#39;C&#39;, &#39;C#&#39;, &#39;D&#39;, &#39;D#&#39;, &#39;E&#39;, &#39;F&#39;, &#39;F#&#39;, &#39;G&#39;, &#39;G#&#39;, &#39;A&#39;, &#39; A # &#39;,&#39; B &#39;});% annotation

![](RackMultipart20220116-4-1h3fgu7_html_9809ac5b2bd21b11.png)

HPF

The cutoff frequency is around 650.

![](RackMultipart20220116-4-1h3fgu7_html_5f5fb81c4baa5de.png)

Time-frequency

![](RackMultipart20220116-4-1h3fgu7_html_4c8ba98dd8d6332d.png)

Energy curve with frequency varying with time (after multiplying 10000)
According to the curve, the maximum value of the energy at each frequency is obtained. Their maximum value is the frequency corresponding to the note.

![](RackMultipart20220116-4-1h3fgu7_html_e791f49560ce579d.png)

Piano sheet music

The yellow area in the figure is the note corresponding to the sound played by the piano keys. The size of the area reflects the strength of the sound and the range of overtones.
Compared with the shortcomings that the overtone can not be displayed in the example, this can express the characteristics of the piano sound more.
According to part1, we can get all the simulated keys sound.
Add a command on the basis of Part1 to convert the analog signal into a sound file and store it.

audiowrite(&#39;z.wav&#39;,legend1,fs);

Put this file in the Part2 program for analysis to get its sound score.
As shown in the figure, they can hardly make overtones, and after a delay, the sound will not change.

![](RackMultipart20220116-4-1h3fgu7_html_bbfcaa2b2964c55a.png)

From C to B (simulation sound)

More examples

![](RackMultipart20220116-4-1h3fgu7_html_abba0eda6ce9cab5.png)

ech25

![](RackMultipart20220116-4-1h3fgu7_html_ce61baa969104d06.png)

ech15

![](RackMultipart20220116-4-1h3fgu7_html_d8a042ea456fb0c4.png)

ech7

**Part III: watermark the audio input with some text information**

Once the notes are extracted, propose a method for inaudibly inserting a text message (for example, the name of the project developer) within the wav file. Therefore, in this part we are requested to perform the watermarking (either by LBS, or frequency-based) of our wav file. Finally, and if we still have time, estimate the SNR after the watermarking and propose some directions for improving it [1,2].

First, I wrote a program to measure the signal-to-noise ratio to check whether the SNR has changed after modifying the audio file. (Take ech7 as an example)

%Test program

[X, fs] = audioread (&#39;ech7\_filter.wav&#39;);
[Y, NOISE] = noisegen (X, 10);
mn = mean (NOISE);
snr = SNR\_singlech (X, Y)

function snr = SNR\_singlech (I, In)
% Calculate the signal to noise ratio function
% I: original signal
% In: noisy signal (ie. Original signal + noise signal)
snr = 0;
Ps = sum (sum ((I-mean (mean (I))). ^ 2));% signal power
Pn = sum (sum ((I-In). ^ 2));% noise power
snr = 10 \* log10 (Ps / Pn);
end

function [Y, NOISE] = noisegen (X, SNR)
% noisegen add white Gaussian noise to a signal.
% [Y, NOISE] = NOISEGEN (X, SNR) adds white Gaussian NOISE to X. The SNR is in dB.
NOISE = randn (size (X));
NOISE = NOISE-mean (NOISE);
signal\_power = 1 / length (X) \* sum (X. \* X);
noise\_variance = signal\_power / (10 ^ (SNR / 10));
NOISE = sqrt (noise\_variance) / std (NOISE) \* NOISE;
Y = X + NOISE;
end

Result:

![](RackMultipart20220116-4-1h3fgu7_html_66011452482bbb65.png)

In matlab, we can edit the header information of the file to add a watermark. This is actually a frequency-based method. The voice signal is decomposed into time-domain waveforms or frequency-domain graphics. For example, the spectrogram generated by Fourier transform. Restore them to the specified audio format, which can be mp3, wav and other audio formats, this is the reverse conversion process. Here, I still restore to wav file. Use the audio writing function to restore the processed sound frequency to sound and store it. We modify its header information will not affect the original sound signal.

[y,fs1]=audioread(&#39;ech7\_filter.wav&#39;);
audioinfo(&#39;ech7\_filter.wav&#39;)
audiowrite(&#39;ech7\_filter\_watermark2.wav&#39;,y,fs1,&#39;BitsPerSample&#39;,16,&#39;Comment&#39;,&#39;This is my new audio file.&#39;,&#39;Title&#39;,&#39;Final&#39;,&#39;Artist&#39;,&#39;zhouyu&#39;);
sound(y,fs1);
audioinfo(&#39;ech7\_filter\_watermark2.wav&#39;)

Result:

![](RackMultipart20220116-4-1h3fgu7_html_2d94adab85a550d5.png)

Test its signal-to-noise ratio:

![](RackMultipart20220116-4-1h3fgu7_html_3bae636e493695a8.png)

Based on the results above, it seems that I changed the &#39;comment&#39; &#39;artist&#39; &#39;title&#39; of the file, and neither the SNR nor &#39;totalsamples&#39; of the sound changed. The effect met expectations and performed very well.

References

[1][https://blog.csdn.net/haoji007/article/details/81155482?utm\_medium=distribute.pc\_relevant.none-task-blog-baidujs-6](https://blog.csdn.net/haoji007/article/details/81155482?utm_medium=distribute.pc_relevant.none-task-blog-baidujs-6)

[2][https://www.mathworks.com/help/matlab/](https://www.mathworks.com/help/matlab/)

[3][https://blog.csdn.net/qq\_36836639/article/details/78662613?utm\_medium=distribute.pc\_relevant.none-task-blog-baidujs-3](https://blog.csdn.net/qq_36836639/article/details/78662613?utm_medium=distribute.pc_relevant.none-task-blog-baidujs-3)

[4] [https://mathworld.wolfram.com/FourierTransform.html](https://mathworld.wolfram.com/FourierTransform.html)

[5][https://www.mathworks.com/help/aerotbx/ug/convmass.html](https://www.mathworks.com/help/aerotbx/ug/convmass.html)

[6][https://blog.csdn.net/qq\_33438733/article/details/79324763?ops\_request\_misc=%257B%2522request%255Fid%2522%253A%2522159066430719725219960349%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&amp;request\_id=159066430719725219960349&amp;biz\_id=0&amp;utm\_medium=distribute.pc\_search\_result.none-task-blog-2~all~first\_rank\_ecpm\_v3~pc\_rank\_v3-3-79324763.first\_rank\_ecpm\_v3\_pc\_rank\_v3&amp;utm\_term=matlab+%E7%94%A8LBS%E5%A4%84%E7%90%86%E5%A3%B0%E9%9F%B3](https://blog.csdn.net/qq_33438733/article/details/79324763?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522159066430719725219960349%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&amp;request_id=159066430719725219960349&amp;biz_id=0&amp;utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v3~pc_rank_v3-3-79324763.first_rank_ecpm_v3_pc_rank_v3&amp;utm_term=matlab+%E7%94%A8LBS%E5%A4%84%E7%90%86%E5%A3%B0%E9%9F%B3)
```