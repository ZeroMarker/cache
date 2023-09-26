// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// Created 13/5/2005 JPD

function BodyOnloadHandler() {
	obj=document.getElementById("Update")
	if (obj) {
		obj.disabled=false;
		obj.onclick=UpdateClickHandler;
	}
	if (tsc['Update']) {
		websys_sckeys[tsc['Update']]=UpdateClickHandler;
	}

	//Initialising Totals for diet order sets.
	var tbl=document.getElementById("tARCOrdSetDateItem_List");
	TotKJ=document.getElementById("TotEnKJ");
	TotKJ.value=0;
	TotCal=document.getElementById("TotEnCal");
	TotCal.value=0;
	TotProt=document.getElementById("TotProt");
	TotProt.value=0;
	TotTFat=document.getElementById("TotTFat");
	TotTFat.value=0;
	TotSFat=document.getElementById("TotSFat");
	TotSFat.value=0;
	TotCarb=document.getElementById("TotCarb");
	TotCarb.value=0;
	TotSugar=document.getElementById("TotSugar");
	TotSugar.value=0;
	TotSod=document.getElementById("TotSod");
	TotSod.value=0;
	TotFibre=document.getElementById("TotFib");
	TotFibre.value=0;
	TotOther=document.getElementById("TotOther");
	TotOther.value=0;
	for (i=1; i<tbl.rows.length; i++) {
		AllTotals(i);
	}
	var ITMQty=document.getElementById("ITMQty");
	if (ITMQty) ITMQty.onchange=QTYChangeHandler;

	var VisObj=document.getElementById("ITMVisible");
	if (VisObj) {
		VisibleChangeHandler();
		VisObj.onclick=VisibleChangeHandler;
	}
}

function VisibleChangeHandler(){
	var VisObj=document.getElementById("ITMVisible");
	var BillItmObj=document.getElementById("ITMLinkToVisibleItem");
	if (BillItmObj && VisObj.checked) { 
		BillItmObj.className="";
	} else if (BillItmObj) {
		BillItmObj.className="clsRequired";
	}
	return;
}

