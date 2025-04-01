import { fullscreen } from '../commons/utils/FullScreen'
import { logger } from '../commons/utils/Logger'
import { statusBar } from '../commons/utils/StatusBar'
import List from '@ohos.util.List'
import { promptAction } from '@kit.ArkUI'
import HomePage from './HomePage'
import ProjectPage from './ProjectPage'
import InterviewPage from './InterviewPage'
import MinePage from './MinePage'

interface ListItem {
  name: string
  icon: Resource
  activeIcon: Resource
}

@Entry
@Component
struct Index {
  @StorageProp('topHeight')
  topHeight: number = 0
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  listItem: ListItem[] = [
    { name: '首页', icon: $r("app.media.tabbar_home"), activeIcon: $r("app.media.tabbar_home_fill") },
    { name: '项目', icon: $r("app.media.tabbar_project"), activeIcon: $r("app.media.tabbar_project_fill") },
    { name: '面经', icon: $r("app.media.tabbar_interview"), activeIcon: $r("app.media.tabbar_interview_fill") },
    { name: '我的', icon: $r("app.media.tabbar_mine"), activeIcon: $r("app.media.tabbar_mine_fill") },
  ]
  @State activeIndex: number = 0

  @Builder
  customTabBar(item: ListItem, index: number) {
    Column({ space: 5 }) {
      Image(index === this.activeIndex ? item.activeIcon : item.icon)
        .width(40)
        .aspectRatio(1)
      Text(item.name)
        .fontColor(index !== this.activeIndex ? $r("app.color.common_gray_01") : $r("app.color.black"))
    }
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, index: $$this.activeIndex,}) {
        ForEach(this.listItem, (item: ListItem, index: number) => {
          TabContent() {
            if (index === 0) {
             HomePage()
            } else if (index === 2) {
             ProjectPage()
            } else if (index === 3) {
              InterviewPage()
            } else {
              MinePage()
            }
          }
          .tabBar(this.customTabBar(item, index))

        })

      }
      .barHeight(65)
      .scrollable(false)
      // .animationMode(AnimationMode.NO_ANIMATION)
      // .onAnimationStart((index, targetIndex) => {
      //   // 动画开始时切换索引
      //   this.activeIndex = targetIndex
      // })
    }
    .height('100%')
    .width('100%')
  }
}
