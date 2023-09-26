function BodyLoadHandler() 
{
	InitUserInfo()	
	var Type=GetElementValue("Type")
	if (Type=="SelectTree")
	{
		var CatsID=GetElementValue("CatsID")
		FindNodeByIds(CatsID);
	}
}

function NodeClickHandler(nod)
{
	var Type=GetElementValue("Type")
	if (Type=="DHCEQCTreeMap"||Type=="")
	{
		var ParType=""
		if (nod.ID!=0)
		{
			var obj=document.getElementById("fillData");
			if (obj){var encmeth=obj.value} else {var encmeth=""};
			var ReturnList=cspRunServerMethod(encmeth,nod.ID);
			ReturnList=ReturnList.replace(/\\n/g,"\n");
			list=ReturnList.split("^");
			var ParType=list[1]
		}
		parent.frames["DHCEQCTreeMapEdit"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCTreeMapEdit&ParTreeDR='+nod.ID+'&Type='+ParType;
	}
	if (Type=="SelectTree")
	{
		if (nod.ID>0)
		{
			opener.SetTreeDR(nod.ID,nod.Text);
			window.close();
		}
	}
}
function GetEncmeth()
{
	return GetElementValue("GetTreeNotes");
}

function GetNodeIDsEncmeth()
{
	return GetElementValue("GetTreeNodeIDs");
}

function GetNodeEncmeth()
{
	return GetElementValue("GetTreeNode");
}


document.body.onload = BodyLoadHandler;