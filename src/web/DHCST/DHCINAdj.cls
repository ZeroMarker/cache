Import sqluser

Class web.DHCST.DHCINAdj Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTSTOCKADJ";

/// 插入或更新库存调整主表
/// Author:zhwh
/// Date:2012-07-09
/// Argu:
///  adj - 库存调整主表rowid
///  data - 库存调整主表数据串 
/// Return:
/// 	>0 - success
/// 	<=0 - failure
/// 	
ClassMethod Update(adj As %String, data As %String) As %String
{
 n (adj,data)
 s ret=0
 i adj'="" q:##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_adj)<0 -99
 i adj="" d
 . s obj=##class(User.DHCINAdj).%New()
 e  d
 .s obj=##class(User.DHCINAdj).%OpenId(adj)
 .d obj.%Reload()
 
 s adjLoc=$P(data,"^",1)   //科室rowid
 s adjUser=$P(data,"^",2)   //调整人
 s adjReason=$P(data,"^",3)  //调整原因
 s adjScg=$P(data,"^",4)  //库存类组rowid
 s adjStkType=$P(data,"^",5)  //库存类型
 s adjInst=$P(data,"^",6)  //盘点主表rowid(DHC_INStktk)
 s adjComp=$P(data,"^",7)  //完成标志
 s adjState=$P(data,"^",8)  //调整单状态
 s remark=$P(data,"^",9)  //备注(备注的文本行之间须用$c(1)分隔)
 s adjDate=+$h    //调整日期
 s adjTime=$p($h,",",2)  //调整时间
 s adjNo=##class(web.DHCST.Common.AppCommon).GetAppNo(..%GetParameter("AppName"),adjScg,adjLoc)  //调整单号
 i adjNo="" d ..uLock(adj) q -9
 s obj.INADNo=adjNo
 s obj.INADCompleted=adjComp
 s obj.INADDate=adjDate
 s obj.INADTime=adjTime
 s obj.INADStkType=adjStkType
 s obj.INADSCGDR=##class(User.DHCStkCatGroup).%OpenId(adjScg,0)
 s obj.INADState=adjState
 s obj.INADSSUSRDR=##class(User.SSUser).%OpenId(adjUser,0)
 s obj.INADINSTDR=##class(User.DHCInStkTk).%OpenId(adjInst,0)
 ;备注字段
 //s memoDelim=##class(web.DHCST.Common.UtilCommon).MemoDelim()  //取分隔符
 //d obj.INADRemarks.Clear()
 //f i=1:1:$l(remark,memoDelim) d
 //.s rem1=$P(remark,memoDelim,i)
 //.d obj.INADRemarks.Insert(rem1)
 s remark=$lfs(remark,$c(3))
 d obj.INADRemarks.Clear()
 d obj.INADRemarks.InsertList(remark)
 ;
 s obj.INADReasonAdjDR=##class(User.INCReasonForAdjustment).%OpenId(adjReason,0)
 s obj.INADCTLOCDR=##class(User.CTLoc).%OpenId(adjLoc,0)

 s result=obj.%Save()	 
 d ..uLock(adj) 
 i $$$ISERR(result) d
 .s ret=-1
 q:ret'=0 ret
 q obj.%Id()
}

/// 取出一条库存调整记录主表的值串
/// Author:zhwh
/// Date:2012-07-09
/// Argu：
///  adj - 库存调整记录主表rowid
/// Return:
///   主表记录值串
ClassMethod Select(adj As %String) As %String
{
 k PLIST
 s result=""
 
 &sql(select * into :PLIST() from DHC_INAdj where %ID=:adj )
 
 q:SQLCODE'=0 result
 //备注信息处理
 s memoDelim=##class(web.DHCST.Common.UtilCommon).MemoDelim()  //取分隔符
 s rem=$LTS(PLIST(2),memoDelim)
 s PLIST(2)=rem
 // 
 s cnt=$o(PLIST(""),-1)
 f i=1:1:cnt d
 .i result=""  s result=$g(PLIST(i))
 .e  s result=result_"^"_$g(PLIST(i))
 
 q result
}

