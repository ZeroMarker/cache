/**
 * add by zx 2021-09-04
 * 盘点单筛选条件处理
 */
$(function(){
	initDocument();
});
function initDocument()
{
	initButtonWidth();
	initEvent();
	initLookUp(); 
	fillData();
}
function initEvent()
{
	$('#BOk').on("click", BOk_Clicked);
	$('#BCancel').on("click", BCancel_Clicked);
}
function fillData()
{
	var InventoryDR=getElementValue("InventoryDR");
	var FilterInfo=getElementValue("FilterInfo");
	if (InventoryDR!="")
	{
		var result=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetInventoryFilterInfo",InventoryDR);
		setData(result)
	}
	if (FilterInfo!="")
	{
		setData(FilterInfo)
	}
}
function setData(value)
{
	var list=value.split("|");
	for (var i=1;i<=list.length;i++)
	{
		var listinfo=list[i-1].split(":")
		if (listinfo[0]=="0")
		{
			if (listinfo[1]>0)
			{
				disableElement("BOK",1);
			}
		}
		else
		{
			setElement(listinfo[0],listinfo[1]);
		}
	}
	//Add By QW20210524 BUG:QW0113 测试需求 1938765 存放地点文本框不显示条件内容 Begin
	var LocationDR=getElementValue("LocationDR")
	var Location=tkMakeServerCall("web.DHCEQCommon","GetTrakNameByID","location",LocationDR);
	if (Location!="") setElement("Location",Location);
	//Add By QW20210524 BUG:QW0113 End
}
function BOk_Clicked()
{
	var filterInfo=""
	filterInfo=filterInfo+"EquipName:"+getElementValue("EquipName");
	filterInfo=filterInfo+"|OriginalFeeStart:"+getElementValue("OriginalFeeStart");
	filterInfo=filterInfo+"|OriginalFeeEnd:"+getElementValue("OriginalFeeEnd");
	filterInfo=filterInfo+"|StartDate:"+getElementValue("StartDate");
	filterInfo=filterInfo+"|EndDate:"+getElementValue("EndDate");
	filterInfo=filterInfo+"|LocationDR:"+getElementValue("LocationDR");
	websys_showModal("options").mth(filterInfo);
	closeWindow('modal');
}
function BCancel_Clicked()
{
	closeWindow('modal');
}

function clearData(elementID)
{
	var elementName=elementID+"DR";
	setElement(elementName,"");
	return;
}

function setSelectValue(elementID,rowData)
{
	var elementID=elementID+"DR";
	setElement(elementID,rowData.TRowID)
}