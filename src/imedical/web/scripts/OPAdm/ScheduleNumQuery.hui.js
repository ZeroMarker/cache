var PageLogicObj={
	m_ScheduleNumQueryTabDataGrid:"",
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
	ScheduleNumQueryTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_ScheduleNumQueryTabDataGrid=InitScheduleNumQueryTabDataGrid();
}
function InitScheduleNumQueryTabDataGrid(){
	var Columns=[[ 
		{field:'TLoc',title:'科室',width:120},
		{field:'TDoc',title:'医生',width:120},
		{field:'TTimeRange',title:'时间段',width:140},
		{field:'TRegLoadNum',title:'正号数',width:100},
		{field:'TOverbookNum',title:'加减号数',width:90},
		{field:'TRegNum',title:'挂出数',width:90},
		{field:'TRemainNum',title:'剩余号数',width:90},
		{field:'TDate',title:'日期',width:100},
		{field:'TAddRegNum',title:'加减诊数量',width:90},
		{field:'TReplaceNum',title:'替诊数量',width:90},
		//{field:'TRepairNum',title:'补诊数量',width:90},
		{field:'TStopNum',title:'停诊数量',width:90},
		{field:'TPStopNum',title:'中途停诊数量',width:90},
		{field:'TTRNum',title:'被替诊数量',width:90},
		//{field:'TFNum',title:'锁定数量',width:90}
    ]]
	var ScheduleNumQueryTabDataGrid=$("#ScheduleNumQueryTab").datagrid({
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
	return ScheduleNumQueryTabDataGrid;
}
function InitEvent(){
	$('#BFind').click(ScheduleNumQueryTabDataGridLoad);
}
function PageHandle(){
	$("#StDate,#EndDate").datebox('setValue',ServerObj.CurDay);
	InitTimeRange();
	InitLoc();
	InitDoc();
	InitSessionType();
}
function ScheduleNumQueryTabDataGridLoad(){
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
	    ClassName : "web.DHCOPAdmRegQuery",
	    QueryName : "RegNumQuery",
	    StartDate:$("#StDate").datebox('getValue'), EndDate:$("#EndDate").datebox('getValue'),
	    LocID:PageLogicObj.m_deptRowId, DocID:PageLogicObj.m_DocRowId,
	    TimeRangeID:PageLogicObj.m_TimeRangeRowId,
	    SessionTypeID:PageLogicObj.m_SessionTypeRowId, OnlyLocTotal:$("#OnlyLocTotal").checkbox('getValue')?'on':'',
	    DocDesc:PageLogicObj.m_DocRowId,
	    Pagerows:PageLogicObj.m_ScheduleNumQueryTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ScheduleNumQueryTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
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
				$("#DocDesc").lookup('setText','');
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