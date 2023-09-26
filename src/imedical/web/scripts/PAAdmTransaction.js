// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//KM 27-Aug-2002: As of today this file is used in association with 
//components PAAdmTransaction.EditNew, PAAdmTransaction.Edit and PAAdmTransaction.EditBooking.
//W650

var obj = document.getElementById("TRANSBedDR");
if (obj) obj.onblur = BedBlurHandler;

var obj = document.getElementById("TRANSWardRoomDR");
if (obj) obj.onblur = RoomBlurHandler;

var obj = document.getElementById("TRANSWardDR");
if (obj) obj.onblur = WardBlurHandler;

function WardChangeHandler(str) {
	var lu = str.split("^");
	//alert(lu);
	var TransType = document.getElementById('TransType');
	var obj = document.getElementById("TRANSCTLOCDR");
	if ((obj) && (obj.disabled)){
		if((TransType)&&(TransType.value=="M")){

		}else{
			obj.value = "";
		}
		
	} 
	var obj = document.getElementById("TRANSWardRoomDR");
	if (obj) obj.value = "";
	var obj = document.getElementById("TRANSBedDR");
	if (obj) obj.value = "";
	var obj = document.getElementById("BedID");
	if (obj) obj.value = "";
	var obj = document.getElementById("CTLOCAgeFrom");
	if (obj) obj.value = lu[3];
	var obj = document.getElementById("CTLOCAgeTo");
	if (obj) obj.value = lu[4];
	var obj = document.getElementById("HOSPDesc");
	if (obj) {
		if (lu[6]) obj.value = lu[6];
	}
	var obj = document.getElementById("SNAPWard");
	if (obj) {
		if (lu[7] != "") {
			obj.value = lu[7];
		}
		if (lu[7] == "") {
			obj.value = "N"
		}
	}
	try {
		mandatoryLocation()
	} catch (e) {}
	//endLookups();
}

function RoomChangeHandler(str) {
	var lu = str.split("^");
	var obj = document.getElementById("TRANSWardRoomDR");
	if (obj) obj.value = lu[0];
	var obj = document.getElementById("TRANSWardDR");
	if (obj) obj.value = lu[1];
	var obj = document.getElementById("ROOMDifferentSexPatients");
	if (obj) obj.value = lu[3];
	var obj = document.getElementById("WardRoomDR");
	if (obj) obj.value = lu[4];
	//alert(obj.value);
	var obj = document.getElementById("TRANSBedDR");
	if (obj) obj.value = "";
	//var obj=document.getElementById('ROOMSex');
	//if (obj) obj.value = lu[6];
	var obj = document.getElementById("TRANSCTLOCDR");
	//if ((obj) && (obj.disabled)) obj.value = "";
	// ab 11.10.03 40403 clear bed if changing room so we dont carry the wrong bed over..
	var obj = document.getElementById("TRANSBedDR");
	if (obj) obj.value = "";
	var obj = document.getElementById("BedID");
	if (obj) obj.value = "";
	var obj = document.getElementById("TRANSOverrideRoomTypeDR");
	if ((obj) && (obj.value == "")) obj.value = lu[7];
	var obj = document.getElementById("HOSPDesc");
	if (obj) obj.value = lu[8];
	//endLookups();
}

function BedBlurHandler() {
	var obj = document.getElementById("TRANSBedDR");
	var objBedID = document.getElementById("BedID");
	var objSNAPBed = document.getElementById("SNAPBed");
	if ((obj) && (obj.value == "")) {
		if (objBedID) objBedID.value = "";
		if (objSNAPBed) objSNAPBed.value = "";
	}
}

function RoomBlurHandler() {
	var obj = document.getElementById("TRANSWardRoomDR");
	var objID = document.getElementById("WardRoomDR");
	if ((obj) && (obj.value == "") && (objID)) objID.value = "";
}

function WardBlurHandler(str) {

	var obj = document.getElementById("TRANSWardDR");
	var obj1 = document.getElementById("CTLOCAgeFrom");
	var obj2 = document.getElementById("CTLOCAgeTo");
	var obj3 = document.getElementById("SNAPWard");
	if ((obj) && (obj.value == "")) {
		if (obj1) obj1.value = "";
		if (obj2) obj2.value = "";
		if (obj3) obj3.value = "";
	}
}


