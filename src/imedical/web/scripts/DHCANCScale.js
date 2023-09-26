var SelectedRow=-1;
var ID="";
function BodyLoadHandler() 
{
	var obj=document.getElementById('Add');
	if (obj) obj.onclick = Add_Click;
	var obj=document.getElementById('Delete');
	if (obj) obj.onclick = Delete_Click;
	var obj=document.getElementById('Update');
	if (obj) obj.onclick = Update1_Click;		
}
function Delete_Click()
{
	 var p1=ID;
     var DeleteAnaestAgent=document.getElementById('DeleteDHCANCScale');
	 if (DeleteAnaestAgent) {var encmeth=DeleteAnaestAgent.value} else {var encmeth=''};
	 //alert(p1);
	 var Ret=cspRunServerMethod(encmeth,'addok','',p1);	
}
function Update1_Click()
{
	// alert("dd");
	 var typeobj=document.getElementById('ANCSCode');
	 if (typeobj) var ANCSCode=typeobj.value;
	 var typeobj=document.getElementById('ANCSDesc');
	 if (typeobj) var ANCSDesc=typeobj.value;
	 var typeobj=document.getElementById('ANCSMinVal');
	 if (typeobj) var ANCSMinVal=typeobj.value;
	 var typeobj=document.getElementById('ANCSMaxVal');
	 if (typeobj) var ANCSMaxVal=typeobj.value;
	 var typeobj=document.getElementById('ANCSRatio');
	 if (typeobj) var ANCSRatio=typeobj.value;
	 var typeobj=document.getElementById('ANCSUOMDr');
	 if (typeobj) var ANCSUOMDr=typeobj.value;
	 var p1=ANCSCode+"^"+ANCSDesc+"^"+ANCSMinVal+"^"+ANCSMaxVal+"^"+ANCSRatio+"^"+ANCSUOMDr;
     p1=p1+"^"+ID;
     //alert(p1);
	 var InsertObj=document.getElementById('UpdateDHCANCScale');
	 if (InsertObj) {var encmeth=InsertObj.value} else {var encmeth=''};
	 var Ret=cspRunServerMethod(encmeth,'addok','',p1); 
 
 }	
 
function Add_Click()
{
	     
	 var typeobj=document.getElementById('ANCSCode');
	 if (typeobj) var ANCSCode=typeobj.value;
	 var typeobj=document.getElementById('ANCSDesc');
	 if (typeobj) var ANCSDesc=typeobj.value;
	 var typeobj=document.getElementById('ANCSMinVal');
	 if (typeobj) var ANCSMinVal=typeobj.value;
	 var typeobj=document.getElementById('ANCSMaxVal');
	 if (typeobj) var ANCSMaxVal=typeobj.value;
	 var typeobj=document.getElementById('ANCSRatio');
	 if (typeobj) var ANCSRatio=typeobj.value;
	 var typeobj=document.getElementById('ANCSUOMDr');
	 if (typeobj) var ANCSUOMDr=typeobj.value;
	// var LeftFirst=typeobj.left(1,1)
          
	 
	 var p1=ANCSCode+"^"+ANCSDesc+"^"+ANCSMinVal+"^"+ANCSMaxVal+"^"+ANCSRatio+"^"+ANCSUOMDr;
 	 //alert(p1);
	 var InsertObj=document.getElementById('AddDHCANCScale');
	 if (InsertObj) {var encmeth=InsertObj.value} else {var encmeth=''};
	 var Ret=cspRunServerMethod(encmeth,'addok','',p1);
	 //alert(Ret);
	}

function addok(value)
	{if (value==0) {
		var findobj=document.getElementById('Query');
		if (findobj) findobj.click();
	//	window.location.reload();
		}}
function SetUomInfo(str)
{

	var obj=str.split("^");
	var Obj=document.getElementById("ANCSUOMDr");
	Obj.value=obj[1];
	var Obj=document.getElementById("ANCSUOMDrName");
	Obj.value=obj[0];	
	}
function SelectRowHandler()	
{  
	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tDHCANCScale');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow!=SelectedRow) {
	var SelRowObj=document.getElementById('tIDz'+selectrow);
	ID=SelRowObj.innerText;
	//alert(ID);
	
	SetScaleInfo(ID);
	}
}
function SetScaleInfo(Str)
{
	 p1=Str;	 
	 var UpdateObj=document.getElementById('GetScaleInfo');
	 if (UpdateObj) {var encmeth=UpdateObj.value} else {var encmeth=''};
	 var Ret=cspRunServerMethod(encmeth,p1); 
	 var RetStr=Ret.split("^");
	 
	 var typeobj=document.getElementById('ANCSCode');
     typeobj.value=RetStr[0];
	 var typeobj=document.getElementById('ANCSDesc');
     typeobj.value=RetStr[1];
	 var typeobj=document.getElementById('ANCSMinVal');
     typeobj.value=RetStr[2];
	 var typeobj=document.getElementById('ANCSMaxVal');
     typeobj.value=RetStr[3];
	 var typeobj=document.getElementById('ANCSRatio');
     typeobj.value=RetStr[4];
	 var typeobj=document.getElementById('ANCSUOMDr');
     typeobj.value=RetStr[5];
	 var typeobj=document.getElementById('ANCSUOMDrName');
     typeobj.value=RetStr[6];     
	}


document.body.onload = BodyLoadHandler;