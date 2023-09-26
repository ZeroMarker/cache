Import sqluser

/// 发票管理
Class web.DHCST.DHCINGdRecInv Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 更新入库记录的发票号信息
/// Author:zhwh
/// Date:2012-08-27
/// Argu:
///  ingri -入库明细RowId
///  invNo-发票号
///  invAmt-发票金额
///  invDate-发票日期
/// Return:  
///   0 - success
///   <0 - 失败
ClassMethod UpdateINV(ingri As %String, invNo As %String, invAmt As %String, invDate As %String, sxNo As %String) As %String
{
 n (ingri,invNo,invAmt,invDate,sxNo)
 s ret=0
 s ingr=+ingri
 q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.DHCINGdRec).%GetParameter("AppName")_ingr)<0 -99
	
  i invDate'="" s invDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(invDate)
  s invAmt=+invAmt
  &sql(update dhc_ingdrecitm set initm_invno=:invNo,
     initm_invdate=:invDate,initm_invmoney=:invAmt,
     initm_sxno=:sxNo  where %id=:ingri)
  i SQLCODE'=0 s ret=-1
  d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.DHCINGdRec).%GetParameter("AppName")_ingr)  
  q ret
}

/// 更新入库记录的随货通行单号信息
/// Author:zhwh
/// Date:2012-08-27
/// Argu:
///  ingri -入库明细RowId
///  sxNo -随行单号
/// Return:  
///   0 - success
///   <0 - 失败
ClassMethod UpdateSxNo(ingri As %String, sxNo As %String) As %String
{
	n (ingri,sxNo)
	s ret=0
	s ingr=+ingri
	q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.DHCINGdRec).%GetParameter("AppName")_ingr)<0 -99	
	i invDate'="" s invDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(invDate)
	s invAmt=+invAmt
	&sql(update dhc_ingdrecitm set initm_sxno=:sxNo where %id=:ingri)
	i SQLCODE'=0 s ret=-1
	d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.DHCINGdRec).%GetParameter("AppName")_ingr)  
	q ret
}

/// 检索入库单主记录
/// Author:zhwh
/// Date:2012-08-27
/// Argu: 
///   Loc - 入库科室RowId
///   StartDate-起始日期
///   EndDate -截止日期
///   Vendor-供应商RowId
///   InvNo-发票号
///   SxNo-随行单号
///   Inci-药品RowId
/// Return:
///    入库单信息列表(入库单主表RowId，供应商名称，入库单号，制单日期，制单人，审核日期，审核人，进价总金额，已付款金额，付款结清标志)
Query DHCINGdRecList(qPar As %String, Loc As %String, StartDate As %String, EndDate As %String, Vendor As %String, InvNo As %String, SxNo As %String, Inci As %String) As %Query(ROWSPEC = "ingr:%String,loc:%String,locDesc:%String,vendorName:%String,ingrNo:%String,ingrDate:%String,ingrUserName:%String,auditDate:%String,auditUserName:%String,rpAmt:%String,spAmt:%String,payedAmt:%String,payOverFlag:%String")
{
}

ClassMethod DHCINGdRecListExecute(ByRef qHandle As %Binary, qPar As %String, Loc As %String, StartDate As %String, EndDate As %String, Vendor As %String, InvNo As %String, SxNo As %String, Inci As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 //
 q:Loc="" $$$OK   //科室rowid是必需条件 
 q:StartDate="" $$$OK //起始日期是必需条件 
 q:EndDate="" $$$OK  //截止日期是必需条件 
 i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)

 s sql="select %id ingr,"
 s sql=sql_"ingr_loc_dr loc,"
 s sql=sql_"ingr_loc_dr->ctloc_Desc locDesc,"
 s sql=sql_"ingr_no ingrNo,"
 s sql=sql_"ingr_apcvm_dr vendor,"
 s sql=sql_"ingr_apcvm_dr->apcvm_name vendorName,"
 s sql=sql_"ingr_no ingrNo,"
 s sql=sql_"ingr_createDate createDate,"
 s sql=sql_"ingr_createtime createTime,"
 s sql=sql_"ingr_createuser->ssusr_name createUserName,"
 s sql=sql_"ingr_date auditDate,"
 s sql=sql_"ingr_time auditTime,"
 s sql=sql_"ingr_ssusr_dr->ssusr_name auditUserName"
 s sql=sql_" From dhc_ingdrec"
 s sql=sql_" where ingr_createdate between "_StartDate_" And "_EndDate
 s sql=sql_" and ingr_loc_dr="_Loc
 //w sql,!
 s xrs=##class(%ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 s err=$$$ISERR(sc)
 i err q $$$OK
 
 while (xrs.Next())
 {
	s ingr=xrs.Data("ingr")
	i Vendor'="" continue:Vendor'=xrs.Data("vendor")
	//i InvNo'="" s InvNo=$$ALPHAUP^SSUTIL4(InvNo)
	//i InvNo'="" continue:'$D(^DHCINGR(0,"INVNO",InvNo,ingr))
	i InvNo'="" continue:..CheckInvNo(InvNo,ingr)
	i Inci'="" continue:'$d(^DHCINGR(0,"INCI",Inci,ingr))
	//i SxNo'="" continue:'..IfSxNoExists(SxNo,ingr)
	i SxNo'="" continue:..CheckSxNo(SxNo,ingr)
	
	s tmpAmt=..GetRecAmt(ingr)
	s rpAmt=$P(tmpAmt,"^",1)
	s spAmt=$P(tmpAmt,"^",2)
    s vendorName=xrs.Data("vendorName")
    s ingrNo=xrs.Data("ingrNo")
    s ingrDate=xrs.Data("createDate")
    i ingrDate'="" s ingrDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ingrDate,"ST")
    s ingrUserName=xrs.Data("createUserName")
    s auditDate=xrs.Data("auditDate")
    i auditDate'="" s auditDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(auditDate,"ST")
    s auditUserName=xrs.Data("auditUserName")
    s payedAmt=..PayedAmt(ingr)
    s payOverFlag="N"
    i payedAmt>=rpAmt s payOverFlag="Y"
    s loc=xrs.Data("loc")
    s locDesc=xrs.Data("locDesc")
    
	d OutPutRow1 
 }
 
 Quit $$$OK
