Import sqluser

Class web.DHCST.DHCStkMon Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTKMONREP";

Parameter TransTypeStr [ Final ] = "G^R^T^K^A^C^D^F^H^P^Y^S^Z^M^X^HC";

/// 生成月报及明细内容
/// Author:zhwh
/// Date:2012-10-31
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
/// 	w ##class(web.DHCST.DHCStkMon).CreateStkMon(102,"2017-08-01",590,"2017-08-02","2017-08-02","00:00:00","23:59:59")
ClassMethod CreateStkMon(loc As %String, mon As %String, user As %String, frDate As %String, toDate As %String, frTime As %String, toTime As %String) As %String
{
	//生成月报主表
	s data=loc_"^"_mon_"^"_frDate_"^"_frTime_"^"_toDate_"^"_toTime_"^"_user
	s Flag=0
	//判断当月月报是否已经生成
	s SmId=..CheckIfExist(loc,mon)
	//月报已经存在，不能生成该月月报  
	q:+SmId>0 -12   
	s sm=..Update("",data)
	i sm'>0  q -1      
	&sql(insert DHC_StkMon_VoucherStatus(VCH_SM_DR,VCH_SSUSR_DR,VCH_Status)values (:sm,:user,"D"))
	// 生成月报明细
	s err=##class(web.DHCST.DHCStkMonReport).CreateRepDetail(sm)
	//如果明细生成失败则主表也应该删除！
	i err'=0 d
	.d ..Delete(sm)
	i err'=0  q err    
	q sm
}

