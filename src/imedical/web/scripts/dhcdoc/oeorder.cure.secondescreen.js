$(document).ready(function(){
	if (ServerObj.PageShowFromWay=="ApplyEntry"){
		$('#BPanel').empty().append('<table id="PatientCureTab"></table>');
	}
	if (ServerObj.PageShowFromWay=="AssEntry"){
		var src=ServerObj.AssUrl.replace(/\^/g,"&");   
		var frame='<iframe id="findapply" name="findapply" src='+src+' width="100%" min-height="500px" height="100%" frameborder="0"></iframe>'
		$('#BPanel').empty().append(frame);
	}
})
$(function(){
	debugger
	if (ServerObj.PageShowFromWay=="ApplyEntry"){
		var Obj = {
		    PatientID: ServerObj.PatientID,
		    StartDate: ServerObj.PreDate,
		    EndDate: ServerObj.CuDate,
		    TriageFlag: "ALL",
		    queryOrderLoc: session['LOGON.CTLOCID'],
		    queryExpStr: session['LOGON.HOSPID']+"^^^^A^doccure.workreport.patientcure.hui.csp^^^Y"
		}
		
		CureReportObj.InitPatientCureTabDataGrid();
		CureReportObj.PatientCureTabDataGridLoad(Obj);
	}
	if (ServerObj.PageShowFromWay=="AssEntry"){
		 /*setTimeout(function() { 
        	$("#QueEmr").hide();
			$("#CureAssSave").hide();
			$("#CureAssPrt").hide();
        }, 5000);*/
		
	}
	
})
