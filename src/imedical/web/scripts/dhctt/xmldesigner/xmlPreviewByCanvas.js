!function(){"use strict";var XML=function(){};(XML.ObjTree=function(){return this}).VERSION="0.23",XML.ObjTree.prototype.xmlDecl='<?xml version="1.0" encoding="gb2312" ?>\n',XML.ObjTree.prototype.attr_prefix="-",XML.ObjTree.prototype.parseXML=function(t){var e;if(window.DOMParser){var n=new DOMParser,r=n.parseFromString(t,"application/xml");if(!r)return;e=r.documentElement}else window.ActiveXObject&&((n=new ActiveXObject("Microsoft.XMLDOM")).async=!1,n.loadXML(t),e=n.documentElement);if(e)return this.parseDOM(e)},XML.ObjTree.prototype.parseHTTP=function(t,e,n){var r,a={};for(var o in e)a[o]=e[o];if(a.method||("undefined"==typeof a.postBody&&"undefined"==typeof a.postbody&&"undefined"==typeof a.parameters?a.method="get":a.method="post"),n){a.asynchronous=!0;var i=this,s=n,l=a.onComplete;a.onComplete=function(t){var e;t&&t.responseXML&&t.responseXML.documentElement&&(e=i.parseDOM(t.responseXML.documentElement)),s(e,t),l&&l(t)}}else a.asynchronous=!1;if("undefined"!=typeof HTTP&&HTTP.Request)a.uri=t,(h=new HTTP.Request(a))&&(r=h.transport);else if("undefined"!=typeof Ajax&&Ajax.Request){var h;(h=new Ajax.Request(t,a))&&(r=h.transport)}return n?r:r&&r.responseXML&&r.responseXML.documentElement?this.parseDOM(r.responseXML.documentElement):void 0},XML.ObjTree.prototype.parseDOM=function(t){if(t){if(this.__force_array={},this.force_array)for(var e=0;e<this.force_array.length;e++)this.__force_array[this.force_array[e]]=1;var n=this.parseElement(t);if(this.__force_array[t.nodeName]&&(n=[n]),11!=t.nodeType){var r={};r[t.nodeName]=n,n=r}return n}},XML.ObjTree.prototype.parseElement=function(t){if(7!=t.nodeType){if(3==t.nodeType||4==t.nodeType){if(null==t.nodeValue.match(/[^\x00-\x20]/))return;return t.nodeValue}var e,n={};if(t.attributes&&t.attributes.length){e={};for(var r=0;r<t.attributes.length;r++){if("string"==typeof(i=t.attributes[r].nodeName))(s=t.attributes[r].nodeValue)&&("undefined"==typeof n[i=this.attr_prefix+i]&&(n[i]=0),n[i]++,this.addNode(e,i,n[i],s))}}if(t.childNodes&&t.childNodes.length){var a=!0;e&&(a=!1);for(r=0;r<t.childNodes.length&&a;r++){var o=t.childNodes[r].nodeType;3!=o&&4!=o&&(a=!1)}if(a){e||(e="");for(r=0;r<t.childNodes.length;r++)e+=t.childNodes[r].nodeValue}else{e||(e={});for(r=0;r<t.childNodes.length;r++){var i,s;if("string"==typeof(i=t.childNodes[r].nodeName))(s=this.parseElement(t.childNodes[r]))&&("undefined"==typeof n[i]&&(n[i]=0),n[i]++,this.addNode(e,i,n[i],s))}}}return e}},XML.ObjTree.prototype.addNode=function(t,e,n,r){this.__force_array[e]?(1==n&&(t[e]=[]),t[e][t[e].length]=r):1==n?t[e]=r:2==n?t[e]=[t[e],r]:t[e][t[e].length]=r},XML.ObjTree.prototype.writeXML=function(t){var e=this.hash_to_xml(null,t);return this.xmlDecl+e},XML.ObjTree.prototype.hash_to_xml=function(t,e){var n=[],r=[];for(var a in e)if(e.hasOwnProperty(a)){var o=e[a];a.charAt(0)!=this.attr_prefix?void 0===o||null==o?n[n.length]="<"+a+" />":"object"==typeof o&&o.constructor==Array?n[n.length]=this.array_to_xml(a,o):n[n.length]="object"==typeof o?this.hash_to_xml(a,o):this.scalar_to_xml(a,o):r[r.length]=" "+a.substring(1)+'="'+this.xml_escape(o)+'"'}var i=r.join(""),s=n.join("");return void 0===t||null==t||(s=n.length>0?s.match(/\n/)?"<"+t+i+">\n"+s+"</"+t+">\n":"<"+t+i+">"+s+"</"+t+">\n":"<"+t+i+" />\n"),s},XML.ObjTree.prototype.array_to_xml=function(t,e){for(var n=[],r=0;r<e.length;r++){var a=e[r];void 0===a||null==a?n[n.length]="<"+t+" />":"object"==typeof a&&a.constructor==Array?n[n.length]=this.array_to_xml(t,a):n[n.length]="object"==typeof a?this.hash_to_xml(t,a):this.scalar_to_xml(t,a)}return n.join("")},XML.ObjTree.prototype.scalar_to_xml=function(t,e){return"#text"==t?this.xml_escape(e):"<"+t+">"+this.xml_escape(e)+"</"+t+">\n"},XML.ObjTree.prototype.xml_escape=function(t){return(t+"").replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;")};var t=[[0," "," ","00","212222","11011001100"],[1,"!","!","01","222122","11001101100"],[2,'"','"',"02","222221","11001100110"],[3,"#","#","03","121223","10010011000"],[4,"$","$","04","121322","10010001100"],[5,"%","%","05","131222","10001001100"],[6,"&","&","06","122213","10011001000"],[7,"'","'","07","122312","10011000100"],[8,"(","(","08","132212","10001100100"],[9,")",")","09","221213","11001001000"],[10,"*","*","10","221312","11001000100"],[11,"+","+","11","231212","11000100100"],[12,",",",","12","112232","10110011100"],[13,"-","-","13","122132","10011011100"],[14,".",".","14","122231","10011001110"],[15,"/","/","15","113222","10111001100"],[16,"0","0","16","123122","10011101100"],[17,"1","1","17","123221","10011100110"],[18,"2","2","18","223211","11001110010"],[19,"3","3","19","221132","11001011100"],[20,"4","4","20","221231","11001001110"],[21,"5","5","21","213212","11011100100"],[22,"6","6","22","223112","11001110100"],[23,"7","7","23","312131","11101101110"],[24,"8","8","24","311222","11101001100"],[25,"9","9","25","321122","11100101100"],[26,":",":","26","321221","11100100110"],[27,";",";","27","312212","11101100100"],[28,"<","<","28","322112","11100110100"],[29,"=","=","29","322211","11100110010"],[30,">",">","30","212123","11011011000"],[31,"?","?","31","212321","11011000110"],[32,"@","@","32","232121","11000110110"],[33,"A","A","33","111323","10100011000"],[34,"B","B","34","131123","10001011000"],[35,"C","C","35","131321","10001000110"],[36,"D","D","36","112313","10110001000"],[37,"E","E","37","132113","10001101000"],[38,"F","F","38","132311","10001100010"],[39,"G","G","39","211313","11010001000"],[40,"H","H","40","231113","11000101000"],[41,"I","I","41","231311","11000100010"],[42,"J","J","42","112133","10110111000"],[43,"K","K","43","112331","10110001110"],[44,"L","L","44","132131","10001101110"],[45,"M","M","45","113123","10111011000"],[46,"N","N","46","113321","10111000110"],[47,"O","O","47","133121","10001110110"],[48,"P","P","48","313121","11101110110"],[49,"Q","Q","49","211331","11010001110"],[50,"R","R","50","231131","11000101110"],[51,"S","S","51","213113","11011101000"],[52,"T","T","52","213311","11011100010"],[53,"U","U","53","213131","11011101110"],[54,"V","V","54","311123","11101011000"],[55,"W","W","55","311321","11101000110"],[56,"X","X","56","331121","11100010110"],[57,"Y","Y","57","312113","11101101000"],[58,"Z","Z","58","312311","11101100010"],[59,"[","[","59","332111","11100011010"],[60,"\\","\\","60","314111","11101111010"],[61,"]","]","61","221411","11001000010"],[62,"^","^","62","431111","11110001010"],[63,"_","_","63","111224","10100110000"],[64,"NUL","`","64","111422","10100001100"],[65,"SOH","a","65","121124","10010110000"],[66,"STX","b","66","121421","10010000110"],[67,"ETX","c","67","141122","10000101100"],[68,"EOT","d","68","141221","10000100110"],[69,"ENQ","e","69","112214","10110010000"],[70,"ACK","f","70","112412","10110000100"],[71,"BEL","g","71","122114","10011010000"],[72,"BS","h","72","122411","10011000010"],[73,"HT","i","73","142112","10000110100"],[74,"LF","j","74","142211","10000110010"],[75,"VT","k","75","241211","11000010010"],[76,"FF","l","76","221114","11001010000"],[77,"CR","m","77","413111","11110111010"],[78,"SO","n","78","241112","11000010100"],[79,"SI","o","79","134111","10001111010"],[80,"DLE","p","80","111242","10100111100"],[81,"DC1","q","81","121142","10010111100"],[82,"DC2","r","82","121241","10010011110"],[83,"DC3","s","83","114212","10111100100"],[84,"DC4","t","84","124112","10011110100"],[85,"NAK","u","85","124211","10011110010"],[86,"SYN","v","86","411212","11110100100"],[87,"ETB","w","87","421112","11110010100"],[88,"CAN","x","88","421211","11110010010"],[89,"EM","y","89","212141","11011011110"],[90,"SUB","z","90","214121","11011110110"],[91,"ESC","[","91","412121","11110110110"],[92,"FS","|","92","111143","10101111000"],[93,"GS","],","93","111341","10100011110"],[94,"RS","~","94","131141","10001011110"],[95,"US","DEL","95","114113","10111101000"],[96,"FNC3","FNC3","96","114311","10111100010"],[97,"FNC2","FNC2","97","411113","11110101000"],[98,"SHIFT","SHIFT","98","411311","11110100010"],[99,"CODEC","CODEC","99","113141","10111011110"],[100,"CODEB","FNC4","CODEB","114131","10111101110"],[101,"FNC4","CODEA","CODEA","311141","11101011110"],[102,"FNC1","FNC1","FNC1","411131","11110101110"],[103,"StartA","StartA","StartA","211412","11010000100"],[104,"StartB","StartB","StartB","211214","11010010000"],[105,"StartC","StartC","StartC","211232","11010011100"],[106,"Stop","Stop","Stop","2331112","1100011101011"]];function drawUnit(t,e,n,r,a,o,i){t.save();try{t.beginPath();var s=o||0,l=i||0;t.rect(n*e+s,l,n,r),a&&(t.fillStyle=a),t.closePath(),t.fill()}finally{t.restore()}}function code128Auto(e,n,r){var a=function createElement(e){var n=0,r=[],a=e.split("");if(/^[0-9]{1}$/.test(e))n=103,r=a.map((function(e){var n=null;return t.forEach((function(t){t[1]===e&&(n=t)})),n}));else if(/^[0-9]+$/.test(e)&&e.length%2==0){n=105;for(var o=function _loop(e,n){var o=""+a[e]+a[e+1],i=null;t.forEach((function(t){t[3]===o&&(i=t)})),r.push(i)},i=0,s=a.length;i<s;i+=2)o(i)}else if(/^[0-9]+$/.test(e)&&e.length%2==1){n=105;var l=function _loop2(e,n){var o=""+a[e]+a[e+1],i=null;t.forEach((function(t){t[3]===o&&(i=t)})),r.push(i)};for(i=0,s=a.length-1;i<s;i+=2)l(i);r.push(t[101]);var h=null;t.forEach((function(t){t[1]===a[a.length-1]&&(h=t)})),r.push(h)}else/^[A-Z0-9]+$/.test(e)?(n=103,r=a.map((function(e){var n=null;return t.forEach((function(t){t[1]===e&&(n=t)})),n}))):(n=104,r=a.map((function(e){var n=null;return t.forEach((function(t){t[2]===e&&(n=t)})),n})));var c=0;return r.forEach((function(t,e){c+=t[0]*(e+1)})),c+=n,r.push(t[c%103]),r.unshift(t[n]),r.push(t[106]),r}(n).map((function(t){return t[5]})).join("").split("");if(0!=a.length){var o=r.unitWidth||r.width/a.length||1,i=r.height||30*o,s=i,l=a.length*o;"string"==typeof e&&""==e&&(e=document.createElement("canvas"),document.body.appendChild(e),r.showText&&(s=i+20),e.height=s,e.width=l);var h=e.getContext("2d"),c=r.x||0,d=r.y||0;r.showText&&(h.fillStyle="#000000",h.textBaseline="top",h.textAlign="center",h.font="normal 14px Arial",h.fillText(n,l,d+i+1),h.textAlign="left");for(var p=0,f=a.length;p<f;p++)+a[p]?drawUnit(h,p,o,i,r.color||"#000",c,d):drawUnit(h,p,o,i,"#fff",c,d);r.base64Callback&&r.base64Callback(e.toDataURL("image/jpeg"))}}function CanvasTool(t){this.imgLoadComplete=0,t.id?this.mycanvas=document.getElementById(t.id):this.mycanvas=t.canvas,this.mycontext=this.mycanvas.getContext("2d"),this.mycontext.imageSmoothingEnabled=!1,this.mycontext.webkitImageSmoothingEnabled=!1,this.mycontext.webkitImageSmoothingEnabled=!1,this.mycontext.rect(0,0,this.mycanvas.width,this.mycanvas.height),this.mycontext.fillStyle="#ffffff",this.mycontext.fill(),this.ADD_PRINT_LINE=function(t,e,n,r,a){this.mycontext.strokeStyle=a.color||"#000000",this.mycontext.lineWidth=a.lineWidth||1,this.mycontext.beginPath(),this.mycontext.moveTo(e,t),this.mycontext.lineTo(r,n),this.mycontext.stroke()},this.SET_PRINT_STYLEA=function(){},this.ADD_PRINT_TEXT=function(t,e,n,r,a,o){this.mycontext.font="normal normal "+("true"===o.bold?"bold":"normal")+" "+o.size+"pt "+o.name,this.mycontext.fillStyle=o.color||"#000000",this.mycontext.textBaseline="top",this.mycontext.fillText(a,e,t)},this.ADD_PRINT_IMAGE=function(t,e,n,r,a,o){if(0==a.indexOf("http")||0==a.indexOf("data:")){var i=new Image;i.style.width=n+"px",i.style.height=r+"px",i.crossOrigin="anonymous",i.src=a;var s=this;i.onload=function(){s.mycontext.drawImage(i,t,e,n,r),s.imgLoadComplete++}}},this.ADD_PRINT_BARCODE=function(t,e,n,r,a,o,i){"QRCode"==a?function(t,e,n){var r=document.createElement("span");document.body.appendChild(r);var a=QRCode.CorrectLevel.H,o=n.color||"#000000";e.length>154?a=QRCode.CorrectLevel.L:e.length>100&&(a=QRCode.CorrectLevel.M),n.qrcodeversion=14,new QRCode(r,{text:e,width:n.width,height:n.height,colorDark:o,colorLight:"#ffffff",correctLevel:a});var i=r.querySelector("img");i.onload=function(){t.getContext("2d").drawImage(i,n.x,n.y,n.width,n.height),document.body.removeChild(r)}}(this.mycanvas,o,{width:n,height:r,color:i.color,x:t,y:e}):code128Auto(this.mycanvas,o,{width:n,height:r,showText:i.showText,color:i.color,x:t,y:e})},this.NewPage=function(){},this.getImgBase64=function(t,e){return this.mycanvas.toDataURL(t,e)}}var e=function js_getDPI(){var t=new Array;if(window.screen.deviceXDPI!=undefined)t[0]=window.screen.deviceXDPI,t[1]=window.screen.deviceYDPI;else{var e=document.createElement("DIV");e.style.cssText="width:1in;height:1in;position:absolute;left:0px;top:0px;z-index:99;visibility:hidden",document.body.appendChild(e),t[0]=parseInt(e.offsetWidth),t[1]=parseInt(e.offsetHeight),e.parentNode.removeChild(e)}return t[2]=t[0]/72,t[3]=t[1]/72,t}();function splitDataByWidth(t,n,r){for(var a=[],o="",i=0,s=0;s<t.length;s++){var l=t.charAt(s);"\n"!=l&&(o+=l,i+=_getPTCharWidth(r,l)),(i>n||"\n"==l)&&(a.push(o),o="",i=0)}return""!=o&&a.push(o),a;function _getPTCharWidth(t,n){return function _getPXCharWidth(t,e){var n={16:1.475,15:1.47,14:1.461,13:1.35,12:1.3,11:1.28,10:1.2,9:1.2,8:1.2,7:1.1},r=1.48,a=2;/^[\u4e00-\u9fa5]+$/.test(e)&&(a=1);"ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ１２３４５６７８９０｀！＠＃＄％＾＆＊（）＿＋｜＼｛｝［］＂＇。《》／？：；￥｛｝，！、：，、！￥（）【】《》？".indexOf(e)>-1&&(a=1);null==t&&""==t&&(t=15);"string"==typeof t&&(t=t.replace("px",""));return r=n[t],t/a*r}(t,n)*e[2]}}function PrintItem(t,e){var n=parseFloat(e.height)||20,r=parseFloat(e.width)||20,a=e.x||e.xcol||0,o=e.y||e.yrow||0,i=e.value||e.defaultvalue||"",s=e.fname||e.fontname||"宋体",l=e.fbold||e.fontbold||"false",h=e.fsize||e.fontsize||12,c=e.fcolor||e.fontcolor||"",d=e.rePrtHeadFlag||"N",p=e.barcodetype||null,f=e.isqrcode||null,u=e.qrcodeversion||"Auto",g=e.isshowtext||"Y",y=e.angle||0;e.type&&("newpage"==e.type.toLowerCase()?t.NewPage():"img"==e.type.toLowerCase()||"picdatapara"==e.type.toLowerCase()?""!=i&&t.ADD_PRINT_IMAGE(a,o,r,n,i):"line"==e.type.toLowerCase()||"pline"==e.type.toLowerCase()?(t.ADD_PRINT_LINE(e.BeginY,e.BeginX,e.EndY,e.EndX,{color:e.fontcolor,lineWidth:e.lineWidth||1}),""!=c&&t.SET_PRINT_STYLEA(0,"FontColor",c)):"string"==typeof p?("128C"==p&&(i=i.replace(/\D/gi,(function(t){return""}))),t.ADD_PRINT_BARCODE(a,o,r,n,p,i,{showText:"N"!=g,color:c})):"string"==typeof f?"true"==f&&t.ADD_PRINT_BARCODE(a,o,r,n,"QRCode",i,{qrcodeversion:u,color:c}):t.ADD_PRINT_TEXT(o,a,r,n,i,{color:c,size:h,name:s,bold:l}),t.SET_PRINT_STYLEA(0,"Angle",0),y>0&&t.SET_PRINT_STYLEA(0,"Angle",y),"Y"==d&&t.SET_PRINT_STYLEA(0,"ItemType",1))}function nodeToPxInsertArray(t,e,n,r){return function nodeInsertArray(t,e,n,r){let a=0;var o=0;if(e){var i=e;e.RePrtHeadFlag&&(i=[e]),i.forEach((function(e){e[n]&&(e[n].length?e[n].forEach((function(i){i.RePrtHeadFlag=e.RePrtHeadFlag,i.type=n,i.defaultvalue&&a++,o++,t.push(r(i))})):(e[n].RePrtHeadFlag=e.RePrtHeadFlag,e[n].type=n,e[n].defaultvalue&&a++,o++,t.push(r(e[n]))))}))}return{printCount:a,count:o}}(t,e,n,(function(t){return t.xcol&&(t.xcol*=r),t.yrow&&(t.yrow*=r),t.fontsize&&(t.fontsize*=r/3.78),t.width&&(t.width*=r),t.height&&(t.height*=r),t.BeginX&&(t.BeginX*=r),t.BeginY&&(t.BeginY*=r),t.EndX&&(t.EndX*=r),t.EndY&&(t.EndY*=r),t}))}function copy(t){var e={};for(var n in t)t.hasOwnProperty(n)&&(e[n]=t[n]);return e}window.DHC_PreviewByCanvas=function(t,e,n,r,a,o){this.curPageNo=0,this.totalPageNo=1,this.printInParaData=null,this.cfg=o,this.inparaJson=function inpara2Obj(t){var e=String.fromCharCode(2),n=t.split("^"),r={};return n.forEach((function(t){var n=t.split(e);r[n[0]]=n[1]})),r}(e),this.listparaJson=function listpara2Obj(t){var e=String.fromCharCode(2);0==t.indexOf(e)&&(t=t.slice(1));var n=t.split(e),r=[];return n.forEach((function(t){var e=t.split("^");r.push(e)})),r}(n),this.canvasTool=null,this.pageSizeWidth=0,this.pageSizeHeight=0,this.layoutContainerId="XMLLayoutContainer",this.landscapeOrientation="",this.init=function(){var t=this;XML.ObjTree.prototype.attr_prefix="",$cm({ClassName:"web.DHCXMLPConfig",MethodName:"ReadXmlByName",Name:a,dataType:"text",global:!1},(function(e){var n=new XML.ObjTree,r=$.trim(e),a=n.parseXML(r);if(!a.appsetting)return alert("print xml template structure error!"),null;t.landscapeOrientation=a.appsetting.invoice.LandscapeOrientation;var i=t._handerPrintJson(a.appsetting.invoice,o).printInParaData;t.printInParaData=i,t.pageSizeWidth=i[0].width,t.pageSizeHeight=i[0].height;for(var s=0;s<t.totalPageNo;s++)t.drawByData(s);return null}))},this.drawByData=function(t){var e=this.pageSizeWidth,n=this.pageSizeHeight,r=document.createElement("canvas");document.getElementById(this.layoutContainerId).appendChild(r),r.style.width=e,r.style.height=n,r.width=e*o.viewScale,r.height=n*o.viewScale;for(var i=new CanvasTool({canvas:r}),s=0,l=(t=t||0,0);l<this.printInParaData.length;l++){var h=this.printInParaData[l];if("newpage"==h.type&&s++,s<t)0==s&&0!=t&&"Y"==h.RePrtHeadFlag&&PrintItem(i,h);else{if(s>t)break;PrintItem(i,h)}}this.curPageNo=t;var c=this;if(o.onCreateIMGBase64||o.onCreatePDFBase64){var d=0;window.intr=setInterval((function(){if(d++,c.printImgCount==i.imgLoadComplete||d>20){clearInterval(window.intr);var t=i.getImgBase64("image/jpeg",1);if(o.onCreateIMGBase64&&o.onCreateIMGBase64.call(this,t),o.onCreatePDFBase64){var e=null;(e=r.width>r.height?new jsPDF("l","mm",[.225*r.width,.225*r.height]):new jsPDF("p","mm",[.225*r.width,.225*r.height])).addImage(t,"jpeg",0,0,.225*r.width,.225*r.height),o.pdfDownload&&e.save(a+".pdf");var n=e.output("datauristring");o.onCreatePDFBase64.call(this,n)}}}),100)}},this.nextPage=function(){this.curPageNo!=this.totalPageNo&&this.drawByData(this.curPageNo+1)},this.prePage=function(){this.curPageNo<0||this.drawByData(this.curPageNo-1)},this._handleListPrintJson=function(t,e,n,r,a,o,i,s){var l=this;if(""==n)return 0;for(var h=t.ListData.PageRows,c=3.78*t.ListData.YStep,d=o[e].yrow+c+r,p=o[e].xcol,f=o[e+s-1].xcol,u=d,g=c,y=0;y<s-1;y++)o[e+y].colWidth=o[e+y+1].xcol-o[e+y].xcol;var m=o[0].width-o[e+s-1].xcol;o[e+s-1].colWidth=m>0?m:100;var v=parseInt(a.tableBorder||0)+2,w=0;return n.forEach((function(t,n){for(var r=0,y=1,m=0;m<s&&!(t.length-1<m);m++){var P=[t[m]];a.rowContentFit&&(P=splitDataByWidth(t[m],o[e+m].colWidth,o[e+m].fontsize)),y<P.length&&(y=P.length)}w+y>h?(i.push({type:"newpage"}),w=y,l.totalPageNo++,u=d):w+=y,u==d&&a.tableBorder>0&&(i.push({type:"line",BeginY:u,BeginX:p-v,EndY:u,EndX:f,fontcolor:"#000000",lineWidth:a.tableBorder||1}),u=parseFloat(u)+parseFloat(a.tableBorder||1)+1,g+=parseFloat(a.tableBorder||1));for(m=0;m<s&&!(t.length-1<m);m++){P=[t[m]];a.rowContentFit&&(P=splitDataByWidth(t[m],o[e+m].colWidth,o[e+m].fontsize)),P.forEach((function(t,n){var r=copy(o[e+m]);r.defaultvalue=t,r.yrow=u+c*n,i.push(r)})),r<c*P.length&&(r=c*(P.length-1))}if(a.tableBorder>0)for(m=0;m<s;m++)i.push({type:"line",BeginY:u-v,BeginX:o[e+m].xcol-(a.tableBorder||1)-1,EndY:u+r+c,EndX:o[e+m].xcol-(a.tableBorder||1)-1,fontcolor:"#000000",lineWidth:a.tableBorder||1});u+=r+c,g+=r,a.tableBorder>0&&(i.push({type:"line",BeginY:u-v,BeginX:p,EndY:u,EndX:f,fontcolor:"#000000",lineWidth:a.tableBorder||1}),u=parseFloat(u)+parseFloat(a.tableBorder||1)+1,g+=parseFloat(a.tableBorder||1))})),t.ListData.BackSlashWidth>0&&i.push({type:"line",BeginY:d+t.ListData.PageRows*c,BeginX:p,EndY:u,EndX:p+3.78*parseInt(t.ListData.BackSlashWidth)}),g},this._handerPrintJson=function(t,e){var n=this,r=[];r.push({type:"invoice",LandscapeOrientation:t.LandscapeOrientation,PageFooter:t.PageFooter,PaperDesc:t.PaperDesc,PrtDevice:t.PrtDevice,PrtDirection:t.PrtDirection,PrtPape:t.PrtPape,PrtPaperSet:t.PrtPaperSet,height:37.8*t.height,width:37.8*t.width}),nodeToPxInsertArray(r,t.PLData,"PLine",3.78*e.viewScale),n.printImgCount=nodeToPxInsertArray(r,t.PICData,"PICdatapara",3.78*e.viewScale).printCount,nodeToPxInsertArray(r,t.TxtData,"txtdatapara",3.78*e.viewScale);var a=nodeToPxInsertArray(r,t.ListData,"Listdatapara",3.78*e.viewScale).count;r.sort((function(t,e){return"invoice"==t.type?-1:"invoice"==e.type?1:("PLine"==t.type&&(t.yrow=t.BeginY),"PLine"===e.type&&(e.yrow=e.BeginY),parseInt(t.yrow)-parseInt(e.yrow))}));var o=[],i=0;if(r.forEach((function(s,l){if("Listdatapara"==s.type){if(a>0){var h=n._handleListPrintJson(t,l,n.listparaJson,i,e,r,o,a);e.rowHeightExpand&&(i+=h),a=0}}else{var c=n.inparaJson[s.name]||"";if(c&&(s.defaultvalue=c),"true"==s.isfollow&&(s.yrow=parseFloat(s.yrow)+i),"txtdatapara"==s.type&&undefined==s.isqrcode&&undefined==s.barcodetype&&s.width){var d=c.split("\n");s.contentFit&&(d=splitDataByWidth(c,s.width,s.fontsize)),d.forEach((function(t,e){var n=copy(s);n.yrow=parseFloat(s.yrow)+parseInt(s.height)*e,n.heightExpand&&(i+=parseInt(s.height)*e),n.defaultvalue=t,o.push(n)}))}else o.push(s)}})),o){var s=0;o.forEach((function(t){if("invoice"==t.type)return 1;"PLine"==t.type&&s<t.BeginY&&(s=t.BeginY),"PLine"==t.type&&s<t.EndY&&(s=t.EndY),s<t.yrow&&(s=t.yrow)})),"Z"==n.landscapeOrientation&&(r[0].height=37.8*t.height+s)}return{printInParaData:o,printImgCount:n.printImgCount,extHeight:i}}}}();