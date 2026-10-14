import { EchoCard } from '../model/EchoCardModel';

/**
 * 精选真实影视与日常高频语料库
 * 包含：盲听原声、连读弱读拆解、词句一体高亮
 */
export const SEED_ECHO_CARDS: EchoCard[] = [
  {
    id: 'echo_001',
    category: 'movie',
    sourceTitle: '《老友记》(Friends)',
    sceneDescription: '朋友提议周五一起去露营跳伞，你非常乐意加入时',
    audioUrl: 'https://dict.youdao.com/dictvoice?audio=I%27m+game+if+you+are.&type=2',
    audioDurationSec: 2.8,
    englishSentence: "I'm game if you are.",
    chineseTranslation: "你要是去，我也完全没问题（我奉陪）！",
    difficultyLevel: 1,
    keywords: [
      {
        word: "game",
        phonetic: "/ɡeɪm/",
        meaning: "愿意加入的；有兴致的（形容词）",
        rootMeaning: "游戏/比赛（名词）",
        usageNote: "在口语和电影中极高频，'be game for something' 意思是随时愿意奉陪玩一把。"
      }
    ],
    phoneticBreakdown: [
      {
        type: 'linking',
        typeLabel: '连读',
        chunk: "game if",
        pronunciation: "/ɡeɪ-mɪf/",
        explanation: "game 词尾辅音 /m/ 与 if 词首元音 /ɪ/ 自然平滑滑读，听起来像 gamif。"
      },
      {
        type: 'weakening',
        typeLabel: '弱读',
        chunk: "you are",
        pronunciation: "/jʊər/",
        explanation: "口语中 are 通常不重读，弱化为轻声的 /ər/。"
      }
    ]
  },
  {
    id: 'echo_002',
    category: 'movie',
    sourceTitle: '《摩登家庭》(Modern Family)',
    sceneDescription: '双方讨论一件事情，虽有不同观点，但觉得对方说的有道理时',
    audioUrl: 'https://dict.youdao.com/dictvoice?audio=Fair+enough%2C+I+see+your+point.&type=2',
    audioDurationSec: 3.2,
    englishSentence: "Fair enough, I see your point.",
    chineseTranslation: "行吧，有道理，我懂你的意思了。",
    difficultyLevel: 1,
    keywords: [
      {
        word: "fair enough",
        phonetic: "/feər ɪˈnʌf/",
        meaning: "有道理；合情合理；说得通",
        usageNote: "影视剧中老美日常达成妥协时的口头禅，比 OK 更显情商和赞同。"
      },
      {
        word: "point",
        phonetic: "/pɔɪnt/",
        meaning: "观点；核心论点",
        rootMeaning: "点/指（动词/名词）",
        usageNote: "see someone's point = 明白某人的立场。"
      }
    ],
    phoneticBreakdown: [
      {
        type: 'linking',
        typeLabel: '连读',
        chunk: "Fair enough",
        pronunciation: "/feə-rɪˈnʌf/",
        explanation: "Fair 尾部辅音 /r/ 与 enough 开头元音 /ɪ/ 紧密咬合连读成 /rɪ/。"
      },
      {
        type: 'elision',
        typeLabel: '失爆',
        chunk: "point",
        pronunciation: "/pɔɪn(t)/",
        explanation: "句尾的 /t/ 舌尖抵住上齿龈只做出口型，不发生爆破爆破气流，几乎听不到 t 声。"
      }
    ]
  },
  {
    id: 'echo_003',
    category: 'daily',
    sourceTitle: '《生活大爆炸》日常场景',
    sceneDescription: '买咖啡或超市结账时，店员问要不要袋子，你随口回应',
    audioUrl: 'https://dict.youdao.com/dictvoice?audio=I%27m+good%2C+thanks+for+asking.&type=2',
    audioDurationSec: 2.5,
    englishSentence: "I'm good, thanks for asking.",
    chineseTranslation: "不用了（我这样挺好），谢谢询问。",
    difficultyLevel: 1,
    keywords: [
      {
        word: "I'm good",
        phonetic: "/aɪm ɡʊd/",
        meaning: "不用了 / 我不需要（礼貌拒绝）",
        rootMeaning: "我很好",
        usageNote: "别总说 No! 老外被问还要不要更多咖啡/加餐时，'I'm good' 最地道自然。"
      }
    ],
    phoneticBreakdown: [
      {
        type: 'weakening',
        typeLabel: '弱读',
        chunk: "for",
        pronunciation: "/fər/",
        explanation: "介词 for 在非句尾时极度弱读为 /fər/，一闪而过，几乎听不到字母 o 的发音。"
      }
    ]
  },
  {
    id: 'echo_004',
    category: 'movie',
    sourceTitle: '《穿普拉达的女王》(The Devil Wears Prada)',
    sceneDescription: '上司交代紧急任务，你要立刻着手办理',
    audioUrl: 'https://dict.youdao.com/dictvoice?audio=I%27m+on+it+right+away.&type=2',
    audioDurationSec: 2.4,
    englishSentence: "I'm on it right away.",
    chineseTranslation: "我这就去办，马上搞定！",
    difficultyLevel: 2,
    keywords: [
      {
        word: "on it",
        phonetic: "/ɒn ɪt/",
        meaning: "正在处理 / 在办了",
        usageNote: "职场、电影中表达执行力最强的一句话，比 'I will do it' 生动十倍。"
      },
      {
        word: "right away",
        phonetic: "/raɪt əˈweɪ/",
        meaning: "立刻；马上",
        usageNote: "固定副词短语，强化紧迫感。"
      }
    ],
    phoneticBreakdown: [
      {
        type: 'linking',
        typeLabel: '两连读',
        chunk: "I'm on it",
        pronunciation: "/aɪ-mɒ-nɪt/",
        explanation: "三词连环贯通：I'm 的 m 连 on 的 o，on 的 n 连 it 的 i，听起来像一个词 'aimonit'。"
      }
    ]
  },
  {
    id: 'echo_005',
    category: 'movie',
    sourceTitle: '《心灵捕手》(Good Will Hunting)',
    sceneDescription: '朋友向你道歉或为某事内疚，你真诚宽慰对方时',
    audioUrl: 'https://dict.youdao.com/dictvoice?audio=It%27s+not+your+fault+at+all.&type=2',
    audioDurationSec: 3.0,
    englishSentence: "It's not your fault at all.",
    chineseTranslation: "这根本不是你的错，一点也不是。",
    difficultyLevel: 2,
    keywords: [
      {
        word: "fault",
        phonetic: "/fɔːlt/",
        meaning: "过错；过失",
        rootMeaning: "缺陷/故障",
        usageNote: "not someone's fault 经典安慰表达。"
      },
      {
        word: "at all",
        phonetic: "/æt ɔːl/",
        meaning: "根本；丝毫（用于否定句加强语气）",
        usageNote: "否定句末尾强调，彻底打消顾虑。"
      }
    ],
    phoneticBreakdown: [
      {
        type: 'linking',
        typeLabel: '连读变音',
        chunk: "at all",
        pronunciation: "/ə-ˈdɔːl/",
        explanation: "美音经典 Flap T：at 词尾辅音 /t/ 夹在元音之间，软化为弹舌音 /d/，听起来像 adall。"
      }
    ]
  },
  {
    id: 'echo_006',
    category: 'daily',
    sourceTitle: '美式咖啡厅现场',
    sceneDescription: '在吧台点咖啡，想要外带边走边喝',
    audioUrl: 'https://dict.youdao.com/dictvoice?audio=Can+I+get+an+iced+latte+to+go%3F&type=2',
    audioDurationSec: 3.5,
    englishSentence: "Can I get an iced latte to go?",
    chineseTranslation: "来一杯冰拿铁打包带走可以吗？",
    difficultyLevel: 2,
    keywords: [
      {
        word: "get",
        phonetic: "/ɡet/",
        meaning: "买；要；来一份",
        rootMeaning: "得到/到达",
        usageNote: "点单时最地道的万能动词是 Can I get...，比 Can I have 更接地气。"
      },
      {
        word: "to go",
        phonetic: "/tə ɡoʊ/",
        meaning: "外带；打包带走",
        usageNote: "美语中打包直接说 to go，堂食是 for here。"
      }
    ],
    phoneticBreakdown: [
      {
        type: 'linking',
        typeLabel: '连读',
        chunk: "Can I",
        pronunciation: "/kæ-naɪ/",
        explanation: "Can 的 /n/ 与 I 的 /aɪ/ 紧密咬合发成 /naɪ/。"
      },
      {
        type: 'weakening',
        typeLabel: '弱读',
        chunk: "to",
        pronunciation: "/tə/",
        explanation: "不定式 to 极少重读，弱化为模糊元音 /tə/。"
      }
    ]
  }
];
