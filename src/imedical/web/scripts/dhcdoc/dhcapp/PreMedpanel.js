var PreMedPanel=(function(){
	function Init(){
		LoadPatClinicalRec();
	}
	function LoadPatClinicalRec(){
		var rtn=$.cm({
	    ClassName : "EMRservice.InterfaceService.EMRRecordInfo",
	    MethodName : "GetHistoryEMRContentInfo",
	    dataType:"text",
	    "APatientID":PatientID,
	    "ADataConfig":"HDSD00.11|HDSD00.11.010^HDSD00.11.008",
	    "ASeq":"Desc",
	    },false);
	   if ((rtn!="")&&(rtn!="^")) {
		    
		    $("#PreMedRecord").val(rtn.split("^")[0]+" 病理号:"+rtn.split("^")[1])}
	}
	function OtherInfo(){
		return ""
	}
	function PrintInfo(){
		var rtnObj = {}	
		var MedRecord=$("#PreMedRecord").val()
		var Stringlength=MedRecord.length
		var Number=0,StartLeng=0,MaxLength=40,Listrecord=""
		for (var j=0; j <= MedRecord.length; j++){
			if ((j-StartLeng)>=MaxLength){
				Number++
				rtnObj["PreMedRecord"+Number] = MedRecord.substr(StartLeng,j);
				StartLeng=j
				Listrecord=""
				}else{
				Listrecord = MedRecord.substr(StartLeng,j);
					}
			}
		if (Listrecord!=""){
			Number++
			rtnObj["PreMedRecord"+Number]=Listrecord
			}
		return rtnObj
	}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
	   
})();