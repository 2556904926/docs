s = tf('s');
G1 = 1/(s+1);
G2 = 10/(s*(s+1));
G3 = 100/(s*(s+1)*(0.1*s+1));

% 计算裕度：GM增益裕度，PM相位裕度，Wcp增益穿越频率
[GM1, PM1, ~, Wcp1] = margin(G1);
[GM2, PM2, ~, Wcp2] = margin(G2);
[GM3, PM3, ~, Wcp3] = margin(G3);
fprintf('G1 相位裕度 PM1 = %.1f °\nG2 相位裕度 PM2 = %.1f °\nG3 相位裕度 PM3 = %.1f °\n',PM1,PM2,PM3);

figure('Color','w');
bode(G1,G2,G3);
grid on;
legend('G1','G2','G3','Location','best');
hold on;

color = lines(3);
sys = {G1,G2,G3};
pm_val = [PM1,PM2,PM3];
w_c = [Wcp1,Wcp2,Wcp3];

% 提取相位坐标轴
ax_phase = findobj(gcf,'YLabel',matlab.graphics.primitive.Text('String','Phase (deg)'));
axes(ax_phase);

for i = 1:3
    w = w_c(i);
    p = pm_val(i);
    [~,ph] = bode(sys{i},w);
    ph = squeeze(ph);
    xline(w,'--','Color',color(i,:));
    plot([w,w],[ph,-180],'Color',color(i,:),'LineWidth',2);
    text(w*1.08, (ph-180)/2, sprintf('PM=%.1f°',p),'Color',color(i,:));
end

figure('Color', 'w', 'Name', '闭环阶跃响应子图');

for i = 1:3
    subplot(1, 3, i);
    T = feedback(sys{i}, 1);
    step(T, 20);
    grid on;
    title(sprintf('T%d 闭环阶跃响应', i));
    xlabel('时间 (秒)');
    ylabel('输出');
    
    % 检查稳定性
    if ~isstable(T)
        text(1, max(ylim)*0.8, '⚠ 不稳定！', ...
            'Color', 'r', 'FontSize', 14, 'FontWeight', 'bold');
    end
end