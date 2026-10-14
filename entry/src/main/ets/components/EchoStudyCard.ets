import { EchoCard, HighlightWord, PhoneticRule } from '../model/EchoCardModel';
import { AudioPlayerManager } from '../common/utils/AudioPlayerManager';

/**
 * 极简 3D 翻转无压学习卡片组件
 * 正面：纯盲听磨耳（波形 + 场景 + 慢速切换）
 * 反面：词句对照 + 重点词高亮 + 连读弱读技巧揭秘 + 跟读操作
 */
@Component
export struct EchoStudyCard {
  @Prop card: EchoCard;
  @State isFlipped: boolean = false;       // 是否翻转到背面
  @State isPlaying: boolean = false;       // 是否正在播放
  @State isSlowSpeed: boolean = false;     // 是否 0.8x 慢速磨耳
  @State rotateAngle: number = 0;          // 翻转角度
  private audioManager = AudioPlayerManager.getInstance();

  onCardCompleted: () => void = () => {};

  aboutToAppear() {
    this.audioManager.setOnStateChange((state: string) => {
      this.isPlaying = (state === 'playing');
    });
  }

  build() {
    Stack() {
      if (!this.isFlipped) {
        // 卡片正面：盲听磨耳 (Audio-first)
        this.CardFrontView()
      } else {
        // 卡片背面：词句一体与发音解码
        this.CardBackView()
      }
    }
    .width('92%')
    .height('75%')
    .borderRadius(24)
    .shadow({ radius: 24, color: '#40000000', offsetY: 12 })
    .rotate({
      x: 0,
      y: 1,
      z: 0,
      angle: this.rotateAngle
    })
    .animation({
      duration: 400,
      curve: Curve.EaseInOut
    })
    .onClick(() => {
      // 点击边缘轻量翻转（若不是点击特定按钮）
    })
  }

