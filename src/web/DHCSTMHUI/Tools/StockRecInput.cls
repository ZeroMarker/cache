Import sqluser

/// 库存信息导入生成待审核入库单
/// Author:zhangxiao
/// Date:2013-12-27
Class web.DHCSTMHUI.Tools.StockRecInput Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// "代码^名称^数量^单位^进价^批号^效期(YYYY-MM-DD)^生产厂家描述(生产厂家必须是系统内的描述)"
/// 处理一行数据
ClassMethod InputItm(RowObj, Ingdrec, Params) As web.DHCSTMHUI.RtnObj
{
	n (RowObj,Ingdrec,Params,%session)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参错误!","",0)
	
	s HospId=PJObj.%Get("gHospId")
	i (HospId="")&&($d(%session)) s HospId=$Get(%session.Data("LOGON.HOSPID"))
	
	//1 生成主表
	i Ingdrec="" d
	.;tro   //滚掉事务 防止第一条报错回滚主表信息 下边的无法进行  20191113lihui 注释 遗留主表没有明细
	.s RtnObj=..CreateDHCINGR(RowObj,Params)
	.s Ingdrec=RtnObj.rowid
	.;ts
	i RtnObj.success'=0 q RtnObj 
	//2插入明细插入子表信息
	s Code=RowObj.%Get("物资代码")
	s Desc=RowObj.%Get("物资名称")
	s Qty=RowObj.%Get("数量")
	s Uom=RowObj.%Get("入库单位")
	s Rp=RowObj.%Get("进价")
	s BatchNo=RowObj.%Get("批号")
	s ExpDate=RowObj.%Get("效期")
	i ExpDate'="" s ExpDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(ExpDate)  ;
	i +ExpDate<0 d RtnObj.Err(-21,"","效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj	
	s SpecDesc=RowObj.%Get("具体规格")
	s Phmanf=RowObj.%Get("生产厂家") 
	s IncId=""
	;s IncId=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(Code)_"Z",""))
	s IncId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("CODE",Code,"INC_Itm",HospId)
	i IncId=""  d RtnObj.Err(-1,"","此代码无效","",0)
	q:RtnObj.success'=0 RtnObj
	s LocId=""
	s LocDesc=RowObj.%Get("科室名称") 
	i LocDesc="" d RtnObj.Err(-1,"","科室名称为空","",0)
	q:RtnObj.success'=0 RtnObj
	;s LocId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),0))
	s LocId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("DESC",LocDesc,"CT_Loc",HospId)
	i +LocId>0 d
	.
	e  d
	.d RtnObj.Err(-1,"","不存在此科室!","",0)
	q:RtnObj.success'=0 RtnObj
	s HospId=$p(^CTLOC(LocId),"^",22)
	s UomId=""
	&sql(select CTUOM_RowId into :UomId from ct_uom where CTUOM_Desc=:Uom)
	i SQLCODE'=0 d RtnObj.Err(-1,"","单位不存在","",0)
	q:RtnObj.success'=0 RtnObj

	s BUomId=$p(^INCI(IncId,1),"^",10)
	s PUomId=$p(^INCI(IncId,3),"^",6)
	i UomId'=BUomId,UomId'=PUomId  d RtnObj.Err(-1,"","单位和物资不匹配","",0)
	q:RtnObj.success'=0 RtnObj
	s Margin=""
	s InvAmt=""
	s InvNo=""
	s ManfId=""
	
	i Phmanf'="" d
	.s ManfId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("DESC",Phmanf,"PH_Manufacturer",HospId,"M")
	.;&sql(select MANF_PhcManf_DR into :ManfId from DHC_Manf_AddionInfo where MANF_Type='M' and MANF_PhcManf_DR->PHMNF_Name=:Phmanf)
	.i +ManfId=0 d RtnObj.Err(-1,"","生产厂家名称无效","",0)
	q:RtnObj.success'=0 RtnObj
	s RpAmt=Rp*Qty
	s AppName=##class(web.DHCSTMHUI.DHCINGdRec).%GetParameter("AppName")
	s HospId=$p($g(^CTLOC(LocId)),"^",22)
	s Param="^"_LocId_"^^"_HospId
	s Sp=##class(web.DHCSTMHUI.DHCINGdRec).GetSpForRec(IncId,UomId,Rp,Param)
	s InvDate=""
	s SxNo=""
	s SpAmt=Sp*Qty
	s PoItmId=""
	s Remark=""
	s QualityNo=""
	s MtDr=""
	s NewSp=Sp
	s NewSpAmt=SpAmt

	;2017-12-13 有条码的先处理条码
	s IngrUser=$p(^DHCINGR(Ingdrec),"^",16)
	s VenId=$p(^DHCINGR(Ingdrec),"^",3)
	s HVBarCode=RowObj.%Get("高值条码")			;高值条码
	i (Qty'=1)&&(HVBarCode'="") d RtnObj.Err(-1,"","高值条码和数量不匹配","",0)
	q:RtnObj.success'=0 RtnObj  
	s dhcit=$s(HVBarCode'="":$o(^DHCIT(0,"LABEL",HVBarCode,0)),1:"")
	;高值条码已存在使用信息
	i dhcit'="" d
	.i $d(^DHCITD(dhcit)) q
	.s dhcitStatus=$p(^DHCIT(dhcit),"^",5)
	.i dhcitStatus'="" d RtnObj.Err(-1,"","条码状态不正确","",0)
	q:RtnObj.success'=0 RtnObj
	;注册条码
	i (HVBarCode'="")&&(dhcit="") {
		s OriginalCode=RowObj.%Get("自带条码")
		s ZDExpDate=$s(ExpDate'="":$zd(ExpDate,3),1:"")
		s ProduceDate=""
		s CertNo="",CertExpDate=""
		s CodeData=IncId_"^"_HVBarCode_"^"_Qty_"^"_OriginalCode_"^"_BatchNo
			_"^"_ZDExpDate_"^"_SpecDesc_"^"_ProduceDate_"^"_CertNo_"^"_CertExpDate
			_"^"_Rp_"^"_ManfId_"^"_VenId
		s CodeTitle="InciId^BarCode^Qty^OriginalCode^BatchNo"
			_"^ExpDate^SpecDesc^ProduceDate^CertNo^CertExpDate"
			_"^Rp^ManfId^VendorId"
		s CodeObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(CodeData,CodeTitle)
		s ItmObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
		s Sc=ItmObj.%FromJSON(CodeObj)
		i Sc'=0 d
		.s Sc=RtnObj.Err(-1,"","明细参数解析失败!")
		q:RtnObj.success'=0 RtnObj
		
		s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).UpdateReg(ItmObj,IngrUser,"",+$h,$p($h,",",2),LocId,"")
		q:RtnObj.success<0 RtnObj
	}
	q:RtnObj.success'=0 RtnObj
	s Chl=1+$o(^DHCINGR(Ingdrec,"GRI",""),-1)
	s Remarks=""
	&sql(INSERT INTO DHC_INGdRecItm(INGRI_INGR_ParRef,INGRI_ChildSub,INGRI_BatchNo,INGRI_CTLOC_DR, 
		INGRI_CTUOM_DR,INGRI_ExpDate,INGRI_Margin,INGRI_RecQty, INGRI_StkDesc,initm_INCI_DR, initm_invmoney, 
		initm_invno, initm_phmnf_dr, initm_realprice,initm_realtotal, initm_saleprice, initm_invdate, 
		initm_BatPrice, initm_sxno,initm_newSp, initm_newSpAmt,initm_SpAmt,INGRI_INPOI_DR,initm_Remark,
		INGRI_Remarks,initm_QualityNo,initm_MT_Dr,initm_SpecList)
	VALUES(:Ingdrec, :Chl, :BatchNo, :LocId,:UomId,:ExpDate,:Margin,:Qty,:Desc,
		:IncId,:InvAmt,:InvNo,:ManfId,:Rp,:RpAmt,:Sp,:InvDate,:Rp,:SxNo,:NewSp,:NewSpAmt,:SpAmt,:PoItmId,
		:Remark,:Remarks,:QualityNo,:MtDr,:SpecDesc)
	)
	i SQLCODE'=0  d RtnObj.Err(-1,"","插入子表失败")
	q:RtnObj.success'=0 RtnObj

	;记录跟踪信息
	i HVBarCode'="" d
	.s Ingri=Ingdrec_"||"_Chl
	.s operData=LocId_"^"_IngrUser_"^"_IncId_"^^"_VenId
	.s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).Update("G",Ingri,HVBarCode,operData)
	q:RtnObj.success'=0 RtnObj
	
	s RtnObj.rowid=Ingdrec
	q RtnObj
}

