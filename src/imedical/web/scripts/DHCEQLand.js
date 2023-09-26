var SelectedRow = 0;
var rowid=0;

function BodyLoadHandler() 
{	
	InitUserInfo();
	InitStandardKeyUp();
	InitButton();
	if (1==GetElementValue("ReadOnly"))
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
	}
	FillData();
}

function InitButton()
{
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
	
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;	
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;	
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
}

function FillData()
{
	var EquipDR=GetElementValue("EquipDR");
	if (EquipDR!="")
	{
		SetData("",EquipDR);
	}
}

function BAdd_Click() 
{
	var obj=document.getElementById("BAdd");
	if ((!obj)||(obj.disabled)) return;
	SaveData();
	/*
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAffix&EquipDR=1';
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
    */
}

function BUpdate_Click() 
{
	var obj=document.getElementById("BUpdate");
	if ((!obj)||(obj.disabled)) return;
	SaveData();
}

function BClose_Click() 
{
	window.close();
}


//////******************
//////******************


function InitStandardKeyUp()
{
	var obj=document.getElementById("Equip");
	if (obj) obj.onkeyup=Standard_KeyUp;
}
function Clear()
{
	///SetElement("RowID","");
	///SetElement("Equip","");
	///SetElement("EquipDR","");
	SetElement("Area","");
	SetElement("LandNo","");
	SetChkElement("OwnerFlag",0);
	SetElement("Place","");
	SetElement("SelfUsedArea","");
	SetElement("IdleArea","");
	SetElement("LendingArea","");
	SetElement("RentArea","");
	SetElement("WorkArea","");
	SetElement("OtherArea","");
	SetElement("LendCompany","");
	SetElement("RentCompany","");
	SetElement("OwnerCertificate","");
	SetElement("CertificateNo","");
	SetElement("CertificateDate","");
	SetElement("OwnerKind","");
	SetElement("CertificateArea","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
}


function BDelete_Click() 
{
	var obj=document.getElementById("BDelete");
	if ((!obj)||(obj.disabled)) return;
	
	var rowid=GetElementValue("RowID");
	if (rowid=="")	{
		alertShow(t['-3002']);
		return;
	}
	var truthBeTold = window.confirm(t['-3001']);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,Guser,'1');
	if (result>0)
	{	location.reload();	}
}


function CombinData()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+GetElementValue("Area") ;
  	combindata=combindata+"^"+GetElementValue("LandNo") ;
  	combindata=combindata+"^"+GetChkElementValue("OwnerFlag") ;
  	combindata=combindata+"^"+GetElementValue("Place") ;
  	combindata=combindata+"^"+GetElementValue("SelfUsedArea") ;
  	combindata=combindata+"^"+GetElementValue("IdleArea") ;
  	combindata=combindata+"^"+GetElementValue("LendingArea") ;
  	combindata=combindata+"^"+GetElementValue("RentArea") ;
  	combindata=combindata+"^"+GetElementValue("WorkArea") ;
  	combindata=combindata+"^"+GetElementValue("OtherArea") ;
  	combindata=combindata+"^"+GetElementValue("LendCompany") ;
  	combindata=combindata+"^"+GetElementValue("RentCompany") ;
  	combindata=combindata+"^"+GetElementValue("OwnerCertificate") ;
  	combindata=combindata+"^"+GetElementValue("CertificateNo") ;
  	combindata=combindata+"^"+GetElementValue("CertificateDate") ;
  	combindata=combindata+"^"+GetElementValue("OwnerKind") ;
  	combindata=combindata+"^"+GetElementValue("CertificateArea") ;
  	combindata=combindata+"^"+GetElementValue("Hold1") ;
  	combindata=combindata+"^"+GetElementValue("Hold2") ;
  	combindata=combindata+"^"+GetElementValue("Hold3") ;
  	combindata=combindata+"^"+GetElementValue("Hold4") ;
  	combindata=combindata+"^"+GetElementValue("Hold5") ;
  	return combindata;
}

function SaveData()
{
	if (CheckMustItemNull()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var plist=CombinData();
	var result=cspRunServerMethod(encmeth,'','',plist,Guser,'0');
	if (result>0)
	{	location.reload();	}
	else
	{	alertShow(t[result]);}
}

function SetData(rowid,equipdr)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var gbldata=cspRunServerMethod(encmeth,'','',rowid,equipdr);
	if (gbldata=="") 
	{		
		return;
	}
	var list=gbldata.split("^");
	var sort=23
	SetElement("EquipDR",list[0]);
	SetElement("Equip",list[sort+0]);
	SetElement("Area",list[1]);
	SetElement("LandNo",list[2]);
	SetChkElement("OwnerFlag",list[3]);
	SetElement("Place",list[4]);
	SetElement("SelfUsedArea",list[5]);
	SetElement("IdleArea",list[6]);
	SetElement("LendingArea",list[7]);
	SetElement("RentArea",list[8]);
	SetElement("WorkArea",list[9]);
	SetElement("OtherArea",list[10]);
	SetElement("LendCompany",list[11]);
	SetElement("RentCompany",list[12]);
	SetElement("OwnerCertificate",list[13]);
	SetElement("CertificateNo",list[14]);
	SetElement("CertificateDate",list[15]);
	SetElement("OwnerKind",list[16]);
	SetElement("CertificateArea",list[17]);
	SetElement("Hold1",list[18]);
	SetElement("Hold2",list[19]);
	SetElement("Hold3",list[20]);
	SetElement("Hold4",list[21]);
	SetElement("Hold5",list[22]);
}


document.body.onload = BodyLoadHandler;
