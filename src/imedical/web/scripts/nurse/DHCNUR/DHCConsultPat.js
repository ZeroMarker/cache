/**
 * @author Administrator
 */
var locdata = new Array();
var condata = new Array();

function BodyLoadHandler() {
	var dep = Ext.getCmp("ConsultDep");
	if (dep != null) {
		//cspRunServerMethod(getloc, 'addloc');
		//cspRunServerMethod(getloc,"DOCTOR","addloc");
		tkMakeServerCall("web.DHCNurSyComm", "getloc1", "DOCTOR", "addloc");
		dep.store.loadData(locdata);
		dep.on('change', updatefindperson);
	}
	setwindow();
}

function findperson(combo, record, index) {
	//alert(combo.value+"^"+record+"^"+index);
	person = new Array();
	var cmb = Ext.getCmp("RequestConDoc");
	cmb.store.loadData(person);
	if (combo.value != "") getlistdata(combo.value, cmb);
}

function updatefindperson(field, newValue, oldValue) {
	//alert(field.value+","+newValue+","+oldValue);
	person = new Array();
	var cmb = Ext.getCmp("RequestConDoc");
	cmb.setValue("");
	cmb.store.loadData(person);

	if (newValue != "") getlistdata(newValue, cmb);
	var cmbdoc = Ext.getCmp("ConsultDoc");
	cmbdoc.setValue("");
	cmbdoc.store.loadData(person);
}

function cmbkey(field, e) {
	if (e.getKey() == Ext.EventObject.ENTER) {
		var pp = field.lastQuery;
		getlistdata("", field);
		// alert(ret);
	}
}
var person = new Array();

function getlistdata(p, cmb) {
	//var GetPerson = document.getElementById('GetPerson');
	//debugger;
	//alert(p);
	//var ret = cspRunServerMethod(GetPerson.value, p);
	var ret = tkMakeServerCall("web.DHCConsult", "GetDoc", p, "DOCTOR");
	if (ret != "") {
		var aa = ret.split('^');
		for (i = 0; i < aa.length; i++) {
			if (aa[i] == "")
				continue;
			var it = aa[i].split('|');
			addperson(it[1], it[0]);
		}
		// debugger;
		cmb.store.loadData(person);
	}
}

function addperson(a, b) {
	person.push({
		desc: a,
		id: b
	});
}

function addloc(a, b) {
	locdata.push({
		id: a,
		desc: b
	});
}

