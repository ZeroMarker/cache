$(function(){
	var ApproveInfoObj=$HUI.datagrid("#tApproveInfo",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.LIBMessages",
			QueryName:"GetApproveList",
			BussType:getElementValue("SourceType"),
			SourceID:getElementValue("SourceID")
		},
		border:true,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
	    //columns:Columns,
	    columns:[[
			{field:'TRowID',title:'TRowID',width:110,align:'center',hidden:true},
			{field:'TApproveDate',title:'����',width:110,align:'center'},
			{field:'TApproveTime',title:'ʱ��',width:110,align:'center'},
			{field:'TApproveRole',title:'������ɫ',width:110,align:'center'},
			{field:'TApproveUser',title:'������',width:110,align:'center'},
			{field:'TOpinion',title:'�������',width:100,align:'center'},
			{field:'TAction',title:'����',width:100,align:'center'}
		]],
		pagination:true,
		pageSize:10,
		pageList:[10]
	});
	//initDocument();
}); 
function initDocument(){
	initApproveInfo();
};

function initApproveInfo()
{
	$.cm({
		ClassName:"web.DHCEQ.Plat.LIBMessages",
		QueryName:"GetApproveList",
		BussType:getElementValue("SourceType"),
		SourceID:getElementValue("SourceID")
	},function(jsonData){
		createApproveInfo(jsonData);
	});
}

function createApproveInfo(jsonData)
{
	$("#ApproveInfoView").empty(); //ÿ�μ���֮ǰ�Ƴ���ʽ
	//��ʱ�䵹��,�����ֵ����
	for (var i=jsonData.rows.length-1;i>=0;i--)
	{
		var approveDate=jsonData.rows[i].TApproveDate; //�䶯����
		var approveTime=jsonData.rows[i].TApproveTime;	//�䶯����
		var approveRole=jsonData.rows[i].TApproveRole;
		var approveUser=jsonData.rows[i].TApproveUser;
		var option=jsonData.rows[i].TOpinion;
		var action=jsonData.rows[i].TAction;
		
		var flag="";
		if(i==0) flag=1;
		var dataInfo=approveDate+"&nbsp"+approveTime;
		var approveUser=approveUser;
		if (approveRole!="") approveUser=approveUser+"("+approveRole+")";
		approveUser=approveUser+"&nbsp"+action;
		opt={
			id:'ApproveInfoView',
			section:'',
			item:'^^'+dataInfo+'%eq-user.png^^'+approveUser+'%^^'+option,
			lastFlag:flag
		}
		
		createTimeLine(opt);
	}
}