// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

//Useful functions that perform on Edit Components

// Disable the onclick for a disable link - lnk.onclick=LinkDisable;
function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) { 
		return false;
	}
	return true;
}


//JW: used to set a caption as mandatory, that is by default non-mandatory in the layout editor
function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "clsRequired";
	}
}
function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "";
	}
}

//JW: enable and disable fields, that are by default not set as enabled / disabled in layout editor

function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
	}
}

function DisableField(fldName) {
    
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
        
		if (fld.type!="checkbox") fld.value = "";
		if (fld.type=="checkbox") fld.checked=false;
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl.className = "";
	}
}

//md version where field will be gray out but visable

function DisableFieldVisiable(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		//if (fld.type!="checkbox") fld.value = "";
		if (fld.type=="checkbox") fld.checked=false;
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl.className = "";
	}
}

/*
// ab - will disable all fields, lookups and links on a page
function DisableAllFields(colour,exclude,clear) {
	// disable input fields
	var fld=document.getElementsByTagName('INPUT');
	for (var j=0; j<fld.length; j++) {
		if ((exclude)&&(exclude.indexOf(","+fld[j].id+",")!=-1)) {
				// don't disable field
		} else {
			if ((fld[j].type!="HIDDEN")&&(fld[j].type!="hidden")) {
				fld[j].disabled=true;
				if (colour) fld[j].className="disabledField";
      			// also clear field
				if (clear) {
					if (fld[j].type!="checkbox") fld[j].value = "";
					if (fld[j].type=="checkbox") fld[j].checked=false;
				}
			}
		}
	}
	
	// ab 13.09.06 - also disable TEXTAREA's
	var fld=document.getElementsByTagName("TEXTAREA");
	for (var j=0; j<fld.length; j++) {
		if ((exclude)&&(exclude.indexOf(","+fld[j].id+",")!=-1)) {
				// don't disable field
		} else {
			fld[j].disabled=true;
			if (colour) fld[j].className="disabledField";
      			// also clear field
			if (clear) {
				fld[j].value = "";
			}
		}
	}
	
	// disable lookups
	var arrLookUps=document.getElementsByTagName("IMG");
	for (var i=0; i<arrLookUps.length; i++) {
		if (arrLookUps[i].id) {
			lookupid=arrLookUps[i].id.substr(arrLookUps[i].id.indexOf("i")+1,arrLookUps[i].id.length)
			if ((exclude)&&(exclude.indexOf(","+lookupid+",")!=-1)) {
				// don't disable lookup of excluded field
			} else {
     				if (arrLookUps[i].id.charAt(0)=="l") arrLookUps[i].disabled=true;
			}
		}
	}
	
	// disable links
	var fld=document.getElementsByTagName("A");
	for (var j=0; j<fld.length; j++) {
		if ((exclude)&&(exclude.indexOf(","+fld[j].id+",")!=-1)) {
			// don't disable field
		}
		else {
			fld[j].disabled=true;
		fld[j].onclick=LinkDisable;
		}
	}
		
	var fld=document.getElementsByTagName("IMG");
	for (var k=0; k<fld.length; k++) {
		var fld2=websys_getParentElement(fld[k]);
		if ((fld2)&&(fld2.tagName=="A")) {
			if (((exclude)&&(exclude.indexOf(","+fld2.id+",")!=-1))||(fld2.id=="")) {
				// don't disable field
			} else {
				fld[k].disabled=true;
				fld2.disabled=true;
				fld2.onclick=LinkDisable;
			}
		}
	}
}
*/
function EnableAllFields() {
	var fld=document.getElementsByTagName('INPUT');
	for (var j=0; j<fld.length; j++) {
		if ((fld[j].type!="HIDDEN")&&(fld[j].type!="hidden")) {
			fld[j].disabled=false;
			fld[j].className="";
		}
	}
}

