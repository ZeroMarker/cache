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
	$('#BClose').on("click", BClose_Clicked);
}

function BSave_Clicked()
{
	setLocationRowID(getElementValue("LocationOperMethod"));
	var LocationDR=getElementValue("LocationDR")
	var KeeperDR=getElementValue("KeeperDR")
	var AccountNo=getElementValue("AccountNo");	// Mozy0247	1190758	2020-02-17
	var RowIDs=getElementValue("RowIDs")
	if ((LocationDR=="")&&(KeeperDR=="")&&(AccountNo=="")) 
	{
		messageShow('popover','error','错误','传入无效信息！','','','')
		return;
	}
	var data=KeeperDR+"^"+LocationDR+"^"+AccountNo;	// Mozy0247	1190758	2020-02-17
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
//modify by wl 2019-12-16 WL0029 加入润乾打印方式 
//modify by wl 2020-03-02 WL0060 修改打印方式
function BPrintCard_Clicked()
{
	var RowIDs=getElementValue("RowIDs")
	if (RowIDs=="") return;
	var arrRowId=RowIDs.split(",");
	var len=arrRowId.length;
	if(printCardNum=="")
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
		var num=printCardNum-1;
		var PrintFlag=getElementValue("PrintFlag")
		if(PrintFlag=="0")
		{	
		PrintEQCard(arrRowId[num]);
		}
		if(PrintFlag=="1")
		{ 
		
		var fileName="DHCEQCardPrint.raq&RowId="+arrRowId[num] ;
		//Modefined by zc0060 20200327   增加润乾预览标志  begin
		var PreviewRptFlag=getElementValue("PreviewRptFlag"); 
		if(PreviewRptFlag==0)
		{
			DHCCPM_RQDirectPrint(fileName);
		}
		if(PreviewRptFlag==1)
		{
			DHCCPM_RQPrint(fileName);
		}
		//Modefined by zc0060 20200327   增加润乾预览标志  end
	  	$.messager.confirm("打印", "是否打印第"+printCardNum+"页反面？点击是正面会覆盖", function (r) {
	  			if(r)
	  			{ 
	  				printCardVerso(arrRowId[printCardNum-1],PreviewRptFlag);	//Modefined by zc0060 20200327   增加润乾预览标志  
	  			}
	  	});
		} 
}
//modify by wl 2019-03-02 WL0060 增加参数
//Modefined by zc0060 20200327   增加润乾预览标志PreviewRptFlag  
function printCardVerso(id,PreviewRptFlag)
{ 
	var fileName="DHCEQCardVersoPrint.raq&RowID="+id ;
	//Modefined by zc0060 20200327   增加润乾预览标志  begin
	if(PreviewRptFlag==0)
	{
		DHCCPM_RQDirectPrint(fileName);
	}
	if(PreviewRptFlag==1)
	{
		DHCCPM_RQPrint(fileName);
	}
	//Modefined by zc0060 20200327   增加润乾预览标志  end
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
	if(elementID=="LocationDR_LDesc") {setElement("LocationDR",rowData.TRowID);}
	else if(elementID=="KeeperDR_SSUSRName") {setElement("KeeperDR",rowData.TRowID);}
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