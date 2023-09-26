// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var debug="N"  //"Y" = alerts and stuff, "N" = alert free
var clearRes="Y";

function DocumentLoadHandler() {

	// Log 39443 BC 29-9-03 Make sure if the find is in the operating room frame and the component is refreshed
	// that the findstill appears in the lower frame.
	if (parent.frames["RBOperatingRoomEdit"]) {parent.FDocumentLoadHandler("Y");}

	obj=document.getElementById('CTLoc');
	if (obj) obj.onblur = LocTextBlurHandler;

	obj=document.getElementById('RESDesc');
	if (obj) obj.onblur = ResTextBlurHandler;

	obj=document.getElementById('Surgeon');
	if (obj) obj.onblur = SurgTextBlurHandler;

	var obj=document.getElementById('HOSPDesc');
	if (obj) obj.onblur=HospBlurHandler;

	obj=document.getElementById('RBOPASCareProv');
	if (obj) obj.onblur = RBOPASCareProvBlurHandler;

	var obj=document.getElementById('RBOPASCareProvType');
	if (obj) obj.onblur=RBOPASCareProvTypeBlurHandler;


	var obj=document.getElementById('RBOPOperDepartmentDR');
	if (obj) {
		obj.onblur = RBOPOperDepartmentBlurHandler;
		if (obj.value!="") {
			var loc= obj.value
			if (loc.indexOf("|||amp|||")!=-1) loc=loc.replace("|||amp|||","&");
			obj.value=loc
		}
	}

	// 65410 RC 2/11/07 Made date mandatory
	var obj=document.getElementById("RBOPDateOper");
	var cobj=document.getElementById("cRBOPDateOper");
	if ((obj)&&(cobj)) {
		obj.className="clsRequired"
		cobj.className="clsRequired"
	}

	//Log 48401 Chandana 28/2/05 - set selection in status listbox
	SetStatusSel();

	//Log 49002 Chandana 2/2/05
	var obj=document.getElementById('find1');
	if (obj) {
		obj.url="";
		obj.onclick=find1_click;
	}
	find1_click();

}

function SetStatusSel(){
	var objH = document.getElementById("OPStatusH");
	var obj = document.getElementById("OPStatus");
	if(obj && objH && objH!=""){
		var arSt = objH.value.split(" ");
		for(var x=0; x<arSt.length; x++){
			for(var i=0; i<obj.length; i++){
				if (obj.options[i].value==arSt[x]){
					obj.options[i].selected=true;
					break;
				}
			}
		}
	}


}

