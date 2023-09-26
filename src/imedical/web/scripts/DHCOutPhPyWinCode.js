//DHCOutPhPyWinCode
var SelectedRow = 0;
function BodyLoadHandler() {
	var baddobj=document.getElementById("Badd");
	if (baddobj) baddobj.onclick=Badd_click;
	var obj=document.getElementById("Bupdate");
	if (obj) obj.onclick=Bupdate_click;
	var userid=document.getElementById('userid').value;
	combo_DeptList=dhtmlXComboFromStr("CLocDesc","");
	combo_DeptList.enableFilteringMode(true);
	var encmeth=DHCC_GetElementData('getloc');
	var DeptStr=cspRunServerMethod(encmeth,userid)
	var Arr=DHCC_StrToArray(DeptStr);
	combo_DeptList.addOption(Arr);
}
function deplook(str) {

var obj=document.getElementById('depid');
var tem=str.split("^");
//alert(tem[1]);
obj.value=tem[1];

}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCOutPhPYWinCode');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('CLocDesc');
	var obj1=document.getElementById('CWinDesc');
	var obj2=document.getElementById('CPhlid');
	var obj3=document.getElementById('CSendCode');
	var obj4=document.getElementById('CBoxNum');
	var SelRowObj=document.getElementById('TLocDescz'+selectrow);
	var SelRowObj1=document.getElementById('TWinDescz'+selectrow);
	var SelRowObj2=document.getElementById('TPhlidz'+selectrow);
    var SelRowObj3=document.getElementById('TSendCodez'+selectrow);
    var SelRowObj4=document.getElementById('TBoxNumz'+selectrow);

    var LocIdobj=document.getElementById('TLocIdz'+selectrow);
	var LocId=LocIdobj.value;
	
	combo_DeptList.setComboValue(LocId);
	
	obj1.value=SelRowObj1.innerText;
	obj2.value=SelRowObj2.innerText;
	obj3.value=SelRowObj3.innerText;
	obj4.value=SelRowObj4.innerText;
	SelectedRow = selectrow;
}

function Bupdate_click()	
{
    var name=document.getElementById('CLocDesc').value;
    var userid=document.getElementById('userid').value;
    var boxnum=document.getElementById('CBoxNum').value;
    var sendcode=document.getElementById('CSendCode').value;
    var tname=document.getElementById('TLocDescz'+SelectedRow).innerText
   
   	var windesc=document.getElementById('CWinDesc').value;
    if (windesc=="") {
		alert(t['04']);
		return;}
		
    var phwid=document.getElementById('TPhPyWinz'+SelectedRow).value
    if (phwid=="") {
		alert(t['05']);
		return;}		
    var up=document.getElementById('up');
	if (up) {var encmeth=up.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,phwid,windesc,boxnum,sendcode)=='0') {alert(t['upok']); window.location.reload();}
	else 
	  alert(t['upfail'])	
			

}
function Badd_click()	
{
	selectrow=SelectedRow;
	var desc=document.getElementById('CLocDesc').value;
	if (desc=="") {
		alert(t['03'])
		return;}
	var phlid=combo_DeptList.getActualValue();

	if (phlid==""){
		alert("请选择药房科室!");
		return;
	}
    var windesc=document.getElementById('CWinDesc').value;
    if (windesc=="") {
		alert("窗口名称不能为空");
		return;}
	 var boxnum=document.getElementById('CBoxNum').value;
     var sendcode=document.getElementById('CSendCode').value;

    var pid=document.getElementById('ins');
	if (pid) {var encmeth=pid.value} else {var encmeth=''};
	p1=desc;
	p2=windesc;
var retval=cspRunServerMethod(encmeth,phlid,windesc,boxnum,sendcode)
    if (retval=="-2"){
	    alert("该窗口已存在")
	    }
	else
	if (retval!="0"){alert(t['07']);}
	else
	 {  window.location.reload();}
	

}
function getphl(value) 
{ 
	var sstr=value.split("^")
	var phlidobj=document.getElementById('CPhlid');
	phlidobj.value=sstr[1]
}
function GetListSelectText(ListName){
	var Val="";
	var obj=document.getElementById(ListName);
	if (obj) {
		if (obj.selectedIndex!=-1){Val=obj.options[obj.selectedIndex].text};
	}
	return Val;
}

function GetListSelectVal(ListName){
	var Val="";
	var obj=document.getElementById(ListName);
	if (obj) {
		if (obj.selectedIndex!=-1){Val=obj.options[obj.selectedIndex].value};
	}
	return Val;
}
document.body.onload = BodyLoadHandler;
