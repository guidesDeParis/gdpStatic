xquery version "3.0" ;
module namespace gdp.edition = 'gdp.edition' ;

(:~
 : This module is a rest for Paris' guidebooks electronic edition
 :
 : @version 1.0
 : @date 2019-05
 : @since 2015-02-05 
 : @author emchateau (Cluster Pasts in the Present)
 : @see http://guidesdeparis.net
 :
 : This module uses SynopsX publication framework 
 : see https://github.com/ahn-ens-lyon/synopsx
 : It is distributed under the GNU General Public Licence, 
 : see http://www.gnu.org/licenses/
 :
 : @qst give webpath by dates and pages ?
 :)

import module namespace rest = 'http://exquery.org/ns/restxq';

import module namespace G = 'synopsx.globals' at '../../../globals.xqm' ;
import module namespace synopsx.models.synopsx = 'synopsx.models.synopsx' at '../../../models/synopsx.xqm' ;

import module namespace gdp.models.tei = "gdp.models.tei" at '../models/tei.xqm' ;

import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../../mappings/htmlWrapping.xqm' ;
import module namespace gdp.mappings.jsoner = 'gdp.mappings.jsoner' at '../mappings/jsoner.xqm' ;
import module namespace gdp.mappings.tei2rdf = 'gdp.mappings.tei2rdf' at '../mappings/tei2rdf.xqm' ;

declare default function namespace 'gdp.edition' ;

(:~
 : this resource function redirect to /home
 :)
declare 
  %rest:path('/')
function index() {
  <rest:response>
    <http:response status="303" message="See Other">
      <http:header name="location" value="/home"/>
    </http:response>
  </rest:response>
};

(:~
 : resource function for the home
 :
 : @return an html home page for the edition
 :)
declare 
  %rest:path('/home')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function editionHome() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getCorpusList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'home.xhtml',
    'pattern' : 'incBullet.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};


(:~
 : resource function for corpus list
 :
 : @return an html representation of the corpus resource
 :)
declare 
  %rest:path('/corpus')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
function corpus() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getCorpusList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incCorpus.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapperNew($queryParams, $result, $outputParams)
};

(:~
 : resource function for corpus list
 :
 : @return a json representation of the corpus resource
 :)
declare 
  %rest:path('/corpus')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
  %output:json("indent=no, escape=yes")
function corpusJson() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getCorpusList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for a corpus ID
 :
 : @param $corpusId the corpus ID
 : @return an html representation of the corpus resource
 :)
declare 
  %rest:path('/corpus/{$corpusId}')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
