$(function () {
	init();
    //保存
	$('#confirm').click(function () {
		var items = [];
		for(var i=0;i<SectionRelationArray.length;i++)
		{
		    items.push({
		        "SectionCode" : SectionRelationArray[i].split(':')[0],
		        "SectionStatus" : SectionRelationArray[i].split(':')[1]
		    });
		}
        var strJson = {
			"action" : "SAVE_SECTION",
			"args" : {
				"Items" : items,
				"params" : {
					"ExampleInstanceID" : model.id,
					"action" : "SAVE_PERSONAL_SECTION"
				}
			}
		};
		cmdDoExecute(strJson);
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
});

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

///方法////////////////////////////////////////////////////////////////////////////////////////
function init() {
	var objString = "<object id='plugin' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'></object>";
	$('#divPlugin').append(objString);
	pluginAdd();
	plugin().initWindow("iEditor");
	//建立数据连接
	setConnect();
	//设置工作环境  "Template"     Single
	cmdDoExecute({
		"action" : "SET_WORKSPACE_CONTEXT",
		"args" : "Template"
	});
	//设置设计状态
	cmdDoExecute({
		action : "SET_NOTE_STATE",
		args : "Edit"
	});

	//初始化章节继承关系
	initSectionRelation();
	//加载个人模板
	loadPersonalTemplate();
	//获取绑定HIS数据目录
	getDataBaseCatalog();
	//获取绑定病历数据目录
	getDataEMRCatalog();
	setFontData();
	setFontSizeData();
	getDocOutline();
	var modelInfo = model.attributes.documentType;
	if ('DOC'!==modelInfo) {
		cmdDoExecute({
			"action" : "SET_WORKSPACE_CONTEXT",
			"args" : "Single"
		});
	}
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
			"Method":"GetNetConnectJson"
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
	return cmdSyncExecute({
		action:"SET_NET_CONNECT",
		args:netConnect
	});
}

//加载个人模板
function loadPersonalTemplate() {
    var strJson = {
        "action" : "LOAD_DOCUMENT",
        "args" : {
            "params" : {
                "action" : "LOAD_PERSONAL_TEMPLATE",
                "ExampleInstanceID" : model.id
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
			setMaxElementObj(dataList[i].Code);
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
	}
}

//获取元素代码
function getNewCode(code) {
	code = code + 1;
	code = code.toString();
	var count = 3 - code.length;
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
	return;
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
	for (var i = 0; i < json.length; i++) {
		$('#font').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
	}
	//设置默认显示项
	if ($.browser.version == '6.0') {
		setTimeout(function () {
			$('#font').find('option[value="宋体"]').attr("selected", true);
		}, 1);
	} else {
		$('#font').find('option[value="宋体"]').attr("selected", true);
	}
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
	for (var i = 0; i < json.length; i++) {
		$('#fontSize').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
	}
	//设置默认显示项
	if ($.browser.version == '6.0') {
		setTimeout(function () {
			$('#fontSize').find('option[value="10.5pt"]').attr("selected", true);
		}, 1);
	} else {
		$('#fontSize').find('option[value="10.5pt"]').attr("selected", true);
	}
	document.getElementById('fontSizeText').value = "10.5";
}

//字号改变
function changeFontSize() {
	document.getElementById('fontSizeText').value = document.getElementById('fontSize').options[document.getElementById('fontSize').selectedIndex].text;
}

//输入字号
function changeFontSizeText() {
	if (event.keyCode == 13) {
		var strJson = {
			action : "FONT_SIZE",
			args : document.getElementById('fontSizeText').value
		};
		cmdDoExecute(strJson);
		document.getElementById('fontSize').value = "";
	}
}

//字体
$("#font").change(function () {
	var strJson = {
		action : "FONT_FAMILY",
		args : $("#font").find("option:selected").text()
	};
	cmdDoExecute(strJson);
});

//字号
$("#fontSize").change(function () {
	var strJson = {
		action : "FONT_SIZE",
		args : $("#fontSize").find("option:selected").val()
	};
	cmdDoExecute(strJson);
});

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

///事件监听///////////////////////////////////////////////////////////////////////////////
//获得模板元素结构
function eventGetDocumentOutline(commandJson) {
	if (0 == commandJson.args.Instances.length)
		return;

	var json = commandJson.args.Instances[0].Sections;
	if (0 == json.length)
		return;
	var treeJson = new Array();

	convertToTreeJson(json, treeJson, "");
	$('#elementTree').tree({
		data : treeJson,
		onClick : function (node) {
			focusElement(node.id);
		},
		onContextMenu : function (e, node) {
			e.preventDefault();
			$(this).tree('select', node.target);
			$('#mm').menu('show', {
				left : e.pageX,
				top : e.pageY
			});
		}
	})
}

//获得模板元素结构
function eventGetMetaDataTree(commandJson) {
	var json = commandJson.args.items;
	var treeJson = new Array();
	convertToTreeJson(json, treeJson, "");
	$('#elementTree').tree({
		data : treeJson,
		onClick : function (node) {
			focusElement(node.id);
		}
	})
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
		loadStructTree();
		setProperty();
	}
}

//编辑器上下文感知功能
function eventCaretContext(commandJson) {
	//判断当前字体
	if (typeof(commandJson.args.FONT_FAMILY) == "undefined") {
		document.getElementById('font').value = "";
	} else {
		$('#font').attr("value", commandJson.args.FONT_FAMILY);
	}
	//判断当前字号
	document.getElementById('fontSize').value = "";
	if (typeof(commandJson.args.FONT_SIZE) == "undefined") {
		document.getElementById('fontSizeText').value = "";
	} else {
		document.getElementById('fontSizeText').value = isExistOption(commandJson.args.FONT_SIZE);
	}
}

function isExistOption(value) {
	var count = $('#fontSize').find('option').length;
	for (var i = 0; i < count; i++) {
		if ($('#fontSize').get(0).options[i].value == value) {
			document.getElementById('fontSize').value = value;
			value = $('#fontSize').get(0).options[i].text;
			break;
		}
	}
	return value;
}

//修改元素监听
function eventUpdateElement(commandJson) {
	if (commandJson.args.result == "OK") {
		loadStructTree();
	}
}

//加载个人模板
function eventLoadDocument(commandJson) {
	if (commandJson.args.result == "ERROR") {
		alert('加载失败！');
	}

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
}

//章节改变事件
function eventSectionChanged(commandJson) {
	setSection(commandJson.args.Code);
}

//保存个人模板
function eventSaveSection(commandJson) {
	if (commandJson.args.result == "OK") {
		alert('保存成功');
	} else {
		alert('保存失败');
	}
}

///属性设置/////////////////////////////////////////////////////////////////////////////
///设置章节属性
function setSection(Code) {
	var strPropty = '<div style="margin:5px"><span>章节编码</span>&nbsp;&nbsp;&nbsp;<span><span><input id="SectionCode" type="text" disabled="true" style="width:160px;"></input></span></div>'
		 + '<div style="margin:5px"><span>章节名称</span>&nbsp;&nbsp;&nbsp;<span><input id="SectionName" type="text" disabled="true" style="width:160px;"></input></span></div>'
		 +'<div style="margin:5px"><span>继&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;承:</span>&nbsp;&nbsp;<span><select id="SectionStatus" name="SectionStatus" style="width:160px;" onchange="selectStatus();"></select></span></div>'

	$("#section")[0].innerHTML = strPropty; 
	$('#SectionStatus').append("<option value='REFERENCE'>是</option>");
	$('#SectionStatus').append("<option value='REPLACE'>否</option>");
	$("#SectionCode").val(Code);
	
	if (Code=="Header")
	{
		$("#SectionStatus").attr("disabled",true);
		$("#SectionName").val("页眉");
		$("#SectionStatus option[value='REFERENCE']").attr("selected", true);
	}
	else if(Code=="Footer")
	{
		$("#SectionStatus").attr("disabled",true);
		$("#SectionName").val("页脚");
		$("#SectionStatus option[value='REFERENCE']").attr("selected", true);
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
				$("#SectionStatus option[value='" + status + "']").attr("selected", true);
			}
		}
	}
}

///根据章节继承属性设置只读
function selectStatus() {
	var isReadonly;
	var code = document.getElementById("SectionCode").value;
	var status = document.getElementById("SectionStatus").value;
	var name = document.getElementById("SectionName").value;
	if (status == "REFERENCE"){
		$.messager.confirm("警示", "继承属性由【否】改为【是】，修改的章节内容会丢失，请再次确认是否修改？", function (r) {
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
	var strJson = {
		"action" : "GET_ELEMENT_CONTEXT",
		"args" : {
			"Type" : "MIElement"
		}
	}
	var elementContext = cmdSyncExecute(strJson);
	if ((''===elementContext)||('NONE'==elementContext)) return;
	elementContext = $.parseJSON(elementContext);
	var type = elementContext.Props.ElemType;
	currentPath = elementContext.Path;
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
	}
}

//初始化元素基本属性
function initBasePropty() {
	var strPropty =
		'<div style="margin:5px">' + initTabIndex() +'<br/>'+ initVisible() + initReadOnly() + initFixedStructs() +'<br/>'+ initAllowNull()+ initSynch() +  '</div>'
		 + '<div style="margin:5px">' + initCode() + '</div>'
		 + '<div style="margin:5px">' + initDisplayName() + '</div>'
		 + '<div style="margin:5px">' + initDescription() + '</div>'
		 + '<div style="margin:5px">' + initDataBind() + '</div>'
		 + '<div style="margin:5px">' + initValidateMsg() + '</div>'
		 + '<div style="margin:5px">' + initConfidentiality() + '</div>'
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
	setValidateMsg(obj.Props.ValidateMsg);
	setConfidentiality(obj.Props.ConfidentialityCode);
	setFixedStructs(obj.Props.FixedStructs);
}

function getBasePropty() {
	var obj = {};
	obj.TabIndex = $("#TabIndex").val();
	obj.Visible = $("#Visible")[0].status;
	obj.AllowNull = $("#AllowNull")[0].status;
	obj.ReadOnly = $("#ReadOnly")[0].status;
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
function setMIString(obj) {
	if (!obj || obj == "")
		return;
	var strPropty = initBasePropty()
		 + '<div style="margin:5px">' + initRegExp() + '</div>'
		 + '<div style="margin:5px">' + initMaxLength() + '</div>'
		 + '<div style="margin:5px">' + initSave() + '</div>'

		$("#property")[0].innerHTML = strPropty;
	$.parser.parse('#property');
	setBasePropty(obj);
	setRegExp(obj.Props.RegExp);
	setMaxLength(obj.Props.MaxLength);
	initSaveOnclick();
}

//设置数字单元
function setMINumber(obj) {
	if (!obj || obj == "")
		return;
	var strPropty = initBasePropty()
		 + '<div style="margin:5px">' + initHasMinVal() + initMinVal() + initIncludeMax() + '</div>'
		 + '<div style="margin:5px">' + initHasMaxVal() + initMaxVal() + initIncludeMin() + '</div>'
		 + '<div style="margin:5px">' + initDecimalPlace() + '</div>'
		 + '<div style="margin:5px">' + initSave() + '</div>'

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
		 + '<div style="margin:5px">' + initChoices() + '</div>'
		 + '<div style="margin:5px">' + initSave() + '</div>'

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
		 + '<div style="margin:5px">' + initSeparator() + initWrapChoice() + '</div>'
		 + '<div style="margin:5px">' + initChoices() + '</div>'
		 + '<div style="margin:5px">' + initSave() + '</div>'

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
		 + '<div style="margin:5px">' + initIncludeDate() + initDateFormat() + '</div>'
		 + '<div style="margin:5px">' + initIncludeTime() + initTimeFormat() + '</div>'
		 + '<div style="margin:5px">' + initSave() + '</div>'

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
		 + '<div style="margin:5px">' + initDictionaryType() + '</div>'
		 + '<div style="margin:5px">' + initCodeSystem() + '</div>'
		 + '<div style="margin:5px">' + initCustDicClassName() + '</div>'
		 + '<div style="margin:5px">' + initDisplayType() + '</div>'
		 + '<div style="margin:5px">' + initSeparator() + '</div>'
		 + '<div style="margin:5px">' + initLinkCode() + '</div>'
		 + '<div style="margin:5px">' + initLinkMethod() + '</div>'
		 + '<div style="margin:5px">' + initLinkDisplayType() + '</div>'
		 + '<div style="margin:5px">' + initAllowCodeNull() + '</div>'
		 + '<div style="margin:5px">' + initAllowValueNull() + '</div>'
		 + '<div style="margin:5px">' + initAssociateItem() + '</div>'
		 + '<div style="margin:5px">' + initRegExp() + '</div>'
		 + '<div style="margin:5px">' + initMaxLength() + '</div>'
		 + '<div style="margin:5px">' + initSave() + '</div>'

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
	return obj;
}

//数字元素obj
function getMINumber() {
	var obj = getBasePropty();
	obj.ElemType = "MINumber";
	obj.HasMinVal = $("#HasMinVal")[0].status;
	obj.MinVal = $("#MinVal").val();
	obj.IncludeMin = $("#IncludeMin")[0].status;
	obj.HasMaxVal = $("#HasMaxVal")[0].status;
	obj.MaxVal = $("#MaxVal").val();
	obj.IncludeMax = $("#IncludeMax")[0].status;
	obj.DecimalPlace = $("#DecimalPlace")[0].status;
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
	obj.WrapChoice = $("#WrapChoice")[0].status;
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
	obj.IncludeDate = $("#IncludeDate")[0].status;
	obj.IncludeTime = $("#IncludeTime")[0].status;
	obj.DateFormat = $("#DateFormat").find("option:selected").text();
	obj.TimeFormat = $("#TimeFormat").find("option:selected").text();
	return obj;
}

//字典单元
function getMIDictionary() {
	var obj = getBasePropty();
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
	}
	return obj;
}

//简单元素编码
function initCode() {
	var str = '<span>元素编码  </span>'
		 + '<span><input id="Code" type="text" disabled="true" style="width:160px;"></input></span>'
		return str;
}

//简单元素描述
function initDisplayName() {
	var str = '<span>元素描述  </span>'
		 + '<span><textarea id="DisplayName" rows="2" cols="20" style="width:160px;"></textarea></span>'
		return str;
}

//简单元素含义描述
function initDescription() {
	var str = '<span>含义描述  </span>'
		 + '<span><textarea id="Description" rows="2" cols="20" style="width:160px;"></textarea></span>'
		return str;
}

//数据绑定
function initDataBind() {
	var str = '<span>数据绑定  </span>'
		 + '<span><input id="BindCode" type="text" disabled="true" style="width:132px;"></input></span>'
		 + '<span><input id="BindType" type="text" style="display:none;"></input></span>'
		 + '<span><input id="clearBind" type="button" value="-"></input></span>'
		return str;
}

//同步
function initSynch() {
	var str = '<span><input id="Synch" type="checkbox" name="Synch">同步</input></span>'
		return str;
}

//不为空
function initAllowNull() {
	var str = '<span><input id="AllowNull" type="checkbox" name="AllowNull">不为空</input></span>'
		return str;
}

//校验消息
function initValidateMsg() {
	var str = '<span>校验消息  </span>'
		 + '<span><input id="ValidateMsg" type="text" style="width:160px;"></input></span>'
		return str;
}

//正则表达式
function initRegExp() {
	var str = '<span>正则表达式  </span>'
		 + '<span><input id="RegExp" type="text" style="width:146px;"></input></span>'
		return str;
}

//顺序号
function initTabIndex() {
	var str = '<span>TabIndex  </span>'
		 + '<span><input id="TabIndex" type="text" style="width:154px;"></input></span>'
		return str;
}

//不可见
function initVisible() {
	var str = '<span><input id="Visible" type="checkbox" name="Visible">不可见</input></span>'
		return str;
}

//只读
function initReadOnly() {
	var str = '<span><input id="ReadOnly" type="checkbox" name="ReadOnly">只读</input></span>'
		return str;
}

//机密级别
function initConfidentiality() {
	var str = '<span>保密级别  </span>'
		 + '<span><select id="ConfidentialityCode" name="ConfidentialityCode" style="width:160px;"></select></span>'
		return str;
}

//固定结构
function initFixedStructs() {
	var str = '<span><input id="FixedStructs" type="checkbox" name="FixedStructs">固定结构</input></span>'
		return str;
}

//最大长度(MIString)
function initMaxLength() {
	var str = '<span>最大长度  </span>'
		 + '<span><input id="MaxLength" type="text" style="width:160px;"></input></span>'
		return str;
}

//最小值
function initMinVal() {
	var str = '<span>最小值</span>'
		 + '<span><input id="MinVal" type="text" style="width:40px;"></input></span>'
		return str;
}

//最大值
function initMaxVal() {
	var str = '<span>最大值</span>'
		 + '<span><input id="MaxVal" type="text" style="width:40px;"></input></span>'
		return str;

}

//设置最小值
function initHasMinVal() {
	var str = '<span><input id="HasMinVal" type="checkbox" name="HasMinVal"></input></span>'
		return str;
}

//设置最大值
function initHasMaxVal() {
	var str = '<span><input id="HasMaxVal" type="checkbox" name="HasMaxVal"></input></span>'
		return str;
}

//是否是小于等于
function initIncludeMin() {
	var str = '<span><input id="IncludeMin" type="checkbox" name="IncludeMin">是否小于等于</input></span>'
		return str;
}

//是否是大于等于
function initIncludeMax() {
	var str = '<span><input id="IncludeMax" type="checkbox" name="IncludeMax">是否大于等于</input></span>'
		return str;
}

//小数点位数
function initDecimalPlace() {
	var str = '<span>小数位数</span>'
		 + '<span><input id="DecimalPlace" type="text" style="width:50px;"></input></span>'
		return str;
}

//备选项集合
function initChoices() {
	var str = '<span>在集合中输入备选项(每行一个值|ID)</span>'
		 + '<span><textarea id="Choices" rows="6" cols="60" style="width:220px;"></textarea></span>'
		return str;
}

//分隔符
function initSeparator() {
	var str = '<span>分隔符</span>'
		 + '<span><input id="Separator" type="text" style="width:178px;"></input></span>'
		return str;
}

//备选项强制换行
function initWrapChoice() {
	var str = '<span><input id="WrapChoice" type="checkbox" name="WrapChoice">强制换行</input></span>'
		return str;
}

//包含日期
function initIncludeDate() {
	var str = '<span><input id="IncludeDate" type="checkbox" name="IncludeDate">日期</input></span>'
		return str;
}

//包含时间
function initIncludeTime() {
	var str = '<span><input id="IncludeTime" type="checkbox" name="IncludeTime">时间</input></span>'
		return str;
}

//日期格式
function initDateFormat() {
	var str = '<span style="padding-left:5px">日期格式</span>'
		 + '<span><select id="DateFormat" name="DateFormat" style="width:110px;"></select></span>'
		return str;
}

//时间格式
function initTimeFormat() {
	var str = '<span style="padding-left:5px">时间格式</span>'
		 + '<span"><select id="TimeFormat" name="TimeFormat" style="width:110px;"></select></span>'
		return str;
}

//字典类型
function initDictionaryType() {
	var str = '<span>字典类型  </span>'
		 + '<span><select id="DictionaryType" name="DictionaryType" style="width:160px;"></select></span>'
		return str;
}

//标准字典名称
function initCodeSystem() {
	var str = '<span>标准字典  </span>'
		 + '<span><select id="CodeSystem" name="CodeSystem" style="width:160px;"></select></span>'
		return str;
}

//自定义字典名称
function initCustDicClassName() {
	var str = '<span>自定义字典  </span>'
		 + '<span><input id="CustDicClassName" type="text" style="width:146px;"></input></span>'
		return str;
}

//字典显示类型
function initDisplayType() {
	var str = '<span>显示类型  </span>'
		 + '<span><select id="DisplayType" name="DisplayType" style="width:160px;"></select></span>'
		return str;
}

//关联的结构化单元
function initLinkCode() {
	var str = '<span>关联Code  </span>'
		 + '<span><input id="LinkCode" type="text" style="width:153px;"></input></span>'
		return str;
}

//链接方式：Append/Replace/Prefix
function initLinkMethod() {
	var str = '<span>链接方式  </span>'
		 + '<span><select id="LinkMethod" name="DisplayType" style="width:160px;"></select></span>'
		return str;
}

//允许使用非标准字典代码
function initAllowCodeNull() {
	var str = '<span><input id="AllowCodeNull" type="checkbox" name="IncludeDate">允许使用非标准字典代码</input></span>'
		return str;
}

//允许使用非标准字典描述
function initAllowValueNull() {
	var str = '<span><input id="IncludeDate" type="checkbox" name="IncludeDate">允许使用非标准字典描述</input></span>'
		return str;
}

//查询条件单元
function initAssociateItem() {
	var str = '<span>查询条件单元</span>'
		 + '<span><input id="AssociateItem" type="text" style="width:220px;"></input></span>'
		return str;
}

//关联元素显示类型
function initLinkDisplayType() {
	var str = '<span>关联元素显示类型</span>'
		 + '<span><select id="LinkDisplayType" name="LinkDisplayType" style="width:108px;"></select></span>'
		return str;
}

//保存
function initSave() {
	var str ='<a href="#" id="propertySave" class="hisui-linkbutton" style="float:right">保存</a>'
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
		$("#Synch").attr("checked", true);
	} else {
		$("#Synch").attr("checked", false);
	}
}

//不为空
function setAllowNull(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#AllowNull").attr("checked", true);
	} else {
		$("#AllowNull").attr("checked", false);
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
		$("#Visible").attr("checked", true);
	} else {
		$("#Visible").attr("checked", false);
	}
}

//只读
function setReadOnly(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#ReadOnly").attr("checked", true);
	} else {
		$("#ReadOnly").attr("checked", false);
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
	]
	for (var i = 0; i < json.length; i++) {
		$('#ConfidentialityCode').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		if (json[i].value == value) {
			$("#ConfidentialityCode").val(value);
		}
	}
}

