import http from '@ohos.net.http';
import { EchoCard, HighlightWord, PhoneticRule } from '../../model/EchoCardModel';
import hilog from '@ohos.hilog';

const TAG = 'DeepSeekService';
const DOMAIN = 0x0003;

export class DeepSeekMessage {
  role: string = '';
  content: string = '';

  constructor(role: string, content: string) {
    this.role = role;
    this.content = content;
  }
}

export class DeepSeekResponseFormat {
  type: string = 'json_object';

  constructor(type: string = 'json_object') {
    this.type = type;
  }
}

export class DeepSeekRequestBody {
  model: string = 'deepseek-chat';
  messages: DeepSeekMessage[] = [];
  temperature: number = 0.7;
  response_format: DeepSeekResponseFormat = new DeepSeekResponseFormat();

  constructor(model: string, messages: DeepSeekMessage[], temperature: number, response_format: DeepSeekResponseFormat) {
    this.model = model;
    this.messages = messages;
    this.temperature = temperature;
    this.response_format = response_format;
  }
}

export class DeepSeekChoiceMessage {
  content: string = '';
}

export class DeepSeekChoice {
  message: DeepSeekChoiceMessage = new DeepSeekChoiceMessage();
}

export class DeepSeekErrorDetail {
  message: string = '';
  type: string = '';
  code: string = '';
}

export class DeepSeekResponse {
  choices: DeepSeekChoice[] = [];
  error: DeepSeekErrorDetail | null = null;
}

export class RawKeywordItem {
  word: string = '';
  phonetic: string = '';
  meaning: string = '';
  rootMeaning: string = '';
  usageNote: string = '';
}

export class RawPhoneticRuleItem {
  type: string = '';
  typeLabel: string = '';
  chunk: string = '';
  pronunciation: string = '';
  explanation: string = '';
}

export class RawCardItem {
  sceneDescription: string = '';
  englishSentence: string = '';
  chineseTranslation: string = '';
  difficultyLevel: number = 1;
  keywords: RawKeywordItem[] = [];
  phoneticBreakdown: RawPhoneticRuleItem[] = [];
}

export class RawCardResponse {
  cards: RawCardItem[] = [];
}

/**
 * DeepSeek 电影原声语料生成服务
 */
export class DeepSeekService {
  private static instance: DeepSeekService | null = null;
  private readonly API_URL = 'https://api.deepseek.com/chat/completions';

  private constructor() {}

  public static getInstance(): DeepSeekService {
    if (!DeepSeekService.instance) {
      DeepSeekService.instance = new DeepSeekService();
    }
    return DeepSeekService.instance;
  }

