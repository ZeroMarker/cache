// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var lst=document.getElementById("OrdItemList")

function DocumentLoadHandler() {

	var obj=document.getElementById("EQQty");
	if (obj) obj.onchange = QtyOnchangeHandler;
	var obj=document.getElementById("EQSequenceNo");
	if (obj) obj.onchange = SequNoOnChangeHandler;
	var obj=document.getElementById("AddToList")
	if (obj) obj.onclick=AddOIToList;
	var obj=document.getElementById("Delete")
	if (obj) obj.onclick=RemoveListItems;
	var obj=document.getElementById("Update")
	if (obj) obj.onclick=UpdateClickHandler;
	//log56749 TedT
	var OrdSubCat=document.getElementById("EQOrdSubCat")
	if(OrdSubCat) OrdSubCat.onblur=clearSubCatID;

	//RC If an Id is found, then it's 'edit mode' and all they should be able to change is quantity and seqNo.
	var id=document.getElementById("OpPrefEqID")
	if (id.value!="") EditMode();
}

function EditMode() {
	var obj=document.getElementById("AddToList")
	if (obj) { obj.disabled=true; obj.onclick=""; }
	var obj=document.getElementById("Delete")
	if (obj) { obj.disabled=true; obj.onclick=""; }

	var obj=document.getElementById("EQOrdCat")
	if (obj) { obj.disabled=true; obj.className="disabledField" }
	var obj=document.getElementById("ld2115iEQOrdCat")
	if (obj) obj.disabled=true;
	var obj=document.getElementById("EQOrdSubCat")
	if (obj) { obj.disabled=true; obj.className="disabledField" }
	var obj=document.getElementById("ld2115iEQOrdSubCat")
	if (obj) obj.disabled=true;
	var obj=document.getElementById("EQOrdItem")
	if (obj) { obj.disabled=true; obj.className="disabledField" }
	var obj=document.getElementById("ld2115iEQOrdItem")
	if (obj) obj.disabled=true;
	//LOG 57313 If Order Set, disable Qty.
	if (document.getElementById("EQARCOSDR").value!=""){
		var obj=document.getElementById("EQQty")
		if (obj) { obj.disabled=true; obj.className="disabledField" }
	}
	// 62488 RC If coming from Bulk Pref screen, disable Qty and Seq also
	if (document.getElementById("BulkPref").value=="1"){
		var obj=document.getElementById("EQQty")
		if (obj) { obj.disabled=true; obj.className="disabledField" }
		var obj=document.getElementById("EQSequenceNo")
		if (obj) { obj.disabled=true; obj.className="disabledField" }
	}

	if (lst) { lst.disabled=true; lst.className="disabledField"}
	var obj=document.getElementById("Update")
	if (obj) obj.onclick=EditUpdateClickHandler;
}

function SubCatLookUpHandler(txt) {
	var adata=txt.split("^");

	var SubCat=document.getElementById("EQOrdSubCat")
	var SubCatID=document.getElementById("subCatID")

	if (SubCat) SubCat.value=adata[0];
	if (SubCatID) SubCatID.value=adata[1];
}

function OrdItemLookupSelect(txt) {
	var adata=txt.split("^");

	var OrdItem=document.getElementById("EQOrdItem")
	var ARCIM=document.getElementById("EQARCIMDR")
	var ARCOS=document.getElementById("EQARCOSDR")
	var Qty=document.getElementById("EQQty")
	if (Qty) Qty.disabled=false;

	if (OrdItem) OrdItem.value=adata[0];
	if (adata[3]=="ARCIM") {ARCIM.value=adata[1]; ARCOS.value=""}
	if (adata[3]=="ARCOS") {
		ARCOS.value=adata[1]; ARCIM.value=""
		//LOG 57313 If Order Set, disable Qty.
		if (Qty) {
			Qty.value=1;
			Qty.disabled=true;
		}
	}
}

//log56749 TedT clear Sub Cat ID when sub cat field is cleared
function clearSubCatID() {
	var subCat=document.getElementById("subCatID");
	if (this.value=="" && subCat) subCat.value="";
}

