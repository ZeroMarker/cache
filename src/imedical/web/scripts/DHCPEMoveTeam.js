//added by xy 20180427
//function:转组
//js:DHCPEMoveTeam.js

var CurrentSel=0

function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("ParRef");
	if (obj) {var iParRef=obj.value}	
}
		
function SelectRowHandler() {
	if (!confirm("是否确定转移到该组")) return false;
	var SelRowObj,obj;
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById("tDHCPEMoveTeam");	
	if (objtbl) { var rows=objtbl.rows.length; }
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (CurrentSel==selectrow)
	{
		CurrentSel=0
	}
	else
	{
		CurrentSel=selectrow;
	}
	
	var Sex="",UpperLimit="",LowerLimit="",Married=""
	SelRowObj=document.getElementById('PGT_RowId'+'z'+CurrentSel);
	if(SelRowObj){var PGTeam=SelRowObj.value;}
	
	SelRowObj=document.getElementById('PGT_Sex_Desc'+'z'+CurrentSel);
	if(SelRowObj){var Sex=SelRowObj.innerText;}
	
	SelRowObj=document.getElementById('PGT_UpperLimit'+'z'+CurrentSel);
	if(SelRowObj){var UpperLimit=SelRowObj.innerText;}

	SelRowObj=document.getElementById('PGT_LowerLimit'+'z'+CurrentSel);
	if(SelRowObj){var LowerLimit=SelRowObj.innerText;}
	
	SelRowObj=document.getElementById('PGT_Married_Desc'+'z'+CurrentSel);
	if(SelRowObj){var Married=SelRowObj.innerText;}
	
	
	obj=document.getElementById("ParRef");
	if (obj) {var iParRef=obj.value}
	
	obj=document.getElementById("PIADMRowId");
	if (obj) {var iPIADMRowId=obj.value}
	
	obj=document.getElementById("PGTeam");
	if (obj) {var iPGTeam=obj.value}
	var string=Sex+"^"+Married+"^"+UpperLimit+"^"+LowerLimit;
  
	var MoveFlag=tkMakeServerCall("web.DHCPE.PreIADM","IsSatisfyTeamInfo",iPIADMRowId,PGTeam,string)

	var MoveCanFlag=MoveFlag.split(",")
 	if (MoveCanFlag[0]==-1)
 	{
	 	if (!(confirm(MoveCanFlag[1])))
	 	{
		 	return false;
		} 
	}
	if (MoveCanFlag[0]==-2)
 	{
	 	alert(MoveCanFlag[1])
		 	return false;
		
	}
	
	var Ret=tkMakeServerCall("web.DHCPE.CancelPE","CancelPE",iPIADMRowId,"I",0)
   
	var iPIBIDR=tkMakeServerCall("web.DHCPE.PreIADM","GetPIBIByPIADM",iPIADMRowId)
	var flag=tkMakeServerCall("web.DHCPE.PreIADM","InsertIADMInGTeam",iPIBIDR,iParRef,PGTeam)
	var flag=flag.split("^")
	if ('0'==flag[0]) {
		alert("转组成功");
	 	opener.location.reload();    
		window.close();
	}
	

}
document.body.onload = BodyLoadHandler;