﻿$(function(){
	//node = {'id':'23','text':'胆石症','attributes':{'type':'KBNode','desc':'','isCommon':'Y','isInUse':'Y','isEmpty':'N'}};
	init();
});

///创建编辑器//////////////////////////////////////////////////////////////////////////////////////

//挂接插件\事件监听
function pluginAdd() {	
	addEvent(plugin(), 'onFailure', function(command){
		alert(command);
	});
    addEvent(plugin(), 'onExecute', function(command){
	   var commandJson = jQuery.parseJSON(command);
	   if (commandJson.action == "eventGetMetaDataTree")
	   {
		   eventGetMetaDataTree(commandJson);
	   }
	   else if (commandJson.action == "eventElementChanged")
	   {
		   eventElementChanged(commandJson);
	   }
	   else if (commandJson.action == "eventAppendElement")
	   {
		   eventAppendElement(commandJson);
	   }
	   else if (commandJson.action == "eventUpdateElement")
	   {
		   eventUpdateElement (commandJson);
	   }
	   else if (commandJson.action == "eventSaveDocument")
	   {
		   eventSaveDocument(commandJson);
	   }
	   else if (commandJson.action == "eventCaretContext")
	   {
		   eventCaretContext(commandJson);
	   }
    });
}
//添加监听事件
function addEvent(obj, name, func)
{
    if (obj.attachEvent) 
    {
        obj.attachEvent("on"+name, func);
    }  
    else 
    {
        obj.addEventListener(name, func, false); 
    }
}
//查找插件
function plugin() {
	return $("#plugin")[0];
}

///方法////////////////////////////////////////////////////////////////////////////////////////

