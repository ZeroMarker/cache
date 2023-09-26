Include webimport

IncludeGenerator webimport

Class web.MRDiagnos Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1113;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MRDIA_DocCode_DR";

Parameter SQLDESCRIPTION = "MRDIA_RowId";

Parameter SQLROWID = "MRDIA_RowId";

Property dummy As %String(TRUNCATE = 1);

/// cjb 09/11/2004 47384 - passing through compref, so it can get passed to websysAfterSave
ClassMethod AddICD(mradm As %Library.String = "", id As %Library.String = "", icd As %Library.String = "", linkedid As %Library.String = "", userid As %Library.String = "", DRGOrder As %Library.String = "", prefix As %Library.String = "", contractflag As %Library.String = "", compref As %Library.String = "", createduserid As %Library.String = "", AccidentDate As %Library.String = "", AliasText As %Library.String = "") As %Library.String
{
}

/// Log 46427 - AI - 27-10-2004 : Method to return whether the current logged-on user can delete a given Diagnosis.
///   Called from MRDiagnos.Edit component - CanUserDelete item.
/// by wuqk 2011-06-02
/// 和人员级别或者诊断被指定有关吗?
ClassMethod CanUserDeleteDiagnosis(DiagID As %Library.String) As %Library.Boolean
{
	quit ""
}

/// rqg,Log27337: This method validates the ICD code requirement details before saving. 
/// This is called from PAAdmCoding.websysBeforeSave .
ClassMethod CheckICDCodeRequirement(compref As %Library.String) As %Library.Boolean
{
}

/// SA 5.7.02: Method implemented for log 24580/24627
/// This method is called from web.PAAdmCoding.CopyDiagProcsAcrossEpisodes
ClassMethod CopyDiagsAcrossEpisodes(compref As %Library.String, mradmFrom As %Library.String = "", mradmsTo As %Library.String = "")
{
}

ClassMethod FindDRGClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindDRGFetch ]
{
}

ClassMethod FindDRGExecute(ByRef QHandle As %Library.Binary, mradm As %Library.String = "", paadmtransid As %Library.String = "", minrows As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod FindDRGFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindDRGExecute ]
{
}

ClassMethod GetFirstDescription(EpisodeID As %Library.String) As %Library.String
{
}

/// Log 24836 HP:
/// by wuqk 2011-06-02
ClassMethod GetFirstRecRowID(mradm As %Library.String) As %Library.String
{
	;^MR({MR_Adm.MRADM_RowId},"DIA",{MRDIA_Childsub})
	quit:'$d(^MR(mradm,"DIA")) ""
	quit mradm_"||"_$o(^MR(mradm,"DIA",""))
}

ClassMethod GetFirstRecord(mradm As %Library.String)
{
}

ClassMethod GetPrimaryDiag(mradm As %Library.String)
{
}

/// ab 5.08.03 37124 - returns all diagnosis without unacceptable flag against icd code
/// used on PAAdm.Tree
ClassMethod GetPrimaryDiagnosis(mradm As %String = "") As %String
{
}

/// Logs 43861/38654 - AI - 17-05-2004 : Get the HRG Description.
ClassMethod GetHRGDescription(mradm As %String = "") As %String
{
	Q ""
}

ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
	;写mrc_diagnosetype
	s MRDiagnosDr=""
	i $d(%request.Data("MRDiagType",1)) d
	.s val = $g(%request.Data("MRDiagType",1))
	.s val=##Class(web.MRCDiagnosType).GetIdFromCodeOrDescription($g(val))
	.s MRDiagnosDr = val
	&sql(select Typ_childsub into :typchildsub from  SQLUser.MR_DiagType where typ_parref=:id)
	
	i typchildsub="",MRDiagnosDr'="" d
	.;s typeobj = ##class(User.MRDiagType).%New(id)
	.S PLIST(0) = id
	.s PLIST(3) = MRDiagnosDr
	.&sql(insert into SQLUser.MR_DiagType values :PLIST())
	e  d
	.i MRDiagnosDr'="" d
	..s typeobj = ##class(User.MRDiagType).%OpenId(id_"||"_typchildsub)
	..i $IsObject(typeobj) d
	...d typeobj.TYPMRCDiagTypSetObjectId(MRDiagnosDr)
	...d typeobj.%Save() 

	q $$$OK
}

