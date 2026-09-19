# 上游来源、借鉴与许可证

记录日期：2026-09-20。首版为独立实现，不是 ThuThesis 的完整 Fork；运行时不加载 ThuThesis。

## ThuThesis 工程参考

项目：[tuna/thuthesis](https://github.com/tuna/thuthesis)。本次设计调研固定在提交 [`fd3be474b1e66be85bcf286ea4be524b26c7e512`](https://github.com/tuna/thuthesis/tree/fd3be474b1e66be85bcf286ea4be524b26c7e512)，用于固定参考证据，不是生产依赖的版本锁。上游采用 LPPL 1.3c。

| 上游机制 | 本项目借鉴方式 |
| --- | --- |
| `thusetup.tex` / `\thusetup` | 集中配置文件和键值接口，改为 `cuebsetup.tex` / `\cuebsetup` |
| `thuthesis-example.tex` 与 `data/`、`ref/` | 主文件组织各部分，正文和书目分文件维护 |
| 本科独立 `.bbx` / `.cbx` | 分离脚注引文和文末著录；按本校手册使用2005基础样式 |
| 字体配置机制 | 显式区分预览字体与正式字体，正式字体缺失报错 |
| 构建、测试与发布组织 | 提供命令行构建、行为检查与可直接编译的发布包 |

首版没有直接复制上游文档类、文献样式或示例文本。学校专用版式、原创教学文本及示意图独立编写。后续若直接复制或修改上游代码，需在此记录文件路径、提交、改动与版权声明，并遵守对应许可证。

## 运行时基础组件

| 组件 | 用途 | 来源与许可说明 |
| --- | --- | --- |
| CTeX / `ctexart` | 中文文档基础 | [ctex-kit](https://github.com/CTeX-org/ctex-kit)，LPPL 1.3c |
| biblatex / Biber | 引文和参考文献处理 | [biblatex](https://github.com/plk/biblatex)、[Biber](https://github.com/plk/biber)，各自许可证随发行版提供 |
| `biblatex-gb7714-2015` 中的 `gb7714-2005` | 2005版书目著录基础 | [源项目](https://github.com/hushidong/biblatex-gb7714-2015)，相关样式为 LPPL 1.3c 或更新版本 |
| Fandol、TeX Gyre | 可分发的草稿预览字体 | 由 TeX 发行版提供；字体自身许可证保持有效 |

这些依赖由 TeX 发行版安装，本仓库不打包它们的全部源码或字体。正式使用的 SimSun、SimHei 和 Times New Roman 不随项目提供。

## 其他调研

[USTCThesis](https://github.com/ustctug/ustcthesis)用于了解示例覆盖和测试方式。[Jiangmanrui/CUEBThesis](https://github.com/Jiangmanrui/CUEBThesis)是首经贸博士论文项目，规范对象不同，调研时未确认可复用的明确许可证；本项目没有复制该项目源码。

## 学校材料与标志

2024届用户手册仅作为规范研究依据。含学生资料的源文件不分发。校名字标的来源及单独权利说明见 [assets/README.md](assets/README.md)。代码的 LPPL 许可不授予学校商标或标志的所有权，也不表示学校认可该项目。

## 示例文献核对入口

示例数据库仅含真实出版物。ISBN 用于定位具体版本，引用者仍应核实自己实际使用的版本和页码。

- 周志华：《机器学习》，清华大学出版社，2016，ISBN 9787302423287。
- 李航：《统计学习方法》第2版，清华大学出版社，2019，ISBN 9787302517276。
- Christopher M. Bishop: *Pattern Recognition and Machine Learning*, Springer, 2006，ISBN 9780387310732；[出版社入口](https://link.springer.com/book/9780387310732)。
- Ashish Vaswani 等：*Attention Is All You Need*，NeurIPS 2017；[会议原始记录](https://papers.nips.cc/paper/7181-attention-is-all-you-need)。
- ThuThesis 项目主页：访问日期2026-09-20；主页没有单一、已核实的发布日期，未伪造 `date` 字段。