function init()
{
	pluginAdd();
	plugin().initWindow("iEditor");
	//建立数据连接
    var nectresult = setConnect();
    nectresult = typeof nectresult=="object"?nectresult:$.parseJSON(nectresult.replace(/\'/g, "\""));
    if (nectresult != "" && nectresult.result != "OK")
    {
        alert('设置链接失败！');
        return;
    } 
	//设置工作环境
	strJson = {"action":"SET_WORKSPACE_CONTEXT","args": "Composite"};
	cmdDoExecute(strJson);
	var strJson = {action:"SET_DEFAULT_FONTSTYLE",args:defaultFontStyle};
	cmdDoExecute(strJson);		
	setNodeInfo();
	getDataBaseCatalog();
	//获取绑定病历数据目录
	getDataEMRCatalog();
	setFontData();
	setFontSizeData();
}

//建立数据库连接
function setConnect(){
	var netConnect = "";
	
	var port = window.location.port;
	var protocol = window.location.protocol.split(":")[0];
	
	if (protocol == "http")
	{
		port = port==""?"80":port;
	}
	else if (protocol == "https")
	{
		port = port==""?"443":port;
	}
	
	$.ajax({
		type: 'Post',
		dataType: 'text',
		url: '../EMRservice.Ajax.common.cls',
		async: false,
		cache: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLSysOption",
			"Method":"GetNetConnectJson",
			"p1":window.location.hostname,
			"p2":port,
			"p3":protocol
		},
		success: function (ret) {

			netConnect = eval("("+ret+")");
		},
		error: function (ret) {
			alert('get err');
			if (!onError) {}
			else {
				onError(ret);
			}
		}
	});
	var strJson = {action:"SET_NET_CONNECT",args:netConnect};
	return cmdSyncExecute(strJson);
}

//设置知识库结点信息
function setNodeInfo()
{
	$("#nodeText").val(node.text);
	if (node.attributes.isCommon.toUpperCase() == "Y")
	{
		$("#chkCommon").attr("checked",true);	
	}
	else
	{
		$("#chkCommon").attr("checked",false);
	}
	if (node.attributes.isInUse.toUpperCase() == "N")
	{
		$("#nodeStatus").text(emrTrans("启用"));
	}
	else
	{
		$("#nodeStatus").text(emrTrans("停用"));
	}
	$("#nodeDesc").val(node.desc);
	if (node.attributes.isEmpty.toUpperCase() == "Y")
	{
		createComposite();
	}
	else
	{
		loadComposite();
	}
	loadStructTree();
}

//将MeteData json 转成easyui tree标准json
function convertToTreeJson(dataList,treeJson,path)
{
	var tempJson = "";
	for (var i=0;i<dataList.length;i++) 
	{
		 var tempPath = "";
		 if (path != undefined && path != "") tempPath = path + "_" + dataList[i].Code;else tempPath = dataList[i].Code;
		 if (dataList[i].items != undefined) 
		 {
			 
			tempJson = {"id":tempPath,"text":emrTrans(dataList[i].DisplayName),"attributes":{"path":tempPath,"type":dataList[i].Type},"children":[]};
			convertToTreeJson(dataList[i].items,tempJson.children,tempPath);
			treeJson.push(tempJson);
		 }
		 else
		 {
			tempJson = {"id":tempPath,"text":emrTrans(dataList[i].DisplayName),"attributes":{"path":tempPath,"type":dataList[i].Type}};
			treeJson.push(tempJson);
			setMaxElementObj(dataList[i].Code);
		 }
	}
}
//初始化元素当前最大值(用于创建下一个元素)
function setMaxElementObj(code)
{
	var type = code.substring(0,1);
	var value = code.substring(1);
	switch(type)
	{
		case "L": 
			if (+value > +maxElementObj.MIString) maxElementObj.MIString = value;
			break;
		case "N": 
			if (+value > +maxElementObj.MINumber) maxElementObj.MINumber = value;
			break;
	 	case "D": 
			if (+value > +maxElementObj.MIDateTime) maxElementObj.MIDateTime = value; 
			break;  
		case "O":
			if (+value > +maxElementObj.MIMonoChoice) maxElementObj.MIMonoChoice = value; 
			break;  
	 	case "M": 
			if (+value > +maxElementObj.MIMultiChoice) maxElementObj.MIMultiChoice = value; 
			break;  
		case "I":
			if (+value > +maxElementObj.MIDictionary) maxElementObj.MIDictionary = value; 
			break;  			
	}
}
//获取元素代码
function getNewCode(code)
{
	code = code + 1;
    code = code.toString();
    var count = 3 - code.length;
    for (i=0;i<count;i++)
    {
       code = "0" + code ; 
    }	
    return code;
}

//异步执行execute
function cmdDoExecute(argJson){
	plugin().execute(JSON.stringify(argJson));
};

//同步执行
function cmdSyncExecute(argJson){
	return plugin().syncExecute(JSON.stringify(argJson));
};

//创建知识库
function createComposite()
{
	var strJson = {"action":"CREATE_COMPOSITE","args":{"Code":node.id,"DisplayName":node.text,"KBNodeID":node.id,"Instances":"0..1",
                  "BindKBBaseID":node.KBBaseID,"BindKBName":node.KBBaseName}};                   
	cmdDoExecute(strJson);
}
//加载知识库
function loadComposite()
{
	var	strJson = {"action":"LOAD_DOCUMENT","args":{"params":{"action":"LOAD_COMPOSITE","KBNodeID":node.id}}};
	cmdDoExecute(strJson);
}

//调用加载知识库元素结构
function loadStructTree()
{
	var strJson = {"action":"GET_METADATA_TREE","args":""}
	cmdDoExecute(strJson);
}

//定位元素
function focusElement(path)
{
	var strJson = {action:"FOCUS_ELEMENT",args:{"Path":path,"actionType":"Select"}};
	cmdDoExecute(strJson);
}

//添加元素
$(function(){  
    
    //添加单元
    //字符单元
    $('#MIString').bind('click', function(){  
        maxElementObj.MIString = getNewCode(+maxElementObj.MIString);
        var strJosn = {action:"APPEND_ELEMENT",args:{"ElemType":"MIString","Code":"L"+maxElementObj.MIString,
            "DisplayName":emrTrans("新建字符单元")+(+maxElementObj.MIString)}};
        cmdDoExecute(strJosn);
    });  
    
    //数值单元
    $('#MINumber').bind('click', function(){  
        maxElementObj.MINumber = getNewCode(+maxElementObj.MINumber);
        var strJosn = {action:"APPEND_ELEMENT",args:{"ElemType":"MINumber","Code":"N"+maxElementObj.MINumber,
            "DisplayName":emrTrans("新建数字单元")+(+maxElementObj.MINumber)}};
        cmdDoExecute(strJosn);
    });
    
     //日期单元
    $('#MIDateTime').bind('click', function(){  
        maxElementObj.MIDateTime = getNewCode(+maxElementObj.MIDateTime);
        var strJosn = {action:"APPEND_ELEMENT",args:{"ElemType":"MIDateTime","Code":"D"+maxElementObj.MIDateTime,
            "DisplayName":emrTrans("新建日期单元")+(+maxElementObj.MIDateTime),"IncludeDate":"True","IncludeTime":"True",
            "DateFormat":"yyyy-MM-dd","TimeFormat":"HH:mm:ss"}};
        cmdDoExecute(strJosn);
    });

     //单选单元
    $('#MIMonoChoice').bind('click', function(){  
        maxElementObj.MIMonoChoice = getNewCode(+maxElementObj.MIMonoChoice);
        var strJosn = {action:"APPEND_ELEMENT",args:{"ElemType":"MIMonoChoice","Code":"O"+maxElementObj.MIMonoChoice,
            "DisplayName":emrTrans("新建单选单元")+(+maxElementObj.MIMonoChoice)}};
        cmdDoExecute(strJosn);
    });
    
     //单选单元(平铺)
    $('#MIMonoChoiceCheck').bind('click', function(){  
        maxElementObj.MIMonoChoice = getNewCode(+maxElementObj.MIMonoChoice);
        var strJosn = {action:"APPEND_ELEMENT",args:{"ElemType":"MIMonoChoice","Code":"O"+maxElementObj.MIMonoChoice,
            "DisplayName":emrTrans("新建单选单元")+(+maxElementObj.MIMonoChoice),"Choices":[{"Code":"1","DisplayName":"新建单选框"}],"ShowType":"CheckBox"}};
        cmdDoExecute(strJosn);
    });
     
     //多选单元
    $('#MIMultiChoice').bind('click', function(){  
        maxElementObj.MIMultiChoice = getNewCode(+maxElementObj.MIMultiChoice);
        var strJosn = {action:"APPEND_ELEMENT",args:{"ElemType":"MIMultiChoice","Code":"M"+maxElementObj.MIMultiChoice,
            "DisplayName":emrTrans("新建多选单元")+(+maxElementObj.MIMultiChoice)}};
        cmdDoExecute(strJosn);
    });
    
     //多选单元(平铺)
    $('#MIMultiChoiceCheck').bind('click', function(){  
        maxElementObj.MIMultiChoice = getNewCode(+maxElementObj.MIMultiChoice);
        var strJosn = {action:"APPEND_ELEMENT",args:{"ElemType":"MIMultiChoice","Code":"M"+maxElementObj.MIMultiChoice,
            "DisplayName":emrTrans("新建多选单元")+(+maxElementObj.MIMultiChoice),"Choices":[{"Code":"1","DisplayName":"新建多选框"}],"ShowType":"CheckBox"}};
        cmdDoExecute(strJosn);
    });
    
     //字典单元
    $('#MIDictionary').bind('click', function(){  
        maxElementObj.MIDictionary = getNewCode(+maxElementObj.MIDictionary);
        var strJosn = {action:"APPEND_ELEMENT",args:{"ElemType":"MIDictionary","Code":"I"+maxElementObj.MIDictionary,
            "DisplayName":emrTrans("新建字典单元")+(+maxElementObj.MIDictionary)}};
        cmdDoExecute(strJosn);
    });   
          
	$("#publicSave").click(function(){
		//保存xml
		var strJson = {"action":"SAVE_DOCUMENT","args":{"params":{"action":"SAVE_COMPOSITE","KBNodeID":node.id}}};
		cmdDoExecute(strJson);
		
	});
	$("#sureSelect").click(function(){
		
		if (!$("#BindCode") || $("#BindCode").length <= 0) return;
		
		var tab = $('#databind').tabs('getSelected');
		var bindType = tab[0].id;
		var bindString = "";
		if (bindType == "DataBase")
		{
			var rowCategory = $("#dataBaseCategory").datagrid('getSelected');  
			var rowDetial = $("#dataBaseDeital").datagrid('getSelected'); 
			if (rowCategory && rowDetial)
			{
				bindString = rowCategory.Name + "." + rowDetial.Name + "#TYPE:DataSet#CNAME:"
				+ rowCategory.ClassName + "#QNAME:" + rowCategory.QueryName + "#FNAME:" 
				+ rowDetial.FieldName + "#VALUETYPE:" + rowDetial.ValueType;
			}
		}
		$("#BindCode").val(bindString);
		$("#BindType").val(bindType);
		$("#setPropty").accordion('select','基本属性');

	});
});
/////工具栏//////////////////////////////////////////////////////////////////
//设置字体数据源
function setFontData()
{
	var json=[{"value":"宋体","name":emrTrans("宋体")},
	          {"value":"仿宋","name":emrTrans("仿宋")},
	          {"value":"楷体","name":emrTrans("楷体")},
	          {"value":"黑体","name":emrTrans("黑体")}
	         ]
	$('#font').combobox({
		textField:'name',
		valueField:'value',
		data:json,
		onLoadSuccess:function(){
			$('#font').combobox('setValue',defaultFontStyle.fontFamily)
			},
		onSelect:function(){
			//字体改变
			    var strJson = {action:"FONT_FAMILY",args:$('#font').combobox('getValue')};
				cmdDoExecute(strJson);	
			}
		})	
}
//设置字体大小数据源
function setFontSizeData()
{
	var json=[{"value":"42pt","name":emrTrans("初号")},
  		      {"value":"36pt","name":emrTrans("小初号")},
	          {"value":"31.5pt","name":emrTrans("大一号")},
	          {"value":"28pt","name":emrTrans("一号")},
	          {"value":"21pt","name":emrTrans("二号")},
	          {"value":"18pt","name":emrTrans("小二号")},
	          {"value":"16pt","name":emrTrans("三号")},
	          {"value":"14pt","name":emrTrans("四号")},
	          {"value":"12pt","name":emrTrans("小四号")},
	          {"value":"10.5pt","name":emrTrans("五号")},
	          {"value":"9pt","name":emrTrans("小五号")},
	          {"value":"8pt","name":emrTrans("六号")},
	          {"value":"6.875pt","name":emrTrans("小六号")},
	          {"value":"5.25pt","name":emrTrans("七号")},
	          {"value":"4.5pt","name":emrTrans("八号")},
	          {"value":"5pt","name":"5"},
	          {"value":"5.5pt","name":"5.5"},
	          {"value":"6.5pt","name":"6.5"},
	          {"value":"7.5pt","name":"7.5"},
	          {"value":"8.5pt","name":"8.5"},
	          {"value":"9.5pt","name":"9.5"},
	          {"value":"10pt","name":"10"},
			  {"value":"10.5pt","name":"10.5"},
	          {"value":"11pt","name":"11"}
	         ]
	var oldValue = "";
	$('#fontSize').combobox({
		textField:'name',
		valueField:'value',
		data:json,
		onLoadSuccess:function(){
			$('#fontSize').combobox('setValue',defaultFontStyle.fontSize)
			},
		onSelect:function(){
			oldValue = "";
			var strJson = {action:"FONT_SIZE",args:$('#fontSize').combobox('getValue')};
			document.getElementById('fontSizeText').value = $('#fontSize').combobox('getValue');
			cmdDoExecute(strJson);
			},
	    onShowPanel:function(){
	    	//不支持onclick方法，2023-03-15,下拉时清除值，未做改变时还原值
		    oldValue = $(this).combobox("getValue");	
		    $(this).combobox("setValue","")
		    },
		onHidePanel:function(){
			if(oldValue!==""){
				$(this).combobox("setValue",oldValue)
				}
			}
		});
		
	document.getElementById('fontSizeText').value = defaultFontStyle.fontSize.replace('pt','');
}


//输入字号
function changeFontSizeText()
{
	if(event.keyCode == 13)
	{
		var strJson = {action:"FONT_SIZE",args:document.getElementById('fontSizeText').value};
		cmdDoExecute(strJson);
		document.getElementById('fontSize').value = ""; 
	} 
	
}

//工具栏
function toolButtonClick(type)
{
	var strJson = "";
	if (type == "bold")
	{
		 strJson = {action:"BOLD",args:{path:""}}; //设置粗体
	}
	else if (type == "italic")
	{
		strJson = {action:"ITALIC",args:""};       //设置斜体
	} 
	else if (type == "underline")
	{
		strJson = {action:"UNDER_LINE",args:""};   //设置下划线
	}
	else if (type == "strike")
	{
		strJson = {action:"STRIKE",args:""};
	}
	else if (type == "super")                      //设置上标
	{
		strJson = {action:"SUPER",args:""};
	}
	else if (type == "sub") 
	{
	    strJson = {action:"SUB",args:""};	      //设置下标
	}
	else if (type == "justify") 
	{
		strJson = {action:"ALIGN_JUSTIFY",args:""}; //设置两端对齐
	}
	else if (type == "alignleft") 
	{
		strJson = {action:"ALIGN_LEFT",args:""};    //设置左对齐
	}
	else if (type == "aligncenter") 
	{
		strJson = {action:"ALIGN_CENTER",args:""};  //设置居中对齐
	}
	else if (type == "alignright") 
	{
		strJson = {action:"ALIGN_RIGHT",args:""};  //设置右对齐
	}
	else if (type == "indent") 
	{
		strJson = {action:"INDENT",args:""};       //设置缩进
	}
	else if (type == "unindent") 
	{
		strJson = {action:"UNINDENT",args:""};    //设置反缩进
	}
	else if (type == "cut") 
	{
		strJson = {action:"CUT",args:""};       //剪切
	}
	else if (type == "copy") 
	{
		strJson = {action:"COPY",args:""};      //复制
	}
	else if (type == "paste") 
	{
		strJson = {action:"PASTE",args:""};      //粘贴
	}
	else if (type == "undo") 
	{
		strJson = {action:"UNDO",args:""};      //撤销
	}
	else if (type == "redo") 
	{
		strJson = {action:"REDO",args:""};      //重做
	}
	else if (type == "spechars")
	{
		
		//以前的模态框
//		var returnValues = window.showModalDialog("emr.ip.tool.spechars.csp","","dialogHeight:420px;dialogWidth:490px;resizable:no;center:yes;status:no");
		//HISUI模态框
		var iframeContent = '<iframe id="specharsIframe" scrolling="auto" frameborder="0" src="emr.ip.tool.spechars.csp" style="width:100%;height:100%;display:block;"></iframe>';
		var callback = function(returnValues,arr){
			strJson={action:"INSERT_STYLE_TEXT_BLOCK",args:returnValues};
			if(strJson!="")	cmdDoExecute(strJson);
	    }
	    createModalDialog("dialogSpechars", "特殊字符", 490, 450, "specharsIframe", iframeContent,callback,"");
	}
	if(strJson!="")	cmdDoExecute(strJson);
}


///事件监听///////////////////////////////////////////////////////////////////////////////

//获得模板元素结构
function eventGetMetaDataTree(commandJson)
{
	var json = commandJson.args.items;
	var treeJson = new Array();
	convertToTreeJson(json,treeJson,"");
		$('#elementTree').tree({
			data: treeJson,
			onClick: function(node){
				focusElement(node.id);  
			},
			onContextMenu: function(e, node){
				treeRightClick(e,node);
			}			
	})
}
//元素改变事件
function eventElementChanged(commandJson)
{
	if (commandJson.args.Focus == "Get")
	{
		var node = $('#elementTree').tree('find',commandJson.args.Path);
		$('#elementTree').tree('select', node.target);
		currentPath = commandJson.args.Path;
		setProperty();
	}	
}

function eventAppendElement(commandJson)
{
	if (commandJson.args.result == "OK")  
	{
		loadStructTree();
		setProperty();
	}
}

//编辑器上下文感知功能
function eventCaretContext(commandJson)
{
	//判断当前字体
	if (typeof(commandJson.args.FONT_FAMILY) == "undefined") 
	{
		document.getElementById('font').value = "";
	}
	else
	{
		$('#font').attr("value",commandJson.args.FONT_FAMILY);
	}
	//判断当前字号
	document.getElementById('fontSize').value = ""; 
	if (typeof(commandJson.args.FONT_SIZE) == "undefined") 
	{
		document.getElementById('fontSizeText').value = "";
	}
	else
	{
		document.getElementById('fontSizeText').value = isExistOption(commandJson.args.FONT_SIZE);
	}  
}

function isExistOption(value) 
{
	var count = $('#fontSize').find('option').length; 
	for(var i=0;i<count;i++)
	{
		 if($('#fontSize').get(0).options[i].value == value) 
		 {
			 document.getElementById('fontSize').value = value;
			 value = $('#fontSize').get(0).options[i].text;
			 break;
		 }
	}
	return value;
}

//文档保存事件监听
function eventSaveDocument(commandJson)
{
	var flag = saveNodePropty();  //保存属性
	if (commandJson.args.result == "OK")
	{
		if (commandJson.args.params.result != "OK")
		{
			top.parent.parent.$.messager.alert('提示',emrTrans('保存失败'));
		}
		else
		{
			if (flag == "1")
			{
				top.parent.parent.$.messager.alert('提示',emrTrans('保存成功'));
			}
			else
			{
				top.parent.parent.$.messager.alert('提示',emrTrans('保存失败'));
			}
		}
	}
	else if (commandJson.args.result == "INVALID")
    {
	    top.parent.parent.$.messager.alert("提示", emrTrans("病历存在非法字符，不能保存"), 'info');
	     
    }
	else if (commandJson.args.result == "NONE")
	{
		if (flag == "1")
		{
			top.parent.parent.$.messager.alert('提示',emrTrans('保存成功'));
		}
		else
		{
			top.parent.parent.$.messager.alert('提示',emrTrans('保存失败'));
		}
	}
}

//修改元素监听
function eventUpdateElement(commandJson)
{
	if (commandJson.args.result == "OK")
	{
		loadStructTree();
	}
}

///属性设置/////////////////////////////////////////////////////////////////////////////

//设置单元属性
function setProperty()
{
	var strJson = {"action":"GET_ELEMENT_CONTEXT", "args":{"Type":"MIElement"}}
	var elementContext = cmdSyncExecute(strJson);
	var elementContext = eval("("+elementContext+")");
	var type = elementContext.Props.ElemType;
	currentPath = elementContext.Path;
	if (type == "MIString")
	{
		setMIString(elementContext);
	}
	else if (type == "MINumber")
	{	
		setMINumber(elementContext);
	}	
	else if (type == "MIDateTime")
	{
		setMIDateTime(elementContext);
	}	
	else if (type == "MIMonoChoice")
	{
		setMIMonoChoice(elementContext);
	}
	else if (type == "MIMultiChoice")
	{
		setMIMultiChoice(elementContext);
	}	
	else if (type == "MIDictionary")
	{
		 setMIDictionary(elementContext);
	}
}
//初始化元素基本属性
function initBasePropty()
{
	var strPropty = 
		'<div>'+initTabIndex()+initVisible()+initAllowNull()+initReadOnly()+'</div>'
		+'<div>'+initCode()+'</div>'
		+'<div>'+initDisplayName()+'</div>'
		+'<div>'+initDescription()+'</div>'
		+'<div>'+initDataBind()+initSynch()+'</div>'
		+'<div>'+initValidateMsg()+'</div>'	
		+'<div>'+initConfidentiality()+'</div>' 
		+'<div>'+initFixedStructs()+'</div>'
	return strPropty;
}
//设置元素基本属性
function setBasePropty(obj)
{
	setTabIndex(obj.Props.TabIndex);
	setVisible(obj.Props.Visible);
	setAllowNull(obj.Props.AllowNull);
	setReadOnly(obj.Props.ReadOnly);
	setCode(obj.Props.Code);
	setDisplayName(obj.Props.DisplayName);
	setDescription(obj.Props.Description);
	setDataBind(obj.Props.BindCode,obj.Props.BindType);
	setSynch(obj.Props.Synch);
	setValidateMsg(obj.Props.ValidateMsg);
	setConfidentiality(obj.Props.ConfidentialityCode);
	setFixedStructs(obj.Props.FixedStructs);	
}

function getBasePropty()
{
	var obj = {};
	obj.TabIndex = $("#TabIndex").val();
	obj.Visible = $("#Visible")[0].status;
	obj.AllowNull = $("#AllowNull")[0].status;
	//obj.ReadOnly = $("#ReadOnly")[0].status;
	obj.ReadOnly = $("#ReadOnly")[0].checked;
    obj.Code = $("#Code").val();
	obj.DisplayName = $("#DisplayName").val();	
	obj.Description = $("#Description").val();
	obj.BindCode = $("#BindCode").val();
	obj.BindType = $("#BindType").val();
	obj.Synch = $("#Synch")[0].status;
	obj.ValidateMsg = $("#ValidateMsg").val();
	obj.ConfidentialityCode = $("#ConfidentialityCode").val();
	obj.FixedStructs = $("#FixedStructs")[0].status;
    return obj;
}

//字符单元
function setMIString(obj)
{
	if (!obj || obj == "") return;
	var strPropty = initBasePropty()
	 +'<div>'+initRegExp()+'</div>' 
	 +'<div>'+initMaxLength()+'</div>'
	 +'<div>'+initSave()+'</div>'
	
	$("#property")[0].innerHTML = strPropty;
	$.parser.parse('#property');
	
	setBasePropty(obj);
	setRegExp(obj.Props.RegExp);
	setMaxLength(obj.Props.MaxLength);	
	initSaveOnclick();
}
//设置数字单元
function setMINumber(obj)
{
	if (!obj || obj == "") return;
	var strPropty = initBasePropty()
	 +'<div>'+initHasMinVal()+initMinVal()+initIncludeMax()+'</div>'
	 +'<div>'+initHasMaxVal()+initMaxVal()+initIncludeMin()+'</div>'
	 +'<div>'+initDecimalPlace()+'</div>'
	 +'<div>'+initSave()+'</div>'
	
	$("#property")[0].innerHTML = strPropty;
	$.parser.parse('#property');
	
	setBasePropty(obj);
	setHasMinVal(obj.Props.HasMinVal);
	setMinVal(obj.Props.MinVal);
	setIncludeMin(obj.Props.IncludeMin);
	setHasMaxVal(obj.Props.HasMaxVal);
	setMaxVal(obj.Props.MaxVal);
	setIncludeMax(obj.Props.IncludeMax);
	setDecimalPlace(obj.Props.DecimalPlace);
	initSaveOnclick();	
}
//单选单元
function setMIMonoChoice(obj)
{
	if (!obj || obj == "") return;
	var strPropty = initBasePropty()
	 +'<div>'+initChoices()+'</div>'
	 +'<div id="choiceCheckDiv"></div>'
	 +'<div>'+initSave()+'</div>'
	
	$("#property")[0].innerHTML = strPropty;
	$.parser.parse('#property');
	
	setBasePropty(obj);
	setChoices(obj.Props.Choices);
	//平铺额外显示备选项
	if (obj.Props.ShowType == "CheckBox")
	{
		setCheckBoxChoices(obj,"1");
	}
	
	initSaveOnclick();
}

//插入平铺选项：单元Code，选项描述，选项code，单选1|多选2
function inSertChoice(groupCode,name,code,type)
{
	var strJson = {action:"INSERT_CHOICE_FIELD",args:{"ChoiceType":type,"Value":"0","Context":name,"Code":code,"Groupid":groupCode}}
		cmdDoExecute(strJson);
}

function setCheckBoxChoices(obj,type)
{
	var html = "<table>";
	html += "<tr><td>备选项(双击选项带入到编辑器中)：</td></tr>"
	for (var i =0;i < obj.Props.Choices.length; i++){
		html += '<tr><td style="color:black" ondblclick="inSertChoice(\''+obj.Props.Code+'\',\''+obj.Props.Choices[i].DisplayName+'\',\''+obj.Props.Choices[i].Code+'\',\''+type+'\')">'+ obj.Props.Choices[i].DisplayName+'</td></tr>';
	}
	html += "</table>";
	$("#choiceCheckDiv").append(html);
}

//多选单元
function setMIMultiChoice(obj)
{
	if (!obj || obj == "") return;
	var strPropty = initBasePropty() 
	 +'<div>'+initSeparator()+initWrapChoice()+'</div>'
	 +'<div>'+initChoices()+'</div>'
	 +'<div id="choiceCheckDiv"></div>'
	 +'<div>'+initSave()+'</div>'
	
	$("#property")[0].innerHTML = strPropty;
	$.parser.parse('#property');
	
	setBasePropty(obj);
	setSeparator(obj.Props.Separator);
	setWrapChoice(obj.Props.WrapChoice);
	setChoices(obj.Props.Choices);
	//平铺额外显示备选项
	if (obj.Props.ShowType == "CheckBox")
	{
		setCheckBoxChoices(obj,"2");
	}
	initSaveOnclick();
}

//日期单元
function setMIDateTime(obj)
{
	if (!obj || obj == "") return;
	var strPropty = initBasePropty() 
	 +'<div>'+initIncludeDate()+initDateFormat()+'</div>'
	 +'<div>'+initIncludeTime()+initTimeFormat()+'</div>'
	 +'<div>'+initSave()+'</div>'
	
	$("#property")[0].innerHTML = strPropty;
	$.parser.parse('#property');

	setBasePropty(obj);
	setIncludeDate(obj.Props.IncludeDate);
	setIncludeTime(obj.Props.IncludeTime);
	setDateFormat(obj.Props.DateFormat);
	setTimeFormat(obj.Props.TimeFormat);
	initSaveOnclick();
}

//字典单元
function setMIDictionary(obj)
{
	if (!obj || obj == "") return;
	var strPropty = initBasePropty()
	 +'<div>'+initDictionaryType()+'</div>'
	 +'<div>'+initCodeSystem()+'</div>'
	 +'<div>'+initCustDicClassName()+'</div>'
	 +'<div>'+initDisplayType()+initSeparator()+'</div>'
	 +'<div>'+initLinkCode()+initLinkMethod()+'</div>'
	 +'<div>'+initLinkDisplayType()+'</div>'
	 +'<div>'+initAllowCodeNull()+'</div>'
	 +'<div>'+initAllowValueNull()+'</div>'
	 +'<div>'+initAssociateItem()+'</div>'
	 +'<div>'+initRegExp()+'</div>'
	 +'<div>'+initMaxLength()+'</div>'
	 +'<div>'+initSave()+'</div>'
	
	$("#property")[0].innerHTML = strPropty;
	$.parser.parse('#property');

	setBasePropty(obj);
	setDictionaryType(obj.Props.DictionaryType);
	getCodeSystemData(obj.Props.CodeSystem);
	setCustDicClassName(obj.Props.CustDicClassName);
	setDisplayType(obj.Props.DisplayType);
	setSeparator(obj.Props.Separator);
	setLinkCode(obj.Props.LinkCode);
	setLinkMethod(obj.Props.LinkMethod);
	setLinkDisplayType(obj.Props.LinkDisplayType);
	setAllowCodeNull(obj.Props.AllowCodeNull);
	setAllowValueNull(obj.Props.AllowValueNull);
	setAssociateItem(obj.Props.AssociateItem);
	setRegExp(obj.Props.RegExp);
	setMaxLength(obj.Props.MaxLength);
	initSaveOnclick();
}
//字符元素obj
function getMIString()
{
	var obj = getBasePropty();
	obj.ElemType = "MIString";
	obj.RegExp = $("#RegExp").val();
	obj.MaxLength = $("#MaxLength").val();
	return obj;
}
//数字元素obj
function getMINumber()
{
	var obj =  getBasePropty();
	obj.ElemType = "MINumber";
	obj.HasMinVal = $("#HasMinVal").is(':checked');
	obj.MinVal = $("#MinVal").val();
	obj.IncludeMin = $("#IncludeMin").is(':checked');
	obj.HasMaxVal = $("#HasMaxVal").is(':checked');
	obj.MaxVal = $("#MaxVal").val();
	obj.IncludeMax = $("#IncludeMax").is(':checked');
	obj.DecimalPlace = $("#DecimalPlace").val();
	return obj;
}
//单选单元
function getMIMonoChoice()
{
	var obj =  getBasePropty();
	obj.ElemType = "MIMonoChoice";
	var list = $("#Choices").val().split("\n");
	var Choices = new Array();
	for (i=0;i<list.length;i++)
	{
		if (list[i] != "")
		{
			Choices.push({"Code":list[i].split("|")[1],"DisplayName":list[i].split("|")[0]});
		}
	}
	obj.Choices = Choices;
	return obj;
}
//多选单元
function getMIMultiChoice()
{
	var obj =  getBasePropty();
	obj.ElemType = "MIMultiChoice";
	obj.Separator = $("#Separator").val();
	obj.WrapChoice = $("#WrapChoice")[0].status;
	var list = $("#Choices").val().split("\n");
	var Choices = new Array();
	for (i=0;i<list.length;i++)
	{
		Choices.push({"Code":list[i].split("|")[1],"DisplayName":list[i].split("|")[0]});
	}
	obj.Choices = Choices;
	return obj;
}
//日期单元
function getMIDateTime()
{
	var obj =  getBasePropty();
	obj.ElemType = "MIDateTime";
	obj.IncludeDate = $("#IncludeDate")[0].checked;
	obj.IncludeTime = $("#IncludeTime")[0].checked;
	obj.DateFormat = $("#DateFormat").find("option:selected").text();
	obj.TimeFormat = $("#TimeFormat").find("option:selected").text();
	return obj;
}
//字典单元
function getMIDictionary()
{
	var obj =  getBasePropty();
	obj.ElemType = "MIDictionary";
	obj.DictionaryType = $("#DictionaryType").val();
	obj.CodeSystem = $("#CodeSystem").val();
	obj.CodeSystemName = $("#CodeSystem").text();
	obj.CustDicClassName = $("#CustDicClassName").val();
	obj.DisplayType = $("#DisplayType").val();
	obj.Separator = $("#Separator").val();
	obj.LinkCode = $("#LinkCode").val();
	obj.LinkMethod = $("#LinkMethod").val();
	obj.LinkDisplayType = $("#LinkDisplayType").val();
	obj.AllowCodeNull = $("#AllowCodeNull")[0].status;
	obj.AllowValueNull = $("#AssociateItem").val();
	obj.RegExp = $("#RegExp").val();
	obj.MaxLength = $("#MaxLength").val();
	return obj;
}
//取元素属性
function getElementPropty(type)
{
	var obj = "";
	if (type == "L")
	{
		obj = getMIString();
	}
	else if (type == "N")
	{
		obj = getMINumber();
	}	
	else if (type == "D")
	{
		obj = getMIDateTime();
	}		
	else if (type == "O")
	{
		obj = getMIMonoChoice();
	}
	else if (type == "M")
	{
		obj = getMIMultiChoice();
	}
	else if (type == "I")
	{
		obj = getMIDictionary();
	}
	return obj;
}


//简单元素编码
function initCode()
{
	var str = '<span>'+emrTrans("元素编码")+'</span>'
			 +'<span><input id="Code" type="text" disabled="true" style="width:200px;"></input></span>'
	return str;
}
//简单元素描述
function initDisplayName()
{
	var str ='<span>'+emrTrans("元素描述")+'</span>'
	 	 +'<span><textarea id="DisplayName" rows="2" cols="20" style="width:200px;"></textarea></span>'
	return str;	
}
//简单元素含义描述
function initDescription()
{
	var str ='<span>'+emrTrans("含义描述")+'</span>'
	 	 +'<span><textarea id="Description" rows="2" cols="20" style="width:200px;"></textarea></span>'
	return str;	
}
//数据绑定
function initDataBind()
{
	var str ='<span>'+emrTrans("数据绑定")+'</span>'
	 	 +'<span><input id="BindCode" type="text" disabled="true" style="width:140px;"></input></span>'
	 	 +'<span><input id="BindType" type="text" style="display:none;"></input></span>'
	 	 +'<span><input id="clearBind"  onclick="clearBind()" type="button" value="-"></input></span>'
	return str;
}

//清空选择的单元的绑定数据
function clearBind()
{
	$("#BindCode").val("");
}
//同步
function initSynch()
{
	var str ='<span><input id="Synch" type="checkbox" name="Synch">'+emrTrans("同步")+'</input></span>'
	return str;
}
//不为空
function initAllowNull()
{
	var str = '<span><input id="AllowNull" type="checkbox" name="AllowNull">'+emrTrans("非必填项")+'</input></span>'
	return str;
}
//校验消息
function initValidateMsg()
{
	var str ='<span>'+emrTrans("校验消息")+'</span>'
	 	 +'<span><input id="ValidateMsg" type="text" style="width:200px;"></input></span>'
	return str;
}
//正则表达式
function initRegExp()
{
	var str ='<span>'+emrTrans("正则表达式")+'</span>'
	 	 +'<span><input id="RegExp" type="text" style="width:190px;"></input></span>'
	return str; 	 
}
//顺序号
function initTabIndex()
{
	var str = '<span>TabIndex</span>'
		     +'<span><input id="TabIndex" type="text" style="width:30px;"></input></span>'	
    return str;
}
//不可见
function initVisible()
{
	var str = '<span style="display:none;"><input id="Visible" type="checkbox" name="Visible">'+emrTrans("不可见")+'</input></span>'
	return str;	
}
//只读
function initReadOnly()
{
	var str = '<span><input id="ReadOnly" type="checkbox" name="ReadOnly">'+emrTrans("只读")+'</input></span>'
	return str;
}
//机密级别
function initConfidentiality()
{
	var str ='<span>'+emrTrans("保密级别")+'</span>'
	 	 +'<span><select id="ConfidentialityCode" name="ConfidentialityCode" style="width:200px;"></select></span>'
	return str; 	 
}
//固定结构
function initFixedStructs()
{
	var str = '<span><input id="FixedStructs" type="checkbox" name="FixedStructs">'+emrTrans("固定结构")+'</input></span>'
	return str;
}
//最大长度(MIString)
function initMaxLength()
{
	var str ='<span>'+emrTrans("最大长度")+'</span>'
	 	 +'<span><input id="MaxLength" type="text" style="width:200px;"></input></span>'
	return str; 	 
}
//最小值
function initMinVal()
{
	var str ='<span>'+emrTrans("最小值")+'</span>'
	 	 +'<span><input id="MinVal" type="text" style="width:30px;"></input></span>'
	return str; 
}
//最大值
function initMaxVal()
{
	var str ='<span>'+emrTrans("最大值")+'</span>'
	 	 +'<span><input id="MaxVal" type="text" style="width:30px;"></input></span>'
	return str; 
	
}
//设置最小值
function initHasMinVal()
{
	var str = '<span><input id="HasMinVal" onclick="checkHasMinVal()" type="checkbox" name="HasMinVal"></input></span>'
	return str;
}
//设置最大值
function initHasMaxVal()
{
	var str = '<span><input id="HasMaxVal" onclick="checkHasMaxVal()" type="checkbox" name="HasMaxVal"></input></span>'
	return str;	
}
//是否是小于等于
function initIncludeMin()
{
	var str = '<span><input id="IncludeMin" type="checkbox" name="IncludeMin">'+emrTrans("是否小于等于")+'</input></span>'
	return str;	
}
//是否是大于等于
function initIncludeMax()
{
	var str = '<span><input id="IncludeMax" type="checkbox" name="IncludeMax">'+emrTrans("是否大于等于")+'</input></span>'
	return str;	
}
//小数点位数
function initDecimalPlace()
{
	var str ='<span>'+emrTrans("小数位数")+'</span>'
	 	 +'<span><input id="DecimalPlace" type="text" style="width:50px;"></input></span>'
	return str; 
}
//备选项集合
function initChoices()
{
	var str ='<span>'+emrTrans("在集合中输入备选项(每行一个 值|ID)")+'</span>'
	 	 +'<span><textarea id="Choices" rows="6" cols="60" style="width:250px;"></textarea></span>'
	return str;		
}
//分隔符
function initSeparator()
{
	var str ='<span>'+emrTrans("分隔符)")+'</span>'
	 	 +'<span><input id="Separator" type="text" style="width:50px;"></input></span>'
	return str; 	
}
//备选项强制换行
function initWrapChoice()
{
	var str = '<span><input id="WrapChoice" type="checkbox" name="WrapChoice">'+emrTrans("强制换行)")+'</input></span>'
	return str;	
}

//包含日期
function initIncludeDate()
{
	var str = '<span><input id="IncludeDate" type="checkbox" name="IncludeDate">'+emrTrans("日期)")+'</input></span>'
	return str;		
}

//包含时间
function initIncludeTime()
{
	var str = '<span><input id="IncludeTime" type="checkbox" name="IncludeTime">'+emrTrans("时间)")+'</input></span>'
	return str;		
}
//日期格式
function initDateFormat()
{
	var str ='<span style="padding-left:5px">'+emrTrans("日期格式")+'</span>'
	 	 +'<span><select id="DateFormat" name="DateFormat" style="width:150px;"></select></span>'
	return str; 
}
//时间格式
function initTimeFormat()
{
	var str ='<span style="padding-left:5px">'+emrTrans("时间格式")+'</span>'
	 	 +'<span"><select id="TimeFormat" name="TimeFormat" style="width:150px;"></select></span>'
	return str; 
}
//字典类型
function initDictionaryType()
{
	var str ='<span>'+emrTrans("字典类型")+'</span>'
	 	 +'<span><select id="DictionaryType" name="DictionaryType" style="width:200px;"></select></span>'
	return str; 		
}
//标准字典名称
function initCodeSystem()
{
	var str ='<span>'+emrTrans("标准字典")+'</span>'
	 	 +'<span><select id="CodeSystem" name="CodeSystem" style="width:200px;"></select></span>'
	return str; 		
}
//自定义字典名称
function initCustDicClassName()
{
	var str ='<span>'+emrTrans("自定义字典")+'</span>'
	 	 +'<span><input id="CustDicClassName" type="text" style="width:190px;"></input></span>'
	return str; 		
}
//字典显示类型
function initDisplayType()
{
	var str ='<span>'+emrTrans("显示类型")+'</span>'
	 	 +'<span><select id="DisplayType" name="DisplayType" style="width:115px;"></select></span>'
	return str; 		
}
//关联的结构化单元
function initLinkCode()
{
	var str ='<span>'+emrTrans("关联Code")+'</span>'
	 	 +'<span><input id="LinkCode" type="text" style="width:80px;"></input></span>'
	return str; 	
}
//链接方式：Append/Replace/Prefix
function initLinkMethod()
{
	var str ='<span>'+emrTrans("链接方式")+'</span>'
	 	 +'<span><select id="LinkMethod" name="DisplayType" style="width:70px;"></select></span>'
	return str; 	
}
//允许使用非标准字典代码
function initAllowCodeNull()
{
	var str = '<span><input id="AllowCodeNull" type="checkbox" name="IncludeDate">'+emrTrans("允许使用非标准字典代码")+'</input></span>'
	return str;		
}
//允许使用非标准字典描述
function initAllowValueNull()
{
	var str = '<span><input id="IncludeDate" type="checkbox" name="IncludeDate">'+emrTrans("允许使用非标准字典描述")+'</input></span>'
	return str;		
}
//查询条件单元
function initAssociateItem()
{
	var str ='<span>'+emrTrans("查询条件单元")+'</span>'
	 	 +'<span><input id="AssociateItem" type="text" style="width:180px;"></input></span>'
	return str; 		
}
//关联元素显示类型
function initLinkDisplayType()
{
	var str ='<span>'+emrTrans("关联元素显示类型")+'</span>'
	 	 +'<span><select id="LinkDisplayType" name="LinkDisplayType" style="width:115px;"></select></span>'
	return str; 	
}

//保存
function initSave()
{
	var str ='<a href="#" id="propertySave" class="hisui-linkbutton hover-dark" style="float:right">'+emrTrans("保存")+'</a>'
	return str; 	
}


//简单元素编码
function setCode(value)
{
	$("#Code").val(value);
}
//简单元素描述
function setDisplayName(value)
{
	$("#DisplayName").val(value);
}
//简单元素含义描述
function setDescription(value)
{
	$("#Description").val(value);
}
//数据绑定
function setDataBind(codeValue,typeValue)
{
	$("#BindCode").val(codeValue);
	$("#BindType").val(typeValue);
}
//同步
function setSynch(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#Synch").attr("checked",true);	
	}else
	{
		$("#Synch").attr("checked",false);	
	}
}
//不为空
function setAllowNull(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#AllowNull").attr("checked",true);	
	}else
	{
		$("#AllowNull").attr("checked",false);	
	}
}
//校验消息
function setValidateMsg(value)
{
	$("#ValidateMsg").val(value)
}
//正则表达式
function setRegExp(value)
{
	$("#RegExp").val(value);	 
}
//顺序号
function setTabIndex(value)
{
	$("#TabIndex").val(value)
}
//不可见
function setVisible(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#Visible").attr("checked",true);	
	}else
	{
		$("#Visible").attr("checked",false);	
	}
}
//只读
function setReadOnly(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#ReadOnly").attr("checked",true);	
	}else
	{
		$("#ReadOnly").attr("checked",false);	
	}
}
//保密级别
function setConfidentiality(value)
{
	var json = [{value:"N",name:emrTrans("正常")},{value:"R",name:emrTrans("严格")},{value:"V",name:emrTrans("非常严格")}]
	for (var i=0;i<json.length;i++)  
	{       
    	$('#ConfidentialityCode').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		if (json[i].value == value){$("#ConfidentialityCode").val(value);}
	}	
}
//固定结构
function setFixedStructs(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#FixedStructs").attr("checked",true);	
	}else
	{
		$("#FixedStructs").attr("checked",false);	
	}
}
//最大长度 (MIString)
function setMaxLength(value)
{
	$("#MaxLength").val(value);	 
}
//最小值
function setMinVal(value)
{
	$("#MinVal").val(value);
}
//最大值
function setMaxVal(value)
{
	$("#MaxVal").val(value);	
}
//设置最小值
function setHasMinVal(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#HasMinVal").attr("checked",true);	
	}
	else
	{
		$("#HasMinVal").attr("checked",false);	
		$("#MinVal").attr("disabled",true);
		$("#IncludeMin").attr("disabled",true);	
	}
}
//设置最大值
function setHasMaxVal(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#HasMaxVal").attr("checked",true);	
	}
	else
	{
		$("#HasMaxVal").attr("checked",false);
		$("#MaxVal").attr("disabled",true);
		$("#IncludeMax").attr("disabled",true);	
	}
}
//是否是小于等于
function setIncludeMin(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#IncludeMin").attr("checked",true);	
	}
	else
	{
		$("#IncludeMin").attr("checked",false);	
	}
}
//是否是大于等于
function setIncludeMax(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#IncludeMax").attr("checked",true);	
	}
	else
	{
		$("#IncludeMax").attr("checked",false);	
	}
}
//小数点位数
function setDecimalPlace(value)
{
	$("#DecimalPlace").val(value);
}
//备选项
function setChoices(value)
{
	var text = "";
	for(var i=0;i<value.length;i++)
	{
		text = text + value[i].DisplayName+"|"+value[i].Code +"\n";
	}
	$("#Choices").val(text);
}
//分隔符
function setSeparator(value)
{
	$("#Separator").val(value);	
}

