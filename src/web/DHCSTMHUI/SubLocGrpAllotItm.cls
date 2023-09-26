Import sqluser

Class web.DHCSTMHUI.SubLocGrpAllotItm Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:统计一段时间的公共支出明细
/// Creator:	tsr
/// CreatDate:	2019-06-29
/// Table:		
/// Others:		##class(%ResultSet).RunQuery("web.DHCSTMHUI.SubLocGrpAllotItm","SubLocAllotItm")
Query SubLocAllotItm(Params As %Text) As Query(ROWSPEC = "slga,slgaNo,slgai,Lug,LugCode,LugDesc,toLoc,toLocDesc,inci,inciCode,inciDesc,qty:%Float,PuomDesc,Abbrev,Brand,Model,Spec") [ SqlProc ]
{
}

ClassMethod SubLocAllotItmExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s DispLoc=PJObj.%Get("DispLoc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s StkGrp=PJObj.%Get("StkGrp")
	s StkCat=PJObj.%Get("StkCat")
	s Inci=PJObj.%Get("Inci")
	s ReqLoc=PJObj.%Get("ReqLoc")
	s GrpList=PJObj.%Get("GrpList")
	s UserList=PJObj.%Get("UserList")
	q:DispLoc="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)

	f Date=StartDate:1:EndDate d
	.s slga=""
	.f  s slga=$o(^DHCSLGA(0,"ALLOTMON",Date,slga)) q:slga=""  d
	..s auditFlag=$p(^DHCSLGA(slga),"^",11)
	..q:auditFlag'="Y"
	..s slgaLoc=$p(^DHCSLGA(slga),"^",5)
	..q:(DispLoc'="")&&(slgaLoc'=DispLoc)
	..s Lug=$p(^DHCSLGA(slga),"^",6)
	..q:(GrpList'="")&&(Lug'=GrpList)
	..s LugCode=$p(^DHCLUG(Lug),"^",1)
	..s LugDesc=$p(^DHCLUG(Lug),"^",2)
	..s toLoc=$p(^DHCLUG(Lug),"^",5)
	..q:(ReqLoc'="")&&(toLoc'=ReqLoc)			;根据接收科室过滤
	..s toLocDesc=$p(^CTLOC(toLoc),"^",2)
	..s stkType=$p(^DHCSLGA(slga),"^",13)
	..q:stkType'=..sssCode()
	..s slgaNo=$p(^DHCSLGA(slga),"^",1)
	..s slgaiCh=""
	..f  s slgaiCh=$o(^DHCSLGA(slga,"I",slgaiCh)) q:slgaiCh=""  d
	...s slgai=slga_"||"_slgaiCh
	...s slgaiInfo=^DHCSLGA(slga,"I",slgaiCh)
	...s inci=$p(slgaiInfo,"^",1)
	...s qty=$p(slgaiInfo,"^",2)
	...s uom=$p(slgaiInfo,"^",3)
	...s rpAmt=$p(slgaiInfo,"^",4)
	...s spAmt=$p(slgaiInfo,"^",5)
	...s inciCode=$p(^INCI(inci,1),"^",1)
	...s inciDesc=$p(^INCI(inci,1),"^",2)
	...s bUom=$p(^INCI(inci,1),"^",10)
	...s pUom=$p(^INCI(inci,3),"^",6)
	...s Fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,bUom)
	...s Fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(pUom,bUom)
	...s qty=qty*Fac1/Fac2
	...s PuomDesc=$p(^CT("UOM",pUom),"^",2)
	...s Abbrev=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetAbbrev(inci)
	...s Brand=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(inci)
	...s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(inci)
	...s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
	...d OutPutItmDetail

	q $$$OK

OutPutItmDetail
	s Data=$lb(slga,slgaNo,slgai,Lug,LugCode,LugDesc,toLoc,toLocDesc,inci,inciCode,
			inciDesc,qty,PuomDesc,Abbrev,Brand,Model,Spec)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:统计一段时间的公共支出明细
/// Creator:	tsr
/// CreatDate:	2019-06-29
/// Table:		
/// Others:		##class(%ResultSet).RunQuery("","")
Query SubLocAllotScale(Params As %Text) As Query(ROWSPEC = "slga,slgas,Lug,LugCode,LugDesc,UserId,UserInitial,UserName,ScaleValue:%Float,RpAmt:%Float,ToLoc,ToLocDesc,TotalScale:%Float") [ SqlProc ]
{
}

