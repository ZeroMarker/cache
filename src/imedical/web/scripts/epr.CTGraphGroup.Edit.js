// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var lstItems=document.getElementById('selected1');
var graphAry=new Array();

var groupdetails="";

Init();

function Init() {
	var obj=document.getElementById('GGRPCode'); if (obj) obj.onchange=GGRPCodeChangeHandler;
	var obj=document.getElementById('GraphLU'); if (obj) obj.onfocus=GraphLUFocusHandler;
	// Selected Graphs: OnChange caters for UP and DOWN arrow key presses in a List Box. OnClick does not.
	var obj=document.getElementById('selected1'); if (obj) obj.onchange=SelectedGraphsChangeHandler;
	var obj=document.getElementById('DisableAttributes'); if (obj) obj.onclick=DisableAttributesClickHandler;
	var obj=document.getElementById('remove1'); if (obj) obj.onclick=RemoveClickHandler;
	var obj=document.getElementById('delete1'); if (obj) obj.onclick=DeleteClickHandler;
	var obj=document.getElementById('update1'); if (obj) obj.onclick=UpdateClickHandler;

	lstItems.multiple=false;
}

function BodyLoadHandler() {
	// Firstly, check for both the Code and Description fields. These two fields are mandatory.
	var flg;
	flg=CheckFields("N");

	// If ID is blank (new Graph Group), disable the "Delete" link.
	var obj=document.getElementById('ID');
	if (!(((obj)&&(obj.value!="")))) {
		var obj1=document.getElementById('delete1');
		if (obj1) {
			obj1.disabled=true;
			obj1.className="clsInvalid";
		}
	}

	DisableGraphProperties();

	// Load strAry (built in epr.CTGraphGroup.getGraphGroups) into REAL array.
	var objStrArry=document.getElementById('selectedgraphs');
	var str=objStrArry.value;
	if (str!="") {
		var lu = str.split("^");
		// Graph Group details are stored in the first piece. The selected graph definitions after that.
		groupdetails=lu[0];
		if (groupdetails!="") FillGroupDetails(groupdetails);
		// groupdetails is lu[0], above. The selected graph definitions start at lu[1].
		for(j=1; j<lu.length; j++) {
			var lu1=lu[j].split("*");
			// Add item into Listbox.
			var num=lstItems.length;
			lstItems[num]= new Option(lu1[2],lu1[1]);
			// Add item to the hidden array.
			var disable="";
			if (lu1[3]=="Y") {
				disable=true;
			} else {
				disable=false;
			}
			buildAry(num,lu1[0],lu1[1],lu1[2],disable);
		}
	}
}

// flg=1 if either field does not exist on the layout, and/or if an ID exists and either field does not have a value.
// checkid = "N" if called from BodyLoadHandler (check that the fields exist, and have values ONLY IF id is not blank).
// checkid = "Y" if called from UpdateClickHandler (check that the fields exist and have values ALWAYS).
function CheckFields(checkid) {
	var msg="";
	var flg=0;
	var flg1=0;
	var flg2=0;
	var id="";
	var obj=document.getElementById('ID');
	if (obj) id=obj.value;
	var objCode=document.getElementById('GGRPCode');
	if (objCode) {
		var obj1=document.getElementById('cGGRPCode');
		if (obj1) obj1.className="clsRequired";
		if ((checkid=="Y")&&(objCode.value=="")) flg1=1;
		if ((checkid=="N")&&(id!="")&&(objCode.value=="")) flg1=1;
	} else {
		flg1=1;
	}
	var objDesc=document.getElementById('GGRPDesc');
	if (objDesc) {
		var obj1=document.getElementById('cGGRPDesc');
		if (obj1) obj1.className="clsRequired";
		if ((checkid=="Y")&&(objDesc.value=="")) flg2=1;
		if ((checkid=="N")&&(id!="")&&(objDesc.value=="")) flg2=1;
	} else {
		flg2=1;
	}

	if (flg1) {
		msg=t['CodeRequired'];
		if (objCode) objCode.className="clsInvalid";
	} else {
		if (objCode) objCode.className="";
	}
	if (flg2) {
		if (msg!="") msg=msg+"\n"+t['DescRequired'];
		if (msg=="") msg=t['DescRequired'];
		if (objDesc) objDesc.className="clsInvalid";
	} else {
		if (objDesc) objDesc.className="";
	}

	if (msg!="") {
		flg=1;
		alert(msg);
	}

	return flg;
}

// Function to populate the Group Details, if applicable.
function FillGroupDetails(groupdetails) {
	var str = groupdetails.split("*");
	var obj=document.getElementById('GGRPCode');
	if (obj) obj.value=str[0];
	var obj=document.getElementById('GGRPDesc');
	if (obj) obj.value=str[1];
}