function AddOIToList() {
	var OrdCat=document.getElementById("EQOrdCat")
	var OrdSubCat=document.getElementById("EQOrdSubCat")
	var OrdItem=document.getElementById("EQOrdItem")
	var ARCIM=document.getElementById("EQARCIMDR")
	var ARCOS=document.getElementById("EQARCOSDR")
	var Qty=document.getElementById("EQQty")
	var Seq=document.getElementById("EQSequenceNo")
	var SeqNo=""; if (Seq) SeqNo=Seq.value;
	var snList=document.getElementById("seqNoList")
	//log56749 TedT
	var subCat=document.getElementById("subCatID");
	var ActDF=document.getElementById("EQDateActiveFrom"); //Log 65339 KB
	var ActDT=document.getElementById("EQDateActiveTo");  // Log 65339 KB
	var oktocont=true;

	if ((OrdItem)&&(Qty)) {
		if (OrdItem.value=="") {alert(t["NoOrdItem"]); return false;}
		if ((Qty.value!="")&&(Qty.value<1)) {
			alert(t['InvQty']);
			Qty.className="clsInvalid";
			return false;
		}		
		if ((OrdItem.className=="clsInvalid")||(Qty.className=="clsInvalid")) return false;
		if ((SeqNo!="")&&(snList.value.search(SeqNo)!=-1)) oktocont=confirm(t["SeqExists"]);
		if (!oktocont) return false;
		if (Qty.value=="") Qty.value=1;
		for (i=0; i<lst.options.length; i++) {
			if ((ARCIM.value!="")&&(ARCIM.value==lst.options[i].value)) {
				alert(t["OrdItemExists"]);
				return false;
			}
			if ((ARCOS.value!="")&&(ARCOS.value==lst.options[i].value)) {
				alert(t["OrdSetExists"]);
				return false;
			}
			var txt=lst.options[i].text.split(".");
			if ((SeqNo!="")&&(SeqNo==txt[0])) {
				oktocont=confirm(t["SeqExists"]);
				if (!oktocont) return false;
			}
		}
		var desc=SeqNo+". "+OrdItem.value+" ("+Qty.value+")";
		//Log 65339 KB
		if ((ActDF)&&(ActDF.value!="")) {desc=desc+" DateF="+ActDF.value;}
		if ((ActDT)&&(ActDT.value1="")) {desc=desc+" DateT="+ActDT.value;}
		//End Log 65339
		if (ARCIM.value!="") {var code=ARCIM.value+":OI"+":"+SeqNo+":"+Qty.value+":"+ActDF.value+":"+ActDT.value;}
		if (ARCOS.value!="") {var code=ARCOS.value+":OS"+":"+SeqNo+":"+Qty.value+":"+ActDF.value+":"+ActDT.value;}
		lst.options[lst.options.length] = new Option(desc,code);
		Qty.value=""; OrdItem.value=""; OrdSubCat.value=""; OrdCat.value="";
		if (ActDF) {ActDF.value="";}
		if (ActDT) {ActDT.value=""}
		
		//log56749 TedT clear sub cat id
		if(subCat) subCat.value="";
		if (Seq) Seq.value="";
		if (Qty.disabled==true) Qty.disabled=false;
	}
}

function RemoveListItems() {
	for (var i=(lst.length-1); i>=0; i--) {
		if (lst.options[i].selected) lst.options[i]=null;
	}
}

function UpdateClickHandler() {
	var liststring="";
	var eqqty=document.getElementById("EQQty");
	var seqno=document.getElementById("EQSequenceNo");
	var actDF=document.getElementById("EQDateActiveFrom");
	var actDT=document.getElementById("EQDateActiveTo");
	
	if ((eqqty)&&(eqqty.className == "clsInvalid")) {
		alert(t['EQQty'] + " " + t['XINVALID']);
		return false;
	}
	if ((seqno)&&(seqno.className == "clsInvalid")) {
		alert(t['EQSequenceNo'] + " " + t['XINVALID']);
		return false;
	}
	if ((actDF)&&(actDF.className == "clsInvalid")) {
		alert(t['EQDateActiveFrom'] + " " + t['XINVALID']);
		return false;
	}
	if ((actDT)&&(actDT.className == "clsInvalid")) {
		alert(t['EQDateActiveTo'] + " " + t['XINVALID']);
		return false;
	}
		
	for (i=0; i<lst.options.length; i++) {
		var tmptxt=lst.options[i].text.split(" (");
		var txt=tmptxt[1].split(")");
		//Log 65339 KB
		liststring=liststring+lst.options[i].value+":"
		if ((actDF)&&(actDF.value!="")) {liststring=liststring+actDF.value;}
		liststring=liststring+":";
		if ((actDT)&&(actDT.value!="")) {liststring=liststring+":"+actDT.value;}
		liststring=liststring+"*^";
	}
	document.getElementById("OrdItemIDList").value=liststring;
	return Update_click();
}

