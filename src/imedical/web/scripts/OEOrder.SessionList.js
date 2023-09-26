// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

//log  64353
var newOrder=true;
var tbl=document.getElementById('tOEOrder_SessionList');
if (tbl) {
	tbl.onfocusin=inhandler;
}

var G_idxRowEdited=0; //set by focusout - retrieved in broker call
var G_idxRowIn=0; //set by focusin - set only if document focus in row
var G_idxRowField=false; //set by focusin - set if focus was 
var idxRowEdited=0;

function outhandler(e) {
	if (!e) {e = window.event;}
	//websys_cancel();
	if (!G_idxRowIn) {return;}
	var outObj=websys_getSrcElement(e);
	var outRow=tk_getRow(outObj);
	if (!outRow) {alert('ARGH!-It should never get here');return;}
	var nextObj=null;
	if (e.relatedTarget) {nextObj = e.relatedTarget; } else if (e.toElement) {nextObj = e.toElement;}
	//nextObj could be null if focus went out of table or out of document
	if (nextObj) {
		nextRow=tk_getRow(nextObj);
		//if focus was in field and user clicks of non-editable column of same row, need to run broker
		//if ((!websys_canfocus(nextObj))&&(nextRow==outRow)) {nextRow=null;} //reset nextRow so that the broker updates
	} else {nextRow=null;}
	
	var Out="";
	//Log 65897 PeterC 27/02/08
	if(nextRow==null) {Out=outRow.sectionRowIndex+1;}
	if (nextRow != outRow) {
		if ((lu_obj)&&(!lu_obj.completed)) {
			if (tk_getRow(lu_obj)==outRow) {
				//alert("same lu_obj");
				//Log 65897 PeterC 27/02/08
				if(Out!="") idxRowEdited=Out;
				updaterowhandler();
				return false;
			}
		}
		idxRowEdited=1+outRow.sectionRowIndex; //use sectionRowIndex as this will always be the same and not dependant on tableheading, 0 start so add 1
		updaterowhandler();
		if(lu_obj) lu_obj=null;
	}
}
function inhandler(e) {
	if (!e) {e = window.event;}
	//websys_cancel();
	var inObj=websys_getSrcElement(e);
	//remove previous lu_obj reference
	//if (lu_obj) {lu_obj=null;}
	var inrow=0;
	var eRow=tk_getRow(inObj);
	if ((eRow)&&(eRow.tagName=="TR")) {inrow=(1+eRow.sectionRowIndex);} else {inrow=0;}
	G_idxRowIn=inrow;
	//if ((G_idxRowIn)&&(!websys_canfocus(inObj))) {G_idxRowIn=0;}

}

function tk_getRow(obj) {
	var objrow=obj;
	while((objrow)&&(objrow.tagName != "TR")) {objrow=websys_getParentElement(objrow);}
	return objrow;
}
function updaterowhandler() {
	if ((document.getElementById('ChangeFlagz'+idxRowEdited)) && (document.getElementById('ChangeFlagz'+idxRowEdited).value!="") && (oktosubmitrow(idxRowEdited))) {
		var id=document.getElementById('IDz'+idxRowEdited).value;
		if (document.getElementById('Dosagez'+idxRowEdited)) {var Dosage=document.getElementById('Dosagez'+idxRowEdited).value;} else {var Dosage="_zz";}
		if (document.getElementById('Durationz'+idxRowEdited)) {var Duration=document.getElementById('Durationz'+idxRowEdited).value;} else {var Duration="_zz";}
		if (document.getElementById('Frequencyz'+idxRowEdited)) {var Frequency=document.getElementById('Frequencyz'+idxRowEdited).value;} else {var Frequency="_zz";}
		if (document.getElementById('Priorityz'+idxRowEdited)) {var Priority=document.getElementById('Priorityz'+idxRowEdited).value;} else {var Priority="_zz";}
		if (document.getElementById('Instrucz'+idxRowEdited)) {var Instruc=document.getElementById('Instrucz'+idxRowEdited).value;} else {var Instruc="_zz";}
		if (document.getElementById('AdminRtz'+idxRowEdited)) {var AdminRt=document.getElementById('AdminRtz'+idxRowEdited).value;} else {var AdminRt="_zz";}
		if (document.getElementById('Qty1z'+idxRowEdited)) {var Qty1=document.getElementById('Qty1z'+idxRowEdited).value;} else {var Qty1="_zz";}
		if (document.getElementById('IVVolumez'+idxRowEdited)) {var IVVolume=document.getElementById('IVVolumez'+idxRowEdited).value;} else {var IVVolume="_zz";}
		if (document.getElementById('IVVolUnitz'+idxRowEdited)) {var IVVolUnit=document.getElementById('IVVolUnitz'+idxRowEdited).value;} else {var IVVolUnit="_zz";}
		if (document.getElementById('IVTimez'+idxRowEdited)) {var IVTime=document.getElementById('IVTimez'+idxRowEdited).value;} else {var IVTime="_zz";}
		if (document.getElementById('IVTimeUnitz'+idxRowEdited)) {var IVTimeUnit=document.getElementById('IVTimeUnitz'+idxRowEdited).value;} else {var IVTimeUnit="_zz";}
		if (document.getElementById('FreqDelayz'+idxRowEdited)) {var FreqDelay=document.getElementById('FreqDelayz'+idxRowEdited).value;} else {var FreqDelay="_zz";}
		if (document.getElementById('IVExpDurz'+idxRowEdited)) {var IVExpDur=document.getElementById('IVExpDurz'+idxRowEdited).value;} else {var IVExpDur="_zz";}
		//Log 62219 PeterC 31/01/07
		var Max="";
		var Expiry="";
		var Days="";
		var MaxRpts="";
		if (document.getElementById('MaxRptsz'+idxRowEdited)) {var Max=document.getElementById('MaxRptsz'+idxRowEdited).value;}
		if (document.getElementById('OEORIPrescRepExpiryDatez'+idxRowEdited)) {var Expiry=document.getElementById('OEORIPrescRepExpiryDatez'+idxRowEdited).value;}
		if (document.getElementById('OEORIPrescRepNumberDaysz'+idxRowEdited)) {var Days=document.getElementById('OEORIPrescRepNumberDaysz'+idxRowEdited).value;}
		if((Max!="")||(Expiry!="")||(Days!="")) MaxRpts=Max+"^"+Expiry+"^"+Days;
		else {MaxRpts="_zz";}
		//Log 60951 BoC
		var IVtypeCode=""
		var IVtypeCodeObj=document.getElementById("IVTypez"+idxRowEdited);
		if (IVtypeCodeObj) IVtypeCode=IVtypeCodeObj.value
		
		var serverupdate=tkMakeServerCall("web.OEOrder","UpdateListRowHandler",id,Dosage,Duration,Frequency,Priority,Instruc,AdminRt,Qty1,IVVolume,IVVolUnit,IVTime,IVTimeUnit,FreqDelay,IVExpDur,MaxRpts,IVtypeCode);
		if (serverupdate!=0) { alert(t['NOCOMMIT'] + " " + document.getElementById('OEITMNamez'+idxRowEdited).value + "\n" + t['NOSTOCK'] + "\n" + serverupdate );}
	}
	// after commit change (or warning) - reset flags
	if (document.getElementById('ChangeFlagz'+idxRowEdited)) document.getElementById('ChangeFlagz'+idxRowEdited).value="";
	idxRowEdited=0;
	return;
}