//备选项强制换行
function setWrapChoice(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#WrapChoice").attr("checked",true);	
	}
	else
	{
		$("#WrapChoice").attr("checked",false);	
	}
}

//包含日期
function setIncludeDate(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#IncludeDate").attr("checked",true);	
	}
	else
	{
		$("#IncludeDate").attr("checked",false);
		$("#DateFormat").attr("disabled",true);
	}
}
//包含日期
function setIncludeTime(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#IncludeTime").attr("checked",true);	
	}
	else
	{
		$("#IncludeTime").attr("checked",false);
		$("#TimeFormat").attr("disabled",true);
	}
}
//日期格式
function setDateFormat(value)
{
	var json = [{value:"1",name:"yyyy-MM-dd"},{value:"2",name:emrTrans("yyyy年MM月dd日")}]
	for (var i=0;i<json.length;i++)  
	{       
		if (json[i].name == value)
		{
			if ($.browser.version == '6.0')
			{
				setTimeout(function() { 
					$("#DateFormat").append("<option value='" + json[i].value + "' selected>" + json[i].name + "</option>");
				}, 1);
			}
			else
			{
				$("#DateFormat").append("<option value='" + json[i].value + "' selected>" + json[i].name + "</option>");
			}
		}else {
			$('#DateFormat').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		}
	}	
}
//时间显示格式
function setTimeFormat(value)
{
	var json = [{value:"1",name:"HH:mm"},{value:"2",name:"HH:mm:ss"}]
	for (var i=0;i<json.length;i++)  
	{       
		if (json[i].name == value)
		{
			if ($.browser.version == '6.0')
			{
				setTimeout(function() {
					$('#TimeFormat').append("<option value='" + json[i].value + "' selected>" + json[i].name + "</option>");
				}, 1);
			}
			else
			{
				$('#TimeFormat').append("<option value='" + json[i].value + "' selected>" + json[i].name + "</option>");
			}
		}else{
			$('#TimeFormat').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		}
	}	
}