/// 插入或更新月报一条主表记录
/// Author:zhwh
/// Date:2012-10-31
/// Argu: 
/// 	sm  - 月报主表rowid
/// 	data -月报主表信息字符串("^"分隔)
/// Return:
/// 
ClassMethod Update(sm As %String, data As %String) As %String
{
	s loc=$p(data,"^",1)  //科室rowid(必需)
	s mon=$p(data,"^",2)  //月份字符串(必需,YYYY-MM-DD,DD/MM/YYYY)
	s frDate=$p(data,"^",3)  //起始日期
	s frTime=$p(data,"^",4) //起始时间
	s toDate=$p(data,"^",5) //截止日期
	s toTime=$p(data,"^",6) //截止时间
	s user=$p(data,"^",7) //月报生成者  
	i loc="" q -1
	i mon="" q -2
	s mon=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(mon)
	i mon'>0  q -2
	s frDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(frDate)
	s toDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(toDate)

	q:+frDate'>0 -3
	q:+toDate'>0 -4

	i frTime="" s frTime="00:00:00"
	i toTime="" s toTime="23:59:59"
	i frTime[":" s frTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(frTime)
	i toTime[":" s toTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(toTime)
	s $ZT="Error^DHCSTERROR"						;增加错误处理
	i sm="" d
	.s obj=##class(User.DHCStkMon).%New()	
	.s AppName=..#AppName
	.s ret=##class(web.DHCST.Common.AppCommon).Lock(AppName)
	.i ret'=0  s err=-11 q ;加锁失败
	.s MonNo=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,"",loc) ;StkGrpId不再传入
	.i MonNo="" d ##class(web.DHCST.Common.AppCommon).UnLock(AppName)
	.i MonNo=""  s err=-12 q  ;加锁失败  ;生成单号失败
	.s obj.DHCSMStkMonNo=MonNo
	e  d
	.s obj=##class(User.DHCStkMon).%OpenId(sm)
	.i $ISOBJECT(obj)  d obj.%Reload()

	i '$ISOBJECT(obj) q -9
	s err=0
	s obj.DHCSMCreatedDate= +$h
	s obj.DHCSMCreatedTime=$p($h,",",2)
	s obj.DHCSMCreatedUserDR=##class(User.SSUser).%OpenId(user,0)
	s obj.DHCSMCTLOCDR=##class(User.CTLoc).%OpenId(loc,0)
	s obj.DHCSMFromDate=frDate
	s obj.DHCSMFromTime=frTime
	s obj.DHCSMToDate=toDate
	s obj.DHCSMToTime=toTime
	s obj.DHCSMMonth=mon
	s obj.DHCSMAcctVoucherStatus="P"
	s obj.DHCSMStkType=..sssCode()
	s ret=obj.%Save()
	i $$$ISERR(ret) d
	.s err=-10
	.w $SYSTEM.Status.DisplayError(ret)
	q:err<0 err
	q obj.%Id()
}

/// 删除月报记录
/// Author:zhwh
/// Date:2012-10-31
/// Argu:
///  sm - 月报主表rowid
/// Return
/// 0 - 可以
/// <0 - 不可以
ClassMethod Delete(sm As %String) As %String
{
	n (sm)
	s appName=..%GetParameter("AppName")
	q:sm="" 0
	//判断是否允许删除
	q:##class(web.DHCST.Common.AppCommon).Lock(appName_sm)<0 -99
	i ..AllowDel(sm)<0 d ..uLock(sm) q -1
	//
	s err=0
	tstart
	//删除DHC_StkMonStat
	&sql(delete from dhc_stkmonstat where smrd_smr_dr->smr_sm_parref=:sm)
	i SQLCODE<0  d 
	. d ..uLock(sm) 
	. trollback
	. s err=-2
	i err<0 q err
	//删除DHC_StkMonStatIn
	&sql(delete from dhc_stkmonstatIn where smrdi_smr_dr->smr_sm_parref=:sm)
	i SQLCODE<0  d 
	. d ..uLock(sm) 
	. trollback
	. s err=-3
	i err<0 q err
	//删除DHC_StkMon,DHC_StkMonReport
	&sql(delete from dhc_stkmon where %id=:sm)
	i SQLCODE'=0  d 
	. d ..uLock(sm) 
	. trollback
	. s err=-4
	i err<0 q err
	//删除DHC_StkMon_VoucherStatus-- 月报凭证状态记录表
	&sql(delete from DHC_StkMon_VoucherStatus where VCH_SM_DR=:sm)
	i SQLCODE'=0  d 
	. d ..uLock(sm) 
	. trollback
	. s err=-5
	i err<0 q err
	tcommit
	d ..uLock(sm) 
	q 0
}

/// 是否允许删除
/// Author:zhwh
/// Date:2012-10-31
/// Argu:
///  sm - 月报主表rowid
/// Return
/// 0 - 可以
/// <0 - 不可以
ClassMethod AllowDel(sm As %String) As %String
{
	n (sm)
	s obj=##class(User.DHCStkMon).%OpenId(sm,0)
	d obj.%Reload()
	s loc=obj.DHCSMCTLOCDR.%Id()
	s lastStkMonRep=$O(^DHCSM(0,"CTLOC",loc,sm))
	i lastStkMonRep'="" q -1  //该月报并非本科室最后一期月报
	q 0
}

/// 获取月报的主信息
/// Author:zhwh
/// Date:2012-10-31
/// Argu:
///  sm - 月报主表rowid
/// Return:
///  月报主信息串("^"分隔)
ClassMethod Select(sm As %String) As %String
{
	k PLIST
	s result=""
	&sql(select * into :PLIST() from DHC_StkMon where %ID=:sm )
	q:SQLCODE'=0 result
	s cnt=$o(PLIST(""),-1)
	f i=1:1:cnt d
	.i result=""  s result=$g(PLIST(i))
	.e  s result=result_"^"_$g(PLIST(i))
	.
	q result
}

/// 批量生成月报
/// Author:zhangdongmei
/// Date:2013-03-26
/// Argu:
/// 	listParams - 科室rowid^月份^用户rowid^起始日期^截止日期^起始时间^截止时间
/// 	
/// Return:0:成功:
/// w ##class(web.DHCST.DHCStkMon).CreateReports("102^2016-10-01^590^2016-01-01^2016-01-31^00:00:01^23:59:59")
ClassMethod CreateReports(listParams As %String) As %String
{
	n (listParams)
	//s ^yunhaibao($zn,"CreateReports")=listParams
	q:listParams="" -110
	s RowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	s len=$l(listParams,RowDelim)
	s Err=""
	f i=1:1:len d
	.s Data=$p(listParams,RowDelim,i)
	.q:Data=""
	.s Loc=$p(Data,"^",1)
	.s Mon=$p(Data,"^",2)
	.s User=$p(Data,"^",3)
	.s FrDate=$p(Data,"^",4)
	.s ToDate=$p(Data,"^",5)
	.s FrTime=$p(Data,"^",6)
	.s ToTime=$p(Data,"^",7)
	.s ret=..CreateStkMon(Loc,Mon,User,FrDate,ToDate,FrTime,ToTime)
	.i (+ret<0)||(ret["ERROR")  d
	..s LocDesc=$p(^CTLOC(Loc),"^",2)
	..i Err=""  d
	...s Err=LocDesc_":"_ret
	..e  d
	...s Err=Err_","_LocDesc_":"_ret
	..
	.
	q:Err'="" -111_","_Err
	q 0
}

/// 对月报主表记录解锁
/// Author:zhwh
/// Date:2012-10-31
/// Argu:
///  sm - 月报主表rowid
ClassMethod uLock(sm As %String) As %String
{
	q:sm=""
	d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_sm)
	q
}

/// 取某科室库存项目上期月报的结余数量、金额
/// Date:2012-10-31
/// Argu:
///  mrowid - 月报主表rowid
///  mon - 月份
///  incil - 科室库存rowid(INC_ItmLoc)
/// Return:
///  结余库存数量^结余库存金额(售价)^结余库存金额(进价)
ClassMethod GetLast(mrowid As %String, mon As %String, incil As %String) As %String
{
	n (mrowid,mon,incil)
	q:mrowid="" ""
	q:mon="" ""
	q:incil="" ""
	s ch=""
	s qty=0,amount=0,costamount=0
	s ch=$o(^DHCSM(0,"INCILMon",incil,mon,mrowid,ch)) 
	i ch'="" d
	.s qty=+$p(^DHCSM(mrowid,"R",ch),"^",6)  ;qty
	.s amount=+$p(^DHCSM(mrowid,"R",ch),"^",7)    ;amount
	.s costamount=+$p(^DHCSM(mrowid,"R",ch),"^",8)  ;cost amount
	q $g(qty)_"^"_$g(amount)_"^"_$g(costamount)
}

/// 取上期月份
/// Date:2012-10-31
/// Argu:
/// mon - 月份
/// Return:
///  上期月份
ClassMethod LastMon(mon As %String) As %String
{
	s mon=$zd(mon,3)
	s y=$e(mon,1,4)
	s m=$e(mon,6,7)
	s d=$e(mon,9,10)
	i +d<10 s d="0"_+d      
	i +m=1 d 
	.s y=y-1,mm="12"
	i +m>1 s mm=+m-1 
	i +mm<10 s mm="0"_+mm
	q $zdh(y_"-"_mm_"-"_d,3)
}

/// 月报主记录列表串(json)
/// Author:zhangdongmei
/// Date:2012-11-21
/// Argu:
/// LocStr -科室rowid串(^)
/// StartDate  -起始日期
/// EndDate - 截止日期
/// Return:
///  主记录字符串(json)
ClassMethod jsDHCStkMon(LocStr As %String, StartDate As %String = "", EndDate As %String = "") As %String
{
	q:LocStr="" ""
	s result=##class(%ResultSet).%New("web.DHCST.DHCStkMon:DHCStkMon")
	s Len=$l(LocStr,"^")
	s count = 0
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	f num=1:1:Len   d
	.s LocId=$p(LocStr,"^",num)
	.s sc=result.Execute(LocId,StartDate,EndDate)
	.q:$$$ISERR(sc)
	.i num=1  d  
	..s colNum=result.GetColumnCount()
	..s colNameStr=""
	..f i=1:1:colNum d
	...i colNameStr="" s colNameStr=result.GetColumnName(i)
	...e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	..
	.d OutPut
	.
	d result.Close()
	s resultString = json.getJsonData(colNameStr,count)
	k json
	Q resultString
 
OutPut
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.%GetData(i)
		.e   s ret=ret_"^"_result.%GetData(i)
		.
		s tmp=ret
		s count = count+1
		d json.InsertRowData(tmp)
	}
}

