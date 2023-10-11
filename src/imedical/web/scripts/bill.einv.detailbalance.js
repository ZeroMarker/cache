/// 名称: bill.einv.detailbalance.js
/// 描述: 电子发票明细对账
/// 编写者：xubaobao
/// 编写日期: 2020-09-14

var UserID = session['LOGON.USERID'];
var Hospital = session['LOGON.HOSPID'];
var Group=session['LOGON.GROUPID']
var Loc=session['LOGON.CTLOCID']

$(function(){
	setPageLayout(); //页面布局初始化
	setElementEvent(); //页面事件初始化
});

//页面布局初始化
function setPageLayout(){
	//获取开始日期
	var StDate = new Date().getFullYear() + "-" + (new Date().getMonth() + 1) + "-" + (new Date().getDate()-1);
	//获取结束日期
	var EdDate = new Date().getFullYear() + "-" + (new Date().getMonth() + 1) + "-" + (new Date().getDate()-1);
	//设置开始日期值
	$('#BusStDate').datebox('setValue', StDate);
	//设置结束日期值
	$('#BusEdDate').datebox('setValue', EdDate);
	$HUI.datagrid('#Centergrid',{
		title:'第三方电子票据明细',
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
				{field:'CTBalanceFlag',title:'对账标识',align:'center',width:80},
				{field:'CTBusNo',title:'业务流水号',align:'center',width:120},
				{field:'CTPlaceCode',title:'开票点',align:'center',width:80},
				{field:'CTBillBatchCode',title:'票据代码',align:'center',width:100},
				{field:'CTBillNo',title:'票据号码',align:'center',width:100},
				{field:'CTRandom',title:'校验码',align:'center',width:80,hidden:true},
				{field:'CTTotalAmt',title:'总金额',align:'center',width:80},
				{field:'CTBusDate',title:'业务日期',align:'center',width:140},
				{field:'CTBillName',title:'票据种类名称',align:'center',width:120}
			]]
	});
	
	$HUI.datagrid('#Hisgrid',{
		title:'HIS电子票据明细',
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
				{field:'HISBalanceFlag',title:'对账标识',align:'center',width:80},
				{field:'HISBusNo',title:'业务流水号',align:'center',width:120},
				{field:'HISPlaceCode',title:'开票点',align:'center',width:80},
				{field:'HISBillBatchCode',title:'票据代码',align:'center',width:100},
				{field:'HISBillNo',title:'票据号码',align:'center',width:100},
				{field:'HISRandom',title:'校验码',align:'center',width:80,hidden:true},
				{field:'HISTotalAmt',title:'总金额',align:'center',width:80},
				{field:'HISBusDate',title:'业务日期',align:'center',width:140},
				{field:'HISBillName',title:'票据种类名称',align:'center',width:120}
			]]
	});
	
	$HUI.datagrid('#CenterErrorgrid',{
		title:'第三方对账异常数据',
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
			{field:'CTPlaceCodeErr',title:'开票点',align:'center',width:120},
			{field:'CTMedicalDrErr',title:'HIS明细ID',align:'center',width:100},
			{field:'CTCenterDrErr',title:'第三方明细ID',align:'center',width:100},
			{field:'CTBillBatchCodeErr',title:'票据代码',align:'center',width:100},
			{field:'CTBillNoErr',title:'票据号码',align:'center',width:100},
			{field:'CTRandomErr',title:'校验码',align:'center',width:80,hidden:true},
			{field:'CTTotalAmtErr',title:'总金额',align:'center',width:80},
			{field:'CTDataTypeErr',title:'数据类型',align:'center',width:80},
			{field:'CTiBlanceDateErr',title:'对账日期',align:'center',width:140},
			{field:'CTiBlanceUserDrErr',title:'对账人',align:'center',width:100}
		]]
	});
	$HUI.datagrid('#HisErrorgrid',{
		title:'HIS对账异常数据',
		iconCls:'icon-w-cal',
		fitColumns:true,
		fit:true,
		rownumbers:true,
		singleSelect:true,
		pagination:true,
		pageSize:10,
		pageList:[10,20,30],
		columns:[[     
			{field:'HISPlaceCodeErr',title:'开票点',align:'center',width:120},
			{field:'HISMedicalDrErr',title:'HIS明细ID',align:'center',width:100},
			{field:'HISCenterDrErr',title:'第三方明细ID',align:'center',width:100},
			{field:'HISBillBatchCodeErr',title:'票据代码',align:'center',width:100},
			{field:'HISBillNoErr',title:'票据号码',align:'center',width:100},
			{field:'HISRandomErr',title:'校验码',align:'center',width:80,hidden:true},
			{field:'HISTotalAmtErr',title:'总金额',align:'center',width:80},
			{field:'HISDataTypeErr',title:'数据类型',align:'center',width:80},
			{field:'HISiBlanceDateErr',title:'对账日期',align:'center',width:140},
			{field:'HISiBlanceUserDrErr',title:'对账人',align:'center',width:100}
		]]
	})
}

