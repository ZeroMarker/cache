/* =========================================================================

JavaScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.PrintCard.Condition.js

AUTHOR: LiYang , Microsoft
DATE  : 2007-6-21


============================================================================ */

var tmpChinese;
function GetChinese(MethodName,Ind)
{
	var strMethod = document.getElementById(MethodName).value;
	var ret = cspRunServerMethod(strMethod,Ind);
	var tmp=ret.split("^");
	return tmp;
}
tmpChinese=GetChinese("MethodGetChinese","DHC.WMR.PrintCard.List");

var intSelectRow = -1;
var strTableName = "tDHC_WMR_PrintCard_List";
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById(strTableName);
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) 
	{
		intSelectRow = -1;
	}
	else
	{
		intSelectRow = selectrow;
	}	
}

function MarkFirstVisit()
{
    var objTable = document.getElementById(strTableName);
    var objCheck = null;
   for(var i = 1; i < objTable.rows.length; i ++)
   {
     objCheck = document.getElementById("FirstVisitz" + i);
     
     objCheck.checked = (document.getElementById("VisitFlagz" + i) .value == "Y");
    } 
}

function GetNeedPrintList()
{
    var objTable = document.getElementById(strTableName);
    var objArry = new Array();
    var objCheck = null;
    for(var i = 0; i < objTable.rows.length; i ++)
   {
     objCheck = document.getElementById("NeedPrintz" + i);
     if(objCheck.checked)
        objArry.push(document.getElementById("RowIDz" + i).value);
    }  
   return objArry; 
}

function cboFilterOnChange()
{
    var strChoice = getElementValue("cboFilter");
    var objTable = document.getElementById(strTableName);
   switch(strChoice)
  {
        case "0":
            for(var i = 1; i < objTable.rows.length; i ++)
            {
                setElementValue("NeedPrintz" + i, true);
            }
            break;
        case "1":
            for(var i = 1; i < objTable.rows.length; i ++)
            {
                if(getElementValue("VisitFlagz" + i) == "Y")
                    setElementValue("NeedPrintz" + i, true);
                else
                    setElementValue("NeedPrintz" + i, false);
            }
            break;
        case "2":  
            for(var i = 1; i < objTable.rows.length; i ++)
            {
                if(getElementValue("VisitFlagz" + i) == "N")
                    setElementValue("NeedPrintz" + i, true);
                else
                    setElementValue("NeedPrintz" + i, false);
            }
            break;
  }  
}

function cmdSelectAllOnClick()
{
    var objTable = document.getElementById(strTableName);
    var objCheck = null;
    for(var i = 1; i < objTable.rows.length; i ++)
   {
        setElementValue("NeedPrintz" + i, true) ;
    }  
}

function cmdSelectNoneOnClick()
{
    var objTable = document.getElementById(strTableName);
    var objCheck = null;
    for(var i = 1; i < objTable.rows.length; i ++)
   {
        setElementValue("NeedPrintz" + i, false) ;
    }  
}

function TableItem()
{
	var obj = new Object();
	obj.PinYin = "";
	obj.Row = 0;
	return obj;
}

function SortByPinYin()
{
	var objArry = new Array();
	var objTable  = document.getElementById("tDHC_WMR_PrintCard_List");
	var obj = null;
	var obj1 = null;
	
	for(var i = 1; i < objTable.rows.length; i ++)
	{
		obj = TableItem();
		obj.PinYin = getElementValue("PinYinz" + i);
		obj.Row = i;
		objArry.push(obj);
	}
	
	for(var i = 0; i < objArry.length; i ++)
	{
		for(var j = 0; j < objArry.length -1; j ++)
		{
			obj = objArry[j];
			obj1 = objArry[j + 1];
			if(obj.PinYin > obj1.PinYin)
			{
				objArry[j] = obj1;
				objArry[j + 1] = obj;	
			}
		}
	}	
	return objArry;
}

