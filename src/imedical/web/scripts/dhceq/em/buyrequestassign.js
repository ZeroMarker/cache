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
		messageShow('alert','error','错误提示','没有单据!');
		return;
	}
	var CurRole=getElementValue("CurRole")
	if (CurRole=="")
	{
		messageShow('alert','error','错误提示','当前角色为空!');
		return;
	}
	var EditOpinion=getElementValue("EditOpinion")
	if (EditOpinion=="")
	{
		messageShow('alert','error','错误提示','当前意见为空!');
		return;
	}
	var OpinionRemark=getElementValue("OpinionRemark")
	var RoleStep=getElementValue("RoleStep")
	if (RoleStep=="")
	{
		messageShow('alert','error','错误提示','当前步骤为空!');
		return;
	}
	var editFieldsInfo=""	//getElementValue("editFieldsInfo")
	var BuyUserDR=getElementValue("BuyUserDR")
	
	var Action=getElementValue("Action")
	if (Action!="BuyReq_Assign") BuyUserDR=""
	if ((BuyUserDR=="")&&(Action=="BuyReq_Assign"))
	{
		messageShow('alert','error','错误提示','采购员为空!');
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
		messageShow("","","","审核成功!");
		//add by zx 2019-09-16
		//var url="dhceq.em.buyrequestassign.csp?&Action="+getElementValue("Action")+"&RowIDs="+RowIDs+"&CurRole="+CurRole+"&CurRole="+CurRole+"&ReadOnly=1";
		//window.location.href= url;
		websys_showModal("options").mth();
		closeWindow('modal');
	}
	else
    {
	    //add by ZY0214
	    if (jsonData.SQLCODE=="-1002") messageShow('alert','error','错误提示',jsonData.Data+"计划单中要求设备项必填,请修改!");
		messageShow('alert','error','错误提示',jsonData.Data);
    }
}
function BCancel_Clicked()
{
	var RowIDs=getElementValue("RowIDs")
	if (RowIDs=="")
	{
		messageShow('alert','error','错误提示','没有单据!');
		return;
	}
	var CurRole=getElementValue("CurRole")
	if (CurRole=="")
	{
		messageShow('alert','error','错误提示','当前角色为空!');
		return;
	}
	var RoleStep=getElementValue("RoleStep")
	if (RoleStep=="")
	{
		messageShow('alert','error','错误提示','当前步骤为空!');
		return;
	}
	var EditOpinion=getElementValue("EditOpinion")
	if (EditOpinion=="")
	{
		messageShow('alert','error','错误提示','当前意见为空!');
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
		messageShow("","","","审核成功!");
		//add by zx 2019-09-12
		//var url="dhceq.em.buyrequestassign.csp?&Action="+getElementValue("Action")+"&RowIDs="+RowIDs+"&CurRole="+CurRole+"&ReadOnly=1";
		//window.location.href= url;
		websys_showModal("options").mth();
		closeWindow('modal');
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
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