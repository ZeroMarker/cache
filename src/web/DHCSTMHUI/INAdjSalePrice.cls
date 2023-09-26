Import sqluser

/// Descript:调价
/// Creater:	ZhangDongmei
/// CreateDate:	2012-06-04
Class web.DHCSTMHUI.INAdjSalePrice Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTADJSPM";

/// Descript:	保存三大项新增项目的价格信息
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-20
/// Table:in_adjsaleprice
/// Input:库存项id,售价,操作人id,入库单位id,进价,医院id,模块名字，单号前缀
/// 物价文件号^物价备案时间^物价生效日期
/// Output:		
/// Return：调价表rowid
ClassMethod CreateAdjspFromNewitm1(ItmRowid, Sp, UserId, PurUomId, Rp, AppName, HospID = "", WarrentInfo = "", LocId = "") As RtnObj
{
	n (ItmRowid,Sp,UserId,PurUomId,Rp,AppName,HospID,WarrentInfo,LocId)
	s RtnObj=##class(RtnObj).%New()
	s AdjDate=$p($h,",",1)			;调价日期
	i ItmRowid="" q RtnObj.Err(-1,"","库存项不能为空!","",0)			;库存项不能为空
	i '$d(^INCI(ItmRowid)) q RtnObj.Err(-1,"","无效的库存项!","",0)	;无效的库存项
	i PurUomId="" q RtnObj.Err(-1,"","单位不能为空!","",0) 				;单位不能为空
	i '$d(^CT("UOM",PurUomId)) q RtnObj.Err(-1,"","无效的单位!","",0)	;无效的单位
	;
	s resultString=""
	s StkCatId=$p(^INCI(ItmRowid,2),"^",2)
	s PriorSp=0
	s PriorRp=0
	s BuomId=$p(^INCI(ItmRowid,1),"^",10)
	i BuomId="" q RtnObj.Err(-1,"","基本单位不能为空!","",0)				;基本单位不能为空
	s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BuomId)
	s ResultSp=+Sp/ConFac
	s ResultRp=+Rp/ConFac
	s Status="No"
	s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(ItmRowid)
	s StkGrpId=$p(StkGrpInfo,"^",5)
	;
	;生成调价单号
	s BillNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,StkGrpId,LocId)
	i BillNo="" q RtnObj.Err(-1,"","生成调价单号失败!") 	;生成调价单号失败
	;
	s WarrentNo=$p(WarrentInfo,"^",1)
	s WarNoDate=$p(WarrentInfo,"^",2)
	s PreExDate=$p(WarrentInfo,"^",3)
	i WarNoDate'=""  s WarNoDate=..DH2L(WarNoDate)
	i PreExDate'=""  s PreExDate=..DH2L(PreExDate)
	i PreExDate=""  d
	.s PreExDate=+$h				//zdm,2011-05-26,计划生效日期为空的话默认为当天
	s ExecuteDate=$zdh("9999-12-31",3)
	s AdjSPCat="自动调价"
	;插入调价记录
	&sql(insert into in_adjsaleprice(inasp_date,inasp_inci_dr,inasp_incsc_dr,inasp_priorsp,inasp_resultsp,
		inasp_ssusr_dr,inasp_status,inasp_no,inasp_ctuom_dr,inasp_ctuom_price,
		INASP_PriorRP,INASP_ResultRP,INASP_CTUOM_Rp,INASP_Hospital_Dr,INASP_WarrentNO,
		INASP_WNODate,INASP_PreExeDate,INASP_ExecuteDate,INASP_Cat) 
	values(:AdjDate,:ItmRowid,:StkCatId,:PriorSp,:ResultSp,
		:UserId,:Status,:BillNo,:PurUomId,:Sp,
		:PriorRp,:ResultRp,:Rp,:HospID,:WarrentNo,
		:WarNoDate,:PreExDate,:ExecuteDate,:AdjSPCat))
	i SQLCODE'=0  d
	.d RtnObj.Err(-1,"",$ClassName()_".CreateAdjspFromNewitm1:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj
	s AspId=$p(%ROWID,$c(1))
	;自动审核调价单
	s RtnObj=..Audit(AspId,UserId)	//$$Audit(%ROWID) zdm，2011-05-26,改为同调价审核调用一样，原调用有问题(没考虑调价生效日期)
	q RtnObj
}

/// Descript:调价单生效
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-20
/// Table:in_adjsaleprice
/// Input:调价表id
/// Output:		
/// Return：0，成功；
/// d ##class(web.DHCSTMHUI.INAdjSalePrice).NightRunAspAmount()
ClassMethod NightRunAspAmount() As %Library.String
{
	new
	;create the asp amount at night-run where the time is after 0:00
	;此routine只能在0点之后执行
	s type=..sssCode()
	s userid=""
	&sql(SELECT SSUSR_RowId into userid FROM ss_user WHERE SSUSR_Initials='demo')  ;任务生效操作人记录为demo的id
	i SQLCODE'=0 d  s userid=""
	s today=+$h ;生效日期为今天
	s auditflag="Audit"
	&sql(declare curnightasp cursor for 
	select inasp_rowid,INASP_INCI_DR From  in_adjsaleprice where INASP_PreExeDate=:today
	and inasp_status=:auditflag)  ;已经审核
	&sql(open curnightasp)
	s result=0
	f  &sql(fetch curnightasp into :inasprowid,:inci) q:SQLCODE  d
	.q:inci=""
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	.s StkType=$p(ScgInfo,"^",3)
	.q:StkType'=type	;不是材料
	.s result=0
	.s result=..Exe(+inasprowid,userid)
	.
	.q:result'=0
	&sql(close curnightasp)
	q
}

/// Descript:	删除某一药品的调价信息(删除药品时调用)
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-28
/// Table:in_adjsaleprice
/// Input:库存项id
/// Output:		
/// Return：0：成功;
ClassMethod DeleteAdjPrice(InciRowid) As %Library.String
{
	n (InciRowid)
	q:InciRowid="" 0
	s $ZT=..sssError()
	;q:'$d(^INASP(0,"INCI",InciRowid)) 0
	;删除调价信息
	s Err=0
	&sql(Delete From IN_AdjSalePrice Where INASP_INCI_DR=:InciRowid)
	i (SQLCODE'=0)&(SQLCODE'=100) d
	.s Err=-1
	q Err
}

