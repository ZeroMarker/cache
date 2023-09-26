Import sqluser

Class web.DHCST.DHCINScrap Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTINSCRAP";

/// Descript:	保存/更新报损单信息
/// Creater:	gwj
/// CreateDate:	2012-08-28
/// Table:DHCINScrap,DHC_INSpItm
/// 	 Input:报损单主表rowid,报损人^报损科室^完成标志^报损原因^类组^备注,
/// 	明细id^库存项RowId^批号^效期^厂商RowId^入库单位RowId^入库数量^进价^New售价^随行单号^发票号^发票日期,
/// 	明细id^库存项RowId^批号^效期^厂商RowId^入库单位RowId^入库数量^进价^New售价^随行单号^发票号^发票日期,
/// Output:		
/// Return：
///    >0: 入库主表id(保存成功)
///   -99  ;加锁失败
///   -2   ;生成入库单号失败
///   -3    ;保存入库单失败
///   -4   ;未找到需更新的入库单
///   -5:保存入库单明细失败
///   -7其它：部分明细保存不成功，提示不成功的药品
///   -8:已完成,-9:已审核
ClassMethod Save(INSCP As %String, MainInfo As %String, ListData As %String) As %Library.String
{
	n (INSCP,MainInfo,ListData)
	q:(INSCP'="")&&($p($g(^DHCINSP(INSCP)),"^",12)="Y") -8 //已完成
	q:(INSCP'="")&&($p($g(^DHCINSP(INSCP)),"^",14)="Y") -9 //已审核
	tstart
 	//s $ZT="Error^DHCSTERROR"						;增加错误处理
	s InscpId=..Update(INSCP,MainInfo)  ;增加或更新报损主表信息
	i +InscpId<=0 trollback
	q:+InscpId<=0 InscpId
	s Ret=##class(web.DHCST.DHCINScrapItm).Save(InscpId,ListData)
	;b ;2
	i (+Ret=-6)!(+Ret=-5) trollback
	q:(+Ret=-6)!(+Ret=-5) -5 
	tcommit    ;只要有明细保存成功，则提交事务
	q:+Ret'=0 Ret   ;存在保存失败的明细
	q InscpId
}

/// Descript:	确认完成某报损单
/// Creater:	gwj
/// CreateDate:	2012-09-03
/// Table:DHC_INScrap
/// Input:rowid
/// Output:		
/// Return：0,成功,
/// -1   	;报损单已经完成
/// -3   ;操作失败
/// -99:加锁控制失败
/// 
ClassMethod SetComplete(Rowid As %String) As %Library.String
{
	n (Rowid)
 	;
 	;不能为空项
 	q:Rowid="" ""
 	s appName=..%GetParameter("AppName")
 	q:##class(web.DHCST.Common.AppCommon).Lock(appName_Rowid)<0 -99
 	s CompFlag=$p(^DHCINSP(Rowid),"^",12)
 	i CompFlag="Y" d ..ULock(Rowid) q -1   	;报损单已经完成
 	s Flag="Y"
 	;
 	s Err=0
 	&sql(Update DHC_INScrap set INSCP_Completed=:Flag where INSCP_RowID=:Rowid)
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("SetComplete:DHC_INScrap",Rowid,SQLCODE_":"_%msg)
 	.s Err=-3   ;操作失败
 	.
 	d ..ULock(Rowid)
 	q Err
}

/// Descript:	取消完成某报损单
/// Creater:	gwj
/// CreateDate:	2012-09-03
/// Table:DHC_INScrap
/// Input:rowid
/// Output:		
/// Return：0,成功,
/// -1  ;报损单尚未完成
/// -2	;报损单已经审核，不能取消完成
/// -3  ;操作失败
ClassMethod CancelComplete(Rowid As %String) As %Library.String
{
 n (Rowid)
 ;
 ;不能为空项
 q:Rowid="" ""
 s appName=..%GetParameter("AppName")
 q:##class(web.DHCST.Common.AppCommon).Lock(appName_Rowid)<0 -99
 s CompFlag=$p(^DHCINSP(Rowid),"^",12)
 i CompFlag'="Y" d ..ULock(Rowid) q -1   	;报损单尚未完成
 s AuditFlag=$p(^DHCINSP(Rowid),"^",14)
 i AuditFlag="Y"  d ..ULock(Rowid) q -2		;报损单已经审核，不能取消完成
 s Flag="N"
 ;
 s Err=0
 &sql(Update DHC_INScrap set INSCP_Completed=:Flag where INSCP_RowID=:Rowid)
 i SQLCODE'=0  d
 .s rett=$$ErrorRecord^DHCSTERROR("SetComplete:DHC_INScrap",Rowid,SQLCODE_":"_%msg)
 .s Err=-3   ;操作失败
 .
 d ..ULock(Rowid)
 q Err
}

/// 插入或更新一条报损单主表记录
/// Author:zhwh
/// Date:2012-07-23
/// Argu:
///  inscrap - 报损单主表rowid
///  Data - 主表数据串
/// Return:
///  <0 - failure
///    -99:加锁失败
///    -1:报损人为空
///    -2:科室为空
///    -3:无法获得报损单号
///    
///    
///  >0 - 报损单主表rowid
ClassMethod Update(inscrap As %String, Data As %String) As %String
{
 n (inscrap,Data)
 //s inscrap="10",Data="1^102^^1^1^xsfdx^^"
 s user=$p(Data,"^",1) //报损人rowid
 s loc=$p(Data,"^",2)  //科室rowid
 s comp=$p(Data,"^",3)  //完成标志
 s reason=$p(Data,"^",4) //报损原因
 s scg=$p(Data,"^",5) //库存类组rowid
 s remark=$p(Data,"^",6) //备注
 s scrapNo=$p(Data,"^",7)  //报损单号
 s stkType=..sssCode()  //库存类型
 s d=+$h
 s t=$p($h,",",2)
  
 s appName=..%GetParameter("AppName")
 q:user="" -1 
 q:loc="" -2
 i inscrap'="" q:##class(web.DHCST.Common.AppCommon).Lock(appName_inscrap)<0 -99
 i inscrap="" d
 .s obj=##class(User.DHCINScrap).%New()
 .s obj.INSCPDate=d
 .s obj.INSCPTime=t 
 e  d
 .s obj=##class(User.DHCINScrap).%OpenId(inscrap)
 .d obj.%Reload()
 //
 i scrapNo="" s scrapNo=##class(web.DHCST.Common.AppCommon).GetAppNo(appName,scg,loc)  //报损单号
 i scrapNo="" d ..ULock(inscrap)   q -3
 s obj.INSCPCTLOCDR=##class(User.CTLoc).%OpenId(loc,0)   //科室
 s obj.INSCPSSUSRDR=##class(User.SSUser).%OpenId(user,0)  //用户
 s obj.INSCPReason=##class(User.DHCIncReasonForStockScrap).%OpenId(reason,0)   //原因
 s obj.INSCPSCGDR=##class(User.DHCStkCatGroup).%OpenId(scg,0)  //类组
 s obj.INSCPStkType = stkType  //库存类型  
 s obj.INSCPCompleted=comp   //完成标志
 s obj.INSCPNO=scrapNo   //单号
 s obj.INSCPRemarks=remark  //备注
 s sc=obj.%Save()
 i inscrap'="" d ..ULock(inscrap)
 i $$$ISERR(sc) q -5
 q obj.%Id()
}

/// 根据RowId取得一条报损单主表记录
/// Author: gwj
/// Date:2012-08-30
/// Argu: 
///  inscrp - 报损单主表
/// Return:
///  记录数据串
ClassMethod Select(inscrp As %String) As %String
{
 n (inscrp)
 q:+inscrp=0 ""
 s result=""
 s INSCPNO=$p(^DHCINSP(inscrp),"^",1)
 s INSCPDate=$p(^DHCINSP(inscrp),"^",2)
 s INSCPTime=$p(^DHCINSP(inscrp),"^",3)
 s INSCPReason=$p(^DHCINSP(inscrp),"^",4)
 s ReasonDesc=$p(^INC("ADJ",INSCPReason),"^",2)
 s INSCPLOC=$p(^DHCINSP(inscrp),"^",5)
 s:INSCPLOC'="" LocDesc=$p(^CTLOC(INSCPLOC),"^",2)
 s INSCPUSRid=$p(^DHCINSP(inscrp),"^",6)
 s:INSCPUSRid'="" INSCPUSR=$p(^SSU("SSUSR",INSCPUSRid),"^",2)
 s ChkDate=$p(^DHCINSP(inscrp),"^",7)
 s ChkTime=$p(^DHCINSP(inscrp),"^",8)
 s ChkUsrid=$p(^DHCINSP(inscrp),"^",9)
 s:ChkUsrid'="" ChkUsr=$p(^SSU("SSUSR",ChkUsrid),"^",2)
 s INSCPStat=$p(^DHCINSP(inscrp),"^",10)
 s Remarks=$p(^DHCINSP(inscrp),"^",11)
 s Completed=$p(^DHCINSP(inscrp),"^",12)
 s StkGrp=""
 s INSCPSCG=$p(^DHCINSP(inscrp),"^",13)
 s:INSCPSCG'="" StkGrp=$p(^DHCSCG(INSCPSCG),"^",2)
 s ChkFlag=$p(^DHCINSP(inscrp),"^",14)
 s StkType=$p(^DHCINSP(inscrp),"^",15)
 //q:StkType'=..sssCode() ""
 s result=$G(INSCPNO)_"^"_$G(INSCPDate)_"^"_$G(INSCPTime)_"^"_$G(INSCPReason)_"^"_$G(ReasonDesc)
 s result=result_"^"_$G(INSCPLOC)_"^"_$G(LocDesc)_"^"_$G(INSCPUSRid)_"^"_$G(INSCPUSR)_"^"_$G(ChkDate)_"^"_$G(ChkTime)
 s result=result_"^"_$G(ChkUsrid)_"^"_$G(ChkUsr)_"^"_$G(INSCPStat)_"^"_$G(Remarks)_"^"_$G(Completed)
 s result=result_"^"_$G(INSCPSCG)_"^"_$G(StkGrp)_"^"_$G(ChkFlag)
 q result
}

/// 执行删除
/// Author: zhwh
/// Date:2012-07-23
/// Argu: 
///  inscrp - 报损单主表
/// Return:
///  0 - success
///  <0 - failure
ClassMethod Delete(inscrp As %String) As %String
{
  n (inscrp)
  s appName=..%GetParameter("AppName")
  //锁定
  q:##class(web.DHCST.Common.AppCommon).Lock(appName_inscrp)<0 -99
  //检查是否允许
  s allowdel=..AllowDel(inscrp)
  i allowdel<0 d ..ULock(inscrp) q allowdel
  ts
  &sql(delete from dhc_inscrap where %ID=:inscrp)
  d ..ULock(inscrp)
  i SQLCODE'=0  tro  q -3
  tc
  q 0
}

/// 是否允许删除
/// Author: zhwh
/// Date:2012-07-23
/// Argu: 
///  inscrp - 报损单主表
/// Return:
///  0 - success
///  <0 - failure
ClassMethod AllowDel(inscrp As %String) As %String
{
 n (inscrp)
 s obj=##class(User.DHCINScrap).%OpenId(inscrp,0)	
 d obj.%Reload()
 s comp=obj.INSCPCompleted
 q:comp="Y" -1  //已经完成
 s chkFlag=obj.INSCPChkFlag
 q:chkFlag="Y" -2  //已经审核
 q 0
}

/// 审核报损单
/// Author:zhwh
/// Date:2012-07-23
/// Argu:
///  inscrp - 报损单主表rowid
///  user - 审核人
///  Loc - 科室rowid
/// Return:
/// 0 -success
/// <0  - failure
/// w ##class(web.DHCST.DHCINScrap).Audit(394,1,102)
ClassMethod Audit(inscrap As %String, user As %String, Loc As %String) As %String
{
  n (inscrap,user,Loc)
  q:inscrap="" -1
  q:user="" -2
  s AuditFlag=$p(^DHCINSP(inscrap),"^",14)
  q:AuditFlag="Y" -3		;报损单已经审核
  //加锁     
  s appName=..%GetParameter("AppName")
  q:##class(web.DHCST.Common.AppCommon).Lock(appName_inscrap)<0 q -99
  
  s errMsg=..ChkScrpItmData(inscrap)
  i errMsg'="" d ..ULock(inscrap) q -100_"^"_errMsg
  //
  ts  ;开始一个事务
   //设置状态
  s ret=..SetAuditFlag(inscrap,user)
  i ret<0  tro  d ..ULock(inscrap)  q "-101"
  
  //处理库存和台账
  s trType="D"
  s TrNo=$p(^DHCINSP(inscrap),"^",1)
  s ScrapLoc=$p(^DHCINSP(inscrap),"^",5)
  s HospID=""
  i ScrapLoc'="" s HospID=$p($g(^CTLOC(ScrapLoc)),"^",22)
  s err=0
  s csub="0" f  s csub=$o(^DHCINSP(inscrap,"I",csub)) q:(csub="")!(err<0)  d
  .s inclb=$p(^DHCINSP(inscrap,"I",csub),"^",1)
  .s uom=$p(^DHCINSP(inscrap,"I",csub),"^",2)
  .s qty=$p(^DHCINSP(inscrap,"I",csub),"^",3)
  .//yunhaibao20151204,报损单审核时,以当前格式化后的进售价再次更新子表
  .s buomid=$p(^INCI(+inclb,1),"^",10)
  .s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclb,+$h,uom,HospID,..sssCode(),"")
  .s rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(inclb,uom,HospID,..sssCode(),+$h,"")
  .s spAmt=sp*qty
  .s rpAmt=rp*qty
  .s spAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(spAmt,HospID)
  .s rpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(rpAmt,HospID)
  .s $p(^DHCINSP(inscrap,"I",csub),"^",4)=rp
  .s $p(^DHCINSP(inscrap,"I",csub),"^",5)=rpAmt
  .s $p(^DHCINSP(inscrap,"I",csub),"^",8)=sp
  .s $p(^DHCINSP(inscrap,"I",csub),"^",9)=spAmt
  .s Pointer=inscrap_"||"_csub
  .s trans=trType
  .s trans=trans_"^"_TrNo
  .s trans=trans_"^"_inclb
  .s trans=trans_"^"_-qty
  .s trans=trans_"^"_uom
  .s trans=trans_"^"_+sp
  .s trans=trans_"^"_user
  .s trans=trans_"^"_Pointer
  .s trans=trans_"^"_+rp
  .s trans=trans_"^"_-rpAmt
  .s trans=trans_"^"_-spAmt
  .
  .s inci=+inclb
  .s buom=$p(^INCI(inci,1),"^",10)
  .s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)
  .s bqty=qty*fac   //换算成基本单位的数量
  .
  .s ret=##class(web.DHCST.Common.StockHandle).UpdateStock(inclb,-bqty)   //处理库存
  .i ret<0 tro   s err=-102 q
  .
  .s ret=##class(web.DHCST.Common.StockHandle).IntoTrans(trans)  //插入台账数据
  .i ret<0  tro   s err=-103  q 
  .
  //提交
  i err=0  tc  
  //解锁
  d ..ULock(inscrap)   
  q err
}