//固定结构
function setFixedStructs(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#FixedStructs").attr("checked", true);
	} else {
		$("#FixedStructs").attr("checked", false);
	}
}

//最大长度 (MIString)
function setMaxLength(value) {
	$("#MaxLength").val(value);
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
		$("#HasMinVal").attr("checked", true);
	} else {
		$("#HasMinVal").attr("checked", false);
		$("#MinVal").attr("disabled", true);
		$("#IncludeMin").attr("disabled", true);
	}
}

//设置最大值
function setHasMaxVal(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#HasMaxVal").attr("checked", true);
	} else {
		$("#HasMaxVal").attr("checked", false);
		$("#MaxVal").attr("disabled", true);
		$("#IncludeMin").attr("disabled", true);
	}
}

//是否是小于等于
function setIncludeMin(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#IncludeMin").attr("checked", true);
	} else {
		$("#IncludeMin").attr("checked", false);
	}
}

//是否是大于等于
function setIncludeMax(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#IncludeMax").attr("checked", true);
	} else {
		$("#IncludeMax").attr("checked", false);
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
		$("#WrapChoice").attr("checked", true);
	} else {
		$("#WrapChoice").attr("checked", false);
	}
}

//包含日期
function setIncludeDate(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#IncludeDate").attr("checked", true);
	} else {
		$("#IncludeDate").attr("checked", false);
		$("#DateFormat").attr("disabled", true);
	}
}

