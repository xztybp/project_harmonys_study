import { QuestionItem } from '../../models'
import { CustomTag } from './CustomTag'

@Extend(Text)
function grayText(isStart: boolean) {
  .lineHeight(13)
  .fontSize(13)
  .fontColor($r('app.color.common_gray_01'))
  .padding({ left: isStart ? 0 : 12, right: 12 })
}

// 封装试题 Item 组件，暴露 item 渲染不同内容
@Component
export struct QuestionItemComp {
  @Prop item: QuestionItem = {} as QuestionItem


  build() {
    Column() {
      Row({ space: 4 }) {
        CustomTag({ difficulty: this.item.difficulty })
        Text(this.item.stem)
          .font({
            size: 16,
            weight: FontWeight.Medium
          })
          .maxLines(1)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
      }
      .margin({
        bottom: 16
      })

      RowSplit() {
        Text() {
          Span('点赞')
          Span(this.item.likeCount.toString())
        }
        .grayText(true)

        Text() {
          Span('浏览')
          Span(this.item.views.toString())
        }
        .grayText(false)

        Text() {
          if (!this.item.readFlag) {
            Span('已看过')
          }
        }
        .grayText(false)
      }
      .margin({
        bottom: 20
      })

      Text()
        .width("100%")
        .height(1)
        .backgroundColor($r("app.color.common_gray_border"))
    }
    .height(80)
    .width("100%")
    .padding(16)
    .alignItems(HorizontalAlign.Start)

  }
}
