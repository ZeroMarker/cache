/**
 * stage.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-02
 * 
 * 
 */
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
	$(document.body).bind("keydown",BodykeydownHandler)
}
function PageHandle() {
	
}
function Find_Handle () {
	var PPRowId = PageLogicObj.m_Project.getValue()||"";
		PPDesc = $("#PPDesc").val();
		
	PLObject.m_Grid.reload({
		ClassName : "web.PilotProject.Extend.Stage",
		QueryName : "QryStageDic",
		PPRowId:PPRowId,
		InHosp:ServerObj.InHosp,
		PPDesc:PPDesc
	})
}
function Reset_Handle() {
	PageLogicObj.m_Project.setValue(ServerObj.PPRowId);
	$("#PPDesc").val("");
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
		},
		onSelect: function(r) {
			Find_Handle();
		}
	});
}
function InitGrid(){
	
	var columns = [[
		{field:'projectName',title:'������Ŀ',width:100},
		{field:'code',title:'�ڼ��׶�',width:100},
		{field:'name',title:'�׶�����',width:100},
		//{field:'days',title:'�׶�����',width:100},
		//{field:'order',title:'�׶�˳��',width:100},
		{field:'active',title:'�Ƿ񼤻�',width:100,
			formatter:function(value,row,index){
					if (value == "1") {
						return "<span class='c-ok'>��</span>"
					} else {
						return "<span class='c-no'>��</span>"
					}
				}
		},
		{field:'id',title:'id',width:100,hidden:true}
	]]
	var toobar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    },{
        text: '�޸�',
        iconCls: 'icon-write-order',
        handler: function() {UpdateClickHandle();}
    }/*,{
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler: function() {DeleteClickHandle();}
    },{
        text: '����',
        iconCls: 'icon-up',
        handler: function() {Up_ClickHandle();}
    },{
        text: '����',
        iconCls: 'icon-down',
        handler: function() {Down_ClickHandle();}
    }*/
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
			ClassName : "web.PilotProject.Extend.Stage",
			QueryName : "QryStageDic",
			PPRowId:ServerObj.PPRowId
		},
		onSelect: function (rowIndex, rowData) {
			
		},
		onLoadSuccess : function (data) {
		},
		columns :columns,
		toolbar:toobar
	});
	
	PLObject.m_Grid = DataGrid;
}

function AddClickHandle() {
	var PPRowId = PageLogicObj.m_Project.getValue()||ServerObj.PPRowId;
	var URL = "docpilotpro.cfg.stage.edit.csp?PPRowId="+PPRowId+"&InHosp="+ServerObj.InHosp;
	websys_showModal({
		url:URL,
		//maximizable:true,
		iconCls: 'icon-w-add',
		title:'����',
		width:370,height:400,
		CallBackFunc:FindClickHandle
	})
	
}

function UpdateClickHandle() {
	var selected = PLObject.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ","��ѡ��һ�У�","warning")
		return false;
	}
	var ID=selected.id;
	var PPRowId = PageLogicObj.m_Project.getValue()||ServerObj.PPRowId;
	
	var URL = "docpilotpro.cfg.stage.edit.csp?PPRowId="+PPRowId+"&InHosp="+ServerObj.InHosp+"&ID="+ID;
	websys_showModal({
		url:URL,
		//maximizable:true,
		iconCls: 'icon-w-edit',
		title:'�޸�',
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

function DeleteClickHandle () {
	var selected = PLObject.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ", "��ѡ��һ�У�", "info");
		return false;
	}
	
	$.messager.confirm("��ʾ", "ȷ��ɾ����",function (r) {
		if (r) {
			$m({
				ClassName:"web.PilotProject.Extend.Stage",
				MethodName:"DeleteDic",
				ID:selected.id
			}, function(result){
				if (result == 0) {
					$.messager.alert("��ʾ", "ɾ���ɹ���", "info");
					FindClickHandle();
					return true;
				} else {
					$.messager.alert("��ʾ", "ɾ��ʧ�ܣ�" + result , "info");
					return false;
				}
			});
		}
		
	});
}

function Up_ClickHandle () {
	var selectedOld = PLObject.m_Grid.getSelected();
	if (!selectedOld) {
		$.messager.alert('��ʾ','��ѡ��һ����¼!', "info");
		return false;
	}
	//Index from zero
	var rowIndexOld = PLObject.m_Grid.getRowIndex(selectedOld);
	if (rowIndexOld == 0) {
		$.messager.alert('��ʾ','���ǵ�һ����¼���޷��ϵ�!', "info");
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
			$.messager.alert("��ʾ", "�ϵ�ʧ�ܣ�" + result , "info");
			return false;
		}
	});	
}

function Down_ClickHandle () {
	var selectedOld = PLObject.m_Grid.getSelected();
	if (!selectedOld) {
		$.messager.alert('��ʾ','��ѡ��һ����¼!', "info");
		return false;
	}
	//Index from zero
	var AllData = PLObject.m_Grid.getData();
	var totalRows = AllData.total;
	var rowIndexOld = PLObject.m_Grid.getRowIndex(selectedOld);
	if (rowIndexOld == (totalRows-1)) {
		$.messager.alert('��ʾ','�������һ����¼���޷��µ�!', "info");
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
			$.messager.alert("��ʾ", "�µ�ʧ�ܣ�" + result , "info");
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
	//�������Backspace������  
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
