var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_3=String.fromCharCode(3);
var CHR_Up="^";
var CHR_Tilted="/";

function InitEventDisplayPatient(obj) {
	
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
		obj.txtMrNo.setValue(objPatient.MedRecNo);
		obj.txtName.setValue(objPatient.PatientName);
		obj.txtSex.setValue(objPatient.Sex);
		obj.txtAge.setValue(objPatient.Age);
		obj.txtWard.setValue(objAdm.Ward);
		
		obj.txtAdmitDate.setValue(objAdm.AdmDate);
		
		
	};
	
	
	obj.gridLab_rowdblclick = function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.gridLab.getStore().getAt(rowIndex);
		if(objRec == null)
			return;
		var strLabTestNo = objRec.get("LabTestNo");
		var strOrderID = objRec.get("OrderID");
		var objAdm = obj.AdmManage.GetObjById(obj.paadm);
		var objTestWin = new ShowTestWin(objAdm.PatientID, strOrderID, strLabTestNo);
				
	}
	


}
