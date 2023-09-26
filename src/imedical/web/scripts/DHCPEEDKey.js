var CurrentSel=""
document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	var obj;
	obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_click;
}
function BDelete_click()
{
	var obj,ID="",encmeth="";
	obj=document.getElementById("ID");
	if (obj) ID=obj.value;
	obj=document.getElementById("DeleteClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ID);
	if (ret=="0"){
		window.location.reload();
	}
	
}
function BUpdate_click()
{
	var obj,ID="",Desc="",Color="",encmeth="";
	obj=document.getElementById("ID");
	if (obj) ID=obj.value;
	obj=document.getElementById("Desc");
	if (obj) Desc=obj.value;
	if (Desc==""){
		alert("请录入建议关键词");
		return false;
	}
	obj=document.getElementById("Color");
	if (obj) Color=obj.value;
	
	obj=document.getElementById("UpdateClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ID,Desc,Color);
	if (ret=="0"){
		window.location.reload();
	}
	
}
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	if (selectrow==CurrentSel){
		var obj=document.getElementById("ID");
		if (obj) obj.value="";
		var obj=document.getElementById("Desc");
		if (obj) obj.value="";
		var obj=document.getElementById("Color");
		if (obj) obj.value="";
		CurrentSel="";
		return false;
	}else{
		CurrentSel=selectrow;
	}
	var obj=document.getElementById("TIDz"+CurrentSel);
	var ID=obj.value;
	var obj=document.getElementById("ID");
	if (obj) obj.value=ID;
	var obj=document.getElementById("TDescz"+CurrentSel);
	var LocDesc=obj.innerText;
	var obj=document.getElementById("Desc");
	if (obj) obj.value=LocDesc;
	var obj=document.getElementById("TColorz"+CurrentSel);
	var LocDesc=obj.innerText;
	var obj=document.getElementById("Color");
	if (obj) obj.value=LocDesc;
}