//包含日期
function setIncludeTime(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#IncludeTime").attr("checked", true);
	} else {
		$("#IncludeTime").attr("checked", false);
		$("#TimeFormat").attr("disabled", true);
	}
}

//日期格式
function setDateFormat(value) {
	var json = [{
			value : "1",
			name : "yyyy-MM-dd"
		}, {
			value : "2",
			name : "yyyy年MM月dd日"
		}
	]
	for (var i = 0; i < json.length; i++) {
		$('#DateFormat').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		if (json[i].name == value) {
			if ($.browser.version == '6.0') {
				setTimeout(function () {
					$("#DateFormat option[text='" + value + "']").attr("selected", true);
				}, 1);
			} else {
				$("#DateFormat option[text='" + value + "']").attr("selected", true);
			}
		}
	}
}

//时间显示格式
function setTimeFormat(value) {
	var json = [{
			value : "1",
			name : "HH:mm"
		}, {
			value : "2",
			name : "HH:mm:ss"
		}
	]
	for (var i = 0; i < json.length; i++) {
		$('#TimeFormat').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		if (json[i].name == value) {
			if ($.browser.version == '6.0') {
				setTimeout(function () {
					$("#TimeFormat option[text='" + value + "']").attr("selected", true);
				}, 1);
			} else {
				$("#TimeFormat option[text='" + value + "']").attr("selected", true);
			}
		}
	}
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
	for (var i = 0; i < json.length; i++) {
		$('#DictionaryType').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		if (json[i].value == value) {
			$("#DictionaryType").val(value);
		}
	}
}

