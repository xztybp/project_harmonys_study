import { HmCalendar, HmCalendarType } from "@ohmos/calendar"
import dayjs from "dayjs"
import { ClockIn } from "../commons/components/ClockIn"
import { SearchBox } from "../commons/components/SearchBox"
import { statusBar } from "../commons/utils/StatusBar"
import { HomeCategory } from "../views/HomeCategory"

@Entry
@Component
export default struct HomePage {
  @StorageProp('topHeight') topHeight: number = 0
  @StorageProp('bottomHeight') bottomHeight: number = 0
  // 轮播图数组
  swiperList: ResourceStr[] = [
    $r('app.media.banner_ai'), $r('app.media.banner_pj'), $r('app.media.banner_qa')
  ]
  currentMonth: string = new Date().toString().split(' ')[1]
  currentDay: string = new Date().toString().split(' ')[2]

  // 组件即将出现时回调该接口
  aboutToAppear(): void {
    statusBar.setBar({
      statusBarColor: '#f3f4f6'// 设置导航栏背景颜色
    })
  }

  // 图片
  @Builder
  swiperBuilder(item: ResourceStr) {
    Row() {
      Image(item)
        .width('100%')
        .aspectRatio(2.65)
        .objectFit(ImageFit.Contain)
    }
    .width("100%")

  }

  // 日历
  @Builder
  calendarBuilder() {
    Row() {
      Row() {

        Column({ space: 12 }) {
          Text(this.currentMonth.toString())
            .fontColor(Color.Red)
            .fontWeight(FontWeight.Medium)
          Text(this.currentDay.toString())
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Regular)
            .fontSize(26)
        }
        .backgroundColor(Color.White)
        .borderRadius(10)
        .padding(12)
        .offset({
          top: -16,
          left: 16
        })
        .margin({
          right: 30
        })

        Column({ space: 10 }) {
          Text('每日一题')
          Text('测试数据   ArkTs是否支持解构?')
            .maxLines(1)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .margin({
          right: 12
        })

        HmCalendar({
          type: HmCalendarType.MONTH_DOT,
          gutter: 6,
          color: '#00aa00',
          selectedDays: [
            { date: dayjs().format('YYYY-MM-DD') },
          ]
        })

      }
      .width("100%")
      .height(80)
      .borderRadius(10)
      .padding({
        right: 16
      })
      .backgroundColor($r("app.color.home_gray"))
    }
    .width("100%")
    .padding({
      left: 16,
      right: 16,
      bottom: 16
    })
    .backgroundColor($r('app.color.common_gray_bg'))

  }

  build() {
    Column() {
      // 顶部
      Row() {
        Image($r('app.media.ic_home_scan'))
          .width(24)
          .aspectRatio(1)
        // 封装搜索占位组件
        SearchBox({ layoutWeightValue: 1 })
        // 封装打卡组件
        ClockIn()
      }
      .width('100%')
      .margin({
        bottom: 16
      })
      .padding({
        left: 16,
        right: 16
      })

      // 轮播图
      Swiper() {
        ForEach(this.swiperList, (item: ResourceStr, index) => {
          this.swiperBuilder(item)
        })
      }
      .autoPlay(true)
      .indicator(DotIndicator.dot()
        .bottom(4)
        .itemHeight(4)
        .selectedItemHeight(4)
        .selectedColor($r('app.color.white')))
      .margin({
        bottom: 30
      })
      .padding({
        left: 16,
        right: 16
      })

      // 日历
      this.calendarBuilder()

      // tab栏分类

      Column() {
         // 使用 Refresh List 和 QuestionItemComp 组件搭建基础结构和样式
        HomeCategory()
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor(Color.White)
      .border({
        radius: {
          topLeft: 16,
          topRight: 16
        }
      })
    }


    .padding({
      top: this.topHeight,
      bottom: this.bottomHeight
    })
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.common_gray_bg'))
  }
}


// 按需导出
// export {
//   HomePage
// }

// 默认导出
// export default HomePage