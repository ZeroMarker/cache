var PageLogicObj={
	m_RBAppointmentQueryTabDataGrid:"",
	m_deptRowId:"",
	m_DocRowId:"",
	m_SessionTypeRowId:"",
	m_TimeRangeRowId:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	//表格数据初始化
	RBAppointmentQueryTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_RBAppointmentQueryTabDataGrid=InitRBAppointmentQueryTabDataGrid();
}
function InitRBAppointmentQueryTabDataGrid(){
	var Columns=[[ 
		{field:'TLoc',title:'科室',width:120},
		{field:'TDoc',title:'医生',width:100},
		{field:'TTimeRange',title:'时间段',width:140},
		{field:'TPatNo',title:'登记号',width:150},
		{field:'TPatientName',title:'患者姓名',width:150},
		{field:'TAppNum',title:'预约',width:90},
		{field:'TRegNum',title:'取号',width:90},
		{field:'TCancelNum',title:'取消',width:90},
		{field:'THYNum',title:'爽约',width:100},
		{field:'TAppTDateAndTime',title:'预约日期',width:150},
		{field:'TAPPTStatusDesc',title:'状态',width:48,
			styler: function(value,row,index){
				if (value == "取消"){
					return 'background-color:#BFBFBF;color:white;';
				} else if (value == "取号") {
					return 'background-color:#33CC66;color:white;';
				} else if (value == "爽约") {
					return 'background-color:red;color:white;';
				}
			}
		},
		{field:'TAppTLastStatusDateAndTime',title:'取号/取消预约日期',width:150},
		{field:'TAPPTLastStatusUserDesc',title:'取号/取消预约操作员',width:70},
		{field:'TAppTSeqNo',title:'预约序号',width:90},
		{field:'TAdmDate',title:'就诊日期',width:90},
		{field:'TAppUserDesc',title:'预约操作员',width:90},
		{field:'TPrice',title:'价格',width:90},
		{field:'TPoliticalLevel',title:'患者级别',width:90},
		{field:'TSecretLevel',title:'患者密级',width:90},
		{field:'TTel',title:'联系电话',width:110}
    ]]
	var RBAppointmentQueryTabDataGrid=$("#RBAppointmentQueryTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		rownumbers:true,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 30,
		pageList : [30,100,200],
		idField:'TTimeRange',
		columns :Columns
	});
	return RBAppointmentQueryTabDataGrid;
}
function InitEvent(){
	$('#BFind').click(RBAppointmentQueryTabDataGridLoad);
	$('#PrintRQ').click(function(){
		ExportPrintCom("Print");
	}); //PrintRQ_Change
	$('#ExportRQ').click(function(){
		ExportPrintCom("Export");
	}); //ExportRQ_Change
}
function PrintRQ_Change(){
	var StartDate=$("#StDate").datebox('getValue')
	var EndDate=$("#EndDate").datebox('getValue')
	var LocID=PageLogicObj.m_deptRowId;
	var DocID=PageLogicObj.m_DocRowId;
	var TimeRangeID=PageLogicObj.m_TimeRangeRowId;
	var SessionTypeID=PageLogicObj.m_SessionTypeRowId;
	var OnlyLocTotal=$("#OnlyLocTotal").checkbox('getValue')?'on':'';
	var DocDesc=PageLogicObj.m_DocRowId;
	
	fileName="newyyxxlbcx.raq&StartDate="+StartDate+"&EndDate="+EndDate+"&LocID="+LocID+"&DocID="+DocID+"&TimeRangeID="+TimeRangeID+"&SessionTypeID="+SessionTypeID+"&OnlyLocTotal="+OnlyLocTotal+"&DocDesc="+DocDesc;
	DHCCPM_RQPrint(fileName,800,500);
}
function PageHandle(){
	$("#StDate,#EndDate").datebox('setValue',ServerObj.CurDay);
	InitTimeRange();
	InitLoc();
	InitDoc();
	InitSessionType();
}
function RBAppointmentQueryTabDataGridLoad(){
	if ($("#LocDesc").lookup('getText')==""){
		PageLogicObj.m_deptRowId="";
	}
	if ($("#DocDesc").lookup('getText')==""){
		PageLogicObj.m_DocRowId="";
	}
	if ($("#SessionType").lookup('getText')==""){
		PageLogicObj.m_SessionTypeRowId="";
	}
	if ($("#TimeRange").lookup('getText')==""){
		PageLogicObj.m_TimeRangeRowId="";
	}
	$.q({
	    ClassName : "web.DHCRBAppointmentQuery",
	    QueryName : "AppointmentNumQuery",
	    StartDate:$("#StDate").datebox('getValue'), EndDate:$("#EndDate").datebox('getValue'),
	    LocID:PageLogicObj.m_deptRowId, DocID:PageLogicObj.m_DocRowId,
	    TimeRangeID:PageLogicObj.m_TimeRangeRowId,
	    SessionTypeID:PageLogicObj.m_SessionTypeRowId, OnlyLocTotal:$("#OnlyLocTotal").checkbox('getValue')?'on':'',
	    DocDesc:PageLogicObj.m_DocRowId,
	    Pagerows:PageLogicObj.m_RBAppointmentQueryTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_RBAppointmentQueryTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function InitTimeRange(){
	$("#TimeRange").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'Desc',
        columns:[[  
            {field:'HIDDEN',title:'',hidden:true},
			{field:'Desc',title:'名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCOPAdmRegQuery',QueryName: 'SearchTimeRange'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{TimeRange:desc});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
			    PageLogicObj.m_TimeRangeRowId=rec["HIDDEN"];
			});
		}
    });
}
function InitLoc(){
	$("#LocDesc").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'rowid',
        textField:'OPLocdesc',
        columns:[[  
            {field:'rowid',title:'',hidden:true},
			{field:'OPLocdesc',title:'科室名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCOPReg',QueryName: 'OPLoclookup'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{desc:desc, hospid:session['LOGON.HOSPID']});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
			    PageLogicObj.m_deptRowId=rec["rowid"];
				$("#DocDesc").lookup('setText',"");
				PageLogicObj.m_DocRowId="";
			});
		}
    });
}
function InitDoc(){
	$("#DocDesc").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'rowid',
        textField:'OPLocdesc',
        columns:[[  
            {field:'rowid',title:'',hidden:true},
			{field:'OPLocdesc',title:'名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCOPRegReports',QueryName: 'OPDoclookup'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if ($("#LocDesc").lookup('getText')==""){
				PageLogicObj.m_deptRowId="";
			}
			param = $.extend(param,{locid:PageLogicObj.m_deptRowId,DocDesc:desc});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
			    PageLogicObj.m_DocRowId=rec["rowid"];
			});
		}
    });
}
function InitSessionType(){
	$("#SessionType").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'Desc',
        columns:[[  
            {field:'HIDDEN',title:'',hidden:true},
			{field:'Desc',title:'名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCOPAdmRegQuery',QueryName: 'SearchSessionType'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{Desc:desc});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
			    PageLogicObj.m_SessionTypeRowId=rec["HIDDEN"];
			});
		}
    });
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
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
function ExportRQ_Change() {
	var Data=PageLogicObj.m_RBAppointmentQueryTabDataGrid.datagrid("getRows");
	if (Data.length==0){
		$.messager.alert("提示","请查询出数据后导出!");
		return false;
	}
	var StartDate=$("#StDate").datebox('getValue')
	var EndDate=$("#EndDate").datebox('getValue')
	var LocDesc=$("#LocDesc").lookup('getText');
	var DocDesc=$("#DocDesc").lookup('getText');
	var TimeRange=$("#TimeRange").lookup('getText');
	var SessionType=$("#SessionType").lookup('getText');
	var FileName=StartDate+"至"+EndDate+LocDesc+DocDesc+SessionType+TimeRange+"RBQuery";
	if ($("#LocDesc").lookup('getText')==""){
		PageLogicObj.m_deptRowId="";
	}
	if ($("#DocDesc").lookup('getText')==""){
		PageLogicObj.m_DocRowId="";
	}
	if ($("#SessionType").lookup('getText')==""){
		PageLogicObj.m_SessionTypeRowId="";
	}
	if ($("#TimeRange").lookup('getText')==""){
		PageLogicObj.m_TimeRangeRowId="";
	}
	var rtn = $cm({
		dataType:'text',
		ResultSetType:'Excel',
		ExcelName:'预约信息一览表',
		ClassName:"web.DHCRBAppointmentQuery",
		QueryName:"AppointmentNumQueryExport",
		StartDate:$("#StDate").datebox('getValue'), 
		EndDate:$("#EndDate").datebox('getValue'),
		LocID:PageLogicObj.m_deptRowId,
		DocID:PageLogicObj.m_DocRowId,
		TimeRangeID:PageLogicObj.m_TimeRangeRowId,
		SessionTypeID:PageLogicObj.m_SessionTypeRowId,
		OnlyLocTotal:$("#OnlyLocTotal").checkbox('getValue')?'on':'',
		DocDesc:PageLogicObj.m_DocRowId
	}, false);
	location.href = rtn;
}
function ExportPrintCom(ResultSetTypeDo){
	var Data=PageLogicObj.m_RBAppointmentQueryTabDataGrid.datagrid("getRows");
	if (Data.length==0){
		if (ResultSetTypeDo=="Export"){
			$.messager.alert("提示","请查询出数据后导出!");
		}else{
			$.messager.alert("提示","请查询出数据后打印!");	
		}
		return false;
	}
	var StartDate=$("#StDate").datebox('getValue')
	var EndDate=$("#EndDate").datebox('getValue')
	var LocDesc=$("#LocDesc").lookup('getText');
	var DocDesc=$("#DocDesc").lookup('getText');
	var TimeRange=$("#TimeRange").lookup('getText');
	var SessionType=$("#SessionType").lookup('getText');
	var FileName=StartDate+"至"+EndDate+LocDesc+DocDesc+SessionType+TimeRange+"RBQuery";
	if ($("#LocDesc").lookup('getText')==""){
		PageLogicObj.m_deptRowId="";
	}
	if ($("#DocDesc").lookup('getText')==""){
		PageLogicObj.m_DocRowId="";
	}
	if ($("#SessionType").lookup('getText')==""){
		PageLogicObj.m_SessionTypeRowId="";
	}
	if ($("#TimeRange").lookup('getText')==""){
		PageLogicObj.m_TimeRangeRowId="";
	}
	$.cm({
		 ResultSetTypeDo:ResultSetTypeDo,
	     ExcelName:"预约信息一览表",
	     ResultSetType:"ExcelPlugin",
	     localDir:ResultSetTypeDo=="Export"?"Self":"",//用户选择路径
	     ClassName : "web.DHCRBAppointmentQuery",
	     QueryName : "AppointmentNumQueryExport",
	     StartDate:$("#StDate").datebox('getValue'), 
		 EndDate:$("#EndDate").datebox('getValue'),
		 LocID:PageLogicObj.m_deptRowId,
		 DocID:PageLogicObj.m_DocRowId,
		 TimeRangeID:PageLogicObj.m_TimeRangeRowId,
		 SessionTypeID:PageLogicObj.m_SessionTypeRowId,
		 OnlyLocTotal:$("#OnlyLocTotal").checkbox('getValue')?'on':'',
		 DocDesc:PageLogicObj.m_DocRowId,
	     rows:99999
	 },false);
}
