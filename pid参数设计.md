# 控制器选型与系统匹配手册


## 被控对象标准型

### 一阶系统

$$G(s)=\frac{1}{Ts+1}$$

- 惯性时间常数：$T$
- 极点：$s=-1/T$
- 极点角频率：$\omega_p=1/T$

例子：

### 二阶系统

$$G(s)=\frac{\omega_n^2}{s^2+2\zeta\omega_n s+\omega_n^2}$$

- 无阻尼自然振荡频率：$\omega_n$
- 阻尼比：$\zeta$
- 极点：$s=-\zeta\omega_n \pm j\omega_n\sqrt{1-\zeta^2}$（$\zeta<1$时）


## 1 P控制器

### 适用系统

一阶系统：
$$G(s)=\frac{1}{Ts+1}$$

### 控制器

$$G_c(s)=K_p$$

### 开环传递函数

$$G_{open}(s)=K_p \cdot \frac{1}{Ts+1}$$

### 闭环传递函数

$$G_{close}(s)=\frac{K_p}{Ts+1+K_p}=\frac{K_p/T}{s+(1+K_p)/T}$$

### 参数设计

令闭环带宽 $\omega_b=(1+K_p)/T$，得：

$$\boxed{K_p=\omega_b T - 1}$$

### 特性分析

| 项目 | 说明 |
|:---|:---|
| 稳态误差 | $\lim_{s\to0}s\cdot\frac{1}{1+G_{open}(s)}\cdot\frac{1}{s}=\frac{1}{1+K_p}$，**存在静差** |
| 响应速度 | $K_p\uparrow$ → 带宽↑ → 响应↑，静差↓ |
| 稳定性 | $K_p$过大 → 增益裕度下降 → 震荡发散 |
| 适用场景 | 允许稳态误差的调压、限流，一阶系统勉强可用 |

### 二阶系统适用性

❌ **不推荐。** 二阶系统P控制无法同时满足稳态精度和动态品质，且可能引发欠阻尼振荡。


## 2 PD控制器

### 适用系统

一阶系统：
$$G(s)=\frac{1}{Ts+1}$$

### 控制器

$$G_c(s)=K_d s+K_p=K_d\left(s+\frac{K_p}{K_d}\right)=K_d(s+\omega_z)$$

其中零点频率：

$$\omega_z=\frac{K_p}{K_d}$$

### 开环传递函数

$$G_{open}(s)=K_d(s+\omega_z)\cdot\frac{1}{Ts+1}$$

### 零极点对消设计

令PD零点抵消一阶系统极点：

$$\omega_z=\omega_p=\frac{1}{T}$$

约束关系：

$$\frac{K_p}{K_d}=\frac{1}{T} \quad\Longrightarrow\quad \boxed{K_p=\frac{K_d}{T}}$$

对消后开环：

$$G_{open}(s)=K_d(s+1/T)\cdot\frac{1}{T(s+1/T)}=\frac{K_d}{T}$$

退化为纯比例环节。

### 带宽定参数

$$G_{open}(s)=\frac{K_d}{T} \quad\Longrightarrow\quad \omega_b=\frac{K_d}{T}$$

$$\boxed{K_d=\omega_b T}$$

$$\boxed{K_p=\omega_b}$$

### 特性分析

| 项目 | 说明 |
|:---|:---|
| 相位超前 | 零点引入超前相位，改善动态响应，抑制超调 |
| 稳态误差 | 无积分项，$\lim_{s\to0}s\cdot\frac{1}{1+K_d/T}\cdot\frac{1}{s}=\frac{1}{1+K_d/T}$，**仍有静差** |
| 高频噪声 | 微分项增益 $|K_d j\omega|$ 随频率线性增大，**严重放大采样噪声** |
| 工程现状 | DSP/MCU中微分项极易导致采样值剧烈跳动，**工业几乎不用** |
| 适用场景 | 理论教学、对噪声不敏感的特殊模拟控制 |

### 二阶系统适用性

⚠️ **有限适用。** 需配合其他环节使用，单独PD无法消除静差且对二阶系统极点对消不完整。


## 3 PI控制器

### 适用系统

一阶系统（⭐ **最优匹配**）：
$$G(s)=\frac{1}{Ts+1}$$

### 控制器

$$G_{PI}(s)=K_p+\frac{K_i}{s}=\frac{K_p s+K_i}{s}=K_p\cdot\frac{s+K_i/K_p}{s}=K_p\cdot\frac{s+\omega_z}{s}$$

其中积分零点频率（比例/积分作用分界频率）：

$$\omega_z=\frac{K_i}{K_p}$$

### 开环传递函数

$$G_{open}(s)=K_p\cdot\frac{s+\omega_z}{s}\cdot\frac{1}{Ts+1}$$

### 零极点对消设计

令PI零点抵消一阶系统极点：

$$\omega_z=\omega_p=\frac{1}{T}$$

$$\frac{K_i}{K_p}=\frac{1}{T} \quad\Longrightarrow\quad \boxed{K_i=\frac{K_p}{T}}$$

### 带宽定参数

对消后开环：

$$G_{open}(s)=K_p\cdot\frac{s+1/T}{s}\cdot\frac{1}{T(s+1/T)}=\frac{K_p}{T}\cdot\frac{1}{s}$$

开环传递函数退化为纯积分环节 $K_p/(T\cdot s)$。

