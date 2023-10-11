/// Creator:      EH
/// CreatDate:    2021-04-09
/// Description:  common js

/// 还原上尖号
if (websys_isIE) {
	document.onkeypress = null;
} else {
	document.removeEventListener("keydown", websys_sckey);
}
document.onkeydown = null;

/// ie 不支持 Object.assign
if (typeof Object.assign !== 'function') {
	// Must be writable: true, enumerable: false, configurable: true
	Object.defineProperty(Object, "assign", {
		value: function assign(target, varArgs) { // .length of function is 2
			'use strict';
			if (target === null || target === undefined) {
				throw new TypeError('Cannot convert undefined or null to object');
			}
			var to = Object(target);
			for (var index = 1; index < arguments.length; index++) {
				var nextSource = arguments[index];
				if (nextSource !== null && nextSource !== undefined) {
					for (var nextKey in nextSource) {
						// Avoid bugs when hasOwnProperty is shadowed
						if (Object.prototype.hasOwnProperty.call(nextSource, nextKey)) {
							to[nextKey] = nextSource[nextKey];
						}
					}
				}
			}
			return to;
		},
		writable: true,
		configurable: true
	});
}
if (!Array.prototype.forEach) {
	Array.prototype.forEach = function forEach(callback, thisArg) {
		var T, k;
		if (this == null) {
			throw new TypeError("this is null or not defined");
		}
		var O = Object(this);
		var len = O.length >>> 0;
		if (typeof callback !== "function") {
			throw new TypeError(callback + " is not a function");
		}
		if (arguments.length > 1) {
			T = thisArg;
		}
		k = 0;
		while (k < len) {

			var kValue;
			if (k in O) {
				kValue = O[k];
				callback.call(T, kValue, k, O);
			}
			k++;
		}
	};
}
if (!Array.prototype.indexOf) {
	Array.prototype.indexOf = function(val) {
		for (var i = 0; i < this.length; i++) {
			if (this[i] == val) return i;
		}
		return -1;
	};
}
if (!Array.prototype.remove) {
	Array.prototype.remove = function(val) {
		var index = this.indexOf(val);
		if (index > -1) {
			this.splice(index, 1);
		}
	};
}
if (typeof String.prototype.myTrim !== 'function') {
	String.prototype.myTrim = function(x, m) {
		return !m ? x.replace(/^\s+|\s+$/g, '') : x.replace(/^[ \f\r\t\v]+|[ \f\r\t\v]+$/gm, '');
	}
}

