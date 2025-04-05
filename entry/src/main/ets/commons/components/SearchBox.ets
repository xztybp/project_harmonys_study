@Component
export struct SearchBox {
  @Prop boxWidth: Length = 100
  @Prop boxHeight: number = 32
  @Prop ph: ResourceStr = '搜索题目'
  @Prop phColor: ResourceColor = $r('app.color.common_gray_02')
  @Prop bgColor: ResourceColor = $r('app.color.common_gray_border')
  @Prop layoutWeightValue: number = 0

  build() {
    Row({ space: 4 }) {
      Image($r('app.media.ic_common_search'))
        .width(16)
        .aspectRatio(1)
      Text(this.ph)
        .fontColor(this.phColor)
    }
    .width(this.boxWidth)
    .height(this.boxHeight)
    .borderRadius(this.boxHeight / 2)
    .margin({
      left: 16,
      right: 16
    })
    .layoutWeight(this.layoutWeightValue)
    .backgroundColor(this.bgColor)
    .justifyContent(FlexAlign.Center)
  }
}