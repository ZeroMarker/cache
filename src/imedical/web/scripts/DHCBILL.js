/**
* fileName:DHCBILL.js
* author:  Lid
* date:    2010-06-09
* function:计费组类库，针对trakcare
* version: v1.0
* notice:  1.为了统一版本，如需修改该JS,请先通知李东(010-62662360),谢谢！！
*          2.本类库主要引用了 ExtJS 3.2 中的源代码 !!
*/

window.undefined = window.undefined;  
DHCBILL = {
	version : '1.0'
};

DHCBILL.apply = function(o, c, defaults){
	// no "this" reference for friendly out of scope calls
	if(defaults){
		DHCBILL.apply(o, defaults);   //如果有默认属性页复制到目标属性中
	}
	if(o && c && typeof c == 'object'){
		for(var p in c){
			o[p] = c[p];  //将对象c中的数据全部copy到o中
		}
	}
	return o;
};

(function(){
			var toString = Object.prototype.toString;
			ua = navigator.userAgent.toLowerCase(),   //做跨浏览器的验证
			check = function(r){
				return r.test(ua);
			},
			DOC = document,  //定义document的简写 DOC
			isStrict = DOC.compatMode == "CSS1Compat",
			isOpera = check(/opera/),
			isChrome = check(/\bchrome\b/),
			isWebKit = check(/webkit/),
			isSafari = !isChrome && check(/safari/),
			isSafari2 = isSafari && check(/applewebkit\/4/), // unique to Safari 2
			isSafari3 = isSafari && check(/version\/3/),
			isSafari4 = isSafari && check(/version\/4/),
			isIE = !isOpera && check(/msie/),
			isIE7 = isIE && check(/msie 7/),
			isIE8 = isIE && check(/msie 8/),
			isIE6 = isIE && !isIE7 && !isIE8,
			isGecko = !isWebKit && check(/gecko/),
			isGecko2 = isGecko && check(/rv:1\.8/),
			isGecko3 = isGecko && check(/rv:1\.9/),
			isBorderBox = isIE && !isStrict,
			isWindows = check(/windows|win32/),
			isMac = check(/macintosh|mac os x/),
			isAir = check(/adobeair/),
			isLinux = check(/linux/),
			isSecure = /^https/i.test(window.location.protocol);

			// remove css image flicker 
			//如果ie6,删除背景缓存
			if(isIE6){
				try{
					DOC.execCommand("BackgroundImageCache", false, true);  
				}catch(e){}
			};

			DHCBILL.apply(DHCBILL,{
			     applyIf : function(o, c){
						if(o){
							for(var p in c){
								if(!DHCBILL.isDefined(o[p])){
									o[p] = c[p];
								}
							}
						}
						return o;
				 },
				 extend : function(){
						// inline overrides 
						//私有函数，用于对象复制
						var io = function(o){
							for(var m in o){
								this[m] = o[m];
							}
						};
						//私有变量，保存Object对象的构造函数
						var oc = Object.prototype.constructor;
						// //函数参数: sb 基类   sp 父类    overrides 用于覆盖的子类的成员
						return function(sb, sp, overrides){
							if(DHCBILL.isObject(sp)){
								overrides = sp;
								sp = sb;
								sb = overrides.constructor != oc ? overrides.constructor : function(){sp.apply(this, arguments);};
							}
							var F = function(){},
								sbp,
								spp = sp.prototype;

							F.prototype = spp;
							sbp = sb.prototype = new F();
							sbp.constructor=sb;
							sb.superclass=spp;
							if(spp.constructor == oc){
								spp.constructor=sp;
							}
							sb.override = function(o){
								DHCBILL.override(sb, o);
							};
							sbp.superclass = sbp.supr = (function(){
								return spp;
							});
							sbp.override = io;
							DHCBILL.override(sb, overrides);
							sb.extend = function(o){return DHCBILL.extend(sb, o);};
							return sb;
						};
				  }(),
				  isIterable : function(v){
						//check for array or arguments
						if(DHCBILL.isArray(v) || v.callee){
							return true;
						}
						//check for node list type
						if(/NodeList|HTMLCollection/.test(toString.call(v))){
							return true;
						}
						//NodeList has an item and length property
						//IXMLDOMNodeList has nextNode method, needs to be checked first.
						return ((typeof v.nextNode != 'undefined' || v.item) && DHCBILL.isNumber(v.length));
				  },
				  each : function(array, fn, scope){
						if(DHCBILL.isEmpty(array, true)){
							return;
						}
						if(!DHCBILL.isIterable(array) || DHCBILL.isPrimitive(array)){
							array = [array];
						}
						for(var i = 0, len = array.length; i < len; i++){
							if(fn.call(scope || array[i], array[i], i, array) === false){
								return i;
							};
						}
				  },
			      isObject : function(v){
						  return !!v && Object.prototype.toString.call(v) === '[object Object]';
				  },
				  override : function(origclass, overrides){
						if(overrides){
							var p = origclass.prototype;
							DHCBILL.apply(p, overrides);
							if(DHCBILL.isIE && overrides.hasOwnProperty('toString')){
								p.toString = overrides.toString;
							}
						}
				  },
				  namespace : function(){
						var o, d;
						DHCBILL.each(arguments, function(v) {
							d = v.split(".");
							o = window[d[0]] = window[d[0]] || {};
							DHCBILL.each(d.slice(1), function(v2){
								o = o[v2] = o[v2] || {};
							});
						});
						return o;
				  },
				  iterate : function(obj, fn, scope){
						if(DHCBILL.isEmpty(obj)){
							return;
						}
						if(DHCBILL.isIterable(obj)){
							DHCBILL.each(obj, fn, scope);
							return;
						}else if(typeof obj == 'object'){
							for(var prop in obj){
								if(obj.hasOwnProperty(prop)){
									if(fn.call(scope || obj, prop, obj[prop], obj) === false){
										return;
									};
								}
							}
						}
				  },
				  isEmpty : function(v, allowBlank){
						return v === null || v === undefined || ((DHCBILL.isArray(v) && !v.length)) || (!allowBlank ? v === '' : false);
				  },
				  isArray : function(v){
						return toString.apply(v) === '[object Array]';
				  },
			      isDate : function(v){
						return toString.apply(v) === '[object Date]';
				  },
				  isObject : function(v){
						return !!v && Object.prototype.toString.call(v) === '[object Object]';
				  },
				  isPrimitive : function(v){
						return DHCBILL.isString(v) || DHCBILL.isNumber(v) || DHCBILL.isBoolean(v);
				  },
				  isFunction : function(v){
						return toString.apply(v) === '[object Function]';
				  },
				  isNumber : function(v){
						return typeof v === 'number' && isFinite(v);
				   },
				  isString : function(v){
						return typeof v === 'string';
				  },
				  isBoolean : function(v){
						return typeof v === 'boolean';
				  },
				  isElement : function(v) {
						return v ? !!v.tagName : false;
				  },
				  isDefined : function(v){
						return typeof v !== 'undefined';
				  },
				  //验证是否为正数  
				  isPositiveNumber:function(val){
						var exp=re = /^(0|([1-9]\d*))(\.\d+)?$/; 
						return exp.test(val);
				  },
				  isNumeric:function(val){   
					   var exp=/(^-?\d\d*\.\d*$)|(^-?\d\d*$)|(^-?\.\d\d*$)/;     
					   return   exp.test(val);   
				  },
				  //验证是否为整数  
				  isInteger:function(val)     
				  {   
						  var exp=/(^-?\d\d*$)/;   
						  return exp.test(val);   
				  }, 
				  //获取节点的坐标位置及宽度高度(像素) 
				  GetElCoordinate:function(e){ 
						var top=e.offsetTop; 
						var left = e.offsetLeft;
						var width = e.offsetWidth;
						var height = e.offsetHeight;
						while (e = e.offsetParent){
							top += e.offsetTop;
							left += e.offsetLeft;
						}
						return {top:top,left:left,width:width,height:height}; 
				  },
				  //去除字符串前后空格(format:0或不传(去前后),1(去左),2(去右))
				  trim:function(val,format){
						if(typeof(val)==="undefined"||typeof(val)==="null"||val===""||val===" ")return;
						if(typeof(format)==="undefined"||+format===0){
							return val.replace(/(^\s*)|(\s*$)/g, "");
						}
						if(+format===1){
							return val.replace(/(^\s*)/g, ""); 
						}
						if(+format===2){
							return val.replace(/(\s*$)/g, ""); 
						}
				  },
				  //日期验证函数,只支持(yyyy-mm-dd hh:mm:ss)格式
				  checkDate:function(val){   
					   if(val.length>0){   
							var regDateTime= /^(\d+)-(\d{1,2})-(\d{1,2}) (\d{1,2}):(\d{1,2}):(\d{1,2})$/;      
							var regDate= /^(\d+)-(\d{1,2})-(\d{1,2})$/;
							var regTime= /^(\d{1,2}):(\d{1,2}):(\d{1,2})$/;
							if(!regDateTime.test(val)&&!regDate.test(val)&&!regTime.test(val)){
							   return false;    
						    }   
						}   
						return true;   
				  },
				  compareDate:function(data1,data2){
					    var aStart=data1.split('-'); //转成成数组，分别为年，月，日，下同
						var aEnd=data2.split('-');
						var startDate = aStart[0]+"/" + aStart[1]+ "/" + aStart[2];
						var endDate = aEnd[0] + "/" + aEnd[1] + "/" + aEnd[2];
						if(Date.parse(startDate)>Date.parse(endDate)){
							return true;
						}
						return false;
				  },
				//Cookie操作
				setCookie:function(c_name,value,expiredays){
					var exdate=new Date()    
					exdate.setDate(exdate.getDate()+expiredays)    
					cookieVal=c_name+ "=" +escape(value)+((expiredays==null) ? "" : ";expires="+exdate.toGMTString());
					//    alert(cookieVal);   
					document.cookie=cookieVal;
				},
				//获取Cookie
				getCookie:function(c_name){
					if (document.cookie.length>0){
						c_start=document.cookie.indexOf(c_name + "=");
						if (c_start!=-1){
							c_start=c_start + c_name.length+1;
							c_end=document.cookie.indexOf(";",c_start);
							if (c_end==-1) c_end=document.cookie.length;
							//document.write(document.cookie.substring(c_start,c_end)+"<br>");
							return unescape(document.cookie.substring(c_start,c_end))
						}	
					}				  
					return ""
				}
			});
	DHCBILL.ns = DHCBILL.namespace;  //定义命名空间的简写
})();

