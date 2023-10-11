/// 名称: bill.einv.balanceday.js
/// 描述: 医保查询
/// 编写者：赵振武
/// 编写日期: 2019-09-27
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
		columns:[
			[
				{title:'第三方分类账',colspan:4},
				{title:'His分类账目',colspan:4}
			],
			[     
				{field:'BusDate',title:'业务日期',align:'center',width:120},
				{field:'CopyNum',title:'总笔数',align:'center',width:120},
				{field:'AllTotalAmt',title:'总金额',align:'center',width:120},
				{field:'AllTotalNum',title:'总开票数',align:'center',width:120},
			
				{field:'HisBusDate',title:'业务日期',align:'center',width:120},
				{field:'HisCopyNum',title:'总笔数',align:'center',width:120},
				{field:'HisAllTotalAmt',title:'总金额',align:'center',width:120},
				{field:'HisAllTotalNum',title:'总开票数',align:'center',width:120}
			]
		]
	});
	
	$HUI.datagrid('#Errorgrid',{
		title:'对账异常数据',
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
			{field:'PlaceCodeErr',title:'开票点',align:'center',width:100},
			{field:'MedicalDrErr',title:'HIS明细ID',align:'center',width:100},
			{field:'CenterDrErr',title:'第三方明细ID',align:'center',width:100},
			{field:'BillBatchCodeErr',title:'票据代码',align:'center',width:100},
			{field:'BillNoErr',title:'票据号码',align:'center',width:100},
			{field:'RandomErr',title:'校验码',align:'center',width:80,hidden:true},
			{field:'CTTotalAmtErr',title:'第三方总金额',align:'center',width:120},
			{field:'HISTotalAmtErr',title:'HIS总金额',align:'center',width:100},
			{field:'CommonInfoErr',title:'对账说明',align:'center',width:120},
			{field:'DataTypeErr',title:'数据类型',align:'center',width:100},
			{field:'iBlanceUserDrErr',title:'对账人',align:'center',width:100},
			{field:'iBlanceDateErr',title:'对账日期',align:'center',width:160}
			
		]]
	});
	
	/*$HUI.datagrid('#balancesubdaydatagrid',{
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
		]]
	});
	$HUI.datagrid('#hisdatagrid',{
		title:'His分类账目',
		iconCls:'icon-w-cal',
		fitColumns:true,
		fit:true,
		rownumbers:true,
		singleSelect:true,
		pagination:true,
		pageSize:10,
		pageList:[10,20,30],
		columns:[[     
			{field:'1',title:'角色编码',width:100},    
			{field:'2',title:'角色组名称',width:100},
			{field:'3',title:'角色编码',width:100},    
			{field:'4',title:'角色组名称',width:100},
			{field:'5',title:'角色编码',width:100},    
			{field:'6',title:'角色组名称',width:100},
		]]
	});*/
}
//页面事件初始化
function setElementEvent(){
	$('#BusSearchBtn').click(function(){
		loadBalanceDayInfo();
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
	$('#Errorgrid').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.EInvBalanceCtl",
		QueryName:"QueryBalanceListErr",
		busBgnDate:BusStDate,
		busEndDate:BusEdDate,
		placeCode:""
	});		
}