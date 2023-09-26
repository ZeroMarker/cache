// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//
// ab 23841 - 26.03.02 - check for blank aliases

function DocumentLoadHandler()
{
	var obj;
	obj=document.getElementById('update1')
	if (obj) obj.onclick=UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;

	obj=document.getElementById('SetDefault')
	if (obj) obj.onclick=SetDefaultHandler;

	return;
}

function UpdateClickHandler()
{
	/*var obj=document.getElementById('ALIASText');
	if (obj.value=="")
	{
		alert("Alias cannot be blank");
		obj.focus();
		return false;
	}
	else*/
		return update1_click();
}

function SetDefaultHandler()
{
	var obj=document.getElementById('ALIASText');
	if (obj.value=="")
	{
		alert("Alias cannot be blank");
		obj.focus();
		return false;
	}
	else
		return SetDefault_click();
}

document.body.onload=DocumentLoadHandler;