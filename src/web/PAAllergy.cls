Include webimport

IncludeGenerator webimport

Class web.PAAllergy Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 848;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ALG_RowID";

Parameter SQLDESCRIPTION = "ALG_Desc";

Parameter SQLROWID = "ALG_RowID";

Property dummy As %String(TRUNCATE = 1);

ClassMethod AllergiesClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = AllergiesFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// by zhouza 2011-07-28 查询过敏记录
/// d ##class(%ResultSet).RunQuery("web.PAAllergy","Allergies",215)
ClassMethod AllergiesExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String) As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	
	s objpat=##class(User.PAPatMas).%OpenId(PatientID)
	i $ISOBject(objpat){
		s count=objpat.ChildPAAllergy.Count()
		for i=1:1:count {
			s (RowID,Category,Allergen,NatureOfReaction,Severity,SeverityColour,OnsetDate,OnsetDateFreeText,
				CareProvider,InActive,OnsetDateText,RowHexColour,LastUpdateDate,LastUpdateTime,LastUpdateUser,
				LastUpdateHospital,Status,ExternalID,LastUpdateUserRole,LastUpdateUserId,Comments,ALGFreeTextAllergy,
				DrugSpecific,tag,ALGDSReportFlag,HiddenFields)=""
			
			s objAllergy=objpat.ChildPAAllergy.GetAt(i)
			s RowID=objAllergy.%Id()
			
			;自定义过敏源
			if objAllergy.ALGTypeDRGetObjectId()'="" {
				s Allergen=objAllergy.ALGTypeDR.ALGDesc
				;s tag=objAllergy.ALGTypeDR.ALGTypeDR.MRCATTagDescription ;--标准版 web.DHCPAAllergy.cls中有
				s tag=objAllergy.ALGMRCAllTypeDR.MRCATTagDescription
			}
			
			;通用项过敏源
			elseif  objAllergy.ALGPHCGEDRGetObjectId()'="" {
				s Allergen=objAllergy.ALGPHCGEDR.PHCGEName
				s tag="G"
				;s tag="Generic Drug"
			}
			
			;药学过敏源
			elseif objAllergy.ALGPHCDMDRGetObjectId()'="" {
				s Allergen=objAllergy.ALGPHCDMDR.PHCDName
				s tag="P"
				;s tag="Pharmacy Item"
			}
			
			elseif objAllergy.ALGIngredDRGetObjectId()'="" {
				s Allergen=objAllergy.ALGIngredDR.INGRDesc
				s tag="I"
				;s tag="Ingredient"
			}

			;分类
			s Category=objAllergy.ALGMRCAllTypeDR.MRCATDesc
 			i (tag="P")!(tag="G")!(tag="I") s tag=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",tag)
			
			;拮抗反应
			if objAllergy.ALGCategoryDRGetObjectId()'="" {
				s NatureOfReaction=objAllergy.ALGCategoryDR.ALRGCATDesc
			}
			
			;医嘱项ID
			if (objAllergy.ALGExternalID'="")&&(objAllergy.ALGExternalID["||") { 
			  s ALGItemID=objAllergy.ALGExternalID
			  s Allergen=$p($g(^ARCIM(+ALGItemID,$p(ALGItemID,"||",2),1)),"^",2)
			}
			;严重
			if objAllergy.ALGSeverityDRGetObjectId()'="" {
				s Severity=ALGSeverityDR.ALGSeverityDR.ALRGSEVDesc
			}
			
			s OnsetDate=objAllergy.ALGOnsetDate
			s OnsetDateFreeText=objAllergy.ALGOnsetDateFreeText
			;发作日期描述
			s OnsetDateText=##Class(websys.Conversions).DateLogicalToHtml(OnsetDate)_OnsetDateFreeText
			
			;医护人员 组件里没有使用
			s CareProvider=objAllergy.ALGCTPCPDR
			
			;未激活标志
			s InActive=objAllergy.ALGInActive
			
			;使用不明
			s RowHexColour=""
			s SeverityColour=""
			s HiddenFields=""

			s LastUpdateDate=objAllergy.ALGLastUpdateDate
			s LastUpdateTime=objAllergy.ALGLastUpdateTime
			if objAllergy.ALGUpdateUserDRGetObjectId()'="" {
				s LastUpdateUserId=objAllergy.ALGUpdateUserDR.SSUSRInitials
				s LastUpdateUser=objAllergy.ALGUpdateUserDR.SSUSRName
				s LastUpdateUserRole=objAllergy.ALGUpdateUserDR.SSUSRStaffTypeDR.STAFFDesc
			}
			if objAllergy.ALGLastUpdateHospitalDRGetObjectId()'="" {
				s LastUpdateHospital=objAllergy.ALGLastUpdateHospitalDR.HOSPDesc
			}
			
			;状态
			s Status=objAllergy.ALGStatus
			s ExternalID=objAllergy.ALGExternalID
			;注释
			s Comments=##Class(websys.Conversions).LongTextLogicalToHtml(objAllergy.ALGComments,$C(13,10))
			s ALGFreeTextAllergy=objAllergy.ALGFreeTextAllergy
			s DrugSpecific=objAllergy.ALGDrugSpecific
			;P7的库上没有这个字段
			;s ALGDSReportFlag=objAllergy.ALGDSReportFlag
			s ALGDSReportFlag=""
			s data=$Lb(RowID,Category,Allergen,NatureOfReaction,Severity,SeverityColour,OnsetDate,OnsetDateFreeText,
						CareProvider,InActive,OnsetDateText,RowHexColour,LastUpdateDate,LastUpdateTime,LastUpdateUser,
						LastUpdateHospital,Status,ExternalID,LastUpdateUserRole,LastUpdateUserId,Comments,ALGFreeTextAllergy,
						DrugSpecific,tag,ALGDSReportFlag,HiddenFields)
			set ^CacheTemp(repid,ind)=data
			set ind=ind+1
		}
	}
	quit $$$OK
}

