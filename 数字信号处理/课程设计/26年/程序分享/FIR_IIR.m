%% ==================================================
%  基于 FIR / IIR 多带阻滤波器的语音去噪实验
%  fs = 22050 Hz
% made by Ben_awa
% ==================================================

clear; clc; close all;

%% 1. 读取音频
[x, fs] = audioread('C:/Users/Ben_awa/Desktop/design/noisysound.wav');

N = length(x);
t = (0:N-1)/fs;

%% 2. 带阻频段设计（根据频谱经验）
% 每个带阻：[f1 f2]

bands = [6735 6775;7865 7895;5600 5645;5265 5325;4802 4803;
         4490 4518;4210 4260;3567 3583;3357 3400;3153 3205;
         2656 2664;2395 2405;2245 2260;2111 2130;2059 2060;
         1907 1908;1743 1800;1035 1130;977 989;952 954;
         940 943;880 881;787 791;657 658;587 589;
         550 555;485 487;440 442;434 436;392 393;
         312 316;290 292;278 280;234 235;217 218;
         193 194;179 181];

%% 3. IIR带阻滤波器
x_iir = x; % 初始化
for i = 1:size(bands,1)
    f1 = bands(i,1);
    f2 = bands(i,2);

    % 自动排序
    f_low  = min(f1,f2);
    f_high = max(f1,f2);

    % 防止越界
    f_low  = max(f_low,  100);
    f_high = min(f_high, fs/2 - 100);

    Wp = [f_low f_high] / (fs/2);
    Ws = [f_low-100 f_high+100] / (fs/2);  % 阻带起始频率（数字角频率，rad/sample）

    if Ws(1) >= Wp(1) || Ws(2) <= Wp(2)
        continue;
    end

    [n, Wn] = buttord(Wp, Ws, 1, 40);
    [b,a] = butter(n, Wn, 'stop');

    x_iir = filter(b,a,x_iir);
end

%% ==================================================
%  4. 基于卷积运算的 FIR 滑动平均滤波器
% ==================================================
N_window = 5;                                %窗口长度(为奇数）
        
F_average = 1/N_window*ones(1,N_window);     % 构建卷积核
x_fir = conv(x,F_average,'same');            %利用卷积的方法计算


%% ==================================================
%  5. 时域对比
% ==================================================
figure('Color','w')
subplot(3,1,1)
plot(t,x)
title('原始含噪语音')

subplot(3,1,2)
plot(t,x_iir)
title('IIR 多带阻滤波后')

subplot(3,1,3)
plot(t,x_fir)
title('FIR 基于卷积运算滤波后')

%% ==================================================
%  6. 频域对比
% ==================================================
f_axis = (0:N-1)*(fs/N);

X  = fft(x);
XI = fft(x_iir);
XF = fft(x_fir);

figure('Color','w')
subplot(1,2,1)
plot(f_axis, abs(X),'k',...
     f_axis, abs(XI),'r')
xlim([0 11025])
legend('原始','IIR 多带阻')
title('频谱对比')
xlabel('Frequency (Hz)')
ylabel('Magnitude')

subplot(1,2,2)
plot(f_axis, abs(X),'k',...
     f_axis, abs(XF),'b')
xlim([0 11025])
legend('原始','FIR 卷积滤波')
title('频谱对比')
xlabel('Frequency (Hz)')
ylabel('Magnitude')
grid on

%% ==================================================
%  7. 音频回放
% ==================================================
disp('播放：原始音频')
sound(x, fs)
pause(length(x)/fs + 1)

disp('播放：IIR 多带阻')
sound(x_iir, fs)
pause(length(x)/fs + 1)

disp('播放：FIR 卷积')
sound(x_fir, fs)
pause(length(x)/fs + 1)

%% ==================================================
%  8. 保存结果
% ===================================================
audiowrite('FIR滤波后音频.wav', x_fir, fs);
audiowrite('IIR滤波后音频.wav', x_iir, fs);

disp('✅ 滤波完成，音频已保存')