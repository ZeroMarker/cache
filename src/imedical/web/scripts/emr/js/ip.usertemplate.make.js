///处理id
function checkNewId(id)
{
	return id.split('^')[1];

}
//新建科室模板
function AddUserTemplate()
{
	if ((model.node.attributes.nodetype == "basisTemplate")||(model.node.attributes.nodetype == "leaf"))
	{
		var userTemplateName = $('#templateName').val();
		if (userTemplateName == "")
		{
			top.$.messager.alert('提示','科室模板名称不能为空','info');
			return;
		}
		var id = checkNewId(model.node.id);
		var templateID = model.node.attributes.TemplateID;
		var VersionNumber = model.node.attributes.TemplateVersionId;
		var IP = getIpAddress();
		var userTempInfo = id+"^"+userTemplateName+"^"+templateID+"^"+userId+"^"+"0"+"^"+VersionNumber+"^"+userId+"^"+IP;
		var titleInfo = $("#selectTitle").combobox("getText");
		jQuery.ajax({
			type: "post",
			dataType: "text",
			url: "../EMRservice.Ajax.common.cls",
			async: false,
			data: {
				"OutputType":"String",
				"Class":"EMRservice.BL.BLIEUserTemplate",
				"Method":"AddUserTemplate",
				"p1":userTempInfo,
				"p2":userLocId,
				"p3":titleInfo
			},
			success: function(d){
				if(d !== "")
				{
					tempUserTemplateID = d;
					saveSectionFlag = "1";	//可以保存章节
					var strJson = {
						"action" : "SAVE_DOCUMENT",
						"args" : {
							"params" : {
								"action" : "SAVE_USER_TEMPLATE",
								"UserTemplateId" : d,
								"Author":userId
							}
						}
					};
				    cmdDoExecute(strJson);
				    loadStructTree();
				}
			},
			error: function(d) {alert("AddUserTemplate error");}
		});
	}
	$('#addUserTemplateDialog').dialog('close');
	if(document.getElementById("divPlugin"))
    	document.getElementById("divPlugin").style.visibility="visible"; //显示插件
}

//保存科室模板
function modifyUserTemplate(asynType)
{
	if ((model.node.attributes.nodetype == "basisTemplate")||(model.node.attributes.nodetype == "leaf"))
	{
		var id = checkNewId(model.node.id);
		var IP = getIpAddress();
		var userTempInfo = id+"^"+userId+"^"+IP;
		var titleInfo = $("#selectTitle").combobox("getText");
		jQuery.ajax({
			type: "post",
			dataType: "text",
			url: "../EMRservice.Ajax.common.cls",
			async: false,
			data: {
				"OutputType":"String",
				"Class":"EMRservice.BL.BLIEUserTemplate",
				"Method":"ModifyUserTemplate",
				"p1":userTempInfo,
				"p2":userLocId,
				"p3":titleInfo
			},
			success: function(d){
				if(d == "1")
				{
					tempUserTemplateID = id;
					saveSectionFlag = "1";	//可以保存章节
					var strJson = {
						"action" : "SAVE_DOCUMENT",
						"args" : {
							"params" : {
								"action" : "SAVE_USER_TEMPLATE",
								"UserTemplateId" : id,
								"Author":userId
							}
						}
					};
					if (asynType == "async") 
					{	//同步
						cmdSyncExecute(strJson);
					}else{
					    cmdDoExecute(strJson);
					}
				    loadStructTree();
				}
			},
			error: function(d) {alert("modifyUserTemplate error");}
		});
	}
	$('#addUserTemplateDialog').dialog('close');
	if(document.getElementById("divPlugin"))
    	document.getElementById("divPlugin").style.visibility="visible"; //显示插件
}

//获取title
function getAllTitles(templateID)
{
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLIEUserTemplate",
			"Method":"GetAllTitlesByTempID",
			"p1":templateID
		},
		success: function(d){
			if(d !== "")
			{
				data = eval("("+d+")");
				$("#selectTitle").combobox({
					valueField:"RowID",
					textField:"TitleName",
					data:data,
					filter: function (q, row) {
			            var opts = $(this).combobox('options');
			            return (row["TitleName"].toLowerCase().indexOf(q.toLowerCase()) >= 0)||(row[opts.textField].toLowerCase().indexOf(q.toLowerCase()) >= 0);
			        },
			        onLoadSuccess:function(d){
				        
					}
				});
				if (d == "[]") $("#selectTitle").combobox('disable');
				else $("#selectTitle").combobox('enable');
			}
		},
		error: function(d) {alert("getAllTitles error");}
	})
}

//申请审核
function commitRequest()
{
	if (getModifyStatus().Modified == "True")
	{
		var text = '文档正在编辑，请保存后申请审核，是否保存？';
		top.$.messager.confirm("操作提示", text, function (data) { 
			if(data) {
				modifyUserTemplate("async");
				commitRequestContent();
			}
		})
	}
	else
	{
		commitRequestContent();
	}
}
//申请审核
function commitRequestContent()
{
	if (model.node.attributes.nodetype !== "leaf")
	{
		top.$.messager.alert('提示','不能审核','info');
		return;
	}
	var tmpStatus = "";
	if (model.node.attributes.Status == "0")
	{
		tmpStatus = "2";
	}
	else if(model.node.attributes.Status == "4")
	{
		tmpStatus = "3";
	}
	else
	{
		top.$.messager.alert('提示','不能审核','info');
		return;
	}
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"string",
			"Class":"EMRservice.BL.BLIEUserTemplate",
			"Method":"ModifyUserTempStatus",
			"p1":checkNewId(model.node.id),
			"p2":tmpStatus,
			"p3":"",
			"p4":"",
			"p5":"",
			"p6":getIpAddress()
		},
		success: function(d){
			if (typeof(initEmrTree) == "function") initEmrTree();
			$("#btnCommit").linkbutton('disable');
			$("#btnSave").linkbutton('disable');
		},
		error: function(d) {alert("getAllTitles error");}
	})
}

///
function setElementEvent()
{
	//新增
	$('#btnAdd').bind('click', function () {
        if ((model.node.attributes.nodetype == "basisTemplate")||(model.node.attributes.nodetype == "leaf"))
		{
			$('#templateName').val("");
			getAllTitles(model.node.attributes.TemplateID);
			if(document.getElementById("divPlugin")&&(judgeIsIE()==false))
		    	document.getElementById("divPlugin").style.visibility="hidden"; //隐藏插件
			$('#addUserTemplateDialog').dialog('open');
		}
    });
	//新建科室模板
	$('#addUserTemplate').click(function () {
		AddUserTemplate();
	})
	//取消新建科室模板
	$('#cancelUserTemplate').click(function () {
		$('#addUserTemplateDialog').dialog('close');
		if(document.getElementById("divPlugin"))
    			document.getElementById("divPlugin").style.visibility="visible"; //显示插件
	})
    //保存
	$('#btnSave').click(function () {
		modifyUserTemplate();
	});
	//提交审核
	$('#btnCommit').click(function () {
		commitRequest();
	});
	//最小值是不否有效
	$("#HasMinVal").on("change", function () {
		var flag = true;
		if ($("#HasMinVal").attr("checked"))
			flag = false;
		$("#MinVal").attr("disabled", flag);
		$("#IncludeMax").attr("disabled", flag);
	});
    
	//最大值是不否有效
	$("#HasMaxVal").on("change", function () {
		var flag = true;
		if ($("#HasMaxVal").attr("checked"))
			flag = false;
		$("#MaxVal").attr("disabled", flag);
		$("#IncludeMin").attr("disabled", flag);
	});
    
	//是否包含日期
	$("#IncludeDate").on("change", function () {
		var flag = true;
		if ($("#IncludeDate").attr("checked"))
			flag = false;
		$("#DateFormat").attr("disabled", flag);
	});

	//是否包含时间
	$("#IncludeTime").on("change", function () {
		var flag = true;
		if ($("#IncludeTime").attr("checked"))
			flag = false;
		$("#TimeFormat").attr("disabled", flag);
	});

	$("#DictionaryType").on("change", function () {
		var selValue = $(this).children('option:selected').val();
		if (selValue == "STDDIC") {
			$("#CustDicClassName").attr("disabled", true);
			$("#CodeSystem").attr("disabled", false);
		} else if (selValue == "CUSTDIC") {
			$("#CodeSystem").attr("disabled", true);
			$("#CustDicClassName").attr("disabled", false);
		}
	});
	
	//字符单元
	$('#MIString').bind('click', function () {
		maxElementObj.MIString = getNewCode(+maxElementObj.MIString);
		var strJosn = {
			action : "APPEND_ELEMENT",
			args : {
				"ElemType" : "MIString",
				"Code" : "L" + maxElementObj.MIString,
				"DisplayName" : "新建字符单元" + (+maxElementObj.MIString)
			}
		};
		cmdDoExecute(strJosn);
	});
	
	//链接单元
	$('#MILink').bind('click', function () {
		maxElementObj.MILink = getNewCode(+maxElementObj.MILink);
		var strJosn = {
			action : "APPEND_ELEMENT",
			args : {
				"ElemType" : "MILink",
				"Code" : "H" + maxElementObj.MILink,
				"DisplayName" : "新建链接单元" + (+maxElementObj.MILink)
			}
		};
		cmdDoExecute(strJosn);
	});

	//数值单元
	$('#MINumber').bind('click', function () {
		maxElementObj.MINumber = getNewCode(+maxElementObj.MINumber);
		var strJosn = {
			action : "APPEND_ELEMENT",
			args : {
				"ElemType" : "MINumber",
				"Code" : "N" + maxElementObj.MINumber,
				"DisplayName" : "新建数字单元" + (+maxElementObj.MINumber)
			}
		};
		cmdDoExecute(strJosn);
	});

	//日期单元
	$('#MIDateTime').bind('click', function () {
		maxElementObj.MIDateTime = getNewCode(+maxElementObj.MIDateTime);
		var strJosn = {
			action : "APPEND_ELEMENT",
			args : {
				"ElemType" : "MIDateTime",
				"Code" : "D" + maxElementObj.MIDateTime,
				"DisplayName" : "新建日期单元" + (+maxElementObj.MIDateTime),
				"IncludeDate" : "True",
				"IncludeTime" : "True",
				"DateFormat" : "yyyy-MM-dd",
				"TimeFormat" : "HH:mm:ss"
			}
		};
		cmdDoExecute(strJosn);
	});

	//单选单元
	$('#MIMonoChoice').bind('click', function () {
		maxElementObj.MIMonoChoice = getNewCode(+maxElementObj.MIMonoChoice);
		var strJosn = {
			action : "APPEND_ELEMENT",
			args : {
				"ElemType" : "MIMonoChoice",
				"Code" : "O" + maxElementObj.MIMonoChoice,
				"DisplayName" : "新建单选单元" + (+maxElementObj.MIMonoChoice)
			}
		};
		cmdDoExecute(strJosn);
	});

	//多选单元
	$('#MIMultiChoice').bind('click', function () {
		maxElementObj.MIMultiChoice = getNewCode(+maxElementObj.MIMultiChoice);
		var strJosn = {
			action : "APPEND_ELEMENT",
			args : {
				"ElemType" : "MIMultiChoice",
				"Code" : "M" + maxElementObj.MIMultiChoice,
				"DisplayName" : "新建多选单元" + (+maxElementObj.MIMultiChoice)
			}
		};
		cmdDoExecute(strJosn);
	});

	//字典单元
	$('#MIDictionary').bind('click', function () {
		maxElementObj.MIDictionary = getNewCode(+maxElementObj.MIDictionary);
		var strJosn = {
			action : "APPEND_ELEMENT",
			args : {
				"ElemType" : "MIDictionary",
				"Code" : "I" + maxElementObj.MIDictionary,
				"DisplayName" : "新建字典单元" + (+maxElementObj.MIDictionary)
			}
		};
		cmdDoExecute(strJosn);
	});

	$("#sureSelect").click(function () {

		if (!$("#BindCode") || $("#BindCode").length <= 0)
			return;

		var tab = $('#databind').tabs('getSelected');
		var bindType = tab[0].id;
		var bindString = "";
		if (bindType == "DataBase") {
			var rowCategory = $("#dataBaseCategory").datagrid('getSelected');
			var rowDetial = $("#dataBaseDeital").datagrid('getSelected');
			if (rowCategory && rowDetial) {
				bindString = rowCategory.Name + "." + rowDetial.Name + "#TYPE:DataSet#CNAME:"
					 + rowCategory.ClassName + "#QNAME:" + rowCategory.QueryName + "#FNAME:"
					 + rowDetial.FieldName + "#VALUETYPE:" + rowDetial.ValueType;
			}
		}
		$("#BindCode").val(bindString);
		$("#BindType").val(bindType);
		$("#setPropty").accordion('select', '基本属性');

	});
}