ClassMethod AllergiesFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = AllergiesExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// KM 18-Sept-2001: Created for use with query web.PAPatMas.FindWithIcons:
ClassMethod FindIfPatientHasAllergy(PatientID As %Library.String) As %Library.Integer
{
	n (PatientID)
	&SQL(select Count(*) into :AllergyCount from SQLUser.PA_Allergy Where ALG_PAPMI_ParRef=:PatientID and ALG_Status <> 'I')
	///ALG_InActive='N')
	
	Q $S(AllergyCount>0:1,1:0)
}

/// Log 36933 - AI - 14-08-2003: Simply returns if the Patient has an Allergy with a Allergy Type (Category) that has the Indeterminate Flag checked.
/// ab 1.08.03 - also show icon if assigned 'Nil Allergies' as defined in system param
ClassMethod FindIfPatientHasIndAllergy(PatientID As %Library.String) As %Library.Integer
{
	quit ""
}

/// ab 1.09.03 - 37488 returns if patient has any allergies to be confirmed
ClassMethod GotTBCAllergy(PatientID As %String = "") As %String
{
	quit ""
}

ClassMethod FindPatientReqMealAssistance(PatientID As %Library.String) As %Library.Boolean
{
}

ClassMethod FindPatientReqMenuAssistance(PatientID As %Library.String) As %Library.Boolean
{
}

/// Author - John Hart
/// Purpose - Saves Patient Allergy Details
/// Used By - EPR page
/// 打开PAAllergy.EditEMR编辑界面时调用数据
/// w ##class(web.PAAllergy).GetAllergenDetails("142721||15")
ClassMethod GetAllergenDetails(ID As %String) As %String
{
	n obj1
	if ID'="" {
		s objAllergy=##class(User.PAAllergy).%OpenId(ID)
		if $IsObject(objAllergy){
			s TagCode="",ALGDescCT="",table=""
			s AllergenRowId=objAllergy.ALGTypeDRGetObjectId()
			if AllergenRowId'="" {
				s ALGDescCT=objAllergy.ALGTypeDR.ALGDesc
				s TagCode=objAllergy.ALGMRCAllTypeDR.MRCATTagDescription
				s table="PACAllergy"
			}else{
				s AllergenRowId=objAllergy.ALGPHCGEDRGetObjectId()
				if AllergenRowId'="" {
					s ALGDescCT=objAllergy.ALGPHCGEDR.PHCGEName
					s TagCode="G"
					s table="PHCGeneric"
				}else{
					s AllergenRowId=objAllergy.ALGPHCDMDRGetObjectId()
					if AllergenRowId'="" {
						s ALGDescCT=objAllergy.ALGPHCDMDR.PHCDName
						s TagCode="P"
						s table="PHCDrgMast"
						
					}else{
						s AllergenRowId=objAllergy.ALGIngredDRGetObjectId()
						if AllergenRowId'="" {
							s ALGDescCT=objAllergy.ALGIngredDR.INGRDesc
							s TagCode="I"
							s table="PHCIngredient"
						}
					}
				}

			}
			s MRCATTagDescription=""
			if TagCode="P" s MRCATTagDescription="Pharmacy Item"
			if TagCode="G" s MRCATTagDescription="Generic Drug"
			if TagCode="I" s MRCATTagDescription="Ingredient"
			
			s MRCATDesc=objAllergy.ALGMRCAllTypeDR.MRCATDesc
			
			S CategoryRowId=objAllergy.ALGMRCAllTypeDRGetObjectId()
			
			s %request.Data("ALGDescCT",1)=ALGDescCT
			s %request.Data("MRCATDesc",1)=MRCATDesc
			s %request.Data("CategoryRowId",1)=CategoryRowId
			s %request.Data("TagCode",1)=TagCode
			s %request.Data("AllergenRowId",1)=AllergenRowId
			s %request.Data("MRCATTagDescription",1)=MRCATTagDescription
			s %request.Data("table",1)=table
		}
	}else{
		s %request.Data("table",1)="PACAllergy"
	}
	Q ""
}