//页面事件初始化
function setElementEvent(){
	
	//查询
	$('#BusSearchBtn').click(function(){
		loadCenterEInvInfo();
		loadHISEInvInfo();
		loadErrorEInvInfo()
	});
	
	//对账
	$('#BalanceBtn').click(function(){
		EInvBalance();
	});
	
	//同步HIS明细数据
	$('#HISLoadBtn').click(function(){
		HISEInvDataLoad();
	});
	
}


//同步HIS明细数据
function HISEInvDataLoad(){
	var BusStDate = $('#BusStDate').datebox('getValue');
	var BusEdDate = $('#BusEdDate').datebox('getValue');
	
	if(BusStDate!=BusEdDate){
		alert("获取明细数据不能跨天操作！");
		return;
	}
	
	$m({
		ClassName:"BILL.EINV.BL.COM.EInvBalanceCtl",
		MethodName:"DLMedicalEInvInfo",
		busBgnDate:BusStDate,
		busEndDate:BusEdDate
	},function(rtn){
		if(rtn!= "0"){
			$.messager.alert("提示","同步数据失败");
		}else{
			$.messager.alert("提示","同步数据成功");
			//$('#Centergrid').datagrid('reload');
			//$('#Hisgrid').datagrid('reload');
			//loadErrorEInvInfo();
		}
	});
}

//获取第三方电子票据数据
function loadCenterEInvInfo(){
	var BusStDate = $('#BusStDate').datebox('getValue');
	var BusEdDate = $('#BusEdDate').datebox('getValue');
	var placeCode=$('#placeCode').val();
	
	if(BusStDate!=BusEdDate){
		alert("获取明细数据不能跨天操作！");
		return;
	}
	
	$('#Centergrid').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.EInvBalanceCtl",
		QueryName:"QueryCenterEInvInfo",
		busBgnDate:BusStDate,
		busEndDate:BusEdDate,
		placeCode:placeCode,
		BalanceFlag:""
	});	
}

//获取HIS电子票据数据
function loadHISEInvInfo(){
	var BusStDate = $('#BusStDate').datebox('getValue');
	var BusEdDate = $('#BusEdDate').datebox('getValue');
	var placeCode=$('#placeCode').val();
	
	if(BusStDate!=BusEdDate){
		alert("获取明细数据不能跨天操作！");
		return;
	}
	
	$('#Hisgrid').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.EInvBalanceCtl",
		QueryName:"QueryHISEInvInfo",
		busBgnDate:BusStDate,
		busEndDate:BusEdDate,
		placeCode:placeCode,
		BalanceFlag:""
	});	
}

// 异常数据
function loadErrorEInvInfo(){
	var BusStDate = $('#BusStDate').datebox('getValue');
	var BusEdDate = $('#BusEdDate').datebox('getValue');
	var placeCode=$('#placeCode').val();
	
	if(BusStDate!=BusEdDate){
		alert("获取明细数据不能跨天操作！");
		return;
	}
	
	$('#CenterErrorgrid').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.EInvBalanceCtl",
		QueryName:"QueryCTBalanceListErr",
		busBgnDate:BusStDate,
		busEndDate:BusEdDate,
		placeCode:placeCode
	});	
	
	$('#HisErrorgrid').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.EInvBalanceCtl",
		QueryName:"QueryHISBalanceListErr",
		busBgnDate:BusStDate,
		busEndDate:BusEdDate,
		placeCode:placeCode
	});	
}


//对账
function EInvBalance(){
	
	var BusStDate = $('#BusStDate').datebox('getValue');
	var BusEdDate = $('#BusEdDate').datebox('getValue');
	var placeCode=$('#placeCode').val();
	var Exstr=UserID+"^"+Hospital;			//对账人^院区^数据类型
	
	if(BusStDate!=BusEdDate){
		alert("获取明细数据不能跨天操作！");
		return;
	}
	
	$m({
		ClassName:"BILL.EINV.BL.COM.EInvBalanceCtl",
		MethodName:"EInvDetailBalance",
		busBgnDate:BusStDate,
		busEndDate:BusEdDate,
		placeCode:placeCode,
		Exstr:Exstr
	},function(rtn){
		if(rtn!= "0"){
			$.messager.alert("提示","对账失败");
		}else{
			$.messager.alert("提示","对账成功");
			$('#Centergrid').datagrid('reload');
			$('#Hisgrid').datagrid('reload');
			loadErrorEInvInfo();
		}
	});
}