//清空选择的单元的绑定数据
function clearBind()
{
	$("#BindCode").val("");
}

function openTemplate()
{
	if (plugin() == undefined)
	{
		var objString = "<object id='plugin' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'></object>";
		$('#divPlugin').append(objString);
	}
	else
	{
		$("#plugin")[0].style.width = "100%";
		$("#plugin")[0].style.height = "100%";
	}
	pluginAdd();
	plugin().initWindow("iEditor");
	//建立数据连接
	if (setConnect() == "err") 
	{
		top.$.messager.alert('提示','链接数据库失败，可能登录超时', 'info');
		return;
	}
	//设置工作环境  "Template"     Single
	cmdDoExecute({
		"action" : "SET_WORKSPACE_CONTEXT",
		"args" : "Template"
	});
	//设置设计状态
	cmdDoExecute({
		action : "SET_NOTE_STATE",
		args : "Design"
	});
	setTemplateLoadSection();
	//科室模板
	if (model.TemplateType == "department")	initSectionRelation();
	//加载模板
	loadlTemplate();
	//获取绑定HIS数据目录
	getDataBaseCatalog();
	//获取绑定病历数据目录
	getDataEMRCatalog();
	getDocOutline();
}

///创建编辑器//////////////////////////////////////////////////////////////////////////////////////
//挂接插件\事件监听
function pluginAdd() {
	addEvent(plugin(), 'onFailure', function (command) {
		alert(command);
	});
	addEvent(plugin(), 'onExecute', function (command) {
		var commandJson = jQuery.parseJSON(command);
		if (commandJson.action == "eventGetDocumentOutline") {
			eventGetDocumentOutline(commandJson);
		} else if (commandJson.action == "eventGetMetaDataTree") {
			eventGetMetaDataTree(commandJson);
		} else if (commandJson.action == "eventElementChanged") {
			eventElementChanged(commandJson);
		} else if (commandJson.action == "eventAppendElement") {
			eventAppendElement(commandJson);
		} else if (commandJson.action == "eventUpdateElement") {
			eventUpdateElement(commandJson);
		} else if (commandJson.action == "eventCaretContext") {
			eventCaretContext(commandJson);
		} else if (commandJson.action == "eventLoadDocument") {
			eventLoadDocument(commandJson);
		} else if (commandJson.action == "eventSaveSection") {
			eventSaveSection(commandJson);
		} else if (commandJson.action == "eventSectionChanged") {
			eventSectionChanged(commandJson);
		} else if (commandJson.action == "eventSaveDocument") {
			eventSaveDocument(commandJson);
		}
	});
}

//添加监听事件
function addEvent(obj, name, func) {
	if (obj.attachEvent) {
		obj.attachEvent("on" + name, func);
	} else {
		obj.addEventListener(name, func, false);
	}
}

//查找插件
function plugin() {
	return $("#plugin")[0];
}

//获取文档是否被修改过
function getModifyStatus()
{
	var argJson = {action:"CHECK_DOCUMENT_MODIFY",args:{"InstanceID":""}};
	return jQuery.parseJSON(cmdSyncExecute(argJson));
}

//建立数据库连接
function setConnect(){
	var netConnect = "";
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
            "p2":window.location.port,
            "p3":window.location.protocol.split(":")[0]
        },
        success: function (ret) {
			try{
            	netConnect = eval("("+ret+")");
			}catch(err){
				return "err";
			}
        },
        error: function (ret) {
            alert('setConnect err');
            if (!onError) {}
            else {
                onError(ret);
            }
        }
    });
    var strJson = {
        action: 'SET_NET_CONNECT',
        args: netConnect
    };
	return cmdSyncExecute(strJson);
}

function setTemplateLoadSection()
{
	var LoadSection = true;
	if (model.TemplateType == "basis")
	{
		var LoadSection = false;
	}
	cmdDoExecute({
		action : "SET_TEMPLATE_LOAD_SECTION",
		args : {"LoadSection":LoadSection,"UserTemplateCode":model.id}
	});
}

//加载模板
function loadlTemplate() {
	var strJson = {
		"action" : "LOAD_DOCUMENT",
		"args" : {
			"params" : {
				"action" : "LOAD_TEMPLATE",
				"TemplateVersionId" : model.TemplateVersionId
			}
		}
	};
    cmdDoExecute(strJson);
}

//将MeteData json 转成easyui tree标准json
function convertToTreeJson(dataList, treeJson, path) {
	
	var tempJson = "";
	for (var i = 0; i < dataList.length; i++) {
		var tempPath = "";
		if (path != undefined && path != "")
			tempPath = path + "_" + dataList[i].Code;
		else
			tempPath = dataList[i].Code;
		if (dataList[i].items != undefined) {

			tempJson = {
				"id" : tempPath,
				"text" : dataList[i].DisplayName,
				"attributes" : {
					"path" : tempPath,
					"type" : dataList[i].Type
				},
				"children" : []
			};
			convertToTreeJson(dataList[i].items, tempJson.children, tempPath);
			treeJson.push(tempJson);
		} else {
			tempJson = {
				"id" : tempPath,
				"text" : dataList[i].DisplayName,
				"attributes" : {
					"path" : tempPath,
					"type" : dataList[i].Type
				}
			};
			treeJson.push(tempJson);
			//setMaxElementObj(dataList[i].Code);
		}
	}
}

//初始化元素当前最大值(用于创建下一个元素)
function setMaxElementObj(code) {
	var type = code.substring(0, 1);
	var value = code.substring(1);
	switch (type) {
	case "L":
		if (+value > +maxElementObj.MIString)
			maxElementObj.MIString = value;
		break;
	case "N":
		if (+value > +maxElementObj.MINumber)
			maxElementObj.MINumber = value;
		break;
	case "D":
		if (+value > +maxElementObj.MIDateTime)
			maxElementObj.MIDateTime = value;
		break;
	case "O":
		if (+value > +maxElementObj.MIMonoChoice)
			maxElementObj.MIMonoChoice = value;
		break;
	case "M":
		if (+value > +maxElementObj.MIMultiChoice)
			maxElementObj.MIMultiChoice = value;
		break;
	case "I":
		if (+value > +maxElementObj.MIDictionary)
			maxElementObj.MIDictionary = value;
		break;
	case "H":
		if (+value > +maxElementObj.MILink)
			maxElementObj.MILink = value;
		break;
	}
}

//获取元素代码
function getNewCode(code) {
	code = code + 1;
	code = code.toString();
	var count = 4 - code.length;
	for (i = 0; i < count; i++) {
		code = "0" + code;
	}
	return code;
}

//异步执行execute
function cmdDoExecute(argJson) {
	plugin().execute(JSON.stringify(argJson));
};

//同步执行
function cmdSyncExecute(argJson) {
	return plugin().syncExecute(JSON.stringify(argJson));
};

