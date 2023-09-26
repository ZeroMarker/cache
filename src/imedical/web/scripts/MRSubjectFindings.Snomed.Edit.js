var qobj=document.getElementById("Qualifiers");
//var q2obj=document.getElementById("Qualifiers2");
var dobj=document.getElementById("Descriptors");
var qlobj=document.getElementById("QualifierList");

function BodyLoadHandler() {
	var updobj=document.getElementById("Update1");
	var concobj=document.getElementById("ConceptID");
	if(updobj && concobj) {
		if (concobj.value=="") {
			updobj.disabled=true;
			updobj.onclick=LinkDisable;
		}
		else {
			updobj.onclick=Update1ClickHandler;
			if (tsc['Update1']) websys_sckeys[tsc['Update1']]=Update1ClickHandler;
		}
	}

	var epId=document.getElementById("EpisodeID");
	var conEpId=document.getElementById("ConsultEpisodeID");
	if(epId && conEpId && conEpId.value!="" && conEpId.value!=epId.value){
		if(updobj){
			updobj.disabled=true;
			updobj.onclick=LinkDisable;
		}
	}

	if (qobj) { //alert(qobj[1].value);
		qobj.multiple=false;
		qobj.onchange=QualifierClickHandler;
		//q2obj.multiple=false;
		//q2obj.onchange=Qual2ClickHandler;
		dobj.multiple=false;
		dobj.onchange=DescriptorClickHandler;
	}

	var obj=document.getElementById("Add");
	if(obj) obj.onclick=AddClickHandler;

	var obj=document.getElementById("Delete");
	if(obj) obj.onclick=DeleteClickHandler;

	// don't allow multiple select
	obj=document.getElementById("DurationUnit");
	if (obj) {
		obj.multiple=false;
		obj.onmousedown=setorigval;
		obj.onchange=checkorigval;
	}

	obj=document.getElementById("DurationNum");
	if(obj) obj.onchange=DurationNumChangeHandler;
}

// YC - this combo of functions allows users to deselect from a listbox when they click a selected option
function setorigval(evt) {
	var obj=websys_getSrcElement(evt);
	origval=obj.selectedIndex;
	obj.selectedIndex=-1;
}

function checkorigval(evt) {
	var obj=websys_getSrcElement(evt);
	if(obj.selectedIndex==origval) obj.selectedIndex=-1;
}
//YC


function QualifierClickHandler() {
	dobj.options.length=0;
	if(qobj.value!="") {
		var dList=document.getElementById("GENSubQualz"+qobj.value);
		if(dList) {
			if(dList.value!="") {
				var dEntry=dList.value.split("^");
				var d;
				for (i=0;i<dEntry.length;i++) {
					d=dEntry[i].split("*");
					dobj[dobj.length] = new Option(d[1],d[0]);
				}
			} else {
				// if no descriptors - auto-add to list
				AddClickHandler();
			}
		}
	}
}

function DescriptorClickHandler() {
		if(dobj && (dobj.selectedIndex!=-1)) {
				AddClickHandler();
		}
}

function AddClickHandler() {
	var idary = "";
	var descary = "";

	if(qlobj) {
		if(qobj) {
			if(qobj.selectedIndex!=-1) {
				// replace - with ^
				idary = qobj.options[qobj.selectedIndex].value.split("_").join("^");
				descary = qobj.options[qobj.selectedIndex].text;
			}
		}
		if(dobj) {
			if(dobj.selectedIndex!=-1) {
				if(idary!="") idary+="^";
				idary += dobj.options[dobj.selectedIndex].value;
				if(descary!="") descary+=" - ";
				descary += dobj.options[dobj.selectedIndex].text;
			}
		}

		if(descary!="" && idary!="" ) {
			qlobj[qlobj.length] = new Option(descary,idary);
		}
	}

	return false;
}

// log 64759 YC - clears duration unit if duration num is deleted
function DurationNumChangeHandler() {
	var objN=document.getElementById("DurationNum");
	var objU=document.getElementById("DurationUnit");
	if (objN && objU && objN.value=="") objU.selectedIndex=-1;

	return DurationNum_changehandler();
}

