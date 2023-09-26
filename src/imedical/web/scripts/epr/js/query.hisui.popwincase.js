$(function(){
	InitCTLocGrid();
	InitCTLocCRGrid();
	InitGroupGrid();
	InitGroupCRGrid();
	
	if (saveType == "modify")
	{
		getSurrCaseInfo();
	}
	
	$("#btCTLocAdd").click(function(){
		addCTLoc();
	});
	$("#btCTLocDelete").click(function(){
		deleteCTLoc();
	});
	
	$("#btGroupAdd").click(function(){
		addGroup();
	});
	$("#btGroupDelete").click(function(){
		deleteGroup();
	});
	
	$("#btSave").click(function(){
		saveQueryCase();
	});	
	$("#btCancel").click(function(){
		closeWindow();
		window.returnValue = "";
	});	
});﻿

function InitCTLocGrid()
{
	$('#CTLocGrid').datagrid({
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		url: '../web.eprajax.hisinterface.hospitalinfo.cls?Action=getLocs&frameType=HISUI',
		idField:'ID', 
		singleSelect:true,
		fitColumns: true,
		fit:true,
		columns:[[  
			{field:'ID',title:'ID',hidden:true},
	    	{field:'Name',title:'待选科室',width:95}
		]]
	});
}

function InitCTLocCRGrid()
{
	$('#CTLocCRGrid').datagrid({
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		url: '../web.eprajax.query.getquerycase.cls',
		idField:'ID', 
		singleSelect:true,
		fitColumns: true,
		fit:true,
		columns:[[  
			{field:'ID',title:'ID',hidden:true},
	    	{field:'Name',title:'已选科室',width:95}
		]]
	});
}

function InitGroupGrid()
{
	$('#GroupGrid').datagrid({
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		url: '../web.eprajax.query.getquerycase.cls?action=getAllSSGroup&frameType=HISUI',
		idField:'ID', 
		singleSelect:true,
		fitColumns: true,
		fit:true,
		columns:[[  
			{field:'ID',title:'ID',hidden:true},
	    	{field:'Desc',title:'待选安全组',width:95}
		]]
	});
}

function InitGroupCRGrid()
{
	$('#GroupCRGrid').datagrid({
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		url: '../web.eprajax.query.getquerycase.cls',
		idField:'ID', 
		singleSelect:true,
		fitColumns: true,
		fit:true,
		columns:[[  
			{field:'ID',title:'ID',hidden:true},
	    	{field:'Desc',title:'已选安全组',width:95}
		]]
	});
}

function addCTLoc()
{
	var selection = $('#CTLocGrid').datagrid('getSelected');
	if (selection !== null)
	{
		var ID = selection.ID;
		var Name = selection.Name;
		var existed = false;
		var existedRows = $('#CTLocCRGrid').datagrid('getRows');
		for (var j = 0;j<existedRows.length;j++ )
		{
			var existedID = existedRows[j].ID;
			if (existedID == ID)
			{
				existed = true;
				$.messager.alert("提示信息", Name + "已存在！","alert");
				break;
			}
		}
		if (existed == false)
		{
			$('#CTLocCRGrid').datagrid('insertRow',{
				row: {
					ID: ID,
					Name: Name
				}
			});
		}
	}
	else
	{
		$.messager.alert("提示信息", "请选择要添加的科室!","alert");
		return;
	}
}

function deleteCTLoc()
{
	var selection = $('#CTLocCRGrid').datagrid('getSelected');
	if (selection !== null)
	{
		var rowIndex = $('#CTLocCRGrid').datagrid('getRowIndex',selection);
		$('#CTLocCRGrid').datagrid('deleteRow',rowIndex);
		
	}
	else
	{
		$.messager.alert("提示信息", "请选择要撤回的科室!","alert");
		return;
	}
}

function addGroup()
{
	var selection = $('#GroupGrid').datagrid('getSelected');
	if (selection !== null)
	{
		var ID = selection.ID;
		var Desc = selection.Desc;
		var existed = false;
		var existedRows = $('#GroupCRGrid').datagrid('getRows');
		for (var j = 0;j<existedRows.length;j++ )
		{
			var existedID = existedRows[j].ID;
			if (existedID == ID)
			{
				existed = true;
				$.messager.alert("提示信息", Desc + "已存在！" ,"alert");
				break;
			}
		}
		if (existed == false)
		{
			$('#GroupCRGrid').datagrid('insertRow',{
				row: {
					ID: ID,
					Desc: Desc
				}
			});
		}
	}
	else
	{
		$.messager.alert("提示信息", "请选择要添加的安全组!","alert");
		return;
	}
}

