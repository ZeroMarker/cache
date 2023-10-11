/**
* @author songchunli
* HISUI �����¼�̶���ͷ������js
*/
var PageLogicObj={
	m_TaskLinkEMRId:"",
	m_TaskLinkEMRSubId:"",
	m_tabTaskLinkEMRItemSubListGrid:""
}
$(function(){ 
	InitHospList();
	InitEvent();
});
$(window).load(function() {
	$("#loading").hide();
	InitEditWindow();
	InitWinData();
	InitTip();
})
function InitWinData(){
	//��ʼ����¼��ģ��
	InitNurRecordEntryTpl();
	//��ʼ����Ч����
	InitApplyAreaLoc();
	// ��ʼ����������
	InitTaskItem();
	// ��ʼ������ģʽ
	InitGenerateWay();
}
function InitEvent(){
 	/*$("#BFind").click(function(){
	 	$("#tabTaskLinkEMRItemList").datagrid("reload");
	});
	$("#SearchDesc").keydown(function(e){
		var key=websys_getKey(e);
		if (key==13){
			$("#tabTaskLinkEMRItemList").datagrid("reload");
		}
	});*/
	$("#BSaveLinkEMR").click(SaveLinkEMRClick);
	$("#BCancel").click(function(){
		$("#TaskLinkEMRItemEditWin").window('close');
	});
	$("#BSaveLinkEMRSubItem").click(SaveLinkEMRSubItemClick);
	$("#BCancelSubWin").click(function(){
		$("#TaskLinkEMRItemSubEditWin").window('close');
	});
}
function InitTip(){
	$("#headerEntryTpl_tip").popover({
		trigger:'hover',
		content:"<p>ֻ�б�¼��ģ����ڶ�̬��ͷ�Ĳ��������б�ģ�塣</p>",
		style:'inverse'
	});
	
	// ��ӡģ��˵��
	$("#printCode_tip").popover({
		trigger:'hover',
		content:"<p>��Ҫ����ͼƬ����Ҫ���ô�ӡģ��ؼ��֡�</p>",
		style:'inverse'
	});
	
}
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_EMRLinkItem");
	hospComp.jdata.options.onSelect = function(e,t){
		$.extend(PageLogicObj,{m_TaskLinkEMRId:"",m_TaskLinkEMRSubId:""});
		$("#templSearch,#TaskItemSearch").searchbox("setValue","");
		SetTaskLinkEMRItemSubToolbarStatus("disable");
		$("#tabTaskLinkEMRItemList").datagrid("load");
		if (PageLogicObj.m_tabTaskLinkEMRItemSubListGrid){
			$("#tabTaskLinkEMRItemSubList").datagrid("loadData",[]);
		}
		InitApplyAreaLoc();
		InitTaskItem();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	// ��ʼ�� ״̬��ѯ����
	InitTaskLinkEMRItemList();
}
function InitTaskLinkEMRItemList(){
	var ToolBar = [{
			text: '����',
			iconCls: 'icon-add',
			handler: function() {
				$("#printCode").val("")
				PageLogicObj.m_TaskLinkEMRId="";
				$("#TaskLinkEMRItemEditWin").window("setTitle","���������¼��ͷ��������").window('open');
			}
	},{
		text: '�޸�',
		iconCls: 'icon-write-order',
		handler: function() {
			var row = $("#tabTaskLinkEMRItemList").datagrid("getSelected");
			if (!row) {
				$.messager.popover({msg:'��ѡ����Ҫ�޸ĵļ�¼��',type:'error'});
				return false;
			}
			ShowTaskLinkEMRItemEditWin(row);
		}
	},{
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
			var row = $("#tabTaskLinkEMRItemList").datagrid("getSelected");
			if (!row) {
				$.messager.popover({msg:'��ѡ����Ҫɾ���ļ�¼��',type:'error'});
				return false;
			}
			$.messager.confirm('ȷ�϶Ի���', 'ȷ��Ҫɾ�����������¼��ͷ������������������Ԫ��Ҳ�ᱻһͬɾ����', function(r){
				if (r){
					$.m({
						ClassName:"CF.NUR.NIS.EMRLinkItem",
						MethodName:"DelEMRLinkItem",
						ID:row.id,
						UserId:session['LOGON.USERID']
					},function(rtn){
						if (rtn ==0){
							var index=$('#tabTaskLinkEMRItemList').datagrid("getRowIndex",row.id);
							$('#tabTaskLinkEMRItemList').datagrid("deleteRow",index);
						}else{
							$.messager.popover({msg:'ɾ��ʧ�ܣ�'+rtn,type:'error'});
						}
					})
				}
			});	
		}
    },'-',];
	var Columns=[[ 
		{ field: 'nurseRecordEntryTpl',title:'��¼��ģ��',width:130,wordBreak:"break-all"},
		{ field: 'signature',title:'ǩ��',width:120},
		{ field: 'diseaseMeasure',title:'�����ʩ',width:150,wordBreak:"break-all"},
		{ field: 'headerEntryTpl',title:'�б�ģ��',width:150,wordBreak:"break-all"},
		{ field: 'locsName',title:'��Ч����',width:150,wordBreak:"break-all"},
		{ field: 'printCode',title:'��ӡģ��',width:150,wordBreak:"break-all"},
		{ field: 'generateway',title:'����ģʽ',width:150,wordBreak:"break-all"
			,formatter:function(value,row,index){
				return row.generatewaydesc;
			}}
    ]];
	$('#tabTaskLinkEMRItemList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : true, 
		idField:"id",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*�˴�Ϊfalse*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.EMRLinkItem&QueryName=GetEMRLinkItemList",
		onBeforeLoad:function(param){
			SetTaskLinkEMRItemSubToolbarStatus("disable");
			PageLogicObj.m_TaskLinkEMRId="";
			$('#tabTaskLinkEMRItemList').datagrid("unselectAll"); 
			param = $.extend(param,{keyword:$("#templSearch").searchbox("getValue"),loc:session['LOGON.CTLOCID'],hospDR:$HUI.combogrid('#_HospList').getValue()});
		},
		onDblClickRow:function(rowIndex, rowData){
			ShowTaskLinkEMRItemEditWin(rowData);
		},
		onSelect:function(rowIndex, rowData){
			if (PageLogicObj.m_tabTaskLinkEMRItemSubListGrid){
				$("#tabTaskLinkEMRItemSubList").datagrid("load");
			}else{
				InittabTaskLinkEMRItemSubListGrid();
			}
			InitfixedElement(rowData.nurseRecordEntryTplId);
			SetTaskLinkEMRItemSubToolbarStatus("enable");
		}
	})
	$("#TaskLinkEMRItemList_toolbar").appendTo($("#TaskLinkEMRItemPanel .datagrid-toolbar tr"))
}
function templSearchClick(){
	$('#tabTaskLinkEMRItemList').datagrid("load");
}
function TaskItemSearchClick(){
	$('#tabTaskLinkEMRItemSubList').datagrid("load");
}
function SetTaskLinkEMRItemSubToolbarStatus(status){
	$("#TaskLinkEMRItemSubPanel .datagrid-toolbar a").linkbutton(status);
}
function InittabTaskLinkEMRItemSubListGrid(){
	var ToolBar = [{
			text: '����',
			iconCls: 'icon-add',
			handler: function() {
				PageLogicObj.m_TaskLinkEMRSubId="";
				$("#enableDate").datebox("setValue",ServerObj.CurrentDate);
				$("#TaskLinkEMRItemSubEditWin").window("setTitle","���������¼��ͷ������������").window('open');
			}
	},{
		text: '�޸�',
		iconCls: 'icon-write-order',
		handler: function() {
			var row = $("#tabTaskLinkEMRItemSubList").datagrid("getSelected");
			if (!row) {
				$.messager.popover({msg:'��ѡ����Ҫ�޸ĵļ�¼��',type:'error'});
				return false;
			}
			ShowTaskLinkEMRItemSubEditWin(row);
		}
	},{
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
			var row = $("#tabTaskLinkEMRItemSubList").datagrid("getSelected");
			if (!row) {
				$.messager.popover({msg:'��ѡ����Ҫɾ���ļ�¼��',type:'error'});
				return false;
			}
			$.messager.confirm('ȷ�϶Ի���', 'ȷ��Ҫɾ�����������¼��ͷ��������������', function(r){
				if (r){
					$.m({
						ClassName:"CF.NUR.NIS.EMRLinkItemSub",
						MethodName:"DelEMRLinkItemSub",
						ID:row.id,
						UserId:session['LOGON.USERID']
					},function(rtn){
						if (rtn ==0){
							var index=$('#tabTaskLinkEMRItemSubList').datagrid("getRowIndex",row.id);
							$('#tabTaskLinkEMRItemSubList').datagrid("deleteRow",index);
						}else{
							$.messager.popover({msg:'ɾ��ʧ�ܣ�'+rtn,type:'error'});
						}
					})
				}
			});	
		}
	},'-'];
	var Columns=[[ 
		{ field: 'fixedElement',title:'�̶�Ԫ��',width:200,wordBreak:"break-all"},
		{ field: 'nurseTask',title:'��������',width:200,wordBreak:"break-all"},
		{ field: 'status',title:'״̬',width:70}
	]];
	PageLogicObj.m_tabTaskLinkEMRItemSubListGrid=$('#tabTaskLinkEMRItemSubList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : true, 
		idField:"id",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*�˴�Ϊfalse*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.EMRLinkItemSub&QueryName=GetEMRLinkItemSubList",
		onBeforeLoad:function(param){
			PageLogicObj.m_TaskLinkEMRSubId="";
			$('#tabTaskLinkEMRItemSubList').datagrid("unselectAll"); 
			//PageLogicObj.m_TaskLinkEMRId
			var pId ="";
			var row = $("#tabTaskLinkEMRItemList").datagrid("getSelected");
			if (row) pId=row.id;
			param = $.extend(param,{pId:pId,keyword:$("#TaskItemSearch").searchbox("getValue"),loc:session['LOGON.CTLOCID'],hospDR:$HUI.combogrid('#_HospList').getValue()});
		},
		onDblClickRow:function(rowIndex, rowData){
			ShowTaskLinkEMRItemSubEditWin(rowData);
		}
	})
	$("#TaskLinkEMRItemListSub_toolbar").appendTo($("#TaskLinkEMRItemSubPanel .datagrid-toolbar tr"))
}
function InitEditWindow(){
    $("#TaskLinkEMRItemEditWin" ).window({
	   modal: true,
	   collapsible:false,
	   minimizable:false,
	   maximizable:false,
	   closed:true,
	   onClose:function(){
			SetTaskLinkEMRItemEditWinData();
	   }
	});
	$("#TaskLinkEMRItemSubEditWin").window({
		modal: true,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closed:true,
		onClose:function(){
			 SetTaskLinkEMRItemSubEditWinData();
		}
	 });
}
function ShowTaskLinkEMRItemEditWin(row){
	PageLogicObj.m_TaskLinkEMRId=row.id;
	//ͨ��id�����¼��ͷ��������
	$.cm({
		ClassName:"Nur.NIS.Service.NursingPlan.EMRLinkItem",
		MethodName:"GetEMRLinkItemById",
		id:row.id
	},function(JsonData){
		$("#nurRecordEntryTpl").combobox("disable").combobox("select",JsonData.nurseRecordEntryTpl);
		setTimeout(function() {
			$("#signature").combobox("setValue",JsonData.signature);
			$("#diseaseMeasure").combobox("setValue",JsonData.diseaseMeasure);
		})
		$("#headerEntryTpl").combobox("setValue",JsonData.headerEntryTpl);
		$("#ApplyAreaLoc").combobox("setValue",JsonData.validLoc)
		$("#printCode").val(JsonData.printCode);
		$("#GenerateWay").combobox("setValue",JsonData.generateway)

		$("#TaskLinkEMRItemEditWin").window("setTitle","�޸Ļ����¼��ͷ��������").window('open');
	})
}
function ShowTaskLinkEMRItemSubEditWin(row){
	PageLogicObj.m_TaskLinkEMRSubId=row.id;
	setTimeout(function() {
		// ͨ��id��ȡ�����¼��ͷ�ӱ���������
		$.cm({
			ClassName:"Nur.NIS.Service.NursingPlan.EMRLinkItemSub",
			MethodName:"GetEMRLinkItemSubById",
			id:row.id
		},function(JsonData){
			$("#fixedElement").combobox("setValue",JsonData.fixedElement);
			$("#taskItem").combobox("setValue",JsonData.nurseTask);
			$("#enableDate").datebox("setValue",JsonData.startDate);
			$("#endDate").datebox("setValue",JsonData.endDate);
			$("#TaskLinkEMRItemSubEditWin").window("setTitle","�޸Ļ����¼��ͷ������������").window('open');			
		})
	})
}
function SetTaskLinkEMRItemEditWinData(){
	$("#nurRecordEntryTpl").combobox("enable");
	$("#nurRecordEntryTpl,#headerEntryTpl,#ApplyAreaLoc").combobox("setValue","");
}
function SetTaskLinkEMRItemSubEditWinData(){
	$("#fixedElement,#taskItem").combobox("setValue","").combobox("reload");
	$("#enableDate").datebox("setValue",ServerObj.CurrentDate);
	$("#endDate").datebox("setValue","");
}
// ���滤���¼������
function SaveLinkEMRClick(){
	var nurseRecordEntryTpl=$("#nurRecordEntryTpl").combobox("getValue");
	if (!nurseRecordEntryTpl) {
		$.messager.popover({msg:'��ѡ���¼��ģ�壡',type:'error'});
		$("#nurRecordEntryTpl").next('span').find('input').focus();
		return false;
	}else if (($.hisui.indexOfArray($("#nurRecordEntryTpl").combobox("getData"),"id",nurseRecordEntryTpl)<0)){
		$.messager.popover({msg:'������������ѡ���¼��ģ�壡',type:'error'});
		$("#nurRecordEntryTpl").next('span').find('input').focus();
		return false;
	}
	var signature=$("#signature").combobox("getValue");
	if (!signature) {
		$.messager.popover({msg:'��ѡ��ǩ����',type:'error'});
		$("#signature").next('span').find('input').focus();
		return false;
	}else if (($.hisui.indexOfArray($("#signature").combobox("getData"),"id",signature)<0)){
		$.messager.popover({msg:'������������ѡ��ǩ����',type:'error'});
		$("#signature").next('span').find('input').focus();
		return false;
	}
	var diseaseMeasure=$("#diseaseMeasure").combobox("getValue");
	if (!diseaseMeasure) {
		$.messager.popover({msg:'��ѡ�����ʩ��',type:'error'});
		$("#diseaseMeasure").next('span').find('input').focus();
		return false;
	}else if (($.hisui.indexOfArray($("#diseaseMeasure").combobox("getData"),"id",diseaseMeasure)<0)){
		$.messager.popover({msg:'������������ѡ�����ʩ��',type:'error'});
		$("#diseaseMeasure").next('span').find('input').focus();
		return false;
	}
	var headerEntryTpl=$("#headerEntryTpl").combobox("getValue");
	if ((headerEntryTpl)&&($.hisui.indexOfArray($("#headerEntryTpl").combobox("getData"),"id",headerEntryTpl)<0)){
		$.messager.popover({msg:'������������ѡ���б�',type:'error'});
		$("#headerEntryTpl").next('span').find('input').focus();
		return false;
	}
	var validLoc=$("#ApplyAreaLoc").combobox("getValue");
	if ((validLoc)&&($.hisui.indexOfArray($("#ApplyAreaLoc").combobox("getData"),"wardid",validLoc)<0)){
		$.messager.popover({msg:'������������ѡ����Ч���ң�',type:'error'});
		$("#ApplyAreaLoc").next('span').find('input').focus();
		return false;
	}
	var generateway=$("#GenerateWay").combobox("getValue");
	if ((generateway)&&($.hisui.indexOfArray($("#GenerateWay").combobox("getData"),"value",generateway)<0)){
		$.messager.popover({msg:'������������ѡ������ģʽ��',type:'error'});
		$("#GenerateWay").next('span').find('input').focus();
		return false;
	}
	var data={
		"id":PageLogicObj.m_TaskLinkEMRId,
		"nurseRecordEntryTpl":nurseRecordEntryTpl,
		"signature":signature,
		"diseaseMeasure":diseaseMeasure,
		"headerEntryTpl":headerEntryTpl,
		"validLoc":validLoc,
		"userId":session['LOGON.USERID'],
		"locId":session['LOGON.CTLOCID'],
		"hospID":$HUI.combogrid('#_HospList').getValue(),
		"printCode":$("#printCode").val(),
		"generateway":generateway,
	};
	$.cm({
		ClassName:"CF.NUR.NIS.EMRLinkItem",
		MethodName:"AddOrUpdateEMRLinkItem",
		data:JSON.stringify(data),
		dataType:"text"
	},function(rtn){
		if (rtn ==0){
			$("#TaskLinkEMRItemEditWin").window("close");
			$("#tabTaskLinkEMRItemList").datagrid("reload");
		}else{
			$.messager.popover({msg:'����ʧ��'+rtn,type:'error'});
			return false;
		}
	})
}
/// ����̶���Ԫ��
function SaveLinkEMRSubItemClick(){
	var fixedElement=$("#fixedElement").combobox("getValue");
	if (!fixedElement) {
		$.messager.popover({msg:'��ѡ��̶�Ԫ�أ�',type:'error'});
		$("#fixedElement").next('span').find('input').focus();
		return false;
	}else if (($.hisui.indexOfArray($("#fixedElement").combobox("getData"),"id",fixedElement)<0)){
		$.messager.popover({msg:'������������ѡ��̶�Ԫ�أ�',type:'error'});
		$("#fixedElement").next('span').find('input').focus();
		return false;
	}
	var taskItem=$("#taskItem").combobox("getValue");
	if (!taskItem) {
		$.messager.popover({msg:'��ѡ��������',type:'error'});
		$("#taskItem").next('span').find('input').focus();
		return false;
	}else if (($.hisui.indexOfArray($("#taskItem").combobox("getData"),"rowid",taskItem)<0)){
		$.messager.popover({msg:'������������ѡ�����Σ�',type:'error'});
		$("#taskItem").next('span').find('input').focus();
		return false;
	}
	var startDate=$("#enableDate").datebox("getValue");
	if (!startDate) {
		$.messager.popover({msg:'��ѡ����������',type:'error'});
		$("#enableDate").next('span').find('input').focus();
		return false;
	}
	var endDate=$("#endDate").datebox("getValue");
	if ((endDate)&&(CompareDate(startDate,endDate))){
		$.messager.popover({msg:'ͣ�����ڲ��������������ڣ�',type:'error'});
		$("#endDate").next('span').find('input').focus();
		return false;
	}
	var row = $("#tabTaskLinkEMRItemList").datagrid("getSelected");
	var pId=row.id;
	var data={
		"id":PageLogicObj.m_TaskLinkEMRSubId,
		"fixedElement":fixedElement,
		"nurseTask":taskItem,
		"startDate":startDate,
		"endDate":endDate,
		"pId":pId,
		"userId":session['LOGON.USERID'],
		"locId":session['LOGON.CTLOCID']
	}
	$.cm({
		ClassName:"CF.NUR.NIS.EMRLinkItemSub",
		MethodName:"AddOrUpdateEMRLinkItemSub",
		data:JSON.stringify(data),
		dataType:"text"
	},function(rtn){
		if (rtn ==0){
			$("#TaskLinkEMRItemSubEditWin").window("close");
			$("#tabTaskLinkEMRItemSubList").datagrid("reload");
		}else{
			$.messager.popover({msg:'����ʧ�ܣ�'+rtn,type:'error'});
			return false;
		}
	})
}
//��ʼ����Ч����
function InitApplyAreaLoc(){
	$('#ApplyAreaLoc').combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.Base.Ward&QueryName=GetallWardNew&rows=99999&ResultSetType=array",
		valueField:'wardid',
		textField:'warddesc',
		mode: "remote",
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param["q"],bizTable:"Nur_IP_EMRLinkItem",hospid:$HUI.combogrid('#_HospList').getValue()});
		}
    });
}
//��ʼ����¼��ģ��
function InitNurRecordEntryTpl(){
	$('#nurRecordEntryTpl,#headerEntryTpl').combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.NursingPlan.EMRLinkItem&QueryName=GetNurseTables&rows=99999&ResultSetType=array",
		valueField:'id',
		textField:'name',
		mode: "remote",
		onBeforeLoad:function(param){
			param = $.extend(param,{keyword:param["q"]});
		},
		onSelect:function(rec){
			if (rec){
				if ($(this)[0].id =="nurRecordEntryTpl") {
					InitTableField();
				}
			}
		},
		onChange:function(newValue, oldValue){
			if (!newValue) {
				$("#signature,#diseaseMeasure").combobox("select","");
			}
		}
    });
}
function InitfixedElement(id){
	$("#fixedElement").combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.NursingPlan.EMRLinkItem&MethodName=GetTableFieldById",
		valueField:'id',
		textField:'NewName',
		mode: "remote",
		onBeforeLoad:function(param){
			param = $.extend(param,{id:id});
		},
		loadFilter:function(data){
			// todo �Ż� �ĳ�queryֱ�ӷ�����ʾֵ
			var newData=new Array();
			for (var i=0;i<data.length;i++){
				var obj=data[i];
				obj.NewName=obj.desc+"("+obj.id+")";
				newData.push(obj);
			}
			return newData;
		}
	})
}
// ��ʼ����������
function InitTaskItem(){
	$("#taskItem").combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryTask&rows=99999&ResultSetType=array",
		valueField:'rowid',
		textField:'taskname',
		mode: "remote",
		onBeforeLoad:function(param){
			param = $.extend(param,{name:param["q"],hospitalID:$HUI.combogrid('#_HospList').getValue()});
		}
	})
}
// ��ʼ������ģʽ
function InitGenerateWay(){
	$("#GenerateWay").combobox({
		data:ServerObj.GenerateWayTypeJson,
		valueField:'value',
		textField:'text',
		mode: "local",
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param["q"],bizTable:"Nur_IP_EMRLinkItem",hospid:$HUI.combogrid('#_HospList').getValue()});
		},
		formatter: function(row){
			var opts = $(this).combobox('options');
			return row[opts.textField];
		}
	})
}

//ǩ���������ʩ���̶���ͷ ��������
function InitTableField(){
	$("#signature,#diseaseMeasure,#fixedElement").combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.NursingPlan.EMRLinkItem&MethodName=GetTableFieldById",
		valueField:'id',
		textField:'NewName',
		mode: "remote",
		onBeforeLoad:function(param){
			param = $.extend(param,{id:$("#nurRecordEntryTpl").combobox("getValue")});
		},
		loadFilter:function(data){
			// todo �Ż� �ĳ�queryֱ�ӷ�����ʾֵ
			var newData=new Array();
			for (var i=0;i<data.length;i++){
				var obj=data[i];
				obj.NewName=obj.desc+"("+obj.id+")";
				newData.push(obj);
			}
			return newData;
		}
	})
}	
function CompareDate(date1,date2){
	var date1 = myparser(date1);
	var date2 = myparser(date2); 
	if(date2<date1){  
		return true;  
	} 
	return false;
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (dtseparator=="-") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (dtseparator=="/") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(dtseparator=="/"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
