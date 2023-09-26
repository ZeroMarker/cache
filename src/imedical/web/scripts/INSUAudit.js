//INSUAudit.js
var Flag=""
function BodyLoadHandler() {
	Guser=session['LOGON.USERID'];var obl=document.getElementById("RegNo") ;
	var objtbl=document.getElementById("tINSUAudit") ;
    var now= new Date()
    var hour= now.getHours();
	if (objtbl)
	{
		//objtbl.ondblclick=RowChanged;
		for (i=1;i<objtbl.rows.length;i++)
		{
			var item=document.getElementById("Selectz"+i);
			item.checked=true;
			var TabAuditFlag=document.getElementById("TabAuditFlagz"+i).innerText;
 			if ((TabAuditFlag==" "))
			{
				item.checked=true;
			}
		}
	}
	
		var Audit=document.getElementById("BtnAudit") ;
		if (Audit)  Audit.onclick=Audit_Click;
		var Refuse=document.getElementById("BtnRefuse") ;
		if (Refuse)  Refuse.onclick=Refuse_Click;
		var ResumeObj=document.getElementById("BtnResume") ;
		if (ResumeObj)  ResumeObj.onclick=Resume_Click;


}

function GetSelectItem()
{
	var TabOEORIRowIdStr=""
	var OEORIRowId=""
	var objtbl=document.getElementById("tINSUAudit") ;
	if (objtbl)
	{
		for (i=1;i<objtbl.rows.length;i++)
		{
			var item=document.getElementById("Selectz"+i);
			if(item.checked==true)
			{
				var OEORIRowId=document.getElementById("TabOEORIRowIdz"+i).value
				if(TabOEORIRowIdStr=="") var TabOEORIRowIdStr=OEORIRowId
				else   var TabOEORIRowIdStr=TabOEORIRowIdStr+"^"+OEORIRowId
			}
		}
	}
	//alert(TabOEORIRowIdStr)
	return TabOEORIRowIdStr

}
function Audit_Click()
{
	var TabOEORIRowIdStr=GetSelectItem()
	var MedAudit=document.getElementById("MedAudit").value ;
    var ret=cspRunServerMethod(MedAudit,TabOEORIRowIdStr,"Y",Guser);
    if (ret!=0)
    {
		alert("更新标志失败!")
	}
    BtnFind_click()
}
function Refuse_Click()
{
	var TabOEORIRowIdStr=GetSelectItem()
	var MedAudit=document.getElementById("MedAudit").value ;
    var ret=cspRunServerMethod(MedAudit,TabOEORIRowIdStr,"N",Guser);
    if (ret!=0)
    {
		alert("更新标志失败!")
	}
    BtnFind_click()
}
function Resume_Click()
{
	var TabOEORIRowIdStr=GetSelectItem()
	var MedAudit=document.getElementById("MedAudit").value ;
    var ret=cspRunServerMethod(MedAudit,TabOEORIRowIdStr,"",Guser);
    if (ret!=0)
    {
		alert("更新标志失败!")
	}
    BtnFind_click()
}

/*
function NurAudit_Click()
{
	var PrescNoStr=GetSelectItem()
	var MedAudit=document.getElementById("MedNurAudit").value ;
    var ret=cspRunServerMethod(MedAudit,PrescNoStr,"Y");
    BtnFind_click()
}
function NurResume_Click()
{
	var PrescNoStr=GetSelectItem()
	var MedAudit=document.getElementById("MedNurAudit").value ;
    var ret=cspRunServerMethod(MedAudit,PrescNoStr,"");
    BtnFind_click()
}
function SendMsg_Click()
{
	var ward=document.getElementById("ward").value ;
    var SavMsg=document.getElementById("SavMsg").value ;
    var warddes=document.getElementById("warddes").value;
    var Process=document.getElementById("Processz"+1).innerText;
    var userid=session['LOGON.USERID'];
	var ret=cspRunServerMethod(SavMsg,ward,warddes,userid,Process);
	if (ret==0)    //WardId,Ward,UserId,Process
	alert("OK");
}

function RowChanged()
{
	alert("RowChanged")
	var eSrc=window.event.srcElement
	var rowObj=getRow(eSrc)
	
	var selectrow=rowObj.rowIndex
	var objtbl=document.getElementById('tINSUAudit');	
	var rows=objtbl.rows.length;

alert(rows)

var SelRowObj=document.getElementById('TabPrescNoz'+selectrow);	
var buyrowid=SelRowObj.innerText;
  
  if (rows>0)
  {
	var SelRowObj=document.getElementById('TabPrescNoz'+selectrow);	
	var PrescNo=SelRowObj.innerText;
  alert("PrescNo=" + PrescNo)
	  var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCNurInsAuditDetail&PrescNo="+PrescNo;	  
	
	  parent.frames['RPbottom'].document.location.href=lnk;
	}
	
}
function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch (e)
	{
		alert(e.toString());
		return -1;
	}
}

function All_Click()
{
	var objUnPayFlage=document.getElementById("UnPayFlage");
	var objAllFlage=document.getElementById("AllFlage");
	if(objAllFlage){
		if(objAllFlage.checked==true){
			if(objUnPayFlage){objUnPayFlage.checked=false}
		}
	}

}
*/
document.body.onload = BodyLoadHandler;
