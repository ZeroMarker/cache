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
	var obj,ARCID="",encmeth="";
	obj=document.getElementById("ARCID");
	if (obj) ARCID=obj.value;
	if(ARCID=="")
	{
		alert("����ѡ��Ҫɾ���ļ�¼");
		return false;
	}
	obj=document.getElementById("DeleteClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ARCID);
	if (ret=="0"){
		window.location.reload();
	}
	
}
function BUpdate_click()
{
	var obj,ARCID="",Sort="",LocID="";
	obj=document.getElementById("ARCID");
	if (obj) ARCID=obj.value;
	
	obj=document.getElementById("Sort");
	if (obj) Sort=obj.value;
	
	if((ARCID=="")&&(Sort==""))
	{
		alert("��ѡ����Ŀ��¼�����");
		return false;
	}

	if (ARCID==""){
		alert("��Ŀ����Ϊ��,��ѡ����Ŀ");
		return false;
	}
	
	if (Sort==""){
	   alert("��Ų���Ϊ��,��¼�����");
		return false;
	}
	obj=document.getElementById("LocID");
	if (obj) LocID=obj.value;
	if (LocID==""){
		alert("û��ѡ�����");
		return false;
	}
	obj=document.getElementById("UpdateClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ARCID,Sort,LocID);
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
		var obj=document.getElementById("ARCID");
		if (obj) obj.value="";
		var obj=document.getElementById("ARCDesc");
		if (obj) obj.value="";
		var obj=document.getElementById("Sort");
		if (obj) obj.value="";
		CurrentSel="";
		return false;
	}else{
		CurrentSel=selectrow;
	}
	var obj=document.getElementById("ArcimIDz"+CurrentSel);
	var LocID=obj.value;
	var obj=document.getElementById("ARCID");
	if (obj) obj.value=LocID;
	var obj=document.getElementById("ARCIMDescz"+CurrentSel);
	var LocDesc=obj.innerText;
	var obj=document.getElementById("ARCDesc");
	if (obj) obj.value=LocDesc;
		var obj=document.getElementById("TSortz"+CurrentSel);
	var LocDesc=obj.innerText;
	var obj=document.getElementById("Sort");
	if (obj) obj.value=LocDesc;
}
function AfterSelectARCIM(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj=document.getElementById("ARCID");
	if (obj) obj.value=Arr[4];
	var obj=document.getElementById("ARCDesc");
	if (obj) obj.value=Arr[6];
}