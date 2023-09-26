/* =========================================================================

JavaScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.ValidateUser.js

AUTHOR: LiYang , Microsoft
DATE  : 2007-4-18

COMMENT: event handler of DHC.WMR.ValidateUser

============================================================================ */

function ValidateContents()
{
	if(Trim(getElementValue("txtUserName")) == "")
	{
		window.alert(t["InputUserName"]);
		return false;
	}
	if(Trim(getElementValue("txtPassword")) == "")
	{
		window.alert(t["InputPassword"]);
		return false;
	}
	return true;
}

function cmdCancelOnClick()
{
	window.returnValue = null;
	window.close();
}

function cmdOKOnClick()
{
	var objCurrentUser = null;
	if(!ValidateContents())
	{
		return;
	}
	objCurrentUser = VerifyUser("MethodVerifyUser", 
		getElementValue("txtUserName"),
		getElementValue("txtPassword"));
	if(objCurrentUser == null)
	{
		window.alert(t["LoginError"]);
		return;
	}

	window.returnValue = GetFullUserInfo("MethodGetUserByID", objCurrentUser.RowID);
	
	window.close();
}

function GetUser()
{
	var str = getElementValue("txtUserName");
	var objUser = null;
	if(str.length != 7) //barcode code length:7
		return null;
	if(str.charAt(0) != "U")//user barcode start with "U"
		return null;
	var UserID = new Number(str.substr(1));
	objUser = GetFullUserInfo("MethodGetUserByID", UserID.toString());
	return objUser;	
}

function txtUserNameOnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	var objUser = GetUser();
	if(objUser == null)
	{
		document.getElementById("txtPassword").focus();
	}
	else
	{
		window.returnValue = objUser;
		window.close();
	}

}

function InitForm()
{
	document.title = GetParam(window, "Title");
}

function SetFocus()
{
	document.getElementById("txtUserName").focus();
}

function InitEvents()
{
	document.getElementById("cmdOK").onclick = cmdOKOnClick;
	document.getElementById("cmdCancel").onclick = cmdCancelOnClick;
	document.getElementById("txtUserName").onkeydown = txtUserNameOnKeyDown;
	window.onload = SetFocus;
	
}


InitForm();
InitEvents();
