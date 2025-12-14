% ============================================================
% cvacademique.cls - Minimalist academic CV document class
%
% Copyright (c) 2025 Wei Xu
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License (LPPL),
% version 1.3c or later.
%
% The latest version of this license is available at:
%   https://www.latex-project.org/lppl.txt
%
% This work has the LPPL maintenance status "maintained".
%
% The Current Maintainer of this work is:
%   Wei Xu (https://www.weixu.net)
%
% This work consists of the file:
%   - cvacademique.cls
% ============================================================


% ============================================================
% Class identification
% ============================================================

\NeedsTeXFormat{LaTeX2e}[1999/12/01]
\ProvidesClass{cvacademique}[2025/12/12 v0.1 CVAcademique document class]


% ============================================================
% Class options
% ============================================================

% -------- Draft mode --------
% Enable a visible "DRAFT" label and compilation timestamp in the footer
\newif\ifDraftMode
\DraftModefalse % default: off
\DeclareOption{draftmode}{\DraftModetrue}

% -------- Overlapped mode --------
% Switch section headings span between the full page width and the left-column label
\newif\ifOverlappedMode
\OverlappedModefalse % default: off
\DeclareOption{overlappedmode}{\OverlappedModetrue}


% ============================================================
% Date and time utilities
% ============================================================

% -------- Month name formatter --------
% \MonthName[short|long]{<month>}
% Formats a numeric month (1-12) as text.
% Default style: short (Jan., Feb., ...)
\newcommand{\MonthName}[2][short]{%
  \def\tempa{#1}%
  \def\shortopt{short}%
  \ifx\tempa\shortopt
    % short month names
    \ifcase#2\relax
      \or Jan.\or Feb.\or Mar.\or Apr.\or May\or June\or July\or Aug.\or Sept.\or Oct.\or Nov.\or Dec.%
    \else
      \PackageWarning{cvacademique}{Invalid month `#1'}%
    \fi
  \else
    % long month names
    \ifcase#2\relax
      \or January\or February\or March\or April\or May\or June\or July\or August\or September\or October\or November\or December%
    \else
      \PackageWarning{cvacademique}{Invalid month `#1'}%
    \fi
  \fi
}

% -------- Semester name formatter --------
% \Semester{1|2|3} -> Spring | Summer | Fall
\newcommand{\Semester}[1]{%
  \ifcase#1\relax
    \or Spring\or Summer\or Fall%
  \else
    \PackageWarning{cvacademique}{Invalid semester `#1'}%
  \fi
}

% -------- Date stamp helpers --------
% Month + Year
\newcommand{\DatestampYM}[2]{\mbox{\MonthName[short]{#2}~#1}}
% Semester + Year
\newcommand{\DatestampYS}[2]{\mbox{\Semester{#2}~#1}}
% Year only
\newcommand{\DatestampY}[1]{#1}
% Ongoing item / open-ended range (no end date)
\newcommand{\DatestampP}{Present}

% -------- Date formatting options --------
% mmyyyy -> Jan. 2019 (default)
\DeclareOption{mmyyyy}{}
% mmmmyyyy -> January 2019
\DeclareOption{mmmmyyyy}{%
  \renewcommand{\DatestampYM}[2]{\mbox{\MonthName[long]{#2}~#1}}%
}
% yyyy -> 2019
\DeclareOption{yyyy}{%
  \renewcommand{\DatestampYM}[2]{\mbox{#1}}%
  \renewcommand{\DatestampYS}[2]{\mbox{#1}}%
}
% Default option
\ExecuteOptions{mmyyyy}


% ============================================================
% Base class and option forwarding
% ============================================================

% Forward unknown options to article
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
% Load article class with fixed page layout and base font size
\LoadClass[10pt,oneside]{article}


% ============================================================
% Required packages
% ============================================================

% Color support
\RequirePackage{xcolor}
% Text and math fonts (Times-like)
\RequirePackage{newtxtext,newtxmath}
% Symbol-style footnotes
\RequirePackage[symbol]{footmisc}
% Page geometry optimized for CV layout
\RequirePackage[
  left=1.0in,
  right=1.0in,
  top=0.5in,
  bottom=0.6in,
  headheight=0.2in,
  headsep=0.3in,
  includehead,
  footskip=0.4in,
  includefoot
]{geometry}
% PDF metadata and navigation
\RequirePackage[
  unicode=true,
  bookmarks=true,
  bookmarksopen=true,
  bookmarksnumbered=true,
  pdfstartview=FitH,
  pdfpagelayout=OneColumn,
  pdfpagemode=UseOutlines,
  hidelinks
]{hyperref}


% ============================================================
% Global layout parameters
% ============================================================

% Line spacing multiplier
\newcommand{\LineSpacing}{1.25}
% Base font size
\newlength{\BaseFontSize}
\setlength{\BaseFontSize}{10pt}
% Title font size
\newlength{\TitleFontSize}
\setlength{\TitleFontSize}{1.2\BaseFontSize}
% Section label column width
\newlength{\LeftColWidth}
\ifOverlappedMode
  \setlength{\LeftColWidth}{0.5in}
\else
  \setlength{\LeftColWidth}{1.2in}
\fi


% ============================================================
% Font selection macros (public styling API)
% ============================================================

% Base font selector (user-replaceable)
\newcommand{\UseHeadingFont}{\normalfont}
% Header and footer font
\newcommand{\UseHeaderFooterFont}{%
  \UseHeadingFont
  \fontsize{\BaseFontSize}{\LineSpacing\BaseFontSize}\selectfont
}
% Note and footnote font
\newcommand{\UseNoteFont}{%
  \UseHeadingFont
  \fontsize{\BaseFontSize}{\LineSpacing\BaseFontSize}\selectfont
}
% Title font
\newcommand{\UseTitleFont}{%
  \UseHeadingFont
  \fontsize{\TitleFontSize}{\LineSpacing\TitleFontSize}\selectfont
  \bfseries
}
% Section heading font
\newcommand{\UseSectionFont}{%
  \UseHeadingFont
  \fontsize{\BaseFontSize}{\LineSpacing\BaseFontSize}\selectfont
  \bfseries
}
% Subsection heading font
\newcommand{\UseSubSectionFont}{%
  \UseHeadingFont
  \fontsize{\BaseFontSize}{\LineSpacing\BaseFontSize}\selectfont
  \bfseries
}
% Main document body font
\newcommand{\UseMainFont}{%
  \UseHeadingFont
  \fontsize{\BaseFontSize}{\LineSpacing\BaseFontSize}\selectfont
}


% ============================================================
% Header and footer configuration
% ============================================================

% Color
\newcommand{\HeaderFooterColor}{gray}
% Compilation timestamp (draft mode)
\newcommand{\Timestamp}{%
  \MonthName[long]{\the\month}~\the\day,~\the\year%
}
% Draft label styling
\newcommand{\DraftLabel}{DRAFT}
\newcommand{\DraftColor}{red}
\newcommand{\DraftStamp}{%
  {
    \UseHeaderFooterFont
    \color{\DraftColor}
    \DraftLabel~\Timestamp
  }%
}
% Page X of Y formatting
\AtEndDocument{\null\label{LastPage}}
\newcommand{\CVPageName}{Page}
\newcommand{\PageKOfN}{%
  {%
    \UseHeaderFooterFont
    \CVPageName~\thepage~of~\pageref{LastPage}%
  }%
}
% Header and footer text content
\newcommand{\CVHeader}{CV}
\newcommand{\HeaderText}{\CVHeader\quad\hfill\CVAuthor}
\newcommand{\FooterText}{%
  \ifDraftMode
    \DraftStamp\quad\hfill\PageKOfN
  \else
    \hfill\PageKOfN
  \fi
}


% ============================================================
% Page style definition
% ============================================================

% Redefine the plain pagestyle for CV headers and footers
\def\ps@plain{%
  \def\@oddhead{\color{\HeaderFooterColor}\itshape\HeaderText}%
  \def\@evenhead{\color{\HeaderFooterColor}\itshape\HeaderText}%
  \def\@oddfoot{\color{\HeaderFooterColor}\FooterText}%
  \def\@evenfoot{\color{\HeaderFooterColor}\FooterText}%
}
\pagestyle{plain}


% ============================================================
% Paragraph and page-breaking behavior
% ============================================================

% Disable paragraph indentation and extra spacing
\setlength{\parindent}{0in}
\setlength{\parskip}{0in}
% Prevent widows and orphans
\widowpenalties 1 10000
\clubpenalties 1 10000
\raggedbottom
% Footnote symbol formatting
% Text\footnote{Here is an example footnote.}
\renewcommand{\thefootnote}{\fnsymbol{footnote}}
\renewcommand{\footnotelayout}{\UseNoteFont}


% ============================================================
% High-level document structure
% ============================================================

% -------- Title block --------
\newcommand{\Title}[1]{%
  \par\vspace{0\baselineskip}
  \pdfbookmark[1]{#1}{title:\thepage}
  \begingroup
    \centering
    \UseTitleFont
    \MakeUppercase{#1}
  \par
  \endgroup
}

% -------- Subtitle block --------
\newenvironment{SubTitle}{%
  \par\vspace*{0.5\baselineskip}
  \begingroup
  \centering
  \UseMainFont
  \ignorespaces%
}{%
  \par
  \endgroup
  \vspace*{0.5\baselineskip}%
}

% -------- Main body list environment --------
\newenvironment{Body}{%
  \par\vspace{0.5\baselineskip}
  \begingroup
  \UseMainFont
  \begin{list}{}{%
    % Margins
    \setlength\leftmargin{\LeftColWidth}%
    \setlength\rightmargin{0in}%
    \setlength\labelwidth{\LeftColWidth}%
    \setlength\labelsep{0in}%
    % Indentation
    \setlength\listparindent{0in}%
    \setlength\itemindent{0in}%
    % Spacing
    \setlength\parskip{0in}%
    \setlength\topsep{0in}%
    \setlength\partopsep{0in}%
    \setlength\parsep{0in}%
    \setlength\itemsep{0\baselineskip}%
  }%
}{%
  \end{list}%
  \par
  \endgroup
}

% -------- Vertical spacing helper --------
% \Gap{<scale>} -> Default: 0.5 baselineskip
\newcommand{\Gap}[1][0.5]{\vspace{#1\baselineskip}}

% -------- Entry helper --------
\newcommand{\Entry}{%
  \par\vspace{0\baselineskip}% end previous paragraph
  \noindent% start entry flush-left
  \ignorespaces% ignore spaces after macro
}

% -------- Conditional suppression helper --------
\newcommand{\Hide}[1]{}


% ============================================================
% Sectioning commands
% ============================================================

% -------- Section heading with left-column label (list-based) --------
% \Section{LABEL}{Bookmark Title}{Bookmark ID}
\newcommand{\Section}[3]{%
  \Gap[1]
  \pdfbookmark[2]{#2}{#3}
  \par\vspace{0\baselineskip}
  \ifOverlappedMode
    % Overlapped / full-width mode
    \item[]
    \begingroup
    \parindent=0pt
    \parskip=0pt
    \parshape 1
      0pt \textwidth
    \noindent
    {\UseSectionFont\MakeUppercase{#1}\par}
    \vspace{3pt}
    \hrule height 0.4pt
    \par
    \endgroup
    \Gap%
  \else
    % Normal left-column mode
    \item[%
      \smash{%
        \parbox[t]{\LeftColWidth}{%
          \UseSectionFont
          \raggedright
          \MakeUppercase{#1}
        }%
      }%
    ]%
    \par
  \fi
}

% -------- Subsection heading (inline) --------
% \SubSection{LABEL}{Bookmark Title}{Bookmark ID}
\newcommand{\SubSection}[3]{%
  \par\vspace{0\baselineskip}
  \pdfbookmark[3]{#2}{#3}
  {%
    \UseSubSectionFont
    \raggedright
    #1
  }%
  \par
}


% ============================================================
% Item layout (bulleted and plain)
% ============================================================

% Bullet spacing and symbol
\newlength{\BulletIndent}
\setlength{\BulletIndent}{0.4em}
\newcommand{\BulletSymbol}{\raisebox{0.3ex}{\tiny\textbullet}}
% Internal boxes and width calculations
\newsavebox{\BulletItemIndentBox}
\newlength{\BulletItemIndentWidth}
\savebox{\BulletItemIndentBox}{%
  \hspace{0.8\BulletIndent}%
  \BulletSymbol%
  \hspace{\BulletIndent}%
}
\settowidth{\BulletItemIndentWidth}{\usebox{\BulletItemIndentBox}}

% -------- Bulleted item --------
\newcommand{\BulletItem}[1]{%
  \par\vspace{0\baselineskip}%
  \begingroup
  \parshape 2
    \LeftColWidth \linewidth
    \dimexpr\LeftColWidth+\BulletItemIndentWidth\relax
    \dimexpr\linewidth-\BulletItemIndentWidth\relax
  \usebox{\BulletItemIndentBox}%
  \ignorespaces%
  #1%
  \par
  \endgroup
}

% -------- Plain item --------
\newcommand{\Item}[1]{%
  \par\vspace{0\baselineskip}%
  \begingroup
  \parshape 1
    \dimexpr\LeftColWidth+\BulletItemIndentWidth\relax
    \dimexpr\linewidth-\BulletItemIndentWidth\relax
  \ignorespaces%
  #1%
  \par
  \endgroup
}


% ============================================================
% Numbered item system (internal)
% ============================================================

% A flexible numbered-item system supporting custom prefixes,
% suffixes, alignment, and optional bracketed labels.

% -------- Counter state --------
\newcounter{NumberedItemCounter}

% -------- Layout lengths and boxes --------
\newlength{\PubIndent}
\setlength{\PubIndent}{0.3em}
\newsavebox{\MaxNumberedItemIndentBox}
\newlength{\MaxNumberedItemIndentWidth}
\newsavebox{\NumberedItemIndentBox}
\newlength{\NumberedItemIndentWidth}

% -------- Internal prefix/suffix state --------
\newcommand{\NI@prefix}{}        % visible prefix
\newcommand{\NI@measureprefix}{} % width-only prefix
\newcommand{\NI@suffix}{}        % visible suffix
\newcommand{\NI@maxnumber}{}
\newif\ifNI@brackets

% -------- Label construction helper --------
\newcommand{\NI@makelabel}[3]{%
  \ifNI@brackets
    [#1#2#3]%
  \else
    #1#2#3%
  \fi
}

% -------- Maximum label width helper --------
\newcommand{\NI@setmaxwidth}{%
  \savebox{\MaxNumberedItemIndentBox}{%
    \hspace{0.2\PubIndent}%
    \NI@makelabel{\NI@measureprefix}{\NI@maxnumber}{\NI@suffix}%
    \hspace{\PubIndent}%
  }%
  \settowidth{\MaxNumberedItemIndentWidth}{%
    \usebox{\MaxNumberedItemIndentBox}%
  }%
}

% -------- Numbered item command --------
\newcommand{\NumberedItem}[1]{%
  \par
  \begingroup
  \stepcounter{NumberedItemCounter}%
  \edef\NI@currentlabel{%
    \NI@makelabel{\NI@prefix}{\arabic{NumberedItemCounter}}{\NI@suffix}%
  }%
  \savebox{\NumberedItemIndentBox}{%
    \hspace{0.2\PubIndent}\NI@currentlabel\hspace{\PubIndent}%
  }%
  \settowidth{\NumberedItemIndentWidth}{%
    \usebox{\NumberedItemIndentBox}%
  }%
  \parshape 2
    \LeftColWidth \linewidth
    \dimexpr\LeftColWidth+\MaxNumberedItemIndentWidth\relax
    \dimexpr\linewidth-\MaxNumberedItemIndentWidth\relax
  \hspace{\dimexpr
    \MaxNumberedItemIndentWidth-\NumberedItemIndentWidth\relax}%
  \usebox{\NumberedItemIndentBox}%
  \ignorespaces
  #1%
  \par
  \endgroup
}

% -------- Numbered item environment --------
% Args:
%  #1 prefix (may be empty)
%  #2 max number (e.g. 99)
%  #3 prefix used ONLY for width measurement
%  #4 suffix (may be empty)
%  #5 bracket flag: true / false
\newenvironment{numbereditems}[5]{%
  \begingroup
  \setcounter{NumberedItemCounter}{0}%
  \renewcommand{\NI@prefix}{#1}%
  \renewcommand{\NI@measureprefix}{#3}%
  \renewcommand{\NI@suffix}{#4}%
  \renewcommand{\NI@maxnumber}{#2}%
  \csname NI@brackets#5\endcsname
  \NI@setmaxwidth
}{%
  \endgroup
}


% ============================================================
% Compilation note
% ============================================================

\newcommand{\CompileNote}{%
  \par\vspace{0\baselineskip}
  \begingroup
  \UseNoteFont%
  \hfill[\textit{\CVNote}]%
  \par
  \endgroup
}

% End of class file
\endinput