// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

//KK 24/Apr/2003 Log 33029

function BodyLoadHandler() {
	ARPatBillListTotal_Translate();
	
	// ab 23.10.06 60501- reset episodeid if different patient chosen than stored in menu
	var MenuPatID="";
	var winf = window;
	if ((winf)&&(!winf.frames["eprmenu"])) winf=winf.parent;
	if ((winf)&&(winf.frames["eprmenu"])) {
		var obj=winf.frames["eprmenu"].document.getElementById("PatientID");
		if (obj) MenuPatID=obj.value;
		var obj2=document.getElementById("PatientID");
		if ((obj2)&&(MenuPatID!="")&&(obj2.value!=MenuPatID)) {
			//winf.SetSingleField("EpisodeID","");
			winf.MainClearEpisodeDetails();
			winf.SetSingleField("PatientID",obj2.value);
		}
	}
}

function ARPatBillListTotal_Translate(){
	var tbl=document.getElementById("tARPatientBill_ListTotals");
	for (var i=1; i<tbl.rows.length; i++) {
		//CellColumnName pattern is FieldName + z + rowNo
		var DescCol=document.getElementById("Descz"+i);
		if (DescCol) {
			var val=DescCol.innerText;
			if  (val!="") {
				//alert("val="+val);
				if (val=="Patient") {
					DescCol.innerText=t['PATIENT'];
				} else if (val=="Payor") {
					DescCol.innerText=t['PAYOR'];
				} else if (val=="Total") {
					DescCol.innerText=t['TOTAL'];
				}
			}
		}
	}
}

document.body.onload = BodyLoadHandler;

