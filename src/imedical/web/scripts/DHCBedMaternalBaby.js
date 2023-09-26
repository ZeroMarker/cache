var CONST_HOSPID=""; 
function GetHospital1111(str)
{
	var obj=document.getElementById('HospitalRowId');
	var tem=str.split("^");
	obj.value=tem[1];
	var obj=document.getElementById('HospitalName');
	obj.value=tem[0];
	//CONST_HOSPID=getHospID();
	location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCBedMaternalBaby&HospitalRowId="+tem[1]+"&HospitalName="+tem[0];
	//listSet();
}
var SelectedRow = 0;
var preRowInd = 0;
function BodyLoadHandler() {
	var obj = document.getElementById('Add')
	if (obj) obj.onclick = Add_click;
	var obj = document.getElementById('Update')
	if (obj) obj.onclick = Update_click;
	var obj = document.getElementById('Delete')
	if (obj) obj.onclick = Delete_click;
	var obj = document.getElementById('LeftOffset')
	if (obj) obj.onclick = Clear_X;
	var obj = document.getElementById('TopOffset')
	if (obj) obj.onclick = Clear_Y;

}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	var objtbl = document.getElementById('tDHCBedMaternalBaby');
	var rows = objtbl.rows.length;
	var lastrowindex = rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) return;

	var BMBID = document.getElementById('BMBID');
	var PacWard = document.getElementById('PacWard');
	var WardID = document.getElementById('WardID');
	var BedType = document.getElementById('BedType');
	var BedTypeID = document.getElementById('BedTypeID');
	var LeftOffset = document.getElementById('LeftOffset');
	var TopOffset = document.getElementById('TopOffset');
	var IntervalX = document.getElementById('IntervalX');
	var IntervalY = document.getElementById('IntervalY');
	var Width = document.getElementById('Width');
	var Height = document.getElementById('Height');
	var BabyIntervalY = document.getElementById('BabyIntervalY');
	var MaxAttachBabies = document.getElementById('MaxAttachBabies');


	var SelRowBMBID = document.getElementById('tBMBIDz' + selectrow);
	var SelRowPacWard = document.getElementById('tPacWardz' + selectrow);
	var SelRowWardID = document.getElementById('tWardIDz' + selectrow);
	var SelRowBedType = document.getElementById('tBedTypez' + selectrow);
	var SelRowBedTypeID = document.getElementById('tBedTypeIDz' + selectrow);
	var SelRowLeftOffset = document.getElementById('tLeftOffsetz' + selectrow);
	var SelRowTopOffset = document.getElementById('tTopOffsetz' + selectrow);
	var SelRowIntervalX = document.getElementById('tIntervalXz' + selectrow);
	var SelRowIntervalY = document.getElementById('tIntervalYz' + selectrow);
	var SelRowWidth = document.getElementById('tWidthz' + selectrow);
	var SelRowHeight = document.getElementById('tHeightz' + selectrow);
	var SelRowBabyIntervalY = document.getElementById('tBabyIntervalYz' + selectrow);
	var SelRowMaxAttachBabies = document.getElementById('tMaxAttachBabiesz' + selectrow);

	if ((SelectedRow == selectrow)&&(PacWard.value!='')) {
		BMBID.value = "";
		PacWard.value = "";
		WardID.value = "";
		BedType.value = "";
		BedTypeID.value = "";
		Width.value = "";
		Height.value = "";
	}
	else {
		BMBID.value = SelRowBMBID.innerText;
		PacWard.value = SelRowPacWard.innerText;
		WardID.value = SelRowWardID.innerText;
		var tmpBedType = SelRowBedType.innerText;
		tmpBedType = tmpBedType.replace(" ", "");
		BedType.value = tmpBedType;
		BedTypeID.value = SelRowBedTypeID.innerText;
		//LeftOffset.value = SelRowLeftOffset.innerText;
		//if (LeftOffset.value == ' ') document.getElementById("LeftOffset").value = '';
		//TopOffset.value = SelRowTopOffset.innerText;
		//if (TopOffset.value == ' ') document.getElementById("TopOffset").value = '';
		//IntervalX.value = SelRowIntervalX.innerText;
		//if (IntervalX.value == ' ') document.getElementById("IntervalX").value = '';
		//IntervalY.value = SelRowIntervalY.innerText;
		//if (IntervalY.value == ' ') document.getElementById("IntervalY").value = '';
		Width.value = SelRowWidth.innerText;
		Height.value = SelRowHeight.innerText;
		//BabyIntervalY.value = SelRowBabyIntervalY.innerText;
		//MaxAttachBabies.value = SelRowMaxAttachBabies.innerText;
	}
	SelectedRow = selectrow;
	return;
}