//获取文档结构
function getDocOutline() {
	var strJson = {
		"action" : "GET_DOCUMENT_OUTLINE",
		"args" : ""
	}
	cmdDoExecute(strJson);
}

//调用加载知识库元素结构
function loadStructTree() {
	var strJson = {
		"action" : "GET_METADATA_TREE",
		"args" : ""
	}
	cmdDoExecute(strJson);
}

//定位元素
function focusElement(path) {
	var strJson = {
		action : "FOCUS_ELEMENT",
		args : {
			"Path" : path,
			"actionType" : "Select"
		}
	};
	cmdDoExecute(strJson);
	setSection(path);
}

/////工具栏//////////////////////////////////////////////////////////////////
//设置字体数据源
function setFontData() {
	var json = [{
			"value" : "宋体",
			"name" : "宋体"
		}, {
			"value" : "仿宋",
			"name" : "仿宋"
		}, {
			"value" : "楷体",
			"name" : "楷体"
		}, {
			"value" : "黑体",
			"name" : "黑体"
		}
	]
	$("#font").combobox({
		valueField:"value",
		textField:"name",
		data:json,
		onLoadSuccess:function(d){
			$("#font").combobox('select',"宋体");
		},
		onSelect:function(record){
			if (plugin() == undefined) return;
			var strJson = {
				action : "FONT_FAMILY",
				args : record.value
			};
			cmdDoExecute(strJson);
		},
		onHidePanel:function(){
			if(document.getElementById("divPlugin")) document.getElementById("divPlugin").style.visibility="visible"; //显示插件
		},
		onShowPanel:function(){
			if(document.getElementById("divPlugin")) document.getElementById("divPlugin").style.visibility="hidden"; //隐藏插件
		}
	});
}
//设置字体大小数据源
function setFontSizeData() {
	var json = [{
			"value" : "42pt",
			"name" : "初号"
		}, {
			"value" : "36pt",
			"name" : "小初号"
		}, {
			"value" : "31.5pt",
			"name" : "大一号"
		}, {
			"value" : "28pt",
			"name" : "一号"
		}, {
			"value" : "21pt",
			"name" : "二号"
		}, {
			"value" : "18pt",
			"name" : "小二号"
		}, {
			"value" : "16pt",
			"name" : "三号"
		}, {
			"value" : "14pt",
			"name" : "四号"
		}, {
			"value" : "12pt",
			"name" : "小四号"
		}, {
			"value" : "10.5pt",
			"name" : "五号"
		}, {
			"value" : "9pt",
			"name" : "小五号"
		}, {
			"value" : "8pt",
			"name" : "六号"
		}, {
			"value" : "6.875pt",
			"name" : "小六号"
		}, {
			"value" : "5.25pt",
			"name" : "七号"
		}, {
			"value" : "4.5pt",
			"name" : "八号"
		}, {
			"value" : "5pt",
			"name" : "5"
		}, {
			"value" : "5.5pt",
			"name" : "5.5"
		}, {
			"value" : "6.5pt",
			"name" : "6.5"
		}, {
			"value" : "7.5pt",
			"name" : "7.5"
		}, {
			"value" : "8.5pt",
			"name" : "8.5"
		}, {
			"value" : "9.5pt",
			"name" : "9.5"
		}, {
			"value" : "10pt",
			"name" : "10"
		}, {
			"value" : "10.5pt",
			"name" : "10.5"
		}, {
			"value" : "11pt",
			"name" : "11"
		}
	]
	$("#fontSize").combobox({
		valueField:"value",
		textField:"name",
		data:json,
		onLoadSuccess:function(d){
			$("#fontSize").combobox('select',"10.5pt");
		},
		onSelect:function(record){
			if (plugin() == undefined) return;
			var strJson = {
				action : "FONT_SIZE",
				args : record.value
			};
			cmdDoExecute(strJson);
		},
		onHidePanel:function(){
			if(document.getElementById("divPlugin")) document.getElementById("divPlugin").style.visibility="visible"; //显示插件
		},
		onShowPanel:function(){
			if(document.getElementById("divPlugin")) document.getElementById("divPlugin").style.visibility="hidden"; //隐藏插件
		}
	});
}

//工具栏
function toolButtonClick(type) {
	var strJson = "";
	if (type == "bold") {
		strJson = {
			action : "BOLD",
			args : {
				path : ""
			}
		}; //设置粗体
	} else if (type == "italic") {
		strJson = {
			action : "ITALIC",
			args : ""
		}; //设置斜体
	} else if (type == "underline") {
		strJson = {
			action : "UNDER_LINE",
			args : ""
		}; //设置下划线
	} else if (type == "strike") {
		strJson = {
			action : "STRIKE",
			args : ""
		};
	} else if (type == "super") //设置上标
	{
		strJson = {
			action : "SUPER",
			args : ""
		};
	} else if (type == "sub") {
		strJson = {
			action : "SUB",
			args : ""
		}; //设置下标
	} else if (type == "justify") {
		strJson = {
			action : "ALIGN_JUSTIFY",
			args : ""
		}; //设置两端对齐
	} else if (type == "alignleft") {
		strJson = {
			action : "ALIGN_LEFT",
			args : ""
		}; //设置左对齐
	} else if (type == "aligncenter") {
		strJson = {
			action : "ALIGN_CENTER",
			args : ""
		}; //设置居中对齐
	} else if (type == "alignright") {
		strJson = {
			action : "ALIGN_RIGHT",
			args : ""
		}; //设置右对齐
	} else if (type == "indent") {
		strJson = {
			action : "INDENT",
			args : ""
		}; //设置缩进
	} else if (type == "unindent") {
		strJson = {
			action : "UNINDENT",
			args : ""
		}; //设置反缩进
	} else if (type == "cut") {
		strJson = {
			action : "CUT",
			args : ""
		}; //剪切
	} else if (type == "copy") {
		strJson = {
			action : "COPY",
			args : ""
		}; //复制
	} else if (type == "paste") {
		strJson = {
			action : "PASTE",
			args : ""
		}; //粘贴
	} else if (type == "undo") {
		strJson = {
			action : "UNDO",
			args : ""
		}; //撤销
	} else if (type == "redo") {
		strJson = {
			action : "REDO",
			args : ""
		}; //重做
	}
	cmdDoExecute(strJson);
}

//保存章节信息
function saveSection(MetaDataTreeArray)
{
	for (var i=0;i<MetaDataTreeArray.length;i++)
	{
		if (MetaDataTreeArray[i].Code.slice(0,1) !== "S") continue;
		var SectionCode = MetaDataTreeArray[i].Code;
		var SectionName = MetaDataTreeArray[i].DisplayName;
		var Status = "";
		for (var j=0;j<SectionRelationArray.length;j++)
		{
			if (SectionRelationArray[j].split(':')[0] == SectionCode)
			{
				Status = SectionRelationArray[j].split(':')[1];
				break;
			}
		}
		jQuery.ajax({
			type: "post",
			dataType: "text",
			url: "../EMRservice.Ajax.common.cls",
			async: false,
			data: {
				"OutputType":"String",
				"Class":"EMRservice.BL.BLIEUserTemplate",
				"Method":"SetUserTemplateSectionRelation",
				"p1":tempUserTemplateID,
				"p2":SectionCode,
				"p3":SectionName,
				"p4":Status
			},
			success: function(d){
				
			},
			error: function(d) {alert("AddUserTemplateSectionRelation error");}
		});
		if (Status == "REPLACE")
		{
			var strJson = {
				"action" : "SAVE_SECTION",
				"args" : {
					"Path" : SectionCode,
					"params" : {
						"action" : "SAVE_SECTION",
						"SectionCode" : SectionCode,
						"SectionName" : SectionName,
						"BindKBBaseID" :MetaDataTreeArray[i].BindKBBaseID,
						"UserTemplateID" : tempUserTemplateID
					}
				}
			};
			cmdSyncExecute(strJson);
		}
	}
	if (typeof(initEmrTree) == "function") initEmrTree("1");

}

///事件监听///////////////////////////////////////////////////////////////////////////////
//获得模板元素结构
function eventGetDocumentOutline(commandJson) {
	if (0 == commandJson.args.Instances.length)
		return;

	var json = commandJson.args.Instances[0].Sections;
	if (0 == json.length) return;
	var treeJson = new Array();
	convertToTreeJson(json, treeJson, "");
	$('#elementTree').tree({
		data : treeJson,
		onClick : function (node) {
			focusElement(node.id);
		},
	})
	loadStructTree();
	loadTempFlag = true;
}

//获得模板元素结构
function eventGetMetaDataTree(commandJson) {
	if (saveSectionFlag == "1")
	{
		saveSection(commandJson.args.items);
		saveSectionFlag = "0";	//复位0 不可以保存章节
	}
	getMetaDataItems(commandJson.args.items);
}

function getMetaDataItems(items)
{
	for (var i=0;i<items.length;i++)
	{
		if (items[i].items != undefined)
		{
			getMetaDataItems(items[i].items);
		}
		else
		{
			setMaxElementObj(items[i].Code);
		}
	}
}

//元素改变事件
function eventElementChanged(commandJson) {
	if (commandJson.args.Focus == "Get") {
		try{
			var node = $('#elementTree').tree('find', commandJson.args.Path);
			//$('#elementTree').tree('select', node.target);
			currentPath = commandJson.args.Path;
			setProperty();
		} catch(e) {
		}
	}
}

function eventAppendElement(commandJson) {
	if (commandJson.args.result == "OK") {
		//loadStructTree();
		setProperty();
	}
}

