/**
 * durexceed.hui.js �Ƴ̳���ԭ������
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 * TABL: DHCDoc_ExceedReason
 */

//ҳ��ȫ�ֱ���
var PageLogicObj = {
	m_DurDataGrid : "",
	m_SDateBox : "",
	m_EDateBox : "",
	m_Win : "",
	m_TimeWin : ""
}

$(function(){
	//��ʼ��
	Init();
	
	//�¼���ʼ��
	InitEvent();
	
	//ҳ��Ԫ�س�ʼ��
	//PageHandle();
})

function Init(){
	var hospComp = GenUserHospComp();
	PageLogicObj.m_DurDataGrid = InitDurDataGrid();
	hospComp.jdata.options.onSelect = function(e,t){
		$('#i-durGrid').datagrid('reload');
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		$('#i-durGrid').datagrid('reload');
	}
}

function InitEvent(){
	$("#i-find").click(findConfig);
	$("#i-add").click(function(){opDialog("add")});
	$("#i-edit").click(function(){opDialog("edit")});
	$("#i-delete").click(function(){deConfig()});
	$("#i-set").click(function(){setDurTime()});
	$("#i-code").keydown(function(e){
		if(e.which == 13 || event.which == 9){
			findConfig();
		}
	})
	$("#i-reason").keydown(function(e){
		if(e.which == 13 || event.which == 9){
			findConfig();
		}
	})
	$(document.body).bind("keydown",BodykeydownHandler)
}

function PageHandle(){
	//
}

function InitDurDataGrid(){
	//TABLE: DHCDocIPBDictory
	var columns = [[
		{field:'TExceedCode',title:'����',width:100},
		{field:'TExceedDesc',title:'����ԭ��',width:300},
		{field:'TExceedFromDate',title:'��ʼ����',width:100},
		{field:'TExceedEndDate',title:'��ֹ����',width:100},
		{field:'ExceedID',title:'ID',width:60}
    ]]
	var DurDataGrid = $HUI.datagrid("#i-durGrid", {
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
			ClassName : "web.DHCDocExceedReason",
			QueryName : "DHCExceedReason",
			ExceedType: "",
			ExceedCode: $("#i-code").val(),
			ExceedDesc: $("#i-reason").val()
		},
		//idField:'Rowid',
		columns :columns,
		toolbar:[{
				text:'����',
				id:'i-add',
				iconCls: 'icon-add'
			},{
				text:'�޸�',
				id:'i-edit',
				iconCls: 'icon-write-order'
			},{
				text:'ɾ��',
				id:'i-delete',
				iconCls: 'icon-cancel'
			},{
				text:'�����޶�ʱ��',
				id:'i-set',
				iconCls: 'icon-copy-sos'
			},{
		        text: '��ȨҽԺ',
		        iconCls: 'icon-house',
		        handler: function() {
			        var row=$('#i-durGrid').datagrid('getSelected');
					if (!row){
						$.messager.alert("��ʾ","��ѡ��һ�У�")
						return false
					}
					GenHospWin("DHCDoc_ExceedReason",row.ExceedID);
			    }
		    }],
		 onBeforeLoad:function(param){
		 	var HospID=$HUI.combogrid('#_HospUserList').getValue();
		 	if(HospID=='') return false;
		 	param.HospID=HospID;
		 }
	});
	
	return DurDataGrid;
}

//�༭������
function opDialog(action) {
	var selected = PageLogicObj.m_DurDataGrid.getSelected();
	var _title = "", _icon = "" ;
	if (action == "add") {
		_title = "����";
		_icon = "icon-w-add";
		$("#i-action").val("add");
		$("#i-id").val("");
	} else {
		if (!selected) {
			$.messager.alert("��ʾ","��ѡ��һ����¼��","info")
			return false;
		}
		_title = "�޸�";
		_icon = "icon-w-edit";
		$("#i-action").val("edit");
		$("#i-id").val(selected.Rowid);
	}
	
	if($('#i-dialog').hasClass("c-hidden")) {
		$('#i-dialog').removeClass("c-hidden");
	};
	
	//����
	var sDateBox = $HUI.datebox("#i-diag-sdate",{
		//required:true  
	});
	
	var eDateBox = $HUI.datebox("#i-diag-edate",{
		//required:true  
	});
	PageLogicObj.m_SDateBox = sDateBox;
	PageLogicObj.m_EDateBox = eDateBox;
	if (action == "add") {
		sDateBox.setValue("");
		eDateBox.setValue("");
		$("#i-id").val("");
		$("#i-action").val("add");
		$("#i-diag-code").val("");
		$("#i-diag-reason").val("");
	} else {
		$("#i-id").val(selected.ExceedID);
		$("#i-action").val("edit");
		sDateBox.setValue(selected.TExceedFromDate);
		eDateBox.setValue(selected.TExceedEndDate);
		$("#i-diag-code").val(selected.TExceedCode);
		$("#i-diag-reason").val(selected.TExceedDesc);
	}
	
	var cWin = $HUI.window('#i-dialog', {
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			//$(this).window('destroy');
			$('#i-dialog').addClass("c-hidden");
		}
	});
	
	PageLogicObj.m_Win = cWin;
}

