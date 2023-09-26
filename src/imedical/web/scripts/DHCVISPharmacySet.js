function BodyLoadHandler() {
	var obj=document.getElementById("btnUpdate")
	if (obj) obj.onclick=UpdateHandler;
}

function UpdateHandler()
{
	var obj=document.getElementById('txtCTLoc');
	var CTLoc=obj.value;
	if((CTLoc=="")||(CTLoc==" ")) return;
	
	var obj=document.getElementById('txtCTLocId');
	var CTLocId=obj.value;
	if(CTLocId=="") return;
	
	var obj=document.getElementById('txtWindow');
	var Window=obj.value;
	if((Window=="")||(Window==" ")) return;

	var obj=document.getElementById('txtWindowId');
	var WindowId=obj.value;
	if(WindowId=="") return;
	
	var obj=document.getElementById('txtWindowContent');
	var WindowContent=obj.value;
	if(WindowContent==" ") WindowContent=""

	var obj=document.getElementById('chkAvitive');
	var Avitive=obj.checked;
	if(Avitive) Avitive="Y"
	else Avitive="N"
	
	var obj=document.getElementById('txtReceiveWindow');
	var ReceiveWindow=obj.value;
	if(ReceiveWindow==" ") ReceiveWindow=""
	
	var obj=document.getElementById('txtReceiveWindowId');
	var ReceiveWindowId=obj.value;
	if(ReceiveWindowId==" ") ReceiveWindowId=""
	
	var obj=document.getElementById('MethodUpdate');
	if(obj)
	{
		var objUpdate=obj.value;
		var retStr=cspRunServerMethod(objUpdate,WindowId,WindowContent,Avitive,ReceiveWindowId);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnUpdate_click();
	}
	
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCVISPharmacySet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('txtCTLoc');
	var obj1=document.getElementById('txtCTLocId');
	var obj2=document.getElementById('txtWindow');
	var obj3=document.getElementById('txtWindowId');
	var obj4=document.getElementById('chkAvitive');
	var obj5=document.getElementById('txtWindowContent');
	var obj6=document.getElementById('txtReceiveWindow');
	var obj7=document.getElementById('txtReceiveWindowId');

	var SelRowObj=document.getElementById('TLocDescz'+selectrow);
	var SelRowObj1=document.getElementById('TLocIdz'+selectrow);
	var SelRowObj2=document.getElementById('TWinDescz'+selectrow);
	var SelRowObj3=document.getElementById('TWinIdz'+selectrow);
	var SelRowObj4=document.getElementById('TWindowStatez'+selectrow);
	var SelRowObj5=document.getElementById('TWindowContentz'+selectrow);
	var SelRowObj6=document.getElementById('TReceiveWindowz'+selectrow);
	var SelRowObj7=document.getElementById('TReceiveWindowIdz'+selectrow);

	if(obj&&SelRowObj) obj.value=SelRowObj.innerText;
	if(obj1&&SelRowObj1) obj1.value=SelRowObj1.innerText;
	if(obj2&&SelRowObj2) obj2.value=SelRowObj2.innerText;
	if(obj3&&SelRowObj3) obj3.value=SelRowObj3.innerText;
	if(obj4&&SelRowObj4)
	{
		if(SelRowObj4.innerText=="”–»À") obj4.checked=true;
		else obj4.checked=false;
	}
	if(obj5&&SelRowObj5) obj5.value=SelRowObj5.innerText;
	if(obj6&&SelRowObj6) obj6.value=SelRowObj6.innerText;
	if(obj7&&SelRowObj7) obj7.value=SelRowObj7.innerText;
	return;
}
function WindowSelect(str){
	var ret=str.split("^");
	var obj=document.getElementById('txtWindow');
	if (obj) obj.value=ret[2]
	var obj=document.getElementById('txtWindowId');
	if (obj) obj.value=ret[3]
}
function ReceiveWindowSelect(str){
	var ret=str.split("^");
	var obj=document.getElementById('txtReceiveWindow');
	if (obj) obj.value=ret[2]
	var obj=document.getElementById('txtReceiveWindowId');
	if (obj) obj.value=ret[3]
}
function LocSelect(str){
	var ret=str.split("^");
	var obj=document.getElementById('txtCTLoc');
	if (obj) obj.value=ret[1]
	var obj=document.getElementById('txtCTLocId');
	if (obj) obj.value=ret[0]
}
window.document.body.onload=BodyLoadHandler;