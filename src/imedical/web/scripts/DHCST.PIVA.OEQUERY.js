function BodyLoadHandler()
{
	setDefaultVal();
	SetTblColor();
	SetObjHandler();
}
function setDefaultVal()
{
	var obj=document.getElementById("mGetDate");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var stdate=cspRunServerMethod(encmeth);
	var eddate=cspRunServerMethod(encmeth);
	var objsd = document.getElementById("tSDate");
	if (objsd){
		if (objsd.value=="") objsd.value = stdate;
	}
	var objed = document.getElementById("tEDate");
	if (objed){
		if (objed.value=="") objed.value = eddate;
	}
	///默认病区
	var AdmId=document.getElementById("EpisodeID").value;
	var WardInfo=tkMakeServerCall("web.DHCSTPIVAQUERY","GetAdmInfo",AdmId);
	var WardArr=WardInfo.split("^");
	document.getElementById("tWardID").value=WardArr[0];
	document.getElementById("tWard").value=WardArr[1];
}

function SetObjHandler()
{
	var obj=document.getElementById("bReCheckOK");
	if (obj) obj.onclick=bReCheckOKClick;
}
function tbSelectClick()
{
	var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_OEQUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	var row=selectedRow(window);
 	if (!row) return;
 	if (row<1) return;
 	var setvalue;
 	var cell=document.getElementById("tbSelectz"+row);
 	var pog=document.getElementById("tbPogIDz"+row).value;;
	if (cell){
		if (cell.checked==false) {setvalue=false;}
		else {setvalue=true;}
	}
	var pogflag=0;
	for (var i=1;i<objtbl.rows.length; i++) {
		var objpog=document.getElementById("tbPogIDz"+i)
		if (objpog) pogid=objpog.value;
		if (pogid==pog){
			var objsel=document.getElementById("tbSelectz"+i);
			objsel.checked=setvalue;
			pogflag=1
		}
		if ((pogid!=pog)&&(pogflag==1)) break;
	}
}

function SetTblColor()
{
	var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_OEQUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt>0){
		/*for (var i=1;i<objtbl.rows.length; i++) {
			var cell=document.getElementById("tbSelectz"+i);
			if (cell){cell.onclick=tbSelectClick;}
    	}*/
		SetTblRowsColor(objtbl,2);  //已有table单击选择方法
	}
}
function CspRunSaveCheckOK(pid,pog,exestate)
{
	var obj=document.getElementById("mSaveCheckOK");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,pid,pog,exestate);
	return result;
}
function bReCheckOKClick()
{
	var cnt=0;
	var dsp;
	var pog;
	var ppog="";
	var ret;
	var exestate=""
	
	var objtbl=document.getElementById("t"+"DHCST_PIVA_OEQUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) {alert("没有需要签收的记录！"); return;}
	var rowselflag=0
	var pid=CspRunGetNewPid();
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		if (rowselflag==1) break;
		if (cell.checked==true){
			var rowselflag=1
			}
	
	}
	if (rowselflag==1){
    if (!confirm("确认签收吗")) return;
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		
		if (cell.checked==true){
			
			
			//dsp=document.getElementById("tbDSPz"+i).value;
			//var bed=document.getElementById("tbBedNoz"+i).innerText;
			var batno=document.getElementById("tbBatNoz"+i).innerText;
			pog=document.getElementById("tbPogIDz"+i).value;
            
			if (pog!=ppog){
				ppog=pog

				ret=CspRunSaveCheckOK(pid,pog,"90");
				//var itmdesc=CspRunGetNoQtyItmDesc()
				var msgstr="行数"+i+" 批次"+batno//+" "+itmdesc;
				if (ret==-9){
					alert("此时不能执行该状态!"+msgstr);
					return;
				}
				if (ret!=0){
					alert(t['SAVE_FAILED']+ret+" "+msgstr);
					return;
				}
				else{
					alert("签收成功")
					}
			}
		}
	}
	
	CspRunClearAfterSave(pid);
	Find_click();
	}
	else {alert("请选择要签收的记录！"); return;}
}
function CspRunGetNewPid()
{
	var obj=document.getElementById("mGetNewPid");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth);
	return result;
}
function CspRunClearAfterSave(pid)
{
	var obj=document.getElementById("mClearRCSAVE");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	cspRunServerMethod(encmeth,pid);
}
document.body.onload=BodyLoadHandler;