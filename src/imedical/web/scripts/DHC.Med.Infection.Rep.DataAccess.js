

function CreateDicDataStore(DicType)
{
		var objArry = QueryDicItemByTypeFlag("MethodQueryDicItemByTypeFlag", DicType, "Y");
		return CreateDicStore(objArry);
}



function CreateGermDataStore()
{
		var objArry = QueryPathogenDic("MethodQueryPathogenDic1", "MethodQueryPathogenDic2", "","","Y");
		return CreateDicStore(objArry);
}

function CreateAntiDicDataStore()
{
		var objArry = QueryAntiDic("MethodQueryAntiDic1", "MethodQueryAntiDic2", "","","Y");
		return CreateDicStore(objArry);	
}

//get  dictionary combobox  's  value:returns dictionary object
function GetDicComboValue(cbo)
{
	if(cbo == null)
		return null;
	var objStore = cbo.initialConfig.store;
	var objData = null;
	if(objStore.getCount() == 0)
		return 0;
	var strValue = cbo.getValue();
	for(var i = 0; i < objStore.getCount(); i ++)
	{
		objData = objStore.getAt(i);
		if(objData.data.Code == strValue)
			return objData.data.DicObj;
	}
	return null;
}

function SetDicComboValue(cbo, strValue)
{
	if(cbo == null)
		return null;
	var objStore = cbo.initialConfig.store;
	var objData = null;
	if(objStore.getCount() == 0)
		return;
	cbo.setValue(strValue);
}

//set ext.data.record 's value both display and relatived obj
function SetDicRecValue(objRec, Displayfield, ObjField, objDic)
{
		objRec.set(Displayfield, objDic.Desc);
		objRec.set(ObjField, null);
		objRec.set(ObjField, objDic);
}

function SetPositionDicRecValue(objRec, Displayfield, ObjField, objDic)
{
		objRec.set(Displayfield, objDic.InfPosition);
		objRec.set(ObjField, null);
		objRec.set(ObjField, objDic);
}


//get selected record of a grid
function GetGridSelectedData(objGrid)
{
    var objSel = objGrid.getSelectionModel();
    var objData = null;
    if(objSel.selections.items.length > 0)
    {
    	objData = objSel.selections.items[0];
    }
		return objData;
}

function GetGridCheckedCount(objGrid, withPChange)
{
    var objStore = objGrid.getStore();
    var objData = null;
    var cnt = 0;
    for(var i = 0; i < objStore.getCount(); i ++)
    {
    	objData = objStore.getAt(i);
    	if(objData.get('checked') && (objData.get('pChange') || (!withPChange)))
    		cnt ++;
    }
		return cnt;		
}

//Create a simple data store for infection position
function CreateInfectionPositionStore()
{
	var obj = null;
	var objData = null;
	var arryData = new Array();
	var store = new Ext.data.SimpleStore({
			fields: ['RowID', 'Code', 'Description', 'DicObj']
		});
	var arry = QueryInfectionPositionByFlag('MethodQueryInfectionPositionByFlag', "Y");
	for(var i = 0; i < arry.length; i ++)
	{
		obj = arry[i];
	  objData = new Ext.data.Record({
	  	RowID : obj.RowID,
	  	Code : obj.RowID,          //Report Save RowID     obj.Code-->obj.RowID    update by zf 20090410
	  	Description : obj.InfPosition,
	  	DicObj:obj
	  });
	  arryData[i] = objData;
	}
	store.add(arryData);
	return store;
}



function DisplayPatientBaseInfo(objPatient, objAdm)
{
	if(objPatient != null)
	{
		objRepControl.txtRegNo.setValue(objPatient.PatientNo);
		objRepControl.txtMrNo.setValue(objPatient.MedRecNo);
		objRepControl.txtName.setValue(objPatient.PatientName);
		objRepControl.txtSex.setValue(objPatient.Sex);
		objRepControl.txtAge.setValue(objPatient.Age);
	}
	if(objAdm != null)
	{
		objRepControl.txtAdmitDate.setValue(objAdm.AdmDate);
		objRepControl.txtDisDate.setValue(objAdm.DischgDate);
		objRepControl.txtBed.setValue(objAdm.BedDesc);
	}
	SelectFirstItem(objRepControl.cboRepPlace, "Code"); //Add BY LiYang 2009-4-7
}

