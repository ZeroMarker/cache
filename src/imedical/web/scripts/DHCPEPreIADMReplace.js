/// DHCPEPreIADMReplace.js

var CurrentSel=0

function BodyLoadHandler() {
   
	var obj;
	obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_click;
	obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_click;
	obj=document.getElementById("RegNo");
	if (obj){
		obj.onchange=RegNo_change;
		obj.onkeydown=RegNo_keydown;
	}
}
function RegNo_change()
{
	var obj,RegNo="",encmeth="";
	obj=document.getElementById("RegNo");
	if (obj) RegNo=obj.value;
	obj=document.getElementById("GetBaseInfoByRegNoClass");
	if (obj) encmeth=obj.value;
	var BaseInfo=cspRunServerMethod(encmeth,RegNo);
	var Arr=BaseInfo.split("^");
	obj=document.getElementById("PatID");
	if (obj) obj.value=Arr[0];
	obj=document.getElementById("RegNo");
	if (obj) obj.value=Arr[1];
	obj=document.getElementById("Name");
	if (obj) obj.value=Arr[2];
	obj=document.getElementById("Sex");
	//if (obj) obj.value=Arr[3].split("")[0];
	if((Arr[3]==""&&obj)) obj.value="";
	if (obj&&Arr[3]!="") obj.value=Arr[3];
	obj=document.getElementById("Marital");
	if (obj) obj.value=Arr[4];
	obj=document.getElementById("IDCard");
	if (obj) obj.value=Arr[5];
}
function RegNo_keydown(e)
{
	var Key=websys_getKey(e);
	if ((9==Key)||(13==Key)) {
		RegNo_change();
	}
}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
function BSave_click() { 
    var obj,PreIADM="",RegNo="",Remark="",encmeth="";
    obj=document.getElementById("PreIADM");
    if (obj) PreIADM=obj.value;
    obj=document.getElementById("RegNo");
    if (obj) RegNo=obj.value;
    if (""==RegNo) {
		obj=document.getElementById("RegNo")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("替换后的信息不能为空,请输入替换人的登记号按回车");
		return false;
	}

    obj=document.getElementById("Remark");
    if (obj) Remark=obj.value;
    var UserID=session['LOGON.USERID'];
    obj=document.getElementById("SaveClass");
    if (obj) encmeth=obj.value;
    var Str=PreIADM+"^"+RegNo+"^"+Remark+"^"+UserID;
    var ret=cspRunServerMethod(encmeth,Str);
    var Arr=ret.split("^");
    if (Arr[0]<0){
	    alert(Arr[1]);
	    return false;
    }
    if (opener) opener.location.reload();
    BClose_click();
}
function BClose_click()
{
	//if (opener) opener.location.reload();
	window.close();
}

document.body.onload = BodyLoadHandler;