function deleteGroup()
{
	var selection = $('#GroupCRGrid').datagrid('getSelected');
	if (selection !== null)
	{
		var rowIndex = $('#GroupCRGrid').datagrid('getRowIndex',selection);
		$('#GroupCRGrid').datagrid('deleteRow',rowIndex);
		
	}
	else
	{
		$.messager.alert("提示信息", "请选择要撤回的安全组!","alert");
		return;
	}
}

function saveQueryCase()
{
	//取方案名称并检测方案名称是否合法 start
	var QueryCaseName = $('#caseName').val();
	if (QueryCaseName == '')
	{
		$.messager.alert("提示信息", "方案名称不能为空！","alert");
		return;
	}
	else if (QueryCaseName.indexOf("@") != -1 || QueryCaseName.indexOf("#") != -1 || QueryCaseName.indexOf("$") != -1 || QueryCaseName.indexOf("%") != -1 || QueryCaseName.indexOf("^") != -1 || QueryCaseName.indexOf("&") != -1 || QueryCaseName.indexOf("*") != -1 || QueryCaseName.indexOf(",") != -1 || QueryCaseName.indexOf("，") != -1 )
	{
		$.messager.alert("提示信息", "方案名称含有非法字符，请重新输入！","alert");
		return;
	}
	//取方案名称并检测方案名称是否合法 end
	
	//取查询条件 start
	var table = parent.$('#tblCondition');
	var length = parent.$("#tblCondition tr").length;
	var ConditionArr = new Array();
	for (var i = 0,j = 0; i < length ; i++,j++) {
		ConditionArr[j] = new Array();
		var ORCode = "",ORName = "", ItemCode = "",ItemName = "", OPCode = "", OPName = "", txtValue = "", checkboxCode = "";
		checkboxCode = parent.$("#checkbox" + i).checkbox('getValue');
		if (checkboxCode == true)
		{
			//获取关系
			if (i == 0)
			{
				ORCode = parent.document.getElementById("relation" + i).getAttribute("code");
				ORName = "";
			}
			else if(i == 1)
			{
				ORCode = parent.document.getElementById("relation" + i).getAttribute("code");
				ORName = parent.document.getElementById("relation" + i).innerText;
			}
			else
			{
				ORCode = parent.$("#relation" + i).combobox("getValue");
				ORName = parent.$("#relation" + i).combobox("getText");
			}
    		
    		//获取项目、大小操作
			if (i < 2)
			{
				var itemCode0 = parent.$("#name" + i).combobox("getValue");
				//ItemCode = itemCode0.substring(2);
				ItemCode = itemCode0
				var ItemName = parent.$("#name" + i).combobox("getText");
				
				OPCode = parent.document.getElementById("op" + i).getAttribute("code");
				OPName = parent.document.getElementById("op" + i).innerText;
				
				
			}
			else
			{
				ItemCode = parent.document.getElementById("name" + i).getAttribute("code");
				ItemName = parent.document.getElementById("name" + i).innerText;
				
				OPCode = parent.$("#op" + i).combobox("getValue");
    			OPName = parent.$("#op" + i).combobox("getText");
			}
			//取查询条件值
			var valType = ItemCode.split("^")[3];
			if (ItemCode.split("^")[4] != "1")
			{
				valType = "select";
			}
			
			if (valType == "date")
			{
				txtValue = parent.$("#txtValue" + i).datebox('getValue');
			}
			else if (valType == "time")
			{
				txtValue = parent.$("#txtValue" + i).timespinner("getValue");
			}
			else if (valType == "select")
			{
				txtValue = parent.$("#txtValue" + i).combogrid("getValue");
			}
			else
			{
				txtValue = parent.$("#txtValue" + i).val();
			}
			
			if ((txtValue.indexOf(",") != -1) || (txtValue.indexOf("，") != -1 ))
			{
				$.messager.alert("提示信息", "查询条件 " + ItemName + " 中不能含有逗号！" ,"alert");
				return;
			}
			
		}
		ConditionArr[j][0] = ORCode;
		ConditionArr[j][1] = ItemCode;
		ConditionArr[j][2] = ItemName;
		ConditionArr[j][3] = OPCode;
		ConditionArr[j][4] = txtValue;
	}
	var dataCondition = escape(ConditionArr);
	//取查询条件 end
	
	//取结果列 start
	var arrInput = parent.$("#divResultCols").find("input:checked");
	var k = 0;
	var ResultColsArr = new Array();
	$.each(arrInput,function(index,item)
	{
		var ResultColsID = item.id;
		var ResultColsCode = item.value;
		var ResultColsName = parent.$("#" + item.id).attr("label");
		
		var ResultColsDisabled = "N";
		if (item.disabled == true)
		{
			ResultColsDisabled = "Y";
		}
		
		ResultColsArr[k] = new Array();
		ResultColsArr[k][0] = ResultColsDisabled;
		ResultColsArr[k][1] = ResultColsName;
		ResultColsArr[k][2] = ResultColsCode;
		k = k+1;
		 
	});
	var dataResultCols = escape(ResultColsArr);
	//取结果列 end
	
	//得到可见科室Code start
	var CTLocIDStr = '';
	var selectedRows = $('#CTLocCRGrid').datagrid('getRows');
	for (var t = 0;t<selectedRows.length;t++ )
	{
		var RowID = selectedRows[t].ID;
		if (CTLocIDStr == "")
		{
			CTLocIDStr = RowID;
		}
		else
		{
			CTLocIDStr = CTLocIDStr + '^' + RowID;
		}
	}
	//alert(CTLocIDStr);
	//得到可见科室Code end
	//得到可见安全组Code start
	var GroupIDStr = '';
	var selectedRows = $('#GroupCRGrid').datagrid('getRows');
	for (var p = 0;p<selectedRows.length;p++ )
	{
		var RowID = selectedRows[p].ID;
		if (GroupIDStr == "")
		{
			GroupIDStr = RowID;
		}
		else
		{
			GroupIDStr = GroupIDStr + '^' + RowID;
		}
	}
	//alert(GroupIDStr);
	//得到可见安全组Code end
	//保存方案 start
	//{
	if (saveType == 'save')
	{
		jQuery.ajax({
			type: "post",
			url: "../web.eprajax.query.savequerycase.cls",
			async: false,
			data: {
				action: 'SaveCase',
				SaveUserID: parent.userID,
				SaveUserName: parent.userName,
				CTLocIDStr: CTLocIDStr,
				GroupIDStr: GroupIDStr,
				QueryCaseName: QueryCaseName,
				ConditionArr: dataCondition, 
				ResultColsArr: dataResultCols
			},
			success: function(d) {
				if (d == -2)
				{
					$.messager.alert("提示信息", "名称已存在，请重新输入！","alert");
					return;
				}
				else if (d == -1)
				{
					$.messager.alert("提示信息", "保存失败！","alert");
					return;
				}
				else if (d > 0)
				{
					$.messager.alert("提示信息", "保存成功！","alert",function(){
						closeWindow();
					});
			
				}
			},
			error : function(d) { $.messager.alert("简单提示", "error", 'info');}
		});	
	}
	else if (saveType == 'modify')
	{
		var caseID = parent.tempStore.ID;
		jQuery.ajax({
			type: "post",
			url: "../web.eprajax.query.savequerycase.cls",
			async: false,
			data: {
				action: 'ModifyCase',
				CaseID: caseID,
				SaveUserID: parent.userID,
				SaveUserName: parent.userName,
				CTLocIDStr: CTLocIDStr,
				GroupIDStr: GroupIDStr,
				QueryCaseName: QueryCaseName,
				ConditionArr: dataCondition,
				ResultColsArr: dataResultCols
			},
			success: function(d) {
				if (d == -2)
				{
					$.messager.alert("提示信息", "名称已存在，请重新输入！","alert");
					return;
				}
				else if (d == -1)
				{
					$.messager.alert("提示信息", "修改失败！","alert");
					return;
				}
				else if (d > 0)
				{
					parent.tempStore.ID = caseID;
					parent.tempStore.Desc = QueryCaseName;
					$.messager.alert("提示信息", "修改成功！","alert",function(){
						closeWindow();
					});
					
				}
			},
			error : function(d) { $.messager.alert("简单提示", "error", 'info');}
		});
	}
}

function getSurrCaseInfo()
{
	var caseID = parent.tempStore.ID;
	jQuery.ajax({
		type: "post",
		url: "../web.eprajax.query.getquerycase.cls",
		async: false,
		data: {
			action: 'checkCaseID',
			CaseID: caseID
		},
		success: function(d) {
			if (d == 0)
			{
				$.messager.alert("提示信息", "此方案已经删除，不能修改方案！若想存储，请关闭页面后保存新方案！","alert");
			}
			else if (d == 1)
			{
				var caseDesc = parent.tempStore.Desc;
				$('#caseName').val(caseDesc);
				$('#CTLocCRGrid').datagrid('load',{
					action: 'getCTLocByCaseID',
					CaseID: caseID
				});
				$('#GroupCRGrid').datagrid('load',{
					action: 'getGroupByCaseID',
					CaseID: caseID
				});
			}
		},
		error : function(d) { $.messager.alert("简单提示", "error", '显示当前方案失败');}
	});
}

function closeWindow()
{
	parent.closeDialog(dialogId);
}