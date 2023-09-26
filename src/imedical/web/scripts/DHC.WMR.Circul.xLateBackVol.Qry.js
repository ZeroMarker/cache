function InitForm()
{
	DisplayMrType();
	InitEvent();
}

function InitEvent()
{
	var obj=document.getElementById("txtLocDesc");
	if (obj) {obj.onchange=txtLocDesc_onchange;}
	var obj=document.getElementById("txtWardDesc");
	if (obj) {obj.onchange=txtWardDesc_onchange;}
	var obj=document.getElementById("btnQuery");
	if (obj) {obj.onclick=btnQuery_onclick;}
}

function btnQuery_onclick()
{
	var MrType=getElementValue("txtMrTypeId");
	var ItemId=GetParam(window,"ItemId");
	var CDays=GetParam(window,"CDays");
	var DDays=GetParam(window,"DDays");
	var Loc=getElementValue("txtLocId");
	var Ward=getElementValue("txtWardId");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.Circul.xLateBackVol.List"+"&MrType=" +MrType+ "&ItemId=" +ItemId+ "&CDays=" +CDays+ "&DDays=" +DDays+ "&cLoc=" + Loc + "&cWard=" + Ward;
	parent.RPbot.location.href=lnk;
}

function DisplayMrType()
{
	var DicRowid = GetParam(window,"MrType");
	var strMethod = document.getElementById("MethodGetDicById").value;
	var ret = cspRunServerMethod(strMethod,DicRowid);
	var tmpList=ret.split("^");
	if (tmpList.length>=2)
	{
		document.getElementById("txtMrTypeId").value=tmpList[0];
		document.getElementById("txtMrTypeDesc").value=tmpList[2];
	}
}

function txtLocDesc_onchange()
{
	if (document.getElementById("txtLocDesc").innerText=="")
	{
		var obj=document.getElementById("txtLocId");
		if (obj){obj.value="";}
	}
}

function txtWardDesc_onchange()
{
	if (document.getElementById("txtWardDesc").innerText=="")
	{
		var obj=document.getElementById("txtWardId");
		if (obj){obj.value="";}
	}
}

function LookUpLoc(str)
{
	var tmpLoc=str.split("^");
	var obj=document.getElementById("txtLocId");
	if (obj){
		if (tmpLoc.length>=0){
			obj.value=tmpLoc[0];
		}else{
			obj.value="";
		}
	}
	var obj=document.getElementById("txtLocDesc");
	if (obj){
		if (tmpLoc.length>=1){
			obj.value=tmpLoc[1];
		}else{
			obj.value="";
		}
	}
}

function LookUpWard(str)
{
	var tmpWard=str.split("^");
	var obj=document.getElementById("txtWardId");
	if (obj){
		if (tmpWard.length>=0){
			obj.value=tmpWard[0];
		}else{
			obj.value="";
		}
	}
	var obj=document.getElementById("txtWardDesc");
	if (obj){
		if (tmpWard.length>=1){
			obj.value=tmpWard[1];
		}else{
			obj.value="";
		}
	}
}

InitForm();