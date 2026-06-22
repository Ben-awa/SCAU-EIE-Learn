% 华南农业大学数字信号处理课程设计
% 选题2
% 基于 FIR / IIR 多带阻滤波器的语音去噪实验
% ✈️enhance1✈️
% 本程序基于利用最小均方（MAD）算法对滤波器权系数进行在线更新，
% 以自适应滤波器通过时域层面对音频进行处理，得到了显著成效
% writen by Ben_awa ----- 2026.5.14

clear; clc; close all;

%% 1. 读取音频
[x, fs] = audioread('C:/Users/Ben_awa/Desktop/design/noisysound.wav');

N = length(x);
t = (0:N-1)/fs;

%% 2. MAD法
% 基于MAD法对离群值进行删除
Ri = randi(length(t),4,1);
x2 = x;
x2(Ri) = x(Ri)*3;
x_MAD = filloutliers(x2,'linear','movmedian',11);

%% 3.
% 时域对比

figure('Color','w')
subplot(3,1,1)
plot(t,x)
title('原始含噪语音')

subplot(3,1,2)
YL = ylim;
plot(t,x_MAD)
ylim(YL)
title('采用MAD滤波后语音')

%% 4.
% 频域对比
f_axis = (0:N-1)*(fs/N);

X  = fft(x);
X_MAD = fft(x_MAD);

figure('Color','w')
plot(f_axis, abs(X),'k',...
     f_axis, abs(X_MAD),'r')

xlim([0 fs/2])
legend('原始','MAD滤波')
title('频谱对比')
xlabel('Frequency (Hz)')
ylabel('Magnitude')
grid on

%% ==================================================
%  5. 音频回放
% ==================================================
disp('播放：原始音频')
sound(x, fs)
pause(length(x)/fs + 1)

disp('播放：MAD法')
sound(x_MAD, fs)
pause(length(x)/fs + 1)

%% ==================================================
%  6. 保存结果
% ===================================================
audiowrite('MAD滤波后音频.wav', x_MAD, fs);

disp('✅ 滤波完成，音频已保存')