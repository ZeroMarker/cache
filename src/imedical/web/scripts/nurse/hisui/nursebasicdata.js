/**
* HISUI 护理基础数据配置-主js
*/
var PageLogicObj={
	NurseBasicDataType:[{"id":"0","text":"患者信息"},{"id":"1","text":"医嘱信息"},{"id":"2","text":"执行记录信息"},{"id":"3","text":"打印信息"},{"id":"4","text":"护理计划"},{"id":"5","text":"分娩信息"}]
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
	// 初始化 数据类型查询条件
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
		rowStyle:'checkbox', //显示成勾选行形式
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
            text: '新增',
            iconCls: 'icon-add',
            handler: function() {
				$("#NurseBasicDataEditWin").window('open');
            }
        },{
            text: '修改',
            iconCls: 'icon-write-order',
            handler: function() {
	            var row = $("#NurseBasicDataList").datagrid("getSelected");
				if (!row) {
					$.messager.popover({msg:'请选择需要修改的记录！',type:'error'});
					return false;
				}
				ShowNurseBasicDataWin(row);
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
				DeleteNurseBasicData();
            }
        },{
	        text: '翻译',
	        iconCls: 'icon-translate-word',
	        handler: function() {
	            Translate("NurseBasicDataList","CT.NUR.NIS.NurseBasicData","NBDName","NBDName")	
	        }
	    }];	
	var Columns=[[    
		{ field: 'NBDCode',title:'数据编码',width:200},
		{ field: 'NBDTypeDesc',title:'数据类型',width:120},
		{ field: 'NBDName',title:'名称',width:120},
		{ field: 'NBDNote',title:'备注',width:120},
		{ field: 'NBDExpression',title:'表达式',width:400,wordBreak:"break-all"}
    ]];
    $('#NurseBasicDataList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true, 
		rownumbers : true,
		idField:"RowID",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*此处为false*/
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
	$("#NurseBasicDataEditWin").panel({title:"修改护理基础数据配置"});
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
	$("#NurseBasicDataEditWin").panel({title:"新增护理基础数据配置"});
	PageLogicObj.m_SelRowId="";
	$("#DataCode,#DataName,#DataNote,#DataExpression").val("");
	$("#DataType").combobox("setValue","");
}
function DeleteNurseBasicData() {
	var selected = $("#NurseBasicDataList").datagrid("getSelected");
	if (!selected) {
		$.messager.popover({msg:'请选择需要删除的记录！',type:'error'});
		return false;
	}
	var rowID=selected.RowID;
	var Msg="确定要删除此条基本数据吗？";
	$.messager.confirm('确认对话框', Msg, function(r){
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
				$.messager.popover({msg:'删除失败！',type:'error'});
				return false;
			}else{
				//$("#NurseBasicDataList").datagrid("reload");
				var QueIndex=$('#NurseBasicDataList').datagrid('getRowIndex',rowID);
				$('#NurseBasicDataList').datagrid('deleteRow', QueIndex);
			}
		}
	});
}
// 保存护理基础数据配置
function SaveNurseBasicDataClick() {
	var NBDCode=$("#DataCode").val();
	if (!NBDCode) {
		$.messager.popover({msg:'请输入数据编码！',type:'error'});
		$("#DataCode").focus();
		return false;
	}
	var NBDType=$("#DataType").combobox("getValue");
	if (!NBDType) {
		$.messager.popover({msg:'请选择数据类型！',type:'error'});
		$('#DataType').next('span').find('input').focus();
		return false;
	}else if($.hisui.indexOfArray($('#DataType').combobox("getData"),"id",NBDType)<0){
		$.messager.popover({msg:'请在下拉框中选择数据类型！',type:'error'});
		$('#DataType').next('span').find('input').focus();
		return false;
	}
	var NBDName=$("#DataName").val();
	var NBDNote=$("#DataNote").val();
	if (!NBDNote) {
		$.messager.popover({msg:'请输入备注！',type:'error'});
		$("#DataNote").focus();
		return false;
	}
	var NBDExpression=$("#DataExpression").val();
	if (!NBDExpression) {
		$.messager.popover({msg:'请输入表达式！',type:'error'});
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
			$.messager.alert("提示","保存失败!");
		}else{
			$.messager.alert("提示","保存失败,"+sc);
		}
		return false;
	}
	
}

// 翻译
function Translate(tableId,className,fieldName,key){
	var selectedRow=$("#"+tableId).datagrid("getSelections");
	if(selectedRow.length>0){
		if(selectedRow[0][key]=="") return $.messager.popover({msg:'名称为空，无需翻译！',type:'info'});
		CreatTranLate(className,fieldName,selectedRow[0][key]);
	}else{
		$.messager.popover({msg:'请选择要翻译的数据！',type:'alert'});
	}		
}