Import sqluser

Class web.DHCSTMHUI.DHCPayMon Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTMPAYMON";

/// 批量生成付款月报
/// Author:	Lihui
/// Date:2016-09-06
/// update: 20181207
/// Argu: listParams - 科室rowid^月份^用户rowid^起始日期^截止日期^起始时间^截止时间	
/// Return:0：成功；
/// w ##class(web.DHCSTMHUI.DHCPayMon).CreatePayReports(^tmpli("CreatePayReports"),6444)
ClassMethod CreatePayReports(MainParams As %String, UserId As %String) As %String
{
	n (MainParams,UserId)
	s ^tmpli("CreatePayReports")=MainParams
	s MethodName=$CLASSNAME()_".CreateReports"
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(MainParams)
	i Sc'=0 d
	.d RtnObj.Err(-1,"",MethodName_"入参解析失败!"_MainParams)
	q:RtnObj.success'=0 RtnObj.Json()
	s $ZT=..sssError()
	ts						;增加错误处理
	while(RtnObj.success=0)!(RtnObj.success'=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RtnObj=..CreatePayMon(Obj,UserId)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0  tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 生成付款月报及明细内容
/// Date:2016-09-06
/// Argu:
/// 	loc - 科室rowid
/// 	mon - 月份
/// 	user - 用户rowid
/// 	frDate - 起始日期
/// 	toDate - 截止日期
/// 	frTime - 起始时间
/// 	toTime - 截止时间
/// 	
/// Return:
/// 	>0 :月报主表rowid
/// 	"",<0 :生成错误
/// 	w ##class(web.DHCSTMHUI.DHCPayMon).CreatePayMon(153,"2016-09-01",590,"2016-09-01","2016-09-13")
ClassMethod CreatePayMon(Paramsobj As %String, UserId As %String) As %String
{
	 n (Paramsobj,UserId)
	 s RtnObj=##class(RtnObj).%New()
	 s loc=Paramsobj.%Get("LocId")
	 i ((loc="")||('$d(^CTLOC(loc)))) d RtnObj.Err(-1,"","科室不存在!","",0) q RtnObj
	 s LocDesc=$p(^CTLOC(loc),"^",2)
	 s mon=Paramsobj.%Get("CurMonth")
	 s:mon["-" mon=mon_"-1"
	 s SmId=..CheckPayMonIfExist(loc,mon)  //判断当月月报是否已经生成
	 i +SmId>0 d RtnObj.Err(-2,"",LocDesc_"月报已经存在，不能生成该月的月报!","",0) q RtnObj
	 s CurStartDate=Paramsobj.%Get("CurStartDate")
	 s CurEndDate=Paramsobj.%Get("CurEndDate")
	 i ((CurStartDate="")||(CurEndDate="")) d RtnObj.Err(-5,"",LocDesc_"开始日期或者截止日期为空!","",0) q RtnObj
	 s RtnObj=..Update("",Paramsobj,UserId)
	 i RtnObj.success'=0 q RtnObj   
	 s pm=RtnObj.rowid
	 s Ret=##class(web.DHCSTMHUI.DHCPayMonDetail).CreatePayMonDetail(pm)
	 ;i Ret=-2 d RtnObj.Err(-3,"",LocDesc_mon_"月份没有对应的付款信息!") q RtnObj
	 i Ret'=0 d RtnObj.Err(-3,"",LocDesc_mon_"月份的付款月报生成明细失败!") q RtnObj
	 s Ret=##class(web.DHCSTMHUI.DHCPayMonDetail).CreatePayMonLBDetail(pm)
	 i +Ret'=0 d RtnObj.Err(-4,"",LocDesc_mon_"月份的付款月报生成明细失败!") q RtnObj
	  
	 q RtnObj
}

/// 检查某科室某月份付款月报是否已经生成
/// Date:2016-09-06
/// Argu:
///  LocId -科室rowid
///  CurMonth-当前月份
/// Return :
///  >0(月报id)：月报已经生成;0:未生成
ClassMethod CheckPayMonIfExist(LocId, CurMonth) As %String
{
	 n (LocId,CurMonth)
	 q:LocId="" 0
	 q:CurMonth="" 0
	 s Flag=0
	 s CurMonth=$zdh(CurMonth,3)
	 s Rowid=$o(^DHCPAYM(0,"MLOC",CurMonth,LocId,""))
	 q Rowid
}

/// 插入或更新月报一条主表记录
/// Date:2016-09-06
/// update 20181207
/// Argu: 
/// 	sm  - 付款月报主表rowid
/// 	Paramsobj -付款月报主表信息对象
ClassMethod Update(sm As %String, Paramsobj As %String, UserId As %String) As %String
{
  n (sm,Paramsobj,UserId)
  s RtnObj=##class(RtnObj).%New()
  s loc=Paramsobj.%Get("LocId")  //科室rowid(必需)
  s mon=Paramsobj.%Get("CurMonth")  //月份
  s:mon["-" mon=mon_"-1"
  s frDate=Paramsobj.%Get("CurStartDate")  //起始日期
  s toDate=Paramsobj.%Get("CurEndDate") //截止日期

  i ((loc="")||(mon="")) d RtnObj.Err(-2,"","科室或者当前月份为空!","",0) q RtnObj
  s LocDesc=$p(^CTLOC(loc),"^",2)
  s mon=..DH2L(mon)

  s frDate=..DH2L(frDate)
  s toDate=..DH2L(toDate)
  i ((+frDate'>0)||(+toDate'>0)) d RtnObj.Err(-3,"",LocDesc_"起止日期有误!","",0) q RtnObj
  
  s err=0
  i sm="" d
  .s obj=##class(User.DHCPayMon).%New()
  e  d
  .s obj=##class(User.DHCPayMon).%OpenId(sm)
  .i $ISOBJECT(obj)  d obj.%Reload()
  i '$ISOBJECT(obj) d RtnObj.Err(-4,"","更新月报 "_sm_" 有误") q RtnObj
  s (LastRpAmt,ArrearRpAmt,PayedRpAmt,EndRpAmt)=0
  f date=frDate:1:toDate  d
  .s payid=""
  .f  s payid=$o(^DHCPAY(0,"D",date,payid)) q:payid=""  d
  ..s ch=""
  ..s payloc=$p(^DHCPAY(payid),"^",3)
  ..q:payloc'=loc
  ..s ack2=$p(^DHCPAY(payid),"^",9)
  ..q:ack2'="Y"
  ..f  s ch=$o(^DHCPAY(payid,"I",ch)) q:ch=""  d
  ...s payinfo=^DHCPAY(payid,"I",ch)
  ...s inci=$p(payinfo,"^",1)
  ...s stkgrpinfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
  ...s grptype=$p(stkgrpinfo,"^",3)
  ...q:grptype'=..sssCode()
  ...s PayedAmt=$p(payinfo,"^",5) ;付款金额
  ...s RecAmt=$p(payinfo,"^",3) ;入库或者退货金额
  ...s PayedRpAmt=PayedRpAmt+PayedAmt
  ...s ArrearRpAmt=ArrearRpAmt+RecAmt
  s LastRpAmt=..LastUnpayAmt(loc)
  s EndRpAmt=LastRpAmt+ArrearRpAmt-PayedRpAmt
  s obj.PMCreateDate= +$h
  s obj.PMCreateTime=$p($h,",",2)
  s obj.PMSSUSRDR=##class(User.SSUser).%OpenId(UserId)
  s obj.PMCTLOCDR=##class(User.CTLoc).%OpenId(loc)
  s obj.PMDateFrom=frDate
  s obj.PMDateTo=toDate
  s obj.PMMonthDate=mon
  s obj.PMLastRpAmt=LastRpAmt
  s obj.PMArrearRpAmt=ArrearRpAmt
  s obj.PMPayedRpAmt=PayedRpAmt
  s obj.PMEndRpAmt=EndRpAmt
  s ret=obj.%Save()
  i $$$ISERR(ret) d
  .s ret=$tr($System.Status.GetErrorText(ret),$c(13,10,0,9))
  .d RtnObj.Err(-5,"","处理月报主信息有误"_ret)
  q:RtnObj.success'=0 RtnObj
  s RtnObj.rowid=obj.%Id()
  q RtnObj
}

/// 上期结余未付款金额
/// w ##class(web.DHCSTMHUI.DHCPayMon).LastUnpayAmt("2016-09-06",153)
ClassMethod LastUnpayAmt(loc As %String) As %String
{
   n (loc)
   q:loc="" 0
   s lastPMid=""
   &sql(SELECT TOP 1 PM_Rowid into lastPMid FROM DHC_PayMon WHERE PM_CTLOC_DR=:loc ORDER BY PM_Rowid DESC)
   s LastUpayAmt=0
   s:lastPMid'="" LastUpayAmt=$p(^DHCPAYM(lastPMid),"^",10)
   q LastUpayAmt
}

/// 检查付款科室某断时间内完成未确认的付款单
/// Author:	Lihui
/// Date:	2016-09-08
/// Argu:	LocId^StartDate(Y-m-d)^EndDate(Y-m-d)
/// Return:	0:ok; -3:有完成但未采购确认的付款单据; 其他:错误
/// w ##class(web.DHCSTMHUI.DHCPayMon).CheckPayMonCond("153^2016-09-05")
ClassMethod CheckPayMonCond(StrParam As %String) As %String
{
	n (StrParam)
	;s ^tmpli("CheckPayMonCond")=StrParam
	s LocId=$p(StrParam,"^",1)
	s EndDate=$p(StrParam,"^",2)
	q:LocId="" -1
	q:EndDate="" -2
	s EndDate=$zdh(EndDate,3)

	s Ret=0
	s PayDate="",Paycomflag="Y",PayAck1Date=""
	&sql(SELECT min(PAY_Date) into :PayDate FROM DHC_Pay WHERE PAY_CTLOC_DR=:LocId 
	     AND PAY_Completed=:Paycomflag AND (PAY_Date_Ack2 Is null))
	i (+PayDate'=0)&&(PayDate<=EndDate) s Ret=-3
	q:Ret<0 Ret
	
	q Ret
}

/// 取安全组下科室及其付款月报存在的情况(json)
/// Date:	2016-09-08
/// Return:
///  安全组-库存科室数据串(json)
Query jsGrpLocForPayMon(gGroupId As %String, LocDesc As %String = "", Params As %String = "") As Query(ROWSPEC = "LocId,LocDesc,lastPayMonRowid,lastMonth,lastFrDate,lastToDate,CurMonth,CurStartDate,CurEndDate")
{
}

ClassMethod jsGrpLocForPayMonExecute(ByRef qHandle As %Binary, gGroupId As %String, LocDesc As %String = "", Params As %String = "") As %Status
{
    n (qHandle,gGroupId,LocDesc,Params,%session)
    s repid=$I(^CacheTemp)
    s ind=1
    s qHandle=$lb(0,repid,0)
    
    s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJObj.%Get("BDPHospital") ;选择的医院ID
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
    
    s sqlStr="Select st_ctloc_dr AS RowId,st_ctloc_dr->ctloc_desc  AS Description from ss_groupstocklocations where st_parref="_gGroupId
    i LocDesc'="" d
    .s LocDesc=$$ALPHAUP^SSUTIL4(LocDesc)
    .s sqlStr = sqlStr_" and %ALPHAUP(st_ctloc_dr->ctloc_desc) %STARTSWITH "_"'"_LocDesc_"'"
    
    s result=##class(%ResultSet).%New()
    d result.RuntimeModeSet(0)
    d result.Prepare(sqlStr)
    s sc=result.Execute()
    i $$$ISERR(sc) q $$$OK
 	While(result.Next())
 	{
	 	//检索每一个科室的上期(最后)月报情况 Start
	  	s (lastPayMonRowid,lastMonth,lastFrDate,lastFrTime,lastToDate,lastToTime)=""
	  	s (CurMonth,CurStartDate,CurStartTime,CurEndDate,CurEndTime)=""
	  	s CurEndDate=+$h-1
	  	s CurMonth=$p($zd(CurEndDate,3),"-",1,2)
	  	s LocId=result.Data("RowId")
	  	continue:(##class(web.DHCSTMHUI.CTLOC).LocOfHosp(LocId,pHospId)'=0)
	  	s LocDesc=result.Data("Description")
	  	s finalMonth=""
	  	&sql(SELECT max(PM_MonthDate) into finalMonth FROM DHC_PayMon WHERE PM_CTLOC_DR=:LocId)
	  	i finalMonth'="" d
	  	.&sql(SELECT %id, PM_MonthDate, PM_DateFrom, PM_DateTo 
		   into :lastPayMonRowid,:lastMonth,:lastFrDate,:lastToDate
		   FROM DHC_PayMon WHERE PM_CTLOC_DR=:LocId AND PM_MonthDate=:finalMonth)
	  	.s CurStartDate=lastToDate+1
	  	.s lastMonth=$zd(lastMonth,3)
	  	.s lastMonth=$p(lastMonth,"-",1,2)
	  	.s lastFrDate=..DL2H(lastFrDate)
	  	.s lastToDate=..DL2H(lastToDate)
	  	s CurStartDate=..DL2H(CurStartDate)
	  	s CurEndDate=..DL2H(CurEndDate)
	  	d OutPutPayMonRow
	}
 	Quit $$$OK

OutPutPayMonRow
	s Data=$lb(LocId,LocDesc,lastPayMonRowid,lastMonth,lastFrDate,lastToDate,CurMonth,CurStartDate,CurEndDate)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 月报主记录列表
/// Date:	2016-09-08
/// Argu:
/// loc -科室rowid
/// StartDate  -起始日期
/// EndDate - 截止日期
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCPayMon","DHCPayMon",2,"","")
Query DHCPayMon(loc As %String, StartDate As %String = "", EndDate As %String = "") As Query(ROWSPEC = "pmRowid,MonthDate,frDate,toDate,createDate,createTime,user,userName,loc,locDesc,LastRpAmt:%Float,ArrearRpAmt:%Float,PayedRpAmt:%Float,EndRpAmt:%Float")
{
}

ClassMethod DHCPayMonExecute(ByRef qHandle As %Binary, loc As %String, StartDate As %String = "", EndDate As %String = "") As %Status
{
 n (qHandle,loc,StartDate,EndDate)
 ;s ^tmpli("DHCPayMon")=$lb(loc,StartDate,EndDate)
 i loc="" q $$$OK
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 ;
 s StartDate=$G(StartDate),EndDate=$G(EndDate)
 s StartDate=..DH2L(StartDate)
 s EndDate=..DH2L(EndDate)
 ;
 s sql="select PM_Rowid pmRowid,"
 s sql=sql_"PM_MonthDate MonthDate,"
 s sql=sql_"PM_DateFrom frDate,"
 s sql=sql_"PM_DateTo toDate,"
 s sql=sql_"PM_SSUSR_DR userRowid,"
 s sql=sql_"PM_SSUSR_DR->SSUSR_Name userName,"
 s sql=sql_"PM_CreateDate createDate,"
 s sql=sql_"PM_CreateTime createTime,"
 s sql=sql_"PM_CTLOC_DR loc,"
 s sql=sql_"PM_CTLOC_DR->CTLOC_Desc locDesc,"
 s sql=sql_"PM_LastRpAmt LastRpAmt,"
 s sql=sql_"PM_ArrearRpAmt ArrearRpAmt,"
 s sql=sql_"PM_PayedRpAmt PayedRpAmt,"
 s sql=sql_"PM_EndRpAmt EndRpAmt"
 s sql=sql_" from DHC_PayMon"
 s sql=sql_" where PM_CTLOC_DR="_loc
 i StartDate'="",EndDate'="" d
 .s sql=sql_" and PM_MonthDate between "_StartDate_" and "_EndDate
 s sql=sql_" order by PM_MonthDate DESC"
 s xrs=##class(%Library.ResultSet).%New()
 d xrs.RuntimeModeSet(0)
 d xrs.Prepare(sql)
 s ret=xrs.Execute()
 i $$$ISERR(ret) q $$$OK
 while (xrs.Next()) 
 {
  s pmRowid=xrs.Data("pmRowid")
  s MonthDate=xrs.Data("MonthDate")
  s frDate=xrs.Data("frDate")
  s toDate=xrs.Data("toDate")
  s createDate=xrs.Data("createDate")
  s createTime=xrs.Data("createTime")
  s user=xrs.Data("userRowid")
  s userName=xrs.Data("userName")
  s loc=xrs.Data("loc")
  s locDesc =xrs.Data("locDesc")
  s locDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(locDesc) 	 
  s MonthDate=$e($zd(MonthDate,3),1,7)
  s frDate=..DL2H(frDate)
  s toDate=..DL2H(toDate)
  s createDate=..DL2H(createDate)
  s createTime=..TL2H(createTime)
  s LastRpAmt=xrs.Data("LastRpAmt")
  s ArrearRpAmt=xrs.Data("ArrearRpAmt")
  s PayedRpAmt=xrs.Data("PayedRpAmt")
  s EndRpAmt=xrs.Data("EndRpAmt")
  d OutPutRow
 } 

 Quit $$$OK

OutPutRow
 s Data=$lb(pmRowid,MonthDate,frDate,toDate,createDate,createTime,user,userName,loc,locDesc,LastRpAmt,ArrearRpAmt,PayedRpAmt,EndRpAmt)
 //w Data,!   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// 删除月报记录
/// Date:	2016-09-08
/// Argu:
///  pm - 月报主表rowid
/// Return
/// 0 - 可以
/// <0 - 不可以
ClassMethod Delete(pm As %String) As %String
{
  s appName=..%GetParameter("AppName")
  s RtnObj=##class(RtnObj).%New()
  i pm="" d RtnObj.Err(-1,"","付款月报记录不存在!","",0) q RtnObj.Json()
  //判断是否允许删除
  i ##class(web.DHCSTMHUI.Common.AppCommon).Lock(appName_pm)<0 d RtnObj.Err(-2,"","加锁失败!") q RtnObj.Json()
  i ..AllowDel(pm)<0 d ..uLock(pm) d RtnObj.Err(-2,"","非最后一期月报,不允许删除!","",0) q RtnObj.Json()
  //
  s err=0
  tstart
  //删除DHC_PayMon
  &sql(delete from DHC_PayMon where PM_Rowid=:pm)
  i SQLCODE<0  d 
  .d ..uLock(pm) 
  .trollback
  .d RtnObj.Err(-3,"","删除失败!")
  i RtnObj.success'=0  q RtnObj.Json()
  tcommit
  d ..uLock(pm) 
  q RtnObj.Json()
}

/// 是否允许删除
/// Date:	2016-09-08
/// Argu:
///  pm - 月报主表rowid
/// Return
/// 0 - 可以
/// <0 - 不可以
ClassMethod AllowDel(pm As %String) As %String
{
 n (pm)
 s obj=##class(User.DHCPayMon).%OpenId(pm)
 d obj.%Reload()
 s loc=obj.PMCTLOCDR.%Id()
 s nextPayMon=$O(^DHCPAYM(0,"Loc",loc,pm))
 i nextPayMon'="" q -1  //该月报并非本科室最后一期付款月报
 q 0
}

/// 对付款月报主表记录解锁
/// Date:	2016-09-08
/// Argu:
///  pm - 付款月报主表rowid
ClassMethod uLock(pm As %String) As %String
{
 q:pm=""
 d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(..%GetParameter("AppName")_pm)
 q
}

/// 取付款月报主表记录的数据信息串
/// Date:	2016-09-08
/// Argu:
///  ret - 月报主表rowid
/// Return：
///  返回记录数据串
/// w ##class(web.DHCSTMHUI.DHCPayMon).GetPayMonMain(85)
ClassMethod GetPayMonMain(RowId As %String) As %String
{
 q:RowId="" ""
 ;s ^tmpli("GetPayMonMain")=RowId
 s paymoninfo=^DHCPAYM(RowId)
 b ;
 s result=""
 s (month,LocDesc,fromdate,todate,createdate,createUsername,createTime)=""
 s mon=$p($g(paymoninfo),"^",2)
 s:mon'="" month=$e($zd(mon,3),1,7)
 s Locid=$p($g(paymoninfo),"^",1)
 s:Locid'="" LocDesc=$p(^CTLOC(Locid),"^",2)
 s fd=$p($g(paymoninfo),"^",5)
 s:fd'="" fromdate=..DL2H(fd)
 s td=$p($g(paymoninfo),"^",6)
 s:td'="" todate=..DL2H(td)
 s cd=$p($g(paymoninfo),"^",3)
 s:cd'="" createdate=..DL2H(cd)
 s createUser=$p($g(paymoninfo),"^",7)
 s:createUser'="" createUsername=$p(^SSU("SSUSR",createUser),"^",2)
 s ct=$p($g(paymoninfo),"^",4)
 s:ct'="" createTime=..TL2H(ct)
 s LastRpAmt=$p($g(paymoninfo),"^",13)
 s ArrearRpAmt=$p($g(paymoninfo),"^",19)
 s PayedRpAmt=$p($g(paymoninfo),"^",16)
 s EndRpAmt=$p($g(paymoninfo),"^",10)

 s result=result_"^"_month_"^"_Locid_"^"_LocDesc_"^"_fromdate_"^"_todate_"^"_createdate_"^"_createUsername_"^"_createTime_"^"_LastRpAmt_"^"_ArrearRpAmt_"^"_PayedRpAmt_"^"_EndRpAmt
 q result
}

/// 月报主记录列表
/// Date:	2016-09-08
/// Argu:
/// loc -科室rowid
/// StartDate  -起始日期
/// EndDate - 截止日期
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCPayMon","GetPayMonMain",2)
Query GetPayMonMain(pm As %String) As Query(ROWSPEC = "pmRowid,MonthDate,frDate,toDate,createDate,createTime,user,userName,loc,locDesc,LastRpAmt:%Float,ArrearRpAmt:%Float,PayedRpAmt:%Float,EndRpAmt:%Float") [ SqlProc ]
{
}

ClassMethod GetPayMonMainExecute(ByRef qHandle As %Binary, pm As %String) As %Status
{
 n (qHandle,pm)
 s ^tmpli("GetPayMonMain")=pm
 i pm="" q $$$OK
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)

 ;
 s sql="select PM_Rowid pmRowid,"
 s sql=sql_"PM_MonthDate MonthDate,"
 s sql=sql_"PM_DateFrom frDate,"
 s sql=sql_"PM_DateTo toDate,"
 s sql=sql_"PM_SSUSR_DR userRowid,"
 s sql=sql_"PM_SSUSR_DR->SSUSR_Name userName,"
 s sql=sql_"PM_CreateDate createDate,"
 s sql=sql_"PM_CreateTime createTime,"
 s sql=sql_"PM_CTLOC_DR loc,"
 s sql=sql_"PM_CTLOC_DR->CTLOC_Desc locDesc,"
 s sql=sql_"PM_LastRpAmt LastRpAmt,"
 s sql=sql_"PM_ArrearRpAmt ArrearRpAmt,"
 s sql=sql_"PM_PayedRpAmt PayedRpAmt,"
 s sql=sql_"PM_EndRpAmt EndRpAmt"
 s sql=sql_" from DHC_PayMon"
 s sql=sql_" where PM_Rowid="_pm
 s xrs=##class(%Library.ResultSet).%New()
 d xrs.RuntimeModeSet(0)
 d xrs.Prepare(sql)
 s ret=xrs.Execute()
 i $$$ISERR(ret) q $$$OK
 while (xrs.Next()) 
 {
  s pmRowid=xrs.Data("pmRowid")
  s MonthDate=xrs.Data("MonthDate")
  s frDate=xrs.Data("frDate")
  s toDate=xrs.Data("toDate")
  s createDate=xrs.Data("createDate")
  s createTime=xrs.Data("createTime")
  s user=xrs.Data("userRowid")
  s userName=xrs.Data("userName")
  s loc=xrs.Data("loc")
  s locDesc =xrs.Data("locDesc")
  s locDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(locDesc) 	 
  s MonthDate=$e($zd(MonthDate,3),1,7)
  s frDate=..DL2H(frDate)
  s toDate=..DL2H(toDate)
  s createDate=..DL2H(createDate)
  s createTime=..TL2H(createTime)
  s LastRpAmt=xrs.Data("LastRpAmt")
  s ArrearRpAmt=xrs.Data("ArrearRpAmt")
  s PayedRpAmt=xrs.Data("PayedRpAmt")
  s EndRpAmt=xrs.Data("EndRpAmt")
  d OutPutRowMain
 } 

 Quit $$$OK

OutPutRowMain
 s Data=$lb(pmRowid,MonthDate,frDate,toDate,createDate,createTime,user,userName,loc,locDesc,LastRpAmt,ArrearRpAmt,PayedRpAmt,EndRpAmt)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

}
