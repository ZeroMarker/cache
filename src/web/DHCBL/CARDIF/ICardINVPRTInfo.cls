Class web.DHCBL.CARDIF.ICardINVPRTInfo Extends (%RegisteredObject, %XML.Adaptor, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 54;

/// /提供一个发票重打功能
/// /注意：  此处不涉及到收回钱的功能， 
/// /一定会产生一个负发票和正发票
/// /票据作废重打功能
ClassMethod CardINVParkRePrint(CardINVRowID As %String, UserDR As %String, CardINVInfo As %String, CardTypeDR As %String, sFlag As %String, CardRowID As %String, ExpStr As %String) As %String
{
	n (CardINVRowID, UserDR, CardINVInfo, CardTypeDR, sFlag, CardRowID, ExpStr)
	;如果集中收费， 需要单独设置 GC
	;如果是对应卡收费，  找原来的卡类型设置 PC
	
	s ^TMPCARDINVPRePrint=$lb(CardINVRowID, UserDR, CardINVInfo, CardTypeDR, sFlag,CardRowID, ExpStr)
	
	s myrtn=0
	s myNewINVRowID=""
	s myExpStr=""
	
	s myrtnval=##class(web.DHCBL.CARD.UCardINVBuilder).CardINVParkRePrint(CardINVRowID, UserDR , CardINVInfo, CardTypeDR, sFlag, CardRowID, myExpStr)
	
	s myrtn=$p(myrtnval,"^",1)
	s myNewINVRowID=$p(myrtnval,"^",2)
	
	q myrtn_$c(1)_myNewINVRowID
}

/// 获取卡发票的信息
ClassMethod GetCardINVInfo(ReceiptNo As %String, ExpStr As %String) As %String
{
	;w ##class(web.DHCBL.CARDIF.ICardINVPRTInfo).GetCardINVInfo("000002")
	n (ReceiptNo, ExpStr)
	s myrtn=0
	s myrtn=##class(web.DHCBL.CARD.UCardINVPRTInfo).GetCardINVInfo(ReceiptNo)
	;b	;
	q myrtn
}

/// 集团注册收费
ClassMethod GroupRegCharge(ConfigInfo As %String, CardINVInfo As %String, SepcialInfo As %String, GRIRowID As %String, ExpStr As %String) As %String
{
	;w ##class(web.DHCBL.CARDIF.ICardINVPRTInfo).GroupRegCharge()
	n (ConfigInfo, CardINVInfo, SepcialInfo, GRIRowID, ExpStr)
	s ^TMPGroupRegCharge=$lb(ConfigInfo, CardINVInfo, SepcialInfo, GRIRowID, ExpStr)
	
	s myrtn=0
	
	s myrtn=##class(web.DHCBL.CARD.UCardINVPRTInfo).GroupRegCharge(ConfigInfo, CardINVInfo, SepcialInfo, GRIRowID, ExpStr)
	s myCardINVRowID=$p(myrtn,"^",2)
	
	s myrtn=+myrtn
	
	q myrtn_$c(1)_myCardINVRowID
}

ClassMethod ReadReceiptNOForCard(itmjs As %Library.String = "", itmjsex As %Library.String = "", UserDR As %String, CardTypeDR As %String, ExpStr As %Library.String = "") As %String
{
	;w ##class(web.DHCBL.CARDIF.ICardINVPRTInfo).ReadReceiptNOForCard()
	;web.DHCBL.CARD.UCardINVPRTInfo
	
	n (itmjs, itmjsex, UserDR, CardTypeDR, ExpStr)
	
	s myGroupDR=""
	s myVer=##class(web.DHCOPConfig).GetVersion()
	s myClsName="web.DHCBL.CARD.UCardINVPRTInfo"_myVer
	s myflag=##class(websys.Conversions).IsValidMethodName(myClsName,"ReadReceiptNOForCard")
	if (myflag)
	{
		s myrtn= $ZOBJCLASSMETHOD(myClsName, "ReadReceiptNOForCard", itmjs, itmjsex, UserDR, CardTypeDR, myGroupDR)
	}else
	{
		s myrtn=##class(web.DHCBL.CARD.UCardINVPRTInfo).ReadReceiptNOForCard(itmjs, itmjsex, UserDR, CardTypeDR, myGroupDR)
	}
	
	q +myrtn
}

ClassMethod ReadReceiptNOForGroupCharge(itmjs As %Library.String = "", itmjsex As %Library.String = "", UserDR As %String, CardTypeDR As %String, GroupDR As %String) As %String
{
	n (itmjs, itmjsex, UserDR, CardTypeDR, ExpStr)
	
	s myGroupDR=""
	s myVer=##class(web.DHCOPConfig).GetVersion()
	s myClsName="web.DHCBL.CARD.UCardINVPRTInfo"_myVer
	s myflag=##class(websys.Conversions).IsValidMethodName(myClsName,"ReadReceiptNOForGroupCharge")
	if (myflag)
	{
		s myrtn= $ZOBJCLASSMETHOD(myClsName, "ReadReceiptNOForGroupCharge", itmjs, itmjsex, UserDR, CardTypeDR, myGroupDR)
	}else
	{
		s myrtn=##class(web.DHCBL.CARD.UCardINVPRTInfo).ReadReceiptNOForGroupCharge(itmjs, itmjsex, UserDR, CardTypeDR, myGroupDR)
	}
	
	q +myrtn
}

ClassMethod RPTest()
{
	;$lb(CardINVRowID,     )
	;w ##class(web.DHCBL.CARDIF.ICardINVPRTInfo).RPTest()
	s CardINVRowID=$LIST($g(^TMPCARDINVPRePrint),1)
	s UserDR=$LIST($g(^TMPCARDINVPRePrint),2)
	s CardINVInfo =$LIST($g(^TMPCARDINVPRePrint),3)
	s CardTypeDR =$LIST($g(^TMPCARDINVPRePrint),4)
	s sFlag=$LIST($g(^TMPCARDINVPRePrint),5)
	s ExpStr=$LIST($g(^TMPCARDINVPRePrint),6)
	;s SepcialInfo=$LIST($g(^TMPCARDINVPRePrint),7)
	;s ExpStr =$LIST($g(^TMPCARDINVPRePrint),8)
	s myrtn=..CardINVParkRePrint(CardINVRowID, UserDR, CardINVInfo, CardTypeDR, sFlag, ExpStr)
	
	q myrtn
}

}