/// 删除库存调整记录主表记录
/// Author:zhwh
/// Date:2012-07-09
/// Argu：
///  adj - 库存调整记录主表rowid
/// Return:
/// 0 - success
/// <0 - failure
ClassMethod Delete(adj As %String) As %String
{
 n (adj)
 i ##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_adj) q -99
 s allowdelete=..AllowDel(adj)
 i allowdelete<0 d ..uLock(adj) q allowdelete
 i ..IfCanDeleteAll(adj)<0 d ..uLock(adj) q -5
 &sql(delete from dhc_inadj where %ID=:adj)	
 d ..uLock(adj)
 i SQLCODE'=0  q -1
 q 0
}

/// 库存调整单审核
/// Author:zhwh
/// Date:2012-07-10
/// Argu：
///    adj - 库存调整记录主表rowid 
///    user - 审核人
/// Return:
///    0 :审核成功
///   -99:加锁失败
///   -100:业务数据基础代码发生变化(单位,售价)
///   -2:审核出错
///   -3:台帐处理出错
///   -4:库存处理出错
///   -1:状态不允许审核("未完成"等)
///   w ##class(web.DHCST.DHCINAdj).Audit(25,13609)
ClassMethod Audit(adj As %String, user As %String) As %String
{
 n (adj,user)
 //加锁
 i ##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_adj)<0 -99
 i ..AllowAudit(adj)<0 d ..uLock(adj) q -1
 s errMsg=..ChkAdjItmData(adj)
 i errMsg'="" d ..uLock(adj) q -100_"^"_errMsg
 s adjLoc=$P(^DHCINAD(adj),"^",16)
 s HospID=$P(^CTLOC(adjLoc),"^",22)
 s ret=0
 //库存处理\台账处理
 s TrNo=""
 &sql(select inad_no into :TrNo from dhc_inadj where %ID=:adj)
 s err=0
 s ch=0
 f  s ch=$o(^DHCINAD(adj,"ADI",ch)) q:(ch="")!(err>0)  d
 .s adjitm=adj_"||"_ch
 .s obj=##class(User.DHCINAdjItm).%OpenId(adjitm,0)
 .d obj.%Reload()
 .s inclb=obj.INADIINCLBDR.%Id()
 .s qty=obj.INADIQty
 .s uom=obj.INADICTUOMDR.%Id()
 .
 .s sp=obj.INADIUCost
 .s spAmt=obj.INADISPAmt
 .s rp=obj.INADIRP
 .s rpAmt=obj.INADIRPAmt
 .
 .s trType="A"
 .s TrNo=$G(TrNo)
 .s Pointer=adjitm
 .q:$d(^DHCINTR(0,"TypePointer",trType,Pointer))
 
 .ts
 .//更新进售价及金额为最新进售价金额
 .s CurSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclb,+$h,uom,HospID,..sssCode(),"")
 .s CurRp=##class(web.DHCST.Common.PriceCommon).GetClbRp(inclb,uom,HospID,..sssCode(),+$h,"")
 .i (CurSp'=sp)||(CurRp'=rp) d
 ..s NewSpAmt=CurSp*qty
 ..s NewRpAmt=CurRp*qty
 ..s NewSpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(NewSpAmt,HospID)
 ..s NewRpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(NewRpAmt,HospID)
 ..&Sql(UPDATE DHC_INAdjItm SET INADI_UCost=:CurSp ,INADI_SPAmt=:NewSpAmt, INADI_RP=:CurRp, INADI_RPAmt=:NewRpAmt WHERE INADI_RowId=:adjitm)
 ..i SQLCODE'=0 s ret=SQLCODE q
 ..s sp=CurSp
 ..s rp=CurRp
 ..s rpAmt=NewRpAmt
 ..s spAmt=NewSpAmt
 .i ret<0 tro   s err=3 q
 
 .s trans=trType
 .s trans=trans_"^"_TrNo
 .s trans=trans_"^"_inclb
 .s trans=trans_"^"_qty
 .s trans=trans_"^"_uom
 .s trans=trans_"^"_sp
 .s trans=trans_"^"_user
 .s trans=trans_"^"_Pointer
 .s trans=trans_"^"_rp
 .s trans=trans_"^"_rpAmt
 .s trans=trans_"^"_spAmt
 .
 
 
 .s inci=+inclb
 .s buom=$p(^INCI(inci,1),"^",10)
 .s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)
 .s bqty=qty*fac   //换算成基本单位的数量
 .
 .s ret=##class(web.DHCST.Common.StockHandle).UpdateStock(inclb,bqty)   //处理库存
 .i ret<0 tro   s err=2 q
 .
 .s ret=##class(web.DHCST.Common.StockHandle).IntoTrans(trans)  //插入台账数据
 .i ret<0  tro   s err=1  q 
 .tc
 d ..uLock(adj)
 q:err=1 -3
 q:err=2 -4
 //更新状态
 s status="20",chk="Y"
 s d=+$H,t=$p($h,",",2)
 &sql(update dhc_inadj set inad_chkflag=:chk,inad_chkDate=:d,inad_chktime=:t,
     INAD_ChkUSR_DR=:user,inad_state=:status where %ID=:adj )
 i SQLCODE'=0 d ..uLock(adj) q -2
 q 0
}

