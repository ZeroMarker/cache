var PageLogicObj={
	m_OPDocLogAmountTabDataGrid:""
}
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	OPDocLogAmountTabDataGridLoad();
})
function Init(){
	PageLogicObj.m_OPDocLogAmountTabDataGrid=InitOPDocLogAmountTabDataGrid();
}
function InitEvent(){
	$("#BFind").click(OPDocLogAmountTabDataGridLoad);
}
function InitOPDocLogAmountTabDataGrid(){
	var Columns=[[ 
		{field:'LocName',title:'科室名称',width:200},
		{field:'PatAllNum',title:'病人总数',width:150},
		{field:'InfectAllNum',title:'上报总数',width:150}
    ]]
	var OPDocLogAmountTabDataGrid=$("#OPDocLogAmountTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'LocName',
		columns :Columns
	});
	return OPDocLogAmountTabDataGrid;
}
function OPDocLogAmountTabDataGridLoad(){
	$.cm({
	    ClassName : "web.DHCOPDOCLog",
	    QueryName : "DHCLogReport",
	    StDate:$("#StDate").datebox('getValue'),
	    EdDate:$("#EdDate").datebox('getValue'),
	    Pagerows:PageLogicObj.m_OPDocLogAmountTabDataGrid.datagrid("options").pageSize,
	    rows:99999
	},function(GridData){
		PageLogicObj.m_OPDocLogAmountTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
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