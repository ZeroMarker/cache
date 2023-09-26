function b_BuildPatInfoObj(sPatInfo){
	if (sPatInfo!=""){
		var objPatient=new clsPatient("");
		var strFields=sPatInfo.split(CHR_2)
		objPatient.PatientNo=strFields[22];
		objPatient.MedRecNo=strFields[19];
		objPatient.PatientName=strFields[0];
		objPatient.Sex=strFields[1];
		objPatient.Identity=strFields[4];
		objPatient.Birthday=strFields[2];
		objPatient.Age=strFields[3];
		objPatient.NowAddress=strFields[17];
		objPatient.Telephone=strFields[8];
		objPatient.RelativeName=strFields[13];
		objPatient.Company=strFields[10];
		objPatient.Nationality=strFields[18];
		objPatient.Nation=strFields[7];
		objPatient.Marriage=strFields[6];
		objPatient.Education=strFields[9];
		objPatient.NativePlace=strFields[5];
		objPatient.Relation=strFields[11];
		objPatient.RelativeAddress=strFields[12];
		objPatient.Occupation=strFields[15];
		objPatient.Payment=strFields[20];
		objPatient.Rowid=strFields[21];
		return objPatient;
		}
	}

function b_BuildEpidemicReport(sEpdInfo){
	if (sEpdInfo!=""){
		var objEpidemicReport=new clsEpidemicReport("");
		var strFields=sEpdInfo.split(CHR_Up)
		var TempPlist
		objEpidemicReport.Rowid=strFields[0];                            ///
		objEpidemicReport.PatientRowID=strFields[1];                        ///
		
		objEpidemicReport.Area=b_BuildDicObj(strFields[2]);                 ///
		
		objEpidemicReport.Occupation=b_BuildDicObj(strFields[3]);           ///
		
		objEpidemicReport.FamName=strFields[4];                             ///
		//objEpidemicReport.ICD=b_BuildICD(strFields[5]);                 /// 
				
		objEpidemicReport.Intimate=b_BuildDicObj(strFields[6]);             ///
		
		objEpidemicReport.DiagnoseType=b_BuildDicObj(strFields[7]);         ///
		
		objEpidemicReport.SickDate=strFields[8];               ///
		
		objEpidemicReport.DiagDegree=b_BuildDicObj(strFields[9]);           ///
		
		objEpidemicReport.DiagnoseDate=strFields[10];        ///
		
		objEpidemicReport.SickKind=b_BuildDicObj(strFields[11]);             ///
		
		objEpidemicReport.DeathDate=strFields[12];           ///
				
		objEpidemicReport.ReportLocation=b_BuildDicObj(strFields[13]);       ///		
		objEpidemicReport.ReportLocation.Rowid=objEpidemicReport.ReportLocation.Code;
		
		objEpidemicReport.ReportPlace=b_BuildDicObj(strFields[14]);          ///
		
		objEpidemicReport.Status=b_BuildDicObj(strFields[15]);               ///
				
		objEpidemicReport.ReportUser=b_BuildDicObjWithId(strFields[16]);           ///
		objEpidemicReport.ReportDate=strFields[17];        ///
		objEpidemicReport.ReportTime=strFields[18];        ///
		objEpidemicReport.CheckUser1=b_BuildDicObjWithId(strFields[19]);           ///
		objEpidemicReport.CheckDate1=strFields[20];           ///
		objEpidemicReport.CheckTime1=strFields[21];       ///
		objEpidemicReport.ResumeText=strFields[22];          ///
		objEpidemicReport.DeleteReason=strFields[23];        ///
		objEpidemicReport.CorrectedReportRowID=strFields[24];   ///
		//objEpidemicReport.AppendixItems=strFields[25];    new clsDictionary("");    ///
		objEpidemicReport.Telphone=strFields[25];         ///
		objEpidemicReport.Address=strFields[26];          ///
		objEpidemicReport.Company=strFields[27];         ///
		//add by zf 2008-11-08
		if (strFields.length>=30){
			objEpidemicReport.IDAddress=strFields[28];         ///
			objEpidemicReport.TEXT1=strFields[29];         ///
			objEpidemicReport.TEXT2=strFields[30];         ///
		}
		return objEpidemicReport;
		}
	}
	
function b_BuildDicObj(sDictionary){
	var objDictionary=new clsDictionary("");
	if (sDictionary!=""){
		var TempPlist=sDictionary.split(CHR_Tilted);
		objDictionary.Rowid="";
		objDictionary.Code=TempPlist[0];          
		objDictionary.Desc=TempPlist[1];         
		}
	return objDictionary;
	}
		
function b_BuildDicObjWithId(sDictionary){
	var objDictionary=new clsDictionary("");
	if (sDictionary!=""){
		var TempPlist=sDictionary.split(CHR_Tilted);
		objDictionary.Rowid=TempPlist[0];
		objDictionary.Code=TempPlist[1];          
		objDictionary.Desc=TempPlist[2];         
		}
	return objDictionary;
	}

function b_BuildICD(sICD){
	var objEpdICD=new clsEpdICD("");
	if (sICD!=""){
		var TempPlist=sICD.split(CHR_Up);		      
	    objEpdICD.Rowid=TempPlist[0];
	    objEpdICD.Code=TempPlist[1];
	    objEpdICD.Desc=TempPlist[2];
	    objEpdICD.Type=TempPlist[3];
	    objEpdICD.Rank=TempPlist[4];
	    objEpdICD.Appendix=TempPlist[5];
	    objEpdICD.Multi=TempPlist[6];
	    objEpdICD.Dependence=TempPlist[7];
	    objEpdICD.TimeLimit=TempPlist[8];
		}
	return objEpdICD;
	}