// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var frm = document.forms["fCTCareProvPrefMod_List"];

function Init() {

	var obj;
	
	var cpSt=document.getElementById("CareProvParRef");
	
	var  objTable=document.getElementById("tCTCareProvPrefMod_List");
	if (objTable) objTable.onclick=TableClickHandler;
	
	obj=document.getElementById('DELCareProv');
	if (obj) obj.onclick=CarePrvDeleteClickHandler;

	obj=document.getElementById('DELOPER');
	if (obj) obj.onclick=OperDeleteClickHandler;
	
	obj=document.getElementById('DELSPPP');
	if (obj) obj.onclick=SPPPDeleteClickHandler;
	
	obj=document.getElementById('DELAnestMthd');
	if (obj) obj.onclick=ANMETDeleteClickHandler;
	
	var obj=document.getElementById("Surgeon")
	if (obj) obj.onclick=SurgeonCx;
	
	var obj=document.getElementById("Anaesthetist")
	if (obj) obj.onclick=AnaestCx;

	var Deselectobj=document.getElementById("DeselectAll"); 
	if (Deselectobj){ Deselectobj.onclick = DeselectAll; } 

	var Selectobj=document.getElementById("SelectAll"); 
	if (Selectobj) { Selectobj.onclick = SelectAll; } 
	
	obj=document.getElementById('Find');
	if (obj) obj.onclick=FindAll;
	if (tsc['Find']) websys_sckeys[tsc['Find']]=FindAll;
	
	var objRA=document.getElementById('RemoveAll');
	if (objRA) objRA.onclick=RemoveAllLink;
	
	var objR=document.getElementById('Replace');
	//if (obj) obj.onclick=ReplaceAll;
	//if (tsc['Replace']) websys_sckeys[tsc['Replace']]=ReplaceAll;
	if (objR) objR.onclick=ReplaceLink;
	
	var objRA=document.getElementById('ReplaceAll');
	if (objRA) objRA.onclick=ReplaceAllLink;
	
	var objRm=document.getElementById('Remove');
	if (objRm) objRm.onclick=RemoveClickHandler;
	
	var obj=document.getElementById('OpsOnly');
	if (obj) obj.onclick=OpsOnlyCx;

	var objAA=document.getElementById('AddAll');
	//if (obj) obj.onclick=AddAllAll;
	//if (tsc['AddAll']) websys_sckeys[tsc['AddAll']]=AddAllAll;
	if (objAA)objAA.onclick=AddAllLink;
	
	var objA=document.getElementById('AddItem');
	if (objA) objA.onclick=AddLink;
	
	obj=document.getElementById('Qnty');
	if (obj) obj.onchange=QntyChanger;
	
	var obj=document.getElementById('recsppp');
	if (obj) obj.onclick=RecCx;
	
	var obj=document.getElementById('RecOper');
	if (obj) obj.onclick=RecCx1;
	
	var obj=document.getElementById('EQOrdSubCat');
	if (obj) obj.onblur=SubCatChanger;
	var obj=document.getElementById('NEQOrdSubCat');
	if (obj) obj.onblur=NSubCatChanger;
	var obj=document.getElementById('EQOrdItem');
	if (obj) obj.onblur=OrderChanger;
	var obj=document.getElementById('NEQOrdItem');
	if (obj) obj.onblur=NOrderChanger;
	
	var objSel=document.getElementById('selectedids');
	if ((objSel)&&(objSel.value=="")) {
		var objRpl=document.getElementById('Replace');
		if (objRpl) {
			objRpl.disabled=true;
			objRpl.onclick=LinkDisable;
		}
		var objRm=document.getElementById('Remove');
		if (objRm) {
			objRm.disabled=true;
			objRm.onclick=LinkDisable;
		}
		var objAdd=document.getElementById('AddItem');
		if (objAdd) {
			objAdd.disabled=true;
			objAdd.onclick=LinkDisable;
		}
	}
	//Log 65339 KB
	ListboxReload("CareProvString","CareProvList");
	ListboxReload("OPERString","OPERList");
	ListboxReload("SPPPString","SPPPList");
	ListboxReload("ANMETString","ANMETList");
	//end Log 65339 KB
	var objRecOp=document.getElementById('RecOper');
	var objRecOpT=document.getElementById('RecOperT');
	if ((objRecOp)&&(objRecOpT)&&(objRecOpT.value=="Y")) objRecOp.checked=true;
	if ((objRecOp)&&(objRecOpT)&&(objRecOpT.value=="")) objRecOp.checked=false;
	var objOp=document.getElementById('OpsOnly');
	var objOpT=document.getElementById('OpsOnlyT');
	if ((objOp)&&(objOpT)&&(objOpT.value=="Y")) objOp.checked=true;
 	if ((objOp)&&(objOpT)&&(objOpT.value==""))objOp.checked=false;
	var objL=document.getElementById('OPERList');
	if (((objRecOp)&&(objRecOp.checked))||((objL)&&(objL.options.length>0)&&(objL.options[0].value!=""))||((objOp)&&(objOp.checked))){
		DisableField("recsppp",1);	
		DisableField("SPPPDesc",1);		
		DisableField("SPPPList",1);		
		DisableField("ANMETDesc",1);		
		DisableField("ANMETList",1);		
		var objIm=document.getElementById("ld2299iSPPPDesc");
		if (objIm){
			objIm.disabled=true;
			objIm.className="DisabledField"
		}
		var objIm=document.getElementById("ld2299iANMETDesc");
		if (objIm){
			objIm.disabled=true;
			objIm.className="DisabledField"
		}
		var obj=document.getElementById("DELSPPP");
		if (obj) obj.onclick=LinkDisable;
		DisableField("DELSPPP",1);		
		var obj=document.getElementById("DELAnestMthd");
		if (obj) obj.onclick=LinkDisable;
		DisableField("DELAnestMthd",1);		
	}
	var objrecsppp=document.getElementById('recsppp');
	var objrecspppT=document.getElementById('recspppt');
	if ((objrecsppp)&&(objrecspppT)&&(objrecspppT.value=="Y")) objrecsppp.checked=true;
	if ((objrecsppp)&&(objrecspppT)&&(objrecspppT.value=="")) objrecsppp.checked=false;
	var objL=document.getElementById('SPPPList');
	if (((objrecsppp)&&(objrecsppp.checked))||((objL)&&(objL.options.length>0)&&(objL.options[0].value!=""))){
		DisableField("RecOper",1);	
		DisableField("OpsOnly",1);	
		DisableField("OPERDesc",1);		
		DisableField("OPERList",1);		
		DisableField("ANMETDesc",1);		
		DisableField("ANMETList",1);		
		var objIm=document.getElementById("ld2299iOPERDesc");
		if (objIm){
			objIm.disabled=true;
			objIm.className="DisabledField"
		}
		var objIm=document.getElementById("ld2299iANMETDesc");
		if (objIm){
			objIm.disabled=true;
			objIm.className="DisabledField"
		}
		var obj=document.getElementById("DELOPER");
		if (obj) obj.onclick=LinkDisable;
		DisableField("DELOPER",1);		
		var obj=document.getElementById("DELAnestMthd");
		if (obj) obj.onclick=LinkDisable;
		DisableField("DELAnestMthd",1);		
	}
	var objL=document.getElementById("ANMETList");
	if ((objL)&&(objL.options.length>0)) {
		DisableField("RecOper",1);		
		DisableField("OpsOnly",1);	
		DisableField("OPERDesc",1);		
		DisableField("OPERList",1);		
		DisableField("recsppp",1);		
		DisableField("SPPPDesc",1);		
		DisableField("SPPPList",1);	
		//DisableField("DELSPPP",1);
		var objIm=document.getElementById("ld2299iOPERDesc");
		if (objIm){
			objIm.disabled=true;
			objIm.className="DisabledField"
		}
		var objIm=document.getElementById("ld2299iSPPPDesc");
		if (objIm){
			objIm.disabled=true;
			objIm.className="DisabledField"
		}
		var obj=document.getElementById("DELOPER");
		if (obj) obj.onclick=LinkDisable;
		DisableField("DELOPER",1);		
		var obj=document.getElementById("DELSPPP");
		if (obj) obj.onclick=LinkDisable;
		DisableField("DELSPPP",1);		
	}
}

