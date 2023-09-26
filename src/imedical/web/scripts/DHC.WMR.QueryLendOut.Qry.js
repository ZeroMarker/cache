//DHC.WMR.QueryLendOut.Qry.js
var mrType="";
var statusId="";
var admType="";

function Init(){
	mrType=GetParam(window,"MrType");
    statusId=GetParam(window,"StatusID");
    admType=GetParam(window,"AdmType");
	DisplayMrType();
	var objFind=document.getElementById("btnFind")
	if (objFind){objFind.onclick=Find_Click;}
}
function DisplayMrType()
{
	var DicRowid = GetParam(window,"MrType");
	var strMethod = document.getElementById("MethodGetDicItem").value;
	var ret = cspRunServerMethod(strMethod,DicRowid);
	if (ret=="") return;
	var tmpList=ret.split("^");
	if (tmpList.length>=2)
	{
		//document.getElementById("MrTypeDr").value=tmpList[0];
		document.getElementById("txtMrType").value=tmpList[2];
	}
}
function Find_Click(){
	var startDate="",endDate="",printFlag="N";
	
	var obj_StartDate=document.getElementById("txtStartDate");
	if (obj_StartDate){startDate=obj_StartDate.value;}
	var obj_EndDate=document.getElementById("txtEndDate");	
	if (obj_EndDate){endDate=obj_EndDate.value;}
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.QueryLendOut&MrType="+mrType+"&AdmType="+admType+"&StatusID="+statusId+"&DateFrom="+startDate+"&DateTo="+endDate+"&PrintFlag="+printFlag;
	
	parent.RPBottom.location.href=lnk;
}
//Init();
window.onload=Init;
//document.onload=Init;