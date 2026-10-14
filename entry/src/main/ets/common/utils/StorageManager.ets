import preferences from '@ohos.data.preferences';
import { DailyStudyRecord, EchoCard } from '../model/EchoCardModel';
import hilog from '@ohos.hilog';

const PREF_NAME = 'daily_echo_storage';
const KEY_RECORD = 'study_record';
const KEY_DEEPSEEK_KEY = 'deepseek_api_key';
const KEY_CUSTOM_CARDS = 'custom_movie_cards';
const KEY_ACTIVE_MOVIE = 'active_movie_title';

const TAG = 'StorageManager';
const DOMAIN = 0x0002;

/**
 * 用户本地打卡与学习进度持久化管理器
 * 支持：学习进度、DeepSeek API Key、自定义电影卡片库
 */
export class StorageManager {
  private static instance: StorageManager | null = null;
  private pref: preferences.Preferences | null = null;

  private constructor() {}

  public static getInstance(): StorageManager {
    if (!StorageManager.instance) {
      StorageManager.instance = new StorageManager();
    }
    return StorageManager.instance;
  }

  /**
   * 初始化偏好存储
   */
  public async init(context: Context): Promise<void> {
    try {
      this.pref = await preferences.getPreferences(context, PREF_NAME);
    } catch (e) {
      hilog.error(DOMAIN, TAG, `Failed to get preferences: ${JSON.stringify(e)}`);
    }
  }

  /**
   * 保存 DeepSeek API Key
   */
  public async setDeepSeekApiKey(key: string): Promise<void> {
    if (!this.pref) return;
    try {
      await this.pref.put(KEY_DEEPSEEK_KEY, key.trim());
      await this.pref.flush();
    } catch (e) {
      hilog.error(DOMAIN, TAG, `Failed to save DeepSeek key: ${JSON.stringify(e)}`);
    }
  }

  /**
   * 获取保存的 DeepSeek API Key
   */
  public async getDeepSeekApiKey(): Promise<string> {
    if (!this.pref) return '';
    try {
      const key = await this.pref.get(KEY_DEEPSEEK_KEY, '');
      return key as string;
    } catch (e) {
      return '';
    }
  }

  /**
   * 保存用户通过 AI 生成的自定义卡片列表
   */
  public async saveCustomCards(cards: EchoCard[], movieTitle: string): Promise<void> {
    if (!this.pref) return;
    try {
      await this.pref.put(KEY_CUSTOM_CARDS, JSON.stringify(cards));
      await this.pref.put(KEY_ACTIVE_MOVIE, movieTitle);
      await this.pref.flush();
    } catch (e) {
      hilog.error(DOMAIN, TAG, `Failed to save custom cards: ${JSON.stringify(e)}`);
    }
  }

  /**
   * 读取自定义卡片列表
   */
  public async getCustomCards(): Promise<{ cards: EchoCard[]; movieTitle: string }> {
    if (!this.pref) return { cards: [], movieTitle: '' };
    try {
      const rawCards = await this.pref.get(KEY_CUSTOM_CARDS, '[]');
      const movieTitle = await this.pref.get(KEY_ACTIVE_MOVIE, '');
      const cards: EchoCard[] = JSON.parse(rawCards as string);
      return { cards, movieTitle: movieTitle as string };
    } catch (e) {
      return { cards: [], movieTitle: '' };
    }
  }

  /**
   * 清除自定义电影库，恢复默认内置精选库
   */
  public async clearCustomCards(): Promise<void> {
    if (!this.pref) return;
    try {
      await this.pref.delete(KEY_CUSTOM_CARDS);
      await this.pref.delete(KEY_ACTIVE_MOVIE);
      await this.pref.flush();
    } catch (e) {
      hilog.error(DOMAIN, TAG, `Failed to clear custom cards: ${JSON.stringify(e)}`);
    }
  }

  /**
   * 获取今日日期字符串 YYYY-MM-DD
   */
  public getTodayString(): string {
    const d = new Date();
    const year = d.getFullYear();
    const month = (d.getMonth() + 1).toString().padStart(2, '0');
    const day = d.getDate().toString().padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  /**
   * 读取当天的打卡记录
   */
  public async getDailyRecord(): Promise<DailyStudyRecord> {
    const today = this.getTodayString();
    const defaultRecord: DailyStudyRecord = {
      date: today,
      completedCardIds: [],
      streakDays: 1,
      isTargetCompleted: false,
      totalCardsMastered: 0
    };

    if (!this.pref) return defaultRecord;

    try {
      const raw = await this.pref.get(KEY_RECORD, JSON.stringify(defaultRecord));
      const record: DailyStudyRecord = JSON.parse(raw as string);

      // 如果跨天了，刷新打卡状态
      if (record.date !== today) {
        const yesterday = new Date(Date.now() - 24 * 3600 * 1000).toISOString().split('T')[0];
        const newStreak = record.date === yesterday && record.isTargetCompleted ? record.streakDays + 1 : 1;

        const newDayRecord: DailyStudyRecord = {
          date: today,
          completedCardIds: [],
          streakDays: newStreak,
          isTargetCompleted: false,
          totalCardsMastered: record.totalCardsMastered
        };
        await this.saveDailyRecord(newDayRecord);
        return newDayRecord;
      }

      return record;
    } catch (e) {
      return defaultRecord;
    }
  }

  /**
   * 标记完成一张卡片（达到 2 张触发完成）
   */
  public async markCardCompleted(cardId: string): Promise<DailyStudyRecord> {
    const record = await this.getDailyRecord();
    if (!record.completedCardIds.includes(cardId)) {
      record.completedCardIds.push(cardId);
      record.totalCardsMastered += 1;
    }
    if (record.completedCardIds.length >= 2) {
      record.isTargetCompleted = true;
    }
    await this.saveDailyRecord(record);
    return record;
  }

  /**
   * 保存打卡记录
   */
  private async saveDailyRecord(record: DailyStudyRecord): Promise<void> {
    if (!this.pref) return;
    try {
      await this.pref.put(KEY_RECORD, JSON.stringify(record));
      await this.pref.flush();
    } catch (e) {
      hilog.error(DOMAIN, TAG, `Failed to save preferences: ${JSON.stringify(e)}`);
    }
  }
}