(function($) {
	/// 多选下拉框
	$.extend($.fn.datagrid.defaults.editors, {
	    combobox: {
	        init: function(container, options) {
	            var combo = $('<input type="text">').appendTo(container);
	            combo.combobox(options || {});
	            return combo;
	        },
	        destroy: function(target) {
	            $(target).combobox('destroy');
	        },
	        getValue: function(target) {
	            var opts = $(target).combobox('options');
	            if (opts.multiple){
	                return $(target).combobox('getValues').join(opts.separator);
	            } else {
	                return $(target).combobox('getValue');
	            }
	        },
	        setValue: function(target, value) {
	            var opts = $(target).combobox('options');
	            if (opts.multiple){
	                if (value == ''){
	                    $(target).combobox('clear');
	                } else {
	                    $(target).combobox('setValues', value.split(opts.separator));
	                }
	            } else {
	                $(target).combobox('setValue', value);
	            }
	        },
	        resize: function(target, width) {
	            $(target).combobox('resize', width);
	        }
	    }
	});
	
	$.fn.autoTextarea = function(options) {
		var defaults = {
			maxHeight: null,
			minHeight: $(this).height()
		};
		var opts = $.extend({},
		defaults, options);
		return $(this).each(function() {
			$(this).bind("paste cut keydown keyup focus blur",
			function() {
				var height, style = this.style;
				this.style.height = opts.minHeight + 'px';
				if (this.scrollHeight > opts.minHeight) {
					if (opts.maxHeight && this.scrollHeight > opts.maxHeight) {
						height = opts.maxHeight;
						style.overflowY = 'scroll';
					} else {
						height = this.scrollHeight;
						style.overflowY = 'hidden';
					}
					style.height = height + 'px';
				}
			});
		});
	};
	
    $.extend({
		isArray: function(o) {
			return (typeof (o) =='object' && Object.prototype.toString.call(o) == '[object Array]');
		},
		
		/// 动态加载js
		loadJavaScript : function(url, callback) {
			var script = document.createElement('script'),
			fn = callback || function() {};
			script.type = 'text/javascript';
			script.charset = 'gbk';
			if (script.readyState) {
				script.onreadystatechange = function() {
					if (script.readyState == 'loaded' || script.readyState == 'complete') {
						script.onreadystatechange = null;
						$.expression(fn);
					}
				}
			} else {
				script.onload = function() {
					$.expression(fn);
				};
			}
			script.src = url;
			document.getElementsByTagName('head')[0].appendChild(script);
		},
		
		/// 表达式相关
		questionMarkExpression : function() {
			var r = arguments;
			for (var i = 0; i < r.length; i++) {
				if (typeof(r[i]) != 'undefined') {
					var v = r[i];
					if (typeof(v) == 'string') {
						var o = $('#' + v.replace('.', '\\.'));
						if (o.length > 0) {
							var l = o[0].className;
							if (l.indexOf('checkbox') > -1) {
								v = o.checkbox('getValue');
							} else if (l.indexOf('combobox') > -1) {
								v = o.combobox('getValue');
							} else if (l.indexOf('numberbox') > -1) {
								v = o.numberbox('getValue');
							} else if (l.indexOf('timespinner') > -1) {
								v = o.timespinner('getValue');
							} else if (l.indexOf('datebox') > -1 && l.indexOf('textbox') == -1) {
								v = o.datebox('getValue');
							} else if (l.indexOf('timebox') > -1) {
								v = o.timebox('getValue');
							} else if (l.indexOf('textbox') > -1) {
								v = o.val();
								v = v.split('^').join('%5E');
							} else if (l.indexOf('textarea') > -1) {
								v = o.val();
								v = v.split('\r').join('');
								v = v.split('\n').join('%5E');
							}
						} else {
							if ($.isExpression(v)) {
								if (!$.expression(v)) { i++; }
								continue;
							} else {
								v = $.expression(v);
								if (!v) { continue; }
							}
						}
					}
					return v;
				}
			}
			return '';
		},
		isExpression : function(v) {
			var s = String(v);
			return s.indexOf('>') > -1 || s.indexOf('<') > -1 || s.indexOf('=') > -1 || s.indexOf('||') > -1 || s.indexOf('&&' > -1) || s.indexOf('!') > -1 || (s.indexOf('?') > -1 && s.indexOf(':') > -1);
		},
		expression : function(fn) {
			if (typeof(fn) == 'function') {
				return fn();
			} else if (typeof(fn) == 'string') {
				var start = fn.substring(0, 1);
				if (start == '#') {
					var end = fn.substring(1, fn.length - 1);
					return $.questionMarkExpression(end);
				}
				var end = fn.substring(fn.length - 1, 1);
				if ((fn.indexOf(':') > - 1 || fn.length == 2) && ((start == '{' && end == '}') || (start == '[' && end == ']'))) {
					try {
						return eval('(' + str + ')');
					} catch (e1) {
						return null;
					}
				}
				try {
					return eval(fn);
				} catch (e1) {
					return null;
				}
			}
			return fn;
		},
		waitUntil : function(value, fn) {
			return ($.expression(value)) ? $.expression(fn) : setTimeout(function() {
				$.waitUntil(value, fn);
			}, 0);
		},
		replace : function() {
			var r = arguments;
			var s = r[0];
			if (typeof(s) != 'undefined') {
				var f = r[1], e = r[2];
				if (typeof(f) == 'string') {
					if (String(s).indexOf(f) > -1) {
						if (typeof(e) == 'undefined') { e = ''; }
						s = String(s).split(f).join(e);
					}
				} else {
					for (var i = 1; i < r.length; i++) {
						if (typeof(r[i]) == 'object') {
							var f = r[i][0], e = r[i][1];
							s = $.replace(s, f, e);
						}
					}
				}
			}
			return s;
		},
		translate : function() {
			var r = arguments;
			var s = r[0];
			var f = r[1], e = r[2];
			if (typeof(f) != 'object') {
				if (s == f) { s = e; }
			} else {
				for (var i = 1; i < r.length; i++) {
					if (typeof(r[i]) == 'object') {
						var f = r[i][0], e = r[i][1];
						s = $.translate(s, f, e);
					}
				}
			}
			return s;
		},
		escape: function(f) {
			if (f == '' || f == undefined) return f;
			var s = String(f), k = s.charCodeAt(0);
			if (!(k >= 48 && k <= 57)) {
				var table = "itemsymbol10020spacealias itemsymbol10021exclamationmarkalias!itemsymbol10022doublequotesalias\"itemsymbol10023poundalias#itemsymbol10024dollaralias$itemsymbol10025percentalias%itemsymbol10026ampersandalias&itemsymbol10027singlequotealias'itemsymbol10028openbracketalias(itemsymbol10029closebracketalias)itemsymbol1002Aasteriskalias*itemsymbol1002Bplusalias+itemsymbol1002Ccommaalias,itemsymbol1002Dminusalias-itemsymbol1002Estopalias.itemsymbol1002Fslashalias\\itemsymbol1003Acolonalias:itemsymbol1003Bsemicolonalias;itemsymbol1003Clessthanalias<itemsymbol1003Dequalalias=itemsymbol1003Egreaterthanalias>itemsymbol1003Fquestionmarkalias?itemsymbol10040atalias@itemsymbol1005Bopensquarebracketalias[itemsymbol1005Cbackslashalias/itemsymbol1005Dclosesquarebracketalias]itemsymbol1005Ecaretalias^itemsymbol1005Funderlinealias_itemsymbol10060opensinglequotealias`itemsymbol1007Bopenbracealias{itemsymbol1007Cverticallinealias|itemsymbol1007Dclosebracealias}itemsymbol1007Etildealias~";
				var t = table.split('item');
				for (var i = 1; i < t.length; i++) {
					var e = t[i].split('alias');
					var a = e[0], b = e[1];
					if (s.indexOf(b) > -1) {
						s = s.split(b).join(a);
					}
				}
			}
			return s;
		}
	});
})(jQuery);

