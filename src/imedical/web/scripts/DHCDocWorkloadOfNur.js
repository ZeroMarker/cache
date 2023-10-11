var PageLogicObj={
	m_OPDocLogTabDataGrid:""
}
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	OPDocLogTabDataGridLoad();
})
function PageHandle(){
	$("#OpDate,#OpDate2").datebox('setValue',ServerObj.NowDate);
}
function Init(){
	PageLogicObj.m_OPDocLogTabDataGrid=InitOPDocLogTabDataGrid();
}
function InitEvent(){
	$("#BFind").click(OPDocLogTabDataGridLoad);
	$("#BExport").click(ExportClickHandle);
}
function InitOPDocLogTabDataGrid(){
	var Columns=[[ 
		{field:'Initials',title:'工号',width:100},
		{field:'NurName',title:'姓名',width:110},
		{field:'Workload',title:'分诊人数',width:100}
    ]]
	var OPDocLogTabDataGrid=$("#OPDocLogTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'paadmrowid',
		columns :Columns 
	});
	return OPDocLogTabDataGrid;
}
function OPDocLogTabDataGridLoad(){
	
	var OpDate=$("#OpDate").datebox('getValue');
	var OpDate2=$("#OpDate2").datebox('getValue');
	$.cm({
	    ClassName : "web.DHCDocWorkloadOfNur",
	    QueryName : "FindWorkloadOfNur",
	    OpDate:OpDate,
	    OpDate2:OpDate2,
	    Pagerows:1,
	    rows:99999
	},function(GridData){
		PageLogicObj.m_OPDocLogTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
	
}
function ExportClickHandle(){
	try {
		var StartDate=$('#OpDate').datebox('getValue');
    	var EndDate=$('#OpDate2').datebox('getValue');
		var rows = PageLogicObj.m_OPDocLogTabDataGrid.datagrid('getRows');
		if ((!rows)||(rows.length==0)){
			$.messager.alert("提示","请查询出数据后导出!");
		    return false;	
		}
		var rtn = $.cm({
			dataType:'text',
			ResultSetType:'Excel',
			ExcelName:'分诊护士工作量统计', //StartDate+"至"+EndDate+
			ClassName : "web.DHCDocWorkloadOfNur",
		    QueryName : "FindWorkloadOfNur",
		    OpDate:StartDate,
		    OpDate2:EndDate
		}, false);
	    location.href = rtn;
		
		/*var TemplatePath=$.cm({
			ClassName:"web.UDHCJFCOMMON",
			MethodName:"getpath",
			dataType:"text"
		},false); 
        var BeginDate,Depart,TotalSum,PatPaySum,PayorSum;
		var ParkINVInfo,ParkSum,ParkNum;
	    var RefundINVInfo,RefundSum,RefundNum,CheckSum,CheckNum;
        var INVInfo;
        var UserName="";
        var myTotlNum=0;
        var CashNUM=0;
        var myencmeth="";
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCOPNurLog.xls";
	    var UserName=session['LOGON.USERNAME'];
	    var StartDate=$('#OpDate').datebox('getValue');
    	var EndDate=$('#OpDate2').datebox('getValue');
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  
	    xlsheet.PageSetup.RightMargin=0;
	    xlsheet.cells(1,1)=StartDate+"至"+EndDate+"期间分诊护士工作量日志";
		var xlsrow=2;
		var xlsCurcol=0;
		var data=PageLogicObj.m_OPDocLogTabDataGrid.datagrid('getData');
		for (var i=0;i<data.rows.length;i++){
			xlsrow=xlsrow+1;
			xlsheet.cells(xlsrow,xlsCurcol+1)=data['rows'][i]['Initials'];
			xlsheet.cells(xlsrow,xlsCurcol+2)=data['rows'][i]['NurName'];
			xlsheet.cells(xlsrow,xlsCurcol+3)=data['rows'][i]['Workload'];
		}
		var d=new Date();
		var h=d.getHours();
		var m=d.getMinutes();
		var s=d.getSeconds()
	    $.messager.alert("提示","文件将保存在您的D盘根目录下!","info",function(){
		    xlBook.SaveAs("D:\\分诊护士工作量统计"+h+m+s+".xls"); 
		    xlBook.Close (savechanges=false);
		    xlApp.Quit();
		    xlApp=null;
		    xlsheet=null;
		});*/
	} catch(e) {
		$.messager.alert("提示",e.message);
	};
}	
		
function gridlist(objSheet,row1,row2,c1,c2){
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
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