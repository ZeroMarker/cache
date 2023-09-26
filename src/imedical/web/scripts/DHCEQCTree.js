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
	if (Type=="DHCEQCTree"||Type=="")
	{
		parent.frames["DHCEQCTreeEdit"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCTreeEdit&ParTreeDR='+nod.ID+'&TreeType='+GetElementValue("TreeType");
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