function BedChangeHandler(str) {
	var lu = str.split("^");
	//bedcode,warddesc,room,bedtype,status,BedID,agefrom,ageto,diffsex,roomsex,roomtype,...,wardroomid
	if (lu[0] != "") {

		var obj = document.getElementById("TRANSBedDR");
		if (obj) obj.value = lu[0];
		var obj = document.getElementById("TRANSWardDR");
		if (obj) obj.value = lu[1];
		var obj = document.getElementById("TRANSWardRoomDR");
		if (obj) obj.value = lu[2];
		var obj = document.getElementById("TRANSBedTypeDR");
		if (obj) obj.value = lu[3];
		var obj = document.getElementById("BedID");
		if (obj) obj.value = lu[5];
		var obj = document.getElementById("ROOMDifferentSexPatients");
		if (obj) obj.value = lu[8];
		var obj = document.getElementById("ROOMSex");
		if (obj) obj.value = lu[9];
		var obj = document.getElementById("TRANSOverrideRoomTypeDR");
		if ((obj) && (obj.value == "")) obj.value = lu[10];
		var obj = document.getElementById("WardRoomDR");
		if (obj) obj.value = lu[19];
		var obj = document.getElementById("HOSPDesc");
		if (obj) obj.value = lu[20];
		var obj = document.getElementById("SNAPWard");
		if (obj) {
			if (lu[21] != "") {
				obj.value = lu[21];
			}
			if (lu[21] == "") {
				obj.value = "N"
			}
		}
		var obj = document.getElementById("SNAPBed");
		if (obj) {
			if (lu[22] != "") {
				obj.value = lu[22];
			}
			if (lu[22] == "") {
				obj.value = "N"
			}
		}
		var obj = document.getElementById("TRANSCTLOCDR");
		//if ((obj) && (obj.disabled)) obj.value = "";
		try {
			mandatoryLocation()
		} catch (e) {}

	}
	//endLookups();
}

function LocationChangeHandler(str) {
	try {
		CustomLocationChangeHandler(str);
	} catch (e) {
		var lu = str.split("^");
		if (lu[1] != "") {
			var obj = document.getElementById("TRANSCTLOCDR");
			if (obj) obj.value = lu[1];
			var obj = document.getElementById("HOSPDesc");
			if (obj) obj.value = lu[6];
			var obj = document.getElementById("Hospitals");
			if (obj) obj.value = lu[7];
			var obj = document.getElementById("LocationID");
			if (obj) obj.value = lu[3];
			var obj = document.getElementById("MentalHealth");
			if (obj) {
				if (lu[4] == "Y") {
					obj.value = 1;
				} else {
					obj.value = 0;
				}
			}
			//JW:removed as causes incorrect validation
			//var obj2=document.getElementById('TRANSCTCPDR');
			//if (obj2&&obj2.value!="") {
			//var obj3=document.getElementById('CareProvLocDesc');
			//if (obj1.value.indexOf(obj3.value)==-1) obj2.value = "";
			//}
			var obj = document.getElementById("TRANSBedDR");
			if ((obj) && (obj.disabled)) obj.value = "";
			var obj = document.getElementById("TRANSWardRoomDR");
			if ((obj) && (obj.disabled)) obj.value = "";
			var obj = document.getElementById("TRANSWardDR");
			if ((obj) && (obj.disabled)) obj.value = "";
			var ifNeedLocWardRelation = tkMakeServerCall("Nur.DHCADTDischSet", "getIfNeedLocWardRelation")
			if (ifNeedLocWardRelation == "Y") {
				//选择科室后自动带出病区
				if (lu[3] != "") {
					var wardInfo = tkMakeServerCall("web.DHCNurCom", "getLinkWard", lu[3]);
					if (wardInfo != "") {
						var obj = document.getElementById("TRANSWardDR");
						if (obj) obj.value = wardInfo.split("^")[0];
						WardChangeHandler(wardInfo);
					}
				}
			}

		}
	}
}

