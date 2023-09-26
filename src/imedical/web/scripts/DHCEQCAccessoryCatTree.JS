/// -------------------------------
/// 创建:ZY  2009-08-31   BugNo.:ZY0011
/// 描述:配件分类维护
/// --------------------------------
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
	//alertShow(nod.IsLast+"^IsLast||"+nod.Parent+"^Parent||"+nod.Loaded+"^Loaded||"+nod.Layer+"^Layer||"+nod.HasChild+"^HasChild||"+nod.ID+"^ID||"+nod.Text+"^Link");
	var Type=GetElementValue("Type")
	if (Type=="DHCEQCAccessoryCat"||Type=="")
	{
		parent.frames["DHCEQCAccessoryCat"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCAccessoryCat&VarParCatDR='+nod.ID;
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

function GetNodeIDsEncmeth()
{
	return GetElementValue("GetTreeNodeIDs");
}

function GetNodeEncmeth()
{
	return GetElementValue("GetTreeNode");
}
document.body.onload = BodyLoadHandler;