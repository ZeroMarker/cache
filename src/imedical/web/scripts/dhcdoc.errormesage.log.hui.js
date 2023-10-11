var PageLogicObj = {
	errormesagetab:"",
}
$(function(){
	PageHandle()
	InitEvent();
});
function PageHandle(){
	$("#StartDate").datebox('setValue',ServerObj.nowdate)
	$("#EndDate").datebox('setValue',ServerObj.nowdate)
	PageLogicObj.errormesagetab=IntMesageTable()
}
function InitEvent(){
	$("#Find").click(LoadDataGrid);
	
}
function BodyLoadHandler(){
	LoadDataGrid()
}
function LoadDataGrid(){
	$.cm({
	    ClassName : "DHCDoc.Log.CommonQuery",
	    QueryName : "FindCommonLog",
	    Stdate:$("#StartDate").datebox('getValue'),
	    EndDate:$("#EndDate").datebox('getValue'),
	    CallClass:$("#CallClass").val(),
	    CallMeth:$("#CallMeth").val(),
	    LogDesc:$("#LogDesc").val(),
	    LogKey:$("#LogKey").val(),
	    LogValue:$("#LogValue").val(),
	    Pagerows:PageLogicObj.errormesagetab.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.errormesagetab.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
	PageLogicObj.errormesagetab.datagrid("clearSelections")
}
///初始化查询Table	
function IntMesageTable()
{
	var tabdatagrid=$('#errormesagetab').datagrid({  
	fit : true,
	border : false,
	striped : true,
	singleSelect : true,
	fitColumns : false,
	autoRowHeight : true,
	rownumbers:true,
	pagination : true,  
	rownumbers : true, 
	nowrap: false,
	pageSize: 50,
	pageList : [50,100,200],
	idField:"ID",
	columns :[[ 
			{field:'FInsType',title:"类型",width:60,align:'left'},
			{field:'FCallClass',title:"调用类",width:180,align:'left'},
			{field:'FCallMethod',title:"调用方法",width:150,align:'left'}, 
			{field:'FLogDesc',title:"日志描述",width:300,align:'left'},
			{field:'FLogKey',title:"主键",width:150,align:'left'},
			{field:'FInsertDate',title:"系统日期",width:100,align:'left'},
			{field:'FInsertTime',title:"系统时间",width:90,align:'left'},
			{field:'FLogValue',title:"日志记录值",width:200,align:'left'},
			{field:'FLastUpdateDate',title:"最后更新日期",width:100,align:'left'},
			{field:'FLastUpdateTime',title:"最后更新时间",width:95,align:'left'},
			{field:'ID',title:"预约ID",width:35,align:'left',hidden:true}
		 ]]
	});
	return tabdatagrid
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