OutPutRow1
 s Data=$lb(ingr,loc,locDesc,vendorName,ingrNo,ingrDate,ingrUserName,auditDate,auditUserName,rpAmt,spAmt,payedAmt,payOverFlag)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod DHCINGdRecListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCINGdRecListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DHCINGdRecListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCINGdRecListExecute ]
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

/// 取入库单的进价和售价总金额
/// Author:zhwh
/// Date:2012-08-27
/// Argu:
///  ingr- 入库主表rowid
/// Return:
///  进价金额和售价金额("^"分隔)
ClassMethod GetRecAmt(ingr As %String) As %String
{
 n (ingr)
 &sql( select sum(initm_realtotal),sum(initm_spamt) into :rpAmt,:spAmt
    From dhc_ingdrecitm   where ingri_ingr_parref=:ingr)
 q $G(rpAmt)_"^"_$G(spAmt)
}

/// 取退货单的进价和售价总金额
/// Author:zhwh
/// Date:2012-08-27
/// Argu:
///  ingrt- 退货单主表rowid
/// Return:
///  进价金额和售价金额("^"分隔)
ClassMethod GetRetAmt(ingrt As %String) As %String
{
 n (ingrt)
 &sql( select sum(ingrti_spamt),sum(ingrti_retamount) into :spAmt,:rpAmt 
   From dhc_ingrtitm where ingrti_ingrt_parref=:ingrt)
 q $G(rpAmt)_"^"_$G(spAmt)
}

/// 整张入库单对应的已付款总金额
/// Author:zhwh
/// Date:2012-08-27
/// Argu:
///   ingr -入库单rowid
/// Return:
///  已付款总金额
///  Add:2020-01-19 yangsj 增加一个参数来判断0金额时是否是没有任何付款金额，还是付款金额为0(免费药)
ClassMethod PayedAmt(ingr As %String, FreeFlag As %String = "") As %String
{
  n (ingr,FreeFlag)
  s amt=0
  i FreeFlag="Y" s amt=""
  s ch=0
  f  s ch=$O(^DHCINGR(ingr,"GRI",ch)) q:ch=""  d
  .s ingri=	ingr_"||"_ch
  .s tmpamt=..PayedAmtRecItm(ingri,FreeFlag)
  .s:tmpamt'="" amt=amt+tmpamt
  q amt
}

/// 整张退货单对应的已付款总金额
/// Author:zhwh
/// Date:2012-08-27
/// Argu:
///   ingrt -退货单rowid
/// Return:
///   已付款总金额
///   Add:2020-01-19 yangsj 增加一个参数来判断0金额时是否是没有任何付款金额，还是付款金额为0(免费药)
///   w ##class(web.DHCST.DHCINGdRecInv).PayedAmtRet(530)
ClassMethod PayedAmtRet(ingrt As %String, FreeFlag As %String = "") As %String
{
  n (ingrt,FreeFlag)
  s amt=0
  i FreeFlag="Y" s amt=""
  s ch=0
  f  s ch=$O(^INGRT(ingrt,"DHCGRR",ch)) q:ch=""  d
  .s ingrti=ingrt_"||"_ch
  .s tmpamt=..PayedAmtRetItm(ingrti,FreeFlag)
  .s:tmpamt'="" amt=amt+tmpamt
  q amt
}

