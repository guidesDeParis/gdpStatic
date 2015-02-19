xquery version '3.0' ;
module namespace gdp.mappings.tei2html = 'gdp.mappings.tei2html' ;

(:~
 : This module is a TEI to html function library
 :
 : @author emchateau (Cluster Pasts in the Present)
 : @since 2015-02-17 
 : @version 0.1
 : @see http://guidesdeparis.net
 :
 : This module uses SynopsX publication framework 
 : see <https://github.com/ahn-ens-lyon/synopsx> 
 : It is distributed under the GNU General Public Licence, 
 : see <http://www.gnu.org/licenses/>
 :
 : @todo assign html element in the namespace
 :)

declare namespace tei = 'http://www.tei-c.org/ns/1.0';

declare default function namespace 'gdp.mappings.tei2html' ;

(:~
 : this function dispatches the treatment of the XML document
 :)
declare function dispatch($node as node()*, $options) as item()* {
  typeswitch($node)
    case text() return $node
    case element(tei:TEI) return passthru($node, $options)
    case element(tei:text) return passthru($node, $options)
    case element(tei:front) return passthru($node, $options)
    case element(tei:body) return passthru($node, $options)
    case element(tei:back) return passthru($node, $options)
    case element(tei:div) return div($node, $options)
    case element(tei:head) return head($node, $options)
    case element(tei:p) return p($node, $options)
    case element(tei:list) return list($node, $options)
    case element(tei:item) return gdp.mappings.tei2html:item($node, $options)
    case element(tei:label) return label($node, $options)
    case element(tei:hi) return hi($node, $options)
    case element(tei:ref) return ref($node, $options)
    case element(tei:said) return said($node, $options)
    case element(tei:lb) return <br/>
    case element(tei:figure) return figure($node, $options)
    case element(tei:listBibl) return listBibl($node, $options)
    case element(tei:biblStruct) return biblItem($node, $options)
    case element(tei:bibl) return biblItem($node, $options)
    case element(tei:analytic) return getAnalytic($node, $options)
    case element(tei:monogr) return getMonogr($node, $options)
    case element(tei:edition) return getEdition($node, $options)
    (: case element(tei:author) return getResponsability($node, $options) :)
    (: case element(tei:editor) return getResponsability($node, $options) :)
    case element(tei:persName) return persName($node, $options)
    case element(tei:head) return '' (: bof :)
    default return passthru($node, $options)
};

(:~
 : This function pass through child nodes (xsl:apply-templates)
 :)
declare function passthru($nodes as node(), $options) as item()* {
  for $node in $nodes/node()
  return dispatch($node, $options)
};


(:~
 : ~:~:~:~:~:~:~:~:~
 : tei textstructure
 : ~:~:~:~:~:~:~:~:~
 :)

declare function div($node as element(tei:div), $options) {
  if ($node/@xml:id) then <div id="{ getXmlId($node, $options) }"></div> else (),
  passthru($node, $options)
};

declare function head($node as element(tei:head), $options) as element() {   if ($node/parent::tei:div) then
    let $type := $node/parent::tei:div/@type
    let $level := count($node/ancestor::div) - 1
    return element { 'h' || $level } { passthru($node, $options) }
  else if ($node/parent::tei:figure) then
    if ($node/parent::tei:figure/parent::tei:p) then
      <strong>{ passthru($node, $options) }</strong>
    else <p><strong>{ passthru($node, $options) }</strong></p>
  else if ($node/parent::tei:list) then
    <li>{ passthru($node, $options) }</li>
  else if ($node/parent::tei:table) then
    <th>{ passthru($node, $options) }</th>
  else  passthru($node, $options)
};

declare function p($node as element(tei:p), $options) {
  <p>{ passthru($node, $options) }</p>
};

(:~
 : ~:~:~:~:~:~:~:~:~
 : tei inline
 : ~:~:~:~:~:~:~:~:~
 :)
declare function hi($node as element(tei:hi), $options) {
  if ($node/@italic) then <em>{ passthru($node, $options) }</i> 
  else if ($node/@bold) ,
  passthru($node, $options)
};


(:~
 : ~:~:~:~:~:~:~:~:~
 : tei biblio
 : ~:~:~:~:~:~:~:~:~
 :)

declare function listBibl($node, $options) {
  <ul id="{$node/@xml:id}">{ passthru($node, $options) }</ul>
};

declare function biblItem($node, $options) {
   <li id="{$node/@xml:id}">{ passthru($node, $options) }</li>
};

(:~
 : This function treats tei:analytic
 : @toto group author and editor to treat distinctly
 :)
declare function getAnalytic($node, $options) {
  getResponsabilities($node, $options), 
  getTitle($node, $options)
};

(:~
 : This function treats tei:monogr
 :)
declare function getMonogr($node, $options) {
  getResponsabilities($node, $options),
  getTitle($node, $options),
  getEdition($node/node(), $options),
  getImprint($node/node(), $options)
};


(:~
 : This function get responsabilities
 : @toto group authors and editors to treat them distinctly
 : @toto "éd." vs "éds."
 :)
declare function getResponsabilities($node, $options) {
  let $nbResponsabilities := fn:count($node/tei:author | $node/tei:editor)
  for $responsability at $count in $node/tei:author | $node/tei:editor
  return if ($count = $nbResponsabilities) then (getResponsability($responsability, $options), '. ')
    else (getResponsability($responsability, $options), ' ; ')
};

(:~
 : si le dernier auteur mettre un séparateur à la fin
 :
 :)
declare function getResponsability($node, $options) {
  if ($node/tei:forename or $node/tei:surname) 
  then getName($node, $options) 
  else passthru($node, $options)
};

declare function persName($node, $options) {
    getName($node, $options)
};

(:~
 : this fonction concatenate surname and forname with a ', '
 :
 : @todo cases with only one element
 :)
declare function getName($node, $options) {
  if ($node/tei:forename and $node/tei:surname)
  then ($node/tei:forename || ', ', <span class="smallcaps">{$node/tei:surname/text()}</span>)
  else if ($node/tei:surname) then <span class="smallcaps">{$node/tei:surname/text()}</span>
  else if ($node/tei:forename) then $node/tei:surname/text()
  else passthru($node, $options)
};

(:~
 : this function returns title in an html element
 :
 : different html element whereas it is an analytic or a monographic title
 : @todo serialize the text properly for tei:hi, etc.
 :)
declare function getTitle($node, $options) {
  for $title in $node/tei:title
  let $separator := '. '
  return if ($title[@level='a'])
    then (<span class="title">« {$title/text()} »</span>, $separator)
    else (<em class="title">{$title/text()}</em>, $separator)
};

declare function getEdition($node, $options) {
  $node/tei:edition/text()
};

declare function getMeeting($node, $options) {
  $node/tei:meeting/text()
};

declare function getImprint($node, $options) {
  for $vol in $node/tei:biblScope[@type='vol']
  return $vol, 
  for $pubPlace in $node/tei:pubPlace
  return 
    if ($pubPlace) then ($pubPlace/text(), ' : ')
    else 's.l. :',
  for $publisher in $node/tei:publisher
  return 
    if ($publisher) then ($publisher/text(), ', ')
    else 's.p.'
};
