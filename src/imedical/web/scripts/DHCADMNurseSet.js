var SelectedRow = 0;
function BodyLoadHandler(){
	var obj=document.getElementById('BADD')
	if(obj) obj.onclick=BADD_click;
	var obj=document.getElementById('BUpdate')
	if(obj) obj.onclick=BUpdate_click;
	var obj=document.getElementById('BDelete')
	if(obj) obj.onclick=BDelete_click;
}
function GetArcim(str)
{
		var Arcim=str.split("^");
		//alert(Arcim[1])
		//alert(Arcim[2])
		//alert(Arcim[0].split("-")[1])
		var obj=document.getElementById("ArcimCode")
		obj.value=Arcim[1];
		var obj=document.getElementById("ArcimID")
		obj.value=Arcim[2];
		var obj=document.getElementById("ArcimDesc")
		obj.value=Arcim[0].split("-")[1];
	
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCADMNurseSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('RowID');
	var SelRowObj=document.getElementById('tRowIDz'+selectrow);
	//alert(SelRowObj.innerText)
	if (obj) obj.value=SelRowObj.innerText;
	
	return;
	SelectedRow=selectrow;
	}
function BADD_click(){
	var obj=document.getElementById('Arcim')
	if(obj) var Arcim=obj.value;
	if(Arcim==""){
		alert(t['02']) 
		return;
		}
	var obj=document.getElementById('InsertTyp')
	if(obj) var encmeth=obj.value;
	
	var objArcimCode=document.getElementById("ArcimCode").value;
	var objArcimID=document.getElementById("ArcimID").value;
	var objArcimDesc=document.getElementById("ArcimDesc").value;
		
	//alert(objArcimCode)
	//alert(objArcimID)
	//alert(objArcimDesc)
    if (cspRunServerMethod(encmeth,objArcimDesc,objArcimCode,objArcimID)!='0')
		{alert(t['04']);
		return;}	
	try {		   
	    alert(t['03']);
	    window.location.reload();
		} catch(e) {};
	}
function BUpdate_click(){
	var obj=document.getElementById('Arcim')
	if(obj) var Arcim=obj.value;
	if(Arcim==""){
		alert(t['02']) 
		return;
		}
	var obj=document.getElementById('RowID')
	if(obj) var RowID=obj.value;
	if(RowID==""){
		alert(t['01']) 
		return;
		}
	var obj=document.getElementById('UpdateTyp')
	if(obj) var encmeth=obj.value;
	var objArcimCode=document.getElementById("ArcimCode").value;
	var objArcimID=document.getElementById("ArcimID").value;
	var objArcimDesc=document.getElementById("ArcimDesc").value;
	if (cspRunServerMethod(encmeth,RowID,objArcimDesc,objArcimCode,objArcimID)!='0')
		{alert(t['04']);
		return;}	
	try {		   
	    alert(t['03']);
	    window.location.reload();
		} catch(e) {};
	}
function BDelete_click(){
	var obj=document.getElementById('RowID')
	if(obj) var RowID=obj.value;
	if(RowID==""){
		alert(t['01']) 
		return;
		}
	var obj=document.getElementById('DeleteTyp')
	if(obj) var encmeth=obj.value;
	if (cspRunServerMethod(encmeth,RowID)!='0')
		{alert(t['04']);
		return;}	
	try {alert(t['03']);
	    window.location.reload();
		} catch(e) {};
	}

document.body.onload=BodyLoadHandler;