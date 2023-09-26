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
	$("#MaintHistoryListView").empty(); //每次加载之前移除样式
	//按时间倒序,从最大值遍历
	for (var i=jsonData.rows.length-1;i>=0;i--)
	{
		var maintDate=jsonData.rows[i].TMaintDate; //维护日期
		var maintTime=jsonData.rows[i].TMaintTime; //维护时间
		var maintType=jsonData.rows[i].TMaintType;	//维护类型
		var sourceTypeDR="";
		if (MPType==1) {sourceTypeDR=32}
		//modify by lmm 2020-05-14
		else if((MPType==2)&&(MaintType==4)) {sourceTypeDR=33}
		else { sourceTypeDR="72-1";  
		}
		var sourceID=jsonData.rows[i].TRowID;
		var maintUser=jsonData.rows[i].TMaintUser;	//维护人
		var usedFee=jsonData.rows[i].TTotalFee;	//总维护费用
		var year=""
		if(maintDate!="") year=maintDate.substring(0,4);
		//var keyInfo=maintDate+" "+maintTime+", "+maintUser+" "+maintType+", 费用："+usedFee；
		
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
///Description: 生命周期超链接点击
///Input: sourceTypeDR 业务代码  sourceID 业务id
function lifeInfoDetail(sourceType,sourceID)
{
	if (sourceType=="35")
	{
		messageShow('alert','info','提示','折旧无业务数据！','','','')
		return;
	}
	var url="dhceqlifeinfo.csp?&SourceType="+sourceType+"&SourceID="+sourceID;
	//modify by lmm 2020-06-03
	if (sourceType=="31")
	{
		showWindow(url,"业务详情","","","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-05 UI
	}
	else if(sourceType=="11")
	{
		showWindow(url,"业务详情","","","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-05 UI
		
	}
	//add by lmm 2020-05-14
	else if(sourceType=="72-1")
	{
		showWindow(url,"计量记录","","10row","icon-w-paper","modal","","","middle");   //modify by lmm 2020-06-17 UI
		
	}
	else if(sourceType=="32")
	{
		showWindow(url,"保养记录","","10row","icon-w-paper","modal","","","middle");   //modify by lmm 2020-06-17 UI
		
	}
	else if(sourceType=="33")
	{
		showWindow(url,"检查记录","","10row","icon-w-paper","modal","","","middle");   //modify by lmm 2020-06-17 UI
		
	}
	//add by lmm 2020-05-14
	else
	{
		showWindow(url,"业务详情","","","icon-w-paper","modal","","","large"); 
	}
}