/// 报损单状态维护:
/// Author:zhwh
/// Date:2012-07-23
/// Argu:
///  inscrap - 主表rowid
///  User  -用户rowid
/// Return:
///   0 - success
///   <0 - failure
///   
ClassMethod SetAuditFlag(inscrap As %String, User As %String) As %String
{
 n (inscrap,User)
 q:$g(inscrap)="" -1
 q:$g(User)="" -2
 
 s sdate=$p($h,",",1)
 s stime=$p($h,",",2)    
 s chkFlag="Y"
 s obj=##class(User.DHCINScrap).%OpenId(inscrap)
 d obj.%Reload()
 s obj.INSCPChkDate=sdate
 s obj.INSCPChkTime=stime
 s obj.INSCPChkFlag=chkFlag
 d obj.INSCPChkUSRDRSetObjectId(User)
 s sc=obj.%Save()
 i $$$ISERR(sc) q -3
 q 0
}

/// 解锁
/// Author:zhwh
/// Date:2012-07-23
/// Argu:
///   inscap - 报损单主表rowid
ClassMethod ULock(inscap As %String)
{
 q:inscap="" 
 s appName=..%GetParameter("AppName")
 d ##class(web.DHCST.Common.AppCommon).UnLock(appName_inscap)	
 q
}

