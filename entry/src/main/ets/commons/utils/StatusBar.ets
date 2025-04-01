// 目标：实现一个控制状态栏的工具，可以快捷设置黑色和白色状态文字
import { window } from '@kit.ArkUI'
import { logger } from './Logger'

class StatusBar {
  async setBar(properties: window.SystemBarProperties) {
    const ctx = AppStorage.get<Context>('context')
    try {
      if (ctx) {
        const win = await window.getLastWindow(ctx)
        await win.setWindowSystemBarProperties(properties)
      }
    } catch (e) {
      logger.error('StatusBar setBar', JSON.stringify(e))
    }
  }
  setDarkBar() {
    this.setBar({ statusBarContentColor: '#000000' })
  }

  setLightBar() {
    this.setBar({ statusBarContentColor: '#ffffff' })
  }
}
export const statusBar = new StatusBar()