
//名称	DHCPEMove.js
//组件  DHCPEMove
//功能	拆分
//创建	2018.09.27
//创建人  xy
document.body.style.padding="0px 0px 10px 0px"
var changeflag=0

function BodyLoadHandler()
{
	
	
	InitPage();
	//设置按钮大小
	$("#MoveToR").css({"width":"130px"});
	$("#MoveAllToR").css({"width":"130px"});
	$("#MoveToL").css({"width":"130px"});
	$("#MoveAllToL").css({"width":"130px"});

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
   	var panel=parent.frames[frameName].$("#tDHCPEFeeListNew").datagrid("getPanel");
   	var objtbl =parent.frames[frameName].$("#tDHCPEFeeListNew").datagrid('getRows');
    var rows=objtbl.length;
	var Info="",checkedRow="";
	
	for (var j=0;j<rows;j++)
	{
		if(Info.length<1){ Info=j;}
		else{ Info=Info+"^"+j;}
		var objCheck=panel.find(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+j+"] td[field="+"TChecked"+"] input");
		if(objCheck.prop("checked")){
			if(checkedRow.length<1) {var checkedRow=j;}
			else{var checkedRow=checkedRow+"^"+j;}
		}
	
	}
	
   if ((checkedRow==Info)&&(Info!="")){ var flag=1;}
	return flag;
}

function GetAuditID(frameName)
{	
	return  parent.frames[frameName].$("#PreAudits").val();
	
}

function GetFeeItemInfo(frameName)
{
	var panel=parent.frames[frameName].$("#tDHCPEFeeListNew").datagrid("getPanel");
   	var objtbl =parent.frames[frameName].$("#tDHCPEFeeListNew").datagrid('getRows');
    var rows=objtbl.length;
	if (!objtbl) return flag;
	var RowIDs="";
	for (var i=0;i<rows;i++)
	{
		
		var objCheck=panel.find(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+i+"] td[field="+"TChecked"+"] input");
		
		if(objCheck.prop("checked")){
			var itemfeeid=objtbl[i].TRowId;
			var itemfeetype=objtbl[i].TFeeType;
			var itemfeeinfos="";
			if ((""!=itemfeeid)&&(""!=itemfeetype)) itemfeeinfos=itemfeeid+","+itemfeetype;
			if((""!=itemfeeid)&&(""==itemfeetype)) itemfeeinfos=itemfeeid;
			   if (RowIDs=="") RowIDs=RowIDs+"^"		
			RowIDs=RowIDs+itemfeeinfos+"^";
		}
	}
	
	return RowIDs		
}

function GetALLItemFeeID(frameName)
{ 
     return parent.frames[frameName].$("#AllItemFeeID").val();
	
}

function MoveToR_clicked()
{
	var flag=IsCheckedAll("LeftFeeList");
	
	if(flag==1){
		alert("如果全部选择移动,请点击移动所有项");	
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
	
	if ((auditid=="")||((feeItems=="")&&(allFlag==0))||((feeItems=="^")&&(allFlag==0)))
	{	alert(t['none']);
		return;
	}
	var encmeth=GetCtlValueById("GetMove");
	if (""==encmeth)
	{	alert(t['nosetting']);
		return;
	}
	
	
	var result=cspRunServerMethod(encmeth,'','',auditid,toAuditid,allFlag,feeItems);
	
	if (isNaN(result)==true)
	{	alert(result);		}
	else
	{
		//parent.parent.opener.location.reload();
		
		changeflag=0;
		if (1==isLToR) 
			{	parent.parent.location.href='dhcpesplitaudit.csp?&AuditID='+auditid+'&ToAuditID='+result;}
		else
			{	parent.parent.location.href='dhcpesplitaudit.csp?&AuditID='+result+'&ToAuditID='+auditid;}
		changeflag=1;
		
		 var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetAuditById",auditid);
		 ret=ret.split("^");
		 
		 var admtype=ret[0]
		 var giadm=ret[1]
		
		 parent.parent.opener.$("#PreAuditPayTable").datagrid('load',{ClassName:"web.DHCPE.PreAudit",QueryName:"SerchPreAudit",ADMType:admtype,CRMADM:"",GIADM:giadm,AppType:"Fee"});
		
		 //parent.parent.document.body.onunload = BodyUnLoadHandler;
		
	}	
}


function BodyUnLoadHandler()
{
	
	if (changeflag==1) parent.parent.opener.location.reload();
}

document.body.onload = BodyLoadHandler;
