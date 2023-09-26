//DHCOutPhWinCode
var SelectedRow = 0;
function BodyLoadHandler() {
	var objtbl=document.getElementById('tDHCOutPhWinCode');
	var baddobj=document.getElementById("Badd");
	if (baddobj) baddobj.onclick=Badd_click;
	var obj=document.getElementById("Bupdate");
	if (obj) obj.onclick=Bupdate_click;
	var userid=document.getElementById("userid").value;
    
	combo_DeptList=dhtmlXComboFromStr("Desc","");
	combo_DeptList.enableFilteringMode(true);
	var encmeth=DHCC_GetElementData('getloc');
	var DeptStr=cspRunServerMethod(encmeth,userid)
	var Arr=DHCC_StrToArray(DeptStr);
	
	combo_DeptList.addOption(Arr);
	 
	combo_DeptList.setComboValue(document.getElementById('ctloc').value)
	combo_WinTypeList=dhtmlXComboFromStr("CWinType","");
	combo_WinTypeList.enableFilteringMode(true);
	
	var encmeth=DHCC_GetElementData('gettype');
	var DeptStr=cspRunServerMethod(encmeth)
	
	var Arr=DHCC_StrToArray(DeptStr);
	combo_WinTypeList.addOption(Arr);

	
	var obj=document.getElementById("setlocwin");
	if (obj) obj.onclick=OpenLocWin;

}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	 objtbl=document.getElementById('tDHCOutPhWinCode');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('Desc');
	var obj1=document.getElementById('CWinDesc');
	var obj2=document.getElementById('CSureFlag');
	var obj3=document.getElementById('CNoUseFlag');
	var obj4=document.getElementById('CPhwid');
	var obj5=document.getElementById('CWinType');
	var SelRowObj=document.getElementById('TLocDescz'+selectrow);
	var SelRowObj1=document.getElementById('TWinDescz'+selectrow);
	var SelRowObj2=document.getElementById('TSureFlagz'+selectrow);
	var SelRowObj3=document.getElementById('TNoUseFlagz'+selectrow);
    var SelRowObj4=document.getElementById('TPhwidz'+selectrow);
    var SelRowObj5=document.getElementById('TWinTypez'+selectrow);
	obj.value=SelRowObj.innerText;
	obj1.value=SelRowObj1.innerText;
	combo_WinTypeList.setComboText(SelRowObj5.innerText)
	if (SelRowObj2.innerText=="是"){obj2.checked=true}
	else
	 {obj2.checked=false}
	if (SelRowObj3.innerText=="是"){obj3.checked=true}
	 else
	 {obj3.checked=false}
	
    obj4.value=SelRowObj4.value;
	SelectedRow = selectrow;
}

function Bupdate_click()	
{
	selectrow=SelectedRow;
    //var name=document.getElementById('Desc').value;
    var userid=document.getElementById('userid').value;
    //var tname=document.getElementById('TLocDescz'+selectrow).innerText

   if (selectrow=="0"){
	    alert("请先选择一条记录!");
		return;
   }
   
	var windesc=document.getElementById('CWinDesc').value;
    if (windesc=="") {
		alert("窗口不能为空");
		return;}
		
    var phwid=document.getElementById('CPhwid').value;
    if (phwid=="") {
		alert(t['nowinid']);
		return;}		
    var py=document.getElementById('CSureFlag').checked;
    var fy=document.getElementById('CNoUseFlag').checked;
    if (py==true){py="1"}
    else {py="0"}
    if (fy==true){fy="1"}
    else {fy="0"}
    var wintype=combo_WinTypeList.getSelectedValue()
    var TypeFlag=0;
    var TypeFlagObj=document.getElementById('TypeFlag')
    if (TypeFlagObj) {
	    if (TypeFlagObj.checked)
	    {TypeFlag=1;}
    }
    
    var ValueString=TypeFlag+"^"
    
    var up=document.getElementById('up');
	if (up) {var encmeth=up.value} else {var encmeth=''};
	
	if (cspRunServerMethod(encmeth,'SetPid','',phwid,windesc,py,fy,userid,wintype,ValueString)=='0') {
			}

}
function Badd_click()	
{
	selectrow=SelectedRow;
	var desc=combo_DeptList.getActualValue();
	
	
    var windesc=document.getElementById('CWinDesc').value;
    if (windesc=="") {
		alert("窗口不能为空");
		return;}

    var py=document.getElementById('CSureFlag').checked;
    var fy=document.getElementById('CNoUseFlag').checked;
    if (py==true){py="1"}
    else {py="0"}
    if (fy==true){fy="1"}
    else {fy="0"}
   
     var pid=document.getElementById('ins');
	if (pid) {var encmeth=pid.value} else {var encmeth=''};
	p1=desc;
	p3=py;
	p4=fy;
	p2=windesc;
	var wintype=combo_WinTypeList.getActualValue()
	if (cspRunServerMethod(encmeth,'SetPid','',p1,p2,p3,p4,wintype)=='0') {
	}

}
function SetPid(value) 
{  
   ///liangqiang 2014-12-20

	if (value=="-1")
	{

	  alert("已有默认窗口!");
	  window.location.reload();
	  return;
	}
	
	if (value=="-2")
	{

	  alert("该用户不在相应的药房人员列表中!");
	　window.location.reload();
	  return;
	}
	
	if (value!="0")
	{alert("操作失败!");
	 window.location.reload();
	return;
		}
		
	try {		   
	    
	    window.location.reload();
		} catch(e) {};
}


function OpenLocWin()
{
	if (!SelectedRow) {alert("请先选择记录");return;}
	if (SelectedRow<1) {alert("请先选择记录");return;}
	
	var LocObj=document.getElementById('TLocDescz'+SelectedRow);
	if (LocObj) Loc=LocObj.innerText;
	
	var WinObj=document.getElementById('TWinDescz'+SelectedRow);
	if (WinObj) Win=WinObj.innerText;
	
	var PhwidObj=document.getElementById('TPhwidz'+SelectedRow);
	if (PhwidObj) PhwinId=PhwidObj.value;
	
	var info=Loc+"  "+Win
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhLocWinConfig"+"&locInfo="+info+"&phwid="+PhwinId
    window.open(lnk,"_target","height=600,width=900,menubar=no,status=yes,toolbar=no,resizable=yes") ;
}

document.body.onload = BodyLoadHandler;