//往DHCBILL对象中复制有关Trakcare的公用方法
(function(){
	DHCBILL.applyIf(DHCBILL,{
		//获取表格行数
		GetTableRows:function(tlbName){
			try{
				var myrows=0;
				var tabObj=document.getElementById(tlbName);
				if (tabObj){
					var myrows=tabObj.rows.length-1;
				}
				return myrows;
			}catch(e){
				alert(e.toString);
				return 0;
			}
		},
		/*
		$:function(){
			var elements = new Array();
			for(var i = 0;i < arguments.length;i++){
				var element = arguments[i];
				
				if(typeof element == "string"){
					element = document.getElementById(element);
				}
				if(arguments.length == 1){
					return element;
				}
				elements.push(element);
			}
			return elements;
	    },
		//通过对象名获取对象值
		$V:function(objname){
			var obj=document.getElementById(objname);
			var transval="";
			if (obj){
				switch (obj.type)
				{
					case "select-one":
						myidx=obj.selectedIndex;
						//transval=obj.options[myidx].text;
						if(+myidx<0){
							transval="";
						}else{
							transval=obj.options[myidx].value;	
						}
						break;
					case "checkbox":
						transval=obj.checked;
						break;
					case "dhtmlXCombo":
						transval=obj.getSelectedValue();
						break;
					default:
						transval=obj.value;
						break;
				}
			}
			return transval;
		},*/
	    /*//设置文本框获取焦点或失去焦点时的背景色
	    SetInputBgColor:function(){
			var el = document.getElementsByTagName("INPUT");
			for (var i=0; i<el.length; i++) {
				if(el.type==="hidden")return;
				el[i].onfocus=function() {
					this.className=" sffocus";  //样式在websys.css中定义
					//this.style.textAlign="left";
				}
				el[i].onblur=function() {
					this.className=this.className.replace(new RegExp(" sffocus\\b"), "");
					//if((isNumeric(this.value))){this.style.textAlign="right";}
				}
			}
		}(),*/
		//验证数字如果是负数则颜色变红色
		CheckNumber:function(obj){
			var key=event.keyCode;
			if(!isNumeric(obj.value)&&key!=8&&key!=13&&obj.value!="-"){
			   alert("您的输入有误请重新输入");
			   obj.focus();obj.select();obj.value="";return;	
			}else{
				if(obj.value<0){
				   obj.style.color="red";	
				}else{
				   obj.style.color="black";	     
				}  	
			}	
		},
		getElementsByClassName:function(className,tag){
 			var allTags = document.getElementsByTagName(tag);
 			var matchingElements = new Array();
 			className = className.replace(/\-/g,"\\-");
 			var regex = new RegExp("(^|\\s)" + className + "(\\s|$)");
 			var element;
 			for(var i=0;i<allTags.length;i++){
 				element = allTags[i];
 				if(regex.test(element.className)){
 					matchingElements.push(element);
 				}
 			}
 			return matchingElements;
 		},
 		GetHrefParam:function(obj, key){
	 		var url = obj.location.href;
			var strParams = "";
			var pos = url.indexOf("?");
			var tmpArry = null;
			var strValue = "";
			var tmp = "";
			if( pos < 0)
			{
				return "";
			}
			else
			{
				strParams = url.substring(pos + 1, url.length);
				tmpArry = strParams.split("&");
				for(var i = 0; i < tmpArry.length; i++)
				{
					tmp = tmpArry[i];
					if(tmp.indexOf("=") < 0)
					continue;
					if(tmp.substring(0, tmp.indexOf("=")) == key)
					strValue = tmp.substring(tmp.indexOf("=") + 1, tmp.length);
				}
				return strValue;
			}	
	 	}
	})
})();

