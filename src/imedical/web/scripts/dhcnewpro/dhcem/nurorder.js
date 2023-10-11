var LINK_CSP="dhcapp.broker.csp";

$(function(){
	
	initParams();
	
	window.frames["nurOrderFrame"].onload  = function(){
		
		winDoc=window.frames["nurOrderFrame"];	
		
		initDom();
		
		initCombox();
	}
	
	//initCombox();	
})

function initParams(){
	var frm = dhcsys_getmenuform();
	if(frm){
		EpisodeID=frm.EpisodeID.value; 			
		PatientID=frm.PatientID.value; 	
	}	
}

function initDom(){
	var domHtml=""
	domHtml=domHtml+"<div style='width:300px;height:20px;position: absolute;right: 0px;top:40px'>";
	domHtml=domHtml+	"<span>选择就诊</span><input id='histAdm' class='hisui-combobox' style='width:220px'></input>";
	domHtml=domHtml+"</div>"
	
	winDoc.$("body").append(domHtml);
	return;
}

function initCombox(){
	winDoc.$HUI.combobox("#histAdm",{
		url:LINK_CSP+"?ClassName=web.DHCEMInComUseMethod&MethodName=JsonAdms&PatID="+PatientID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        parent.comboboxSelect(option);
	    },
	    onLoadSuccess:function(){
		    parent.comboboxLoadSuccess();
		}	
	})
	
}

function comboboxSelect(option){
	EpisodeID = option.value;
	flash(EpisodeID,PatientID);	
}

function comboboxLoadSuccess(){
	if(EpisodeID==""){
		var AllData=winDoc.$HUI.combobox("#histAdm").getData();
		if(AllData.length>0){
			EpisodeID=AllData[0].value
			winDoc.$HUI.combobox("#histAdm").setValue(AllData[0].value);
			flash(EpisodeID,PatientID);	
		}
	}else{
		winDoc.$HUI.combobox("#histAdm").setValue(EpisodeID);	
	}	
}

function flash(EpisodeID,PatientID){
	setEprMenuForm(EpisodeID,PatientID);
	flashNurOrderFrame();
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
	window.location.reload();	
	return;
}