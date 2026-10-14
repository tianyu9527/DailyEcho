import { EchoCard, DailyStudyRecord } from '../model/EchoCardModel';
import { SEED_ECHO_CARDS } from '../common/constants/SeedData';
import { StorageManager } from '../common/utils/StorageManager';
import { EchoStudyCard } from '../components/EchoStudyCard';
import { AiMovieGeneratorDialog } from '../components/AiMovieGeneratorDialog';
import promptAction from '@ohos.promptAction';

/**
 * DailyEcho 主页面
 * 包含：今日目标进度、卡片 Swiper 滑动、达成礼花、自由加餐流、AI电影语料库定制
 */
@Entry
@Component
struct Index {
  @State cards: EchoCard[] = SEED_ECHO_CARDS;
  @State currentMovieTitle: string = '精选原声与日常';
  @State currentIndex: number = 0;
  @State studyRecord: DailyStudyRecord = {
    date: '',
    completedCardIds: [],
    streakDays: 1,
    isTargetCompleted: false,
    totalCardsMastered: 0
  };
  @State isBingeMode: boolean = false; // 是否开启“无压加餐”模式

  private storageManager = StorageManager.getInstance();

  // 弹窗控制器
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: AiMovieGeneratorDialog({
      onSuccessGenerated: (newCards: EchoCard[], movieTitle: string) => {
        this.cards = newCards;
        this.currentMovieTitle = `《${movieTitle}》原声`;
        this.currentIndex = 0;
        this.isBingeMode = true; // 换库后直接可以刷题
      }
    }),
    alignment: DialogAlignment.Center,
    customStyle: true,
    autoCancel: true
  });

  async aboutToAppear() {
    await this.storageManager.init(getContext(this));
    this.studyRecord = await this.storageManager.getDailyRecord();

    // 加载自定义电影库（若有）
    const customData = await this.storageManager.getCustomCards();
    if (customData.cards && customData.cards.length > 0) {
      this.cards = customData.cards;
      this.currentMovieTitle = `《${customData.movieTitle}》原声`;
    }
  }

  build() {
    Column() {
      // 1. 顶部 Header：打卡状态、电影主题与 AI 生成按钮
      this.HeaderBar()

      // 2. 核心内容区域：卡片滑动 / 目标达成界面
      if (!this.studyRecord.isTargetCompleted || this.isBingeMode) {
        Column() {
          Swiper() {
            ForEach(this.cards, (card: EchoCard, index: number) => {
              EchoStudyCard({
                card: card,
                onCardCompleted: () => {
                  this.handleCardComplete(card.id);
                }
              })
            })
          }
          .index(this.currentIndex)
          .indicator(false)
          .loop(false)
          .onChange((index: number) => {
            this.currentIndex = index;
          })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        // 今日目标达成胜利界面（极低无压体验）
        this.CelebrationView()
      }

      // 3. 底部轻提示与操作
      this.BottomBar()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0B0F19')
  }

  /**
   * 顶部栏：连续天数、当前电影库与 AI 按钮
   */
  @Builder
  HeaderBar() {
    Column({ space: 8 }) {
      Row() {
        Column({ space: 4 }) {
          Row({ space: 6 }) {
            Text('🔥')
              .fontSize(18)
            Text(`连续 ${this.studyRecord.streakDays} 天`)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#F8FAFC')
          }

          Text(this.isBingeMode ? '无限自由加餐中...' : `今日计划：${Math.min(this.studyRecord.completedCardIds.length, 2)} / 2 张卡片`)
            .fontSize(12)
            .fontColor('#94A3B8')
        }
        .alignItems(HorizontalAlign.Start)

        Blank()

        // AI 电影生成入口按钮
        Button('✨ 找电影学')
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
          .backgroundColor('#6366F1')
          .height(34)
          .borderRadius(17)
          .padding({ left: 14, right: 14 })
          .onClick(() => {
            this.dialogController.open();
          })
      }
      .width('100%')

      // 当前语料库来源标签
      Row({ space: 6 }) {
        Text(`当前语料：${this.currentMovieTitle}`)
          .fontSize(12)
          .fontColor('#38BDF8')

        if (this.currentMovieTitle !== '精选原声与日常') {
          Text('⟲ 还原精选库')
            .fontSize(11)
            .fontColor('#94A3B8')
            .onClick(async () => {
              await this.storageManager.clearCustomCards();
              this.cards = SEED_ECHO_CARDS;
              this.currentMovieTitle = '精选原声与日常';
              this.currentIndex = 0;
              promptAction.showToast({ message: '已切回默认精选影视库' });
            })
        }
      }
      .width('100%')
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 40, bottom: 8 })
  }

  /**
   * 今日目标达成提示视图（拒绝压力，完成即止）
   */
  @Builder
  CelebrationView() {
    Column({ space: 20 }) {
      Text('🎉')
        .fontSize(64)
        .margin({ top: 30 })

      Text('今日 3 分钟盲听磨耳已达成！')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)

      Text('好习惯贵在微小与坚持。今天的大脑已经吸收了地道原声，无压收工吧！')
        .fontSize(14)
        .fontColor('#94A3B8')
        .textAlign(TextAlign.Center)
        .padding({ left: 30, right: 30 })

      Blank()

      Row({ space: 12 }) {
        Button('✨ 换部电影学')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#E2E8F0')
          .backgroundColor('#1E293B')
          .height(44)
          .borderRadius(22)
          .layoutWeight(1)
          .onClick(() => {
            this.dialogController.open();
          })

        Button('自由加餐 ➔')
          .fontSize(14)
          .fontWeight(FontWeight.SemiBold)
          .fontColor(Color.White)
          .backgroundColor('#6366F1')
          .height(44)
          .borderRadius(22)
          .layoutWeight(1)
          .onClick(() => {
            this.isBingeMode = true;
            this.currentIndex = 2; // 跳到下一张
          })
      }
      .width('85%')
      .margin({ bottom: 40 })
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  /**
   * 底部状态栏
   */
  @Builder
  BottomBar() {
    Row() {
      Text('💡 每日 1~2 张卡片 · 沉浸盲听 · 支持任意电影 AI 定制')
        .fontSize(12)
        .fontColor('#64748B')
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .padding({ bottom: 20, top: 10 })
  }

  /**
   * 处理卡片完成事件
   */
  private async handleCardComplete(cardId: string) {
    this.studyRecord = await this.storageManager.markCardCompleted(cardId);

    promptAction.showToast({
      message: '✓ 已收录！你的听力耳朵又灵敏了一点',
      duration: 1500
    });

    if (this.currentIndex < this.cards.length - 1) {
      this.currentIndex += 1;
    }
  }
}