function corpusItem($corpusId as xs:string) {
  let $queryParams := map {
    'corpusId' : $corpusId,
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getCorpusById'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incText.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapperNew($queryParams, $result, $outputParams)
};

(:~
 : resource function for a corpus ID
 :
 : @param $corpusId the corpus ID
 : @return a json representation of the corpus resource
 :)
declare 
  %rest:path('/corpus/{$corpusId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function corpusItemJson($corpusId as xs:string) {
  let $queryParams := map {
    'corpusId' : $corpusId,
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getCorpusById'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for a text by ID
 :
 : @param $textId the text ID
 : @return an html representation of the text resource
 :)
declare 
  %rest:path('/texts/{$textId}')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
function textItems($textId as xs:string) {
  let $queryParams := map {
    'textId' : $textId,
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getTextById'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incTextItem.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : resource function for a text by ID
 :
 : @param $textId the text ID
 : @return a json representation of the text resource
 :)
declare 
  %rest:path('/texts/{$textId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function textItemsJson($textId as xs:string) {
  let $queryParams := map {
    'textId' : $textId,
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getTextById'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for text toc by ID
 :
 : @param $textId the text ID
 : @return a json toc of the text
 :)
declare 
  %rest:path('/texts/{$textId}/toc')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function textItemsTocJson($textId as xs:string) {
  let $queryParams := map {
    'textId' : $textId,
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getTocByTextId'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for text pagination
 :
 : @param $textId the text ID
 : @return a json toc of the text
 :)
declare
  %rest:path('/texts/{$textId}/pagination')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function textItemsPaginationJson($textId as xs:string) {
  let $queryParams := map {
    'textId' : $textId,
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getPaginationByTextId'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for a text item by ID
 :
 : @param $corpusId the text item ID
 : @return an html representation of the text item
 :)
declare 
  %rest:path('/items/{$itemId}')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
function items($itemId as xs:string) {
  let $queryParams := map {
    
    'itemId' : $itemId,
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getItemById'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incItem.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : resource function for a text item by ID
 :
 : @param $corpusId the text item ID
 : @param $depth render the content in depth true of false
 : @return a json representation of the text item
 :)
declare 
  %rest:path('/items/{$itemId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
  %rest:query-param("depth", "{$depth}", 1)
function itemsJson($itemId as xs:string, $depth as xs:boolean) {
  let $queryParams := map {
    
    'itemId' : $itemId,
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'depth' : $depth,
    'function' : 'getItemById'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : this resource function is a bibliographical list for testing
 : @return an html representation of the bibliographical list
 : @param $pattern a GET param giving the name of the calling HTML tag
 : @todo use this tag !
 :)
declare 
  %rest:path('/resp/list/html')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
  %rest:query-param('pattern', '{$pattern}')
function biblioListHtml($pattern as xs:string?) {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getRespList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'incBlogList.xhtml',
    'pattern' : 'incBlogArticle.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : this resource function is a documentation
 : @return an html representation of the bibliographical list
 : @param $pattern a GET param giving the name of the calling HTML tag
 : @todo use this tag !
 :)
declare 
  %rest:path('/model')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
function model() {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'gdp',
    'path' : '/schema/gdpSchemaTEI.odd.xml',
    'model' : 'tei',
    'function' : 'getModel'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'about.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : this resource function is a about page
 : @return an html representation of the bibliographical list
 : @param $pattern a GET param giving the name of the calling HTML tag
 : @todo use this tag !
 :)
declare 
  %rest:path('/about')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
function about() {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'blog',
    'model' : 'tei',
    'function' : 'getBlogItem',
    'entryId' : 'gdpPresentation2014'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incBlogArticle.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapperNew($queryParams, $result, $outputParams)
};

(:~
 : this resource function is a about page
 : @return an html representation of the bibliographical list
 : @param $pattern a GET param giving the name of the calling HTML tag
 : @todo use this tag !
 :)
declare 
  %rest:path('/documentation')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
function documentation() {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'gdp',
    'path' : '/schema/gdpSchemaTEI.odd.xml',
    'model' : 'tei',
    'function' : 'getModel'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'about.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

declare 
  %rest:path('/html/header')
function getHtmlHeader() {
  fn:doc($G:WORKSPACE||'gdp/templates/header.xhtml')
};

declare 
  %rest:path('/html/footer')
function getHtmlFooter() {
  fn:doc($G:WORKSPACE||'gdp/templates/footer.xhtml')
};

(:~
 : resource function for the index list
 :
 : @return an html list of indexes
 :)
declare 
  %rest:path('/index')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
function indexes() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incIndex.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : resource function for the indexLocorum
 :
 : @return a json list of indexLocorum entries
 :)
declare 
  %rest:path('/index')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function indexesJson() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
    return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for the indexLocorum
 :
 : @return an html list of indexLocorum entries
 :)
declare 
  %rest:path('/indexLocorum')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
  %rest:query-param("start", "{$start}", 1)
  %rest:query-param("count", "{$count}", 100)
  %rest:query-param("text", "{$text}", 'all')
function indexLocorum(
  $start as xs:integer,
  $count as xs:integer,
  $text as xs:string*
  ) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexLocorum',
    'start' : $start,
    'count' : $count,
    'text' : $text
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incIndexLocorum.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : resource function for the indexLocorum
 :
 : @return a json list of indexLocorum entries
 :)
declare 
  %rest:path('/indexLocorum')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
  %rest:query-param("start", "{$start}", 1)
  %rest:query-param("count", "{$count}", 100)
  %rest:query-param("text", "{$text}", 'all')
  %rest:query-param("letter", "{$letter}", 'all')
function indexLocorumJson(
  $start as xs:integer,
  $count as xs:integer,
  $text as xs:string*,
  $letter as xs:string
  ) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexLocorum',
    'start' : $start,
    'count' : $count,
    'text' : $text,
    'letter' : $letter
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
    return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for the indexLocorum item
 :
 : @param $itemId the item ID
 : @return an html representation of an indexLocorum item
 :)
declare 
  %rest:path('/indexLocorum/{$itemId}')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
function indexLocorumItem($itemId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexLocorumItem',
    'itemId' : $itemId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incIndexLocorum.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : resource function for the indexLocorum item
 :
 : @param $itemId the item ID
 : @return a json representation of an indexLocorum item
 :)
declare 
  %rest:path('/indexLocorum/{$itemId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function indexLocorumItemJson($itemId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexLocorumItem',
    'itemId' : $itemId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
    return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for the indexOperum
 :
 : @return an html list of indexOperum entries
 :)
declare 
  %rest:path('/indexOperum')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
  %rest:query-param("start", "{$start}", 1)
  %rest:query-param("count", "{$count}", 100)
  %rest:query-param("text", "{$text}", 'all')
  %rest:query-param("letter", "{$letter}", 'all')
function indexOperum(
  $start as xs:integer,
  $count as xs:integer,
  $text as xs:string*,
  $letter as xs:string
  ) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexOperum',
    'start' : $start,
    'count' : $count,
    'text' : $text,
    'letter' : $letter
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incIndex.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : resource function for the indexOperum
 :
 : @return a json list of indexOperum entries
 :)
declare 
  %rest:path('/indexOperum')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
  %rest:query-param("start", "{$start}", 1)
  %rest:query-param("count", "{$count}", 100)
  %rest:query-param("text", "{$text}", 'all')
  %rest:query-param("letter", "{$letter}", 'all')
function indexOperumJson(
  $start as xs:integer,
  $count as xs:integer,
  $text as xs:string*,
  $letter as xs:string
  ) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexOperum',
    'start' : $start,
    'count' : $count,
    'text' : $text,
    'letter' : $letter
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
    return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for an indexOperum item
 :
 : @param $itemId the item ID
 : @return an html reprenstation of an indexOperum item
 :)
declare 
  %rest:path('/indexOperum/{$itemId}')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
function indexOperumItem($itemId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexOperumItem',
    'itemId' : $itemId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incIndexOperum.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : resource function for an indexOperum item
 :
 : @param $itemId the item ID
 : @return a json reprenstation of an indexOperum item
 :)
declare 
  %rest:path('/indexOperum/{$itemId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function indexOperumItemJson($itemId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexOperumItem',
    'itemId' : $itemId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
    return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for the indexNominum
 :
 : @return a html list of indexNominum entries
 :)
declare 
  %rest:path('/indexNominum')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
  %rest:query-param("start", "{$start}", 1)
  %rest:query-param("count", "{$count}", 100)
  %rest:query-param("text", "{$text}", 'all')
  %rest:query-param("letter", "{$letter}", 'all')
function indexNominum(
  $start as xs:integer,
  $count as xs:integer,
  $text as xs:string*,
  $letter as xs:string
  ) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexNominum',
    'start' : $start,
    'count' : $count,
    'text' : $text,
    'letter' : $letter
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incIndex.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : resource function for the indexNominum
 :
 : @return a json list of indexNominum entries
 :)
declare 
  %rest:path('/indexNominum')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
  %rest:query-param("start", "{$start}", 1)
  %rest:query-param("count", "{$count}", 100)
  %rest:query-param("text", "{$text}", 'all')
  %rest:query-param("letter", "{$letter}", 'all')
function indexNominumJson(
  $start as xs:integer,
  $count as xs:integer,
  $text as xs:string*,
  $letter as xs:string
  ) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexNominum',
    'start' : $start,
    'count' : $count,
    'text' : $text,
    'letter' : $letter
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
    return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for the indexNominum item
 :
 : @param $itemId the item ID
 : @return an html representation of an indexNominum item
 :)
declare 
  %rest:path('/indexNominum/{$itemId}')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
function indexNominumItem($itemId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexNominumItem',
    'itemId' : $itemId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incIndexNominum.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : resource function for the indexNominum item
 :
 : @param $itemId the item ID
 : @return a json representation of an indexNominum item
 :)
declare 
  %rest:path('/indexNominum/{$itemId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function indexNominumItemJson($itemId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexNominumItem',
    'itemId' : $itemId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
    return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};
 
(:~
 : resource function for the indexNominum item
 :
 : @param $itemId the item ID
 : @return a jsonLD representation of an indexNominum item
 :)
declare 
  %rest:path('/indexNominum/{$itemId}/rdf')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function indexNominumItemRdf($itemId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexNominumItem',
    'itemId' : $itemId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2rdf'
    }
    return gdp.mappings.tei2rdf:tei2rdf($queryParams, $result, $outputParams)
};

(:~
 : entrées d’index d’un texte ???
 :)
 
(:~
 : cartes et accès complexes 
 :)

(:~
 : resource function for indexing
 :
 : @param $itemId the item ID
 : @return a jsonLD representation of an indexNominum item
 : @todo add operum
 :)
declare
  %rest:path('/indexing')
  %updating
function indexing() {
  let $indexId := ('gdpIndexNominum', 'gdpIndexLocorum')
  for $index in $indexId return gdp.models.tei:addId2IndexedEntities($index)
};