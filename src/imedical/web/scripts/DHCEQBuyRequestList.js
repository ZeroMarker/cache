
function BodyLoadHandler(){		
	SetLink();
}
function SetLink()
{
	var SelRowObj;
	var objtbl=document.getElementById('tDHCEQBuyRequestList');
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++)
	{
		SelRowObj=document.getElementById('TPrjNamez'+i);
		if (SelRowObj)
		{
		SelRowObj.onclick=lnk_Click;//调用
		SelRowObj.href="#";
		}
	}	
}
function lnk_Click()
{
	var eSrc=window.event.srcElement;	//获取事件源头
	var row=GetRowByColName(eSrc.id);//调用
	var lnk=GetHref(row);//调用
    parent.location.href=lnk;
    //window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
}
function GetRowByColName(colname)
{
	var offset=colname.lastIndexOf("z");
	var row=colname.substring(offset+1);
	return row;
}
function GetHref(row)
{
	var Type=GetElementValue('Type');
	var RowIDobj=document.getElementById('TRowIDz'+row);
	var RowID=RowIDobj.value;
	var ApproveSetDR=GetElementValue('TApproveSetDRz'+row);
	var CurRole=GetElementValue('ApproveRole');
	var QXType=GetElementValue('QXType');
	//var PlanType=PlanTypeobj.value;
	var ComponentName=""
	var lnk='dhceqbuyrequest.csp?RowID='+RowID+'&Type='+Type+'&ApproveSetDR='+ApproveSetDR+'&CurRole='+CurRole+'&QXType='+QXType;
	return lnk;
}


document.body.onload = BodyLoadHandler;