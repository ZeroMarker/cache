var curYear=""; //记录生命周期生成时年限节点
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
///Description: 生命周期数据解析加载
///Input: 生命周期数据集
function createLifeInfo(jsonData)
{
	$("#LifeInfoDetail").empty(); //每次加载之前移除样式
	//按时间倒序,从最大值遍历
	for (var i=jsonData.rows.length-1;i>=0;i--)
	{
		var changeDate=jsonData.rows[i].TChangeDate; //变动日期
		var appendType=jsonData.rows[i].TAppendType;	//变动类型
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
///Description: 生命周期超链接点击
///Input: sourceTypeDR 业务代码  sourceID 业务id
function lifeInfoClick(sourceType,sourceID)
{
	if (sourceType=="35")
	{
		messageShow('alert','info','提示','折旧无业务数据！','','','')
		return;
	}
	var url="dhceqlifeinfo.csp?&SourceType="+sourceType+"&SourceID="+sourceID;
	//modify by lmm 2020-06-05
	if (sourceType=="31")
	{
		showWindow(url,"业务详情","","","icon-w-paper","modal","","","large");
	}
	else if(sourceType=="11")
	{
		showWindow(url,"业务详情","","","icon-w-paper","modal","","","large");
	}
	else if((sourceType=="32")||(sourceType=="33"))
	{
		showWindow(url,"业务详情","","9row","icon-w-paper","modal","","","middle");  
		
	}
	else
	{
		showWindow(url,"业务详情","","","icon-w-paper","modal","","","large"); 
	}
}