// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var aryDiagnoses;
var aryTreatments;
var aryColours;
var aryID;

var hSel=document.getElementById("HiddenSelected");
var hlSel=document.getElementById("HiddenLastSelected");
var hlSelToothId="";

/* Just Testing
var aa=Object();
aa["red"] = "red";  // if you like bracket style
aa.size = 15;       // if you like object style
text = "";
for (prop in aa) {
    //text += prop + ": " + aa.prop + "\";
	alert (prop + ": " + aa[prop]);
    }
*/

// Log 63505: history for selected tooth displays as read-only
var objSelectedHistory=document.getElementById("SelectedHistory");
if (objSelectedHistory) {
     objSelectedHistory.readOnly=true;
   }	


var objState = document.getElementById("State");
if (objState) {
	objState.onclick = StateClick;
}

var objTreatment = document.getElementById("Treatment");
if (objTreatment) {
	objTreatment.onclick = TreatmentClick;
}

var objHistoryLnk = document.getElementById("History");
if (objHistoryLnk) {
	objHistoryLnk.onclick = HistoryClick;
}

var obj = document.getElementById("tPAPerson_Dental_Odontogram");
var clrBG="";

if (obj) {
	clrBG=obj.currentStyle.backgroundColor;
}
if (clrBG == "") {
	clrBG = "White";
}

function StateClick(evt) {
	if(hSel.value==""){
		alert(t['No_SelTeeth']);
		return false;
	}
	var url = "websys.default.csp?WEBSYS.TCOMPONENT=PAPersonTooth.Edit" + GeturlParams("patid","");
	websys_lu(url, false, 'top=50,left=100,width=800,height=600,scrollbars=yes,resizable=yes');
	return false;
}

function TreatmentClick(evt) {
	if(hSel.value==""){
		alert(t['No_SelTeeth']);
		return false;
	}
	var f=document.getElementById("fPAPerson_Dental_Odontogram");
	var OEPopupWKFL=f.elements["OEPopupWKFL"].value;
	var url = "websys.csp?&TWKFL=" + OEPopupWKFL + GeturlParams("mradm","");
	//alert("url: " + url);
	websys_lu(url, false, 'top=50,left=100,width=800,height=600,scrollbars=yes,resizable=yes');
	return false;
}

function HistoryClick(evt) {
	if(hSel.value==""){
		alert(t['No_SelTeeth']);
		return false;
	}
	var url="";
	//if only one tooth selected, pass it's id else pass blank (2nd parameter to GeturlParams)
	if(hSel.value.indexOf("^") == -1){
		var encObj = document.getElementById("EncHistoryMth");
		var tId="";
		var hObj = document.getElementById("H" + hSel.value);
		var patObj=document.getElementById("PatientID");
		if (encObj && encObj.value !="" && hObj && patObj && patObj.value != ""){	
			//alert(patObj.value+" "+hObj.getAttribute("Position")+" "+hObj.getAttribute("Number"));
			var arr = cspRunServerMethod(encObj.value,patObj.value,hObj.getAttribute("Position"),hObj.getAttribute("Number")).split("^");
			if(arr[0]) tId = arr[0];	
		}
		url = "websys.default.csp?WEBSYS.TCOMPONENT=PAPersonToothComments.Edit" + GeturlParams("patid",tId);
	}
	else{
		url = "websys.default.csp?WEBSYS.TCOMPONENT=PAPersonToothComments.Edit" + GeturlParams("patid","");
	}
	//alert(url);
	websys_lu(url, false, 'top=50,left=100,width=800,height=600,scrollbars=yes,resizable=yes');
	return false;
}

