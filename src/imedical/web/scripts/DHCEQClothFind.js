var SelectedRow=0;
var readonly;

function BodyLoadHandler() 
{
	InitPage();
	/*
	var objtbl=document.getElementById('tDHCEQClothFind');
	var rows=objtbl.rows.length;
	if ((GetElementValue("TRowIDz1")<1))
	{
		DisableBElement("TNamez1",true);
		alertShow(1);
	}
	var lastrowindex=rows - 1;
	if (lastrowindex>0)
	{
		if (GetElementValue("TRowIDz"+lastrowindex)<1)
		{
			DisableBElement("TNamez"+lastrowindex,true);
			
		}
	}
	
	*/
}

function InitPage()
{
	KeyUp("UseLoc^Item");
	Muilt_LookUp("UseLoc^Item");
	/*
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	//readonly=GetElementValue("ReadOnly");
	*/
}
/*
function BFind_Click()
{
	var val="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQClothFind";
	val=val+"&Data=";
	val="^UseLocDR="+GetElementValue("UseLocDR");
	val=val+"^StoreLocDR="+GetElementValue("StoreLocDR");
	val=val+"^ItemDR="+GetElementValue("ItemDR");
	val=val+"^Name="+GetElementValue("Name");
	val=val+"^Status="+GetElementValue("Status");
	val=val+"^ModelDR="+GetElementValue("ModelDR");
	val=val+"^FilterFlag="+GetElementValue("FilterFlag");
	val=val+"^"+GetElementValue("FilterData");
	val=val+"^QXType="+GetElementValue("QXType");
	val=val+"&ReadOnly="+readonly;   ///2014-4-29 10:18:27
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQClothFind&vData='+val;
}
*/
function SelectRowHandler()	{
	var selectrow=0;
	var eSrc=websys_getSrcElement(e);	
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc)
	if (eSrc.tagName=="TD")
	{
		var rowObj=getRow(eSrc);
		selectrow=rowObj.rowIndex;
	}
	else
	{
		selectrow=GetRowByColName(eSrc.id);//µ÷ÓÃ
	}
	
	if (!selectrow) return;
	if (SelectedRow==selectrow)	{	
		SelectedRow=0;
		rowid=0;
		///parent.parent.frames["eprmenu"].document.forms["fEPRMENU"].PatientID.value="";
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+selectrow);
		///parent.parent.frames["eprmenu"].document.forms["fEPRMENU"].PatientID.value=rowid;
		}
		
	//alertShow(parent.frames["eprmenu"].document.forms["fEPRMENU"].PatientID.value);
	
}

function GetUseLocID(value)
{
	GetLookUpID("UseLocDR",value);
}

function GetItemID(value)
{
	GetLookUpID("ItemDR",value);
}


document.body.onload = BodyLoadHandler;