function DisplayPatientDiagnose(Paadm)
{
	var arryDiagnose = QueryAdmitDiagnose("MethodQueryAdmitDiagnose", Paadm);
	var objRec = null;
	var objDis = null;
	var arryData = new Array();
	var objStore = objRepControl.gridAdmitDiagnose.getStore();
	for(var i = 0; i < arryDiagnose.length; i ++)
	{
		objDis = arryDiagnose[i];
		objRec = new Ext.data.Record({
			   RowID:objDis.ICDRowID,
			   ICDCode:objDis.ICD,
			   ICDDescription:objDis.DiagnoseName,
			   DiagnoseType:objDis.DiagnoseTypeDesc,
			   DoctorCode:objDis.Doctor.Code,
			   Doctor:objDis.Doctor.UserName,
			   DiagnoseDate:objDis.DiagnoseDate,
			   DiagnoseTime:objDis.DiagnoseTime,
			   objAdmitDiagnose:objDis,
			   objRepDiagnose:null			
	  });
		arryData[i] = objRec;	
	}
	objStore.removeAll();
	objStore.add(arryData);	
	objRepControl.gridAdmitDiagnose.getView().refresh();
}

function DisplayPatientOperation(Paadm)
{
	var arry = QueryAdmitOperation("MethodQueryAdmitOperation", Paadm);
	var objRec = null;
	var obj = null;
	var arryData = new Array();
	var objStore = objRepControl.gridOperation.getStore();
	for(var i = 0; i < arry.length; i ++)
	{
		obj = arry[i];
		objRec = new Ext.data.Record({
			   RowID:obj.OperationRowID,
			   OperationName:obj.OperationName,
			   EmergencyOperation:"",
			   OrderDate:obj.OrderDate,
			   OrderStatus:obj.Status,
			   StartDate:obj.StartDate+ " " + obj.StartTime,  //20090826
			   StartTime:obj.StartTime,
			   EndTime:obj.EndTime,          //20090826
			   EndDate:obj.EndDate+ " " +obj.EndTime,
			   //Modified 2009-12-14 fix bug:手术医师为空时引起错误
			   Operator:(obj.OperDocObj != null ? obj.OperDocObj.DoctorName : ""),      //obj.OperDoc,
			   OperatorObj:(obj.OperDocObj == null? new DHCMedDoctor() : obj.OperDocObj), //obj.OperDocObj,                //new DHCMedDoctor(), 20090826
			   NarcosisType:obj.Anamed,
			   NarcosisTypeObj:new DHCMedDictionaryItem(),
			   CutType:"",
			   CutTypeObj:new DHCMedDictionaryItem(),
			   CloseType:"",
			   CloseTypeObj:new DHCMedDictionaryItem(),
			   CutInfected:"",
			   OperationCutInfected:"",
			   CauseInfection:"",
			   objOpeInfo:obj,
			   objRepOpe:	null,
			   Day:"",
			   Minute:"",
			   Hour:"",
			   After:"",
			   OpeCutType:"",
			   OpeCutTypeObj:new DHCMedDictionaryItem(),
			   checked:false,
			   OpICD:obj.OPICD9Map
	  });
		arryData[i] = objRec;	
	}
	objStore.removeAll();
	objStore.add(arryData);	
	objRepControl.gridOperation.getView().refresh();	
}

function DisplayPatientLabCheck(Paadm)
{
	var arry = QueryAdmitLabCheck("MethodQueryAdmitLabCheck", Paadm);
	var objRec = null;
	var obj = null;
	var arryData = new Array();
	var objStore = objRepControl.gridLab.getStore();
	for(var i = 0; i < arry.length; i ++)
	{
		obj = arry[i];
		objRec = new Ext.data.Record({
			   RowID:obj.OrderID,
			   LabCheckName:obj.LabName,
			   OrderDate:obj.LabDate,
				 OrderStatus:obj.Status,
				 InfectionPosition:"",
				 InfectionPositionObj:new DHCMedInfectPosition(),
				 CheckDate:"",
				 CheckMethod:"",
				 SensitiveCheck:"",
				 SensitiveObj:new DHCMedDictionaryItem(),
				 objLabItem:obj,
				 objInfLab:null,
				 SimpleObj:new DHCMedDictionaryItem(),
				 Simple:"",
				 CheckMethodObj:new DHCMedDictionaryItem(),
				 ArryGerm:new Array()
	  });
		arryData[i] = objRec;	
	}
	objStore.removeAll();
	objStore.add(arryData);	
	objRepControl.gridLab.getView().refresh();	
}

