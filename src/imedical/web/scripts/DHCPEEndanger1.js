var CurRow=0
function BodyIni()
{
	var obj;
	obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_Click;
	obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
}
function BSave_Click()
{
	var EDID="",EDCode="",EDDesc="",encmeth="";
	obj=document.getElementById("SaveClass");
	if (obj){
		encmeth=obj.value;
		obj=document.getElementById("EDID");
		if (obj) EDID=obj.value;
		obj=document.getElementById("EDCode");
		if (obj) EDCode=obj.value;
		if (EDCode==""){
			alert("���벻��Ϊ��");
			return false;
		}
		obj=document.getElementById("EDDesc");
		if (obj) EDDesc=obj.value;
		if (EDDesc==""){
			alert("��������Ϊ��");
			return false;
		}
		var ret=cspRunServerMethod(encmeth,EDID,EDCode,EDDesc)
		if (ret=="0"){//�ɹ�
			parent.location.reload();
		}else{//ʧ��
			alert(ret);
		}
	}
}
function BDelete_Click()
{
	var EDID="",encmeth="";
	obj=document.getElementById("DeleteClass");
	if (obj){
		encmeth=obj.value;
		obj=document.getElementById("EDID");
		if (obj) EDID=obj.value;
		if (EDID==""){
			alert("ɾ�����ز���Ϊ��");
			return false;
		}
		var ret=cspRunServerMethod(encmeth,EDID)
		if (ret=="0"){//�ɹ�
			parent.location.reload();
		}else{//ʧ��
			alert(ret);
		}
	}
}
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//�����¼���
	var rowObj=getRow(eSrc);
	var Row=rowObj.rowIndex;
	var obj,tobj;
	if (Row==CurRow)
	{
		CurRow=0
		obj=document.getElementById("EDCode");
		if (obj) obj.value="";
		obj=document.getElementById("EDDesc");
		if (obj) obj.value="";
		obj=document.getElementById("EDID");
		if (obj) obj.value="";
		
	}
	else
	{
		CurRow=Row;
		
		obj=document.getElementById("EDCode");
		if (obj){
			tobj=document.getElementById("TEDCodez"+CurRow);
			if (tobj) obj.value=tobj.innerText;
		}
		obj=document.getElementById("EDDesc");
		if (obj){
			tobj=document.getElementById("TEDDescz"+CurRow);
			if (tobj) obj.value=tobj.innerText;
		}
		obj=document.getElementById("EDID");
		if (obj){
			tobj=document.getElementById("TEDIDz"+CurRow);
			if (tobj) obj.value=tobj.value;
		}
		
	}
	parent.frames('right').location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCPEEndangerItem&ParRef='+obj.value;
}
//ȥ���ַ������˵Ŀո�
function Trim(String)
{
	if (""==String) { return ""; }
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
document.body.onload = BodyIni;