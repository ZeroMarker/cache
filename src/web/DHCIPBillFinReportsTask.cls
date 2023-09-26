Import sqluser

Class web.DHCIPBillFinReportsTask Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function出院结算汇总表任务
/// CreateDate:2013-05-09
/// OEORI_OrdDept_DR (病人所在科室),OEORI_AdmLoc_DR(病人所在病区)
/// w ##class(web.DHCIPBillFinReportsTask).InsertFinancialFeeSum()
ClassMethod InsertFinancialFeeSum()
{
	s StDate=..getstdate("FINANCIALACOUNT")
	i StDate["/" s StDate=$zdh(StDate,4)
	s TaskEndDate=+$h-1  ;做前一天的任务
	
	d ..GetFinancialFeeSum(StDate,TaskEndDate,"")
	tstart
	s Err=0
	f TaskDate=StDate:1:TaskEndDate d
	.q:$d(^DHCJFYJACOUNT(0,"DateFlag","FINANCIALACOUNT",TaskDate)) 
	.s OrdDepDr=""
	.f  s OrdDepDr=$o(^||TMPFINANCIALWARDFEE(TaskDate,OrdDepDr)) q:OrdDepDr=""  d
	..s OrdWardDr=""
	..f  s OrdWardDr=$o(^||TMPFINANCIALWARDFEE(TaskDate,OrdDepDr,OrdWardDr)) q:OrdWardDr=""  d
	...s Wardtot=+$g(^||TMPFINANCIALWARDFEE(TaskDate,OrdDepDr,OrdWardDr))
	...s InsAccInfo=TaskDate_"^"_""_"^"_TaskDate_"^"_""_"^"_""_"^"_""_"^"_""_"^"_Wardtot_"^"_""_"^"_"FINANCIALACOUNT"_"^"_OrdWardDr_"^"_OrdDepDr
    ...s RetInfo=..InsertAcount(InsAccInfo)
    ...s RetErr=$p(RetInfo,"^",1),RetAcctRowID=$p(RetInfo,"^",2)
    ...s Err=Err+RetErr
	...s ACRowID=0
	...f  s ACRowID=$o(^DHCTarC("TAC",ACRowID)) q:ACRowID=""  d
	....s AcctFee=+$g(^||TMPFINANCIALWARDFEE(TaskDate,OrdDepDr,OrdWardDr,ACRowID))
	....s InsFeeInfo=RetAcctRowID_"^"_ACRowID_"^"_0_"^"_0_"^"_+AcctFee
	....s AcctRetErr=..InsertFeeAcount(InsFeeInfo)
	....s Err=Err+AcctRetErr
	b ;err
	i Err=0 d
	.tc
	e  d
	.trollback
	k ^||TMPFINANCIALWARDFEE
	
	q Err
}

/// 取出院结算分类费用
/// DateFlag:"Y":表示按结账日，否则默认按自然日 
ClassMethod GetFinancialFeeSum(StDate, EndDate, DateFlag)
{
   k ^||TMPFINANCIALFEE,^||TMPFINANCIALWARDFEE
   i StDate["-" s StDate=$zdh(StDate,3)
   i EndDate["-" s EndDate=$zdh(EndDate,3)
   i StDate["/" s StDate=$zdh(StDate,4)
   i EndDate["/" s EndDate=$zdh(EndDate,4)
   i DateFlag'="Y" d
   .f PrtDate=StDate:1:EndDate d
   ..s PrtRowID="0" 
   ..f  s PrtRowID=$o(^DHCINVPRTZY(0,"DATE",PrtDate,PrtRowID)) q:PrtRowID=""  d
   ...s PrtFlag=$p(^DHCINVPRTZY(PrtRowID),"^",8)
   ...q:PrtFlag="A"
   ...s PrtAdm=$p(^DHCINVPRTZY(PrtRowID),"^",4)
   ...s AdmWardID=$p(^PAADM(PrtAdm),"^",70)
   ...s PBRowID=$p(^DHCINVPRTZY(PrtRowID),"^",5)
   ...s OrdSub=0
   ...f  s OrdSub=$o(^DHCPB(PBRowID,"O",OrdSub)) q:OrdSub=""  d
   ....s OEItmRowID=$p(^DHCPB(PBRowID,"O",OrdSub),"^",4)
   ....s Itm=+OEItmRowID,ItmCld=$p(OEItmRowID,"||",2)
   ....s OEORIDate=$P($G(^OEORD(Itm,"I",ItmCld,3)),"^",7)  ;取得医嘱表医嘱日期时间?加入基础数据表
   ....s OEORITime=$P($G(^OEORD(Itm,"I",ItmCld,1)),"^",17)
   ....;医嘱所在科室
   ....s OEDepDr=..GetCuurntWard(OEORIDate,OEORITime,PrtAdm,6,AdmWardID)
   ....;医嘱所在病区
   ....s OEWardDr=..GetCuurntWard(OEORIDate,OEORITime,PrtAdm,9,AdmWardID)
   ....s DetSub=0
   ....f  s DetSub=$o(^DHCPB(PBRowID,"O",OrdSub,"D",DetSub)) q:DetSub=""  d
   .....s TariDr=$p(^DHCPB(PBRowID,"O",OrdSub,"D",DetSub),"^",3)     ;收费项目
   .....s PBTotal=$p(^DHCPB(PBRowID,"O",OrdSub,"D",DetSub),"^",7) ;总额
   .....i TariDr'="" s ACSubCateDr=$p(^DHCTARI(TariDr),"^",5)        ;会计子分类
   .....s AcctCate=$p(^DHCTarC("AC",ACSubCateDr),"^",3)                ;会计大类
   .....s ^||TMPFINANCIALWARDFEE(PrtDate,OEDepDr,OEWardDr,AcctCate)=+$g(^||TMPFINANCIALWARDFEE(PrtDate,OEDepDr,OEWardDr,AcctCate))+PBTotal
   .....S ^||TMPFINANCIALWARDFEE(PrtDate,OEDepDr,OEWardDr)=+$G(^||TMPFINANCIALWARDFEE(PrtDate,OEDepDr,OEWardDr))+PBTotal
   b 
  q
}

/// 取账务开始日期
ClassMethod getstdate(flag)
{
	s stdate=+$h-1
	s rowid=$o(^DHCJFYJACOUNT(0,"Flag",flag,""),-1)
	i rowid'="" d
	.s enddate=$p(^DHCJFYJACOUNT(rowid),"^",6)
	.s stdate=enddate+1
	e  d
	.I flag="FINANCIALACOUNT" d
	..s PrtRowID=$o(^DHCINVPRTZY("0"))
	..i PrtRowID'="" s stdate=$p(^DHCINVPRTZY(PrtRowID),"^",2)
	.i flag="YJACOUNT" d
	..s PrtRowID=$o(^DHCSFPRINTDETAIL("0"))
	..i PrtRowID'="" s stdate=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",2)
    i stdate="" s stdate=+$h-1
 	i stdate'="" s stdate=$zd(stdate,4)
	q stdate
}

/// Creator：yyx
/// CreateDate:2013-05-30
/// Function:预交金账务表
/// w ##class(web.DHCIPBillFinReportsTask).InsertDepositAcount()
ClassMethod InsertDepositAcount()
{
	s StDate=..getstdate("YJACOUNT")
	i StDate["/" s StDate=$zdh(StDate,4)
	s TaskEndDate=+$h-1  ;做前一天的任务
	d ..GetDepositAcountInfo(StDate,TaskEndDate,"")
	b ;start
	s AddUser=""
	tstart
	s Err=0
	f TaskDate=StDate:1:TaskEndDate d
	.q:$d(^DHCJFYJACOUNT(0,"DateFlag","YJACOUNT",TaskDate)) 
	.i ($d(^||TMPDEPOSIT(TaskDate,"JFSum"))!$d(^||TMPDEPOSIT(TaskDate,"DFSum"))) d
	..s LastRemain=+$g(^||TMPDEPOSIT(TaskDate,"LastRemain"))
	..s DFSum=+$g(^||TMPDEPOSIT(TaskDate,"DFSum"))
	..s JFSum=+$g(^||TMPDEPOSIT(TaskDate,"JFSum"))
	..s LastRemain=##class(web.DHCIPBillFinReports).getlastremain(TaskDate,"YJACOUNT","")
	..s CurRemain=LastRemain+DFSum-JFSum
	..;开始日期^开始时间^结束日期^结束时间^上期余额^借方^贷方^当前余额^添加人^标志^病区^科室
	..s InsAccInfo=TaskDate_"^"_""_"^"_TaskDate_"^"_""_"^"_LastRemain_"^"_JFSum_"^"_DFSum_"^"_CurRemain_"^"_AddUser_"^"_"YJACOUNT"_"^"_""_"^"_""
	..s RetInfo=..InsertAcount(InsAccInfo)
    ..s RetErr=$p(RetInfo,"^",1),RetAcctRowID=$p(RetInfo,"^",2)
    ..s Err=Err+RetErr
    ..s rtn=##Class(web.DHCIPBillDeptAcountDetail).InsertYJAcountSub(RetAcctRowID,"Date")
    ..S Err=Err+rtn
    ..i rtn'=0 d 
    ...b ;rtn
    b ;end
    i Err=0 d
    .tc
    e  d
    .trollback
    q Err
}

/// Creator:yyx
/// CreateDate:2013-05-30
/// Function:取结算预交金张的押金信息
/// d ##class(web.DHCIPBillFinReportsTask).GetDepositAcountInfo(+$h-200,+$h,"")
ClassMethod GetDepositAcountInfo(StDate, EndDate, DateFlag)
{
	k ^||TMPDEPOSIT
	i StDate["-" s StDate=$zdh(StDate,3)
    i EndDate["-" s EndDate=$zdh(EndDate,3)
    i StDate["/"  s StDate=$zdh(StDate,4)
    i EndDate["/" s EndDate=$zdh(EndDate,4)
    i DateFlag'="Y" d
    .f PrtDate=StDate:1:EndDate d
    ..;s LastRemain=##class(web.DHCIPBillFinReports).getlastremain(PrtDate,"YJACOUNT","")
    ..s LastRemain=0
    ..s ^||TMPDEPOSIT(PrtDate,"LastRemain")=+LastRemain
    ..s PrtRowID="0" 
    ..f  s PrtRowID=$o(^DHCSFPRINTDETAIL(0,"PrtDate",PrtDate,PrtRowID)) q:PrtRowID=""  d 
	...s PrintDate=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",2)
	...s PrintTime=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",3)
	...s PrtStatus=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",8)
	...q:PrtStatus="2"
	...s PayAmount=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",6)
	...i (PrtStatus="1")!(PrtStatus="4") d
	....s ^||TMPDEPOSIT(PrtDate,"DFSum")=+$g(^||TMPDEPOSIT(PrtDate,"DFSum"))++PayAmount
	...i PrtStatus="3" d
	....s ^||TMPDEPOSIT(PrtDate,"JFSum")=+$g(^||TMPDEPOSIT(PrtDate,"JFSum"))-+PayAmount
    ..s InvRowID="0" 
	..f  s InvRowID=$o(^DHCINVPRTZY(0,"DATE",PrtDate,InvRowID)) q:InvRowID=""  d
	...s PrtFlag=$p(^DHCINVPRTZY(InvRowID),"^",8) 
	...q:PrtFlag="A"
	...s BillNo=$p(^DHCINVPRTZY(InvRowID),"^",5)
	...s JFAmount=0
	...s DepInfo=$g(^DHCJFDepositRowID("ZYJF",BillNo))
	...i DepInfo'=""  d
	....s DepNum=$length(DepInfo,"^")
	....f i=1:1:DepNum  d
	.....s DepStr=$p(DepInfo,"^",i)
	.....s DepositID=$p(DepStr,"!",1)
	.....s DepositStatus=$p(DepStr,"!",2)
	.....q:DepositStatus=2
	.....s DepositAmt=$p(^DHCSFPRINTDETAIL(DepositID),"^",6)
    .....s JFAmount=JFAmount+DepositAmt
    .....s ^||TMPDEPOSIT(PrtDate,"JFSum")=+$g(^||TMPDEPOSIT(PrtDate,"JFSum"))++DepositAmt
    
    q
}

/// 插入dhc_jfyjacount表
ClassMethod InsertAcount(InsInfo)
{
	s AcctRowID=""
	s stdate=$p(InsInfo,"^",1)
    s sttime=$p(InsInfo,"^",2)
    s enddate=$p(InsInfo,"^",3)
    s endtime=$p(InsInfo,"^",3)
    s lastremain=$p(InsInfo,"^",5)
    s jfsum=$p(InsInfo,"^",6)
    s dfsum=$p(InsInfo,"^",7)
    s curremain=$p(InsInfo,"^",8)
    s adddate=+$h
    s addtime=$p($h,",",2)
    s adduser=$p(InsInfo,"^",9)
    s flag=$p(InsInfo,"^",10)
    s warddr=$p(InsInfo,"^",11)
    s depdr=$p(InsInfo,"^",12)
	&sql(insert into dhc_jfyjacount(acct_stdate,acct_sttime,acct_enddate,acct_endtime,acct_lastremain,acct_jfsum,acct_dfsum,acct_curremain,acct_adddate,acct_addtime,acct_adduser,acct_flag,acct_ward_dr,acct_dep_dr)
	values (:stdate,:sttime,:enddate,:endtime,:lastremain,:jfsum,:dfsum,:curremain,:adddate,:addtime,:adduser,:flag,:warddr,:depdr))
    s AcctRowID=%ROWID
    q SQLCODE_"^"_AcctRowID
}

/// 插入分类明细表dhc_jffeeacount
ClassMethod InsertFeeAcount(FeeInfo)
{
	s jkrowid=$p(FeeInfo,"^",1)
	s flrowid=$p(FeeInfo,"^",2)
	s jfsum=$p(FeeInfo,"^",3)
	s dfsum=$p(FeeInfo,"^",4)
	s curremain=$p(FeeInfo,"^",5)
	&sql(insert into dhc_jffeeacount(fee_acct_dr,fee_tari_dr,fee_jfsum,fee_dfsum,fee_currentremain)
	  values(:jkrowid,:flrowid,:jfsum,:dfsum,:curremain))
	q SQLCODE
}

ClassMethod GetCuurntWard(OEORIDate, OEORITime, PAADMDR, Piece, PatCTWardDR)
{
 k WardRowid
 ;s OEORIDate=$zdh("2005-6-30",3)
 ;s OEORITime=$zth("15:13:37",3)
 ;s PAADMDR=164
 ;s PatCTWardDR=100
 ;s Piece=9
 i OEORIDate=0 d
 .s OEORIDate=$p(^PAADM(PAADMDR),"^",6)
 .s OEORITime=$p(^PAADM(PAADMDR),"^",7)
 i PatCTWardDR="" s PatCTWardDR=99999
 s WardRowid=0
 i '$d(^PAWARD(0,"WARD_LocationDR",PatCTWardDR)) s WardRowid=99999
 e  s WardRowid=$o(^PAWARD(0,"WARD_LocationDR",PatCTWardDR,WardRowid))
 s WardRowid=$$GetCurrent(PAADMDR,OEORIDate,OEORITime,WardRowid,Piece,0)
 i Piece=9 d
 .i $d(^PAWARD(WardRowid)) s PatCTWardDR=$p(^PAWARD(WardRowid),"^",5)  
 .e  s PatCTWardDR=99999
 e  d
 .s PatCTWardDR=WardRowid
 q PatCTWardDR
  ///取病人的当前科室的上一条转科记录,日期和时间
GetCurrent(PAADMRowid,OeordDate,OeordTime,OeordLoc,TransPiece,FlagNum)   
 
 ;先取出该病人的所有转科记录?转床或者是医生都不记入?发生在下医嘱时间之前的也不记入
 ;将这些转科记录存入临时global?按照条件取出来  20120906周凡新改程序
 ;FlagNum=0为当前科室?1为上一科室
 ;TransPiece=5 ;ctpcp
 ;TransPiece=6 ;ctloc
 ;TransPiece=7 ;room
 ;TransPiece=8 ;bed
 ;TransPiece=9 ;ward
 n (PAADMRowid,OeordDate,OeordTime,OeordLoc,TransPiece,FlagNum)
 q:FlagNum<0 OeordLoc
 k tLoc,cLoc
 k ^mtempDHCWL($j,"cTran")
 ;s PAADMRowid=20
 ;s OeordDate=$zdh("2005-3-23",3)
 ;s OeordTime=$zth("14:52:11",3)
 ;s OeordLoc=222
 
 s cLoc=0
 s TransDate=""
 f  s TransDate=$o(^PAADMi("TransDateTime1",PAADMRowid,TransDate)) q:TransDate=""  d
 .q:TransDate>OeordDate
 .s TransTime=""
 .f  s TransTime=$o(^PAADMi("TransDateTime1",PAADMRowid,TransDate,TransTime)) q:TransTime=""  d
 ..q:((TransDate=OeordDate)&(TransTime>OeordTime))
 ..s TransSub=0
 ..f  s TransSub=$o(^PAADMi("TransDateTime1",PAADMRowid,TransDate,TransTime,TransSub)) q:TransSub=""  d
 ...s TransLoc=$p(^PAADM(PAADMRowid,"TRANS",TransSub),"^",TransPiece)
 ...q:TransLoc=""
 ...q:cLoc=TransLoc
 ...s ^mtempDHCWL($j,"cTran",TransDate,TransTime)=TransLoc
 ...s cLoc=TransLoc
 
 s tFlag=-1
 s cDate=""
 f  s cDate=$o(^mtempDHCWL($j,"cTran",cDate),-1) q:(cDate="")!(tFlag=FlagNum)  d
 .s cTime=""
 .f  s cTime=$o(^mtempDHCWL($j,"cTran",cDate,cTime),-1) q:(cTime="")!(tFlag=FlagNum)  d
 ..s tFlag=tFlag+1
 ..s tLoc=^mtempDHCWL($j,"cTran",cDate,cTime)
 i tFlag'=FlagNum s tLoc=OeordLoc
 k ^mtempDHCWL($j,"cTran")
 q $g(tLoc)
}

}
