//DHCOutPhPFWin
var SelectedRow = 0;
function BodyLoadHandler() {
	var baddobj=document.getElementById("Badd");
	if (baddobj) baddobj.onclick=Badd_click;
	var obj=document.getElementById("Bupdate");
	if (obj) obj.onclick=Bupdate_click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_click;
	var userid=document.getElementById("userid").value;
	var ctloc=document.getElementById("ctloc").value;
	combo_DeptList=dhtmlXComboFromStr("CLocDesc","");
	combo_DeptList.enableFilteringMode(true);
	var encmeth=DHCC_GetElementData('getloc');
	combo_DeptList.optionsArr=new Array();
	var DeptStr=cspRunServerMethod(encmeth,userid)
	var Arr=DHCC_StrToArray(DeptStr);
	combo_DeptList.addOption(Arr);
	combo_DeptList.selectHandle=SetWinInfo;
	combo_FyWin=dhtmlXComboFromStr("CFyWinDesc","");
	combo_FyWin.enableFilteringMode(true);
	var encmeth=DHCC_GetElementData('getfywin');
	var DeptStr=cspRunServerMethod(encmeth,ctloc)
	var Arr=DHCC_StrToArray(DeptStr);
	combo_FyWin.addOption(Arr);
	combo_PyWin=dhtmlXComboFromStr("CPyWinDesc","");
	combo_PyWin.enableFilteringMode(true);
	var encmeth=DHCC_GetElementData('getpywin');
	var DeptStr=cspRunServerMethod(encmeth,ctloc)
	var Arr=DHCC_StrToArray(DeptStr);
	combo_PyWin.addOption(Arr);	
}


function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCOutPhPFWin');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('CLocDesc');
	var obj1=document.getElementById('CFyWinDesc');
	var obj2=document.getElementById('CFyWinID');
	var obj3=document.getElementById('CPyWinDesc');
	var obj4=document.getElementById('rowid');
	var SelRowObj=document.getElementById('TLocDescz'+selectrow);
	var SelRowObj1=document.getElementById('TFyWinDescz'+selectrow);
	var SelRowObj2=document.getElementById('TPhwidz'+selectrow);
    var SelRowObj3=document.getElementById('TPyWinDescz'+selectrow);
    var SelRowObj4=document.getElementById('TPyWinIDz'+selectrow);
    
	obj.value=SelRowObj.innerText;
	obj1.value=SelRowObj1.innerText;
	obj2.value=SelRowObj2.value;
	obj3.value=SelRowObj3.innerText;
	obj4.value=SelRowObj4.value;
	SelectedRow = selectrow;
}

function Bupdate_click()	
{
    var userid=document.getElementById('userid').value;
   var name=combo_DeptList.getSelectedText();
   
   	var windesc=combo_FyWin.getSelectedValue();
    if (windesc=="") {
		alert(t['04']);
		return;}
		
    var phwid=combo_PyWin.getSelectedValue();
    if (phwid=="") {
		alert(t['05']);
		return;}		
    var up=document.getElementById('up');
	if (up) {var encmeth=up.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,phwid,windesc)=='0') {alert(t['delok']); window.location.reload();}
	else 
	  alert(t['delfail'])	
			
}
function BDelete_click()	
{
   var rowid=document.getElementById('rowid').value;
   if (rowid=="") {alert(t['selfail']);return;}
    var up=document.getElementById('del');
	if (up) {var encmeth=up.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,rowid)=='0') {alert(t['delok']); window.location.reload(); window.location.reload();}
	else 
	  alert(t['delfail'])	
			
}
function Badd_click()	
{
	selectrow=SelectedRow;
	var desc=combo_DeptList.getSelectedText();
	if (desc=="") {
		alert(t['03'])
		return;}
	var ctloc=combo_DeptList.getSelectedValue();
    var pywin=combo_PyWin.getSelectedValue();
    if (pywin=="") {
		alert(t['09'])
		return;} 
    var fywin=combo_FyWin.getSelectedValue();
    if (fywin=="") {
		alert("发药窗口不能为空")
		return;} 
    var pid=document.getElementById('ins');
	if (pid) {var encmeth=pid.value} else {var encmeth=''};
	var retval=cspRunServerMethod(encmeth,ctloc,fywin,pywin)
	if (retval!="0"){
		if (retval=="-1"){
			alert("此发药窗口已经配置,不能再重复配置!")
			return;
		}
		else{
			alert(t['07']);
		}
	}
	else
	 { alert(t['08']); window.location.reload();}
	

}
function getphl(value) 
{ 
	var sstr=value.split("^")
	var phlidobj=document.getElementById('CPhlid');
	phlidobj.value=sstr[1]
}
function fywin(value) 
{ 
	var sstr=value.split("^")
	var phlidobj=document.getElementById('CFyWinID');
	phlidobj.value=sstr[1]
}
function pywin(value) 
{ 
	var sstr=value.split("^")
	var phlidobj=document.getElementById('CPyWinID');
	phlidobj.value=sstr[1]
}
function SetWinInfo()
{
	newctloc=combo_DeptList.getSelectedValue();
    combo_FyWin.optionsArr=new Array();
    combo_FyWin.redrawOptions();
    combo_PyWin.optionsArr=new Array();
    combo_PyWin.redrawOptions();
	var encmeth=DHCC_GetElementData('getfywin');
	var DeptStr=cspRunServerMethod(encmeth,newctloc)
	var Arr=DHCC_StrToArray(DeptStr);
	combo_FyWin.addOption(Arr);
	var encmeth=DHCC_GetElementData('getpywin');
	var DeptStr=cspRunServerMethod(encmeth,newctloc)
	var Arr=DHCC_StrToArray(DeptStr);
	combo_PyWin.addOption(Arr);

}

document.body.onload = BodyLoadHandler;