/// 以下为新版本
/// Descript:更新调后进价和售价（调价单审核或生效后需修改价格）
/// Creater:	ZhangDongmei
/// CreateDate:	2013-01-08
/// Table:IN_AdjSalePrice
/// Input:rowid^调后售价^调后进价,rowid^调后售价^调后进价
/// Output:	
/// Return:0：成功，
ClassMethod BatUpdatePrice(Rows As %String) As %Library.String
{
	n (Rows,%session)
	s RtnObj=##class(RtnObj).%New()
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Rows)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s AppName=..%GetParameter("AppName")
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s ResultSpUom=Obj.%Get("ResultSpUom")
		s ResultRpUom=Obj.%Get("ResultRpUom")
		q:RowId=""
		s ExeDate=$p(^INASP(RowId),"^",2)
		s Status=$p(^INASP(RowId),"^",9)
		i (Status="Yes")&(ExeDate'=+$h)   d RtnObj.Err(-5,RowId,"不是当天生效的调价单不能修改","",0)
		q:RtnObj.success'=0
		s ListData=RowId_"^"_ResultSpUom_"^"_ResultRpUom
		s RtnObj=..UpdatePrice(ListData)
		q:RtnObj.success'=0
		
		i Status="Yes"  d
		.s $p(^INASP(RowId),"^",9)="Audit"  ;修改状态，否则不允许重复生效
		.s RtnObj=..Exe(RowId)
		q:RtnObj.success'=0	
		
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	更新调后价格（调价审核或生效后需要修改价格）
/// Creater:	ZhangDongmei
/// CreateDate:	2013-01-08
/// Table:in_adjsaleprice
/// Input:明细id^调后售价^调后进价
/// Output:		
/// Return：0:成功；错误代码
ClassMethod UpdatePrice(ListData As %String) As %Library.String
{
	n (ListData)
	s MethodName=$CLASSNAME()_".UpdatePrice" 
	s AdjDate=+$h							;制单日期
	s Rowid=$p(ListData,"^",1)
	s ResultSp=$p(ListData,"^",2)
	s ResultRp=$p(ListData,"^",3)
	s RtnObj=##class(RtnObj).%New()
	i Rowid=""  q RtnObj.Err(-2,Rowid,MethodName_"调价表id为空","",0)
	;
	s InciId=$p(^INASP(Rowid),"^",4)
	i InciId="" q RtnObj.Err(-3,Rowid,MethodName_"库存项id为空","",0)
	s AdjUomId=$p(^INASP(Rowid),"^",10)
	s BuomId=$p(^INCI(InciId,1),"^",10)
	i BuomId="" q RtnObj.Err(-3,Rowid,MethodName_"物资基本单位为空","",0)
	s HospId=$p(^INASP(Rowid),"^",20)			;医院id
	i AdjUomId=BuomId d
	.s ResultSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(ResultSp,HospId,2)
	.s ResultRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(ResultRp,HospId,2)
	e  d
	.s ResultSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(ResultSp,HospId,1)
	.s ResultRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(ResultRp,HospId,1)
	.
	s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(AdjUomId,BuomId)
	s BResultSp=+ResultSp/ConFac
	s BResultRp=+ResultRp/ConFac
	s BResultSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(BResultSp,HospId,2)
	s BResultRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(BResultRp,HospId,2)
	ts
	;更新调价记录
	&sql(update in_adjsaleprice set inasp_resultsp=:BResultSp,inasp_ctuom_price=:ResultSp,
		INASP_ResultRP=:BResultRp,INASP_CTUOM_Rp=:ResultRp
		where inasp_rowid=:Rowid)
	i SQLCODE'=0 d
	.d RtnObj.Err(-4,Rowid,MethodName_":更新调价单失败")
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

/// Descript:	调价单生效
/// Creater:	zx
/// CreateDate:	2018-06-11
/// Table:		in_adjsaleprice
/// Input:		调价单串，审核信息
/// Return：	
/// w ##class(web.DHCSTMHUI.INAdjSalePrice).SetExe(^templxt(1),^templxt(2))
ClassMethod SetExe(Rows As %String, Params As %String) As %Library.String
{
	n (Rows,Params)
	s ParamsObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d ParamsObj.%FromJSON(Params)
	s gUserId=ParamsObj.%Get("gUserId")
	s gGroupId=ParamsObj.%Get("gGroupId")
	s gLocId=ParamsObj.%Get("gLocId")
	s gHospId=ParamsObj.%Get("gHospId")
	
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Rows)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		q:RowId=""
		s RtnObj=..Exe(RowId,gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId)
		q:RtnObj.success'=0
		
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:调价单生效
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-20
/// Table:in_adjsaleprice
/// Input:调价表id,操作人id
/// Output:		
/// Return：0，成功；
/// -1  ;调价单已审核或已生效
/// -2   ;计划生效日期不能为空
/// -3  ;调价单已经过了计划生效日期，不能再审核
/// -4    ;更新调价单状态失败
/// -5    ;调价单生效失败
ClassMethod Exe(AspId, Params = "") As %Library.String
{
	n (AspId,Params,%session)
	s RtnObj=##class(RtnObj).%New()
	i AspId="" s Sc=RtnObj.Err(-2,"","Id不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	
	s Params=$g(Params)
	i Params="" s Params=..sssParamStr()
	s gGroupId=$p(Params,"^",1)
	s gLocId=$p(Params,"^",2)
	s gUserId=$p(Params,"^",3)  ;生效操作人
	s gHospId=$p(Params,"^",4)
	s ExeDate=+$h
	
	s AspId=+AspId
	s Status=$p(^INASP(AspId),"^",9)
	s incid=$p(^INASP(AspId),"^",4)
	s InciCode=$p(^INCI(incid,1),"^",1)
	i Status'="Audit" s Sc=RtnObj.Err(-3,"",InciCode_"调价单不是已审核未生效状态","",0)
	q:RtnObj.success'=0 RtnObj
	
	s Yes="Yes",Audit="Audit"
	s MethodName=$CLASSNAME()_".Exe" 
	tstart
	;更新调价单状态为已生效 
	&sql(update in_adjsaleprice set inasp_status=:Yes,inasp_executedate=:ExeDate,INASP_StartUser_dr=:gUserId
	where inasp_rowid =:AspId and inasp_status=:Audit)
	i SQLCODE'=0  d
    .d RtnObj.Err(-7,AspId,MethodName_":更新调价单失败"_InciCode)
	i RtnObj.success<0 tro  q RtnObj
	
	s Inci=$p(^INASP(AspId),"^",4)
	s UserId=$p(^INASP(AspId),"^",3)
	s ResultSp=$p(^INASP(AspId),"^",7)
	s AdjNo=$p(^INASP(AspId),"^",5)
	s HospID=$p(^INASP(AspId),"^",20)
	
	s RtnObj=..InsAspDetAfterExe(AspId,gUserId)  ;插入dhc_inasp_detail
	i RtnObj.success<0 tro  q RtnObj
	
	;生成损益
	s:HospID="" HospID=$p(^CTLOC(gLocId),"^",22)
	s batFlag=..sssBatSpFlag(HospID,incid)
	s RtnObj=..InsertAspAmount(AspId) 
	i RtnObj.success<0 tro  q RtnObj
	
	;统一进/售价模式，需要更新批次表进价
	i batFlag=2 d
	.s RtnObj=..UpdateBatRp(AspId)
	i RtnObj.success<0 tro  q RtnObj

	s err=$$AdjINCIPrice^DHCSTMHUITARPRICE(Inci,ExeDate,ResultSp,$g(UserId),AspId,"",HospID)
	i err'=0 d RtnObj.Err(-5,AspId,MethodName_":更新计费价格失败")
	i RtnObj.success<0 tro  q RtnObj
	tcommit
	//调用平台接口上传调价信息
	d ##class(web.DHCSTMHUI.ServiceForSCI).adjRp(Inci)
	job ##class(web.DHCSTMHUI.ServiceForECS).updateHosInv(Inci,HospID)
	q RtnObj
}

/// Decription：依据调价信息更新批次表进价
/// Creator：lxt
/// CreateDate：20230404
ClassMethod UpdateBatRp(RowId)
{
	n (RowId)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".UpdateBatRp" 
	i RowId="" q RtnObj.Err(-8,RowId,MethodName_"入参为空","",0)
		
	s InciId=$p(^INASP(RowId),"^",4)
	s AspdId=$O(^DHCINASPD(0,"INASP",RowId,""),-1)
	i AspdId>0 d
	.s ResultRp=$p(^DHCINASPD(AspdId),"^",11)		;基本单位对应的调后进价
	e  d
	.s ResultRp=$p(^INASP(RowId),"^",16)		;基本单位对应的调后进价

	s BUomId=$p(^INCI(InciId,1),"^",10)
	s PUomId=$p(^INCI(InciId,3),"^",6)
	s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUomId)
	s PResultRp=ResultRp*ConFac
	
	tstart
	s ch=0
	f  s ch=$o(^INCI(InciId,"IB",ch)) q:(ch="")!(RtnObj.success<0)  d
	.s Incib=InciId_"||"_ch
	.s dhcIncib=$o(^DHCINCIB(0,"INCIB",Incib,""))
	.q:dhcIncib=""
	.&sql(update DHC_IncItmBat set INCIB_Rp=:ResultRp,INCIB_RpPuruom=:PResultRp where INCIB_RowID=:dhcIncib)
	.i SQLCODE'=0 d RtnObj.Err(-7,AspId,MethodName_":更新批次进价失败")
	
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

/// Descript:生成调价损益数据
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-20
/// Table:dhc_aspamount
/// Input:调价表id
/// Output:		
/// Return：0，成功；
ClassMethod InsertAspAmount(RowId) As %Library.String
{
	n (RowId)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".InsertAspAmount" 
	i RowId="" q RtnObj.Err(-8,RowId,MethodName_"入参为空","",0)
		
	s CurDate=$p($h,",",1)
	s CurTime=$p($h,",",2)
	s AspNo=$p(^INASP(RowId),"^",5)
	s InciId=$p(^INASP(RowId),"^",4)
	s AdjUserId=$p(^INASP(RowId),"^",3)
	s HospId=$p(^INASP(RowId),"^",20)		;医院id
	s AspdId=$O(^DHCINASPD(0,"INASP",RowId,""),-1)
	i AspdId>0 d
	.s PriorSp=$p(^DHCINASPD(AspdId),"^",8)			;基本单位对应的价格
	.s ResultSp=$p(^DHCINASPD(AspdId),"^",9)		;基本单位对应的价格
	.s PriorRp=$p(^DHCINASPD(AspdId),"^",10)		;基本单位对应的调前进价
	.s ResultRp=$p(^DHCINASPD(AspdId),"^",11)		;基本单位对应的调后进价
	e  d
	.s PriorSp=$p(^INASP(RowId),"^",6)			;基本单位对应的价格
	.s ResultSp=$p(^INASP(RowId),"^",7)			;基本单位对应的价格
	.s PriorRp=$p(^INASP(RowId),"^",15)			;基本单位对应的调前进价
	.s ResultRp=$p(^INASP(RowId),"^",16)		;基本单位对应的调后进价
	s DiffSp=ResultSp-PriorSp
	s DiffRp=ResultRp-PriorRp
	
	s BatSpFlag=..sssBatSpFlag(HospId,InciId)
	i BatSpFlag=0 s DiffRp=0
	q:BatSpFlag=1 RtnObj		//1-走批次售价，不再生成售价的损益防止调价损益生成2次
	q:(BatSpFlag=0)&&(DiffSp=0) RtnObj	//0-统一售价：进价不再生成损益
	q:(BatSpFlag=2)&&(DiffSp=0)&&(DiffRp=0) RtnObj	//2-统一进/售价：进价售价都生成进价损益
	
	tstart
	s ch=0
	f  s ch=$o(^INCI(InciId,"IL",ch))  q:(ch="")!(RtnObj.success<0)  d
	.s LocId=$p($g(^INCI(InciId,"IL",ch)),"^",1)
	.q:LocId=""
	.s TmpHospId=$P($g(^CTLOC(+LocId)),"^",22)
	.q:(HospId'="")&(TmpHospId'=HospId)
	.s Qty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(InciId,LocId,+$h)  ;  get the qty in DHC_LocDailyTotal
	.q:+Qty=0
	.s SpAmt=(+Qty)*DiffSp
	.s RpAmt=(+Qty)*DiffRp
	.S SpAmt=+##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
	.S RpAmt=+##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
	.s trid="",type="KC"
	.s trid=##class(web.DHCSTMHUI.Common.AspAmount).getLastINCLocTrans(LocId,InciId)
	.&sql(insert into dhc_aspamount(aspa_no,aspa_ctloc_dr,aspa_adjprice,aspa_inasp_dr,
		aspa_inci_dr,aspa_stkqty,aspa_amount,aspa_date,aspa_time,aspa_ssusr_dr,ASPA_AdjRP,ASPA_RPAmt,ASPA_ASPTran_Dr,ASPA_TranType)
		values(:AspNo,:LocId,:DiffSp,:RowId,:InciId,:Qty,:SpAmt,:CurDate,:CurTime,:AdjUserId,:DiffRp,:RpAmt,:trid,:type))
	.i SQLCODE'=0  d RtnObj.Err(-9,RowId,MethodName_":生成调价损益数据失败,SQLCODE:"_SQLCODE)
	.i RtnObj.success<0  q
	.s AspaId=$p(%ROWID,$c(1))
	.s RtnObj=..InserAspAmtLB(AspaId)
	.i RtnObj.success<0 q
	i RtnObj.success<0 tro  q RtnObj
	
	tcommit
	q RtnObj
}

/// Descript:保存批次损益数据
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-20
/// Table:dhc_aspamountlb
/// Input:损益表（dhc_aspamount）id
/// Output:		
/// Return：0，成功；其它：失败
/// 只在InsertAspAmount中调用，不能单独运行（单独运行需加事务处理）
ClassMethod InserAspAmtLB(Aspa) As %Library.String
{
	n (Aspa)
	s MethodName=$CLASSNAME()_".jsCancelComplete"
	s RtnObj=##class(RtnObj).%New()
	i Aspa="" q RtnObj.Err(-10,"",MethodName_":入参为空","",0)
	s Aspa=+Aspa
	s Inci=$p(^ASPA(Aspa),"^",1)
	s Loc=$p(^ASPA(Aspa),"^",2)
	s DiffSp=$p(^ASPA(Aspa),"^",3)  	;基本单位差价（售价）
	s DiffRp=$p(^ASPA(Aspa),"^",11)  	;基本单位差价（进价）
	s AspId=$p(^ASPA(Aspa),"^",10)
	i AspId="" q RtnObj.Err(-11,Aspa,MethodName_":损益表对应调价单为空","",0)
	S ExeDate=$P(^INASP(AspId),"^",2)    ;生效日期
	S HospId=$P(^INASP(AspId),"^",20)
	s PrioRp=$P(^INASP(AspId),"^",15)    ;调前进价
	s ch=$o(^INCI("IL_LOC",Loc,Inci,0)) 
	i ch="" q RtnObj.Err(-11,Aspa,MethodName_":没有对应库存批次","",0)
	
	s lbch=0
	f  s lbch=$o(^INCI(Inci,"IL",ch,"LB",lbch)) q:(lbch="")!(RtnObj.success<0)  d
	.s Inclb=Inci_"||"_ch_"||"_lbch
	.s InclbQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(Inclb,+$h)
	.s SpAmt=DiffSp*InclbQty
	.s RpAmt=DiffRp*InclbQty
	.S SpAmt=+##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
	.S RpAmt=+##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
	.s AspalbCh=1+$o(^ASPA(Aspa,"LB",""),-1)
	.&sql(insert into Dhc_AspAmountLB (aspalb_aspa_parref,aspalb_childsub,aspalb_inclb_dr,
		aspalb_qty,aspalb_adjdiff,aspalb_adjamt,ASPALB_AdjRP,ASPALB_RPAmt,ASPALB_PriorRP)
		values(:Aspa,:AspalbCh,:Inclb,:InclbQty,:DiffSp,:SpAmt,:DiffRp,:RpAmt,:PrioRp) )
	.i SQLCODE'=0 d RtnObj.Err(-12,Aspa,MethodName_":生成调价损益数据失败,SQLCODE:"_SQLCODE)
	
	q RtnObj
}

/// Descript:生效以后的处理dhc_inasp_detail
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-21
/// Table:dhc_inasp_detail
/// Input:调价表id，操作人id
/// Output:		
/// Return：dhc_inasp_detail表rowid
ClassMethod InsAspDetAfterExe(AspId, UserId = "") As %Library.String
{
	n (AspId,UserId)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".InsAspDetAfterExe" 
	s ResultSpUom=$p(^INASP(AspId),"^",11)
	s UomId=$p(^INASP(AspId),"^",10)
	s ResultSp=$p(^INASP(AspId),"^",7)
	s Date=+$h  ; execute date
	s Time=$p($h,",",2)

	s PriorSp= $p(^INASP(AspId),"^",6)        //调整前售价(基本单位)
	s Inci= $p(^INASP(AspId),"^",4) 
	s BuomId=$p(^INCI(Inci,1),"^",10)
	s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BuomId)
	s PriorSpUom=PriorSp*ConFac  //调整前售价(调价单位)
	s PriorRp=$p(^INASP(AspId),"^",15) 
	s PriorRpUom=PriorRp*ConFac
	s ResultRp=$p(^INASP(AspId),"^",16) 
	s ResultRpUom=$p(^INASP(AspId),"^",14) 

	s AspdId=$O(^DHCINASPD(0,"INASP",AspId,""),-1)
	i AspdId>0 d //若属于多次调价
	.s PriorSp=$p($G(^DHCINASPD(AspdId)),"^",9)  //取上次的"调后售价"做本次"调前售价"
	.s PriorSpUom=$p($G(^DHCINASPD(AspdId)),"^",6)
	.s PriorRp=$p($g(^DHCINASPD(AspdId)),"^",11) //取上次的"调后进价"做本次"调前进价"
	.s PriorRpUom=$p($g(^DHCINASPD(AspdId)),"^",13) 
	.
	&sql(insert into dhc_inasp_detail(ASPD_Date,ASPD_Time,ASPD_SSUSR_DR,ASPD_ResultSP_Uom,
		ASPD_AdjUom_DR,ASPD_ResultSP,ASPD_INASP_DR,
		ASPD_PriorSP,ASPD_PriorSP_Uom,
		ASPD_PriorRP,ASPD_ResultRP,
		ASPD_PriorRP_Uom,ASPD_ResultRP_Uom)
		values(:Date,:Time,:UserId,:ResultSpUom,:UomId,:ResultSp,:AspId,
		:PriorSp,:PriorSpUom,:PriorRp,:ResultRp,:PriorRpUom,:ResultRpUom))
	i SQLCODE'=0 d RtnObj.Err(-5,AspId,MethodName_":调价单生效记录表插入失败")
	q RtnObj
}

/// Creator:    zx
/// CreateDate: 2018-06-11
/// Table:in_adjsaleprice
/// Input:调价单串，审核信息
/// Output:     
/// Return：obj
/// w ##class(web.DHCSTMHUI.INAdjSalePrice).CancelAudit(
ClassMethod SetCancelAudit(Rows As %String, Params As %String) As %Library.String
{
	n (Rows, Params)
	s ParamsObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d ParamsObj.%FromJSON(Params)
	s AuditUserId=ParamsObj.%Get("gUserId")
	
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Rows)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		q:RowId=""
		
		s RtnObj=..CancelAudit(RowId,AuditUserId)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:调价单取消审核
/// Creator:    wangjiabin
/// CreateDate: 2013-07-24
/// Table:in_adjsaleprice
/// Input:调价表id,操作人id
/// Output:     
/// Return：0，成功；
/// -1  ;调价单不是已审核状态
/// -2    ;更新调价单状态失败
ClassMethod CancelAudit(AspId, AuditUserId) As %Library.String
{
	n (AspId,AuditUserId)
	s RtnObj=##class(RtnObj).%New()
	i AspId="" s Sc=RtnObj.Err(-2,"","Id不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	;
	s AspId=+AspId
	s Status=$p(^INASP(AspId),"^",9)
	i Status'="Audit" s Sc=RtnObj.Err(-3,"","调价单不是已审核状态 !","",0)
	q:RtnObj.success'=0 RtnObj

	s LockName="ASPITM"_AspId
	i ..sssLock(LockName)<0  s Sc=RtnObj.Err(-4,"","调价单加锁失败 !","",0)
	q:RtnObj.success'=0 RtnObj

	s AuditFlag="No"
	
	tstart
	;更新调价单状态为未审核
	&sql(update in_adjsaleprice set inasp_status=:AuditFlag,INASP_AuditUser=null,INASP_AuditDate=null,INASP_Audittime=null
		where inasp_rowid=:AspId)
	i SQLCODE'=0 d RtnObj.Err(-5,AspId,"更新调价单状态失败","{RowId:"_AspId_"}")
	i RtnObj.success<0 d ..sssUnLock(LockName) tro  q RtnObj

	tcommit
	d ..sssUnLock(LockName)
	q RtnObj
}

/// Descript:	审核调价单
/// Creater:	zx
/// CreateDate:	2018-06-11
/// Table:		in_adjsaleprice
/// Input:		调价单串，审核信息
/// Return：	
/// w ##class(web.DHCSTMHUI.INAdjSalePrice).Audit("[{""RowId"":""1017""}]","{""StartDate"":""2018-07-16"",""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""97"",""gHospId"":""2"",""ScgId"":"""",""EndDate"":""2018-07-16"",""Status"":""No"",""AdjspNo"":"""",""InciDesc"":""""}")
ClassMethod SetAudit(Rows As %String, Params As %String) As %Library.String
{
	n (Rows,Params)
	s ParamsObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d ParamsObj.%FromJSON(Params)
	s AuditUserId=ParamsObj.%Get("gUserId")
	
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Rows)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		q:RowId=""
		
		s RtnObj=..Audit(RowId,AuditUserId)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:调价单审核
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-20
/// Table:in_adjsaleprice
/// Input:调价表id,操作人id
/// Output:		
/// Return：0，成功；
/// -1  ;调价单已审核或已生效
/// -2  ;计划生效日期不能为空
/// -3  ;调价单已经过了计划生效日期，不能再审核
/// -4  ;更新调价单状态失败
/// -5  ;调价单生效失败
ClassMethod jsAudit(AspId, AuditUserId) As %Library.String
{
	n (AspId,AuditUserId)
	s $ZT=..sssError()
	ts
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Audit(AspId,AuditUserId)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

ClassMethod Audit(AspId, AuditUserId) As %Library.String
{
	n (AspId,AuditUserId)
	
	s RtnObj=##class(RtnObj).%New()
	i AspId="" s Sc=RtnObj.Err(-2,"","Id不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	
	s AspId=+AspId
	s Status=$p(^INASP(AspId),"^",9)
	s incid=$p(^INASP(AspId),"^",4)
	s InciCode=$p(^INCI(incid,1),"^",1)
	i Status'="No" s Sc=RtnObj.Err(-3,"",InciCode_"调价单已审核或已生效","",0)
	q:RtnObj.success'=0 RtnObj
	
	s PreexeDate=$p(^INASP(AspId),"^",17)
	i PreexeDate="" s Sc=RtnObj.Err(-4,"",InciCode_"计划生效日期不能为空","",0)
	q:RtnObj.success'=0 RtnObj
	
	i PreexeDate<+$h s Sc=RtnObj.Err(-5,"",InciCode_"调价单已经过了计划生效日期,不能再审核","",0)
	q:RtnObj.success'=0 RtnObj

	s LockName="ASPITM"_AspId
	i ..sssLock(LockName)<0 s Sc=RtnObj.Err(-6,"",InciCode_"调价单加锁失败!")
	q:RtnObj.success'=0 RtnObj
	s AuditFlag="Audit"
	;
	;更新调价单状态为已审核
	s AuditDate=+$h
	s AuditTime=$p($h,",",2)
	&sql(update in_adjsaleprice set inasp_status=:AuditFlag,INASP_AuditUser=:AuditUserId,INASP_AuditDate=:AuditDate,INASP_Audittime=:AuditTime
	where inasp_rowid=:AspId)
	s err=SQLCODE
	i err'=0 d
	.d RtnObj.Err(-7,AspId,InciCode_"更新调价单状态失败","{RowId:"_AspId_"}")
	i err'=0   d ..sssUnLock(LockName)
	q:RtnObj.success'=0 RtnObj
	
	i PreexeDate=+$h d    ;计划生效日期为today时,自动生效。
	.s Params="^^"_AuditUserId		;安全组id,科室id未传入
	.s RtnObj=..Exe(AspId,Params)
	i RtnObj.success'=0 d ..sssUnLock(LockName) q RtnObj
	
	d ..sssUnLock(LockName)
	q RtnObj
}

/// Descript:	根据单号查询调价单信息
/// Creater:	zx
/// CreateDate:	2018-06-11
/// Table:		in_adjsaleprice
/// Input:		查询条件
/// Return：	调价单信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INAdjSalePrice","QueryDetail","MASP20180611001","{""StartDate"":""2018-06-11"",""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""97"",""gHospId"":""2"",""ScgId"":"""",""EndDate"":""2018-06-11"",""Status"":"""",""ExcludeNew"":""Y"",""AdjspNo"":"""",""InciDesc"":""""}")
Query QueryDetail(AspNo As %String, Params As %String(MAXLEN=500), AspIdStr As %String = "") As Query(ROWSPEC = "RowId,AspNo,Status,AdjDate,ExecuteDate,AdjUserName,InciId,InciCode,InciDesc,StkCatDesc,AspUomId,AspUomDesc,PriorSpUom:%Float,ResultSpUom:%Float,DiffSpUom,PriorRpUom:%Float,ResultRpUom:%Float,DiffRpUom,WarrentNo,Remark,AuditUserName,MarkTypeDesc,MaxSp:%Float,PreExecuteDate,BUomId,PurUomId,ConFacPur:%Float,InvNo,InvDate,AdjReasonId,AdjReason,ExeUserName,Spec,HospDesc,printTime") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, AspNo As %String, Params As %String(MAXLEN=500), AspIdStr As %String = "") As %Status
{
	n (qHandle,AspNo,Params,AspIdStr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:AspNo="" ""
	s AspNo=$$ALPHAUP^SSUTIL4(AspNo)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s pStartDate=PJObj.%Get("StartDate")		//开始日期
	s pEndDate=PJObj.%Get("EndDate")		//截止日期
	s pStkScgId=PJObj.%Get("ScgId")		//类组
	s pInciId=PJObj.%Get("Inci")		//物资
	s pAdjspNo=PJObj.%Get("AdjspNo")		//单号
	s:pAdjspNo'="" pAdjspNo=$$ALPHAUP^SSUTIL4(pAdjspNo)
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	s pStatus=PJObj.%Get("Status")
	s excludeFirst=PJObj.%Get("ExcludeNew")
	s pInciDesc=PJObj.%Get("InciDesc")
	s AdjSPCat=PJObj.%Get("AdjSPCat")
	s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s:pEndDate'="" pEndDate=..DH2L(pEndDate)
	
	s type=..sssCode()
	s pHospId=..sssHospId(gLocId)
	s:pHospId="" pHospId=gHospId
	s pStkScgId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(gUserId,type,gLocId,pStkScgId,pHospId)

	s AspId=""
	f  s AspId=$o(^INASP(0,"ASPNO",AspNo,AspId))  q:AspId=""  d
	.q:(AspIdStr'="")&&(("^"_AspIdStr_"^")'[("^"_AspId_"^"))
	.s Status=$p(^INASP(AspId),"^",9)
	.q:(pStatus'="")&(Status'=pStatus)
	.s AdjDate=$p(^INASP(AspId),"^",1)  
	.s ExecuteDate=$p(^INASP(AspId),"^",2)
	.s AdjUserId=$p(^INASP(AspId),"^",3)
	.s InciId=$p(^INASP(AspId),"^",4)
	.q:InciId=""
	.q:(pInciId'="")&(InciId'=pInciId)
	.s tmpAdjSPCat=$p(^INASP(AspId),"^",32)
	.q:(AdjSPCat=1)&&(tmpAdjSPCat'="手动调价")
	.q:(AdjSPCat=2)&&(tmpAdjSPCat'="自动调价")
	.s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	.s TmpStkGrpId=$p(StkGrpInfo,"^",5)
	.;q:(StkGrpId'="")&(TmpStkGrpId'=StkGrpId)
	.q:(pStkScgId'="")&&(("^"_pStkScgId_"^")'[("^"_TmpStkGrpId_"^"))
	.s PriorSp=$p(^INASP(AspId),"^",6)      ;基本单位对应的价格
	.s ResultSp=$p(^INASP(AspId),"^",7)		;基本单位对应的价格
	.s StkCatId=$p(^INCI(InciId,2),"^",2)
	.s AspUomId=$p(^INASP(AspId),"^",10)
	.s ResultSpUom=$p(^INASP(AspId),"^",11)   ;调价单位对应的调后售价
	.s ResultRpUom=$p(^INASP(AspId),"^",14)       ;调价单位对应的调后进价
	.s WarrentNo=$p(^INASP(AspId),"^",12)    ;物价文件号
	.s WnoDate=$p(^INASP(AspId),"^",22)   		;物价文件备案日期
	.s Remark=$p(^INASP(AspId),"^",13)      ;目前存调价原因
	.s PriorRp=$p(^INASP(AspId),"^",15)     ;基本单位对应的调前进价
	.s ResultRp=$p(^INASP(AspId),"^",16)	;基本单位对应的调后进价
	.s PreExecuteDate=$p(^INASP(AspId),"^",17)  ;计划生效日期
	.s HospId=$p(^INASP(AspId),"^",20)			;医院id
	.s HospDesc=$p(^CT("HOSP",HospId),"^",2)
	.s AuditUserId=$p(^INASP(AspId),"^",21)   ;审核人
	.s ExeUserid=$p(^INASP(AspId),"^",30)       ;生效人
	.
	.s:AdjDate'="" AdjDate=..DL2H(AdjDate)
	.s:ExecuteDate'="" ExecuteDate=..DL2H(ExecuteDate)
	.s AdjUserName=""
	.s:AdjUserId'="" AdjUserName=..sssUserName(AdjUserId)
	.s InciCode=$p(^INCI(InciId,1),"^",1)
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.s Specdesc=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
	.;w Specdesc,!
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.s PurUomId=$p(^INCI(InciId,3),"^",6)
	.s StkCatDesc="",AspUomDesc=""
	.s:StkCatId'="" StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
	.s:AspUomId'="" AspUomDesc=$p(^CT("UOM",AspUomId),"^",2)
	.s:WnoDate'="" WnoDate=..DL2H(WnoDate)
	.s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(AspUomId,BUomId)
	.s PriorRpUom=PriorRp*ConFac
	.s PriorSpUom=PriorSp*ConFac
	.i AspUomId=BUomId d
	..s PriorSpUom=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(PriorSpUom,HospId,2)
	..s PriorRpUom=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(PriorRpUom,HospId,2)
	.e  d
	..s PriorSpUom=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(PriorSpUom,HospId,1)
	..s PriorRpUom=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(PriorRpUom,HospId,1)
	.s (AuditUserName,ExeUserName)=""
	.s:PreExecuteDate'="" PreExecuteDate=..DL2H(PreExecuteDate)
	.s:AuditUserId'="" AuditUserName=..sssUserName(AuditUserId)
	.s:ExeUserid'="" ExeUserName=..sssUserName(ExeUserid)
	.s DiffSpUom=ResultSpUom-PriorSpUom
	.s DiffRpUom=ResultRpUom-PriorRpUom
	.
	.s InfoId=$o(^DHCITMINFO(0,"INCI",InciId,0))
	.s (MarkTypeDesc,MaxSp)=""
	.i InfoId'=""  d
	..s MarkTypeId=$p(^DHCITMINFO(InfoId),"^",15)
	..s:MarkTypeId'="" MarkTypeDesc=$p(^DHCINMT(MarkTypeId),"^",2)
	..;s PriceFileNo=$p(^DHCITMINFO(InfoId),"^",33)
	..s MaxSp=$p(^DHCITMINFO(InfoId),"^",16)
	.s ConFacPur=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	.s InvNo=$p(^INASP(AspId),"^",18) 
	.s InvDate=$p(^INASP(AspId),"^",19)
	.s AdjReason=""
	.s AdjReasonId=$p(^INASP(AspId),"^",28)
	.s:AdjReasonId'="" AdjReason=$p(^DHCSTREASON("ASP",AdjReasonId),"^",2) 
	.s:Status="No" Status="未审核"
	.s:Status="Audit" Status="已审核未生效"
	.s:Status="Yes" Status="已生效"
	.s printTime=..DL2H(+$H)
	.
	.d OutPutRowByAspNo
	Quit $$$OK
OutPutRowByAspNo
	s Data=$lb(AspId,AspNo,Status,AdjDate,ExecuteDate,AdjUserName,InciId,InciCode,InciDesc,StkCatDesc,AspUomId,AspUomDesc,PriorSpUom,ResultSpUom,DiffSpUom,PriorRpUom,ResultRpUom,DiffRpUom,WarrentNo,Remark,AuditUserName,MarkTypeDesc,MaxSp,PreExecuteDate,BUomId,PurUomId,ConFacPur,InvNo,InvDate,AdjReasonId,AdjReason,ExeUserName,Specdesc,HospDesc,printTime)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	查询调价单信息
/// Creater:	zx
/// CreateDate:	2018-06-11
/// Table:		in_adjsaleprice
/// Input:		查询条件
/// Return：	调价单信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INAdjSalePrice","QueryAdjSpNo",^zx(2))
Query QueryAdjSpNo(Params As %String) As Query(ROWSPEC = "AspNo,AspDate,AspUser,AspIdStr") [ SqlProc ]
{
}

ClassMethod QueryAdjSpNoExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	;s ^zx(2)=Params
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s pStartDate=PJObj.%Get("StartDate")		//开始日期
	s pEndDate=PJObj.%Get("EndDate")		//截止日期
	s pStkScgId=PJObj.%Get("ScgId")		//类组
	s pInciId=PJObj.%Get("Inci")		//物资
	s pAdjspNo=PJObj.%Get("AdjspNo")		//单号
	s:pAdjspNo'="" pAdjspNo=$$ALPHAUP^SSUTIL4(pAdjspNo)
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	s pStatus=PJObj.%Get("Status")
	s excludeFirst=PJObj.%Get("ExcludeNew")
	s pInciDesc=PJObj.%Get("InciDesc")
	s AdjSPCat=PJObj.%Get("AdjSPCat")
	s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s:pEndDate'="" pEndDate=..DH2L(pEndDate)
	
	s type=..sssCode()
	s pHospId=..sssHospId(gLocId)
	s:pHospId="" pHospId=gHospId
	s pStkScgId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(gUserId,type,gLocId,pStkScgId,pHospId)
	s Pid=..NewPid()
	
	s TmpStatus=0
	f  s TmpStatus=$o(^INASP(0,"DATESTATUS",TmpStatus)) q:TmpStatus=""  d
	.q:(pStatus'="")&(TmpStatus'=pStatus)
	.f Date=pStartDate:1:pEndDate  d
	..s AspId=""
	..f  s AspId=$o(^INASP(0,"DATESTATUS",TmpStatus,Date,AspId))  q:AspId=""  d
	...q:'$d(^INASP(AspId))
	...s HospId=$p(^INASP(AspId),"^",20) ;医院id
	...q:(gHospId'="")&(HospId'=gHospId)
	...s InciId=$p(^INASP(AspId),"^",4)
	...q:InciId=""
	...q:(pInciId'="")&(InciId'=pInciId)
	...s InciDesc=$p(^INCI(InciId,1),"^",2)
	...q:(pInciDesc'="")&(InciDesc'[pInciDesc)
	...s tmpAdjSPCat=$p(^INASP(AspId),"^",32)
	...q:(AdjSPCat=1)&&(tmpAdjSPCat'="手动调价")
	...q:(AdjSPCat=2)&&(tmpAdjSPCat'="自动调价")
	...s TmpAspNo=$p(^INASP(AspId),"^",5)
	...q:(pAdjspNo'="")&(TmpAspNo'=pAdjspNo)
	...s firstDate=$o(^INASP(0,"INCI",InciId,""))
	...q:(excludeFirst="Y")&&(Date=firstDate)		;排除初次调价	
	...s TmpGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	...s StkType=$p(TmpGrpInfo,"^",3)
	...q:StkType'=..sssCode()
	...s TmpStkGrpId=$p(TmpGrpInfo,"^",5)
	...q:(pStkScgId'="")&&(("^"_pStkScgId_"^")'[("^"_TmpStkGrpId_"^"))
	...s AdjDate=$p(^INASP(AspId),"^",1)  
	...s AdjUserId=$p(^INASP(AspId),"^",3)
	...s HospId=$p(^INASP(AspId),"^",20)			;医院id
	...s AuditUserId=$p(^INASP(AspId),"^",21)
	...s AdjDate=..DL2H(AdjDate)
	...s AdjUserName="",AuditUserName=""
	...s:AdjUserId'="" AdjUserName=..sssUserName(AdjUserId)
	...s:AuditUserId'="" AuditUserName=..sssUserName(AuditUserId)
	...i '$d(^TMPASP(Pid,"ASP",TmpAspNo))  d
	....s ^TMPASP(Pid,"ASP",TmpAspNo)=AdjDate_"^"_AdjUserName_"^"_AspId
	...e  d
	....s $p(^TMPASP(Pid,"ASP",TmpAspNo),"^",3)=$p(^TMPASP(Pid,"ASP",TmpAspNo),"^",3)_","_AspId
	....s TmpAdjDate=$p(^TMPASP(Pid,"ASP",TmpAspNo),"^",1)
	....;最后一次更新人和更新日期
	....i AdjDate>TmpAdjDate  d
	.....s $p(^TMPASP(Pid,"ASP",TmpAspNo),"^",1)=AdjDate
	.....s $p(^TMPASP(Pid,"ASP",TmpAspNo),"^",2)=AdjUserName
	s Num=0
	s AspNo=""
	f  s AspNo=$o(^TMPASP(Pid,"ASP",AspNo)) q:AspNo=""  d
	.s DataList=^TMPASP(Pid,"ASP",AspNo)
	.s AdjDate=$p(DataList,"^",1)
	.s AdjUserName=$p(DataList,"^",2)
	.s AspIdStr=$p(DataList,"^",3)
	.d OutPut

	k ^TMPASP(Pid,"ASP") 
	Quit $$$OK
OutPut
	s Data=$lb(AspNo,AdjDate,AdjUserName,AspIdStr)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	检查是否存在某库存项对应的未生效的调价单
/// Creater:	ZhangDongmei
/// CreateDate:	2012-02-06
/// Table:in_adjsaleprice
/// Input:库存项id
/// Output:		
/// Return：1：存在；0：不存在
ClassMethod CheckItmAdjSp(Inci As %String, HospId As %String) As %Library.String
{
	n (Inci,HospId)
	q:Inci="" 0 
	s Flag=0
	
	s AspId=""
	i HospId'="" d
	.s ExeDate=$o(^INASP(0,"HOSPI",HospId,Inci,""),-1)
	.q:ExeDate=""
	.s AspId=$o(^INASP(0,"HOSPI",HospId,Inci,ExeDate,""),-1)
	
	i AspId="" d
	.s ExeDate=$o(^INASP(0,"INCI",Inci,""),-1)
	.q:ExeDate=""
	.s AspId=$o(^INASP(0,"INCI",Inci,ExeDate,""),-1)
	
	q:AspId="" Flag
	s Status=$p(^INASP(AspId),"^",9)
	s:Status'="Yes" Flag=1
	q Flag
}

/// Descript:   检查是否存在某库存项对应的当天调价记录
/// Creater:    wangjiabin
/// CreateDate: 2013-06-25
/// Table:in_adjsaleprice
/// Input:库存项id
/// Output:     
/// Return：1：存在；0：不存在
ClassMethod CheckItmAspToday(Inci As %String, HospId As %String) As %Library.String
{
	n (Inci,HospId)
	q:Inci="" 0
	s Flag=0
	
	s ExeDate=+$h+1
	i HospId'="" d
	.f  s ExeDate=$o(^INASP(0,"HOSPI",HospId,Inci,ExeDate),-1) q:ExeDate=""  d
	..i ExeDate=+$h d
	...s Flag=1
	e  d
	.f  s ExeDate=$o(^INASP(0,"INCI",Inci,ExeDate),-1) q:ExeDate=""  d
	..i ExeDate=+$h d
	...s Flag=1
	
	q Flag
}

/// Descript:	保存调价单
/// Creater:	zx
/// CreateDate:	2018-06-7
/// Table:		IN_AdjSalePrice
/// Input:		主单信息，明细信息
/// Return：	成功，失败
/// w ##class(web.DHCSTMHUI.INAdjSalePrice).Save("{""StartDate"":""2018-07-20"",""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""97"",""gHospId"":""2"",""ScgId"":"""",""EndDate"":""2018-07-20"",""InciDesc"":"""",""AdjspNo"":""""}","")
ClassMethod Save(Main As %String, Detail As %String) As %Library.String
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()
	s $ZT=..sssError()
	s RtnObj=..Update(Main,Detail)
	i RtnObj.success<0 q RtnObj.Json()
	q RtnObj.Json()
}

ClassMethod Update(Main, Detail) As RtnObj
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()
	
	ts
	s AppName=..%GetParameter("AppName")
	s MainObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d MainObj.%FromJSON(Main)
	s AdjspNo=MainObj.%Get("AdjspNo")
	s GrpId=MainObj.%Get("ScgId")
	s LocId=MainObj.%Get("gLocId")
	s gUserId=MainObj.%Get("gUserId")
	s gHospId=MainObj.%Get("gHospId")
	i AdjspNo=""  d
	.s AdjspNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,GrpId,LocId)
	.i +AdjspNo<0 d RtnObj.Err(-1,"","生成单号失败!")
	q:RtnObj.success'=0 RtnObj
	
	i Detail="" d RtnObj.Err(-3,"","缺少明细数据！","",0)
	q:RtnObj.success'=0 RtnObj
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d RtnObj.Err(-2,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s RowIdStr=""
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Inci=Obj.%Get("Inci")
		i +Inci=0 d RtnObj.Err(-3,"","缺少明细数据！","",0)
		q:RtnObj.success'=0 

		s AdjUomId=Obj.%Get("AspUomId")
		s ResultSp=Obj.%Get("ResultSpUom")
		s ResultRp=Obj.%Get("ResultRpUom")
		s AdjReasonId=Obj.%Get("AdjReasonId")
		s HospId=gHospId
		s AdjUserId=gUserId
		s WarrentNo=Obj.%Get("WarrentNo")
		s WnoDate=Obj.%Get("WnoDate")
		s:WnoDate'="" WnoDate=..DH2L(WnoDate)
		s Remark=Obj.%Get("Remark")
		s InvoNo=Obj.%Get("InvNo")
		s InvoDate=Obj.%Get("InvDate")
		s InciDesc=Obj.%Get("Description")
		s:InciDesc="" InciDesc=$p(^INCI(Inci,1),"^",2)
		s PreExecuteDate=Obj.%Get("PreExecuteDate")
		s PreExecuteDate=..DH2L(PreExecuteDate)
		s StkCatId=$p(^INCI(Inci,2),"^",2)
		s AdjSPCat=Obj.%Get("AdjSPCat")
		
		i RowId="" d
		.s Status="No"
		.s Flag=..CheckItmAdjSp(Inci,HospId)
		.i Flag=1 d RtnObj.Err(-4,"",InciDesc_"存在未生效的调价单！","",0)
		.q:RtnObj.success'=0		
		.s AdjDate=+$h ;制单日期
		.s AdjTime=$p($h,",",2)
		.s ExecuteDate=..DH2L("9999-12-31")
		.s:PreExecuteDate="" PreExecuteDate=AdjDate+1
		.s PriorSp=Obj.%Get("PriorSpUom")
		.s PriorRp=Obj.%Get("PriorRpUom")
		.s BuomId=$p(^INCI(Inci,1),"^",10)
		.s:BuomId="" Sc=RtnObj.Err(-6,"",InciDesc_"没有基本单位！","",0)
		.q:RtnObj.success'=0 
		.
		.s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(AdjUomId,BuomId)
		.i AdjUomId=BuomId d
		..s PriorSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(PriorSp,HospId,2)
		..s ResultSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(ResultSp,HospId,2)
		..s PriorRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(PriorRp,HospId,2)
		..s ResultRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(ResultRp,HospId,2)
		.e  d
		..s PriorSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(PriorSp,HospId,1)
		..s ResultSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(ResultSp,HospId,1)
		..s PriorRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(PriorRp,HospId,1)
		..s ResultRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(ResultRp,HospId,1)
		.s BResultSp=+ResultSp/ConFac
		.s BResultRp=+ResultRp/ConFac
		.s BPriorSp=PriorSp/ConFac
		.s BPriorRp=PriorRp/ConFac
		.s BResultSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(BResultSp,HospId,2)
		.s BResultRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(BResultRp,HospId,2)
		.s BPriorSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(BPriorSp,HospId,2)
		.s BPriorRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(BPriorRp,HospId,2)
		.
		.&sql(insert into in_adjsaleprice(inasp_date,inasp_inci_dr,inasp_incsc_dr,inasp_priorsp,
			inasp_resultsp,inasp_ssusr_dr,inasp_status,inasp_no,INASP_ExecuteDate,inasp_ctuom_dr,inasp_ctuom_price,
			INASP_PriorRP,INASP_ResultRP,INASP_CTUOM_Rp,INASP_Hospital_Dr,INASP_WarrentNO,INASP_WNODate,
			INASP_PreExeDate,INASP_Remark,INASP_INVOICE,INASP_INVODATE,INASP_REASON_DR,INASP_Time,INASP_Cat) 
			values(:AdjDate,:Inci,:StkCatId,:BPriorSp,:BResultSp,:AdjUserId,:Status,:AdjspNo,:ExecuteDate,
			:AdjUomId,:ResultSp,:BPriorRp,:BResultRp,:ResultRp,:HospId,:WarrentNo,:WnoDate,:PreExecuteDate,
			:Remark,:InvoNo,:InvoDate,:AdjReasonId,:AdjTime,:AdjSPCat) )
		.i SQLCODE'=0  d RtnObj.Err(-7,"",InciDesc_"插入调价表失败!")
		.i RtnObj.success'=0  q
		.s RowId=$p(%ROWID,$c(1))
		.i RowIdStr="" d
		..s RowIdStr=RowId
		.e  d
		..s RowIdStr=RowIdStr_","_RowId
		e  d
		.s Status=$p(^INASP(RowId),"^",9)
		.i Status'="No" s Sc=RtnObj.Err(-8,"",InciDesc_"调价表不能修改!","",0)  ;调价单已审核或已生效，不能修改
		.i RtnObj.success'=0  q
		.s AdjDate=+$h ;制单日期
		.s AdjTime=$p($h,",",2)
		.s PriorSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inci,+$h,AdjUomId,HospId)
		.s PriorRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(Inci,+$h,AdjUomId,HospId)
		.s BuomId=$p(^INCI(Inci,1),"^",10)
		.i BuomId="" d RtnObj.Err(-6,"",InciDesc_"没有基本单位！","",0)
		.q:RtnObj.success'=0 
		.s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(AdjUomId,BuomId)
		.i AdjUomId=BuomId d
		..s PriorSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(PriorSp,HospId,2)
		..s ResultSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(ResultSp,HospId,2)
		..s PriorRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(PriorRp,HospId,2)
		..s ResultRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(ResultRp,HospId,2)
		.e  d
		..s PriorSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(PriorSp,HospId,1)
		..s ResultSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(ResultSp,HospId,1)
		..s PriorRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(PriorRp,HospId,1)
		..s ResultRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(ResultRp,HospId,1)
		.s BResultSp=+ResultSp/ConFac
		.s BResultRp=+ResultRp/ConFac
		.s BPriorSp=PriorSp/ConFac
		.s BPriorRp=PriorRp/ConFac
		.s BResultSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(BResultSp,HospId,2)
		.s BResultRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(BResultRp,HospId,2)
		.s BPriorSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(BPriorSp,HospId,2)
		.s BPriorRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(BPriorRp,HospId,2)
		.
		.&sql(update in_adjsaleprice set inasp_date=:AdjDate,inasp_priorsp=:BPriorSp,inasp_resultsp=:BResultSp,
			inasp_ssusr_dr=:AdjUserId,inasp_ctuom_dr=:AdjUomId,inasp_ctuom_price=:ResultSp,
			INASP_PriorRP=:BPriorRp,INASP_ResultRP=:BResultRp,INASP_CTUOM_Rp=:ResultRp,INASP_Time=:AdjTime,
			INASP_WarrentNO=:WarrentNo,INASP_WNODate=:WnoDate,INASP_PreExeDate=:PreExecuteDate,
			INASP_Remark=:Remark,INASP_INVOICE=:InvoNo,INASP_INVODATE=:InvoDate,INASP_REASON_DR=:AdjReasonId,
			INASP_Cat=:AdjSPCat
			where inasp_rowid=:RowId)
		.i SQLCODE'=0  d RtnObj.Err(-9,"","更新调价表失败!")
		.i RtnObj.success'=0 q
		.i RowIdStr="" d
		..s RowIdStr=RowId
		.e  d
		..s RowIdStr=RowIdStr_","_RowId
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj
	tc
	s RtnObj.rowid=RowIdStr 
	q RtnObj
}

/// 删除调价单
/// Author:zx
/// Date:2018-06-06
/// w ##class(web.DHCSTMHUI.INAdjSalePrice).Delete("[{""RowId"":""956"",""AspNo"":""MASP20180606001"",""Status"":""未审核""   ,""AdjDate"":""2018-06-06"",""ExecuteDate"":""9999-12-31"",""AdjUserName"":""汪  洪岗"",""Inci"":""946"",""Code"":""HQQT0005"",""Description"":""水曲柳"",""Spec"     ":"""",""StkCatDesc"":""其它"",""AspUomId"":""312"",""AspUomDesc"":""立方米"",""     PriorSpUom"":""100"",""PriorRpUom"":""100"",""DiffSpUom"":""20"",""DiffRpUom"":""10"",""WarrentNo"":"""",""WnoDate"":"""",""Remark"":"""",""AuditUserName"":"""",""MarkTypeDesc"":"""",""MaxSp"":""100"",""PreExecuteDate"":""2018-06-07"",""BUomId"":""312"",""PurUomId"":""312"",""AdjReasonId"":""2"",""AdjReason"":""涨价"",  ""MarginNow"":""1.091"",""InvNo"":""222"",""InvDate"":""2018-06-06"",""ResultRpUom"":""110"",""ResultSpUom"":""120""}]")
ClassMethod jsDelete(Params) As %String
{
	n (Params)
	;s ^zx(21)=Params
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		s RtnObj=..Delete(RowId)
		continue:RtnObj.success<0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

ClassMethod Delete(RowId As %String) As RtnObj
{
	n (RowId)
	s RtnObj=##class(RtnObj).%New()
	
	i RowId="" q RtnObj.Err(-2,"","参数错误")
	s Status=$p(^INASP(RowId),"^",9)
	i Status'="No" d
	.d RtnObj.Err(-2,"","调价单已审核或已生效,不允许删除!","",0)
	q:RtnObj.success<0 RtnObj
	&sql(delete from in_adjsaleprice where inasp_rowid=:RowId)
	i SQLCODE'=0 d
	.d RtnObj.Err(-4,RowId,"删除调价表失败","{RowId:"_RowId_"}")
	q:RtnObj.success<0 RtnObj
	
	q RtnObj
}

/// Descript:	查询调价单信息
/// Creater:	zx
/// CreateDate:	2018-05-30
/// Table:		in_adjsaleprice
/// Input:		排序，查询条件
/// Return：	调价单信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INAdjSalePrice","QueryAspInfo",^tempxj)
Query QueryAspInfo(Params As %String) As Query(ROWSPEC = "RowId,AspNo,Status,AdjDate,ExecuteDate,AdjUserName,Inci,InciCode,InciDesc,Spec,StkCatDesc,AspUomId,AspUomDesc,PriorSpUom:%Float,PriorRpUom:%Float,DiffSpUom:%Float,DiffRpUom:%Float,WarrentNo,WnoDate,Remark,AuditUserName,MarkTypeDesc,MaxSp:%Float,PreExecuteDate,BUomId,PurUomId,AdjReasonId,AdjReason,MarginNow,InvNo,InvDate,ResultRpUom:%Float,ResultSpUom:%Float,AdjSPCat") [ SqlProc ]
{
}

ClassMethod QueryAspInfoExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s pStartDate=PJObj.%Get("StartDate")		//开始日期
	s pEndDate=PJObj.%Get("EndDate")		//截止日期
	s pStkScgId=PJObj.%Get("ScgId")		//类组
	s pInciId=PJObj.%Get("Inci")		//物资
	s pAdjspNo=PJObj.%Get("AdjspNo")		//单号
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	s pStatus=PJObj.%Get("Status")
	s pAspIdStr=PJObj.%Get("AspIdStr")
	
	s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s:pEndDate'="" pEndDate=..DH2L(pEndDate)
	
	s type=..sssCode()
	s pHospId=..sssHospId(gLocId)
	s:pHospId="" pHospId=gHospId
	s pStkScgId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(gUserId,type,gLocId,pStkScgId,pHospId)
	s SqlStr="select INASP_Rowid RowId,"
	s SqlStr=SqlStr_"INASP_NO AdjspNo,"
	s SqlStr=SqlStr_"INASP_Date AdjDate,"
	s SqlStr=SqlStr_"INASP_ExecuteDate ExecuteDate,"
	s SqlStr=SqlStr_"INASP_INCI_DR InciId,"
	s SqlStr=SqlStr_"INASP_PriorSP PriorSP,"
	s SqlStr=SqlStr_"INASP_ResultSP ResultSP,"
	s SqlStr=SqlStr_"INASP_Status Status,"
	s SqlStr=SqlStr_"INASP_CTUOM_DR AspUomId,"
	s SqlStr=SqlStr_"INASP_CTUOM_Price ResultSpUom,"
	s SqlStr=SqlStr_"INASP_CTUOM_Rp ResultRpUom,"
	s SqlStr=SqlStr_"INASP_PriorRP PriorRP,"
	s SqlStr=SqlStr_"INASP_ResultRP ResultRP,"
	s SqlStr=SqlStr_"INASP_PreExeDate PreExeDate,"
	s SqlStr=SqlStr_"INASP_Hospital_Dr HospId,"
	s SqlStr=SqlStr_"INASP_AuditUser AuditUserId,"
	s SqlStr=SqlStr_"INASP_SSUSR_DR AdjUserId,"
	s SqlStr=SqlStr_"INASP_Time CreateTime,"
	s SqlStr=SqlStr_"INASP_AuditDate AuditDate,"
	s SqlStr=SqlStr_"INASP_Audittime Audittime,"
	s SqlStr=SqlStr_"INASP_StartDate StartDate,"
	s SqlStr=SqlStr_"INASP_StartTime StartTime,"
	s SqlStr=SqlStr_"INASP_WarrentNO WarrentNo,"
	s SqlStr=SqlStr_"INASP_WNODate WnoDate,"
	s SqlStr=SqlStr_"INASP_Remark Remark,"
	s SqlStr=SqlStr_"INASP_Cat AdjSPCat,"
	s SqlStr=SqlStr_"INASP_REASON_DR AdjReasonId"
	s SqlStr=SqlStr_" from IN_AdjSalePrice"
	s SqlStr=SqlStr_" where INASP_Date between "_pStartDate_" and "_pEndDate
	i pAspIdStr'="" d
	.s SqlStr=SqlStr_" And INASP_Rowid IN ("_pAspIdStr_")"
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s AdjspNo = Result.Data("AdjspNo")
		continue:(pAdjspNo'="")&(AdjspNo'=pAdjspNo)
		s AdjDate = Result.Data("AdjDate")
		s AdjDate=..DL2H(AdjDate)	
		
		s ExecuteDate = Result.Data("ExecuteDate")
		s ExecuteDate=..DL2H(ExecuteDate)	
		s InciId = Result.Data("InciId")
		continue:(pInciId'="")&(InciId'=pInciId)
		s TmpGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
		s TmpStkGrpId=$p(TmpGrpInfo,"^",5)
		continue:(pStkScgId'="")&&(("^"_pStkScgId_"^")'[("^"_TmpStkGrpId_"^"))
		s stktype=$p(TmpGrpInfo,"^",3)
		continue:stktype'=..sssCode()
		s PriorSP = Result.Data("PriorSP")  ;调前售价(基本单位)
		s ResultSP = Result.Data("ResultSP") ;调后售价(基本单位)
		
		s Status = Result.Data("Status")   
		continue:(pStatus'="")&&(pStatus'=Status)
		s AspUomId = Result.Data("AspUomId")   ;调价单位
		s ResultRpUom = Result.Data("ResultRpUom")   ;调价单位对应调后进价
		s ResultSpUom = Result.Data("ResultSpUom")   ;调价单位对应调后售价
		s PriorRP = Result.Data("PriorRP")  ;调前进价(基本单位)
		s PreExeDate = Result.Data("PreExeDate") ;计划生效日期
		s PreExeDate=..DL2H(PreExeDate)
		
		s HospId = Result.Data("HospId")
		continue:(gHospId'="")&&(gHospId'=HospId)
		s AdjUserId = Result.Data("AdjUserId")
		s CreateTime = Result.Data("CreateTime")
		s CreateTime=..TL2H(CreateTime)
		s AuditDate = Result.Data("AuditDate")
		s AuditDate=..DL2H(AuditDate)	
		s AdjSPCat=Result.Data("AdjSPCat")
		
		s WarrentNo = Result.Data("WarrentNo")
		s WnoDate = Result.Data("WnoDate")
		s WnoDate=..DL2H(WnoDate)
		
		s Audittime = Result.Data("Audittime")
		s Audittime=..TL2H(Audittime)
		s Remark = Result.Data("Remark") 
		s AuditUserId = Result.Data("AuditUserId")
		s AuditUserName=""
		s:AuditUserId'="" AuditUserName=..sssUserName(AuditUserId)
		
		s AdjReasonId = Result.Data("AdjReasonId")
		s AdjReason=""
		s:AdjReasonId'="" AdjReason=$p(^DHCSTREASON("ASP",AdjReasonId),"^",2)
		
		i Status="No" d
		.s Status="未审核"
		e  i Status="Audit"  d
		.s Status="已审核"
		e  i Status="Yes"  d
		.s Status="已生效"
		
		s StkCatId=$p(^INCI(InciId,2),"^",2)
		s InciCode=$p(^INCI(InciId,1),"^",1)
		s InciDesc=$p(^INCI(InciId,1),"^",2)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
		s BUomId=$p(^INCI(InciId,1),"^",10)
		s PurUomId=$p(^INCI(InciId,3),"^",6)
		s StkCatDesc="",AspUomDesc=""
		s:StkCatId'="" StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
		s:AspUomId'="" AspUomDesc=$p(^CT("UOM",AspUomId),"^",2) ;调价单位
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(AspUomId,BUomId)
		s PriorRPUom=PriorRP*ConFac
		s PriorSpUom=PriorSP*ConFac
		i AspUomId=BUomId d
		.s PriorSpUom=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(PriorSpUom,HospId,2)
		.s PriorRPUom=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(PriorRPUom,HospId,2)
		e  d
		.s PriorSpUom=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(PriorSpUom,HospId,1)
		.s PriorRPUom=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(PriorRPUom,HospId,1)

		s DiffSpUom=ResultSpUom-PriorSpUom
		s DiffRpUom=ResultRpUom-PriorRPUom
		s AdjUserName=""
		s:AdjUserId'="" AdjUserName=..sssUserName(AdjUserId)
		s InfoId=$o(^DHCITMINFO(0,"INCI",InciId,0))
		s MarkTypeDesc="",MaxSp="",MarkTypeId=""
		i InfoId'=""  d
		.s MarkTypeId=$p(^DHCITMINFO(InfoId),"^",15)
		.s:MarkTypeId'="" MarkTypeDesc=$p(^DHCINMT(MarkTypeId),"^",2)
		.s MaxSp=$p(^DHCITMINFO(InfoId),"^",16)
		s MarginNow=$s(+ResultRpUom'=0:ResultSpUom/ResultRpUom,1:"")
		s:+MarginNow'=0 MarginNow=$fn(MarginNow,"",3)
		s InvNo=$p(^INASP(RowId),"^",18) 
		s InvDate=$p(^INASP(RowId),"^",19)
		s InvDate=..DL2H(InvDate)
		d OutPutRow2
	}
	
	Quit $$$OK
OutPutRow2
	s Data=$lb(RowId,AdjspNo,Status,AdjDate,ExecuteDate,AdjUserName,InciId,InciCode,InciDesc,Spec,StkCatDesc,AspUomId,AspUomDesc,PriorSpUom,PriorRPUom,DiffSpUom,DiffRpUom,WarrentNo,WnoDate,Remark,AuditUserName,MarkTypeDesc,MaxSp,PreExeDate,BUomId,PurUomId,AdjReasonId,AdjReason,MarginNow,InvNo,InvDate,ResultRpUom,ResultSpUom,AdjSPCat)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	根据物资id取物资调价信息
/// Creater:	zx
/// CreateDate:	2018-05-30
/// Table:		inc_itm
/// Input:		库存项id,安全组id^科室id^用户id
/// Return：	
/// 
/// w ##class(web.DHCSTMHUI.INAdjSalePrice).GetItmInfo("948","{""StartDate"":""2018-07-13"",""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""97"",""gHospId"":""2"",""ScgId"":""2"",""EndDate"":""2018-07-13"",""InciDesc"":"""",""AdjspNo"":""""}")
ClassMethod GetItmInfo(Inci As %String, Params As %String) As %Library.String
{
	n (Inci,Params)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	q:+Inci=0 ""
	s GroupId=PJObj.%Get("gGroupId")
	s LocId=PJObj.%Get("PurLoc")
	s UserId=PJObj.%Get("gUserId")
	s HospId=PJObj.%Get("gHospId")
	s:((HospId="")&&(LocId'="")) HospId=$p(^CTLOC(LocId),"^",22)
	s ParamStr=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
	
	s AppName=..%GetParameter("AppName")
	s StkCatId=$p(^INCI(Inci,2),"^",2)
	s StkCatDesc=""
	s:StkCatId'="" StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
	s InciCode=$p(^INCI(Inci,1),"^",1)
	s InciDesc=$p(^INCI(Inci,1),"^",2)
	s InfoId=$o(^DHCITMINFO(0,"INCI",Inci,0))
	s (MarkTypeId,MarkTypeDesc,PriceFileNo,MaxSp)=""
	i InfoId'=""  d
	.s MarkTypeId=$p(^DHCITMINFO(InfoId),"^",15)
	.s:MarkTypeId'="" MarkTypeDesc=$p(^DHCINMT(MarkTypeId),"^",2)
	.s PriceFileNo=$p(^DHCITMINFO(InfoId),"^",33)
	.s MaxSp=$p(^DHCITMINFO(InfoId),"^",16)
	.
	s BUomId=$p(^INCI(Inci,1),"^",10)
	s PUomId=$p(^INCI(Inci,3),"^",6)
	s (BUomDesc,PUomDesc)=""
	s:BUomId'="" BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	s:PUomId'="" PUomDesc=$p(^CT("UOM",PUomId),"^",2)
	s PurSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inci,+$h,PUomId,HospId)
	s PurRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetConfigRp(Inci,PUomId,AppName,ParamStr)
	s ConFacPur=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUomId)
	s WarrentNo="",WnoDate=""
	&sql(select INFO_PrcFile,INFO_PrcFileD into :WarrentNo,:WnoDate from DHC_ItmAddionInfo where INFO_INCI_DR=:Inci)
	s:+WnoDate'=0 WnoDate=..DL2H(WnoDate)
	
	s Data1=InciCode_"^"_InciDesc_"^"_StkCatId_"^"_StkCatDesc_"^"_MarkTypeId_"^"_MarkTypeDesc
	s Data2=BUomId_"^"_BUomDesc_"^"_PUomId_"^"_PUomDesc_"^"_PriceFileNo
	s Data3=PurSp_"^"_PurRp_"^"_MaxSp_"^"_ConFacPur_"^"_WarrentNo_"^"_WnoDate
	s Data=Data1_"^"_Data2_"^"_Data3
	s Title="InciCode^InciDesc^StkCatId^StkCatDesc^MarkTypeId^MarkTypeDesc"
		_"^BUomId^BUomDesc^PUomId^PUomDesc^PriceFileNo^PurSp^PurRp^MaxSp^ConFacPur^WarrentNo^WnoDate"
	
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

/// Descript:	物资信息维护调价(保存成功后自动审核)
/// w ##class(web.DHCSTMHUI.INAdjSalePrice).SaveAdjPrice("{""AdjspNo"":"""",""ScgId"":"""",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2""}","[{""RowId"":"""",""PreExecuteDate"":""2020-07-01"",""Inci"":""2"",""AspUomId"":""7"",""ResultSpUom"":""7800"",""ResultRpUom"":""7800"",""AdjReasonId"":""1"",""PriorSpUom"":""7900.00"",""PriorRpUom"":""7900.00"",""AdjSPCat"":""手动调价"",""WarrentNo"":"""",""WnoDate""    :"""",""InvNo"":"""",""InvDate"":"""",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2""}]","6423")
ClassMethod SaveAdjPrice(Main As %String, Detail As %String, AdjUserId As %String) As %Library.String
{
	n (Main,Detail,AdjUserId)
	s RtnObj=##class(RtnObj).%New()
	s $ZT=..sssError()
	s RtnObj=..Update(Main,Detail)
	i RtnObj.success<0 q RtnObj.Json()
	s Asp=RtnObj.rowid
	s RtnObj=..Audit(Asp,AdjUserId)
	i RtnObj.success<0 q RtnObj.Json()
	q RtnObj.Json()
}

}
