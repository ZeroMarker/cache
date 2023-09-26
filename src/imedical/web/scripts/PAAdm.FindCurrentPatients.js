// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var URobj=document.getElementById("PAPMINo"); 

// populate 'PARAMS' to pass to FindCurrentPatients query
function FindClickHandler(e) {
	if (checkMandatoryfields()) {
	var objParam=document.getElementById("PARAMS");
	var arr=new Array(16);
	
	var obj=document.getElementById("location");
	if (obj) arr[0]=obj.value;
	var obj=document.getElementById("CTPCPDesc");
	if (obj) arr[1]=obj.value;
	var obj=document.getElementById("HOSPDesc");
	if (obj) arr[2]=obj.value;
	var obj=document.getElementById("PAPMIName");
	if (obj) arr[3]=obj.value;
	var obj=document.getElementById("dfrom");
	if (obj) arr[4]=obj.value;
	var obj=document.getElementById("dto");
	if (obj) arr[5]=obj.value;
	arr[6]=""
	arr[7]=""
	var obj=document.getElementById("CurrentPatients");
	if ((obj)&&(obj.checked)) {arr[8]=1} else {arr[8]=""}
	var obj=document.getElementById("admType");
	if (obj) arr[9]=obj.value;
	var obj=document.getElementById("PAADMType");
	if (obj) arr[9]=obj.value;
	var obj=document.getElementById("PayorDesc");
	if (obj) arr[10]=obj.value;
	var obj=document.getElementById("WARDDesc");
	if (obj) arr[11]=obj.value;
	var obj=document.getElementById("DisDateFrom");
	if (obj) arr[12]=obj.value;
	var obj=document.getElementById("DisDateTo");
	if (obj) arr[13]=obj.value;
	var obj=document.getElementById("PatCondNotUpdated");
	if (obj) arr[14]=obj.value;
	var obj=document.getElementById("PAPMINo");
	if (obj) arr[15]=obj.value;
	var obj=document.getElementById("keyword");
	if (obj) arr[16]=obj.value;
	var obj=document.getElementById("DOSA");
	if (obj) arr[17]=obj.value;
	
	// cjb 09/10/2003 39479 (orig log 37107)
	var obj=document.getElementById("PAPERName2");
	if (obj) arr[18]=obj.value;
	var obj=document.getElementById("PAPERDob");
	if (obj) arr[19]=obj.value;
	var obj=document.getElementById("PAPERSex");
	if (obj) arr[20]=obj.value;
	var obj=document.getElementById("SelBookingType");
	if (obj) arr[21]=obj.value;
	var obj=document.getElementById("AdmRespUnit");
	if (obj) arr[22]=obj.value;
	var obj=document.getElementById("AdmissionPoint");
	if (obj) arr[23]=obj.value;
	var obj=document.getElementById("SignificantFacility");
	if (obj) arr[24]=obj.value;
	var obj=document.getElementById("ExpAdmDateFrom");
	if (obj) arr[25]=obj.value;
	var obj=document.getElementById("ExpAdmDateTo");
	if (obj) arr[26]=obj.value;
	var obj=document.getElementById("AdmPointLoc");
	if (obj) arr[27]=obj.value;
    var obj=document.getElementById("EpisodeNo");
	if (obj) arr[28]=obj.value;
    var obj=document.getElementById("SUBTDesc");
	if (obj) arr[29]=obj.value;
    var obj=document.getElementById("DISCONDesc");
	if (obj) arr[30]=obj.value;
	// cjb 09/10/2003 end 39479
	
	objParam.value=arr.join("^");
	//alert(objParam.value);
	find1_click();
	return false
	}
}

function documentLoadHandler() {
	//setConsultantFilter()
	/*var obj=document.getElementById('dfrom');
	if (obj) obj.onblur=DisDateTime;
	var obj=document.getElementById('dto');
	if (obj) obj.onblur=DisDateTime;
	var obj=document.getElementById('DisDateFrom');
	if (obj) obj.onblur=DisDateTime;
	var obj=document.getElementById('DisDateTo');
	if (obj) obj.onblur=DisDateTime;
	var obj=document.getElementById('cdfrom');
	if (obj) obj.className="clsRequired";*/
	
	var obj=document.getElementById("BookingType");
	if (obj) obj.onchange=SetBookingType;
	SetBookingType();
	
	var obj=document.getElementById("PAADMType");
	if (obj) obj.onblur=AdmTypeBlurHandler;
    var obj=document.getElementById("PAADMVisitStatus");
	if (obj) obj.onblur=VisitStatusBlurHandler;
	var obj=document.getElementById("HOSPDesc");
	if (obj) obj.onblur=HospBlurHandler;
	
	var obj=document.getElementById("find1");
	if (obj) obj.onclick=FindClickHandler;
	if (tsc['find1']) websys_sckeys[tsc['find1']]=FindClickHandler;
}

