<?xml version="1.0" encoding="utf-8"?>
<!-- ====================================================================== -->
<!-- mainlangfilter.xsl: 

     Authors: Gustavo Fonseca (gustavo.fonseca@scielo.org)

     Copyright 2016 SciELO <scielo-dev@googlegroups.com>.
     Licensed under the terms of the BSD license. Please see LICENSE in the 
     source code for more information.

     This work is based on the project github.com/ncbi/JATSPreviewStylesheets 
     by the National Library of Medicine (NLM).
-->
<!-- ====================================================================== -->
<!--  Function of this stylesheet:

       This stylesheet filters Journal Publishing data based
       on the article/@article-type attribute. In this version 
       elements sub-article[@article-type='translation' are 
       excluded from the results, while the main article is passed 
       through.           -->

<xsl:transform version="1.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="no"/>


<xsl:template match="sub-article[@article-type = 'translation']"/>
<!-- match and drop these elements -->


<xsl:template match="@*|node()">
  <!-- match and copy these nodes -->
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>


</xsl:transform>

