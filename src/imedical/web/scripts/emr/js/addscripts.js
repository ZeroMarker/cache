$(function(){
    initType();
    setData();
});

function initType()
{
	var data = GetTypeData();
	var cbox = $HUI.combobox("#type",{
		valueField:'Code',
		textField:'Desc',
		multiple:false,
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:data,
		onChange: function (newValue, oldValue) {   
			setTypeView(newValue);
　　    }  
	});	

}

function GetTypeData()
{
	var result = [];
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLQuestTypeScript",
			"Method":"GetScriptByType",
			"p1":questType
		},
		success: function(d) {
			if (d != "") result = eval("("+d+")");
		},
		error : function(d) { 
			alert("GetTypeData error");
		}
	});
	return result;
}

function setTypeView(type)
{
	$('#content').empty();
	if (type == "hideThis")
	{
		inithideThis();
	}
	else if(type == "selectShowHide")
	{
		initselectShowHide();
	}
	else if(type == "setLinkData")
	{
		initsetLinkData();
	}
	else if(type == "inputShowHide")
	{
		initinputShowHide();
	}
	$.parser.parse('#content');
}

function inithideThis()
{
	var content = '<span class="desc">性别 = </span><select id="sex" class="hisui-combobox" style="width:100px;" data-options="">';

    content = content + '<option value="man">男</option>'; 
    content = content + '<option value="female">女</option>'; 
    content = content + '</select>';
    content = content + '<span class="desc">时隐藏本题</span>';
    		
	var html = $('<div class="box"></div>');
	$(html).append(content);
	$('#content').append(html);
}

function sethideThis(obj)
{
	$('#sex').combobox('setValue',obj.CondValue);
}

function gethideThis()
{
	var sex = $("#sex").combobox("getText");
	var script = {"trigger":"load","Action":"hideThis","Condition":"Sex","CondValue":sex,"typeCode":"hideThis"};
	var obj = {"typeCode":"hideThis","typeDesc":"根据性别隐藏本题","script":script};
	return obj;
}

function initselectShowHide()
{
    var content = '<span class="desc">选择</span><select id="TriCondition" class="hisui-combobox" style="width:400px;" data-options="">';
    var list = parent.parent.$("#dataset").val().split("\n");
	for (i=0;i<list.length;i++)
	{
		if (list[i] != "")
		{
			var value = i;
			if ((list[i].split("|")[1] != undefined)&&(list[i].split("|")[1] != ""))
			{
				value = list[i].split("|")[1];
			}
			
			var desc = list[i].split("|")[0];
        	var code = value;
        	content = content + '<option value='+code+'>'+desc+'</option>';  
		}
	}
	content = content + '</select>';
	content = content + '<span class="desc">时</span>';
	
	
	var content = content + '<select id="Action" class="hisui-combobox" style="width:100px;" data-options="">';

    content = content + '<option value="hide">隐藏</option>'; 
    content = content + '<option value="show">显示</option>'; 
    content = content + '</select>';
    content = content + '<div style="margin-top:5px;"><span class="desc">题目</span>';
    
    var content = content + '<select id="question" class="hisui-combogrid" style="width:520px;" data-options="">';
    content = content + '</select></div>';		
	var html = $('<div class="box"></div>');
	$(html).append(content);
	$('#content').append(html);
	$.parser.parse('#content');
	
	var data = getQuestionData();
	$HUI.combogrid("#question",{
		idField:"QuestionID", 
		textField:"QuestionTitle", 
		fitColumns:true,
		pagination:false,
		multiple: true,
		panelWidth: 530,
		panelHeight: 220,
		data:data,
        columns:[[  
				{field:'QuestionID',title:'题号',width:50},
				{field:'QuestionTitle',title:'题目',width:300,sortable:true},
				{field:'QuestionType',title:'题型',width:100,sortable:true}
			]]
	});
	
}