ClassMethod SubLocAllotScaleExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s DispLoc=PJObj.%Get("DispLoc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s StkGrp=PJObj.%Get("StkGrp")
	s StkCat=PJObj.%Get("StkCat")
	s Inci=PJObj.%Get("Inci")
	s ReqLoc=PJObj.%Get("ReqLoc")
	s GrpList=PJObj.%Get("GrpList")
	s UserList=PJObj.%Get("UserList")
	q:DispLoc="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)

	f Date=StartDate:1:StartDate d
	.s slga=""
	.f  s slga=$o(^DHCSLGA(0,"ALLOTMON",Date,slga)) q:slga=""  d
	..s auditFlag=$p(^DHCSLGA(slga),"^",11)
	..q:auditFlag'="Y"
	..s slgaLoc=$p(^DHCSLGA(slga),"^",5)
	..q:(DispLoc'="")&&(slgaLoc'=DispLoc)
	..s Lug=$p(^DHCSLGA(slga),"^",6)
	..q:(GrpList'="")&&(Lug'=GrpList)
	..s LugCode=$p(^DHCLUG(Lug),"^",1)
	..s LugDesc=$p(^DHCLUG(Lug),"^",2)
	..s LugLoc=$p(^DHCLUG(Lug),"^",5)
	..q:(ReqLoc'="")&&(LugLoc'=ReqLoc)			;根据接收科室过滤
	..s toLocDesc=$p(^CTLOC(LugLoc),"^",2)
	..s stkType=$p(^DHCSLGA(slga),"^",13)
	..q:stkType'=..sssCode()
	..s slgaNo=$p(^DHCSLGA(slga),"^",5)
	..s TotalScale=0
	..&sql(select sum(nvl(SLGAS_ScaleValue,0)) into :TotalScale from DHC_SubLocGrpAllotScale where SLGAS_SLGA_Parref=:slga)
	..s slgasCh=""
	..f  s slgasCh=$o(^DHCSLGA(slga,"S",slgasCh)) q:slgasCh=""  d
	...s slgas=slga_"||"_slgasCh
	...s slgasInfo=^DHCSLGA(slga,"S",slgasCh)
	...s user=$p(slgasInfo,"^",1)
	...s ScaleValue=+$p(slgasInfo,"^",2)
	...q:ScaleValue=0
	...s rpAmt=$p(slgasInfo,"^",3)
	...s spAmt=$p(slgasInfo,"^",4)
	...q:(UserList'="")&&(UserList'=user)
	...s LugCode=$p(^DHCLUG(Lug),"^",1)
	...s LugDesc=$p(^DHCLUG(Lug),"^",2)
	...s userInitial=$p(^SSU("SSUSR",user),"^",1)
	...s userName=$p(^SSU("SSUSR",user),"^",2)
	...d OutPutScaleDetail

	q $$$OK

OutPutScaleDetail
	s Data=$lb(slga,slgas,Lug,LugCode,LugDesc,user,userInitial,userName,ScaleValue,rpAmt,
			toLoc,toLocDesc,TotalScale)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	插入分配明细信息
/// Creater:	wangjiabin
/// CreateDate:	2014-02-14
/// Table:		DHC_SubLocGrpAllotItm
/// Input:分配主表id, 库存项id^数量^单位Id(基本单位)
/// Output:		
/// Return：成功:rowid，"",失败
ClassMethod Insert(Parref As %String, ListData As %String) As %Library.String
{
	n (Parref,ListData)
	s IncId=$p(ListData,"^",1)
	s Qty=$p(ListData,"^",2)
	s UomId=$p(ListData,"^",3)
	s RpAmt=$p(ListData,"^",4)
	s SpAmt=$p(ListData,"^",5)
	q:IncId="" ""
	q:+Qty=0 ""
	q:Parref="" ""
	;
	s Chl=1+$o(^DHCSLGA(Parref,"I",""),-1)
	s Err=0
	&sql(insert into DHC_SubLocGrpAllotItm(SLGAI_SLGA_Parref,SLGAI_Childsub,SLGAI_INCI_DR,SLGAI_Qty,SLGAI_UOM_DR,SLGAI_RpAmt,SLGAI_SpAmt) 
		values (:Parref,:Chl,:IncId,:Qty,:UomId,:RpAmt,:SpAmt))
	i SQLCODE'=0  d
	.d ErrorRecord^DHCSTMHUIERROR(..%GetParameter("AppName"),Parref_","_Chl_","_IncId_","_Qty_","_UomId_","_RpAmt_","_SpAmt,$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	.s Err=-3
	.
	q:Err'=0 ""    ;保存分配单明细失败
	;
	q $p($g(%ROWID),$c(1))
}

/// Descript:	删除某分配单明细信息
/// Creater:	wangjiabin
/// CreateDate:	2012-06-19
/// Table:IN_PurplanItm
/// Input:rowid
/// Output:		
/// Return：成功:0，
/// -1   	;订单已经完成，不能删除
/// -2		;订单已经审核，不能删除
/// -3   ;删除计划明细失败
ClassMethod Delete(slgai As %String) As %Library.String
{
	n (slgai)
	;
	q:slgai="" ""
	s slga=+slgai
    s CompFlag=$p(^DHCSLGA(slga),"^",10)
    s AuditFlag=$p(^DHCSLGA(slga),"^",11)
    q:CompFlag="Y" -1       ;分配单已经完成，不能删除
    q:AuditFlag="Y" -2      ;分配单已经审核，不能删除
	;
	s Err=0
	&sql(Delete from DHC_SubLocGrpAllotItm where %id=:slgai) 
	i SQLCODE'=0  d
	.d ErrorRecord^DHCSTMHUIERROR(..%GetParameter("AppName"),slgai,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
	.s Err=-3
	.
	q:Err'=0 -3   ;删除计划明细失败
	;
	q 0
}

/// 取分配单明细记录的数据串(json)
/// Author:	wangjiabin
/// Date:	2014-02-19
/// Argu: 
/// 	slga- -分配单主表rowid
/// Return:
///    数据串(json格式)
ClassMethod jsAllotDetail(Start As %String, Limit As %String, slga As %String) As %String
{
 n (Start,Limit,slga)
 s result=##class(%Library.ResultSet).%New("web.DHCSTMHUI.SubLocGrpAllotItm:AllotItm")
 s sc=result.Execute(slga)
 i $$$ISERR(sc) q ""
 
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)

 s count = 0
 s resultString = ""
 s end = Start+Limit
 w "{rows:["
 While(result.Next())
 { 
  s DataStr=""
  f i=1:1:colNum d
  .i DataStr="" s DataStr=result.%GetData(i)
  .e  s DataStr=DataStr_"^"_result.%GetData(i)
  
  s count = count+1
  CONTINUE:count<(Start+1)
  CONTINUE:count>end
	
  i count=(Start+1) d
  .w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,colNameStr)
  e  d
  .w ","_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,colNameStr)
 }
 w "],results:"_count_"}"
 d result.Close()
}

