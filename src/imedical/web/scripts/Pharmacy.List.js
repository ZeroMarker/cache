// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var tbl=document.getElementById("tPharmacy_List");
var f=document.getElementById("fPharmacy_List");

document.styleSheets[0].addImport("epr.chartbook.side.css",0);

function CheckRefresh() {
	var WinOpen = false;
	for (w in websys_windows) {
		try {
			if (!websys_windows[w].closed) {
				WinOpen = true;
				break;
			}
		} catch(e) {}
	}
	if (!WinOpen) {
		window.location.reload(); 
	}
}

function DoRowCol() {
	var Altbl=document.getElementById("tPharmacy_List");
	var Alfrm=document.getElementById("fPharmacy_List");
	if (Altbl&&Alfrm) {
		for (var curr_row=1; curr_row<Altbl.rows.length; curr_row++) {
			var RowHexColour=Alfrm.elements["PrioColz" + curr_row].value;
			if (RowHexColour.value!="") {
				Altbl.rows[curr_row].style.backgroundColor=RowHexColour;
			}			
			var NONForm=document.getElementById('NONFormularyz' + curr_row);
			if (NONForm) NONForm.onclick=BlankClick;
			//alert("LoopListid "+ curr_row);
		}
	}
}
function BlankClick(){
	return false;
}

function DocumentLoadHandler() {
	DoRowCol();
	// get default timeout for page refresh
	var objRefresh=document.getElementById('RefreshPeriod');
	if (objRefresh) {
		var Period = parseInt(objRefresh.value*60*1000);
		if (Period != 0) {
			window.setTimeout('CheckRefresh()',Period)
		}
	}

	var obj=document.getElementById('Find');
	if (obj) {
		obj.onclick = FindClick;
	}

	//// 59228
	var Pobj=document.getElementById('PrescNo');
	if (Pobj) {
		Pobj.onchange = PrescNoBlur;
	}
	

/*
// All this commented out log 59514
	// assume today's date if nothing entered...
	var DateTo = "";
	var DateFrom  = "";
	var Ward = "";
	var ADMINDateTo = "";
	var ADMINDateFrom  = "";
	var ADMINTimeTo = "";
	var ADMINTimeFrom  = "";
	var RegistrationNo  = "";


	var objDateFrom=document.getElementById('DateFrom');
	if (objDateFrom) DateFrom=objDateFrom.value;
	var objDateTo=document.getElementById('DateTo');
	if (objDateTo) DateTo=objDateTo.value;

	var obj=document.getElementById('ADMINDateFrom');
	if (obj) ADMINDateFrom=obj.value;
	var obj=document.getElementById('ADMINDateTo');
	if (obj) ADMINDateTo=obj.value;

	var obj=document.getElementById('ADMINTimeFrom');
	if (obj) ADMINTimeFrom=obj.value;
	var obj=document.getElementById('ADMINTimeTo');
	if (obj) ADMINTimeTo=obj.value;

	var obj=document.getElementById('RegistrationNo');
	if (obj) RegistrationNo=obj.value;


	if ((ADMINDateTo+ADMINDateFrom+ADMINTimeTo+ADMINTimeFrom+RegistrationNo)=="") {
		var today=new Date();
		var DateToday = ReWriteDate(today.getDate(),today.getMonth()+1,today.getYear());
		if (DateFrom=="" && objDateFrom) objDateFrom.value = DateToday;
		if (DateTo=="" && objDateTo) objDateTo.value = DateToday;
	}
*/

////// Log 63690 Eliotc  21/05/07  Start
    var RegNo=document.getElementById('RegistrationNo');
	if (RegNo) {
		RegNo.onchange = PatientBasedWB;
	}

    var PreStartDateFrom=document.getElementById('StartFrom');
	var PreStartDateTo=document.getElementById('StartTo');

	if (PreStartDateFrom||PreStartDateTo) {
		PreStartDateFrom.onblur = DispenseByStartDate;
		PreStartDateTo.onblur = DispenseByStartDate;

	}

    var PreDateFrom=document.getElementById('DateFrom');
	var PreDateTo=document.getElementById('DateTo');

   if (PreDateFrom||PreDateTo) {
		PreDateFrom.onblur = DispenseByCreatedDate;
		PreDateTo.onblur = DispenseByCreatedDate;
		

	}

	var UnitDoseDateFrom=document.getElementById('ADMINDateFrom');
	var UnitDoseDateTo=document.getElementById('ADMINDateTo');
	var UnitDoseTimeFrom=document.getElementById('ADMINTimeFrom');
	var UnitDoseTimeTo=document.getElementById('ADMINTimeTo');
	

  
  if (UnitDoseDateFrom||UnitDoseDateTo||UnitDoseTimeFrom||UnitDoseTimeTo) {
		UnitDoseDateFrom.onblur = UnitDose;
		UnitDoseDateTo.onblur = UnitDose;
		UnitDoseTimeFrom.onblur = UnitDose;
		UnitDoseTimeTo.onblur = UnitDose;
		

	}

   /*  The code to disable RegistrationNo field and the patient search 

	var PrescNumber=document.getElementById('PrescNo').value;
	if (PrescNumber!="")
	{
        DisableEl('RegistrationNo'); 
		document.links("PatientSearch").disabled=true ;

		if (document.getElementById('PatientSearch'))
	{
		document.getElementById('PatientSearch').onclick="return false;";
	}

		//document.getElementById('PatientSearch').onfocus="if(this.blur)this.blur();" 
	}

*/

 ////// Log 63690 Eliotc  21/05/07  End   

}