function deConfig () {
	var selected = PageLogicObj.m_DurDataGrid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ","��ѡ��һ����¼��","info")
		return false;
	}
	$.m({
			ClassName:"web.DHCDocExceedReason",
			MethodName:"Delete",
			'ID': selected.ExceedID,
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('��ʾ','ɾ���ɹ���',"info");
				PageLogicObj.m_DurDataGrid.reload();
			} else {
				$.messager.alert('��ʾ','�޸�ʧ��,�������: '+ responseText , "info");
				return false;
			}	
		})
}

function setDurTime() {
	if($('#i-time').hasClass("c-hidden")) {
		$('#i-time').removeClass("c-hidden");
	};
	//��ֵ
	$.m({
		ClassName:"web.DHCDocExceedReason",
		MethodName:"GetExceedDate",
		'AdmType':"O"
	},function (responseText){
		$("#i-time-mz").val(responseText);	
	})
	
	$.m({
		ClassName:"web.DHCDocExceedReason",
		MethodName:"GetExceedDate",
		'AdmType':"E"
	},function (responseText){
		$("#i-time-jz").val(responseText);	
	})
	
	//
	var cWin = $HUI.window('#i-time', {
		title: "�����޶�ʱ��",
		iconCls: "icon-w-clock",
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			//$(this).window('destroy');
			$('#i-time').addClass("c-hidden");
		}
	});
	PageLogicObj.m_TimeWin = cWin;
}

function saveTime () {	
	var mzTime = $.trim($("#i-time-mz").val());	
	var jzTime = $.trim($("#i-time-jz").val());	
	var otn=tkMakeServerCall("web.DHCDocExceedReason","SetExceedDate","O",mzTime);
	var etn=tkMakeServerCall("web.DHCDocExceedReason","SetExceedDate","E",jzTime);
	$.messager.alert('��ʾ','���óɹ���',"info");
	PageLogicObj.m_TimeWin.close();
}

//�����ֵ���Ϣ
function saveCfg() {
	var id = $("#i-id").val();
	var action = $("#i-action").val();
	var code = $.trim($("#i-diag-code").val());
	var desc = $.trim($("#i-diag-reason").val());
	var sDate = PageLogicObj.m_SDateBox.getValue();
	var eDate = PageLogicObj.m_EDateBox.getValue();
	var type = "";
	
	if (code == "") {
		$.messager.alert('��ʾ','���벻��Ϊ�գ�',"info");
		return false;
	}
	if (desc == "") {
		$.messager.alert('��ʾ','����ԭ����Ϊ�գ�',"info");
		return false;
	}
	var methodName = "Update";
	var paraStr = code + "^" + desc  + "^" + type + "^" + sDate  + "^" + eDate;
	
	if (action == "add") {
		methodName = "Insert";
		$.m({
			ClassName:"web.DHCDocExceedReason",
			MethodName:methodName,
			'str':paraStr,
			HospID:$HUI.combogrid('#_HospUserList').getValue()
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('��ʾ','�����ɹ���',"info");
				PageLogicObj.m_Win.close();
				PageLogicObj.m_DurDataGrid.reload();
				
			} else {
				$.messager.alert('��ʾ','����ʧ��,�������: '+ responseText , "info");
				return false;
			}	
		})
	} else {
		$.m({
			ClassName:"web.DHCDocExceedReason",
			MethodName:methodName,
			'ID': id,
			'str':paraStr
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('��ʾ','�޸ĳɹ���',"info");
				PageLogicObj.m_Win.close();
				PageLogicObj.m_DurDataGrid.reload();
				
			} else {
				$.messager.alert('��ʾ','�޸�ʧ��,�������: '+ responseText , "info");
				return false;
			}	
		})
	}
}
function findConfig () {
	var code = $("#i-code").val();
	var reason = $("#i-reason").val();
	PageLogicObj.m_DurDataGrid.reload({
		ClassName : "web.DHCDocExceedReason",
		QueryName : "DHCExceedReason",
		ExceedType: "",
		ExceedCode: code,
		ExceedDesc: reason
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