闭环传递函数：

$$G_{close}(s)=\frac{K_p/(T)}{s+K_p/T}$$

闭环带宽 $\omega_b=K_p/T$，得：

$$\boxed{K_p=\omega_b T}$$

$$\boxed{K_i=\omega_b}$$

### 特性分析

| 项目 | 说明 |
|:---|:---|
| 稳态误差 | 开环含纯积分（1型系统），阶跃响应**无静差** |
| 动态响应 | 闭环为一阶惯性 $G_{close}=\omega_b/(s+\omega_b)$，**无超调** |
| 物理意义 | $K_p$ 决定响应速度，$K_i$ 消除静差 |
| 参数温漂 | $T$ 变化时零点偏移，需预留带宽裕度（$\omega_b$留20%~30%余量） |
| 积分饱和 | **必须加输出限幅 + 积分分离/抗积分饱和** |
| 工程地位 | **一阶系统标准控制器**，电机FOC、DCDC电流环标配 |

### 二阶系统适用性

⚠️ **有限适用。** PI仅提供一个零点，无法完全对消二阶系统的两个极点，闭环仍为二阶，可能产生超调。若二阶系统有一个主导极点远慢于另一个（$T_1 \gg T_2$），可近似为一阶系统使用PI，非主导极点影响忽略。


## 4 PID控制器

### 适用系统

二阶系统（⭐ **标准匹配**）：
$$G(s)=\frac{\omega_n^2}{s^2+2\zeta\omega_n s+\omega_n^2}$$

### 控制器

$$G_{PID}(s)=K_p+\frac{K_i}{s}+K_d s=\frac{K_d s^2+K_p s+K_i}{s}$$

设PID零点频率为 $\omega_{z1}$、$\omega_{z2}$，则：

$$G_{PID}(s)=K_d\cdot\frac{(s+\omega_{z1})(s+\omega_{z2})}{s}$$

### 零极点对消设计

令两个零点分别对消二阶系统的两个极点：

$$\omega_{z1}=p_1, \quad \omega_{z2}=p_2$$

其中 $p_1,p_2$ 为二阶系统极点（$\zeta<1$时为共轭复极点）。

对消后开环：

$$G_{open}(s)=K_d\cdot\frac{(s+p_1)(s+p_2)}{s}\cdot\frac{\omega_n^2}{(s+p_1)(s+p_2)}=\frac{K_d\cdot\omega_n^2}{s}$$

退化为纯积分环节。

### 参数整定（二选一）

**方法一：极点对消法（精确匹配）**

已知二阶系统极点 $p_1,p_2$：

$$K_d s^2+K_p s+K_i = K_d(s+p_1)(s+p_2)=K_d[s^2+(p_1+p_2)s+p_1 p_2]$$

得：

$$K_p=K_d(p_1+p_2), \quad K_i=K_d\cdot p_1 p_2$$

带宽 $\omega_b=K_d\cdot\omega_n^2$，则 $K_d=\omega_b/\omega_n^2$，回代：

$$\boxed{K_p=\frac{\omega_b(p_1+p_2)}{\omega_n^2}},\quad \boxed{K_i=\omega_b}$$

**方法二：相位裕度法（工程常用）**

1. 根据相位裕度目标（通常 $60°\sim70°$）确定穿越频率 $\omega_c$
2. 在 $\omega_c$ 处配置零点和极点，使相位裕度满足要求
3. 计算三参数，需迭代或借助工具

### 特性分析

| 项目 | 说明 |
|:---|:---|
| 稳态误差 | 开环含纯积分，**无静差** |
| 动态品质 | 微分项提供相位超前，可独立调节阻尼比，抑制超调 |
| 复杂度 | 三参数整定，需极点对消或相位裕度法 |
| 适用场景 | 伺服位置环、高阶系统、要求高动态品质场合 |

### 一阶系统适用性

❌ **禁用。** 理由：

1. 一阶系统仅1个极点，PID提供2个零点，多出1个零点无法对消
2. 多余零点引入额外相位滞后，破坏系统稳定性
3. 微分项在一阶系统中对动态无增益，反而放大高频噪声
4. **结论：一阶系统用PID属于过度设计，有害无益**


## 参数速查总表

| 控制器 | 适用系统 | $K_p$ | $K_i$ | $K_d$ | 静差 | 推荐度 |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| **P** | 一阶 | $\omega_b T-1$ | — | — | ❌有 | ⭐⭐ |
| **PD** | 一阶 | $\omega_b$ | — | $\omega_b T$ | ❌有 | ⭐ |
| **PI** | 一阶 | $\omega_b T$ | $\omega_b$ | — | ✅无 | ⭐⭐⭐⭐⭐ |
| **PID** | 二阶 | $\frac{\omega_b(p_1+p_2)}{\omega_n^2}$ | $\omega_b$ | $\frac{\omega_b}{\omega_n^2}$ | ✅无 | ⭐⭐⭐⭐⭐ |


## 工程要点

1. **一阶系统 → PI**，二阶系统 → PID，P和PD不建议用于闭环电流/速度控制
2. 零点对消口诀：**控制器零点 = 被控对象极点**
3. 带宽约束：$\omega_b \le \frac{1}{5}\omega_s$（等效 $f_b \le f_s/10$）
4. 离散化：**增量式PI优先**，避免积分饱和
5. 参数温漂：预留带宽裕度，实际调试时微调