/// 设置(或取消)库存调整单完成
/// Author:zhwh
/// Date:2012-10-24
/// Argu:
///  adj - 库存调整单主表 rowid
///  completed - 完成标志(Y,N)
/// Return:
/// 0 - success
/// <0 - failure
ClassMethod SetComplete(adj As %String, completed As %String) As %String
{
 n (adj,completed)
 i adj="" q -100
 //加锁
 i ##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_adj)<0 -99
 &sql(select inad_completed,inad_chkflag into :comp,:audit from dhc_inadj where %id=:adj)
 i SQLCODE d ..uLock(adj) q -1
 i (completed="Y")&( $g(comp)="Y") d ..uLock(adj) q -2  //已经完成
 
 i (completed="N")&( $g(audit)="Y") d ..uLock(adj) q -3  //已经审核,不许取消完成
 
 &sql(update dhc_inadj set inad_completed=:completed where %id=:adj)
 i SQLCODE'=0  d ..uLock(adj) q -4
 d ..uLock(adj)
 q 0
}

/// 是否允许审核
/// Author:zhwh
/// Date:2012-07-10
/// Argu:
///  adj - 调整单主表rowid
/// Return:
///  0 - sucess
/// <0 - failure
/// 
ClassMethod AllowAudit(adj As %String) As %String
{
 n (adj)
 s obj=##class(User.DHCINAdj).%OpenId(adj,0)
 i $$$ISERR(obj) q -1
 d obj.%Reload()
 s comp=obj.INADCompleted
 q:comp'="Y" -2    //未完成
 s auditFlag=obj.INADChkFlag   //flag of audit
 q:auditFlag="Y" -3  //已经审核
 s state=obj.INADState
 i +state'<20 q -4
 q 0
}

/// 检查是否允许删除
/// Author:zhwh
/// Date:2012-07-10
/// Argu:
///  adj -调整单主表rowid
/// Return:
///  0 - 允许
///  <0 -不允许
///    -1:记录不存在
///    -2:已经完成
///    -3:已经审核
///    -4:已经审核
ClassMethod AllowDel(adj As %String) As %String
{
 n (adj)
 s obj=##class(User.DHCINAdj).%OpenId(adj,0)
 i $$$ISERR(obj) q -1
 d obj.%Reload()
 s comp=obj.INADCompleted
 q:comp="Y" -2    //已经完成
 s auditFlag=obj.INADChkFlag   //flag of audit
 q:auditFlag="Y" -3  //已经审核

 //s state=obj.INADState 
 //i +state'=10 q -4  //已经审核
 q 0
}

