// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// dont do this on body load because it overrides other components on the same frame
var objW=document.getElementById("WorkID");

// ab 7.08.02 - 27092 - worklist stuff - for every listdoccurrent table on the frame
// set the targets for the icon links to reload the entire worklist rather than the individual frame

if ((objW)&&(objW.value!="")) {
    //var aryListDocs=document.forms
    for (var j=0;j<document.all.length;j++)
    {
      if (document.all[j].tagName=="TABLE")
      {
          //var df=aryListDocs[j].id;
          //var tbllistdoc=document.getElementById("t"+df.substring(1,df.length));
          var tbllistdoc=document.all[j];
          for (var i=1;i<tbllistdoc.rows.length;i++) {
             for (var k=0;k<tbllistdoc.rows[i].all.length;k++) {
                 var childid="",child=tbllistdoc.rows[i].all[k];
                 childid=child.id.split("z");
                 if ((childid[0]=="CustomIcon1")||(childid[0]=="CustomIcon2")) {
                   child.target="_parent";
                 }
             }
          }
      }//if
    }
	// ab 04.11.02 - set all the 'find' click handlers to function inside the worklist (can have multiple of the same component on the same page)
	for (var i=0;i<document.all.tags("DIV").length;i++) {
		div=document.all.tags("DIV")[i];
		if (div) {
		    for (var j=0;j<div.all.tags("A").length;j++) {
				if (div.all.tags("A")[j].id=="find1") {
					var obj=div.all.tags("A")[j];
					if (obj) obj.onclick=findClickHandler;
				}
			}
		}
	}

}

function findClickHandler(e) {
		var frm="";
		var tabfound=0;
		var overrideLoc=1;
		var overrideCP=1;
		var hasPref=0;
		var eSrc=websys_getSrcElement(e);
		if (eSrc.id=="") eSrc=websys_getParentElement(eSrc);

		//create the link string manually from the current components elements
		// linkvar string = WorkID + hidden inputs + visible inputs on form
		var linkvar="&WorkID="+objW.value;
		// bubble up from the find button and get the associated form, and fields from table and div
		while (frm=="") {
			eSrc=websys_getParentElement(eSrc);

			// get all of the visible inputs to add to the linkvar string (from the first found table)
			if ((tabfound==0)&&(eSrc.tagName=="TABLE")) {
				tabfound=1;
				for (var i=0;i<eSrc.all.tags("INPUT").length;i++) {
					var obj=eSrc.all.tags("INPUT")[i];
                    // ab 9.12.04 - 48162 - dont pass hidden fields here, was passing all the hidden row fields and making very long string
					if ((obj)&&(obj.type!="hidden")) {
						if ((obj.value=="on")&&(obj.checked==true)) linkvar=linkvar+"&"+obj.id+"=on";
						//if ((obj.value!="on")&&(obj.id!="")) linkvar=linkvar+"&"+obj.id+"="+escapeString(obj.value);
						if ((obj.value!="on")&&(obj.id!="")) linkvar=linkvar+"&"+obj.id+"="+websys_escape(obj.value);
						
						if (obj.id=="Unit") overrideLoc=0;
						if (obj.id=="CareProvider") {	overrideCP=0;}
						
						if ((obj.id=="OPConsultRm")&&(obj.value!="")) {
							var dfobj=document.getElementById("DateFrom");
							var dtobj=document.getElementById("DateTo");
							if (((dfobj)&&(dfobj.value==""))||(((dtobj)&&(dtobj.value=="")))) {
								alert(t['DateFrom']+", "+t['DateTo']+" "+t['XMISSING'])
								return false;
							}
						}
					}
				}
			}

			// get all of the hidden values to be passed through
			if (eSrc.tagName=="FORM") {
				frm=eSrc;
				for (var i=0;i<frm.children.tags("INPUT").length;i++) {
					var obj=frm.children.tags("INPUT")[i];
					//Log 62783 PeterC 28/02/07
					if ((obj.id=="PrefParams")&&(obj.id.value!="")) hasPref=1;
				}
				for (var i=0;i<frm.children.tags("INPUT").length;i++) {
					var obj=frm.children.tags("INPUT")[i];
					if ((obj)&&(obj.id!="")){
						// ab 4.08.03 - 37938 - passes location through if not on the page
						if (obj.id=="LocHidden") {
							//alert(linkvar);
							//if (overrideLoc) linkvar=linkvar+"&Location="+escapeString(obj.value);
							if (overrideLoc) linkvar=linkvar+"&Location="+websys_escape(obj.value);
							//alert(linkvar);
							
						} else if (obj.id=="DocHidden") {
							//if (overrideCP) linkvar=linkvar+"&CareProvider="+escapeString(obj.value);
							//Log 62783 PeterC 28/02/07
							linkvar=linkvar+"&Doctor="+websys_escape(obj.value);
							if ((overrideCP)&&(!hasPref)) linkvar=linkvar+"&CareProvider="+websys_escape(obj.value);
													
						} else {
							if ((obj.value=="on")&&(obj.checked==true)) linkvar=linkvar+"&"+obj.id+"=on";
							if ((obj.value!="on")&&(obj.id!="")) linkvar=linkvar+"&"+obj.id+"="+escapeString(obj.value);
							
							
						}
					}
				}
			}
		}
		if (!frm) return false;

		//alert(linkvar);
		window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=PAAdm.ListDocCurrent"+linkvar;
		return false;
}