/// 检索分配单明细
/// Author:	wangjiabin
/// Date:	2014-02-19
/// Argu:
/// Parref - 分配单DHC_SubLocGrpAllot主表rowid
/// Return:
///  采购单明细信息数据(采购明细RowId，库存rowid,物资代码,物资名称,数量,单位,单位Desc,进价金额,售价金额)
Query AllotItm(Parref As %String) As Query(ROWSPEC = "slgai,inci,inciCode,inciDesc,qty:%Float,uom,uomDesc,rpAmt:%Float,spAmt:%Float,Abbrev,Brand,Model,Spec") [ SqlProc ]
{
}

ClassMethod AllotItmExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle, Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	;
	q:Parref="" $$$OK
	s StrSql="select SLGAI_Rowid Rowid,SLGAI_INCI_DR inci,SLGAI_INCI_DR->inci_code inciCode,SLGAI_INCI_DR->inci_Desc inciDesc,"
	_"SLGAI_Qty qty,SLGAI_UOM_DR uom,SLGAI_UOM_DR->ctuom_desc uomDesc,SLGAI_RpAmt rpAmt,SLGAI_SpAmt spAmt"
	_" from DHC_SubLocGrpAllotItm "
	_" where SLGAI_SLGA_Parref="_Parref
	;
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	;
	If err  q ""
	s count = 0 
	While(result.Next())
	{	
		s slgai = result.Data("Rowid")
		s inci = result.Data("inci")
		s inciCode = result.Data("inciCode")
		s inciDesc = result.Data("inciDesc")
		s qty = result.Data("qty")
		s uom = result.Data("uom")
		s uomDesc = result.Data("uomDesc")
		s rpAmt = result.Data("rpAmt")
		s spAmt = result.Data("spAmt")
		s Abbrev=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetAbbrev(inci)
		s Brand=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(inci)
		s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(inci)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
		d OutPutRow
	}
	d result.Close()
 Quit $$$OK

