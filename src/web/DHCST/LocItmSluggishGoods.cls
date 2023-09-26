Import sqluser

Class web.DHCST.LocItmSluggishGoods Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 取呆滞记录数据串(json)
/// Author:zhwh
/// Date:2012-07-30
/// Argu:
/// Start
/// Limit
/// Sort
/// Dir
/// StrPar
/// Return:
/// 呆滞记录数据串(json)
/// w ##class(web.DHCST.LocItmSluggishGoods).jsLocItmSluggishGoods(0,30,"","","102^2016-03-15^2016-04-14^T$",590)
ClassMethod jsLocItmSluggishGoods(Start As %String, Limit As %String, Sort As %String, Dir As %String, StrPar As %String, User As %String) As %String
{
  n (Start,Limit,Sort,Dir,StrPar,User,%session)
  s $zt="ErrorjsLocItmSluggishGoods"
  s qPar=Sort_"^"_Dir
  s Loc=$p(StrPar,"^",1)
  s StartDate=$p(StrPar,"^",2)
  s EndDate=$p(StrPar,"^",3)
  s BusinessTypes=$p(StrPar,"^",4)
  s result=##class(%Library.ResultSet).%New("web.DHCST.LocItmSluggishGoods:LocItmSluggishGoods")
  s sc=result.Execute(qPar,Loc,StartDate,EndDate,BusinessTypes,User)	
  i $$$ISERR(sc) q ##class(web.DHCSTEXTCOMMON).GetNoJson() 
  d ##class(web.DHCST.Common.Display).RSToJson(result,Sort,Dir,Start,Limit) 
  Q ""

ErrorjsLocItmSluggishGoods
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
}

/// 查询某科室一段日期范围内的业务呆滞情况
/// 
/// Author:zhwh
/// Date:2012-07-30
/// Argu:
///  Loc - 科室RowId
///  StartDate -业务起始日期
///  EndDate - -业务截止日期
///  BusinessTypes - 业务类型与呆滞参照数("T$100,P$200")
/// 
Query LocItmSluggishGoods(qPar As %String, Loc As %String, StartDate As %String, EndDate As %String, BusinessTypes As %String, User As %String = "") As %Query(ROWSPEC = "inclb:%String,code:%String,desc:%String,spec:%String,manf:%String,batNo:%String,expDate:%String,vendor:%String,stkUom:%String,stkQty:%String,avaQty:%String,sp:%String,sbDesc:%String,LastImpDate:%String,LastTrOutDate :%String,LastTrInDate:%String,LastIpDate:%String,LastOpDate:%String")
{
}