function QTYChangeHandler(){
	//Log 61118 27-09-2006 Boc: check if the entered quantity is float
	Qty=document.getElementById("ITMQty");
	if (Qty) Qty.className="";
	if (Qty && isNaN(Qty.value)) {
		Qty.className="clsInvalid";
		return false;
	}

	var tbl=document.getElementById("tARCOrdSetDateItem_List");
	var ItemID=document.getElementById("ItemID");
	TotKJ=document.getElementById("TotEnKJ");
	TotKJ.value=0;
	TotCal=document.getElementById("TotEnCal");
	TotCal.value=0;
	TotProt=document.getElementById("TotProt");
	TotProt.value=0;
	TotTFat=document.getElementById("TotTFat");
	TotTFat.value=0;
	TotSFat=document.getElementById("TotSFat");
	TotSFat.value=0;
	TotCarb=document.getElementById("TotCarb");
	TotCarb.value=0;
	TotSugar=document.getElementById("TotSugar");
	TotSugar.value=0;
	TotSod=document.getElementById("TotSod");
	TotSod.value=0;
	TotFibre=document.getElementById("TotFib");
	TotFibre.value=0;
	TotOther=document.getElementById("TotOther");
	TotOther.value=0;

	for (i=1; i<tbl.rows.length; i++) {
		var ItemRow=document.getElementById("ITMRowIdz"+i);
		if (ItemID) if (ItemID.value!=ItemRow.value) AllTotals(i);
	}
	if (ItemID){
	//Now must calculate new values for item column - and add them to existing total's
	//Log 61118 27-09-2006 Boc: don't calculate if not a number
		//Qty=document.getElementById("ITMQty");
		Qty=Qty.value;
		Qty=parseFloat(Qty);
		KJ=document.getElementById("KJ");
		KJ=KJ.value;
		KJ=parseFloat(KJ);
		ItmKJ=document.getElementById("ItmEnKJ");
		if (!isNaN(KJ)) {
			ItmKJ.value=Qty*KJ;
			TotKJ.value=parseFloat(TotKJ.value)+parseFloat(ItmKJ.value);
		}
		Cal=document.getElementById("Cal");
		Cal=Cal.value;
		Cal=parseFloat(Cal);
		ItmCal=document.getElementById("ItmEnCal");
		if (!isNaN(Cal)){
			ItmCal.value=Qty*Cal;
			TotCal.value=parseFloat(TotCal.value)+parseFloat(ItmCal.value);
		}
		Prot=document.getElementById("Prot");
		Prot=Prot.value;
		Prot=parseFloat(Prot);
		ItmProt=document.getElementById("ItmProtein");
		if (!isNaN(Prot)){
			ItmProt.value=Qty*Prot;
			TotProt.value=parseFloat(TotProt.value)+parseFloat(ItmProt.value);
		}
		TFat=document.getElementById("TFat");
		TFat=TFat.value;
		TFat=parseFloat(TFat);
		ItmTFat=document.getElementById("ItmTotFat");
		if (!isNaN(TFat)){
			ItmTFat.value=Qty*TFat;
			TotTFat.value=parseFloat(TotTFat.value)+parseFloat(ItmTFat.value);
		}
		SFat=document.getElementById("SFat");
		SFat=SFat.value;
		SFat=parseFloat(SFat);
		ItmSFat=document.getElementById("ItmSatFat");
		if (!isNaN(SFat)){
			ItmSFat.value=Qty*SFat;
			TotSFat.value=parseFloat(TotSFat.value)+parseFloat(ItmSFat.value);
		}
		Carb=document.getElementById("Carb");
		Carb=Carb.value;
		Carb=parseFloat(Carb);
		ItmCarb=document.getElementById("ItmCarbs");
		if (!isNaN(Carb)){
			ItmCarb.value=Qty*Carb;
			TotCarb.value=parseFloat(TotCarb.value)+parseFloat(ItmCarb.value);
		}
		Sugar=document.getElementById("Sugar");
		Sugar=Sugar.value;
		Sugar=parseFloat(Sugar);
		ItmSugar=document.getElementById("ItmSugar");
		if (!isNaN(Sugar)){
			ItmSugar.value=Qty*Sugar;
			TotSugar.value=parseFloat(TotSugar.value)+parseFloat(ItmSugar.value);
		}
		Sodium=document.getElementById("Sodium");
		Sodium=Sodium.value;
		Sodium=parseFloat(Sodium);
		ItmSodium=document.getElementById("ItmSodium");
		if (!isNaN(Sodium)){
			ItmSodium.value=Qty*Sodium;
			TotSod.value=parseFloat(TotSod.value)+parseFloat(ItmSodium.value);
		}
		Fibre=document.getElementById("Fibre");
		Fibre=Fibre.value;
		Fibre=parseFloat(Fibre);
		ItmFibre=document.getElementById("ItmFibre");
		if (!isNaN(Fibre)){
			ItmFibre.value=Qty*Fibre;
			TotFibre.value=parseFloat(TotFibre.value)+parseFloat(ItmFibre.value);
		}
		Other=document.getElementById("Other");
		Other=Other.value;
		Other=parseFloat(Other);
		ItmOther=document.getElementById("ItmOther");
		if (!isNaN(Other)){
			ItmOther.value=Qty*Other;
			TotOther.value=parseFloat(TotOther.value)+parseFloat(ItmOther.value);
		}
	}

	return;
}