function oktosubmitrow(idxRowEdited) {
	var id,Priority,oktosave="";
	oktosave=true;
	var id=document.getElementById('IDz'+idxRowEdited).value;
	if (document.getElementById('Priorityz'+idxRowEdited)) Priority=document.getElementById('Priorityz'+idxRowEdited).value;
	if (id!="" && Priority!="") {
		if (document.getElementById('Durationz'+idxRowEdited)) {var Duration=document.getElementById('Durationz'+idxRowEdited).value;} else {var Duration="_zz";}
		if (document.getElementById('Frequencyz'+idxRowEdited)) {var Frequency=document.getElementById('Frequencyz'+idxRowEdited).value;} else {var Frequency="_zz";}
		if (document.getElementById('typez'+idxRowEdited)) {var type=document.getElementById('typez'+idxRowEdited).value;} else {var type="_zz";}
		if (type=="R") {
			if (document.getElementById('Dosagez'+idxRowEdited)) {var Dosage=document.getElementById('Dosagez'+idxRowEdited).value;} else {var Dosage="_zz";}
			if (document.getElementById('Instrucz'+idxRowEdited)) {var Instruc=document.getElementById('Instrucz'+idxRowEdited).value;} else {var Instruc="_zz";}
			if (document.getElementById('AdminRtz'+idxRowEdited)) {var AdminRt=document.getElementById('AdminRtz'+idxRowEdited).value;} else {var AdminRt="_zz";}
			if (document.getElementById('Qty1z'+idxRowEdited)) {var Qty1=document.getElementById('Qty1z'+idxRowEdited).value;} else {var Qty1="_zz";}
			// fields instructions and admin route aren't really compulsary
			if ((Dosage=="")||(Duration=="")||(Frequency=="")||(Qty1=="")||(Qty1=="NaN")) oktosave=false;
		} else if (type=="I") {
			var IVType=document.getElementById("IVTypez"+idxRowEdited);
			if (IVType) { IVType=IVType.value; } else { IVType=""; }
			if (document.getElementById('IVVolumez'+idxRowEdited)) {var IVVolume=document.getElementById('IVVolumez'+idxRowEdited).value;} else {var IVVolume="_zz";}
			if (document.getElementById('IVVolUnitz'+idxRowEdited)) {var IVVolUnit=document.getElementById('IVVolUnitz'+idxRowEdited).value;} else {var IVVolUnit="_zz";}
			if (document.getElementById('IVTimez'+idxRowEdited)) {var IVTime=document.getElementById('IVTimez'+idxRowEdited).value;} else {var IVTime="_zz";}
			if (document.getElementById('IVTimeUnitz'+idxRowEdited)) {var IVTimeUnit=document.getElementById('IVTimeUnitz'+idxRowEdited).value;} else {var IVTimeUnit="_zz";}
			if (document.getElementById('Frequencyz'+idxRowEdited) && (document.getElementById('Frequencyz'+idxRowEdited).disabled=false) && (Frequency=="")) oktosave=false;
			if (((IVType=="C")||(IVType=="M"))&&((IVVolume=="")||(IVVolUnit=="")||(IVTime=="")||(IVTimeUnit==""))) oktosave=false;
			if ((IVType=="P")&&((Duration=="")||(Frequency==""))) oktosave=false;
			if ((IVType=="C")&&(Duration=="")) oktosave=false;
		}
	} else { oktosave = false; }

	if (!oktosave) {
		alert(t['NOCOMMIT']+ " " + document.getElementById('OEITMNamez'+idxRowEdited).value + "\n" +t['MANDATORY']);
		return oktosave;
	}

	if (oktosave && (type=="R")&&(document.getElementById("PriorityCodez"+idxRowEdited)) && (document.getElementById("PriorityCodez"+idxRowEdited).value=="PRN")) {
		var dayoverride=0
		var df=document.getElementById("DurFactorz"+idxRowEdited);
		if (df) df=df.value;
		if (df && (df!="")){
			var NoCumDay=document.getElementById("NoCumDayz"+idxRowEdited); 
			if ((NoCumDay.value!="") && (parseInt(df)>parseInt(NoCumDay.value))) {
				var checkday=confirm(t['NODAYEXCEED']+"\n"+t['CONTINUE']);
				if (!checkday) { oktosave=false; websys_setfocus("Durationz"+idxRowEdited);}
			}
		}
		var PRNhrs,gap,freq="";
		var frqf=document.getElementById("FreqFactorz"+idxRowEdited);
		if (frqf) freq=frqf.value;
		if (oktosave && freq && (freq!="")) {
			gap=24/freq;
			var PRNhrsobj=document.getElementById("PRNMinTimez"+idxRowEdited);
			if (PRNhrsobj) PRNhrs=PRNhrsobj.value;
			if (PRNhrs!="" && (gap<PRNhrs)) {
				var checkhrs=confirm(t['PRNHrs']+"\n"+t['CONTINUE']);
				if (!checkhrs) { oktosave=false; websys_setfocus("Frequencyz"+idxRowEdited);}
			}
		}
	}
	// Validate repeats - 59969
	if (document.getElementById('MaxRptsz'+idxRowEdited)) {var MaxRpts=document.getElementById('MaxRptsz'+idxRowEdited).value;} else {var MaxRpts="_zz";}
	if (document.getElementById('PBSRpts1z'+idxRowEdited)) {var PBSRpts1=document.getElementById('PBSRpts1z'+idxRowEdited).value;} else {var PBSRpts1="_zz";}
	if ((MaxRpts!="")&&(!isNaN(MaxRpts))&&(PBSRpts1!="")) {
		if (MaxRpts>PBSRpts1) {
			var rpts=confirm(t['Rpts']+"\n"+t['CONTINUE']);
			if (!rpts) { oktosave=false; websys_setfocus("MaxRptsz"+idxRowEdited);}
		}
	}
	////
	return oktosave;
}