function LookUpWard(str) {
	var loc = str.split("^");
	var obj = document.getElementById("WardID");
	obj.value = loc[2];
}

function LookUpBedType(str) {
	var loc = str.split("^");
	var obj = document.getElementById("BedTypeID");
	obj.value = loc[1];
}

function Clear_X() {
	document.getElementById("IntervalX").value = '';
}

function Clear_Y() {
	document.getElementById("IntervalY").value = '';
}

function Add_click() {
	var PacWard, WardID, BedType, BedTypeID, LeftOffset, TopOffset, IntervalX, IntervalY, Width, Height, BabyIntervalY, MaxAttachBabies

	var obj = document.getElementById('PacWard')
	if (obj) PacWard = obj.value;
	if (PacWard == "") {
		alert(t['NULL_Ward'])
		return;
	}
	var obj = document.getElementById('WardID')
	WardID = obj.value

	var obj = document.getElementById('BedType')
	if (obj) BedType = obj.value;
	if (BedType == "") {
		//alert(t['NULL_BedType']) 
		//return;
	}
	var obj = document.getElementById('BedTypeID')
	BedTypeID = obj.value
	var obj = document.getElementById('LeftOffset')
	if (obj) LeftOffset = obj.value;
	var obj = document.getElementById('TopOffset')
	if (obj) TopOffset = obj.value;
	var obj = document.getElementById('IntervalX')
	if (obj) IntervalX = obj.value;
	var obj = document.getElementById('IntervalY')
	if (obj) IntervalY = obj.value;

	if (((IntervalX == '') && (LeftOffset == '')) || ((IntervalY == '') && (TopOffset == ''))) {
		//alert(t['No Offset']);
		//return;
	}

	if (IntervalX != '') LeftOffset = '';
	if (IntervalY != '') TopOffset = '';

	var obj = document.getElementById('Width')
	if (obj) Width = obj.value;
	if (Width == "") {
		//alert(t['NULL_Width'])
		//return;
	}

	var obj = document.getElementById('Height')
	if (obj) Height = obj.value;
	if (Height == "") {
		//alert(t['NULL_Height'])
		//return;
	}

	var obj = document.getElementById('BabyIntervalY')
	if (obj) BabyIntervalY = obj.value;
	if (BabyIntervalY == "") {
		//alert(t['NULL_BabyIntervalY'])
		//return;
	}

	var obj = document.getElementById('MaxAttachBabies')
	if (obj) MaxAttachBabies = obj.value;
	/*if (MaxAttachBabies == "") {
		alert(t['NULL_MaxAttachBabies'])
		return;
	}*/

	var obj = document.getElementById('AddRecord')
	if (obj) {
		var encmeth = obj.value;
		var resStr = cspRunServerMethod(encmeth, WardID, BedTypeID, LeftOffset, TopOffset, IntervalX, IntervalY, Width, Height, BabyIntervalY, MaxAttachBabies)
		if (resStr != '0') {
			alert(t['Error']+":"+resStr);
			return;
		}
		else {
			alert(t['Success']);
			location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCBedMaternalBaby&HospitalRowId="+document.getElementById('HospitalRowId').value+"&HospitalName="+document.getElementById('HospitalName').value;
		}
	}
}

