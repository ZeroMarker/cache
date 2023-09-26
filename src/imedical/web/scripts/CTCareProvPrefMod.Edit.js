function Init(){
	
	var obj=document.getElementById("update1")
	if (obj) obj.onclick=UpdateClickHandler;
	
	var objAct=document.getElementById("Action1")
	if ((objAct)&&((objAct.value=="AddAll")||(objAct.value=="Replace")||(objAct.value=="Add"))){
		DisableField("CurEQOrdItem",1);
		var objIm=document.getElementById("ld2383iCurEQOrdItem");
		if (objIm){
			objIm.disabled=true;
			objIm.className="DisabledField"
		}

	}
	if ((objAct)&&(objAct.value=="RemoveAll")){
		DisableField("Qnty",1);
		DisableField("NEQOrdItem",1);
		var objIm=document.getElementById("ld2383iNEQOrdItem");
		if (objIm){
			objIm.disabled=true;
			objIm.className="DisabledField"
		}
	}
	if ((objAct)&&((objAct.value=="ReplaceAll")||(objAct.value=="Replace"))) {
		var objOI=document.getElementById("EQOrdItem");
		var objARCIM=document.getElementById("EQARCIMDR");
		var objARCOS=document.getElementById("EQARCOSDR");
		if ((objOI)&&(objARCIM)&&(objARCOS)&&(objOI.value!="")&&((objARCIM.value!="")||(objARCOS.value!=""))) {
			var objCOI=document.getElementById("CurEQOrdItem");
			if (objCOI) {objCOI.value=objOI.value;}
			var objCARCIM=document.getElementById("CurEQARCIMDR");
			if (objCARCIM) {objCARCIM.value=objARCIM.value;}
			var objCARCOS=document.getElementById("CurEQARCOSDR");
			if (objCARCOS) {objCARCOS.value=objARCOS.value}
		}
	}
}

function UpdateClickHandler(){
	var act=document.getElementById("Action1");
	var testStr=""
	var objORP=document.getElementById("ORPParRef");
	if (objORP) testStr=testStr+objORP.value;
	var objCP=document.getElementById("CareProvParRef");
	if (objCP) testStr=testStr+objCP.value;
	var objSPPP=document.getElementById("SPPPParRef");
	if (objSPPP) testStr=testStr+objSPPP.value;
	var objAM=document.getElementById("ANMETParRef");
	if (objAM) testStr=testStr+objAM.value;
	var objCOI=document.getElementById("CurEQOrdItem");
	var objNOI=document.getElementById("NEQOrdItem");
	var objQty=document.getElementById("Qnty");
	
	if ((act)&&(objQty)&&(act.value!="RemoveAll")&&(objQty.value!="")){
		if (objQty.value<1){
			alert(t['WrongQty']);
			objQty.className='clsInvalid';
			return false;
		}
	}
	if ((act)&&(act.value!="RemoveAll"))
	{
		if ((!objNOI)||((objNOI)&&(objNOI.value==""))){
			alert(t['NOINotSpec']);
			objNOI.className='clsInvalid';
			return false;
		}
	}
	if ((act)&&((act.value=="RemoveAll")||(act.value=="ReplaceAll"))){
		if ((!objCOI)||((objCOI)&&(objCOI.value==""))){
			alert(t['COINotSpec']);
			objCOI.className='clsInvalid';
			return false;
		}
	}
	if ((act)&&(act.value=="AddAll")){
		if (!confirm(t['OIAdding']+objNOI.value)) return false;
	}
	if ((act)&&(act.value=="ReplaceAll")){
		if (!confirm(t['OIReplace']+objNOI.value)) return false;
	}
	if ((act)&&(act.value=="RemoveAll")) {
		if (!confirm(t['OIRemove']+objCOI.value+t['FAPrefs'])) return false;
	}
	if ((act)&&(act.value=="AddAll")){
		if ((objCP)&&((testStr=="")||(objCP.value==""))) {
			if (!confirm(t['BckGndJob'])) return false;
		}
	}
	if ((act)&&(act.value=="ReplaceAll")) {
		if ((objCP)&&((testStr=="")||(objCP.value==""))) {
			if (!confirm(t['BckGndJob'])) return false;
		}
	}
	return update1_click();
}

function NewOrdItemLookupSelect(txt) {
	
	var adata=txt.split("^");

	var OrdItem=document.getElementById("NEQOrdItem")
	var ARCIM=document.getElementById("NEQARCIMDR")
	var ARCOS=document.getElementById("NEQARCOSDR")
	

	if (OrdItem) OrdItem.value=adata[0];
	if (adata[3]=="ARCIM") {ARCIM.value=adata[1]; ARCOS.value=""}
	if (adata[3]=="ARCOS") {
		ARCOS.value=adata[1]; ARCIM.value=""
		
	}
}

function CurOrdItemLookupSelect(txt) {
	
	var adata=txt.split("^");

	var OrdItem=document.getElementById("CurEQOrdItem")
	var ARCIM=document.getElementById("CurEQARCIMDR")
	var ARCOS=document.getElementById("CurEQARCOSDR")
	

	if (OrdItem) OrdItem.value=adata[0];
	if (adata[3]=="ARCIM") {ARCIM.value=adata[1]; ARCOS.value=""}
	if (adata[3]=="ARCOS") {
		ARCOS.value=adata[1]; ARCIM.value=""
		
	}
}
document.body.onload=Init;