ClassMethod HistoryInsert(compref As %Library.String, pid As %String, algDesc As %String, onsetDate As %String, durYr As %String, durMo As %String, durDy As %String, comments As %String, hid As %String, chkInActive As %String)
{
}

ClassMethod LookUpAllergiesClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpAllergiesFetch ]
{
}

ClassMethod LookUpAllergiesExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String, ActiveOnly As %String) As %Library.Status
{
}

ClassMethod LookUpAllergiesFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpAllergiesExecute ]
{
}

/// Log 55973 - PC - 01-12-2005 : Save the selected rows as either "Include in DS Report" or "Exclude From DS Report".
ClassMethod IncludeExcludeDSReport(action As %Library.String = "E", RowIDs As %Library.String = "")
{
}

ClassMethod websysDeleteAllergen(compref As %Library.String, id As %String = "") As %Boolean
{
	;不知是否要处理User.PAAlertMsg
	d ..websysDelete(id)
	Q $$$OK
}

ClassMethod websysBeforeSave(compref As %Library.String, PARREF As %String = "", id As %String = "") As %Boolean
{
	Q $$$OK
}

ClassMethod websysSaveAll(PatientID As %Library.String, Allergies As %Library.String, ListBoxChanged As %Library.String = 1)
{
}

/// cjb 02/02/2005 49305 rewritten some of the save as the 'else' wasn't working...
/// replaced
///  . e  d
/// with
/// . i ALGReasForChangeDR'="",refid'="" d
/// (etc)
ClassMethod websysSaveAllergen(compref As %String, id As %String)
{
 s $ZT="saveerr"
 n compid,status,new,j,oktosave,save,value,parref,oldval
 s compid=$e($p(compref,"i",1),2,999),oktosave=1,save=0
 i id'="",'##Class(websys.Lock).Lock($lb(id,"User.PAAllergy"),%session.SessionId,%session.Get("LOGON.USERID"),.status) d  q 0
 . d msg.AddItem("E","LOCKED",status,compid) s oktosave=0
 i '##Class(web.PAAllergy).websysBeforeSave(compref,.id) q 0
 
 s new=id=""
 s:id'="" obj=##Class(User.PAAllergy).%OpenId(id)
 if id="" d
 . s parref=$g(%request.Data("PARREF",1))
 . i parref="" s obj=##Class(User.PAAllergy).%New()
 . i parref'="" s obj=##Class(User.PAAllergy).%New(parref)
 
 i $d(%request.Data("PARREF",1)) d
 . s (val,oldval)=$g(%request.Data("PARREF",1)) i %request.Get("PARREF")'="" d obj.ALGPAPMIParRefSetObjectId(%request.Get("PARREF"))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PARREF"),""),oldval_" "_$g(t("XINVALID")," is invalid"),compid,"PARREF") s oktosave=0
 
 i $d(%request.Data("UserName",1)) d
 . s (val,oldval)=$g(%request.Data("UserName",1)) d obj.ALGUpdateUserDRSetObjectId(##Class(web.SSUser).GetIdFromCodeOrDescription($g(val)))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("UserName"),"用户名称"),oldval_" "_$g(t("XINVALID")," is invalid"),compid,"UserName") s oktosave=0
 
 d
 . s (val,oldval)=$g(%request.Data("ALGInActive",1)) s obj.ALGInActive=##Class(websys.Conversions).YesNoHtmlToLogical($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("ALGInActive"),"未激活"),oldval_" "_$g(t("XINVALID")," is invalid"),compid,"ALGInActive") s oktosave=0
 
 i $d(%request.Data("ALGOnsetDate",1)) d
 . s (val,oldval)=$g(%request.Data("ALGOnsetDate",1)) s obj.ALGOnsetDate=##Class(websys.Conversions).DateHtmlToLogical($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("ALGOnsetDate"),"发作日期"),oldval_" "_$g(t("XINVALID")," is invalid"),compid,"ALGOnsetDate") s oktosave=0
 
 i $d(%request.Data("ALGOnsetDateFreeText",1)) d
 . s (val,oldval)=$g(%request.Data("ALGOnsetDateFreeText",1)) s obj.ALGOnsetDateFreeText=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("ALGOnsetDateFreeText"),"Onset Date (Free Text)"),oldval_" "_$g(t("XINVALID")," is invalid"),compid,"ALGOnsetDateFreeText") s oktosave=0
 
 i $d(%request.Data("ALRGCATDesc",1)) d
 . s (val,oldval)=$g(%request.Data("ALRGCATDesc",1)) s:$l($g(val)) val=##Class(web.PACAllergyCategory).GetIdFromCodeOrDescription($g(val)) d obj.ALGCategoryDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("ALRGCATDesc"),"拮抗反应"),oldval_" "_$g(t("XINVALID")," is invalid"),compid,"ALRGCATDesc") s oktosave=0
 
 i $d(%request.Data("ALRGSEVDesc",1)) d
 . s (val,oldval)=$g(%request.Data("ALRGSEVDesc",1)) s:$l($g(val)) val=##Class(web.PACAllergySeverity).GetIdFromCodeOrDescription($g(val)) d obj.ALGSeverityDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("ALRGSEVDesc"),"严重"),oldval_" "_$g(t("XINVALID")," is invalid"),compid,"ALRGSEVDesc") s oktosave=0
 
 i $d(%request.Data("ALGComments",1)) d
 . s (val,oldval)=$g(%request.Data("ALGComments",1)) d ##Class(websys.Conversions).LongTextHtmlToLogical(obj.ALGComments,$g(val),$c(13,10))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("ALGComments"),"注释"),oldval_" "_$g(t("XINVALID")," is invalid"),compid,"ALGComments") s oktosave=0

 i $d(%request.Data("ReasForChange",1)) d
 . s (val,oldval)=$g(%request.Data("ReasForChange",1)) s:$l($g(val)) val=##Class(web.PACAllergyReasonForChang).GetIdFromCodeOrDescription($g(val)) d obj.ALGReasForChangeDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("ReasForChange"),"更改原因"),oldval_" "_$g(t("XINVALID")," is invalid"),compid,"ReasForChange") s oktosave=0
 
 i $d(%request.Data("ALGFreeTextAllergy",1)) d
 . s (val,oldval)=$g(%request.Data("ALGFreeTextAllergy",1)) s obj.ALGFreeTextAllergy=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("ALGFreeTextAllergy"),"FreeTextAllergy"),oldval_" "_$g(t("XINVALID")," is invalid"),compid,"ALGFreeTextAllergy") s oktosave=0
 
 d
 . s (val,oldval)=$g(%request.Data("ALGDrugSpecific",1)) s obj.ALGDrugSpecific=##Class(websys.Conversions).YesNoHtmlToLogical($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("ALGDrugSpecific"),"Drug Only"),oldval_" "_$g(t("XINVALID")," is invalid"),compid,"ALGDrugSpecific") s oktosave=0
 
 s table=$g(%request.Data("table",1))
 s val=$g(%request.Data("AllergenRowId",1))
 s ALGDescCT=$g(%request.Data("ALGDescCT",1))
 i ALGDescCT="" s val=""			;wanghc 2012-10-25 
 if table="PHCGeneric" {
	 &SQL(SELECT ALG_RowID into :oldid FROM SQLUser.PA_Allergy
		WHERE (ALG_PAPMI_ParRef = :parref) AND (ALG_PHCGE_DR=:val) AND
			(ALG_InActive = 'N') )
	d obj.ALGPHCGEDRSetObjectId($g(val))
 }
 
 if table="PHCDrgMast" {
	 &SQL(SELECT ALG_RowID into :oldid FROM SQLUser.PA_Allergy
		WHERE (ALG_PAPMI_ParRef = :parref) AND (ALG_PHCDM_DR=:val) AND
			(ALG_InActive = 'N') )
 	d obj.ALGPHCDMDRSetObjectId($g(val))
 }
 
 if table="PHCIngredient" {
	 d obj.ALGIngredDRSetObjectId($g(val))
	 &SQL(SELECT ALG_RowID into :oldid FROM SQLUser.PA_Allergy
		WHERE (ALG_PAPMI_ParRef = :parref) AND (ALG_Ingred_DR=:val) AND
			(ALG_InActive = 'N') )
 }
 if table="PACAllergy"  {
	 s val=$g(%request.Data("ALGDescCT",1))	;新建时用到  wanghc 2012/8/28
	 s val=##class(web.PACAllergy).GetIdFromCodeOrDescription($g(val)) 
	 d obj.ALGTypeDRSetObjectId($g(val))	 
	 &SQL(SELECT ALG_RowID into :oldid FROM SQLUser.PA_Allergy
		WHERE (ALG_PAPMI_ParRef = :parref) AND (ALG_Type_DR=:val) AND
			(ALG_InActive = 'N') )
 }
 if SQLCODE=0 {
	   if ($g(oldid)'="")&&(id'=$g(oldid))&&(id'="") {
 			d msg.AddItem("E",$g(t("ALGDescCT"),"Allergen"),$g(t("IsDuplicate"),"An Active Allergen exists for this Patient - Cannot add Nil Allergies entry."),compid,"ALGDescCT") s oktosave=0
	   }
 }

 
 /*
 if table="PACAllergy"  d obj.ALGTypeDRSetObjectId($g(val))
 if table="PHCGeneric" d obj.ALGPHCGEDRSetObjectId($g(val))
 if table="PHCDrgMast" d obj.ALGPHCDMDRSetObjectId($g(val))
 if table="PHCIngredient" d obj.ALGIngredDRSetObjectId($g(val))
 */
 
 s obj.ALGStatus="A"
 s obj.ALGLastUpdateDate=obj.ALGDate
 s obj.ALGLastUpdateTime=obj.ALGTime
 s obj.ALGExternalID=obj.ALGPAPMIParRefGetObjectId()_"ALG"_obj.ALGChildSub
 
 if $d(%request.Data("CategoryRowId",1)) {
 	s (val,oldval)=$g(%request.Data("CategoryRowId",1)) d obj.ALGMRCAllTypeDRSetObjectId($g(val))
	i oldval'="",val="" d msg.AddItem("E",$g(t("CategoryRowId"),"CategoryRowId"),oldval_" "_$g(t("XINVALID")," is invalid"),compid,"CategoryRowId") s oktosave=0
 }
 
 i 'oktosave,'$g(msg.Count("E")),$g(%request.Data("TOVERRIDE",1)) s oktosave=1
 i oktosave d
 . s save=obj.%Save(0)
 . i $d(msg) d msg.Status(save,compid)
 
 s:save id=obj.%Id()
 d obj.%Close()  s obj=""
 
 s idnew=id
 d:save ##Class(web.PAAllergy).websysAfterSave(compref,id,new)
 i 'new d ##Class(websys.Lock).LockClear($lb(id,"User.PAAllergy"),%session.SessionId)
 q save
