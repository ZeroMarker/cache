var JCPanel=(function(){
	function Init(){
		/// 会诊专家	
		$('#ConsStaff').combobox({
			url:LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID="+'',
			//mode:'remote',
			blurValidValue:true,		
			onShowPanel:function(){		
				var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID="+'';
				$("#ConsStaff").combobox('reload',unitUrl);
			}
		});
		var rtn=$.cm({
	    ClassName : "EMRservice.InterfaceService.EMRRecordInfo",
	    MethodName : "GetHistoryEMRContentInfo",
	    dataType:"text",
	    "APatientID":PatientID,
	    "ADataConfig":"HDSD00.11|HDSD00.11.010",
	    "ASeq":"Desc",
	    },false);
	    if (rtn!="") {$("#SpecExaRes").val(rtn)}
	}
	function OtherInfo(){
		return ""
		}
	function PrintInfo(){
		var rtnObj = {}	
		var MedRecord=$("#SpecExaRes").val()
		var Stringlength=MedRecord.length
		var Number=0,StartLeng=0,MaxLength=100,Listrecord=""
		for (var j=0; j <= MedRecord.length; j++){
			if ((j-StartLeng)>=MaxLength){
				Number++
				rtnObj["SpecExaRes"+Number] = MedRecord.substr(StartLeng,j);
				StartLeng=j
				Listrecord=""
				}else{
				Listrecord = MedRecord.substr(StartLeng,j);
					}
			}
		if (Listrecord!=""){
			Number++
			rtnObj["SpecExaRes"+Number]=Listrecord}
		var MedRecord=$("#ConsNote").val()
		var Stringlength=MedRecord.length
		var Number=0,StartLeng=0,MaxLength=100,Listrecord=""
		for (var j=0; j <= MedRecord.length; j++){
			if ((j-StartLeng)>=MaxLength){
				Number++
				rtnObj["ConsNote"+Number] = MedRecord.substr(StartLeng,j);
				StartLeng=j
				Listrecord=""
				}else{
				Listrecord = MedRecord.substr(StartLeng,j);
					}
			}
		if (Listrecord!=""){
			Number++
			rtnObj["ConsNote"+Number]=Listrecord}
		return rtnObj
		}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
		}
	   
})();