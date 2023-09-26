/// 华西的报表没有办理结算的报表流水账
Class web.udhcOPFinBalance7UnFootQ Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetUnFootDataForAll(HZJsName As %String, CatJsName As %String, PMJsName As %String, StDate As %String = "", StTime As %String = "", EndDate As %String = "", EndTime As %String = "", SubAvailHosp As %String = "") As %String
{
	;w ##class(web.udhcOPFinBalance7UnFootQ).GetUnFootDataForAll("","","",+$h-90,"",+$h,"",2)
	;, EndDate As %String, EndTime As %String
	;调试代码
	;w ##class(web.udhcOPHandin7FQuery).GetHandin("","","6")
	;w ##class(web.udhcOPHandin7FQuery).GetCardINVRepInfo(60315,39695,60949,0,27)
	;w ##class(web.udhcOPHandin7FQuery).KillTmp()
	;^TMPHandin=5%%%
	n (HZJsName, CatJsName, PMJsName,StDate , StTime , EndDate, EndTime, SubAvailHosp)
	s ^TMPFDFDFDF=$lb(HZJsName, CatJsName, PMJsName,StDate , StTime , EndDate, EndTime, SubAvailHosp)
	
	i StTime="" s StTime="0"
	i EndTime="" s EndTime="86399"
	i StDate["/" s StDate=$zdh(StDate,4)
	i EndDate["/" s EndDate=$zdh(EndDate,4)
	
	s myrtn=0
	s stdate=StDate
	s sttime=StTime
	s EndDate=EndDate
	s EndTime=EndTime
	s hUser=""
	
	d ##class(web.udhcOPHandin7FQuery).KillTmp()
	
	d ..KillTMP()
	
	;s EndDate=+$h		;$zdh(EndDate,3)
	;s EndTime=$p($h,",",2)			;$zth(EndTime,1)
	
	;s myINVInfo=##class(web.udhcOPHandin7FQuery).SetINVRepInfo(stdate,sttime,EndDate,EndTime, hUser)
	;b	;;;myINVInfo
	s myFootFlag="A"
	s myRepObj=##class(web.DHCEntity.OPC.ReportsInfos).%New()
	;s myIPRepInfo=##class(web.udhcOPHandin7FQuery).GetINVPRTRepInfo(stdate,sttime,EndDate,EndTime, hUser, .myRepObj)
	s myIPRepInfo = ##class(web.DHCBL.OPC.ReportsInfos).GetINVPRTRepInfo(stdate,sttime,EndDate,EndTime, .myRepObj, myFootFlag)
	;b	;myIPRepInfo
	
	;s myAPIObj=##class(web.DHCEntity.OPC.ReportsInfo).%New()
	s myIPCPPRepInfo=""
	s myAPIRepInfo=##class(web.udhcOPHandin7FQuery).GetAPIRepInfo(stdate,sttime,EndDate,EndTime, hUser, myIPCPPRepInfo, .myRepObj)
	
	;s myPDObj=##class(web.DHCEntity.OPC.ReportsInfo).%New()
	s myPDInfo=##class(web.udhcOPHandin7FQuery).GetPRDRepINfo(stdate,sttime,EndDate,EndTime, hUser, .myRepObj)
	b	;PRD   OK
	s myPDRtn=$p(myPDInfo,$c(3),1)
	s myPDInfo=$p(myPDInfo,$c(3),2)
	
	;s myCardINVInfo=##class(web.udhcOPHandin7FQuery).GetCardINVRepInfo(stdate,sttime,EndDate,EndTime, hUser, .myRepObj)
	s myCardINVInfo=##class(web.DHCBL.OPC.ReportsInfos).GetCardINVRepInfo(stdate,sttime,EndDate,EndTime, hUser, .myRepObj, myFootFlag)
	s myCardINVRtn=$p(myCardINVInfo,$c(2),1)
	
	b	; CardINVPRT
	
	;判断的标准是否有记录包含在里面

	;s myCPPInfo=myAPNum_"^"_myAPSum_"^"_myAPRefNum_"^"_myAPRefSum_"^"_myAPParkNum_"^"_myAPParkSum_RefPRTInfo_ParkPRTInfo
	;增加DHC_INVPRT打印发票的卡支付汇总金额  这个代表医院收入
	
	;b	;实际上缴额
	;主要信息包括：上缴金额信息+总的发票信息
	
	
	;把数据输出到界面
	;输出会计科目数据	
	s myCount = myRepObj.RepInfos.Count()
	s myTCashSum=0
	s myTChequeSum=0
	s myTBankCardSum=0
	s myTYBCardSum=0
	s myTDWZHSum=0
	s myTHTZHSum=0
	s myTZGBLJZSum=0
	s myTJZQFSum=0
	
	d ..GetACCatList()
	
	
	f i=1:1:myCount {
		;输出收费员数据
		;d myRepObj.SetSelectPayMode(SubAvailHosp)
		s myPMRowTSum=0
		s myOperInfo=myRepObj.RepInfos.GetAt(i)
		s myHospPMObj=myOperInfo.SetSelectPayMode(SubAvailHosp)
		s myCashSum=myOperInfo.SelTotalPayMode.CashSum
		s myChequeSum=myOperInfo.SelTotalPayMode.ChequeSum
		
		s myBankCardSum=myOperInfo.SelTotalPayMode.BankCardSum
		s myYBCardSum=myOperInfo.SelTotalPayMode.YBCardSum
		
		s myDWZHSum=0
		s myHTZHSum=0
		s myZGBLJZSum=0
		s myJZQFSum=0
		
		s myTCashSum=+myTCashSum+myCashSum
		s myTChequeSum=+myTChequeSum+myChequeSum
		s myTBankCardSum=+myTBankCardSum+myBankCardSum
		s myTYBCardSum=+myTYBCardSum+myYBCardSum
		s myTDWZHSum=+myTDWZHSum+ myDWZHSum
		s myTHTZHSum= +myTHTZHSum + myHTZHSum
		s myTZGBLJZSum= +myTZGBLJZSum + myZGBLJZSum
		s myTJZQFSum= +myTJZQFSum + myJZQFSum
		
		s myUserDR=myOperInfo.UserDR
		s myUserName=$p(^SSU("SSUSR",myUserDR),"^",2)
		s myPMRowTSum = +myPMRowTSum+myCashSum
		s myPMRowTSum = +myPMRowTSum+myChequeSum
		s myPMRowTSum = +myPMRowTSum+myBankCardSum
		s myPMRowTSum = +myPMRowTSum+myYBCardSum
		
		s myCashSum=$fn(myCashSum,"",2)
		s myChequeSum=$fn(myChequeSum,"",2)
		s myBankCardSum=$fn(myBankCardSum,"",2)
		s myYBCardSum=$fn(myYBCardSum,"",2)
		s myDWZHSum=$fn(myDWZHSum,"",2)
		s myHTZHSum=$fn(myHTZHSum,"",2)
		s myZGBLJZSum=$fn(myZGBLJZSum,"",2)
		s myJZQFSum=$fn(myJZQFSum,"",2)
		s myPMRowTSum=$fn(myPMRowTSum,"",2)
		s:+myCashSum=0 myCashSum=""
		s:+myChequeSum=0 myChequeSum=""
		s:+myBankCardSum=0 myBankCardSum=""
		s:+myYBCardSum=0 myYBCardSum=""
		s:+myDWZHSum=0 myDWZHSum=""
		s:+myHTZHSum=0 myHTZHSum=""
		s:+myZGBLJZSum=0 myZGBLJZSum=""
		s:+myJZQFSum=0 myJZQFSum=""
		s:+myPMRowTSum=0 myPMRowTSum=0
		
		s mystr=myUserName_"^"_myCashSum_"^"_myChequeSum_"^"_myBankCardSum_"^"_myYBCardSum
		s mystr=mystr_"^"_myDWZHSum_"^"_myHTZHSum_"^"_myZGBLJZSum_"^"_myJZQFSum_"^"_myPMRowTSum_"^^^^^^^^^^^^^^^"
		s retval=PMJsName_"('"_$ZCVT(mystr,"O","JS")_"'"
		s retval=retval_");"
		
		&javascript<#(retval)#>
		
		s myItmACCat=""
		
		;当前收费员的 项目分类
		;myOperInfo
		
		s myAcCats=myOperInfo.ACCat
		s myItmCount=myAcCats.Count()
		for myItmIdx=1:1:myItmCount {
			s myACCat = myAcCats.GetAt(myItmIdx)
			i (SubAvailHosp=myACCat.SubAvailHospitlDR) {
				;
				
				s myItemID=myACCat.CatDR
				s myItmSum=myACCat.Acount
				s myIdx=$g(^TMPTar($j,"ItmID",myItemID))
				i myIdx'=""{
					s ^TMPTar($j,"FAIR",myIdx,"TSum") = +$g(^TMPTar($j,"FAIR", myIdx,"TSum"))+myItmSum
				}
			}
		}
		
	}

	s myTPMRowTSum=+myTCashSum + myTChequeSum + myTBankCardSum + myTYBCardSum
	s myTPMRowTSum=+myTPMRowTSum+myTDWZHSum+ myTHTZHSum+myTZGBLJZSum + myTJZQFSum
	
	s myTCashSum=$fn(myTCashSum,"",2)
	s myTChequeSum=$fn(myTChequeSum,"",2)
	s myTBankCardSum=$fn(myTBankCardSum,"",2)
	s myTYBCardSum=$fn(myTYBCardSum,"",2)
	s myTDWZHSum=$fn(myTDWZHSum,"",2)
	s myTHTZHSum=$fn(myTHTZHSum,"",2)
	s myTZGBLJZSum=$fn(myTZGBLJZSum,"",2)
	s myTJZQFSum=$fn(myTJZQFSum,"",2)
	s myTPMRowTSum=$fn(myTPMRowTSum,"",2)
	s:+myTCashSum=0 myTCashSum=""
	s:+myTChequeSum=0 myTChequeSum=""
	s:+myTBankCardSum=0 myTBankCardSum=""
	s:+myTYBCardSum=0 myTYBCardSum=""
	s:+myTDWZHSum=0 myTDWZHSum=""
	s:+myTHTZHSum=0 myTHTZHSum=""
	s:+myTZGBLJZSum=0 myTZGBLJZSum=""
	s:+myTJZQFSum=0 myTJZQFSum=""
	s:+myTPMRowTSum=0 myTPMRowTSum=""
	
	s mystr="合计  ^"_myTCashSum_"^"_myTChequeSum_"^"_myTBankCardSum_"^"_myTYBCardSum
	s mystr=mystr_"^"_myTDWZHSum_"^"_myTHTZHSum_"^"_myTZGBLJZSum_"^"_myTJZQFSum_"^"_myTPMRowTSum_"^^^^^^^^^^^^^^^"
	s retval=PMJsName_"('"_$ZCVT(mystr,"O","JS")_"'"
	s retval=retval_");"
	
	&javascript<#(retval)#>
	
	s myTCashSum=$fn(myTCashSum,"",2)
	s myTChequeSum=$fn(myTChequeSum,"",2)
	s myTBankCardSum=$fn(myTBankCardSum,"",2)
	s myTYBCardSum=$fn(myTYBCardSum,"",2)
	s myTDWZHSum=$fn(myTDWZHSum,"",2)
	s myTHTZHSum=$fn(myTHTZHSum,"",2)
	s myTZGBLJZSum=$fn(myTZGBLJZSum,"",2)
	s myTJZQFSum=$fn(myTJZQFSum,"",2)
	s myTPMRowTSum=$fn(myTPMRowTSum,"",2)
	s:+myTCashSum=0 myTCashSum=""
	s:+myTChequeSum=0 myTChequeSum=""
	s:+myTBankCardSum=0 myTBankCardSum=""
	s:+myTYBCardSum=0 myTYBCardSum=""
	s:+myTDWZHSum=0 myTDWZHSum=""
	s:+myTHTZHSum=0 myTHTZHSum=""
	s:+myTZGBLJZSum=0 myTZGBLJZSum=""
	s:+myTJZQFSum=0 myTJZQFSum=""
	s:+myTPMRowTSum=0 myTPMRowTSum=""
	
	s mystr=myTCashSum_"^"_myTChequeSum_"^"_myTBankCardSum_"^"_myTYBCardSum
	s mystr=mystr_"^"_myTDWZHSum_"^"_myTHTZHSum_"^"_myTZGBLJZSum_"^"_myTJZQFSum_"^"_myTPMRowTSum_"^^^^^^^^^^^^^^^"
	s retval=HZJsName_"('"_$ZCVT(mystr,"O","JS")_"'"
	s retval=retval_");"
	
	&javascript<#(retval)#>
	
	;^TMPItmCat($j,myIdx, myItemID,"TSum")
	s mylenStr=+$g(^TMPTar($j))
	s myItemStr=mylenStr
	s myIdx=0
	b	;Idx
	s myTTCatSum=0
	f  s myIdx=$o(^TMPTar($j, "FAIR", myIdx))  q:(myIdx="")  d
	.s myTTCatSum=+myTTCatSum + $g(^TMPTar($j, "FAIR", myIdx,"TSum"))
	.s myTMPCatSum=+$fn(^TMPTar($j, "FAIR", myIdx,"TSum"),"",2)
	.s:+myTMPCatSum=0 myTMPCatSum=""
	.i myItemStr="" d
	..s myItemStr=myTMPCatSum
	.e  d
	..s myItemStr=myItemStr_"^"_myTMPCatSum
	
	i myItemStr="" d
	.s myItemStr="0^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
	e  d
	.s myItemStr=myItemStr_"^"_$fn(myTTCatSum,"",2)
	
	s retval=CatJsName_"('"_$ZCVT(myItemStr,"O","JS")_"'"
	s retval=retval_");"
	
	&javascript<#(retval)#>
	
	d myRepObj.%Close()
	
	d ##class(web.udhcOPHandin7FQuery).KillTmp()
	d ..KillTMP()
	
	;最后判断一下是否办理结算
	
	q myrtn
}

ClassMethod FootItemQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FootItemQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FootItemQueryExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "", SubAvailHosp As %String = "") As %Status
{
	
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance7","FootItemQuery",+$h,+$h)
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance7","FootItemQuery","","")
	New repid, index
	Set repid=$I(^CacheTemp)
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance4","ReadUnFootINV")
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;生成Global,  然后输出，  
	;最后加上合计
	;s ^TMPFDFDFDFD=StDate
	d ResetVariablesFI
	
	i (StDate="")!(EndDate=""){
		d OutputFI
		Quit $$$OK
	}
	
	b
	d ..KillTMP()
	
	;生成Global
	;挂号
	;收费
	;s myrtn=..GetFinFootData(StDate,EndDate )
	
	i StDate["/" d
	.s StDate=$zdh(StDate,4)
	i EndDate["/" d
	.s EndDate=$zdh(EndDate,4)
	
	;^TMPOPFOper($j,myHisRowID, myUserDR
	;^TMPItmCat($j,INVRepRowID,i)
	s myItemLen=+$g(^TMPTar($j))
	s myHisRowID=""
	s myNo=0
	d ..GetACCatList()
	
	s myItemLen=+$g(^TMPTar($j))
	s myHisRowID=""
	s myDate=StDate-1
	
	f  s myDate=$o(^DHCOPInsFootI(0,"Date",myDate)) q:((myDate="")!(myDate>EndDate))  d
	.s myHisRowID=0
	.f  s myHisRowID=$o(^DHCOPInsFootI(0,"Date",myDate,myHisRowID)) q:(myHisRowID="")  d
	..s mySub=0
	..f  s mySub=$o(^DHCOPInsFoot(myHisRowID,"C",mySub)) q:(mySub="")  d
	...
	...s ItmOPCat=$p(^DHCOPInsFoot(myHisRowID,"C",mySub),"^",1)
	...s mySubAvailHospDR=$p(^DHCOPInsFoot(myHisRowID,"C",mySub),"^",4)
	...q:(mySubAvailHospDR'=SubAvailHosp)&&(SubAvailHosp'="")
	...s OPCatDesc=$p(^DHCTarC("TAC",ItmOPCat),"^",2)
	...s INVRepRowID=myHisRowID
	...s TotalAmount=$p(^DHCOPInsFoot(myHisRowID,"C",mySub),"^",2)	;
	...f i=1:1:$g(^TMPTar($j)) d
	....i ItmOPCat=$g(^TMPTar($j,i)) d
	.....s ^TMPItmCat($j,INVRepRowID,i)=+$g(^TMPItmCat($j,INVRepRowID,i))+TotalAmount
	....q:ItmOPCat=$g(^TMPTar($j,i))
	
	s mySum=0
	f  s myHisRowID=$o(^TMPItmCat($j,myHisRowID)) q:(myHisRowID="")  d
	.s myNo=myNo+1
	.s myItemInfo=""
	.b	;;
	.;序号，操作员，RowID，
	.f i=1:1:myItemLen  d
	..;s myItemInfo=myItemInfo_"^"_$fn(+$g(^TMPItmCat($j,myHisRowID,i)),"",2)
	.;b		;myItemInfo
	.;合计，记账收入(讨论一下这个怎么，为空)，收款收入
	.;s myRepInfo=myItemLen_"^"_myNo_"^"_myUserName_"^"_myHisRowID_myItemInfo_"^"_mySum_"^"_"^"_mySum
	.s TNO=myNo
	.;s UserName=myUserName
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
	.s TSum=$fn(mySum,"",2) ;mySum_"^"_"^"_mySum
	.;s InsSum=$fn(myJZSum,"",2)
	.;s JZSum=JZSum+myJZSum
	.;s PatShareSum=$fn(PatShareSum,"",2)
	.;s myPatShareSum=$g(myPatShareSum)+PatShareSum
	.;s myListSum=+$g(myListSum)+mySum
	.;d OutputFI
	
	;合计
	;i myNo'=0 d
	s TNO="",UserName="合计",RepRowID=""
	s TCAT1=$fn($g(TCATSum1),"",2)
	s TCAT2=$fn($g(TCATSum2),"",2)
	s TCAT3=$fn($g(TCATSum3),"",2)
	s TCAT4=$fn($g(TCATSum4),"",2)
	s TCAT5=$fn($g(TCATSum5),"",2)
	s TCAT6=$fn($g(TCATSum6),"",2)
	s TCAT7=$fn($g(TCATSum7),"",2)
	s TCAT8=$fn($g(TCATSum8),"",2)
	s TCAT9=$fn($g(TCATSum9),"",2)
	s TCAT10=$fn($g(TCATSum10),"",2)
	s TCAT11=$fn($g(TCATSum11),"",2)
	s TCAT12=$fn($g(TCATSum12),"",2)
	s TCAT13=$fn($g(TCATSum13),"",2)
	s TCAT14=$fn($g(TCATSum14),"",2)
	s TCAT15=$fn($g(TCATSum15),"",2)
	s TCAT16=$fn($g(TCATSum16),"",2)
	s TCAT17=$fn($g(TCATSum17),"",2)
	s TCAT18=$fn($g(TCATSum18),"",2)
	s TCAT19=$fn($g(TCATSum19),"",2)
	s TCAT20=$fn($g(TCATSum20),"",2)
	;s TSum=$fn(myListSum,"",2) ;mySum_"^"_"^"_mySum
	;s InsSum=$fn(JZSum,"",2)
	;s PatShareSum=$fn(myPatShareSum,"",2)
	;s myFeeYHSum=$fn(TFeeYHSum,"",2)
	;s myYBPaySum=$fn(TYBPaySum,"",2)
	d OutputFI
	b		;kill  
	
	d ..KillTMP()
	
	
	Quit $$$OK
ResetVariablesFI
	s (TNO,UserName,RepRowID,TCAT1,TCAT2,TCAT3,TCAT4,TCAT5,TCAT6,TCAT7, TCAT8, TCAT9, TCAT10,TCAT11, TCAT12, TCAT13, TCAT14, TCAT15, TCAT16, TCAT17, TCAT18, TCAT19, TCAT20)=""
	s (TSum, InsSum, PatShareSum)=""
	s (TFeeYHSum, TYBPaySum)=""
	s myUserDR=""
	quit
OutputFI
	s Data=$lb(TNO,UserName,RepRowID,TCAT1,TCAT2,TCAT3,TCAT4,TCAT5,TCAT6,TCAT7, TCAT8, TCAT9, TCAT10,TCAT11, TCAT12, TCAT13, TCAT14, TCAT15, TCAT16, TCAT17, TCAT18, TCAT19, TCAT20, TSum)
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

/// 得到会计大类
ClassMethod GetACCat() As %String
{
	;w ##class(web.udhcOPFinBalance7).GetACCat()
	s n=1
	s ret=""
	s itmrowid=0 f  s itmrowid=$o(^DHCTarC("TAC",itmrowid)) q:itmrowid=""  d
	.s itm=$p(^DHCTarC("TAC",itmrowid),"^",2)
	.i ret=""  s ret=itm
	.e  s ret=ret_"^"_itm
	.s n=n+1
	q ret
}

ClassMethod GetACCatList()
{
	s n=1
	s itmrowid=0 f  s itmrowid=$o(^DHCTarC("TAC",itmrowid)) q:itmrowid=""  d
	.s itm=$p(^DHCTarC("TAC",itmrowid),"^",2)
	.s ^TMPTar($j)=n
	.s ^TMPTar($j,"ItmID",itmrowid)=n
	.s ^TMPTar($j, "FAIR", n,"TSum")=0
	.s ^TMPTar($j,n)=itmrowid
	.s ^TMPItmCat($j,n, itmrowid)=""
	.s ^TMPItmCat($j,n, itmrowid,"TSum")=0
	.
	.s n=n+1
	
	q n
}

Query FootItemQuery(StDate As %String = "", EndDate As %String = "", SubAvailHosp As %String = "") As %Query(ROWSPEC = "TNO:%String,UserName:%String,RepRowID:%String,TCAT1:%String,TCAT2:%String,TCAT3:%String,TCAT4:%String,TCAT5:%String,TCAT6:%String,TCAT7:%String, TCAT8:%String, TCAT9:%String, TCAT10:%String,TCAT11:%String, TCAT12:%String, TCAT13:%String, TCAT14:%String, TCAT15:%String, TCAT16:%String, TCAT17:%String, TCAT18:%String, TCAT19:%String, TCAT20:%String, TSum:%String, InsSum:%String, PatShareSum:%String, YBPaySum:%String, FeeYHSum:%String, UserRowID:%String")
{
}

ClassMethod GetFinFootData(BDate As %String = "", EDate As %String = "") As %String
{
	;财务报表结算，只有一个开始和结算日期时间
	;w ##class(web.udhcOPFinBalance4).GetFinFootData("28/11/2005","30/11/2005")
	;n (BDate, BTime, EDate, ETime)
	
	d ..KillTMP()
	;k ^TMPOPFOper($j)

	s n=1
	s itmrowid=0 f  s itmrowid=$o(^DHCTarC("TAC",itmrowid)) q:itmrowid=""  d
	.s itm=$p(^DHCTarC("TAC",itmrowid),"^",2)
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
	..;d ..GetFinFootRefundData(myHisRowID)
	..s ^TMPOPFOper($j,myHisRowID,myUserDR)=myUserName
	..s myCashSum=$p(^DHCOPInsFoot(myHisRowID),"^",18)
	..;s myCashSum=+myCashSum+$p(^DHCOPInsFoot(myHisRowID),"^",22)
	..;s myCashSum=+myCashSum+$p(^DHCOPInsFoot(myHisRowID),"^",24)
	..s ^TMPOPFOper($j,myHisRowID,myUserDR,"Cash")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Cash"))+myCashSum
	..s myCheckSum=$p(^DHCOPInsFoot(myHisRowID),"^",20)
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"Check")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Check"))+myCheckSum
	..s myCredPaySum=+$p(^DHCOPInsFoot(myHisRowID),"^",45)
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"CredPay")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"CredPay"))+myCredPaySum				;信用卡支付
	..s myOtherPaySum=+$p(^DHCOPInsFoot(myHisRowID),"^",28)
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"OtherPay")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"OtherPay"))+myOtherPaySum			;其他支付
	..s myYBPaySum=+$p(^DHCOPInsFoot(myHisRowID),"^",30)		;HIS_YBSum
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"YBSum")=$g(^TMPOPFOper($j,myHisRowID, myUserDR,"YBSum"))+myYBPaySum
	..s myJZSum=+$p(^DHCOPInsFoot(myHisRowID),"^",52)		;HIS_PRDGetSum
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"JIZHANG")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"JIZHANG"))+myJZSum
	..;
	..;+myCashSum+myCheckSum+myCredPaySum+myOtherPaySum
	..;需要注意，每次增加支付类型都需要在此重新取值
	..s myCashSum=+$g(^TMPOPFOper($j,myHisRowID,myUserDR,"Cash"))
	..s myCheckSum=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Check"))
	..s myCredPaySum=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"CredPay"))
	..s myOtherPaySum=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"OtherPay"))
	..s myYBPaySum=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"YBSum"))
	..s myJZSum=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"JIZHANG"))
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"Sum")=$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Sum"))+myCashSum+myCheckSum+myCredPaySum+myOtherPaySum+myYBPaySum+myJZSum
	..s myTotalSum=+$p(^DHCOPInsFoot(myHisRowID),"^",1)		;HIS_Amount
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"TotalSum")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"TotalSum"))+myTotalSum
	..s myPatPaySum=+$p(^DHCOPInsFoot(myHisRowID),"^",16)		;HIS_Amount
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"PatPaySum")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"PatPaySum"))+myPatPaySum
	..;d ..STATtoCAT(myHisRowID)
	..
	
	q 0
}

