///DHCEQDepreFind.js
var selectrow=0
var rowid=0

function BodyLoadHandler() 
{	
	InitUserInfo();
	InitPage();
	var objtbl=document.getElementById('tDHCEQDepreFind');
	var rows=objtbl.rows.length;
	if ((GetElementValue("TRowIDz1")<1))
	{
		DisableBElement("TNamez1",true);
	}
	var lastrowindex=rows - 1;
	if (lastrowindex>0)
	{
		if (GetElementValue("TRowIDz"+lastrowindex)<1)
		{
			DisableBElement("TNamez"+lastrowindex,true);
		}
	}	
	
}
function InitPage()
{	
	KeyUp("UseLoc^Name^BeginDate^EndDate^EquipType");
	Muilt_LookUp("UseLoc^Name^BeginDate^EndDate^EquipType");
	
}

function GetUseLoc(value)
{
	GetLookUpID("UseLocDR",value);
}
function GetEquipType(value)
{
	GetLookUpID("EquipTypeDR",value);
}

document.body.onload = BodyLoadHandler;
