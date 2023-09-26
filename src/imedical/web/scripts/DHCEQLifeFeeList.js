///Ñ¡ÔñÐÐ
var CurrentSel=0;
var strLnk='';

function BodyLoadHandler() 
{
	SetLink();
}

function SetLink()
{
	var SelRowObj;
	var objtbl=document.getElementById('tDHCEQLifeFeeList');
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++)
	{
		SelRowObj=document.getElementById('RowIDz'+i);
		SelRowObj.onclick=lnk_Click;
		SelRowObj.href="#";
	}	
}


function lnk_Click()
{
	var eSrc=window.event.srcElement;	
	var row=GetRowByColName(eSrc.id);
	var lnk=GetHref(row);
	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
}

function GetHref(row)
{
	var SelRowObj=document.getElementById('RowIDz'+row);
	var TypeObj=document.getElementById('FeeTypeDRz'+row);
	var lnk="";
	if (TypeObj.value==5)
	{
		lnk= "dhceqinspect.csp?ID="+SelRowObj.innerText;
	}
	else if (TypeObj.value==7)
	{
		lnk= "dhceqmaint.csp?ID="+SelRowObj.innerText;
	}
	else if (TypeObj.value==10)
	{
		lnk= "dhcequsedresource.csp";
	}
	else if (TypeObj.value==19)
	{
		lnk= "dhceqmonthdepre.csp";
	}
	return lnk;
}

function GetRowByColName(colname)
{
	var offset=colname.lastIndexOf("z");
	var row=colname.substring(offset+1);
	return row;
}

function GetLocID(value)
{
	alertShow(value);
	var obj=document.getElementById("FeeType");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}
document.body.onload = BodyLoadHandler;