/// 取报损单主表记录数据(json)
/// Author:zhwh
/// Date:2012-07-23
/// Argu:
///  Start - 起始行号
///  Limit - 行数
///  Sort - 排序字段
///  Dir   - 排序方向
///  strPar -  query参数
/// Return:
///  报损单主表记录数据串(json)
///  
ClassMethod jsDHCINSpM(Start As %String, Limit As %String, Sort As %String, Dir As %String, strPar As %String) As %String
{

 ;s strPar="2012-01-01^2012-11-01^102^^"
 s qPar=Sort_"^"_Dir
 s StartDate=$p(strPar,"^",1)  //	起始日期
 s EndDate=$p(strPar,"^",2)   //截止日期
 s Loc=$p(strPar,"^",3)  //科室rowid
 s CompletedFlag=$p(strPar,"^",4)  //完成标志
 s AuditFlag=$p(strPar,"^",5)  //审核标志
 
 s result=##class(%Library.ResultSet).%New("web.DHCST.DHCINScrap:DHCINSpM")
 s sc=result.Execute(qPar,StartDate,EndDate,Loc,CompletedFlag,AuditFlag)
 i $$$ISERR(sc) q ""

 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
 //w colNameStr,!
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
  //w tmp,!		
  d json.InsertRowData(tmp)
 }
 d result.Close()
 s resultString = json.getJsonData(colNameStr,count)
 k json
 Q resultString
}