//字典类型
function setDictionaryType(value)
{
	var json = [{value:"STDDIC",name:emrTrans("标准字典")},{value:"CUSTDIC",name:emrTrans("自定义字典")}]
	for (var i=0;i<json.length;i++)  
	{       
    	$('#DictionaryType').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		if (json[i].value == value){$("#DictionaryType").val(value);}
	}	
}
//字典代码
function setCodeSystem(value,data)
{
	for (var i=0;i<data.length;i++)  
	{       
    	$('#CodeSystem').append("<option value='" + data[i].Code + "'>" + data[i].Name + "</option>");
		if (data[i].Code == value){$("#CodeSystem").val(value);}
	}
}
//自定义字典名
function setCustDicClassName(value)
{
	$("#CustDicClassName").val(value);
}
//显示类型
function setDisplayType(value)
{
	var json = [{value:"Desc",name:emrTrans("描述")},{value:"Code",name:emrTrans("代码")}]
	for (var i=0;i<json.length;i++)  
	{       
    	$('#DisplayType').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		if (json[i].value == value){$("#DisplayType").val(value);}
	}	
}
//关联的结构化单元
function setLinkCode(value)
{
	$("#LinkCode").val(value);
}
//链接方式
function setLinkMethod(value)
{
	var json = [{value:"Append",name:emrTrans("追加")},{value:"Replace",name:emrTrans("替换")},{value:"Prefix",name:emrTrans("前加")}]
	for (var i=0;i<json.length;i++)  
	{       
    	$('#LinkMethod').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		if (json[i].value == value){$("#LinkMethod").val(value);}
	}		
}
//允许使用非标准字典代码 
function setAllowCodeNull(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#AllowCodeNull").attr("checked",true);	
	}else
	{
		$("#AllowCodeNull").attr("checked",false);	
	}
}

