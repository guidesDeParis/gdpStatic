(: 
 : SynopsX's wrapping html5 default layout (polyglot document) 
 : @see http://www.w3.org/TR/html-polyglot/
 : @todo apply ARIA accessibility standards http://www.w3.org/WAI/PF/aria/ 
 : @todo use xquery so the comment won't appears in the result doc
 : @rmq this is the xml fragment used by XQueries, the appropriate DOCTYPE is given by rendering
 : 
 :)
<html xmlns="http://www.w3.org/1999/xhtml" lang="fr" xml:lang="fr">
   <head>
      <meta charset="utf-8"/>
      <title>{title}</title>
      <link href="styles.css" rel="stylesheet"/>
      <script src="scripts.js"></script>
      <!-- ajouter js pour lt IE 9 -->
   </head>
   <body>
     <main>
       <div>
         <header>
           <h1>{title}</h1>
           <h2><span>{quantity}</span> corpus disponibles</h2>
         </header>
         {content}
       </div>
     </main>
   </body>
   <footer></footer>
</html>