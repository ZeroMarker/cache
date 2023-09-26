//DHCMedPVMArcimQry
var objLogUser   ///=new clsLogUser("");

function BodyLoadHandler() {
	iniForm();
	var obj=document.getElementById("bQuery");
	if (obj){ obj.onclick=Query_click;}
	var obj=document.getElementById("btnExcel");
	if (obj){ obj.onclick=btnExcel_click;}	
	GetUser();
	}
	
function iniForm() {
	
	var obj=document.getElementById("cLoc");
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;
	  }
	}
	
function GetUser() {
	//update by zf 2008-08-11
	//objLogUser=BASE_GetLogUser(gGetObjValue("txtLogUserInfo"),gGetObjValue("userid"),session['LOGON.GROUPID'],session['LOGON.CTLOCID']);
	objLogUser=BASE_GetLogUser(gGetObjValue("txtLogUserInfo"),session['LOGON.USERID'],session['LOGON.GROUPID'],session['LOGON.CTLOCID']);
}

function SetINCItmName(value){
	var TempPlist=value.split(CHR_Up);
	gSetObjValue("INCItmName",TempPlist[2]);
	gSetObjValue("INCItmID",TempPlist[0]);
	}	

function Query_click() {
    var cDateFrom=gGetObjValue("cDateFrom");
    var cDateTo=gGetObjValue("cDateTo");
    var cLoc=gGetListData("cLoc");
    var cINCItm=gGetObjValue("INCItmID");
    //gSetObjValue("INCItmID","");
    if (cINCItm=="") return;
    
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedPVMPaadmList" + "&fd=" + cDateFrom + "&td=" +cDateTo+ "&loc=" +cLoc+"&ItmBt=" +cINCItm;
    parent.frames[1].location.href=lnk;
	}
function btnExcel_click()
{
	var fd=gGetObjValue("cDateFrom");
    var td=gGetObjValue("cDateTo");
    var loc=gGetListData("cLoc");
    var ItmBt=gGetObjValue("INCItmID");
    //gSetObjValue("INCItmID","");
    if (ItmBt=="") return;
	var encmeth=gGetObjValue("txtGetServerInfo");
	objWebServer=BASE_GetWebConfig(encmeth);
	QueryTool.ConnectionString = objWebServer.LayOutManager;
	var arryResult = QueryTool.RunQuery("web.DHCMedPVMRepINCItm","QueryPaadmByItmBt",ItmBt,fd,td,loc);
	QueryTool.CreateExcelFile(arryResult,1,1,ExcelGenHandler,null);
}

function ExcelGenHandler(objExcelApp, objWorkBook, objSheet)
{
	//var TitleCell = objSheet.Cells(1, 1);
	//TitleCell.Font.Size = 20;
	//objSheet.Cells(2, 1).Value = t["PatientName"] + objPatient.PatientName;
	//objSheet.Range(objSheet.Cells(1, 1), objSheet.Cells(1, 7)).Merge();
	objSheet.Columns("A:A").Select
	objExcelApp.Selection.Delete
	objSheet.Columns("G:G").Select
	objExcelApp.Selection.Delete
	objSheet.Columns("A:A").Select
	objSheet.Cells(1, 1).Value = t["name"];
	objSheet.Cells(1, 2).Value = t["patno"];
    objSheet.Cells(1, 3).Value = t["admdate"];
	objSheet.Cells(1, 4).Value = t["admloc"];
	objSheet.Cells(1, 5).Value = t["age"];
	objSheet.Cells(1, 6).Value = t["admno"];

	objExcelApp.Visible = true;
}
	
document.body.onload = BodyLoadHandler;