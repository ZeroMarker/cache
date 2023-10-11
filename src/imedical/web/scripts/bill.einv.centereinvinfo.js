<!--js  bill.einv.centereinvinfo.js -->
<!-- 入口函数 -->
$(function(){
	setPageLayout();
	setElementEvent();	
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
	$('#BusEDate').datebox('setValue', EdDate);
	
	$('#CetaList').datagrid({
		pagination:'true', // 分页工具栏
		pageSize:'10',
		pageList:[10,20,30],
		singleSelect:'true',
		striped:'true', // 显示斑马线效果
		height: 600,
		//rownumbers:true,
		fit:true,
		url:$URL,
		queryParams: {
			ClassName:"BILL.EINV.BL.COM.CenterEInvInfoCtl",
			QueryName:"QueryCenterEInvInfo"
		},
		columns:[[
			{field:'ID',title:'ID'},
			{field:'checkbox',checkbox:true},
			{field:'BusNo',title:'业务流水号',width:300,hidden:true},
			{field:'PlaceCode',title:'开票点编码',width:100},
			{field:'BillName',title:'票据种类名称',width:270},
			{field:'BillBatchCode',title:'票据代码',width:100},
			{field:'BillNo',title:'票据号码',width:100},
			{field:'Random',title:'校验码',width:100},
			{field:'TotalAmt',title:'总金额',width:100},
			{field:'BusDate',title:'业务日期',width:100},
			{field:'BusTime',title:'业务时间',width:100},
			{field:'IvcDate',title:'开票日期',width:100},
			{field:'IvcTime',title:'开票时间',width:100},
			{field:'DataType',title:'数据类型',width:100},
			{field:'State',title:'状态',width:100},
			{field:'RelateBillBatchCode',title:'关联电子票据代码',width:120},
			{field:'RelateBillNo',title:'关联电子票据号码',width:120},
			{field:'InvFactoryCD',title:'开发商编码',width:100},
			{field:'InvFactoryNM',title:'开发商名称 ',width:100},
			{field:'XStr1',title:'备用1 ',width:60,hidden:true},
			{field:'XStr2',title:'备用2 ',width:60,hidden:true},
			{field:'XStr3',title:'备用3 ',width:60,hidden:true},
			{field:'XStr4',title:'备用4 ',width:60,hidden:true},
			{field:'XStr5',title:'备用5 ',width:60,hidden:true}
		]],
		onBeforeLoad:function(param){
			param.rows='';
		}
	});
}	
	


function setElementEvent(){
	$('#searchBtn').click(function(){
		SearchBtn();
	});
	$('#DownLoadBtn').click(function(){
		DownBillData();
	});
}
//查询
function SearchBtn(){
	var PlaceCode=$('#PlaceCode').val();
	var BillBatchCode="";
	var BillNo="";
	var BusDate=$('#BusStDate').datebox('getValue');
	var EdDate=$('#BusEDate').datebox('getValue');
	//alert(BusDate+"^"+EdDate+"^"+PlaceCode)
	$('#CetaList').datagrid('load',{
			ClassName:"BILL.EINV.BL.COM.CenterEInvInfoCtl",
			QueryName:"QueryCenterEInvInfo",
			PlCode:PlaceCode,
			BBatchCode:BillBatchCode,
			BiNo:BillNo,
			stDate:BusDate,
			edDate:EdDate
	});
	
}

//下载票据数据
function DownBillData(){
	var BusStDate =$('#BusStDate').datebox('getValue');
	var BusEdDate =$('#BusEDate').datebox('getValue');
	
	var InputPam=BusStDate+"^"+BusEdDate+"^^^1^200"
	//alert(InputPam)
	$m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"DLEInvBillMXList",
		InputPam:InputPam
	},function(rtn){
		if(rtn=="0"){
			SearchBtn();
		}else{
			$.messager.alert("提示","下载数据失败");
		}
	});
}




