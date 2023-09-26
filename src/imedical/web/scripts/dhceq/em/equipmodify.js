var printCardNum=""; //add by wl 2020-03-02 WL0060��Ǭ��Ƭ��ӡ�Ĵ���
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
		messageShow('popover','error','����','������Ч��Ϣ��','','','')
		return;
	}
	var data=KeeperDR+"^"+LocationDR+"^"+AccountNo;	// Mozy0247	1190758	2020-02-17
	var result=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","ModifyEquip",RowIDs,data,curUserID);
	if(result!=0)
	{
		messageShow('alert','error','��ʾ',"����ʧ��!"+result)
	}
	else
	{
		messageShow('popover','success','��ʾ','����ɹ���','','','');
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
//modify by wl 2019-12-16 WL0029 ������Ǭ��ӡ��ʽ 
//modify by wl 2020-03-02 WL0060 �޸Ĵ�ӡ��ʽ
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
			messageShow('popover','success','��ʾ','��ӡ��ϣ�','','','');
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
		//Modefined by zc0060 20200327   ������ǬԤ����־  begin
		var PreviewRptFlag=getElementValue("PreviewRptFlag"); 
		if(PreviewRptFlag==0)
		{
			DHCCPM_RQDirectPrint(fileName);
		}
		if(PreviewRptFlag==1)
		{
			DHCCPM_RQPrint(fileName);
		}
		//Modefined by zc0060 20200327   ������ǬԤ����־  end
	  	$.messager.confirm("��ӡ", "�Ƿ��ӡ��"+printCardNum+"ҳ���棿���������Ḳ��", function (r) {
	  			if(r)
	  			{ 
	  				printCardVerso(arrRowId[printCardNum-1],PreviewRptFlag);	//Modefined by zc0060 20200327   ������ǬԤ����־  
	  			}
	  	});
		} 
}
//modify by wl 2019-03-02 WL0060 ���Ӳ���
//Modefined by zc0060 20200327   ������ǬԤ����־PreviewRptFlag  
function printCardVerso(id,PreviewRptFlag)
{ 
	var fileName="DHCEQCardVersoPrint.raq&RowID="+id ;
	//Modefined by zc0060 20200327   ������ǬԤ����־  begin
	if(PreviewRptFlag==0)
	{
		DHCCPM_RQDirectPrint(fileName);
	}
	if(PreviewRptFlag==1)
	{
		DHCCPM_RQPrint(fileName);
	}
	//Modefined by zc0060 20200327   ������ǬԤ����־  end
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