OutPutRow
 s Data=$lb(slgai,inci,inciCode,inciDesc,qty,uom,uomDesc,rpAmt,spAmt,Abbrev,Brand,Model,Spec) 
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/*
/// 取分配单权重明细的数据串(json)
/// Author:	wangjiabin
/// Date:	2014-02-20
/// Argu: 
/// 	Start,Limit,Sort,Dir,slga--分配单主表rowid,是否排除权重为0或空明细(1:排除,其他不排除)
/// Return:
///    数据串(json格式)
ClassMethod jsAllotScaleDetail(Start As %String, Limit As %String, Sort As %String, Dir As %String, slga As %String, ExcludeZero As %String = "") As %String
{
	n (Start,Limit,Sort,Dir,slga,ExcludeZero)
	q:slga="" ""
	s StrSql="select SLGAS_Rowid slgas,SLGAS_User_DR UserId,SLGAS_User_DR->SSUSR_Name UserName,SLGAS_ScaleValue ScaleValue,"
	_"SLGAS_ScaleRpAmt ScaleRpAmt,SLGAS_ScaleSpAmt ScaleSpAmt"
	_" from DHC_SubLocGrpAllotScale "
    _" where SLGAS_SLGA_Parref="_slga
	s OrderField=""
    s:Sort="UserName" OrderField="UserName"
    s:Sort="ScaleValue" OrderField="ScaleValue"
    ;
    s:Dir'="" Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="ASC"
    i OrderField'=""  d
    .s StrSql=StrSql_" order by "_OrderField_" "_Dir
	;
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	;
	If err  q ""
	s slgaAuditFlag=$p(^DHCSLGA(slga),"^",11)
	s slgaRpAmt=0,slgaSpAmt=0
	&sql(select sum(SLGAI_RpAmt),sum(SLGAI_SpAmt) into :slgaRpAmt,:slgaSpAmt
		from DHC_SubLocGrpAllotItm where SLGAI_SLGA_Parref=:slga)
	s slgaScale=0
	&sql(select sum(nvl(SLGAS_ScaleValue,0)) into :slgaScale from DHC_SubLocGrpAllotScale where SLGAS_SLGA_Parref=:slga)
	s:slgaScale=0 slgaScale=1	;确保如果没有保存权重,可以输出
	s TitleStr="slgas^UserId^UserName^ScaleValue^ScaleRpAmt^ScaleSpAmt"
	s end=Start+Limit
	s count = 0
	w "{rows:["
	While(result.Next())
	{
		s slgas=result.Data("slgas")
		s UserId=result.Data("UserId")
		s UserName=result.Data("UserName")
		s ScaleValue=result.Data("ScaleValue")
		continue:(ExcludeZero=1)&&(+ScaleValue=0)
		;已审核单据显示scale子表,未审核单据根据itm子表计算
		i slgaAuditFlag="Y" d
		.s ScaleRpAmt=result.Data("ScaleRpAmt")
		.s ScaleSpAmt=result.Data("ScaleSpAmt")
		e  d
		.s ScaleRpAmt=ScaleValue/slgaScale*slgaRpAmt
		.s ScaleRpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(ScaleRpAmt,"")
		.s ScaleSpAmt=ScaleValue/slgaScale*slgaSpAmt
		.s ScaleSpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(ScaleSpAmt,"")
		.
		s DataStr=slgas_"^"_UserId_"^"_UserName_"^"_ScaleValue_"^"_ScaleRpAmt_"^"_ScaleSpAmt
		s count=count+1
		continue:count<(Start+1)
		continue:count>end
		i count=(Start+1) d
		.w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
		e  d
		.w ","_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	}
	w "],results:"_count_"}"
	d result.Close()
}
*/
/// 取分配单权重明细的数据串(json)
/// Author:	wangjiabin
/// Date:	2015-07-08
/// Argu: 
/// 	Start,Limit,Sort,Dir,slga--分配单主表rowid,是否排除权重为0或空明细(1:排除,其他不排除)
/// Return:
///    数据串(json格式)
/// d ##class(web.DHCSTMHUI.SubLocGrpAllotItm).jsAllotScaleDetail(0,10,"","",38,"1")
ClassMethod jsAllotScaleDetail(Start As %String, Limit As %String, Sort As %String, Dir As %String, slga As %String, ExcludeZero As %String = "") As %String
{
	n (Start,Limit,Sort,Dir,slga,ExcludeZero)
	q:slga="" ""
	s result=##class(%Library.ResultSet).%New("web.DHCSTMHUI.SubLocGrpAllotItm:AllotScale")
	s sc=result.Execute(slga,Sort,Dir,ExcludeZero)
	i $$$ISERR(sc) q ""

	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)

	s count = 0
	s resultString = ""
	s end = Start+Limit
	w "{rows:["
	While(result.Next())
	{
		s DataStr=""
		f i=1:1:colNum d
		.i DataStr="" s DataStr=result.%GetData(i)
		.e  s DataStr=DataStr_"^"_result.%GetData(i)

		s count = count+1
		CONTINUE:count<(Start+1)
		CONTINUE:count>end

		i count=(Start+1) d
		.w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,colNameStr)
		e  d
		.w ","_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,colNameStr)
	}
	w "],results:"_count_"}"
	d result.Close()
}

