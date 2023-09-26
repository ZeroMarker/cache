document.body.onload = BodyLoadHandler;
var AllDocStr=""
function BodyLoadHandler(){
	var DeptStr=""
	var CTLoc=DHCC_GetElementData('CTLoc');
	if (document.getElementById('CTLoc')){
			var DepStr=DHCC_GetElementData('DepStr');
			combo_AdmDep=dhtmlXComboFromStr("CTLoc",DepStr);
			combo_AdmDep.enableFilteringMode(true);
			combo_AdmDep.setComboText(CTLoc);
			combo_AdmDep.selectHandle=combo_AdmDepKeydownhandler;
			combo_AdmDep.attachEvent("onKeyPressed",combo_AdmDepKeyenterhandler)
		}
	var AdmDoc=DHCC_GetElementData('Doctor');
	if (document.getElementById('Doctor')){
			combo_AdmDoc=dhtmlXComboFromStr("Doctor",'');
			combo_AdmDoc.enableFilteringMode(true);
			combo_AdmDoc.selectHandle=combo_AdmDocKeydownhandler;
			combo_AdmDoc.setComboText(AdmDoc);
			combo_AdmDoc.attachEvent("onKeyPressed",combo_AdmDocKeyenterhandler)
		}
	var DepRowId=DHCC_GetElementData('CTlocID');
	if(DepRowId!="")
	{ 
		if (combo_AdmDoc){
		var encmeth=DHCC_GetElementData('GetResDocEncrypt');
		if ((encmeth!="")&&(DepRowId!="")){
			combo_AdmDoc.addOption('');
			var DocStr=cspRunServerMethod(encmeth,DepRowId);
			if (DocStr!=""){
				var Arr=DHCC_StrToArray(DocStr);
				combo_AdmDoc.addOption(Arr);
			}
		}
	}	
	}
	var DepRowId=DHCC_GetElementData('CTlocID');
	if(DepRowId!="")SetComboValue(combo_AdmDep,DepRowId);
	var DocRowId=DHCC_GetElementData('CTPCPID');
	if(DocRowId!="") SetComboValue(combo_AdmDoc,DocRowId);
	/*
	var vRBASID=DHCC_GetElementData('vRBASID');
	if (vRBASID!=""){
		var tables = document.getElementsByTagName("table");
		if (tables.length > 0){
			var InsuTable = tables[4].parentElement.parentElement;
			InsuTable.style.display = 'none';
		}
	}*/
	
}		
	function SetComboValue(obj,val){
	if (obj) {
		var ind=obj.getIndexByValue(val);
		if (ind==-1){obj.setComboText("");return;}
		obj.selectOption(ind)
	}
}	
function combo_AdmDocKeydownhandler()
{
	var DepRowId=DHCC_GetElementData('CTlocID')
	var DocRowId=combo_AdmDoc.getActualValue();
	mDocRowId=DocRowId;
	DHCC_SetElementData('CTPCPID',DocRowId);
	websys_nexttab(combo_AdmDoc.tabIndex);
}

function combo_AdmDepKeydownhandler(e){
	var DepRowId=combo_AdmDep.getActualValue();
	//var DepRowId=DHCC_GetComboValue(combo_ERepLoc);
	 DHCC_SetElementData('CTlocID',DepRowId);

	if (combo_AdmDoc){
		combo_AdmDoc.clearAll();
		combo_AdmDoc.setComboText("");
		var encmeth=DHCC_GetElementData('GetResDocEncrypt');
		if ((encmeth!="")&&(DepRowId!="")){
			combo_AdmDoc.addOption('');
			var DocStr=cspRunServerMethod(encmeth,DepRowId);
			if (DocStr!=""){
				var Arr=DHCC_StrToArray(DocStr);
				combo_AdmDoc.addOption(Arr);
			}
		}
	}	
	websys_nexttab(combo_AdmDep.tabIndex);
}

function combo_AdmDepKeyenterhandler(e){
	var keycode;
	try {
		keycode=websys_getKey(e);
	} catch(e) {keycode=websys_getKey();}
	if (keycode==13) {
		combo_AdmDepKeydownhandler();
	}
}
function combo_AdmDocKeyenterhandler(e){
	var keycode;
	try {
		keycode=websys_getKey(e);
	} catch(e) {keycode=websys_getKey();}
	if (keycode==13) {
		combo_AdmDocKeydownhandler();
	}
}