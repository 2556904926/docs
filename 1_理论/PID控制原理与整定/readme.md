# PID控制原理与整定

## 1. PID控制律

$$u(t)=K_p e(t)+K_i\int_0^t e(\tau)d\tau+K_d\frac{de(t)}{dt}$$

$$G_c(s)=K_p+\frac{K_i}{s}+K_d s$$

## 2. 频域特性

$$G_c(j\omega)=K_p+j\left(K_d\omega-\frac{K_i}{\omega}\right)$$

| 环节 | 幅值 | 相位 | 作用频段 |
|:---|:---|:---|:---|
| P | $K_p$ | $0°$ | 全频段，决定响应速度 |
| I | $K_i/\omega$ | $-90°$ | 低频段，消除静差 |
| D | $K_d\omega$ | $+90°$ | 高频段，提升相角裕度 |

**穿越频率处开环相位**：

$$\angle G_c(j\omega_c)G_p(j\omega_c)=-180°+PM$$

---

## 3. 控制器与被控对象匹配

控制器的本质：**引入零极点，改造原系统开环特性，使其逼近理想积分型 $K/s$，获得一阶闭环行为（无超调、零静差）**。

### 3.1 一阶系统 + PI

$$G(s)=\frac{1}{Ts+1}$$

PI控制器：

$$G_{PI}(s)=K_p+\frac{K_i}{s}=\frac{K_p s+K_i}{s}$$

**零极点对消**：令控制器零点抵消对象极点 $s=-1/T$

$$\frac{K_i}{K_p}=\frac{1}{T}\quad\Longrightarrow\quad K_p=K_iT$$

**改造后开环**：

$$L(s)=G_{PI}\cdot G=\frac{K_i(Ts+1)}{s}\cdot\frac{1}{Ts+1}=\frac{K_i}{s}$$

**闭环**：

$$T(s)=\frac{L}{1+L}=\frac{K_i}{s+K_i}$$

带宽 $\omega_b=K_i$：

$$\boxed{K_i=\omega_b,\quad K_p=\omega_b T}$$

### 3.2 二阶系统 + PID

$$G(s)=\frac{\omega_n^2}{s^2+2\zeta\omega_n s+\omega_n^2}=\frac{\omega_n^2}{(s+p_1)(s+p_2)}$$

PID控制器：

$$G_{PID}(s)=K_p+\frac{K_i}{s}+K_d s=\frac{K_d(s+p_1)(s+p_2)}{s}$$

**双零点对消**：令控制器分子完全抵消对象分母

$$K_p=K_d(p_1+p_2)=K_d\cdot 2\zeta\omega_n$$

$$K_i=K_d\cdot p_1p_2=K_d\omega_n^2$$

**改造后开环**：

$$L(s)=G_{PID}\cdot G=\frac{K_d(s+p_1)(s+p_2)}{s}\cdot\frac{\omega_n^2}{(s+p_1)(s+p_2)}=\frac{K_d\omega_n^2}{s}$$

**闭环**：

$$T(s)=\frac{L}{1+L}=\frac{K_d\omega_n^2}{s+K_d\omega_n^2}$$

带宽 $\omega_b=K_d\omega_n^2$：

$$\boxed{K_d=\frac{\omega_b}{\omega_n^2},\quad K_p=\frac{2\zeta\omega_b}{\omega_n},\quad K_i=\omega_b}$$

### 3.3 匹配总结

无论一阶还是二阶系统，匹配后的闭环统一为：

$$T(s)=\frac{\omega_b}{s+\omega_b}$$

**核心结论**：设计者只需指定带宽 $\omega_b$，控制器参数由对象固有参数（$T$、$\omega_n$、$\zeta$）唯一确定。闭环行为完全一致——无超调、零静差。

| 被控对象 | 推荐控制器 | 设计公式 | 闭环行为 |
|:---:|:---:|:---:|:---:|
| 一阶 $1/(Ts+1)$ | PI | $K_p=\omega_b T,\quad K_i=\omega_b$ | 一阶，无超调 |
| 二阶 $\omega_n^2/(s^2+2\zeta\omega_n s+\omega_n^2)$ | PID | $K_p=\dfrac{2\zeta\omega_b}{\omega_n},\quad K_i=\omega_b,\quad K_d=\dfrac{\omega_b}{\omega_n^2}$ | 一阶，无超调 |

---

## 4. 整定流程

```mermaid
flowchart TD
    A[辨识被控对象] --> B{系统阶次?}
    B -->|一阶| C[PI控制器]
    B -->|二阶| D[PID控制器]
    C --> E["Kp = ωb·T, Ki = ωb"]
    D --> F["Kd=ωb/ωn², Kp=2ζωb/ωn, Ki=ωb"]
    E --> G[仿真验证]
    F --> G
    G --> H{满足性能?}
    H -->|是| I[部署]
    H -->|否| J[调整ωb]
    J --> G