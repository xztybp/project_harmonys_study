// 目标：实现一个开启和关闭沉浸式的工具
// 前置知识：
//
// window.getLastWindow 获取当前窗口对象
// getWindowAvoidArea 使用窗口对象获取某一个区域的尺寸
import { window } from '@kit.ArkUI'

class FullScreen {
  // 需求：
  // 1. 提供 enable disable 开启和关闭沉浸式
  // 2. 提供安全区的高度，顶部安全区 + 底部安全区
  // 注意：需要的 context 在 appStorage 共享一个

  // 定义一个开启应用沉浸式的方法
  async enable() {
    // 由于非页面获取上下文，所以需要暂存AppStorage,在entryability中进行写入
    const context = AppStorage.get<Context>('context')
    if (context) {
      const win = await window.getLastWindow(context)
      // 开启沉浸式
      win.setWindowLayoutFullScreen(true)
      // 共享安全区高度
      const topRect = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect
      AppStorage.setOrCreate('topHeight', px2vp(topRect.height))
      const bottomRect = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect
      AppStorage.setOrCreate('bottomHeight', px2vp(bottomRect.height))
    }
  }

  // 定义一个关闭应用沉浸式的方法
  async disable() {
    // 由于非页面获取上下文，所以需要暂存AppStorage,在entryability中进行写入
    const context = AppStorage.get<Context>('context')
    if (context) {
      const win = await window.getLastWindow(context)
      // 关闭沉浸式
      win.setWindowLayoutFullScreen(false)
      // 取消安全区高度
      AppStorage.setOrCreate('topHeight', 0)
      AppStorage.setOrCreate('bottomHeight', 0)
    }
  }
}

export const fullscreen = new FullScreen()