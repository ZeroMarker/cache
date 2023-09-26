Import sqluser

/// Descript:订单管理
/// Creater:	ZhangDongmei
/// CreateDate:	2012-07-30
Class web.DHCST.INPOItm Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新订单明细信息
/// Creater:	gwj
/// CreateDate:	2013-01-23
/// Table:IN_PoItm
/// Input:订单主表id,
/// 明细Id^库存项id^采购数量^单位Id^供应商Id^进价^厂商id^配送商id^请求科室,
/// 明细Id^库存项id^采购数量^单位Id^供应商Id^进价^厂商id^配送商id^请求科室
/// Output:		
/// Return：0：成功，
/// -5:主表id或明细不能为空
/// -6:所有明细保存均失败
/// 其它：部分明细保存不成功，提示不成功的药品
ClassMethod Save(PoId As %String, ListData As %String) As %Library.String
{
	n (PoId,ListData)
	q:PoId="" -5
	q:ListData="" -5
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	s Len=$l(ListData,rowDelim)
	s Count=0
	s Err=""
	f i=1:1:Len  d
	.s Data=$p(ListData,rowDelim,i)
	.s Rowid=$p(Data,"^",1)
	.s IncId=$p(Data,"^",2)
	.q:IncId=""
	.s IncDesc=$p(^INCI(IncId,1),"^",2)
	.s Detail=$p(Data,"^",2,$l(Data,"^"))
	.i Rowid'=""  d
	..s Ret=..Update(Rowid,PoId,Detail)
	..b
	..i Ret<0  d
	...s Err=Err_","_IncDesc
	..e  d
	...s Count=Count+1
	.e  d
	..s Ret=..Insert(PoId,Detail)
	..i Ret<0  d
	...s Err=Err_","_IncDesc
	..e  d
	...s Count=Count+1
	.
	q:Count=0 -6  ;所有明细保存均失败
	q:Err'="" -7_"^"_Err  ;保存失败的药品
	q 0
}

/// 插入或更新订单子表
/// Author:zhwh
/// Date:2012-10-29
/// Argu:
///  poitm - 子表rowid
///   po - 主表rowid
///   ListData - 明细数据串
/// Return:
///   串: 明细rowid
///   <0 - failure
ClassMethod Update(poitm As %String, po As %String, ListData As %String) As %String
{
 n (poitm,po,ListData)
 
 i poitm="" q ..Insert(po,ListData)
 s appName=##class(web.DHCST.INPO).%GetParameter("AppName")
 q:##class(web.DHCST.Common.AppCommon).Lock(appName_po)<0 -99
 
	s IncId=$p(ListData,"^",1)  //库存项rowid
	s UomId=$p(ListData,"^",2)  //单位rowid
	s Rp=$p(ListData,"^",3)  //进价
	s Qty=+$p(ListData,"^",4)  //订单数量
	s ReqQty=$p(ListData,"^",5)  //请求数量
	i IncId="" d ##class(web.DHCST.INPO).ULock(po) q -1  
	i Qty=0 d ##class(web.DHCST.INPO).ULock(po) q -1
	s Parref=po
	i Parref="" d ##class(web.DHCST.INPO).ULock(po) q -1
	;
	s CreateDate=+$h
	s BuomId=$p(^INCI(IncId,1),"^",10)
	i BuomId="" d ##class(web.DHCST.INPO).ULock(po) q ""  	;基本单位不能为空
	s LocId=""
	s HospId=""
	s DhcPoId=$o(^DHCINPO(0,"INPO",Parref,0))
	;b ;a
	s:DhcPoId'="" LocId=$p(^DHCINPO(DhcPoId),"^",2)
	s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
	s Chl=1+$o(^INPO(Parref,"POI",""),-1)
	;
	s Rp = ##Class(web.DHCST.Common.AppCommon).FormatInciRp(Rp,HospId,IncId,UomId) 
  	s RpAmt=Rp*Qty
	s RpAmt = ##Class(web.DHCST.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
	s Err=0
	
	&sql(update IN_PoItm  set INPOI_Date=:CreateDate,INPOI_INCI_DR=:IncId,
	INPOI_CTUOM_DR=:UomId,INPOI_UnitCost=:Rp,INPOI_GrossAmt=:RpAmt,INPOI_Req_Qty=:ReqQty,
	INPOI_Pur_Qty=:Qty,	INPOI_CTLOC_DR=:LocId 
	where %ID=:poitm)
	
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("Insert:IN_PoItm",Parref,SQLCODE_":"_%msg)
	.s Err=-3
	.d ##class(web.DHCST.INPO).ULock(po)
	.
	q:Err'=0 -3    ;保存订单失败
	d ##class(web.DHCST.INPO).ULock(po)
	s PoItmId=$p($g(%ROWID),$c(1))
	q PoItmId
}

