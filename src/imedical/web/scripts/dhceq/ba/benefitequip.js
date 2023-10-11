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
	//initChartsDefine("LocEquipNums^ItemBenefitInfo^LocBenefitInfo^EquipOutFeeInfo",ChartsParams);	//��ʼ��ͼ����÷��������ݱ�������ʱglobal�� //1733788 modified by czf 2021-01-20
	/*
	//����ͷ����ť
	if(getElementValue("ToolBarFlag")!=1){$("#EquipShow").layout('remove','north');}
	initCardInfo();  //add by zx 2019-06-24  ���������� 939539
	//������������
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
///Description: ��ȡ̨����Ϣ������
function fillData()
{
	var RowID=getElementValue("RowID");
	if (RowID=="") return;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",RowID);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow('alert','error','��ʾ',jsonData.Data,'','','');return;}
	//jsonData.Data=GetJSONDataBySys(jsonData.Data);  //Add by JYP 2019-08-26
	setElementByJson(jsonData.Data); // hisuiͨ�÷���ֻ�ܸ�inputԪ�ظ�ֵ,�˷�������д
	showFieldsTip(jsonData.Data); // ��ϸ�ֶ���ʾ����ToolTip
	showFundsTip(jsonData.Data);  // �ʽ���Դ��Ϣtooltip
	//add by csj 20190215 �豸״̬�����ڿ�Ĳ������˻�
	if(getElementValue("EQStatus")!=0){
		disableElement("returnBtn",true)
	}
	$("#Banner").attr("src",'dhceq.plat.banner.csp?&EquipDR='+RowID); //add by zx 2019-02-15 ��ֹbanner������ݼ���
	//add by csj 2020-03-30 �����ڼ����豸���ü�����ť
	var Data=tkMakeServerCall("web.DHCEQ.EM.BUSEquipAttribute","CheckEquipHaveAttributeGroup","01",3, RowID);
	if(Data!="Y"){
		disableElement("BMeterage",true)
	}
}

///Creator: zx
///CreatDate: 2018-08-23
///Description: Ԫ�ظ�ֵ
///Input: vJsonInfo ��̨��ȡ��json����
///Other: ƽ̨ͳһ�����˴�������
function setElementByJson(vJsonInfo)
{
	for (var key in vJsonInfo)
	{
		var str=getShortString(vJsonInfo[key]);
		//add by zx 2019-06-17
		if (key=="EQAdvanceDisFlag") str=(vJsonInfo["EQHold1"]=="")?getShortString(vJsonInfo["EQAdvanceDisFlagDesc"]):getShortString(vJsonInfo["EQAdvanceDisFlagDesc"]+"("+vJsonInfo["EQHold1"]+")");  //add by zx 2019-07-05 ȥ������
		$("#"+key).text(str);
		if((key=="EQComputerFlag")||(key=="EQCommonageFlag")||(key=="EQRaditionFlag"))
		{
			if (vJsonInfo[key]=="1") $("#"+key).text("��");
			else $("#"+key).text("��");
		}
		if((key=="EQGuaranteePeriodNum")&&(vJsonInfo["EQGuaranteePeriodNum"]!="")) $("#"+key).text(vJsonInfo[key]+"��");
		if(vJsonInfo["EQAddDepreMonths"]!="")
		{
			var AddDepreMonths=parseInt(vJsonInfo["EQAddDepreMonths"]);
			if(AddDepreMonths>0) $("#EQLimitYearsNum").text(vJsonInfo["EQLimitYearsNum"]+" (��"+AddDepreMonths+"��)");
			else $("#EQLimitYearsNum").text(vJsonInfo["EQLimitYearsNum"]+" (��"+AddDepreMonths+"��)");
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
		//if(vJsonInfo["EQHold1"]!="") $("#EQAdvanceDisFlagDesc").text(vJsonInfo["EQAdvanceDisFlagDesc"]+" ��"+vJsonInfo["EQHold1"]+"��");
	}
	setElement("EQStatus",vJsonInfo.EQStatus)
	setElement("EQStatusDisplay",vJsonInfo.EQStatusDisplay)
	setElement("EQParentDR",vJsonInfo.EQParentDR);		//Mozy	914928	2019-7-11
}