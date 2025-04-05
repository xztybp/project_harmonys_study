import { SortType } from '../../models'

@Component
export struct FilterButton {
  @Prop text: string = ''
  @Prop isSort: boolean = false
  @Prop isNew: boolean = false
  @Prop selected: boolean = false
  @Prop sort: SortType = SortType.Default

  build() {
    Row() {
      Text(this.text)
        .fontSize(12)
        .fontColor(this.selected ? $r('app.color.common_main_color') : $r('app.color.black'))
      if (this.isSort) {
        // 偶数升序 low  奇数降序 high
        Column() {
          Image($r('sys.media.ohos_ic_public_arrow_up'))
            .size({ width: 12, height: 6 })
            .fillColor(this.selected && (this.sort % 2) === 0 ? $r('app.color.common_main_color') : $r('app.color.black'))
          Image($r('sys.media.ohos_ic_public_arrow_down'))
            .size({ width: 12, height: 6 })
            .fillColor(this.selected && (this.sort % 2) === 1 ? $r('app.color.common_main_color') : $r('app.color.black'))
        }
        .margin({ left: 2 })
      }
      if (this.isNew) {
        Image($r('app.media.ic_home_new'))
          .width(32)
          .height(14)
          .objectFit(ImageFit.Contain)
          .position({ right: -26, top: -7 })
      }
    }
    .height(32)
    .padding({ left: 10, right: 10 })
    .borderRadius(4)
    .backgroundColor($r('app.color.common_gray_bg'))
    .margin({ bottom: 12, right: this.isNew ? 26 : 10 })
  }
}