function DisplayPatientArcim(Paadm, Drugflag)
{
	var arry = QueryAdmitArcim("MethodQueryAdmitArcim", Paadm, Drugflag);
	var objRec = null;
	var obj = null;
	var arryData = new Array();
	var objStore = objRepControl.gridDrug.getStore();
	for(var i = 0; i < arry.length; i ++)
	{
		obj = arry[i];
		objRec = new Ext.data.Record({
			   RowID:obj.OrderID,
			   DrugName:obj.ArcimDesc,
			   DrugsRoute:"",
				 FromDate:obj.StartDate,
				 ToDate:obj.EndDate,
				 UseDayCnt:obj.Days,
				 AdministerDrugs:"",
				 InfectionAdministerDrugsGoal:"",
				 CureAdministerDrugsType:"",
				 DefendAdministerDrugsType:"",
				 Indication:"",
				 Effect:"",
				 UnionDrug:"",
				 AroundOpeDrug:"",
				 BeforeOpeDate:"",
				 AfterOpeDate:"",
				 Rationality:"",
				 Irrationality:"",
				 CurativeEffect:"",
				 ArcimObj:obj,
				 RepObj:null,
			   DrugsRouteObj: new DHCMedDictionaryItem(),
				 AdministerDrugsObj: new DHCMedDictionaryItem(),
				 InfectionAdministerDrugsGoalObj: new DHCMedDictionaryItem(),
				 CureAdministerDrugsTypeObj: new DHCMedDictionaryItem(),
				 DefendAdministerDrugsTypeObj: new DHCMedDictionaryItem(),
				 IndicationObj: new DHCMedDictionaryItem(),
				 EffectObj: new DHCMedDictionaryItem(),
				 UnionDrugObj: new DHCMedDictionaryItem(),
				 AroundOpeDrugObj: new DHCMedDictionaryItem(),
				 BeforeOpeDateObj: new DHCMedDictionaryItem(),
				 AfterOpeDateObj: new DHCMedDictionaryItem(),
				 RationalityObj: new DHCMedDictionaryItem(),
				 IrrationalityObj: new DHCMedDictionaryItem(),
				 CurativeEffectObj: new DHCMedDictionaryItem()
	  });
		arryData[i] = objRec;	
	}
	objStore.removeAll();
	objStore.add(arryData);	
	objRepControl.gridDrug.getView().refresh();	
} 

function GetInfectionRep(RowID)
{
	var objReport = GetInfRep("MethodGetInfRep", RowID);
	var objLab = null;
	var objGerm = null;
	if(objReport == null)
		return null;
	objReport.DiagnoseArry = GetInfRepDia("MethodGetInfRepDia", RowID);
	objReport.ReasonArry = GetInfRepRea("MethodGetInfRepRea", RowID);
	objReport.InfectionArry = GetInfRepPos("MethodGetInfRepPos", RowID);
	objReport.LabArry = GetInfRepPathogeny("MethodGetInfRepPathogeny", RowID);
	
	//objReport.Sen = GetInfRepPyObjDrug("MethodGetInfRepPyObjDrug", RowID);
	objReport.OpeArry = GetInfRepOPR("MethodGetInfRepOPR", RowID);
	objReport.DrugArry = GetInfRepDrug("MethodGetInfRepDrug", RowID);
	for(var i = 0; i < objReport.LabArry.length; i ++)
	{
		objLab = objReport.LabArry[i];
		objLab.GermArry = GetInfRepPyObj("MethodGetInfRepPyObj", objLab.RowID);
		for(var j = 0; j < objLab.GermArry.length; j ++)
		{
			objGerm = objLab.GermArry[j];
			objGerm.arryDrug = GetInfRepPyObjDrug("MethodGetInfRepPyObjDrug", objGerm.RowID);
		}	
	}
	
	
	return objReport;
}



