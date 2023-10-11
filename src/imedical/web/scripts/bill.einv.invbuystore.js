// 入口函数
$(function(){
	setPageLayout(); //初始化页面布局
	setElementEvent(); //初始化页面元素事件
});
//初始化页面布局
function setPageLayout(){
	$cm({
		ClassName:"BILL.EINV.BL.COM.InvBuyApplyCtl",
		MethodName:"test2"
	},function(jsonData){
		var DataArr=jsonData.stocklist;
		$('#InvBuyStoreView').datagrid({
    		fit:true,
    		fitColumns:true,
    		border:false,
    		striped:true,
    		singleSelect:true,
    		pagination:true,
    		columns:[[   
    			{field:'apply_no',title:'申请单号',width:100},
    			{field:'invoice_code',title:'电子票据代码',width:100},
    			{field:'invoice_name',title:'电子票据名称',width:100},
    			{field:'count',title:'电子票据总数',width:100},
    			{field:'start_no',title:'起始号码',width:100},
    			{field:'end_no',title:'结束号码',width:100},
    			{field:'dis_datetime',title:'发放日期',width:100}
    		]],
    		data:DataArr
		});
	});
}
//初始化页面元素事件
function setElementEvent(){
	
}