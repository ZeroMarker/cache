var SelectedRow = 0;
var preRowInd=0;
function BodyLoadHandler(){
	var objtbl=document.getElementById('tDHCANOPRoomStatus');
	if (objtbl) {objtbl.ondblclick=Dublclick}
	var objlc=document.getElementById('GetANOPStat').value;
	var OPRCTLocId=document.getElementById("OPRCTLocId").value;
	var BedTypeCode=document.getElementById("BedTypeCode").value;
	var obj=document.getElementById("IfAvailable"); 
	if ((obj)&&(obj.checked==true)) var IfAvailable="Y";
	else var IfAvailable="N";
	var ret=cspRunServerMethod(objlc,OPRCTLocId,BedTypeCode,IfAvailable);
	var obj=document.getElementById('ANOPRoomA');
	if (obj) obj.value=ret;
	var obj=document.getElementById('select');
	if (obj) obj.onclick=SchClick;
 }
 function Dublclick(){
	 var eSrc=window.event.srcElement;
	 var objtbl=document.getElementById('tDHCANOPRoomStatus');
	 var rowObj=getRow(eSrc);
	 var selectrow=rowObj.rowIndex;
	 var SelRowObj=document.getElementById('TOPRRowidz'+selectrow);
	 var SelRowObj1=document.getElementById('TOPRDescz'+selectrow);
	 //alert(SelRowObj.innerText)
	 parent.frames['RPBottom'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPRoomStatusDetail&OPRRowid="+SelRowObj.innerText; //+"&OPARoom="+SelRowObj1.innerText; 
 	return;
 }
 function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCANOPRoomStatus');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('ANOPRoomA');
	
	var SelRowObj=document.getElementById('TOPRRowidz'+selectrow);
	
    if (preRowInd==selectrow){

   		preRowInd=0;
    }
   else{
	
	preRowInd=selectrow;
    }
	//SelectedRow=selectRow;
	return;
}
function SchClick()
{	
	var OPRCTLocId=document.getElementById("OPRCTLocId").value;
	var obj=document.getElementById("OPRCTLoc"); 
	if ((obj)&&(obj.value=="")) OPRCTLocId="";
	var BedTypeCode=document.getElementById("BedTypeCode").value;
	var obj=document.getElementById("BedType"); 
	if ((obj)&&(obj.value=="")) BedTypeCode="";
	var obj=document.getElementById("IfAvailable"); 
	if ((obj)&&(obj.checked==true)) var IfAvailable="Y";
	else var IfAvailable="N";
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPRoomStatus&OPRCTLocId="+OPRCTLocId+"&BedTypeCode="+BedTypeCode+"&IfAvailable="+IfAvailable;
	window.location.href=lnk; 	
}
function GetBedType(str)
{
	var bedTypeStr=str.split("^");
	var obj=document.getElementById("BedType")
	if (obj) obj.value=bedTypeStr[0];
	var obj=document.getElementById("BedTypeCode")
	if (obj) obj.value=bedTypeStr[1];	
}

function GetOPRCTLoc(str)
{
	var bedTypeStr=str.split("^");
	alert(str)
	var obj=document.getElementById("OPRCTLocId")
	if (obj) obj.value=bedTypeStr[0];	
	var obj=document.getElementById("OPRCTLoc")
	if (obj) obj.value=bedTypeStr[1];
}
document.body.onload = BodyLoadHandler;