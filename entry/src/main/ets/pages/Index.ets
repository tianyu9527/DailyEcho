import { EchoCard, DailyStudyRecord } from '../model/EchoCardModel';
import { SEED_ECHO_CARDS } from '../common/constants/SeedData';
import { StorageManager } from '../common/utils/StorageManager';
import { EchoStudyCard } from '../components/EchoStudyCard';
import promptAction from '@ohos.promptAction';

/**
 * DailyEcho 主页面
 * 包含：今日目标进度、卡片 Swiper 滑动、达成礼花、自由加餐流
 */
@Entry
@Component
struct Index {
  @State cards: EchoCard[] = SEED_ECHO_CARDS;
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

  async aboutToAppear() {
    await this.storageManager.init(getContext(this));
    this.studyRecord = await this.storageManager.getDailyRecord();
  }

  build() {
    Column() {
      // 1. 顶部 Header：极简打卡状态与坚持天数
      this.HeaderBar()

      // 2. 核心内容区域：卡片滑动 / 目标达成界面
      if (!this.studyRecord.isTargetCompleted || this.isBingeMode) {
        // 卡片学习流
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
   * 顶部栏：连续天数与今日进度条
   */
  @Builder
  HeaderBar() {
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

      // 累计掌握徽章
      Row({ space: 4 }) {
        Text('🎧')
          .fontSize(14)
        Text(`已磨耳 ${this.studyRecord.totalCardsMastered} 句`)
          .fontSize(12)
          .fontColor('#38BDF8')
      }
      .padding({ left: 10, right: 10, top: 6, bottom: 6 })
      .backgroundColor('#1038BDF8')
      .borderRadius(14)
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 40, bottom: 12 })
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

      Button('我有余力，继续自由加餐 ➔')
        .fontSize(15)
        .fontWeight(FontWeight.SemiBold)
        .fontColor(Color.White)
        .backgroundColor('#6366F1')
        .height(46)
        .width('75%')
        .borderRadius(23)
        .margin({ bottom: 40 })
        .onClick(() => {
          this.isBingeMode = true;
          this.currentIndex = 2; // 跳到下一张
        })
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
      Text('💡 每日 1~2 张卡片 · 沉浸盲听 · 无需死记硬背')
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
