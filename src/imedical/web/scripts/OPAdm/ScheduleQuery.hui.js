var PageLogicObj={
	m_ScheduleQueryTabDataGrid:"",
	m_DocRowId:"",
	m_deptRowId:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	//表格数据初始化
	ScheduleQueryTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_ScheduleQueryTabDataGrid=InitScheduleQueryTabDataGrid();
}
function InitScheduleQueryTabDataGrid(){
	var Columns=[[ 
		{field:'TLocDesc',title:'科室',width:120},
		{field:'TDocDesc',title:'医生',width:120},
		{field:'TReason',title:'停替诊原因',width:100},
		{field:'TDate',title:'出诊时间',width:100},
		{field:'TSessType',title:'职称',width:90},
		/*{field:'TQty1',title:'上午号数',width:90},
		{field:'TQty2',title:'下午号数',width:90},
		{field:'TQty3',title:'夜间号数',width:90},*/
		{field:'TTimeRange',title:'时段',width:90},
		{field:'TQty',title:'号数',width:90},
		{field:'TStatus',title:'状态',width:90}
    ]]
	var ScheduleQueryTabDataGrid=$("#ScheduleQueryTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 30,
		pageList : [30,100,200],
		idField:'TDocDesc',
		columns :Columns
	});
	return ScheduleQueryTabDataGrid;
}
function InitEvent(){
	$('#BFind').click(ScheduleQueryTabDataGridLoad);
	$('#BPrint').click(PrintClickHandle);
}
function PageHandle(){
	InitLoc();
	InitDoc();
	InitReason();
	InitStatus();
}
function ScheduleQueryTabDataGridLoad(){
	if ($("#Loc").lookup('getText')==""){
		PageLogicObj.m_deptRowId="";
	}
	if ($("#Doc").lookup('getText')==""){
		PageLogicObj.m_DocRowId="";
	}
	$.q({
	    ClassName : "web.DHCOPSendMedicare",
	    QueryName : "FindRBAS",
	    LocID:PageLogicObj.m_deptRowId, DocID:PageLogicObj.m_DocRowId, StatusID:$("#Status").combobox('getValue'), ReasonID:$("#Reason").combobox('getValue'), 
	    StartDate:$("#StDate").datebox('getValue'), EndDate:$("#EndDate").datebox('getValue'), 
	    Submit:"", //$("#submit").checkbox('getValue')?"on":"",
	    Pagerows:PageLogicObj.m_ScheduleQueryTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ScheduleQueryTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function InitLoc(){
	$("#Loc").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'Hidden',
        textField:'Desc',
        columns:[[  
            {field:'Hidden',title:'',hidden:true},
			{field:'Desc',title:'科室名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCRBResSession',QueryName: 'FindLoc'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{Loc:desc, UserID:""});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
			    PageLogicObj.m_deptRowId=rec["Hidden"];
			    PageLogicObj.m_DocRowId="";
			    $("#Doc").lookup('setText','');
			});
		}
    });
}
function InitDoc(){
	$("#Doc").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'Hidden1',
        textField:'Desc',
        columns:[[  
            {field:'Hidden1',title:'',hidden:true},
			{field:'Desc',title:'名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCRBResSession',QueryName: 'FindResDoc'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if ($("#Loc").lookup('getText')==""){
				PageLogicObj.m_deptRowId="";
			}
			param = $.extend(param,{DepID:PageLogicObj.m_deptRowId, Type:"",UserID:"",Group:"",MarkCodeName:desc});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
			    PageLogicObj.m_DocRowId=rec["Hidden1"];
			});
		}
    });
}
function InitReason(){
	$.cm({ 
		ClassName:"web.DHCRBCReasonNotAvail", 
		MethodName:"GetStopReasonStr",
		dataType:'text'
	},function(data){
		var arr=new Array();
		for (var i=0;i<data.split("^").length;i++){
			var id=data.split("^")[i].split(String.fromCharCode(1))[0];
			var text=data.split("^")[i].split(String.fromCharCode(1))[1];
			arr.push({"id":id,"text":text})
		}
		$HUI.combobox("#Reason", {
				valueField: 'id',
				textField: 'text', 
				editable:true,
				data: arr,
				filter: function(q, row){
					q=q.toUpperCase();
					return (row["text"].toUpperCase().indexOf(q) >= 0);
				},onChange:function(newValue,OldValue){
					if (newValue==""){
						$("#Reason").combobox('select',"");
					}
				}
		 });
	})
}
function InitStatus(){
	$.cm({ 
		ClassName:"web.DHCOPSendMedicare", 
		MethodName:"GetStatusStr",
		dataType:'text'
	},function(data){
		var arr=new Array();
		for (var i=0;i<data.split("^").length;i++){
			var id=data.split("^")[i].split(String.fromCharCode(1))[0];
			var text=data.split("^")[i].split(String.fromCharCode(1))[1];
			arr.push({"id":id,"text":text})
		}
		$HUI.combobox("#Status", {
				valueField: 'id',
				textField: 'text', 
				editable:true,
				data: arr,
				filter: function(q, row){
					q=q.toUpperCase();
					return (row["text"].toUpperCase().indexOf(q) >= 0);
				},onChange:function(newValue,OldValue){
					if (newValue==""){
						$("#Status").combobox('select',"");
					}
				}
		 });
	})
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
function PrintClickHandle(){
   /*var myPrtXMLName="UDHCRegHandinRptList";
   DHCP_GetXMLConfig("InvPrintEncrypt",myPrtXMLName);
   var path=$.cm({
		ClassName:"web.UDHCJFCOMMON",
		MethodName:"getpath",
		dataType:"text"
   },false);
	var Template=path+"DHCRBApptScheduleQuery.xls";
	try{
		var xlApp= new ActiveXObject("Excel.Application"); 
		var xlBook= xlApp.Workbooks.Add(Template); 
		var xlSheet = xlBook.ActiveSheet;	
		var xlsheet = xlBook.WorkSheets("Sheet1");
	}
	catch(e) {
  		$.messager.alert("提示","要打印该表您必须安装Excel电子表格软件,同时浏览器须使用'ActiveX 控件',您的浏览器须允许执行控件 请点击帮助了解浏览器设置方法");
  		return "";
	}
	var columnNumber=1;
	xlsheet.cells(2, columnNumber).value = "科室";
	xlsheet.cells(2, columnNumber+1).value = "医生";
	xlsheet.cells(2, columnNumber+2).value = "停替诊原因";
	xlsheet.cells(2, columnNumber+3).value = "出诊时间";
	xlsheet.cells(2, columnNumber+4).value = "职称";
	xlsheet.cells(2, columnNumber+5).value = "时段";
	xlsheet.cells(2, columnNumber+6).value = "号数";
	xlsheet.cells(2, columnNumber+7).value = "状态";
	var rows=PageLogicObj.m_ScheduleQueryTabDataGrid.datagrid('getRows');
	for (var i=0;i<rows.length;i++){
		xlsheet.cells(i+3, columnNumber).value = rows[i]['TLocDesc'];
		xlsheet.cells(i+3, columnNumber+1).value = rows[i]['TDocDesc'];
		xlsheet.cells(i+3, columnNumber+2).value = rows[i]['TReason'];
		xlsheet.cells(i+3, columnNumber+3).value = rows[i]['TDate'];
		xlsheet.cells(i+3, columnNumber+4).value = rows[i]['TSessType'];
		xlsheet.cells(i+3, columnNumber+5).value = rows[i]['TTimeRange'];
		xlsheet.cells(i+3, columnNumber+6).value = rows[i]['TQty'];
		xlsheet.cells(i+3, columnNumber+7).value = rows[i]['TStatus'];
		//xlsheet.cells(i+3, columnNumber+8).value = rows[i]['TStatus'];
	}
	xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null;
	return true;*/
	var PrintNum = 1; //打印次数
	var IndirPrint = "N"; //是否预览打印
	var TaskName="停替诊查询单"; //打印任务名称
	var Title=$("#StDate").datebox('getValue')+" 至 "+$("#EndDate").datebox('getValue')+"停替诊查询单"; //表头
	var DetailData=GetPrintDetailData(); //明细信息
	if (DetailData.length==0) {
		$.messager.alert("提示","没有需要打印的数据!");
		return false
	}
	//明细信息展示
	var Cols=[
		{field:"TLocDesc",title:"科室",width:"10%",align:"left"},
		{field:"TDocDesc",title:"医生",width:"10%",align:"left"},
		{field:"TReason",title:"停替诊原因",width:"10%",align:"left"},
		{field:"TDate",title:"出诊时间",width:"10%",align:"center"},
		{field:"TSessType",title:"职称",width:"10%",align:"left"},
		{field:"TTimeRange",title:"时段",width:"10%",align:"left"},
		{field:"TQty",title:"号数",width:"10%",align:"center"},
		{field:"TStatus",title:"状态",width:"10%",align:"center"}
	];	
	PrintDocument(PrintNum,IndirPrint,TaskName,Title,Cols,DetailData)
}
function GetPrintDetailData(){
	if ($("#Loc").lookup('getText')==""){
		PageLogicObj.m_deptRowId="";
	}
	if ($("#Doc").lookup('getText')==""){
		PageLogicObj.m_DocRowId="";
	}
	var GridData=$.q({
	    ClassName : "web.DHCOPSendMedicare",
	    QueryName : "FindRBAS",
	    LocID:PageLogicObj.m_deptRowId, DocID:PageLogicObj.m_DocRowId, StatusID:$("#Status").combobox('getValue'), ReasonID:$("#Reason").combobox('getValue'), 
	    StartDate:$("#StDate").datebox('getValue'), EndDate:$("#EndDate").datebox('getValue'), 
	    Submit:"",
	    Pagerows:PageLogicObj.m_ScheduleQueryTabDataGrid.datagrid("options").pageSize,rows:99999
	},false);
	return GridData.rows;
}