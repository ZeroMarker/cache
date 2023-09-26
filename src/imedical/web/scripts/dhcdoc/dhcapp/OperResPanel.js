var OperResPanel=(function(){
	function Init(){
		if (ServerObj.RISOperNote!=""){
			$("#OperRes").val(ServerObj.RISOperNote)
			}
	}
	function OtherInfo(){
		return ""
	}
	function PrintInfo(){
		var rtnObj = {}	
		var MedRecord=$("#OperRes").val()
		var Stringlength=MedRecord.length
		var Number=0,StartLeng=0,MaxLength=40,Listrecord=""
		for (var j=0; j <= MedRecord.length; j++){
			if ((j-StartLeng)>=MaxLength){
				Number++
				rtnObj["OperRes"+Number] = MedRecord.substr(StartLeng,j);
				StartLeng=j
				Listrecord=""
			}else{
				Listrecord = MedRecord.substr(StartLeng,j);
					}
			}
		if (Listrecord!=""){
			Number++
			rtnObj["OperRes"+Number]=Listrecord}
		return rtnObj
	}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
	   
})();