ClassMethod KillTMP() As %String
{
	k ^TMPOPFOper($j)
	k ^TMPTar($j)
	k ^TMPItmCat($j)
}

ClassMethod ReadFootPayModeHZClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadFootPayModeHZExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReadFootPayModeHZExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "", SubAvailHosp As %String = "") As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance7","ReadFootPayModeHZ", +$h, +$h)
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;生成Global,  然后输出，  
	;最后加上合计
	
	d ResetVariablesHZ
	d OutputHZ
		
	Quit $$$OK
ResetVariablesHZ
	s (myTCash, myTCheck, myTBankCard, myTYBPay, myTDBZH, myTHTJZ, myTBLJZ, myTELackFair, myTTotal)=""
	s (TSum, InsSum, PatShareSum)=""
	s (TFeeYHSum, TYBPaySum)=""
	s myUserDR=""
	quit
OutputHZ
	s Data=$lb(myTCash, myTCheck, myTBankCard, myTYBPay, myTDBZH, myTHTJZ, myTBLJZ, myTELackFair, myTTotal)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
}

ClassMethod ReadFootPayModeHZFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadFootPayModeHZExecute ]
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

ClassMethod ReadUserFootPayModeDataAClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadUserFootPayModeDataAExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReadUserFootPayModeDataAExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "", SubAvailHosp As %String = "") As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance7","ReadUserFootPayModeData",+$h-1, +$h, 2)
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;生成Global,  然后输出，  
	;最后加上合计
	
	d ResetVariablesPayMode
	
	i (StDate="")!(EndDate=""){
		d OutputPayMode
		Quit $$$OK
	}
	
	s myDate=StDate-1
	s myIdx=0
	s myCount=0
	k myPayModeObj
	k myRepUserName
	f  s myDate=$o(^DHCOPInsFootI(0,"Date",myDate)) q:((myDate="")!(myDate>EndDate))  d
	.s myHisRowID=0
	.f  s myHisRowID=$o(^DHCOPInsFootI(0,"Date",myDate,myHisRowID)) q:(myHisRowID="")  d
	..s myIdx=+myIdx+1
	..s myCount=+myCount+1
	..s myPayModeObj(myIdx)=##class(web.DHCEntity.OPC.ReportsPayMode).%New()
	..s myUserDR=$p(^DHCOPInsFoot(myHisRowID),"^", 8)
	..s myUserName= $p(^SSU("SSUSR", myUserDR),"^",2)
	..s myRepUserName(myIdx)=myUserName
	..s mySub=0
	..;^DHCOPInsFoot({DHC_INVPRTReports.HIS_Rowid},"P",
	..f  s mySub=$o(^DHCOPInsFoot(myHisRowID,"P", mySub)) q:(mySub="")  d
	...s mySubHospDR=$p(^DHCOPInsFoot(myHisRowID,"P", mySub),"^",22)
	...q:(mySubHospDR'="")&&(mySubHospDR'=SubAvailHosp)
	...;b	;
	...s myPMDR=$p(^DHCOPInsFoot(myHisRowID,"P", mySub),"^",2)
	...s myINVAcount=$p(^DHCOPInsFoot(myHisRowID,"P", mySub),"^",1)
	...s myINVRefSum=$p(^DHCOPInsFoot(myHisRowID,"P", mySub),"^",4)
	...s myPRDGetSum=$p(^DHCOPInsFoot(myHisRowID,"P", mySub),"^",7)
	...s myPRDParkSum=$p(^DHCOPInsFoot(myHisRowID,"P", mySub),"^",9)
	...s myLParkINVSum=$p(^DHCOPInsFoot(myHisRowID,"P", mySub),"^",16)
	...s myLStrikINVSum=$p(^DHCOPInsFoot(myHisRowID,"P", mySub),"^",18)
	...s myLogINVSum=$p(^DHCOPInsFoot(myHisRowID,"P", mySub),"^",20)
	...s myTSum=myINVAcount+myINVRefSum+myPRDGetSum+myPRDParkSum+myLParkINVSum+myLStrikINVSum+myLogINVSum
	...q:(myPMDR="")
	...s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	...b	;
	...d myPayModeObj(myIdx).PutPayMode(myPMCode,myTSum,0)
	
	;Out Data
	f i=1:1:myCount  d
	.s myUserName=myRepUserName(i)
	.s myTCash=$fn(myPayModeObj(i).CashSum,"",2)
	.s myTCheck=$fn(myPayModeObj(i).ChequeSum,"",2)
	.s myTBankCard=$fn(myPayModeObj(i).BankCardSum,"",2)
	.s myTYBPay=$fn(+myPayModeObj(i).YBCardSum,"",2)
	.s myTDBZH="0.00"
	.s myTHTJZ="0.00"
	.s myTBLJZ="0.00"
	.s myTELackFair="0.00"
	.s myTTotal=myPayModeObj(i).CashSum+myPayModeObj(i).ChequeSum+myPayModeObj(i).BankCardSum+myPayModeObj(i).YBCardSum
	.s myTTotal=$fn(myTTotal,"",2)
	.d OutputPayMode
	
	k myPayModeObj
	k myRepUserName
	
	Quit $$$OK
ResetVariablesPayMode
	s (myUserName, myTCash, myTCheck, myTBankCard, myTYBPay, myTDBZH, myTHTJZ, myTBLJZ, myTELackFair, myTTotal)=""
	s (TSum, InsSum, PatShareSum)=""
	s (TFeeYHSum, TYBPaySum)=""
	s myUserDR=""
	quit
OutputPayMode
	s Data=$lb(myUserName, myTCash, myTCheck, myTBankCard, myTYBPay, myTDBZH, myTHTJZ, myTBLJZ, myTELackFair, myTTotal)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
}

/// 查询汇总的支付模式
Query ReadFootPayModeHZ(StDate As %String = "", EndDate As %String = "", SubAvailHosp As %String = "") As %Query(ROWSPEC = "TCash:%String,TCheck:%String,TBankCard:%String,TYBPay:%String,TDBZH:%String,THTJZ:%String,TBLJZ:%String,TELackFair:%String, TTotal:%String")
{
}

ClassMethod ReadUserFootPayModeDataAFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadUserFootPayModeDataAExecute ]
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

/// 读取操作员结算查询
Query ReadUserFootPayModeDataA(StDate As %String = "", EndDate As %String = "", SubAvailHosp As %String = "") As %Query(ROWSPEC = "TUserName:%String,TCash:%String,TCheck:%String,TBankCard:%String,TYBPay:%String,TDBZH:%String,THTJZ:%String,TBLJZ:%String,TELackFair:%String, TTotal:%String")
{
}

}
