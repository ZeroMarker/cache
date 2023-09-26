Class web.DHCST.LocItmMoveInfo Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 取动销记录数据(json)
/// Author:zhwh
/// Date:2012-07-31
/// Argu:
/// Start-起始行
/// Limit-每页行数
/// Sort-排序字段名称
/// Dir- 排序方向
/// StrPar-查询参数(科室rowid,起始日期,起始时间,截止日期,截止时间,类组RowId,分类RowId,药学分类(大类RowId,子类RowId,小类RowId))
/// Return:
/// 数据串(json)
/// LastUpdate:yunhaibao20151116,添加新药学分类,以及查询修改为write形式(防止超长)
/// w ##class(web.DHCST.LocItmMoveInfo).jsLocItmMoveInfo(0,30,"","","102^2016-01-17^^2016-02-16^^1^^,,^29",590)
ClassMethod jsLocItmMoveInfo(Start As %String, Limit As %String, Sort As %String, Dir As %String, StrPar As %String, User As %String = "") As %String
{
	n (Start,Limit,Sort,Dir,StrPar,User,%session) 	
	s $zt="ErrorjsLocItmMoveInfo"	
	s qPar=Sort_"^"_Dir
	s Loc=$P(StrPar,"^",1)
	s StartDate=$P(StrPar,"^",2)
	s StartTime=$P(StrPar,"^",3)
	s EndDate=$P(StrPar,"^",4)
	s EndTime=$P(StrPar,"^",5)
	s SCG=$P(StrPar,"^",6)
	s:SCG="" SCG=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStrNew(User,..sssCode())  //用户类组串
	s INCSC=$P(StrPar,"^",7)
	s pCatStr=$P(StrPar,"^",8)
	s newCatRowid=$P(StrPar,"^",9)
	s User=$G(User)
	s:StartTime="" StartTime="00:00:00"
	s:EndTime="" EndTime="23:59:59"
	s result=##class(%Library.ResultSet).%New("web.DHCST.LocItmMoveInfo:LocItmMoveInfo")
	s sc=result.Execute(qPar,Loc,StartDate,StartTime,EndDate,EndTime,SCG,INCSC,pCatStr,newCatRowid)
	q:$$$ISERR(sc) ##class(web.DHCSTEXTCOMMON).GetNoJson()
	d ##class(web.DHCST.Common.Display).RSToJson(result,Sort,Dir,Start,Limit)
	q ""
ErrorjsLocItmMoveInfo
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
}

/// 检索科室内项目的动销情况信息
/// Author：zhwh
/// Date:202-07-30
/// Argu:
/// qPar -查询参数(排序字段^排序方向)
/// Loc - 科室rowoid
/// StartDate - 起始日期
/// StartTime -起始时间
/// EndDate - 截止日期
/// EndTime - 截止时间
/// SCG - 类组rowid
/// INCSC  -分类rowid
/// pCatStr -药学分类Rowid串(大类Rowid^子类Rowid^小类Rowid)
Query LocItmMoveInfo(qPar As %String, Loc As %String, StartDate As %String, StartTime As %String, EndDate As %String, EndTime As %String, SCG As %String, INCSC As %String, pCatStr As %String, newCatRowid As %String) As %Query(ROWSPEC = "incil:%String,code:%String,desc:%String,spec:%String,manf:%String,OutQty:%String,pUomDesc:%String,sumOutAmt:%String,sumOutRpAmt:%String,InQty:%String,sumInAmt:%String,sumInRpAmt:%String,sbDesc:%String,currStkQty:%String")
{
}

