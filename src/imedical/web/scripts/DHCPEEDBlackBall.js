document.body.onload = BodyLoadHandler;
var CurrentSel=0
function BodyLoadHandler()
{
	var obj;
	obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_click;
	obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_click;
}
function BAdd_click()
{
	var Parref=GetValue("Parref");
	if (Parref=="") return false;
	var ID=GetValue("ID");
	var EDID=GetValue("EDID");
	if (EDID==""){
		alert("请先选择建议");
		return false;
	}
	if (Parref==EDID){
		alert("源建议和排斥建议不能相同");
		return false;
	}
	var encmeth=GetValue("InsertCls");
	//alert(ID)
	//alert(Parref)
	//alert(EDID)
	var ret=cspRunServerMethod(encmeth,ID,Parref,EDID)
	if (ret==0){
		window.location.reload();
	}else{
		alert("更新错误"+ret);
		return false;
	}
}
function BDelete_click()
{
	var ID=GetValue("ID");
	if (ID==""){
		alert("ID不能为空")
		return false;
	}
	var encmeth=GetValue("DelCls");
	var ret=cspRunServerMethod(encmeth,ID)
	if (ret==0){
		window.location.reload();
	}else{
		alert("删除错误"+ret);
		return false;
	}
}
function GetObj(ElementName)
{
	return document.getElementById(ElementName);
}
function GetValue(ElementName)
{
	var Value="";
	var obj=GetObj(ElementName);
	if (obj) Value=obj.value;
	return Value;
}
function SetValue(ElementName,Value)
{
	var obj=GetObj(ElementName);
	if (obj) obj.value=Value;
}
function GetEDiagnosis(Value)
{
	if (Value=="") return false;
	
	var Arr=Value.split("^");
	SetValue("EDID",Arr[0]);
	SetValue("Code",Arr[3]);
	SetValue("Desc",Arr[1]);
	SetValue("Detail",Arr[2]);
}
function SelectRowHandler() {

	var eSrc=window.event.srcElement;

	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	    
	if (selectrow==CurrentSel) {
		
		
		CurrentSel=0
	}else{

		CurrentSel=selectrow;
	}
	ShowCurRecord(CurrentSel);

}
function ShowCurRecord(SelRow)
{
	
	var obj,Value="";
	obj=document.getElementById("TIDz"+SelRow);
	if (obj) Value=obj.value;
	SetValue("ID",Value);
	Value="";
	obj=document.getElementById("TCodez"+SelRow);
	if (obj) Value=obj.innerText;
	SetValue("Code",Value);
	Value="";
	obj=document.getElementById("TDescz"+SelRow);
	if (obj) Value=obj.innerText;
	SetValue("Desc",Value);
	Value="";
	obj=document.getElementById("TDetailz"+SelRow);
	if (obj) Value=obj.innerText;
	SetValue("Detail",Value);
	Value="";
	obj=document.getElementById("TEDIDz"+SelRow);
	if (obj) Value=obj.value;
	SetValue("EDID",Value);
}