/// 生成入库主表
ClassMethod CreateDHCINGR(RowObj, Params) As %String
{
	n (RowObj,Params)  
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d DataRtnObj.Err(-1,"","入参解析失败!")
	s UserId=PJObj.%Get("gUserId")
	i +UserId=0 d RtnObj.Err(-1,"","没有取到操作人信息!","",0)
	q:RtnObj.success'=0 RtnObj
	s gHospId=PJObj.%Get("gHospId")
	///生成入库主表
	s LocDesc=RowObj.%Get("科室名称")
	i LocDesc="" d RtnObj.Err(-1,"","科室名称为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s LocId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),0))
	i LocId="" d RtnObj.Err(-1,"","不存在此科室!","",0)
	q:RtnObj.success'=0 RtnObj
	
	s HospId=..sssHospId(+LocId)
	s:HospId="" HospId=gHospId
	
	s ReqLocId=""
	s ReqLocDesc=RowObj.%Get("接收科室名称")
	i ReqLocDesc'="" d
	.s ReqLocId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(ReqLocDesc),0))
	.i ReqLocId="" d RtnObj.Err(-1,"","接收科室"_ReqLocDesc_"在系统中不存在","",0)
	q:RtnObj.success'=0 RtnObj

	s Vendordesc=RowObj.%Get("供应商")
	i Vendordesc="" d RtnObj.Err(-1,"","供应商为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s VendorId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("DESC",Vendordesc,"APC_Vendor",HospId,"M")
	;s VendorId=$O(^APC("APCVM",0,"APCVM_Name",$$ALPHAUP^SSUTIL4(Vendordesc),""))
	;s VendorId=..GetDefaultVendor() ;获取初始化供应商
	i VendorId'>0 d RtnObj.Err(-1,"","没有取到供应商id","",0)
	q:RtnObj.success'=0 RtnObj

	s AppName=##class(web.DHCSTMHUI.DHCINGdRec).%GetParameter("AppName")
	s IngrNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,"",LocId)
	i IngrNo="" d RtnObj.Err(-1,"","生成单号失败")
	q:RtnObj.success'=0 RtnObj
	s Complete="Y"
	s ExchangeFlag="N"
	s PresentFlag="N"
	s IngrTypeId=""
	s StkType=..sssCode()
	s PurUserId=""
	s StkGrpId=""
	s AuditFlag="N"
	s PoId=""
	s h=+$h
	s t=$p($h,",",2)
	&sql(insert into dhc_ingdrec(INGR_APCVM_DR,INGR_Completed,INGR_CTCUR_DR,
		INGR_ExRate,INGR_HandChg,INGR_No,INGR_Loc_Dr,INGR_CreateUser,
		INGR_CreateDate,INGR_CreateTime,INGR_AdjCheque,INGR_GiftFlag,INGR_Type,
		INGR_SSUSR_Purch_DR,INGR_SCG_DR,INGR_AuditFlag,INGR_StkType,INGR_INPO_DR,
		INGR_ReqLoc_Dr) 
		values (:VendorId,:Complete,1,
		1,0,:IngrNo,:LocId,:UserId,
		:h,:t,:ExchangeFlag,:PresentFlag,:IngrTypeId,
		:PurUserId,:StkGrpId,:AuditFlag,:StkType,:PoId,
		:ReqLocId)
	)
	i SQLCODE'=0  d
	.d RtnObj.Err(-1,"","主表插入失败")
	e  d
	.s RtnObj.rowid=$g(%ROWID)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:获取初始化供应商
