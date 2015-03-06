xquery version '3.0' ;
module namespace gdp.static = 'gdp.static' ;

(:~
 : This module is a RESTXQ for Paris' guidebooks blog
 :
 : @author emchateau (Cluster Pasts in the Present)
 : @since 2015-03-02 
 : @version 0.1
 : @see http://guidesdeparis.net
 :
 : This module uses SynopsX publication framework 
 : see https://github.com/ahn-ens-lyon/synopsx
 : It is distributed under the GNU General Public Licence, 
 : see http://www.gnu.org/licenses/
 :
 :)

import module namespace restxq = 'http://exquery.org/ns/restxq';
import module namespace G = 'synopsx.globals' at '../../../globals.xqm' ;

declare default function namespace 'gdp.static' ;

(:~
: resource function for the static files
:
: @param $file file or unknown path
: @return rest response and binary file
:)
declare
%rest:path('/gdp/static/{$file=.+}')
function file($file as xs:string) as item()+ {
  let $path := $G:WORKSPACE || 'gdp/static/' ||  $file
  return (
    <rest:response>
      <http:response>
        <http:header name='Cache-Control' value='max-age=3600,public'/>
      </http:response>
      <output:serialization-parameters>
      <output:media-type value='{ mime-type($path) }'/>
      <output:method value='raw'/>
      </output:serialization-parameters>
    </rest:response>,
    file:read-binary($path))
};

(:~
 : this function return a mime-type for a specified file
 :
 : @param  $name  file name
 : @return a mime type for the specified file
 :)
declare function mime-type(
  $name  as xs:string
) as xs:string {
  Q{java:org.basex.io.MimeTypes}get($name)
};