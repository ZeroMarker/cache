//DHCANCOPCountTypeDefault.JS
function BodyLoadHandler(){
	var objtbl=document.getElementById('tDHCANCOPCountTypeDefault');
	for (var i=1;i<objtbl.rows.length;i++)
	{
       	var	obj=document.getElementById('PreOperNumz'+i);
       	if (obj) obj.onkeydown=UpdateKeyDown;
	}
}

function UpdateKeyDown(){
	if (window.event.keyCode!=13) return;
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selrow=rowObj.rowIndex;
	if (selrow=="") return;
	var TypeId=document.getElementById("TypeId").value;
	var SeqNo=document.getElementById('SeqNoz'+selrow).innerText;
	if ((TypeId=="")||(SeqNo=="")) return;
	var CountItemId=document.getElementById('OPCountIdz'+selrow).value;
	var PreOperNum=document.getElementById('PreOperNumz'+selrow).value;
	var para=CountItemId+"!"+PreOperNum;
	var objSaveTypeSelDefVal=document.getElementById('SaveTypeSelDefVal')
	if(objSaveTypeSelDefVal){
		var ret=cspRunServerMethod(objSaveTypeSelDefVal.value,TypeId,SeqNo,para);
		//alert(ret);
		window.location.reload();
	}
}



document.body.onload=BodyLoadHandler;