function DisDateTime() {
	//horribly complicated procedure to default mandatory field.
	var g=0;var obj1;var obj1c;var obj2;var obj3;var obj3c;var obj4;
	var eSrc=websys_getSrcElement(window.event);
	var objA=document.getElementById('dfrom');
	var objAc=document.getElementById('cdfrom');
	var objB=document.getElementById('DisDateFrom');
	var objBc=document.getElementById('cDisDateFrom');
	var objC=document.getElementById('dto');
	var objD=document.getElementById('DisDateTo');
	if (!objA||!objB||!objC||!objD) return;
	if (objA) {if (objA.id==eSrc.id&&objB.value!="") {g=1;var obj1=objA;var obj1c=objAc;var obj2=objC;var obj3=objB;var obj3c=objBc;var obj4=objD;}}
	if (objA) {if (objA.id==eSrc.id&&objA.value!="") {g=1;var obj1=objA;var obj1c=objAc;var obj2=objC;var obj3=objB;var obj3c=objBc;var obj4=objD;}}
	if (objB) {if ((objB.id==eSrc.id)&&(objA.value==""&&objB.value=="")) {g=1;var obj1=objB;var obj1c=objBc;var obj2=objD;var obj3=objA;var obj3c=objAc;var obj4=objC;}}
	//if (objB) {if ((objB.id==eSrc.id)&&(objA.value!=""&&objB.value=="")) {g=0;var obj1=objB;var obj1c=objBc;var obj2=objD;var obj3=objA;var obj3c=objAc;var obj4=objC;}}
	if (objB) {if ((objB.id==eSrc.id&&objB.value!="")) {g=1;var obj1=objB;var obj1c=objBc;var obj2=objD;var obj3=objA;var obj3c=objAc;var obj4=objC;}}
	if (g==0) return;
	if (obj1&&obj1.value=="") {
		//alert("dis")
		if (obj1c) obj1c.className="";
		if (obj2) obj2.value="";
		if (obj3) obj3.value="";
		if (obj4) obj4.value="";
		if (obj3c) obj3c.className="clsRequired";
	} else {
		//alert("adm")
		if (obj1c) obj1c.className="clsRequired";
		if (obj3) obj3.value="";
		if (obj4) obj4.value="";
		if (obj3c) obj3c.className=""; 
	} 
}
function checkMandatoryfields() {
	var msg="";
	var checkbox=0
	var objA=document.getElementById('dfrom');
	var objB=document.getElementById('DisDateFrom');
	var objC=document.getElementById('CurrentPatients');
	if (objC&&objC.checked==true) { checkbox=1 } 
	if (checkbox!=1) { 
		if ((objA&&objB)&&(objA.value==""&&objB.value=="")) { 
			msg += "\'" + t['dfrom'] + "\' " + t['XMISSING'] + "\n";
		}
	}
	
	if (msg != "") {
		alert(msg)
		return false;
	} else {
		return true;
	}
}

function HospBlurHandler() {
	var obj=document.getElementById("HOSPDesc");
	var objid=document.getElementById("HospitalID");
	if ((obj)&&(objid)&&(obj.value=="")) objid.value="";
}

function HOSPDescLookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("HospitalID");
	if (obj) obj.value=lu[1];
}

function UROnChangeHandler(evt) {
	if ((URobj)&&(URobj.value!="")) {}
}
function DateCheck(date) {	
	var dateArr=date.split("^");	
								
	var dateminObj=document.getElementById("dfrom");  
	if (dateminObj) dateminObj.value=dateArr[2];		
	alert("dateminObj.value"=dateminObj.value);
	
	var datemax=document.getElementById("dto");  
	if (datemax) datemax.value=dateArr[2];		
	alert("datemax.value"=datemax.value);
	
	///var RegistrationNumber=document.getElementById("PAPMINo");  
	///if (RegistrationNumber) RegistrationNumber.value=dateArr[1];		
	///alert("RegistrationNumber.value"=RegistrationNumber.value);	
}
//restrict the lookup on careproviders to specialists

function setConsultantFilter() {
	var obj=document.getElementById("conFlag"); 
	if (obj) obj.value="Y"
}

function LookUpURSelect(str) {
}

function PAPMINo_changehandler(encmeth) {
	var obj=document.getElementById('PAPMINo');
	var p1='';
	if (obj) p1=obj.value;
	var obj=document.getElementById('PAPMINo');
	if (cspRunServerMethod(encmeth,'','LookUpURSelect',p1)=='0') {
		obj.className='clsInvalid';
		obj.focus();
		return websys_cancel();
	} else {
		obj.className='';
	}
}

function SetBookingType() {
	var arrItems = new Array();
	var types="";
	var lst = document.getElementById("BookingType");
	var numberchosen=0
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			if (lst.options[j].selected) {
				numberchosen++;
				types = types + lst.options[j].value + "|"
			}
		}
		types=types.substring(0,(types.length-1));
		var obj=document.getElementById("SelBookingType");
		if (obj) obj.value=types;
	}
}

function LookupAdmissionType(str) {
	lu=str.split("^");
	//alert(str);
	var obj=document.getElementById("admType");
	if (obj) obj.value=lu[2];
}

function LookupVisitStatus(str) {
	lu=str.split("^");
	//alert(str);
	var obj=document.getElementById("VisitStatus");
	if (obj) obj.value=lu[2];
}

function AdmTypeBlurHandler() {
	var obj=document.getElementById("PAADMType");
	var objid=document.getElementById("admType");
	if ((obj)&&(objid)&&(obj.value=="")) objid.value="";
}

function VisitStatusBlurHandler() {
	var obj=document.getElementById("PAADMVisitStatus");
	var objid=document.getElementById("VisitStatus");
	if ((obj)&&(objid)&&(obj.value=="")) objid.value="";
}

function CareProvLookupSelect(str) {
	lu=str.split("^");
	var obj=document.getElementById("location");
	if (obj) obj.value=lu[2];
}

function LocationLookupSelect(str) {
	lu=str.split("^");
	var obj=document.getElementById("location");
	if (obj) obj.value=lu[1];
}


document.body.onload=documentLoadHandler;

