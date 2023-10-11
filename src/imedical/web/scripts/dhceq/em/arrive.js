$(function(){
	initDocument();
	setElement("ArriveNum",getElementValue("CanArriveNum"));	// MZY0053	1503081		2020-09-08
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	///modofiied by ZY0252  20210301
	setElement("ArriveLocDR_CTLOCDesc",getElementValue("ArriveLoc"))
	initLookUp(); 			//��ʼ���Ŵ�	 MZY0058	2020-10-18
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
	//modified by ZY0198 �ַ��ж�����
	var CanArriveNum=parseFloat(getElementValue("CanArriveNum"))
	var ArriveNum=parseFloat(getElementValue("ArriveNum"))
	if ((ArriveNum<1)||(ArriveNum>CanArriveNum))
	{
		//alertShow("���ε���������Ч!");
		messageShow('alert','info','��ʾ',"���ε���������Ч!");
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
		//alertShow("֪ͨ���ճɹ�!");
		messageShow('alert','success','��ʾ',"֪ͨ���ճɹ�!","",confirmFun);	// MZY0053	1503082		2020-09-08	���ӷ��ش�����
		//var url="dhceq.em.arrive.csp?&SourceType="+getElementValue("SourceType")+"&SourceID="+getElementValue("SourceID")
	    //window.location.href=url;		// MZY0053	1503082		2020-09-08	ע��
	}
	else
    {
             ///modofiied by ZY0252  20210301
	    disableElement("BArrive",false)
	    messageShow('alert','error','��ʾ',"֪ͨ����ʧ��!");
   		//alertShow("֪ͨ����ʧ��!")
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