webpackJsonp([16],{UBQj:function(e,t,n){"use strict";var r={};function o(){try{return new window.XMLHttpRequest}catch(e){}}r._getBinaryFromXHR=function(e){return e.response||e.responseText};var i="undefined"!=typeof window&&window.ActiveXObject?function(){return o()||function(){try{return new window.ActiveXObject("Microsoft.XMLHTTP")}catch(e){}}()}:o;r.getBinaryContent=function(e,t){var n,o,a,s;t||(t={}),"function"==typeof t?(s=t,t={}):"function"==typeof t.callback&&(s=t.callback),s||"undefined"==typeof Promise?(o=function(e){s(null,e)},a=function(e){s(e,null)}):n=new Promise(function(e,t){o=e,a=t});try{var c=i();c.open("GET",e,!0),"responseType"in c&&(c.responseType="arraybuffer"),c.overrideMimeType&&c.overrideMimeType("text/plain; charset=x-user-defined"),c.onreadystatechange=function(t){if(4===c.readyState)if(200===c.status||0===c.status)try{o(r._getBinaryFromXHR(c))}catch(e){a(new Error(e))}else a(new Error("Ajax error for "+e+" : "+this.status+" "+this.statusText))},t.progress&&(c.onprogress=function(n){t.progress({path:e,originalEvent:n,percent:n.loaded/n.total*100,loaded:n.loaded,total:n.total})}),c.send()}catch(e){a(new Error(e),null)}return n},e.exports=r}});