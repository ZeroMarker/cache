Class DHCExternalService.RegInterface.GetRelate Extends DHCDoc.Util.RegisteredObject
{

/// 根据外部医院代码得到HIS中的医院ID
ClassMethod GetHISHospitalIdFromOuterCode(HospitalOutCode As %String, ScheduleItemId As %String = "") As %String
{
	s HISHospitalId=""
	if ScheduleItemId'=""{
		s HISHospitalId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp("","",ScheduleItemId,""),"^",1)
	}
	if HISHospitalId=""{
		if HospitalOutCode=""{
			s HISHospitalId=..GetHospital()
		}else{
			s HISHospitalId=$o(^CT("HOSP",0,"Code",HospitalOutCode,""))
		}
	}
	
	Q HISHospitalId
}

/// 根据HIS中的医院ID得到外部医院代码
ClassMethod GetOuterHospitalCodeFromHISId(HospitalId As %String) As %String
{
	quit:HospitalId="" ""
	quit $Get(^DHCRegInterfaceCodeRelate("HospitalId","Outer",HospitalId))
}

/// 根据平台传入的卡类型代码得到HIS的卡类型ID
/// w ##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID("")
ClassMethod GetHisCardTypeID(CardTypeCode As %String = "", BankCode As %String = "", Bindflag As %String = "", HospId As %String = "") As %String
{
	if CardTypeCode=""{
		s CardTypeCode=##class(DHCDoc.Interface.Outside.Config).GetDefaultDataNew("CardType",HospId)
	}
	i BankCode'="" {
		if (Bindflag'="")
		{
			q:$G(^DHCCardInterfaceCodeRelate("CardType",BankCode,Bindflag))'="" $G(^DHCCardInterfaceCodeRelate("CardType",BankCode,Bindflag)) 
			q $G(^DHCCardInterfaceCodeRelate("CardType",BankCode))
		}
		else
		{
			s CompareData=##class(web.DHCDocTextDicDataCtl).GetCompareData("CardType",CardTypeCode,"",BankCode)
			s CompareDataID=$p(CompareData,"^",1)
			Q CompareDataID
		}
	}else{
		q:CardTypeCode="" ""
		&sql(Select CTD_RowID into :RowId From SQLUser.DHC_CardTypeDef Where CTD_Code=:CardTypeCode)
		Q $g(RowId)
	}
}

/// 根据平台支付方式代码得到HIS需要的支付方式ID
/// w ##class(DHCExternalService.RegInterface.GetRelate).GetHisPayModeID("CASH","1")
ClassMethod GetHisPayModeID(PayModeCode, BankCode As %String = "")
{
	q:PayModeCode="" ""
	s HisCode=##class(DHCExternalService.RegInterface.GetRelate).GetCompareData("PayMode",PayModeCode,BankCode)
	q HisCode
}

/// 根据卡类型ID得到外部接口需要的卡类型信息
/// w ##class(DHCExternalService.RegInterface.GetRelate).GetOuterCardType(1,1)
ClassMethod GetOuterCardType(BankCode, CardTypeID As %String = "") As %String
{
	Q:CardTypeID="" ""
	s CompareData=..GetCompareOutData("CardTypeOut",CardTypeID,BankCode)
	Q CompareData
}

/// 根据时段ID得到外部机构需要的时段代码
/// w ##class(DHCExternalService.RegInterface.GetRelate).GetOuterTimeRangeCode(1)
ClassMethod GetOuterTimeRangeCode(TimeRangeID, BankCode As %String = "")
{
	q:TimeRangeID="" ""
	s CompareData=..GetCompareOutData("TimeRangeOut",TimeRangeID,BankCode)
	Q CompareData
}

/// 根据患者类型ID得到外部机构需要的患者类型
/// w ##class(DHCExternalService.RegInterface.GetRelate).GetOuterCredTypeCode(1)
ClassMethod GetOuterPatTypeCode(PatTypeID, BankCode As %String = "")
{
	q:PatTypeID="" ""
	s CompareData=..GetCompareOutData("PatTypeOut",PatTypeID,BankCode)
	Q CompareData
}

