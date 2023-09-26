Import sqluser

/// Descript:入库明细表相关
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-26
Class web.DHCSTMHUI.DHCINGdRecItm Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:   保存/更新入库明细信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-26
/// Table:DHC_InGdRecItm
/// Input:主表id,
/// 明细id^库存项RowId^批号^效期^生产厂家RowId^入库单位RowId^入库数量^进价^New售价^随行单号^发票号^发票日期^订单明细id^摘要^备注^质检单号^定价类型^高值条码^vendor^oeori,
/// 明细id^库存项RowId^批号^效期^生产厂家RowId^入库单位RowId^入库数量^进价^New售价^随行单号^发票号^发票日期^订单明细id^摘要^备注^质检单号^定价类型^高值条码^vendor^oeori,
/// Output:     
/// Return：0：成功，
/// 失败：ErrCode:ErrInfo
ClassMethod Save(IngrId As %String, ListData, MainInfo As %String) As RtnObj
{
	n (IngrId,ListData,MainInfo)
	s RtnObj=##class(RtnObj).%New()
 	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(MainInfo)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	i ((IngrId="")||('$d(^DHCINGR(IngrId))))  d
	.s Sc=RtnObj.Err(-2,"","入库单不存在!","",0)
	q:RtnObj.success'=0 RtnObj
	i (ListData="")  d
	.s Sc=RtnObj.Err(-3,"","不存在需要保存的明细!","",0)
	q:RtnObj.success'=0 RtnObj
	s VenId=PJObj.%Get("ApcvmDr")
	i VenId="" s VenId=PJObj.%Get("Vendor")  ;由于界面combbox值空显示数字问题，改了命名，以防存在遗漏的地方
	s LocId=PJObj.%Get("RecLoc")
	s CreateUser=PJObj.%Get("gUserId")
	s GroupId="",HospId=""
	s:CreateUser'="" GroupId=$p(^SSU("SSUSR",CreateUser),"^",5)
	s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
	s Param=GroupId_"^"_LocId_"^"_CreateUser_"^"_HospId
	s NewSpAsSp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(##class(web.DHCSTMHUI.DHCINGdRec).%GetParameter("AppName"),"NewSpAsSp",Param)
	s PJObjItm=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObjItm.%FromJSON(ListData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","明细入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s Err=""
	While (RtnObj.success=0) {
		s ItmObj=PJObjItm.%Pop()
		q:ItmObj=""
		
		s RtnObj=..Update(IngrId,ItmObj,NewSpAsSp)
	}
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Descript:   保存/更新入库明细信息提供js调用
/// Creater:    lihui
/// CreateDate: 20180831
ClassMethod DetailSaveForJs(IngrId As %String, ListData, MainInfo As %String) As %Library.String
{
	n (IngrId,ListData,MainInfo)
	s RtnObj=##class(RtnObj).%New()
	ts
	s RtnObj=..Save(IngrId,ListData,MainInfo)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:更新入库明细信息
/// Creater:ZhangDongmei
/// CreateDate: 2012-06-26
/// Table:DHC_InGdRecItm
/// Input:rowid,库存项RowId^批号^效期^生产厂家RowId^入库单位RowId^入库数量^进价^New售价^随行单号^发票号^发票日期^发票金额
/// Output:     
/// Return：成功:0，其它,失败
/// w ##class(web.DHCSTMHUI.DHCINGdRecItm).Update("4574||1","37^2013060306^2015-06-03^18^7^5^6.96^8^^^^^^^^2")
ClassMethod Update(Parref As %String, ListDataObj As %String, NewSpAsSp As %String = "") As RtnObj
{
	n (Parref,ListDataObj,NewSpAsSp)
	s RtnObj=##class(RtnObj).%New()
	s Rowid=ListDataObj.%Get("RowId")
	s IncId=ListDataObj.%Get("IncId")
	s BatNo=ListDataObj.%Get("BatchNo")
	s ExpDate=ListDataObj.%Get("ExpDate")
	s ExpDate=..DH2L(ExpDate)
	s ManfId=ListDataObj.%Get("ManfId")
	s UomId=ListDataObj.%Get("IngrUomId")
	s Qty=ListDataObj.%Get("RecQty")
	s Rp=ListDataObj.%Get("Rp")
	s NewSp=ListDataObj.%Get("NewSp")
	s SxNo=ListDataObj.%Get("SxNo")
	s InvNo=ListDataObj.%Get("InvNo")
	s InvDate=ListDataObj.%Get("InvDate")
	s InvDate=..DH2L(InvDate)
	s PoItmId=ListDataObj.%Get("Inpoi")
	s Remark=ListDataObj.%Get("Remark")
	s Remarks=ListDataObj.%Get("Remarks")
	s Remarks=$lfs(Remarks,$c(3))
	s QualityNo=ListDataObj.%Get("QualityNo")
	s MtDr=ListDataObj.%Get("MtDr")
	s SterilizedNo=ListDataObj.%Get("SterilizedNo")
	s AdmNo=ListDataObj.%Get("AdmNo")
	s AdmExpDate=ListDataObj.%Get("AdmExpdate")
	s AdmExpDate=..DH2L(AdmExpDate)
	s InvAmt=ListDataObj.%Get("InvMoney") 
	s SpecDesc=ListDataObj.%Get("SpecDesc")
	s OrderDetailSubId=ListDataObj.%Get("OrderDetailSubId")	//平台配送明细ID
	s RequestLoc=ListDataObj.%Get("reqLocId")
	s Sp=ListDataObj.%Get("Sp")
	s Tax=ListDataObj.%Get("Tax")       ;20180223
	s:Tax="" Tax=0
	s ProduceDate=ListDataObj.%Get("ProduceDate")
	s ProduceDate=..DH2L(ProduceDate)
	s InvCode=ListDataObj.%Get("InvCode")
	s DetailId=ListDataObj.%Get("DetailId")	//第三方批次id
	s ThirdCode=ListDataObj.%Get("ThirdCode")	//第三方单据号
	s ThirdId=ListDataObj.%Get("ThirdId")	//第三方单据明细id
	s Barcode=ListDataObj.%Get("HVBarCode")   /// 高值条码
	s RedItmId=ListDataObj.%Get("RedItmId")	//红冲明细ID
	i ((Parref="")||(IncId="")) s Sc=RtnObj.Err(-2,"","明细不存在!","",0) q RtnObj
	s IncDesc=$p(^INCI(IncId,1),"^",2)
	i (Sp="") s Sc=RtnObj.Err(-2,"",IncDesc_"售价不存在!","",0) q RtnObj
	i (+Qty=0) s Sc=RtnObj.Err(-2,"",IncDesc_"数量为空!","",0) q RtnObj
	
	i (Rowid="")&&(Barcode'="") d
	.&sql(select dhcitd_pointer into :Rowid from dhc_itmtrackdetail where dhcitd_parref->dhcit_label=:Barcode and dhcitd_type='G' and dhcitd_parref->DHCIT_OriginalStatus!='NotUnique')

	s inclb=""
	s:Rowid'="" inclb=$p(^DHCINGR(+Rowid,"GRI",$p(Rowid,"||",2)),"^",1)
	q:inclb'="" RtnObj.Err(-2,"","明细已审核!","",0)

	s CreateUser=$p(^DHCINGR(Parref),"^",16)
	s VenId=$p(^DHCINGR(Parref),"^",3)
	s LocId=$p(^DHCINGR(Parref),"^",13)
	s HospId=""
	s:LocId'="" HospId=$p($g(^CTLOC(LocId)),"^",22)
	
	s BuomId=$p(^INCI(IncId,1),"^",10)
	s PurUomId=$p(^INCI(IncId,3),"^",6)
	i (BuomId="") s Sc=RtnObj.Err(-2,"",IncDesc_"基本单位为空!","",0) q RtnObj
	i (UomId'=BuomId)&&(UomId'=PurUomId) s Sc=RtnObj.Err(-1,"",IncDesc_"入库单位错误!") q RtnObj

	//判断临采物资入库数量是否已超标
	s MainlocId=##class(web.DHCSTMHUI.Common.UtilCommon).MLoc(LocId)
	s IntrUomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BuomId)
	s QtyBUom=Qty*IntrUomFac
	s TemPurchaseInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTemPurchaseInfo(IncId)
	s TemPurchaseFlag=$p(TemPurchaseInfo,"^",1)
	s TemPRecMaxQty=$p(TemPurchaseInfo,"^",2)
	s (RecMaxQtyBUom,CurRecQtyBUom)=""
	i (MainlocId="")&&(TemPurchaseFlag="Y")&&(TemPRecMaxQty'="") d
	.s ReceivedQty=+..GetReceivedQty(IncId,Rowid)
	.s CurRecQtyBUom=ReceivedQty+QtyBUom
	.s RecMaxQtyBUom=(+TemPRecMaxQty)*IntrUomFac
	i (RecMaxQtyBUom'="")&&(CurRecQtyBUom'="")&&(CurRecQtyBUom>RecMaxQtyBUom) s Sc=RtnObj.Err(-10,"",IncDesc_"入库数量已超过临采最大量!") q RtnObj
	
	//处理依据订单生成入库单没有定价类型的问题
	i MtDr="" d
	.s MtInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMarkType(IncId)
	.s MtDr=$p(MtInfo,"^",1)
	
	s Param=""_"^"_LocId_"^"_""_"^"_HospId   //根据科室和医院获取
	s AppName=##class(web.DHCSTMHUI.DHCINGdRec).%GetParameter("AppName")
	s NotBatDefaSp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"NotBatDefaSp",Param)
	s BatSpFlag=##class(web.DHCSTMHUI.Common.AppCommon).GetCommPropValue("BatSp",Param)
	;NewSpAsSp参数,在批次售价环境下的特殊处理
	i (BatSpFlag="1")&&(NewSpAsSp="Y")&&(NewSp'="") d
	.s Sp=NewSp
	s:+NewSp=0 NewSp=Sp
	i UomId=BuomId d
	.s NewSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(NewSp,HospId,2)
	.s Rp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(Rp,HospId,2)
	.s Sp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(Sp,HospId,2)
	e  d
	.s NewSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(NewSp,HospId,1)
	.s Rp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(Rp,HospId,1)
	.s Sp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(Sp,HospId,1)
	
	s SpAmt=Sp*Qty
	s RpAmt=Rp*Qty
	s NewSpAmt=NewSp*Qty
	s:+InvAmt=0 InvAmt=RpAmt
	s TaxAmt=Tax*Qty
	s SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
	s NewSpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(NewSpAmt,HospId) 
	s RpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
	s Margin=$s(+Rp'=0:Sp/Rp-1,1:"")
	
	s InvSetDate=""
	i Rowid'="" d
	.s InvSetDate=..GetInvSetDate(Rowid,"G",InvNo) ;获取发票录入日期
	e  d
	.s:InvNo'="" InvSetDate=+$h
	
	s AddFlag="Y"	//是否新增
	i Rowid="" d
	.s Chl=1+$o(^DHCINGR(Parref,"GRI",""),-1)
	.&sql(INSERT INTO DHC_INGdRecItm(INGRI_INGR_ParRef,INGRI_ChildSub,INGRI_BatchNo,INGRI_CTLOC_DR, 
		INGRI_CTUOM_DR,INGRI_ExpDate,INGRI_Margin,INGRI_RecQty, INGRI_StkDesc,initm_INCI_DR, initm_invmoney, 
		initm_invno, initm_phmnf_dr, initm_realprice,initm_realtotal, initm_saleprice, initm_invdate, 
		initm_BatPrice, initm_sxno,initm_newSp, initm_newSpAmt,initm_SpAmt,INGRI_INPOI_DR,initm_Remark,INGRI_Remarks,initm_QualityNo,initm_MT_Dr,initm_SterilizedBat,
		initm_AdmNo,initm_AdmExpdate,initm_SpecList,initm_OrderDetailSubId,INGRI_Tax,INGRI_TaxAmount,initm_InvSetDate,initm_ProduceDate,initm_InvCode)
		VALUES(:Parref, :Chl, :BatNo, :LocId,:UomId,:ExpDate,:Margin,:Qty, :IncDesc,
		:IncId, :InvAmt,:InvNo,:ManfId,:Rp,:RpAmt,:Sp,:InvDate,:Rp, :SxNo,:NewSp,:NewSpAmt,:SpAmt,:PoItmId,:Remark,:Remarks,:QualityNo,:MtDr,:SterilizedNo,
		:AdmNo,:AdmExpDate,:SpecDesc,:OrderDetailSubId,:Tax,:TaxAmt,:InvSetDate,:ProduceDate,:InvCode))
	.i SQLCODE'=0  d RtnObj.Err(-2,"",IncDesc_"保存入库明细失败!")
	.q:RtnObj.success'=0
	.s Rowid=$p($g(%ROWID),$c(1))
	.;保存第三方明细id
	.s ThirdObj={},ThirdObj.ThirdCode=ThirdCode,ThirdObj.Type="G",ThirdObj.Pointer=Rowid,ThirdObj.ThirdId=ThirdId
	.s ThirdStr=ThirdObj.%ToJSON()
	.s RtnObj=##class(web.DHCSTMHUI.DHCServiceBill).Save(ThirdStr)
	.q:RtnObj.success'=0
	.i (Barcode'="") d
	..s operData=LocId_"^"_CreateUser_"^"_IncId_"^^"_VenId
	..s Pointerid=Rowid
	..s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).Update("G",Pointerid,Barcode,operData)
	.i RtnObj.success'=0 d RtnObj.Err(-6,"","保存"_IncDesc_"跟踪信息失败!")
	.q:RtnObj.success'=0
	e  d
	.s AddFlag="N"
	.&sql(Update DHC_INGdRecItm set INGRI_BatchNo=:BatNo,INGRI_CTUOM_DR=:UomId,INGRI_ExpDate=:ExpDate,
		INGRI_Margin=:Margin,INGRI_RecQty=:Qty,INGRI_StkDesc=:IncDesc,initm_INCI_DR=:IncId, 
		initm_invmoney=:InvAmt,initm_invno=:InvNo, initm_phmnf_dr=:ManfId,initm_realprice=:Rp,
		initm_realtotal=:RpAmt, initm_saleprice=:Sp, initm_invdate=:InvDate,initm_BatPrice=:Rp, 
		initm_sxno=:SxNo,initm_newSp=:NewSp, initm_newSpAmt=:NewSpAmt,initm_Remark=:Remark,
		INGRI_Remarks=:Remarks,initm_QualityNo=:QualityNo,initm_SpAmt=:SpAmt,initm_SterilizedBat=:SterilizedNo ,
		initm_AdmNo=:AdmNo,initm_AdmExpdate=:AdmExpDate,initm_SpecList=:SpecDesc,INGRI_Tax=:Tax,INGRI_TaxAmount=:TaxAmt,
		initm_InvSetDate=:InvSetDate,initm_ProduceDate=:ProduceDate,initm_InvCode=:InvCode  where INGRI_Rowid=:Rowid) 
	.i SQLCODE'=0  d RtnObj.Err(-3,"",IncDesc_"更新入库明细失败!")
	q:RtnObj.success'=0 RtnObj
	
	s AddInfo=$o(^DHCINGRINFO(0,"INGRI",Rowid,""),-1)
	i (AddFlag="Y")&&(AddInfo'="") d
	.s AddInfo=""
	.&sql(delete from DHC_INGdRecItmAddionInfo where INGRINFO_DR=:Rowid)
	.i SQLCODE'=0 d RtnObj.Err(-12,PoId,"附加表历史数据删除失败!"_SQLCODE)
	q:RtnObj.success'=0 RtnObj
	
	i AddInfo="" d
	.&sql(INSERT INTO DHC_INGdRecItmAddionInfo(INGRINFO_DR,INGRINFO_ReqLoc_Dr,INGRINFO_DetailId)
		VALUES (:Rowid,:RequestLoc,:DetailId))
	.i SQLCODE'=0 d RtnObj.Err(-3,"",IncDesc_"保存入库明细附加表失败!")
	.q:RtnObj.success'=0
	e  d
	.&sql(update DHC_INGdRecItmAddionInfo set INGRINFO_ReqLoc_Dr=:RequestLoc where INGRINFO_DR=:Rowid)
	.i SQLCODE<0  d RtnObj.Err(-4,"",IncDesc_"更新入库明细附加表失败!")
	.q:RtnObj.success<0
	q:RtnObj.success'=0 RtnObj
	i +RedItmId>0 d
	.&sql(update HRP_MAT.INGRRedOffsetItm set INGRROI_NewIngri_DR=:Rowid where %id=:RedItmId)
	.i SQLCODE<0  d RtnObj.Err(-4,"",IncDesc_"更新红冲明细表失败!")
	.q:RtnObj.success<0
	q:RtnObj.success'=0 RtnObj
	s RtnObj.rowid=Rowid
	q RtnObj
}

/// Descript:   删除某入库明细信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-26
/// Table:DHC_InGdRecItm
/// Input:rowid
/// Output:     
/// Return：成功:0，
/// -1  ;入库单已经完成，不能删除
/// -2  ;入库单已经审核，不能删除
/// -3  ;删除入库明细失败
/// -4  ;明细已经审核
/// w ##class(web.DHCSTMHUI.DHCINGdRecItm).Delete(^tmpli("Deleteingri"))
ClassMethod Delete(Params As %String) As %Library.String
{
	n (Params)

	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s $ZT=..sssError()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Rowid=Obj.%Get("RowId")
		s CompFlag=$p(^DHCINGR(+Rowid),"^",23)
		i CompFlag="Y" d RtnObj.Err(-2,"","入库单已完成不允许删除!","",0) q
		s AuditFlag=$p(^DHCINGR(+Rowid),"^",29)
		i AuditFlag="Y" d RtnObj.Err(-3,"","入库单已经审核不允许删除!","",0) q
		s inclb=$p(^DHCINGR(+Rowid,"GRI",$p(Rowid,"||",2)),"^",1)
		i inclb'="" d RtnObj.Err(-4,"","此明细已经审核不允许删除!","",0) q

		//先处理SCI平台订单状态
		s LocId=$p(^DHCINGR(+Rowid),"^",13)
		s HospId=..sssHospId(LocId)
		d ##class(web.DHCSTMHUI.ServiceForSCI).deleteOrderitm(Rowid)
		d ##class(web.DHCSTMHUI.ServiceForECS).DeleteIngrItm(Rowid,HospId)
		
		s RtnObj=##class(web.DHCSTMHUI.DHCItmTrackDetail).DelByPointer("G",Rowid)
		i RtnObj.success'=0 s Sc=RtnObj.Err(-5,"","处理该条码跟踪信息失败!") q
		;处理子表附加表
		s ingriadd=""
		s ingriadd=$o(^DHCINGRINFO(0,"INGRI",Rowid,0))
		i ingriadd'="" d
		.&sql(Delete From DHC_INGdRecItmAddionInfo  where INGRINFO_DR=:Rowid) 
		.i SQLCODE'=0 d RtnObj.Err(-6,"","处理子表附加表失败!")
		i RtnObj.success'=0 q
		
		;处理子表附加表
		&sql(Delete From DHC_InGdRecItm  where INGRI_Rowid=:Rowid) 
		i SQLCODE'=0 d RtnObj.Err(-7,"","此明细删除失败!")
		i RtnObj.success'=0 q
		
		s oerecflag=##class(web.DHCSTMHUI.DHCINGdRec).GetOeriRecFlag(+Rowid)
		i oerecflag="Y" d
		.&sql(update DHC_HVMat_OrdItm set ORI_INGRI_Modify_DR=null,ORI_IngrFlag=null,ORI_DateOfManu=null where ORI_INGRI_Modify_DR=:Rowid)
		i SQLCODE'=0 d RtnObj.Err(-8,"","处理条码补录信息失败!")
		i RtnObj.success'=0 q
		
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:   删除某入库单所有明细信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-26
/// Table:DHC_InGdRecItm
/// Input:入库主表id
/// Output:     
/// Return：成功:0，
/// -1      ;订单已经完成，不能删除
/// -2      ;订单已经审核，不能删除
/// -3   ;删除计划明细失败
ClassMethod DeleteAll(Parref As %String) As %Library.String
{
	n (Parref)
	;
	q:Parref="" ""
	q:'$d(^DHCINGR(Parref)) 0   ;已经删除
	s CompFlag=$p(^DHCINGR(Parref),"^",23)
	s AuditFlag=$p(^DHCINGR(Parref),"^",29)
	q:CompFlag="Y" -1       ;入库单已经完成，不能删除
	q:AuditFlag="Y" -2      ;入库单已经审核，不能删除
	s Err=0
	&sql(Delete From DHC_InGdRecItm  where INGRI_INGR_ParRef=:Parref) 
	i SQLCODE'=0  d
	.s Err=-3
	q:Err'=0 -3   ;删除入库明细失败
	;
	q 0
}

/// Descript:   根据入库单RowId取得入库单明细信息
/// Creater: zhangdongmei
/// CreateDate: 2012-06-26
/// Input: 开始行,一页显示记录数,排序字段,排序方向,入库主表id     
/// Return：入库子表id^批号^入库单位Id^入库单位^效期^批次id^订单子表id^加成^入库数量^备注^库存项id^库存项代码
/// ^库存项名称^发票金额^发票号^付款单号^生产厂家Id^生产厂家^进价^进价金额^售价^售价金额^发票日期^批次进价
/// ^质检单号^随行单号^摘要^入库售价^入库售价金额^定价类型id^定价类型^招标轮次id^招标轮次^基本单位Id^包装单位和基本单位转换率"
/// ^检测口岸^检测报告^报告日期^注册证号^注册证有效期^包装合格^规格^当前加成^高值标志(Y/N)^高值条码
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINGdRecItm","QueryDetail",116)
Query QueryDetail(Parref As %String) As Query(ROWSPEC = "RowId,BatchNo,IngrUomId,IngrUom,ExpDate,Inclb,Inpoi,Margin,RecQty:%Float,Remarks,IncId,IncCode,IncDesc,InvMoney:%Float,InvNo,PayNo,ManfId,Manf,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,InvDate,BatRp:%Float,QualityNo,SxNo,NewSp:%Float,NewSpAmt:%Float,MtDr,MtDesc,PubBL,PubDesc,BUomId,ConFacPur,CheckPort,CheckRepNo,CheckRepDate,AdmNo,AdmExpdate,CheckPack,Spec,Marginnow,HVFlag,HVBarCode,SterilizedNo,InPoQty%Float,BatchReq,ExpReq,BarCode,SpecDesc,AOGTemp,PackGood,AcceptCon,dhcit,reqLocId,Token,LocalToken,CheckRemarks,ProdCertif,reqLocDesc,Tax:%Float,TaxAmt:%Float,Remark,Incsc,IncscDesc,IncscType,vendorCode,IntrStkQty:%Float,Model,InvCode,OrigiBarCode,OrderDetailSubId,vendor,VendorDesc,ProduceDate,AdjSpStatus,OriginalStatus,InvCode,CheckDate,IngrDate,CheckUser,GrpId,GrpDesc,IngrNo,MatInsuCode,MatInsuDesc,PatInfo") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:Parref="" $$$OK
	s result = ##class(%Library.ResultSet).%New()
	s StrSql = "SELECT INGRI_INGR_ParRef,INGRI_Rowid as Rowid, INGRI_BatchNo, INGRI_CTUOM_DR, INGRI_ExpDate,"
		_"INGRI_INCLB_DR, INGRI_INPOI_DR, INGRI_Margin, INGRI_RecQty,INGRI_Remarks, "
		_"initm_INCI_DR,initm_INCI_DR->INCI_Code as IncCode,initm_INCI_DR->INCI_Desc as IncDesc,"
		_"initm_invmoney, initm_invno, initm_payno, initm_phmnf_dr,initm_phmnf_dr->PHMNF_Name as Manf,"
		_"initm_realprice,initm_realtotal,initm_saleprice, initm_SpAmt, initm_invdate, initm_BatPrice,"
		_"initm_QualityNo,initm_sxno,initm_Remark,initm_newSp,initm_newSpAmt,initm_MT_Dr,initm_PubBL, "
		_"initm_CheckPort,initm_CheckRepNo,initm_CheckRepDate,initm_AdmNo,initm_AdmExpdate,initm_CheckPack,initm_SterilizedBat,initm_SpecList,INGRI_Tax,INGRI_TaxAmount,"
		_"initm_InvCode,initm_OrderDetailSubId,initm_ProduceDate,initm_InvCode "
		_"FROM DHC_INGdRecItm WHERE INGRI_INGR_ParRef in ("_Parref_")"
		_" ORDER BY INGRI_ChildSub asc"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err q $$$OK
	While(result.Next())
	{
		s RowId = result.Data("Rowid")
		s ingrid = result.Data("INGRI_INGR_ParRef")
		s BatchNo = result.Data("INGRI_BatchNo")  
		s IngrUomId = result.Data("INGRI_CTUOM_DR")
		s IngrUom=""
		s:IngrUomId'="" IngrUom=$p(^CT("UOM",IngrUomId),"^",2)
		s ExpDate=result.Data("INGRI_ExpDate")
		s:+ExpDate'=0 ExpDate=..DL2H(ExpDate)
		s Inclb=result.Data("INGRI_INCLB_DR")
		s Inpoi=result.Data("INGRI_INPOI_DR")
		s InPoQty=..GetInPoQty(Inpoi)
		s RecQty = result.Data("INGRI_RecQty")
		s Remarks = result.Data("INGRI_Remarks")
		s Remarks=$LTS(Remarks)
		s IncId = result.Data("initm_INCI_DR")
		s BarCode=$p(^INCI(IncId,3),"^",9) ;库存项条码
		s IncCode = result.Data("IncCode")
		s IncDesc = result.Data("IncDesc")
		s InvMoney = result.Data("initm_invmoney")
		s InvNo = result.Data("initm_invno")
		s PayNo = result.Data("initm_payno")
		s ManfId = result.Data("initm_phmnf_dr")
		s Manf = result.Data("Manf")
		s Rp = result.Data("initm_realprice")
		s RpAmt = result.Data("initm_realtotal")
		s Sp = result.Data("initm_saleprice")
		s SpAmt = result.Data("initm_SpAmt")
		s Margin=SpAmt-RpAmt
		s InvDate = result.Data("initm_invdate")
		s:+InvDate'=0 InvDate=..DL2H(InvDate)
		s BatRp = result.Data("initm_BatPrice")
		s QualityNo = result.Data("initm_QualityNo")
		s SxNo = result.Data("initm_sxno")
		s Remark = result.Data("initm_Remark")     ;摘要
		s NewSp = result.Data("initm_newSp")
		s NewSpAmt = result.Data("initm_newSpAmt")
		s MtDr = result.Data("initm_MT_Dr")      ;定价类型
		s MtDesc=""
		s:MtDr'="" MtDesc=$p(^DHCINMT(MtDr),"^",2)
		s PubBL = result.Data("initm_PubBL")            ;招标轮次
		s CheckPort=result.Data("initm_CheckPort")      ;检测口岸
		s CheckRepNo=result.Data("initm_CheckRepNo")    ;检测报告
		s CheckRepDate=result.Data("initm_CheckRepDate")    ;报告日期
		s:CheckRepDate'="" CheckRepDate=..DL2H(CheckRepDate)
		s AdmNo=result.Data("initm_AdmNo")                  ;注册证号
		s AdmExpdate=result.Data("initm_AdmExpdate")        ;注册证有效期
		s:AdmExpdate'="" AdmExpdate=..DL2H(AdmExpdate)
		s CheckPack=result.Data("initm_CheckPack")          ;包装合格
		s Tax=result.Data("INGRI_Tax")          ;税额20180223
		s TaxAmt=result.Data("INGRI_TaxAmount")
		s InvCode=result.Data("initm_InvCode")
		
		s PubDesc=""
		s:PubBL'="" PubDesc=$p(^DHCPBLIST(PubBL),"^",2)
		s BUomId=$p(^INCI(IncId,1),"^",10)
		s PurUomId=$p(^INCI(IncId,3),"^",6)
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)  
		s Marginnow=""
		i +Rp'=0 s Marginnow= Sp/Rp-1
		s Marginnow=$fn(Marginnow,"",3)
		s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(IncId)
		s HVBarCodeInfo=..GetHVBarCode(RowId)
		s HVBarCode=$p(HVBarCodeInfo,"^",1),dhcit=$p(HVBarCodeInfo,"^",2)
		s OrigiBarCode=$p(HVBarCodeInfo,"^",5)
		s OriginalStatus=$p(HVBarCodeInfo,"^",6)
		s SterilizedNo=result.Data("initm_SterilizedBat")   ;灭菌批号
		s BatchReq=$p(^INCI(IncId,2),"^",10)
		s ExpReq=$p(^INCI(IncId,2),"^",11)
		s SpecDesc=result.Data("initm_SpecList")
		s IngriAdd=$o(^DHCINGRINFO(0,"INGRI",RowId,0))
		s (AOGTemp,PackGood,AcceptCon,reqLocId,reqLocDesc,Token,LocalToken,CheckRemarks,ProdCertif)=""
		i IngriAdd'="" d
		.s AOGTemp=$p(^DHCINGRINFO(IngriAdd),"^",2)
		.s PackGood=$p(^DHCINGRINFO(IngriAdd),"^",3)
		.s AcceptCon=$p(^DHCINGRINFO(IngriAdd),"^",4)
		.s reqLocId=$p(^DHCINGRINFO(IngriAdd),"^",5)
		.s reqLocDesc=$s(reqLocId'="":$p(^CTLOC(reqLocId),"^",2),1:"")
		.s CheckRemarks=$p(^DHCINGRINFO(IngriAdd),"^",9)
		.s Token=$p(^DHCINGRINFO(IngriAdd),"^",10)
		.s LocalToken=$p(^DHCINGRINFO(IngriAdd),"^",11)
		.s ProdCertif=$p(^DHCINGRINFO(IngriAdd),"^",12)
		s Incsc=$p(^INCI(IncId,2),"^",2)
		s IncscDesc=$s(Incsc'="":$p(^INC("SC",Incsc),"^",2),1:"")
		&sql(select initm_SpecList into SpecDesc from  dhc_ingdrecitm where ingri_rowid=:RowId)
		s IngrNo=$p(^DHCINGR(ingrid),"^",1)
		s vendor=$p(^DHCINGR(ingrid),"^",3)
		s vendorCode=$p(^APC("APCVM",vendor),"^",2)
		s VendorDesc=$p(^APC("APCVM",vendor),"^",3)
		s IncscType=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(IncId),"^",6)
		;台帐结存数量(若无台帐,取当前库存)
		s IntrStkQtyB=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetIntrStkQty("G",RowId)
		s IntrStkQty=IntrStkQtyB/ConFac
		s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(IncId)
		s InvCode=result.Data("initm_InvCode") ;发票代码
		s OrderDetailSubId=result.Data("initm_OrderDetailSubId")
		s ProduceDate=result.Data("initm_ProduceDate")
		s:+ProduceDate'=0 ProduceDate=..DL2H(ProduceDate)
		s IngrLocid=$p(^DHCINGR(+RowId),"^",13)
		s HospId=$p(^CTLOC(IngrLocid),"^",22)
		s CheckItmAdjSp=##class(web.DHCSTMHUI.INAdjSalePrice).CheckItmAdjSp(IncId,HospId)
		s AdjSpStatus=""
		i CheckItmAdjSp=1 s AdjSpStatus="存在未处理调价单"
		s IngrDate=$p(^DHCINGR(+RowId),"^",4)
		s:+IngrDate'=0 IngrDate=..DL2H(IngrDate)
		s CheckDate=$p(^DHCINGR(+RowId),"^",4)
		s:+CheckDate'=0 CheckDate=..DL2H(CheckDate) 
		s CheckUserid=$p(^DHCINGR(+RowId),"^",26)
		s CheckUser=$s(CheckUserid'="":$p(^SSU("SSUSR",CheckUserid),"^",2),1:"")
		s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(IncId)
		s GrpId=$p(StkGrpInfo,"^",5)
		s GrpDesc=$p(StkGrpInfo,"^",2)
		s MatInsuInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMatInsuInfo(IncId,HospId)
		s MatInsuCode=$p(MatInsuInfo,"^",1)
		s MatInsuDesc=$p(MatInsuInfo,"^",2)
		s PatInfo=..GetPatInfoByHVBarCode(RowId)
		d OutPutRowDetail
	}
	Quit $$$OK

OutPutRowDetail
	s Data=$lb(RowId,BatchNo,IngrUomId,IngrUom,ExpDate,Inclb,Inpoi ,Margin,RecQty,Remarks,IncId,IncCode,IncDesc,InvMoney,
	InvNo,PayNo,ManfId,Manf,Rp,RpAmt,Sp,SpAmt,InvDate,BatRp,QualityNo,SxNo,NewSp,NewSpAmt,MtDr,MtDesc,PubBL,PubDesc,BUomId,
	ConFac,CheckPort,CheckRepNo,CheckRepDate,AdmNo,AdmExpdate,CheckPack,Spec,Marginnow,HVFlag,HVBarCode,SterilizedNo,InPoQty,
	BatchReq,ExpReq,BarCode,SpecDesc,AOGTemp,PackGood,AcceptCon,dhcit,reqLocId,Token,LocalToken,CheckRemarks,ProdCertif,
	reqLocDesc,Tax,TaxAmt,Remark,Incsc,IncscDesc,IncscType,vendorCode,IntrStkQty,Model,InvCode,OrigiBarCode,OrderDetailSubId,
	vendor,VendorDesc,ProduceDate,AdjSpStatus,OriginalStatus,InvCode,CheckDate,IngrDate,CheckUser,GrpId,GrpDesc,IngrNo,
	MatInsuCode,MatInsuDesc,PatInfo)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:zhangxiao
/// CreatDate:2014-03-10
/// Description:取订单数量
/// InPut：IN_POItm 
/// Table:dhc_ingdrecitm
/// OutPut:
/// Return:"",无订单；
/// >0 :订单数
/// w ##class(web.DHCSTMHUI.DHCINGdRecItm).GetInPoQty("893||1")
ClassMethod GetInPoQty(inpoi) As %Library.String
{
	n (inpoi)
	s InPoQty=""
	q:inpoi="" InPoQty
	&sql(select INPOI_Pur_Qty into InPoQty from IN_POItm where IN_POItm=:inpoi )
	q InPoQty
}

/// Creator:zdm
/// CreatDate:2009-09-07
/// Description:更新入库子表的批次信息
/// InPut：入库子表rowid,科室库存项批次rowid
/// Table:dhc_ingdrecitm
/// OutPut:
/// Return:0,成功；
/// -1，失败
ClassMethod UpdateDhcRecItm(ingri, inclb) As %Library.String
{
	n (ingri,inclb)
	s RtnObj=##class(RtnObj).%New()
	i ((ingri="")||(inclb="")) s Sc=RtnObj.Err(-1,"","更新入库子表的批次信息失败!") q RtnObj 

	s Obj=##class(User.DHCINGdRecItm).%OpenId(ingri)
	s InvSetDate=Obj.initmInvSetDate
	d Obj.INGRIINCLBDRSetObjectId(inclb)
	i InvSetDate'="" s Obj.initmInvSetDate=+$h		;如果发票填写日期不为空,调整为当天;为了防止月报中票未到数据计算bug
	s Sc=Obj.%Save()
	i $$$ISERR(Sc) q RtnObj.Err(-2,"","更新入库子表的批次信息失败!")
	
	q RtnObj
}

/// Descript:   保存/更新入库验收信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-07-18
/// Table:DHC_InGdRecItm
/// Input:明细id^检测口岸^检测报告^报告日期^注册证号^注册证有效期^摘要
/// Output:     
/// Return：0：成功，
/// -5:明细不能为空
/// -6:所有明细保存均失败
/// -7其它：部分明细保存不成功，提示不成功的药品
ClassMethod SaveAcceptInfo(ListData As %String) As RtnObj
{
	n (ListData)
	s RtnObj=##class(RtnObj).%New()
	s PJObjItm=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObjItm.%FromJSON(ListData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","明细入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	While (RtnObj.success=0) {
		s ItmObj=PJObjItm.%Pop()
		q:ItmObj=""
		s Rowid=ItmObj.%Get("RowId")
		i ((Rowid="")||('$d(^DHCINGR(+Rowid,"GRI",$p(Rowid,"||",2)))))  d
		.s Sc=RtnObj.Err(-2,"","入库单明细不存在!","",0)
		q:RtnObj.success'=0
		s Chl=$p(Rowid,"||",2)
		s IncId=+$p(^DHCINGR(+Rowid,"GRI",Chl),"^",25)
		q:IncId=0
		s IncDesc=$p(^INCI(IncId,1),"^",2)
		s RtnObj=..UpdateAcceptInfo(ItmObj)
		q:RtnObj.success'=0
	}
	q RtnObj
}

/// Creator:zdm
/// CreatDate:2009-09-07
/// Description:更新入库子表的验收信息
/// InPut：入库子表rowid,检测口岸^检测报告^报告日期^注册证号^注册证有效期^摘要
/// Table:dhc_ingdrecitm
/// OutPut:
/// Return:0,成功；
/// -1，失败
ClassMethod UpdateAcceptInfo(Detail As %String) As RtnObj
{
	n (Detail)
	s RtnObj=##class(RtnObj).%New()
	s Ingri=Detail.%Get("RowId")
	s CheckPort=Detail.%Get("CheckPort") ;检测口岸
	s CheckReport=Detail.%Get("CheckRepNo") ;检测报告
	s CheckRepDate=Detail.%Get("CheckRepDate") ;报告日期
	s CheckRepDate=..DH2L(CheckRepDate)
	s AdmNo=Detail.%Get("AdmNo")
	s AdmExpDate=Detail.%Get("AdmExpdate")
	s AdmExpDate=..DH2L(AdmExpDate)
	s Remark=Detail.%Get("Remark")
	
	&sql(update dhc_ingdrecitm set initm_CheckPort=:CheckPort,initm_CheckRepNo=:CheckReport,
	initm_CheckRepDate=:CheckRepDate,initm_AdmNo=:AdmNo,initm_AdmExpdate=:AdmExpDate,initm_Remark=:Remark
	where ingri_Rowid=:Ingri)
	i SQLCODE'=0  s Sc=RtnObj.Err(-1,"","更新入库子表的验收信息!","",0) q RtnObj
	q RtnObj
}

/// Descript:根据订单RowId取得订单明细信息(根据订单入库用)
/// Creater:zhangdongmei
/// CreateDate:2012-07-31
/// Input:订单主表id
/// Output:     
/// Return：订单明细Id^库存项Id^库存项代码^库存项名称^订购单位Id^订购单位^订购数量^进价^产地Id^产地
/// ^售价^批号^效期^基本单位Id^转化率
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINGdRecItm","QueryPoItmForRec","","",6367)
Query QueryPoItmForRec(Parref As %String) As Query(ROWSPEC = "Inpoi,IncId,IncCode,IncDesc,IngrUomId,IngrUom,RecQty:%Float,Rp:%Float,ManfId,Manf,Sp:%Float,BatchNo,ExpDate,BUomId,ConFacPur:%Float,PurQty:%Float,ImpQty:%Float,BatchReq,ExpReq,Spec,BarcodeQty:%Float,AvaBarcodeQty:%Float,SpecDesc,AdmNo,AdmExpdate,HVFlag,ImpQtyAudited:%Float")
{
}

ClassMethod QueryPoItmForRecExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	
	s DhcPoId=$o(^DHCINPO(0,"INPO",Parref,0))
	s PoLoc =$p(^DHCINPO(DhcPoId),"^",2)
	s result = ##class(%Library.ResultSet).%New()
	s StrSql = "SELECT IN_POItm as Rowid, INPOI_INCI_DR, INPOI_CTUOM_DR, INPOI_UnitCost,"
		_"INPOI_Pur_Qty "
		_"FROM IN_PoItm WHERE IN_PO= "_Parref
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q $$$OK
	While(result.Next())
	{
		s Inpoi = result.Data("Rowid")
		s IncId = result.Data("INPOI_INCI_DR")
		continue:IncId=""
		s IngrUomId = result.Data("INPOI_CTUOM_DR")
		s:IngrUomId'="" IngrUom=$p(^CT("UOM",IngrUomId),"^",2)
		s Rp=result.Data("INPOI_UnitCost")
		s PurQty =+ result.Data("INPOI_Pur_Qty")
		s ImpQtyInfo=##class(web.DHCSTMHUI.INPOItm).GetImpQty(Inpoi,IngrUomId)
		s ImpQty=$p(ImpQtyInfo,"^",1)
		s ImpQtyAudited=$p(ImpQtyInfo,"^",2)
		s RecQty=PurQty-ImpQty    ;还可以入库的数量
		s BarcodeQty=+##class(web.DHCSTMHUI.DHCItmTrack).GetBarcodeQty(Inpoi)
		s AvaBarcodeQty=PurQty-BarcodeQty    ;还可以入库的数量
		s IncCode=$p(^INCI(IncId,1),"^",1)
		s IncDesc=$p(^INCI(IncId,1),"^",2)
		;s Param="^"_PoLoc_"^"
		;s ItmDefaultInfo=##class(web.DHCSTMHUI.DHCINGdRec).GetItmInfo(IncId,Param)
		s:PoLoc'="" HospId=$p(^CTLOC(PoLoc),"^",22)
		s Params="^"_PoLoc_"^^"_HospId
		s BatExp=##class(web.DHCSTMHUI.DHCINGdRec).GetDefaultBatExp(IncId,Params)
		s BatchNo=$p(BatExp,"^",1)
		s ExpDate=$p(BatExp,"^",2)
		s PurUomId=$p(^INCI(IncId,3),"^",6)
		s BUomId=$p(^INCI(IncId,1),"^",10)
		s ConFacPur=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId) 
		s BatchReq=$p(^INCI(IncId,2),"^",10)
		s ExpReq=$p(^INCI(IncId,2),"^",11)
		;2018-01-02 修改售价取法
		s Sp=##class(web.DHCSTMHUI.DHCINGdRec).GetSpForRec(IncId,IngrUomId,Rp,Params)
		s CanceledFlag="N"
		&sql(select POI_CanceledFlag into :CanceledFlag from DHC_INPOItm where POI_INPOI_DR=:Inpoi)
		continue:CanceledFlag="Y"
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId) ;规格
		s (SpecDesc,ManfId,Manf)=""
		s dhcpoi=$o(^DHCINPOI(0,"INPOI",Inpoi,""),-1)
		i dhcpoi'="" d
		.s SpecDesc=$p(^DHCINPOI(dhcpoi),"^",5)
		.s ManfId=$p(^DHCINPOI(dhcpoi),"^",14)
		.s:ManfId'="" Manf=$P(^PHMNF(ManfId),"^",2)
		s CerInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(IncId)
		s AdmNo=$p(CerInfo,"^",1)
		s AdmExpdate=$p(CerInfo,"^",2)
		s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(IncId)
		d OutPutPoItmForRecRow
	}
	Quit $$$OK

OutPutPoItmForRecRow
	s Data=$lb(Inpoi,IncId,IncCode,IncDesc,IngrUomId,IngrUom,RecQty,Rp,ManfId,Manf,Sp,BatchNo,ExpDate,BUomId,ConFacPur,PurQty,ImpQty,BatchReq,ExpReq,Spec,BarcodeQty,AvaBarcodeQty,SpecDesc,AdmNo,AdmExpdate,HVFlag,ImpQtyAudited)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:检查本次入库明细的发票号是否存在于别的入库单
/// Creater:    ZhangDongmei
/// CreateDate: 2012-09-19
/// Table:DHC_InGdRecItm
/// Input:入库子表id,发票号
/// Output:     
/// Return：1:存在;0:不存在
ClassMethod CheckInvnoExist(Ingr As %String, Invno As %String, InvCode = "") As %Library.String
{
	n (Ingr,Invno,InvCode)
	s Flag=0
	q:Invno="" 0
	s Invno=$$ALPHAUP^SSUTIL4(Invno)
	s OldIngr=0
	f  s OldIngr=$o(^DHCINGR(0,"INVNO",Invno,OldIngr)) q:(OldIngr="")||(Flag=1)  d
	.i InvCode="" d
	..i +Ingr=0 d
	...s Flag=1                      ;新增项目的发票号存在于其它入库单
	..e  i Ingr'=OldIngr  d
	...s Flag=1                      ;更新项目的发票号存在于其它入库单
	.e  d
	..s chl=0
	..f  s chl=$o(^DHCINGR(OldIngr,"GRI",chl)) q:(chl="")||(Flag=1)  d
	...i (+Ingr'=0)&&(Ingr'=OldIngr) d
	....s OldInvCode=$p(^DHCINGR(OldIngr,"GRI",chl),"^",51)
	....i InvCode=OldInvCode s Flag=1
	
	
	q Flag
}

/// 根据当前入库明细中的注册证号信息，更新库存项目档案信息中的注册证信息
/// Author:zhwh
/// Date:2016-07-07
/// Arguments:
///    ingri - RowId
///     ParamStr - 参数串
/// w ##class(web.DHCSTMHUI.DHCINGdRecItm).HandleRecItmCertInfo("491||1","98^153")
ClassMethod HandleRecItmCertInfo(ingri As %String, ParamStr As %String) As %String
{
	n (ingri,ParamStr)
	s RtnObj=##class(RtnObj).%New()
	&sql(SELECT initm_inci_dr,initm_admno,initm_admexpdate,initm_phmnf_dr into :inci,:cert,:exp,:manf FROM dhc_ingdrecitm where ingri_rowid=:ingri)
	q:((SQLCODE)||(cert="")) RtnObj
	
	s AppName=##class(web.DHCSTMHUI.DHCINGdRec).%GetParameter("AppName")
	s UpdItmCertByRec=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"UpdItmCertByRec",ParamStr)
	s MRCRowID=$o(^DHCMRCT(0,"NO",cert,""),-1)
	i MRCRowID="" d
	.s RtnObj=##class(web.DHCSTMHUI.DHCMatRegCert).Update(inci,manf,cert,exp,UpdItmCertByRec)

	q RtnObj
}

/// Descript:	根据ingri获取高值条码,高值补录的按dhc_hvmat_orditm取值
/// 			ps:仅适用于显示
/// Creator:	wangjiabin
/// CreateDate:	2016-07-25
/// Input:		入库子表id
/// Output:		高值条码^dhcit
/// w ##class(web.DHCSTMHUI.DHCINGdRecItm).GetHVBarCode("6531||1")
ClassMethod GetHVBarCode(Ingri) As %String
{
	n (Ingri)
	s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("G",Ingri)
	;实库补录的数据,dhc_itmtrackdetail未记录,通过dhc_hvmat_orditm取值
	s (Doctor,SxNo)=""
	i HVBarCode="" d
	.s hvm=$o(^DHCHVMORI(0,"INGRIModify",Ingri,0))
	.q:hvm=""
	.s originIngri=$p(^DHCHVMORI(hvm,1),"^",12)  ;原始入库明细id
	.s:originIngri'="" SxNo=$p(^DHCINGR(+originIngri,"GRI",$p(originIngri,"||",2)),"^",38)  ;随行单号
	.s HVBarCode=$p(^DHCHVMORI(hvm,1),"^",24)
	.s Doctorid=$p(^DHCHVMORI(hvm,1),"^",4)  ;开医嘱人
	.s:Doctorid'="" Doctor=$p(^SSU("SSUSR",Doctorid),"^",2)
	
	s (dhcit,OrigiBarCode,OriginalStatus)=""
	i HVBarCode'="" d
	.s dhcit=$o(^DHCIT(0,"LABEL",HVBarCode,0))
	.s:dhcit'="" OrigiBarCode=$p(^DHCIT(dhcit),"^",13)
	.s:dhcit'="" OriginalStatus=$p(^DHCIT(dhcit),"^",35)
	q HVBarCode_"^"_dhcit_"^"_Doctor_"^"_SxNo_"^"_OrigiBarCode_"^"_OriginalStatus
}

/// 高值条码获取病人信息
/// w ##class(web.DHCSTMHUI.DHCINGdRecItm).GetPatInfoByHVBarCode("6531||1")
ClassMethod GetPatInfoByHVBarCode(Ingri) As %Library.String
{
	n (Ingri)
	s OrderId=$o(^DHCHVMORI(0,"INGRIModify",Ingri,""))
	q:OrderId="" ""
	s Oeori=$P(^DHCHVMORI(OrderId,1),"^",1)
	q:Oeori="" ""
	s subOeori=$p(Oeori,"||",2)
	s OeordLoc=$p(^OEORD(+Oeori,"I",subOeori,1),"^",3)  ///下单科室
	s OeordLocDept=""
	i OeordLoc'="" s OeordLocDept=$p(^CTLOC(OeordLoc),"^",2)  ///下单科室
	s Adm=$p(^OEORD(+Oeori),"^",1)
	s Painfo=##class(web.DHCSTMHUI.Common.AdmInfo).GetPatientInfoByAdm(Adm)
	s PaNo=Painfo.PatNo
	s PaName=Painfo.PatName
	q OeordLocDept_","_PaNo_","_PaName
}

/// Descript:	根据"参数设置" 或 "效期长度(月份)"判断过否过期
/// Creator:	wangjiabin
/// CreateDate:	2018-01-15
/// Input:		库存项id, 有效期(Y-m-d)
/// Output:		"": 检测为发现问题, 非空: 过期提示信息
/// w ##class(web.DHCSTMHUI.DHCINGdRecItm).CheckExpDate("1813","14/03/2021")
ClassMethod CheckExpDate(Inci, ExpDate)
{
	n (%session,Inci,ExpDate)
	q:Inci="" ""
	q:ExpDate="" ""
	s ExpDate=..DH2L(ExpDate)
	
	s AppName=##class(web.DHCSTMHUI.DHCINGdRec).%GetParameter("AppName")
	s Param=..sssParamStr()
	s ChkExpDateDays=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"ChkExpDateDays",Param)
	s InciDesc=$p(^INCI(Inci,1),"^",2)
	s InfoId=$o(^DHCITMINFO(0,"INCI",Inci,0))
	s InciExpireLen=""
	i (InfoId'="")&&($d(^DHCITMINFO(InfoId,1))) s InciExpireLen=$p(^DHCITMINFO(InfoId,1),"^",45)
	
	s Ret=""
	i InciExpireLen'="" d
	.;若不为空,按月份判断
	.s ExpireDate=$p($SYSTEM.SQL.DATEADD("mm",InciExpireLen,+$h)," ")
	.s ExpireDate=..DH2L(ExpireDate)
	.i ExpDate<ExpireDate s Ret=InciDesc_"有效期距今小于"_InciExpireLen_"个月!" q
	.s CheckExpirelen=""
	.s CheckExpirelen=(ExpDate-(+$h))\30
	.i ((CheckExpirelen-InciExpireLen)>0) d
	..s Ret=InciDesc_"超过效期长度"_(CheckExpirelen-InciExpireLen)_"月" q
	e  d
	.s Today=+$h
	.s Gaps=ExpDate-Today
	.i Gaps<ChkExpDateDays s Ret=InciDesc_"距离失效期小于"_ChkExpDateDays_"天!" q
	
	q Ret
}

/// Descript:	获取发票录入日期
/// Creator:	lihui
/// CreateDate:	20180321
/// Input:		入库退货子表id,类型(入库:G;退货:R)
/// Output:		发票录入日期
/// w ##class(web.DHCSTMHUI.DHCINGdRecItm).GetInvSetDate("785||1","R","")
ClassMethod GetInvSetDate(IngrtId As %String, type As %String, InvNo As %String) As %String
{
	n (IngrtId,type,InvNo)
	q:IngrtId="" ""
	q:((type'="G")&&(type'="R")) ""
	s (InvSetDate,oldInvSetDate,oldInvNo)=""
	i type="G" d
	.&sql(select initm_invno,initm_InvSetDate into :oldInvNo,:oldInvSetDate from DHC_INGdRecItm where INGRI_RowId=:IngrtId)
	e  d
	.&sql(SELECT INGRTI_InvNo,INGRTI_InvSetDate into :oldInvNo,:oldInvSetDate FROM DHC_INGRTITM WHERE INGRTI_RowId=:IngrtId)
	i ((oldInvSetDate="")&&(oldInvNo="")&&(InvNo'="")) d
	.s InvSetDate=+$h
	e  d
	.s InvSetDate=oldInvSetDate
	q InvSetDate
}

/// Creator: lihui
/// CreatDate: 20180802
/// Description: 入库更新具体规格到规格列表
/// InPut：库存项id,具体规格描述
/// Table: DHCItmSpecList
/// OutPut:
/// Return: 0成功;非0 不成功;
/// w ##class(web.DHCSTMHUI.DHCINGdRecItm).InsertSpeclistByRec(948,"44")
ClassMethod InsertSpeclistByRec(Inci, Specdesc) As %Library.String
{
	n (Inci,Specdesc)
	q:Inci="" 0
	q:Specdesc="" 0
	s SPECRowId=""
	s Ret=0
	s RtnObj=##class(RtnObj).%New()
	&sql(SELECT SPEC_RowId INTO :SPECRowId FROM DHC_ItmSpecList WHERE SPEC_INCI_DR=:Inci AND SPEC_Desc=:Specdesc)
	i SPECRowId=""  d
	.s Data=""_"^"_Specdesc
	.s Title="RowId^Spec"
	.s ListData="["_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)_"]"
	.s RtnObj=##class(web.DHCSTMHUI.INCALIAS).SaveSpec(Inci,ListData)
	.i RtnObj.success'=0 d
	..s Ret=-1
	q Ret
}

/// Descript:	根据入库单RowId取得入库单明细信息(合并同单品高值)打印单据用
/// Creator:	lxt
/// CreateDate:	2019-03-29
/// Table:		dhc_ingdrecitm
/// Input:		排序，查询条件   
/// Return：	入库子表id^批号^入库单位Id^入库单位^效期^批次id^订单子表id^加成^入库数量^备注^库存项id^库存项代码
/// ^库存项名称^发票金额^发票号^付款单号^生产厂家Id^生产厂家^进价^进价金额^售价^售价金额^发票日期^批次进价
/// ^质检单号^随行单号^摘要^入库售价^入库售价金额^定价类型id^定价类型^招标轮次id^招标轮次^基本单位Id^包装单位和基本单位转换率"
/// ^检测口岸^检测报告^报告日期^注册证号^注册证有效期^包装合格^规格^当前加成^高值标志(Y/N)^高值条码
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINGdRecItm","QueryHVColDetail","","",221)
Query QueryHVColDetail(Parref As %String) As Query(ROWSPEC = "Inci,InciCode,InciDesc,Model,Spec,HVFlag,BarCode,IncscDesc,IngrUomDesc,RecQty:%Float,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,BatRp:%Float,NewSp:%Float,NewSpAmt:%Float,Margin:%Float,Marginnow:%Float,MtDesc,BatNo,ExpDate,SpecDesc,QualityNo,SxNo,PubDesc,SterilizedNo,InvCode,InvDate,InvMoney:%Float,InvNo,PayNo,CheckPort,AOGTemp,PackGood,AcceptCon,Token,LocalToken,CheckRemarks,ProdCertif,Tax:%Float,TaxAmt:%Float,VendorDesc,ManfDesc")
{
}

ClassMethod QueryHVColDetailExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	s result = ##class(%Library.ResultSet).%New()
	s StrSql = "SELECT INGRI_Rowid as Rowid, INGRI_BatchNo, INGRI_CTUOM_DR, INGRI_ExpDate,"
		_"INGRI_INCLB_DR, INGRI_INPOI_DR, INGRI_Margin, INGRI_RecQty,INGRI_Remarks, "
		_"initm_INCI_DR,initm_INCI_DR->INCI_Code as IncCode,initm_INCI_DR->INCI_Desc as IncDesc,"
		_"initm_invmoney, initm_invno, initm_payno, initm_phmnf_dr,initm_phmnf_dr->PHMNF_Name as Manf,"
		_"initm_realprice,initm_realtotal,initm_saleprice, initm_SpAmt, initm_invdate, initm_BatPrice,"
		_"initm_QualityNo,initm_sxno,initm_Remark,initm_newSp,initm_newSpAmt,initm_MT_Dr,initm_PubBL, "
		_"initm_CheckPort,initm_CheckRepNo,initm_CheckRepDate,initm_AdmNo,initm_AdmExpdate,initm_CheckPack,initm_SterilizedBat,initm_SpecList,INGRI_Tax,INGRI_TaxAmount,"
		_"initm_InvCode,initm_OrderDetailSubId "
		_"FROM DHC_INGdRecItm WHERE INGRI_INGR_ParRef= "_Parref
	k ^TMPHVCOLDETAIL
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q $$$OK
	While(result.Next())
	{
		s RowId = result.Data("Rowid")
		s BatchNo = result.Data("INGRI_BatchNo")  
		s IngrUomId = result.Data("INGRI_CTUOM_DR")
		s IngrUom=""
		s:IngrUomId'="" IngrUom=$p(^CT("UOM",IngrUomId),"^",2)
		s ExpDate=result.Data("INGRI_ExpDate")
		s:+ExpDate'=0 ExpDate=..DL2H(ExpDate)
		s Inclb=result.Data("INGRI_INCLB_DR")
		s Inpoi=result.Data("INGRI_INPOI_DR")
		s InPoQty=..GetInPoQty(Inpoi)
		s RecQty = result.Data("INGRI_RecQty")
		s Remarks = result.Data("INGRI_Remarks")
		s Remarks=$LTS(Remarks)
		s IncId = result.Data("initm_INCI_DR")
		s BarCode=$p(^INCI(IncId,3),"^",9) ;库存项条码
		s IncCode = result.Data("IncCode")
		s IncDesc = result.Data("IncDesc")
		s InvMoney = result.Data("initm_invmoney")
		s InvNo = result.Data("initm_invno")
		s PayNo = result.Data("initm_payno")
		s ManfId = result.Data("initm_phmnf_dr")
		s Manf = result.Data("Manf")
		s Rp = result.Data("initm_realprice")
		s RpAmt = result.Data("initm_realtotal")
		s Sp = result.Data("initm_saleprice")
		s SpAmt = result.Data("initm_SpAmt")
		s Margin=SpAmt-RpAmt
		s InvDate = result.Data("initm_invdate")
		s:+InvDate'=0 InvDate=..DL2H(InvDate)
		s BatRp = result.Data("initm_BatPrice")
		s QualityNo = result.Data("initm_QualityNo")
		s SxNo = result.Data("initm_sxno")
		s Remark = result.Data("initm_Remark")     ;摘要
		s NewSp = result.Data("initm_newSp")
		s NewSpAmt = result.Data("initm_newSpAmt")
		s MtDr = result.Data("initm_MT_Dr")      ;定价类型
		s MtDesc=""
		s:MtDr'="" MtDesc=$p(^DHCINMT(MtDr),"^",2)
		s PubBL = result.Data("initm_PubBL")            ;招标轮次
		s CheckPort=result.Data("initm_CheckPort")      ;检测口岸
		s CheckRepNo=result.Data("initm_CheckRepNo")    ;检测报告
		s CheckRepDate=result.Data("initm_CheckRepDate")    ;报告日期
		s:CheckRepDate'="" CheckRepDate=..DL2H(CheckRepDate)
		s AdmNo=result.Data("initm_AdmNo")                  ;注册证号
		s AdmExpdate=result.Data("initm_AdmExpdate")        ;注册证有效期
		s:AdmExpdate'="" AdmExpdate=..DL2H(AdmExpdate)
		s CheckPack=result.Data("initm_CheckPack")          ;包装合格
		s Tax=result.Data("INGRI_Tax")          ;税额20180223
		s TaxAmt=result.Data("INGRI_TaxAmount")
		s PubDesc=""
		s:PubBL'="" PubDesc=$p(^DHCPBLIST(PubBL),"^",2)
		s BUomId=$p(^INCI(IncId,1),"^",10)
		s PurUomId=$p(^INCI(IncId,3),"^",6)
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)  
		s Marginnow=""
		i +Rp'=0 s Marginnow= Sp/Rp-1
		s Marginnow=$fn(Marginnow,"",3)
		s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(IncId)
		s HVBarCodeInfo=..GetHVBarCode(RowId)
		s HVBarCode=$p(HVBarCodeInfo,"^",1),dhcit=$p(HVBarCodeInfo,"^",2)
		s OrigiBarCode=$p(HVBarCodeInfo,"^",5)
		s SterilizedNo=result.Data("initm_SterilizedBat")   ;灭菌批号
		s BatchReq=$p(^INCI(IncId,2),"^",10)
		s ExpReq=$p(^INCI(IncId,2),"^",11)
		s SpecDesc=result.Data("initm_SpecList")
		s IngriAdd=$o(^DHCINGRINFO(0,"INGRI",RowId,0))
		s (AOGTemp,PackGood,AcceptCon,reqLocId,reqLocDesc,Token,LocalToken,CheckRemarks,ProdCertif)=""
		i IngriAdd'="" d
		.s AOGTemp=$p(^DHCINGRINFO(IngriAdd),"^",2)
		.s PackGood=$p(^DHCINGRINFO(IngriAdd),"^",3)
		.s AcceptCon=$p(^DHCINGRINFO(IngriAdd),"^",4)
		.s reqLocId=$p(^DHCINGRINFO(IngriAdd),"^",5)
		.s reqLocDesc=$s(reqLocId'="":$p(^CTLOC(reqLocId),"^",2),1:"")
		.s CheckRemarks=$p(^DHCINGRINFO(IngriAdd),"^",9)
		.s Token=$p(^DHCINGRINFO(IngriAdd),"^",10)
		.s LocalToken=$p(^DHCINGRINFO(IngriAdd),"^",11)
		.s ProdCertif=$p(^DHCINGRINFO(IngriAdd),"^",12)
		s Incsc=$p(^INCI(IncId,2),"^",2)
		s IncscDesc=$s(Incsc'="":$p(^INC("SC",Incsc),"^",2),1:"")
		&sql(select initm_SpecList into SpecDesc from  dhc_ingdrecitm where ingri_rowid=:RowId)
		s vendor=$p(^DHCINGR(Parref),"^",3)
		s vendorCode=$p(^APC("APCVM",vendor),"^",2)
		s VendorDesc=$p(^APC("APCVM",vendor),"^",3)
		s IncscType=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(IncId),"^",6)
		;台帐结存数量(若无台帐,取当前库存)
		s IntrStkQtyB=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetIntrStkQty("G",RowId)
		s IntrStkQty=IntrStkQtyB/ConFac
		s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(IncId)
		s InvCode=result.Data("initm_InvCode") ;发票代码
		s OrderDetailSubId=result.Data("initm_OrderDetailSubId")
		i '$d(^TMPHVCOLDETAIL(IncId))  d
		.s Data1=IncCode_"^"_IncDesc_"^"_Model_"^"_Spec_"^"_HVFlag
		.s Data2=BarCode_"^"_IncscDesc_"^"_IngrUom_"^"_RecQty_"^"_Rp
		.s Data3=RpAmt_"^"_Sp_"^"_SpAmt_"^"_BatRp_"^"_NewSp
		.s Data4=NewSpAmt_"^"_Margin_"^"_Marginnow_"^"_MtDesc_"^"_BatchNo
		.s Data5=ExpDate_"^"_SpecDesc_"^"_QualityNo_"^"_SxNo_"^"_PubDesc
		.s Data6=SterilizedNo_"^"_InvCode_"^"_InvDate_"^"_InvMoney_"^"_InvNo
		.s Data7=PayNo_"^"_CheckPort_"^"_AOGTemp_"^"_PackGood_"^"_AcceptCon
		.s Data8=Token_"^"_LocalToken_"^"_CheckRemarks_"^"_ProdCertif_"^"_Tax
		.s Data9=TaxAmt_"^"_VendorDesc_"^"_Manf
		.s ^TMPHVCOLDETAIL(IncId)=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5_"^"_Data6_"^"_Data7_"^"_Data8_"^"_Data9
		e  d
		.s TmpQty=$p(^TMPHVCOLDETAIL(IncId),"^",9)+RecQty
		.s TmpRpAmt=$p(^TMPHVCOLDETAIL(IncId),"^",11)+RpAmt
		.s TmpSpAmt=$p(^TMPHVCOLDETAIL(IncId),"^",13)+SpAmt
		.s TmpNewSpAmt=$p(^TMPHVCOLDETAIL(IncId),"^",16)+NewSpAmt
		.s TmpMargin=$p(^TMPHVCOLDETAIL(IncId),"^",17)+Margin
		.s TmpInvMoney=$p(^TMPHVCOLDETAIL(IncId),"^",29)+InvMoney
		.s TmpTaxAmt=$p(^TMPHVCOLDETAIL(IncId),"^",41)+TaxAmt
		.s $p(^TMPHVCOLDETAIL(IncId),"^",9)=TmpQty
		.s $p(^TMPHVCOLDETAIL(IncId),"^",11)=TmpRpAmt
		.s $p(^TMPHVCOLDETAIL(IncId),"^",13)=TmpSpAmt
		.s $p(^TMPHVCOLDETAIL(IncId),"^",16)=TmpNewSpAmt
		.s $p(^TMPHVCOLDETAIL(IncId),"^",17)=TmpMargin
		.s $p(^TMPHVCOLDETAIL(IncId),"^",29)=TmpInvMoney
		.s $p(^TMPHVCOLDETAIL(IncId),"^",41)=TmpTaxAmt
	}
	s Inci=0
	f  s Inci=$o(^TMPHVCOLDETAIL(Inci)) q:(Inci="")  d
	.s InciCode=$p(^TMPHVCOLDETAIL(Inci),"^",1)
	.s InciDesc=$p(^TMPHVCOLDETAIL(Inci),"^",2)
	.s Model=$p(^TMPHVCOLDETAIL(Inci),"^",3)
	.s Spec=$p(^TMPHVCOLDETAIL(Inci),"^",4)
	.s HVFlag=$p(^TMPHVCOLDETAIL(Inci),"^",5)
	.
	.s BarCode=$p(^TMPHVCOLDETAIL(Inci),"^",6)
	.s IncscDesc=$p(^TMPHVCOLDETAIL(Inci),"^",7)
	.s IngrUomDesc=$p(^TMPHVCOLDETAIL(Inci),"^",8)
	.s RecQty=$p(^TMPHVCOLDETAIL(Inci),"^",9)
	.s Rp=$p(^TMPHVCOLDETAIL(Inci),"^",10)
	.
	.s RpAmt=$p(^TMPHVCOLDETAIL(Inci),"^",11)
	.s Sp=$p(^TMPHVCOLDETAIL(Inci),"^",12)
	.s SpAmt=$p(^TMPHVCOLDETAIL(Inci),"^",13)
	.s BatRp=$p(^TMPHVCOLDETAIL(Inci),"^",14)
	.s NewSp=$p(^TMPHVCOLDETAIL(Inci),"^",15)
	.
	.s NewSpAmt=$p(^TMPHVCOLDETAIL(Inci),"^",16)
	.s Margin=$p(^TMPHVCOLDETAIL(Inci),"^",17)  //进销差
	.s Marginnow=$p(^TMPHVCOLDETAIL(Inci),"^",18)  //(sp/rp-1)
	.s MtDesc=$p(^TMPHVCOLDETAIL(Inci),"^",19)
	.s BatNo=$p(^TMPHVCOLDETAIL(Inci),"^",20)
	.
	.s ExpDate=$p(^TMPHVCOLDETAIL(Inci),"^",21)
	.s SpecDesc=$p(^TMPHVCOLDETAIL(Inci),"^",22)
	.s QualityNo=$p(^TMPHVCOLDETAIL(Inci),"^",23)
	.s SxNo=$p(^TMPHVCOLDETAIL(Inci),"^",24)
	.s PubDesc=$p(^TMPHVCOLDETAIL(Inci),"^",25)
	.
	.s SterilizedNo=$p(^TMPHVCOLDETAIL(Inci),"^",26)
	.s InvCode=$p(^TMPHVCOLDETAIL(Inci),"^",27)
	.s InvDate=$p(^TMPHVCOLDETAIL(Inci),"^",28)
	.s InvMoney=$p(^TMPHVCOLDETAIL(Inci),"^",29)
	.s InvNo=$p(^TMPHVCOLDETAIL(Inci),"^",30)
	.
	.s PayNo=$p(^TMPHVCOLDETAIL(Inci),"^",31)
	.s CheckPort=$p(^TMPHVCOLDETAIL(Inci),"^",32)
	.s AOGTemp=$p(^TMPHVCOLDETAIL(Inci),"^",33)
	.s PackGood=$p(^TMPHVCOLDETAIL(Inci),"^",34)
	.s AcceptCon=$p(^TMPHVCOLDETAIL(Inci),"^",35)
	.
	.s Token=$p(^TMPHVCOLDETAIL(Inci),"^",36)
	.s LocalToken=$p(^TMPHVCOLDETAIL(Inci),"^",37)
	.s CheckRemarks=$p(^TMPHVCOLDETAIL(Inci),"^",38)
	.s ProdCertif=$p(^TMPHVCOLDETAIL(Inci),"^",39)
	.s Tax=$p(^TMPHVCOLDETAIL(Inci),"^",40)
	.
	.s TaxAmt=$p(^TMPHVCOLDETAIL(Inci),"^",41)
	.s VendorDesc=$p(^TMPHVCOLDETAIL(Inci),"^",42)
	.s ManfDesc=$p(^TMPHVCOLDETAIL(Inci),"^",43)
	.
	.d OutPutRowHVColDetail
	Quit $$$OK

OutPutRowHVColDetail
	s Data=$lb(Inci,InciCode,InciDesc,Model,Spec,HVFlag,
		BarCode,IncscDesc,IngrUomDesc,RecQty,Rp,
		RpAmt,Sp,SpAmt,BatRp,NewSp,
		NewSpAmt,Margin,Marginnow,MtDesc,BatNo,
		ExpDate,SpecDesc,QualityNo,SxNo,PubDesc,
		SterilizedNo,InvCode,InvDate,InvMoney,InvNo,
		PayNo,CheckPort,AOGTemp,PackGood,AcceptCon,
		Token,LocalToken,CheckRemarks,ProdCertif,Tax,
		TaxAmt,VendorDesc,ManfDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 查询入库综合明细
/// Author:zhangdongmei
/// Date:2021-08-11
/// Argu:
///   StartDate - 开始日期
///   EndDate-截止日期
///   LocId-科室
///   Others-类组id^库存分类id^库存项id^定价类型^进口标志^生产批号^是否招标^
/// 招标级别^药学大类id^药学子类id^药学更小分类id^生产厂家id^剂型^医保类型^
/// 管制分类^供应商id^入库类型^最低售价^最高售价^最低进价^最高进价^发票号
/// ^批次售价不等于售价标志^是否按审核日期统计
/// Return:入库单号^发票号^制单日期^库存项代码^库存项名称^单位^入库数量^
/// 进价^进价金额^售价^售价金额^供应商名称^批号^效期^产地^货位^发票日期^
/// 定价类型^招标标志^招标级别^医保类型^状态^审核日期
///  Json数据串
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINGdRecItm","QueryRecDetail","","","{""RecLoc"":""392"",""gUserId"":""4642"",""gLocId"":""392"",""gGroupId"":""264"",""gHospId"":""2"",""IngrTypeId"":"""",""Vendor"":"""",""StartDate"":""01/05/2018"",""INFOImportFlag"":"""",""PhManufacturer"":"""",""EndDate"":""19/10/2018"",""PublicBidding"":"""",""INFOMT"":"""",""StkGrpId"":"""",""INFOPBLevel"":"""",""StkCatBox"":"""",""InsuType"":"""",""CreateUserId"":"""",""DateFlag"":"""",""SpFlag"":"""",""InGrNo"":"""",""MinRp"":"""",""MaxRp"":"""",""MinSp"":"""",""InvNo"":"""",""MaxSp"":"""",""InciDesc"":""""}")
Query QueryRecDetail(Params As %Text) As Query(ROWSPEC = "Ingri,IngrNo,InvNo,IngrCreateDate,InciCode,InciDesc,PurUom,Qty:%Float,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,Vendor,BatNo,ExpDate,Manf,StkBin,InvDate,SpType,PbFlag,PbLevel,Status,IngrDate,Spec,HVBarCode,Margin,OrigiBarCode,Model,StkCatDesc,AdmNo,InvMoney:%Float,PackGood,AcceptCon,CheckUser,MatInsuCode,MatInsuDesc,IngrTime") [ SqlProc ]
{
}

ClassMethod QueryRecDetailExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:Params="" $$$OK
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s StartDate=PJobj.%Get("StartDate")
	s EndDate=PJobj.%Get("EndDate")
	s LocId=PJobj.%Get("RecLoc")
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	q:LocId="" $$$OK
	s pStkGrpId=PJobj.%Get("StkGrpId")
	s StkCatId=PJobj.%Get("StkCatBox")
	s pInciRowid=PJobj.%Get("InciRowid")
	s MarkType=PJobj.%Get("INFOMT")
	s ImpFlag=PJobj.%Get("INFOImportFlag")
	s pBatNo=PJobj.%Get("BatNo")
	s PbFlag=PJobj.%Get("PublicBidding")
	s PbLevel=PJobj.%Get("INFOPBLevel")
	s CreateUserid=PJobj.%Get("CreateUserId")
	s ManfId=PJobj.%Get("PhManufacturer")
	s pInsuType=PJobj.%Get("InsuType")
	s VendorId=PJobj.%Get("Vendor")
	s pIngrTypeId=PJobj.%Get("IngrTypeId")
	s SpFrom=PJobj.%Get("MinSp")
	s SpTo=PJobj.%Get("MaxSp")
	s RpFrom=PJobj.%Get("MinRp")
	s RpTo=PJobj.%Get("MaxRp")
	s pInvNo=PJobj.%Get("InvNo")
	s pSpFlag=PJobj.%Get("SpFlag")
	s pDateFlag=PJobj.%Get("DateFlag")   ;"Y":按审核日期查找，否则按制单日期查找
	s pIncDesc=PJobj.%Get("InciDesc")
	s pAuditFlag=PJobj.%Get("AuditFlag")
	s pInGrNo=PJobj.%Get("InGrNo")
	s pHospId=..sssHospId(LocId)
	s gHospId=PJobj.%Get("gHospId")
	s FBDate=PJobj.%Get("FBDate") ;发票日期
	s PChargeFlag=PJobj.%Get("ChargeFlag")
	
	s:FBDate'="" FBDate=..DH2L(FBDate)
	s:pHospId="" pHospId=gHospId
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s pStkGrpId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),LocId,pStkGrpId,pHospId)
	s sql="select INGRI_INGR_ParRef->ingr_no as IngrNo,"
	s sql=sql_"INGRI_INGR_ParRef->ingr_apcvm_dr as VendorId,"
	s sql=sql_"INGRI_INGR_ParRef->ingr_apcvm_dr->apcvm_name as Vendor,"
	s sql=sql_"INGRI_INGR_ParRef->ingr_date as IngrDate,"
	s sql=sql_"INGRI_INGR_ParRef->ingr_time as IngrTime,"
	s sql=sql_"INGRI_INGR_ParRef->ingr_createdate as IngrCreateDate,"
	s sql=sql_"ingri_rowid as Rowid,"
	s sql=sql_"initm_INCI_DR as Incid,initm_INCI_DR->inci_desc as InciDesc "
	s sql=sql_"from dhc_ingdrecitm where "
	i pDateFlag="Y"  d
	.s sql=sql_"(ingri_ingr_parref->ingr_date between "_StartDate_" and "_EndDate_")"
	.s sql=sql_" and ingri_ingr_parref->ingr_loc_dr="_LocId
	e  d
	.s sql=sql_"(ingri_ingr_parref->ingr_createdate between "_StartDate_" and "_EndDate_")"
	.s sql=sql_" and ingri_ingr_parref->ingr_loc_dr="_LocId
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err q $$$OK
	While(result.Next())
	{
		s IngrNo = result.Data("IngrNo")
		CONTINUE:((pInGrNo'="")&&(pInGrNo'=IngrNo))
		s VendorRowid=result.Data("VendorId")
		s Vendor = result.Data("Vendor")
		s IngrDate=result.Data("IngrDate")
		s IngrTime=result.Data("IngrTime")
		s IngrCreateDate=result.Data("IngrCreateDate")
		s venDate=IngrCreateDate
		i IngrDate'="" s venDate=IngrDate
		s:VendorRowid'="" Vendor=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetDateVendor(venDate,VendorRowid)
		s IngrCreateDate=..DL2H(IngrCreateDate)
		s IngrDate=..DL2H(IngrDate)
		s IngrTime=..TL2H(IngrTime)
		s Ingri = result.Data("Rowid")
		s Incid=result.Data("Incid")
		s InciDesc = result.Data("InciDesc")
		CONTINUE:(pInciRowid'="")&(pInciRowid'=Incid)			;库存项不符
		CONTINUE:'$d(^INCI(Incid,1))
		CONTINUE:'$d(^INCI(Incid,2))
		CONTINUE:'$d(^INCI(Incid,3))
		CONTINUE:(pIncDesc'="")&(InciDesc'[pIncDesc)
		s Dhcingr=+Ingri
		s Dhcingri=$p(Ingri,"||",2)
		CONTINUE:'$d(^DHCINGR(Dhcingr))
		CONTINUE:'$d(^DHCINGR(Dhcingr,"GRI",Dhcingri))
		s IngrData=^DHCINGR(Dhcingr,"GRI",Dhcingri)
		s CreateUserId=$p(^DHCINGR(Dhcingr),"^",16)
		continue:(CreateUserid'="")&&(CreateUserId'=CreateUserid)
		s Inclb=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",1)
		continue:(pAuditFlag="Y")&&(Inclb="")
		continue:(pAuditFlag="N")&&(Inclb'="")
		s tmpstkgrp=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Incid)
		s TmpStkGrpId=$p(tmpstkgrp,"^",5)
		continue:(pStkGrpId'="")&&(("^"_pStkGrpId_"^")'[("^"_TmpStkGrpId_"^"))
		s StkGrpDesc=$p(tmpstkgrp,"^",2)
		s TmpIncCatId=$p(^INCI(Incid,2),"^",2)
		CONTINUE:(StkCatId'="")&&(StkCatId'=TmpIncCatId)		;库存分类不符
		s incscdesc=""
		s:TmpIncCatId'="" incscdesc=$p(^INC("SC",TmpIncCatId),"^",2)
		s ChargeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetChargeFlag(Incid)
		continue:(PChargeFlag'="")&&(ChargeFlag'=PChargeFlag)
		s spType=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMarkType(Incid),"^",2)
		s spTypeId=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMarkType(Incid),"^",1)
		CONTINUE:(MarkType'="")&&(spTypeId'=MarkType)			;定价类型
		s TmpImpFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmImportFlag(Incid)
		CONTINUE:(ImpFlag'="")&&(TmpImpFlag'=ImpFlag)
		s gmanfid=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",29)
		CONTINUE:(ManfId'="")&&(gmanfid'=ManfId)						;生产厂家
		s Manf=""
		s:gmanfid'="" Manf=$p(^PHMNF(gmanfid),"^",2)
		CONTINUE:(VendorId'="")&&(VendorRowid'=VendorId)				;按供应商过滤
		s tmpimpsort=$p(^DHCINGR(Dhcingr),"^",23)
		CONTINUE:(pIngrTypeId'="")&&(tmpimpsort'=pIngrTypeId)			;按入库类型过滤
		s TmpPbFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmPbFlag(Incid)
		CONTINUE:(PbFlag'="")&&(TmpPbFlag'=PbFlag)			;是否招标
		i TmpPbFlag="Y" s TmpPbFlag="招标"
		i TmpPbFlag="N" s TmpPbFlag="非招标"
		s TmpPbLevel=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmAddtionPbLevel(Incid)
		CONTINUE:(PbLevel'="")&&(TmpPbLevel'=PbLevel)		;招标级别
		s TmpPbLevelDesc=""
		s:TmpPbLevel'="" TmpPbLevelDesc=$p(^DHCITMPBL(TmpPbLevel),"^",2)
		s TmpBaFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmAddtionBAFlag(Incid) ;备案
		s:TmpBaFlag="Y" TmpBaFlag=1
		s:TmpBaFlag="N" TmpBaFlag=0
		s sp=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",32)      ;售价
		s rp=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",30)      ;进价
		s newsp=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",45)
		s qty=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",4)
		s inuom=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",10)
		s inuomdesc=""
		s:inuom'="" inuomdesc=$p(^CT("UOM",inuom),"^",2)
		s buom=$p(^INCI(Incid,1),"^",10)
		s puruom=$p(^INCI(Incid,3),"^",6)
		s buomdesc=$p(^CT("UOM",buom),"^",2)
		i puruom="" s puruom=buom,puruomdesc=buomdesc
		e  s puruomdesc=$p(^CT("UOM",puruom),"^",2)
		s bfac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(inuom,buom) ; factor 
		s pfac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(puruom,buom)
		s pqty=(qty*bfac)/pfac
		s psp=(sp*pfac)/bfac
		s prp=(rp*pfac)/bfac
		s pnewsp=(newsp*pfac)/bfac
		CONTINUE:(SpFrom'="")&&(psp<+SpFrom)      ;低于售价范围最小值
		CONTINUE:(SpTo'="")&&(psp>+SpTo)
		CONTINUE:(RpFrom'="")&&(prp<+RpFrom)
		CONTINUE:(RpTo'="")&(prp>+RpTo)
		CONTINUE:(pSpFlag="1")&&(newsp=sp)	;批次售价和售价不等的checkbox勾上 090701
		s invno=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",27)
		CONTINUE:(pInvNo'="")&&(invno'=pInvNo)				;按发票号过滤 090623
		s ExpireDate=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",9)
		s ExpireDate=..DL2H(ExpireDate)
		s TmpBatNo=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",13)
		CONTINUE:(pBatNo'="")&&(TmpBatNo'=pBatNo)
		s incicode=$p(^INCI(Incid,1),"^",1)
		s stkbin=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(LocId,Incid)
		s stkbin=$p(stkbin,"^",1)
		s invdatetmp=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",34)
		continue:(FBDate'="")&&(FBDate'=invdatetmp)
		s invdate=..DL2H(invdatetmp)
		s InvMoney=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",26)
		s rpcosts=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",31)
		s spcosts=qty*sp
		s pprice=+$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",35)
		s ppcosts=qty*pprice
		s pprice=(pprice*pfac)/bfac
		s newspcosts=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",46)
		s rpcosts=$fn(rpcosts,"",2)
		s ppcosts=$fn(ppcosts,"",2)
		s spcosts=$fn(spcosts,"",2)
		s Margin=spcosts-rpcosts
		s newspcosts=$fn(newspcosts,"",2)
		s cpcosts=spcosts-rpcosts
		s newcpcosts=newspcosts-rpcosts
		i +Inclb'=0  d
		.s Status="已审核"
		e  d
		.s Status="未审核"
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Incid)
		s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(Incid)
		s MatInsuInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMatInsuInfo(Incid,pHospId)
		s MatInsuCode=$p(MatInsuInfo,"^",1)
		s MatInsuDesc=$p(MatInsuInfo,"^",2)
		s HVBarCodeInfo=##class(web.DHCSTMHUI.DHCINGdRecItm).GetHVBarCode(Ingri)
		s HVBarCode=$p(HVBarCodeInfo,"^",1)
		s OrigiBarCode=$p(HVBarCodeInfo,"^",5)
		s AdmNo=$p(IngrData,"^",42)
		s IngriAdd=$o(^DHCINGRINFO(0,"INGRI",Ingri,0))
		s (AOGTemp,PackGood,AcceptCon,Token,LocalToken,CheckRemarks,CheckDate,CheckTime,CheckUser)=""
		i IngriAdd'="" d
		.s IngriAddionInfo=^DHCINGRINFO(IngriAdd)
		.s AOGTemp=$p(IngriAddionInfo,"^",2)
		.s PackGood=$p(IngriAddionInfo,"^",3)
		.s AcceptCon=$p(IngriAddionInfo,"^",4)
		.s CheckDate=$p(IngriAddionInfo,"^",6)
		.s:CheckDate'="" CheckDate=$zd(CheckDate,3)
		.s CheckTime=$p(IngriAddionInfo,"^",7)
		.s:CheckTime'="" CheckTime=$zt(CheckTime)
		.s CheckUser=$p(IngriAddionInfo,"^",8)
		.s:CheckUser'="" CheckUser=$p(^SSU("SSUSR",CheckUser),"^",2)
		.s CheckRemarks=$p(IngriAddionInfo,"^",9)
		.s Token=$p(IngriAddionInfo,"^",10)
		.s LocalToken=$p(IngriAddionInfo,"^",11)
		d OutPutRecDetailRow
	}
	d result.Close()
	Quit $$$OK

OutPutRecDetailRow
	s Data=$lb(Ingri,IngrNo,invno,IngrCreateDate,incicode,InciDesc,puruomdesc,pqty,prp,rpcosts,psp,spcosts,Vendor,TmpBatNo,ExpireDate,Manf,stkbin,invdate,spType,TmpPbFlag,TmpPbLevelDesc,Status,IngrDate,Spec,HVBarCode,Margin,OrigiBarCode,Model,incscdesc,AdmNo,InvMoney,PackGood,AcceptCon,CheckUser,MatInsuCode,MatInsuDesc,IngrTime)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:wxj
/// CreatDate:2023-03-21
/// Description:取库存项已入库数量
/// InPut：Inci-库存项Rowid
/// OutPut:库存项已入库数量(基本单位)
/// Table:DHC_INTRANS
/// Remark:1.去掉已退货数量 2.去掉虚库入库数量 3.基于一个入库退货单中库存项可重复出现，从入库退货明细表中取值，不考虑台账
/// Debug:w ##class(web.DHCSTMHUI.DHCINGdRecItm).GetReceivedQty(3229)
ClassMethod GetReceivedQty(Inci, IngrItm) As %Library.String
{
	n (Inci,IngrItm)
	s ReceivedQty=0
	q:Inci="" ReceivedQty
	s BuomId=$p(^INCI(Inci,1),"^",10)
	q:BuomId="" ReceivedQty
	s Ingr=""
	f  s Ingr=$o(^DHCINGR(0,"INCI",Inci,Ingr))  q:Ingr=""  d
	.s IngrLoc=$p(^DHCINGR(Ingr),"^",13)
	.s MainlocId=##class(web.DHCSTMHUI.Common.UtilCommon).MLoc(IngrLoc)
	.q:MainlocId'=""
	.s IngrCh=""
	.f  s IngrCh=$o(^DHCINGR(0,"INCI",Inci,Ingr,IngrCh)) q:IngrCh=""  d
	..s Ingri=Ingr_"||"_IngrCh
	..q:Ingri=IngrItm
	..s RecQty=$p(^DHCINGR(Ingr,"GRI",IngrCh),"^",4)
	..s IngrUom=$p(^DHCINGR(Ingr,"GRI",IngrCh),"^",10)
	..s RecUomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(IngrUom,BuomId)
	..s RecQtyBUom=RecQty*RecUomFac
	..s ReceivedQty=ReceivedQty+RecQtyBUom
	..s Ingrt=""
	..f  s Ingrt=$o(^INGRT(0,"INGRI",Ingri,Ingrt)) q:Ingrt=""  d
	...s AuditFlag=$p(^INGRT(Ingrt),"^",15)
	...q:AuditFlag'="Y"
	...s IngrtCh=""
	...f  s IngrtCh=$o(^INGRT(0,"INGRI",Ingri,Ingrt,IngrtCh)) q:IngrtCh=""  d
	....s RetQty=$p(^INGRT(Ingrt,"DHCGRR",IngrtCh),"^",2)
	....s RetUom=$p(^INGRT(Ingrt,"DHCGRR",IngrtCh),"^",3)
	....s RetUomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(RetUom,BuomId)
	....s RetQtyBUom=RetQty*RetUomFac
	....s ReceivedQty=ReceivedQty-RetQtyBUom
	q ReceivedQty
}

}