/* function LocationChangeHandler(str) {
	var lu = str.split("^");
	if (lu[1]!="") {
		var obj1=document.getElementById('TRANSCTLOCDR')
		if (obj1) obj1.value = lu[1]
		//var obj2=document.getElementById('TRANSCTCPDR');
		//if (obj2&&obj2.value!="") {
		//var obj3=document.getElementById('CareProvLocDesc');
		//if (obj1.value.indexOf(obj3.value)==-1) obj2.value = "";
		//}
		var obj=document.getElementById('TRANSBedDR');
		if ((obj)&&(obj.disabled)) obj.value = "";
		var obj=document.getElementById('TRANSWardRoomDR');
		if ((obj)&&(obj.disabled)) obj.value = "";
		var obj=document.getElementById('TRANSWardDR');
		if ((obj)&&(obj.disabled)) obj.value = "";
	}
	//endLookups();
} */

function setEvents() {
	var obj = document.getElementById('ld1084iTRANSWardDR');
	if (obj) obj.onclick = setLookups;
	var obj = document.getElementById('ld1084iTRANSWardRoomDR');
	if (obj) obj.onclick = setLookups
	var obj = document.getElementById('ld1084iTRANSBedDR');
	if (obj) obj.onclick = setLookups
	var obj = document.getElementById('ld1084iTRANSCTCPDR');
	if (obj) obj.onclick = setLookups;
	var obj = document.getElementById('ld1084iCTACUDesc');
	if (obj) obj.onclick = setLookups;
	var obj = document.getElementById('ld1084iTRANSReasonDR');
	if (obj) obj.onclick = setLookups;
	var obj = document.getElementById('ld1084iTemporaryLoc');
	if (obj) obj.onclick = setLookups;
	var obj = document.getElementById('ld1084iPAADMParentWardDR');
	if (obj) obj.onclick = setLookups;
	var obj = document.getElementById('ld1084iPAADMLikelyTransICUDR');
	if (obj) obj.onclick = setLookups;

	var obj = document.getElementById('TRANSStartDate');
	if (obj) obj.onblur = TRANSStartDateTimeHandler;
	var obj = document.getElementById('TRANSStartTime');
	if (obj) obj.onblur = TRANSStartDateTimeHandler;

}

function TRANSStartDateTimeHandler(e) {
	var eobj = websys_getSrcElement(e);

	// run all brokers to validate date/time against code tables
	if ((eobj) && (eobj.id == "TRANSStartDate") && (IsValidDate(eobj))) {
		var obj = document.getElementById("TRANSStartDateH");
		if (obj) {
			if (eobj.value != "") obj.value = DateStringTo$H(eobj.value);
			if (eobj.value == "") obj.value = obj.defaultValue;
		}
		//var fields=new Array("TRANSCTCPDR","TRANSCTLOCDR","TRANSWardDR","TRANSBedDR","HOSPDesc");
		//RunBrokers(fields);
	}

	if (!document.getElementById('TransType')) return;
	//blank ward, bed and room details for OPEN Accepted booking transactions
	if ((document.getElementById('TransType').value == "B") && (document.getElementById('REQSTCode').value == "A")) {
		var objR = document.getElementById('TRANSWardRoomDR')
		var objB = document.getElementById('TRANSBedDR')
		if (objR.value != "" || objB.value != "") {
			var objD = document.getElementById('TRANSStartDate');
			var objT = document.getElementById('TRANSStartTime');
			if ((objD.defaultValue != objD.value) || (objT.defaultValue != objT.value)) {
				if (objR) {
					objR.value = ""
				}
				if (objB) {
					objB.value = ""
				}
				alert(t['RoomAndBedBlanked']);
			}
		}
	}
}

function setLookups() {
	//DisableOnTop()
	var eSrc = websys_getSrcElement(window.event);
	var func = eSrc.id.substring(7, eSrc.id.length) + "_lookuphandler(window.event)";
	eval(func);
}

function endLookups() {
	//timerenabled=true;
	//StayOnTop();

}

function checkCodeTableValid(fields) {
	var valid = true;
	var errmsg = "";
	for (var i = 0; i < (fields.length); i++) {
		obj = document.getElementById(fields[i]);
		if ((obj) && (obj.className == "clsInvalid")) {
			errmsg = errmsg + t[fields[i]] + " " + t["XINVALID"] + "\n";
			valid = false;
		}
	}
	if (errmsg != "") alert(errmsg);
	return valid
}

function RunBrokers(fields) {
	var valid = true;
	for (var i = 0; i < (fields.length); i++) {
		var obj = document.getElementById(fields[i]);
		if ((obj) && (!obj.disabled)) obj.onchange();
	}
	return valid
}