/*
<!--json转换方法

1、字符串转json

1.js自带的eval函数，其中需要添加小括号eval('('+str+')');
function strToJson(str) {
	var json = eval('(' + str + ')');
	return json;
}

2.new Function形式
function strToJson(str){
	var json = (new Function('return ' + str))();
	return json;
}

3.全局的JSON对象
function strToJson(str){
	return JSON.parse(str);
}
使用JSON.parse需严格遵守JSON规范，如属性都需用引号引起来，如下
var str = '{name: "jack"}';
var obj = JSON.parse(str); // --> parse error
name没有用引号引起来，使用JSON.parse所有浏览器中均抛异常，解析失败。

2、json转字符串
var jsonString = '{"bar": "property", "baz": 3}';
var jsObject = JSON.parse(jsonString); //转换为json对象
alert(jsObject.bar); //取json中的值
var st = JSON.stringify(jsObject); //转换为json类型的字符串

-->
<--jquery注意事项

1.jquery id选择器 id带"."问题
.必须使用\\.转义

2.input和textarea标签
【1】文本框
<input type="text">
【2】密码框
<input type="password">
【3】提交按钮
<input type="submit">
【4】重置按钮
<input type="reset">
【5】单选框
<input type="radio">
【6】复选框
<input type="checkbox">
【7】普通按钮
<input type="button">
【8】文件选择控件
<input type="file">
【9】隐藏框
<input type="hidden">
【10】图片按钮
<input type="image">

easyui 本身没有实现textarea的封装

-->
*/

