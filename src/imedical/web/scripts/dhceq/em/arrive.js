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
	var valuelist=getElementValue("SourceType")+"^"+getElementValue("SourceID")+"^"+ArriveNum;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSArrive","SaveArriveRecord",combindata,valuelist);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		//alertShow("֪ͨ���ճɹ�!");
		messageShow('alert','success','��ʾ',"֪ͨ���ճɹ�!");
		var url="dhceq.em.arrive.csp?&SourceType="+getElementValue("SourceType")+"&SourceID="+getElementValue("SourceID")
	    window.location.href= url;
	}
	else
    {
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
}