function DisableAllFields(colour,exclude,clear,hide) {
	// disable input fields
	var fld=document.getElementsByTagName('INPUT');
	for (var j=0; j<fld.length; j++) {
		if ((exclude)&&(exclude.indexOf(","+fld[j].id+",")!=-1)) {
				// don't disable field
		} else {
			if ((fld[j].type!="HIDDEN")&&(fld[j].type!="hidden")) {
				if (fld[j].disabled==true) {
				AddToExcluded(fld[j].id);
				}else {
				fld[j].disabled=true;
				if (colour) fld[j].className="disabledField";
				}
                // also clear field
                if (clear) {
                    if (fld[j].type!="checkbox") fld[j].value = "";
		            if (fld[j].type=="checkbox") fld[j].checked=false;
                }
			}
		}
	}
	// ab 13.09.06 - also disable TEXTAREA's
	var fld=document.getElementsByTagName("TEXTAREA");
	for (var j=0; j<fld.length; j++) {
		if ((exclude)&&(exclude.indexOf(","+fld[j].id+",")!=-1)) {
				// don't disable field
		} else {
			if (fld[j].disabled==true) {
			AddToExcluded(fld[j].id);
			}else {
			fld[j].disabled=true;
			if (colour) fld[j].className="disabledField";
			}
      			// also clear field
			if (clear) {
				fld[j].value = "";
			}
		}
	}
	// disable lookups
	var arrLookUps=document.getElementsByTagName("IMG");
	for (var i=0; i<arrLookUps.length; i++) {
		if (arrLookUps[i].id) {
            lookupid=arrLookUps[i].id.substr(arrLookUps[i].id.indexOf("i")+1,arrLookUps[i].id.length)
            if ((exclude)&&(exclude.indexOf(","+lookupid+",")!=-1)) {
				// don't disable lookup of excluded field
		    } else {
		    if (arrLookUps[i].id.charAt(0)=="l")
		    {
		    if (arrLookUps[i].disabled==true) { 
		    AddToExcluded(arrLookUps[i].id);
		     }
		    else { arrLookUps[i].disabled=true; }
		    }
            }
        }
	}
	
	
	// disable links
	var fld=document.getElementsByTagName("A");
	for (var j=0; j<fld.length; j++) {
		if ((exclude)&&(exclude.indexOf(","+fld[j].id+",")!=-1)) {
			// don't disable field
		}
		else {
		        if (hide) { 
			//fld[j].style.visibility = "hidden";
			if ((fld[j].id!="")&&(fld[j].disabled!=true)) {
			AddToExcludedLink(fld[j].id,fld[j].onclick); 
			fld[j].disabled=true;
			fld[j].onclick=LinkDisable;
			}
			}
			if (!hide) {
			fld[j].disabled=true;
			fld[j].onclick=LinkDisable;
			}
		        
			
		}
	}
	
	var fld=document.getElementsByTagName("IMG");
	for (var k=0; k<fld.length; k++) {
		var fld2=websys_getParentElement(fld[k]);
		if ((fld2)&&(fld2.tagName=="A")) {
			if (((exclude)&&(exclude.indexOf(","+fld2.id+",")!=-1))||(fld2.id=="")) {
				// don't disable field
			} else {
				fld[k].disabled=true;
				fld2.disabled=true;
				fld2.onclick=LinkDisable;
			}
		}
	}
}



function AddToExcluded(field) {


	if  (exclusedlist!="") exclusedlist=exclusedlist+field+","
	if  (exclusedlist=="") exclusedlist=exclusedlist+","+field+","


}

function AddToExcludedLink(field,linker) {

	
	var lstr=linker.toString();
	var arrlst=lstr.split("()");
	var sarr=arrlst[0].split("(evt)");
	var tarr=sarr[0].split("function ");
	Linkexclusedlist[field]=linker;
	
}

