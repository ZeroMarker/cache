$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	defindTitleStyle();
	loadBusinessListData();
}

function loadBusinessListData()
{
	var bussType=getElementValue("BussType");
	var BussID=getElementValue("BussID");
	if (BussID=="") return;
	var methodName="GetBusinessMain";
	if (bussType=="21") methodName="GetOneInStockList";
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBBusinessModify",methodName,BussID);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;};
	setElementByJson(jsonData.Data);
}

/// add by zx 2019-08-30
/// 保存按钮回调事件
function setValueByEdit(id,value)
{
	//alertShow(value)
	//setElement("id",value);
	location.reload();
}