function linkadd(linkvar,name) {
	var obj=document.getElementById(name);
	if (obj) {

	}
	return linkvar;
}

// ab 4.08.03 NOTE: please modify the 'findclickhandler' to reflect any changes made here, it is used from within worklists
function findHandler() {
	var obj=document.getElementById("OPConsultRm");
	if ((obj)&&(obj.value!="")) {
		var dfobj=document.getElementById("DateFrom");
		var dtobj=document.getElementById("DateTo");
		if (((dfobj)&&(dfobj.value==""))||(((dtobj)&&(dtobj.value=="")))) {
			alert(t['DateFrom']+", "+t['DateTo']+" "+t['XMISSING'])
			return false;
		}
	}
	return find1_click();
}

function DisableField(fldName,icN) {
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.disabled = true;
	}
	if (icN) {
		var objIcon=document.getElementById(icN);
		if (objIcon) objIcon.style.visibility = "hidden";
	}

}

/*function TempLocLookupHandler(str) {
	var lu=str.split("^");
	alert(lu);
	var obj=document.getElementById("TemporaryLocation")
	if (obj) obj.value=lu[0];
}*/

function EnableField(fldName,icN) {
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.disabled = false;
	}
	if (icN) {
		var objIcon=document.getElementById(icN);
		if (objIcon) objIcon.style.visibility = "";
	}

}

function CheckFields(){
	var obj1=document.getElementById("Unit");
	var obj2=document.getElementById("OPConsultRm");
	var obj3=document.getElementById("TemporaryLocation");
	var obj4=document.getElementById("CURRLoc");

	// ab 12.02.04 - changed this as we can now search location and ward at the same time
	if ((obj1)&&(obj1.value!="")) DisableAllButOne("Unit","ld506iUnit","CURRLoc","ld506iCURRLoc");
	else if ((obj2)&&(obj2.value!="")) DisableAllButOne("OPConsultRm","ld506iOPConsultRm");
	else if ((obj3)&&(obj3.value!="")) DisableAllButOne("TemporaryLocation","ld506iTemporaryLocation");
	else if ((obj4)&&(obj4.value!="")) DisableAllButOne("CURRLoc","ld506iCURRLoc","Unit","ld506iUnit");
	else {
		enableAll();
	}

}

function CheckUnreadResult(){
	var obj=document.getElementById("NotRead");
	if((obj)&&(obj.checked)) {
		var obj=document.getElementById("OPConsultRm");
		if(obj) obj.value="";
		DisableField("OPConsultRm","ld506iOPConsultRm");

		var obj=document.getElementById("DateFrom");
		if(obj) obj.value="";
		DisableField("DateFrom","ld506iDateFrom");

		var obj=document.getElementById("DateTo");
		if(obj) obj.value="";
		DisableField("DateTo","ld506iDateTo");
	}
	else {
		EnableField("OPConsultRm","ld506iOPConsultRm");
		EnableField("DateFrom","ld506iDateFrom");
		EnableField("DateTo","ld506iDateTo");
	}
	CheckFields();
}

function enableAll(){
	var obj=document.getElementById("NotRead");
	EnableField("Unit","ld506iUnit");
	if(((obj)&&(!obj.checked))||(!obj)) EnableField("OPConsultRm","ld506iOPConsultRm");
	EnableField("TemporaryLocation","ld506iTemporaryLocation");
	EnableField("CURRLoc","ld506iCURRLoc");
}

function DisableAllButOne(fldName,icN,fldName2,icN2){
	//alert("disabling all but: " + fldName);

	if ((fldName!="Unit")&&(fldName2!="Unit")) DisableField("Unit","ld506iUnit");
	if ((fldName!="OPConsultRm")&&(fldName2!="OPConsultRm")) DisableField("OPConsultRm","ld506iOPConsultRm");
	if ((fldName!="TemporaryLocation")&&(fldName2!="TemporaryLocation")) DisableField("TemporaryLocation","ld506iTemporaryLocation");
	if ((fldName!="CURRLoc")&&(fldName2!="CURRLoc")) DisableField("CURRLoc","ld506iCURRLoc");
	EnableField(fldName,icN);
	EnableField(fldName2,icN2);
}