function TableClickHandler(e) {
	
	var orditem=document.getElementById("EQOrdItem");
	var objrtnselected=document.getElementById("selectedids");
   	var eSrc = websys_getSrcElement(e);
		if (eSrc.tagName=="INPUT") {
			if (eSrc.id.indexOf("Selectz")==0) { 
				
				}
		}
	CheckWSelected();
	//if (objrtnselected&&orditem&&objrtnselected.value!="") {
	if ((objrtnselected)&&(objrtnselected.value!="")) {
		//DisableField('EQOrdItem');
		//DisableLookup('ld2299iEQOrdItem');
		SingleItmLnksAct();
		//EnableLink('Add');
		//objAdd.disabled=true;
		//objAdd.onclick="";

	}
	else {
		//EnableField('EQOrdItem');
		//EnableLookup('ld2299iEQOrdItem');
		MultItmLnksAct();
	}
	
	
}



function DeselectAll(e) { 	
	var tbl=document.getElementById("tCTCareProvPrefMod_List");
	var f=document.getElementById("fCTCareProvPrefMod_List");
	var orditem=document.getElementById("EQOrdItem");
	var objrtnselected=document.getElementById("selectedids");
	if ((f)&&(tbl)) {
		for (var j=1;j<tbl.rows.length;j++) {
			var obj=document.getElementById('Selectz'+j);
			if ((obj) && (!obj.disabled)) {
				obj.checked=false;				
			}
		}
	}
	CheckWSelected();
	if (objrtnselected&&orditem&&objrtnselected.value!="") {
	DisableField('EQOrdItem');
	DisableLookup('ld2299iEQOrdItem');
	}
	else {
	EnableField('EQOrdItem');
	EnableLookup('ld2299iEQOrdItem');
	}
	MultItmLnksAct();
	return false;
}

function SelectAll(e) {  	
	var tbl=document.getElementById("tCTCareProvPrefMod_List");
	var f=document.getElementById("fCTCareProvPrefMod_List");	
	var orditem=document.getElementById("EQOrdItem");
	var objrtnselected=document.getElementById("selectedids");
	if ((f)&&(tbl)) {
		for (var j=1;j<tbl.rows.length;j++) {
			var obj=document.getElementById('Selectz'+j);
			if ((obj) && (!obj.disabled)) {
				obj.checked=true;				
			}
		}
	}
	CheckWSelected();
	if (objrtnselected&&orditem&&objrtnselected.value!="") {
		DisableField('EQOrdItem');
		DisableLookup('ld2299iEQOrdItem');
	}
	else {
		EnableField('EQOrdItem');
		EnableLookup('ld2299iEQOrdItem');
	}
	SingleItmLnksAct();

	return false;
}

