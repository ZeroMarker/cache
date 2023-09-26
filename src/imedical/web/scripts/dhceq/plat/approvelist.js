$(document).ready(function () {
    initDocument();
});
function initDocument()
{
	var BussType=$("#SourceType").val();
	var BussID=$("#SourceID").val();
	initBussLifeInfo(BussType,BussID)
}

function initBussLifeInfo(BussType,BussID)
{
	$.ajax({
		url :"dhceq.jquery.csp",
        type:"POST",
        data:{
            ClassName:"web.DHCEQ.Plat.LIBMessages",
            QueryName:"GetApproveList",
            dataType: 'json',
            Arg1:BussType,
            Arg2:BussID,
            ArgCnt:2
        },
        success:function (data, response, status) {
        $.messager.progress('close');
        	if(data)
			{
				data=JSON.parse(data);
        		createLifeInfo(data);
			}
       }
            
    })
}

function createLifeInfo(jsonData)
{
	var curYear=""
	$("#ApproveInfoView").empty(); //每次加载之前移除样式
	//按时间倒序,从最大值遍历
	for (var i=0;i<jsonData.rows.length;i++)
	{
		var statusFlag=0
		var ApproveDate=jsonData.rows[i].TApproveDate; //审批日期
		var ApproveTime=jsonData.rows[i].TApproveTime; //审批时间
		var ApproveUser=jsonData.rows[i].TApproveUser; //审批人
		var Opinion=jsonData.rows[i].TOpinion; //审批人
		var Year=jsonData.rows[i].TYear; 
		var ApproveRole=jsonData.rows[i].TApproveRole; //审批角色
		var Action=jsonData.rows[i].TAction; //审批动作
		var keyInfo=ApproveUser+" "+Action+"，审批意见："+Opinion
		if (ApproveRole!="") keyInfo=ApproveRole+" "+keyInfo
		var section="";
		var flag="";
		if(i==jsonData.rows.length-1) flag=1;
		if ((curYear!=Year)&&(Year!=""))
		{
			curYear=Year;
			section="eq-lifeinfo-lock.png^"+Year;
		}
		ApproveDate=ApproveDate+" "+ApproveTime
		var ApproveInfo=""
		if(ApproveDate==" ") 
		{
			statusFlag=1
			ApproveInfo=keyInfo
		}
		else ApproveInfo=ApproveDate+"，"+keyInfo
		//var url='href="#" onclick="javascript:lifeInfoDetail('+sourceTypeDR+','+sourceID+')"';
		opt={
			id:'ApproveInfoView',
			section:section,
			item:'^^'+'%^^'+ApproveInfo,
			lastFlag:flag,
			onOrOff:statusFlag
		}
		
		createTimeLine(opt);
	}
}