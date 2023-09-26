// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Log 29736 - AI - 18-12-2003 : File created for new Profile.

var f=document.fDHCEPR_ProfileList;
var frm=document.forms['fDHCEPR_ProfileList'];

// 'obsgrpid' is the ID of the Observation Group associated to the current/selected Observation Profile.
var catid="";
var defaulttempname="";

Init();

// To handle the fact that MAXIMUM ONE of "EpisodesAll" and "CurrentPregnancy" can be checked.
function Init() {
	
}


function UpdateClickHandler(e) {
	
		
	f.PPParameters.value=f.CategoryName.value + "," + f.CategoryID.value + "," + f.CategoryType.value;		

	return update1_click();
	
}

function completeForm(str,graph) {
	AddParams(str.join(','));
}

function AddParams(str) {
	
	var arr=str.split(',');
	
	var objCategoryName=frm.elements['CategoryName'];
	if (objCategoryName) {
			
		objCategoryName.value=arr[0];
		
	}

	var objCategoryID=frm.elements['CategoryID'];
	if (objCategoryID) {
		objCategoryID.value=arr[1];			
		
	}
	
	var objCategoryType=frm.elements['CategoryType'];
	if (objCategoryType) {
		objCategoryType.value=arr[2];	
		
		
	}
	
}

function LookUpDHCEPRListProfile(val) {	

	var ary=val.split("^");	
	frm.elements['ID'].value=ary[1];
	//fire broker to fetch params from selected profile id
	//frm.elements['xfetchparams'].change();
	//NB: may not work with N6
	var evt = document.createEventObject();
	frm.elements['xfetchparams'].fireEvent("onchange",evt);
	
}



//wrapper to call broker on hidden field to fetch params
function xfetchparams_changehandler(encmeth) {
	
	if (cspRunServerMethod(encmeth,'AddParams',frm.elements['ID'].value)) {
	
	}
}

function SelectCategory(){
	var result;
	result = window.showModalDialog("dhcepr.selectcategory.csp",null, "dialogHeight:550px;dialogWidth:425px" );
	if (result != null) {
		if (result != "") {
			var categoryname = result.split(",")[0];
			var categoryid = result.split(",")[1];
			var categorytype = result.split(",")[2];
			var objCategoryName = frm.elements['CategoryName'];
			if (objCategoryName) objCategoryName.value = categoryname;
			var objCategoryID = frm.elements['CategoryID'];
			if (objCategoryID) objCategoryID.value = categoryid;				
			var objCategoryType = frm.elements['CategoryType'];
			if (objCategoryType) objCategoryType.value = categorytype;
			
		}
	}	
}



