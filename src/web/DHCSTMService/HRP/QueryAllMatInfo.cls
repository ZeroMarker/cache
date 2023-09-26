Import sqluser

Class web.DHCSTMService.HRP.QueryAllMatInfo Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// 集团ID
Parameter GROUPID;

/// 医院ID
Parameter HOSID;

/// 账套编码
Parameter COPYCODE;

/// 数据源编码
Parameter DSCODE;

/// 材料字典 MAT_INV
/// Author: lihui
/// Date: 20200521
/// CALL web_DHCSTMService_HRP.QueryAllMatInfo_QueryMatBaseInfo()
/// d ##class(%ResultSet).RunQuery("web.DHCSTMService.HRP.QueryAllMatInfo","QueryMatBaseInfo")
Query QueryMatBaseInfo() As websys.Query(ROWSPEC = "INVID:%String,INVCODE:%String,INVNAME:%String,ALIAS:%String,SPELLCODE:%String,WBXCODE:%String,MATTYPEID:%String,INVMODEL:%String,UNITCODE:%String,FACID:%String,AMORTIZETYPE:%String,PRICETYPE:%String,PLANPRICE:%String,PRICERATE:%String,SELLPRICE:%String,ISSINGLEVEN:%String,ISBATCH:%String,ISBAR:%String,ISPERBAR:%String,ISCERT:%String,ISQUALITY:%String,ISDISINFECT:%String,ISCOM:%String,ISDURA:%String,ISHIGHVALUE:%String,ISCHARGE:%String,ISSECWHG:%String,ISSHELMAKE:%String,SDATE:%String,EDATE:%String,BARCODENEW:%String,ABCTYPE:%String,PERWEIGHT:%String,PERVOLUM:%String,BRANDNAME:%String,AGENTNAME:%String,INVSTRUCTURE:%String,INVUSAGE:%String,USESTATE:%String,NOTE:%String,STATE:%String,CHECKDATE:%String,CHECKER:%String,ISBID:%String,BIDDATE:%String,BIDCODE:%String,ISINVOLVED:%String,ISIMPLANT:%String,STORATRANCOND:%String,ISZEROSTORE:%String,ALIASSPELL:%String") [ SqlProc ]
{
}

ClassMethod QueryMatBaseInfoExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s inci=0,count=0
	f  s inci=$o(^INCI(inci)) q:+inci=0  d
	.s tmpstkgrp=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	.s TmpStkGrpdesc=$p(tmpstkgrp,"^",3)	
	.q:TmpStkGrpdesc'="M"
	.s notuse=$p(^INCI(inci,2),"^",9)
	.;q:notuse="Y"
	.s InciCode=$P(^INCI(inci,1),"^",1)
	.s InciDesc=$P(^INCI(inci,1),"^",2)
	.s PuomDr=$P(^INCI(inci,3),"^",6)
	.s PuomDesc=$s(PuomDr'="":$P(^CT("UOM",PuomDr),"^",2),1:"")
	.s BuomStr=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncBuom(inci)
	.s BuomDr=$P(BuomStr,"^",1)
	.s BuomDesc=$P(BuomStr,"^",2)
	.s packageQuantity=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PuomDr,BuomDr)
	.s Spec=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
	.s Model=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(inci)
	.s Brand=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(inci)
	.s Abbrev=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetAbbrev(inci)
	.s ManfStr=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(inci)
	.s Manfdr=$P(ManfStr,"^",1)
	.s ManfCode=$P(ManfStr,"^",2)
	.s ManfName=$P(ManfStr,"^",3)
	.s IncCatId=$p(^INCI(inci,2),"^",2)
	.s IncCat=$s(IncCatId'="":$p(^INC("SC",IncCatId),"^",2),1:"")
	.s cert=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(inci)
	.s AliasStr=##class(web.DHCSTMHUI.INCALIAS).GetIncAlias(inci)
	.s CertNo=$p(cert,"^",1)
	.s CertExpDate=$p(cert,"^",2)
	.s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inci,+$h,PuomDr,"")
	.s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(inci,+$h,PuomDr,"")
	.s HvFlag=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
	.s ChargeFlag=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetChargeFlag(inci)
	.s VendorStr=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(inci)
	.s VendorId=$p(VendorStr,"^",1)
	.s Vendor=$p(VendorStr,"^",2)
	.s Remarks=""
	.i $d(^INCI(inci,"REM",1)) d
	..s Remarks=^INCI(inci,"REM",1)
	.s Implant=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncImplantationMat(inci)
	.s count=count+1
	.s INVID=inci ;物资材料ID
	.s INVCODE=InciCode ;物资材料编码
	.s INVNAME=InciDesc ;物资材料名称
	.s ALIAS=AliasStr ;别名
	.s SPELLCODE=AliasStr ;拼音码
	.s WBXCODE=AliasStr ;五笔码
	.s MATTYPEID=IncCatId ;物资类别ID
	.s INVMODEL=Spec_""_Model ;规格型号
	.s UNITCODE=PuomDesc ;计量单位
	.s FACID=Manfdr ;生产厂家ID
	.s AMORTIZETYPE="" ;摊销方式
	.s PRICETYPE="" ;计价方法
	.s PLANPRICE=Rp ;计划价
	.s PRICERATE="" ;加价率
	.s SELLPRICE=Sp ;零售价
	.s ISSINGLEVEN="" ;是否唯一供应商
	.s ISBATCH="" ;是否按批管理
	.s ISBAR="" ;是否条码管理
	.s ISPERBAR="" ;是否个体条码
	.s ISCERT="" ;是否证件管理
	.s ISQUALITY="" ;是否保质期管理
	.s ISDISINFECT="" ;是否灭菌材料
	.s ISCOM="" ;是否代销品
	.s ISDURA="" ;是否耐用品
	.s ISHIGHVALUE=HvFlag ;是否高值
	.s ISCHARGE=ChargeFlag ;是否收费
	.s ISSECWHG="" ;是否作二级库管理
	.s ISSHELMAKE="" ;是否自制品
	.s SDATE="" ;启用日期
	.s EDATE="" ;停用日期
	.s BARCODENEW="" ;品种条码
	.s ABCTYPE="" ;ABC分类
	.s PERWEIGHT="" ;单位重量
	.s PERVOLUM="" ;单位体积
	.s BRANDNAME=Brand ;品牌
	.s AGENTNAME=Vendor ;代理商
	.s INVSTRUCTURE="" ;材料结构
	.s INVUSAGE="" ;材料用途
	.s USESTATE="使用" ;在用状态
	.i notuse="Y" s USESTATE="停用"
	.s NOTE=Remarks ;备注
	.s STATE="" ;审核状态
	.s CHECKDATE="" ;审核日期
	.s CHECKER="" ;审核人
	.s ISBID="" ;是否中标
	.s BIDDATE="" ;中标日期
	.s BIDCODE="" ;项目中标编码
	.s ISINVOLVED=Implant ;是否介入
	.s ISIMPLANT=Implant ;是否植入
	.s STORATRANCOND="" ;储运条件
	.s ISZEROSTORE=Implant ;是否零库存管理
	.s ALIASSPELL=AliasStr ;别名拼音码
	.d OutputRowBaseInfo
	Quit $$$OK

