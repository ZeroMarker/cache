// DHCOutPhPYPrint
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
	var DeptStr=cspRunServerMethod(encmeth,userid)
	var Arr=DHCC_StrToArray(DeptStr);
	combo_DeptList.addOption(Arr);
	var obj=document.getElementById("BRetrieve");
	if (obj) obj.onclick= Retrieve_Click;
	combo_PyWin=dhtmlXComboFromStr("CPyWinDesc","");
	combo_PyWin.enableFilteringMode(true);
	var encmeth=DHCC_GetElementData('getpywin');

	var DeptStr=cspRunServerMethod(encmeth,ctloc)
	var Arr=DHCC_StrToArray(DeptStr);
	combo_PyWin.addOption(Arr);
	
	
	obj=document.getElementById("CLocDesc");
	if (obj) obj.onblur=GetLocWinData;
	
	
}

function GetLocWinData()
{
	combo_PyWin.clearAll(true);
	var loc=combo_DeptList.getSelectedValue();
	if (loc=="")return;
	var encmeth=DHCC_GetElementData('getpywin');
	var DeptStr=cspRunServerMethod(encmeth,loc)
	var Arr=DHCC_StrToArray(DeptStr);
	
	combo_PyWin.addOption(Arr);
}


function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCOutPhPYPrint');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('CLocDesc');
	var obj1=document.getElementById('CPhlid');
	var obj2=document.getElementById('CPyWinID');
	var obj3=document.getElementById('CPyWinDesc');
	var obj5=document.getElementById('rowid');
	var obj4=document.getElementById('CPrintDesc');
	var SelRowObj=document.getElementById('TLocDescz'+selectrow);
	var SelRowObj1=document.getElementById('TPhlidz'+selectrow);
	var SelRowObj4=document.getElementById('TPrintNamez'+selectrow);
    var SelRowObj3=document.getElementById('TPyWinDescz'+selectrow);
    var SelRowObj2=document.getElementById('TPyWinIDz'+selectrow);
    var SelRowObj5=document.getElementById('TPrintRowIDz'+selectrow);
    var SelRowObj6=document.getElementById('TCurrPrintz'+selectrow);
    var SelRowObj7=document.getElementById('TPrintCancelz'+selectrow); 
    combo_DeptList.setComboText(SelRowObj.innerText);
    
    GetLocWinData();
	//obj.value=SelRowObj.innerText;
	obj1.value=SelRowObj1.innerText;
	obj2.value=SelRowObj2.value;
	//obj3.value=SelRowObj3.innerText;
	
	combo_PyWin.setComboText(SelRowObj3.innerText);
	obj4.value=SelRowObj4.innerText;
	obj5.value=SelRowObj5.value;
	if (SelRowObj6.innerText==t['01']){ document.getElementById('CCurrPrint').checked=true;}
	if (SelRowObj7.innerText==t['01']){ document.getElementById('CPrintCancel').checked=true;}
	SelectedRow = selectrow;
	
	

	
	
}

function Bupdate_click()	
{
    var userid=document.getElementById('userid').value;
    var name=combo_DeptList.getSelectedText();
	var loc=combo_DeptList.getSelectedValue()
    var phwid=combo_PyWin.getSelectedValue();
    
      if (phwid=="") {
	      
	    if (SelectedRow!=0){
		    alert("该药房没有此窗口,请确认!")
		    return;
	    }
	    
		alert("请先选择记录!");
		return;
		}
	if (loc=="") {
		alert("该用户可登录科室无该药房,请确认!");
		
		return;
		}
		var curflag=0
		var cancelflag=0
	var printrow=document.getElementById('rowid').value;
	var printname=document.getElementById('CPrintDesc').value;		
    if ( document.getElementById('CCurrPrint').checked==true){var curflag="1";}
	if ( document.getElementById('CPrintCancel').checked==true){var cancelflag="1";}   	
    var up=document.getElementById('up');
	if (up) {var encmeth=up.value} else {var encmeth=''};
	var oldphloc=document.getElementById('TPhlidz'+SelectedRow).value;
	var oldphwid=document.getElementById('TPyWinIDz'+SelectedRow).value;
	var retval=cspRunServerMethod(encmeth,loc,phwid,printrow,printname,curflag,cancelflag,oldphloc,oldphwid)
	if (retval=='0') {alert(t['08']); Retrieve_Click();}
	else 
	{
	alert(t['07'])	
	}
			
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
	var loc=combo_DeptList.getSelectedValue()
	if (loc=="") {
		
		alert("该用户可登录科室无该药房,请下拉确认!");
		return;
		}
    var pywin=combo_PyWin.getSelectedValue();
    if (pywin=="") {
	    if (SelectedRow!=0){
		    alert("该药房没有此窗口,请确认!")
		    return;
	    }
		alert(t['09'])
		return;} 
			var curflag=0
		var cancelflag=0
   	var printname=document.getElementById('CPrintDesc').value;		
    if ( document.getElementById('CCurrPrint').checked==true){var curflag="1";}
	if ( document.getElementById('CPrintCancel').checked==true){var cancelflag="1";}

    var pid=document.getElementById('ins');
 	if (pid) {var encmeth=pid.value} else {var encmeth=''};
    var retval=cspRunServerMethod(encmeth,loc,pywin,printname,curflag,cancelflag)
    
	if (retval!="0"){alert(t['07']);}
	else
	 { alert(t['08']); Retrieve_Click();}
	

}

function Retrieve_Click()
{
	var ctloc=document.getElementById('ctloc').value;

 var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhPYPrint&ctloc=" //+ctloc;
  location.href=lnk
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



document.body.onload = BodyLoadHandler;
