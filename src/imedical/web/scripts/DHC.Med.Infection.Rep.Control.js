var strPatientID = GetParam(window, "PatientID");
var strAdmID = GetParam(window, "EpisodeID");
var strReportID = GetParam(window, "ReportID");
var dicInfectionCutType = null;
var dicInfectionWoundCicatrize = null;
var objCurrentReport = null;
var objCurrentConfig = null;



var objCurrentPatient = null;
var objCurrentAdm = null;

var objRepControl = null;//<-------------GUI Control Object!!!!!

function ProcessRequest()
{
	//Display Report
	if(strReportID != "")
	{
		var objReport = GetInfectionRep(strReportID);
		if(objReport != null)
			strAdmID = objReport.Paadm_DR;
	}
	
	objCurrentAdm = GetPatientAdmitInfo("MethodGetPatientAdmitInfo", strAdmID);
	if(objCurrentAdm == null)
	{
		window.alert("Parameter Error!!!!!!!");
		window.close();	
		return;
	}
	objCurrentPatient = GetPatientByID("MethodGetPatientByID", objCurrentAdm.PatientID);
	DisplayPatientBaseInfo(objCurrentPatient, objCurrentAdm)
	DisplayPatientDiagnose(objCurrentAdm.RowID);
	DisplayPatientOperation(objCurrentAdm.RowID);
	DisplayPatientLabCheck(objCurrentAdm.RowID);
	DisplayPatientArcim(objCurrentAdm.RowID, "Y");
	if(objReport != null){
		DisplayInfectionReport(objReport);
	}
}

//*************DisplayReport*************************

