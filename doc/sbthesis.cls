% 
% sbthesis.cls v.1.2.1
% 
% CSU San Bernardino Master's Thesis LaTex Class
% 
% Writen by:
%    Keith Evan Schubert, Ph.D., E.I.T.  
%    August 31, 2005
%    v.0.1
% Based off:
%    University of Oxford tex file - Which I thought looked nice
% Contents:
%    Basic layout, titlepage, dedication, acknowledgements, abstract
% 
% Modified by:
%    Keith Evan Schubert, Ph.D., E.I.T.
%    October 6, 2006
%    v.0.2
%    Made it follow rules more precisely
%
%    Tom Seward Lee, M.S.
%    November 5, 2006
%    v.0.3
%    Put in reviewer's requirements
%
%    Keith Evan Schubert, Ph.D., E.I.T.
%    February 26, 2007
%    v.1.0
%    Final Reviewer Commments
%
%    Keith Evan Schubert, Ph.D., E.I.T.
%    November 17, 2008
%    v.1.1
%    advisor is now chair, fixed appendix numbering and listing,
%    updated department name
%
%    Keith Evan Schubert, Ph.D., E.I.T.
%    November 18, 2008
%    v.1.1.1
%    Fixed bibliography problem.
%
% Rules:
%    12pt courier -> I will use 12pt computer modern, it looks better
%    Double space
%    Margins (T=1.25,L=1.5,R=1,B=1.25,footer=.75)       % change bottom margin to .75
%    Footer should be centered and have only the page number
%
%    Keith Evan Schubert, Ph.D., E.I.T.
%    January 25, 2009
%    v.1.1.2
%    My version and the web version of 1.1.1 was somehow different, so I am
%    calling my version 1.1.2 and uploading it.
%
%    Zonqi Ritchie Cai
%    January 27, 2010
%    v.1.1.3
%    Removed preliminary from proposal, changed signature sheet to new standard
%
%
%    Keith Evan Schubert, Ph.D., E.I.T.
%    October 28, 2010
%    v.1.2
%    advisor is advisor again, Department of CS is School of CSE.
%
%    Keith Evan Schubert, Ph.D., E.I.T.
%    November 3, 2010
%    v.1.2.1
%    left justify dedication.
\NeedsTeXFormat{LaTeX2e} 
\ProvidesClass{sbthesis}[2010/10/28 CSUSB Thesis Class] 
\RequirePackage{ifthen}
\RequirePackage{suffix}
\RequirePackage{couriers}
\RequirePackage[letterpaper]{geometry}
\RequirePackage{fancyhdr}
%\RequirePackage{tocloft}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{thesis}}
\ProcessOptions\relax
\LoadClass{thesis}
\typeout{***************************************************************}
\typeout{** California State University, San Bernardino Thesis Class  **}
\typeout{** Written by Keith Evan Schubert                            **}
\typeout{**            Professor                                      **}
\typeout{**            School of Computer Science and Engineering     **}
\typeout{***************************************************************}

