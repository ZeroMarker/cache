// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var tbl=document.getElementById("tRTVolume_MoveRequest");


function UpdateHandler(evt) {
	
	//check that records with no requests requires the MRLocation field to be filled
	var checkedFlag=false;
	var obj=document.getElementById("MRLocation");
	var tbl=document.getElementById("tRTVolume_MoveRequest");

	if ( (!obj) || ((obj)&&(obj.value=="")) ) {		
		if (tbl) {
			for (i=1; i<tbl.rows.length; i++) {
				var obj=document.getElementById("Selectz"+i);
				if ((obj)&&(obj.checked)) {
					checkedFlag=true;
					if(document.getElementById("ReqVolIDz"+i).value=="") {
						alert(t['RequiredLocation']);
						return false;
					}
				}
			}
		}
	}
	else {
		if (tbl) {
			for (i=1; i<tbl.rows.length; i++) {
				var obj=document.getElementById("Selectz"+i);
				if ((obj)&&(obj.checked)) {
					checkedFlag=true;
				}
			}
		}
	}


	var cobj=document.getElementById("CreateReqConfig");
	if (cobj) {
		if (cobj.value=="Y") {
			var check=CheckRequest(obj,tbl);
			//PeterC 22/12/03 Log 41266 need to comment out the line below to stop the system from targeting the wrong frame
			//document.fRTVolume_MoveRequest.target="TRAK_hidden";
			//document.fRTVolume_MoveRequest.target="TRAK_main";
			//return Update_click();
			//Update_click();
		}
	}
	//return Update_click();
	
	if (checkedFlag) {
		Update_click(); 
		//window.opener.location.reload(true);
		//refreshParent();
		//window.close();
	}
	else {
		 alert(t['No_Record']); 
	}


}

function refreshParent() {
	var win=window.opener.parent.frames[1];
	if (win) {
		var formRad=win.document.forms['fRTRequest_FindMRRequest'];
		if (formRad) {
			// ANA Using the URl looses workflow.
			win.treload('websys.csp');			
		}
	} else if (window.opener) {
		//should be from epr chart csp page
		window.opener.history.go(0);
	}
}

function HospitalLookupSelect(txt) {
		
	var adata=txt.split("^");
	var hospDesc=adata[0];
	var hospID=adata[1];	
	var iobj=document.getElementById("hospID");
	if (iobj) iobj.value=hospID;
	//alert(iobj.value);
	var globj=document.getElementById("MRLocation");
	if (globj) globj.value="";
}

function ClearField() {
	var HOSPDescObj=document.getElementById("hospDesc"); 
	var HospIDObj=document.getElementById("HospID");
	//alert("hosp : "+HOSPDescObj.value);
	//HOSPDescObj.value="";
	//alert("obj: "+HOSPDescObj);
	if (HOSPDescObj){
		//alert("obj and blank");
		
		if ((HospIDObj) && (HOSPDescObj.value=="")) HospIDObj.value="";
		var mrobj=document.getElementById("hospitalID");
		if (mrobj) mrobj.value="";

	}else{
		//alert("null obj: "+HospIDObj);
		if (HospIDObj) HospIDObj.value="";
		var mrobj=document.getElementById("hospitalID");
		if (mrobj) mrobj.value="";
		//alert("hospitalid: "+mrobj.value);

	}
	//alert("hidden: "+HospIDObj.value);

}

var HOSPDescObj=document.getElementById("hospDesc"); 
if (HOSPDescObj){
	//alert("obj exist");
	 HOSPDescObj.onblur=ClearField;
}else{
	//alert("In else");
	ClearField();
}