function DisplayInfectionReport(objReport)
{
	objCurrentReport = objReport;
	var objDic = new ActiveXObject("Scripting.Dictionary");
	var obj = null;
	var obj1 = null;
	var objRecDic = null;
	var objData = null;
	var objStore = null;
	//BaseInfo
	objRepControl.txtNo.setValue(objReport.RowID);
	SetDicComboValue(objRepControl.cboLapseTo, objReport.LapseTo);	
	SetDicComboValue(objRepControl.cboRelation, objReport.DeathConnection);	
	SetDicComboValue(objRepControl.cboICU, objReport.ICUFlag);	
	SetDicComboValue(objRepControl.cboRepPlace, objReport.RepPlace);	
	objRepControl.chkUntowardReaction.setValue(objReport.DrugEffect == "Y");
	objRepControl.chkDoubleInfection.setValue(objReport.DblInfFlag == "Y");
	//Add By LiYang 2009-12-07 Mission:7110	
	//objRepControl.txtTreatmentInfo.setValue(objReport.Treatment);
	//objRepControl.txtAnalyse.setValue(objReport.Analysis);
	
	
	//Diagnose
	objDic.RemoveAll();
	for(var i = 0; i < objReport.DiagnoseArry.length; i ++)
	{
		obj = objReport.DiagnoseArry[i];
		if(!objDic.Exists(obj.DiagnoseRowID))
		{
			objDic.Add(obj.DiagnoseRowID, obj);
		}	
	}
	objStore = objRepControl.gridAdmitDiagnose.getStore();
	for(var i = 0; i < objStore.getCount(); i ++)
	{
		objData = objStore.getAt(i);
		if(obj1 = objData.get("objAdmitDiagnose"))
		{
			if(objDic.Exists(obj1.DiagnoseRowID))
			{	
				objData.set("checked", true);
				objData.set("pChange", true);
				objData.set("objRepDiagnose", null);
				objData.set("objRepDiagnose", objDic.Item(obj1.DiagnoseRowID));
			}
		}
	}
	objStore.commitChanges();
	
	//Dangerous
	objDic.RemoveAll();
	for(var i = 0; i < objReport.ReasonArry.length; i ++)
	{
		obj = objReport.ReasonArry[i];
		if(!objDic.Exists(obj.InfReason))
		{
			objDic.Add(obj.InfReason, obj);
		}	
	}
	objStore = objRepControl.gridDangerFactor.getStore();
	for(var i = 0; i < objStore.getCount(); i ++)
	{
		objData = objStore.getAt(i);
		if(obj1 = objData.get("Code"))
		{
			if(objDic.Exists(obj1))
			{	
				objData.set("checked", true);
				objData.set("pChange", true);
			}
		}
	}	
	objStore.commitChanges();
	
	//Operation
	objDic.RemoveAll();
	for(var i = 0; i < objReport.OpeArry.length; i ++)
	{
		obj = objReport.OpeArry[i];
		if(!objDic.Exists(obj.OEORI_DR))
		{
			objDic.Add(obj.OEORI_DR, obj);
		}	
	}
	objStore = objRepControl.gridOperation.getStore();
	for(var i = 0; i < objStore.getCount(); i ++)
	{
		objData = objStore.getAt(i);
		if(obj1 = objData.get("objOpeInfo").OperationRowID)
		{
			if(objDic.Exists(obj1))
			{	
				
				obj = objDic.Item(obj1);
				objData.set("StartDate", obj.DateFrom);	
				objData.set("StartTime", obj.DateFrom + " " + obj.TimeFrom);
				objData.set("StartDate", obj.DateFrom + " " + obj.TimeFrom);  //20090826
				objData.set("OpStartTime", obj.TimeFrom);
				objData.set("EndDate", obj.DateTo);	
				objData.set("EndDate", obj.DateTo + " " + obj.TimeTo);    //20090826
				objData.set("EndTime", obj.DateTo + " " + obj.TimeTo);
				objData.set("OpEndTime", obj.TimeTo);
				objData.set("EmergencyOperation", (obj.EmerOprFlag == "Y" ? "Yes" : ""));
				objData.set("CauseInfection", (obj.InfectionFlag == "Y" ? "Yes" : ""));
				objData.set("CutInfected", (obj.CuteInfFlag == "Y" ? "Yes" : "")); 
	
				var objSelCut = GetDicValueFromCombo(objRepControl.cboCutType, 'Code', obj.CuteType);
				var objClose = new DHCMedDictionaryItem();
				var objCut = new DHCMedDictionaryItem();
				switch(objSelCut.Code)
				{
						case "1":
						case "2":
						case "3":
							objClose = dicInfectionWoundCicatrize.Item("1");
							objCut = dicInfectionCutType.Item("1");
							break;
						case "4":
						case "5":
						case "6":
							objClose = dicInfectionWoundCicatrize.Item("2");
							objCut = dicInfectionCutType.Item("2");			
							break;
						case "7":
						case "8":
						case "9":
							objClose = dicInfectionWoundCicatrize.Item("3");
							objCut = dicInfectionCutType.Item("3");			
							break;
				}
				SetDicRecValue(objData, "CloseType", "CloseTypeObj", objClose);
				//SetDicRecValue(objRec, "OpeCutType", "OpeCutTypeObj", objCut);
				SetDicRecValue(objData, "NarcosisType", "NarcosisTypeObj", GetDicValueFromCombo(objRepControl.cboNarcosisType, 'Code', obj.Anaesthesia));
				SetDicRecValue(objData, "CutType", "CutTypeObj", objCut);
				SetDicRecValue(objData, "OpeCutType", "OpeCutTypeObj", GetDicValueFromCombo(objRepControl.cboOpeCutType, 'Code', obj.CuteType));
				objData.set("OpICD", obj.OPICD9Map); 
				objData.set("Operator", obj.OprDocObj.DoctorName); 
				objData.set("OperatorObj", null); 
				objData.set("OperatorObj", obj.OprDocObj); 		
				objData.set("objRepOpe", null); 
				objData.set("objRepOpe", obj); 							
				objData.set("checked", true);
				objData.set("pChange", true);
			}
		}
	}	
	objStore.commitChanges();	
	
	//Infection
	objStore = objRepControl.gridInfetion.getStore();
	for(var i = 0; i < objReport.InfectionArry.length; i ++)
	{
		obj = objReport.InfectionArry[i];
		obj1 = GetDicValueFromCombo(objRepControl.gridInfetionOpe, 'Code', obj.InroadOpr);
		objData = new Ext.data.Record({
				 RowID:"",
			   Position:obj.InfPos_DR.InfPosition,
			   InfDate:obj.InfDate,
			   EndDate:obj.InfEndDate,
			   Days:obj.InfDays,
				 Diagnose:obj.InfDiag_DR.DiseaseName,
				 //Add By LiYang 2009-09-08 operate date and time
				 InfEdDate:obj.OprEndDate,
				 InfEdTime:obj.OprEndTime,
				 InfStDate:obj.OprStartDate,
				 InfStTime:obj.OprStartTime,
				 
				 Ope:obj1.Desc,
				 objPosition:obj.InfPos_DR,
				 objDiagnose:obj.InfDiag_DR,
				 OpeObj:obj1,
				 objInfection:obj	
				}
			);
		objStore.add([objData]);
	}
	
	//Lab
	objDic.RemoveAll();
	objStore = objRepControl.gridLab.getStore(); 
	for(var i = 0; i < objReport.LabArry.length; i ++)
	{
		obj = objReport.LabArry[i];
		if(!objDic.Exists(obj.OEORI_DR))
		{
			objDic.Add(obj.OEORI_DR, obj);
		}	
	}
	
	for(var i = 0; i < objStore.getCount(); i ++)
	{
		objData = objStore.getAt(i);
		if(!objDic.Exists(objData.get('RowID')))
			continue;
			
		obj = objDic.Item(objData.get('RowID'));
		if(obj.InfPos_DR == "") // Modified By LiYang Prevent User check checkbox and do not fill the information
			continue;
		SetPositionDicRecValue(objData, "InfectionPosition", "InfectionPositionObj", GetDicValueFromCombo(objRepControl.cboLabInfPos, 'RowID', obj.InfPos_DR));    //update by zf 20090410 RowID-->Code
		SetDicRecValue(objData, "Simple", "SimpleObj", GetDicValueFromCombo(objRepControl.cboSimple, 'Code', obj.Sample));
		SetDicRecValue(objData, "CheckMethod", "CheckMethodObj", GetDicValueFromCombo(objRepControl.cboCheckMethod, 'Code', obj.Method));
		objData.set('ArryGerm', null);
		objData.set('ArryGerm', obj.GermArry);
		//objData.set("SensitiveCheck", obj.DrugFlag == "Y" ? "Yes" : "");
		///* 20091010 cjb
		if(obj.DrugFlag == "Y")
		{
			objData.set("SensitiveCheck", SenResultOne);
		}
		if(obj.DrugFlag == "N")
		{
			objData.set("SensitiveCheck", SenResultTwo);
		}	
		if(obj.DrugFlag == "C")
	  {
			objData.set("SensitiveCheck", SenResultThr);	
		}
		//*/
		objData.set("CheckDate", obj.Date);
		objData.set("checked", true);
		objData.set("pChange", true);
	}	
	objStore.commitChanges();
	
	//Drug
		//a();	
	objDic.RemoveAll();
	objStore = objRepControl.gridDrug.getStore(); 
	for(var i = 0; i < objReport.DrugArry.length; i ++)
	{
		obj = objReport.DrugArry[i];
		if(!objDic.Exists(obj.OEORI_DR))
		{
			objDic.Add(obj.OEORI_DR, obj);
		}	
	}	
	var intDay = 0;
	var intHour = 0;
	var intMin = 0;
	
	for(var i = 0; i < objStore.getCount(); i ++)
	{
		objData = objStore.getAt(i);
		if(!objDic.Exists(objData.get('RowID')))
			continue;
		obj = objDic.Item(objData.get('RowID'));
		if(obj.Instr == "") // Modified By LiYang Prevent User check checkbox and do not fill the information
			continue;
		SetDicRecValue(objData, "DrugsRoute", "DrugsRouteObj", GetDicValueFromCombo(objRepControl.cboDrugsRoute, 'Code', obj.Instr));
		SetDicRecValue(objData, "AdministerDrugs", "AdministerDrugsObj", GetDicValueFromCombo(objRepControl.cboAdministerDrugs, 'Code', obj.Mode));
		SetDicRecValue(objData, "InfectionAdministerDrugsGoal", "InfectionAdministerDrugsGoalObj", GetDicValueFromCombo(objRepControl.cboInfectionAdministerDrugsGoal, 'Code', obj.Aim));
		SetDicRecValue(objData, "CureAdministerDrugsType", "CureAdministerDrugsTypeObj", GetDicValueFromCombo(objRepControl.cboCureAdministerDrugsType, 'Code', obj.CureDrugMode));
		SetDicRecValue(objData, "DefendAdministerDrugsType", "DefendAdministerDrugsTypeObj", GetDicValueFromCombo(objRepControl.cboDefendAdministerDrugsType, 'Code', obj.PrevDrugMode));
		SetDicRecValue(objData, "Effect", "EffectObj", GetDicValueFromCombo(objRepControl.cboEffect, 'Code', obj.PrevDrugEffect));
		SetDicRecValue(objData, "UnionDrug", "UnionDrugObj", GetDicValueFromCombo(objRepControl.cboUnionDrug, 'Code', obj.UniteDrug));
		SetDicRecValue(objData, "Rationality", "RationalityObj", GetDicValueFromCombo(objRepControl.cboRationality, 'Code', obj.RightFlag));
		SetDicRecValue(objData, "Irrationality", "IrrationalityObj", GetDicValueFromCombo(objRepControl.cboIrrationality, 'Code', obj.Impertinency));
		SetDicRecValue(objData, "CurativeEffect", "CurativeEffectObj", GetDicValueFromCombo(objRepControl.cboCurativeEffect, 'Code', obj.Effect));
		
		if(obj.PreDrugTime == "")
			obj.PreDrugTime = 0;
		intDay = Math.floor(obj.PreDrugTime / 24 / 60); 
		intMin = obj.PreDrugTime % 60;
		intHour = (obj.PreDrugTime - intMin - (intDay * 24 * 60)) / 60;
	  objData.set("Day", intDay);
		objData.set("Hour", intHour);
		objData.set("Minute", intMin);
		objData.set("BeforeOpeDate", intDay + "D" + intHour + "H" + intMin + "M");
		objData.set("AfterOpeDate", obj.AftDrugDays);	
		objData.set("Indication", obj.PrevDrugFlag == "Y" ? "Yes" : "");	
		objData.set("AroundOpeDrug", obj.OprDrugFlag == "Y" ? "Yes" : "");
		objData.set("checked", true);
		objData.set("pChange", true);
	}		
	objStore.commitChanges();
	
	objRepControl.btnSave.setDisabled(true);
	if((objReport.Status == '2') || (objReport.Status == '3'))//Passed an modified status
	{
		objRepControl.btnSave.setText(Modify);
		objRepControl.btnSave.setDisabled(false);
	}
	if((objReport.Status == '9') || (objReport.Status == '1'))//Delete an Waiting Status
	{
		objRepControl.btnSave.setText(Save);
		objRepControl.btnSave.setDisabled(false);
	}
	
}





