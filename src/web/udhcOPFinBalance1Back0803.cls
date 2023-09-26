Class web.udhcOPFinBalance1Back0803 Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 253;

ClassMethod GetUserFootDT(UserDR As %String = "") As %String
{
	n (UserDR)
	;w ##class(web.udhcOPFinBalance1).GetUserFootDT("23310")
	
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

ClassMethod GetFinFootData(BDate As %String = "", EDate As %String = "") As %String
{
	;财务报表结算，只有一个开始和结算日期时间
	;w ##class(web.udhcOPFinBalance4).GetFinFootData("28/11/2005","30/11/2005")
	n (BDate, BTime, EDate, ETime)
	
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
	i BDate["-" d
	.s BDate=$zdh(BDate,3)
	
	i EDate["/" d
	.s EDate=$zdh(EDate,4)
	
	s myDate=BDate-1
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
	..s myUserName=$p($g(^SSU("SSUSR",myUserDR)),"^",2)
	..s ^TMPOPFOper($j,myHisRowID,myUserDR)=myUserName
	..s myCashSum=$p(^DHCOPInsFoot(myHisRowID),"^",18)
	..s myCashSum=+myCashSum+$p(^DHCOPInsFoot(myHisRowID),"^",22)
	..s myCashSum=+myCashSum+$p(^DHCOPInsFoot(myHisRowID),"^",24)
	..s ^TMPOPFOper($j,myHisRowID,myUserDR,"Cash")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Cash"))+myCashSum
	..s myCheckSum=$p(^DHCOPInsFoot(myHisRowID),"^",20)
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"Check")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Check"))+myCheckSum
	..s myCredPaySum=+$p(^DHCOPInsFoot(myHisRowID),"^",45)
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"CredPay")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"CredPay"))+myCredPaySum				;信用卡支付
	..s myOtherPaySum=+$p(^DHCOPInsFoot(myHisRowID),"^",28)
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"OtherPay")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"OtherPay"))+myOtherPaySum			;其他支付
	..;；增加医保支付，
	..
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"Sum")=$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Sum"))+myCashSum+myCheckSum+myCredPaySum+myOtherPaySum
	..
	..d ..STATtoCAT(myHisRowID)
	..
	
	q 0
}

ClassMethod GetFinFootDataForAPINV(BDate As %String = "", EDate As %String = "") As %String
{
	;财务报表结算，只有一个开始和结算日期时间
	;w ##class(web.udhcOPFinBalance4).GetFinFoot1Data("28/11/2005","30/11/2005")
	n (BDate, BTime, EDate, ETime)
	
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
	i BDate["-" d
	.s BDate=$zdh(BDate,3)
	
	i EDate["/" d
	.s EDate=$zdh(EDate,4)
	s myDate=BDate-1
	
	;b		;
	;^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	;按照财务结算日期
	;^DHCOPInsFootI(0,"INSFDate",{HIS_INSFootDate},{HIS_Rowid})
	;f  s myDate=$o(^DHCOPInsFootI(0,"Date",myDate)) q:((myDate="")!(myDate>EDate))  d
	b		;开始日期
	f  s myDate=$o(^DHCOPInsFootI(0,"INSFDate", myDate)) q:((myDate="")!(myDate>EDate))  d
	.s myHisRowID=0
	.f  s myHisRowID=$o(^DHCOPInsFootI(0,"INSFDate",myDate,myHisRowID)) q:(myHisRowID="")  d
	..s myTime=$p(^DHCOPInsFoot(myHisRowID),"^",7)
	..;q:((myDate=BDate)&&(myTime<BTime))
	..;q:((myDate=EDate)&&(myTime>ETime))
	..s myINSFDate=$p(^DHCOPInsFoot(myHisRowID),"^",13)
	..;q:(myINSFDate'="")
	..s myAccPaySum=$p(^DHCOPInsFoot(myHisRowID),"^",59)
	..s mySysFlag=$p(^DHCOPInsFoot(myHisRowID),"^",60)
	..q:(mySysFlag="S")			;如果是系统结算退出
	..s myUserDR=$p(^DHCOPInsFoot(myHisRowID),"^",8)
	..s myUserName=$p($g(^SSU("SSUSR",myUserDR)),"^",2)
	..s ^TMPOPFOper($j,myHisRowID,myUserDR)=myUserName
	..s myCashSum=$p(^DHCOPInsFoot(myHisRowID),"^",18)
	..s myCashSum=+myCashSum+$p(^DHCOPInsFoot(myHisRowID),"^",22)
	..s myCashSum=+myCashSum+$p(^DHCOPInsFoot(myHisRowID),"^",24)
	..s ^TMPOPFOper($j,myHisRowID,myUserDR,"Cash")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Cash"))+myCashSum
	..s myCheckSum=$p(^DHCOPInsFoot(myHisRowID),"^",20)
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"Check")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Check"))+myCheckSum
	..s myCredPaySum=+$p(^DHCOPInsFoot(myHisRowID),"^",45)
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"CredPay")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"CredPay"))+myCredPaySum				;信用卡支付
	..s myOtherPaySum=+$p(^DHCOPInsFoot(myHisRowID),"^",28)
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"OtherPay")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"OtherPay"))+myOtherPaySum			;其他支付
	..
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"Sum")=$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Sum"))+myCashSum+myCheckSum+myCredPaySum+myOtherPaySum
	..s myINVSum=+$p(^DHCOPInsFoot(myHisRowID),"^",1)		;票据金额
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"INVSum")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"INVSum"))+myINVSum
	..s myINVNum=0
	..s myINVNum=+myINVNum+$p(^DHCOPInsFoot(myHisRowID),"^",9)		;打印的发票数量
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"INVNum")=$g(^TMPOPFOper($j,myHisRowID, myUserDR,"INVNum"))+myINVNum
	..s myParkINVNum=0
	..s myParkINVNum=+myParkINVNum++$p(^DHCOPInsFoot(myHisRowID),"^",21)
	..s myParkINVNum=+myParkINVNum++$p(^DHCOPInsFoot(myHisRowID),"^",23)
	..s myParkINVNum=+myParkINVNum++$p(^DHCOPInsFoot(myHisRowID),"^",34)
	..s myParkINVNum=+myParkINVNum++$p(^DHCOPInsFoot(myHisRowID),"^",38)
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"ParkINVNum")=$g(^TMPOPFOper($j,myHisRowID, myUserDR,"ParkINVNum"))+myParkINVNum
	..d ..STATtoCATForINV(myHisRowID)
	..;集中打印发票的
	..d ..APIFootToOPCAT(myHisRowID)
	
	q 0
}

