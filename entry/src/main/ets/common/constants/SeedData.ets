import { EchoCard, HighlightWord, PhoneticRule } from '../../model/EchoCardModel';

/**
 * 精选真实影视与日常高频语料库
 * 包含：盲听原声、连读弱读拆解、词句一体高亮
 */
export const SEED_ECHO_CARDS: EchoCard[] = [
  new EchoCard(
    'echo_001',
    'movie',
    '《老友记》(Friends)',
    '朋友提议周五一起去露营跳伞，你非常乐意加入时',
    'https://dict.youdao.com/dictvoice?audio=I%27m+game+if+you+are.&type=2',
    2.8,
    "I'm game if you are.",
    '你要是去，我也完全没问题（我奉陪）！',
    1,
    [
      new HighlightWord(
        'game',
        '/ɡeɪm/',
        '愿意加入的；有兴致的（形容词）',
        '游戏/比赛（名词）',
        "在口语和电影中极高频，'be game for something' 意思是随时愿意奉陪玩一把。"
      )
    ],
    [
      new PhoneticRule(
        'linking',
        '连读',
        'game if',
        '/ɡeɪ-mɪf/',
        'game 词尾辅音 /m/ 与 if 词首元音 /ɪ/ 自然平滑滑读，听起来像 gamif。'
      ),
      new PhoneticRule(
        'weakening',
        '弱读',
        'you are',
        '/jʊər/',
        '口语中 are 通常不重读，弱化为轻声的 /ər/。'
      )
    ]
  ),
  new EchoCard(
    'echo_002',
    'movie',
    '《摩登家庭》(Modern Family)',
    '双方讨论一件事情，虽有不同观点，但觉得对方说的有道理时',
    'https://dict.youdao.com/dictvoice?audio=Fair+enough%2C+I+see+your+point.&type=2',
    3.2,
    'Fair enough, I see your point.',
    '行吧，有道理，我懂你的意思了。',
    1,
    [
      new HighlightWord(
        'fair enough',
        '/feər ɪˈnʌf/',
        '有道理；合情合理；说得通',
        '',
        '影视剧中老美日常达成妥协时的口头禅，比 OK 更显情商和赞同。'
      ),
      new HighlightWord(
        'point',
        '/pɔɪnt/',
        '观点；核心论点',
        '点/指（动词/名词）',
        "see someone's point = 明白某人的立场。"
      )
    ],
    [
      new PhoneticRule(
        'linking',
        '连读',
        'Fair enough',
        '/feə-rɪˈnʌf/',
        'Fair 尾部辅音 /r/ 与 enough 开头元音 /ɪ/ 紧密咬合连读成 /rɪ/。'
      ),
      new PhoneticRule(
        'elision',
        '失爆',
        'point',
        '/pɔɪn(t)/',
        '句尾的 /t/ 舌尖抵住上齿龈只做出口型，不发生爆破气流，几乎听不到 t 声。'
      )
    ]
  ),
  new EchoCard(
    'echo_003',
    'daily',
    '《生活大爆炸》日常场景',
    '买咖啡或超市结账时，店员问要不要袋子，你随口回应',
    'https://dict.youdao.com/dictvoice?audio=I%27m+good%2C+thanks+for+asking.&type=2',
    2.5,
    "I'm good, thanks for asking.",
    '不用了（我这样挺好），谢谢询问。',
    1,
    [
      new HighlightWord(
        "I'm good",
        '/aɪm ɡʊd/',
        '不用了 / 我不需要（礼貌拒绝）',
        '我很好',
        "别总说 No! 老外被问还要不要更多咖啡/加餐时，'I'm good' 最地道自然。"
      )
    ],
    [
      new PhoneticRule(
        'weakening',
        '弱读',
        'for',
        '/fər/',
        '介词 for 在非句尾时极度弱读为 /fər/，一闪而过，几乎听不到字母 o 的发音。'
      )
    ]
  ),
  new EchoCard(
    'echo_004',
    'movie',
    '《穿普拉达的女王》(The Devil Wears Prada)',
    '上司交代紧急任务，你要立刻着手办理',
    'https://dict.youdao.com/dictvoice?audio=I%27m+on+it+right+away.&type=2',
    2.4,
    "I'm on it right away.",
    '我这就去办，马上搞定！',
    2,
    [
      new HighlightWord(
        'on it',
        '/ɒn ɪt/',
        '正在处理 / 在办了',
        '',
        "职场、电影中表达执行力最强的一句话，比 'I will do it' 生动十倍。"
      ),
      new HighlightWord(
        'right away',
        '/raɪt əˈweɪ/',
        '立刻；马上',
        '',
        '固定副词短语，强化紧迫感。'
      )
    ],
    [
      new PhoneticRule(
        'linking',
        '两连读',
        "I'm on it",
        '/aɪ-mɒ-nɪt/',
        "三词连环贯通：I'm 的 m 连 on 的 o，on 的 n 连 it 的 i，听起来像一个词 'aimonit'。"
      )
    ]
  ),
  new EchoCard(
    'echo_005',
    'movie',
    '《心灵捕手》(Good Will Hunting)',
    '朋友向你道歉或为某事内疚，你真诚宽慰对方时',
    'https://dict.youdao.com/dictvoice?audio=It%27s+not+your+fault+at+all.&type=2',
    3.0,
    "It's not your fault at all.",
    '这根本不是你的错，一点也不是。',
    2,
    [
      new HighlightWord(
        'fault',
        '/fɔːlt/',
        '过错；过失',
        '缺陷/故障',
        "not someone's fault 经典安慰表达。"
      ),
      new HighlightWord(
        'at all',
        '/æt ɔːl/',
        '根本；丝毫（用于否定句加强语气）',
        '',
        '否定句末尾强调，彻底打消顾虑。'
      )
    ],
    [
      new PhoneticRule(
        'linking',
        '连读变音',
        'at all',
        '/ə-ˈdɔːl/',
        '美音经典 Flap T：at 词尾辅音 /t/ 夹在元音之间，软化为弹舌音 /d/，听起来像 adall。'
      )
    ]
  ),
  new EchoCard(
    'echo_006',
    'daily',
    '美式咖啡厅现场',
    '在吧台点咖啡，想要外带边走边喝',
    'https://dict.youdao.com/dictvoice?audio=Can+I+get+an+iced+latte+to+go%3F&type=2',
    3.5,
    'Can I get an iced latte to go?',
    '来一杯冰拿铁打包带走可以吗？',
    2,
    [
      new HighlightWord(
        'get',
        '/ɡet/',
        '买；要；来一份',
        '得到/到达',
        '点单时最地道的万能动词是 Can I get...，比 Can I have 更接地气。'
      ),
      new HighlightWord(
        'to go',
        '/tə ɡoʊ/',
        '外带；打包带走',
        '',
        '美语中打包直接说 to go，堂食是 for here。'
      )
    ],
    [
      new PhoneticRule(
        'linking',
        '连读',
        'Can I',
        '/kæ-naɪ/',
        'Can 的 /n/ 与 I 的 /aɪ/ 紧密咬合发成 /naɪ/。'
      ),
      new PhoneticRule(
        'weakening',
        '弱读',
        'to',
        '/tə/',
        '不定式 to 极少重读，弱化为模糊元音 /tə/。'
      )
    ]
  )
];
