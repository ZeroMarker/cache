// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var f=document.getElementById("fOEOrdItem_TabularResultsEMR");
function OpenInformationDoc1() {
	var link1=document.getElementById('ARCIMFileNotes');
	window.open(link1.value);
	return false;
}
function OpenInformationDoc2() {
	var link2=document.getElementById('ARCIMPatientOrderFile1');
	if (link2) window.open(link2.value);
	return false;
}
function OpenInformationDoc3() {
	var link3=document.getElementById('ARCIMPatientOrderFile2');
	if (link3) window.open(link3.value);
	return false;
}

/*
function MarkBoxesOnLoad() {
	var objTagged = document.getElementById("TagList");
	if(objTagged) {
		var tagged=objTagged.value.split("^");
		for(i=0;i<tagged.length;i++) {
			if(tagged[i]!="") {
				objTag=document.getElementById("Tagz"+i);
				if(objTag) objTag.checked=true;
			}
		}
	}
}
*/

// call this from each of atomic, text and word js files
function UpdateBodyLoadHandler() {
  // tick read Checkbox if document.getElementById("ReadResult")!="";
 
	var objTagged=document.getElementById('TaggedRowIDs');
	if(objTagged&&objTagged.value!="") TickTaggedResults("^"+objTagged.value+"^");
	
	var MarkAsReadobj=document.getElementById('MarkAsRead');
	if ((MarkAsReadobj)&&(!MarkAsReadobj.disabled)) MarkAsReadobj.onclick=MarkAsReadClickHandler;

  var objAlreadyRead=document.getElementById('ResultRead');
  if(objAlreadyRead&&MarkAsReadobj) 
  	if(objAlreadyRead.value!="") MarkAsReadobj.checked=true;

  var unreadobj=document.getElementById("Unread");
  if (unreadobj) if(!unreadobj.disabled) unreadobj.onclick=UnreadClickHandler; //UnreadClickHandler;

  var unreadobj=document.getElementById("Update");
  if (unreadobj) if(!unreadobj.disabled) unreadobj.onclick=UpdateClickHandler;

  var unreadobj=document.getElementById("ReadAll");
  if (unreadobj) if(!unreadobj.disabled) unreadobj.onclick=ReadAllClickHandler;
    
	// if NO counter - we have come from MRAdm.ListEMRResults - so don't try and read all...
	var counter="";
	var objcounter=document.getElementById("Counter");
	if (objcounter) counter = objcounter.value;
	
	// Log 51375 YC - Show Warning for Unverfied Results
	var objShowWarning = document.getElementById("ShowNotVerifWarning")
	if (objShowWarning)
		if (objShowWarning.value) alert(t['NotVerified']);
		
	if(counter!=="") // for OEOrdItem.Tabular* pages (from OEOrdItem.ListTabularEMR)
	{
		var CONTEXT = document.getElementById("CONTEXT").value;
		// Log 58881 YC - Replaced ResultList and OrderList with a TMP global
  	//var ResultList = window.opener.document.getElementById("ResultList"+CONTEXT).value;
  	//var OrderList = window.opener.document.getElementById("OrderList"+CONTEXT).value;  
  
  	/*
  	var thisResultList = document.getElementById("ResultList");
  	if (thisResultList) thisResultList.value=ResultList;
  	var thisOrderList = document.getElementById("OrderList");
  	if (thisOrderList) thisOrderList.value=OrderList;
  	*/

		var prevobj=document.getElementById('Prev');
		var prevcountobj=document.getElementById('PrevCounterID');
		if (prevobj&&prevcountobj) {
			if (prevcountobj.value=="" || counter<=1) {
				prevobj.disabled=true;
				prevobj.onclick=LinkDisable;
			} else {
	  	  prevobj.onclick=PrevClickHandler;
	  	}
	  }
    
    //var maxcount=ResultList.split("^").length;

    var nextcountobj=document.getElementById('NextCounterID');
	  var upnextobj=document.getElementById('UpdateAndNext');
	  if (upnextobj&&nextcountobj) {
	  	if (nextcountobj.value=="") { // || counter>=maxcount) {
	  		upnextobj.disabled=true;
	  		upnextobj.onclick=LinkDisable;
      }
    }

  	var upnextobj=document.getElementById('UpdateAndNext');
  	if (upnextobj) if(!upnextobj.disabled) upnextobj.onclick=UpdateAndNextClickHandler;

		var nextobj=document.getElementById('Next');
		if (nextobj&&nextcountobj) {
			if (nextcountobj.value=="") { // || counter>=maxcount) {
				nextobj.disabled=true;
				nextobj.onclick=LinkDisable;
			} else {
			  nextobj.onclick=NextClickHandler;
			}
		}
	}
	else  // coming from MRAdm.ListEMRResults - no next/prev needed
	{
		var prevobj=document.getElementById('Prev');
		if(prevobj)
		{
			prevobj.disabled=true;
			prevobj.onclick=LinkDisable;
		}
		var upnextobj=document.getElementById('UpdateAndNext');
		if(upnextobj)
		{
			upnextobj.disabled=true;
			upnextobj.onclick=LinkDisable;
		}
		var nextobj=document.getElementById('Next');
		if(nextobj)
		{
			nextobj.disabled=true;
			nextobj.onclick=LinkDisable;
		}		
		var readallobj=document.getElementById('ReadAll');
		if(readallobj)
		{
			readallobj.disabled=true;
			readallobj.onclick=LinkDisable;
		}	
	}


  //Population information links against the order
	var obj1=document.getElementById('InformationLink1');
	var link1=document.getElementById('ARCIMFileNotes');
	if ((obj1)&&(link1)&&(link1.value=="")) {
		obj1.disabled=true;
		obj1.onclick=LinkDisable;
	}
	if ((obj1)&&(link1)&&(link1.value!="")) obj1.onclick=OpenInformationDoc1;
	var obj2=document.getElementById('InformationLink2');
	var link2=document.getElementById('ARCIMPatientOrderFile1');
	if ((obj2)&&(link2)&&(link2.value=="")) {
		obj2.disabled=true;
		obj2.onclick=LinkDisable;
	}
	if ((obj2)&&(link2)&&(link2.value!="")) obj2.onclick=OpenInformationDoc2;

	var obj3=document.getElementById('InformationLink3');
	var link3=document.getElementById('ARCIMPatientOrderFile2');
	if ((obj3)&&(link3)&&(link3.value=="")) {
		obj3.disabled=true;
		obj3.onclick=LinkDisable;
	}
	if ((obj3)&&(link3)&&(link3.value!="")) obj3.onclick=OpenInformationDoc3;

	var UpdateLink=document.getElementById("UpdateLink");
	if (UpdateLink) UpdateLink = UpdateLink.value;

	return true;
}

