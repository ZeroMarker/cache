/*--------------------------------------------------------------------------*/
/*  McJsAll.js
 *  Version 3.2.2 build 2013-03-15
 *  (c) 1997-2012 Medicom
 *--------------------------------------------------------------------------*/
var Prototype={Version:'1.5.1.1',Browser:{IE:!!(window.attachEvent&&!window.opera),Opera:!!window.opera,WebKit:navigator.userAgent.indexOf('AppleWebKit/')>-1,Gecko:navigator.userAgent.indexOf('Gecko')>-1&&navigator.userAgent.indexOf('KHTML')==-1},BrowserFeatures:{XPath:!!document.evaluate,ElementExtensions:!!window.HTMLElement,SpecificElementExtensions:(document.createElement('div').__proto__!==document.createElement('form').__proto__)},ScriptFragment:'<script[^>]*>([\\S\\s]*?)<\/script>',JSONFilter:/^\/\*-secure-([\s\S]*)\*\/\s*$/,emptyFunction:function(){},K:function(x){return x}}
var Class={create:function(){return function(){this.initialize.apply(this,arguments);}}}
var Abstract=new Object();Object.extend=function(destination,source){for(var property in source){destination[property]=source[property];}
return destination;}
Object.extend(Object,{inspect:function(object){try{if(object===undefined)return'undefined';if(object===null)return'null';return object.inspect?object.inspect():object.toString();}catch(e){if(e instanceof RangeError)return'...';throw e;}},toJSON:function(object){var type=typeof object;switch(type){case'undefined':case'function':case'unknown':return;case'boolean':return object.toString();}
if(object===null)return'null';if(object.toJSON)return object.toJSON();if(object.ownerDocument===document)return;var results=[];for(var property in object){var value=Object.toJSON(object[property]);if(value!==undefined)
results.push(property.toJSON()+': '+value);}
return'{'+results.join(', ')+'}';},keys:function(object){var keys=[];for(var property in object)
keys.push(property);return keys;},values:function(object){var values=[];for(var property in object)
values.push(object[property]);return values;},clone:function(object){return Object.extend({},object);}});Function.prototype.bind=function(){var __method=this,args=$MediComA(arguments),object=args.shift();return function(){return __method.apply(object,args.concat($MediComA(arguments)));}}
Function.prototype.bindAsEventListener=function(object){var __method=this,args=$MediComA(arguments),object=args.shift();return function(event){return __method.apply(object,[event||window.event].concat(args));}}
Object.extend(Number.prototype,{toColorPart:function(){return this.toPaddedString(2,16);},succ:function(){return this+1;},times:function(iterator){$R(0,this,true).each(iterator);return this;},toPaddedString:function(length,radix){var string=this.toString(radix||10);return'0'.times(length-string.length)+string;},toJSON:function(){return isFinite(this)?this.toString():'null';}});Date.prototype.toJSON=function(){return'"'+this.getFullYear()+'-'+
(this.getMonth()+1).toPaddedString(2)+'-'+
this.getDate().toPaddedString(2)+'T'+
this.getHours().toPaddedString(2)+':'+
this.getMinutes().toPaddedString(2)+':'+
this.getSeconds().toPaddedString(2)+'"';};var Try={these:function(){var returnValue;for(var i=0,length=arguments.length;i<length;i++){var lambda=arguments[i];try{returnValue=lambda();break;}catch(e){}}
return returnValue;}}
var PeriodicalExecuter=Class.create();PeriodicalExecuter.prototype={initialize:function(callback,frequency){this.callback=callback;this.frequency=frequency;this.currentlyExecuting=false;this.registerCallback();},registerCallback:function(){this.timer=setInterval(this.onTimerEvent.bind(this),this.frequency*1000);},stop:function(){if(!this.timer)return;clearInterval(this.timer);this.timer=null;},onTimerEvent:function(){if(!this.currentlyExecuting){try{this.currentlyExecuting=true;this.callback(this);}finally{this.currentlyExecuting=false;}}}}
Object.extend(String,{interpret:function(value){return value==null?'':String(value);},specialChar:{'\b':'\\b','\t':'\\t','\n':'\\n','\f':'\\f','\r':'\\r','\\':'\\\\'}});Object.extend(String.prototype,{gsub:function(pattern,replacement){var result='',source=this,match;replacement=arguments.callee.prepareReplacement(replacement);while(source.length>0){if(match=source.match(pattern)){result+=source.slice(0,match.index);result+=String.interpret(replacement(match));source=source.slice(match.index+match[0].length);}else{result+=source,source='';}}
return result;},sub:function(pattern,replacement,count){replacement=this.gsub.prepareReplacement(replacement);count=count===undefined?1:count;return this.gsub(pattern,function(match){if(--count<0)return match[0];return replacement(match);});},scan:function(pattern,iterator){this.gsub(pattern,iterator);return this;},truncate:function(length,truncation){length=length||30;truncation=truncation===undefined?'...':truncation;return this.length>length?this.slice(0,length-truncation.length)+truncation:this;},strip:function(){return this.replace(/^\s+/,'').replace(/\s+$/,'');},stripTags:function(){return this.replace(/<\/?[^>]+>/gi,'');},stripScripts:function(){return this.replace(new RegExp(Prototype.ScriptFragment,'img'),'');},extractScripts:function(){var matchAll=new RegExp(Prototype.ScriptFragment,'img');var matchOne=new RegExp(Prototype.ScriptFragment,'im');return(this.match(matchAll)||[]).map(function(scriptTag){return(scriptTag.match(matchOne)||['',''])[1];});},evalScripts:function(){return this.extractScripts().map(function(script){return eval(script)});},escapeHTML:function(){var self=arguments.callee;self.text.data=this;return self.div.innerHTML;},unescapeHTML:function(){var div=document.createElement('div');div.innerHTML=this.stripTags();return div.childNodes[0]?(div.childNodes.length>1?$MediComA(div.childNodes).inject('',function(memo,node){return memo+node.nodeValue}):div.childNodes[0].nodeValue):'';},toQueryParams:function(separator){var match=this.strip().match(/([^?#]*)(#.*)?$/);if(!match)return{};return match[1].split(separator||'&').inject({},function(hash,pair){if((pair=pair.split('='))[0]){var key=decodeURIComponent(pair.shift());var value=pair.length>1?pair.join('='):pair[0];if(value!=undefined)value=decodeURIComponent(value);if(key in hash){if(hash[key].constructor!=Array)hash[key]=[hash[key]];hash[key].push(value);}
else hash[key]=value;}
return hash;});},toArray:function(){return this.split('');},succ:function(){return this.slice(0,this.length-1)+
String.fromCharCode(this.charCodeAt(this.length-1)+1);},times:function(count){var result='';for(var i=0;i<count;i++)result+=this;return result;},camelize:function(){var parts=this.split('-'),len=parts.length;if(len==1)return parts[0];var camelized=this.charAt(0)=='-'?parts[0].charAt(0).toUpperCase()+parts[0].substring(1):parts[0];for(var i=1;i<len;i++)
camelized+=parts[i].charAt(0).toUpperCase()+parts[i].substring(1);return camelized;},capitalize:function(){return this.charAt(0).toUpperCase()+this.substring(1).toLowerCase();},underscore:function(){return this.gsub(/::/,'/').gsub(/([A-Z]+)([A-Z][a-z])/,'#{1}_#{2}').gsub(/([a-z\d])([A-Z])/,'#{1}_#{2}').gsub(/-/,'_').toLowerCase();},dasherize:function(){return this.gsub(/_/,'-');},inspect:function(useDoubleQuotes){var escapedString=this.gsub(/[\x00-\x1f\\]/,function(match){var character=String.specialChar[match[0]];return character?character:'\\u00'+match[0].charCodeAt().toPaddedString(2,16);});if(useDoubleQuotes)return'"'+escapedString.replace(/"/g,'\\"')+'"';return"'"+escapedString.replace(/'/g,'\\\'')+"'";},toJSON:function(){return this.inspect(true);},unfilterJSON:function(filter){return this.sub(filter||Prototype.JSONFilter,'#{1}');},isJSON:function(){var str=this.replace(/\\./g,'@').replace(/"[^"\\\n\r]*"/g,'');return(/^[,:{}\[\]0-9.\-+Eaeflnr-u \n\r\t]*$/).test(str);},evalJSON:function(sanitize){var json=this.unfilterJSON();try{if(!sanitize||json.isJSON())return eval('('+json+')');}catch(e){}
throw new SyntaxError('Badly formed JSON string: '+this.inspect());},include:function(pattern){return this.indexOf(pattern)>-1;},startsWith:function(pattern){return this.indexOf(pattern)===0;},endsWith:function(pattern){var d=this.length-pattern.length;return d>=0&&this.lastIndexOf(pattern)===d;},empty:function(){return this=='';},blank:function(){return/^\s*$/.test(this);}});if(Prototype.Browser.WebKit||Prototype.Browser.IE)Object.extend(String.prototype,{escapeHTML:function(){return this.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');},unescapeHTML:function(){return this.replace(/&amp;/g,'&').replace(/&lt;/g,'<').replace(/&gt;/g,'>');}});String.prototype.gsub.prepareReplacement=function(replacement){if(typeof replacement=='function')return replacement;var template=new Template(replacement);return function(match){return template.evaluate(match)};}
String.prototype.parseQuery=String.prototype.toQueryParams;Object.extend(String.prototype.escapeHTML,{div:document.createElement('div'),text:document.createTextNode('')});with(String.prototype.escapeHTML)div.appendChild(text);var Template=Class.create();Template.Pattern=/(^|.|\r|\n)(#\{(.*?)\})/;Template.prototype={initialize:function(template,pattern){this.template=template.toString();this.pattern=pattern||Template.Pattern;},evaluate:function(object){return this.template.gsub(this.pattern,function(match){var before=match[1];if(before=='\\')return match[2];return before+String.interpret(object[match[3]]);});}}
var $break={},$continue=new Error('"throw $continue" is deprecated, use "return" instead');var Enumerable={each:function(iterator){var index=0;try{this._each(function(value){iterator(value,index++);});}catch(e){if(e!=$break)throw e;}
return this;},eachSlice:function(number,iterator){var index=-number,slices=[],array=this.toArray();while((index+=number)<array.length)
slices.push(array.slice(index,index+number));return slices.map(iterator);},all:function(iterator){var result=true;this.each(function(value,index){result=result&&!!(iterator||Prototype.K)(value,index);if(!result)throw $break;});return result;},any:function(iterator){var result=false;this.each(function(value,index){if(result=!!(iterator||Prototype.K)(value,index))
throw $break;});return result;},collect:function(iterator){var results=[];this.each(function(value,index){results.push((iterator||Prototype.K)(value,index));});return results;},detect:function(iterator){var result;this.each(function(value,index){if(iterator(value,index)){result=value;throw $break;}});return result;},findAll:function(iterator){var results=[];this.each(function(value,index){if(iterator(value,index))
results.push(value);});return results;},grep:function(pattern,iterator){var results=[];this.each(function(value,index){var stringValue=value.toString();if(stringValue.match(pattern))
results.push((iterator||Prototype.K)(value,index));})
return results;},include:function(object){var found=false;this.each(function(value){if(value==object){found=true;throw $break;}});return found;},inGroupsOf:function(number,fillWith){fillWith=fillWith===undefined?null:fillWith;return this.eachSlice(number,function(slice){while(slice.length<number)slice.push(fillWith);return slice;});},inject:function(memo,iterator){this.each(function(value,index){memo=iterator(memo,value,index);});return memo;},invoke:function(method){var args=$MediComA(arguments).slice(1);return this.map(function(value){return value[method].apply(value,args);});},max:function(iterator){var result;this.each(function(value,index){value=(iterator||Prototype.K)(value,index);if(result==undefined||value>=result)
result=value;});return result;},min:function(iterator){var result;this.each(function(value,index){value=(iterator||Prototype.K)(value,index);if(result==undefined||value<result)
result=value;});return result;},partition:function(iterator){var trues=[],falses=[];this.each(function(value,index){((iterator||Prototype.K)(value,index)?trues:falses).push(value);});return[trues,falses];},pluck:function(property){var results=[];this.each(function(value,index){results.push(value[property]);});return results;},reject:function(iterator){var results=[];this.each(function(value,index){if(!iterator(value,index))
results.push(value);});return results;},sortBy:function(iterator){return this.map(function(value,index){return{value:value,criteria:iterator(value,index)};}).sort(function(left,right){var a=left.criteria,b=right.criteria;return a<b?-1:a>b?1:0;}).pluck('value');},toArray:function(){return this.map();},zip:function(){var iterator=Prototype.K,args=$MediComA(arguments);if(typeof args.last()=='function')
iterator=args.pop();var collections=[this].concat(args).map($MediComA);return this.map(function(value,index){return iterator(collections.pluck(index));});},size:function(){return this.toArray().length;},inspect:function(){return'#<Enumerable:'+this.toArray().inspect()+'>';}}
Object.extend(Enumerable,{map:Enumerable.collect,find:Enumerable.detect,select:Enumerable.findAll,member:Enumerable.include,entries:Enumerable.toArray});var $MediComA=Array.from=function(iterable){if(!iterable)return[];if(iterable.toArray){return iterable.toArray();}else{var results=[];for(var i=0,length=iterable.length;i<length;i++)
results.push(iterable[i]);return results;}}
if(Prototype.Browser.WebKit){$MediComA=Array.from=function(iterable){if(!iterable)return[];if(!(typeof iterable=='function'&&iterable=='[object NodeList]')&&iterable.toArray){return iterable.toArray();}else{var results=[];for(var i=0,length=iterable.length;i<length;i++)
results.push(iterable[i]);return results;}}}
Object.extend(Array.prototype,Enumerable);if(!Array.prototype._reverse)
Array.prototype._reverse=Array.prototype.reverse;Object.extend(Array.prototype,{_each:function(iterator){for(var i=0,length=this.length;i<length;i++)
iterator(this[i]);},clear:function(){this.length=0;return this;},first:function(){return this[0];},last:function(){return this[this.length-1];},compact:function(){return this.select(function(value){return value!=null;});},flatten:function(){return this.inject([],function(array,value){return array.concat(value&&value.constructor==Array?value.flatten():[value]);});},without:function(){var values=$MediComA(arguments);return this.select(function(value){return!values.include(value);});},indexOf:function(object){for(var i=0,length=this.length;i<length;i++)
if(this[i]==object)return i;return-1;},reverse:function(inline){return(inline!==false?this:this.toArray())._reverse();},reduce:function(){return this.length>1?this:this[0];},uniq:function(sorted){return this.inject([],function(array,value,index){if(0==index||(sorted?array.last()!=value:!array.include(value)))
array.push(value);return array;});},clone:function(){return[].concat(this);},size:function(){return this.length;},inspect:function(){return'['+this.map(Object.inspect).join(', ')+']';},toJSON:function(){var results=[];this.each(function(object){var value=Object.toJSON(object);if(value!==undefined)results.push(value);});return'['+results.join(', ')+']';}});Array.prototype.toArray=Array.prototype.clone;function $w(string){string=string.strip();return string?string.split(/\s+/):[];}
if(Prototype.Browser.Opera){Array.prototype.concat=function(){var array=[];for(var i=0,length=this.length;i<length;i++)array.push(this[i]);for(var i=0,length=arguments.length;i<length;i++){if(arguments[i].constructor==Array){for(var j=0,arrayLength=arguments[i].length;j<arrayLength;j++)
array.push(arguments[i][j]);}else{array.push(arguments[i]);}}
return array;}}
var Hash=function(object){if(object instanceof Hash)this.merge(object);else Object.extend(this,object||{});};Object.extend(Hash,{toQueryString:function(obj){var parts=[];parts.add=arguments.callee.addPair;this.prototype._each.call(obj,function(pair){if(!pair.key)return;var value=pair.value;if(value&&typeof value=='object'){if(value.constructor==Array)value.each(function(value){parts.add(pair.key,value);});return;}
parts.add(pair.key,value);});return parts.join('&');},toJSON:function(object){var results=[];this.prototype._each.call(object,function(pair){var value=Object.toJSON(pair.value);if(value!==undefined)results.push(pair.key.toJSON()+': '+value);});return'{'+results.join(', ')+'}';}});Hash.toQueryString.addPair=function(key,value,prefix){key=encodeURIComponent(key);if(value===undefined)this.push(key);else this.push(key+'='+(value==null?'':encodeURIComponent(value)));}
Object.extend(Hash.prototype,Enumerable);Object.extend(Hash.prototype,{_each:function(iterator){for(var key in this){var value=this[key];if(value&&value==Hash.prototype[key])continue;var pair=[key,value];pair.key=key;pair.value=value;iterator(pair);}},keys:function(){return this.pluck('key');},values:function(){return this.pluck('value');},merge:function(hash){return $MediComH(hash).inject(this,function(mergedHash,pair){mergedHash[pair.key]=pair.value;return mergedHash;});},remove:function(){var result;for(var i=0,length=arguments.length;i<length;i++){var value=this[arguments[i]];if(value!==undefined){if(result===undefined)result=value;else{if(result.constructor!=Array)result=[result];result.push(value)}}
delete this[arguments[i]];}
return result;},toQueryString:function(){return Hash.toQueryString(this);},inspect:function(){return'#<Hash:{'+this.map(function(pair){return pair.map(Object.inspect).join(': ');}).join(', ')+'}>';},toJSON:function(){return Hash.toJSON(this);}});function $MediComH(object){if(object instanceof Hash)return object;return new Hash(object);};if(function(){var i=0,Test=function(value){this.key=value};Test.prototype.key='foo';for(var property in new Test('bar'))i++;return i>1;}())Hash.prototype._each=function(iterator){var cache=[];for(var key in this){var value=this[key];if((value&&value==Hash.prototype[key])||cache.include(key))continue;cache.push(key);var pair=[key,value];pair.key=key;pair.value=value;iterator(pair);}};ObjectRange=Class.create();Object.extend(ObjectRange.prototype,Enumerable);Object.extend(ObjectRange.prototype,{initialize:function(start,end,exclusive){this.start=start;this.end=end;this.exclusive=exclusive;},_each:function(iterator){var value=this.start;while(this.include(value)){iterator(value);value=value.succ();}},include:function(value){if(value<this.start)
return false;if(this.exclusive)
return value<this.end;return value<=this.end;}});var $R=function(start,end,exclusive){return new ObjectRange(start,end,exclusive);}
var Ajax={getTransport:function(){return Try.these(function(){return new XMLHttpRequest()},function(){return new ActiveXObject('Msxml2.XMLHTTP')},function(){return new ActiveXObject('Microsoft.XMLHTTP')})||false;},activeRequestCount:0}
Ajax.Responders={responders:[],_each:function(iterator){this.responders._each(iterator);},register:function(responder){if(!this.include(responder))
this.responders.push(responder);},unregister:function(responder){this.responders=this.responders.without(responder);},dispatch:function(callback,request,transport,json){this.each(function(responder){if(typeof responder[callback]=='function'){try{responder[callback].apply(responder,[request,transport,json]);}catch(e){}}});}};Object.extend(Ajax.Responders,Enumerable);Ajax.Responders.register({onCreate:function(){Ajax.activeRequestCount++;},onComplete:function(){Ajax.activeRequestCount--;}});Ajax.Base=function(){};Ajax.Base.prototype={setOptions:function(options){this.options={method:'post',asynchronous:true,contentType:'application/x-www-form-urlencoded',encoding:'UTF-8',parameters:''}
Object.extend(this.options,options||{});this.options.method=this.options.method.toLowerCase();if(typeof this.options.parameters=='string')
this.options.parameters=this.options.parameters.toQueryParams();}}
Ajax.Request=Class.create();Ajax.Request.Events=['Uninitialized','Loading','Loaded','Interactive','Complete'];Ajax.Request.prototype=Object.extend(new Ajax.Base(),{_complete:false,initialize:function(url,options){this.transport=Ajax.getTransport();this.setOptions(options);this.request(url);},request:function(url){this.url=url;this.method=this.options.method;var params=Object.clone(this.options.parameters);if(!['get','post'].include(this.method)){params['_method']=this.method;this.method='post';}
this.parameters=params;if(params=Hash.toQueryString(params)){if(this.method=='get')
this.url+=(this.url.include('?')?'&':'?')+params;else if(/Konqueror|Safari|KHTML/.test(navigator.userAgent))
params+='&_=';}
try{if(this.options.onCreate)this.options.onCreate(this.transport);Ajax.Responders.dispatch('onCreate',this,this.transport);this.transport.open(this.method.toUpperCase(),this.url,this.options.asynchronous);if(this.options.asynchronous)
setTimeout(function(){this.respondToReadyState(1)}.bind(this),10);this.transport.onreadystatechange=this.onStateChange.bind(this);this.setRequestHeaders();this.body=this.method=='post'?(this.options.postBody||params):null;this.transport.send(this.body);if(!this.options.asynchronous&&this.transport.overrideMimeType)
this.onStateChange();}
catch(e){this.dispatchException(e);}},onStateChange:function(){var readyState=this.transport.readyState;if(readyState>1&&!((readyState==4)&&this._complete))
this.respondToReadyState(this.transport.readyState);},setRequestHeaders:function(){var headers={'X-Requested-With':'XMLHttpRequest','X-Prototype-Version':Prototype.Version,'Accept':'text/javascript, text/html, application/xml, text/xml, */*'};if(this.method=='post'){headers['Content-type']=this.options.contentType+
(this.options.encoding?'; charset='+this.options.encoding:'');if(this.transport.overrideMimeType&&(navigator.userAgent.match(/Gecko\/(\d{4})/)||[0,2005])[1]<2005)
headers['Connection']='close';}
if(typeof this.options.requestHeaders=='object'){var extras=this.options.requestHeaders;if(typeof extras.push=='function')
for(var i=0,length=extras.length;i<length;i+=2)
headers[extras[i]]=extras[i+1];else
$MediComH(extras).each(function(pair){headers[pair.key]=pair.value});}
for(var name in headers)
this.transport.setRequestHeader(name,headers[name]);},success:function(){return!this.transport.status||(this.transport.status>=200&&this.transport.status<300);},respondToReadyState:function(readyState){var state=Ajax.Request.Events[readyState];var transport=this.transport,json=this.evalJSON();if(state=='Complete'){try{this._complete=true;(this.options['on'+this.transport.status]||this.options['on'+(this.success()?'Success':'Failure')]||Prototype.emptyFunction)(transport,json);}catch(e){this.dispatchException(e);}
var contentType=this.getHeader('Content-type');if(contentType&&contentType.strip().match(/^(text|application)\/(x-)?(java|ecma)script(;.*)?$/i))
this.evalResponse();}
try{(this.options['on'+state]||Prototype.emptyFunction)(transport,json);Ajax.Responders.dispatch('on'+state,this,transport,json);}catch(e){this.dispatchException(e);}
if(state=='Complete'){this.transport.onreadystatechange=Prototype.emptyFunction;}},getHeader:function(name){try{return this.transport.getResponseHeader(name);}catch(e){return null}},evalJSON:function(){try{var json=this.getHeader('X-JSON');return json?json.evalJSON():null;}catch(e){return null}},evalResponse:function(){try{return eval((this.transport.responseText||'').unfilterJSON());}catch(e){this.dispatchException(e);}},dispatchException:function(exception){(this.options.onException||Prototype.emptyFunction)(this,exception);Ajax.Responders.dispatch('onException',this,exception);}});Ajax.Updater=Class.create();Object.extend(Object.extend(Ajax.Updater.prototype,Ajax.Request.prototype),{initialize:function(container,url,options){this.container={success:(container.success||container),failure:(container.failure||(container.success?null:container))}
this.transport=Ajax.getTransport();this.setOptions(options);var onComplete=this.options.onComplete||Prototype.emptyFunction;this.options.onComplete=(function(transport,param){this.updateContent();onComplete(transport,param);}).bind(this);this.request(url);},updateContent:function(){var receiver=this.container[this.success()?'success':'failure'];var response=this.transport.responseText;if(!this.options.evalScripts)response=response.stripScripts();if(receiver=$MediCom(receiver)){if(this.options.insertion)
new this.options.insertion(receiver,response);else
receiver.update(response);}
if(this.success()){if(this.onComplete)
setTimeout(this.onComplete.bind(this),10);}}});Ajax.PeriodicalUpdater=Class.create();Ajax.PeriodicalUpdater.prototype=Object.extend(new Ajax.Base(),{initialize:function(container,url,options){this.setOptions(options);this.onComplete=this.options.onComplete;this.frequency=(this.options.frequency||2);this.decay=(this.options.decay||1);this.updater={};this.container=container;this.url=url;this.start();},start:function(){this.options.onComplete=this.updateComplete.bind(this);this.onTimerEvent();},stop:function(){this.updater.options.onComplete=undefined;clearTimeout(this.timer);(this.onComplete||Prototype.emptyFunction).apply(this,arguments);},updateComplete:function(request){if(this.options.decay){this.decay=(request.responseText==this.lastText?this.decay*this.options.decay:1);this.lastText=request.responseText;}
this.timer=setTimeout(this.onTimerEvent.bind(this),this.decay*this.frequency*1000);},onTimerEvent:function(){this.updater=new Ajax.Updater(this.container,this.url,this.options);}});function $MediCom(element){if(arguments.length>1){for(var i=0,elements=[],length=arguments.length;i<length;i++)
elements.push($MediCom(arguments[i]));return elements;}
if(typeof element=='string')
element=document.getElementById(element);return Element.extend(element);};if(Prototype.BrowserFeatures.XPath){document._getElementsByXPath=function(expression,parentElement){var results=[];var query=document.evaluate(expression,$MediCom(parentElement)||document,null,XPathResult.ORDERED_NODE_SNAPSHOT_TYPE,null);for(var i=0,length=query.snapshotLength;i<length;i++)
results.push(query.snapshotItem(i));return results;};document.getElementsByClassName=function(className,parentElement){var q=".//*[contains(concat(' ', @class, ' '), ' "+className+" ')]";return document._getElementsByXPath(q,parentElement);}}else document.getElementsByClassName=function(className,parentElement){var children=($MediCom(parentElement)||document.body).getElementsByTagName('*');var elements=[],child,pattern=new RegExp("(^|\\s)"+className+"(\\s|$)");for(var i=0,length=children.length;i<length;i++){child=children[i];var elementClassName=child.className;if(elementClassName.length==0)continue;if(elementClassName==className||elementClassName.match(pattern))
elements.push(Element.extend(child));}
return elements;};if(!window.Element)var Element={};Element.extend=function(element){var F=Prototype.BrowserFeatures;if(!element||!element.tagName||element.nodeType==3||element._extended||F.SpecificElementExtensions||element==window)
return element;var methods={},tagName=element.tagName,cache=Element.extend.cache,T=Element.Methods.ByTag;if(!F.ElementExtensions){Object.extend(methods,Element.Methods),Object.extend(methods,Element.Methods.Simulated);}
if(T[tagName])Object.extend(methods,T[tagName]);for(var property in methods){var value=methods[property];if(typeof value=='function'&&!(property in element))
element[property]=cache.findOrStore(value);}
element._extended=Prototype.emptyFunction;return element;};Element.extend.cache={findOrStore:function(value){return this[value]=this[value]||function(){return value.apply(null,[this].concat($MediComA(arguments)));}}};Element.Methods={visible:function(element){return $MediCom(element).style.display!='none';},toggle:function(element){element=$MediCom(element);Element[Element.visible(element)?'hide':'show'](element);return element;},hide:function(element){$MediCom(element).style.display='none';return element;},show:function(element){$MediCom(element).style.display='';return element;},remove:function(element){element=$MediCom(element);element.parentNode.removeChild(element);return element;},update:function(element,html){html=typeof html=='undefined'?'':html.toString();$MediCom(element).innerHTML=html.stripScripts();setTimeout(function(){html.evalScripts()},10);return element;},replace:function(element,html){element=$MediCom(element);html=typeof html=='undefined'?'':html.toString();if(element.outerHTML){element.outerHTML=html.stripScripts();}else{var range=element.ownerDocument.createRange();range.selectNodeContents(element);element.parentNode.replaceChild(range.createContextualFragment(html.stripScripts()),element);}
setTimeout(function(){html.evalScripts()},10);return element;},inspect:function(element){element=$MediCom(element);var result='<'+element.tagName.toLowerCase();$MediComH({'id':'id','className':'class'}).each(function(pair){var property=pair.first(),attribute=pair.last();var value=(element[property]||'').toString();if(value)result+=' '+attribute+'='+value.inspect(true);});return result+'>';},recursivelyCollect:function(element,property){element=$MediCom(element);var elements=[];while(element=element[property])
if(element.nodeType==1)
elements.push(Element.extend(element));return elements;},ancestors:function(element){return $MediCom(element).recursivelyCollect('parentNode');},descendants:function(element){return $MediComA($MediCom(element).getElementsByTagName('*')).each(Element.extend);},firstDescendant:function(element){element=$MediCom(element).firstChild;while(element&&element.nodeType!=1)element=element.nextSibling;return $MediCom(element);},immediateDescendants:function(element){if(!(element=$MediCom(element).firstChild))return[];while(element&&element.nodeType!=1)element=element.nextSibling;if(element)return[element].concat($MediCom(element).nextSiblings());return[];},previousSiblings:function(element){return $MediCom(element).recursivelyCollect('previousSibling');},nextSiblings:function(element){return $MediCom(element).recursivelyCollect('nextSibling');},siblings:function(element){element=$MediCom(element);return element.previousSiblings().reverse().concat(element.nextSiblings());},match:function(element,selector){if(typeof selector=='string')
selector=new Selector(selector);return selector.match($MediCom(element));},up:function(element,expression,index){element=$MediCom(element);if(arguments.length==1)return $MediCom(element.parentNode);var ancestors=element.ancestors();return expression?Selector.findElement(ancestors,expression,index):ancestors[index||0];},down:function(element,expression,index){element=$MediCom(element);if(arguments.length==1)return element.firstDescendant();var descendants=element.descendants();return expression?Selector.findElement(descendants,expression,index):descendants[index||0];},previous:function(element,expression,index){element=$MediCom(element);if(arguments.length==1)return $MediCom(Selector.handlers.previousElementSibling(element));var previousSiblings=element.previousSiblings();return expression?Selector.findElement(previousSiblings,expression,index):previousSiblings[index||0];},next:function(element,expression,index){element=$MediCom(element);if(arguments.length==1)return $MediCom(Selector.handlers.nextElementSibling(element));var nextSiblings=element.nextSiblings();return expression?Selector.findElement(nextSiblings,expression,index):nextSiblings[index||0];},getElementsBySelector:function(){var args=$MediComA(arguments),element=$MediCom(args.shift());return Selector.findChildElements(element,args);},getElementsByClassName:function(element,className){return document.getElementsByClassName(className,element);},readAttribute:function(element,name){element=$MediCom(element);if(Prototype.Browser.IE){if(!element.attributes)return null;var t=Element._attributeTranslations;if(t.values[name])return t.values[name](element,name);if(t.names[name])name=t.names[name];var attribute=element.attributes[name];return attribute?attribute.nodeValue:null;}
return element.getAttribute(name);},getHeight:function(element){return $MediCom(element).getDimensions().height;},getWidth:function(element){return $MediCom(element).getDimensions().width;},classNames:function(element){return new Element.ClassNames(element);},hasClassName:function(element,className){if(!(element=$MediCom(element)))return;var elementClassName=element.className;if(elementClassName.length==0)return false;if(elementClassName==className||elementClassName.match(new RegExp("(^|\\s)"+className+"(\\s|$)")))
return true;return false;},addClassName:function(element,className){if(!(element=$MediCom(element)))return;Element.classNames(element).add(className);return element;},removeClassName:function(element,className){if(!(element=$MediCom(element)))return;Element.classNames(element).remove(className);return element;},toggleClassName:function(element,className){if(!(element=$MediCom(element)))return;Element.classNames(element)[element.hasClassName(className)?'remove':'add'](className);return element;},observe:function(){Event.observe.apply(Event,arguments);return $MediComA(arguments).first();},stopObserving:function(){Event.stopObserving.apply(Event,arguments);return $MediComA(arguments).first();},cleanWhitespace:function(element){element=$MediCom(element);var node=element.firstChild;while(node){var nextNode=node.nextSibling;if(node.nodeType==3&&!/\S/.test(node.nodeValue))
element.removeChild(node);node=nextNode;}
return element;},empty:function(element){return $MediCom(element).innerHTML.blank();},descendantOf:function(element,ancestor){element=$MediCom(element),ancestor=$MediCom(ancestor);while(element=element.parentNode)
if(element==ancestor)return true;return false;},scrollTo:function(element){element=$MediCom(element);var pos=Position.cumulativeOffset(element);window.scrollTo(pos[0],pos[1]);return element;},getStyle:function(element,style){element=$MediCom(element);style=style=='float'?'cssFloat':style.camelize();var value=element.style[style];if(!value){var css=document.defaultView.getComputedStyle(element,null);value=css?css[style]:null;}
if(style=='opacity')return value?parseFloat(value):1.0;return value=='auto'?null:value;},getOpacity:function(element){return $MediCom(element).getStyle('opacity');},setStyle:function(element,styles,camelized){element=$MediCom(element);var elementStyle=element.style;for(var property in styles)
if(property=='opacity')element.setOpacity(styles[property])
else
elementStyle[(property=='float'||property=='cssFloat')?(elementStyle.styleFloat===undefined?'cssFloat':'styleFloat'):(camelized?property:property.camelize())]=styles[property];return element;},setOpacity:function(element,value){element=$MediCom(element);element.style.opacity=(value==1||value==='')?'':(value<0.00001)?0:value;return element;},getDimensions:function(element){element=$MediCom(element);var display=$MediCom(element).getStyle('display');if(display!='none'&&display!=null)
return{width:element.offsetWidth,height:element.offsetHeight};var els=element.style;var originalVisibility=els.visibility;var originalPosition=els.position;var originalDisplay=els.display;els.visibility='hidden';els.position='absolute';els.display='block';var originalWidth=element.clientWidth;var originalHeight=element.clientHeight;els.display=originalDisplay;els.position=originalPosition;els.visibility=originalVisibility;return{width:originalWidth,height:originalHeight};},makePositioned:function(element){element=$MediCom(element);var pos=Element.getStyle(element,'position');if(pos=='static'||!pos){element._madePositioned=true;element.style.position='relative';if(window.opera){element.style.top=0;element.style.left=0;}}
return element;},undoPositioned:function(element){element=$MediCom(element);if(element._madePositioned){element._madePositioned=undefined;element.style.position=element.style.top=element.style.left=element.style.bottom=element.style.right='';}
return element;},makeClipping:function(element){element=$MediCom(element);if(element._overflow)return element;element._overflow=element.style.overflow||'auto';if((Element.getStyle(element,'overflow')||'visible')!='hidden')
element.style.overflow='hidden';return element;},undoClipping:function(element){element=$MediCom(element);if(!element._overflow)return element;element.style.overflow=element._overflow=='auto'?'':element._overflow;element._overflow=null;return element;}};Object.extend(Element.Methods,{childOf:Element.Methods.descendantOf,childElements:Element.Methods.immediateDescendants});if(Prototype.Browser.Opera){Element.Methods._getStyle=Element.Methods.getStyle;Element.Methods.getStyle=function(element,style){switch(style){case'left':case'top':case'right':case'bottom':if(Element._getStyle(element,'position')=='static')return null;default:return Element._getStyle(element,style);}};}
else if(Prototype.Browser.IE){Element.Methods.getStyle=function(element,style){element=$MediCom(element);style=(style=='float'||style=='cssFloat')?'styleFloat':style.camelize();var value=element.style[style];if(!value&&element.currentStyle)value=element.currentStyle[style];if(style=='opacity'){if(value=(element.getStyle('filter')||'').match(/alpha\(opacity=(.*)\)/))
if(value[1])return parseFloat(value[1])/100;return 1.0;}
if(value=='auto'){if((style=='width'||style=='height')&&(element.getStyle('display')!='none'))
return element['offset'+style.capitalize()]+'px';return null;}
return value;};Element.Methods.setOpacity=function(element,value){element=$MediCom(element);var filter=element.getStyle('filter'),style=element.style;if(value==1||value===''){style.filter=filter.replace(/alpha\([^\)]*\)/gi,'');return element;}else if(value<0.00001)value=0;style.filter=filter.replace(/alpha\([^\)]*\)/gi,'')+'alpha(opacity='+(value*100)+')';return element;};Element.Methods.update=function(element,html){element=$MediCom(element);html=typeof html=='undefined'?'':html.toString();var tagName=element.tagName.toUpperCase();if(['THEAD','TBODY','TR','TD'].include(tagName)){var div=document.createElement('div');switch(tagName){case'THEAD':case'TBODY':div.innerHTML='<table><tbody>'+html.stripScripts()+'</tbody></table>';depth=2;break;case'TR':div.innerHTML='<table><tbody><tr>'+html.stripScripts()+'</tr></tbody></table>';depth=3;break;case'TD':div.innerHTML='<table><tbody><tr><td>'+html.stripScripts()+'</td></tr></tbody></table>';depth=4;}
$MediComA(element.childNodes).each(function(node){element.removeChild(node)});depth.times(function(){div=div.firstChild});$MediComA(div.childNodes).each(function(node){element.appendChild(node)});}else{element.innerHTML=html.stripScripts();}
setTimeout(function(){html.evalScripts()},10);return element;}}
else if(Prototype.Browser.Gecko){Element.Methods.setOpacity=function(element,value){element=$MediCom(element);element.style.opacity=(value==1)?0.999999:(value==='')?'':(value<0.00001)?0:value;return element;};}
Element._attributeTranslations={names:{colspan:"colSpan",rowspan:"rowSpan",valign:"vAlign",datetime:"dateTime",accesskey:"accessKey",tabindex:"tabIndex",enctype:"encType",maxlength:"maxLength",readonly:"readOnly",longdesc:"longDesc"},values:{_getAttr:function(element,attribute){return element.getAttribute(attribute,2);},_flag:function(element,attribute){return $MediCom(element).hasAttribute(attribute)?attribute:null;},style:function(element){return element.style.cssText.toLowerCase();},title:function(element){var node=element.getAttributeNode('title');return node.specified?node.nodeValue:null;}}};(function(){Object.extend(this,{href:this._getAttr,src:this._getAttr,type:this._getAttr,disabled:this._flag,checked:this._flag,readonly:this._flag,multiple:this._flag});}).call(Element._attributeTranslations.values);Element.Methods.Simulated={hasAttribute:function(element,attribute){var t=Element._attributeTranslations,node;attribute=t.names[attribute]||attribute;node=$MediCom(element).getAttributeNode(attribute);return node&&node.specified;}};Element.Methods.ByTag={};Object.extend(Element,Element.Methods);if(!Prototype.BrowserFeatures.ElementExtensions&&document.createElement('div').__proto__){window.HTMLElement={};window.HTMLElement.prototype=document.createElement('div').__proto__;Prototype.BrowserFeatures.ElementExtensions=true;}
Element.hasAttribute=function(element,attribute){if(element.hasAttribute)return element.hasAttribute(attribute);return Element.Methods.Simulated.hasAttribute(element,attribute);};Element.addMethods=function(methods){var F=Prototype.BrowserFeatures,T=Element.Methods.ByTag;if(!methods){Object.extend(Form,Form.Methods);Object.extend(Form.Element,Form.Element.Methods);Object.extend(Element.Methods.ByTag,{"FORM":Object.clone(Form.Methods),"INPUT":Object.clone(Form.Element.Methods),"SELECT":Object.clone(Form.Element.Methods),"TEXTAREA":Object.clone(Form.Element.Methods)});}
if(arguments.length==2){var tagName=methods;methods=arguments[1];}
if(!tagName)Object.extend(Element.Methods,methods||{});else{if(tagName.constructor==Array)tagName.each(extend);else extend(tagName);}
function extend(tagName){tagName=tagName.toUpperCase();if(!Element.Methods.ByTag[tagName])
Element.Methods.ByTag[tagName]={};Object.extend(Element.Methods.ByTag[tagName],methods);}
function copy(methods,destination,onlyIfAbsent){onlyIfAbsent=onlyIfAbsent||false;var cache=Element.extend.cache;for(var property in methods){var value=methods[property];if(!onlyIfAbsent||!(property in destination))
destination[property]=cache.findOrStore(value);}}
function findDOMClass(tagName){var klass;var trans={"OPTGROUP":"OptGroup","TEXTAREA":"TextArea","P":"Paragraph","FIELDSET":"FieldSet","UL":"UList","OL":"OList","DL":"DList","DIR":"Directory","H1":"Heading","H2":"Heading","H3":"Heading","H4":"Heading","H5":"Heading","H6":"Heading","Q":"Quote","INS":"Mod","DEL":"Mod","A":"Anchor","IMG":"Image","CAPTION":"TableCaption","COL":"TableCol","COLGROUP":"TableCol","THEAD":"TableSection","TFOOT":"TableSection","TBODY":"TableSection","TR":"TableRow","TH":"TableCell","TD":"TableCell","FRAMESET":"FrameSet","IFRAME":"IFrame"};if(trans[tagName])klass='HTML'+trans[tagName]+'Element';if(window[klass])return window[klass];klass='HTML'+tagName+'Element';if(window[klass])return window[klass];klass='HTML'+tagName.capitalize()+'Element';if(window[klass])return window[klass];window[klass]={};window[klass].prototype=document.createElement(tagName).__proto__;return window[klass];}
if(F.ElementExtensions){copy(Element.Methods,HTMLElement.prototype);copy(Element.Methods.Simulated,HTMLElement.prototype,true);}
if(F.SpecificElementExtensions){for(var tag in Element.Methods.ByTag){var klass=findDOMClass(tag);if(typeof klass=="undefined")continue;copy(T[tag],klass.prototype);}}
Object.extend(Element,Element.Methods);delete Element.ByTag;};var Toggle={display:Element.toggle};Abstract.Insertion=function(adjacency){this.adjacency=adjacency;}
Abstract.Insertion.prototype={initialize:function(element,content){this.element=$MediCom(element);this.content=content.stripScripts();if(this.adjacency&&this.element.insertAdjacentHTML){try{this.element.insertAdjacentHTML(this.adjacency,this.content);}catch(e){var tagName=this.element.tagName.toUpperCase();if(['TBODY','TR'].include(tagName)){this.insertContent(this.contentFromAnonymousTable());}else{throw e;}}}else{this.range=this.element.ownerDocument.createRange();if(this.initializeRange)this.initializeRange();this.insertContent([this.range.createContextualFragment(this.content)]);}
setTimeout(function(){content.evalScripts()},10);},contentFromAnonymousTable:function(){var div=document.createElement('div');div.innerHTML='<table><tbody>'+this.content+'</tbody></table>';return $MediComA(div.childNodes[0].childNodes[0].childNodes);}}
var Insertion=new Object();Insertion.Before=Class.create();Insertion.Before.prototype=Object.extend(new Abstract.Insertion('beforeBegin'),{initializeRange:function(){this.range.setStartBefore(this.element);},insertContent:function(fragments){fragments.each((function(fragment){this.element.parentNode.insertBefore(fragment,this.element);}).bind(this));}});Insertion.Top=Class.create();Insertion.Top.prototype=Object.extend(new Abstract.Insertion('afterBegin'),{initializeRange:function(){this.range.selectNodeContents(this.element);this.range.collapse(true);},insertContent:function(fragments){fragments.reverse(false).each((function(fragment){this.element.insertBefore(fragment,this.element.firstChild);}).bind(this));}});Insertion.Bottom=Class.create();Insertion.Bottom.prototype=Object.extend(new Abstract.Insertion('beforeEnd'),{initializeRange:function(){this.range.selectNodeContents(this.element);this.range.collapse(this.element);},insertContent:function(fragments){fragments.each((function(fragment){this.element.appendChild(fragment);}).bind(this));}});Insertion.After=Class.create();Insertion.After.prototype=Object.extend(new Abstract.Insertion('afterEnd'),{initializeRange:function(){this.range.setStartAfter(this.element);},insertContent:function(fragments){fragments.each((function(fragment){this.element.parentNode.insertBefore(fragment,this.element.nextSibling);}).bind(this));}});Element.ClassNames=Class.create();Element.ClassNames.prototype={initialize:function(element){this.element=$MediCom(element);},_each:function(iterator){this.element.className.split(/\s+/).select(function(name){return name.length>0;})._each(iterator);},set:function(className){this.element.className=className;},add:function(classNameToAdd){if(this.include(classNameToAdd))return;this.set($MediComA(this).concat(classNameToAdd).join(' '));},remove:function(classNameToRemove){if(!this.include(classNameToRemove))return;this.set($MediComA(this).without(classNameToRemove).join(' '));},toString:function(){return $MediComA(this).join(' ');}};Object.extend(Element.ClassNames.prototype,Enumerable);var Selector=Class.create();Selector.prototype={initialize:function(expression){this.expression=expression.strip();this.compileMatcher();},compileMatcher:function(){if(Prototype.BrowserFeatures.XPath&&!(/\[[\w-]*?:/).test(this.expression))
return this.compileXPathMatcher();var e=this.expression,ps=Selector.patterns,h=Selector.handlers,c=Selector.criteria,le,p,m;if(Selector._cache[e]){this.matcher=Selector._cache[e];return;}
this.matcher=["this.matcher = function(root) {","var r = root, h = Selector.handlers, c = false, n;"];while(e&&le!=e&&(/\S/).test(e)){le=e;for(var i in ps){p=ps[i];if(m=e.match(p)){this.matcher.push(typeof c[i]=='function'?c[i](m):new Template(c[i]).evaluate(m));e=e.replace(m[0],'');break;}}}
this.matcher.push("return h.unique(n);\n}");eval(this.matcher.join('\n'));Selector._cache[this.expression]=this.matcher;},compileXPathMatcher:function(){var e=this.expression,ps=Selector.patterns,x=Selector.xpath,le,m;if(Selector._cache[e]){this.xpath=Selector._cache[e];return;}
this.matcher=['.//*'];while(e&&le!=e&&(/\S/).test(e)){le=e;for(var i in ps){if(m=e.match(ps[i])){this.matcher.push(typeof x[i]=='function'?x[i](m):new Template(x[i]).evaluate(m));e=e.replace(m[0],'');break;}}}
this.xpath=this.matcher.join('');Selector._cache[this.expression]=this.xpath;},findElements:function(root){root=root||document;if(this.xpath)return document._getElementsByXPath(this.xpath,root);return this.matcher(root);},match:function(element){return this.findElements(document).include(element);},toString:function(){return this.expression;},inspect:function(){return"#<Selector:"+this.expression.inspect()+">";}};

Object.extend(Selector, {
  _cache: {},
  xpath: {
    descendant:   "//*",
    child:        "/*",
    adjacent:     "/following-sibling::*[1]",
    laterSibling: '/following-sibling::*',
    tagName:      function(m) {
      if (m[1] == '*') return '';
      return "[local-name()='" + m[1].toLowerCase() +
             "' or local-name()='" + m[1].toUpperCase() + "']";
    },
    className:    "[contains(concat(' ', @class, ' '), ' #{1} ')]",
    id:           "[@id='#{1}']",
    attrPresence: "[@#{1}]",
    attr: function(m) {
      m[3] = m[5] || m[6];
      return new Template(Selector.xpath.operators[m[2]]).evaluate(m);
    },
    pseudo: function(m) {
      var h = Selector.xpath.pseudos[m[1]];
      if (!h) return '';
      if (typeof h === 'function') return h(m);
      return new Template(Selector.xpath.pseudos[m[1]]).evaluate(m);
    },
    operators: {
      '=':  "[@#{1}='#{3}']",
      '!=': "[@#{1}!='#{3}']",
      '^=': "[starts-with(@#{1}, '#{3}')]",
      '$=': "[substring(@#{1}, (string-length(@#{1}) - string-length('#{3}') + 1))='#{3}']",
      '*=': "[contains(@#{1}, '#{3}')]",
      '~=': "[contains(concat(' ', @#{1}, ' '), ' #{3} ')]",
      '|=': "[contains(concat('-', @#{1}, '-'), '-#{3}-')]"
    },
    pseudos: {
      'first-child': '[not(preceding-sibling::*)]',
      'last-child':  '[not(following-sibling::*)]',
      'only-child':  '[not(preceding-sibling::* or following-sibling::*)]',
      'empty':       "[count(*) = 0 and (count(text()) = 0 or translate(text(), ' \t\r\n', '') = '')]",
      'checked':     "[@checked]",
      'disabled':    "[@disabled]",
      'enabled':     "[not(@disabled)]",
      'not': function(m) {
        var e = m[6], p = Selector.patterns,
            x = Selector.xpath, le, m, v;

        var exclusion = [];
        while (e && le != e && (/\S/).test(e)) {
          le = e;
          for (var i in p) {
            if (m = e.match(p[i])) {
              v = typeof x[i] == 'function' ? x[i](m) : new Template(x[i]).evaluate(m);
              exclusion.push("(" + v.substring(1, v.length - 1) + ")");
              e = e.replace(m[0], '');
              break;
            }
          }
        }
        return "[not(" + exclusion.join(" and ") + ")]";
      },
      'nth-child':      function(m) {
        return Selector.xpath.pseudos.nth("(count(./preceding-sibling::*) + 1) ", m);
      },
      'nth-last-child': function(m) {
        return Selector.xpath.pseudos.nth("(count(./following-sibling::*) + 1) ", m);
      },
      'nth-of-type':    function(m) {
        return Selector.xpath.pseudos.nth("position() ", m);
      },
      'nth-last-of-type': function(m) {
        return Selector.xpath.pseudos.nth("(last() + 1 - position()) ", m);
      },
      'first-of-type':  function(m) {
        m[6] = "1"; return Selector.xpath.pseudos['nth-of-type'](m);
      },
      'last-of-type':   function(m) {
        m[6] = "1"; return Selector.xpath.pseudos['nth-last-of-type'](m);
      },
      'only-of-type':   function(m) {
        var p = Selector.xpath.pseudos; return p['first-of-type'](m) + p['last-of-type'](m);
      },
      nth: function(fragment, m) {
        var mm, formula = m[6], predicate;
        if (formula == 'even') formula = '2n+0';
        if (formula == 'odd')  formula = '2n+1';
        if (mm = formula.match(/^(\d+)$/)) // digit only
          return '[' + fragment + "= " + mm[1] + ']';
        if (mm = formula.match(/^(-?\d*)?n(([+-])(\d+))?/)) { // an+b
          if (mm[1] == "-") mm[1] = -1;
          var a = mm[1] ? Number(mm[1]) : 1;
          var b = mm[2] ? Number(mm[2]) : 0;
          predicate = "[((#{fragment} - #{b}) mod #{a} = 0) and " +
          "((#{fragment} - #{b}) div #{a} >= 0)]";
          return new Template(predicate).evaluate({
            fragment: fragment, a: a, b: b });
        }
      }
    }
  },
  criteria: {
    tagName:      'n = h.tagName(n, r, "#{1}", c);   c = false;',
    className:    'n = h.className(n, r, "#{1}", c); c = false;',
    id:           'n = h.id(n, r, "#{1}", c);        c = false;',
    attrPresence: 'n = h.attrPresence(n, r, "#{1}"); c = false;',
    attr: function(m) {
      m[3] = (m[5] || m[6]);
      return new Template('n = h.attr(n, r, "#{1}", "#{3}", "#{2}"); c = false;').evaluate(m);
    },
    pseudo:       function(m) {
      if (m[6]) m[6] = m[6].replace(/"/g, '\\"');
      return new Template('n = h.pseudo(n, "#{1}", "#{6}", r, c); c = false;').evaluate(m);
    },
    descendant:   'c = "descendant";',
    child:        'c = "child";',
    adjacent:     'c = "adjacent";',
    laterSibling: 'c = "laterSibling";'
  },
  patterns: {
    // combinators must be listed first
    // (and descendant needs to be last combinator)
    laterSibling: /^\s*~\s*/,
    child:        /^\s*>\s*/,
    adjacent:     /^\s*\+\s*/,
    descendant:   /^\s/,

    // selectors follow
    tagName:      /^\s*(\*|[\w\-]+)(\b|$)?/,
    id:           /^#([\w\-\*]+)(\b|$)/,
    className:    /^\.([\w\-\*]+)(\b|$)/,
    pseudo:       /^:((first|last|nth|nth-last|only)(-child|-of-type)|empty|checked|(en|dis)abled|not)(\((.*?)\))?(\b|$|\s|(?=:))/,
    attrPresence: /^\[([\w]+)\]/,
    attr:         /\[((?:[\w-]*:)?[\w-]+)\s*(?:([!^$*~|]?=)\s*((['"])([^\]]*?)\4|([^'"][^\]]*?)))?\]/
  },
  		handlers:{concat:function(a,b){for(var i=0,node;node=b[i];i++)
a.push(node);return a;},mark:function(nodes){for(var i=0,node;node=nodes[i];i++)
node._counted=true;return nodes;},unmark:function(nodes){for(var i=0,node;node=nodes[i];i++)
node._counted=undefined;return nodes;},index:function(parentNode,reverse,ofType){parentNode._counted=true;if(reverse){for(var nodes=parentNode.childNodes,i=nodes.length-1,j=1;i>=0;i--){node=nodes[i];if(node.nodeType==1&&(!ofType||node._counted))node.nodeIndex=j++;}}else{for(var i=0,j=1,nodes=parentNode.childNodes;node=nodes[i];i++)
if(node.nodeType==1&&(!ofType||node._counted))node.nodeIndex=j++;}},unique:function(nodes){if(nodes.length==0)return nodes;var results=[],n;for(var i=0,l=nodes.length;i<l;i++)
if(!(n=nodes[i])._counted){n._counted=true;results.push(Element.extend(n));}
return Selector.handlers.unmark(results);},descendant:function(nodes){var h=Selector.handlers;for(var i=0,results=[],node;node=nodes[i];i++)
h.concat(results,node.getElementsByTagName('*'));return results;},child:function(nodes){var h=Selector.handlers;for(var i=0,results=[],node;node=nodes[i];i++){for(var j=0,children=[],child;child=node.childNodes[j];j++)
if(child.nodeType==1&&child.tagName!='!')results.push(child);}
return results;},adjacent:function(nodes){for(var i=0,results=[],node;node=nodes[i];i++){var next=this.nextElementSibling(node);if(next)results.push(next);}
return results;},laterSibling:function(nodes){var h=Selector.handlers;for(var i=0,results=[],node;node=nodes[i];i++)
h.concat(results,Element.nextSiblings(node));return results;},nextElementSibling:function(node){while(node=node.nextSibling)
if(node.nodeType==1)return node;return null;},previousElementSibling:function(node){while(node=node.previousSibling)
if(node.nodeType==1)return node;return null;},tagName:function(nodes,root,tagName,combinator){tagName=tagName.toUpperCase();var results=[],h=Selector.handlers;if(nodes){if(combinator){if(combinator=="descendant"){for(var i=0,node;node=nodes[i];i++)
h.concat(results,node.getElementsByTagName(tagName));return results;}else nodes=this[combinator](nodes);if(tagName=="*")return nodes;}
for(var i=0,node;node=nodes[i];i++)
if(node.tagName.toUpperCase()==tagName)results.push(node);return results;}else return root.getElementsByTagName(tagName);},id:function(nodes,root,id,combinator){var targetNode=$MediCom(id),h=Selector.handlers;if(!nodes&&root==document)return targetNode?[targetNode]:[];if(nodes){if(combinator){if(combinator=='child'){for(var i=0,node;node=nodes[i];i++)
if(targetNode.parentNode==node)return[targetNode];}else if(combinator=='descendant'){for(var i=0,node;node=nodes[i];i++)
if(Element.descendantOf(targetNode,node))return[targetNode];}else if(combinator=='adjacent'){for(var i=0,node;node=nodes[i];i++)
if(Selector.handlers.previousElementSibling(targetNode)==node)
return[targetNode];}else nodes=h[combinator](nodes);}
for(var i=0,node;node=nodes[i];i++)
if(node==targetNode)return[targetNode];return[];}
return(targetNode&&Element.descendantOf(targetNode,root))?[targetNode]:[];},className:function(nodes,root,className,combinator){if(nodes&&combinator)nodes=this[combinator](nodes);return Selector.handlers.byClassName(nodes,root,className);},byClassName:function(nodes,root,className){if(!nodes)nodes=Selector.handlers.descendant([root]);var needle=' '+className+' ';for(var i=0,results=[],node,nodeClassName;node=nodes[i];i++){nodeClassName=node.className;if(nodeClassName.length==0)continue;if(nodeClassName==className||(' '+nodeClassName+' ').include(needle))
results.push(node);}
return results;},attrPresence:function(nodes,root,attr){var results=[];for(var i=0,node;node=nodes[i];i++)
if(Element.hasAttribute(node,attr))results.push(node);return results;},attr:function(nodes,root,attr,value,operator){if(!nodes)nodes=root.getElementsByTagName("*");var handler=Selector.operators[operator],results=[];for(var i=0,node;node=nodes[i];i++){var nodeValue=Element.readAttribute(node,attr);if(nodeValue===null)continue;if(handler(nodeValue,value))results.push(node);}
return results;},pseudo:function(nodes,name,value,root,combinator){if(nodes&&combinator)nodes=this[combinator](nodes);if(!nodes)nodes=root.getElementsByTagName("*");return Selector.pseudos[name](nodes,value,root);}},pseudos:{'first-child':function(nodes,value,root){for(var i=0,results=[],node;node=nodes[i];i++){if(Selector.handlers.previousElementSibling(node))continue;results.push(node);}
return results;},'last-child':function(nodes,value,root){for(var i=0,results=[],node;node=nodes[i];i++){if(Selector.handlers.nextElementSibling(node))continue;results.push(node);}
return results;},'only-child':function(nodes,value,root){var h=Selector.handlers;for(var i=0,results=[],node;node=nodes[i];i++)
if(!h.previousElementSibling(node)&&!h.nextElementSibling(node))
results.push(node);return results;},'nth-child':function(nodes,formula,root){return Selector.pseudos.nth(nodes,formula,root);},'nth-last-child':function(nodes,formula,root){return Selector.pseudos.nth(nodes,formula,root,true);},'nth-of-type':function(nodes,formula,root){return Selector.pseudos.nth(nodes,formula,root,false,true);},'nth-last-of-type':function(nodes,formula,root){return Selector.pseudos.nth(nodes,formula,root,true,true);},'first-of-type':function(nodes,formula,root){return Selector.pseudos.nth(nodes,"1",root,false,true);},'last-of-type':function(nodes,formula,root){return Selector.pseudos.nth(nodes,"1",root,true,true);},'only-of-type':function(nodes,formula,root){var p=Selector.pseudos;return p['last-of-type'](p['first-of-type'](nodes,formula,root),formula,root);},getIndices:function(a,b,total){if(a==0)return b>0?[b]:[];return $R(1,total).inject([],function(memo,i){if(0==(i-b)%a&&(i-b)/a>=0)memo.push(i);return memo;});},nth:function(nodes,formula,root,reverse,ofType){if(nodes.length==0)return[];if(formula=='even')formula='2n+0';if(formula=='odd')formula='2n+1';var h=Selector.handlers,results=[],indexed=[],m;h.mark(nodes);for(var i=0,node;node=nodes[i];i++){if(!node.parentNode._counted){h.index(node.parentNode,reverse,ofType);indexed.push(node.parentNode);}}
if(formula.match(/^\d+$/)){formula=Number(formula);for(var i=0,node;node=nodes[i];i++)
if(node.nodeIndex==formula)results.push(node);}else if(m=formula.match(/^(-?\d*)?n(([+-])(\d+))?/)){if(m[1]=="-")m[1]=-1;var a=m[1]?Number(m[1]):1;var b=m[2]?Number(m[2]):0;var indices=Selector.pseudos.getIndices(a,b,nodes.length);for(var i=0,node,l=indices.length;node=nodes[i];i++){for(var j=0;j<l;j++)
if(node.nodeIndex==indices[j])results.push(node);}}
h.unmark(nodes);h.unmark(indexed);return results;},'empty':function(nodes,value,root){for(var i=0,results=[],node;node=nodes[i];i++){if(node.tagName=='!'||(node.firstChild&&!node.innerHTML.match(/^\s*$/)))continue;results.push(node);}
return results;},'not':function(nodes,selector,root){var h=Selector.handlers,selectorType,m;var exclusions=new Selector(selector).findElements(root);h.mark(exclusions);for(var i=0,results=[],node;node=nodes[i];i++)
if(!node._counted)results.push(node);h.unmark(exclusions);return results;},'enabled':function(nodes,value,root){for(var i=0,results=[],node;node=nodes[i];i++)
if(!node.disabled)results.push(node);return results;},'disabled':function(nodes,value,root){for(var i=0,results=[],node;node=nodes[i];i++)
if(node.disabled)results.push(node);return results;},'checked':function(nodes,value,root){for(var i=0,results=[],node;node=nodes[i];i++)
if(node.checked)results.push(node);return results;}},operators:{'=':function(nv,v){return nv==v;},'!=':function(nv,v){return nv!=v;},'^=':function(nv,v){return nv.startsWith(v);},'$=':function(nv,v){return nv.endsWith(v);},'*=':function(nv,v){return nv.include(v);},'~=':function(nv,v){return(' '+nv+' ').include(' '+v+' ');},'|=':function(nv,v){return('-'+nv.toUpperCase()+'-').include('-'+v.toUpperCase()+'-');}},matchElements:function(elements,expression){var matches=new Selector(expression).findElements(),h=Selector.handlers;h.mark(matches);for(var i=0,results=[],element;element=elements[i];i++)
if(element._counted)results.push(element);h.unmark(matches);return results;},findElement:function(elements,expression,index){if(typeof expression=='number'){index=expression;expression=false;}
return Selector.matchElements(elements,expression||'*')[index||0];},findChildElements:function(element,expressions){var exprs=expressions.join(','),expressions=[];exprs.scan(/(([\w#:.~>+()\s-]+|\*|\[.*?\])+)\s*(,|$)/,function(m){expressions.push(m[1].strip());});var results=[],h=Selector.handlers;for(var i=0,l=expressions.length,selector;i<l;i++){selector=new Selector(expressions[i].strip());h.concat(results,selector.findElements(element));}
return(l>1)?h.unique(results):results;}});function $$MediCom(){return Selector.findChildElements(document,$MediComA(arguments));}
var Form={reset:function(form){$MediCom(form).reset();return form;},serializeElements:function(elements,getHash){var data=elements.inject({},function(result,element){if(!element.disabled&&element.name){var key=element.name,value=$MediCom(element).getValue();if(value!=null){if(key in result){if(result[key].constructor!=Array)result[key]=[result[key]];result[key].push(value);}
else result[key]=value;}}
return result;});return getHash?data:Hash.toQueryString(data);}};Form.Methods={serialize:function(form,getHash){return Form.serializeElements(Form.getElements(form),getHash);},getElements:function(form){return $MediComA($MediCom(form).getElementsByTagName('*')).inject([],function(elements,child){if(Form.Element.Serializers[child.tagName.toLowerCase()])
elements.push(Element.extend(child));return elements;});},getInputs:function(form,typeName,name){form=$MediCom(form);var inputs=form.getElementsByTagName('input');if(!typeName&&!name)return $MediComA(inputs).map(Element.extend);for(var i=0,matchingInputs=[],length=inputs.length;i<length;i++){var input=inputs[i];if((typeName&&input.type!=typeName)||(name&&input.name!=name))
continue;matchingInputs.push(Element.extend(input));}
return matchingInputs;},disable:function(form){form=$MediCom(form);Form.getElements(form).invoke('disable');return form;},enable:function(form){form=$MediCom(form);Form.getElements(form).invoke('enable');return form;},findFirstElement:function(form){return $MediCom(form).getElements().find(function(element){return element.type!='hidden'&&!element.disabled&&['input','select','textarea'].include(element.tagName.toLowerCase());});},focusFirstElement:function(form){form=$MediCom(form);form.findFirstElement().activate();return form;},request:function(form,options){form=$MediCom(form),options=Object.clone(options||{});var params=options.parameters;options.parameters=form.serialize(true);if(params){if(typeof params=='string')params=params.toQueryParams();Object.extend(options.parameters,params);}
if(form.hasAttribute('method')&&!options.method)
options.method=form.method;return new Ajax.Request(form.readAttribute('action'),options);}}
Form.Element={focus:function(element){$MediCom(element).focus();return element;},select:function(element){$MediCom(element).select();return element;}}
Form.Element.Methods={serialize:function(element){element=$MediCom(element);if(!element.disabled&&element.name){var value=element.getValue();if(value!=undefined){var pair={};pair[element.name]=value;return Hash.toQueryString(pair);}}
return'';},getValue:function(element){element=$MediCom(element);if(element==null)return'';var method=element.tagName.toLowerCase();return Form.Element.Serializers[method](element);},clear:function(element){$MediCom(element).value='';return element;},present:function(element){return $MediCom(element).value!='';},activate:function(element){element=$MediCom(element);try{element.focus();if(element.select&&(element.tagName.toLowerCase()!='input'||!['button','reset','submit'].include(element.type)))
element.select();}catch(e){}
return element;},disable:function(element){element=$MediCom(element);element.blur();element.disabled=true;return element;},enable:function(element){element=$MediCom(element);element.disabled=false;return element;}}
var Field=Form.Element;var $F=Form.Element.Methods.getValue;Form.Element.Serializers={input:function(element){switch(element.type.toLowerCase()){case'checkbox':case'radio':return Form.Element.Serializers.inputSelector(element);default:return Form.Element.Serializers.textarea(element);}},inputSelector:function(element){return element.checked?element.value:null;},textarea:function(element){return element.value;},select:function(element){return this[element.type=='select-one'?'selectOne':'selectMany'](element);},selectOne:function(element){var index=element.selectedIndex;return index>=0?this.optionValue(element.options[index]):null;},selectMany:function(element){var values,length=element.length;if(!length)return null;for(var i=0,values=[];i<length;i++){var opt=element.options[i];if(opt.selected)values.push(this.optionValue(opt));}
return values;},optionValue:function(opt){return Element.extend(opt).hasAttribute('value')?opt.value:opt.text;}}
Abstract.TimedObserver=function(){}
Abstract.TimedObserver.prototype={initialize:function(element,frequency,callback){this.frequency=frequency;this.element=$MediCom(element);this.callback=callback;this.lastValue=this.getValue();this.registerCallback();},registerCallback:function(){setInterval(this.onTimerEvent.bind(this),this.frequency*1000);},onTimerEvent:function(){var value=this.getValue();var changed=('string'==typeof this.lastValue&&'string'==typeof value?this.lastValue!=value:String(this.lastValue)!=String(value));if(changed){this.callback(this.element,value);this.lastValue=value;}}}
Form.Element.Observer=Class.create();Form.Element.Observer.prototype=Object.extend(new Abstract.TimedObserver(),{getValue:function(){return Form.Element.getValue(this.element);}});Form.Observer=Class.create();Form.Observer.prototype=Object.extend(new Abstract.TimedObserver(),{getValue:function(){return Form.serialize(this.element);}});Abstract.EventObserver=function(){}
Abstract.EventObserver.prototype={initialize:function(element,callback){this.element=$MediCom(element);this.callback=callback;this.lastValue=this.getValue();if(this.element.tagName.toLowerCase()=='form')
this.registerFormCallbacks();else
this.registerCallback(this.element);},onElementEvent:function(){var value=this.getValue();if(this.lastValue!=value){this.callback(this.element,value);this.lastValue=value;}},registerFormCallbacks:function(){Form.getElements(this.element).each(this.registerCallback.bind(this));},registerCallback:function(element){if(element.type){switch(element.type.toLowerCase()){case'checkbox':case'radio':Event.observe(element,'click',this.onElementEvent.bind(this));break;default:Event.observe(element,'change',this.onElementEvent.bind(this));break;}}}}
Form.Element.EventObserver=Class.create();Form.Element.EventObserver.prototype=Object.extend(new Abstract.EventObserver(),{getValue:function(){return Form.Element.getValue(this.element);}});Form.EventObserver=Class.create();Form.EventObserver.prototype=Object.extend(new Abstract.EventObserver(),{getValue:function(){return Form.serialize(this.element);}});if(!window.Event){var Event=new Object();}


Object.extend(Event,{KEY_BACKSPACE:8,KEY_TAB:9,KEY_RETURN:13,KEY_ESC:27,KEY_LEFT:37,KEY_UP:38,KEY_RIGHT:39,KEY_DOWN:40,KEY_DELETE:46,KEY_HOME:36,KEY_END:35,KEY_PAGEUP:33,KEY_PAGEDOWN:34,element:function(event){return $MediCom(event.target||event.srcElement);},isLeftClick:function(event){return(((event.which)&&(event.which==1))||((event.button)&&(event.button==1)));},pointerX:function(event){return event.pageX||(event.clientX+
(document.documentElement.scrollLeft||document.body.scrollLeft));},pointerY:function(event){return event.pageY||(event.clientY+
(document.documentElement.scrollTop||document.body.scrollTop));},stop:function(event){if(event.preventDefault){event.preventDefault();event.stopPropagation();}else{event.returnValue=false;event.cancelBubble=true;}},findElement:function(event,tagName){var element=Event.element(event);while(element.parentNode&&(!element.tagName||(element.tagName.toUpperCase()!=tagName.toUpperCase())))
element=element.parentNode;return element;},observers:false,_observeAndCache:function(element,name,observer,useCapture){if(!this.observers)this.observers=[];if(element.addEventListener){this.observers.push([element,name,observer,useCapture]);element.addEventListener(name,observer,useCapture);}else if(element.attachEvent){this.observers.push([element,name,observer,useCapture]);element.attachEvent('on'+name,observer);}},unloadCache:function(){if(!Event.observers)return;for(var i=0,length=Event.observers.length;i<length;i++){Event.stopObserving.apply(this,Event.observers[i]);Event.observers[i][0]=null;}
Event.observers=false;},observe:function(element,name,observer,useCapture){element=$MediCom(element);useCapture=useCapture||false;if(name=='keypress'&&(Prototype.Browser.WebKit||element.attachEvent))

name='keydown';Event._observeAndCache(element,name,observer,useCapture);},observeParam:function(element,name,observer,useCapture,Param){element=$MediCom(element);useCapture=useCapture||false;if(name=='keypress'&&(Prototype.Browser.WebKit||element.attachEvent))
name='keydown';Event._observeAndCacheParam(element,name,observer,useCapture,Param);},_observeAndCacheParam:function(element,name,observer,useCapture,Param)
{var eventHandler=observer;if(Param!=null)
{eventHandler=function(e)
{observer.call(Param,e);}}


if(!this.observers)this.observers=[];if(element.addEventListener)
{this.observers.push([element,name,eventHandler,useCapture]);element.addEventListener(name,eventHandler,useCapture);}
else if(element.attachEvent)
{this.observers.push([element,name,eventHandler,useCapture]);element.attachEvent('on'+name,eventHandler);}},stopObserving:function(element,name,observer,useCapture){element=$MediCom(element);useCapture=useCapture||false;if(name=='keypress'&&(Prototype.Browser.WebKit||element.attachEvent))
name='keydown';if(element.removeEventListener){element.removeEventListener(name,observer,useCapture);}else if(element.detachEvent){try{element.detachEvent('on'+name,observer);}catch(e){}}}});if(Prototype.Browser.IE)
	
Event.observe(window,'unload',Event.unloadCache,false);var Position={includeScrollOffsets:false,prepare:function(){this.deltaX=window.pageXOffset||document.documentElement.scrollLeft||document.body.scrollLeft||0;this.deltaY=window.pageYOffset||document.documentElement.scrollTop||document.body.scrollTop||0;},realOffset:function(element){var valueT=0,valueL=0;do{valueT+=element.scrollTop||0;valueL+=element.scrollLeft||0;element=element.parentNode;}while(element);return[valueL,valueT];},cumulativeOffset:function(element){var valueT=0,valueL=0;do{valueT+=element.offsetTop||0;valueL+=element.offsetLeft||0;element=element.offsetParent;}while(element);return[valueL,valueT];},positionedOffset:function(element){var valueT=0,valueL=0;do{valueT+=element.offsetTop||0;valueL+=element.offsetLeft||0;element=element.offsetParent;if(element){if(element.tagName=='BODY')break;var p=Element.getStyle(element,'position');if(p=='relative'||p=='absolute')break;}}while(element);return[valueL,valueT];},offsetParent:function(element){if(element.offsetParent)return element.offsetParent;if(element==document.body)return element;while((element=element.parentNode)&&element!=document.body)
if(Element.getStyle(element,'position')!='static')
return element;return document.body;},within:function(element,x,y){if(this.includeScrollOffsets)
return this.withinIncludingScrolloffsets(element,x,y);this.xcomp=x;this.ycomp=y;this.offset=this.cumulativeOffset(element);return(y>=this.offset[1]&&y<this.offset[1]+element.offsetHeight&&x>=this.offset[0]&&x<this.offset[0]+element.offsetWidth);},withinIncludingScrolloffsets:function(element,x,y){var offsetcache=this.realOffset(element);this.xcomp=x+offsetcache[0]-this.deltaX;this.ycomp=y+offsetcache[1]-this.deltaY;this.offset=this.cumulativeOffset(element);return(this.ycomp>=this.offset[1]&&this.ycomp<this.offset[1]+element.offsetHeight&&this.xcomp>=this.offset[0]&&this.xcomp<this.offset[0]+element.offsetWidth);},overlap:function(mode,element){if(!mode)return 0;if(mode=='vertical')
return((this.offset[1]+element.offsetHeight)-this.ycomp)/element.offsetHeight;if(mode=='horizontal')
return((this.offset[0]+element.offsetWidth)-this.xcomp)/element.offsetWidth;},page:function(forElement){var valueT=0,valueL=0;var element=forElement;do{valueT+=element.offsetTop||0;valueL+=element.offsetLeft||0;if(element.offsetParent==document.body)
if(Element.getStyle(element,'position')=='absolute')break;}while(element=element.offsetParent);element=forElement;do{if(!window.opera||element.tagName=='BODY'){valueT-=element.scrollTop||0;valueL-=element.scrollLeft||0;}}while(element=element.parentNode);return[valueL,valueT];},clone:function(source,target){var options=Object.extend({setLeft:true,setTop:true,setWidth:true,setHeight:true,offsetTop:0,offsetLeft:0},arguments[2]||{})
source=$MediCom(source);var p=Position.page(source);target=$MediCom(target);var delta=[0,0];var parent=null;if(Element.getStyle(target,'position')=='absolute'){parent=Position.offsetParent(target);delta=Position.page(parent);}
if(parent==document.body){delta[0]-=document.body.offsetLeft;delta[1]-=document.body.offsetTop;}
if(options.setLeft)target.style.left=(p[0]-delta[0]+options.offsetLeft)+'px';if(options.setTop)target.style.top=(p[1]-delta[1]+options.offsetTop)+'px';if(options.setWidth)target.style.width=source.offsetWidth+'px';if(options.setHeight)target.style.height=source.offsetHeight+'px';},absolutize:function(element){element=$MediCom(element);if(element.style.position=='absolute')return;Position.prepare();var offsets=Position.positionedOffset(element);var top=offsets[1];var left=offsets[0];var width=element.clientWidth;var height=element.clientHeight;element._originalLeft=left-parseFloat(element.style.left||0);element._originalTop=top-parseFloat(element.style.top||0);element._originalWidth=element.style.width;element._originalHeight=element.style.height;element.style.position='absolute';element.style.top=top+'px';element.style.left=left+'px';element.style.width=width+'px';element.style.height=height+'px';},relativize:function(element){element=$MediCom(element);if(element.style.position=='relative')return;Position.prepare();element.style.position='relative';var top=parseFloat(element.style.top||0)-(element._originalTop||0);var left=parseFloat(element.style.left||0)-(element._originalLeft||0);element.style.top=top+'px';element.style.left=left+'px';element.style.height=element._originalHeight;element.style.width=element._originalWidth;}}
if(Prototype.Browser.WebKit){Position.cumulativeOffset=function(element){var valueT=0,valueL=0;do{valueT+=element.offsetTop||0;valueL+=element.offsetLeft||0;if(element.offsetParent==document.body)
if(Element.getStyle(element,'position')=='absolute')break;element=element.offsetParent;}while(element);return[valueL,valueT];}}
Element.addMethods();

String.prototype.trim=function(){return this.replace(/^[\s]+|[\s]+$/g,"");}
function MC_webserviceJscript(nameSpace,serverUrl,charset){var _this=this;this.nameSpace=nameSpace;this.serverUrl=serverUrl;this.charset=charset;this.params=[];this.is_pParams=false;this.AddParam=function(key,value){if(this.params==null){this.params=[];}
value=encodeURIComponent(value);this.params[this.params.length]={"key":key,"value":value};}
this.AddQuery=function(qstr){var arr=qstr.split('&');for(var i=0;i<arr.length;i++){var str=arr[i];var _kv=str.split('=');var key=_kv[0];var value="";if(_kv.length>1){value=_kv[1];}
this.AddParam(key.trim(),value.trim());}}
this.ClearParam=function(){this.params.length=0;}
this.post=function(methodStr,callback){return this.__fetchData(methodStr,"POST",callback);}
this.get=function(methodStr,callback){return this.__fetchData(methodStr,"GET",callback);}
this.postsoap=function(methodStr,callback){return this.__fetchData(methodStr,"POST_SOAP",callback);}
this.__fetchData=function(methodStr,httpMethod,callback){var _charset=this.charset;if(_charset==null||_charset==""){_charset="utf-8";}
var xmlhttp=this.createXMLHttpRequest();var data;if(httpMethod=="POST_SOAP"){data='<?xml version="1.0" encoding="utf-8"?>';data=data+'<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">';data=data+'<soap:Body>';data=data+'<'+methodStr+' xmlns="'+this.nameSpace+'">';if(this.is_pParams){data=data+"<pParams>";}
if(this.params!=null&&this.params.length>0){for(var i=0;i<this.params.length;i++){data=data+'<'+this.params[i].key+'>'+this.params[i].value+'</'+this.params[i].key+'>';}}
if(this.is_pParams){data=data+"</pParams>";}
data=data+'</'+methodStr+'>';data=data+'</soap:Body>';data=data+'</soap:Envelope>';}
else if(httpMethod=="GET"||httpMethod=="POST"){var _d_arr=[];if(this.params!=null&&this.params.length>0){for(var i=0;i<this.params.length;i++){_d_arr[_d_arr.length]=this.params[i].key+"="+this.params[i].value;}}
data=_d_arr.join("&");}
var isXdomain=false;try{isXdomain=(xmlhttp.constructor.toString().indexOf("XDomainRequest")!=-1);}catch(ex){}
if(callback!=null){xmlhttp.onreadystatechange=function(){if(xmlhttp.readyState==4){if(xmlhttp.status==200){var xmldoc=_this.loadXMLString(xmlhttp.responseText);var rstr=xmldoc.documentElement.text;if(rstr==undefined){rstr=xmldoc.documentElement.textContent;}
callback({error:false,value:rstr});}
else{callback({error:true,value:rstr,errmore:xmlhttp.status});}}}
if(isXdomain){xmlhttp.onload=function(){callback(xmlhttp.responseText);}
xmlhttp.onerror=function(){callback('xdr err');}}}
var isAsyn=true;if(callback==null)isAsyn=false;if(httpMethod=="POST"){xmlhttp.open("POST",this.serverUrl+"/"+methodStr,isAsyn);}else if(httpMethod=="GET"){xmlhttp.open(httpMethod,this.serverUrl+"/"+methodStr+"?"+data,isAsyn);}else if(httpMethod=="POST_SOAP"){xmlhttp.open("POST",this.serverUrl,isAsyn);}
if(!isXdomain){if(httpMethod=="POST_SOAP"){if(this.nameSpace!=""&&methodStr!=""){xmlhttp.setRequestHeader("SOAPAction",this.nameSpace+methodStr);}}else if(httpMethod=="POST"){xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded; charset="+_charset);}else{xmlhttp.setRequestHeader("Content-Type","text/xml; charset="+_charset);}}
if(httpMethod=="POST"||httpMethod=="POST_SOAP"){xmlhttp.send(data);}
else{xmlhttp.send(null);}
if(callback==null){if(xmlhttp.status==200){var xmldoc=_this.loadXMLString(xmlhttp.responseText);var rstr=xmldoc.documentElement.text;if(rstr==undefined){rstr=xmldoc.documentElement.textContent;}
return{error:false,value:rstr};}
else{return{error:true,value:rstr,errmore:xmlhttp.status};}}
return"";}}
MC_webserviceJscript.prototype.createXMLHttpRequest=function(){var xmlhttp;if(window.ActiveXObject){var ieArr=["MSXML2.XmlHttp","Microsoft.XMLHTTP"];for(var i=0;i<ieArr.length;i++){xmlhttp=new ActiveXObject(ieArr[i]);}}
else if(window.XMLHttpRequest){xmlhttp=new XMLHttpRequest();xmlhttp.withCredentials="true";if(xmlhttp.readyState==null){xmlhttp.readyState=0;xmlhttp.addEventListener("load",function(){xmlhttp.readyState=4;if(typeof(xmlhttp.onreadystatechange)=="function"){xmlhttp.onreadystatechange();}},false);}}
else if(window.XDomainRequest){xmlhttp=new XDomainRequest();}
return xmlhttp;}
MC_webserviceJscript.prototype.strToJson=function(str){return new Function("return "+str)();}
MC_webserviceJscript.prototype.loadXMLString=function(txt){try{var xmlDoc=new ActiveXObject("Microsoft.XMLDOM");xmlDoc.async=false;xmlDoc.loadXML(txt);return(xmlDoc);}
catch(e){try{var parser=new DOMParser();var xmlDoc=parser.parseFromString(txt,"text/xml");return(xmlDoc);}
catch(e){return(null);}}}
﻿
this.Params_GetDrugQueryInfo_In=function(){this.Birthay="";this.DrugCode="";this.DrugName="";this.DrugType="USER_Drug";this.DoseUnit="";this.RouteID="";this.RouteDesc="";this.RouteType="USER";this.DoseTypeID="";this.MedCondCode="";this.VocabTypeCode="";this.MedCondDesc="";this.MedCondType="";this.QueryType=-1;}
this.Params_Patient_In=function(){this.PatID="";this.PatName="";this.Sex="";this.Birth="";this.UseTime="";this.Height="";this.Weight="";this.VisitID="";this.Department="";this.Doctor="";this.InTime="";this.OutTime="";this.WorkStationType="22";this.DoctorCode="";this.DepartmentCode="";}
this.Params_Allergen_In=function(){this.Index="";this.AllergenCode="";this.AllergenDesc="";this.AllergenType="";this.Reaction="";}
this.Params_MedCond_In=function(){this.Index="";this.MedCondCode="";this.MedCondDesc="";this.MedCondType="";this.VocabTypeCode="";this.StartDate="";this.StopDate="";}
this.Params_Recipe_In=function(){this.Index="";this.DrugCode="";this.DrugName="";this.DrugType="USER_Drug";this.DoseForm="";this.Strength="";this.StrengthUnit="";this.SingleDose="";this.DoseUnit="";this.StartDate="";this.EndDate="";this.Frequency="";this.Duration="";this.RouteID="";this.RouteDesc="";this.RouteType="USER";this.DoseTypeID="";this.MedCondCode="";this.MedCondDesc="";this.VocabTypeCode="";this.MedCondType="";this.GroupTag="";this.WarningTag="";this.IsTemporary="";this.DoctorCode="";this.Doctor="";}
﻿
var McErrorMsg1="<FONT color=#ff0000>非常抱歉，服务器异常，请刷新页面后再试！</FONT>";var McQueryInitError="<FONT color=#ff0000>非常抱歉，启动PASS 查询服务异常！</FONT>";var McCheckInitError="<FONT color=#ff0000>非常抱歉，启动PASS 审查服务异常！</FONT>";MC_CHARSET="utf-8";MC_NAMESPASE="http://www.medicom.com.cn/";IsInitDllSuc=0;IsInitCheckDllSuc=0;SelectedRowIndex=-1;SelectedID="";function MC_client_request(types){var url;if(types==1){url=WebServiceUrl+"/PassCheckService.asmx";}
else{url=WebServiceUrl+"/PassQueryService.asmx";}
var requestObj=new MC_webserviceJscript(MC_NAMESPASE,url,MC_CHARSET);return requestObj;}
this.WebServiceInit2=function(){this.InitDll();}
this.McInitNum=1;this.InitDll=function(){if(IsInitDllSuc!="1"){try{var client=new MC_client_request(0);client.ClearParam();client.AddParam("psUserInfo","administrator");client.AddParam("pWorkStationType",11);client.get("MDC_Init",InitDllCallBack);}
catch(ex){if(this.McInitNum<5){this.McInitNum++;setTimeout("InitDll",200);}
else{alert("非常遗憾，查询服务初始化异常，请稍后再试！\n-----------------\n"+ex.description);}}}}
function InitDllCallBack(result){if(result.value=="1")
IsInitDllSuc="1";}
this.WebServiceInitCheck=function(){this.InitCheckDll();}
this.McInitCheckNum=1;this.InitCheckDll=function(){if(IsInitCheckDllSuc!="1"){try{var client=new MC_client_request(1);client.ClearParam();client.AddParam("psUserInfo","administrator");client.AddParam("pWorkStationType",11);client.get("MDC_Init",InitCheckDllCallBack);}
catch(ex){if(this.McInitCheckNum<5){this.McInitCheckNum++;setTimeout("InitCheckDll",200);}
else{alert("非常遗憾，审查服务初始化异常，请稍后再试！\n-----------------\n"+ex.description);}}}}
function InitCheckDllCallBack(result){if(result.value=="1")
IsInitCheckDllSuc="1";}
function CheckWebServiceIsEnable(msg){if(IsInitDllSuc==1)
return true;else
return false;}
function CheckWebServiceIsEnable_Check(msg){if(IsInitCheckDllSuc==1)
return true;else
return false;}
function CreateIframe(id,Container,scr){var div1=document.createElement("div");div1.innerHTML="<iframe class=\"MyIframe\" id=\""+id+"\"  name=\""+id+"\" frameborder=\"0\" scrolling=\"auto\" src=\"\"></iframe>";Container.appendChild(div1);}
function GetModelByRowIndex(rowIndex){McShowDebugInfo(IsDebugDrugQueryInfoModel,$MediComH(McDrugQueryInfoModel).toJSON(),DebugShowPanel_DrugQueryInfoModel);return McDrugQueryInfoModel;}
function ShowLoadingInfo(strList,showLoadInfo){if(showLoadInfo.length==0)
showLoadInfo="<img src=\"Image/loadingGIF2.gif\"/>&nbsp;&nbsp;数据加载中……";$MediCom(strList).innerHTML=showLoadInfo;}
function McBackErrInfoToUser(controlID,resultStr,baseErrInfo){var errMsg="";if(resultStr.length<50){if(resultStr.indexOf("EXP:")==0){errMsg=McErrorMsg1;}
if(resultStr.indexOf("[ERROR]")==0){errMsg=McErrorMsg1;}
if(resultStr.length<20){errMsg="非常遗憾，未能找到相应的“"+baseErrInfo+"”信息！";}}
if(errMsg.length>5){var c=$MediCom(controlID);if(c!=null)
c.innerHTML=errMsg;else
alert(errMsg);return false;}
else{return true;}}
function McShowBackErrInfoToUser(controlID,baseErrInfo){var errMsg="非常遗憾，未能找到相应的“"+baseErrInfo+"”信息！";var c=$MediCom(controlID);if(c!=null)
c.innerHTML=errMsg;else
alert(errMsg);}
function McBackErrInfoToUser2(controlID,resultStr,allErrInfo){var errMsg="";if(resultStr.length<50){if(resultStr.indexOf("EXP:")==0){errMsg=McErrorMsg1;}
if(resultStr.length<10){errMsg=allErrInfo;}}
if(errMsg.length>5){var c=$MediCom(controlID);if(c!=null)
c.innerHTML=errMsg;else
alert(errMsg);return false;}
else{return true;}}
function OpenOrCloseMcPanel(id,baseName){var label=$MediCom("moreInfo"+baseName+"Label_"+id);var showPanel=$MediCom("ShowMoreInfo"+baseName+"Panel_"+id);if(showPanel.className=="showPanel_Show")
{showPanel.className="showPanel_Hide";label.innerText="详细信息[+]";label.className="label_Hide";}
else if(showPanel.className=="showPanel_Hide")
{showPanel.className="showPanel_Show";label.innerText="详细信息[-]";label.className="label_Show";}}
this.StringBuilder=function(){var tmp=new Array();this.Append=function(value){tmp[tmp.length]=value;return this;}
this.Clear=function(){tmp.length=1;}
this.toString=function(){return tmp.join('');}}
function McShowDebugInfo(isShowDebug,debugInfo,debugPanel){if(isShowDebug){if(debugPanel.length>0){var panel=$MediCom(debugPanel);if(panel!=null){panel.innerHTML=debugInfo;}
else{alert("调试信息载体“"+debugPanel+"”未找到\n\n"+debugInfo);}}
else{alert(debugInfo);}}}
var x0=0,y0=0,x1=0,y1=0;var offx=6,offy=6;var moveable=false;var hover='#00CCCC',normal='#0099cc';var index=10000;function startDrag(obj){if(event.button==1){obj.setCapture();var win=obj.parentNode;var sha=win.nextSibling;x0=event.clientX;y0=event.clientY;if(win.style.left!="")
x1=parseInt(win.style.left);if(win.style.top!="")
y1=parseInt(win.style.top);normal=obj.style.backgroundColor;obj.style.backgroundColor=hover;win.style.borderColor=hover;moveable=true;}}
function drag(obj){if(moveable){var win=obj.parentNode;var sha=win.nextSibling;sha.style.left=(x1-x0+event.clientX)+"px";sha.style.top=(y1-y0+event.clientY)+"px";if(parseInt(sha.style.left.replace("px",""))<=0){sha.style.left="0px";}
else if(parseInt(sha.style.left.replace("px",""))>=(parseInt(document.body.clientWidth)-parseInt(sha.style.width))){sha.style.left=(parseInt(document.body.clientWidth)-parseInt(sha.style.width))+"px";}
if(parseInt(sha.style.top.replace("px",""))<=0){sha.style.top="0px";}
win.style.left=sha.style.left;win.style.top=sha.style.top;}}
function stopDrag(obj){if(moveable){var win=obj.parentNode;var sha=win.nextSibling;var msg=obj.nextSibling;win.style.borderColor=normal;obj.style.backgroundColor=normal;if(parseInt(sha.style.left.replace("px",""))<=0){sha.style.left="0px";}
else if(parseInt(sha.style.left.replace("px",""))>=(parseInt(document.body.clientWidth)-parseInt(sha.style.width))){sha.style.left=(parseInt(document.body.clientWidth)-parseInt(sha.style.width))+"px";}
if(parseInt(sha.style.top.replace("px",""))<=0){sha.style.top="0px";}
win.style.left=sha.style.left;win.style.top=sha.style.top;obj.releaseCapture();moveable=false;}}
function getFocus(obj){if(obj.style.zIndex!=index){index=index+2;var idx=index;obj.style.zIndex=idx;obj.nextSibling.style.zIndex=idx-1;}}
function min(obj){var win=obj.parentNode.parentNode;var sha=win.nextSibling;var tit=obj.parentNode;var msg=tit.nextSibling;var flg=msg.style.display=="none";if(flg){win.style.height=(parseInt(msg.style.height)+22)+"px";sha.style.height=win.style.height;msg.style.display="block";obj.innerHTML="0";}
else{win.style.height="20px";sha.style.height="20px";obj.innerHTML="2";msg.style.display="none";}}
function ShowHideNew(id,dis){if(dis=="close"){if(document.getElementById(id)){document.body.removeChild(document.getElementById(id));document.body.removeChild(document.getElementById(id+"bg"));}}
else{var bdisplay=(dis==null)?((document.getElementById(id).style.display=="")?"none":""):dis;document.getElementById(id).style.display=bdisplay;document.getElementById(id+"bg").style.display=bdisplay;}}
this.PassPopWindowNew=function(){this.Title="";this.W=MC_WindowWidth;this.H=MC_WindowHeight;this.mainID="PassMain";this.mainClassName="PanelMain";this.headID="PassHead";this.headClassName="PanelHead";this.bodyID="PassBody";this.bodyClassName="PanelBody";index=index+2;this.id=this.mainID;this.width=MC_WindowWidth
this.height=MC_WindowHeight;var offsetWidth=document.documentElement.offsetWidth;var offsetHeight=document.documentElement.offsetHeight;var scrollLeft=document.documentElement.scrollLeft;var scrollTop=document.documentElement.scrollTop;if(offsetWidth==0)
offsetWidth=document.body.offsetWidth;if(offsetHeight==0)
offsetHeight=document.body.offsetHeight;if(scrollLeft==0)
scrollLeft=document.body.scrollLeft;if(scrollTop==0)
scrollTop=document.body.scrollTop;this.left=(offsetWidth-this.width)/2+scrollLeft;this.top=(offsetHeight-this.height)/2+scrollTop;if(this.left<0)
this.left=0;if(this.top<0)
this.top=0;this.zIndex=index;this.message="";this.obj=null;var win;this.CreatePanel=function(){if(document.getElementById(this.mainID))
{document.body.removeChild(document.getElementById(this.mainID));document.body.removeChild(document.getElementById(this.mainID+"bg"));}
var str=""
+"<div id="+this.mainID+" "
+"style='"
+"z-index:"+this.zIndex+";"
+"width:"+this.width+"px;"
+"height:"+this.height+"px;"
+"left:"+this.left+"px;"
+"top:"+this.top+"px;"
+"background-color:"+normal+";"
+"font-size:8pt;"
+"font-family:Tahoma;"
+"position:absolute;"
+"cursor:default;"
+"border:1px solid "+normal+";"
+"' "
+"onmousedown='getFocus(this)'>"
+"<div id="+this.headID+" "
+"style='"
+"background-color:"+normal+";"
+"width:"+(this.width-2)+"px;"
+"height:20px;"
+"color:white;"
+"' "
+"onmousedown='startDrag(this)' "
+"onmouseup='stopDrag(this)' "
+"onmousemove='drag(this)' "
+"ondblclick='min(this.childNodes[1])'"
+">"
+"<div style='width:"+(this.width-36)+"px;padding-left:2px;float:left;cursor:move;margin-top:3px'><img src=\"Image/PASS.gif\" height=12 width=32/>&nbsp;&nbsp;"+this.Title+"</div>"
+"<div style='width:12px;border-width:0px;color:white;font-family:webdings;cursor:default;float:left;' onclick='min(this)'>0</div>"
+"<div style='width:12px;border-width:0px;color:white;font-family:webdings;cursor:default;float:left;' onclick='ShowHideNew(\""
+this.mainID+"\",\"close\");'>r</div>"
+"</div>"
+"<div id="+this.bodyID+" "
+"style='"
+"width:"+(this.width-2)+"px;"
+"height:"+(this.height-22)+"px;"
+"overflow-y:scroll;"
+"background-color:white;"
+"line-height:14px;"
+"word-break:break-all;"
+"padding:1px;'>"
+this.message+"</div>"
+"</div>"
+"<div id="+this.mainID+"bg "
+"style='"
+"width:"+this.width+"px;"
+"height:"+this.height+"px;"
+"top:"+this.top+"px;"
+"left:"+this.left+"px;"
+"z-index:"+(this.zIndex-1)+";"
+"position:absolute;"
+"background-color:black;"
+"filter:alpha(opacity=40);"
+"'><iframe class='mc_iframe_bg'></iframe></div>";document.body.insertAdjacentHTML("beforeEnd",str);ShowHideNew(this.mainID,"none");}
this.MyDestroy=function(){ShowHideNew(this.mainID,"close");}}
var McDrugQueryInfoModel;var McPatientModel;var McRecipeDataList=new Array();var McAllergenDataList=new Array();var McMedCondDataList=new Array();function GetModelByRowIndexInRecipeCheck(identityCode)
{for(var i=0;i<McRecipeDataList.length;i++)
{if(McRecipeDataList[i].Index==identityCode)
{var dqi=new Params_GetDrugQueryInfo_In();dqi.DrugCode=McRecipeDataList[i].DrugCode;dqi.DrugName=McRecipeDataList[i].DrugName;dqi.DrugType=McRecipeDataList[i].DrugType;dqi.DoseUnit=McRecipeDataList[i].DoseUnit;dqi.RouteID=McRecipeDataList[i].RouteID;dqi.RouteDesc=McRecipeDataList[i].RouteDesc;dqi.RouteType=McRecipeDataList[i].RouteType;dqi.DoseTypeID=McRecipeDataList[i].DoseTypeID;dqi.MedCondCode=McRecipeDataList[i].MedCondCode;dqi.VocabTypeCode=McRecipeDataList[i].VocabTypeCode;dqi.MedCondDesc="";dqi.MedCondType=McRecipeDataList[i].MedCondType;return dqi;}}}
﻿
var ManualCompanyCount=0;var ManualDoseFormCount=0;var ManualItemCount=0;var ManualData;function ShowArticle(id)
{GetDirect(id);}
function ShowRefInfo(RefID)
{if(RefID==1)
{}}
function SelectRBtn(id,itemID)
{document.getElementsByName("rbtnSource")[id].checked="checked";if(id==0)
{CreateCompanyDDL(itemID);var selectedCompanyID=document.getElementsByName("sltCompany")[0].value;CreateDoseFormListByCompanyID(selectedCompanyID);}
if(id==1)
{CreateDoseFormDDL(itemID);var selectedDoseFormID=document.getElementsByName("sltDoseForm")[0].value;CreateCompanyListByDoseFormID(selectedDoseFormID);}}
function CreateCompanyDDL(id)
{var strSelected="";var sb=new StringBuilder();sb.Append("<select name=\"sltCompany\" onChange=\"CreateDoseFormListByCompanyID(this.value);\">");for(var i=0;i<ManualCompanyCount;i++)
{if(ManualData.Companys[i].ID==id)
strSelected=" selected=\"selected\" ";else
strSelected="";sb.Append("<option value=\"");sb.Append(ManualData.Companys[i].ID);sb.Append("\" ");sb.Append(strSelected);sb.Append(">");sb.Append(ManualData.Companys[i].Name);sb.Append("</option>");}
sb.Append("</select>");$MediCom("ddlSource").innerHTML=sb.toString();}
function CreateDoseFormDDL(id)
{var strSelected="";var sb=new StringBuilder();sb.Append("<select name=\"sltDoseForm\"  onChange=\"CreateCompanyListByDoseFormID(this.value);\">");for(var i=0;i<ManualDoseFormCount;i++)
{if(ManualData.DoseForms[i].ID==id)
strSelected=" selected=\"selected\" ";else
strSelected="";sb.Append("<option value=\"");sb.Append(ManualData.DoseForms[i].ID);sb.Append("\" ");sb.Append(strSelected);sb.Append(">");sb.Append(ManualData.DoseForms[i].Name);sb.Append("</option>");}
sb.Append("</select>");$MediCom("ddlSource").innerHTML=sb.toString();}
function ArraySort(arr)
{return arr.sort(function(a,b){return a-b;});}
this.ManualTempDllShowItems=function()
{this.ID=-1;this.ArticleID=-1;this.ShowName="";}
function GetOptionStrByID(ArrList,id)
{var count=ArrList.length;for(var i=0;i<count;i++)
{if(ArrList[i].ID==id)
{return"<option value=\""+ArrList[i].ArticleID+"\">"+ArrList[i].ShowName+"</option>";}}}
function CreateDoseFormListByCompanyID(id)
{var sb=new StringBuilder();sb.Append("<select name=\"sltDoseForm\"  onChange=\"ShowArticle(this.value);\">");var tempArr=new Array();var tempIDArr=new Array();var mtdsi;for(var j=0;j<ManualItemCount;j++)
{if(ManualData.Items[j].CompanyID==id)
{mtdsi=new ManualTempDllShowItems();mtdsi.ID=ManualData.Items[j].DoseFormID;mtdsi.ArticleID=ManualData.Items[j].DirectNo;mtdsi.ShowName=GetTNameByTID(ManualData.Items[j].DoseFormID);tempArr[tempArr.length]=mtdsi;tempIDArr[tempIDArr.length]=ManualData.Items[j].DoseFormID;}}
var tempIDArrOK=ArraySort(tempIDArr);var count=tempIDArrOK.length;for(var x=0;x<count;x++)
{sb.Append(GetOptionStrByID(tempArr,tempIDArrOK[x]));}
$MediCom("ddlShow").innerHTML=sb.toString();ShowArticle(document.getElementsByName("sltDoseForm")[0].value);}
function CreateCompanyListByDoseFormID(id)
{var sb=new StringBuilder();sb.Append("<select name=\"sltCompany\" onChange=\"ShowArticle(this.value);\">");var tempArr=new Array();var tempIDArr=new Array();var mtdsi;for(var j=0;j<ManualItemCount;j++)
{if(ManualData.Items[j].DoseFormID==id)
{mtdsi=new ManualTempDllShowItems();mtdsi.ID=ManualData.Items[j].CompanyID;mtdsi.ArticleID=ManualData.Items[j].DirectNo;mtdsi.ShowName=GetFNameByFID(ManualData.Items[j].CompanyID);tempArr[tempArr.length]=mtdsi;tempIDArr[tempIDArr.length]=ManualData.Items[j].CompanyID;}}
var tempIDArrOK=ArraySort(tempIDArr);var count=tempIDArrOK.length;for(var x=0;x<count;x++)
{sb.Append(GetOptionStrByID(tempArr,tempIDArrOK[x]));}
$MediCom("ddlShow").innerHTML=sb.toString();ShowArticle(document.getElementsByName("sltCompany")[0].value);}
function GetFNameByFID(id)
{for(var i=0;i<ManualCompanyCount;i++)
{if(ManualData.Companys[i].ID==id)
{return ManualData.Companys[i].Name;}}}
function GetTNameByTID(id)
{for(var i=0;i<ManualDoseFormCount;i++)
{if(ManualData.DoseForms[i].ID==id)
{return ManualData.DoseForms[i].Name;}}}
function CreateManualPanel()
{ppw=new PassPopWindowNew();ppw.Title="药品说明书";ppw.mainID="ManualMain";ppw.headID="ManualHead";ppw.bodyID="ManualBody";ppw.CreatePanel();var divManualMenu=document.createElement("div");var divManualContent=document.createElement("div");divManualMenu.id="ManualMenuPanel";divManualMenu.className="ManualMenu";var divOper=document.createElement("div");divOper.id="McManualMenuOperPanel";divOper.style.display="none";var divloading=document.createElement("div");divloading.id="McManualloadingDiv";var rbtnStr="<div id=\"divRadioBtn\" class=\"ManualDll\" style=\"float:left;\"><label><input name=\"rbtnSource\" type=\"radio\" onClick=\"SelectRBtn(this.value,-1);\" value=\"0\">来源</label><label><input type=\"radio\" name=\"rbtnSource\" onClick=\"SelectRBtn(this.value,-1);\" value=\"1\" />剂型\</label></div>";var dllStr="<div id=\"ddlSource\" class='ManualDll' style=\"float:left;\"></div> <div id=\"ddlShow\" class='ManualDll' style=\"float:left;\"></div>";divOper.innerHTML=rbtnStr+dllStr;divManualMenu.appendChild(divloading);divManualMenu.appendChild(divOper);divManualContent.id="McManualloadingDiv";divManualContent.className="ManualContent";$MediCom(divManualContent).style.height="470";CreateIframe("ifr_Manual_Div",divManualContent,"/IframeLoading.htm");$MediCom(ppw.bodyID).appendChild(divManualMenu);$MediCom(ppw.bodyID).appendChild(divManualContent);ShowLoadingInfo("McManualloadingDiv","");ShowHideNew(ppw.mainID,null);}
function GetDirect(DirectNo)
{if(CheckWebServiceIsEnable("GetDirect"))
{var client=new MC_client_request(0);client.ClearParam();client.AddParam("pDirectNo",DirectNo);client.AddParam("pSearchText","");client.post("MDC_GetDirectionForHTML",articleUrlCallBack);}
else
{ShowLoadingInfo("ManualMenuPanel",McQueryInitError);}}
function articleUrlCallBack(result)
{if(!result.error)
{McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);document.all.ifr_Manual_Div.src=WebServiceUrl+"/"+result.value;}}
function GetManualData(dqi)
{dqi.QueryType=31;if(CheckWebServiceIsEnable("GetManualData"))
{var client=new MC_client_request(0);client.ClearParam();client.AddParam("psDrugQueryJSONStr",$MediComH(dqi).toJSON());client.post("MDC_GetDrugQueryInfo",ShowListInPanelCallBack);}
else
{ShowLoadingInfo("ManualMenuPanel",McQueryInitError);}}
function ShowListInPanelCallBack(result)
{if(!result.error)
{McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="药品说明书";var showErrControlId="ManualMenuPanel";if(!McBackErrInfoToUser(showErrControlId,result.value,errMsg))
{return;}
$MediCom("McManualloadingDiv").style.display="none";$MediCom("McManualMenuOperPanel").style.display="block";var f=new Function("ManualData ="+result.value);f();var SourceType=ManualData.SourceType;var DefualtID=ManualData.DefualtID;ManualCompanyCount=ManualData.Companys.length;ManualDoseFormCount=ManualData.DoseForms.length;ManualItemCount=ManualData.Items.length;if(ManualItemCount>0)
{if(SourceType==0)
DefualtID=0;SelectRBtn(SourceType,DefualtID);ShowRefInfo(ManualData.IsRef);}
else
{McShowBackErrInfoToUser(showErrControlId,errMsg);return;}}}
function FuncDirections()
{CreateManualPanel();GetManualData(GetModelByRowIndex(SelectedRowIndex));}
function CreateManualPanelUser()
{ppw=new PassPopWindowNew();ppw.Title="医院药品说明书";ppw.mainID="ManualMainUser";ppw.headID="ManualHeadUser";ppw.bodyID="ManualBodyUser";ppw.CreatePanel();var divManualMenuUser=document.createElement("div");divManualMenuUser.id="ManualMenuPanelUser";divManualMenuUser.className="ManualMenu";var divManualContentUser=document.createElement("div");divManualContentUser.id="divManualContentPanelUser";divManualContentUser.className="ManualContent";var divloadingUser=document.createElement("div");divloadingUser.id="McManualloadingDivUser";divManualContentUser.appendChild(divloadingUser);CreateIframe("ifr_Manual_DivUser",divManualContentUser,"/IframeLoading.htm");$MediCom(ppw.bodyID).appendChild(divManualMenuUser);$MediCom(ppw.bodyID).appendChild(divManualContentUser);$MediCom(divManualMenuUser).style.height="50";$MediCom(divManualContentUser).style.height="470";ShowLoadingInfo("McManualloadingDivUser","");ShowHideNew(ppw.mainID,null);}
function GetManualDataUser(dqi)
{dqi.QueryType=99;if(CheckWebServiceIsEnable("GetManualData"))
{var client=new MC_client_request(0);client.ClearParam();client.AddParam("psDrugQueryJSONStr",$MediComH(dqi).toJSON());client.post("MDC_GetDrugQueryInfo",ShowListInPanelUserCallBack);}
else
{ShowLoadingInfo("ManualMenuPanelUser",McQueryInitError);}}
function ShowListInPanelUserCallBack(result)
{if(result.value=="Null")
{ShowHideNew("ManualMainUser","close");FuncDirections();}
else if(!result.error)
{McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="药品说明书";var showErrControlId="ManualMenuPanelUser";if(!McBackErrInfoToUser(showErrControlId,result.value,errMsg))
{return;}
$MediCom("McManualloadingDivUser").style.display="none";var name=GetModelByRowIndex(SelectedRowIndex).DrugName;ManualMenuPanelUser.innerHTML+=" <div style='text-align: center'><strong><span style='font-size: 16pt'><br/>"+name+"</span></strong></div>";ManualMenuPanelUser.innerHTML+=" <div style='text-align:right;'><span class=\"McDdcmLinkLable\"  onclick='FuncDirections();'>查看PASS说明书</span></div><hr color='#dddddd' /> ";document.all.ifr_Manual_DivUser.src=WebServiceUrl+"/"+result.value;}}
function FuncDirectionsUser()
{CreateManualPanelUser();GetManualDataUser(GetModelByRowIndex(SelectedRowIndex));}
﻿
var McCpeData;var McCpeItemCount=0;function CreateCpePanel()
{ppw=new PassPopWindowNew();ppw.Title="病人用药教育";ppw.mainID="MC_RecipeCheck_Main";ppw.headID="MC_RecipeCheck_Head";ppw.bodyID="MC_RecipeCheck_Body";ppw.CreatePanel();var divCPEMenu=document.createElement("div");var divCPEContent=document.createElement("div");divCPEMenu.id="ddlMcCpe";divCPEMenu.className="McCpeMenu";divCPEContent.id="RecipeCheckContentPanel";divCPEContent.className="McCpeContent";$MediCom(divCPEContent).style.height="450";CreateIframe("ifr_CPE_Div",divCPEContent,"/IframeLoading.htm");$MediCom(ppw.bodyID).appendChild(divCPEMenu);$MediCom(ppw.bodyID).appendChild(divCPEContent);ShowLoadingInfo("ddlMcCpe","");ShowHideNew(ppw.mainID,null);}
function CreateCpeDDL()
{var sb=new StringBuilder();sb.Append("<select name=\"sltMcCpe\" onChange=\"GetCpeArticleData(this.value);\">");for(var i=0;i<McCpeItemCount;i++)
{sb.Append("<option value=\"");sb.Append(McCpeData.Items[i].CpeNo);sb.Append("\" >");sb.Append(McCpeData.Items[i].Title);sb.Append("</option>");}
sb.Append("</select>");$MediCom("ddlMcCpe").innerHTML=sb.toString();GetCpeArticleData(document.getElementsByName("sltMcCpe")[0].value);}
function GetCpeArticleData(pCpeNo)
{if(CheckWebServiceIsEnable("GetCpeArticleData"))
{var client=new MC_client_request(0);client.ClearParam();client.AddParam("pCpeNo",pCpeNo);client.AddParam("pSearchText","");client.post("MDC_GetCpeForHTML",CpeDataCallBack);}
else
{ShowLoadingInfo("ddlMcCpe",McQueryInitError);}}
function CpeDataCallBack(result)
{if(!result.error)
{McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);document.all.ifr_CPE_Div.src=WebServiceUrl+"/"+result.value;}}
function GetCpeListData(dqi)
{dqi.QueryType=25;if(CheckWebServiceIsEnable("GetCpeListData"))
{var client=new MC_client_request(0);client.ClearParam();client.AddParam("psDrugQueryJSONStr",$MediComH(dqi).toJSON());client.post("MDC_GetDrugQueryInfo",ShowCpeListCallBack);}
else
{ShowLoadingInfo("ddlMcCpe",McQueryInitError);}}
function ShowCpeListCallBack(result)
{if(!result.error)
{McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="病人用药教育";var showErrControlId="ddlMcCpe";if(!McBackErrInfoToUser(showErrControlId,result.value,errMsg))
{return;}
var f=new Function("McCpeData ="+result.value);f();McCpeItemCount=McCpeData.Items.length;if(McCpeItemCount>0)
{CreateCpeDDL();}
else
{McShowBackErrInfoToUser(showErrControlId,errMsg);return;}}}
function FuncCPERes()
{CreateCpePanel();GetCpeListData(GetModelByRowIndex(SelectedRowIndex));}
﻿
var McCprData;var McCprItemCount=0;function CreateCprPanel(){ppw=new PassPopWindowNew();ppw.Title="药物专论";ppw.mainID="MC_RecipeCheck_Main";ppw.headID="MC_RecipeCheck_Head";ppw.bodyID="MC_RecipeCheck_Body";ppw.CreatePanel();var divCPRMenu=document.createElement("div");var divCPRContent=document.createElement("div");divCPRMenu.id="ddlMcCpr";divCPRMenu.className="McCprMenu";divCPRContent.id="RecipeCheckContentPanel";divCPRContent.className="McCprContent";$MediCom(divCPRContent).style.height="450";CreateIframe("ifr_CPR_Div",divCPRContent,"/IframeLoading.htm");$MediCom(ppw.bodyID).appendChild(divCPRMenu);$MediCom(ppw.bodyID).appendChild(divCPRContent);ShowLoadingInfo("ddlMcCpr","");ShowHideNew(ppw.mainID,null);}
function CreateCprDDL(){var sb=new StringBuilder();sb.Append("<select name=\"sltMcCpr\" onChange=\"GetCprArticleData(this.value);\">");for(var i=0;i<McCprItemCount;i++){sb.Append("<option value=\"");sb.Append(McCprData.Items[i].CprNo);sb.Append("\" >");sb.Append(McCprData.Items[i].Title);sb.Append("</option>");}
sb.Append("</select>");$MediCom("ddlMcCpr").innerHTML=sb.toString();GetCprArticleData(document.getElementsByName("sltMcCpr")[0].value);}
function GetCprArticleData(pCprNo){if(CheckWebServiceIsEnable("GetCprArticleData")){var client=new MC_client_request(0);client.ClearParam();client.AddParam("pCprNo",pCprNo);client.AddParam("pSearchText","");client.post("MDC_GetCprForHTML",CprDataCallBack);}
else
{ShowLoadingInfo("ddlMcCpr",McQueryInitError);}}
function CprDataCallBack(result){if(!result.error){McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);document.all.ifr_CPR_Div.src=WebServiceUrl+"/"+result.value;}}
function GetCprListData(dqi){dqi.QueryType=20;if(CheckWebServiceIsEnable("GetCprListData"))
{var client=new MC_client_request(0);client.ClearParam();client.AddParam("psDrugQueryJSONStr",$MediComH(dqi).toJSON());client.post("MDC_GetDrugQueryInfo",ShowCprListCallBack);}
else
{ShowLoadingInfo("ddlMcCpr",McQueryInitError);}}
function ShowCprListCallBack(result){if(!result.error){McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="药物专论";var showErrControlId="ddlMcCpr";if(!McBackErrInfoToUser(showErrControlId,result.value,errMsg)){return;}
var f=new Function("McCprData ="+result.value);f();McCprItemCount=McCprData.Items.length;if(McCprItemCount>0){CreateCprDDL();}
else{McShowBackErrInfoToUser(showErrControlId,errMsg);return;}}}
function FuncCPRRes(){CreateCprPanel();GetCprListData(GetModelByRowIndex(SelectedRowIndex));}
﻿
var McChpData;var McChpItemCount=0;function CreateChpPanel(){var ppw=new PassPopWindowNew();ppw.Title="中华人民共和国药典";ppw.mainID="MC_CHP_Main";ppw.headID="MC_CHP_Head";ppw.bodyID="MC_CHP_Body";ppw.CreatePanel();var divCHPMenu=document.createElement("div");var divCHPContent=document.createElement("div");divCHPMenu.id="ddlMcChp";divCHPMenu.className="McChpMenu";divCHPContent.className="McChpContent";$MediCom(divCHPContent).style.height="450";CreateIframe("ifr_CHP_Div",divCHPContent,"/IframeLoading.htm");$MediCom(ppw.bodyID).appendChild(divCHPMenu);$MediCom(ppw.bodyID).appendChild(divCHPContent);ShowLoadingInfo("ddlMcChp","");ShowHideNew(ppw.mainID,null);}
function CreateChpDDL(){var sb=new StringBuilder();sb.Append("<select name=\"sltMcChp\" onChange=\"GetChpArticleData(this.value);\">");for(var i=0;i<McChpItemCount;i++){sb.Append("<option value=\"");sb.Append(McChpData.Items[i].ChpNo);sb.Append("\" >");sb.Append(McChpData.Items[i].Title);sb.Append("</option>");}
sb.Append("</select>");$MediCom("ddlMcChp").innerHTML=sb.toString();GetChpArticleData(document.getElementsByName("sltMcChp")[0].value);}
function GetChpArticleData(pChpNo){if(CheckWebServiceIsEnable("GetChpArticleData")){var client=new MC_client_request(0);client.ClearParam();client.AddParam("pChpNo",pChpNo);client.AddParam("pSearchText","");client.post("MDC_GetChpForHTML",ChpDataCallBack);}
else
{ShowLoadingInfo("McChpMenu",McQueryInitError);}}
function ChpDataCallBack(result){if(!result.error){McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);document.all.ifr_CHP_Div.src=WebServiceUrl+"/"+result.value;}}
function GetChpListData(dqi){dqi.QueryType=32;if(CheckWebServiceIsEnable("GetChpListData"))
{var client=new MC_client_request(0);client.ClearParam();client.AddParam("psDrugQueryJSONStr",$MediComH(dqi).toJSON());client.post("MDC_GetDrugQueryInfo",ShowChpListCallBack);}
else
{ShowLoadingInfo("McChpMenu",McQueryInitError);}}
function ShowChpListCallBack(result){if(!result.error){McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="中华人民共和国药典";var showErrControlId="ddlMcChp";if(!McBackErrInfoToUser(showErrControlId,result.value,errMsg)){return;}
var f=new Function("McChpData ="+result.value);f();McChpItemCount=McChpData.Items.length;if(McChpItemCount>0){CreateChpDDL();}
else{McShowBackErrInfoToUser(showErrControlId,errMsg);}}}
function FuncCHP(){CreateChpPanel();GetChpListData(GetModelByRowIndex(SelectedRowIndex));}
﻿
var McDdimData;var McDdimItemCount=0;function CreateDdimPanel(){var ppw=new PassPopWindowNew();ppw.Title="药物-药物相互作用查询信息";ppw.mainID="MC_DDIM_Main";ppw.headID="MC_DDIM_Head";ppw.bodyID="MC_DDIM_Body";ppw.CreatePanel();var divDDIMMenu=document.createElement("div");var divDDIMContent=document.createElement("div");divDDIMMenu.id="McDdimMenuPanel";divDDIMMenu.className="McDdimMenu";divDDIMContent.id="McDdimContentPanel";divDDIMContent.className="McDdimContent";$MediCom(ppw.bodyID).appendChild(divDDIMMenu);$MediCom(ppw.bodyID).appendChild(divDDIMContent);ShowLoadingInfo("McDdimMenuPanel","");ShowHideNew(ppw.mainID,null);}
function CreateDdimPanelInRecipeCheck(parentNode){var divDDIMMenu=document.createElement("div");var divDDIMContent=document.createElement("div");divDDIMMenu.className="McDdimMenu";divDDIMMenu.style.height="10px";divDDIMContent.id="McDdimContentPanel1";divDDIMContent.className="McDdimContent";$MediCom(parentNode).appendChild(divDDIMMenu);$MediCom(parentNode).appendChild(divDDIMContent);ShowLoadingInfo("McDdimContentPanel1","");}
function ShowDdimListCallBackInRecipeCheck(DataObj){McDdimData=DataObj;McDdimItemCount=McDdimData.Items.length;if(McDdimItemCount>0){CreateDdimList1();}}
function CreateDdimList1(){var sb=new StringBuilder();for(var i=0;i<McDdimItemCount;i++){sb.Append("<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"1\"><tr><td><div style=\"float:left;\">");sb.Append(i+1);sb.Append(".</div><div class=\"DdimRemark_");sb.Append(McDdimData.Items[i].WarningCode);sb.Append("\" /> </td><td colspan=\"2\">");sb.Append(McDdimData.Items[i].Title);sb.Append("</td></tr><tr><td width=\"40\">&nbsp;</td><td width=\"360\">所属类别：");sb.Append(McDdimData.Items[i].DrugClass);sb.Append("</td><td>严重程度：");sb.Append(McDdimData.Items[i].SLCodeDesc);sb.Append("</td></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td align=\"right\"><span id=\"1moreInfoDdimLabel_");sb.Append(i);sb.Append("\" onclick=\"OpenOrCloseDdim1(");sb.Append(i);sb.Append(", 'Ddim');\" class=\"label_Hide\" >详细信息[+]</span></td></tr><tr><td></td><td colspan=\"2\" > <span id=\"1ShowMoreInfoDdimPanel_");sb.Append(i);sb.Append("\" class=\"showPanel_Hide\"></span> </td></tr><tr><td colspan=\"3\" height=\"1\" bgcolor=\"#dcdcdc\"></td></tr></table>");}
$MediCom("McDdimContentPanel1").innerHTML=sb.toString();}
function CreateDdimList(){var sb=new StringBuilder();for(var i=0;i<McDdimItemCount;i++){sb.Append("<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"1\"><tr><td><div style=\"float:left;\">");sb.Append(i+1);sb.Append(".</div><div class=\"DdimRemark_");sb.Append(McDdimData.Items[i].WarningCode);sb.Append("\" /> </td><td colspan=\"2\">");sb.Append(McDdimData.Items[i].Title);sb.Append("</td></tr><tr><td width=\"40\">&nbsp;</td><td width=\"360\">所属类别：");sb.Append(McDdimData.Items[i].DrugClass);sb.Append("</td><td>严重程度：");sb.Append(McDdimData.Items[i].SLCodeDesc);sb.Append("</td></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td align=\"right\"><span id=\"moreInfoDdimLabel_");sb.Append(i);sb.Append("\" onclick=\"OpenOrCloseDdim(");sb.Append(i);sb.Append(", 'Ddim');\" class=\"label_Hide\" >详细信息[+]</span></td></tr><tr><td></td><td colspan=\"2\" > <span id=\"ShowMoreInfoDdimPanel_");sb.Append(i);sb.Append("\" class=\"showPanel_Hide\"></span> </td></tr><tr><td colspan=\"3\" height=\"1\" bgcolor=\"#dcdcdc\"></td></tr></table>");}
$MediCom("McDdimContentPanel").innerHTML=sb.toString();}
var SetDdimClickIndex=-1;function OpenOrCloseDdim(id,baseName){SetDdimClickIndex=id;var label=$MediCom("moreInfo"+baseName+"Label_"+id);var showPanel=$MediCom("ShowMoreInfo"+baseName+"Panel_"+id);if(showPanel.className=="showPanel_Show")
{showPanel.className="showPanel_Hide";label.innerText="详细信息[+]";label.className="label_Hide";}
else{if(showPanel.className=="showPanel_Hide")
{showPanel.className="showPanel_Show";label.innerText="详细信息[-]";label.className="label_Show";if(showPanel.innerHTML==McErrorMsg1||showPanel.innerHTML.length<100)
{GetDdimArticleData(id);}}}}
function OpenOrCloseDdim1(id,baseName){SetDdimClickIndex=id;var label=$MediCom("1moreInfo"+baseName+"Label_"+id);var showPanel=$MediCom("1ShowMoreInfo"+baseName+"Panel_"+id);if(showPanel.className=="showPanel_Show")
{showPanel.className="showPanel_Hide";label.innerText="详细信息[+]";label.className="label_Hide";}
else{if(showPanel.className=="showPanel_Hide")
{showPanel.className="showPanel_Show";label.innerText="详细信息[-]";label.className="label_Show";if(showPanel.innerHTML==McErrorMsg1||showPanel.innerHTML.length<100)
{GetDdimArticleData1(id);}}}}
function GetDdimArticleData(index){if(CheckWebServiceIsEnable("GetDdimArticleData")){var client=new MC_client_request(0);client.ClearParam();client.AddParam("piMonoID",McDdimData.Items[index].MonoID);client.AddParam("piDrugClass1",McDdimData.Items[index].DrugClass1);client.AddParam("piDrugClass2",McDdimData.Items[index].DrugClass2);client.post("MDC_GetDDIMMonograph",DdimDataCallBack);ShowLoadingInfo("ShowMoreInfoDdimPanel_"+index,"");}
else
{ShowLoadingInfo("McDdimMenuPanel",McQueryInitError);}}
function GetDdimArticleData1(index){if(CheckWebServiceIsEnable("GetDdimArticleData1")){var client=new MC_client_request(0);client.ClearParam();client.AddParam("piMonoID",McDdimData.Items[index].MonoID);client.AddParam("piDrugClass1",McDdimData.Items[index].DrugClass1);client.AddParam("piDrugClass2",McDdimData.Items[index].DrugClass2);client.post("MDC_GetDDIMMonograph",DdimDataCallBack1);ShowLoadingInfo("1ShowMoreInfoDdimPanel_"+index,"");}
else
{ShowLoadingInfo("McDdimMenuPanel",McQueryInitError);}}
function DdimDataCallBack(result){if(!result.error){McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="非常遗憾，未找到相关数据！";var showPanel=$MediCom("ShowMoreInfoDdimPanel_"+SetDdimClickIndex);if(!McBackErrInfoToUser2(showPanel,result.value,errMsg)){return;}
else{showPanel.innerHTML=CreateDdimMoreInfoStyle(result.value);}}}
function DdimDataCallBack1(result){if(!result.error){McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="非常遗憾，未找到相关数据！";var showPanel=$MediCom("1ShowMoreInfoDdimPanel_"+SetDdimClickIndex);if(!McBackErrInfoToUser2(showPanel,result.value,errMsg)){return;}
else{showPanel.innerHTML=CreateDdimMoreInfoStyle(result.value);}}}
function CreateDdimMoreInfoStyle(str){var f=new Function("MoreDdimInfoData ="+str);f();var sb=new StringBuilder();var count=MoreDdimInfoData.Items.length;for(var i=0;i<count;i++){if(i!=0)
sb.Append("<br>");sb.Append("【"+MoreDdimInfoData.Items[i].Desc+"】<BR>　　");sb.Append(MoreDdimInfoData.Items[i].Content);sb.Append("<br>");}
return sb.toString();}
function GetDdimListData(dqi){dqi.QueryType=1;if(CheckWebServiceIsEnable("GetDdimListData"))
{var client=new MC_client_request(0);client.ClearParam();client.AddParam("psDrugQueryJSONStr",$MediComH(dqi).toJSON());client.post("MDC_GetDrugQueryInfo",ShowDdimListCallBack);}
else
{ShowLoadingInfo("McDdimMenuPanel",McQueryInitError);}}
function ShowDdimListCallBack(result){if(!result.error){McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="药物-药物相互作用查询信息";var showErrControlId="McDdimMenuPanel";if(!McBackErrInfoToUser(showErrControlId,result.value,errMsg)){return;}
var f=new Function("McDdimData ="+result.value);f();McDdimItemCount=McDdimData.Items.length;ShowLoadingInfo("McDdimMenuPanel","共有"+McDdimItemCount+"条详细信息");if(McDdimItemCount>0){CreateDdimList();}
else{McShowBackErrInfoToUser(showErrControlId,errMsg);return;}}}
function FuncDDIM(){CreateDdimPanel();GetDdimListData(GetModelByRowIndex(SelectedRowIndex));}
﻿
var McDdcmData;var McDdcmItemCount=0;var McDdcmDataPostIn;var DdcmMoreInfoInRecipeCheckIndex=0;function CreateDdcmPanel()
{var ppw=new PassPopWindowNew();ppw.Title="药物禁忌详细信息";ppw.mainID="MC_DDCM_Main";ppw.headID="MC_DDCM_Head";ppw.bodyID="MC_DDCM_Body";ppw.CreatePanel();var divDDCMTitle=document.createElement("div");var divDDCMMenu=document.createElement("div");var divDDCMContent=document.createElement("div");divDDCMTitle.id="McDdcmTitlePanel";divDDCMTitle.className="McDdcmTitle";divDDCMMenu.id="McDdcmMenuPanel";divDDCMMenu.className="McDdcmMenu";divDDCMContent.id="McDdcmContentPanel";divDDCMContent.className="McDdcmContent";$MediCom(ppw.bodyID).appendChild(divDDCMTitle);$MediCom(ppw.bodyID).appendChild(divDDCMMenu);$MediCom(ppw.bodyID).appendChild(divDDCMContent);ShowLoadingInfo(divDDCMTitle,"");ShowHideNew(ppw.mainID,null);}
function ShowDdcmMoreInfoInRecipeCheck(index)
{DdcmMoreInfoInRecipeCheckIndex=index;CreateDdcmPanel();GetDdcmListData(GetModelByRowIndexInRecipeCheck(McDdcmDataPostIn.Items[index].UserDrugIndex));}
function CreateDdcmPanelInRecipeCheck(showPanel,dataObj)
{$MediCom(showPanel).appendChild(ShowRecipeCheckInfoToUser("警告：病人可能存在使用以下药品处方的禁忌症"));var sb=new StringBuilder();var count=dataObj.Items.length;if(count>0)
McDdcmDataPostIn=dataObj;for(var i=0;i<count;i++)
{sb.Append("<table width=\"100%\" border=\"0\" cellpadding=\"1\" cellspacing=\"1\"><tr><td width=\"40\"><div style=\"float:left;\">");sb.Append(i+1);sb.Append(".</div><div class=\"DdimRemark_");sb.Append(dataObj.Items[i].WarningCode);sb.Append("\" /></td><td colspan=\"2\">");sb.Append(dataObj.Items[i].Title);sb.Append("</td></tr><tr><td>&nbsp;</td><td width=\"300\">所属类别：");sb.Append(dataObj.Items[i].DrugClass);sb.Append("</td><td>严重程度：");sb.Append(dataObj.Items[i].SLCodeShortDesc);sb.Append("</td></tr><tr><td>&nbsp;</td><td>禁 忌 症：");sb.Append(dataObj.Items[i].DescriptionDisease);sb.Append("</td><td align=\"right\" ><span class=\"McDdcmLinkLable\" onclick=\"ShowDdcmMoreInfoInRecipeCheck('");sb.Append(i);sb.Append("');\">详细信息>>>&nbsp;</td></tr><tr><td height=\"1\" colspan=\"3\" bgcolor=\"#dddddd\"></td></tr></table>");}
var divDdcmContent=document.createElement("div");divDdcmContent.id="McRecipeCheckDdcmListPanel";divDdcmContent.className="McRecipeCheckDdcmListPanel";divDdcmContent.innerHTML=sb.toString();$MediCom(showPanel).appendChild(divDdcmContent);}
function GetDdcmListData(dqi)
{dqi.QueryType=10;if(CheckWebServiceIsEnable("GetDdcmListData"))
{var client=new MC_client_request(0);client.ClearParam();client.AddParam("psDrugQueryJSONStr",$MediComH(dqi).toJSON());client.post("MDC_GetDrugQueryInfo",ShowDdcmListCallBack);$MediCom("McDdcmTitlePanel").innerHTML=dqi.DrugName+"("+dqi.RouteDesc+")";}
else
{ShowLoadingInfo("McDdcmTitlePanel",McQueryInitError);}}
function ShowDdcmListCallBack(result)
{if(!result.error)
{McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="药物禁忌详细信息";var showErrControlId="McDdcmMenuPanel";if(!McBackErrInfoToUser(showErrControlId,result.value,errMsg))
{return;}
var f=new Function("McDdcmData ="+result.value);f();McDdcmItemCount=McDdcmData.Items.length;var showResultOK=false;for(var i=0;i<McDdcmItemCount;i++)
{if(McDdcmData.Items[i].Items.length>0)
{showResultOK=true;break;}}
if(showResultOK)
{ShowDdcmData();}
else
{McShowBackErrInfoToUser(showErrControlId,errMsg);return;}}}
function CreateDdcmRbtn()
{var sb=new StringBuilder();for(var i=0;i<McDdcmItemCount;i++)
{if(McDdcmData.Items[i].Items.length>0)
sb.Append("<label class=\"McDdcmMenuRBtn\"><input type=\"radio\" name=\"rbtnMcDdcm\" value=\"");sb.Append(McDdcmData.Items[i].Index+"\" onclick=\"rbtnMcDdcmClick(this.value);\" />");sb.Append(McDdcmData.Items[i].DescDrug+"</label>");}
$MediCom("McDdcmMenuPanel").innerHTML=sb.toString();}
function rbtnMcDdcmClick(index)
{ShowLoadingInfo("McDdcmContentPanel","");ShowCurrentDdcmTable(index);}
function ShowCurrentDdcmTable(index)
{var sb=new StringBuilder();sb.Append("  <table width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"1\" bgcolor=\"#dddddd\">  <tr><td align=\"center\" bgcolor=\"#eeeeee\" width=\"30\">编号</td><td align=\"center\" bgcolor=\"#eeeeee\" >禁忌症</td><td align=\"center\" bgcolor=\"#eeeeee\" width=\"80\">严重程度</td><td align=\"center\" bgcolor=\"#eeeeee\" width=\"200\">参考文献</td>  </tr>");var count=McDdcmData.Items[index].Items.length;for(var i=0;i<count;i++)
{sb.Append("<tr><td bgcolor=\"#ffffff\">");sb.Append(McDdcmData.Items[index].Items[i].index);sb.Append("</td><td bgcolor=\"#ffffff\">");sb.Append(McDdcmData.Items[index].Items[i].DescriptionDisease);sb.Append("</td><td bgcolor=\"#ffffff\">");sb.Append(McDdcmData.Items[index].Items[i].SLCodeShortDesc);sb.Append("</td><td bgcolor=\"#ffffff\">");sb.Append(McDdcmData.Items[index].Items[i].PageRef);sb.Append("</td></tr>");}
sb.Append("</table>");$MediCom("McDdcmContentPanel").innerHTML=sb.toString();}
function CreateRecipeCheckDdcmMoreinfoTitleTable(obj)
{var titleOld=$MediCom("McDdcmTitlePanel").innerHTML;var sb=new StringBuilder();sb.Append("<table width=\"100%\" border=\"0\" cellpadding=\"3\" cellspacing=\"0\"><tr><td width=\"50%\" align=\"left\"><b>处方药品：</b>"+titleOld+"</td><td width=\"50%\" align=\"left\"><b>病生状态：</b>"+obj.ConditionDescription+"</td></tr><tr><td align=\"left\">　－－药物类别：");sb.Append(obj.DrugClass);sb.Append("</td><td align=\"left\">　－－关联病症：");sb.Append(obj.DescriptionDisease);sb.Append("</td></tr><tr><td align=\"left\">　－－副 作 用：");sb.Append(obj.DescriptionDisease);sb.Append("</td><td>&nbsp;</td></tr><tr><td align=\"left\"><b>严重程度：</b>");sb.Append(obj.SLCodeShortDesc);sb.Append("</td><td>&nbsp;</td></tr></table>");return sb.toString();}
function ShowDdcmData()
{try
{if(McDdcmDataPostIn.Items[DdcmMoreInfoInRecipeCheckIndex].ConditionDescription!=undefined)
{$MediCom("McDdcmTitlePanel").innerHTML=CreateRecipeCheckDdcmMoreinfoTitleTable(McDdcmDataPostIn.Items[DdcmMoreInfoInRecipeCheckIndex]);}}
catch(e)
{}
CreateDdcmRbtn();document.getElementsByName("rbtnMcDdcm")[0].checked="checked";ShowCurrentDdcmTable(document.getElementsByName("rbtnMcDdcm")[0].value);}
function FuncDDCM()
{McDdcmDataPostIn=null;CreateDdcmPanel();GetDdcmListData(GetModelByRowIndex(SelectedRowIndex));}
﻿
var McSideData;var McSideItemCount=0;var McSideDataPostIn;var SideMoreInfoInRecipeCheckIndex=0;function CreateSidePanel()
{var ppw=new PassPopWindowNew();ppw.Title="不良反应详细信息";ppw.mainID="MC_SIDE_Main";ppw.headID="MC_SIDE_Head";ppw.bodyID="MC_SIDE_Body";ppw.CreatePanel();var divSIDETitle=document.createElement("div");var divSIDEMenu=document.createElement("div");var divSIDEContent=document.createElement("div");divSIDETitle.id="McSideTitlePanel";divSIDETitle.className="McSideTitle";divSIDEMenu.id="McSideMenuPanel";divSIDEMenu.className="McSideMenu";divSIDEContent.id="McSideContentPanel";divSIDEContent.className="McSideContent";$MediCom(ppw.bodyID).appendChild(divSIDETitle);$MediCom(ppw.bodyID).appendChild(divSIDEMenu);$MediCom(ppw.bodyID).appendChild(divSIDEContent);ShowLoadingInfo(divSIDEMenu,"");ShowHideNew(ppw.mainID,null);}
function ShowSideMoreInfoInRecipeCheck(i)
{SideMoreInfoInRecipeCheckIndex=i;CreateSidePanel();GetSideListData(GetModelByRowIndexInRecipeCheck(McSideDataPostIn.Items[i].UserDrugIndex));}
function CreateSidePanelInRecipeCheck(showPanel,dataObj)
{$MediCom(showPanel).appendChild(ShowRecipeCheckInfoToUser("警告：以下处方药品副作用可能加重病人病情"));var sb=new StringBuilder();var count=dataObj.Items.length;if(count>0)
{McSideDataPostIn=dataObj;}
var obj;for(var i=0;i<count;i++)
{obj=dataObj.Items[i];sb.Append("<table width=\"100%\" border=\"0\" cellpadding=\"1\" cellspacing=\"1\"><tr><td width=\"40\"><div style=\"float:left;\">");sb.Append(i+1);sb.Append(".</div><div class=\"DdimRemark_");sb.Append(obj.WarningCode);sb.Append("\" /></td><td colspan=\"2\">");sb.Append(obj.Title);sb.Append("</td></tr><tr><td>&nbsp;</td><td width=\"300\">药物类别：");sb.Append(obj.DrugClass);sb.Append("</td><td>严重性/发生率：");sb.Append(obj.SLCodeDesc);sb.Append("</td></tr><tr><td>&nbsp;</td><td>副 作 用：");sb.Append(obj.DescriptionDisease);sb.Append("</td><td align=\"right\" ><span class=\"McDdcmLinkLable\" onclick=\"ShowSideMoreInfoInRecipeCheck('");sb.Append(i);sb.Append("');\">详细信息>>>&nbsp;</td></tr><tr><td height=\"1\" colspan=\"3\" bgcolor=\"#dddddd\"></td></tr></table>");}
var divSideContent=document.createElement("div");divSideContent.id="McRecipeCheckSideListPanel";divSideContent.className="McRecipeCheckDdcmListPanel";divSideContent.innerHTML=sb.toString();$MediCom(showPanel).appendChild(divSideContent);}
function GetSideListData(dqi)
{dqi.QueryType=11;if(CheckWebServiceIsEnable("GetSideListData"))
{var client=new MC_client_request(0);client.ClearParam();client.AddParam("psDrugQueryJSONStr",$MediComH(dqi).toJSON());client.post("MDC_GetDrugQueryInfo",ShowSideListCallBack);$MediCom("McSideTitlePanel").innerHTML=dqi.DrugName+"("+dqi.RouteDesc+")";}
else
{ShowLoadingInfo("McSideMenuPanel",McQueryInitError);}}
function ShowSideListCallBack(result)
{if(!result.error)
{McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="不良反应详细信息";var showErrControlId="McSideMenuPanel";if(!McBackErrInfoToUser(showErrControlId,result.value,errMsg))
{return;}
var f=new Function("McSideData ="+result.value);f();McSideItemCount=McSideData.Items.length;var showResultOK=false;for(var i=0;i<McSideItemCount;i++)
{if(McSideData.Items[i].Items.length>0)
{showResultOK=true;break;}}
if(showResultOK)
{ShowSideData();}
else
{McShowBackErrInfoToUser(showErrControlId,errMsg);return;}}}
function CreateSideRbtn()
{var sb=new StringBuilder();for(var i=0;i<McSideItemCount;i++)
{if(McSideData.Items[i].Items.length>0)
{sb.Append("<label class=\"McSideMenuRBtn\"><input type=\"radio\" name=\"rbtnMcSide\" value=\"");sb.Append(McSideData.Items[i].Index);sb.Append("\" onclick=\"rbtnMcSideClick(this.value);\" />");sb.Append(McSideData.Items[i].DescDrug);sb.Append("</label>");}}
$MediCom("McSideMenuPanel").innerHTML=sb.toString();}
function rbtnMcSideClick(index)
{ShowLoadingInfo("McSideContentPanel","");ShowCurrentSideTable(index);}
function ShowCurrentSideTable(index)
{var sb=new StringBuilder();sb.Append("<table width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"1\" bgcolor=\"#dddddd\">  <tr><td align=\"center\" bgcolor=\"#eeeeee\" width=\"30\">编号</td><td align=\"center\" bgcolor=\"#eeeeee\" >副作用</td><td align=\"center\" bgcolor=\"#eeeeee\" width=\"80\">严重性</td><td align=\"center\" bgcolor=\"#eeeeee\" width=\"80\">发生率</td><td align=\"center\" bgcolor=\"#eeeeee\" width=\"80\">过敏反应</td>  </tr>");var count=McSideData.Items[index].Items.length;var obj;for(var i=0;i<count;i++)
{obj=McSideData.Items[index].Items[i];var showAllergenStr="";if(obj.IsAllergen==1)
{showAllergenStr="√";}
sb.Append("<tr><td bgcolor=\"#ffffff\">");sb.Append(obj.index);sb.Append("</td><td bgcolor=\"#ffffff\">");sb.Append(obj.DescriptionCond);sb.Append("</td><td bgcolor=\"#ffffff\">");sb.Append(obj.SLCodeDesc);sb.Append("</td><td bgcolor=\"#ffffff\">");sb.Append(obj.FrequencyDesc);sb.Append("</td><td bgcolor=\"#ffffff\" align=\"center\">");sb.Append(showAllergenStr);sb.Append("</td></tr>");}
sb.Append("</table>");$MediCom("McSideContentPanel").innerHTML=sb.toString();}
function CreateRecipeCheckSideMoreinfoTitleTable(obj)
{var titleOld=$MediCom("McSideTitlePanel").innerHTML;var sb=new StringBuilder();sb.Append("<table width=\"100%\" border=\"0\" cellpadding=\"3\" cellspacing=\"0\"><tr><td width=\"50%\" align=\"left\"><b>处方药品：</b>"+titleOld+"</td><td width=\"50%\" align=\"left\"><b>病生状态：</b>"+obj.ConditionDescription+"</td></tr><tr><td align=\"left\">　－－药物类别："+obj.DrugClass+"</td><td align=\"left\">　－－关联病症："+obj.DescriptionDisease+"</td></tr><tr><td align=\"left\">　－－副 作 用："+obj.DescriptionDisease+"</td><td>&nbsp;</td></tr><tr><td align=\"left\"><b>严重性/发生率：</b>"+obj.SLCodeDesc+"</td><td>&nbsp;</td></tr></table>");return sb.toString();}
function ShowSideData()
{try
{if(McSideDataPostIn.Items[SideMoreInfoInRecipeCheckIndex].ConditionDescription!=undefined)
{$MediCom("McSideTitlePanel").innerHTML=CreateRecipeCheckSideMoreinfoTitleTable(McSideDataPostIn.Items[SideMoreInfoInRecipeCheckIndex]);}}
catch(e)
{}
CreateSideRbtn();document.getElementsByName("rbtnMcSide")[0].checked="checked";ShowCurrentSideTable(document.getElementsByName("rbtnMcSide")[0].value);}
function FuncSIDE()
{McSideDataPostIn=null;CreateSidePanel();GetSideListData(GetModelByRowIndex(SelectedRowIndex));}
﻿
var McCheckData;var McCheckItemCount=0;function CreateCheckPanel(){ppw=new PassPopWindowNew();ppw.Title="药物对检验值的影响";ppw.mainID="MC_Check_Main";ppw.headID="MC_Check_Head";ppw.bodyID="MC_Check_Body";ppw.CreatePanel();var divCheckMenu=document.createElement("div");var divCheckContent=document.createElement("div");divCheckMenu.id="McCheckMenuPanel";divCheckMenu.className="McCheckMenu";divCheckContent.id="McCheckContentPanel";divCheckContent.className="McCheckContent";$MediCom(ppw.bodyID).appendChild(divCheckMenu);$MediCom(ppw.bodyID).appendChild(divCheckContent);ShowLoadingInfo("McCheckMenuPanel","");ShowHideNew(ppw.mainID,null);}
function CreateCheckList(){var sb=new StringBuilder();sb.Append("<div class=\"PanelAutoTable_Show\"> <table border=\"0\" align=\"center\" cellpadding=\"4\" cellspacing=\"1\" bgcolor=\"#dddddd\" class=\"McCheckDataTable\"><tr><td colspan=\"4\" align=\"center\" bgcolor=\"#eeeeee\">");sb.Append(McCheckData.Description+"</td><tr><td align=\"center\"  bgcolor=\"#f4f4f4\">检验值项目</td><td align=\"center\" bgcolor=\"#f4f4f4\">名称</td><td align=\"center\" bgcolor=\"#f4f4f4\">改变</td><td align=\"center\" bgcolor=\"#f4f4f4\">原因说明</td></tr>");for(var i=0;i<McCheckItemCount;i++){var itemCount=McCheckData.Items[i].Items.length;var obj;for(var j=0;j<itemCount;j++){obj=McCheckData.Items[i].Items[j];sb.Append("<tr>");if(j==0){sb.Append("<td width=\"85\" valign=\"middle\" bgcolor=\"#ffffff\" rowspan=\"");sb.Append(McCheckData.Items[i].Items.length);sb.Append("\">");sb.Append(McCheckData.Items[i].TypeName);sb.Append("</td>");}
sb.Append("<td width=\"180\"  bgcolor=\"#ffffff\">");sb.Append(obj.ChkName);sb.Append("</td><td width=\"50\" align=\"center\" bgcolor=\"#ffffff\">");sb.Append(obj.ChkValue);sb.Append("</td><td bgcolor=\"#ffffff\">");sb.Append(obj.ChkCause);sb.Append("</td>");}
sb.Append("<tr><td colspan=\"4\" height=\"5\" bgcolor=\"#f7f7f7\"></td></tr>");}
sb.Append("</table> </div>");$MediCom("McCheckContentPanel").innerHTML=sb.toString();}
function GetCheckListData(dqi){dqi.QueryType=21;if(CheckWebServiceIsEnable("GetCheckListData"))
{var client=new MC_client_request(0);client.ClearParam();client.AddParam("psDrugQueryJSONStr",$MediComH(dqi).toJSON());client.post("MDC_GetDrugQueryInfo",ShowCheckListCallBack);}
else
{ShowLoadingInfo("McCheckMenuPanel",McQueryInitError);}}
function ShowCheckListCallBack(result){if(!result.error){McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="药物对检验值的影响";var showErrControlId="McCheckMenuPanel";if(!McBackErrInfoToUser(showErrControlId,result.value,errMsg)){return;}
var f=new Function("McCheckData ="+result.value);f();McCheckItemCount=McCheckData.Items.length;if(McCheckItemCount>0){ShowLoadingInfo("McCheckMenuPanel","共有"+McCheckItemCount+"条详细信息");CreateCheckList();}
else{McShowBackErrInfoToUser(showErrControlId,errMsg);}}}
function FuncCheckRes(){CreateCheckPanel();GetCheckListData(GetModelByRowIndex(SelectedRowIndex));}
﻿
var McDfimData;var McDfimItemCount=0;function CreateDfimPanel(){var ppw=new PassPopWindowNew();ppw.Title="药物-食物相互作用查询信息";ppw.mainID="MC_DFIM_Main";ppw.headID="MC_DFIM_Head";ppw.bodyID="MC_DFIM_Body";ppw.CreatePanel();var divDFIMMenu=document.createElement("div");var divDFIMContent=document.createElement("div");divDFIMMenu.id="DivMcDfimMenu";divDFIMMenu.className="McDfimMenu";divDFIMContent.id="DivMcDfimContent";divDFIMContent.className="McDfimContent";$MediCom(ppw.bodyID).appendChild(divDFIMMenu);$MediCom(ppw.bodyID).appendChild(divDFIMContent);ShowLoadingInfo(divDFIMMenu,"");ShowHideNew(ppw.mainID,null);}
function GetDfimListData(dqi){dqi.QueryType=2;if(CheckWebServiceIsEnable("GetDfimListData"))
{var client=new MC_client_request(0);client.ClearParam();client.AddParam("psDrugQueryJSONStr",$MediComH(dqi).toJSON());client.post("MDC_GetDrugQueryInfo",ShowDfimListCallBack);}
else
{ShowLoadingInfo("DivMcDfimMenu",McQueryInitError);}}
function ShowDfimListCallBack(result){if(!result.error){McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="药物-食物相互作用查询信息";var showErrControlId="DivMcDfimMenu";if(!McBackErrInfoToUser(showErrControlId,result.value,errMsg)){return;}
var f=new Function("McDfimData ="+result.value);f();McDfimItemCount=McDfimData.Items.length;if(McDfimItemCount>0){ShowDfimData();}
else{McShowBackErrInfoToUser(showErrControlId,errMsg);return;}}}
function ShowDfimData(){$MediCom("DivMcDfimMenu").innerHTML=McDfimData.Title;var sb=new StringBuilder();for(var i=0;i<McDfimItemCount;i++){sb.Append("【"+McDfimData.Items[i].Desc+"】<BR>　　");sb.Append(McDfimData.Items[i].Content);sb.Append("<br><br>");}
$MediCom("DivMcDfimContent").innerHTML=sb.toString();}
function FuncDFIM(){CreateDfimPanel();GetDfimListData(GetModelByRowIndex(SelectedRowIndex));}
﻿
var McIvData;var McIvMoreInfoData;var McIvItemsCount;var McIvMoreInfoItemsCount;function CreateIvPanel()
{var ppw=new PassPopWindowNew();ppw.Title="国内注射剂配伍查询信息";ppw.mainID="MC_IV_Main";ppw.headID="MC_IV_Head";ppw.bodyID="MC_IV_Body";ppw.CreatePanel();var divIvTitle=document.createElement("div");var divIvBMenu=document.createElement("div");var divIvContent=document.createElement("div");divIvTitle.id="McIVTitlePanel";divIvTitle.className="McIvTitle";divIvBMenu.id="McIvMenuPanel";divIvBMenu.className="McIvMenu";divIvContent.id="McIvContentPanel";divIvContent.className="McIvContent";$MediCom(ppw.bodyID).appendChild(divIvTitle);$MediCom(ppw.bodyID).appendChild(divIvBMenu);$MediCom(ppw.bodyID).appendChild(divIvContent);ShowLoadingInfo("McIVTitlePanel","");ShowHideNew(ppw.mainID,null);}
function CreateIvPanelInRecipeCheck(showPanel,dataObj)
{var count=dataObj.Items.length;var divDDIMMenu=document.createElement("div");divDDIMMenu.className="McDdimMenu";divDDIMMenu.style.height="10px";$MediCom(showPanel).appendChild(divDDIMMenu);var ShowIvMoreInfoLabel="";var tempStr="";var icount=0;var sb=new StringBuilder();for(var i=0;i<count;i++)
{icount=dataObj.Items[i].DetailCount;if(icount>0)
{ShowIvMoreInfoLabel="<span class=\"McDdcmLinkLable\" onclick=\"GetIvMoreInfoList("+Create_GetIvMoreInfoList_Param(dataObj.Items[i])+",1 );\">共有"+icount+"条记录>>></span>";}
else
{ShowIvMoreInfoLabel="";}
sb.Append("<table width=\"100%\" border=\"0\" cellpadding=\"1\" cellspacing=\"1\"><tr><td width=\"40\"><div style=\"float:left;\">");sb.Append(i+1);sb.Append(".</div><div class=\"DdimRemark_");sb.Append(dataObj.Items[i].WarningCode);sb.Append("\" /></td><td colspan=\"2\">");sb.Append(dataObj.Items[i].DrugDesc1);sb.Append(" 和 ");sb.Append(dataObj.Items[i].DrugDesc2);sb.Append("</td></tr><tr><td>&nbsp;</td><td width=\"300\">给药途径：");sb.Append(dataObj.Items[i].RouteDesc);sb.Append("</td><td>配伍结果：");sb.Append(dataObj.Items[i].SLDesc);sb.Append("</td></tr><tr><td>&nbsp;</td><td>数据来源：");sb.Append(dataObj.Items[i].RefDesc);sb.Append("</td><td align=\"right\" >");sb.Append(ShowIvMoreInfoLabel);sb.Append("&nbsp;</td></tr><tr><td height=\"1\" colspan=\"3\" bgcolor=\"#dddddd\"></td></tr></table>");}
var divSideContent=document.createElement("div");divSideContent.id="McRecipeCheckSideListPanel";divSideContent.className="McRecipeCheckDdcmListPanel";divSideContent.innerHTML=sb.toString();$MediCom(showPanel).appendChild(divSideContent);}
function IvMoreInfoListPopWindow(DrugName1,DrugName2,Drug1SysDesc,Drug2SysDesc)
{var pw=new PassPopWindowNew();pw.Title="国内注射剂配伍查询详细信息";pw.mainID="MC_IV_MoreInfo_Main";pw.headID="MC_IV_MoreInfo_Head";pw.bodyID="MC_IV_MoreInfo_Body";pw.W=650;pw.H=500;pw.CreatePanel();var divIvTitle=document.createElement("div");var divIvBMenu=document.createElement("div");var divIvContent=document.createElement("div");if(Drug2SysDesc!="null")
divIvTitle.innerHTML="<b>配伍药品：</b>"+DrugName1+" ("+Drug1SysDesc+")&nbsp;&nbsp; 和 &nbsp;&nbsp;"+DrugName2+" ("+Drug2SysDesc+")";else
divIvTitle.innerHTML="<b>配伍药品：</b>"+DrugName1+" ("+Drug1SysDesc+")&nbsp;&nbsp; 和 &nbsp;&nbsp;"+DrugName2;divIvTitle.className="McIvMoreInfoTitle";divIvBMenu.id="McIvMoreInfoMenuPanel";divIvBMenu.className="McIvMoreInfoTitle";divIvContent.id="McIvMoreInfoContentPanel";divIvContent.className="McIvContent";$MediCom(pw.bodyID).appendChild(divIvTitle);$MediCom(pw.bodyID).appendChild(divIvBMenu);$MediCom(pw.bodyID).appendChild(divIvContent);ShowLoadingInfo("McIvMoreInfoMenuPanel","");ShowHideNew(pw.mainID,null);}
function CreateIvList()
{if(McIvData.Description.length>0)
$MediCom("McIVTitlePanel").innerHTML=McIvData.Description;else
$MediCom("McIVTitlePanel").style.display="none";$MediCom("McIvMenuPanel").innerHTML=CreateIvBigMenuStr()+CreateIvSubMenuStrList();$MediCom("McIvContentPanel").innerHTML=CreateIvSubContentStr();SelectIvMenuOper(0,0);}
function CreateIvBigMenuStr()
{var sb=new StringBuilder();sb.Append("<div id=\"DivIvBMenu\" class=\"McIvBMenu\">");var totalNum=0;for(var i=0;i<McIvItemsCount;i++)
{totalNum=0;for(var j=0;j<3;j++)
{totalNum=totalNum+McIvData.Items[i].Items[j].Items.length;}
sb.Append("<label class=\"item\"><input name=\"rbtnBMenu\" type=\"radio\" onClick=\"SelectIvMenuOper(this.value,-1);\" value=\"");sb.Append(i);sb.Append("\">");sb.Append(McIvData.Items[i].TypeDesc);sb.Append("(共");sb.Append(totalNum);sb.Append("条)</label>");}
sb.Append("</div>");return sb.toString();}
function CreateIvSubMenuStr(bIndex)
{var sb=new StringBuilder();sb.Append("<div id=\"DivBMenu"+bIndex+"_SubMenu\" class=\"McIvSMenu\">");var count=McIvData.Items[bIndex].Items.length;var obj=McIvData.Items[bIndex];for(var i=0;i<count;i++)
{if(obj.Items[i].Items.length>0)
{sb.Append("<label class=\"item\"><input name=\"rbtnSMenu_");sb.Append(bIndex);sb.Append("\" type=\"radio\" onClick=\"SelectIvMenuOper(");sb.Append(bIndex);sb.Append(",this.value);\" value=\"");sb.Append(obj.Items[i].Index);sb.Append("\">");sb.Append(obj.Items[i].SLDesc);sb.Append("(共");sb.Append(obj.Items[i].Items.length);sb.Append("条)</label>");}}
sb.Append("</div>");return sb.toString();}
function CreateIvSubMenuPanelContentStr(bIndex)
{var sb=new StringBuilder();var count=McIvData.Items[bIndex].Items.length;var obj=McIvData.Items[bIndex];for(i=0;i<count;i++)
{sb.Append("<div id=\"DivSMenuContent_");sb.Append(obj.Items[i].Index);sb.Append("\" class=\"panelItem\">");sb.Append(CreateIvSubContentItemListStr(bIndex,i));sb.Append("</div>");}
return sb.toString();}
function CreateIvSubContentItemListStr(bigIndex,subIndex)
{var showOperLabel="";var tempStr="";var item=null;var count=McIvData.Items[bigIndex].Items[subIndex].Items.length;var sb=new StringBuilder();for(var i=0;i<count;i++)
{item=McIvData.Items[bigIndex].Items[subIndex].Items[i];if(item.DetailCount>0)
showOperLabel="&nbsp;共"+item.DetailCount+"条记录>>>&nbsp;";else
showOperLabel="";sb.Append("<div id=\"DivSubContent_");sb.Append(item.bigIndex);sb.Append(item.subIndex);sb.Append(i);sb.Append("\" class=\"listItem\"><div class=\"listItemLeft\">");sb.Append(i+1);sb.Append(". ");sb.Append(item.DrugDesc1);sb.Append("&nbsp;&nbsp; 和 &nbsp;&nbsp;");sb.Append(item.DrugDesc2);sb.Append("</div><div class=\"listItemRight\" onclick=\"GetIvMoreInfoList(");sb.Append(Create_GetIvMoreInfoList_Param(item));sb.Append(" ,0);\">&nbsp;");sb.Append(showOperLabel);sb.Append("</div></div>");}
return sb.toString();}
function Create_GetIvMoreInfoList_Param(item)
{var sb=new StringBuilder();sb.Append(item.RefType);sb.Append(",");sb.Append(item.DetailType);sb.Append(",");sb.Append(item.DrugID1);sb.Append(",");sb.Append(item.DrugID2);sb.Append(",");sb.Append(item.RouteType);sb.Append(", '");sb.Append(item.DrugDesc1);sb.Append("','");sb.Append(item.DrugDesc2);sb.Append("','");sb.Append(item.Drug1SysDesc);sb.Append("','");sb.Append(item.Drug2SysDesc);sb.Append("'");return sb.toString();}
function CreateIvSubContentStr()
{var sb=new StringBuilder();for(var i=0;i<McIvItemsCount;i++)
{sb.Append("<div id=\"DivBMenu");sb.Append(i);sb.Append("_Content\" class=\"McSMenuContent\">");sb.Append(CreateIvSubMenuPanelContentStr(i));sb.Append("</div>");}
return sb.toString();}
function CreateIvSubMenuStrList()
{var sb=new StringBuilder();sb.Append("<div id=\"DivSMenuList");sb.Append(i);sb.Append("\">");for(var i=0;i<McIvItemsCount;i++)
{sb.Append(CreateIvSubMenuStr(i));}
sb.Append("</div>");return sb.toString();}
function SelectIvMenuOper(bIndex,sIndex)
{var i=0;var baseIndex=-1;document.getElementsByName("rbtnBMenu")[bIndex].checked="checked";if(bIndex==0)
{$MediCom("DivBMenu0_SubMenu").style.display="block";$MediCom("DivBMenu0_Content").style.display="block";$MediCom("DivBMenu1_SubMenu").style.display="none";$MediCom("DivBMenu1_Content").style.display="none";}
if(bIndex==1)
{$MediCom("DivBMenu1_SubMenu").style.display="block";$MediCom("DivBMenu1_Content").style.display="block";$MediCom("DivBMenu0_SubMenu").style.display="none";$MediCom("DivBMenu0_Content").style.display="none";}
var baseIndex=-1;if(bIndex==0)
baseIndex=0;if(bIndex==1)
baseIndex=3;if(sIndex>-1)
{for(i=baseIndex;i<3+baseIndex;i++)
{$MediCom("DivSMenuContent_"+i).style.display="none";}
$MediCom("DivSMenuContent_"+sIndex).style.display="block";document.getElementsByName("rbtnSMenu_"+bIndex)[sIndex-baseIndex].checked="checked";}
else
{for(i=0;i<3;i++)
{if(document.getElementsByName("rbtnSMenu_"+bIndex)[i].checked==true)
{return;}}
for(i=baseIndex;i<3+baseIndex;i++)
{$MediCom("DivSMenuContent_"+i).style.display="none";}
$MediCom("DivSMenuContent_"+baseIndex).style.display="block";document.getElementsByName("rbtnSMenu_"+bIndex)[0].checked="checked";}}
function GetIvMoreInfoList(piRefType,piDetailType,piDrugID1,piDrugID2,piRouteType,DrugName1,DrugName2,Drug1SysDesc,Drug2SysDesc,infoType)
{if(CheckWebServiceIsEnable("GetIvMoreInfoList"))
{var client=new MC_client_request(0);client.ClearParam();client.AddParam("piRefType",piRefType);client.AddParam("piDetailType",piDetailType);client.AddParam("piDrugID1",piDrugID1);client.AddParam("piDrugID2",piDrugID2);client.AddParam("piRouteType",piRouteType);client.AddParam("piIsScreen",infoType);client.post("MDC_GetIVDetail",IvMoreInfoListCallBack);IvMoreInfoListPopWindow(DrugName1,DrugName2,Drug1SysDesc,Drug2SysDesc);}
else
{ShowLoadingInfo("McIVTitlePanel",McQueryInitError);}}
function IvMoreInfoListCallBack(result)
{if(!result.error)
{McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="非常遗憾，未能找到相应的详细信息！";var showErrControlId="McIvMoreInfoMenuPanel";if(!McBackErrInfoToUser2(showErrControlId,result.value,errMsg))
{return;}
var f=new Function("McIvMoreInfoData ="+result.value);f();McIvMoreInfoItemsCount=McIvMoreInfoData.Items.length;if(McIvMoreInfoItemsCount>0)
{LoadIvMoreInfoData();}
else
{McShowBackErrInfoToUser(showErrControlId,errMsg);return;}}}
function LoadIvMoreInfoData()
{var McIvMoreInfoDataSubItemsSLDesc="";var tempStr="";var normalNum=0;var otherNum=0;var tempOhterStr="";var sb=new StringBuilder();var sbTempStr=new StringBuilder();var sbTempOhterStr=new StringBuilder();for(var i=0;i<McIvMoreInfoItemsCount;i++)
{sb.Clear();sb.Append("条</td></tr><tr><td width=\"16%\" align=\"center\" valign=\"top\" bgcolor=\"#f4f4f4\">〖配伍药名〗</td><td width=\"42%\" bgcolor=\"#FFFFFF\">");sb.Append(McIvMoreInfoData.Items[i].DrugName1);sb.Append("</td><td width=\"42%\" bgcolor=\"#FFFFFF\">");sb.Append(McIvMoreInfoData.Items[i].DrugName2);sb.Append("</td></tr><tr><td align=\"center\" valign=\"top\" bgcolor=\"#f4f4f4\">〖生产厂家〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McIvMoreInfoData.Items[i].ManuName1);sb.Append("</td><td bgcolor=\"#FFFFFF\">");sb.Append(McIvMoreInfoData.Items[i].ManuName2);sb.Append("</td></tr><tr><td align=\"center\" valign=\"top\" bgcolor=\"#f4f4f4\">〖药品浓度〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McIvMoreInfoData.Items[i].DrugConc1);sb.Append("</td><td bgcolor=\"#FFFFFF\">");sb.Append(McIvMoreInfoData.Items[i].DrugConc2);sb.Append("</td></tr><tr><td align=\"center\" valign=\"top\" bgcolor=\"#f4f4f4\">〖配伍结果〗</td><td colspan=\"2\" bgcolor=\"#FFFFFF\">");sb.Append(McIvMoreInfoData.Items[i].SLDesc);sb.Append("</td></tr><tr><td align=\"center\" valign=\"top\" bgcolor=\"#f4f4f4\">〖配伍摘要〗</td><td colspan=\"2\" bgcolor=\"#FFFFFF\">");sb.Append(McIvMoreInfoData.Items[i].Remark);sb.Append("</td></tr><tr><td align=\"center\" valign=\"top\" bgcolor=\"#f4f4f4\">〖参考文献〗</td><td colspan=\"2\" bgcolor=\"#FFFFFF\">");sb.Append(McIvMoreInfoData.Items[i].Reference);sb.Append("</td></tr></table><table><tr><td height=\"2\"></td></tr></table>");McIvMoreInfoDataSubItemsSLDesc=McIvMoreInfoData.Items[i].SLDesc;if(McIvMoreInfoData.Items[i].TopLevel==1)
{normalNum=normalNum+1;sbTempStr.Append("<table width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"1\" bgcolor=\"#dddddd\"><tr><td colspan=\"3\" bgcolor=\"#dddddd\">第");sbTempStr.Append(normalNum);sbTempStr.Append(sb.toString());}
if(McIvMoreInfoData.Items[i].TopLevel==0)
{otherNum=otherNum+1;sbTempOhterStr.Append("<table width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"1\" bgcolor=\"#dddddd\"><tr><td colspan=\"3\" bgcolor=\"#dddddd\">第");sbTempOhterStr.Append(otherNum);sbTempOhterStr.Append(sb.toString());}}
$MediCom("McIvMoreInfoMenuPanel").innerHTML=McIvMoreInfoData.StatDesc;tempOhterStr=sbTempOhterStr.toString();tempStr=sbTempStr.toString();var sb1=new StringBuilder();if(tempStr.length>0)
{sb1.Append("<div class=\"PanelAutoTable_Show\">");sb1.Append(tempStr);sb1.Append("</div>");}
var sb2=new StringBuilder();if(tempOhterStr.length>0)
{sb2.Append("<div id=\"LabelIvMoreInfoOhterContentText\" onclick=\"IV_OpenOrClose();\" class=\"label_Hide\">其他信息[+]</div>  <div id=\"IvMoreInfoOhterContent\" class=\"PanelAutoTable_Hide\">");sb2.Append("<div class=\"McIvMoreInfoTitle\">");sb2.Append(McIvMoreInfoData.OtherStatDesc);sb2.Append("</div>");sb2.Append(tempOhterStr);sb2.Append("</div>");}
$MediCom("McIvMoreInfoContentPanel").innerHTML=sb1.toString()+sb2.toString();}
function IV_OpenOrClose()
{var label=$MediCom("LabelIvMoreInfoOhterContentText");var showPanel=$MediCom("IvMoreInfoOhterContent");if(showPanel.className=="PanelAutoTable_Show")
{showPanel.className="PanelAutoTable_Hide";label.innerText="其他信息[+]";label.className="label_Hide";}
else
{if(showPanel.className=="PanelAutoTable_Hide")
{showPanel.className="PanelAutoTable_Show";label.innerText="其他信息[-]";label.className="label_Show";}}}
function GetIvListData(dqi)
{dqi.QueryType=22;if(CheckWebServiceIsEnable("GetIvListData"))
{var client=new MC_client_request(0);client.ClearParam();client.AddParam("psDrugQueryJSONStr",$MediComH(dqi).toJSON());client.post("MDC_GetDrugQueryInfo",ShowIvListCallBack);}}
function TestDataIv()
{}
function ShowIvListCallBack(result)
{if(!result.error)
{McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="国内注射剂配伍查询信息";var showErrControlId="McIVTitlePanel";if(!McBackErrInfoToUser(showErrControlId,result.value,errMsg))
{return;}
var f=new Function("McIvData ="+result.value);f();McIvItemsCount=McIvData.Items.length;if(IsHasIvData())
{CreateIvList();}
else
{McShowBackErrInfoToUser(showErrControlId,errMsg);return;}}}
function IsHasIvData()
{var bigTotalNum=0;var totalNum=0;for(var i=0;i<McIvItemsCount;i++)
{totalNum=0;for(var j=0;j<3;j++)
{totalNum=totalNum+McIvData.Items[i].Items[j].Items.length;}
bigTotalNum=bigTotalNum+totalNum;}
if(bigTotalNum==0)
return false;else
return true;}
function FuncMatchRes()
{CreateIvPanel();GetIvListData(GetModelByRowIndex(SelectedRowIndex));}
﻿function OnMouseOverPopInfoWindow(index)
{pw=new PassPopWindowNew();pw.Title="重要提示信息";pw.mainID="MC_RecipeCheck_Main";pw.headID="MC_RecipeCheck_Head";pw.bodyID="MC_RecipeCheck_Body";pw.width=350;pw.height=200;var clientTop=document.documentElement.clientTop;var clientLeft=document.documentElement.clientLeft;var offsetHeight=document.documentElement.offsetHeight;var scrollLeft=document.documentElement.scrollLeft;var scrollTop=document.documentElement.scrollTop;if(clientTop==0)
clientTop=document.body.clientTop;if(clientLeft==0)clientLeft=document.body.clientLeft;if(offsetHeight==0)
offsetHeight=document.body.offsetHeight;if(scrollLeft==0)scrollLeft=document.body.scrollLeft;if(scrollTop==0)
scrollTop=document.body.scrollTop;
var x=-1;var y=-1;if(arguments.length==3){x=arguments[1];y=arguments[2];pw.left=x;pw.top=y;}else{var top=window.event.clientY+scrollTop-clientTop;
if(offsetHeight-window.event.clientY<100)top=offsetHeight+scrollTop-pw.height;pw.left=window.event.clientX+scrollLeft-clientLeft;pw.top=top;}pw.CreatePanel();var divRecipeCheckContent=document.createElement("div");divRecipeCheckContent.id="MIPW_Body";divRecipeCheckContent.className="MIPW_Body";$MediCom(pw.bodyID).appendChild(divRecipeCheckContent);ShowLoadingInfo("MIPW_Body","");ShowHideNew(pw.mainID,null);var dqi=GetModelByRowIndex(index);GetMcSummaryInfo(dqi);}
function GetMcSummaryInfo(dqi)
{if(CheckWebServiceIsEnable("GetMcSummaryInfo"))
{dqi.QueryType=97;var client=new MC_client_request(0);client.ClearParam();client.AddParam("psDrugQueryJSONStr",$MediComH(dqi).toJSON());client.post("MDC_GetDrugQueryInfo",GetMcSummaryInfoCallBack);}
else
{ShowLoadingInfo("MIPW_Body",McQueryInitError);}}
function GetMcSummaryInfoCallBack(result)
{if(!result.error)
{McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="非常遗憾，未找到相关摘要数据！";var showErrControlId="MIPW_Body";if(!McBackErrInfoToUser2(showErrControlId,result.value,errMsg))
{return;}
ShowLoadingInfo("MIPW_Body",result.value);}}
﻿
var McRecipeCheckData;var McRecipeCheckItemCount=0;var McRecipeCheckPassPopWindow;var McRecipeCheckSimpleInfoWindow;var McRecipeCheckLastLightStateArr=new Array();var McRecipeCheckRemarkCode=0;var McRecipeCheckSeverityLevelMax=0;function CreateRecipeCheckPanel(){McRecipeCheckPassPopWindow=new PassPopWindowNew();McRecipeCheckPassPopWindow.Title="合理用药监测系统";McRecipeCheckPassPopWindow.mainID="MC_RecipeCheck_Main";McRecipeCheckPassPopWindow.headID="MC_RecipeCheck_Head";McRecipeCheckPassPopWindow.bodyID="MC_RecipeCheck_Body";McRecipeCheckPassPopWindow.CreatePanel();var divRecipeCheckMenu=document.createElement("div");var divRecipeCheckContent=document.createElement("div");divRecipeCheckMenu.id="RecipeCheckMenuPanel";divRecipeCheckMenu.className="McRecipeCheckMenu";divRecipeCheckContent.id="RecipeCheckContentPanel";divRecipeCheckContent.className="McRecipeCheckContent";$MediCom(McRecipeCheckPassPopWindow.bodyID).appendChild(divRecipeCheckMenu);$MediCom(McRecipeCheckPassPopWindow.bodyID).appendChild(divRecipeCheckContent);ShowLoadingInfo("RecipeCheckMenuPanel","");ShowHideNew(McRecipeCheckPassPopWindow.mainID,null);}
function ShowRecipeCheckSimplePanel(){McRecipeCheckPassPopWindow=new PassPopWindowNew();McRecipeCheckPassPopWindow.Title="合理用药监测系统";McRecipeCheckPassPopWindow.mainID="MC_RecipeCheck_Main";McRecipeCheckPassPopWindow.headID="MC_RecipeCheck_Head";McRecipeCheckPassPopWindow.bodyID="MC_RecipeCheck_Body";McRecipeCheckPassPopWindow.width=350;McRecipeCheckPassPopWindow.height=200;McRecipeCheckPassPopWindow.CreatePanel();var divRecipeCheckContent=document.createElement("div");divRecipeCheckContent.id="RecipeCheckMenuPanel";divRecipeCheckContent.className="MIPW_Body";$MediCom(McRecipeCheckPassPopWindow.bodyID).appendChild(divRecipeCheckContent);ShowLoadingInfo("RecipeCheckMenuPanel","");ShowHideNew(McRecipeCheckPassPopWindow.mainID,null);ShowHideNew(McRecipeCheckPassPopWindow.mainID,"none");}
function GetRecipeCheckListData(iCheckModeParmInt,iWorkStationTypeParmInt,MedCondType,PatientParmStr,AllergensParmStr,MedCondsParmStr,RecipesParmStr)
{if(CheckWebServiceIsEnable_Check("GetRecipeCheckListData"))
{var client=new MC_client_request(1);client.ClearParam();client.AddParam("piCheckMode",iCheckModeParmInt);client.AddParam("piWorkStationType",iWorkStationTypeParmInt);client.AddParam("piCheckType",MedCondType);client.AddParam("psPatientJSONStr",PatientParmStr);client.AddParam("psAllergensJSONStr",AllergensParmStr);client.AddParam("psMedCondsJSONStr",MedCondsParmStr);client.AddParam("psRecipesJSONStr",RecipesParmStr);if(IsAsyncRecipeCheck){client.post("MDC_DoCheck",ShowRecipeCheckListCallBack);}
else{ShowRecipeCheckListCallBack(client.post("MDC_DoCheck",null,ShowRecipeCheckListCallBack));}}
else
{ShowLoadingInfo("RecipeCheckMenuPanel",McCheckInitError);}}
function ShowRecipeCheckListCallBack(result)
{if(result=="undefind"||result==null)
{ShowLoadingInfo("RecipeCheckMenuPanel",McCheckInitError);return;}
if(!result.error){McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="合理用药监测系统";var showErrControlId="RecipeCheckMenuPanel";if(result.value.toLowerCase()=="null"){if(McRecipeCheckRemarkCode==1){if(McRecipeCheckSimpleInfoWindow!=null){ShowHideNew(McRecipeCheckSimpleInfoWindow.mainID,"none");}}
if(McRecipeCheckRemarkCode==2||McRecipeCheckRemarkCode==3){if(McRecipeCheckPassPopWindow!=null){ShowHideNew(McRecipeCheckPassPopWindow.mainID,"none");}}
return;}
if(!McBackErrInfoToUser(showErrControlId,result.value,errMsg)){return;}
McDebug_t2=GetCurrentTime();var f=new Function("McRecipeCheckData =["+result.value+"]");f();McRecipeCheckItemCount=McRecipeCheckData.length;if(McRecipeCheckItemCount>1||(McRecipeCheckRemarkCode==3&&McRecipeCheckItemCount>0))
{$MediCom("RecipeCheckMenuPanel").innerHTML="";for(var i=0;i<McRecipeCheckItemCount;i++){CreateRecipeCheckMenuItem(i,McRecipeCheckData[i].CheckItemName,McRecipeCheckData[i].CheckItemDesc,McRecipeCheckData[i].ItemCount);}
if(RecipeCheckMenuCount>0){var obj=new Object();obj.index=0;obj.id="li_"+McRecipeCheckData[0].CheckItemName;obj.className="McRecipeCheckMenuItem";obj.baseName=McRecipeCheckData[0].CheckItemName;$MediCom("RecipeCheckMenuPanel").className="McRecipeCheckMenu_ShowBlueMenu";RecipeCheckShowItemContent(obj);}
else{McShowBackErrInfoToUser(showErrControlId,errMsg);return;}}
else
{if(McRecipeCheckItemCount==1)
{if(McRecipeCheckRemarkCode==1){if(McRecipeCheckSimpleInfoWindow!=null){ShowHideNew(McRecipeCheckSimpleInfoWindow.mainID,"none");}}
if(McRecipeCheckRemarkCode==2){if(McRecipeCheckPassPopWindow!=null){ShowHideNew(McRecipeCheckPassPopWindow.mainID,"none");}}}}
McDebug_t3=GetCurrentTime();if(McRecipeCheckData[McRecipeCheckItemCount-1].CheckItemName=="WarningCode"){var objLight=McRecipeCheckData[McRecipeCheckItemCount-1];
var countLight=objLight.Items.length;var varWarningCode=-1;var varWarningCodeMax=0;for(var i=0;i<countLight;i++){varWarningCode=McRecipeCheckData[McRecipeCheckItemCount-1].Items[i].WarningCode;

if(McRecipeCheckUpdateLight==1){
if ($MediCom("McRecipeCheckLight_" + objLight.Items[i].UserDrugIndex)) {//for deal with no light div
   $MediCom("McRecipeCheckLight_"+objLight.Items[i].UserDrugIndex).className="DdimRemark_"+varWarningCode;
 }
}
McRecipeCheckLastLightStateArr[McRecipeCheckLastLightStateArr.length]=objLight.Items[i].UserDrugIndex;if(varWarningCode==2)
varWarningCode=3;else if(varWarningCode==3)
varWarningCode=4;else if(varWarningCode==4)
varWarningCode=2;if(varWarningCodeMax<varWarningCode)
varWarningCodeMax=varWarningCode;}
McRecipeCheckSeverityLevelMax=varWarningCodeMax;}
if(IsDebugShowTime){McDebugShowTime();}}
else{alert(result.errmore);}}
var RecipeCheckMenuCount=0;function CreateRecipeCheckMenuItem(index,baseName,title,itemCount){if(title!=null){if(title!="WarningCode"){RecipeCheckMenuCount=RecipeCheckMenuCount+1;var menuItem=document.createElement("li");menuItem.index=index;menuItem.id="li_"+baseName;menuItem.className="McRecipeCheckMenuItem";menuItem.baseName=baseName;menuItem.innerHTML=title+"("+itemCount+")";$MediCom("RecipeCheckMenuPanel").appendChild(menuItem);var menuItemContent=document.createElement("div");menuItemContent.id="RecipeCheckMenuItemContent_"+baseName;menuItemContent.className="McRecipeCheckMenuItemContent";$MediCom("RecipeCheckContentPanel").appendChild(menuItemContent);menuItem.onclick=function(){RecipeCheckMenuItemOnclick(menuItem)};}}}
function RecipeCheckMenuItemOnclick(e){var obj=e;var arr=$MediCom("RecipeCheckMenuPanel").getElementsByTagName("li");for(var i=arr.length-1;i>=0;i--){arr[i].className="McRecipeCheckMenuItem";}
arr=$MediCom("RecipeCheckContentPanel").getElementsByTagName("div");for(var i=arr.length-1;i>=0;i--){if(arr[i].className=="McRecipeCheckMenuItemContentOver"){arr[i].className="McRecipeCheckMenuItemContent";}}
RecipeCheckShowItemContent(obj);}
function RecipeCheckShowItemContent(obj){$MediCom(obj.id).className="McRecipeCheckMenuItemOver";$MediCom("RecipeCheckMenuItemContent_"+obj.baseName).className="McRecipeCheckMenuItemContentOver";if($MediCom("RecipeCheckMenuItemContent_"+obj.baseName).innerHTML.length>5)
return;var showPanel="RecipeCheckMenuItemContent_"+obj.baseName;var dataObj=McRecipeCheckData[obj.index];switch(obj.baseName.toLowerCase()){case"ddim":CreateDdimPanelInRecipeCheck(showPanel);ShowDdimListCallBackInRecipeCheck(dataObj);break;case"mciv":CreateIvPanelInRecipeCheck(showPanel,dataObj);break;case"ddcm":CreateDdcmPanelInRecipeCheck(showPanel,dataObj);break;case"side":CreateSidePanelInRecipeCheck(showPanel,dataObj);break;case"routeres":CreateRouteResPanelInRecipeCheck(showPanel,dataObj);break;case"dtdi":CreateDtDiPanelInRecipeCheck(showPanel,dataObj);break;case"dosageres":CreateDosageResPanelInRecipeCheck(showPanel,dataObj);break;case"geri":CreateGeriPanelInRecipeCheck(showPanel,dataObj);break;case"lact":CreateLactPanelInRecipeCheck(showPanel,dataObj);break;case"pedi":CreatePediPanelInRecipeCheck(showPanel,dataObj);break;case"preg":CreatePregPanelInRecipeCheck(showPanel,dataObj)
break;case"dam":CreateDamPanelInRecipeCheck(showPanel);ShowDamListCallBackInRecipeCheck(dataObj);break;default:break;}}
function GetCurrentObjData(obj){for(var i=0;i<McRecipeCheckItemCount;i++){if(McRecipeCheckData[i].CheckItemName.toLowerCase()==obj.baseName.toLowerCase()){return McRecipeCheckData[i];}}}
function ShowRecipeCheckInfoToUser(msg){var div=document.createElement("div");div.innerHTML=msg;div.className="ShowRecipeCheckInfoToUser";return div;}
var McRecipeCheckUpdateLight=1;function FuncRecipeCheckNoLightDiv(MedCondType,TypeCode){McRecipeCheckUpdateLight=0;FuncRecipeCheck(MedCondType,TypeCode);}
function FuncRecipeCheck(MedCondType,TypeCode)
{var iCheckModeParmInt=0;if(TypeCode==1)
{McRecipeCheckRemarkCode=1;ShowRecipeCheckSimplePanel();iCheckModeParmInt=32;}
else if(TypeCode==2)
{McRecipeCheckRemarkCode=2;CreateRecipeCheckPanel();iCheckModeParmInt=33;}
if(!CheckWebServiceIsEnable_Check("FuncRecipeCheck"))
{ShowLoadingInfo("RecipeCheckMenuPanel",McCheckInitError);return;}
McDebug_t0=GetCurrentTime();var iWorkStationTypeParmInt=McPatientModel.WorkStationType;var McPatientStr="";var o;if(McPatientModel instanceof Hash)
o=McPatientModel;else
o=new Hash(McPatientModel);McPatientStr=o.toJSON();McShowDebugInfo(IsDebugPatient,McPatientStr,DebugShowPanel_Patient);var RecipesParmStr="";if(McRecipeDataList.length>0)
RecipesParmStr="{\"Recipes\":"+McRecipeDataList.toJSON()+"}";McShowDebugInfo(IsDebugRecipes,RecipesParmStr,DebugShowPanel_Recipes);var AllergensParmStr="";if(McAllergenDataList.length>0)
AllergensParmStr="{\"Allergens\":"+McAllergenDataList.toJSON()+"}";McShowDebugInfo(IsDebugAllergens,AllergensParmStr,DebugShowPanel_Allergens);var MedCondsParmStr="";if(McMedCondDataList.length>0)
MedCondsParmStr="{\"MedConds\":"+McMedCondDataList.toJSON()+"}";McShowDebugInfo(IsDebugMedConds,MedCondsParmStr,DebugShowPanel_MedConds);McResetWarningLight();McDebug_t11=GetCurrentTime();GetRecipeCheckListData(iCheckModeParmInt,iWorkStationTypeParmInt,MedCondType,McPatientStr,AllergensParmStr,MedCondsParmStr,RecipesParmStr);}
function FuncSingleRecipeCheck(MedCondType){if(!CheckWebServiceIsEnable_Check("FuncSingleRecipeCheck"))
return;McRecipeCheckRemarkCode=3;CreateRecipeCheckPanel();var iCheckModeParmInt=33;var iWorkStationTypeParmInt=McPatientModel.WorkStationType;var McPatientStr="";McPatientStr=$MediComH(McPatientModel).toJSON();var RecipesParmStr="";if(McRecipeDataList.length>0)
RecipesParmStr="{\"Recipes\":"+McRecipeDataList.toJSON()+"}";var AllergensParmStr="";if(McAllergenDataList.length>0)
AllergensParmStr="{\"Allergens\":"+McAllergenDataList.toJSON()+"}";var MedCondsParmStr="";if(McMedCondDataList.length>0)
MedCondsParmStr="{\"MedConds\":"+McMedCondDataList.toJSON()+"}";GetRecipeCheckListData(iCheckModeParmInt,iWorkStationTypeParmInt,MedCondType,McPatientStr,AllergensParmStr,MedCondsParmStr,RecipesParmStr);}
function McResetWarningLight(){var count=McRecipeCheckLastLightStateArr.length;if(McRecipeCheckUpdateLight==1){for(var i=0;i<count;i++){try{$MediCom("McRecipeCheckLight_"+McRecipeCheckLastLightStateArr[i]).className="DdimRemark_null";}
catch(e)
{}}}
McRecipeCheckLastLightStateArr=new Array();McRecipeCheckSeverityLevelMax=0;}
var McDebug_t0;var McDebug_t11;var McDebug_t2;var McDebug_t3;function McDebugShowTime(){alert("处方条数："+McRecipeDataList.length+"\n过敏条数："+McAllergenDataList.length+"\n病生条数："+McMedCondDataList.length+"\n\n格式化参数用时:"+(McDebug_t11-McDebug_t0)+"\n获取数据用时:"+(McDebug_t2-McDebug_t11)+"\n组织界面用时:"+(McDebug_t3-McDebug_t2));}
function GetCurrentTime(){var t=new Date();return(t.getSeconds()*1000+t.getMilliseconds());}
﻿
var McRouteResData;function CreateRouteResPanelInRecipeCheck(parentNode,dataObj)
{var divRouteResMenu=document.createElement("div");var divRouteResContent1=document.createElement("div");var divRouteResContent2=document.createElement("div");divRouteResMenu.id="McRouteResMenuPanel";divRouteResMenu.className="McRouteResMenu";divRouteResContent1.id="McRouteResContentPanel1";divRouteResContent1.className="McRouteResContent";divRouteResContent2.id="McRouteResContentPanel2";divRouteResContent2.className="McRouteResContent";$MediCom(parentNode).appendChild(divRouteResMenu);$MediCom(parentNode).appendChild(divRouteResContent1);$MediCom(parentNode).appendChild(divRouteResContent2);CreateRouteResRbtnMenuAndDataTable(dataObj);document.getElementsByName("rbtnMcRouteRes")[0].checked="checked";rbtnMcRouteResClick(document.getElementsByName("rbtnMcRouteRes")[0].value);}
function CreateRouteResRbtnMenuAndDataTable(dataObj)
{var sb=new StringBuilder();var sbContent=new StringBuilder();var count=dataObj.Items.length;var iCount=0;for(var i=0;i<count;i++)
{iCount=dataObj.Items[i].ItemCount;if(iCount>0)
{sb.Append("<label class=\"McRouteResMenuRBtn\"><input type=\"radio\" name=\"rbtnMcRouteRes\" value=\"");sb.Append(dataObj.Items[i].ResType);sb.Append("\" onclick=\"rbtnMcRouteResClick(this.value);\" />");sb.Append(dataObj.Items[i].Desc);sb.Append("(");sb.Append(dataObj.Items[i].ItemCount);sb.Append(")</label>");sbContent.Clear();for(var j=0;j<iCount;j++)
{sbContent.Append("<table width=\"100%\" border=\"0\" cellpadding=\"1\" cellspacing=\"1\"><tr><td width=\"40\"><div style=\"float:left;\">");sbContent.Append(j+1);sbContent.Append(".</div><div class=\"DdimRemark_");sbContent.Append(dataObj.Items[i].Items[j].WarningCode);sbContent.Append("\" /></td><td colspan=\"2\">");sbContent.Append(dataObj.Items[i].Items[j].DrugDesc);if(dataObj.Items[i].ResType==1)
{sbContent.Append("</td></tr><tr><td>&nbsp;</td><td width=\"300\">剂型：");sbContent.Append(dataObj.Items[i].Items[j].DoseformDesc);sbContent.Append("</td><td>给药途径：");sbContent.Append(dataObj.Items[i].Items[j].RouteDesc);sbContent.Append("</td></tr>");}
if(dataObj.Items[i].ResType==2)
{sbContent.Append(" (");sbContent.Append(dataObj.Items[i].Items[j].SysDrugDesc);sbContent.Append(")");sbContent.Append("</td></tr><tr><td>&nbsp;</td><td width=\"300\">给药途径：");sbContent.Append(dataObj.Items[i].Items[j].RouteDesc);sbContent.Append("</td><td>严重程度：");sbContent.Append(dataObj.Items[i].Items[j].SLDesc);sbContent.Append("</td></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td align=\"right\"><span id=\"moreInfoRouteResLabel_");sbContent.Append(dataObj.Items[i].Items[j].index);sbContent.Append("\" onclick=\"OpenOrCloseMcPanel(");sbContent.Append(dataObj.Items[i].Items[j].index);sbContent.Append(", 'RouteRes');\" class=\"label_Hide\" >详细信息[+]</span></td></tr><tr><td></td><td colspan=\"2\" height=\"0\" ><span id=\"ShowMoreInfoRouteResPanel_");sbContent.Append(dataObj.Items[i].Items[j].index);sbContent.Append("\" class=\"showPanel_Hide\"><table width=\"100%\" border=\"0\" cellpadding=\"3\" cellspacing=\"1\" bgcolor=\"#f1f1f1\"><tr><td width=\"80\" align=\"center\" bgcolor=\"#F7f7f7\">〖给药说明〗</td><td bgcolor=\"#FFFFFF\">");sbContent.Append(dataObj.Items[i].Items[j].UnRouteDesc);sbContent.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#F7f7f7\">〖备　　注〗</td><td bgcolor=\"#FFFFFF\">");sbContent.Append(dataObj.Items[i].Items[j].Memo);sbContent.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#F4f4f4\">〖参考文献〗</td><td bgcolor=\"#FFFFFF\">");sbContent.Append(dataObj.Items[i].Items[j].Reference);sbContent.Append("</td></tr></table></span></td></tr>");}
sbContent.Append("<tr><td height=\"1\" colspan=\"3\" bgcolor=\"#dddddd\"></td></tr></table>");}
var divRouteResContentTable=document.createElement("div");divRouteResContentTable.innerHTML=sbContent.toString();if(dataObj.Items[i].ResType==1)
{$MediCom("McRouteResContentPanel1").appendChild(ShowRecipeCheckInfoToUser("警告：以下药品处方可能存在药品剂型和给药途径匹配问题"));$MediCom("McRouteResContentPanel1").appendChild(divRouteResContentTable);}
if(dataObj.Items[i].ResType==2)
{$MediCom("McRouteResContentPanel2").appendChild(divRouteResContentTable);}}}
$MediCom("McRouteResMenuPanel").innerHTML=sb.toString();}
function rbtnMcRouteResClick(index)
{if(index==1)
{$MediCom("McRouteResContentPanel1").style.display="block";$MediCom("McRouteResContentPanel2").style.display="none";}
else
{$MediCom("McRouteResContentPanel2").style.display="block";$MediCom("McRouteResContentPanel1").style.display="none";}}
﻿
var McDtDiData;var McDtDiItemCount=0;function CreateDtDiPanelInRecipeCheck(parentNode,dataObj)
{var divDtDiMenu=document.createElement("div");var divDtDiContent1=document.createElement("div");var divDtDiContent2=document.createElement("div");divDtDiMenu.id="McDtDiMenuPanel";divDtDiMenu.className="McDtDiMenu";divDtDiContent1.id="McDtDiContentPanel1";divDtDiContent1.className="McDtDiContent";divDtDiContent2.id="McDtDiContentPanel2";divDtDiContent2.className="McDtDiContent";$MediCom(parentNode).appendChild(divDtDiMenu);$MediCom(parentNode).appendChild(divDtDiContent1);$MediCom(parentNode).appendChild(divDtDiContent2);CreateDtDiRbtnMenuAndDataTable(dataObj);document.getElementsByName("rbtnMcDtDi")[0].checked="checked";rbtnMcDtDiClick(document.getElementsByName("rbtnMcDtDi")[0].value);}
function CreateDtDiRbtnMenuAndDataTable(dataObj)
{var sb=new StringBuilder();var count=dataObj.Items.length;for(var i=0;i<count;i++)
{var iCount=dataObj.Items[i].ItemCount;if(iCount>0)
{sb.Append("<label class=\"McDtDiMenuRBtn\"><input type=\"radio\" name=\"rbtnMcDtDi\" value=\"");sb.Append(dataObj.Items[i].CheckItem);sb.Append("\" onclick=\"rbtnMcDtDiClick(this.value);\" />");sb.Append(dataObj.Items[i].CheckItemDesc);sb.Append("(");sb.Append(dataObj.Items[i].ItemCount);sb.Append(")</label>");var sb2=new StringBuilder();for(var j=0;j<iCount;j++)
{sb2.Append("<table width=\"100%\" border=\"0\" cellpadding=\"1\" cellspacing=\"1\"><tr><td width=\"40\"><div style=\"float:left;\">");sb2.Append(j+1);sb2.Append(".</div><div class=\"DdimRemark_");sb2.Append(dataObj.Items[i].Items[j].WarningCode);sb2.Append("\" /></td><td colspan=\"2\">");sb2.Append(dataObj.Items[i].Items[j].Title);sb2.Append("</td></tr>");if(dataObj.Items[i].CheckItem==9)
{var sb3=new StringBuilder();var count3=dataObj.Items[i].Items[j].DrugItems.length;for(var x=0;x<count3;x++)
{sb3.Append("<tr><td bgcolor=\"#ffffff\">·");sb3.Append(dataObj.Items[i].Items[j].DrugItems[x].DrugDescription);sb3.Append("<br>　　--组成成分：");sb3.Append(dataObj.Items[i].Items[j].DrugItems[x].DrugIngd);sb3.Append("</td></tr>");}
sb2.Append("<tr><td>&nbsp;</td><td width=\"300\">重复成分：");sb2.Append(dataObj.Items[i].Items[j].BaseIngtDesc);sb2.Append("</td><td align=\"right\"><span id=\"moreInfoDtDiLabel_");sb2.Append(dataObj.Items[i].CheckItem);sb2.Append(dataObj.Items[i].Items[j].index);sb2.Append("\" onclick=\"OpenOrCloseMcPanel(");sb2.Append(dataObj.Items[i].CheckItem);sb2.Append(dataObj.Items[i].Items[j].index);sb2.Append(",'DtDi');\" class=\"label_Hide\" >详细信息[+]</span></td></tr><tr><td></td><td colspan=\"2\" height=\"0\" ><span id=\"ShowMoreInfoDtDiPanel_");sb2.Append(dataObj.Items[i].CheckItem);sb2.Append(dataObj.Items[i].Items[j].index);sb2.Append("\" class=\"showPanel_Hide\"><table width=\"100%\" border=\"0\" cellpadding=\"2\" cellspacing=\"1\" bgcolor=\"#f1f1f1\">");sb2.Append(sb3.toString());sb2.Append("</table></span></td></tr>");}
if(dataObj.Items[i].CheckItem==8)
{var sb4=new StringBuilder();var count4=dataObj.Items[i].Items[j].DrugItems.length;for(var x=0;x<count4;x++)
{sb4.Append("<tr><td bgcolor=\"#ffffff\">·");sb4.Append(dataObj.Items[i].Items[j].DrugItems[x].DrugDescription);sb4.Append("("+dataObj.Items[i].Items[j].DrugItems[x].RTDesc);sb4.Append(") <br>　　--通用名称：");sb4.Append(dataObj.Items[i].Items[j].DrugItems[x].GenDrugName);sb4.Append("</td></tr>");}
sb2.Append("<tr><td>&nbsp;</td><td width=\"300\">所属类别：");sb2.Append(dataObj.Items[i].Items[j].ClassDescription);sb2.Append("</td><td>重复容限：");sb2.Append(dataObj.Items[i].Items[j].Allowance);sb2.Append("</td></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td align=\"right\"><span id=\"moreInfoDtDiLabel_");sb2.Append(dataObj.Items[i].CheckItem);sb2.Append(dataObj.Items[i].Items[j].index);sb2.Append("\" onclick=\"OpenOrCloseDtDi(");sb2.Append(dataObj.Items[i].CheckItem);sb2.Append(dataObj.Items[i].Items[j].index);sb2.Append(");\" class=\"label_Hide\" >详细信息[+]</span></td></tr><tr><td></td><td colspan=\"2\" height=\"0\" ><span id=\"ShowMoreInfoDtDiPanel_");sb2.Append(dataObj.Items[i].CheckItem);sb2.Append(dataObj.Items[i].Items[j].index);sb2.Append("\" class=\"showPanel_Hide\"><table width=\"100%\" border=\"0\" cellpadding=\"2\" cellspacing=\"1\" bgcolor=\"#f1f1f1\">");sb2.Append(sb4.toString());sb2.Append("</table></span></td></tr>");}
sb2.Append("<tr><td height=\"1\" colspan=\"3\" bgcolor=\"#dddddd\"></td></tr></table>");}}
var divDtDiContent1Table=document.createElement("div");divDtDiContent1Table.innerHTML=sb2.toString();if(dataObj.Items[i].CheckItem==9)
{$MediCom("McDtDiContentPanel1").appendChild(ShowRecipeCheckInfoToUser("警告：以下各组处方药品含有相同的药物成分，可能存在重复用药"));$MediCom("McDtDiContentPanel1").appendChild(divDtDiContent1Table);}
if(dataObj.Items[i].CheckItem==8)
{$MediCom("McDtDiContentPanel2").appendChild(ShowRecipeCheckInfoToUser("警告：以下各组处方药品属于同一重复治疗分类，可能存在重复用药"));$MediCom("McDtDiContentPanel2").appendChild(divDtDiContent1Table);}}
$MediCom("McDtDiMenuPanel").innerHTML=sb.toString();}
function rbtnMcDtDiClick(index)
{if(index==9)
{$MediCom("McDtDiContentPanel1").style.display="block";$MediCom("McDtDiContentPanel2").style.display="none";}
else
{$MediCom("McDtDiContentPanel2").style.display="block";$MediCom("McDtDiContentPanel1").style.display="none";}}
function OpenOrCloseDtDi(id)
{var label=$MediCom("moreInfoDtDiLabel_"+id);var showPanel=$MediCom("ShowMoreInfoDtDiPanel_"+id);if(showPanel.className=="showPanel_Show")
{showPanel.className="showPanel_Hide";label.innerText="详细信息[+]";label.className="label_Hide";}
else
{if(showPanel.className=="showPanel_Hide")
{showPanel.className="showPanel_Show";label.innerText="详细信息[-]";label.className="label_Show";}}}
﻿
var McDosageResData;var McDosageResItemCount=0;function CreateDosageResPanelInRecipeCheck(parentNode,dataObj)
{var divDosageResMenu=document.createElement("div");var divDosageResContent=document.createElement("div");divDosageResMenu.className="McDosageResMenu";divDosageResMenu.style.height="10px";divDosageResContent.id="McDosageResContentPanel";divDosageResContent.className="McDosageResContent";$MediCom(parentNode).appendChild(divDosageResMenu);$MediCom(parentNode).appendChild(divDosageResContent);CreateDosageResRbtnMenuAndDataTable(dataObj);}
function CreateDosageResRbtnMenuAndDataTable(dataObj)
{var sb=new StringBuilder();var count=dataObj.Items.length;for(var i=0;i<count;i++)
{sb.Append("<table width=\"100%\" border=\"0\" cellpadding=\"1\" cellspacing=\"1\"><tr><td width=\"40\"><div style=\"float:left;\">");sb.Append(i+1);sb.Append(".</div><div class=\"DdimRemark_");sb.Append(dataObj.Items[i].WarningCode);sb.Append("\" /></td>");sb.Append("<td colspan=\"2\">");sb.Append(dataObj.Items[i].DrugDescription);sb.Append("（");sb.Append(dataObj.Items[i].Route);sb.Append("）</td></tr><tr><td>&nbsp;</td><td colspan=\"2\">年龄阶段：");sb.Append(dataObj.Items[i].AgeRangeDesc);sb.Append("</td></tr><tr><td>&nbsp;</td><td width=\"300\">体重范围：");sb.Append(dataObj.Items[i].WeightRangeDesc);sb.Append("</td><td>严重程度：");sb.Append(dataObj.Items[i].SLDesc);sb.Append("</td></tr><tr><td>&nbsp;</td><td colspan=\"2\">审查结果：");sb.Append(dataObj.Items[i].ScreenResult);sb.Append("</td></tr><tr><td>&nbsp;</td><td  colspan=\"2\" align=\"right\"><span id=\"moreInfoDosageResLabel_");sb.Append(i+1);sb.Append("\" onclick=\"OpenOrCloseDosageRes(");sb.Append(i+1);sb.Append(");\" class=\"label_Hide\" >详细信息[+]</span></td></tr><tr><td></td><td colspan=\"2\" height=\"0\" ><span id=\"ShowMoreInfoDosageResPanel_");sb.Append(i+1);sb.Append("\" class=\"showPanel_Hide\"><table width=\"100%\" border=\"0\" cellpadding=\"2\" cellspacing=\"1\" bgcolor=\"#eeeeee\"><tr><td colspan=\"3\">〖基本信息〗</td></tr><tr><td width=\"34%\" bgcolor=\"#FFFFFF\">出生日期：");sb.Append(dataObj.Items[i].Birthday);sb.Append("</td><td width=\"33%\" bgcolor=\"#FFFFFF\">身高：");sb.Append(dataObj.Items[i].Height);sb.Append("</td><td width=\"33%\" bgcolor=\"#FFFFFF\">体重：");sb.Append(dataObj.Items[i].Weight);sb.Append("</td></tr><tr><td bgcolor=\"#FFFFFF\">处方用量：");sb.Append(dataObj.Items[i].ActualPTime);sb.Append("</td><td colspan=\"2\" bgcolor=\"#FFFFFF\">");sb.Append(dataObj.Items[i].ActualPDay);sb.Append("</td></tr><tr><td bgcolor=\"#FFFFFF\">用药频率：");sb.Append(dataObj.Items[i].Frequency);sb.Append("</td><td colspan=\"2\" bgcolor=\"#FFFFFF\">用药持续时间：");sb.Append(dataObj.Items[i].UserDuration);sb.Append("</td></tr></table><table width=\"50\" height=\"3\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr><td></td></tr></table><table width=\"100%\" border=\"0\" cellpadding=\"2\" cellspacing=\"1\" bgcolor=\"#eeeeee\"><tr><td>〖审查结果〗</td></tr><tr><td bgcolor=\"#FFFFFF\">");sb.Append(dataObj.Items[i].ScreenResult);sb.Append("</td></tr></table><table width=\"50\" height=\"3\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr><td></td></tr></table><table width=\"100%\" border=\"0\" cellpadding=\"2\" cellspacing=\"1\" bgcolor=\"#eeeeee\"><tr><td colspan=\"2\">〖参考用法用量〗</td></tr><tr><td colspan=\"2\" bgcolor=\"#FFFFFF\">");sb.Append(dataObj.Items[i].DrugName);sb.Append("（");sb.Append(dataObj.Items[i].Route);sb.Append("）</td></tr><tr><td width=\"50%\" bgcolor=\"#FFFFFF\">年龄阶段：");sb.Append(dataObj.Items[i].AgeRangeDesc);sb.Append("</td><td width=\"50%\" bgcolor=\"#FFFFFF\">体重范围：");sb.Append(dataObj.Items[i].WeightRangeDesc);sb.Append("</td></tr><tr><td width=\"50%\" bgcolor=\"#FFFFFF\">常 用 量：");sb.Append(dataObj.Items[i].DoseEach);sb.Append("</td><td width=\"50%\" bgcolor=\"#FFFFFF\">");sb.Append(dataObj.Items[i].DoseDay);sb.Append("</td></tr><tr><td width=\"50%\" bgcolor=\"#FFFFFF\">极　　量：");sb.Append(dataObj.Items[i].MaxDoseEach);sb.Append("</td><td width=\"50%\" bgcolor=\"#FFFFFF\">");sb.Append(dataObj.Items[i].MaxDoseDay);sb.Append("</td></tr><tr><td colspan=\"2\" bgcolor=\"#FFFFFF\">用药频率：");sb.Append(dataObj.Items[i].UseFrequency);sb.Append("</td></tr><tr><td bgcolor=\"#FFFFFF\">常规用药持续时间：");sb.Append(dataObj.Items[i].Duration);sb.Append("</td><td bgcolor=\"#FFFFFF\">最大用药持续时间：");sb.Append(dataObj.Items[i].DurationMax);sb.Append("</td></tr></table><table width=\"50\" height=\"3\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr><td></td></tr></table><table width=\"100%\" border=\"0\" cellpadding=\"2\" cellspacing=\"1\" bgcolor=\"#eeeeee\"><tr><td>〖剂量调整参考信息〗</td></tr><tr><td bgcolor=\"#FFFFFF\">肝功能损害：");sb.Append(dataObj.Items[i].HepaticalDesc);sb.Append("</td></tr><tr><td bgcolor=\"#FFFFFF\">肾功能损害：");sb.Append(dataObj.Items[i].RenalDesc);sb.Append("</td></tr><tr><td bgcolor=\"#FFFFFF\">其它情况：");sb.Append(dataObj.Items[i].SpecialDesc);sb.Append("</td></tr></table><table width=\"50\" height=\"3\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr><td></td></tr></table><table width=\"100%\" border=\"0\" cellpadding=\"2\" cellspacing=\"1\" bgcolor=\"#eeeeee\"><tr><td colspan=\"2\">〖参考文献〗</td></tr><tr><td colspan=\"2\" bgcolor=\"#FFFFFF\">");sb.Append(dataObj.Items[i].Reference);sb.Append("</td></tr></table></span></td></tr><tr><td height=\"1\" colspan=\"3\" bgcolor=\"#dddddd\"></td></tr></table>");}
$MediCom("McDosageResContentPanel").innerHTML=sb.toString();}
function OpenOrCloseDosageRes(id)
{var label=$MediCom("moreInfoDosageResLabel_"+id);var showPanel=$MediCom("ShowMoreInfoDosageResPanel_"+id);if(showPanel.className=="showPanel_Show")
{showPanel.className="showPanel_Hide";label.innerText="详细信息[+]";label.className="label_Hide";}
else
{if(showPanel.className=="showPanel_Hide")
{showPanel.className="showPanel_Show";label.innerText="详细信息[-]";label.className="label_Show";}}}
﻿
var McGeriData;var McGeriItemCount;function CreateGeriWindow()
{var ppw=new PassPopWindowNew();ppw.Title="老人用药查询信息";ppw.mainID="MC_Geri_Main";ppw.headID="MC_Geri_Head";ppw.bodyID="MC_Geri_Body";ppw.CreatePanel();var divGeriMenu=document.createElement("div");var divGeriContent=document.createElement("div");var divGeriTitle=document.createElement("div");divGeriTitle.id="McGeriTitlePanel";divGeriTitle.className="McGeriTitle";divGeriMenu.id="McGeriMenuPanel";divGeriMenu.className="McGeriMenu";divGeriContent.id="McGeriContentPanel";divGeriContent.className="McGeriContent";$MediCom(ppw.bodyID).appendChild(divGeriTitle);$MediCom(ppw.bodyID).appendChild(divGeriMenu);$MediCom(ppw.bodyID).appendChild(divGeriContent);ShowLoadingInfo(divGeriMenu,"");ShowHideNew(ppw.mainID,null);}
function CreateGeriPanelInRecipeCheck(showPanel,DataObj)
{McGeriItemCount=DataObj.Items.length;var divMenu=document.createElement("div");divMenu.className="McGeriMenu";divMenu.style.height="10px";$MediCom(showPanel).appendChild(divMenu);var sb=new StringBuilder();var count=DataObj.Items.length;if(count>0)
McLactDataPostIn=DataObj;for(var i=0;i<count;i++)
{sb.Append("<table width=\"100%\" border=\"0\" cellpadding=\"1\" cellspacing=\"1\"><tr><td width=\"40\"><div style=\"float:left;\">");sb.Append(i+1);sb.Append(".</div><div class=\"DdimRemark_");sb.Append(DataObj.Items[i].WarningCode);sb.Append("\" /></td><td colspan=\"2\">");sb.Append(DataObj.Items[i].DrugDescription);sb.Append("（");sb.Append(DataObj.Items[i].RTDesc);sb.Append("）</td></tr><tr><td>&nbsp;</td><td width=\"300\">所属类别：");sb.Append(DataObj.Items[i].Description);sb.Append("</td><td>严重程度：");sb.Append(DataObj.Items[i].SLCodeShortDesc);sb.Append("</td></tr><tr><td>&nbsp;</td><td colspan=\"2\">关联病症：");sb.Append(DataObj.Items[i].LinkMedCond);sb.Append("</td></tr><tr><td>&nbsp;</td><td  colspan=\"2\" align=\"right\"><span id=\"moreInfoGeriLabel_");sb.Append(i+1);sb.Append("\" onclick=\"OpenOrCloseMcPanel(");sb.Append(i+1);sb.Append(", 'Geri');\" class=\"label_Hide\" >详细信息[+]</span></td></tr><tr><td></td><td colspan=\"2\" height=\"0\" ><span id=\"ShowMoreInfoGeriPanel_");sb.Append(i+1);sb.Append("\" class=\"showPanel_Hide\"><table width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"1\" bgcolor=\"#eeeeee\"><tr><td width=\"80\" align=\"center\" bgcolor=\"#f7f7f7\">〖给药方式〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(DataObj.Items[i].RTDesc);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#f7f7f7\">〖病生状态〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(DataObj.Items[i].MedConds);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#f7f7f7\">〖严重程度〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(DataObj.Items[i].SLCodeDesc);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#f7f7f7\">〖高危因素〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(DataObj.Items[i].SystemIndDesc);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#f7f7f7\">〖摘要信息〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(DataObj.Items[i].abstract);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#f7f7f7\">〖参考文献〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(DataObj.Items[i].reference);sb.Append("</td></tr></table></span></td></tr><tr><td height=\"1\" colspan=\"3\" bgcolor=\"#dddddd\"></td></tr></table>");}
var divPregContent=document.createElement("div");divPregContent.id="McRecipeCheckPregListPanel";divPregContent.className="McRecipeCheckPregListPanel";divPregContent.innerHTML=sb.toString();$MediCom(showPanel).appendChild(divPregContent);}
function CreateGeriList()
{var tempStr="";var sb=new StringBuilder();for(var i=0;i<McGeriItemCount;i++)
{sb.Append("<table width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"1\" bgcolor=\"#dedede\"><tr><td colspan=\"2\" bgcolor=\"#f4f4f4\"><b>第");sb.Append(i+1);sb.Append("条</b></td></tr><tr><td width=\"90\" align=\"center\" bgcolor=\"#FFFFFF\">〖所属类别〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McGeriData.Items[i].Description);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖给药方式〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McGeriData.Items[i].RTDesc);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖严重程度〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McGeriData.Items[i].SLCodeDesc);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖高危因素〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McGeriData.Items[i].SystemIndDesc);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖摘要信息〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McGeriData.Items[i].abstract);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖参考文献〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McGeriData.Items[i].reference);sb.Append("</td></tr></table><table width=\"50\" height=\"5\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr><td></td></tr></table>");}
$MediCom("McGeriContentPanel").innerHTML=sb.toString();}
function GetGeriListData(dqi)
{dqi.QueryType=4;if(CheckWebServiceIsEnable("GetGeriListData"))
{var client=new MC_client_request(0);client.ClearParam();client.AddParam("psDrugQueryJSONStr",$MediComH(dqi).toJSON());client.post("MDC_GetDrugQueryInfo",ShowGeriListCallBack);}
else
{ShowLoadingInfo("McGeriMenuPanel",McQueryInitError);}}
function ShowGeriListCallBack(result)
{if(!result.error)
{McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="老人用药";var showErrControlId="McGeriMenuPanel";if(!McBackErrInfoToUser(showErrControlId,result.value,errMsg))
{return;}
var f=new Function("McGeriData ="+result.value);f();McGeriItemCount=McGeriData.Items.length;ShowLoadingInfo("McGeriMenuPanel","<b>"+McGeriData.DrugDescription+"</b>&nbsp;&nbsp;&nbsp;（共有"+McGeriItemCount+"条详细信息）");if(McGeriData.Items.length>0)
{CreateGeriList();}
else
{McShowBackErrInfoToUser(showErrControlId,errMsg);return;}}}
function FuncGERI()
{CreateGeriWindow();GetGeriListData(GetModelByRowIndex(SelectedRowIndex));}
﻿
var McPediData;var McPediItemsCount;function CreatePediWindow()
{var ppw=new PassPopWindowNew();ppw.Title="儿童用药查询信息";ppw.mainID="MC_Pedi_Main";ppw.headID="MC_Pedi_Head";ppw.bodyID="MC_Pedi_Body";ppw.CreatePanel();var divPediMenu=document.createElement("div");var divPediContent=document.createElement("div");var divPediTitle=document.createElement("div");divPediTitle.id="McPediTitlePanel";divPediTitle.className="McPediTitle";divPediMenu.id="McPediMenuPanel";divPediMenu.className="McPediMenu";divPediContent.id="McPediContentPanel";divPediContent.className="McPediContent";$MediCom(ppw.bodyID).appendChild(divPediTitle);$MediCom(ppw.bodyID).appendChild(divPediMenu);$MediCom(ppw.bodyID).appendChild(divPediContent);ShowLoadingInfo(divPediMenu,"");ShowHideNew(ppw.mainID,null);}
function CreatePediPanelInRecipeCheck(showPanel,DataObj)
{McPediItemsCount=DataObj.Items.length;var divMenu=document.createElement("div");divMenu.className="McPediMenu";divMenu.style.height="10px";$MediCom(showPanel).appendChild(divMenu);var sb=new StringBuilder();var count=DataObj.Items.length;if(count>0)
McLactDataPostIn=DataObj;for(var i=0;i<count;i++)
{sb.Append("<table width=\"100%\" border=\"0\" cellpadding=\"1\" cellspacing=\"1\"><tr><td width=\"40\"><div style=\"float:left;\">");sb.Append(i+1);sb.Append(".</div><div class=\"DdimRemark_");sb.Append(DataObj.Items[i].WarningCode);sb.Append("\" /></td><td colspan=\"2\">");sb.Append(DataObj.Items[i].DrugDescription);sb.Append("（");sb.Append(DataObj.Items[i].RTDesc);sb.Append("）</td></tr><tr><td>&nbsp;</td><td width=\"300\">所属类别：");sb.Append(DataObj.Items[i].Description);sb.Append("</td><td>严重程度：");sb.Append(DataObj.Items[i].SLCodeShortDesc);sb.Append("</td></tr><tr><td>&nbsp;</td><td colspan=\"2\">年龄阶段：");sb.Append(DataObj.Items[i].AgeDesc);sb.Append("</td></tr><tr><td>&nbsp;</td><td  colspan=\"2\" align=\"right\"><span id=\"moreInfoPediLabel_");sb.Append(i+1);sb.Append("\" onclick=\"OpenOrCloseMcPanel(");sb.Append(i+1);sb.Append(",'Pedi');\" class=\"label_Hide\" >详细信息[+]</span></td></tr><tr><td></td><td colspan=\"2\" height=\"0\" ><span id=\"ShowMoreInfoPediPanel_");sb.Append(i+1);sb.Append("\" class=\"showPanel_Hide\"><table width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"1\" bgcolor=\"#eeeeee\"><tr><td width=\"90\" align=\"center\" bgcolor=\"#f7f7f7\">〖给药方式〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(DataObj.Items[i].RTDesc);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#f7f7f7\">〖严重程度〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(DataObj.Items[i].SLCodeDesc);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#f7f7f7\">〖摘要信息〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(DataObj.Items[i].abstract);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#f7f7f7\">〖参考文献〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(DataObj.Items[i].reference);sb.Append("</td></tr></table></span></td></tr><tr><td height=\"1\" colspan=\"3\" bgcolor=\"#dddddd\"></td></tr></table>");}
var divPregContent=document.createElement("div");divPregContent.id="McRecipeCheckPregListPanel";divPregContent.className="McRecipeCheckPregListPanel";divPregContent.innerHTML=sb.toString();$MediCom(showPanel).appendChild(divPregContent);}
function CreatePediList()
{var sb=new StringBuilder();for(var i=0;i<McPediItemsCount;i++)
{sb.Append("<table width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"1\" bgcolor=\"#dedede\"><tr><td colspan=\"2\" bgcolor=\"#f4f4f4\"><b>第");sb.Append(i+1);sb.Append("条</b></td></tr><tr><td width=\"90\" align=\"center\" bgcolor=\"#FFFFFF\">〖所属类别〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McPediData.Items[i].Description);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖给药方式〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McPediData.Items[i].RTDesc);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖严重程度〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McPediData.Items[i].SLCodeDesc);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖摘要信息〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McPediData.Items[i].abstract);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖参考文献〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McPediData.Items[i].reference);sb.Append("</td></tr></table><table width=\"50\" height=\"5\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr><td></td></tr></table>");}
$MediCom("McPediContentPanel").innerHTML=sb.toString();}
function GetPediListData(dqi)
{dqi.QueryType=6;if(CheckWebServiceIsEnable("GetPediListData"))
{var client=new MC_client_request(0);client.ClearParam();client.AddParam("psDrugQueryJSONStr",$MediComH(dqi).toJSON());client.post("MDC_GetDrugQueryInfo",ShowPediListCallBack);}
else
{ShowLoadingInfo("McPediMenuPanel",McQueryInitError);}}
function ShowPediListCallBack(result)
{if(!result.error)
{McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="儿童用药查询信息";var showErrControlId="McPediMenuPanel";if(!McBackErrInfoToUser(showErrControlId,result.value,errMsg))
{return;}
var f=new Function("McPediData ="+result.value);f();McPediItemsCount=McPediData.Items.length
ShowLoadingInfo("McPediMenuPanel","<b>"+McPediData.DrugDescription+"</b>&nbsp;&nbsp;&nbsp;（共有"+McPediItemsCount+"条详细信息）");if(McPediItemsCount>0)
{CreatePediList();}
else
{McShowBackErrInfoToUser(showErrControlId,errMsg);return;}}}
function FuncPEDI()
{CreatePediWindow();GetPediListData(GetModelByRowIndex(SelectedRowIndex));}
﻿
var McPregData;var McPregItemsCount;function CreatePregWindow()
{var ppw=new PassPopWindowNew();ppw.Title="妊娠用药查询信息";ppw.mainID="MC_Preg_Main";ppw.headID="MC_Preg_Head";ppw.bodyID="MC_Preg_Body";ppw.CreatePanel();var divPregMenu=document.createElement("div");var divPregContent=document.createElement("div");var divPregTitle=document.createElement("div");divPregTitle.id="McPregTitlePanel";divPregTitle.className="McPregTitle";divPregMenu.id="McPregMenuPanel";divPregMenu.className="McPregMenu";divPregContent.id="McPregContentPanel";divPregContent.className="McPregContent";$MediCom(ppw.bodyID).appendChild(divPregTitle);$MediCom(ppw.bodyID).appendChild(divPregMenu);$MediCom(ppw.bodyID).appendChild(divPregContent);ShowLoadingInfo(divPregMenu,"");ShowHideNew(ppw.mainID,null);}
function CreatePregPanelInRecipeCheck(showPanel,DataObj)
{McPregItemsCount=DataObj.Items.length;var divMenu=document.createElement("div");divMenu.className="McPregMenu";divMenu.style.height="10px";$MediCom(showPanel).appendChild(divMenu);var sb=new StringBuilder();var count=DataObj.Items.length;if(count>0)
McLactDataPostIn=DataObj;for(var i=0;i<count;i++)
{sb.Append("<table width=\"100%\" border=\"0\" cellpadding=\"1\" cellspacing=\"1\"><tr><td width=\"40\"><div style=\"float:left;\">");sb.Append(i+1);sb.Append(".</div><div class=\"DdimRemark_");sb.Append(DataObj.Items[i].WarningCode);sb.Append("\" /></td><td colspan=\"2\">");sb.Append(DataObj.Items[i].DrugDescription);sb.Append("（");sb.Append(DataObj.Items[i].RTDesc);sb.Append("）</td></tr><tr><td>&nbsp;</td><td width=\"300\">所属类别：");sb.Append(DataObj.Items[i].Description);sb.Append("</td><td>妊娠分级：");sb.Append(DataObj.Items[i].ShortSLCodeDesc);sb.Append("</td></tr><tr><td>&nbsp;</td><td colspan=\"2\">妊娠分期：");sb.Append(DataObj.Items[i].PregGrade);sb.Append("</td></tr><tr><td>&nbsp;</td><td  colspan=\"2\" align=\"right\"><span id=\"moreInfoPregLabel_");sb.Append(i+1);sb.Append("\" onclick=\"OpenOrCloseMcPanel(");sb.Append(i+1);sb.Append(",'Preg');\" class=\"label_Hide\" >详细信息[+]</span></td></tr><tr><td></td><td colspan=\"2\" height=\"0\" ><span id=\"ShowMoreInfoPregPanel_");sb.Append(i+1);sb.Append("\" class=\"showPanel_Hide\"><table width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"1\" bgcolor=\"#eeeeee\"><tr><td width=\"90\" align=\"center\" bgcolor=\"#FFFFFF\">〖给药方式〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(DataObj.Items[i].RTDesc);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖妊娠分级〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(DataObj.Items[i].SLCodeDesc);sb.Append("</td></tr>");if(DataObj.Items[i].SLLevelDesc!="")
{sb.Append("<tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖分级标准〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(DataObj.Items[i].SLLevelDesc);sb.Append("</td></tr>");}
sb.Append("<tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖摘要信息〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(DataObj.Items[i].abstract);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖参考文献〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(DataObj.Items[i].reference);sb.Append("</td></tr></table></span></td></tr><tr><td height=\"1\" colspan=\"3\" bgcolor=\"#dddddd\"></td></tr></table>");}
var divPregContent=document.createElement("div");divPregContent.id="McRecipeCheckPregListPanel";divPregContent.className="McRecipeCheckPregListPanel";divPregContent.innerHTML=sb.toString();$MediCom(showPanel).appendChild(divPregContent);}
function CreatePregList()
{var sb=new StringBuilder();for(var i=0;i<McPregItemsCount;i++)
{sb.Append("<table width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"1\" bgcolor=\"#dedede\"><tr><td colspan=\"2\" bgcolor=\"#f4f4f4\"><b>第");sb.Append(i+1);sb.Append("条</b></td></tr><tr><td width=\"90\" align=\"center\" bgcolor=\"#FFFFFF\">〖所属类别〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McPregData.Items[i].Description);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖给药方式〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McPregData.Items[i].RTDesc);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖妊娠分级〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McPregData.Items[i].SLCodeDesc);sb.Append("</td></tr>");if(McPregData.Items[i].SLLevelDesc!="")
{sb.Append("<tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖分级标准〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McPregData.Items[i].SLLevelDesc);sb.Append("</td></tr>");}
sb.Append("<tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖摘要信息〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McPregData.Items[i].abstract);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖参考文献〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McPregData.Items[i].reference);sb.Append("</td></tr></table><table width=\"50\" height=\"5\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr><td></td></tr></table>");}
$MediCom("McPregContentPanel").innerHTML=sb.toString();}
function GetPregListData(dqi)
{dqi.QueryType=7;if(CheckWebServiceIsEnable("GetPregListData"))
{var client=new MC_client_request(0);client.ClearParam();client.AddParam("psDrugQueryJSONStr",$MediComH(dqi).toJSON());client.post("MDC_GetDrugQueryInfo",ShowPregListCallBack);}
else
{ShowLoadingInfo("McPregMenuPanel",McQueryInitError);}}
function ShowPregListCallBack(result)
{if(!result.error)
{McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="妊娠用药查询信息";var showErrControlId="McPregMenuPanel";if(!McBackErrInfoToUser(showErrControlId,result.value,errMsg))
{return;}
var f=new Function("McPregData ="+result.value);f();McPregItemsCount=McPregData.Items.length;ShowLoadingInfo("McPregMenuPanel","<b>"+McPregData.DrugDescription+"</b>&nbsp;&nbsp;&nbsp;（共有"+McPregItemsCount+"条详细信息）");if(McPregItemsCount>0)
{CreatePregList();}
else
{McShowBackErrInfoToUser(showErrControlId,errMsg);return;}}}
function FuncPREG()
{CreatePregWindow();GetPregListData(GetModelByRowIndex(SelectedRowIndex));}
﻿var McLactData;var McLactItemsCount;var McLactDataPostIn;function CreateLactPanel()
{var ppw=new PassPopWindowNew();ppw.Title="哺乳用药查询信息";ppw.mainID="MC_Lact_Main";ppw.headID="MC_Lact_Head";ppw.bodyID="MC_Lact_Body";ppw.CreatePanel();var divLACTMenu=document.createElement("div");var divLACTContent=document.createElement("div");var divLACTTitle=document.createElement("div");divLACTTitle.id="McLactTitlePanel";divLACTTitle.className="McLactTitle";divLACTMenu.id="McLactMenuPanel";divLACTMenu.className="McLactMenu";divLACTContent.id="McLactContentPanel";divLACTContent.className="McLactContent";$MediCom(ppw.bodyID).appendChild(divLACTTitle);$MediCom(ppw.bodyID).appendChild(divLACTMenu);$MediCom(ppw.bodyID).appendChild(divLACTContent);ShowLoadingInfo(divLACTMenu,"");ShowHideNew(ppw.mainID,null);}
function CreateLactPanelInRecipeCheck(showPanel,dataObj)
{McLactItemsCount=dataObj.Items.length;var divMenu=document.createElement("div");divMenu.className="McLactMenu";divMenu.style.height="10px";$MediCom(showPanel).appendChild(divMenu);var sb=new StringBuilder();var count=dataObj.Items.length;if(count>0)
McLactDataPostIn=dataObj;for(var i=0;i<count;i++)
{sb.Append("<table width=\"100%\" border=\"0\" cellpadding=\"1\" cellspacing=\"1\"><tr><td width=\"40\"><div style=\"float:left;\">");sb.Append(i+1);sb.Append(".</div><div class=\"DdimRemark_");sb.Append(dataObj.Items[i].WarningCode);sb.Append("\" /></td><td colspan=\"2\">");sb.Append(dataObj.Items[i].DrugDescription);sb.Append("（");sb.Append(dataObj.Items[i].RTDesc);sb.Append("）</td></tr><tr><td>&nbsp;</td><td width=\"300\">所属类别：");sb.Append(dataObj.Items[i].Description);sb.Append("</td><td>严重程度：");sb.Append(dataObj.Items[i].SLCodeShortDesc);sb.Append("</td></tr><tr><td>&nbsp;</td><td  colspan=\"2\" align=\"right\"><span id=\"moreInfoLactLabel_");sb.Append(i+1);sb.Append("\" onclick=\"OpenOrCloseMcPanel(");sb.Append(i+1);sb.Append(",'Lact');\" class=\"label_Hide\" >详细信息[+]</span></td></tr><tr><td></td><td colspan=\"2\" height=\"0\" ><span id=\"ShowMoreInfoLactPanel_");sb.Append(i+1);sb.Append("\" class=\"showPanel_Hide\"><table width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"1\" bgcolor=\"#eeeeee\"><tr><td width=\"80\" align=\"center\" bgcolor=\"#f7f7f7\">〖给药方式〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(dataObj.Items[i].RTDesc);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#f7f7f7\">〖严重程度〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(dataObj.Items[i].SLCodeDesc);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#f7f7f7\">〖分泌效应〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(dataObj.Items[i].excreffect);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#f7f7f7\">〖哺乳效应〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(dataObj.Items[i].lacteffect);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#f7f7f7\">〖摘要信息〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(dataObj.Items[i].abstract);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#f7f7f7\">〖参考文献〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(dataObj.Items[i].reference);sb.Append("</td></tr></table></span></td></tr><tr><td height=\"1\" colspan=\"3\" bgcolor=\"#dddddd\"></td></tr></table>");}
var divLactContent=document.createElement("div");divLactContent.id="McRecipeCheckLactListPanel";divLactContent.className="McRecipeCheckLactListPanel";divLactContent.innerHTML=sb.toString();$MediCom(showPanel).appendChild(divLactContent);}
function GetLactListData(dqi)
{dqi.QueryType=5;if(CheckWebServiceIsEnable("GetLactListData"))
{var client=new MC_client_request(0);client.ClearParam();client.AddParam("psDrugQueryJSONStr",$MediComH(dqi).toJSON());client.post("MDC_GetDrugQueryInfo",ShowLactListCallBack);}
else
{ShowLoadingInfo("McLactMenuPanel",McQueryInitError);}}
function ShowLactListCallBack(result)
{if(!result.error)
{McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="哺乳用药查询信息";var showErrControlId="McLactMenuPanel";if(!McBackErrInfoToUser(showErrControlId,result.value,errMsg))
{return;}
var f=new Function("McLactData ="+result.value);f();McLactItemsCount=McLactData.Items.length;ShowLoadingInfo("McLactMenuPanel","<b>"+McLactData.DrugDescription+"</b>&nbsp;&nbsp;&nbsp;（共有"+McLactItemsCount+"条详细信息）");if(McLactItemsCount>0)
{CreateLactList();}
else{McShowBackErrInfoToUser(showErrControlId,errMsg);return;}}}
function CreateLactList()
{var sb=new StringBuilder();for(var i=0;i<McLactItemsCount;i++)
{sb.Append("<table width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"1\" bgcolor=\"#dedede\"><tr><td colspan=\"2\" bgcolor=\"#f4f4f4\"><b>第");sb.Append(i+1);sb.Append("条</b></td></tr><tr><td width=\"90\" align=\"center\" bgcolor=\"#FFFFFF\">〖所属类别〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McLactData.Items[i].Description);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖给药方式〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McLactData.Items[i].RTDesc);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖严重程度〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McLactData.Items[i].SLCodeDesc);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖分泌效应〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McLactData.Items[i].excreffect);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖哺乳效应〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McLactData.Items[i].lacteffect);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖摘要信息〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McLactData.Items[i].abstract);sb.Append("</td></tr><tr><td align=\"center\" bgcolor=\"#FFFFFF\">〖参考文献〗</td><td bgcolor=\"#FFFFFF\">");sb.Append(McLactData.Items[i].reference);sb.Append("</td></tr></table><table width=\"50\" height=\"5\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr><td></td></tr></table>");}
$MediCom("McLactContentPanel").innerHTML=sb.toString();}
function FuncLACT(){McLactDataPostIn=null;CreateLactPanel();GetLactListData(GetModelByRowIndex(SelectedRowIndex));}
﻿
var McDamData;function CreateDamPanelInRecipeCheck(parentNode)
{var divDamMenu=document.createElement("div");var divDamContent=document.createElement("div");divDamMenu.id="McDamMenuPanel";divDamMenu.className="McDamMenu";divDamContent.id="McDamContentPanel";divDamContent.className="McDamContent";$MediCom(parentNode).appendChild(divDamMenu);$MediCom(parentNode).appendChild(divDamContent);ShowLoadingInfo("McDamMenuPanel","");}
function ShowDamListCallBackInRecipeCheck(DataObj)
{McDamData=DataObj;$MediCom("McDamMenuPanel").outerHTML=ShowRecipeCheckInfoToUser("警告：根据病人药物过敏史记录，以下处方药品可能发生过敏反应").outerHTML;if(DataObj.ItemCount>0)
{CreateDamListInRecipeCheck(DataObj);}}
function CreateDamListInRecipeCheck(DataObj)
{var sb=new StringBuilder();var count=DataObj.ItemCount;for(var i=0;i<count;i++)
{sb.Append("<table width=\"100%\" border=\"0\" cellpadding=\"1\" cellspacing=\"1\"><tr><td width=\"40\"><div style=\"float:left;\">");sb.Append(i+1);sb.Append(".</div><div class=\"DdimRemark_");sb.Append(DataObj.Items[i].WarningCode);sb.Append("\" /></td><td colspan=\"2\">");sb.Append(DataObj.Items[i].DrugDescription);sb.Append("</td></tr><tr><td>&nbsp;</td><td width=\"300\">既往过敏原：");sb.Append(DataObj.Items[i].AllergenDesc);sb.Append("</td><td>关联类型：");sb.Append(DataObj.Items[i].SLCodeDesc);sb.Append("</td></tr><tr><td>&nbsp;</td><td  colspan=\"2\" align=\"right\"><span id=\"moreInfoDamLabel_");sb.Append(""+i);sb.Append("\" onclick=\"OpenOrCloseMcDamPanel(");sb.Append(i);sb.Append(",'Dam');\" class=\"label_Hide\" >详细信息[+]</span></td></tr><tr><td></td><td colspan=\"2\" height=\"0\" ><span id=\"ShowMoreInfoDamPanel_");sb.Append(i);sb.Append("\" class=\"showPanel_Hide\"> </span></td></tr><tr><td height=\"1\" colspan=\"3\" bgcolor=\"#dddddd\"></td></tr></table>");}
$MediCom("McDamContentPanel").innerHTML=sb.toString();}
var SetDamClickIndex=-1;function OpenOrCloseMcDamPanel(id,baseName)
{SetDamClickIndex=id;var label=$MediCom("moreInfo"+baseName+"Label_"+id);var showPanel=$MediCom("ShowMoreInfo"+baseName+"Panel_"+id);if(showPanel.className=="showPanel_Show")
{showPanel.className="showPanel_Hide";label.innerText="详细信息[+]";label.className="label_Hide";}
else
{if(showPanel.className=="showPanel_Hide")
{showPanel.className="showPanel_Show";label.innerText="详细信息[-]";label.className="label_Show";if(showPanel.innerHTML==McErrorMsg1||showPanel.innerHTML.length<100)
{GetDamArticleData(id);}}}}
function GetDamArticleData(index)
{if(CheckWebServiceIsEnable("GetDamArticleData"))
{var client=new MC_client_request(0);client.ClearParam();client.AddParam("piSLCode",parseInt(McDamData.Items[index].SLCode));client.AddParam("piMatchID",parseInt(McDamData.Items[index].MatchID));client.AddParam("psAllergenScrID",McDamData.Items[index].AllergenScrID);client.AddParam("psDrugScrID",McDamData.Items[index].DrugScrID);client.post("MDC_GetDAMDetail",DamDataCallBack);ShowLoadingInfo("ShowMoreInfoDamPanel_"+index,"");}
else
{ShowLoadingInfo("McDamMenuPanel",McQueryInitError);}}
function DamDataCallBack(result)
{if(!result.error)
{McShowDebugInfo(IsDebugResultValue,result.value,DebugShowPanel_ResultValue);var errMsg="非常遗憾，未找到相关数据！";var showPanel=$MediCom("ShowMoreInfoDamPanel_"+SetDamClickIndex);if(!McBackErrInfoToUser2(showPanel,result.value,errMsg))
{return;}
else
{showPanel.innerHTML=CreateDamMoreInfoStyle(result.value);}}}
function CreateDamMoreInfoStyle(str)
{var f=new Function("McDamMoreInfoData = "+str);f();var sb=new StringBuilder();sb.Append("<table width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"1\" bgcolor=\"#eeeeee\"><tr><td bgcolor=\"#FFFFFF\" width=\"50%\">既往过敏原：");sb.Append(McDamData.Items[SetDamClickIndex].AllergenDesc);sb.Append("</td><td bgcolor=\"#FFFFFF\"  width=\"50%\">处方药品：");sb.Append(McDamData.Items[SetDamClickIndex].DrugDescription);sb.Append("</td></tr><tr><td bgcolor=\"#FFFFFF\">&nbsp;&nbsp;——组成成分：");sb.Append(McDamMoreInfoData.AllergenIngd);sb.Append("</td><td bgcolor=\"#FFFFFF\">&nbsp;&nbsp;——组成成分：");sb.Append(McDamMoreInfoData.DrugIngd);sb.Append("</td></tr><tr><td bgcolor=\"#FFFFFF\">既往过敏症状：");sb.Append(McDamData.Items[SetDamClickIndex].Reaction);sb.Append("</td><td bgcolor=\"#FFFFFF\">过敏关联类型：");sb.Append(McDamData.Items[SetDamClickIndex].SLCodeDesc);sb.Append("&lt;");sb.Append(McDamData.Items[SetDamClickIndex].MatchDesc);sb.Append("&gt;</td></tr></table>");McDamMoreInfoData=null;return sb.toString();}
﻿ 
/*  RightMenu.js
*--------------------------------------------------------------------------*/

var HTMLstrRightMenu;
var BaseRightMenuText; 
var IsDirectShowMenu = false;
function RightMenu() {
    this.AddExtendMenu = AddExtendMenu;
    this.AddItem = AddItem;
    this.GetMenu = GetMenu;
    this.HideAll = HideAll;
    this.I_OnMouseOver = I_OnMouseOver;
    this.I_OnMouseOut = I_OnMouseOut;
    this.I_OnMouseUp = I_OnMouseUp;
    this.P_OnMouseOver = P_OnMouseOver;
    this.P_OnMouseOut = P_OnMouseOut;
    A_rbpm = new Array();
    var sb = new StringBuilder();
    sb.Append("<div id='E_rbpm' class='RightMenuDiv' style='z-index:100000;width:200px;height:auto;left:100px;top:100px;position:absolute;'>\n");
    // rbpm = right button pop menu
    sb.Append("<table border='0' cellspacing='0'  width='100%'>\n");
    sb.Append("<tr><td width='20px' valign='middle'  bgcolor='#0099cc' onclick=window.event.cancelBubble=true; class='info'>美康合理用药\n");
    sb.Append("</td><td width='200px' style='padding: 1' valign='top'>\n");
    sb.Append("<table width='100%' border='0' cellspacing='0'>\n");
    sb.Append("<!-- Insert A Extend Menu or Item On Here For E_rbpm -->\n"); //all the munu in the table
    sb.Append("</table></td></tr></table>\n</div>"); 
    sb.Append("<!-- Insert A Extend_Menu Area on Here For E_rbpm -->\n");     
	sb.Append("<div id='E_rbpmbg' style='z-index:99999;position:absolute;filter:alpha(opacity=40);'>")
    sb.Append("<iframe class='mc_iframe_bg'></iframe></div>\n");
    sb.Append("<!-- PopMenu Ends -->\n");
    HTMLstrRightMenu = sb.toString();    
}

function AddExtendMenu(id, img, wh, name, parent) {
    var sb = new StringBuilder();
    eval("A_" + parent + ".length++");
    eval("A_" + parent + "[A_" + parent + ".length-1] = id");  // add the memnu into the parent id
    sb.Append("<div id='test'><div id='E_");
    sb.Append(id);
    sb.Append("' class='RightMenuDiv' style='z-index:100000;width:180px;height:auto;left:100px;top:100px;position:absolute;'>\n");
    sb.Append("<table width='100%' border='0' cellspacing='0'>\n");
    sb.Append("<!-- Insert A Extend Menu or Item On Here For E_");
    sb.Append(id);
    sb.Append(" -->");
    sb.Append("</table>\n");
    sb.Append("</div>\n");
    sb.Append("<!-- Insert A Extend_Menu Area on Here For E_");
    sb.Append(id);
    sb.Append(" -->");
    sb.Append("<!-- Insert A Extend_Menu Area on Here For E_");
    sb.Append(parent);
    sb.Append(" -->");	
    sb.Append("</div><div id='E_rbpmbg2' style='z-index:99999;width:200px;height:400px;position:absolute;filter:alpha(opacity=40);'>");
    sb.Append("<iframe class='mc_iframe_bg'></iframe></div>\n");	
    HTMLstrRightMenu = HTMLstrRightMenu.replace("<!-- Insert A Extend_Menu Area on Here For E_" + parent + " -->", sb.toString());
    eval("A_" + id + " = new Array()");
    var sb2 = new StringBuilder();
    sb2.Append("<!-- Extend Item : P_");
    sb2.Append(id);
    sb2.Append(" -->\n");
    sb2.Append("<tr id='P_");
    sb2.Append(id);
    sb2.Append("' class='out'");
    sb2.Append(" onmouseover='P_OnMouseOver(\"");
    sb2.Append(id);
    sb2.Append("\",\"");
    sb2.Append(parent);
    sb2.Append("\")'");
    sb2.Append(" onmouseout='P_OnMouseOut(\"");
    sb2.Append(id);
    sb2.Append("\",\"");
    sb2.Append(parent);
    sb2.Append("\")'");
    sb2.Append(" onmouseup=window.event.cancelBubble=true;");
    sb2.Append(" onclick=window.event.cancelBubble=true;");
    sb2.Append("><td nowrap>");
    sb2.Append("<font face='Wingdings' style='font-size:18px'>0</font> ");
    sb2.Append(name);
    sb2.Append("</td><td style='font-family: webdings; text-align: ;'>4");
    sb2.Append("</td></tr>\n");
    sb2.Append("<!-- Insert A Extend Menu or Item On Here For E_");
    sb2.Append(parent);
    sb2.Append(" -->");
    HTMLstrRightMenu = HTMLstrRightMenu.replace("<!-- Insert A Extend Menu or Item On Here For E_" + parent + " -->", sb2.toString());
}
function AddItem(id, img, wh, name, parent, location) {    
    var sb = new StringBuilder();
    var ItemStr = "<!-- ITEM : I_" + id + " -->";
    if (id == "sperator") {
        sb.Append(ItemStr);
        sb.Append("\n <tr class='out' onclick='window.event.cancelBubble=true;' onmouseup='window.event.cancelBubble=true;'><td colspan='2' height='1'><hr class='sperator'></td></tr>");
        sb.Append("<!-- Insert A Extend Menu or Item On Here For E_");
        sb.Append(parent);
        sb.Append(" -->");
        HTMLstrRightMenu = HTMLstrRightMenu.replace("<!-- Insert A Extend Menu or Item On Here For E_" + parent + " -->", sb.toString());
        return;
    }

    if (HTMLstrRightMenu.indexOf(ItemStr) != -1) {
        alert("I_" + id + "already exist!");
        return;
    }
    sb.Append(ItemStr + "\n");
    sb.Append("<tr><td>  ");
    sb.Append("<div id='I_");  
    sb.Append(id);
    if (location != "Disable")
    { sb.Append("' class='out'"); }
    else
    { sb.Append("' class='disable'"); }
    sb.Append(" onmouseover='I_OnMouseOver(\"");
    sb.Append(id);
    sb.Append("\",\"");
    sb.Append(parent);
    sb.Append("\",\"");
    sb.Append(location);
    sb.Append("\")'");
    sb.Append(" onmouseout='I_OnMouseOut(\"");
    sb.Append(id);
    sb.Append("\",\"");
    sb.Append(location);
    sb.Append("\")'");
    sb.Append(" onclick='window.event.cancelBubble=true;'");
    if (location == null) {
        sb.Append(" onmouseup='I_OnMouseUp(\"");
        sb.Append(id);
        sb.Append("\",\"");
        sb.Append(parent);
        sb.Append("\",null)'");
    }
    else {
        sb.Append(" onmouseup='I_OnMouseUp(\"");
        sb.Append(id);
        sb.Append("\",\"");
        sb.Append(parent);
        sb.Append("\",\"");
        sb.Append(location);
        sb.Append("\")'");
    }
    sb.Append(">");    
    sb.Append("<div class='GifText'>");
    sb.Append(wh);  
    sb.Append("</div> ");
    sb.Append("<div class='MenuText'>");    
    sb.Append(name);
    sb.Append(" </div> </div> </td></tr>");
    sb.Append("<!-- Insert A Extend Menu or Item On Here For E_");
    sb.Append(parent);
    sb.Append(" -->");
    HTMLstrRightMenu = HTMLstrRightMenu.replace("<!-- Insert A Extend Menu or Item On Here For E_" + parent + " -->", sb.toString());
}

function GetMenu() {
    return HTMLstrRightMenu;
}

function I_OnMouseOver(id, parent, location) {
    if (parent != "rbpm") {
        var ParentItem;
        ParentItem = $MediCom("P_" + parent);
        ParentItem.className = "over";
    }
    var Item = $MediCom("I_" + id);
    if (location != "Disable")
        Item.className = "over";   
    HideAll(parent, 1);
}

function I_OnMouseOut(id, location) {
    var Item = $MediCom("I_" + id);
    if (location != "Disable")
        Item.className = "out";      
}

function I_OnMouseUp(id, parent, location) {
    var ParentMenu;
    window.event.cancelBubble = true;
    OnClick();
    ParentMenu = $MediCom("E_" + parent);
    ParentMenu.display = "none";
    if (location == null)
        eval("Do_" + id + "();");
    else {
        if (location != "Disable")
            eval(location);
    }
}

function P_OnMouseOver(id, parent) {
    var Item;
    var Extend;
    var Parent;
    if (parent != "rbpm") {
        var ParentItem;
        ParentItem = $MediCom("P_" + parent);
        ParentItem.className = "over";
    }
    HideAll(parent, 1);
    Item = $MediCom("P_" + id);
    Extend = $MediCom("E_" + id);
    Parent = $MediCom("E_" + parent);
    Item.className = "over";
    Extend.style.display = "block";
    Extend.style.posLeft = document.body.scrollLeft + Parent.offsetLeft + Parent.offsetWidth - 4;
    if (Extend.style.posLeft + Extend.offsetWidth > document.body.scrollLeft + document.body.clientWidth)
        Extend.style.posLeft = Extend.style.posLeft - Parent.offsetWidth - Extend.offsetWidth + 8;
    if (Extend.style.posLeft < 0) Extend.style.posLeft = document.body.scrollLeft + Parent.offsetLeft + Parent.offsetWidth;
    Extend.style.posTop = Parent.offsetTop + Item.offsetTop + 1;
    if (Extend.style.posTop + Extend.offsetHeight > document.body.scrollTop + document.body.clientHeight)
        Extend.style.posTop = document.body.scrollTop + document.body.clientHeight - Extend.offsetHeight;
    if (Extend.style.posTop < 0) Extend.style.posTop = 0;
    
    var PopMenubg2 = $MediCom("E_rbpmbg2");
    PopMenubg2.style.left = Extend.style.posLeft;
    PopMenubg2.style.top = Extend.style.posTop;
    PopMenubg2.style.height = Extend.offsetHeight + "px";
    PopMenubg2.style.width =  Extend.offsetWidth  + "px";
    PopMenubg2.style.display = "block";
}

function P_OnMouseOut(id, parent) {    
}

function HideAll(id, flag) {
    var Area;
    var Temp;
    var i;
    if (!flag) {
        Temp = $MediCom("E_" + id);
        Temp.style.display = "none"; 
    }
    Area = eval("A_" + id);
    if (Area.length) {
        var PopMenubg = $MediCom("E_rbpmbg2");    
            PopMenubg.style.display = "none";
    
        for (i = 0; i < Area.length; i++) {
            HideAll(Area[i], 0);
            Temp = $MediCom("E_" + Area[i]);
            Temp.style.display = "none";
            Temp = $MediCom("P_" + Area[i]);
            Temp.className = "out";           
        }
    }
}
 
function PopRightMenuAtTrueStation() {
    var x = -1;
    var y = -1;
    var PopMenu = $MediCom("E_rbpm");
    HideAll("rbpm", 0);
    if (IsDirectShowMenu == false)
        PopMenu.innerHTML = BaseRightMenuText;   
    PopMenu.style.display = "block";
    $MediCom("E_rbpmbg").style.display = "block";       
    var offsetHeight = document.documentElement.offsetHeight;
    var clientWidth = document.documentElement.clientWidth;
    var clientHeight = document.documentElement.clientHeight;
    var clientTop = document.documentElement.clientTop;
    var clientLeft = document.documentElement.clientLeft;
    var scrollLeft = document.documentElement.scrollLeft;
    var scrollTop = document.documentElement.scrollTop;
    if (clientTop == 0)
        clientTop = document.body.clientTop;
    if (clientLeft == 0)
        clientLeft = document.body.clientLeft;
    if (scrollLeft == 0)
        scrollLeft = document.body.scrollLeft;
    if (scrollTop == 0)
        scrollTop = document.body.scrollTop;
    if (clientHeight == 0)
        clientHeight = document.body.clientHeight;
    if (clientWidth == 0)
        clientWidth = document.body.clientWidth;
    if (offsetHeight == 0)
        offsetHeight = document.body.offsetHeight;
    if (arguments.length == 2) 
    {
        x = arguments[0];
        y = arguments[1];
        if (x <= 0 || y <= 0) {
            x = window.event.clientX + scrollLeft;
            y = window.event.clientY + scrollTop;
        }
    }
    else {
        x = window.event.clientX + scrollLeft - clientLeft + 20; 
        y = window.event.clientY + scrollTop - clientTop;
        if (offsetHeight - window.event.clientY < 100)
            y = offsetHeight + scrollTop - 200;
    }
    if (x < 0)
        x = 0;
    if (y < 0)
        y = 0;
    PopMenu.style.left = x + "px";
    PopMenu.style.top = y + "px";
    var PopMenubg = $MediCom("E_rbpmbg");
    PopMenubg.style.left = x + "px";
    PopMenubg.style.top = y + "px";
    PopMenubg.style.height = PopMenu.offsetHeight + "px";
    PopMenubg.style.width  = PopMenu.offsetWidth  + "px";	
}

function OnMouseUpRightMenu(rowIndex, id) {
    var isNeedRightButtonClick;
    if (arguments.length >= 3) 
    {
        isNeedRightButtonClick = Boolean(arguments[2]);
        if (isNeedRightButtonClick) 
        {
            if (window.event.button != 2) {
                return;
            }
        }
    }
  
    if (SelectedRowIndex == rowIndex)
        IsDirectShowMenu = true;  
    if (arguments.length == 5)
    {
        var x = arguments[3];
        var y = arguments[4];
        PopRightMenuAtTrueStation(x, y);
    }
    else {
        PopRightMenuAtTrueStation();

    }
    if (SelectedRowIndex != rowIndex) 
    {
        SelectedRowIndex = rowIndex;
        GetRightMenuItemState(GetModelByRowIndex(SelectedRowIndex));
    }    
    SelectedID = id;
}


function GetRightMenuItemState(dqi) 
{      
    if (CheckWebServiceIsEnable("GetRightMenuItemState"))
    {       
        var client = new MC_client_request(0);
        client.ClearParam();
        client.AddParam("psDrugCode", dqi.DrugCode);
        client.AddParam("psDrugType", dqi.DrugType);
        client.AddParam("psDoseUnit", dqi.DoseUnit);
        client.AddParam("psRTCode", dqi.RouteID);
        client.AddParam("psRTType", dqi.RouteType);
        client.post("MDC_GetEnabledMenu", CreateRightMenuByData);
    }
}

function OnClick() { 
    HideAll("rbpm", 0);   
    $MediCom("E_rbpmbg2").style.display = "none";	
	//useful
	var PopMenubg = $MediCom("E_rbpmbg");
    PopMenubg.style.left ="1px";
    PopMenubg.style.top ="1px";
    PopMenubg.style.height = "1px";
    PopMenubg.style.width  = "1px";   
}

function GetMenuTrueLinkInfoStr(str, remark) {
    if (remark == 1)
        return str;
    else
        return "Disable";
}
this.RightMenuItemState = function () {
    this.ID = "";
    this.State = "";
}
function CreateRightMenuByData(result) {  
    if (!result.error) {      
        McShowDebugInfo(IsDebugResultValue, result.value, DebugShowPanel_ResultValue); 
		if (!McBackErrInfoToUser("ddddasdf", result.value, "右键菜单状态")) {
            return;
        } 
        var f = new Function("menuJsonData = {" + result.value + "};");
        f();
        var stateArray = $MediComH(menuJsonData).toArray();
        var count = stateArray.length;
        var item;
        var arrRightMenuItemState = new Array();
        var arr;
        for (var i = 0; i < count; i++) {
            item = new RightMenuItemState();
            arr = stateArray[i].toString().split(",");
            item.ID = arr[0];
            item.State = arr[1];
            arrRightMenuItemState[arrRightMenuItemState.length] = item;
        }
        ChangeRightMenuItemState(arrRightMenuItemState);
    }
    else { 
        return;
    }
}

function CreateBaseRightMenuText() {
    var menu = new RightMenu(); 
    menu.AddItem("CPRRes", "suan", "+", "药物专论", "rbpm", "Disable");
    menu.AddItem("CPERes", "suan", "+", "病人用药教育", "rbpm", "Disable");
    menu.AddItem("Directions", "suan", "+", "药品说明书", "rbpm", "Disable");
    menu.AddItem("CheckRes", "suan", "+", "药物对检验值的影响", "rbpm", "Disable");
    menu.AddItem("CHP", "suan", "+", "中国药典", "rbpm", "Disable");
    menu.AddExtendMenu("m5", "start_pro", "24", "专项信息", "rbpm", null);
    menu.AddItem("DDIM", "suan", "+", "药物-药物相互作用&nbsp;", "m5", "Disable");
    menu.AddItem("DFIM", "suan", "+", "药物-食物相互作用&nbsp;", "m5", "Disable");
    menu.AddItem("sperator", "", "", "", "m5", null);
    menu.AddItem("MatchRes", "suan", "+", "国内注射剂配伍", "m5", "Disable");
    menu.AddItem("sperator", "", "", "", "m5", null);
    menu.AddItem("DDCM", "suan", "+", "药物禁忌", "m5", "Disable");
    menu.AddItem("SIDE", "suan", "+", "不良反应", "m5", "Disable");
    menu.AddItem("sperator", "", "", "", "m5", null);
    menu.AddItem("GERI", "suan", "+", "老年用药", "m5", "Disable");
    menu.AddItem("PEDI", "suan", "+", "儿童用药", "m5", "Disable");
    menu.AddItem("PREG", "suan", "+", "妊娠用药", "m5", "Disable");
    menu.AddItem("LACT", "suan", "+", "哺乳用药", "m5", "Disable");    
    document.writeln(menu.GetMenu());
    BaseRightMenuText = $MediCom("E_rbpm").innerHTML;
    document.onclick = OnClick; 
    $MediCom("E_rbpmbg2").style.display = "none";
}


//get the menu text by id
function GetRightMenuItemTextByID(ID) { 
      switch (ID) {
        case "DDIM":return "药物-药物相互作用";
        case "DFIM":return "药物-食物相互作用";
        case "GERI":return "老人用药";
        case "LACT":return "哺乳用药";
        case "PEDI":return "儿童用药";
        case "PREG":return "妊娠用药";
        case "DDCM":return "药物禁忌";
        case "SIDE":return "不良反应";
        case "CPRRes":return "药物专论";
        case "CheckRes":return "药物对检验值的影响";
        case "MatchRes":return "国内注射剂配伍";
        case "CPERes":return "病人用药教育";
        case "Directions":return "药品说明书";
        case "CHP":return "中国药典";
        default:return "";
    } 
}

function GetRightMenuItemFatherIDByID(ID) { 
    switch (ID) {
        case "DDIM": return "m5";
        case "DFIM": return "m5";
        case "GERI": return "m5";
        case "LACT": return "m5";
        case "PEDI": return "m5";
        case "PREG": return "m5";
        case "DDCM": return "m5";
        case "SIDE": return "m5";
        case "CPRRes": return "rbpm";
        case "CheckRes": return "rbpm";
        case "MatchRes": return "m5";
        case "CPERes": return "rbpm";
        case "Directions": return "rbpm";
        case "CHP":return "rbpm";
        default:return "";
    }
}

function ChangeRightMenuItemState(obj) {
    var count = obj.length;   
    for (var i = 0; i < count; i++) {
        var o = $MediCom("I_" + obj[i].ID)
        if (o != null)
            o.outerHTML = GetTrOuterHTML(obj[i].ID, GetRightMenuItemTextByID(obj[i].ID), GetRightMenuItemFatherIDByID(obj[i].ID), obj[i].State);       
    }   
}

this.RightMenuItem = function () { this.ItemID = "";this.ItemText = "";this.EnableValue = "";}

function GetTrOuterHTML(ItemID, ItemText, FatherID, backRemark) {  
    var sb = new StringBuilder();
    if (backRemark == "0") {
        sb.Append("<div id='I_");
        sb.Append(ItemID);
        sb.Append("' class='disable'><div class='GifText'>+</div> <div class='MenuText'> ");
        sb.Append(ItemText);
        sb.Append(" </div></div>");
        return sb.toString();
    }
    else {
        sb.Append("<div id='I_");
        sb.Append(ItemID);
        sb.Append("' class='out' onmouseover='I_OnMouseOver(\"");
        sb.Append(ItemID);
        sb.Append("\",\"");
        sb.Append(FatherID);
        sb.Append("\",\"Func");
        sb.Append(ItemID);
        sb.Append("();\")' onmouseout='I_OnMouseOut(\"");
        sb.Append(ItemID);
        sb.Append("\",\"Func");
        sb.Append(ItemID);
        sb.Append("();\")' onclick='window.event.cancelBubble=true;' onmouseup='I_OnMouseUp(\"");
        sb.Append(ItemID);
        sb.Append("\",\"");
        sb.Append(FatherID);
        sb.Append("\",\"Func");
        sb.Append(ItemID);
        sb.Append("();\")'> <div class='GifText'>+</div> <div class='MenuText'> ");
        sb.Append(ItemText);
        sb.Append(" </div> </div>");
        return sb.toString();
    }
} 
CreateBaseRightMenuText(); 