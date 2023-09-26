// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ANA LOG 33222 Save SearchPreferences for View request Screen in websys.Preferences.
function LookUpSelLoc(txt) {
	var adata=txt.split("^");
	var LocDesc=adata[0];
	var LocID=adata[3];	
	txt=LocDesc+"^"+LocID;
	var lobj=document.getElementById("LocDesc");
	if (lobj) lobj.value=LocDesc;
	var lbObj=document.getElementById("MLocDesc");
	if (lbObj) SetListBoxValues(lbObj,txt)
	if (lobj) lobj.value="";
}
function LookUpSelCurrLoc(txt) {
	var adata=txt.split("^");
	var LocDesc=adata[0];
	var LocID=adata[1];	
	txt=LocDesc+"^"+LocID;
	var lobj=document.getElementById("CurrLoc");
	if (lobj) lobj.value=LocDesc;
	var lbObj=document.getElementById("MCurrLoc");
	if (lbObj) SetListBoxValues(lbObj,txt)
	if (lobj) lobj.value="";
}
function LookUpSelReqFrom(txt){
	var adata=txt.split("^");
	var RequestedFrom=adata[0];
	var LocID=adata[1];	
	txt=RequestedFrom+"^"+LocID;
	var rfobj=document.getElementById("RequestedFrom");
	if (rfobj) rfobj.value=RequestedFrom;
	var mrfObj=document.getElementById("MRequestedFrom");
	if (mrfObj) SetListBoxValues(mrfObj,txt)
	if (rfobj) rfobj.value="";
}
function ChangeStatusHandler(txt){
	var adata=txt.split("^");
	//alert(" Status1 "+txt);
	var Status1=adata[0];
	var Status1ID=adata[2];
	txt=Status1+"^"+Status1ID;
	var rfobj=document.getElementById("Status1");
	if (rfobj) rfobj.value=Status1;
	var mrfObj=document.getElementById("MStatus1");
	if (mrfObj) SetListBoxValues(mrfObj,txt)
	if (rfobj) rfobj.value="";
}
function LookUpReasForReq(txt){
	var adata=txt.split("^");
	//alert(" ReasForRequest "+txt);
	var Reason=adata[0];
	var ReasID=adata[2];	
	txt=Reason+"^"+ReasID;
	var rfobj=document.getElementById("ReasForRequest");
	if (rfobj) rfobj.value=Reason;
	var mrfObj=document.getElementById("MReasForRequest");
	if (mrfObj) SetListBoxValues(mrfObj,txt)
	if (rfobj) rfobj.value="";
}
function LookUpCurrLocSelect(){
	var adata=txt.split("^");
	//alert(" CurrLoc "+txt);	
	var RequestedFrom=adata[0];
	var rfobj=document.getElementById("CurrLoc");
	if (rfobj) rfobj.value=RequestedFrom;
	var mrfObj=document.getElementById("MCurrLoc");
	if (mrfObj) SetListBoxValues(mrfObj,txt)
	if (rfobj) rfobj.value="";
}
function SetListBoxValues(BoxObj,Value){
	var adata=Value.split("^");
	var LocDesc=adata[0];
	//alert("LocDesc-value"+LocDesc+"-"+Value);
	BoxObj.options[BoxObj.length] = new Option(LocDesc,Value);	
}
function DeleteClickHandler(){
	var lst1 = document.getElementById("MLocDesc");
	DeleteSelItems(lst1);
	var lst2 = document.getElementById("MRequestedFrom");
	DeleteSelItems(lst2);
	var lst3 = document.getElementById("MReasForRequest");
	DeleteSelItems(lst3);
	var lst4 = document.getElementById("MStatus1");
	DeleteSelItems(lst4);
	var lst5 = document.getElementById("MCurrLoc");
	DeleteSelItems(lst5);
	return false;
}
function DeleteSelItems(LstObj){
	for (var i=(LstObj.length-1); i>=0; i--) {
			if (LstObj.options[i].selected)
				LstObj.options[i]=null;
	}
}
function UpdateClickHandler(){
	var lst1 = document.getElementById("MLocDesc");
	var Fld1=document.getElementById("HMLocDesc");
	if ((lst1)&&(Fld1)) UpdateHiddenField(lst1,Fld1);
	
	
	var lst2 = document.getElementById("MRequestedFrom");
	var Fld2=document.getElementById("HMRequestedFrom");
	if ((lst2)&&(Fld2)) UpdateHiddenField(lst2,Fld2);
	
	var lst3 = document.getElementById("MReasForRequest");
	var Fld3=document.getElementById("HMReasForRequest");
	if ((lst3)&&(Fld3)) UpdateHiddenField(lst3,Fld3);
	
	var lst4 = document.getElementById("MStatus1");
	var Fld4=document.getElementById("HMStatus1");
	if ((lst4)&&(Fld4)) UpdateHiddenField(lst4,Fld4);	
	
	var lst5 = document.getElementById("MCurrLoc");
	var Fld5=document.getElementById("HMCurrLoc");
	if ((lst5)&&(Fld5)) UpdateHiddenField(lst5,Fld5);	
	return Update_click();
}
function UpdateHiddenField(LstObj,FldObj) {
	var hvalue="";
	//var arrItems = new Array();
	for (var j=0; j<LstObj.options.length; j++) {
		hvalue=hvalue+LstObj.options[j].value+String.fromCharCode(1);
		//arrItems[j] = LstObj.options[j].value;
		//alert(" j "+j+" LstObj.id="+LstObj.id+" LstObj.value="+LstObj.options[j].value);
	}
	if (FldObj) FldObj.value = hvalue;
	//if (FldObj) FldObj.value = arrItems.join(String.fromCharCode(1));
	//alert("FldObj.id="+FldObj.id+" FldObj.value="+FldObj.value);
}
var uobj=document.getElementById("Update");
if (uobj) uobj.onclick=UpdateClickHandler;
var dobj=document.getElementById("Delete");
if (dobj) dobj.onclick=DeleteClickHandler;