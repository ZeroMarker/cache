Import sqluser

/// Descript:采购计划制单(明细)
/// Creater:	ZhangDongmei
/// CreateDate:	2012-06-18
Class web.DHCST.INPurPlanItm Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新采购计划明细信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-06-18
/// Table:IN_PurplanItm
/// Input:计划主表id,
/// 明细Id^库存项id^采购数量^单位Id^供应商Id^进价^厂商id^配送商id^请求科室,
/// 明细Id^库存项id^采购数量^单位Id^供应商Id^进价^厂商id^配送商id^请求科室
/// Output:		
/// Return：0：成功，
/// -5:主表id或明细不能为空
/// -6:所有明细保存均失败
/// 其它：部分明细保存不成功，提示不成功的药品
ClassMethod Save(PurId As %String, ListData) As %Library.String
{
	n (PurId,ListData)
	k SaveData
	q:PurId="" -5
	q:ListData="" -5
	s ListDataStream=##class(%GlobalCharacterStream).%New()
	// 解析
	i ListData["CharacterStream" d ListDataStream.CopyFrom(ListData)
	e  d ListDataStream.Write(ListData)
	s oneRowLen=9		// 每行数据按^分隔的长度
	s uniqueCnt=0
	s readData=""
	f  q:readData="Null"  d
	.s readData=ListDataStream.Read()
	.i readData="" s readData="Null" q
	.s rowLen=$l(readData,$c(1))	// 参考此算法时注意,行间单字符分割
	.s rowI=""
	.f rowI=1:1:rowLen d
	..s uniqueCnt=uniqueCnt+1
	..s rowData=$p(readData,$c(1),rowI)
	..q:rowData=""
	..s quitFlag=""
	..// 需要计算结尾不处于分隔地带
	..i rowI=1 d
	...s rowDataLen=$l(rowData,"^")
	...i rowDataLen<=oneRowLen d
	....s uniqueCnt=uniqueCnt-1
	....s SaveData(uniqueCnt)=$g(SaveData(uniqueCnt))_rowData
	....s quitFlag=1
	..q:quitFlag'=""
	..s SaveData(uniqueCnt)=rowData	
	q:'$d(SaveData) -5
	s Count=0
	s Err=""
	s uniqueId=""
	f  s uniqueId=$o(SaveData(uniqueId)) q:uniqueId=""  d
	.s Data=SaveData(uniqueId)
	.s Rowid=$p(Data, "^", 1)
	.s IncId=$p(Data, "^", 2)
	.s notUseFlag=$P(^INCI(IncId,2), "^", 9)
    .q:notUseFlag="Y"
	.q:IncId=""
	.s IncDesc=$p(^INCI(IncId,1), "^", 2)
	.s Detail=$p(Data, "^", 2,$l(Data,"^"))
	.i Rowid'=""  d
	..s Ret=..Update(Rowid,Detail)
	..i Ret'=0  d
	...s Err=Err_","_IncDesc
	..e  d
	...s Count=Count+1
	.e  d
	..s Ret=..Insert(PurId,Detail)
	..i Ret=""  d
	...s Err=Err_","_IncDesc
	..e  d
	...s Count=Count+1
	.
	k SaveData
	q:Count=0 -6  ;所有明细保存均失败
	q:Err'="" -7_"^"_Err  ;保存失败的药品
	q 0
}

/// Descript:	插入采购计划明细信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-06-18
/// Table:IN_PurplanItm
/// Input:采购计划主表id,库存项id^采购数量^单位Id^供应商Id^进价^厂商id^配送商id^请求科室
/// Output:		
/// Return：成功:rowid，"",失败
ClassMethod Insert(Parref As %String, ListData As %String) As %Library.String
{
	n (Parref,ListData)
	s IncId = $p(ListData, "^", 1)
	s Qty   = $p(ListData, "^", 2)
	s UomId = $p(ListData, "^", 3)
	s VendorId = $p(ListData, "^", 4)
	s Rp       = $p(ListData, "^", 5)
	s ManfId   = $p(ListData, "^", 6)
	s CarrierId = $p(ListData, "^", 7)
	s ReqLocId  = $p(ListData, "^", 8)
	s ProPurQty = $p(ListData, "^", 9)  //建议采购量 bianshuai 2014-05-09
	s DispensQty = $p(ListData, "^", 10)  //消耗数量(入库单位)
	q:IncId="" ""
	//q:+Qty=0 ""
	q:Parref="" ""
	;
	s Chl=1+$o(^INPP(Parref,"PPI",""),-1)
	s LocId=$p(^INPP(Parref), "^", 7)
	s HospId=$p(^CTLOC(LocId), "^", 22)
	//s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(IncId,+$h,UomId,HospId)
	s Sp = ##class(web.DHCST.Common.PriceCommon).GetPriceElse(IncId,+$h,UomId,HospId,"G","")
	;b ;11
	s Err=0
	&sql(
		INSERT INTO IN_PurPlanItm
		(
			INPPI_Parref, INPPI_Childsub, INPPI_INCI_DR, INPPI_Qty, INPPI_CTUOM_DR, 
			INPPI_PurPrice, INPPI_APCVM_DR, INPPI_PHMNF_DR, INPPI_Carrier_DR, INPPI_AvailQty, 
			INPPI_RLOC_DR, INPPI_Sp, INPPI_ProPurQty, INPPI_DispQty
		) 
		VALUES 
		(
			:Parref, :Chl, :IncId, :Qty, :UomId, 
			:Rp, :VendorId, :ManfId, :CarrierId, :Qty, 
			:ReqLocId, :Sp, :ProPurQty, :DispensQty
		)
	)
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("Insert:IN_PurPlanItm", IncId, SQLCODE_":"_%msg)
	.s Err=-3
	.
	q:Err'=0 ""    ;保存计划明细失败
	;
	q $p($g(%ROWID),$c(1))
}

/// Descript:	插入采购计划明细信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-06-18
/// Table:IN_PurplanItm
/// Input:rowid,库存项id^采购数量^单位Id^供应商Id^进价^厂商id^配送商id^请求科室
/// Output:		
/// Return：成功:0，其它,失败
ClassMethod Update(Rowid As %String, ListData As %String) As %Library.String [ Private ]
{
	n (Rowid,ListData)
	s IncId = $p(ListData, "^", 1)
	s Qty   = $p(ListData, "^", 2)
	s UomId = $p(ListData, "^", 3)
	s VendorId = $p(ListData, "^", 4)
	s Rp       = $p(ListData, "^", 5)
	s ManfId   = $p(ListData, "^", 6)
	s CarrierId = $p(ListData, "^", 7)
	s ReqLocId  = $p(ListData, "^", 8)
	s ProPurQty = $p(ListData, "^", 9)
	s DispensQty = $p(ListData, "^", 10)  //消耗数量(入库单位)
	s Parref=+Rowid
	q:IncId="" ""
	//q:+Qty=0 ""
	q:Parref="" ""
	;
	s LocId  = $p(^INPP(Parref), "^", 7)
	s HospId = $p(^CTLOC(LocId), "^", 22)
	//s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(IncId,+$h,UomId,HospId)
	s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(IncId,+$h,UomId,HospId,"G","")
	;
	s Err=0
	&sql(
		UPDATE 
			IN_PurPlanItm 
		SET 
			INPPI_INCI_DR = :IncId,
			INPPI_Qty = :Qty,
			INPPI_CTUOM_DR = :UomId,
			INPPI_PurPrice = :Rp,
			INPPI_APCVM_DR = :VendorId,
			INPPI_PHMNF_DR = :ManfId,
			INPPI_Carrier_DR = :CarrierId,
			INPPI_AvailQty = :Qty,
			INPPI_RLOC_DR = :ReqLocId,
			INPPI_Sp = :Sp, 
			INPPI_DispQty = :DispensQty
		WHERE 
			INPPI_Rowid=:Rowid
	) 
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("Update:IN_PurPlanItm",Rowid,SQLCODE_":"_%msg)
	.s Err=-3
	.
	q:Err'=0 -11    ;更新计划明细失败
	;
	q 0
}

/// Descript:	删除某采购计划明细信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-06-19
/// Table:IN_PurplanItm
/// Input:rowid
/// Output:		
/// Return：成功:0，
/// -1   	;订单已经完成，不能删除
/// -2		;订单已经审核，不能删除
/// -3   ;删除计划明细失败
ClassMethod Delete(Rowid As %String) As %Library.String
{
	n (Rowid)
	;
	q:Rowid="" ""
	s CompFlag=$p(^INPP(+Rowid), "^", 8)
 	s AuditFlag=$p(^INPP(+Rowid), "^", 10)
 	q:CompFlag="Y" -1   	;订单已经完成，不能删除
 	q:AuditFlag="Y" -2		;订单已经审核，不能删除
	;
	s Err=0
	&sql(Delete from IN_PurPlanItm  where INPPI_Rowid=:Rowid) 
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("Update:IN_PurPlanItm",Rowid,SQLCODE_":"_%msg)
	.s Err=-3
	.
	q:Err'=0 -3   ;删除计划明细失败
	//s RowidCh=$o(^INPP(+Rowid,"PPI",""),-1)
	//i RowidCh=""  d
	.//s rett=##class(web.DHCST.INPurPlan).Delete(+Rowid)
	.//s:rett<0 Err=-4
	//q:Err'=0 -4
	;
	q 0
}

/// Descript:	删除某采购计划单所有明细信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-06-19
/// Table:IN_PurplanItm
/// Input:采购计划主表id
/// Output:		
/// Return：成功:0，
/// -1   	;订单已经完成，不能删除
/// -2		;订单已经审核，不能删除
/// -3   ;删除计划明细失败
ClassMethod DeleteAll(Parref As %String) As %Library.String
{
	n (Parref)
	;
	q:Parref="" ""
	q:'$d(^INPP(Parref)) 0   ;已经删除
	s CompFlag=$p(^INPP(Parref), "^", 8)
 	s AuditFlag=$p(^INPP(Parref), "^", 10)
 	q:CompFlag="Y" -1   	;订单已经完成，不能删除
 	q:AuditFlag="Y" -2		;订单已经审核，不能删除
	;
	s Err=0
	&sql(Delete from IN_PurPlanItm  where INPPI_Parref=:Parref) 
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("DeleteAll:IN_PurPlanItm",Parref,SQLCODE_":"_%msg)
	.s Err=-3
	.
	q:Err'=0 -3   ;删除计划明细失败
	;
	q 0
}

/// Descript:	查询某计划单明细信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-06-20
/// Table:IN_PurplanItm
/// Input:开始行,一页显示记录数,排序字段,排序方向,采购计划主表id
/// Output:		
/// Return：子表Rowid^库存项id^代码^名称^规格^厂商id^厂商^数量^单位id^单位
/// ^进价^售价^进价金额^售价金额^供应商id^供应商^配送商id^配送商^通用名^商品名^剂型^订单RowId
/// ^申购科室id^申购科室名称^申购科室库存量^库存上限^库存下限^基本单位id^基本单位和大单位转换系数
/// w ##class(web.DHCST.INPurPlanItm).Query("0","9999","RowId","asc","28")
ClassMethod Query(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, Parref As %String) As %String
{
	n (Parref,Start,Limit,Sort,Dir)
	//s ^YSJTMP("Query") = $LB(Start, Limit , Sort , Dir , Parref)
	i Parref="" w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:Parref=0 ""
	s HospId=""
	s pid=..NewPid()
	s $zt="ErrorQuery"
	s StrSql="select INPPI_Rowid as Rowid,INPPI_Parref->INPP_CTLOC_DR as PlanLocId,INPPI_INCI_DR,INPPI_INCI_DR->INCI_Code as IncCode,INPPI_INCI_DR->INCI_Desc as IncDesc,"_
	"INPPI_PHMNF_DR,INPPI_PHMNF_DR->PHMNF_Name as Manf,INPPI_Qty,INPPI_CTUOM_DR,"_
    " INPPI_CTUOM_DR->CTUOM_Desc as UomDesc,INPPI_PurPrice,INPPI_Sp, INPPI_APCVM_DR,"_
    " INPPI_APCVM_DR->APCVM_Name as Vendor,INPPI_Carrier_DR,INPPI_Carrier_DR->CA_Desc as Carrier,"_
    "INPPI_INPOI_DR,INPPI_RLOC_DR as ReqLocID,INPPI_RLOC_DR->CTLOC_Desc as ReqLoc,INPPI_ProPurQty as ProPurQty,INPPI_ChildSub,INPPI_DispQty  from IN_PurPlanItm "_
    " where INPPI_Parref="_Parref
    s OrderField="INPPI_ChildSub"
    s:Sort="IncCode" OrderField="IncCode"
    s:Sort="IncDesc" OrderField="IncDesc"
    s:Sort="Manf" OrderField="Manf"
    s:Sort="Qty" OrderField="INPPI_Qty"
    s:Sort="Rp" OrderField="INPPI_PurPrice"
    s:Sort="Sp" OrderField="INPPI_Sp"
    s:Sort="VenId" OrderField="Vendor"
    s:Sort="Carrier" OrderField="Carrier"
    s:Sort="ReqLoc" OrderField="ReqLoc"
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i OrderField'=""  d
    .s StrSql=StrSql_" order by "_OrderField_" "_Dir
    s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	i err w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:err ""
	s countrecords = 0
	s End = Start+Limit
	s Start=Start+1
	While(result.Next())
	{	
		s Rowid   = result.Data("Rowid")
		s IncId   = result.Data("INPPI_INCI_DR")
		s IncCode = result.Data("IncCode")
		s IncDesc = result.Data("IncDesc")
		s ManfId  = result.Data("INPPI_PHMNF_DR")
		s Manf    = result.Data("Manf")
		s Qty     = result.Data("INPPI_Qty")
		s UomId	  = result.Data("INPPI_CTUOM_DR")
		s Uom     = result.Data("UomDesc")
		s Rp  	  = result.Data("INPPI_PurPrice")
		s Sp  	  = result.Data("INPPI_Sp")
		s VenId   = result.Data("INPPI_APCVM_DR")
		s Vendor  = result.Data("Vendor")
		s CarrierId = result.Data("INPPI_Carrier_DR")
		s Carrier = result.Data("Carrier")
		s PoId    = result.Data("INPPI_INPOI_DR")
		s ReqLocId = result.Data("ReqLocID")
		s ReqLoc  = result.Data("ReqLoc")
		s ProPurQty = result.Data("ProPurQty")
		s PlanLocId = result.Data("PlanLocId")
		s DispQty   = result.Data("INPPI_DispQty")
		s DispQty = $FN(DispQty,"N")
		s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec(IncCode,IncId)
		s GeneInfo=##class(web.DHCST.Common.DrugInfoCommon).GetGene(IncId)
		s Gene=$p(GeneInfo, "^", 2)
		s GoodName=##class(web.DHCST.Common.DrugInfoCommon).GetGoodName(IncId)
		s FormInfo=##class(web.DHCST.Common.DrugInfoCommon).GetForm(IncId)
		s Form=$p(FormInfo, "^", 2)
		s StkQty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(IncId,ReqLocId,UomId,+$h)  //申购科室库存
		s CurStkQty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(IncId,PlanLocId,UomId,+$h)   //采购科室库存
		s QtyInfoLocId=""
		i ReqLocId'="" s QtyInfoLocId=ReqLocId
		e  s QtyInfoLocId=PlanLocId  //明细申购科室为空时,上下限默认采购科室,yunhaibao2016-01-11
		s QtyInfo=##class(web.DHCST.Common.DrugStkCommon).GetItmLocMNRQtyUO(IncId,QtyInfoLocId,UomId) 
		s MinQty=$p(QtyInfo, "^", 1)
		s MaxQty=$p(QtyInfo, "^", 2)
		s RpAmt=Rp*Qty
		s SpAmt=Sp*Qty
		s RecQty=..GetImpQty(Rowid,UomId)
		s LeftQty=Qty-RecQty
		i LeftQty<0 s LeftQty=0
		s BUomId=$p(^INCI(IncId,1), "^", 10)
		s PurUomId=$p(^INCI(IncId,3), "^", 6)
		s PurUomDesc=$p($g(^CT("UOM",PurUomId)), "^", 2)
		s PackUomStr=##class(web.DHCST.Common.DrugInfoCommon).GetIncPackUom(IncId)
		s PackUomDesc=$p(PackUomStr, "^", 2)
		s PackPurFac=$p(PackUomStr, "^", 3)
		i PackUomDesc'="" s PackUomDesc=PackPurFac_$p(PurUomDesc,"[",1)_"/"_PackUomDesc
		s Confac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
		i HospId="" s HospId=$p($g(^CTLOC(PlanLocId)), "^", 22)
		s HospitalQty=##class(web.DHCST.Common.DrugStkCommon).QtyHospInc(IncId,HospId,+$h,UomId)
		s IncDesc=##class(ext.util.String).EvalJSON(IncDesc)  
		s arcimDr=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(IncId)
    	s freeDrugFlag=##class(web.DHCST.Common.DrugInfoCommon).CheckIfFreeDrug(arcimDr)
    	s Qty=$fn(Qty,"N")
    	s DFlag=$S(PurUomId=UomId:1,1:2)
    	s Rp = ##Class(web.DHCST.Common.AppCommon).FormatRp(Rp,HospId,DFlag,"G","",IncId)
    	s Sp = ##Class(web.DHCST.Common.AppCommon).FormatSp(Sp,HospId,DFlag,"G","",IncId)
    	s RpAmt = ##Class(web.DHCST.Common.AppCommon).FormatRpAmt(RpAmt,HospId,"G")
    	s SpAmt = ##Class(web.DHCST.Common.AppCommon).FormatSpAmt(SpAmt,HospId,"G")
    	
		s Data1=Rowid_"^"_IncId_"^"_IncCode_"^"_IncDesc_"^"_Spec_"^"_ManfId_"^"_Manf 
		s Data2=Qty_"^"_UomId_"^"_Uom_"^"_Rp_"^"_Sp_"^"_RpAmt_"^"_SpAmt_"^"_VenId 
		s Data3=Vendor_"^"_CarrierId_"^"_Carrier_"^"_Gene_"^"_GoodName_"^"_Form_"^"_PoId_"^"_ReqLocId 
		s Data4=ReqLoc_"^"_StkQty_"^"_MaxQty_"^"_MinQty_"^"_RecQty_"^"_LeftQty_"^"_BUomId_"^"_Confac_"^"_ProPurQty_"^"_CurStkQty
		s Data5=PackUomDesc_"^"_HospitalQty_"^"_freeDrugFlag_"^"_DispQty
		s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","INPurPlanItm","Query",pid,countrecords)=Data
	}
	i countrecords=0 w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:countrecords=0 ""
	i End>countrecords s End=countrecords
	s Title1="RowId^IncId^IncCode^IncDesc^Spec^ManfId^Manf^Qty^UomId^Uom^Rp" 
	s Title2="Sp^RpAmt^SpAmt^VenId^Vendor^CarrierId^Carrier^Gene^GoodName^Form^PoId" 
	s Title3="ReqLocId^ReqLoc^StkQty^MaxQty^MinQty^RecQty^LeftQty^BUomId^ConFacPur^ProPurQty^CurStkQty"
	s Title4="PackUomDesc^HospitalQty^FreeDrugFlag^DispQty" 
	s Title=Title1_"^"_Title2_"^"_Title3_"^"_Title4
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","INPurPlanItm","Query",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","INPurPlanItm","Query",pid,outputi)
	.s count = count+1
	.q:count<Start
	.q:count>End
	.i count=Start d
	..w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(countrecords)
	..s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	..w retstring
	.e  d
	..s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	..w ","_retstring
	i count=0 w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:count=0 ""
	w "]}"
	k ^TMP("DHCST","INPurPlanItm","Query",pid)
	q ""
ErrorQuery
	k ^TMP("DHCST","INPurPlanItm","Query",pid)
	q $ze
}

