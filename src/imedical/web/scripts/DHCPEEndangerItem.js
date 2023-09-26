var CurRow=0
function BodyIni()
{
	var obj;
	obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_Click;
	obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	obj=document.getElementById("ArcimDesc");
	if (obj) obj.onchange=ArcimDesc_change;
	obj=document.getElementById("SetsDesc");
	if (obj) obj.onchange=SetsDesc_change;
}
function BSave_Click()
{
	var ID="",ParRef="",ArcimID="",SetsID="",SetsFlag="N",NeedFlag="N",encmeth="";
	obj=document.getElementById("SaveClass");
	if (obj){
		encmeth=obj.value;
		obj=document.getElementById("ID");
		if (obj) ID=obj.value;
		obj=document.getElementById("ParRef");
		if (obj) ParRef=obj.value;
		if (ParRef==""){
			alert("请先选择危害因素");
			return false;
		}
		obj=document.getElementById("ArcimID");
		if (obj) ArcimID=obj.value;
		obj=document.getElementById("SetsID");
		if (obj) SetsID=obj.value;
		
		if ((ArcimID=="")&&(SetsID=="")){
			alert("项目不能为空");
			return false;
		}
		if (ArcimID==""){
			SetsFlag="Y";
			ArcimID=SetsID;
		}
		
		obj=document.getElementById("NeedFlag");
		if (obj&&obj.checked) NeedFlag="Y";
		var ret=cspRunServerMethod(encmeth,ParRef,ID,ArcimID,SetsFlag,NeedFlag)
		if (ret=="0"){//成功
			location.reload();
		}else{//失败
			alert(ret);
		}
	}
}
function BDelete_Click()
{
	var ID="",encmeth="";
	obj=document.getElementById("DeleteClass");
	if (obj){
		encmeth=obj.value;
		obj=document.getElementById("ID");
		if (obj) ID=obj.value;
		if (ID==""){
			alert("删除项目不能为空");
			return false;
		}
		var ret=cspRunServerMethod(encmeth,ID)
		if (ret=="0"){//成功
			location.reload();
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
		obj=document.getElementById("ID");
		if (obj) obj.value="";
		obj=document.getElementById("ArcimID");
		if (obj) obj.value="";
		obj=document.getElementById("ArcimDesc");
		if (obj) obj.value="";
		obj=document.getElementById("NeedFlag");
		if (obj) obj.checked=false;
	}
	else
	{
		CurRow=Row;
		
		obj=document.getElementById("ID");
		if (obj){
			tobj=document.getElementById("TIDz"+CurRow);
			if (tobj) obj.value=tobj.value;
		}
		obj=document.getElementById("ArcimID");
		if (obj){
			tobj=document.getElementById("TArcimIDz"+CurRow);
			if (tobj) obj.value=tobj.value;
		}
		obj=document.getElementById("ArcimDesc");
		if (obj){
			tobj=document.getElementById("TArcimDescz"+CurRow);
			if (tobj) obj.value=Trim(tobj.innerText);
		}
		obj=document.getElementById("SetsID");
		if (obj){
			tobj=document.getElementById("TSetsIDz"+CurRow);
			if (tobj) obj.value=tobj.value;
		}
		obj=document.getElementById("SetsDesc");
		if (obj){
			tobj=document.getElementById("TSetsDescz"+CurRow);
			if (tobj) obj.value=Trim(tobj.innerText);
		}
		obj=document.getElementById("NeedFlag");
		if (obj){
			tobj=document.getElementById("TNeedFlagz"+CurRow);
			if (tobj) obj.checked=tobj.checked;
		}
	}
}
function ArcimAfter(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj;
	obj=document.getElementById("ArcimID");
	if (obj) obj.value=Arr[2];
	obj=document.getElementById("ArcimDesc");
	if (obj) obj.value=Arr[1];
	obj=document.getElementById("SetsID");
	if (obj) obj.value="";
	obj=document.getElementById("SetsDesc");
	if (obj) obj.value="";
}
function ArcimDesc_change()
{
	var obj;
	obj=document.getElementById("ArcimID");
	if (obj) obj.value="";
}
function SetsAfter(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj;
	obj=document.getElementById("ArcimID");
	if (obj) obj.value="";
	obj=document.getElementById("ArcimDesc");
	if (obj) obj.value="";
	
	obj=document.getElementById("SetsID");
	if (obj) obj.value=Arr[0];
	obj=document.getElementById("SetsDesc");
	if (obj) obj.value=Arr[1];
}
function SetsDesc_change()
{
	var obj;
	obj=document.getElementById("SetsID");
	if (obj) obj.value="";
}
//去除字符串两端的空格
function Trim(String)
{
	if (""==String) { return ""; }
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
document.body.onload = BodyIni;