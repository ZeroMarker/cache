// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Log 28555 - AI - 18-02-2003 : Created this js file to set the row font colour.

/*Procedure for allowing multiple profiles on the same page is to dynamically change the id of a
  profiles form, table menu and table list to be unique.  The unique id is obtained from
  adding the document.forms.length property on to the end of their existing names.*/

var df=document.forms;
var ltbl=document.getElementById("t"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
if (ltbl) {ltbl.id=ltbl.id+df.length,ltbl.Name=ltbl.id;}
var mtbl=document.getElementById("m"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
if (mtbl) {mtbl.id=mtbl.id+df.length,mtbl.Name=mtbl.id;}
df[df.length-1].id=df[df.length-1].id+df.length;df[df.length-1].name=df[df.length-1].name+df.length;

var frm=document.getElementById("f"+ltbl.id.substring(1,ltbl.id.length));


function DoColour() {
	for (var curr_row=1; curr_row<ltbl.rows.length; curr_row++) {
		var RowHexColour=frm.elements["RowHexColourz" + curr_row].value;
		// Log 40615 - AI - 10-11-2003 : Use a hidden field as normal fields are not always on the layout (Users choice).
		var InActiveFlag=frm.elements["InActiveHiddenz" + curr_row];

		for (var CurrentCell=0; CurrentCell<ltbl.rows[curr_row].cells.length; CurrentCell++) {
			if (RowHexColour.value=="") {
				ltbl.rows[curr_row].cells[CurrentCell].style.color="Black";
			}
			else {
// initially, it was just the font colour that was set. Now, it's the row background colour.
//				ltbl.rows[curr_row].cells[CurrentCell].style.color=RowHexColour;
				ltbl.rows[curr_row].cells[CurrentCell].style.color="Black";
				ltbl.rows[curr_row].cells[CurrentCell].bgColor=RowHexColour;
			}
			// Log 40615 - AI - 10-11-2003 : No longer a checkbox - value is N or Y.
			if ((InActiveFlag)&&(InActiveFlag.value=="Y")) {
				ltbl.rows[curr_row].cells[CurrentCell].className="EMRAllergyInactive";
			}
		}
	}
}
DoColour();

if (parent.refreshTabsTitleAndStyle){
	/*var options=parent.$('#tabsReg').tabs("getSelected").panel('options');
	var title=options.title.split("(")[0];
	var code=options.id;
	var PatientID=document.getElementById("PatientID").value;
	var RetJson=tkMakeServerCall('websys.DHCChartStyle','GetAllergyStyle',PatientID);
	if (RetJson!=""){
		var RetJson=eval('(' + RetJson + ')');
		var count=RetJson.count;
		var className=RetJson.className;
	}else{
		var count=0;
		var className="";
	}
	var newJsonArr = new Array();
	var newJson={};
	var childArr=new Array();
	childArr.push({"code":code,"text":title,"count":count,"className":className});
	newJson.children=childArr;
	newJsonArr.push(newJson);
	parent.refreshTabsTitleAndStyle(newJsonArr);
	*/
	parent.reloadMenu();
}else{
	parent.refreshBar();
}


// Log 55973 - PC - 30-11-2005 : New functions to Select All rows for use by the 'Reports' menu.
function ALGDSReportFlagLinkDisable(evt) {
	return false;

/*
	// Make 'el' the LINK, not the ICON (part of the link) that was clicked on.
	var el = window.event.srcElement.parentElement;
	if (el.disabled) {
		return false;
	}
	return true;
*/
}

function DisableLink(fld) {
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.onclick=ALGDSReportFlagLinkDisable
		fld.className = "disabledLink";
	}
}

//
//This function is no longer in use
//Log 65388
//
function DisableReportFlagLinks() {
	var ary=ltbl.getElementsByTagName("A")
	for (var curr_fld=0; curr_fld<ary.length; curr_fld++) {
		var obj=ary[curr_fld];
		if (obj) {
			if (obj.id.substring(0,16) == "ALGDSReportFlagz") {
				DisableLink(obj);
			}
		}
	}

	return false;
}

//DisableReportFlagLinks();


var objSelectAll = frm.elements["SelectAll"];
if (objSelectAll) objSelectAll.onclick=SelectAllClickHandler;


function SelectAllClickHandler(evt) {
	var ifrm,itbl;

	var el=window.event.srcElement
	// Get the form that contains the element that initiated the event.
	if (el) ifrm=getFormName(el);
	// Get the table of the same name as the form.
	if (ifrm) itbl=document.getElementById("t"+ifrm.id.substring(1,ifrm.id.length));
	// Set each "SelectItem" checkboxes to the same value as the "SelectAll" checkbox.
	if (itbl) {
		for (var curr_row=1; curr_row<itbl.rows.length; curr_row++) {
			var objSelectItem=ifrm.elements["SelectItemz" + curr_row];
			if (!objSelectItem) objSelectItem=ifrm.elements["Selectz" + curr_row];
			if (objSelectItem) objSelectItem.checked=el.checked;
		}
	}

	return true;
}
// Function called from the Component Menus.
function PAAllergyListEMR_PassSelected(lnk,newwin) {
	var f,aryfound;
	var tbl=getTableName(window.event.srcElement);

	if (tbl) f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));

	if (f) aryfound=checkedCheckBoxes(f,tbl,"SelectItemz");

	if (aryfound.length==0) {
		alert(t['NONE_SELECTED']);
		return;
	} else {
		var AryItems=new Array();
		var RowIDs="";
		for (var i=0;i<aryfound.length;i++) {
			var count=aryfound[i];
			var RowID=f.elements["IDz"+count].value;
			if (RowIDs=="") {
				RowIDs=RowID;
			} else {
				RowIDs=RowIDs+"^"+RowID;
			}
		}

		lnk+= "&RowIDs=" + RowIDs;
	}

	//alert(lnk);
	window.location = lnk;
}
document.onkeydown=function(event){
  if(event.ctrlKey && event.keyCode == 78) { 
      event.keyCode=0;   
      event.returnValue=false; 
	  window.setTimeout(function(){
			var PatientID=document.getElementById("PatientID").value;
			var EpisodeID=document.getElementById("EpisodeID").value;
			var url="websys.default.csp?WEBSYS.TCOMPONENT=DHC.PAAllergy.EditEMR&PARREF="+PatientID+"&PatientID="+PatientID+"&PatientBanner=0&EpisodeID="+EpisodeID;     
			var params="top=100,left=200,width=650,height=400" ;  
			if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
		    window.open(url,"",params); //打开新窗口   
	  }, 300);
     
   return false;
  }
};
// end Log 55973
