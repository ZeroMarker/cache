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
	if (Type=="DHCEQCEquipeCat"||Type=="")
	{
		parent.frames["DHCEQCEquipCat"].location.href='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCEquipeCat&VarParCatDR='+nod.ID;  //hisui改造 modify by lmm 2018-08-17
	}
	if (Type=="DHCEQEquipList")
	{
		var NodID=nod.ID
		if (NodID=="0") NodID=""
		parent.frames["DHCEQEquipList"].location.href='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQEquipList&Data=^IsDisused=N^IsOut=N^EquipCatDR='+NodID+"^IncludeFlag=1"+"&ReadOnly=1";  //hisui改造 modify by lmm 2018-08-17
	}
	if (Type=="SelectTree")
	{
		if (nod.ID>0)
		{
			//modify by csj 20190601
			websys_showModal("options").mth(nod.ID,nod.Text);  
//			opener.SetEquipCat(nod.ID,nod.Text);
			closeWindow("modal")
//			window.close();
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