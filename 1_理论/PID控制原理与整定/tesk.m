%% 一阶系统 + PI 控制器 (零极点对消设计)
clear; clc; close all;

%% 1. 参数设置
T = 0.5;        % 系统时间常数 (秒)
omega_b = 10;   % 期望闭环带宽 (rad/s)

%% 2. 控制器设计 (零极点对消)
Ki = omega_b;           % 积分增益
Kp = Ki * T;            % 比例增益

fprintf('Kp = %.2f, Ki = %.2f\n', Kp, Ki);

%% 3. 构建系统
s = tf('s');
G = 1 / (T*s + 1);              % 被控对象
G_PI = Kp + Ki/s;               % PI控制器
L = G_PI * G;                   % 开环传递函数
T_cl = feedback(L, 1);          % 闭环传递函数
T_ideal = Ki / (s + Ki);        % 理想闭环 (零极点对消后)

%% 4. 时域验证 (阶跃响应)
figure(1);
step(T_cl, T_ideal, 'r--');
grid on;
title('单位阶跃响应');
legend('实际闭环', '理想闭环', 'Location', 'southeast');

%% 5. 频域验证 (带宽)
figure(2);
bode(T_cl);
grid on;
title('闭环Bode图');

% 测量-3dB带宽
[mag, ~, w] = bode(T_cl);
mag_db = 20*log10(squeeze(mag));
bw = interp1(mag_db, w, -3, 'linear');
fprintf('实际带宽 = %.2f rad/s (目标 = %.2f rad/s)\n', bw, omega_b);