function IsValidResType(restype) {
	if ((restype=="T")||(restype=="W")||(restype=="L")||(restype=="RTFLAB")||(restype=="WLAB")) {
		return true;
	}
	else  {
		return false;
	}
}

function PrevClickHandler(e) {
	var counterobj=document.getElementById('Counter');
	var prevcounterobj=document.getElementById('PrevCounterID');
	TagResults();
	if(counterobj&&prevcounterobj)
		counterobj.value=prevcounterobj.value;

	// Log 52156 YC - undisable to save the markasread value (disabled elements do not save)
	var MarkAsReadobj = document.getElementById('MarkAsRead');
	if (MarkAsReadobj) MarkAsReadobj.disabled = false; 

	return Prev_click();
}

function NextClickHandler(e) {
	var counterobj=document.getElementById('Counter');
	var nextcounterobj=document.getElementById('NextCounterID');
	TagResults();
	if(counterobj&&nextcounterobj)
		counterobj.value=nextcounterobj.value;

	// Log 52156 YC - undisable to save the markasread value (disabled elements do not save)
	var MarkAsReadobj = document.getElementById('MarkAsRead');
	if (MarkAsReadobj) MarkAsReadobj.disabled = false; 

	return Next_click();
}

function UnreadClickHandler(e) {
	// mark me as unread, then update ALL pages
	TagResults();
	var MarkAsReadobj=document.getElementById('MarkAsRead');
	if ((MarkAsReadobj) && (!MarkAsReadobj.disabled)) {
		MarkAsReadobj.checked = false;
	} else {
		return false;
	}
	// Log 51948 YC - from custom script for Qld Health
	try {
		if(!Update2ClickHandler())
		{
			return false;
		}
	} catch(ex) {}
	
	return Unread_click();
}
function UpdateClickHandler(e) {
	TagResults();
	var OneResObj=document.getElementById('UpdateOneResult');
	if(OneResObj) OneResObj.value=1;
	
	// Log 51948 YC - from custom script for Qld Health
	try {
		if(!Update2ClickHandler())
			return false;
	} catch(ex) { }
	
	// Log 52156 YC - undisable to save the markasread value (disabled elements do not save)
	var MarkAsReadobj = document.getElementById('MarkAsRead');
	if (MarkAsReadobj) MarkAsReadobj.disabled = false; 
	return Update_click();
}
function ReadAllClickHandler(e) {
	TagResults();
	
	// Log 51948 YC - from custom script for Qld Health
	try {
		if(!Update2ClickHandler())
			return false;
	} catch(ex) {}
	
	// Log 52156 YC - undisable to save the markasread value (disabled elements do not save)
	var MarkAsReadobj = document.getElementById('MarkAsRead');
	if (MarkAsReadobj) MarkAsReadobj.disabled = false; 
	
	return ReadAll_click();
}
function UpdateAndNextClickHandler(e) {
	var counterobj=document.getElementById('Counter');
	var nextcounterobj=document.getElementById('NextCounterID');
	TagResults();
	if(counterobj&&nextcounterobj)
		counterobj.value=nextcounterobj.value;
	
	// Log 51948 YC - from custom script for Qld Health
	try {
		if(!Update2ClickHandler())
			return false;
	} catch(ex) {}
		
	// Log 52156 YC - undisable to save the markasread value (disabled elements do not save)
	var MarkAsReadobj = document.getElementById('MarkAsRead');
	if (MarkAsReadobj) MarkAsReadobj.disabled = false; 
		
	return UpdateAndNext_click();
}

function GetTheTitle(ResultType,HL7ResultType)  {
	var TheTitle = "";
	if ((ResultType=="T")||((ResultType=="L")&&(HL7ResultType=="IM"))) {
		TheTitle = 'TextResults';
	} else if (ResultType=="L") {
		TheTitle = 'AtomicResults';
	} else if (ResultType=="RTFLAB") {
		TheTitle = 'RTFResults';
	} else if ((ResultType=="W")||(ResultType=="WLAB")) {
		TheTitle = 'WordResults';
	}
	return TheTitle;
}

function LinkDisable(e) {
	var el = websys_getSrcElement(e);
	if (el.disabled) {
		return false;
	}
	return true;
}

function MarkAsReadClickHandler(e) {
	var MarkAsReadobj=document.getElementById('MarkAsRead');

	var Updateobj=document.getElementById("Update");
	if (Updateobj && Updateobj.disabled && (MarkAsReadobj.checked)) {
		return false;
	}
	return true;
}