////// Log 63690 Eliotc  21/05/07 Start



function PatientBasedWB () {

	if (document.getElementById('RegistrationNo').value!="") 
	{ 
		
		disable('RegistrationNo'); 
		
	}

	if (document.getElementById('RegistrationNo').value=="") 
	{ 
		
		enable('RegistrationNo'); 
		
	}

}


function DispenseByStartDate () {


	if (document.getElementById('StartFrom').value!=""||document.getElementById('StartTo').value!="") 
	{ 
		
		disable('StartFrom'); 
	
	}

	if (document.getElementById('StartFrom').value==""&&document.getElementById('StartTo').value=="") 
	{ 
		
		enable('StartFrom'); 
	
	}

}



function DispenseByCreatedDate () {


	if (document.getElementById('DateFrom').value!=""||document.getElementById('DateTo').value!="") 
	{ 
		
		disable('DateFrom'); 
	
	}

	if (document.getElementById('DateFrom').value==""&&document.getElementById('DateTo').value=="") 
	{ 
		
		enable('DateFrom'); 
	
	}

}


function UnitDose () {


	if (document.getElementById('ADMINDateFrom').value!=""||document.getElementById('ADMINDateTo').value!=""||document.getElementById('ADMINTimeFrom').value!=""||document.getElementById('ADMINTimeTo').value!="") 
	{ 
		disable('ADMINDateFrom'); 
	}

	if (document.getElementById('ADMINDateFrom').value==""&&document.getElementById('ADMINDateTo').value==""&&document.getElementById('ADMINTimeFrom').value==""&&document.getElementById('ADMINTimeTo').value=="") 
	{ 
		
		enable('ADMINDateFrom'); 
	
	}

}


function disable(field) {
   

   
   if (field=='RegistrationNo')
   {
         DisableEl("PrescNo");
   }
  if (field=='StartFrom')
   {
     
		 DisableEl("DateFrom");
		 DisableEl("DateTo");
		 DisableEl("ADMINDateFrom");
		 DisableEl("ADMINDateTo");
		 DisableEl("ADMINTimeFrom");
		 DisableEl("ADMINTimeTo");
		 DisableEl("PrescNo");

   }
     if (field=='DateFrom')
   {
      
	     DisableEl("StartFrom");
		 DisableEl("StartTo");
		 DisableEl("ADMINDateFrom");
		 DisableEl("ADMINDateTo");
		 DisableEl("ADMINTimeFrom");
		 DisableEl("ADMINTimeTo");
		 DisableEl("PrescNo");
		
	   

   }
        if (field=='ADMINDateFrom')
   {
      
	  
		 DisableEl("DateFrom");
		 DisableEl("DateTo");
		 DisableEl("StartFrom");
		 DisableEl("StartTo");
		 DisableEl("PrescNo");	   

   }


}