/// Descript:取某采购明细对应的入库数量
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-03
/// Table:IN_PurplanItm，DHC_InGdRecItm
/// Input:采购计划明细id
/// Output:		
/// Return：入库数量
ClassMethod GetImpQty(PurItmId As %String, UomId As %String) As %Library.String
{
	n (PurItmId,UomId)
	q:PurItmId="" 0
	s TotalQty=0
	;
	s PoItmId=$p(^INPP(+PurItmId,"PPI",$p(PurItmId,"||",2)), "^", 7)
	q:PoItmId="" 0
	s Ingr=0
	f  s Ingr=$o(^DHCINGR(0,"PODR",PoItmId,Ingr)) q:Ingr=""  d
	.s Chl=0
	.f  s Chl=$o(^DHCINGR(0,"PODR",PoItmId,Ingr,Chl)) q:Chl=""  d
	..s IncId=+$p(^DHCINGR(Ingr,"GRI",Chl), "^", 25)
	..s Qty=$p(^DHCINGR(Ingr,"GRI",Chl), "^", 4)
	..s RecUomId=$p(^DHCINGR(Ingr,"GRI",Chl), "^", 10)
	..s BUomId=$p(^INCI(IncId,1), "^", 10)
	..s PurUomId=$p(^INCI(IncId,3), "^", 6)
	..s Fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(RecUomId,BUomId)
	..s Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(UomId,BUomId)
	..s Qty=Qty*Fac1/Fac2
	..s TotalQty=TotalQty+Qty
	.
	q TotalQty
}

