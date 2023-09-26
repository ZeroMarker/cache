Class web.udhcOPFinBalance7Exp Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod GetUserFootDT(UserDR As %String = "") As %String
{
	n (UserDR)
	;w ##class(web.udhcOPFinBalance1).GetUserFootDT("902")
	
	s StDate=""
	s StTime=""
	s EndDate=+$h
	s EndTime=$p($h,",",2)
	
	s myHISRID=""
	q:(UserDR="") "-1^"_StDate_"^"_StTime_"^"_EndDate_"^"_EndTime
	
	;^DHCOPInsFootI(0,"User",{HIS_User},{HIS_Rowid})
	;s myHISRID=$o(^DHCOPInsFootI(0,"User",UserDR,""),-1)
	s myHisFootDate=$o(^DHCOPInsFootI(0,"UserFD",UserDR,""),-1)
	i myHisFootDate'="" d
	.s myHISRID=""
	.s myHISRID=$o(^DHCOPInsFootI(0,"UserFD",UserDR,myHisFootDate,myHISRID),-1)
	.b	;
	.q:myHISRID=""
	.s StDate=$p($g(^DHCOPInsFoot(myHISRID)),"^",13)		;去财务上次结算日期
	.s StTime=$p($g(^DHCOPInsFoot(myHISRID)),"^",14)
	
	;s myLastHISRowID=$o(^DHCOPInsFootI(0,"User",UserDR,""),-1)
	
	i myHISRID="" d
	.s myHISRID=$o(^DHCOPInsFootI(0,"User",UserDR,0))
	.q:(myHISRID="")
	.s StDate=$p($g(^DHCOPInsFoot(myHISRID)),"^",2)			;去操作员第一次结算日期
	.s StTime=$p($g(^DHCOPInsFoot(myHISRID)),"^",7)
	.s StTime=StTime-1
	
	s myCount=0
	s myHisID=myHISRID-1			;RowID前一个
	f  s myHisID=$o(^DHCOPInsFootI(0,"User",UserDR,myHisID))  q:(myHisID="")  d
	.s myINSFD=$p($g(^DHCOPInsFoot(myHisID)),"^",13)
	.q:(myINSFD'="")
	.s myCount=+myCount+1
	
	i StDate="" d
	.s StDate=+$h
	.s StTime=$p($h,",",2)
	
	s StDate=$zd(StDate,4)
	s StTime=$zt(StTime)
	s EndDate=$zd(EndDate,4)
	s EndTime=$zt(EndTime)
	
	q "0^"_StDate_"^"_StTime_"^"_EndDate_"^"_EndTime_"^"_myCount
}

ClassMethod ReadUserFootDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadUserFootDataExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReadUserFootDataExecute(ByRef qHandle As %Binary, UserRowID As %String = "", StDate As %String = "", StTime As %String = "", EndDate As %String = "", EndTime As %String = "") As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance1","ReadUserFootData","10033","60234","60336","60407","82739")
	;s mystr=##class(web.udhcOPFinBalance1).GetUserFootDT(UserDR)
	
	;s ^TMP111=UserRowID_"^"_StDate_"^"_StTime_"^"_EndDate_"^"_EndTime
	s:StDate="" StDate=+$h
	s:StTime="" StTime=$p($h,",",2)
	s:EndDate="" EndDate=+$h
	s:EndTime="" EndTime=$p($h,",",2)
	
	;患者审核
	;1.检索操作未做日报记录
	;2.检索操作做日报记录
	
	;^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	d ResetVariablesFR
	s No=0
	s myINVTSum=0
	s myHandTSum=0
	s myRefTSum=0
	s myGetTSum=0
	b
	s myDate=StDate-1
	f  s myDate=$o(^DHCOPInsFootI(0,"Date",myDate)) q:(myDate="")  d
	.s myHisRID=0
	.q:(EndDate<myDate)
	.f  s myHisRID=$o(^DHCOPInsFootI(0,"Date",myDate, myHisRID))  q:(myHisRID="")  d
	..s myUDR=$p($g(^DHCOPInsFoot(myHisRID)),"^",8)
	..q:((UserRowID'=myUDR)&&(UserRowID'=""))
	..s myTime=$p($g(^DHCOPInsFoot(myHisRID)),"^",7)
	..q:((myDate=StDate)&&(myTime<StTime))
	..q:((myDate=EndDate)&&(myTime>EndTime))
	..s myFootUserDR=$p($g(^DHCOPInsFoot(myHisRID)),"^",15)
	..q:(myFootUserDR'="")
	..s No=+No+1
	..s RepID=myHisRID
	..s FootDate=$zd(myDate,3)
	..s FootTime=$zt(myTime)
	..s INVSum=$p($g(^DHCOPInsFoot(myHisRID)),"^",1)
	..s INVSum=$fn(INVSum,"",2)
	..s myINVTSum=+myINVTSum+INVSum
	..s HandSum=$p($g(^DHCOPInsFoot(myHisRID)),"^",16)
	..s HandSum=$fn(HandSum,"",2)
	..s myGetPDSum=+$p($g(^DHCOPInsFoot(myHisRID)),"^",52)
	..s myGetTSum=+myGetTSum+myGetPDSum
	..s myRefPDSum=+$p($g(^DHCOPInsFoot(myHisRID)),"^",54)
	..s myRefTSum=+myRefTSum+myRefPDSum
	..s myHandTSum=+myHandTSum+HandSum
	..s myBegD=$p($g(^DHCOPInsFoot(myHisRID)),"^",5)
	..s myBegT=$p($g(^DHCOPInsFoot(myHisRID)),"^",6)
	..s BegFootDT=$zd(myBegD,3)_" "_$zt(myBegT)
	..s myEndD=$p($g(^DHCOPInsFoot(myHisRID)),"^",3)
	..s myEndT=$p($g(^DHCOPInsFoot(myHisRID)),"^",4)
	..s EndFootDT=$zd(myEndD,3)_" "_$zt(myEndT)
	..s myFootStatus="已结"
	..d OutputFR
	
	k ^TMPUserFootData($j)
	;对于没有办理结算的数据
	;按照日期来建立一个临时Global, 利用接口建立,  然后取出这些数据
	;日期按照数据的操作时间来算；
	;^TMPUserFootData($j,Date,)
	d ResetVariablesFR
	s myrtn=##class(web.udhcOPFinBalanceIF).GetUFDataForFin(UserRowID, StDate, StTime, EndDate, EndTime)
	s myCurDate=0
	
	f  s myCurDate=$o(^TMPUserFootData($j, myCurDate))  q:(myCurDate="")  d
	.s No=+No+1
	.s myHandInfo=$g(^TMPUserFootData($j, myCurDate))
	.s myUnFTInfo=$p(myHandInfo,$c(3),1)
	.s INVSum=$p(myUnFTInfo,"^",6)		;票据额
	.s INVSum=$fn(INVSum,"",2)
	.s myINVTSum=+myINVTSum+INVSum
	.s HandSum=$p(myUnFTInfo,"^",7)		;;实际上缴额
	.s HandSum=$fn(HandSum,"",2)
	.s myPRDINfo=$p(myHandInfo,$c(3),3)   ;myary[3].split("^");
	.s myGetPDSum=$fn(+$p(myPRDINfo,"^",2),"",2)		;收预交金额
	.s myGetTSum=+myGetTSum+myGetPDSum
	.s myRefPDSum=$fn(+$p(myPRDINfo,"^",4),"",2)		;退预交金额
	.s myRefTSum=+myRefTSum+myRefPDSum
	.s myHandTSum=+myHandTSum+HandSum
	.;s myBegD=$p($g(^DHCOPInsFoot(myHisRID)),"^",5)
	.;s myBegT=$p($g(^DHCOPInsFoot(myHisRID)),"^",6)
	.;s BegFootDT=$zd(myBegD,3)_" "_$zt(myBegT)
	.;s myEndD=$p($g(^DHCOPInsFoot(myHisRID)),"^",3)
	.;s myEndT=$p($g(^DHCOPInsFoot(myHisRID)),"^",4)
	.;s EndFootDT=$zd(myEndD,3)_" "_$zt(myEndT)
	.s myFootStatus="未结"
	.d OutputFR
	
	k ^TMPUserFootData($j)
	
	;合计
	;s (No,RepID,FootDate,FootTime,INVSum,HandSum,BegFootDT,EndFootDT)=""
	d ResetVariablesFR
	
	s No="合计"
	s INVSum=$fn(myINVTSum,"",2)
	s HandSum=$fn(myHandTSum,"",2)
	s myGetPDSum=$fn(myGetTSum,"",2)
	s myRefPDSum=$fn(myRefTSum,"",2)
	
	d OutputFR
	
	Quit $$$OK
ResetVariablesFR
	s (RepID,FootDate,FootTime,INVSum,HandSum,BegFootDT,EndFootDT, myGetPDSum, myRefPDSum, myUDR, myFootStatus)=""
	quit
OutputFR
	s Data=$lb(No,RepID,FootDate,FootTime,INVSum,HandSum,BegFootDT,EndFootDT, myGetPDSum, myRefPDSum, myUDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod ReadUserFootDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadUserFootDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 读取操作员结算的数据
Query ReadUserFootData(UserRowID As %String = "", StDate As %String = "", StTime As %String = "", EndDate As %String = "", EndTime As %String = "") As %Query(ROWSPEC = "No:%String,RepID:%String,FootDate:%String,FootTime:%String,INVSum:%String,HandSum:%String,BegFootDT:%String,EndFootDT:%String, GetPDSum:%String, RefPDSum:%String, UserRowID:%String")
{
}

}
