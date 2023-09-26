var curYear=""; //��¼������������ʱ���޽ڵ�
$(document).ready(function () {
    initBussLifeInfo();
});

function initBussLifeInfo()
{
	$.cm({
		ClassName:"web.DHCEQ.EM.BUSLifeInfo",
		QueryName:"LifeInfo",
		EquipDR:getElementValue("EquipDR"),
		LocDR:"",
		EquipTypeDR:"",
		LifeTypeDR:"",
		StartDate:"",
		EndDate:"",
		SourceTypeDR:"",
		QXType:""
	},function(jsonData){
		createLifeInfo(jsonData);
	});
}

///Creator: zx
///CreatDate: 2018-08-24
///Description: �����������ݽ�������
///Input: �����������ݼ�
function createLifeInfo(jsonData)
{
	$("#LifeInfoDetail").empty(); //ÿ�μ���֮ǰ�Ƴ���ʽ
	//��ʱ�䵹��,�����ֵ����
	for (var i=jsonData.rows.length-1;i>=0;i--)
	{
		var changeDate=jsonData.rows[i].TChangeDate; //�䶯����
		var appendType=jsonData.rows[i].TAppendType;	//�䶯����
		var sourceTypeDR=jsonData.rows[i].TSourceTypeDR;
		var sourceID=jsonData.rows[i].TSourceID;
		var usedFee=jsonData.rows[i].TUsedFee;
		var year=jsonData.rows[i].TYear;
		var keyInfo=jsonData.rows[i].TKeyInfo;
		
		var section="";
		var flag="";
		if(i==0) flag=1;
		if (curYear!=year)
		{
			curYear=year;
			section="eq-lifeinfo-lock.png^"+year;
		}
		var url='href="#" onclick="javascript:lifeInfoClick('+sourceTypeDR+','+sourceID+')"';
		opt={
			id:'LifeInfoDetail',
			section:section,
			item:'^^'+changeDate+'%^'+url+'^'+appendType+':'+usedFee+'%^^'+keyInfo,
			lastFlag:flag
		}
		
		createTimeLine(opt);
	}
}
///Creator: zx
///CreatDate: 2018-08-24
///Description: �������ڳ����ӵ��
///Input: sourceTypeDR ҵ�����  sourceID ҵ��id
function lifeInfoClick(sourceType,sourceID)
{
	if (sourceType=="35")
	{
		messageShow('alert','info','��ʾ','�۾���ҵ�����ݣ�','','','')
		return;
	}
	var url="dhceqlifeinfo.csp?&SourceType="+sourceType+"&SourceID="+sourceID;
	//modify by lmm 2020-06-05
	if (sourceType=="31")
	{
		showWindow(url,"ҵ������","","","icon-w-paper","modal","","","large");
	}
	else if(sourceType=="11")
	{
		showWindow(url,"ҵ������","","","icon-w-paper","modal","","","large");
	}
	else if((sourceType=="32")||(sourceType=="33"))
	{
		showWindow(url,"ҵ������","","9row","icon-w-paper","modal","","","middle");  
		
	}
	else
	{
		showWindow(url,"ҵ������","","","icon-w-paper","modal","","","large"); 
	}
}