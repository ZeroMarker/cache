function BodyLoadHandler() 
{
	InitPage();
}
///��ʼ��ҳ��
function InitPage()
{
	//document.body.scroll="no";
	KeyUp("Equip^Loc^ToLoc","N")
	Muilt_LookUp("Equip^Loc^ToLoc");
	
	var obj=document.getElementById("BExecute");
	if (obj) obj.onclick=BExecute_Click;
	
	var obj=document.getElementById("SelectAll");
	if (obj) obj.onclick=SelectAll_Clicked;
	
	RemoveInvalidChk();
}
function RemoveInvalidChk()
{
	var Objtbl=document.getElementById("tDHCEQAdjustDepreFee");
	var Rows=Objtbl.rows.length;
	//alertShow(Rows)
	for (var i=1;i<Rows;i++)
	{
		if (document.getElementById("TRowIDz"+i).value=="") EQCommon_HiddenElement("TChkz"+i);
	}
}
function SelectAll_Clicked()
{
	var obj=document.getElementById("SelectAll");
	var Objtbl=document.getElementById("tDHCEQAdjustDepreFee");
	var Rows=Objtbl.rows.length;
	//alertShow(Rows)
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById("TChkz"+i);
		if (document.getElementById("TRowIDz"+i).value>0) document.getElementById("TChkz"+i).checked=obj.checked;
	}
}
function BExecute_Click()
{
	if (CheckItemNull(1,"ToLoc")) return;
	var tmpRowIDs="";
	var objtbl=document.getElementById("tDHCEQAdjustDepreFee");
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++)
	{
		var id=GetElementValue("TRowIDz"+i);
		var TChk=GetChkElementValue("TChkz"+i);
		if ((TChk)&&(id>0))
		{
			if (tmpRowIDs!="") tmpRowIDs=tmpRowIDs+"^";
			tmpRowIDs=tmpRowIDs+id;
		}
	}
	if (tmpRowIDs=="")
	{
		alertShow("δѡ����Чִ����.");
		return;
	}
	var encmeth=GetElementValue("ExecuteAdjustData");
	if (encmeth=="") return;
	var ReturnValue=cspRunServerMethod(encmeth,tmpRowIDs,GetElementValue("ToLocDR"));
	if (ReturnValue=="0")
    {
	    alertShow("ִ�гɹ�.");
		window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAdjustDepreFee&Equip="+GetElementValue("Equip")+"&EquipDR="+GetElementValue("EquipDR")+"&ToLoc="+GetElementValue("ToLoc")+"&ToLocDR="+GetElementValue("ToLocDR");
	}
    else
    {
	    alertShow(ReturnValue+"   ����ʧ��!");
    }
}
function GetEquip(value)
{
    GetLookUpID("EquipDR",value);
}
function GetLoc(value)
{
    GetLookUpID("LocDR",value);
}
function GetToLoc(value)
{
    GetLookUpID("ToLocDR",value);
}
document.body.onload = BodyLoadHandler;