function enable(field) {

   
   if (field=='RegistrationNo')
   {
  	 
	 EnableEl("PrescNo");
   }

   if (field=='StartFrom')
   {

		 EnableEl("DateFrom");
		 EnableEl("DateTo");
		 EnableEl("ADMINDateFrom");
		 EnableEl("ADMINDateTo");
		 EnableEl("ADMINTimeFrom");
		 EnableEl("ADMINTimeTo");
		 EnableEl("PrescNo");
	   

   }
     if (field=='DateFrom')
   {
     
	   


		 EnableEl("StartFrom");
		 EnableEl("StartTo");
		 EnableEl("ADMINDateFrom");
		 EnableEl("ADMINDateTo");
		 EnableEl("ADMINTimeFrom");
		 EnableEl("ADMINTimeTo");
		 EnableEl("PrescNo");
		
	   

   }



    if (field=='ADMINDateFrom')
   {
      
		 EnableEl("DateFrom");
		 EnableEl("DateTo");
		 EnableEl("StartFrom");
		 EnableEl("StartTo");
		 EnableEl("PrescNo");
	   

   }
}
function DisableEl(el){
	var Obj=document.getElementById(el);
	var lObj=document.getElementById("ld1991i"+el);
	if (Obj) Obj.disabled=true;
	if (lObj) lObj.disabled=true;
	if (lObj) lObj.style.visibility="hidden";
	return;
}

function EnableEl(el){
	var Obj=document.getElementById(el);
	var lObj=document.getElementById("ld1991i"+el);
	if (Obj) Obj.disabled=false;
	if (lObj) lObj.disabled=false;
	if (lObj) lObj.style.visibility="visible";
	return;
}



////// Log 63690 Eliotc  21/05/07 End



/*
function PatientBasedWBdisable() {
fPharmacy_List.PrescNo.disabled = true;
}

function PatientBasedWBdisable() {

fPharmacy_List.RegistrationNo.disabled = true;
}
*/








function PrescNoBlur () {
	//// 59228
	if (document.getElementById('PrescNo').value!="") { FindClick(); }
	return false;
}



function FindClick () {

	if (!DateCheckOK()) {
		alert(t['ADMINDATEWARD']);
		return false;
	} else {
		return Find_click();
	}

}

function DateCheckOK () {

	var DateCheckOK = true;
	var DateTo = "";
	var DateFrom  = "";
	var Ward = "";
	var ADMINDateTo = "";
	var ADMINDateFrom  = "";
	var ADMINTimeTo = "";
	var ADMINTimeFrom  = "";

	var obj=document.getElementById('Ward');
	if (obj) Ward=obj.value;
	var obj=document.getElementById('DateFrom');
	if (obj) DateFrom=obj.value;
	var obj=document.getElementById('DateTo');
	if (obj) DateTo=obj.value;

	var obj=document.getElementById('ADMINDateFrom');
	if (obj) ADMINDateFrom=obj.value;
	var obj=document.getElementById('ADMINDateTo');
	if (obj) ADMINDateTo=obj.value;

	var obj=document.getElementById('ADMINTimeFrom');
	if (obj) ADMINTimeFrom=obj.value;
	var obj=document.getElementById('ADMINTimeTo');
	if (obj) ADMINTimeTo=obj.value;

	// if administration date/time entered - MUST enter a ward...
	if ((ADMINDateTo+ADMINDateFrom+ADMINTimeTo+ADMINTimeFrom) !="") {
		if (Ward=="") DateCheckOK = false;
	}
	return  DateCheckOK;
}

function DisableKeyDown() {
	return false;
}

function UnitLookUp(str) {
	var lu = str.split("^");
	var obj=document.getElementById('Unit');
	if (obj) obj.value = lu[1];
}

