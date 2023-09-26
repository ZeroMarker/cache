$(document).ready(function () {
    initDocument();
});
var LatestBusstype=91;
var LatestBussID=$("#BuyReqDR").val();
var LatestBussName="采购申请";
var LatestBussStatus=$("#BuyReqStatus").val();	//modified by czf 2019-12-16 CZF0050
function initDocument()
{
	createBuyReqprocess("buyrequestprocess",$("#BuyReqDR").val())
	initLifeInfo(LatestBusstype,LatestBussID,LatestBussName,LatestBussStatus)
	//ApproveInfo("","")	业务审批进度
}
function createBuyReqprocess(vElementID,vSourceID)
{
	var BuyReqProcess=tkMakeServerCall("web.DHCEQBuyRequest","GetBuyReqProcess",vSourceID)
	//var BuyReqProcessObj=JSON.parse(BuyReqProcess)
	//var BuyReqProcessInfo=BuyReqProcessObj["Data"]
	var BuyReqFlow=BuyReqProcess.split("^")
	var html=""
	//modified by czf 2019-12-16 begin CZF0050
	var JumpID=0
	for (var j=BuyReqFlow.length-1;j>=0;j--)
	{
		var BuyReqProcessInfo=BuyReqFlow[j].split("#");
		var OneInfo=BuyReqProcessInfo[0].split("=");
		var BusInfo=BuyReqProcessInfo[1].split(",");
		if((BusInfo[2]==11)||(BusInfo[2]==21)||(BusInfo[2]==22)||(BusInfo[2]==91)) continue;	//验收、入库、转移、采购申请无论是否做业务都显示
		if(OneInfo[1]==1)
		{
			JumpID=j;	//记录下倒序时第一个审核的业务位置
			break;
		}
	}
	//modified by czf 2019-12-16 end CZF0050
	for (var i=0;i<BuyReqFlow.length;i++)
	{
		var BuyReqProcessInfo=BuyReqFlow[i].split("#");
		var OneInfo=BuyReqProcessInfo[0].split("=");
		var BusInfo=BuyReqProcessInfo[1].split(",");
		if((i<JumpID)&&(OneInfo[1]==0)) continue;	//已审核业务之前未进行的业务不显示 modified by czf 2019-12-16 CZF0050
		var captionhtml="<a class='BussNameOff' style=\"color: #C0C0C0;font-size:16px;padding:0 10px 0px 10px;\">"+OneInfo[0]+"</a>"
		var imghtml1="<a><img src='../images/eq-line-1.png'></a>"
		var imghtml2=imghtml1
		if (OneInfo[1]==1)
		{
			captionhtml="<a class='BussNameOn' href='#' style='color: #40A2DE;font-size:16px;padding:0 10px 0px 10px;' onclick=initLifeInfo("+BusInfo[2]+","+BusInfo[0]+",'"+OneInfo[0]+"'"+","+BusInfo[1]+")>"+OneInfo[0]+"</a>"
			if (BusInfo[1]==0)	//新增
			{
				imghtml1="<a><img src='../images/eq-line-1.png'></a>"
				imghtml2="<a><img src='../images/eq-line-1.png'></a>"
			}
			if (BusInfo[1]==1)	//提交
			{
				imghtml1="<a><img src='../images/eq-line-2.png'></a>"
				imghtml2="<a><img src='../images/eq-line-1.png'></a>"
			}
			if (BusInfo[1]==2)	//审核
			{
				imghtml1="<a><img src='../images/eq-line-2.png'></a>"
				imghtml2="<a><img src='../images/eq-line-2.png'></a>"
			}
			LatestBusstype=BusInfo[2];
			LatestBussID=BusInfo[0];
			LatestBussName=OneInfo[0];
			LatestBussStatus=BusInfo[1];
		}
		if (i<(BuyReqFlow.length-1))
		{
			html=html+captionhtml+imghtml1+imghtml2
		}
		else
		{
			html=html+captionhtml
		}
	}
	$("#"+vElementID).append(html);
}

function initLifeInfo(BussType,BussID,LatestBussName,BussStatus)
{
	var tempobj = $('#brprocessInfo').layout('panel','center');
	tempobj.panel('setTitle',LatestBussName+"审批详细");
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
        		createLifeInfo(data,BussStatus);
			}
       }
            
    })
}

function createLifeInfo(jsonData,BussStatus)
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
		///Modified BY ZY0204  把审批的所有操作都记录下来
		var OperateType=jsonData.rows[i].TOperateType; //操作类型
		var keyInfo=ApproveUser+" "+Action+"，审批意见："+Opinion
		if (OperateType==1) keyInfo=ApproveUser+" "+Action+"，拒绝，拒绝原因："+Opinion
		if (ApproveRole!="") keyInfo=ApproveRole+" "+keyInfo
		var section="";
		var flag="";
		if((i==jsonData.rows.length-1)&&(BussStatus!=2)) flag=1;
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
	if(BussStatus==2)		//modified by czf 2019-12-16 CZF0050
	{
		var CurHtml=$("#ApproveInfoView").html();
		var html='<li class="eq-times-ul-li-noneborder2"><b class="eq-times-point"></b>';
		html=html+'<div>'+"完成"+'</div>'+'</li>';
		$("#ApproveInfoView").append(html);
	}
}

function ApproveInfo(BussType,BussID)
{
	$("#tApproveInfo").datagrid({
	url:"dhceq.jquery.csp",
	panelWidth:1200,
	queryParams:{
		ClassName:"web.DHCEQ.Plat.LIBMessages",
		QueryName:"GetApproveList",
		Arg1:BussType,
		Arg2:BussID,
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
}