/// 根据证件ID得到外部机构需要的证件代码
/// w ##class(DHCExternalService.RegInterface.GetRelate).GetOuterCredTypeCode(1)
ClassMethod GetOuterCredTypeCode(CredTypeID, BankCode As %String = "")
{
	q:CredTypeID="" ""
	s CompareData=..GetCompareOutData("CredTypeOut",CredTypeID,BankCode)
	Q CompareData
}

/// 根据性别ID得到外部机构需要的性别代码
/// w ##class(DHCExternalService.RegInterface.GetRelate).GetOuterSexCode(1)
ClassMethod GetOuterSexCode(SexID, BankCode As %String = "")
{
	q:SexID="" ""
	s CompareData=..GetCompareOutData("SexOut",SexID,BankCode)
	Q CompareData
}

/// 根据支付方式ID得到外部机构需要的支付方式代码
/// w ##class(DHCExternalService.RegInterface.GetRelate).GetOuterPayModeCode(1)
ClassMethod GetOuterPayModeCode(PayModeID, BankCode As %String = "")
{
	q:PayModeID="" ""
	s CompareData=..GetCompareOutData("PayModeOut",PayModeID,BankCode)
	Q CompareData
}

/// 根据客户端类型获取his预约方式
ClassMethod GetApptMethodCode(ClientType)
{
	//zw ^RBC("APTM")
	q:ClientType="" ""
	q $G(^DHCRegInterfaceCodeRelate("ApptMethod","His",ClientType))
}

/// 得到默认的人员ID
/// w ##class(DHCExternalService.RegInterface.GetRelate).GetUser(1)
ClassMethod GetUser(ExtUserID, BankCode As %String = "", HospId As %String = "")
{
	set myrtn=""
	if ExtUserID=""{
		s ExtUserID=##class(DHCDoc.Interface.Outside.Config).GetDefaultDataNew("ExtUserID",HospId) ;$g(^DHCRegInterfaceCodeRelate("Default","ExtUserID"))
	}
	set myExtUserID=ExtUserID
	if (myExtUserID="") quit myrtn
	set myUserId=$order(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(myExtUserID),0))
	if (myUserId'="") quit myUserId
	quit myrtn
}

/// 得到默认的安全组
/// w ##class(DHCExternalService.RegInterface.GetRelate).GetGroup(1)
ClassMethod GetGroup(ExtUserID)
{
	s Group=$p($g(^SSU("SSUSR",ExtUserID)),"^",5) 
	q Group
}

/// 得到默认的医院
/// w ##class(DHCExternalService.RegInterface.GetRelate).GetHospital()
ClassMethod GetHospital()
{
	s HospitalID=0
	s HospitalID=$o(^CT("HOSP",HospitalID))
	q HospitalID
}

/// 得到默认的登录科室
ClassMethod GetLoc(ExtUserID)
{
	s DefaultLoc=$p($g(^SSU("SSUSR",ExtUserID)),"^",4) 
	q DefaultLoc
}

/// 得到病历本费
ClassMethod GetBookFee()
{
	q 1
}

/// 得到默认的收费类别
ClassMethod GetAdmReason(HospId As %String = "")
{
	s AdmReason=##class(DHCDoc.Interface.Outside.Config).GetDefaultDataNew("AdmReason",HospId)
	q AdmReason
}

