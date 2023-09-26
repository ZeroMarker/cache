function GetEpdInfoByRowid(encmeth,EpdRowid){
	if (encmeth!=""){
		var ret=cspRunServerMethod(encmeth,EpdRowid);
		if (ret!=""){	
			var TempList=ret.split(CHR_1);
			var sEpdInfo=TempList[0];
			var sPatInfo=TempList[1];
			var sICDInfo=TempList[2];
					
			objPatient=b_BuildPatInfoObj(sPatInfo);
			objEpidemicReport=b_BuildEpidemicReport(sEpdInfo);
			objEpidemicReport.ICD=b_BuildICD(sICDInfo);
			}	
		}	
	}
	
	
function BuildEpidemicReport(){
	var objTMPEpidemicReport=new clsEpidemicReport("");
	with(objTMPEpidemicReport){
		Rowid=gGetObjValue("MepdRowid");
	        Occupation.Desc=gGetObjValue("Occupation");
	        Occupation.Code=gGetObjValue("OccupationCode");
	        FamName=gGetObjValue("RelativeName");
	        Company=gGetObjValue("Company");
	        Telphone=gGetObjValue("Telephone");
	        Address=gGetObjValue("NowAddress");
	        Area.Desc=gGetObjValue("Area");
	        Area.Code=gGetObjValue("AreaCode");
	        ICD.Desc=gGetObjValue("ICD");
	        ICD.Rowid=gGetObjValue("ICDRowid");
	        ICD.Code=gGetObjValue("ICDCode");
	        ICD.Type=gGetObjValue("ICDType");
	        ICD.Rank=gGetObjValue("ICDRank");
	        ICD.Appendix=gGetObjValue("ICDAppendi");
	        ICD.Multi=gGetObjValue("ICDMulti");
	        ICD.Dependence=gGetObjValue("ICDDependence");
	        ICD.TimeLimit=gGetObjValue("ICDTimeLimit");
	        Intimate.Desc=gGetObjValue("Intimate");
	        Intimate.Code=gGetObjValue("IntimateCode");
	        SickDate=gFormatDateA(gGetObjValue("SickDate"));
	        SickKind.Desc=gGetObjValue("SickKind");
	        SickKind.Code=gGetObjValue("SickKindCode");
	        DiagnoseDate=gFormatDateA(gGetObjValue("DiagnoseDate"))+" "+gGetObjValue("DiagnoseTime");
	        DeathDate=gFormatDateA(gGetObjValue("DeathDate"));
	        ReportLocation.Desc=gGetObjValue("ReportLocation");
	        ReportLocation.Rowid=gGetObjValue("ctloc");
	        ReportPlace.Desc=gGetObjValue("ReportPlace");
	        ReportPlace.Code=gGetObjValue("ReportPlaceCode");
	        Status.Desc=gGetObjValue("Status");
	        Status.Code=gGetObjValue("StatusCode");
	        ReportUser.Desc=gGetObjValue("ReportUser");
	        ReportUser.Rowid=gGetObjValue("ReportUserRowid");
	        ReportDate=gFormatDateA(gGetObjValue("ReportDate"));
	        ReportTime=gGetObjValue("ReportTime");
	        CheckUser1.Desc=gGetObjValue("CheckUser1");
	        CheckUser1.Rowid=gGetObjValue("CheckUser1Rowid");
	        CheckDate1=gFormatDateA(gGetObjValue("CheckDate1"));
	        CheckTime1=gGetObjValue("CheckTime1");
	        DiagDegree.Desc=gGetObjValue("DiagDegree");
	        DiagDegree.Code=gGetObjValue("DiagDegreeCode");
	        ResumeText=gGetObjValue("ResumeText");
	        DeleteReason=gGetObjValue("DeleteReason");
	        CorrectedReportRowID=gGetObjValue("CorrectedReportRowID");
	        //add by zf 2008-11-08
	        IDAddress=gGetObjValue("IDAddress");
	        TEXT1=gGetObjValue("TEXT1");
	        TEXT2=gGetObjValue("TEXT2");
	}
	return objTMPEpidemicReport;
}

