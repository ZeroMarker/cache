// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function CTLOCDescLookUpSelect(str) {
	var lu = str.split("^");
	//alert(str)
	var obj=document.getElementById('CTLOCDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('LocId');
	if (obj) obj.value=lu[1];
	var objResDesc=document.getElementById('RESDesc');
	if ((objResDesc) && (lu[5]!="")) objResDesc.value=lu[5].split("*")[0];
	var obj=document.getElementById('RescID');
	if ((obj) && (lu[5]!="")) obj.value=lu[5].split("*")[1];
	var obj=document.getElementById('SERDesc');
	if ((obj) && (lu[5]!="")) obj.value=lu[5].split("*")[2];
	var obj=document.getElementById('ServID');
	if ((obj) && (lu[5]!="")) obj.value=lu[5].split("*")[3];
	var obj=document.getElementById('HOSPDesc')
	if (obj) obj.value=lu[4];
	var obj=document.getElementById('HOSPId')
	if (obj) obj.value=lu[7];
	if (objResDesc) objResDesc.onchange()
}

function ServiceLookUpSelect(str) {
    var obj;
    var lu = str.split("^");
    obj=document.getElementById('RESDesc')
    if (obj="") obj.value=lu[1];
	var obj=document.getElementById('RescID');
	if (obj="") obj.value=lu[1];
	var obj=document.getElementById('CTLOCDesc');
	if (obj="") obj.value=lu[1];
	var obj=document.getElementById('LocId');
	if (obj="") obj.value=lu[1];
    var obj=document.getElementById('SERDesc')
    if (obj) obj.value=lu[1];
	if (lu[3]=="SS") {
		var obj=document.getElementById('SSServId');
		if (obj) obj.value=lu[3];
		var obj=document.getElementById('SSFlag');
		if (obj) obj.value=lu[4];
	} else {
		var obj=document.getElementById('ServID');
		if (obj) obj.value=lu[3];
	}
}

function ResourceLookUpSelect(str) {
	var lu = str.split("^");
	//alert(str)
	var obj=document.getElementById('RESDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('RescID');
	if (obj) obj.value=lu[2];
	var obj=document.getElementById('SERDesc');
	if (obj) {
		obj.value="";
		if (lu[0]!="") obj.value=lu[4];
	}
	var obj=document.getElementById('ServId');
	if (obj) {
		obj.value="";
		if (lu[0]!="") obj.value=lu[3];
	}
	/* SB 13/03/03: Why would we set all these fields to the same piece (lu[4])???
	var obj=document.getElementById('CTLOCDesc');
	if (obj="") obj.value=lu[4];
	var obj=document.getElementById('LocId');
	if (obj="") obj.value=lu[4];
	var obj=document.getElementById('SERDesc');
	if (obj="") obj.value=lu[4];
	var obj=document.getElementById('ServID');
	if (obj="") obj.value=lu[4];
	*/
}

function LocTextBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('LocId');
		if (obj) obj.value=""
	}
}

function ResTextBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('ResId');
		if (obj) obj.value="";
	}
}

function SerTextBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('ServId');
		if (obj) obj.value=""
	}
}

function HospTextBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('HOSPId');
		if (obj) obj.value=""
	}
}

function ValidateFind() {
    var frm = document.forms['fRBResEffDateSessServices_Find'];
    if ((frm.PatientID.value != "")&&(frm.BookingType.value != "OP")&&(frm.SERDesc && frm.SERDesc.value == "")) {
		alert("'"+t['SERDesc']+"' "+t['RBRequired']+"\n")
        return false;
    }
	var loc=document.getElementById('CTLOCDesc');
	var res=document.getElementById('RESDesc');
	var ser=document.getElementById('SERDesc');
	if (evtTimer) {
		setTimeout('ValidateFind()',250)
	} else {
		if((frm.SERDesc && frm.SERDesc.value=="")&&(frm.RESDesc && frm.RESDesc.value=="")&&(frm.CTLOCDesc && frm.CTLOCDesc.value=="")||(((loc && loc.className=="clsInvalid") || (res && res.className=="clsInvalid")) || (ser && ser.className=="clsInvalid"))) {
			alert(t['RBEnterOne']+" "+t['CTLOCDesc']+", "+t['RESDesc']+", "+t['SERDesc'])
			return false;
		}
		Find_click();
	    return false;
	}
	//49846
	/*
	if (evtTimer) {
		setTimeout('ValidateFind()',250)
	} else {
		if ((loc.className=="clsInvalid")&&(frm.SERDesc && frm.SERDesc.value=="")&&(frm.RESDesc && frm.RESDesc.value=="")) {
			alert(t['RBEnterOne']+" "+t['CTLOCDesc']+", "+t['RESDesc']+", "+t['SERDesc'])
			return false;
		} else if ((res.className=="clsInvalid")&&(frm.SERDesc && frm.SERDesc.value=="")&&(frm.CTLOCDesc && frm.CTLOCDesc.value=="")) {
			alert(t['RBEnterOne']+" "+t['CTLOCDesc']+", "+t['RESDesc']+", "+t['SERDesc'])
			return false;
		} else if ((ser.className=="clsInvalid")&&(frm.RESDesc && frm.RESDesc.value=="")&&(frm.CTLOCDesc && frm.CTLOCDesc.value=="")) {
			alert(t['RBEnterOne']+" "+t['CTLOCDesc']+", "+t['RESDesc']+", "+t['SERDesc'])
			return false;
		}
    	Find_click();
	    return false;
	}
	*/
}

