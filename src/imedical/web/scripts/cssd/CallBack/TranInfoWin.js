var TranInfoWin=function(packageLabel){
	//alert(packageLabel)
	$HUI.dialog('#TranInfoWin').open();
	var TransInfo = $.cm({
			ClassName: 'web.CSSDHUI.Trans.Trans',
			MethodName: 'GetTransDetailInfo',
			label:packageLabel 
	},false);
	var rowMain = $('#MainList').datagrid('getSelected');
	if(rowMain.ComplateFlag!="Y"){
		$UI.msg('alert',"需提交后方可查询!")
		$HUI.dialog('#TranInfoWin').close();
		return false;
	}
	if(isEmpty(TransInfo) ){
		$UI.msg('alert',"未查询到相关跟踪信息")
		$HUI.dialog('#TranInfoWin').close();
		return false;
	}else{
		delReturnData(TransInfo);
	}
	
	
	function delReturnData(JsonData){
		$("#barcode").text(JsonData.label)
		$("#packageName").text(JsonData.packageName)
		$("#packageStatue").text(JsonData.status)
		
		$("#CleanNO").text(JsonData.cleanBatchNo)
		$("#CleanGuoHao").text(JsonData.cleanMachineNo)
		$("#CleanUser").text(JsonData.cleanerName)
		$("#CleanDate").text(JsonData.cleanDateTime)
		$("#CleanAckUser").text(JsonData.cleanChkerName)
		$("#CleanAckDate").text(JsonData.cleanChkDateTime)
		
		
		$("#packUser").text(JsonData.packUserName)
		$("#packAckUser").text(JsonData.ackUserName)
		$("#packDate").text(JsonData.packDateTime)
		
		$("#SterNo").text(JsonData.batchNo)
		$("#SterGuoHao").text(JsonData.machineNo)
		$("#SterUser").text(JsonData.sterilizeUserName)
		$("#SterDate").text(JsonData.steDateTime)
		$("#SterAckUser").text(JsonData.steChkerName)
		$("#SterAckDate").text(JsonData.steChkDateTime)
		$("#SterExperDate").text(JsonData.expDate)
		
		
		$("#dispUser").text(JsonData.dispUserName)
		$("#dispDate").text(JsonData.dispDate)
		$("#ResUser").text(JsonData.toUserName)
		$("#ResDate").text(JsonData.rcvDate)
		$("#ResLoc").text(JsonData.toLocDesc)
		
		$("#CallBackUser").text(JsonData.callbackUserName)
		$("#CallBackDate").text(JsonData.callbackDateTime)
		$("#CallBackLoc").text(JsonData.fromLocDesc)
		//alert(JsonData.userinfo);
		if(!isEmpty(JsonData.userinfo)){
			$("#PatientId").text(JsonData.userinfo.patientId)
			$("#PatientName").text(JsonData.userinfo.patientName)
			$("#OprDoctorName").text(JsonData.userinfo.oprDoctorName)
			$("#InstNurseName").text(JsonData.userinfo.instNurseName)
			$("#CircNurseName").text(JsonData.userinfo.circNurseName)
			$("#OprDt").text(JsonData.userinfo.oprDt)
			$("#OprRoomNo").text(JsonData.userinfo.oprRoomNo)
			$("#OprRoom").text(JsonData.userinfo.oprRoom)
			$("#DeptName").text(JsonData.deptName)
			$("#UseDept").text(JsonData.userinfo.useDept)
			$("#InfectName").text(JsonData.userinfo.infectName)
		}
		/**
		transRowid^deptName^packageLoc ^recallflag^^
	^^sterilizeDetailDr^
	cleanDatailId^rcvDate^^useinfo
		
		*/
		
	}
}