function FindAll() {
	UpdateCareProv();
	UpdateSPPP();
	UpdateOPER();
	UpdateANMET();
	var testStr="";
	var cpObj=document.getElementById("CareProvParRef");
	if (cpObj) {testStr=testStr+cpObj.value;}
	var spppObj=document.getElementById("SPPPParRef");
	if (spppObj) {testStr=testStr+spppObj.value;}
	var orpObj=document.getElementById("ORPParRef");
	if (orpObj) {testStr=testStr+orpObj.value;}
	var anMObj=document.getElementById("ANMETParRef");
	if (anMObj) {testStr=testStr+anMObj.value;}
	var OIObj=document.getElementById("EQARCIMDR");
	if (OIObj) {testStr=testStr+OIObj.value;}
	var OSObj=document.getElementById("EQARCOSDR");
	if (OSObj) {testStr=testStr+OSObj.value;}
	if (testStr=="") {
		alert(t["NoSrchCrt"]);
		return false;
	}
	if (!QntyChanger()) return false;

	return Find_click()
}

function AddAll() {
	//var obj=document.getElementById("NEQOrdItem")
	//if (((obj)&&(obj.value==""))||(!obj))
	//{
	//alert("Please select order item to be add");
	//alert(t['PSWTA']);
  //      return false;
	//}
	//if ((document.getElementById("MsgToDisplay").value=="1")&&(!confirm(t['OIAdding']+obj.value))) return false;
	//CheckWSelected();
	
	//if (!QntyChanger()) return false;
	//return Add_click()
	
}

//Log 65339 KB These functions no longer used ReplaceAll() and AddAllAll()
/*
function ReplaceAll() {
	var obj=document.getElementById("NEQOrdItem")
	if (((obj)&&(obj.value==""))||(!obj))
	{
	alert(t['PSOITBA']);
        return false;
	}
	if ((document.getElementById("MsgToDisplay").value=="1")&&(!confirm(t['OIReplace']+obj.value))) return false;
	UpdateCareProv();
	UpdateSPPP();
	UpdateOPER();
	UpdateANMET();
	CheckRSelected();	
	if (!QntyChanger()) return false;
	return Replace_click()
	
}


function AddAllAll() {
	var obj=document.getElementById("NEQOrdItem")
	if (((obj)&&(obj.value==""))||(!obj))
	{
	alert(t['PSWTA']);
        return false;
	}
	if ((document.getElementById("MsgToDisplay").value=="1")&&(!confirm(t['OIAdding']+obj.value))) return false;
	UpdateCareProv();
	UpdateSPPP();
	UpdateOPER();
	UpdateANMET();
	CheckRSelected();
	if (!QntyChanger()) return false;
	var objLink=document.getElementById('AddAll');
	if (objLink) {
				objLink.onclick=LinkDisable;
				objLink.disabled=true;
	}
	var testStr=""
	var objORP=document.getElementById("ORPParRef");
	if (objORP) testStr=testStr+objORP.value;
	var objCP=document.getElementById("CareProvParRef");
	if (objCP) testStr=testStr+objCP.value;
	var objSPPP=document.getElementById("SPPPParRef");
	if (objSPPP) testStr=testStr+objSPPP.value;
	var objAM=document.getElementById("ANMETParRef");
	if (objAM) testStr=testStr+objAM.value;
	if ((objCP)&&((testStr=="")||(objCP.value==""))) {
		if (!confirm(t['BckGndJob'])) return false;
	}
	return AddAll_click()
	
}
*/

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}


function CheckWSelected() {  	
	var tbl=document.getElementById("tCTCareProvPrefMod_List");
	var f=document.getElementById("fCTCareProvPrefMod_List");	
	var objrtnselected=document.getElementById("selectedids");	
	if (objrtnselected) objrtnselected.value="";
	if ((f)&&(tbl)) {
		for (var j=1;j<tbl.rows.length;j++) {
			var obj=document.getElementById('Selectz'+j);
			if ((obj) && (!obj.disabled)&&(obj.checked==true))				
			{
				var obj1=document.getElementById('OperPARRFz'+j);
				var obj2=document.getElementById('CarePDrz'+j);
				var obj3=document.getElementById('EQRowIdz'+j);
				if ((objrtnselected)&&(obj1)&&(obj2)&&(obj3)) {
					var eqDr=obj2.value+"||"+obj1.value+"||"+obj3.value
					if (objrtnselected.value!="") objrtnselected.value=objrtnselected.value+"^"+eqDr;
					if (objrtnselected.value=="") objrtnselected.value=eqDr;
				}
			}
		}
	}
	return false;
}

function CheckRSelected() {  	
	var tbl=document.getElementById("tCTCareProvPrefMod_List");
	var f=document.getElementById("fCTCareProvPrefMod_List");	
	var objrtnselected=document.getElementById("EQselectedids");	
	if (objrtnselected) objrtnselected.value="";
	if ((f)&&(tbl)) {
		for (var j=1;j<tbl.rows.length;j++) {
			var obj=document.getElementById('Selectz'+j);
			if ((obj) && (!obj.disabled)&&(obj.checked==true))				
			{
			var obj1=document.getElementById('EQRowIdz'+j);
			if ((objrtnselected)&&(obj1)) {
			if (objrtnselected.value!="") objrtnselected.value=objrtnselected.value+obj1.value+"^";
			if (objrtnselected.value=="") objrtnselected.value=obj1.value+"^"
			}
			}
		}
	}
	return false;
}

