// 实现步骤：
// views 下新建组件，Home 准备一个容器来使用组件
// 根据模拟数据绘制组件基本结构
// 实现自定义 TabBar，实现切换分类效果
import { QuestionType, SortType } from "../models"
import { font, promptAction } from "@kit.ArkUI"
import { QuestionItemComp } from "../commons/components/QuestionItemComp"
import { QuestionListComp } from "../commons/components/QuestionListComp"
import { http } from "../commons/utils/Http"
import { logger } from "../commons/utils/Logger"
import { FilterButton } from "../commons/components/FilterButton"

// const mockData: QuestionType[] = [
//   { id: 1, name: 'ArkTS', displayNewestFlag: 0 },
//   { id: 2, name: 'ArkUI', displayNewestFlag: 1 },
//   { id: 3, name: 'Hap', displayNewestFlag: 1 },
//   { id: 4, name: 'Hsp', displayNewestFlag: 0 },
//   { id: 5, name: 'Har', displayNewestFlag: 0 },
//   { id: 6, name: 'Ability', displayNewestFlag: 0 },
//   { id: 7, name: 'Stage', displayNewestFlag: 0 },
//   { id: 8, name: 'Kit', displayNewestFlag: 0 }
// ]

@Component
export struct HomeCategory {
  @State activeIndex: number = 0
  // 模态框是否展示
  @State isShow: boolean = false
  @State questionTypeList: QuestionType[] = []
  @State sort: SortType = SortType.Default
  // ************筛选条件******************************
  @State filterDataSort: SortType = SortType.Default
  @State filterDataIndex: number = 0

  // 自定义分类tab样式
  @Builder
  CustomCategoryTabBuilder(item: QuestionType, index: number) {
    Row({ space: 6 }) {
      Stack({ alignContent: Alignment.Bottom }) {
        Text(item.name)
          .font({
            size: 20,
            weight: index === this.activeIndex ? FontWeight.Medium : FontWeight.Normal
          })
          .fontColor(index === this.activeIndex ? $r('app.color.black') : $r('app.color.common_gray_01'))
          .height(44)
        if (index === this.activeIndex) {
          Text()
            .height(2)
            .width(20)
            .backgroundColor(Color.Black)
            .animation({ duration: this.activeIndex === index ? 300 : 0 })
        }
      }

      if (item.displayNewestFlag) {
        Image($r('app.media.ic_home_new'))
          .height(20)
      }
    }
    .padding({
      right: index === this.questionTypeList.length - 1 ? 60 : 20,
      left: index ? 0 : 20
    })

  }