/// Invoked before websysSave - can be used to cancel the save.
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysSaveDRG(compref As %Library.String = "", id As %Library.String = "", idtrans As %Library.String = "")
{
}

/// Log 47524 - AI - 29-11-2004 : Method to save the Tumour details - not the regular websysSave.
///                               Called by Update item on component MRDiagnosTumour.Edit.
ClassMethod websysSaveDiagnosTumour(compref As %String, id As %Library.String = "")
{
}

ClassMethod websysSave(compref As %String, id As %String)
{
 n compid,status,new,j,oktosave,save,value,parref,oldval
 s $zt = "ERROR"
 s compid=291,oktosave=1,save=0
 i id'="",'##Class(websys.Lock).Lock($lb(id,"User.MRDiagnos"),%session.SessionId,%session.Get("LOGON.USERID"),.status) d  q 0
 . d msg.AddItem("E","LOCKED",status,compid) s oktosave=0
 i '##Class(web.MRDiagnos).websysBeforeSave(compref,.id) q 0
 s new=id=""
 s:id'="" obj=##Class(User.MRDiagnos).%OpenId(id)
 if id="" d
 . s parref=$g(%request.Data("PARREF",1))
 . i parref="" s obj=##Class(User.MRDiagnos).%New()
 . i parref'="" s obj=##Class(User.MRDiagnos).%New(parref)
 i $d(%request.Data("MRDIAICDCodeDR",1)) d
 . s (val,oldval)=$g(%request.Data("MRDIAICDCodeDR",1)) s:$l($g(val)) val=##Class(web.MRCICDDx).GetIdFromCodeOrDescription($g(val)) d obj.MRDIAICDCodeDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("MRDIAICDCodeDR"),"诊断"),oldval_" "_$g(t("XINVALID")," is invalid"),291,"MRDIAICDCodeDR") s oktosave=0
 i $d(%request.Data("PARREF",1)) d
 . s (val,oldval)=$g(%request.Data("PARREF",1)) i %request.Get("PARREF")'="" d obj.MRDIAMRADMParRefSetObjectId(%request.Get("PARREF"))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PARREF"),""),oldval_" "_$g(t("XINVALID")," is invalid"),291,"PARREF") s oktosave=0
 i $d(%request.Data("MRDIASignSymDR",1)) d
 . s (val,oldval)=$g(%request.Data("MRDIASignSymDR",1)) s:$l($g(val)) val=##Class(web.MRCDiagnosSignSymptom).GetIdFromCodeOrDescription($g(val)) d obj.MRDIASignSymDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("MRDIASignSymDR"),"症状"),oldval_" "_$g(t("XINVALID")," is invalid"),291,"MRDIASignSymDR") s oktosave=0
 i $d(%request.Data("UpdateUser",1)) d
 . s (val,oldval)=$g(%request.Data("UpdateUser",1)) d obj.MRDIAUpdateUserDRSetObjectId(%session.Get("LOGON.USERID"))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("UpdateUser"),"UpdateUser"),oldval_" "_$g(t("XINVALID")," is invalid"),291,"UpdateUser") s oktosave=0
 i $d(%request.Data("MRDIADesc",1)) d
 . s (val,oldval)=$g(%request.Data("MRDIADesc",1)) d ##Class(websys.Conversions).LongTextHtmlToLogical(obj.MRDIADesc,$g(val),$C(13,10))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("MRDIADesc"),"注释"),oldval_" "_$g(t("XINVALID")," is invalid"),291,"MRDIADesc") s oktosave=0
 i $d(%request.Data("MRDIADiagStatDR",1)) d
 . s (val,oldval)=$g(%request.Data("MRDIADiagStatDR",1)) s:$l($g(val)) val=##Class(web.MRCDiagnosStatus).GetIdFromCodeOrDescription($g(val)) d obj.MRDIADiagStatDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("MRDIADiagStatDR"),"诊断状态"),oldval_" "_$g(t("XINVALID")," is invalid"),291,"MRDIADiagStatDR") s oktosave=0
 i $d(%request.Data("MRDIADocCodeDR",1)) d
 . s (val,oldval)=$g(%request.Data("MRDIADocCodeDR",1)) d:$l($g(val)) obj.MRDIADocCodeDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("MRDIADocCodeDR"),"Care Provider Name"),oldval_" "_$g(t("XINVALID")," is invalid"),291,"MRDIADocCodeDR") s oktosave=0
 i $d(%request.Data("MRDiagType",1)) d
 . s (val,oldval)=$g(%request.Data("MRDiagType",1)) s:$l($g(val)) val=##Class(web.MRCDiagnosType).GetIdFromCodeOrDescription($g(val)) 
 . i id="" d
 . . s typeobj=##class(User.MRDiagType).%New() 
 . i oldval'="",val="" d msg.AddItem("E",$g(t("MRDiagType"),"诊断类型"),oldval_" "_$g(t("XINVALID")," is invalid"),291,"MRDiagType") s oktosave=0
 i $d(%request.Data("MRDIAICDCodeDRDescOnly",1)) d
 . s (val,oldval)=$g(%request.Data("MRDIAICDCodeDRDescOnly",1)) i '$d(%request.Data("MRDIAICDCodeDR")) s val=##Class(web.MRCICDDx).GetIdFromCodeOrDescription($g(val)) d obj.MRDIAICDCodeDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("MRDIAICDCodeDRDescOnly"),"诊断描述"),oldval_" "_$g(t("XINVALID")," is invalid"),291,"MRDIAICDCodeDRDescOnly") s oktosave=0
 i $d(%request.Data("MRDIAICDCodeID",1)) d
 . s (val,oldval)=$g(%request.Data("MRDIAICDCodeID",1)) i '$d(%request.Data("MRDIAICDCodeDR")),'$d(%request.Data("MRDIAICDCodeDRDescOnly")),$d(%request.Data("MRDIAICDCodeDRAltDescAlias")) s val=$g(%request.Data("MRDIAICDCodeID",1)) d obj.MRDIAICDCodeDRSetObjectId(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("MRDIAICDCodeID"),""),oldval_" "_$g(t("XINVALID")," is invalid"),291,"MRDIAICDCodeID") s oktosave=0
 i $d(%request.Data("UpdateDate",1)) d
 . s (val,oldval)=$g(%request.Data("UpdateDate",1)) s obj.MRDIAUpdateDate=+$h
 . i oldval'="",val="" d msg.AddItem("E",$g(t("UpdateDate"),"UpdateDate"),oldval_" "_$g(t("XINVALID")," is invalid"),291,"UpdateDate") s oktosave=0
 i $d(%request.Data("UpdateTime",1)) d
 . s (val,oldval)=$g(%request.Data("UpdateTime",1)) s val=+$p($h,",",2)  s obj.MRDIAUpdateTime=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("UpdateTime"),"UpdateTime"),oldval_" "_$g(t("XINVALID")," is invalid"),291,"UpdateTime") s oktosave=0
 i $d(%request.Data("UpdateHospital",1)) d
 . s (val,oldval)=$g(%request.Data("UpdateHospital",1)) d obj.MRDIAUpdateHospitalDRSetObjectId(##Class(web.CTLoc).GetHospital(%session.Get("LOGON.CTLOCID")))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("UpdateHospital"),"UpdateHospital"),oldval_" "_$g(t("XINVALID")," is invalid"),291,"UpdateHospital") s oktosave=0
 i $d(%request.Data("UserCreated",1)) d
 . s (val,oldval)=$g(%request.Data("UserCreated",1)) i %request.Get("ID")="" d obj.MRDIAUserCreatedDRSetObjectId(%session.Get("LOGON.USERID"))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("UserCreated"),"UserCreated"),oldval_" "_$g(t("XINVALID")," is invalid"),291,"UserCreated") s oktosave=0
 i $d(%request.Data("MRDIADeletionReasonDR",1)) d
 . s (val,oldval)=$g(%request.Data("MRDIADeletionReasonDR",1)) s:$l($g(val)) val=##Class(web.PACReasonForChangePatData).GetIdFromCodeOrDescription($g(val)) d obj.MRDIADeletionReasonDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("MRDIADeletionReasonDR"),"诊断删除原因"),oldval_" "_$g(t("XINVALID")," is invalid"),291,"MRDIADeletionReasonDR") s oktosave=0
 i $d(%request.Data("GRP1Desc",1)) d
 . s (val,oldval)=$g(%request.Data("GRP1Desc",1)) s:$l($g(val)) val=##Class(web.MRCDiagnosisGroup1).GetIdFromCodeOrDescription($g(val)) d obj.MRDIADiagnosisGroup1DRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("GRP1Desc"),"诊断组"),oldval_" "_$g(t("XINVALID")," is invalid"),291,"GRP1Desc") s oktosave=0
 d
 . s (val,oldval)=$g(%request.Data("MRDIADSReportFlag",1)) s obj.MRDIADSReportFlag=##Class(websys.Conversions).YesNoHtmlToLogical($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("MRDIADSReportFlag"),"DS Report Flag"),oldval_" "_$g(t("XINVALID")," is invalid"),291,"MRDIADSReportFlag") s oktosave=0
 i $d(%request.Data("MRDIADateDiagnosisIdentif",1)) d
 . s (val,oldval)=$g(%request.Data("MRDIADateDiagnosisIdentif",1)) s obj.MRDIADateDiagnosisIdentif=##Class(websys.Conversions).DateHtmlToLogical($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("MRDIADateDiagnosisIdentif"),"诊断定义日期"),oldval_" "_$g(t("XINVALID")," is invalid"),291,"MRDIADateDiagnosisIdentif") s oktosave=0
 i $d(%request.Data("MRDIARiskEvaluationDR",1)) d
 . s (val,oldval)=$g(%request.Data("MRDIARiskEvaluationDR",1)) s:$l($g(val)) val=##Class(web.MRCRiskEvalParam).GetIdFromCodeOrDescription($g(val)) d obj.MRDIARiskEvaluationDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("MRDIARiskEvaluationDR"),"风险评估"),oldval_" "_$g(t("XINVALID")," is invalid"),291,"MRDIARiskEvaluationDR") s oktosave=0
 d
 . s (val,oldval)=$g(%request.Data("MRDIAActive",1)) s obj.MRDIAActive=$s(##Class(%Collation).Upper($g(val))="ON":"N",1:"Y")
 . i oldval'="",val="" d msg.AddItem("E",$g(t("MRDIAActive"),"未激活"),oldval_" "_$g(t("XINVALID")," is invalid"),291,"MRDIAActive") s oktosave=0
 i 'oktosave,'$g(msg.Count("E")),$g(%request.Data("TOVERRIDE",1)) s oktosave=1
 i oktosave d
 . s save=obj.%Save(0)
 . i $d(msg) d msg.Status(save,291)
 s:save id=obj.%Id()
 d obj.%Close()  s obj=""
 s idnew=id
 d:save ##Class(web.MRDiagnos).websysAfterSave(compref,id,new)
 i 'new d ##Class(websys.Lock).LockClear($lb(id,"User.MRDiagnos"),%session.SessionId)
 q save
ERROR 
	s ^Temp("Upgrade","web.MRDiagnos","websyssave")=$ze
	q "error"
}

