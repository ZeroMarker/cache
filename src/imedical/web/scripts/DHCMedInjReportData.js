
function UpdateCheckInj(encmeth,Rowid,Status,CheckUsr,CheckDate,CheckTime,ResumeText){
	if (encmeth!=""){
		var ret=cspRunServerMethod(encmeth,Rowid,Status,CheckUsr,CheckDate,CheckTime,ResumeText);
		return ret;
		}	
	}
	
function GetInjDtlByRowid(encmeth,InjRowid){
	if (encmeth!=""){
		var ret=cspRunServerMethod(encmeth,InjRowid);
		if (ret!=""){	
			var TempList=ret.split(CHR_1);
			var k=0;
			while(k<TempList.length){
				var DtlValStr=TempList[k];
				var DtlVals=DtlValStr.split(CHR_Up);
				var DictCode=DtlVals[0];
				var DictVal=DtlVals[1];
				var OtherVal=DtlVals[2];
				var ResumeText=DtlVals[3];
				//更简单的用gSetListIndexByVal(DictCode,DictVal);
				switch (DictCode) {
                	case "InjHuJi" :
                	   gSetListIndexByVal("InjHuJi",DictVal);
                       break;
                    case "InjEducation" :
                       gSetListIndexByVal("InjEducation",DictVal);
                       break;
                     case "InjCareer" :
                       gSetListIndexByVal("InjCareer",DictVal);
                       break;
                     case "InjReason" :
                       if(OtherVal!="")
                       {
                       	 gSetListIndexByTxt("InjReason",t['Other']);
                       	 InjReason_change();
                       	 gSetObjValue("InjReasonOther",OtherVal);
                       }
                       else
                         gSetListIndexByVal("InjReason",DictVal);
                       break;
                     case "InjSite" :
                       if(OtherVal!="")
                       {
                       	 gSetListIndexByTxt("InjSite",t['Other']);
                       	 InjSite_change();
                       	 gSetObjValue("InjSiteOther",OtherVal);
                       }
                       else
                         gSetListIndexByVal("InjSite",DictVal);
                       break;
                     case "InjActivity" :
                       if(OtherVal!="")
                       {
                       	 gSetListIndexByTxt("InjActivity",t['Other']);
                       	 InjActivity_change();
                       	 gSetObjValue("InjActivityOther",OtherVal);
                       }
                       else
                         gSetListIndexByVal("InjActivity",DictVal);
                       break;
                     case "InjIntentional" :
                	   gSetListIndexByVal("InjIntentional",DictVal);
                       break;
                     case "InjKind" :
                       if(OtherVal!="")
                       {
                       	 gSetListIndexByTxt("InjKind",t['Other']);
                       	 InjKind_change();
                       	 gSetObjValue("InjKindOther",OtherVal);
                       }
                       else
                         gSetListIndexByVal("InjKind",DictVal);
                       break;
                     case "InjPosition" :
                       if(OtherVal!="")
                       {
                       	 gSetListIndexByTxt("InjPosition",t['Other']);
                       	 InjPosition_change();
                       	 gSetObjValue("InjPositionOther",OtherVal);
                       }
                       else
                         gSetListIndexByVal("InjPosition",DictVal);
                       break;
                     case "InjDegree" :
                	   gSetListIndexByVal("InjDegree",DictVal);
                       break;
                     case "InjResult" :
                       if(OtherVal!="")
                       {
                       	 gSetListIndexByTxt("InjResult",t['Other']);
                       	 InjResult_change();
                       	 gSetObjValue("InjResultOther",OtherVal);
                       }
                       else
                         gSetListIndexByVal("InjResult",DictVal);
                       break;
                  } 
                  k++;
			  }
			}	
		}	
	}
function gSetListIndexByTxt(objname,Txt){
	var obj=document.getElementById(objname);
	if (obj){
		for (i=0;i<obj.options.length;i++){
			if (Txt==obj.options[i].text){
				obj.options[i].selected=true;
				return;
				}
			}
		}
	}	
function GetInjInfoByRowid(encmeth,InjRowid){
	if (encmeth!=""){
		var ret=cspRunServerMethod(encmeth,InjRowid,gGetObjValue("Papmi"));
		if (ret!=""){	
			var TempList=ret.split(CHR_1);
			var sInjInfo=TempList[0];
			var sPatInfo=TempList[1];
			var sICDInfo=TempList[2];
					
			objPatient=b_BuildPatInfoObj(sPatInfo);
			objInjuryReport=b_BuildInjuryReport(sInjInfo);
			objInjuryReport.Diagnose=b_BuildMRCDiagnose(sICDInfo);
			}	
		}	
	}

