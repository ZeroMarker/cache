Import sqluser

Class web.DHCEMAllergyEnter Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 过敏结果查询
/// Creator:     congyue
/// CreateDate:  2016-08-02
/// Table: 		 PA_Allergy
/// Input:  	 病人登记号
/// Return： 	 过敏结果信息
/// Others:		 w ##class(web.DHCEMAllergyEnter).QueryAllergyInfo(0,6,"0000000210")
ClassMethod QueryAllergyInfo(offset = 0, limit = 10, PatientID)
{
	n (offset , limit , PatientID)
	S End = offset+limit
	S Start = offset+1
    S count=0,h=0
    Q:PatientID="" "{""rows"":[],""total"":"_count_"}"
	w "{""rows"":["
	s objpat=##class(User.PAPatMas).%OpenId(PatientID)
	i $ISOBject(objpat) d
	.s h=objpat.ChildPAAllergy.Count()
	.F i=1:1:h d
	..s (RowID,Category,Allergen,NatureOfReaction,Severity,SeverityColour,OnsetDate,OnsetDateFreeText,CareProvider,InActive,OnsetDateText,RowHexColour,LastUpdateDate,LastUpdateTime,LastUpdateUser,LastUpdateHospital,Status,ExternalID,LastUpdateUserRole,LastUpdateUserId,Comments,ALGFreeTextAllergy,DrugSpecific,tag,ALGDSReportFlag,HiddenFields,ALGItem)=""
	..s objAllergy=objpat.ChildPAAllergy.GetAt(i)
	..s RowID=objAllergy.%Id()
	..;自定义过敏分类
	..if objAllergy.ALGTypeDRGetObjectId()'="" d
	...s Allergen=objAllergy.ALGTypeDR.ALGDesc
	...s tag=objAllergy.ALGTypeDR.ALGTypeDR.MRCATTagDescription
	..;通用项过敏源
	..if objAllergy.ALGPHCGEDRGetObjectId()'="" d
	...s ALGItem=objAllergy.ALGPHCGEDR.PHCGEName
	...s tag="G"
	...;s tag="Generic Drug"
	..;药学过敏源
	..if objAllergy.ALGPHCDMDRGetObjectId()'="" d
	...s ALGItem=objAllergy.ALGPHCDMDR.PHCDName
	...s tag="P"
	...;s tag="Pharmacy Item"
	..if objAllergy.ALGIngredDRGetObjectId()'="" d
	...s ALGItem=objAllergy.ALGIngredDR.INGRDesc
	...s tag="I"
	...;s tag="Ingredient"
	..if objAllergy.ALGIngredDRGetObjectId()'="" d
	...s ALGItem=objAllergy.ALGIngredDR.INGRDesc
	...s tag="I"
	...;s tag="Ingredient"
	..;分类
	..s Category=objAllergy.ALGMRCAllTypeDR.MRCATDesc
 	..i (tag="P")!(tag="G")!(tag="I") s tag=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",tag)
	..;拮抗反应
	..if objAllergy.ALGCategoryDRGetObjectId()'="" d
	...s NatureOfReaction=objAllergy.ALGCategoryDR.ALRGCATDesc
	..;医嘱项ID
	..if (objAllergy.ALGExternalID'="")&&(objAllergy.ALGExternalID["||") d
	...s ALGItemID=objAllergy.ALGExternalID
	...s ALGItem=$p($g(^ARCIM(+ALGItemID,$p(ALGItemID,"||",2),1)),"^",2)
	..;严重
	..if objAllergy.ALGSeverityDRGetObjectId()'="" d
	...s Severity=ALGSeverityDR.ALGSeverityDR.ALRGSEVDesc
	..s OnsetDate=objAllergy.ALGOnsetDate
	..s OnsetDateFreeText=objAllergy.ALGOnsetDateFreeText
	..;发作日期描述
	..s:OnsetDate'="" OnsetDateText=##class(web.DHCEMCommonUtil).DateLogicalToHtml(OnsetDate) //$zd(OnsetDate,3) ;=##Class(websys.Conversions).DateLogicalToHtml(OnsetDate)_OnsetDateFreeText
	..;医护人员 组件里没有使用
	..s CareProvider=objAllergy.ALGCTPCPDR
	..;未激活标志
	..s InActive=objAllergy.ALGInActive
	..;使用不明
	..s RowHexColour=""
	..s SeverityColour=""
	..s HiddenFields=""
	..s LastUpdateDate=objAllergy.ALGLastUpdateDate
	..s:LastUpdateDate'="" LastUpdateDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(LastUpdateDate) //$zd(LastUpdateDate,3)
	..s LastUpdateTime=objAllergy.ALGLastUpdateTime
	..if objAllergy.ALGUpdateUserDRGetObjectId()'="" d
	...s LastUpdateUserId=objAllergy.ALGUpdateUserDR.SSUSRInitials
	...s LastUpdateUser=objAllergy.ALGUpdateUserDR.SSUSRName
	...s LastUpdateUserRole=objAllergy.ALGUpdateUserDR.SSUSRStaffTypeDR.STAFFDesc
	..if objAllergy.ALGLastUpdateHospitalDRGetObjectId()'="" d
	...s LastUpdateHospital=objAllergy.ALGLastUpdateHospitalDR.HOSPDesc
	..;状态
	..s Status=objAllergy.ALGStatus
	..s ExternalID=objAllergy.ALGExternalID
	..;注释
	..s Comments=##Class(websys.Conversions).LongTextLogicalToHtml(objAllergy.ALGComments,$C(13,10))
	..s ALGFreeTextAllergy=objAllergy.ALGFreeTextAllergy
	..s DrugSpecific=objAllergy.ALGDrugSpecific
	..s ALGDSReportFlag=objAllergy.ALGDSReportFlag
	..s TempStr=RowID_"^"_Category_"^"_Allergen_"^"_ALGItem_"^"_NatureOfReaction_"^"_Severity_"^"_SeverityColour_"^"_OnsetDate_"^"_OnsetDateFreeText
	..s TempStr=TempStr_"^"_CareProvider_"^"_InActive_"^"_OnsetDateText_"^"_RowHexColour_"^"_LastUpdateDate_"^"_LastUpdateTime_"^"_LastUpdateUser
	..s TempStr=TempStr_"^"_LastUpdateHospital_"^"_Status_"^"_ExternalID_"^"_LastUpdateUserRole_"^"_LastUpdateUserId_"^"_Comments_"^"_ALGFreeTextAllergy
	..s TempStr=TempStr_"^"_DrugSpecific_"^"_tag_"^"_ALGDSReportFlag_"^"_HiddenFields
	..;set ^CacheTemp(repid,ind)=data
	..S count=count+1
	..Q:count<Start
	..Q:count>End
   	..W $case(count,Start:"",:",") 
	..W ##class(web.DHCAPPJsonCommon).getJsonData("RowID^Category^Allergen^ALGItem^NatureOfReaction^Severity^SeverityColour^OnsetDate^OnsetDateFreeText^CareProvider^InActive^OnsetDateText^RowHexColour^LastUpdateDate^LastUpdateTime^LastUpdateUser^LastUpdateHospital^Status^ExternalID^LastUpdateUserRole^LastUpdateUserId^Comments^ALGFreeTextAllergy^DrugSpecific^tag^ALGDSReportFlag^HiddenFields",TempStr)
	W "],""total"":"_count_"}"

	Q ""
}

/// Description: 过敏结果查询(hisui调用)
/// Creator:     lvpeng
/// CreateDate:  2018-02-26
/// Table: 		 PA_Allergy
/// Input:  	 病人登记号
/// Return： 	 过敏结果信息
/// Others:		 w ##class(web.DHCEMAllergyEnter).QueryAllergyInfoNew(1,10,"9")
ClassMethod QueryAllergyInfoNew(page = 1, rows = 10, PatientID)
{
	n (page , rows , PatientID,%session)
	s start=(page-1)*rows+1
	s end=page*rows
    S count=0,h=0
    Q:PatientID="" "{""rows"":[],""total"":"_count_"}"
	s TempColumn="RowID"_$c(1)_"Category"_$c(1)_"Allergen"_$c(1)_"ALGItem"_$c(1)_"NatureOfReaction"_$c(1)_"Severity"_$c(1)_"SeverityColour"_$c(1)_"OnsetDate"_$c(1)_"OnsetDateFreeText"_$c(1)_"CareProvider"_$c(1)_"InActive"_$c(1)_"OnsetDateText"_$c(1)_"RowHexColour"_$c(1)_"LastUpdateDate"_$c(1)_"LastUpdateTime"_$c(1)_"LastUpdateUser"_$c(1)_"LastUpdateHospital"_$c(1)_"Status"_$c(1)_"ExternalID"_$c(1)_"LastUpdateUserRole"_$c(1)_"LastUpdateUserId"_$c(1)_"Comments"_$c(1)_"ALGFreeTextAllergy"_$c(1)_"DrugSpecific"_$c(1)_"tag"_$c(1)_"ALGDSReportFlag"_$c(1)_"HiddenFields"
	w "{""rows"":["
	s objpat=##class(User.PAPatMas).%OpenId(PatientID)
	i $ISOBject(objpat) d
	.s h=objpat.ChildPAAllergy.Count()
	.F i=1:1:h d
	..s (RowID,Category,Allergen,NatureOfReaction,Severity,SeverityColour,OnsetDate,OnsetDateFreeText,CareProvider,InActive,OnsetDateText,RowHexColour,LastUpdateDate,LastUpdateTime,LastUpdateUser,LastUpdateHospital,Status,ExternalID,LastUpdateUserRole,LastUpdateUserId,Comments,ALGFreeTextAllergy,DrugSpecific,tag,ALGDSReportFlag,HiddenFields,ALGItem)=""
	..s objAllergy=objpat.ChildPAAllergy.GetAt(i)
	..s RowID=objAllergy.%Id()
	..;自定义过敏分类
	..if +objAllergy.ALGTypeDRGetObjectId()'="0" d
	...s Allergen=objAllergy.ALGTypeDR.ALGDesc
	...s tag=objAllergy.ALGTypeDR.ALGTypeDR.MRCATTagDescription
	..;通用项过敏源
	..if +objAllergy.ALGPHCGEDRGetObjectId()'="0" d
	...s ALGItem=objAllergy.ALGPHCGEDR.PHCGEName
	...s tag="G"
	...;s tag="Generic Drug"
	..;药学过敏源
	..if +objAllergy.ALGPHCDMDRGetObjectId()'="0" d
	...s ALGItem=objAllergy.ALGPHCDMDR.PHCDName
	...s tag="P"
	...;s tag="Pharmacy Item"
	..if +objAllergy.ALGIngredDRGetObjectId()'="0" d
	...s ALGItem=objAllergy.ALGIngredDR.INGRDesc
	...s tag="I"
	...;s tag="Ingredient"
	..//if objAllergy.ALGIngredDRGetObjectId()'="" d
	...//s ALGItem=objAllergy.ALGIngredDR.INGRDesc
	...//s tag="I"
	...;s tag="Ingredient"
	..;分类
	..s Category=objAllergy.ALGMRCAllTypeDR.MRCATDesc
 	..i (tag="P")!(tag="G")!(tag="I") s tag=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",tag)
	..;拮抗反应
	..if objAllergy.ALGCategoryDRGetObjectId()'="" d
	...s NatureOfReaction=objAllergy.ALGCategoryDR.ALRGCATDesc
	..;医嘱项ID
	..i ALGItem="" d
	...if (objAllergy.ALGExternalID'="")&&(objAllergy.ALGExternalID["||") d
	....s ALGItemID=objAllergy.ALGExternalID
	....s ALGItem=$p($g(^ARCIM(+ALGItemID,$p(ALGItemID,"||",2),1)),"^",2)
	...e  i objAllergy.ALGExternalID'="" d
	....s ALGItem=objAllergy.ALGExternalID
	....s ALGItemID=objAllergy.ALGExternalID
	..;严重
	..if objAllergy.ALGSeverityDRGetObjectId()'="" d
	...s Severity=ALGSeverityDR.ALGSeverityDR.ALRGSEVDesc
	..s OnsetDate=objAllergy.ALGOnsetDate
	..s OnsetDateFreeText=objAllergy.ALGOnsetDateFreeText
	..;发作日期描述
	..s:OnsetDate'="" OnsetDateText=##class(web.DHCEMCommonUtil).DateLogicalToHtml(OnsetDate) //$zd(OnsetDate,3) ;=##Class(websys.Conversions).DateLogicalToHtml(OnsetDate)_OnsetDateFreeText
	..;医护人员 组件里没有使用
	..s CareProvider=objAllergy.ALGCTPCPDR
	..;未激活标志
	..s InActive=objAllergy.ALGInActive
	..;使用不明
	..s RowHexColour=""
	..s SeverityColour=""
	..s HiddenFields=""
	..s LastUpdateDate=objAllergy.ALGLastUpdateDate
	..s:LastUpdateDate'="" LastUpdateDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(LastUpdateDate) //$zd(LastUpdateDate,3)
	..s LastUpdateTime=objAllergy.ALGLastUpdateTime
	..if objAllergy.ALGUpdateUserDRGetObjectId()'="" d
	...s LastUpdateUserId=objAllergy.ALGUpdateUserDR.SSUSRInitials
	...s LastUpdateUser=objAllergy.ALGUpdateUserDR.SSUSRName
	...s LastUpdateUser =##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",LastUpdateUser)
	...s LastUpdateUserRole=objAllergy.ALGUpdateUserDR.SSUSRStaffTypeDR.STAFFDesc
	..if objAllergy.ALGLastUpdateHospitalDRGetObjectId()'="" d
	...s LastUpdateHospital=objAllergy.ALGLastUpdateHospitalDR.HOSPDesc
	..;状态
	..s Status=objAllergy.ALGStatus
	..s ExternalID=objAllergy.ALGExternalID
	..;注释
	..s Comments=##Class(websys.Conversions).LongTextLogicalToHtml(objAllergy.ALGComments,$C(13,10))
	..s ALGFreeTextAllergy=objAllergy.ALGFreeTextAllergy
	..s DrugSpecific=objAllergy.ALGDrugSpecific
	..s ALGDSReportFlag=objAllergy.ALGDSReportFlag
	..; 过敏原 增加显示 过敏原补充内容 2022-10-09 cy
	..s ALGDescAdd=objAllergy.ALGDescAdd
	..i (ALGDescAdd'="")&&(Allergen'="") s Allergen=Allergen_"("_ALGDescAdd_")"
	..i (ALGDescAdd'="")&&(Allergen="") s Allergen=ALGDescAdd
	..s TempStr=RowID_$c(1)_Category_$c(1)_Allergen_$c(1)_ALGItem_$c(1)_NatureOfReaction_$c(1)_Severity_$c(1)_SeverityColour_$c(1)_OnsetDate_$c(1)_OnsetDateFreeText
	..s TempStr=TempStr_$c(1)_CareProvider_$c(1)_InActive_$c(1)_OnsetDateText_$c(1)_RowHexColour_$c(1)_LastUpdateDate_$c(1)_LastUpdateTime_$c(1)_LastUpdateUser
	..s TempStr=TempStr_$c(1)_LastUpdateHospital_$c(1)_Status_$c(1)_ExternalID_$c(1)_LastUpdateUserRole_$c(1)_LastUpdateUserId_$c(1)_Comments_$c(1)_ALGFreeTextAllergy
	..s TempStr=TempStr_$c(1)_DrugSpecific_$c(1)_tag_$c(1)_ALGDSReportFlag_$c(1)_HiddenFields
	..
	..;set ^CacheTemp(repid,ind)=data
	..S count=count+1
	..q:count<start
	..q:count>end
   	..W $case(count,start:"",:",") 
	..W ##class(web.DHCAPPJsonCommon).getJsonData(TempColumn,TempStr,$c(1))
	W "],""total"":"_count_"}"

	Q ""
}

/// Description: 获取患者的过敏源
/// Creator:     qqa
/// CreateDate:  2021-04-23
/// Table: 		 PA_Allergy
/// Input:  	 PatientID
/// Return： 	 过敏源
/// Others:		 w ##class(web.DHCEMAllergyEnter).GetPatALGDesc("111")
ClassMethod GetPatALGDesc(PatientID)
{
	n ( PatientID,%session)
	s Ret=""
	s ObjPat=##class(User.PAPatMas).%OpenId(PatientID,0)
	i $ISOBject(ObjPat) d
	.s Len=ObjPat.ChildPAAllergy.Count()
	.F i=1:1:Len d
	..s ObjAllergy=ObjPat.ChildPAAllergy.GetAt(i)
	..s RowID=ObjAllergy.%Id()
	..s Status=ObjAllergy.ALGStatus
	..q:Status'="A"
	..s Allergen=""
	..if +ObjAllergy.ALGTypeDRGetObjectId()'="0" d
	...s Allergen=ObjAllergy.ALGTypeDR.ALGDesc
	...s Allergen=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACAllergy","ALGDesc","",Allergen) //hxy 2022-12-19
	..s ALGDescAdd=ObjAllergy.ALGDescAdd
	..; 过敏原 增加显示 过敏原补充内容 2022-10-09 cy
	..i (ALGDescAdd'="")&&(Allergen'="") s Allergen=Allergen_"("_ALGDescAdd_")"
	..i (ALGDescAdd'="")&&(Allergen="") s Allergen=ALGDescAdd
	..s:Allergen'="" TMPData("Allergen",Allergen)=""
	
	s Allergen=""
	f  s Allergen=$o(TMPData("Allergen",Allergen)) q:Allergen=""  d
	.s:Ret'="" Ret=Ret_","_Allergen
	.s:Ret="" Ret=Allergen
	Q Ret
}

/// 2012.12.14 dhcc
ClassMethod DeleteAllergen(EpisodeID As %Library.String, id As %String = "") As %Boolean [ ProcedureBlock = 0 ]
{
	;不知是否要处理User.PAAlertMsg
	//d ..websysDelete(id)
	n (EpisodeID,id)
	s ^QQA  = EpisodeID_"^"_id
	if (##class(User.PAAllergy).%ExistsId(id))
	set PAAllergyObj=##class(User.PAAllergy).%DeleteId(id)
	s EpisodeID=EpisodeID
	s rtn=##class(web.DOC.PortalService).DHCHisInterface("S00000013",id,2,EpisodeID)
	Q $$$OK
}

/// Description: 过敏录入保存
/// Creator:     congyue
/// CreateDate:  2016-08-09
/// Table: 		 PA_Allergy
/// Input:  	 医嘱id
/// Return： 	 
/// 	var list="395"+"^"+ALGOnsetDate+"^"+MRCATTagDescription+"^"+ALGMRCCat+"^"+ALGDescCT+"^"+ALGItem+"^"+ALGComments+"^"+ALGCheckConflict;
/// Others:		 w ##class(web.DHCEMAllergyEnter).SaveAllergyInfo("284!!22/01/2019!!成分!!!!!!测试!!!!!!I!!5570!!2!!","")
ClassMethod SaveAllergyInfo(list As %String, id As %String) [ ProcedureBlock = 0 ]
{
 
 s $ZT="saveerr"
 n (list,id) ;compid,status,new,j,oktosave,save,value,parref,oldval
 s new=id=""
 s EpisodeID=$p(list,"!!",1) ;就诊id
 s ALGOnsetDate=$p(list,"!!",2) ;过敏日期
 
 s MRCATTagDescription=$p(list,"!!",3) ;过敏类型
 s ALGMRCCat=$p(list,"!!",4) ;过敏分类
 s ALGDescCT=$p(list,"!!",5) ;过敏源
 s ALGItem=$p(list,"!!",6) ;过敏项目
 s ALGComments=$p(list,"!!",7) ;过敏情况补充
 s ALGCheckConflict=$p(list,"!!",8) ;过敏冲突检测开启
 s MRCATTagDescriptionCode=$p(list,"!!",9) ;过敏类型 代码
 s LgUserID=$p(list,"!!",10) ;用户id
 S papRowid=$p(list,"!!",11) ;病人ID
 s ALGStatus=$p(list,"!!",12) ;状态 2016-10-26
 s:id'="" obj=##Class(User.PAAllergy).%OpenId(id)
 if id="" d
 . s parref=$g(papRowid)
 . i parref="" s obj=##Class(User.PAAllergy).%New()
 . i parref'="" s obj=##Class(User.PAAllergy).%New(parref)
 
 i $d(papRowid) d
 . s (val,oldval)=$g(papRowid)  d obj.ALGPAPMIParRefSetObjectId(papRowid) //i papRowid'=""
 ;过敏分类
 i $d(ALGMRCCat) d
 . s (val,oldval)=$g(ALGMRCCat) d obj.ALGMRCAllTypeDRSetObjectId(ALGMRCCat) //:$g(val)'=""
 ;过敏源
 i $d(ALGDescCT) d
 . s (val,oldval)=$g(ALGDescCT) d obj.ALGTypeDRSetObjectId($g(val)) //:$g(val)'=""
 
 ///qqa 2017-07-12
 i ('+ALGDescCT)&(+id) d
 . d obj.ALGTypeDRSetObjectId($g(val))
 
 ;过敏项目
 if $d(ALGItem) 
 {
 	if $g(MRCATTagDescriptionCode)="G"
 	{   //通用名
	 s (val,oldval)=$g(ALGItem) d:$g(val)'="" obj.ALGPHCGEDRSetObjectId($g(val)),obj.ALGPHCDMDRSetObjectId(""),obj.ALGIngredDRSetObjectId("")
 	}elseif $g(MRCATTagDescriptionCode)="P"
 	{   //药学项
	 s (val,oldval)=$g(ALGItem) d:$g(val)'="" obj.ALGPHCDMDRSetObjectId($g(val)),obj.ALGPHCGEDRSetObjectId(""),obj.ALGIngredDRSetObjectId("")
 	}elseif $g(MRCATTagDescriptionCode)="I"
 	{   //自定义
	 s (val,oldval)=$g(ALGItem) d:$g(val)'="" obj.ALGIngredDRSetObjectId($g(val)),obj.ALGPHCGEDRSetObjectId("",),obj.ALGPHCDMDRSetObjectId("")
 	}else
 	{   //医嘱项
	 s (val,oldval)=$g(ALGItem) s:$g(val)'="" obj.ALGExternalID=ALGItem
 	}
 }
 
 ///qqa 2017-07-12
 if '+ALGItem
 {
	if $g(MRCATTagDescriptionCode)="G"
 	{   //通用名
	 s (val,oldval)=$g(ALGItem) d obj.ALGPHCGEDRSetObjectId($g(val))
 	}elseif $g(MRCATTagDescriptionCode)="P"
 	{   //药学项
	 s (val,oldval)=$g(ALGItem) d obj.ALGPHCDMDRSetObjectId($g(val))
 	}elseif $g(MRCATTagDescriptionCode)="I"
 	{   //自定义
	 s (val,oldval)=$g(ALGItem) d obj.ALGIngredDRSetObjectId($g(val))
 	}else
 	{   //医嘱项
	 s (val,oldval)=$g(ALGItem) s obj.ALGExternalID=ALGItem
	 d obj.ALGPHCGEDRSetObjectId($g(val))
	 d obj.ALGPHCDMDRSetObjectId($g(val))
	 d obj.ALGIngredDRSetObjectId($g(val))
 	} 
 }
 i $d(ALGComments) d
 . s (val,oldval)=$g(ALGComments) d ##Class(websys.Conversions).LongTextHtmlToLogical(obj.ALGComments,$g(val),$c(13,10))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("ALGComments"),"注释"),oldval_" "_$g(t("XINVALID")," is invalid"),compid,"ALGComments") s oktosave=0

 i $d(LgUserID) d
 . s (val,oldval)=$g(LgUserID) d obj.ALGUpdateUserDRSetObjectId(LgUserID)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("UserName"),"用户名称"),oldval_" "_$g(t("XINVALID")," is invalid"),compid,"UserName") s oktosave=0
 
 i $d(ALGOnsetDate) d
 . s obj.ALGOnsetDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(ALGOnsetDate) //hxy $zdh(ALGOnsetDate,3)
 i obj.ALGOnsetDate>+$h q -9 //时间超限
 s:ALGStatus="" ALGStatus="A" ;2016-10-26
 s obj.ALGStatus=ALGStatus  ;状态 2016-10-26
 s obj.ALGLastUpdateDate=+$H
 s obj.ALGLastUpdateTime=$P($H,",",2)
 s save=obj.%Save(0)
 s newFalg=0
 i id="" s newFalg=1
 s:save id=obj.%Id()
 d obj.%Close()  s obj=""

 i ($d(ALGDescCT)&&(id'=""))
 {
	 s $P(^PAPER(+id,"ALG",$P(id,"||",2),"DHC"),"^",1)=ALGDescCT
	 
 }

 i ($d(ALGCheckConflict)&&(id'="")) 
 {
	  s Conflictval=$g(ALGCheckConflict)
      s $P(^PAPER(+id,"ALG",$P(id,"||",2),"DHC"),"^",3)=##Class(websys.Conversions).YesNoHtmlToLogical($g(Conflictval))     
 }
 else
 {
	  s $P(^PAPER(+id,"ALG",$P(id,"||",2),"DHC"),"^",3)=##Class(websys.Conversions).YesNoHtmlToLogical("")
 }
 s idnew=id
 i newFalg=1 d
 .s EpisodeID=EpisodeID
 .s rtn=##class(web.DOC.PortalService).DHCHisInterface("S00000013",id,1,EpisodeID)
 q save
saveerr
 s ^Temp("Upgrade","websysSave","web.DHCPAAllergy")=$ZE
 q -1
}

/// Description: 过敏类型
/// Creator:     congyue
/// CreateDate:  2016-08-09
/// Table: 		 PHC_DrgMast  
/// Input:  	 医嘱id
/// Return： 	 皮试结果信息
/// Others:		 w ##class(web.DHCEMAllergyEnter).LookUpByType("","","")
/// ClassMethod LookUpByType(type As %String, val As %String, search As %String) As %String
ClassMethod LookUpByType(type As %String, val As %String, search As %String) As %String
{
	n (type, val,search)
	s type="AllergenTag"
	s val=""
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	s count=1
#;	SELECT Description, Code, StoredValue
#;FROM websys.StandardTypeItem
#;WHERE ParRef=:type 
#;AND Description %STARTSWITH :val
#;
#;	
	w "["
   		&sql(
 	  		DECLARE StaTyItm CURSOR FOR
 	  		SELECT	Description,StoredValue
 	  		     into :Description,:StoredValue
 	  		FROM	websys.StandardTypeItem
 	  		WHERE	(ParRef=:type AND Description %STARTSWITH :val)
 	  		ORDER BY Description ASC
  		 	)
   		&sql(OPEN StaTyItm)
   		For  &SQL(FETCH StaTyItm) QUIT:SQLCODE  do
   		.q:(search'="")&&(StoredValue'[search)
   		.q:(Description="")||(StoredValue="")
   		.w $CASE(count,1:"",:",")
		.w jsonObj.Put("id",StoredValue).Put("text",Description).Json()
		.s count=count+1
		&SQL(CLOSE StaTyItm)
		w "]"
	q ""
}

/// Description: 过敏项目
/// Creator:     congyue
/// CreateDate:  2016-08-09
/// Table: 		 PHC_DrgMast  
/// Input:  	 医嘱id
/// Return： 	 皮试结果信息
/// Others:		 w ##class(web.DHCEMAllergyEnter).listAlgItem("","G","","lhn")
ClassMethod listAlgItem(ALGItem As %String, TagCode As %String, GroupID As %String = "", q As %String) As %String
{
   
	n (ALGItem, TagCode, GroupID,q)
	s ^tan("listAlgItem")=ALGItem_","_TagCode_","_GroupID_","_q
	s ALGItem=q 
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	s count=1
	w "["
	if TagCode="P"
	{
		; Pharmacy Item
		/*
   		&sql(
 	  		DECLARE PhmItm CURSOR FOR
 	  		SELECT	PHCD_Name,PHCD_RowId
 	  		     into :PHCDName,:PHCDRowId
 	  		FROM	SQLUser.PHC_DrgMast
 	  		WHERE	((%ALPHAUP PHCD_Name %STARTSWITH %ALPHAUP :ALGItem) OR (:ALGItem IS NULL))
 	  		ORDER BY PHCD_Name ASC
  		 	)
   		&sql(OPEN PhmItm)
   		For  &SQL(FETCH PhmItm) QUIT:SQLCODE  do
   		.q:(PHCDRowId="")||(PHCDName="")
   		.q:(q'="")&&(PHCDName'[q)
   		.w $CASE(count,1:"",:",")
		.w jsonObj.Put("id",PHCDRowId).Put("text",PHCDName).Json()
		.s count=count+1
		&SQL(CLOSE PhmItm)
		*/
		s PHCDRowId=0
		for {
			s PHCDRowId=$O(^PHCD(PHCDRowId))
			q:(PHCDRowId="")
			s PHCDName=$P($G(^PHCD(PHCDRowId,1)),"^",2)
			if (PHCDName=""){
				continue
			}
			s PHCDAlias=##class(ext.util.String).ToChineseSpell(PHCDName)
			if (q="")||((q'="")&&
				($ZCVT(PHCDName,"U")'[$ZCVT(q,"U"))&&
				($ZCVT(PHCDAlias,"U")'[$ZCVT(q,"U"))
				){
			
				continue
			}
			w $CASE(count,1:"",:",")
			w jsonObj.Put("id",PHCDRowId).Put("text",PHCDName).Json()
			s count=count+1
		}
	}
	elseif TagCode="G"  
	{
		; Generic Drug
		/*
   		&sql(
 	  		DECLARE GenDrg CURSOR FOR
 	  		SELECT	PHCGE_Name,PHCGE_RowId
 	  		into :PHCGEName,:PHCGERowId
 	  		FROM	SQLUser.PHC_Generic
 	 		WHERE	((%ALPHAUP PHCGE_Name %STARTSWITH %ALPHAUP :ALGItem) OR (:ALGItem IS NULL))
 	  		ORDER BY PHCGE_Name ASC
   			)
   		&sql(OPEN GenDrg)
   		For  &SQL(FETCH GenDrg) QUIT:SQLCODE  do
   		.q:(PHCGERowId="")||(PHCGEName="")
   		.q:(q'="")&&(PHCGEName'[q)
		.;q:count>20 //hxy 2017-02-06
   		.w $CASE(count,1:"",:",")
		.w jsonObj.Put("id",PHCGERowId).Put("text",PHCGEName).Json()
		.s count=count+1
		&SQL(CLOSE GenDrg)
		*/
		s PHCGERowId=0
		for {
			s PHCGERowId=$O(^PHCGE("GE",PHCGERowId))
			q:(PHCGERowId="")
			s PHCGEName=$P($G(^PHCGE("GE",PHCGERowId)),"^",2)
			//w PHCGEName,!
			if (PHCGEName=""){
				continue
			}
			s PHCGEAlias=##class(ext.util.String).ToChineseSpell(PHCGEName)
			if (q="")||((q'="")&&
				($ZCVT(PHCGEName,"U")'[$ZCVT(q,"U"))&&
				($ZCVT(PHCGEAlias,"U")'[$ZCVT(q,"U"))
				){
			
				continue
			}
			w $CASE(count,1:"",:",")
			w jsonObj.Put("id",PHCGERowId).Put("text",PHCGEName).Json()
			s count=count+1
		}
	}
	elseif TagCode="I"  //
	{
		; Ingradient
		/*
   		&sql(
 	  		DECLARE Ingrd CURSOR FOR
 	  		SELECT	INGR_Desc,INGR_RowId
 	  		into :INGRDesc,:INGRRowId
 	  		FROM	SQLUser.PHC_Ingredient
 	  		WHERE	((%ALPHAUP INGR_Desc %STARTSWITH %ALPHAUP :ALGItem) OR (:ALGItem IS NULL))
 	  		ORDER BY INGR_Desc ASC
   			)
   		&sql(OPEN Ingrd)
   		For  &SQL(FETCH Ingrd) QUIT:SQLCODE  do
   		.q:(PHCGERowId="")||(PHCGEName="")
   		.q:(q'="")&&(PHCGEName'[q)
		.;q:count>20 //hxy 2017-02-07
   		.w $CASE(count,1:"",:",")
		.w jsonObj.Put("id",PHCGERowId).Put("text",PHCGEName).Json()
		.s count=count+1
		&SQL(CLOSE Ingrd)
		*/
		s INGRRowId=0
		for {
			s INGRRowId=$O(^PHC("INGR",INGRRowId))
			q:(INGRRowId="")
			s INGRName=$P($G(^PHC("INGR",INGRRowId)),"^",2)
			if (INGRName=""){
				continue
			}
			s INGRAlias=##class(ext.util.String).ToChineseSpell(INGRName)
			if (q="")||((q'="")&&
				($ZCVT(INGRName,"U")'[$ZCVT(q,"U"))&&
				($ZCVT(INGRAlias,"U")'[$ZCVT(q,"U"))
				){
			
				continue
			}
			w $CASE(count,1:"",:",")
			w jsonObj.Put("id",INGRRowId).Put("text",INGRName).Json()
			s count=count+1
		}
		
	}else
	{
		//QQA 2017-2-17	这里的ALGItem已经相当于名称过滤，不需要二次过滤。
	
		if (ALGItem'=""){
			Set rset=##class(%ResultSet).%New("web.DHCDocOrderEntry.LookUpItem")
			d rset.Execute(ALGItem,GroupID,"","", "", "", "", "", "", "", "", "","", "","","")
		 	While (rset.Next()) {  
		            s ArcimDesc=rset.GetData(1)
		            s ArcimId=rset.GetData(2)
		            w $CASE(count,1:"",:",")
		            w jsonObj.Put("id",ArcimId).Put("text",ArcimDesc).Json()
					s count=count+1
		 	}
		 	d rset.Close()
		}
	}
	w "]"
	q ""
}

/// Description: 过敏分类
/// Creator:     congyue
/// CreateDate:  2016-08-09
/// Table: 		 MRC_AllType
/// Input:  	 医嘱id
/// Return： 	 皮试结果信息
/// Others:		 w ##class(web.DHCEMAllergyEnter).listAlgMrcCat("","","")
ClassMethod listAlgMrcCat1(search As %String, tag As %String, date As %Date = "") As %Status
{
	n (search, tag, date)
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	s listObj=##class(%ListOfObjects).%New()
	if search'=""  s search=$zcvt(search,"U")
	s MRCATRowId=0 f  s MRCATRowId=$o(^MRC("AT",MRCATRowId)) q:MRCATRowId=""  d
	.s MRCATCode=$p(^MRC("AT",MRCATRowId),"^")
	.s MRCATDesc=$p(^MRC("AT",MRCATRowId),"^",2)
	.q:(search'="")&&(MRCATDesc'[search)
	.s MRCATTagDescription=$p(^MRC("AT",MRCATRowId),"^",6)
	.q:(tag'="")&&(MRCATTagDescription'=tag)
	.s DateForm=$p(^MRC("AT",MRCATRowId),"^",9)
	.q:(DateForm'="")&&(+$h<DateForm)
	.s DateTo=$p(^MRC("AT",MRCATRowId),"^",10)
	.q:(DateTo'="")&&(+$h>DateTo)
	.;Set ^CacheTemp(repid,ind)=$lb(MRCATDesc,MRCATCode,MRCATTagDescription,MRCATRowId)
	.;Set ind=ind+1
	.d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("id",MRCATRowId).Put("text",MRCATDesc))
	w jsonObj.ListToJson(listObj)
	q ""
}

/// Description: 过敏分类
/// Creator:     QQA
/// CreateDate:  2017-02-15
/// Table: 		 MRC_AllType
/// Input:  	 医嘱id
/// Return： 	 皮试结果信息
/// Others:		 w ##class(web.DHCEMAllergyEnter).listAlgMrcCat("","","")
ClassMethod listAlgMrcCat(desc As %String, tag As %String, date As %Date = "", search As %String) As %Status
{
	n (search,desc,tag, date)
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	s listObj=##class(%ListOfObjects).%New()
	s desc=$g(search)
	if desc'=""  s desc=$zcvt(desc,"U")
	s MRCATRowId=0 f  s MRCATRowId=$o(^MRC("AT",MRCATRowId)) q:MRCATRowId=""  d
	.s MRCATCode=$p(^MRC("AT",MRCATRowId),"^")
	.s MRCATDesc=$p(^MRC("AT",MRCATRowId),"^",2)
	.q:(desc'="")&&(MRCATDesc'[desc)
	.s MRCATTagDescription=$p(^MRC("AT",MRCATRowId),"^",6)
	.q:(tag'="")&&(MRCATTagDescription'=tag)
	.s DateForm=$p(^MRC("AT",MRCATRowId),"^",9)
	.q:(DateForm'="")&&(+$h<DateForm)
	.s DateTo=$p(^MRC("AT",MRCATRowId),"^",10)
	.q:(DateTo'="")&&(+$h>DateTo)
	.d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("id",MRCATRowId).Put("text",MRCATDesc))
	w jsonObj.ListToJson(listObj)
	q ""
}

/// Description: 过敏源(下拉框)
/// Creator:     congyue
/// CreateDate:  2016-08-09
/// Table: 		 PAC_Allergy
/// Input:  	 医嘱id
/// Return： 	 皮试结果信息
/// Others:		 w ##class(web.DHCEMAllergyEnter).listAlgDescCT("","2","")
ClassMethod listAlgDescCT(search As %String, CategoryRowId As %String = "", TagCode As %String = "")
{
	n (search, CategoryRowId, TagCode)
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	s listObj=##class(%ListOfObjects).%New()
	if search'=""  s search=$zcvt(search,"U")
	s ALGDesc="" f  s ALGDesc=$o(^PAC("ALG",0,"Desc",ALGDesc)) q:ALGDesc=""  d
	.q:(search'="")&&(ALGDesc'[search)
	.s ALGRowId="" f  s ALGRowId=$o(^PAC("ALG",0,"Desc",ALGDesc,ALGRowId)) q:ALGRowId=""  d
	..q:'$d(^PAC("ALG",ALGRowId))
	..s ALGCode=$p(^PAC("ALG",ALGRowId),"^")
	..s MRCATDesc="",MRCATTagDescription="",MRCATTagCode=""
	..s ALGTypeDR=$p(^PAC("ALG",ALGRowId),"^",3)
	..s:ALGTypeDR'="" MRCATDesc=$p(^MRC("AT",ALGTypeDR),"^",2),MRCATTagCode=$p(^MRC("AT",ALGTypeDR),"^",6) 
	..q:(CategoryRowId'="")&&(CategoryRowId'=ALGTypeDR)
	..q:(TagCode'="")&&(TagCode'=MRCATTagCode)
	..s:MRCATTagCode'="" MRCATTagDescription=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",MRCATTagCode)
	..s DateForm=$p(^PAC("ALG",ALGRowId),"^",4)
	..q:(DateForm'="")&&(+$h<DateForm)
	..s DateTo=$p(^PAC("ALG",ALGRowId),"^",5)
	..q:(DateTo'="")&&(+$h>DateTo)
	..;Set ^CacheTemp(repid,ind)=$lb(ALGDesc,ALGCode,MRCATDesc,MRCATTagDescription,MRCATTagCode,ALGRowId)
	..;Set ind=ind+1
	..d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("id",ALGRowId).Put("text",ALGDesc))
	; d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("id","N").Put("text","停用"))
	w jsonObj.ListToJson(listObj)
	q ""
}

/// Description: 通过ID查询过敏记录信息
/// Creator:     congyue
/// CreateDate:  2017-03-22
/// Table: 		 PAC_Allergy
/// Input:  	 医嘱id
/// Return： 	 皮试结果信息
/// Others:		 w ##class(web.DHCEMAllergyEnter).GetAllergenDetails("13||1")
ClassMethod GetAllergenDetails(ID As %String) As %String
{
	s dataStr = ""
	
	if ID'="" {
		s ALGItem=""
		s objAllergy=##class(User.PAAllergy).%OpenId(ID,0)
		if $IsObject(objAllergy){
			s TagCode="",ALGDescCT="",table="",MRCATTagDescription="",TagCode="",ALGItemRowId="",ALGItem=""
			///过敏子分类(过敏源)
			s AllergenRowId=objAllergy.ALGTypeDRGetObjectId()
			if +AllergenRowId'="0" {
				s ALGDescCT=objAllergy.ALGTypeDR.ALGDesc             //过敏源
			    s TagCode=objAllergy.ALGTypeDR.ALGTypeDR.MRCATTagDescription
			}  //else{
			
				s ALGPHCGEDR=objAllergy.ALGPHCGEDRGetObjectId()
				if +ALGPHCGEDR'="0" {
					s ALGItem=objAllergy.ALGPHCGEDR.PHCGEName		//过敏项目
					s ALGItemRowId=ALGPHCGEDR
					s TagCode="G"
					//s table="PHCGeneric"
				}else{
					s ALGPHCDMDR=objAllergy.ALGPHCDMDRGetObjectId()
					if +ALGPHCDMDR'="0" {
						s ALGItem=objAllergy.ALGPHCDMDR.PHCDName   //过敏项目
						s ALGItemRowId=ALGPHCDMDR
						s TagCode="P"
						//s table="PHCDrgMast"
						
					}else{
						s ALGIngredDR=objAllergy.ALGIngredDRGetObjectId()
						if +ALGIngredDR'="0" {
							s ALGItem=objAllergy.ALGIngredDR.INGRDesc   //过敏项目
							s ALGItemRowId=ALGIngredDR
							s TagCode="I"
							//s table="PHCIngredient"
						}
					}
				}
			//}
			if (ALGItem=""){
				;医嘱项ID
				if (objAllergy.ALGExternalID'="")&&(objAllergy.ALGExternalID["||") { 
				  s ALGItemRowId=objAllergy.ALGExternalID
				  s ALGItem=$p($g(^ARCIM(+ALGItemRowId,$p(ALGItemRowId,"||",2),1)),"^",2)   //过敏项目
				}else{
					if (objAllergy.ALGExternalID'=""){
						s ALGItemRowId=objAllergy.ALGExternalID
						s ALGItem=objAllergy.ALGExternalID
					}
				}
			}
										   
			s MRCATDesc=objAllergy.ALGMRCAllTypeDR.MRCATDesc                               //过敏分类描述
			S CategoryRowId=objAllergy.ALGMRCAllTypeDRGetObjectId()						   //过敏分类ID
			s:TagCode'="" MRCATTagDescription=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",TagCode) //过敏类型
			s ALGDate=objAllergy.ALGOnsetDate            //开始日期
			s Comments=##Class(websys.Conversions).LongTextLogicalToHtml(objAllergy.ALGComments,$C(13,10))   //过敏情况补充
			s ALGCheckConflict=$P($g(^PAPER(+ID,"ALG",$P(ID,"||",2),"DHC")),"^",3)
			s ALGCheckConflict=##Class(websys.Conversions).YesNoLogicalToHtml(ALGCheckConflict)
			
		    
		    ;s dataStr= MRCATDesc_"$"_CategoryRowId_"$"_TagCode_"$"_ALGDescCT_"$"_AllergenRowId_"$"_ALGItem_"$"_ALGItemRowId
			;s dataStr= dataStr_"$"_MRCATTagDescription_"$"_table_"$"_ALGDate_"$"_Comments_"$"_$g(ALGCheckConflict)
			
		    ;s nameStr = "MRCATDesc$CategoryRowId$TagCode$ALGDescCT$AllergenRowId$ALGItem$ALGItemRowId"
		    ;s nameStr = nameStr_"dataStr$MRCATTagDescription$table$ALGDate$Comments$ALGCheckConflict"
		    ;W ##class(web.DHCAPPJsonCommon).getJsonData(nameStr,dataStr,"$")
		    /*
		    s %request.Data("ALGMRCCat",1)=MRCATDesc
			s %request.Data("CategoryRowId",1)=CategoryRowId
			s %request.Data("TagCode",1)=TagCode
			s %request.Data("ALGDescCT",1)=ALGDescCT
			s %request.Data("AllergenRowId",1)=AllergenRowId
			s %request.Data("ALGItem",1)=ALGItem
			s %request.Data("ALGItemRowId",1)=ALGItemRowId
			s %request.Data("MRCATTagDescription",1)=MRCATTagDescription //过敏源标志
			//s %request.Data("table",1)=table
			s %request.Data("ALGOnsetDate",1)=ALGDate
			s %request.Data("ALGComments",1)=Comments
			s %request.Data("ALGCheckConflict",1)=$g(ALGCheckConflict)
		    m ^Temp("Upgrade","web.DHCPAAllergy.GetAllergenDetails","%req")=%request.Data
		    */
		    s jsonObj=##class(web.DHCAPPJsonObject).%New()
		   
			d jsonObj.Put("MRCATDesc",MRCATDesc)   						//过敏分类描述
			d jsonObj.Put("CategoryRowId",CategoryRowId) 				//过敏分类Id
			d jsonObj.Put("TagCode",TagCode) 							//过敏类型"I","P"等
			d jsonObj.Put("MRCATTagDescription",MRCATTagDescription)    //过敏类型描述
			d jsonObj.Put("AllergenRowId",AllergenRowId) 				//过敏源ID
			d jsonObj.Put("ALGDescCT",ALGDescCT) 						//过敏源描述
			d jsonObj.Put("ALGItem",ALGItem) 							//过敏项目描述
			d jsonObj.Put("ALGItemRowId",ALGItemRowId) 					//过敏项目ID				
			d jsonObj.Put("table",table) 
			s:ALGDate'="" ALGDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(ALGDate)    //时间转换
			d jsonObj.Put("ALGDate",ALGDate) 							//开始时间
			d jsonObj.Put("Comments",Comments) 							//注释（过敏情况补充）
			d jsonObj.Put("ALGCheckConflict",$g(ALGCheckConflict)) 		//冲突开启标志
			w jsonObj.Json()
		}
	}
	Q ""
}

}