//允许使用非标准字典描述
function setAllowValueNull(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#AllowValueNull").attr("checked",true);	
	}else
	{
		$("#AllowValueNull").attr("checked",false);	
	}
}
//查询条件单元
function setAssociateItem(value)
{
	$("#AssociateItem").val(value);
}

//关联元素显示类型
function setLinkDisplayType(value)
{
	var json = [{value:"Desc",name:emrTrans("描述")},{value:"Code",name:emrTrans("代码")}]
	for (var i=0;i<json.length;i++)  
	{       
    	$('#LinkDisplayType').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		if (json[i].value == value){$("#LinkDisplayType").val(value);}
	}	
}
//最小值是否有效 
function checkHasMinVal(){
		var flag = true;
		if (document.getElementById('HasMinVal').checked) flag = false;	
		$("#MinVal").attr("disabled",flag);
		$("#IncludeMax").attr("disabled",flag);	
	}
//最大值是否有效 
function checkHasMaxVal(){
		var flag = true;
		if (document.getElementById('HasMaxVal').checked) flag = false;	
		$("#MaxVal").attr("disabled",flag);
		$("#IncludeMin").attr("disabled",flag);	
	}
$(function(){
	//最小值是不否有效
	//$("#HasMinVal").on("change",function(){
	//	var flag = true;
	//	if ($("#HasMinVal").attr("checked")) flag = false;	
	//	$("#MinVal").attr("disabled",flag);
	//	$("#IncludeMax").attr("disabled",flag);	
	//});
	//最大值是不否有效
	//$("#HasMaxVal").on("change",function(){
	//	var flag = true;
	//	if ($("#HasMaxVal").attr("checked")) flag = false;	
	//	$("#MaxVal").attr("disabled",flag);
	//	$("#IncludeMin").attr("disabled",flag);	
	//});
	//是否包含日期
	$("#IncludeDate").on("change",function(){
		var flag = true;
		if ($("#IncludeDate").attr("checked")) flag = false;	
		$("#DateFormat").attr("disabled",flag);
	});
	
	//是否包含时间
	$("#IncludeTime").on("change",function(){
		var flag = true;
		if ($("#IncludeTime").attr("checked")) flag = false;	
		$("#TimeFormat").attr("disabled",flag);
	});	
	
	$("#DictionaryType").on("change",function(){
		 var selValue = $(this).children('option:selected').val();
		 if (selValue == "STDDIC")
		 {
			 $("#CustDicClassName").attr("disabled",true);
			 $("#CodeSystem").attr("disabled",false);
		 }
		 else if(selValue == "CUSTDIC")
		 {
			 $("#CodeSystem").attr("disabled",true);
			 $("#CustDicClassName").attr("disabled",false);
		 }
	});
	document.getElementById("deleteElement").onclick = function(){ 
		var node = $('#elementTree').tree('getSelected');
		$('#elementTree').tree('remove', node.target);
		deleteElement(node.id);
	}
});
///后台交互///////////////////////////////////////////////////////////////