/// 月报主记录列表串(json)
/// Author:zhwh
/// Date:2012-11-02
/// Argu:
/// 		loc -科室rowid
/// 		StartDate  -起始日期
/// 	EndDate - 截止日期
/// Return:
///  主记录字符串(json)
ClassMethod jsDHCStkMonLoc(loc As %String, StartDate As %String = "", EndDate As %String = "") As %String
{
	q:loc="" ""
	s result=##class(%ResultSet).%New("web.DHCST.DHCStkMon:DHCStkMon")
	s sc=result.Execute(loc,StartDate,EndDate)
	i $$$ISERR(sc)  q ""
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)

	s count = 0
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.%GetData(i)
		.e   s ret=ret_"^"_result.%GetData(i)
		.
		s tmp=ret
		s count = count+1
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData(colNameStr,count)
	k json
	Q resultString
}

/// 月报主记录列表
/// Author:zhwh
/// Date:2012-11-02
/// Argu:
/// loc -科室rowid
/// StartDate  -起始日期
/// EndDate - 截止日期
Query DHCStkMon(loc As %String, StartDate As %String = "", EndDate As %String = "") As websys.Query(ROWSPEC = "smRowid:%String,mon:%String,frDate:%String,toDate:%String,frTime:%String,toTime:%String,createDate:%String,createTime:%String,user:%String,userName:%String,loc:%String,locDesc:%String")
{
}

