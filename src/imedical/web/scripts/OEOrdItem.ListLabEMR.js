// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var tbl=document.getElementById("tOEOrdItem_ListLabEMR");
var f=document.getElementById("fOEOrdItem_ListLabEMR");
var mobj=document.getElementById("patientid");
if ((mobj)&&(mobj.value=="")) mobj.disbled=true;

for (var i=1;i<tbl.rows.length;i++) {
	var eSrc=f.elements['episodeidz'+i];
	if (eSrc) {
		var obj=getRow(eSrc)
		var col=f.elements['episodeidz'+i].value;
		// Log 26597 - AI - 16-07-2002 : clean up this function, mainly handling of episode id.
		var epid=document.getElementById("episodeid");
		if (col!=epid.value) {
			if ((i%2)==1) {
				obj.className="EMROtherEpsOdd";
			} else {
				obj.className="EMROtherEpsEven";
			}
		}
	}
}
function getRow(eSrc) {
	while(eSrc.tagName != "TR") {
		if (eSrc.tagName == "TH") break;
		if (eSrc.parentElement) {
			eSrc=eSrc.parentElement;
		} else {
			eSrc="";
			break;
		}
	}
	return eSrc;
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

function ChkAbnormalResult() {
	var tbl=document.getElementById("tOEOrdItem_ListLabEMR");
	for (var curr_row=1; curr_row<tbl.rows.length; curr_row++) {
		var FlagValue = document.getElementById("FlagValuez" + curr_row);
		if (FlagValue) {
			if ((FlagValue.value!="N")&&(FlagValue.value!="")) MarkAsAbnormal(curr_row,tbl);
		} else {
			var RefRange = document.getElementById("RefRangez" + curr_row);
			if (RefRange) {
				RefRange=RefRange.innerText; RefRange=RefRange.split("-");
				if (RefRange[2]!=null) {
					RefRange[0]=RefRange[0]+RefRange[1]
					RefRange[1]=RefRange[2]
				}
				RefRange[0]=parseFloat(RefRange[0]); RefRange[1]=parseFloat(RefRange[1]);
				if (RefRange[0]=="") RefRange[0]="openlow";
				if (RefRange[1]=="") RefRange[1]="openhigh";
				var Value = document.getElementById("InnerValuez" + curr_row);
				if (Value) {
					var Result=parseFloat(Value.value);
					var min=Math.min(RefRange[0],RefRange[1],Result);
					var max=Math.max(RefRange[0],RefRange[1],Result);
					if ((RefRange[0]=="openlow")||(RefRange[1]=="openhigh")) {
						if ((RefRange[0]=="openlow")&&(Result>RefRange[1])) {
							MarkAsAbnormal(curr_row,tbl);
						} else if ((RefRange[1]=="openhigh")&&(Result<RefRange[0])) {
							MarkAsAbnormal(curr_row,tbl);
						}
					} else if (((Result==min)||(Result==max))&&((Result!=RefRange[0])&&(Result!=RefRange[1]))) {
						MarkAsAbnormal(curr_row,tbl);
					}
				}
			}
		}
	}
}

function MarkAsAbnormal(CurrentRow,tableobj) {
		for (var CurrentCell=0; CurrentCell<tableobj.rows[CurrentRow].cells.length; CurrentCell++) {
			tableobj.rows[CurrentRow].cells[CurrentCell].style.color="Red";
   	}
}

var objClicked=document.getElementById('Clicked');
if (objClicked.value>=1) {
	  var searchobj=document.getElementById('SearchPar');
	  searchobj.disabled=true;
	  searchobj.onclick=LinkDisable
}

ChkAbnormalResult();