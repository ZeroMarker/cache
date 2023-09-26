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
            theRequest[strs[i].split("=")[0]] = unescape(strs[i].split("=")[1]);
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
                
                $("#FileWindow").on('input', function (e) {
                    var FilePath = $('#FileWindow').val();
                    FilePath=FilePath.replace("fakepath\\","")
                    funOpt(FilePath);
                });
            }
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