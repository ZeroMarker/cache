$(document).ready(function () {
    initDocument();
});

var MPType=$("#MPType").val();
var MaintType=$("#MaintType").val();
var EquipID=$("#EquipDR").val();

function initDocument()
{
	initBussLifeInfo()
}

function initBussLifeInfo()
{
	$.cm({
		ClassName:"web.DHCEQ.EM.BUSMaint",
		QueryName:"GetMaint",
		BussType:MPType,
		EquipDR:EquipID,
		MaintTypeDR:MaintType
	},function(jsonData){
		createLifeInfo(jsonData);
	});
}

function createLifeInfo(jsonData)
{
	var curYear=""
	$("#MaintHistoryListView").empty(); //ÿ�μ���֮ǰ�Ƴ���ʽ
	//��ʱ�䵹��,�����ֵ����
	for (var i=jsonData.rows.length-1;i>=0;i--)
	{
		var maintDate=jsonData.rows[i].TMaintDate; //ά������
		var maintTime=jsonData.rows[i].TMaintTime; //ά��ʱ��
		var maintType=jsonData.rows[i].TMaintType;	//ά������
		var sourceTypeDR="";
		if (MPType==1) {sourceTypeDR=32}
		//modify by lmm 2020-05-14
		else if((MPType==2)&&(MaintType==4)) {sourceTypeDR=33}
		else { sourceTypeDR="72-1";  
		}
		var sourceID=jsonData.rows[i].TRowID;
		var maintUser=jsonData.rows[i].TMaintUser;	//ά����
		var usedFee=jsonData.rows[i].TTotalFee;	//��ά������
		var year=""
		if(maintDate!="") year=maintDate.substring(0,4);
		//var keyInfo=maintDate+" "+maintTime+", "+maintUser+" "+maintType+", ���ã�"+usedFee��
		
		var section="";
		var flag="";
		if(i==0) flag=1;
		if (curYear!=year)
		{
			curYear=year;
			section="eq-lifeinfo-lock.png^"+year;
		}
		//modify by lmm 2020-05-14
		var url='href="#" onclick="javascript:lifeInfoDetail(&quot;'+sourceTypeDR+'&quot;,'+sourceID+')"';
		opt={
			id:'MaintHistoryListView',
			section:section,
			item:'^^'+maintDate+" "+maintTime+" "+maintUser+'%^'+url+'^'+maintType+':'+usedFee+'%^^',
			lastFlag:flag
		}
		
		createTimeLine(opt);
	}
	
}

///Creator: czf
///CreatDate: 2020-04-29
///Description: �������ڳ����ӵ��
///Input: sourceTypeDR ҵ�����  sourceID ҵ��id
function lifeInfoDetail(sourceType,sourceID)
{
	if (sourceType=="35")
	{
		messageShow('alert','info','��ʾ','�۾���ҵ�����ݣ�','','','')
		return;
	}
	var url="dhceqlifeinfo.csp?&SourceType="+sourceType+"&SourceID="+sourceID;
	//modify by lmm 2020-06-03
	if (sourceType=="31")
	{
		showWindow(url,"ҵ������","","","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-05 UI
	}
	else if(sourceType=="11")
	{
		showWindow(url,"ҵ������","","","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-05 UI
		
	}
	//add by lmm 2020-05-14
	else if(sourceType=="72-1")
	{
		showWindow(url,"������¼","","10row","icon-w-paper","modal","","","middle");   //modify by lmm 2020-06-17 UI
		
	}
	else if(sourceType=="32")
	{
		showWindow(url,"������¼","","10row","icon-w-paper","modal","","","middle");   //modify by lmm 2020-06-17 UI
		
	}
	else if(sourceType=="33")
	{
		showWindow(url,"����¼","","10row","icon-w-paper","modal","","","middle");   //modify by lmm 2020-06-17 UI
		
	}
	//add by lmm 2020-05-14
	else
	{
		showWindow(url,"ҵ������","","","icon-w-paper","modal","","","large"); 
	}
}