function b_BuildMRCDiagnose(sICD){
	var objICD=new clsEpdICD("");
	if (sICD!=""){
		var TempPlist=sICD.split(CHR_Tilted);		      
	    objICD.Rowid=TempPlist[0];
	    objICD.Code=TempPlist[1];
	    objICD.Desc=TempPlist[2];
		}
	return objICD;
	}
function b_BuildInjuryReport(sInjInfo){
	if (sInjInfo!=""){
		var objReport=new clsInjuryReport("");
		var strFields=sInjInfo.split(CHR_Up)
		var TempPlist
		objReport.Rowid=strFields[0];                            ///
		objReport.Pa_AdmRowID=strFields[1];                        ///
		objReport.CardNo=strFields[2];                 ///
		objReport.Status=b_BuildDicObj(strFields[3]);           ///
		objReport.InjDate=strFields[4];                             ///
		objReport.InjTime=strFields[5];             ///
		//objReport.Diagnose=b_BuildDicObj(strFields[6]);         ///
		objReport.RepUser=b_BuildDicObjWithId(strFields[7]);               ///
		objReport.ReportDate=strFields[8];                             ///
		objReport.ReportTime=strFields[9];
        objReport.CheckUser=b_BuildDicObjWithId(strFields[10]);               ///
		objReport.CheckDate=strFields[11];                             ///
		objReport.CheckTime=strFields[12];
		objReport.IsActive=strFields[13];             ///
		objReport.ResumeText=strFields[14];           ///
		return objReport;
		}
	}
		
function UpdateInj(encmeth,InjString,InjDtlString){
	if (encmeth!=""&&InjString!=""){
		var ret=cspRunServerMethod(encmeth,InjString,InjDtlString);
		return ret;
		}
	}

function BuildInjuryReportString(objTMPInjReport){
	with(objTMPInjReport){
		var InjuryReportString=
		Rowid+"^"+
		objPaAdm.Rowid+"^"+
		CardNo+"^"+
		Status.Code+"^"+
		InjDate+"^"+
		InjTime+"^"+
		Diagnose.Rowid+"^"+
		RepUser.Rowid+"^"+
		ReportDate+"^"+
		ReportTime+"^"+
		CheckUser.Rowid+"^"+
		CheckDate+"^"+
		CheckTime+"^"+
		IsActive+"^"+
		ResumeText                          //TEXT2
		}
	return InjuryReportString;
	}
	
function BuildInjuryReportDtlString(){
	var InjHuJiStr="InjHuJi"+"/"+      //字典类型
		gGetListCodes("InjHuJi")+"/"+  //字典值rowid
		""+"/"+                        //其他的值
		""                             //备注
	var InjEducationStr="InjEducation"+"/"+
		gGetListCodes("InjEducation")+"/"+
		""+"/"+
		""
	var InjCareerStr="InjCareer"+"/"+
		gGetListCodes("InjCareer")+"/"+
		""+"/"+
		""
	var InjReasonStr="InjReason"+"/"+
		gGetListCodes("InjReason")+"/"+
		cTrim(gGetObjValue("InjReasonOther"),0)+"/"+
		""
	var InjSiteStr="InjSite"+"/"+
		gGetListCodes("InjSite")+"/"+
		cTrim(gGetObjValue("InjSiteOther"),0)+"/"+
		""
	var InjActivityStr="InjActivity"+"/"+
		gGetListCodes("InjActivity")+"/"+
		cTrim(gGetObjValue("InjActivityOther"),0)+"/"+
		""		
	var InjIntentionalStr="InjIntentional"+"/"+
		gGetListCodes("InjIntentional")+"/"+
		""+"/"+
		""	
	var InjKindStr="InjKind"+"/"+
		gGetListCodes("InjKind")+"/"+
		cTrim(gGetObjValue("InjKindOther"),0)+"/"+
		""
	var InjPositionStr="InjPosition"+"/"+
		gGetListCodes("InjPosition")+"/"+
		cTrim(gGetObjValue("InjPositionOther"),0)+"/"+
		""
	var InjDegreeStr="InjDegree"+"/"+
		gGetListCodes("InjDegree")+"/"+
		""+"/"+
		""
	var InjResultStr="InjResult"+"/"+
		gGetListCodes("InjResult")+"/"+
		cTrim(gGetObjValue("InjResultOther"),0)+"/"+
		""
	var sptF="|"											
	var InjuryReportDtlString=InjHuJiStr+sptF+
		InjEducationStr+sptF+
		InjCareerStr+sptF+
		InjReasonStr+sptF+
		InjSiteStr+sptF+
		InjActivityStr+sptF+
		InjIntentionalStr+sptF+
		InjKindStr+sptF+
		InjPositionStr+sptF+
		InjDegreeStr+sptF+
		InjResultStr
	return InjuryReportDtlString;
	}
	
