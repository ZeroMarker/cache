var PageLogicObj={
	m_RBAppointmentQueryTabDataGrid:"",
	m_deptRowId:"",
	m_DocRowId:"",
	m_SessionTypeRowId:"",
	m_TimeRangeRowId:""
};
$(function(){
	//��ʼ��
	Init();
	//�¼���ʼ��
	InitEvent();
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
	//������ݳ�ʼ��
	RBAppointmentQueryTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_RBAppointmentQueryTabDataGrid=InitRBAppointmentQueryTabDataGrid();
}
function InitRBAppointmentQueryTabDataGrid(){
	var Columns=[[ 
		{field:'TLoc',title:'����',width:120},
		{field:'TDoc',title:'ҽ��',width:100},
		{field:'TTimeRange',title:'ʱ���',width:140},
		{field:'TPatientName',title:'��������',width:150},
		{field:'TAppNum',title:'ԤԼ',width:90},
		{field:'TRegNum',title:'ȡ��',width:90},
		{field:'TCancelNum',title:'ȡ��',width:90},
		{field:'THYNum',title:'ˬԼ',width:100},
		{field:'TAppTDateAndTime',title:'ԤԼ����',width:150},
		{field:'TAppTLastStatusDateAndTime',title:'ȡ������',width:150},
		{field:'TAppTSeqNo',title:'ԤԼ���',width:90},
		{field:'TPoliticalLevel',title:'���߼���',width:90},
		{field:'TSecretLevel',title:'�����ܼ�',width:90},
		{field:'TTel',title:'��ϵ�绰',width:90}
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
			{field:'Desc',title:'����',width:350}
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
			{field:'OPLocdesc',title:'��������',width:350}
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
			{field:'OPLocdesc',title:'����',width:350}
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
			{field:'Desc',title:'����',width:350}
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
	var StartDate=$("#StDate").datebox('getValue')
	var EndDate=$("#EndDate").datebox('getValue')
	var LocDesc=$("#LocDesc").lookup('getText');
	var DocDesc=$("#DocDesc").lookup('getText');
	var TimeRange=$("#TimeRange").lookup('getText');
	var SessionType=$("#SessionType").lookup('getText');
	var FileName=StartDate+"��"+EndDate+LocDesc+DocDesc+SessionType+TimeRange+"RBQuery";
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
		ExcelName:'ԤԼ��Ϣһ����',
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
	var StartDate=$("#StDate").datebox('getValue')
	var EndDate=$("#EndDate").datebox('getValue')
	var LocDesc=$("#LocDesc").lookup('getText');
	var DocDesc=$("#DocDesc").lookup('getText');
	var TimeRange=$("#TimeRange").lookup('getText');
	var SessionType=$("#SessionType").lookup('getText');
	var FileName=StartDate+"��"+EndDate+LocDesc+DocDesc+SessionType+TimeRange+"RBQuery";
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
	     ExcelName:"ԤԼ��Ϣһ����",
	     ResultSetType:"ExcelPlugin",
	     localDir:ResultSetTypeDo=="Export"?"Self":"",//�û�ѡ��·��
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