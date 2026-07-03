clear; clc; close all;

wn = 5;          % 自然频率 (注释写10，实际用5)
zeta = 0.4;      % 阻尼比
tau = 0.5;       % 一阶系统时间常数

sys_1 = tf(1, [tau, 1]);                 % 一阶惯性环节
sys_2 = tf(wn^2, [1, 2*zeta*wn, wn^2]);  % 二阶振荡环节

% 绘制Bode图，频率范围 0.1 ~ 1000 rad/s
bode(sys_1, sys_2, {0.1, 1000});
grid on;  % 开启网格

legend('一阶系统 (1/(τs+1))', '二阶系统 (ω_n^2/(s^2+2ζω_n s+ω_n^2))', ...
       'Location', 'best');