/// 检索主信息
/// Author:zhwh
/// Date:2012-07-23
/// Argu:
///   StartDate  -起始日期，，，””=”
///   EndDate -截止日期
///   Loc -科室RowId
///   CompleteFlag-状态=
///   AuditFlag - ，完成标志
Query DHCINSpM(qPar As %String, StartDate As %String, EndDate As %String, Loc As %String, CompleteFlag As %String = "", AuditFlag As %String = "") As %Query(ROWSPEC = "inscp:%String,no:%String,date:%String,time:%String,user:%String,userName:%String,loc:%String,locDesc:%String,chkDate:%String,chkTime:%String,chkUser:%String,chkUserName:%String,completed:%String,chkFlag :%String,stkType:%String,scg:%String,scgDesc:%String,reason:%String,reasonDesc:%String,remark:%String,spAmt:%Double,rpAmt:%Double")
{
}

ClassMethod DHCINSpMExecute(ByRef qHandle As %Binary, qPar As %String, StartDate As %String, EndDate As %String, Loc As %String, CompleteFlag As %String = "", AuditFlag As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0) 
 s Sort=$p(qPar,"^",1)
 s Dir=$p(qPar,"^",2)
 i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 i AuditFlag="Y" s CompleteFlag="Y"
 s sql=" select %ID inscp,"
 s sql=sql_"inscp_no xNo,"
 s sql=sql_"inscp_date d,"
 s sql=sql_"inscp_time t,"
 s sql=sql_"inscp_ssusr_dr xUser,"
 s sql=sql_"inscp_ssusr_dr->ssusr_name userName,"
 s sql=sql_"inscp_ctloc_dr loc,"
 s sql=sql_"inscp_ctloc_dr->ctloc_desc locDesc,"
 s sql=sql_"inscp_chkdate chkDate,"
 s sql=sql_"inscp_chktime chkTime,"
 s sql=sql_"inscp_chkusr_dr chkUser,"
 s sql=sql_"inscp_chkusr_dr->ssusr_name chkUserName,"
 s sql=sql_"nvl(inscp_completed,'N') completed,"
 s sql=sql_"nvl(inscp_chkflag,'N') chkFlag,"
 s sql=sql_"inscp_stktype stkType,"
 s sql=sql_"inscp_scg_dr scg,"
 s sql=sql_"inscp_scg_dr->scg_desc scgDesc,"
 s sql=sql_"inscp_reason reason,"
 s sql=sql_"inscp_reason->REASON_ScrapDesc reasonDesc,"
 s sql=sql_"INSCP_Remarks remark"
 s sql=sql_" From dhc_inscrap"
 s sql=sql_" where INSCP_Date between "_StartDate_" And "_EndDate
   
 s Dir=$$ALPHAUP^SSUTIL4(Dir)
 s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
 
 s orderFieldName=""
 s Sort=$$ALPHAUP^SSUTIL4(Sort)
 s:Sort="DATE" orderFieldName="d"
 s:Sort="CHKDATE" orderFieldName="chkDate"
 s:Sort="USER" orderFieldName="xUser"
 s:Sort="CHKUSER" orderFieldName="chkUser"
 s:Sort="NO" orderFieldName="xNo"

 i orderFieldName'="" d
 .s sql=sql_" Order By "_orderFieldName_" "_Dir

 //w sql,!
 s xrs=##class(%Library.ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 i $$$ISERR(sc) q $$$OK
 while (xrs.Next()) 
 {
   	  
 s inscp=xrs.Data("inscp")
 s no=xrs.Data("xNo")
 s date=xrs.Data("d")
 i date'="" s date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date,"ST")
 s time=xrs.Data("t")
 i time'="" s time=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(time,"ST")
 s user=xrs.Data("xUser")
 s userName=xrs.Data("userName")
 s loc=xrs.Data("loc")
 continue:loc'=Loc
 s locDesc=xrs.Data("locDesc")
 s chkDate=xrs.Data("chkDate")
 i chkDate'="" s chkDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(chkDate,"ST")
 s chkTime=xrs.Data("chkTime")
 i chkTime'="" s chkTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(chkTime,"ST")
 s chkUser=xrs.Data("chkUser")
 s chkUserName=xrs.Data("chkUserName")
 s completed=xrs.Data("completed")
 i CompleteFlag'="" continue:CompleteFlag'=completed
 s chkFlag =xrs.Data("chkFlag")
 i AuditFlag'="" continue:AuditFlag'=chkFlag
 
 s stkType=xrs.Data("stkType")
 continue:stkType'=..sssCode()
 s scg=xrs.Data("scg")
 s scgDesc=xrs.Data("scgDesc")	 
 s reason=xrs.Data("reason")	 
 s reasonDesc=xrs.Data("reasonDesc")	 
 s remark=xrs.Data("remark")
 s spamt=0
 s rpamt=0
 &SQL(SELECT sum(INSPI_RpAmt),sum(INSPI_SpAmt) INTO :rpamt,:spamt FROM DHC_INSpItm WHERE INSPI_Parref=:inscp)
 d OutPutRow 
 } 
 Quit $$$OK
