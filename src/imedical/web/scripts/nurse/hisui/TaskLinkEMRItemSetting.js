/**
* @author songchunli
* HISUI 护理记录固定表头配置主js
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
	//初始化表单录入模板
	InitNurRecordEntryTpl();
	//初始化生效科室
	InitApplyAreaLoc();
	// 初始化护嘱任务
	InitTaskItem();
	// 初始化生成模式
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
		content:"<p>只有表单录入模板存在动态表头的才需配置列表模板。</p>",
		style:'inverse'
	});
	
	// 打印模板说明
	$("#printCode_tip").popover({
		trigger:'hover',
		content:"<p>需要生成图片才需要配置打印模板关键字。</p>",
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
	// 初始化 状态查询条件
	InitTaskLinkEMRItemList();
}
function InitTaskLinkEMRItemList(){
	var ToolBar = [{
			text: '新增',
			iconCls: 'icon-add',
			handler: function() {
				$("#printCode").val("")
				PageLogicObj.m_TaskLinkEMRId="";
				$("#TaskLinkEMRItemEditWin").window("setTitle","新增护理记录表头数据配置").window('open');
			}
	},{
		text: '修改',
		iconCls: 'icon-write-order',
		handler: function() {
			var row = $("#tabTaskLinkEMRItemList").datagrid("getSelected");
			if (!row) {
				$.messager.popover({msg:'请选择需要修改的记录！',type:'error'});
				return false;
			}
			ShowTaskLinkEMRItemEditWin(row);
		}
	},{
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			var row = $("#tabTaskLinkEMRItemList").datagrid("getSelected");
			if (!row) {
				$.messager.popover({msg:'请选择需要删除的记录！',type:'error'});
				return false;
			}
			$.messager.confirm('确认对话框', '确认要删除此条护理记录表头数据配置吗？若含有子元素也会被一同删除。', function(r){
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
							$.messager.popover({msg:'删除失败！'+rtn,type:'error'});
						}
					})
				}
			});	
		}
    },'-',];
	var Columns=[[ 
		{ field: 'nurseRecordEntryTpl',title:'表单录入模板',width:130,wordBreak:"break-all"},
		{ field: 'signature',title:'签名',width:120},
		{ field: 'diseaseMeasure',title:'病情措施',width:150,wordBreak:"break-all"},
		{ field: 'headerEntryTpl',title:'列表模板',width:150,wordBreak:"break-all"},
		{ field: 'locsName',title:'生效科室',width:150,wordBreak:"break-all"},
		{ field: 'printCode',title:'打印模板',width:150,wordBreak:"break-all"},
		{ field: 'generateway',title:'生成模式',width:150,wordBreak:"break-all"
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
		loadMsg : '加载中..',  
		pagination : true, 
		idField:"id",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*此处为false*/
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
			text: '新增',
			iconCls: 'icon-add',
			handler: function() {
				PageLogicObj.m_TaskLinkEMRSubId="";
				$("#enableDate").datebox("setValue",ServerObj.CurrentDate);
				$("#TaskLinkEMRItemSubEditWin").window("setTitle","新增护理记录表头子项数据配置").window('open');
			}
	},{
		text: '修改',
		iconCls: 'icon-write-order',
		handler: function() {
			var row = $("#tabTaskLinkEMRItemSubList").datagrid("getSelected");
			if (!row) {
				$.messager.popover({msg:'请选择需要修改的记录！',type:'error'});
				return false;
			}
			ShowTaskLinkEMRItemSubEditWin(row);
		}
	},{
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			var row = $("#tabTaskLinkEMRItemSubList").datagrid("getSelected");
			if (!row) {
				$.messager.popover({msg:'请选择需要删除的记录！',type:'error'});
				return false;
			}
			$.messager.confirm('确认对话框', '确认要删除此条护理记录表头子项数据配置吗？', function(r){
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
							$.messager.popover({msg:'删除失败！'+rtn,type:'error'});
						}
					})
				}
			});	
		}
	},'-'];
	var Columns=[[ 
		{ field: 'fixedElement',title:'固定元素',width:200,wordBreak:"break-all"},
		{ field: 'nurseTask',title:'护理任务',width:200,wordBreak:"break-all"},
		{ field: 'status',title:'状态',width:70}
	]];
	PageLogicObj.m_tabTaskLinkEMRItemSubListGrid=$('#tabTaskLinkEMRItemSubList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true, 
		idField:"id",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*此处为false*/
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
	//通过id护理记录表头数据配置
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

		$("#TaskLinkEMRItemEditWin").window("setTitle","修改护理记录表头数据配置").window('open');
	})
}
function ShowTaskLinkEMRItemSubEditWin(row){
	PageLogicObj.m_TaskLinkEMRSubId=row.id;
	setTimeout(function() {
		// 通过id获取护理记录表头子表数据配置
		$.cm({
			ClassName:"Nur.NIS.Service.NursingPlan.EMRLinkItemSub",
			MethodName:"GetEMRLinkItemSubById",
			id:row.id
		},function(JsonData){
			$("#fixedElement").combobox("setValue",JsonData.fixedElement);
			$("#taskItem").combobox("setValue",JsonData.nurseTask);
			$("#enableDate").datebox("setValue",JsonData.startDate);
			$("#endDate").datebox("setValue",JsonData.endDate);
			$("#TaskLinkEMRItemSubEditWin").window("setTitle","修改护理记录表头子项数据配置").window('open');			
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
// 保存护理记录单配置
function SaveLinkEMRClick(){
	var nurseRecordEntryTpl=$("#nurRecordEntryTpl").combobox("getValue");
	if (!nurseRecordEntryTpl) {
		$.messager.popover({msg:'请选择表单录入模板！',type:'error'});
		$("#nurRecordEntryTpl").next('span').find('input').focus();
		return false;
	}else if (($.hisui.indexOfArray($("#nurRecordEntryTpl").combobox("getData"),"id",nurseRecordEntryTpl)<0)){
		$.messager.popover({msg:'请在下拉框中选择表单录入模板！',type:'error'});
		$("#nurRecordEntryTpl").next('span').find('input').focus();
		return false;
	}
	var signature=$("#signature").combobox("getValue");
	if (!signature) {
		$.messager.popover({msg:'请选择签名！',type:'error'});
		$("#signature").next('span').find('input').focus();
		return false;
	}else if (($.hisui.indexOfArray($("#signature").combobox("getData"),"id",signature)<0)){
		$.messager.popover({msg:'请在下拉框中选择签名！',type:'error'});
		$("#signature").next('span').find('input').focus();
		return false;
	}
	var diseaseMeasure=$("#diseaseMeasure").combobox("getValue");
	if (!diseaseMeasure) {
		$.messager.popover({msg:'请选择病情措施！',type:'error'});
		$("#diseaseMeasure").next('span').find('input').focus();
		return false;
	}else if (($.hisui.indexOfArray($("#diseaseMeasure").combobox("getData"),"id",diseaseMeasure)<0)){
		$.messager.popover({msg:'请在下拉框中选择病情措施！',type:'error'});
		$("#diseaseMeasure").next('span').find('input').focus();
		return false;
	}
	var headerEntryTpl=$("#headerEntryTpl").combobox("getValue");
	if ((headerEntryTpl)&&($.hisui.indexOfArray($("#headerEntryTpl").combobox("getData"),"id",headerEntryTpl)<0)){
		$.messager.popover({msg:'请在下拉框中选择列表！',type:'error'});
		$("#headerEntryTpl").next('span').find('input').focus();
		return false;
	}
	var validLoc=$("#ApplyAreaLoc").combobox("getValue");
	if ((validLoc)&&($.hisui.indexOfArray($("#ApplyAreaLoc").combobox("getData"),"wardid",validLoc)<0)){
		$.messager.popover({msg:'请在下拉框中选择生效科室！',type:'error'});
		$("#ApplyAreaLoc").next('span').find('input').focus();
		return false;
	}
	var generateway=$("#GenerateWay").combobox("getValue");
	if ((generateway)&&($.hisui.indexOfArray($("#GenerateWay").combobox("getData"),"value",generateway)<0)){
		$.messager.popover({msg:'请在下拉框中选择生成模式！',type:'error'});
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
			$.messager.popover({msg:'保存失败'+rtn,type:'error'});
			return false;
		}
	})
}
/// 保存固定子元素
function SaveLinkEMRSubItemClick(){
	var fixedElement=$("#fixedElement").combobox("getValue");
	if (!fixedElement) {
		$.messager.popover({msg:'请选择固定元素！',type:'error'});
		$("#fixedElement").next('span').find('input').focus();
		return false;
	}else if (($.hisui.indexOfArray($("#fixedElement").combobox("getData"),"id",fixedElement)<0)){
		$.messager.popover({msg:'请在下拉框中选择固定元素！',type:'error'});
		$("#fixedElement").next('span').find('input').focus();
		return false;
	}
	var taskItem=$("#taskItem").combobox("getValue");
	if (!taskItem) {
		$.messager.popover({msg:'请选择护理任务！',type:'error'});
		$("#taskItem").next('span').find('input').focus();
		return false;
	}else if (($.hisui.indexOfArray($("#taskItem").combobox("getData"),"rowid",taskItem)<0)){
		$.messager.popover({msg:'请在下拉框中选择护理任！',type:'error'});
		$("#taskItem").next('span').find('input').focus();
		return false;
	}
	var startDate=$("#enableDate").datebox("getValue");
	if (!startDate) {
		$.messager.popover({msg:'请选择启用日期',type:'error'});
		$("#enableDate").next('span').find('input').focus();
		return false;
	}
	var endDate=$("#endDate").datebox("getValue");
	if ((endDate)&&(CompareDate(startDate,endDate))){
		$.messager.popover({msg:'停用日期不能晚于启用日期！',type:'error'});
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
			$.messager.popover({msg:'保存失败！'+rtn,type:'error'});
			return false;
		}
	})
}
//初始化生效科室
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
//初始化表单录入模板
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
			// todo 优化 改成query直接返回显示值
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
// 初始化护嘱任务
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
// 初始化生成模式
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

//签名、病情措施、固定表头 下拉数据
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
			// todo 优化 改成query直接返回显示值
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