function allScripts(prno,Action) {
	var retval = "";
	var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
	for (i in aryfound) {
		var row=aryfound[i];
		if (!f.elements["IDz"+row]) continue;
		// Log 47636 YC - Check if prescription can perform the action
		if (f.elements["CanDoz"+row]) {
			var CanDo = f.elements["CanDoz"+row].value;
			if (CanDo.indexOf(","+Action+",")==-1) {
				alert(t["ACTION_INVALID"]);
				return -1;
			}
		}
		var PrescNumber = f.elements["IDz"+row].value;
		if (PrescNumber!="") {
			if (retval!="") { retval += "^";}
			retval += PrescNumber;
		}
	}
	if (retval == "") { retval = prno;}
	return retval;
}

function clickAction (Action, PrescNo, CONTEXT) {
	var AllScripts = PrescNo;
	// can't enquire on multiple presc numbers..
	//if (Action != 'Enquire') AllScripts = allScripts(PrescNo);
	// oh yes you can now!!!
	AllScripts = allScripts(PrescNo,Action);
	// return false since there was an action invalid for a prescription
	if (AllScripts==-1) return false;
	var PatBanner=1;
	var ADMINDateTo = "";
	var ADMINDateFrom  = "";
	var ADMINTimeTo = "";
	var ADMINTimeFrom  = "";
	var DISOnly  = "";
	var obj=document.getElementById('DISOnly');
	if (obj) {
		if (obj.checked) DISOnly="on";
	}
	var obj=document.getElementById('ADMINDateFrom');
	if (obj) ADMINDateFrom=obj.value;
	var obj=document.getElementById('ADMINDateTo');
	if (obj) ADMINDateTo=obj.value;

	var obj=document.getElementById('ADMINTimeFrom');
	if (obj) ADMINTimeFrom=obj.value;
	var obj=document.getElementById('ADMINTimeTo');
	if (obj) ADMINTimeTo=obj.value;
	var tp = 0;  //window.screen.height-window.screen.availHeight;
	var lft = 0;  //window.screen.Width-window.screen.availWidth;
	var wid = screen.availWidth-10;
	var hght = screen.availHeight-30;
	var feature='top='+tp+',left='+lft+',width='+wid+',height='+hght + ',scrollbars=yes,resizable=yes';

	var url = "pharmacy.presc.frames.csp?DISOnly="+DISOnly+"&PatCounter=&Action=" + Action + "&PatientBanner=" + PatBanner + "&CONTEXT=" + CONTEXT + "&AllScripts=" + AllScripts+"&ADMINDateTo="+ADMINDateTo+"&ADMINDateFrom="+ADMINDateFrom+"&ADMINTimeTo="+ADMINTimeTo+"&ADMINTimeFrom="+ADMINTimeFrom;
	websys_createWindow(url,'PrescEdit',feature);
}