/// Default save method used for updating the database for Components of type Edit.
/// 
/// The compref is the  component reference which is the string from which we can deduce the instance of
/// websysComponent
/// websysComponentItem
/// id is the id for the instance of class we wish to update.
ClassMethod websysSaveSnomed(compref As %String, id As %String)
{
}

ClassMethod DUPEwebsysSaveSnomed(compref As %String, id As %String)
{
}

ClassMethod ListSnomedExecute(ByRef QHandle As %Library.Binary, mradm As %Library.String = "", ConsultID As %Library.String = "") As %Library.Status
{
}

ClassMethod ListSnomedFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListSnomedExecute ]
{
}

ClassMethod ListSnomedClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListSnomedFetch ]
{
}

/// wqr 2011.10.22
/// do ##class(%ResultSet).RunQuery("web.MRDiagnos","ListEPRNew","77128","","","","")
Query ListEPRNew(mradm, PAAdmTransactionID, GrpSetCarPrv, DischEpisodes, CurrFlag) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,MRCIDCode,MRCIDDesc,DSYMDesc,DSTATDesc,MRDIADate,MRDIATime,MRDIADesc,MRDIAMRADMParRef,IcdID,DaggerAster,AltDesc,UpdateDate,UpdateTime,UpdateUserName,UpdateHospitalDesc,HRGDesc,ApptIds,EpisodeID,UserCreatedName,DeletionReasonDesc,MRDIADSReportFlag,MRDIADateDiagnosisIdentif,MRDIARiskEvaluationDR,MRDIADiagnosisGroup1DR,MRDIABodySite,MRDIALaterality,MRDIASeverity,MRDIADuration,HIDDEN,MRDIAActive,MRDIAOnsetDate,MRDIAOnsetTime,MRDIAEndDate,MRDIAEndTime,Duration,LinkedOrders,SnoMRDIADesc,Qualifiers,MRDIATimeDiagnosisIdentif,MRDIAApprox")
{
}

