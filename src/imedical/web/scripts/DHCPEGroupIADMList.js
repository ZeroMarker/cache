
var CurrentSel=0;
function BodyLoadHandler() {
	ShowCurRecord(1);
}

// *******************************************************
//�Ա㱾ҳ�����ҳ������ȷ�Ĵ������
function ShowCurRecord(selectrow) {
	var obj=document.getElementById("TIADMz"+selectrow);
	var IADM="aaaa"
	if (obj) IADM=obj.value;
	var obj=document.getElementById("FeeType");
	var FeeType="I"
	if (obj) FeeType=obj.value;
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEGroupIADMItemList&FeeType="+FeeType+"&IADM="+IADM;
   
    parent.frames["ItemList"].location.href=lnk;	
}

function SelectRowHandler() {
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById("tDHCPEGroupIADMList");	
	if (objtbl) { var rows=objtbl.rows.length; }
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return; 
	if (selectrow==CurrentSel) {	    
		CurrentSel=0
	}
	else{
		CurrentSel=selectrow;
	}
	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;