saveerr
 d ##Class(websys.Lock).LockClear($lb(id,"User.PAAllergy"),%session.SessionId)
 s ^Temp("Upgrade","websysSaveAllergen")=$ZE
 q 1
}

ClassMethod ReturnAllergyAlert(AllergyID As %Library.String) As %Library.String
{
}

/// Log 28554 - AI - 31-01-2003:
/// Find the details of a Patient's Allergies that are stored on PAAllergy.
/// Used in PAAllergy.ListEMR component.
/// 
/// Log 35610 - AI - 21-03-2003 :
/// Re-arranged to use the ^TMP global for Sequence sorting.
/// Really only required when Sequence field is blank - we want to display this last.
/// 
Query Allergies(PatientID As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "RowID,Category:%String,Allergen:%String,NatureOfReaction:%String,Severity:%String,SeverityColour:%String,OnsetDate:%Date,OnsetDateFreeText:%String,CareProvider:%String,InActive:%Boolean,OnsetDateText:%String,RowHexColour:%String,LastUpdateDate:%Date,LastUpdateTime:%Time,LastUpdateUser:%String,LastUpdateHospital:%String,Status:%String,ExternalID:%String,LastUpdateUserRole:%String,LastUpdateUserId:%String,Comments:%String,ALGFreeTextAllergy:%String,DrugSpecific:%Boolean,tag:%String,ALGDSReportFlag:%Boolean,HiddenFields:%String")
{
}

