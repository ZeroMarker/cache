function BodyLoadHandler() 
{
	InitUserInfo()	
	var Type=GetElementValue("Type")
	if (Type=="SelectTree")
	{
		var CatsID=GetElementValue("CatsID")
		FindNodeByIds(CatsID);
	}
	//add by csj 2020-09-15 分类树hisui改造
	$("#treeviewarea").html("<ul id='tDHCEQCTreeMap' data-options='animate:true'></ul>")
	initTree()
	
}
//add by csj 2020-09-15 分类树hisui改造
function initTree()
{
	var EquipeCatTree =tkMakeServerCall("web.DHCEQ.Plat.LIBTree","GetTreeMapStr")
	$('#tDHCEQCTreeMap').tree({
		data:JSON.parse(EquipeCatTree),
		onClick: function (node) {
			NodeClickHandler(node)
		},
		lines:true,
	})
}

//// MZY0094	2083132,2083148		2021-09-13 分类树hisui改造
function NodeClickHandler(nod)
{
	var Type=GetElementValue("Type")
	if (Type=="DHCEQCTreeMap"||Type=="")
	{
		var lnk='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCTreeMapEdit&Type=1&ParTreeDR='+nod.id;
		if ('function'==typeof websys_getMWToken){
			lnk += "&MWToken="+websys_getMWToken()
		}
		parent.frames["DHCEQCTreeMapEdit"].location.href=lnk;
	}
	if (Type=="DHCEQCTreeMapEdit")
	{
		var NodID=nod.id
		if (NodID=="0") NodID=""
		var lnk='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCTreeMapEdit&Data=^IsDisused=N^IsOut=N^EquipCatDR='+NodID+"^IncludeFlag=1&ReadOnly=1";
		if ('function'==typeof websys_getMWToken){
			lnk += "&MWToken="+websys_getMWToken()
		}
		parent.frames["DHCEQCTreeMapEdit"].location.href=lnk;
	}
	if (Type=="SelectTree")
	{
		if (nod.id>0)
		{
			websys_showModal("options").mth(nod.id,nod.text);  
			closeWindow("modal")
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