ClassMethod LocItmMoveInfoExecute(ByRef qHandle As %Binary, qPar As %String, Loc As %String, StartDate As %String, StartTime As %String, EndDate As %String, EndTime As %String, SCG As %String, INCSC As %String, pCatStr As %String, newCatRowid As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 s Sort=$p(qPar,"^",1)
 s Dir=$p(qPar,"^",2)
 
 q:Loc="" $$$OK
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 
 s HospID=$p(^CTLOC(Loc),"^",22)
 
 i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 
 i StartTime[":" s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
 i EndTime[":" s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
 
 s Sort=$p(qPar,"^",1)
 s Dir=$p(qPar,"^",2)
 ; 
 s sql="select incil_inci_parref inci,"
 s sql=sql_"incil_rowid incil,"
 s sql=sql_"incil_inci_parref->inci_incsc_dr incsc,"
 s sql=sql_"incil_inci_parref->inci_code code,"
 s sql=sql_"incil_inci_parref->inci_desc descx,"
 s sql=sql_"incil_logqty logQty,"
 //s sql=sql_"incil_incsb_dr->incsb_desc sbDesc,"
 //s sql=sql_"incil_inci_parref->inci_notuseflag NotUseFlag,"
 s sql=sql_"incil_inci_parref->inci_ctuom_purch_dr pUom,"
 s sql=sql_"incil_inci_parref->inci_ctuom_purch_dr->ctuom_desc pUomDesc,"
 s sql=sql_"incil_inci_parref->inci_ctuom_dr bUom,"
 s sql=sql_"incil_inci_parref->inci_ctuom_dr->ctuom_desc bUomDesc"
 s sql=sql_" from inc_itmloc"
 s sql=sql_" where incil_ctloc_dr="_Loc
 
 i INCSC'="" d
 .s sql=sql_" and incil_inci_parref->inci_incsc_dr="_INCSC
 
 s orderFieldName=""
 s Sort=$$ALPHAUP^SSUTIL4(Sort)
 s:Sort="CODE" orderFieldName="code"
 s:Sort="DESC" orderFieldName="descx"
 ;s:Sort="" orderFieldName=""
 s Dir=$$ALPHAUP^SSUTIL4(Dir)
 s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
 i orderFieldName'="" d
 .s sql=sql_" Order By "_orderFieldName_" "_Dir
 s xrs=##class(%ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 if $$$ISERR(sc) q $$$OK  
 
 while (xrs.Next())
 {
  s incil=xrs.Data("incil") 
  s inci=+incil
  s incsc=xrs.Data("incsc") 
  s scg=$o(^DHCSCG("STKCAT",incsc,""))
  //i SCG'="" continue:scg'=SCG
  i SCG'="" continue:("^"_SCG_"^")'[("^"_scg_"^")
  s grpType=""
  i scg'="" s grpType=$p($g(^DHCSCG(scg)),"^",3)
  i grpType'="" continue:grpType'=..sssCode()
  //s thePcats=##class(web.DHCST.Common.DrugInfoCommon).GetDrugPhcCat(+incil) //药学分类的过滤
  //s phccat=$p(pCatStr,",",1)
  //s phcsubcat=$p(pCatStr,",",2)
  //s phcmincat=$p(pCatStr,",",3)
  //i phccat'="" continue:phccat'=$P(thePcats,"^",1) 
  //i phcsubcat'="" continue:phcsubcat'=$P(thePcats,"^",3) 
  //i phcmincat'="" continue:phcmincat'=$P(thePcats,"^",5) 
  s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(inci)
  s PhaCatAlls=$p(PhaCatAllstr,"^",1)
  s PhaCatAllDesc=$p(PhaCatAllstr,"^",2)
  s retflag=##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(newCatRowid,PhaCatAlls)
  continue:(newCatRowid'="")&&(retflag=0) //药学多级分类
  //s sbDesc=xrs.Data("sbDesc")  //货位
  s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") 
  s stkbinstr=$p(stkbinret,":",2)
  s sbDesc=stkbinstr  //货位
  s bUom=xrs.Data("bUom") 
  s pUom=xrs.Data("pUom")
  s pUomDesc=xrs.Data("pUomDesc")
  s code=xrs.Data("code") 
  s desc=xrs.Data("descx") 

  s sumOutQty=0,sumOutAmt=0,sumOutRpAmt=0
  s sumInQty=0,sumInAmt=0,sumInRpAmt=0

  s types="G^R^T^K^P^Y^F^H^S^Z^A^D"
  f i=1:1:$l(types,"^") d
  .s type=$p(types,"^",i)
  .s statType=..GetInOut(type)
  .
  .f dd=StartDate:1:EndDate  d
  ..s intr=""
  ..f  s intr=$o(^DHCINTR(0,"ILTYPEDATE",incil,type,dd,intr)) q:intr=""  d
  ...s trTime=$p(^DHCINTR(intr),"^",3)
  ...i dd=StartDate q:(trTime<StartTime)&&(StartTime'="")
  ...i dd=EndDate q:(trTime>EndTime)&&(EndTime'="")
  ...s qty=$p(^DHCINTR(intr),"^",6)
  ...s amt=$p(^DHCINTR(intr),"^",8)   //售价金额
  ...//
  ...s rpAmt=$p(^DHCINTR(intr),"^",17)   //进价金额 
  ...s uom=$p(^DHCINTR(intr),"^",10)
  ...s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,bUom)
  ...s qty=qty*fac
  ...
  ...
  ...i statType="OUT" d
  ....s sumOutQty=sumOutQty+qty
  ....s sumOutAmt=sumOutAmt+amt
  ....s sumOutRpAmt=sumOutRpAmt+rpAmt
  ...
  ...i statType="IN" d
  ....s sumInQty=sumInQty+qty
  ....s sumInAmt=sumInAmt+amt
  ....s sumInRpAmt=sumInRpAmt+rpAmt
  ...

  continue:(sumOutQty=0)&(sumInQty=0)  //没有进、出记录，认为是没有动销
  s currStkQty=##class(web.DHCST.Common.DrugStkCommon).IL(inci,Loc,+$h)
  
  s pFac=##class(web.DHCST.Common.UtilCommon).UOMFac(pUom,bUom)
  s OutQty=sumOutQty/pFac
  s InQty=sumInQty/pFac
  s currStkQty=currStkQty/pFac
  s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
  s manf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci),"^",3)
  d OutPutRow

 }

 Quit $$$OK

OutPutRow
 s Data=$lb(incil,code,desc,spec,manf,OutQty,pUomDesc,sumOutAmt,sumOutRpAmt,InQty,sumInAmt,sumInRpAmt,sbDesc,currStkQty)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod LocItmMoveInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocItmMoveInfoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod LocItmMoveInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocItmMoveInfoExecute ]
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

/// 取业务类型
/// Author:zhwh
/// Date:2012-07-31
/// Argu:
/// type - 业务类型代码(DHC_INTRANS.INTR_Type)
/// Return:
///  类型名称(IN-增加，OUT-减少)
ClassMethod GetInOut(type As %String) As %String
{
 n (type)
 i type="G" q "IN"
 i type="R" q "OUT"
 i type="T" q "OUT"
 i type="K" q "IN"
 i type="F" q "OUT"
 i type="H" q "IN"
 i type="S" q "OUT"
 i type="Z" q "IN"
 i type="P" q "OUT"
 i type="Y" q "IN"
 i type="A" q "IN"
 i type="D" q "OUT"
 q "IN"
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("LocItmMoveInfo"))
}

}