function hideel(el){
	var obj=document.getElementById(el);
	if (obj) obj.style.visibility="hidden";
	var luobj=document.getElementById("lt2183i"+el);
	if (luobj) luobj.style.visibility="hidden";

}

function BodyLoadHandler() {

/*************************************************************************************\
*	Please have a think about what you force into the sessionlist component	      *
*		The frame is refreshed constantly so keep as much of the	      *
*		functionality as possible on the OEOrder.Custom and 		      *
*		oeorder.updateorders.csp submit!				      *
\*************************************************************************************/

	tbl=document.getElementById('tOEOrder_SessionList');
	if (tbl) {
		//log  64353
		//tbl.onfocusin=inhandler;
		tbl.onfocusout=outhandler;
		for (var i=1;i<tbl.rows.length;i++) {
			// Get a delete handler that works in conjunction with function DeleteItemIDs(NewOrders) from custom
			var DeleteObj=document.getElementById("Deletez"+i);
			if (DeleteObj) DeleteObj.onclick = DeleteHandler;
			var VariableDoseObj=document.getElementById("VariableDosez"+i);
			if (VariableDoseObj) VariableDoseObj.onclick = VariableDoseHandler;
			//log 61690 BoC 30-11-2006 add dose click handler
			var DosingObj=document.getElementById("Dosingz"+i);
			if (DosingObj) DosingObj.onclick = DosingHandler;
			if ((document.getElementById("PriorityCodez"+i)) && (document.getElementById("PriorityCodez"+i).value=="STAT")) {
				DisableListEl("Frequencyz"+i);
				DisableListEl("Durationz"+i);
			}
			var type=document.getElementById("typez"+i);
			var MaxRptsObj=document.getElementById("MaxRptsz"+i);
			if (MaxRptsObj) {
				MaxRptsObj.onchange = MaxRptsHandler;	
			}
			//log 61044 Tedt
			var qtyobj=document.getElementById("Qtyz"+i);
			if(qtyobj) qtyobj.onchange=QtyChangeHandler;
			
			var freqdelay=document.getElementById("FreqMinsz"+i);
			if (type && type.value!=""){
				if ((type.value!="I")&&(type.value!="R")) {
				// have to hide fields that do not relate to order type
					hideel("Dosagez"+i);
					hideel("Unitz"+i);
					hideel("Durationz"+i);
					hideel("Frequencyz"+i);
					hideel("Instrucz"+i);
					hideel("AdminRtz"+i);
					hideel("IVVolumez"+i);
					hideel("IVVolUnitz"+i);
					hideel("IVTimez"+i);
					hideel("IVTimeUnitz"+i);
					hideel("VariableDosez"+i);
					hideel("MaxRptsz"+i);
					hideel("CalcQty2z"+i);
					hideel("TotVolumez"+i);
					hideel("OEORIPrescRepNumberDaysz"+i);
					hideel("Dosingz"+i);
					hideel("OEORIPrescRepExpiryDatez"+i);
				} else if (type.value=="R"){
					hideel("IVVolumez"+i);
					hideel("IVVolUnitz"+i);
					hideel("IVTimez"+i);
					hideel("IVTimeUnitz"+i);
					hideel("TotVolumez"+i);
					if (freqdelay && (freqdelay.value!="")) {
						hideel("CalcQty2z"+i);
						hideel("Durationz"+i);
						hideel("Frequencyz"+i);
						DisableListEl("Dosagez"+i)
						DisableListEl("Qtyz"+i)
					} else {
						var calcqty=document.getElementById("calcqtyz"+i);
						var CalcQty2Obj=document.getElementById("CalcQty2z"+i);
						var QtyObj=document.getElementById("Qtyz"+i);
						if (CalcQty2Obj && QtyObj) {
							if (CheckQuantity(i)!=QtyObj.value) { 
								CalcQty2Obj.checked=false;
								QtyObj.disabled=false;
							} else {
								CalcQty2Obj.checked=true;
								QtyObj.disabled=true;
							}
							CalcQty2Obj.onclick=CalcQtyFlagHandler;
						} else if ((!CalcQty2Obj) && QtyObj && calcqty && calcqty.value=="Y") {
							QtyObj.disabled=true;
						}
						var DoseQtyObj=document.getElementById("Dosagez"+i);
						if (DoseQtyObj) {
							if (curydecimalsym!=".") {  
								var arrTemp = DoseQtyObj.value.split('.'); 
								DoseQtyObj.value=arrTemp.join(curydecimalsym);
							}
							DoseQtyObj.onchange = DoseQtyChangeHandler;	
						}	
					}
				} else if (type.value=="I"){
					var VolObj=document.getElementById("IVVolumez"+i);
					if (VolObj) VolObj.onchange = IVVolChangeHandler;
					var TimeObj=document.getElementById("IVTimez"+i);
					if (TimeObj) TimeObj.onchange = IVTimeChangeHandler;
					//log60844 TedT
					var calcqty=document.getElementById("calcqtyz"+i);
					var QtyObj=document.getElementById("Qtyz"+i);
					if(calcqty && QtyObj && calcqty.value=="Y") QtyObj.disabled=true;
					var freq=document.getElementById("Frequencyz"+i);
					if(freq) freq.onblur=FrequencyOnblur;
					var dur=document.getElementById("Durationz"+i);
					if(dur) dur.onblur=DurationOnblur;
					hideel("Dosagez"+i);
					hideel("Unitz"+i);
					//hideel("AdminRtz"+i); //admin route field added to IV - 59679
					hideel("Instrucz"+i);
					hideel("VariableDosez"+i);
					hideel("CalcQty2z"+i);
					hideel("Dosingz"+i);
					var IVType=document.getElementById("IVTypez"+i);
					if (IVType && (IVType.value!="")) {
						IVType=IVType.value;
						if (IVType=="C"){
							DisableListEl("Frequencyz"+i);
						} else if (IVType=="P"){
							DisableListEl("IVTimez"+i);
							DisableListEl("IVTimeUnitz"+i);
						}
					}
				}
			}
		}
	}
	//log  64353
	/*
	// 62612
	var ordwin = window.open("","oeorder_entry");
	var obj=ordwin.document.getElementById('Item');
	if (obj) {
		try {
			obj.focus();
			obj.select();
		} catch(e) {}
	}*/	
	return;
}