/// 库存调整单主表记录(json)
/// Author:zhwh
/// Date:2012-07-10
/// Argu:
///  Start - 起始行号
///  Limit - 行数
///  Sort - 排序字段
///  Dir   - 排序方向
///  strPar -  query参数
/// Return:
/// 库存调整主表记录串(json格式)
/// w ##class(web.DHCST.DHCINAdj).jsDHCINAdjM(0,15,"No","desc","2015-11-19^2015-11-27^102^N^Y")
ClassMethod jsDHCINAdjM(Start As %String, Limit As %String, Sort As %String, Dir As %String, strPar As %String) As %String
{
 n (Start,Limit,Sort,Dir,strPar)
 s StartDate=$p(strPar,"^",1)  //起始日期
 s EndDate=$p(strPar,"^",2)  //截止日期
 s Loc=$p(strPar,"^",3)   //科室rowid
 s Status=$p(strPar,"^",4)   //审核标志
 s Comp=$p(strPar,"^",5) //完成状态
 s ReasonDr=$p(strPar,"^",6)  //调整原因
 s result=##class(%Library.ResultSet).%New("web.DHCST.DHCINAdj:DHCINAdjM")	
 s qPar=Sort_"^"_Dir
 s sc=result.Execute(qPar,StartDate,EndDate,Loc,Status,Comp,ReasonDr)
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
 s count = 0
 s resultString = ""
 s end = Start+Limit
 s json = ##class(Code.JsonObj).%New()
 While(result.Next())
 { 
  s ret=""
  f i=1:1:colNum d
  .i ret="" s ret=result.%GetData(i)
  .e   s ret=ret_"^"_result.%GetData(i)
  s tmp=ret
  s count = count+1
  CONTINUE:count<(Start+1)
  CONTINUE:count>end				
  d json.InsertRowData(tmp)
 }
 d result.Close()
 s resultString = json.getJsonData(colNameStr,count)
 k json
 Q resultString
}

/// 库存调整单主表记录Query
/// Author:zhwh
/// Date:2012-07-10
/// Argu:
///   qPar - 
///   StartDate - 起始日期
///   EndDate - 截止日期
///   Loc  -科室rowid
///   Status - 状态
///   Comp - 完成标志
///   
Query DHCINAdjM(qPar As %String, StartDate As %String, EndDate As %String, Loc As %String, Audited As %String = "", Comp As %String = "", ReasonDr As %String = "") As %Query(ROWSPEC = "adj:%String,no:%String,loc:%String,locDesc:%String,date:%String,time:%String,user:%String,userName:%String,chkDate:%String,chkTime:%String,chkUser:%String,chkUserName:%String,scg:%String,scgDesc:%String,comp:%String,state:%String,chkFlag:%String,stkType:%String,spAmt:%String,rpAmt:%String,adjReason:%String,adjRemark:%String")
{
}

