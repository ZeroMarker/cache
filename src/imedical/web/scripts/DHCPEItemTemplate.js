//Create by MLH
var TFORM="tDHCPEItemTemplate";
var CurrentSel=0;
function BodyLoadHandler() {
	var obj;
	//obj=document.getElementById(TFORM);
	//if (obj) { obj.ondblclick=PreIADM_click; }
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	iniForm();
}

function iniForm(){
	var obj;
	//obj=document.getElementById("Status");
	//if (obj) { SetStatus(obj.value); }
	//ShowCurRecord(0);
}

function Update_click() {
	var TemplateDetail=""
  	var obj=document.getElementById("TemplateDetail");
    if (obj){
		TemplateDetail=obj.value
	}
	//alert("TemplateDetail:"+TemplateDetail);

    window.opener.ChangeTemplate(TemplateDetail);
	window.close();

 	return false;
}

function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	var tForm="";
	var obj=document.getElementById("TFORM");
	var TemplateDesc="";
	
	if (obj){ tForm=obj.value; }
	var objtbl=document.getElementById(tForm);	
	if (objtbl) { var rows=objtbl.rows.length; }
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	for (p=0; p<rowObj.all.length; p++)	{
		var TemplateDescObj=rowObj.all[p];
		if (TemplateDescObj.id=='TTemplateDescz'+selectrow){
			TemplateDesc=TemplateDescObj.innerText;
		} 
	}
    
    var TempDetailOBJ=document.getElementById('TemplateDetail');
    var TempDetailValue=TempDetailOBJ.value
	if (TempDetailOBJ){
		if (TempDetailValue=='') {
			TempDetailOBJ.value=TemplateDesc;
			}
		else {
		TempDetailOBJ.value=TempDetailValue+" "+TemplateDesc;}
	}

}

document.body.onload = BodyLoadHandler;