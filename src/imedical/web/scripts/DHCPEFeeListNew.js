var SelectedRow="";

function BodyLoadHandler()
{	
	InitListInfo();
	Inform();
	obj=document.getElementById("Name");
	if (obj){ obj.onkeydown=Name_KeyDown;
		
	}
}

function Name_KeyDown(e){
	
	var Key=websys_getKey(e);
	var obj=document.getElementById("Query");
	if ((13==Key)) {
		obj.click();
	}
}

function Inform(){
	var objtbl=document.getElementById('tDHCPEFeeListNew');
	if (!objtbl) return;
	var itemfeeids=""
	var rows=objtbl.rows.length; 
	for (i=1;i<=rows;i++)
	{
	var itemfeeid=GetCtlValueById("TRowIdz"+i);
	if(itemfeeids==""){itemfeeids=itemfeeid;}
	else{itemfeeids=itemfeeids+"^"+itemfeeid;}
	}
	SetCtlValueById("AllItemFeeID",itemfeeids,0);
}


function InitListInfo()
{
	var i,objChk;
	var objtbl=document.getElementById('tDHCPEFeeListNew');
	if (!objtbl) return;
	
	var rows=objtbl.rows.length; 
	for (i=1;i<=rows;i++)
	{
		objChk=document.getElementById('TCheckedz'+i);
		if (objChk)
		{
			objChk.disabled=false;
			objChk.onclick=Chk_Click;
		}
	}	
}

function Chk_Click()
{
	
	var eSrc = window.event.srcElement;
	var addflag=eSrc.checked;
	var rowObj=getRow(eSrc);
	var SelectIds=GetCtlValueById("SelectRows")
	var selectrow=rowObj.rowIndex;
	
	var itemfeeid=GetCtlValueById("TRowIdz"+selectrow);
	
	var itemfeetype=GetCtlValueById("TFeeTypez"+selectrow);
	var itemfeeinfos="";
	
	if ((""!=itemfeeid)&&(""!=itemfeetype)) itemfeeinfos=itemfeeid+","+itemfeetype;
	if((""!=itemfeeid)&&(""==itemfeetype)) itemfeeinfos=itemfeeid
	//alert(itemfeeinfos);
	if (addflag)
	{
		if (SelectIds=="") SelectIds=SelectIds+"^"		
		SelectIds=SelectIds+itemfeeinfos+"^";
	}
	else
	{
		SelectIds=SelectIds.replace("^"+itemfeeinfos+"^","^");
	}
	
	SetCtlValueById("SelectRows",SelectIds,0);
}
/*
function SelectRowHandler() {  
	var eSrc=window.event.srcElement;
	
	var objtbl=document.getElementById('tDHCPEFeeList');
	
	if (objtbl){
		var rows=objtbl.rows.length;
	}

	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	var SelectedRow=GetCtlValueById("SelectRows");

	if (selectrow!=SelectedRow) {
		SelectedRow=selectrow;
		var itemfeeid=GetCtlValueById("TRowIdz"+SelectedRow);
		var itemfeetype=GetCtlValueById("TFeeTypez"+SelectedRow);
		var itemfeeinfos=""
		if ((""!=itemfeeid)&&(""!=itemfeetype)) itemfeeinfos=itemfeeid+","+itemfeetype;
		SetCtlValueById("SelectRows",itemfeeinfos,0);		
	}
	else
	{	SelectedRow="";
		SetCtlValueById("SelectRows","",0);}
	
}
*/

document.body.onload = BodyLoadHandler;