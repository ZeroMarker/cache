// Copyright (c) 2005 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

// Log 52406 YC - Clear Location if Hospital is changed
function HospitalLookUpHandler(str) {
	var objHospital = document.getElementById("Hospital");
	var objLocation = document.getElementById("Location");
	if (objHospital && objLocation) {
		objLocation.value="";
	}
}