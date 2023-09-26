﻿$(function(){
	setSuperior();
    if (episodeID == "")
    {
	  	var frm = dhcsys_getmenuform();
		patientID = frm.PatientID.value;
		episodeID = frm.EpisodeID.value;
	}
	initPatientList();  
	initPatientRecord();
	resetSize();
});

//切换用户(平台调用)
function xhrRefresh(refreshArgs)
{
	if (refreshArgs.adm == episodeID) return;
	patientID = refreshArgs.papmi;
	episodeID =  refreshArgs.adm;	 
	if (window.frames["framePatientRecord"])
    {
	    $('#framePatientRecord').attr("src",'emr.record.csp?PatientID=' + patientID + '&EpisodeID=' + episodeID);
	}
}
//Desc:患者列表
function initPatientList()
{
    var patientList= '<iframe id="framePatientList" src="emr.patientlist.csp" width="100%" height="100%"'+
                     'marginheight="0" marginwidth="0" scrolling="no" align="middle"></iframe>'	
    $('#patientList').append(patientList);                
}
//Desc:病历信息
function initPatientRecord()
{
	var patientRecord = '<iframe id="framePatientRecord"src="emr.record.csp?PatientID=' + patientID + 
                        '&EpisodeID=' + episodeID +'" width="100%" height="100%" marginheight="0"' + 
                        'marginwidth="0" scrolling="no" align="middle"></iframe>'; 
    
    $('#patientRecord').append(patientRecord);                   
}
var chartOnBlur = function(){
	document.getElementById('chartOnBlur').focus();
	if (window.frames["framePatientRecord"].frames["framRecord"])
	{
		window.frames["framePatientRecord"].frames["framRecord"].savePrompt("");
	}
	return true;
}

///页面适应窗口大小
function resetSize()  
{
	try
	{
		var posX=screen.availWidth;
		var posY=screen.availHeight;
		websys_move(0,0,posX,posY);
		$(".easyui-layout").layout('resize');
	}
	catch(err)
	{
	}
}

function setSuperior()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLSuperDoctor",
			"Method":"Check",			
			"p1":userID,
			"p2":userLocID
		},
		success: function(d){
           if (d == "0")
           {
	           window.open('emr.setsuperior.csp?UserID='+userID+'&UserName='+userName+'&UserLoc='+userLocID+'&SSGroupID='+ssgroupID,'','width=500px,height=300px'); 
	       }
		},
		error: function(d){alert("error");}
	});	
}