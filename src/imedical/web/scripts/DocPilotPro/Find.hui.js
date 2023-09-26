var PageLogicObj={
	m_PilotProListTabDataGrid:"",
	dw:$(window).width()-150,
	dh:$(window).height()-100
};
$(function(){
	//页面元素初始化
	PageHandle();
	//页面数据初始化
	Init();
	//加载分诊区表格数据
	PilotProListTabDataGridLoad();
	//事件初始化
	InitEvent();
});
function PageHandle(){
	//科室
	LoadDepartment();  
	//主要研究者   
	LoadStartUser();  
	//类别   
	LoadPilotCategory();  
	//多中心状态
	LoadIsHeadman(); 
	//申请事项     
    LoadApplyMatter(); 
    //申请期别    
    LoadApplyStage();  
    //状态
    LoadStatus(); 
	//跟踪审查频率
	LoadCheckFreq(); 
}
function InitEvent(){
	$("#BFind").click(PilotProListTabDataGridLoad);
	$("#BClear").click(ClearClickHander);
	$("#BExport").click(ExportClickHander)
}
function Init(){
	PageLogicObj.m_PilotProListTabDataGrid=InitPilotProListTabDataGrid();
}
function InitPilotProListTabDataGrid(){
	var toobar=[{
        text: '立项',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    },{
        text: '修改项目',
        iconCls: 'icon-write-order',
        handler: function() {UpdateClickHandle();}
    },'-',{
        text: '付款记录',
        iconCls: 'icon-fee',
        handler: function() {RemClickHandle();}
    },'-',{
        text: '免费医嘱设置',
        iconCls: 'icon-fee',
        handler: function() {FreeOrdClickHandle();}
    }];
	var Columns=[[ 
		{field:'TPPRowId',hidden:true,title:''},
		{field:'TPPCode',title:'项目编号',width:100},
		{field:'TPPDesc',title:'药物/医疗器械名称',width:200},
		{field:'TEndDate',title:'完成日期',width:80},
		{field:'TPPCreateDepartment',title:'立项科室',width:100},
		{field:'TPPStartUser',title:'负责人',width:100},
		{field:'TPPBudget',title:'项目预算',width:100},
		{field:'TPPState',title:'当前状态',width:80},
		{field:'PPSUpdateReason',title:'状态原因',width:80},
		{field:'ArchivesFilesNo',title:'档案文件夹编号',width:110},
		{field:'PlanNamenow',title:'方案名称',width:80},
		{field:'ApplicationUnitnow',title:'申请人',width:80},
		{field:'CPRCApproveDate',title:'CPRC审查日期',width:100},
		{field:'EthicsMeetDate',title:'伦理委员会上会日期',width:120},
		{field:'TEthicsMeetAduitDate',title:'伦理委员会批准日期',width:125},
		//{field:'EMADate',title:'伦理委员会批准日期',width:125},
		{field:'PPAccount',title:'账户',width:100},
		{field:'CPRCApproveResult',title:'CPRC审查意见',width:100},
		{field:'TApproveResult',title:'预审结果',width:100,
			rowStyler: function(index,row){
				if (row.TApproveResult=="N"){
					return 'background-color:#BEBEBE;';
				}
			}

		},
		{field:'TPPStartDate',title:'开始日期',width:100},
		{field:'RecordSum',title:'',hidden:true}
    ]]
	var PilotProListTabDataGrid=$("#PilotProListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'TPPRowId',
		columns :Columns,
		toolbar:toobar
	}); 
	return PilotProListTabDataGrid;
}
function PilotProListTabDataGridLoad(){
	var StatusID=$("#Status").combobox("getValue");
	if (StatusID==undefined) StatusID="";
	var CFDr=$("#CF").combobox("getValue");
	if (CFDr==undefined) CFDr="";
	var StartDate=$("#StartDate").datebox("getValue")||"",
		EndDate=$("#EndDate").datebox("getValue")||"";
	$.q({
	    ClassName : "web.PilotProject.DHCDocPilotProject",
	    QueryName : "FindProject",
	    PPCode:$("#PPCode").val(),
	    PPDesc:$("#PPDesc").val(),
	    Flag:ServerObj.Flag,
	    PlanNo:$("#PlanNo").val(),
	    PlanName:$("#PlanName").val(),
	    ApplicationUnit:$("#ApplicationUnit").val(),
	    PilotCategoryDr:$("#PilotCategory").combobox("getValue"),
	    ApprovalNo:$("#ApprovalNo").val(),
	    ApplyMatterDr:$("#ApplyMatter").combobox("getValue"),
	    ApplyStageDr:$("#ApplyStage").combobox("getValue"),
	    IsHeadmanDr:$("#IsHeadman").combobox("getValue"),
	    PPCreateDepartmentDr:$("#PPCreateDepartment").combobox("getValue"),
	    PPStartUserDr:$("#PPStartUser").combobox("getValue"),
	    Indication:$("#Indication").val(),
	    ArchivesFilesNo:$("#ArchivesFilesNo").val(),
	    Exp:StatusID+"^"+CFDr+"^"+StartDate+"^"+EndDate,
	    //StatusID:$("#Status").combobox("getValue"),
	    //CFDr:$("#CF").combobox("getValue"),
	    Pagerows:PageLogicObj.m_PilotProListTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_PilotProListTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function ClearClickHander(){
	var $input=$(":input:text");
	for (var i=0;i<$input.length;i++){
		$("#"+$input[i]["id"]).val("");
	}
	$(".hisui-combobox").combobox('select','');
	$(".hisui-datebox").datebox('setValue','');
}

function ExportClickHander () {
	var StatusID=$("#Status").combobox("getValue");
	if (StatusID==undefined) StatusID="";
	var CFDr=$("#CF").combobox("getValue");
	if (CFDr==undefined) CFDr="";
	var StartDate=$("#StartDate").datebox("getValue")||"",
		EndDate=$("#EndDate").datebox("getValue")||"";
	var PPCode=$("#PPCode").val(),
		PPDesc=$("#PPDesc").val(),
		Flag=ServerObj.Flag,
		PlanNo=$("#PlanNo").val(),
		PlanName=$("#PlanName").val(),
		ApplicationUnit=$("#ApplicationUnit").val(),
		PilotCategoryDr=$("#PilotCategory").combobox("getValue"),
		ApprovalNo=$("#ApprovalNo").val(),
		ApplyMatterDr=$("#ApplyMatter").combobox("getValue"),
		ApplyStageDr=$("#ApplyStage").combobox("getValue"),
		IsHeadmanDr=$("#IsHeadman").combobox("getValue"),
		PPCreateDepartmentDr=$("#PPCreateDepartment").combobox("getValue"),
		PPStartUserDr=$("#PPStartUser").combobox("getValue"),
		Indication=$("#Indication").val(),
		ArchivesFilesNo=$("#Indication").val(),
		Exp=StatusID+"^"+CFDr+"^"+StartDate+"^"+EndDate;
		
	var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:"PilotProject",
		ClassName:"web.PilotProject.Extend.E1",
		QueryName:"Export",
		PPCode:$("#PPCode").val(),
	    PPDesc:$("#PPDesc").val(),
	    Flag:ServerObj.Flag,
	    PlanNo:$("#PlanNo").val(),
	    PlanName:$("#PlanName").val(),
	    ApplicationUnit:$("#ApplicationUnit").val(),
	    PilotCategoryDr:$("#PilotCategory").combobox("getValue"),
	    ApprovalNo:$("#ApprovalNo").val(),
	    ApplyMatterDr:$("#ApplyMatter").combobox("getValue"),
	    ApplyStageDr:$("#ApplyStage").combobox("getValue"),
	    IsHeadmanDr:$("#IsHeadman").combobox("getValue"),
	    PPCreateDepartmentDr:$("#PPCreateDepartment").combobox("getValue"),
	    PPStartUserDr:$("#PPStartUser").combobox("getValue"),
	    Indication:$("#Indication").val(),
	    ArchivesFilesNo:$("#ArchivesFilesNo").val(),
	    Exp:StatusID+"^"+CFDr+"^"+StartDate+"^"+EndDate
	},false);
	
	//var rtn = tkMakeServerCall("websys.Query","ToExcel","PilotProject2","web.PilotProject.Extend.E1","Export",PPCode,PPDesc,Flag,PlanNo,PlanName,ApplicationUnit,PilotCategoryDr,ApprovalNo,ApplyMatterDr,ApplyStageDr,IsHeadmanDr,PPCreateDepartmentDr,PPStartUserDr,Indication,ArchivesFilesNo,Exp);
	
	location.href = rtn;	
}

function LoadDepartment(){
	$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"FindLoc",
		dataType:"json",
		Loc:"",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#PPCreateDepartment", {
				valueField: 'RowId',
				textField: 'Desc', 
				editable:true,
				data: Data["rows"],
				onChange:function(newValue,OldValue){
					if (newValue==""){
						var cbox = $HUI.combobox("#PPCreateDepartment");
						cbox.select("");
					}
				},
				filter: function(q, row){
					q=q.toUpperCase();
					return (row["Desc"].toUpperCase().indexOf(q) >= 0)||(row["Alias"].toUpperCase().indexOf(q) >= 0);
				}
		 });
	}); 
	
}
function LoadStartUser(){
	$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"FindStartUser",
		dataType:"json",
		PPStartUser:"",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#PPStartUser", {
				valueField: 'Hidden',
				textField: 'Desc', 
				editable:true,
				data: Data["rows"],
				onChange:function(newValue,OldValue){
					if (newValue==""){
						var cbox = $HUI.combobox("#PPStartUser");
						cbox.select("");
					}
				},
				filter: function(q, row){
					q=q.toUpperCase();
					return (row["Desc"].toUpperCase().indexOf(q) >= 0)||(row["SSUSRInitials"].toUpperCase().indexOf(q) >= 0);
				}
		 });
	}); 
}
function LoadPilotCategory(){
	$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"FindDefineData",
		dataType:"json",
		MDesc:"科研药理",
		DDesc:"类别",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#PilotCategory", {
			valueField: 'rowid',
			textField: 'Desc', 
			editable:true,
			data: Data["rows"],
			onChange:function(newValue,OldValue){
					if (newValue==""){
						var cbox = $HUI.combobox("#PilotCategory");
						cbox.select("");
					}
				}
		 });
	}); 
	
}
function LoadIsHeadman(){
	$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"FindDefineData",
		dataType:"json",
		MDesc:"科研药理",
		DDesc:"是否是组长",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#IsHeadman", {
				valueField: 'rowid',
				textField: 'Desc', 
				editable:false,
				data: Data["rows"],
				onChange:function(newValue,OldValue){
					if (newValue==""){
						var cbox = $HUI.combobox("#IsHeadman");
						cbox.select("");
					}
				}
		 });
	}); 
	
}
function LoadApplyMatter(){
	$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"FindDefineData",
		dataType:"json",
		MDesc:"科研药理",
		DDesc:"申请事项",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#ApplyMatter", {
				valueField: 'rowid',
				textField: 'Desc', 
				editable:true,
				data: Data["rows"],
				onChange:function(newValue,OldValue){
					if (newValue==""){
						var cbox = $HUI.combobox("#ApplyMatter");
						cbox.select("");
					}
				}
		 });
	}); 
}
function LoadApplyStage(){
	$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"FindDefineData",
		dataType:"json",
		MDesc:"科研药理",
		DDesc:"申请期",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#ApplyStage", {
				valueField: 'rowid',
				textField: 'Desc', 
				editable:true,
				data: Data["rows"],
				onChange:function(newValue,OldValue){
					if (newValue==""){
						var cbox = $HUI.combobox("#ApplyStage");
						cbox.select("");
					}
				}
		 });
	}); 
}
function LoadCheckFreq(){
	$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"FindDefineData",
		dataType:"json",
		MDesc:"科研药理",
		DDesc:"跟踪审查频率",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#CF", {
				valueField: 'rowid',
				textField: 'Desc', 
				editable:true,
				data: Data["rows"],
				onChange:function(newValue,OldValue){
					if (newValue==""){
						var cbox = $HUI.combobox("#CF");
						cbox.select("");
						//cbox.setValue("");
					}
				}
		 });
	}); 
}
function LoadStatus(){
	var cbox = $HUI.combobox("#Status", {
			valueField: 'rowid',
			textField: 'Desc', 
			editable:true,
			data: [
				{"rowid":"N","Desc":"立项"}
				,{"rowid":"H","Desc":"未进行"}
				,{"rowid":"V","Desc":"在研"}
				,{"rowid":"P","Desc":"发补后在研"}
				,{"rowid":"F","Desc":"已完成"}
				,{"rowid":"A","Desc":"暂停"}
				,{"rowid":"S","Desc":"终止"}
				,{"rowid":"B","Desc":"中止"}
				,{"rowid":"I","Desc":"审批中"}
				,{"rowid":"D","Desc":"上会未通过"}
			],
			onChange:function(newValue,OldValue){
				if (newValue==""){
					var cbox = $HUI.combobox("#Status");
					cbox.select("");
				}
			}
	 });
}
function AddClickHandle(){
	var Flag=ServerObj.Flag;
	var src="docpilotpro.project.hui.csp?PPRowId="+"&Flag=";
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Project","临床试验立项", '1010', '450',"icon-w-add","",$code,"");
}
function RemClickHandle(){
	var row=PageLogicObj.m_PilotProListTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择项目!");
		return false;
	}
	var PPRowId=row["TPPRowId"];
	var PPDesc=row["TPPDesc"];
	var src="docpilotpro.rem.hui.csp?PPRowId="+PPRowId;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Project","药理项目:"+PPDesc, PageLogicObj.dw, PageLogicObj.dh,"icon-w-edit","",$code,"");
}
function FreeOrdClickHandle(){
	var row=PageLogicObj.m_PilotProListTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择项目!");
		return false;
	}
	var PPRowId=row["TPPRowId"];
	var PPDesc=row["TPPDesc"];
	var src="docpilotpro.freeordset.hui.csp?PPRowId="+PPRowId;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Project","药理项目:"+PPDesc, PageLogicObj.dw, PageLogicObj.dh,"icon-w-edit","",$code,"");
}
function UpdateClickHandle(){
	var row=PageLogicObj.m_PilotProListTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要修改的项目!");
		return false;
	}
	var PPRowId=row["TPPRowId"];
	var Flag=ServerObj.Flag; 
	var PPDesc=row["TPPDesc"];
	var src="docpilotpro.project.hui.csp?PPRowId="+PPRowId+"&Flag="+Flag;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Project",PPDesc+" 药理项目修改", '1030', '450',"icon-w-update","",$code,"");
	//todo 以下药理中心关系系统相关界面 
	/*if ((Flag=="ProApprove")||(Flag=="CPRCApprove")||(Flag=="Sign")||(Flag=="SignModify")){
		var EthicsMeetAduitDate=row["TEthicsMeetAduitDate"];
		var CPRCApproveResult=row["TCPRCApproveResult"];
		src=src+"&PPRowId="+PPRowId+"&Flag="+Flag+"&EthicsMeetAduitDate="+EthicsMeetAduitDate+"&CPRCApproveResult="+CPRCApproveResult;
	}
	var ApproveResult=row["TApproveResult"];
	if (Flag=="EcApprove"){
		if (ApproveResult=="Y")  var PrePass=1  
		else PrePass=0
		src=src+"&PPRowId="+PPRowId+"&PrePass="+PrePass+"&Flag="+Flag;
	}else if(Flag=="Pay"){
		src=src+"&PPRowId="+PPRowId+"&Flag="+Flag+"&PPDesc="+PPDesc;
	}else if(Flag=="ConfirmPay"){
		src=src+"&PPRowId="+PPRowId+"&Flag="+Flag;
	}else if (Flag=="SAE"){
		src=src+"&PPRowId="+PPRowId+"&Flag="+Flag;
	}else if (Flag=="FileManage"){
		src=src+"&PPRowId="+PPRowId+"&Flag="+Flag;
	}else if (Flag=="Exam"){
		src=src+"&PPRowId="+PPRowId+"&Flag="+Flag;
	}else if ((Flag=="Settle")&&(PPRowId=="")){
		src=src+"&PPRowId="+PPRowId+"&Flag="+Flag;
	}else if ((Flag=="Settle")&&(PPRowId!="")){
		src=src+"&PPRowId="+PPRowId+"&Flag="+Flag;
	}else if(Flag=="YearCheck"){
		src=src+"&PPRowId="+PPRowId+"&Flag="+Flag;
	}else if(Flag=="Other"){
		src=src+"&PPRowId="+PPRowId+"&Flag="+Flag;
	}else if(Flag=="QCYW"){
		src=src+"&PPRowId="+PPRowId+"&Flag="+Flag;
	}else if(Flag=="QCDA"){
		src=src+"&PPRowId="+PPRowId+"&Flag="+Flag;
	}else if(Flag=="QCZYZ"){
		src=src+"&PPRowId="+PPRowId+"&Flag="+Flag;
	}*/
	
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}
function destroyDialog(id){
   //移除存在的Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
