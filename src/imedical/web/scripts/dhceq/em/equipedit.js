$(function(){
	initDocument();
});
function initDocument()
{
	//initUserInfo();
	fillData();
	initLookUp();
    //modified by ZY 20221107 2978113
    var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"EQManageLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0101"},{"name":"notUseFlag","type":"2","value":""}];
    singlelookup("EQManageLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
	defindTitleStyle();
	initButton();
	initButtonWidth();  //add by zx 2019-07-04
	setRequiredElements("EQName"); //������
	$("#BDepreAllot").on("click", BDepreAllot_Clicked);  //add by zx 2019-07-04
	muilt_Tab()  //add by lmm 2020-06-29 �س���һ�����
	// MZY0032	2020-06-09	�ض��������
	singlelookup("EQEquiCatDR_ECDesc","EM.L.EquipCat",[{name:"Desc",type:1,value:"EQEquiCatDR_ECDesc"},{name:"EquipTypeDR",type:4,value:"EQEquipTypeDR"},{name:"StatCatDR",type:4,value:"EQStatCatDR"},{"name":"EditFlag","type":"2","value":"1"}])
	//Modify by zx 2020-08-20 BUG ZX0102
	if(getElementValue("ReadOnly")=="1") disableAllElements("EQKeeperDR_SSUSRName^EQUserDR_SSUSRName^EQLocationDR_LDesc");    //���Ӵ�ŵص��޸�
	//Modefied by ZY0307 2022-07-13 �����¾ɳ̶ȶ���
	initStatusData();
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
	if ((getElementValue("EQParentDR")=="")||(getElementValue("EQNo").indexOf("-")==-1))
	{
		disableElement("EQParentDR_EQNo",true);
	}
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
	else if(elementID=="EQUserDR_SSUSRName") {setElement("EQUserDR",rowData.TRowID)}  //Modify by zx 2020-08-18 ZX0102
	else if(elementID=="EQBrand_BDesc") {setElement("EQBrand",rowData.TRowID)}  //Modify by QW20220531  BUG:QW0162 ����Ʒ��
    //modified by ZY 2913588,2913589,2913590
    else if(elementID=="EQAuthorizeDeptDR_ADDesc") {setElement("EQAuthorizeDeptDR",rowData.TRowID)}
    else if(elementID=="EQUseSubjectDR_USDesc") {setElement("EQUseSubjectDR",rowData.TRowID)}
    else if(elementID=="EQBuyModeDR_BMDesc") {setElement("EQBuyModeDR",rowData.TRowID)}
    else if(elementID=="EQManageLocDR_CTLOCDesc") {setElement("EQManageLocDR",rowData.TRowID)}
    else if(elementID=="EQParentDR_EQNo") {
	    setElement("EQParentDR_EQNo",rowData.TNo)
	    setElement("EQParentDR",rowData.TRowID)
	}

}

//Modefied by ZY0307 2022-07-13 �����¾ɳ̶ȶ���
function initStatusData()
{
	var Status = $HUI.combobox('#EQNewOldPercent',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '0',
				text: 'ȫ��'
			},{
				id: '1',
				text: '�ų���'
			},{
				id: '2',
				text: '�˳���'
			},{
				id: '3',
				text: '�߳���'
			},{
				id: '4',
				text: '������'
			},{
				id: '5',
				text: '�����'
			},{
				id: '10',
				text: '���豸'
			}]
	});
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
	var LimitYearsNum=getElementValue("EQLimitYearsNum")
	if((LimitYearsNum!="")&&(!validateNamber(LimitYearsNum)))
	{
		messageShow('alert','error','��ʾ','ʹ�����������쳣��������.','','','');
		return;
	}
	if (getElementValue("EQName")=="")
	{
		messageShow("alert","error","��ʾ","ͨ��������Ϊ��!");
		return
	}
	if ((getElementValue("EQNo").indexOf("-")>-1)&&(getElementValue("EQParentDR")==""))
	{
		messageShow("alert","error","��ʾ","�����豸���豸����Ϊ��!");
		$("#EQParentDR_EQNo").focus();
		return
	}
	setModelRowID(getElementValue("ModelOperMethod"));
	setProviderRowID(getElementValue("ProviderOperMethod"));
	setManuFactoryRowID(getElementValue("ManuFactoryOperMethod"));
	setLocationRowID(getElementValue("LocationOperMethod"));
	
	var data=getInputList();
	//Modefied by zc0103 2021-06-02 ʹ�����ޱ���,��ҽ��ʶ���洢 begin
	/*
	// �����������ṹ���ò�һ��,���⴦��	Mozy	2019-10-18
	if ($("#EQHold5").is(':checked')) data.EQHold5="Y";
	else data.EQHold5="N";
	*/
	//Modefied by zc0103 2021-06-02 ʹ�����ޱ���,��ҽ��ʶ���洢 end
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
	///modified by ZY0297 2022-04-15
	//var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCostAllot&EquipDR='+EquipDR+'&Types=1&ReadOnly='+getElementValue("ReadOnly"); //Modified By QW20211112 BUG:QW0155
	var url='dhceq.em.costallot.csp?&CAHold2='+EquipDR+'&CATypes=1&ReadOnly='+getElementValue("ReadOnly");
	showWindow(url,"��̯����","","","icon-w-paper","","","","middle"); //modify by lmm 2020-06-05 UI
}
