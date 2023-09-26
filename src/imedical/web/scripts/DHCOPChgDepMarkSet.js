var SelectedRow = 0;
function BodyLoadHandler() {
	var obj=document.getElementById("Save");
	if (obj) obj.onclick=Save_click;
	var obj=document.getElementById("Bupdate");
	if (obj) obj.onclick=Bupdate_click;
	var obj=document.getElementById("Delete");
	if (obj) obj.onclick=Bdel_click;
}
function Bdel_click()	
{

	var rid=document.getElementById('ID').value;
    if (rid=="") {
		alert(t['01']);
		return;}
		
    var del=document.getElementById('GetDeleteMethod');

	if (del) {var encmeth=del.value} else {var encmeth=''};

	Retcode=cspRunServerMethod(encmeth,rid)
	
	if (Retcode!=0){
		alert(t["02"])
		return
	}else{
		alert(t["03"])
		window.location.reload();
	}
}


function DepResourceResult(str) {
	var obj=document.getElementById('DepSourceDr');
	var tem=str.split("^");
	obj.value=tem[0];
	var obj=document.getElementById('DepSource');
	var tem=str.split("^");
	obj.value=tem[1];
	var obj=document.getElementById('MarkSource');
	obj.value=""
	var obj=document.getElementById('MarkSourceDr');
	obj.value=""
}

function MarkResourceResult(str) {
	var obj=document.getElementById('MarkSourceDr');
	var tem=str.split("^");
	obj.value=tem[1];
}

function DepTargetResult(str) {
	var obj=document.getElementById('DepTargetDr');
	var tem=str.split("^");
	obj.value=tem[0];
	var obj=document.getElementById('DepTarget');
	var tem=str.split("^");
	obj.value=tem[1];
	var obj=document.getElementById('MarkTarget');
	obj.value=""
	var obj=document.getElementById('MarkTargetDr');
	obj.value=""
}

function MarkTargetResult(str) {
var obj=document.getElementById('MarkTargetDr');
var tem=str.split("^");
obj.value=tem[1];
}


function SelectRowHandler()	{
	
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCOPChgDepMarkSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	var DepSource=document.getElementById('DepSource');
	var MarkSource=document.getElementById('MarkSource');
	var DepTarget=document.getElementById('DepTarget');
	var MarkTarget=document.getElementById('MarkTarget');
	var DepSourceDr=document.getElementById('DepSourceDr');
	var MarkSourceDr=document.getElementById('MarkSourceDr');
    var DepTargetDr=document.getElementById('DepTargetDr');
	var MarkTargetDr=document.getElementById('MarkTargetDr');
	var ID=document.getElementById('ID');
	var SelRowObj=document.getElementById('TDepSourcez'+selectrow);
	var SelRowObj1=document.getElementById('TMarkSourcez'+selectrow);
	var SelRowObj2=document.getElementById('TDepTargetz'+selectrow);
	var SelRowObj3=document.getElementById('TMarkTargetz'+selectrow);
	var SelRowObj4=document.getElementById('TDepSourceDrz'+selectrow);
	var SelRowObj5=document.getElementById('TMarkSourceDrz'+selectrow);
	var SelRowObj6=document.getElementById('TDepTargetDrz'+selectrow);
	var SelRowObj7=document.getElementById('TMarkTargetDrz'+selectrow);
	var SelRowObj8=document.getElementById('TIDz'+selectrow);
    if (selectrow==SelectedRow) {
		DepSource.value="";
		MarkSource.value="";
		MarkTarget.value="";
		DepTarget.value="";
		MarkSourceDr.value="";
		DepSourceDr.value="";
		ID.value="";
		SelectedRow=0
		return;
	}
	if(DepSource) DepSource.value= SelRowObj.innerText
	if(MarkSource) MarkSource.value= SelRowObj1.innerText
	if(DepTarget) DepTarget.value= SelRowObj2.innerText
	if(MarkTarget) MarkTarget.value= SelRowObj3.innerText
	if(DepSourceDr) DepSourceDr.value= SelRowObj4.value
	if(MarkSourceDr) MarkSourceDr.value= SelRowObj5.value
	if(DepTargetDr) DepTargetDr.value= SelRowObj6.value
	if(MarkTargetDr) MarkTargetDr.value= SelRowObj7.value
	if(ID) ID.value= SelRowObj8.value

	
	//alert(DepSourceDr.value+"^"+MarkSourceDr.value+"^"+DepTargetDr.value+"^"+MarkTargetDr.value+"^"+ID.value)
	SelectedRow = selectrow;
}

function Bupdate_click()	
{
	selectrow=SelectedRow;
	var roomid=document.getElementById('roomid').value;
	if (roomid=="") {
		alert(t['04']);
		return;}

    var comid=document.getElementById('depid').value;
    var comname=document.getElementById('depname').value;
    if (comname=="") {
		comid="";}
	
	var markid=document.getElementById('markid').value;
    if (markid=="") {
		alert(t['05']);
		return;}
    var rid=document.getElementById('rid').value;
    if (rid=="") {
		alert(t['01']);
		return;}		
	var mState=document.getElementById('st')
    if  (mState.checked)
    {var st="2";
    }
    else
    {
    var st="1";
    }
    var mSign=document.getElementById('si')
    if  (mSign.checked)
    {var si="Y";
    }
    else
    {
    var si="N";
    }
    var up=document.getElementById('up');
	if (up) {var encmeth=up.value} else {var encmeth=''};

	if (cspRunServerMethod(encmeth,'SetPid','',roomid,comid,markid,st,si,rid)=='0') {
			}
}
function Save_click()	//
{
	selectrow=SelectedRow;
    var DepSourceDr=document.getElementById('DepSourceDr').value;
    var DepSource=document.getElementById('DepSource').value
   	if(DepSource=="") DepSourceDr=""
	if (DepSourceDr=="") {
		alert(t['04'])
		return;}
  	
	var MarkSourceDr=document.getElementById('MarkSourceDr').value;
	var MarkSource=document.getElementById('MarkSource').value
   	if(MarkSource=="") MarkSourceDr=""
    if (MarkSourceDr=="") {
		alert(t['05']);
		return;}
	var DepTargetDr=document.getElementById('DepTargetDr').value;
	var DepTarget=document.getElementById('DepTarget').value
   	if(DepTarget=="") DepTargetDr=""
	if (DepTargetDr=="") {
		alert(t['06'])
		return;}
  	
	var MarkTargetDr=document.getElementById('MarkTargetDr').value;
	var MarkTarget=document.getElementById('MarkTarget').value; 
	if(MarkTarget=="") MarkTarget=""
    if (MarkTargetDr=="") {
		alert(t['07']);
		return;}

	//alert(DepSourceDr+"^"+MarkSourceDr+"^"+DepTargetDr+"^"+MarkTargetDr)
    //return
    var ins=document.getElementById('GetSaveMethod');
	if (ins) {var encmeth=ins.value} else {var encmeth=''};
	Retcode=cspRunServerMethod(encmeth,DepSourceDr,MarkSourceDr,DepTargetDr,MarkTargetDr)
	if(Retcode!=0){
		alert(t['09']);
		return;
	}else{
		alert(t['08']);	
		window.location.reload();
	}
}

document.body.onload = BodyLoadHandler;
