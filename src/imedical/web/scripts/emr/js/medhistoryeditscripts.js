$(function(){
	initScriptData();
    initHistory(); 
});

function initScriptData()
{
	$('#scriptData').datagrid({
	    headerCls:'panel-header-gray',
        loadMsg: '数据装载中......',
        autoRowHeight: true,
        rownumbers: true,
        pagination: false,
        singleSelect: true,
        idField: 'ID',
        fit: true,
        remoteSort: false,
        onBeforeSelect:function(rowIndex, rowData){
			 var selectCol = $("#scriptData").datagrid("getSelected");
			 var prevIndex = $("#scriptData").datagrid("getRowIndex",selectCol);
			 if (prevIndex == rowIndex)
			 {
				 return false;
			 }
			 else if(prevIndex != "-1")
			 {
				var curdata = getScriptData();
				$('#scriptData').datagrid('updateRow',{
				    index: prevIndex,
				    row: {
				        typeCode: curdata.typeCode,
				        typeDesc: curdata.typeDesc,
				        script: JSON.stringify(curdata.script)
				    }
				});
			 }
	    },
		onSelect:function(rowIndex, rowData){
			$("#framEdit").attr("src","emr.addscripts.csp?MedHistoryType="+medHistoryType +"&QuestType="+questType+"&ScriptType="+rowData.typeCode+"&Script="+rowData.script);
			
	    },
	    columns:[[  
				{field:'typeCode',title:'typeCode',width:80,hidden: true},
				{field:'typeDesc',title:'脚本类型',width:240,sortable:true},
				{field:'script',title:'脚本语句',width:400,sortable:true,hidden: true}
			]]
    });
}

function initHistory()
{
	var scriptData = parent.$("#addscipts").val();
	if (scriptData == "") return;
	var scriptObj = JSON.parse(scriptData);
	for(var i=0;i<scriptObj.length;i++)
	{
		var script = JSON.stringify(scriptObj[i]);
		var typeDesc = getTypeDesc(scriptObj[i].typeCode);
		
		$('#scriptData').datagrid('appendRow',{
		    typeCode: scriptObj[i].typeCode,
		    typeDesc: typeDesc,
		    script: script
		});
	}
}

function getTypeDesc(typeCode)
{
	var result = "";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLQuestTypeScript",
			"Method":"GetScriptDesc",
			"p1":typeCode
		},
		success: function(d) {
			if (d != "") result = d;
		},
		error : function(d) { 
			alert("getTypeDesc error");
		}
	});
	return result;
}

function AddScriptFunc()
{
	$('#scriptData').datagrid('appendRow',{
	    typeCode: "",
	    typeDesc: "",
	    script: ""
	});
	var length = $('#scriptData').datagrid('getRows').length;
	$('#scriptData').datagrid('selectRow',length-1);
}

function Save()
{
	var selectRow = $("#scriptData").datagrid("getSelected");
	if (selectRow != null)
	{
		var editIndex = $('#scriptData').datagrid('getRowIndex',selectRow);
		var curdata = getScriptData();
		$('#scriptData').datagrid('updateRow',{
		    index: editIndex,
		    row: {
		        typeCode: curdata.typeCode,
		        typeDesc: curdata.typeDesc,
		        script: JSON.stringify(curdata.script)
		    }
		});
	}
	var Scripts = new Array();
    var rows = $("#scriptData").datagrid("getRows");
	for(var i=0;i<rows.length;i++)
	{
		if (rows[i].script != "")
		{
			var script = eval("("+rows[i].script+")");
			Scripts.push(script);
		}
        
	}
	
	var result = JSON.stringify(Scripts);
	window.returnValue = result;
	closeWindow();
}

function DeleteScript()
{
	var selectScript = $("#scriptData").datagrid("getSelected");
	if (selectScript != null)
	{
		var curIndex = $("#scriptData").datagrid("getRowIndex",selectScript);
		$("#scriptData").datagrid("deleteRow",curIndex);
		document.getElementById("framEdit").contentWindow.$('#addColLayout').empty();
	}
	else
	{
		$.messager.alert("提示信息","请先选中表格数据！");
	}
}

function getScriptData()
{
	var result = document.getElementById("framEdit").contentWindow.confirm();
	return eval("("+result+")");
}

//关闭窗口
function closeWindow()
{
	parent.closeDialog("EditSciptsDialog");	
}