  // 筛选框按钮
  @Builder
  FilterSheetBuilder() {
    Column() {
      Row() {
        Text('重置')
          .font({
            size: 18,
            weight: FontWeight.Medium
          })
          .onClick(() => {
            this.filterDataSort = SortType.Default
            // this.activeIndex = 0
            this.filterDataIndex = 0
            // this.isShow = false
          })
        Text('筛选题目')
          .font({
            size: 18,
            weight: FontWeight.Medium
          })
        Text('完成')
          .font({
            size: 18,
            weight: FontWeight.Medium
          })
          .fontColor($r("app.color.common_main_color"))
          .onClick(() => {
            this.isShow = false
            // 点击完成时，同步模态框选中结果，然后监听选中状态字段变化，重新调起接口响应
            this.activeIndex = this.filterDataIndex
            this.sort = this.filterDataSort

          })

      }
      .width("100%")
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({
        bottom: 20
      })

      Row() {
        Text('题目排序')
          .titleFilter()
      }
      .margin({
        bottom: 16
      })

      Flex({
        wrap: FlexWrap.Wrap
      }) {
        // 如果筛选内容等于默认值就激活选中状态
        FilterButton({ text: '默认', selected: this.filterDataSort === SortType.Default })
          .onClick(() => {
            this.filterDataSort = SortType.Default
          })
        // isSort 是否支持排序  sort 判断升序和降序  selected 选中状态
        FilterButton({
          text: '浏览量',
          isSort: true,
          sort: this.filterDataSort,
          selected: this.filterDataSort === SortType.ViewLow || this.filterDataSort === SortType.ViewHigh
        })
          .onClick(() => {
            // 如果已经选中，那么取反，否则，默认升序
            if (this.filterDataSort === SortType.ViewLow || this.filterDataSort === SortType.ViewHigh) {
              this.filterDataSort = this.filterDataSort === SortType.ViewLow ? SortType.ViewHigh : SortType.ViewLow
            } else {
              this.filterDataSort = SortType.ViewHigh
            }
          })
        FilterButton({
          text: '难度',
          isSort: true,
          sort: this.filterDataSort,
          selected: this.filterDataSort === SortType.DifficultyLow || this.filterDataSort === SortType.DifficultyHigh
        })
          .onClick(() => {
            // 如果已经选中，那么取反，否则，默认升序
            if (this.filterDataSort === SortType.DifficultyLow || this.filterDataSort === SortType.DifficultyHigh) {
              this.filterDataSort =
                this.filterDataSort === SortType.DifficultyLow ? SortType.DifficultyHigh : SortType.DifficultyLow
            } else {
              this.filterDataSort = SortType.DifficultyHigh
            }
          })
        FilterButton({ text: '推荐', selected: this.filterDataSort === SortType.Commend })
          .onClick(() => {
            this.filterDataSort = SortType.Commend
          })
      }

      Row() {
        Text('选择分类')
          .titleFilter()
      }
      .margin({
        bottom: 16
      })

      // 选择分类
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.questionTypeList, (item: QuestionType, index) => {
          FilterButton({
            text: item.name,
            isNew: item.displayNewestFlag === 1,
            selected: this.filterDataIndex === index
          })
            .onClick(() => {
              // 激活选中状态
              this.filterDataIndex = index
            })
        })
      }
    }
    .height("100%")
    .alignItems(HorizontalAlign.Start)
    .padding(16)
    .backgroundColor(Color.White)
  }

  // 组件即将出现时回调该接口
  aboutToAppear(): void {
    this.getQuestionTypeList()
  }

  // 获取tab栏数据
  getQuestionTypeList() {
    http.request<QuestionType[]>({ url: 'question/type' })
      .then(res => {
        this.questionTypeList = res
        logger.info(JSON.stringify(res))
      })
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Tabs({ index: $$this.activeIndex }) {
        ForEach(this.questionTypeList, (item: QuestionType, index) => {
          TabContent() {
            // 封装问题列表 QuestionListComp
            QuestionListComp({
              typeId: item.id,
              sort: this.sort,
              activeIndex: this.activeIndex,
              index: index
            })
          }.tabBar(this.CustomCategoryTabBuilder(item, index))

        })
      }
      .barMode(BarMode.Scrollable)
      .barHeight(44)
      .scrollable(false)
      .divider({ strokeWidth: 0.5, color: $r('app.color.common_gray_border') })


      Row() {
        Image($r('app.media.ic_home_filter'))
          .width(24)
          .aspectRatio(1)
      }
      .width(56)
      .height(44)
      .justifyContent(FlexAlign.Center)
      .border({
        radius: {
          topLeft: 10,
          topRight: 10
        }
      })
      .linearGradient({ angle: 90, colors: [['#00FFFFFF', 0], ['#FFFFFF', 0.285]] })
      .bindSheet($$this.isShow, this.FilterSheetBuilder(), {
        showClose: false,
        height: 400
      })
      .onClick(() => {
        this.isShow = true
        // 初始话打开时，同步选中状态
        this.filterDataIndex = this.activeIndex
      })
    }

  }
}

@Extend(Text)
function titleFilter() {
  .font({
    size: 16,
    weight: FontWeight.Medium
  })
}