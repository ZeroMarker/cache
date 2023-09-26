
function BodyLoadHandler() {
	var obj=document.getElementById("btnAdd")
	if (obj) obj.onclick=AddHandler;
	var obj=document.getElementById("btnUpdate")
	if (obj) obj.onclick=UpdateHandler;
	var obj=document.getElementById("btnDelete")
	if (obj) obj.onclick=DeleteHandler;
}

function AddHandler()
{
	var obj=document.getElementById('txtPlanDR');
	var PlanDR=obj.value;
	if(PlanDR=="") return;

	var obj=document.getElementById('txtFileName');
	var FileName=obj.value;
	if(FileName=="") return;
	
	var obj=document.getElementById('txtActiveFlag');
	var ActiveFlag=obj.value;
	if(ActiveFlag=="") return;
	if(ActiveFlag=="on") ActiveFlag="Y"
	else ActiveFlag="N"

	var obj=document.getElementById('txtSeqNo');
	var SeqNo=obj.value;
	if(SeqNo=="") return;
	
	var obj=document.getElementById('MethodInsert');
	if(obj)
	{
		var objInsert=obj.value;
		var retStr=cspRunServerMethod(objInsert,PlanDR,FileName,ActiveFlag,SeqNo);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnAdd_click();
	}
	
}

function UpdateHandler()
{
	var obj=document.getElementById('txtPlanDR');
	var PlanDR=obj.value;
	if(PlanDR=="") return;

	var obj=document.getElementById('txtPlanItemDR');
	var PlanItemDR=obj.value;
	if(PlanItemDR=="") return;
	
	var obj=document.getElementById('txtFileName');
	var FileName=obj.value;
	if(FileName=="") return;
	
	var obj=document.getElementById('txtActiveFlag');
	var ActiveFlag=obj.value;
	if(ActiveFlag=="") return;
	if(ActiveFlag=="on") ActiveFlag="Y"
	else ActiveFlag="N"

	var obj=document.getElementById('txtSeqNo');
	var SeqNo=obj.value;
	if(SeqNo=="") return;
	
	var obj=document.getElementById('MethodUpdate');
	if(obj)
	{
		var objUpdate=obj.value;
		var retStr=cspRunServerMethod(objUpdate,PlanItemDR,PlanDR,FileName,ActiveFlag,SeqNo);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnUpdate_click();
	}
}

function DeleteHandler()
{
	var obj=document.getElementById('txtPlanItemDR');
	var PlanItemDR=obj.value;
	if(PlanItemDR=="") return;
	var obj=document.getElementById('MethodDelete');
	if(obj)
	{
		var objDelete=obj.value;
		var retStr=cspRunServerMethod(objDelete,PlanItemDR);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnDelete_click();
	}
}

function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCVISPlayPlanItemSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj1=document.getElementById('txtPlanDR');
	var obj2=document.getElementById('txtPlanItemDR');
	var obj3=document.getElementById('txtFileName');
	var obj4=document.getElementById('txtActiveFlag');
	var obj5=document.getElementById('txtSeqNo');
	
	var SelRowObj1=document.getElementById('PlanDRz'+selectrow);
	var SelRowObj2=document.getElementById('PlanItemDRz'+selectrow);
	var SelRowObj3=document.getElementById('FileNamez'+selectrow);
	var SelRowObj4=document.getElementById('ActiveFlagz'+selectrow);
	var SelRowObj5=document.getElementById('SeqNoz'+selectrow);
	
	if(obj1&&SelRowObj1) obj1.value=SelRowObj1.value;
	if(obj2&&SelRowObj2) obj2.value=SelRowObj2.value;
	if(obj3&&SelRowObj3) obj3.value=SelRowObj3.innerText;
	if(obj4&&SelRowObj4)
	{
		if(SelRowObj4.innerText=="Y") obj4.checked=true;
		else obj4.checked=false;
	}
	if(obj5&&SelRowObj5) obj5.value=SelRowObj5.innerText;

}
window.document.body.onload=BodyLoadHandler;