ClassMethod DHCStkMonExecute(ByRef qHandle As %Binary, loc As %String, StartDate As %String = "", EndDate As %String = "") As %Status
{
	i loc="" q $$$OK
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	;
	s sql="select dhcsm_rowid smRowid,"
	s sql=sql_"dhcsm_month mon,"
	s sql=sql_"dhcsm_fromdate frDate,"
	s sql=sql_"dhcsm_todate toDate,"
	s sql=sql_"DHCSM_CreatedUser_dr userRowid,"
	s sql=sql_"dhcsm_createduser_dr->ssusr_name userName,"
	s sql=sql_"dhcsm_createddate createDate,"
	s sql=sql_"DHCSM_FromTime frTime,"
	s sql=sql_"DHCSM_ToTime toTime,"
	s sql=sql_"DHCSM_CreatedTime createTime,"
	s sql=sql_"dhcsm_ctloc_dr monLoc,"
	s sql=sql_"dhcsm_ctloc_dr->ctloc_desc monLocDesc"
	s sql=sql_" from dhc_stkmon"
	s sql=sql_" where dhcsm_ctloc_dr="_loc
	i StartDate'="",EndDate'="" d
	.s sql=sql_" and dhcsm_month between "_StartDate_" and "_EndDate
	s sql=sql_" order by dhcsm_month DESC"
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.Prepare(sql)
	s ret=xrs.Execute()
	i $$$ISERR(ret) q $$$OK
	while (xrs.Next()) 
	{
		s smRowid=xrs.Data("smRowid")
		s mon=xrs.Data("mon")
		s frDate=xrs.Data("frDate")
		s toDate=xrs.Data("toDate")
		s frTime=xrs.Data("frTime")
		s toTime=xrs.Data("toTime")
		s createDate=xrs.Data("createDate")
		s createTime=xrs.Data("createTime")
		s user=xrs.Data("userRowid")
		s userName=xrs.Data("userName")
		s monLoc=xrs.Data("monLoc")
		continue:$p(^CTLOC(loc),"^",22)'=$p(^CTLOC(monLoc),"^",22)
		s monLocDesc =xrs.Data("monLocDesc") 	 
		s mon=$e($zd(mon,3),1,7)
		s frDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(frDate,"ST")
		s toDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(toDate,"ST")
		s frTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(frTime,"ST")
		s toTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(toTime,"ST")
		s createDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(createDate,"ST")
		s createTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(createTime,"ST")
		d OutPutRow
	} 
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRow
	s Data=$lb(smRowid,mon,frDate,toDate,frTime,toTime,createDate,createTime,user,userName,monLoc,monLocDesc)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 取科室库存项目的排除标志，根据该属性的定义，返回1或0
/// Author:zhwh
/// Date:2012-11-05
/// Argu:
///  inclb -库存批次rowid
/// Return :
///  1 - 排除
///  0 - 不排除
ClassMethod ExcludeFlag(inclb As %String) As %String
{
	n (inclb)
	s incil=$P(inclb,"||",1,2)
	&sql(select incil_freestoragebin into :flag From inc_itmloc where  %id=:incil) 
	s flag=$G(flag)
	i (flag="Y")!(flag="1") q 1
	q 0
}

/// 取得某科室本次月报的起始日期和时间(根据上次月报的日期和时间)
/// Author:zhangdongmei
/// Date:2012-11-19
/// Argu:
///  locid -科室rowid
///  currmon-当前月份
/// Return :
///  起始日期^起始时间
ClassMethod GetStkMonStDateTime(locid, currmon) As %String
{
	n (locid,currmon)
	q:locid="" ""
	;caculate last mon
	i +$p(currmon,"-",2)=1 s m=12,y=+$p(currmon,"-",1)-1
	e  s m=+$p(currmon,"-",2)-1,y=$p(currmon,"-",1)
	s lastmon=y_"-"_m_"-"_"01"
	;
	s mon=$zdh(lastmon,3)
	s lastid=$o(^DHCSM(0,"MLOC",mon,locid,""))
	;
	i +lastid=0 d  ;不存在上次月报
	.s startdate=""
	.s starttime=""
	e  d
	. s enddate=$p(^DHCSM(lastid),"^",4)
	. s endtime=$p(^DHCSM(lastid),"^",8)
	. i endtime="" s endtime=$zth("23:59:59")
	. 
	. i endtime=$zth("23:59:59") d
	. . s startdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(enddate+1,"ST")
	. . s starttime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(0,"ST")
	. e  d
	. . s startdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(enddate,"ST")
	. . s starttime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(endtime+1,"ST")
	q startdate_"^"_starttime
}

/// 检查某科室某月份月报是否已经生成
/// Author:zhangdongmei
/// Date:2012-11-20
/// Argu:
///  LocId -科室rowid
///  CurMonth-当前月份
/// Return :
///  >0(月报id)：月报已经生成;0:未生成
ClassMethod CheckIfExist(LocId, CurMonth) As %String
{
	 ;
	 n (LocId,CurMonth)
	 q:LocId="" 0
	 q:CurMonth="" 0
	 ;
	 s Flag=0
	 s CurMonth=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CurMonth)	 	
	 s Rowid=$o(^DHCSM(0,"TML","G",CurMonth,LocId,""))
	 q Rowid
}

