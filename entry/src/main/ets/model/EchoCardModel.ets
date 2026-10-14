/**
 * 核心词汇/搭配高亮模型
 */
export interface HighlightWord {
  word: string;             // 重点单词或短语，如 "game"
  phonetic: string;         // 音标，如 "/ɡeɪm/"
  meaning: string;          // 在本句中的精确含义，如 "愿意参加的；有冒险精神的"
  rootMeaning?: string;     // 常见基础义，如 "游戏，比赛（名词）"
  usageNote?: string;       // 语境用法小贴士
}

/**
 * 听力难点发音解码模型（连读、弱读、同化、失爆）
 */
export interface PhoneticRule {
  type: 'linking' | 'weakening' | 'assimilation' | 'elision' | 'stress'; // 规则类型
  typeLabel: string;        // 中文标签，如 "连读", "弱读", "失爆", "同化"
  chunk: string;            // 涉及的文本片段，如 "I'm game" -> [aɪm ɡeɪm]
  pronunciation: string;    // 实际听到的音标表示
  explanation: string;      // 影视听力为什么听不懂的通俗原理解析
}

/**
 * 学习卡片核心数据结构
 */
export interface EchoCard {
  id: string;               // 唯一ID
  category: 'movie' | 'daily' | 'dialogue'; // 分类：影视原声 / 日常生存 / 场景对话
  sourceTitle: string;      // 来源出处，如《老友记》《摩登家庭》《疯狂动物城》或日常咖啡馆
  sceneDescription: string; // 语境场景一句话还原，助联想画面
  audioUrl: string;         // 音频地址（本地 rawfile 或远程原声切片）
  audioDurationSec: number; // 音频时长（秒），通常 3~6s
  englishSentence: string;  // 英文原句
  chineseTranslation: string; // 中文地道翻译
  keywords: HighlightWord[]; // 核心单词列表（词句一体）
  phoneticBreakdown: PhoneticRule[]; // 发音解码技巧
  difficultyLevel: 1 | 2 | 3; // 难度等级：1入门，2进阶，3高语速真实影视
}

/**
 * 用户每日学习打卡状态
 */
export interface DailyStudyRecord {
  date: string;             // YYYY-MM-DD
  completedCardIds: string[]; // 当天已掌握的卡片ID
  streakDays: number;       // 连续打卡天数
  isTargetCompleted: boolean; // 是否已完成今日最低目标（1~2张）
  totalCardsMastered: number; // 历史累计掌握卡片总数
}
