$(document).ready(function () {
    initDocument();
});
function initDocument()
{
	var ShareRSDR=$("#ShareRSDR").val();
	initRentHistoryInfo(ShareRSDR)
}

function initRentHistoryInfo(ShareRSDR)
{
	$.ajax({
		url :"dhceq.jquery.csp",
        type:"POST",
        data:{
            ClassName:"web.DHCEQ.RM.BUSRent",
            QueryName:"GetRentHistory",
            dataType: 'json',
            Arg1:ShareRSDR,
            ArgCnt:1
        },
        success:function (data, response, status) {
	        console.log(data)
	        $.messager.progress('close');
	        	if(data)
				{
					data=JSON.parse(data);
	        		createRentHistoryInfo(data);
				}
	       }
    })
}

function createRentHistoryInfo(jsonData)
{
	//日期jsonData.rows[i].TRequestDate
	//单号jsonData.rows[i].TRequestNo TStartDate TStartTime TReturnDate TReturnTime
	//科室jsonData.rows[i].TRequestLoc+jsonData.rows[i].TLocReturn+"租借"+设备名称jsonData.rows[i].TEquip+租赁时长jsonData.rows[i].TWorkLoad+jsonData.rows[i].TWorkLoadUOM
	var curYearMonth=""
	$("#RentHistoryInfoView").empty(); //每次加载之前移除样式
	//按时间倒序,从最大值遍历
	for (var i=0;i<jsonData.rows.length;i++)
	{
		var statusFlag=0
		var TRequestStartDateTime="开始时间："+jsonData.rows[i].TStartDate+" "+jsonData.rows[i].TStartTime
		var TRequestReturnDateTime="，结束时间："+jsonData.rows[i].TReturnDate+" "+jsonData.rows[i].TReturnTime	

		var TRequestDate=TRequestStartDateTime+TRequestReturnDateTime	//jsonData.rows[i].TRequestDate //日期
		//modify by lmm 2020-06-05 UI
		//Modify by zx 2020-06-09 BUG ZX0100
		var TRequestNo="租赁单号：<a href=# onclick=showWindow('dhceq.rm.rent.csp?&RowID="+jsonData.rows[i].TRowID+"&ReadOnly=1','租赁详细','','','icon-w-paper','modal','','','middle','')>"+jsonData.rows[i].TRequestNo+"</a>"	//单号
		var TRequestInfo=jsonData.rows[i].TRequestLoc+jsonData.rows[i].TLocReturn+"租借"+jsonData.rows[i].TWorkLoad+jsonData.rows[i].TWorkLoadUOM //+TRequestStartDateTime+TRequestReturnDateTime
//		var ApproveDate=jsonData.rows[i].TApproveDate; //审批日期
//		var ApproveTime=jsonData.rows[i].TApproveTime; //审批时间
//		var ApproveUser=jsonData.rows[i].TApproveUser; //审批人
//		var Opinion=jsonData.rows[i].TOpinion; //审批人
		var YearMonth=jsonData.rows[i].TRequestDate.split("-")[0]+'-'+jsonData.rows[i].TRequestDate.split("-")[1]; 
//		var ApproveRole=jsonData.rows[i].TApproveRole; //审批角色
//		var Action=jsonData.rows[i].TAction; //审批动作
//		var keyInfo=ApproveUser+" "+Action+"，审批意见："+Opinion
//		if (ApproveRole!="") keyInfo=ApproveRole+" "+keyInfo
		var section="";
		var flag="";
		if(i==jsonData.rows.length-1) flag=1;
		if ((curYearMonth!=YearMonth)&&(YearMonth!=""))
		{
			curYearMonth=YearMonth;
			section="eq-lifeinfo-lock.png^"+YearMonth;
		}
//		ApproveDate=ApproveDate+" "+ApproveTime
//		var ApproveInfo=""
//		if(ApproveDate==" ") 
//		{
//			statusFlag=1
//			ApproveInfo=keyInfo
//		}
//		else ApproveInfo=ApproveDate+"，"+keyInfo
		//var url='href="#" onclick="javascript:lifeInfoDetail('+sourceTypeDR+','+sourceID+')"';
		opt={
			id:'RentHistoryInfoView',
			section:section,
			item:'^^'+'%^^'+TRequestDate+'%^^'+TRequestNo+'%^^'+TRequestInfo,	//+'%^^'+TRequestStartDateTime+'%^^'+TRequestReturnDateTime,
			lastFlag:flag,
			onOrOff:statusFlag
		}
		
		createTimeLine(opt);
	}
	if(jsonData.rows.length==0)
	{
		opt={
			id:'RentHistoryInfoView',
			section:"eq-lifeinfo-lock.png^"+new Date().getFullYear()+'-'+(new Date().getMonth()+1),
			item:'^^还没有租赁历史',
			lastFlag:1,
			onOrOff:1
		}
		
		createTimeLine(opt);
	}
}