//编辑器上下文感知功能
function eventCaretContext(commandJson) {
	//判断当前字体
	if (typeof(commandJson.args.FONT_FAMILY) == "undefined") {
		$("#font").combobox("setValue", "");
		$("#font").combobox("setText", "");
	} else {
		$("#font").combobox("setValue", commandJson.args.FONT_FAMILY);
		$("#font").combobox("setText", commandJson.args.FONT_FAMILY);
	}
	//判断当前字号
	$("#fontSize").combobox("setValue", "");
	$("#fontSize").combobox("setText", "");
	if (typeof(commandJson.args.FONT_SIZE) == "undefined") {
	} else {
		var tmpData = $("#fontSize").combobox("getData");
		for (var i = 0; i < tmpData.length; i++) {
			if (tmpData[i].value == commandJson.args.FONT_SIZE) {
				$("#fontSize").combobox("setValue", tmpData[i].value);
				$("#fontSize").combobox("setText", tmpData[i].name);
				break;
			}
		}
	}
}

//修改元素监听
function eventUpdateElement(commandJson) {
	if (commandJson.args.result == "OK") {
		//loadStructTree();
	}
}

//加载科室模板
function eventLoadDocument(commandJson) {
	if (commandJson.args.result == "ERROR") {
		alert('加载失败！');
	}

    //清除留痕
    var strJson = {
        "action" : "CLEAN_ALL_REVISIONS",
        "args" : ""
    };
    cmdDoExecute(strJson);
    
	if (model.TemplateType == "basis")	//基础模板
	{
		for(var i=0;i<commandJson.args.Sections.length;i++)
		{
			var Code = commandJson.args.Sections[i]["Code"];
			var name = commandJson.args.Sections[i]["Value"];
			SectionRelationArray[i] = Code+":REFERENCE:"+name;
		}
	}
	else
	{
		if (SectionRelationArray.length < 2)
		{
			for(var i=0;i<commandJson.args.Sections.length;i++)
			{
				var Code = commandJson.args.Sections[i]["Code"];
				var name = commandJson.args.Sections[i]["Value"];
				SectionRelationArray[i] = Code+":REFERENCE:"+name;
			}
		}
	}
    //根据章节继承属性设置只读
	var items = [];
	for(var i=0;i<SectionRelationArray.length;i++)
	{
		var tmp = SectionRelationArray[i].split(':')
		var status = tmp[1];
		var sectionCode = tmp[0];
		if (status == "REFERENCE") {
			items.push({"SectionCode":sectionCode,"ReadOnly":true});  
		}else if (status == "REPLACE"){
			items.push({"SectionCode":sectionCode,"ReadOnly":false});  
		}
	}
	var strJson = {
		"action" : "SET_SECTION_READONLY",
		"args" : {
			"Items" : items
		}
	};
	cmdDoExecute(strJson);
	///加载成功后设置按钮状态
	if (model.node.attributes.nodetype == "basisTemplate")	//基础模板
	{
		$("#btnAdd").linkbutton('enable');
		$("#btnSave").linkbutton('disable');
		$("#btnCommit").linkbutton('disable');
	}
	else	//科室模板
	{
		if ((model.node.attributes.Status == "0")||(model.node.attributes.Status == "4"))
		{
			$("#btnAdd").linkbutton('enable');
			$("#btnSave").linkbutton('enable');
			$("#btnCommit").linkbutton('enable');
		}
		else
		{
			$("#btnAdd").linkbutton('enable');
			$("#btnSave").linkbutton('disable');
			$("#btnCommit").linkbutton('disable');
		}
	}
}

//章节改变事件
function eventSectionChanged(commandJson) {
	setSection(commandJson.args.Code);
}

//保存
function eventSaveDocument(commandJson) {
	if (commandJson.args.result == "OK") {
		top.$.messager.popover({msg:'保存成功！', type:'success', style:{top:10,right:document.body.clientWidth/2}});
	}
}

//保存科室模板
function eventSaveSection(commandJson) {
	if (commandJson.args.result == "OK") {
		top.$.messager.popover({msg:'保存成功！', type:'success', style:{top:10,right:document.body.clientWidth/2}});
	} else {
		top.$.messager.popover({msg:'保存失败！', type:'error', style:{top:10,right:document.body.clientWidth/2}});
	}
}

///属性设置/////////////////////////////////////////////////////////////////////////////
///设置章节属性
function setSection(Code) {
	var strPropty = '<div style="margin:10px"><span>章节编码</span>&nbsp;&nbsp;&nbsp;<span><span><input id="SectionCode" type="text" class="textbox" disabled="true" style="width:160px;"></input></span></div>'
		 + '<div style="margin:10px"><span>章节名称</span>&nbsp;&nbsp;&nbsp;<span><input id="SectionName" type="text" class="textbox" disabled="true" style="width:160px;"></input></span></div>'
		 +'<div style="margin:10px"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;继承</span><span style="margin-left:11px"><input id="SectionStatus" type="combobox" class="hisui-combobox" style="width:167px;"></input></span></div>'

	$("#section")[0].innerHTML = strPropty; 
	$("#SectionCode").val(Code); 
	
	$("#SectionStatus").combobox({
		valueField:"id",
		textField:"text",
		data:[{'id':'REFERENCE','text':'是'},{'id':'REPLACE','text':'否'}],
		onSelect:function(){
			selectStatus();
		}
	});
	
	if (Code=="Header")
	{
		$("#SectionStatus").attr("disabled",true);
		$("#SectionName").val("页眉");
		$("#SectionStatus").combobox("setValue", 'REFERENCE');
	    $("#SectionStatus").combobox("setText", '是');
	}
	else if(Code=="Footer")
	{
		$("#SectionStatus").attr("disabled",true);
		$("#SectionName").val("页脚");
		$("#SectionStatus").combobox("setValue", 'REFERENCE');
	    $("#SectionStatus").combobox("setText", '是');
	}
	else
	{
		$("#SectionStatus").attr("disabled",false);
		for(var i=0;i<SectionRelationArray.length;i++)
		{
			var tmp = SectionRelationArray[i].split(':')
			var status = tmp[1];
			var sectionCode = tmp[0];
			var sectionName = tmp[2];
			if (sectionCode == Code)
			{
				$("#SectionName").val(sectionName);
				var statusText = "否"
				if (status == 'REFERENCE') statusText = "是";
				$("#SectionStatus").combobox("setValue", status);
			    $("#SectionStatus").combobox("setText", statusText);
			}
		}
	}
}

///根据章节继承属性设置只读
function selectStatus() {
	var isReadonly;
	var code = document.getElementById("SectionCode").value;
	var status = $("#SectionStatus").combobox("getValue");
	var name = document.getElementById("SectionName").value;
	if (status == "REFERENCE"){
		top.$.messager.confirm("警示", "继承属性由【否】改为【是】，修改的章节内容会丢失，请再次确认是否修改？", function (r) {
		    if (r) {   
				isReadonly = true;
					var item =[{"SectionCode":code,"ReadOnly":isReadonly}];
					var strJson = {
						"action" : "SET_SECTION_READONLY",
						"args" : {
							"Items" : item
						}
					};
					cmdDoExecute(strJson);
					updateStatus(code,"REFERENCE",name);
			} else {
				document.getElementById('SectionStatus').value = "REPLACE";
			}
		});
		
	}else if (status == "REPLACE"){
		isReadonly = false;
		var item =[{"SectionCode":code,"ReadOnly":isReadonly}];
		var strJson = {
			"action" : "SET_SECTION_READONLY",
			"args" : {
				"Items" : item
			}
		};
		cmdDoExecute(strJson);
		updateStatus(code,status,name);
	}
}

///修改章节继承属性
function updateStatus(Code,Status,Name)
{
	for(var i=0;i<SectionRelationArray.length;i++)
	{
		var sectionCode = SectionRelationArray[i].split(':')[0];
		if (sectionCode == Code)
		{
			SectionRelationArray[i] = Code+':'+Status+':'+Name;
		}
	}
}

//设置单元属性
function setProperty() {
	/* if (model.TemplateType == "basis") //基础模板
	{
		$("div").remove("#property div");
		return;
	} */
	var strJson = {
		"action" : "GET_ELEMENT_CONTEXT",
		"args" : {
			"Type" : "MIElement"
		}
	}
	var elementContext = cmdSyncExecute(strJson);
	if ((''===elementContext)||('NONE'==elementContext))
	{
		$("div").remove("#property div");
		return;
	}
	elementContext = $.parseJSON(elementContext);
	currentPath = elementContext.Path;
	var type = elementContext.Props.ElemType;
	if (type == "MIString") {
		setMIString(elementContext);
	} else if (type == "MINumber") {
		setMINumber(elementContext);
	} else if (type == "MIDateTime") {
		setMIDateTime(elementContext);
	} else if (type == "MIMonoChoice") {
		setMIMonoChoice(elementContext);
	} else if (type == "MIMultiChoice") {
		setMIMultiChoice(elementContext);
	} else if (type == "MIDictionary") {
		setMIDictionary(elementContext);
	} else if (type == "MILink") {
		setMILink(elementContext);
	} else {
		$("div").remove("#property div");
	}
}

//初始化元素基本属性
function initBasePropty() {
	var strPropty =initTabIndex()
		 + '<div style="margin-top:10px">' +'<span style="margin-right:30px">'+ initVisible() +'</span>'+ initReadOnly() + initFixedStructs() + '</div>'
		 + '<div style="margin-top:10px">' +'<span style="margin-right:30px">'+ initAllowNull() +'</span>'+ initSynch() + initSilentSynch() +'</span>'+ '</div>'
		 + '<div style="margin-top:10px">' + initCode() + '</div>'
		 + '<div style="margin-top:10px">' + initDisplayName() + '</div>'
		 + '<div style="margin-top:10px">' + initDescription() + '</div>'
		 + '<div style="margin-top:10px">' + initDataBind() + '</div>'
		 + '<div style="margin-top:10px">' + initValidateMsg() + '</div>'
		 + '<div style="margin-top:10px">' + initConfidentiality() + '</div>'
		return strPropty;
}