/// 取挂号时特殊科室收的特殊费用
ClassMethod GetOtherFee(CTLocDr As %String = "", AdmDate As %String = "", AdmReason As %String = "", Arcim As %String = "") As %String
{
	quit 0
	set OtherFee=0
	if (AdmReason="") set AdmReason=..GetAdmReason()
	if (AdmDate="") set AdmDate=..%SysDate()
	if (CTLocDr)="144" set OtherFee=+$p(##Class(web.UDHCJFPRICE).GetOrderPrice("",AdmReason,"2142||1",AdmDate,"","","",""),"^",4)            //医大一院门诊眼科加收裂隙灯费
	quit OtherFee
}

/// 根据证件号取病人ID，尽量验证病人姓名及移动电话
ClassMethod GetPatIDByDVA(DVA As %String, DVATypeCode As %String, Name As %String = "", TelePhoneNo As %String = "") As %String
{
	q:(DVA="") "证件号为空"
	q:(DVATypeCode="") "证件类型为空"
	//q:(Name="") "病人姓名为空"
	//q:(MobileNo="") "移动电话为空"
	s PersonRowId=0
	s PatID=""
	f  s PersonRowId=$o(^PAPERi("DVA",$ZCVT(DVA,"U"),PersonRowId)) q:PersonRowId=""  d
	.s PatCredTypeDr=$p($g(^PAPER(PersonRowId,"PAT",3)),"^",7)
	.s PatCredTypeCode=$p(^PAC("CARD",PatCredTypeDr),"^",1)
	.s PatName=$p($g(^PAPER(PersonRowId,"ALL")),"^",1)
	.s PatTelePhoneNo=$p($g(^PAPER(PersonRowId,"PER",1)),"^",11)
	.q:(PatCredTypeCode'=DVATypeCode)
	.q:((Name'="")&&(Name'=PatName))
	.q:((TelePhoneNo'="")&&(PatTelePhoneNo'=TelePhoneNo))
	.s PatID=PersonRowId
	q 0_"^"_PatID
}

/// d ##class(DHCExternalService.RegInterface.GetRelate).SetDefaultData(^tmpnk("SetDefaultData"))
ClassMethod SetDefaultData(Coninfo)
{
	s ^tmpnk("SetDefaultData")=Coninfo
	s ConNum=$l(Coninfo,$C(2))
	f i=1:1:ConNum  d
	.s evNoteinfo=$p(Coninfo,$C(2),i)
	.i evNoteinfo'="" d
	..s Node=$p(evNoteinfo,$C(1),1)
	..s Info=$p(evNoteinfo,$C(1),2)
	..s ^DHCRegInterfaceCodeRelate("Default",Node)=Info
	q 0
	

	;平台->His支付方式ID
	;SELECT * FROM ct_paymode
	/*s ^DHCRegInterfaceCodeRelate("PayMode","TOHis","CASH")=1
	s ^DHCRegInterfaceCodeRelate("PayMode","TOHis","CPP")=3
	;s ^DHCRegInterfaceCodeRelate("PayMode","TOHis","ZFB")=45
	;s ^DHCRegInterfaceCodeRelate("PayMode","TOHis","WX")=44	
	
	;His支付方式ID->平台
	s ^DHCRegInterfaceCodeRelate("PayMode","TOOuter","1")="CASH"
	s ^DHCRegInterfaceCodeRelate("PayMode","TOOuter","CASH")="CASH"
	s ^DHCRegInterfaceCodeRelate("PayMode","TOOuter","3")="CPP"
	s ^DHCRegInterfaceCodeRelate("PayMode","TOOuter","CPP")="CPP"
	
	;平台->His的卡类型
	;SELECT * FROM DHC_CardTypeDef
	s ^DHCCardInterfaceCodeRelate("CardType","TOHis","02")=2
	s ^DHCCardInterfaceCodeRelate("CardType","TOHis","01")=1
	
	;平台->His的性别
	;SELECT * FROM DHC_CardTypeDef
	s ^DHCCardInterfaceCodeRelate("SexCode","TOHis","男")=1
	s ^DHCCardInterfaceCodeRelate("SexCode","TOHis","女")=2
	s ^DHCCardInterfaceCodeRelate("SexCode","TOHis","0")=3
	s ^DHCCardInterfaceCodeRelate("SexCode","TOHis","9")=3
	s ^DHCCardInterfaceCodeRelate("SexCode","TOHis","M")=1
	s ^DHCCardInterfaceCodeRelate("SexCode","TOHis","F")=2*/
}

/// Desc:根据外部机构取对外接口文本字段对照配置数据，外部机构对照His数据，未配置则直接取His
/// Input:Code 	Sex 		性别
/// 			IDCardType 	证件类型
/// 			PatType 	患者类型
/// 			Marital 	婚姻
/// 			Nation		民族
/// 			Occupation	职业
/// 			Relation	关系
/// 			Nationality	国籍
/// 			PayMode		支付方式
/// debug: w ##class(DHCExternalService.RegInterface.GetRelate).GetCompareData("Relation","","")
ClassMethod GetCompareData(Code As %String, Value As %String, ExrOrg As %String)
{
	s HisCode=""
	q:Value="" HisCode
	i ExrOrg'="" {
		s CompareData=##class(web.DHCDocTextDicDataCtl).GetCompareData(Code,Value,"",ExrOrg)
		s HisCode=$p(CompareData,"^",1)
	}
	if HisCode=""{
		;直接取本地代码
		s Value=$$ALPHAUP^SSUTIL4(Value)
		if Code="Sex"{
			s HisCode=$O(^CT("SEX",0,"Code",Value,0))
		}elseif Code="IDCardType"{
			s HisCode=$O(^PAC("CARD",0,"Code",Value,0))
		}elseif Code="PatType"{
			s HisCode=$O(^CT("SS",0,"Code",Value,0))
		}elseif Code="Marital"{
			s HisCode=$O(^CT("MAR",0,"Code",Value,0))
		}elseif Code="Nation"{
			s HisCode=$O(^CT("NAT",0,"Code",Value,0))
		}elseif Code="Occupation"{
			s HisCode=$O(^CT("OCC",0,"Code",Value,0))
		}elseif Code="Relation"{
			s HisCode=$O(^CT("RLT",0,"Code",Value,0))
		}elseif Code="Nationality"{
			s HisCode=$O(^CT("COU",0,"Code",Value,0))
		}elseif Code="PayMode"{
			s HisCode=$O(^CT("CTPM",0,"Code",Value,0))
		}else{
			s HisCode=""	
		}
	}
	s HisCode=..CheckHisCode(HisCode,Code)
	Q HisCode
}

ClassMethod CheckHisCode(HisCode As %String, Code As %String) As %String
{
	Q:HisCode="" HisCode
	if Code="Sex"{
		Q:'$d(^CT("SEX",HisCode)) ""
		s CTSEXDateFrom=$p($g(^CT("SEX",HisCode)),"^",4)
		Q:(CTSEXDateFrom'="")&&(CTSEXDateFrom>+$h) ""
		s CTSEXDateTo=$p($g(^CT("SEX",HisCode)),"^",5)
		Q:(CTSEXDateTo'="")&&(CTSEXDateTo<+$h) ""
	}elseif Code="IDCardType"{
		Q:'$d(^PAC("CARD",HisCode)) ""
		s CARDDateFrom=$p($g(^PAC("CARD",HisCode)),"^",3)
		Q:(CARDDateFrom'="")&&(CARDDateFrom>+$h) ""
		s CARDDateTo=$p($g(^PAC("CARD",HisCode)),"^",4)
		Q:(CARDDateTo'="")&&(CARDDateTo<+$h) ""
	}elseif Code="Marital"{
		Q:'$d(^CT("MAR",HisCode)) ""
		s CTMARDateFrom=$p($g(^CT("MAR",HisCode)),"^",4)
		Q:(CTMARDateFrom'="")&&(CTMARDateFrom>+$h) ""
		s CTMARDateTo=$p($g(^CT("MAR",HisCode)),"^",5)
		Q:(CTMARDateTo'="")&&(CTMARDateTo<+$h) ""
	}elseif Code="Occupation"{
		Q:'$d(^CT("OCC",HisCode)) ""
		s CTOCCDateFrom=$p($g(^CT("OCC",HisCode)),"^",3)
		Q:(CTOCCDateFrom'="")&&(CTOCCDateFrom>+$h) ""
		s CTOCCDateTo=$p($g(^CT("OCC",HisCode)),"^",4)
		Q:(CTOCCDateTo'="")&&(CTOCCDateTo<+$h) ""
	}elseif Code="Relation"{
		Q:'$d(^CT("RLT",HisCode)) ""
		s CTRLTDateFrom=$p($g(^CT("RLT",HisCode)),"^",3)
		Q:(CTRLTDateFrom'="")&&(CTRLTDateFrom>+$h) ""
		s CTRLTDateTo=$p($g(^CT("RLT",HisCode)),"^",4)
		Q:(CTRLTDateTo'="")&&(CTRLTDateTo<+$h) ""
	}elseif Code="Nationality"{
		Q:'$d(^CT("COU",HisCode)) ""
		s CTCOUDateActiveFrom=$p($g(^CT("COU",HisCode)),"^",4)
		Q:(CTCOUDateActiveFrom'="")&&(CTCOUDateActiveFrom>+$h) ""
		s CTCOUDateActiveTo=$p($g(^CT("COU",HisCode)),"^",5)
		Q:(CTCOUDateActiveTo'="")&&(CTCOUDateActiveTo<+$h) ""
	}elseif Code="PayMode"{
		Q:'$d(^CT("CTPM",HisCode)) ""
		s CTPMDateFrom=$p($g(^CT("CTPM",HisCode)),"^",5)
		Q:(CTPMDateFrom'="")&&(CTPMDateFrom>+$h) ""
		s CTPMDateTo=$p($g(^CT("CTPM",HisCode)),"^",6)
		Q:(CTPMDateTo'="")&&(CTPMDateTo<+$h) ""
	}
	Q HisCode
}

/// Desc:根据外部机构取对外接口文本字段对照配置，His对照外部机构数据，未配置则直接取His
/// Input:Code 	SexOut 			性别
/// 			CardTypeOut		卡类型
/// 			CredTypeOut 	证件类型
/// 			PatTypeOut 		患者类型
/// 			PayModeOut		支付方式
/// 			TimeRangeOut 	时段
/// debug: w ##class(DHCExternalService.RegInterface.GetRelate).GetCompareOutData("PayModeOut","22","")
ClassMethod GetCompareOutData(Code As %String, Value As %String, ExrOrg As %String)
{
	s OutData=""
	q:Value="" OutData
	i ExrOrg'="" {
		s OutData=##class(web.DHCDocTextDicDataCtl).GetCompareData(Code,Value,"N",ExrOrg)
	}
	if OutData=""{
		s (HisCode,HisDesc)=""
		if Code="CardTypeOut"{
			s HisCode=$P($g(^DHCCARDTYPEDef(+Value)),"^",1)
			s HisDesc=$P($g(^DHCCARDTYPEDef(+Value)),"^",2)
		}elseif Code="SexOut"{
			s HisCode=$P($g(^CT("SEX",+Value)),"^",1)
			s HisDesc=$P($g(^CT("SEX",+Value)),"^",2)
		}elseif Code="CredTypeOut"{
			s HisCode=$P($g(^PAC("CARD",+Value)),"^",1)
			s HisDesc=$P($g(^PAC("CARD",+Value)),"^",2)
		}elseif Code="PatTypeOut"{
			s HisCode=$P($g(^CT("SS",+Value)),"^",1)
			s HisDesc=$P($g(^CT("SS",+Value)),"^",2)
		}elseif Code="PayModeOut"{
			s HisCode=$P($g(^CT("CTPM",+Value)),"^",1)
			s HisDesc=$P($g(^CT("CTPM",+Value)),"^",2)
		}elseif Code="TimeRangeOut"{
			s HisCode=$P($g(^DHCTimeRange(+Value)),"^",1)
			s HisDesc=$P($g(^DHCTimeRange(+Value)),"^",2)
		}
		s OutData=HisCode_"^"_HisDesc
	}
	
	Q OutData
}

}