function CareProvLookupSelect(txt) {
	
	var adata=txt.split("^");
	var obj=document.getElementById("CareProvList")

	if (obj) {
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				var obj=document.getElementById("CTCareProv")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				var obj=document.getElementById("CTCareProv")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("CTCareProv")
	if (obj) obj.value="";
}

function UpdateCareProv() {
	var arrItems = new Array();
	var lst = document.getElementById("CareProvList");
	var passedparam=document.getElementById("CareProvParRef");
	passedparam.value="";
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			var bb1=lst.options[j].value.split(String.fromCharCode(2))[1];
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
			//if (passedparam.value!="") { passedparam.value=passedparam.value+bb1}
			//if (passedparam.value=="") { passedparam.value=bb1+"^"}
			if (passedparam.value!="") { passedparam.value=passedparam.value+"^"+bb1}
			if (passedparam.value=="") { passedparam.value=bb1}
			
		}
		var el = document.getElementById("CareProvString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
		
	}

}

function CarePrvDeleteClickHandler() {
	

	var obj=document.getElementById("CareProvList")
	if (obj)
		RemoveFromList(obj);
	return false;
}


function OperationtLookupSelect(txt) {
	
	var adata=txt.split("^");
	var obj=document.getElementById("OPERList")

	if (obj) {
		
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				var obj=document.getElementById("OPERDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				var obj=document.getElementById("OPERDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("OPERDesc")
	if (obj) obj.value="";
	
	//Log 65339 KB
	//var lst = document.getElementById('ANMETList');
	//RemoveAllFromList(lst);
	DisableField("recsppp",1);		
	DisableField("SPPPDesc",1);		
	DisableField("SPPPList",1);		
	DisableField("DELSPPP",1);		
	DisableField("ANMETDesc",1);		
	DisableField("ANMETList",1);		
	DisableField("DELAnestMthd",1);		
	var objIm=document.getElementById("ld2299iSPPPDesc");
	if (objIm){
		objIm.disabled=true;
		objIm.className="DisabledField"
	}
	var objIm=document.getElementById("ld2299iANMETDesc");
	if (objIm){
		objIm.disabled=true;
		objIm.className="DisabledField"
	}
	var obj=document.getElementById("DELSPPP");
	if (obj) obj.onclick=LinkDisable;
	DisableField("DELSPPP",1);		
	var obj=document.getElementById("DELAnestMthd");
	if (obj) obj.onclick=LinkDisable;
	DisableField("DELAnestMthd",1)
}

function UpdateOPER() {
	var arrItems = new Array();
	var lst = document.getElementById("OPERList");
	var passedparam=document.getElementById("ORPParRef");
	passedparam.value="";
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			
			var bb1=lst.options[j].value.split(String.fromCharCode(2))[1];
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
			if (passedparam.value!="") { passedparam.value=passedparam.value+"^"+bb1}
			if (passedparam.value=="") { passedparam.value=bb1}
			
		}
		var el = document.getElementById("OPERString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
		
	}
}

function OperDeleteClickHandler() {
	

	var obj=document.getElementById("OPERList")
	if (obj)
		RemoveFromList(obj);
	//Log 65339 Kb 01 Nov 2007
	var objCx=document.getElementById("RecOper")
	var objCx2=document.getElementById("OpsOnly");
	if ((obj.options.length==0)&&(!objCx.checked)&&(!objCx2.checked)) {
		EnableField("recsppp");	
		EnableField("SPPPDesc");		
		EnableField("SPPPList");		
		EnableField("DELSPPP");		
		EnableField("ANMETDesc");		
		EnableField("ANMETList");		
		EnableField("DELAnestMthd");		
		EnableField("ld2299iSPPPDesc");
		EnableField("ld2299iANMETDesc");
		var obj=document.getElementById("DELSPPP");
		if (obj) obj.onclick=SPPPDeleteClickHandler;
		var obj=document.getElementById("DELAnestMthd");
		if (obj) obj.onclick=ANMETDeleteClickHandler;
		
	}
	return false;
}



function SPPPLookupSelect(txt) {
	
	var adata=txt.split("^");
	var obj=document.getElementById("SPPPList")

	if (obj) {
		
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert(t['SPPPSlctd']);
				var obj=document.getElementById("SPPPDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert(t['SPPPSlctd']);
				var obj=document.getElementById("SPPPDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("SPPPDesc")
	if (obj) obj.value="";
	//Log 65339 KB 2 Nov 2007
	//var lst = document.getElementById('ANMETList');
	//RemoveAllFromList(lst);
	DisableField("RecOper",1);		
	DisableField("OpsOnly",1);
	DisableField("OPERDesc",1);		
	DisableField("OPERList",1);		
	DisableField("ANMETDesc",1);		
	DisableField("ANMETList",1);		
	DisableField("DELAnestMthd",1);		
	var objIm=document.getElementById("ld2299iOPERDesc");
	if (objIm){
		objIm.disabled=true;
		objIm.className="DisabledField"
	}
	var objIm=document.getElementById("ld2299iANMETDesc");
	if (objIm){
		objIm.disabled=true;
		objIm.className="DisabledField"
	}
	var obj=document.getElementById("DELOPER");
	if (obj) obj.onclick=LinkDisable;
	DisableField("DELOPER",1);		
	var obj=document.getElementById("DELAnestMthd");
	if (obj) obj.onclick=LinkDisable;
	DisableField("DELAnestMthd",1);		

}



function UpdateSPPP() {
	var arrItems = new Array();
	var lst = document.getElementById("SPPPList");
	var passedparam=document.getElementById("SPPPParRef");
	passedparam.value="";
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			
			var bb1=lst.options[j].value.split(String.fromCharCode(2))[1];
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
			if (passedparam.value!="") { passedparam.value=passedparam.value+"^"+bb1}
			if (passedparam.value=="") { passedparam.value=bb1}
		}
		var el = document.getElementById("SPPPString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
		
	}
}


function SPPPDeleteClickHandler() {
	

	var obj=document.getElementById("SPPPList")
	if (obj)
		RemoveFromList(obj);
	//Log 65339 KB 2 Nov 2007
	var objCx=document.getElementById("recsppp");
	if ((obj.options.length==0)&&(!objCx.checked)) {
		EnableField("RecOper");	
		EnableField("OpsOnly");	
		EnableField("OPERDesc");		
		EnableField("OPERList");		
		EnableField("DELOPER");		
		EnableField("ANMETDesc");		
		EnableField("ANMETList");		
		EnableField("DELAnestMthd");		
		EnableField("ld2299iOPERDesc");
		EnableField("ld2299iANMETDesc");	
		var obj=document.getElementById("DELOPER");
		if (obj) obj.onclick=OperDeleteClickHandler;
		var obj=document.getElementById("DELAnestMthd");
		if (obj) obj.onclick=ANMETDeleteClickHandler;
	}
	return false;
}



function ANMETDescSelect(txt) {
	
	var adata=txt.split("^");
	var obj=document.getElementById('ANMETList')

	if (obj) {
		
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert(t['AnMthSlctd']);
				var obj=document.getElementById('ANMETDesc')
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert(t['AnMthSlctd']);
				var obj=document.getElementById('ANMETDesc')
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById('ANMETDesc')
	if (obj) obj.value="";
	//var lst = document.getElementById('SPPPList');
	//RemoveAllFromList(lst);
	//var lst = document.getElementById('OPERList');
	//RemoveAllFromList(lst);
	//Log 65339 KB 2 Nov 2007
	DisableField("RecOper",1);		
	DisableField("OpsOnly",1);
	DisableField("OPERDesc",1);		
	DisableField("OPERList",1);		
	DisableField("recsppp",1);
	DisableField("SPPPDesc",1);		
	DisableField("SPPPList",1);		
	var objIm=document.getElementById("ld2299iOPERDesc");
	if (objIm){
		objIm.disabled=true;
		objIm.className="DisabledField"
	}
	var objIm=document.getElementById("ld2299iSPPPDesc");
	if (objIm){
		objIm.disabled=true;
		objIm.className="DisabledField"
	}	
	var obj=document.getElementById("DELOPER");
	if (obj)obj.onclick=LinkDisable;
	DisableField("DELOPER",1);		
  var obj=document.getElementById("DELSPPP");
  if (obj) obj.onclick=LinkDisable;
  DisableField("DELSPPP",1);	
	
}



function UpdateANMET() {
	var arrItems = new Array();
	var lst = document.getElementById("ANMETList");
	var passedparam=document.getElementById("ANMETParRef")
	if(passedparam) {passedparam.value="";}
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			
			var bb1=lst.options[j].value.split(String.fromCharCode(2))[1];
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
			if (passedparam.value!="") { passedparam.value=passedparam.value+"^"+bb1}
			if (passedparam.value=="") { passedparam.value=bb1}
		}
		var el = document.getElementById("ANMETString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
		
	}
}


function ANMETDeleteClickHandler() {
	

	var obj=document.getElementById("ANMETList")
	if (obj)
		RemoveFromList(obj);
	//Log 65339 KB 2 Nov 2007
	if ((obj)&&(obj.options.length==0)) {
		EnableField("RecOper");
		EnableField("OpsOnly");		
		EnableField("OPERDesc");		
		EnableField("OPERList");		
		EnableField("DELOPER");		
		EnableField("recsppp");
		EnableField("SPPPDesc");		
		EnableField("SPPPList");		
		EnableField("DELSPPP");		
		EnableField("ld2299iOPERDesc");
		EnableField("ld2299iSPPPDesc");	
		var obj=document.getElementById("DELSPPP");
		if (obj) obj.onclick=SPPPDeleteClickHandler;
		var obj=document.getElementById("DELOPER");
		if (obj) obj.onclick=OperDeleteClickHandler;
	}
	return false;
}



function SubCatLookUpHandler(txt) {
	var adata=txt.split("^");

	var SubCat=document.getElementById("EQOrdSubCat")
	var SubCatID=document.getElementById("subCatID")

	if (SubCat) SubCat.value=adata[0];
	if (SubCatID) SubCatID.value=adata[1];
}

function SubCatChanger() {
	var SubCat=document.getElementById("EQOrdSubCat")
	var SubCatID=document.getElementById("subCatID")
	 if ((SubCat)&&(SubCat.value=="")) {
	 SubCatID.value="";
	 }

}

function OrdItemLookupSelect(txt) {
	var adata=txt.split("^");

	var OrdItem=document.getElementById("EQOrdItem")
	var ARCIM=document.getElementById("EQARCIMDR")
	var ARCOS=document.getElementById("EQARCOSDR")
	

	if (OrdItem) OrdItem.value=adata[0];
	if (adata[3]=="ARCIM") {ARCIM.value=adata[1]; ARCOS.value=""}
	if (adata[3]=="ARCOS") {
		ARCOS.value=adata[1]; ARCIM.value=""
		
	}
}

function OrderChanger() {
	var OrdItem=document.getElementById("EQOrdItem")
	var ARCIM=document.getElementById("EQARCIMDR")
	var ARCOS=document.getElementById("EQARCOSDR")
	 if ((OrdItem)&&(OrdItem.value=="")) {
	 ARCIM.value="";
	 ARCOS.value=""
	 }


}

function SubCatLookUpHandlerNew(txt) {
	var adata=txt.split("^");

	var SubCat=document.getElementById("NEQOrdSubCat")
	var SubCatID=document.getElementById("NsubCatID")

	if (SubCat) SubCat.value=adata[0];
	if (SubCatID) SubCatID.value=adata[1];
}

function NSubCatChanger() {
	var SubCat=document.getElementById("NEQOrdSubCat")
	var SubCatID=document.getElementById("NsubCatID")
	 if ((SubCat)&&(SubCat.value=="")) {
	 SubCatID.value="";
	 }

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

function NOrderChanger() {
	var OrdItem=document.getElementById("NEQOrdItem")
	var ARCIM=document.getElementById("NEQARCIMDR")
	var ARCOS=document.getElementById("NEQARCOSDR")
	 if ((OrdItem)&&(OrdItem.value=="")) {
	 ARCIM.value="";
	 ARCOS.value=""
	 }


}

function ReplaceHiddenCode(piece,val) {
	var obj=document.getElementById('dcflags');
	if (obj) {
		var hiddenCodes=obj.value.split("^");
		hiddenCodes[piece]=val;
		obj.value=hiddenCodes.join("^");
		
	}
}

function SurgeonCx() {

	var obj=document.getElementById("Surgeon");
	if ((obj)&&(obj.checked)) {ReplaceHiddenCode(2,"Y")	 }
	if ((obj)&&!(obj.checked)) {ReplaceHiddenCode(2,"")         }
}

function AnaestCx() {

	var obj=document.getElementById("Anaesthetist")
	if ((obj)&&(obj.checked)) {ReplaceHiddenCode(1,"Y")	}
	if ((obj)&&!(obj.checked)) {ReplaceHiddenCode(1,"")       }
}

function RecCx() {

	var obj=document.getElementById('recsppp');
	var obj2=document.getElementById('recspppT');
	if ((obj)&&(obj.checked)&&(obj2)) {obj2.value="Y" } // Log 65339 KB will use this for the find
	if ((obj)&&!(obj.checked)&&(obj2)) {obj2.value="" }	
	var obj1=document.getElementById('rsttp');
	if ((obj)&&(obj.checked)&&(obj1)) {obj1.value="Y" }
	if ((obj)&&!(obj.checked)&&(obj1)) {obj1.value="" }
	//Log 65339 Section 2.1 KB 2 Nov 2007
	if ((obj)&&(obj.checked)) {
		DisableField("RecOper",1);		
		DisableField("OpsOnly",1);
		DisableField("OPERDesc",1);		
		DisableField("OPERList",1);		
		DisableField("ANMETDesc",1);		
		DisableField("ANMETList",1);		
		var objIm=document.getElementById("ld2299iOPERDesc");
		if (objIm){
			objIm.disabled=true;
			objIm.className="DisabledField"
		}
		var objIm=document.getElementById("ld2299iANMETDesc");
		if (objIm){
			objIm.disabled=true;
			objIm.className="DisabledField"
		}
		objDel=document.getElementById('DELAnestMthd');
	  if (objDel) objDel.onclick=LinkDisable;
		objDel=document.getElementById('DELOPER');
	  if (objDel) objDel.onclick=LinkDisable;
	}
	var objL=document.getElementById("SPPPList");
	if ((obj)&&(!obj.checked)&&(objL)&&(objL.options.length==0)){
		EnableField("RecOper");
		EnableField("OpsOnly");
		EnableField("OPERDesc");
		EnableField("OPERList");
		EnableField("DELOPER");
		EnableField("ANMETDesc");
		EnableField("ANMETList");
		EnableField("DELAnestMthd");
		EnableField("ld2299iOPERDesc");
		EnableField("ld2299iANMETDesc");
		obj=document.getElementById('DELAnestMthd');
	  if (obj) obj.onclick=ANMETDeleteClickHandler;
		obj=document.getElementById('DELOPER');
	  if (obj) obj.onclick=OperDeleteClickHandler;
	}	
}


function RecCx1() {

	var obj=document.getElementById('RecOper');
	var obj1=document.getElementById('rsttp');
	var objroT=document.getElementById('RecOperT');
  //if ((obj)&&(obj.checked)&&(obj1)) {obj1.value="Y";}
	//if ((obj)&&!(obj.checked)&&(obj1)) {obj1.value="";}
	if ((obj)&&(obj.checked)&&(objroT)) {objroT.value="Y"; } // Log 65339 KB will use this for the find
	if ((obj)&&!(obj.checked)&&(objroT)) {objroT.value=""; }	
	//Log 65339 Section 2.1 KB
	if ((obj)&&(obj.checked)) {
		//DisableField("OpsOnly",1);
		DisableField("recsppp",1);
		DisableField("SPPPDesc",1);		
		DisableField("SPPPList",1);		
		DisableField("DELSPPP",1);		
		DisableField("ANMETDesc",1);		
		DisableField("ANMETList",1);		
		DisableField("DELAnestMthd",1);	
		var objIm=document.getElementById("ld2299iSPPPDesc");
		if (objIm){
			objIm.disabled=true;
			objIm.className="DisabledField"
		}
		var objIm=document.getElementById("ld2299iANMETDesc");
		if (objIm){
			objIm.disabled=true;
			objIm.className="DisabledField"
		}
		objDel=document.getElementById('DELAnestMthd');
	  if (objDel) objDel.onclick=LinkDisable;
		objDel=document.getElementById('DELSPPP');
	  if (objDel) objDel.onclick=LinkDisable;
	}
	var objL=document.getElementById("OPERList");
	var objOO=document.getElementById("OpsOnly");
	if ((obj)&&(!obj.checked)&&(objL)&&(objL.options.length==0)&&(objOO)&&(!objOO.checked)){
		//EnableField("OpsOnly");
		EnableField("recsppp");
		EnableField("SPPPDesc");
		EnableField("SPPPLis");
		EnableField("DELSPPP");
		EnableField("ANMETDesc");
		EnableField("ANMETList");
		EnableField("DELAnestMthd");
		EnableField("ld2299iSPPPDesc");
		EnableField("ld2299iANMETDesc");
		obj=document.getElementById('DELAnestMthd');
	  if (obj) obj.onclick=ANMETDeleteClickHandler;
		obj=document.getElementById('DELSPPP');
	  if (obj) obj.onclick=SPPPDeleteClickHandler;
	}
}

//Log 65339 KB 2 Nov 2007
function OpsOnlyCx() {
	var obj=document.getElementById('OpsOnly');
	var obj2=document.getElementById('OpsOnlyT');
	if ((obj)&&(obj.checked)&&(obj2)) {obj2.value="Y" } // Log 65339 KB will use this for the find
	if ((obj)&&!(obj.checked)&&(obj2)) {obj2.value="" }	
	if ((obj)&&(obj.checked)) {
		//DisableField("RecOper",1);
		DisableField("recsppp",1);		
		DisableField("SPPPDesc",1);		
		DisableField("SPPPList",1);		
		DisableField("DELSPPP",1);		
		DisableField("ANMETDesc",1);		
		DisableField("ANMETList",1);		
		DisableField("DELAnestMthd",1);	
		var objIm=document.getElementById("ld2299iSPPPDesc");
		if (objIm){
			objIm.disabled=true;
			objIm.className="DisabledField"
		}
		var objIm=document.getElementById("ld2299iANMETDesc");
		if (objIm){
			objIm.disabled=true;
			objIm.className="DisabledField"
		}
		objDel=document.getElementById('DELAnestMthd');
	  if (objDel) objDel.onclick=LinkDisable;
		objDel=document.getElementById('DELSPPP');
	  if (objDel) objDel.onclick=LinkDisable;
	}
	var objL=document.getElementById("OPERList");
	var objRO=document.getElementById("RecOper");
	if ((obj)&&(!obj.checked)&&(objL)&&(objL.options.length==0)&&(objRO)&&(!objRO.checked)){
		//EnableField("RecOper");
		EnableField("recsppp");
		EnableField("SPPPDesc");
		EnableField("SPPPLis");
		EnableField("DELSPPP");
		EnableField("ANMETDesc");
		EnableField("ANMETList");
		EnableField("DELAnestMthd");
		EnableField("ld2299iSPPPDesc");
		EnableField("ld2299iANMETDesc");
		obj=document.getElementById('DELAnestMthd');
	  if (obj) obj.onclick=ANMETDeleteClickHandler;
		obj=document.getElementById('DELSPPP');
	  if (obj) obj.onclick=SPPPDeleteClickHandler;
	}
}


///////////////////////////////// LIST BOXES ////////////////////////////////////////////////////////////////////////
function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}

function AddItemToList_Reload(list,code,desc) {
	//Add an item to a listbox
	list.options[list.options.length] = new Option(desc,code);
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
		obj.options[i]=null;
	}

}

function RemoveAllFromList(obj){
	for (var i=(obj.length-1); i>=0; i--) {
		obj.options[i]=null;
	}

}

function ListboxReload(strName, lstName) {
	var el = document.getElementById(strName);
	var lst = document.getElementById(lstName);
	var updated = document.getElementById("Updated");
	//don't execute this when page loads for the first time b/c first time values come from db,
	//execute for subsequent reloads (such as on error condition).
	if ((lst) && (el)) {// && (updated.value == "1")) { Log 65339 KB
		RemoveAllFromList(lst);
		if(el.value != ""){
			var arrITEM=el.value.split(String.fromCharCode(1));
			for (var i=0; i<arrITEM.length; i++) {
				var arrITEMVAL=arrITEM[i].split(String.fromCharCode(2));
				AddItemToList_Reload(lst,arrITEMVAL[0]+String.fromCharCode(2)+arrITEMVAL[1],arrITEMVAL[2]);
			}
		}
	}
}

//TN: reload listboxes with values in hidded fields.
//this is due to page being refreshed upon error message (such as invalid pin)
function ReloadListBoxes() {
	//PreComplReload();
	//ArtReload();
	ListboxReload("SPPPString","SPPPList");
	ListboxReload("OPERString","OPERList");
	ListboxReload("CareProvString","CareProvList");
	ListboxReload("ANMETString","ANMETList");
}

function QntyChanger() {
	var obj = document.getElementById('Qnty');
	if (obj) { Qnty_changehandler(); }
	
	
	if (obj) {
		if (!IsValidInteger(obj)) {
		alert(t[obj.id]+" "+t['XINVALID']);
			obj.className='clsInvalid';
			websys_setfocus('Qnty');
			websys_cancel();
			return false;
		}
		
	if (obj.value >999) {
		alert(t[obj.id]+" "+t['XINVALID']);
		obj.className='clsInvalid';
		websys_setfocus('Qnty');
		websys_cancel();
		return false;
	}	
	}
	return true;
}

function ReplaceLink(){
	linkFunct("Replace");
}

function ReplaceAllLink(){
	linkFunct("ReplaceAll");
}

function RemoveAllLink() {
	linkFunct("RemoveAll");
}
 function AddAllLink(){
	linkFunct("AddAll");
}

function AddLink() {
	linkFunct("Add");
}

function linkFunct(txt) {
	UpdateCareProv();
	UpdateSPPP();
	UpdateOPER();
	UpdateANMET();
	var url="";
	url="websys.default.csp?WEBSYS.TCOMPONENT=CTCareProvPrefMod.Edit&Action="+txt;
	obj=document.getElementById("ANMETParRef")
	if (obj) url=url+"&ANMETParRef="+obj.value;
	obj=document.getElementById("CareProvParRef")
	if (obj) url=url+"&CareProvParRef="+obj.value;
	obj=document.getElementById("ORPParRef")
	if (obj) url=url+"&ORPParRef="+obj.value;
	obj=document.getElementById("SPPPParRef")
	if (obj) url=url+"&SPPPParRef="+obj.value;
	obj=document.getElementById("selectedids")
	if (obj) url=url+"&selectedids="+obj.value;
	obj=document.getElementById("RecOperT")
	if (obj) url=url+"&RecOperT="+obj.value;
	obj=document.getElementById("recspppT")
	if (obj) url=url+"&recspppT="+obj.value;
	obj=document.getElementById("OpsOnlyT")
	if (obj) url=url+"&OpsOnlyT="+obj.value;
	objEQOI=document.getElementById("EQOrdItem")
	if (objEQOI) url=url+"&EQOrdItem="+objEQOI.value;
	if ((objEQOI)&&(objEQOI.value!="")) {
		var objEQARCIM=document.getElementById("EQARCIMDR");
		if (objEQARCIM){ url=url+"&EQARCIMDR="+objEQARCIM.value;}
		var objEQARCOS=document.getElementById("EQARCOSDR");
		if (objEQARCOS) {url=url+"&EQARCOSDR="+objEQARCOS.value;}
	}
	var win=websys_createWindow(url,"CTCareProvPrefModList","status=yes,scrollbars=yes,resizable=yes");	
}

function RemoveClickHandler(){
	if (!confirm(t['OIRemove']+t['DUWT'])) return false;
	Remove_click();
}

function SingleItmLnksAct() {
	EnableField("Replace");
	var objR=document.getElementById('Replace');
	if (objR) {objR.onclick=ReplaceLink;}
	EnableField("Remove");
	var objRm=document.getElementById('Remove');
	if (objRm) {objRm.onclick=RemoveClickHandler;}
	EnableField("AddItem");
	var objA=document.getElementById('AddItem');
	if (objA) {objA.onclick=AddLink;}
		
	var objAA=document.getElementById('AddAll');
	if (objAA){
		objAA.disabled=true;
		objAA.onclick=LinkDisable;
	}
	var objRpA=document.getElementById('ReplaceAll');
	if (objRpA) {
		objRpA.disabled=true;
		objRpA.onclick=LinkDisable;
	}
	var objRmA=document.getElementById('RemoveAll');
	if (objRmA) {
		objRmA.disabled=true;
		objRmA.onclick=LinkDisable;
	}
}

function MultItmLnksAct() {
		var obj=document.getElementById('Replace');
		if (obj){
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById('Remove');
		if (obj){
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById('AddItem');
		if (obj){
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		EnableField("AddAll");
		var obj=document.getElementById('AddAll');
		if (obj) {obj.onclick=AddAllLink;}
		EnableField("RemoveAll");
		var obj=document.getElementById('RemoveAll');
		if (obj) {obj.onclick=RemoveAllLink;}
		EnableField("ReplaceAll");
		var obj=document.getElementById('ReplaceAll');
		if (obj) {obj.onclick=ReplaceAllLink;}
}
///////////////////////////////// END LIST BOXES ////////////////////////////////////////////////////////////////////////

//TN: call this outside onload call so it can be called straight away, and not wait till everything has loaded.
//ReloadListBoxes();

document.body.onload=Init;
