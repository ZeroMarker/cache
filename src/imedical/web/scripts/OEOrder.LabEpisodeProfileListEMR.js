// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function ChkAbnormalResult() {
	var tbl=document.getElementById("tOEOrder_LabEpisodeProfileListEMR");
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

ChkAbnormalResult();