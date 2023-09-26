Import SQLUser

Class web.DHCIPBillDeptAcountDetail Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 提供给服务器的自动结算类方法
/// d ##class(web.DHCIPBillDeptAcountDetail).ACFinDataAutoFoot()
ClassMethod ACFinDataAutoFoot(flag) As %String
{
	s Job=$i(^TMPIPBAcount("YJAcountSub"))
	k ^TMPIPBAcount(Job)
	
	s myfootinfo=..ReadACFinData(flag, Job)
		
	s myrtn=$p(myfootinfo,$c(3),1)
	s ExpStr=""
	;写一次日志写到^TMP
	i (+myrtn=0) d
	.s myFootUserDR="1"
	.s ExpStr=Job
	.s myDPFootInfo=$p(myfootinfo,$c(3),2)
	.s myfootsaveinfo=..ACFinDataFoot(myFootUserDR ,myDPFootInfo, ExpStr)
	.s myrtn=$p(myfootsaveinfo,$c(3),1)
	.i +myrtn=0 d
	..;结算成功！
	..s ^TMPIPBFoot("S",+$h,$p($h,",",2))="系统自动结算成功,时间："_$zd(+$h,3)_" "_$zt($p($h,",",2))
	..s ^TMPIPBFoot("S",+$h,$p($h,",",2),"DPFInfo")=myDPFootInfo
	.e  d
	..;结算失败日志
	..s ^TMPIPBFoot("F",+$h,$p($h,",",2))="系统自动结算失败,时间："_$zd(+$h,3)_" "_$zt($p($h,",",2))
	..s ^TMPIPBFoot("F",+$h,$p($h,",",2),"DPFInfo")=myDPFootInfo
	..s ^TMPIPBFoot("F",+$h,$p($h,",",2),"FailInfo")=myfootsaveinfo
	
	q 0
}

