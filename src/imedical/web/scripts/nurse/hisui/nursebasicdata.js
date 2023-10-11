/**
* HISUI ���������������-��js
*/
var PageLogicObj={
	NurseBasicDataType:[{"id":"0","text":"������Ϣ"},{"id":"1","text":"ҽ����Ϣ"},{"id":"2","text":"ִ�м�¼��Ϣ"},{"id":"3","text":"��ӡ��Ϣ"},{"id":"4","text":"����ƻ�"},{"id":"5","text":"������Ϣ"}]
}
$(function(){ 
	Init();
	InitEvent();
});
$(window).load(function() {
	$("#Loading").hide();
	InitEditWindow();
	InitDataType();
})
function InitEvent(){
 	$("#BFind").click(function(){
	 	$("#NurseBasicDataList").datagrid("reload");
	});
	$("#SearchDesc").keydown(function(e){
		var key=websys_getKey(e);
		if (key==13){
			$("#NurseBasicDataList").datagrid("reload");
		}
	});
	$("#BSave").click(SaveNurseBasicDataClick);
	$("#BCancel").click(function(){
		$("#NurseBasicDataEditWin").window('close');
	});
}
function InitHospList(){
//	var hospComp = GenHospComp("Nur_IP_InterventionItem");
//	hospComp.jdata.options.onSelect = function(e,t){
//		$("#SearchDesc").val("");
//		//$.extend(PageLogicObj,{m_SelRowId:"",delInterventionSubItemArr:[]});
//		$("#NurseBasicDataList").datagrid("load");
//		InitDataType();
//	}
//	hospComp.jdata.options.onLoadSuccess= function(data){
//		Init();
//	}
}
function Init(){
	// ��ʼ�� �������Ͳ�ѯ����
	InitType();
	InitNurseBasicDataGrid();
	$("#SearchDesc").val("");
	$("#NurseBasicDataList").datagrid("load");
	InitDataType();
}
function InitType(){
	$("#SearchType").combobox({
		valueField:'id',
		textField:'text',
		mode: "local",
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		data:PageLogicObj.NurseBasicDataType,
		onSelect:function(rec){
			if (rec) {
				$("#NurseBasicDataList").datagrid("load");
			}
		},
		onUnselect:function(rec){
			$("#NurseBasicDataList").datagrid("load");
		},
		onAllSelectClick:function(e){
			$("#NurseBasicDataList").datagrid("load");

		}
	});
}
function InitNurseBasicDataGrid() {
	var ToolBar = [{
            text: '����',
            iconCls: 'icon-add',
            handler: function() {
				$("#NurseBasicDataEditWin").window('open');
            }
        },{
            text: '�޸�',
            iconCls: 'icon-write-order',
            handler: function() {
	            var row = $("#NurseBasicDataList").datagrid("getSelected");
				if (!row) {
					$.messager.popover({msg:'��ѡ����Ҫ�޸ĵļ�¼��',type:'error'});
					return false;
				}
				ShowNurseBasicDataWin(row);
            }
        },{
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
				DeleteNurseBasicData();
            }
        },{
	        text: '����',
	        iconCls: 'icon-translate-word',
	        handler: function() {
	            Translate("NurseBasicDataList","CT.NUR.NIS.NurseBasicData","NBDName","NBDName")	
	        }
	    }];	
	var Columns=[[    
		{ field: 'NBDCode',title:'���ݱ���',width:200},
		{ field: 'NBDTypeDesc',title:'��������',width:120},
		{ field: 'NBDName',title:'����',width:120},
		{ field: 'NBDNote',title:'��ע',width:120},
		{ field: 'NBDExpression',title:'���ʽ',width:400,wordBreak:"break-all"}
    ]];
    $('#NurseBasicDataList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : true, 
		rownumbers : true,
		idField:"RowID",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*�˴�Ϊfalse*/
		url : $URL+"?ClassName=Nur.NIS.Service.Base.BedConfig&QueryName=GetNurseBasicDataList",
		onBeforeLoad:function(param){
			var SearchType=$("#SearchType").combobox("getValues");
			if (SearchType.length > 0){
				SearchType=SearchType.join("^");
			}else{
				SearchType="";
			}
			PageLogicObj.m_SelRowId=""
			$('#NurseBasicDataList').datagrid("unselectAll");
			param = $.extend(param,{searchName:$("#SearchDesc").val(),searchType:SearchType});
			
		},
		onDblClickRow:function(rowIndex, rowData){
		}
	})
}
function InitEditWindow(){
    $("#NurseBasicDataEditWin" ).window({
	   modal: true,
	   collapsible:false,
	   minimizable:false,
	   maximizable:false,
	   closed:true,
	   onClose:function(){
			SetNurseBasicDataEditWinData();
	   }
	});
}
function InitDataType() {
	$("#DataType").combobox({
		valueField:'id',
		textField:'text',
		multiple:false,
		method:'local',
		data:PageLogicObj.NurseBasicDataType
	})
}
function ShowNurseBasicDataWin(row) {
	$("#NurseBasicDataEditWin").panel({title:"�޸Ļ��������������"});
	$("#DataCode").val(row.NBDCode);
	var index=$.hisui.indexOfArray(PageLogicObj.NurseBasicDataType,"text",row.NBDTypeDesc); 
	$("#DataType").combobox("setValue",PageLogicObj.NurseBasicDataType[index].id);
	$("#DataName").val(row.NBDName);
	$("#DataNote").val(row.NBDNote);
	$("#DataExpression").val(row.NBDExpression);
	PageLogicObj.m_SelRowId=row.RowID;
	$("#NurseBasicDataEditWin").window('open');
}
function SetNurseBasicDataEditWinData() {
	$("#NurseBasicDataEditWin").panel({title:"�������������������"});
	PageLogicObj.m_SelRowId="";
	$("#DataCode,#DataName,#DataNote,#DataExpression").val("");
	$("#DataType").combobox("setValue","");
}
function DeleteNurseBasicData() {
	var selected = $("#NurseBasicDataList").datagrid("getSelected");
	if (!selected) {
		$.messager.popover({msg:'��ѡ����Ҫɾ���ļ�¼��',type:'error'});
		return false;
	}
	var rowID=selected.RowID;
	var Msg="ȷ��Ҫɾ����������������";
	$.messager.confirm('ȷ�϶Ի���', Msg, function(r){
		if (r) {
			var rtn=$.m({
				ClassName:"Nur.NIS.Service.Base.BedConfig",
				MethodName:"HandleNurseBasicData",
				rowID:rowID,
				code:"",
				type:"",
				name:"",
				note:"",
				expression:"",
				hospId:"",
				event:"DELETE"
			},false)
			if (rtn !=0) {
				$.messager.popover({msg:'ɾ��ʧ�ܣ�',type:'error'});
				return false;
			}else{
				//$("#NurseBasicDataList").datagrid("reload");
				var QueIndex=$('#NurseBasicDataList').datagrid('getRowIndex',rowID);
				$('#NurseBasicDataList').datagrid('deleteRow', QueIndex);
			}
		}
	});
}
// ���滤�������������
function SaveNurseBasicDataClick() {
	var NBDCode=$("#DataCode").val();
	if (!NBDCode) {
		$.messager.popover({msg:'���������ݱ��룡',type:'error'});
		$("#DataCode").focus();
		return false;
	}
	var NBDType=$("#DataType").combobox("getValue");
	if (!NBDType) {
		$.messager.popover({msg:'��ѡ���������ͣ�',type:'error'});
		$('#DataType').next('span').find('input').focus();
		return false;
	}else if($.hisui.indexOfArray($('#DataType').combobox("getData"),"id",NBDType)<0){
		$.messager.popover({msg:'������������ѡ���������ͣ�',type:'error'});
		$('#DataType').next('span').find('input').focus();
		return false;
	}
	var NBDName=$("#DataName").val();
	var NBDNote=$("#DataNote").val();
	if (!NBDNote) {
		$.messager.popover({msg:'�����뱸ע��',type:'error'});
		$("#DataNote").focus();
		return false;
	}
	var NBDExpression=$("#DataExpression").val();
	if (!NBDExpression) {
		$.messager.popover({msg:'��������ʽ��',type:'error'});
		$("#DataExpression").focus();
		return false;
	}
	console.log(NBDCode,NBDType,NBDName,NBDExpression)
	var sc=$.m({
		ClassName:"Nur.NIS.Service.Base.BedConfig",
		MethodName:"HandleNurseBasicData",
		rowID:PageLogicObj.m_SelRowId,
		code:NBDCode,
		type:NBDType,
		name:NBDName,
		note:NBDNote,
		expression:NBDExpression,
		event:"SAVE"
	},false)
	if (sc==="0"){
		$("#NurseBasicDataEditWin").window("close");
		$("#NurseBasicDataList").datagrid("reload");
	}else{
		if (sc==="-1") {
			$.messager.alert("��ʾ","����ʧ��!");
		}else{
			$.messager.alert("��ʾ","����ʧ��,"+sc);
		}
		return false;
	}
	
}

// ����
function Translate(tableId,className,fieldName,key){
	var selectedRow=$("#"+tableId).datagrid("getSelections");
	if(selectedRow.length>0){
		if(selectedRow[0][key]=="") return $.messager.popover({msg:'����Ϊ�գ����跭�룡',type:'info'});
		CreatTranLate(className,fieldName,selectedRow[0][key]);
	}else{
		$.messager.popover({msg:'��ѡ��Ҫ��������ݣ�',type:'alert'});
	}		
}