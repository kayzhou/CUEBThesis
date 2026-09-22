# 快速入门

第一次接触 LaTeX，请先阅读 [README 零基础使用指南](../README.md)。本文保留更详细的命令、引文和学院配置说明，适合已经完成第一次编译后查阅。

## 1. 获取并编译

将项目解压到一个可写目录，打开终端并进入含 `main.tex` 的根目录。安装完整的 TeX Live / MacTeX，确认可以执行 `xelatex`、`biber` 和 `latexmk`。模板依赖 `ctex`、`fontspec`、`geometry`、`fancyhdr`、`biblatex`、`biblatex-gb7714-2015` 等公开宏包；项目内已经提供自己的文档类和文献样式。

```sh
latexmk -outdir=build main.tex
```

打开 `build/main.pdf`。首次编译需要运行 Biber 并重复处理目录与交叉引用，交给 latexmk 即可。不要在 `data/` 或 `examples/` 内直接运行命令。

最新本地编译验证使用 TeX Live 2026、XeTeX 0.999998、latexmk 4.88 与 Biber 2.22；两份示例及PDF/日志检查通过。完整测试的文献边界用例仍存在 `\printenddate` 未定义问题，详见[验证记录](validation.md)。较早的 TeX Live 2022 环境记录也保留在该文档中；不同环境的结果需分别判断。

主示例默认使用 `submission`，需已安装 `SimSun`、`SimHei` 与 `Times New Roman`。暂未安装时，将 `cuebsetup.tex` 中的 `font-profile` 改为 `preview`。最小示例始终使用预览字体。

最小环境检查：

```sh
latexmk -outdir=build/minimal examples/minimal.tex
```

最小文件故意省略摘要、目录等论文组成部分。实际写作从 `main.tex` 开始。

Overleaf：上传整个工程或发布包，设置主文件为 `main.tex`，编译器为 **XeLaTeX**，然后重新编译。平台字体与本地字体可能不同；预览模式可先验证工程，正式模式需自行合法提供平台可识别的指定字体。线上运行结果需另行核对，本地编译通过不等于已验证所有 Overleaf 环境。

## 2. 修改文件

| 文件 | 日常修改内容 |
| --- | --- |
| `cuebsetup.tex` | 基本信息、字体方案、编号和论文类型 |
| `main.tex` | 各部分的顺序，增加或删除正文文件 |
| `data/abstract.tex` | 中英文摘要及关键词 |
| `data/01-writing.tex`、`data/02-validation.tex` | 替换为自己的正文 |
| `data/appendix.tex`、`data/acknowledgements.tex` | 附录与致谢 |
| `ref/refs.bib` | 文献元数据 |

新增一节可以创建 `data/03-results.tex`，再在主文件中适当位置增加 `\input{data/03-results}`。标题使用 `\section`、`\subsection`、`\subsubsection`。不手写编号，也不在正文中反复设置字号和行距。

## 3. 引文与文献库

文献脚注与解释性脚注：

```latex
资料的相关论述。\cuebcite{zhou2016}
这里是需要补充解释的内容。\footnote{这里写解释，不是书目。}
% 在核实所用版本的具体页码后，才使用：
% \cuebcite[23--25]{实际引用键}
```

多篇来源有各自页码时，使用 `\cuebcites[23--25]{键一}[10]{键二}`；`\cites` 和 `\footcites` 也生成完整文献脚注。`\cuebcite[23]{键一,键二}` 的单一页码仅置于整条注释末尾，不能表达每个来源不同的页码。

脚注全文连续计数。重复使用同一个引用键，会产生新的完整文献脚注；文末书目仍只保留一条。具体页码属于当前引用，不要为了使脚注“看起来完整”而编造页码。

中文书目示例：

```bibtex
@book{li2019,
  author = {{李航}},
  title = {统计学习方法},
  edition = {2},
  location = {北京},
  publisher = {清华大学出版社},
  date = {2019},
  langid = {chinese},
  sortkey = {LiHang2019}
}
```

中文条目填写 `langid={chinese}`，并用 `sortkey` 指定作者拼音顺序；多音字、团体作者尤其需要人工核对。显式 `langid` 优先决定文献语言；缺省时上游样式按文字推断，仍建议逐条填写。外文条目使用 `langid={english}` 等实际语言信息，作者通常写成 `姓, 名`，多作者用 `and` 分隔。不要在作者字段中手工加“等”或“et al.”。

网络条目区分 `date`（已核实的发布/更新日期）和 `urldate`（实际访问日期）。示例 ThuThesis 主页未填写无法核实的单一发布日期，编译时会出现相应的缺发布年份提醒；`2026-09-20` 是访问日期，不能拿来填充出版日期。正式引用应尽可能选择可确定版本和日期的页面，或按学院确认的口径处理缺失信息。