function BuildInjuryReport(){
	var objTMPInjReport=new clsInjuryReport("");
	with(objTMPInjReport){
		Rowid=gGetObjValue("MinjRowid");
	    Pa_AdmRowID=gGetObjValue("PaAdmID");
	    Status.Desc=gGetObjValue("Status");
	    Status.Code=gGetObjValue("StatusCode");
	    InjDate=gGetObjValue("InjDate");
	    InjTime=gGetObjValue("InjTime");
	    Diagnose.Desc=gGetObjValue("ICDDesc");
	    Diagnose.Rowid=gGetObjValue("ICDRowId");
	    Diagnose.Code=gGetObjValue("ICDCode");
	    Diagnose.Type=gGetObjValue("ICDInsDesc");
	    Diagnose.Rank=gGetObjValue("ICD9CM_Code");
	    RepUser.Rowid=gGetObjValue("ReportUserRowid");
	    RepUser.Desc=gGetObjValue("ReportUser");
	    ReportDate=gGetObjValue("ReportDate");
	    ReportTime=gGetObjValue("ReportTime");
	    CheckUser.Desc=gGetObjValue("CheckUser1");
	    CheckUser.Rowid=gGetObjValue("CheckUser1Rowid");
	    CheckDate=gFormatDateA(gGetObjValue("CheckDate1"));
	    CheckTime=gGetObjValue("CheckTime1");
	    IsActive="Y"
	    ResumeText=gGetObjValue("ResumeText");
	}
	return objTMPInjReport;
}

function BuildInjuryReportDtl(){
	var objInjHuJiDtl=new clsInjuryReportDtl("");
	return objInjHuJiDtl;
}
/**********************************************
/
***********************************************/
function gVisibleElement(eleName){
	var obj=document.getElementById(eleName);
    if (obj){obj.style.visibility="visible";}
    
	}
	
function CheckInjInfomation(){
	with(objInjuryReport){
		var obj=document.getElementById("InjReasonOther");
		if(obj.style.visibility!="hidden")
		{
				if (gGetObjValue("InjReasonOther")=="") { gSetFocus("InjReasonOther"); return false;}			
		}
		var obj=document.getElementById("InjSiteOther");
		if(obj.style.visibility!="hidden")
		{
				if (gGetObjValue("InjSiteOther")=="") { gSetFocus("InjSiteOther"); return false;}			
		}
		var obj=document.getElementById("InjActivityOther");
		if(obj.style.visibility!="hidden")
		{
				if (gGetObjValue("InjActivityOther")=="") { gSetFocus("InjActivityOther"); return false;}			
		}
		var obj=document.getElementById("InjKindOther");
		if(obj.style.visibility!="hidden")
		{
				if (gGetObjValue("InjKindOther")=="") { gSetFocus("InjKindOther"); return false;}			
		}
		var obj=document.getElementById("InjPositionOther");
		if(obj.style.visibility!="hidden")
		{
				if (gGetObjValue("InjPositionOther")=="") { gSetFocus("InjPositionOther"); return false;}			
		}
		var obj=document.getElementById("InjResultOther");
		if(obj.style.visibility!="hidden")
		{
				if (gGetObjValue("InjResultOther")=="") { gSetFocus("InjResultOther"); return false;}			
		}
		if (InjDate=="") { gSetFocus("InjDate"); return false;}
		if (InjTime=="") { gSetFocus("InjTime"); return false;}
		if (Diagnose.Desc=="") { gSetFocus("DiagnoseDesc"); return false;}	

		//if (ResumeText.length < 0) { gSetFocus("ResumeText"); return false;}
		}
		if (gGetObjValue("Identity")=="") { gSetFocus("Identity"); return false;}
	  return true;
	}