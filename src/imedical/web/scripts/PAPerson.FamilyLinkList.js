// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var frm = document.forms["fPAPerson_FamilyLinkList"];

function DocumentLoadHandler(e) {
	//alert(window.name)
	//alert(window.parent.name)
	var objTable=document.getElementById("tPAPerson_FamilyLinkList");
	var IDObj=document.getElementById("pat");
	//alert(IDObj);
	var eSrc;
	//var newlink=document.getElementById("New1");
	//if (newlink) newlink.onclick=NewClickHander;
	//var updateObj=document.getElementById("update1");

	//if (updateObj) updateObj.onclick=updateClickHandler;

	if (objTable) objTable.onclick=FamClickHandler;

	if (objTable) {
		var numRows=objTable.rows.length;
		var currentRow;
		var currentIdObj,currentLink,currentDelete;

		for (i=1;i<numRows;i++) {
			currentRow=objTable.rows[i];
			currentIdObj=document.getElementById("patz"+i);
			//alert(currentIdObj.value);
			currentLink=document.getElementById("relationz"+i);
			currentDelete=document.getElementById("delete1z"+i);
			//alert(currentLink);
			//alert(currentDelete);
			if (currentIdObj&&IDObj&&(currentIdObj.value==IDObj.value)) {
				//alert(currentIdObj.value);
				currentLink.click();
			}

		}

	} //Row Highlight
}

function updateClickHandler() {
	//alert(frm.elements['TWKFL'].value)
	if (window.name=="tempAddr_list") {
		if (frm.elements['TWKFL'].value!="") frm.elements['TFRAME'].value=window.parent.name;
		//if (frm.elements['TWKFL']!="") frm.elements['TFRAME'].value=window.parent.name
	}
	return update1_click();

}

function FamClickHandler(e) {

	var patid="",epid="",parref="",addrid="",lnk="",id="";
	var patid=document.getElementById("PatientID");
	if (patid) patid=patid.value;
	var epid=document.getElementById("EpisodeID");
	if (epid) epid=epid.value;
	var parref=document.getElementById("PARREF");
 	if (parref) parref=parref.value;
	var addrid=document.getElementById("ADDR_RowId");
 	if (addrid) addrid=addrid.value
	var eSrc = websys_getSrcElement(e);

	if (parent.frames["PAPerson_FamilyLinkEdit"]) {
		if (eSrc.tagName=="IMG") {
			eSrc=websys_getParentElement(eSrc)
		}
		var eSrcAry=eSrc.id.split("z");

		if (eSrc.tagName=="A") {

			if (eSrc.id.indexOf("relationz")==0) {
				//alert(eSrc.href);
				eSrc.target = "PAPerson_FamilyLinkEdit";
				var currentlink=eSrc.href.split("?");
				//alert(currentlink[1]);
				eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=PAPerson.FamilyLinkEdit&" + currentlink[1];
				eSrc=websys_getParentElement(eSrc);
				if (selectedRowObj!=eSrc) SelectRow();
				eSrc.href=lnk
			}
			if (eSrcAry[0]=="delete1") {
				var objrelationcode=document.getElementById('relationcodez'+eSrcAry[1]);

				// mother
				if (objrelationcode.value=="M") {
					alert(t["BabyMotherDelete"]);
				}
				// child
				if (objrelationcode.value=="C") {
					if (confirm(t["MotherBabyDelete"])) {
						var objpat=document.getElementById('patz'+eSrcAry[1]);
						var OriginalPatientID=document.getElementById("PatientID");
						var TRELOADID=document.getElementById("TRELOADID");
						//alert(TRELOADID.value);
						var TPAGID=document.getElementById("TPAGID");
						//alert(TPAGID.value);
						//websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=PAPerson.Edit&PatientID='+objpat.value+'&ID='+objpat.value,'comp','top=20,left=20,width=300,height=300,scrollbars=yes,resizable=yes');
						eSrc.href = "websys.csp?WEBSYS.TCOMPONENT=PAPerson.Edit&PatientID="+objpat.value+"&ID="+objpat.value+"&TEVENT=t1848idelete1"+"&OriginalPatientID="+OriginalPatientID.value+"&pat="+objpat.value+"&relationcode="+objrelationcode.value  //+"&TRELOADID="+TRELOADID.value+"&TPAGID="+TPAGID.value
						eSrc.target="_parent"

					} else {

						//alert("no");

					}


				}


			}
			if (eSrc.id.indexOf("regoz")==0) {
				//alert("reg");
				//eSrc.target="PAPerson.Edit"
				//if  (TWKFLI.value=="") {
				//	var currentlink=eSrc.href.split("?");
				//	var lnk="patempaddrframe.csp?ADDR_DateTo="+addrDTo+"&PARREF="+parref+"&EpisodeID="+epid+"&hiddenLinks="+hidlnk+"&PatientID="+patid+"&ID="+addrid;
				//	//alert("if: "+lnk)
				//} else {
				//	var currentlink=eSrc.href.split("&TWKFLI=");
				//	var twkfli=currentlink[1].split("&ID=")
				//	var lnk=currentlink[0]+"&ID="+twkfli[1]+"&EpisodeID="+epid+"&PatientID="+patid+"&hiddenLinks="+hidlnk+"&TWKFLI="+(TWKFLI-1)+"&admType="+admtype;
				//	//alert("else: "+lnk)
				//}
			}


		}
	}
}


document.body.onload = DocumentLoadHandler;


/* log 61939 commented out
function SelectRowHandler(evt) {
	//alert("cjb2");
	var eSrc=websys_getSrcElement(evt);
	var rowObj=getRow(eSrc);
	if (rowObj.tagName != "TH") {
		if (eSrc.tagName != "A") eSrc=websys_getParentElement(eSrc);
		if (eSrc.tagName != "A") return;
		var rowsel=rowObj.rowIndex;
		//var lnk="patempaddrframe.csp?TWKFL="+document.getElementById("TWKFL").value;

		el=document.forms['fPAPerson_FamilyLinkEdit'].elements['TWKFLI'];
		if (el) lnk+="&TWKFLI="+el.value;
		el=document.getElementById("PatientID");
		if (el) lnk+="&PatientID="+el.value;
		el=document.getElementById("EpisodeID");
		if (el) lnk+="&EpisodeID="+el.value;
		//alert("cjb3");
		window.location=lnk;

		return false;

	}
}*/
