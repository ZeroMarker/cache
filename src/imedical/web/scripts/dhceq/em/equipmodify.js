var printCardNum=""; //add by wl 2020-03-02 WL0060润乾卡片打印的次数
$(function(){
	initDocument();
});
function initDocument()
{
	initUserInfo();
	initLookUp();
	initButtonWidth();
	initEvent();
}
function initEvent()
{
	$('#BSave').on("click", BSave_Clicked);
	$('#BPrintBar').on("click", BPrintBar_Clicked);
	$('#BPrintCard').on("click", BPrintCard_Clicked);
	$('#BPrintCardVerso').on("click", BPrintCardVerso_Clicked);		// MZY0069	1736224,1736431		2021-02-18
	$('#BClose').on("click", BClose_Clicked);
	//Modify by zx 2020-08-18 BUG ZX0102
	if (getElementValue("QXType")!="0")		//只有台帐可修改凭证号  czf 1528642
	{
		hiddenObj("cAccountNo",true);
		hiddenObj("AccountNo",true);
	}
	if (getElementValue("QXType")=="2")
	{
		$("#PrintContainer").hide();
		setDisableElements("LocationDR_LDesc^AccountNo",true)
	}
}

function BSave_Clicked()
{
	setLocationRowID(getElementValue("LocationOperMethod"));
	var LocationDR=getElementValue("LocationDR")
	var KeeperDR=getElementValue("KeeperDR");
	var AccountNo=getElementValue("AccountNo");	// Mozy0247	1190758	2020-02-17
	var UserDR=getElementValue("UserDR");  //Modify by zx 2020-08-18 ZX0102
	var BrandDR=getElementValue("BrandDR");  //Add By QW20220421
	var ManageLocDR=getElementValue("ManageLocDR");  //Add By MYL20220816
	var CountryDR=getElementValue("CountryDR");  //Add by zc0125 2022-11-14 增加国别
	var PurposeTypeDR=getElementValue("PurposeTypeDR");  //dd by zc0125 2022-11-14 增加用途
	var BuyTypeDR=getElementValue("BuyTypeDR");  //Add by zc0125 2022-11-14 增加采购方式
	var RowIDs=getElementValue("RowIDs")
	if ((LocationDR=="")&&(KeeperDR=="")&&(AccountNo=="")&&(UserDR=="")&&(BrandDR=="")&&(ManageLocDR=="")&&(CountryDR=="")&&(PurposeTypeDR=="")&&(BuyTypeDR==""))  //Modified By zc0125 2022-11-14 增加国别、用途和采购方式的判断
	{
		messageShow('popover','error','错误','传入无效信息！','','','')
		return;
	}
	var data=KeeperDR+"^"+LocationDR+"^"+AccountNo+"^"+UserDR+"^"+BrandDR+"^"+ManageLocDR+"^"+CountryDR+"^"+PurposeTypeDR+"^"+BuyTypeDR;	//Modified By zc0125 2022-11-14 增加国别、用途和采购方式的更新
	var result=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","ModifyEquip",RowIDs,data,curUserID);
	if(result!=0)
	{
		messageShow('alert','error','提示',"保存失败!"+result)
	}
	else
	{
		messageShow('popover','success','提示','保存成功！','','','');
		websys_showModal("options").mth();
		closeWindow('modal');
	}
}

