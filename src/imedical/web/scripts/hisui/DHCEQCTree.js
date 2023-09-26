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
	/*messageShow("","","",nod.IsLast);
	messageShow("","","",nod.Parent);
	messageShow("","","",nod.ID);*/
	//ReloadNode(nod.ID);
	var Type=GetElementValue("Type")
	if (Type=="DHCEQCTree"||Type=="")
	{
		parent.frames["DHCEQCTreeEdit"].location.href='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCTreeEdit&ParTreeDR='+nod.ID+'&TreeType='+GetElementValue("TreeType"); //modified by kdf 2018-10-18 hisui-¸ÄÔì
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