function DeleteClickHandler() {
	if(qlobj) {
		// goes backwards since the list moves UP everytime you delete something
		for((i=qlobj.options.length-1);i>=0;i--) {
			if(qlobj.options[i].selected==true) {
				qlobj.options[i]=null;
			}
		}
	}

	return false;
}

function Update1ClickHandler() {
	var qslobj=document.getElementById("QualSaveList");
	if(qlobj && qslobj) {
		qslobj.value="";
		for(i=0;i<qlobj.length;i++) {
			if (qlobj[i].value!="") {
				if(qslobj.value!="") qslobj.value+="*";
				qslobj.value+=qlobj[i].value;
			}
		}
	}

	// declare vars & make sure they are all not clsInvalid
	var durobj=document.getElementById("DurationNum");
	if (durobj)	durobj.className="";
	var durunitobj=document.getElementById("DurationUnit");
	if (durunitobj) durunitobj.className="";
	var ODobj=document.getElementById("OnsetDate");
	if (ODobj) ODobj.className="";
	var OTobj=document.getElementById("OnsetTime");
	if (OTobj) OTobj.className="";
	var EDobj=document.getElementById("EndDate");
	if (EDobj) EDobj.className="";
	var ETobj=document.getElementById("EndTime");
	if (ETobj) ETobj.className="";

	// check that both duration and duration unit are entered (must be entered as pairs)
	if (durobj && durobj.value!="") {
		if (!durunitobj) {
			alert(t['DUR_MISSING']);
			return false;
		}
		else if(durunitobj.value=="") {
			durunitobj.className="clsInvalid";
			alert(t['DUR_MISSING']);
			return false;
		}
	}
	if (durunitobj) {
		if (durunitobj.value!="") {
			if (!durobj) {
				alert(t['DUR_MISSING']);
				return false;
			}
			else if (durobj.value=="") {
				durobj.className="clsInvalid";
				alert(t['DUR_MISSING']);
				return false;
			}
		}
	}

	// checks that onset date/time is not in the future
	if(ODobj && ODobj.value!="") {
		if (OTobj && OTobj.value!="") {
			if (DateTimeStringCompareToday(ODobj.value,OTobj.value)==1) {
				alert(t['OnsetDate']+" & "+t['OnsetTime']+" "+t['NOT_IN_FUTURE']);
				ODobj.className="clsInvalid";
				OTobj.className="clsInvalid";
				return false;
			}
		}
		if (DateStringCompareToday(ODobj.value)==1) {
			alert(t['OnsetDate']+" "+t['NOT_IN_FUTURE']);
			ODobj.className="clsInvalid";
			return false;
		}
	}

	// checks that end date/time is not in the future
	if(EDobj && EDobj.value!="") {
		if(ETobj && ETobj.value!="") {
			if (DateTimeStringCompareToday(EDobj.value,ETobj.value)==1) {
				alert(t['EndDate']+" & "+t['EndTime']+" "+t['NOT_IN_FUTURE']);
				EDobj.className="clsInvalid";
				ETobj.className="clsInvalid";
				return false;
			}
		}
		if (DateStringCompareToday(EDobj.value)==1) {
			alert(t['EndDate']+" "+t['NOT_IN_FUTURE']);
			EDobj.className="clsInvalid";
			return false;
		}
	}

	// check if onset date/time is before end date/time
	var compare=0;
	if (ODobj && EDobj && ODobj.value!="" && EDobj.value!="") {
		if (OTobj && ETobj && OTobj.value!="" && ETobj.value!="") {
			compare=DateTimeStringCompare(ODobj.value,OTobj.value,EDobj.value,ETobj.value);
		}
		else {
			compare=DateStringCompare(ODobj.value,EDobj.value);
		}
		if (compare==1) {
			alert(t['ONSET_AFTER_END']);
			ODobj.className="clsInvalid";
			EDobj.className="clsInvalid";
			if (OTobj) OTobj.className="clsInvalid";
			if (ETobj) ETobj.className="clsInvalid";
			return false;
		}
	}

	return Update1_click();
}

document.body.onload=BodyLoadHandler;