//设置元素基本属性
function setBasePropty(obj) {
	setTabIndex(obj.Props.TabIndex);
	setVisible(obj.Props.Visible);
	setAllowNull(obj.Props.AllowNull);
	setReadOnly(obj.Props.ReadOnly);
	setCode(obj.Props.Code);
	setDisplayName(obj.Props.DisplayName);
	setDescription(obj.Props.Description);
	setDataBind(obj.Props.BindCode, obj.Props.BindType);
	setSynch(obj.Props.Synch);
	setSilentSynch(obj.Props.SilentSynch);
	setValidateMsg(obj.Props.ValidateMsg);
	setConfidentiality(obj.Props.ConfidentialityCode);
	setFixedStructs(obj.Props.FixedStructs);
}

function getBasePropty() {
	var obj = {};
	obj.TabIndex = $("#TabIndex").val();
	obj.Visible = $("#Visible").checkbox("getValue");
	obj.AllowNull = $("#AllowNull").checkbox("getValue");
	obj.ReadOnly = $("#ReadOnly").checkbox("getValue");
	obj.Code = $("#Code").val();
	obj.DisplayName = $("#DisplayName").val();
	obj.Description = $("#Description").val();
	obj.BindCode = $("#BindCode").val();
	obj.BindType = $("#BindType").val();
	obj.Synch = $("#Synch").checkbox("getValue");
	obj.SilentSynch = $("#SilentSynch").checkbox("getValue");
	obj.ValidateMsg = $("#ValidateMsg").val();
	obj.ConfidentialityCode = $("#ConfidentialityCode").combobox("getValue");
	obj.FixedStructs = $("#FixedStructs").checkbox("getValue");
	return obj;
}

//字符单元
function setMIString(obj) {
	if (!obj || obj == "")
		return;
	var strPropty = initBasePropty()
		 + '<div style="margin-top:10px">' + initRegExp() + '</div>'
		 + '<div style="margin-top:10px">' + initMaxLength() + '</div>'
		 + '<div style="margin-top:10px">' + initSignLevel() + '</div>'
		 + '<div style="margin-top:10px">' +'<span style="margin-right:30px">'+ initQrCode() +'</span>'+ initShowSignerDescription() + '</div>'
		 + '<div style="margin-top:10px">' + initSave() + '</div>'
		 
		$("#property")[0].innerHTML = strPropty;
	$.parser.parse('#property');
	setBasePropty(obj);
	setRegExp(obj.Props.RegExp);
	setMaxLength(obj.Props.MaxLength);
	setSignLevel(obj.Props.SignatureLevel);
	setQrCode(obj.Props.QrCode);
	setShowSignerDescription(obj.Props.ShowSignerDescription);
	initSaveOnclick();
}

//设置链接单元
function setMILink(obj) {
	if (!obj || obj == "")
		return;
	var strPropty = initBasePropty()
		 + '<div style="margin-top:10px">' + initMILinkUrl() + '</div>'
		 + '<div style="margin-top:10px">' + initWriteBack() + '</div>'
		 + '<div style="margin-top:10px">' + initSave() + '</div>'
		 
		$("#property")[0].innerHTML = strPropty;
	$.parser.parse('#property');
	setBasePropty(obj);
	setMILinkUrl(obj.Props.Url);
	setWriteBack(obj.Props.WriteBack);
	initSaveOnclick();
}

