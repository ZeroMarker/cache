Class web.udhcOPFinBalance6 Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 113;

/// //上海华山医院专用查询
/// //
ClassMethod CMergeRegINV(OPHISRowID As %String, myUDR As %String) As %String
{
	;拆分挂号的发票段
	;形成的^TMPOPINVINSFootRep格式
	;$j,$j(UserID),
	;w ##class(web.udhcOPFinBalance5).CMergeFINV("3",$j)
	n (OPHISRowID, myUDR)
	q:((OPHISRowID="")!(myUDR="")) 0
	
	;^DHCOPRegInvReports({OPHIS_Rowid})
	s myRcptNoStr=$p($g(^DHCOPRegInvReports(OPHISRowID)),"^",38)
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

ClassMethod ReadFootSum(BDate As %String = "", EDate As %String = "") As %String
{
	;w ##class(web.udhcOPFinBalance4).ReadFootSum("12/11/2006","14/11/2006")
	n (JSFunName, BDate, EDate)
	d ..KillTMP()
	
	;生成Global
	
	i BDate["/" d
	.s BDate=$zdh(BDate,4)
	i EDate["/" d
	.s EDate=$zdh(EDate,4)
	s myDate=BDate-1
	
	s myLen=0
	s itmrowid=0 f  s itmrowid=$o(^DHCTarC("TOC",itmrowid)) q:itmrowid=""  d
	.s itm=$p(^DHCTarC("TOC",itmrowid),"^",2)
	.s myLen=myLen+1
	
	;^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	f  s myDate=$o(^DHCOPInsFootI(0,"Date",myDate)) q:((myDate="")!(myDate>EDate))  d
	.s myHisRowID=""
	.f  s myHisRowID=$o(^DHCOPInsFootI(0,"Date",myDate,myHisRowID)) q:(myHisRowID="")  d
	..s myTime=$p(^DHCOPInsFoot(myHisRowID),"^",7)
	..;q:((myDate=BDate)&&(myTime<BTime))
	..;q:((myDate=EDate)&&(myTime>ETime))
	..s myINSFDate=$p(^DHCOPInsFoot(myHisRowID),"^",13)
	..;q:(myINSFDate'="")
	..d ..GetFinFootRefundData(myHisRowID)
	..d ..GetFinFootDataByPM(myHisRowID)
	..s myUserDR=$p(^DHCOPInsFoot(myHisRowID),"^",8)
	..s myUserName=$p(^SSU("SSUSR",myUserDR),"^",2)
	..s ^TMPOPFOper($j,myUserDR)=myUserName
	..
	..s myCashSum=+$g(^TMPOPFOper($j,myUserDR,"Cash"))
	..s myCheckSum=+$g(^TMPOPFOper($j, myUserDR,"Check"))
	..s myCredPaySum=+$g(^TMPOPFOper($j, myUserDR,"CredPay"))
	..s myOtherPaySum=+$g(^TMPOPFOper($j, myUserDR,"OtherPay"))
	..s myYBPaySum=+$g(^TMPOPFOper($j, myUserDR,"YBSum"))
	..s myJZSum=+$g(^TMPOPFOper($j, myUserDR,"JIZHANG"))
	..s ^TMPOPFOper($j, myUserDR,"Sum")=+myCashSum+myCheckSum+myCredPaySum+myOtherPaySum+myYBPaySum+myJZSum
	..s myTotalSum=+$p(^DHCOPInsFoot(myHisRowID),"^",1)		;HIS_Amount
	..s ^TMPOPFOper($j, myUserDR,"TotalSum")=+$g(^TMPOPFOper($j, myUserDR,"TotalSum"))+myTotalSum
	..s myPatPaySum=+$p(^DHCOPInsFoot(myHisRowID),"^",16)		;HIS_Amount
	..s ^TMPOPFOper($j, myUserDR,"PatPaySum")=+$g(^TMPOPFOper($j, myUserDR,"PatPaySum"))+myPatPaySum
	..s myRoundSum=+$p(^DHCOPInsFoot(myHisRowID),"^",29)		;
	..s ^TMPOPFOper($j, myUserDR,"RoundSum")=+$g(^TMPOPFOper($j, myUserDR,"RoundSum"))+myRoundSum
	
	;累加挂号；
	d ..GetRegFinFootData(BDate, EDate)
	
	;累加金额
	s myCashSum=0
	s myCheckSum=0
	s myCredPaySum=0
	s myOtherPaySum=0
	s myTSum=0
	s myYBSum=0
	s myHospYHSum=0
	s myRoundSum=0
	
	s myUserDR=""
	f  s myUserDR=$o(^TMPOPFOper($j,myUserDR)) q:(myUserDR="")  d
	.s myCashSum=+$g(myCashSum)++$g(^TMPOPFOper($j, myUserDR,"Cash"))
	.s myCheckSum=+$g(myCheckSum)+$g(^TMPOPFOper($j, myUserDR,"Check"))
	.s myCredPaySum=+$g(myCredPaySum)+$g(^TMPOPFOper($j, myUserDR,"CredPay"))
	.s myOtherPaySum=+$g(myOtherPaySum)+$g(^TMPOPFOper($j, myUserDR,"OtherPay"))
	.s myTSum=$g(myTSum)+$g(^TMPOPFOper($j, myUserDR,"Sum"))
	.s myYBSum=myYBSum+$g(^TMPOPFOper($j, myUserDR,"YBSum"))
	.s myHospYHSum=myHospYHSum+$g(^TMPOPFOper($j, myUserDR,"TotalSum"))
	.s myHospYHSum=myHospYHSum-$g(^TMPOPFOper($j, myUserDR,"PatPaySum"))
	.s myRoundSum=myRoundSum+$g(^TMPOPFOper($j, myUserDR,"RoundSum"))
	
	s myCashSum=$fn(myCashSum,"",2)
	s myCheckSum=$fn(myCheckSum,"",2)
	s myCredPaySum=$fn(myCredPaySum,"",2)
	s myOtherPaySum=$fn(myOtherPaySum,"",2)
	s myTSum=$fn(myTSum-myRoundSum,"",2)
	s myYBSum=$fn(myYBSum,"",2)
	s myHospYHSum=$fn(myHospYHSum,"",2)
	s myRoundSum=$fn(myRoundSum,"",2)
	
	d ..KillTMP()
	
	q 0_"^"_myCashSum_"^"_myCheckSum_"^"_myCredPaySum_"^"_myOtherPaySum_"^"_myTSum_"^"_myLen_"^"_myHospYHSum_"^"_myYBSum_"^"_myRoundSum
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
	s myFootINVNum=0
	
	f mydate=StartDate:1:EndDate  d
	.s myHISRowID=0
	.f  s myHISRowID=$o(^DHCOPInsFootI(0,"Date",mydate, myHISRowID)) q:(myHISRowID="")  d
	..q:($d(^DHCOPInsFoot(myHISRowID))=10)
	..s myUserDR=$p(^DHCOPInsFoot(myHISRowID),"^",8)
	..q:((myUserDR'=UserRowID)&(UserRowID'=""))
	..s myrtn=##class(web.udhcOPFinBalance5).CMergeFINV(myHISRowID,UserRowID)
	..s myFootAmount=+$g(myFootAmount)+$p(^DHCOPInsFoot(myHISRowID),"^",1)
	..s myFootHandSum=+$g(myFootHandSum)+$p(^DHCOPInsFoot(myHISRowID),"^",16)
	..s myFootINVNum=$g(myFootINVNum)+$p(^DHCOPInsFoot(myHISRowID),"^",9)		;His_Num
	
	;加入挂号
	f mydate=StartDate:1:EndDate  d
	.s myHISRowID=0
	.;^DHCOPRegInvReports(0,"Date",{OPHIS_Date},{OPHIS_Rowid})
	.f  s myHISRowID=$o(^DHCOPRegInvReports(0,"Date",mydate,myHISRowID)) q:(myHISRowID="")  d
	..q:($d(^DHCOPRegInvReports(myHISRowID))=10)
	..s myUserDR=$p((^DHCOPRegInvReports(myHISRowID)),"^",45)
	..q:((myUserDR'=UserRowID)&(UserRowID'=""))
	..;为挂号准备的
	..s myrtn=##class(web.udhcOPFinBalance6).CMergeRegINV(myHISRowID,UserRowID)
	..s myFootAmount=$g(myFootAmount)+$p((^DHCOPRegInvReports(myHISRowID)),"^",1)
	..s myFootHandSum=$g(myFootHandSum)+$p((^DHCOPRegInvReports(myHISRowID)),"^",1)
	..s myFootINVNum=$g(myFootINVNum)+$p((^DHCOPRegInvReports(myHISRowID)),"^",31)
	
	s INVRepNo=""
	s myTMPIdx=0
	f  s myTMPIdx=$o(^TMPOPINVINSFootRep($j,UserRowID,"INVNo", myTMPIdx)) q:(myTMPIdx="")  d
	.s myTMPSTNo=$o(^TMPOPINVINSFootRep($j,UserRowID,"INVNo", myTMPIdx, "ST",""))
	.s myTMPEndNo=$o(^TMPOPINVINSFootRep($j,UserRowID,"INVNo", myTMPIdx, "End",""))
	.s INVRepNo=INVRepNo_" "_myTMPSTNo_"--"_myTMPEndNo_","
	
	;b		;;;
	k ^TMPOPINVINSFootRep($j)
	
	s myrtn=INVRepNo_"^"_myFootAmount_"^"_myFootHandSum_"^"_myFootINVNum
	
	q myrtn
}

ClassMethod KillTMP() As %String
{
	k ^TMPOPFOper($j)
	k ^TMPTar($j)
	k ^TMPItmCat($j)
}

ClassMethod ReadOPUSEFootClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadOPUSEFootExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReadOPUSEFootExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String) As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;w ##class(%ResultSet).RunQuery("web.udhcOPFinBalance6","ReadOPUSEFoot",+$h-30,+$h)
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;生成Global
	
	k ^TMPOPFOper($j)
	
	i StDate["/" d
	.s StDate=$zdh(StDate,4)
	i EndDate["/" d
	.s EndDate=$zdh(EndDate,4)
	s myDate=StDate-1
	
	s myLen=0
	
	s HISAmountSum=0
	s FCash=0
	s FCheck=0
	s FPOSum=0
	s FPOSSum=0
	s FYLSum=0
	s FQFSum=0
	s FXJSum=0
	s HISINVNum=0
	
	;生成Global
	
	d ResetVariables
	;^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	f  s myDate=$o(^DHCOPInsFootI(0,"Date",myDate)) q:((myDate="")!(myDate>EndDate))  d
	.s myHisRowID=""
	.f  s myHisRowID=$o(^DHCOPInsFootI(0,"Date",myDate,myHisRowID)) q:(myHisRowID="")  d
	..s myTime=$p(^DHCOPInsFoot(myHisRowID),"^",7)
	..s myFCash=0
	..s myFCheck=0
	..s myFPOSum=0
	..s myFPOSSum=0
	..s myFYLSum=0
	..s myFQFSum=0
	..s myFXJSum=0
	..s myUserDR=$p(^DHCOPInsFoot(myHisRowID),"^",8)
	..s myUserName=$p(^SSU("SSUSR",myUserDR),"^",2)
	..s myUserCode=$p(^SSU("SSUSR",myUserDR),"^",1)
	..s ^TMPOPFOper($j,myUserDR,"UI","UserCode")=myUserCode
	..s ^TMPOPFOper($j,myUserDR,"UI","UserUserName")=myUserName
	..;s myCashSum=$p(^DHCOPInsFoot(myHisRowID),"^",18)
	..;查找支付模式PayMode
	..;^DHCOPInsFoot(RowID,"P",{HisPay_ChildSub})
	..s myPMSub=0
	..f  s myPMSub=$o(^DHCOPInsFoot(myHisRowID,"P",myPMSub))  q:(myPMSub="")  d
	...s myPMDR=$p(^DHCOPInsFoot(myHisRowID,"P",myPMSub),"^",2)		;HisPay_Paymode
	...s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)			;PMCode
	...s myAmtSum=$p(^DHCOPInsFoot(myHisRowID,"P",myPMSub),"^",1)		;HisPay_Acount
	...s myRefSum=$p(^DHCOPInsFoot(myHisRowID,"P",myPMSub),"^",4)		;HisPay_Refundsum
	...;现金
	...i myPMCode="CASH" d
	....s myFCash=+myFCash+myAmtSum+myRefSum
	....s ^TMPOPFOper($j,myUserDR,"PM","CASH")=+$g(^TMPOPFOper($j,myUserDR,"PM","CASH"))+myAmtSum+myRefSum
	...;支票
	...i myPMCode="CHEQUES" d
	....s myFCheck=+myFCheck+myAmtSum+myRefSum
	....s ^TMPOPFOper($j,myUserDR,"PM","CHEQUES")=+$g(^TMPOPFOper($j,myUserDR,"PM","CHEQUES"))+myAmtSum+myRefSum
	...;汇票
	...i myPMCode="PO" d
	....s myFPOSum=+myFPOSum+myAmtSum+myRefSum
	....s ^TMPOPFOper($j,myUserDR,"PM","PO")=+$g(^TMPOPFOper($j,myUserDR,"PM","PO"))+myAmtSum+myRefSum
	...;POS
	...i myPMCode="POS" d
	....s myFPOSSum=+myFPOSSum+myAmtSum+myRefSum
	....s ^TMPOPFOper($j,myUserDR,"PM","POS")=+$g(^TMPOPFOper($j,myUserDR,"PM","POS"))+myAmtSum+myRefSum
	...;银联
	...i myPMCode="YINLIAN" d
	....s myFYLSum=+myFYLSum+myAmtSum+myRefSum
	....s ^TMPOPFOper($j,myUserDR,"PM","YINLIAN")=+$g(^TMPOPFOper($j,myUserDR,"PM","YINLIAN"))+myAmtSum+myRefSum
	...;欠费
	...i myPMCode="JIZHANG" d
	....s myFQFSum=+myFQFSum+myAmtSum+myRefSum
	....s ^TMPOPFOper($j,myUserDR,"PM","JIZHANG")=+$g(^TMPOPFOper($j,myUserDR,"PM","JIZHANG"))+myAmtSum+myRefSum
	...;小计
	...s myFXJSum=+myFXJSum+myFCash+myFCheck+myFPOSum+myFPOSSum+myFYLSum+myFQFSum
	...s ^TMPOPFOper($j,myUserDR,"PM","XJ")=+$g(^TMPOPFOper($j,myUserDR,"PM","XJ"))+myAmtSum+myRefSum
	..;^DHCOPInsFoot({HIS_Rowid})
	..s myHISAmountSum=$p(^DHCOPInsFoot(myHisRowID),"^",1)
	..s myHISAmountSum=+myHISAmountSum+$p(^DHCOPInsFoot(myHisRowID),"^",29)
	..s ^TMPOPFOper($j,myUserDR,"UI","AMTSUM")=+$g(^TMPOPFOper($j,myUserDR,"UI","AMTSUM"))+myHISAmountSum
	..;s myHISINVRange=$p(^DHCOPInsFoot(myHisRowID),"^",10)
	..;s myHISINVNum=$p(^DHCOPInsFoot(myHisRowID),"^",9)
	
    f k=StDate:1:EndDate d
	.s myHisRowID=0 for  s myHisRowID=$o(^DHCOPRegInvReports(0,"Date",k,myHisRowID)) q:myHisRowID=""  d
	..s myUserDR=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",45)
	..s myUserName=$p(^SSU("SSUSR",myUserDR),"^",2)
	..s myUserCode=$p(^SSU("SSUSR",myUserDR),"^",1)
	..s ^TMPOPFOper($j,myUserDR,"UI","UserCode")=myUserCode
	..s ^TMPOPFOper($j,myUserDR,"UI","UserUserName")=myUserName
	..s myHISAmountSum=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",1)
	..;s myHISINVRange=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",38)
	..;s myHISINVNum=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",31)
	..;s HISINVNum=HISINVNum+myHISINVNum
	..;s HISAmountSum=HISAmountSum+$fn(myHISAmountSum,"",2)
	..s ^TMPOPFOper($j,myUserDR,"PM","CASH")=+$g(^TMPOPFOper($j,myUserDR,"PM","CASH"))+myHISAmountSum
	..s ^TMPOPFOper($j,myUserDR,"PM","XJ")=+$g(^TMPOPFOper($j,myUserDR,"PM","XJ"))+myHISAmountSum
	..s ^TMPOPFOper($j,myUserDR,"UI","AMTSUM")=+$g(^TMPOPFOper($j,myUserDR,"UI","AMTSUM"))+myHISAmountSum
	
	;Merg INV
	;^TMPOPFOper($j,myUserDR
	s myUserDR=0
	f  s myUserDR=$o(^TMPOPFOper($j,myUserDR)) q:(myUserDR="")  d
	.s myrtn=..ReadFootINVInfo(StDate, EndDate, myUserDR)
	.s ^TMPOPFOper($j,myUserDR,"UI","INVRange")=$p(myrtn,"^",1)
	.s ^TMPOPFOper($j,myUserDR,"UI","INVNum")=+$p(myrtn,"^",4)
	.s myUserCode=$g(^TMPOPFOper($j,myUserDR,"UI","UserCode"))
	.s myUserName=$g(^TMPOPFOper($j,myUserDR,"UI","UserUserName"))
	.s myHISAmountSum=+$g(^TMPOPFOper($j,myUserDR,"UI","AMTSUM"))
	.s myHISINVNum=+$g(^TMPOPFOper($j,myUserDR,"UI","INVNum"))
	.s myHISINVRange=$g(^TMPOPFOper($j,myUserDR,"UI","INVRange"))
	.s myFCash=+$g(^TMPOPFOper($j,myUserDR,"PM","CASH"))
	.s myFCheck=+$g(^TMPOPFOper($j,myUserDR,"PM","CHEQUES"))
	.s myFPOSum=+$g(^TMPOPFOper($j,myUserDR,"PM","PO"))
	.s myFPOSSum=+$g(^TMPOPFOper($j,myUserDR,"PM","POS"))
	.s myFYLSum=+$g(^TMPOPFOper($j,myUserDR,"PM","YINLIAN"))
	.s myFQFSum=+$g(^TMPOPFOper($j,myUserDR,"PM","JIZHANG"))
	.s myFXJSum=+$g(^TMPOPFOper($j,myUserDR,"PM","XJ"))
	.s HISINVNum=HISINVNum+myHISINVNum
	.s HISAmountSum=HISAmountSum+$fn(myHISAmountSum,"",2)
	.s FCash=FCash+$fn(myFCash,"",2)
	.s FCheck=FCheck+$fn(myFCheck,"",2)
	.s FPOSum=FPOSum+$fn(myFPOSum,"",2)
	.s FPOSSum=FPOSSum+$fn(myFPOSSum,"",2)
	.s FYLSum =FYLSum+$fn(myFYLSum,"",2) 
	.s FQFSum=FQFSum+$fn(myFQFSum,"",2)
	.s FXJSum=FXJSum+$fn(myFXJSum,"",2)
	.b		;;;;Foot
	.d FormatData
	.d Output
	
	;..d FormatData
	;..d Output
	
	;增加合计
	
	d ResetVariables
	
	s myHISAmountSum=$fn(HISAmountSum,"",2)
	s myFCash=$fn(FCash,"",2)
	s myFCheck=$fn(FCheck,"",2)
	s myFPOSum=$fn(FPOSum,"",2)
	s myFPOSSum=$fn(FPOSSum,"",2)
	s myFYLSum =$fn(FYLSum,"",2) 
	s myFQFSum=$fn(FQFSum,"",2)
	s myFXJSum=$fn(FXJSum,"",2)
	s myUserName="合计"
	s myHISINVNum=HISINVNum
	
	d Output
	
	k ^TMPOPFOper($j)
	
	Quit $$$OK
ResetVariables
	s (myUserCode,myUserName,myHISINVRange,myHISINVNum,myHISAmountSum, myFCash,myFCheck, myFPOSum,myFPOSSum, myFYLSum, myFQFSum, myFXJSum)=""
	quit
Output
	s Data=$lb(index, myUserCode,myUserName,myHISINVRange,myHISINVNum,myHISAmountSum, myFCash,myFCheck, myFPOSum,myFPOSSum, myFYLSum, myFQFSum, myFXJSum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
FormatData
	s myHISAmountSum=$fn(myHISAmountSum,"",2)
	s myFCash=$fn(myFCash,"",2)
	s myFCheck=$fn(myFCheck,"",2)
	s myFPOSum=$fn(myFPOSum,"",2)
	s myFPOSSum=$fn(myFPOSSum,"",2)
	s myFYLSum =$fn(myFYLSum,"",2) 
	s myFQFSum=$fn(myFQFSum,"",2)
	s myFXJSum=$fn(myFXJSum,"",2)
	q
}

ClassMethod GetFinFootDataByPM(HISRowID As %String) As %String
{
	;获取收费金额
	;w ##class(web.udhcOPFinBalance6).GetFinFootDataByPM(934)
	n (HISRowID)
	
	s mySub=0
	s mySub=$o(^DHCOPInsFoot(HISRowID,"P",mySub))
	while (mySub'="") {
		s myPMDR=$p(^DHCOPInsFoot(HISRowID,"P",mySub),"^",2)
		s myAmt=+$p(^DHCOPInsFoot(HISRowID,"P",mySub),"^",1)
		s myUserDR=$p(^DHCOPInsFoot(HISRowID),"^",8)
		if ((myPMDR'="")&(+myAmt'=0)){
			s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
			if ((myPMCode="CASH")!(myPMCode="CASHA")!(myPMCode="CASHB")!(myPMCode="CASHC")!(myPMCode="CASHD")){
				s ^TMPOPFOper($j,myUserDR,"Cash")=+$g(^TMPOPFOper($j,myUserDR,"Cash"))+myAmt
			}elseif(myPMCode="CHEQUES"){
				s ^TMPOPFOper($j, myUserDR,"Check")=+$g(^TMPOPFOper($j, myUserDR,"Check"))+myAmt
			}elseif(myPMCode="POS"){
				s ^TMPOPFOper($j, myUserDR,"CredPay")=+$g(^TMPOPFOper($j, myUserDR,"CredPay"))+myAmt
			}elseif((myPMCode="GBJJZF")!(myPMCode="TCZF")!(myPMCode="JZZF")!(myPMCode="SHJZZF")!(myPMCode="DNGZ")!(myPMCode="LNGZ")){
				s ^TMPOPFOper($j, myUserDR,"YBSum")=$g(^TMPOPFOper($j, myUserDR,"YBSum"))+myAmt
			}elseif(myPMCode="JIZHANG"){
				s ^TMPOPFOper($j, myUserDR,"JIZHANG")=+$g(^TMPOPFOper($j, myUserDR,"JIZHANG"))+myAmt
			}else{
				s ^TMPOPFOper($j, myUserDR,"OtherPay")=+$g(^TMPOPFOper($j, myUserDR,"OtherPay"))+myAmt
			}
		}
		s mySub=$o(^DHCOPInsFoot(HISRowID,"P",mySub))
	}
	
	q 0
}

ClassMethod GetFinFootRefundData(HISRowID As %String) As %String
{
	;w ##class(web.udhcOPFinBalance4).GetFinFootRefundData(934)
	n (HISRowID)
	
	s mySub=0
	s mySub=$o(^DHCOPInsFoot(HISRowID,"P",mySub))
	while (mySub'="") {
		s myPMDR=$p(^DHCOPInsFoot(HISRowID,"P",mySub),"^",2)
		s myRefAmt=+$p(^DHCOPInsFoot(HISRowID,"P",mySub),"^",4)
		s myUserDR=$p(^DHCOPInsFoot(HISRowID),"^",8)
		if ((myPMDR'="")&(+myRefAmt'=0)){
			s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
			if ((myPMCode="CASH")!(myPMCode="CASHA")!(myPMCode="CASHB")!(myPMCode="CASHC")!(myPMCode="CASHD")){
				s ^TMPOPFOper($j,myUserDR,"Cash")=+$g(^TMPOPFOper($j,myUserDR,"Cash"))+myRefAmt
				b		;Cash
			}elseif(myPMCode="CHEQUES"){
				s ^TMPOPFOper($j, myUserDR,"Check")=+$g(^TMPOPFOper($j, myUserDR,"Check"))+myRefAmt
			}elseif(myPMCode="POS"){
				s ^TMPOPFOper($j, myUserDR,"CredPay")=+$g(^TMPOPFOper($j, myUserDR,"CredPay"))+myRefAmt
			}elseif((myPMCode="GBJJZF")!(myPMCode="TCZF")!(myPMCode="JZZF")!(myPMCode="SHJZZF")!(myPMCode="DNGZ")!(myPMCode="LNGZ")){
				s ^TMPOPFOper($j, myUserDR,"YBSum")=$g(^TMPOPFOper($j, myUserDR,"YBSum"))+myRefAmt
			}elseif(myPMCode="JIZHANG"){
				s ^TMPOPFOper($j, myUserDR,"JIZHANG")=+$g(^TMPOPFOper($j, myUserDR,"JIZHANG"))+myRefAmt
			}else{
				s ^TMPOPFOper($j, myUserDR,"OtherPay")=+$g(^TMPOPFOper($j, myUserDR,"OtherPay"))+myRefAmt
			}
		}
		s mySub=$o(^DHCOPInsFoot(HISRowID,"P",mySub))
	}
	
	q 0
}

ClassMethod GetRegFinFootData(BDate As %String = "", EDate As %String = "") As %String
{
	n (BDate, EDate)
	;需要修改,...变换节点
	
	i BDate["/" d
	.s BDate=$zdh(BDate,4)
	i EDate["/" d
	.s EDate=$zdh(EDate,4)
	s myDate=BDate-1
	
    s CKFCatRowid=$O(^DHCTarC("TOC",0,"Code","CKF",0))
    s GBFCatRowid=$O(^DHCTarC("TOC",0,"Code","GBF",0))
    s GHFCatRowid=$O(^DHCTarC("TOC",0,"Code","GHF",0))
    f k=BDate:1:EDate d
	.s myHisRowID=0 for  s myHisRowID=$o(^DHCOPRegInvReports(0,"Date",k,myHisRowID)) q:myHisRowID=""  d   
	 ..s myUserDR=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",45)
	 ..s uname=$p($g(^SSU("SSUSR",myUserDR)),"^",2)
	 ..s sda=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",42) 
	 ..s stime=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",43) 
	 ..s eda=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",21) 
	 ..s etime=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",22)
	 ..;挂号费
	 ..s gh=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",27)
	 ..;侦查费
	 ..s zc=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",28)
	 ..;病历费
	 ..s bl=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",29)
	 ..;磁卡费
	 ..s ck=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",47)
	 ..s ze=gh+zc+bl+ck
	 ..s ^TMPOPFOper($j, myUserDR,"Sum")=+$g(^TMPOPFOper($j, myUserDR,"Sum"))+ze
	 ..s ^TMPOPFOper($j, myUserDR,"TotalSum")=+$g(^TMPOPFOper($j, myUserDR,"TotalSum"))+ze
	 ..s ^TMPOPFOper($j, myUserDR,"PatPaySum")=+$g(^TMPOPFOper($j, myUserDR,"PatPaySum"))+ze
	 ..s ^TMPOPFOper($j, myUserDR,"Cash")=+$g(^TMPOPFOper($j, myUserDR,"Cash"))+ze
	 ..f i=1:1:$g(^TMPTar($j)) d
	 ...i CKFCatRowid=$g(^TMPTar($j,i)) d
	 ....s ^TMPItmCat($j,myUserDR,i)=+$g(^TMPItmCat($j,myUserDR,i))+ck
	 ...i GBFCatRowid=$g(^TMPTar($j,i)) d
	 ....s ^TMPItmCat($j,myUserDR,i)=+$g(^TMPItmCat($j,myUserDR,i))+bl
	 ...i GHFCatRowid=$g(^TMPTar($j,i)) d
	 ....s ^TMPItmCat($j,myUserDR,i)=+$g(^TMPItmCat($j,myUserDR,i))+gh
	
	q 0
}

ClassMethod ReadOPUSEFootFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadOPUSEFootExecute ]
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

ClassMethod GetFinFootData(BDate As %String = "", EDate As %String = "") As %String
{
	;财务报表结算，只有一个开始和结算日期时间
	;w ##class(web.udhcOPFinBalance4).GetFinFootData("28/11/2005","30/11/2005")
	n (BDate, BTime, EDate, ETime)
	;需要修改；
	
	d ..KillTMP()
	;k ^TMPOPFOper($j)

	s n=1
	s itmrowid=0 f  s itmrowid=$o(^DHCTarC("TOC",itmrowid)) q:itmrowid=""  d
	.s itm=$p(^DHCTarC("TOC",itmrowid),"^",2)
	.s ^TMPTar($j)=n
	.s ^TMPTar($j,n)=itmrowid
	.s n=n+1
	
	i BDate["/" d
	.s BDate=$zdh(BDate,4)
	i EDate["/" d
	.s EDate=$zdh(EDate,4)
	s myDate=BDate-1
	
	;b		;GetFinFootData
	;^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	f  s myDate=$o(^DHCOPInsFootI(0,"Date",myDate)) q:((myDate="")!(myDate>EDate))  d
	.s myHisRowID=""
	.f  s myHisRowID=$o(^DHCOPInsFootI(0,"Date",myDate,myHisRowID)) q:(myHisRowID="")  d
	..s myTime=$p(^DHCOPInsFoot(myHisRowID),"^",7)
	..;q:((myDate=BDate)&&(myTime<BTime))
	..;q:((myDate=EDate)&&(myTime>ETime))
	..s myINSFDate=$p(^DHCOPInsFoot(myHisRowID),"^",13)
	..;q:(myINSFDate'="")
	..s myUserDR=$p(^DHCOPInsFoot(myHisRowID),"^",8)
	..s myUserName=$p(^SSU("SSUSR",myUserDR),"^",2)
	..;退费金额
	..d ..GetFinFootRefundData(myHisRowID)
	..d ..GetFinFootDataByPM(myHisRowID)
	..s ^TMPOPFOper($j,myUserDR)=myUserName
	..;
	..s myRoundSum=+$p(^DHCOPInsFoot(myHisRowID),"^",29)		;HIS_INVRoundSum
	..s ^TMPOPFOper($j, myUserDR,"RoundSum")=+$g(^TMPOPFOper($j, myUserDR,"RoundSum"))+myRoundSum
	..;+myCashSum+myCheckSum+myCredPaySum+myOtherPaySum+myYBPaySum+myJZSum
	..;需要注意，每次增加支付类型都需要在此重新取值
	..s myCashSum=+$g(^TMPOPFOper($j,myUserDR,"Cash"))
	..s myCheckSum=+$g(^TMPOPFOper($j, myUserDR,"Check"))
	..s myCredPaySum=+$g(^TMPOPFOper($j, myUserDR,"CredPay"))
	..s myOtherPaySum=+$g(^TMPOPFOper($j, myUserDR,"OtherPay"))
	..s myYBPaySum=+$g(^TMPOPFOper($j, myUserDR,"YBSum"))
	..s myJZSum=+$g(^TMPOPFOper($j, myUserDR,"JIZHANG"))
	..s ^TMPOPFOper($j, myUserDR,"Sum")=+myCashSum+myCheckSum+myCredPaySum+myOtherPaySum+myYBPaySum+myJZSum
	..s myTotalSum=+$p(^DHCOPInsFoot(myHisRowID),"^",1)		;HIS_Amount
	..s ^TMPOPFOper($j, myUserDR,"TotalSum")=+$g(^TMPOPFOper($j, myUserDR,"TotalSum"))+myTotalSum
	..s myPatPaySum=+$p(^DHCOPInsFoot(myHisRowID),"^",16)		;HIS_Amount
	..s ^TMPOPFOper($j, myUserDR,"PatPaySum")=+$g(^TMPOPFOper($j, myUserDR,"PatPaySum"))+myPatPaySum
	..d ..STATtoCAT(myHisRowID)
	..b	;;;;;
	;b		;;;FootData
	q 0
}

ClassMethod STATtoCAT(INVRepRowID As %String) As %String
{
	;w ##class(web.udhcOPFinBalance4).STATtoCAT("1077")
	n (INVRepRowID)
	;需要修改；
	
	s iteminfo=""
	
	s INVPRTRowid=0
	;^DHCINVPRT(0,"Report",{PRT_DHCINVPRTR_DR},{PRT_Rowid})
	s myUserDR=$p($g(^DHCOPInsFoot(INVRepRowID)),"^",8)
	q:(myUserDR="")
	
	f  s INVPRTRowid=$o(^DHCINVPRT(0,"Report",INVRepRowID, INVPRTRowid)) q:(INVPRTRowid="")  d
	.s conRowid=0 F  S conRowid=$o(^DHCBCI(0,"INV",INVPRTRowid,conRowid)) Quit:conRowid=""  d
	..S Bill=$p(^DHCBCI(conRowid),"^",2)
	..q:'$D(^DHCPB(Bill))
	..S Ord="" F  S Ord=$o(^DHCPB(Bill,"O",Ord)) q:Ord=""  d
	...S Itm=0 For  Set Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) q:Itm=""  Do
	....S ItmDr=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",3)
	....S TotalAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",7)
	....S DiscAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",8)
	....S PayorShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",9)
	....S PatientShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",10)	
	....S ItmOPSubCat=$p($g(^DHCTARI(ItmDr)),"^",15)
	....i $g(ItmOPSubCat)="" d
	.....s ^TMPTestItmSubCat(ItmDr)=ItmDr
	....;赵加入的测试
	....q:$g(ItmOPSubCat)=""
	....S ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	....q:$g(ItmOPCat)=""
	....s OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
	....f i=1:1:$g(^TMPTar($j)) d
	.....i ItmOPCat=$g(^TMPTar($j,i)) d
	......s ^TMPItmCat($j,myUserDR,i)=+$g(^TMPItmCat($j,myUserDR,i))+TotalAmount
	.....q:ItmOPCat=$g(^TMPTar($j,i))
	
	q 0
}

ClassMethod FootItemQueryExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance6","FootItemQuery",+$h-10,+$h)
	New repid, index
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;需要修改；
	;多张日报合成一个到一个人身上的报表;
	;生成Global,  然后输出，  
	;最后加上合计
	
	d ResetVariablesFI
	
	i (StDate="")!(EndDate=""){
		d OutputFI
		Quit $$$OK
	}
	
	d ..KillTMP()
	
	;生成Global
	;收费
	s myrtn=##class(web.udhcOPFinBalance6).GetFinFootData(StDate,EndDate )
	b	;;
	;挂号
	d ..GetRegFinFootData(StDate,EndDate)
	
	;^TMPOPFOper($j,myHisRowID, myUserDR
	;^TMPItmCat($j,INVRepRowID,i)
	s myItemLen=+$g(^TMPTar($j))
	s myHisRowID=""
	s myNo=0
	s myItemInfo=""
	s myListSum=0
	s myPatShareSum=0
	s myJZSum=0
	s JZSum=0
	s myUserDR=0
	
	f  s myUserDR=$o(^TMPOPFOper($j,myUserDR)) q:(myUserDR="")  d
	.s myNo=myNo+1
	.s myItemInfo=""
	.;s myUserDR=$o(^TMPOPFOper($j,myHisRowID,""))
	.s myUserName=$p(^SSU("SSUSR",myUserDR),"^",2)
	.s mySum=$g(^TMPOPFOper($j, myUserDR,"Sum"))
	.s mySum=+mySum-$g(^TMPOPFOper($j, myUserDR,"RoundSum"))
	.s myYBPaySum=+$g(^TMPOPFOper($j, myUserDR,"YBSum"))
	.s myYBPaySum=$fn(myYBPaySum,"",2)
	.s TYBPaySum=+$g(TYBPaySum)+myYBPaySum
	.s myFeeYHSum=+$g(^TMPOPFOper($j, myUserDR,"TotalSum"))
	.s myFeeYHSum=+myFeeYHSum-$g(^TMPOPFOper($j, myUserDR,"PatPaySum"))
	.s myFeeYHSum=$fn(myFeeYHSum,"",2)
	.s TFeeYHSum=+$g(TFeeYHSum)+myFeeYHSum
	.s PatShareSum=$g(^TMPOPFOper($j, myUserDR,"Cash"))
	.s myJZSum=+$g(^TMPOPFOper($j, myUserDR,"JIZHANG"))
	.b	;;
	.;序号，操作员，RowID，
	.f i=1:1:myItemLen  d
	..s myItemInfo=myItemInfo_"^"_$fn(+$g(^TMPItmCat($j,myUserDR,i)),"",2)
	.;b		;myItemInfo
	.;合计，记账收入(讨论一下这个怎么，为空)，收款收入
	.s myRepInfo=myItemLen_"^"_myNo_"^"_myUserName_"^"_myHisRowID_myItemInfo_"^"_mySum_"^"_"^"_mySum
	.s TNO=myNo
	.s UserName=myUserName
	.s RepRowID=myHisRowID
	.s TCAT1=$fn(+$g(^TMPItmCat($j,myUserDR,1)),"",2)
	.s TCATSum1=$g(TCATSum1)+TCAT1
	.s TCAT2=$fn(+$g(^TMPItmCat($j,myUserDR,2)),"",2)
	.s TCATSum2=$g(TCATSum2)+TCAT2
	.s TCAT3=$fn(+$g(^TMPItmCat($j,myUserDR,3)),"",2)
	.s TCATSum3=$g(TCATSum3)+TCAT3
	.s TCAT4=$fn(+$g(^TMPItmCat($j,myUserDR,4)),"",2)
	.s TCATSum4=$g(TCATSum4)+TCAT4
	.s TCAT5=$fn(+$g(^TMPItmCat($j,myUserDR,5)),"",2)
	.s TCATSum5=$g(TCATSum5)+TCAT5
	.s TCAT6=$fn(+$g(^TMPItmCat($j,myUserDR,6)),"",2)
	.s TCATSum6=$g(TCATSum6)+TCAT6
	.s TCAT7=$fn(+$g(^TMPItmCat($j,myUserDR,7)),"",2)
	.s TCATSum7=$g(TCATSum7)+TCAT7
	.s TCAT8=$fn(+$g(^TMPItmCat($j,myUserDR,8)),"",2)
	.s TCATSum8=$g(TCATSum8)+TCAT8
	.s TCAT9=$fn(+$g(^TMPItmCat($j,myUserDR,9)),"",2)
	.s TCATSum9=$g(TCATSum9)+TCAT9
	.s TCAT10=$fn(+$g(^TMPItmCat($j,myUserDR,10)),"",2)
	.s TCATSum10=$g(TCATSum10)+TCAT10
	.s TCAT11=$fn(+$g(^TMPItmCat($j,myUserDR,11)),"",2)
	.s TCATSum11=$g(TCATSum11)+TCAT11
	.s TCAT12=$fn(+$g(^TMPItmCat($j,myUserDR,12)),"",2)
	.s TCATSum12=$g(TCATSum12)+TCAT12
	.s TCAT13=$fn(+$g(^TMPItmCat($j,myUserDR,13)),"",2)
	.s TCATSum13=$g(TCATSum13)+TCAT13
	.s TCAT14=$fn(+$g(^TMPItmCat($j,myUserDR,14)),"",2)
	.s TCATSum14=$g(TCATSum14)+TCAT14
	.s TCAT15=$fn(+$g(^TMPItmCat($j,myUserDR,15)),"",2)
	.s TCATSum15=$g(TCATSum15)+TCAT15
	.s TCAT16=$fn(+$g(^TMPItmCat($j,myUserDR,16)),"",2)
	.s TCATSum16=$g(TCATSum16)+TCAT16
	.s TCAT17=$fn(+$g(^TMPItmCat($j,myUserDR,17)),"",2) 
	.s TCATSum17=$g(TCATSum17)+TCAT17
	.s TCAT18=$fn(+$g(^TMPItmCat($j,myUserDR,18)),"",2)
	.s TCATSum18=$g(TCATSum18)+TCAT18
	.s TCAT19=$fn(+$g(^TMPItmCat($j,myUserDR,19)),"",2)
	.s TCATSum19=$g(TCATSum19)+TCAT19
	.s TCAT20=$fn(+$g(^TMPItmCat($j,myUserDR,20)),"",2)
	.s TCATSum20=$g(TCATSum20)+TCAT20
	.s TSum=$fn(mySum,"",2) ;mySum_"^"_"^"_mySum
	.s InsSum=$fn(myJZSum,"",2)
	.s JZSum=JZSum+myJZSum
	.s PatShareSum=$fn(PatShareSum,"",2)
	.s myPatShareSum=$g(myPatShareSum)+PatShareSum
	.s myListSum=+$g(myListSum)+mySum
	.d OutputFI
	
	;合计
	i myNo'=0 d
	.s TNO="",UserName="合计",RepRowID=""
	.s TCAT1=$fn(TCATSum1,"",2)
	.s TCAT2=$fn(TCATSum2,"",2)
	.s TCAT3=$fn(TCATSum3,"",2)
	.s TCAT4=$fn(TCATSum4,"",2)
	.s TCAT5=$fn(TCATSum5,"",2)
	.s TCAT6=$fn(TCATSum6,"",2)
	.s TCAT7=$fn(TCATSum7,"",2)
	.s TCAT8=$fn(TCATSum8,"",2)
	.s TCAT9=$fn(TCATSum9,"",2)
	.s TCAT10=$fn(TCATSum10,"",2)
	.s TCAT11=$fn(TCATSum11,"",2)
	.s TCAT12=$fn(TCATSum12,"",2)
	.s TCAT13=$fn(TCATSum13,"",2)
	.s TCAT14=$fn(TCATSum14,"",2)
	.s TCAT15=$fn(TCATSum15,"",2)
	.s TCAT16=$fn(TCATSum16,"",2)
	.s TCAT17=$fn(TCATSum17,"",2)
	.s TCAT18=$fn(TCATSum18,"",2)
	.s TCAT19=$fn(TCATSum19,"",2)
	.s TCAT20=$fn(TCATSum20,"",2)
	.s TSum=$fn(myListSum,"",2) ;mySum_"^"_"^"_mySum
	.s InsSum=$fn(JZSum,"",2)
	.s PatShareSum=$fn(myPatShareSum,"",2)
	.s myFeeYHSum=$fn(TFeeYHSum,"",2)
	.s myYBPaySum=$fn(TYBPaySum,"",2)
	.d OutputFI
	b		;kill  
	
	d ..KillTMP()
	
	
	Quit $$$OK
ResetVariablesFI
	s (TNO,UserName,RepRowID,TCAT1,TCAT2,TCAT3,TCAT4,TCAT5,TCAT6,TCAT7, TCAT8, TCAT9, TCAT10,TCAT11, TCAT12, TCAT13, TCAT14, TCAT15, TCAT16, TCAT17, TCAT18, TCAT19, TCAT20)=""
	s (TSum, InsSum, PatShareSum)=""
	s (TFeeYHSum, TYBPaySum)=""
	quit
OutputFI
	s Data=$lb(TNO,UserName,RepRowID,TCAT1,TCAT2,TCAT3,TCAT4,TCAT5,TCAT6,TCAT7, TCAT8, TCAT9, TCAT10,TCAT11, TCAT12, TCAT13, TCAT14, TCAT15, TCAT16, TCAT17, TCAT18, TCAT19, TCAT20, TSum, InsSum, PatShareSum, myYBPaySum, myFeeYHSum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
}

ClassMethod FootItemQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FootItemQueryExecute ]
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

ClassMethod FootItemQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FootItemQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FootItemQuery(StDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "TNO:%String,UserName:%String,RepRowID:%String,TCAT1:%String,TCAT2:%String,TCAT3:%String,TCAT4:%String,TCAT5:%String,TCAT6:%String,TCAT7:%String, TCAT8:%String, TCAT9:%String, TCAT10:%String,TCAT11:%String, TCAT12:%String, TCAT13:%String, TCAT14:%String, TCAT15:%String, TCAT16:%String, TCAT17:%String, TCAT18:%String, TCAT19:%String, TCAT20:%String, TSum:%String, InsSum:%String, PatShareSum:%String, YBPaySum:%String, FeeYHSum:%String")
{
}

Query ReadOPUSEFoot(StDate As %String, EndDate As %String) As %Query(ROWSPEC = "No:%String,TOperCode:%String,TOperName:%String,TINVRange:%String,TINVNum:%String,TTolSum:%String,TCashSum:%String,TCheckSum:%String,TPOSum:%String,TPOSSum:%String,TYLSum:%String,TQFSum:%String,TFactSum:%String")
{
}

}