ClassMethod ACFinDataFoot(FootUserDR As %String, ACFInfo As %String, ExpStr As %String) As %String
{
	s $ZT="ERROR^DHCSSERR" 
	n (FootUserDR, ACFInfo, ExpStr)
	s Job=ExpStr
	
	s rtn=0
	
	d ..tb()

	s BDate=$P(ACFInfo,"^",1)
	s BTime=$P(ACFInfo,"^",2)
	s EndDate=$P(ACFInfo,"^",3)
	s EndTime=$P(ACFInfo,"^",4)
	
	i (EndDate["-") d
	.s EndDate=$zdh(EndDate,3)
	i (EndDate["/") d
	.s EndDate=$zdh(EndDate,4)
	//s EndTime=$zth(EndTime)
	
	i (BDate["-") d
	.s BDate=$zdh(BDate,3)
	i (BDate["/") d
	.s BDate=$zdh(BDate,4)
	//s BTime=$zth(BTime)
	
	s lastremain=$p(ACFInfo,"^",5)
	s dfsum=$p(ACFInfo,"^",6)
	s jfsum=$p(ACFInfo,"^",7)
	s curremain=$P(ACFInfo,"^",8)
	
	s adddate=+$h
	s addtime=$p($h,",",2)
	s flag="YJACOUNT"
    
    &SQL(INSERT INTO Dhc_JFYJAcount(Acct_stdate,Acct_sttime,Acct_enddate,Acct_endtime,Acct_lastremain,Acct_jfsum,Acct_dfsum,Acct_curremain,Acct_adddate,Acct_addtime,Acct_adduser,Acct_flag)
	VALUES (:BDate,:BTime,:EndDate,:EndTime,:lastremain,:jfsum,:dfsum,:curremain,:adddate,:addtime,:FootUserDR,:flag))
	i SQLCODE'=0 tro
    s rtn=rtn+SQLCODE
	s jkrowid=$g(%ROWID)

	s adm=0
	i (+rtn=0) d
	.f  s adm=$o(^TMPIPBAcount(Job,adm)) q:((adm="")!(+rtn'=0))  d
	..s myPreLeftSum=+$g(^TMPIPBAcount(Job,adm,"PLeft"))
	..s myDFSum=+$g(^TMPIPBAcount(Job,adm,"Add"))
	..s myJFSum=+$g(^TMPIPBAcount(Job,adm,"Reduce"))
	..s myCurLeftSum=myPreLeftSum+myDFSum+myJFSum
	..q:(myPreLeftSum=0)&(myDFSum=0)&(myJFSum=0)	
	..k PLIST
	..s PLIST(0)=jkrowid
	..s PLIST(3)=+adm
	..s PLIST(4)=+myDFSum
	..s PLIST(5)=+myJFSum
	..s PLIST(7)=+myPreLeftSum
	..s PLIST(8)=+myCurLeftSum
	..&SQL(INSERT INTO DHC_IPBillDeptAcountDetail VALUES PLIST())
	..s rtn=rtn+SQLCODE
   
	
	if (+rtn=0)  d
	.d ..tc()
	e  d
	.tro
	
	k ^TMPIPBAcount(Job)
	
	q rtn_$c(3)_jkrowid
}

/// w ##class(web.DHCIPBillDeptAcountDetail).ReadACFinData()
ClassMethod ReadACFinData(flag, Job) As %String
{
	;n (ad)
	s myrtn=..GetDate(flag)
	s myrtn=myrtn_"^"_Job
    s myInfo=..BuildACFinData(myrtn, flag)
    
    q myInfo
}

/// w ##class(web.DHCIPBillDeptAcountDetail).BuildACFinData()
ClassMethod BuildACFinData(myrtn, DateFlag, HospId As %String = "") As %String
{
	n (myrtn, DateFlag, HospId)

	s rtn=0

	s myBDate=$p(myrtn,"^",1)
	s myBTime=$p(myrtn,"^",2)
	s myEndDate=$p(myrtn,"^",3)
	s myEndTime=$p(myrtn,"^",4)
	s myPFRowID=$p(myrtn,"^",5)   //上一条记录RowId
	s Job=$p(myrtn,"^",7)
	
	s myPreLeftSum=0
	s myJFSum=0
	s myDFSum=0
	
	i (myPFRowID'="") d
	.//本次的期初=上次的期末
	.s myPreLeftSum=$p($g(^DHCJFYJACOUNT(myPFRowID)),"^",4)    //Acct_curremain
	.s sub=0
	.f  s sub=$o(^DHCIPBillDeptAcountD(myPFRowID,"SUB",sub))  q:(sub="")  d
	..s dtlData=$g(^DHCIPBillDeptAcountD(myPFRowID,"SUB",sub))
	..q:(dtlData="")
	..s adm=$p(dtlData,"^",1)
	..s bal=$p(dtlData,"^",6)
	..q:((adm="")||(+bal=0))
	..s ^TMPIPBAcount(Job,adm,"PLeft")=+bal
	
	i (DateFlag="Date")  d
	.f myDate=myBDate:1:myEndDate  d
	..//押金
	..s prt=0
	..f  s prt=$o(^DHCSFPRINTDETAIL(0,"PrtDate",myDate,prt))  q:(prt="")  d
	...s depData=$g(^DHCSFPRINTDETAIL(prt))
	...q:(depData="")
	...s ptime=$p(depData,"^",3)
	...s depTypeDr=$p(depData,"^",13)
	...s depTypeCode=$s((+depTypeDr'=0):$p($g(^ARC("ARCDT",depTypeDr)),"^",1),1:"")
	...q:(depTypeCode'="01")
	...s depHospDR=$p(depData,"^",44)
	...q:((depHospDR'=HospId)&&(HospId'=""))   //wangjian 2018-10-15
	...s adm=$p(depData,"^",4)
	...s flag=$p(depData,"^",8)
	...q:(+flag=2)
	...s amt=$p(depData,"^",6)
	...s ^TMPIPBAcount(Job,adm,"Add")=+$g(^TMPIPBAcount(Job,adm,"Add"))+amt
	...s myDFSum=myDFSum+amt
	..//住院结算
	..s inv=0
	..f  s inv=$o(^DHCINVPRTZY(0,"DATE",myDate,inv))  q:(inv="")  d
	...s invData=$g(^DHCINVPRTZY(inv))
	...q:(invData="")
	...s ptime=$p(invData,"^",3)
	...//q:((myDate=myBDate)&&(ptime<myBTime))||((myDate=myEndDate)&&(ptime>myEndTime))
	...s adm=$p(invData,"^",4)
	...s amt=$p(invData,"^",6)
	...s flag=$p(invData,"^",8)
	...q:(flag="A")
	...s invDepAmt=$p(invData,"^",22)
	...s invHospDR=$p(invData,"^",35)
	...q:(invHospDR'=HospId)&&(HospId'="")  //wangjian 2018-10-11
	...s ^TMPIPBAcount(Job,adm,"Reduce")=$g(^TMPIPBAcount(Job,adm,"Reduce"))-invDepAmt
	...s myJFSum=myJFSum-invDepAmt
	e  d
	.f myDate=myBDate:1:myEndDate  d
	..s jkid=0
	..f  s jkid=$o(^DHCJFUSERJK(0,"date",myDate,jkid))  q:(jkid="")  d
	...s ptime=$p(^DHCJFUSERJK(jkid),"^",2)
	...s jkHospDR=$p(^DHCJFUSERJK(jkid),"^",27)
	...q:((jkHospDR'=HospId)&&(HospId'=""))   //wangjian 2018-10-15
	...q:((myDate=myBDate)&&(ptime<myBTime))||((myDate=myEndDate)&&(ptime>myEndTime))
	...//押金
	...s prt=0
	...f  s prt=$o(^DHCSFPRINTDETAIL(0,"JKDR",jkid,prt))  q:(prt="")  d
	....s depData=$g(^DHCSFPRINTDETAIL(prt))
	....q:(depData="")
	....s ptime=$p(depData,"^",3)
	....//q:((myDate=myBDate)&&(ptime<myBTime))||((myDate=myEndDate)&&(ptime>myEndTime))
	....s depTypeDr=$p(depData,"^",13)
	....s depTypeCode=$s((+depTypeDr'=0):$p($g(^ARC("ARCDT",depTypeDr)),"^",1),1:"")
	....q:(depTypeCode'="01")
	....s depHospDR=$p(depData,"^",44)
	....q:(depHospDR'=HospId)&&(HospId'="")  //wangjian 2018-10-15
	....s adm=$p(depData,"^",4)
	....s flag=$p(depData,"^",8)
	....q:(+flag=2)
	....s amt=$p(depData,"^",6)
	....s ^TMPIPBAcount(Job,adm,"Add")=$g(^TMPIPBAcount(Job,adm,"Add"))+amt
	....s myDFSum=myDFSum+amt
	...//住院收费
	...s inv=0
	...f  s inv=$o(^DHCINVPRTZY(0,"JK",jkid,inv))  q:(inv="")  d
	....s invData=$g(^DHCINVPRTZY(inv))
	....q:(invData="")
	....s ptime=$p(invData,"^",3)
	....s adm=$p(invData,"^",4)
	....s amt=$p(invData,"^",6)
	....s flag=$p(invData,"^",8)
	....q:(flag="A")
	....s invDepAmt=$p(invData,"^",22)
	....s invHospDR=$p(invData,"^",35)
	....q:((invHospDR'=HospId)&&(HospId'=""))  //wangjian 2018-10-11
	....s ^TMPIPBAcount(Job,adm,"Reduce")=$g(^TMPIPBAcount(Job,adm,"Reduce"))-invDepAmt
	....s myJFSum=myJFSum-invDepAmt

	s myCurLeft=myPreLeftSum+myDFSum+myJFSum
	
	s myInfo=myBDate_"^"_myBTime_"^"_myEndDate_"^"_myEndTime
	s myInfo=myInfo_"^"_myPreLeftSum_"^"_myDFSum_"^"_myJFSum_"^"_myCurLeft
	
	q rtn_$c(3)_myInfo
}

ClassMethod GetDate(flag) As %String
{
	s myBDate=""
	s myBTime=""
	s myPFRowID=""
	
	s curdate=+$h+1    ;技巧在当前的日前一定加上1  变成当前日期的明天。
	s maxtime=$zth("23:59:59",3)
	i $d(^DHCJFYJACOUNT(0,"Flag","YJACOUNTSAVE")) d
	.s myPFRowID=$o(^DHCJFYJACOUNT(0,"Flag","YJACOUNTSAVE",""),-1)
	.s myBTime=$p($g(^DHCJFYJACOUNT(myPFRowID)),"^",12)
	.s myBDate=$p($g(^DHCJFYJACOUNT(myPFRowID)),"^",6)
	e  d   ;没有办理结算时取账户管理的最小时间。
	.s myBDate=$o(^DHCSFPRINTDETAIL(0,"PrtDate",myBDate))     ;最小时间
	.q:(myBDate="")
	.s myPrtRowID=$o(^DHCSFPRINTDETAIL(0,"PrtDate",myBDate,0))
	.s myBTime=$p($g(^DHCSFPRINTDETAIL(myPrtRowID)), "^", 3)
	.;i (myBDate'="") d
	.;.s myBTime=$o(^DHCACDi("AccM",0,"OCDate",myBDate,myBTime))
	
	i myBDate="" d
	.s myBDate=+$h
	i myBTime="" d
	.s myBTime=$p($h,",",2)
	
	;s myBDate=$zd(myBDate,3)
	;s myBTime=$zt(myBTime)
	s curdate=+$h
	s curtime=$p($h,",",2)
	
	s myDateInfo=..AutoGetDT(myBDate, myBTime, +$h, "", flag)
	s curdate=$p(myDateInfo,"^",1)
	s curtime=$p(myDateInfo,"^",2)
	;s curdate=$zdh("2006-10-10",3)
	;s curtime=$zth("23:59:59")
	
	s myHSDate=0
	i (+myBDate=+curdate) {
		s myHSDate=+curdate
	}elseif((+myBDate'=+curdate)&(curtime=0)){
		s myHSDate=+curdate-1
	}else{
		s myHSDate=curdate
	}
	
	q myBDate_"^"_myBTime_"^"_curdate_"^"_curtime_"^"_myPFRowID_"^"_myHSDate
}

/// w ##class(web.DHCIPBillDeptAcountDetail).AutoGetDT(+$h-2,0,+$h,0)
ClassMethod AutoGetDT(BDate As %String, BTime As %String, EndDate As %String, ExpStr As %String, flag) As %String
{
	n (BDate, BTime, EndDate, ExpStr, flag)
	
	s myrtn=+$h_"^"_$p($h,",",2)
	

	s myEndTime=0
	s myEndDate=EndDate
	
	i (+BDate<+$h) d
	.s myCount=0
	.s mypdate=""
	.f mypdate=BDate:1:EndDate  q:(+myCount'=0)  d
	..q:(+mypdate>=+$h)			;要求当前日期
	..s myTMPEndDate=mypdate+1
	..s myTMPEndTime=myEndTime
	..s mybtime=BTime
	..i (mypdate>BDate)   s mybtime=0
	..s myCount=..CheckAccFlag(mypdate, mybtime, myTMPEndDate, myTMPEndTime, flag)
	..i +myCount'=0  d
	...;如果当天存在要要结算数据, 把结束时间定为明天的0分
	...s myEndDate=mypdate+1
	...s myEndTime=0
	...s myrtn=myEndDate_"^"_myEndTime
	
	q myrtn
}

/// 查找这段时间内的预交金笔数
/// w ##class(web.DHCIPBillDeptAcountDetail).CheckAccFlag(60446,0,60447,0)
ClassMethod CheckAccFlag(BDate As %String, BTime As %String, EndDate As %String, EndTime As %String, flag) As %String
{
	n (BDate, BTime, EndDate, EndTime, flag)
	s myCount=0
	
	i (flag="Date")  d
	.f mydate=BDate:1:EndDate d
	..s myPrtRowID=0
	..f  s myPrtRowID=$o(^DHCSFPRINTDETAIL(0,"PrtDate",mydate,myPrtRowID)) q:(myPrtRowID="")  d
	...q:($d(^DHCSFPRINTDETAIL(myPrtRowID))=10)
	...s myPreInfo=$g(^DHCSFPRINTDETAIL(myPrtRowID))
	...s myTime=$p(myPreInfo,"^",3)			;AccPD_PreTime
	...q:((+mydate=+BDate)&&(+myTime<+BTime))
	...q:((+mydate=+EndDate)&&(+myTime>=+EndTime))
	...s myCount=myCount+1
	..s myInvDr=0
	..f  s myInvDr=$o(^DHCINVPRTZY(0,"DATE",mydate,myInvDr)) q:(myInvDr="")  d
	...q:($d(^DHCINVPRTZY(myInvDr))=10)
	...s myPayInfo=$g(^DHCINVPRTZY(myInvDr))
	...s myTime=$p(myPayInfo,"^",3)
	...s invDepAmt=$p(myPayInfo,"^",22)
	...q:(+invDepAmt=0)
	...q:((+mydate=+BDate)&&(+myTime<+BTime))
	...q:((+mydate=+EndDate)&&(+myTime>=+EndTime))
	...s myCount=myCount+1
	e    d
	.f jkdate=BDate:1:EndDate d
	..s jkid=0
	..f  s jkid=$o(^DHCJFUSERJK(0,"date",jkdate,jkid))  q:(jkid="")  d
	...s myPrtRowID=0
	...f  s myPrtRowID=$o(^DHCSFPRINTDETAIL(0,"JKDR",jkid,myPrtRowID)) q:(myPrtRowID="")  d
	....q:($d(^DHCSFPRINTDETAIL(myPrtRowID))=10)
	....s myPreInfo=$g(^DHCSFPRINTDETAIL(myPrtRowID))
	....s mydate=$p(myPreInfo,"^",2)
	....s myTime=$p(myPreInfo,"^",3)			;AccPD_PreTime
	....q:((+mydate=+BDate)&&(+myTime<+BTime))
	....q:((+mydate=+EndDate)&&(+myTime>=+EndTime))
	....s myCount=myCount+1
	...s myInvDr=0
	...f  s myInvDr=$o(^DHCINVPRTZY(0,"JK",jkid,myInvDr)) q:(myInvDr="")  d
	....q:($d(^DHCINVPRTZY(myInvDr))=10)
	....s myPayInfo=$g(^DHCINVPRTZY(myInvDr))
	....s mydate=$p(myPayInfo,"^",2)
	....s myTime=$p(myPayInfo,"^",3)
	....s invDepAmt=$p(myPayInfo,"^",22)
	....q:(+invDepAmt=0)
	....q:((+mydate=+BDate)&&(+myTime<+BTime))
	....q:((+mydate=+EndDate)&&(+myTime>=+EndTime))
	....s myCount=myCount+1
	
	q myCount
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
	n SQLCODE
	TCOMMIT  s SQLCODE=$zu(34)
	q
}

ClassMethod InsertYJAcountSub(DeptFtDr As %String, DateFlag As %String, HospId As %String = "")
{
	new (DeptFtDr, DateFlag, HospId)
	
	set DateFlag="Date"
	set stdate=$p(^DHCJFYJACOUNT(DeptFtDr),"^",5)      //Acct_stdate
	set sttime=$p(^DHCJFYJACOUNT(DeptFtDr),"^",11)     //Acct_sttime
	set enddate=$p(^DHCJFYJACOUNT(DeptFtDr),"^",6)     //Acct_enddate
	set endtime=$p(^DHCJFYJACOUNT(DeptFtDr),"^",12)    //Acct_endtime
	
	set lastPFRowID=""
	if $d(^DHCJFYJACOUNT(0,"Flag","YJACOUNT")) {
		set myPFRowID=DeptFtDr
		while($o(^DHCJFYJACOUNT(0,"Flag","YJACOUNT",myPFRowID),-1)&&(lastPFRowID="")) {
			set myPFRowID=$o(^DHCJFYJACOUNT(0,"Flag","YJACOUNT",myPFRowID),-1)
			set ward=$p(^DHCJFYJACOUNT(myPFRowID),"^",14)
			continue:(+ward'=0)
			set myHospDR=$p(^DHCJFYJACOUNT(myPFRowID),"^",16)
			continue:((myHospDR'=HospId)&&(HospId'=""))  //wangjian 2018-10-15
			set lastPFRowID=myPFRowID
		}
	}
	
	set myHSDate=0
	if (+stdate=+enddate) {
		set myHSDate=+enddate
	}elseif((+stdate'=+enddate)&&(endtime=0)){
		set myHSDate=+enddate-1
	}else{
		set myHSDate=+enddate
	}
	
	set DateInfo=stdate_"^"_sttime_"^"_enddate_"^"_endtime_"^"_lastPFRowID_"^"_myHSDate
    set Job=$i(^TMPIPBAcount("YJAcountSub"))
    kill ^TMPIPBAcount(Job)
    set DateInfo=DateInfo_"^"_Job
	set myfootinfo=..BuildACFinData(DateInfo, DateFlag, HospId)
	set myrtn=$p(myfootinfo,$c(3),1)
	set ExpStr="Date"
	//写一次日志写到^TMP
	if (+myrtn=0) {
		set ExpStr=Job
		set myDPFootInfo=$p(myfootinfo,$c(3),2)
		set myfootsaveinfo=..ACFinDataFootSub(DeptFtDr, ExpStr)
		set myrtn=$p(myfootsaveinfo,$c(3),1)
	}
	
	quit myrtn
}

ClassMethod ACFinDataFootSub(DeptFtDr As %String, ExpStr As %String) As %String
{
	set $ZT="ERROR^DHCSSERR"
	new (DeptFtDr, ExpStr)
	set Job=ExpStr
    
    quit:'$d(^DHCJFYJACOUNT(+DeptFtDr)) -1101
    
	set TRef=$p($g(^DHCJFYJACOUNT(+DeptFtDr)),"^",2)       //Acct_jfsum
	set TRef=$fn(TRef,"",2)
    set TAdd=$p($g(^DHCJFYJACOUNT(+DeptFtDr)),"^",3)       //Acct_dfsum
    set TAdd=$fn(TAdd,"",2)
    set TCurB=$p($g(^DHCJFYJACOUNT(+DeptFtDr)),"^",4)      //Acct_curremain
    set TCurB=$fn(TCurB,"",2)
    
    set rtn=0
	set AddSum=0, RefSum=0, CurSum=0

	set adm=0
	while($o(^TMPIPBAcount(Job,adm))&&(rtn=0)) {
		set adm=$o(^TMPIPBAcount(Job,adm))
		set myPreLeftSum=+$g(^TMPIPBAcount(Job,adm,"PLeft"))
		//set myPreLeftSum=+$g(^TMPIPBAcount($j,adm))
		set myDFSum=+$g(^TMPIPBAcount(Job,adm,"Add"))
		set myJFSum=+$g(^TMPIPBAcount(Job,adm,"Reduce"))
		set myCurLeftSum=myPreLeftSum+myDFSum+myJFSum
		set AddSum=AddSum+myDFSum
		set RefSum=RefSum+myJFSum
		set CurSum=CurSum+myCurLeftSum
		continue:((myPreLeftSum=0)&&(myDFSum=0)&&(myJFSum=0))
		set Vistatus=$p(^PAADM(adm),"^",20)
		kill PLIST
		set PLIST(0)=+DeptFtDr
		set PLIST(3)=+adm
		set PLIST(4)=+myDFSum
		set PLIST(5)=+myJFSum
		set PLIST(7)=+myPreLeftSum
		set PLIST(8)=+myCurLeftSum
		set PLIST(17)=Vistatus
		&SQL(INSERT INTO DHC_IPBillDeptAcountDetail VALUES PLIST())
		set rtn=SQLCODE
		quit:(+rtn)
	}
	
	set AddSum=$fn(AddSum,"",2)
	set RefSum=$fn(RefSum,"",2)
	set CurSum=$fn(CurSum,"",2)
    if ($zabs(AddSum)'=$zabs(TAdd))||($zabs(RefSum)'=$zabs(TRef))||($zabs(CurSum)'=$zabs(TCurB)) {
	    b ;判断平衡
	    set rtn=-1102
	}
	
	kill ^TMPIPBAcount(Job)
	
	quit rtn
}

ClassMethod InsertRemain(adduser, flag, job)
{
	s ind=$o(^TMP("ZYJF",flag,job,""),-1)
	s s=^TMP("ZYJF",flag,job,ind)
	s stdate=$zdh($p(s,"^",1),3)
	s sttime=$zth($p(s,"^",2),1)
	s enddate=$zdh($p(s,"^",3),3)
	s endtime=$zth($p(s,"^",4),1)
	s ind=$o(^TMP("ZYJF",flag,job,ind),-1)
	s s=^TMP("ZYJF",flag,job,ind)
	
	s DateFlag=""
	s DateInfo=stdate_"^"_sttime_"^"_enddate_"^"_endtime
	s LastFtDr=$o(^DHCJFYJACOUNT(0,"Flag","YJACOUNT",""),-1)
	s DateInfo=DateInfo_"^"_LastFtDr
	
	s Job=$i(^TMPIPBAcount("YJAcountSub"))
	
	s DateInfo=DateInfo_"^^"_Job
	s myfootinfo=..BuildACFinData(DateInfo, DateFlag)
	s myrtn=$p(myfootinfo,$c(3),1)
	s ExpStr=""
	;写一次日志写到^TMP
	i (+myrtn=0) d
	.s ExpStr=Job
	.s myDPFootInfo=$p(myfootinfo,$c(3),2)
	.s myfootsaveinfo=..ACFinDataFoot(adduser, myDPFootInfo, ExpStr)
	.s myrtn=$p(myfootsaveinfo,$c(3),1)
	
	q myrtn
}

ClassMethod CheckData(stdate As %String, enddate As %String)
{
    s AddSum=0,RefSum=0,RefSum1=0
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	f prtdate=stdate:1:enddate d
	.s jkrowid=0
	.f  s jkrowid=$o(^DHCJFUSERJK(0,"date",prtdate,jkrowid))  q:(jkrowid="")  d
	..s prtrowid=0
	..f  s prtrowid=$o(^DHCSFPRINTDETAIL(0,"JKDR",jkrowid,prtrowid))  q:(prtrowid="")  d
	...s prttime=$p(^DHCSFPRINTDETAIL(prtrowid),"^",3)
	...s prtstatus=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",8),$c(1))
	...q:(+prtstatus=2)
	...s prttypedr=$p(^DHCSFPRINTDETAIL(prtrowid),"^",13)
	...q:(prttypedr="")
	...q:($d(^ARC("ARCDT",prttypedr))=0)
	...s depTypeCode=$p(^ARC("ARCDT",prttypedr),"^",1)
	...q:(depTypeCode'="01")
	...s admwardid=$p(^DHCSFPRINTDETAIL(prtrowid),"^",36)
	...s wardLinkroom=$p($g(^PAWARD(admwardid)),"^",11)
	...q:wardLinkroom=""
    ...s admno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",4)
	...i admwardid=""  d
	...s admwardid=$p(^PAADM(admno),"^",70)
	...s payamount=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",6),$c(1))
	...s AddSum=AddSum+payamount, ^TMP("Test",$j,admwardid)=$g(^TMP("Test",$j,admwardid))+payamount
    ...;i (payamount>0) s AddSum=AddSum+payamount,^TMP("Test",$j,admwardid)=$g(^TMP("Test",$j,admwardid))+payamount
    ...;e  s RefSum=RefSum+payamount,RefSum1=RefSum+payamount
    ..s prtrowid=0
	..;f  s prtrowid=$o(^DHCINVPRTZY(0,"DATE",prtdate,prtrowid)) q:(prtrowid="")  d
	..f  s prtrowid=$o(^DHCINVPRTZY(0,"JK",jkrowid,prtrowid)) q:(prtrowid="")  d
	...s s=^DHCINVPRTZY(prtrowid)
	...s prtstatus=$p(s,"^",8)
	...q:prtstatus="A"
	...s arpbl=+$p(s,"^",5) 
	...s invDepAmt=+$p(s,"^",22) 
	...s RefSum=RefSum-invDepAmt
	...s shdate="", shtime=""
	...s yjstr=$g(^DHCJFDepositRowID("ZYJF",arpbl))
	...i (yjstr'="")  d
	....s yjnum=$length(yjstr,"^")
	....f yjnum1=1:1:yjnum  d
	.....s yjstr1=$p(yjstr,"^",yjnum1)
	.....s arrcp=$p(yjstr1,"||",1)
	.....s arral=$p(yjstr1,"||",2)
	.....;s s=^ARRCP(arrcp,"RAL",arral)
	.....s yjsfrowid=0
	.....f  s yjsfrowid=$o(^DHCSFPRINTDETAIL(0,"RcptDR",arrcp,yjsfrowid))  q:(yjsfrowid="")  d
	......s yjprtstatus=$p(^DHCSFPRINTDETAIL(yjsfrowid),"^",8)
	......q:(yjprtstatus=2)
	......s payamount=$p(^DHCSFPRINTDETAIL(yjsfrowid),"^",6)
	......i prtstatus="S" s payamount=0-payamount
    ......s RefSum1=RefSum-payamount
    
    q AddSum_"^"_RefSum_"^"_RefSum1
}

ClassMethod Test01()
{
    s adm="0"
    f  s adm=$o(^TMPIPBAcount($j,adm))  q:adm=""   d
    .s inv=""
    .s fee=0,invdep=0,paidyj=0
    .f  s inv=$o(^DHCINVPRTZY(0,"ADM",adm,inv))   q:inv=""   d
    ..s flag=$p(^DHCINVPRTZY(inv),"^",8)
    ..q:flag="A"
    ..s jkdate=$p(^DHCINVPRTZY(inv),"^",15)
	..q:(jkdate="")||((jkdate'="")&(jkdate>62456))
    ..s fee=fee+$p(^DHCINVPRTZY(inv),"^",6)
    ..s invdep=invdep+$p(^DHCINVPRTZY(inv),"^",22)
    .s prt=""
    .f  s prt=$o(^DHCSFPRINTDETAIL(0,"adm",adm,prt))   q:prt=""  d
    ..s flag=$p(^DHCSFPRINTDETAIL(prt),"^",8)
    ..q:+flag=2
    ..s jkdate=$p($g(^DHCSFPRINTDETAIL(prt)),"^",21)
    ..;q:(jkdate="")||((jkdate'="")&(jkdate>62795))
    ..s paidflag=$p(^DHCSFPRINTDETAIL(prt),"^",38)
    ..q:paidflag'="Y"
    ..s paidyj=paidyj+$p(^DHCSFPRINTDETAIL(prt),"^",6)
    .i +paidyj'=(+invdep)    w !,adm_"^"_invdep_"^"_paidyj
   
   
    q 0
}

ClassMethod Test05()
{
    s adm=""
    f  s adm=$o(^TMPIPBAcount($j,adm))  q:adm=""   d
    .s amt=+$g(^TMPIPBAcount($j,adm,"PLeft"))
    .s dept=0
    .s prt=""
    .f  s prt=$o(^DHCSFPRINTDETAIL(0,"adm",adm,prt))   q:prt=""  d
    ..s flag=$p(^DHCSFPRINTDETAIL(prt),"^",8)
    ..q:+flag=2
    ..s jkdate=$p($g(^DHCSFPRINTDETAIL(prt)),"^",21)
    ..q:(jkdate="")||((jkdate'="")&(jkdate>62456))
    ..s paidflag=$p(^DHCSFPRINTDETAIL(prt),"^",38)
    ..q:paidflag'="N"
    ..s dept=dept+$p(^DHCSFPRINTDETAIL(prt),"^",6)
    .i +amt'=(+dept)    w !,adm_"^"_dept_"^"_amt
   
    q 0
}

ClassMethod Test03()
{
    s adm=""
    f  s adm=$o(^TMPIPBAcount($j,adm))  q:adm=""   d
    .s inv="" 
    .s prt="",depts=0
    .f  s prt=$o(^DHCSFPRINTDETAIL(0,"adm",adm,prt))   q:prt=""  d
    ..s flag=$p(^DHCSFPRINTDETAIL(prt),"^",8)
    ..q:+flag=2
    ..s amt=$p($g(^DHCSFPRINTDETAIL(prt)),"^",6)
    ..i (flag=1)&(amt<0)   w !,prt
    ..q:flag=1
    ..s depts=depts+amt
    .i depts'=0   w !,prt_"err"_depts
   
   
    q 0
}

ClassMethod Test02()
{
	s rtn=0
	i rtn=0  d
    .s prt=""
	.f  s prt=$o(^DHCSFPRINTDETAIL(0,"PaidFlag","N",prt))   q:(prt="")   d
	..s pdate=$p(^DHCSFPRINTDETAIL(prt),"^",2)
	..s flag=$p(^DHCSFPRINTDETAIL(prt),"^",8)
	..q:+flag=2
    ..;q:pdate>62457
	..s depdr=$p(^DHCSFPRINTDETAIL(prt),"^",13)
	..q:+depdr'=1
	..;s jkdate=$p(^DHCSFPRINTDETAIL(prt),"^",21)
	..;s jkdr=$p(^DHCSFPRINTDETAIL(prt),"^",30)	
	..;q:(+jkdr'=0)&(jkdate>myBDate)
	..;q:((pdate=myBDate)&(ptime>myBTime))
	..;q:(pdate<62256)     ;;;有垃圾数据
 	..s adm=$p(^DHCSFPRINTDETAIL(prt),"^",4)
	..s amt=$p(^DHCSFPRINTDETAIL(prt),"^",6)
	..s inv=0,invdep=0,fee=0
	..f  s inv=$o(^DHCINVPRTZY(0,"ADM",adm,inv))   q:inv=""   d
    ...s flag=$p(^DHCINVPRTZY(inv),"^",8)
    ...q:flag="A"
    ...s fee=fee+$p(^DHCINVPRTZY(inv),"^",6)
    ...;s invfee=invfee+$p(^DHCINVPRTZY(inv),"^",6)
    ...s invdep=invdep+$p(^DHCINVPRTZY(inv),"^",22)
    ..s rcpt="0",paidyj=0
    ..f  s rcpt=$o(^ARRCP("Adm_DR",adm,rcpt))   q:rcpt=""  d
    ...s deptdr=$p(^ARRCP(+rcpt,"RAL",1),"^",9)
    ...q:+deptdr'=1
    ...s arbil=$p(^ARRCP(+rcpt,"RAL",1),"^",18)
    ...s payamt=$p(^ARRCP(+rcpt,"RAL",1),"^",2)
    ...q:+arbil=0
    ...s paidyj=paidyj+payamt
    ..s pb="",paidfee=0
    ..f  s pb=$o(^DHCPB(0,"ADM",adm,pb))  q:pb=""   d
    ...s flag=$p(^DHCPB(pb),"^",16)
    ...q:flag'["P"
    ...s paidfee=paidfee+$p(^DHCPB(pb),"^",12)
    ..i +paidyj'=(+invdep)  w !,adm_"^"_invdep_"^"_paidyj
    ..i +paidfee'=(+fee)  w !,adm_"^"_fee_"^"_paidfee_"^inv"
		
    q 0
}

ClassMethod Test04()
{
	s inv=0
	f  s inv=$o(^DHCINVPRTZY(inv))   q:(inv="")  d
    .s invdep=$p(^DHCINVPRTZY(inv),"^",22)
    .s adm=$p(^DHCINVPRTZY(inv),"^",4)
    .s yjamt=0
    .s arpbl=+$p(^DHCINVPRTZY(inv),"^",5)
    .s yjstr=$g(^DHCJFDepositRowID("ZYJF",arpbl))
	.i yjstr'=""  d
	..s yjnum=$l(yjstr,"^")
	..f yjnum1=1:1:yjnum  d
	...s yjstr1=$p(yjstr,"^",yjnum1)
	...s arrcp=$p(yjstr1,"||",1)
	...s arral=$p(yjstr1,"||",2)
	...s yjsfrowid=""
	...f  s yjsfrowid=$o(^DHCSFPRINTDETAIL(0,"RcptDR",arrcp,yjsfrowid))  q:(yjsfrowid="")  d
	....s payamount=$p(^DHCSFPRINTDETAIL(yjsfrowid),"^",6)
	....s yjprtstatus=$p(^DHCSFPRINTDETAIL(yjsfrowid),"^",8)
	....q:(yjprtstatus=2)
	....s yjamt=yjamt+payamount
    .i $zabs(yjamt)'=$zabs(invdep)   w !,adm_"^"_inv_"^"_yjamt_"^"_invdep
		
    q 0
}

/// 创建预缴金账的明细余额数据
ClassMethod Test06(myBDate, myBTime, myEndDate, myEndTime, flag)
{
	s Job=$i(^TMPIPBAcount("YJAcountSub"))
	k ^TMPIPBAcount(Job)
	s myDFSum=0, myJFSum=0
	i flag="Date"  d
	.f pdate=myBDate:1:myEndDate  d
	..s prt=0
	..f  s prt=$o(^DHCSFPRINTDETAIL(0,"PrtDate",pdate,prt))  q:(prt="")  d
	...s ptime=$p(^DHCSFPRINTDETAIL(prt),"^",3)
	...q:((pdate=myBDate)&&(ptime<myBTime))||((pdate=myEndDate)&&(ptime>myEndTime))
	...s depTypeDR=$p(^DHCSFPRINTDETAIL(prt),"^",13)
	...s depTypeCode=$p(^ARC("ARCDT",depTypeDR),"^",1)
	...q:(depTypeCode'="01")
	...s adm=$p(^DHCSFPRINTDETAIL(prt),"^",4)
	...s flag=$p(^DHCSFPRINTDETAIL(prt),"^",8)
	...q:(+flag=2)
	...s amt=$p(^DHCSFPRINTDETAIL(prt),"^",6)
	...;i (amt>0)  s ^TMPIPBAcount($j,adm,"Add")=$g(^TMPIPBAcount($j,adm,"Add"))+amt,myDFSum=myDFSum+amt
	...;e  s ^TMPIPBAcount($j,adm,"Reduce")=$g(^TMPIPBAcount($j,adm,"Reduce"))+amt,myJFSum=myJFSum+amt
	...s ^TMPIPBAcount(Job,adm,"PLeft")=$g(^TMPIPBAcount(Job,adm,"PLeft"))+amt
	...s myDFSum=myDFSum+amt
	.f pdate=myBDate:1:myEndDate  d
	..s inv=0
	..f  s inv=$o(^DHCINVPRTZY(0,"DATE",pdate,inv))  q:(inv="")  d
	...s ptime=$p(^DHCINVPRTZY(inv),"^",3)
	...q:((pdate=myBDate)&(ptime<myBTime))||((pdate=myEndDate)&&(ptime>myEndTime))
	...s adm=$p(^DHCINVPRTZY(inv),"^",4)
	...s amt=$p(^DHCINVPRTZY(inv),"^",6)
	...s flag=$p(^DHCINVPRTZY(inv),"^",8)
	...s invDepAmt=$p(^DHCINVPRTZY(inv),"^",22)
	...q:(flag="A")
	...s ^TMPIPBAcount(Job,adm,"PLeft")=$g(^TMPIPBAcount(Job,adm,"PLeft"))-invDepAmt
	...s myJFSum=myJFSum-invDepAmt
	e   d
	.f pdate=myBDate:1:myEndDate  d
	..s jkid=0
	..f  s jkid=$o(^DHCJFUSERJK(0,"date",pdate,jkid))  q:(jkid="")  d
	...s jktime=$p(^DHCJFUSERJK(jkid),"^",2)
	...q:((pdate=myBDate)&&(jktime<myBTime))||((pdate=myEndDate)&&(jktime>myEndTime))
	...s prt=0
	...f  s prt=$o(^DHCSFPRINTDETAIL(0,"JKDR",jkid,prt))  q:(prt="")  d
	....;s ptime=$p(^DHCSFPRINTDETAIL(prt),"^",3)
	....s depTypeDR=$p(^DHCSFPRINTDETAIL(prt),"^",13)
	....s depTypeCode=$p(^ARC("ARCDT",depTypeDR),"^",1)
	....q:(depTypeCode'="01")
	....s adm=$p(^DHCSFPRINTDETAIL(prt),"^",4)
	....s flag=$p(^DHCSFPRINTDETAIL(prt),"^",8)
	....q:(+flag=2)
	....s amt=$p(^DHCSFPRINTDETAIL(prt),"^",6)
	....;i (amt>0)  s ^TMPIPBAcount($j,adm,"Add")=$g(^TMPIPBAcount($j,adm,"Add"))+amt,myDFSum=myDFSum+amt
	....;e  s ^TMPIPBAcount($j,adm,"Reduce")=$g(^TMPIPBAcount($j,adm,"Reduce"))+amt,myJFSum=myJFSum+amt
	....s ^TMPIPBAcount(Job,adm,"PLeft")=$g(^TMPIPBAcount(Job,adm,"PLeft"))+amt
	....s myDFSum=myDFSum+amt
	...s inv=""
	...f  s inv=$o(^DHCINVPRTZY(0,"JK",jkid,inv))  q:(inv="")  d
	....;s ptime=$p(^DHCINVPRTZY(inv),"^",3)
	....s adm=$p(^DHCINVPRTZY(inv),"^",4)
	....s amt=$p(^DHCINVPRTZY(inv),"^",6)
	....s flag=$p(^DHCINVPRTZY(inv),"^",8)
	....s invDepAmt=$p(^DHCINVPRTZY(inv),"^",22)
	....q:(flag="A")
	....s ^TMPIPBAcount(Job,adm,"PLeft")=$g(^TMPIPBAcount(Job,adm,"PLeft"))-invDepAmt
	....s myJFSum=myJFSum-invDepAmt

	q Job_"^"_myJFSum_"^"_myDFSum
}

ClassMethod Test07(myBDate, myEndDate, flag)
{
	s err=0
	f Date=myBDate:1:myEndDate  q:(+err'=0)  d
	.s ftdr=0
	.f  s ftdr=$o(^DHCJFYJACOUNT(0,"STDATE",Date,ftdr))  q:(ftdr="")  d
	..s acctflag=$p(^DHCJFYJACOUNT(ftdr),"^",9)
	..q:(acctflag'="YJACOUNT")
	..s err=..InsertYJAcountSub(ftdr,"")
     
	q err
}

ClassMethod Test08()
{
	s stdate=$o(^DHCJFUSERJK(0,"date",""))
	s enddate=$o(^DHCJFUSERJK(0,"date",""),-1)
	f date=stdate:1:enddate   d
	.s fend=$o(^DHCJFYJACOUNT(0,"ENDDATE",""),-1)
	.q:fend>=(+$h-1)	
	.d ##class(web.DHCIPBillDeptAcountDetail).ACFinDataAutoFoot("Date")
    
    q 0
}

}
