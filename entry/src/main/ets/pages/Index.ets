import { fullscreen } from '../commons/utils/FullScreen'
import { logger } from '../commons/utils/Logger'
import { statusBar } from '../commons/utils/StatusBar'

@Entry
@Component
struct Index {
  @StorageProp('topHeight')
  topHeight: number = 0
  @StorageProp('bottomHeight')
  bottomHeight: number = 0

  build() {
    Column() {
      Row() {
        Text('头部')
      }
      .width('100%')
      .height(40)
      .backgroundColor('#0094ff')

      Row() {
        Text('头部')
        Button('测试沉浸式' + this.topHeight + 'bottom' + this.bottomHeight)
          .onClick(() => {
            fullscreen.enable()
            statusBar.setBar({
              // navigationBarColor: '#0094ff',
              // statusBarContentColor: '#0094ff', // 导航栏字体颜色
              statusBarColor: "#0094dd" // 导航栏背景颜色
            })
            // statusBar.setDarkBar()
          })
        Button('关闭沉浸式')
          .onClick(() => {
            fullscreen.disable()
          })
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .layoutWeight(1)

      Row() {
        Text('底部')
      }
      .width('100%')
      .height(40)

    }
    .height('100%')
    .width('100%')
    .padding({
      top: this.topHeight,
      bottom: this.bottomHeight
    })
    .backgroundColor('#92118bd9')
  }
}