function SelectTab (newtabcode) {

	var EPRIcon = "";
	var RegistrationNo = "";
	var Unit = "";
	var Ward = "";
	var CONTEXT="";
	var EpisodeEmerPat = "";
	var EpisodeInPat = "";
	var EpisodeOutPat = "";
	var DateTo = "";
	var DateFrom  = "";
	var ADMINDateTo = "";
	var ADMINDateFrom  = "";
	var ADMINTimeTo = "";
	var ADMINTimeFrom  = "";
	var DISOnly  = "";
	var ManufactureONLY = "";

	var obj=document.getElementById('EPRIcon');
	if (obj) EPRIcon=obj.value;
	var obj=document.getElementById('RegistrationNo');
	if (obj) RegistrationNo=obj.value;
	var obj=document.getElementById('Unit');
	if (obj) Unit=escape(obj.value);
	var obj=document.getElementById('Ward');
	if (obj) Ward=escape(obj.value);
	var obj=document.getElementById('DateFrom');
	if (obj) DateFrom=obj.value;
	var obj=document.getElementById('DateTo');
	if (obj) DateTo=obj.value;

	var obj=document.getElementById('ADMINDateFrom');
	if (obj) ADMINDateFrom=obj.value;
	var obj=document.getElementById('ADMINDateTo');
	if (obj) ADMINDateTo=obj.value;

	var obj=document.getElementById('ADMINTimeFrom');
	if (obj) ADMINTimeFrom=obj.value;
	var obj=document.getElementById('ADMINTimeTo');
	if (obj) ADMINTimeTo=obj.value;

	var obj=document.getElementById('EpisodeEmerPat');
	if (obj) {
		if (obj.checked) EpisodeEmerPat="on";
	}
	var obj=document.getElementById('EpisodeInPat');
	if (obj) {
		if (obj.checked) EpisodeInPat="on";
	}
	var obj=document.getElementById('EpisodeOutPat');
	if (obj) {
		if (obj.checked) EpisodeOutPat="on";
	}
	var obj=document.getElementById('DISOnly');
	if (obj) {
		if (obj.checked) DISOnly="on";
	}
	// Log 50113 YC - New Manufacture Only checkbox
	var obj=document.getElementById('ManufactureONLY');
	if (obj) {
		if (obj.checked) ManufactureONLY="on";
	}

	var obj=document.getElementById('CONTEXT');
	if (obj) {
		var arr = obj.value.split("_");
		CONTEXT=arr[0] + "_" + newtabcode;
	}

	//// 51250 /////
	if (document.getElementById('StartFrom')) {var StartFrom=document.getElementById('StartFrom').value;} else {var StartFrom="";}
	if (document.getElementById('StartTo')) {var StartTo=document.getElementById('StartTo').value;} else {var StartTo="";}
	if (document.getElementById('PrescNo')) {var PrescNo=document.getElementById('PrescNo').value;} else {var PrescNo="";}

	var url = "websys.default.csp?WEBSYS.TCOMPONENT=Pharmacy.List&DISOnly="+DISOnly+"&EPRIcon="+EPRIcon+"&Ward="+Ward+"&Unit="+Unit+"&CONTEXT="+CONTEXT+"&QueueStatus="+newtabcode+"&RegistrationNo="+RegistrationNo+"&EpisodeEmerPat="+EpisodeEmerPat+"&EpisodeInPat="+EpisodeInPat+"&EpisodeOutPat="+EpisodeOutPat+"&DateFrom="+DateFrom+"&DateTo="+DateTo+"&ADMINDateTo="+ADMINDateTo+"&ADMINDateFrom="+ADMINDateFrom+"&ADMINTimeTo="+ADMINTimeTo+"&ADMINTimeFrom="+ADMINTimeFrom+"&ManufactureONLY="+ManufactureONLY;
	var url = url + "&StartFrom="+StartFrom+"&StartTo="+StartTo+"&PrescNo="+PrescNo;

	if (!DateCheckOK()) {
		alert(t['ADMINDATEWARD']);
		return false;
	} else {
		window.location.href= url;
	}
}

function PrintSelectedRowsHandler(tblname,lnk,newwin) {
	var found=0;
	//alert("tablename=" + tblname + " && lnk=" + lnk + " && newwin=" + newwin);
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
	var PresNoList="";
	//HitCount var required to force Crystal Web Server to rerun query - see KnowledgeBase Article c2002771
	var HitCount=Math.round(Math.random() * 1000);
	var MasVolIDs="";
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		if (newwin=="TRAK_hidden") {
			var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="PresNo">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					// check for specific values - these values must be hidden in the component
					if (!f.elements["IDz"+row]) continue;
					if (f.elements["IDz"+row].value!="") {
						document.writeln('<INPUT NAME="PresNo" VALUE="' + f.elements["IDz"+row].value + '">');
					}
				}
				//Log 63924 - 08.06.2007 - to prevent stack overflow error
				//document.writeln('</FORM><SCR'+'IPT>');
				//document.writeln('window.HFORM.submit();');
				//document.writeln('</SCR'+'IPT></BODY></HTML>');
				//document.close();
				document.writeln('</FORM></BODY></HTML>');
				document.close();
				document.HFORM.submit();	
				// End Log 63924 	
			}
		} else {
			// for each row selected
			for (i in aryfound) {
				var row=aryfound[i];
				// check for specific values - these values must be hidden in the component
				if (!f.elements["IDz"+row]) continue;
				if (f.elements["IDz"+row].value!="") {
					// when the report is crystal and will be previewed pass these parameters so they can
					// be converted to prompt(n) variables.
					// PassReportParametersForPreview(lnk,newwin,f.elements["IDz"+row].value);
				}
			}
		}
	}
}

document.body.onload = DocumentLoadHandler;
