% 初始观察音频时域&频域程序
% writen by Ben_awa --- 2026.5.13
clear; clc; close all;

[y, fs] = audioread('C:/Users/Ben_awa/Desktop/design/noisysound.wav');

N = length(y);
t = (0:N-1)/fs;

disp(['采样率 fs = ', num2str(fs)]);
disp(['采样点数 N = ', num2str(length(y))]);
disp(['时长 = ', num2str(length(y)/fs), ' s']);
% 采样率 fs = 22050
% 采样点数 N = 424334
% 时长 = 19.2442 s

% 画时域图
figure(1)
plot(t, y);
xlabel('Time (s)');
ylabel('Amplitude');
title('原始音频时域波形');
grid on

%画频域图
k = 0:N-1;
f = k * fs / N;

figure(2)
plot(f, abs(fft(y)))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('原始音频频域波形')
xlim([0 fs/2])
grid on