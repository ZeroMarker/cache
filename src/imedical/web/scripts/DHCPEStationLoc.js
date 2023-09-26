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
	var obj,LocID="",encmeth="";
	obj=document.getElementById("LocID");
	if (obj) LocID=obj.value;
	if(LocID==""){
		alert("请先选择待删除的数据");
		return false;
	}

	obj=document.getElementById("DeleteLocClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,LocID);
	if (ret=="0"){
		window.location.reload();
	}
	
}


function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}


function BUpdate_click()
{
	var obj,ParRef="",LocID="",LocDesc="",LocSort="",encmeth="";
	obj=document.getElementById("ParRef");
	if (obj) ParRef=obj.value;
	if (ParRef==""){
		alert("请选择站点");
		return false;
	}
	obj=document.getElementById("LocID");
	if (obj) LocID=obj.value;
	obj=document.getElementById("LocDesc");
	if (obj) LocDesc=obj.value;
	if (LocDesc==""){
		alert("请录入科室名称");
		return false;
	}
	obj=document.getElementById("Sort");
	if (obj) LocSort=trim(obj.value);
	obj=document.getElementById("UpdateLocClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ParRef,LocID,LocDesc,LocSort);
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
		var obj=document.getElementById("LocID");
		if (obj) obj.value="";
		var obj=document.getElementById("LocDesc");
		if (obj) obj.value="";
		var obj=document.getElementById("Sort");
		if (obj) obj.value="";
		CurrentSel="";
		return false;
	}else{
		CurrentSel=selectrow;
	}
	var obj=document.getElementById("STL_RowIdz"+CurrentSel);
	var LocID=obj.value;
	var obj=document.getElementById("LocID");
	if (obj) obj.value=LocID;
	var obj=document.getElementById("STL_Descz"+CurrentSel);
	var LocDesc=obj.innerText;
	var obj=document.getElementById("LocDesc");
	if (obj) obj.value=LocDesc;
	var obj=document.getElementById("STL_Sortz"+CurrentSel);
	var LocDesc=obj.innerText;
	var obj=document.getElementById("Sort");
	if (obj) obj.value=LocDesc;
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEStationLocDetail&LocID="+LocID;
	parent.frames["stationlocdetail"].location.href=lnk;

}