\renewcommand{\normalsize}{\fontsize{12pt}{12pt}\selectfont} 
\geometry{paperwidth=8.5in,paperheight=11in,includehead=false,top=1.25in,left=1.5in,right=1in,bottom=1.25in,footskip=.5in}%,showframe}
%\geometry{paperwidth=8.5in,paperheight=11in,includehead=false,top=1.25in,left=1.5in,right=1in,bottom=.75in,footskip=.5in}%,showframe}
\markboth{}{}%clear the old headers that comes from thesis
\renewcommand{\headrulewidth}{0mm}
\renewcommand{\footrulewidth}{0mm}
\fancypagestyle{plain}{\fancyhf{}\fancyfoot[c]{\thepage}}%reset plain
\fancyhf{}\fancyhead{}\fancyfoot{}%clear fields
\lhead[]{}\lfoot[]{} 
\chead[]{}\cfoot[\thepage]{\thepage} 
\rhead[]{}\rfoot[]{} 
%
%
% Change table of contents name from Contents (default) to Table of Contents
\renewcommand{\contentsname}{Table of Contents}
\addtocontents{toc}{\protect\thispagestyle{fancy}}
% Change bibliography name from Bibliography (default) to References
\renewcommand{\bibname}{References}
%Need the following for thesis separation, they want 2"
\newcommand{\Hline}[1][2in]{\rule{#1}{1.0pt}\par}   % dividing lines on signature and title page:  0.75 or 1.0 pt weight
\newcommand{\ListOfFigures}{\clearpage\addcontentsline{toc}{chapter}{List of Figures}\listoffigures
                            \addtocontents{lof}{\protect\thispagestyle{fancy}}}
\newcommand{\ListOfTables}{\clearpage\addcontentsline{toc}{chapter}{List of Tables}\listoftables
                           \addtocontents{lot}{\protect\thispagestyle{fancy}}}
\newcommand{\NoFigures}{\renewcommand{\ListOfFigures}{}}
\newcommand{\NoTables}{\renewcommand{\ListOfTables}{}}
\newif\ifappendix\appendixfalse
\newif\iffigure\figurefalse
\let\oldcaption\caption
  \renewcommand{\caption}[1]{   \ifappendix
                                   \iffigure
                                     {Figure #1}
                                   \else
                                     {Table #1}
                                   \fi
                                 \else
                                   \oldcaption{#1}
                                 \fi
                                 }
\renewcommand\appendix{%\par
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \renewcommand{\theequation}{\Alph{chapter}-\arabic{equation}}
  \renewcommand{\thesection}{\Alph{chapter}.\arabic{section}}
  \renewcommand{\thesubsection}{\Alph{chapter}.\arabic{section}.\arabic{subsection}}
  \renewcommand{\thetable}{\Alph{chapter}.\arabic{table}}
  \renewcommand{\thefigure}{\Alph{chapter}.\arabic{figure}}
  \appendixtrue
}
\newcommand{\Appendix}[1]{
  \clearpage\addtocounter{chapter}{1} \addcontentsline{toc}{chapter}{Appendix~\Alph{chapter}: {#1}} \vspace*{2.30in}
\begin{center}
{\Large {\MakeUppercase{Appendix~\Alph{chapter}}}}
\end{center}
\begin{center}
{\Large {\MakeUppercase{#1}}}
\end{center}
\newpage
  }
%\setlength{\cftfigindent}{0em}
% Must ensure in single column mode for frontmatter
\newenvironment{alwayssingle}{%
       \@restonecolfalse
       \if@twocolumn\@restonecoltrue\onecolumn
       \else\if@openright\cleardoublepage\else\clearpage\fi
       \fi}%
       {\if@restonecol\twocolumn
       \else\newpage\fi}
%
%                    Thesis Proposal
%
\newcommand{\ThesisProposal}{
\gdef\@papertype{Masters Thesis Proposal}\pagenumbering{roman}\pagestyle{empty}\renewcommand{\baselinestretch}{1.9}
\clearpage
\MakeTitle
\CommentPage
\pagestyle{fancy}\setcounter{page}{3}
\tableofcontents
\ListOfFigures
\ListOfTables\clearpage
\pagenumbering{arabic}\setcounter{page}{1}
\renewcommand{\normalsize}{\fontsize{12pt}{12pt}\selectfont} 
\renewcommand{\baselinestretch}{1.9}
\normalsize}
%
%                    Thesis
%
\newcommand{\Thesis}{
\gdef\@papertype{Thesis}\pagenumbering{roman}\pagestyle{empty}\renewcommand{\baselinestretch}{1.9}
\thispagestyle{empty}\clearpage\null% blank page comes first
\MakeCover% title page is second
\MakeApprovalPage% signature page is third
\CopyrightPage% optional fourth
\pagestyle{fancy}\setcounter{page}{3}
\normalsize
\begin{Abstract}% abstract fifth
\addcontentsline{toc}{chapter}{Abstract}
\@csusbabstract
\end{Abstract}
\begin{AcknowledgementsLong}% optional acknowledgements sixth
\addcontentsline{toc}{chapter}{Acknowledgements}
\@csusbacknowledgement
\end{AcknowledgementsLong}
\@csusbdedication% optional dedication seventh
%\addcontentsline{toc}{chapter}{Table of Contents}% Table of contents is eighth
\tableofcontents
% list of tables is ninth
\ListOfTables
% list of illustrations(figures/graphs/maps/plates) is tenth/last
\ListOfFigures
\clearpage
\pagenumbering{arabic}\setcounter{page}{1} % was labelling last page of listoffigures as page 0
\renewcommand{\normalsize}{\fontsize{12pt}{14pt}\selectfont} 
\renewcommand{\baselinestretch}{1.9}   % for double spacing (1.9 spacing)
%\renewcommand{\baselinestretch}{1.5}    % for 1.5 spacing
\normalsize}

  
%
%                    Project Proposal
%
\newcommand{\ProjectProposal}{
\gdef\@papertype{Masters Project Proposal}\renewcommand{\baselinestretch}{1.9}
\MakeTitle
\CommentPage
\tableofcontents
\ListOfFigures
\ListOfTables\clearpage
\pagenumbering{arabic}\setcounter{page}{1}
\renewcommand{\normalsize}{\fontsize{12pt}{12pt}\selectfont} 
\renewcommand{\baselinestretch}{1.9}
\normalsize}
%
%                    Project
%
\newcommand{\Project}{
\gdef\@papertype{Project}\pagenumbering{roman}\pagestyle{empty}\renewcommand{\baselinestretch}{1.9}
\thispagestyle{empty}\clearpage\null% blank page comes first
\MakeCover% title page is second
\MakeApprovalPage% signature page is third
\CopyrightPage% optional fourth
\pagestyle{fancy}\setcounter{page}{3}
\begin{Abstract}% abstract fifth
\addcontentsline{toc}{chapter}{Abstract}
\@csusbabstract
\end{Abstract}
\begin{AcknowledgementsLong}% optional acknowledgements sixth
\addcontentsline{toc}{chapter}{Acknowledgements}
\@csusbacknowledgement
\end{AcknowledgementsLong}
\@csusbdedication% optional dedication seventh
%\addcontentsline{toc}{chapter}{Table of Contents}% Table of contents is eighth
\tableofcontents
% list of tables is ninth
\ListOfTables
% list of illustrations(figures/graphs/maps/plates) is tenth/last
\ListOfFigures\clearpage
\pagenumbering{arabic}\setcounter{page}{1}
\renewcommand{\normalsize}{\fontsize{12pt}{12pt}\selectfont} 
\renewcommand{\baselinestretch}{1.9}
\normalsize}
%
%               Declaring Variables
%
\gdef\@titlelinetwo{}
\newcommand{\TitleLineTwo}[1]{\gdef\@titlelinetwo{#1}}
\newcommand{\Department}[1][School of Computer Science and Engineering]{\gdef\@department{#1}}
\newcommand{\EmailAddress}[1]{\gdef\@email{#1}}
\newcommand{\Advisor}[1]{\gdef\@advisor{#1}}
\newcommand{\Committee}[2]{\gdef\@committeea{#1}
                           \gdef\@committeeb{#2}
                           \gdef\@committeelastline{}
                           \gdef\@commentspace{2in}
                           \gdef\@commentlastline{}
                           \gdef\@committeelastlinethesis{}}
\WithSuffix\newcommand\Committee*[3]{\gdef\@committeea{#1}
                           \gdef\@committeeb{#2}
                           \gdef\@committeec{#3}                        
                           \gdef\@committeelastline{&&\@committeec\\}                           
                           \gdef\@commentspace{.7in}
                           \gdef\@commentlastline{
%                             {\textbf{COMMITTEE MEMBER 3: \@committeec}\par}                             
                             \vspace*{\@commentspace}
                             {\CommentApproval\par}}
                           \gdef\@committeelastlinethesis{
                                  & &      \\                                  
                                  & &      \\ \cline{1-1}
      \texttt{\@committeec}       & &      \\}}
\newcommand{\CSUSBDate}[1]{\gdef\@thedate{#1}}
%\newcommand{\CopyrightPage}{}
\newcommand{\CopyrightPage}{\begin{alwayssingle}
  \thispagestyle{empty}\begin{center}
  \vspace*{2.75in}
  {\LARGE \copyright \hspace{.1in}\number\year\hspace{.1in} \@author}
  \end{center}\end{alwayssingle}
 }
\newcommand{\Copyright}{\renewcommand{\CopyrightPage}{\begin{alwayssingle}
  \thispagestyle{empty}\begin{center}
  \vspace*{2.75in}
  {\LARGE \copyright \hspace{.1in}\number\year\hspace{.1in} \@author}
  \end{center}\end{alwayssingle}
 }}
\newcommand{\AbstractText}[1]{\gdef\@csusbabstract{#1}}
\newcommand{\AcknowledgementText}[1]{\gdef\@csusbacknowledgement{#1}}
\gdef\@csusbdedication{}
\newcommand{\DedicationText}[1]{\gdef\@csusbdedication{\begin{Dedication}{#1}\end{Dedication}}}
%
%                    TITLE PAGE
%
\newcommand{\MakeTitle}{%
  \begin{alwayssingle}
    \thispagestyle{empty}
    \begin{center}
      {\large \textbf{California State University, San Bernardino}\par}
      {\large \textbf{\@department}\par}
      \vspace*{1.5in}
      {\large\textbf{\@papertype}\par}
      \vspace*{.2in}
      {For \par}
      {\Large\textbf{\@title}\par}
      \vspace*{.2in}
      {By \par}
      {\large\textbf{\@author} \par}
      {\textless\@email\textgreater \par}
      \vspace*{1.5in}
      {\begin{tabular}{lll}
        ADVISOR:   && \@advisor    \\
        MEMBERS: && \@committeea \\
                 && \@committeeb \\
                 \@committeelastline
      \end{tabular}\par}
      \vspace*{1in}
      {\@thedate}
    \end{center}
    \null\vfill
  \end{alwayssingle}
}
%
%                    COVER PAGE
%
\newcommand{\MakeCover}{%
  \begin{alwayssingle}
    \thispagestyle{empty}
    \begin{center}{\large
      {\texttt{\MakeUppercase{\@title}}\par}
      {\texttt{\MakeUppercase{\@titlelinetwo}}\par}
%      \vspace*{0.1in}\Hline\vspace*{.35in}      % first format review specs
%      \vspace*{0.25in}\Hline\vspace*{.3in}      % second format review specs
%      \vspace*{0.6375in}\Hline\vspace*{0.3in}      % third format review specs
      \vspace*{-0.15in}\Hline\vspace*{0.3in}      % fourth format review specs      
      {\texttt{A \@papertype}\par}
      {\texttt{Presented to the} \par}
      {\texttt{Faculty of} \par}
      {\texttt{California State University,} \par}
      {\texttt{San Bernardino} \par}
%      \vspace*{0.1in}\Hline\vspace*{.35in}      % first format review specs
%      \vspace*{0.2in}\Hline\vspace*{.45in}      % second format review specs      
      \vspace*{0.2in}\Hline\vspace*{.29375in}      % third format review specs            
      {\texttt{In Partial Fulfillment} \par}
      {\texttt{of the Requirements for the Degree} \par}
      {\texttt{Master of Science} \par}
      {\texttt{in} \par}
      {\texttt{Computer Science} \par}
%      \vspace*{0.1in}\Hline\vspace*{.35in}      % first format review specs
%      \vspace*{0.4in}\Hline\vspace*{.3in}      % second format review specs      
      \vspace*{0.24375in}\Hline\vspace*{.3in}      % third format review specs            
      {\texttt{by} \par}
      {\texttt{\@author} \par}
      {\texttt{\@thedate} \par}}
    \end{center}
    \null\vfill
  \end{alwayssingle}
}
%
%                    APPROVAL PAGE
%
\newcommand{\MakeApprovalPage}{%
  \begin{alwayssingle}
    \thispagestyle{empty}
    \begin{center}{\large
      {\texttt{\MakeUppercase{\@title}}\par}
      {\texttt{\MakeUppercase{\@titlelinetwo}}\par}
%      \vspace*{0.1in}\Hline\vspace*{.35in}      % first format review specs
%      \vspace*{0.25in}\Hline\vspace*{.3in}      % second format review specs
%      \vspace*{0.6375in}\Hline\vspace*{0.3in}      % third format review specs
      \vspace*{-0.15in}\Hline\vspace*{0.3in}      % fourth format review specs            
      {\texttt{A \@papertype}\par}
      {\texttt{Presented to the} \par}
      {\texttt{Faculty of} \par}
      {\texttt{California State University,} \par}
      {\texttt{San Bernardino} \par}
%      \vspace*{0.1in}\Hline\vspace*{.35in}      % first format review specs
%      \vspace*{0.2in}\Hline\vspace*{.3in}      % second format review specs      
      \vspace*{0.2in}\Hline\vspace*{.15in}      % third format review specs     
      {\texttt{by} \par}
      {\texttt{\@author} \par}
      {\texttt{\@thedate} \par}
%      \vspace*{0.15in}
      \vspace*{0in}      
      \texttt{Approved by:} \par}
      \vspace*{.3in}
      \begin{tabular}{p{4.1in}@{}p{.5in}@{}p{1.1in}}
                                  & &      \\ \cline{1-1}\cline{3-3}
%      \texttt{\@advisor, Advisor} & & \hspace{.05in}\texttt{Date} \\
      \texttt{\@advisor, Advisor, \@department} & & \hspace{.05in}\texttt{Date} \\      
%      \texttt{\@department}   & &      \\
                                  & &      \\
% added new lines here                                  
                                  & &      \\
                                  & &      \\ \cline{1-1}
      \texttt{\@committeea}       & &      \\
                                  & &      \\
% added new lines here                                  
                                  & &      \\                                  
                                  & &      \\ \cline{1-1}
      \texttt{\@committeeb}       & &      \\
                                  & &      \\
      \@committeelastlinethesis 
      \end{tabular}
    \end{center}
    \null\vfill
  \end{alwayssingle}}
%
%                    COMMENTS/SUGGESTIONS
%
\newcommand{\CommentApproval}{
  % ======== Original ========
  % \begin{tabular}{p{3em}p{1in}p{3em}p{1.5in}p{1.5in}}
  % & APPROVE && DISAPPROVE & \\ \cline{1-1} \cline{3-3} \cline{5-5}
  % &         &&            & Signature/Date \\
  % \end{tabular}
  \begin{tabular}{p{0.8in}p{3em}p{1in}p{3em}p{0.7in}p{5em}}
    APPROVE && DISAPPROVE && REASON: & \\ \cline{2-2} \cline{4-4} \cline{6-6}
            &&            &&        & \\  
    COMMENTS: &&            &&        & \\  
  \end{tabular}
}
\newcommand{\CommentPage}{\thispagestyle{empty}
  \begin{center}
    {\textbf{PROPOSED COMMITTEE COMMENTS/SUGGESTIONS}\par}
  \end{center}
  % ======== Original ========
  % {\textbf{ADVISOR: \@advisor}\par}
  % \vspace*{\@commentspace}
  % {\CommentApproval\par}
  % {\textbf{COMMITTEE MEMBER 1: \@committeea}\par}
  % \vspace*{\@commentspace}
  % {\CommentApproval\par}
  % {\textbf{COMMITTEE MEMBER 2: \@committeeb}\par}
  % \vspace*{\@commentspace}
  % {\CommentApproval\par}
  % \@commentlastline

  \vspace{0.4in}  
  % ---------------------------------------------------
  \begin{tabular}{p{3.8in}p{7em}}
    {\textbf{ADVISOR: \@advisor}} & \\ \cline{2-2}
                                & Signature/Date \\
  \end{tabular}

  \vspace{0.2in}
  {\CommentApproval\par}
  \vspace*{\@commentspace}

  % ---------------------------------------------------
  \begin{tabular}{p{3.8in}p{7em}}
    {\textbf{COMMITTEE MEMBER 1: \@committeea}} & \\ \cline{2-2}
                                                & Signature/Date \\
  \end{tabular}

  \vspace{0.2in}
  {\CommentApproval\par}
  \vspace*{\@commentspace}

  % ---------------------------------------------------
  \begin{tabular}{p{3.8in}p{7em}}
    {\textbf{COMMITTEE MEMBER 1: \@committeeb}} & \\ \cline{2-2}
                                                & Signature/Date \\
  \end{tabular}

  \vspace{0.2in}
  {\CommentApproval\par}
  \vspace*{\@commentspace}

  % ---------------------------------------------------

  \@commentlastline
}
%
%                    DEDICATION
%
% The dedication environment makes sure the dedication gets its
% own page and is set out in verse format.
\newenvironment{Dedication}{
  \begin{alwayssingle}
  \thispagestyle{empty}
  \begin{center}
  \vspace*{1.5cm}
%  {\LARGE Dedication}
    {\LARGE DEDICATION}
  \end{center}
  \vspace{0.5cm}\begin{verse}}
{\end{verse}\end{alwayssingle}}
% ACKNOWLEDGEMENTS
%
% The acknowledgements environment puts a large, bold, centered 
% "Acknowledgements" label at the top of the page. The acknowledgements
% themselves appear in a quote environment, i.e. tabbed in at both sides, and
% on its own page.
\newenvironment{Acknowledgements}{
\begin{alwayssingle} \thispagestyle{fancy}
\begin{center}
\vspace*{1.5cm}
%{\Large \bfseries ACKNOWLEDGEMENTS}
{\Large ACKNOWLEDGEMENTS}
\end{center}
\vspace{0.5cm}
\begin{quote}}
{\end{quote}\end{alwayssingle}}
% The acknowledgementslong environment puts a large, bold, centered 
% "Acknowledgements" label at the top of the page. The acknowledgement itself 
% does not appears in a quote environment so you can get more in.
\newenvironment{AcknowledgementsLong}
{\begin{alwayssingle} \thispagestyle{fancy}
\begin{center}
\vspace*{1.5cm}
%{\Large \bfseries ACKNOWLEDGEMENTS}
{\Large ACKNOWLEDGEMENTS}
\end{center}
\vspace{0.5cm}}
{\end{alwayssingle}}
%ABSTRACT
%
%The abstract environment puts a large, bold, centered "Abstract" label at
%the top of the page. The abstract itself appears in a quote environment,
%i.e. tabbed in at both sides, and on its own page.
\newenvironment{Abstract} {\begin{alwayssingle} \thispagestyle{fancy}
  \begin{center}
  %\vspace*{1.5cm}
%  {\Large \bfseries  ABSTRACT}
  {\Large ABSTRACT}  
  \end{center}
  \vspace{0.5cm}
   \begin{quote}}
{\end{quote}\end{alwayssingle}}
%The abstractlong environment puts a large, bold, centered "Abstract" label at
%the top of the page. The abstract itself does not appears in a quote
%environment so you can get more in.
\newenvironment{AbstractLong} {\begin{alwayssingle} \thispagestyle{empty}
  \begin{center}
  \vspace*{1.5cm}
%  {\Large \bfseries  Abstract}
  {\Large Abstract}  
  \end{center}
  \vspace{0.5cm}}
{\end{alwayssingle}}
%
% Chapter with starting page number
%
\newcommand{\Chapter}[1]{\chapter{#1}\protect\thispagestyle{fancy}}
%
%  Bibliography
%
\newcommand{\Bibliography}[1]{\bibliographystyle{plain}\bibliography{#1}}
\let\@sbthebibliography\thebibliography
\renewcommand{\thebibliography}[1]{
                \@sbthebibliography{#1}%
\protect\thispagestyle{fancy}
\addcontentsline{toc}{chapter}{\bibname}}


