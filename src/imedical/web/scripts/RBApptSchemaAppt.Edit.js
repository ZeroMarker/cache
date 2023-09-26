//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


function BodyLoadHandler() {
	var obj=document.getElementById('RBASAHosp');
	if (obj) obj.onblur=HospBlurHandler;
	var obj=document.getElementById('RBASALoc');
	if (obj) obj.onblur=LocBlurHandler;
	var obj=document.getElementById('RBASARes');
	if (obj) obj.onblur=ResBlurHandler;
	var obj=document.getElementById('RBASAServ');
	if (obj) obj.onblur=ServBlurHandler;
	var obj=document.getElementById('RBASAWLLoc');
	if (obj) obj.onblur=WLLocBlurHandler;
	var obj=document.getElementById('RBASACareProv');
	if (obj) obj.onblur=CPBlurHandler;
	var obj=document.getElementById('RBASAWLHosp');
	if (obj) obj.onblur=WLHospBlurHandler;
	var obj=document.getElementById('RBASAOrdDel');
	if (obj) obj.onclick=DeleteOrderClickHandler;
	var obj=document.getElementById('RBASAUpd');
	if (obj) obj.onclick=UpdateClickHandler;

	PopulateOrderList();
}

function UpdateClickHandler() {
	var lstOrders=document.getElementById('RBASAOrdLst');
	var flag=new Array("N","N","N"); var strOrders="";
	if (document.getElementById('RBASAddSer').checked==true) {flag[0]="Y";}
	if (document.getElementById('RBASAddWL').checked==true) {flag[1]="Y";}
	if (document.getElementById('RBASAddOrd').checked==true) {flag[2]="Y";}
	for (var i=0;i<lstOrders.length; i++) {
		strOrders=strOrders+lstOrders.options[i].value+"*";
	}
	var flags=flag[0]+"^"+flag[1]+"^"+flag[2]
	document.getElementById('OrderString').value=strOrders;
	document.getElementById('AddToAllAppFlags').value=flags;
	return RBASAUpd_click();
}

function HospitalLookupSelect(txt) {
	var adata=txt.split("^");
	ClearLocAndResAndServ();

	var obj=document.getElementById("RBASAHosp");
	if (obj) obj.value=adata[0];
	var obj=document.getElementById("APHospitalDR");
	if (obj) obj.value=adata[1];
}

function CTLOCDescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('RBASALoc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('APCTLOCDR');
	if (obj) obj.value=lu[1];
}

function RESDescLookUpSelect(str) {
	var lu = str.split("^");
	var objres=document.getElementById('RBASARes');
	if (objres) objres.value=lu[0];
	var obj=document.getElementById('APResourceDR');
	if (obj) {
		if (lu[2]=="") {
			if (objres) objres.value=""
			obj.value=""
		} else {
			obj.value=lu[2];
		}
	}
}

function SERDescLookUpSelect(str) {
	var lu = str.split("^");
	var char4=String.fromCharCode(4)
	var SScheck=""
	var obj=document.getElementById('RBASAServ');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('APServiceDR');
	if (obj) obj.value=mPiece(lu[3],char4,0)
}

function WLTypeLookUpHandler(str) {
 	var lu = str.split("^");
	var obj;
	if (lu[2]!="") {
		obj=document.getElementById("RBASAWLLoc");
		if (obj) obj.value = lu[2];
	}
	if (lu[3]!="") {
		obj=document.getElementById("RBASACareProv");
		if (obj) obj.value = lu[3];
	}
	if (lu[4]!="") {
		obj=document.getElementById("RBASAWLHosp");
		if (obj) obj.value = lu[4];
	}
	if (lu[5]!="") {
		obj=document.getElementById("APWLCTLOCDR");
		if (obj) obj.value = lu[5];
	}
}

function StatusLookUp(str) {
	var lu = str.split("^");
	var objStatus=document.getElementById('RBASAStat');
	if (objStatus) objStatus.value=lu[1];
}

function LocationLookUp(str) {
	var lu = str.split("^");
	var obj=document.getElementById('RBASAWLLoc')
	if (obj) obj.value=lu[1]
	var obj=document.getElementById('APWLCTLOCDR');
	if (obj) obj.value=lu[3];
    var obj=document.getElementById('RBASAWLHosp');
	if (obj) obj.value=lu[6];
    var obj=document.getElementById('APWLHospitalDR');
	if (obj) obj.value=lu[7];
}

