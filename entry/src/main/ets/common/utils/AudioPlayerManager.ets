import media from '@ohos.multimedia.media';
import hilog from '@ohos.hilog';

const TAG = 'AudioPlayerManager';
const DOMAIN = 0x0001;

/**
 * 鸿蒙原生音频播放管理器封装（基于 AVPlayer）
 * 支持：网络/本地音频极速加载、0.8x/1.0x 调速播放、单曲循环、播放状态监听
 */
export class AudioPlayerManager {
  private static instance: AudioPlayerManager | null = null;
  private avPlayer: media.AVPlayer | null = null;
  private currentUrl: string = '';
  private currentSpeed: number = 1.0;
  private isPrepared: boolean = false;
  private onStateChangeCallback: ((state: string) => void) | null = null;
  private onTimeUpdateCallback: ((currentMs: number, totalMs: number) => void) | null = null;

  private constructor() {}

  public static getInstance(): AudioPlayerManager {
    if (!AudioPlayerManager.instance) {
      AudioPlayerManager.instance = new AudioPlayerManager();
    }
    return AudioPlayerManager.instance;
  }

  /**
   * 初始化并创建底层 AVPlayer 实例
   */
  public async init(): Promise<void> {
    if (this.avPlayer) {
      return;
    }
    try {
      this.avPlayer = await media.createAVPlayer();
      this.bindEvents();
      hilog.info(DOMAIN, TAG, 'AVPlayer initialized successfully');
    } catch (e) {
      hilog.error(DOMAIN, TAG, `Failed to create AVPlayer: ${JSON.stringify(e)}`);
    }
  }

  /**
   * 绑定底层 AVPlayer 状态机事件
   */
  private bindEvents(): void {
    if (!this.avPlayer) return;

    this.avPlayer.on('stateChange', async (state: media.AVPlayerState) => {
      hilog.info(DOMAIN, TAG, `AVPlayer state changed to: ${state}`);
      if (this.onStateChangeCallback) {
        this.onStateChangeCallback(state);
      }

      switch (state) {
        case 'idle':
          this.isPrepared = false;
          break;
        case 'initialized':
          if (this.avPlayer) {
            try {
              await this.avPlayer.prepare();
            } catch (err) {
              hilog.error(DOMAIN, TAG, `prepare error: ${JSON.stringify(err)}`);
            }
          }
          break;
        case 'prepared':
          this.isPrepared = true;
          // 准备好后直接开播
          if (this.avPlayer) {
            try {
              if (this.currentSpeed !== 1.0) {
                const targetSpeed = this.currentSpeed <= 0.8 ? media.PlaybackSpeed.SPEED_FORWARD_0_75_X : media.PlaybackSpeed.SPEED_FORWARD_1_00_X;
                await this.avPlayer.setSpeed(targetSpeed);
              }
              await this.avPlayer.play();
            } catch (err) {
              hilog.error(DOMAIN, TAG, `play error: ${JSON.stringify(err)}`);
            }
          }
          break;
        case 'playing':
          break;
        case 'paused':
          break;
        case 'completed':
          this.isPrepared = true;
          break;
        case 'stopped':
          break;
        case 'released':
          this.isPrepared = false;
          break;
        case 'error':
          this.isPrepared = false;
          break;
      }
    });

    this.avPlayer.on('timeUpdate', (timeMs: number) => {
      if (this.onTimeUpdateCallback && this.avPlayer) {
        this.onTimeUpdateCallback(timeMs, this.avPlayer.duration);
      }
    });

    this.avPlayer.on('error', (err) => {
      hilog.error(DOMAIN, TAG, `AVPlayer error event: code=${err.code}, msg=${err.message}`);
      if (this.avPlayer) {
        try {
          this.avPlayer.reset();
        } catch (_) {}
      }
    });
  }

  /**
   * 播放指定音频链接（支持可选倍速）
   */
  public async playUrl(url: string, speed: number = 1.0): Promise<void> {
    await this.init();
    if (!this.avPlayer) return;

    this.currentSpeed = speed;

    try {
      if (this.currentUrl === url && this.isPrepared) {
        if (this.avPlayer.state === 'paused' || this.avPlayer.state === 'completed') {
          await this.setSpeed(speed);
          await this.avPlayer.play();
          return;
        }
      }

      this.currentUrl = url;
      await this.avPlayer.reset();
      this.avPlayer.url = url;
    } catch (e) {
      hilog.error(DOMAIN, TAG, `Failed to playUrl: ${JSON.stringify(e)}`);
    }
  }

  /**
   * 暂停
   */
  public async pause(): Promise<void> {
    if (this.avPlayer && this.avPlayer.state === 'playing') {
      try {
        await this.avPlayer.pause();
      } catch (err) {
        hilog.error(DOMAIN, TAG, `pause error: ${JSON.stringify(err)}`);
      }
    }
  }

  /**
   * 停止
   */
  public async stop(): Promise<void> {
    if (this.avPlayer) {
      try {
        await this.avPlayer.stop();
      } catch (err) {
        hilog.error(DOMAIN, TAG, `stop error: ${JSON.stringify(err)}`);
      }
    }
  }

  /**
   * 设置播放倍速
   */
  public async setSpeed(speed: number): Promise<void> {
    if (this.avPlayer && this.isPrepared) {
      try {
        const targetSpeed = speed <= 0.8 ? media.PlaybackSpeed.SPEED_FORWARD_0_75_X : media.PlaybackSpeed.SPEED_FORWARD_1_00_X;
        await this.avPlayer.setSpeed(targetSpeed);
      } catch (err) {
        hilog.error(DOMAIN, TAG, `setSpeed error: ${JSON.stringify(err)}`);
      }
    }
  }

  /**
   * 监听播放状态
   */
  public setOnStateChange(cb: (state: string) => void): void {
    this.onStateChangeCallback = cb;
  }

  /**
   * 监听时间进度
   */
  public setOnTimeUpdate(cb: (currentMs: number, totalMs: number) => void): void {
    this.onTimeUpdateCallback = cb;
  }

  /**
   * 释放资源
   */
  public async release(): Promise<void> {
    if (this.avPlayer) {
      try {
        await this.avPlayer.release();
      } catch (err) {
        hilog.error(DOMAIN, TAG, `release error: ${JSON.stringify(err)}`);
      }
      this.avPlayer = null;
      this.isPrepared = false;
    }
  }
}
