
function BodyLoadHandler()
{
	SetElement("SourceType",GetElementValue("SourceTypeDR"))
	InitPage();
}
function InitPage()
{
	var obj=document.getElementById("ld"+GetElementValue("GetComponentID")+"iSourceID");
	if (obj) obj.onclick=BSourceID_Click;
	
	var obj=document.getElementById("SourceType");
	if (obj) obj.onchange=SourceType_Click;
	if (GetElementValue("BussType")==2)
	{
		KeyUp("Name^MaintLoc^SourceID","N");
		Muilt_LookUp("Name^MaintLoc^SourceID","N");
	}
	else
	{
		KeyUp("Name^MaintType^MaintLoc^SourceID","N");
		Muilt_LookUp("Name^MaintType^MaintLoc^SourceID","N");
	}
}

function BSourceID_Click()
{	
	var value=GetElementValue("SourceType")
	if (value=="1") //1:设备分类 
	{
		var CatName=GetElementValue("SourceID")
		var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCEquipCatTree&Type=SelectTree&CatName="+CatName;
    	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
	}else if (value=="2") //2:设备项 
	{
		LookUp("","web.DHCEQCMasterItem:GetMasterItem","GetSourceID",",,SourceID");
	}else if (value=="3") //3:设备
	{
		LookUp("","web.DHCEQEquip:GetShortEquip","GetSourceID","SourceID");		
	}
}
function SourceType_Click()
{
	SetElement("SourceTypeDR",GetElementValue("SourceType"))
	SetElement('SourceID',"");
	SetElement('SourceIDDR',"");
}
function GetSourceID(value) 
{
	var list=value.split("^")
	SetElement('SourceID',list[0]);
	SetElement('SourceIDDR',list[1]);
}

function GetNameID(value)
{
	GetLookUpID('NameDR',value);
}
function GetMaintType(value)
{
	GetLookUpID('MaintTypeDR',value);
}
function GetMaintLoc(value)
{
	GetLookUpID('MaintLocDR',value);
}
function SetEquipCat(id,text)
{
	SetElement('SourceID',text);
	SetElement('SourceIDDR',id);
}
document.body.onload = BodyLoadHandler;