function CareProvLookUp(str) {
	var lu = str.split("^");
	var obj=document.getElementById('RBASACareProv')
	if (obj) obj.value=lu[0]
	var obj=document.getElementById('APWLCareProvDR');
	if (obj) obj.value=lu[8];
    var obj=document.getElementById('RBASAWLLoc');
	if (obj) obj.value=lu[2];
	var obj=document.getElementById('APWLCTLOCDR');
	if (obj) obj.value=lu[4];
    var obj=document.getElementById('RBASAWLHosp');
	if (obj) obj.value=lu[5];
	var obj=document.getElementById('APWLHospitalDR');
	if (obj) obj.value=lu[7];
}

function WLHospLookUp(str) {
	var adata=str.split("^");
	var obj=document.getElementById("RBASAWLHosp");
	if (obj) obj.value=adata[0];
	var obj=document.getElementById("APWLHospitalDR");
	if (obj) obj.value=adata[1];
}

function LookUpCatSelect(txt) {
	//ANA 06.03.2002 Function to Return the Category ID
	var lu=txt.split("^");
	var scobj=document.getElementById("RBASASubcat");
	if (scobj) scobj.value="";
	var iobj=document.getElementById("RBASAOrdItm");
	if (iobj) iobj.value="";

}

function LookUpSubCatSelect(txt) {
	//ANA 06.03.2002 Function to Return the Category ID
	var lu=txt.split("^");
	var iobj=document.getElementById("RBASAOrdItm");
	if (iobj) iobj.value="";

}

function OrderItemLookupSelect(txt) {
	var lu=txt.split("^")
	var desc=lu[0];
	var arcid=lu[1];
	var ordertype=lu[3];
	var ordlist=document.getElementById('RBASAOrdLst');
	AddItemToList(ordlist,desc,arcid,ordertype)
	var cobj=document.getElementById("RBASACat");
	if (cobj) cobj.value="";
	var scobj=document.getElementById("RBASASubcat");
	if (scobj) scobj.value="";
	var orditm=document.getElementById("RBASAOrdItm");
	if (orditm) orditm.value="";
}

function ClearLocAndResAndServ() {
	var obj=document.getElementById('APCTLOCDR');
	if (obj) obj.value=""
	var obj=document.getElementById('APResourceDR');
	if (obj) obj.value="";
	var obj=document.getElementById('APServiceDR');
	if (obj) obj.value=""
	var obj=document.getElementById('RBASALoc');
	if (obj) obj.value=""
	var obj=document.getElementById('RBASARes');
	if (obj) obj.value="";
	var obj=document.getElementById('RBASAServ');
	if (obj) obj.value="";
}

function HospBlurHandler() {
	if (this.value=="") {
		var obj=document.getElementById('APHospitalDR');
		if (obj) obj.value="";
	}
}

function LocBlurHandler() {
	if (this.value=="") {
		var obj=document.getElementById('APCTLOCDR');
		if (obj) obj.value="";
	}
}

function ResBlurHandler() {
	if (this.value=="") {
		var obj=document.getElementById('APResourceDR');
		if (obj) obj.value="";
	}
}

function ServBlurHandler() {
	if (this.value=="") {
		var obj=document.getElementById('APServiceDR');
		if (obj) obj.value="";
	}
}

function WLLocBlurHandler() {
	if (this.value=="") {
		var obj=document.getElementById('APWLCTLOCDR');
		if (obj) obj.value="";
	}
}

function CPBlurHandler() {
	if (this.value=="") {
		var obj=document.getElementById('APWLCareProvDR');
		if (obj) obj.value="";
	}
}

function WLHospBlurHandler() {
	if (this.value=="") {
		var obj=document.getElementById('APWLHospitalDR');
		if (obj) obj.value="";
	}
}

function DeleteOrderClickHandler() {
	var lstOrders=document.getElementById('RBASAOrdLst');
	for (var i=(lstOrders.length-1); i>=0; i--) {
		if (lstOrders.options[i].selected){
			//alert(lstOrders.options[i].text+","+lstOrders.options[i].value);
			lstOrders.options[i]=null;
		}
	}
	return false;
}

function AddItemToList(list,desc,arcid,ordertype) {
	var code=arcid+"^"+ordertype
	list.options[list.length] = new Option(desc,code);
}

function PopulateOrderList() {
	var ordStr=document.getElementById('OrderString').value
	var ordlist=document.getElementById('RBASAOrdLst');
	if (ordStr!="") {
		for (var i=0;mPiece(ordStr,"*",i)!=""; i++) {
			var ordpiece=mPiece(ordStr,"*",i)
			var arcdesc=mPiece(ordpiece,"^",0); var arcid=mPiece(ordpiece,"^",1); var arctype=mPiece(ordpiece,"^",2)
			AddItemToList(ordlist,arcdesc,arcid,arctype)
		}
	}
	document.getElementById('OrderString').value="";
}

function mPiece(s1,sep,n) {
    //Split the array with the passed delimeter
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}

document.body.onload = BodyLoadHandler;