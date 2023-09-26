Import sqluser

/// Descript:批次调价
/// Creater:    wyx
/// CreateDate: 2014-03-19
/// up: xuchao 2015/1/22
Class web.DHCSTMHUI.INAdjPriceBatch Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTADJSPBATCHM";

/// Descript：	批次调价任务,每天0点执行
/// Creater：	zhouyg
/// CreateDate：2013-08-07
/// Return：	0-正确，其他-错误
ClassMethod NightRunAspAmount()
{
 s PreDah=+$h
 s PreTime=""
 s RetCode=""
 f  s PreTime=$o(^DHCSTINAPB(0,"STATUSPRE","A",PreDah,PreTime)) q:PreTime=""  d
 .s APBID=""
 .f  s APBID=$o(^DHCSTINAPB(0,"STATUSPRE","A",PreDah,PreTime,APBID)) q:APBID=""  d
 ..s Incib=$p(^DHCSTINAPB(APBID),"^",4)
 ..s Inci=+Incib
 ..s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
 ..s StkType=$p(ScgInfo,"^",3)
 ..q:StkType'=..sssCode()	;过滤非耗材数据
 ..s RetCode=..ExeAPB(APBID,"","","")
 q RetCode
}

/// Descript:	保存调价单
/// Creater:	zx
/// CreateDate:	2018-06-7
/// Table:		IN_AdjSalePrice
/// Input:		主单信息，明细信息
/// Return：	成功，失败
/// w ##class(web.DHCSTMHUI.INAdjPriceBatch).JsSave("{""StartDate"":""2018-07-20"",""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""97"",""gHospId"":""2"",""ScgId"":"""",""EndDate"":""2018-07-20"",""InciDesc"":"""",""AdjspNo"":""""}","[{""RowId"":""18"",""AspNo"":""MASPB20180720003"",""Inci"":""908"",""AspUomId"":""105"",""PriorSpUom"":""0"",""PriorRpUom"":""0"",""WarrentNo"":"""",""WnoDate"":"""",""PreExecuteDate"":""2018-07-21"",""AdjReasonId"":""1"",""ResultRpUom"":""1"",""ResultSpUom"":""2"",""Incib"":""908||1""}]")
ClassMethod JsSave(Main As %String, Detail As %String) As %Library.String
{
	n (Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Save(Main,Detail)
	q RtnObj.Json()
}

/// Descript:	保存调价单
/// Creater:	zx
/// CreateDate:	2018-06-7
/// Table:		IN_AdjSalePrice
/// Input:		主单信息，明细信息
/// Return：	成功，失败
/// w ##class(web.DHCSTMHUI.INAdjPriceBatch).Save("{""StartDate"":""2018-07-20"",""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""97"",""gHospId"":""2"",""ScgId"":"""",""EndDate"":""2018-07-20"",""InciDesc"":"""",""AdjspNo"":""""}","[{""RowId"":""18"",""AspNo"":""MASPB20180720003"",""Inci"":""908"",""AspUomId"":""105"",""PriorSpUom"":""0"",""PriorRpUom"":""0"",""WarrentNo"":"""",""WnoDate"":"""",""PreExecuteDate"":""2018-07-21"",""AdjReasonId"":""1"",""ResultRpUom"":""1"",""ResultSpUom"":""2"",""Incib"":""908||1""}]")
ClassMethod Save(Main As %String, Detail As %String) As RtnObj
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()
	ts
	s AppName=..%GetParameter("AppName")
	s MainObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d MainObj.%FromJSON(Main)
	s AdjspNo=MainObj.%Get("AspNo")
	s GrpId=MainObj.%Get("ScgId")
	s LocId=MainObj.%Get("gLocId")
	s gUserId=MainObj.%Get("gUserId")
	s gHospId=MainObj.%Get("gHospId")
	i AdjspNo=""  d
	.s AdjspNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,GrpId,LocId)
	.s:+AdjspNo<0 Sc=RtnObj.Err(-1,"","生成单号失败!")
	q:RtnObj.success'=0 RtnObj

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-2,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s RowIdStr=""
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Incib=Obj.%Get("Incib")
		s Inci=Obj.%Get("Inci")
		i Inci=0  s Sc=RtnObj.Err(-3,"","缺少明细数据！","",0)
		q:RtnObj.success'=0 
		
		s InciChl=$p(Incib,"||",2)
		s InciBtNo=$p(^INCI(Inci,"IB",InciChl),"^",1) ;批次
		s PreExecuteDate=Obj.%Get("PreExecuteDate")
		s PreExecuteDate=..DH2L(PreExecuteDate)

		s AdjUomId=Obj.%Get("AspUomId")
		s ResultSp=Obj.%Get("ResultSpUom")
		s ResultRp=Obj.%Get("ResultRpUom")
		s AdjReasonId=Obj.%Get("AdjReasonId")
		s AdjUserId=gUserId
		s HospId=gHospId
		
		s WarrentNo=Obj.%Get("WarrentNo")
		s WnoDate=Obj.%Get("WnoDate")
		s:WnoDate'="" WnoDate=..DH2L(WnoDate)
		s Remark=Obj.%Get("Remark")
		s AdjSPCat=Obj.%Get("AdjSPCat")
		s StkCatId=$p(^INCI(Inci,2),"^",2)
		s InciDesc=$P(^INCI(Inci,1),"^",2) 
 	    
		i RowId="" d
		.;s AdjUserId=gUserId
		.s Status="N"
		.s Flag=..CheckItmAdjBatSp(Incib)
		.i Flag=1 s Sc=RtnObj.Err(-4,"",InciDesc_"存在未生效的调价单！","",0)
		.q:RtnObj.success'=0 
		.s AdjDate=+$h ;制单日期
 	    .s AdjTime=$p($h,",",2)
 	    .;s ExecuteDate=$zdh("9999-12-31",3)
 	    .s ExecuteDate=..DH2L("9999-12-31")
 	    .
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
	    .&sql(insert into IN_AdjPriceBatch(INAPB_date,INAPB_Time,INAPB_Incib_Dr,INAPB_ssusr_dr,INAPB_status,
		    INAPB_no,INAPB_ExecuteDate,INAPB_Uom_Dr,INAPB_PriorRpUom,INAPB_ResultRpUom,INAPB_PriorSpUom,
		    INAPB_ResultSpUom,INAPB_PriorRP,INAPB_ResultRP,INAPB_priorsp,INAPB_resultsp,INAPB_Hospital_Dr,
		    INAPB_WarrentNO,INAPB_WNODate,INAPB_PreExeDate,INAPB_Remark,INAPB_REASON_DR,INAPB_Cat) 
		    values(:AdjDate,:AdjTime,:Incib,:AdjUserId,:Status,
		    :AdjspNo,:ExecuteDate,:AdjUomId,:PriorRp,:ResultRp,:PriorSp,
		    :ResultSp,:BPriorRp,:BResultRp,:BPriorSp,:BResultSp,:HospId,
		    :WarrentNo,:WnoDate,:PreExecuteDate,:Remark,:AdjReasonId,
		    :AdjSPCat) )
	    .i SQLCODE'=0  s Sc=RtnObj.Err(-7,"",InciDesc_"插入调价表失败!")
		.i RtnObj.success'=0  q
		.s RowId=$p(%ROWID,$c(1))
		.i RowIdStr="" d
		..s RowIdStr=RowId
		.e  d
		..s RowIdStr=RowIdStr_","_RowId
		e  d
		.s Status=$p(^DHCSTINAPB(RowId),"^",3)
 	    .i Status'="N" s Sc=RtnObj.Err(-8,"",InciDesc_"调价表不能修改!","",0)  ;调价单已审核或已生效，不能修改
        .i RtnObj.success'=0  q
        .s AdjDate=+$h ;制单日期
 	    .s AdjTime=$p($h,",",2)
	    .s RetStr=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceByIncib(Incib,+$h,AdjUomId,HospId,"")
	    .s PriorSp=$p(RetStr,"^",2)
	    .s PriorRp=$p(RetStr,"^",1)
	    .s BuomId=$p(^INCI(Inci,1),"^",10)
	    .s:BuomId="" Sc=RtnObj.Err(-6,"",InciDesc_"没有基本单位！","",0)
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
	    .&sql(update in_adjpricebatch set INAPB_Incib_Dr=:Incib,INAPB_Date=:AdjDate,INAPB_Time=:AdjTime,
	        INAPB_ssusr_dr=:AdjUserId,INAPB_uom_dr=:AdjUomId,INAPB_PriorRpUom=:PriorRp,INAPB_ResultRpUom=:ResultRp,
	        INAPB_PriorSpUom=:PriorSp,INAPB_ResultSpUom=:ResultSp,INAPB_PriorRP=:BPriorRp,INAPB_ResultRP=:BResultRp,
	        INAPB_priorsp=:BPriorSp,INAPB_resultsp=:BResultSp,INAPB_WarrentNO=:WarrentNo,INAPB_WNODate=:WnoDate,
	        INAPB_PreExeDate=:PreExecuteDate, INAPB_Remark=:Remark,INAPB_REASON_DR=:AdjReasonId,INAPB_Cat=:AdjSPCat   
	        where INAPB_rowid=:RowId)
	    .i SQLCODE'=0  s Sc=RtnObj.Err(-9,"","更新调价表失败!","",0)
		.i RtnObj.success'=0  q
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