//log  64353 focus the field and popup screens, always add the top level popup screen to the last of the code.
function setFocus(){
	var ordwin = window.open("","oeorder_entry");
	if (ordwin){
		var obj=ordwin.document.getElementById('Item');
		if (obj) {
			try {
				obj.focus();
				obj.select();
			} catch(e) {}
		}
		var OrdExeWin=ordwin.OrdExeWin;
		var OrdDetailsWin=ordwin.OrdDetailsWin;
		var winAlertScreen=ordwin.winAlertScreen;
		//alert ("Bo Testing \n"+ordwin+"\n"+OrdExeWin+"\n"+OrdDetailsWin);
		if (OrdExeWin){
				try{
					OrdExeWin.focus();
				}
				catch (e){}
		}
		if (OrdDetailsWin){
				try{
					OrdDetailsWin.focus();
				}
				catch (e){}
		}
		if (winAlertScreen){
				try{
					winAlertScreen.focus();
				}
				catch (e){}
		}
	}
}

function DisableListEl(el){
	var Obj=document.getElementById(el);
	var lObj=document.getElementById("lt2183i"+el);
	if (Obj) Obj.disabled=true;
	if (lObj) lObj.disabled=true;
	// added because lObj.disabled didn't stop lookup!?
	if (lObj) lObj.style.visibility="hidden";
	return;
}

function EnableListEl(el){
	var Obj=document.getElementById(el);
	var lObj=document.getElementById("lt2183i"+el);
	if (Obj) Obj.disabled=false;
	if (lObj) lObj.disabled=false;
	if (lObj) lObj.style.visibility="";
	return;
}

function PriorityLookUpSelect(str){
	var rowidx=lu_obj.id.replace('Priorityz','');
	var lu = str.split("^");
	
	var type=document.getElementById("typez"+rowidx);
	if (type && ((type.value=="R")||(type.value=="I"))) {	
		EnableListEl("Frequencyz"+rowidx);
		EnableListEl("Durationz"+rowidx);

		if (lu[1]=="STAT") {
			var STATdur=document.getElementById("OneDayDuration");
			var STATfreq=document.getElementById("OnceDailyFreq");
			var dur=document.getElementById("Durationz"+rowidx);
			var freq=document.getElementById("Frequencyz"+rowidx);

			if (dur && STATdur) dur.value=STATdur.value;
			if (freq && STATfreq) freq.value=STATfreq.value;

			var calcqty=document.getElementById("calcqtyz"+rowidx);
			if (calcqty && calcqty.value=="Y") {
				var Dqty=document.getElementById("Dosagez"+rowidx);
				var qty=document.getElementById("Qtyz"+rowidx);
				if (Dqty && Dqty.value!="" && qty) qty.value=Dqty.value;
				var objQty1=document.getElementById("Qty1z"+rowidx);
				if (Dqty && Dqty.value!="" && objQty1) objQty1.value=Dqty.value;
				var obj=document.getElementById("DurFactorz"+rowidx);
				if (obj) obj.value=1;
				var obj=document.getElementById("FreqFactorz"+rowidx);
				if (obj) obj.value=1;
				var obj=document.getElementById("FreqDayz"+rowidx);
				if (obj) obj.value=1;
			}

			DisableListEl("Frequencyz"+rowidx);
			DisableListEl("Durationz"+rowidx);
		}
	}

	var code=document.getElementById("PriorityCodez"+rowidx);
	if (code) code.value=lu[1];

	if (document.getElementById('ChangeFlagz'+rowidx)) document.getElementById('ChangeFlagz'+rowidx).value=1;

	return;
}
function FrequencyLookUpSelect(str) {
	var rowidx=lu_obj.id.replace('Frequencyz','');
	var lu = str.split("^");
	var obj=document.getElementById("Frequencyz"+rowidx);
	if (obj) obj.value = lu[0];
	var freq = lu[2];
	if (freq=="") freq=0;
	var frqf=document.getElementById("FreqFactorz"+rowidx);
	if (frqf) frqf.value = freq;
	var iobj=document.getElementById("FreqDayz"+rowidx);
	if (iobj) iobj.value= lu[3];
	SetQuantity(rowidx);
	return;
}
function DurationLookUpSelect(str) {
	var rowidx=lu_obj.id.replace('Durationz','');
	var lu = str.split("^");
	var obj=document.getElementById("Durationz"+rowidx);
	if (obj) obj.value = lu[0];
	var dur = lu[2];
	if (dur=="") dur=0;
	var dfobj=document.getElementById("DurFactorz"+rowidx);
	if (dfobj) dfobj.value=dur;	
	SetQuantity(rowidx);
	return;
}
function AdmRtChange(str){
	var txt=str.split("^");
	var rowidx=lu_obj.id.replace('AdminRtz','');
	if (document.getElementById('ChangeFlagz'+rowidx)) document.getElementById('ChangeFlagz'+rowidx).value=1;
	//Log 60951 BoC
	var IVtypeCodeObj=document.getElementById("IVTypez"+rowidx);
	EnableListEl("Frequencyz"+rowidx);
	EnableListEl("IVTimez"+rowidx);
	EnableListEl("IVTimeUnitz"+rowidx);
	if (IVtypeCodeObj) {
		IVtypeCodeObj.value=txt[4];
		if (IVtypeCodeObj.value=="C") {
			var PHCFRObj=document.getElementById("Frequencyz"+rowidx);
			if (PHCFRObj) {
				PHCFRObj.value="";
				PHCFRObj.disabled=true;
			}
			DisableListEl("Frequencyz"+rowidx);	
			var FFObj=document.getElementById("FreqFactorz"+rowidx);
			if (FFObj) FFObj.value="";
			SetQuantity(rowidx);
		}
		if (IVtypeCodeObj.value=="P") {
			var FlowTimeObj=document.getElementById("IVTimez"+rowidx);
			if (FlowTimeObj) FlowTimeObj.value="";
			DisableListEl("IVTimez"+rowidx);
			var FlowTimeUnitObj=document.getElementById("IVTimeUnitz"+rowidx);
			if (FlowTimeUnitObj) FlowTimeUnitObj.value="";
			DisableListEl("IVTimeUnitz"+rowidx);
		}
		SetQuantity(rowidx);
	}

	return;
}
function IVVolUnitLookUp(str){
	var rowidx=lu_obj.id.replace('IVVolUnitz','');
	var lu=str.split("^");
	var qobj=document.getElementById("IVVolUnit1z"+rowidx);
	if (qobj) {
		if (lu[1]=="l") { qobj.value=1000;
		} else { qobj.value=1; }
	}
	SetQuantity(rowidx);
	return;
}
function IVTimeUnitLookUp(str){
	var rowidx=lu_obj.id.replace('IVTimeUnitz','');
	var lu=str.split("^");
	var htobj=document.getElementById("IVTimeUnit1z"+rowidx);
	if (htobj) {
		if (lu[2]=="hrs") { htobj.value=1;
		} else { htobj.value=1/60; }
	}
	SetQuantity(rowidx);
	return;
}
function IVVolChangeHandler(e) {
	if (!e) {var e = window.event;}
	if (e.target) {outObj = e.target;} else if (e.srcElement) {outObj = e.srcElement;}
	outRow=tk_getRow(outObj);
	rowidx=outRow.sectionRowIndex+1;
	SetQuantity(rowidx);
	return;
}
function IVTimeChangeHandler(e) {
	if (!e) {var e = window.event;}
	if (e.target) {outObj = e.target;} else if (e.srcElement) {outObj = e.srcElement;}
	outRow=tk_getRow(outObj);
	rowidx=outRow.sectionRowIndex+1;

	var IVType="";
	var TimeUnit="";
	var IVType=document.getElementById("IVTypez"+rowidx);
	var IVTimeUnit=document.getElementById("IVTimeUnitz"+rowidx);
	
	if (IVType && (IVType.value!="")) {
		IVType=IVType.value;
	}
	if (IVTimeUnit && (IVTimeUnit.value!="")) {
		TimeUnit=IVTimeUnit.value;
	}
	if(((IVType=="C")&&(TimeUnit!=""))||(IVType!="C")) SetQuantity(rowidx);
	return;
}

