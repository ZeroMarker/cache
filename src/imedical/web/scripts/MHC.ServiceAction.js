
function BodyLoadHandler() {
	var obj=document.getElementById("btnAdd")
	if (obj) obj.onclick=AddHandler;
	var obj=document.getElementById("btnUpdate")
	if (obj) obj.onclick=SaveHandler;
	var obj=document.getElementById("btnDelete")
	if (obj) obj.onclick=DeleteHandler;
	var obj=document.getElementById("btn_Find")
	if (obj) obj.onclick=btnAdd_click;
}
function AddHandler()
{
	var obj=document.getElementById('txtID');
	if(obj) obj.value="";
	SaveHandler();
} 
function SaveHandler()
{
	var ID=""
	var obj=document.getElementById('txtID');
	if(obj) ID=obj.value;
	var ActionCode="ActionCode|"
	var obj=document.getElementById('txtActionCode');
	if(obj) ActionCode=ActionCode+obj.value;
	
	var ActionName="ActionName|"
	var obj=document.getElementById('txtActionName');
	if(obj) ActionName=ActionName+obj.value;
	
	var ClassName="ClassName|"
	var obj=document.getElementById('txtClassName');
	if(obj) ClassName=ClassName+obj.value;
	
	var MethodName="MethodName|"
	var obj=document.getElementById('txtMethodName');
	if(obj) MethodName=MethodName+obj.value;
	
	var ParmList=ActionCode+"^"+ActionName+"^"+ClassName+"^"+MethodName
	var RetStr=tkMakeServerCall("MHC.Store.ServiceAction","Save",ID,ParmList);
	alert(RetStr)
	var obj=document.getElementById('txtID');
	if(obj) obj.value="";
	var obj=document.getElementById('txtActionCode');
	if(obj) obj.value="";
	var obj=document.getElementById('txtActionName');
	if(obj) obj.value="";
	var obj=document.getElementById('txtClassName');
	if(obj) obj.value="";
	var obj=document.getElementById('txtMethodName');
	if(obj) obj.value="";
	btnAdd_click();
}
function DeleteHandler()
{
	var ID=""
	var obj=document.getElementById('txtID');
	if(obj) ID=obj.value;
	if(ID=="")
	{
		alert("ÇëÑ¡ÔñÉ¾³ýµÄ¼ÇÂ¼!");
		btnAdd_click();
	}
	var RetStr=tkMakeServerCall("MHC.Store.ServiceAction","Delete",ID);
	var obj=document.getElementById('txtID');
	if(obj) obj.value="";
	var obj=document.getElementById('txtActionCode');
	if(obj) obj.value="";
	var obj=document.getElementById('txtActionName');
	if(obj) obj.value="";
	var obj=document.getElementById('txtClassName');
	if(obj) obj.value="";
	var obj=document.getElementById('txtMethodName');
	if(obj) obj.value="";
	btnAdd_click();
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tMHC_ServiceAction');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('txtID');
	var SelRowObj=document.getElementById('IDz'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.value;
	
	var obj=document.getElementById('txtActionCode');
	var SelRowObj=document.getElementById('ActionCodez'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText;
	
	var obj=document.getElementById('txtActionName');
	var SelRowObj=document.getElementById('ActionNamez'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText;
	
	var obj=document.getElementById('txtClassName');
	var SelRowObj=document.getElementById('ClassNamez'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText;

	var obj=document.getElementById('txtMethodName');
	var SelRowObj=document.getElementById('MethodNamez'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText;	
}
function ServerSelect(str){
	var ret=str.split("^");
	var obj=document.getElementById('txtServerName');
	if (obj) obj.value=ret[2]
	var obj=document.getElementById('txtServerId');
	if (obj) obj.value=ret[0]
	var obj=document.getElementById('txtExaBoroughId');
	if (obj) obj.value=ret[4]
}
function ExaRoomSelect(str){
	var ret=str.split("^");
	var obj=document.getElementById('txtClientLinkRoom');
	if (obj) obj.value=ret[1]
	var obj=document.getElementById('txtClientLinkRoomId');
	if (obj) obj.value=ret[0]
}
function WindowSelect(str){
	var ret=str.split("^");
	var obj=document.getElementById('txtClientLinkRoom');
	if (obj) obj.value=ret[2]
	var obj=document.getElementById('txtClientLinkRoomId');
	if (obj) obj.value=ret[3]
}
function LocSelect(str){
	var ret=str.split("^");
	var obj=document.getElementById('txtClientLinkDoc');
	if (obj) obj.value=ret[1]
	var obj=document.getElementById('txtClientLinkDocId');
	if (obj) obj.value=ret[0]
}
function QueueTypeSelect(str){
	var ret=str.split("^");
	var obj=document.getElementById('txtClientNote');
	if (obj) obj.value=ret[1]
	var obj=document.getElementById('txtClientNoteId');
	if (obj) obj.value=ret[0]
}
window.document.body.onload=BodyLoadHandler;