//字典代码
function setCodeSystem(value, data) {
	for (var i = 0; i < data.length; i++) {
		$('#CodeSystem').append("<option value='" + data[i].Code + "'>" + data[i].Name + "</option>");
		if (data[i].Code == value) {
			$("#CodeSystem").val(value);
		}
	}
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
	for (var i = 0; i < json.length; i++) {
		$('#DisplayType').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		if (json[i].value == value) {
			$("#DisplayType").val(value);
		}
	}
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
	for (var i = 0; i < json.length; i++) {
		$('#LinkMethod').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		if (json[i].value == value) {
			$("#LinkMethod").val(value);
		}
	}
}

//允许使用非标准字典代码
function setAllowCodeNull(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#AllowCodeNull").attr("checked", true);
	} else {
		$("#AllowCodeNull").attr("checked", false);
	}
}

//允许使用非标准字典描述
function setAllowValueNull(value) {
	if (value.toUpperCase() == "TRUE") {
		$("#AllowValueNull").attr("checked", true);
	} else {
		$("#AllowValueNull").attr("checked", false);
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
	for (var i = 0; i < json.length; i++) {
		$('#LinkDisplayType').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		if (json[i].value == value) {
			$("#LinkDisplayType").val(value);
		}
	}
}

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
		}
	});
}

function getDataBaseDetial(id) {
	$('#dataBaseDeital').datagrid({
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
				"Class":"EMRservice.BL.BLExampleInstanceSectionRelation",
				"Method":"GetSectionRelationS",
				"p1":model.id
        },
        success: function(ret) {
			SectionRelationArray = ret.split('^');
        },
        error: function(ret) {}
    });	
}