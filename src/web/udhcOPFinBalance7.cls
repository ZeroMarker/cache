/// 华西的报表 Cls
Class web.udhcOPFinBalance7 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod UpdateRepForINSAll(INSFUDR As %String, StDate As %String, StTime As %String, EndDate As %String, EndTime As %String) As %String
{
	n (UserRowID, INSFUDR, StDate, StTime, EndDate, EndTime)
	;w ##class(web.udhcOPFinBalance7).UpdateRepForINSAll(6,60952,"",60953,"")
	
	;s $ZT="ERROR^DHCSSERR"
	
	s ^TMP23=INSFUDR_"^"_StDate_"^"_StTime_"^"_EndDate_"^"_EndTime
	
	ts
	
	s myCurDate=+$h
	s myCurTime=$p($h,",",2)
	
	i StDate["/" d  s StDate=$zdh(StDate,4)
	i StTime[":" d  s StTime=$zth(StTime)
	i EndDate["/" d  s EndDate=$zdh(EndDate,4)
	i EndTime[":" d  s EndTime=$zth(EndTime)
	
	;^DHCOPInsFootI(0, "IncomeDate", {HIS_IncomeDate}, {HIS_Rowid})
	
	s myrtn=0
	s myDate=StDate-1
	;f  s myDate=$o(^DHCOPInsFootI(0,"Date",myDate)) q:((myDate="")||(myrtn'=0))  d
	f myDate=StDate:1:EndDate  q:((myrtn'=0))  d
	.s myHisRID=0
	.q:(EndDate<myDate)
	.f  s myHisRID=$o(^DHCOPInsFootI(0,"IncomeDate",myDate, myHisRID))  q:(myHisRID="")  d
	..s myUDR=$p($g(^DHCOPInsFoot(myHisRID)),"^",8)
	..;q:(UserRowID'=myUDR)
	..s myRepStatus=$p($g(^DHCOPInsFoot(myHisRID)),"^",61)
	..i myRepStatus="C" d
	...s myrtn=119
	..q:(+myrtn)
	..;s myTime=$p($g(^DHCOPInsFoot(myHisRID)),"^",7)
	..;q:((myDate=StDate)&&(myTime<StTime))
	..;q:((myDate=EndDate)&&(myTime>EndTime))
	..s myFootUserDR=$p($g(^DHCOPInsFoot(myHisRID)),"^",15)
	..q:(myFootUserDR'="")
	..k PLIST
	..b
	..s myrtn=##class(web.UDHCINVPRTReports).SELECT(myHisRID)
	..q:myrtn
	..s PLIST(13)="Y"
	..s PLIST(14)=myCurDate
	..s PLIST(15)=myCurTime
	..s PLIST(16)=INSFUDR
	..s myrtn=##class(web.UDHCINVPRTReports).UPDATE(myHisRID)
	..q:myrtn
	
	b	;;Tro
	i +myrtn=0 d
		.tc
	e  d
		.Trollback
	
	q myrtn
}

/// / 获取INVPRTReports 的最后结算日期时间
ClassMethod GetDate() As %String
{
	;w ##class(web.udhcOPFinBalance7).GetDate()
	s myBeginDate=""
	s myBeginTime=""
	s myEndDate=+$h
	s myEndTime=$p($h,",",2)
	
	s myMinDate=+$h
	s myMaxDate=""
	s myIncomeDate=""
	s myHISRowID=""
	;^DHCOPInsFootI(0, "INSFDate", {HIS_INSFootDate}, {HIS_Rowid})
	;^DHCOPInsFootI(0, "IncomeDate", {HIS_IncomeDate}, {HIS_Rowid})
	s myMaxDate=$o(^DHCOPInsFootI(0, "INSFDate",""),-1)
	
	;没有办理过结算
	i myMaxDate="" d
	.;s myHISRowID=
	.;s myMaxDate=+$h
	.s myPRTDate=$o(^DHCINVPRT(0,"Date",0))
	.s myCardDate=$o(^DHCCARDINVPRTi(0,"Date",0))
	.s myAccPreDate=$o(^DHCACDi("AccM",0,"APDDate",0))
	.i (+myPRTDate<+myMinDate)&&(myPRTDate'="") d
	..s myMinDate=myPRTDate
	.i (+myCardDate<+myMinDate)&&(myCardDate'="") d
	..s myMinDate=myCardDate
	.i (+myAccPreDate<+myMinDate)&&(myAccPreDate'="") d
	..s myMinDate=myAccPreDate
	.;s myBeginDate=$o(^DHCOPInsFootI(0, "IncomeDate",""))
	.s myBeginDate=myMinDate
	.s myBeginTime=0
	.s myEndDate=myBeginDate		;;+1
	.s myEndTime=0
	e  d
	.;办理过结算的
	.s myHISRowID=$o(^DHCOPInsFootI(0, "INSFDate", myMaxDate, ""),-1)
	.s myIncomeDate=$p(^DHCOPInsFoot(myHISRowID),"^",64)
	.;有收入的日期
	.s myIncomeDate=$o(^DHCOPInsFootI(0, "IncomeDate",myIncomeDate))
	.i myIncomeDate="" d
	..s myIncomeDate=+$h
	.s myBeginDate=+myIncomeDate
	.s myBeginTime=0
	.s myEndTime=0
	
	;验证业务表中是否有收入
	i (+myBeginDate<+$h) d
	.s myCount=0
	.s mypdate=""
	.f mypdate=myBeginDate:1:myEndDate  q:(+myCount'=0)  d
	..q:(+mypdate>=+$h)			;要求当前日期
	..s myCount=..CheckINVFlag(mypdate, myEndDate)
	..
	..i +myCount'=0  d
	...;如果当天存在要要结算数据, 把结束时间定为明天的0分
	...s myEndDate=mypdate
	...s myEndTime="86399"
	
	q myBeginDate_"^"_myBeginTime_"^"_myEndDate_"^"_myEndTime
}

ClassMethod CheckINVFlag(stdate As %String, EndDate As %String) As %String
{
	;n (hUser,stdate,EndDate,EndTime)
	;目的是验证当天的数据是否有没有办理结算的
	
	s myCount=0
	
	;^DHCINVPRT(0,""Date"",{PRT_Date},{PRT_Rowid})
	
	s pddate=stdate
	i $d(^DHCINVPRT(0,"Date",pddate))'=0 d
	.;验证发票表
	.s Handin=""
	.s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date", pddate,PRTrowid),-1) q:((PRTrowid="")&&(+myCount))  d
	..s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
	..s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	..;q:(pdate=EndDate)&(PRTTime>EndTime)
	..s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	..s myINVNo=$p(^DHCINVPRT(PRTrowid),"^",14)			;PRT_inv
	..s myPrtFlag=$p(^DHCINVPRT(PRTrowid),"^",3)		;PRT_INVPrintFlag
	..q:((myINVNo="")&(myPrtFlag="P"))
	..s myCount=+myCount+1
	
	;验证押金表，或者账户结算信息表
	i $d(^DHCACDi("AccM",0,"APDDate",pddate))'=0 d
	.s myAccRowID=""
	.f  s myAccRowID=$o(^DHCACDi("AccM",0,"APDDate", pddate, myAccRowID)) q:((myAccRowID="")&&(+myCount))  d
	..s myAccSub=0
	..f  s myAccSub=$o(^DHCACDi("AccM",0,"APDDate",pddate, myAccRowID,"AccPD", myAccSub)) q:(myAccSub="")  d
	...q:($d(^DHCACD("AccM",myAccRowID,"AccPD",myAccSub))=10)
	...s myPLIST=^DHCACD("AccM",myAccRowID,"AccPD",myAccSub)
	...s myRepDR=$p(myPLIST,"^",10)
	...b		;押金表
	...s myCount=+myCount+1
	..
	
	;验证集中打印发票表
	;下面是：DHC_AccPayINV表的发票号码
	
	i $d(^DHCINVPRTAPi(0,"Date",pddate))'=0 d
	.s myAPRowID=""
	.f  s myAPRowID=$o(^DHCINVPRTAPi(0, "Date", pddate, myAPRowID))  q:((myAPRowID="")&&(+myCount))  d
	..s myAPUser=$p(^DHCINVPRTAP(myAPRowID),"^", 5)
	..s myAPTime=$p(^DHCINVPRTAP(myAPRowID),"^", 4)
	..;q:((APdate=stdate)&&(myAPTime<sttime))
	..;q:((APdate=EndDate)&&(myAPTime>EndTime))
	..s myCheckDate=$p(^DHCINVPRTAP(myAPRowID),"^", 7)
	..;q:(myCheckDate'="")	;已经结算的退出
	..b		;集中打印
	..s myCount=+myCount+1
	
	i $d(^DHCCARDINVPRTi(0,"Date",pddate))'=0 d
	.s myCIPRowID=0
	.f  s myCIPRowID=$o(^DHCCARDINVPRTi(0,"Date",pddate,myCIPRowID)) q:((myCIPRowID="")&&(+myCount))  d
	..q:('$d(^DHCCARDINVPRT(myCIPRowID)))
	..s PRTUser=$p(^DHCCARDINVPRT(myCIPRowID),"^",6)			;CIP_PUser_DR
	..s PRTTime=$p(^DHCCARDINVPRT(myCIPRowID),"^",5)			;CIP_Time
	..s myReportsDR=$p(^DHCCARDINVPRT(myCIPRowID),"^",9)			;CIP_INVReports_DR
	..;q:myReportsDR'=""
	..s myCount=+myCount+1
	
	q myCount
}

ClassMethod GetOperListDataForAll(HZJsName As %String, CatJsName As %String, PMJsName As %String, StDate As %String = "", StTime As %String = "", EndDate As %String = "", EndTime As %String = "", SubAvailHosp As %String = "") As %String
{
	;w ##class(web.udhcOPFinBalance7).GetOperListDataForAll("","","","","",+$h,"","")
	;, EndDate As %String, EndTime As %String
	;调试代码
	;^TMPHandin=5%%%
	n (HZJsName, CatJsName, PMJsName,StDate , StTime , EndDate, EndTime, SubAvailHosp)
	s ^TMPFDFDFDF=$lb(HZJsName, CatJsName, PMJsName,StDate , StTime , EndDate, EndTime, SubAvailHosp)
	
	s myINSFFlag=0
	i StTime="" s StTime="0"
	i EndTime="" s EndTime="86399"
	i StDate["/" s StDate=$zdh(StDate,4)
	i EndDate["/" s EndDate=$zdh(EndDate,4)
	
	s myDateInfo=..GetDate()
	b	;;
	s StDate=$p(myDateInfo,"^",1)
	s StTime=$p(myDateInfo,"^",2)
	s EndDate=$p(myDateInfo,"^",3)
	s EndTime=$p(myDateInfo,"^",4)
	
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
	
	s myFootFlag="U"
	s myRepObj=##class(web.DHCEntity.OPC.ReportsInfos).%New()
	s myIPRepInfo = ##class(web.DHCBL.OPC.ReportsInfos).GetINVPRTRepInfo(stdate,sttime,EndDate,EndTime, .myRepObj, myFootFlag)
	
	b	;myIPRepInfo
	
	s myIPCPPRepInfo=""
	s myAPIRepInfo=##class(web.udhcOPHandin7FQuery).GetAPIRepInfo(stdate,sttime,EndDate,EndTime, hUser, myIPCPPRepInfo, .myRepObj)
	
	s myPDInfo=##class(web.udhcOPHandin7FQuery).GetPRDRepINfo(stdate,sttime,EndDate,EndTime, hUser, .myRepObj)
	b	;PRD   OK
	s myPDRtn=$p(myPDInfo,$c(3),1)
	s myPDInfo=$p(myPDInfo,$c(3),2)
	
	;s myCardINVInfo=##class(web.udhcOPHandin7FQuery).GetCardINVRepInfo(stdate,sttime,EndDate,EndTime, hUser, .myRepObj)
	s myCardINVInfo=##class(web.DHCBL.OPC.ReportsInfos).GetCardINVRepInfo(stdate,sttime,EndDate,EndTime, hUser, .myRepObj, myFootFlag)
	s myCardINVRtn=$p(myCardINVInfo,$c(2),1)
	
	b	; CardINVPRT
	;
	s myUFUCount=myRepObj.RepInfos.Count()
	i (+myUFUCount>0)&&(+myINSFFlag=0) d
	.s myINSFFlag=122
	
	for myi=1:1:myUFUCount {
		s myRepObj.RepInfos.GetAt(myi).ReportStatus="U"
	}
	
	s myCardINVInfo=##class(web.DHCBL.OPC.ReportsInfos).GetInComeReportInfo(stdate,sttime,EndDate,EndTime, hUser, .myRepObj, "A")
	
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
		;s myHospPMObj=myOperInfo.SetSelectPayMode(SubAvailHosp)
		s myCashSum=myOperInfo.TotalPayModes.CashSum
		s myChequeSum=myOperInfo.TotalPayModes.ChequeSum
		
		s myBankCardSum=myOperInfo.TotalPayModes.BankCardSum
		s myYBCardSum=myOperInfo.TotalPayModes.YBCardSum
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
		
		i (myOperInfo.ReportStatus="C")&&(+myINSFFlag=0) d
		.s myINSFFlag=119
		
		s mystr=myUserName_"^"_$fn(myCashSum,"",2)_"^"_$fn(myChequeSum,"",2)_"^"_$fn(myBankCardSum,"",2)_"^"_$fn(myYBCardSum,"",2)
		s mystr=mystr_"^"_$fn(myDWZHSum,"",2)_"^"_$fn(myHTZHSum,"",2)_"^"_$fn(myZGBLJZSum,"",2)_"^"_$fn(myJZQFSum,"",2)_"^"_$fn(myPMRowTSum,"",2)_"^^^^^^^^^^^^^^^"
		s myReportStatus=myOperInfo.ReportStatus
		s retval=PMJsName_"('"_$ZCVT(mystr,"O","JS")_"', "_"'"_$ZCVT(myReportStatus,"O","JS")_"'"
		s retval=retval_");"
		
		&javascript<#(retval)#>
		
		s myItmACCat=""
		
		;当前收费员的 项目分类
		;myOperInfo
		
		s myAcCats=myOperInfo.ACCat
		s myItmCount=myAcCats.Count()
		for myItmIdx=1:1:myItmCount {
			s myACCat = myAcCats.GetAt(myItmIdx)
			i ((SubAvailHosp=myACCat.SubAvailHospitlDR)||(SubAvailHosp="")) {
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
	s mystr="合计  ^"_$fn(myTCashSum,"",2)_"^"_$fn(myTChequeSum,"",2)_"^"_$fn(myTBankCardSum,"",2)_"^"_$fn(myTYBCardSum,"",2)
	s mystr=mystr_"^"_$fn(myTDWZHSum,"",2)_"^"_$fn(myTHTZHSum,"",2)_"^"_$fn(myTZGBLJZSum,"",2)_"^"_$fn(myTJZQFSum,"",2)_"^"_$fn(myTPMRowTSum,"",2)_"^^^^^^^^^^^^^^^"
	s retval=PMJsName_"('"_$ZCVT(mystr,"O","JS")_"'"
	s retval=retval_");"
	
	&javascript<#(retval)#>
	
	s mystr=$fn(myTCashSum,"",2)_"^"_$fn(myTChequeSum,"",2)_"^"_$fn(myTBankCardSum,"",2)_"^"_$fn(myTYBCardSum,"",2)
	s mystr=mystr_"^"_$fn(myTDWZHSum,"",2)_"^"_$fn(myTHTZHSum,"",2)_"^"_$fn(myTZGBLJZSum,"",2)_"^"_$fn(myTJZQFSum,"",2)_"^"_$fn(myTPMRowTSum,"",2)_"^^^^^^^^^^^^^^^"
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
	.i myItemStr="" d
	..s myItemStr=$fn(^TMPTar($j, "FAIR", myIdx,"TSum"),"",2)
	.e  d
	..s myItemStr=myItemStr_"^"_$fn(^TMPTar($j, "FAIR", myIdx,"TSum"),"",2)
	
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
	
	s myinsobj=##class(web.DHCEntity.OPC.INSReport).%New()
	
	s myinsobj.StDate=$zd(StDate,3)
	s myinsobj.EndDate=$zd(EndDate,3)
	d myinsobj.XMLExportToStringExp(.myXmlData)
	d myinsobj.%Close()
	
	;当天数据不能办理财务结算
	i (+myINSFFlag=0)&&(+StDate=+$h) d
	.s myINSFFlag=123
	
	;最后判断一下是否办理结算
	s myrtn=+myINSFFlag
	
	q myrtn_"^"_myXmlData
}

ClassMethod GetOperListDataForAllRP(HZJsName As %String, CatJsName As %String, PMJsName As %String, StDate As %String = "", StTime As %String = "", EndDate As %String = "", EndTime As %String = "", SubAvailHosp As %String = "") As %String
{
	;w ##class(web.udhcOPFinBalance7).GetOperListDataForAllRP("","","","26/03/2008","","26/03/2008","","1")
	;, EndDate As %String, EndTime As %String
	;调试代码
	;^TMPHandin=5%%%
	n (HZJsName, CatJsName, PMJsName,StDate , StTime , EndDate, EndTime, SubAvailHosp)
	s ^TMPFDFDFDF=$lb(HZJsName, CatJsName, PMJsName,StDate , StTime , EndDate, EndTime, SubAvailHosp)
	
	s myINSFFlag=0
	i StTime="" s StTime="0"
	i EndTime="" s EndTime="86399"
	i StDate["/" s StDate=$zdh(StDate,4)
	i EndDate["/" s EndDate=$zdh(EndDate,4)
	
	b	;;	
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
	
	s myFootFlag="U"
	s myRepObj=##class(web.DHCEntity.OPC.ReportsInfos).%New()
	s myIPRepInfo = ##class(web.DHCBL.OPC.ReportsInfos).GetINVPRTRepInfo(stdate,sttime,EndDate,EndTime, .myRepObj, myFootFlag)
	
	b	;myIPRepInfo
	
	s myIPCPPRepInfo=""
	s myAPIRepInfo=##class(web.udhcOPHandin7FQuery).GetAPIRepInfo(stdate,sttime,EndDate,EndTime, hUser, myIPCPPRepInfo, .myRepObj)
	
	s myPDInfo=##class(web.udhcOPHandin7FQuery).GetPRDRepINfo(stdate,sttime,EndDate,EndTime, hUser, .myRepObj)
	b	;PRD   OK
	s myPDRtn=$p(myPDInfo,$c(3),1)
	s myPDInfo=$p(myPDInfo,$c(3),2)
	
	s myCardINVInfo=##class(web.DHCBL.OPC.ReportsInfos).GetCardINVRepInfo(stdate,sttime,EndDate,EndTime, hUser, .myRepObj, myFootFlag)
	s myCardINVRtn=$p(myCardINVInfo,$c(2),1)
	
	b	; CardINVPRT
	;
	s myUFUCount=myRepObj.RepInfos.Count()
	i (+myUFUCount>0)&&(+myINSFFlag=0) d
	.s myINSFFlag=122
	
	for myi=1:1:myUFUCount {
		s myRepObj.RepInfos.GetAt(myi).ReportStatus="U"
		b	;判断报表是否审核
		i ((+myINSFFlag=0)){
			s myINSFFlag=126
		}
	}
	
	s myCardINVInfo=##class(web.DHCBL.OPC.ReportsInfos).GetInComeReportInfo(stdate,sttime,EndDate,EndTime, hUser, .myRepObj, "A")
	
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
		;s myHospPMObj=myOperInfo.SetSelectPayMode(SubAvailHosp)
		
		;s myCashSum=myOperInfo.TotalPayModes.CashSum
		s myCashSum=myOperInfo.SelTotalPayMode.CashSum
		;s myChequeSum=myOperInfo.TotalPayModes.ChequeSum
		s myChequeSum=myOperInfo.SelTotalPayMode.ChequeSum
		
		;s myBankCardSum=myOperInfo.TotalPayModes.BankCardSum
		s myBankCardSum=myOperInfo.SelTotalPayMode.BankCardSum
		;s myYBCardSum=myOperInfo.TotalPayModes.YBCardSum
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
		
		i (myOperInfo.ReportStatus="C")&&(+myINSFFlag=0) d
		.s myINSFFlag=119
		
		i myOperInfo.ReportCollect'="Y" d
		.s myOperInfo.ReportCollect="N"
		
		i ((+myINSFFlag=0)&&(myOperInfo.ReportCollect'="Y")){
			s myINSFFlag=126
		}
		
		s mystr=myUserName_"^"_$fn(myCashSum,"",2)_"^"_$fn(myChequeSum,"",2)_"^"_$fn(myBankCardSum,"",2)_"^"_$fn(myYBCardSum,"",2)
		s mystr=mystr_"^"_$fn(myDWZHSum,"",2)_"^"_$fn(myHTZHSum,"",2)_"^"_$fn(myZGBLJZSum,"",2)_"^"_$fn(myJZQFSum,"",2)_"^"_$fn(myPMRowTSum,"",2)_"^^^^^^^^^^^^^^^"
		s myReportStatus=myOperInfo.ReportStatus
		s myReportCollect=myOperInfo.ReportCollect
		s retval=PMJsName_"('"_$ZCVT(mystr,"O","JS")_"', "_"'"_$ZCVT(myReportStatus,"O","JS")_"', '"_$ZCVT(myReportCollect,"O","JS")_"'"
		s retval=retval_");"
		
		&javascript<#(retval)#>
		
		s myItmACCat=""
		
		;当前收费员的 项目分类
		;myOperInfo
		
		s myAcCats=myOperInfo.ACCat
		s myItmCount=myAcCats.Count()
		for myItmIdx=1:1:myItmCount {
			s myACCat = myAcCats.GetAt(myItmIdx)
			i ((SubAvailHosp=myACCat.SubAvailHospitlDR)||(SubAvailHosp="")) {
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
	s mystr="合计  ^"_$fn(myTCashSum,"",2)_"^"_$fn(myTChequeSum,"",2)_"^"_$fn(myTBankCardSum,"",2)_"^"_$fn(myTYBCardSum,"",2)
	s mystr=mystr_"^"_$fn(myTDWZHSum,"",2)_"^"_$fn(myTHTZHSum,"",2)_"^"_$fn(myTZGBLJZSum,"",2)_"^"_$fn(myTJZQFSum,"",2)_"^"_$fn(myTPMRowTSum,"",2)_"^^^^^^^^^^^^^^^"
	s retval=PMJsName_"('"_$ZCVT(mystr,"O","JS")_"'"
	s retval=retval_");"
	
	&javascript<#(retval)#>
	
	s mystr=$fn(myTCashSum,"",2)_"^"_$fn(myTChequeSum,"",2)_"^"_$fn(myTBankCardSum,"",2)_"^"_$fn(myTYBCardSum,"",2)
	s mystr=mystr_"^"_$fn(myTDWZHSum,"",2)_"^"_$fn(myTHTZHSum,"",2)_"^"_$fn(myTZGBLJZSum,"",2)_"^"_$fn(myTJZQFSum,"",2)_"^"_$fn(myTPMRowTSum,"",2)_"^^^^^^^^^^^^^^^"
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
	.i myItemStr="" d
	..s myItemStr=$fn(^TMPTar($j, "FAIR", myIdx,"TSum"),"",2)
	.e  d
	..s myItemStr=myItemStr_"^"_$fn(^TMPTar($j, "FAIR", myIdx,"TSum"),"",2)
	
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
	
	s myinsobj=##class(web.DHCEntity.OPC.INSReport).%New()
	
	s myinsobj.StDate=$zd(StDate,3)
	s myinsobj.EndDate=$zd(EndDate,3)
	d myinsobj.XMLExportToStringExp(.myXmlData)
	d myinsobj.%Close()
	
	;当天数据不能办理财务结算
	i (+myINSFFlag=0)&&(+StDate=+$h) d
	.s myINSFFlag=123
	
	;最后判断一下是否办理结算
	s myrtn=+myINSFFlag
	
	;判断是否能够汇总打印
	
	
	q myrtn_"^"_myXmlData
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

Query FootItemQuery(StDate As %String = "", EndDate As %String = "", SubAvailHosp As %String = "") As %Query(ROWSPEC = "TNO:%String,UserName:%String,RepRowID:%String,TCAT1:%String,TCAT2:%String,TCAT3:%String,TCAT4:%String,TCAT5:%String,TCAT6:%String,TCAT7:%String, TCAT8:%String, TCAT9:%String, TCAT10:%String,TCAT11:%String, TCAT12:%String, TCAT13:%String, TCAT14:%String, TCAT15:%String, TCAT16:%String, TCAT17:%String, TCAT18:%String, TCAT19:%String, TCAT20:%String, TSum:%String, InsSum:%String, PatShareSum:%String, YBPaySum:%String, FeeYHSum:%String, UserRowID:%String")
{
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
	
	d ..KillTMP()
	;^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	s myDate=StDate-1
	s myPayModeObj=##class(web.DHCEntity.OPC.ReportsPayMode).%New()
	
	f  s myDate=$o(^DHCOPInsFootI(0,"Date",myDate)) q:((myDate="")!(myDate>EndDate))  d
	.s myHisRowID=0
	.f  s myHisRowID=$o(^DHCOPInsFootI(0,"Date",myDate,myHisRowID)) q:(myHisRowID="")  d
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
	...d myPayModeObj.PutPayMode(myPMCode,myTSum,0)
	
	d ..KillTMP()
	
	s myTCash=$fn(myPayModeObj.CashSum,"",2)
	s myTCheck=$fn(myPayModeObj.ChequeSum,"",2)
	s myTBankCard=$fn(myPayModeObj.BankCardSum,"",2)
	s myTYBPay=$fn(+myPayModeObj.YBCardSum,"",2)
	s myTDBZH="0.00"
	s myTHTJZ="0.00"
	s myTBLJZ="0.00"
	s myTELackFair="0.00"
	s myTTotal=myPayModeObj.CashSum+myPayModeObj.ChequeSum+myPayModeObj.BankCardSum+myPayModeObj.YBCardSum
	s myTTotal=$fn(myTTotal,"",2)
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
