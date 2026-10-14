import { DeepSeekService } from '../common/utils/DeepSeekService';
import { StorageManager } from '../common/utils/StorageManager';
import { EchoCard } from '../model/EchoCardModel';
import promptAction from '@ohos.promptAction';

/**
 * AI 电影库生成与 DeepSeek 密钥配置弹窗
 */
@CustomDialog
export struct AiMovieGeneratorDialog {
  controller: CustomDialogController;
  @State apiKey: string = '';
  @State movieTitle: string = '';
  @State cardCount: number = 5;
  @State isLoading: boolean = false;
  @State statusTip: string = '';

  private storageManager = StorageManager.getInstance();
  private deepSeekService = DeepSeekService.getInstance();

  onSuccessGenerated: (cards: EchoCard[], movieTitle: string) => void = () => {};

  async aboutToAppear() {
    this.apiKey = await this.storageManager.getDeepSeekApiKey();
  }

  build() {
    Column({ space: 16 }) {
      // 标题栏
      Row() {
        Text('🎬 AI 电影原声语料生成')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)

        Blank()

        Text('✕')
          .fontSize(18)
          .fontColor('#94A3B8')
          .onClick(() => {
            this.controller.close();
          })
      }
      .width('100%')

      Text('输入任意想看的英文电影或美剧，AI 将自动检索经典对白，并深度拆解连读、弱读与发音要点。')
        .fontSize(13)
        .fontColor('#94A3B8')
        .width('100%')

      // DeepSeek API 密钥输入
      Column({ space: 6 }) {
        Row() {
          Text('DeepSeek API Key')
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .fontColor('#E2E8F0')

          Blank()

          Text(this.apiKey ? '✓ 已保存' : '必填')
            .fontSize(11)
            .fontColor(this.apiKey ? '#10B981' : '#F59E0B')
        }
        .width('100%')

        TextInput({ placeholder: 'sk-xxxxxxxxxxxxxxxxxxxx', text: this.apiKey })
          .type(InputType.Password)
          .placeholderColor('#64748B')
          .fontColor(Color.White)
          .backgroundColor('#0B0F19')
          .borderRadius(10)
          .height(42)
          .onChange((value: string) => {
            this.apiKey = value;
          })
      }
      .width('100%')

      // 电影/美剧名称输入
      Column({ space: 6 }) {
        Text('想学习的电影 / 美剧名')
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor('#E2E8F0')
          .width('100%')

        TextInput({ placeholder: '例如：星际穿越、老友记、肖申克的救赎...', text: this.movieTitle })
          .placeholderColor('#64748B')
          .fontColor(Color.White)
          .backgroundColor('#0B0F19')
          .borderRadius(10)
          .height(42)
          .onChange((value: string) => {
            this.movieTitle = value;
          })
      }
      .width('100%')

      // 生成数量快捷选择
      Row({ space: 10 }) {
        Text('生成卡片数量：')
          .fontSize(13)
          .fontColor('#94A3B8')

        Button('3 句')
          .fontSize(12)
          .height(30)
          .fontColor(this.cardCount === 3 ? Color.White : '#94A3B8')
          .backgroundColor(this.cardCount === 3 ? '#6366F1' : '#0B0F19')
          .onClick(() => { this.cardCount = 3; })

        Button('5 句')
          .fontSize(12)
          .height(30)
          .fontColor(this.cardCount === 5 ? Color.White : '#94A3B8')
          .backgroundColor(this.cardCount === 5 ? '#6366F1' : '#0B0F19')
          .onClick(() => { this.cardCount = 5; })

        Button('8 句')
          .fontSize(12)
          .height(30)
          .fontColor(this.cardCount === 8 ? Color.White : '#94A3B8')
          .backgroundColor(this.cardCount === 8 ? '#6366F1' : '#0B0F19')
          .onClick(() => { this.cardCount = 8; })
      }
      .width('100%')

      if (this.isLoading) {
        Column({ space: 8 }) {
          LoadingProgress()
            .color('#6366F1')
            .width(36)
            .height(36)
          Text(this.statusTip || 'AI 正在深度检索对白并拆解连读技巧...')
            .fontSize(12)
            .fontColor('#38BDF8')
        }
        .width('100%')
        .margin({ top: 10, bottom: 10 })
      }

      // 底部操作按钮
      Row({ space: 12 }) {
        Button('取消')
          .fontSize(14)
          .fontColor('#94A3B8')
          .backgroundColor('#0B0F19')
          .height(42)
          .layoutWeight(1)
          .borderRadius(21)
          .enabled(!this.isLoading)
          .onClick(() => {
            this.controller.close();
          })

        Button(this.isLoading ? '正在生成...' : '立即生成专属语料 🚀')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .backgroundColor('#6366F1')
          .height(42)
          .layoutWeight(2)
          .borderRadius(21)
          .enabled(!this.isLoading)
          .onClick(() => {
            this.handleGenerate();
          })
      }
      .width('100%')
      .margin({ top: 10 })
    }
    .width('90%')
    .padding(24)
    .backgroundColor('#1E293B')
    .borderRadius(24)
  }

  /**
   * 触发生成
   */
  private async handleGenerate() {
    if (!this.apiKey || this.apiKey.trim() === '') {
      promptAction.showToast({ message: '请先填写 DeepSeek API Key' });
      return;
    }
    if (!this.movieTitle || this.movieTitle.trim() === '') {
      promptAction.showToast({ message: '请输入想学习的电影名称' });
      return;
    }

    this.isLoading = true;
    this.statusTip = `正在唤醒 DeepSeek 提取《${this.movieTitle}》台词...`;

    try {
      // 1. 保存 API Key
      await this.storageManager.setDeepSeekApiKey(this.apiKey);

      // 2. 调用 DeepSeek 服务生成卡片
      const cards = await this.deepSeekService.generateCardsForMovie(
        this.apiKey,
        this.movieTitle.trim(),
        this.cardCount
      );

      // 3. 持久化存储到自定义电影库
      await this.storageManager.saveCustomCards(cards, this.movieTitle.trim());

      promptAction.showToast({
        message: `🎉 成功生成 ${cards.length} 张《${this.movieTitle}》原声卡片！`,
        duration: 2000
      });

      this.onSuccessGenerated(cards, this.movieTitle.trim());
      this.controller.close();
    } catch (e) {
      const err = e as Error;
      promptAction.showToast({
        message: `生成失败: ${err.message || '网络或格式错误'}`,
        duration: 3000
      });
    } finally {
      this.isLoading = false;
    }
  }
}