/// Descript:	调价单生效
/// Creater:	zx
/// CreateDate:	2018-07-17
/// Table:		in_adjpricebatch
/// Input:调价单串，审核信息
/// Output:     
/// Return：obj
/// w ##class(web.DHCSTMHUI.INAdjPriceBatch).BatUpdatePriceAPB("[{""RowId"":""12"",""ResultRpUom"":""2"",""ResultSpUom"":""2""}]","{""StartDate"":""2018-07-18"",""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""97"",""gHospId"":""2"",""ScgId"":"""",""EndDate"":""2018-07-18"",""Status"":""Y"",""AdjspNo"":"""",""InciDesc"":""""}")
ClassMethod BatUpdatePriceAPB(Rows As %String, Params As %String) As %Library.String
{
	n (Rows,Params)
	
	s MethodName=$CLASSNAME()_".BatUpdatePriceAPB" 
	s RtnObj=##class(RtnObj).%New()
	s ParamsObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d ParamsObj.%FromJSON(Params)
	s gUserId=ParamsObj.%Get("gUserId")
	s gGroupId=ParamsObj.%Get("gGroupId")
	s gLocId=ParamsObj.%Get("gLocId")
	
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
		s ResultSpUom=Obj.%Get("ResultSpUom")
		s ResultRpUom=Obj.%Get("ResultRpUom")
		q:RowId=""
		s ExeDate=$p(^DHCSTINAPB(RowId),"^",16)
		s Status=$p(^DHCSTINAPB(RowId),"^",3)
		i (Status="Y")&(ExeDate'=+$h)   d RtnObj.Err(-2,RowId,"不是当天生效的调价单不能修改","",0)
		q:RtnObj.success'=0
		s Incib=$p(^DHCSTINAPB(RowId),"^",4)
		s UomId=$p(^DHCSTINAPB(RowId),"^",5)
		s Inci=+Incib
		i Inci=0 d RtnObj.Err(-3,RowId,"批次调价单没有对应库存项Id","",0)
		q:RtnObj.success'=0
		s BUomId=$P($g(^INCI(Inci,1)),"^",10)
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
		s HospId=$p(^DHCSTINAPB(RowId),"^",1)
		i UomId=BUomId d
        .s ResultRpUom=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(ResultRpUom,HospId,2)
        .s ResultSpUom=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(ResultSpUom,HospId,2)
        e  d
        .s ResultRpUom=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(ResultRpUom,HospId,1)
        .s ResultSpUom=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(ResultSpUom,HospId,1)
        s ResultRp=ResultRpUom/ConFac
        s ResultSp=ResultSpUom/ConFac
        s ResultRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(ResultRp,HospId,2) 
        s ResultSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(ResultSp,HospId,2)
	    &sql(update in_adjpricebatch  set INAPB_ResultRpUom=:ResultRpUom,
          INAPB_ResultSpUom=:ResultSpUom,INAPB_ResultRp=:ResultRp,
          INAPB_ResultSp=:ResultSp  where INAPB_RowID=:RowId)
         i SQLCODE'=0 d RtnObj.Err(-4,RowId,MethodName_":更新批次调价单失败")
         q:RtnObj.success'=0
		i Status="Y"  d
		.s $p(^DHCSTINAPB(RowId),"^",3)="A"  ;修改状态，否则不允许重复生效
		.s RtnObj=..ExeAPB(RowId,gGroupId,gLocId,gUserId)
		q:RtnObj.success'=0	
		
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	调价单生效
/// Creater:	zx
/// CreateDate:	2018-07-17
/// Table:		in_adjpricebatch
/// Input:调价单串，审核信息
/// Output:     
/// Return：obj
/// w ##class(web.DHCSTMHUI.INAdjPriceBatch).SetExe(^zx(1),^zx(2))
ClassMethod SetExe(Rows As %String, Params As %String) As %Library.String
{
	n (Rows,Params)
	s ParamsObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d ParamsObj.%FromJSON(Params)
	s gUserId=ParamsObj.%Get("gUserId")
	s gGroupId=ParamsObj.%Get("gGroupId")
	s gLocId=ParamsObj.%Get("gLocId")
	
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
 		s RtnObj=..ExeAPB(RowId,gGroupId,gLocId,gUserId)
		q:RtnObj.success'=0
		
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript：	更新批次调价记录生效
/// Creater：	zhouyg
/// CreateDate：2013-08-07
/// Input：		APBID-批次调价记录ID,UserID-审核人ID
/// Return：	0-正确，其他-错误
/// w ##class(web.DHCSTMHUI.INAdjPriceBatch).ExeAPB()
ClassMethod ExeAPB(ApbId, GrpId, LocId, UserId)
{
	n (ApbId, GrpId, LocId, UserId)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".ExeAPB"
	i ApbId="" q RtnObj.Err(-2,ApbId,MethodName_"入参为空","",0)
	i '$d(^DHCSTINAPB(ApbId)) q RtnObj.Err(-2,ApbId,"不存在Id对应的批次调价单!","",0)
	i ..LK(ApbId)<0 q RtnObj.Err(-99,ApbId,"加锁失败!")
	s Status=$p(^DHCSTINAPB(ApbId),"^",3)
	i Status'="A" d ..ULK(ApbId) q RtnObj.Err(-3,ApbId,"调价单不是已审核状态!","",0)
	
	tstart
	s Status="Y"
	s ExecuteDate=$p($h,",",1)
	s ExecuteTime="" //$p($h,",",2)
	s StartDate=$p($h,",",1)
	s StartTime=$p($h,",",2)
	&sql(update in_adjpricebatch set INAPB_Status=:Status,INAPB_ExecuteDate=:ExecuteDate,
		INAPB_ExecuteTime=:ExecuteTime,INAPB_StartUser_dr=:UserId, INAPB_StartDate=:StartDate,
		INAPB_StartTime=:StartTime where INAPB_RowID=:ApbId )    
	i SQLCODE'=0  d
	.d RtnObj.Err(-4,ApbId,MethodName_":更新调价单失败")
	.d ..ULK(ApbId)
	i RtnObj.success<0 tro  q RtnObj 
	;插入价格调整日志    
	s RtnObj=..InsAspDetAfterExe(ApbId,UserId)
	i RtnObj.success<0 d
	.d ..ULK(ApbId)
	i RtnObj.success<0 tro  q RtnObj
	
	s RtnObj=..InsAspAmt(ApbId,GrpId,LocId,UserId)  ;生成损益数据
	i RtnObj.success<0 d
	.d ..ULK(ApbId)
	i RtnObj.success<0 tro  q RtnObj
	
	;同步计费项价格
	s HospId=$p(^DHCSTINAPB(ApbId),"^",1)
	i (HospId="")&&(LocId'="") d
	.s HospId=$p(^CTLOC(LocId),"^",22)
	s Incib=$p(^DHCSTINAPB(ApbId),"^",4)
	s Inci=+Incib
	s BatSpFlag=..sssBatSpFlag(HospId,Inci)
	i BatSpFlag=1 d
	.s LastIncibch=$o(^INCI(Inci,"IB",""),-1)
	.s LastIncib=Inci_"||"_LastIncibch
	.i Incib=LastIncib d
	..s ResultSp=$p(^DHCSTINAPB(ApbId),"^",13)
	..s err=$$AdjINCIPrice^DHCSTMHUITARPRICE(Inci,ExecuteDate,ResultSp,UserId,ApbId,"",HospId)  
	..i err'=0 d RtnObj.Err(-5,ApbId,MethodName_":更新计费价格失败")
	i RtnObj.success<0 tro  q RtnObj
	
	tcommit
	d ..ULK(ApbId)
	q RtnObj
}

/// Descript：	调价生效时计算调价损益
/// Creater：	zx
/// CreateDate：2018-07-17
/// Table:		DHC_ASPAmount,Dhc_AspAmountLB
/// Input：		APBID-批次调价记录ID,GrpId-安全组ID, LocId-科室ID,UserID-审核人ID
/// Return：	0-正确，其他-错误
ClassMethod InsAspAmt(ApbId, GrpId = "", LocId = "", UserID = "")
{
	n (ApbId,GrpId,LocId,UserID)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".InsAspAmt" 
	i ApbId="" q RtnObj.Err(-6,ApbId,MethodName_"入参为空","",0)
	s Incib=$p(^DHCSTINAPB(ApbId),"^",4)
	i Incib="" q RtnObj.Err(-7,ApbId,MethodName_"Incib不能为空","",0)
	s Inci=$o(^INCI("LB_IB",Incib,""))
	i Inci="" q RtnObj
	
	s AspBatNo=$p(^DHCSTINAPB(ApbId),"^",2)
	s AspdId=$O(^DHCINASPD(0,"INAPB",ApbId,""),-1)
	i AspdId>0 d
	.s PriorSp=$p(^DHCINASPD(AspdId),"^",8)      	;基本单位对应的价格
	.s ResultSp=$p(^DHCINASPD(AspdId),"^",9)    		;基本单位对应的价格
	.s PriorRp=$p(^DHCINASPD(AspdId),"^",10)       	;基本单位对应的调前进价
	.s ResultRp=$p(^DHCINASPD(AspdId),"^",11)    	;基本单位对应的调后进价
	e  d 
	.s PriorRp=$p(^DHCSTINAPB(ApbId),"^",10)
	.s ResultRp=$p(^DHCSTINAPB(ApbId),"^",11)
	.s PriorSp=$p(^DHCSTINAPB(ApbId),"^",12)
	.s ResultSp=$p(^DHCSTINAPB(ApbId),"^",13)
	s HospID=$p(^DHCSTINAPB(ApbId),"^",1)
	s ResultSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(ResultSp,HospID,2)
	s PriorSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(PriorSp,HospID,2)
	s ResultRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(ResultRp,HospID,2)
	s PriorRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(PriorRp,HospID,2)
	s DiffSp=ResultSp-PriorSp
	s DiffRp=ResultRp-PriorRp
	s ILSub=0,Ret=0
 	f  s ILSub=$o(^INCI("LB_IB",Incib,Inci,ILSub)) q:(ILSub="")!(Ret'=0)  d
 	.s LocID=$p(^INCI(Inci,"IL",ILSub),"^",1)
 	.s LBSub=""
 	.f  s LBSub=$o(^INCI("LB_IB",Incib,Inci,ILSub,LBSub)) q:(LBSub="")!(Ret'=0)  d
 	..s INCLB=Inci_"||"_ILSub_"||"_LBSub
	..s Date=+$h
 	..s Qty=##CLASS(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(INCLB,Date)
 	..q:Qty=0
 	..s SpAmt=Qty*DiffSp
 	..s RpAmt=Qty*DiffRp
 	..S SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,HospID)
 	..S RpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospID)
 	..s AspaNo=AspBatNo	//单号
 	..s AspaCtlocDR=LocID
	..s AspaAdjPrice=DiffSp
 	..s AspaInciDR =Inci
 	..s AspaStkQty=Qty
 	..s AspaAmount=SpAmt
 	..s AspaDate=+$h
 	..s AspaTime=$p($h,",",2)
 	..s AspaSSUSRDR=UserID
 	..s AspaAdjRP=DiffRp
 	..s AspaRPAmt=RpAmt
	..s AspaINAPBDr=ApbId
 	..s AspaINCLBDr=INCLB
 	..s trid="",type="KC"
 	..s trid=##class(web.DHCSTMHUI.Common.AspAmount).getLastINCLocTrans(AspaCtlocDR,Inci)
 	..&sql(insert into DHC_ASPAmount
       (ASPA_No,ASPA_CTLOC_DR,ASPA_AdjPrice,ASPA_INCI_DR,ASPA_StkQty,ASPA_Amount,
         ASPA_Date,ASPA_Time,ASPA_SSUSR_DR,ASPA_AdjRP,ASPA_RPAmt,ASPA_INAPB_Dr,
         ASPA_INCLB_Dr,ASPA_ASPTran_Dr,ASPA_TranType) 
        values(:AspaNo,:AspaCtlocDR,:AspaAdjPrice,:AspaInciDR,:AspaStkQty,:AspaAmount,
               :AspaDate,:AspaTime,:AspaSSUSRDR,:AspaAdjRP,:AspaRPAmt,:AspaINAPBDr,
               :AspaINCLBDr,:trid,:type) )
 	..s Ret=SQLCODE
 	..i Ret'=0 d
 	...d RtnObj.Err(-9,ApbId,MethodName_":生成调价损益数据失败,SQLCODE:"_Ret)
 	..q:Ret'=0 
 	..s AspaId=$p(%ROWID,$c(1))
 	..s AspalbAspaParref=AspaId
 	..s AspalbChildsub=$o(^ASPA(AspaId,"LB",""),-1)+1
 	..s AspalbINCLBDR=INCLB
 	..s AspalbQty=Qty
 	..s AspalbAdjDiff=DiffSp
 	..s AspalbAdjAmt=SpAmt
 	..s AspalbAdjRP=DiffRp
 	..s AspalbRPAmt=RpAmt
 	..s AspalbPriorRP=PriorRp
 	..&sql(insert into DHC_ASPAmountLB
        (ASPALB_ASPA_Parref,ASPALB_Childsub,ASPALB_INCLB_DR,ASPALB_Qty,
         ASPALB_AdjDiff,ASPALB_AdjAmt,ASPALB_AdjRP,ASPALB_RPAmt,
         ASPALB_PriorRP)
      	values(:AspalbAspaParref,:AspalbChildsub,:AspalbINCLBDR,:AspalbQty,
         :AspalbAdjDiff,:AspalbAdjAmt,:AspalbAdjRP,:AspalbRPAmt,
         :AspalbPriorRP) )
 	..s Ret=SQLCODE
 	..i Ret'=0 d
 	...d RtnObj.Err(-10,AspaId,MethodName_":生成调价损益批次数据失败,SQLCODE:"_Ret)
	..q:Ret'=0
 	q RtnObj
}

/// Descript:生效以后的处理dhc_inasp_detail
/// Creater:	zx
/// CreateDate:	20180717
/// Table:dhc_inasp_detail
/// Input:调价表id，操作人id
ClassMethod InsAspDetAfterExe(ApbId, UserID = "") As %Library.String
{
	n (ApbId,UserID)
    s RtnObj=##class(RtnObj).%New()
    s MethodName=$CLASSNAME()_".InsAspDetAfterExe"
    
    s UomId=$p(^DHCSTINAPB(ApbId),"^",5)
    s PriorRpUom=$p(^DHCSTINAPB(ApbId),"^",6) 
    s ResultRpUom=$p(^DHCSTINAPB(ApbId),"^",7) 
    s PriorSpUom=$p(^DHCSTINAPB(ApbId),"^",8)     //调整前售价(调价单位)
    s ResultSpuom=$p(^DHCSTINAPB(ApbId),"^",9)
    s PriorRp=$p(^DHCSTINAPB(ApbId),"^",10) 
    s ResultRp=$p(^DHCSTINAPB(ApbId),"^",11) 
    s PriorSp=$p(^DHCSTINAPB(ApbId),"^",12)        //调整前售价(基本单位)
    s ResultSp=$p(^DHCSTINAPB(ApbId),"^",13)
    s Date=+$h  ; execute date
    s Time=$p($h,",",2)
    
    s AspdId=$O(^DHCINASPD(0,"INAPB",ApbId,""),-1)
    i AspdId>0 d //若属于多次调价
    .s PriorSp=$p($G(^DHCINASPD(AspdId)),"^",9)  //取上次的"调后售价"做本次"调前售价"
    .s PriorSpUom=$p($G(^DHCINASPD(AspdId)),"^",6)
    .s PriorRp=$p($g(^DHCINASPD(AspdId)),"^",11) //取上次的"调后进价"做本次"调前进价"
    .s PriorRpUom=$p($g(^DHCINASPD(AspdId)),"^",13)
    &sql(insert into dhc_inasp_detail(ASPD_Date,ASPD_Time,ASPD_SSUSR_DR,ASPD_AdjUom_DR,
	ASPD_ResultSP_Uom,
	ASPD_ResultSP,ASPD_INAPB_DR,
	ASPD_PriorSP,ASPD_PriorSP_Uom,
	ASPD_PriorRP,ASPD_ResultRP,
	ASPD_PriorRP_Uom,ASPD_ResultRP_Uom  )
	values(:Date,:Time,:UserID,:UomId,:ResultSpuom,:ResultSp,:ApbId,
	:PriorSp,:PriorSpUom,:PriorRp,:ResultRp,:PriorRpUom,:ResultRpUom))
	i SQLCODE'=0  d RtnObj.Err(-5,ApbId,MethodName_":调价单生效记录表插入失败")
	q RtnObj
}

/// Creator:    zx
/// CreateDate: 2018-07-16
/// Table:in_adjpricebatch
/// Input:调价单串，审核信息
/// Output:     
/// Return：obj
/// w ##class(web.DHCSTMHUI.INAdjPriceBatch).SetCancelAudit("[{""RowId"":""9""}]","{""StartDate"":""2018-07-16"",""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""97"",""gHospId"":""2"",""ScgId"":"""",""EndDate"":""2018-07-16"",""Status"":""A"",""AdjspNo"":"""",""InciDesc"":""""}")
ClassMethod SetCancelAudit(Rows As %String, Params As %String) As %Library.String
{
    n (Rows, Params)
    s ParamsObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d ParamsObj.%FromJSON(Params)
	s UserID=ParamsObj.%Get("gUserId")
	
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
		
 		s RtnObj=..CancelAudit(RowId,UserID)
		q:RtnObj.success'=0
		
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript：	取消审核
/// Creater：	zx
/// CreateDate：2018-07-16
/// Input：		APBID-批次调价记录ID,UserID-审核人ID
/// Return：	obj
ClassMethod CancelAudit(ApbId, UserID)
{
	n (ApbId,UserID)
	s RtnObj=##class(RtnObj).%New()
	i ApbId="" s Sc=RtnObj.Err(-2,"","Id不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	i '$d(^DHCSTINAPB(ApbId))  s Sc=RtnObj.Err(-3,"","Id对应的批次调价数据不存在!","",0)
	q:RtnObj.success'=0 RtnObj
	i ..LK(ApbId)<0 q RtnObj.Err(-99,ApbId,"加锁失败")
	s Status=$p(^DHCSTINAPB(ApbId),"^",3)
    i Status'="A" d ..ULK(ApbId) q RtnObj.Err(-101,ApbId,"调价单不是已审核状态!","",0)
    tstart
    s $ZT=..sssError()	
    s Status="N"  
    &sql(update in_adjpricebatch set INAPB_AuditUser=:null,INAPB_AuditDate=:null,
          INAPB_AuditTime=:null,INAPB_Status=:Status where INAPB_RowID=:ApbId)
    i SQLCODE'=0 d
    .d RtnObj.Err(-4,ApbId,"更新调价单状态失败","{RowId:"_ApbId_"}")  
    .trollback  
    .d ..ULK(ApbId)
    q:RtnObj.success'=0 RtnObj 
    tcommit
    d ..ULK(ApbId)
    q RtnObj
}

/// Descript:	批次调价单审核
/// Creater:	zx
/// CreateDate:	2018-07-16
/// Table:		IN_AdjPriceBatch
/// Input:		调价单串，审核信息
/// Return：	
/// w ##class(web.DHCSTMHUI.INAdjPriceBatch).SetAudit("[{""RowId"":""9""}]","{""StartDate"":""2018-07-16"",""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""97"",""gHospId"":""2"",""ScgId"":"""",""EndDate"":""2018-07-16"",""Status"":""N"",""AdjspNo"":"""",""InciDesc"":""""}")
ClassMethod SetAudit(Rows As %String, Params As %String) As %Library.String
{
	n (Rows,Params)
	s ParamsObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d ParamsObj.%FromJSON(Params)
	s AuditUserId=ParamsObj.%Get("gUserId")
	s LocId=ParamsObj.%Get("gLocId")
	s GroupId=ParamsObj.%Get("gGroupId")
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
		
 		s RtnObj=..Audit(RowId,AuditUserId_"^"_GroupId_"^"_LocId)
		q:RtnObj.success'=0		
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:批次调价单审核
/// Creater:	zx
/// CreateDate:	2018-7-16
/// Table:IN_AdjPriceBatch
ClassMethod Audit(ApbId, Params) As RtnObj
{
	n (ApbId,Params)
	s RtnObj=##class(RtnObj).%New()
	i ApbId="" s Sc=RtnObj.Err(-2,"","Id不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	i '$d(^DHCSTINAPB(ApbId)) q RtnObj.Err(-3,ApbId,"Id对应的批次调价数据不存在!","",0)
	i ..LK(ApbId)<0 q RtnObj.Err(-99,ApbId,"加锁失败","{}",0)
	
	s UserID=$p(Params,"^",1)
	s GrpId=$p(Params,"^",2)
    s LocId=$p(Params,"^",3)
    
    s Status=$p(^DHCSTINAPB(ApbId),"^",3)
    i Status'="N" d ..ULK(ApbId)
    i Status'="N" q RtnObj.Err(-101,ApbId,"调价单不是未审核状态!","{}",0)
    
    tstart
	s $ZT=..sssError()						;增加错误处理 
	s Status="A"
	s AuditUser=UserID
    s AuditDate=$p($h,",",1)
    s AuditTime=$p($h,",",2)
    s PreExeDate=$p(^DHCSTINAPB(ApbId),"^",14)
    &sql(update in_adjpricebatch  set INAPB_AuditUser=:AuditUser,INAPB_AuditDate=:AuditDate,
          INAPB_AuditTime=:AuditTime,INAPB_Status=:Status where INAPB_RowID=:ApbId)
    i SQLCODE'=0 d
	.d RtnObj.Err(-7,ApbId,"更新调价单状态失败","{RowId:"_ApbId_"}")
	i SQLCODE'=0  trollback  d ..ULK(ApbId)  
	q:RtnObj.success'=0 RtnObj
	
	i PreExeDate=+$h d
	.s RtnObj=..ExeAPB(ApbId,GrpId,LocId,UserID)  ;20180716关联修改
	i RtnObj.success'=0	d
	.trollback
	.d ..ULK(ApbId)
	q:RtnObj.success'=0 RtnObj
	
	tcommit
    d ..ULK(ApbId)
    q RtnObj
}

/// Descript:	查询调价单信息
/// Creater:	zx
/// CreateDate:	2018-07-12
/// Table:		IN_AdjPriceBatch
/// Input:		查询条件
/// Return：	调价单信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INAdjPriceBatch","QueryAspBatNo","{""StartDate"":""2018-07-12"",""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""97"",""gHospId"":""2"",""ScgId"":"""",""EndDate"":""2018-07-12"",""Status"":"""",""AdjspNo"":"""",""InciDesc"":""""}")
Query QueryAspBatNo(Params As %String) As Query(ROWSPEC = "AspNo,AspDate,AspUser,AspBatIdStr") [ SqlProc ]
{
}

ClassMethod QueryAspBatNoExecute(ByRef qHandle As %Binary, Params As %String) As %Status
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
	s:pAdjspNo'="" pAdjspNo=$$ALPHAUP^SSUTIL4(pAdjspNo)
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	s pStatus=PJObj.%Get("Status")
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
	f  s TmpStatus=$o(^DHCSTINAPB(0,"STATUSDATE",TmpStatus)) q:TmpStatus=""  d
	.q:(pStatus'="")&(TmpStatus'=pStatus)
	.f Date=pStartDate:1:pEndDate  d
	..s Time=""
	..f  s Time=$o(^DHCSTINAPB(0,"STATUSDATE",TmpStatus,Date,Time))  q:Time=""  d
	...s AspBatId=""
	...f  s AspBatId=$o(^DHCSTINAPB(0,"STATUSDATE",TmpStatus,Date,Time,AspBatId))  q:AspBatId=""  d
	....q:'$d(^DHCSTINAPB(AspBatId))
	....s Incib=$p(^DHCSTINAPB(AspBatId),"^",4)
	....s HospId=$p(^DHCSTINAPB(AspBatId),"^",1)            ;医院id
	....q:(gHospId'="")&(HospId'=gHospId)
	....s InciId=+Incib
	....q:InciId=""
	....q:(pInciId'="")&(InciId'=pInciId)
	....s InciDesc=$p(^INCI(InciId,1),"^",2)
	....q:(pInciDesc'="")&(InciDesc'[pInciDesc)
	....s TmpAspBatNo=$p(^DHCSTINAPB(AspBatId),"^",2)
	....q:(pAdjspNo'="")&(TmpAspBatNo'=pAdjspNo)
	....s firstDate=$o(^INASP(0,"INCI",InciId,""))	
	....s TmpGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	....s StkType=$p(TmpGrpInfo,"^",3)
	....q:StkType'=..sssCode()
	....s TmpStkGrpId=$p(TmpGrpInfo,"^",5)
	....q:(pStkScgId'="")&&(("^"_pStkScgId_"^")'[("^"_TmpStkGrpId_"^"))
	....s tmpAdjSPCat=$p(^DHCSTINAPB(AspBatId),"^",37)
	....q:(AdjSPCat=1)&&(tmpAdjSPCat'="手动调价")
	....q:(AdjSPCat=2)&&(tmpAdjSPCat'="自动调价")
	....s AdjDate=$p(^DHCSTINAPB(AspBatId),"^",19)  
	....s AdjUserId=$p(^DHCSTINAPB(AspBatId),"^",18)
	....s AuditUserId=$p(^DHCSTINAPB(AspBatId),"^",21)  
	....s AdjDate=..DL2H(AdjDate)
	....s (AdjUserName,AuditUserName)=""
	....s:AdjUserId'="" AdjUserName=..sssUserName(AdjUserId)
	....s:AuditUserId'="" AuditUserName=..sssUserName(AuditUserId)
	....i '$d(^TMPASP(Pid,"ASPBAT",TmpAspBatNo))  d
	.....s ^TMPASP(Pid,"ASPBAT",TmpAspBatNo)=AdjDate_"^"_AdjUserName_"^"_AspBatId
	....e  d
	.....s $p(^TMPASP(Pid,"ASPBAT",TmpAspBatNo),"^",3)=$p(^TMPASP(Pid,"ASPBAT",TmpAspBatNo),"^",3)_","_AspBatId
	.....s TmpAdjDate=$p(^TMPASP(Pid,"ASPBAT",TmpAspBatNo),"^",1)
	.....;最后一次更新人和更新日期
	.....i AdjDate>TmpAdjDate  d
	......s $p(^TMPASP(Pid,"ASPBAT",TmpAspBatNo),"^",1)=AdjDate
	......s $p(^TMPASP(Pid,"ASPBAT",TmpAspBatNo),"^",2)=AdjUserName
	
	s Num=0
    s AspNo=""
    f  s AspNo=$o(^TMPASP(Pid,"ASPBAT",AspNo)) q:AspNo=""  d
    .s DataList=^TMPASP(Pid,"ASPBAT",AspNo)
    .s AdjDate=$p(DataList,"^",1)
    .s AdjUserName=$p(DataList,"^",2)
    .s AspBatIdStr=$p(DataList,"^",3)
    .d OutPut

 	k ^TMPASP(Pid,"ASPBAT") 
	Quit $$$OK
OutPut
    s Data=$lb(AspNo,AdjDate,AdjUserName,AspBatIdStr)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

/// Descript:	根据单号查询调价单信息
/// Creater:	zx
/// CreateDate:	2018-07-12
/// Table:		IN_AdjPriceBatch
/// Input:		查询条件
/// Return：	调价单信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INAdjPriceBatch","QueryDetail","MASPB20220225001","{""StartDate"":""2022-02-14"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""MENUID"":""57835"",""ScgId"":""1"",""AdjSPCat"":""0"",""EndDate"":""2023-02-14"",""Status"":"""",""InciDesc"":"""",""Inci"":"""",""AdjspNo"":""""}","152")
Query QueryDetail(AspNo As %String, Params As %String(MAXLEN=500), AspBatIdStr As %String) As Query(ROWSPEC = "RowId,AspNo,Status,AdjDate,ExecuteDate,AdjUserName,InciId,InciCode,InciDesc,StkCatDesc,AspUomId,AspUomDesc,PriorSpUom:%Float,ResultSpUom:%Float,DiffSpUom,PriorRpUom:%Float,ResultRpUom:%Float,DiffRpUom:%Float,WarrentNo,Remark,AuditUserName,MarkTypeDesc,MaxSp:%Float,PreExecuteDate,BUomId,PurUomId,ConFacPur:%Float,InvNo,InvDate,AdjReasonId,AdjReason,ExeUserName,Spec,HospDesc,Incib,BatExp") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, AspNo As %String, Params As %String(MAXLEN=500), AspBatIdStr As %String) As %Status
{
	n (qHandle,AspNo,Params,AspBatIdStr)
	;s ^tmpzx(1)=$lb(AspNo,Params,AspBatIdStr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:AspNo="" ""
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
	s pInciDesc=PJObj.%Get("InciDesc")
	s AdjSPCat=PJObj.%Get("AdjSPCat")
	
	s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s:pEndDate'="" pEndDate=..DH2L(pEndDate)
	
	s type=..sssCode()
	s pHospId=..sssHospId(gLocId)
	s:pHospId="" pHospId=gHospId
	s pStkScgId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(gUserId,type,gLocId,pStkScgId,pHospId)

	
	s AspBatId=""
	f  s AspBatId=$o(^DHCSTINAPB(0,"ASPNO",AspNo,AspBatId))  q:AspBatId=""  d
	.q:(AspBatIdStr'="")&&(("^"_AspBatIdStr_"^")'[("^"_AspBatId_"^"))
	.s Status=$p(^DHCSTINAPB(AspBatId),"^",3)
	.q:(pStatus'="")&(Status'=pStatus)
	.s AdjDate=$p(^DHCSTINAPB(AspBatId),"^",19)  
	.s ExecuteDate=$p(^DHCSTINAPB(AspBatId),"^",16)
	.s AdjUserId=$p(^DHCSTINAPB(AspBatId),"^",21)
	.s Incib=$p(^DHCSTINAPB(AspBatId),"^",4)
	.s InciId=+Incib
	.q:InciId=""
	.q:(pInciId'="")&(InciId'=pInciId)
	.s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	.s TmpStkGrpId=$p(StkGrpInfo,"^",5)
	.;q:(StkGrpId'="")&(TmpStkGrpId'=StkGrpId)
	.q:(pStkScgId'="")&&(("^"_pStkScgId_"^")'[("^"_TmpStkGrpId_"^"))
	.s tmpAdjSPCat=$p(^DHCSTINAPB(AspBatId),"^",37)
	.q:(AdjSPCat=1)&&(tmpAdjSPCat'="手动调价")
	.q:(AdjSPCat=2)&&(tmpAdjSPCat'="自动调价")
	.s PriorSp=$p(^DHCSTINAPB(AspBatId),"^",12)      ;基本单位对应的价格
	.s ResultSp=$p(^DHCSTINAPB(AspBatId),"^",13) 		;基本单位对应的价格
	.s StkCatId=$p(^INCI(InciId,2),"^",2)
	.s AspUomId=$p(^DHCSTINAPB(AspBatId),"^",5)
	.s ResultSpUom=$p(^DHCSTINAPB(AspBatId),"^",9)   ;调价单位对应的调后售价
	.s ResultRpUom=$p(^DHCSTINAPB(AspBatId),"^",7)       ;调价单位对应的调后进价
	.s WarrentNo=$p(^DHCSTINAPB(AspBatId),"^",27)    ;物价文件号
	.s WnoDate=$p(^DHCSTINAPB(AspBatId),"^",28)   		;物价文件备案日期
	.s Remark=$p(^DHCSTINAPB(AspBatId),"^",31)     ;目前存调价原因
	.s PriorRp=$p(^DHCSTINAPB(AspBatId),"^",10)      ;基本单位对应的调前进价
	.s ResultRp=$p(^DHCSTINAPB(AspBatId),"^",11)	;基本单位对应的调后进价
	.s PreExecuteDate=$p(^DHCSTINAPB(AspBatId),"^",14) ;计划生效日期
	.s HospId=$p(^DHCSTINAPB(AspBatId),"^",1) 			;医院id
	.s HospDesc=""
	.s:HospId'="" HospDesc=$p(^CT("HOSP",HospId),"^",2)
	.s AuditUserId=$p(^DHCSTINAPB(AspBatId),"^",21)    ;审核人
	.s ExeUserid=$p(^DHCSTINAPB(AspBatId),"^",24)      ;生效人
	.s:AdjDate'="" AdjDate=..DL2H(AdjDate)
	.s:ExecuteDate'="" ExecuteDate=..DL2H(ExecuteDate)
	.s (AdjUserName,ExeUserName,AuditUserName)=""
	.s:AdjUserId'="" AdjUserName=..sssUserName(AdjUserId)
	.s:ExeUserid'="" ExeUserName=..sssUserName(ExeUserid)
	.s:AuditUserId'="" AuditUserName=..sssUserName(AuditUserId)
	.
	.s InciCode=$p(^INCI(InciId,1),"^",1)
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.s Specdesc=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
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
  	.
	.s:PreExecuteDate'="" PreExecuteDate=..DL2H(PreExecuteDate)
	.s DiffSpUom=ResultSpUom-PriorSpUom
	.s DiffRpUom=ResultRpUom-PriorRpUom
	.
	.s InfoId=$o(^DHCITMINFO(0,"INCI",InciId,0))
	.s (MaxSp,MarkTypeDesc)=""
	.i InfoId'=""  d
	..s MarkTypeId=$p(^DHCITMINFO(InfoId),"^",15)
	..s:MarkTypeId'="" MarkTypeDesc=$p(^DHCINMT(MarkTypeId),"^",2)
	..;s PriceFileNo=$p(^DHCITMINFO(InfoId),"^",33)
	..s MaxSp=$p(^DHCITMINFO(InfoId),"^",16)
	.s ConFacPur=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	.s AdjReason=""
	.s AdjReasonId=$p(^DHCSTINAPB(AspBatId),"^",29)
	.s:AdjReasonId'="" AdjReason=$p(^DHCSTREASON("ASP",AdjReasonId),"^",2) 
	.s:Status="N" Status="未审核"
	.s:Status="A" Status="已审核未生效"
	.s:Status="Y" Status="已生效"
	.s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
    .s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
    .i ExpDate'="" s ExpDate=..DL2H(ExpDate)
    .s BatExp=BatNo_"~"_ExpDate
	.
	.d OutPutRowByAspNo
	Quit $$$OK
OutPutRowByAspNo
 s Data=$lb(AspBatId,AspNo,Status,AdjDate,ExecuteDate,AdjUserName,InciId,InciCode,InciDesc,StkCatDesc,AspUomId,AspUomDesc,PriorSpUom,ResultSpUom,DiffSpUom,PriorRpUom,ResultRpUom,DiffRpUom,WarrentNo,Remark,AuditUserName,MarkTypeDesc,MaxSp,PreExecuteDate,BUomId,PurUomId,ConFacPur,InvNo,InvDate,AdjReasonId,AdjReason,ExeUserName,Specdesc,HospDesc,Incib,BatExp)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Descript:	查询调价单信息
/// Creater:	zx
/// CreateDate:	2018-07-05
/// Table:		IN_AdjPriceBatch
/// Input:		排序，查询条件
/// Return：	调价单信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INAdjPriceBatch","QueryAspBatInfo","","","{""StartDate"":""2018-07-20"",""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""97"",""gHospId"":""2"",""ScgId"":""2"",""EndDate"":""2018-07-20"",""InciDesc"":"""",""AdjspNo"":"""",""Status"":""N""}")
Query QueryAspBatInfo(Params As %String) As Query(ROWSPEC = "RowId,AspNo,Status,AdjDate,ExecuteDate,AdjUserName,Inci,InciCode,InciDesc,Spec,StkCatDesc,AspUomId,AspUomDesc,PriorSpUom:%Float,PriorRpUom:%Float,DiffSpUom:%Float,DiffRpUom:%Float,WarrentNo,WnoDate,Remark,AuditUserName,MarkTypeDesc,MaxSp:%Float,PreExecuteDate,BUomId,PurUomId,AdjReasonId,AdjReason,MarginNow,ResultRpUom:%Float,ResultSpUom:%Float,BatExp,Incib,AdjSPCat") [ SqlProc ]
{
}

ClassMethod QueryAspBatInfoExecute(ByRef qHandle As %Binary, Params As %String) As %Status
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
	s SqlStr="select INAPB_RowID RowId,"
	s SqlStr=SqlStr_"INAPB_No AdjspNo,"
	s SqlStr=SqlStr_"INAPB_Date AdjDate,"
	s SqlStr=SqlStr_"INAPB_ExecuteDate ExecuteDate,"
	s SqlStr=SqlStr_"INAPB_Incib_Dr Incib,"
	s SqlStr=SqlStr_"INAPB_PriorSp PriorSP,"
	s SqlStr=SqlStr_"INAPB_ResultSp ResultSP,"
	s SqlStr=SqlStr_"INAPB_Status Status,"
	s SqlStr=SqlStr_"INAPB_Uom_DR AspUomId,"
	s SqlStr=SqlStr_"INAPB_ResultSpUom ResultSpUom,"
	s SqlStr=SqlStr_"INAPB_Remark Remark,"
	s SqlStr=SqlStr_"INAPB_ResultRpUom ResultRpUom,"
	s SqlStr=SqlStr_"INAPB_PriorRp PriorRP,"
	s SqlStr=SqlStr_"INAPB_ResultRp ResultRP,"
	s SqlStr=SqlStr_"INAPB_PreExeDate PreExeDate,"
	s SqlStr=SqlStr_"INAPB_Hospital_Dr HospId,"
	s SqlStr=SqlStr_"INAPB_AuditUser AuditUserId,"
	s SqlStr=SqlStr_"INAPB_SSUSR_Dr AdjUserId,"
	s SqlStr=SqlStr_"INAPB_Time CreateTime,"
	s SqlStr=SqlStr_"INAPB_AuditDate AuditDate,"
	s SqlStr=SqlStr_"INAPB_AuditTime Audittime,"
	s SqlStr=SqlStr_"INAPB_StartDate StartDate,"
	s SqlStr=SqlStr_"INAPB_StartTime StartTime,"
	s SqlStr=SqlStr_"INAPB_WarrentNO WarrentNo,"
	s SqlStr=SqlStr_"INAPB_WNODate WnoDate,"
	s SqlStr=SqlStr_"INAPB_Cat AdjSPCat,"
	s SqlStr=SqlStr_"INAPB_REASON_DR AdjReasonId"
	s SqlStr=SqlStr_" from IN_AdjPriceBatch"
	s SqlStr=SqlStr_" where INAPB_Date between "_pStartDate_" and "_pEndDate
	i pAspIdStr'="" d
	.s SqlStr=SqlStr_" And INAPB_RowID IN ("_pAspIdStr_")"
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
		s Incib = Result.Data("Incib")
		continue:'$d(^INCI(+Incib,"IB",$p(Incib,"||",2)))
		s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
    	s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
    	i ExpDate'="" s ExpDate=..DL2H(ExpDate)
    	s BatExp = BatNo_"~"_ExpDate	
		s InciId = +Incib
		
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
		s CreateTime = Result.Data("CreateTime")  ;制单时间
		s CreateTime=..TL2H(CreateTime)
		s AuditDate = Result.Data("AuditDate")     ;审核日期
		s AuditDate=..DL2H(AuditDate)	
		
		s WarrentNo = Result.Data("WarrentNo")  
		s WnoDate = Result.Data("WnoDate")    
		s WnoDate=..DL2H(WnoDate)	 
		
		s Audittime = Result.Data("Audittime")  ;审核时间
		s Audittime=..TL2H(Audittime)
		s Remark = Result.Data("Remark") 
		s AdjSPCat = Result.Data("AdjSPCat")
		s AuditUserId = Result.Data("AuditUserId") 
		s AuditUserName=""
	    s:AuditUserId'="" AuditUserName=..sssUserName(AuditUserId)
		
		s AdjReasonId = Result.Data("AdjReasonId")  ;调价原因
		s AdjReason=""
	    s:AdjReasonId'="" AdjReason=$p(^DHCSTREASON("ASP",AdjReasonId),"^",2)
		
		i Status="N" d
		.s Status="未审核"
		e  i Status="A"  d
		.s Status="已审核"
		e  i Status="Y"  d
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

		d OutPutRow2
	}
	
	Quit $$$OK
OutPutRow2
	s Data=$lb(RowId,AdjspNo,Status,AdjDate,ExecuteDate,AdjUserName,InciId,InciCode,InciDesc,Spec,StkCatDesc,AspUomId,AspUomDesc,PriorSpUom,PriorRPUom,DiffSpUom,DiffRpUom,WarrentNo,WnoDate,Remark,AuditUserName,MarkTypeDesc,MaxSp,PreExeDate,BUomId,PurUomId,AdjReasonId,AdjReason,MarginNow,ResultRpUom,ResultSpUom,BatExp,Incib,AdjSPCat)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:   删除调价批次信息
/// Creater:    zx
/// CreateDate: 2018-07-12
/// Table:in_adjpricebatch
/// w ##class(web.DHCSTMHUI.INAdjPriceBatch).jsDelete("[{""RowId"":""5"",""AspNo"":""MASPB20180712001"",""Status"":""未审核"",""AdjDate"":""2018-07-12"",""ExecuteDate"":""9999-12-31"",""AdjUserName"":""汪洪岗"",""Inci"":""946"",""Code"":""HQQT0005"",""Description"":""水曲柳"",""Spec"":"""",""StkCatDesc"":""其它"",""AspUomId"":""312"",""AspUomDesc"":""立方米"",""PriorSpUom"":""0"",""PriorRpUom"":""0"",""DiffSpUom"":""1"",""DiffRpUom"":""1"",""WarrentNo"":"""",""WnoDate"":"""",""Remark"":"""",""AuditUserName"":"""",""MarkTypeDesc"":"""",""MaxSp"":""100"",""PreExecuteDate"":""2018-07-13"",""BUomId"":""312"",""PurUomId"":""312"",""AdjReasonId"":""1"",""AdjReason"":""调价"",""Margin  Now"":""1.000"",""InvNo"":"""",""InvDate"":"""",""ResultRpUom"":""1"",""ResultSpUom"":""1"",""BatExp"":""~""}]")
ClassMethod jsDelete(Params As %String) As %Library.String
{
    n (Params)   
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
	s Status=$p(^DHCSTINAPB(RowId),"^",3)
 	i Status'="N" d
 	.d RtnObj.Err(-3,"","调价单已审核或已生效,不允许删除!","",0)
 	q:RtnObj.success<0 RtnObj
 	&sql(delete from in_adjpricebatch where inapb_rowid=:RowId)
	i SQLCODE'=0 d
	.d RtnObj.Err(-4,RowId,"删除调价表失败","{RowId:"_RowId_"}")
	q:RtnObj.success<0 RtnObj
	
	q RtnObj
}

/// Descript:   检查是否存在某批次库存项对应的未生效的调价单
/// Creater:    ZhangDongmei
/// CreateDate: 2012-02-06
/// Table:in_adjsaleprice
/// Input:库存项批次id
/// Output:     
/// Return：1：存在；0：不存在
ClassMethod CheckItmAdjBatSp(Incib As %String) As %Library.String
{
    n (Incib)
    q:Incib="" 0 
    s Flag=0
    ;
    s ExeDate=""
    f  s ExeDate=$o(^DHCSTINAPB(0,"INCIB",Incib,ExeDate))  q:ExeDate=""  d
    .s ExeTime=""
    .f  s ExeTime=$o(^DHCSTINAPB(0,"INCIB",Incib,ExeDate,ExeTime)) q:ExeTime=""  d
    ..s AspBatId=""
    ..f  s AspBatId=$o(^DHCSTINAPB(0,"INCIB",Incib,ExeDate,ExeTime,AspBatId)) q:AspBatId=""  d
    ...s Status=$p(^DHCSTINAPB(AspBatId),"^",3)
    ...q:Status="Y"    ;已生效
    ...s Flag=1
    ..
    .
    q Flag
}

/// Descript:   检查是否存在某批次库存项对应的当天调价记录
/// Creater:    wangjiabin
/// CreateDate: 2013-06-25
/// Table:in_adjsaleprice
/// Input:库存项批次id
/// Output:     
/// Return：1：存在；0：不存在
ClassMethod CheckItmAspBatToday(Incib As %String) As %Library.String
{
    n (Incib)
    q:Incib="" 0 
    s Flag=0
    ;
    s ExeDate=+$h+1
    f  s ExeDate=$o(^DHCSTINAPB(0,"INCIB",Incib,ExeDate),-1)  q:ExeDate=""  d
    .i ExeDate=+$h d
    ..s Flag=1
    .
    q Flag
}

/// 对调价批次表更新时需要加锁
/// Date:2012-07-13
/// Argu:
///   APBID - 调价批次表 RowId
/// Return:
///   0 - success
///   <0 - failure
/// 
ClassMethod LK(APBID)
{
 n (APBID)
 q:APBID="" 0
 q ##class(web.DHCSTMHUI.Common.AppCommon).Lock(..%GetParameter("AppName")_APBID)
}

/// 解锁
ClassMethod ULK(APBID)
{
  n (APBID)
 d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(..%GetParameter("AppName")_APBID)
 q
}

/// Descript:   已经部分上线的项目跟进批次价格插入批次调价表信息(根据定价类型计算售价)
/// Creater:    Zhangxiao
/// CreateDate: 20210524
/// Table:in_adjsaleprice
/// Input:医院id(用于调价时存医院)
/// Output:     
/// Return：
/// 执行完方法查看^TMPDHCSTMHUI("GetPriceToPriceBatch") 有没有异常数据
/// w ##class(web.DHCSTMHUI.INAdjPriceBatch).GetPriceToPriceBatch(2)
ClassMethod GetPriceToPriceBatch(HospId) As %Library.String
{
	n (HospId)
	q:+HospId=0 "医院Id不能为空"
	k ^TMPDHCSTMHUI("GetPriceToPriceBatch")
	s RtnObj=##class(RtnObj).%New()

	s num=0
	s inci=0
	s HospId=2
	f  s inci=$o(^INCI(inci)) q:inci=""  d
	.s stkcat=""
	.q:+inci=0
	.s stkcat=$p(^INCI(inci,2),"^",2)
	.q:stkcat=""
	.s type=""
	.s type=$p(^INC("SC",stkcat),"^",3)
	.q:type'="M"
	.s sub=""
	.f  s sub=$o(^INCI(inci,"IB",sub)) q:sub=""  d
	..s incib=inci_"||"_sub
	..;q:incib'="100||5"
	..s dhcincib=""
	..s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,dhcincib))
	..s (rp,rppuruom,sp,sppuruom)=0
	..q:dhcincib=""
	..s ExeDate=$o(^DHCSTINAPB(0,"INCIB",incib,""),-1)
	..q:ExeDate>0  ;存在批次调价记录的批次不再进行调价
	..
	..s rp=$p(^DHCINCIB(dhcincib),"^",3)
	..s rppuruom=$p(^DHCINCIB(dhcincib),"^",4)
	..s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetMtSp(inci,rppuruom,rp,HospId)
	..s InciCode=$p(^INCI(inci,1),"^",1)
	..i sp=0 d
	...s Info=$o(^DHCITMINFO(0,"INCI",inci,0))
	...s MtDr=""
	...s:Info'="" MtDr=$p(^DHCITMINFO(Info),"^",15)
	...i MtDr="" d
	....s ^TMPDHCSTMHUI("GetPriceToPriceBatch","Error",incib)=InciCode_"未维护定价类型"
	...e  d
	....s ^TMPDHCSTMHUI("GetPriceToPriceBatch","Warning",incib)=InciCode_"售价为0"
	..;s sp=$p(^DHCINCIB(dhcincib),"^",5)
	..;s sppuruom=$p(^DHCINCIB(dhcincib),"^",6)
	..s sppuruom=rppuruom
	..s buom=$p(^INCI(inci,1),"^",10)
	..s puruom=$p(^INCI(inci,3),"^",6)
	..s MainData={}
	..s MainData.AdjspNo=""
	..s MainData.gHospId=HospId
	..s MainData=MainData.%ToJSON()
	..
	..s tmpData=incib_"^"_inci_"^"_buom_"^"_sp_"^"_rp_"^"_"期初数据自动生成"
	..s tmpTitle="Incib^Inci^AspUomId^ResultSpUom^ResultRpUom^Remark"
	..s Detail="["_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(tmpData,tmpTitle)_"]"
	..
	..s RtnObj=..Save(MainData,Detail)
	..i RtnObj.success'=0 d
	...s ^TMPDHCSTMHUI("GetPriceToPriceBatch","Error",incib)=InciCode_"插入调价单失败"
	..q:RtnObj.success'=0
	..s AdjspId=RtnObj.rowid
	..s RtnObj=..Audit(AdjspId,"")
	..i RtnObj.success'=0 d
	...s ^TMPDHCSTMHUI("GetPriceToPriceBatch","Error",incib)=InciCode_"调价单审核失败"
	..q:RtnObj.success'=0
	..
	..s RtnObj=..ExeAPB(AdjspId,"","","")
    ..i RtnObj.success'=0 d
	...s ^TMPDHCSTMHUI("GetPriceToPriceBatch","Error",incib)=InciCode_"调价单生效失败"
	..q:RtnObj.success'=0
	..s desc=$p(^INCI(inci,1),"^",2)
	..s num=num+1
	..w incib_"^"_desc_" 生成批次调价单成功" ,!
	..

	q num
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INAdjPriceBatch","QueryIncibNoAdjPriceBatch")
/// CALL web_DHCSTMHUI.INAdjPriceBatch_QueryIncibNoAdjPriceBatch()
/// Description:查询批次没有批次调价表的数据或者价格不一致的数据
Query QueryIncibNoAdjPriceBatch() As websys.Query(ROWSPEC = "InciCode,InciDesc,Spec,Incib,Remark") [ SqlProc ]
{
}

ClassMethod QueryIncibNoAdjPriceBatchExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s MType=..sssCode()
	
	s InciId=0
	f  s InciId=$o(^INCI(InciId)) q:InciId=""  d
	.q:+InciId=0
	.s scgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	.s stkType=$p(scgInfo,"^",3)
	.s ScgDesc=$p(scgInfo,"^",2)
	.q:stkType'=MType
	.s Sub=""
	.f  s Sub=$o(^INCI(InciId,"IB",Sub)) q:Sub=""  d
	..s Incib=InciId_"||"_Sub
	..s Remark=""
	..s dhcincib=""
	..s dhcincib=$o(^DHCINCIB(0,"INCIB",Incib,dhcincib))
	..s (rp,rppuruom,sp,sppuruom)=0
	..q:dhcincib=""
	..
	..s rp=$p(^DHCINCIB(dhcincib),"^",3)
	..s rppuruom=$p(^DHCINCIB(dhcincib),"^",4)
	..s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetMtSp(InciId,rppuruom,rp,"")
	..s PriceList=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceByIncib(Incib,+$H,rppuruom)
	..s ApbId=$p(PriceList,"^",5)
	..i ApbId="" d
	...s Remark="没有对应批次调价数据"
	..e  d
	...s retrp=$p(PriceList,"^",1)
	...s retsp=$p(PriceList,"^",2)
	...i retrp'=rp d
	....s Remark="调价表进价与批次表不一致"
	...e  i retsp'=sp d
	....s Remark="调价表售价与定价规则不一致"
	..q:Remark=""
	..s InciCode=$p(^INCI(InciId,1),"^",1)
	..s InciDesc=$p(^INCI(InciId,1),"^",2)
	..s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
	..d IncibNoAdjPriceBatch
	Quit $$$OK
IncibNoAdjPriceBatch
	s Data=$lb(InciCode,InciDesc,Spec,Incib,Remark)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
