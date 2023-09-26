function BodyLoadHandler() 
{
	InitUserInfo();	
	//SetBAddType();
	KeyUp("ExObj^RequestLoc");
	Muilt_LookUp("ExObj^RequestLoc");
	SetStatus();
	var obj=document.getElementById("BAdd");
	if(obj) obj.onclick=BAdd_Clicked;
	var obj=document.getElementById("BAddNew");
	if(obj) obj.onclick=BAddNew_Clicked;
	SetBEnable()
	//SetBackGroupColor('tDHCEQMMaintRequestFind')	//Add By DJ 2015-08-17 DJ0156
	var NewFlag=GetElementValue("NewFlag")
	if (NewFlag=="1")
	{
		HiddenObj("Status",1)
		HiddenObj("cStatus",1)
	}
}

function BAddNew_Clicked()
{
	//var obj=document.getElementById("Add");
	//if (obj.value==1) return;
	window.location.href= "dhceqmmaintrequest.csp?RowID=&Status=0&ExObjDR=&QXType="+GetElementValue("QXType");
}
function SetBAddType()
{
	//var obj=document.getElementById("Add");
	//if (obj.value==1) {DisableBElement("BAdd",true);}
}
function GetRequestLocDR(value)
{
	GetLookUpID('RequestLocDR',value);
}
function GetExObj(value)
{
	GetLookUpID('ExObjDR',value);
	//alertShow(value);
}
//function GetModel(value)
//{
//	GetLookUpID('ModelDR',value);
//}
function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatus"))
}

function SetBEnable()
{
	var WaitAD=GetElementValue("WaitAD");
	if (WaitAD!="off")
	{
		DisableBElement("BAddNew",true);
	}
}
document.body.onload = BodyLoadHandler;