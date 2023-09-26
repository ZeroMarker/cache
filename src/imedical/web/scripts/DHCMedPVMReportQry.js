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
	var obj=document.getElementById("ReportType");
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;
	  }
    var obj=document.getElementById("Opinion");
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;
	  }  
	  
	var obj=document.getElementById("cStatus");
	if (obj){
	  obj.size=4; 
	  }
	AddStatus();
	AddReportType();
	AddOpinion();
	}
function GetUser() {
	//update by zf 2008-08-11
	//objLogUser=BASE_GetLogUser(gGetObjValue("txtLogUserInfo"),gGetObjValue("userid"),session['LOGON.GROUPID'],session['LOGON.CTLOCID']);
	objLogUser=BASE_GetLogUser(gGetObjValue("txtLogUserInfo"),session['LOGON.USERID'],session['LOGON.GROUPID'],session['LOGON.CTLOCID']);
}
function Query_click() {
    var cDateFrom=gGetObjValue("cDateFrom");
    var cDateTo=gGetObjValue("cDateTo");
    var cLoc=gGetListData("cLoc");
    var cStatus=gGetListCodes("cStatus")
    var cKey=gGetObjValue("txtKey");
    var cINCItm=gGetObjValue("INCItmID");
    var Opinion=gGetListData("Opinion");
    //gSetObjValue("INCItmID","");
    var cReportType=gGetListData("ReportType");
    if (cStatus=="") return;
    //alert(cLoc+","+cStatus+","+cReportType);return;
    if(GetParam(window.parent, "Sta") == "Y")
    {   
		lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedPVMINCItmStaList" + "&DateFrom=" + cDateFrom + "&DateTo=" +cDateTo+ "&CtLoc=" +cLoc+ "&Status=" +cStatus+ "&INCItm=" +cINCItm+"&Key=" + cKey + "&ReportType=" + cReportType+"&Opinion="+ Opinion;
    	parent.frames[1].location.href=lnk;
    }
    else
    {
	    lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedPVMReportList" + "&DateFrom=" + cDateFrom + "&DateTo=" +cDateTo+ "&CtLoc=" +cLoc+ "&Status=" +cStatus+ "&INCItm=" +cINCItm+"&Key=" + cKey + "&ReportType=" + cReportType+"&Opinion="+ Opinion;
    	parent.frames[1].location.href=lnk;
	    }
	}
function btnExcel_click()
{
	var DateFrom=gGetObjValue("cDateFrom");
    var DateTo=gGetObjValue("cDateTo");
    var CtLoc=gGetListData("cLoc");
    var Status=gGetListCodes("cStatus")
    var Key=gGetObjValue("txtKey");
    var INCItm=gGetObjValue("INCItmID");
    var Opinion=gGetListData("Opinion");
    //gSetObjValue("INCItmID","");,,,,,,
    var ReportType=gGetListData("ReportType");
    if (Status=="") return;
	var encmeth=gGetObjValue("txtGetServerInfo");
	objWebServer=BASE_GetWebConfig(encmeth);
	QueryTool.ConnectionString = objWebServer.LayOutManager;
	
	if(GetParam(window.parent, "Sta") == "Y")
	{
		var arryResult = QueryTool.RunQuery("web.DHCMedPVMINCItmSta","QueryStaReport",DateFrom,DateTo,CtLoc,Status,INCItm,Key,ReportType,Opinion);
		var tmpRow=t["userName"]+String.fromCharCode(1)+String.fromCharCode(1)+String.fromCharCode(1)+String.fromCharCode(1)+String.fromCharCode(1)+String.fromCharCode(1)+objLogUser.Name;
		arryResult.push(tmpRow);
		var tmpRow=t["tlName"]+String.fromCharCode(1)+String.fromCharCode(1)+String.fromCharCode(1)+String.fromCharCode(1)+String.fromCharCode(1)+String.fromCharCode(1);
		arryResult.push(tmpRow);
		var tmpRow=t["printDate"]+String.fromCharCode(1)+String.fromCharCode(1)+String.fromCharCode(1)+String.fromCharCode(1)+String.fromCharCode(1)+String.fromCharCode(1)+PrintDate();
		arryResult.push(tmpRow);
		QueryTool.CreateExcelFile(arryResult,1,1,ExcelGenHandlerSta,null);
	}
	else{
		var arryResult = QueryTool.RunQuery("web.DHCMedPVMRepINCItm","QueryReport",DateFrom,DateTo,CtLoc,Status,INCItm,Key,ReportType,Opinion);
		QueryTool.CreateExcelFile(arryResult,1,1,ExcelGenHandler,null);
	}
	
}

function PrintDate(){
   var d,s="";           // 声明变量
   d = new Date();                           // 创建 Date 对象
   s += d.getYear()+ t["Year"];                         // 获取年份
   s += (d.getMonth() + 1) + t["Month"];            // 获取月份
   s += d.getDate() + t["Day"];                   // 获取日
   return(s);                                // 返回日期
}

