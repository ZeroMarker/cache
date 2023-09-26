document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	var tbl=document.getElementById("tDHCDocExamGetPatList");
	if(tbl) tbl.ondblclick=TblDblClick;
}
function TblDblClick()
{
	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tDHCDocExamGetPatList');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('PatNoz'+selectrow);  
 	 if (obj){var Rowidz=obj.innerText;};
 	 var Str=Rowidz
 	 window.returnValue=Str;
     window.close();
	 	 
}