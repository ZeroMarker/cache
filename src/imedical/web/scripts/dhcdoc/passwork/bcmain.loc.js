/**
 * bcmain.loc.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-02
 * 
 * 
 */

var PageLogicObj = {
	m_Loc:""
}

$(function() {
	Init();
	InitEvent();
	//PageHandle();
})


function Init(){
	InitBTypeGrid();
	InitCombox();
	
}

function InitEvent () {
	$("#BTAdd").click(function(){SaveHandler("ADD")});
	$("#BTEdit").click(function(){SaveHandler("Edit")});
	$("#BTDel").click(BTDelHandler);
}

function PageHandle() {
	
}

function BTDelHandler () {
	var selected = PageLogicObj.m_BTypeGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	
	$.messager.confirm("提示", "确认删除？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.PW.CFG.BCLoc",
				MethodName:"Delete",
				ID:selected.rowid
			}, function(result){
				if (result == 0) {
					$.messager.alert("提示", "删除成功！", "info");
					PageLogicObj.m_Loc.clear();
					FindBType();
					return true;
				} else {
					$.messager.alert("提示", "删除失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
}

function SaveHandler(AC) {
	var ID="";
	if (AC == "Edit") {
		var selected = PageLogicObj.m_BTypeGrid.getSelected();
		if (!selected) {
			$.messager.alert("提示", "请选择一行！", "info");
			return false;
		} else {
			ID = selected.rowid;
		}
	}
	var MID = ServerObj.MID;
	var Loc = PageLogicObj.m_Loc.getValue()||"";
	if (Loc == "") {
		$.messager.alert("提示", "请选择科室！", "info");
		return false;
	}
	
	var inPara = MID+"^"+Loc;
	
	$m({
		ClassName:"DHCDoc.PW.CFG.BCLoc",
		MethodName:"Save",
		ID:ID,
		inPara:inPara
	}, function(result){
		var result = result.split("^")
		if (result[0] > 0) {
			$.messager.alert("提示", "保存成功！", "info",function () {
				PageLogicObj.m_Loc.clear();
				PageLogicObj.m_Loc.reload();
				FindBType();
			});
		}  else {
			$.messager.alert("提示", "保存失败："+result[1] , "info");
			return false;
		}
	});
	
	
	
}

function FindBType () {
	PageLogicObj.m_BTypeGrid.reload({
		ClassName : "DHCDoc.PW.CFG.BCLoc",
		QueryName : "QryBCLoc",
		InMID:ServerObj.MID
	});
}

function InitCombox() {
	PageLogicObj.m_Loc = $HUI.combobox("#loc", {
		url:$URL+"?ClassName=DHCDoc.PW.CFG.BCLoc&QueryName=QryGetdep&InHosp="+ServerObj.Hosp+"&InLcoType=I"+"&ResultSetType=array",
		valueField:'id',
		textField:'text',
		blurValidValue:true,
		mode:'remote',
		onBeforeLoad:function(param){
			param.Desc = param["q"];
		}
	});
	
}

function InitBTypeGrid () {
	var columns = [[
		{field:'locname',title:'科室名称',width:200},
        {field:'rowid',title:'ID',width:60,hidden:false}
    ]]
	var DurDataGrid = $HUI.datagrid("#List", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.PW.CFG.BCLoc",
			QueryName : "QryBCLoc",
			InMID:ServerObj.MID
		},
		onUnselect:function(){
		},
		columns :columns,
		toolbar:[{
				text:'新增',
				id:'BTAdd',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'BTEdit',
				iconCls: 'icon-write-order'
            }
            ,{
				text:'删除',
				id:'BTDel',
				iconCls: 'icon-cancel'
			}
		],
		onBeforeSelect:function(index, row){
			var selrow = PageLogicObj.m_BTypeGrid.getSelected();
			if (selrow){
				var oldIndex = PageLogicObj.m_BTypeGrid.getRowIndex(selrow);
				if (oldIndex == index){
					PageLogicObj.m_BTypeGrid.unselectRow(index);
					return false;
				}
			}
		},
		onUnselect: function (rowIndex, rowData) {
			PageLogicObj.m_Loc.clear();
		},
		onSelect: function (rowIndex, rowData) {
			PageLogicObj.m_Loc.reload();
			PageLogicObj.m_Loc.select(rowData.locid)
		}
	});
	
	PageLogicObj.m_BTypeGrid =  DurDataGrid;
	return false;
}
