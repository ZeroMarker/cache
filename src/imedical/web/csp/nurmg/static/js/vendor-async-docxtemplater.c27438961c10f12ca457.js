webpackJsonp([12],{"/76K":function(e,t,r){"use strict";var n=r("Ocir").pregMatchAll;e.exports=function(e,t){var r={};r.content=e,r.tagsXmlArray=t,r.tagsXmlArrayJoined=r.tagsXmlArray.join("|");var o=new RegExp("(?:(<(?:"+r.tagsXmlArrayJoined+")[^>]*>)([^<>]*)</(?:"+r.tagsXmlArrayJoined+")>)|(<(?:"+r.tagsXmlArrayJoined+")[^>]*/>)","g");return r.matches=n(o,r.content),function(e){function t(){var t={array:Array.prototype.slice.call(arguments)};t.array.shift();var r=t.array[0]+t.array[1];t.array.unshift(r),t.array.pop();var n=t.array.pop();t.offset=n,t.first=!0,e.matches.unshift(t)}-1===e.content.indexOf("<")&&-1===e.content.indexOf(">")&&e.content.replace(/^()([^<>]*)$/,t);var r=new RegExp("^()([^<]+)</(?:"+e.tagsXmlArrayJoined+")>");return e.content.replace(r,t),r=new RegExp("(<(?:"+e.tagsXmlArrayJoined+")[^>]*>)([^>]+)$"),e.content.replace(r,function(){var t={array:Array.prototype.slice.call(arguments)};t.array.pop();var r=t.array.pop();t.offset=r,t.last=!0,-1===t.array[0].indexOf("/>")&&e.matches.push(t)}),e}(r)}},"0ayG":function(e,t,r){"use strict";function n(e,t){for(var r=-1,n=0,o=e.length;n<o;n++)t[n]>=e[n].length||(-1===r||e[n][t[n]].offset<e[r][t[r]].offset)&&(r=n);if(-1===r)throw new Error("minIndex negative");return r}e.exports=function(e){var t=e.reduce(function(e,t){return e+t.length},0);e=e.filter(function(e){return e.length>0});for(var r=new Array(t),o=e.map(function(){return 0}),a=0;a<=t-1;){var i=n(e,o);r[a]=e[i][o[i]],o[i]++,a++}return r}},"69RC":function(e,t,r){"use strict";var n=function(){function e(e,t){for(var r=0;r<t.length;r++){var n=t[r];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(e,n.key,n)}}return function(t,r,n){return r&&e(t.prototype,r),n&&e(t,n),t}}();var o=r("nMUQ").getScopeParserExecutionError,a=function(){function e(t){!function(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,e),this.scopePath=t.scopePath,this.scopePathItem=t.scopePathItem,this.scopeList=t.scopeList,this.parser=t.parser,this.resolved=t.resolved}return n(e,[{key:"loopOver",value:function(e,t,r){return r=r||!1,this.loopOverValue(this.getValue(e),t,r)}},{key:"functorIfInverted",value:function(e,t,r,n){e&&t(r,n)}},{key:"isValueFalsy",value:function(e,t){return null==e||!e||"[object Array]"===t&&0===e.length}},{key:"loopOverValue",value:function(e,t,r){var n=Object.prototype.toString.call(e),o=this.scopeList[this.num];if(this.isValueFalsy(e,n))return this.functorIfInverted(r,t,o,0);if("[object Array]"!==n)return"[object Object]"===n?this.functorIfInverted(!r,t,e,0):this.functorIfInverted(!r,t,o,0);for(var a,i=0;i<e.length;i++)a=e[i],this.functorIfInverted(!r,t,a,i)}},{key:"getValue",value:function(e,t){var r=this;this.num=null==t?this.scopeList.length-1:t;var n=this.scopeList[this.num];if(this.resolved){var a=this.resolved;return this.scopePath.forEach(function(e,t){a=(a=a.find(function(t){if(t.tag===e)return!0})).value[r.scopePathItem[t]]}),a=a.find(function(t){if(t.tag===e)return!0}).value}var i=void 0,s=this.parser(e,{scopePath:this.scopePath});try{i=s.get(n,{num:this.num,scopeList:this.scopeList})}catch(t){throw o({tag:e,scope:n,error:t})}return null==i&&this.num>0?this.getValue(e,this.num-1):i}},{key:"getValueAsync",value:function(e,t){var r=this;this.num=null==t?this.scopeList.length-1:t;var n=this.scopeList[this.num],a=this.parser(e,{scopePath:this.scopePath});return Promise.resolve(a.get(n,{num:this.num,scopeList:this.scopeList})).catch(function(t){throw o({tag:e,scope:n,error:t})}).then(function(t){return null==t&&r.num>0?r.getValueAsync(e,r.num-1):t})}},{key:"createSubScopeManager",value:function(t,r,n){return new e({resolved:this.resolved,parser:this.parser,scopeList:this.scopeList.concat(t),scopePath:this.scopePath.concat(r),scopePathItem:this.scopePathItem.concat(n)})}}]),e}();e.exports=function(e){return e.scopePath=[],e.scopePathItem=[],e.scopeList=[e.tags],new a(e)}},DAjD:function(e,t,r){"use strict";var n=r("WNB/"),o=r("POkW"),a=r("IGNR"),i=r("E/k5"),s=r("NssR"),u={getTemplatedFiles:function(e){return e.file(/ppt\/(slides|slideMasters)\/(slide|slideMaster)\d+\.xml/).map(function(e){return e.name}).concat(["ppt/presentation.xml","docProps/app.xml","docProps/core.xml"])},textPath:function(){return"ppt/slides/slide1.xml"},tagsXmlTextArray:["a:t","m:t","vt:lpstr","dc:title","dc:creator","cp:keywords"],tagsXmlLexedArray:["p:sp","a:tc","a:tr","a:table","a:p","a:r"],expandTags:[{contains:"a:tc",expand:"a:tr"}],onParagraphLoop:[{contains:"a:p",expand:"a:p",onlyTextInTag:!0}],tagRawXml:"p:sp",tagTextXml:"a:t",baseModules:[n,i,a,s]},l={getTemplatedFiles:function(e){return e.file(/word\/(header|footer)\d+\.xml/).map(function(e){return e.name}).concat(["docProps/core.xml","docProps/app.xml","word/document.xml","word/document2.xml"])},textPath:function(e){return e.files["word/document.xml"]?"word/document.xml":e.files["word/document2.xml"]?"word/document2.xml":void 0},tagsXmlTextArray:["w:t","m:t","vt:lpstr","dc:title","dc:creator","cp:keywords"],tagsXmlLexedArray:["w:tc","w:tr","w:table","w:p","w:r","w:rPr","w:pPr","w:spacing"],expandTags:[{contains:"w:tc",expand:"w:tr"}],onParagraphLoop:[{contains:"w:p",expand:"w:p",onlyTextInTag:!0}],tagRawXml:"w:p",tagTextXml:"w:t",baseModules:[n,o,i,a,s]};e.exports={docx:l,pptx:u}},"E/k5":function(e,t,r){"use strict";var n=function(){return function(e,t){if(Array.isArray(e))return e;if(Symbol.iterator in Object(e))return function(e,t){var r=[],n=!0,o=!1,a=void 0;try{for(var i,s=e[Symbol.iterator]();!(n=(i=s.next()).done)&&(r.push(i.value),!t||r.length!==t);n=!0);}catch(e){o=!0,a=e}finally{try{!n&&s.return&&s.return()}finally{if(o)throw a}}return r}(e,t);throw new TypeError("Invalid attempt to destructure non-iterable instance")}}(),o=r("0ayG"),a=r("Ocir"),i=a.getLeft,s=a.getRight,u=r("rQgF"),l=r("b8ZH").getExpandToDefault,p=r("nMUQ"),c=p.getUnmatchedLoopException,f=p.getClosingTagNotMatchOpeningTag,h=p.throwLocationInvalid;function d(e){switch(e.location){case"start":return 1;case"end":return-1;default:h(e)}}var g={name:"ExpandPairTrait",optionsTransformer:function(e,t){return this.expandTags=t.fileTypeConfig.expandTags.concat(t.options.paragraphLoop?t.fileTypeConfig.onParagraphLoop:[]),e},postparse:function(e,t){var r=this,a=t.getTraits,u=t.postparse,p=a("expandPair",e);p=p.map(function(e){return e||[]});var h=function e(t){var r=[],o=[];if(0===t.length)return{pairs:o,errors:r};var a=1,i=n(t,1)[0];if("start"===i.part.location)for(var s=1;s<t.length;s++){var u=t[s];if(0===(a+=d(u.part))){var l=e(t.slice(s+1));return u.part.value!==i.part.value&&""!==u.part.value?r.push(f({tags:[i.part,u.part]})):o=[[i,u]],{pairs:o.concat(l.pairs),errors:r.concat(l.errors)}}}var p=i.part;r.push(c({part:p,location:p.location}));var h=e(t.slice(1));return{pairs:h.pairs,errors:r.concat(h.errors)}}(p=o(p)),g=h.pairs,v=h.errors,m=g.map(function(t){var n=t[0].part.expandTo;if("auto"===n){var o=l(e,t,r.expandTags);o.error&&v.push(o.error),n=o.value}return n?[i(e,n,t[0].offset),s(e,n,t[1].offset)]:[t[0].offset,t[1].offset]}),y=0,x=void 0;return{postparsed:e.reduce(function(t,r,n){var o=y<g.length&&m[y][0]<=n,a=g[y],i=m[y];if(!o)return t.push(r),t;if(i[0]===n&&(x=[]),a[0].offset!==n&&a[1].offset!==n&&x.push(r),i[1]===n){var s=e[a[0].offset];s.subparsed=u(x,{basePart:s}),delete s.location,delete s.expandTo,t.push(s),y++}return t},[]),errors:v}}};e.exports=function(){return u(g)}},IGNR:function(e,t,r){"use strict";var n=function(){function e(e,t){for(var r=0;r<t.length;r++){var n=t[r];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(e,n.key,n)}}return function(t,r,n){return r&&e(t.prototype,r),n&&e(t,n),t}}();var o=r("b8ZH"),a=r("Ocir").isContent,i=r("nMUQ").throwRawTagShouldBeOnlyTextInParagraph,s=r("rQgF");function u(e){var t=e.part,r=e.left,n=e.right,o=e.postparsed,s=e.index,u=function(e,t,r){for(var n=r;n>=0;n--)for(var o=e[n],a=0,i=t.length;a<i;a++){var s=t[a];if(0===o.value.indexOf("<"+s)&&-1!==[">"," "].indexOf(o.value[s.length+1]))return t[a]}return null}(o,["w:p","w:tc"],r-1);u===function(e,t,r){for(var n=r,o=e.length;n<o;n++)for(var a=e[n],i=0,s=t.length;i<s;i++){var u=t[i];if(a.value==="</"+u+">")return t[i]}return-1}(o,["w:p","w:tc"],n+1)&&"w:tc"===u&&(t.emptyValue="<w:p></w:p>");var l=o.slice(r+1,n);return l.forEach(function(e,n){n!==s-r-1&&a(e)&&i({paragraphParts:l,part:t})}),t}var l=function(){function e(){!function(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,e),this.name="RawXmlModule",this.prefix="@"}return n(e,[{key:"optionsTransformer",value:function(e,t){return this.fileTypeConfig=t.fileTypeConfig,e}},{key:"parse",value:function(e){return e[0]!==this.prefix?null:{type:"placeholder",value:e.substr(1),module:"rawxml"}}},{key:"postparse",value:function(e){return o.expandToOne(e,{moduleName:"rawxml",getInner:u,expandTo:this.fileTypeConfig.tagRawXml})}},{key:"render",value:function(e,t){if("rawxml"!==e.module)return null;var r=t.scopeManager.getValue(e.value);return null==r&&(r=t.nullGetter(e)),r?{value:r}:{value:e.emptyValue||""}}}]),e}();e.exports=function(){return s(new l)}},NssR:function(e,t,r){"use strict";var n=function(){function e(e,t){for(var r=0;r<t.length;r++){var n=t[r];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(e,n.key,n)}}return function(t,r,n){return r&&e(t.prototype,r),n&&e(t,n),t}}();var o=r("rQgF"),a=r("nMUQ").getScopeCompilationError,i=function(){function e(){!function(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,e),this.name="Render"}return n(e,[{key:"set",value:function(e){e.compiled&&(this.compiled=e.compiled),null!=e.data&&(this.data=e.data)}},{key:"getRenderedMap",value:function(e){var t=this;return Object.keys(this.compiled).reduce(function(e,r){return e[r]={from:r,data:t.data},e},e)}},{key:"optionsTransformer",value:function(e,t){return this.parser=t.parser,e}},{key:"postparse",value:function(e){var t=this,r=[];return e.forEach(function(e){if("placeholder"===e.type){var n=e.value;try{t.parser(n)}catch(e){r.push(a({tag:n,rootError:e}))}}}),{postparsed:e,errors:r}}}]),e}();e.exports=function(){return o(new i)}},Ocir:function(e,t,r){"use strict";var n=r("OAFc"),o=n.DOMParser,a=n.XMLSerializer,i=r("nMUQ").throwXmlTagNotFound;function s(e){return e[e.length-1]}var u={nullGetter:function(e){return e.module?(e.module,""):"undefined"},xmlFileNames:[],parser:function(e){return n=function(t){return"."===e?t:t[e]},(r="get")in(t={})?Object.defineProperty(t,r,{value:n,enumerable:!0,configurable:!0,writable:!0}):t[r]=n,t;var t,r,n},delimiters:{start:"{",end:"}"}};var l={"&":"&amp;","'":"&apos;","<":"&lt;",">":"&gt;",'"':"&quot;"},p=/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g;function c(e){return e.replace(p,"\\$&")}var f=Object.keys(l).map(function(e){var t=l[e];return{rstart:new RegExp(c(t),"g"),rend:new RegExp(c(e),"g"),start:t,end:e}});var h=new RegExp(String.fromCharCode(160),"g");function d(e,t){var r=t.type,n=t.tag,o=t.position;return"tag"===r&&n===e&&"start"===o}function g(e,t){var r=t.type,n=t.tag,o=t.position;return"tag"===r&&n===e&&"end"===o}var v=/[\x00-\x08\x0B\x0C\x0E-\x1F]/;e.exports={isContent:function(e){return"placeholder"===e.type||"content"===e.type&&"insidetag"===e.position},isParagraphStart:function(e){return d("w:p",e)||d("a:p",e)},isParagraphEnd:function(e){return g("w:p",e)||g("a:p",e)},isTagStart:d,isTagEnd:g,isTextStart:function(e){return"tag"===e.type&&"start"===e.position&&e.text},isTextEnd:function(e){return"tag"===e.type&&"end"===e.position&&e.text},unique:function(e){for(var t={},r=[],n=0,o=e.length;n<o;++n)t.hasOwnProperty(e[n])||(t[e[n]]=!0,r.push(e[n]));return r},chunkBy:function(e,t){return e.reduce(function(e,r){var n=s(e);if(0===n.length)return n.push(r),e;var o=t(r);return"start"===o?e.push([r]):"end"===o?(n.push(r),e.push([])):n.push(r),e},[[]]).filter(function(e){return e.length>0})},last:s,mergeObjects:function(){for(var e={},t=void 0,r=void 0,n=0;n<arguments.length;n+=1){t=arguments[n],r=Object.keys(t);for(var o=0;o<r.length;o+=1)e[r[o]]=t[r[o]]}return e},xml2str:function(e){return(new a).serializeToString(e).replace(/xmlns:[a-z0-9]+="" ?/g,"")},str2xml:function(e,t){return new o({errorHandler:t}).parseFromString(e,"text/xml")},getRight:function(e,t,r){for(var n=r,o=e.length;n<o;n++)if(e[n].value==="</"+t+">")return n;i({position:"right",element:t,parsed:e,index:r})},getLeft:function(e,t,r){for(var n=r;n>=0;n--){var o=e[n];if(0===o.value.indexOf("<"+t)&&-1!==[">"," "].indexOf(o.value[t.length+1]))return n}i({position:"left",element:t,parsed:e,index:r})},pregMatchAll:function(e,t){for(var r=[],n=void 0;null!=(n=e.exec(t));)r.push({array:n,offset:n.index});return r},convertSpaces:function(e){return e.replace(h," ")},escapeRegExp:c,charMapRegexes:f,hasCorruptCharacters:function(e){return v.test(e)},defaults:u,wordToUtf8:function(e){for(var t=void 0,r=0,n=f.length;r<n;r++)t=f[r],e=e.replace(t.rstart,t.end);return e},utf8ToWord:function(e){"string"!=typeof e&&(e=e.toString());for(var t=void 0,r=0,n=f.length;r<n;r++)t=f[r],e=e.replace(t.rend,t.start);return e},concatArrays:function(e){for(var t=[],r=0;r<e.length;r++)for(var n=e[r],o=0,a=n.length;o<a;o++)t.push(n[o]);return t},charMap:l}},POkW:function(e,t,r){"use strict";var n=r("rQgF"),o=r("Ocir"),a=o.isTextStart,i=o.isTextEnd;function s(e){return-1!==e.indexOf('xml:space="preserve"')?e:e.substr(0,e.length-1)+' xml:space="preserve">'}var u={name:"SpacePreserveModule",postparse:function(e){var t=[],r=!1,n=0,o=0,u=e.reduce(function(e,u){return a(u)&&"w:t"===u.tag&&(r=!0,o=t.length),r?(n||"placeholder"!==u.type||u.module||(n=u.endLindex,t[0].value=s(t[0].value)),t.push(u),i(u)&&(n?u.lIndex>n&&(t[o].value=s(t[o].value),Array.prototype.push.apply(e,t),r=!1,o=0,n=0,t=[]):(Array.prototype.push.apply(e,t),r=!1,o=0,n=0,t=[])),e):(e.push(u),e)},[]);return Array.prototype.push.apply(u,t),u}};e.exports=function(){return n(u)}},UIiT:function(e,t,r){"use strict";var n=function(){return function(e,t){if(Array.isArray(e))return e;if(Symbol.iterator in Object(e))return function(e,t){var r=[],n=!0,o=!1,a=void 0;try{for(var i,s=e[Symbol.iterator]();!(n=(i=s.next()).done)&&(r.push(i.value),!t||r.length!==t);n=!0);}catch(e){o=!0,a=e}finally{try{!n&&s.return&&s.return()}finally{if(o)throw a}}return r}(e,t);throw new TypeError("Invalid attempt to destructure non-iterable instance")}}(),o=r("nMUQ"),a=o.getUnclosedTagException,i=o.getUnopenedTagException,s=o.throwMalformedXml,u=r("Ocir"),l=u.concatArrays,p=u.isTextStart,c=u.isTextEnd,f=0,h=-1,d=1;function g(e,t){return e[0]<=t.offset&&t.offset<e[1]}function v(e,t){return p(e)?(t&&s(e),!0):c(e)?(t||s(e),!1):t}function m(e){var t="start",r=1;"/"===e[e.length-2]&&(t="selfclosing"),"/"===e[1]&&(r=2,t="end");var n=e.indexOf(" "),o=-1===n?e.length-1:n;return{tag:e.slice(r,o),position:t}}function y(e,t){return e===t?0:-1===e||-1===t?t<e?h:d:e<t?h:d}function x(e){var t=e.split(" ");if(2!==t.length)throw new Error("New Delimiters cannot be parsed");var r=n(t,2),o=r[0],a=r[1];if(0===o.length||0===a.length)throw new Error("New Delimiters cannot be parsed");return[o,a]}function w(e){var t=this;this.innerContentParts=e,this.full="",this.parseDelimiters=function(e){t.full=t.innerContentParts.map(function(e){return e.value}).join("");var r=function(e,t){for(var r=[],o=t.start,a=t.end,i=-1;;){var s=e.indexOf(o,i+1),u=e.indexOf(a,i+1),l=null,p=void 0,c=y(s,u);if(c===f)return r;if(c===d&&(i=u,l="end",p=a.length),c===h&&(i=s,l="start",p=o.length),"start"!==l||"="!==e[i+o.length])r.push({offset:i,position:l,length:p});else{r.push({offset:s,position:"start",length:o.length,changedelimiter:!0});var g=e.indexOf("=",i+o.length+1),v=e.indexOf(a,g+1);r.push({offset:v,position:"end",length:a.length,changedelimiter:!0});var m=x(e.substr(i+o.length+1,g-i-o.length-1)),w=n(m,2);o=w[0],a=w[1],i=v}}}(t.full,e),o=0,s=t.innerContentParts.map(function(e){return{offset:(o+=e.value.length)-e.value.length,lIndex:e.lIndex}}),u=function(e,t,r){if(0===e.length)return[];var n=[],o=!1,s={offset:0},u=void 0,l=0;e.forEach(function(e){for(;r[l+1]&&!(r[l+1].offset>e.offset);)l++;u=t.substr(s.offset,e.offset-s.offset),"start"===e.position&&o||"end"===e.position&&!o?"start"===e.position?(n.push(a({xtag:u,offset:s.offset})),e.error=!0):(n.push(i({xtag:u,offset:e.offset})),e.error=!0):o=!o,s=e});var p={offset:t.length};return u=t.substr(s.offset,p.offset-s.offset),o&&(n.push(a({xtag:u,offset:s.offset})),p.error=!0),n}(r,t.full,s),l=0,p=0;t.parsed=s.map(function(e,t){for(var n=e.offset,o=[n,n+this.innerContentParts[t].value.length],a=this.innerContentParts[t].value,i=[];p<r.length&&g(o,r[p]);)i.push(r[p]),p++;var s=[],u=0;l>0&&(u=l,l=0);var c=void 0;i.forEach(function(e){var t=a.substr(u,e.offset-n-u);if(t.length>0){if(c)return void(e.changedelimiter&&(u=e.offset-n+e.length,c="start"===e.position));s.push({type:"content",value:t,offset:u+n}),u+=t.length}var r={type:"delimiter",position:e.position,offset:u+n};if(e.error&&(r.error=e.error),e.changedelimiter)return c="start"===e.position,void(u=e.offset-n+e.length);s.push(r),u=e.offset-n+e.length}),l=u-a.length;var f=a.substr(u);return f.length>0&&s.push({type:"content",value:f,offset:n}),s},t),t.errors=u}}e.exports={parse:function(e,t){var r=!1,n=new w(function(e){var t=!1,r=[];return e.forEach(function(e){(t=v(e,t))&&"content"===e.type&&r.push(e)}),r}(e));n.parseDelimiters(t);var o=[],a=0;return e.forEach(function(e){r=v(e,r),"content"===e.type&&(e.position=r?"insidetag":"outsidetag"),r&&"content"===e.type?(Array.prototype.push.apply(o,n.parsed[a].map(function(e){return"content"===e.type&&(e.position="insidetag"),e})),a++):o.push(e)}),o=o.map(function(e,t){return e.lIndex=t,e}),{errors:n.errors,lexed:o}},xmlparse:function(e,t){var r=function(e,t,r){for(var n=0,o=e.length,a=l([t.map(function(e){return{tag:e,text:!0}}),r.map(function(e){return{tag:e,text:!1}})]).reduce(function(e,t){return e[t.tag]=t.text,e},{}),i=[];n<o&&-1!==(n=e.indexOf("<",n));){var s=n;n=e.indexOf(">",n);var u=e.slice(s,n+1),p=m(u),c=p.tag,f=p.position,h=a[c];null!=h&&i.push({type:"tag",position:f,text:h,offset:s,value:u,tag:c})}return i}(e,t.text,t.other),n=0,o=r.reduce(function(t,r){var o=e.substr(n,r.offset-n);return o.length>0&&t.push({type:"content",value:o}),n=r.offset+r.value.length,delete r.offset,r.value.length>0&&t.push(r),t},[]),a=e.substr(n);return a.length>0&&o.push({type:"content",value:a}),o}}},UXEu:function(e,t,r){"use strict";var n=function(){function e(e,t){for(var r=0;r<t.length;r++){var n=t[r];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(e,n.key,n)}}return function(t,r,n){return r&&e(t.prototype,r),n&&e(t,n),t}}();var o=r("Ocir");o.traits=r("b8ZH"),o.moduleWrapper=r("rQgF");var a=o.defaults,i=o.str2xml,s=o.xml2str,u=o.moduleWrapper,l=o.concatArrays,p=o.unique,c=r("nMUQ"),f=c.XTInternalError,h=c.throwFileTypeNotIdentified,d=c.throwFileTypeNotHandled,g=function(){function e(){if(function(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,e),arguments.length>0)throw new Error("The constructor with parameters has been removed in docxtemplater 3, please check the upgrade guide.");this.compiled={},this.modules=[],this.setOptions({})}return n(e,[{key:"setModules",value:function(e){this.modules.forEach(function(t){t.set(e)})}},{key:"sendEvent",value:function(e){this.modules.forEach(function(t){t.on(e)})}},{key:"attachModule",value:function(e){var t=(arguments.length>1&&void 0!==arguments[1]?arguments[1]:{}).prefix;return t&&(e.prefix=t),this.modules.push(u(e)),this}},{key:"setOptions",value:function(e){var t=this;return this.options=e,Object.keys(a).forEach(function(e){var r=a[e];t.options[e]=null!=t.options[e]?t.options[e]:r,t[e]=t.options[e]}),this.zip&&this.updateFileTypeConfig(),this}},{key:"loadZip",value:function(e){if(e.loadAsync)throw new f("Docxtemplater doesn't handle JSZip version >=3, see changelog");return this.zip=e,this.updateFileTypeConfig(),this.modules=l([this.fileTypeConfig.baseModules.map(function(e){return e()}),this.modules]),this}},{key:"compileFile",value:function(e){var t=this.createTemplateClass(e);t.parse(),this.compiled[e]=t}},{key:"resolveData",value:function(e){var t=this;return Promise.all(Object.keys(this.compiled).map(function(r){return t.compiled[r].resolveTags(e)})).then(function(e){return l(e)})}},{key:"compile",value:function(){var e=this;return Object.keys(this.compiled).length?this:(this.options=this.modules.reduce(function(t,r){return r.optionsTransformer(t,e)},this.options),this.options.xmlFileNames=p(this.options.xmlFileNames),this.xmlDocuments=this.options.xmlFileNames.reduce(function(t,r){var n=e.zip.files[r].asText();return t[r]=i(n),t},{}),this.setModules({zip:this.zip,xmlDocuments:this.xmlDocuments}),this.getTemplatedFiles(),this.setModules({compiled:this.compiled}),this.templatedFiles.forEach(function(t){null!=e.zip.files[t]&&e.compileFile(t)}),this)}},{key:"updateFileTypeConfig",value:function(){var t=void 0;return this.zip.files.mimetype&&(t="odt"),(this.zip.files["word/document.xml"]||this.zip.files["word/document2.xml"])&&(t="docx"),this.zip.files["ppt/presentation.xml"]&&(t="pptx"),"odt"===t&&d(t),t||h(),this.fileType=t,this.fileTypeConfig=this.options.fileTypeConfig||e.FileTypeConfig[this.fileType],this}},{key:"render",value:function(){var e=this;return this.compile(),this.setModules({data:this.data}),this.mapper=this.modules.reduce(function(e,t){return t.getRenderedMap(e)},{}),this.fileTypeConfig.tagsXmlLexedArray=p(this.fileTypeConfig.tagsXmlLexedArray),this.fileTypeConfig.tagsXmlTextArray=p(this.fileTypeConfig.tagsXmlTextArray),Object.keys(this.mapper).forEach(function(t){var r=e.mapper[t],n=r.from,o=r.data,a=e.compiled[n];a.setTags(o),a.render(t),e.zip.file(t,a.content,{createFolders:!0})}),this.sendEvent("syncing-zip"),this.syncZip(),this}},{key:"syncZip",value:function(){var e=this;Object.keys(this.xmlDocuments).forEach(function(t){e.zip.remove(t);var r=s(e.xmlDocuments[t]);return e.zip.file(t,r,{createFolders:!0})})}},{key:"setData",value:function(e){return this.data=e,this}},{key:"getZip",value:function(){return this.zip}},{key:"createTemplateClass",value:function(e){var t=this.zip.files[e].asText();return this.createTemplateClassFromContent(t,e)}},{key:"createTemplateClassFromContent",value:function(t,r){var n=this,o={filePath:r};return Object.keys(a).forEach(function(e){o[e]=n[e]}),o.fileTypeConfig=this.fileTypeConfig,o.modules=this.modules,new e.XmlTemplater(t,o)}},{key:"getFullText",value:function(e){return this.createTemplateClass(e||this.fileTypeConfig.textPath(this.zip)).getFullText()}},{key:"getTemplatedFiles",value:function(){return this.templatedFiles=this.fileTypeConfig.getTemplatedFiles(this.zip),this.templatedFiles}}]),e}();g.DocUtils=o,g.Errors=r("nMUQ"),g.XmlTemplater=r("f+XZ"),g.FileTypeConfig=r("DAjD"),g.XmlMatcher=r("/76K"),e.exports=g},"WNB/":function(e,t,r){"use strict";var n=r("Ocir"),o=n.mergeObjects,a=n.chunkBy,i=n.last,s=n.isParagraphStart,u=n.isParagraphEnd,l=n.isContent,p=/^-([^\s]+)\s(.+)$/,c=r("rQgF");function f(e){return e.some(function(e){return l(e)})?0:e.length}var h={name:"LoopModule",prefix:{start:"#",end:"/",dash:"-",inverted:"^"},parse:function(e){var t="placeholder",r=this.prefix;return e[0]===r.start?{type:t,value:e.substr(1),expandTo:"auto",module:"loop",location:"start",inverted:!1}:e[0]===r.inverted?{type:t,value:e.substr(1),expandTo:"auto",module:"loop",location:"start",inverted:!0}:e[0]===r.end?{type:t,value:e.substr(1),module:"loop",location:"end"}:e[0]===r.dash?{type:t,value:e.replace(p,"$2"),expandTo:e.replace(p,"$1"),module:"loop",location:"start",inverted:!1}:null},getTraits:function(e,t){if("expandPair"===e)return t.reduce(function(e,t,r){return"placeholder"===t.type&&"loop"===t.module&&e.push({part:t,offset:r}),e},[])},postparse:function(e,t){var r=t.basePart;if(!function(e){return 0!==e.length&&s(e[0])&&u(i(e))}(e))return e;if(!r||"auto"!==r.expandTo)return e;var n=a(e,function(e){return s(e)?"start":u(e)?"end":null});if(n.length<=2)return e;var o=n[0],l=i(n),p=f(o),c=f(l);return 0===p||0===c?e:e.slice(p,e.length-c)},render:function(e,t){if("placeholder"===!e.type||"loop"!==e.module)return null;var r=[],n=[];return t.scopeManager.loopOver(e.value,function(a,i){var s=t.scopeManager.createSubScopeManager(a,e.value,i),u=t.render(o({},t,{compiled:e.subparsed,tags:{},scopeManager:s}));r=r.concat(u.parts),n=n.concat(u.errors||[])},e.inverted),{value:r.join(""),errors:n}},resolve:function(e,t){if("placeholder"===!e.type||"loop"!==e.module)return null;var r=t.scopeManager.getValue(e.value),n=[];function a(r,a){var i=t.scopeManager.createSubScopeManager(r,e.value,a);n.push(t.resolve(o(t,{compiled:e.subparsed,tags:{},scopeManager:i})))}return Promise.resolve(r).then(function(r){return t.scopeManager.loopOverValue(r,a,e.inverted),Promise.all(n).then(function(e){return e.map(function(e){return e.resolved})})})}};e.exports=function(){return c(h)}},b8ZH:function(e,t,r){"use strict";var n="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e},o=r("Ocir"),a=o.getRight,i=o.getLeft,s=o.concatArrays,u=o.chunkBy,l=o.isTagStart,p=o.isTagEnd,c=o.isContent,f=o.last,h=r("nMUQ"),d=h.XTTemplateError,g=h.throwRawTagNotInParagraph,v=h.getLoopPositionProducesInvalidXMLError;function m(e,t){if(0===e.length)return!1;var r=e[e.length-1].tag.substr(1),n=t.substr(2,t.length-3);return 0===r.indexOf(n)}function y(e,t){return e.push({tag:t}),e}e.exports={expandToOne:function(e,t){var r=[];return e.errors&&(r=e.errors,e=e.postparsed),e.reduce(function(e,r){return"placeholder"===r.type&&r.module===t.moduleName&&e.push(r),e},[]).forEach(function(n){try{e=function(e,t,r){var n=e.expandTo||r.expandTo,o=t.indexOf(e);if(!n)return t;var u=void 0,l=void 0;try{u=a(t,n,o),l=i(t,n,o)}catch(r){throw r instanceof d&&g({part:e,rootError:r,postparsed:t,expandTo:n,index:o}),r}var p=t.slice(l,o),c=t.slice(o+1,u+1),f=r.getInner({index:o,part:e,leftParts:p,rightParts:c,left:l,right:u,postparsed:t});return f.length||(f.expanded=[p,c],f=[f]),s([t.slice(0,l),f,t.slice(u+1)])}(n,e,t)}catch(e){if(!(e instanceof d))throw e;r.push(e)}}),{postparsed:e,errors:r}},getExpandToDefault:function(e,t,r){var o=function(e){for(var t,r=e.filter(function(e){return"tag"===e.type}),n=[],o=0;o<r.length;o++)"/"===(t=r[o].value)[1]?m(n,t)?n.pop():n=y(n,t):"/"!==t[t.length-2]&&(n=y(n,t));return n}(e.slice(t[0].offset,t[1].offset));if(o.filter(function(e){return"/"===e.tag[1]}).length!==o.filter(function(e){var t=e.tag;return"/"!==t[1]&&"/"!==t[t.length-2]}).length)return{error:v({tag:t[0].part.value})};for(var s=function(n,s){var h=r[n],d=h.contains,g=h.expand,v=h.onlyTextInTag;if(function(e,t){for(var r=0;r<t.length;r++)if(0===t[r].tag.indexOf("<"+e))return!0;return!1}(d,o)){if(v){var m=i(e,d,t[0].offset),y=a(e,d,t[1].offset),x=u(e.slice(m,y),function(e){return l(d,e)?"start":p(d,e)?"end":null});if(x.length<=2)return"continue";var w=x[0],T=f(x),b=w.filter(c),E=T.filter(c);if(1!==b.length||1!==E.length)return"continue"}return{v:{value:g}}}},h=0,d=r.length;h<d;h++){var g=s(h);switch(g){case"continue":continue;default:if("object"===(void 0===g?"undefined":n(g)))return g.v}}return!1}}},"f+XZ":function(e,t,r){"use strict";var n="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e},o=function(){function e(e,t){for(var r=0;r<t.length;r++){var n=t[r];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(e,n.key,n)}}return function(t,r,n){return r&&e(t.prototype,r),n&&e(t,n),t}}();var a=r("Ocir"),i=a.wordToUtf8,s=a.convertSpaces,u=a.defaults,l=r("69RC"),p=r("/76K"),c=r("nMUQ"),f=c.throwMultiError,h=c.throwContentMustBeString,d=r("UIiT"),g=r("gOep"),v=r("ktYI"),m=r("sWw0");e.exports=function(){function e(t,r){!function(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,e),this.fromJson(r),this.setModules({inspect:{filePath:this.filePath}}),this.load(t)}return o(e,[{key:"load",value:function(e){"string"!=typeof e&&h(void 0===e?"undefined":n(e)),this.content=e}},{key:"setTags",value:function(e){return this.tags=null!=e?e:{},this.scopeManager=l({tags:this.tags,parser:this.parser}),this}},{key:"resolveTags",value:function(e){var t=this;this.tags=null!=e?e:{},this.scopeManager=l({tags:this.tags,parser:this.parser});var r={compiled:this.postparsed,tags:this.tags,modules:this.modules,parser:this.parser,nullGetter:this.nullGetter,filePath:this.filePath,resolve:m};return r.scopeManager=l(r),m(r).then(function(e){var r=e.resolved;return Promise.all(r.map(function(e){return Promise.resolve(e)})).then(function(e){return t.resolved=e})})}},{key:"fromJson",value:function(e){this.filePath=e.filePath,this.modules=e.modules,this.fileTypeConfig=e.fileTypeConfig,Object.keys(u).map(function(t){this[t]=null!=e[t]?e[t]:u[t]},this)}},{key:"getFullText",value:function(){return e=this.content,t=this.fileTypeConfig.tagsXmlTextArray,r=p(e,t).matches.map(function(e){return e.array[2]}),i(s(r.join("")));var e,t,r}},{key:"setModules",value:function(e){this.modules.forEach(function(t){t.set(e)})}},{key:"parse",value:function(){var e=[];this.xmllexed=d.xmlparse(this.content,{text:this.fileTypeConfig.tagsXmlTextArray,other:this.fileTypeConfig.tagsXmlLexedArray}),this.setModules({inspect:{xmllexed:this.xmllexed}});var t=d.parse(this.xmllexed,this.delimiters),r=t.lexed,n=t.errors;e=e.concat(n),this.lexed=r,this.setModules({inspect:{lexed:this.lexed}}),this.parsed=g.parse(this.lexed,this.modules),this.setModules({inspect:{parsed:this.parsed}});var o=g.postparse(this.parsed,this.modules),a=o.postparsed,i=o.errors;return this.postparsed=a,this.setModules({inspect:{postparsed:this.postparsed}}),e=e.concat(i),this.errorChecker(e),this}},{key:"errorChecker",value:function(e){var t=this;e.length&&(this.modules.forEach(function(t){e=t.errorsTransformer(e)}),e.forEach(function(e){e.properties.file=t.filePath}),f(e))}},{key:"render",value:function(e){this.filePath=e;var t={compiled:this.postparsed,tags:this.tags,resolved:this.resolved,modules:this.modules,parser:this.parser,nullGetter:this.nullGetter,filePath:this.filePath,render:v};t.scopeManager=l(t);var r=v(t),n=r.errors,o=r.parts;return this.errorChecker(n),this.content=o.join(""),this.setModules({inspect:{content:this.content}}),this}}]),e}()},gOep:function(e,t,r){"use strict";var n=Object.assign||function(e){for(var t=1;t<arguments.length;t++){var r=arguments[t];for(var n in r)Object.prototype.hasOwnProperty.call(r,n)&&(e[n]=r[n])}return e},o=r("Ocir"),a=o.wordToUtf8,i=o.concatArrays;var s={postparse:function(e,t){function r(e,r){return t.map(function(t){return t.getTraits(e,r)})}var o=[];function a(e,s){return t.reduce(function(e,t){var u=t.postparse(e,n({},s,{postparse:a,getTraits:r}));return u.errors?(o=i([o,u.errors]),u.postparsed):u},e)}return{postparsed:a(e),errors:o}},parse:function(e,t){var r=!1,n="",o=void 0,i=[];return e.reduce(function(e,s){if("delimiter"===s.type){if(r="start"===s.position,"end"===s.position){var u=s.lIndex;n=a(n),e=function(e,t,r,n,o){for(var a=void 0,i=0,s=e.length;i<s;i++)if(a=e[i].parse(t))return a.offset=n,r.push(a),r;return r.push({type:"placeholder",value:t,offset:n,endLindex:o}),r}(t,n,e,o,u),o=null,Array.prototype.push.apply(e,i),i=[]}return"start"===s.position&&(i=[],o=s.offset),n="",e}return r?"content"!==s.type||"insidetag"!==s.position?(i.push(s),e):(n+=s.value,e):(e.push(s),e)},[])}};e.exports=s},ktYI:function(e,t,r){"use strict";var n=r("Ocir"),o=n.utf8ToWord,a=n.concatArrays,i=n.hasCorruptCharacters,s=r("nMUQ"),u=s.throwUnimplementedTagType,l=s.throwCorruptCharacters;e.exports=function(e){var t=e.compiled,r=e.scopeManager,n=e.nullGetter,s=[],p=t.map(function(t){var p=function(e,t){for(var r=void 0,n=0,o=t.modules.length;n<o;n++)if(r=t.modules[n].render(e,t))return r;return!1}(t,e);if(p)return p.errors&&(s=a([s,p.errors])),p.value;if("placeholder"===t.type){var c=r.getValue(t.value);return null==c&&(c=n(t)),i(c)&&l({tag:t.value,value:c}),o(c)}if("content"===t.type||"tag"===t.type)return t.value;u(t)});return{errors:s,parts:p}}},nMUQ:function(e,t,r){"use strict";function n(e){this.name="GenericError",this.message=e,this.stack=new Error(e).stack}function o(e){this.name="TemplateError",this.message=e,this.stack=new Error(e).stack}function a(e){this.name="RenderingError",this.message=e,this.stack=new Error(e).stack}function i(e){this.name="ScopeParserError",this.message=e,this.stack=new Error(e).stack}function s(e){this.name="InternalError",this.properties={explanation:"InternalError"},this.message=e,this.stack=new Error(e).stack}n.prototype=Error.prototype,o.prototype=new n,a.prototype=new n,i.prototype=new n,s.prototype=new n,e.exports={XTError:n,XTTemplateError:o,XTInternalError:s,XTScopeParserError:i,RenderingError:a,throwMultiError:function(e){var t=new o("Multi error");throw t.properties={errors:e,id:"multi_error",explanation:"The template has multiple errors"},t},throwXmlTagNotFound:function(e){var t=new o('No tag "'+e.element+'" was found at the '+e.position);throw t.properties={id:"no_xml_tag_found_at_"+e.position,explanation:'No tag "'+e.element+'" was found at the '+e.position,part:e.parsed[e.index],parsed:e.parsed,index:e.index,element:e.element},t},throwCorruptCharacters:function(e){var t=e.tag,r=e.value,n=new a("There are some XML corrupt characters");throw n.properties={id:"invalid_xml_characters",xtag:t,value:r,explanation:"There are some corrupt characters for the field ${name}"},n},throwContentMustBeString:function(e){var t=new s("Content must be a string");throw t.properties.id="xmltemplater_content_must_be_string",t.properties.type=e,t},getUnmatchedLoopException:function(e){var t=e.location,r="start"===t?"unclosed":"unopened",n=new o(("start"===t?"Unclosed":"Unopened")+" loop"),a=e.part.value;return n.properties={id:r+"_loop",explanation:'The loop with tag "'+a+'" is '+r,xtag:a},n},throwRawTagShouldBeOnlyTextInParagraph:function(e){var t=new o("Raw tag should be the only text in paragraph"),r=e.part.value;throw t.properties={id:"raw_xml_tag_should_be_only_text_in_paragraph",explanation:'The tag "'+r+'" should be the only text in this paragraph',xtag:e.part.value,offset:e.part.offset,paragraphParts:e.paragraphParts},t},throwRawTagNotInParagraph:function(e){var t=new o("Raw tag not in paragraph"),r=e.part,n=r.value,a=r.offset;throw t.properties={id:"raw_tag_outerxml_invalid",explanation:'The tag "'+n+'" is not inside a paragraph',rootError:e.rootError,xtag:n,offset:a,postparsed:e.postparsed,expandTo:e.expandTo,index:e.index},t},getClosingTagNotMatchOpeningTag:function(e){var t=e.tags,r=new o("Closing tag does not match opening tag");return r.properties={id:"closing_tag_does_not_match_opening_tag",explanation:'The tag "'+t[0].value+'" is closed by the tag "'+t[1].value+'"',openingtag:t[0].value,offset:[t[0].offset,t[1].offset],closingtag:t[1].value},r},throwUnimplementedTagType:function(e){var t=new o('Unimplemented tag type "'+e.type+'"');throw t.properties={part:e,id:"unimplemented_tag_type"},t},getScopeCompilationError:function(e){var t=e.tag,r=e.rootError,n=new i("Scope parser compilation failed");return n.properties={id:"scopeparser_compilation_failed",tag:t,explanation:'The scope parser for the tag "'+t+'" failed to compile',rootError:r},n},getScopeParserExecutionError:function(e){var t=e.tag,r=e.scope,n=e.error,o=new i("Scope parser execution failed");return o.properties={id:"scopeparser_execution_failed",explanation:"The scope parser for the tag "+t+" failed to execute",scope:r,tag:t,rootError:n},o},getUnopenedTagException:function(e){var t,r=new o("Unopened tag");return r.properties={xtag:(t=e.xtag.split(" "),t[t.length-1]),id:"unopened_tag",context:e.xtag,offset:e.offset,lIndex:e.lIndex,explanation:'The tag beginning with "'+e.xtag.substr(0,10)+'" is unopened'},r},getUnclosedTagException:function(e){var t,r=new o("Unclosed tag");return r.properties={xtag:(t=e.xtag.split(" "),t[0]).substr(1),id:"unclosed_tag",context:e.xtag,offset:e.offset,lIndex:e.lIndex,explanation:'The tag beginning with "'+e.xtag.substr(0,10)+'" is unclosed'},r},throwMalformedXml:function(e){var t=new s("Malformed xml");throw t.properties={part:e,id:"malformed_xml"},t},throwFileTypeNotIdentified:function(){var e=new s("The filetype for this file could not be identified, is this file corrupted ?");throw e.properties={id:"filetype_not_identified"},e},throwFileTypeNotHandled:function(e){var t=new s('The filetype "'+e+'" is not handled by docxtemplater');throw t.properties={id:"filetype_not_handled",explanation:'The file you are trying to generate is of type "'+e+'", but only docx and pptx formats are handled'},t},getLoopPositionProducesInvalidXMLError:function(e){var t=e.tag,r=new o('The position of the loop tags "'+t+'" would produce invalid XML');return r.properties={tag:t,id:"loop_position_invalid",explanation:'The tags "'+t+'" are misplaced in the document, for example one of them is in a table and the other one outside the table'},r},throwLocationInvalid:function(e){throw new s('Location should be one of "start" or "end" (given : '+e.location+")")}}},rQgF:function(e,t,r){"use strict";function n(){}function o(e){return e}e.exports=function(e){var t={set:n,parse:n,render:n,getTraits:n,optionsTransformer:o,errorsTransformer:o,getRenderedMap:o,postparse:o,on:n,resolve:n};if(Object.keys(t).every(function(t){return!e[t]}))throw new Error("This module cannot be wrapped, because it doesn't define any of the necessary functions");return Object.keys(t).forEach(function(r){e[r]=e[r]||t[r]}),e}},sWw0:function(e,t,r){"use strict";e.exports=function(e){var t=[],r=e.compiled,n=e.scopeManager,o=e.nullGetter;e.resolved=t;var a=[];return Promise.all(r.map(function(r){var a=function(e,t){for(var r=void 0,n=0,o=t.modules.length;n<o;n++)if(r=t.modules[n].resolve(e,t))return r;return!1}(r,e);return a?a.then(function(e){t.push({tag:r.value,value:e})}):"placeholder"===r.type?n.getValueAsync(r.value).then(function(e){return null==e&&(e=o(r)),t.push({tag:r.value,value:e}),e}):void 0}).filter(function(e){return e})).then(function(){return{errors:a,resolved:t}})}}});