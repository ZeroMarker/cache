// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// YC - don't put a load handler on this component since it conflicts with the "onload" on epr.clinicalhistory.csp
//function DocumentLoadHandler()

assignClickHandler();

obj=document.getElementById("new1");
if (obj) obj.onclick=ClearFields;

obj=document.getElementById("ConsultID");
if (obj) {
	if (obj.value!="") {
		disableFields(true);
		var consary=obj.value.split("||");
		expandFirstTree(consary[0]+"||"+consary[1]);
	}
	else expandFirstTree("");
}
else expandFirstTree("");

obj=document.getElementById("find1");
if (obj) obj.onclick=FindClickHandler;

function ClearFields() {
	disableFields(false);

	var field=document.getElementById("CONSConsultSetDesc");
	if (field) {
		field.value="";
		field.readOnly=false;
		field.className="";
	}

	var field=document.getElementById("CONSVisitTime");
	if (field) {
		field.value="";
		field.className="";
	}

	var field=document.getElementById("CONSVisitDate");
	if (field) {
		field.value="";
		field.className="";
	}

	var field=document.getElementById("CONSSignificant");
	if (field) field.checked=false;

	var field=document.getElementById("CONSCareProv");
	if (field) {
		field.value="";
		field.className="";
	}

	var field=document.getElementById("CONSConsultSetCat");
	if (field) {
		field.value="";
		field.readOnly=false;
		field.className="";
	}

	var field=document.getElementById("CONSSubCat");
	if (field) {
		field.value="";
		field.readOnly=false;
		field.className="";
	}

	var field=document.getElementById("CONSConsultSetCatDR");
	if (field) field.value="";

	var field=document.getElementById("CONSSubCatDR");
	if (field) field.value="";

	var field=document.getElementById("CONSCareProvDR");
	if (field) field.value="";

	var field=document.getElementById("ConsultID");
	if (field) field.value="";

	var field=document.getElementById("CONSConsultSetID");
	if (field) field.value="";

	var field=document.getElementById("updateflg");
	if (field) field.value="";

	return false;
}

function disableFields(status) {
	var invalid=0;

	var field=document.getElementById("CONSConsultSetDesc");
	if (field) {
		field.disabled=status;
		field.readOnly=status;
		if (field.className=="clsInvalid") invalid=1;
	}

	var field=document.getElementById("CONSVisitTime");
	if (field) {
		field.disabled=status;
		field.readOnly=status;
		if (field.className=="clsInvalid") invalid=1;
	}

	var field=document.getElementById("CONSVisitDate");
	if (field) {
		field.disabled=status;
		field.readOnly=status;
		if (field.className=="clsInvalid") invalid=1;
	}

	var field=document.getElementById("ld2193iCONSVisitDate");
	if (field) field.disabled=status;

	var field=document.getElementById("CONSCareProv");
	if (field) {
		field.disabled=status;
		field.readOnly=status;
		if (field.className=="clsInvalid") invalid=1;
	}

	var field=document.getElementById("ld2193iCONSCareProv");
	if (field) field.disabled=status;

	var field=document.getElementById("CONSConsultSetCat");
	if (field) {
		field.disabled=status;
		field.readOnly=status;
		if (field.className=="clsInvalid") invalid=1;
	}

	var field=document.getElementById("ld2193iCONSConsultSetCat");
	if (field) field.disabled=status;

	var field=document.getElementById("CONSSubCat");
	if (field) {
		field.disabled=status;
		field.readOnly=status;
		if (field.className=="clsInvalid") invalid=1;
	}

	var field=document.getElementById("ld2193iCONSSubCat");
	if (field) field.disabled=status;

	var field=document.getElementById("CONSSignificant");
	if (field) {
		field.disabled=status;
		if (field.className=="clsInvalid") invalid=1;
	}

	var field=document.getElementById("update1");
	if (field) {
		field.disabled=status;
		if (status==true) field.onclick={};
		else field.onclick=update1_click;
	}

	if (status==true && invalid==1) disableFields(false);

	return false;
}

function assignClickHandler() {
	var tbl=document.getElementById("tepr_SOAPConsultation_Tree");
	for (var i=1;i<tbl.rows.length;i++) {
		var objNew=document.getElementById("NewConsultationz"+i)
		if (objNew) objNew.onclick=CatClickHandler;
		var objEdit=document.getElementById("Editz"+i)
		if (objEdit) objEdit.onclick=CatEditClickHandler;
		if(tbl.rows[i].id.indexOf("r2193iConsultationz")!=-1) {
			var elems=websys_getChildElements(tbl.rows[i]);
			for(var j=1;j<elems.length;j++) {
				if(elems[j].id.indexOf("Edit1z")!=-1) {
					elems[j].onclick=ConsEditClickHandler;
				}
			}
		}
	}
	return false;
}