function NEnableAllFields(colour,exclude,clear,hide) {
	// input fields
	var fld=document.getElementsByTagName('INPUT');
	for (var j=0; j<fld.length; j++) {
		if (((exclusedlist!=""))&&(exclusedlist.indexOf(","+fld[j].id+",")!=-1)) {
			} else{
			if ((fld[j].type!="HIDDEN")&&(fld[j].type!="hidden")) {
				fld[j].disabled=false;
				if (colour) fld[j].className="";
                // also clear field
                if (clear) {
                    if (fld[j].type!="checkbox") fld[j].value = "";
		            if (fld[j].type=="checkbox") fld[j].checked=false;
                }
			}
		}
	}
	
	
	
	var fld=document.getElementsByTagName("TEXTAREA");
	for (var j=0; j<fld.length; j++) {
		if ((exclusedlist)&&(exclusedlist.indexOf(","+fld[j].id+",")!=-1)) {
			} else {
			fld[j].disabled=true;
			if (colour) fld[j].className="";
      			// also clear field
			if (clear) {
				fld[j].value = "";
			}
		}
	}

	//  lookups
	var arrLookUps=document.getElementsByTagName("IMG");
	for (var i=0; i<arrLookUps.length; i++) {
		if (arrLookUps[i].id) {
            lookupid=arrLookUps[i].id.substr(arrLookUps[i].id.indexOf("i")+1,arrLookUps[i].id.length)
            if ((exclusedlist)&&(exclusedlist.indexOf(","+lookupid+",")!=-1)) {
	 } else {
                if (arrLookUps[i].id.charAt(0)=="l") arrLookUps[i].disabled=false;
            }
        }
	}
	
	//  links
	var fld=document.getElementsByTagName("A");
	for (var j=0; j<fld.length; j++) {
		if ((exclude)&&(exclude.indexOf(","+fld[j].id+",")!=-1)) {
			// don't disable field
		}
		else {
		       if (!hide) {
			fld[j].disabled=false;
			fld[j].onclick=LinkDisable;
			}
		        if (hide) {
			//fld[j].style.visibility = ""; 
			CheckForLink(fld[j]);
			
			}
		}
	}
	
	var fld=document.getElementsByTagName("IMG");
	for (var k=0; k<fld.length; k++) {
		var fld2=websys_getParentElement(fld[k]);
		if ((fld2)&&(fld2.tagName=="A")) {
			if (((exclude)&&(exclude.indexOf(","+fld2.id+",")!=-1))||(fld2.id=="")) {
			} else {
				fld[k].disabled=false;
				fld2.disabled=false;
				
			}
		}
	}
}


function CheckForLink(field) {

	if (Linkexclusedlist[field.id])
	{
	field.disabled=false;
	field.onclick=Linkexclusedlist[field.id] 
	}
 
}

var exclusedlist="";
var Linkexclusedlist = new Array(20);





// ab - will disable all rows in a list
function DisableListRows(tbl) {
	if (tbl) {
		for (var j=0;j<tbl.rows.length;j++) {
			tbl.rows[j].className="clsRowDisabled";
			tbl.rows[j].selectenabled=0;
			
			//disable links
			var fld=tbl.rows[j].getElementsByTagName("A");
			for (var k=0; k<fld.length; k++) {
				fld[k].disabled=true;
				fld[k].onclick=LinkDisable;
			}
			var fld=tbl.rows[j].getElementsByTagName("IMG");
			for (var k=0; k<fld.length; k++) {
				var fld2=websys_getParentElement(fld[k]);
				if ((fld2)&&(fld2.tagName=="A")){
					fld[k].disabled=true;
					fld2.disabled=true;
					fld2.onclick=LinkDisable;
				}
			}
		}	
	}
}


//JW used to disable the lookup icon, where fldName is "ld...ifieldname"
function DisableLookup(fldName)
{
	var obj=document.getElementById(fldName);
	if (obj) obj.disabled=true;
}

function EnableLookup(fldName)
{
	var obj=document.getElementById(fldName);
	if (obj) obj.disabled=false;
}


//JW from paadm.editemergency - change to use disable field.
function DisableCheckbox(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.checked = false;
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}
function disableLinks() {
var fld=document.getElementsByTagName('A');
	for (var j=0; j<fld.length; j++) {
		fld[j].disabled=true;
		fld[j].onclick=LinkDisable;
		}
}

//JW check valid email
function isEmail(e) {
	var eSrc = websys_getSrcElement(e);
	var ComponentItemName=eSrc.id
	//alert(eSrc.id)
	var reEmail = /^.+\@.+\..+$/

  	if (eSrc.value!="") {
  		if (!(reEmail.test(eSrc.value))) {
			eSrc.className="clsInvalid";
			alert("\'" + t[ComponentItemName] + "\' " + t['XINVALID'] + "\n");
			eSrc.focus();
			return false;
	    	}
	}
	eSrc.className="";
	return true;
}
	
/*
function DisableLink(fldName) {
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
	}
}

function DisableField(fld) {
	var lbl = ('c'+fld);
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}
*/

/*function setBoldLinks(el,state) {
	obj=document.getElementById(el);
	if (obj) {
		if (state==1) obj.style.fontWeight="bold";
		else obj.style.fontWeight="normal";
	}
} 
*/
/*JW from paadm.editemergency - but ? used

function Disable(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.disabled==true)) {
		fld.value = "";
		fld.disabled = false;
		//fld.className = "";
		//if (lbl) lbl = lbl.className = "";
	}
} */
//JW duplicate
/*
function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
	//	if (lbl) lbl = lbl.className = "clsRequired";
	}
} */