function ListDocCurrentLoadHandler() {
	if ((objW)&&(objW.value=="")) {
		var obj=document.getElementById("find1");
		if(obj) obj.onclick=findHandler;
	}
	var obj=document.getElementById("Unit");
	if ((obj)&&(obj.value!="")&&(obj.onchange)) {
		obj.onchange();
	}

	var obj=document.getElementById("OPConsultRm");
	if(obj) obj.onblur=CheckFields;

	var tempobj=document.getElementById("TemporaryLocation");
	var locobj=document.getElementById("CURRLoc");
	var loctypeobj=document.getElementById("LocTypeHidden");
	var lochiddenobj=document.getElementById("LocHidden");
	if (tempobj) tempobj.onblur=CheckFields;
	if (locobj) locobj.onblur=WardBlurHandler;

	var obj=document.getElementById("Hosp");
	if (obj) obj.onblur=HospitalBlurHandler;

	var obj=document.getElementById("Unit");
	if (obj) obj.onblur=UnitBlurHandler;

	CheckFields();
	CheckUnreadResult();

	var obj=document.getElementById("NotRead");
	if(obj) obj.onclick=CheckUnreadResult;

	var objPrefParams=document.getElementById("PrefParams");
	var objWorkListParams=document.getElementById("WorkListParams");
	var objNoPrefs=document.getElementById("NoPrefs");
	var objPrefLink=document.getElementById("Preferences");
	if (objPrefLink && (objPrefParams.value!="") ) {
		objPrefLink.style.fontWeight="bold";
	}

	// do we want to use ANY prefernces?? - if not -
	if (objNoPrefs && objNoPrefs.checked) {
		var today=new Date();
		var objDateFrom=document.getElementById("WLDateFrom");
		var objDateTo=document.getElementById("WLDateTo");
		var DateToday = ReWriteDate(today.getDate(),today.getMonth()+1,today.getYear());
		if (objDateFrom && (objDateFrom.value=="")) {
			//objDateFrom.value = DateToday;
		}
		if (objDateTo && (objDateTo.value=="")) {
			//objDateTo.value = DateToday;
		}
	} else {
		if (objPrefParams && objWorkListParams) {
			if (objPrefParams.value!="" ) {

				//preferences exist...
				var aryParams = objPrefParams.value.split("^")
				if (aryParams.length > 31) {

					var obj=document.getElementById("dtFrom");
					if (obj && (obj.value=="")) {
						if ((aryParams[29]!="") ) {
							obj.value = aryParams[29];
						}
					}
					var obj=document.getElementById("dtTo");
					if (obj && (obj.value=="")) {
						if ((aryParams[30]!="") ) {
							obj.value = aryParams[30];
						}
					}
					// Hospital Codes
					if (aryParams[5]!="") {
						var obj = document.getElementById("HospCodes");
						if (obj) {
							var arrhospstr = aryParams[5].split(String.fromCharCode(1));
							var ids = "";
							for (var tmphosp = 0; tmphosp < arrhospstr.length; tmphosp++) {
								var arypiece = arrhospstr[tmphosp].split(String.fromCharCode(2))
								if (arypiece.length > 2) {
									if (ids !="" ) { ids+= "|";}
									ids+= arypiece[2];
								}
							}
							obj.value = ids;
						}
					}
					// Care Provider
					/*
					if (aryParams[6]!="") {
						var arrCodes = aryParams[6].split(String.fromCharCode(1));
						if (arrCodes.length==1) {
							var arrtxt = arrCodes[0].split(String.fromCharCode(2));
							var obj = document.getElementById("WLCP");
							if (obj && (obj.value=="")) {
								obj.value = arrtxt[1];
							}
						}
					}
					*/
					// location

					if (aryParams[8]!="") {
						var strLoc = "";
						var arrCodes = aryParams[8].split(String.fromCharCode(1));
						/*
						if (arrCodes.length==1) {
							var arrtxt = arrCodes[0].split(String.fromCharCode(2));
							var obj = document.getElementById("Unit");
							if (obj ) {
								obj.value = arrtxt[1];
							}
						}
						*/
						var obj = document.getElementById("LocIDs");
						if (obj) {
							obj.value = aryParams[22];
						}
					}

					// ward
					if (aryParams[16]!="") {
						var arrCodes = aryParams[16].split(String.fromCharCode(1));
						/*
						if (arrCodes.length==1) {
							var arrtxt = arrCodes[0].split(String.fromCharCode(2));
							var obj = document.getElementById("CURRLoc");
							if (obj ) {
								obj.value = arrtxt[1];
							}
						}
						*/
					}
				}

			} else {

				// no prefs - so use WorkList defaults
				var aryParams = objWorkListParams.value.split("^")
				if (aryParams.length > 41) {
					var obj=document.getElementById("dtFrom");
					if (obj && (obj.value=="")) {
						if ((aryParams[40]!="") ) {
							obj.value = aryParams[40];
						}
					}
					var obj=document.getElementById("dtTo");
					if (obj && (obj.value=="")) {
						if ((aryParams[41]!="") ) {
							obj.value = aryParams[41];
						}
					}
					// Hospital Codes
					if (aryParams[22]!="") {
						var obj = document.getElementById("HospCodes");
						if (obj) {
							var arrhospstr = aryParams[22].split(String.fromCharCode(1));
							var ids = "";
							for (var tmphosp = 0; tmphosp < arrhospstr.length; tmphosp++) {
								var arypiece = arrhospstr[tmphosp].split(String.fromCharCode(2))
								if (arypiece.length > 2) {
									if (ids !="" ) { ids+= "|";}
									ids+= arypiece[2];
								}
							}
							obj.value = ids;
						}
					}
					/*
					// Care Prov
					if (aryParams[25]!="") {
						var arrCodes = aryParams[25].split(String.fromCharCode(1));
						if (arrCodes.length==1) {
							var arrtxt = arrCodes[0].split(String.fromCharCode(2));
							var obj = document.getElementById("WLCP");
							if (obj && (obj.value=="")) {
								obj.value = arrtxt[0];
							}
						}
					}
					*/
					// location (unit)
					if (aryParams[33]!="") {
						var arrCodes = aryParams[33].split(String.fromCharCode(1));
						/*
						if (arrCodes.length==1) {
							var arrtxt = arrCodes[0].split(String.fromCharCode(2));
							var obj = document.getElementById("Unit");
							if (obj) {
								obj.value = arrtxt[1];
							}
						}
						*/
						var obj = document.getElementById("LocIDs");
						if (obj) {
							obj.value = aryParams[43];
						}
					}
					// ward
					if (aryParams[34]!="") {
						var arrCodes = aryParams[34].split(String.fromCharCode(1));
						/*
						if (arrCodes.length==1) {
							var arrtxt = arrCodes[0].split(String.fromCharCode(2));
							var obj = document.getElementById("CURRLoc");
							if (obj) {
								obj.value = arrtxt[1];
							}
						}
						*/
					}
				}

			}  // if (objPrefParams.value!="" )
		}	// if (obj)
	}	// if (objNoPrefs)




}