/// 检索采购单明细
/// Author:zhangxiao
/// Date:2013-06-15
/// Argu:
/// Parref - 采购单主表rowid
/// Return:
///  采购单明细信息数据(采购明细RowId，库存rowid，药品代码，药品名称，数量，单位，进价，进价金额，售价，售价金额，供应商，厂商,订单子表,配送商,可用数量,科室 )
///  d ##class(%ResultSet).RunQuery("web.DHCST.INPurPlanItm","INPurPlanItm",2)
Query INPurPlanItm(Parref As %String, zbFlagIO As %String) As %Query(ROWSPEC = "INPPI:%String,inci:%String,inciCode:%String,inciDesc:%String,qty:%String,uomDesc:%String,rp:%Float,rpAmt:%Float,sp:%Float,spAmt:%Float,vendor:%String,manf:%String,inpoitm:%String,carrier:%String,valqty:%String,ReqLoc:%String,InPurPlanLocIO,userIO,HospDescIO,zbFlagIO") [ SqlProc ]
{
}

ClassMethod INPurPlanItmExecute(ByRef qHandle As %Binary, Parref As %String, zbFlagIO As %String = "") As %Status
{
  s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 ;
 q:Parref="" $$$OK
 
 // InPurPlanLocIO,userIO,HospDescIO,zbFlagIO
 s (InPurPlanLocIO,userIO,HospDescIO)=""
 i zbFlagIO s zbFlagIO=""
 e  i zbFlagIO=2  s zbFlagIO="招标"
 e  s zbFlagIO="非招标"
 s MainInfoStr=##class(web.DHCST.INPurPlan).Select(Parref)
 s InPurPlanLocIO=$P(MainInfoStr, "^", 4)
 s userIO=$P(MainInfoStr, "^", 7)
 s purLocId = $p(^INPP(Parref), "^", 7)
 s HospDescIO=$P(^CTLOC(purLocId), "^", 22)
 s:HospDescIO'="" HospDescIO=$P(^CT("HOSP",HospDescIO), "^", 2)
 
 s StrSql="select INPPI_Rowid as Rowid,INPPI_INCI_DR,INPPI_INCI_DR->INCI_Code as IncCode,INPPI_INCI_DR->INCI_Desc as IncDesc,"_
	"INPPI_PHMNF_DR,INPPI_PHMNF_DR->PHMNF_Name as Manf,INPPI_Qty,INPPI_CTUOM_DR,"_
    " INPPI_CTUOM_DR->CTUOM_Desc as UomDesc,INPPI_PurPrice,INPPI_Sp,INPPI_AvailQty,INPPI_APCVM_DR,"_
    " INPPI_APCVM_DR->APCVM_Name as Vendor,INPPI_Carrier_DR,INPPI_Carrier_DR->CA_Desc as Carrier,"_
    "INPPI_INPOI_DR,INPPI_RLOC_DR,INPPI_RLOC_DR->CTLOC_Desc as ReqLoc from IN_PurPlanItm "_
    " where INPPI_Parref="_Parref
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
		s INPPI = result.Data("Rowid")
		s inci = result.Data("INPPI_INCI_DR")
		s inciCode = result.Data("IncCode")
		;s ^ZX("inciCode")=inciCode
		s inciDesc = result.Data("IncDesc")
		;s:$f(inciDesc,"-") inciDesc=$p(inciDesc,"-",2)
		s ManfId = result.Data("INPPI_PHMNF_DR")
		s manf = result.Data("Manf")
		s qty = result.Data("INPPI_Qty")
		s UomId = result.Data("INPPI_CTUOM_DR")
		s uomDesc = result.Data("UomDesc")
		s rp = result.Data("INPPI_PurPrice")
		s sp = result.Data("INPPI_Sp")
		s rpAmt=rp*qty
		s spAmt=sp*qty
		s VenId = result.Data("INPPI_APCVM_DR")
		s vendor = result.Data("Vendor")
		s CarrierId = result.Data("INPPI_Carrier_DR")
		s carrier = result.Data("Carrier")
		s inpoitm= result.Data("INPPI_INPOI_DR")
		s valqty=result.Data("INPPI_AvailQty")
		s ReqLocId = result.Data("INPPI_RLOC_DR")
		s ReqLoc = result.Data("ReqLoc")
		
		
		
		d OutPutRow
	}
 Quit $$$OK

OutPutRow
 s Data=$lb(INPPI,inci,inciCode,inciDesc,qty,uomDesc,rp,rpAmt,sp,spAmt,vendor,manf,inpoitm,carrier,valqty,ReqLoc,InPurPlanLocIO,userIO,HospDescIO,zbFlagIO)
 //w Data,!   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod INPurPlanItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCPayItmExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod INPurPlanItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCPayItmExecute ]
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

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("INPurPlanItm"))
}

}
