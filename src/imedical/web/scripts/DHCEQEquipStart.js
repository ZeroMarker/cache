var SelectedRow = 0;

function BodyLoadHandler() 
{
	InitPage();
	disabled(false)
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
		val=val+"&StartFlag="+GetElementValue("StartFlag")
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquipStart'+val;
		if (parent.opener.opener)
		{
			parent.opener.opener.location.reload();
		}
		else if (parent.opener)
		{
			parent.opener.location.reload();
		}
	}
	else
	{
		alertShow(rtn)
	}
}

function disabled(value)//»Ò»¯
{
	InitPage();
	var ReadOnly=GetElementValue("ReadOnly")
	if (ReadOnly=="1") value=true
	var StartFlag=GetElementValue("StartFlag")
	var FromStatusDR=GetElementValue("FromStatusDR")
	if (StartFlag=="Y")
	{
		if (FromStatusDR!=2) value=true
	}
	DisableBElement("BSave",value)
}	
document.body.onload = BodyLoadHandler;
