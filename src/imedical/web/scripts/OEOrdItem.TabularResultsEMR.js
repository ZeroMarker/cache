// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var f=document.getElementById("fOEOrdItem_TabularResultsEMR");

// create a variable to indicate to OEORdItem.TabularResultsUpdate.js
// that it is to call TagResults upon 'read & next'
var TabularAtomic = true;

function TickTaggedResults(TagString) {
	var datarow = "";
	var tbl=document.getElementById("tOEOrdItem_TabularResultsEMR");
	for (var i=1;(i<(tbl.rows.length+1));i++) {
		datarow = document.getElementById("DataRowIDz" + i);
		tagbox = document.getElementById("Tagz" + i);
		if (datarow && tagbox) {
		 	if (TagString.indexOf("^" + datarow.value + "^")!=-1) {
				tagbox.checked = true;
			}
		}
	}
}

function GetTagged(Delim) {
	var Tagged = "";
	var UnTagged = "";
	var datarow = "";
	var tbl=document.getElementById("tOEOrdItem_TabularResultsEMR");
	for (var i=1;(i<(tbl.rows.length+1));i++) {
		datarow = document.getElementById("DataRowIDz" + i);
		if (datarow) {
		 	if (f.elements["Tagz"+i] && f.elements["Tagz"+i].checked && !f.elements["Tagz"+i].disabled) {
				Tagged  = Tagged + datarow.value + Delim;
			} else {
				UnTagged  = UnTagged + datarow.value + Delim;
			}
		}
	}
	// add the test item comment rows...tOEOrdItem_TabularResultsEMRCOMMENTS
	var tblcomm=document.getElementById("tOEOrdItem_TabularResultsEMRCOMMENTS");
	if (tblcomm) {
		for (i=1;(i<(tblcomm.rows.length+1));i++) {
			datarow = document.getElementById("CommentRowIDz" + i);
			if (datarow) { UnTagged  = UnTagged + datarow.value + Delim;}
		}
	}

	return Tagged + "," + UnTagged;
}

function TagResults() {
	var tmp = GetTagged("^");
	var arrtmp = tmp.split(",");
	var Tagged = arrtmp[0];
	var UnTagged = arrtmp[1];
	var TaggedRowIDs = document.getElementById("TaggedRowIDs");
	if (TaggedRowIDs) {
		TaggedRowIDs.value = Tagged;
	}
	var UnTaggedRowIDs = document.getElementById("UnTaggedRowIDs");
	if (UnTaggedRowIDs) {
		UnTaggedRowIDs.value = UnTagged;
	}
}

function ChkAbnormalResult() {
	var tbl=document.getElementById("tOEOrdItem_TabularResultsEMR");
	for (var curr_row=1; curr_row<tbl.rows.length; curr_row++) {
		var FlagValue = document.getElementById("FlagValuez" + curr_row);
		var FlagCode=document.getElementById("OtherFlagCodez" + curr_row);
		if ((FlagCode) && (FlagCode.value!="")) {
			// there are other HL7 flags...
			var obj=getRow(FlagCode);
			var clrBG=obj.currentStyle.backgroundColor;
			if (FlagCode.value=="N") {
				obj.className="NormalResult"
				obj.style.backgroundColor=clrBG;
			} else if (FlagCode.value=="L") {
				obj.className="LowResult"
				obj.style.backgroundColor=clrBG;
			} else if (FlagCode.value=="H") {
				obj.className="HighResult"
				obj.style.backgroundColor=clrBG;
			} else if (FlagCode.value=="LL") {
				obj.className="LowLowResult"
				obj.style.backgroundColor=clrBG;
			} else if (FlagCode.value=="HH") {
				obj.className="HighHighResult"
				obj.style.backgroundColor=clrBG;
			} else if (FlagCode.value=="A") {
 				// Log 44050 - AI - 06-09-2004 : Add logic for "A" for Abnormal.
				obj.className="AbnormalResult"
				obj.style.backgroundColor=clrBG;
			}
		} else if ((FlagValue) && (FlagValue.value!="N") && (FlagValue.value!="")) {
			// no other flags - so use the flags calculated
			MarkAsAbnormal(curr_row,tbl);
		}
	}
}

function getRow(eSrc) {
	while(eSrc.tagName != "TR") {
		if (eSrc.tagName == "TH") break;
		if (eSrc.parentElement) {
			eSrc=eSrc.parentElement;
		} else {
			eSrc="";
			break;
		}
	}
	return eSrc;
}

function MarkAsAbnormal(CurrentRow,tableobj) {
	for (var CurrentCell=0; CurrentCell<tableobj.rows[CurrentRow].cells.length; CurrentCell++) {
		tableobj.rows[CurrentRow].cells[CurrentCell].style.color="Red";
   	}
}

