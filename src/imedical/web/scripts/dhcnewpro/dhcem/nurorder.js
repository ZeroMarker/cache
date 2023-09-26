var LINK_CSP="dhcapp.broker.csp";

$(function(){
	
	initParams();
	
	initCombox();	
})

function initParams(){
	var frm = dhcsys_getmenuform();
	if(frm){
		EpisodeID=frm.EpisodeID.value; 			
		PatientID=frm.PatientID.value; 	
	}	
}

function initCombox(){
	$HUI.combobox("#histAdm",{
		url:LINK_CSP+"?ClassName=web.DHCEMInComUseMethod&MethodName=JsonAdms&PatID="+PatientID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        EpisodeID = option.value;
	        setEprMenuForm(EpisodeID,PatientID);
	        flashNurOrderFrame();
	    }	
	})
	if(EpisodeID!=""){
		$HUI.combobox("#histAdm").setValue(EpisodeID);	
	}
}


var setEprMenuForm = function(adm,papmi){
	var frm = dhcsys_getmenuform();
	if((frm) &&(frm.EpisodeID.value != adm)){
		frm.EpisodeID.value = adm; 			//DHCDocMainView.EpisodeID;
		frm.PatientID.value = papmi; 		//DHCDocMainView.PatientID;
		if(frm.AnaesthesiaID) frm.AnaesthesiaID.value = "";
		if(frm.PPRowId) frm.PPRowId.value = "";
	}
}

function flashNurOrderFrame(){
	$('#nurOrderFrame').attr('src', $('#nurOrderFrame').attr('src'));	
	return;
}