//Log 49002 Chandana 2/2/05.  Moved this from rboperatingroomframe.csp.
//This overwrites find1_click in the generated script.
function find1_click() {
		var win=document.frames['RBOperatingRoomEdit'];
		var link=""
		var doc=document;
		var RBOPDateOper=""
		var CTLocID=""
		var RESDesc=""
		var CTLoc=""
		var ResID=""
		var surgeonid=""
		var Surgeon=""
		var dateto=""
		var Anesthetiest=""
		var RBOPOperDepartmentID=""
		var RBOPOperDepartmentDR=""
		var OPStatus=""
		var noappt=""
		var RetainFieldValue=""
		var RBOPOperation=""
		var RBOPStatePPP=""
		var RegistrationNo=""
		var RBOPASCareProv=""
		var RBOPASCareProvType=""
		var RBOPASCareProvId=""
		var RBOPASCareProvTypeId=""

		// 65410 RC 2/11/07 Made date mandatory
		var obj=document.getElementById("RBOPDateOper");
		if ((obj)&&(obj.value=="")) {
			alert("\'"+t['RBOPDateOper']+"\' "+t["XMISSING"]);
			return false;
		}

		var obj=doc.getElementById("RetainFieldValue");
		if (obj) {
			//BR 57055
			if (obj.checked==false) obj.value="off";
			if (obj.checked==true) obj.value="on";
			RetainFieldValue=obj.value;
			link="&RetainFieldValue="+RetainFieldValue;
		}

		var obj=doc.getElementById("RBOPDateOper");
		if (obj) {RBOPDateOper=obj.value;link=link+"&RBOPDateOper="+RBOPDateOper;}

		var obj=doc.getElementById("CTLocID");
		if (obj) {CTLocID=obj.value;link=link+"&CTLocID="+CTLocID;}

		var obj=doc.getElementById("CTLoc");
		if (obj) {CTLoc=obj.value;link=link+"&CTLoc="+websys_escape(CTLoc);}

		var obj=doc.getElementById("ResID");
		if (obj) {ResID=obj.value;link=link+"&ResID="+ResID;}

		var obj=doc.getElementById("RESDesc");
		if (obj) {RESDesc=obj.value;link=link+"&RESDesc="+websys_escape(RESDesc);}

		var obj=doc.getElementById("surgeonid");
		if (obj) {surgeonid=obj.value;link=link+"&surgeonid="+surgeonid;}

		var obj=doc.getElementById("Surgeon");
		if (obj) {Surgeon=obj.value;link=link+"&Surgeon="+websys_escape(Surgeon);}

		var obj=doc.getElementById("dateto");
		if (obj) {dateto=obj.value;link=link+"&dateto="+dateto;}

		var obj=doc.getElementById("Anesthetiest");
		if (obj) {Anesthetiest=obj.value;link=link+"&Anesthetiest="+websys_escape(Anesthetiest);}

		var obj=doc.getElementById("RBOPOperDepartmentID");
		if (obj) {RBOPOperDepartmentID=obj.value;link=link+"&RBOPOperDepartmentID="+RBOPOperDepartmentID;}

		var obj=doc.getElementById("RBOPOperDepartmentDR");
		if (obj) {RBOPOperDepartmentDR=obj.value;link=link+"&RBOPOperDepartmentDR="+websys_escape(RBOPOperDepartmentDR);}

		//Log 48401 Chandana 28/2/05 - status field changed to a list box to allow multiple selection
		//var obj=doc.getElementById("OPStatus");
		//if (obj) {OPStatus=obj.value;link=link+"&OPStatus="+OPStatus;}
		var obj=doc.getElementById("OPStatus");
		if(obj) {
			for (var i=(obj.length-1); i>=0; i--) {
				if (obj.options[i].selected) {
					if(OPStatus==""){
						OPStatus=obj.options[i].value;
					}
					else {
						OPStatus=OPStatus+" "+obj.options[i].value;
					}
				}
			}
			link=link+"&OPStatus="+websys_escape(OPStatus);
		}

		var obj=doc.getElementById("NoAppt");
		if ((obj)&&(obj.checked)) {noappt="on";} else {noappt="";}
		if (!obj) noappt=""
		if(noappt == "") noappt = "off";
		link=link+"&NoAppt="+noappt;

		var obj=doc.getElementById("RBOPOperation");
		if (obj) {RBOPOperation=obj.value;link=link+"&RBOPOperation="+websys_escape(RBOPOperation);}

		var obj=doc.getElementById("RBOPStatePPP");
		if (obj) {RBOPStatePPP=obj.value;link=link+"&RBOPStatePPP="+websys_escape(RBOPStatePPP);}


		var obj=doc.getElementById("RegistrationNo");
		if (obj) {RegistrationNo=obj.value;link=link+"&RegistrationNo="+RegistrationNo;}

		var obj=doc.getElementById("RBOPASCareProv");
		if (obj) {RBOPASCareProv=obj.value;link=link+"&RBOPASCareProv="+websys_escape(RBOPASCareProv);}

		var obj=doc.getElementById("RBOPASCareProvType");
		if (obj) {RBOPASCareProvType=obj.value;link=link+"&RBOPASCareProvType="+websys_escape(RBOPASCareProvType);}

		var obj=doc.getElementById("RBOPASCareProvId");
		if (obj) {RBOPASCareProvId=obj.value;link=link+"&RBOPASCareProvId="+RBOPASCareProvId;}

		var obj=doc.getElementById("RBOPASCareProvTypeId");
		if (obj) {RBOPASCareProvTypeId=obj.value;link=link+"&RBOPASCareProvTypeId="+RBOPASCareProvTypeId;}

		//Log 47744 - CS 09/12/04
		//FindOperation query in web.RBOperatingRoom has 15 parameters, therefore use
		//Params as the last parameter.  It is a ^ delimited parameter.
		var obj=doc.getElementById("Params");
		//if(obj) {obj.value=CTLoc+"^"+RESDesc+"^"+RBOPOperDepartmentDR;link=link+"&Params="+obj.value;}
		if(obj) {obj.value=websys_escape(CTLoc)+"^"+websys_escape(RESDesc)+"^"+websys_escape(RBOPOperDepartmentDR)+"^"+RBOPASCareProvId+"^"+RBOPASCareProvTypeId;link=link+"&Params="+obj.value;}

		//alert(obj.value);

		//alert(RBOPDateOper+","+CTLocID+","+ResID+","+surgeonid+","+dateto+","+Anesthetiest+","+RBOPOperDepartmentDR+","+OPStatus);
		//alert("Surgeon " + Surgeon + " surgeonid " + surgeonid);
		var url="websys.default.csp?WEBSYS.TCOMPONENT=RBOperatingRoom.List"+link+"&CONTEXT="+session["CONTEXT"];
		var win2=parent.frames['RBOperatingRoomList'];
		if (win2) {win2.location=url;}
		return;
}


