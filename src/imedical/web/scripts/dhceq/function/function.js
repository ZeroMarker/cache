//Create By DJ 20160126 ��������
//====================================================================
//����Ĭ�Ͻ���
function setFocus(id)
{
	if(jQuery("#" + id).length)
	{
		jQuery("#" + id).focus();
	}
}
function GetComboGridDesc(vElements,vElements2)
{
	var ReturnStr=""
	if (vElements!="")
	{
		var ElementsInfo=vElements.split("^");
		for(var i=1; i<=ElementsInfo.length; i++)
		{
			var vElementID=ElementsInfo[i-1];
			if (jQuery("#"+vElementID).prop("type")!="hidden")
			{
				ReturnStr=ReturnStr+"&"+vElementID+"="+jQuery("#"+vElementID).combogrid("getText");
			}
		}
	}
	if (vElements2!="")
	{
		var ElementsInfo=vElements2.split("^");
		for(var i=1; i<=ElementsInfo.length; i++)
		{
			var CurElement=ElementsInfo[i-1]
			var CurElementInfo=CurElement.split("=");
			var vParamName=CurElementInfo[0];
			var vElementID=CurElementInfo[1];
			if (jQuery("#"+vElementID).prop("type")!="hidden")
			{
				ReturnStr=ReturnStr+"&"+vParamName+"="+jQuery("#"+vElementID).combogrid("getText");
			}
		}
	}
	return ReturnStr
}
//��ʼ������Ԫ����Ч�Լ���¼�
//2016-01-26 ���¼��������
function initNumElement(vElements)
{
	var ElementInfo=vElements.split("^");
	for(var i=1; i<=ElementInfo.length; i++)
	{
		var CurElement=ElementInfo[i-1]
		if (jQuery("#"+CurElement).prop("type")!="hidden")
		{
			//jQuery("#"+CurElement).change(function(){NumChange(CurElement)});
		}
	}
}
//����Ԫ����Ч�Լ�麯��
function NumChange(vElementID)
{
	var ElementValue=jQuery("#"+vElementID).val();
	if ((ElementValue!="")&&(isNaN(ElementValue)))
	{
		alertShow("����ȷ������ֵ!")
		return
	}
}