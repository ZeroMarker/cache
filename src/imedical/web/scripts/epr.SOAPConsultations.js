cassignClickHandler();

function cassignClickHandler() {
	var tbl=document.getElementById("tepr_SOAPConsultations");
	alert(tbl.rows.length);
	for (var i=1;i<tbl.rows.length;i++) {
	alert("test");
		var objEdit=document.getElementById("VisitDatez"+i)
		alert(i);
		if (objEdit) {
			alert(objEdit.name);
			objEdit.onclick=ClickHandler;
		}
	}
	return false;
}

function ClickHandler(e) {
	var obj=websys_getSrcElement(e);
	if ((obj)&&(obj.tagName=="IMG")) obj=websys_getParentElement(obj);
	if (obj) {
		var rowid=obj.id;
		var rowAry=rowid.split("z");
		var HIDDEN=document.getElementById("HIDDENz"+rowAry[1]).value;
		var temp=HIDDEN.split("^");
		/*
		//ClearFields();
		ConsultDR_"^"_VisitDate_"^"_VisitTime_"^"_CareProv_"^"_ChiefComplaint_"^"_Diagnosis
		
	  var field=document.getElementById("CONSConsultSetID");
	  if (field) field.value=temp[0];
		
	  var field=document.getElementById("CONSConsultSetDesc");
	  if (field) field.value=temp[1];
	
	  var field=document.getElementById("CONSConsultSetCat");
	  if (field) field.value=temp[2];
	
	  var field=document.getElementById("CONSConsultSetCatDR");
	  if (field) field.value=temp[3];
	  */
	}
	return false;
}