function VariableDoseHandler(e){
	if (!e) {var e = window.event;}
	if (e.target) {outObj = e.target;} else if (e.srcElement) {outObj = e.srcElement;}
	outRow=tk_getRow(outObj);
	rowidx=outRow.sectionRowIndex+1;
	if (rowidx!=""){
		var Frequency="";
		var Duration="";
		var ID="";
		var OEORISttDat="";
		var Quantity="";
		var CTUOMDesc="";
		var OEORISttTim="";

		var VFObj=document.getElementById("Frequencyz" + rowidx);
		if ((VFObj)&&(VFObj.value!="")) Frequency=VFObj.value;
		var VDObj=document.getElementById("Durationz" + rowidx);
		if ((VDObj)&&(VDObj.value!="")) Duration=VDObj.value;
		var IDObj=document.getElementById("IDz" + rowidx);
		if ((IDObj)&&(IDObj.value!="")) ID=IDObj.value;
		var STDObj=document.getElementById("SttDatez" + rowidx);
		if ((STDObj)&&(STDObj.value!="")) OEORISttDat=STDObj.innerText;
		var STTObj=document.getElementById("SttTimez" + rowidx);
		if ((STTObj)&&(STTObj.value!="")) OEORISttTim=STTObj.innerText;
		var QObj=document.getElementById("Dosagez" + rowidx);
		if ((QObj)&&(QObj.value!="")) Quantity=QObj.value;
		var CUObj=document.getElementById("Unitz" + rowidx);
		if ((CUObj)&&(CUObj.value!="")) CTUOMDesc=CUObj.innerText;

		
		if((ID=="")||(Frequency=="")||(Duration=="")||(OEORISttDat=="")||(Quantity=="")||(CTUOMDesc=="")) {
			alert(t['VariableFields']);
			return false;
		}

		var url = "oeorder.variableorderdays.csp?Frequency="+Frequency+"&Duration="+Duration+"&ID="+ID+"&OEORISttDat="+OEORISttDat+"&Quantity="+Quantity+"&CTUOMDesc="+CTUOMDesc+"&OEORISttTim="+OEORISttTim;
                //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
		websys_createWindow(url,"","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
	}
}
function DeleteHandler(e){
	if (!e) {var e = window.event;}
	if (e.target) {outObj = e.target;} else if (e.srcElement) {outObj = e.srcElement;}
	outRow=tk_getRow(outObj);
	rowidx=outRow.sectionRowIndex+1;

	if (rowidx!=""){
		if (document.getElementById('IDz'+rowidx) && document.getElementById('arcimz'+rowidx) && document.getElementById('IDz'+rowidx).value!="" && document.getElementById('arcimz'+rowidx).value!="") {
			//var deletestring=document.getElementById('arcimz'+rowidx).value+"*"+document.getElementById('IDz'+rowidx).value+"*V^";
			var deletestring=document.getElementById('IDz'+rowidx).value+"^";
			var ok=tkMakeServerCall("web.OEOrder","CheckDeletes",deletestring);
			if (ok==0) {
				alert(t['NODELETE']);
			}
			if (ok!=0) {
				try {
					var detailFrame=window.open("","oeorder_entry");
					if (detailFrame) detailFrame.DeleteItemIDs(deletestring);
				} catch(e) {}
			}
		}
	}
}
function DoseQtyChangeHandler(e) {
	if (!e) {var e = window.event;}
	if (e.target) {outObj = e.target;} else if (e.srcElement) {outObj = e.srcElement;}
	outRow=tk_getRow(outObj);
	rowidx=outRow.sectionRowIndex+1;

	if (rowidx!="") {
		var dqobj=document.getElementById("OEORIDoseQty"+rowidx);
		if(dqobj) {
			if((dqobj)&&isNaN(dqobj.value)) {
				dqobj.className='clsInvalid';
				return false;
			} else { dqobj.className=''; }
	
		}
		SetQuantity(rowidx);
	}
	return;
}
//// 59969
function MaxRptsHandler(e) {
	if (!e) {var e = window.event;}
	if (e.target) {outObj = e.target;} else if (e.srcElement) {outObj = e.srcElement;}
	outRow=tk_getRow(outObj);
	rowidx=outRow.sectionRowIndex+1;

	if (rowidx!="") {
		if (document.getElementById('ChangeFlagz'+rowidx)) document.getElementById('ChangeFlagz'+rowidx).value=1;
	}
	return;
}
function CalcQtyFlagHandler(e) {
	if (!e) {var e = window.event;}
	if (e.target) {outObj = e.target;} else if (e.srcElement) {outObj = e.srcElement;}
	outRow=tk_getRow(outObj);
	rowidx=outRow.sectionRowIndex+1;

	if (rowidx!="") {
		var CalcQtyFlag2=document.getElementById("CalcQty2z"+rowidx);
		var objQty=document.getElementById("Qtyz"+rowidx);
		if (CalcQtyFlag2.checked) {
			if (objQty) objQty.disabled=true;
			if (objQty) SetQuantity(rowidx);
		} else {
			if (objQty) objQty.disabled=false;
		}		
	}
	return;
}
function CheckQuantity(rowidx){
	var type=document.getElementById("typez"+rowidx);
	var calcqty=document.getElementById("calcqtyz"+rowidx);
	if (calcqty && calcqty.value!="Y") return "_zz";

	if (type && type.value=="R") {
		var QtyRtn="";
		var pricode=document.getElementById("PriorityCodez"+rowidx);
		var objDoseQty=document.getElementById("Dosagez"+rowidx);
		var rdobj=document.getElementById("ConfigRoundDose");

		var freq,RoundUpNum=""
		var dfobj=document.getElementById("DurFactorz"+rowidx);
		var frqf=document.getElementById("FreqFactorz"+rowidx);
		var iobj=document.getElementById("FreqDayz"+rowidx);
		var pdobj=document.getElementById("PartialDeductz"+rowidx);
		if (frqf) freq=frqf.value
		if (dfobj) dur=dfobj.value;

		if (iobj) {
			var Interval=iobj.value;
			if ((Interval!="") && (Interval!=null)) {
				var convert=Number(dur)/Number(Interval)
				var fact=(Number(dur))%(Number(Interval));
				if (fact>0) {
					fact=1;
				} else {
					fact=0;
				}
				dur=Math.floor(convert)+fact;
			}	
		}

		if ((rdobj)&&(objDoseQty)) {
			var valDoseQty=objDoseQty.value;
			if (curydecimalsym!=".") {  
				var arrTemp = valDoseQty.split(curydecimalsym); 
				valDoseQty=arrTemp.join('.');
				var arrTemp = objDoseQty.value.split('.'); 
				objDoseQty.value=arrTemp.join(curydecimalsym);
			}
			if ((rdobj.value=="Y")&&((pdobj)&&(pdobj.value=="N"))) {
				RoundUpNum=Math.ceil(valDoseQty);
			}
		}

		if ((objDoseQty)&&(objDoseQty.value!="NaN")) {
			var valDoseQty=RoundUpNum;
			if (valDoseQty=="") valDoseQty=objDoseQty.value;
			if (curydecimalsym!=".") {  
				if (valDoseQty.split) {
					var arrTemp=valDoseQty.split(curydecimalsym);
					valDoseQty=arrTemp.join('.');
				}
			} 
			valDoseQty=valDoseQty+"";
			valDoseQty=valDoseQty.replace(",","")
			QtyRtn = parseFloat(valDoseQty) * parseFloat(freq) * parseFloat(dur);
			QtyRtn = Math.round(QtyRtn*100000000)/100000000

			if ((rdobj)&&(rdobj.value=="N")) {
				if ((pdobj)&&(pdobj.value=="N")) {
					QtyRtn=Math.round(QtyRtn);
				}
			}
		} else {
			if (QtyRtn=="") QtyRtn="0";
			if ((QtyRtn) && (objDoseQty.value=="NaN")) QtyRtn="NaN";
		}
		if (curydecimalsym!=".") {  
			//var arrTemp = QtyRtn.split('.'); 
			//QtyRtn=arrTemp.join(curydecimalsym);
		}

		if (objDoseQty) objDoseQty.value=String(objDoseQty.value);
	} 
	return QtyRtn;
}

//log 61044 TedT
function QtyChangeHandler(e) {
	if (!e) {var e = window.event;}
	if (e.target) {outObj = e.target;} else if (e.srcElement) {outObj = e.srcElement;}
	outRow=tk_getRow(outObj);
	rowidx=outRow.sectionRowIndex+1;

	if (rowidx!="") {
		var qty1=document.getElementById("Qty1z"+rowidx);
		if (qty1) qty1.value=this.value;
		var flag=document.getElementById('ChangeFlagz'+rowidx);
		if(flag) flag.value=1;
	}
	return;
}

//60844 TedT 
function FrequencyOnblur() {
	if(this.value==""){
		var rowidx=this.id.substr(this.id.lastIndexOf("z")+1);
		var frqf=document.getElementById("FreqFactorz"+rowidx);
		if(frqf) frqf.value=0;
		SetQuantity(rowidx);
	}
}

function DurationOnblur() {
	if(this.value==""){
		var rowidx=this.id.substr(this.id.lastIndexOf("z")+1);
		var dur=document.getElementById("DurFactorz"+rowidx);
		if(dur) dur.value=0;
		SetQuantity(rowidx);
	}
}

function SetQuantity(rowidx){
	if (document.getElementById('ChangeFlagz'+rowidx)) document.getElementById('ChangeFlagz'+rowidx).value=1;

	var type=document.getElementById("typez"+rowidx);
	var calcqty=document.getElementById("calcqtyz"+rowidx);
	
	if (type && type.value=="R") {
		// 59969 - manual override for calculate qty
		var CalcQty2=document.getElementById("CalcQty2z"+rowidx);
		if (CalcQty2 && !CalcQty2.checked) return;
		if (!CalcQty2 && calcqty && calcqty.value!="Y") return;
		
		var objQty1=document.getElementById("Qty1z"+rowidx);
		var pricode=document.getElementById("PriorityCodez"+rowidx);
		var objDoseQty=document.getElementById("Dosagez"+rowidx);
		var objQty=document.getElementById("Qtyz"+rowidx);
		var rdobj=document.getElementById("ConfigRoundDose");

		if (pricode && pricode.value=="STAT") {
			if (objDoseQty && objDoseQty.value!="" && objQty) objQty.value=objDoseQty.value;
			if (objDoseQty && objDoseQty.value!="" && objQty1) objQty1.value=objDoseQty.value;
			return;
		}

		var freq,RoundUpNum=""
		var dfobj=document.getElementById("DurFactorz"+rowidx);
		var frqf=document.getElementById("FreqFactorz"+rowidx);
		var iobj=document.getElementById("FreqDayz"+rowidx);
		var pdobj=document.getElementById("PartialDeductz"+rowidx);
		if (frqf) freq=frqf.value
		if (dfobj) dur=dfobj.value;

		if (iobj) {
			var Interval=iobj.value;
			if ((Interval!="") && (Interval!=null)) {
				var convert=Number(dur)/Number(Interval)
				var fact=(Number(dur))%(Number(Interval));
				if (fact>0) {
					fact=1;
				} else {
					fact=0;
				}
				dur=Math.floor(convert)+fact;
			}	
		}

		if ((rdobj)&&(objDoseQty)) {
			var valDoseQty=objDoseQty.value;
			if (curydecimalsym!=".") {  
				var arrTemp = valDoseQty.split(curydecimalsym); 
				valDoseQty=arrTemp.join('.');
				var arrTemp = objDoseQty.value.split('.'); 
				objDoseQty.value=arrTemp.join(curydecimalsym);
			}
			if ((rdobj.value=="Y")&&((pdobj)&&(pdobj.value=="N"))) {
				RoundUpNum=Math.ceil(valDoseQty);
			}
		}

		if ((objQty)&&(objDoseQty)&&(objDoseQty.value!="NaN")) {
			var valDoseQty=RoundUpNum;
			if (valDoseQty=="") valDoseQty=objDoseQty.value;
			if (curydecimalsym!=".") {  
				if (valDoseQty.split) {
					var arrTemp=valDoseQty.split(curydecimalsym);
					valDoseQty=arrTemp.join('.');
				}
			} 
			valDoseQty=valDoseQty+"";
			valDoseQty=valDoseQty.replace(",","")
			objQty.value = parseFloat(valDoseQty) * parseFloat(freq) * parseFloat(dur);
			objQty.value = Math.round(objQty.value*100000000)/100000000

			if ((rdobj)&&(rdobj.value=="N")) {
				if ((pdobj)&&(pdobj.value=="N")) {
					objQty.value=Math.round(objQty.value);
				}
			}
		} else {
			if ((objQty) && (objQty.value) && (objQty.value=="")) objQty.value="0";
			if ((objQty) && (objDoseQty.value=="NaN")) objQty.value="NaN";
		}
		if (curydecimalsym!="." && objQty) {  
			var arrTemp = objQty.value.split('.'); 
			objQty.value=arrTemp.join(curydecimalsym);
		}

		if (objDoseQty) objDoseQty.value=String(objDoseQty.value);

		if (objQty && objQty1) objQty1.value=objQty.value;

	} else if (type && type.value=="I") {
		var IVType=document.getElementById("IVTypez"+rowidx);

		var dfobj=document.getElementById("DurFactorz"+rowidx);
		var volobj=document.getElementById("IVVolumez"+rowidx);
		var voluobj=document.getElementById("IVVolUnit1z"+rowidx);
		var timeobj=document.getElementById("IVTimez"+rowidx);
		var timeuobj=document.getElementById("IVTimeUnit1z"+rowidx);
		var totvolobj=document.getElementById("HiddenTotVolz"+rowidx);
		var pdobj=document.getElementById("PartialDeductz"+rowidx);
		var fdobj=document.getElementById("FreqDelayz"+rowidx);
		var ieobj=document.getElementById("IVExpiryz"+rowidx);
		//log60844 TedT
		var FreqFac=document.getElementById("FreqFactorz"+rowidx);
		var objQty1=document.getElementById("Qty1z"+rowidx);
		var objQty=document.getElementById("Qtyz"+rowidx);
		var objIVDF=document.getElementById("IVDoseFactorz"+rowidx);

		var Volume,VolUnit,Time,TimeUnit,Rate,DurFac,Quantity,PartialDeduct,TotVolume,IVExpiry,IVExpDur="";
		//Log 61232 PeterC 15/02/07
		var IVDoseFactor=1;

		if (dfobj) DurFac=dfobj.value;
		if (volobj) Volume=volobj.value;
		if (voluobj) VolUnit=voluobj.value;
		if (timeobj) Time=timeobj.value;
		if (timeuobj) TimeUnit=timeuobj.value;
		if (pdobj) PartialDeduct=pdobj.value;
		if (totvolobj) TotVolume=totvolobj.value;
		if (ieobj) IVExpiry=ieobj.value;
		if (FreqFac) FreqFac=FreqFac.value; //log60844 TedT
		if (objIVDF) IVDoseFactor=objIVDF.value;
		//log60844 TedT
		if ((!IVType) || (IVType && IVType.value!="C")) {
			if(calcqty && calcqty.value!="Y") return;
			var qty=Math.round(parseFloat(DurFac)*parseFloat(FreqFac)*parseFloat(IVDoseFactor)*100000000)/100000000;
			if(objQty) objQty.value=qty;
			if(objQty1) objQty1.value=qty;
			return;
		}
		
		var FreqInMins="";
		if((Volume!=="")&&(VolUnit!="")&&(Time!="")&&(TimeUnit!="")&&(!isNaN(Volume))&&(!isNaN(Time))&&(!isNaN(VolUnit))&&(!isNaN(TimeUnit))) {
				//alert("DurFac:"+DurFac+", Volume:"+Volume+", VolUnit:"+VolUnit+", Time:"+Time+", TimeUnit:"+TimeUnit+", PartialDeduct:"+PartialDeduct+", TotVolume:"+TotVolume);
		
			Rate=(Volume*VolUnit)/(Time*TimeUnit)
			if(Rate!="") {
				Quantity=(Rate*DurFac*24)/TotVolume;
				//-------------------------------------
				var IVDur=(DurFac/Quantity)*24;
				if((IVExpiry!="")&&(IVExpiry<((DurFac/Quantity)*24))) {
					IVExpDur=IVDur;
					var newnotes=t['EXP_1']+ IVExpiry +t['EXP_2'] + IVDur + t['EXP_3'];
					if (lu_obj) lu_obj.completed=false;
					alert(newnotes);
					Time=IVExpiry;
					TimeUnit=1;
					Rate=(Volume*VolUnit)/(Time*TimeUnit)
					if(Rate!="") {
						Quantity=(Rate*DurFac*24)/TotVolume;
						FreqInMins=(IVExpiry*60);
					}
				}
				//-------------------------------------
				if((DurFac!="")&&(Quantity!="")&&(FreqInMins=="")) FreqInMins=(DurFac/Quantity)*24*60;
				if(FreqInMins!="") fdobj.value=FreqInMins;
				if (PartialDeduct!="Y") Quantity=Math.ceil(Quantity);
				var objQty1=document.getElementById("Qty1z"+rowidx);
				var objQty=document.getElementById("Qtyz"+rowidx);
				if (objQty) objQty.value=Quantity;
				if (objQty1) objQty1.value=Quantity;
				var obj=document.getElementById("IVExpDurz"+rowidx);
				if (obj) obj.value=IVExpDur;

			}
		}
	}	
	return;
}


//log60222 TedT 
function OverrideOnClickHandler(){
	
	tbl=document.getElementById('tOEOrder_SessionList');
	var noID="";
	var ordString="";
	var ordArr="";
	var EpisodeID=document.getElementById("EpisodeID");
	if(EpisodeID) EpisodeID=EpisodeID.value;
	var PatientID=document.getElementById("PatientID");
	if(PatientID) PatientID=PatientID.value;

	if(tbl) {
		for (var i=1;i<tbl.rows.length;i++) {
			var sel=document.getElementById("selectz"+i);
			var id=document.getElementById("IDz"+i);
			var override=document.getElementById("OverrideIDz"+i);
			var itmname=document.getElementById("OEITMNamez"+i);
			if (id && override && sel && sel.checked) {
				//what if override has no id
				if(override.value=="") {
					noID+=itmname.value+"\n";
					continue;
				}
				ordString+=id.value+String.fromCharCode(4)+override.value+"^";
			}
		}
	}
	
	if(noID!="") {
		alert(t['NO_OVERRIDE']+":\n"+noID);
		return false;
	}
	
	if (ordString=="") {
		alert(t['NO_SELECT']);
		return false;
	}
	
	ordArr=ordString.split("^");
	//log TedT if only one item selected, pass in ID only
	if(ordArr.length==2)
		ordString="&ID="+mPiece(ordArr[0],String.fromCharCode(4),1);
	else
		ordString="&OverrideRowIDs="+escape(ordString);

	var url="websys.default.csp?WEBSYS.TCOMPONENT=ARChargesOverride.Edit&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PatientBanner=1"+ordString;
	websys_createWindow(url,"",'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes');
}

function mPiece(s1,sep,n) {
    delimArray = s1.split(sep);
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}

//log 61314 TedT 
function DeleteOrder(ordid) {
	if (ordid=="" || ordid==null) return false;
	var i=tkMakeServerCall("web.OEOrder","DeleteSessionItemHandler",ordid);
	return true;
}

//log60323 TedT
function GetSelectedOrders() {
	var orderids="";
	
	if(tbl) {
		for (var i=1;i<tbl.rows.length;i++) {
			var sel=document.getElementById("selectz"+i);
			var id=document.getElementById("IDz"+i);
			if (id && sel && sel.checked) {
				orderids=orderids+id.value+"^";
			}
		}
	}
	
	return orderids;
}

//log 61690 BoC 30-11-2006 add dose click handler
function DosingHandler(e){
	if (!e) {var e = window.event;}
	if (e.target) {outObj = e.target;} else if (e.srcElement) {outObj = e.srcElement;}
	outRow=tk_getRow(outObj);
	rowidx=outRow.sectionRowIndex+1;
	if (rowidx!=""){

		var type=document.getElementById("typez"+rowidx).value;
		var IVType=document.getElementById("IVTypez"+rowidx).value;
		if ((type=="I") && (IVType=="C")) return false;

		var Duration="";
		var Frequency="";
		var HidBSAFormula="";
		var OEORIItmMastDR="";
		var PatientID="";
		var EpisodeID=""
		var Dose="";
		var CTUOMDesc="";
		var mradm=""

		var PIDObj=document.getElementById("PatientID");
		if ((PIDObj)&&(PIDObj.value!="")) PatientID=PIDObj.value;
		var EIDObj=document.getElementById("EpisodeID");
		if ((EIDObj)&&(EIDObj.value!="")) EpisodeID=EIDObj.value;
		var ARCObj=document.getElementById("arcimz" + rowidx);
		if ((ARCObj)&&(ARCObj.value!="")) OEORIItmMastDR=ARCObj.value;
		var VFObj=document.getElementById("Frequencyz" + rowidx);
		if ((VFObj)&&(VFObj.value!="")) Frequency=VFObj.value;
		var VDObj=document.getElementById("Durationz" + rowidx);
		if ((VDObj)&&(VDObj.value!="")) Duration=VDObj.value;
		var QObj=document.getElementById("Dosagez" + rowidx);
		if ((QObj)&&(QObj.value!="")) Dose=QObj.value;
		var CUObj=document.getElementById("Unitz" + rowidx);
		if ((CUObj)&&(CUObj.value!="")) CTUOMDesc=CUObj.innerText;
		var HBSAObj=document.getElementById("HidBSAFormulaz" + rowidx);
		if ((HBSAObj)&&(HBSAObj.value!="")) HidBSAFormula=HBSAObj.value;
		var MRObj=document.getElementById("MRAdmz" + rowidx);
		if ((MRObj)&&(MRObj.value!="")) mradm=MRObj.value;
		var url = "websys.default.csp?WEBSYS.TCOMPONENT=OEOrder.CalcDose&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PatientBanner=1"+"&Frequency="+Frequency+"&Duration="+Duration+"&OEORIItmMastDR="+OEORIItmMastDR+"&Dose="+Dose+"&CTUOMDesc="+CTUOMDesc+"&HidBSAFormula="+HidBSAFormula+"&mradm="+mradm+"&rowidx="+rowidx;
		websys_createWindow(url,"","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
	}
}
document.body.onload=BodyLoadHandler;

//Log 66079 PeterC 11/01/08
document.body.onunload=BodyUnLoadHandler;

function BodyUnLoadHandler(){

}