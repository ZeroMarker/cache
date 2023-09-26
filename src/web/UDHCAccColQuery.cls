Class web.UDHCAccColQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 12;

ClassMethod KillTMP(TMPGID As %String) As %String
{
	n (TMPGID)
	
	;保存卡的数量
	k ^TMPCardColInfo($j)
	;保存挂号数量和退号数量
	k ^TMPCardColInfo($j)
	
	q 0
}

ClassMethod OperColWorkSateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OperColWorkSateExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OperColWorkSateExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, UserDR As %String) As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;d ##class(%ResultSet).RunQuery("web.UDHCAccColQuery","OperColWorkSate",+$h-50,+$h,"")
	
	;No, myCardNo, myPatName, myPAPMNo, myOperName, myCardStatus,
	;myOperDate, myComIP, myAppName, myAppAddress,
	;myAppIDType, myAppIDNo, myAppTelNo, myRemark
	
	if (StDate["-")!(StDate["/") d
	.s StDate=$zdh(BDate,3)
	i EndDate["-" d
	.s EndDate=$zdh(EndDate,3)
	
	s:StDate="" StDate=+$h
	s:EndDate="" EndDate=+$h
	
	d ..KillTMP("")
	
	d ResetVariablesCCI
	
	;按照流水时间统计卡数
	s myIdx=0
	s myAccRowID=0
	;f  s myAccRowID=$o(^TMPAcc($j,myAccRowID)) q:(myAccRowID="")  d
	f myDate=EndDate:-1:StDate d
	.s myCardRowID=0
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
	...q:((UserDR'="")&&(UserDR'=myUseDR))
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
	..s myUserDR=$o(^SSU("SSUSR",0,"SSUSR_Name",myOperName,0))
	..q:(myUserDR="")
	..s ^TMPCardColInfo($j,myUserDR,"RegC")=+$g(^TMPCardColInfo($j,myUserDR,"RegC"))+1
	
	;收退发票数量,按照流水日期查询
	
	
	b		;;Test
	
	s No=0
	s myTNNum=0
	s myTLNum=0
	s myTENum=0
	s myUserDR=0
	s myUserName=""
	f  s myUserDR=$o(^TMPCardColInfo($j,myUserDR)) q:(myUserDR="")  d
	.s myUserName=$g(^TMPCardColInfo($j,myUserDR))
	.s myNNum=+$g(^TMPCardColInfo($j,myUserDR,"N"))
	.s myTNNum=myTNNum+myNNum
	.s myLNum=+$g(^TMPCardColInfo($j,myUserDR,"L"))
	.s myTLNum=+myTLNum+myLNum
	.s myENum=+$g(^TMPCardColInfo($j,myUserDR,"E"))
	.s myTENum=+myTENum+myENum
	.s No=No+1
	.d OutputCCI
	
	d ResetVariablesCCI
	
	s myUserName="合计"
	s myNNum=myTNNum
	s myLNum=myTLNum
	s myENum=myTENum
	d OutputCCI
	
	d ..KillTMP("")
	
	Quit $$$OK
	
ResetVariablesCCI
	s (myUserName, myNNum, myLNum, myENum)=""
	;s ()=""
	quit
OutputCCI
	s Data=$lb(No, myUserName, myNNum, myLNum, myENum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod OperColWorkSateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OperColWorkSateExecute ]
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

Query OperColWorkSate(StDate As %String, EndDate As %String, UserDR As %String) As %Query(ROWSPEC = "Arg1:%String,Arg2:%String,Arg3:%String,Arg4:%String")
{
}

}
