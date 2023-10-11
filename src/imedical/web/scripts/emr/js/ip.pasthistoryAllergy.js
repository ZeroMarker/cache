$(function(){
	window.returnValue = "ok";
	var tempFrame = "<iframe id='iframeAllergyEnter' scrolling='auto' frameborder='0' src='dhcdoc.allergyenter.csp?EpisodeID=" + episodeID + "&PatientID=" + patientID + "&RegNo=" + papmiNo + "' style='width:1126px; height:468px; display:block;'></iframe>";
	$('#center').append(tempFrame);
});

