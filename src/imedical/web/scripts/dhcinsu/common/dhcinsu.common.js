/*
* FileName:	dhcinsu.common.js
* User:		tangzf 
* Date:		2019-08-09	
* Description: 医保通用js
*/


/*
* 返回URL请求中的参数
* DingSH 2019-06-06
* input:
* output: 
*			theRequest 将URL的参数解析 成 theRequest['param1'],theRequest['param2'],
*/
function INSUGetRequest() {
    try {
        var url = location.search; //获取url中"?"符后的字串 
    var theRequest = new Object();
    if (url.indexOf("?") != -1) {
        var str = url.substr(1);
        strs = str.split("&");
        for (var i = 0; i < strs.length; i++) {
			try{
				theRequest[strs[i].split("=")[0]] = decodeURIComponent(strs[i].split("=")[1]);
			}
			catch (error) {
				theRequest[strs[i].split("=")[0]] = strs[i].split("=")[1];
			}
        }
    }
    return theRequest;
    } catch (error) {
        $.messager.alert('提示','dhcinsu.common.js中方法:INSUGetRequest()发生错误:' + error,'info');
    }
    
}
/*
* 加载医保字典的数据
* tangzf 2019-08-09
* input: objectId : 元素 Id ; 必填
*		 DicType : 字典类别 ; 必填
*		 options. :	(选填)
*		 	DicCode : 字典代码 ; 
*		 	type :  控件类型   CB ：'combobox' ; DG：'datagrid' CG：'combogrid' ;可为空 为空时 按combobox加载
*		 	valueField : combo Id	默认=id
*		 	textField : combo 显示值  默认=cDesc
*		 	showAll : 加载出的com 是否显示 '全部'选项; Y ： '加载'  默认不加载
*		 	editable : 是否可编辑 true可编辑 默认不可编辑
*		 	defaultFlag ：是否默认值  
*           DicOPIPFlag :过滤数据标识 例如 IP 或 OP + DingSH 20200527 
*           hospDr:院区 + DingSH 20200527 
* output: 			
*/
function INSULoadDicData(objectId, DicType,options) {
    try {
	    if(!options){
			var options=new Object();
		}
	    var DicCode = options.DicCode || "" ;
	    var type = options.type || "" ;
	    var valueField = options.valueField || "cCode" ;
	    var textField = options.textField || "cDesc" ;
	    var showAll = options.showAll || "N" ;
	    var editable = options.editable || false ;
	    var defaultFlag = options.defaultFlag || "Y" ;
	    var DicOPIPFlag = options.DicOPIPFlag || "" ;
	    var hospDr = options.hospDr || "" ;
	    var indexed = 0 ;  
        var url = $URL;
   		$HUI.combobox('#' + objectId,{
       		valueField: valueField,
			textField: textField,
			editable: editable,
         loadFilter:function(data){
	         
	      if (data.length > 0 && showAll == 'N'){
            		data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
				}	
	    	  var j=0
	    	  var newData = new Array();
	          if(DicOPIPFlag ==""){
		          newData=data;
		      }else{
			   	for(var i in data){
					if(data[i].DicOPIPFlag == DicOPIPFlag){
					      newData.push(data[i])
				      }
			   	 }

			  }
			for(var i in newData){
				if(newData[i].DicDefaultFlag == "Y")
					 {
						indexed=i
					 }
			}
			return newData;
	    },
        	blurValidValue:true,
			onBeforeLoad:function(param){
				param.ClassName = 'web.INSUDicDataCom';
				param.QueryName= 'QueryDic';
				param.Type = DicType;
				param.Code = DicCode;
				param.HospDr = hospDr; 
				param.ResultSetType = 'array';
			},
			onLoadSuccess:function(data){
				setValueById(objectId,'');
				if(data.length > 0 && defaultFlag == 'Y' ){
					$('#' + objectId).combobox('select',data[indexed][valueField]);	
				}
				
			}
       	});
       $('#' + objectId).combobox('reload', url);
    } catch (error) {
        $.messager.alert('提示', 'dhcinsu.common.js中方法:INSULoadDicData()发生错误:' + error, 'info');
    }
}
/*
* 加载医保字典的数据
* tangzf 2019-08-09
* input: objectId : 元素 Id ; 
*		 DicType : 字典类别 ;
*		 DicCode : 字典代码 ; 
*		 type :  控件类型   CB ：'combobox' ; DG：'datagrid' CG：'combogrid' ;可为空 为空时 按combobox加载
*		 valueField : combo Id
*		 textField : combo 显示值
*		 showAll : 加载出的com 是否显示全部 Y ： '加载'  默认不加载
* output: 			
*/
function INSULoadDicData1(objectId, options) {
    try {
	    var DicType = options.DicType || "" ;
	    var DicCode = options.DicCode || "" ;
	    var type = options.type || "" ;
	    var valueField = options.DicCode || "id" ;
	    var textField = options.DicCode || "cDesc" ;
	    var showAll = options.DicCode || "N" ;
	    
        var url = $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic&Type=" + DicType+'&Code='+DicCode ;
        switch (type) {
            case 'DG':
                $('#' + objectId).datagrid('options').url=url ;
                $('#' + objectId).datagrid('reload');
                break;
            case 'CG':
                $('#' + objectId).combobox('clear');
                $('#' + objectId).combogrid('grid').datagrid('options').url=url ;
                $('#' + objectId).combogrid('grid').datagrid('reload') ;
                break;
            default:
           		$('#' + objectId).combobox({
	           		valueField: valueField,
					textField: textField
	           	});
	           	var combobox;
	           	$('#' + objectId).combobox('clear');
                $('#' + objectId).combobox('reload', url);
                break;
        }
    } catch (error) {
        $.messager.alert('提示','dhcinsu.common.js中方法:INSULoadDicData()发生错误:' + error,'info');
    }
}
/*
* 文件夹选择框
* tangzf 2019-08-09
* input: funOpt : 回调方法   调用成功以后给回调方法传入  界面选择的路径 
* output: 			
*/
function FileOpenWindow(funOpt) {
    try {
        if (typeof funOpt != 'function') {
            $.messager.alert('提示', '传入的方法未定义', 'info');
            return;
        } else {
            if ($('#FileWindowDiv').length == 0) {
                $('#FileWindowDiv').empty();
                $FileWindowDiv = $("<a id='FileWindowDiv' class='FileWindow' style='display:none'>&nbsp;</a>");
                $("body").append($FileWindowDiv);
                $FileWindow = $("<input id='FileWindow' type='file' name='upload'/>");
                $("#FileWindowDiv").append($FileWindow);
                
                
            }
            $("#FileWindow").off('input');
            $("#FileWindow").on('input', function (e) {
                var FilePath = $('#FileWindow').val();
                FilePath=FilePath.replace("fakepath\\","")
                funOpt(FilePath);
            });
            $('#FileWindow').val("");
            $('#FileWindow').select();
            $(".FileWindow input").click();
        }
    } catch (error) {
        $.messager.alert('提示','dhcinsu.common.js中方法:FileOpenWindow()发生错误:' + error,'info');
    }
    
}
/*
* json转xml串
* tangzf 2019-11-18
* input: json 
* output: xml串	
* ---------------------------Start	
*/
function json2xml(json, options) {
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
        exceptions: []
}
var settings = {};
function convertToXml(json, tagName, parentPath, depth) {
        //var suffix = (settings.formatOutput) ? '\r\n' : '';
       // var indent = (settings.formatOutput) ? getIndent(depth) : '';
       var suffix="";
       var indent="";
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
function getIndent(depth) {
        var output = '';
        for (var i = 0; i < depth; i++) {
            output += settings.indentString;
        }
        return output;
    };
function getPropertyName(parentPath, name) {
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
function createNodeFromArray(source, name, path, depth, suffix) {
        var xmlNode = '';
        if (source.length > 0) {
            for (var index in source) {
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
                else {
                    xmlNode += convertToXml(source[index], name, path, depth);
                }
            }
        }
        else {
            xmlNode += getIndent(depth) + '<' + name + '/>' + suffix;
        }
        return xmlNode;
}
function createTextNode(name, text, parentDepth, suffix) {
        var textPrefix = (settings.formatTextNodes)
			? suffix + getIndent(parentDepth + 2) : '';
        var textSuffix = (settings.formatTextNodes)
			? suffix + getIndent(parentDepth + 1) : '';
        var xmlNode = getIndent(parentDepth + 1) + '<' + name + '>'
					+ textPrefix + text + textSuffix
					+ '</' + name + '>' + suffix;
        return xmlNode;
}
/*
* json转xml串
* tangzf 2019-11-18
* input: json 
* output: xml串	
* --------------------end	
*/


/*
* 检查传入字符串是否包含指定字符串
* tangzf 2019-11-18
* input: 
* str: 字符串
* msg: 提示标签
* checkStr: 指定字符串，有默认
* output: 0 不包含 ; 抛异常 包含 并且给出提示
*/
function INSUcheckText(str,msg,checkStr){
	if(!checkStr){
		checkStr = "^ < > ' \\ / ";	
	}
	if(!msg){
		msg = "输入框";	
	}
	var rtn = "0";
	for (var i = 0; i < str.length; i++) {
		if (checkStr.indexOf(str.substr(i, 1)) >= 0) {
			rtn = "1";
			$.messager.alert('提示', '[' + msg +']' + '不能包含特殊字符：' + checkStr, 'error');
			throw msg;
		}
	}
	return rtn;		
}
/*
* 将指定日期转换成 年月日时分秒 连续字符串
* tangzf 2019-11-18
* input: timeObj 
* output: 年月日时分秒 连续字符串	
* --------------------end	
*/
function nowTimeObjToFormatTime(timeObj){
	timeObj=timeObj||'';
	var preg=/(^[0-9][0-9]{9}$)|(^[0-9][0-9]{12}$)/;
	if(typeof timeObj=='object'&&timeObj instanceof Date){
	   timeObj=timeObj;
	}else if(preg.test(timeObj.toString().replace(/(^\s*)|(\s*$)/g,""))){
	    var newStr=timeObj.toString().replace(/(^\s*)|(\s*$)/g,"");
	    if(newStr.length==10){
	        newStr=newStr+'000';
	    }
	    timeObj=Number(newStr);
	    timeObj=new Date(timeObj);
	}else{
	   timeObj=new Date();
	}

	var startYear=timeObj.getFullYear();
	var startMonth=timeObj.getMonth()+1;
	var startDay=timeObj.getDate();
	var startHours=timeObj.getHours();
	var startMinutes=timeObj.getMinutes();
	var startSeconds=timeObj.getSeconds();


	if(startMonth<10){
	    startMonth='0'+startMonth;//0-11
	}
	if(startDay<10){
	    startDay='0'+startDay;//1-31
	}
	if(startHours==0||startHours<10){
	    startHours='0'+startHours;//0-23
	}
	if(startMinutes==0||startMinutes<10){
	    startMinutes='0'+startMinutes;//0-59
	}
	if(startSeconds==0||startSeconds<10){
	    startSeconds='0'+startSeconds;//0-59
	}
	var formatTime=startYear  + "" + startMonth + "" + startDay + "" + startHours + "" + startMinutes + "" + startSeconds;
	return formatTime;
}



/*
* 文件选择弹窗
* DingSH 20200429
*    input: 
*          FileFilter ：文件过滤表达 ,非必填
*                       例如 "Excel xlsx (*.xlsx), *.xlsx,Excel xls (*.xls), *.xls" 或 "Text Files (*.txt), *.txt  
* 使用说明:
*          1 CSP 文件需要引入标签 <ADDINS require="CmdShell"/> 
*          2 需要部署东华医为客户端管理中间件并启用 
*          3 一般和websys_ReadExcel(filePath)函数(此函数返回一个二维数组) 联合使用
* 存在问题：弹窗不置顶
*   output:   
*          文件所在的客户端绝对路径 例如C:\test.xls			
*/
function OpenFileDialog(FileFilter) {
	if ("undefined" == typeof FileFilter){
		FileFilter="Excel xlsx (*.xlsx), *.xlsx,Excel xls (*.xls), *.xls";
		}
	 var filePath=""
     var exec= '(function func(){ var xlApp  = new ActiveXObject("Excel.Application");'
	            +'var fName=xlApp.GetOpenFilename("'+FileFilter+'");'
	            +'if (!fName){fName="";}'
	            +'xlApp.Quit();'
                +'xlSheet=null;'
                +'xlApp=null;'
	            +'return fName;}());'
	   CmdShell.notReturn = 0;
       var rs=CmdShell.EvalJs(exec);
       if(rs.msg == 'success'){
          filePath = rs.rtn;
       }else{
          $.messager.alert('提示', '打开文件错误！'+rs.msg,'error');
       }		
       return filePath;
}
/**
 * 判断传入 日期的大小关系
 * @method DHCINSUCheckDate
 * @param {String} date1 日期1
 * @param {String} date2 日期2
 * @author tangzf
 * @return  0: data1>date2 ; 1: date1<date2 ; 2 : date1=date2
 */
function DHCINSUCheckDate(date1,date2) {
	var rtn = -1;
    date1 = tkMakeServerCall("websys.Conversions","DateHtmlToLogical",date1); 
    date2 = tkMakeServerCall("websys.Conversions","DateHtmlToLogical",date2); 
    if (date1 > date2){
		rtn = 0;
	}else if (date1<date2){
		rtn = 1;
	}else if (date1==date2){
		rtn = 2;
	}
    return rtn;
}
/**
 * 根据入参获取对应grid的对象
 * @method loadDataGridStore
 * @param {String} gridIndex 表格序号 gridIndex 0:pat,1:,2:tar,3:ord
 * @param {type} 要获取指定表格的哪个对象/值【tr,td,field,td-div,tdHead,td】
 * @author tangzf
 */
 // INSUMIDataGrid.setValueToEditor
var DHCINSUDataGrid={ 
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
                this.setValueToEditor(gridId,index,field, val);
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
function DHCINSUPOP(msg,type){
	type = type || 'info';
	$.messager.popover({
		msg:msg,
		type:type	
	});
}
function DHCINSUClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
}
 // 获取datagrid正在编辑的行号
function DHCINSUGetEditRowIndexByID(gridId){
	var tr = $('#' + gridId).siblings().find('.datagrid-editable').parent().parent();//
	var SelectIndex = tr.attr('datagrid-row-index') || -1; 
	return SelectIndex
}
/*
* 拼接URL参数拼接
* DingSH 2021-01-11
* input: URLParams,name,value
* output: name1=value1&name2=value2&...&namen=valuen
* 示例:
* URLParams""
* URLParams=AddQryParam(URLParams,"psn_no","90000109");
* URLParams=AddQryParam(URLParams,"cum_ym","000");
* URLParams=AddQryParam(URLParams,"insuplc_admdvs","440200");
* --------------------end	
*/
function AddURLParam(URLParams,name,value){
	return URLParams+="&"+name+"="+value;
}
/*
*动态加载js文件
* DingSH 20210111
*
*/
function loadJS(url,callback,loadMod){
	var ldd=loadMod || 0 ; 
	if (ldd == 0)
	{
		var tcol=document.getElementsByTagName("script");
		var len = tcol.length,
		    flag=0 ;
		var oldscrpt=null;
		for(var i=1;i<len;i++)
		{
			if(tcol[i].src.indexOf(url.replace("..",""))>0)
			{
			    flag=1;
			    oldscrpt = tcol[i];    //js 已存在
				break;
			}
		}
		tcol=null;
		//if (flag == 1){return;}     //注释掉 DingSH 20210518
		if (flag == 1){
			   document.getElementsByTagName('head')[0].removeChild(oldscrpt); 
			   oldscrpt=null;
			}
	}
    var script = document.createElement('script'),
    fn = callback || function(){};
    script.type = 'text/javascript';
    //IE
    if(script.readyState){
        script.onreadystatechange = function(){
            if( script.readyState == 'loaded' || script.readyState == 'complete' ){
                script.onreadystatechange = null;
                fn();
            }
        };

    }else{
        //其他浏览器
        script.onload = function(){
            fn();
        };
    }
    script.src = url;
    document.getElementsByTagName('head')[0].appendChild(script);
}

/*
* 日期元素转换成YYYY-MM-DD格式
* DingSH 20210526
* diff: -1,-2,-3,... :前推几天, 0:当前,1,2,3,... :后推几天
*/
function InsuDateDefault(elm,diff){
	
	var diffNum= Number(diff) || 0;
	var CurDate=new Date();
	TargetDate=new Date(CurDate.getTime()+diffNum*(24*60*60*1000));
var Default=TargetDate.getFullYear()+"-"+formatNumber(TargetDate.getMonth()+1)+"-"+formatNumber(TargetDate.getDate());
$('#'+elm).datebox({
  value:Default,
  formatter:function(date){
   var y = date.getFullYear();
   var m = date.getMonth()+1;
   var d = date.getDate();
   return y+'-'+formatNumber(m)+'-'+formatNumber(d);
  },
  parser:function(s){
   var t = Date.parse(s);
   if (!isNaN(t)){
    return new Date(t);
   } else {
    return new Date();
   }
  }
 });
  function formatNumber(value){
    return (value < 10 ? '0' : '') + value;
   }
}

/*    根据界面日期转换成医保接口所需日期格式
 *    入参说明：
 *    dt：UI界面日期
 *    format:日期格式数值 1 MM/DD/YYYY; 3 YYYY-MM-DD;4 DD/MM/YYYY   
 *    示例：GetInsuDateFormat("26/5/2021")或GetInsuDateFormat("26/5/2021",4)
 *    DingSH 20210526
*/
function GetInsuDateFormat(dt,format)
{
   var format = format||3;
   var rtn=tkMakeServerCall("web.DHCINSUPort","GetInsuDateFormat",dt,format);
   return rtn;
}



/**
 * 导出 json 数据为 Excle 表格(.CSV格式)
 * @param {json} data 要导出的 json 数据 
 * @param {String} head 表头, 可选 参数示例：'名字,邮箱,电话'
 * @param {*} name 导出的文件名, 可选
 * 举例子 jsonToExcel(fileData, "权限标识,创建账户,字典标签,序号,创建时间,字典类型,父字典键值,字典键值,版本号",getValueById('type')+"字典导出")
 */
 //+ 20220923  LuJH,DingSH
function jsonToExcel(data, head) {
    var name = arguments.length <= 2 || arguments[2] === undefined ? '导出的文件名' : arguments[2];

    var str = head ? head + '\n' : '';
    data.forEach(function (item) {
        // 拼接json数据, 增加 \t 为了不让表格显示科学计数法或者其他格式
        for (var key in item) {
            str = str + item[key] + '\t' + ',';
        }
        str += '\n';
    });
    //console.log(str)
    // encodeURIComponent解决中文乱码
    var uri = 'data:text/csv;charset=utf-8,\ufeff﻿' + encodeURIComponent(str);
    // 通过创建a标签实现
    var link = document.createElement("a");
    link.href = uri;
    // 对下载的文件命名
    link.download = '' + (name + '.csv');
    link.click();
}




/*
 * Excel操作对象封装-持续更新
 * DingSH 20211208 
 * 支持 医为浏览器、医为中间件
 * 示例
      var INSUExcel=new INSU_ExcelTool();
	  var fileOption={
           title: "提示",
           msg: '文件导入中',
           text: '数据读取中...'
        }
     var readOption={
           title: "提示",
           msg: '医保目录导入中',
        }   
     var saveOption={
	    SucRtnVal:0,
	    ErrRtnVal:-1,
	    ClassName:"web.INSUTarItemsCom",
	    MethodName:"Update",
	   }  
	   var C2=String.fromCharCode(2); //m  $c(2)
	   var Args=[];
	   Args[0]="itmjs"+C2+"";
	   Args[1]="itmjsex"+C2+"";
	   Args[2]="InString"+C2+"{}";  //{}  读excel 会对 {} 指定具体值
	   saveOption.Args=Args ;
	   INSUExcel.ExcelImport(fileOption,readOption,saveOption); 
*/

var INSU_ExcelTool =(function()
{
/*
 *示例
  var option={
           title: "提示",
           msg: '文件导入中',
           text: '数据读取中...'
        }
  var readOption={
           title: "提示",
           msg: '医保目录导入中',
        }   
  var saveOption={
	    SucRtnVal:0,
	    ErrRtnVal:-1,
	    ClassName:"web.INSUTarItemsCom",
	    MethodName:"Update",
	   }  
	   var C2=String.fromCharCode(2); //m  $c(2)
	   var Args=[];
	   Args[0]="itmjs"+C2+"";
	   Args[1]="itmjsex"+C2+"";
	   Args[2]="InString"+C2+"{}";  //{}  读excel 会对 {} 指定具体值
	   saveOption.Args=Args ;     
*/
function _importFilePath(filePath,option,readOption,saveOption)
{
    if (filePath == "") {
        $.messager.alert('提示', '请选择文件！','info')
        return ;
    }
   $.messager.progress({
         title: option.title||"提示",
         msg:  option.msg|| '文件导入中',
         text: option.text||'数据读取中...'
        }); 
   $.ajax({
	async : true,
	complete : function () {
         _readExcel(filePath,readOption,saveOption);
	}
	});
}
/*读取Excel数据*/
/*
 *示例
  var option={
           title: "提示",
           msg: '医保目录导入中',
        }   
  var saveOption={
	    SucRtnVal:0,
	    ErrRtnVal:-1,
	    ClassName:"web.INSUTarItemsCom",
	    MethodName:"Update",
	   }  
	   var C2=String.fromCharCode(2); //m  $c(2)
	   var Args=[];
	   Args[0]="itmjs"+C2+"";
	   Args[1]="itmjsex"+C2+"";
	   Args[2]="InString"+C2+"{}";  //{}  读excel 会对 {} 指定具体值
	   saveOption.Args=Args ;     
*/
function _readExcel(filePath,option,saveOption)
{
	
   var arr;
   try 
   {
	 arr= websys_ReadExcel(filePath);
	 $.messager.progress("close");
	}
   catch(ex)
   {
	  $.messager.progress("close");
	  $.messager.alert('提示', '调用websys_ReadExcel异常：'+ex.message,'error')
	  return ;
	}
	 var rowCnt=arr.length
	 $.messager.progress({
            title: option.title||"提示",
            msg: option.msg||'目录导入',
            text: '导入中，共：'+(rowCnt-1)+'条'
        }); 
	$.ajax({
	   async : true,
	   complete : function () {
        _ExcelDataSave(arr,saveOption);
	}
	});
}
/*Excel数据保存*/
/*
    
     示例:
     var option={
	    SucRtnVal:0,
	    ErrRtnVal:-1,
	    ClassName:"web.INSUTarItemsCom",
	    MethodName:"Update",
	   }  
	   var C2=String.fromCharCode(2); //m  $c(2)
	   var Args=[];
	   Args[0]="itmjs"+C2+"";
	   Args[1]="itmjsex"+C2+"";
	   Args[2]="InString"+C2+"{}";  //{}  读excel 会对 {} 指定具体值
	   option.Args=Args ;
*/
function _ExcelDataSave(arr,option)
{
	//读取保存数据
	var ErrMsg = "";     //错误数据
    var errRowNums = 0;  //错误行数
    var sucRowNums = 0;  //导入成功的行数
    var SucRtnVal=option.ErrVal||0;    //调用函数成功返回值;
	var ErrRtnVal=option.SucVal||-1;   //调用函数成功返回值;
	var ClassName=option.ClassName;    //类名
	var MethodName=option.MethodName;  //类方法名m
	//st-构建$.m需要参数
	var mOption={
		 ClassName:option.ClassName||"",
		 MethodName:option.MethodName||"",
		}
	if 	((mOption.ClassName == "")||(mOption.MethodName == "")){
		 $.messager.alert('提示', '类方法和函数不能为空'+ex.message,'error')
	      return ;
		}
	var Args = 	option.Args||new Array();
	var SaveArgName="";
	var ArgsCnt=Args.length;
	 for (i = 0; i < ArgsCnt; i++)
	 {
		  var C2=String.fromCharCode(2); //m  $c(2)
		  var argName= Args[i].split(C2)[0];
		  var argVal= Args[i].split(C2)[1]||"";
		  if(argVal=="{}") {
			  SaveArgName=argName;
			  continue
			  }
		mOption[argName]=argVal;
	 }	
	 if (mOption.SaveArgName == ""){
		 $.messager.alert('提示', '指定类方法中保存数据的参数名不能为空','error')
	      return ;
		}
	 //ed-构建$.m需要参数
	var rowCnt=arr.length;
	 try{
		 for (i = 1; i < rowCnt; i++) 
		 {
			  var rowArr=arr[i]
			  var SaveStr="^"+rowArr.join("^");
			  //var rtnVal = tkMakeServerCall(ClassName, MethodName, "", "", SaveStr)
			  mOption[SaveArgName]=SaveStr;
			  var rtnVal = $.m(mOption, false);
            //if (savecode == null || savecode == undefined) savecode = -1;
             if (rtnVal == null || rtnVal == undefined) rtnVal = option.ErrRtnVal||-1;
                    if (rtnVal >= SucRtnVal) {
                        sucRowNums = sucRowNums + 1;
                    } else {
                        errRowNums = errRowNums + 1;
                        if (ErrMsg == "") {
                            ErrMsg = i+":"+rtnVal;
                        } else {
                            ErrMsg = ErrMsg + "<br>" + i+":"+rtnVal;
                        }
                    }
		 }
		 if (ErrMsg == "") {
                    $.messager.progress("close");
                    $.messager.alert('提示', '数据正确导入完成');
                } else {
                   $.messager.progress("close");
                     var tmpErrMsg = "导入成功："+sucRowNums +"条，失败："+errRowNums+"条。";
                     tmpErrMsg = tmpErrMsg + "<br>失败数据行号：<br>"+ ErrMsg;
                    $.messager.alert('提示', tmpErrMsg,'info');
                }
		      return ;
		 }
		 catch(ex)
		 {
			  $.messager.progress("close");
			  $.messager.alert('提示', '保存[_ExcelDataSave]数据异常：'+ex.message,'error')
	          return ;
	      }
  return ;
	
}
//定义对象
function _tool(){
	}
_tool.prototype={
		
/*excel导入*/
/* ExcelImport 入参说明:
    *示例
  var option={
           title: "提示",
           msg: '文件导入中',
           text: '数据读取中...'
        }
  var readOption={
           title: "提示",
           msg: '医保目录导入中',
        }   
  var saveOption={
	    SucRtnVal:0,
	    ErrRtnVal:-1,
	    ClassName:"web.INSUTarItemsCom",
	    MethodName:"Update",
	   }  
	   var C2=String.fromCharCode(2); //m  $c(2)
	   var Args=[];
	   Args[0]="itmjs"+C2+"";
	   Args[1]="itmjsex"+C2+"";
	   Args[2]="InString"+C2+"{}";  //{}  读excel 会对 {} 指定具体值
	   saveOption.Args=Args ;     
    */
	ExcelImport:function(fileOptions,readOption,saveOption){
       var filePath=""
	   var exec= '(function tst(){ var xlApp  = new ActiveXObject("Excel.Application");'
	            +'var fName=xlApp.GetOpenFilename("Excel xlsx (*.xlsx), *.xlsx,Excel xls (*.xls), *.xls");'
	            +'if (!fName){fName="";}'
	            +'xlApp.Quit();'
                +'xlSheet=null;'
                +'xlApp=null;'
	            +'return fName;}());'
	   CmdShell.notReturn = 0;
       var rs=CmdShell.EvalJs(exec);
       if(rs.msg == 'success'){
          filePath = rs.rtn;
          _importFilePath(filePath,fileOptions,readOption,saveOption);
       }else{
          $.messager.alert('提示', '打开文件错误！'+rs.msg,'error');
       }		
		
		}
	
   }
	return _tool;
})();

/** Creator: 靳帅1010
 CreateDate: 2022-10-21
 Descript: 通过交易编号,父节点代码，参数代码,院区,参数内容,比较前端传入参数长度和后台获取的参数长度，超长则截断
 Table : CF.INSU.MI.PortCommon
 Input:TransactionCode,Parameter,ParentNodeCode,HospDr,text
 Output: 在最大长度之内的信息

**/
function GetParameterLength(TransactionNumber,ParentNodeCode,ParameterCode,HospDr,text){
	
	var Fromttext=text;
     
	$m({
	 ClassName: "INSU.MI.PortInArgsCom",
	 MethodName: "GetParameterLength",
	 TransactionNumber: TransactionNumber,
	 ParentNodeCode: ParentNodeCode,
	 ParameterCode: ParameterCode,
	 HospDr: HospDr
      },function(textData){
      var MaxLength=Number(textData);
	 if(text.length>MaxLength)
	 {
		 Fromttext=text.substring(0,MaxLength);
	
		 }
	  
     });
  
  
	  return Fromttext;
	   
	  
	  
	}

