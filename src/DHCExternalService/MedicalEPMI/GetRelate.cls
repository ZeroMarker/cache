Class DHCExternalService.MedicalEPMI.GetRelate Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 需要的对照关系(外部与当前HIS)如下:
/// 1.证件代码+证件类型			
/// 2.卡类型						
/// 3.性别						
/// 4.病人类型					
/// 5.婚姻状况					
/// 6.民族						
/// 7.职业						
/// 8.邮编省份市					
/// 9.联系人关系					
/// 10.国籍						
/// 根据外部机构以及对应的外部证件代码得到证件类型
/// w ##class(DHCExternalService.MedicalEPMI.GetRelate).GetIDCardType("01","1")
ClassMethod GetIDCardType(BankCode, IDCardType) As %String
{
	;s ^DHCCardInterfaceCodeRelate("IDCardType","01","1")="1" 工行  身份证
	n (BankCode,IDCardType)
	q:IDCardType="" ""
	i BankCode'="" {
		s HisCode=$G(^DHCCardInterfaceCodeRelate("IDCardType",BankCode,IDCardType))
	}else{
		;直接取本地代码
		s IDCardType=$$ALPHAUP^SSUTIL4(IDCardType)
		s HisCode=$O(^PAC("CARD",0,"Code",IDCardType,0))
	}
	q HisCode
}

/// 根据卡类型代码取卡类型RowID
/// w ##class(DHCExternalService.MedicalEPMI.GetRelate).GetHisCardTypeID("01")
ClassMethod GetHisCardTypeID(CardTypeCode As %String = "") As %String
{
	q:CardTypeCode="" ""
	&sql(Select CTD_RowID into :RowId From SQLUser.DHC_CardTypeDef Where CTD_Code=:CardTypeCode)
	Q $g(RowId)
}

/// 得到默认的人员ID
ClassMethod GetUser(ExtUserID As %String) As %String
{
	set myrtn=""
	set myExtUserID=ExtUserID
	if (myExtUserID="") quit myrtn
	set myUserId=$order(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(myExtUserID),0))
	if (myUserId'="") quit myUserId
	quit myrtn
}

}
