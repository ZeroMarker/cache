/*
	easyui扩展
	Zhan 20141008
*/
var EditIndex=undefined;

//var listenFlag=true;
//grid增加方向键、翻页键支持
$.extend($.fn.datagrid.methods, {
	keyCtr : function (jq) {
		return jq.each(function () {
			var jqgrid = $(this);
			jqgrid.datagrid('getPanel').panel('panel').attr('tabindex', 1).bind('keyup', function (e) {
				//if(listenFlag!=true){return;}
				switch (e.keyCode) {
				case 38: // up
					var myselected = jqgrid.datagrid('getSelected');
					if (myselected) {
						var index = jqgrid.datagrid('getRowIndex', myselected);
						if(index<1){return;}
						jqgrid.datagrid('selectRow', index - 1);
					} else {
						var rows = jqgrid.datagrid('getRows');
						jqgrid.datagrid('selectRow', rows.length - 1);
					}
					break;
				case 40: // down
					var myselected = jqgrid.datagrid('getSelected');
					if (myselected) {
						var index = jqgrid.datagrid('getRowIndex', myselected);
						var tmprcnt=jqgrid.datagrid('getRows').length-1
						if(index>=tmprcnt){return;}
						jqgrid.datagrid('selectRow', index + 1);
					} else {
						jqgrid.datagrid('selectRow', 0);
					}
					break;
				case 27: // ESC
					//call esc function
					try{
						ESCCall(jqgrid)
					}catch(e){
					}
					finally{
					}
					break;
				case 33: // PageUp
					//prev
					try{
						var tmpnum=jqgrid.datagrid('options').pageNumber-1;
						//tmpnum=tmpnum<1?1:tmpnum
						if(tmpnum>=1)jqgrid.datagrid('getPager').pagination('select', tmpnum);
					}catch(e){
					}
					finally{
					}
					break;
				case 34: // PageDown
					//Next page
					try{
						var tmpnum=jqgrid.datagrid('options').pageNumber+1;
						jqgrid.datagrid('getPager').pagination('select', tmpnum);
					}catch(e){
					}
					finally{
					}
					break;
				case 13: // enter
					//call enter function
					try{
						
						if(e.target.className!=="pagination-num"){
							EnterCall(jqgrid)
						}else{
							
						}
						
					}catch(e){
						//alert(e)
					}
					finally{
					}
					break;
					/*
					var myselected = jqgrid.datagrid('getSelected');
					if (myselected) {
						var index =jqgrid.datagrid('getRowIndex', myselected);
						if(EditIndex!==index){
							if (isEditing()){
								jqgrid.datagrid('beginEdit', index);
								EditIndex=index
							}
						}

					} else {
						jqgrid.datagrid('selectRow', 0);
					}
					*/
				}
			});
		});
	},
	keyCtrR : function (jq) {
		return jq.each(function () {
			var jqrgrid = $(this);
			jqrgrid.datagrid('getPanel').panel('panel').attr('tabindex', 1).bind('keyup', function (e) {
				//if(listenFlag!=true){return;}
				//switch (e.keyCode) {
				try{
						jqCallBack(jqrgrid,e.keyCode)
				}catch(e){
				}
				finally{
				}
			});
		});
	}
});
//类似MSN的提示信息
//title:提示框的标题
//msg:提示信息
//timeout:多久后消息,单位为毫秒
function MSNShow(title,msg,timeout){
	$.messager.show({
		title:title,
		msg:msg,
		timeout:timeout,
		showType:'slide'
	});
}
//取当天日期
function GetToday(){
	var myDate=new Date();
	var y = myDate.getFullYear();
	var m = myDate.getMonth()+1;
	var d = myDate.getDate();
	return y+"-"+(m<10?('0'+m):m)+"-"+(d<10?('0'+d):d);
}
function GetTime(){
	var myDate=new Date();
	var h = myDate.getHours();
	var m = myDate.getMinutes();
	var s = myDate.getSeconds();
	return (h<10?('0'+h):h)+":"+(m<10?('0'+m):m)+":"+(s<10?('0'+s):s);
}
//过滤函数
function GetDescByssHisDesc(ssHisDesc){
		var tmp,tmpHisDesc
		tmpHisDesc=ssHisDesc
		tmp=tmpHisDesc.split("(");
		if(tmp[0].length<1){
			tmp=tmpHisDesc.split(")");
			tmpHisDesc=tmp[1];
		}else{tmpHisDesc=tmp[0];}
		tmp=tmpHisDesc.split("?");
		tmpHisDesc=tmp[0];
		tmp=tmpHisDesc.split("[");
		//tmpHisDesc=tmp[0];
		if(tmp[0].length<1){
			tmp=tmpHisDesc.split("]");
			tmpHisDesc=tmp[1];
		}else{tmpHisDesc=tmp[0];}
		//tmp=tmpHisDesc.split("");
		//tmpHisDesc=tmp[0];
		
		if(tmpHisDesc=="")
		//tmpHisDesc=tmpHisDesc.replace(/[^\u4e00-\u9fa5|,]+/,'')	//过滤非汉字
		tmpHisDesc=tmpHisDesc.replace('/','')
		if(tmpHisDesc.length>5)tmpHisDesc=tmpHisDesc.substr(0,5)	//截取前4位汉字
		return tmpHisDesc;
}


