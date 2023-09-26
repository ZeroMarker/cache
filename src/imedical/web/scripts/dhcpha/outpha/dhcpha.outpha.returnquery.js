/*
模块:门诊药房
子模块:门诊药房-退药单查询
createdate:2016-05-24
creator:dinghongying,yunnaibao
*/
var url = "dhcpha.outpha.returnquery.action.csp";
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var gLocId=session['LOGON.CTLOCID'];
$(function(){	
	InitDateBox();
	InitRefundInfoList();	
	InitRefundDetailList();	
	//点击检索
	$('#BRetrieve').bind('click', Query);	
	$('#BReset').bind('click',Clear);	
	$('#BExport').bind('click',function(){
		ExportAllToExcel("refundinfodg");
	});
	$('#BPrint').bind('click',BPrintHandler);
	$('#BCancelReturn').bind('click',BCancelReturnHandler);
});
function InitDateBox(){
	$("#CDateSt").datebox("setValue", formatDate(0));  //Init起始日期
	$("#CDateEnd").datebox("setValue", formatDate(0));  //Init截止日期
}
function Clear(){
	InitDateBox();
	$('#refundinfodg').datagrid('loadData',{total:0,rows:[]}); 
	$('#refunddetaildg').datagrid('loadData',{total:0,rows:[]});
	$('#refundinfodg').datagrid('options').queryParams.params = "";  
	$('#refunddetaildg').datagrid('options').queryParams.params = ""; 
}
//初始化退药单列表
function InitRefundInfoList(){
	//定义columns
	var columnspat=[[
		{field:'TPmiNo',title:'登记号',width:80},    
		{field:'TPatName',title:'姓名',width:80},
		{field:'TRetDate',title:'退药日期',width:80},
		{field:'TRetMoney',title:'退药金额',width:80,align:'right'},
		{field:'TRetUser',title:'操作人',width:100},
		{field:'TDoctor',title:'医生',width:100},
		{field:'TLocDesc',title:'科室',width:120},
		{field:'TRetReason',title:'退药原因',width:150},
		{field:'TDispDate',title:'发药日期',width:80},
		{field:'TEncryptLevel',title:'病人密级',width:80},
		{field:'TPatLevel',title:'病人级别',width:80},
		{field:'TRetRowid',title:'TRetRowid',width:80,hidden:true}
	]];  

	//定义datagrid	
	$('#refundinfodg').datagrid({    
		url:url+'?action=QueryReturn',
		fit:true,
		border:false,
		singleSelect:true,
		nowrap:false,
		rownumbers:true,
		columns:columnspat,
		pageSize:50,  // 每页显示的记录条数
		pageList:[50,100,300,500],   // 可以设置每页记录条数的列表
		loadMsg: '正在加载信息...',
		pagination:true ,
		onLoadSuccess: function(){
			//选中第一
			if ($('#refundinfodg').datagrid("getRows").length>0){
				$('#refundinfodg').datagrid("selectRow", 0)
				QueryDetail();
			}else{
				$('#refunddetaildg').datagrid('loadData',{total:0,rows:[]}); 
				$('#refunddetaildg').datagrid('options').queryParams.params = ""; 
			}
		},
		onSelect:function(rowIndex,rowData){
			QueryDetail();
		}      
	});
}


//初始化退药单明细列表
function InitRefundDetailList(){
	//定义columns
	var columnspat=[[
	    {field:'TPhDesc',title:'药品名称',width:300},    
        {field:'TPhUom',title:'单位',width:125},    
        {field:'TRetQty',title:'退药数量',width:125,align:'right'},
        {field:'TPhprice',title:'单价',width:125,align:'right'},    
        {field:'TRetMoney',title:'退药金额',width:125,align:'right'}
    ]];  
	
   //定义datagrid	
   $('#refunddetaildg').datagrid({    
      url:url+'?action=QueryReturnDetail',
      fit:true,
	  border:false,
	  singleSelect:true,
	  rownumbers:true,
      columns:columnspat
   });
}
///检索
function Query(){
	var startDate=$('#CDateSt').datebox('getValue');
	if (startDate==""){
		$.messager.alert('错误提示',"请输入开始日期!","info");
		return;
	}
	var endDate=$('#CDateEnd').datebox('getValue');
	if (endDate==""){
		$.messager.alert('错误提示',"请输入开始日期!","info");
		return;
	}
	var params=startDate+"^"+endDate+"^"+gLocId;
	$('#refundinfodg').datagrid({
		queryParams:{
			params:params
		}
	});
}
//查询明细
function QueryDetail(){
	var selectdata=$("#refundinfodg").datagrid("getSelected")
	if (selectdata==null){
		$.messager.alert('错误提示',"选中数据异常!","info");
		return;
	}
	var params=selectdata["TRetRowid"]
	$('#refunddetaildg').datagrid({
		queryParams:{
			params:params
		}	
	});
}
//打印
function BPrintHandler(){
	var selectdata=$("#refundinfodg").datagrid("getSelected");
	if (selectdata==null){
		$.messager.alert('错误提示',"请选择需要打印的退药单!","info");
		return;
	}
	var retrowid=selectdata["TRetRowid"];
	PrintReturn(retrowid,"补");
}
//撤销退药
function BCancelReturnHandler(){
	var selectdata=$("#refundinfodg").datagrid("getSelected");
	if (selectdata==null){
		$.messager.alert('错误提示',"请选择需要撤销的退药单!","info");
		return;
	}
	var retrowid=selectdata["TRetRowid"];
	var cancelRet=tkMakeServerCall("web.DHCOutPhReturn","CancleReturn",retrowid);
	if (cancelRet == "-1"){
		$.messager.alert("提示","非当天的退药记录,不能撤销！","info")
		return;
	}else if (cancelRet == "-2"){
		$.messager.alert("提示","退药单据对应收费记录不存在,请核对！","info")
		return;
	}else if (cancelRet == "-3"){
		$.messager.alert("提示","该条记录已退费,不能撤销！","info")
		return;
	}else if (cancelRet == "-4"){
		$.messager.alert("提示","该条记录已撤销退药,请核对！","info")
		return;
	}else if (cancelRet!=0){
		$.messager.alert("提示","撤消失败,请联系相关人员进行处理！","info")
		return;
	}else{
		$.messager.alert("提示","撤消成功！","success")
		Query();
	}
}