OutputRowBaseInfo
	s Data=$lb(INVID,INVCODE,INVNAME,ALIAS,SPELLCODE,WBXCODE,MATTYPEID,INVMODEL,UNITCODE,FACID,
			AMORTIZETYPE,PRICETYPE,PLANPRICE,PRICERATE,SELLPRICE,ISSINGLEVEN,ISBATCH,ISBAR,ISPERBAR,ISCERT,
			ISQUALITY,ISDISINFECT,ISCOM,ISDURA,ISHIGHVALUE,ISCHARGE,ISSECWHG,ISSHELMAKE,SDATE,EDATE,
			BARCODENEW,ABCTYPE,PERWEIGHT,PERVOLUM,BRANDNAME,AGENTNAME,INVSTRUCTURE,INVUSAGE,USESTATE,NOTE,
			STATE,CHECKDATE,CHECKER,ISBID,BIDDATE,BIDCODE,ISINVOLVED,ISIMPLANT,STORATRANCOND,ISZEROSTORE,ALIASSPELL)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
}

/// 材料分类字典表 MAT_TYPE
/// Author: lihui
/// Date: 20200521
/// CALL web_DHCSTMService_HRP.QueryAllMatInfo_QueryMatCat()
/// d ##class(%ResultSet).RunQuery("web.DHCSTMService.HRP.QueryAllMatInfo","QueryMatCat")
Query QueryMatCat() As websys.Query(ROWSPEC = "MATTYPEID:%String,MATTYPECODE:%String,MATTYPENAME:%String,SUPERCODE:%String,ISLAST:%String,TYPELEVEL:%String,ISSTOP:%String,SPELLCODE:%String,WBXCODE:%String,ISBUDG:%String,ISAUTOEXP:%String,EXPYEAR:%String,NOTE:%String,SORTCODE:%String") [ SqlProc ]
{
}

ClassMethod QueryMatCatExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s incscId=0,count=0
	f  s incscId=$O(^INC("SC",incscId)) q:incscId=""  d
	.s incscinfo=^INC("SC",incscId)
	.s type=$p(incscinfo,"^",3)
	.q:type'="M"
	.s incscCode=$p(incscinfo,"^",1)
	.s incscDesc=$p(incscinfo,"^",2)
	.s scgid=$o(^DHCSCG("STKCAT",incscId,""))
	.q:scgid=""
	.q:'$d(^DHCSCG(scgid))
	.s scgCode=$p(^DHCSCG(scgid),"^",1)
	.s count=count+1
	.s MATTYPEID=incscId ;材料分类ID
	.s MATTYPECODE=incscCode ;材料分类编码
	.s MATTYPENAME=incscDesc ;材料分类名称
	.s SUPERCODE=scgCode ;上级分类编码
	.s ISLAST=1 ;是否末级
	.s TYPELEVEL=2 ;级次
	.s ISSTOP=0 ;是否停用
	.s SPELLCODE="" ;拼音码
	.s WBXCODE="" ;五笔码
	.s ISBUDG=0 ;
	.s ISAUTOEXP=1 ;是否自动有效期
	.s EXPYEAR="" ;默认有效年限
	.s NOTE="" ;备注
	.s SORTCODE=count ;排序号
	.d OutputRowMatCat
	Quit $$$OK
OutputRowMatCat	
	s Data=$lb(MATTYPEID,MATTYPECODE,MATTYPENAME,SUPERCODE,ISLAST,TYPELEVEL,ISSTOP,SPELLCODE,WBXCODE,ISBUDG,ISAUTOEXP,EXPYEAR,NOTE,SORTCODE)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	入库主表(HIP_MAT_IN_MAIN) 
/// 	CALL web_DHCSTMService_HRP.QueryAllMatInfo_GetIngrMain("2018-05-18","2020-05-22") 
/// d ##class(%ResultSet).RunQuery("web.DHCSTMService.HRP.QueryAllMatInfo","GetIngrMain","2018-05-18","2020-05-22")
Query GetIngrMain(StartDate As %String, EndDate As %String, LocIdStr As %String = "") As websys.Query(ROWSPEC = "GROUP_ID,HOS_ID,COPY_CODE,DS_CODE,IN_NO,YEAR,MONTH,BUS_TYPE_CODE,SUP_code,STORE_code,BRIEF,MAKER,IN_DATE,CHECKER,CHECK_DATE,CONFIRMER,CONFIRM_DATE,PROTOCOL_CODE,PROJ_CODE,SOURCE_CODE,BILL_NO,BILL_DATE,BILL_STATE") [ SqlProc ]
{
}