// ab 4.09.03 - 38434 will replace the "&" and "?" characters in a string so they are safe to pass in a url
function escapeString(str) {
	return escape(str);
	//str=str.replace(/&/g,"%26");
	//str=str.replace(/\?/g,"%3F");
	//return str;
}


function UnitLookUp(str) {
	var lu = str.split("^");
	var obj=document.getElementById("Unit");
	var LocIDs=document.getElementById("LocIDs");
	if (obj) {
		obj.value = lu[1];
		if (LocIDs) LocIDs.value=lu[3];
	}
}

function UnitBlurHandler() {
	var obj=document.getElementById("Unit");
	var LocIDs=document.getElementById("LocIDs");
	if ((obj)&&(LocIDs)&&(obj.value=="")) LocIDs.value="";

	// ab 5.03.04 - 42710 - if we have a single location and then clear it out, dont restrict the query on subsequent 'finds'
	var locoverride=document.getElementById("LocOverride");
	var loclistobj=document.getElementById("WILocationList");
	if ((obj)&&(loclistobj)&&(locoverride)) {
		if ((obj.value=="")&&(loclistobj.value.split("^").length < 2)) {
			locoverride.value=1;
		} else {
			locoverride.value=0;
		}
	}
	CheckFields();

}

function WardBlurHandler() {
	// ab 17.03.04 - 42710 - if we have a single location and then clear it out, dont restrict the query on subsequent 'finds'
	var obj=document.getElementById("CURRLoc");
	var locoverride=document.getElementById("WardOverride");
	var loclistobj=document.getElementById("WIWardList");
	if ((obj)&&(loclistobj)&&(locoverride)) {
		if ((obj.value=="")&&(loclistobj.value.split("^").length < 2)) {
			locoverride.value=1;
		} else {
			locoverride.value=0;
		}
	}
	CheckFields();

}

function HospitalBlurHandler() {
	var obj=document.getElementById("Hosp");
	var objID=document.getElementById("HospCodes");
	// ab - not sure if we should make this blank or defaultValue
	if ((objID)&&(obj)&&(obj.value=="")) objID.value="";
}

function HospLookup(str) {
	var lu = str.split("^");
	var obj=document.getElementById("Hosp");
	var objID=document.getElementById("HospCodes");
	if ((objID)&&(obj)) {
		objID.value=lu[1];
	}
}

document.body.onload=ListDocCurrentLoadHandler;