function PrintReport()
{
    var objPatient = null;
    var  objMrPatient = null;
    var  intYPos = 0;
    var LeftMarge = 1.5;
   var TopMarge = 1.5;
    var  LineHeight = 0.7;
   var strPapmi = "";
  var strMainID = "";  
  var objArry = SortByPinYin();
  var obj = null;
  objPrinter = new ActiveXObject("DHCMedWebPackage.clsPrinter");
  objPrinter.Font = tmpChinese[0];
  objPrinter.FontBold  = true;
  objPrinter.FontSize = 15;
  objPrinter.PrintContents(LeftMarge + 6, TopMarge + 0, tmpChinese[1]);
   
  objPrinter.Font = tmpChinese[2];
  objPrinter.FontSize = 11; 
  objPrinter.FontBold = false;
  intYPos = 1;
   for(var i = 1; i < objArry.length; i ++)
  {
	obj = objArry[i];
        strPapmi = getElementValue("Papmiz" + obj.Row); 
        strMainID = getElementValue("RowIDz" + obj.Row); 
       if(!getElementValue("NeedPrintz" + obj.Row)) 
        continue;
        if(strMainID != "")
       {
            objMrPatient = GetPatientInfoByMrRowID("MethodGetPatientInfoByMrRowID", strMainID);
            objPrinter.PrintContents(LeftMarge + 0 , TopMarge + LineHeight * intYPos, getElementValue("MrNOz" +  obj.Row));
            objPrinter.PrintContents(LeftMarge + 3, TopMarge + LineHeight * intYPos, objMrPatient.PatientName);
            objPrinter.PrintContents(LeftMarge + 5, TopMarge + LineHeight * intYPos, objMrPatient.Sex);
            objPrinter.PrintContents(LeftMarge + 6, TopMarge + LineHeight * intYPos, objMrPatient.Company);
            objPrinter.PrintContents(LeftMarge + 12, TopMarge + LineHeight * intYPos, objMrPatient.HomeAddress); 
       }
       else
       {
            objPatient = GetPatientByID("MethodGetPatientByID", strPapmi);
            objPrinter.PrintContents(LeftMarge + 0 , TopMarge + LineHeight * intYPos, objPatient.PatientNo + tmpChinese[3]);
            objPrinter.PrintContents(LeftMarge + 3, TopMarge + LineHeight * intYPos, objPatient.PatientName);
            objPrinter.PrintContents(LeftMarge + 5, TopMarge + LineHeight * intYPos, objPatient.Sex);
            objPrinter.PrintContents(LeftMarge + 6, TopMarge + LineHeight * intYPos, objPatient.Company);
            objPrinter.PrintContents(LeftMarge + 12, TopMarge + LineHeight * intYPos, objPatient.NowAddress);
       } 
        intYPos ++;
        if(intYPos >= 40)
       {
            objPrinter.NewPage();
            intYPos = 0;
       } 
  }  
  objPrinter.EndDoc();
}

function PrintSingleCard(objCurrentMR, objCurrentPatient)
{
//    var objPrinter = document.getElementById("clsPrinter");
//   if(objPrinter == null)
	    objPrinter = new ActiveXObject("DHCMedWebPackage.clsPrinter"); 
	var objArry = GetDHCWMRMainVolumeArryByMainID(
		"MethodGetDHCWMRMainVolumeArryByMainID", objCurrentMR.RowID);
	var objVolume = objArry[0];
	var objAdm = null;
	if(objVolume != null)
	{
		if(objVolume.Paadm_Dr != "")
		{
			objAdm = GetPatientAdmitInfo("MethodGetPatientAdmitInfo", objVolume.Paadm_Dr);
			objCurrentPatient.Volume = ConvertAdm(objAdm);
		}
		else
		{
			objAdm = GetDHCWMRHistoryAdm("MethodGetDHCWMRHistoryAdm", objVolume.HistroyAdm_Dr);
			objCurrentPatient.Volume = ConvertHisAdm(objAdm);
		}
	}
	PrintCard(objPrinter, objCurrentPatient, objCurrentMR);
	objPrinter.EndDoc();
}

