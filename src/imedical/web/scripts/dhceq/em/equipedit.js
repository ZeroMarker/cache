$(function(){
	initDocument();
});
function initDocument()
{
	//initUserInfo();
	fillData();
	initLookUp();
	defindTitleStyle();
	initButton();
	initButtonWidth();  //add by zx 2019-07-04
	setRequiredElements("EQName"); //������
	$("#BDepreAllot").on("click", BDepreAllot_Clicked);  //add by zx 2019-07-04
	muilt_Tab()  //add by lmm 2020-06-29 �س���һ�����
	// MZY0032	2020-06-09	�ض��������
	singlelookup("EQEquiCatDR_ECDesc","EM.L.EquipCat",[{name:"Desc",type:1,value:"EQEquiCatDR_ECDesc"},{name:"EquipTypeDR",type:4,value:"EQEquipTypeDR"},{name:"StatCatDR",type:4,value:"EQStatCatDR"},{"name":"EditFlag","type":"2","value":"1"}])
};
///Creator: zx
///CreatDate: 2018-08-23
///Description: ��ȡ̨����Ϣ������
function fillData()
{
	var RowID=getElementValue("EQRowID");
	if (RowID=="") return;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",RowID);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {$.messager.alert(jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	if (!getElementValue("EQCommonageFlag")) disableElement("BDepreAllot",true);
}

///Creator: zx
///CreatDate: 2018-08-23
///Description: LookUpѡ���к�ֵ��DRԪ��
///Input: vElementID LookUpԪ��ID  rowData ѡ��������
function setSelectValue(elementID,rowData)
{
	if(elementID=="EQCountryDR_CTCOUDesc") {setElement("EQCountryDR",rowData.TRowID)}
	else if(elementID=="EQModelDR_MDesc") {setElement("EQModelDR",rowData.TRowID)}
	else if(elementID=="EQUnitDR_UOMDesc") {setElement("EQUnitDR",rowData.TRowID)}
	else if(elementID=="EQHold10_EDesc") {setElement("EQHold10",rowData.TRowID)}
	else if(elementID=="EQManuFactoryDR_MFName") {setElement("EQManuFactoryDR",rowData.TRowID)}
	else if(elementID=="EQPurposeTypeDR_PTDesc") {setElement("EQPurposeTypeDR",rowData.TRowID)}
	else if(elementID=="EQOriginDR_ODesc") {setElement("EQOriginDR",rowData.TRowID)}
	else if(elementID=="EQEquiCatDR_ECDesc") {setElement("EQEquiCatDR",rowData.TRowID)}
	else if(elementID=="EQBuyTypeDR_BTDesc") {setElement("EQBuyTypeDR",rowData.TRowID)}
	else if(elementID=="EQPurchaseTypeDR_PTDesc") {setElement("EQPurchaseTypeDR",rowData.TRowID)}
	else if(elementID=="EQProviderDR_VName") {setElement("EQProviderDR",rowData.TRowID)}
	else if(elementID=="EQLocationDR_LDesc") {setElement("EQLocationDR",rowData.TRowID)}
	else if(elementID=="EQKeeperDR_SSUSRName") {setElement("EQKeeperDR",rowData.TRowID)}
	else if(elementID=="EQDepreMethodDR_DMDesc") {setElement("EQDepreMethodDR",rowData.TRowID)}
}

function clearData(elementID)
{
	var elementName=elementID.split("_")[0]
	setElement(elementName,"")
	return;
}

///Creator: zx
///CreatDate: 2018-09-07
///Description: ���ݱ��淽��
function BSave_Clicked()
{
	if(!validateNamber(getElementValue("EQLimitYearsNum")))
	{
		messageShow('alert','error','��ʾ','ʹ�����������쳣��������.','','','');
		return;
	}
	if (getElementValue("EQName")=="")
	{
		messageShow("alert","error","��ʾ","ͨ��������Ϊ��!");
		return
	}
	
	setModelRowID(getElementValue("ModelOperMethod"));
	setProviderRowID(getElementValue("ProviderOperMethod"));
	setManuFactoryRowID(getElementValue("ManuFactoryOperMethod"));
	setLocationRowID(getElementValue("LocationOperMethod"));
	
	var data=getInputList();
	// �����������ṹ���ò�һ��,���⴦��	Mozy	2019-10-18
	if ($("#EQHold5").is(':checked')) data.EQHold5="Y";
	else data.EQHold5="N";
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","SaveData",data);
	jsonData=JSON.parse(jsonData);	//Mozy	2019-10-18
	if (jsonData.SQLCODE<0) {messageShow('alert','error','��ʾ',jsonData.Data);return;}
	//var RowID=getElementValue("EQRowID");
	//var url="dhceq.em.equipedit.csp?RowID="+RowID;
	//window.location.href=url;
	window.location.reload();
}

function setModelRowID(type)
{
	if((type=="0")||(type==""))
	{
		setElement("EQModelDR","");
	}
	else
	{
		var modelDesc=getElementValue("EQModelDR_MDesc");
		if (modelDesc=="") return;
		var data=modelDesc+"^"+getElementValue("EQOriginalFee");
		var item=getElementValue("EQItemDR");
		var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTModel","UpdModel",data, item);
		jsonData=JSON.parse(jsonData);
		if (jsonData.SQLCODE==0) setElement("EQModelDR",jsonData.Data);
	}
}

function setProviderRowID(type)
{
	if((type=="0")||(type==""))
	{
		setElement("EQProviderDR","");
	}
	else
	{
		var providerName=getElementValue("EQProviderDR_VName");
		if (providerName=="") return;
		var data=providerName+"^"+getElementValue("EQProviderHandler")+"^"+getElementValue("EQProviderTel");
		var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTVendor","UpdProvider",data);
		jsonData=JSON.parse(jsonData);
		if (jsonData.SQLCODE==0) setElement("EQProviderDR",jsonData.Data);
	}
}

function setManuFactoryRowID(type)
{
	if((type=="0")||(type==""))
	{
		setElement("EQManuFactoryDR","");
	}
	else
	{
		var manuFactoryName=getElementValue("EQManuFactoryDR_MFName");
		if (manuFactoryName=="") return;
		var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTManufacturer","UpdManufacturer",manuFactoryName);
		jsonData=JSON.parse(jsonData);
		if (jsonData.SQLCODE==0) setElement("EQManuFactoryDR",jsonData.Data);
	}
}

function setLocationRowID(type)
{
	if((type=="0")||(type==""))
	{
		setElement("EQLocationDR","");
	}
	else
	{
		var locationDesc=getElementValue("EQLocationDR_LDesc");
		if (locationDesc=="") return;
		var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTLocaton","UpdLocation",locationDesc);
		jsonData=JSON.parse(jsonData);
		if (jsonData.SQLCODE==0) setElement("EQLocationDR",jsonData.Data);
	}
}

// add by zx 2019-07-04
// hisui��̯���ô���
function BDepreAllot_Clicked()
{
	var EquipDR=getElementValue("EQRowID");
	var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCostAllot&EquipDR='+EquipDR+'&Types=1';
	showWindow(url,"��̯����","","","icon-w-paper","","","","middle"); //modify by lmm 2020-06-05 UI
}
