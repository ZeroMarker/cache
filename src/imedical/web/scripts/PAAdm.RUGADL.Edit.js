// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function DocumentLoadHandler() {
	obj=document.getElementById("PCSDesc")
	if (obj) obj.onblur=AdmPalCareHandler

	obj=document.getElementById("BMDesc")
	if (obj) obj.onblur=AdmBedMobHandler

	obj=document.getElementById("TOILDesc")
	if (obj) obj.onblur=AdmToilHandler

	obj=document.getElementById("TRANSFDesc")
	if (obj) obj.onblur=AdmTransHandler

	obj=document.getElementById("EATDesc")
	if (obj) obj.onblur=AdmEatHandler

	obj=document.getElementById("DISPCSDesc")
	if (obj) obj.onblur=DisPalCareHandler

	obj=document.getElementById("DISBMDesc")
	if (obj) obj.onblur=DisBedMobHandler

	obj=document.getElementById("DISTOILDesc")
	if (obj) obj.onblur=DisToilHandler

	obj=document.getElementById("DISTRANSFDesc")
	if (obj) obj.onblur=DisTransHandler

	obj=document.getElementById("DISEATDesc")
	if (obj) obj.onblur=DisEatHandler
}

function AdjustAdmTotalScore() {
	objTotal=document.getElementById("PAADMRUGTotal")
	if ((objTotal)&&(objTotal.value=="")) objTotal.value=0
	objPalCare=document.getElementById("AdmPalCareScore")
	if ((objPalCare)&&(objPalCare.value=="")) objPalCare.value=0
	objBedMob=document.getElementById("AdmBedMobScore")
	if ((objBedMob)&&(objBedMob.value=="")) objBedMob.value=0
	objToil=document.getElementById("AdmToilScore")
	if ((objToil)&&(objToil.value=="")) objToil.value=0
	objTrans=document.getElementById("AdmTransScore")
	if ((objTrans)&&(objTrans.value=="")) objTrans.value=0
	objEat=document.getElementById("AdmEatScore")
	if ((objEat)&&(objEat.value=="")) objEat.value=0
	//alert(objPalCare.value+" "+objBedMob.value+" "+objToil.value+" "+objTrans.value+" "+objEat.value)
	objTotal.value=parseInt(objPalCare.value)+parseInt(objBedMob.value)+parseInt(objToil.value)+parseInt(objTrans.value)+parseInt(objEat.value)
}

function AdjustDisTotalScore() {
	objTotal=document.getElementById("DischRUGTotal")
	if ((objTotal)&&(objTotal.value=="")) objTotal.value=0
	objPalCare=document.getElementById("DisPalCareScore")
	if ((objPalCare)&&(objPalCare.value=="")) objPalCare.value=0
	objBedMob=document.getElementById("DisBedMobScore")
	if ((objBedMob)&&(objBedMob.value=="")) objBedMob.value=0
	objToil=document.getElementById("DisToilScore")
	if ((objToil)&&(objToil.value=="")) objToil.value=0
	objTrans=document.getElementById("DisTransScore")
	if ((objTrans)&&(objTrans.value=="")) objTrans.value=0
	objEat=document.getElementById("DisEatScore")
	if ((objEat)&&(objEat.value=="")) objEat.value=0
	//alert(objPalCare.value+" "+objBedMob.value+" "+objToil.value+" "+objTrans.value+" "+objEat.value)
	objTotal.value=parseInt(objPalCare.value)+parseInt(objBedMob.value)+parseInt(objToil.value)+parseInt(objTrans.value)+parseInt(objEat.value)
}

function AdjustIndividualScore(val,score) {
	objVal=document.getElementById(val)
	obj=document.getElementById(score)
	if ((obj)&&(objVal)&&(objVal.value=="")) obj.value="";
}

// Admission Column Fields --------------------------------

function AdmPalCareHandler() {
	AdjustIndividualScore("PCSDesc","AdmPalCareScore");
	AdjustAdmTotalScore();
}

function AdmBedMobHandler() {
	AdjustIndividualScore("BMDesc","AdmBedMobScore");
	AdjustAdmTotalScore();
}

function AdmToilHandler() {
	AdjustIndividualScore("TOILDesc","AdmToilScore");
	AdjustAdmTotalScore();
}

function AdmTransHandler() {
	AdjustIndividualScore("TRANSFDesc","AdmTransScore");
	AdjustAdmTotalScore();
}

function AdmEatHandler() {
	AdjustIndividualScore("EATDesc","AdmEatScore");
	AdjustAdmTotalScore();
}

//------------------------------------

function AdmPalCareLookUp(str) {
	var lu = str.split("^");
	obj=document.getElementById("PCSDesc")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("AdmPalCareScore")
	if (obj) obj.value = lu[2]
	AdjustAdmTotalScore();
}

function AdmBedMobLookUp(str) {
	var lu = str.split("^");
	obj=document.getElementById("BMDesc")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("AdmBedMobScore")
	if (obj) obj.value = lu[2]
	AdjustAdmTotalScore();
}

function AdmToilLookUp(str) {
	var lu = str.split("^");
	obj=document.getElementById("TOILDesc")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("AdmToilScore")
	if (obj) obj.value = lu[2]
	AdjustAdmTotalScore();
}

function AdmTransLookUp(str) {
	var lu = str.split("^");
	obj=document.getElementById("TRANSFDesc")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("AdmTransScore")
	if (obj) obj.value = lu[2]
	AdjustAdmTotalScore();
}

function AdmEatLookUp(str) {
	var lu = str.split("^");
	obj=document.getElementById("EATDesc")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("AdmEatScore")
	if (obj) obj.value = lu[2]
	AdjustAdmTotalScore();
}

// Discharge Column Fields
//------------------------------------

function DisPalCareHandler() {
	AdjustIndividualScore("DISPCSDesc","DisPalCareScore");
	AdjustDisTotalScore();
}

function DisBedMobHandler() {
	AdjustIndividualScore("DISBMDesc","DisBedMobScore");
	AdjustDisTotalScore();
}

function DisToilHandler() {
	AdjustIndividualScore("DISTOILDesc","DisToilScore");
	AdjustDisTotalScore();
}

function DisTransHandler() {
	AdjustIndividualScore("DISTRANSFDesc","DisTransScore");
	AdjustDisTotalScore();
}

function DisEatHandler() {
	AdjustIndividualScore("DISEATDesc","DisEatScore");
	AdjustDisTotalScore();
}

//------------------------------------

function DisPalCareLookUp(str) {
	var lu = str.split("^");
	obj=document.getElementById("DISPCSDesc")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("DisPalCareScore")
	if (obj) obj.value = lu[2]
	AdjustDisTotalScore();
}


function DisBedMobLookUp(str) {
	var lu = str.split("^");
	obj=document.getElementById("DISBMDesc")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("DisBedMobScore")
	if (obj) obj.value = lu[2]
	AdjustDisTotalScore();
}

function DisToilLookUp(str) {
	var lu = str.split("^");
	obj=document.getElementById("DISTOILDesc")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("DisToilScore")
	if (obj) obj.value = lu[2]
	AdjustDisTotalScore();
}

function DisTransLookUp(str) {
	var lu = str.split("^");
	obj=document.getElementById("DISTRANSFDesc")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("DisTransScore")
	if (obj) obj.value = lu[2]
	AdjustDisTotalScore();
}

function DisEatLookUp(str) {
	var lu = str.split("^");
	obj=document.getElementById("DISEATDesc")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("DisEatScore")
	if (obj) obj.value = lu[2]
	AdjustDisTotalScore();
}

document.body.onload=DocumentLoadHandler;