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
	//����jsonData.rows[i].TRequestDate
	//����jsonData.rows[i].TRequestNo TStartDate TStartTime TReturnDate TReturnTime
	//����jsonData.rows[i].TRequestLoc+jsonData.rows[i].TLocReturn+"���"+�豸����jsonData.rows[i].TEquip+����ʱ��jsonData.rows[i].TWorkLoad+jsonData.rows[i].TWorkLoadUOM
	var curYearMonth=""
	$("#RentHistoryInfoView").empty(); //ÿ�μ���֮ǰ�Ƴ���ʽ
	//��ʱ�䵹��,�����ֵ����
	for (var i=0;i<jsonData.rows.length;i++)
	{
		var statusFlag=0
		var TRequestStartDateTime="��ʼʱ�䣺"+jsonData.rows[i].TStartDate+" "+jsonData.rows[i].TStartTime
		var TRequestReturnDateTime="������ʱ�䣺"+jsonData.rows[i].TReturnDate+" "+jsonData.rows[i].TReturnTime	

		var TRequestDate=TRequestStartDateTime+TRequestReturnDateTime	//jsonData.rows[i].TRequestDate //����
		//modify by lmm 2020-06-05 UI
		//Modify by zx 2020-06-09 BUG ZX0100
		var TRequestNo="���޵��ţ�<a href=# onclick=showWindow('dhceq.rm.rent.csp?&RowID="+jsonData.rows[i].TRowID+"&ReadOnly=1','������ϸ','','','icon-w-paper','modal','','','middle','')>"+jsonData.rows[i].TRequestNo+"</a>"	//����
		var TRequestInfo=jsonData.rows[i].TRequestLoc+jsonData.rows[i].TLocReturn+"���"+jsonData.rows[i].TWorkLoad+jsonData.rows[i].TWorkLoadUOM //+TRequestStartDateTime+TRequestReturnDateTime
//		var ApproveDate=jsonData.rows[i].TApproveDate; //��������
//		var ApproveTime=jsonData.rows[i].TApproveTime; //����ʱ��
//		var ApproveUser=jsonData.rows[i].TApproveUser; //������
//		var Opinion=jsonData.rows[i].TOpinion; //������
		var YearMonth=jsonData.rows[i].TRequestDate.split("-")[0]+'-'+jsonData.rows[i].TRequestDate.split("-")[1]; 
//		var ApproveRole=jsonData.rows[i].TApproveRole; //������ɫ
//		var Action=jsonData.rows[i].TAction; //��������
//		var keyInfo=ApproveUser+" "+Action+"�����������"+Opinion
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
//		else ApproveInfo=ApproveDate+"��"+keyInfo
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
			item:'^^��û��������ʷ',
			lastFlag:1,
			onOrOff:1
		}
		
		createTimeLine(opt);
	}
}