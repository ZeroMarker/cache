///DHCDocIndicationsChoose
document.body.onload = BodyLoadHandler;
///document.body.onunload = BodyUnLoadHandler;

var SelectedRow = 0;
var selectrow=0;
window.returnValue="";
function BodyLoadHandler()
{
	var Obj=window.dialogArguments;
	//var Obj=document.getElementById("InsurAlertStr");
	if (Obj){
		var temp=Obj.value;
		var InsurAlertStr=temp.split("&")[0];
		AddDataToTbl(InsurAlertStr);
	}
	var Obj=document.getElementById("Update");
	if (Obj){
		Obj.onclick=Update_Click;
	}
	var Obj=document.getElementById("Exit");
	if (Obj){
		Obj.onclick=Exit_Click;
	}
}

function AddDataToTbl(Para)
{
	if (Para==""){
		alert("Did not receive data");
		return;
	}
	var Objtbl=document.getElementById("tDHCDocIndicationsChoose");
	var Itemtemp=Para.split("!");
	for (var i=0;i<Itemtemp.length;i++){
		//DHCC_InsertRowToTable(Objtbl);
		if (i>Objtbl.rows.length-1){DHCC_InsertRowToTable(Objtbl);}
		var Item=Itemtemp[i].split(String.fromCharCode(1));
		var TarConCode=Item[0];
		var TarConDesc=Item[1];
		var ConType=Item[2];
		var bz=Item[3];
		document.getElementById("TarConCodez"+(i+1)).innerText=TarConCode;
		document.getElementById("TarConDescz"+(i+1)).innerText=TarConDesc;
		document.getElementById("ConTypez"+(i+1)).innerText=ConType;
		document.getElementById("bzz"+(i+1)).innerText=bz;
		
	}
}
function Update_Click(){
	if (SelectedRow!=1){
		alert("Row have no choice!");
		return;
	}
	var TarConCode=document.getElementById("TarConCodez"+selectrow).innerText;
	var TarConDesc=document.getElementById("TarConDescz"+selectrow).innerText;
	var ConType=document.getElementById("ConTypez"+selectrow).innerText;
	var bz=document.getElementById("bzz"+selectrow).innerText;
	window.returnValue=ConType;
	self.close();
	
}
function Exit_Click(){
	self.close();
}

function SelectRowHandler(){

	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tDHCDocIndicationsChoose');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	OldSelectRow=selectrow;
	selectrow=rowObj.rowIndex;
	if (selectrow!=0){
		if ((SelectedRow==0)||(selectrow!=OldSelectRow))SelectedRow=1;
		else SelectedRow=0;
	}	
}
function DHCC_InsertRowToTable(objtbl){
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=eval(arrId[arrId.length-1])+1;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			//rowitems[j].value="";
			if (rowitems[j].tagName=='LABEL'){rowitems[j].innerText=""}else{rowitems[j].value=""}
		}
	}
	objtbody=tk_getTBody(objlastrow);
	objnewrow=objtbody.appendChild(objnewrow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}	
}
