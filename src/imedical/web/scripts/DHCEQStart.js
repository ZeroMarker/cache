var SelectedRow = 0;
var rowid=0;

function BodyLoadHandler() 
{
	InitPage();
	//BannerInitPage();
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQStart');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

//alertShow(selectrow+"/"+rows)

	if (!selectrow) return;
	Selected(selectrow);
}

document.body.onload = BodyLoadHandler;
