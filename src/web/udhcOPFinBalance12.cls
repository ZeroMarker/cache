/// service for DITAN only
Class web.udhcOPFinBalance12 Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod ReadAccMListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadAccMListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReadPatAccListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadPatAccListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReadAccMListExecute(ByRef qHandle As %Binary, AccNo As %String, PAPMINo As %String, BUserCode As %String, CardNo As %String, AccStatus As %String, AccType As %String, StDate As %String, EndDate As %String, BUserCodeA As %String, PatNameA As %String, TMPGID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	;条件：登记号，用户代码，卡号，帐户状态，帐户类型， 开户 开始，截止日期
	;
	;根据条件查询记录集
	;医院的账户信息
	;PatNameA

	i TMPGID'="" d
	.k ^TMPOPPrintOut(TMPGID)
	
	s myTMPGID=$i(^TMPOPPrintOut)
	
	i StDate="" set StDate=+$H			;Set qHandle=$lb(0,repid,0)	Quit $$$OK
	i EndDate="" Set EndDate=+$H			;Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s myIdx=0
	
	s (myPreTSum, myRefPreTSum,myAccPayTSum , myAccLeftTSum, myUnPrintTSum)=""
	
	s myPAPMILen=+$p(^CF("PATCF",1,3),"^",5)
	i PAPMINo'="" d
	.s mylen=$l(PAPMINo)
	.s myPANo=$e("0000000000000000",1,myPAPMILen-mylen)_PAPMINo
	.s PAPMINo=myPANo
	
	d ValidateData
	
	k ^CacheTemp(0,$j,"ACCQ")
	s myAccRowID=0
	f myDate=StDate:1:EndDate  d
	.;^CacheTemp(0,$j,"ACCQ",myAccRowID)
	.;^DHCINVPRT(0,"Date",{PRT_Date},{PRT_Rowid})
	.s myPRTRowID=0
	.f  s myPRTRowID=$o(^DHCINVPRT(0,"Date",myDate, myPRTRowID))  q:(myPRTRowID="")  d
	..q:($d(^DHCINVPRT(myPRTRowID))=10)
	..s myINVPrintFlag=$p(^DHCINVPRT(myPRTRowID),"^",3)
	..q:(myINVPrintFlag="P")
	..s myFlag=$p(^DHCINVPRT(myPRTRowID),"^",8)
	..q:(myFlag'="N")
	..s myAccRowID=""
	..s myPMSub=0
	..f  s myPMSub=$o(^DHCINVPRT(myPRTRowID,"P",myPMSub))  q:((myPMSub="")!(myAccRowID'=""))  d
	...q:($d(^DHCINVPRT(myPRTRowID,"P",myPMSub))=10)
	...s myAccRowID=+$p(^DHCINVPRT(myPRTRowID,"P",myPMSub),"^",8)
	..q:(myAccRowID="")
	..s ^CacheTemp(0,$j,"ACCQ",myAccRowID)=""
	..s myPatSum=$p(^DHCINVPRT(myPRTRowID),"^",16)
	..s ^CacheTemp(0,$j,"ACCQ",myAccRowID,"PatSum")=+$g(^CacheTemp(0,$j,"ACCQ",myAccRowID,"PatSum"))+myPatSum
	
	s myAccRowID=0
	f  s myAccRowID=$o(^CacheTemp(0,$j,"ACCQ", myAccRowID))  q:(myAccRowID="")  d
	.;^DHCACD("AccM",{AccM_RowID}) 
	.q:($d(^DHCACD("AccM",myAccRowID))=10)
	.s myIdx=+myIdx+1
	.s myAccountNo=$p($g(^DHCACD("AccM",myAccRowID)),"^",1)				;AccM_AccountNo
	.q:((AccNo'="")&&(myAccountNo'=AccNo))
	.s myPAPMIDR=$p($g(^DHCACD("AccM",myAccRowID)),"^",2)				;AccM_PAPMI_DR
	.s myPatName=$p($g(^PAPER(myPAPMIDR,"ALL")),"^", 1)
	.q:(PatNameA'="")&(PatNameA'=myPatName)
	.s myDOB=$p($g(^PAPER(myPAPMIDR,"ALL")),"^", 6)
	.s mySexDR=$p($g(^PAPER(myPAPMIDR,"ALL")),"^", 7)
	.s mySexN=$g(mySexN)
	.i mySexDR'="" d
	..i $d(^CT("SEX",mySexDR)) d
	...s mySexN=$p($g(^CT("SEX",mySexDR)),"^",2)
	.s myPAPMINo=$p($g(^DHCACD("AccM",myAccRowID)),"^",3)				;AccM_PAPMINo
	.q:((PAPMINo'="")&&(PAPMINo'=myPAPMINo))
	.s myCardNo=$p($g(^DHCACD("AccM",myAccRowID)),"^",4)				;AccM_CardNo
	.q:((CardNo'="")&&(CardNo'=myCardNo))
	.s myOCDate=$p($g(^DHCACD("AccM",myAccRowID)),"^",5)				;AccM_OCDate
	.s myOCTime=$p($g(^DHCACD("AccM",myAccRowID)),"^",6)	;AccM_OCTime
	.s myCDate=$zd(myOCDate,3)_" "_$zt(myOCTime)
	.s myCUseDR=$p($g(^DHCACD("AccM",myAccRowID)),"^",7)	;AccM_CUser_DR
	.s myCUCode=$p($g(^SSU("SSUSR",myCUseDR)),"^",1)
	.q:((BUserCode'="")&&(BUserCode'=myCUCode))
	.q:((BUserCodeA'="")&&(BUserCodeA'=myCUCode))
	.s myCUseName=$p($g(^SSU("SSUSR",myCUseDR)),"^",2)
	.s myAccLeftSum=$p($g(^DHCACD("AccM",myAccRowID)),"^",8)	;AccM_Balance
	.s myAccLeftSum=$fn(myAccLeftSum,"",2)
	.s myWFDate=$p($g(^DHCACD("AccM",myAccRowID)),"^",9)	;AccM_WoffDate
	.s myWFTime=$p($g(^DHCACD("AccM",myAccRowID)),"^",10)	;AccM_WoffTime
	.s myWODate=""
	.i (myWFDate'="")&&(myWFTime) d
	..s myWODate=$zd(myWFDate,3)_" "_$zt(myWFTime)
	.s myDUseDR=$p($g(^DHCACD("AccM",myAccRowID)),"^",11)	;AccM_DUser_DR
	.s myWOUserName=""
	.i myDUseDR'="" d
	..s myWOUserName=$p($g(^SSU("SSUSR",myDUseDR)),"^",2)
	.s myAccStatus=$p($g(^DHCACD("AccM",myAccRowID)),"^",13)	;AccM_AccStatus
	.q:((AccStatus'="")&&(AccStatus'=myAccStatus))
	.if myAccStatus="N" s myAccStatusName="正常"
	.if myAccStatus="S" s myAccStatusName="挂起"
	.if myAccStatus="F" s myAccStatusName="结算"
	.s myAccType=$p($g(^DHCACD("AccM",myAccRowID)),"^",16)	;AccM_Type
	.q:((AccType'="")&&(AccType'=myAccType))
	.s myCredTDR=$p($g(^DHCACD("AccM",myAccRowID)),"^",17)	;AccM_CredType_DR 证件类型
	.s myCredName=""
	.s:(myCredTDR'="") myCredName=$p($g(^DHCACCCredType(myCredTDR)),"^",2)
	.;不显示证件号码AccStatus
	.;预交金
	.;^DHCACD("AccM",{DHC_AccManager.AccM_RowID},"AccPD",{AccPD_Sub})
	.s mySub=0
	.s myPreSum=0
	.s myRefPreSum=0
	.f  s mySub=$o(^DHCACD("AccM",myAccRowID,"AccPD",mySub)) q:(mySub="")  d
	..s myTmpSum=$p($g(^DHCACD("AccM",myAccRowID,"AccPD",mySub)),"^",2)
	..i +myTmpSum>0 d
	...s myPreSum=+myPreSum+myTmpSum
	..e  d
	...s myRefPreSum=+myRefPreSum+myTmpSum
	.s myPreSum=$fn(myPreSum,"",2)
	.s myRefPreSum=$fn(myRefPreSum,"",2)
	.;卡支付
	.;^DHCACD("AccM",{DHC_AccManager.AccM_RowID},"AccPL",{AccPL_Sub})
	.s mySub=0
	.s myPayNum=0
	.f  s mySub=$o(^DHCACD("AccM",myAccRowID,"AccPL",mySub)) q:(mySub="")  d
	..s myPayNum=+myPayNum+$p($g(^DHCACD("AccM",myAccRowID,"AccPL",mySub)),"^",8)
	.s myAccPaySum=$fn(myPayNum,"",2)
	.;取出卡号
	.s myCardNo=""
	.;^DHCCARDi("CF",0,"AccNoDR",{CF_AccNo_DR},{CF_RowID})
	.s myCFRowID=0
	.f  s myCFRowID=$o(^DHCCARDi("CF",0,"AccNoDR",myAccRowID,myCFRowID))  q:(myCFRowID="")  d
	..s myCardFlag=$p(^DHCCARD("CF",myCFRowID),"^",10)
	..q:(myCardFlag'="N")
	..s myCardNo=$p(^DHCCARD("CF",myCFRowID),"^",2)
	.s myUnPrintSum=+$g(^CacheTemp(0,$j,"ACCQ",myAccRowID,"PatSum"))
	.s myUnPrintSum=$fn(myUnPrintSum,"", 2)
	.s myPreTSum=+myPreTSum+myPreSum
	.s myRefPreTSum=+myRefPreTSum+myRefPreSum
	.s myAccPayTSum=+myAccPayTSum+myAccPaySum
	.s myAccLeftTSum=+myAccLeftTSum+myAccLeftSum
	.s myUnPrintTSum=+myUnPrintTSum+myUnPrintSum
	.Do OutputRow
	
	;合计
	d ValidateData
	s myIdx=ind
	s myPatName="合计"
	s myPreSum=$fn(+myPreTSum,"",2)
	s myRefPreSum=$fn(+myRefPreTSum,"",2)
	s myAccPaySum=$fn(+myAccPayTSum,"",2)
	s myAccLeftSum=$fn(+myAccLeftTSum,"",2)
	s myUnPrintSum=$fn(myUnPrintTSum,"",2)
	i ((+myPreSum'=0)||(+myRefPreSum'=0)||(+myAccPaySum'=0)||(+myAccLeftSum'=0)||(+myUnPrintTSum'=0)) d
	.Do OutputRow
	
	k ^CacheTemp(0,$j,"ACCQ")
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(myIdx,myAccountNo, myPatName, mySexN, myPreSum, myRefPreSum,myAccPaySum , myAccLeftSum, myAccStatusName, myCDate,myWOUserName,myWODate,myPAPMINo,myCredName,myCUseName, myTMPGID, myCardNo, myAccRowID, myUnPrintSum)
	Set ^CacheTemp(repid,ind)=Data
	s myTMPData=##class(web.DHCOPConfig).TransLBToStr(Data)
	s ^TMPOPPrintOut(myTMPGID,ind)=myTMPData
	Set ind=ind+1
	quit
ValidateData
	s (myIdx,myAccountNo, myPatName, mySexN, myPreSum, myRefPreSum,myAccPaySum , myAccLeftSum, myAccStatusName, myCDate,myWOUserName , myWODate, myPAPMINo, myCredName, myUnPrintSum)=""
	s myCardNo=""
	quit
}

ClassMethod SetPatAccPayList(AccRowID As %String = "") As %String
{
	;把患者的支付设置为一个^TMP ]
	;用来帮助患者自助查询/或打印
	;w ##class(web.UDHCACPayList).SetPatAccPayList("112")
	q:(AccRowID="") 0
	
	;用于患者的自助查询；提供一个按照时间的循序排序
	;^TMPAccPat("Acc",$j,Date,Time)=rowID
	;^DHCACD("AccM",{DHC_AccManager.AccM_RowID},"AccPL",{AccPL_Sub})
	s myPLSub=0
	s myPaySum=0
	f  s myPLSub=$o(^DHCACD("AccM",AccRowID,"AccPL",myPLSub)) q:(myPLSub="")  d
	.q:($d(^DHCACD("AccM",AccRowID,"AccPL",myPLSub))=10)
	.;序号  交易时间  交易类型  金额  操作员  单据号 
	.s myPLDate=$p(^DHCACD("AccM",AccRowID,"AccPL",myPLSub),"^",6)
	.s myPLTime=$p(^DHCACD("AccM",AccRowID,"AccPL",myPLSub),"^",7)
	.s myDate=$zd(myPLDate,3)_" "_$zt(myPLTime)
	.s myPLPayNum=$p(^DHCACD("AccM",AccRowID,"AccPL",myPLSub),"^",8)
	.i (+myPLPayNum>0) d
	..s myPLTypeDesc="卡支付"
	.e  d
	..s myPLTypeDesc="卡支付退费"
	.s myUserDesc=""
	.s myUserDR=$p(^DHCACD("AccM",AccRowID,"AccPL",myPLSub),"^",5)
	.s:(myUserDR'="") myUserDesc=$p(^SSU("SSUSR",myUserDR),"^",2)
	.s myBillNo=$p(^DHCACD("AccM",AccRowID,"AccPL",myPLSub),"^",4)
	.s myPLLeft=$p(^DHCACD("AccM",AccRowID,"AccPL",myPLSub),"^",9)
	.s myPRTRowID=$p(^DHCACD("AccM",AccRowID,"AccPL",myPLSub),"^",2)		;AccPL_InvPrt_DR
	.s myPRTINVFlag=$p(^DHCINVPRT(myPRTRowID),"^",3)			;PRT_INVPrintFlag
	.q:(myPRTINVFlag="P")
	.s myINVNo=""
	.s myPRTFlag=$p(^DHCINVPRT(myPRTRowID),"^",8)
	.q:(myPRTFlag'="N")
	.i myPRTINVFlag="P" d
	..s myINVNo=$p(^DHCINVPRT(myPRTRowID),"^",14)
	..q:(myINVNo'="")
	..s myAccINVDR=$p(^DHCINVPRT(myPRTRowID),"^",4)
	..q:(myAccINVDR="")
	..s myINVNo=$p(^DHCINVPRTAP(myAccINVDR),"^",6)
	.s myPLRowID=AccRowID_"||"_myPLSub
	.;写DHC_INVPRT表的RowID
	.
	.;增加一个子节点，防止同一时间；,DHCWeb.OPCommon.js
	.s mySub=""
	.s mySub=$o(^TMPAccPat("Acc",$j,myPLDate,myPLTime,mySub),-1)
	.s mySub=+$g(mySub)+1
	.s ^TMPAccPat("Acc",$j,myPLDate,myPLTime, mySub)=myDate_"^"_myPLTypeDesc_"^"_myPLPayNum_"^"_myUserDesc_"^"_myBillNo_"^"_myPLLeft_"^PL^"_myPRTRowID_"^"_myINVNo
	
	b
	q 0
}

ClassMethod ReadPatAccListExecute(ByRef qHandle As %Binary, AccRowID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	;查询每个账户的账目变化情况，可以给患者提供清单
	;同时，可以利用触摸屏来查询；
	;d ##class(%ResultSet).RunQuery("web.UDHCAccManageCLS","ReadPatAccList","121")
	
	s (No, APDate, APType,AccSum, AccUser,ABillNo,ALeft, myINVNo)=""
	
	k ^TMPAccPat("Acc",$j)
	
	;s rtn=##class(web.UDHCAccAddDeposit).SetPreDepositList(AccRowID)
	
	s rtn=..SetPatAccPayList(AccRowID)
	
	;No, APDate, APType,AccSum, AccUser,ABillNo,ALeft
	s myADate=""
	s myIdx=1
	f  s myADate=$o(^TMPAccPat("Acc",$j,myADate),-1) q:(myADate="")  d
	.q:(myADate=0)
	.s myATime=""
	.f  s myATime=$o(^TMPAccPat("Acc",$j,myADate, myATime),-1) q:(myATime="")  d
	..q:(myATime=0)
	..s mySub=""
	..f  s mySub=$o(^TMPAccPat("Acc",$j,myADate, myATime, mySub),-1) q:(mySub="")  d
	...q:(mySub=0)
	...s No=myIdx
	...s APDate=$p(^TMPAccPat("Acc",$j,myADate, myATime, mySub),"^",1)
	...s APType=$p(^TMPAccPat("Acc",$j,myADate, myATime, mySub),"^",2)
	...s AccSum=$p(^TMPAccPat("Acc",$j,myADate, myATime, mySub),"^",3)
	...s AccUser=$p(^TMPAccPat("Acc",$j,myADate, myATime, mySub),"^",4)
	...s ABillNo=$p(^TMPAccPat("Acc",$j,myADate, myATime, mySub),"^",5)
	...s ALeft=$p(^TMPAccPat("Acc",$j,myADate, myATime, mySub),"^",6)
	...s myFlag=$p(^TMPAccPat("Acc",$j,myADate, myATime, mySub),"^",7)
	...s myPRowID=$p(^TMPAccPat("Acc",$j,myADate, myATime, mySub),"^",8)
	...s myINVNo=$p($g(^TMPAccPat("Acc",$j,myADate, myATime, mySub)),"^",9)
	...Do OutputRowPLIST
	...s myIdx=+myIdx+1
	
	k ^TMPAccPat("Acc",$j)
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowPLIST
	set Data=$lb(No, APDate, APType,AccSum, AccUser,ABillNo,ALeft, myFlag, myPRowID, myINVNo)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ReadAccMListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadAccMListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ReadPatAccListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadPatAccListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query ReadAccMList(AccNo As %String, PAPMINo As %String, BUserCode As %String, CardNo As %String, AccStatus As %String, AccType As %String, StDate As %String, EndDate As %String, BUserCodeA As %String, PatNameA As %String, TMPGID As %String) As %Query(ROWSPEC = "No:%String,AccountNo:%String,PatName:%String,Sex:%String, PreSum:%String,RefPreSum:%String, AccPaySum:%String,AccLeftSum:%String,AccStatusName:%String,CDate:%String,WOUserName:%String,WODate:%String, PAPMINo:%String, CredName:%String, CUseName:%String, TMPGID:%String, CardNo:%String, AccRowID:%String, UnPrintSum:%String")
{
}

Query ReadPatAccList(AccRowID As %String = "") As %Query(ROWSPEC = "No:%String,APDate:%String,APType:%String,AccSum:%String,AccUser:%String,ABillNo:%String,ALeft:%String, Flag:%String, PRowID:%String, INVNo:%String")
{
}

}
