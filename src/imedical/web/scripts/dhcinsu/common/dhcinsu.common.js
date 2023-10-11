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
/**
 * �жϴ��� ���ڵĴ�С��ϵ
 * @method DHCINSUCheckDate
 * @param {String} date1 ����1
 * @param {String} date2 ����2
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
 * ������λ�ȡ��Ӧgrid�Ķ���
 * @method loadDataGridStore
 * @param {String} gridIndex ������ gridIndex 0:pat,1:,2:tar,3:ord
 * @param {type} Ҫ��ȡָ�������ĸ�����/ֵ��tr,td,field,td-div,tdHead,td��
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
	//����datagrid�ı༭����ֵ ����ʹ��setGridVal ���и�ֵ
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
    // ��ȡ�༭���ֵ
    getCellVal: function (dg,index,field) {
		var rtn = '';
		var editor = $('#' + dg).datagrid('getEditor', {
      		index: index,
      		field: field
		});
		if(editor){ // �༭����ֵ
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
		}else{ // �Ǳ༭����
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
			// �����
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
				
			}else if(jObj[0].tagName=="A"){  //��ť�޸���ʾֵ 2018-07-23 
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
    // ������
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
				// �����
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
 // ��ȡdatagrid���ڱ༭���к�
function DHCINSUGetEditRowIndexByID(gridId){
	var tr = $('#' + gridId).siblings().find('.datagrid-editable').parent().parent();//
	var SelectIndex = tr.attr('datagrid-row-index') || -1; 
	return SelectIndex
}
/*
* ƴ��URL����ƴ��
* DingSH 2021-01-11
* input: URLParams,name,value
* output: name1=value1&name2=value2&...&namen=valuen
* ʾ��:
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
*��̬����js�ļ�
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
			    oldscrpt = tcol[i];    //js �Ѵ���
				break;
			}
		}
		tcol=null;
		//if (flag == 1){return;}     //ע�͵� DingSH 20210518
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
        //���������
        script.onload = function(){
            fn();
        };
    }
    script.src = url;
    document.getElementsByTagName('head')[0].appendChild(script);
}

/*
* ����Ԫ��ת����YYYY-MM-DD��ʽ
* DingSH 20210526
* diff: -1,-2,-3,... :ǰ�Ƽ���, 0:��ǰ,1,2,3,... :���Ƽ���
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

/*    ���ݽ�������ת����ҽ���ӿ��������ڸ�ʽ
 *    ���˵����
 *    dt��UI��������
 *    format:���ڸ�ʽ��ֵ 1 MM/DD/YYYY; 3 YYYY-MM-DD;4 DD/MM/YYYY   
 *    ʾ����GetInsuDateFormat("26/5/2021")��GetInsuDateFormat("26/5/2021",4)
 *    DingSH 20210526
*/
function GetInsuDateFormat(dt,format)
{
   var format = format||3;
   var rtn=tkMakeServerCall("web.DHCINSUPort","GetInsuDateFormat",dt,format);
   return rtn;
}



/**
 * ���� json ����Ϊ Excle ���(.CSV��ʽ)
 * @param {json} data Ҫ������ json ���� 
 * @param {String} head ��ͷ, ��ѡ ����ʾ����'����,����,�绰'
 * @param {*} name �������ļ���, ��ѡ
 * ������ jsonToExcel(fileData, "Ȩ�ޱ�ʶ,�����˻�,�ֵ��ǩ,���,����ʱ��,�ֵ�����,���ֵ��ֵ,�ֵ��ֵ,�汾��",getValueById('type')+"�ֵ䵼��")
 */
 //+ 20220923  LuJH,DingSH
function jsonToExcel(data, head) {
    var name = arguments.length <= 2 || arguments[2] === undefined ? '�������ļ���' : arguments[2];

    var str = head ? head + '\n' : '';
    data.forEach(function (item) {
        // ƴ��json����, ���� \t Ϊ�˲��ñ����ʾ��ѧ����������������ʽ
        for (var key in item) {
            str = str + item[key] + '\t' + ',';
        }
        str += '\n';
    });
    //console.log(str)
    // encodeURIComponent�����������
    var uri = 'data:text/csv;charset=utf-8,\ufeff�1�3' + encodeURIComponent(str);
    // ͨ������a��ǩʵ��
    var link = document.createElement("a");
    link.href = uri;
    // �����ص��ļ�����
    link.download = '' + (name + '.csv');
    link.click();
}




/*
 * Excel���������װ-��������
 * DingSH 20211208 
 * ֧�� ҽΪ�������ҽΪ�м��
 * ʾ��
      var INSUExcel=new INSU_ExcelTool();
	  var fileOption={
           title: "��ʾ",
           msg: '�ļ�������',
           text: '���ݶ�ȡ��...'
        }
     var readOption={
           title: "��ʾ",
           msg: 'ҽ��Ŀ¼������',
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
	   Args[2]="InString"+C2+"{}";  //{}  ��excel ��� {} ָ������ֵ
	   saveOption.Args=Args ;
	   INSUExcel.ExcelImport(fileOption,readOption,saveOption); 
*/

