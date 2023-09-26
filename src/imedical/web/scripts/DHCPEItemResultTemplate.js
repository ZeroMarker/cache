///Create by MLH

function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	obj=document.getElementById("GetTemplate");
	if (obj){ obj.onclick=GetTemplate_click; }
}

function Update_Click()	{
	
}

function GetTemplate_click()	{
	var GetTemplateMothod=document.getElementById("GetTemplateBox");
	var ODSID="2||1||6";
	
	if (GetTemplateMothod) {var encmeth=GetTemplateMothod.value} else {var encmeth=''}
	var GetTemplate=cspRunServerMethod(encmeth,ODSID);
	//if (GetTemplateCode=='0') {alert(t['UpdateFailure']);}
	//else  {alert(t['UpdateSuccessful']);}
	var obj=document.getElementById("Target");
	obj.value=GetTemplate;
	return false;
}

document.body.onload = BodyLoadHandler;

