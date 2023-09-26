
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
	var obj=document.getElementById('txtMessCatDesc');
	var MessCatDesc=obj.value;
	if(MessCatDesc==" ") MessCatDesc="";
	if(MessCatDesc=="") return;
	
	var obj=document.getElementById('txtMessCatCode');
	var MessCatCode=obj.value;
	if(MessCatCode==" ") MessCatCode="";
	if(MessCatCode=="") return;
	
	var MessCatActive="N";
	var obj=document.getElementById('chkMessCatActive');
	if(obj.checked) MessCatActive="Y";
	
	var obj=document.getElementById('txtMessCatNote');
	var MessCatNote=obj.value;
	if(MessCatNote==" ") MessCatNote="";
	
	var obj=document.getElementById('MethodInsert');
	if(obj)
	{
		var objInsert=obj.value;
		var retStr=cspRunServerMethod(objInsert,MessCatDesc,MessCatCode,MessCatActive,MessCatNote);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnAdd_click();
	}
	
}

function UpdateHandler()
{
	var obj=document.getElementById('txtMessCatRowId');
	var MessCatRowId=obj.value;
	if(MessCatRowId=="") return;
	
	var obj=document.getElementById('txtMessCatDesc');
	var MessCatDesc=obj.value;
	if(MessCatDesc==" ") MessCatDesc="";
	if(MessCatDesc=="") return;
	
	var obj=document.getElementById('txtMessCatCode');
	var MessCatCode=obj.value;
	if(MessCatCode==" ") MessCatCode="";
	if(MessCatCode=="") return;
	
	var MessCatActive="N";
	var obj=document.getElementById('chkMessCatActive');
	if(obj.checked) MessCatActive="Y";
	
	var obj=document.getElementById('txtMessCatNote');
	var MessCatNote=obj.value;
	if(MessCatNote==" ") MessCatNote="";
	
	var obj=document.getElementById('MethodUpdate');
	if(obj)
	{
		var objUpdate=obj.value;
		var retStr=cspRunServerMethod(objUpdate,MessCatRowId,MessCatDesc,MessCatCode,MessCatActive,MessCatNote);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnUpdate_click();
	}
	
}

function DeleteHandler()
{
	var obj=document.getElementById('txtMessCatRowId');
	var MessCatRowId=obj.value;
	if(MessCatRowId=="") return;
	var obj=document.getElementById('MethodDelete');
	if(obj)
	{
		var objDelete=obj.value;
		var retStr=cspRunServerMethod(objDelete,MessCatRowId);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnDelete_click();
	}
}

function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCMessageCategory');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('txtMessCatRowId');
	var obj1=document.getElementById('txtMessCatDesc');
	var obj2=document.getElementById('txtMessCatCode');
	var obj3=document.getElementById('txtMessCatNote');
	var obj4=document.getElementById('chkMessCatActive');
	
	var SelRowObj=document.getElementById('MessCatRowIdz'+selectrow);
	var SelRowObj1=document.getElementById('MessCatDescz'+selectrow);
	var SelRowObj2=document.getElementById('MessCatCodez'+selectrow);
	var SelRowObj3=document.getElementById('MessCatNotez'+selectrow);
	var SelRowObj4=document.getElementById('MessCatActivez'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText;
	if(obj1&&SelRowObj1) obj1.value=SelRowObj1.innerText;
	if(obj2&&SelRowObj2) obj2.value=SelRowObj2.innerText;
	if(obj3&&SelRowObj3) obj3.value=SelRowObj3.innerText;
	if(obj4&&SelRowObj4)
	{
		if(SelRowObj4.innerText=="Y") obj4.checked=true;
		else obj4.checked=false;
	}
}
function ServerSelect(str){
	var ret=str.split("^");
	var obj=document.getElementById('txtServerName');
	if (obj) obj.value=ret[2]
	var obj=document.getElementById('txtServerId');
	if (obj) obj.value=ret[0]
}
window.document.body.onload=BodyLoadHandler;