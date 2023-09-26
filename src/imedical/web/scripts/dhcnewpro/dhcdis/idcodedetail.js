$(document).ready(function(){
	
	//初始化 table
	initTable();
	
	})

function initTable()
{
	//定义columns
	var columns=[[
	    //{field:'RCPointer',title:'disreqID',width:80,hidden:false},
		//{field:"ck",checkbox:true,width:20},
		{field:'DisRCCode',title:'验证码',width:200,align:'center'},
		{field:'DisRCCreateDate',title:'创建日期',width:200,align:'center'},
		{field:'DisRCCreateTime',title:'创建时间',width:200,align:'center'},
		{field:'DisRCCreateUser',title:'创建人',width:200,align:'center'},
		{field:'DisRCActiveFlag',title:'是否可用',width:200,align:'center'}
	]];
	//var param = disreqID
	
	//验证码明细
	$('#codedetail').datagrid({
		//url:LINK_CSP+'?ClassName=web.DHCDISEscortArrage&MethodName=codequery&param='+param,
	    columns:columns,
	    fit:true,
	    title:'',
	    fitColumns:true,
	    rownumbers:true,
	    pageSize:20, // 每页显示的记录条数
	    pageList:[20,40],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    loadMsg: '正在加载信息...',
	    pagination:true,
	    nowrap:false//数据自动换行
		//onClickRow:function(Index, row){
		//	disreqID=row.DisREQ;
		//	ClickRowDetail(disreqID);//显示申请单明细列表
		//}
	});
	search();
}

function search(){
	var Params=disreqID+"^"+TypeID; //获取参数
	$('#codedetail').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISGoodsRequest&MethodName=QueryCodeDetail',	
			queryParams:{
			StrParam:Params}	
	});
	
}