//设置数字单元
function setMINumber(obj) {
	if (!obj || obj == "")
		return;
	var strPropty = initBasePropty()
		 + '<div style="margin-top:10px">' +'<span style="margin-right:20px">'+ initHasMinVal() + initMinVal() +'</span>'+ initIncludeMax() + '</div>'
		 + '<div style="margin-top:10px">' +'<span style="margin-right:20px">'+ initHasMaxVal() + initMaxVal() +'</span>'+ initIncludeMin() + '</div>'
		 + '<div style="margin-top:10px">' + initDecimalPlace() + '</div>'
		 + '<div style="margin-top:10px">' + initSave() + '</div>'

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
function setMIMonoChoice(obj) {
	if (!obj || obj == "")
		return;
	var strPropty = initBasePropty()
		 + '<div style="margin-top:10px">' + initChoices() + '</div>'
		 + '<div style="margin-top:10px">' + initSave() + '</div>'

		$("#property")[0].innerHTML = strPropty;
	$.parser.parse('#property');
	setBasePropty(obj);
	setChoices(obj.Props.Choices);
	initSaveOnclick();
}

//多选单元
function setMIMultiChoice(obj) {
	if (!obj || obj == "")
		return;
	var strPropty = initBasePropty()
		 + '<div style="margin-top:10px">' + initSeparator() +'<span style="margin-left:20px">'+ initWrapChoice() +'</span>'+ '</div>'
		 + '<div style="margin-top:10px">' + initChoices() + '</div>'
		 + '<div style="margin-top:10px">' + initSave() + '</div>'

		$("#property")[0].innerHTML = strPropty;
	$.parser.parse('#property');
		
	setBasePropty(obj);
	setSeparator(obj.Props.Separator);
	setWrapChoice(obj.Props.WrapChoice);
	setChoices(obj.Props.Choices);
	initSaveOnclick();
}

//日期单元
function setMIDateTime(obj) {
	if (!obj || obj == "")
		return;
	var strPropty = initBasePropty()
		 + '<div style="margin-top:10px">' + initIncludeDate() +'<span style="margin-left:10px">'+ initDateFormat() + '</span></div>'
		 + '<div style="margin-top:10px">' + initIncludeTime() +'<span style="margin-left:10px">'+ initTimeFormat() + '</span></div>'
		 + '<div style="margin-top:10px">' + initSave() + '</div>'

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
function setMIDictionary(obj) {
	if (!obj || obj == "")
		return;
	var strPropty = initBasePropty()
		 + '<div style="margin-top:10px">' + initDictionaryType() + '</div>'
		 + '<div style="margin-top:10px">' + initCodeSystem() + '</div>'
		 + '<div style="margin-top:10px">' + initCustDicClassName() + '</div>'
		 + '<div style="margin-top:10px">' + initDisplayType() + '</div>'
		 + '<div style="margin-top:10px">' + initSeparator() + '</div>'
		 + '<div style="margin-top:10px">' + initLinkCode() + '</div>'
		 + '<div style="margin-top:10px">' + initLinkMethod() + '</div>'
		 + '<div style="margin-top:10px">' + initLinkDisplayType() + '</div>'
		 + '<div style="margin-top:10px">' + initAllowCodeNull() + '</div>'
		 + '<div style="margin-top:10px">' + initAllowValueNull() + '</div>'
		 + '<div style="margin-top:10px">' + initAssociateItem() + '</div>'
		 + '<div style="margin-top:10px">' + initRegExp() + '</div>'
		 + '<div style="margin-top:10px">' + initMaxLength() + '</div>'
		 + '<div style="margin-top:10px">' + initSave() + '</div>'

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
function getMIString() {
	var obj = getBasePropty();
	obj.ElemType = "MIString";
	obj.RegExp = $("#RegExp").val();
	obj.MaxLength = $("#MaxLength").val();
	obj.SignatureLevel = $("#SignLevel").combobox("getValue");
	obj.QrCode = $("#QrCode").checkbox("getValue");
	obj.ShowSignerDescription = $("#ShowSignerDescription").checkbox("getValue");
	return obj;
}

//链接单元
function getMILink() {
	var obj = getBasePropty();
	obj.ElemType = "MILink";
	obj.Url = $("#MILinkUrl").val();
	obj.WriteBack = $("#WriteBack").combobox("getValue");
	return obj;
}

//数字元素obj
function getMINumber() {
	var obj = getBasePropty();
	obj.ElemType = "MINumber";
	obj.HasMinVal = $("#HasMinVal").checkbox("getValue");
	obj.MinVal = $("#MinVal").val();
	obj.IncludeMin = $("#IncludeMin").checkbox("getValue");
	obj.HasMaxVal = $("#HasMaxVal").checkbox("getValue");
	obj.MaxVal = $("#MaxVal").val();
	obj.IncludeMax = $("#IncludeMax").checkbox("getValue");
	obj.DecimalPlace = $("#DecimalPlace").val();
	return obj;
}

//单选单元
function getMIMonoChoice() {
	var obj = getBasePropty();
	obj.ElemType = "MIMonoChoice";
	var list = $("#Choices").val().split("\n");
	var Choices = new Array();
	for (i = 0; i < list.length; i++) {
		if (list[i] != "") {
			Choices.push({
				"Code" : list[i].split("|")[1],
				"DisplayName" : list[i].split("|")[0]
			});
		}
	}
	obj.Choices = Choices;
	return obj;
}

//多选单元
function getMIMultiChoice() {
	var obj = getBasePropty();
	obj.ElemType = "MIMultiChoice";
	obj.Separator = $("#Separator").val();
	obj.WrapChoice = $("#WrapChoice").checkbox("getValue");
	var list = $("#Choices").val().split("\n");
	var Choices = new Array();
	for (i = 0; i < list.length; i++) {
		Choices.push({
			"Code" : list[i].split("|")[1],
			"DisplayName" : list[i].split("|")[0]
		});
	}
	obj.Choices = Choices;
	return obj;
}

//日期单元
function getMIDateTime() {
	var obj = getBasePropty();
	obj.ElemType = "MIDateTime";
	obj.IncludeDate = $("#IncludeDate").checkbox("getValue");
	obj.IncludeTime = $("#IncludeTime").checkbox("getValue");
	obj.DateFormat = $("#DateFormat").combobox("getValue");
	obj.TimeFormat = $("#TimeFormat").combobox("getValue");
	return obj;
}

//字典单元
function getMIDictionary() {
	var obj = getBasePropty();
	obj.ElemType = "MIDictionary";
	obj.DictionaryType = $("#DictionaryType").combobox("getValue");
	obj.CodeSystem = $("#CodeSystem").combobox("getValue");
	obj.CodeSystemName = $("#CodeSystem").text();
	obj.CustDicClassName = $("#CustDicClassName").val();
	obj.DisplayType = $("#DisplayType").combobox("getValue");
	obj.Separator = $("#Separator").val();
	obj.LinkCode = $("#LinkCode").val();
	obj.LinkMethod = $("#LinkMethod").combobox("getValue");
	obj.LinkDisplayType = $("#LinkDisplayType").combobox("getValue");
	obj.AllowCodeNull = $("#AllowCodeNull").checkbox("getValue");
	obj.AllowValueNull = $("#AllowValueNull").checkbox("getValue");
	obj.AssociateItem = $("#AssociateItem").val();
	obj.RegExp = $("#RegExp").val();
	obj.MaxLength = $("#MaxLength").val();
	return obj;
}

//取元素属性
function getElementPropty(type) {
	var obj = "";
	if (type == "L") {
		obj = getMIString();
	} else if (type == "N") {
		obj = getMINumber();
	} else if (type == "D") {
		obj = getMIDateTime();
	} else if (type == "O") {
		obj = getMIMonoChoice();
	} else if (type == "M") {
		obj = getMIMultiChoice();
	} else if (type == "I") {
		obj = getMIDictionary();
	} else if (type == "H") {
		obj = getMILink();
	}
	return obj;
}

//简单元素编码
function initCode() {
	var str = '<div><lable class="lableCss">元素编码</lable>'
		 + '<input id="Code" type="text" class="textbox" disabled="true" style="width:165px;"></input></div>'
		return str;
}

//简单元素描述
function initDisplayName() {
	var str = '<div><lable class="lableCss">元素描述</lable>'
		 + '<textarea id="DisplayName" type="text" class="textbox" rows="2" cols="20" style="width:165px;"></textarea></div>'
		return str;
}

//简单元素含义描述
function initDescription() {
	var str = '<div><lable class="lableCss">含义描述</lable>'
		 + '<textarea id="Description" type="text" class="textbox" rows="2" cols="20" style="width:165px;"></textarea></div>'
		return str;
}

//链接单元的操作
function initMILinkUrl() {
	var str = '<div><lable class="lableCss">操作</lable>'
		 + '<textarea id="MILinkUrl" type="text" class="textbox" rows="2" cols="20" style="width:165px;"></textarea></div>'
		return str;
}

//回写方式
function initWriteBack() {
	var str = '<lable class="lableCss">回写方式</lable>'
		+ '<input id="WriteBack" name="WriteBack" type="combobox" class="hisui-combobox" style="width:172px;"></input>'
		return str;
}

//数据绑定
function initDataBind() {
	var str = '<div><lable class="lableCss">数据绑定</lable>'
		 + '<input id="BindCode" type="text" class="textbox" disabled="true" style="width:97px;"></input>'
		 + '<span><input id="BindType" type="text" style="display:none;"></input></span>'
		 + '<span style="margin-left:10px"><a href="#" id="clearBind" class="hisui-linkbutton" onclick="clearBind()">清空</a></div>'
		return str;
}

//同步
function initSynch() {
	var str = '<span style="margin-right:30px"><input id="Synch" type="checkbox" class="hisui-checkbox" name="Synch">同步</input></span>'
		return str;
}

//静默刷新
function initSilentSynch() {
	var str = '<span><input id="SilentSynch" type="checkbox" class="hisui-checkbox" name="SilentSynch">静默刷新</input></span>'
		return str;
}

//不为空
function initAllowNull() {
	var str = '<input id="AllowNull" type="checkbox" class="hisui-checkbox" name="AllowNull">不为空</input>'
		return str;
}

//校验消息
function initValidateMsg() {
	var str = '<div><lable class="lableCss">校验消息</lable>'
		 + '<input id="ValidateMsg" type="text" class="textbox" style="width:165px;"></input></div>'
		return str;
}

//正则表达式
function initRegExp() {
	var str = '<div><lable class="lableCss">正则表达式</lable>'
		 + '<input id="RegExp" type="text" class="textbox" style="width:165px;"></input></div>'
		return str;
}

//顺序号
function initTabIndex() {
	var str = '<div><lable class="lableCss">TabIndex</lable>'
		 + '<input id="TabIndex" type="text" class="textbox" style="width:165px;"></input></div>'
		return str;
}

//不可见
function initVisible() {
	var str = '<input id="Visible" type="checkbox" class="hisui-checkbox" name="Visible">不可见</input>'
		return str;
}

//只读
function initReadOnly() {
	var str = '<span style="margin-right:30px"><input id="ReadOnly" type="checkbox" class="hisui-checkbox" name="ReadOnly">只读</input></span>'
		return str;
}

//机密级别
function initConfidentiality() {
	var str = '<lable class="lableCss">保密级别</lable>'
		+ '<input id="ConfidentialityCode" name="ConfidentialityCode" type="combobox" class="hisui-combobox" style="width:172px;"></input>'
		return str;
}

//固定结构
function initFixedStructs() {
	var str = '<input id="FixedStructs" type="checkbox" class="hisui-checkbox" name="FixedStructs">固定结构</input>'
		return str;
}

//最大长度(MIString)
function initMaxLength() {
	var str = '<div><lable class="lableCss">最大长度</lable>'
		 + '<input id="MaxLength" type="text" class="textbox" style="width:165px;"></input></div>'
		return str;
}

//签名级别(MIString)
function initSignLevel() {
	var str = '<lable class="lableCss">签名级别</lable>'
		+ '<input id="SignLevel" name="SignLevel" type="combobox" class="hisui-combobox" style="width:172px;"></input>'
		return str;
}

//二维码(MIString)
function initQrCode() {
	var str = '<input id="QrCode" type="checkbox" class="hisui-checkbox" name="QrCode">显示二维码</input>'
	return str;
}

//显示职称(MIString)
function initShowSignerDescription() {
	var str = '<input id="ShowSignerDescription" type="checkbox" class="hisui-checkbox" name="ShowSignerDescription">显示职称</input>'
	return str;
}

//最小值
function initMinVal() {
	var str = '<input id="MinVal" type="text" class="textbox" style="width:40px;"></input>'
		return str;
}

//最大值
function initMaxVal() {
	var str = '<input id="MaxVal" type="text" class="textbox" style="width:40px;"></input>'
		return str;

}

//设置最小值
function initHasMinVal() {
	var str = '<input id="HasMinVal" type="checkbox" class="hisui-checkbox" name="HasMinVal">最小值</input>'
		return str;
}

//设置最大值
function initHasMaxVal() {
	var str = '<input id="HasMaxVal" type="checkbox" class="hisui-checkbox" name="HasMaxVal">最大值</input>'
		return str;
}

//是否是小于等于
function initIncludeMin() {
	var str = '<input id="IncludeMin" type="checkbox" class="hisui-checkbox" name="IncludeMin">是否小于等于</input>'
		return str;
}

//是否是大于等于
function initIncludeMax() {
	var str = '<input id="IncludeMax" type="checkbox" class="hisui-checkbox" name="IncludeMax">是否大于等于</input>'
		return str;
}

//小数点位数
function initDecimalPlace() {
	var str = '<div><lable class="lableCss">小数位数</lable>'
		 + '<input id="DecimalPlace" type="text" class="textbox" style="width:165px;"></input></div>'
		return str;
}

//备选项集合
function initChoices() {
	var str = '<div style="margin-left:9px"><lable>在集合中输入备选项(每行一个值|ID)</lable>'
 		 + '<textarea id="Choices" type="text" class="textbox" rows="6" cols="60" style="width:236px;margin-top:10px"></textarea></div>'
		return str;
}

//分隔符
function initSeparator() {
	var str = '<span><lable class="lableCss">分隔符</lable>'
		 + '<input id="Separator" type="text" class="textbox" style="width:70px;"></input></span>'
		return str;
}

//备选项强制换行
function initWrapChoice() {
	var str = '<input id="WrapChoice" type="checkbox" class="hisui-checkbox" name="WrapChoice">强制换行</input>'
		return str;
}

//包含日期
function initIncludeDate() {
	var str = '<input id="IncludeDate" type="checkbox" class="hisui-checkbox" name="IncludeDate">日期</input>'
		return str;
}

//包含时间
function initIncludeTime() {
	var str = '<input id="IncludeTime" type="checkbox" class="hisui-checkbox" name="IncludeTime">时间</input>'
		return str;
}

//日期格式
function initDateFormat() {
	var str = '<lable style="width:60px;text-align:right;margin:4px 10px 0 0;">日期格式</lable>'
		+ '<input id="DateFormat" name="DateFormat" type="combobox" class="hisui-combobox" style="width:127px;"></input>'
		return str;
}

//时间格式
function initTimeFormat() {
	var str = '<lable style="width:60px;text-align:right;margin:4px 10px 0 0;">时间格式</lable>'
		+ '<input id="TimeFormat" name="TimeFormat" type="combobox" class="hisui-combobox" style="width:127px;"></input>'
		return str;
}

//字典类型
function initDictionaryType() {
	var str = '<lable class="lableCss">字典类型</lable>'
		+ '<input id="DictionaryType" name="DictionaryType" type="combobox" class="hisui-combobox" style="width:172px;"></input>'
		return str;
}

//标准字典名称
function initCodeSystem() {
	var str = '<lable class="lableCss">标准字典</lable>'
		+ '<input id="CodeSystem" name="CodeSystem" type="combobox" class="hisui-combobox" style="width:172px;"></input>'
		return str;
}

//自定义字典名称
function initCustDicClassName() {
	var str = '<div><lable class="lableCss">自定义字典</lable>'
		 + '<input id="CustDicClassName" type="text" class="textbox" style="width:165px;"></input></div>'
		return str;
}

//字典显示类型
function initDisplayType() {
	var str = '<lable class="lableCss">显示类型</lable>'
		+ '<input id="DisplayType" name="DisplayType" type="combobox" class="hisui-combobox" style="width:172px;"></input>'
		return str;
}

//关联的结构化单元
function initLinkCode() {
	var str = '<div><lable class="lableCss">关联Code</lable>'
		 + '<input id="LinkCode" type="text" class="textbox" style="width:165px;"></input></div>'
		return str;
}

//链接方式：Append/Replace/Prefix
function initLinkMethod() {
	var str = '<lable class="lableCss">链接方式</lable>'
		+ '<input id="LinkMethod" name="LinkMethod" type="combobox" class="hisui-combobox" style="width:172px;"></input>'
		return str;
}

//允许使用非标准字典代码
function initAllowCodeNull() {
	var str = '<input id="AllowCodeNull" type="checkbox" class="hisui-checkbox" name="AllowCodeNull">允许使用非标准字典代码</input>'
		return str;
}

//允许使用非标准字典描述
function initAllowValueNull() {
	var str = '<input id="AllowValueNull" type="checkbox" class="hisui-checkbox" name="AllowValueNull">允许使用非标准字典描述</input>'
		return str;
}

//查询条件单元
function initAssociateItem() {
	var str = '<div><lable class="lableCss" style="width:auto">查询条件单元</lable>'
		 + '<input id="AssociateItem" type="text" class="textbox" style="width:245px;"></input></div>'
		return str;
}

//关联元素显示类型
function initLinkDisplayType() {
	var str = '<lable class="lableCss" style="width:125px">关联元素显示类型</lable>'
		+ '<input id="LinkDisplayType" name="LinkDisplayType" type="combobox" class="hisui-combobox" style="width:117px;"></input>'
		return str;
}

//保存
function initSave() {
	var str ='<a href="#" id="propertySave" class="hisui-linkbutton green" style="float:right">保存</a>'
	return str;
}

//简单元素编码
function setCode(value) {
	$("#Code").val(value);
}

//简单元素描述
function setDisplayName(value) {
	$("#DisplayName").val(value);
}

//简单元素含义描述
function setDescription(value) {
	$("#Description").val(value);
}

//数据绑定
function setDataBind(codeValue, typeValue) {
	$("#BindCode").val(codeValue);
	$("#BindType").val(typeValue);
}

//同步
function setSynch(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#Synch").checkbox("check");
	} else {
		$("#Synch").checkbox("uncheck");
	}
}

//静默刷新
function setSilentSynch(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#SilentSynch").checkbox("check");
	} else {
		$("#SilentSynch").checkbox("uncheck");
	}
}

//不为空
function setAllowNull(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#AllowNull").checkbox("check");
	} else {
		$("#AllowNull").checkbox("uncheck");
	}
}