//定义StringBuffer类
StringBuffer=function(){
	this._objArray = [];   
    this._undoFlag = false;
}
StringBuffer.prototype.toString = function(separator) {   
    if(this._objArray.length==0) {   
        return '';   
    }   
    var str = this._objArray.join(separator);   
    if(this._objArray.length > 1) {   
        this.clear();   
        this.append(str);   
    }   
    this._undoFlag = false;   
    return str;   
};   
StringBuffer.prototype.append = function(object) {   
    this._objArray[this._objArray.length] = object;   
    this._undoFlag = true;   
    return this;   
};    
StringBuffer.prototype.clear = function() {   
    this._objArray.length = 0;   
    this._undoFlag = false;   
};   
StringBuffer.prototype.undoLastAppend = function() {   
    if(this._undoFlag) {   
        this._objArray.length = this._objArray.length -1;   
        this._undoFlag = false;   
    }   
};   
StringBuffer.prototype.setSize = function(size) {   
    if(size==null || size<=0) {   
        this.clear();   
        return;   
    }   
    var str = this._objArray.join('');   
    if(size < str.length) {   
        str = str.substring(0, size);   
        this.clear();   
        this.append(str);   
    } else if(this._objArray.length > 1) {   
        this.clear();   
        this.append(str);   
    }   
    this._undoFlag = false;   
};   
StringBuffer.prototype.getSize = function() {   
    var str = this.toString();   
    return str.length;   
};  

//加载jquery-autocomplete用的JS与CSS.
/*document.write('<script type="text/javascript" src="../scripts/JQueryAutoComplete/lib/jQuery.js">');
document.write('</script>');
document.write('<script type="text/javascript" src="../scripts/JQueryAutoComplete/lib/jquery.bgiframe.min.js">');
document.write('</script>');
document.write('<script type="text/javascript" src="../scripts/JQueryAutoComplete/lib/jquery.ajaxQueue.js">');
document.write('</script>');
document.write('<script type="text/javascript" src="../scripts/JQueryAutoComplete/lib/thickbox-compressed.js">');
document.write('</script>');
document.write('<script type="text/javascript" src="../scripts/JQueryAutoComplete/jquery.autocomplete.js">');
document.write('</script>');
document.write('<link rel="stylesheet" type="text/css" href="../scripts/JQueryAutoComplete/jquery.autocomplete.css" />');
document.write('<link rel="stylesheet" type="text/css" href="../scripts/JQueryAutoComplete/lib/thickbox.css" />');
*/
//var $j=jQuery.noConflict(); 	//定义$的别名 
//$j=$.noConflict();
//$j('#msg').hide();//此处$j就代表JQuery 









