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
	var objtbl=document.getElementById('tDHCEQChangeInfoList');
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
	var TypeObj=document.getElementById('ChangeTypez'+row);
	var lnk="";
	if (TypeObj.innerText==5)
	{
		lnk= "dhceqmove.csp?ID="+SelRowObj.innerText;
	}
	else if (TypeObj.innerText==7)
	{
		lnk= "dhceqmoveout.csp?ID="+SelRowObj.innerText;
	}
	else if (TypeObj.innerText==10)
	{
		lnk= "dhceqstart.csp";
	}
	else if (TypeObj.innerText==19)
	{
		lnk= "dhceqdisuserequest.csp";
	}
	return lnk;
}



document.body.onload = BodyLoadHandler;