//取标准字典数据
function getCodeSystemData(value)
{
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.dictionary.cls",
		async: true,
		data: {"Action":"getStdDic"},
		success: function(obj) {
			result = eval(obj);
			setCodeSystem(value,result);
		},
		error: function(d) {alert("error");}
	});
}

//保存知识库属性
function saveNodePropty()
{
	var result = -1;
	var Description = escape($("#nodeDesc").val());
	var Name = escape($("#nodeText").val());
	var IsCommon = "Y";
	var IsInUse = "Y";
	if (!$("#chkCommon")[0].status) IsCommon = "N";
	if (!$("#nodeStatus").val() == "停用") IsInUse = "N";
	
	var TextData = "";
	//获取知识库文本内容 add by Lina 2016-11-07
	var strJson = {"action":"GET_ELEMENT_TEXT","args":{"Path":"","Type":"Composite","RemoveHintText":"False"}};
	var value = cmdSyncExecute(strJson);
	value = value.replace(/(^\s*)|(\s*$)/g, "");
	var text = value.substring(value.indexOf("Value")+8,value.indexOf("result")-3);
	var returnvalue = eval("("+value+")");
	if (returnvalue.result == "True") TextData = text;
	
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.kbTree.cls",
		async: false,
		data: {"ACTION":"UpdateKBNode","ID":node.id,"Description":Description,"Name":Name,"IsCommon":IsCommon,"IsInUse":IsInUse,"TextData":TextData},
		success: function(d) {
            if(d == "1")
            {
	            var nodeText = $("#nodeText").val();
	            returnValues.NodeText = nodeText;
	            returnValues.TextData = TextData;
	            returnValues.isEmpty = "N";
	            window.returnValue = returnValues;
	            result = 1;
				node.attributes.isEmpty = "N";
	        }
		},
		error: function(d) {alert("error");}
	});	
	return result;
}
//加载HIS绑定字段
function getDataBaseCatalog()
{
	$('#dataBaseCategory').datagrid({  
		height: '200px',
	    url:'../EMRservice.Ajax.databind.cls',  
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    fitColumns: true,
	    singleSelect:true,
	    singleSelect:true,
	    idField:'ID',
	    fit:true,
	    columns:[[  
	        {field:'ID',title:'ID',width:100,hidden:true},  
	        {field:'Name',title:'选择系统表',width:100},  
	        {field:'ClassName',title:'ClassName',width:100,hidden:true},
	        {field:'QueryName',title:'QueryName',width:100,hidden:true}, 
	        {field:'Description',title:'Description',width:100,hidden:true}, 
	        {field:'SingleResult',title:'SingleResult',width:100,hidden:true}
	    ]],
	    onSelect: function(rowIndex,rowData){
			var id = rowData.ID;
			getDataBaseDetial(id);
		},
		queryParams: {
			ACTION: 'DataBaseCatalog'		
		}
	});
}