OutPutRow
 s Data=$lb(inscp,no,date,time,user,userName,loc,locDesc,chkDate,chkTime,chkUser,chkUserName,completed,chkFlag ,stkType,scg,scgDesc,reason,reasonDesc,remark,spamt,rpamt)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod DHCINSpMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCINSpMExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DHCINSpMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCINSpMExecute ]
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

/// 报损原因
/// Author:zhwh
/// Date:2012-07-23
/// 
Query ReasonForAdj() As %SQLQuery(CONTAINID = 1)
{
 select %ID RowId,ADJ_Desc Description  From INC_ReasonForAdjustment
}

/// 取报损单主表的数据(json)
/// Author:zhwh
/// Date:2013-01-14
/// Argu:
/// 		inscrap -主表rowid
/// Return:
///  主表的数据(json)
ClassMethod jsSelect(inscrap As %String) As %String
{
 n (inscrap)
 
 s sql="select *,"
 s sql=sql_"inscp_ctloc_dr->ctloc_desc locDesc," 
 s sql=sql_"inscp_scg_dr->scg_desc scgDesc," 
 s sql=sql_"inscp_ssusr_dr->ssusr_name userName,"
 s sql=sql_"inscp_chkusr_dr->ssusr_name chkUserName,"
 s sql=sql_"inscp_reason->REASON_ScrapDesc reason"
 s sql=sql_" from dhc_inscrap where %ID="_inscrap 
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
   .i xrs.GetColumnName(i)="INSCP_Date",df'="" s df=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(df,"ST")
   .i xrs.GetColumnName(i)="INSCP_Time",df'="" s df=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(df,"ST")
   .i xrs.GetColumnName(i)="INSCP_ChkDate",df'="" s df=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(df,"ST")
   .i xrs.GetColumnName(i)="INSCP_ChkTime",df'="" s df=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(df,"ST")
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

/// 检查库存报损单数据(一般在"审核"前执行该操作)
/// Author:LiangQiang
/// Date:2014-01-16
/// Argu:
///     inscrap - 库存报损单主表rowid
/// Return:
///    "" -数据合法
///    非空 -  错误信息
ClassMethod ChkScrpItmData(inscrap As %String) As %String
{
	 n (inscrap)
	 s errMsg=""
	 s ch=0
	 f  s ch=$O(^DHCINSP(inscrap,"I",ch)) q:(ch="")!(errMsg'="")  d
	 .s inclb=$P(^DHCINSP(inscrap,"I",ch),"^",1)
	 .s qty=$P(^DHCINSP(inscrap,"I",ch),"^",3)
	 .s uom=$P(^DHCINSP(inscrap,"I",ch),"^",2)
     .s inci=+inclb
	 .s desc=$p(^INCI(inci,1),"^",2)
	 .s buom=$p(^INCI(inci,1),"^",10)
	 .i uom'=buom d
	 ..&sql( select %ID into :fac from  ct_confac where ctcf_frUOm_dr=:uom and ctcf_touom_dr=:buom)
	 ..i SQLCODE s errMsg=..Trans("库存项：<")_desc_..Trans("> 单位换算错误")
	 .q:errMsg'=""
	 .//检查库存
	 .s AvaQty=##class(web.DHCST.Common.DrugStkCommon).CurInclbAvaQty(inclb,buom)
	 .s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)
	 .s qty=qty*Fac
	 .i AvaQty-qty<0 s errMsg=..Trans("库存项：<")_desc_..Trans("> 可用库存数小于调整数")
	 .q:errMsg'=""
	 q errMsg
}

/// Descript:取库存保存相关界面参数配置属性
/// Creater:    yangsj
/// CreateDate: 2021-04-17
/// Table:
/// Input:安全组id,科室id,用户id
/// Output:     
/// Return：报损数量是否允许录入小数
/// w ##class(web.DHCST.DHCINScrap).GetParamProp("142","102","590")
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
	q ##class(websys.Translation).Get("dhcst.ingdretaudit.csp",Text)
}

}