function ExcelGenHandlerSta(objExcelApp, objWorkBook, objSheet)
{
	objSheet.Columns("E:F").Select
	objExcelApp.Selection.NumberFormatLocal = "0.000";
	objSheet.Columns("B:B").ColumnWidth = 32.38
	objSheet.Columns("G:G").ColumnWidth = 32.38
	objSheet.Cells(1, 1).Value = t["RepPlace"];
	objSheet.Cells(1, 2).Value = t["IncItmName"];
    objSheet.Cells(1, 3).Value = t["UOM"];
	objSheet.Cells(1, 4).Value = t["qty"];
	objSheet.Cells(1, 5).Value = t["Price"];
	objSheet.Cells(1, 6).Value = t["PriceSum"];
    objSheet.Cells(1, 7).Value = t["Res"];
	objExcelApp.Visible = true;
	//oExcel.Range("A" + CStr(RowN + 2)).Select
}

function ExcelGenHandler(objExcelApp, objWorkBook, objSheet)
{
	//var TitleCell = objSheet.Cells(1, 1);
	//TitleCell.Font.Size = 20;
	//objSheet.Cells(2, 1).Value = t["PatientName"] + objPatient.PatientName;
	//objSheet.Range(objSheet.Cells(1, 1), objSheet.Cells(1, 7)).Merge();
	//Selection.NumberFormatLocal = "0.000;[红色]0.000"
	objSheet.Columns("A:A").Select
	objExcelApp.Selection.Delete
	objSheet.Columns("D:E").Select
	objExcelApp.Selection.Delete
	objSheet.Columns("K:K").Select
	objExcelApp.Selection.Delete
	objSheet.Columns("Q:R").Select
	objExcelApp.Selection.Delete
	
	objSheet.Columns("A:A").Select
	objSheet.Cells(1, 1).Value = t["RepNo"];
	objSheet.Cells(1, 2).Value = t["repType"];
    objSheet.Cells(1, 3).Value = t["status"];
	objSheet.Cells(1, 4).Value = t["qty"];
	objSheet.Cells(1, 5).Value = t["inqty"];
	objSheet.Cells(1, 6).Value = t["stqty"];
    objSheet.Cells(1, 7).Value = t["describe"];
	objSheet.Cells(1, 8).Value = t["resume"];
	
	objSheet.Cells(1, 9).Value = t["opinion"];
	objSheet.Cells(1, 10).Value = t["reploc"];
	objSheet.Cells(1, 11).Value = t["repuser"];
	objSheet.Cells(1, 12).Value = t["repdate"];
	objSheet.Cells(1, 13).Value = t["reptime"];
	objSheet.Cells(1, 14).Value = t["checkuser"];
	objSheet.Cells(1, 15).Value = t["checkdate"];
	objSheet.Cells(1, 16).Value = t["checktime"];
	objExcelApp.Visible = true;
}

function AddStatus(){
	gClearAllList("cStatus");
	s=gGetObjValue("tmpDictionary");
	var objDic=BASE_GetDictionary(s,"PVMReportStatus","Y");
	//alert(objDic.Count);
	var a=(new VBArray(objDic.Keys()));   
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("cStatus",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Code)
	    gSetListIndex("cStatus",i);
	    }
	}	

function AddReportType(){
	gClearAllList("ReportType");
	s=gGetObjValue("tmpDictionary");
	var objDic=BASE_GetDictionary(s,"PVMReportType","Y");
	if (objDic.Count>0){
		gSetListValue("ReportType",t['All'],"");
		}
	//alert(objDic.Count);
	var a=(new VBArray(objDic.Keys()));   
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("ReportType",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Code)
	    }
	}

function AddOpinion(){
	gClearAllList("Opinion");
	s=gGetObjValue("tmpDictionary");
	var objDic=BASE_GetDictionary(s,"PVMOpinion","Y");
	if (objDic.Count>0){
		gSetListValue("Opinion",t['All'],"");
		}
	//alert(objDic.Count);
	var a=(new VBArray(objDic.Keys()));   
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("Opinion",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Code)
	    }
	}

function SetINCItmName(value){
	var TempPlist=value.split(CHR_Up);
	gSetObjValue("INCItmName",TempPlist[2]);
	gSetObjValue("INCItmID",TempPlist[0]);
	}		
document.body.onload = BodyLoadHandler;

//get parameter from url string
//obj:window object
//key:item name
function GetParam(obj, key)
{
	var url = obj.location.href;
    var strParams = "";
    var pos = url.indexOf("?");
    var tmpArry = null;
    var strValue = "";
    var tmp = "";
    if( pos < 0)
    {
       return "";
		}
    else
    {
		
       strParams = url.substring(pos + 1, url.length);
       tmpArry = strParams.split("&");
       for(var i = 0; i < tmpArry.length; i++)
       {
          tmp = tmpArry[i];
          if(tmp.indexOf("=") < 0)
             continue;
          if(tmp.substring(0, tmp.indexOf("=")) == key)
             strValue = tmp.substring(tmp.indexOf("=") + 1, tmp.length);
			}
          return strValue;
		}
	}