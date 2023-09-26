/// Expception
/// 北京积水潭医院的扩展
/// 
Class web.udhcOPFinBalanceExp Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 26;

ClassMethod BuildUserLISTINVCatData(UserRowID As %String, StDate As %String, EndDate As %String) As %String
{
	n (UserRowID, StDate, EndDate)
	;w ##class(web.udhcOPFinBalanceExp).BuildUserLISTINVCatData("",+$h,+$h+1)
	;生成一个供Query使用的TMP
	;按照权责发生流水帐来生成TMP
	k ^TMPOPINVINSFootRep($j)
	
	;
	s myUserRowID=0
	;^DHCINVOICE("USER",{INV_Usr},{INV_rowid})
	
	f  s myUserRowID=$o(^DHCINVOICE(0,"USER",myUserRowID)) q:(myUserRowID="")  d
	.s myINVRowID=0
	.s myFinFlag="N"
	.q:(UserRowID'="")&(UserRowID'=myUserRowID)
	.f  s myINVRowID=$o(^DHCINVOICE(0,"USER",myUserRowID, myINVRowID)) q:((myINVRowID="")!(myFinFlag="Y"))  d
	..s myType=$p(^DHCINVOICE(myINVRowID),"^",8)		;INV_type
	..q:(myType'="O")
	..s myFinFlag="Y"
	..s myUserINVInfo=##class(web.udhcOPHandin0FQ).ReadOPINVHZInfo(myUserRowID,StDate,0,EndDate,0,"")
	..;s myInfoT=myTotINVNum_"^"_myINVInfo_"^"_myTotAbortNum_"^"_myTotAbortInfo_"^"_myTotRefNum_"^"_myTotRefInfo
	..s myTInfo=$p(myUserINVInfo,$c(1),1)
	..s myTINVNum=+$p(myTInfo,"^",1)
	..s myTParkNum=+$p(myTInfo,"^",3)
	..s myTRefNum=+$p(myTInfo,"^",5)
	..q:((myTINVNum=0)&(myTParkNum=0)&(myTRefNum=0))
	..b
	..s ^TMPOPINVINSFootRep($j,myUserRowID,"INVInfo")=$p(myTInfo,"^",2)
	..s ^TMPOPINVINSFootRep($j,myUserRowID,"INVTNum")=$p(myTInfo,"^",1)
	..s ^TMPOPINVINSFootRep($j,myUserRowID,"INVTSum")=$p(myTInfo,"^",7)
	..s ^TMPOPINVINSFootRep($j,myUserRowID,"INVParkInfo")=$p(myTInfo,"^",4)
	..s ^TMPOPINVINSFootRep($j,myUserRowID,"INVRefInfo")=$p(myTInfo,"^",6)
	..
	
	
	q 0
}

ClassMethod ReadUserLISTINVCAVClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadUserLISTINVCAVExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReadUserLISTINVCAVExecute(ByRef qHandle As %Binary, UserRowID As %String, StDate As %String, EndDate As %String, TMPGID As %String) As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance1","ReadUserFootINVCAV","","60446","60456")
	;s mystr=##class(web.udhcOPFinBalance1).GetUserFootDT(UserDR)
	
	;s ^TMP111=UserRowID_"^"_StDate_"^"_EndDate
	
	s:StDate="" StDate=+$h
	s:EndDate="" EndDate=+$h
	
	;^DHCOPInsFootI(0,"INSFDate",{HIS_INSFootDate},{HIS_Rowid})
	d ResetVariablesFICAV
	
	;使用流水账进行查询，解决积水潭医院
	
	k ^TMPOPINVINSFootRep($j)
	;发票的汇总计算
	;k ^TMPOPINVINSFootRep($j,UserDR,"INVNo")
	
	i TMPGID'="" d
	.k ^TMPOPPrintOut(TMPGID)
	
	s myTMPGID=$i(^TMPOPPrintOut)
	
	s myINVTSum=0
	s myHandTSum=0
	s myRefTSum=0
	s myGetTSum=0
	
	d ..BuildUserLISTINVCatData(UserRowID, StDate, +EndDate+1)
	
	s myTolINVNum=0
	s myTolINVSum=0
	b		;;bengi
	s No=0
	s myUserRowID=0
	f  s myUserRowID=$o(^TMPOPINVINSFootRep($j,myUserRowID))  q:(myUserRowID="")  d
	.s OperName=$p(^SSU("SSUSR",myUserRowID),"^",2)
	.;生成号段
	.s myINVNo=""
	.s INVRepNo=""
	.;^TMPOPINVINSFootRep($j,myUDR,"INVNo", myINVIdx))
	.s myTMPIdx=0
	.s INVRepNo=$g(^TMPOPINVINSFootRep($j,myUserRowID,"INVInfo"))
	.s INVNum=+$g(^TMPOPINVINSFootRep($j,myUserRowID,"INVTNum"))
	.s INVSum=+$g(^TMPOPINVINSFootRep($j,myUserRowID,"INVTSum"))
	.s myINVParkInfo=$g(^TMPOPINVINSFootRep($j,myUserRowID,"INVParkInfo"))
	.s myINVRefInfo=$g(^TMPOPINVINSFootRep($j,myUserRowID,"INVRefInfo"))
	.s myTolINVNum=+myTolINVNum+INVNum
	.s myTolINVSum=+myTolINVSum+INVSum
	.q:((+myTolINVNum=0)!(+myTolINVSum=0))
	.s No=No+1
	.d OutputFICAV
	.
	
	
	;合计
	;s (No,OperName,INVNum,INVRepNo,INVSum)=""
	d ResetVariablesFICAV
	
	s No="合计"
	s INVSum=$fn(myTolINVSum,"",2)
	s INVNum=myTolINVNum
	
	d OutputFICAV
	
	k ^TMPOPINVINSFootRep($j)
	
	Quit $$$OK
ResetVariablesFICAV
	s (No,OperName,INVNum,INVRepNo,INVSum,myINVParkInfo,myINVRefInfo)=""
	quit
OutputFICAV
	s Data=$lb(No,OperName,INVNum,INVRepNo,INVSum, myTMPGID,myINVParkInfo,myINVRefInfo)
	Set ^CacheTemp(repid,index)=Data
	s myTMPData=##class(web.DHCOPConfig).TransLBToStr(Data)
	s ^TMPOPPrintOut(myTMPGID,index)=myTMPData
	Set index=index+1
	quit
}

ClassMethod ReadUserLISTINVCAVFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadUserLISTINVCAVExecute ]
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

Query ReadUserLISTINVCAV(UserRowID As %String, StDate As %String, EndDate As %String, TMPGID As %String) As %Query(ROWSPEC = "No:%String,OperName:%String,INVNum:%String,INVRepNo:%String,INVSum:%String,TMPGID:%String,INVParkInfo:%String,INVRefInfo:%String")
{
}

}
