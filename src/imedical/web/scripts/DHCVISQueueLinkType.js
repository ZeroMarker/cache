//DHCVISQueueLinkType.js
var typeId="";
var selrow="";
function BodyLoadHandler() {
	
	var AddButton = document.getElementById("Add");
	if (AddButton) {AddButton.onclick=AddOnclick;} 
	var UpdateButton = document.getElementById("Update");
	if (UpdateButton) {UpdateButton.onclick=UpdateOnclick;} 
	var DeleteButton = document.getElementById("Delete");
	if (DeleteButton) {DeleteButton.onclick=DeleteOnclick;} 
}

function AddOnclick () {
	var typeCode=document.getElementById("typeCode").value;
	var typeDesc=document.getElementById("typeDesc").value;
	var typeNote=document.getElementById("typeNote").value;
	var activeFlag=document.getElementById("activeFlag").checked;
	if (activeFlag==true) {activeFlag="Y";}
	else {activeFlag="N";}
	//alert(typeCode+typeDesc+typeNote+activeFlag);
	
	var ret=tkMakeServerCall("web.DHCVISLinkQueueType","SaveLinkQueueType","",typeCode,typeDesc,typeNote,activeFlag);
	//alert(ret);
	var retArr=ret.split("^");
	if (retArr[0]=="0") {
		alert("添加成功");
		Search_click();
	}else {
		var err=retArr[1];
		alert(err);
	}
}

function UpdateOnclick() {
	if (typeId=="") {
		alert("请选中一条记录后再进行操作!");
		return ;
	}
	
	var typeCode=document.getElementById("typeCode").value;
	var typeDesc=document.getElementById("typeDesc").value;
	var typeNote=document.getElementById("typeNote").value;
	var activeFlag=document.getElementById("activeFlag").checked;
	//alert("activeFlag=="+activeFlag);
	if (activeFlag==true) {activeFlag="Y";}
	else {activeFlag="N";}
	//alert(typeCode+typeDesc+typeNote+activeFlag);
	
	var ret=tkMakeServerCall("web.DHCVISLinkQueueType","SaveLinkQueueType",typeId,typeCode,typeDesc,typeNote,activeFlag);
	//alert(ret);
	
	var retArr=ret.split("^");
	if (retArr[0]=="0") {
		alert("更新成功");
		Search_click();
	}else {
		var err=retArr[1];
		alert(err);
	}
}

function DeleteOnclick() {
	
	if (typeId=="") {
		alert("请选中一条记录后再进行操作!");
		return ;
	}
	var ret=tkMakeServerCall("web.DHCVISLinkQueueType","DeleteLinkQueueType",typeId);
	//alert(ret);
	
	var retArr=ret.split("^");
	if (retArr[0]=="0") {
		alert("删除成功");
		Search_click();
	}else {
		var err=retArr[1];
		alert(err);
	}
}

function SelectRowHandler()
{
   	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCVISQueueLinkType');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	var rowObj=getRow(eSrc);
	var selrow=rowObj.rowIndex;
	if (!selrow) return;
	
	typeId=document.getElementById("QueueTypeIdz"+selrow).value;
	var typeCode=document.getElementById("QueueTypeCodez"+selrow).innerText;
	var typeDesc=document.getElementById("QueueTypeDescz"+selrow).innerText;
	var typeNote=document.getElementById("QueueTypeNotez"+selrow).innerText;
	var activeFlag=document.getElementById("QueueActiveFlagz"+selrow).innerText;
	document.getElementById("typeCode").value=typeCode;
	document.getElementById("typeDesc").value=typeDesc;
	document.getElementById("typeNote").value=typeNote;
	if (activeFlag=="Y") {
		document.getElementById("activeFlag").checked=true;
	}else {
		document.getElementById("activeFlag").checked=false;
	}
	
	return false;
}

function SelectRowHandlerBak()
{
   	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	selrow=rowObj.rowIndex;
	//alert("selrow=="+selrow);
	if (!selrow) return;
	
	typeId=document.getElementById("QueueTypeIdz"+selrow).value;
	var typeCode=document.getElementById("QueuetypeCodez"+selrow).innerText;
	var typeDesc=document.getElementById("QueuetypeDescz"+selrow).innerText;
	var typeNote=document.getElementById("QueuetypeNotez"+selrow).innerText;
	var activeFlag=document.getElementById("QueueActiveFlagz"+selrow).innerText;
	document.getElementById("typeCode").value=typeCode;
	document.getElementById("typeDesc").value=typeDesc;
	document.getElementById("typeNote").value=typeNote;
	if (activeFlag=="Y") {
		document.getElementById("activeFlag").checked=true;
	}else {
		document.getElementById("activeFlag").checked=false;
	}
	
	return false;
}

document.body.onload = BodyLoadHandler;