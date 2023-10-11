var EquipDR=getElementValue("EquipDR")
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	var obj=document.getElementById("Banner");
	if (obj){$("#Banner").attr("src",'dhceq.plat.banner.csp?&EquipDR='+EquipDR)}
	
	initUserInfo();
	var ChartsParams=getElementValue("Job")+","+getElementValue("StartDate")+","+getElementValue("EndDate")+","+curSSUserID+","+curSSLocID+","+curSSGroupID;
	initEchartsObjMap();
	//initChartsDefine("LocEquipNums^ItemBenefitInfo^LocBenefitInfo^EquipOutFeeInfo",ChartsParams);	//初始化图表调用方法将数据保存至临时global中 //1733788 modified by czf 2021-01-20
	/*
	//隐藏头部按钮
	if(getElementValue("ToolBarFlag")!=1){$("#EquipShow").layout('remove','north');}
	initCardInfo();  //add by zx 2019-06-24  测试组需求 939539
	//隐藏生命周期
	if(getElementValue("LifeInfoFlag")!=1){$('#EquipInfo').layout('remove','east');}
	else {
		lifeInfoKeywords();
		initLifeInfo("");
	}
	
	fillData();
	initImage();
	*/
}

function initEchartsObjMap()
{
	EchartsObjMap["LocEquipNums"]="EquipLocDistribute";
	//EchartsObjMap["StatCatEquipAmount"]="EquipStatCatDistribute";		//1733788 modified by czf 2021-01-20
	EchartsObjMap["ItemBenefitInfo"]="HospEquipAnaly";		//
	EchartsObjMap["LocBenefitInfo"]="LocBenefitView";		//
	EchartsObjMap["EquipOutFeeInfo"]="EquipOutFeeAnaly";		//
}

///Creator: zx
///CreatDate: 2018-08-23
///Description: 获取台帐信息并加载
function fillData()
{
	var RowID=getElementValue("RowID");
	if (RowID=="") return;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",RowID);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow('alert','error','提示',jsonData.Data,'','','');return;}
	//jsonData.Data=GetJSONDataBySys(jsonData.Data);  //Add by JYP 2019-08-26
	setElementByJson(jsonData.Data); // hisui通用方法只能给input元素赋值,此方法被重写
	showFieldsTip(jsonData.Data); // 详细字段提示工具ToolTip
	showFundsTip(jsonData.Data);  // 资金来源信息tooltip
	//add by csj 20190215 设备状态不是在库的不允许退货
	if(getElementValue("EQStatus")!=0){
		disableElement("returnBtn",true)
	}
	$("#Banner").attr("src",'dhceq.plat.banner.csp?&EquipDR='+RowID); //add by zx 2019-02-15 防止banner多次数据加载
	//add by csj 2020-03-30 不属于计量设备禁用计量按钮
	var Data=tkMakeServerCall("web.DHCEQ.EM.BUSEquipAttribute","CheckEquipHaveAttributeGroup","01",3, RowID);
	if(Data!="Y"){
		disableElement("BMeterage",true)
	}
}

///Creator: zx
///CreatDate: 2018-08-23
///Description: 元素赋值
///Input: vJsonInfo 后台获取的json数据
///Other: 平台统一方法此处不适用
function setElementByJson(vJsonInfo)
{
	for (var key in vJsonInfo)
	{
		var str=getShortString(vJsonInfo[key]);
		//add by zx 2019-06-17
		if (key=="EQAdvanceDisFlag") str=(vJsonInfo["EQHold1"]=="")?getShortString(vJsonInfo["EQAdvanceDisFlagDesc"]):getShortString(vJsonInfo["EQAdvanceDisFlagDesc"]+"("+vJsonInfo["EQHold1"]+")");  //add by zx 2019-07-05 去掉括号
		$("#"+key).text(str);
		if((key=="EQComputerFlag")||(key=="EQCommonageFlag")||(key=="EQRaditionFlag"))
		{
			if (vJsonInfo[key]=="1") $("#"+key).text("是");
			else $("#"+key).text("否");
		}
		if((key=="EQGuaranteePeriodNum")&&(vJsonInfo["EQGuaranteePeriodNum"]!="")) $("#"+key).text(vJsonInfo[key]+"月");
		if(vJsonInfo["EQAddDepreMonths"]!="")
		{
			var AddDepreMonths=parseInt(vJsonInfo["EQAddDepreMonths"]);
			if(AddDepreMonths>0) $("#EQLimitYearsNum").text(vJsonInfo["EQLimitYearsNum"]+" (增"+AddDepreMonths+"月)");
			else $("#EQLimitYearsNum").text(vJsonInfo["EQLimitYearsNum"]+" (减"+AddDepreMonths+"月)");
		}
		if (vJsonInfo["EQEquipTypeDR"]==getElementValue("BuildingType"))
		{
			$("#EQEquipTypeDR_ETDesc").html('<a href="#" style="margin:0;font-weight:800;" onclick="javascript:equipBuilding()">'+vJsonInfo["EQEquipTypeDR_ETDesc"]+'</a>')
		}
		else if (vJsonInfo["EQEquipTypeDR"]==getElementValue("VehicleType"))
		{
			$("#EQEquipTypeDR_ETDesc").html('<a href="#" style="margin:0;font-weight:800;" onclick="javascript:equipVehicle()">'+vJsonInfo["EQEquipTypeDR_ETDesc"]+'</a>')
		}
		else
		{
			$("#EQEquipTypeDR_ETDesc").text(vJsonInfo["EQEquipTypeDR_ETDesc"])
		}
		//alertShow(vJsonInfo["EQHold1"])
		//if(vJsonInfo["EQHold1"]!="") $("#EQAdvanceDisFlagDesc").text(vJsonInfo["EQAdvanceDisFlagDesc"]+" （"+vJsonInfo["EQHold1"]+"）");
	}
	setElement("EQStatus",vJsonInfo.EQStatus)
	setElement("EQStatusDisplay",vJsonInfo.EQStatusDisplay)
	setElement("EQParentDR",vJsonInfo.EQParentDR);		//Mozy	914928	2019-7-11
}