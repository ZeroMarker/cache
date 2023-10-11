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
            QueryName:"GetBussMessages",
            dataType: 'json',
            Arg1:BussType,
            Arg2:'',
			Arg3:'',
			Arg4:'',
			Arg5:'' ,
			Arg6:'' ,
			Arg7:'',
			Arg8:'' ,
			Arg9:'' ,
			Arg10:'' ,
			Arg11:'' ,
			Arg12:'', 
			Arg13:BussID, 
            ArgCnt:13
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
	$("#BussInfoView").empty(); //每次加载之前移除样式
	//按时间倒序,从最大值遍历
	for (var i=0;i<jsonData.rows.length;i++)
	{
		var statusFlag=0
		var MessDealDate=jsonData.rows[i].TMessDealDate; 
		var MessDealTime=jsonData.rows[i].TMessDealTime; 
		var MessDealUser=jsonData.rows[i].TMessDealUser;  
		var ApproveRole=jsonData.rows[i].TApproveRole; 
		var Action=jsonData.rows[i].TAction; 
		//Modified By QW20200819 BUG:QW0074 begin 修改消息信息显示 
		var SendUser=jsonData.rows[i].TSendUser; 
		var keyInfo=ApproveRole+"(发送人:"+SendUser+")"+"    "+Action+"    用户("+MessDealUser+")于 "+MessDealDate+" "+MessDealTime+" 处置"
		var flag="";
		if(jsonData.rows[i].TMessDealFlag=="N")
		{
			statusFlag=1
			flag=1;
			keyInfo=ApproveRole+"----发送人:"+SendUser+"    "+Action+"    接收人----"+MessDealUser
		}
		//Modified By QW20200819 begin 修改消息信息显示 
		opt={
			id:'BussInfoView',
			item:'^^'+'%^^'+keyInfo,
			lastFlag:flag,
			onOrOff:statusFlag
		}
		
		createTimeLine(opt);
	}
}