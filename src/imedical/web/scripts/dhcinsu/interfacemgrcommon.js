/**
 * FileName: interfacemgrcommon.js
 * Author: lizhi
 * Date: 2022-06-6
 * Description: 接口管理通用方法
 */

//判断字符串是否是xml
function checkxml(str)
{
	try{
		var json= $.xml2json(str);
		return true;
	}catch(e){
		return false;
		}
}
//判断字符串是否是json
function checkjson (str) {
	try{
		var jsonobj=eval("("+str+")");
		return true
		}catch (e) {
		return false
	}
}


//格式化xml
function formatXml(xml) {
	xml=xml.replaceAll(" ","");
	xml=xml.replaceAll("\n","");
	xml=xml.replaceAll("$1\r\n$2$3","");
	var formatted = '';
	var reg = /(>)(<)(\/*)/g;
	xml = xml.replace(reg, '$1\r\n$2$3');
	var pad = 0;
	jQuery.each(xml.split('\r\n'), function(index, node) {
		var indent = 0;
		if (node.match( /.+<\/\w[^>]*>$/ )) {
			indent = 0;
		} else if (node.match( /^<\/\w/ )) {
			if (pad != 0) {
				pad -= 1;
			}
		} else if (node.match( /^<\w[^>]*[^\/]>.*$/ )) {
			indent = 1;
		} else {
			indent = 0;
		}
		var padding = '';
		for (var i = 0; i < pad; i++) {
			padding += '  ';
		}
		formatted += padding + node + '\r\n';
		pad += indent;
	});
	formatted=(formatted).replaceAll("\n\n","");
	return formatted;
}

//格式化json
var formatJson = function(json, options) {
    var reg = null,
      formatted = '',
      pad = 0,
      PADDING = '    '; // one can also use '\t' or a different number of spaces
    // optional settings
    options = options || {};
    // remove newline where '{' or '[' follows ':'
    options.newlineAfterColonIfBeforeBraceOrBracket = (options.newlineAfterColonIfBeforeBraceOrBracket === true) ? true : false;
    // use a space after a colon
    options.spaceAfterColon = (options.spaceAfterColon === false) ? false : true;

    // begin formatting...

    // make sure we start with the JSON as a string
    if (typeof json !== 'string') {
        json = JSON.stringify(json);
    }
    // parse and stringify in order to remove extra whitespace
    json = JSON.parse(json);
    json = JSON.stringify(json);

    // add newline before and after curly braces
    reg = /([\{\}])/g;
    json = json.replace(reg, '\r\n$1\r\n');

    // add newline before and after square brackets
    reg = /([\[\]])/g;
    json = json.replace(reg, '\r\n$1\r\n');

    // add newline after comma
    reg = /(\,)/g;
    json = json.replace(reg, '$1\r\n');

    // remove multiple newlines
    reg = /(\r\n\r\n)/g;
    json = json.replace(reg, '\r\n');

    // remove newlines before commas
    reg = /\r\n\,/g;
    json = json.replace(reg, ',');

    // optional formatting...
    if (!options.newlineAfterColonIfBeforeBraceOrBracket) {
        reg = /\:\r\n\{/g;
        json = json.replace(reg, ':{');
        reg = /\:\r\n\[/g;
        json = json.replace(reg, ':[');
    }
    if (options.spaceAfterColon) {
        reg = /\:/g;
        json = json.replace(reg, ':');
    }

    $.each(json.split('\r\n'), function(index, node) {
        var i = 0,
          indent = 0,
          padding = '';

        if (node.match(/\{$/) || node.match(/\[$/)) {
            indent = 1;
        } else if (node.match(/\}/) || node.match(/\]/)) {
            if (pad !== 0) {
                pad -= 1;
            }
        } else {
            indent = 0;
        }

        for (i = 0; i < pad; i++) {
            padding += PADDING;
        }

        formatted += padding + node + '\r\n';
        pad += indent;
    });

    return formatted;
};

//xml转json
(function ($) {

    // Add function to jQuery namespace
    $.extend({

        // converts xml documents and xml text to json object
        xml2json: function (xml, extended) {
            if (!xml) return {}; // quick fail

            //### PARSER LIBRARY
            // Core function
            function parseXML(node, simple) {
                if (!node) return null;
                var txt = '', obj = null, att = null;
                var nt = node.nodeType, nn = jsVar(node.localName || node.nodeName);
                var nv = node.text || node.nodeValue || '';
                /*DBG*/ //if(window.console) console.log(['x2j',nn,nt,nv.length+' bytes']);
                if (node.childNodes) {
                    if (node.childNodes.length > 0) {
                        /*DBG*/ //if(window.console) console.log(['x2j',nn,'CHILDREN',node.childNodes]);
                        $.each(node.childNodes, function (n, cn) {
                            var cnt = cn.nodeType, cnn = jsVar(cn.localName || cn.nodeName);
                            var cnv = cn.text || cn.nodeValue || '';
                            /*DBG*/ //if(window.console) console.log(['x2j',nn,'node>a',cnn,cnt,cnv]);
                            if (cnt == 8) {
                                /*DBG*/ //if(window.console) console.log(['x2j',nn,'node>b',cnn,'COMMENT (ignore)']);
                                return; // ignore comment node
                            }
                            else if (cnt == 3 || cnt == 4 || !cnn) {
                                // ignore white-space in between tags
                                if (cnv.match(/^\s+$/)) {
                                    /*DBG*/ //if(window.console) console.log(['x2j',nn,'node>c',cnn,'WHITE-SPACE (ignore)']);
                                    return;
                                };
                                /*DBG*/ //if(window.console) console.log(['x2j',nn,'node>d',cnn,'TEXT']);
                                txt += cnv.replace(/^\s+/, '').replace(/\s+$/, '');
                                // make sure we ditch trailing spaces from markup
                            }
                            else {
                                /*DBG*/ //if(window.console) console.log(['x2j',nn,'node>e',cnn,'OBJECT']);
                                obj = obj || {};
                                if (obj[cnn]) {
                                    /*DBG*/ //if(window.console) console.log(['x2j',nn,'node>f',cnn,'ARRAY']);

                                    // http://forum.jquery.com/topic/jquery-jquery-xml2json-problems-when-siblings-of-the-same-tagname-only-have-a-textnode-as-a-child
                                    if (!obj[cnn].length) obj[cnn] = myArr(obj[cnn]);
                                    obj[cnn] = myArr(obj[cnn]);

                                    obj[cnn][obj[cnn].length] = parseXML(cn, true/* simple */);
                                    obj[cnn].length = obj[cnn].length;
                                }
                                else {
                                    /*DBG*/ //if(window.console) console.log(['x2j',nn,'node>g',cnn,'dig deeper...']);
                                    obj[cnn] = parseXML(cn);
                                };
                            };
                        });
                    }; //node.childNodes.length>0
                }; //node.childNodes
                if (node.attributes) {
                    if (node.attributes.length > 0) {
                        /*DBG*/ //if(window.console) console.log(['x2j',nn,'ATTRIBUTES',node.attributes])
                        att = {}; obj = obj || {};
                        $.each(node.attributes, function (a, at) {
                            var atn = jsVar('@' + at.name), atv = at.value;
                            att[atn] = atv;
                            if (obj[atn]) {
                                /*DBG*/ //if(window.console) console.log(['x2j',nn,'attr>',atn,'ARRAY']);

                                // http://forum.jquery.com/topic/jquery-jquery-xml2json-problems-when-siblings-of-the-same-tagname-only-have-a-textnode-as-a-child
                                //if(!obj[atn].length) obj[atn] = myArr(obj[atn]);//[ obj[ atn ] ];
                                obj[cnn] = myArr(obj[cnn]);

                                obj[atn][obj[atn].length] = atv;
                                obj[atn].length = obj[atn].length;
                            }
                            else {
                                /*DBG*/ //if(window.console) console.log(['x2j',nn,'attr>',atn,'TEXT']);
                                obj[atn] = atv;
                            };
                        });
                        //obj['attributes'] = att;
                    }; //node.attributes.length>0
                }; //node.attributes
                if (obj) {
                    obj = $.extend((txt != '' ? new String(txt) : {}), /* {text:txt},*/obj || {}/*, att || {}*/);
                    //txt = (obj.text) ? (typeof(obj.text)=='object' ? obj.text : [obj.text || '']).concat([txt]) : txt;
                    txt = (obj.text) ? ([obj.text || '']).concat([txt]) : txt;
                    if (txt) obj.text = txt;
                    txt = '';
                };
                var out = obj || txt;
                //console.log([extended, simple, out]);
                if (extended) {
                    if (txt) out = {}; //new String(out);
                    txt = out.text || txt || '';
                    if (txt) out.text = txt;
                    if (!simple) out = myArr(out);
                };
                return out;
            }; // parseXML
            // Core Function End
            // Utility functions
            var jsVar = function (s) { return String(s || '').replace(/-/g, "_"); };

            // NEW isNum function: 01/09/2010
            // Thanks to Emile Grau, GigaTecnologies S.L., www.gigatransfer.com, www.mygigamail.com
            function isNum(s) {
                // based on utility function isNum from xml2json plugin (http://www.fyneworks.com/ - diego@fyneworks.com)
                // few bugs corrected from original function :
                // - syntax error : regexp.test(string) instead of string.test(reg)
                // - regexp modified to accept  comma as decimal mark (latin syntax : 25,24 )
                // - regexp modified to reject if no number before decimal mark  : ".7" is not accepted
                // - string is "trimmed", allowing to accept space at the beginning and end of string
                var regexp = /^((-)?([0-9]+)(([\.\,]{0,1})([0-9]+))?$)/
                return (typeof s == "number") || regexp.test(String((s && typeof s == "string") ? jQuery.trim(s) : ''));
            };
            // OLD isNum function: (for reference only)
            //var isNum = function(s){ return (typeof s == "number") || String((s && typeof s == "string") ? s : '').test(/^((-)?([0-9]*)((\.{0,1})([0-9]+))?$)/); };

            var myArr = function (o) {

                // http://forum.jquery.com/topic/jquery-jquery-xml2json-problems-when-siblings-of-the-same-tagname-only-have-a-textnode-as-a-child
                //if(!o.length) o = [ o ]; o.length=o.length;
                if (!$.isArray(o)) o = [o]; o.length = o.length;

                // here is where you can attach additional functionality, such as searching and sorting...
                return o;
            };
            // Utility functions End
            //### PARSER LIBRARY END

            // Convert plain text to xml
            if (typeof xml == 'string') xml = $.text2xml(xml);

            // Quick fail if not xml (or if this is a node)
            if (!xml.nodeType) return;
            if (xml.nodeType == 3 || xml.nodeType == 4) return xml.nodeValue;

            // Find xml root node
            var root = (xml.nodeType == 9) ? xml.documentElement : xml;

            // Convert xml to json
            var out = parseXML(root, true /* simple */);

            // Clean-up memory
            xml = null; root = null;

            // Send output
            return out;
        },
        text2xml: function (str) {
            return $.parseXML(str);
        }

    }); 
    /**
    * Converts JSON object to XML string.
    * 
    * @param json object to convert
    * @param options additional parameters 
    * @return XML string 
    */
    $.json2xml = function (json, options) {
        settings = {};
        settings = $.extend(true, settings, defaultSettings, options || {});
        return convertToXml(json, settings.rootTagName, '', 0);
    };

    var defaultSettings = {
        formatOutput: true,
        formatTextNodes: false,
        indentString: '  ',
        rootTagName: 'root',
        ignore: [],
        replace: [],
        nodes: [],
        ///TODO: exceptions system
        exceptions: []
    };

    /**
    * This is actual settings object used throught plugin, default settings
    * are stored separately to prevent overriding when using multiple times.
    */
    var settings = {};

    /**
    * Core function parsing JSON to XML. It iterates over object properties and
    * creates XML attributes appended to main tag, if property is primitive 
    * value (eg. string, number).
    * Otherwise, if it's array or object, new node is created and appened to
    * parent tag. 
    * You can alter this behaviour by providing values in settings.ignore, 
    * settings.replace and settings.nodes arrays. 
    * 
    * @param json object to parse
    * @param tagName name of tag created for parsed object
    * @param parentPath path to properly identify elements in ignore, replace 
    * 	      and nodes arrays
    * @param depth current element's depth 
    * @return XML string
    */
    var convertToXml = function (json, tagName, parentPath, depth) {
        var suffix = (settings.formatOutput) ? '\r\n' : '';
        var indent = (settings.formatOutput) ? getIndent(depth) : '';
        var xmlTag = indent + '<' + tagName;
        var children = '';

        for (var key in json) {
            if (json.hasOwnProperty(key)) {
                var propertyPath = parentPath + key;
                var propertyName = getPropertyName(parentPath, key);
                // element not in ignore array, process
                if ($.inArray(propertyPath, settings.ignore) == -1) {
                    // array, create new child element
                    if ($.isArray(json[key])) {
                        children += createNodeFromArray(json[key], propertyName,
								propertyPath + '.', depth + 1, suffix);
                    }
                    // object, new child element aswell
                    else if (typeof (json[key]) === 'object') {
                        children += convertToXml(json[key], propertyName,
								propertyPath + '.', depth + 1);
                    }
                    // primitive value property as attribute
                    else {
                        // unless it's explicitly defined it should be node
                        if (propertyName.indexOf('@') == -1) {
                            children += createTextNode(propertyName, json[key],
									depth, suffix);
                        }
                        else {
                            propertyName = propertyName.replace('@', '');
                            xmlTag += ' ' + propertyName + '="' + json[key] + '"';
                        }
                    }
                }
            }
        }
        // close tag properly
        if (children !== '') {
            xmlTag += '>' + suffix + children + indent + '</' + tagName + '>' + suffix;
        }
        else {
            xmlTag += '/>' + suffix;
        }
        return xmlTag;
    };


    /**
    * Creates indent string for provided depth value. See settings for details.
    * 
    * @param depth
    * @return indent string 
    */
    var getIndent = function (depth) {
        var output = '';
        for (var i = 0; i < depth; i++) {
            output += settings.indentString;
        }
        return output;
    };


    /**
    * Checks settings.replace array for provided name, if it exists returns
    * replacement name. Else, original name is returned.
    * 
    * @param parentPath path to this element's parent
    * @param name name of element to look up
    * @return element's final name
    */
    var getPropertyName = function (parentPath, name) {
        var index = settings.replace.length;
        var searchName = parentPath + name;
        while (index--) {
            // settings.replace array consists of {original : replacement} 
            // objects 
            if (settings.replace[index].hasOwnProperty(searchName)) {
                return settings.replace[index][searchName];
            }
        }
        return name;
    };

    /**
    * Creates XML node from javascript array object.
    * 
    * @param source 
    * @param name XML element name
    * @param path parent element path string
    * @param depth
    * @param suffix node suffix (whether to format output or not)
    * @return XML tag string for provided array
    */
    var createNodeFromArray = function (source, name, path, depth, suffix) {
        var xmlNode = '';
        if (source.length > 0) {
            for (var index in source) {
	            if(index=="unique"||index=="remove")
	            {
		        	continue;    
		        }
                // array's element isn't object - it's primitive value, which
                // means array might need to be converted to text nodes
                if (typeof (source[index]) !== 'object') {
                    // empty strings will be converted to empty nodes
                    if (source[index] === "") {
                        xmlNode += getIndent(depth) + '<' + name + '/>' + suffix;
                    }
                    else {
                        var textPrefix = (settings.formatTextNodes)
                    ? suffix + getIndent(depth + 1) : '';
                        var textSuffix = (settings.formatTextNodes)
        					? suffix + getIndent(depth) : '';
                        xmlNode += getIndent(depth) + '<' + name + '>'
	                			+ textPrefix + source[index] + textSuffix
	                			+ '</' + name + '>' + suffix;
                    }
                }
                // else regular conversion applies
                else {
                    xmlNode += convertToXml(source[index], name, path, depth);
                }
            }
        }
        // array is empty, also creating empty XML node		
        else {
            xmlNode += getIndent(depth) + '<' + name + '/>' + suffix;
        }
        return xmlNode;
    };

    /**
    * Creates node containing text only.
    * 
    * @param name node's name
    * @param text node text string
    * @param parentDepth this node's parent element depth
    * @param suffix node suffix (whether to format output or not)
    * @return XML tag string
    */
    var createTextNode = function (name, text, parentDepth, suffix) {
        // unformatted text node: <node>value</node>
        // formatting includes value indentation and new lines
        var textPrefix = (settings.formatTextNodes)
			? suffix + getIndent(parentDepth + 2) : '';
        var textSuffix = (settings.formatTextNodes)
			? suffix + getIndent(parentDepth + 1) : '';
        var xmlNode = getIndent(parentDepth + 1) + '<' + name + '>'
					+ textPrefix + text + textSuffix
					+ '</' + name + '>' + suffix;
        return xmlNode;
    };
})(jQuery);

