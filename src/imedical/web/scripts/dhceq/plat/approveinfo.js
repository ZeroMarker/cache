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
	    rownumbers: true,  //如果为true，则显示一个行号列。
	    //columns:Columns,
	    columns:[[
			{field:'TRowID',title:'TRowID',width:110,align:'center',hidden:true},
			{field:'TApproveDate',title:'日期',width:110,align:'center'},
			{field:'TApproveTime',title:'时间',width:110,align:'center'},
			{field:'TApproveRole',title:'审批角色',width:110,align:'center'},
			{field:'TApproveUser',title:'审批人',width:110,align:'center'},
			{field:'TOpinion',title:'审批意见',width:100,align:'center'},
			{field:'TAction',title:'动作',width:100,align:'center'}
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
	$("#ApproveInfoView").empty(); //每次加载之前移除样式
	//按时间倒序,从最大值遍历
	for (var i=jsonData.rows.length-1;i>=0;i--)
	{
		var approveDate=jsonData.rows[i].TApproveDate; //变动日期
		var approveTime=jsonData.rows[i].TApproveTime;	//变动类型
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