/// Creater: zhangxiao
/// CreateDate: 2013-12-27
/// Table:apc_vendor
/// Return：供应商id
/// w ##class(web.DHCSTMHUI.Tools.StockRecInput).GetDefaultVendor()
ClassMethod GetDefaultVendor()
{
	n 
	s Ret=0
	s vendor="初始化供应商"
	s ven=$O(^APC("APCVM",0,"APCVM_Name",$$ALPHAUP^SSUTIL4(vendor),""))
	q:ven>0 ven
	s Type=..sssCode()
	s Status="A"
	///没有初始化供应商则新建
	&sql(Insert into APC_Vendor(APCVM_Code,APCVM_Name,APCVM_Type,APCVM_Status)
	values(:vendor,:vendor,:Type,:Status))
	i SQLCODE'=0 d
	. s Ret=-1
	e  d
	.s Ret=%ROWID
	q Ret
}

/// Descript:获取供应商ID
/// Creater: wxj
/// CreateDate: 2022-01-24
/// Table:apc_vendor
/// Return：供应商名称
/// w ##class(web.DHCSTMHUI.Tools.StockRecInput).GetVendorId("上海巨彤商贸有限公司")
ClassMethod GetVendorId(Vendesc) As %String
{
	n (Vendesc)
	S Type=..sssCode()
	s Rowid="",VendorId=""
	f  s Rowid=$o(^APC("APCVM",0,"APCVM_Name",Vendesc,Rowid)) q:(+Rowid=0)||(VendorId'="")  d
	.s STV=$o(^DHCSTV(0,Rowid,0))
	.s StkType=$p(^APC("APCVM",Rowid),"^",9)
	.q:Type'=StkType
	.s VendorId=Rowid
	q VendorId
}

}