  /**
   * 根据电影名调用 DeepSeek 生成学习卡片
   */
  public async generateCardsForMovie(apiKey: string, movieTitle: string, count: number = 5): Promise<EchoCard[]> {
    if (!apiKey || apiKey.trim() === '') {
      throw new Error('请先在设置中填写 DeepSeek API 密钥');
    }

    const systemPrompt = `你是一位专注于英语影视听力和口语教学的专家，专为“听懂真实电影与生活口语”设计学习卡片。
你的任务是：根据用户指定的英文电影或剧集名称，检索或生成该电影中最具代表性、最地道实用的 ${count} 句经典对白或日常口语。
请严格分析每句话中的发音技巧（影视听不懂的根本原因：连读、弱读、同化、失爆等）以及重点单词在语境中的准确含义。

必须严格返回 JSON 格式，根节点为 {"cards": [...]}，格式如下：
{
  "cards": [
    {
      "sceneDescription": "电影中该对白发生的生动场景描述（10~25字）",
      "englishSentence": "英文原句（3~10个单词，口语化强）",
      "chineseTranslation": "中文地道翻译",
      "difficultyLevel": 1,
      "keywords": [
        {
          "word": "重点词或短语",
          "phonetic": "/音标/",
          "meaning": "在该句子里的具体含义",
          "rootMeaning": "常见字面基础含义",
          "usageNote": "口语语境用法提示"
        }
      ],
      "phoneticBreakdown": [
        {
          "type": "linking",
          "typeLabel": "连读",
          "chunk": "两个相邻单词",
          "pronunciation": "/连读后的实际发音/",
          "explanation": "为什么这样发音，老外电影里为什么会听成这样"
        }
      ]
    }
  ]
}
注意：
1. 只要纯 JSON，不要包含任何 markdown 围栏字符（如 \`\`\`json ），不要有多余解释。
2. 选取的句子必须是电影中真实或高度风格吻合的地道表达，利于盲听磨耳。`;

    const userPrompt = `请为电影/美剧《${movieTitle}》生成 ${count} 张极简原声磨耳学习卡片。`;

    const messages: DeepSeekMessage[] = [
      new DeepSeekMessage('system', systemPrompt),
      new DeepSeekMessage('user', userPrompt)
    ];
    const requestBody = new DeepSeekRequestBody(
      'deepseek-chat',
      messages,
      0.7,
      new DeepSeekResponseFormat('json_object')
    );

    const httpRequest = http.createHttp();

    try {
      const response = await httpRequest.request(this.API_URL, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${apiKey.trim()}`
        },
        extraData: JSON.stringify(requestBody),
        readTimeout: 60000,
        connectTimeout: 30000
      });

      if (response.responseCode !== 200) {
        hilog.error(DOMAIN, TAG, `DeepSeek API failed with code ${response.responseCode}: ${response.result}`);
        let errDesc = `请求失败 (状态码: ${response.responseCode})`;
        try {
          const errObj: DeepSeekResponse = JSON.parse(response.result as string);
          if (errObj.error && errObj.error.message) {
            errDesc = errObj.error.message;
          }
        } catch (_) {}
        throw new Error(errDesc);
      }

      const resultObj: DeepSeekResponse = JSON.parse(response.result as string);
      if (!resultObj.choices || resultObj.choices.length === 0) {
        throw new Error('DeepSeek 返回内容为空');
      }

      const rawContent = resultObj.choices[0].message.content.trim();
      hilog.info(DOMAIN, TAG, `DeepSeek raw response: ${rawContent}`);

      // 清理可能包含的 Markdown 标记
      let cleanJson = rawContent;
      if (cleanJson.startsWith('```json')) {
        cleanJson = cleanJson.replace(/^```json\s*/, '').replace(/\s*```$/, '');
      } else if (cleanJson.startsWith('```')) {
        cleanJson = cleanJson.replace(/^```\s*/, '').replace(/\s*```$/, '');
      }

      const parsed: RawCardResponse = JSON.parse(cleanJson);
      if (!parsed.cards || parsed.cards.length === 0) {
        throw new Error('未成功解析出卡片数据，请重试');
      }

      // 将 raw 转换为标准 EchoCard 结构，并挂接发音音频
      const timestamp = new Date().getTime();
      const generatedCards: EchoCard[] = [];

      for (let i = 0; i < parsed.cards.length; i++) {
        const item = parsed.cards[i];
        const encodedSentence = encodeURIComponent(item.englishSentence);
        const audioUrl = `https://dict.youdao.com/dictvoice?audio=${encodedSentence}&type=2`;

        const kwList: HighlightWord[] = [];
        if (item.keywords && item.keywords.length > 0) {
          for (let k = 0; k < item.keywords.length; k++) {
            const kw = item.keywords[k];
            kwList.push(new HighlightWord(
              kw.word,
              kw.phonetic,
              kw.meaning,
              kw.rootMeaning || '',
              kw.usageNote || ''
            ));
          }
        }

        const pbList: PhoneticRule[] = [];
        if (item.phoneticBreakdown && item.phoneticBreakdown.length > 0) {
          for (let p = 0; p < item.phoneticBreakdown.length; p++) {
            const pb = item.phoneticBreakdown[p];
            pbList.push(new PhoneticRule(
              pb.type || 'linking',
              pb.typeLabel || '连读',
              pb.chunk || '',
              pb.pronunciation || '',
              pb.explanation || ''
            ));
          }
        }

        const card = new EchoCard(
          `ai_${timestamp}_${i + 1}`,
          'movie',
          `《${movieTitle}》`,
          item.sceneDescription || '电影原声对白',
          audioUrl,
          Math.max(2.5, item.englishSentence.split(' ').length * 0.4),
          item.englishSentence,
          item.chineseTranslation,
          item.difficultyLevel || 2,
          kwList,
          pbList
        );
        generatedCards.push(card);
      }

      return generatedCards;
    } catch (err) {
      hilog.error(DOMAIN, TAG, `DeepSeek request error: ${JSON.stringify(err)}`);
      if (err instanceof Error) {
        throw err;
      }
      throw new Error(`生成失败: ${JSON.stringify(err)}`);
    } finally {
      httpRequest.destroy();
    }
  }
}