//二维码
function setQrCode(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#QrCode").checkbox("check");
	} else {
		$("#QrCode").checkbox("uncheck");
	}
}

//显示职称
function setShowSignerDescription(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#ShowSignerDescription").checkbox("check");
	} else {
		$("#ShowSignerDescription").checkbox("uncheck");
	}
}

//校验消息
function setValidateMsg(value) {
	$("#ValidateMsg").val(value)
}

//正则表达式
function setRegExp(value) {
	$("#RegExp").val(value);
}

//顺序号
function setTabIndex(value) {
	$("#TabIndex").val(value)
}

//不可见
function setVisible(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#Visible").checkbox("check");
	} else {
		$("#Visible").checkbox("uncheck");
	}
}

//只读
function setReadOnly(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#ReadOnly").checkbox("check");
	} else {
		$("#ReadOnly").checkbox("uncheck");
	}
}

//保密级别
function setConfidentiality(value) {
	var json = [{
			value : "N",
			name : "正常"
		}, {
			value : "R",
			name : "严格"
		}, {
			value : "V",
			name : "非常严格"
		}
	];
	$("#ConfidentialityCode").combobox({
		valueField:"value",
		textField:"name",
		data:json,
		onLoadSuccess:function(d){
			$("#ConfidentialityCode").combobox('select',value);
		}
	});
}

//固定结构
function setFixedStructs(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#FixedStructs").checkbox("check");
	} else {
		$("#FixedStructs").checkbox("uncheck");
	}
}

//最大长度 (MIString)
function setMaxLength(value) {
	$("#MaxLength").val(value);
}

//连接单元的操作
function setMILinkUrl(value) {
	$("#MILinkUrl").val(value);
}

//回写方式
function setWriteBack(value) {
	var json = [{
			value : "Replace",
			name : "Replace"
		}, {
			value : "Append",
			name : "Append"
		}, {
			value : "None",
			name : "None"
		}
	]
	$("#WriteBack").combobox({
		valueField:"value",
		textField:"name",
		data:json,
		onLoadSuccess:function(d){
			$("#WriteBack").combobox('select',value);
		}
	});
}

//最小值
function setMinVal(value) {
	$("#MinVal").val(value);
}

//最大值
function setMaxVal(value) {
	$("#MaxVal").val(value);
}

//设置最小值
function setHasMinVal(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#HasMinVal").checkbox("check");
	} else {
		$("#HasMinVal").checkbox("uncheck");
		/* $("#MinVal").attr("disabled", true);
		$("#IncludeMax").attr("disabled", true); */
	}
}

//设置最大值
function setHasMaxVal(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#HasMaxVal").checkbox("check");
	} else {
		$("#HasMaxVal").checkbox("uncheck");
		/* $("#MaxVal").attr("disabled", true);
		$("#IncludeMin").attr("disabled", true); */
	}
}

//是否是小于等于
function setIncludeMin(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#IncludeMin").checkbox("check");
	} else {
		$("#IncludeMin").checkbox("uncheck");
	}
}

//是否是大于等于
function setIncludeMax(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#IncludeMax").checkbox("check");
	} else {
		$("#IncludeMax").checkbox("uncheck");
	}
}

//小数点位数
function setDecimalPlace(value) {
	$("#DecimalPlace").val(value);
}

//备选项
function setChoices(value) {
	var text = "";
	for (var i = 0; i < value.length; i++) {
		text = text + value[i].DisplayName + "|" + value[i].Code + "\n";
	}
	$("#Choices").val(text);
}

//分隔符
function setSeparator(value) {
	$("#Separator").val(value);
}

//备选项强制换行
function setWrapChoice(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#WrapChoice").checkbox("check");
	} else {
		$("#WrapChoice").checkbox("uncheck");
	}
}

//包含日期
function setIncludeDate(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#IncludeDate").checkbox("check");
	} else {
		$("#IncludeDate").checkbox("uncheck");
		$("#DateFormat").attr("disabled", true);
	}
}

//包含日期
function setIncludeTime(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#IncludeTime").checkbox("check");
	} else {
		$("#IncludeTime").checkbox("uncheck");
		$("#TimeFormat").attr("disabled", true);
	}
}

//日期格式
function setDateFormat(value) {
	var json = [{
			value : "yyyy-MM-dd",
			name : "yyyy-MM-dd"
		}, {
			value : "yyyy年MM月dd日",
			name : "yyyy年MM月dd日"
		}
	]
	$("#DateFormat").combobox({
		valueField:"value",
		textField:"name",
		data:json,
		onLoadSuccess:function(d){
			$("#DateFormat").combobox('select',value);
		}
	});
}

//时间显示格式
function setTimeFormat(value) {
	var json = [{
			value : "HH:mm",
			name : "HH:mm"
		}, {
			value : "HH:mm:ss",
			name : "HH:mm:ss"
		}
	]
	$("#TimeFormat").combobox({
		valueField:"value",
		textField:"name",
		data:json,
		onLoadSuccess:function(d){
			$("#TimeFormat").combobox('select',value);
		}
	});
}

//字典类型
function setDictionaryType(value) {
	var json = [{
			value : "STDDIC",
			name : "标准字典"
		}, {
			value : "CUSTDIC",
			name : "自定义字典"
		}
	]
	$("#DictionaryType").combobox({
		valueField:"value",
		textField:"name",
		data:json,
		onLoadSuccess:function(d){
			$("#DictionaryType").combobox('select',value);
		}
	});
}

//字典代码
function setCodeSystem(value, data) {
	$("#CodeSystem").combobox({
		valueField:"Code",
		textField:"Name",
		data:data,
		onLoadSuccess:function(d){
			$("#CodeSystem").combobox('select',value);
		}
	});
}

//自定义字典名
function setCustDicClassName(value) {
	$("#CustDicClassName").val(value);
}

//显示类型
function setDisplayType(value) {
	var json = [{
			value : "Desc",
			name : "描述"
		}, {
			value : "Code",
			name : "代码"
		}
	]
	$("#DisplayType").combobox({
		valueField:"value",
		textField:"name",
		data:json,
		onLoadSuccess:function(d){
			$("#DisplayType").combobox('select',value);
		}
	});
}

//关联的结构化单元
function setLinkCode(value) {
	$("#LinkCode").val(value);
}

//链接方式
function setLinkMethod(value) {
	var json = [{
			value : "Append",
			name : "追加"
		}, {
			value : "Replace",
			name : "替换"
		}, {
			value : "Prefix",
			name : "前加"
		}
	]
	$("#LinkMethod").combobox({
		valueField:"value",
		textField:"name",
		data:json,
		onLoadSuccess:function(d){
			$("#LinkMethod").combobox('select',value);
		}
	});
}

//允许使用非标准字典代码
function setAllowCodeNull(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#AllowCodeNull").checkbox("check");
	} else {
		$("#AllowCodeNull").checkbox("uncheck");
	}
}