/// 取分配单权重明细query
/// Author:	wangjiabin
/// Date:	2015-07-08
/// Argu: 
/// 	Parref--分配单主表rowid,Sort,Dir,是否排除权重为0或空明细(1:排除,其他不排除)
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.SubLocGrpAllotItm","AllotScale",11,"","","")
Query AllotScale(Parref As %String, Sort, Dir, ExcludeZero) As Query(ROWSPEC = "slgas,UserId,UserName,ScaleValue:%Float,ScaleRpAmt:%Float,ScaleSpAmt:%Float,slgaScale:%Float") [ SqlProc ]
{
}

ClassMethod AllotScaleExecute(ByRef qHandle As %Binary, Parref As %String, Sort, Dir, ExcludeZero) As %Status
{
	n (qHandle,Parref,Sort,Dir,ExcludeZero)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	;
	q:Parref="" $$$OK
	s StrSql="select SLGAS_Rowid slgas,SLGAS_User_DR UserId,SLGAS_User_DR->SSUSR_Name UserName,SLGAS_ScaleValue ScaleValue,"
		_"SLGAS_ScaleRpAmt ScaleRpAmt,SLGAS_ScaleSpAmt ScaleSpAmt"
		_" from DHC_SubLocGrpAllotScale "
		_" where SLGAS_SLGA_Parref="_Parref
	s:Dir'="" Dir=$$ALPHAUP^SSUTIL4(Dir)
	s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="ASC"
	i Sort'=""  d
	.s StrSql=StrSql_" order by "_Sort_" "_Dir
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	;
	If err  q $$$OK
	s slgaAuditFlag=$p(^DHCSLGA(Parref),"^",11)
	s slgaRpAmt=0,slgaSpAmt=0
	&sql(select sum(SLGAI_RpAmt),sum(SLGAI_SpAmt) into :slgaRpAmt,:slgaSpAmt
		from DHC_SubLocGrpAllotItm where SLGAI_SLGA_Parref=:Parref)
	s slgaScale=0
	&sql(select sum(nvl(SLGAS_ScaleValue,0)) into :slgaScale from DHC_SubLocGrpAllotScale where SLGAS_SLGA_Parref=:Parref)
	s:slgaScale=0 slgaScale=1	;确保如果没有保存权重,可以输出
	While(result.Next())
	{
		s slgas=result.Data("slgas")
		s UserId=result.Data("UserId")
		s UserName=result.Data("UserName")
		s ScaleValue=result.Data("ScaleValue")
		continue:(ExcludeZero=1)&&(+ScaleValue=0)
		;已审核单据显示scale子表,未审核单据根据itm子表计算
		i slgaAuditFlag="Y" d
		.s ScaleRpAmt=result.Data("ScaleRpAmt")
		.s ScaleSpAmt=result.Data("ScaleSpAmt")
		e  d
		.s ScaleRpAmt=ScaleValue/slgaScale*slgaRpAmt
		.s ScaleRpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(ScaleRpAmt,"")
		.s ScaleSpAmt=ScaleValue/slgaScale*slgaSpAmt
		.s ScaleSpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(ScaleSpAmt,"")
		
		d OutPutScaleRow
	}
	d result.Close()
	Quit $$$OK

OutPutScaleRow
 s Data=$lb(slgas,UserId,UserName,ScaleValue,ScaleRpAmt,ScaleSpAmt,slgaScale) 
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Descript:	保存/更新分配单明细信息
/// Creater:	wangjiabin
/// CreateDate:	2014-02-24
/// Table:DHC_SubLocGrpAllotItm
/// Input:分配主表id,
/// slgas(scale明细rowid)^userid^scaleValue_$c(1)_slgas^userid^scaleValue,...
/// Output:		
/// Return：0：成功，
/// -5:主表id或明细不能为空
/// -6:所有明细保存均失败
/// 其它：部分明细保存不成功，提示不成功的药品
ClassMethod SaveScale(slga As %String, ListData As %String) As %Library.String
{
	n (slga,ListData)
	q:slga="" -5
	q:ListData="" -5
	s rowDelim=##class(web.DHCSTMHUI.Common.UtilCommon).RowDataDelim()
	s Len=$l(ListData,rowDelim)
	s Count=0
	s Err=""
	f i=1:1:Len  d
	.s Data=$p(ListData,rowDelim,i)
	.s Rowid=$p(Data,"^",1)
	.s Detail=$p(Data,"^",2,$l(Data,"^"))
	.i Rowid'=""  d
	..s Ret=..UpdateScale(Rowid,Detail)
	..s:Ret'=0 Err=-1
	..
	.e  d
	..s Ret=..InsertScale(slga,Detail)
	..s:Ret<0 Err=-2
	..
	.
	q:Err'="" Err
	q 0
}

/// Descript:   插入分配明细和科室内发放明细关联
/// Creater:    wangjiabin
/// CreateDate: 2014-02-18
/// Table:		DHC_SLGAInDsiItm
/// Input:代码,描述
/// Output:     
/// Return：成功:0
/// -1:信息为空
/// -3   ;保存失败
ClassMethod InsertScale(AllotId As %String, ScaleStr As %String) As %Library.String
{
    n (AllotId, ScaleStr)
    q:AllotId="" -1
    q:ScaleStr="" -1
    ;
    s Err=0
    s Chl=1+$o(^DHCSLGA(AllotId,"S",""),-1)
    s UserId=$p(ScaleStr,"^",1)
    s ScaleValue=$p(ScaleStr,"^",2)
    &sql(insert into DHC_SubLocGrpAllotScale(SLGAS_SLGA_Parref,SLGAS_Childsub,SLGAS_User_DR,SLGAS_ScaleValue) 
    	values (:AllotId,:Chl,:UserId,:ScaleValue))
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTMHUIERROR(..%GetParameter("AppName"),AllotId_","_Chl_","_UserId_","_ScaleValue,$ClassName()_".InsertScale:SQLCODE"_SQLCODE_":"_$g(%msg))
    .s Err=-3
    
    q:Err'=0 Err    ;保存失败
    ;
    q 0
}

/// Descript:   修改分配子表权重
/// Creater:    wangjiabin
/// CreateDate: 2014-02-24
/// Table:		DHC_SubLocGrpAllotScale
/// Input:代码,描述
/// Output:     
/// Return：成功:0
/// -1:信息为空
/// -3   ;保存失败
ClassMethod UpdateScale(slgas As %String, ScaleStr As %String) As %Library.String
{
    n (slgas, ScaleStr)
    q:slgas="" -1
    q:ScaleStr="" -1
    ;
    s UserId=$p(ScaleStr,"^",1)
    s ScaleValue=$p(ScaleStr,"^",2)
    s Err=0
    &sql(update DHC_SubLocGrpAllotScale set SLGAS_User_DR=:UserId,SLGAS_ScaleValue=:ScaleValue
    	where %id=:slgas)
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTMHUIERROR(..%GetParameter("AppName"),UserId_","_ScaleValue_","_slgas,$ClassName()_".UpdateScale:SQLCODE"_SQLCODE_":"_$g(%msg))
    .s Err=-3
    
    q:Err'=0 Err    ;保存失败
    ;
    q 0
}

}
