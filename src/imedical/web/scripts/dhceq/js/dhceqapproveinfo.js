function getUrlParam(name) {
	var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //����һ������Ŀ�������������ʽ����
	var r = window.location.search.substr(1).match(reg);  //ƥ��Ŀ�����
	if (r != null) return unescape(r[2]); return null; //���ز���ֵ
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
		{field:'TRow',title:'���',width:50,align:'center'},
		{field:'TApproveDate',title:'����',width:110,align:'center'},
		{field:'TApproveTime',title:'ʱ��',width:110,align:'center'},
		{field:'TApproveRole',title:'������ɫ',width:110,align:'center'},
		{field:'TApproveUser',title:'������',width:110,align:'center'},
		{field:'TOpinion',title:'�������',width:100,align:'center'},
		{field:'TAction',title:'����',width:100,align:'center'}
	]],
	pagination:true,
	pageSize:15,
	pageNumber:1,
	pageList:[15,30,45,60,75]
});


})