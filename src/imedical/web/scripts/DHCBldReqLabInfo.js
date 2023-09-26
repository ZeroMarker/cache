//ºÏ—È–≈œ¢
var LabBloodGroup=document.getElementById("BloodGroup");
var LabBloodRh=document.getElementById("BloodRh");
var LabOtherBlood=document.getElementById("OtherBlood");
var LabRBC=document.getElementById("RBC");
var LabHCT=document.getElementById("HCT");
var LabHb=document.getElementById("Hb");
var LabPLT=document.getElementById("PLT");
var LabALT=document.getElementById("ALT");
var LabHBeAg=document.getElementById("HBeAg");
var LabHBsAg=document.getElementById("HBsAg");
var LabAntiHBs=document.getElementById("AntiHBs");
var LabAntiHBe=document.getElementById("AntiHBe");
var LabAntiHBc=document.getElementById("AntiHBc");
var LabAntiHCV=document.getElementById("AntiHCV");
var LabAntiHIV=document.getElementById("AntiHIV");
var LabMD=document.getElementById("MD");
LabBloodGroup.readOnly=true;
LabBloodRh.readOnly=true;
LabRBC.readOnly=true;
LabHCT.readOnly=true;
LabHb.readOnly=true;
LabPLT.readOnly=true;
LabALT.readOnly=true;
LabHBeAg.readOnly=true;
LabHBsAg.readOnly=true;
LabAntiHBs.readOnly=true;
LabAntiHBe.readOnly=true;
LabAntiHBc.readOnly=true;
LabAntiHCV.readOnly=true;
LabAntiHIV.readOnly=true;
LabMD.readOnly=true;

function BodyLoadHandler() {
	var objAdmId=document.getElementById("admId");
	if ((objAdmId)&&(objAdmId.value!="")) {
		var curId="^"+objAdmId.value;
   	    getLabInfo(curId);
	} else {alert("patId not value!");}
}

function getLabInfo(patId){
	var obj=document.getElementById("GetLabInfo");
	if (obj) {var encmeth=obj.value} else {var encmeth=''};
	var myExpStr="";
	var LabInfoStr=cspRunServerMethod(encmeth,"","",patId);
	var LabInfo=LabInfoStr.split("^");
	LabBloodGroup.value=LabInfo[0];
	LabBloodRh.value=LabInfo[1];
	//LabOtherBlood.value=LabInfo[2];
	LabRBC.value=LabInfo[2];
	LabHCT.value=LabInfo[3];
	LabHb.value=LabInfo[4];
	LabPLT.value=LabInfo[5];
	LabALT.value=LabInfo[6];
	LabHBeAg.value=LabInfo[7];
	LabHBsAg.value=LabInfo[8];
	LabAntiHBs.value=LabInfo[9];
	LabAntiHBe.value=LabInfo[10];
	LabAntiHBc.value=LabInfo[11];
	LabAntiHCV.value=LabInfo[12];
	LabAntiHIV.value=LabInfo[13];
	LabMD.value=LabInfo[14];
}

document.body.onload = BodyLoadHandler;