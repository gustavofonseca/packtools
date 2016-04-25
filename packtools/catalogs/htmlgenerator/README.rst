Sobre a geração de HTML à partir do XML SciELO PS
=================================================

Um arquivo XML SciELO PS pode representar 1 ou vários documentos distintos, 
porém correlatos, que por sua vez podem resultar em 1 ou vários recursos na web. 
O exemplo típico é do artigo que apresenta versões em outros idiomas, onde 
cada tradução é representada por um elemento ``sub-article``, em um mesmo 
arquivo XML.


Estrutura do HTML
-----------------

Cabeçalho do artigo::

    <header>
        <p class="sps-headSubject">Original Articles</p>
        <h1 class="sps-articleTitle">Depressive symptoms in institutionalized 
        older adults</h1>
        <p class="sps-transArticleTitle" lang="pt">Sintomas depressivos em 
        idosos institucionalizados</p>
        <p class="sps-doi">
            <a href="">numero doi</a>
        </p>
        <ul class="sps-contribList">
            <li class="sps-contributor">Foo, Bar</li>
        </ul>
        <p class="sps-contributorMeta" id=""><sup></sup></p>
    </header>


Resumos::

    <div id="sps-abstractGroup">
        <section>
            <header>
                <h1>Resumo</h1>
            </header>
            <section>
                <header>
                    <h1>Objetivo</h1>
                </header>
                <p>Bla</p>
            </section>
            <section>
                <header>
                    <h1>Métodos</h1>
                </header>
                <p>Bla</p>
            </section>
        </section>
    </div>


Sumário::

    <nav>
        <ul class="sps-sectionsList">
            <li><a href="#intro">Introduction</a></li>
        </ul>
    </nav>


Seções::

    <section id="intro">
        <header>
            <h1>Introduction</h1>
        </header>
        <p>Depression is a mood disorder that is most often encountered among 
        older individuals. 15 It is pointed out as one of the conditions 
        responsible for high morbidity-mortality risk, more frequent use of 
        healthcare services, low adherence to therapy and treatment and 
        self-care behavior, and suicide.</p>
        <p>Multiple risk factors for depression have been identified, including 
        social, demographic, psychological and health factors.</p>
    </section>


Citações::

    <section id="sps-referencesList">
        <ul class="sps-referencesList">
            <li class="sps-citation">
                <cite id="B1" class="sps-citationContent">
                    <span class="sps-citationLabel">1.</span>
                    Aires M, Paz AA, Perosa CT. Situação de saúde e grau de 
                    dependência de pessoas idosas institucionalizadas. Rev Gaucha 
                    Enferm. 2009;30(3):192-9.
                </cite>
            </li>
        </ul>
    </section>


Notas de rodapé em parágrafo::

    <p> Announcer: Number 16: The <i>hand</i>.</p>
    <p> Interviewer: Good evening. I have with me in the studio tonight
    Mr Norman St John Polevaulter, who for the past few years has been
    contradicting people. Mr Polevaulter, why <em>do</em> you
    contradict people?</p>
    <p> Norman: I don't. <sup><a href="#fn1">1</a></sup></p>
    <p> Interviewer: You told me you did!</p>
    ...
    <section class="sps-footnotes">
        <p id="fn1" class="sps-footnoteContent"><sup>1</sup> This is, naturally, 
        a lie, but paradoxically if it were true he could not say so without 
        contradicting the interviewer and thus making it false.</p>
    </section>
    

Tabelas::

    <div class="sps-tableWrap" id="t01">
        <table>
            <caption>
                <p>Table 1.</p>
                <p>This table shows the total score obtained from rolling two...</p>
            </caption>
            <thead>...</thead>
            <tbody>...</tbody>
        </table>
        <section class="sps-footnotes">
            <p id="tfn1" class="FootnoteContent"><sup>1</sup> This is blá</p>
        </section>
    </div>


Exemplos de documentos por tipo
-------------------------------

* article-commentary

    * http://ref.scielo.org/7bwsr4  
    * http://ref.scielo.org/8b8pbv  (contém comentário do editor)
    * http://ref.scielo.org/7k44jp  (contém comentário de leitor + resposta)

* book-review

    * http://ref.scielo.org/qtwpk4
    * http://ref.scielo.org/cympyn

    Os elementos abaixo do elemento ``product`` são utilizados na produção de 
    string de texto com a referência bibliográfica do produto resenhado. Qual 
    a norma que deve ser utilizada? 

* brief-report

    * http://ref.scielo.org/9tmk5f

* case-report

    * http://ref.scielo.org/xs3fkr

* correction

    * http://ref.scielo.org/vfd53s

* editorial

    * http://ref.scielo.org/wpxyp8

* in-brief (não há na pesquisa)
* letter

    * http://ref.scielo.org/pgccy2

* other
* rapid-communication

    * http://ref.scielo.org/qcmpnf

* reply (não há na pesquisa)
* research-article

    * http://ref.scielo.org/4hc7xr

* retraction (não há na pesquisa)
* review-article

    * http://ref.scielo.org/kxhwrk

* translation (não há na pesquisa)
