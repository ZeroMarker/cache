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
	/*alertShow(nod.IsLast);
	alertShow(nod.Parent);
	alertShow(nod.ID);*/
	//ReloadNode(nod.ID);
	var Type=GetElementValue("Type")
	if (Type=="DHCEQCEquipeCat"||Type=="")
	{
		parent.frames["DHCEQCEquipCat"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCEquipeCat&VarParCatDR='+nod.ID;
	}
	if (Type=="DHCEQEquipList")
	{
		var NodID=nod.ID
		if (NodID=="0") NodID=""
		parent.frames["DHCEQEquipList"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquipList&Data=^IsDisused=N^IsOut=N^EquipCatDR='+NodID+"^IncludeFlag=1"+"&ReadOnly=1";
	}
	if (Type=="SelectTree")
	{
		if (nod.ID>0)
		{
			opener.SetEquipCat(nod.ID,nod.Text);
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