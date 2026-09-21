# CUEBThesis

首都经济贸易大学人工智能学院本科毕业论文（设计）LaTeX 模板。

**v0.1.1 预览版 · 2026-09-20 · 词元工作室独立实现，非学校官方模板。**

CUEBThesis 面向**首都经济贸易大学人工智能学院**本科毕业论文与毕业设计，提供摘要、目录、正文、图表、公式、参考文献、附录及致谢的统一排版。模板依据所附二〇二四届《本科毕业论文（设计）指导与评审手册》中的撰写要求，基于 CTeX、XeLaTeX、biblatex 和 Biber 实现，并保留学院配置扩展。

学院配置目前只预设学院名称，版式沿用所附校级手册；尚未加入未经确认的学院专属格式。

当前自动生成的是**暂拟打印扉页**，不是已经确认的学校统一封面。默认使用可分发的预览字体。正式使用前需核实当届规范、学院补充要求、封面底稿和字体，并核对[规范映射与未决事项](docs/requirements.md)。不宣称已获学校审定或适用于最新届次。

## 获取项目

```sh
git clone https://github.com/kayzhou/CUEBThesis.git
cd CUEBThesis
```

## 立即编译

安装含 XeLaTeX、Biber、latexmk、CTeX 与 `biblatex-gb7714-2015` 的 TeX Live / MacTeX。在项目根目录运行：

```sh
latexmk -outdir=build main.tex
```

输出为 `build/main.pdf`。已有 `latexmkrc` 负责选择 XeLaTeX，并由 latexmk 自动调用 Biber、重复编译。默认 `font-profile=preview` 使用 Fandol 与 TeX Gyre，不要求安装宋体。

也可以使用：

```sh
make thesis     # 完整排版示例
make minimal    # 最小编译示例
make test       # 自动检查
make release    # 构建含示例 PDF 的发布包
```

最小示例的直接命令为 `latexmk -outdir=build/minimal examples/minimal.tex`。请始终从项目根目录执行。发布包位于 `dist/cueb-undergraduate-thesis-v0.1.1.zip`。v0.1.1 的 `make test` 使用 Python 集成检查；l3build 回归机制留待后续版本。

## 开始写作

1. 修改 `cuebsetup.tex` 中的题目、姓名、学号、学院、专业、导师和日期。
2. 替换 `data/abstract.tex`、两个正文文件、附录与致谢；在 `main.tex` 调整文件顺序。
3. 将自己的文献写入 `ref/refs.bib`，使用 `\cuebcite{引用键}` 生成当页文献脚注。
4. 编译后查看最终 PDF，修复未解析引文、缺字、溢出与分页问题。
5. 提交前使用 `font-profile=submission` 重新编译，并完成规范与逐页核对。

主示例覆盖中英文摘要、三级标题、两节中的公式与图表、跨页表、重复文献引用、说明性脚注、参考文献、附录和致谢。除实际使用学院名称外，学生、导师等身份信息均为占位内容，数值均为人工构造。它是缩短的排版教学示例，**不是满足8000～10000字要求的完整论文**；示例中的五条参考文献也不满足正式论文的数量要求。

## 常用配置

| 配置 | 可选值与用途 |
| --- | --- |
| `standard` | `cueb-2024`：所附2024届手册 |
| `college-profile` | `artificial-intelligence`：默认人工智能学院；`general`：通用配置，需自行填写学院名称 |
| `font-profile` | `preview`：Fandol / TeX Gyre；`submission`：SimSun / SimHei / Times New Roman |
| `numbering` | `continuous`：全文连续，默认；`section`：按一级标题编号 |
| `thesis-type` | `research`：研究论文；`review`：文献综述；`design`：毕业设计 |
| `cover-file` | 可选，经确认的封面 PDF 路径，例如 `assets/approved-cover.pdf` |

`submission` 缺少指定字体时会报错，不会悄悄回退到预览字体。字体不随本项目分发。论文类型用于文献数量及综述外文文献提醒，不自动改变章节组织。提醒不构成合格判定；字数、摘要篇幅与关键词数量仍需人工核对。

文末参考文献以 GB/T 7714—2005 为基础，中文在前，组内按显式拼音排序键或外文作者字母排序。脚注与文末书目分别编号；同一来源再次引用产生新的脚注，文末书目去重。默认不使用 `\nocite{*}`。

## 文档与范围

- [快速入门与故障处理](docs/quickstart.md)
- [规范映射、默认解释与未决事项](docs/requirements.md)
- [上游来源与许可证](UPSTREAM.md)
- [版本记录](CHANGELOG.md)
- [本次验证记录](docs/validation.md)
- [校名字标来源](assets/README.md)

开题报告、指导记录、评阅表和答辩表不在首版范围内。所附手册包含的学生资料不会随工程再分发。源代码采用 LPPL 1.3c 或更新版本，学校标志的权利单独保留，见 `LICENSE` 与资源说明。