  /**
   * 正面视图：盲听磨耳
   */
  @Builder
  CardFrontView() {
    Column() {
      // 顶部出处与场景描述
      Row() {
        Text(this.card.sourceTitle)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#F59E0B')
          .padding({ left: 10, right: 10, top: 4, bottom: 4 })
          .backgroundColor('#26F59E0B')
          .borderRadius(12)

        Blank()

        Text(this.card.category === 'movie' ? '影视原声' : '生活口语')
          .fontSize(12)
          .fontColor('#94A3B8')
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 20 })

      // 场景氛围
      Text(this.card.sceneDescription)
        .fontSize(13)
        .fontColor('#64748B')
        .margin({ top: 10, left: 20, right: 20 })
        .textAlign(TextAlign.Start)
        .width('100%')

      Blank()

      // 中心听力波形交互区
      Column({ space: 16 }) {
        Stack({ alignContent: Alignment.Center }) {
          // 动态波形脉冲圈
          Circle()
            .width(this.isPlaying ? 140 : 110)
            .height(this.isPlaying ? 140 : 110)
            .fill('#1E293B')
            .animation({ duration: 500, iterations: -1, curve: Curve.EaseInOut })

          Circle()
            .width(90)
            .height(90)
            .fill('#6366F1')

          Text(this.isPlaying ? '■' : '▶')
            .fontSize(28)
            .fontColor(Color.White)
        }
        .onClick(() => {
          this.togglePlay();
        })

        Text(this.isPlaying ? '正在原声磨耳中...' : '轻触波形，闭眼盲听')
          .fontSize(14)
          .fontColor('#94A3B8')
      }

      Blank()

      // 底部慢速切换与翻转提示
      Row({ space: 12 }) {
        Button(this.isSlowSpeed ? '0.8x 慢速' : '1.0x 原速')
          .fontSize(13)
          .fontColor('#E2E8F0')
          .backgroundColor('#334155')
          .height(36)
          .borderRadius(18)
          .onClick(() => {
            this.isSlowSpeed = !this.isSlowSpeed;
            if (this.isPlaying) {
              this.togglePlay();
            }
          })

        Button('揭晓字幕与解析  ➔')
          .fontSize(14)
          .fontWeight(FontWeight.SemiBold)
          .fontColor(Color.White)
          .backgroundColor('#6366F1')
          .height(38)
          .layoutWeight(1)
          .borderRadius(19)
          .onClick(() => {
            this.flipToBack();
          })
      }
      .width('100%')
      .padding({ left: 20, right: 20, bottom: 24 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0F172A')
    .borderRadius(24)
  }

  /**
   * 背面视图：词句一体与发音解码
   */
  @Builder
  CardBackView() {
    Column() {
      // 顶部出处与回翻
      Row() {
        Text(this.card.sourceTitle)
          .fontSize(13)
          .fontColor('#F59E0B')

        Blank()

        Text('⟲ 回到盲听')
          .fontSize(13)
          .fontColor('#94A3B8')
          .onClick(() => {
            this.flipToFront();
          })
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 16 })

      Scroll() {
        Column({ space: 14 }) {
          // 1. 英文原句 + 重新播放
          Row() {
            Column({ space: 6 }) {
              Text(this.card.englishSentence)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .textAlign(TextAlign.Start)

              Text(this.card.chineseTranslation)
                .fontSize(15)
                .fontColor('#CBD5E1')
                .textAlign(TextAlign.Start)
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)

            // 小播放按钮
            Button(this.isPlaying ? '❚❚' : '▶')
              .fontSize(14)
              .fontColor(Color.White)
              .backgroundColor('#4F46E5')
              .width(38)
              .height(38)
              .borderRadius(19)
              .margin({ left: 10 })
              .onClick(() => {
                this.togglePlay();
              })
          }
          .width('100%')
          .padding(14)
          .backgroundColor('#1E293B')
          .borderRadius(16)

          // 2. 听力难点发音解码（连读/弱读/失爆）
          if (this.card.phoneticBreakdown && this.card.phoneticBreakdown.length > 0) {
            Column({ space: 8 }) {
              Text('🎧 影视听懂秘诀（发音解码）')
                .fontSize(13)
                .fontWeight(FontWeight.Bold)
                .fontColor('#38BDF8')
                .width('100%')

              ForEach(this.card.phoneticBreakdown, (rule: PhoneticRule) => {
                Row({ space: 8 }) {
                  Text(rule.typeLabel)
                    .fontSize(11)
                    .fontColor('#38BDF8')
                    .backgroundColor('#1A38BDF8')
                    .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                    .borderRadius(4)

                  Text(rule.chunk + ' ➔ ' + rule.pronunciation)
                    .fontSize(13)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#F8FAFC')
                }
                .width('100%')

                Text(rule.explanation)
                  .fontSize(12)
                  .fontColor('#94A3B8')
                  .width('100%')
              })
            }
            .width('100%')
            .padding(14)
            .backgroundColor('#1E293B')
            .borderRadius(16)
          }

          // 3. 核心词汇/短语（词句一体）
          if (this.card.keywords && this.card.keywords.length > 0) {
            Column({ space: 8 }) {
              Text('💡 核心词句一体')
                .fontSize(13)
                .fontWeight(FontWeight.Bold)
                .fontColor('#A855F7')
                .width('100%')

              ForEach(this.card.keywords, (kw: HighlightWord) => {
                Row({ space: 6 }) {
                  Text(kw.word)
                    .fontSize(15)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(Color.White)

                  Text(kw.phonetic)
                    .fontSize(12)
                    .fontColor('#94A3B8')
                }
                .width('100%')

                Text(`本句义：${kw.meaning}`)
                  .fontSize(13)
                  .fontColor('#E2E8F0')
                  .width('100%')

                if (kw.usageNote) {
                  Text(`贴士：${kw.usageNote}`)
                    .fontSize(12)
                    .fontColor('#64748B')
                    .width('100%')
                }
              })
            }
            .width('100%')
            .padding(14)
            .backgroundColor('#1E293B')
            .borderRadius(16)
          }
        }
        .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      }
      .layoutWeight(1)

      // 底部打卡操作区
      Row({ space: 14 }) {
        Button('稍后重现')
          .fontSize(14)
          .fontColor('#94A3B8')
          .backgroundColor('#1E293B')
          .height(42)
          .layoutWeight(1)
          .borderRadius(21)
          .onClick(() => {
            this.onCardCompleted();
          })

        Button('✓ 彻底听懂了')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .backgroundColor('#10B981')
          .height(42)
          .layoutWeight(1)
          .borderRadius(21)
          .onClick(() => {
            this.onCardCompleted();
          })
      }
      .width('100%')
      .padding({ left: 20, right: 20, bottom: 20, top: 10 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0F172A')
    .borderRadius(24)
  }

  /**
   * 触发翻转
   */
  private flipToBack() {
    this.rotateAngle = 90;
    setTimeout(() => {
      this.isFlipped = true;
      this.rotateAngle = 0;
    }, 200);
  }

  private flipToFront() {
    this.rotateAngle = 90;
    setTimeout(() => {
      this.isFlipped = false;
      this.rotateAngle = 0;
    }, 200);
  }

  /**
   * 播放/暂停原声音频
   */
  private togglePlay() {
    const speed = this.isSlowSpeed ? 0.8 : 1.0;
    this.audioManager.playUrl(this.card.audioUrl, speed);
  }
}