function getDataBaseDetial(id)
{
	$('#dataBaseDeital').datagrid({  
	    url:'../EMRservice.Ajax.databind.cls',  
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    fitColumns: true,
	    singleSelect:true,
	    singleSelect:true,
	    idField:'ID',
	    fit:true,
	    columns:[[  
	        {field:'ID',title:'ID',width:100,hidden:true},  
	        {field:'Name',title:'选择字段',width:100},  
	        {field:'FieldName',title:'FieldName',width:100,hidden:true}, 
	        {field:'FieldType',title:'FieldType',width:100,hidden:true}, 
	        {field:'Description',title:'Description',width:100,hidden:true},
	        {field:'DicID',title:'DicID',width:100,hidden:true}

	    ]],
		queryParams: {
			ACTION: 'dataBaseDeital',
			pId: id		
		} 
	});	
}

///加载绑定病历数据目录
function getDataEMRCatalog()
{
	$('#dataEMRCategory').tree({
		url:'../EMRservice.Ajax.databind.cls?ACTION=DataEMRCategory',
		method:'get',
		animate:true,
		lines:true,
		autoRowHeight: true,
		onSelect: function(node){
			$('#dataEMRDeital').tree('reload');
			$('#valueType').combobox('clear');
			var type = node.attributes.type;
			var text = node.text;
			var id = node.id;
			//选中病历模板则获取模板xml
			if(type == "Template")
			{
				getXml(id);
			}
		}
		//折叠全部
		//onLoadSuccess:function(node, data) {$('#dataEMRCategory').tree('collapseAll');},
		//onLoadError: function(){ alert("EMRCatalogonLoadError");}
	});	
}