ClassMethod STATtoCATForINV(INVRepRowID As %String) As %String
{
	;需要修改此处
	;要求结算过同时打印了发票的记录才成
	;如果当前的DHC_INVPRT记录中没有发票号码，或支付方式不是
	;w ##class(web.udhcOPFinBalance4).STATtoCAT("368")
	n (INVRepRowID)
	
	s iteminfo=""
	
	s INVPRTRowid=0
	;^DHCINVPRT(0,"Report",{PRT_DHCINVPRTR_DR},{PRT_Rowid})
	f  s INVPRTRowid=$o(^DHCINVPRT(0,"Report",INVRepRowID, INVPRTRowid)) q:(INVPRTRowid="")  d
	.q:($d(^DHCINVPRT(INVPRTRowid))=10)
	.s myINVNo=$p($g(^DHCINVPRT(INVPRTRowid)),"^",14)			;发票号码
	.s myPMDR=$o(^CT("CTPM",0,"Code","CPP",0))					;卡支付
	.;^DHCINVPRTi(0,"PMDR",{DHC_INVPRT.PRT_Rowid},{IPM_PayMode_DR}
	.s myPMSub=$o(^DHCINVPRTi(0,"PMDR",INVPRTRowid,myPMDR,"P",0))
	.q:((myINVNo="")&(myPMSub'=""))						;如果现金支付，没有打印发票，
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
	....q:$g(ItmOPSubCat)=""
	....S ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	....q:$g(ItmOPCat)=""
	....s OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
	....f i=1:1:$g(^TMPTar($j)) d
	.....i ItmOPCat=$g(^TMPTar($j,i)) d
	......s ^TMPItmCat($j,INVRepRowID,i)=+$g(^TMPItmCat($j,INVRepRowID,i))+TotalAmount
	.....q:ItmOPCat=$g(^TMPTar($j,i))
	
	q 0
}

ClassMethod STATtoCAT(INVRepRowID As %String) As %String
{
	;需要修改此处
	;需要发票的分类????
	;此处汇集所有的DHC_INVPRT表的结算表  (包括现金打印发票或卡支付的金额)
	;w ##class(web.udhcOPFinBalance4).STATtoCAT("368")
	n (INVRepRowID)
	
	s iteminfo=""
	
	s INVPRTRowid=0
	;^DHCINVPRT(0,"Report",{PRT_DHCINVPRTR_DR},{PRT_Rowid})
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
	....q:$g(ItmOPSubCat)=""
	....S ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	....q:$g(ItmOPCat)=""
	....s OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
	....f i=1:1:$g(^TMPTar($j)) d
	.....i ItmOPCat=$g(^TMPTar($j,i)) d
	......s ^TMPItmCat($j,INVRepRowID,i)=+$g(^TMPItmCat($j,INVRepRowID,i))+TotalAmount
	.....q:ItmOPCat=$g(^TMPTar($j,i))
	
	q 0
}

ClassMethod APIFootToOPCAT(INVRepRowID As %String)
{
	n (INVRepRowID)
	;把财务结算过的集中打印的票据转化为门诊收费大类或子类
	;^DHCINVPRTCAPi(0,"APINVDR",{ACP_APINV_DR},{ACP_RowID})
	;^DHCINVPRTAPi(0,"INVRep",{API_INVRep_DR},{API_RowID})
	
	s APINVRowid=0
	f  s APINVRowid=$o(^DHCINVPRTAPi(0,"INVRep",INVRepRowID,APINVRowid)) q:(APINVRowid="")  d
	.d ..APayINVSTATtoOPCAT(APINVRowid, INVRepRowID)
	
	q 0
}

ClassMethod APayINVSTATtoOPCAT(APINVRowid As %String, INVRepRowID As %String)
{
	n (APINVRowid, INVRepRowID)
	;把一张集中打印的票据转化为门诊收费大类或子类
	;^DHCINVPRTCAPi(0,"APINVDR",{ACP_APINV_DR},{ACP_RowID})
	
	s myACPRowID=0
	f  s myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",APINVRowid, myACPRowID)) q:(myACPRowID="")  d
	.s INVPRTRowid=$p($g(^DHCINVPRTCAP(myACPRowID)),"^",1)
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
	....q:$g(ItmOPSubCat)=""
	....S ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	....q:$g(ItmOPCat)=""
	....s OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
	....f i=1:1:$g(^TMPTar($j)) d
	.....i ItmOPCat=$g(^TMPTar($j,i)) d
	......s ^TMPItmCat($j,INVRepRowID,i)=+$g(^TMPItmCat($j,INVRepRowID,i))+TotalAmount
	.....q:ItmOPCat=$g(^TMPTar($j,i))
	
	q 0
}

ClassMethod FootINVItemQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FootINVItemQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FootItemQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FootItemQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FootINVItemQueryExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance1","FootINVItemQuery",60447,60465)
	New repid, index
	Set repid=$I(^CacheTemp)
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance1","ReadUnFootINV")
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;生成Global,  然后输出，  
	;最后加上合计
	
	d ResetVariablesFINVQ
	
	i (StDate="")!(EndDate=""){
		d OutputFINVQ
		Quit $$$OK
	}
	
	b
	d ..KillTMP()
	
	
	
	;生成Global
	s myrtn=..GetFinFootDataForAPINV(StDate,EndDate)
	
	b	;FootINV
	;^TMPOPFOper($j,myHisRowID, myUserDR
	;^TMPItmCat($j,INVRepRowID,i)
	s myItemLen=+$g(^TMPTar($j))
	s myHisRowID=""
	s myNo=0
	s myItemInfo=""
	s myListSum=0
	s myTINVNum=0
	s myTParkINVNum=0
	s myTGZNum=0
	s myDrugFair=0
	
	s myDrugXY=0		;西药
	s myXYIdx=0
	;^DHCTarC("TOC",0,"Code",{TARTOC_Code},{TARTOC_RowId})
	s myXYRowID=$o(^DHCTarC("TOC",0,"Code","XY",0))
	
	s myDrugZCYF=0		;中草药费
	s myZCYFRowID=$o(^DHCTarC("TOC",0,"Code","ZCYF",0))
	s myZCYFIdx=0
	
	s myDrugZCY=0		;中成药
	s myZCYIdx=0
	s myZCYRowID=$o(^DHCTarC("TOC",0,"Code","ZCY",0))
	
	f i=1:1:myItemLen d
	.i ($g(^TMPTar($j,i))=myXYRowID) d
	..s myXYIdx=i
	.i ($g(^TMPTar($j,i))=myZCYFRowID) d
	..s myZCYFIdx=i
	.i ($g(^TMPTar($j,i))=myZCYRowID) d
	..s myZCYIdx=i
	
	f  s myHisRowID=$o(^TMPOPFOper($j,myHisRowID)) q:(myHisRowID="")  d
	.s myNo=myNo+1
	.s myItemInfo=""
	.s myUserDR=$o(^TMPOPFOper($j,myHisRowID,""))
	.s myUserName=$p($g(^SSU("SSUSR",myUserDR)),"^",2)
	.s mySum=$g(^TMPOPFOper($j,myHisRowID, myUserDR,"INVSum"))
	.s myINVNum=$g(^TMPOPFOper($j,myHisRowID, myUserDR,"INVNum"))
	.s myParkINVNum=$g(^TMPOPFOper($j,myHisRowID, myUserDR,"ParkINVNum"))
	.;序号，操作员，RowID，
	.f i=1:1:myItemLen  d
	..s myItemInfo=myItemInfo_"^"_$fn(+$g(^TMPItmCat($j,myHisRowID,i)),"",2)
	.;b		;myItemInfo
	.;合计，记账收入(讨论一下这个怎么，为空)，收款收入
	.s myRepInfo=myItemLen_"^"_myNo_"^"_myUserName_"^"_myHisRowID_myItemInfo_"^"_mySum_"^"_"^"_mySum
	.s TNO=myNo
	.s UserName=myUserName
	.s RepRowID=myHisRowID
	.s myDrugXY=+myDrugXY+$g(^TMPItmCat($j,myHisRowID,myXYIdx))
	.s myDrugZCY=+myDrugZCY+$g(^TMPItmCat($j,myHisRowID,myZCYIdx))
	.s myDrugZCYF=+myDrugZCYF+$g(^TMPItmCat($j,myHisRowID,myZCYFIdx))
	.s TCAT1=$fn(+$g(^TMPItmCat($j,myHisRowID,1)),"",2)
	.s TCATSum1=$g(TCATSum1)+TCAT1
	.s TCAT2=$fn(+$g(^TMPItmCat($j,myHisRowID,2)),"",2)
	.s TCATSum2=$g(TCATSum2)+TCAT2
	.s TCAT3=$fn(+$g(^TMPItmCat($j,myHisRowID,3)),"",2)
	.s TCATSum3=$g(TCATSum3)+TCAT3
	.s TCAT4=$fn(+$g(^TMPItmCat($j,myHisRowID,4)),"",2)
	.s TCATSum4=$g(TCATSum4)+TCAT4
	.s TCAT5=$fn(+$g(^TMPItmCat($j,myHisRowID,5)),"",2)
	.s TCATSum5=$g(TCATSum5)+TCAT5
	.s TCAT6=$fn(+$g(^TMPItmCat($j,myHisRowID,6)),"",2)
	.s TCATSum6=$g(TCATSum6)+TCAT6
	.s TCAT7=$fn(+$g(^TMPItmCat($j,myHisRowID,7)),"",2)
	.s TCATSum7=$g(TCATSum7)+TCAT7
	.s TCAT8=$fn(+$g(^TMPItmCat($j,myHisRowID,8)),"",2)
	.s TCATSum8=$g(TCATSum8)+TCAT8
	.s TCAT9=$fn(+$g(^TMPItmCat($j,myHisRowID,9)),"",2)
	.s TCATSum9=$g(TCATSum9)+TCAT9
	.s TCAT10=$fn(+$g(^TMPItmCat($j,myHisRowID,10)),"",2)
	.s TCATSum10=$g(TCATSum10)+TCAT10
	.s TCAT11=$fn(+$g(^TMPItmCat($j,myHisRowID,11)),"",2)
	.s TCATSum11=$g(TCATSum11)+TCAT11
	.s TCAT12=$fn(+$g(^TMPItmCat($j,myHisRowID,12)),"",2)
	.s TCATSum12=$g(TCATSum12)+TCAT12
	.s TCAT13=$fn(+$g(^TMPItmCat($j,myHisRowID,13)),"",2)
	.s TCATSum13=$g(TCATSum13)+TCAT13
	.s TCAT14=$fn(+$g(^TMPItmCat($j,myHisRowID,14)),"",2)
	.s TCATSum14=$g(TCATSum14)+TCAT14
	.s TCAT15=$fn(+$g(^TMPItmCat($j,myHisRowID,15)),"",2)
	.s TCATSum15=$g(TCATSum15)+TCAT15
	.s TCAT16=$fn(+$g(^TMPItmCat($j,myHisRowID,16)),"",2)
	.s TCATSum16=$g(TCATSum16)+TCAT16
	.s TCAT17=$fn(+$g(^TMPItmCat($j,myHisRowID,17)),"",2) 
	.s TCATSum17=$g(TCATSum17)+TCAT17
	.s TCAT18=$fn(+$g(^TMPItmCat($j,myHisRowID,18)),"",2)
	.s TCATSum18=$g(TCATSum18)+TCAT18
	.s TCAT19=$fn(+$g(^TMPItmCat($j,myHisRowID,19)),"",2)
	.s TCATSum19=$g(TCATSum19)+TCAT19
	.s TCAT20=$fn(+$g(^TMPItmCat($j,myHisRowID,20)),"",2)
	.s TCATSum20=$g(TCATSum20)+TCAT20
	.s mySum=0
	.s mySum=mySum+TCAT1
	.s mySum=mySum + TCAT2
	.s mySum=mySum + TCAT3
	.s mySum=mySum + TCAT4
	.s mySum=mySum + TCAT5
	.s mySum=mySum + TCAT6
	.s mySum=mySum + TCAT7
	.s mySum=mySum + TCAT8
	.s mySum=mySum + TCAT9
	.s mySum=mySum + TCAT10
	.s mySum=mySum + TCAT11
	.s mySum=mySum + TCAT12
	.s mySum=mySum + TCAT13
	.s mySum=mySum + TCAT14
	.s mySum=mySum + TCAT15
	.s mySum=mySum + TCAT16
	.s mySum=mySum + TCAT17
	.s mySum=mySum + TCAT18
	.s mySum=mySum + TCAT19
	.s mySum=mySum + TCAT20
	.s TSum=$fn(mySum,"",2) ;mySum_"^"_"^"_mySum
	.s myTINVNum=+myTINVNum+myINVNum
	.s myTParkINVNum=+myTParkINVNum+myParkINVNum
	.s myGZNum=myINVNum+myParkINVNum
	.s myTGZNum=+myTGZNum+myGZNum
	.s PatShareSum=$fn(mySum,"",2)
	.s myListSum=+$g(myListSum)+mySum
	.d OutputFINVQ
	
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
	.s InsSum=0.0
	.s PatShareSum=$fn(myListSum,"",2)
	.s myINVNum=myTINVNum
	.s myParkINVNum=myTParkINVNum
	.s myGZNum=myTGZNum
	.d OutputFINVQ
	;b		;kill
	
	s myDrugFair=+myDrugXY+myDrugZCY+myDrugZCYF
	s myDrugRadio=0
	i +TSum'=0 d
	.s myDrugRadio=myDrugFair/TSum
	
	s myDrugRadio=myDrugRadio*100
	s myDrugRadio=$fn(myDrugRadio,"",2)_"%"
	d ResetVariablesFINVQ
	s UserName="药品比例"
	s TCAT1=myDrugRadio
	d OutputFINVQ
	
	d ..KillTMP()
	
	Quit $$$OK
ResetVariablesFINVQ
	s (TNO,UserName,RepRowID,TCAT1,TCAT2,TCAT3,TCAT4,TCAT5,TCAT6,TCAT7, TCAT8, TCAT9, TCAT10,TCAT11, TCAT12, TCAT13, TCAT14, TCAT15, TCAT16, TCAT17, TCAT18, TCAT19, TCAT20)=""
	s (TSum, InsSum, PatShareSum)=""
	quit
OutputFINVQ
	s Data=$lb(TNO,UserName,RepRowID,TCAT1,TCAT2,TCAT3,TCAT4,TCAT5,TCAT6,TCAT7, TCAT8, TCAT9, TCAT10,TCAT11, TCAT12, TCAT13, TCAT14, TCAT15, TCAT16, TCAT17, TCAT18, TCAT19, TCAT20, TSum, myINVNum, myParkINVNum, myGZNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
}

ClassMethod FootItemQueryExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance1","FootItemQuery",+$h-100,+$h)
	New repid, index
	Set repid=$I(^CacheTemp)
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance1","ReadUnFootINV")
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;生成Global,  然后输出，  
	;最后加上合计
	
	d ResetVariablesFI
	
	i (StDate="")!(EndDate=""){
		d OutputFI
		Quit $$$OK
	}
	
	b
	d ..KillTMP()
	
	;生成Global  ##class(web.udhcOPFinBalanceIF)
	s myrtn=..GetFinFootData(StDate,EndDate)
	
	;^TMPOPFOper($j,myHisRowID, myUserDR
	;^TMPItmCat($j,INVRepRowID,i)
	s myItemLen=+$g(^TMPTar($j))
	s myHisRowID=""
	s myNo=0
	s myItemInfo=""
	s myListSum=0
	
	f  s myHisRowID=$o(^TMPOPFOper($j,myHisRowID)) q:(myHisRowID="")  d
	.s myNo=myNo+1
	.s myItemInfo=""
	.s myUserDR=$o(^TMPOPFOper($j,myHisRowID,""))
	.s myUserName=$p($g(^SSU("SSUSR",myUserDR)),"^",2)
	.s mySum=$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Sum"))
	.;序号，操作员，RowID，
	.f i=1:1:myItemLen  d
	..s myItemInfo=myItemInfo_"^"_$fn(+$g(^TMPItmCat($j,myHisRowID,i)),"",2)
	.;b		;myItemInfo
	.;合计，记账收入(讨论一下这个怎么，为空)，收款收入
	.s myRepInfo=myItemLen_"^"_myNo_"^"_myUserName_"^"_myHisRowID_myItemInfo_"^"_mySum_"^"_"^"_mySum
	.s TNO=myNo
	.s UserName=myUserName
	.s RepRowID=myHisRowID
	.s TCAT1=$fn(+$g(^TMPItmCat($j,myHisRowID,1)),"",2)
	.s TCATSum1=$g(TCATSum1)+TCAT1
	.s TCAT2=$fn(+$g(^TMPItmCat($j,myHisRowID,2)),"",2)
	.s TCATSum2=$g(TCATSum2)+TCAT2
	.s TCAT3=$fn(+$g(^TMPItmCat($j,myHisRowID,3)),"",2)
	.s TCATSum3=$g(TCATSum3)+TCAT3
	.s TCAT4=$fn(+$g(^TMPItmCat($j,myHisRowID,4)),"",2)
	.s TCATSum4=$g(TCATSum4)+TCAT4
	.s TCAT5=$fn(+$g(^TMPItmCat($j,myHisRowID,5)),"",2)
	.s TCATSum5=$g(TCATSum5)+TCAT5
	.s TCAT6=$fn(+$g(^TMPItmCat($j,myHisRowID,6)),"",2)
	.s TCATSum6=$g(TCATSum6)+TCAT6
	.s TCAT7=$fn(+$g(^TMPItmCat($j,myHisRowID,7)),"",2)
	.s TCATSum7=$g(TCATSum7)+TCAT7
	.s TCAT8=$fn(+$g(^TMPItmCat($j,myHisRowID,8)),"",2)
	.s TCATSum8=$g(TCATSum8)+TCAT8
	.s TCAT9=$fn(+$g(^TMPItmCat($j,myHisRowID,9)),"",2)
	.s TCATSum9=$g(TCATSum9)+TCAT9
	.s TCAT10=$fn(+$g(^TMPItmCat($j,myHisRowID,10)),"",2)
	.s TCATSum10=$g(TCATSum10)+TCAT10
	.s TCAT11=$fn(+$g(^TMPItmCat($j,myHisRowID,11)),"",2)
	.s TCATSum11=$g(TCATSum11)+TCAT11
	.s TCAT12=$fn(+$g(^TMPItmCat($j,myHisRowID,12)),"",2)
	.s TCATSum12=$g(TCATSum12)+TCAT12
	.s TCAT13=$fn(+$g(^TMPItmCat($j,myHisRowID,13)),"",2)
	.s TCATSum13=$g(TCATSum13)+TCAT13
	.s TCAT14=$fn(+$g(^TMPItmCat($j,myHisRowID,14)),"",2)
	.s TCATSum14=$g(TCATSum14)+TCAT14
	.s TCAT15=$fn(+$g(^TMPItmCat($j,myHisRowID,15)),"",2)
	.s TCATSum15=$g(TCATSum15)+TCAT15
	.s TCAT16=$fn(+$g(^TMPItmCat($j,myHisRowID,16)),"",2)
	.s TCATSum16=$g(TCATSum16)+TCAT16
	.s TCAT17=$fn(+$g(^TMPItmCat($j,myHisRowID,17)),"",2) 
	.s TCATSum17=$g(TCATSum17)+TCAT17
	.s TCAT18=$fn(+$g(^TMPItmCat($j,myHisRowID,18)),"",2)
	.s TCATSum18=$g(TCATSum18)+TCAT18
	.s TCAT19=$fn(+$g(^TMPItmCat($j,myHisRowID,19)),"",2)
	.s TCATSum19=$g(TCATSum19)+TCAT19
	.s TCAT20=$fn(+$g(^TMPItmCat($j,myHisRowID,20)),"",2)
	.s TCATSum20=$g(TCATSum20)+TCAT20
	.s mySum=0
	.s mySum=mySum+TCAT1
	.s mySum=mySum + TCAT2
	.s mySum=mySum + TCAT3
	.s mySum=mySum + TCAT4
	.s mySum=mySum + TCAT5
	.s mySum=mySum + TCAT6
	.s mySum=mySum + TCAT7
	.s mySum=mySum + TCAT8
	.s mySum=mySum + TCAT9
	.s mySum=mySum + TCAT10
	.s mySum=mySum + TCAT11
	.s mySum=mySum + TCAT12
	.s mySum=mySum + TCAT13
	.s mySum=mySum + TCAT14
	.s mySum=mySum + TCAT15
	.s mySum=mySum + TCAT16
	.s mySum=mySum + TCAT17
	.s mySum=mySum + TCAT18
	.s mySum=mySum + TCAT19
	.s mySum=mySum + TCAT20
	.s TSum=$fn(mySum,"",2) ;mySum_"^"_"^"_mySum
	.s InsSum=0.0
	.s PatShareSum=$fn(mySum,"",2)
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
	.s InsSum=0.0
	.s PatShareSum=$fn(myListSum,"",2)
	.d OutputFI
	b		;kill
	
	d ..KillTMP()
	
	
	Quit $$$OK
ResetVariablesFI
	s (TNO,UserName,RepRowID,TCAT1,TCAT2,TCAT3,TCAT4,TCAT5,TCAT6,TCAT7, TCAT8, TCAT9, TCAT10,TCAT11, TCAT12, TCAT13, TCAT14, TCAT15, TCAT16, TCAT17, TCAT18, TCAT19, TCAT20)=""
	s (TSum, InsSum, PatShareSum)=""
	quit
OutputFI
	s Data=$lb(TNO,UserName,RepRowID,TCAT1,TCAT2,TCAT3,TCAT4,TCAT5,TCAT6,TCAT7, TCAT8, TCAT9, TCAT10,TCAT11, TCAT12, TCAT13, TCAT14, TCAT15, TCAT16, TCAT17, TCAT18, TCAT19, TCAT20, TSum, InsSum, PatShareSum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
}

ClassMethod FootINVItemQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FootINVItemQueryExecute ]
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

ClassMethod ReadINSFootDataAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadINSFootDataAllExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReadUserFootDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadUserFootDataExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReadINSFootDataAllExecute(ByRef qHandle As %Binary, INSUserDR As %String = "", StDate As %String = "", StTime As %String = "", EndDate As %String, EndTime As %String, UserName As %String) As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance1","ReadINSFootDataAll","","60220","60336","60407","82739")
	
	;s ^TMP111=UserRowID_"^"_StDate_"^"_StTime_"^"_EndDate_"^"_EndTime
	s:StDate="" StDate=+$h
	s:StTime="" StTime=$p($h,",",2)
	s:EndDate="" EndDate=+$h
	s:EndTime="" EndTime=$p($h,",",2)
	
	;^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	d ResetVariablesIFD
	
	s myINVTSum=0
	s myHandTSum=0
	s myRefTSum=0
	s myGetTSum=0
	s myRTNum=0
	b
	;此Query按照
	s myDate=StDate-1
	;f  s myDate=$o(^DHCOPInsFootI(0,"Date",myDate)) q:(myDate="")  d
	;^DHCOPInsFootI(0,"INSFDate",{HIS_INSFootDate},{HIS_Rowid})
	f  s myDate=$o(^DHCOPInsFootI(0,"INSFDate",myDate)) q:(myDate="")  d
	.s myHisRID=0
	.b
	.q:(EndDate<myDate)
	.f  s myHisRID=$o(^DHCOPInsFootI(0,"INSFDate",myDate, myHisRID))  q:(myHisRID="")  d
	..s myUDR=$p($g(^DHCOPInsFoot(myHisRID)),"^",15)				;HIS_INSFootUser
	..q:((INSUserDR'=myUDR)&&(INSUserDR'=""))
	..s myOperDR=$p($g(^DHCOPInsFoot(myHisRID)),"^",8)				;HIS_User
	..s myUserName=$p($g(^SSU("SSUSR",myOperDR)),"^",2)
	..s myUserCode=$p($g(^SSU("SSUSR",myOperDR)),"^",1)
	..s myTime=$p($g(^DHCOPInsFoot(myHisRID)),"^",14)				;HIS_INSFootTime
	..q:((myDate=StDate)&&(myTime<+StTime)&&(StTime'=""))
	..q:((myDate=EndDate)&&(myTime>+EndTime)&&(EndTime'=""))
	..s myFootUserDR=$p($g(^DHCOPInsFoot(myHisRID)),"^",15)
	..
	..q:((UserName'="")&(UserName'=myUserCode))
	..q:(myFootUserDR="")	;未结算的退出
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
	..;在结算卡支付账目时的记录应该排除在外
	..s myCardPaySum=$p($g(^DHCOPInsFoot(myHisRID)),"^",59)
	..s myRcptNO=$p($g(^DHCOPInsFoot(myHisRID)),"^",10)			;HIS_RcptNO
	..s myReceiptNum=$p($g(^DHCOPInsFoot(myHisRID)),"^",9)		;HIS_Num
	..s myRTNum=myRTNum+myReceiptNum
	..s myFFlag=$p($g(^DHCOPInsFoot(myHisRID)),"^",60)		;HIS_FootFlag
	..q:(myFFlag="S")			;系统自动结算的退出
	..;q:(myCardPaySum'="")
	..
	..d OutputIFD
	
	;合计
	;s (No,RepID,FootDate,FootTime,INVSum,HandSum,BegFootDT,EndFootDT)=""
	d ResetVariablesIFD
	
	;s No="合计"
	s myUserName="合计"
	s INVSum=$fn(myINVTSum,"",2)
	s HandSum=$fn(myHandTSum,"",2)
	s myGetPDSum=$fn(myGetTSum,"",2)
	s myRefPDSum=$fn(myRefTSum,"",2)
	s myReceiptNum=myRTNum
	
	d OutputIFD
	
	Quit $$$OK
ResetVariablesIFD
	s (No,RepID,FootDate,FootTime,INVSum,HandSum,BegFootDT,EndFootDT, myGetPDSum, myRefPDSum, myUserName, myRcptNO, myReceiptNum, myOperDR)=""
	quit
OutputIFD
	s Data=$lb(No,RepID,FootDate,FootTime,INVSum,HandSum,BegFootDT,EndFootDT, myGetPDSum, myRefPDSum, myUserName, myRcptNO, myReceiptNum, myOperDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
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
	
	;^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	d ResetVariablesFR
	
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
	..
	..d OutputFR
	
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
	s (No,RepID,FootDate,FootTime,INVSum,HandSum,BegFootDT,EndFootDT, myGetPDSum, myRefPDSum, myUDR)=""
	quit
OutputFR
	s Data=$lb(No,RepID,FootDate,FootTime,INVSum,HandSum,BegFootDT,EndFootDT, myGetPDSum, myRefPDSum, myUDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
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

ClassMethod UpdateRepForINS(UserRowID As %String = "", INSFUDR As %String, StDate As %String, StTime As %String, EndDate As %String, EndTime As %String) As %String
{
	n (UserRowID, INSFUDR, StDate, StTime, EndDate, EndTime)
	;w ##class(web.udhcOPFinBalance1).UpdateRepForINS("9914","1","07/01/2006","16:44:19","23/05/2006","10:12:30")
	
	s $ZT="ERROR^DHCSSERR"
	
	s ^TMP23=UserRowID_"^"_INSFUDR_"^"_StDate_"^"_StTime_"^"_EndDate_"^"_EndTime
	
	d ..tb()
	
	
	s myCurDate=+$h
	s myCurTime=$p($h,",",2)
	
	s StDate=$zdh(StDate,4)
	s StTime=$zth(StTime)
	s EndDate=$zdh(EndDate,4)
	s EndTime=$zth(EndTime)
	
	s myrtn=0
	s myDate=StDate-1
	f  s myDate=$o(^DHCOPInsFootI(0,"Date",myDate)) q:((myDate="")||(myrtn'=0))  d
	.s myHisRID=0
	.q:(EndDate<myDate)
	.f  s myHisRID=$o(^DHCOPInsFootI(0,"Date",myDate, myHisRID))  q:(myHisRID="")  d
	..s myUDR=$p($g(^DHCOPInsFoot(myHisRID)),"^",8)
	..q:(UserRowID'=myUDR)
	..s myTime=$p($g(^DHCOPInsFoot(myHisRID)),"^",7)
	..q:((myDate=StDate)&&(myTime<StTime))
	..q:((myDate=EndDate)&&(myTime>EndTime))
	..s myFootUserDR=$p($g(^DHCOPInsFoot(myHisRID)),"^",15)
	..q:(myFootUserDR'="")
	..k PLIST
	..b
	..s myrtn=##class(web.UDHCINVPRTReports).SELECT(myHisRID)
	..q:myrtn
	..s PLIST(13)="Y"
	..s PLIST(14)=EndDate				;myCurDate
	..s PLIST(15)=EndTime				;myCurTime
	..s PLIST(16)=INSFUDR
	..s myrtn=##class(web.UDHCINVPRTReports).UPDATE(myHisRID)
	..q:myrtn
	
	i +myrtn=0 d
		.d ..tc()
	e  d
		.Trollback
	
	q myrtn
}

ClassMethod KillTMP() As %String
{
	k ^TMPOPFOper($j)
	k ^TMPTar($j)
	k ^TMPItmCat($j)
}

ClassMethod ReadUnFootDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadUnFootDataExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 读取操作员结算的数据
Query ReadUserFootData(UserRowID As %String = "", StDate As %String = "", StTime As %String = "", EndDate As %String = "", EndTime As %String = "") As %Query(ROWSPEC = "No:%String,RepID:%String,FootDate:%String,FootTime:%String,INVSum:%String,HandSum:%String,BegFootDT:%String,EndFootDT:%String, GetPDSum:%String, RefPDSum:%String, UserRowID:%String")
{
}

ClassMethod ReadUnFootDataExecute(ByRef qHandle As %Binary) As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance1","ReadUnFootData")
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;生成Global,  然后输出，  
	;最后加上合计
	
	d ResetVariablesUF
	
	k ^TMPOPFOper($j)
	k ^TMPOPFOperID($j)
	
	;获取最大的结算日期
	;^DHCINVPRT(0,"HandDate",{PRT_HandinDate},{PRT_Rowid})
	;^DHCINVPRT(0,"User",{PRT_Usr},{PRT_Rowid})
	;找到所有用户的没有结算的最小日期,
	s myCurDate=$zd(+$h,3)
	s myDate=""
	s myUserRID=""
	
	;^DHCINVOICE(0,"USER",{INV_Usr},{INV_rowid})
	;发现门诊发票退出
	s myUserDR=0
	s myINVFlag=""
	s myCount=0
	f  s myUserDR=$o(^DHCINVOICE(0,"USER",myUserDR)) q:(myUserDR="")  d
	.s myINVFlag=""
	.s myINVRowID=0
	.f  s myINVRowID=$o(^DHCINVOICE(0,"USER",myUserDR,myINVRowID)) q:((myINVRowID="")||(myINVFlag="O"))  d
	..s myINVFlag=$p($g(^DHCINVOICE(myINVRowID)),"^",8)
	..q:(myINVFlag'="O")
	..s myUserName=$p($g(^SSU("SSUSR",myUserDR)),"^",2)
	..s myCount=+myCount+1
	..s ^TMPOPFOperID($j, myUserDR)=myUserDR
	
	;^DHCACDi("AccM",0,"User",{AccPD_User_DR},
	s myUserDR=0
	f  s myUserDR=$o(^DHCACDi("AccM",0,"User",myUserDR)) q:(myUserDR="")  d
	.;存在退出
	.q:(myUserDR=$g(^TMPOPFOperID($j,myUserDR)))
	.s myUserName=$p($g(^SSU("SSUSR",myUserDR)),"^",2)
	.s ^TMPOPFOperID($j, myUserDR)=myUserDR
	.s myCount=+myCount+1
	
	;No,UserDR,UserName,INVNum, INVSum, ParkINVNum, ParkINVSum, PreNum, PreSum, RefPreNum, RefPreSum TSum	
	if (+myCount=0){
		d OutputUF
		Quit $$$OK
	}
	
	s myUserDR=0
	s myEndDate=+$h
	s myEndTime=$p($h,",",2)
	
	s No=0
	f  s myUserDR=$o(^TMPOPFOperID($j,myUserDR))  q:(myUserDR="")  d
	.s myUserName=$p($g(^SSU("SSUSR",myUserDR)),"^",2)
	.s sttimeinfo=##class(web.udhcOPHandin1).GetDate(myUserDR, myEndDate)
	.s stdate=$p(sttimeinfo,"^",1)
	.s sttime=$p(sttimeinfo,"^",2)
	.d ##class(web.udhcOPHandin1).KillTmp()
	.s myIPRepInfo=##class(web.udhcOPHandin1).GetINVPRTRepInfo(stdate,sttime,myEndDate,myEndTime, myUserDR)
	.s myIPRepInfo1=myIPRepInfo
	.s myIPRtn=$p(myIPRepInfo1,$c(3),1)
	.s myIPRepInfo=$p(myIPRepInfo1,$c(3),2)
	.s myIPCPPRepInfo=$p(myIPRepInfo1,$c(3),3)
	.s myINVSum=""
	.s myINVNum=""
	.s ^TMPOPFOper($j,myUserDR,"INVSum")=+$g(^TMPOPFOper($j,myUserDR,"INVSum"))+myINVSum
	.s ^TMPOPFOper($j,myUserDR,"INVNum")=+$g(^TMPOPFOper($j,myUserDR,"INVNum"))+myINVNum
	.s myAPIRepInfo=##class(web.udhcOPHandin1).GetAPIRepInfo(stdate,sttime,myEndDate,myEndTime, myUserDR, myIPCPPRepInfo)
	.s myAPRtn=$p(myAPIRepInfo,$c(3),1)
	.s myAPIRepInfo=$p(myAPIRepInfo,$c(3),2)
	.s myPDInfo=##class(web.udhcOPHandin1).GetPRDRepINfo(stdate,sttime,myEndDate,myEndTime, myUserDR)
	.;****************************************************************************
	.;;;如果有错误，下面的都换,与Handin1类保持一致
	.;****************************************************************************
	.s myAPIInfo=$p(myAPIRepInfo,$c(3))
	.s myAPIInfo1=$p(myAPIInfo,$c(4),1)
	.s myAPIInfo2=$p(myAPIInfo,$c(4),2)
	.s myAPIInfo3=$p(myAPIInfo,$c(4),3)
	.s myAPIInfo4=$p(myAPIInfo,$c(4),4)
	.;打印票据数量
	.s myPRTNum=0
	.s myPRTNum=myPRTNum+$p(myIPRepInfo,"^",4)			;
	.s myPRTNum=myPRTNum+$p(myIPRepInfo,"^",5)			;
	.;s myPRTNum=myPRTNum+$p(myIPRepInfo,"^",22)			;去掉CPP支付的发票
	.s myPRTNum=myPRTNum+$p(myIPRepInfo,"^",24)
	.s myPRTNum=myPRTNum+$p(myAPIInfo2,"^",2)			;卡支付中收费票据数量
	.b			;打印票据数量
	.;打印票据金额
	.s myPRTSum=+$p(myIPRepInfo,"^",18)					;现金收费的票据金额
	.s myPRTSum=+myPRTSum+$p(myAPIInfo2,"^",1)					;卡支付中收费票据金额
	.;作废的发票数量
	.s myPRTParkNum=0
	.s myPRTParkNum=+myPRTParkNum+$p(myIPRepInfo,"^",6)			;
	.s myPRTParkNum=+myPRTParkNum+$p(myIPRepInfo,"^",8)			;
	.s myPRTParkNum=+myPRTParkNum+$p(myAPIInfo3,"^",2)		;卡支付中退费票据数量
	.s myPRTParkNum=+myPRTParkNum+$p(myAPIInfo4,"^",2)		;卡支付中红冲票据数量
	.;作废发票金额		；；
	.s myPRTParkSum=0
	.s myPRTParkSum=+myPRTParkSum+$p(myIPRepInfo,"^",7)			;
	.s myPRTParkSum=+myPRTParkSum+$p(myIPRepInfo,"^",9)			;
	.s myPRTParkSum=+myPRTParkSum+$p(myAPIInfo3,"^",1)		;卡支付中退费票据
	.s myPRTParkSum=+myPRTParkSum+$p(myAPIInfo4,"^",1)		;卡支付中红冲票据
	.;卡支付返回值
	.;s myNINfo=AccNTotSum_"^"_AccNNum_"^"_AccNINVInfo_"^"_AccNCardPaySum
	.;s myNINfo=myNINfo_"^"_AccNYBPaySum_"^"_AccNRefSum_"^"_AccNCashSum
	.;s myParkInfo=AccParkTotSum_"^"_AccParkNum_"^"_AccParkINVInfo_"^"_AccParkCardPaySum
	.;s myParkInfo=myParkInfo_"^"_AccParkYBPaySum_"^"_AccParkRefSum_"^"_AccParkCashSum
	.;s myRefInfo=AccRefTotSum_"^"_AccRefundNum_"^"_AccRefundINVInfo_"^"_AccRefCardPaySum
	.;s myRefInfo=myRefInfo_"^"_AccRefYBPaySum_"^"_AccRefRefSum_"^"_AccRefCashSum
	.;现金支付返回值
	.;s ret=$ZD(stdate,4)_"^"_$zt(sttime,1)_"^"_INVNOinfo_"^"_cashnum_"^"_checknum	;0-4
	.;s ret=ret_"^"_cancelnum_"^"_cancelsum_"^"_refundnum_"^"_refundsum_"^"_handinsum	;5-9
	.;s ret=ret_"^"_handcash_"^"_handcheck_"^"_sksum_"^"_tksum_"^"_jybs_"^"_CurDate	;10-15
	.;s ret=ret_"^"_CurTime_"^"_FootTotSum		;16-17
	.;s ret=ret_"^"_$fn(PayorSum,"",2)_"^"_RefundINVInfo_"^"_ParkINVInfo	;18-20
	.;s myOthPayInfo=myCPPNum_"^"_$fn(myCPPSum,"",2)_"^"_myOtherNum_"^"_$fn(myOtherSum,"",2)  ;21--24
	.;其中现金
	.s myCashSum=+$p(myIPRepInfo,"^",11)
	.;把门诊收费中的退费钱数加到现金中		；与原来的分解有些差异；把收来的钱分解
	.s myCashSum=+myCashSum+$p(myIPRepInfo,"^",7)
	.s myCashSum=+myCashSum+$p(myIPRepInfo,"^",9)
	.s myCashSum=+myCashSum+$p(myAPIInfo3,"^",7)
	.s myCashSum=+myCashSum+$p(myAPIInfo4,"^",7)
	.s myCashSum=+myCashSum+$p(myPDInfo,"^",5)
	.;其中支票
	.s myCheckSum=0
	.s myCheckSum=+$p(myIPRepInfo,"^",12)
	.s myCheckSum=+myCheckSum+$p(myPDInfo,"^",6)
	.;其中其他支付方式
	.s myOtherSum=0
	.s myOtherSum=+$p(myIPRepInfo,"^",25)
	.s myOtherSum=+myOtherSum+$p(myPDInfo,"^",7)
	.;实际收款
	.s mySKSum=0
	.s mySKSum=$p(myIPRepInfo,"^",13)
	.s mySKSum=+mySKSum+$p(myPDInfo,"^",2)
	.s myTKSum=0
	.s myTKSum=$p(myIPRepInfo,"^",14)
	.s myTKSum=+myTKSum + $p(myAPIInfo3,"^",7)			;卡支付退款时退现金总额
	.s myTKSum=+myTKSum+$p(myAPIInfo4,"^",7)				;卡支付红冲时退现金总额
	.s myTKSum=+myTKSum+$p(myPDInfo,"^",4)
	.s myPRTPatSum=+$p(myIPRepInfo,"^",10)
	.;医保退款
	.s myAccPatSum=+$p(myAPIInfo2,"^",5)
	.s myYBPaySum=+$p(myAPIInfo2,"^",5)
	.;退费时回收医保支付
	.s myAccPatSum=+myAccPatSum+$p(myAPIInfo3,"^",5)
	.s myYBPaySum=myYBPaySum+$p(myAPIInfo3,"^",5)
	.;退款时退现金总额
	.s myAccPatSum=+myAccPatSum+$p(myAPIInfo3,"^",7)
	.;红冲时回收医保支付
	.s myAccPatSum=+myAccPatSum+$p(myAPIInfo4,"^",5)
	.s myYBPaySum=myYBPaySum+$p(myAPIInfo4,"^",5)
	.;红冲时退现金总额
	.s myAccPatSum=+myAccPatSum+$p(myAPIInfo4,"^",7)
	.;预交金额
	.s myPDPatSum=+$p(myPDInfo,"^",2)+$p(myPDInfo,"^",4)
	.;收预交金笔数
	.s myPreNum=+$p(myPDInfo,"^",1)
	.;s myInfo=mypdnum_"^"_pdsum_"^"_refundnum_"^"_refundsum
	.;s myInfo=myInfo_"^"_cashsum_"^"_chequesum_"^"_othersum
	.;收预交金金额
	.s myPreSum=+$p(myPDInfo,"^",2)
	.;退预交金笔数
	.s myParkPreNum=+$p(myPDInfo,"^",3)
	.;退预交金金额
	.s myParkPreSum=+$p(myPDInfo,"^",4)
	.;实际上缴额
	.s myPatSum=+myPRTPatSum+myAccPatSum+myPDPatSum
	.s myOtherPaySum=+myPRTPatSum+myAccPatSum			;其他支付额
	.;数值类型转换
	.;myPRTNum
	.s myPRTSum=$fn(myPRTSum,"",2)
	.;myPRTParkNum
	.s myPRTParkSum=$fn(myPRTParkSum,"",2)
	.;myPreNum
	.s myPreSum=$fn(myPreSum,"",2)
	.;myParkPreNum
	.s myParkPreSum=$fn(myParkPreSum,"",2)
	.s myOtherPaySum=$fn(myOtherPaySum,"",2)
	.s myPatSum=$fn(myPatSum,"",2)
	.s No=No+1
	.b
	.d OutputUF
	
	;myPRTNum, myPRTSum, myPRTParkNum, myPRTParkSum, myPreNum, myPreSum, myParkPreNum, myParkPreSum, myOtherPaySum, myPatSum
	;b		;;;TMP
	
	;合计
	s No=""
	s UserDR=""
	s UserName="合计:"
	;s INVNum=myTNum
	;s INVSum=myTSum
	;s ParkNum=myParkTNum
	;s ParkSum=myParkTSum
	;s TSum=+INVSum+ParkSum
	;d OutputUF
	
	k ^TMPOPFOper($j)
	k ^TMPOPFOperID($j)
	
	Quit $$$OK
ResetVariablesUF
	s (No, myUserName, myUserDR, myPRTNum, myPRTSum, myPRTParkNum, myPRTParkSum, myPreNum, myPreSum, myParkPreNum, myParkPreSum, myOtherPaySum, myPatSum)=""
	quit
OutputUF
	s Data=$lb(No,myUserName, myUserDR, myPRTNum, myPRTSum, myPRTParkNum, myPRTParkSum, myPreNum, myPreSum, myParkPreNum, myParkPreSum, myOtherPaySum, myPatSum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
}

ClassMethod ParkINVDetailsExecute(ByRef qHandle As %Binary, UserCode As %String, StDate As %Date, EndDate As %Date, INVNo As %String, UserCodeA As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	;
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance1","ParkINVDetails","",+$h-10,+$h,"")
	s stdate=$g(StDate)				;;$p(sttimeinfo,"^",1)
	s EndDate=$g(EndDate)
	
	s PatPaySum=0
	s myIdx=0
	
	d ValidateDataUPark
	i (stdate'="")  d
	.s snum=0
	.f pdate=stdate:1:EndDate  d
	..q:$d(^DHCINVPRT(0,"Date",pdate))=0
	..s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:PRTrowid=""  d
	...q:($d(^DHCINVPRT(PRTrowid))=10)
	...s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)		;;->SS_User
	...s myUCode=$p($g(^SSU("SSUSR",PRTUser)),"^",1)
	...q:(UserCode'="")&(myUCode'=UserCode)
	...q:(UserCodeA'="")&(myUCode'=UserCodeA)
	...s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	...;q:(pdate=EndDate)&(PRTTime>EndTime)
	...s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	...;q:Handin="Y"
	...s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1)	;总收入
	...s PrtPatPay=$p(^DHCINVPRT(PRTrowid),"^",16)	;票据金额
	...s PrtinvDr=$p(^DHCINVPRT(PRTrowid),"^",13)		;原票据的RowID  正常票据=??
	...s Flag=$p(^DHCINVPRT(PRTrowid),"^",8)
	...s PayMode=""
	...;本收款员作废的单据?红冲得单据
	...q:(Flag="N")
	...i ((Flag="A")||(Flag="S"))&(PrtinvDr'="")  d
	....;s PrtNO=$p(^DHCINVPRT(PrtinvDr),"^",14)			;作废票据的原票据号码?
	....s PrtNO=$p(^DHCINVPRT(PrtinvDr),"^",14)			;红冲票据  原票据的票据号码
	....q:(PrtNO="")
	....q:(INVNo'="")&(INVNo'=PrtNO)
	....;重新写的红冲单据
	....;d ReadINVDUPark
	....s ParkDate=$p($G(^DHCINVPRT(PRTrowid)),"^",5)		;;作废日期
	....s ParkTime=$p($G(^DHCINVPRT(PRTrowid)),"^",20)		;作废时间
	....s PRTDate=$p($G(^DHCINVPRT(PrtinvDr)),"^",5)		;
	....s sTime=$p($G(^DHCINVPRT(PrtinvDr)),"^",20)
	....s myParkDT=$zd(ParkDate,3)_" "_$zt(ParkTime)
	....
	....s PRTAcount=$p(^DHCINVPRT(PrtinvDr),"^",1)	;总收入
	....s PrtPatPay=$p(^DHCINVPRT(PrtinvDr),"^",16)	;票据金额
	....s myParkUseDR=$p(^DHCINVPRT(PRTrowid),"^",21)		;;->SS_User作废发票的人
	....s myParkName=$p($g(^SSU("SSUSR",myParkUseDR)),"^",2)			;UserName
	....
	....s myPRTUseDR=$p(^DHCINVPRT(PrtinvDr),"^",21)		;;->SS_User  大印发票的人
	....s myPRTUName=$p($g(^SSU("SSUSR",myPRTUseDR)),"^",2)			;UserName
	....;新发票的rowid->部分退费
	....;^DHCINVPRT(0,"OldINV",{PRT_OldINV_DR},{PRT_Rowid})
	....s myNewPrtRowID=$o(^DHCINVPRT(0,"OldINV",PrtinvDr,0))
	....s myNewINVNo=""
	....s myNewPRTAcount=0
	....s myNewPrtPatPay=0
	....s myPRTRtnSum=0
	....i myNewPrtRowID'="" d
	.....s myNewINVNo=$p(^DHCINVPRT(myNewPrtRowID),"^",14)		;
	.....s myNewPRTAcount=$p(^DHCINVPRT(myNewPrtRowID),"^",1)	;总收入
	.....s myNewPrtPatPay=$p(^DHCINVPRT(myNewPrtRowID),"^",16)	;票据金额
	....s myPRTRtnSum=$zabs(PrtPatPay)-$zabs(myNewPrtPatPay)
	....s myIdx=myIdx+1
	....d OutputRowUPark
	
	;No, myPRTUName, PrtNO, PRTAcount, myParkName, myNewINVNo, myPRTRtnSum, myParkDT
	
	s stdate=$g(StDate)				;;$p(sttimeinfo,"^",1)
	
	;d ValidateDataUPark
	
	;增加门诊集中打印发票的节点查询
	;作废/红冲发票的查询
	i (stdate'="")  d
	.s snum=0
	.;;^DHCINVPRTAPi(0,"Date",{API_Date},{API_RowID})
	.f pdate=stdate:1:EndDate  d
	..q:($d(^DHCINVPRTAPi(0,"Date",pdate))=0)
	..s PRTrowid=""
	..f  s PRTrowid=$o(^DHCINVPRTAPi(0,"Date",pdate,PRTrowid)) q:PRTrowid=""  d
	...
	...q:($d(^DHCINVPRTAP(PRTrowid))=10)
	...;b		;Acc
	...s PRTUser=$p(^DHCINVPRTAP(PRTrowid),"^",5)		;;API_PUser_DR->SS_User
	...s myUCode=$p($g(^SSU("SSUSR",PRTUser)),"^",1)
	...q:(UserCode'="")&(myUCode'=UserCode)
	...s PRTTime=$p(^DHCINVPRTAP(PRTrowid),"^",4)
	...s myCheckDate=$p(^DHCINVPRTAP(PRTrowid),"^",7)
	...s PRTAcount=$p(^DHCINVPRTAP(PRTrowid),"^",1)			;总收入API_Amount
	...s PrtPatPay=$p(^DHCINVPRTAP(PRTrowid),"^",13)		;票据金额API_PatientShare
	...;s PrtNO=$p(^DHCINVPRTAP(PRTrowid),"^",6)				;API_INVNo
	...s PrtinvDr=$p(^DHCINVPRTAP(PRTrowid),"^",10)		;原票据的RowID API_PayINV_DR  正常票据=??
	...s Flag=$p(^DHCINVPRTAP(PRTrowid),"^",2)
	...s PayMode=""
	...;本收款员作废的单据?红冲得单据
	...q:(Flag="N")
	...i ((Flag="A")||(Flag="S"))&&(PrtinvDr'="")  d
	....s PrtNO=$p(^DHCINVPRTAP(PrtinvDr),"^",6)			;红冲票据  原票据的票据号码
	....q:(INVNo'="")&(INVNo'=PrtNO)
	....s ParkDate=$p($G(^DHCINVPRTAP(PRTrowid)),"^",3)		;;作废日期
	....s ParkTime=$p($G(^DHCINVPRTAP(PRTrowid)),"^",4)		;作废时间
	....s myParkDT=$zd(ParkDate,3)_" "_$zt(ParkTime)
	....;
	....s myParkUseDR=$p(^DHCINVPRTAP(PRTrowid),"^",5)		;;->SS_User
	....s myParkName=$p($g(^SSU("SSUSR",myParkUseDR)),"^",2)			;UserName
	....;
	....;s myPRTUseDR=$p(^DHCINVPRTAP(PRTrowid),"^",5)		;;->SS_User
	....;s myPRTUName=$p($g(^SSU("SSUSR",myPRTUseDR)),"^",2)			;UserName
	....
	....s PRTDate=$p($G(^DHCINVPRTAP(PrtinvDr)),"^",3)		;发票打印时间
	....s sTime=$p($G(^DHCINVPRTAP(PrtinvDr)),"^",4)		;
	....s PRTAcount=$p(^DHCINVPRTAP(PrtinvDr),"^",1)			;总收入API_Amount
	....s PrtPatPay=$p(^DHCINVPRTAP(PrtinvDr),"^",13)		;票据金额API_PatientShare
	....s myPRTUseDR=$p(^DHCINVPRTAP(PrtinvDr),"^",5)		;;->SS_User   打印发票人
	....s myPRTUName=$p($g(^SSU("SSUSR",myPRTUseDR)),"^",2)			;UserName
	....
	....;^DHCINVPRTAPi(0,"OldADR",{API_OldAPINV_DR},{API_RowID})
	....s myNewPrtRowID=$o(^DHCINVPRTAPi(0,"OldADR",PrtinvDr,0))
	....i myNewPrtRowID'="" d
	.....s myNewINVNo=$p(^DHCINVPRTAP(myNewPrtRowID),"^",6)		;
	.....s myNewPRTAcount=$p(^DHCINVPRTAP(myNewPrtRowID),"^",1)	;总收入
	.....s myNewPrtPatPay=$p(^DHCINVPRTAP(myNewPrtRowID),"^",13)	;票据金额
	....s myPRTRtnSum=$zabs(PrtPatPay)-$zabs(myNewPrtPatPay)
	....s myIdx=myIdx+1
	....d OutputRowUPark
	
	;myIdx, myPRTUName, PrtNO, PRTAcount, myParkName, myNewINVNo, myPRTRtnSum, myParkDT
	
	Set qHandle=$lb(0,repid,0)
	
	Quit $$$OK
OutputRowUPark
	set Data=$lb(myIdx, myPRTUName, PrtNO, PRTAcount, myParkName, myNewINVNo, myPRTRtnSum, myParkDT)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ValidateDataUPark
	set (myIdx, myPRTUName, PrtNO, PRTAcount, myParkName, myNewINVNo, myPRTRtnSum, myParkDT)=""
	
	quit
}

ClassMethod ParkINVDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ParkINVDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ParkINVDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ParkINVDetailsExecute ]
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

ClassMethod ReadParkItemDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadParkItemDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod ReadParkItemDetailsExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, AuditLocDR As %String, CardNo As %String, AuditUserDR As %String, ARCIMDR As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	;合肥退费统计报表
	
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance1","ReadParkItemDetails",+$h-10,+$h,"", "", "", "")
	s stdate=$g(StDate)				;;$p(sttimeinfo,"^",1)
	s EndDate=$g(EndDate)
	
	s PatPaySum=0
	s myIdx=0
	;StDate As %String, EndDate As %String, 
	;AuditLocDR As %String, 
	;CardNo As %String, 
	;AuditUserDR As %String, 
	;ARCIMDR As %String
	if (stdate=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	d ValidateDataPID
	
	s snum=0
	f pdate=stdate:1:EndDate  d
	.q:$d(^DHCINVPRT(0,"Date",pdate))=0
	.s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:PRTrowid=""  d
	..q:($d(^DHCINVPRT(PRTrowid))=10)
	..s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)		;;->SS_User
	..s myUCode=$p($g(^SSU("SSUSR",PRTUser)),"^",1)
	..;q:(UserCode'="")&(myUCode'=UserCode)
	..s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	..s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	..s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1)	;总收入
	..s PrtPatPay=$p(^DHCINVPRT(PRTrowid),"^",16)	;票据金额
	..s PrtinvDr=$p(^DHCINVPRT(PRTrowid),"^",13)		;原票据的RowID  正常票据=??
	..s myPAPMIDR=$p(^DHCINVPRT(PRTrowid),"^",15)			;
	..s myPatName=$p(^PAPER(myPAPMIDR,"ALL"),"^",1)
	..s myPMSub=0
	..s myAPLDR=""
	..f  s myPMSub=$o(^DHCINVPRT(PRTrowid,"P",myPMSub)) q:(myPMSub="")!(myAPLDR'="")  d
	...s myAPLDR=$p(^DHCINVPRT(PRTrowid,"P",myPMSub),"^",8)
	..s myAccRowID=+myAPLDR
	..s myCardNo=$p($g(^DHCACD("AccM",+myAccRowID)),"^",4)		;AccM_CardNo
	..q:(CardNo'="")&(CardNo'=myCardNo)
	..s Flag=$p(^DHCINVPRT(PRTrowid),"^",8)
	..s PayMode=""
	..;本收款员作废的单据?红冲得单据
	..q:(Flag="N")
	..q:((Flag="A")||(Flag="S"))&(PrtinvDr="")
	..s PrtNO=$p(^DHCINVPRT(PrtinvDr),"^",14)			;红冲票据  原票据的票据号码
	..;重新写的红冲单据
	..s ParkDate=$p($G(^DHCINVPRT(PRTrowid)),"^",5)		;;作废日期
	..s ParkTime=$p($G(^DHCINVPRT(PRTrowid)),"^",20)		;作废时间
	..s PRTDate=$p($G(^DHCINVPRT(PrtinvDr)),"^",5)		;开发票日期
	..s sTime=$p($G(^DHCINVPRT(PrtinvDr)),"^",20)			;开发票时间
	..s myParkDT=$zd(ParkDate,3)_" "_$zt(ParkTime)
	..s myParkUseDR=$p(^DHCINVPRT(PRTrowid),"^",21)		;;->SS_User作废发票的人
	..s myParkName=$p($g(^SSU("SSUSR",myParkUseDR)),"^",2)			;UserName
	..s myPrtNo=$p($G(^DHCINVPRT(PrtinvDr)),"^",14)		;;
	..s myARCIMDR=""
	..;q:(ARCIMDR'="")&(ARCIMDR'=myARCIMDR)
	..s myNewPrtRowID=$o(^DHCINVPRT(0,"OldINV",PrtinvDr,0))
	..s myARCIMDesc=""
	..s myAuditUserDR=$p(^DHCINVPRT(PrtinvDr),"^",25)			;PRT_AllRefundUser
	..q:(AuditUserDR'="")&(AuditUserDR'=myAuditUserDR)
	..s myAuditName=""
	..s:(myAuditUserDR'="") myAuditName=$p($g(^SSU("SSUSR",myAuditUserDR)),"^",2)			;UserName
	..s myRefReason=$p(^DHCINVPRT(PrtinvDr),"^",32)			;PRT_RefAuditLocDR
	..s myAuditLocDR=$p(^DHCINVPRT(PrtinvDr),"^",33)			;PRT_RefAuditLocDR
	..q:(AuditLocDR'="")&(AuditLocDR'=myAuditLocDR)
	..s myAuditLocDesc=""
	..s:(myAuditLocDR'="") myAuditLocDesc=$p($g(^CTLOC(myAuditLocDR)),"^",2)
	..;q:(myAuditLocDR="")&(myAuditUserDR="")
	..;PrtinvDr  原发票RowID
	..;^DHCBCI(0,"INV",{DHCBCI_INVDR},{DHCBCI_Rowid})
	..
	..s myItemList=..GetParkACIMDetails(PrtinvDr,myNewPrtRowID)
	..s mylen=$l(myItemList,$c(2))
	..f i=1:1:mylen  d
	...s myARCStr=$p(myItemList,$c(2),i)
	...q:(myARCStr="")
	...s myARCIMDesc=$p(myARCStr,"^",1)
	...s myARCIMParkSum=$p(myARCStr,"^",2)
	...s myIdx=myIdx+1
	...d OutputRowPID
	
	;myIdx, myPrtNo, myCardNo, myPatName, myRefReason, myParkDT, myARCIMDesc, myARCIMParkSum, myAuditLocDesc, myAuditName
	
	Set qHandle=$lb(0,repid,0)
	
	Quit $$$OK
OutputRowPID
	set Data=$lb(myIdx, myPrtNo, myCardNo, myPatName, myRefReason, myParkDT, myARCIMDesc, myARCIMParkSum, myAuditLocDesc, myAuditName)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ValidateDataPID
	set (myIdx, myPrtNo, myCardNo, myPatName, myRefReason, myParkDT, myARCIMDesc, myARCIMParkSum, myAuditLocDesc, myAuditName)=""
	
	quit
}

ClassMethod GetParkACIMDetails(OldPRTRowID As %String, NewPRTRowID As %String) As %String
{
	n (OldPRTRowID, NewPRTRowID)
	;w ##class(web.udhcOPFinBalance1).GetParkACIMDetails("2940", "2942")
	
	s mystr=""
	s myOldPBRowID=""
	s myNewPBRowID=""
	
	s myOldBCIRowID=0
	f  s myOldBCIRowID=$o(^DHCBCI(0,"INV",OldPRTRowID,myOldBCIRowID)) q:(myOldBCIRowID="")  d
	.s myOldPBRowID=$p($g(^DHCBCI(myOldBCIRowID)),"^",2)			;DHCBCI_PatBillDR
	.;^DHCPB({DHC_PatientBill.PB_RowId},"O",{PBO_ChildSub})
	.s myOldPBSub=0
	.f  s myOldPBSub=$o(^DHCPB(myOldPBRowID,"O",myOldPBSub))  q:(myOldPBSub="")  d
	..s myOldARCIMDR=$p($g(^DHCPB(myOldPBRowID,"O",myOldPBSub)),"^",3)
	..s myARCIMDesc=$p($g(^ARCIM(+myOldARCIMDR,1,1)),"^",2)
	..s myOldOEORIDR=$p($g(^DHCPB(myOldPBRowID,"O",myOldPBSub)),"^",4)
	..s myOldPatShare=$p($g(^DHCPB(myOldPBRowID,"O",myOldPBSub)),"^",11)
	..s myFlag=0
	..q:(+myOldPatShare=0)
	..;
	..
	..i NewPRTRowID="" d
	...s mystr=mystr_myARCIMDesc_"^"_$fn(myOldPatShare,"",2)_$c(2)
	..q:(NewPRTRowID="")
	..s myNewBCIRowID=0
	..f  s myNewBCIRowID=$o(^DHCBCI(0,"INV",NewPRTRowID,myNewBCIRowID)) q:(myNewBCIRowID="")!(+myFlag=1)  d
	...s myNewPBRowID=$p($g(^DHCBCI(myNewBCIRowID)),"^",2)			;DHCBCI_PatBillDR
	...;^DHCPB({DHC_PatientBill.PB_RowId},"O",{PBO_ChildSub})
	...s myNewPBSub=0
	...f  s myNewPBSub=$o(^DHCPB(myNewPBRowID,"O",myNewPBSub))  q:(myNewPBSub="")!(+myFlag=1)  d
	....s myNewOEORIDR=$p($g(^DHCPB(myNewPBRowID,"O",myNewPBSub)),"^",4)
	....s myNewARCIMDR=$p($g(^DHCPB(myNewPBRowID,"O",myNewPBSub)),"^",3)
	....i (myNewOEORIDR=myOldOEORIDR)&(myNewARCIMDR=myOldARCIMDR) d
	.....s myFlag=1
	.....s myNewPatShare=$p($g(^DHCPB(myNewPBRowID,"O",myNewPBSub)),"^",11)
	.....s myOldPatShare=myOldPatShare-myNewPatShare
	..;^ARCIM(myOldARCIMDR,1,1)
	..q:(+myOldPatShare=0)
	..s mystr=mystr_myARCIMDesc_"^"_$fn(myOldPatShare,"",2)_$c(2)
	
	;项目^金额_$c(2)_项目^金额
	
	q mystr
}

ClassMethod ReadUnFootDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadUnFootDataExecute ]
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

ClassMethod ReadParkItemDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadParkItemDetailsExecute ]
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

ClassMethod tc()
{
	n SQLCODE
	TCOMMIT  s SQLCODE=$zu(34)
	q
}

/// 打印发票后结算的项目分类
Query FootINVItemQuery(StDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "TNO:%String,UserName:%String,RepRowID:%String,TCAT1:%String,TCAT2:%String,TCAT3:%String,TCAT4:%String,TCAT5:%String,TCAT6:%String,TCAT7:%String, TCAT8:%String, TCAT9:%String, TCAT10:%String,TCAT11:%String, TCAT12:%String, TCAT13:%String, TCAT14:%String, TCAT15:%String, TCAT16:%String, TCAT17:%String, TCAT18:%String, TCAT19:%String, TCAT20:%String, TSum:%String, INVNum:%String, ParkINVNum:%String, TNum:%String")
{
}

/// 读取操作员交给财务，由财务办理结算后的数据列表
Query ReadINSFootDataAll(INSUserDR As %String = "", StDate As %String = "", StTime As %String = "", EndDate As %String, EndTime As %String, UserName As %String) As %Query(ROWSPEC = "No:%String,RepID:%String,FootDate:%String,FootTime:%String,INVSum:%String,HandSum:%String,BegFootDT:%String,EndFootDT:%String, GetPDSum:%String, RefPDSum:%String, UserName:%String, RcptNO:%String, ReceiptNum:%String, sUser:%String")
{
}

/// /结算的项目
Query FootItemQuery(StDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "TNO:%String,UserName:%String,RepRowID:%String,TCAT1:%String,TCAT2:%String,TCAT3:%String,TCAT4:%String,TCAT5:%String,TCAT6:%String,TCAT7:%String, TCAT8:%String, TCAT9:%String, TCAT10:%String,TCAT11:%String, TCAT12:%String, TCAT13:%String, TCAT14:%String, TCAT15:%String, TCAT16:%String, TCAT17:%String, TCAT18:%String, TCAT19:%String, TCAT20:%String, TSum:%String, InsSum:%String, PatShareSum:%String")
{
}

Query ReadUnFootData() As %Query(ROWSPEC = "No:%String, UserName:%String, UserDR:%String, PRTNum:%String, PRTSum:%String, PRTParkNum:%String, PRTParkSum:%String, PreNum:%String, PreSum:%String, ParkPreNum:%String, ParkPreSum:%String, OtherPaySum:%String, PatSum:%String")
{
}

/// 按照时间段等条件查询废票
Query ParkINVDetails(UserCode As %String, StDate As %Date, EndDate As %Date, INVNo As %String, UserCodeA As %String) As %Query(ROWSPEC = "No:%String, PRTUName:%String, PrtNO:%String, PRTAcount:%String, ParkName:%String, NewINVNo:%String, PRTRtnSum:%String, ParkDT:%String")
{
}

/// 查询门诊退费项目列表
Query ReadParkItemDetails(StDate As %String, EndDate As %String, AuditLocDR As %String, CardNo As %String, AuditUserDR As %String, ARCIMDR As %String) As %Query(ROWSPEC = "No:%String,TPrtNO:%String,TCardNO:%String,TPatName:%String,TRefReason:%String,TRefDateTime:%String,TRefItemDesc:%String,TSum:%String,TAuditLoc:%String,TAuditUser:%String")
{
}

}