function AllTotals(i){
	var QTY="";
	QTY=document.getElementById("qty1z"+i);
	if (QTY) QTY=QTY.value;
	var KJ="";
	KJ=document.getElementById("KJz"+i);
	if (KJ) KJ=KJ.value;
	if (KJ && QTY && TotKJ.value) TotKJ.value=parseFloat(TotKJ.value)+(parseFloat(QTY)*parseFloat(KJ));
	var Cal="";
	Cal=document.getElementById("Calz"+i);
	if (Cal) Cal=Cal.value;
	if (Cal && QTY && TotCal.value) TotCal.value=parseFloat(TotCal.value)+(parseFloat(QTY)*parseFloat(Cal));
	var Prot="";
	Prot=document.getElementById("Protz"+i);
	if (Prot) Prot=Prot.value;
	if (Prot && QTY && TotProt.value) TotProt.value=parseFloat(TotProt.value)+(parseFloat(QTY)*parseFloat(Prot));
	var TFat="";
	TFat=document.getElementById("TFatz"+i);
	if (TFat) TFat=TFat.value;
	if (TFat && QTY && TotTFat.value) TotTFat.value=parseFloat(TotTFat.value)+(parseFloat(QTY)*parseFloat(TFat));
	var SFat="";
	SFat=document.getElementById("SFatz"+i);
	if (SFat) SFat=SFat.value;
	if (SFat && QTY && TotSFat.value) TotSFat.value=parseFloat(TotSFat.value)+(parseFloat(QTY)*parseFloat(SFat));
	var Carb="";
	Carb=document.getElementById("Carbz"+i);
	if (Carb) Carb=Carb.value;
	if (Carb && QTY && TotCarb.value) TotCarb.value=parseFloat(TotCarb.value)+(parseFloat(QTY)*parseFloat(Carb));
	var Sugar="";
	Sugar=document.getElementById("Sugarz"+i);
	if (Sugar) Sugar=Sugar.value;
	if (Sugar && QTY && TotSugar.value) TotSugar.value=parseFloat(TotSugar.value)+(parseFloat(QTY)*parseFloat(Sugar));
	var Sod="";
	Sod=document.getElementById("Sodiumz"+i);
	if (Sod) Sod=Sod.value;
	if (Sod && QTY && TotSod.value) TotSod.value=parseFloat(TotSod.value)+(parseFloat(QTY)*parseFloat(Sod));
	var Fibre="";
	Fibre=document.getElementById("Fibrez"+i);
	if (Fibre) Fibre=Fibre.value;
	if (Fibre && QTY && TotFibre.value) TotFibre.value=parseFloat(TotFibre.value)+(parseFloat(QTY)*parseFloat(Fibre));
	var Other="";
	Other=document.getElementById("Otherz"+i);
	if (Other) Other=Other.value;
	if (Other && QTY && TotOther.value) TotOther.value=parseFloat(TotOther.value)+(parseFloat(QTY)*parseFloat(Other));
	return;
}

function UpdateClickHandler(){

	var BillItmObj=document.getElementById("ITMLinkToVisibleItem");
	if (BillItmObj && BillItmObj.className=="clsRequired") {
		alert(t['ITMLinkToVisibleItem']+" "+t['LINKREQ']);
		return;
	}

	var onPage=document.getElementById("onPage");
	if (document.getElementById("ITMVisible")) onPage.value=onPage.value+"^ITMVisible";
	if (document.getElementById("ITMDayIncrement")) onPage.value=onPage.value+"^ITMDayIncrement";
	if (document.getElementById("ITMLinkDoctor")) onPage.value=onPage.value+"^ITMLinkDoctor";
	if (document.getElementById("ITMLinkToVisibleItem")) onPage.value=onPage.value+"^ITMLinkToVisibleItem";
	if (document.getElementById("ITMQty")) onPage.value=onPage.value+"^ITMQty";
	if (document.getElementById("Item")) onPage.value=onPage.value+"^ITMARCIMDR";

	Update_click();
}