function BuildEpidemicReportString(objTMPEpidemicReport){
	with(objTMPEpidemicReport){
		var EpidemicReportString=
		Rowid+"^"+
		objPatient.Rowid+"^"+
		Area.Code+"^"+
		Occupation.Code+"^"+
		FamName+"^"+
		ICD.Rowid+"^"+
		Intimate.Code+"^"+
		ICD.Type+"^"+
		SickDate+"^"+
		DiagDegree.Code+"^"+
		DiagnoseDate+"^"+
		SickKind.Code+"^"+
		DeathDate+"^"+
		ReportLocation.Rowid+"^"+
		ReportPlace.Code+"^"+
		Status.Code+"^"+
		ReportUser.Rowid+"^"+
		ReportDate+"^"+
		ReportTime+"^"+
		CheckUser1.Rowid+"^"+
		CheckDate1+"^"+
		CheckTime1+"^"+
		ResumeText+"^"+
		DeleteReason+"^"+
		CorrectedReportRowID+"^"+
		Telphone+"^"+
		Address+"^"+
		Company+"^"+
		IDAddress+"^"+                 //IDAddress  add by zf 200-11-08
		TEXT1+"^"+                     //TEXT1
		TEXT2                          //TEXT2
		}
	return EpidemicReportString;
	}
function BuildPatient(objPatient){
	var objTempPatient=new clsPatient("");
	objTempPatient=objPatient;
	with(objTempPatient){
		Rowid=gGetObjValue("Papmi");                   ///Papmi
		Occupation=gGetObjValue("Occupation");                   ///Job
		PatientName=gGetObjValue("PatientName");                   ///Name
		Company=gGetObjValue("Company");                   ///Company
		RelativeName=gGetObjValue("RelativeName");                   ///RelativeName
		Telephone=gGetObjValue("Telephone");                   ///Tel
		NowAddress=gGetObjValue("NowAddress");                   ///Address
		Age=gGetObjValue("Age");                   ///Age
		Birthday=gFormatDateA(gGetObjValue("Birthday"));                   ///Birthday
		Identity=gGetObjValue("Identity");                   ///Identity
		Sex=gGetObjValue("Sex");                   ///Sex
		MedRecNo=gGetObjValue("MedRecNo");                   ///MrNo
		PatientNo=gGetObjValue("PatientNo");                   ///RegNo
		}
	return objTempPatient;
	}
function UpdateEPD(encmeth,EpdString){
	if (encmeth!=""&&EpdString!=""){
		var ret=cspRunServerMethod(encmeth,EpdString);
		return ret;
		}
	}

function UpdateCheckEPD(encmeth,MEPDRowid,Status,CheckUsr,CheckDate,CheckTime,Demo){
	//alert(MEPDRowid+"-"+Status+"-"+CheckUsr+"-"+CheckDate+"-"+CheckTime+"-"+Demo);
	if (encmeth!=""){
		var ret=cspRunServerMethod(encmeth,MEPDRowid,Status,CheckUsr,CheckDate,CheckTime,Demo);
		return ret;
		}	
	}

function UpdateIdentity(encmeth,sPapmi,sIdentity){
	if (encmeth!=""&&sPapmi!=""&&sIdentity!=""){
		var ret=cspRunServerMethod(encmeth,sPapmi,sIdentity);
		return ret;
		}	
	}
	