//允许使用非标准字典描述
function setAllowValueNull(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#AllowValueNull").checkbox("check");
	} else {
		$("#AllowValueNull").checkbox("uncheck");
	}
}

//查询条件单元
function setAssociateItem(value) {
	$("#AssociateItem").val(value);
}

//关联元素显示类型
function setLinkDisplayType(value) {
	var json = [{
			value : "Desc",
			name : "描述"
		}, {
			value : "Code",
			name : "代码"
		}
	]
	$("#LinkDisplayType").combobox({
		valueField:"value",
		textField:"name",
		data:json,
		onLoadSuccess:function(d){
			$("#LinkDisplayType").combobox('select',value);
		}
	});
}

//设置签名级别
function setSignLevel(value) {
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLIEUserTemplate",
			"Method":"GetSignLevelJson"
		},
		success: function(d){
			json = eval("["+d+"]");
			$("#SignLevel").combobox({
				valueField:"value",
				textField:"name",
				data:json,
				onSelect:function(record){
					if (record.name !== "")
					{
						if (record.name == "无"){
							if ($("#DisplayName").val() != "") return;
							setDisplayName("新建字符单元");
						}else{
							setDisplayName(record.name);
						}
					}
				},
				onLoadSuccess:function(d){
					$("#SignLevel").combobox('select',value);
				}
			});
		},
		error: function(d){
			alert("setSignLevel error");
		}
	});
}

//保存元素属性
function initSaveOnclick()
{
	document.getElementById("propertySave").onclick = function(){
		var type = $("#Code").val().substring(0,1);
		//保存xml
		var strJson = {action:"UPDATE_ELEMENT",args:{"Path":currentPath,"Props":getElementPropty(type)}}
		cmdSyncExecute(strJson);
	};
}

///后台交互///////////////////////////////////////////////////////////////
//取标准字典数据
function getCodeSystemData(value) {
	jQuery.ajax({
		type : "GET",
		dataType : "text",
		url : "../EMRservice.Ajax.dictionary.cls",
		async : true,
		data : {
			"Action" : "getStdDic"
		},
		success : function (obj) {
			result = $.parseJSON(obj);
			setCodeSystem(value, result);
		},
		error : function (d) {
			alert("error");
		}
	});
}

//加载HIS绑定字段
function getDataBaseCatalog() {
	$('#dataBaseCategory').datagrid({
		height : '200px',
		headerCls:'panel-header-gray',
		bodyCls:'panel-header-gray', 
		url : '../EMRservice.Ajax.databind.cls',
		loadMsg : '数据装载中......',
		autoRowHeight : true,
		fitColumns : true,
		singleSelect : true,
		singleSelect : true,
		idField : 'ID',
		fit : true,
		columns : [[{
					field : 'ID',
					title : 'ID',
					width : 100,
					hidden : true
				}, {
					field : 'Name',
					title : '选择系统表',
					width : 100
				}, {
					field : 'ClassName',
					title : 'ClassName',
					width : 100,
					hidden : true
				}, {
					field : 'QueryName',
					title : 'QueryName',
					width : 100,
					hidden : true
				}, {
					field : 'Description',
					title : 'Description',
					width : 100,
					hidden : true
				}, {
					field : 'SingleResult',
					title : 'SingleResult',
					width : 100,
					hidden : true
				}
			]],
		onSelect : function (rowIndex, rowData) {
			var id = rowData.ID;
			getDataBaseDetial(id);
		},
		queryParams : {
			ACTION : 'DataBaseCatalog'
		},
		onLoadSuccess : function(d) {
			if (d.rows.length > 0) $("#dataBaseCategory").datagrid("selectRow",0);
		}
	});
}

function getDataBaseDetial(id) {
	$('#dataBaseDeital').datagrid({
		url : '../EMRservice.Ajax.databind.cls',
		loadMsg : '数据装载中......',
		autoRowHeight : true,
		headerCls:'panel-header-gray',
		bodyCls:'panel-header-gray',		
		fitColumns : true,
		singleSelect : true,
		singleSelect : true,
		idField : 'ID',
		fit : true,
		columns : [[{
					field : 'ID',
					title : 'ID',
					width : 100,
					hidden : true
				}, {
					field : 'Name',
					title : '选择字段',
					width : 100
				}, {
					field : 'FieldName',
					title : 'FieldName',
					width : 100,
					hidden : true
				}, {
					field : 'FieldType',
					title : 'FieldType',
					width : 100,
					hidden : true
				}, {
					field : 'Description',
					title : 'Description',
					width : 100,
					hidden : true
				}, {
					field : 'DicID',
					title : 'DicID',
					width : 100,
					hidden : true
				}

			]],
		queryParams : {
			ACTION : 'dataBaseDeital',
			pId : id
		}
	});
}

///加载绑定病历数据目录
function getDataEMRCatalog() {
	$('#dataEMRCategory').tree({
		url : '../EMRservice.Ajax.databind.cls?ACTION=DataEMRCategory',
		method : 'get',
		animate : true,
		lines : true,
		autoRowHeight : true,
		onSelect : function (node) {
			$('#dataEMRDeital').tree('reload');
			$('#valueType').combobox('clear');
			if (node.attributes == undefined) return;
			var type = node.attributes.type;
			var text = node.text;
			var id = node.id;
			//选中病历模板则获取模板xml
			if (type == "Template") {
				getXml(id);
			}
		}
		//折叠全部
		//onLoadSuccess:function(node, data) {$('#dataEMRCategory').tree('collapseAll');},
		//onLoadError: function(){ alert("EMRCatalogonLoadError");}
	});
}

function initSectionRelation() {
    $.ajax({
        type: 'GET',
        dataType: 'text',
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        cache: false,
        data: {
        		"OutputType":"String",
				"Class":"EMRservice.BL.BLIEUserTemplate",
				"Method":"GetSectionRelationS",
				"p1":model.id
        },
        success: function(ret) {
			SectionRelationArray = ret.split('^');
        },
        error: function(ret) {}
    });	
}

function initKBCateTree()
{
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLIEUserTemplate",
			"Method":"GetAllKBCategory"
		},
		success: function(d){
			if (d != "")
			{
				data = eval("("+d+")");
				initKBCateTreeFunc(data);
			}
		},
		error: function(d){
			alert("initKBCateTree error");
		}
	});
}

function initKBCateTreeFunc(data)
{
	$("#dataKBCategory").tree({
        data: data,
        dnd: true,
		lines:true,
		onDblClick:function()
		{
			var node = $("#dataKBCategory").tree('getSelected');
			if (node.nodetype != "KBData") return;
			initKBTree(node.id);
		}
	})
}

function initKBTree(knowledgeBaseID)
{
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLIEUserTemplate",
			"Method":"GetAllKBTreeByKBID",
			"p1":checkNewId(knowledgeBaseID)
		},
		success: function(d){
			if (d != "")
			{
				data = eval("("+d+")");
				initKBTreeFunc(data);
			}
		},
		error: function(d){
			alert("initKBTree error");
		}
	});
}

function initKBTreeFunc(data)
{
	$("#dataKBTree").tree({
        data: data,
        dnd: true,
		lines:true,
		onContextMenu: function (e, node) {
			$(this).tree('select', node.target);
			KBTreeMenu(e, node);
		}
	})
}

function KBTreeMenu(e,node)
{
	e.preventDefault();
	var node = $("#dataKBTree").tree('getSelected');
	
	$('#KBTreeMenu').menu('disableItem', $('#associKBTree')[0]);
	$('#KBTreeMenu').menu('disableItem', $('#insertKBTree')[0]);
	if (node.nodetype == "KBNodeData")
	{
		$('#KBTreeMenu').menu('enableItem', $('#associKBTree')[0]);
		$('#KBTreeMenu').menu('enableItem', $('#insertKBTree')[0]);
	} 
	$('#KBTreeMenu').menu('show', {
		left: e.pageX,
		top: e.pageY
	});
}

function initKBTreeMenu()
{
	///关联知识库
	document.getElementById("associKBTree").onclick = function(){
		associKBTree();
	}
	///插入知识库
	document.getElementById("insertKBTree").onclick = function(){
		insertKBTree();
	}
}

//关联知识库
function associKBTree()
{
	var node = $("#dataKBTree").tree('getSelected');
	if (plugin() == undefined)
	{
		top.$.messager.alert("提示","请打开模板",'info');
		return;
	}
	else
	{
		top.$.messager.confirm("关联知识库", "关联知识库节点，章节内容会被关联知识库内容替换掉，请确认是否关联？", function (r) {
			if (r)
			{
				var strJson = {
					"action" : "APPEND_COMPOSITE_ADVANCED",
					"args" : {
						"params" : {
							"action" : "LOAD_COMPOSITE",
							"KBNodeID" : checkNewId(node.id),
							"bReferenceKBNode" : "True"					
						}
					}
				};
			    cmdDoExecute(strJson);
			}
		});
	}
}

//插入知识库
function insertKBTree()
{
	var node = $("#dataKBTree").tree('getSelected');
	if (plugin() == undefined)
	{
		top.$.messager.alert("提示","请打开模板",'info');
		return;
	}
	else
	{
		var strJson = {
			"action" : "APPEND_COMPOSITE",
			"args" : {
				"params" : {
					"action" : "LOAD_COMPOSITE",
					"KBNodeID" : checkNewId(node.id)
				}
			}
		};
	    cmdDoExecute(strJson);	
	}
}

//设置数据绑定的样式
function setdatabindPage()
{
	proptyHeight = $("#DataBase").height();
	var dataBaseCategoryHt = (proptyHeight-50)*0.48;
	var dataBaseDeitalHt = (proptyHeight-50)*0.52;
	$("#dataBaseCategoryHt").height(dataBaseCategoryHt+"px");
	$("#dataBaseDeitalHt").height(dataBaseDeitalHt+"px");
}