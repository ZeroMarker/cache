Import SQLUser

/// Creator: 	yangyongtao
/// CreateDate: 2017-05-12
/// Descript: 	获取过敏信息
Class web.DHCSTPHCMALLERGYLIST Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 获取过敏信息
/// Creator: 	yangyongtao
/// CreateDate: 2016-12-27
/// Table: 		 PA_Allergy
/// Input:  	 病人登记号
/// Return： 	 过敏结果信息
/// Others:		 w ##class(web.DHCSTPHCMALLERGYLIST).QueryAllergyList(10,1,"0000000001")
ClassMethod QueryAllergyList(offet, limit, PatientID) As %GlobalCharacterStream
{
	
	n (offet,limit,PatientID)
	S End = limit+offet
	S Start = limit+1
    S count=0,h=0
    s OutBinStream=##Class(%GlobalCharacterStream).%New()
    Q:PatientID="" "{""rows"":[],""total"":"_count_"}"
    //S PatientID=$o(^PAPERi("PAPMI_PatNo",(RegNo),""))
    Q:PatientID="" "{""rows"":[],""total"":"_count_"}"
	d OutBinStream.Write("[")  //输出json前缀串
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
	..s:OnsetDate'="" OnsetDateText=$zd(OnsetDate,3) ;=##Class(websys.Conversions).DateLogicalToHtml(OnsetDate)_OnsetDateFreeText
	..;医护人员 组件里没有使用
	..s CareProvider=objAllergy.ALGCTPCPDR
	..;未激活标志
	..s InActive=objAllergy.ALGInActive
	..;使用不明
	..s RowHexColour=""
	..s SeverityColour=""
	..s HiddenFields=""
	..s LastUpdateDate=objAllergy.ALGLastUpdateDate
	..s:LastUpdateDate'="" LastUpdateDate=$zd(LastUpdateDate,3)
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
	..S count=count+1
	..Q:count<Start
	..Q:count>End
	..I count=Start D
	...d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData("RowID^Category^Allergen^ALGItem^NatureOfReaction^Severity^SeverityColour^OnsetDate^OnsetDateFreeText^CareProvider^InActive^OnsetDateText^RowHexColour^LastUpdateDate^LastUpdateTime^LastUpdateUser^LastUpdateHospital^Status^ExternalID^LastUpdateUserRole^LastUpdateUserId^Comments^ALGFreeTextAllergy^DrugSpecific^tag^ALGDSReportFlag^HiddenFields",TempStr,"^"))
	..e  d
	...d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData("RowID^Category^Allergen^ALGItem^NatureOfReaction^Severity^SeverityColour^OnsetDate^OnsetDateFreeText^CareProvider^InActive^OnsetDateText^RowHexColour^LastUpdateDate^LastUpdateTime^LastUpdateUser^LastUpdateHospital^Status^ExternalID^LastUpdateUserRole^LastUpdateUserId^Comments^ALGFreeTextAllergy^DrugSpecific^tag^ALGDSReportFlag^HiddenFields",TempStr,"^"))
	d OutBinStream.Write("]")   //输出json结尾符
	//D OutBinStream.OutputToDevice()
    Q OutBinStream
}

}
