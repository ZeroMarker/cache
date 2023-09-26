var kpiObj = $HUI.datagrid("#kpiTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',
		QueryName:'GetPoolKPI'
	},
	fitColumns:true,
	toolbar:"#kpiToobar",
	pagination:true, //允许用户通过翻页导航数据
	pageSize:15,  //设置首次界面展示时每页加载条数
	pageList:[10,15,20,50,100], //设置分页可选展示条数
	onClickRow:function(rowIndex, rowData){
		var kpiCode = rowData.kpiCode;
		$("#rptTable").datagrid("load",{ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',QueryName:'GetRptByKPI',kpiCode:kpiCode});
	}
})

var rptObj = $HUI.datagrid("#rptTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',
		QueryName:'GetRptByKPI'
	},
	toolbar:[],
	fitColumns:true,
	pagination:true, //允许用户通过翻页导航数据
	pageSize:15,  //设置首次界面展示时每页加载条数
	pageList:[10,15,20,50,100] //设置分页可选展示条数
})

/*--统计项统计内容查询--*/
$('#searchText').searchbox({
	searcher:function(value,name){
		kpiObj.load({ClassName:"web.DHCWL.V1.ComplexRpt.ComplexRptFun",QueryName:"GetPoolKPI",filterValue:value});
	}
})