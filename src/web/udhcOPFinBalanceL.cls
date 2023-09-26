Class web.udhcOPFinBalanceL Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 137;

Query ReadINSFootDataAll(INSUserDR As %String = "", StDate As %String = "", StTime As %String = "", EndDate As %String, EndTime As %String, UserName As %String, TMPGID As %String) As %Query(ROWSPEC = "No:%String,RepID:%String,FootDate:%String,FootTime:%String,INVSum:%String,HandSum:%String,BegFootDT:%String,EndFootDT:%String, GetPDSum:%String, RefPDSum:%String, UserName:%String, RcptNO:%String, ReceiptNum:%String, sUser:%String,INSFootUser:%String,WorkSum:%String,WorkSum2:%String,WorkSum4:%String, TMPGID:%String")
{
}

ClassMethod ReadINSFootDataAllExecute(ByRef qHandle As %Binary, INSUserDR As %String = "", StDate As %String = "", StTime As %String = "", EndDate As %String, EndTime As %String, UserName As %String, TMPGID As %String) As %Status
{
	
	New repid, index
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	s index=2
	
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalanceL","ReadINSFootDataAll","",+$h,"",+$h,"","","")
	
	;s ^TMP111=UserRowID_"^"_StDate_"^"_StTime_"^"_EndDate_"^"_EndTime
	;s:StDate="" StDate=+$h
	s:StTime="" StTime=$p($h,",",2)    ;0秒
	;s:EndDate="" EndDate=+$h
	s:EndTime="" EndTime=$p($h,",",2)   ;23:59:59秒
	s queryflag=""
	s queryflag=StDate
	
	i TMPGID'="" d
	.k ^TMPOPPrintOut(TMPGID)
	
	s myTMPGID=$i(^TMPOPPrintOut)
	
	q:(queryflag="") $$$OK
	;s ^lgltest(3211)=StDate_"^"_EndDate
	;^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	d ResetVariablesIFD
	
	s myINVTSum=0
	s myHandTSum=0
	s myRefTSum=0
	s myGetTSum=0
	s myRTNum=0
	s WorkSumS=0,WorkSum=0,WorkSumT=0,WorkSumBKS=0,WorkSumTKS=0,WorkSum4=0,WorkSumT2=0,WorkSumT4=0  ;lgl+工作量
	s myHisRID=0,WorkSumSYJJ=0,WorkSumTYJJ=0,WorkSumGHS=0,WorkSumTHS=0
	s WorkSumTSYJJ=0,WorkSumTTYJJ=0,WorkSumTGHS=0,WorkSumTTHS=0,WorkSumTBKS=0,WorkSumTTKS=0
	s myDate=StDate-1
	s i=0,RepID=""
	
	k ^TMPCardColInfo($j)
	
	d ..SetCardCount(StDate, EndDate)
	
	s OperDR="" f  s OperDR=$o(^DHCOPInsFootI(0,"UserFD",OperDR)) q:(OperDR="")  d
	.s FootFlag=0
	.d ResetVariablesIFD
	.s myDate=StDate-1
	.f  s myDate=$o(^DHCOPInsFootI(0,"UserFD",OperDR,myDate)) q:(myDate="")  d
	..s myUserName=$p($g(^SSU("SSUSR",OperDR)),"^",2)
	..s myUserCode=$p($g(^SSU("SSUSR",OperDR)),"^",1)
	..q:((myDate>EndDate)!(myDate<StDate))
	..s myHisRID="" f  s myHisRID=$o(^DHCOPInsFootI(0,"UserFD",OperDR,myDate,myHisRID)) q:(myHisRID="")  d
	...s myUDR=$p($g(^DHCOPInsFoot(myHisRID)),"^",15)
	...;s ^lgltest(645)=INSUserDR_"^"_myUDR
	...q:((INSUserDR'=myUDR)&&(INSUserDR'=""))
	...s myTime=$p($g(^DHCOPInsFoot(myHisRID)),"^",14)
	...q:((myDate=StDate)&&(myTime<+StTime)&&(StTime'=""))   //lgl:此处无意义
	...q:((myDate=EndDate)&&(myTime>+EndTime)&&(EndTime'=""))
	...s myFootUserDR=$p($g(^DHCOPInsFoot(myHisRID)),"^",15)
	...q:((UserName'="")&(UserName'=myUserCode))
	...q:(myFootUserDR="")	;未结算的退出
	...s FootFlag=1  ;是否有结算记录
	...s INVSum=INVSum+$p($g(^DHCOPInsFoot(myHisRID)),"^",1)
	...s INVSum=$fn(INVSum,"",1)
	...s HandSum=HandSum+$p($g(^DHCOPInsFoot(myHisRID)),"^",16)
	...
	...s HandSum=$fn(HandSum,"",1)
	...s myGetPDSum=myGetPDSum+$p($g(^DHCOPInsFoot(myHisRID)),"^",52)
	...s myRefPDSum=myRefPDSum+$p($g(^DHCOPInsFoot(myHisRID)),"^",54)
	...;在结算卡支付账目时的记录应该排除在外
	...s myCardPaySum=$p($g(^DHCOPInsFoot(myHisRID)),"^",59)
	...;s myRcptNO=$p($g(^DHCOPInsFoot(myHisRID)),"^",10)			;HIS_RcptNO
	...s myReceiptNum=+myReceiptNum+$p($g(^DHCOPInsFoot(myHisRID)),"^",9)		;HIS_Num
	...s myFFlag=$p($g(^DHCOPInsFoot(myHisRID)),"^",60)		;HIS_FootFlag
	...q:(myFFlag="S")			;系统自动结算的退出
	...;q:(myCardPaySum'="")
	...s myGetPDSum=$fn(myGetPDSum,"",1)   ;lgl+全部只取到毛
	...s myRefPDSum=$fn(myRefPDSum,"",1)
	...;s WorkSYJJ=0,WorkTYJJ=0
	...;&sql(select count(*) into :WorkSYJJ from SQLUser.DHC_AccPreDeposit where accpd_iprep_dr=:myHisRID and accpd_type="P")
	...s WorkSYJJ=+$p($g(^DHCOPInsFoot(myHisRID)),"^",51)
	...s WorkSumSYJJ=+WorkSumSYJJ+WorkSYJJ   //预交金笔数；
	...;&sql(select count(*) into :WorkTYJJ from SQLUser.DHC_AccPreDeposit where accpd_iprep_dr=:myHisRID and accpd_type="R")
	...s WorkTYJJ=+$p($g(^DHCOPInsFoot(myHisRID)),"^",53)
	...s WorkSumTYJJ=+WorkSumTYJJ+WorkTYJJ   //退预交金笔数；
	.q:(FootFlag=0)
	.s WorkSum=WorkSumSYJJ_"/"_WorkSumTYJJ
	.;&sql(select count(*) into :WorkGHS from SQLUser.pa_adm where paadm_createuser=:OperDR and  paadm_createdate>=:StDate and paadm_createdate<=:EndDate)
	.;&sql(select ssusr_name into :sname from SQLUser.ss_user where ssusr_rowid=:OperDR)
	.s WorkGHS=+$g(^TMPCardColInfo($j,OperDR,"RegA"))
	.s sname=$p($g(^SSU("SSUSR",OperDR)),"^",2)
	.;&sql(select count(*) into :WorkTHS from SQLUser.pa_adm where paadm_socialworkername=:sname and paadm_updatedate>=:StDate and paadm_updatedate<=:EndDate and paadm_visitstatus="C")
	.s WorkTHS=+$g(^TMPCardColInfo($j,OperDR,"RegC"))
	.//退号数
	.s WorkSumGHS=+WorkSumGHS+WorkGHS  //挂号数
	.s WorkSumTHS=+WorkSumTHS+WorkTHS  //退号数
	.s WorkSum2=WorkSumGHS_"/"_WorkSumTHS   //挂号数
	.;&sql(select count(*) into :WorkBKS from SQLUser.dhc_cardref where cf_user_dr=:OperDR and cf_date>=:StDate and cf_date<=:EndDate)
	.s WorkBKS=$g(^TMPCardColInfo($j,OperDR,"N"))
	.;&sql(select count(*) into :WorkTKS from SQLUser.dhc_cardref where cf_cancleuser_dr=:OperDR and cf_cancledate>=:StDate and cf_cancledate<=:EndDate)
	.s WorkTKS=$g(^TMPCardColInfo($j,OperDR,"L"))
	.s WorkSumBKS=+WorkSumBKS+WorkBKS  //办卡数
	.s WorkSumTKS=+WorkSumTKS+WorkTKS   //退卡数
	.;保留没有办理结算的操作员
	.k ^TMPCardColInfo($j,OperDR)
	.//s WorkSum5=+WorkSum5+Work5   //退卡数
	.s WorkSum4=WorkSumBKS_"/"_WorkSumTKS   //发卡数
	.s myINVTSum=+myINVTSum+INVSum
	.s myGetTSum=+myGetTSum+myGetPDSum
	.s myRefTSum=+myRefTSum+myRefPDSum
	.s myHandTSum=+myHandTSum+HandSum
	.s WorkSumTSYJJ=+WorkSumTSYJJ+WorkSumSYJJ  //预交金
	.s WorkSumTTYJJ=+WorkSumTTYJJ+WorkSumTYJJ
	.s WorkSumTGHS=+WorkSumTGHS+WorkSumGHS  //挂号
	.s WorkSumTTHS=+WorkSumTTHS+WorkSumTHS  
	.s WorkSumTBKS=+WorkSumTBKS+WorkSumBKS   //办卡
	.s WorkSumTTKS=+WorkSumTTKS+WorkSumTKS
	.;s WorkSumT=+WorkSumT+WorkSumS
	.s myRTNum=+myRTNum+myReceiptNum
	.s i=i+1
	.s No=i
	.d OutputIFD
	
	s myUserDR=0
	;^TMPCardColInfo($j,myUseDR,"N")
	f  s myUserDR=$o(^TMPCardColInfo($j,myUserDR)) q:(myUserDR="")  d
	.d ResetVariablesIFD
	.s WorkSumBKS=$g(^TMPCardColInfo($j,myUserDR,"N"))
	.s WorkSumTKS=$g(^TMPCardColInfo($j,myUserDR,"L"))
	.s WorkSum4=WorkSumBKS_"/"_WorkSumTKS   //发卡数
	.s sname=$p($g(^SSU("SSUSR",myUserDR)),"^",2)
	.s myUserName=sname
	.s WorkSumTBKS=+WorkSumTBKS+WorkSumBKS   //办卡
	.s WorkSumTTKS=+WorkSumTTKS+WorkSumTKS
	.;挂号数量
	.s WorkGHS=+$g(^TMPCardColInfo($j,myUserDR,"RegA"))
	.s WorkTHS=+$g(^TMPCardColInfo($j,myUserDR,"RegC"))
	.s WorkSumGHS=+WorkGHS  //挂号数  +WorkSumGHS
	.s WorkSumTHS=+WorkTHS  //退号数	+WorkSumTHS
	.s WorkSumTGHS=+WorkSumTGHS+WorkGHS
	.s WorkSumTTHS=+WorkSumTTHS+WorkTHS
	.s WorkSum2=WorkSumGHS_"/"_WorkSumTHS   //挂号数
	.s i=i+1
	.s No=i
	.d OutputIFD
	
	;校正挂号；
	s WorkGHS=+$g(^TMPCardColInfo($j,"Other","ORegA"))
	s WorkTHS=+$g(^TMPCardColInfo($j,"Other","ORegC"))
	i ((+WorkGHS'=0)!(+WorkTHS'=0)) d
	.d ResetVariablesIFD
	.s myUserName="未知"
	.s WorkGHS=+$g(^TMPCardColInfo($j,"Other","ORegA"))
	.s WorkTHS=+$g(^TMPCardColInfo($j,"Other","ORegC"))
	.s WorkSumGHS=+WorkGHS  //挂号数  +WorkSumGHS
	.s WorkSumTHS=+WorkTHS  //退号数	+WorkSumTHS
	.s WorkSumTGHS=+WorkSumTGHS+WorkGHS
	.s WorkSumTTHS=+WorkSumTTHS+WorkTHS
	.s WorkSum2=WorkSumGHS_"/"_WorkSumTHS   //挂号数
	.s i=i+1
	.s No=i
	.d OutputIFD
	.
	
	;s No="合计"
	s myUserName="合计"
	s INVSum=$fn(myINVTSum,"",1)
	s HandSum=$fn(myHandTSum,"",1)
	s myGetPDSum=$fn(myGetTSum,"",1)
	s myRefPDSum=$fn(myRefTSum,"",1)
	s myReceiptNum=myRTNum    ;$fn(myRTNum,"",1)
	s WorkSum=WorkSumTSYJJ_"/"_WorkSumTTYJJ
	s WorkSum2=WorkSumTGHS_"/"_WorkSumTTHS
	s WorkSum4=WorkSumTBKS_"/"_WorkSumTTKS
	s i=i+1
	s No=i
	d OutputIFD2
	
	k ^TMPCardColInfo($j)
	
	Quit $$$OK
ResetVariablesIFD
	s (No,RepID,FootDate,FootTime,INVSum,HandSum,BegFootDT,EndFootDT, myGetPDSum, myRefPDSum, myUserName, myRcptNO, myReceiptNum, myOperDR,INSFootUser,WorkSumS,WorkSum,WorkSum2,WorkSum4,WorkSumSYJJ,WorkSumTYJJ,WorkSumGHS,WorkSumTHS,WorkSumBKS,WorkSumTKS)=""
	quit
OutputIFD
	s Data=$lb(No,RepID,FootDate,FootTime,INVSum,HandSum,BegFootDT,EndFootDT, myGetPDSum, myRefPDSum, myUserName, myRcptNO, myReceiptNum, myOperDR,INSFootUser,WorkSum,WorkSum2,WorkSum4, myTMPGID)
	Set ^CacheTemp(repid,index)=Data
	s myPRTData=##class(web.DHCOPConfig).TransLBToStr(Data)
	s ^TMPOPPrintOut(myTMPGID,index)=myPRTData
	
	Set index=index+1
	quit
OutputIFD2
	s Data=$lb(No,RepID,FootDate,FootTime,INVSum,HandSum,BegFootDT,EndFootDT, myGetPDSum, myRefPDSum, myUserName, myRcptNO, myReceiptNum, myOperDR,INSFootUser,WorkSum,WorkSum2,WorkSum4, myTMPGID)
	Set ^CacheTemp(repid,1)=Data
	s myPRTData=##class(web.DHCOPConfig).TransLBToStr(Data)
	s ^TMPOPPrintOut(myTMPGID,index+1)=myPRTData
	quit
}

ClassMethod ReadINSFootDataAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadINSFootDataAllExecute ]
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

ClassMethod ReadINSFootDataAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadINSFootDataAllExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SetCardCount(StDate As %String, EndDate As %String) As %String
{
	n (EndDate, StDate)
	b	;;
	s myIdx=0
	s myAccRowID=0
	
	f myDate=EndDate:-1:StDate d
	.s myCardRowID=0
	.b		;Date
	.f  s myCardRowID=$o(^DHCCARDi("CF",0,"CSDate",myDate,myCardRowID)) q:(myCardRowID="")  d
	..s mySub=0
	..f  s mySub=$o(^DHCCARDi("CF",0,"CSDate",myDate,myCardRowID,"CSC", mySub)) q:(mySub="")  d
	...s myTime=$p(^DHCCARD("CF",myCardRowID,"CSC",mySub),"^",2)
	...s myOperDate=$zd(myDate,3)_" "_$zt(myTime)
	...s myCardStatusCode=$p(^DHCCARD("CF",myCardRowID,"CSC",mySub),"^",3)
	...;q:(CardStatus'="")&(CardStatus'=myCardStatusCode)
	...i myCardStatusCode="N" s myCardStatus="正常"
	...i myCardStatusCode="S" s myCardStatus="挂失"
	...i myCardStatusCode="R" s myCardStatus="回收"
	...i myCardStatusCode="D" s myCardStatus="作废"
	...s myUseDR=$p(^DHCCARD("CF",myCardRowID,"CSC",mySub),"^",4)
	...s myOperName=""
	...s myUserCode=""
	...i (myUseDR'="") d
	....s myOperName=$p(^SSU("SSUSR",myUseDR),"^",2)
	....s myUserCode=$p(^SSU("SSUSR",myUseDR),"^",1)
	...s ^TMPCardColInfo($j,myUseDR)=myOperName
	...i myCardStatusCode="N"  d
	....s ^TMPCardColInfo($j,myUseDR,"N")=+$g(^TMPCardColInfo($j,myUseDR,"N"))+1
	...i myCardStatusCode'="N" d
	....s ^TMPCardColInfo($j,myUseDR,"L")=+$g(^TMPCardColInfo($j,myUseDR,"L"))+1
	
	;按照流水时间统计挂号数量
	;^TMPCardColInfo($j)
	f myDate=EndDate:-1:StDate d
	.;^PAADMi("PAADM_AdmDate",{PAADM_AdmDate},{PAADM_RowID})
	.s myPAADMRowID=0
	.f  s myPAADMRowID=$o(^PAADMi("PAADM_AdmDate",myDate,myPAADMRowID))  q:(myPAADMRowID="")  d
	..s myADMType=$p(^PAADM(myPAADMRowID),"^",2)
	..q:(myADMType'="O")
	..s myUserDR=$p(^PAADM(myPAADMRowID),"^",43)
	..i (myUserDR="") d
	...s ^TMPCardColInfo($j,"Other","ORegA")=+$g(^TMPCardColInfo($j,"Other","ORegA"))+1
	..q:(myUserDR="")
	..s ^TMPCardColInfo($j,myUserDR,"RegA")=+$g(^TMPCardColInfo($j,myUserDR,"RegA"))+1
	
	;2.退号
	;^PAADMi("UpdDate",{PAADM_UpdateDate},{PAADM_RowID})
	f myDate=EndDate:-1:StDate d
	.s myPAADMRowID=0
	.f  s myPAADMRowID=$o(^PAADMi("UpdDate", myDate, myPAADMRowID))  q:(myPAADMRowID="")  d
	..s myADMType=$p(^PAADM(myPAADMRowID),"^",2)
	..q:(myADMType'="O")
	..s myOperName=$p(^PAADM(myPAADMRowID,2),"^",69)
	..;^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP({SSUSR_Name}),
	..i myOperName="" d
	...s ^TMPCardColInfo($j,"Other","ORegC")=+$g(^TMPCardColInfo($j,"Other","ORegC"))+1
	..q:(myOperName="")
	..s myUserDR=$o(^SSU("SSUSR",0,"SSUSR_Name",myOperName,0))
	..i (myUserDR="") d
	...s ^TMPCardColInfo($j,"Other","ORegC")=+$g(^TMPCardColInfo($j,"Other","ORegC"))+1
	...;s ^TMPWZOPReg(myPAADMRowID)=myOperName
	..q:(myUserDR="")
	..s ^TMPCardColInfo($j,myUserDR,"RegC")=+$g(^TMPCardColInfo($j,myUserDR,"RegC"))+1
	
	q 0
}

}