ClassMethod ListEPRNewExecute(ByRef QHandle As %Library.Binary, mradm As %Library.String = "", PAAdmTransactionID As %Library.String = "", GrpSetCarPrv As %Library.String = "", DischEpisodes As %String = "", CurrFlag As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	Set QHandle=$lb(0,repid,0)
	Set ind=1
	
	if mradm="" Quit $$$OK
	set EpisodeID=$p($g(^MR(mradm,"PRO",1)),"^",9)
	set Childsub = $o(^MR(mradm,"DIA",0))
	while (Childsub '= "")
	{
		set item = ^MR(mradm,"DIA",Childsub)
		
		//MRDIAUpdateUserDR
		set MRDIAUpdateUserDR = $p(item,"^",12)
		
		//2
		set SSUSRCareProvDR = $p(^SSU("SSUSR",MRDIAUpdateUserDR),"^",14)
		set CTPCPCarPrvTpDR = $p(^CTPCP(SSUSRCareProvDR,1),"^",4)
		if ((GrpSetCarPrv [ ","_CTPCPCarPrvTpDR_",") || (GrpSetCarPrv = ""))
		{
		}
		else
		{
			set Childsub = $o(^MR(mradm,"DIA",Childsub))
			continue
		}
		
		//3
		set SSUSRLastPAADMDR = $p(^SSU("SSUSR",MRDIAUpdateUserDR),"^",18)
		if ((PAAdmTransactionID = SSUSRLastPAADMDR) || (PAAdmTransactionID = ""))
		{
		}
		else
		{
			set Childsub = $o(^MR(mradm,"DIA",Childsub))
			continue
		}
		
		set UpdateUserName = $p(^SSU("SSUSR",MRDIAUpdateUserDR),"^",2)
		//MRDIAICDCodeDR
		set MRDIAICDCodeDR = $p(item,"^",1)
		set IcdID = MRDIAICDCodeDR
		s MRCIDCode="",MRCIDDesc=""
		if MRDIAICDCodeDR'="" {
			set MRCIDCode = $p(^MRC("ID",MRDIAICDCodeDR),"^",1)
			set MRCIDDesc = $p(^MRC("ID",MRDIAICDCodeDR),"^",2)
		}
		;set CTCareInfo = ^CTPCP(MRDIADocCodeDR)
		//MRDIADocCodeDR:
		set MRDIADocCodeDR = $p(item,"^",4)
		
		set MRDIADate =  $p(item,"^",7)
		set MRDIATime =  $p(item,"^",8)
		
		set MRCDiagnosStatus = $p(item,"^",9)
		if ((MRCDiagnosStatus = "") || ($g(^MRC("DSTAT",MRCDiagnosStatus)) = ""))
		{
			set DSTATDesc = ""
		}
		else
		{
			set DSTATDesc = $p(^MRC("DSTAT",MRCDiagnosStatus),"^",2)
		}
		
		set MRDIASignSymDR = $p(item,"^",10)
		if (($g(MRDIASignSymDR) = "") || ($g(^MRC("DSYM",MRDIASignSymDR)) = ""))
		{
			set DSYMDesc = ""
		}
		else
		{
			set DSYMDesc = $p(^MRC("DSYM",MRDIASignSymDR),"^",2)
		}
		
		set MRDIADiagnosisGroup1DR = $p(item,"^",13)
		
		set MRDIAUpdateHospitalDR = $p(item,"^",18)
		if (($g(MRDIAUpdateHospitalDR) = "") || ($g(^CT("HOSP",MRDIAUpdateHospitalDR)) = ""))
		{
			set UpdateHospitalDesc = ""
		}
		else
		{
			set UpdateHospitalDesc = $p(^CT("HOSP",MRDIAUpdateHospitalDR),"^",2)
		}
		
		set UpdateDate = $p(item,"^",19)
		set UpdateTime = $p(item,"^",20)
		
		set MRDIADeletionReasonDR = $p(item,"^",21)
		if (($g(MRDIADeletionReasonDR) = "") || ($g(^PAC("RCH",MRDIADeletionReasonDR)) = ""))
		{
			set RCHDesc = ""
		}
		else
		{
			set RCHDesc = ^PAC("RCH",MRDIADeletionReasonDR)
		}
		set MRDIADSReportFlag = $p(item,"^",25)
		set MRDIARiskEvaluationDR = $p(item,"^",26)
		set MRDIADateDiagnosisIdentif = $p(item,"^",27)
		set MRDIABodySite = $p(item,"^",29)
		set MRDIALaterality = $p(item,"^",30)
		set MRDIASeverity = $p(item,"^",31)
		if (($p(item,"^",32) = "") && ($p(item,"^",33) = ""))
		{
			set MRDIADuration = ""
		}
		else
		{
			set MRDIADuration = $p(item,"^",32)_"||"_$p(item,"^",33)
		}
		set MRDIAActive = $p(item,"^",34)
		set MRDIAOnsetDate = $p(item,"^",35)
		set MRDIAOnsetTime = $p(item,"^",36)
		set MRDIAEndDate = $p(item,"^",37)
		set MRDIAEndTime = $p(item,"^",38)
		set MRDIATimeDiagnosisIdentif = $p(item,"^",39)
		set MRDIAApproximate = $p(item,"^",40)
		
		set MRDIADesc=""
		set ChildDescSub = $o(^MR(mradm,"DIA",Childsub,"DES",0))
		if ChildDescSub '= ""
		{
			set MRDIADesc = ^MR(mradm,"DIA",Childsub,"DES",ChildDescSub)
		}
		
		set MRDIADaggerAster = $p($g(^MR(mradm,"DIA",Childsub,1)),"^",11)
		set UserCreatedName = $p($g(^MR(mradm,"DIA",Childsub,1)),"^",18)
		
		set ID = mradm_"||"_Childsub
		;set MRCIDCode = ""
		;set MRCIDDesc = ""
		;set DSYMDesc = ""
		;set DSTATDesc = ""
		;set MRDIADate = ""
		;set MRDIATime = ""
		;set MRDIADesc = ""
		set MRDIAMRADMParRef = mradm
		;set IcdID = ""
		set DaggerAster = MRDIADaggerAster
		set AltDesc = ""
		;set UpdateDate = ""
		;set UpdateTime = ""
		;set UpdateUserName = ""
		;set UpdateHospitalDesc = ""
		set HRGDesc = ""
		set ApptIds = ""
		set EpisodeID = "" ;%request.Data("EpisodeID",1)
		;set UserCreatedName = ""
		set DeletionReasonDesc = RCHDesc
		;set MRDIADSReportFlag = ""
		;set MRDIADateDiagnosisIdentif = ""
		;set MRDIARiskEvaluationDR = ""
		;set MRDIADiagnosisGroup1DR = ""
		;set MRDIABodySite = ""
		;set MRDIALaterality = ""
		;set MRDIASeverity = ""
		;set MRDIADuration = ""
		set HIDDEN = ""
		;set MRDIAActive = ""
		;set MRDIAOnsetDate = ""
		;set MRDIAOnsetTime = ""
		;set MRDIAEndDate = ""
		;set MRDIAEndTime = ""
		set Duration = MRDIADuration
		set LinkedOrders = ""
		set SnoMRDIADesc = ""
		set Qualifiers = ""
		;set MRDIATimeDiagnosisIdentif = ""
		;set MRDIAApprox = ""
		
		set output = $lb(ID,MRCIDCode,MRCIDDesc,DSYMDesc,DSTATDesc,MRDIADate,MRDIATime,MRDIADesc,MRDIAMRADMParRef,IcdID,DaggerAster,AltDesc,UpdateDate,UpdateTime,UpdateUserName,UpdateHospitalDesc,HRGDesc,ApptIds,EpisodeID,UserCreatedName,DeletionReasonDesc,MRDIADSReportFlag,MRDIADateDiagnosisIdentif,MRDIARiskEvaluationDR,MRDIADiagnosisGroup1DR,MRDIABodySite,MRDIALaterality,	MRDIASeverity,MRDIADuration,HIDDEN,MRDIAActive,MRDIAOnsetDate,MRDIAOnsetTime,MRDIAEndDate,MRDIAEndTime,Duration,LinkedOrders,SnoMRDIADesc,Qualifiers,MRDIATimeDiagnosisIdentif,MRDIAApprox)
		;set ^tempWQRchk("web.MRDiagnos","ListEPRNewExecute",ID) = output
		set ^CacheTemp(repid,ind) = output
		set ind = ind + 1
		
		set Childsub = $o(^MR(mradm,"DIA",Childsub))
		set flag = 1
	}
	
	quit $$$OK
}

ClassMethod ListEPRNewFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status
{
	Set AtEnd=$LIST(QHandle,1)
	Set repid=$LIST(QHandle,2)
	Set ind=$LIST(QHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	set QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ListEPRNewClose(QHandle As %Library.Binary) As %Library.Status
{
	Set repid=$LIST(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRow(rowid, parent, code)
{
}

/// Log 63805 YC - For Deleting Snomed Diagnosis
ClassMethod websysDeleteSnomed(ID As %Library.String = "")
{
}

/// KM 27-Jun-2001: Called from component  MRDiagnos.ListEMR
Query Find(mradm As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,mradm,MRDIAICDCodeDR,MRDIAICDCodeDRDesc,MRDIAICDCodeDRCode,MRDIADate:%Date,MRDIATime:%Time,MRDIADesc:%List,MRDIAUpdateUserDRSSUSRName")
{
SELECT MRDIA_RowID, MRDIA_MRADM_ParRef, MRDIA_ICDCode_DR, MRDIA_ICDCode_DR->MRCID_Desc, MRDIA_ICDCode_DR->MRCID_Code, MRDIA_Date, MRDIA_Time, MRDIA_Desc, MRDIA_UpdateUser_DR->SSUSR_Name
FROM SQLUser.MR_Diagnos
WHERE MRDIA_MRADM_ParRef = :mradm
}

/// KM 27-Jun-2001: Called from component  MRDiagnos.ListEMR
Query FindDRG(mradm, paadmtransid, minrows) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,MRDIAICDCodeDR,MRDIAICDCodeDRDesc,MRDIAICDCodeDRCode,MRDIADRGOrder,MRDIAICDCodeDRExt1,MRDIAICDCodeDRExt2,MRDIAICDCodeDRExt3,MRDIAPrefix,CodeExt1,CodeExt2,CodeExt3,MappedICD,MRContractFlag,ValidContractFlag,MRCancer,AddCodeRqmt,MRCIDExternalCause,MRCIDMorphologyCode,MRCIDInjuryPoisoningCode,codeinpair,MRCIDUnacceptablePDx,MRCIDCodingPractices,MRCIDValidMCodeExt,MRCIDAllowToDuplicate,MRDIAUserCreatedDR,MRDIAAccidentDate,MRDIAAliasDiagText")
{
}

Query FindDefaultOrderSet(mradmid As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,DSYMARCOSDR")
{
SELECT MRDIA_RowId, MRDIA_SignSym_DR->DSYM_ARCOS_DR
FROM MR_Diagnos
WHERE (MRDIA_MRADM_ParRef = :mradmid)
}

Query FindTumor(mradm As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,STCLDesc,TUMDesc,LYMNDesc,DISMDesc,STGDesc,VENIDesc,LYMIDesc,MALGDesc,RESTUMDesc,TumourSize,TumourNotes")
{
SELECT MRDIA_Rowid,
 MRDIA_StageClas_DR->STCL_Desc,
 MRDIA_Tumour_DR->TUM_Desc,
 MRDIA_LymphNode_DR->LYMN_Desc, 
 MRDIA_DistalMet_DR->DISM_Desc,
 MRDIA_Stages_DR->STG_Desc, 
 MRDIA_VenInvasion_DR->VENI_Desc,
 MRDIA_LymphInvas_DR->LYMI_Desc, 
 MRDIA_MalGrade_DR->MALG_Desc, 
 MRDIA_ResTum_DR->RESTUM_Desc,
 MRDIA_TumourSize,
 MRDIA_TumourNotes
FROM SQLUser.MR_Diagnos
WHERE (MRDIA_MRADM_ParRef = :mradm)
AND (MRDIA_Tumour_DR IS NOT NULL)
}

/// KM 27-Jun-2001: Called from component  MRDiagnos.ListEMR
/// KK 09-Apr-2002 Log-23957: Added PAAdmTransactionID to the filer criteria
Query ListEPR(mradm As %Library.String, GrpSetCarPrv As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,MRCID_Code,MRCID_Desc,DSYM_Desc:%Library.String,DSTAT_Desc:%Library.String,MRDIA_Date:%Library.Date,MRDIA_Time:%Library.Time,MRDIA_Desc,SSUSR_Name,MRDIAMRADMParRef,IcdID,DaggerAster")
{
	SELECT DISTINCT MRDIA_RowID,
	MRDIA_ICDCode_DR->MRCID_Code,
	MRDIA_ICDCode_DR->MRCID_Desc, 
	MRDIA_SignSym_DR->DSYM_Desc, 
	MRDIA_DiagStat_DR->DSTAT_Desc, 
	MRDIA_Date, MRDIA_Time, MRDIA_Desc, 
	MRDIA_UpdateUser_DR->SSUSR_Name,
	MRDIA_MRADM_ParRef,
	MRDIA_ICDCode_DR->MRCID_Rowid,
	MRDIA_DaggerAster
	FROM SQLUser.MR_Diagnos,SQLUser.MR_DiagnosisAllocation
	WHERE (MRDIA_MRADM_ParRef = :mradm)
	AND ((:GrpSetCarPrv [ {fn CONCAT( ',', {fn CONCAT((%INTERNAL(MRDIA_UpdateUser_DR->SSUSR_CareProv_DR->CTPCP_CarPrvTp_DR)),',')})}) OR (:GrpSetCarPrv IS NULL))
	AND ((ALLOC_Transaction_DR=:PAAdmTransactionID) OR (:PAAdmTransactionID is NULL))
}

/// cjb 11/04/2005 51584 - moved here from PAAdmCoding
Query GetDiagnosisByMRAdm(mradm As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "MRDIARowId,MRCIDCode,MRDIADaggerAster,MRDIAFirstInset,MRCIDCodeDR")
{
SELECT MRDIA_RowId, MRDIA_ICDCode_DR->MRCID_Code, MRDIA_DaggerAster, MRDIA_FirstInset, MRDIA_ICDCode_DR
FROM SQLUser.MR_Diagnos
WHERE (MRDIA_MRADM_ParRef = :mradm)
}

/// cjb 11/04/2005 51584 - moved here from PAAdmCoding
Query GetDiagnosisByTransaction(AdmTransID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "MRDIARowId,MRCIDCode,MRDIADaggerAster,MRDIAFirstInset")
{
SELECT MRDIA_RowId, MRDIA_ICDCode_DR->MRCID_Code, MRDIA_DaggerAster, MRDIA_FirstInset
FROM SQLUser.MR_Diagnos,SQLUser.MR_DiagnosisAllocation
WHERE (MRDIA_RowId = ALLOC_ParRef)
AND (ALLOC_Transaction_DR = :AdmTransID)
}

/// Aji 7/10/2003
/// cjb 12/04/2005 51584 - moved here from PAAdmCoding
Query GetDiagCode(mradm As %Library.String, diagcode As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,ICDID:%String")
{
 SELECT MRDIA_RowID, MRDIA_ICDCode_DR
 FROM SQLUser.MR_Diagnos
 WHERE MRDIA_MRADM_ParRef = :mradm
 AND MRDIA_ICDCode_DR = :diagcode
}

/// Log 55973 - PC - 05-12-2005 : Save the selected rows as either "Include in DS Report" or "Exclude From DS Report".
ClassMethod IncludeExcludeDSReport(action As %Library.String = "E", RowIDs As %Library.String = "")
{
}

ClassMethod DiagListbymradm(mradm As %Library.String = "", GrpId As %Library.String = "")
{
}

Query ListSnomed(mradm As %Library.String = "", ConsultID As %Library.String = "") As %Library.Query(ROWSPEC = "ID,Date,Time,UpdateUser,UpdateDate,UpdateTime,UpdateHosp,ICDDiagnosis,Duration,Comments,Qualifiers,Inactive,SNODiagnosis,DateDiagnosisIdentif,TimeDiagnosisIdentif,OnsetDate,OnsetTime,EndDate,EndTime,Approx,mradm")
{
}

}