/// 停用知识库
$("#nodeStatus").on("click",function(){
	
	var IsInUse = ($("#nodeStatus").val() == "停用")?"N":"Y";
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.kbTree.cls",
		async: false,
		data: {"ACTION":"StopOrStartKBNode","KBTreeID":node.id,"IsInUse":IsInUse},
		success: function(d) {
			var btText = (IsInUse == "N")?"启用":"停用";	
			$("#nodeStatus").text(emrTrans(btText));	
			returnValues.NodeStatus = IsInUse;
			window.returnValue = returnValues;
		},
		error: function(d) {alert("error");}
	});		
});

//保存元素属性
function initSaveOnclick()
{
	document.getElementById("propertySave").onclick = function(){
		var type = $("#Code").val().substring(0,1);
		//保存xml
		var strJson = {action:"UPDATE_ELEMENT",args:{"Path":currentPath,"Props":getElementPropty(type)}}
		cmdDoExecute(strJson);
	};
}

//右键菜单
function treeRightClick(e,node)
{
	if ((node.attributes.type == "Section")||(node.attributes.type == "Composite")) return;
	e.preventDefault();
	$('#elementTree').tree('select', node.target);
	focusElement(node.id);
	$('#mm').menu('show', {left: e.pageX-80, top: e.pageY});
}

//删除元素
function deleteElement(path)
{
	var strJson = { action: "DELETE_ELEMENT", args: {"Path":path}};
	cmdDoExecute(strJson);
}