ClassMethod DHCINAdjMExecute(ByRef qHandle As %Binary, qPar As %String, StartDate As %String, EndDate As %String, Loc As %String, Audited As %String = "", Comp As %String = "", ReasonDr As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 s xrs=##class(%ResultSet).%New()
 s Sort=$p(qPar,"^",1)
 s Dir=$p(qPar,"^",2) 
 //排序字段
 s orderFieldName=""
 s:Sort="User" orderFieldName="adjUser"
 s:Sort="Date" orderFieldName="adjDate"
 s:Sort="chkUser" orderFieldName="chkUser"
 s:Sort="chkDate" orderFieldName="chkDate"
 s:Sort="comp" orderFieldName="comp"
 s:Sort="state" orderFieldName="state"
 s:Sort="chkFlag" orderFieldName="chkFlag"
 s:Sort="scg" orderFieldName="scg"

 s Dir=$$ALPHAUP^SSUTIL4(Dir)
 s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
 i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 s sql="select %ID adj,"
 s sql=sql_"inad_NO adjNo,"
 s sql=sql_"inad_ctloc_dr loc,"
 s sql=sql_"inad_ctloc_dr->ctloc_desc locDesc,"
 s sql=sql_"inad_date adjDate,"
 s sql=sql_"inad_time adjTime,"
 s sql=sql_"inad_ssusr_dr adjUser,"
 s sql=sql_"inad_ssusr_dr->ssusr_name userName,"
 s sql=sql_"inad_chkdate chkDate,"
 s sql=sql_"inad_chktime chkTime,"
 s sql=sql_"inad_chkusr_dr chkUser,"
 s sql=sql_"inad_chkusr_dr->ssusr_name chkUserName,"
 s sql=sql_"inad_scg_dr scg,"
 s sql=sql_"inad_scg_dr->scg_desc scgDesc,"
 s sql=sql_"nvl(inad_completed,'N') comp,"
 s sql=sql_"inad_state state,"
 s sql=sql_"nvl(inad_chkflag,'N') chkFlag,"
 s sql=sql_"inad_stktype stkType,"
 s sql=sql_"INAD_ReasonAdj_DR->ADJ_DESC adjReason"
 s sql=sql_" From dhc_inadj "
 s sql=sql_"Where inad_date between "_StartDate_" And "_EndDate
 i ReasonDr'="" d
 .s sql=sql_" and INAD_ReasonAdj_DR= "_ReasonDr
 i orderFieldName'=""  d
 . s sql=sql_" order by "_orderFieldName_" "_Dir
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 s err=$$$ISERR(sc)
 i err q $$$OK
 
 while (xrs.Next())
 {
	 //s i=i+1
	 s loc=xrs.Data("loc")
	 continue:loc'=Loc
	 s state=xrs.Data("state")
	 s chkFlag=xrs.Data("chkFlag")
	 i Audited'=""   continue:chkFlag'=Audited 
	 s comp=xrs.Data("comp")
	 i (Audited="N")&(Comp'="")  continue:comp'=Comp
	 s adj=xrs.Data("adj")
	 s no=xrs.Data("adjNo")
	 s locDesc=xrs.Data("locDesc")
	 s date=xrs.Data("adjDate")
	 s time=xrs.Data("adjTime")
	 s user=xrs.Data("adjUser")
	 s userName=xrs.Data("userName")
	 s chkDate=xrs.Data("chkDate")
	 s chkTime=xrs.Data("chkTime")
	 s chkUser=xrs.Data("chkUser")
	 s chkUserName=xrs.Data("chkUserName")
	 s scg=xrs.Data("scg")
	 s scgDesc=xrs.Data("scgDesc")
	 s stkType=xrs.Data("stkType")
	 continue:stkType'=..sssCode()
	 i date'="" s date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date,"ST")
	 i time'="" s time=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(time,"ST")
	 i chkDate'="" s chkDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(chkDate,"ST")
	 i chkTime'="" s chkTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(chkTime,"ST")
 	 s spAmt=""
 	 s rpamt=""
 	 &SQL(SELECT sum(INADI_SpAmt),sum(INADI_RpAmt) into :spAmt,:rpAmt FROM DHC_INAdjItm WHERE INADI_INAD_ParRef=:adj)
 	 s adjReason=xrs.Data("adjReason")
	 s adjRemark=$g(^DHCINAD(adj,"REM",1))  //$p($g(^DHCINAD(225,"REM")),"^",1)
 	 d OutPutRow1
 }
 Quit $$$OK
OutPutRow1
 s Data=$lb(adj,no,loc,locDesc,date,time,user,userName,chkDate,chkTime,chkUser,chkUserName,scg,scgDesc,comp,state,chkFlag,stkType,spAmt,rpAmt,adjReason,adjRemark)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod DHCINAdjMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCINAdjMExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DHCINAdjMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCINAdjMExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod SetLoc() As %String
{
 s inad=0
 s n=0
 f  s inad=$o(^DHCINAD(inad)) q:inad=""  d
 .s ch=$o(^DHCINAD(inad,"ADI",0))
 .q:ch=""
 .s inclb=$P(^DHCINAD(inad,"ADI",ch),"^",1)
 .q:inclb=""
 .s loc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
 .i loc'="" &sql(update dhc_inadj set inad_ctloc_dr=:loc where %ID=:inad)
 .s n=n+1
 q n
}

/// 库存调整单加锁
/// Author:zhwh
/// Date:2012-07-10
/// Argu:
///  adj -库存调整单主表rowid
///  
ClassMethod uLock(adj As %String)
{
 n (adj)
 q:adj=""
 d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_adj)
 q
}

/// 库存调整原因SQLQuery
/// Author:zhwh
/// Date:2012-07-10
/// 
Query AdjReason() As %SQLQuery(CONTAINID = 1)
{
 select %ID,ADJ_Desc from SQLUser.INC_ReasonForAdjustment
}

/// 检查库存调整单数据(一般在"审核"前执行该操作)
/// Author:zhwh
/// Date:2012-07-10
/// Argu:
///     adj - 库存调整单主表rowid
/// Return:
///    "" -数据合法
///    非空 -  错误信息
ClassMethod ChkAdjItmData(adj As %String) As %String
{
	 n (adj)
	 s LocID=$p(^DHCINAD(adj),"^",16)
	 i LocID="" d
	 .s asub=$o(^DHCINAD(adj,"ADI",0))
	 .q:asub=""
	 .s LocID=$p(^DHCINAD(adj,"ADI",asub),"^",11)
	 q:LocID="" "<"_adj_">科室为空"
	 s HospID=$P($g(^CTLOC(LocID)),"^",22)
	 s errMsg=""
	 s ch=0
	 f  s ch=$O(^DHCINAD(adj,"ADI",ch)) q:(ch="")!(errMsg'="")  d
	 .q:$d(^DHCINTR(0,"TypePointer","A",adj_"||"_ch))
	 .s inclb=$P(^DHCINAD(adj,"ADI",ch),"^",1)
	 .s qty=$P(^DHCINAD(adj,"ADI",ch),"^",2)
	 .s sp=$P(^DHCINAD(adj,"ADI",ch),"^",4)
	 .s uom=$P(^DHCINAD(adj,"ADI",ch),"^",5)
	 .s rp=$P(^DHCINAD(adj,"ADI",ch),"^",9)
	 .s inci=+inclb
	 .s code=$p(^INCI(inci,1),"^",1)
	 .s desc=$p(^INCI(inci,1),"^",2)
	 .s buom=$p(^INCI(inci,1),"^",10)
	 .i uom'=buom d
	 ..&sql( select %ID into :fac from  ct_confac where ctcf_frUOm_dr=:uom and ctcf_touom_dr=:buom)
	 ..i SQLCODE s errMsg=..Trans("库存项：<")_desc_..Trans("> 单位换算错误")
	 .q:errMsg'=""
	 .s StkType = "G"
	 .i uom=buom d
	 ..s sp=##class(web.DHCST.Common.AppCommon).FormatSp(sp,HospID,2,StkType)
	 .e  d
	 ..s sp=##class(web.DHCST.Common.AppCommon).FormatSp(sp,HospID,1,StkType)
	 .//s currentSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclb,+$h,uom,HospID,"G","")  //价格发生变化不提示，直接更新调整明细表
	 .//i sp'=currentSp s errMsg="库存项：<"_desc_"> 售价已发生变化"
	 .//q:errMsg'=""
	 .
	 .//检查库存
	 .s AvaQty=##class(web.DHCST.Common.DrugStkCommon).CurInclbAvaQty(inclb,buom)
	 .s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)
	 .s qty=qty*Fac
	 .i AvaQty+qty<0 s errMsg=..Trans("库存项：<")_desc_..Trans("> 可用库存数小于调整数")
	 .q:errMsg'=""
	 q errMsg
}

ClassMethod test() As %String
{
 
 q ..%GetParameter("AppName")
}

/// 保存库存调整单据主表和明细数据
/// Author:zhwh
/// Date:2012-01-08
/// Argu:
///  adj - 库存调整单主表rowid
///  mainData -主表数据串("^"分隔)
///  detailData - 明细数据串("^"分隔)
/// Return:
///   库存调整主表rowid
ClassMethod SaveAdj(adj As %String, mainData As %String, detailData As %String) As %String
{
  i adj="",(mainData="")!(detailData="") q -100  //对新单的判断
  q:(adj'="")&&($p($g(^DHCINAD(adj)),"^",13)="Y") -8
  q:(adj'="")&&($p($g(^DHCINAD(adj)),"^",14)="Y") -9
  s appName=..%GetParameter("AppName")
  i adj'="" q:##class(web.DHCST.Common.AppCommon).Lock(appName_adj)<0 -99
  tstart
  s err=..Update(adj,mainData)
  i +err'>0 trollback  d ..uLock(adj) q -1
  s main=+err
  s err=##class(web.DHCST.DHCINAdjItm).Save(main,detailData)
  i err<0 trollback  d ..uLock(main) q -2
  tcommit
  d ..uLock(main)
  q main
}

// 

ClassMethod jsSelect(Adj As %String) As %String
{
 n (Adj)
 s sql="select *,"
 s sql=sql_"inad_ssusr_dr->ssusr_name userName," 
 s sql=sql_"inad_ssusr_dr userNameId," 
 s sql=sql_"inad_chkusr_dr->ssusr_name chkUserName," 
 s sql=sql_"inad_chkusr_dr chkUserNameId," 
 s sql=sql_"inad_ctloc_Dr->ctloc_desc locDesc,"
 s sql=sql_"inad_ctloc_Dr  locDescId,"
 s sql=sql_"inad_reasonadj_dr->adj_desc reasonDesc,"
 s sql=sql_"inad_scg_dr->scg_desc scgDesc"
 s sql=sql_" from DHC_INAdj where %ID="_Adj 
 //w sql,!
 s xrs=##class(%ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 s colNameStr=""
 s count=0
 s resultString=""
 s colNum=xrs.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=xrs.GetColumnName(i)  //(xrs.GetColumnName(i),"_")
 .e  s colNameStr=colNameStr_"^"_xrs.GetColumnName(i)
 s json = ##class(Code.JsonObj).%New()
 while (xrs.Next())
 {
   s ret=""
   f i=1:1:colNum d
   .s df=xrs.%GetData(i)
   . 
   .i xrs.GetColumnName(i)="INAD_Date",df'="" s df=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(df,"ST")
   .i xrs.GetColumnName(i)="INAD_Time",df'="" s df=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(df,"ST")
   .i xrs.GetColumnName(i)="INAD_ChkDate",df'="" s df=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(df,"ST")
   .i xrs.GetColumnName(i)="INAD_ChkTime",df'="" s df=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(df,"ST")
   .
   .i xrs.GetColumnName(i)="INAD_Remarks" d
   ..s memoDelim=##class(web.DHCST.Common.UtilCommon).MemoDelim()
   ..s df=$lts(df,memoDelim)
   ..s ^zhwh(121)=df
   .
   .i ret="" s ret=df
   .e   s ret=ret_"^"_df
   .
   s tmp=ret
   s count = count+1
   d json.InsertRowData(tmp)
 }
 s resultString = json.getJsonData(colNameStr,count)
 k json
 d xrs.Close()
 q resultString
}

/// creator:yunhaibao
/// createdate:20151119
/// description:库存调整取消审核
/// w ##class(web.DHCST.DHCINAdj).CancelAudit(10000001)
ClassMethod CancelAudit(inadj)
{
	n (inadj)
	q:+inadj="0" ..Trans("调整单ID为空!")
	s inadj=+inadj
 	s Audit=$p(^DHCINAD(inadj),"^",14)
 	q:Audit'="Y" ..Trans("调整单单未审核!")
 	s AdjReasonDr=$p(^DHCINAD(inadj),"^",6)
 	q:AdjReasonDr="" ..Trans("盘点数据,不允许取消审核!")
 	q:..IfMakeMon(inadj)=1 ..Trans("已经生成月报,不能取消审核!")
 	q:..IfHaveAdjPrice(inadj)>0 ..Trans("调整审核时间后,存在已生效调价记录,不允许取消审核!")
 	s Ret=0
 	s Ch=0
 	q:##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_inadj)<0 ..Trans("加锁失败!")
 	tstart
 	s $ZT="Error^DHCSTERROR"
	f  s Ch=$o(^DHCINAD(inadj,"ADI",Ch)) q:(Ch="")!(Ret'=0)  d
	.s inadjrowid=inadj_"||"_Ch
	.s Inclb=$p(^DHCINAD(inadj,"ADI",Ch),"^",1)
	.s Qty=$p(^DHCINAD(inadj,"ADI",Ch),"^",2)
	.s Uom=$p(^DHCINAD(inadj,"ADI",Ch),"^",5)
	.s Inci=+Inclb
	.s Buom=$p(^INCI(Inci,1),"^",10)
	.s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(Uom,Buom)
	.s Qty=Qty*Fac
	.s LocDr=$p(^INCI(Inci,"IL",$p(Inclb,"||",2)),"^",1) 
	.q:LocDr=""
	.q:Inclb=""
	.;恢复库存数据
	.s Ret=##class(web.DHCST.Common.StockHandle).DelIntrs("A",inadjrowid)
	.i Ret'=0 d
	..s Ret=$p(^INCI(Inci,1),"^",2)_"-"_Ret 
	.q:Ret'=0
	i Ret'=0 trollback
	d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_inadj)
	q:Ret'=0 ..Trans("处理明细出错!")_Ret   ;明细未处理ok 
	&sql(UPDATE DHC_INAdj SET INAD_ChkFlag=null,INAD_ChkDate=null,INAD_ChkTime=null,INAD_ChkUSR_DR=null,INAD_State='N',INAD_Completed='N' WHERE INAD_RowId=:inadj)
	i SQLCODE trollback
	q:SQLCODE ..Trans("更新主信息状态失败!")
	tcommit
	q 0
}

/// creator:yunhaibao
/// createdate:20151119
/// description:判断库存调整单是否已做到月报
/// input：库存调整主表id
/// return:0,未生成；1,已生成
ClassMethod IfMakeMon(inadj As %String) As %Library.String
{
	n (inadj)
	q:inadj="" 0
	s loc=$p(^DHCINAD(inadj),"^",16)
	s date=$p(^DHCINAD(inadj),"^",8) ;审核日期
	&sql(select DHCSM_Rowid from DHC_StkMon where DHCSM_CTLOC_DR=:loc and DHCSM_ToDate>=:date)
	q:'SQLCODE 1
	q 0
}

/// creator:yunhaibao
/// createdate:20151223
/// description:判断库存调整单明细数据是否在审核日期后存在调价
/// input：库存调整主表id
/// return:>0 存在
/// w ##class(web.DHCST.DHCINAdj).IfHaveAdjPrice("795")
ClassMethod IfHaveAdjPrice(inadj As %String) As %Library.String
{
	n (inadj)
	q:inadj="" 0
	s priceflag=0
	s inadjdate=$p(^DHCINAD(inadj),"^",8)
	s inadjtime=$p(^DHCINAD(inadj),"^",9)
	s inadjch=""
	f  s inadjch=$o(^DHCINAD(inadj,"ADI",inadjch)) q:(inadjch="")!(priceflag'=0)  d
	.s inadjrowid=inadj_"||"_inadjch
	.s inclb=$p(^DHCINAD(inadj,"ADI",inadjch),"^",1)
	.q:'$d(^DHCINTR(0,"TypePointer","A",inadjrowid))  //台账记录
	.s priceflag=##class(web.DHCST.DHCRetAspAmount).CheckIfHaveAdjPrice(inclb,inadjdate,inadjtime)
	q priceflag
}

/// creator:	yunhaibao
/// createdate:	2017-01-11
/// description:判断库存调整单是否存在台账数据
/// input：		库存调整主表id
/// return:		<0 不允许
/// others:		w ##class(web.DHCST.DHCINAdj).IfCanDeleteAll("795")
ClassMethod IfCanDeleteAll(inadj As %String) As %Library.String
{
	n (inadj)
	q:inadj="" 0
	s adjitm="",candelete=""
	f  s adjitm=$o(^DHCINAD(inadj,"ADI",adjitm)) q:(adjitm="")||(candelete'="")  d
	.s adjitmrowid=inadj_"||"_adjitm
	.i $d(^DHCINTR(0,"TypePointer","A",adjitmrowid)) s candelete=1
	q:candelete'="" -5
	q 0
}

/// Descript:取库存调整相关界面参数配置属性
/// Creater:    yangsj
/// CreateDate: 2020-02-20
/// Table:
/// Input:安全组id,科室id,用户id
/// Output:     
/// Return：调整数量是否允许录入小数
/// w ##class(web.DHCST.DHCINAdj).GetParamProp("142","102","590")
ClassMethod GetParamProp(GroupId As %String, LocId As %String, UserId As %String) As %Library.String
{
    n (GroupId,LocId,UserId)
    ;s ^zdm("GetParamProp")=GroupId_"^"_LocId_"^"_UserId
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=..%GetParameter("AppName")
    s StockAllowDecimal=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"StockAllowDecimal",Param)
    s Data=StockAllowDecimal
    q Data
}

/// 翻译 
/// yangsj 2020-11-05
ClassMethod Trans(Text)
{
	q ##class(websys.Translation).Get("dhcst.inadjaudit.csp",Text)
}

}