function ResourceChangeHandler() {
	var obj=document.getElementById('CTLOCDesc')
	var res=document.getElementById('RESDesc')
	var ser=document.getElementById('SERDesc')
	if ((obj) && (res) && (ser)) {
		res.value=""
		ser.value=""
	}
    obj=document.getElementById("SERDesc")
    if (obj) obj.value=""
}

function LocationChangeHandler() {
	var obj=document.getElementById('CTLOCDesc')
	var res=document.getElementById('RESDesc')
	var ser=document.getElementById('SERDesc')
	if ((obj) && (res) && (ser)) {
		//res.value=""
		ser.value=""
	}
    obj=document.getElementById("SERDesc")
    if (obj) obj.value=""
    //obj=document.getElementById("RESDesc")
    //if (obj) obj.value=""
}

function LocationTextChangeHandler() {
	//SB 12/06/02: This function is called from CTLoc.LookUpBrokerLoc, as the onchange handler overwrites the broker method.
	var obj=document.getElementById('CTLOCDesc')
	var res=document.getElementById('RESDesc')
	var ser=document.getElementById('SERDesc')
	if ((obj) && (res) && (ser)) {
		//res.value=""
		ser.value=""
		var obj=document.getElementById('LocId');
		if (obj) obj.value=""
		//var obj=document.getElementById('ResId');
		//if (obj) obj.value="";
		var obj=document.getElementById('ServId');
		if (obj) obj.value=""
	}
	//obj.style.color = "black";
}

function ResourceTextChangeHandler() {
	//SB 12/06/02: This function is called from RBResource.LookUpBrokerRes, as the onchange handler overwrites the broker method.
	var obj=document.getElementById('CTLOCDesc')
	var res=document.getElementById('RESDesc')
	var ser=document.getElementById('SERDesc')
	if ((obj) && (res) && (ser)) {
		//res.value=""
		ser.value=""
		var obj=document.getElementById('ServId');
		if (obj) obj.value=""
	}
}

function ServiceTextChangeHandler() {
	//SB 12/06/02: This function is called from RBAppointment.LookUpBrokerServ, as the onchange handler overwrites the broker method.
	var obj=document.getElementById('OrderItemMess')
	if (obj) obj.value="";
}

function BodyLoadHandler() {
    var frm = document.forms['fRBResEffDateSessServices_Find'];
    // LOG 27955 BC 30-8-2002 Used to allow the page not to require refresh.  Can only be used as a small amount of data is being sent
    //if (frm) {frm.method="GET";}
    if (frm.PatientID.value != "") {
	//var obj=document.getElementById('cSERDesc');
	//if (obj) {
        //   obj.className = "clsRequired";
        //}
    }

    obj=document.getElementById('CTLOCDesc');
	if (obj) obj.onblur = LocTextBlurHandler;


	obj=document.getElementById('RESDesc');
	if (obj) obj.onblur = ResTextBlurHandler;

	obj=document.getElementById('SERDesc');
	if (obj) obj.onblur = SerTextBlurHandler;

	obj=document.getElementById('HOSPDesc');
	if (obj) obj.onblur = HospTextBlurHandler;

    var obj=document.getElementById('Find');
    if (obj) obj.onclick = ValidateFind;
	if (tsc['Find']) websys_sckeys[tsc['Find']]=ValidateFind;
}

function HospLookup(str) {
	var lu = str.split("^");
	//alert(lu);
	var obj=document.getElementById('HOSPId');
	if (obj) obj.value=lu[1];

	return;
}

document.body.onload = BodyLoadHandler;
