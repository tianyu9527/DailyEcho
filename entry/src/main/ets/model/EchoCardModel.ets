/**
 * 核心词汇/搭配高亮模型
 */
export class HighlightWord {
  word: string = '';             // 重点单词或短语，如 "game"
  phonetic: string = '';         // 音标，如 "/ɡeɪm/"
  meaning: string = '';          // 在本句中的精确含义，如 "愿意参加的；有冒险精神的"
  rootMeaning?: string = '';     // 常见基础义，如 "游戏，比赛（名词）"
  usageNote?: string = '';       // 语境用法小贴士

  constructor(word: string, phonetic: string, meaning: string, rootMeaning?: string, usageNote?: string) {
    this.word = word;
    this.phonetic = phonetic;
    this.meaning = meaning;
    this.rootMeaning = rootMeaning;
    this.usageNote = usageNote;
  }
}

/**
 * 听力难点发音解码模型（连读、弱读、同化、失爆）
 */
export class PhoneticRule {
  type: string = 'linking';      // 规则类型：linking | weakening | assimilation | elision | stress
  typeLabel: string = '连读';     // 中文标签，如 "连读", "弱读", "失爆", "同化"
  chunk: string = '';            // 涉及的文本片段，如 "I'm game" -> [aɪm ɡeɪm]
  pronunciation: string = '';    // 实际听到的音标表示
  explanation: string = '';      // 影视听力为什么听不懂的通俗原理解析

  constructor(type: string, typeLabel: string, chunk: string, pronunciation: string, explanation: string) {
    this.type = type;
    this.typeLabel = typeLabel;
    this.chunk = chunk;
    this.pronunciation = pronunciation;
    this.explanation = explanation;
  }
}

/**
 * 学习卡片核心数据结构
 */
export class EchoCard {
  id: string = '';               // 唯一ID
  category: string = 'movie';    // 分类：movie | daily | dialogue
  sourceTitle: string = '';      // 来源出处，如《老友记》《摩登家庭》
  sceneDescription: string = ''; // 语境场景一句话还原
  audioUrl: string = '';         // 音频地址
  audioDurationSec: number = 3.0;// 音频时长（秒）
  englishSentence: string = '';  // 英文原句
  chineseTranslation: string = ''; // 中文地道翻译
  keywords: HighlightWord[] = [];// 核心单词列表
  phoneticBreakdown: PhoneticRule[] = []; // 发音解码技巧
  difficultyLevel: number = 1;   // 难度等级：1入门，2进阶，3高语速真实影视

  constructor(
    id: string,
    category: string,
    sourceTitle: string,
    sceneDescription: string,
    audioUrl: string,
    audioDurationSec: number,
    englishSentence: string,
    chineseTranslation: string,
    difficultyLevel: number,
    keywords: HighlightWord[],
    phoneticBreakdown: PhoneticRule[]
  ) {
    this.id = id;
    this.category = category;
    this.sourceTitle = sourceTitle;
    this.sceneDescription = sceneDescription;
    this.audioUrl = audioUrl;
    this.audioDurationSec = audioDurationSec;
    this.englishSentence = englishSentence;
    this.chineseTranslation = chineseTranslation;
    this.difficultyLevel = difficultyLevel;
    this.keywords = keywords;
    this.phoneticBreakdown = phoneticBreakdown;
  }
}

/**
 * 用户每日学习打卡状态
 */
export class DailyStudyRecord {
  date: string = '';             // YYYY-MM-DD
  completedCardIds: string[] = []; // 当天已掌握的卡片ID
  streakDays: number = 1;       // 连续打卡天数
  isTargetCompleted: boolean = false; // 是否已完成今日最低目标（1~2张）
  totalCardsMastered: number = 0; // 历史累计掌握卡片总数

  constructor(
    date: string,
    completedCardIds: string[],
    streakDays: number,
    isTargetCompleted: boolean,
    totalCardsMastered: number
  ) {
    this.date = date;
    this.completedCardIds = completedCardIds;
    this.streakDays = streakDays;
    this.isTargetCompleted = isTargetCompleted;
    this.totalCardsMastered = totalCardsMastered;
  }
}