//datagrid操作
var GetDataGrid={ 
	GetGridInfo:function(gridIndex,type,index,field){
		var view = $('.datagrid-view');
	    var view = $(view[gridIndex]).children('.datagrid-view2');
	    var rtn = "";
	    var tr = $(view).find('.datagrid-body tr[datagrid-row-index=' + index + ']');
		switch (type){ // gridIndex 0:pat,1:,2:tar,3:ord
		    case "tr" :
				// 审核人
				rtn = tr;
		    	break;
		    case "tdHead" :  
		    	tr = $(view).find('.datagrid-header-row');  
	 			td = $(tr).find('td[field="' + field + '"]');
	 			rtn = td;
		    	break;
		    case "td" :  
	 			td = $(tr).find('td[field="' + field + '"]');
	 			rtn = td;
		    	break;
		    case "field" :
				// 审核人
				var Field = $(view).find('.datagrid-body td[field="' + field + '"]')[index];
				var divObj = $(Field).find('div')[0];
				var jObj = $(divObj).children(":first");
				var result = '';
				if(!jObj || (jObj && jObj.length == 0)){
					result = divObj.innerText; 
				}
		        else if (jObj[0].tagName=="INPUT"){
					var objType=jObj.prop("type");
					var objClassInfo=jObj.prop("class");
					if (objType=="checkbox"){
						//result=jObj.is(':checked')
						result = jObj.checkbox("getValue");
					}else if (objType=="select-one"){
						result=jObj.combobox("getValue");
					}else if (objType=="text"){
						if (objClassInfo.indexOf("combogrid")>=0){
							result=jObj.combogrid("getText");
						}else if (objClassInfo.indexOf("datebox-f")>=0){
							result=jObj.datebox('getText')
						}else if (objClassInfo.indexOf("combobox")>=0){
							result=jObj.combobox("getValue");
						}else if(objClassInfo.indexOf("number")>=0){
							result=jObj.numberbox("getValue");
						}
					}
				}else if(jObj[0].tagName=="SELECT"){
					var objClassInfo=jObj.prop("class");
					if (objClassInfo.indexOf("combogrid")>=0){
						result=jObj.combogrid("getText");
					}else if (objClassInfo.indexOf("combobox")>=0){
						result=jObj.combobox("getValue");
					}
				}else if(jObj[0].tagName=="LABEL"){
					result = jObj.text();
					
				}else if(jObj[0].tagName=="A"){  //按钮修改显示值 2018-07-23 
					result = jObj.find(".l-btn-text").text();
				}else if(jObj[0].tagName=="TABLE"){  // editor
					var editInput = $(jObj).find('input');
					var objType=editInput.prop("type");
					var objClassInfo=editInput.prop("class");
					if (objType=="checkbox"){
						result = editInput.checkbox("getValue");
					}else if (objType=="select-one"){
						result=editInput.combobox("getValue");
					}else if (objType=="text"){
						if (objClassInfo.indexOf("combogrid")>=0){
							result = editInput.combogrid("getText");
						}else if (objClassInfo.indexOf("datebox-f")>=0){
							result = editInput.datebox('getText')
						}else if (objClassInfo.indexOf("combobox")>=0){
							result = editInput.combobox("getValue");
						}else if(objClassInfo.indexOf("number")>=0){
							result = editInput.numberbox("getValue");
						}else{
							result = editInput[0].value; 	
						}
					}
				}
		        rtn = result;
		    	break;
		    case "td-div" :
		    	break;
		    default :
		    	break;
		    } 	
		return rtn;
	},
	setGridVal:function(gridId,index,field,val){
		var gridViewArr = $('#' + gridId).siblings();
		var GridView2 = '';
		for (var gridIndex = 0; gridIndex < gridViewArr.length - 1; gridIndex++) {
			var GridClass = $(gridViewArr[gridIndex]).attr('class');
			if(GridClass.indexOf('view2') > 0){
				GridView2 = gridViewArr[gridIndex];		
			}
		}
	    var td = $(GridView2).find('.datagrid-body td[field="' + field + '"]')[index];
		var grid = $('#' + gridId);
        if (index === undefined || index === '') {
            index = 0;
        }
        var row = grid.datagrid('getRows')[index];
        if (row != null) {
            var editor = grid.datagrid('getEditor', {
                    index: index,
                    field: field
                });
            if (editor != null) {
                this.setValueToEditor(gridId, index,field,val);
            } else {
		        tmpdiv = $(td).find('div')[0];
		        if(tmpdiv){
			    	tmpdiv.innertText = val;
			    }
				$(tmpdiv).text(val);
            }
        }
	},
	//设置datagrid的编辑器的值 可以使用setGridVal 进行赋值
    setValueToEditor: function (dg,index,field, value) {
	    var editor = $('#' + dg).datagrid('getEditor', {
      		index: index,
      		field: field
		});
        switch (editor.type) {
        case 'combobox':
            editor.target.combobox('setValue', value);
            break;
        case 'combotree':
            editor.target.combotree('setValue', value);
            break;
        case 'textbox':
            editor.target.textbox('setValue', value);
            break;
        case 'numberbox':
            editor.target.numberbox("setValue", value);
            break;
        case 'datebox':
            editor.target.datebox("setValue", value);
            break;
        case 'datetimebox':
            editor.target.datebox("setValue", value);
            break;
        case 'switchbox':
            editor.target.switchbox("setValue", value);
            break;
        default:
            editor.html = value;
            editor.target[0].value = value; 
            break;
        }
    }
}
var INSUMIDataGrid={ 
	setGridVal:function(gridId,index,field,val){
		var gridViewArr = $('#' + gridId).siblings();
		var GridView2 = '';
		for (var gridIndex = 0; gridIndex < gridViewArr.length - 1; gridIndex++) {
			var GridClass = $(gridViewArr[gridIndex]).attr('class');
			if(GridClass.indexOf('view2') > 0){
				GridView2 = gridViewArr[gridIndex];		
			}
		}
	    var td = $(GridView2).find('.datagrid-body td[field="' + field + '"]')[index];
		var grid = $('#' + gridId);
        if (index === undefined || index === '') {
            index = 0;
        }
        var row = grid.datagrid('getRows')[index];
        if (row != null) {
            var editor = grid.datagrid('getEditor', {
                    index: index,
                    field: field
                });
            if (editor != null) {
                this.setValueToEditor(gridId, index,field,val);
            } else {
		        tmpdiv = $(td).find('div')[0];
		        if(tmpdiv){
			    	tmpdiv.innertText = val;
			    }
				$(tmpdiv).text(val);
            }
        }
	},
	//设置datagrid的编辑器的值 可以使用setGridVal 进行赋值
    setValueToEditor: function (dg,index,field, value) {
	    var editor = $('#' + dg).datagrid('getEditor', {
      		index: index,
      		field: field
		});
        switch (editor.type) {
        case 'combobox':
            editor.target.combobox('setValue', value);
            break;
        case 'combotree':
            editor.target.combotree('setValue', value);
            break;
        case 'textbox':
            editor.target.textbox('setValue', value);
            break;
        case 'numberbox':
            editor.target.numberbox("setValue", value);
            break;
        case 'datebox':
            editor.target.datebox("setValue", value);
            break;
        case 'datetimebox':
            editor.target.datebox("setValue", value);
            break;
        case 'switchbox':
            editor.target.switchbox("setValue", value);
            break;
        default:
            editor.html = value;
            editor.target[0].value = value; 
            break;
        }
    },
    // 获取编辑框的值
    getCellVal: function (dg,index,field) {
		var rtn = '';
		var editor = $('#' + dg).datagrid('getEditor', {
      		index: index,
      		field: field
		});
		if(editor){ // 编辑器的值
	        switch (editor.type) {
	        case 'combobox':
	            rtn = editor.target.combobox('getValue');
	            break;
	        case 'combotree':
	            rtn = editor.target.combotree('getValue');
	            break;
	        case 'textbox':
	            rtn = editor.target.textbox('getValue');
	            break;
	        case 'numberbox':
	            rtn = editor.target.numberbox("getValue");
	            break;
	        case 'datebox':
	            rtn = editor.target.datebox("getValue");
	            break;
	        case 'datetimebox':
	            rtn = editor.target.datebox("getValue");
	            break;
	        case 'switchbox':
	            rtn = editor.target.switchbox("getValue");
	            break;
	        case 'combogrid':
	            rtn = editor.target.combobox('getValue');
	            break;
	        default:
	            rtn = editor.target[0].value ; 
	            break;
	        }
		}else{ // 非编辑器的
			var rows = $('#' + dg).datagrid('getRows');
			rtn = rows[index][field];
			var gridViewArr = $('#' + dg).siblings();
			var GridView2 = '';
			for (var gridIndex = 0; gridIndex < gridViewArr.length - 1; gridIndex++) {
				var GridClass = $(gridViewArr[gridIndex]).attr('class');
				if(GridClass.indexOf('view2') > 0){
					GridView2 = gridViewArr[gridIndex];		
				}
			}
		    var view = GridView2;
			// 
			var Field = $(view).find('.datagrid-body td[field="' + field + '"]')[index];
			var divObj = $(Field).find('div')[0];
			var jObj = $(divObj).children(":first");
			var result = '';
			if(!jObj || (jObj && jObj.length == 0)){
				result = divObj.innerText; 
			}
	        else if (jObj[0].tagName=="INPUT"){
				var objType=jObj.prop("type");
				var objClassInfo=jObj.prop("class");
				if (objType=="checkbox"){
					//result=jObj.is(':checked')
					result = jObj.checkbox("getValue");
				}else if (objType=="select-one"){
					result=jObj.combobox("getValue");
				}else if (objType=="text"){
					if (objClassInfo.indexOf("combogrid")>=0){
						result=jObj.combogrid("getText");
					}else if (objClassInfo.indexOf("datebox-f")>=0){
						result=jObj.datebox('getText')
					}else if (objClassInfo.indexOf("combobox")>=0){
						result=jObj.combobox("getValue");
					}else if(objClassInfo.indexOf("number")>=0){
						result=jObj.numberbox("getValue");
					}
				}
			}else if(jObj[0].tagName=="SELECT"){
				var objClassInfo=jObj.prop("class");
				if (objClassInfo.indexOf("combogrid")>=0){
					result=jObj.combogrid("getText");
				}else if (objClassInfo.indexOf("combobox")>=0){
					result=jObj.combobox("getValue");
				}
			}else if(jObj[0].tagName=="LABEL"){
				result = jObj.text();
				
			}else if(jObj[0].tagName=="A"){  //按钮修改显示值 2018-07-23 
				result = jObj.find(".l-btn-text").text();
			}else if(jObj[0].tagName=="TABLE"){  // editor
				var editInput = $(jObj).find('input');
				var objType=editInput.prop("type");
				var objClassInfo=editInput.prop("class");
				if (objType=="checkbox"){
					result = editInput.checkbox("getValue");
				}else if (objType=="select-one"){
					result=editInput.combobox("getValue");
				}else if (objType=="text"){
					if (objClassInfo.indexOf("combogrid")>=0){
						result = editInput.combogrid("getText");
					}else if (objClassInfo.indexOf("datebox-f")>=0){
						result = editInput.datebox('getText')
					}else if (objClassInfo.indexOf("combobox")>=0){
						result = editInput.combobox("getValue");
					}else if(objClassInfo.indexOf("number")>=0){
						result = editInput.numberbox("getValue");
					}else{
						result = editInput[0].value; 	
					}
				}
			}
	        rtn = result;	
		}
        return rtn;
    },
    // 表格对象
    getTableObj:function(grid,index,type){
		var gridViewArr = $('#' + gridId).siblings();
		var GridView2 = '';
		for (var gridIndex = 0; gridIndex < gridViewArr.length - 1; gridIndex++) {
			var GridClass = $(gridViewArr[gridIndex]).attr('class');
			if(GridClass.indexOf('view2') > 0){
				GridView2 = gridViewArr[gridIndex];		
			}
		}
    	var tr = $(view).find('.datagrid-body tr[datagrid-row-index=' + index + ']');
		switch (type){ // gridIndex 0:pat,1:,2:tar,3:ord
		    case "tr" :
				// 审核人
				rtn = tr;
		    	break;
		    case "tdHead" :  
		    	tr = $(view).find('.datagrid-header-row');  
	 			td = $(tr).find('td[field="' + field + '"]');
	 			rtn = td;
		    	break;
		    case "td" :  
	 			td = $(tr).find('td[field="' + field + '"]');
	 			rtn = td;
		    	break;
			default :
	    		break;
		}
	}
}