//*************Operation*****************************
function DisplayOpeInfo(objRec)
{
	var stdt=objRec.data.StartDate;
	var tmpstdt=stdt.split(" ");
	stdt=tmpstdt[0];
	var stt=tmpstdt[1];
	var eddt=objRec.data.EndDate;
	var tmpeddt=eddt.split(" ");
	var eddt=tmpeddt[0];
	var edt=tmpeddt[1];
	objRepControl.cboNarcosisType.setValue(objRec.data.NarcosisTypeObj.Code);
	objRepControl.cboCutType.setValue(objRec.data.CutTypeObj.Code);
	objRepControl.cboOpeCutType.setValue(objRec.data.OpeCutTypeObj.Code);
	objRepControl.chkEmergencyOperation.setValue(objRec.data.EmergencyOperation == "Yes");
	objRepControl.chkCasuseInf.setValue(objRec.data.CauseInfection == "Yes");
  objRepControl.chkWoundInfection.setValue(objRec.data.CutInfected == "Yes");
  objRepControl.dtOpeStartDate.setValue(stdt);//  objRec.data.StartDate);
  objRepControl.txtOpeStartTime.setValue(stt); //objRec.data.OpStartTime);  //20090826
  objRepControl.dtOpeEndDate.setValue(eddt);     //objRec.data.EndDate);
  objRepControl.txtOpeEndTime.setValue(edt);
  objRepControl.txtOpeDoctor.setValue(objRec.data.OperatorObj.DoctorName);
  //objRepControl.txtICD.setValue(objRec.get("OpICD"));
  objRepControl.SelDoctor = objRec.get("OperatorObj");

}

function ValidateOpeInfo()
{
	var result = true;
	if(GetGridSelectedData(objRepControl.gridOperation) == null)
	{
			Ext.Msg.alert(Notice, PleaseSelectGridItem);
			return false;
	}	
  if(objRepControl.txtOpeDoctor.getValue() == "")
  {
  	Ext.Msg.alert(Notice, PleaseDoctor);
  	return false;
  }	
	if(GetDicComboValue(objRepControl.cboNarcosisType) == null) result = false;
  if(GetDicComboValue(objRepControl.cboCutType) == null) result = false;
  if(GetDicComboValue(objRepControl.cboOpeCutType) == null) result = false;
  if(!result)
  {
  		Ext.Msg.alert(Notice, AllComboBoxIsRequired);
  }
  return result;
}

function OpeSaveOnClick()
{
	if(!ValidateOpeInfo())
		return;
	var objStore = this.gridOperation.getStore();
	var objRec = GetGridSelectedData(this.gridOperation);
	if(objRec == null)
		return;
	objRec.set("StartDate", objRepControl.dtOpeStartDate.getRawValue());	
	objRec.set("StartTime", objRepControl.dtOpeStartDate.getRawValue() + " " + objRepControl.txtOpeStartTime.getValue());
	objRec.set("StartDate", objRepControl.dtOpeStartDate.getRawValue() + " " + objRepControl.txtOpeStartTime.getValue()); //20090826
	objRec.set("OpStartTime", objRepControl.txtOpeStartTime.getValue());
	objRec.set("EndDate", objRepControl.dtOpeEndDate.getRawValue());	
	objRec.set("EndTime", objRepControl.dtOpeEndDate.getRawValue() + " " + objRepControl.txtOpeEndTime.getValue());
	objRec.set("EndDate", objRepControl.dtOpeEndDate.getRawValue() + " " + objRepControl.txtOpeEndTime.getValue());
	objRec.set("OpEndTime", objRepControl.txtOpeEndTime.getValue());
	objRec.set("CauseInfection", objRepControl.chkCasuseInf.getValue() ? "Yes": "");
	objRec.set("EmergencyOperation", objRepControl.chkEmergencyOperation.getValue() ? "Yes": ""); 
	objRec.set("CutInfected", objRepControl.chkWoundInfection.getValue() ? "Yes": ""); 
	//objRec.set("OpICD", objRepControl.txtICD.getValue());
	
	var objSelCut = GetDicComboValue(objRepControl.cboCutType);
	var objClose = new DHCMedDictionaryItem();
	var objCut = new DHCMedDictionaryItem();
	switch(objSelCut.Code)
	{
			case "1":
			case "2":
			case "3":
				//objClose = dicInfectionWoundCicatrize.Item("1");
				objCut = dicInfectionCutType.Item("1");
				break;
			case "4":
			case "5":
			case "6":
				//objClose = dicInfectionWoundCicatrize.Item("2");
				objCut = dicInfectionCutType.Item("2");			
				break;
			case "7":
			case "8":
			case "9":
				//objClose = dicInfectionWoundCicatrize.Item("3");
				objCut = dicInfectionCutType.Item("3");			
				break;
	}
	
	switch(objSelCut.Code)
	{
			case "1":
			case "4":
			case "7":
				objClose = dicInfectionWoundCicatrize.Item("1");
				//objCut = dicInfectionCutType.Item("1");
				break;
			case "2":
			case "5":
			case "8":
				objClose = dicInfectionWoundCicatrize.Item("2");
				//objCut = dicInfectionCutType.Item("2");			
				break;
			case "3":
			case "6":
			case "9":
				objClose = dicInfectionWoundCicatrize.Item("3");
				//objCut = dicInfectionCutType.Item("3");			
				break;
	}	
	
	SetDicRecValue(objRec, "CloseType", "CloseTypeObj", objClose);
	//SetDicRecValue(objRec, "OpeCutType", "OpeCutTypeObj", objCut);
	SetDicRecValue(objRec, "NarcosisType", "NarcosisTypeObj", GetDicComboValue(objRepControl.cboNarcosisType));
	SetDicRecValue(objRec, "CutType", "CutTypeObj", objCut);
	SetDicRecValue(objRec, "OpeCutType", "OpeCutTypeObj", GetDicComboValue(objRepControl.cboOpeCutType));
	
	objRec.set("Operator", objRepControl.SelDoctor.DoctorName); 
	objRec.set("OperatorObj", null); 
	objRec.set("OperatorObj", objRepControl.SelDoctor); 
	objRec.set("checked", true);
	objRec.set("pChange", true);
	objStore.commitChanges();
}

