s = tf('s');
G1 = 1/(s+1);
G2 = 10/(s*(s+1));
G3 = 100/((6*s+1)*(8*s+1));

G1_cl = feedback(G1, 1);
G2_cl = feedback(G2, 1);
G3_cl = feedback(G3, 1);

bw1 = bandwidth(G1_cl);
bw2 = bandwidth(G2_cl);
bw3 = bandwidth(G3_cl);

fprintf('G1 BW = %.2f rad/s\n', bw1);
fprintf('G2 BW = %.2f rad/s\n', bw2);
fprintf('G3 BW = %.2f rad/s\n', bw3);

figure;
bode(G1_cl, G2_cl, G3_cl, {1e-2, 1e3});
grid on;
title('闭环系统伯德图及带宽标注');

% 获取幅值图
ax_all = findall(gcf, 'Type', 'axes');
ax_mag = ax_all(2);
axes(ax_mag);
hold on;

% -3dB 参考线
yline(-3, 'k--', '-3dB', 'LineWidth', 1.5);

% 获取幅值数据，找到带宽点
[mag1, ~, w1] = bode(G1_cl, {1e-2, 1e3});
[mag2, ~, w2] = bode(G2_cl, {1e-2, 1e3});
[mag3, ~, w3] = bode(G3_cl, {1e-2, 1e3});

mag1_db = 20*log10(squeeze(mag1));
mag2_db = 20*log10(squeeze(mag2));
mag3_db = 20*log10(squeeze(mag3));
w1 = squeeze(w1);
w2 = squeeze(w2);
w3 = squeeze(w3);

% 找 -3dB 穿越点
[~, idx1] = min(abs(mag1_db - (-3)));
[~, idx2] = min(abs(mag2_db - (-3)));
[~, idx3] = min(abs(mag3_db - (-3)));

% 画带宽点
plot(w1(idx1), mag1_db(idx1), 'bo', 'MarkerSize', 10, 'LineWidth', 2);
plot(w2(idx2), mag2_db(idx2), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
plot(w3(idx3), mag3_db(idx3), 'go', 'MarkerSize', 10, 'LineWidth', 2);

% 标注带宽数值
text(w1(idx1)*1.5, mag1_db(idx1), sprintf('BW=%.2f', bw1), 'Color', 'b', 'FontSize', 10);
text(w2(idx2)*1.5, mag2_db(idx2), sprintf('BW=%.2f', bw2), 'Color', 'r', 'FontSize', 10);
text(w3(idx3)*1.5, mag3_db(idx3), sprintf('BW=%.2f', bw3), 'Color', 'g', 'FontSize', 10);
figure(2);
step(G1_cl, G2_cl, G3_cl, 20);
grid on;
title('闭环系统阶跃响应对比');
legend('G1\_cl (一阶)', 'G2\_cl (二阶)', 'G3\_cl (高阶)', 'Location', 'southeast');
xlabel('时间 (秒)');
ylabel('幅值');