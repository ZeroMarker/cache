var CurrentSel=0;
function BodyLoadHandler()
{
	var obj;
	obj=document.getElementById("BSave");
	if (obj) obj.onclick=BUpdate_click;
	obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_click;
}

function BUpdate_click()
{
	var obj,encmeth="",ParRef="",ID="",ItemType="",Sort="";
	obj=document.getElementById("ID");
	if (obj) ID=obj.value;
	obj=document.getElementById("ItemType");
	if (obj) ItemType=obj.value;
	
	if(ItemType=="")
	{
		alert("��Ŀ���Ͳ���Ϊ��");
		return false;
	}

	obj=document.getElementById("Sort");
	if (obj) Sort=obj.value;
	
	if(Sort=="")
	{
		alert("��Ų���Ϊ��");
		return false;
	}

	obj=document.getElementById("ParRef");
	if (obj) ParRef=obj.value;
	if(ParRef == "") {
		alert("���ȱ��������ײ���Ϣ��");
		return false;
	}

	var StrInfo=ParRef+"^"+ItemType+"^"+Sort;
	obj=document.getElementById("SaveClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ID,StrInfo);
	var Arr=ret.split("^");
	if (Arr[0]=="-1"){
		alert(Arr[1]);
	}else{
		alert("����ɹ�");
		if (ID==""){
			obj=document.getElementById("ID");
			if (obj) obj.value=Arr[0];
			window.location.reload();
			ShowOtherFrame();
		}
	}
}
function ShowOtherFrame()
{
	var obj,ParRef="";
	obj=document.getElementById("ID");
	if (obj) ParRef=obj.value;
	if (parent.frames["OrdSetsItem"]){
		lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENetOrdSetsItem&ParRef="+ParRef;
		parent.frames["OrdSetsItem"].location.href=lnk;
	}
	if (parent.frames["OrdSetsItemDetail"]){
		lnk="websys.default.csp";
		parent.frames["OrdSetsItemDetail"].location.href=lnk;
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
		alert("ɾ���ɹ�");
		location.reload();
		obj=document.getElementById("ID");
		if (obj) obj.value="";
		ShowOtherFrame();
	}else{
		alert("ɾ��ʧ��:"+ret)
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
		obj=document.getElementById("ItemType");
		if (obj) obj.value="";
		obj=document.getElementById("Sort");
		if (obj) obj.value="";
		
	}else{
		obj=document.getElementById("ID");
		if (obj){
			tobj=document.getElementById("TIDz"+SelectRow);
			if (tobj) obj.value=tobj.value;
		}
		obj=document.getElementById("ItemType");
		if (obj){
			tobj=document.getElementById("TItemTypeIDz"+SelectRow);
			if (tobj) obj.value=tobj.value;
		}
		obj=document.getElementById("Sort");
		if (obj){
			tobj=document.getElementById("TSortz"+SelectRow);
			if (tobj) obj.value=tobj.innerText;
		}
	}
	ShowOtherFrame();
}
document.body.onload = BodyLoadHandler;