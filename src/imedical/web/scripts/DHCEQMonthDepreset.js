var SelectedRow = 0;
var rowid=0;
//计提折旧
function BodyLoadHandler() 
{	
	InitUserInfo();
	KeyUp("UseLoc^EquiCat");
	Muilt_LookUp("UseLoc^EquiCat");
	var obj=document.getElementById("Depre");
	if (obj) obj.onclick=Depre_Click;
	var obj=document.getElementById("Find");
	if (obj) obj.onclick=Find_Click;
	var obj=document.getElementById("Select");//全选
	if (obj) obj.onclick=Select_Click;
	var obj=document.getElementById("Selectf"); //反选
	if (obj) obj.onclick=Selectf_Click;
	SetChkEnabled();
	var obj=document.getElementById(GetLookupName("EquiCat"));
	if (obj) obj.onclick=EquiCat_Click;
}
function EquiCat_Click()
{
	var CatName=GetElementValue("EquiCat")
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCEquipCatTree&Type=SelectTree&CatName="+CatName;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
}

function SetEquipCat(id,text)
{
	SetElement("EquiCat",text);
	SetElement("EquiCatDR",id);
}

function SetChkEnabled()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQMonthDepreset');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++ )
	{
    	var MonthDepredobj=document.getElementById("TMonthDepredz"+i);
    	var DepreSetobj=document.getElementById("TDepreSetz"+i);
    	if (!((!MonthDepredobj.checked)&&(DepreSetobj.value=="Y")))
    	{
	    	DisableElement("TDeprez"+i,true);
    	}
	}
}
function Select_Click() 
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQMonthDepreset');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++ )
	{
		var obj=document.getElementById("TDeprez"+i)
		if (!obj.disabled)
		{
    		document.getElementById("TDeprez"+i).checked=true
		}
	}
}
function Selectf_Click() 
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQMonthDepreset');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++ )
	{
		var obj=document.getElementById("TDeprez"+i)
		if (!obj.disabled)
		{
			var Deprez=	document.getElementById("TDeprez"+i).checked;
	    	document.getElementById("TDeprez"+i).checked=!Deprez;
		}
	}
}
function Find_Click() 
{
	var DepreMonth=GetElementValue("DepreMonth")
	if (DepreMonth=="")
	{
		alertShow(t["02"]);
		return;
	}
	var IsVaild=MonthStrIsvalidation(DepreMonth)
	if (IsVaild=="0")
	{
		alertShow(t["01"]);
		return;
	}
	var UseLocDR=GetElementValue("UseLocDR")
	var UseLoc=GetElementValue("UseLoc")
	var EquiCatDR=GetElementValue("EquiCatDR")
	var EquiCat=GetElementValue("EquiCat")
	var DepreReady=GetChkElementValue("DepreReady")
	if(DepreReady==true)
	{
		DepreReady="1"
	}
	else
	{
		DepreReady="0"
	}
	window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMonthDepreset'
	+'&DepreMonth='+DepreMonth
	+'&DepreReady='+DepreReady
	+'&UseLocDR='+UseLocDR+'&UseLoc='+UseLoc
	+'&EquiCatDR='+EquiCatDR+'&EquiCat='+EquiCat

}
function MonthStrIsvalidation(DepreMonth)
{
	var encmeth=GetElementValue("MonthStrIsvalidation");
	return cspRunServerMethod(encmeth,DepreMonth)
}
function Depre_Click() 
{
	var DepreMonth=GetElementValue("DepreMonth")
	var IsVaild=MonthStrIsvalidation(DepreMonth)
	if (IsVaild=="0")
	{
		alertShow(t["01"]);
		return;
	}
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQMonthDepreset');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var Rows=""
	for (i=1;i<rows;i++)
	{
		rowid=GetElementValue("TRowIDz"+i);
		Depre=GetChkElementValue("TDeprez"+i)
		if (Depre=="true")
		{
			Rows=Rows+rowid+"^";
		}
	}
	if (Rows=="")
	{
		alertShow(t["03"]);
		return;
	}
	var Return=SetData(Rows,DepreMonth);
	if (Return=="0")
	{
		window.location.reload();
	}
	else
	{
		alertShow(Return+t["04"]);
	}
}
function SetData(Rows,DepreMonth)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,Rows,DepreMonth);
	return gbldata;
}
function GetEquipCat(value)
{
	GetLookUpID("EquiCatDR",value);
}
function GetUseLoc(value)
{
	GetLookUpID("UseLocDR",value);
}
document.body.onload = BodyLoadHandler;