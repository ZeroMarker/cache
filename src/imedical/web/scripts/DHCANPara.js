var SelectedRow=-1;
var ID=""
var OperID=""
function BodyLoadHandler() {
	var obj=document.getElementById('Add');
	if (obj) obj.onclick = Add_Click;
	var obj=document.getElementById('Delete');
	if (obj) obj.onclick = Delete_Click;
	var obj=document.getElementById('Update');
	if (obj) obj.onclick = Update_Click;	
	var obj=document.getElementById('ParaItem');
	if (obj) obj.onclick = ShowParaItem;		
}
function Update_Click()
{
	//ANPInterval ANPFixedItems
	 var typeobj=document.getElementById('ANPInterval');
	 if (typeobj) var ANPInterval=typeobj.value;
	 var typeobj=document.getElementById('ANPFixedItems');
	 if (typeobj) var ANPFixedItems=typeobj.value;
	 
	 var p1=ANPInterval+"^"+ANPFixedItems;
     p1=p1+"^"+OperID;
     //alert(p1);
	 var InsertObj=document.getElementById('UpdateDHCANCPara');
	 if (InsertObj) {var encmeth=InsertObj.value} else {var encmeth=''};
	 var Ret=cspRunServerMethod(encmeth,'addok','',p1);
}
function ShowParaItem()
{
	/*if (OperID=="") Return;
    var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCANParaItem&ANPIParref="+OperID;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=100,top=100');
 */
}
function Add_Click()
{
	 var typeobj=document.getElementById('ANPInterval');
	 if (typeobj) var ANPInterval=typeobj.value;
	 var typeobj=document.getElementById('ANPOPADr');
	 if (typeobj) var ANPOPADr=typeobj.value;
	 var typeobj=document.getElementById('ANPFixedItems');
	 if (typeobj) var ANPFixedItems=typeobj.value;
	 var p1=ANPInterval+"^"+ANPOPADr+"^"+ANPFixedItems;
 	 //alert(p1);
	 var InsertObj=document.getElementById('AddDHCANPara');
	 if (InsertObj) {var encmeth=InsertObj.value} else {var encmeth=''};
	 var Ret=cspRunServerMethod(encmeth,'addok','',p1);
	}
function addok(value)
	{if (value==0) {
		var findobj=document.getElementById('Query');
		if (findobj) findobj.click();
	//	window.location.reload();
		}}
function Delete_Click()
{
     var p1=OperID;
     var DeleteAnaestAgent=document.getElementById('DeleteDHCANPara');
	 if (DeleteAnaestAgent) {var encmeth=DeleteAnaestAgent.value} else {var encmeth=''};
	 //alert(p1);
	 var Ret=cspRunServerMethod(encmeth,'addok','',p1);	
}
function SetOperInfo(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("Name");
	Obj.value=obj[0];
	var Obj=document.getElementById("ID");
	Obj.value=obj[1];	
	}
	
function SelectRowHandler()	
{  
	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tDHCANPara');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow!=SelectedRow) {
	var SelRowObj=document.getElementById('tIDz'+selectrow);
	OperID=SelRowObj.innerText;
	SetParaInfo(OperID);
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANParaItem&ANPIParref="+OperID;
    parent.frames['AnParaBottom'].location.href=lnk; 
	}
}
function SetParaInfo(Str)
{
	 p1=Str;
     //alert(p1);	 
	 var UpObj=document.getElementById('GetParaInfo');
	 if (UpObj) {var encmeth=UpObj.value} else {var encmeth=''};
	 var Ret=cspRunServerMethod(encmeth,p1); 
	 var RetStr=Ret.split("^");
	 //alert(Ret);
	 
	 var typeobj=document.getElementById('ANPInterval');
	 if (typeobj)  typeobj.value=RetStr[0];
	 var typeobj=document.getElementById('ANPFixedItems');
     if (typeobj)  typeobj.value=RetStr[1];
	 
}	
document.body.onload = BodyLoadHandler;