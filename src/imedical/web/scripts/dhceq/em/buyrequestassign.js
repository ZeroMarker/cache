$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	initLookUp();
	initButton();
	initButtonWidth();
	defindTitleStyle();
    setEnabled();
}

function BAudit_Clicked() 
{
	var RowIDs=getElementValue("RowIDs");
	if (RowIDs=="")
	{
		messageShow('alert','error','������ʾ','û�е���!');
		return;
	}
	var CurRole=getElementValue("CurRole")
	if (CurRole=="")
	{
		messageShow('alert','error','������ʾ','��ǰ��ɫΪ��!');
		return;
	}
	var EditOpinion=getElementValue("EditOpinion")
	if (EditOpinion=="")
	{
		messageShow('alert','error','������ʾ','��ǰ���Ϊ��!');
		return;
	}
	var OpinionRemark=getElementValue("OpinionRemark")
	var RoleStep=getElementValue("RoleStep")
	if (RoleStep=="")
	{
		messageShow('alert','error','������ʾ','��ǰ����Ϊ��!');
		return;
	}
	var editFieldsInfo=""	//getElementValue("editFieldsInfo")
	var BuyUserDR=getElementValue("BuyUserDR")
	
	var Action=getElementValue("Action")
	if (Action!="BuyReq_Assign") BuyUserDR=""
	if ((BuyUserDR=="")&&(Action=="BuyReq_Assign"))
	{
		messageShow('alert','error','������ʾ','�ɹ�ԱΪ��!');
		return;
	}
	var AuditInfo=CurRole
	AuditInfo=AuditInfo+"^"+RoleStep
	AuditInfo=AuditInfo+"^"+EditOpinion
	AuditInfo=AuditInfo+"^"+OpinionRemark
	AuditInfo=AuditInfo+"^"	//RejectReason
	AuditInfo=AuditInfo+"^"+BuyUserDR	//BuyUserDR
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","BatchAuditData",RowIDs,AuditInfo,editFieldsInfo);
	//alertShow(jsonData)
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow("","","","��˳ɹ�!");
		//add by zx 2019-09-16
		//var url="dhceq.em.buyrequestassign.csp?&Action="+getElementValue("Action")+"&RowIDs="+RowIDs+"&CurRole="+CurRole+"&CurRole="+CurRole+"&ReadOnly=1";
		//window.location.href= url;
		websys_showModal("options").mth();
		closeWindow('modal');
	}
	else
    {
	    //add by ZY0214
	    if (jsonData.SQLCODE=="-1002") messageShow('alert','error','������ʾ',jsonData.Data+"�ƻ�����Ҫ���豸�����,���޸�!");
		messageShow('alert','error','������ʾ',jsonData.Data);
    }
}
function BCancel_Clicked()
{
	var RowIDs=getElementValue("RowIDs")
	if (RowIDs=="")
	{
		messageShow('alert','error','������ʾ','û�е���!');
		return;
	}
	var CurRole=getElementValue("CurRole")
	if (CurRole=="")
	{
		messageShow('alert','error','������ʾ','��ǰ��ɫΪ��!');
		return;
	}
	var RoleStep=getElementValue("RoleStep")
	if (RoleStep=="")
	{
		messageShow('alert','error','������ʾ','��ǰ����Ϊ��!');
		return;
	}
	var EditOpinion=getElementValue("EditOpinion")
	if (EditOpinion=="")
	{
		messageShow('alert','error','������ʾ','��ǰ���Ϊ��!');
		return;
	}
	var OpinionRemark=getElementValue("OpinionRemark")
	var AuditInfo=CurRole
	AuditInfo=AuditInfo+"^"+RoleStep
	AuditInfo=AuditInfo+"^"	//EditOpinion
	AuditInfo=AuditInfo+"^"+OpinionRemark
	AuditInfo=AuditInfo+"^"+EditOpinion	//RejectReason
	AuditInfo=AuditInfo+"^"	//
	
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","BatchCancelSubmitData",RowIDs,AuditInfo);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow("","","","��˳ɹ�!");
		//add by zx 2019-09-12
		//var url="dhceq.em.buyrequestassign.csp?&Action="+getElementValue("Action")+"&RowIDs="+RowIDs+"&CurRole="+CurRole+"&ReadOnly=1";
		//window.location.href= url;
		websys_showModal("options").mth();
		closeWindow('modal');
	}
	else
    {
		messageShow('alert','error','������ʾ',jsonData.Data);
    }
}

function setEnabled()
{
	var Action=getElementValue("Action")
	if (Action!="BuyReq_Assign")
	{
		hiddenObj("hiddenFlag",1);
	}
	var ReadOnly=getElementValue("ReadOnly")
	if (ReadOnly==1)
	{
		$("#BAudit").linkbutton("disable");
		$("#BCancel").linkbutton("disable");
	}
	
}

function setSelectValue(elementID,rowData)
{
	if(elementID=="BuyUserDR_SSUSRName") {setElement("BuyUserDR",rowData.TRowID)}
}