ClassMethod GetIngrMainExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocIdStr As %String = "") As %Status
{
	n (qHandle,StartDate,EndDate,LocIdStr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s pid=..NewPid()
	k ^TMP("DHCSTMService.HRP","GetIngrMain",pid)
	s YEAR=$p(EndDate,"-",1)
	s MONTH=$p(EndDate,"-",2)
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	s GROUPID=..#GROUPID
	s HOSID=..#HOSID
	s COPYCODE=..#COPYCODE
	s DSCODE=..#DSCODE
	f date=StartDate:1:EndDate d
	.;统计入库部分
	.s intrid=""
	.f  s intrid=$o(^DHCINTR(0,"TypeDate","G",date,intrid)) q:intrid=""  d
	..q:'$d(^DHCINTR(intrid))
	..s pointer=$p(^DHCINTR(intrid),"^",9)
	..s Ingr=+pointer
	..s dhcingri=$p(pointer,"||",2)
	..q:'$d(^DHCINGR(Ingr))
	..q:'$d(^DHCINGR(Ingr,"GRI",dhcingri))
	..s StkType=$p(^DHCINGR(Ingr),"^",30)
	..q:StkType'="M"
	..s IngrNo=$p(^DHCINGR(Ingr),"^",1)				;入库单号
	..q:IngrNo=""
	..s ApcvmDr=$p(^DHCINGR(Ingr),"^",3)			;供应商ID
	..s ApcvmDesc=""
	..s:ApcvmDr'="" ApcvmDesc=$p(^APC("APCVM",ApcvmDr),"^",3)
	..s RecLocId=$p(^DHCINGR(Ingr),"^",13)			;入库科室ID
	..q:(LocIdStr'="")&&((","_LocIdStr_",")'[(","_RecLocId_","))
	..s:RecLocId'="" RecLocDesc=$p(^CTLOC(RecLocId),"^",2)
	..s Remark=""
	..i $d(^DHCINGR(Ingr,"REM",1))  d				;入库单备注
	...s Remark=^DHCINGR(Ingr,"REM",1)
	..s (CreateUser,AuditUser)=""
	..s CreateUserId=$p(^DHCINGR(Ingr),"^",16)		;入库制单人
	..s:CreateUserId'="" CreateUser=$p(^SSU("SSUSR",CreateUserId),"^",2)
	..s CreateDate=$p(^DHCINGR(Ingr),"^",14)		;入库制单日期
	..s:+CreateDate'=0 CreateDate=$zd(CreateDate,3)
	..s AuditUserId=$p(^DHCINGR(Ingr),"^",8)		;入库审核人
	..s:AuditUserId'="" AuditUser=$p(^SSU("SSUSR",AuditUserId),"^",2)
	..s AuditDate=$p(^DHCINGR(Ingr),"^",4)			;入库审核日期
	..s:+AuditDate'=0 AuditDate=$zd(AuditDate,3)
	..s SourceOfFund=$p(^DHCINGR(Ingr),"^",36)		;资金来源
	..s:SourceOfFund'="" SourceOfFundCode=$p(^DHCSOUROFFUND(SourceOfFund),"^",1)
	..s:SourceOfFund'="" SourceOfFundDesc=$p(^DHCSOUROFFUND(SourceOfFund),"^",2)
	..s ConfirmDate=AuditDate,ConfirmUser=AuditUser	;入库确认人、确认日期暂取审核人和审核日期
	..s Type=2	;业务类型(入库2)
	..s Sub=Ingr_"^"_Type
	..i '$d(^TMP("DHCSTMService.HRP","GetIngrMain",pid,Sub)) d
	...s ^TMP("DHCSTMService.HRP","GetIngrMain",pid,Sub)=IngrNo_"^"_ApcvmDr_"^"_RecLocId_"^"_Remark_"^"_CreateUser_"^"_AuditUser_"^"_AuditDate_"^"_ConfirmUser_"^"_ConfirmDate
	.;统计退货部分
	.s intrid=""
	.f  s intrid=$o(^DHCINTR(0,"TypeDate","R",date,intrid)) q:intrid=""  d
	..q:'$d(^DHCINTR(intrid))
	..s pointer=$p(^DHCINTR(intrid),"^",9)
	..s ingrtid=$p(pointer,"||",1)
	..s retch=$p(pointer,"||",2)
	..q:'$d(^INGRT(ingrtid))
	..q:'$d(^INGRT(ingrtid,"DHCGRR",retch))
	..s StkType=$p(^INGRT(ingrtid),"^",16)
	..q:StkType'="M"
	..s ingri=$p(^INGRT(ingrtid,"DHCGRR",retch),"^",1)
	..s ingrid=$p(ingri,"||",1)
	..s dhcingri=$p(ingri,"||",2)
	..q:ingri=""
	..s Ingrtno=$p(^INGRT(ingrtid),"^",1)			;退货单号
	..s ApcvmDr=$p(^INGRT(ingrtid),"^",2)			;供应商ID
	..s ApcvmDesc=""
	..s:ApcvmDr'="" ApcvmDesc=$p(^APC("APCVM",ApcvmDr),"^",3)
	..s RetLocId=$p(^INGRT(ingrtid),"^",7)			;退货科室ID
	..q:(LocIdStr'="")&&((","_LocIdStr_",")'[(","_RecLocId_","))
	..s Remark=$p(^INGRT(ingrtid),"^",26)			;退货备注
	..s IngrtCreateDate=$p(^INGRT(ingrtid),"^",3)	;退货制单日期
	..s:IngrtCreateDate'="" IngrtCreateDate=$zd(IngrtCreateDate,3)
	..s IngrtCreateuserid=$p(^INGRT(ingrtid),"^",5)	;退货制单人
	..s:IngrtCreateuserid'="" IngrtCreateuser=$p(^SSU("SSUSR",IngrtCreateuserid),"^",2)
	..s IngrtDate=$p(^INGRT(ingrtid),"^",9)			;退货审核日期
	..s:IngrtDate'="" IngrtDate=$zd(IngrtDate,3)
	..s Ingrtuserid=$p(^INGRT(ingrtid),"^",8)		;退货审核人
	..s:Ingrtuserid'="" Ingrtuser=$p(^SSU("SSUSR",Ingrtuserid),"^",2)
	..s SourceOfFund=$p(^DHCINGR(ingrid),"^",36)	;资金来源
	..s:SourceOfFund'="" SourceOfFundCode=$p(^DHCSOUROFFUND(SourceOfFund),"^",1)
	..s:SourceOfFund'="" SourceOfFundDesc=$p(^DHCSOUROFFUND(SourceOfFund),"^",2)
	..s ConfirmDate=IngrtDate,ConfirmUser=Ingrtuser	;退货确认人、确认日期暂取审核人和审核日期
	..s Type=12
	..s Sub=ingrtid_"^"_Type
	..i '$d(^TMP("DHCSTMService.HRP","GetIngrMain",pid,Sub)) d
	...s ^TMP("DHCSTMService.HRP","GetIngrMain",pid,Sub)=Ingrtno_"^"_ApcvmDr_"^"_RecLocId_"^"_Remark_"^"_CreateUser_"^"_AuditUser_"^"_AuditDate_"^"_ConfirmUser_"^"_ConfirmDate
	s Sub=""
	f  s Sub=$o(^TMP("DHCSTMService.HRP","GetIngrMain",pid,Sub)) q:Sub=""  d
	.s BUSTYPECODE=$p(Sub,"^",2)
	.s INNO=$p(^TMP("DHCSTMService.HRP","GetIngrMain",pid,Sub),"^",1)
	.s SUPcode=$p(^TMP("DHCSTMService.HRP","GetIngrMain",pid,Sub),"^",2)
	.s STOREcode=$p(^TMP("DHCSTMService.HRP","GetIngrMain",pid,Sub),"^",3)
	.s BRIEF=$p(^TMP("DHCSTMService.HRP","GetIngrMain",pid,Sub),"^",4)
	.s MAKER=$p(^TMP("DHCSTMService.HRP","GetIngrMain",pid,Sub),"^",5)
	.s INDATE=$p(^TMP("DHCSTMService.HRP","GetIngrMain",pid,Sub),"^",6)
	.s CHECKER=$p(^TMP("DHCSTMService.HRP","GetIngrMain",pid,Sub),"^",7)
	.s CHECKDATE=$p(^TMP("DHCSTMService.HRP","GetIngrMain",pid,Sub),"^",8)
	.s CONFIRMER=$p(^TMP("DHCSTMService.HRP","GetIngrMain",pid,Sub),"^",9)
	.s CONFIRMDATE=$p(^TMP("DHCSTMService.HRP","GetIngrMain",pid,Sub),"^",10)
	.s (PROTOCOLCODE,PROJCODE,BILLNO,BILLDATE,BILLSTATE)=""	;协议编号/项目编码/发票号/发票日期传空
	.d OutPutIngrMain
	k ^TMP("DHCSTMService.HRP","GetIngrMain",pid)
	Quit $$$OK
	
OutPutIngrMain
	s Data=$lb(GROUPID,HOSID,COPYCODE,DSCODE,INNO,YEAR,MONTH,BUSTYPECODE,
		SUPcode,STOREcode,BRIEF,MAKER,INDATE,CHECKER,CHECKDATE,CONFIRMER,CONFIRMDATE,
		PROTOCOLCODE,PROJCODE,SOURCECODE,BILLNO,BILLDATE,BILLSTATE
	)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:出库主表(HIP_MAT_OUT_MAIN) 
/// CALL web_DHCSTMService_HRP.QueryAllMatInfo_GetInitMain("2018-05-18","2020-05-22") 
/// d ##class(%ResultSet).RunQuery("web.DHCSTMService.HRP.QueryAllMatInfo","GetInitMain","2020-05-18","2020-05-22")
Query GetInitMain(StartDate As %String, EndDate As %String, LocIdStr As %String = "") As websys.Query(ROWSPEC = "GROUP_ID,HOS_ID,COPY_CODE,DS_CODE,OUT_NO,YEAR,MONTH,BUS_TYPE_CODE,STORE_CODE,BRIEF,DEPT_CODE,DEPT_EMP,MAKER,OUT_DATE,CHECKER,CHECK_DATE,CONFIRMER,CONFIRM_DATE,PROJ_CODE,SOURCE_CODE,STATE") [ SqlProc ]
{
}

ClassMethod GetInitMainExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocIdStr As %String = "") As %Status
{
	n (qHandle,StartDate,EndDate,LocIdStr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s pid=..NewPid()
	k ^TMP("DHCSTMService.HRP","GetInitMain",pid)
	s YEAR=$p(EndDate,"-",1)
	s MONTH=$p(EndDate,"-",2)
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	s GROUPID=..#GROUPID
	s HOSID=..#HOSID
	s COPYCODE=..#COPYCODE
	s DSCODE=..#DSCODE
	f date=StartDate:1:EndDate d
	.;统计出库部分
	.s intrid=""
	.f  s intrid=$o(^DHCINTR(0,"TypeDate","T",date,intrid)) q:intrid=""  d
	..q:'$d(^DHCINTR(intrid))
	..s pointer=$p(^DHCINTR(intrid),"^",9)
	..s MainId=+pointer
	..s Chl=$p(pointer,"||",2)
	..q:'$d(^DHCINIT(MainId))
	..q:'$d(^DHCINIT(MainId,"ITI",Chl))
	..s StkType=$p(^DHCINIT(MainId),"^",24)
	..q:StkType'="M"
	..s FromLocId=$p(^DHCINIT(MainId),"^",5)		;出库科室
	..q:FromLocId=""
	..q:(LocIdStr'="")&&((","_LocIdStr_",")'[(","_FromLocId_","))
	..s:FromLocId'="" FromLocDesc=$p(^CTLOC(FromLocId),"^",2)
	..s ToLocId=$p(^DHCINIT(MainId),"^",6)			;接收科室	
	..s InitNo =$p(^DHCINIT(MainId),"^",1)			;出库单号
	..s Remark=""
	..i $d(^DHCINIT(MainId,"REM",1))  d				;备注
	...s Remark=^DHCINIT(MainId,"REM",1)
	..s (InitCreateUser,InitAuditUser,InitInackUser)=""
	..s InitCreateUserId=$p(^DHCINIT(MainId),"^",8)	;出库制单人
	..s:InitCreateUserId'="" InitCreateUser=$p(^SSU("SSUSR",InitCreateUserId),"^",2)
	..s InitCreateDate=$p(^DHCINIT(MainId),"^",2)	;出库制单日期
	..s:InitCreateDate'="" InitCreateDate=$zd(InitCreateDate,3)
	..s InitAuditUserId=$p(^DHCINIT(MainId),"^",11)	;出库审核人
	..s:InitAuditUserId'="" InitAuditUser=$p(^SSU("SSUSR",InitAuditUserId),"^",2)
	..s InitAuditDate=$p(^DHCINIT(MainId),"^",9)	;出库审核日期
	..s:InitAuditDate'="" InitAuditDate=$zd(InitAuditDate,3)
	..s InitInackUserId=$p(^DHCINIT(MainId),"^",17)	;出库接收人
	..s:InitInackUserId'="" InitInackUser=$p(^SSU("SSUSR",InitInackUserId),"^",2)
	..s InitInackDate=$p(^DHCINIT(MainId),"^",15)	;出库接收日期
	..s:InitInackDate'="" InitInackDate=$zd(InitInackDate,3)
	..s ConfirmDate=InitAuditDate,ConfirmUser=InitAuditUser	;出库确认人、确认日期暂取审核人和审核日期
	..s Type=3
	..s Sub=MainId_"^"_Type
	..i '$d(^TMP("DHCSTMService.HRP","GetInitMain",pid,Sub)) d
	...s ^TMP("DHCSTMService.HRP","GetInitMain",pid,Sub)=InitNo_"^"_FromLocId_"^"_Remark_"^"_ToLocId_"^"_InitInackUser_"^"_InitCreateUser_"^"_InitCreateDate_"^"_InitAuditUser_"^"_InitAuditDate_"^"_ConfirmUser_"^"_ConfirmDate
	.;统计退库部分
	.s intrid=""
	.f  s intrid=$o(^DHCINTR(0,"TypeDate","K",date,intrid)) q:intrid=""  d
	..q:'$d(^DHCINTR(intrid))
	..s MainId=+pointer
	..s Chl=$p(pointer,"||",2)
	..q:'$d(^DHCINIT(MainId))
	..q:'$d(^DHCINIT(MainId,"ITI",Chl))
	..s StkType=$p(^DHCINIT(MainId),"^",24)
	..q:StkType'="M"
	..s FromLocId=$p(^DHCINIT(MainId),"^",5)		;出库科室
	..s ToLocId=$p(^DHCINIT(MainId),"^",6)			;接收科室
	..q:ToLocId=""
	..q:(LocIdStr'="")&&((","_LocIdStr_",")'[(","_ToLocId_","))
	..s:ToLocId'="" ToLocDesc=$p(^CTLOC(ToLocId),"^",2)
	..s InitNo =$p(^DHCINIT(MainId),"^",1)			;出库单号
	..s Remark=""
	..i $d(^DHCINIT(MainId,"REM",1))  d				;备注
	...s Remark=^DHCINIT(MainId,"REM",1)
	..s (InitCreateUser,InitAuditUser,InitInackUser)=""
	..s InitCreateUserId=$p(^DHCINIT(MainId),"^",8)	;出库制单人
	..s:InitCreateUserId'="" InitCreateUser=$p(^SSU("SSUSR",InitCreateUserId),"^",2)
	..s InitCreateDate=$p(^DHCINIT(MainId),"^",2)	;出库制单日期
	..s:InitCreateDate'="" InitCreateDate=$zd(InitCreateDate,3)
	..s InitAuditUserId=$p(^DHCINIT(MainId),"^",11)	;出库审核人
	..s:InitAuditUserId'="" InitAuditUser=$p(^SSU("SSUSR",InitAuditUserId),"^",2)
	..s InitAuditDate=$p(^DHCINIT(MainId),"^",9)	;出库审核日期
	..s:InitAuditDate'="" InitAuditDate=$zd(InitAuditDate,3)
	..s InitInackUserId=$p(^DHCINIT(MainId),"^",17)	;出库接收人
	..s:InitInackUserId'="" InitInackUser=$p(^SSU("SSUSR",InitInackUserId),"^",2)
	..s InitInackDate=$p(^DHCINIT(MainId),"^",15)	;出库接收日期
	..s:InitInackDate'="" InitInackDate=$zd(InitInackDate,3)
	..s ConfirmDate=InitAuditDate,ConfirmUser=InitAuditUser	;出库确认人、确认日期暂取审核人和审核日期
	..s Type=21
	..s Sub=MainId_"^"_Type
	..i '$d(^TMP("DHCSTMService.HRP","GetInitMain",pid,Sub)) d
	...s ^TMP("DHCSTMService.HRP","GetInitMain",pid,Sub)=InitNo_"^"_ToLocId_"^"_Remark_"^"_FromLocId_"^"_InitInackUser_"^"_InitCreateUser_"^"_InitCreateDate_"^"_InitAuditUser_"^"_InitAuditDate_"^"_ConfirmUser_"^"_ConfirmDate
	s Sub=""
	f  s Sub=$o(^TMP("DHCSTMService.HRP","GetInitMain",pid,Sub)) q:Sub=""  d
	.s BUSTYPECODE=$p(Sub,"^",2)
	.s OUTNO=$p(^TMP("DHCSTMService.HRP","GetInitMain",pid,Sub),"^",1)
	.s STORECODE=$p(^TMP("DHCSTMService.HRP","GetInitMain",pid,Sub),"^",2)
	.s BRIEF=$p(^TMP("DHCSTMService.HRP","GetInitMain",pid,Sub),"^",3)
	.s DEPTCODE=$p(^TMP("DHCSTMService.HRP","GetInitMain",pid,Sub),"^",4)
	.s DEPTEMP=$p(^TMP("DHCSTMService.HRP","GetInitMain",pid,Sub),"^",5)
	.s MAKER=$p(^TMP("DHCSTMService.HRP","GetInitMain",pid,Sub),"^",6)
	.s OUTDATE=$p(^TMP("DHCSTMService.HRP","GetInitMain",pid,Sub),"^",7)
	.s CHECKER=$p(^TMP("DHCSTMService.HRP","GetInitMain",pid,Sub),"^",8)
	.s CHECKDATE=$p(^TMP("DHCSTMService.HRP","GetInitMain",pid,Sub),"^",9)
	.s CONFIRMER=$p(^TMP("DHCSTMService.HRP","GetInitMain",pid,Sub),"^",10)
	.s CONFIRMDATE=$p(^TMP("DHCSTMService.HRP","GetInitMain",pid,Sub),"^",11)
	.s (PROTOCOLCODE,SOURCECODE)=""	;项目编码传空
	.s STATE=3
	.b ;1
	.d OutPutInitMain
	k ^TMP("DHCSTMService.HRP","GetInitMain",pid)
	Quit $$$OK
OutPutInitMain
	s Data=$lb(GROUPID,HOSID,COPYCODE,DSCODE,OUTNO,YEAR,MONTH,BUSTYPECODE,STORECODE,
		BRIEF,DEPTCODE,DEPTEMP,MAKER,OUTDATE,CHECKER,CHECKDATE,CONFIRMER,CONFIRMDATE,
		PROJCODE,SOURCECODE,STATE
	)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:入库明细表(HIP_MAT_IN_DETAIL)(退货明细)
/// CALL web_DHCSTMService_HRP.QueryAllMatInfo_GetIngrDetail("2018-05-18","2020-05-22")
/// d ##class(%ResultSet).RunQuery("web.DHCSTMService.HRP.QueryAllMatInfo","GetIngrDetail","2020-05-18","2020-05-22")
Query GetIngrDetail(StartDate As %String, EndDate As %String, LocIdStr As %String = "") As websys.Query(ROWSPEC = "GROUP_ID,HOS_ID,COPY_CODE,DS_CODE,IN_ID,IN_NO,INV_CODE,BATCH_NO,PRICE,AMOUNT,AMOUNT_MONEY,NOTE") [ SqlProc ]
{
}

ClassMethod GetIngrDetailExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocIdStr As %String = "") As %Status
{
	n (qHandle,StartDate,EndDate,LocIdStr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	s GROUPID=..#GROUPID
	s HOSID=..#HOSID
	s COPYCODE=..#COPYCODE
	s DSCODE=..#DSCODE
	s TypeStr="G^R"
	s TypeNum=$l(TypeStr,"^")
	s LocNum=$l(LocIdStr,"^")
	f i=1:1:TypeNum d
	.s TrType=$p(TypeStr,"^",i)
	.f date=StartDate:1:EndDate d
	..s intrid=0
	..f  s intrid=$o(^DHCINTR(0,"TypeDate",TrType,date,intrid)) q:intrid=""  d
	...q:'$d(^DHCINTR(intrid))
	...s pointer=$p(^DHCINTR(intrid),"^",9)		;明细表ID
	...s MainId=+pointer
	...s Ch=$p(pointer,"||",2)
	...q:(TrType="G")&&('$d(^DHCINGR(MainId)))
	...q:(TrType="G")&&('$d(^DHCINGR(MainId,"GRI",Ch)))
	...q:(TrType="R")&&('$d(^INGRT(MainId)))
	...q:(TrType="R")&&('$d(^INGRT(MainId,"DHCGRR",Ch)))
	...s:TrType="G" StkType=$p(^DHCINGR(MainId),"^",30)
	...s:TrType="R" StkType=$p(^INGRT(MainId),"^",16)
	...q:StkType'="M"
	...s No=$p(^DHCINTR(intrid),"^",13)			;单号
	...s:TrType="G" RecLocId=$p(^DHCINGR(MainId),"^",13)			;入库科室ID
	...s:TrType="R" RecLocId=$p(^INGRT(MainId),"^",7)			;退货科室ID
	...q:(LocIdStr'="")&&((","_LocIdStr_",")'[(","_RecLocId_","))
	...s Inclb=$p(^DHCINTR(intrid),"^",7)
	...s Inci=$p(Inclb,"||",1)
	...q:Inci=""
	...s InciCode=$p(^INCI(Inci,1),"^",1)		;材料编码
	...s BatInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	...s Batno=$p(BatInfo,"^",1)				;批号
	...s TrUom=$p(^DHCINTR(intrid),"^",10)
	...s BUomId=$p(^INCI(Inci,1),"^",10)
	...s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(TrUom,BUomId)
	...s Qty=$p(^DHCINTR(intrid),"^",6)
	...s Rp=$p(^DHCINTR(intrid),"^",16)
	...s Qty=Qty*UomFac							;数量
	...s:Rp'=0 Rp=Rp/UomFac						;单价
	...s RpAmt=$p(^DHCINTR(intrid),"^",17)		;金额
	...S Rp=$fn(Rp,"",2)
	...s RpAmt=$fn(RpAmt,"",2)
	...s Remark=""
	...s:TrType="G" Remark=$p(^DHCINGR(MainId,"GRI",Ch),"^",44)	;备注 
	...s:TrType="R" Remark=$p(^INGRT(MainId,"DHCGRR",Ch),"^",21)	;备注 
	...d OutPutIngrDeatail
	Quit $$$OK
	
OutPutIngrDeatail
	s Data=$lb(GROUPID,HOSID,COPYCODE,DSCODE,pointer,No,InciCode,Batno,Rp,Qty,RpAmt,Remark)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:出库明细表(HIP_MAT_OUT_DETAIL)
/// CALL web_DHCSTMService_HRP.QueryAllMatInfo_GetInitDetail("2018-05-18","2020-05-22")
/// d ##class(%ResultSet).RunQuery("web.DHCSTMService.HRP.QueryAllMatInfo","GetInitDetail","2020-05-18","2020-05-22")
Query GetInitDetail(StartDate As %String, EndDate As %String, LocIdStr As %String = "") As websys.Query(ROWSPEC = "GROUP_ID,HOS_ID,COPY_CODE,DS_CODE,OUT_ID,OUT_NO,INV_CODE,BATCH_NO,PRICE,AMOUNT,AMOUNT_MONEY,NOTE") [ SqlProc ]
{
}

ClassMethod GetInitDetailExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocIdStr As %String = "") As %Status
{
	n (qHandle,StartDate,EndDate,LocIdStr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	s GROUPID=..#GROUPID
	s HOSID=..#HOSID
	s COPYCODE=..#COPYCODE
	s DSCODE=..#DSCODE
	s TypeStr="T^K"
	s TypeNum=$l(TypeStr,"^")
	s LocNum=$l(LocIdStr,"^")
	f i=1:1:TypeNum d
	.s TrType=$p(TypeStr,"^",i)
	.f date=StartDate:1:EndDate d
	..s intrid=0
	..f  s intrid=$o(^DHCINTR(0,"TypeDate",TrType,date,intrid)) q:intrid=""  d
	...q:'$d(^DHCINTR(intrid))
	...s pointer=$p(^DHCINTR(intrid),"^",9)			;明细表ID
	...s MainId=+pointer
	...s Ch=$p(pointer,"||",2)
	...q:'$d(^DHCINIT(MainId))
	...q:'$d(^DHCINIT(MainId,"ITI",Ch))
	...s FromLocId=$p(^DHCINIT(MainId),"^",5)		;出库科室
	...s ToLocId=$p(^DHCINIT(MainId),"^",6)			;接收科室	
	...q:FromLocId=""
	...q:ToLocId=""
	...q:(TrType="T")&&(LocIdStr'="")&&((","_LocIdStr_",")'[(","_FromLocId_","))
	...q:(TrType="K")&&(LocIdStr'="")&&((","_LocIdStr_",")'[(","_ToLocId_","))
	...s No=$p(^DHCINTR(intrid),"^",13)					;单号
	...s Inclb=$p(^DHCINTR(intrid),"^",7)
	...s Inci=$p(Inclb,"||",1)
	...q:Inci=""
	...s InciCode=$p(^INCI(Inci,1),"^",1)				;材料编码
	...s BatInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	...s Batno=$p(BatInfo,"^",1)						;批号
	...s TrUom=$p(^DHCINTR(intrid),"^",10)
	...s BUomId=$p(^INCI(Inci,1),"^",10)
	...s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(TrUom,BUomId)
	...s Qty=$p(^DHCINTR(intrid),"^",6)
	...s Rp=$p(^DHCINTR(intrid),"^",16)
	...s Qty=-(Qty*UomFac)								;数量
	...s:Rp'=0 Rp=Rp/UomFac								;单价
	...s RpAmt=-$p(^DHCINTR(intrid),"^",17)				;金额
	...S Rp=$fn(Rp,"",2)
	...s RpAmt=$fn(RpAmt,"",2)
	...s Remark=$p(^DHCINIT(MainId,"ITI",Ch),"^",24)	;备注
	...d OutPutInitDeatail
	Quit $$$OK
	
OutPutInitDeatail
	s Data=$lb(GROUPID,HOSID,COPYCODE,DSCODE,pointer,No,InciCode,Batno,Rp,Qty,RpAmt,Remark)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript: 出库资金来源表(HIP_MAT_OUT_RESOURCE)
/// CALL web_DHCSTMService_HRP.QueryAllMatInfo_GetInitSource("2018-05-18","2020-05-22")
/// d ##class(%ResultSet).RunQuery("web.DHCSTMService.HRP.QueryAllMatInfo","GetInitSource","2018-05-18","2020-05-22")
Query GetInitSource(StartDate As %String, EndDate As %String, LocIdStr As %String = "") As websys.Query(ROWSPEC = "GROUP_ID,HOS_ID,COPY_CODE,OUTID,SOURCEID,SOURCEMONEY") [ SqlProc ]
{
}

ClassMethod GetInitSourceExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocIdStr As %String = "") As %Status
{
	n (qHandle,StartDate,EndDate,LocIdStr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s pid=$i(^TMPDHCSTM("InitSource"))
	k ^TMPDHCSTM("INITSOURCEFOUND",pid)
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	s GROUPID=..#GROUPID
	s HOSID=..#HOSID
	s COPYCODE=..#COPYCODE
	s DSCODE=..#DSCODE
	s TypeStr="T^K"
	s TypeNum=$l(TypeStr,"^")
	s LocNum=$l(LocIdStr,"^")
	f i=1:1:TypeNum d
	.s TrType=$p(TypeStr,"^",i)
	.f date=StartDate:1:EndDate d
	..s intrid=0
	..f  s intrid=$o(^DHCINTR(0,"TypeDate",TrType,date,intrid)) q:intrid=""  d
	...q:'$d(^DHCINTR(intrid))
	...s pointer=$p(^DHCINTR(intrid),"^",9)			;明细表ID
	...s MainId=+pointer
	...s Ch=$p(pointer,"||",2)
	...q:'$d(^DHCINIT(MainId))
	...q:'$d(^DHCINIT(MainId,"ITI",Ch))
	...s FromLocId=$p(^DHCINIT(MainId),"^",5)		;出库科室
	...s ToLocId=$p(^DHCINIT(MainId),"^",6)			;接收科室	
	...q:FromLocId=""
	...q:ToLocId=""
	...q:(TrType="T")&&(LocIdStr'="")&&((","_LocIdStr_",")'[(","_FromLocId_","))
	...q:(TrType="K")&&(LocIdStr'="")&&((","_LocIdStr_",")'[(","_ToLocId_","))
	...s No=$p(^DHCINTR(intrid),"^",13)					;单号
	...s Inclb=$p(^DHCINTR(intrid),"^",7)
	...s Inci=$p(Inclb,"||",1)
	...q:Inci=""
	...s SourceFoundid=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSourceOfFundInfoByInclb(Inclb),"^",1)
	...i SourceFoundid="" s SourceFoundid="*"
	...s SourceFoundDesc=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSourceOfFundInfoByInclb(Inclb),"^",2)
	...s RpAmt=-$p(^DHCINTR(intrid),"^",17)				;金额
	...s RpAmt=$fn(RpAmt,"",2)
	...i '$d(^TMPDHCSTM("INITSOURCEFOUND",pid,MainId,SourceFoundid)) d
	....s ^TMPDHCSTM("INITSOURCEFOUND",pid,MainId,SourceFoundid)=RpAmt
	...e  d
	....s ^TMPDHCSTM("INITSOURCEFOUND",pid,MainId,SourceFoundid)=^TMPDHCSTM("INITSOURCEFOUND",pid,MainId,SourceFoundid)+RpAmt 
	
	s Initid=""
	f  s Initid=$o(^TMPDHCSTM("INITSOURCEFOUND",pid,Initid)) q:Initid=""  d
	.s Sourceid=""
	.f  s Sourceid=$o(^TMPDHCSTM("INITSOURCEFOUND",pid,Initid,Sourceid)) q:Sourceid=""  d
	..s RpAmt=^TMPDHCSTM("INITSOURCEFOUND",pid,Initid,Sourceid)
	..s OUTID=Initid ;单据ID
	..s SOURCEID=Sourceid ;资金来源ID
	..s SOURCEMONEY=RpAmt
	..d OutPutInitSource
	k ^TMPDHCSTM("INITSOURCEFOUND",pid)
	Quit $$$OK
	
OutPutInitSource
	s Data=$lb(GROUPID,HOSID,COPYCODE,OUTID,SOURCEID,SOURCEMONEY)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:入库资金来源表(HIP_MAT_IN_RESOURCE)
/// CALL web_DHCSTMService_HRP.QueryAllMatInfo_GetIngrSource("2018-05-18","2020-05-22")
/// d ##class(%ResultSet).RunQuery("web.DHCSTMService.HRP.QueryAllMatInfo","GetIngrSource","2018-05-18","2020-05-22")
Query GetIngrSource(StartDate As %String, EndDate As %String, LocIdStr As %String = "") As websys.Query(ROWSPEC = "GROUP_ID,HOS_ID,COPY_CODE,INID,SOURCEID,SOURCEMONEY") [ SqlProc ]
{
}

ClassMethod GetIngrSourceExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocIdStr As %String = "") As %Status
{
	n (qHandle,StartDate,EndDate,LocIdStr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	
	s pid=$i(^TMPDHCSTM("IngrSource"))
	k ^TMPDHCSTM("INGRSOURCEFOUND",pid)
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	s GROUPID=..#GROUPID
	s HOSID=..#HOSID
	s COPYCODE=..#COPYCODE
	s DSCODE=..#DSCODE
	s TypeStr="G^R"
	s TypeNum=$l(TypeStr,"^")
	s LocNum=$l(LocIdStr,"^")
	f i=1:1:TypeNum d
	.s TrType=$p(TypeStr,"^",i)
	.f date=StartDate:1:EndDate d
	..s intrid=0
	..f  s intrid=$o(^DHCINTR(0,"TypeDate",TrType,date,intrid)) q:intrid=""  d
	...q:'$d(^DHCINTR(intrid))
	...s pointer=$p(^DHCINTR(intrid),"^",9)		;明细表ID
	...s MainId=+pointer
	...s Ch=$p(pointer,"||",2)
	...q:(TrType="G")&&('$d(^DHCINGR(MainId)))
	...q:(TrType="G")&&('$d(^DHCINGR(MainId,"GRI",Ch)))
	...q:(TrType="R")&&('$d(^INGRT(MainId)))
	...q:(TrType="R")&&('$d(^INGRT(MainId,"DHCGRR",Ch)))
	...s:TrType="G" StkType=$p(^DHCINGR(MainId),"^",30)
	...s:TrType="R" StkType=$p(^INGRT(MainId),"^",16)
	...q:StkType'="M"
	...s No=$p(^DHCINTR(intrid),"^",13)			;单号
	...s:TrType="G" RecLocId=$p(^DHCINGR(MainId),"^",13)			;入库科室ID
	...s:TrType="R" RecLocId=$p(^INGRT(MainId),"^",7)			;退货科室ID
	...q:(LocIdStr'="")&&((","_LocIdStr_",")'[(","_RecLocId_","))
	...s Inclb=$p(^DHCINTR(intrid),"^",7)
	...s Inci=$p(Inclb,"||",1)
	...q:Inci=""
	...s SourceFoundid=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSourceOfFundInfoByInclb(Inclb),"^",1)
	...i SourceFoundid="" s SourceFoundid="*"
	...s SourceFoundDesc=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSourceOfFundInfoByInclb(Inclb),"^",2)
	...s RpAmt=$p(^DHCINTR(intrid),"^",17)		;金额
	...s RpAmt=$fn(RpAmt,"",2)
	...i '$d(^TMPDHCSTM("INGRSOURCEFOUND",pid,MainId,SourceFoundid)) d
	....s ^TMPDHCSTM("INGRSOURCEFOUND",pid,MainId,SourceFoundid)=RpAmt
	...e  d
	....s ^TMPDHCSTM("INGRSOURCEFOUND",pid,MainId,SourceFoundid)=^TMPDHCSTM("INGRSOURCEFOUND",pid,MainId,SourceFoundid)+RpAmt 
	s Ignrid=""
	f  s Ignrid=$o(^TMPDHCSTM("INGRSOURCEFOUND",pid,Ignrid)) q:Ignrid=""  d
	.s Sourceid=""
	.f  s Sourceid=$o(^TMPDHCSTM("INGRSOURCEFOUND",pid,Ignrid,Sourceid)) q:Sourceid=""  d
	..s RpAmt=^TMPDHCSTM("INGRSOURCEFOUND",pid,Ignrid,Sourceid)
	..s INID=Ignrid ;单据ID
	..s SOURCEID=Sourceid ;资金来源ID
	..s SOURCEMONEY=RpAmt
	..d OutPutIngrSource
	k ^TMPDHCSTM("INGRSOURCEFOUND",pid)
	Quit $$$OK
	
OutPutIngrSource
	s Data=$lb(GROUPID,HOSID,COPYCODE,INID,SOURCEID,SOURCEMONEY)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
