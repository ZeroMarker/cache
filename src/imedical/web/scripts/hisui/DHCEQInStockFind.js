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
	initButtonWidth()  //hisui改造 add by zy 2018-10-31
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

///modified by zy 20180930  ZY0170
function BAddNew_Click() //GR0026 点击新增后新窗口打开模态窗口
{
	var Status=GetElementValue("Status");
	var WaitAD=GetElementValue("WaitAD"); 
	var QXType=GetElementValue("QXType");
	var flag=GetElementValue("flag");
	var val="&Status="+Status+"&WaitAD="+WaitAD+"&QXType="+QXType+"&flag="+flag;
	//url="dhceqinstocknew.csp?&DHCEQMWindow=1"+val
	url="dhceq.em.instock.csp?"+val
	///modefied by zy 20190111 ZY0184
	//websys_lu(url,false,'width=1080,height=650,left=130,top=3,hisui=true')
	//SetWindowSize(url,1,'','','','','入库单');
	
	showWindow(url,"入库单","","","icon-w-paper","modal","","","large")	//modified by lmm 2020-06-04 UI
	
}
document.body.onload = BodyLoadHandler;