function EditUpdateClickHandler() {
	var liststring="";
	var ARCIM=document.getElementById("EQARCIMDR")
	var ARCOS=document.getElementById("EQARCOSDR")
	var Qty=document.getElementById("EQQty")
	var id=document.getElementById("OpPrefEqID")
	var Seq=document.getElementById("EQSequenceNo")
	var SeqNo=""; if (Seq) SeqNo=Seq.value;
	var snList=document.getElementById("seqNoList")
	var oktocont=true;
	var eqqty=document.getElementById("EQQty");
	var prevseqno=document.getElementById("PrevSeqNo");
	// Log 65339 KB
	var objDF=document.getElementById("EQDateActiveFrom");
	var objDT=document.getElementById("EQDateActiveTo");

	if (eqqty.className == "clsInvalid") {
		alert(t['EQQty'] + " " + t['XINVALID']);
		return false;
	}
	if (Seq.className == "clsInvalid") {
		alert(t['EQSequenceNo'] + " " + t['XINVALID']);
		return false;
	}
	if (objDF.className == "clsInvalid") {
		alert(t['EQDateActiveFrom'] + " " + t['XINVALID']);
		return false;
	}
	if (objDT.className == "clsInvalid") {
		alert(t['EQDateActiveTo'] + " " + t['XINVALID']);
		return false;
	}

	if ((SeqNo!="")&&(snList.value.search(SeqNo)!=-1)&&(SeqNo!=prevseqno.value)) oktocont=confirm(t["SeqExists"]);
	if (!oktocont) return false;
	if (Qty.value=="") Qty.value=1;
	//log 65339 KB
	if (ARCIM.value!="") {
		liststring=ARCIM.value+":OI"+":"+SeqNo+":"+Qty.value+":";
		if (objDF) {liststring=liststring+objDF.value;} //log KB Addind DateActiveFrom and DateActiveTo values to the string
		liststring=liststring+":";
		if (objDT) {liststring=liststring+objDT.value;}
		liststring=liststring+"*"+id.value+"^";
	}
	else if (ARCOS.value!="") {
		liststring=ARCOS.value+":OS"+":"+SeqNo+":"+Qty.value+":";
		if (objDF) {liststring=liststring+objDF.value;} //log KB Addind DateActiveFrom and DateActiveTo values to the string
		liststring=liststring+":";
		if (objDT) {liststring=liststring+objDT.value;}
		liststring=liststring+"*"+id.value+"^";
	}

	document.getElementById("OrdItemIDList").value=liststring;
	return Update_click();
}

function QtyOnchangeHandler() {
	var obj=document.getElementById("EQQty");
	if (obj) {
		if (obj.value.length > 3) {
			obj.className = "clsInvalid";
			websys_setfocus('EQQty');
		}

		else {
			if (obj.readOnly) {obj.className='clsReadOnly'} else {obj.className=''}
			EQQty_changehandler();
		}
	}

}

function SequNoOnChangeHandler() {
	var obj=document.getElementById("EQSequenceNo");
	if (obj) {
		if (obj.value.length > 3) {
			obj.className = "clsInvalid";
			websys_setfocus('EQSequenceNo');
		}

		else {
			if (obj.readOnly) {obj.className='clsReadOnly'} else {obj.className=''}
			EQSequenceNo_changehandler();
		}
	}
}
document.body.onload=DocumentLoadHandler;