Query Find(PatientID As %String, ActiveOnly As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "RowID,PACALGDesc:%String,ALGOnsetDate:%Date,ALGDuratYear:%String,ALGDuratMonth:%String,ALGDuratDays:%String,ALGDesc:%List,ALGCareProv:%String,ALGUpdateUser:%String,MRCATDesc:%String,ALGTypeDR:%String,ALGInActive:%String,MRCATIndeterminateCode:%String,Status:%String,PHCGEName:%String,PHCDName:%String,PHCGERowId:%String,PHCDRowId:%String,INGRRowId:%String,INGRDesc:%String")
{
SELECT ALG_RowID,  ALG_Type_DR->ALG_Desc, ALG_OnsetDate,  ALG_DuratYear,  ALG_DuratMonth,
 ALG_DuratDays, ALG_Desc,  ALG_CTPCP_DR->CTPCP_Desc, ALG_UpdateUser_DR->SSUSR_Name,
 ALG_Type_DR->ALG_Type_DR->MRCAT_Desc, ALG_Type_DR, ALG_InActive,
 ALG_Type_DR->ALG_Type_DR->MRCAT_IndeterminateCode,
 ALG_Status,ALG_PHCGE_DR->PHCGE_Name,
 ALG_PHCDM_DR->PHCD_Name,ALG_PHCGE_DR->PHCGE_RowId,ALG_PHCDM_DR->PHCD_RowId,ALG_Ingred_DR->INGR_RowId,ALG_Ingred_DR->INGR_Desc
FROM PA_Allergy
WHERE (ALG_PAPMI_ParRef = :PatientID)
AND ((:ActiveOnly <> 'Y') OR ((:ActiveOnly = 'Y') AND (ALG_Status <> 'I')))
}