/// 结清标志
/// 检查该随行单是否存在于某入库单
/// Author:zhwh
/// Date:2012-08-27
/// Argu:
///  sxNo - 随行单号
///  ingr - 入库主表rowid
/// Return:
/// >0 :Exists
/// 0 : Not Exists
ClassMethod IfSxNoExists(sxNo As %String, ingr As %String) As %String
{
 n (sxNo,ingr)
 q:sxNo="" 0
 s ret=0
 s ch=0
 f  s ch=$o(^DHCINGR(ingr,"GRI",ch)) q:(ch="")!(ret>0)  d
 .s sxno=$P(^DHCINGR(ingr,"GRI",ch),"^",38)	
 .i sxno=sxNo s ret=1 
 q ret
}

/// 入库明细已付金额
/// Author:zhwh
/// Date:2012-08-27
/// Argu:
///   ingri - 入库明细记录rowid
/// ReturN:
///   入库明细已付金额
///   w ##class(web.DHCST.DHCINGdRecInv).PayedAmtRecItm("8173||1")
ClassMethod PayedAmtRecItm(ingri As %String, FreeFlag As %String = "") As %String
{
 n (ingri,FreeFlag)
 s pointer=ingri
 s type="G"
 s payedAmt=0
 i FreeFlag="Y" s payedAmt=""
 s pay=$o(^DHCPAY(0,"TYPEGR",type,pointer,""),-1)  q:pay="" payedAmt
 s ch=$o(^DHCPAY(0,"TYPEGR",type,pointer,pay,""),-1) q:ch="" payedAmt 
 q:$P($G(^DHCPAY(pay)),"^",19)'="Y" payedAmt 
 //q:$P($G(^DHCPAY(pay,"I",ch)),"^",7)'="Y" payedAmt
 s payedAmt=$P($G(^DHCPAY(pay,"I",ch)),"^",4)
 q payedAmt
}

/// 退货明细已付金额
/// Author:zhwh
/// Date:2012-08-27
/// Argu:
///   ingrti - 退货明细记录rowid
/// ReturN:
///   退货明细已付金额
ClassMethod PayedAmtRetItm(ingrti As %String, FreeFlag As %String = "") As %String
{
 n (ingrti,FreeFlag)
 s pay=""
 s sumAmt=0
 i FreeFlag="Y" s sumAmt=""
 f  s pay=$o(^DHCPAY(0,"TYPEGR","R",ingrti,pay)) q:pay=""  d
 .s ch=0
 .f  s ch=$o(^DHCPAY(0,"TYPEGR","R",ingrti,pay,ch)) q:ch=""  d
 ..s payedAmt=$P(^DHCPAY(pay,"I",ch),"^",4)
 ..q:$P($G(^DHCPAY(pay)),"^",19)'="Y"
 ..s sumAmt=sumAmt+payedAmt
 q sumAmt
}

/// 取入库单信息列表(json)
/// Author:gwj
/// Date:2012-09-20
/// Argu:
///  Start - 起始行号
///  Limit - 行数
///  Sort - 排序字段
///  Dir   - 排序方向
///  strPar -  query参数
/// Return:
///  入库单信息列表数据串(json)
///  
ClassMethod jsDHCINGdRec(Start As %String, Limit As %String, Sort As %String, Dir As %String, strPar As %String) As %String
{
 s qPar=Sort_"^"_Dir
 s Loc=$p(strPar,"^",1)
 s StartDate=$p(strPar,"^",2)
 s EndDate=$p(strPar,"^",3)
 s Vendor=$p(strPar,"^",4)
 s InvNo=$p(strPar,"^",5)
 s SxNo=$p(strPar,"^",6)
 s Inci=$p(strPar,"^",7)
 
 s result=##class(%Library.ResultSet).%New("web.DHCST.DHCINGdRecInv:DHCINGdRecList")
 s sc=result.Execute(qPar,Loc, StartDate, EndDate, Vendor, InvNo, SxNo, Inci)
 i $$$ISERR(sc) q ##class(web.DHCSTEXTCOMMON).GetNoJson()  
 d ##class(web.DHCST.Common.Display).RSToJson(result,Sort,Dir,Start,Limit)
 Q ""
}

/// 检查入库单是否存在某发票号
/// Author:zhwh
/// Date:2012-12-18
/// Argu:
/// 	invNo - 发票号
/// 	ingr - 入库单rowid
/// Return:
///  0 -存在
///  <0,>0 - 不存在
ClassMethod CheckInvNo(invNo As %String, ingr As %String) As %String
{
 n (invNo,ingr)
 s match=invNo_"%"
 &sql(select  %id into :rowid from dhc_ingdrecitm  where ingri_ingr_parref=:ingr and initm_invno like :match)
  q SQLCODE
}

/// 检查入库单是否存在某随行单号
/// Author:zhwh
/// Date:2012-12-18
/// Argu:
/// 	invNo - 随行单号
/// 	ingr - 入库单rowid
/// Return:
///  0 -存在
///  <0,>0 - 不存在
ClassMethod CheckSxNo(sxNo As %String, ingr As %String) As %String
{
 n (sxNo,ingr)
 s match=sxNo_"%"
 &sql(select %id into :rowid from dhc_ingdrecitm  where ingri_ingr_parref=:ingr and initm_sxno like :match)
  q SQLCODE
}

}
