$(document).ready(function () {
    initDocument();
});
var LatestBusstype=91;
var LatestBussID=$("#BuyReqDR").val();
var LatestBussName="�ɹ�����";
var LatestBussStatus=$("#BuyReqStatus").val();	//modified by czf 2019-12-16 CZF0050
function initDocument()
{
	createBuyReqprocess("buyrequestprocess",$("#BuyReqDR").val())
	initLifeInfo(LatestBusstype,LatestBussID,LatestBussName,LatestBussStatus)
	//ApproveInfo("","")	ҵ����������
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
		if((BusInfo[2]==11)||(BusInfo[2]==21)||(BusInfo[2]==22)||(BusInfo[2]==91)) continue;	//���ա���⡢ת�ơ��ɹ����������Ƿ���ҵ����ʾ
		if(OneInfo[1]==1)
		{
			JumpID=j;	//��¼�µ���ʱ��һ����˵�ҵ��λ��
			break;
		}
	}
	//modified by czf 2019-12-16 end CZF0050
	for (var i=0;i<BuyReqFlow.length;i++)
	{
		var BuyReqProcessInfo=BuyReqFlow[i].split("#");
		var OneInfo=BuyReqProcessInfo[0].split("=");
		var BusInfo=BuyReqProcessInfo[1].split(",");
		if((i<JumpID)&&(OneInfo[1]==0)) continue;	//�����ҵ��֮ǰδ���е�ҵ����ʾ modified by czf 2019-12-16 CZF0050
		var captionhtml="<a class='BussNameOff' style=\"color: #C0C0C0;font-size:16px;padding:0 10px 0px 10px;\">"+OneInfo[0]+"</a>"
		var imghtml1="<a><img src='../images/eq-line-1.png'></a>"
		var imghtml2=imghtml1
		if (OneInfo[1]==1)
		{
			captionhtml="<a class='BussNameOn' href='#' style='color: #40A2DE;font-size:16px;padding:0 10px 0px 10px;' onclick=initLifeInfo("+BusInfo[2]+","+BusInfo[0]+",'"+OneInfo[0]+"'"+","+BusInfo[1]+")>"+OneInfo[0]+"</a>"
			if (BusInfo[1]==0)	//����
			{
				imghtml1="<a><img src='../images/eq-line-1.png'></a>"
				imghtml2="<a><img src='../images/eq-line-1.png'></a>"
			}
			if (BusInfo[1]==1)	//�ύ
			{
				imghtml1="<a><img src='../images/eq-line-2.png'></a>"
				imghtml2="<a><img src='../images/eq-line-1.png'></a>"
			}
			if (BusInfo[1]==2)	//���
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
	tempobj.panel('setTitle',LatestBussName+"������ϸ");
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
	$("#ApproveInfoView").empty(); //ÿ�μ���֮ǰ�Ƴ���ʽ
	//��ʱ�䵹��,�����ֵ����
	for (var i=0;i<jsonData.rows.length;i++)
	{
		var statusFlag=0
		var ApproveDate=jsonData.rows[i].TApproveDate; //��������
		var ApproveTime=jsonData.rows[i].TApproveTime; //����ʱ��
		var ApproveUser=jsonData.rows[i].TApproveUser; //������
		var Opinion=jsonData.rows[i].TOpinion; //������
		var Year=jsonData.rows[i].TYear; 
		var ApproveRole=jsonData.rows[i].TApproveRole; //������ɫ
		var Action=jsonData.rows[i].TAction; //��������
		///Modified BY ZY0204  �����������в�������¼����
		var OperateType=jsonData.rows[i].TOperateType; //��������
		var keyInfo=ApproveUser+" "+Action+"�����������"+Opinion
		if (OperateType==1) keyInfo=ApproveUser+" "+Action+"���ܾ����ܾ�ԭ��"+Opinion
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
		else ApproveInfo=ApproveDate+"��"+keyInfo
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
		html=html+'<div>'+"���"+'</div>'+'</li>';
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
}