var INSU_ExcelTool =(function()
{
/*
 *ʾ��
  var option={
           title: "��ʾ",
           msg: '�ļ�������',
           text: '���ݶ�ȡ��...'
        }
  var readOption={
           title: "��ʾ",
           msg: 'ҽ��Ŀ¼������',
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
	   Args[2]="InString"+C2+"{}";  //{}  ��excel ��� {} ָ������ֵ
	   saveOption.Args=Args ;     
*/
function _importFilePath(filePath,option,readOption,saveOption)
{
    if (filePath == "") {
        $.messager.alert('��ʾ', '��ѡ���ļ���','info')
        return ;
    }
   $.messager.progress({
         title: option.title||"��ʾ",
         msg:  option.msg|| '�ļ�������',
         text: option.text||'���ݶ�ȡ��...'
        }); 
   $.ajax({
	async : true,
	complete : function () {
         _readExcel(filePath,readOption,saveOption);
	}
	});
}
/*��ȡExcel����*/
/*
 *ʾ��
  var option={
           title: "��ʾ",
           msg: 'ҽ��Ŀ¼������',
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
	   Args[2]="InString"+C2+"{}";  //{}  ��excel ��� {} ָ������ֵ
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
	  $.messager.alert('��ʾ', '����websys_ReadExcel�쳣��'+ex.message,'error')
	  return ;
	}
	 var rowCnt=arr.length
	 $.messager.progress({
            title: option.title||"��ʾ",
            msg: option.msg||'Ŀ¼����',
            text: '�����У�����'+(rowCnt-1)+'��'
        }); 
	$.ajax({
	   async : true,
	   complete : function () {
        _ExcelDataSave(arr,saveOption);
	}
	});
}
/*Excel���ݱ���*/
/*
    
     ʾ��:
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
	   Args[2]="InString"+C2+"{}";  //{}  ��excel ��� {} ָ������ֵ
	   option.Args=Args ;
*/
function _ExcelDataSave(arr,option)
{
	//��ȡ��������
	var ErrMsg = "";     //��������
    var errRowNums = 0;  //��������
    var sucRowNums = 0;  //����ɹ�������
    var SucRtnVal=option.ErrVal||0;    //���ú����ɹ�����ֵ;
	var ErrRtnVal=option.SucVal||-1;   //���ú����ɹ�����ֵ;
	var ClassName=option.ClassName;    //����
	var MethodName=option.MethodName;  //�෽����m
	//st-����$.m��Ҫ����
	var mOption={
		 ClassName:option.ClassName||"",
		 MethodName:option.MethodName||"",
		}
	if 	((mOption.ClassName == "")||(mOption.MethodName == "")){
		 $.messager.alert('��ʾ', '�෽���ͺ�������Ϊ��'+ex.message,'error')
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
		 $.messager.alert('��ʾ', 'ָ���෽���б������ݵĲ���������Ϊ��','error')
	      return ;
		}
	 //ed-����$.m��Ҫ����
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
                    $.messager.alert('��ʾ', '������ȷ�������');
                } else {
                   $.messager.progress("close");
                     var tmpErrMsg = "����ɹ���"+sucRowNums +"����ʧ�ܣ�"+errRowNums+"����";
                     tmpErrMsg = tmpErrMsg + "<br>ʧ�������кţ�<br>"+ ErrMsg;
                    $.messager.alert('��ʾ', tmpErrMsg,'info');
                }
		      return ;
		 }
		 catch(ex)
		 {
			  $.messager.progress("close");
			  $.messager.alert('��ʾ', '����[_ExcelDataSave]�����쳣��'+ex.message,'error')
	          return ;
	      }
  return ;
	
}
//�������
function _tool(){
	}
_tool.prototype={
		
/*excel����*/
/* ExcelImport ���˵��:
    *ʾ��
  var option={
           title: "��ʾ",
           msg: '�ļ�������',
           text: '���ݶ�ȡ��...'
        }
  var readOption={
           title: "��ʾ",
           msg: 'ҽ��Ŀ¼������',
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
	   Args[2]="InString"+C2+"{}";  //{}  ��excel ��� {} ָ������ֵ
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
          $.messager.alert('��ʾ', '���ļ�����'+rs.msg,'error');
       }		
		
		}
	
   }
	return _tool;
})();

/** Creator: ��˧1010
 CreateDate: 2022-10-21
 Descript: ͨ�����ױ��,���ڵ���룬��������,Ժ��,��������,�Ƚ�ǰ�˴���������Ⱥͺ�̨��ȡ�Ĳ������ȣ�������ض�
 Table : CF.INSU.MI.PortCommon
 Input:TransactionCode,Parameter,ParentNodeCode,HospDr,text
 Output: ����󳤶�֮�ڵ���Ϣ

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

