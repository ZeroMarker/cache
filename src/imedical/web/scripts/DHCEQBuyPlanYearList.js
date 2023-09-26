
function BodyLoadHandler(){		
	InitPage();
}

function InitPage()
{
	KeyUp("RequestLoc");
	Muilt_LookUp("RequestLoc");
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Clicked;
}
function BAdd_Clicked()
{
	var j=0
	var ValueRowList=""
	var objtbl=document.getElementById('tDHCEQBuyPlanYearList');
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++)
	{
		var obj=document.getElementById('TRefuseFlagz'+i);
		if (obj.checked)
		{
			j=j+1
			ValueRowList=ValueRowList+GetElementValue('TRowIDz'+i)+"^"
		}
	}
	if (j==0)
	{
		alertShow(t['01']);
		return;
	}
	var encmeth=GetElementValue("updDetail");
	var YearDealPlanDR=GetElementValue("YearDealDR");
	var Return=cspRunServerMethod(encmeth,YearDealPlanDR,ValueRowList,j,"1")
	if (Return=='0')
	{
		opener.location.reload();
		window.location.reload();
	}
	else
	{
		alertShow(Return+t['02']);
	}
}
function GetRequestLoc (value)
{
    GetLookUpID("RequestLocDR",value);
}

document.body.onload = BodyLoadHandler;