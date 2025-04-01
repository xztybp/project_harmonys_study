@Component
export default struct HomePage {
  build() {
    Column() {
      Text('我是首页')
    }
  }
}
// 按需导出
// export {
//   HomePage
// }

// 默认导出
// export default HomePage