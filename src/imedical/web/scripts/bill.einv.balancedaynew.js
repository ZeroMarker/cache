/// 名称: bill.einv.balancedaynew.js
/// 描述: 医保查询
/// 编写者：赵振武
/// 编写日期: 2019-09-29
$(function(){
	setPageLayout(); //页面布局初始化
	setElementEvent(); //页面事件初始化
});
//页面布局初始化
function setPageLayout(){
	//获取开始日期
	var StDate = new Date().getFullYear() + "-" + (new Date().getMonth() + 1) + "-" + (new Date().getDate()-1);
	//获取结束日期
	var EdDate = new Date().getFullYear() + "-" + (new Date().getMonth() + 1) + "-" + new Date().getDate();
	//设置开始日期值
	$('#BusStDate').datebox('setValue', StDate);
	//设置结束日期值
	$('#BusEdDate').datebox('setValue', EdDate);
	
	$HUI.datagrid('#balancedaydatagrid',{
		title:'日对总账结果',
		iconCls:'icon-w-cal',
		fitColumns:true,
		fit:true,
		rownumbers:true,
		singleSelect:true,
		pagination:true,
		pageSize:10,
		pageList:[10,20,30],
		url:$URL,
		columns:[[     
				{field:'BusDate',title:'业务日期',align:'center',width:120},
				{field:'CopyNum',title:'总笔数',align:'center',width:120},
				{field:'AllTotalAmt',title:'总金额',align:'center',width:120},
				{field:'AllTotalNum',title:'总开票数',align:'center',width:120}
		]],
		onLoadSuccess:function(){
		}
	});
	$HUI.datagrid('#balancesubdaydatagrid',{
		title:'第三方分类账',
		iconCls:'icon-w-cal',
		fitColumns:true,
		fit:true,
		rownumbers:true,
		singleSelect:true,
		pagination:true,
		pageSize:10,
		pageList:[10,20,30],
		url:$URL,
		columns:[[     
			{field:'BusDate',title:'业务日期',width:100},    
			{field:'BillBatchCode',title:'电子票据代码',width:100},
			{field:'BillName',title:'票据种类名称',width:100},    
			{field:'BgnNo',title:'起始号码',width:100},
			{field:'EndNo',title:'终止号码',width:100},    
			{field:'CopyNum',title:'票号段内总开票数',width:100},
			{field:'TotalAmt',title:'票号段内总金额',width:100}
		]],
		onLoadSuccess:function(){
		}
	});
}
//页面事件初始化
function setElementEvent(){
	$('#BusSearchBtn').click(function(){
		loadBalanceDayInfo();
	});
	$('#DownLoadBtn').click(function(){
		DowncheckTotalData();
	});
}
function loadBalanceDayInfo(){
	//日对总账
	var BusStDate = $('#BusStDate').datebox('getValue');
	var BusEdDate = $('#BusEdDate').datebox('getValue');
	$('#balancedaydatagrid').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.BalanceDayCtl",
		QueryName:"QueryBalanceDayInfo",
		BusStDate:BusStDate,
		BusEdDate:BusEdDate
	});	
	//第三方分类账
	$('#balancesubdaydatagrid').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.BalanceDayCtl",
		QueryName:"QueryBalanceSubDayInfo",
		BusStDate:BusStDate,
		BusEdDate:BusEdDate
	});		
}

//下载总笔数核对数据
function DowncheckTotalData(){
	var BusStDate = $('#BusStDate').datebox('getValue');
	var BusEdDate = $('#BusEdDate').datebox('getValue');
	if (BusStDate!=BusEdDate){
		$.messager.alert('提示', '只能下载某一天的核对数据.请选择需要下载的日期');
		return;
	}
	
	var InputPam=BusStDate+"^^^1^1^200"
	alert(InputPam)
	$m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"DLEInvBillList",
		InputPam:InputPam
	},function(rtn){
		if(rtn=="0"){
			loadBalanceDayInfo();
		}else{
			$.messager.alert("提示","下载数据失败");
		}
	});
}