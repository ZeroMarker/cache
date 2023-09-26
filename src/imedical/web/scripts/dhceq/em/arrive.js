$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	initEvent();
    setEnabled();
}

function initEvent()
{
	var obj=document.getElementById("BArrive");
	if (obj)
	{
		jQuery("#BArrive").linkbutton({iconCls: 'icon-w-ok'});
		jQuery("#BArrive").on("click", arriveConfirmClickHandler);
	}
}
function arriveConfirmClickHandler() 
{
	//modified by ZY0198 字符判断问题
	var CanArriveNum=parseFloat(getElementValue("CanArriveNum"))
	var ArriveNum=parseFloat(getElementValue("ArriveNum"))
	if ((ArriveNum<1)||(ArriveNum>CanArriveNum))
	{
		//alertShow("本次到货数量无效!");
		messageShow('alert','info','提示',"本次到货数量无效!");
		return;
	}
	var combindata=getElementValue("ProviderDR")
	var valuelist=getElementValue("SourceType")+"^"+getElementValue("SourceID")+"^"+ArriveNum;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSArrive","SaveArriveRecord",combindata,valuelist);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		//alertShow("通知验收成功!");
		messageShow('alert','success','提示',"通知验收成功!");
		var url="dhceq.em.arrive.csp?&SourceType="+getElementValue("SourceType")+"&SourceID="+getElementValue("SourceID")
	    window.location.href= url;
	}
	else
    {
	    messageShow('alert','error','提示',"通知验收失败!");
   		//alertShow("通知验收失败!")
    }
}

function setEnabled()
{
	var CanArriveNum=getElementValue("CanArriveNum")
	if (CanArriveNum<1)
	{
		disableElement("ArriveNum",true);
		disableElement("BArrive",true);
	}
}
