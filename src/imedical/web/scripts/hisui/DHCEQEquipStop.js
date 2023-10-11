var SelectedRow = 0;

function BodyLoadHandler() 
{
	InitPage();
	disabled(false)
	initButtonWidth()  //hisui改造 add by lmm 2018-08-20 修改界面按钮长度不一致
	initPanelHeaderStyle();	// MZY0151	2023-02-01
	hidePanelTitle();
}
function InitPage()
{
	var obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_Clicked;
}
function BSave_Clicked()
{
	var EquipID=GetElementValue("EquipID")
  	if (EquipID=="") return;
	var ReadOnly=GetElementValue("ReadOnly")
	var combindata="";
	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("EquipID") ;
  	combindata=combindata+"^"+GetElementValue("GroupDR") ;
  	combindata=combindata+"^"+GetElementValue("ChangeTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("ChangeDate") ;
  	combindata=combindata+"^"+GetElementValue("SourceType") ;
  	combindata=combindata+"^"+GetElementValue("SourceID") ;
  	combindata=combindata+"^"+GetElementValue("Status") ;
  	combindata=combindata+"^"+GetElementValue("FromStatusDR") ;
  	combindata=combindata+"^"+GetElementValue("ToStatus") ;
  	combindata=combindata+"^"+GetElementValue("FromOther") ;
  	combindata=combindata+"^"+GetElementValue("ToOther") ;
  	combindata=combindata+"^"+GetElementValue("ApproveListDR") ;
  	combindata=combindata+"^"+GetElementValue("Reason") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	var encmeth=GetElementValue("SaveData")
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata,"2");
	if (rtn==0)
	{
		var val=""
		val="&EquipID="+EquipID;
		val=val+"&ReadOnly="+ReadOnly;
		val=val+"&StopFlag="+GetElementValue("StopFlag")
		window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQEquipStop'+val;   //hisui改造 add by lmm 2018-08-18 改调hisui默认csp
		websys_showModal("options").mth();  //modify by lmm 2019-02-20
	}
	else
	{
		messageShow("","","",rtn)
	}
}

function disabled(value)//灰化
{
	InitPage();
	var ReadOnly=GetElementValue("ReadOnly")
	if (ReadOnly=="1") value=true
	var StopFlag=GetElementValue("StopFlag")
	var FromStatusDR=GetElementValue("FromStatusDR")
	if (StopFlag=="Y")
	{
		if (FromStatusDR!=1) value=true
	}
	DisableBElement("BSave",value)
}	
document.body.onload = BodyLoadHandler;
