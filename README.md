# DailyEcho - 鸿蒙极简原声英语微学习 App (HarmonyOS NEXT)

> **极简无压 · 影视盲听磨耳 · 连读发音解码 · 词句一体**

DailyEcho 是一款面向想真正**听懂真实生活与英文影视原声**、但时间碎片且容易焦虑的用户打造的鸿蒙原生（HarmonyOS NEXT Stage 模型）学习应用。

---

## 🌟 核心理念与亮点

1. **超低心智负担（Atomic Habit）**：
   * 默认每天仅需学习 **1~2 张卡片（约 3 分钟）**。
   * “完成即是胜利”，达成后触发极简成就反馈，坚决拒绝背单词软件的挫败感与红点压力。
2. **先听后看（Audio-first 盲听磨耳）**：
   * 卡片正面只给原声音频与语境场景，强迫耳朵摆脱英文字幕依赖；
   * 翻转卡片后揭晓中英对照，并支持 0.8x 慢速与 1.0x 原速精听切换。
3. **影视听懂秘诀（发音解码）**：
   * 专门拆解导致“看懂但听不懂”的罪魁祸首：**连读（Linking）、弱读（Weakening）、同化（Assimilation）、失爆（Elision）**。
4. **词句一体（Chunking）**：
   * 拒绝背孤立词表；核心词汇作为句子的“骨架”出现，学一个词带走一整句高频生活表达。
5. **弹性加餐（Binge Mode）**：
   * 完成今日 2 张卡后，想学随时可以一键进入自由滑动加餐流。

---

## 📱 技术架构与技术栈

* **操作系统平台**：HarmonyOS NEXT (API 12+)
* **应用模型**：Stage 模型 (ArkTS 强类型规范)
* **核心组件**：
  * **ArkUI 声明式组件**：3D 翻转动效卡片 (`EchoStudyCard.ets`)、Swiper 沉浸滑动
  * **系统音频引擎**：基于 `@ohos.multimedia.media` 的 `AVPlayer` 状态机高封装播放器 (`AudioPlayerManager.ets`)
  * **轻量本地持久化**：基于 `@ohos.data.preferences` 的连续打卡与天数追踪 (`StorageManager.ets`)

---

## 📂 源码目录结构

```text
DailyEcho/
├── AppScope/                      # 全局应用配置
│   ├── app.json5                  # 应用 BundleName、版本配置
│   └── resources/                 # 全局图标与字符串资源
├── entry/                         # 主模块
│   ├── build-profile.json5        # 编译构建配置
│   ├── oh-package.json5           # 包管理依赖
│   └── src/main/
│       ├── module.json5           # 模块与 Ability、网络权限声明
│       ├── ets/
│       │   ├── entryability/      # Ability 生命周期
│       │   │   └── EntryAbility.ets
│       │   ├── model/             # 核心数据模型 (卡片、打卡状态)
│       │   │   └── EchoCardModel.ets
│       │   ├── components/        # 核心 UI 组件
│       │   │   └── EchoStudyCard.ets (3D 翻转卡片/盲听波形/解码)
│       │   ├── common/
│       │   │   ├── utils/         # 工具类 (AVPlayer 封装, Preferences 存储)
│       │   │   │   ├── AudioPlayerManager.ets
│       │   │   │   └── StorageManager.ets
│       │   │   └── constants/     # 语料库种子数据
│       │   │       └── SeedData.ets
│       │   └── pages/             # 页面入口
│       │       └── Index.ets      # 极简打卡主页与加餐流
│       └── resources/             # 颜色、多语言、页面路由 profile
├── build-profile.json5            # 工程级构建配置
├── oh-package.json5               # 工程级依赖
└── README.md
```

---

## 🚀 如何在 DevEco Studio 中运行

1. 下载并安装官方 **DevEco Studio (HarmonyOS NEXT 版)**。
2. 打开 DevEco Studio，选择 **Open Project**，定位到本目录 `D:\DailyEcho`。
3. 等待 Gradle / hvigor 同步依赖完成。
4. 连接鸿蒙真机或启动 NEXT 模拟器，点击运行按钮即可体验！

---

## 🗺️ 后续路线图 (Roadmap)

* [ ] 鸿蒙桌面服务卡片（FormExtensionAbility，免开 App 桌面翻卡）
* [ ] 实况窗通勤随身磨耳（Live View 锁屏与胶囊播控）
* [ ] 连读发音波形可视化高亮
* [ ] 华为手表端（Watch）抬腕轻触发音卡片
