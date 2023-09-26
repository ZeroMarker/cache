// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 6.05.03 - colouring moved to PACWard.ListColours.js, called from the components PACWardRoom.ListPatients and PACWard.ListPatientsInWard bodyloadhandlers

function SetWardColours() {
	var df=document.forms;
	for (var i=0;i<df.length;i++) {
		SetWardColourForm(df[i]);
	}
}

function SetWardColourForm(frm) {
		var tbl=document.getElementById("t"+frm.id.substring(1,frm.id.length));
		var divAry=document.all.tags("DIV");
		for (var j=0;j<divAry.length;j++) {
			if (divAry[j].id.substring(1,divAry[j].id.length)==tbl.id.substring(1,tbl.id.length)) var div=document.all.tags("DIV")[j];
		}
		for (var j=0;j<tbl.rows.length;j++) {
			var obj=frm.elements["TempLocCodez"+j]
			var obj1=frm.elements["FromTempLocz"+j]
			if (obj) {
				// ab 58173 - only check FromTempLoc for bottom list
				if (obj1) {
					if (obj1.value!="") tbl.rows[j].className="clsRowFromTempLoc"
					if ((obj1.value=="")&&(obj.value!="")) tbl.rows[j].className="clsRowTempLoc";
				} else {
					if (obj.value!="") tbl.rows[j].className="clsRowTempLoc";
				}
			}
			var obj=frm.elements["StatusCodez"+j]
			if (obj) {if (obj.value=="D") tbl.rows[j].className="clsDischarged"}
			//var obj=frm.elements["BoarderOutFlagz"+j]
			//if (obj) {if (obj.value!="") tbl.rows[j].className="clsBoarderOut"}
			var objWardBook=frm.elements["OtherWardBookingz"+j];
			var obj=frm.elements["BoarderOutFlagz"+j];
			if ((obj)&&(obj.value!="")) {
				tbl.rows[j].className="clsBoarderOut";
				if (objWardBook.value!=1) tbl.rows[j].selectenabled=0;
			}
			var obj=frm.elements["OutlierFlagz"+j];
			
			if ((obj)&&(obj.value!="")&&(obj.value!="0")&&(objWardBook)) {
				tbl.rows[j].className="clsOutlier";
				// ab 30.10.03 - 40206 - removed restriction on selecting outliers
				// ab 21.11.03 - 40206 - reinstated restriction for outliers without booking
				if (objWardBook.value!=1) tbl.rows[j].selectenabled=0;
			}
			// ab 31.10.02 - disable the selecting of emergency bookings on inpatient ward patient list
			var loctype=document.getElementById("CTLocType");
			var admorg=frm.elements["orgadmtypez"+j];
			var admstat=frm.elements["prcodez"+j];
			var admtype=frm.elements["admtypez"+j];
			var boarder=frm.elements["boarderhiddenz"+j];
			if ((loctype)&&(loctype.value!="EM")) {
				if ((admorg)&&((admorg.value=="E")||(admorg.value=="O"))&&(admstat)&&(admstat.value=="P")) tbl.rows[j].className="clsRowPre";
				if ((admtype)&&((admtype.value=="O")||(admtype.value=="E"))) tbl.rows[j].className="clsRowDisabled";
			}
			// Outliers - color the UR
			if ((div)&&(boarder)&&(boarder.value=="Y")) {
				if (div.all.tags("A")["URz"+j]) div.all.tags("A")["URz"+j].parentElement.className="tblBoarder";
				if (div.all.tags("A")["RTMASMRNoz"+j]) div.all.tags("A")["RTMASMRNoz"+j].parentElement.className="tblBoarder";
			}
			// cjb 16/01/2006 55848 - If the security group doesn't allow you to see VIP patients, PACWard.ListPatientsInWard returns PatientID as null.  Also need to disable the row as EpisodeID is set so we can get the Icon Profile
			var PatientID=frm.elements["PatientIDz"+j];
			if ((PatientID)&&(PatientID.value=="")) {
				// cjb 01/05/2006 58322
				//tbl.rows[j].className="clsRowDisabled";
				tbl.rows[j].selectenabled=0;
				var Select=frm.elements["Selectz"+j];
				if (Select) Select.disabled=true;
			}
		}
		ColorExpDisch(frm,tbl);
}

//LOG 23.... BC 11-Mar-2002
function ColorExpDisch(f,tbl) {
	if ((f)&&(tbl)) {
		var divAry=document.all.tags("DIV");
		for (var j=0;j<divAry.length;j++) {
			if (divAry[j].id.substring(1,divAry[j].id.length)==tbl.id.substring(1,tbl.id.length)) var div=document.all.tags("DIV")[j];
		}
		if (div) {
			for (var i=0;i<tbl.rows.length;i++) {
				var colorobj=f.elements['Colorz'+i];
				if (div.all.tags("LABEL")["ExpDischargez"+i]) {
					if (div.all.tags("LABEL")["ExpDischargez"+i].innerHTML!="&nbsp;") {
						if (colorobj){
							if (colorobj.value!="") {
								var tabobj=div.all.tags("LABEL")["ExpDischargez"+i].parentElement;
								tabobj.bgColor=colorobj.value;
							}
						}
					}
				}
				var colortriageobj=f.elements['ColorTriagez'+i];
				if (div.all.tags("LABEL")["PriorityDRz"+i]) {
					if (div.all.tags("LABEL")["PriorityDRz"+i].innerHTML!="&nbsp;") {
						if (colortriageobj) {
							if (colortriageobj.value!=""){
								var tabobj=div.all.tags("LABEL")["PriorityDRz"+i].parentElement;
								tabobj.bgColor=colortriageobj.value;
							}
						}
					}
				}
			}
		}
	}
	return false;
}