function CheckRequest(obj,tbl) {
	var volids="";
	var check=false;
	var MRLocID="";
	
	if (obj) {
		var mridobj=document.getElementById("MRLocationID");
		if (mridobj) MRLocID=mridobj.value;
		
		for (i=1; i<tbl.rows.length; i++) {
			var obj=document.getElementById("Selectz"+i);
			if ((obj)&&(obj.checked)) {
				checkedFlag=true;
				if (document.getElementById("ReqVolIDz"+i)) {
					var hrobj=document.getElementById("HidRequestIDz"+i);
					if ((document.getElementById("ReqVolIDz"+i).value!="") && (hrobj.value==null) && (MRLocID!="")) {						
						if (document.getElementById("RTREQReqLocDRz"+i).value!=MRLocID) {
							volids=volids+document.getElementById("RTMAVRowIdz"+i).value+",";
							//alert("1: "+volids);
						}
					
					} else {
						if (document.getElementById("ReqVolIDz"+i).value=="") {
							if (hrobj.value==null) { 
								volids=volids+document.getElementById("RTMAVRowIdz"+i).value+",";
								//alert("2: "+volids);
							}					
						}
					}
					

				}
			}

		}
		//alert(volids);
		var patid="";
		var reqid="";
		var ReqLoc="";
		var pobj=document.getElementById("PatientID");
		if (pobj) patid=pobj.value;
		var robj=document.getElementById("MRLocation");
		if (robj) ReqLoc=robj.value;

		if (volids!="") {
			var url="rtvolume.createrequest.csp?VolumeIDs="+volids+"&PatientID="+patid+"&ReqLoc="+ReqLoc+"&CreateTransactions=Y"+"&Page=";
			window.location=url;
		}
	}
	return check;
}

function docLoaded() {
	ClearField();	
	//if (uobj) uobj.focus();
	SelectRequests();
	//document.onclick=VolumeCheck;
}

function SetFocusToUR(str) {
	var lu=str.split("^");
	//alert(lu);
	var mrobj=document.getElementById("MRLocationID");
	if (mrobj) mrobj.value=lu[1];
}

function SetFocusToURHos(str) {
	var lu=str.split("^");
	var mrobj=document.getElementById("hospitalID");

	if (lu && mrobj) {
		mrobj.value=lu[1];
		//alert(mrobj.value);
	}
}



function VolumeCheck(e){

	var src=websys_getSrcElement(e);
	var arry=src.id.split("z");
	rowsel=arry[arry.length-1];


	var vobj=document.getElementById("RTMAVVolDescz"+rowsel);
	//alert(rowsel);
	//alert(vobj);
	if ((vobj) && (vobj.innerText==" ") || (vobj.innerText=="")) {
		var sobj=document.getElementById("Selectz"+rowsel);
		if ((sobj)&&(sobj.checked)) {
			alert(t['Volume_Check']);
			//alert("Volume is blank, please create volume before update.");
			sobj.checked=false;
		}
	}	
	
}

function SelectRequests() {
	//Log 31705
	var rtmvsObj=document.getElementById("RTMAVRowIds")
	if ((rtmvsObj) && (rtmvsObj.value!="")) var arryVol=rtmvsObj.value.split(",")
	var vridobj=document.getElementById("VolRequestID");
	var reqid="";
	if (vridobj) reqid=vridobj.value;

	var tbl=document.getElementById("tRTVolume_MoveRequest");
	//alert("length : "+arryVol.length);
	for (k=0; k<arryVol.length; k++) {
		if (tbl) {
			for (i=1; i<tbl.rows.length; i++) {
				var obj=document.getElementById("Selectz"+i);
				var hobj=document.getElementById("hidSelectz"+i);
				var rtmv=document.getElementById("RTMAVRowIdz"+i);
				var treqid=document.getElementById("RequestIDz"+i);
				//alert(treqid.innerText);
				if ((rtmv) && (rtmv.value==arryVol[k])) {
					if ((obj) && (obj.checked==false)) {
						obj.checked=true;
					}

					if ((hobj)&&(obj)&&(obj.checked==true)) {
						hobj.value="ON";
					}
				}
				
			}
		}
	}
}

function EnterKey(e) {
	//alert("Clicked");
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if ((websys_getAlt(e)&&keycode!=18)||(keycode==33)||(keycode==34)) {
		try {	
			var key=String.fromCharCode(keycode);
				//if (key=="D") DeleteClickHandler();
				if (key=="U") {
					//alert("Clicked");
					UpdateHandler();
				}
				//if (key=="A") AddClickHandler();
				//if (key=="F") AddToFavClickHandler();
				//if (key=="O") OrderDetailsClickHandler();				
				//websys_sckeys[key]();
				//websys_cancel();
		}
		//catch and ignore
		catch(e) {}
	}
	
}

var uobj=document.getElementById("Update");
if (uobj) uobj.onclick=UpdateHandler;
document.body.onkeydown=EnterKey;
document.body.onload=docLoaded;