/// Descript:	插入订单明细信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-07-30
/// Table:IN_PoItm
/// Input:主表id,
/// 库存项id^单位Id^进价^数量^请求数量
/// Output:		
/// Return：成功:rowid
/// -1:科室或人员为空
/// -99  ;加锁失败
/// -2   ;生成计划单号失败
/// -3   ;保存计划单失败
ClassMethod Insert(Parref As %String, ListData As %String) As %Library.String
{
	n (Parref,ListData)
	s IncId=$p(ListData,"^",1)  //库存项rowid
	s UomId=$p(ListData,"^",2)  //单位rowid
	s Rp=$p(ListData,"^",3)   //进价
	s Qty=+$p(ListData,"^",4)  //数量
	s ReqQty=$p(ListData,"^",5)  //请求数量
	s HDCMInpoiId=$p(ListData,"^",6) //医共体订单子表id
	I ReqQty=""  s ReqQty=Qty  //'INPOI_Req_Qty' in table 'SQLUser.IN_POItm' is a required field
	q:IncId="" -1
	q:Qty<0 -1
	q:Parref="" -1
	;
	s CreateDate=+$h
	s BuomId=$p(^INCI(IncId,1),"^",10)
	q:BuomId=""""  	;基本单位不能为空
	s LocId=""
	s HospId=""
	s DhcPoId=$o(^DHCINPO(0,"INPO",Parref,0))
	;b ;a
	s:DhcPoId'="" LocId=$p(^DHCINPO(DhcPoId),"^",2)
	s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
	s Chl=1+$o(^INPO(Parref,"POI",""),-1)
	
	s Rp = ##Class(web.DHCST.Common.AppCommon).FormatInciRp(Rp,HospId,IncId,UomId) 
  	s RpAmt=Rp*Qty
	s RpAmt = ##Class(web.DHCST.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
  	
	s Err=0
	&sql(insert into IN_PoItm(IN_PO,INPOI_Childsub,INPOI_Date,INPOI_INCI_DR,
	INPOI_CTUOM_DR,INPOI_UnitCost,INPOI_GrossAmt,INPOI_Req_Qty,INPOI_Pur_Qty,
	INPOI_CTLOC_DR,INPOI_HDCMDetailId) 
	values (:Parref,:Chl,:CreateDate,:IncId,:UomId,:Rp,:RpAmt,:ReqQty,:Qty,:LocId,:HDCMInpoiId))
	B
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("Insert:IN_PoItm",Parref,SQLCODE_":"_%msg)
	.s Err=-3
	.
	q:Err'=0 -3    ;保存订单失败
	s PoItmId=$p($g(%ROWID),$c(1))
	q PoItmId
}

/// Descript:取某订单明细对应的入库数量
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-03
/// Table:IN_PoItm，DHC_InGdRecItm
/// Input:采购计划明细id
/// Output:		
/// Return：入库数量
ClassMethod GetImpQty(PoItmId As %String, UomId As %String) As %Library.String
{
	n (PoItmId,UomId)
	q:PoItmId="" 0
	s TotalQty=0
	;
	s Ingr=0
	f  s Ingr=$o(^DHCINGR(0,"PODR",PoItmId,Ingr)) q:Ingr=""  d
	.s Chl=0
	.f  s Chl=$o(^DHCINGR(0,"PODR",PoItmId,Ingr,Chl)) q:Chl=""  d
	..s IncId=+$p(^DHCINGR(Ingr,"GRI",Chl),"^",25)
	..s Qty=$p(^DHCINGR(Ingr,"GRI",Chl),"^",4)
	..s RecUomId=$p(^DHCINGR(Ingr,"GRI",Chl),"^",10)
	..s BUomId=$p(^INCI(IncId,1),"^",10)
	..s PurUomId=$p(^INCI(IncId,3),"^",6)
	..s Fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(RecUomId,BUomId)
	..s Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(UomId,BUomId)
	..s Qty=Qty*Fac1/Fac2
	..s TotalQty=TotalQty+Qty
	.
	q TotalQty
}

/// Descript:	查询订单明细
/// Creater:zhangdongmei
/// CreateDate:2012-10-08
/// Input:开始行,一页显示记录数,排序字段,排序方向,订单主表id
/// Output:		
/// Return:订单子表id^库存项id^库存项代码^库存项名称^单位id^单位^未到货数量^进价^订购数量^已到货数量
/// w ##class(web.DHCST.INPOItm).Query("0","999","","","294")
ClassMethod Query(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, Parref As %String) As %String
{
	n (Parref,Start,Limit,Sort,Dir)
	q:Parref="" "" 
	s DhcPoId=$o(^DHCINPO(0,"INPO",Parref,0))
	s PoLoc =$p(^DHCINPO(DhcPoId),"^",2)
 	s result = ##class(%Library.ResultSet).%New()
 	s StrSql = "SELECT IN_POItm as Rowid, INPOI_INCI_DR,INPOI_INCI_DR->inci_code as IncCode," _
 	"INPOI_INCI_DR->inci_desc as IncDesc, INPOI_CTUOM_DR,INPOI_CTUOM_DR->ctuom_desc as PurUom,"
 			_"INPOI_UnitCost,INPOI_Pur_Qty,INPOI_GrossAmt "
 			_"FROM IN_PoItm WHERE IN_PO= "_Parref
 	s OrderField="Rowid"
    ;
    s:Sort'="" OrderField=Sort
    ;
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i OrderField'=""  d
    .s StrSql=StrSql_" order by "_OrderField_" "_Dir
	s json = ##class(Code.JsonObj).%New()
	;
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	;b ;1
	If err  q ""
	s count = 0
	s end = Start+Limit
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
		s PoItmId = result.Data("Rowid")
		s IncId = result.Data("INPOI_INCI_DR")
		continue:IncId=""
		s PurUomId = result.Data("INPOI_CTUOM_DR")
		s PurUom=result.Data("PurUom")
		s Rp=result.Data("INPOI_UnitCost")
		s RpAmt=result.Data("INPOI_GrossAmt")
		s PurQty =+ result.Data("INPOI_Pur_Qty")  ;订购数量
		s ImpQty=+##class(web.DHCST.INPOItm).GetImpQty(PoItmId,PurUomId)  ;到货数量
		s AvaQty=PurQty-ImpQty    ;还可以入库的数量		;未到货数量
		i AvaQty<0 s AvaQty=0
		s IncCode=result.Data("IncCode")
		s IncDesc=result.Data("IncDesc")
		s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",IncId)
		s ManfDr="",Manf=""
		s ManfInfo=##class(web.DHCST.Common.DrugInfoCommon).GetManf(IncId)
		s ManfDr=$p(ManfInfo,"^",1)
		s Manf=$p(ManfInfo,"^",3)
		s INPPRowid=$o(^INPP(0,"INPOI",PoItmId,""))
		//continue:INPPRowid=""
		i INPPRowid'=""  d
		.s sub=$o(^INPP(0,"INPOI",PoItmId,INPPRowid,""))
		.//continue:sub=""
		.i sub'=""  d
		..s ManfDr=$p(^INPP(INPPRowid,"PPI",sub),"^",6)
		..s Manf=$p($G(^PHMNF(+ManfDr)),"^",2)
		s BUom=$p(^INCI(IncId,1),"^",10)
		s PUom=$p(^INCI(IncId,3),"^",6)
		s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(PUom,BUom)
		;
		s Rp=$FN(Rp,"N")
		s RpAmt=$FN(RpAmt,"N")
		s ImpQty=$FN(ImpQty,"N")
		s AvaQty=$FN(AvaQty,"N")
		s PurQty=$FN(PurQty,"N")
		s Data1=PoItmId_"^"_IncId_"^"_IncCode_"^"_IncDesc_"^"_PurUomId_"^"_$g(PurUom)
		s Data2=AvaQty_"^"_Rp_"^"_PurQty_"^"_ImpQty_"^"_Spec_"^"_Manf_"^"_RpAmt_"^"_BUom_"^"_ConFac
		s Data=Data1_"^"_Data2
		s count = count+1	
		CONTINUE:count<(Start+1)
		CONTINUE:count>end	
		d json.InsertRowData(Data)
	}
 	s Title="PoItmId^IncId^IncCode^IncDesc^PurUomId^PurUom^NotImpQty^Rp^PurQty^ImpQty^Spec^Manf^rpAmt^BUom^ConFac"
 	s resultString = json.getJsonData(Title,count)
 	k json
 	q resultString
}

/// Descript:	查询订单明细(不分页)
/// Creater:zhangdongmei
/// CreateDate:2012-10-08
/// Input:开始行,一页显示记录数,排序字段,排序方向,订单主表id
/// Output:		
/// Return:订单子表id^库存项id^库存项代码^库存项名称^单位id^单位^未到货数量^进价^订购数量^已到货数量
/// w ##class(web.DHCST.INPOItm).Query("0","999","","","11")
ClassMethod QueryALL(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, Parref As %String) As %String
{
	n (Parref,Start,Limit,Sort,Dir)
	q:Parref="" "" 
	s DhcPoId=$o(^DHCINPO(0,"INPO",Parref,0))
	s PoLoc =$p(^DHCINPO(DhcPoId),"^",2)
	s HospId=$P(^CTLOC(PoLoc),"^",22)
 	s result = ##class(%Library.ResultSet).%New()
 	s StrSql = "SELECT IN_POItm as Rowid, INPOI_INCI_DR,INPOI_INCI_DR->inci_code as IncCode," _
 	"INPOI_INCI_DR->inci_desc as IncDesc, INPOI_CTUOM_DR,INPOI_CTUOM_DR->ctuom_desc as PurUom,"
 			_"INPOI_UnitCost,INPOI_Pur_Qty,INPOI_GrossAmt "
 			_"FROM IN_PoItm WHERE IN_PO= "_Parref
 	s OrderField="Rowid"
    ;
    s:Sort'="" OrderField=Sort
    ;
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i OrderField'=""  d
    .s StrSql=StrSql_" order by "_OrderField_" "_Dir
	s json = ##class(Code.JsonObj).%New()
	;
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	;b ;1
	If err  q ""
	s count = 0
	s end = Start+Limit
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	s countnum=0,Title="PoItmId^IncId^IncCode^IncDesc^PurUomId^PurUom^NotImpQty^Rp^PurQty^ImpQty^Spec^Manf^rpAmt^BUom^ConFac^FreeDrugFlag"
	While(result.Next())
	{
		s PoItmId = result.Data("Rowid")
		s IncId = result.Data("INPOI_INCI_DR")
		continue:IncId=""
		s PurUomId = result.Data("INPOI_CTUOM_DR")
		s PurUom=result.Data("PurUom")
		s Rp=result.Data("INPOI_UnitCost")
		s RpAmt=result.Data("INPOI_GrossAmt")
		s PurQty =+ result.Data("INPOI_Pur_Qty")  ;订购数量
		s ImpQty=+##class(web.DHCST.INPOItm).GetImpQty(PoItmId,PurUomId)  ;到货数量
		s AvaQty=PurQty-ImpQty    ;还可以入库的数量		;未到货数量
		i AvaQty<0 s AvaQty=0
		s IncCode=result.Data("IncCode")
		s IncDesc=result.Data("IncDesc")
		s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",IncId)
		s ManfDr="",Manf=""
		s ManfInfo=##class(web.DHCST.Common.DrugInfoCommon).GetManf(IncId)
		s ManfDr=$p(ManfInfo,"^",1)
		s Manf=$p(ManfInfo,"^",3)
		s INPPRowid=$o(^INPP(0,"INPOI",PoItmId,""))
		//continue:INPPRowid=""
		i INPPRowid'=""  d
		.s sub=$o(^INPP(0,"INPOI",PoItmId,INPPRowid,""))
		.//continue:sub=""
		.i sub'=""  d
		..s ManfDr=$p(^INPP(INPPRowid,"PPI",sub),"^",6)
		..s Manf=$p($G(^PHMNF(+ManfDr)),"^",2)
		s BUom=$p(^INCI(IncId,1),"^",10)
		s PUom=$p(^INCI(IncId,3),"^",6)
		s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(PUom,BUom)
		s arcimDr=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(IncId)
    	s freeDrugFlag=##class(web.DHCST.Common.DrugInfoCommon).CheckIfFreeDrug(arcimDr)
		;
		s Rp = ##Class(web.DHCST.Common.AppCommon).FormatInciRp(Rp,HospId,IncId,PurUomId) 
		s RpAmt = ##Class(web.DHCST.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
		s ImpQty=$FN(ImpQty,"N")
		s AvaQty=$FN(AvaQty,"N")
		s PurQty=$FN(PurQty,"N")
		s Data1=PoItmId_"^"_IncId_"^"_IncCode_"^"_IncDesc_"^"_PurUomId_"^"_$g(PurUom)
		s Data2=AvaQty_"^"_Rp_"^"_PurQty_"^"_ImpQty_"^"_Spec_"^"_Manf_"^"_RpAmt_"^"_BUom_"^"_ConFac
		s Data3=freeDrugFlag
		s Data=Data1_"^"_Data2_"^"_Data3
		s count = count+1	
		CONTINUE:count<(Start+1)
		CONTINUE:count>end	
		s countnum=countnum+1
		i countnum=1 d
		.w "{results:0,rows:["
		.w ##class(web.DHCST.Common.UtilCommon).GetJsonStr(Data,Title)
		e  d
		.w ","_##class(web.DHCST.Common.UtilCommon).GetJsonStr(Data,Title)
    }
   
    i countnum=0  w ##class(web.DHCSTEXTCOMMON).GetNoJson() q ""
    w "]}"
    q ""
}

/// 打印明细取值添加query函数
/// 2013-06-24
/// d ##class(%ResultSet).RunQuery("web.DHCST.INPOItm","INPOItmQuery",1)
Query INPOItmQuery(Parref As %String) As %Query(ROWSPEC = "PoItmId:%String,IncId:%String,IncCode:%String,IncDesc:%String,PurUomId:%String,PurUom:%String,AvaQty:%String,Rp:%Float,PurQty:%String,ImpQty:%String,Spec:%String,Manf:%String,RpAmt:%Float,userIO,PoLocDescIO,VenDescIO,HospDescIO") [ SqlProc ]
{
}

ClassMethod INPOItmQueryExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
   s qHandle=$lb(0,repid,0)

   q:Parref="" $$$OK
   
   //s ^YSJTMP("INPOItmQuery")=Parref
   //userIO,PoLocDescIO,VenDescIO,HospDescIO
   s (userIO,PoLocDescIO,VenDescIO,HospDescIO)=""
   s mainInfoStr=##class(web.DHCST.INPO).SelectMain(Parref)
   s userIO=$P(mainInfoStr,"^",34)
   s PoLocDescIO=$P(mainInfoStr,"^",30)
   s VenDescIO=$P(mainInfoStr,"^",33)
   s DhcPoIdd=$o(^DHCINPO(0,"INPO",Parref,0))
   i DhcPoIdd'=""  d
   .s PoLoc =$p(^DHCINPO(DhcPoIdd),"^",2)
   .s:PoLoc'="" HospDescIO=$P(^CTLOC(PoLoc),"^",22)
   .s:HospDescIO'="" HospDescIO=$P(^CT("HOSP",HospDescIO),"^",2)
   
   s result = ##class(%Library.ResultSet).%New()
   s StrSql = "SELECT IN_POItm as Rowid, INPOI_INCI_DR,INPOI_INCI_DR->inci_code as IncCode," _
 	    "INPOI_INCI_DR->inci_desc as IncDesc, INPOI_CTUOM_DR,INPOI_CTUOM_DR->ctuom_desc as PurUom,"
 			_"INPOI_UnitCost,INPOI_Pur_Qty,INPOI_GrossAmt "
 			_"FROM IN_PoItm WHERE IN_PO= "_Parref
   s OrderField="Rowid"
   s json = ##class(Code.JsonObj).%New()
	;
   s result = ##class(%Library.ResultSet).%New()
   d result.Prepare(StrSql)
   s sc=result.Execute()
   s err=$$$ISERR(sc)
	;
   If err  q ""
   s count = 0
   s resultString = ""
   s json = ##class(Code.JsonObj).%New()  
   While(result.Next())
	{	
		s PoItmId = result.Data("Rowid")
		s IncId = result.Data("INPOI_INCI_DR")
		continue:IncId=""
		s PurUomId = result.Data("INPOI_CTUOM_DR")
		s PurUom=result.Data("PurUom")
		s Rp=result.Data("INPOI_UnitCost")
		s RpAmt=result.Data("INPOI_GrossAmt")
		s PurQty =+ result.Data("INPOI_Pur_Qty")  ;订购数量
		s ImpQty=+##class(web.DHCST.INPOItm).GetImpQty(PoItmId,PurUomId)  ;到货数量
		s AvaQty=PurQty-ImpQty    ;还可以入库的数量		;未到货数量
		s IncCode=result.Data("IncCode")
		s IncDesc=result.Data("IncDesc")
		s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",IncId)
		s Manf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(IncId),"^",3)
		
		
		
		d OutPutRow
	}
 Quit $$$OK

OutPutRow
 s Data=$lb(PoItmId,IncId,IncCode,IncDesc,PurUomId,$g(PurUom),AvaQty,Rp,PurQty,ImpQty,Spec,Manf,RpAmt,userIO,PoLocDescIO,VenDescIO,HospDescIO)
 //w Data,!   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod INPOItmQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCPayItmExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod INPOItmQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCPayItmExecute ]
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

/// Descript:	删除某订单明细信息
/// Creater:	gwj
/// CreateDate:	2013-01-25
/// Table:IN_PoItm
/// Input:rowid
/// Output:		
/// Return：成功:0，
/// -1   	;订单已经完成，不能删除
/// -3   ;删除计划明细失败
ClassMethod Delete(Rowid As %String) As %Library.String
{
	n (Rowid)
	;
	q:Rowid="" ""
	s CompFlag=$p(^INPO(+Rowid),"^",9)
 	q:CompFlag="Y" -1   	;订单已经完成，不能删除
 	s Err=0
	&sql(Delete from IN_PoItm  where In_PoItm=:Rowid) 
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("Delete:IN_PoItm",Rowid,SQLCODE_":"_%msg)
	.s Err=-3
	.
	q:Err'=0 -3   ;删除计划明细失败
	;
	q 0
}

/// w ##class(web.DHCST.INPOItm).InsertIntoINPo()
ClassMethod InsertIntoINPo()
{
	f i=1:1:500 d
	.s sub=$o(^INPO(11,"POI",""),-1)+1
	.s val1=11,val2=sub,val3=65581,val4=2080,val5=4,val6=56.1,val7=56.1,val8=1,val9=1,val10=165,val11=11_"||"_sub
	.&SQL(INSERT INTO IN_POItm (IN_PO,IN_POItm, INPOI_Childsub, INPOI_Date, INPOI_INCI_DR, INPOI_CTUOM_DR, INPOI_UnitCost, INPOI_GrossAmt, INPOI_Req_Qty, INPOI_Pur_Qty,INPOI_CTLOC_DR)
	VALUES (:val1,:val11,:val2,:val3,:val4,:val5,:val6,:val7,:val8,:val9,:val10))
	.w SQLCODE_"^"_i

 	q ""
}

}
