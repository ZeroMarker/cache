$(function(){
	initDocument();
	setElement("ArriveNum",getElementValue("CanArriveNum"));	// MZY0053	1503081		2020-09-08
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	///modofiied by ZY0252  20210301
	setElement("ArriveLocDR_CTLOCDesc",getElementValue("ArriveLoc"))
	initLookUp(); 			//初始化放大镜	 MZY0058	2020-10-18
	initEvent();
    setEnabled();
}
// MZY0058	2020-10-18
function setSelectValue(elementID,rowData)
{
	if(elementID=="ArriveLocDR_CTLOCDesc") {setElement("ArriveLocDR",rowData.TRowID)}
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
	/// modified by ZY0260 20210428
	var ALHold1=getElementValue("ALHold1")
	var valuelist=getElementValue("SourceType")+"^"+getElementValue("SourceID")+"^"+ArriveNum+"^"+ALHold1+"^"+getElementValue("ArriveLocDR");
	disableElement("BArrive",true)
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSArrive","SaveArriveRecord",combindata,valuelist);	// MZY0058	2020-10-18
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		
        websys_showModal("options").mth();	/// modified end by ZY0260 20210428
		//alertShow("通知验收成功!");
		messageShow('alert','success','提示',"通知验收成功!","",confirmFun);	// MZY0053	1503082		2020-09-08	增加返回处理方法
		//var url="dhceq.em.arrive.csp?&SourceType="+getElementValue("SourceType")+"&SourceID="+getElementValue("SourceID")
	    //window.location.href=url;		// MZY0053	1503082		2020-09-08	注释
	}
	else
    {
             ///modofiied by ZY0252  20210301
	    disableElement("BArrive",false)
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
	///modofiied by ZY0252  20210301
	var ContractListLocID=getElementValue("ContractListLocID")
	if (ContractListLocID!="")
	{
		disableElement("ArriveLocDR_CTLOCDesc",true);
	}
}
// MZY0053	1503082		2020-09-08
function confirmFun()
{
	websys_showModal("close");
}