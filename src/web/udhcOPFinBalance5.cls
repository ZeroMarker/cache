Class web.udhcOPFinBalance5 Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 67;

ClassMethod CMergeFINV(HISRowID As %String, myUDR As %String) As %String
{
	;通用的结算发票合并算法，把记录写到^TMP中
	;形成的^TMPOPINVINSFootRep格式
	;$j,$j(UserID),
	;w ##class(web.udhcOPFinBalance5).CMergeFINV("3",$j)
	n (HISRowID, myUDR)
	q:((HISRowID="")!(myUDR="")) 0
	
	s myRcptNoStr=$p($g(^DHCOPInsFoot(HISRowID)),"^",10)
	q:(myRcptNoStr="") 0
	
	s mylen=$l(myRcptNoStr,",")
	f i=1:1:mylen d
	.s myStr=$p(myRcptNoStr,",",i)
	.s myStr=##class(web.DHCOPCommonFunLib).Trim(myStr)
	.q:((myStr)="")
	.s myStRcpNo=$p(myStr,"--",1)
	.s myEndRcpNo=$p(myStr,"--",2)
	.;看看存在的数据段是否能够容纳
	.s myINVIdx=0
	.s myInFlag=0
	.f  s myINVIdx=$o(^TMPOPINVINSFootRep($j,myUDR,"INVNo", myINVIdx))  q:((myINVIdx="")!(myInFlag=1))  d
	..s myTMPStNo=$o(^TMPOPINVINSFootRep($j,myUDR,"INVNo", myINVIdx, "ST",""))
	..s myTMPEndNo=$o(^TMPOPINVINSFootRep($j,myUDR,"INVNo", myINVIdx, "End",""))
	..;b	;;;
	..;磨掉开始结束节点
	..i ((+myTMPStNo)=(+myEndRcpNo+1))&((+myTMPEndNo)=(+myStRcpNo-1)) d
	...k ^TMPOPINVINSFootRep($j,myUDR,"INVNo", myINVIdx, "ST",myTMPStNo)
	...k ^TMPOPINVINSFootRep($j,myUDR,"INVNo", myINVIdx, "End",myTMPEndNo)
	..;磨掉左节点
	..i ((+myTMPEndNo)=(+myStRcpNo-1))&(myInFlag=0) d
	...s myInFlag=1
	...k ^TMPOPINVINSFootRep($j,myUDR,"INVNo", myINVIdx, "End",myTMPEndNo)
	...s ^TMPOPINVINSFootRep($j,myUDR,"INVNo", myINVIdx, "End",myEndRcpNo)=myEndRcpNo
	..i ((+myTMPStNo)=(+myEndRcpNo+1))&(myInFlag=0) d
	...s myInFlag=1
	...k ^TMPOPINVINSFootRep($j,myUDR,"INVNo", myINVIdx, "ST",myTMPStNo)
	...s ^TMPOPINVINSFootRep($j,myUDR,"INVNo", myINVIdx, "ST",myTMPStNo)=myTMPStNo
	.q:(+myInFlag=1)
	.s myCurIndx=$i(^TMPOPINVINSFootRep($j,myUDR,"INVNo"))
	.s ^TMPOPINVINSFootRep($j,myUDR,"INVNo", myCurIndx, "ST",myStRcpNo)=myStRcpNo
	.s ^TMPOPINVINSFootRep($j,myUDR,"INVNo", myCurIndx, "End",myEndRcpNo)=myEndRcpNo
	
	;增加一个消除各个段之间的节点
	;即连接节点
	;算法：一定是把后面的节点连接到前面的节点上
	;连接左节点；数据结构的链表
	
	s myINVIdx=0
	f  s myINVIdx=$o(^TMPOPINVINSFootRep($j,myUDR,"INVNo", myINVIdx))  q:((myINVIdx=""))  d
	.s myLeftP=$o(^TMPOPINVINSFootRep($j,myUDR,"INVNo", myINVIdx, "ST",""))
	.;取其他段的右节点
	.s myRightIdx=myINVIdx
	.f  s myRightIdx=$o(^TMPOPINVINSFootRep($j,myUDR,"INVNo", myRightIdx))  q:(myRightIdx="")  d
	..q:(+myRightIdx=+myINVIdx)
	..s myRightP=$o(^TMPOPINVINSFootRep($j,myUDR,"INVNo", myRightIdx, "End",""))
	..s myRightBegP=$o(^TMPOPINVINSFootRep($j,myUDR,"INVNo", myRightIdx, "ST",""))
	..q:(+(myRightP+1)'=+myLeftP)
	..;左节点变为左节点
	..s ^TMPOPINVINSFootRep($j,myUDR,"INVNo", myINVIdx, "ST",myRightBegP)=myRightBegP
	..s ^TMPOPINVINSFootRep($j,myUDR,"INVNo")=$g(^TMPOPINVINSFootRep($j,myUDR,"INVNo"))-1
	..k ^TMPOPINVINSFootRep($j,myUDR,"INVNo", myRightIdx, "End",myRightP)
	..k ^TMPOPINVINSFootRep($j,myUDR,"INVNo", myRightIdx, "ST",myRightBegP)
	..k ^TMPOPINVINSFootRep($j,myUDR,"INVNo", myINVIdx, "ST",myLeftP)
	
	;连接右节点
	s myINVIdx=0
	f  s myINVIdx=$o(^TMPOPINVINSFootRep($j,myUDR,"INVNo", myINVIdx))  q:((myINVIdx=""))  d
	.s myRightP=$o(^TMPOPINVINSFootRep($j,myUDR,"INVNo", myINVIdx, "End",""))
	.;取其他段的右节点
	.s myLeftIdx=myINVIdx
	.f  s myLeftIdx=$o(^TMPOPINVINSFootRep($j,myUDR,"INVNo", myLeftIdx))  q:(myLeftIdx="")  d
	..q:(+myLeftIdx=+myINVIdx)
	..s myLeftP=$o(^TMPOPINVINSFootRep($j,myUDR,"INVNo", myLeftIdx, "ST",""))
	..s myLeftEndP=$o(^TMPOPINVINSFootRep($j,myUDR,"INVNo", myLeftIdx, "End",""))
	..q:(+(myLeftP)'=+(myRightP+1))
	..;右节点变右节点
	..s ^TMPOPINVINSFootRep($j,myUDR,"INVNo", myINVIdx, "End",myLeftEndP)=myLeftEndP
	..s ^TMPOPINVINSFootRep($j,myUDR,"INVNo")=$g(^TMPOPINVINSFootRep($j,myUDR,"INVNo"))-1
	..k ^TMPOPINVINSFootRep($j,myUDR,"INVNo", myLeftIdx, "ST",myLeftP)
	..k ^TMPOPINVINSFootRep($j,myUDR,"INVNo", myLeftIdx, "End",myLeftEndP)
	..k ^TMPOPINVINSFootRep($j,myUDR,"INVNo", myINVIdx, "End",myRightP)
	
	
	q 0
}

/// /增加一个合并发票的算法；
/// /
ClassMethod KillTmp()
{
	k ^TMPOPHand($j)
	k ^TMPOPHandsub($j)
	k ^TMPCatSub($j)
	k ^TMPCatSubOther($j)
	k ^TMPOPCat($j)
	k ^TMPOPTARPAYMODE($j)
}

ClassMethod ReadFootINVInfo(StartDate As %String, EndDate As %String, UserRowID As %String) As %String
{
	n (StartDate,EndDate,UserRowID)
	;w ##class(web.udhcOPFinBalance5).ReadFootINVInfo("10/06/2006","17/10/2006","")
	
	s mystr=""
	
	i StartDate["/" s StartDate=$zdh(StartDate,4)
	i EndDate["/" s EndDate=$zdh(EndDate,4)
	
	i StartDate["-" s StartDate=$zdh(StartDate,3)
	i EndDate["-" s EndDate=$zdh(EndDate,3)
	
	i StartDate="" s StartDate=+$h
	i EndDate="" s EndDate=+$h
	
	;^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	
	k ^TMPOPINVINSFootRep($j)
	
	s myFootAmount=0
	s myFootHandSum=0
	
	f mydate=StartDate:1:EndDate  d
	.s myHISRowID=0
	.f  s myHISRowID=$o(^DHCOPInsFootI(0,"Date",mydate, myHISRowID)) q:(myHISRowID="")  d
	..q:($d(^DHCOPInsFoot(myHISRowID))=10)
	..s myUserDR=$p(^DHCOPInsFoot(myHISRowID),"^",8)
	..q:((myUserDR'=UserRowID)&(UserRowID'=""))
	..s myrtn=..CMergeFINV(myHISRowID,$j)
	..s myFootAmount=+$g(myFootAmount)+$p(^DHCOPInsFoot(myHISRowID),"^",1)
	..s myFootHandSum=+$g(myFootHandSum)+$p(^DHCOPInsFoot(myHISRowID),"^",16)
	
	s INVRepNo=""
	s myTMPIdx=0
	f  s myTMPIdx=$o(^TMPOPINVINSFootRep($j,$j,"INVNo", myTMPIdx)) q:(myTMPIdx="")  d
	.s myTMPSTNo=$o(^TMPOPINVINSFootRep($j,$j,"INVNo", myTMPIdx, "ST",""))
	.s myTMPEndNo=$o(^TMPOPINVINSFootRep($j,$j,"INVNo", myTMPIdx, "End",""))
	.s INVRepNo=INVRepNo_" "_myTMPSTNo_"--"_myTMPEndNo_","
	
	b		;;;
	k ^TMPOPINVINSFootRep($j)
	
	s myrtn=INVRepNo_"^"_myFootAmount_"^"_myFootHandSum
	
	q myrtn
}

ClassMethod ReadUSEFootECCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadUSEFootECCatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

///   /西安门诊报表
ClassMethod ReadUSEFootECCatExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, UserRowID As %String) As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;w ##class(%ResultSet).RunQuery("web.udhcOPFinBalance5","ReadUSEFootECCat",+$h-30,+$h,"")
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	d ..KillTmp()
	
	d ResetVariablesFR
	s StartDate=$g(StartDate)
	s EndDate=$g(EndDate)
	i StartDate="" d  s StartDate=+$h
	i EndDate="" d  s EndDate=+$h
	
	s myPrtRowID=0
	;s myUserDR=$p($g(^DHCOPInsFoot(RepID)),"^",8)
	
	;;替代一个节点问题
	s myUserDR=$j
	
	s myrtn=##class(udhcOPHandin5).GetOECCat(myUserDR)
	
	;^DHCINVPRT(0,"Report",{PRT_DHCINVPRTR_DR},{PRT_Rowid})
	;^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	f myDate=StartDate:1:EndDate d
	.;UserRowID
	.s myHISRowID=0
	.f  s myHISRowID=$o(^DHCOPInsFootI(0,"Date",myDate,myHISRowID)) q:(myHISRowID="")  D
	..s myHISUDR=$p(^DHCOPInsFoot(myHISRowID),"^",8)
	..q:((myHISUDR'=UserRowID)&(UserRowID'=""))
	..f  s myPrtRowID=$o(^DHCINVPRT(0,"Report",myHISRowID, myPrtRowID)) q:(myPrtRowID="")  d
	...d ##class(udhcOPHandin5).SetTarTOECat(myPrtRowID,myUserDR)
	b	;;
	;把得到的二维表传出；
	;^TMPOPTARPAYMODE($j, UserID, TECarRowID, PayModeDR)
	s myIdx=0
	s myTarRowID=0
	s myToHJ=0
	s myPatHJ=0
	s myRefCashHJ=0
	s myRefTCHJ=0
	s myCashHJ=0
	s myTCHJ=0
	f  s myTarRowID=$o(^TMPOPTARPAYMODE($j, myUserDR,myTarRowID)) q:(myTarRowID="")  d
	.;支付模式
	.s myPMDR=0
	.s myTECDesc=$g(^TMPOPTARPAYMODE($j, myUserDR,myTarRowID))
	.s myToSum=+$g(^TMPOPTARPAYMODE($j,"PT", myUserDR,myTarRowID, "TP"))		;支付全额
	.s myToHJ=+myToHJ+myToSum
	.s myPatSum=+$g(^TMPOPTARPAYMODE($j,"PT",myUserDR,myTarRowID, "PP"))		;患者支付额
	.s myPatHJ=myPatHJ+myPatSum
	.s myRefCashSum=0
	.s myRefTCSum=0
	.s myCashSum=0
	.s myTCSum=0
	.f  s myPMDR=$o(^TMPOPTARPAYMODE($j, myUserDR,myTarRowID, myPMDR)) q:(myPMDR="")  d
	..s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	..s myPMDesc=$p(^CT("CTPM",myPMDR),"^",2)
	..i myPMCode="CASH" d
	...;现金
	...s myCashSum=$g(myCashSum)+$g(^TMPOPTARPAYMODE($j, myUserDR, myTarRowID, myPMDR, "N"))
	...s myRefCashSum=$g(myRefCashSum)+$g(^TMPOPTARPAYMODE($j, myUserDR, myTarRowID, myPMDR, "A"))
	..e  d
	...;统筹
	...s myTCSum=$g(myTCSum)+$g(^TMPOPTARPAYMODE($j, myUserDR, myTarRowID, myPMDR, "N"))
	...s myRefTCSum=$g(myRefTCSum)+$g(^TMPOPTARPAYMODE($j, myUserDR, myTarRowID, myPMDR, "A"))
	.s myRefCashHJ=myRefCashHJ+myRefCashSum
	.s myRefTCHJ=myRefTCHJ+myRefTCSum
	.s myCashHJ=myCashHJ+myCashSum
	.s myTCHJ=myTCHJ+myRefTCSum
	.s myIdx=myIdx+1
	.s myToSum=$fn(myToSum,"",2)
	.s myRefCashSum=$fn(myRefCashSum,"",2)
	.s myRefTCSum=$fn(myRefTCSum,"",2)
	.s myCashSum=$fn(myCashSum,"",2)
	.s myTCSum=$fn(+myTCSum,"",2)
	.s myPatSum=$fn(myPatSum,"",2)
	.s No=myIdx
	.d OutputFR
	.
		
	;合计
	;
	d ResetVariablesFR
	
	s myTECDesc="合计"
	s myToSum=myToHJ
	s myRefCashSum=myRefCashHJ
	s myRefTCHJ=myRefTCSum
	s myCashSum=myCashHJ
	s myTCSum=myTCHJ
	s myPatSum=myPatHJ
	
	d OutputFR

	d ..KillTmp()
	
	Quit $$$OK
ResetVariablesFR
	s (No, myTECDesc,myToSum,myRefCashSum,myRefTCSum,myCashSum, myTCSum, myPatSum)=""
	quit
OutputFR
	s Data=$lb(No, myTECDesc,myToSum,myRefCashSum,myRefTCSum,myCashSum, myTCSum, myPatSum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod ReadUSEFootECCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadUSEFootECCatExecute ]
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

Query ReadUSEFootECCat(StartDate As %String, EndDate As %String, UserRowID As %String) As %Query(ROWSPEC = "No:%String,TTarName:%String,TTotalSum:%String,TRefCashSum:%String,TRefTCSum:%String,TCashSum:%String,TTCSum:%String,TSum:%String")
{
}

}