//***************************************************

//********************Infection***********************
function DisplayInfInfo(objRec)
{
	
	
	/*objRepControl.cboNarcosisType.setValue(objRec.data.CheckMethodObj.Code);
	objRepControl.cboCutType.setValue(objRec.data.CutTypeObj.Code);
	objRepControl.cboOpeCutType.setValue(objRec.data.CutTypeObj.Code);
	
	objRepControl.chkEmergencyOperation.setValue(objRec.data.EmergencyOperation == "Yes");
	objRepControl.chkCasuseInf.setValue(objRec.data.CauseInfection == "Yes");
	objRepControl.chkWoundInfection.setValue(objRec.data.chkWoundInfection == "Yes");
	
	SetDicRecValue(objRec, "NarcosisType", "CheckMethodObj", GetDicComboValue(objRepControl.cboNarcosisType));
	SetDicRecValue(objRec, "CutType", "CutTypeObj", GetDicComboValue(objRepControl.cboCutType));
	SetDicRecValue(objRec, "OpeCutType", "OpeCutTypeObj", GetDicComboValue(objRepControl.cboOpeCutType));
	
	objRec.set("EmergencyOperation", objRepControl.chkEmergencyOperation.getValue()); 
	objRec.set("StartTime", objRepControl.dtOpeStartDate.getRawValue() + " " + objRepControl.txtOpeStartTime.getValue());
	objRec.set("EndTime", objRepControl.dtOpeEndDate.getRawValue() + " " + objRepControl.txtOpeEndTime.getValue());
	objRec.set("EmergencyOperation", objRepControl.chkEmergencyOperation.getValue());
	objRec.set("CauseInfection", objRepControl.chkCasuseInf.getValue() ? "Yes": "");	
	*/
}

function ValidateInfInfo()
{
	var result = true;
	if(GetDicComboValue(objRepControl.cboInfPosition) == null) result = false;
  if(objRepControl.objSelInfDis == null) result = false;
  if(objRepControl.dtInfDate.getRawValue() == "") result = false;
  if(!objRepControl.dtInfDate.isValid(false)) result = false;
  if(!result)
  {
  		Ext.Msg.alert(Notice, AllComboBoxIsRequired);
  }
  return result;
}

function SaveInfInfoOnClick()
{
	if(!ValidateInfInfo())
		return;
	var objRec = null;
	var objOpeStore = this.gridInfetionOpe.getStore();
	var objInfStore = this.gridInfetion.getStore();
	var objPosition = GetDicComboValue(objRepControl.cboInfPosition);
	var objOpe = null;
	for(var i = 0; i < objOpeStore.getCount(); i++)
	{
		objOpe = objOpeStore.getAt(i);
		if(objOpe.data.checked)
		{
			objRec = new Ext.data.Record(
				{
				 RowID:"",
			   Position:objPosition.InfPosition,
			   InfDate:objRepControl.dtInfDate.getRawValue(),
			   EndDate:objRepControl.dtEndDate.getRawValue(),
			   Days:objRepControl.txtInfDays.getValue(),
				 Diagnose:objRepControl.objSelInfDis.DiseaseName,
				 //Add By LiYang 2009-09-08
				 InfStDate:objRepControl.txtOprStartDate.getRawValue(),
				 InfStTime:objRepControl.txtOprStartTime.getRawValue(),
				 InfEdDate:objRepControl.txtOprEndDate.getRawValue(),
				 InfEdTime:objRepControl.txtOprEndTime.getRawValue(),
				 //------
				 Ope:objOpe.data.Description,
				 objPosition:objPosition,
				 objDiagnose:objRepControl.objSelInfDis,
				 OpeObj:objOpe.data.DicObj,
				 objInfection:null	
				}
			);
			objInfStore.add([objRec]);	
		}
	}
		
}

//****************************************************

//*************Lab************************************
function DisplayLabInfo(objRec)
{
	//objRepControl.chkSensitiveCheck.setValue(objRec.data.SensitiveCheck == "Yes");
	//20091010 cjb 
	//alert(objRec.data.SensitiveCheck);
	if(objRec.data.SensitiveCheck == SenResultOne)
	{
		objRepControl.cboSensitive.setValue("Y");
		objRepControl.btnSen.enable();
	}
	if(objRec.data.SensitiveCheck == SenResultTwo)
	{
		objRepControl.cboSensitive.setValue("N");
		objRepControl.btnSen.disable();
	}
	if(objRec.data.SensitiveCheck == SenResultThr)
	{
		objRepControl.cboSensitive.setValue("C");
		objRepControl.btnSen.disable();
	}
	objRepControl.dtLabDate.setValue(objRec.data.CheckDate);
	objRepControl.cboSimple.setValue(objRec.data.SimpleObj.Code);
	objRepControl.cboCheckMethod.setValue(objRec.data.CheckMethodObj.Code);
	objRepControl.cboLabInfPos.setValue(objRec.data.InfectionPositionObj.RowID);
	objRepControl.LabGermArry = objRec.get("ArryGerm");
}

function ValidateLabInfo()
{
	var result = true;
	if(GetGridSelectedData(objRepControl.gridLab) == null)
	{
			Ext.Msg.alert(Notice, PleaseSelectGridItem);
			return false;
	}
	if(GetDicComboValue(objRepControl.cboSimple) == null) result = false;
  if(GetDicComboValue(objRepControl.cboLabInfPos) == null) result = false;
  if(GetDicComboValue(objRepControl.cboCheckMethod) == null) result = false;
  if(!result)
  {
  		Ext.Msg.alert(Notice, AllComboBoxIsRequired);
  }
  return result;
}

function LabSaveOnClick(objRec)
{
	if(!ValidateLabInfo())
		return;
	SetPositionDicRecValue(objRec, "InfectionPosition", "InfectionPositionObj", GetDicComboValue(objRepControl.cboLabInfPos));
	SetDicRecValue(objRec, "Simple", "SimpleObj", GetDicComboValue(objRepControl.cboSimple));
	SetDicRecValue(objRec, "CheckMethod", "CheckMethodObj", GetDicComboValue(objRepControl.cboCheckMethod));
	
	//objRec.set("SensitiveCheck", objRepControl.chkSensitiveCheck.getValue() ? "Yes" : "");
	///* 20091010 cjb
	var tmpObj=GetDicComboValue(objRepControl.cboSensitive);
	if(tmpObj.Code=="Y")
	{
		objRec.set("SensitiveCheck",SenResultOne);
		
	}
	if(tmpObj.Code=="N")
	{
	  objRec.set("SensitiveCheck",SenResultTwo);
	  
	 }
	if(tmpObj.Code=="C")
	{
	  objRec.set("SensitiveCheck",SenResultThr);  
	  
	}
	//*/
	objRec.set("CheckDate", objRepControl.dtLabDate.getRawValue());
	objRec.set("ArryGerm", null);
	objRec.set("ArryGerm", objRepControl.LabGermArry);
	objRec.set("checked", true);
	objRec.set("pChange", true);	
}


//****************************************************



