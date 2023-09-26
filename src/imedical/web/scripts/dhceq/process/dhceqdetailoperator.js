$(document).ready(function(){
	$('#dhceqoperator').datagrid(
	{
		url:'dhceq.jquery.csp',
		border:'true',	   
		queryParams:{
			ClassName:"web.DHCEQLifeInfo",
			QueryName:"GetDetailOperatorInfo",
			Arg1:$("#SourceType").val(),
			Arg2:$("#SourceID").val(),
			ArgCnt:2
			},
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�TRowID,TOpinion,TApproveUserDR,TApproveDate
		singleSelect:true,
		columns:[[
			{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
			{field:'TOpinion',title:'���',width:200,align:'center'},
			{field:'TApproveRole',title:'��ɫ',width:100,align:'center'},
			{field:'TApproveUserDR',title:'������',width:100,align:'center'},
			{field:'TApproveDate',title:'��������',width:150,align:'center'},
		]],
		//onClickRow:function(rowIndex,rowData){OnclickRow();},
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75]
	});
});
