Class web.DHCBL.CARD.UCardPatRegDefaultConfing Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod ReadDefaultCardTypeDefine(SessionStr As %String = "") As %String
{
	///读取卡类型定义
	;^DHCCARDTYPEDef(myTypeID)
	i $d(%session) {
		s SessionStr="^"_%session.Get("LOGON.USERID")_"^"_%session.Get("LOGON.CTLOCID")_"^"_%session.Get("LOGON.GROUPID")_"^"_%session.Get("LOGON.HOSPID")_"^"_%session.Get("LOGON.SITECODE")_"^"
	}
	s myDataFlag=0
	s myPEObj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDataObjectBySession(SessionStr)
	if ($IsObject(myPEObj)){
		s myDataFlag=1
	}
	s myDefaultRowID=""
	s mySelFlag=0
	s myTypeID=0
	s mydes=""
	s myval=""
	s myIdx=0
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myval=myTypeID
	.s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.i myDataFlag=1 d
	..s myFindFlag=myPEObj.FindCardTypeByDR(myTypeID)
	..i myPEObj.DefaultCardTypeDR=myTypeID s myDefaultRowID=myTypeID
	.e  d
	..i myDefault="Y" s myDefaultRowID=myTypeID
	
	q myDefaultRowID
}

ClassMethod ReadDefaultSex(HospId As %String = "") As %String
{
	//, HospId As %String = ""
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s HospCodeNode="HospDr_"_HospId
	s DefaultSex=$G(^DHCDocCardConfig(HospCodeNode,"DefaultSex"))
	;^CMC("CMCBM",{CMCBM_RowId})
	;w ##class(web.UDHCOPOtherLB).ReadBankListBroker("","")
	s myDefaultRowID=""
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=0
	f  s myBMRowid=$o(^CT("SEX",myBMRowid)) q:(myBMRowid="")  d
	.s mydes=$p(^CT("SEX",myBMRowid),"^", 2)
	.s myval=myBMRowid
	.s myval=myval_"^"_$p(^CT("SEX",myBMRowid),"^", 1)
	.i DefaultSex=myBMRowid d 
	..s mySelFlag=1
	..s myDefaultRowID=myBMRowid
	.e  d
	..s mySelFlag=0
	.s myIdx=+myIdx+1
	
	q myDefaultRowID
}

ClassMethod ReadDefaultCredTypeExp(CardTypeID = "") As %String
{
	;读取 PAC_CardType and DHC_CredType  相互之间的数据
	;^CMC("CMCBM",{CMCBM_RowId})
	;w ##class(web.UDHCOPOtherLB).ReadCredTypeExp("","")
	;因新增了卡类型证件类型关联，所以需判断是否有默认
	s (CTDCredTypeListStr,CTDCredTypeDefault)=""
    if CardTypeID'=""{
        s CTDCredTypeListStr=$p($g(^DHCCARDTYPEDef(CardTypeID)),"^",43)
        s CTDCredTypeDefault=$p($g(^DHCCARDTYPEDef(CardTypeID)),"^",44)
    }
	
	s myDefaultRowID=""
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=1
	;^PAC("CARD",{CRT_RowID})
	f  s myBMRowid=$o(^PAC("CARD",myBMRowid)) q:(myBMRowid="")  d
	.s active=$p($g(^PAC("CARD",myBMRowid,"DHC")),"^",1)
	.q:active'="Y"
	.s def=$p($g(^PAC("CARD",myBMRowid, "DHC")),"^",2)
	.s mydes=$p(^PAC("CARD",myBMRowid),"^", 2)		;Desc
	.s myval=myBMRowid
	.s myval=myval_"^"_$p(^PAC("CARD", myBMRowid),"^", 1)		;Code
	.i (def="Y")&&(CTDCredTypeDefault="") d
	..s mySelFlag=1
	..s myDefaultRowID=myBMRowid
	.e  d
	..s mySelFlag=0
    ..i CTDCredTypeDefault=myBMRowid d
    ...s mySelFlag=1
	...s myDefaultRowID=myBMRowid
	
	q myDefaultRowID
}

ClassMethod ReadDefaultPatType(SessionStr As %String = "") As %String
{
	;CT_SocialStatus
	;w ##class(web.UDHCOPOtherLB).ReadPatType()
	i $d(%session) {
		s SessionStr="^"_%session.Get("LOGON.USERID")_"^"_%session.Get("LOGON.CTLOCID")_"^"_%session.Get("LOGON.GROUPID")_"^"_%session.Get("LOGON.HOSPID")_"^"_%session.Get("LOGON.SITECODE")_"^"
	}
	s myDataFlag=0
	s myPEObj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDataObjectBySession(SessionStr)
	if ($IsObject(myPEObj)){
		s myDataFlag=1
	}
	
	s myDefaultRowID=""
	s myBMRowid=0
	s mydes=""
	s myval=""
	s myIdx=0
	f  s myBMRowid=$o(^CT("SS",myBMRowid)) q:(myBMRowid="")  d
	.s mydes=$p(^CT("SS",myBMRowid),"^", 2)
	.s myval=myBMRowid
	.s myval=myval_"^"_$p(^CT("SS",myBMRowid),"^", 1)		;
	.i myDataFlag=1 d
	..s myFindFlag=myPEObj.FindPatTypeByDR(myBMRowid)
	..i myPEObj.DefaultPatTypeDR=myBMRowid s myDefaultRowID=myBMRowid
	.e  d
	..i mydes="自费" s myDefaultRowID=myBMRowid
	
	q myDefaultRowID
}

ClassMethod ReadDefaultPayMode(gGroupID As %String = "") As %String
{
	;^CMC("CMCBM",{CMCBM_RowId})
	;w ##class(web.UDHCOPOtherLB).ReadBankListBroker("","")
	s myDefaultRowID=""
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=0
	s myGSRowID=$o(^DHCOPGSi("GS",0,"GSDR",gGroupID,0))
	q:myGSRowID="" "-1"
	f  s myBMRowid=$o(^DHCOPGS("GS",myGSRowID,"PM",myBMRowid)) q:(myBMRowid="")  s str=^(myBMRowid) d
	.s def=$p(str,"^",4)
	.;q:def'="Y"
	.s paymodedr=$p(str,"^",1)
	.q:paymodedr=""
	.q:'$d(^CT("CTPM",paymodedr))
	.s paymodecode=$p(^CT("CTPM",paymodedr),"^",1)
	.q:paymodecode="CPP"
	.s RPFlag=$p(str,"^",6)
	.s mydes=$p(^CT("CTPM",paymodedr),"^",2)
	.s myval=paymodedr
	.s myval=myval_"^"_paymodecode_"^"_RPFlag
	.i def="Y" d 
	..s mySelFlag=1
	..s myDefaultRowID=paymodedr
	.e  d
	..s mySelFlag=0
	
	q myDefaultRowID
}

}