var GV = {
    _CLASSNAME_COMMON: 'Nur.MobileCare.Common',
    _CLASSNAME: 'Nur.HISUI.MNIS.Config',
	_MAINTABLE: 'CT_NUR_MNIS.MainModule',
	_LOCTYPE: 'W,EM,OP',
	_HOSPBOX: '_HospList',
	_HOPSID: null,
    _ASSIGNED: false,
    _SettingFromCSP: false,
	_SettingFromBackEnd: false
};

/// 行编辑
GV['_DblClickRow'] = {};
function gridEndEditing(id) {
    if (GV['_DblClickRow'][id] == undefined) { return true; }
    if ($('#' + id).datagrid('validateRow', GV['_DblClickRow'][id])) {
        $('#' + id).datagrid('endEdit', GV['_DblClickRow'][id]);
        GV['_DblClickRow'][id] = undefined;
        return true;
    } else {
        return false;
    }
}
function gridOnDblClickRow(id, PcFn, PsFn) {
	return function(index, row) {
		if (typeof(PcFn) == 'function') {
			if (PcFn(index, row) === false) { return false; }
		}
		if (GV['_DblClickRow'][id] != index) {
	        if (gridEndEditing(id)) {
	            $('#' + id).datagrid('selectRow', index).datagrid('beginEdit', index);
	            GV['_DblClickRow'][id] = index;
	            if (typeof(PsFn) == 'function') {
		            PsFn(index, row);
	            }
	        } else {
	            $('#' + id).datagrid('selectRow', GV['_DblClickRow'][id]);
	        }
	    }
	};
}
/// 行选择
GV['_ClickRow'] = {};
function gridOnClickRow(id, fn) {
	return function(index, field, value) {
		if (GV['_ClickRow'][id] !=index) {
			GV['_ClickRow'][id] = index;
			if (typeof(fn) == 'function') {
				fn(index, field, value);
			}
		}
	};
}
/// 行增加
function gridOnAddClick(id, fn, last) {
	var options = $('#' + id).datagrid('options');
	var columns = options.columns[0];
	var row = {};
	for (var i = 0; i < columns.length; i++) {
		var name = columns[i].field;
		row[name] = '';
	}
	if (typeof(fn) == 'function') {
		fn(row);
	}
	if (!gridEndEditing(id)) { return false; }
	var rows = last != undefined ? last : $('#' + id).datagrid('getRows').length;
	$('#' + id).datagrid('insertRow', {
		index: rows,
		row: row
	});
	gridOnDblClickRow(id)(rows, $('#' + id).datagrid('getRows')[rows]);
}
/// 列属性
function getBoxCandidate(candidates, row) {
	var value = '';
	for (var i = 0; i < candidates.length; i++) {
		var candidate = candidates[i];
		for (var name in row) {
			if (name.indexOf(candidate) > -1) {
				value = name;
				break;
			}
		}
		if (value != '') { break; }
	}
	return value;
}
function getBoxData(data, emptyFlag) {
	var box = [];
	if (data === 'flag') {
		box = [
            { value: 'Y', desc: '是' },
            { value: 'N', desc: '否' }
        ];
	} else if (typeof (data) == 'string') {
		var rows = data.split(',');
		for (var i = 0; i < rows.length; i++) {
			var value = rows[i];
			if (value != '') {
				box.push({ value: value, desc: value });
			}
		}
	} else if (typeof (data) == 'object') {
		if (data.length > 0) {
			var value = getBoxCandidate(['code', 'Code', 'value', 'Value', 'ID', 'id', 'Id', 'rw'], data[0]) || 'value';
			var desc = getBoxCandidate(['desc', 'Desc', 'name', 'Name', 'text', 'Text'], data[0]) || 'desc';
			for (var i = 0; i < data.length; i++) {
				var row = data[i];
				if (typeof (row) == 'object') {
					box.push({ value: row[value], desc: row[desc] });
				} else {
					box.push({ value: row, desc: row });
				}
			}
		}
	}
	if (emptyFlag === true) {
    	box.push({ value: '', desc: '\\' });
    }
    return box;
}
function getBoxFormatter(data, emptyFlag) {
	return function(value, row, index) {
		var desc = '';
		var box = getBoxData(data, emptyFlag);
		for (var i = 0; i < box.length; i++) {
			if (box[i].value == value) {
				desc = box[i].desc;
				break;
			}
		}
		if (desc == '\\') { desc = ''; }
		return desc;
	};
}
function getBoxDataFormatter(id, columnIndex) {
	return function(value, row, index) {
		var options = $('#' + id).datagrid('options');
		var editor = options.columns[0][columnIndex].editor;
		if (editor != undefined) {
			var type = editor.type;
			if (type == 'combobox') {
				var valueField = editor.options.valueField;
				var textField = editor.options.textField;
				var box = editor.options.data;
				var desc = '';
				for (var i = 0; i < box.length; i++) {
					if (String(box[i][valueField]) === String(value)) {
						desc = box[i][textField];
						break;
					}
				}
				if (desc == '\\') { desc = ''; }
				return desc;
			}
		}
		return value;
	};
}
function getBoxStyler(data) {
	return function(value, row, index) {
		var desc = '';
		if (data == 'flag') {
			if (value == 'N') {
				desc = 'background-color:moccasin';
			}
		}
		return desc;
	};
}
function getBoxEditor(data, emptyFlag, required) {
	return getEditor('box', data, emptyFlag, required);
}