///Hide Admit Success Row
function HideAdmitSuccess()
{
	var objTable = document.getElementById("tDHC_WMR_PrintCard_List");
	var strMrNo = "";
	for(var i = objTable.rows.length - 1; i > 0; i --)
	{
		strMrNo = getElementValue("MrNOz" + i);
		if(Trim(strMrNo) != "")
			objTable.deleteRow(i);
	}
}

function cmdPrintAllCardOnClick()
{
  var objPatient = null;
  var objMr = null;
  var strMainID = "";
  var objTable = document.getElementById("tDHC_WMR_PrintCard_List"); 
  var intCounter  = 0;
  for(var i = 1; i < objTable.rows.length; i ++)
  {
        strMainID = getElementValue("RowIDz" + i); 
       if(!getElementValue("NeedPrintz" + i)) 
        continue;
       if(strMainID == "")
        continue;
       	objPatient = GetPatientInfoByMrRowID("MethodGetPatientInfoByMrRowID", strMainID );
	    objMr = GetDHCWMRMainByID("MethodGetDHCWMRMainByID", strMainID);
	    PrintSingleCard(objMr, objPatient);
	   intCounter ++; 
  }  
  window.alert(t["PrintCount"].replace("*", intCounter));
}

function cmdPrintOnClick()
{
    PrintReport();
}


function cmdAdmitPatientOnClick()
{
    var strRowID = window.event.srcElement.id.replace("cmdAdmitPatientz", "");
    var strPapmiID = getElementValue("Papmiz" + strRowID);
    var strPadmID = getElementValue("Paadmz" + strRowID);
    var strMrType =  GetParam(window, "MRTypeDr");
    var strUrl = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.AdmitPatient.Main&PatientID=" + strPapmiID + 
                        "&EpisodeID=" + strPadmID +
                        "&MrType="  + strMrType;
    window.open(strUrl, "_blank", "top=100,left=100,height=600,width=800,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=yes"); 
}




function InitForm()
{
//    var strPrinter = GetVBPrinterObjectString("MethodGetVBPrinterObjectString" );
//   document.write(strPrinter); 
    MarkFirstVisit();
    MakeComboBox("cboFilter");
   AddListItem("cboFilter" , tmpChinese[4], "0");
   AddListItem("cboFilter" , tmpChinese[5], "1");
   AddListItem("cboFilter" , tmpChinese[6], "2");
   setElementValue("cboFilter", "0");
    cboFilterOnChange(); 
    if(GetParam(parent, "HideAdmit") == "1")
    {
    	SetControlVisitable("cmdPrintAllCard", false);
    	SetControlVisitable("cmdPrint", false);
    	SetControlVisitable("cmdSelectAll", false);
    	SetControlVisitable("cmdSelectNone", false);
    	SetControlVisitable("cboFilter", false);
    	HideAdmitSuccess();
    }
    else
    {
	 SetControlVisitable("cmdHideAdmit", false);
	 SetControlVisitable("txtQueryDate", false);
    }
}

function InitEvents()
{
    document.getElementById("cboFilter").onchange = cboFilterOnChange;
    document.getElementById("cmdSelectAll").onclick =  cmdSelectAllOnClick;
    document.getElementById("cmdSelectNone").onclick = cmdSelectNoneOnClick;
   	document.getElementById("cmdPrint").onclick = cmdPrintOnClick; 
    document.getElementById("cmdPrintAllCard").onclick = cmdPrintAllCardOnClick;	
    document.getElementById("cmdHideAdmit").onclick = HideAdmitSuccess;
   var objTable = document.getElementById("tDHC_WMR_PrintCard_List"); 
    for(var i = 1; i < objTable.rows.length; i ++)
    {
        document.getElementById("cmdAdmitPatientz" + i).onclick =  cmdAdmitPatientOnClick;
    }   
}

InitForm();
InitEvents();