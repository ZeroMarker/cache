/*
模块:门诊药房
子模块:门诊药房-药房统计-退药药品汇总
createdate:2016-05-27
creator:dinghongying
modified by yunhaibao20160603
*/
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var url = "dhcpha.outpha.returntotal.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID']; 
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'200'
} 
$(function(){
	var depLocCombo=new ListCombobox("depLoc",commonOutPhaUrl+'?action=GetCtLocDs','',combooption);
	depLocCombo.init(); //初始化科室	
	InitRefundSumList();	
	$('#BRetrieve').bind('click', Query);//点击查询
	$('#BPrint').bind('click',BPrintHandler);//点击打印	
	$('#BExport').bind('click', function(){
		ExportAllToExcel("RefundSumdg")
	});//点击导出
	$('#BReset').bind('click', InitCondition);//点击清空
	InitCondition();
});
function InitCondition(){
	$("#startDate").datebox("setValue", formatDate(0)); 
	$("#endDate").datebox("setValue", formatDate(0)); 
	$("#depLoc").combobox("setValue","");  
	$('#RefundSumdg').datagrid('loadData',{total:0,rows:[]});
	$('#RefundSumdg').datagrid('options').queryParams.params = ""; 
}
//初始化退药汇总列表
function InitRefundSumList(){
	//定义columns
	var columnspat=[[
        {field:'TPhDesc',title:'药品名称',width:300},
        {field:'TPhUom',title:'单位',align:'center',width:150},    
        {field:'TRetQty',title:'退药数量',align:'right',width:150,sortable:true},
        {field:'TRetMoney',title:'退药金额',align:'right',width:150,sortable:true}
         ]];  
	
   //定义datagrid	
   $('#RefundSumdg').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  singleSelect:true,
	  rownumbers:true,
      columns:columnspat,
      pageSize:100,  // 每页显示的记录条数
	  pageList:[100,300,500,1000],   // 可以设置每页记录条数的列表
	  singleSelect:true,
	  loadMsg: '正在加载信息...',
	  pagination:true
	 
   });
  
}


///退药药品汇总查询
function Query(){	
	var startDate=$('#startDate').datebox('getValue');
	if (startDate==""){
		$.messager.alert('错误提示',"请输入开始日期!");
		return;
	}
	var endDate=$('#endDate').datebox('getValue');
	if (endDate==""){
		$.messager.alert('错误提示',"请输入截止日期!");
		return;
	}
	var depLoc=$('#depLoc').combobox("getValue");
	if ($.trim($('#depLoc').combobox("getText"))==""){
		depLoc=""
	}
	var ldoctor=""
	var params=gLocId+"^"+startDate+"^"+endDate+"^"+depLoc+"^"+ldoctor
	$('#RefundSumdg').datagrid({
     	url:url+'?action=QueryReturnTotal',
     	queryParams:{
			params:params}
	});
	
}
function BPrintHandler() 
{
	if ($('#RefundSumdg').datagrid('getData').rows.length == 0) {//获取当面界面数据行数
		$.messager.alert("提示","页面没有数据","info");
		return ;
	}
	var RefundSumdgOption=$("#RefundSumdg").datagrid("options")
	var RefundSumdgparams=RefundSumdgOption.queryParams.params;
	var sortorder=RefundSumdgOption.sortOrder;
	var sortname=RefundSumdgOption.sortName;
	var RefundSumdgUrl=RefundSumdgOption.url;
	$.ajax({
		type: "GET",
		url: RefundSumdgUrl+"&page=1&rows=9999&params="+RefundSumdgparams+"&sort="+sortname+"&order="+sortorder,
		async:false,
		dataType: "json",
		success: function(returndata){
			PrintRefund(returndata);
		}
	});
}
function PrintRefund(returndata){
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");//获取模板路径
	var tmpjsonObject = JSON.stringify(returndata.rows);
    var colarray = typeof tmpjsonObject != 'object' ? JSON.parse(tmpjsonObject) : tmpjsonObject;
    var str = '';
    var rows=colarray.length
    var startdate=$('#startDate').datebox('getValue');
    var enddate=$('#endDate').datebox('getValue');
	var xlApp,obook,osheet,xlsheet,xlBook
	var paymoney
	var Template
	Template = path + "yftyhz.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
	xlsheet.cells(2,2).value =startdate  + enddate;
	for (var i = 0; i < colarray.length; i++) {	
		
	    xlsheet.cells(4 + i, 1).value = colarray[i]["TPhDesc"];
		xlsheet.cells(4 + i, 2).value = colarray[i]["TPhUom"];
		xlsheet.cells(4 + i, 3).value = colarray[i]["TRetQty"];
		xlsheet.cells(4 + i, 4).value = colarray[i]["TRetMoney"];	
    }			
	xlsheet.printout
	xlBook.Close(savechanges = false);
	xlApp = null;
	xlsheet = null
}