//*************Drug***********************************
function DisplayDrugInfo(objRec)
{
	if(objRec.get("pChange"))
	{
		objRepControl.cboDrugsRoute.setValue(objRec.data.DrugsRouteObj.Code);
	  objRepControl.cboAdministerDrugs.setValue(objRec.data.AdministerDrugsObj.Code);
	  objRepControl.cboInfectionAdministerDrugsGoal.setValue(objRec.data.InfectionAdministerDrugsGoalObj.Code);
	  objRepControl.cboCureAdministerDrugsType.setValue(objRec.data.CureAdministerDrugsTypeObj.Code);
	  objRepControl.cboDefendAdministerDrugsType.setValue(objRec.data.DefendAdministerDrugsTypeObj.Code);
	  objRepControl.cboEffect.setValue(objRec.data.EffectObj.Code);
	  objRepControl.cboUnionDrug.setValue(objRec.data.UnionDrugObj.Code);
	  objRepControl.cboRationality.setValue(objRec.data.RationalityObj.Code);
	  objRepControl.cboIrrationality.setValue(objRec.data.IrrationalityObj.Code);
	  objRepControl.cboCurativeEffect.setValue(objRec.data.CurativeEffectObj.Code);
	}
	else
	{
		if(objCurrentConfig.DrugFlg.length > 9)
		{
			if(objCurrentConfig.DrugFlg[0] == "1")
				SelectFirstItem(objRepControl.cboDrugsRoute, "Code");
			else
				objRepControl.cboDrugsRoute.setValue(objRec.data.DrugsRouteObj.Code);

			if(objCurrentConfig.DrugFlg[1] == "1")
				SelectFirstItem(objRepControl.cboAdministerDrugs, "Code");
			else
				objRepControl.cboAdministerDrugs.setValue(objRec.data.AdministerDrugsObj.Code);
						
			if(objCurrentConfig.DrugFlg[2] == "1")
				SelectFirstItem(objRepControl.cboInfectionAdministerDrugsGoal, "Code");
			else
				objRepControl.cboInfectionAdministerDrugsGoal.setValue(objRec.data.InfectionAdministerDrugsGoalObj.Code);
				
			if(objCurrentConfig.DrugFlg[3] == "1")
				SelectFirstItem(objRepControl.cboCureAdministerDrugsType, "Code");
			else
				objRepControl.cboCureAdministerDrugsType.setValue(objRec.data.CureAdministerDrugsTypeObj.Code);			
				
			if(objCurrentConfig.DrugFlg[4] == "1")
				SelectFirstItem(objRepControl.cboDefendAdministerDrugsType, "Code");
			else
				objRepControl.cboDefendAdministerDrugsType.setValue(objRec.data.DefendAdministerDrugsTypeObj.Code);
				
			if(objCurrentConfig.DrugFlg[5] == "1")
				SelectFirstItem(objRepControl.cboEffect, "Code");
			else
				objRepControl.cboEffect.setValue(objRec.data.EffectObj.Code);	
				
			if(objCurrentConfig.DrugFlg[6] == "1")
				SelectFirstItem(objRepControl.cboUnionDrug, "Code");
			else
				objRepControl.cboUnionDrug.setValue(objRec.data.UnionDrugObj.Code);
				
			if(objCurrentConfig.DrugFlg[7] == "1")
				SelectFirstItem(objRepControl.cboRationality, "Code");
			else
				objRepControl.cboRationality.setValue(objRec.data.RationalityObj.Code);	
				
			if(objCurrentConfig.DrugFlg[8] == "1")
				SelectFirstItem(objRepControl.cboIrrationality, "Code");
			else
				objRepControl.cboIrrationality.setValue(objRec.data.IrrationalityObj.Code);
				
			if(objCurrentConfig.DrugFlg[9] == "1")
				SelectFirstItem(objRepControl.cboCurativeEffect, "Code");
			else
				objRepControl.cboCurativeEffect.setValue(objRec.data.CurativeEffectObj.Code);					
								
		}
		else
		{
			objRepControl.cboDrugsRoute.setValue(objRec.data.DrugsRouteObj.Code);
		  objRepControl.cboAdministerDrugs.setValue(objRec.data.AdministerDrugsObj.Code);
		  objRepControl.cboInfectionAdministerDrugsGoal.setValue(objRec.data.InfectionAdministerDrugsGoalObj.Code);
		  objRepControl.cboCureAdministerDrugsType.setValue(objRec.data.CureAdministerDrugsTypeObj.Code);
		  objRepControl.cboDefendAdministerDrugsType.setValue(objRec.data.DefendAdministerDrugsTypeObj.Code);
		  objRepControl.cboEffect.setValue(objRec.data.EffectObj.Code);
		  objRepControl.cboUnionDrug.setValue(objRec.data.UnionDrugObj.Code);
		  objRepControl.cboRationality.setValue(objRec.data.RationalityObj.Code);
		  objRepControl.cboIrrationality.setValue(objRec.data.IrrationalityObj.Code);
		  objRepControl.cboCurativeEffect.setValue(objRec.data.CurativeEffectObj.Code);
		}
	}	
	objRepControl.txtDay.setValue(objRec.data.Day);
	objRepControl.txtHour.setValue(objRec.data.Hour);
	objRepControl.txtMinute.setValue(objRec.data.Minute);	
	objRepControl.txtAfter.setValue(objRec.data.AfterOpeDate);	
	objRepControl.chkIndication.setValue((objRec.data.Indication == 'Yes'));	
	objRepControl.chkAroundOpeDrug.setValue((objRec.data.AroundOpeDrug == 'Yes'));
}

function ValidateDrugInfo()
{
	var result = true;
	if(GetGridSelectedData(objRepControl.gridDrug) == null)
	{
			Ext.Msg.alert(Notice, PleaseSelectGridItem);
			return false;
	}
	if(GetDicComboValue(objRepControl.cboDrugsRoute) == null) result = false;
  if(GetDicComboValue(objRepControl.cboAdministerDrugs) == null) result = false;
  if(GetDicComboValue(objRepControl.cboInfectionAdministerDrugsGoal) == null) result = false;
  if(GetDicComboValue(objRepControl.cboCureAdministerDrugsType) == null) result = false;
  if(GetDicComboValue(objRepControl.cboDefendAdministerDrugsType) == null) result = false;
  if(GetDicComboValue(objRepControl.cboEffect) == null) result = false;
  if(GetDicComboValue(objRepControl.cboUnionDrug) == null) result = false;
  if(GetDicComboValue(objRepControl.cboRationality) == null) result = false;
  if(GetDicComboValue(objRepControl.cboIrrationality) == null) result = false;
  if(GetDicComboValue(objRepControl.cboCurativeEffect) == null) result = false;
  if(!result)
  {
  		Ext.Msg.alert(Notice, AllComboBoxIsRequired);
  }
  return result;
}