//将对象转换为treegrid参数-----舍弃
function treegridjsonold(Paramobj)
{
	var jsonData={total:0,rows:[],curPage: 1};
	var index=0;
	$.each(Paramobj,function(name,value){
			var jsonobj={};
			jsonobj["Rowid"]=index.toString();
			jsonobj["_parentId"]="";
			jsonobj["inputname1"]=name;
			jsonobj["inputcode1"]=value;
			if(typeof(value)=="object") //如果是对象,代表json第2层
			{
				jsonobj["inputcode1"]="";
				var index2=0;
				$.each(value,function(name2,value2){
					var jsonobj2={};
					jsonobj2["_parentId"]=jsonobj["Rowid"];
					jsonobj2["Rowid"]=index+"A"+index2;
					jsonobj2["inputname1"]=name2;
					jsonobj2["inputcode1"]=value2;
					if(typeof(value2)=="object")//如果是对象,代表json第3层
					{
						jsonobj2["inputcode1"]="";
						var index3=0;
						$.each(value2,function(name3,value3){
							var jsonobj3={};
							jsonobj3["_parentId"]=jsonobj2["Rowid"];
							jsonobj3["Rowid"]=index+"A"+index2+"B"+index3;
							jsonobj3["inputname1"]=name3;
							jsonobj3["inputcode1"]=value3;
							if(typeof(value3)=="object")//如果是对象,代表json第4层
							{
								jsonobj3["inputcode1"]="";
								var index4=0;
								$.each(value3,function(name4,value4){
									var jsonobj4={};
									jsonobj4["_parentId"]=jsonobj3["Rowid"];
									jsonobj4["Rowid"]=index+"A"+index2+"C"+index3+"D"+index4;
									jsonobj4["inputname1"]=name4;
									jsonobj4["inputcode1"]=value4;
									if(typeof(value4)=="object")//如果是对象,代表json第5层
									{
										jsonobj4["inputcode1"]="";
										var index5=0;
										$.each(value4,function(name5,value5){
												var jsonobj5={};
												jsonobj5["_parentId"]=jsonobj4["Rowid"];
												jsonobj5["Rowid"]=index+"A"+index2+"C"+index3+"D"+index4+"E"+index5;
												jsonobj5["inputname1"]=name5;
												jsonobj5["inputcode1"]=value5;
												index5=index5+1;
												jsonData.rows.push(jsonobj5);
											});
									}
									index4=index4+1;
									jsonData.rows.push(jsonobj4);
									});
							}
							index3=index3+1;
							jsonData.rows.push(jsonobj3);
						});
					}
					index2=index2+1;
					jsonData.rows.push(jsonobj2);
				});
			}
			index=index+1;
			jsonData.rows.push(jsonobj);
		});
	return jsonData;
}
