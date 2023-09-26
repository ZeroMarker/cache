/// 发票操作的逻辑流程
Class web.DHCBL.CARD.UCardINVBuilder Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod CardINVParkRePrint(CardINVRowID As %String, UserDR As %String, CardINVInfo As %String, CardTypeDR As %String, sFlag As %String, CardRowID As %String, ExpStr As %String) As %String
{
	s myrtn=0
	s myNewINVRowID=""
	
	ts
	
	s myCurDate=+$h
	s myCurTime=$p($h,",",2)
	
	;作废原发票
	s myrtn=##class(web.DHCBL.CARD.UCardINVPRTInfo).CardINVPark(CardINVRowID, UserDR, sFlag)
	b	;作废原发票
	;INVRowID, UserDR, sFlag, CurDate, CurTime
	;产生负票
	i +myrtn=0 d
	.s myval=##class(web.DHCBL.CARD.UCardINVPRTInfo).CardINVCancel(CardINVRowID, UserDR,sFlag,myCurDate, myCurTime)
	.s myrtn=+$p(myval,"^",1)
	.s myParkRowID=$p(myval,"^",2)
	
	b	;产生负票
	
	;写负支付模式
	i +myrtn=0 d
	.s myExpStr=""
	.s myrtn=##class(web.DHCBL.CARD.UCardINVPRTInfo).CardINVCancelPayMode(CardINVRowID, myParkRowID, myCurDate, myCurTime, myExpStr)
	
	b	;写负支付模式
	;生成正发票
	i +myrtn=0 d
	.;UseINVType, PrtINVFlag, FareType, ExpStr
	.s myPAPMI=$p(^DHCCARDINVPRT(CardINVRowID),"^", 1)
	.i myPAPMI="" d
	..;集团收费
	..s myUseINVType="L"
	..s PrtINVFlag="Y"
	..s FareType="C"
	.e  d
	..;个人收费
	..;CardTypeDR
	..s myUseINVType=$p($g(^DHCCARDTYPEDef(CardTypeDR)),"^",5)		;
	..s PrtINVFlag=$p($g(^DHCCARDTYPEDef(CardTypeDR)),"^",4)		;
	..s FareType=$p($g(^DHCCARDTYPEDef(CardTypeDR)),"^",3)		;
	.s CardINVObj=##class(web.DHCEntity.PCA.CardINVPRT).%New()
	.d CardINVObj.XMLDeserialize(.CardINVObj, CardINVInfo)
	.s CardINVObj.Date=+myCurDate
	.s CardINVObj.Time=+myCurTime
	.s CardINVObj.Flag="N"
	.s myrtn=##class(web.DHCBL.CARD.UCardINVPRTInfo).InsertCardINV(CardINVObj, myUseINVType, PrtINVFlag, FareType, ExpStr)
	.s myNewINVRowID=$p(myrtn,"^",2)
	.s myrtn=$p(myrtn,"^",1)
	.d CardINVObj.%Close()
	.
	
	b	;生成正发票
	
	;把正发票的RowID更新到发的卡中
	i +myrtn=0 d
	.s myrtn=##class(web.DHCBL.CARD.UCardRefInfo).UpdateCardINVInfo(CardRowID,myNewINVRowID)
	
	b	;;Tro
	
	if (+myrtn=0) d
	.tc
	e  d
	.tro
	
	q myrtn_"^"_myNewINVRowID
}

}
