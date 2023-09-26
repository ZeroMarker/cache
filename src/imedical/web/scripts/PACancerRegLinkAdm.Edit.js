// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


setHospital();

//disable hospital field
function setHospital() {
	var obj=document.getElementById("HiddenHospital")
	var objh=document.getElementById('HOSPDesc');
	if (objh) {
		if (objh.value=="") objh.value=obj.value
		objh.disabled=true;
	}
}

function Init() {
	websys_firstfocus();

	var obj;

	//obj=document.getElementById('HARDel');
	//if (obj) obj.onclick=HARDeleteClickHandler;	

	//objHidden=document.getElementById('find1');
	//if (objHidden) objHidden.onclick= FindClickHandler;
	//if (tsc['find1']) websys_sckeys[tsc['find1']]=FindClickHandler;
	//alert("chris")
	//setConsultantFilter()
	//KK 31/01/05 L:48117
	var objAdm;
	objAdm=document.getElementById('PAADMADMNo');
	if ((objAdm)&&(objAdm.className=="clsInvalid")){
		objAdm.value="";
		objAdm.onchange();
	}
}

// Geographic Information
function CancerLookUp(str) {
	//EpisodeNo^CTLOC_Desc^CTPCP_Desc^WARDDesc^hosp
 	var lu = str.split("^");
	//alert("hello^" + str + "end||start" + lu[0] + ":" + lu[1] + ":" + lu[2] + ":" + lu[3] + ":" + lu[4]);
	//alert(lu[4])
	var obj=document.getElementById("HOSPDesc")
	if ((obj)&&(lu[4])) obj.value = lu[4];
	var obj=document.getElementById("HiddenHospital")
	if ((obj)&&(lu[4])) obj.value = lu[4];
	var obj=document.getElementById("EpisodeID")
	if ((obj)&&(lu[5])) obj.value = lu[5];
	
	//AJI L35869
	var obj=document.getElementById("FCEConsultant")
	if ((obj)&&(lu[4])) {
		obj.value = lu[2];
		obj.innerText = obj.value;  //L35869
	}

	//alert("atend");
}

function FCELookUp(str) {
	//EpisodeNo^CTLOC_Desc^CTPCP_Desc^WARDDesc^hosp
 	var lu = str.split("^");
	//alert("hello^" + str + "end||start" + lu[0] + ":" + lu[1] + ":" + lu[2] + ":" + lu[3] + ":" + lu[4]);
	//alert(lu[7])
	var obj=document.getElementById("FCESpecialty")
	if ((obj)&&(lu[4])) {
		obj.value = lu[2];
		obj.innerText = obj.value;   //AJI 27.10.03 L35869 - Set innerText so displayOnly option will work
	}
	var obj=document.getElementById("FCEConsultant")
	if ((obj)&&(lu[4])) {
		obj.value = lu[1];
		obj.innerText = obj.value;  //L35869
	}
	var obj=document.getElementById("admcod")
	if ((obj)&&(lu[4])) obj.value = lu[7];
}

document.body.onload=Init;