function CheckInfomation(){
	with(objEpidemicReport){
		//Modified by LiYang 2008-09-28 when child's age less than 14, parent's name is required.
		var tmpArry = objPatient.Age.split(t["08"]);
		if ((tmpArry[0] < 15) && (FamName == "")) {gSetFocus("RelativeName"); return false};
		//-----
		if (Area.Code=="") { gSetFocus("Area"); return false;}
		if (Occupation.Code=="") { gSetFocus("Occupation"); return false;}
		//if (FamName=="") {{ gSetFocus("RelativeName"); return false;}}
		if (ICD.Rowid=="") { gSetFocus("ICD"); return false;}
		if (Intimate.Code=="") { gSetFocus("Intimate"); return false;}
		if (SickDate=="") { gSetFocus("SickDate"); return false;}
		if (DiagDegree.Code=="") { gSetFocus("DiagDegree"); return false;}
		if (DiagnoseDate=="") { gSetFocus("DiagnoseDate"); return false;}
		if (SickKind.Code=="") { gSetFocus("SickKind"); return false;}
		if (ReportPlace.Code=="") { gSetFocus("ReportPlace"); return false;}
		//if (ResumeText.length < 15) { gSetFocus("ResumeText"); return false;} //Modified By LiYang 2008-09-15
		//Modify by wuqk 2008-10-01  //
		if (ResumeText.length < 0) { gSetFocus("ResumeText"); return false;}
		/*
		if (DeathDate=="") { gSetFocus(""); return false;}
		if (ReportLocation.Rowid=="") { gSetFocus(""); return false;}
		if (ReportPlace.Code=="") { gSetFocus(""); return false;}
		if (Status.Code=="") { gSetFocus(""); return false;}
		if (ReportUser.Rowid=="") { gSetFocus(""); return false;}
		if (ReportDate=="") { gSetFocus(""); return false;}
		if (ReportTime=="") { gSetFocus(""); return false;}
		if (CheckUser1.Rowid=="") { gSetFocus(""); return false;}
		if (CheckDate1=="") { gSetFocus(""); return false;}
		if (CheckTime1=="") { gSetFocus(""); return false;}
		if (ResumeText=="") { gSetFocus(""); return false;}
		if (DeleteReason=="") { gSetFocus(""); return false;}
		if (CorrectedReportRowID=="") { gSetFocus(""); return false;}
		*/
		if (Telphone=="") { gSetFocus("Telephone"); return false;}
		if (Address=="") { gSetFocus("NowAddress"); return false;}
		if (Company=="") { gSetFocus("Company"); return false;}
		if(FormatDateStringGs(gGetObjValue("DiagnoseDate"),gGetObjValue("SickDate"))){gSetFocus("SickDate");return false;}
		}
	with(objPatient){
		if (Identity=="") {gSetFocus("Identity"); return false;}
		}
	return true;
	}
	
function CheckAppendixCard(MepdRowid,editActive){
	var flag="0"
	//alert(MepdRowid+"/"+editActive);
	if (MepdRowid=="") return flag;
	
    var encmeth1=gGetObjValue("txtCheckSub");
    var encmeth2=gGetObjValue("txtGetAppCode");
	//alert(encmeth1);
    var ret=cspRunServerMethod(encmeth1,MepdRowid);
    //alert("sub="+ret);
	if (ret=="1"){
		flag=ret;
		return flag;
		}
    //var encmeth=gGetObjValue("txtGetAppCode");
	//alert(encmeth2);
    var GetAppCode=cspRunServerMethod(encmeth2,MepdRowid);
    //alert("GetAppCode="+GetAppCode);
    if ((GetAppCode>0)&&(editActive=="1")){
	    flag="1";
	    return flag;
	    }
    return flag;
	}
	
//format dade from "DD/MM/YYYY" to  "YYYY-MM-DD str=dia str1=sick
 function FormatDateStringGs(str,str1)
 {      var ret=false;
	 var objArryDate = str.split("/");
	 var objArryDate1= str1.split("/");
	 if(parseFloat(objArryDate[2])>parseFloat(objArryDate1[2]))
	 {
	 	
	 	}
	 else
	 {
	 	if(parseFloat(objArryDate[2])==parseFloat(objArryDate1[2]))
	 	{
	 		if(parseFloat(objArryDate[1])>parseFloat(objArryDate1[1]))
	 		{
	 	
	 	         }
	 	         else
	 	         {
	 	         	if(parseFloat(objArryDate[1])==parseFloat(objArryDate1[1]))
	 	                {
	 	                	
	 	                	if(parseFloat(objArryDate[0])>parseFloat(objArryDate1[0]))
			 		{
			 	           
			 	         }
			 	         else
			 	         {
			 	         	if(parseFloat(objArryDate[0])==parseFloat(objArryDate1[0]))
			 	                {
			 	                	
			 	                }
			 	                else
			 	                {
			 	                	ret=true;
			 	                	}
			 	         }
	 	                }
	 	                else
	 	                {
	 	                	ret=true;
	 	                	}
	 	         }
	 	}
	 	else
	 	{
	 	  	ret=true;
	 	}
	 }
	return ret;
 }
 