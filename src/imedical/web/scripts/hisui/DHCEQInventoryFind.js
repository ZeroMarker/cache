//add by zy 2015-08-25 ZY0136
function BodyLoadHandler() 
{
	InitUserInfo();	
	initButtonWidth(); //HISUI���� add by MWZ 2018-09-28
	setButtonText();	//HISUI���� add by MWZ 2018-09-28
	var StatusDR=GetElementValue("StatusDR");
	if (StatusDR>0)
	{
		HiddenObj("BNew",1)
		HiddenObj("BLocInventory",1)
	}
	var obj=document.getElementById("BLocInventory");
	if (obj) obj.onclick=BLocInventory_Click;
	KeyUp("Hospital","N")  //add by mwz 2020-04-27  MWZ0036
	Muilt_LookUp("Hospital");  //add by mwz 2020-04-27  MWZ0036
}
function BLocInventory_Click()
{
	var truthBeTold = window.confirm("ȷ���������������п����̵㵥?");
	if (truthBeTold)
	{
		var encmeth=GetElementValue("UpdLocInventroy");
		if (encmeth=="") return
		var result=cspRunServerMethod(encmeth);
		if (result!=0)
		{
			alertShow("����ʧ��!")
			return
		}
		else
		{
			alertShow("�������!")
			location.reload();
		}
	}
}
// Mozy0251	1099778		2020-3-2
function GetHospitalDR (value)
{
    GetLookUpID("HospitalDR",value);
}
document.body.onload = BodyLoadHandler;