function DrugSaveOnClick(objRec)
{
	if(!ValidateDrugInfo())
		return;
	SetDicRecValue(objRec, "DrugsRoute", "DrugsRouteObj", GetDicComboValue(objRepControl.cboDrugsRoute));
	SetDicRecValue(objRec, "AdministerDrugs", "AdministerDrugsObj", GetDicComboValue(objRepControl.cboAdministerDrugs));
	SetDicRecValue(objRec, "InfectionAdministerDrugsGoal", "InfectionAdministerDrugsGoalObj", GetDicComboValue(objRepControl.cboInfectionAdministerDrugsGoal));
	SetDicRecValue(objRec, "CureAdministerDrugsType", "CureAdministerDrugsTypeObj", GetDicComboValue(objRepControl.cboCureAdministerDrugsType));
	SetDicRecValue(objRec, "DefendAdministerDrugsType", "DefendAdministerDrugsTypeObj", GetDicComboValue(objRepControl.cboDefendAdministerDrugsType));
	SetDicRecValue(objRec, "Effect", "EffectObj", GetDicComboValue(objRepControl.cboEffect));
	SetDicRecValue(objRec, "UnionDrug", "UnionDrugObj", GetDicComboValue(objRepControl.cboUnionDrug));
	SetDicRecValue(objRec, "Rationality", "RationalityObj", GetDicComboValue(objRepControl.cboRationality));
	SetDicRecValue(objRec, "Irrationality", "IrrationalityObj", GetDicComboValue(objRepControl.cboIrrationality));
	SetDicRecValue(objRec, "CurativeEffect", "CurativeEffectObj", GetDicComboValue(objRepControl.cboCurativeEffect));
	
	var intDay = (objRepControl.txtDay.getValue() == "" ? 0 : objRepControl.txtDay.getValue());
	var intHour = (objRepControl.txtHour.getValue() == "" ? 0 : objRepControl.txtHour.getValue());
	var intMinute = (objRepControl.txtMinute.getValue() == "" ? 0 : objRepControl.txtMinute.getValue());
  objRec.set("Day", intDay);
	objRec.set("Hour", intHour);
	objRec.set("Minute", intMinute);
	objRec.set("BeforeOpeDate", objRepControl.txtDay.getValue() + "D" + objRepControl.txtHour.getValue() + "H" + objRepControl.txtMinute.getValue() + "M");
	objRec.set("AfterOpeDate", objRepControl.txtAfter.getValue());	
	objRec.set("Indication", objRepControl.chkIndication.getValue() ? "Yes" : "");	
	objRec.set("AroundOpeDrug", objRepControl.chkAroundOpeDrug.getValue() ? "Yes" : "");
	objRec.set("checked", true);
	objRec.set("pChange", true);	
		
}
//************************************************
function ValidateContents()
{
	if(GetDicComboValue(objRepControl.cboLapseTo) == null)
	{
		Ext.Msg.alert(Notice, PleaseSelectLapseTo);
		return false;	
	}
	if(GetDicComboValue(objRepControl.cboRelation) == null)
	{
		Ext.Msg.alert(Notice, PleaseSelectRelation);
		return false;	
	}
	if(GetDicComboValue(objRepControl.cboICU) == null)
	{
		Ext.Msg.alert(Notice, PleaseSelectICU);
		return false;	
	}
			
	/*if(GetGridCheckedCount(objRepControl.gridAdmitDiagnose, false) <= 0)
	{
		Ext.Msg.alert(Notice, PleaseSelectAdmitDiagnose);
		return false;	
	}
	if(GetGridCheckedCount(objRepControl.gridDangerFactor, false) <= 0)
	{
		Ext.Msg.alert(Notice, PleaseSelectDangerousFactor);
		return false;	
	}	
	if(GetGridCheckedCount(objRepControl.gridOperation, true) <= 0)
	{
		Ext.Msg.alert(Notice, PleaseSelectOperation);
		return false;	
	}*/
	if(objRepControl.gridInfetion.getStore().getCount() <= 0)
	{
		Ext.Msg.alert(Notice, PleaseSelectInfection);
		return false;	
	}	
	/*if(GetGridCheckedCount(objRepControl.gridLab, true) <= 0)
	{
		Ext.Msg.alert(Notice, PleaseSelectLab);
		return false;	
	}	
	if(GetGridCheckedCount(objRepControl.gridDrug, true) <= 0)
	{
		Ext.Msg.alert(Notice, PleaseSelectDrug);
		return false;	
	}	*/	
	return true;	
}

