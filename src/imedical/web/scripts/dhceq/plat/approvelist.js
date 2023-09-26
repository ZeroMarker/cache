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
		var keyInfo=ApproveUser+" "+Action+"�����������"+Opinion
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
}