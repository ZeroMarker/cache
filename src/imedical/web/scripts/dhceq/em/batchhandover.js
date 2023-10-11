$(function(){
	initDocument();
});
function initDocument()
{
	initUserInfo();
	initMessage(""); 
	initLookUp();
	initButtonWidth();
	initEvent();
	setRequiredElements("HOToUserDR_UName"); 
}
function initEvent()
{
	$('#BSave').on("click", BSave_Clicked);
}

function BSave_Clicked()
{
	if(checkMustItemNull()){return;}
	var HOToUserDR=getElementValue("HOToUserDR");
	var RowIDs=getElementValue("RowIDs")
	var data=HOToUserDR+"^"+curLocID
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSHandOver","BatchHandOver",RowIDs,data,curUserID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE!=0)
	{
		messageShow('alert','error','提示',"保存失败!"+jsonData.Data)
	}
	else
	{
		messageShow('popover','success','提示','保存成功！','','','');
		websys_showModal("options").mth();
		closeWindow('modal');
	}
}
function setSelectValue(elementID,rowData)
{
	if(elementID=="HOToUserDR_UName") {setElement("HOToUserDR",rowData.TRowID)}
}
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	return;
}