默认只列出已引用的来源。确实需要列出正文未直接引用但对写作有帮助的资料时，可以显式写 `\nocite{特定引用键}`，并确认其符合论文要求，不建议直接导出整个数据库。

## 4. 图表、公式与附录

用 `\label` 记录对象，以 `\ref` 或 `\eqref` 引用。图题在图下、表题在表上。跨页表使用 `longtable`，不要再嵌套 `table` 浮动环境。主示例包含可以替换的完整写法。

默认编号为全文连续。只有在已确认学院要求后，才将 `numbering=continuous` 改为 `numbering=section`。普通一级标题不会自动另起页；主示例中第二节前的 `\clearpage` 只是示例编排选择，可以按实际内容删除。

`\cuebappendix` 开始附录部分，之后继续使用 `\section`。`\cuebacknowledgements` 生成无编号致谢标题，不需要再加一个同名标题。`\cuebmainmatter` 开始新页，但不重置页码；封面与暂拟打印扉页无页码，中文摘要起使用阿拉伯数字。这些前置页行为属于当前默认解释，详见规范映射。

## 5. 正式字体与封面

主示例当前配置为：

```latex
\cuebsetup{font-profile=submission}
```

系统必须能够按名称找到 `SimSun`、`SimHei`、`Times New Roman`。例如 macOS 的 Songti SC 不会被当作 SimSun 自动代用。请使用自己合法可用的字体，安装后重新编译并核对分页。预览字体与正式字体不能视为版面等价。

取得已经确认的学校封面 PDF 后可配置：

```latex
\cuebsetup{cover-file={assets/approved-cover.pdf}}
```

它用于插入外部封面。模板仍提供暂拟打印扉页；是否保留以及各项位置必须按适用底稿核对。项目没有附带被宣称为正式封面的学校文件。

## 6. 常见问题

| 现象 | 处理方式 |
| --- | --- |
| 找不到 `cuebthesis.cls` 或校名字标 | 回到项目根目录编译，确保解压了完整工程 |
| 缺少 `gb7714-2005.bbx` | 安装或更新 `biblatex-gb7714-2015`；包名含2015，但也提供2005样式 |
| 提示缺少提交字体 | 检查系统字体名称；草稿可先使用 `preview` |
| 引文显示引用键、目录页码未更新 | 使用 latexmk 完成 Biber 与多轮编译；检查 `.bib` 引用键拼写 |
| Biber 和 biblatex 不兼容 | 从同一 TeX 发行版管理器配套更新，避免只替换单个程序 |
| 出现 `Overfull` 或缺字提示 | 定位日志中的文件和行号，检查长词、网址、公式宽度与字体覆盖 |
| 摘要过长或关键词挤到下一页 | 调整摘要至要求篇幅，检查最终 PDF，不靠缩小字号掩盖问题 |
| 文献数量或综述外文文献提醒 | 示例仅有五条；模板按类型提醒，正式论文仍需核对数量、外文要求及来源质量 |

清除辅助文件后重编译可执行 `latexmk -C -outdir=build main.tex`，这也会删除该输出目录中的主 PDF；源文件不会被删除。排查问题时保留出错日志有助于定位原因。

按节编号时，附件中的图、表和公式使用 `附1.1` 等编号，避免与正文第1节的对象重号；全文连续模式下，附件对象继续沿用全篇序号。

## 7. 学院配置

当前默认使用 `college-profile=artificial-intelligence`，扉页显示“人工智能学院”；学院名来自该配置文件，不需要在 `cuebsetup.tex` 重复填写。它只预设学院名称，版式仍沿用所附2024届校级手册。学生姓名、学号、专业和导师仍需填写。使用通用配置时，设置 `college-profile=general` 并明确填写 `department={实际学院}`。显式 `department` 可覆盖学院默认值。

维护者可在 `config/colleges/` 新建一个有明确规范依据的 `.def` 文件，使用 `\cuebprofilesetup{...}` 设置差异，然后用 `college-profile` 选择其不带扩展名的文件名。加载顺序为学校配置、学院配置、用户显式配置。例如学院配置选择按节编号时，用户配置中的 `numbering=continuous` 仍会覆盖它；希望采用学院默认值时应删除这项显式设置。不要仅因学院名称不同就复制整套文档类。

`make test` 额外需要 Python 3 与 Poppler 的 `pdftotext`；普通论文编译不需要 Python 或 Poppler。本地 macOS 验证记录见 [validation.md](validation.md)。GitHub Actions 已运行三平台检查，目前仍有未通过项目，最新结果见 [Actions](https://github.com/kayzhou/CUEBThesis/actions)；Overleaf 尚未完成实测。