ClassMethod LocItmSluggishGoodsExecute(ByRef qHandle As %Binary, qPar As %String, Loc As %String, StartDate As %String, EndDate As %String, BusinessTypes As %String, User As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:Loc="" $$$OK
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK 
 s HospID=$p(^CTLOC(Loc),"^",22) 
 i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 s Sort=$p(qPar,"^",1)
 s Dir=$p(qPar,"^",2)
 ; 
 s sql="select incil_inci_parref inci,"
 s sql=sql_"incil_rowid incil,"
 s sql=sql_"incil_inci_parref->inci_code code,"
 s sql=sql_"incil_inci_parref->inci_desc descx,"
 s sql=sql_"incil_logqty logQty,"
 //s sql=sql_"incil_incsb_dr->incsb_desc sbDesc,"
 s sql=sql_"incil_inci_parref->inci_notuseflag NotUseFlag,"
 s sql=sql_"incil_inci_parref->inci_ctuom_purch_dr pUom,"
 s sql=sql_"incil_inci_parref->inci_ctuom_purch_dr->ctuom_desc pUomDesc,"
 s sql=sql_"incil_inci_parref->inci_ctuom_dr bUom,"
 s sql=sql_"incil_inci_parref->inci_ctuom_dr->ctuom_desc bUomDesc"
 s sql=sql_" from inc_itmloc"
 s sql=sql_" where incil_ctloc_dr="_Loc
 
 s orderFieldName=""
 s Sort=$$ALPHAUP^SSUTIL4(Sort)
 s:Sort="CODE" orderFieldName="code"
 s:Sort="DESC" orderFieldName="descx"
 ;s:Sort="" orderFieldName=""
 s Dir=$$ALPHAUP^SSUTIL4(Dir)
 s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
 i orderFieldName'="" d
 .s sql=sql_" Order By "_orderFieldName_" "_Dir
 //w sql,!
 s xrs=##class(%ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 if $$$ISERR(sc) q $$$OK 
  
 s UserCatGrpStr=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStrNew(User,..sssCode())  //用户类组串
 while (xrs.Next())
 {
	s incil=xrs.Data("incil")
	s NotUseFlag=xrs.Data("NotUseFlag")
	continue:NotUseFlag="Y"
	//q:NotUseFlag="Y"
	
	s logQty=xrs.Data("logQty")
	continue:logQty=0 
	//q:logQty=0  //零库存的滤除
	s move=0
	s cnt=$l(BusinessTypes,",")
	f i=1:1:cnt q:move=1  d
	.s typeInfo=$p(BusinessTypes,",",i)
	.s type=$p(typeInfo,"$",1)
	.s limitNum=+$p(typeInfo,"$",2)
	.s move=..CheckMoveInfo(incil,StartDate,EndDate,type,limitNum)
	.q:move=1
	.
    continue:move=1
    s inci=xrs.Data("inci")
    s code=xrs.Data("code")
    s desc=xrs.Data("descx")
	s ScgGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	s ScgType=$p(ScgGrpInfo,"^",3)
	continue:ScgType'=..sssCode()
	s Scg=$p(ScgGrpInfo,"^",5)
	continue:("^"_UserCatGrpStr_"^")'[("^"_Scg_"^")
    s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
    s stkUom=xrs.Data("pUomDesc")
    s pUom=xrs.Data("pUom")
    //s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inci,+$h,pUom,HospID)
    s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") 
    s stkbinstr=$p(stkbinret,":",2)
    s sbDesc=stkbinstr  //货位
    
    s pFac=##class(web.DHCST.Common.UtilCommon).UOMFac(pUom,$P(^INCI(inci,1),"^",10))
    
	s LastImpDate=..LastImpDate(incil,EndDate)			;将=1改为>0,zdm,2009-3-6
	s LastTrOutDate=..LastTrOutDate(incil,EndDate)
	s LastTrInDate=..LastTrInDate(incil,EndDate)
	s LastIpDate=..LastIpDate(incil,EndDate)
	s LastOpDate=..LastOpDate(incil,EndDate)
     
    s lb=0
    s ilch=$p(incil,"||",2)
    f  s lb=$O(^INCI(inci,"IL",ilch,"LB",lb)) q:lb=""  d
    .s inclb=incil_"||"_lb
    .s stkQty=$P(^INCI(inci,"IL",ilch,"LB",lb),"^",2)
    .q:+stkQty=0   //滤除零库存的批次
    .;b ;22
    .s dirtyQty=$P(^INCI(inci,"IL",ilch,"LB",lb),"^",3)
    .s avaQty=stkQty-dirtyQty
    .s incib=$P(^INCI(inci,"IL",ilch,"LB",lb),"^",1)
    .s batNo="" ,expDate=""
    .&sql(select incib_no ,incib_expdate into :batNo,:expDate from inc_itmbat where %ID=:incib)
    .i expDate'="" s expDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expDate,"ST")
    .s vendor= $p(##class(web.DHCST.Common.DrugStkCommon).GetInclbVend(inclb,EndDate),"^",2)
    .s manf=$P( ##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclb),"^",2)
    .
    .s stkQty=stkQty/pFac
    .s avaQty=avaQty/pFac
    .s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclb,+$h,pUom,HospID,"G","")
    .s sp=##Class(web.DHCST.Common.AppCommon).FormatInciSp(sp,HospID,inci,pUom)
    .d ##Class(PHA.COM.Number).FormatSqAll(HospID,.stkQty,.avaQty)
    .d OutPutRow
    .
 }
 Quit $$$OK
OutPutRow
  //科室库存RowId，药品RowId，药品代码，名称，规格，厂商，单位，库存数量，可用数量，售价，货位码
  s Data=$lb(inclb,code,desc,spec,manf,batNo,expDate,vendor,stkUom,stkQty,avaQty,sp,sbDesc,LastImpDate,LastTrOutDate ,LastTrInDate,LastIpDate,LastOpDate )   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod LocItmSluggishGoodsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocItmSluggishGoodsExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod LocItmSluggishGoodsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocItmSluggishGoodsExecute ]
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

/// 检查某科室库存项某段日期内的某业务是否呆滞
/// Author:
/// zhwh
/// Date:2012-07-30
/// Argu:
/// incil -科室库存rowid
/// sd - 起始日期
/// ed - 截止日期
/// type -业务类型代码
/// limitNum - 呆滞参照数（即业务发生数少于此数时可认定为呆滞）,此数值为按入库单位计的数量
/// Return: 0--呆滞, 1-非呆滞
ClassMethod CheckMoveInfo(incil As %String, sd As %String, ed As %String, type As %String, limitNum As %String) As %String
{
 n (incil,sd,ed,type,limitNum)
 s move=0
 s buom=$P($g(^INCI(+incil,1)),"^",10)
 //计算参考值
 //
 s pUom=$P($G(^INCI(+incil,3)),"^",6) i pUom="" s pUom=buom
 s pFac=##class(web.DHCST.Common.UtilCommon).UOMFac(pUom,buom)
 s limitNum=limitNum*pFac   //换算为基本单位的量
 s sumPY=0
 s sumFH=0
 s sumTrQty=0
 f dd=sd:1:ed q:move=1  d  
 .s intr=""
 .f  s intr=$o(^DHCINTR(0,"ILTYPEDATE",incil,type,dd,intr)) q:(intr="")!(move=1)  d
 ..s trQty=$p(^DHCINTR(intr),"^",6)
 ..s uom=$p(^DHCINTR(intr),"^",10)
 ..s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)
 ..s trQty=trQty*fac   //换算为基本单位
 ..//w trQty,!
 ..i (type["P") ! (type["Y") d 
 ...s sumPY=sumPY+trQty
 ...i (+limitNum>0)&(-sumPY>=+limitNum) s move=1 q
 ..e  i (type["F") ! (type["H") d
 ...s sumFH=sumFH+trQty
 ...i (+limitNum>0)&(-sumFH>=+limitNum) s move=1 q
 ..e  d
 ...s:type="T" trQty=-trQty
 ...s sumTrQty=sumTrQty+trQty
 ...s:sumTrQty>=limitNum move=1
 ..q:move=1
 q move
}

/// 取某科室某日期前的最后入库日期 
/// Date:2012-07-30
/// Argu:
///  incil -科室库存rowid
///  dd - 日期(number)
/// Return:最后的入库日期
ClassMethod LastImpDate(incil As %String, dd As %String) As %String
{
 n (incil,dd)
 s d=..LastDate(incil,"G",dd)
 i d>0 q ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(d,"ST")
 q ""
}

/// ;最后转移出库日期 
/// Date:2012-07-30
/// Argu:
///  incil -科室库存rowid
///  dd - 日期(number)
/// Return:最后的转移出库日期
ClassMethod LastTrOutDate(incil As %String, dd As %String) As %String
{
 n (incil,dd)
 s d=..LastDate(incil,"T",dd)
 i d>0 q ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(d,"ST")
 q ""
}

/// ;最后转移入库日期
/// Date:2012-07-30
/// Argu:
///  incil -科室库存rowid
///  dd - 日期(number)
/// Return:最后的转移入库日期
ClassMethod LastTrInDate(incil As %String, dd As %String) As %String
{
 n (incil,dd)
 s d=..LastDate(incil,"K",dd)
 i d>0 q ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(d,"ST")
 q ""
}

/// ;最后住院发/退日期 
/// Date:2012-07-30
/// Argu:
///  incil -科室库存rowid
///  dd - 日期(number)
/// Return:最后的住院发(退)药日期
ClassMethod LastIpDate(incil, dd)
{
  n (incil,dd)
  s d1=..LastDate(incil,"P",dd)
  s d2=..LastDate(incil,"Y",dd)
  s d=d2
  i +d1>+d2 s d=d1
	 i d>0 q ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(d,"ST")
  q ""
}

/// ;最后门诊发/退日期 
/// Date:2012-07-30
/// Argu:
///  incil -科室库存rowid
///  dd - 日期(number)
/// Return:最后的门诊发(退)药日期
ClassMethod LastOpDate(incil, dd)
{
  n (incil,dd)
  s d1=..LastDate(incil,"F",dd)
  s d2=..LastDate(incil,"H",dd)
  s d3=..LastDate(incil,"S",dd)
  s d4=..LastDate(incil,"Z",dd)
  k ^TMP($j,"LASTOPDATEX")
  i d1>0 s ^TMP($j,"LASTOPDATEX",d1)=""
  i d2>0 s ^TMP($j,"LASTOPDATEX",d2)=""
  i d3>0 s ^TMP($j,"LASTOPDATEX",d3)=""
  i d4>0 s ^TMP($j,"LASTOPDATEX",d4)=""
  s d=$o(^TMP($j,"LASTOPDATEX",""),-1)
  k ^TMP($j,"LASTOPDATEX")
  i d>0 q ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(d,"ST")
  q ""
}

/// 取某科室﹜某库存项﹜某项业务的最后日期
/// Date:2012-07-30
/// Argu:
///   incil  -科室库存rowid
///   type  -业务类型代码
///   dd  - 截至日期
/// Return :
///   某项业务的最后日期
ClassMethod LastDate(incil As %String, type As %String, dd As %String) As %String
{
 n (incil,type,dd)
 i dd="" s dd=+$H
 q:incil="" ""
 q:type="" ""
 s lastdate=$o(^DHCINTR(0,"ILTYPEDATE",incil,type,dd),-1)  ;最后入库日期
 q +lastdate
}

ClassMethod NewPid()
{
  q $I(^DHCSTPID("LocItmSluggishGoods"))
}

}
