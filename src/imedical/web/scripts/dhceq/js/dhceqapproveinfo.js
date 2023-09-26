function getUrlParam(name) {
	var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
	var r = window.location.search.substr(1).match(reg);  //匹配目标参数
	if (r != null) return unescape(r[2]); return null; //返回参数值
}

$(document).ready(function(){

$("#tApproveInfo").datagrid({
	url:"dhceq.jquery.csp",
	panelWidth:1200,
	queryParams:{
		ClassName:"web.DHCEQMessages",
		QueryName:"GetApproveList",
		Arg1:getUrlParam("BussType"),
		Arg2:getUrlParam("BussID"),
		ArgCnt:2
		},
	singleSelect:true,
	columns:[[
		{field:'TRowID',title:'TRowID',width:110,align:'center',hidden:true},
		{field:'TRow',title:'序号',width:50,align:'center'},
		{field:'TApproveDate',title:'日期',width:110,align:'center'},
		{field:'TApproveTime',title:'时间',width:110,align:'center'},
		{field:'TApproveRole',title:'审批角色',width:110,align:'center'},
		{field:'TApproveUser',title:'审批人',width:110,align:'center'},
		{field:'TOpinion',title:'审批意见',width:100,align:'center'},
		{field:'TAction',title:'动作',width:100,align:'center'}
	]],
	pagination:true,
	pageSize:15,
	pageNumber:1,
	pageList:[15,30,45,60,75]
});


})