<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                exclude-result-prefixes="xlink mml">

<!-- ====================================================================== -->
<!-- scielops.xsl: The base HTML XSL Stylesheet for SciELO PS spec.

     Authors: Gustavo Fonseca (gustavo.fonseca@scielo.org)
              Juan Funez (juan.funez@scielo.org)

     Copyright 2016 SciELO <scielo-dev@googlegroups.com>.
     Licensed under the terms of the BSD license. Please see LICENSE in the 
     source code for more information.
-->
<!-- ====================================================================== -->
    <xsl:preserve-space elements="*"/>

    <!-- Strip spaces from all the elements that cannot have mixed-content. -->
    <xsl:strip-space elements="
        copyright-year conf-date conf-loc conf-name conf-sponsor object-id isbn 
        issn issn-l issue issue-id issue-part issue-sponsor issue-title 
        journal-id volume volume-id volume-series etal publisher-name fpage 
        lpage page-range size elocation-id country email fax phone uri day 
        month season year contrib-id degrees given-names surname prefix suffix 
        alt-text long-desc meta-name article-id self-uri unstructured-kwd-group 
        conf-acronym conf-num journal-title journal-subtitle 
        abbrev-journal-title tex-math access-date edition patent pub-id 
        time-stamp annotation glyph-data"/>

    <xsl:param name="show.unhandled.elements" select="1"/>
    <xsl:param name="show.mathjax.cdnlink" select="1"/>
    <xsl:param name="article_lang" />
    <xsl:param name="is_translation" />
    <xsl:param name="issue_label" />
    <xsl:param name="styles_css_path" />

    <xsl:output method="html" 
                indent="no" 
                encoding="utf-8" 
                omit-xml-declaration="yes" 
                standalone="yes" />

    <!-- Output a warning for unhandled elements! --> 
    <xsl:template match="*">
        <xsl:if test="$show.unhandled.elements != 0">
            <xsl:message>
                <xsl:text>No template matches </xsl:text> 
                <xsl:value-of select="name(.)"/> 
                <xsl:text>.</xsl:text>
            </xsl:message>
            <font color="red"> 
                <xsl:text>&lt;</xsl:text> 
                <xsl:value-of select="name(.)"/> 
                <xsl:text>&gt;</xsl:text> 
                <xsl:apply-templates/> 
                <xsl:text>&lt;/</xsl:text> 
                <xsl:value-of select="name(.)"/> 
                <xsl:text>&gt;</xsl:text>
            </font>
        </xsl:if>
    </xsl:template>

    <!-- Recursively copy nodes adjusting its namespace to element-level scope. -->
    <!-- based on https://www.oxygenxml.com/archives/xsl-list/200301/msg00340.html -->
    <xsl:template mode="copy-no-ns" match="*">
        <xsl:element name="{local-name(.)}" namespace="{namespace-uri(.)}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="copy-no-ns"/>
        </xsl:element>
    </xsl:template>

    <!-- the document node. -->
    <xsl:template match="/">
        <xsl:if test="article/sub-article[@article-type = 'translation']">
            <xsl:message terminate="no">
                <xsl:text>All translations will be ignored.</xsl:text>
            </xsl:message>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- the outermost XML element. --> 
    <xsl:template match="article">
        <html>
            <xsl:if test="@xml:lang">
                <xsl:attribute name="lang">
                    <xsl:value-of select="@xml:lang"/>
                </xsl:attribute>
            </xsl:if>
            <head>
                <meta charset="utf-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1"/>
                <xsl:call-template name="css"/>
                <xsl:call-template name="script"/>
            </head>
            <body>
                <article class="container">
                    <xsl:apply-templates/>
                </article>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="front">
        <xsl:call-template name="article.header"/>
        <xsl:call-template name="article.abstracts"/>
    </xsl:template>

    <xsl:template match="body"> 
        <nav>
            <ul class="sps-sectionsList">
                <xsl:apply-templates mode="toc" select="sec"/>
            </ul>
        </nav>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="back">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template name="css">
        <link rel="stylesheet" 
              type="text/css" 
              href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" />
        <xsl:if test="$styles_css_path">
            <link rel="stylesheet" type="text/css" href="{$styles_css_path}"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="script">
        <xsl:if test="$show.mathjax.cdnlink != 0">
            <script type="text/javascript"
                    src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=MML_CHTML">
            </script>
        </xsl:if>
    </xsl:template>


    <!-- ================================================================== -->
    <!-- Front-matter elements -->

    <!-- Header: head-subject, article titles, citation, authors and affs -->
    <xsl:template name="article.header">
        <header>
            <p class="sps-headSubject">
                <xsl:value-of select="article-meta/article-categories/subj-group[@subj-group-type = 'heading']/subject/text()"/>
            </p>
            <xsl:apply-templates select="
                article-meta/title-group/article-title | 
                article-meta/title-group/trans-title-group/trans-title"/>

            <xsl:call-template name="article.doi"/>
            <xsl:call-template name="article.cit"/>
            <xsl:apply-templates select="article-meta/contrib-group"/>
            <xsl:apply-templates select="article-meta/aff"/>
            <xsl:apply-templates select="article-meta/author-notes"/>
        </header>
    </xsl:template>

    <xsl:template match="article-title">
        <h1 class="sps-articleTitle"><xsl:apply-templates/></h1>
    </xsl:template>

    <xsl:template match="trans-title">
        <p class="sps-transArticleTitle" 
           lang="{parent::trans-title-group/@xml:lang}">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="contrib-group">
        <ul class="sps-contribList list-inline">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="contrib">
        <xsl:variable name="target_uri" select="./xref/@rid"/>
        <li>
            <xsl:choose>
                <xsl:when test="string-length($target_uri) &gt; 0">
                    <a href="#{$target_uri}">
                        <xsl:apply-templates mode="contrib" select="name"/>
                        <xsl:apply-templates mode="contrib" select="xref"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="name"/>
                    <xsl:apply-templates mode="contrib" select="xref"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="position() = last()">
                    <xsl:text>.</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>,</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>

    <xsl:template mode="contrib" match="name">
        <xsl:value-of select="concat(given-names/text(), ' ', surname/text())"/>
    </xsl:template>

    <xsl:template mode="contrib" match="xref">
        <!--
          Cenários e resultados gerados:
          - contrib/xref tem valor:
            gera uma ancora com texto do tag: contrib/xref (normalmente um <sup/>)
          - contrib/xref NÃO tem valor:
            gera uma ancora com texto do tag: aff/label
          - contrib/xref tem valor, e aff/label NÃO tem valor
            gera uma ancora com texto igual ao atributo @rid do tag xref
        -->
        <xsl:variable name="xref_text_nodes" select="descendant-or-self::text()"/>
        <xsl:variable name="xref_rid" select="@rid"/>

        <xsl:choose>
            <xsl:when test="count($xref_text_nodes) = 0">
                <xsl:choose>
                    <xsl:when test="//aff[@id = $xref_rid]/label">
                        <sup>
                            <xsl:value-of select="//aff[@id = $xref_rid]/label"/>
                        </sup>
                    </xsl:when>
                    <xsl:otherwise>
                        <sup><xsl:value-of select="$xref_rid"/></sup>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="article.doi">
        <xsl:param name="article-meta" select="./article-meta"/>
        <xsl:variable name="doi" select="$article-meta/article-id[@pub-id-type = 'doi']"/>
        <xsl:if test="string-length($doi) &gt; 0">
            <p class="sps-doi">
                DOI: 
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat('http://dx.doi.org/', $doi)"/>
                    </xsl:attribute>
                    <xsl:value-of select="$doi"/>
                </a>
            </p>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="article.cit">
        <xsl:param name="article-meta" select="./article-meta"/>
        <xsl:param name="journal-meta" select="$article-meta/../journal-meta"/>
        <xsl:variable name="volnum">
            <xsl:variable name="fmt_issue">
                <xsl:if test="$article-meta/issue">
                    (<xsl:value-of select="$article-meta/issue"/>)
                </xsl:if>
            </xsl:variable>
            <xsl:value-of select="concat(
                normalize-space($article-meta/volume),
                normalize-space($fmt_issue))"/>
        </xsl:variable>
        <xsl:variable name="fmt_volnum">
            <xsl:if test="$volnum">
                ;<xsl:value-of select="$volnum"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="location">
            <xsl:choose>
                <xsl:when test="$article-meta/fpage">
                    <xsl:value-of select="concat($article-meta/fpage, '-', $article-meta/lpage)"/>
                </xsl:when>
                <xsl:when test="$article-meta/elocation-id">
                    <xsl:value-of select="$article-meta/elocation-id"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <p class="sps-cit">
            <xsl:value-of select="concat(
                normalize-space($journal-meta//abbrev-journal-title[@abbrev-type = 'publisher']),
                '&#10;',
                normalize-space($article-meta/pub-date/year),
                normalize-space($fmt_volnum),
                ':',
                normalize-space($location))"/>
        </p>
    </xsl:template>
    
    <xsl:template match="aff">
        <p id="{@id}">
            <sup><xsl:value-of select="label"/></sup>
            <xsl:text>&#10;</xsl:text>
            <xsl:value-of select="institution[@content-type = 'original']"/>
        </p>
    </xsl:template>

    <!-- Abstracts section -->
    <xsl:template name="article.abstracts">
        <xsl:param name="article-meta" select="./article-meta"/>

        <xsl:if test="$article-meta/abstract | $article-meta/trans-abstract">
            <!-- outermost container for abstracts, targeted by nav link -->
            <div id="sps-abstractGroup">
                <xsl:for-each select="$article-meta/abstract | 
                    $article-meta/trans-abstract">
                    <xsl:call-template name="article.abstract">
                        <xsl:with-param name="abstract" select="."/>
                    </xsl:call-template>
                </xsl:for-each>
            </div>
        </xsl:if>
    </xsl:template>

    <!-- Display the abstract and keywords -->
    <xsl:template name="article.abstract">
        <xsl:variable name="abs_lang">
            <xsl:choose>
                <xsl:when test="@xml:lang">
                    <xsl:value-of select="@xml:lang"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="/article/@xml:lang"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <section>
            <xsl:apply-templates mode="abstract"/>
            <xsl:apply-templates select="//kwd-group[@xml:lang = $abs_lang]"/>
        </section>
    </xsl:template>

    <xsl:template mode="abstract" match="title">
        <header>
            <h1><xsl:apply-templates/></h1>
        </header>
    </xsl:template>

    <!-- bypass to the generic element handler -->
    <xsl:template mode="abstract" match="sec|p">
        <xsl:apply-templates select="."/>
    </xsl:template>

    <xsl:template match="kwd-group">
        <ul class="sps-keywordsList list-inline">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="kwd">
        <li class="sps-keyword">
            <xsl:apply-templates/>
            <xsl:choose>
                <xsl:when test="position() = last()">
                    <xsl:text>.</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>,</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>

    <xsl:template match="author-notes">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="corresp">
        <p><xsl:apply-templates/></p>
    </xsl:template>


    <!-- ================================================================== -->
    <!-- Reference list -->
    <xsl:template match="ref-list">
        <section id="sps-referencesList">
            <xsl:apply-templates select="title"/>
            <ul class="sps-referencesList">
                <xsl:apply-templates select="ref"/>
            </ul>
        </section>
    </xsl:template>

    <xsl:template match="ref-list/title">
        <header>
            <h2><xsl:apply-templates/></h2>
        </header>
    </xsl:template>

    <xsl:template match="ref/label">
        <span class="sps-citationLabel">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="ref/mixed-citation">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ref">
        <li class="sps-citation">
            <cite id="{@id}" class="sps-citationContent">
                <xsl:apply-templates select="label"/>
                <xsl:apply-templates select="mixed-citation"/>
            </cite>
        </li>
    </xsl:template>


    <!-- ================================================================== -->
    <!-- Document sections -->
    <xsl:template match="sec">
        <section>
            <xsl:if test="@sec-type">
                <xsl:attribute name="id">
                    <xsl:value-of select="@sec-type"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </section>  
    </xsl:template>

    <xsl:template mode="toc" match="sec">
        <li>
            <a href="#{@sec-type}"><xsl:value-of select="./title"/></a>
        </li>  
    </xsl:template>


    <xsl:template match="sec/title">
        <header>
            <h1><xsl:apply-templates/></h1>
        </header>
    </xsl:template>


    <!-- ================================================================== -->
    <!-- table: the XHTML table model -->

    <!-- TODO: 2016-04-26 : Prevent the copy of deprecated attributes! -->
    <!-- https://developer.mozilla.org/en-US/docs/Web/HTML/Element/table -->
    <xsl:template match="caption|col|colgroup|tfoot|thead|tr|tbody|td|th">
        <xsl:element name="{local-name(.)}">
            <xsl:for-each select="@*">
                <xsl:copy>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="table">
        <xsl:element name="{local-name(.)}">
            <xsl:for-each select="@*">
                <xsl:copy>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:for-each>
            <xsl:attribute name="class">
                <xsl:text>table</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="table-wrap.caption"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="table-wrap-foot">
        <section class="sps-footnotes">
            <xsl:apply-templates/>
        </section>
    </xsl:template>

    <!-- label and title related to the table  -->
    <xsl:template name="table-wrap.caption">
        <xsl:param name="table-wrap" select=".."/>
        <caption>
            <p><xsl:value-of select="$table-wrap/label"/>.</p>
            <p><xsl:value-of select="$table-wrap/caption/title"/></p>
        </caption>
    </xsl:template>

    <!-- table caption should not be handled in a rule-based strategy. -->
    <xsl:template match="table-wrap/label | table-wrap/caption">
        <!-- suppress -->
    </xsl:template>

    <xsl:template match="table-wrap">
        <div class="sps-tableWrap table-responsive">
            <xsl:if test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </div>
    </xsl:template>


    <!-- ================================================================== -->
    <!-- Math: MathML and LaTeX support -->

    <xsl:template match="disp-formula | inline-formula">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="mml:math">
        <xsl:apply-templates mode="copy-no-ns" select="."/>
    </xsl:template>


    <!-- ================================================================== -->
    <!-- Footnotes -->

    <xsl:template match="fn-group">
        <section class="Footnotes">
            <xsl:apply-templates select="title"/>
            <xsl:apply-templates select="fn"/>
        </section>
    </xsl:template>

    <xsl:template match="fn-group/title">
        <header>
            <h1><xsl:apply-templates/></h1>
        </header>
    </xsl:template>

    <xsl:template mode="footnote" match="label">
        <sup><xsl:apply-templates/></sup>
    </xsl:template>

    <xsl:template mode="footnote" match="p">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="fn">
        <p class="sps-footnoteContent">
            <xsl:if test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="footnote"/>
        </p>
    </xsl:template>


    <!-- ================================================================== -->
    <!-- Formatting elements -->

    <!-- break: line break -->
    <!-- equates to HTML <br/> -->
    <xsl:template match="break">
        <br/>
    </xsl:template>

    <!-- italic: in-line italics -->
    <!-- equates to HTML <i> -->
    <xsl:template match="italic">
        <i><xsl:apply-templates/></i>
    </xsl:template>

    <!-- bold: in-line emphasis -->
    <!-- equates to HTML <b> -->
    <xsl:template match="bold">
        <b><xsl:apply-templates/></b>
    </xsl:template>

    <!-- strike: in-line strikethrough -->
    <!-- equates to HTML <s> -->
    <xsl:template match="strike">
        <s><xsl:apply-templates/></s>
    </xsl:template>

    <!-- hr: an explicit horizontal rule -->
    <!-- equates to HTML <hr/> -->
    <xsl:template match="hr">
        <hr/>
    </xsl:template>


    <!-- ================================================================== -->
    <!-- Floating elements -->

    <xsl:template match="xref">
        <a href="#{@rid}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <xsl:template match="p|sup|sub">
        <xsl:element name="{name()}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="ext-link[@ext-link-type = 'uri']">
        <a>
            <xsl:if test="@xlink:href">
                <xsl:attribute name="href">
                    <xsl:value-of select="@xlink:href"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <xsl:template match="label">
        <strong><xsl:apply-templates/></strong>
    </xsl:template>

    <xsl:template match="email">
        <xsl:variable name="email" select="text()"/>
        <a href="mailto:{$email}"><xsl:value-of select="$email"/></a>
    </xsl:template>

</xsl:stylesheet>
