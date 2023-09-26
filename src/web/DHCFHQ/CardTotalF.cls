Class web.DHCFHQ.CardTotalF Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 根据日期来查询卡数量
ClassMethod CardTypeByDate(ByRef repid As %Integer = 0, StartDate As %String = "", EndDate As %String = "", LogonHospDesc As %String = "") As %Integer
{
	s del="^",RetNum=0
	q:StartDate="" RetNum
	q:EndDate="" RetNum
	i StartDate["-" s StartDate=$zdh(StartDate,3)
	i EndDate["-" s EndDate=$zdh(EndDate,3)
	s Date=StartDate-1
	s CardNum=0
	f  s Date=$o(^DHCCARDi("CF",0,"Date",Date)) q:((Date>EndDate)!(Date=""))  d
	.s CardId=0
	.s CardStatus="办卡"
	.f  s CardId=$o(^DHCCARDi("CF",0,"Date",Date,CardId)) q:CardId=""  d
	..s CSCSub=0,FindNewCardFlag=0
	..f  s CSCSub=$o(^DHCCARD("CF",CardId,"CSC",CSCSub)) q:CSCSub=""  d
	...s CSCCurStatus=$p(^DHCCARD("CF",CardId,"CSC",CSCSub),"^",3)
	...s CSCHospDR=$p(^DHCCARD("CF",CardId,"CSC",CSCSub),"^",18)
	...//Q:(CSCHospDR'=LogonHospID)&&(LogonHospID'="")
	...s CSCHospDesc=""
	...i CSCHospDR'="" s CSCHospDesc=$p($g(^CT("HOSP",CSCHospDR)),"^",2)
	...Q:(LogonHospDesc'="")&&(CSCHospDesc'=LogonHospDesc)
	...Q:(CSCCurStatus'="N")&&(CSCCurStatus'="E")&&(CSCCurStatus'="RN")
	...s FindNewCardFlag=1
	..Q:FindNewCardFlag=0
	..s CreateUserDr=$p(^DHCCARD("CF",CardId),del,9)
	..s CreateUser="999"
	..s:((CreateUserDr'="")&&($d(^SSU("SSUSR",CreateUserDr)))) CreateUser=$p(^SSU("SSUSR",CreateUserDr),del,2)
	..;IF CreateUser="999" B
	..s CardTypeDr=$p(^DHCCARD("CF",CardId),del,16)
	..s CardType="aa"
	..s:((CardTypeDr'="")&&($d(^DHCCARDTYPEDef(CardTypeDr)))) CardType=$p(^DHCCARDTYPEDef(CardTypeDr),del,2)
	..s:$d(^CacheTempFHQ(repid,0,CreateUser,CardType,CardStatus)) ^CacheTempFHQ(repid,0,CreateUser,CardType,CardStatus)=^CacheTempFHQ(repid,0,CreateUser,CardType,CardStatus)+1
	..s:'$d(^CacheTempFHQ(repid,0,CreateUser,CardType,CardStatus)) ^CacheTempFHQ(repid,0,CreateUser,CardType,CardStatus)=1
	
	s Date=StartDate-1
	s CardNum=0
	f  s Date=$o(^DHCCARDi("CF",0,"CancleDate",Date)) q:((Date>EndDate)!(Date=""))  d
	.s CardId=0
	.s CardStatus="退卡"
	.f  s CardId=$o(^DHCCARDi("CF",0,"CancleDate",Date,CardId)) q:CardId=""  d
	..s CSCSub=0,FindCancelCardFlag=0
	..f  s CSCSub=$o(^DHCCARD("CF",CardId,"CSC",CSCSub)) q:CSCSub=""  d
	...s CSCCurStatus=$p(^DHCCARD("CF",CardId,"CSC",CSCSub),"^",3)
	...s CSCHospDR=$p(^DHCCARD("CF",CardId,"CSC",CSCSub),"^",18)
	...//Q:(CSCHospDR'=LogonHospID)&&(LogonHospID'="")
	...s CSCHospDesc=""
	...i CSCHospDR'="" s CSCHospDesc=$p($g(^CT("HOSP",CSCHospDR)),"^",2)
	...Q:(LogonHospDesc'="")&&(CSCHospDesc'=LogonHospDesc)
	...Q:(CSCCurStatus'="R")
	...s FindCancelCardFlag=1
	..Q:FindCancelCardFlag=0
	..s CancleUserDr=$p(^DHCCARD("CF",CardId),del,15)
	..s CancleUser="999"
	..s:((CancleUserDr'="")&&($d(^SSU("SSUSR",CancleUserDr)))) CancleUser=$p(^SSU("SSUSR",CancleUserDr),del,2)
	..s CardTypeDr=$p(^DHCCARD("CF",CardId),del,16)
	..s CardType=""
	..s:((CardTypeDr'="")&&($d(^DHCCARDTYPEDef(CardTypeDr)))) CardType=$p(^DHCCARDTYPEDef(CardTypeDr),del,2)
	..s:$d(^CacheTempFHQ(repid,0,CancleUser,CardType,CardStatus)) ^CacheTempFHQ(repid,0,CancleUser,CardType,CardStatus)=^CacheTempFHQ(repid,0,CancleUser,CardType,CardStatus)+1
	..s:'$d(^CacheTempFHQ(repid,0,CancleUser,CardType,CardStatus)) ^CacheTempFHQ(repid,0,CancleUser,CardType,CardStatus)=1

	
	
    s CreateUser=0
	f  s CreateUser=$o(^CacheTempFHQ(repid,0,CreateUser)) q:CreateUser=""  d
	.s CardType=""
	.f  s CardType=$o(^CacheTempFHQ(repid,0,CreateUser,CardType)) q:CardType=""  d
	..s CardStatus=""
	..f  s CardStatus=$o(^CacheTempFHQ(repid,0,CreateUser,CardType,CardStatus)) q:CardStatus=""  d
	...s CardNum=0,CardNumRet=0
	...s:CardStatus="办卡" CardNum=$g(^CacheTempFHQ(repid,0,CreateUser,CardType,CardStatus))
	...s:CardStatus="退卡" CardNumRet=$g(^CacheTempFHQ(repid,0,CreateUser,CardType,CardStatus))
	...s RetNum=RetNum+1
	...s ^CacheTempFHQ(repid,RetNum)=$lb(CreateUser,CardStatus,CardType,$g(CardNum),$g(CardNumRet))
	..K ^CacheTempFHQ(repid,0,CreateUser,CardType)
	q RetNum
}

ClassMethod CardTypeByDateCancle(ByRef repid As %Integer = 0, StartDate As %String = "", EndDate As %String = "") As %Integer
{
	s del="^",RetNum=0
	if StartDate="" s StartDate=$zd(+$h,3)
	if EndDate="" s EndDate=$zd(+$h,3)
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	s Date=StartDate-1
	s CardNum=0
	f  s Date=$o(^DHCCARDi("CF",0,"CancleDate",Date)) q:((Date>EndDate)!(Date=""))  d
	.s CardId=0
	.s CardStatus="退卡"
	.f  s CardId=$o(^DHCCARDi("CF",0,"CancleDate",Date,CardId)) q:CardId=""  d
	..s CancleUserDr=$p(^DHCCARD("CF",CardId),del,15)
	..s CancleUser="999"
	..s:((CancleUserDr'="")&&($d(^SSU("SSUSR",CancleUserDr)))) CancleUser=$p(^SSU("SSUSR",CancleUserDr),del,2)
	..s CardTypeDr=$p(^DHCCARD("CF",CardId),del,16)
	..s CardType=""
	..s:((CardTypeDr'="")&&($d(^DHCCARDTYPEDef(CardTypeDr)))) CardType=$p(^DHCCARDTYPEDef(CardTypeDr),del,2)
	..s:$d(^CacheTempFHQ(repid,0,CancleUser,CardType,CardStatus)) ^CacheTempFHQ(repid,0,CancleUser,CardType,CardStatus)=^CacheTempFHQ(repid,0,CancleUser,CardType,CardStatus)+1
	..s:'$d(^CacheTempFHQ(repid,0,CancleUser,CardType,CardStatus)) ^CacheTempFHQ(repid,0,CancleUser,CardType,CardStatus)=1
	..;W CancleUser_":"_CardType_":"_CardStatus,!
    s CancleUser=0
	f  s CancleUser=$o(^CacheTempFHQ(repid,0,CancleUser)) q:CancleUser=""  d
	.s CardType=""
	.f  s CardType=$o(^CacheTempFHQ(repid,0,CancleUser,CardType)) q:CardType=""  d
	..s CardStatus=""
	..f  s CardStatus=$o(^CacheTempFHQ(repid,0,CancleUser,CardType,CardStatus)) q:CardStatus=""  d
	...s CardNum=$g(^CacheTempFHQ(repid,0,CancleUser,CardType,CardStatus))
	...s RetNum=RetNum+1
	...s ^CacheTempFHQ(repid,RetNum)=$lb(CancleUser,CardType,CardStatus,CardNum)
	..K ^CacheTempFHQ(repid,0,CancleUser,CardType)
	q RetNum
}

}
