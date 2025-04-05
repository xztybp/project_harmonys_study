// 使用 Refresh List 和 QuestionItemComp 组件搭建基础结构和样式
// 实现步骤：
// 使用 Refresh List 和 QuestionItemComp 组件搭建基础结构和样式
// 完成 下拉刷新 效果，不含数据刷新
// 完成 上拉加载 Builder
// 完成 上拉加载 完整效果
import { QuestionItemComp } from './QuestionItemComp'
import { promptAction } from '@kit.ArkUI'
import { http } from '../utils/Http'
import { PageData, QuestionItem, QuestionListParams, SortType } from '../../models'
import { logger } from '../utils/Logger'

// 完成 下拉刷新 完整效果
@Component
export struct QuestionListComp {
  // 下拉刷新
  @State isRefreshing: boolean = false
  // 加载中图标
  @State angle: number = 0
  // 是否加载完成
  @State isFinished: boolean = false
  // 正在加载中...
  @State isLoading: boolean = false
  // 列表
  @State list: QuestionItem[] = []
  @Prop typeId: number
  @Prop @Watch('sortChange') sort: SortType = SortType.Default
  @State page: number = 1
  @Prop index: number
  @Prop @Watch("activeIndexChange") activeIndex: number
  // 切换tab 栏吸顶
  scroller: Scroller = new Scroller(); // 列表滚动控制器
  @State currentSortStatus: number = 0
  // 监听页签和筛选状态同时改变
  sortAndIndexAllChange: boolean = false

  // 解决切换tab栏列表没有吸顶的问题
  activeIndexChange() {
    if (this.activeIndex === this.index) {
      logger.info('页签监听改变了', this.typeId.toString())
      this.scroller.scrollToIndex(0); // 关键跳转逻辑

      logger.info(this.currentSortStatus.toString(), this.sort.toString())
      // 页签改变记录当前筛选状态
      this.currentSortStatus = this.sort
      // 关键代码，页签改变，筛选条件也变了
      this.isRefreshing = true
      // if (this.sortAndIndexAllChange) {
      //   this.isRefreshing = true
      // }

    }

  }

  // 监听筛选状态改变触发
  sortChange() {
    promptAction.showToast({
      message: '筛选状态改变了'
    })
    // 解决接口多次调用问题
    if (this.activeIndex === this.index) {
      logger.info('监听改变了', `sort${this.sort}`)
      this.isRefreshing = true
      // if (this.currentSortStatus.toString() !== this.sort.toString()) {
      //   this.sortAndIndexAllChange = true
      // } else {
      //   this.sortAndIndexAllChange = false
      // }
      // logger.info(this.currentSortStatus.toString(), this.sort.toString())
    }
  }

  // 模拟1秒更新完成
  async onRefresh() {
    this.page = 1
    const result = await this.getQuestionList()
    this.isRefreshing = false
    this.list = result.rows
    // 有没有更多数据
    if (this.list.length >= result.total) {
      this.isFinished = true
    } else {
      this.isFinished = false
      this.page++
    }
  }

  // 加载更多，注意，页面加载会触发onReachEnd,所以不用在生命周期钩子初始化
  async onLoad() {

    this.isLoading = true
    // 开启动画
    animateTo({ duration: 1000, curve: Curve.Linear }, () => {
      this.angle += 360; // 旋转360度
    });
    const result = await this.getQuestionList()
    if (this.list.length >= result.total) {
      this.isFinished = true
      this.isLoading = false
      return
    }
    this.page++
    this.isLoading = false
    this.list = this.list.concat(result.rows)

  }

  aboutToAppear(): void {

  }

  // 获取列表
  getQuestionList(): Promise<PageData<QuestionItem>> {
    return http.request<PageData<QuestionItem>>({
      url: 'question/list',
      params: {
        type: this.typeId,
        questionBankType: 10,
        sort: this.sort,
        page: this.page,
        pageSize: 10
      } as QuestionListParams
    })
  }

  // 自定义加载中图标
  @Builder
  CustomRefreshBuilder() {
    Row() {
      Image($r("app.media.redloading"))
        .width(20)
        .aspectRatio(1)
        .rotate({
          angle: this.angle
        })
      Text('拼命加载中.....')
        .fontSize(12)
        .fontColor($r("app.color.common_gray_01"))

    }
  }

  // 自定义加载更多和加载完成
  @Builder
  LoadingAndFinishedBuilder() {
    ListItem() {
      // 加载完成
      if (this.isFinished) {
        Row() {
          Text('~~~~~~我是有底线的~~~~~~~~')
            .fontColor($r("app.color.common_gray_02"))
        }
        .width("100%")
        .height(80)
        .justifyContent(FlexAlign.Center)
      } else if (this.isLoading) {
        Row() {
          this.CustomRefreshBuilder()
        }
        .width("100%")
        .height(80)
        .justifyContent(FlexAlign.Center)
      }
    }

  }

  build() {
    Refresh({ refreshing: $$this.isRefreshing, builder: this.CustomRefreshBuilder }) {
      List({ scroller: this.scroller }) {
        ForEach(this.list, (item: QuestionItem, index) => {
          ListItem() {
            QuestionItemComp({
              item
            })
          }

        })
        this.LoadingAndFinishedBuilder()
      }
      // .divider({
      //   strokeWidth: 0.5,
      //   color: $r('app.color.common_gray_border'),
      //   startMargin: 16,
      //   endMargin: 16
      // })
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.None)
      .onReachEnd(() => {
        // promptAction.showToast({
        //   message: '开始吧刷新'
        // })
        logger.info('onReachEnd')
        if (this.isFinished || this.isLoading || this.isRefreshing) {
          return
        }
        this.isLoading = true
        this.onLoad()
      })
    }
    .onRefreshing(() => {
      logger.info('onRefreshing')
      this.onRefresh()
      animateTo({ duration: 1000, curve: Curve.Linear }, () => {
        this.angle += 360; // 旋转360度
      });
    })

  }
}