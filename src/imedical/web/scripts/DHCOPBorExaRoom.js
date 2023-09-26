var SelectedRow = 0;

function BodyLoadHandler() {
	var obj=document.getElementById("Badd");
	if (obj) obj.onclick=Badd_click;
	var obj=document.getElementById("Bupdate");
	if (obj) obj.onclick=Bupdate_click;
	var obj=document.getElementById("Bcancel");
	if (obj) obj.onclick=Bdel_click;
	var obj=document.getElementById("BordBordesc");
	if (obj) obj.onchange=BordBordescChange;
	var obj=document.getElementById("ExaRoomDesc");
	if (obj) obj.onchange=ExaRoomDescChange;
	
	
}
function ExaRoomDescChange()
{
	var obj=document.getElementById("ExaRoomDesc");
	if(obj.value==""){
		var obj=document.getElementById('ExaRoomDr');
        obj.value=""
	}
}
function BordBordescChange()
{
	var obj=document.getElementById("BordBordesc");
	if(obj.value==""){
		var obj=document.getElementById('BordBorDr');
        obj.value=""
	}
}
function borlook(str) {
var obj=document.getElementById('BordBorDr');
var tem=str.split("^");
//alert(tem[1]);
if(obj) obj.value=tem[1];

}

function ExaRoomlook(str) {
var obj=document.getElementById('ExaRoomDr');
var tem=str.split("^");
//alert(tem[1]);
if(obj) obj.value=tem[1];

}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
    var objtbl=document.getElementById('DHCOPBorExaRoom');

    var obj=document.getElementById('BordBordesc');
	var obj1=document.getElementById('ExaRoomDesc');
	var obj2=document.getElementById('BordMemo');
	var obj3=document.getElementById('BordBorDr');
	var obj4=document.getElementById('ExaRoomDr');
	var obj5=document.getElementById('ID');
	if(SelectedRow ==selectrow){
		obj.value="";
		obj1.value="";
		obj2.value="";
		obj3.value="";
		obj4.value="";
		obj5.value="";	
		SelectedRow=0
		return
	}
	var SelRowObj=document.getElementById('TBordBordescz'+selectrow);
	var SelRowObj1=document.getElementById('TExaRoomDescz'+selectrow);
	var SelRowObj2=document.getElementById('TCommz'+selectrow);
	var SelRowObj3=document.getElementById('TBordBorDrz'+selectrow);
	var SelRowObj4=document.getElementById('TExaRoomDrz'+selectrow);
	var SelRowObj5=document.getElementById('TIDz'+selectrow);

	obj.value=SelRowObj.innerText;
	obj1.value=SelRowObj1.innerText;
	obj2.value=SelRowObj2.innerText;
	obj3.value=SelRowObj3.value;
	obj4.value=SelRowObj4.value;
	obj5.value=SelRowObj5.value;
	//alert(obj.value+","+obj1.value+","+obj2.value+","+obj3.value+","+obj4.value+","+obj5.value)
	//var ss=obj5.value;//
    //var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCExaRoom&borid="+ss;//
 	//bottomFrame.location.href=lnk;//
	SelectedRow = selectrow;
}

function Bupdate_click()	//
{
	var Bor=document.getElementById('BordBorDr').value;
	if (Bor=="") {
		alert("请选择分诊区")
		return;}
    var dep=document.getElementById('ExaRoomDr').value;
    if (dep=="") {
		alert("请选择诊室")
		return;}
    var ID=document.getElementById('ID').value
 	if (ID=="") {
		alert("请选择要更新的记录")
		return;}

    var BordBorDr=document.getElementById('BordBorDr').value;
    var ExaRoomDr=document.getElementById('ExaRoomDr').value;    
    var BordMemo=document.getElementById('BordMemo').value

    var up=document.getElementById('up');
	if (up) {var encmeth=up.value} else {var encmeth=''};
	
	//	alert(BordBorDr+","+ExaRoomDr+","+BordMemo+","+encmeth);

	Rtn=cspRunServerMethod(encmeth,'','',ID,BordBorDr,ExaRoomDr,BordMemo)
	if (Rtn=="0")
	{
		alert("修改成功");
		window.location.reload();
	}else	if (Rtn=="1"){
	    alert("该诊室已做对照");
	    window.location.reload();
	} else {
		alert("修改失败");
	}
			
}
function Bdel_click()	//
{
	var ID=document.getElementById('ID').value
	//alert(ID)
 	if (ID=="") {
		alert("请选择要删除的记录");
		return;}
		
    var del=document.getElementById('del');
	if (del) {var encmeth=del.value} else {var encmeth=''};
	
	Rtn=cspRunServerMethod(encmeth,'','',ID) 
	if (Rtn!="0")
	{
		alert("删除失败");
	}else{
	    alert("删除成功");
	    window.location.reload();
	} 
}

function Badd_click()	
{
	var Bor=document.getElementById('BordBordesc').value;
	if (Bor=="") {
		alert("请选择诊区")
		return;}
    var dep=document.getElementById('ExaRoomDesc').value;
    if (dep=="") {
	    alert("请选择诊室");
		return;}

    var BordBorDr=document.getElementById('BordBorDr').value;
    var ExaRoomDr=document.getElementById('ExaRoomDr').value;  
    
    var BordMemo=document.getElementById('BordMemo').value;
   
    var add=document.getElementById('add');
	if (add) {var encmeth=add.value} else {var encmeth=''};
	//alert(BordBorDr+","+BordDepDr+","+BordMemo)
	if (cspRunServerMethod(encmeth,'SetPid','',BordBorDr,ExaRoomDr,BordMemo)=='0') {
			}
}
function SetPid(value) 
{ 
    //alert(value);
	if (value!="")
	{alert("该诊室已对照");
	return;
		}
	try {	
	   
	    alert("保存成功");
	    window.location.reload();
		} catch(e) {};
}
function CleartDHCOPAdm()
{
	var objtbl=document.getElementById('tDHCOPReturn');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	for (var j=1;j<lastrowindex+1;j++) {
		objtbl.deleteRow(1);
	//alert(j);
	}
}
document.body.onload = BodyLoadHandler;