function Update_click() {
	var BMBID, PacWard, WardID, BedType, BedTypeID, LeftOffset, TopOffset, IntervalX, IntervalY, Width, Height, BabyIntervalY, MaxAttachBabies
	var obj = document.getElementById('BMBID')
	if (obj) BMBID = obj.value;
	if (BMBID == "") {
		alert(t['Please Select One'])
		return;
	}
	var obj = document.getElementById('PacWard')
	if (obj) PacWard = obj.value;
	if (PacWard == "") {
		alert(t['NULL_Ward'])
		return;
	}
	var obj = document.getElementById('WardID')
	WardID = obj.value

	var obj = document.getElementById('BedType')
	if (obj) BedType = obj.value;
	if (BedType == "") {
		//alert(t['NULL_BedType']) 
		//return;
	}
	var obj = document.getElementById('BedTypeID')
	BedTypeID = obj.value
	if (BedType == "") BedTypeID = "";
	var obj = document.getElementById('LeftOffset')
	if (obj) LeftOffset = obj.value;
	var obj = document.getElementById('TopOffset')
	if (obj) TopOffset = obj.value;
	var obj = document.getElementById('IntervalX')
	if (obj) IntervalX = obj.value;
	var obj = document.getElementById('IntervalY')
	if (obj) IntervalY = obj.value;

	if (((IntervalX == '') && (LeftOffset == '')) || ((IntervalY == '') && (TopOffset == ''))) {
		//alert(t['No Offset']);
		//return;
	}

	if (IntervalX != '') LeftOffset = '';
	if (IntervalY != '') TopOffset = '';

	var obj = document.getElementById('Width')
	if (obj) Width = obj.value;
	if (Width == "") {
		//alert(t['NULL_Width'])
		//return;
	}

	var obj = document.getElementById('Height')
	if (obj) Height = obj.value;
	if (Height == "") {
		//alert(t['NULL_Height'])
		//return;
	}

	var obj = document.getElementById('BabyIntervalY')
	if (obj) BabyIntervalY = obj.value;
	if (BabyIntervalY == "") {
		//alert(t['NULL_BabyIntervalY'])
		//return;
	}

	var obj = document.getElementById('MaxAttachBabies')
	if (obj) MaxAttachBabies = obj.value;
	/*if (MaxAttachBabies == "") {
		alert(t['NULL_MaxAttachBabies'])
		return;
	}*/

	var obj = document.getElementById('UpdateRecord');
	if (obj) {
		var encmeth = obj.value;
		var resStr = cspRunServerMethod(encmeth, BMBID, WardID, BedTypeID, LeftOffset, TopOffset, IntervalX, IntervalY, Width, Height, BabyIntervalY, MaxAttachBabies)
		if (resStr != '0') {
			alert(t['Error']+":"+resStr);
			return;
		}
		else {
			alert(t['Success']);
			location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCBedMaternalBaby&HospitalRowId="+document.getElementById('HospitalRowId').value+"&HospitalName="+document.getElementById('HospitalName').value;
		}
	}

}

function Delete_click() {
	var BMBID;
	var obj = document.getElementById('BMBID');
	if (obj) BMBID = obj.value;
	if (BMBID == "") {
		alert(t['Please Select One'])
		return;
	}
	var r=confirm("确认删除？");
	if (r == true) {
		var obj = document.getElementById('DeleteRecord')
			if (obj)
				var encmeth = obj.value;
			var resStr = cspRunServerMethod(encmeth, BMBID);
		if (resStr != '0') {
			alert(t['Error']);
			return;
		} else {
			alert(t['Success']);
			location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCBedMaternalBaby&HospitalRowId="+document.getElementById('HospitalRowId').value+"&HospitalName="+document.getElementById('HospitalName').value;
		}
	} else {
		return;
	}
}
document.body.onload = BodyLoadHandler;
