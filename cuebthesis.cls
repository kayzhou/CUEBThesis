%% CUEB undergraduate thesis template, version 0.1.0 (2026-09-20)
%% Copyright (C) 2026 CUEB undergraduate thesis template contributors.
%% Distributed under LPPL 1.3c or later; see LICENSE.
\NeedsTeXFormat{LaTeX2e}[2020/10/01]
\ProvidesClass{cuebthesis}[2026/09/20 v0.1.0 CUEB undergraduate thesis]
\RequirePackage{iftex}
\RequireXeTeX
\LoadClass[UTF8,a4paper,zihao=-4,scheme=plain,fontset=none,oneside]{ctexart}
\RequirePackage{geometry,fancyhdr,graphicx,amsmath,amssymb,booktabs,longtable}
\RequirePackage{caption,etoolbox,pdfpages,xurl}
\RequirePackage[backend=biber,bibstyle=cueb-bibliography,citestyle=cueb-footnote,
 sorting=cueb,sortcites=false,autolang=none]{biblatex}
\RequirePackage[hidelinks,unicode]{hyperref}
\hypersetup{bookmarksnumbered=true,pdfcreator={CUEB undergraduate thesis v0.1.0}}
\urlstyle{same}
\ExplSyntaxOn
\tl_new:N \g_cueb_user_options_tl
\clist_map_inline:nn {title,title_en,author,student_id,department,major,supervisor,date,
 standard,college,font,numbering,type,logo,cover}
 {\tl_new:c {g_cueb_#1_tl}}
\bool_new:N \g_cueb_finalized_bool
\tl_gset:Nn \g_cueb_standard_tl {cueb-2024}
\tl_gset:Nn \g_cueb_college_tl {general}
\tl_gset:Nn \g_cueb_font_tl {preview}
\tl_gset:Nn \g_cueb_numbering_tl {continuous}
\tl_gset:Nn \g_cueb_type_tl {research}
\tl_gset:Nn \g_cueb_logo_tl {assets/cueb-logo.png}
\msg_new:nnn {cueb}{missing-field}{Required~metadata~'#1'~is~empty.}
\msg_new:nnn {cueb}{missing-font}{Submission~font~'#1'~is~not~installed.~Use~font-profile=preview~for~drafts.}
\msg_new:nnn {cueb}{bad-profile}{Unknown~or~invalid~profile~'#1'.}
\msg_new:nnn {cueb}{few-references}{Only~#1~references~loaded;~the~handbook~suggests~at~least~#2.~Check~your~college~requirements.}
\msg_new:nnn {cueb}{no-foreign}{A~review~thesis~requires~foreign-language~references.}
\msg_new:nnn {cueb}{late-setup}{Use~cuebsetup~only~in~the~preamble.}
\keys_define:nn {cueb}
 {
  title .tl_gset:N = \g_cueb_title_tl,
  title* .tl_gset:N = \g_cueb_title_en_tl,
  author .tl_gset:N = \g_cueb_author_tl,
  student-id .tl_gset:N = \g_cueb_student_id_tl,
  department .tl_gset:N = \g_cueb_department_tl,
  major .tl_gset:N = \g_cueb_major_tl,
  supervisor .tl_gset:N = \g_cueb_supervisor_tl,
  date .tl_gset:N = \g_cueb_date_tl,
  standard .choice:,
  standard / cueb-2024 .code:n = {\tl_gset:Nn\g_cueb_standard_tl{cueb-2024}},
  college-profile .tl_gset:N = \g_cueb_college_tl,
  font-profile .choice:,
  font-profile / preview .code:n = {\tl_gset:Nn\g_cueb_font_tl{preview}},
  font-profile / submission .code:n = {\tl_gset:Nn\g_cueb_font_tl{submission}},
  numbering .choice:,
  numbering / continuous .code:n = {\tl_gset:Nn\g_cueb_numbering_tl{continuous}},
  numbering / section .code:n = {\tl_gset:Nn\g_cueb_numbering_tl{section}},
  thesis-type .choice:,
  thesis-type / research .code:n = {\tl_gset:Nn\g_cueb_type_tl{research}},
  thesis-type / review .code:n = {\tl_gset:Nn\g_cueb_type_tl{review}},
  thesis-type / design .code:n = {\tl_gset:Nn\g_cueb_type_tl{design}},
  header-logo .tl_gset:N = \g_cueb_logo_tl,
  cover-file .tl_gset:N = \g_cueb_cover_tl,
 }
\NewDocumentCommand \cuebsetup {m}
 {
  \bool_if:NT \g_cueb_finalized_bool {\msg_fatal:nn{cueb}{late-setup}}
  \keys_set:nn {cueb}{#1}
  \tl_gput_right:Nn \g_cueb_user_options_tl {#1,}
 }
% For profile files: apply defaults without recording them as explicit user choices.
\NewDocumentCommand \cuebprofilesetup {m}{\keys_set:nn{cueb}{#1}}
\cs_new_protected:Npn \cueb_preview_fonts:
 {
  \setmainfont{texgyretermes-regular.otf}[BoldFont=texgyretermes-bold.otf,
   ItalicFont=texgyretermes-italic.otf,BoldItalicFont=texgyretermes-bolditalic.otf]
  \setsansfont{texgyreheros-regular.otf}[BoldFont=texgyreheros-bold.otf]
  \setmonofont{texgyrecursor-regular.otf}
  \setCJKmainfont{FandolSong-Regular.otf}[Script=CJK,BoldFont=FandolSong-Bold.otf,ItalicFont=FandolKai-Regular.otf]
  \setCJKsansfont{FandolHei-Regular.otf}[Script=CJK,BoldFont=FandolHei-Bold.otf]
  \setCJKmonofont{FandolFang-Regular.otf}[Script=CJK]
  \setCJKfamilyfont{zhsong}{FandolSong-Regular.otf}[Script=CJK,BoldFont=FandolSong-Bold.otf]
  \setCJKfamilyfont{zhhei}{FandolHei-Regular.otf}[Script=CJK,BoldFont=FandolHei-Bold.otf]
  \setCJKfamilyfont{zhkai}{FandolKai-Regular.otf}[Script=CJK]
 }
\cs_new_protected:Npn \cueb_submission_fonts:
 {
  \clist_map_inline:nn {SimSun,SimHei,Times~New~Roman}
   {\IfFontExistsTF{##1}{}{\msg_fatal:nnn{cueb}{missing-font}{##1}}}
  \setmainfont{Times~New~Roman}
  \setCJKmainfont{SimSun}[AutoFakeBold=2]
  \setCJKsansfont{SimHei}
  \setCJKmonofont{SimSun}
  \setCJKfamilyfont{zhsong}{SimSun}[AutoFakeBold=2]
  \setCJKfamilyfont{zhhei}{SimHei}
  \setCJKfamilyfont{zhkai}{SimSun}
 }
\cs_new_protected:Npn \cueb_finalize:
 {
  \file_input:n {config/cueb-2024.def}
  \exp_args:NnV \regex_match:nnTF {\A[-a-zA-Z0-9_]+\Z}\g_cueb_college_tl
   {
    \file_if_exist:nTF {config/colleges/\g_cueb_college_tl.def}
     {\file_input:n {config/colleges/\g_cueb_college_tl.def}}
     {\msg_fatal:nnx{cueb}{bad-profile}{\g_cueb_college_tl}}
   }{\msg_fatal:nnx{cueb}{bad-profile}{\g_cueb_college_tl}}
  \exp_args:NnV \keys_set:nn {cueb}\g_cueb_user_options_tl
  \str_if_eq:VnTF \g_cueb_font_tl {submission}
   {\cueb_submission_fonts:}{}
  \clist_map_inline:nn {title,author,student_id,department,major,supervisor}
   {\exp_args:Nv \tl_if_blank:nT {g_cueb_##1_tl}{\msg_fatal:nnn{cueb}{missing-field}{##1}}}
  \tl_if_blank:VT \g_cueb_date_tl {\tl_gset:Nn\g_cueb_date_tl{\the\year 年\the\month 月}}
  \str_if_eq:VnT \g_cueb_numbering_tl {section}
   {\counterwithin{figure}{section}\counterwithin{table}{section}\numberwithin{equation}{section}}
  \file_if_exist:nF {\g_cueb_logo_tl}
   {\msg_fatal:nnx{cueb}{bad-profile}{\g_cueb_logo_tl}}
  \exp_args:Nx\hypersetup{pdftitle={\exp_not:V\g_cueb_title_tl},pdfauthor={\exp_not:V\g_cueb_author_tl}}
  \bool_gset_true:N \g_cueb_finalized_bool
 }
\cueb_preview_fonts:
\AtEndPreamble{\cueb_finalize:}
\NewDocumentCommand\cuebvalue{m}{\tl_use:c{g_cueb_#1_tl}}
\NewDocumentCommand\cuebheaderlogo{}{
 \raisebox{0pt}[0.9cm][0pt]{\includegraphics[width=4.5cm,height=0.9cm]{\tl_use:N\g_cueb_logo_tl}}}
\RenewDocumentCommand\maketitle{}{
 \hypersetup{pageanchor=false}
 \tl_if_blank:VF\g_cueb_cover_tl{\includepdf[pages=-,pagecommand={\thispagestyle{empty}}]{\tl_use:N\g_cueb_cover_tl}}
 \begin{titlepage}\thispagestyle{empty}\centering
 \vspace*{0.8cm}
 \includegraphics[width=10cm]{\tl_use:N\g_cueb_logo_tl}\par
 \vspace{1.2cm}
 {\heiti\fontsize{22bp}{32bp}\selectfont 本科毕业论文（设计）\par}
 \vspace{1.4cm}
 {\heiti\fontsize{22bp}{32bp}\selectfont\tl_use:N\g_cueb_title_tl\par}
 \vfill
 {\songti\bfseries\fontsize{16bp}{28bp}\selectfont
 \renewcommand\arraystretch{1.4}
 \begin{tabular}{r p{8cm}}
 学生姓名：&\tl_use:N\g_cueb_author_tl\\
 学\quad 号：&\tl_use:N\g_cueb_student_id_tl\\
 学\quad 院：&\tl_use:N\g_cueb_department_tl\\
 专业（方向）：&\tl_use:N\g_cueb_major_tl\\
 指导教师：&\tl_use:N\g_cueb_supervisor_tl
 \end{tabular}\par}
 \vspace{1.2cm}
 {\songti\bfseries\fontsize{16bp}{24bp}\selectfont\tl_use:N\g_cueb_date_tl\par}
 \vspace*{0.8cm}
 \end{titlepage}
}
\NewDocumentCommand\cuebappendixnumbering{}{
 \str_if_eq:VnT\g_cueb_numbering_tl{section}{
  \renewcommand\thefigure{附\thesection.\arabic{figure}}
  \renewcommand\thetable{附\thesection.\arabic{table}}
  \renewcommand\theequation{附\thesection.\arabic{equation}}}}
\NewDocumentCommand\cuebcheckreferences{}{
 \str_if_eq:VnTF\g_cueb_type_tl{review}
  {\int_compare:nNnT{\value{cuebreferencecount}}<{30}{\msg_warning:nnxx{cueb}{few-references}{\arabic{cuebreferencecount}}{30}}
   \int_compare:nNnT{\value{cuebforeigncount}}={0}{\msg_warning:nn{cueb}{no-foreign}}}
  {\int_compare:nNnT{\value{cuebreferencecount}}<{15}{\msg_warning:nnxx{cueb}{few-references}{\arabic{cuebreferencecount}}{15}}}
}
\ExplSyntaxOff
\newcounter{cuebreferencecount}
\newcounter{cuebforeigncount}
\AtDataInput{\stepcounter{cuebreferencecount}
 \iffieldequalstr{languageid}{chinese}{}{\stepcounter{cuebforeigncount}}
 \ifentrytype{online}{\iffieldundef{year}{\PackageWarningNoLine{cuebthesis}{Online entry '\thefield{entrykey}' has no publication date}}{}}{}}
\providecommand\songti{\CJKfamily{zhsong}}
\providecommand\heiti{\CJKfamily{zhhei}}
\providecommand\kaishu{\CJKfamily{zhkai}}
\newcommand\cuebbodyfont{\songti\fontsize{12bp}{18bp}\selectfont}
\newcommand\cuebheadingfont{\heiti\fontsize{15bp}{22.5bp}\selectfont}
\newcommand\cuebfrontmatter{\clearpage\hypersetup{pageanchor=true}\pagenumbering{arabic}\pagestyle{cueb}\cuebbodyfont}
\newcommand\cuebmainmatter{\clearpage\pagestyle{cueb}\cuebbodyfont}
\newcommand\cuebunnumbered[1]{\clearpage\section*{#1}\addcontentsline{toc}{section}{#1}}
\newcommand\cuebappendix{\clearpage\appendix\renewcommand\thesection{\arabic{section}}\ctexset{section={name={附件,},number=\arabic{section}}}\cuebappendixnumbering}
\newcommand\cuebacknowledgements{\cuebunnumbered{致谢}}
\NewDocumentEnvironment{cuebabstract}{}{\clearpage\section*{摘\quad 要}\cuebbodyfont}{\par\clearpage}
\NewDocumentEnvironment{cuebabstract*}{}{\clearpage\section*{Abstract}\cuebbodyfont\let\cuebkeywords\cuebkeywordsEn}{\par\clearpage}
\newcommand\cuebkeywords[1]{\par\vfill\noindent\textbf{关键词：}#1\par}
\newcommand\cuebkeywordsEn[1]{\par\vfill\noindent\textbf{Keywords: }#1\par}
\newcommand\cuebprintbibliography{\cuebcheckreferences\clearpage\printbibliography[heading=bibintoc,title={参考文献}]}
\let\cueboriginaltoc\tableofcontents
\renewcommand\tableofcontents{\clearpage\cueboriginaltoc\clearpage}
\renewcommand\l@section{\@dottedtocline{1}{0em}{2.5em}}
\renewcommand\contentsname{目\quad 录}
\renewcommand\figurename{图}
\renewcommand\tablename{表}
\renewcommand\listfigurename{插图目录}
\renewcommand\listtablename{表格目录}
\renewcommand\thefootnote{\arabic{footnote}}
\renewcommand\@makefnmark{\hbox{\textsuperscript{\normalfont[\@thefnmark]}}}
\renewcommand\@makefntext[1]{\parindent=2em\noindent\hb@xt@2em{\normalfont[\@thefnmark]\hfil}#1}
\renewcommand\footnotesize{\songti\fontsize{9bp}{12bp}\selectfont}
\AtBeginDocument{\cuebbodyfont\let\cite\cuebcite\let\footcite\cuebcite}
\endinput
