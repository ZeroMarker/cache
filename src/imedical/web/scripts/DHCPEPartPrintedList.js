 //DHCPEPartPrintedList.js
 // create by zhouli
 var SelectedRow="";
 var TFORM="DHCPEPartPrintedList"
function BodyLoadHandler()
{	
	
	
   InitList();
  
 
}

function InitList()
{
	  var obj=document.getElementById("GADMName")
	  if (obj){GName=obj.value
   
	  document.getElementById("cGADMNameView").innerText=GName}
	  }



function ShowCurRecord(CurrentSel) {

	

	var SelRowObj=document.getElementById('TSort'+'z'+CurrentSel);
	var obj=document.getElementById("Num");
	if (SelRowObj && obj) {obj.value=SelRowObj.innerText; }
	TransData()
	    
	

}
 
 function TransData()
{	
    
    var frm=parent.frames[1];
	var obj=document.getElementById("Num");
	if(obj){var SelNum=obj.value}
	DHCWebD_ClearAllListSub("SelectedList");
    var obj=frm.document.getElementById("GADMDR")
	if(obj){var GADMDR=obj.value}
	var encmeth1=document.getElementById("GetRowSession");
    var encmeth1=encmeth1.value
    if (encmeth1!=""){
    var rtn=cspRunServerMethod(encmeth1,GADMDR,SelNum)
	} 
    var encmeth=frm.document.getElementById("GetData");
    var encmeth=encmeth.value
    if (encmeth!=""){
    var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListSub","SelectedList",GADMDR,SelNum)
	} 
}
function SelectRowHandler() {
   
    var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPEPartPrintedList');	
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;	    
	CurrentSel=selectrow;
	ShowCurRecord(CurrentSel);


}
document.body.onload = BodyLoadHandler;