function BPrintBar_Clicked()
{
	var RowIDs=getElementValue("RowIDs")
	if (RowIDs=="") return;
	printBars(RowIDs,"");
}
// MZY0069	1736224,1736431		2021-02-18
//modify by wl 2019-12-16 WL0029 加入润乾打印方式 
//modify by wl 2020-03-02 WL0060 修改打印方式
function BPrintCard_Clicked()
{
	var RowIDs=getElementValue("RowIDs")
	if (RowIDs=="") return;
	var arrRowId=RowIDs.split(",");
	var len=arrRowId.length;
	var PrintFlag=getElementValue("PrintFlag")
	for (num=0;num<len;num++)
	{
	/*if(printCardNum=="")
	{ 
		printCardNum=1;
	}
	else
	{ 
		printCardNum=printCardNum+1;
	}
		if((printCardNum>len))
		{
			messageShow('popover','success','提示','打印完毕！','','','');
			return ;
		}
		var num=printCardNum-1;*/
		if(PrintFlag=="0")
		{	
			PrintEQCard(arrRowId[num]);
		}
		if(PrintFlag=="1")
		{
			PrintEQCard(arrRowId[num],2);	//czf 2022-01-24 润乾连续打印卡片报错，改为Lodop打印
			/*
			// MZY0103	2284390		2021-12-06
			var PreviewRptFlag=getElementValue("PreviewRptFlag"); 
			if(PreviewRptFlag==0)
			{
				var fileName="{DHCEQCardPrint.raq(RowId="+arrRowId[num]+")}";
				DHCCPM_RQDirectPrint(fileName);
			}
			if(PreviewRptFlag==1)
			{
				var fileName="DHCEQCardPrint.raq&RowId="+arrRowId[num];
				DHCCPM_RQPrint(fileName);
			}
			*/
		}
	}
	messageShow('popover','success','提示','打印完毕！','','','');
}
// MZY0069	1736224,1736431		2021-02-18
function BPrintCardVerso_Clicked()
{
	var RowIDs=getElementValue("RowIDs")
	if (RowIDs=="") return;
	var PreviewRptFlag=getElementValue("PreviewRptFlag");
	var arrRowId=RowIDs.split(",");
	var len=arrRowId.length;
	for (i=0;i<len;i++)
	{
		//printCardVerso(arrRowId[i], PreviewRptFlag);
		printCardVersoLodop(arrRowId[i]);	//czf 2022-01-26 lodop打印反面
	}
	messageShow('popover','success','提示','打印完毕！','','','');
}
//modify by wl 2019-03-02 WL0060 增加参数
//Modefined by zc0060 20200327   增加润乾预览标志PreviewRptFlag  
function printCardVerso(id,PreviewRptFlag)
{
	// MZY0103	2284390		2021-12-06
	if(PreviewRptFlag==0)
	{
		var fileName="{DHCEQCardVersoPrint.raq(RowID="+id+")}";
		DHCCPM_RQDirectPrint(fileName);
	}
	if(PreviewRptFlag==1)
	{
		var fileName="DHCEQCardVersoPrint.raq&RowID="+id;
		DHCCPM_RQPrint(fileName);
	}
} 
function setLocationRowID(type)
{
	if((type=="0")||(type==""))
	{
		setElement("LocationDR","");
	}
	else
	{
		var locationDesc=getElementValue("LocationDR_LDesc");
		if (locationDesc=="") return;
		var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTLocaton","UpdLocation",locationDesc);
		jsonData=JSON.parse(jsonData);
		if (jsonData.SQLCODE==0) setElement("LocationDR",jsonData.Data);
	}
}

function setSelectValue(elementID,rowData)
{
	setDefaultElementValue(elementID,rowData)   ///Add by zc0125 2022-11-14 放大镜元素选中赋值
	if(elementID=="LocationDR_LDesc") {setElement("LocationDR",rowData.TRowID);}
	else if(elementID=="KeeperDR_SSUSRName") {setElement("KeeperDR",rowData.TRowID);}
	else if(elementID=="UserDR_SSUSRName") {setElement("UserDR",rowData.TRowID);}  //Modify by zx 2020-08-18 ZX0102
	else if(elementID=="BrandDR_BDesc") {setElement("BrandDR",rowData.TRowID);} //Add By QW20220421
	else if(elementID=="ManageLocDR_MDesc") {setElement("ManageLocDR",rowData.TRowID);} //Add By MYL20220816
}
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	return;
}

function BClose_Clicked()
{
	websys_showModal("options").mth();
	closeWindow('modal');
}