// Make the Code UPPER CASE.
function GGRPCodeChangeHandler() {
	var obj=document.getElementById('GGRPCode');
	if (obj) {
		obj.value=obj.value.toUpperCase();
	}
}

// When the LookUp gets Focus, clear the other details.
function GraphLUFocusHandler() {
	DisableGraphProperties();
}

function SelectedGraphsChangeHandler() {
	// When Selected Graph item is selected, display all properties for that item.
	if (lstItems.selectedIndex!=-1) {
		var j = lstItems.selectedIndex;
		var obj=document.getElementById('DisableAttributes');
		if (obj) obj.checked=graphAry[j].disable;
		EnableGraphProperties();
	}
}

function GraphLUHandler(str) {
	var lu = str.split("^");
	if (lu[1]!="") {
		//Check selected Graph Definition is not already in Listbox.
		for(i=0; i<graphAry.length; i++) {
			if (graphAry[i].graphcode==lu[1]) {
				alert("'" + lu[0] + "' " + t['AlreadyExists']);
				// Clear LookUp.
				var obj=document.getElementById('GraphLU');
				if (obj) obj.value="";
				// Mark the existing list item as the selected one.
				lstItems.selectedIndex=i;
				return false;
			}
		}
		// Add selected LookUp item into Listbox.
		var num=lstItems.length;
		lstItems[num]= new Option(lu[0],lu[1]);
		// Add selected LookUp item into Array.
		buildAry(num,lu[2],lu[1],lu[0],"");
		// Clear LookUp.
		var obj=document.getElementById('GraphLU');
		if (obj) obj.value="";
		// make the new entry the selected one.
		lstItems.selectedIndex=num;
		EnableGraphProperties();
	}
}

function DisableAttributesClickHandler() {
	updateGraphProp();
}

function updateGraphProp() {
	// Every time a Graph property is changed, update the array with latest data.
	var j = lstItems.selectedIndex;
	var disable="";
	var obj=document.getElementById('DisableAttributes');
	if (obj) disable=obj.checked;
	buildAry(j,graphAry[j].graphid,graphAry[j].graphcode,graphAry[j].graphdesc,disable);
}

function buildAry(pos,graphid,graphcode,graphdesc,disable) {
	tmpAry = new graphRecord(graphid,graphcode,graphdesc,disable);
	graphAry[pos] = tmpAry;
}

// The layout of a record.
function graphRecord(graphid,graphcode,graphdesc,disable) {
	this.graphid=graphid;
	this.graphcode=graphcode;
	this.graphdesc=graphdesc;
	this.disable=disable;
}

function RemoveClickHandler() {
	var j=lstItems.selectedIndex;
	if (j!=-1) {
		// Remove selected item from Array.
		graphAry.splice(j,1);
		// Remove selected item from Listbox.
		lstItems.remove(j);
	}
	return false;
}

function DeleteClickHandler() {
	var obj=document.getElementById('delete1');
	if ((obj)&&(obj.disabled==true)) return false;
	return delete1_click();
}

function UpdateClickHandler () {
	// Firstly, check for both the Code and Description fields. These two fields are mandatory.
	var flg;
	flg=CheckFields("Y");
	if (flg) return false;

	var strBuffer="";
	var disable="";
	var obj=document.getElementById('GGRPCode');
	if (obj) strBuffer=obj.value;
	var obj1=document.getElementById('GGRPDesc');
	if (obj1) strBuffer=strBuffer + "*" + obj1.value;

	for(j=0; j<graphAry.length; j++) {
		if (graphAry[j].disable==true) {
			disable="Y";
		} else {
			disable="N";
		}
		if (j==0) strBuffer=strBuffer + "^" + graphAry[j].graphid + "*" + disable;
		if (j!=0) strBuffer=strBuffer + "#" + graphAry[j].graphid + "*" + disable;
	}
	var obj = document.getElementById('selectedgraphs');
	if (obj) obj.value=strBuffer;
	return update1_click();
}


function DisableField(fldName,vGray) {
	var fld = document.getElementById(fldName);
	if ((fld)&&(fld.tagName=="INPUT")&&(fld.type!="hidden")) {
		fld.disabled = true;
		if (fld.type=="checkbox") fld.checked=false;
		fld.value = "";
		if (vGray) fld.className = "disabledField";
	}
}

function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	if ((fld)&&(fld.tagName=="INPUT")&&(fld.type!="hidden")) {
		fld.disabled = false;
		fld.className = "";
	}
}

function DisableGraphProperties() {
	var obj = document.getElementById("DisableAttributes");
	if (obj) {
		obj.checked=false;
		obj.disabled=true;
	}
	lstItems.selectedIndex=-1;
}

function EnableGraphProperties() {
	EnableField('DisableAttributes');
}


document.body.onload=BodyLoadHandler;
