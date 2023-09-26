/*
* FileName:	dhcinsu.common.js
* User:		tangzf 
* Date:		2019-08-09	
* Description: ҽ��ͨ��js
*/


/*
* ����URL�����еĲ���
* DingSH 2019-06-06
* input:
* output: 
*			theRequest ��URL�Ĳ������� �� theRequest['param1'],theRequest['param2'],
*/
function INSUGetRequest() {
    try {
        var url = location.search; //��ȡurl��"?"������ִ� 
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
        $.messager.alert('��ʾ','dhcinsu.common.js�з���:INSUGetRequest()��������:' + error,'info');
    }
    
}
/*
* ����ҽ���ֵ������
* tangzf 2019-08-09
* input: objectId : Ԫ�� Id ; ����
*		 DicType : �ֵ���� ; ����
*		 options. :	(ѡ��)
*		 	DicCode : �ֵ���� ; 
*		 	type :  �ؼ�����   CB ��'combobox' ; DG��'datagrid' CG��'combogrid' ;��Ϊ�� Ϊ��ʱ ��combobox����
*		 	valueField : combo Id	Ĭ��=id
*		 	textField : combo ��ʾֵ  Ĭ��=cDesc
*		 	showAll : ���س���com �Ƿ���ʾ 'ȫ��'ѡ��; Y �� '����'  Ĭ�ϲ�����
*		 	editable : �Ƿ�ɱ༭ true�ɱ༭ Ĭ�ϲ��ɱ༭
*		 	defaultFlag ���Ƿ�Ĭ��ֵ  
*           DicOPIPFlag :�������ݱ�ʶ ���� IP �� OP + DingSH 20200527 
*           hospDr:Ժ�� + DingSH 20200527 
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
            		data.splice(data.length - 1, 1); // ��query���ص� ȫ�� ȥ��
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
        $.messager.alert('��ʾ', 'dhcinsu.common.js�з���:INSULoadDicData()��������:' + error, 'info');
    }
}
/*
* ����ҽ���ֵ������
* tangzf 2019-08-09
* input: objectId : Ԫ�� Id ; 
*		 DicType : �ֵ���� ;
*		 DicCode : �ֵ���� ; 
*		 type :  �ؼ�����   CB ��'combobox' ; DG��'datagrid' CG��'combogrid' ;��Ϊ�� Ϊ��ʱ ��combobox����
*		 valueField : combo Id
*		 textField : combo ��ʾֵ
*		 showAll : ���س���com �Ƿ���ʾȫ�� Y �� '����'  Ĭ�ϲ�����
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
        $.messager.alert('��ʾ','dhcinsu.common.js�з���:INSULoadDicData()��������:' + error,'info');
    }
}
/*
* �ļ���ѡ���
* tangzf 2019-08-09
* input: funOpt : �ص�����   ���óɹ��Ժ���ص���������  ����ѡ���·�� 
* output: 			
*/
function FileOpenWindow(funOpt) {
    try {
        if (typeof funOpt != 'function') {
            $.messager.alert('��ʾ', '����ķ���δ����', 'info');
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
        $.messager.alert('��ʾ','dhcinsu.common.js�з���:FileOpenWindow()��������:' + error,'info');
    }
    
}
/*
* jsonתxml��
* tangzf 2019-11-18
* input: json 
* output: xml��	
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
* jsonתxml��
* tangzf 2019-11-18
* input: json 
* output: xml��	
* --------------------end	
*/


/*
* ��鴫���ַ����Ƿ����ָ���ַ���
* tangzf 2019-11-18
* input: 
* str: �ַ���
* msg: ��ʾ��ǩ
* checkStr: ָ���ַ�������Ĭ��
* output: 0 ������ ; ���쳣 ���� ���Ҹ�����ʾ
*/
function INSUcheckText(str,msg,checkStr){
	if(!checkStr){
		checkStr = "^ < > ' \\ / ";	
	}
	if(!msg){
		msg = "�����";	
	}
	var rtn = "0";
	for (var i = 0; i < str.length; i++) {
		if (checkStr.indexOf(str.substr(i, 1)) >= 0) {
			rtn = "1";
			$.messager.alert('��ʾ', '[' + msg +']' + '���ܰ��������ַ���' + checkStr, 'error');
			throw msg;
		}
	}
	return rtn;		
}
/*
* ��ָ������ת���� ������ʱ���� �����ַ���
* tangzf 2019-11-18
* input: timeObj 
* output: ������ʱ���� �����ַ���	
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
* �ļ�ѡ�񵯴�
* DingSH 20200429
*    input: 
*          FileFilter ���ļ����˱�� ,�Ǳ���
*                       ���� "Excel xlsx (*.xlsx), *.xlsx,Excel xls (*.xls), *.xls" �� "Text Files (*.txt), *.txt  
* ʹ��˵��:
*          1 CSP �ļ���Ҫ�����ǩ <ADDINS require="CmdShell"/> 
*          2 ��Ҫ���𶫻�ҽΪ�ͻ��˹����м�������� 
*          3 һ���websys_ReadExcel(filePath)����(�˺�������һ����ά����) ����ʹ��
* �������⣺�������ö�
*   output:   
*          �ļ����ڵĿͻ��˾���·�� ����C:\test.xls			
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
          $.messager.alert('��ʾ', '���ļ�����'+rs.msg,'error');
       }		
       return filePath;
}