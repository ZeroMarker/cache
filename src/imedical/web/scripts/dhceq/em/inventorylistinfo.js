// ../scripts/dhceq/em/inventorylistinfo.js
$(function(){
	initDocument();
});
function initDocument()
{
	initUserInfo();
	initLookUp();
	initButtonWidth();
	initEvent();
	setRequiredElements("ILILocationDR_LDesc"); //必填项
	fillData(); 				//数据填充
	if (getElementValue("ReadOnly")==1) DisableBElement("BSave",true);
}
function initEvent()
{
	singlelookup("ILIKeeperDR_SSUSRName","PLAT.L.EQUser",[{name:"Type",type:2,value:""},{name:"Name",type:1,value:"ILIKeeperDR_SSUSRName"},{name:"Loc",type:2,value:curLocName}])
	$('#BSave').on("click", BSave_Clicked);
	$('#BClose').on("click", BClose_Clicked);
}
function fillData()
{
	if (getElementValue("ILIInventoryListDR")=="") return;
	var gbldata=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetOneListInfo", getElementValue("ILIInventoryListDR"));
	//alert(gbldata)
	var list=gbldata.split("^");
	var sort=17;
	SetElement("ILIInventoryListDR",list[0]);
	SetElement("No",list[1]);
	SetElement("Name",list[2]);
	SetElement("ILIRowID",list[3]);
	SetElement("ILIKeeperDR",list[5]);
	SetElement("ILIKeeperDR_SSUSRName",list[sort+0]);
	SetElement("ILILocationDR",list[6]);
	SetElement("ILILocationDR_LDesc",list[sort+1]);
	SetElement("ILILeaveFactoryNo",list[7]);
}
function BSave_Clicked()
{
	if (getElementValue("ILILocationDR_LDesc")=="")
	{
		messageShow('alert','error','错误提示','存放地点不能为空!');
		return;
	}
	var data=getElementValue("ILIRowID")+"^"+getElementValue("ILIInventoryListDR")+"^"+getElementValue("ILIKeeperDR")+"^"+getElementValue("ILILocationDR")+"^"+getElementValue("ILILeaveFactoryNo")+"^^"+getElementValue("ILILocationDR_LDesc");
	var result=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","SaveListInfo", data);
	if (result>0)
	{
	    //window.location.reload()
	    var url='dhceq.em.inventorylistinfo.csp?&InventoryListDR='+getElementValue("ILIInventoryListDR");
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    messageShow("popover","","","操作成功!");
		setTimeout(function(){window.location.href=url},2000);		//延迟2秒
	}
	else
    {
		messageShow('alert','error','错误提示',result);
    }
}
function setSelectValue(elementID,rowData)
{
	if(elementID=="ILIKeeperDR_SSUSRName") {setElement("ILIKeeperDR",rowData.TRowID);}
	else if(elementID=="ILILocationDR_LDesc") {setElement("ILILocationDR",rowData.TRowID);}
}
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	return;
}

function BClose_Clicked()
{
	//websys_showModal("options").mth();
	closeWindow('modal');
}