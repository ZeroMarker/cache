function InitViewPatInfoEvent(obj) {
	obj.PatManage = ExtTool.StaticServerObject("DHCMed.Base.Patient");
	obj.AdmManage = ExtTool.StaticServerObject("DHCMed.Base.PatientAdm");
	obj.LoadEvent = function()
	{
		//obj.gridAdmitDiagnoseStore.load({});
		//obj.gridOperationStore.load({});
		//obj.gridOperation.load({});
		//obj.gridLabStore.load({});
		//obj.gridDrugStore.load({});
		

		var objAdm = obj.AdmManage.GetObjById(obj.paadm);
		var objPatient=obj.PatManage.GetObjById(objAdm.PatientID);
		obj.txtRegNo.setValue(objPatient.PapmiNo);
		obj.txtMrNo.setValue(objPatient.InPatMrNo);  //fix bug  8379 by pylian 2015-03-31 住院号、住院时间不显示
		obj.txtName.setValue(objPatient.PatientName);
		obj.txtSex.setValue(objPatient.Sex);
		var strSpeInfo = ExtTool.RunServerMethod("DHCMed.SPEService.PatientsSrv","GetPatInfoByAdm",obj.paadm);
		if (strSpeInfo == '') return;
		var arrSepInfo = strSpeInfo.split('^');
		var Age= arrSepInfo[7];
		
		obj.txtAge.setValue(Age);
		obj.txtWard.setValue(objAdm.Ward);
		
		obj.txtAdmitDate.setValue(arrSepInfo[8]);
		
	};
	
}
