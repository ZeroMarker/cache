/// 
Class web.UDHCAccManageCLS12 Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

ClassMethod AccCallBack(AccRowID As %String, UserDR As %String, CardInfo As %String, CompIP As %String, CardRowID As %String, CardTypeDR As %String, ExpStr As %String) As %String
{
	;原则：账户的复原
	;AccRowID  :原账户RowID
	;CardInfo  ：新发卡的信息
	;CompIP    ：计算机名称
	;ExpStr    ：
	;ExpStr 组成：  CardRowID^
	;w ##class(web.UDHCAccManageCLS0).AccCallBack(AccRowID, UserDR, CardInfo, CompIP, ExpStr)
	;1.结算账户复原，使账户能够重新使用
	;2.重新发卡，因为原来的卡已经回收；
	;2.1 如果卡被收回这个逻辑是对的
	;退完费用后，操作员重新
	n (AccRowID, UserDR, CardInfo, CompIP, CardRowID, CardTypeDR, ExpStr)
	
	tstart
	
	;更新账户状态，使账户信息Foot状态-->正常状态
	s myExpStr=""
	s rtn=##class(web.UDHCAccManageCLS).AccCallBack(AccRowID, UserDR, myExpStr)
	
	;写入账户日志
	;(accid As %String, oldstatus As %String, newstatus As %String, userid As %String, IP As %String, RLinfo As %String)
	i +rtn=0 d
	.s rtn=##class(web.UDHCAccManageCLS).AccountStatusRecord(AccRowID,"结算","正常",UserDR,CompIP,"")
	
	s myCardINVRowID=""
	if ((+rtn=0)&&(CardRowID="")){
		;纪录卡费用额
		s myCardTypeDR=$p(CardInfo,"^",11)
		s myFareType=$p(^DHCCARDTYPEDef(myCardTypeDR),"^",3)
		
		i ((myFareType="C")&&(+rtn=0))
		{
			s myCardINVObj=##class(web.DHCEntity.PCA.CardINVPRT).%New()
			s myCardINVObj.Date = +$h
			s myCardINVObj.Time = $p($h,",",2)
			s myPAPMIRowID=$p(^DHCACD("AccM",AccRowID),"^",2)
			s myCardINVObj.PAPMIRowID = myPAPMIRowID
			s myCardINVObj.CardFareCost=$p(^DHCCARDTYPEDef(myCardTypeDR),"^",6)
			s myCardINVObj.UserDR=UserDR
			s myCardINVObj.Flag="N"
			s myCashPMRowID=$o(^CT("CTPM",0,"Code","CASH",0))
			s myCardINVObj.PayMode=myCashPMRowID
			s myrtn=##class(web.DHCBL.CARD.UCardINVPRTInfo).SaveCardINVInfo(myCardINVObj, myCardTypeDR)
			s myCardINVRowID=$p(myrtn,"^",2)
			s myrtn=+myrtn
			s rtn=+myrtn
		}
	}
	
	i (+rtn=0)&&(CardRowID="") d
	.;需要原账户新卡的信息
	.s rtn=##Class(web.UDHCAccCardManage12).grantcardNEW(CardInfo, myCardINVRowID)
	.s ren=$p(rtn,"^",1),securityno=$p(rtn,"^",2)
	.s myCardRowID=$p(rtn,"^",3)
	.
	e  d
	.s myCardRowID=CardRowID
	
	;CardUpdate
	i +rtn=0 d
	.s rtn=##class(web.UDHCAccManageCLS).CardUpdate(myCardRowID, AccRowID)
	
	b	;;;Tro
	i +rtn=0 d
	.tc
	e  d
	.trollback
	
	q rtn_$c(2)_""
}

}