function CatEditClickHandler(e) {
	var obj=websys_getSrcElement(e);
	if ((obj)&&(obj.tagName=="IMG")) obj=websys_getParentElement(obj);
	if (obj) {
		var rowid=obj.id;
		var rowAry=rowid.split("z");
		var HIDDEN=document.getElementById("HIDDENz"+rowAry[1]).value;

		EditFields(HIDDEN,"");
	}

	return false;
}

// new consultation button
function CatClickHandler(e) {
	ClearFields();

	var obj=websys_getSrcElement(e);
	if ((obj)&&(obj.tagName=="IMG")) obj=websys_getParentElement(obj);
	if (obj) {
		var rowid=obj.id;
		var rowAry=rowid.split("z");
		var HIDDEN=document.getElementById("HIDDENz"+rowAry[1]).value;
		var temp=HIDDEN.split("^");

		var field=document.getElementById("CONSConsultSetID");
		if (field) field.value=temp[0];

		var field=document.getElementById("CONSConsultSetDesc");
		if (field) {
			field.value=temp[1];
			field.className="disabledField";
			field.readOnly=true;
		}

		var field=document.getElementById("CONSConsultSetCat");
		if (field) {
			field.value=temp[2];
			field.className="disabledField";
			field.readOnly=true;
		}

		var field=document.getElementById("ld2193iCONSConsultSetCat");
		if (field) field.disabled=true;

		var field=document.getElementById("CONSConsultSetCatDR");
		if (field) field.value=temp[3];

		var field=document.getElementById("CONSSubCat");
		if (field) {
			field.value=temp[4];
			field.className="disabledField";
			field.readOnly=true;
		}

		var field=document.getElementById("ld2193iCONSSubCat");
		if (field) field.disabled=true;

		var field=document.getElementById("CONSubCatDR");
		if (field) field.value=temp[5];
	}

	return false;
}

// Gets called by CatEditClickHandler and ConsEditClickHandler
function EditFields(CatHidden, ConsHidden) {
	var temp=CatHidden.split("^");

	ClearFields();

	if(ConsHidden=="") {
		var field=document.getElementById("CONSVisitTime");
		if (field) {
			field.readOnly=true;
			field.className="disabledField";
		}

		var field=document.getElementById("CONSVisitDate");
		if (field) {
			field.readOnly=true;
			field.className="disabledField";
		}

		var field=document.getElementById("ld2193iCONSVisitDate");
		if (field) field.disabled=true;

		var field=document.getElementById("CONSCareProv");
		if (field) {
			field.readOnly=true;
			field.className="disabledField";
		}

		var field=document.getElementById("ld2193iCONSCareProv");
		if (field) field.disabled=true;

		var field=document.getElementById("CONSSignificant");
		if (field) field.disabled=true;

		var field=document.getElementById("updateflg");
		if (field) field.value="1";
	}

	var field=document.getElementById("CONSConsultSetID");
	if (field) field.value=temp[0];

	var field=document.getElementById("CONSConsultSetDesc");
	if (field) {
		field.value=temp[1];
		if(ConsHidden!="") {
			field.readOnly=true;
			field.className="disabledField";
		}
	}

	var field=document.getElementById("CONSConsultSetCat");
	if (field) {
		field.value=temp[2];
		if(ConsHidden!="") {
			field.readOnly=true;
			field.className="disabledField";
		}
	}

	var field=document.getElementById("CONSConsultSetCatDR");
	if (field) field.value=temp[3];

	var field=document.getElementById("CONSSubCat");
	if (field) {
		field.value=temp[4];
		if(ConsHidden!="") {
			field.readOnly=true;
			field.className="disabledField";
		}
	}

	var field=document.getElementById("CONSSubCatDR");
	if (field) field.value=temp[5];

	if(ConsHidden!="") {
		var temp2=ConsHidden.split("^");

		var field=document.getElementById("ConsultID");
		if (field) field.value=temp2[0];

		var field=document.getElementById("CONSVisitDate");
		if (field) field.value=temp2[1];

		var field=document.getElementById("CONSVisitTime");
		if (field) field.value=temp2[2];

		var field=document.getElementById("CONSCareProv");
		if (field) field.value=temp2[3];

		var field=document.getElementById("CONSCareProvDR");
		if (field) field.value=temp2[4];

		var field=document.getElementById("CONSSignificant");
		if (field && temp2[5]=="Y") field.checked=true;

		var field=document.getElementById("ld2193iCONSConsultSetCat");
		if (field) field.disabled=true;

		var field=document.getElementById("ld2193iCONSSubCat");
		if (field) field.disabled=true;
	}
}