function ItemLookupHandler (str){
	//Log 61118 27-09-2006 Boc: reset when changing item
	ItmKJ=document.getElementById("ItmEnKJ");
	ItmKJ.value="";
	ItmCal=document.getElementById("ItmEnCal");
	ItmCal.value="";
	ItmProt=document.getElementById("ItmProtein");
	ItmProt.value="";
	ItmTFat=document.getElementById("ItmTotFat");
	ItmTFat.value="";
	ItmSFat=document.getElementById("ItmSatFat");
	ItmSFat.value="";
	ItmCarb=document.getElementById("ItmCarbs");
	ItmCarb.value="";
	ItmSugar=document.getElementById("ItmSugar");
	ItmSugar.value="";
	ItmSodium=document.getElementById("ItmSodium");
	ItmSodium.value="";
	ItmFibre=document.getElementById("ItmFibre");
	ItmFibre.value="";
	ItmOther=document.getElementById("ItmOther");
	ItmOther.value="";

	if (str) {
		var arr=str.split("^");
		var arcimID=document.getElementById("ITMARCIMDR");
		if (arcimID) arcimID.value=arr[1];
	
	}

	var Qty=document.getElementById("ITMQty");
	if (Qty && (Qty.value=="")) Qty.value=1;

	//Log 61118 27-09-2006 Boc: get nutritional values
	//lu: ^EnergyKj^EnergyCal^ProteinG^TotalFatG^SaturatedFatsG^CarbohydratesG^SugarsG^SodiumMg^DietryFibreG^OtherG first piece is blank
	var lu=""
	lu = tkMakeServerCall("web.ARCOrdSetDateItem","GetNutritionalValues",arr[1])
	var KJ=document.getElementById("KJ");
	if (KJ) KJ.value=mPiece(lu,"^",1);
	Cal=document.getElementById("Cal");
	if (Cal) Cal.value=mPiece(lu,"^",2);
	Prot=document.getElementById("Prot");
	if (Prot) Prot.value=mPiece(lu,"^",3);
	TFat=document.getElementById("TFat");
	if (TFat) TFat.value=mPiece(lu,"^",4);
	SFat=document.getElementById("SFat");
	if (SFat) SFat.value=mPiece(lu,"^",5);
	Carb=document.getElementById("Carb");
	if (Carb) Carb.value=mPiece(lu,"^",6);
	Sugar=document.getElementById("Sugar");
	if (Sugar) Sugar.value=mPiece(lu,"^",7);
	Sod=document.getElementById("Sodium");
	if (Sod) Sod.value=mPiece(lu,"^",8);
	Fibre=document.getElementById("Fibre");
	if (Fibre) Fibre.value=mPiece(lu,"^",9);
	Other=document.getElementById("Other");
	if (Other) Other.value=mPiece(lu,"^",10);
	//alert (KJ.value+";"+Cal.value+";"+Prot.value+";"+TFat.value+";"+SFat.value+";"+Carb.value+";"+Sugar.value+";"+Sod.value+";"+Fibre.value+";"+Other.value);
	QTYChangeHandler();

	return;

}

function mPiece(s1,sep,n) {
    delimArray = s1.split(sep);
    if ((n <= delimArray.length-1) && (n >= 0)) return delimArray[n];
}

//log 61567 BoC: clear out item nutritiional values and reset total values when clearing out Item field
function checkBlank() {
	var Itemobj=document.getElementById("Item");
	if ((Itemobj)&&(Itemobj.value=="")){
		ItmKJ=document.getElementById("ItmEnKJ");
		ItmKJ.value="";
		ItmCal=document.getElementById("ItmEnCal");
		ItmCal.value="";
		ItmProt=document.getElementById("ItmProtein");
		ItmProt.value="";
		ItmTFat=document.getElementById("ItmTotFat");
		ItmTFat.value="";
		ItmSFat=document.getElementById("ItmSatFat");
		ItmSFat.value="";
		ItmCarb=document.getElementById("ItmCarbs");
		ItmCarb.value="";
		ItmSugar=document.getElementById("ItmSugar");
		ItmSugar.value="";
		ItmSodium=document.getElementById("ItmSodium");
		ItmSodium.value="";
		ItmFibre=document.getElementById("ItmFibre");
		ItmFibre.value="";
		ItmOther=document.getElementById("ItmOther");
		ItmOther.value="";
		var KJ=document.getElementById("KJ");
		if (KJ) KJ.value="";
		Cal=document.getElementById("Cal");
		if (Cal) Cal.value="";
		Prot=document.getElementById("Prot");
		if (Prot) Prot.value="";
		TFat=document.getElementById("TFat");
		if (TFat) TFat.value="";
		SFat=document.getElementById("SFat");
		if (SFat) SFat.value="";
		Carb=document.getElementById("Carb");
		if (Carb) Carb.value="";
		Sugar=document.getElementById("Sugar");
		if (Sugar) Sugar.value="";
		Sod=document.getElementById("Sodium");
		if (Sod) Sod.value="";
		Fibre=document.getElementById("Fibre");
		if (Fibre) Fibre.value="";
		Other=document.getElementById("Other");
		if (Other) Other.value="";
		var ITMQty=document.getElementById("ITMQty");
		if (ITMQty) {
			ITMQty.value="";
			QTYChangeHandler();
		}
	}
}

document.body.onload=BodyOnloadHandler;
var Itemobj=document.getElementById("Item");
if (Itemobj) Itemobj.onblur=checkBlank;