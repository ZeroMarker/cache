var SelectedRow="";
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