function ConsetCatLookUpHandler(str) {
 	var lu = str.split("^");

	var obj=document.getElementById('CONSConsultSetCatDR');
	if (obj) {
		if (obj.value!=lu[1]) {
			var obj2=document.getElementById('CONSSubCat');
			if (obj2) { if(!obj2.disabled) obj2.value=""; }
			var obj2=document.getElementById('CONSSubCatDR');
			if (obj2) { if(!obj2.disabled) obj2.value=""; }
		}
		obj.value=lu[1];
	}
}

function ConsetSubCatLookUpHandler(str) {
 	var lu = str.split("^");

	var obj=document.getElementById('CONSSubCatDR');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('CONSConsultSetCatDR');
	if (obj) {
		obj.value=lu[3];
		var obj2=document.getElementById('CONSConsultSetCat');
		if (obj2) obj2.value=lu[4];
	}
}

function CareProvLookUpHandler(str) {
 	var lu = str.split("^");

	var CareProvDR=document.getElementById('CONSCareProvDR');
	if (CareProvDR) {
		CareProvDR.value=lu[1];
	}
}

// 60476 YC - grabs the hidden fields of both the consult set and consultation for editing
function ConsEditClickHandler(e) {
	var obj=websys_getSrcElement(e);
	var obj2;
	var trary="";
	if ((obj)&&(obj.tagName=="IMG")) {
		try {
			while(obj.tagName!="TR" || obj.id.indexOf("r2193iConsultationz")==-1) {
				// keeps grabbing the parent element until it finds the consultation tree <TR>
				obj=websys_getParentElement(obj);
				if(obj.tagName=="TR" && obj.innerHTML.indexOf("tHIDDENz")!=-1 && trary=="") {
					// picks up the elements in the row that contains the tHIDDEN field
					trary = obj.getElementsByTagName("input");
				}
			}
		} catch(e) { };
	}
	if(obj && obj.id.indexOf("r2193iConsultationz")!=-1 && trary!="") {
		var idary=obj.id.split("r2193iConsultationz");
		if(idary[1]!="") {
			// gets the consult set HIDDEN field
			var obj3 = document.getElementById("HIDDENz"+idary[1]);
			for(i=0;i<trary.length;i++) {
				// gets the consultation tHIDDEN field
				if(trary[i].id.indexOf("tHIDDENz")!=-1) obj2=trary[i];
			}
		}
	}
	if (obj3 && obj2) {
		EditFields(obj3.value,obj2.value);
	}

	return false;
}

// Log 59748 YC
// expands the first tree or tree where consult is selected (if one is selected)
function expandFirstTree(consultSelected) {
	var arrLookUps=document.getElementsByTagName("IMG");
	// if we clicked find then expand all trees
	var isFind=0;
	var isFindobj=document.getElementById("isFind");
	if (isFindobj) isFind=isFindobj.value;
	var rownum=0;
	if(arrLookUps){
		for (var i=0; i<arrLookUps.length; i++) {
			if (isFind!=1 && consultSelected!="") {
				if(arrLookUps[i].src.indexOf("plus.gif") != -1){
					rownum++;
					var cons=document.getElementById("ConsultSetDRz"+rownum);
					if (cons) {
						if (cons.value==consultSelected) {
							arrLookUps[i].onclick();
							//websys_getParentElement(cons);
							// websys.List
							break;
						}
					}
				}
				if(arrLookUps[i].src.indexOf("minus.gif") != -1) {
					rownum++;
					var cons=document.getElementById("ConsultSetDRz"+rownum);
					if (cons) {
						if (cons.value==consultSelected) {
							//websys_getParentElement(cons);
							break;
						}
					}
				}
			}
			else {
				if(arrLookUps[i].src.indexOf("plus.gif") != -1){
					arrLookUps[i].onclick();
					if (isFind!=1) break;
				}
				if(arrLookUps[i].src.indexOf("minus.gif") != -1) {
					if (isFind!=1) break;
				}
			}
		}
	}

	// Log 60566 YC - hides all empty consult categories when searching
	if(isFind==1) {
		var t=document.getElementById("tepr_SOAPConsultation_Tree");
		for (i=0;i<t.rows.length;i++) {
			if(t.rows[i].id.indexOf("r2193iConsultationz")!=-1 && t.rows[i].innerHTML.indexOf("ConsultDRz1")==-1) {
				t.rows[i].style.display="none";
				t.rows[i-1].style.display="none";
			}
		}
	}

	if (isFindobj) isFindobj.value=0;
}

