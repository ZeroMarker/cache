var PreMedPanel=(function(){
	function Init(){
		LoadPatClinicalRec();
	}
	function LoadPatClinicalRec(){
		/*var rtn=$.cm({
	    ClassName : "EMRservice.InterfaceService.EMRRecordInfo",
	    MethodName : "GetHistoryEMRContentInfo",
	    dataType:"text",
	    "APatientID":PatientID,
	    "ADataConfig":"HDSD00.11|HDSD00.11.010",
	    "ASeq":"Desc",
	    },false);
	    if (rtn!="") {$("#PreMedRecord").val(rtn)}*/
	}
	function OtherInfo(){
		return ""
	}
	function PrintInfo(){
		var rtnObj = {}	
		var MedRecord=$("#InpotExamReport").val()
		var Stringlength=MedRecord.length
		var Number=1,StartLeng=0,MaxLength=100
		for (var j=0; j < MedRecord.length; j++){
			if ((j-StartLeng)>=MaxLength){
				rtnObj["#InpotExamReport"+Number] = str.substr(StartLeng,j);
				StartLeng=j
				Number++
				}else if(j==MedRecord.length){
				rtnObj["#InpotExamReport"+Number] = str.substr(StartLeng,j);	
				}
			}
		return rtnObj
	}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
	   
})();