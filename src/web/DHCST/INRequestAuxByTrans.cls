Import sqluser

Class web.DHCST.INRequestAuxByTrans Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 取辅助请求记录数据串(json)
/// Author:zhwh 
/// Date:2012-08-09
/// Argu:
///  StrPar - 参数数据串
/// Return:
///  辅助请求记录数据串(json)
ClassMethod jsLocItmForReq(StrPar As %String, User As %String) As %String
{
 s Loc=$p(StrPar,"^",1)
 s StartDate=$p(StrPar,"^",2)
 s EndDate=$p(StrPar,"^",3)
 s Days=$p(StrPar,"^",4)
 s SCG=$p(StrPar,"^",5)
 s FrLoc=$p(StrPar,"^",6)
 s roundInt=$p(StrPar,"^",7)
 s includeZero=$p(StrPar,"^",8)
 s useInt=$p(StrPar,"^",9)
 s checkKC=$p(StrPar,"^",10)
 
 s:SCG="" SCG=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStrNew(User,..sssCode())  //若类组为空，则传递User类组串
 s result=##class(%ResultSet).%New("web.DHCST.INRequestAuxByTrans:LocItmForReq")
 s sc=result.Execute(Loc,StartDate,EndDate,Days,SCG,FrLoc,roundInt,includeZero,useInt,checkKC)
 i $$$ISERR(sc) q ""
 
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)

 s count = 0
 s resultString = ""
 ;s end = Start+Limit
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

  ;CONTINUE:count<(Start+1)
  ;CONTINUE:count>end			
	
  d json.InsertRowData(tmp)
 }
 d result.Close()
 
 s resultString = json.getJsonData(colNameStr,count)
 k json
 Q resultString
}

/// 检索需要请求的库存项目列表
/// Author:zhwh
/// Argu:
/// Loc - 请求科室rowid
/// StartDate -参考起始日期
/// EndDate -参考截止日期
/// Days -支持天数
/// SCG - 类组rowid
/// FrLoc-供应科室
/// Return:
///  待申请项目列表
Query LocItmForReq(Loc As %String, StartDate As %String, EndDate As %String, Days As %String, SCG As %String, FrLoc As %String, roundInt As %String, includeZero As %String, useInt As %String, checkKC As %String) As %Query(ROWSPEC = "inci:%String,code:%String,desc:%String,spec:%String,manf:%String,uom:%String,uomDesc:%String,stkQty:%String,avaQty:%String,dailyDispQty:%String,reqQtyAll:%String,applyQty:%String,ActualQty:%String")
{
}

ClassMethod LocItmForReqExecute(ByRef qHandle As %Binary, Loc As %String, StartDate As %String, EndDate As %String, Days As %String, SCG As %String, FrLoc As %String, roundInt As %String, includeZero As %String, useInt As %String, checkKC As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 ;param is use for check loc qty
 q:Loc="" $$$OK
 q:Days="" $$$OK
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 s num=0
 s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 s dispDays=EndDate-StartDate+1
 s inci=""
 f  s inci=$o(^INCI("IL_LOC",Loc,inci)) q:inci=""  d
 .s stkQty="",dispQty="",reqQtyAll="",dailyDispQty="",avaQty="",applyQty=""
 .s code="",desc="",buom="",uom="",uomDesc="",fac=""
 .s ch=$o(^INCI("IL_LOC",Loc,inci,""))
 .s incil=inci_"||"_ch
 .
 .q:$p($g(^INCI(inci,2)),"^",9)="Y"   //过滤"不可用"项 
 .i FrLoc'="" q:$o(^INCI("IL_LOC",FrLoc,inci,""))=""  //若供应科室无此库存项则不予请求  zhwh, 2011-06-22
 .
 .s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
 .s ScgType=$p(StkGrpInfo,"^",3)
 .s Scg=$p(StkGrpInfo,"^",5)
 .q:ScgType'=..sssCode()
 .q:(SCG'="")&(("^"_SCG_"^")'[("^"_Scg_"^"))
 .s dispQty=..TotalItmTransIn(incil,StartDate,EndDate)
 .q:dispQty<0  ;disp qty
 .s stkQty=##class(web.DHCST.Common.DrugStkCommon).IL(inci,Loc,+$h)
 .
 .s avaQty=##class(web.DHCST.Common.DrugStkCommon).CurItmAvaQtyB(incil,"")   //可用数
 .
 .s dailyDispQty=dispQty/dispDays
 .s reqQtyAll=dailyDispQty*Days
 .q:avaQty>reqQtyAll
 .s code=$p(^INCI(inci,1),"^",1)
 .s desc=$p(^INCI(inci,1),"^",2)
 .s buom=$p(^INCI(inci,1),"^",10)
 .s uom=$p(^INCI(inci,3),"^",6)
 .s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)
 .s applyQty=reqQtyAll
 .q:(includeZero'="Y")&(applyQty=0)        //wyx add 请求量为0标志 2014-01-21
 .s dailyDispQty=$fn(dailyDispQty/fac,"",4) ;日发药量
 .s reqQtyAll=$fn(reqQtyAll/fac,"",2)  ;days天需求量
 .s stkQty=$fn(stkQty/fac,"",2)  ;dhc 库存
 .s avaQty=$fn(avaQty/fac,"",2) ;可用开医嘱量
 .s applyQty=$fn(applyQty/fac,"",2)     ;建议申请量
 .
 .s:roundInt="Y" applyQty=$fn(applyQty,"",0) //wyx add 取整标志 2014-01-21
 .
 .s:useInt="Y" ActualQty=applyQty          //wyx add 使用建议请求量标志 2014-01-21
 .q:(checkKC="Y")&(stkQty<=0)            //wyx add 检查部门库存标志 2014-01-21
 .s uomDesc=$p(^CT("UOM",uom),"^",2)
 .s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
 .s manf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci),"^",3)
 .d OutPutRow1
 Quit $$$OK
 
OutPutRow1
 s Data=$lb(inci,code,desc,spec,manf,uom,uomDesc,stkQty,avaQty,dailyDispQty,reqQtyAll,applyQty,ActualQty)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod LocItmForReqClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocItmForReqExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod LocItmForReqFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocItmForReqExecute ]
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

/// 统计某科室库存项某日期范围内的转移入库数量
/// Argu：
///   incil - 科室库存rowid
///    StartDate  -起始日期
///    EndDate  -截止日期
/// Return:
///   转移入库数量合计(基本单位)
///   
ClassMethod TotalItmTransIn(incil As %String, StartDate As %String, EndDate As %String) As %String
{
 ;-->>total the qty of TransIn of any loc inci
 n (incil,StartDate,EndDate)
 s intr="",uom="",dd="",tmploc="",trUom="",fac="",dispQty="",totalQty=""
 s uom=$p(^INCI(+incil,1),"^",10) q:uom="" 0
 s totalQty=0,trQty=0

 f dd=StartDate:1:EndDate  d
 .f  s intr=$o(^DHCINTR(0,"ILTYPEDATE",incil,"K",dd,intr)) q:intr=""  d    ; get INTR
 ..q:(($d(^DHCINTR(intr))=0))!(($d(^DHCINTR(intr))=10))
 ..q:($p(^DHCINTR(intr),"^",1)'="K")
 ..s trUom=$p(^DHCINTR(intr),"^",10)  ; dispensing uom
 ..s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(trUom,uom) ; factor 
 ..s trQty=$p(^DHCINTR(intr),"^",6)   ;dispensing qty
 ..s trQty=trQty*fac
 ..s totalQty=$g(totalQty)+$g(trQty)  ; total of qty in basic uom
 q totalQty
}

}
