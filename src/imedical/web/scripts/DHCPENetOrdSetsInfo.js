var CurrentSel=0;
function BodyLoadHandler()
{
	var obj;
	obj=document.getElementById("BSave");
	if (obj) obj.onclick=BUpdate_click;
	obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_click;
	FillData();
}
function FillData()
{
	var OrdSetsID="",encmeth="",obj;
	obj=document.getElementById("HisSetsID");
	if (obj) OrdSetsID=obj.value;
	if (OrdSetsID=="") return false;
	obj=document.getElementById("GetOrdSetsInfo");
	if (obj) encmeth=obj.value;
	var LocID=session['LOGON.CTLOCID']
	var ret=cspRunServerMethod(encmeth,OrdSetsID,LocID);
	var Arr=ret.split("^");
	obj=document.getElementById("ID");
	if (obj) obj.value=Arr[0];
	obj=document.getElementById("Desc");
	if (obj) obj.value=Arr[1];
	obj=document.getElementById("Price");
	if (obj) obj.value=Arr[2];
	obj=document.getElementById("VIPLevel");
	if (obj) obj.value=Arr[3];
	obj=document.getElementById("Sex_DR_Name");
	if (obj) obj.value=Arr[4];
	obj=document.getElementById("Remark");
	if (obj) obj.value=Arr[5];
	obj=document.getElementById("Sort");
	if (obj) obj.value=Arr[6];
	obj=document.getElementById("GIFlag");
	if (obj){
		obj.checked=false;
		if (Arr[4]=="G") obj.checked=true;
	}
	obj=document.getElementById("Active");
	if (obj){
		obj.checked=false;
		if (Arr[8]=="Y") obj.checked=true;
	}
	ShowOtherFrame();
}
function BUpdate_click()
{
	var obj,encmeth="",HisSetsID="",ID="",Desc="",Price="",VIPLevel="",Sex="",Remark="",Sort="",GIFlag="I",LocID="",ActiceFlag="N";
	var LocID=session['LOGON.CTLOCID']
	obj=document.getElementById("ID");
	if (obj) ID=obj.value;
	obj=document.getElementById("Desc");
	if (obj) Desc=obj.value;
	obj=document.getElementById("Price");
	if (obj) Price=obj.value;
	obj=document.getElementById("VIPLevel");
	if (obj) VIPLevel=obj.value;
	
	if(VIPLevel=="")
	{
		alert("VIP等级不能为空");
		return false;
	}

	obj=document.getElementById("Sex_DR_Name");
	if (obj) Sex=obj.value;
	obj=document.getElementById("Remark");
	if (obj) Remark=obj.value;
	obj=document.getElementById("Sort");
	if (obj) Sort=obj.value;
	obj=document.getElementById("GIFlag");
	if (obj&&obj.checked){
		GIFlag="G"
	}
	obj=document.getElementById("HisSetsID");
	if (obj) HisSetsID=obj.value;
	
	obj=document.getElementById("Active");
	if (obj&&obj.checked) ActiceFlag="Y";
	if (VIPLevel==""){                 
		alert(t["01"]);
		return false;
	}
	var StrInfo=HisSetsID+"^"+Desc+"^"+Price+"^"+VIPLevel+"^"+Sex+"^"+Remark+"^"+Sort+"^"+GIFlag+"^"+LocID+"^"+ActiceFlag;
	obj=document.getElementById("SaveClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ID,StrInfo);
	var Arr=ret.split("^");
	if (Arr[0]=="-1"){
		alert(Arr[1]);
	}else{
		alert("保存成功");
		if (ID==""){
			obj=document.getElementById("ID");
			if (obj) obj.value=Arr[0];
			ShowOtherFrame();
		}
	}
}
function ShowOtherFrame()
{
	var obj,ID="";
	obj=document.getElementById("ID");
	if (obj) ID=obj.value;
	if (parent.frames["OrdSetsItemType"]){
		lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENetOrdSetsItemType&ParRef="+ID;
		parent.frames["OrdSetsItemType"].location.href=lnk;
	}
	if (parent.frames["OrdSetsItemDetail"]){
		lnk="websys.default.csp";
		parent.frames["OrdSetsItemDetail"].location.href=lnk;
	}
	if (parent.frames["OrdSetsItem"]){
		lnk="websys.default.csp";
		parent.frames["OrdSetsItem"].location.href=lnk;
	}
}
function BDelete_click()
{
	var obj,encmeth="",ID="";
	obj=document.getElementById("ID");
	if (obj) ID=obj.value;
	obj=document.getElementById("DeleteClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ID);
	
	if (ret=="0"){
		  alert("删除成功");
		 location.reload();
		obj=document.getElementById("ID");
		if (obj) obj.value="";
		ShowOtherFrame();
	}else{
		alert("无删除项"); 
	}
}

function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	//var objtbl=document.getElementById("tDHCPEPreTemplateTime");	
	//if (objtbl) { var rows=objtbl.rows.length; }
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	if (CurrentSel==selectrow)
	{
		CurrentSel=0;
	}
	else
	{
		CurrentSel=selectrow;
	}
	ShowCurRecord(CurrentSel);
}
function ShowCurRecord(SelectRow)
{
	var obj,tobj;
	if (SelectRow==0){
		obj=document.getElementById("ID");
		if (obj) obj.value="";
		obj=document.getElementById("LinkDetailID");
		if (obj) obj.value="";
		obj=document.getElementById("LinkDetail");
		if (obj) obj.value="";
		
	}else{
		obj=document.getElementById("ID");
		if (obj){
			tobj=document.getElementById("TIDz"+SelectRow);
			if (tobj) obj.value=tobj.value;
		}
		obj=document.getElementById("LinkDetailID");
		if (obj){
			tobj=document.getElementById("TLinkDetailIDz"+SelectRow);
			if (tobj) obj.value=tobj.value;
		}
		obj=document.getElementById("LinkDetail");
		if (obj){
			tobj=document.getElementById("TDetailDescz"+SelectRow);
			if (tobj) obj.value=tobj.innerText;
		}
	}
}
document.body.onload = BodyLoadHandler;