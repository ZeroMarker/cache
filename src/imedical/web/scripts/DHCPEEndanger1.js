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
			alert("编码不能为空");
			return false;
		}
		obj=document.getElementById("EDDesc");
		if (obj) EDDesc=obj.value;
		if (EDDesc==""){
			alert("描述不能为空");
			return false;
		}
		var ret=cspRunServerMethod(encmeth,EDID,EDCode,EDDesc)
		if (ret=="0"){//成功
			parent.location.reload();
		}else{//失败
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
			alert("删除因素不能为空");
			return false;
		}
		var ret=cspRunServerMethod(encmeth,EDID)
		if (ret=="0"){//成功
			parent.location.reload();
		}else{//失败
			alert(ret);
		}
	}
}
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
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
//去除字符串两端的空格
function Trim(String)
{
	if (""==String) { return ""; }
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
document.body.onload = BodyIni;