function GeturlParams(parSrc,idSrc) {
	var f=document.getElementById("fPAPerson_Dental_Odontogram");
	var PatientID=f.elements["PatientID"].value;
	var EpisodeID=f.elements["EpisodeID"].value;
	var mradm=f.elements["mradm"].value;
	var CONTEXT=f.elements["CONTEXT"].value;

	var url = "&PatientBanner=1";
	url = url += "&ID=" + idSrc;
	url = url += "&PARREF=";
	if(parSrc == "patid"){
		url += PatientID; 
	}
	else if(parSrc == "mradm"){
		url += mradm;
	}
	url += "&PatientID=" + PatientID + "&mradm=" + mradm + "&EpisodeID=" + EpisodeID + "&CONTEXT=" + CONTEXT;
	url += "&TeethIDs=" + hSel.value;
	url += "&TeethUAreas=" + getSelTeethUniqueAreas();
	url += "&TeethAreas=" + getSelTeethAreas();
	url += "&TeethPos=" + getSelTeethPos();
	url += "&TeethNum=" + getSelTeethNum();
	url += "&SelTeethDesc=" + getSelTeethDesc();
	//alert(url);
	return url;
}

//This function loops through hSel and constructs a string of all the tooth descriptions selected
function getSelTeethDesc(){
	var arrId = hSel.value.split("^");
	var selDesc="";
	for(i=0; i<arrId.length; i++){
		id = arrId[i];
		if(id != ""){
			objId = document.getElementById("H"+id);
			if(objId){
				desc = objId.getAttribute("Desc");
				if(desc != ""){
					if(selDesc == ""){
						selDesc = desc;
					}
					else{
						selDesc = selDesc + ", " + desc;
					}
				}
			}
		}
	}
	return selDesc;
}

//This function loops through hSel and constructs a string of all the tooth positions selected
function getSelTeethPos(){
	var arrId = hSel.value.split("^");
	var selPos="";
	for(i=0; i<arrId.length; i++){
		id = arrId[i];
		if(id != ""){
			objId = document.getElementById("H"+id);
			if(objId){
				pos = objId.getAttribute("Position");
				if(pos != ""){
					if(selPos == ""){
						selPos = pos;
					}
					else{
						selPos = selPos + "^" + pos;
					}
				}
			}
		}
	}
	return selPos;
}

//This function loops through hSel and constructs a string of all the tooth numbers selected
function getSelTeethNum(){
	var arrId = hSel.value.split("^");
	var selNum="";
	for(i=0; i<arrId.length; i++){
		id = arrId[i];
		if(id != ""){
			objId = document.getElementById("H"+id);
			if(objId){
				num = objId.getAttribute("Number");
				if(num != ""){
					if(selNum == ""){
						selNum = num;
					}
					else{
						selNum = selNum + "^" + num;
					}
				}
			}
		}
	}
	return selNum;
}

//This function loops through hSel and constructs a string of all the unique tooth areas selected
function getSelTeethUniqueAreas(){
	var arrId = hSel.value.split("^");
	var selAreas="";
	for(i=0; i<arrId.length; i++){
		id = arrId[i];
		if(id != ""){
			objId = document.getElementById("H"+id);
			if(objId){
				area = objId.getAttribute("Area");
				if(area != ""){
					if(selAreas == ""){
						selAreas = area;
					}
					else{
						if(selAreas.indexOf(area) == -1){
							selAreas = selAreas + "^" + area;
						}
					}
				}
			}
		}
	}
	return selAreas;
}