function getTextFormatter(wrapFlag) {
	return function(value, row, index) {
		var desc = value;
		if (wrapFlag) desc = '<div style="word-break:break-all;white-space:normal">' + value + '</div>';
		return desc;
	};
}
function getTextEditor(numericFlag, required) {
	return getEditor('text', numericFlag, false, required);
}
function getEditor(type, data, flag, required) {
	var editor = null;
	if (type == 'text') {
		editor = 'validatebox';
		if (data == true) {
			editor = 'numberbox';
		}
		if (required) {
			editor = {
				type: editor,
				options: {
					required: true
				}
			};
		}
	}
	if (type == 'box') {
		editor = {
            type: 'combobox',
            options: {
                valueField: 'value',
                textField: 'desc',
				panelHeight: 'auto',
                required: false,
         		editable: false,
        		enterNullValueClear: false,
                data: getBoxData(data, flag)
            }
        };
        if (required) {
	        editor.options.required = true;
        }
	}
	return editor;
}
function cellPinyinEdit(id, codeIndex, nameIndex) {
	return function(index, record) {
		var editors = $('#' + id).datagrid('getEditors', index);
		var codeEditor = editors[codeIndex].target;
		var nameEditor = editors[nameIndex].target;
		if ((codeEditor) && (nameEditor)) {
			nameEditor.blur(function(e) {
				var value = nameEditor.val();
				var pinyin = getPinyin(value);
				codeEditor.val(pinyin);
			});
		}
	};
}
/// 表格刷新
GV['_FindClick'] = {};
function gridOnFindClick(id, PcFn, PSFn, fn) {
	var findFn = function() {
		var nullFlag = false;
		if (typeof(PcFn) == 'function') {
			if (PcFn() === false) { nullFlag = true; }
		}
		if (nullFlag) {
			$('#' + id).datagrid('loadData', []);
		} else {
			var options = $('#' + id).datagrid('options');
			var queryParams = {
				ClassName: GV._CLASSNAME,
			    ResultSetType: 'array',
				configFlag: 'Y'
			};
			if (typeof(PSFn) == 'function') {
				var params = PSFn();
				for (var name in params) {
					queryParams[name] = params[name];
				}
			}
			if (options.url == '') {
				options.url = $URL;
			}
			$('#' + id).datagrid('reload', queryParams);
		}
		$('#' + id).datagrid('clearSelections');
		GV['_ClickRow'][id] = null;
		GV['_DblClickRow'][id] = null;
		if (typeof(fn) == 'function') {
			fn();	
		}
	};
	if (GV['_FindClick'][id] == undefined) {
		GV['_FindClick'][id] = findFn;
	}
	return findFn;
}
/// 表格保存
function gridOnSaveClick(id, PcFn, PSFn, fn) {
	return function() {
		var nullFlag = false;
		if (typeof(PcFn) == 'function') {
			if (PcFn() === false) { nullFlag = true; }
		}
		if (nullFlag) {
		} else {
			gridEndEditing(id);
			var selectedRows = $('#' + id).datagrid('getChanges');
		    var err = 0, msg = '', calls = 0;
		    selectedRows.forEach(function(row) {
			    var queryParams = {
					ClassName: GV._CLASSNAME
				};
				if (typeof(PSFn) == 'function') {
					var params = PSFn(row);
					for (var name in params) {
						queryParams[name] = params[name];
					}
				}
			    $cm(queryParams, function(ret) {
					calls++;
					if (String(ret).indexOf('"success":0') > -1) {
						var success = eval('(' + ret + ')');
						err = 2, msg = success.msg;
					} else if (!(parseInt(ret) < 0)) {
						if (err == 0) {
							err = 1;
						}
					} else {
						err = 2, msg = ret;
					}
					if (calls == selectedRows.length) {
						if (err == 2) {
							$.messager.popover({ msg: '保存失败:' + msg, type: 'alert', timeout: 5000, style: { height: 'auto', top: '', left: '' } });
						}
						if (err == 1) {
							$.messager.popover({ msg: '保存成功!', type: 'success', timeout: 1000 });
							GV['_FindClick'][id]();
						}
						if (typeof(fn) == 'function') {
							fn(err);
						};
					}
				});
			});
		}
	};
}
/// 表格删除
function gridOnDeleteClick(id, PcFn, PSFn, fn) {
	return function() {
		var nullFlag = false;
		if (typeof(PcFn) == 'function') {
			if (PcFn() === false) { nullFlag = true; }
		}
		if (nullFlag) {
		} else {
			gridEndEditing(id);
			var selectedRows = $('#' + id).datagrid('getSelections');
		    var err = 0, msg = '', calls = 0;
		    selectedRows.forEach(function(row) {
			    var queryParams = {
					ClassName: GV._CLASSNAME
				};
				if (typeof(PSFn) == 'function') {
					var params = PSFn(row);
					for (var name in params) {
						queryParams[name] = params[name];
					}
				}
			    $cm(queryParams, function(ret) {
					calls++;
					if (String(ret).indexOf('"success":0') > -1) {
						var success = eval('(' + ret + ')');
						err = 2, msg = success.msg;
					} else if (!(parseInt(ret) < 0)) {
						if (err == 0) {
							err = 1;
						}
					} else {
						err = 2, msg = ret;
					}
					if (calls == selectedRows.length) {
						if (err == 2) {
							$.messager.popover({ msg: '删除失败:' + msg, type: 'alert', timeout: 5000, style: { height: '40px', top: '', left: '' } });
						}
						if (err == 1) {
							$.messager.popover({ msg: '删除成功!', type: 'success', timeout: 1000 });
							GV['_FindClick'][id]();
						} 
						if (typeof(fn) == 'function') {
							fn(err);
						};
					}
				});
			});
		}
	};
}
/// 参数构造
function getParams(names, queryName, methodName, otherParams, row) {
	var params = otherParams || {};
	if (typeof(queryName) == 'string') {
		params['QueryName'] = queryName;
	}
	if (typeof(methodName) == 'string') {
		params['MethodName'] = methodName;
	}
	var record = null, recordFlag = false;
	if (queryName != undefined) {
		if (typeof(queryName) == 'object') {
			if (methodName != undefined) {
				if (typeof(methodName) == 'object') {
					record = methodName;
					recordFlag = true;
				}
			}
		}
	}
	if (row != undefined) {
		if (typeof(row) == 'object') {
			record = row;
			recordFlag = true;
		}
	}
	for (var i = 0; i < names.length; i++) {
		var name = names[i];
		var value = '';
		switch(names[i]) {
			case 'ClassName':
				value = GV._CLASSNAME
				break;
			case 'hospID':
			case 'inputHospID':
				value = getHospID();
				break;
			case 'locID':
			case 'inputLocID':
				value = getLocID();
				break;
			case 'userType':
			case 'inputUserType':
				value = 'NURSE'
				break;
			case 'configFlag':
			case 'inputConfigFlag':
				value = 'Y';
				break;
			case 'ResultSetType':
				value = 'array';
				break;
			case 'dataType':
				value = 'text';
				break;
			default:
				break;
		}
		if (recordFlag) {
			if (record.hasOwnProperty(name)) {
				if (typeof(record[name]) != 'function') {
					value = record[name];
				}
			}
		}
		params[name] = value;
	}
	if (queryName != undefined) {
		if (typeof(queryName) == 'object') {
			for (var name in queryName) {
				params[name] = queryName[name];
			}
		}
	}
	return params;
}
function getHospID() {
	var value = GV._HOSPID || '';
	var element = $('#' + GV._HOSPBOX);
	if (element.length > 0) {
		if (GV._HOSPBOX == '_HospList') {
			value = element.combogrid('getValue');
		} else {
			value = element.combobox('getValue');
		}
	}
	return value;
}
function getLocID() {
	if (GV['_ClickRow']['locGrid'] == undefined) { return ''; }
	return $('#locGrid').datagrid("getData").rows[GV['_ClickRow']['locGrid']].ID;
}
function getNullFlag() {
	var nullFlag = 'Y';
	if (GV['_ClickRow']['locGrid'] != undefined) {
		var rec = $('#locGrid').datagrid("getData").rows[GV['_ClickRow']['locGrid']];
		if ((rec.ID == 'common') || (String(rec.ID).indexOf('hosp') > -1) || (rec.commonFlag == 'N') || (rec.ID == '')) {
			nullFlag = 'N';
		}
	} else {
		var locGrid = $('#locGrid');
		if (locGrid.length == 0) {
			nullFlag = 'N';
		}
	}
	return nullFlag;
}
/// 取值
function getData(methodName, PSFn, fn) {
	var queryParams = {
		ClassName: GV._CLASSNAME
	};
	var params = null, callback = null;
	if (typeof(methodName) == 'string') {
		queryParams['MethodName'] = methodName;
		if (typeof(PSFn) == 'function') {
			params = PSFn();
		} else if (typeof(PSFn) == 'object') {
			params = PSFn;
		}
		callback = fn;
	} else {
		if (typeof(methodName) == 'function') {
			params = methodName();
		} else if (typeof(methodName) == 'object') {
			params = methodName;
		}
		callback = PSFn;
	}
	if (params != undefined) {
		for (var name in params) {
			queryParams[name] = params[name];
		}
	}
	if (queryParams['QueryName']) {
		return (String(callback) == 'false') ? $cm(queryParams, false) : $cm(queryParams, function(ret) {
			if (callback != undefined) {
				callback(ret);
			}
		});
	} else if (queryParams['MethodName']) {
		return (String(callback) == 'false') ? $cm(queryParams, false) : $cm(queryParams, function(ret) {
			if (callback != undefined) {
				callback(ret);
			}
		});
	}
}
function convertFlag(value, reverse) {
	return !reverse ? $.translate(value, [true, 'Y'], [false, 'N']) : $.translate(value, ['Y', true], ['N', false]);
}
function convertOption(value, reverse) {
	return !reverse ? $.replace(value, ['^', '%5E']) : $.replace(value, ['%5E', '^']);
}
function convertText(value, reverse) {
	return !reverse ? $.replace(value, ['\r'], ['^', '%5E'], ['\n', '%0A']) : $.replace(value, ['%5E', '^'], ['%0A', '\n']);
}
function convertValue(value, type, reverse) {
	switch(type) {
		case 'flag':
			return convertFlag(value, reverse);
		case 'option':
			return convertOption(value, reverse);
		case 'text':
			return convertText(value, reverse);
		default:
			break;
	}
	return value;
}
function getElement(id) {
	return $('#' + id.replace('.', '\\.'));
}
function getGridTitle(id) {
	return $('#' + id).parent().parent().parent().parent().prev().children().eq(0).text();
}
function getGridIconCls(id) {
	return $('#' + id).parent().parent().parent().parent().prev().children().eq(1).attr('class');
}
function getButtonIconCls(id) {
	return $('#' + id).children().children().children().children().length ? $('#' + id).children().children().children().children().eq(1).attr('class') : $('#' + id).children().children().eq(1).attr('class').replace('l-btn-icon', 'panel-icon');
}
function setButtonIconCls(id, cls) {
	return $('#' + id).children().children().children().children().length ? $('#' + id).children().children().children().children().eq(1).attr('class', cls) : $('#' + id).children().children().children().children().eq(1).attr('class', cls.replace('panel-icon', 'l-btn-icon'));
}
function getButtonText(id) {
	return $('#' + id).children().children().children().children().length ? $('#' + id).children().children().children().children().eq(0).text() : $('#' + id).children().children().eq(0).text();
}
function setButtonText(id, text) {
	return $('#' + id).children().children().children().children().length ? $('#' + id).children().children().children().children().eq(0).text(text) : $('#' + id).children().children().eq(0).text(text);
}
function isElement(id) {
	return getElement(id)[0] != undefined;
}
function getElementValue(id) {
	var value = null;
	var div = getElement(id);
	if (div[0] != undefined) {
		value = '';
		var className = div[0].className;
		if (className.indexOf('checkbox') > -1) {
			value = div.checkbox('getValue');
			value = convertValue(value, 'flag');
		} else if (className.indexOf('combobox') > -1) {
			value = div.combobox('getValue');
		} else if (className.indexOf('numberbox') > -1) {
			value = div.numberbox('getValue');
		} else if (className.indexOf('timespinner') > -1) {
			value = div.timespinner('getValue');
		} else if (className.indexOf('datebox') > -1 && className.indexOf('textbox') == -1) {
			value = div.datebox('getValue');
		} else if (className.indexOf('timebox') > -1) {
			value = div.timebox('getValue');
		} else if (className.indexOf('textbox') > -1) {
			value = div.val();
			value = convertValue(value, 'option');
		} else if (className.indexOf('textarea') > -1) {
			value = div.val();
			value = convertValue(value, 'text');
		}
	}
	return value;
}
function setElementValue(id, value) {
	var div = getElement(id);
	if (div[0] != undefined) {
		var className = div[0].className;
		if (className.indexOf('checkbox') > -1) {
			value = convertValue(value, 'flag', true);
			div.checkbox('setValue', value);
		} else if (className.indexOf('combobox') > -1) {
			div.combobox('setValue', value);
		} else if (className.indexOf('numberbox') > -1) {
			div.numberbox('setValue', value);
		} else if (className.indexOf('timespinner') > -1) {
			div.timespinner('setValue', value);
		} else if (className.indexOf('datebox') > -1 && className.indexOf('textbox') == -1) {
			div.datebox('setValue', value);
		} else if (className.indexOf('timebox') > -1) {
			div.timebox('setValue', value);
		} else if (className.indexOf('textbox') > -1) {
			value = convertValue(value, 'option', true);
			div.val(value);
		} else if (className.indexOf('textarea') > -1) {
			value = convertValue(value, 'text', true);
			div.val(value);
		}
	}
}
function showResult(ret, action) {
	if (String(ret).indexOf('"success":0') > -1) {
		var success = eval('(' + ret + ')');
		var msg = success.msg;
		$.messager.popover({ msg: action + '失败:' + msg, type: 'alert', timeout: 5000, style: { height: '40px', top: '', left: '' } });
	} else if (!(parseInt(ret) < 0)) {
		$.messager.popover({ msg: action + '成功!', type: 'success', timeout: 1000 });
	} else {
		$.messager.popover({ msg: action + '失败:' + ret, type: 'alert', timeout: 5000, style: { height: '40px', top: '', left: '' } });
	}
}