function SaveToObject()
{
	var objStore = null;
	var objItm = null;
	var objData = null;
	var objRepData = null;
	if(objCurrentReport == null)
	{
		objCurrentReport = new DHCMedInfectionRep();
	}
	//main info
	objCurrentReport.Paadm_DR = strAdmID;
	objCurrentReport.LapseTo = GetDicComboValue(objRepControl.cboLapseTo).Code;
	objCurrentReport.DeathConnection = GetDicComboValue(objRepControl.cboRelation).Code;
	objCurrentReport.ICUFlag = GetDicComboValue(objRepControl.cboICU).Code;
	objCurrentReport.DrugEffect = (objRepControl.chkUntowardReaction.getValue() ? "Y" : "N");
	objCurrentReport.DblInfFlag = (objRepControl.chkDoubleInfection.getValue() ? "Y" : "N");
	objCurrentReport.RepPlace = GetDicComboValue(objRepControl.cboRepPlace).Code; //Add By LiYang 2009-4-7
	//objCurrentReport.BeModify_DR = "";
	//Add By LiYang 2009-12-07 Misson:7110
	//objCurrentReport.Treatment = objRepControl.txtTreatmentInfo.getValue();
	//objCurrentReport.Analysis = objRepControl.txtAnalyse.getValue();
	objCurrentReport.Date = strCurrDate;
	objCurrentReport.Time = strCurrTime;
	objCurrentReport.User_DR = session['LOGON.USERID'];
	//objCurrentReport.Status = "1";
	//objCurrentReport.CheckUsr_DR = "";
	//objCurrentReport.CheckDate = "";
	//objCurrentReport.CheckTime = "";
	objCurrentReport.Demo = "";	
	//diagnose info
	var arryDiagnose = new Array();
  objStore = objRepControl.gridAdmitDiagnose.getStore();
	for(var i = 0; i < objStore.getCount(); i ++)
	{
		objData = objStore.getAt(i); 
		if(!objData.get('checked'))
			continue;
		objItm = new DHCMedInfectionRepDia();
		objRepData = objData.get("objAdmitDiagnose"); //Modified By LiYang 2009-1-8
		objItm.MrDia_DR = objData.get("objAdmitDiagnose").DiagnoseRowID;
		objItm.DiagDesc = objData.get("objAdmitDiagnose").DiagnoseName;
		objItm.DiagType = objData.get("objAdmitDiagnose").DiagnoseTypeDesc;
		objItm.DiagDoc = objData.get("objAdmitDiagnose").Doctor.RowID;
		objItm.DiagDate = objData.get("DiagnoseDate");
		objItm.DiagTime = objData.get("DiagnoseTime");
		objItm.ICD10 = (objRepData.RepDia != null ? objRepData.RepDia.ICD10 : ""); //Modified By LiYang 2009-1-5
		objItm.ICD10Desc = (objRepData.RepDia != null ? objRepData.RepDia.ICD10Desc : "");
		objItm.IsActive = "Y";
		objItm.Resume = (objRepData.RepDia != null ? objRepData.RepDia.Resume : "");
		arryDiagnose.push(objItm);
	}
	objCurrentReport.DiagnoseArry = arryDiagnose;
	
	//dangerous factor
	var arryFactor = new Array();
	objStore = objRepControl.gridDangerFactor.getStore();
	for(var i = 0; i < objStore.getCount(); i ++)
	{
		objData = objStore.getAt(i); 
		if(!objData.get('checked'))
			continue;
		objItm = new DHCMedInfectionRepRea();
		objItm.InfReason = objData.get("DicObj").Code;
		arryFactor.push(objItm);
	}	
	objCurrentReport.FactorArry = arryFactor;
	
	//operation
		var arryOpe = new Array();
	objStore = objRepControl.gridOperation.getStore();
	for(var i = 0; i < objStore.getCount(); i ++)
	{
		objData = objStore.getAt(i); 
		if(!objData.get('checked'))
			continue;
		if(objData.get("OperatorObj") == null) //Modified By LiYang 2008-12-11 Prevent User check checkbox and do not fill information
			continue;	
		objItm = new DHCMedInfectionRepOPR();
		objRepData = objData.get("objRepOpe");
		objItm.OperationDesc = objData.get("OperationName");
		objItm.EmerOprFlag = (objData.get("EmergencyOperation") == "Yes" ? "Y" : "N");
		objItm.DateFrom = objData.get("StartDate");
		objItm.TimeFrom = objData.get("OpStartTime");
		objItm.DateTo = objData.get("EndDate");
		objItm.TimeTo = objData.get("OpEndTime");
		objItm.OprDoc = objData.get("OperatorObj").RowID;
		objItm.Anaesthesia = objData.get("NarcosisTypeObj").Code;
		objItm.CuteType = objData.get("CloseTypeObj").Code;
		objItm.Concrescence = objData.get("CloseTypeObj").Code;
		objItm.CuteInfFlag = (objData.get("CutInfected") == "Yes" ? "Y" : "N");
		objItm.OprCuteType = objData.get("OpeCutTypeObj").Code;
		objItm.InfectionFlag = (objData.get("CauseInfection") == "Yes" ? "Y" : "N");
		objItm.OEORI_DR = objData.get("RowID");
		objItm.OPICD9Map = (objRepData != null ? objRepData.OPICD9Map : ""); //Modified By LiYang 2009-1-5
		objItm.OperICD9Desc = (objRepData != null ? objRepData.OperICD9Desc : "");
		objItm.IsActive = "Y";
		objItm.Resume = (objRepData != null ? objRepData.Resume : "");
		
		arryOpe.push(objItm);
	}	
	objCurrentReport.OperationArry = arryOpe;
	
	//infection
	var arryInf = new Array();
	objStore = objRepControl.gridInfetion.getStore();
	for(var i = 0; i < objStore.getCount(); i ++)
	{
		objData = objStore.getAt(i); 
		objItm = new DHCMedInfectionRepPos();
		objItm.InfPos_DR = objData.get("objPosition").RowID;        //update by zf 20090410 Code-->RowID
		objItm.InfDate = (objData.get("InfDate"));
		objItm.InfDiag_DR = objData.get("objDiagnose").RowID;
		objItm.InroadOpr = objData.get("OpeObj").Code;
		objItm.InfEndDate = objData.get("EndDate");
		objItm.InfDays = objData.get("Days");
		//Add By LiYang 2009-09-08 operat start/end date and time
		objItm.OprEndDate = objData.get("InfEdDate");
		objItm.OprEndTime = objData.get("InfEdTime");
		objItm.OprStartDate = objData.get("InfStDate");
		objItm.OprStartTime = objData.get("InfStTime");
		arryInf.push(objItm);
	}		
	objCurrentReport.InfectionArry = arryInf;
	
	//Lab
	var arryLab = new Array();
	objStore = objRepControl.gridLab.getStore();
	for(var i = 0; i < objStore.getCount(); i ++)
	{
		objData = objStore.getAt(i); 
		if(!objData.get('checked'))
			continue;		
		if(objData.get("InfectionPositionObj") == null) //Modified By LiYang 2008-12-11 Prevent user check the checkbox and do not fill information
			continue;
		objItm = new DHCMedInfPathogeny();
		objItm.Sample = objData.get("SimpleObj").Code;
		objItm.InfPos_DR = objData.get("InfectionPositionObj").RowID;           //update by zf 20090410 Code-->RowID
		objItm.Date = objData.get("CheckDate");
		objItm.Method = objData.get("CheckMethodObj").Code;
		//objItm.DrugFlag = (objData.get("SensitiveCheck")=="Yes" ? "Y" : "N");
		//*20091010 cjb
		if(objData.get("SensitiveCheck")==SenResultOne)
			objItm.DrugFlag ="Y";
		if(objData.get("SensitiveCheck")==SenResultTwo)
			objItm.DrugFlag ="N";
		if(objData.get("SensitiveCheck")==SenResultThr)
			objItm.DrugFlag ="C";
		//*/
		objItm.OEORI_DR = objData.get("RowID");
		objItm.GermArry = objData.get('ArryGerm');
		arryLab.push(objItm);
	}			
	objCurrentReport.LabArry = arryLab;
	
	//Drug
	var arryDrug = new Array();
	objStore = objRepControl.gridDrug.getStore();
	for(var i = 0; i < objStore.getCount(); i ++)  
	{
		objData = objStore.getAt(i); 
		if(!objData.get('checked'))
			continue;		
		if(objData.get("DrugsRouteObj") == null)//Modified By LiYang 2008-12-11 Prevent user check the checkbox and do not fill information
			continue;
		//	a();
		objItm = new DHCMedInfectionRepDrug();
		objItm.OEORI_DR = objData.get("RowID");
		objItm.Instr = objData.get("DrugsRouteObj").Code;
		objItm.DateFrom = objData.get("FromDate");
		objItm.DateTo = objData.get("ToDate");
		objItm.Days = objData.get("UseDayCnt");
		objItm.Mode = objData.get("AdministerDrugsObj").Code;
		objItm.Aim = objData.get("InfectionAdministerDrugsGoalObj").Code;
		objItm.CureDrugMode = objData.get("CureAdministerDrugsTypeObj").Code;
		objItm.PrevDrugMode = objData.get("DefendAdministerDrugsTypeObj").Code;
		objItm.PrevDrugFlag = objData.get("Indication") ? "Y" : "N";
		objItm.PrevDrugEffect = objData.get("EffectObj").Code;
		objItm.UniteDrug = objData.get("UnionDrugObj").Code;
		objItm.OprDrugFlag = objData.get("AroundOpeDrugObj").Code;
		objItm.PreDrugTime = objData.get("Day") * 60 * 24 + objData.get("Hour") * 60 + objData.get("Minute");
		objItm.AftDrugDays = objData.get("AfterOpeDate");
		objItm.RightFlag = objData.get("RationalityObj").Code;
		objItm.Impertinency = objData.get("IrrationalityObj").Code;
		objItm.Effect = objData.get("EffectObj").Code;
		arryDrug.push(objItm);
	}				
	objCurrentReport.DrugArry = arryDrug;
	return objCurrentReport;
}