function setwindow() {
	if (NurRecId == "") return;
	// var ret =tkMakeServerCall("web.DHCConsult","getSingleConsult", NurRecId);
	// //alert(ret);
	// var arr = ret.split("^");
	// var dep = Ext.getCmp("ConsultDep");
	// var appdate = Ext.getCmp("AppDate");
	// var apptime = Ext.getCmp("AppTime");
	// var typ = Ext.getCmp("ConType");
	// var inout = Ext.getCmp("InOut");
	// var destin = Ext.getCmp("ConDestination");
	// var atti = Ext.getCmp("Attitude");
	// var cmbdoc = Ext.getCmp("ConsultDoc");
	// var PatDoc = Ext.getCmp("PatDoc");
	// var ConsultDate = Ext.getCmp("ConsultDate");
	// var ConsultTime = Ext.getCmp("ConsultTime");
	// var RequestConDoc = Ext.getCmp("RequestConDoc");
	// var DocGrade = Ext.getCmp("DocGrade");
	// var MoreLoc = Ext.getCmp("MoreLoc_1");
	// dep.setValue( arr[5]);
	// if (arr[5] != "")
	// {
	// 	person = new Array();
	// 	getlistdata(arr[5], cmbdoc);
	// 	person = new Array();
	// 	getlistdata(arr[5], RequestConDoc);
	// }
	// //cmbdoc.on('specialkey', cmbkey);
	// //RequestConDoc.on('specialkey', cmbkey);
	// //if (cmbdoc) getlistdata("", cmbdoc);
	// //if (RequestConDoc) getlistdata("", RequestConDoc);
	// appdate.setValue(arr[0]);
	// apptime.setValue( arr[1]);
	// typ.setValue( arr[4]);
	// var attitudeArr = arr[2].split("@");
	// var attitudeValue="";
	// for (var i=0;i<attitudeArr.length;i++){
	// 		attitudeValue=attitudeValue+attitudeArr[i]+"\n";
	// }
	// atti.setValue( attitudeValue);
	// destin.setValue(arr[3]);
	// inout.setValue(arr[7]);
	// cmbdoc.setValue(arr[6]);
	// PatDoc.setValue( arr[8]);
	// ConsultDate.setValue( arr[9]);
	// ConsultTime.setValue( arr[10]);
	// RequestConDoc.setValue( arr[11]);
	// DocGrade.setValue( arr[12]);
	// if (arr[13]=="Y") MoreLoc.checked=true;
	// else MoreLoc.checked=false;
	// var ConAttitude = Ext.getCmp("Attitude");
	// ConAttitude.disabled=true;
	// var ConsultDate = Ext.getCmp("ConsultDate");
	// ConsultDate.disabled=true;
	// var ConsultTime = Ext.getCmp("ConsultTime");
	// ConsultTime.disabled=true;
	// var ConsultDoc = Ext.getCmp("ConsultDoc");
	// ConsultDoc.disabled=true;



	var ret = tkMakeServerCall("web.DHCConsult", "getSingleConsult", NurRecId);
	var arr = ret.split("^");

	var dep = Ext.getCmp("ConsultDep");
	if (dep != null) {
		cspRunServerMethod(getloc, 'addloc');
		dep.store.loadData(locdata);
		//dep.on('change', updatefindperson);
	}


	var dep = Ext.getCmp("ConsultDep");
	var appdate = Ext.getCmp("AppDate");
	var apptime = Ext.getCmp("AppTime");
	var typ = Ext.getCmp("ConType");
	var inout = Ext.getCmp("InOut");
	var patid = Ext.getCmp("PatId");
	var destin = Ext.getCmp("ConDestination");
	var atti = Ext.getCmp("Attitude");
	var cmbdoc = Ext.getCmp("ConsultDoc");
	cmbdoc.disable();
	var PatDoc = Ext.getCmp("PatDoc");
	var ConsultDate = Ext.getCmp("ConsultDate");
	ConsultDate.disable();
	var ConsultTime = Ext.getCmp("ConsultTime");
	ConsultTime.disable();

	var applytsy = Ext.getCmp("applytsy");
	//applytsy.disable();
	var attitudetsy = Ext.getCmp("attitudetsy");
	var RequestConDoc = Ext.getCmp("RequestConDoc");
	var DocGrade = Ext.getCmp("DocGrade");
	dep.setValue(arr[5]);
	if (arr[5] != "") {
		getlistdata(arr[5], cmbdoc);
		getlistdata(arr[5], RequestConDoc);
	}
	//cmbdoc.on('specialkey', cmbkey);
	//if (cmbdoc) getlistdata("", cmbdoc);
	//if (RequestConDoc) getlistdata("", RequestConDoc);
	appdate.setValue(arr[0]);
	apptime.setValue(arr[1]);
	typ.setValue(arr[4]);
	var attitudeArr = arr[2].split("@");
	var attitudeValue = "";
	for (var i = 0; i < attitudeArr.length; i++) {
		attitudeValue = attitudeValue + attitudeArr[i] + "\n";
	}
	atti.setValue(attitudeValue);
	destin.setValue(arr[3]);
	inout.setValue(arr[7]);
	if (arr[6] != "") {
		cmbdoc.setValue(arr[6]);
	} 
	PatDoc.setValue(arr[8]);
	if (arr[9] != "") {
		ConsultDate.setValue(arr[9]);
	} else {
		ConsultDate.setValue(new Date());
	}
	if (arr[10] != "") {
		ConsultTime.setValue(arr[10]);
	} else {
		ConsultTime.setValue(new Date().dateFormat('H:i'));
	}
	RequestConDoc.setValue(arr[11]);
	applytsy.setValue(arr[13]);
	patid.setValue(arr[15].split("@")[1]);
	DocGrade.setValue(arr[12]);

	attitudetsy.setValue(arr[14]);

	attitudetsy.disable();

	var ret = tkMakeServerCall("web.DHCMGNurComm", "PatInfo", EpisodeID)
	ret = ret.split("^");
	var PatName = Ext.getCmp("PatName");
	PatName.setValue(ret[4].split("@")[1]);
	var Diag = Ext.getCmp("Diag");
	Diag.setValue(ret[8].split("@")[1]);
	var PatDep = Ext.getCmp("PatDep");
	PatDep.setValue(ret[1].split("@")[1]);
	var BedCode = Ext.getCmp("BedCode");
	BedCode.setValue(ret[5].split("@")[1]);
	var PatRegNo = Ext.getCmp("PatRegNo");
	PatRegNo.setValue(ret[0].split("@")[1]);
	var PatId = Ext.getCmp("PatId");
	PatId.setValue(ret[9].split("@")[1]);
	var PatWard = Ext.getCmp("PatWard");
	PatWard.setValue(ret[7].split("@")[1]);
	var PatLevel = Ext.getCmp("PatLevel");
	PatLevel.setValue(ret[25].split("@")[1]);
	var EncryptLevel = Ext.getCmp("EncryptLevel");
	EncryptLevel.setValue(ret[24].split("@")[1]);



	// cmb.on('specialkey',cmbkey);
}