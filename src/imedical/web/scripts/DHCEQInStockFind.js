function BodyLoadHandler(){
	InitUserInfo();		
	InitPage();
	SetBEnable();
	SetStatus();
	Muilt_LookUp("BuyLoc^Loc");
	
	var CancelOper=GetElementValue("CancelOper")
	if (CancelOper=="Y")
	{
		SetElement("Status",2)
		DisableBElement("Status",true);
	}
}

function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatu"))
}
function InitPage()
{
	KeyUp("Loc^BuyLoc");
}
function GetLoc(value)
{
	GetLookUpID("LocDR",value);
}

function GetBuyLoc(value)
{
	GetLookUpID("BuyLocDR",value);
}

//modified by czf 2017-03-23
//解决入库审核界面新增按钮图标可点开新窗口的问题
function SetBEnable()
{
	var WaitAD=GetElementValue("WaitAD");
	if (WaitAD!="off")
	{
		DisableBElement("BAddNew",true);
	}
	else
	{
		var obj=document.getElementById("BAddNew");//GR0026 点击新增后新窗口打开模态窗口
		if (obj) obj.onclick=BAddNew_Click;
	}
}

function BAddNew_Click() //GR0026 点击新增后新窗口打开模态窗口
{
	var Status=GetElementValue("Status");
	var WaitAD=GetElementValue("WaitAD"); 
	var QXType=GetElementValue("QXType");
	var flag=GetElementValue("flag");
	var val="&Status="+Status+"&WaitAD="+WaitAD+"&QXType="+QXType+"&flag="+flag;
	url="dhceqinstocknew.csp?&DHCEQMWindow=1"+val
	var scrWidth = screen.availWidth; var scrHeight = screen.Height; 
	websys_createWindow(url,false,'width=980,height=730,left=130,top=3');
}

document.body.onload = BodyLoadHandler;