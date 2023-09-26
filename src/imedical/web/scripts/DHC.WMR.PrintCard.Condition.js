/* =========================================================================

JavaScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.PrintCard.Condition.js

AUTHOR: LiYang , Microsoft
DATE  : 2007-6-19


============================================================================ */
var strMrType = "";
var strAdmType = ""; 
function QueryPatient(MrType, AdmitDate)
{
	var strUrl = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.PrintCard.List&ADMType=" + strAdmType + "&MRTypeDr="  + MrType +  "&AdmDate=" + encodeURI (AdmitDate);
	parent.frames[1].location.href = strUrl;
}


function cmdDisplay()
{
	QueryPatient(strMrType, getElementValue("txtAdmitDate"));
}

function cmdPrintSingleOnClick()
{
    var strMrNO = window.prompt(t["InputMrNO"], "");
   if((strMrNO == null) || (strMrNO == ""))
        return;
   var objMain = GetDHCWMRMainByMrNo("MethodGetDHCWMRMainByMrNo", strMrType, strMrNO, "Y");
   if(objMain != null)
  {
        window.open("websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.PrintSingleCard&MainID=" + objMain.RowID,
                    "_blank", "height=400,width=450,left=300,top=150" );
   }
  else
  {
        window.alert(t["NotFoundMr"]);
  }  
}


function initForm()
{
	strMrType = GetParam(parent, "MrType");
	strAdmType = GetParam(parent, "ADMType");
	var objMrType = null;
	if(strMrType == "")
	{
		window.alert("Medical Record Type Error!!!!!!!");
		return;
	}
	objMrType = GetDHCWMRDictionaryByID("MethodGetDictionaryByID", strMrType);
	setElementValue("txtMrType", objMrType.Description);
	
}

function initEvevts()
{
	document.getElementById("cmdDisplay").onclick = cmdDisplay;
	document.getElementById("cmdPrintSingle").onclick = cmdPrintSingleOnClick;
}

initForm();
initEvevts();