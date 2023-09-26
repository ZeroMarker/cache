///DHCPEDocListNew
function BodyLoadHandler() {
	obj=document.getElementById("GroupName");
	if (obj) { obj.onchange=GroupName_Change; }
	ColorTblColumn()
}

function AfterGroupSelected222(value)
{
	if (""==value){return false}
	var aiList=value.split("^");
	var obj;
	obj=document.getElementById("GroupID");
	if (obj) obj.value=aiList[0];
	obj=document.getElementById("GroupName");
	if (obj) obj.value=aiList[1];
}
function GroupName_Change()
{
	var obj=document.getElementById("GroupID");
	if (obj) { obj.value=""; }
}
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPEDocListNew');	//取表格元素?名称
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
    	if (!selectrow) return;
	ShowCurRecord(selectrow)
}	
function ShowCurRecord(CurRecord) {
	var Reg="",PAADM="";
	var o1=document.getElementById('Regz'+CurRecord);
	if (o1) {
		var Reg=o1.innerText;	
	}
	var o1=document.getElementById('PAADMz'+CurRecord);
	if (o1) {
		var PAADM=o1.value;	
	} 
	var CheckingInfo=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","GetCheckingInfo",PAADM);
	if (CheckingInfo!=""){
		if (!confirm(CheckingInfo)) return false;
	}
	var CheckingInfo=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","SetCheckingInfo",PAADM,session['LOGON.USERID']);
    	var lnk="dhcpenewdiagnosis1.csp?Reg="+Reg+"&PAADM="+PAADM;
	var ZJ="ZJ"
	parent.frames[ZJ].location.href=lnk;
}
function ColorTblColumn(){
	var tbl=document.getElementById('tDHCPEDocListNew');	//取表格元素?名称
	var row=tbl.rows.length;
	row=row-1;
	
	for (var j=1;j<row+1;j++) {
	var objSort=document.getElementById('TSortz'+j);
	var objArcim=document.getElementById('Regz'+j);
	var objPlacerCode=document.getElementById('Nz'+j);
	var placerCode=""; 
	
	if (objPlacerCode) {placerCode=objPlacerCode.value;}
	//alert(placerCode)
	var objArcim=document.getElementById('Regz'+j).parentElement;
	var objArcim2=document.getElementById('Namez'+j).parentElement;
	var objSort=document.getElementById('TSortz'+j).parentElement;
	var sTD=objArcim.parentElement;
	if (placerCode==1)
	{
	sTD.bgColor="#42D729"
	objArcim.bgColor="#42D729"
	objArcim2.bgColor="#42D729"
	objSort.bgColor="#42D729"
	}
	if (placerCode==2)
	{
	sTD.bgColor="#DEEB10"
	objArcim.bgColor="#DEEB10"
	objArcim2.bgColor="#DEEB10"
	objSort.bgColor="#DEEB10"
	
	}
	if (placerCode==3)
	{
	sTD.bgColor="#D63829"
	objArcim.bgColor="#D63829"
	objArcim2.bgColor="#D63829"
	objSort.bgColor="#D63829"
	}
	if (placerCode==4)
	{
	sTD.bgColor="#808000"
	objArcim.bgColor="#808000"
	objArcim2.bgColor="#808000"
	objSort.bgColor="#808000"
	}
	if (placerCode==5)
	{
	sTD.bgColor="#C0C0C0"
	objArcim.bgColor="#C0C0C0"
	objArcim2.bgColor="#C0C0C0"
	objSort.bgColor="#C0C0C0"
	}
	}
}
function SetOneColor(PAADM,MainDoctor)
{
	var tbl=document.getElementById('tDHCPEDocListNew');	//取表格元素?名称
	var row=tbl.rows.length;
	row=row-1;
	var CurPAADM="";
	for (var j=1;j<row+1;j++) {
		var o1=document.getElementById('PAADMz'+j);
		if (o1) {
			var CurPAADM=o1.value;
			if (CurPAADM==PAADM){
				var objArcim=document.getElementById('Regz'+j).parentElement;
				var sTD=objArcim.parentElement;
				var objArcim2=document.getElementById('Namez'+j).parentElement;
				if (MainDoctor=="Y"){
					sTD.bgColor="#C0C0C0"
					objArcim.bgColor="#C0C0C0"
					objArcim2.bgColor="#C0C0C0"
				}else{
					sTD.bgColor="#808000"
					objArcim.bgColor="#808000"
					objArcim2.bgColor="#808000"
				}
			}
		} 
	}
}

document.body.onload = BodyLoadHandler;