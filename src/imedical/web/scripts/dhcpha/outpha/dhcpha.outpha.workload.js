/*
模块:门诊药房
子模块:门诊药房-药房统计-工作量统计
createdate:2016-06-06
creator:dinghongying
modified by yunhaibao20160612
*/
var url = "dhcpha.outpha.workload.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID']; 
$(function(){	
	InitWorkLoadList();	
	$('#BReset').bind('click', Reset);//点击清空
	$('#BRetrieve').bind('click', Query);//点击统计
	$('#BPrint').bind('click', PrintHandler);//点击打印
	$('#BExport').bind('click', function(){
		ExportAllToExcel("workloaddg")
	});
	Reset();
});



//初始化工作量统计列表
function InitWorkLoadList(){
	//定义columns
	var columns=[[
        {field:'TPhName',title:'药房人员',width:100},
        {field:'TPYRC',title:'配药处方',width:100,align:'right',sortable:true},    
        {field:'TFYRC',title:'发药处方',width:100,align:'right',sortable:true}, 
        {field:'TPYJE',title:'配药金额',width:100,align:'right',sortable:true}, 
        {field:'TFYJE',title:'发药金额',width:100,align:'right',sortable:true},
        {field:'TPYL',title:'配药量',width:100,align:'right',sortable:true},
        {field:'TFYL',title:'发药量',width:100,align:'right',sortable:true},
        {field:'TRetPresc',title:'退药处方',width:100,align:'right',sortable:true}, 
        {field:'TRetMoney',title:'退药金额',width:100,align:'right',sortable:true},
        {field:'TRetYL',title:'退药量',width:100,align:'right',sortable:true},
        {field:'TPyFS',title:'配药付数',width:100,hidden:true,align:'right',sortable:true}, 
        {field:'TFyFS',title:'发药付数',width:100,align:'right',sortable:true}, 
        {field:'TTyFS',title:'退药付数',width:100,align:'right',sortable:true}, 
        {field:'TJYFS',title:'煎药付数',width:100,hidden:true,sortable:true},
        {field:'TJYCF',title:'煎药处方',width:100,hidden:true,sortable:true}
         ]];  
	
   //定义datagrid	
   $('#workloaddg').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  singleSelect:true,
	  rownumbers:true,
      columns:columns,
	  singleSelect:true,
	  loadMsg: '正在加载信息...'
	 
   });
  
}


///药房工作量统计清空
function Reset()
{
	$("#startDate").datebox("setValue",formatDate(0));  //Init起始日期
	$("#endDate").datebox("setValue", formatDate(0));  //Init结束日期
	$('#startTime').timespinner('setValue',"");
	$('#endTime').timespinner('setValue',"");
	$('#workloaddg').datagrid('loadData',{total:0,rows:[]}); 
}

///药房工作量统计查询
function Query()
{
	var startDate=$('#startDate').datebox('getValue');
	if (startDate==""){
		$.messager.alert('提示',"请输入开始日期!","info");
		return;
	}
	var endDate=$('#endDate').datebox('getValue');
	if (endDate==""){
		$.messager.alert('提示',"请输入截止日期!","info");
		return;
	}
	var startTime=$('#startTime').timespinner('getValue');
	var endTime=$('#endTime').timespinner('getValue');
	var params=gLocId+"^"+startDate+"^"+endDate+"^"+startTime+"^"+endTime;
	$('#workloaddg').datagrid({
     	url:url+'?action=GetWorkLoadList',
     	queryParams:{
			params:params}
	});
	
}

function PrintHandler()
{
	
	if ($('#workloaddg').datagrid('getData').rows.length == 0) //获取当面界面数据行数
	{
		$.messager.alert("提示","页面没有数据","info");
		return ;
	}
	var WorkLoaddgOption=$("#workloaddg").datagrid("options")
	var WorkLoaddgparams=WorkLoaddgOption.queryParams.params;
	var WorkLoaddgUrl=WorkLoaddgOption.url;
	$.ajax({
		type: "GET",
		url: WorkLoaddgUrl+"&page=1&rows=9999&params="+WorkLoaddgparams,
		async:false,
		dataType: "json",
		success: function(workloaddata){
			PrintWorkLoad(workloaddata);
		}
	});
}
	
function PrintWorkLoad(workloaddata){
	
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");//获取模板路径
	var tmpjsonObject = JSON.stringify(workloaddata.rows);
    var colarray = typeof tmpjsonObject != 'object' ? JSON.parse(tmpjsonObject) : tmpjsonObject;
    var rows=colarray.length
	var datestart = $('#startDate').datebox('getValue');
	var dateend = $('#endDate').datebox('getValue');
	var xlApp,obook,osheet,xlsheet,xlBook
	var Template
	Template = path + "YFGZL.XLS"
	//alert(Template);
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
	xlsheet.cells(2,6).value = datestart + "至" +dateend
	for (i = 0; i < rows; i++) 
		{
			xlsheet.cells(4 + i, 1).value = colarray[i].TPhName
			xlsheet.cells(4 + i, 2).value = colarray[i].TPYRC
			xlsheet.cells(4 + i, 3).value = colarray[i].TFYRC
			xlsheet.cells(4 + i, 4).value = colarray[i].TPYJE
			xlsheet.cells(4 + i, 5).value = colarray[i].TFYJE
			xlsheet.cells(4 + i, 6).value = colarray[i].TPYL
			xlsheet.cells(4 + i, 7).value = colarray[i].TFYL
			xlsheet.cells(4 + i, 8).value = colarray[i].TRetPresc
			xlsheet.cells(4 + i, 9).value = colarray[i].TRetMoney
			xlsheet.cells(4 + i, 10).value = colarray[i].TRetYL
			//xlsheet.cells(4 + i, 11).value = colarray[i].TPyFS
			xlsheet.cells(4 + i, 12).value = colarray[i].TFyFS
			xlsheet.cells(4 + i, 13).value = colarray[i].TTyFS
			xlsheet.cells(4 + i, 14).value = colarray[i].TJYFS
			xlsheet.cells(4 + i, 15).value = colarray[i].TJYCF
	    }
		xlsheet.printout
	    xlBook.Close(savechanges = false);
	    xlApp = null;
	    xlsheet = null
}

