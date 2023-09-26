///DHCPEGroupAllPersonFind.js
var CurrentSel=0
function BodyLoadHandler() {
	var obj;
    
	obj=document.getElementById("SelectALL");
	if (obj) { obj.onclick=SelectALL_Click; }
	
	//新建项目 BNewItem_click
	obj=document.getElementById("BNewItem");
	if (obj){ 
		obj.onclick=BNewItem_click; 

		
	}
	
	//额外加项MLH
	obj=document.getElementById("BAddItem");
	if (obj){ 
		obj.onclick=AddItem_click; 
		 
		
	}

}
function SelectALL_Click() 
{  var TFORM='tDHCPEGroupAllPersonFind'
	var Src=window.event.srcElement;
	 var tbl=document.getElementById(TFORM);
     var rows=tbl.rows.length; 
	for (var iLLoop=1;iLLoop<=rows;iLLoop++) {
		obj=document.getElementById('TSelect'+'z'+iLLoop);
		if (obj) { obj.checked=Src.checked; }
	}
	
}
//当前客户新增项目
function BNewItem_click() {
	
     var TFORM='tDHCPEGroupAllPersonFind'
	//var eSrc=document.getElementById("BNewItem");
	//if (eSrc.disabled) { return false;}

	var iRowId="";
     var RowIdStr=""; 
    var objtbl=document.getElementById(TFORM);
	if (objtbl) { var rows=objtbl.rows.length; }
	else { return false; }
    for (var iLLoop=1;iLLoop<rows;iLLoop++)
     {
		var obj=document.getElementById('TSelect'+'z'+iLLoop);
		if (obj && obj.checked) 
		{
		var iRowId=""
		var obj=document.getElementById('TPIADMRowId'+'z'+iLLoop);
	    if (obj) { iRowId=obj.value; }
	    if (RowIdStr==""){ RowIdStr=iRowId}
	    else {RowIdStr=RowIdStr+"^"+iRowId}
			}
			}
	if (""==RowIdStr) 
	{ alert(t['NoSelect']);
	return false;}
	
	var PreOrAdd="PRE"  //是否公费加项
	var ShowFlag="F"    //为批量加项链接 则不显示某些按钮
	var lnk="dhcpepreitemlist.main.csp"+"?AdmType=PERSON"
			+"&AdmId="+RowIdStr+"&PreOrAdd="+PreOrAdd+"&ShowFlag="+ShowFlag
			;
		alert(lnk)
	var wwidth=1000;
	var wheight=600; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes, '
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(lnk,"_blank",nwin)	

	return true;
}

//额外加项---
function AddItem_click() {
	
	var TFORM='tDHCPEGroupAllPersonFind'
	//var eSrc=document.getElementById("BAddItem");
	//if (eSrc.disabled) { return false;}
	var RowIdStr=""; 
    var objtbl=document.getElementById(TFORM);
	if (objtbl) { var rows=objtbl.rows.length; }
	else { return false; }
    for (var iLLoop=1;iLLoop<rows;iLLoop++)
     {
		var obj=document.getElementById('TSelect'+'z'+iLLoop);
		if (obj && obj.checked) 
		{
		var iRowId=""
		var obj=document.getElementById('TPIADMRowId'+'z'+iLLoop);
	    if (obj) { iRowId=obj.value; }
	    if (RowIdStr==""){ RowIdStr=iRowId}
	    else {RowIdStr=RowIdStr+"^"+iRowId}
			}
			}
  
  
	if (""==RowIdStr)	
	{ alert(t['NoSelect']);
	return false;}
	var PreOrAdd="ADD" //是否公费加项
	var ShowFlag="F"   //为批量加项链接 则不显示某些按钮
 	var lnk="dhcpepreitemlist.main.csp"+"?AdmType=PERSON"
			+"&AdmId="+RowIdStr+"&PreOrAdd="+PreOrAdd+"&ShowFlag="+ShowFlag
			;
	var wwidth=1000;
	var wheight=600; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes, '
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(lnk,"_blank",nwin)	

	return true;
}

function SelectRowHandler() {
 
	var eSrc=window.event.srcElement;
	var tForm="";
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById(tForm);	
	
	if (objtbl) { var rows=objtbl.rows.length; }
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	if (CurrentSel==selectrow)
	{
		CurrentSel=0
	}
	else
	{
		CurrentSel=selectrow;
	}
		ChangeCheckStatus("TSelect");


}









document.body.onload = BodyLoadHandler;
