// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//var frm = document.forms["fPAPregEnquiry_Find"];

function Init() {
	var obj;

	PopulateListBoxFromString("ResourceEntered",document.getElementById("ResourceDescString").value)
	var obj=document.getElementById("Lock");
	var obj1=document.getElementById("RetainValues");
	if ((obj)&&(obj1)) {
		if (obj1.value=="on") obj.checked=true;
	}

	var obj=document.getElementById('find');
	if (obj) {
		obj.url="";
		obj.onclick=findClick;
		if (tsc['find']) websys_sckeys[tsc['find']]=findClick;
	}
	findClick();
	SetStatusSel();

	obj=document.getElementById('DeleteResource');
	if (obj) obj.onclick=ResDeleteClickHandler;

	//try {parent.frames['RBResourceOTTree'].treload();} catch (e) {}
}

function SetStatusSel() {
	var objH = document.getElementById("OPStatusH");
	var obj = document.getElementById("OPStatus");
	if(obj && objH && objH!=""){
		var arSt = objH.value.split("^");
		for(var x=0; x<arSt.length; x++){
			for(var i=0; i<obj.length; i++){
				if (obj.options[i].value==arSt[x]){
					obj.options[i].selected=true;
					break;
				}
			}
		}
	}
}

function findClick() {
	var link="";
	var Location="";
	var ResourceDescString="";
	var res="";
	var date=""
	var OPStatus=""
	var OPStatFullList=""
	var treeType=document.getElementById("TreeType").value;

	var obj=document.getElementById("ResourceEntered");
	var obj1=document.getElementById("ResourceDescString");
	if ((obj)&&(obj1)) {
		for(var i=0; i<obj.length; i++){res = res + obj.options[i].text + "^";}
		if (obj1) obj1.value=res
	}
	var obj=document.getElementById("Lock");
	var obj1=document.getElementById("RetainValues");
	if ((obj)&&(obj1)) {
		if (obj.checked==true) obj1.value="on";
		if (obj.checked==false) obj1.value="off";
		RetainFieldValue=obj1.value;
		link="&RetainValues="+RetainFieldValue;
	}

	var obj=document.getElementById("Location");
	if (obj) {Location=obj.value;link=link+"&locDesc="+Location;}

	var obj=document.getElementById("Date");
	if (obj) {
		if (treeType=="SCHED") {
			date=obj.value;link=link+"&sDate="+date+"&adate="+date;
		} else {
			date=obj.value;link=link+"&adate="+date;
		}
	}

	var obj=document.getElementById("OPStatus");
	if (obj) {
		for (var i=(obj.length-1); i>=0; i--) {
			OPStatFullList=OPStatFullList+"^"+obj.options[i].value;
			if (obj.options[i].selected) {
				if (OPStatus=="") {
					OPStatus=obj.options[i].value;
				} else {
					OPStatus=OPStatus+"^"+obj.options[i].value;
				}
			}
		}
		if (OPStatus=="") {OPStatus=OPStatFullList;}
		link=link+"&OPStatus="+OPStatus;
	}

	if (treeType=="SCHED") {
		link="&resId=&locId="+link
	}

	var obj=document.getElementById("ResourceDescString");
	if (obj) {ResourceDescString=obj.value;link=link+"&resList="+ResourceDescString;}

	if (treeType=="SCHED") {
		var url="websys.default.csp?WEBSYS.TCOMPONENT=RBApptSchedule.Tree"+link+"&CONTEXT="+session["CONTEXT"];
		var win2=parent.frames['RBApptScheduleTree'];
		if (win2) {win2.location=url;}
	} else {
		var url="websys.default.csp?WEBSYS.TCOMPONENT=RBResourceOT.Tree"+link+"&CONTEXT="+session["CONTEXT"];
		var win2=parent.frames['RBResourceOTTree'];
		if (win2) {win2.location=url;}
	}

	return;
}

function mPiece(s1,sep,n) {
    //Split the array with the passed delimeter
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}


////////////////////////////////////// Listbox Processing Start ////////////////////////////////////////

//This method forms a String containing all the values from the listbox.
//A seperate String is formed for each listbox.
function FromListboxStrings(){
	UpdateListboxString("ResourceEntered","ResourceDescString");
}

function UpdateListboxString(lbName, strName) {
	var strItems = "";
	var lst = document.getElementById(lbName);
	if (lst) {
		var j;
		for (j=0; j<lst.options.length; j++) {
			strItems = strItems + "^" + lst.options[j].value + "^";
			if ((j+1) < lst.options.length){
				strItems = strItems + ", ";
			}
		}
		var el = document.getElementById(strName);
		if (el) el.value = strItems;
		//if (el.value != "")
		//	alert("string " + el.value);
	}
}

function PopulateListBoxFromString(lbName,strvalue) {
	var lst = document.getElementById(lbName);
	if ((lst)&&(strvalue!="")) {
		for (var j=0; mPiece(strvalue,"^",j)!=""; j++) {
			AddItemToList(lst," ",mPiece(strvalue,"^",j))
		}
	}
}

function ResDeleteClickHandler() {
	//Delete items from listboxes when a "Delete" button is clicked.
	var obj=document.getElementById("ResourceEntered");
	if (obj)
		RemoveFromList(obj);
	return false;
}

function ResourceLookupSelect(txt) {
	//Add an item to Resource list when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("ResourceEntered");

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == adata[1]) {
				alert(t['ResourceDesc'] + " " + t['Selected']);
				var obj=document.getElementById("ResourceDesc");
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert(t['ResourceDesc'] + " " + t['Selected']);
				var obj=document.getElementById("ResourceDesc");
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("ResourceDesc");
	if (obj) obj.value="";
}



function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	//alert("in list " + list.name + " code " + code + " desc " + desc);
	list.options[list.options.length] = new Option(desc,code);
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}

}

////////////////////////////////////// Listbox Processing End ////////////////////////////////////////


document.body.onload=Init;
