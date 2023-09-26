var changeflag=0
//页面初始化
function BodyLoadHandler()
{
	InitPage();
}

function InitPage()
{
	var obj=document.getElementById("MoveToR");
	if (obj) obj.onclick=MoveToR_clicked;
	var obj=document.getElementById("MoveToL");
	if (obj) obj.onclick=MoveToL_clicked;
	var obj=document.getElementById("MoveAllToR");
	if (obj) obj.onclick=MoveAllToR_clicked;
	var obj=document.getElementById("MoveAllToL");
	if (obj) obj.onclick=MoveAllToL_clicked;
}

function IsCheckedAll(frameName)
{
   	var flag=0;
	var obj=parent.frames[frameName].document.getElementById('tDHCPEFeeListNew');
	if (!obj) return flag;
	var rows=obj.rows.length; 
	var Info="",checkedRow="";
	for (i=1;i<rows;i++)
	{
		if(Info==""){var Info=i;}
		else {var Info=Info+"^"+i;}
		
		obj=parent.frames[frameName].document.getElementById('TCheckedz'+i);
		if(obj.checked){
			if(checkedRow=="") {var checkedRow=i;}
			else{var checkedRow=checkedRow+"^"+i;}
			} 
	
	}
	
   if ((checkedRow==Info)&&(Info!="")){ var flag=1;}
	return flag;
}

function GetAuditID(frameName)
{	
	var obj=parent.frames[frameName].document.getElementById("PreAudits")
	if (obj) return obj.value;
	return "";
}

function GetFeeItemInfo(frameName)
{
	var feeItemInfos="";
	var obj=parent.frames[frameName].document.getElementById("SelectRows")
	if (obj) 
	{	return obj.value;	}
	return "";
	
}

function GetALLItemFeeID(frameName)
{ 
	var obj=parent.frames[frameName].document.getElementById("AllItemFeeID")
	if (obj) return obj.value;
	return "";
}

function MoveToR_clicked()
{
	var flag=IsCheckedAll("LeftFeeList")
	if(flag==1){alert("如果全部选择移动,请点击移动所有项");
	return false;
	}

	var allFlag=0;
	var feeItems=GetFeeItemInfo("LeftFeeList");
	var auditid=GetAuditID("LeftFeeList");
	var toAuditid=GetAuditID("RightFeeList");
	Move(auditid,toAuditid,allFlag,feeItems,1);
}

function MoveAllToR_clicked()
{
	var allFlag=1;
	var feeItems=GetFeeItemInfo("LeftFeeList");
	var auditid=GetAuditID("LeftFeeList");
	var toAuditid=GetAuditID("RightFeeList");
	
	var alltoAuditid= GetALLItemFeeID ("LeftFeeList");
    if(alltoAuditid==""){
	  alert("已没有可移动的");
 	  return false;
  }

	Move(auditid,toAuditid,allFlag,feeItems,1);
}

function MoveToL_clicked()
{
	var allFlag=0;
	var feeItems=GetFeeItemInfo("RightFeeList");
	var auditid=GetAuditID("RightFeeList");
	var toAuditid=GetAuditID("LeftFeeList");
	Move(auditid,toAuditid,allFlag,feeItems,0);
}

function MoveAllToL_clicked()
{
	var allFlag=1;
	var feeItems=GetFeeItemInfo("RightFeeList");
	var auditid=GetAuditID("RightFeeList");
	var toAuditid=GetAuditID("LeftFeeList");
	Move(auditid,toAuditid,allFlag,feeItems,0);
}

function Move(auditid,toAuditid,allFlag,feeItems,isLToR)
{
	//alert("auditid:"+auditid+"  toAuditid:"+toAuditid+"  allFlag:"+allFlag+"  feeItems:"+feeItems);
	//return;
	if ((auditid=="")||((feeItems=="")&&(allFlag==0))||((feeItems=="^")&&(allFlag==0)))
	{	alert(t['none']);
		return;
	}
	var encmeth=GetCtlValueById("GetMove");
	if (""==encmeth)
	{	alert(t['nosetting']);
		return;
	}
	if (""!=feeItems) 
	{	feeItems=feeItems.substring(1,feeItems.length-1);
	}
	//alert(feeItems);
	//return;
	var result=cspRunServerMethod(encmeth,'','',auditid,toAuditid,allFlag,feeItems);
	if (isNaN(result)==true)
	{	alert(result);		}
	else
	{
		parent.parent.opener.location.reload();
		/*
		changeflag=0;
		if (1==isLToR) 
			{	parent.parent.location.href='dhcpesplitaudit.csp?&AuditID='+auditid+'&ToAuditID='+result;}
		else
			{	parent.parent.location.href='dhcpesplitaudit.csp?&AuditID='+result+'&ToAuditID='+auditid;}
		changeflag=1;
		parent.parent.document.body.onunload = BodyUnLoadHandler;
		*/
	}	
}


function BodyUnLoadHandler()
{
	if (changeflag==1) parent.parent.opener.location.reload();
}

document.body.onload = BodyLoadHandler;