function SearchDiagnosisLookup(str) {
	var lu=str.split("^");
	var objDesc=document.getElementById("SearchDiagnosis");
	if (objDesc) objDesc.value=lu[0];
	var objCode=document.getElementById("SearchDiagnosisID");
	if (objCode) objCode.value=lu[2]+"^"+lu[3]; //id + "^" + type(ICD or SNOMED)
}

function SearchCareProvLookup(str) {
 	var lu = str.split("^");
	var obj=document.getElementById('SearchCareProvID');
	if (obj) obj.value=lu[1];
}

function SearchChiefComplaintLookup(str) {
 	var lu = str.split("^");
	var obj=document.getElementById('SearchChiefComplaintID');
	if (obj) obj.value=lu[1]+"^"+lu[3]; //id + "^" + SNOMED(Y or N)
}

function SearchConsultCatLookup(str) {
 	var lu = str.split("^");
	var obj=document.getElementById("SearchConsultCategoryID");
	if (obj) obj.value=lu[1];
}

function SearchSubCatLookup(str) {
 	var lu = str.split("^");
	var obj=document.getElementById("SearchSubCatID");
	if (obj) obj.value=lu[1];
}

function FindClickHandler() {
	var obj=document.getElementById("ConsultID");
	if (obj) obj.value="";

	// Clear ID fields if their corresponding lookup field is blank
	var obj=document.getElementById("SearchConsultCategory");
	if (obj) {
		if (obj.value=="") {
			var idobj=document.getElementById("SearchConsultCategoryID");
			if (idobj) idobj.value="";
		}
	}

	var obj=document.getElementById("SearchSubCat");
	if (obj) {
		if (obj.value=="") {
			var idobj=document.getElementById("SearchSubCatID");
			if (idobj) idobj.value="";
		}
	}

	var obj=document.getElementById("SearchCareProv");
	if (obj) {
		if (obj.value=="") {
			var idobj=document.getElementById("SearchCareProvID");
			if (idobj) idobj.value="";
		}
	}

	var obj=document.getElementById("SearchDiagnosis");
	if (obj) {
		if (obj.value=="") {
			var idobj=document.getElementById("SearchDiagnosisID");
			if (idobj) idobj.value="";
		}
	}

	var obj=document.getElementById("SearchChiefComplaint");
	if (obj) {
		if (obj.value=="") {
			var idobj=document.getElementById("SearchChiefComplaintID");
			if (idobj) idobj.value="";
		}
	}

	var obj=document.getElementById("isFind");
	if (obj) obj.value=1;

	return find1_click();
}

var EpisodeId=document.getElementById("EpisodeID");
var tables=document.getElementsByTagName("TABLE");
for(var i=0; i<tables.length; i++){
	var tobj=tables[i];
	if(tobj && tobj.id=="tepr_SOAPConsultations"){
		for(var CurrentRow=1; CurrentRow<tobj.rows.length; CurrentRow++){
			for(var iCell=0; iCell<tobj.rows[CurrentRow].cells.length; iCell++){
				for( var e=0; e<tobj.rows[CurrentRow].cells[iCell].children.length; e++ ) {
					var child=tobj.rows[CurrentRow].cells[iCell].children[e];
					if( child && (child.id=="EpisodeIDz"+CurrentRow) && (child.value!=EpisodeId.value) ){
						for(var CurrentCell=0; CurrentCell<tobj.rows[CurrentRow].cells.length; CurrentCell++) {
							tobj.rows[CurrentRow].cells[CurrentCell].style.fontStyle="Italic";
						}
						break;
					}
				}
			}
		}
	}
}

// YC - don't put a load handler on this component since it conflicts with the "onload" on epr.clinicalhistory.csp
//document.body.onload = DocumentLoadHandler;
