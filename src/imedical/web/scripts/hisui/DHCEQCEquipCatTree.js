function BodyLoadHandler() 
{
	//modified by cjt 20230212 需求号3221875 UI页面改造
	initPanelHeaderStyle();
	initButtonColor();
	InitUserInfo()	
	var Type=GetElementValue("Type")
	if (Type=="SelectTree")
	{
		var CatsID=GetElementValue("CatsID")
		FindNodeByIds(CatsID);
	}
	//add by csj 2020-09-15 分类树hisui改造
	$("#treeviewarea").html("<ul id='tDHCEQCEquipCatTree' data-options='animate:true'></ul>")
	initTree();
	
	//add by czf 2021-04-28 1836939 设备分类搜索框响应 
	$('#EquipCatSearch').searchbox({ 
		searcher:function () {  
			var SearchContent = $("#EquipCatSearch").searchbox('getValue');
			$("#tDHCEQCEquipCatTree").tree("search", SearchContent); 
		}
	});
}
//add by csj 2020-09-15 分类树hisui改造
function initTree()
{
	//modified by czf 2021-02-25 begin
	//tkMakeServerCall或cspRunServerMethod()同步接收返回值，因字符流超长，转换字符串报错；改用ajax方式异步获取字符流
	//var EquipeCatTree =tkMakeServerCall("web.DHCEQ.Plat.LIBTree","GetEquipeCatTreeStr")
	//var encmeth=GetElementValue("GetEquipeCatTreeStr");
	//var EquipeCatTree=cspRunServerMethod(encmeth,"0");
	
	var EquipeCatTree=$.m({
	    ClassName:"web.DHCEQ.Plat.LIBTree",
	    MethodName:"GetEquipeCatTreeStr",
	},false);
	
	//modified by czf 2021-02-25 end
	
	$('#tDHCEQCEquipCatTree').tree({
		data:JSON.parse(EquipeCatTree),
		onClick: function (node) {
			NodeClickHandler(node)
		},
		lines:true,
	})
}
//modified by csj 2020-09-15 分类树hisui改造
function NodeClickHandler(nod)
{
	var Type=GetElementValue("Type")
	var lnk=""
	if (Type=="DHCEQCEquipeCat"||Type=="")
	{
		lnk='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCEquipeCat&VarParCatDR='+nod.id;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			lnk += "&MWToken="+websys_getMWToken()
		}
		parent.frames["DHCEQCEquipCat"].location.href=lnk
	}
	if (Type=="DHCEQEquipList")
	{
		var NodID=nod.id
		if (NodID=="0") NodID=""
		lnk='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQEquipList&Data=^IsDisused=N^IsOut=N^EquipCatDR='+NodID+"^IncludeFlag=1"+"&ReadOnly=1";
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			lnk += "&MWToken="+websys_getMWToken()
		}
		parent.frames["DHCEQEquipList"].location.href=lnk
	}
	if (Type=="SelectTree")
	{
		if (nod.id>0)
		{
			//modify by csj 20190601
			websys_showModal("options").mth(nod.id,nod.text);  
//			opener.SetEquipCat(nod.id,nod.text);
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