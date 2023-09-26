/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.PrintUserBarCode.JS

AUTHOR: LiYang , Microsoft
DATE  : 2007-4-27

COMMENT: DHC.WMR.PrintUserBarCode event handler

========================================================================= */


//validate user/password, if passed return user info else return null
function ValidateUser(userName, Password)
{
	var objUser = null;
	objUser = VerifyUser("MethodValidateUser", userName, Password);
	return objUser;
}

function PrintUserBarCode(objUser)
{
	objPrinter = document.getElementById("clsWMRBarCode");
//	if(objPrinter == null)
	    objPrinter = new ActiveXObject("DHCMedWebPackage.clsWMRBarCode");
	objPrinter.BarCodeFontName = BarCodeFontName;//font name declareed in ataAccess.JS
	objPrinter.PrintUserBarCode(objUser.RowID, objUser.Code, objUser.UserName);
}

function cmdPrintOnClick()
{
	var objUser = ValidateUser(
		getElementValue("txtUserName"),
		getElementValue("txtPassword"));
	if(objUser != null)
	{
		PrintUserBarCode(objUser);
	}
	else
	{
		window.alert(t["UserValidateFail"]);
	}
	setElementValue("txtUserName", "");
	setElementValue("txtPassword", "");
}

function initForm()
{
//	var strObject = cspRunServerMethod(getElementValue("MethodBarCodeObject"));
//	document.write(strObject);
}

function initEvent()
{
	document.getElementById("cmdPrint").onclick = cmdPrintOnClick;
}
initForm();
initEvent();