/// 检查某科室某月份月报是否存在未完成的单据
/// Author:wyx
/// Date:2014-03-06
/// Argu:
///  LocId -科室rowid
///  StartDate-月报开始日期
///  EndDate -月报结束日期
/// Return :
///  未完成的单据 
///  w ##class(web.DHCST.DHCStkMon).CheckIfCompleted(100,"2017-06-01","2017-06-01")
ClassMethod CheckIfCompleted(LocId, StartDate, EndDate) As %String
{
	n (LocId,StartDate,EndDate)
	q:LocId="" ""
	q:StartDate="" ""
	q:EndDate="" ""
	s sd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s ed=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s result=""
	f date=sd:1:ed q:(result'="")  d
	.//未审核的入库单
	.s ingrID="" 
	.f  s ingrID=$o(^DHCINGR(0,"CreateDate",date,LocId,ingrID)) q:(ingrID="")!(result'="")  d 
	..s AuditDate=$p(^DHCINGR(ingrID),"^",4)
	..q:AuditDate'=""
	..s StkType=$p(^DHCINGR(ingrID),"^",30)
	..q:StkType'="G"
	..s INGRNO=$p(^DHCINGR(ingrID),"^",1)
	..s result=..Trans("入库单:")_INGRNO
	.//未审核的出库单
	.s initID=""
	.f  s initID=$o(^DHCINIT(0,"TrfDate",date,initID)) q:(initID="")!(result'="")  d
	..s fLocID=$p(^DHCINIT(initID),"^",5)
	..s tLocID=$p(^DHCINIT(initID),"^",6)
	..s status=$p(^DHCINIT(initID),"^",14)
	..s StkType=$p(^DHCINIT(initID),"^",24)
	..q:StkType'="G"
	..q:(status=30)||(status=40)||(status=21) // 拒绝接收 , 重转作废,出库审核  单据过滤
	..q:(fLocID'=LocId)&(tLocID'=LocId)
	..q:(fLocID=LocId)&($p(^DHCINIT(initID),"^",9)'="")&($p(^DHCINIT(initID),"^",15)'="")
	..q:(tLocID=LocId)&($p(^DHCINIT(initID),"^",15)'="")&($p(^DHCINIT(initID),"^",9)'="")
	..s initNo=$p(^DHCINIT(initID),"^",1)
	..i fLocID=LocId s result=..Trans("转移出库单:")
	..i tLocID=LocId s result=..Trans("转移入库单:")
	..s result=result_initNo
	.//退货单
	.s ingrtID=""
	.f  s ingrtID=$o(^INGRT(0,"DATE",date,ingrtID)) q:(ingrtID="")!(result'="")  d
	..s locID=$p(^INGRT(ingrtID),"^",7)
	..q:locID'=LocId
	..s StkType=$p(^INGRT(ingrtID),"^",16)
	..q:StkType'="G"
	..q:$p(^INGRT(ingrtID),"^",9)'=""
	..s ingrtNo=$p(^INGRT(ingrtID),"^",1)
	..s result=..Trans("退货单:")_ingrtNo
	.//调整单
	.s inadID=""
	.f  s inadID=$o(^DHCINAD(0,"Date",date,inadID)) q:(inadID="")!(result'="")  d
	..s inadSub=$o(^DHCINAD(0,"Loc",LocId,inadID,""))
	..q:inadSub=""
	..s state=$p(^DHCINAD(inadID),"^",7)
	..q:state=20
	..s StkType=$p(^DHCINAD(inadID),"^",15)
	..q:StkType'="G"
	..s inadNo=$p(^DHCINAD(inadID),"^",1)
	..s result=..Trans("调整单:")_inadNo
	.//报损
	.s inscpID=""
	.f  s inscpID=$o(^DHCINSP(0,"Date",date,inscpID)) q:(inscpID="")!(result'="")  d
	..s locID=$p(^DHCINSP(inscpID),"^",5)
	..q:locID'=LocId
	..s state=$p(^DHCINSP(inscpID),"^",10)
	..q:state=20
	..s chkflag=$p($g(^DHCINSP(inscpID)),"^",14)
	..q:chkflag="Y"
	..s StkType=$p(^DHCINSP(inscpID),"^",15)
	..q:StkType'="G"
	..s inscpNo=$p(^DHCINSP(inscpID),"^",1)
	..s result=..Trans("报损单:")_inscpNo
	q result
}

/// 取安全组-库存科室及其月报存在的情况(json)
/// Author:zhwh
/// Date: 2012-11-22
/// Argu:
///  Start - 
///  Limit - 
///  Grp-
/// Return:
///  安全组-库存科室数据串(json)
///  w ##class(web.DHCST.DHCStkMon).jsGrpLocForStkMon(0,30,142)
ClassMethod jsGrpLocForStkMon(Start As %String, Limit As %String, Grp As %String, Hosp = "") As %String
{
	//取出该安全组下的科室	
	s xrs=##class(%ResultSet).%New("web.DHCST.Common.UtilCommon:GrpStockLocation")
	s sc=xrs.Execute(Grp,"","",Hosp)
	;
	i $$$ISERR(sc) q ""
	s colNum=xrs.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=xrs.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_xrs.GetColumnName(i)


	s colNameStr=colNameStr_"^lastStkMonRowid^lastMonth^lastFrDate^lastFrTime^lastToDate^lastToTime"

	s count = 0
	s resultString = ""
	s end = Start+Limit
	s json = ##class(Code.JsonObj).%New()
	While(xrs.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=xrs.%GetData(i)
		.e   s ret=ret_"^"_xrs.%GetData(i)

		//检索每一个科室的上期(最后)月报情况 Start 
		s last="",lastMonth="",lastFrDate="",lastFrTime="",lastToDate="",lastToTime=""
		s loc=$p(ret,"^",1)
		s finalMonth=""
		&sql( select max(dhcsm_month) into :finalMonth  From dhc_stkmon where dhcsm_ctloc_Dr=:loc)
		i finalMonth'="" d
		.&sql(select %id,dhcsm_month,dhcsm_fromdate,dhcsm_todate,dhcsm_fromtime,dhcsm_totime
		into :last,:lastMonth,:lastFrDate,:lastToDate,:lastFrTime,:lastToTime 
		From dhc_stkmon where dhcsm_ctloc_dr=:loc and dhcsm_month= :finalMonth)
		.s last=+last
		.s lastMonth=$zd(lastMonth,3)
		.s lastFrDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(lastFrDate,"ST")
		.s lastFrTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(lastFrTime,"ST")
		.s lastToDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(lastToDate,"ST")
		.s lastToTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(lastToTime,"ST")
		s ret=ret_"^"_last
		s ret=ret_"^"_lastMonth
		s ret=ret_"^"_lastFrDate
		s ret=ret_"^"_lastFrTime
		s ret=ret_"^"_lastToDate
		s ret=ret_"^"_lastToTime
		//检索每一个科室的上期(最后)月报情况 end.
		//
		s tmp=ret
		s count = count+1
		CONTINUE:count<(Start+1)
		CONTINUE:count>end			
		d json.InsertRowData(tmp)
	}
	d xrs.Close()
	s resultString = json.getJsonData(colNameStr,count)
	k json
	Q resultString
}

/// 取月报主表记录的数据信息串
/// Author:zhangxiao
/// Date:2013-09-24
/// Argu:
///  ret - 月报主表rowid
/// Return：
///  返回记录数据串
/// w ##class(web.DHCST.DHCStkMon).GetMain(25)
ClassMethod GetMain(RowId As %String) As %String
{
	q:RowId="" ""
	k PLIST
	s result=""
	&sql(select * into :PLIST() from DHC_StkMon where %ID=:RowId)
	q:SQLCODE ""
	s cnt=$o(PLIST(""),-1)
	s mon=$g(PLIST(2))
	s:mon'="" month=$e($zd(mon,3),1,7)
	s Locid=$g(PLIST(3))
	s:Locid'="" LocDesc=$p(^CTLOC(Locid),"^",2)
	s fd=$g(PLIST(4))
	s:fd'="" fromdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(fd,"ST")
	s td=$g(PLIST(5))
	s:td'="" todate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(td,"ST")
	s cd=$g(PLIST(6))
	s:cd'="" createdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(cd,"ST")
	s createUser=$g(PLIST(7))
	s:createUser'="" createUsername=$p(^SSU("SSUSR",createUser),"^",2)
	s ft=$g(PLIST(8))
	s:ft'="" frTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ft,"ST")
	s tt=$g(PLIST(9))
	s:tt'="" toTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(tt,"ST")
	s ct=$g(PLIST(10))
	s:ct'="" createTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ct,"ST")
	s result=$g(month)_"^"_$g(LocDesc)_"^"_$g(fromdate)_"^"_$g(todate)_"^"_$g(createdate)_"^"_createUsername_"^"_$g(frTime)_"^"_$g(toTime)_"^"_$g(createTime)
	q result
}

/// Descript:取月报生成界面参数配置属性
/// Creater:    wyx
/// CreateDate: 2014-03-06
/// Table:
/// Input:安全组id,科室id,用户id
/// Output:     
/// Return：未完成单据提示
ClassMethod GetParamProp(GroupId As %String, LocId As %String, UserId As %String) As %Library.String
{
    n (GroupId,LocId,UserId)
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=##class(web.DHCST.DHCStkMon).%GetParameter("AppName")
    s IfCompleted=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"IfCompleted",Param)
    s CreateFromDaily=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"CreateFromDaily",Param)
    s Data1=IfCompleted_"^"_CreateFromDaily
    q Data1
}

/// 根据月报号更新凭证号，凭证日期，凭证PDF
/// Author:	xuchao
/// Date:	2016-08-01
/// Argu:	月报号
/// Return:	成功返回0 其他返回错误
/// w ##class(web.DHCST.DHCStkMon).UpdateAcctVoucherInfo()
ClassMethod UpdateAcctVoucherInfo(StkMonNo As %String, AcctVoucherCode As %String, AcctVoucherDate As %String, PdfFile As %String) As %String
{
	n (StkMonNo,AcctVoucherCode,AcctVoucherDate,PdfFile)
	q:StkMonNo="" -1
	s:AcctVoucherDate'="" AcctVoucherDate=$zdh(AcctVoucherDate,3)
	&sql(update DHC_StkMon set DHCSM_AcctVoucherCode=:AcctVoucherCode,DHCSM_AcctVoucherDate=:AcctVoucherDate,DHCSM_PdfFile=:PdfFile where DHCSM_StkMonNo=:StkMonNo)
	q SQLCODE
}

/// 根据月报号更新凭证号状态
/// Author:	xuchao
/// Date:	2016-08-01
/// Argu:	月报号 (A,P,R):Accepted,Passed,Returned
/// Return:	成功返回0 其他返回错误
/// w ##class(web.DHCST.DHCStkMon).UpdateAcctVoucherStatus("QXKKFMON20160802004","A",1)
ClassMethod UpdateAcctVoucherStatus(StkMonNo As %String, AcctVoucherStatus As %String, User As %String = "") As %String
{
	n (StkMonNo,AcctVoucherStatus,User)
	q:StkMonNo="" -1
	&sql(update DHC_StkMon set DHCSM_AcctVoucherStatus=:AcctVoucherStatus where DHCSM_StkMonNo=:StkMonNo)
	s Sm=%ROWID
	&sql(insert DHC_StkMon_VoucherStatus(VCH_SM_DR,VCH_SSUSR_DR,VCH_Status)values (:Sm,:User,:AcctVoucherStatus))
	q SQLCODE
}

/// creator:    yunhaibao
/// createdate: 2017-07-24
/// description:生月报任务(dayNo为空时,默认月报时段为1-31号,任务为下月1号开始)
/// input:		locId(科室Id),startDate(开始日期),endDate(结束日期)
/// w ##class(web.DHCST.DHCStkMon).CreateMonRepTask("102")
ClassMethod CreateMonRepTask(locIds, dayNo = "")
{
	n (locIds,dayNo)
	s curDateHtml=$p($zd(+$h,3),"-",1,2)_"-01"
	s curDate=$zdh(curDateHtml,3)
	s needDate=curDate-1
	s needDateHtml=$zd(needDate,3)
	s needStartDate=$p(needDateHtml,"-",1,2)_"-01"
	s needEndDate=$zd(needDate,3)
	s needMonth=$p(needDateHtml,"-",1,2)_"-01"
	f locI=1:1:$l(locIds,"^") d
	.s locId=$p(locIds,"^",locI)
	.q:locId=""
	.q:'$d(^CTLOC(locId))
	.s monRet=##class(web.DHCST.DHCStkMon).CreateStkMon(locId,needMonth,1,needStartDate,needEndDate,"00:00:00","23:59:59")
	q 0
}

/// description: 生成月报,job方式用的不多,暂不考虑公共
ClassMethod JobSendCreateReports(listParams)
{
	n (listParams)	
	s pid=##class(web.DHCST.Common.Job).NewPid()
	Job ##class(web.DHCST.DHCStkMon).JobSetCreateReports(pid,listParams)
	q pid
}

/// description: 生成月报-中介
ClassMethod JobSetCreateReports(pid, listParams)
{
	n (pid,listParams)	
	s creRet=##class(web.DHCST.DHCStkMon).CreateReports(listParams)
	i creRet=0 s creRet="0^"_..Trans("生成成功")
	e  s creRet="-1^"_creRet
	d ##class(web.DHCST.Common.Job).SetJobResult(pid,creRet)
	q 0
}

/// 翻译 
/// yangsj 2020-11-05
ClassMethod Trans(Text)
{
	q ##class(websys.Translation).Get("dhcst.stkmon.csp",Text)
}

}