(function(global) {
    'use strict';
    // existing version for noConflict()
    var _Base64 = global.Base64;
    var version = "1.1.9";
    // if node.js, we use Buffer
    var buffer;
    if (typeof module !== 'undefined' && module.exports) {
        try {
            buffer = require('buffer').Buffer;
        } catch (err) {}
    }
    // constants
    var b64chars
        = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    var b64tab = function(bin) {
        var t = {};
        for (var i = 0, l = bin.length; i < l; i++) t[bin.charAt(i)] = i;
        return t;
    }(b64chars);
    var fromCharCode = String.fromCharCode;
    // encoder stuff
    var cb_utob = function(c) {
        if (c.length < 2) {
            var cc = c.charCodeAt(0);
            return cc < 0x80 ? c
                : cc < 0x800 ? (fromCharCode(0xc0 | (cc >>> 6))
                                + fromCharCode(0x80 | (cc & 0x3f)))
                : (fromCharCode(0xe0 | ((cc >>> 12) & 0x0f))
                   + fromCharCode(0x80 | ((cc >>>  6) & 0x3f))
                   + fromCharCode(0x80 | ( cc         & 0x3f)));
        } else {
            var cc = 0x10000
                + (c.charCodeAt(0) - 0xD800) * 0x400
                + (c.charCodeAt(1) - 0xDC00);
            return (fromCharCode(0xf0 | ((cc >>> 18) & 0x07))
                    + fromCharCode(0x80 | ((cc >>> 12) & 0x3f))
                    + fromCharCode(0x80 | ((cc >>>  6) & 0x3f))
                    + fromCharCode(0x80 | ( cc         & 0x3f)));
        }
    };
    var re_utob = /[\uD800-\uDBFF][\uDC00-\uDFFFF]|[^\x00-\x7F]/g;
    var utob = function(u) {
        return u.replace(re_utob, cb_utob);
    };
    var cb_encode = function(ccc) {
        var padlen = [0, 2, 1][ccc.length % 3],
        ord = ccc.charCodeAt(0) << 16
            | ((ccc.length > 1 ? ccc.charCodeAt(1) : 0) << 8)
            | ((ccc.length > 2 ? ccc.charCodeAt(2) : 0)),
        chars = [
            b64chars.charAt( ord >>> 18),
            b64chars.charAt((ord >>> 12) & 63),
            padlen >= 2 ? '=' : b64chars.charAt((ord >>> 6) & 63),
            padlen >= 1 ? '=' : b64chars.charAt(ord & 63)
        ];
        return chars.join('');
    };
    var btoa = global.btoa ? function(b) {
        return global.btoa(b);
    } : function(b) {
        return b.replace(/[\s\S]{1,3}/g, cb_encode);
    };
    var _encode = buffer ? function (u) {
        return (u.constructor === buffer.constructor ? u : new buffer(u))
        .toString('base64')
    }
    : function (u) { return btoa(utob(u)) }
    ;
    var encode = function(u, urisafe) {
        return !urisafe
            ? _encode(String(u))
            : _encode(String(u)).replace(/[+\/]/g, function(m0) {
                return m0 == '+' ? '-' : '_';
            }).replace(/=/g, '');
    };
    var encodeURI = function(u) { return encode(u, true) };
    // decoder stuff
    var re_btou = new RegExp([
        '[\xC0-\xDF][\x80-\xBF]',
        '[\xE0-\xEF][\x80-\xBF]{2}',
        '[\xF0-\xF7][\x80-\xBF]{3}'
    ].join('|'), 'g');
    var cb_btou = function(cccc) {
        switch(cccc.length) {
        case 4:
            var cp = ((0x07 & cccc.charCodeAt(0)) << 18)
                |    ((0x3f & cccc.charCodeAt(1)) << 12)
                |    ((0x3f & cccc.charCodeAt(2)) <<  6)
                |     (0x3f & cccc.charCodeAt(3)),
            offset = cp - 0x10000;
            return (fromCharCode((offset  >>> 10) + 0xD800)
                    + fromCharCode((offset & 0x3FF) + 0xDC00));
        case 3:
            return fromCharCode(
                ((0x0f & cccc.charCodeAt(0)) << 12)
                    | ((0x3f & cccc.charCodeAt(1)) << 6)
                    |  (0x3f & cccc.charCodeAt(2))
            );
        default:
            return  fromCharCode(
                ((0x1f & cccc.charCodeAt(0)) << 6)
                    |  (0x3f & cccc.charCodeAt(1))
            );
        }
    };
    var btou = function(b) {
        return b.replace(re_btou, cb_btou);
    };
    var cb_decode = function(cccc) {
        var len = cccc.length,
        padlen = len % 4,
        n = (len > 0 ? b64tab[cccc.charAt(0)] << 18 : 0)
            | (len > 1 ? b64tab[cccc.charAt(1)] << 12 : 0)
            | (len > 2 ? b64tab[cccc.charAt(2)] <<  6 : 0)
            | (len > 3 ? b64tab[cccc.charAt(3)]       : 0),
        chars = [
            fromCharCode( n >>> 16),
            fromCharCode((n >>>  8) & 0xff),
            fromCharCode( n         & 0xff)
        ];
        chars.length -= [0, 0, 2, 1][padlen];
        return chars.join('');
    };
    var atob = global.atob ? function(a) {
        return global.atob(a);
    } : function(a){
        return a.replace(/[\s\S]{1,4}/g, cb_decode);
    };
    var _decode = buffer ? function(a) {
        return (a.constructor === buffer.constructor
                ? a : new buffer(a, 'base64')).toString();
    }
    : function(a) { return btou(atob(a)) };
    var decode = function(a){
        return _decode(
            String(a).replace(/[-_]/g, function(m0) { return m0 == '-' ? '+' : '/' })
                .replace(/[^A-Za-z0-9\+\/]/g, '')
        );
    };
    var noConflict = function() {
        var Base64 = global.Base64;
        global.Base64 = _Base64;
        return Base64;
    };
    // export Base64
    global.Base64 = {
        VERSION: version,
        atob: atob,
        btoa: btoa,
        fromBase64: decode,
        toBase64: encode,
        utob: utob,
        encode: encode,
        encodeURI: encodeURI,
        btou: btou,
        decode: decode,
        noConflict: noConflict
    };
    // if ES5 is available, make Base64.extendString() available
    if (typeof Object.defineProperty === 'function') {
        var noEnum = function(v){
            return {value:v,enumerable:false,writable:true,configurable:true};
        };
        global.Base64.extendString = function () {
            Object.defineProperty(
                String.prototype, 'fromBase64', noEnum(function () {
                    return decode(this)
                }));
            Object.defineProperty(
                String.prototype, 'toBase64', noEnum(function (urisafe) {
                    return encode(this, urisafe)
                }));
            Object.defineProperty(
                String.prototype, 'toBase64URI', noEnum(function () {
                    return encode(this, true)
                }));
        };
    }
    // that's it!
    if (global['Meteor']) {
       Base64 = global.Base64; // for normal export in Meteor.js
    }
})(this);

/*会导致datagrid报错
//editor增加combogrid
$.extend($.fn.datagrid.defaults.editors, {
	combogridsm: {
		init: function(container, options){
			var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container); 
			input.combogrid(options);
			return input;
		},
		destroy: function(target){
			$(target).combogrid('destroy');
		},
		getValue: function(target){
			return $(target).combogrid('getValue');
		},
		setValue: function(target, value){
			$(target).combogrid('setValue', value);
		},
		resize: function(target, width){
			$(target).combogrid('resize',width);
		}
	}
});
*/
