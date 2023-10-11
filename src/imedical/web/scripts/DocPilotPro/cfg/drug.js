/**
 * stage.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-02
 * 
 * 
 */
var PageLogicObj = {
	
}

$(function() {
	Init();
	InitEvent();
	//PageHandle();
})


function Init(){
	InitCombox();
	InitGrid();
}

function InitEvent () {
	$("#Find").click(Find_Handle)
	$("#Reset").click(Reset_Handle)
	//$(document.body).bind("keydown",BodykeydownHandler)
}
function PageHandle() {
	
}
function Find_Handle () {
	var 
		InDesc = $.trim($("#DArcim").val());
		
	PageLogicObj.m_Grid.reload({
		ClassName : "DHCDoc.GCP.CFG.Drug",
		QueryName : "DrugList",
		InPrj: ServerObj.PPRowId,
		InDesc: InDesc
	})
}
function Reset_Handle() {
	$("#DArcim").val("");
	Find_Handle();
}
function InitCombox() {
	PageLogicObj.m_Project = $HUI.combobox("#Project", {
		url:$URL+"?ClassName=web.PilotProject.Extend.Stage&QueryName=QryGCP&InHosp="+ServerObj.InHosp+"&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//required:true,
		value:ServerObj.PPRowId,
		blurValidValue:true,
		onBeforeLoad:function(param){
			param.inDesc = param["q"];
		}
	});
}
function InitGrid(){
	var columns = [[
		{field:'DArcim',title:'药品',width:150},
		{field:'DAddUser',title:'添加人',width:100},
		{field:'DAddDate',title:'添加时间',width:100},
		{field:'id',title:'id',width:100,hidden:true}
	]]
	var toobar=[{
        text: '新增',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {DelClickHandle();}
    }
    ];
	var DataGrid = $HUI.datagrid("#list", {
		fit : true,
		striped : true,
		border:false,
		singleSelect : true,
		fitColumns : true,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.GCP.CFG.Drug",
			QueryName : "DrugList",
			InPrj: ServerObj.PPRowId
		},
		onSelect: function (rowIndex, rowData) {
			
		},
		onLoadSuccess : function (data) {
		},
		columns :columns,
		toolbar:toobar
	});
	
	PageLogicObj.m_Grid = DataGrid;
}

function AddClickHandle() {
	var PPRowId = ServerObj.PPRowId;
	var URL = "gcp.cfg.drug.edit.csp?PPRowId="+PPRowId+"&InHosp="+ServerObj.InHosp;
	websys_showModal({
		url:URL,
		//maximizable:true,
		iconCls: 'icon-w-add',
		title:'添加',
		width:600,height:550,
		CallBackFunc:Find_Handle
	})
	
}

function UpdateClickHandle() {
	var selected = PLObject.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("提示","请选择一行！","warning")
		return false;
	}
	var ID=selected.id;
	var PPRowId = PageLogicObj.m_Project.getValue()||ServerObj.PPRowId;
	
	var URL = "docpilotpro.cfg.stage.edit.csp?PPRowId="+PPRowId+"&InHosp="+ServerObj.InHosp+"&ID="+ID;
	websys_showModal({
		url:URL,
		//maximizable:true,
		iconCls: 'icon-w-edit',
		title:'修改',
		width:370,height:400,
		CallBackFunc:FindClickHandle
	})
}

function FindClickHandle () {
	var PPRowId = PageLogicObj.m_Project.getValue()||"";
		PPDesc = $("#PPDesc").val();
		
	PLObject.m_Grid.reload({
		ClassName : "web.PilotProject.Extend.Stage",
		QueryName : "QryStageDic",
		PPRowId:PPRowId,
		PPDesc:PPDesc
	})
}

function DelClickHandle () {
	var selected = PageLogicObj.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	
	$.messager.confirm("提示", "确认删除？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.GCP.CFG.Drug",
				MethodName:"Delete",
				ID:selected.id
			}, function(result){
				if (result == 0) {
					$.messager.alert("提示", "删除成功！", "info");
					Find_Handle();
					return true;
				} else {
					$.messager.alert("提示", "删除失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
}

function Up_ClickHandle () {
	var selectedOld = PLObject.m_Grid.getSelected();
	if (!selectedOld) {
		$.messager.alert('提示','请选择一条记录!', "info");
		return false;
	}
	//Index from zero
	var rowIndexOld = PLObject.m_Grid.getRowIndex(selectedOld);
	if (rowIndexOld == 0) {
		$.messager.alert('提示','已是第一条记录，无法上调!', "info");
		return false;
	}
	//console.log(selectedOld)
	var oldSeqno = selectedOld.order;
	var oldID=selectedOld.id;
	var preIndex = rowIndexOld - 1;
	var selectedPre = PLObject.m_Grid.getData().rows[preIndex];
	var preSeqno = selectedPre.order;
	var preID=selectedPre.id
	
	$m({
		ClassName:"web.PilotProject.Extend.Stage",
		MethodName:"UpOrder",
		oldID:oldID,
		oldSeqno:oldSeqno,
		preID:preID,
		preSeqno:preSeqno
	}, function(result){
		if (result == 0) {
			FindClickHandle();
			return true;
		} else {
			$.messager.alert("提示", "上调失败：" + result , "info");
			return false;
		}
	});	
}

function Down_ClickHandle () {
	var selectedOld = PLObject.m_Grid.getSelected();
	if (!selectedOld) {
		$.messager.alert('提示','请选择一条记录!', "info");
		return false;
	}
	//Index from zero
	var AllData = PLObject.m_Grid.getData();
	var totalRows = AllData.total;
	var rowIndexOld = PLObject.m_Grid.getRowIndex(selectedOld);
	if (rowIndexOld == (totalRows-1)) {
		$.messager.alert('提示','已是最后一条记录，无法下调!', "info");
		return false;
	}
	var nextIndex = rowIndexOld + 1;
	var selectedNext = AllData.rows[nextIndex];
	var oldSeqno = selectedOld.order;
	var oldID=selectedOld.id;
	var preSeqno = selectedNext.order;
	var preID=selectedNext.id
	
	$m({
		ClassName:"web.PilotProject.Extend.Stage",
		MethodName:"UpOrder",
		oldID:oldID,
		oldSeqno:oldSeqno,
		preID:preID,
		preSeqno:preSeqno
	}, function(result){
		if (result == 0) {
			FindClickHandle();
			return true;
		} else {
			$.messager.alert("提示", "下调失败：" + result , "info");
			return false;
		}
	});	
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	//alert(keyCode)
	if (keyCode==13) {
		if(SrcObj && SrcObj.id.indexOf("PPDesc")>=0){
			Find_Handle();
			return false;
		}
		return true;
	}
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }   
}