//This function loops through hSel and constructs a string of all the tooth areas selected
function getSelTeethAreas(){
	var arrId = hSel.value.split("^");
	var selAreas="";
	for(i=0; i<arrId.length; i++){
		id = arrId[i];
		if(id != ""){
			objId = document.getElementById("H"+id);
			if(objId){
				area = objId.getAttribute("Area");
				if(area != ""){
					if(selAreas == ""){
						selAreas = area;
					}
					else{
						selAreas = selAreas + "^" + area;
					}
				}
			}
		}
	}
	return selAreas;
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

function PAPerson_Dental_Odontogram_ClickHandler(posn, side, num, type, face, evt) {	
	var selHistAr;
	var OdontID = posn + side + num + type + face;
	if (OdontID == "") return false;
	var objClicked = document.getElementById(OdontID);
	if (!objClicked) return false;

	//call a server method to retrieve history of the selected tooth (whole tooth not individual areas)
	var encObj = document.getElementById("EncHistoryMth");
	if (encObj && encObj.value !=""){	
		var patObj=document.getElementById("PatientID");
		//alert(cspRunServerMethod(encObj.value,patObj.value,posn+side,num));
		selHistAr = cspRunServerMethod(encObj.value,patObj.value,posn+side,num).split("^");
		var histObj = document.getElementById("SelectedHistory");
		if(histObj){
			if(objClicked.selected) { //tooth already selected, so clear the history
				histObj.value="";
			}
			else{
				if(selHistAr[3]) {
					//Backend returns "<BR>" for a line break.  Need to replace that with the
					//string equivalent to the unicode characters 13,10 (line break)
					var subsHist ="";
					if(selHistAr[3] == "") {
						subsHist="";
					}
					else{
						rExp=/<BR>/gi;
						subsHist = selHistAr[3].replace(rExp,String.fromCharCode(13,10));
					}
					histObj.value=subsHist;
				}
			}			
		}
	}

	//store the last selected tooth id and set the tooth position and number to a display only variable
	var dispPNObj=document.getElementById("SelToothPosNum");
	if(hlSel){
		if(objClicked.selected) { //tooth already selected, so clear hlSel
			hlSel.value="";
			if (dispPNObj) dispPNObj.value="";
			hlSelToothId="";
		}
		else{
			hlSel.value=OdontID;
			if (dispPNObj && selHistAr[1] && selHistAr[2]) dispPNObj.value=selHistAr[1] + t['PosNumSeperator'] + selHistAr[2];
			if(selHistAr[0]) hlSelToothId=selHistAr[0];
		}	
		//alert(hlSel.value);		
		//alert(hlSelToothId);
	}

	var tblDentalOdontogram=document.getElementById("tPAPerson_Dental_Odontogram");
	if ((tblDentalOdontogram)&&(tblDentalOdontogram.disabled==true)) return false;
	//If the selected object is of type "A", if the "A" part is selected,then select all the other tooth parts.
	//If the "A" part is deselected, then deselect all other tooth parts.
	if(type == "A") {
		nObj = objClicked;
		rObj = document.getElementById(posn + side + num + "R");
		tObj = document.getElementById(posn + side + num + "T");
		f1Obj = document.getElementById(posn + side + num + "F1");
		f2Obj = document.getElementById(posn + side + num + "F2");
		f3Obj = document.getElementById(posn + side + num + "F3");
		f4Obj = document.getElementById(posn + side + num + "F4");
		f5Obj = document.getElementById(posn + side + num + "F5");

		if(nObj && rObj && tObj && f1Obj && f2Obj && f3Obj && f4Obj){
			if(nObj.selected){  //already selected, so unselect the whole tooth
				SelectToothPart(nObj,false,true);
				SelectToothPart(rObj,false,true);
				SelectToothPart(tObj,false,true);
				SelectToothPart(f1Obj,false,true);
				SelectToothPart(f2Obj,false,true);
				SelectToothPart(f3Obj,false,true);
				SelectToothPart(f4Obj,false,true);
				if(f5Obj) SelectToothPart(f5Obj,false,true);				
			}
			else{
				SelectToothPart(nObj,true,true);
			
				//first unselect all the tooth parts (except Number).  This will remove the ids from hSel
				SelectToothPart(rObj,false,true);
				SelectToothPart(tObj,false,true);
				SelectToothPart(f1Obj,false,true);
				SelectToothPart(f2Obj,false,true);
				SelectToothPart(f3Obj,false,true);
				SelectToothPart(f4Obj,false,true);
				if(f5Obj) SelectToothPart(f5Obj,false,true);

				//then select all the tooth parts (except Number) with the addTohSel flag turned off (which doesn't add ids to hSel)
				SelectToothPart(rObj,true,false);
				SelectToothPart(tObj,true,false);
				SelectToothPart(f1Obj,true,false);
				SelectToothPart(f2Obj,true,false);
				SelectToothPart(f3Obj,true,false);
				SelectToothPart(f4Obj,true,false);
				if(f5Obj) SelectToothPart(f5Obj,true,false);				
			}			
		}
	}
	else{
		//If the clicked object is already selected, unselect it.  If not already select, select it.  (Invert selection on each click)
		if(objClicked.selected){
			SelectToothPart(objClicked,false,true);

			nObj = document.getElementById(posn + side + num + "A");
			if(nObj && nObj.selected){
				SelectToothPart(nObj,false,true);
				rObj = document.getElementById(posn + side + num + "R");
				tObj = document.getElementById(posn + side + num + "T");
				f1Obj = document.getElementById(posn + side + num + "F1");
				f2Obj = document.getElementById(posn + side + num + "F2");
				f3Obj = document.getElementById(posn + side + num + "F3");
				f4Obj = document.getElementById(posn + side + num + "F4");
				f5Obj = document.getElementById(posn + side + num + "F5");
				cObj = document.getElementById(posn + side + num + "C");

				if(rObj && rObj.selected) {SelectToothPart(rObj,false,true); SelectToothPart(rObj,true,true);}
				if(tObj && tObj.selected) {SelectToothPart(tObj,false,true); SelectToothPart(tObj,true,true);}
				if(f1Obj && f1Obj.selected) {SelectToothPart(f1Obj,false,true); SelectToothPart(f1Obj,true,true);}
				if(f2Obj && f2Obj.selected) {SelectToothPart(f2Obj,false,true); SelectToothPart(f2Obj,true,true);}
				if(f3Obj && f3Obj.selected) {SelectToothPart(f3Obj,false,true); SelectToothPart(f3Obj,true,true);}
				if(f4Obj && f4Obj.selected) {SelectToothPart(f4Obj,false,true); SelectToothPart(f4Obj,true,true);}
				if(f5Obj && f5Obj.selected) {SelectToothPart(f5Obj,false,true); SelectToothPart(f5Obj,true,true);}
				if(cObj && cObj.selected) {SelectToothPart(cObj,false,true); SelectToothPart(cObj,true,true);}
			}
		}
		else{
			SelectToothPart(objClicked,true,true);			
		}
	}	
	//alert("id " + hSel.value + " areas " + getSelTeethAreas());
	return false;
}

//This function sets the selection of the object (objClicked) based on the select flag
function SelectToothPart(objClicked, select, addTohSel){
	var hObj = document.getElementById("H" + objClicked.id);
	if (!hObj) return false;
	var objSelectedState = document.getElementById("SelectedState");
	var objSelectedTreatment = document.getElementById("SelectedTreatment");

	if (!select) {
		objClicked.selected=false;
		// put the old colour back.
		objClicked.className = "";
		objClicked.bgColor = hObj.getAttribute("Colour");

		//when deselecting, remove the id from hSel
		RemoveFromhSel(objClicked.id);

		//Remove Diagnosis and Treatment from listboxes
		if(objSelectedState) RemoveItemSingle(objSelectedState, objClicked.id);
		if(objSelectedTreatment) RemoveItemSingle(objSelectedTreatment, objClicked.id);		

	} else {
		objClicked.selected=true;
		objClicked.className = "DentalSel";
				
		//when selecting, add the id to hSel
		if(addTohSel) AddTohSel(objClicked.id);	
		
		//Add Diagnosis and Treatment to listboxes
		if(objSelectedState) AddItemSingle(objSelectedState, objClicked.id, hObj.getAttribute("Desc") +": " + hObj.getAttribute("State"));
		if(objSelectedTreatment) AddItemSingle(objSelectedTreatment, objClicked.id,  hObj.getAttribute("Desc") +": " + hObj.getAttribute("Treatment"));		
	}
}

//Add a value to hSel (delimited by ^)
function AddTohSel(val){
	if (hSel.value != ""){
		hSel.value += "^";
	}
	hSel.value += val;
}

//Remove a value from hSel (which is delimited by ^)
function RemoveFromhSel(val){
	tmpId = "^" + val; //if id is not the first piece
	if (hSel.value.indexOf(tmpId) != -1){
		hSel.value = hSel.value.replace(tmpId,"");
	}
	else if (hSel.value.indexOf(val) != -1){ //if id is first piece
		hSel.value = hSel.value.replace(val,"");
		//if ^ in at 0 index (first character), get rid of it (replace function only replaces the first occurance)
		if(hSel.value.indexOf("^")==0){
			hSel.value=hSel.value.replace("^","");
		}
	}
}
ShowOdontNOW();