function RBOPOperDepartmentBlurHandler(e) {
	//alert("LocTextBlurHandler");
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('RBOPOperDepartmentID');
		if (obj) obj.value=""
	}
}

function LocTextBlurHandler(e) {
	//alert("LocTextBlurHandler");
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('CTLocID');
		if (obj) obj.value=""
	}
}

function ResTextBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('ResID');
		if (obj) obj.value="";
	}
}

function SurgTextBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('surgeonid');
		if (obj) obj.value="";
	}
}


function LocationTextChangeHandler() {
	//SB 12/06/02: This function is called from CTLoc.LookUpBrokerLoc, as the onchange handler overwrites the broker method.
	var obj=document.getElementById('CTLoc')
	var res=document.getElementById('RESDesc')
	if ((obj) && (res)) {
		res.value=""
		var obj=document.getElementById('CTLocID');
		if (obj) obj.value=""
		var obj=document.getElementById('ResID');
		if (obj) obj.value="";

	}
}

function ResourceTextChangeHandler() {
	//SB 12/06/02: This function is called from RBResource.LookUpBrokerRes, as the onchange handler overwrites the broker method.
	var obj=document.getElementById('CTLoc')
	var res=document.getElementById('RESDesc')
	// && (obj.value=="")
	if (((obj) && (res))) {
		res.value=""
	}
}

function CTLOCDescLookUpSelect(str) {
	//alert(str);
	var lu = str.split("^");
	//var obj=document.getElementById('RESDesc');
	//if (obj) obj.value=lu[1];
	//var obj=document.getElementById('ResID');
	//if (obj) obj.value=lu[3];
	var obj=document.getElementById('CTLoc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('CTLocID');
	if (obj) obj.value=lu[1];
	var objres=document.getElementById('RESDesc');
	if (objres) objres.value="";
	var obj=document.getElementById('ResID');
	if (obj) obj.value="";

}

function RBOPOperDepartmentLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('RBOPOperDepartmentDR');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('RBOPOperDepartmentID');
	if (obj) obj.value=lu[1];

}

function RESDescLookUpSelect(str) {

	if (debug=="Y") {alert("RESDescLookUpSelect");}
	var lu = str.split("^");
	var objres=document.getElementById('RESDesc');
	if (objres) objres.value=lu[0];
	var obj=document.getElementById('ResID');
	if (obj) {obj.value=lu[2]}
	var obj=document.getElementById('CTLoc');
	if (obj) obj.value=lu[3];
	var obj=document.getElementById('CTLocID');
	if (obj) obj.value=lu[4];
}

function SurgDescLookUpSelect(str) {
	if (debug=="Y") {alert("SurgDescLookUpSelect");}
	var lu = str.split("^");
	//alert(str);
	var objres=document.getElementById('Surgeon');
	if (objres) objres.value=lu[0];
	var obj=document.getElementById('surgeonid');
	if (obj) {obj.value=lu[1];}
}

function HospLookup(str) {
	var lu = str.split("^");
	//alert(lu);
	var obj=document.getElementById('HOSPId');
	if (obj) obj.value=lu[1];

	return;
}

function HospBlurHandler() {
	var objid=document.getElementById('HOSPId');
	var obj=document.getElementById('HOSPDesc');
	if ((objid)&&(obj)&&(obj.value=="")) objid.value="";

}

function RBOPASCareProvLookUpHandler(str) {
	var lu = str.split("^");
	//alert(lu);
	var obj=document.getElementById('RBOPASCareProvId');
	if (obj) obj.value=lu[1];

	return;
}

function RBOPASCareProvBlurHandler() {
	var objid=document.getElementById('RBOPASCareProvId');
	var obj=document.getElementById('RBOPASCareProv');
	if ((objid)&&(obj)&&(obj.value=="")) objid.value="";

}

function RBOPASCareProvTypeLookUpHandler(str) {
	var lu = str.split("^");
	//alert(lu);
	var obj=document.getElementById('RBOPASCareProvTypeId');
	if (obj) obj.value=lu[2];

	return;
}

function RBOPASCareProvTypeBlurHandler() {
	var objid=document.getElementById('RBOPASCareProvTypeId');
	var obj=document.getElementById('RBOPASCareProvType');
	if ((objid)&&(obj)&&(obj.value=="")) objid.value="";

}

document.body.onload = DocumentLoadHandler;