//Save Report
function SaveReport()
{
	 if(!ValidateContents())
     		return;
	var MainStr = "";
	var objReport = SaveToObject();
	
	//SetPower
	//update by zf 2008-10-08
	if((objReport.Status == '2')||(objReport.Status == '3'))
	{
		objReport.Status = '10'; 
		CheckInfRep(
			"MethodCheckInfRep",
			objCurrentReport.RowID, 
			"10",//-0 means Bedelete 
			objCurrentReport.CheckUsr_DR, 
			objCurrentReport.CheckDate, 
			objCurrentReport.CheckTime, 
			""
		);
		objReport.BeModify_DR = objReport.RowID;
		objReport.RowID = "";
		objReport.Status = '3';
	}else if ((objReport.Status == '1')||(objReport.Status == '9')||(objReport.Status == '')){
		objReport.Status = '1';
	}else{
		Ext.Msg.alert(Notice, UpdateRepError);
		return;
	}
   
   MainStr = SerializeDHCMedInfectionRep(objReport);
   var DiaStr = SerializeObjArry(objReport.DiagnoseArry, CHR_1, SerializeDHCMedInfectionRepDia);
	 var ReaStr = SerializeObjArry(objReport.FactorArry, CHR_1, SerializeDHCMedInfectionRepRea);
	 var OpeStr = SerializeObjArry(objReport.OperationArry, CHR_1, SerializeDHCMedInfectionRepOPR);
	 var InfStr = SerializeObjArry(objReport.InfectionArry, CHR_1, SerializeMedInfectionRepPos);
	 var LabStr = SerializeObjArry(objReport.LabArry, CHR_1, SerializeDHCMedInfPathogeny);
	 var DrugStr = SerializeObjArry(objReport.DrugArry, CHR_1, SerializeDHCMedInfectionRepDrug);
	 var GermStr = "";
	 var SenStr = "";       	    	
   var ret = SaveInfectionRep("MethodSaveInfectionRep", MainStr, DiaStr, ReaStr, InfStr, OpeStr, LabStr, DrugStr, GermStr, SenStr);
   if(ret > 0 )
   {
   	objCurrentReport = objReport;
   	objCurrentReport.RowID = ret;
   	Ext.Msg.alert(Notice, SaveSuccess);
   }
   else
   {
   	Ext.Msg.alert(Notice, SaveFail + ret);
   }
}

//DeleteReport()
function DeleteReport(demo)
{
	var ret = "";
	var objLastReport = null;
	if(objCurrentReport == null)
	{
		Ext.Msg.alert(Notice, PleaseSaveBefore);
		return;	
	}
	//SetPower
	//update by zf 2008-10-08
	if((objCurrentReport.Status != '1')&&(objCurrentReport.Status != '9'))
	{
		Ext.Msg.alert(Notice, DelStatusError);
		return;			
	}
	/*
	ret = CheckInfRep("MethodCheckInfRep", 
			objCurrentReport.RowID, 
			"0",//-0 means delete 
			objCurrentReport.CheckUsr_DR, 
			strCurrDate, 
			strCurrTime, 
			demo);	
         */
         ret = CheckInfRep("MethodDeleteInfRep", 
			objCurrentReport.RowID, 
			"0",//-0 means delete 
			session['LOGON.USERNAME'], 
			strCurrDate, 
			strCurrTime, 
			demo);	
	if(objCurrentReport.status == '3')
	{
		if(objCurrentReport.BeModify_DR != '')
		{
			objLastReport = GetInfRep("MethodGetInfRep", objCurrentReport.BeModify_DR);
			if(objLastReport.BeModify_DR == '')
			{
				ret = CheckInfRep("MethodCheckInfRep", 
						objLastReport.RowID, 
						"2",//-2 means passed 
						objLastReport.CheckUsr_DR, 
						objLastReport.CheckDate, 
						objLastReport.CheckTime, 
						objLastReport.Demo);	
			}
			else
			{
				ret = CheckInfRep("MethodCheckInfRep", 
						objLastReport.RowID, 
						"3",//-0 means modified 
						objLastReport.CheckUsr_DR, 
						objLastReport.CheckDate, 
						objLastReport.CheckTime, 
						objLastReport.Demo);					
			}
		}
	}
	Ext.Msg.alert(Notice, DelSuccess);
}


//Check Report
function CheckReport(NewStatus, Demo)
{
	if(objCurrentReport == null)
	{
		Ext.Msg.alert(Notice, PleaseSaveBefore);
		return;	
	}
	
	//SetPower
	//update by zf 2008-10-08
	if((NewStatus=="2")&&(objCurrentReport.Status != '1')&&(objCurrentReport.Status != '3'))
	{
		Ext.Msg.alert(Notice, NeedWaitStatus);
		return;
	}
	if((NewStatus=="9")&&(objCurrentReport.Status != '1'))
	{
		Ext.Msg.alert(Notice, SendBackError);
		return;
	}
	
	var ret = CheckInfRep("MethodCheckInfRep", 
		objCurrentReport.RowID, 
		NewStatus, 
		session['LOGON.USERID'], 
		strCurrDate, 
		strCurrTime, 
		Demo);
	if(ret > 0)
	{
		switch(NewStatus)
		{
			case 2:
				Ext.Msg.alert(Notice, AuditSuccess);
				break;
			case 9:
				Ext.Msg.alert(Notice, SendBackSuccess);
				break;	
		}
	}
	else
	{
		switch(NewStatus)
		{
			case 2:
				Ext.Msg.alert(Notice, AuditFail + ret);
				break;
			case 9:
				Ext.Msg.alert(Notice, SendBackFail + ret);
				break;	
		}		
	}
}
//-------------------------------------------------
function GetDicValueFromCombo(cbo, field, value)
{
		var objStore = cbo.initialConfig.store;
		var objData = null;
		for(var i = 0; i < objStore.getCount(); i ++)
		{
			objData = objStore.getAt(i);
			if(objData.get(field) == value)
				return objData.get("DicObj");
		}
		return null;
}


function SelectFirstItem(cbo, valueField)
{
	var objStore = cbo.initialConfig.store;
	if(objStore.getCount() == 0)
		return;
	var objData = objStore.getAt(0);
	cbo.setValue(objData.get(valueField));
}
//-------------------------------------------------
function WindowOnload()
{
	//document.body.appendChild(document.createElement("")); 
	objCurrentConfig = GetMedInfBaseConfig("MethodGetBaseConfig");	
	objRepControl = new InfectionRepControl();
	objRepControl.EditInfWin.show();
	dicInfectionCutType = QueryDicItemByTypeFlagDic("MethodQueryDicItemByTypeFlag", "InfectionCutType", "Y");
	dicInfectionWoundCicatrize = QueryDicItemByTypeFlagDic("MethodQueryDicItemByTypeFlag", "InfectionWoundCicatrize", "Y");
	ProcessRequest();
	//Add By LiYang 2009-11-08 hide scroll bar 
	document.body.scroll = "no";
}


window.onload = WindowOnload;