function setselectShowHide(obj)
{
	$('#TriCondition').combobox('setValue',obj.TriCondition);
	$('#Action').combobox('setValue',obj.Action);
	var ids = GetQuestIDsNotDelete(obj.Value);
	var values = ids.split("^");
	$('#question').combogrid('setValues', values);
	
}

function getselectShowHide()
{
	var TriCondition = $("#TriCondition").combobox("getValue");
	var Action = $("#Action").combobox("getValue");
	var values = $("#question").combogrid("getValues");
	var Value = "";
	for (i=0;i<values.length;i++)
	{
		if (values[i] != "")
		{
			if (Value != "")
			{
				Value = Value + "^";
			}
			Value = Value + values[i];
		}
	}
	
	var script = {"trigger":"choose","TriCondition":TriCondition,"Action":Action,"Value":Value,"typeCode":"selectShowHide"};
	var obj = {"typeCode":"selectShowHide","typeDesc":"选中后显示隐藏其他题","script":script};
	return obj;
}

function getQuestionData()
{
	var result = [];
	jQuery.ajax({
			type : "POST", 
			dataType : "text",
			url : "../EMRservice.Ajax.QuestionData.cls",
			async : false,
			data : {
					"Action":"GetQuestionData",
					"MedHistoryType":medHistoryType
				},
			success : function(d) {
	           		if (d != "")
	           		{
		           		result = eval("("+d+")");
	           		}
			},
			error : function(d) { alert("getQuestionData error");}
		});
	return result;
}

function initsetLinkData()
{
	var col = parent.parent.parent.$("#addcol").val();
	if (col == "")
	{
		$.messager.alert("提示信息","此表格没有列属性，请先编辑表格列属性！");
		return;
	}
	var colObj = JSON.parse(col);
	var comboboxData = "";
	var allData = "";
	for (i=0;i<colObj.length;i++)
	{
		if (colObj[i] != "")
		{
			var desc = colObj[i].title;
        	var code = colObj[i].field;
        	allData = allData + '<option value='+code+'>'+desc+'</option>'; 
        	if (colObj[i].editor.type == "combobox")
        	{
        		var desc = colObj[i].title;
        		var code = colObj[i].field;
        		comboboxData = comboboxData + '<option value='+code+'>'+desc+'</option>';  
        	}
		}
	}
	var content = "";
	var content = '<div><span class="desc">条件下拉框</span><select id="conditon" class="hisui-combobox" style="width:225px;" data-options="">';
	content = content + comboboxData;
	content = content + '</select></div>';
	
	content = content + '<div class="row"><span class="desc">结果下拉框</span><select id="result" class="hisui-combobox" style="width:225px;" data-options="">';
	content = content + allData;
	content = content + '</select></div>';
	
	content = content + '<div class="row"><span class="desc">取值类名称</span><input id="class" class="textbox" style="width:220px;"></div>'
	content = content + '<div class="row"><span class="desc">取值方法名</span><input id="method" class="textbox" style="width:220px;"></div>'
	
	var html = $('<div class="box"></div>');
	$(html).append(content);
	$('#content').append(html);
}

function setsetLinkData(obj)
{
	$('#conditon').combobox('setValue',obj.TriField);
	$('#result').combobox('setValue',obj.LinkField);
	$("#class").val(obj.ClassName);
	$("#method").val(obj.MethodName);
}


function getsetLinkData()
{
	var TriField = $("#conditon").combobox("getValue");
	var LinkField = $("#result").combobox("getValue");
	var ClassName = $("#class").val();
	var MethodName = $("#method").val();
	
	var script = {"trigger":"datagridSelect","TriField":TriField,"LinkField":LinkField,"Action":"setLinkData","ClassName":ClassName,"MethodName":MethodName,"typeCode":"setLinkData"};
	var obj = {"typeCode":"setLinkData","typeDesc":"下拉框选择级联","script":script};
	return obj;
}

