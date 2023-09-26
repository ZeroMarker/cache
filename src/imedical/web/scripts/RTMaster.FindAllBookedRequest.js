// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function SelectRowHandler(evt) {
	// tbl.row[rowindex].col[colindex].className="clsRowSelected";
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var row=rowObj.rowIndex;
	var DLobj=document.getElementById("CTLOCDescz"+row)
	if ((DLobj)&&(DLobj.href!="")) {
		var twkfli="";
		var arr=DLobj.href.split("?");
		var twObj=document.getElementById("TWKFLI");
		if (twObj) twkfli=twObj.value-1;
		DLobj.href=arr[0]+"?TWKFLI="+twkfli+"&"+arr[1];
		//alert(DLobj.href);
		window.location=DLobj.href;
	}
	return false;
}

function SelectRequestRow(rowid){
	var ltbl=document.getElementById("tRTMaster_FindAllBookedRequest");
	var vfrm=document.getElementById("fRTMasVol_FindRequestVolume");
	var vtbl=document.getElementById("tRTMasVol_FindRequestVolume");
	if (ltbl) {
		for (var curr_row=1; curr_row<ltbl.rows.length; curr_row++) {
			var RTObj=document.getElementById("RTREVRowIdz"+curr_row)
			if((RTObj)&&(RTObj.value==rowid)){
				for (var CurrentCell=0; CurrentCell<ltbl.rows[curr_row].cells.length; CurrentCell++){
					ltbl.rows[curr_row].cells[CurrentCell].className="clsRowSelected";
				}
			}
			if ((vfrm)&&(vtbl)&&(ltbl.rows[curr_row].cells[1].className=="clsRowSelected")) {
				for (var j=1; j<vtbl.rows.length; j++) {
					var sel=vfrm.document.getElementById("AddVolz"+j);
					if (sel) {
						var volreq=vfrm.document.getElementById("ReqVolIDz"+j).value;
						if (RTObj) var bookreq=RTObj.value
						if (mPiece(bookreq,"||",0)==mPiece(volreq,"||",0)) sel.checked=true;
						else sel.checked=false;
					}
				}
			}
		}
	}
}

function mPiece(s1,sep,n) {
	//Split the array with the passed delimeter
      delimArray = s1.split(sep);

	//If out of range, return a blank string
      if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
	} else {
	  return ""
      }
}

function Init(){
	var Obj=document.getElementById("RTREVRowId");
	if((Obj)&&(Obj.value!="")) {
		SelectRequestRow(Obj.value);
	}
	window.setTimeout("DocLoadedDelay()",500)
}

function DocLoadedDelay() {


}

document.body.onload=Init;