jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
	
);
function initDocument()
{
	initPanel();
}
function initPanel()
{
	initTopPanel();		
}
//初始化查询头面板
function initTopPanel()
{
	initButton();
    initButtonWidth();
	initLookUp();
	defindTitleStyle();
	setRequiredElements("User^Group");
	initMessage("");
	FillData();
	
}
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	if (vElementID=="Group")
	{
		setElement("Group",item.TGroupName);
		setElement("GroupDR",item.TGroupID);
	}
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}
function CombineData()
{
	var val="";
	val=getElementValue("RowID");
	val+="^"+getElementValue("UserDR");
	val+="^"+getElementValue("GroupDR");
	val+="^"+getElementValue("RoleDR");
	val+="^"+GetCheckValue("EquipTypeFlag");
	val+="^"+GetCheckValue("StatCatFlag");
	val+="^"+GetCheckValue("EquipCatFlag");
	val+="^"+GetCheckValue("LocFlag");
	val+="^"+GetCheckValue("EquipFlag");
	val+="^"+GetCheckValue("ItemFlag");
	return val;
}
function GetCheckValue(checkName)
{
	return (jQuery("#" + checkName).is(':checked')==true)?"Y":"N";
}

function FillData()
{
	var RowID=getElementValue("RowID");
	if(RowID!="") {
		disableElement("BSave",true);
		var rowid=RowID
	}else {
		var rowid=getElementValue("MLLManageLimitDR");
	}
	var data = tkMakeServerCall("web.DHCEQ.Plat.CTManageLimit", "GetOneManageLimit", rowid);
	var list=data.split("^");
	if(RowID!=""){
		setElement("User",list[9]);
		setElement("UserDR",list[0]);
	}
	setElement("Group",list[10]);
	setElement("GroupDR",list[1]);
	setElement("Role",list[11]);
	setElement("RoleDR",list[2]);
	setElement("EquipTypeFlag",list[3]);
	setElement("StatCatFlag",list[4]);
	setElement("EquipCatFlag",list[5]);
	setElement("LocFlag",list[6]);
	setElement("EquipFlag",list[7]);
	setElement("ItemFlag",list[8]);
}


function BSave_Clicked()
{
	if (checkMustItemNull()) return;
	var data=CombineData();
	var result=tkMakeServerCall("web.DHCEQ.Plat.CTManageLimit","SaveManageLimit",data,'')
	if(result>0)
	{
		setElement("RowID",result);
		var MLLManageLimitDR=getElementValue("MLLManageLimitDR");
		var copyresult=tkMakeServerCall("web.DHCEQ.Plat.CTManageLimit","CopyManageLimitList",result,MLLManageLimitDR)
		if(copyresult>0) $.messager.popover({msg:"保存成功",type:'success'});
		else $.messager.popover({msg:"保存失败",type:'error'});
	}
	else  $.messager.popover({msg:"保存失败",type:'error'});
	var RowID=getElementValue("RowID");
	var MLLManageLimitDR=getElementValue("MLLManageLimitDR");
	var url="dhceq.plat.cmanagelimitmodify.csp?&RowID="+RowID+"&MLLManageLimitDR="+MLLManageLimitDR;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href= url;
	websys_showModal("options").mth(); 
}