function initinputShowHide()
{
	var content = '<span class="desc">输入值</span><select id="TriCondition" class="hisui-combobox" name="newcombobox" style="width:100px;" data-options="">';
    content = content + '<option value="high">大于</option>';
    content = content + '<option value="equal">等于</option>';  
    content = content + '<option value="low">小于</option>'; 
	content = content + '</select>';
	content = content + '<span class="desc"><input id="TriValue" class="hisui-numberbox textbox" type="text" style="width:270px;"></span>';
	content = content + '<span class="desc">时</span>';
	
	
	var content = content + '<select id="Action" class="hisui-combobox" style="width:100px;" data-options="">';

    content = content + '<option value="hide">隐藏</option>'; 
    content = content + '<option value="show">显示</option>'; 
    content = content + '</select>';
    content = content + '<div style="margin-top:5px;"><span class="desc">题目</span>';
    
    var content = content + '<select id="question" class="hisui-combogrid" style="width:520px;" data-options="">';
    content = content + '</select></div>';		
	var html = $('<div class="box"></div>');
	$(html).append(content);
	$('#content').append(html);
	$.parser.parse('#content');
	
	var data = getQuestionData();
	$HUI.combogrid("#question",{
		idField:"QuestionID", 
		textField:"QuestionTitle", 
		fitColumns:true,
		pagination:false,
		multiple: true,
		panelWidth: 530,
		panelHeight: 220,
		data:data,
        columns:[[  
				{field:'QuestionID',title:'题号',width:50},
				{field:'QuestionTitle',title:'题目',width:300,sortable:true},
				{field:'QuestionType',title:'题型',width:100,sortable:true}
			]]
	});
}

function setinputShowHide(obj)
{
	$('#TriCondition').combobox('setValue',obj.TriCondition);
	$("#TriValue").val(obj.TriValue);
	$('#Action').combobox('setValue',obj.Action);
	var values = obj.Value.split("^");
	$('#question').combogrid('setValues', values);
}

function getinputShowHide()
{
	var TriCondition = $("#TriCondition").combobox("getValue");
	var TriValue = $("#TriValue").val();
	var Action = $("#Action").combobox("getValue");
	var values = $("#question").combogrid("getValues");
	var Value = "";
	for (i=0;i<values.length;i++)
	{
		if (values[i] != "")
		{
			if (Value != "")
			{
				Value = Value + "^";
			}
			Value = Value + values[i];
		}
	}
	
	var script = {"trigger":"number","TriCondition":TriCondition,"TriValue":TriValue,"Action":Action,"Value":Value,"typeCode":"inputShowHide"};
	var obj = {"typeCode":"inputShowHide","typeDesc":"输入后显示隐藏其他题","script":script};
	return obj;
}

function getData(type)
{
	var result = {};
	if (type == "hideThis")
	{
		result = gethideThis();
	}
	else if(type == "selectShowHide")
	{
		result = getselectShowHide();
	}
	else if(type == "setLinkData")
	{
		result = getsetLinkData();
	}
	else if(type == "inputShowHide")
	{
		result = getinputShowHide();
	}
	result = JSON.stringify(result);
	return result;
}

function setData()
{
	if (scriptType == "") return;
	$('#type').combobox('setValue',scriptType);
	if (script == "") return;
	var obj = JSON.parse(script);
	if (scriptType == "hideThis")
	{
		sethideThis(obj);
	}
	else if(scriptType == "selectShowHide")
	{
		setselectShowHide(obj);
	}
	else if(scriptType == "setLinkData")
	{
		setsetLinkData(obj);
	}
	else if(scriptType == "inputShowHide")
	{
		setinputShowHide(obj);
	}
}

function confirm()
{
 	var type = $("#type").combobox("getValue");
 	var result = getData(type);
 	return result;
}

function GetQuestIDsNotDelete(questIDs)
{
	var result = [];
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLQuestionData",
			"Method":"GetQuestIDsNotDelete",
			"p1":questIDs
		},
		success: function(d) {
			if (d != "") result = d;
		},
		error : function(d) { 
			alert("GetQuestIDsNotDelete error");
		}
	});
	return result;
}