var SelectedRow = 0,preRowInd=0;
var ancsuCodeold=0;
function BodyLoadHandler(){
	var obj=document.getElementById('ADD')
	if(obj) obj.onclick=ADD_click;
	var obj=document.getElementById('UPDATE')
	if(obj) obj.onclick=UPDATE_click;
	var obj=document.getElementById('DELETE')
	if(obj) obj.onclick=DELETE_click;
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCANCVenipuncSite');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('ancsuId');
	var obj1=document.getElementById('ancsuCode');
    var obj2=document.getElementById('ancsuDesc');
	if (preRowInd==selectrow){
	obj.value="";
	obj1.value="";
	obj2.value="";
	preRowInd=0;	
	}
	else {
	var SelRowObj=document.getElementById('tAncsuIdz'+selectrow);
	var SelRowObj1=document.getElementById('tAncsuCodez'+selectrow);
	var SelRowObj2=document.getElementById('tAncsuDescz'+selectrow);
	obj.value=SelRowObj.innerText;
	obj1.value=SelRowObj1.innerText;
	obj2.value=SelRowObj2.innerText;}
    ancsuCodeold=SelRowObj1.innerText;
	preRowInd=selectrow;
	return;
	}
function ADD_click(){
	var ancsuCode,ancsuDesc,Rerencmeth
	var obj=document.getElementById('ancsuCode')
	if(obj) ancsuCode=obj.value;
	if(ancsuCode==""){
		alert(t['alert:ancsuCodeFill']) 
		return;
		}
	var obj=document.getElementById('ancsuDesc')
	if(obj)  ancsuDesc=obj.value;
	if(ancsuDesc==""){
		alert(t['alert:ancsuDescFill']) 
		return;
		}

	var obj=document.getElementById('RepANCVpSite')
	if(obj) Rerencmeth=obj.value;
    var repflag=cspRunServerMethod(Rerencmeth,ancsuCode)
    if(repflag=="Y"){
		alert(t['alert:ANCVpSiterepeat'])
		 return;
		}
	var obj=document.getElementById('InsertANCVpSite')
	if(obj) {
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,ancsuCode,ancsuDesc);
	    if (resStr!='0'){
			alert(t['alert:baulk']);
			return;
			}	
		else  {alert(t['alert:success']);
		location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANCVenipuncSite";
		}
		}
}
function UPDATE_click(){
	if (preRowInd<1) return;
	var ancsuCode,ancsuDesc,Rerencmeth,ancsuId
	var obj=document.getElementById('ancsuId')
	if(obj) ancsuId=obj.value;
	if(ancsuId==""){
		alert(t['alert:Please Select One']) 
		return;
		}
	var obj=document.getElementById('ancsuCode')
	if(obj) ancsuCode=obj.value;
	if(ancsuCode==""){
		alert(t['alert:ancsuCodeFill']) 
		return;
		}
	var obj=document.getElementById('ancsuDesc')
	if(obj)  ancsuDesc=obj.value;
	if(ancsuDesc==""){
		alert(t['alert:ancsuDescFill']) 
		return;
		}
	if(ancsuCodeold!=ancsuCode){
	var obj=document.getElementById('RepANCVpSite')
	if(obj) Rerencmeth=obj.value;
    var repflag=cspRunServerMethod(Rerencmeth,ancsuCode)
    if(repflag=="Y"){
		alert(t['alert:ANCVpSiterepeat'])
		 return;
		}
	 }
	var obj=document.getElementById('UpdateANCVpSite')
	if(obj) {
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,ancsuId,ancsuCode,ancsuDesc);
	    if (resStr!='0'){
			alert(t['alert:baulk']);
			return;
			}	
		else  {alert(t['alert:success']);
		location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANCVenipuncSite";
		}
		}
}
function DELETE_click(){
	if (preRowInd<1) return;
	var ancsuId
	var obj=document.getElementById('ancsuId')
	if(obj) ancsuId=obj.value;
	if(ancsuId==""){
		alert(t['alert:Please Select One']) 
		return;
		}
	var obj=document.getElementById('DeleteANCVpSite')
	if(obj) var encmeth=obj.value;
	var resStr=cspRunServerMethod(encmeth,ancsuId)
	if (resStr!='0')
		{alert(t['alert:baulk']);
		return;}	
	else {alert(t['alert:success'])
	  location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANCVenipuncSite";
	}
}
document.body.onload = BodyLoadHandler;