Query FindMealAssistance(PatientID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ALGRequireAssistanceMeal")
{
SELECT ALG_RequireAssistanceMeal
FROM PA_Allergy
WHERE (ALG_PAPMI_ParRef = :PatientID)
}

Query FindMenuAssistance(PatientID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ALGRequireAssistanceMenu")
{
SELECT ALG_RequireAssistanceMenu
FROM PA_Allergy
WHERE (ALG_PAPMI_ParRef = :PatientID)
}

/// LOG 26677 - AI - 25-07-2002 : Find With InActive checkbox value.
/// Called by web.PAPatMas.HistoryExecute
/// Used in EPR Chart, Patient History, History.
Query FindWithInActive(PatientID As %String, InActive As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,PACALGDesc:%String,ALGOnsetDate:%Date,ALGDuratYear:%String,ALGDuratMonth:%String,ALGDuratDays:%String,ALGDesc:%List,ALGCareProv:%String,ALGUpdateUser:%String,ALGInActive:%String,MRCATDesc:%String,ALGTypeDR:%String")
{
SELECT ALG_RowID, 
 ALG_Type_DR->ALG_Desc,
 ALG_OnsetDate, 
 ALG_DuratYear, 
 ALG_DuratMonth,
 ALG_DuratDays,
 ALG_Desc, 
 ALG_CTPCP_DR->CTPCP_Desc,
 ALG_UpdateUser_DR->SSUSR_Name,
 ALG_InActive,
 ALG_Type_DR->ALG_Type_DR->MRCAT_Desc,
 ALG_Type_DR
FROM PA_Allergy
WHERE ((ALG_PAPMI_ParRef = :PatientID) AND ((ALG_InActive = :InActive) OR (:InActive = 'Y' AND ALG_InActive IS NULL)))
}

Query LookUpAllergies(papmi As %Library.String, ActiveOnly As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "values:%String,desc:%String")
{
}

/// the dummy methods ensure that websys.abstract doesn't generate nasty sql
ClassMethod LookUpDateBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.String = "") As %Library.Boolean
{
}

/// Log 58610 - GC 27/04/2006 : Save the DS Report Flag.
ClassMethod websysUpdateDSReportFlag(id As %Library.String = "") As %Boolean
{
}

/// cjb 09/10/2006 36197
ClassMethod GetImages(PatientID As %Library.String, ByRef imgLIST As %Library.String)
{
}

}