function CumulativeClickHandler(e) {
		var PatientID = document.getElementById("PatientID");
		if (PatientID) {PatientID = PatientID.value};
		var EpisodeID = document.getElementById("EpisodeID");
		if (EpisodeID) {EpisodeID = EpisodeID.value};
		// Log 37905 - AI - 04-09-2003 : add mradm to the parameters list.
		var mradm = document.getElementById("mradm");
		if (mradm) {mradm = mradm.value};
		var EpisodesAll = document.getElementById("EpisodesAll");
		if (EpisodesAll) {EpisodesAll = EpisodesAll.value};
		var ChartID = "";
		var Context = "";
		var IncludeRPrefix = window.opener.document.getElementById("IncludeRPrefix");
		if (IncludeRPrefix) {IncludeRPrefix = IncludeRPrefix.value};
		var CumulativeItemIDs = "";

		var tbl=document.getElementById("tOEOrdItem_TabularResultsEMR");
		for (var curr_row=1; curr_row<tbl.rows.length; curr_row++) {
			var cumItemID = document.getElementById("CMLz" + curr_row);
			if (cumItemID && cumItemID.checked) {
				var TestItemCode = document.getElementById("TestItemCodez" + curr_row);
				if (TestItemCode) {
					if (CumulativeItemIDs!="") {CumulativeItemIDs = CumulativeItemIDs + "^"};
					CumulativeItemIDs = CumulativeItemIDs + TestItemCode.value;
				}
			}
		}
		// if we have chosen NO cumulative items - get all items for this order, or display group...
		var ItemID =""
		var OrderID =""
		if (CumulativeItemIDs=="") {
			/*
			for (var curr_row=1; curr_row<=tbl.rows.length; curr_row++) {
				var cumItemID = document.getElementById("CMLz" + curr_row);
				if (cumItemID) {
					var TestItemCode = document.getElementById("TestItemCodez" + curr_row);
					if (TestItemCode) {
						if (CumulativeItemIDs!="") {CumulativeItemIDs = CumulativeItemIDs + "^"};
						CumulativeItemIDs = CumulativeItemIDs + TestItemCode.value;
					}
				}
			}
			var tbl2=document.getElementById("tOEOrdItem_TabularResultsEMRCOMMENTS");
			for (var curr_row=1; curr_row<=tbl2.rows.length; curr_row++) {
				var TestItemCode = document.getElementById("TestItemCodeCommentz" + curr_row);
				if (TestItemCode) {
					if (CumulativeItemIDs!="") {CumulativeItemIDs = CumulativeItemIDs + "^"};
					CumulativeItemIDs = CumulativeItemIDs + TestItemCode.value;
				}
			}
			*/
			ItemID = document.getElementById("ItemID");
			if (ItemID) ItemID = ItemID.value;
			OrderID = document.getElementById("ID");
			if (OrderID) OrderID = OrderID.value;
		}
		// Log 37905 - AI - 04-09-2003 : add mradm to the parameters list.
		var url="epr.cumulative.csp?PatientID="+PatientID+"&PatientBanner=1&EpisodeID="+EpisodeID+"&EpisodesAll="+EpisodesAll+"&ChartID="+ChartID+"&Context="+Context+"&OrderItemID="+ItemID+"&IncludeRPrefix="+IncludeRPrefix+"&CumulativeItemIDs="+CumulativeItemIDs+"&ColumnID="+ColumnID+"&mradm="+mradm+"&CanRead=1"+"&OrderID="+OrderID;
		//var url="epr.cumulative.csp?PatientID="+PatientID+"&PatientBanner=1&EpisodeID="+EpisodeID+"&EpisodesAll="+EpisodesAll+"&ChartID="+ChartID+"&Context="+Context+"&OrderItemID="+ItemID+"&IncludeRPrefix="+IncludeRPrefix+"&CumulativeItemIDs="+CumulativeItemIDs+"&ColumnID="+OrderID+"&mradm="+mradm+"&CanRead=1"+"&OrderID="+OrderID;

		websys_createWindow(url, 'CumulativeResults', 'scrollbars=yes,toolbar=no,width=screen.width,height=screen.height,top=0,left=0,resizable=yes');
}

// this will be done on the load - we will open our own document
document.body.onload = BodyLoadHandler;

function BodyLoadHandler() {

	var obj=document.getElementById('Cumulative');
	if (obj) obj.onclick=CumulativeClickHandler;

	ChkAbnormalResult();

	var obj=document.getElementById("CanReadItems");
	if ((obj)&&(obj.value!=1)) {
		var MarkAsReadobj=document.getElementById('MarkAsRead');
		if (MarkAsReadobj) {
			MarkAsReadobj.disabled = true;
		}
		var obj=document.getElementById("Unread");
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById("UpdateAndNext");
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
	}

	var obj=document.getElementById("AllowStatusz1");
	if ((obj)&&(obj.value!="Y")) {
		var MarkAsReadobj=document.getElementById('MarkAsRead');
		if (MarkAsReadobj) {
			MarkAsReadobj.disabled = true;
		}
		var obj=document.getElementById("Unread");
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj2=document.getElementById("UpdateAndNext");
		if (obj2) {
			obj2.disabled=true;
			obj2.onclick=LinkDisable;
		}
	}

	/*
	var objDATE=document.getElementById("DateRead");
	var objTIME=document.getElementById("TimeRead");
	if ((objDATE)&(objTIME))	{
		if ((objDATE.value=="")&&(objTIME.value=="")) {
			var obj=document.getElementById("Unread");
			if (obj) {
				obj.disabled=true;
				obj.onclick=LinkDisable;
			}
		}
	}
	var obj=document.getElementById("ResultRead");
	var obj2=document.getElementById("DoNotDisplayz1");
	if (((obj)&&(obj.value==""))||((obj2)&&(obj2.value!=0))) {
		obj=document.getElementById("Unread");
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
	}
	*/

	var objBold=document.getElementById('BoldLinks');
	if (objBold) {
		var BoldLink = objBold.value.split("^");
		var obj=document.getElementById('EscalationHistory');
		if ((obj) && (BoldLink[0]=="1")) obj.style.fontWeight="bold";
	}

	UpdateBodyLoadHandler();
}

