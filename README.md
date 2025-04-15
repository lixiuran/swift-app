# Swift数据管理应用

一个使用 SwiftUI 开发的 iOS 数据管理应用，提供直观的数据展示和管理功能。

## 功能特性

### 1. 首页数据展示
- 核心数据卡片展示
  - 今日收益
  - 昨日收益
  - 国内/海外收益分析
  - 月度数据统计
- 详细数据快速入口
  - 账户管理
  - 应用分析
  - 代码位管理

### 2. 导航与界面
- 底部标签栏导航
  - 首页
  - 数据
  - 统计
- 侧边抽屉菜单
  - 用户信息展示
  - 深色主题切换
  - 版本信息
  - 退出登录

### 3. 界面特性
- 现代化 UI 设计
- 流畅的动画效果
- 响应式布局
- 支持深色模式

## 技术栈

- Swift 5.0+
- SwiftUI
- iOS 15.0+
- Xcode 14.0+

## 开发环境设置

1. 确保安装了最新版本的 Xcode
2. Clone 项目到本地：
```bash
git clone https://github.com/lixiuran/swift-app.git
```
3. 打开 `swfitapp.xcodeproj`
4. 选择目标设备或模拟器
5. 点击运行按钮或按 `Cmd + R`

## 项目结构

```
swfitapp/
├── ContentView.swift     # 主视图文件
├── HomeView             # 首页视图
├── DataView            # 数据页面
├── StatisticsView      # 统计页面
├── Components/         # 可复用组件
│   ├── DataCard       # 数据卡片组件
│   └── DetailItem     # 详细列表项组件
└── Assets.xcassets     # 资源文件
```

## 版本历史

- v1.0.0
  - 初始版本发布
  - 实现基础数据展示功能
  - 添加抽屉菜单
  - 完成底部导航栏

## 待实现功能

- [ ] 数据页面详细实现
- [ ] 统计页面图表展示
- [ ] 深色主题完整适配
- [ ] 用户认证系统
- [ ] 数据本地存储

## 贡献指南

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 联系方式

项目维护者 - [@lixiuran](https://github.com/lixiuran)

项目链接: [https://github.com/lixiuran/swift-app](https://github.com/lixiuran/swift-app) 