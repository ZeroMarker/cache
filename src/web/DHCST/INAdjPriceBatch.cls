Import sqluser

/// Descript:批次调价
/// Creater:    wyx
/// CreateDate: 2014-03-19
Class web.DHCST.INAdjPriceBatch Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTADJSPBATCH";

/// Descript:   保存/更新批次调价单信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-04
/// Table:IN_AdjSalePrice
/// Input:调价单号,应用程序名称,rowid^批次id（inc_itmbat）^计划生效日期^库存项id^调价单位id^调后售价^调后进价^操作人id^
/// 调价原因id^医院id^物价文件号^物价备案时间^备注^发票号^发票日期,rowid^计划生效日期^
/// 库存项id^调价单位id^调后售价^调后进价^操作人id^调价原因id^医院id  ,autoFlag 自动调价不判断生效日期标志
/// ^物价文件号^物价备案时间^备注^发票号^发票日期
/// Output: 
/// Return:调价单号：成功，
/// 错误代码^药品名称
/// -1:调价单已审核或已生效，不能修改
/// -2:库存项无效
/// -3:生成调价单号失败
/// -5:该药品存在未生效的调价单，不能新建调价单
/// -6:基本单位不能为空
/// -8:保存调价记录失败
/// w ##class(web.DHCST.INAdjPriceBatch).Save("",1,102,"^858||1^2015-10-13^858^69^18^15^590^1^2^^^^15^18")
ClassMethod Save(AdjBatchNo As %String, GrpId As %String, LocId As %String, listData As %String, autoFlag As %String = "") As %Library.String
{
    n (AdjBatchNo,GrpId,LocId,listData,autoFlag)
    s AppName=..%GetParameter("AppName")
    s resultString=""
    i AdjBatchNo=""  d
    .s AdjBatchNo=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,GrpId,LocId)
    .s:+AdjBatchNo<0 resultString=-3   
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    q:resultString'="" resultString
    s len=$l(listData,rowDelim)
    s err=0
    f i=1:1:len  q:err'=0  d
    .s data=$p(listData,rowDelim,i)
    .s rowid=$p(data,"^",1)
    .s incib=$p(data,"^",2)
    .s inci=$p(data,"^",4)
    .s preexedate=$p(data,"^",3)
    .q:inci=""
    .q:preexedate=""
    .s:'$d(^INCI(inci)) err=-2
    .s incidesc=$p(^INCI(inci,1),"^",2)
    .s incibatno=$p($g(^INCI(inci,"IB",$p(incib,"||",2))),"^",1) 
    .s inciexpdate=$p($g(^INCI(inci,"IB",$p(incib,"||",2))),"^",2)
    .i inciexpdate'="" s inciexpdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(inciexpdate,"ST")
    .q:err'=0
    .s data=$p(data,"^",2,$l(data,"^"))
    .i rowid'=""  d
    ..s RetCode=..LK(rowid)
    ..q:RetCode<0
    ..s ret=..Update(rowid,data)
    ..d ..ULK(rowid)
    ..s:ret'=0 err=ret
    .e  d
    ..s ret=..Insert(AdjBatchNo,data,autoFlag)
    ..s:+ret<0 err=ret
    .
    q:err'=0 err_"^"_incidesc_","_incibatno_"~"_inciexpdate
    q AdjBatchNo
}

/// Descript:   更新批次调价信息
/// Creater:    wyx
/// CreateDate: 2014-03-19
/// Table:in_adjpricebatch
/// Input:明细id,计划生效日期^库存项id^调价单位id^调后售价^调后进价^操作人id^
/// 调价原因id^医院id^物价文件号^物价备案时间^备注
/// Output:     
/// Return：0:成功；错误代码
ClassMethod Update(AspBatRowid As %String, ListData As %String) As %Library.String
{
    n (AspBatRowid,ListData)       
    s AdjDate=+$h                           ;制单日期
    ;
    s Incib=$p(ListData,"^",1) 
    s PreExecuteDate=$p(ListData,"^",2)     ;计划生效日期
    s:PreExecuteDate'="" PreExecuteDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(PreExecuteDate)
    s AdjUomId=$p(ListData,"^",4)
    s ResultSp=$p(ListData,"^",5)
    s ResultRp=$p(ListData,"^",6)
    s AdjUserId=$p(ListData,"^",7)
    s AdjReasonId=$p(ListData,"^",8)
    s HospId=$p(ListData,"^",9)
    s PriceFileNo=$p(ListData,"^",10)
    s WarNoDate=$p(ListData,"^",11)
    s:WarNoDate'="" WarNoDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(WarNoDate)
    s Remark=$p(ListData,"^",12)
    //s PriorRp=$p(ListData,"^",13)
    //s PriorSp=$p(ListData,"^",14)
    s resultString=""
    ;
    s Status=$p(^DHCSTINAPB(AspBatRowid),"^",3)
    q:Status'="N" -1   ;调价单已审核或已生效，不能修改
    ;
    s ItmRowid=+$p(^DHCSTINAPB(AspBatRowid),"^",4)
    s BuomId=$p(^INCI(ItmRowid,1),"^",10)
    q:BuomId="" -5      ;基本单位不能为空
    s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(AdjUomId,BuomId)

	//更新调前进售价格为最新价格
	s RpAndSpNow=##class(web.DHCSTPRICE).GetPriceByIncib(Incib,+$h,AdjUomId,HospId,"","")
    s PriorRp=$P(RpAndSpNow,"^",1)
    s PriorSp=$P(RpAndSpNow,"^",2)
    s BRpAndSpNow=##class(web.DHCSTPRICE).GetPriceByIncib(Incib,+$h,BuomId,HospId,"","")
    s BPriorRp=$P(BRpAndSpNow,"^",1)
    s BPriorSp=$P(BRpAndSpNow,"^",2)
    
    //调后进售价按8位截取
    s ResultSp=+$fn(ResultSp,"",8)
    s ResultRp=+$fn(ResultRp,"",8)
    s BResultSp=+ResultSp/ConFac
    s BResultRp=+ResultRp/ConFac
    s BResultSp=+$fn(BResultSp,"",8)
    s BResultRp=+$fn(BResultRp,"",8)
    ;
    ;更新调价记录
    &sql(update in_adjpricebatch 
    set INAPB_Incib_Dr=:Incib,
        INAPB_Date=:AdjDate,
        INAPB_ssusr_dr=:AdjUserId,
        INAPB_uom_dr=:AdjUomId,
        INAPB_PriorRpUom=:PriorRp,
        INAPB_ResultRpUom=:ResultRp,
        INAPB_PriorSpUom=:PriorSp,
        INAPB_ResultSpUom=:ResultSp,
        INAPB_PriorRP=:BPriorRp,
        INAPB_ResultRP=:BResultRp,
        INAPB_priorsp=:BPriorSp,
        INAPB_resultsp=:BResultSp,
        INAPB_WarrentNO=:PriceFileNo,
        INAPB_WNODate=:WarNoDate,
        INAPB_PreExeDate=:PreExecuteDate,
        INAPB_Remark=:Remark,
        INAPB_REASON_DR=:AdjReasonId  
    where INAPB_rowid=:AspBatRowid)
    s Err=0
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("UpdateAsp:in_adjpricebatch",AspBatRowid,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 Err    ;更新调价表失败
    q 0
}

/// Descript:   保存批次调价信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-02-06
/// Table:IN_AdjPriceBatch
/// Input:调价单号，rowid^计划生效日期^库存项id^调价单位id^调后售价^调后进价^操作人id^
/// 调价原因id^医院id^物价文件号^物价备案时间^备注^发票号^发票日期,aotuFlag 自动调价不判断预生效日期标志
/// Output:     
/// Return：调价表rowid
ClassMethod Insert(AdjBatSpNo As %String, ListData As %String, aotuFlag As %String = "") As %Library.String
{
    n (AdjBatSpNo,ListData,aotuFlag)  
    s AdjDate=+$h                           ;制单日期
    s Incib=$p(ListData,"^",1)     ;批次rowid
    s ExecuteDate=$zdh("9999-12-31",3)
    s PreExecuteDate=$p(ListData,"^",2)     ;计划生效日期
    i PreExecuteDate'="" s PreExecuteDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(PreExecuteDate)
    s ItmRowid=$p(ListData,"^",3)
    s AdjUomId=$p(ListData,"^",4)
    s ResultSp=$p(ListData,"^",5)
    s ResultRp=$p(ListData,"^",6)
    s AdjUserId=$p(ListData,"^",7)
    s AdjReasonId=$p(ListData,"^",8)
    s HospId=$p(ListData,"^",9)
    s PriceFileNo=$p(ListData,"^",10)
    s WarNoDate=$p(ListData,"^",11)
    s:WarNoDate'="" WarNoDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(WarNoDate)
    s Remark=$p(ListData,"^",12)
    s Status="N"      ;未审核
    s StkCatId=$p(^INCI(ItmRowid,2),"^",2)
    s resultString=""
    ;
    s Flag=..CheckItmAdjBatSp(Incib,HospId)
    q:Flag=1 -5              ;该药品存在未生效的调价单，不能新建调价单
    
    // 保存数据调价信息时只判断是否计划生效日期大于今日，不判断今日是否有已生效的调价单  yangsj 2019-12-19
    q:(aotuFlag'="Y")&&(PreExecuteDate<=+$H) -9  

    s BuomId=$p(^INCI(ItmRowid,1),"^",10)
    q:BuomId="" -6      ;基本单位不能为空
    s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(AdjUomId,BuomId)
   
   	//更新调前进售价格为最新价格
	s RpAndSpNow=##class(web.DHCSTPRICE).GetPriceByIncib(Incib,+$h,AdjUomId,HospId,"","")
    s PriorRp=$P(RpAndSpNow,"^",1)
    s PriorSp=$P(RpAndSpNow,"^",2)
    s BRpAndSpNow=##class(web.DHCSTPRICE).GetPriceByIncib(Incib,+$h,BuomId,HospId,"","")
    s BPriorRp=$P(BRpAndSpNow,"^",1)
    s BPriorSp=$P(BRpAndSpNow,"^",2)
    
    //调后进售价按8位截取
    s ResultSp=+$fn(ResultSp,"",8)
    s ResultRp=+$fn(ResultRp,"",8)
    s BResultSp=+ResultSp/ConFac
    s BResultRp=+ResultRp/ConFac
    s BResultSp=+$fn(BResultSp,"",8)
    s BResultRp=+$fn(BResultRp,"",8)
    
    ;插入调价记录
    &sql(insert into IN_AdjPriceBatch(INAPB_date,INAPB_Incib_Dr,INAPB_ssusr_dr,INAPB_status,
    INAPB_no,INAPB_ExecuteDate,INAPB_Uom_Dr,INAPB_PriorRpUom,INAPB_ResultRpUom,INAPB_PriorSpUom,
    INAPB_ResultSpUom,INAPB_PriorRP,INAPB_ResultRP,INAPB_priorsp,INAPB_resultsp,INAPB_Hospital_Dr,
    INAPB_WarrentNO,INAPB_WNODate,INAPB_PreExeDate,INAPB_Remark,INAPB_REASON_DR) 
    values(:AdjDate,:Incib,:AdjUserId,:Status,
    :AdjBatSpNo,:ExecuteDate,:AdjUomId,:PriorRp,:ResultRp,:PriorSp,
    :ResultSp,:BPriorRp,:BResultRp,:BPriorSp,:BResultSp,:HospId,
    :PriceFileNo,:WarNoDate,:PreExecuteDate,:Remark,:AdjReasonId) )
    
    s Err=0
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("InsertAsp:IN_AdjPriceBatch",Incib,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 -8    ;插入调价表失败
    s AspBatId=$p(%ROWID,$c(1))
    q AspBatId
}

/// Descript:   检查是否存在某批次库存项对应的未生效的调价单
/// Creater:    ZhangDongmei
/// CreateDate: 2012-02-06
/// Table:in_adjsaleprice
/// Input:库存项批次id
/// Output:     
/// Return：1：存在；0：不存在
ClassMethod CheckItmAdjBatSp(Incib As %String, HospId As %String) As %Library.String
{
    n (Incib,HospId)
    q:Incib="" 0 
    s Flag=0
	s GroupFlag=##Class(web.DHCSTCOMMPARA).GetGroupFlag() //yunhaibao20151222,集团化分管价格时按院区判断是否存在
    i GroupFlag'=2 d
    .s ExeDate=""
    .f  s ExeDate=$o(^DHCSTINAPB(0,"INCIB",Incib,ExeDate))  q:ExeDate=""  d
    ..s ExeTime=""
    ..f  s ExeTime=$o(^DHCSTINAPB(0,"INCIB",Incib,ExeDate,ExeTime)) q:ExeTime=""  d
    ...s AspBatId=""
    ...f  s AspBatId=$o(^DHCSTINAPB(0,"INCIB",Incib,ExeDate,ExeTime,AspBatId)) q:AspBatId=""  d
    ....s Status=$p(^DHCSTINAPB(AspBatId),"^",3)
    ....q:Status="Y"    ;已生效
    ....s Flag=1
    e  d
	.I HospId'="" D
	..s ExeDate=""
	..f  s ExeDate=$o(^DHCSTINAPB(0,"HOSPINCIB",HospId,Incib,ExeDate)) q:ExeDate=""  d
	...s ExeTime=""
	...f  s ExeTime=$o(^DHCSTINAPB(0,"HOSPINCIB",HospId,Incib,ExeDate,ExeTime)) q:ExeTime=""  d
	....s AspBatId=""
	....f  s AspBatId=$o(^DHCSTINAPB(0,"HOSPINCIB",HospId,Incib,ExeDate,ExeTime,AspBatId)) q:AspBatId=""  d
    .....s Status=$p(^DHCSTINAPB(AspBatId),"^",3)
    .....q:Status="Y"    ;已生效
    .....s Flag=1
    q Flag
}

/// Descript:   检查是否存在某批次库存项对应的当天调价记录
/// Creater:    wangjiabin
/// CreateDate: 2013-06-25
/// Table:in_adjsaleprice
/// Input:库存项批次id
/// Output:     
/// Return：1：存在；0：不存在
ClassMethod CheckItmAspBatToday(Incib As %String, HospId As %String) As %Library.String
{
    n (Incib,HospId)
    q:Incib="" 0 
    s Flag=0
	s GroupFlag=##Class(web.DHCSTCOMMPARA).GetGroupFlag() //yunhaibao20151222,集团化分管价格时按院区判断是否存在
    s ExeDate=+$h+1
    i GroupFlag'=2 d
    .f  s ExeDate=$o(^DHCSTINAPB(0,"INCIB",Incib,ExeDate),-1)  q:ExeDate=""  d
    ..i ExeDate=+$h s Flag=1
    e  d
    .i HospId'="" d
	..f  s ExeDate=$o(^DHCSTINAPB(0,"HOSPINCIB",HospId,Incib,ExeDate),-1) q:ExeDate=""  d
    ...i ExeDate=+$h s Flag=1
    q Flag
}

/// Descript:   查询一段时间内的调价信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-02-13
/// Table:in_adjsaleprice
/// Input:开始行,一页显示记录条数,开始日期,截止日期,调价单号^调价单状态^库存项id^类组id^
/// Output:     
/// Return：调价批次单信息
/// w ##class(web.DHCST.INAdjPriceBatch).QueryAspBatInfo("0","999","2022-05-18","2022-05-19","XYK[KQ]KQXY01ASPBAT20220519001^N^^8")
ClassMethod QueryAspBatInfo(Start As %Integer, Limit As %Integer, StartDate As %String, EndDate As %String, Others As %String) As %Library.String
{
    n (Start, Limit,StartDate,EndDate,Others)
    //s ^PHATMP("MYQ", $this, "QueryAspBatInfo") = $lb(Start, Limit,StartDate,EndDate,Others)
    s AspBatNo=$p(Others,"^",1)
    s Status=$p(Others,"^",2)
    s ItmRowid=$p(Others,"^",3)
    s StkGrpId=$p(Others,"^",4)
    q:StartDate="" ""
    q:EndDate="" ""
    s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
    s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    s:AspBatNo'="" AspBatNo=$$ALPHAUP^SSUTIL4(AspBatNo)
    s End=Start+Limit
    //s:Status="" Status=0
    s Pid=..NewPid()
    ;
    Set Json = ##class(Code.JsonObj).%New()
    s Num=0
    ;
    i Status'=""  d
    .f Date=StartDate:1:EndDate  d
    ..s Time=""
    ..f  s Time=$o(^DHCSTINAPB(0,"STATUSDATE",Status,Date,Time))  q:Time=""  d
    ...s AspBatId=""
    ...f  s AspBatId=$o(^DHCSTINAPB(0,"STATUSDATE",Status,Date,Time,AspBatId))  q:AspBatId=""  d
    ....d GetDetail(AspBatId)
    ....
    e  d
    .f  s Status=$o(^DHCSTINAPB(0,"STATUSDATE",Status)) q:Status=""  d
    ..f Date=StartDate:1:EndDate  d
    ...s Time=""
    ...f  s AspBatId=$o(^DHCSTINAPB(0,"STATUSDATE",Status,Date,Time))  q:Time=""  d
    ....s AspBatId=""
    ....f  s AspBatId=$o(^DHCSTINAPB(0,"STATUSDATE",Status,Date,Time,AspBatId))  q:AspBatId=""  d
    .....d GetDetail(AspBatId)
    .
    ;
    s Title1="AspBatId^AspBatNo^Incib^BatExp^Status^AdjDate^ExecuteDate^AdjUserName^InciId^InciCode"
    s Title2="InciDesc^StkCatDesc^AspUomId^AspUomDesc^PriorSpUom^ResultSpUom^DiffSpUom"
    s Title3="PriorRpUom^ResultRpUom^DiffRpUom^WarrentNo^WnoDate^Remark^AuditUserName"
    s Title4="MarkType^PriceFileNo^MaxSp^PreExecuteDate^BUomId^PurUomId^ConFacPur^AdjReasonId^AdjReason^FreeDrugFlag"
    s Title=Title1_"^"_Title2_"^"_Title3_"^"_Title4
    s DetailStr=Json.getJsonData(Title,Num)
    k Json 
    Quit DetailStr

GetDetail(Rowid)
    s TmpStatus=$p(^DHCSTINAPB(Rowid),"^",3)
    s AdjDate=$p(^DHCSTINAPB(Rowid),"^",19)  
    s ExecuteDate=$p(^DHCSTINAPB(Rowid),"^",16)
    s AdjUserId=$p(^DHCSTINAPB(Rowid),"^",18)
    s Incib=$p(^DHCSTINAPB(Rowid),"^",4)
    q:'$d(^INCI(+Incib,"IB",$p(Incib,"||",2)))
    s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
    s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
    s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
    s BatExp = BatNo_"~"_ExpDate
    s InciId=+Incib
    q:InciId=""
    q:(ItmRowid'="")&(InciId'=ItmRowid)
    s TmpAspBatNo=$p(^DHCSTINAPB(Rowid),"^",2)
    s TmpAspBatNo = $$ALPHAUP^SSUTIL4(TmpAspBatNo)
    q:(AspBatNo'="")&(TmpAspBatNo'=AspBatNo)
    s TmpGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
    s scgtype=$p(TmpGrpInfo,"^",3)
    q:scgtype'=..sssCode()
    s TmpStkGrpId=$p(TmpGrpInfo,"^",5)
    q:(StkGrpId'="")&(TmpStkGrpId'=StkGrpId)
    ;
    s PriorSp=$p(^DHCSTINAPB(Rowid),"^",12)      ;基本单位对应的价格
    s ResultSp=$p(^DHCSTINAPB(Rowid),"^",13)      ;基本单位对应的价格
    s StkCatId=$p(^INCI(InciId,2),"^",2)
    s AspUomId=$p(^DHCSTINAPB(Rowid),"^",5)
    s ResultSpUom=$p(^DHCSTINAPB(Rowid),"^",9)   ;调价单位对应的调后售价
    s ResultRpUom=$p(^DHCSTINAPB(Rowid),"^",7)       ;调价单位对应的调后进价
    //s WarrentNo=$p(^DHCSTINAPB(Rowid),"^",27)    ;物价文件号
    //s WnoDate=$p(^DHCSTINAPB(Rowid),"^",28)          ;物价文件备案日期
    s Info=$o(^DHCITMINFO(0,"INCI",InciId,0))
    s WarrentNo=$p($g(^DHCITMINFO(Info)),"^",33)    ;物价文件号
    s WnoDate=$p(^DHCITMINFO(Info),"^",34)     ;物价文件备案日期
    s Remark=$p(^DHCSTINAPB(Rowid),"^",31)      ;目前存调价原因
    s PriorRp=$p(^DHCSTINAPB(Rowid),"^",10)     ;基本单位对应的调前进价
    s ResultRp=$p(^DHCSTINAPB(Rowid),"^",11) ;基本单位对应的调后进价
    s PreExecuteDate=$p(^DHCSTINAPB(Rowid),"^",14)  ;计划生效日期
    s HospId=$p(^DHCSTINAPB(Rowid),"^",1)           ;医院id
    s AuditUserId=$p(^DHCSTINAPB(Rowid),"^",21)  
    ;
    s:AdjDate'="" AdjDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AdjDate,"ST")
    s:ExecuteDate'="" ExecuteDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExecuteDate,"ST")
    s (AdjUserNames,StkCatDesc,AspUomDesc)=""
    s:AdjUserId'="" AdjUserName=$p(^SSU("SSUSR",AdjUserId),"^",2)
    s InciCode=$p(^INCI(InciId,1),"^",1)
    s InciDesc=$p(^INCI(InciId,1),"^",2)
    s BUomId=$p(^INCI(InciId,1),"^",10)
    s PurUomId=$p(^INCI(InciId,3),"^",6)
    s:StkCatId'="" StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
    s:AspUomId'="" AspUomDesc=$p(^CT("UOM",AspUomId),"^",2)
    s:WnoDate'="" WnoDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(WnoDate,"ST")
    s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(AspUomId,BUomId)
    s PriorRpUom=PriorRp*ConFac
    s PriorSpUom=PriorSp*ConFac
    s herbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(InciId)
    i (AspUomId=BUomId)&&(BUomId'=PurUomId) d
    .s PriorSpUom=##class(web.DHCST.Common.AppCommon).FormatSp(PriorSpUom,HospId,2,..sssCode(),herbFlag)
    .s PriorRpUom=##class(web.DHCST.Common.AppCommon).FormatRp(PriorRpUom,HospId,2,..sssCode(),herbFlag)
    e  d
    .s PriorSpUom=##class(web.DHCST.Common.AppCommon).FormatSp(PriorSpUom,HospId,1,..sssCode(),herbFlag)
    .s PriorRpUom=##class(web.DHCST.Common.AppCommon).FormatRp(PriorRpUom,HospId,1,..sssCode(),herbFlag)
    .
    s:PreExecuteDate'="" PreExecuteDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PreExecuteDate,"ST")
    s:AuditUserId'="" AuditUserName=$p(^SSU("SSUSR",AuditUserId),"^",2)
    s DiffSpUom=ResultSpUom-PriorSpUom
    s DiffRpUom=ResultRpUom-PriorRpUom
    ;
    s InfoId=$o(^DHCITMINFO(0,"INCI",InciId,0))
    s MarkTypeDesc=""
    i InfoId'=""  d
    .s MarkTypeId=$p(^DHCITMINFO(InfoId),"^",15)
    .s:MarkTypeId'="" MarkTypeDesc=$p(^DHCINMT(MarkTypeId),"^",2)
    .;s PriceFileNo=$p(^DHCITMINFO(InfoId),"^",33)
    .s MaxSp=$p(^DHCITMINFO(InfoId),"^",16)
    s ConFacPur=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
    s PriceFileNo=WarrentNo
    i TmpStatus="N" d
    .s TmpStatus="未审核"
    e  i TmpStatus="A"  d
    .s TmpStatus="已审核"
    e  i TmpStatus="Y"  d
    .s TmpStatus="已生效"
    ;

    ;s:InvDate'="" InvDate=$zd(InvDate,3)	;目前INASP_INVODATE存的就是Y-m-d格式
    s AdjReasonId=$p(^DHCSTINAPB(Rowid),"^",29)
    s AdjReason=""
    s:AdjReasonId'="" AdjReason=$p(^DHCSTREASON("ASP",AdjReasonId),"^",2) 
    s arcimDr=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(InciId)
    s freeDrugFlag=##class(web.DHCST.Common.DrugInfoCommon).CheckIfFreeDrug(arcimDr)
    ;
    
    s DiffRpUom = $fn(DiffRpUom,"N")
    s DiffSpUom = $fn(DiffSpUom,"N")
    s Data1=Rowid_"^"_TmpAspBatNo_"^"_Incib_"^"_BatExp_"^"_TmpStatus_"^"_AdjDate_"^"_ExecuteDate_"^"_$g(AdjUserName)_"^"_InciId_"^"_InciCode
    s Data2=InciDesc_"^"_$g(StkCatDesc)_"^"_AspUomId_"^"_$g(AspUomDesc)_"^"_PriorSpUom_"^"_ResultSpUom_"^"_DiffSpUom
    s Data3=PriorRpUom_"^"_ResultRpUom_"^"_DiffRpUom_"^"_WarrentNo_"^"_WnoDate_"^"_Remark_"^"_$g(AuditUserName)_"^"_$g(MarkTypeDesc)
    s Data4=$g(PriceFileNo)_"^"_$g(MaxSp)_"^"_PreExecuteDate_"^"_BUomId_"^"_PurUomId_"^"_ConFacPur_"^"_AdjReasonId_"^"_$g(AdjReason)_"^"_$g(freeDrugFlag)
    ;
    s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4
    s Num=Num+1
    q:(Start'="")&(Num<=Start)     ;只返回当前页需要显示的记录
    q:(Limit'="")&(Num>End)
    ;
    d Json.InsertRowData(Data)
    ;
    q
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("AdjBatchPrice"))
}

/// Descript:   删除调价批次信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-04
/// Table:in_adjpricebatch
/// Input:明细id
/// Output:     
/// Return：0:成功；错误代码
ClassMethod Delete(AspBatId As %String) As %Library.String
{
    n (AspBatId)       
    ;
    q:AspBatId="" -1            ;rowid不能为空
    s Status=$p(^DHCSTINAPB(AspBatId),"^",3)
    q:Status'="N" -2    ;调价单已审核或已生效，不能删除
    ;
    ;删除调价记录
    s Err=0
    &sql(delete from in_adjpricebatch where inapb_rowid=:AspBatId)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("DeleteAspItm:in_adjpricebatch",AspBatId,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 -3    ;更新调价表失败
    q 0
}

/// Descript:批次调价单审核
/// Creater:    ZhangDongmei
/// CreateDate: 2012-02-13
/// Table:in_adjsaleprice
/// Input:调价批次id串^审核人id，安全组id^科室id
/// Output:     
/// Return：0，成功；
ClassMethod Audit(StrAspBatId As %String, UserID As %String, Params As %String) As %Library.String
{
    n (StrAspBatId,UserID,Params)
    q:StrAspBatId="" -11 
    q:UserID="" -21
    ;
    s Err=0
    s Len=$l(StrAspBatId,"^")
    f i=1:1:Len q:Err'=0  d
    .s AspBatId=$p(StrAspBatId,"^",i)
    .q:AspBatId=""
    .s Err=..AuditAPB(AspBatId,UserID,Params)
    .
    ;
    q Err
}

/// Descript：	审核批次调价记录
/// Creater：	zhouyg
/// CreateDate：2013-08-07
/// Input：		APBID-批次调价记录ID,UserID-审核人ID
/// Return：	0-正确，其他-错误
ClassMethod AuditAPB(APBID As %String, UserID As %String, Params)
{
 
 n (APBID,UserID,Params)
 s GrpId=$p(Params,"^",1)
 s LocId=$p(Params,"^",2)
 q:APBID="" -1
 q:'$d(^DHCSTINAPB(APBID)) -1
 q:..LK(APBID)<0 -100
 s status=$p(^DHCSTINAPB(APBID),"^",3)
 i status'="N" d ..ULK(APBID)
 q:status'="N" -101
 s RetCode=..Select(APBID)
 i RetCode'=0 d ..ULK(APBID)
 q:RetCode'=0 -102
 tstart
 s status="A"
 s auditUser=UserID
 s auditDate=$p($h,",",1)
 s auditTime=$p($h,",",2)
 s PreExeDate=$p(^DHCSTINAPB(APBID),"^",14)
 //s RetCode=..Update()
 &sql(update in_adjpricebatch 
      set INAPB_AuditUser=:auditUser,
          INAPB_AuditDate=:auditDate,
          INAPB_AuditTime=:auditTime,
          INAPB_Status=:status
      where INAPB_RowID=:APBID)
 s RetCode=SQLCODE
 i RetCode'=0  d
 .s rett=$$ErrorRecord^DHCSTERROR("AuditAPB:in_adjpricebatch",APBID,SQLCODE_":"_%msg)
 .s RetCode=-1
 i RetCode'=0 d
 .trollback
 .d ..ULK(APBID)
 q:RetCode'=0 -201
 i PreExeDate=+$h d
 .s RetCode=..ExeAPB(APBID,GrpId,LocId,UserID)
 .i RetCode'=0 d
 ..trollback
 ..d ..ULK(APBID)
 q:RetCode'=0 -202
 tcommit
 d ..ULK(APBID)
 q RetCode
}

/// Descript：	更新批次调价记录生效
/// Creater：	zhouyg
/// CreateDate：2013-08-07
/// Input：		APBID-批次调价记录ID,UserID-审核人ID
/// Return：	0-正确，其他-错误
ClassMethod ExeAPB(APBID, GrpId, LocId, UserID)
{
 n (APBID,GrpId,LocId,UserID,PLIST)
 q:APBID="" -1
 q:'$d(^DHCSTINAPB(APBID)) -2
 ;过滤非药品数据
 s itmrowid=+$p(^DHCSTINAPB(APBID),"^",4)
 q:$p(##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(itmrowid),"^",3)'="G" -10
 s RetCode=..Select(APBID)
 q:RetCode'=0 -100
 s status="Y"
 s executeDate=$p($h,",",1)
 s executeTime="" //$p($h,",",2)
 s startUserDr=UserID
 s startDate=$p($h,",",1)
 s startTime=$p($h,",",2)
 //s RetCode=..Update()
 &sql(update in_adjpricebatch 
      set INAPB_Status=:status,
          INAPB_ExecuteDate=:executeDate,
          INAPB_ExecuteTime=:executeTime,
          INAPB_StartUser_dr=:UserID,
          INAPB_StartDate=:startDate,
          INAPB_StartTime=:startTime
      where INAPB_RowID=:APBID )
 s RetCode=SQLCODE
 q:RetCode'=0 RetCode
 
 //更新批次附加表价格 2020-04-09  yangsj
 s uom=$P(^DHCSTINAPB(APBID),"^",5)
 s uomRp=$P(^DHCSTINAPB(APBID),"^",7)
 s uomSp=$P(^DHCSTINAPB(APBID),"^",9)
 s BuomDr=$p(^INCI(+itmrowid,1),"^",10)
 s PuruomDr=$p(^INCI(+itmrowid,3),"^",6)
 s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(PuruomDr,BuomDr)
 i uom=BuomDr  d
 .s BRp=uomRp
 .s PurRp=uomRp*Fac
 .s BSp=uomSp
 .s PurSp=uomSp*Fac
 e  d
 .s BRp=uomRp/Fac
 .s PurRp=uomRp
 .s BSp=uomSp/Fac
 .s PurSp=uomSp
 s incib=$p(^DHCSTINAPB(APBID),"^",4)
 s dhcincib=$O(^DHCINCIB(0,"INCIB",incib,""))
 i dhcincib'=""  d
 .&sql(UPDATE DHC_IncItmBat SET INCIB_Rp=:BRp, INCIB_RpPuruom=:PurRp, INCIB_Sp=:BSp,INCIB_SpPuruom=:PurSp WHERE INCIB_INCIB_Dr=:incib)
 s RetCode=SQLCODE
 q:RetCode'=0 RetCode
 
 s remark=$p(^DHCSTINAPB(APBID),"^",31)
 s:remark'="入库生成" RetCode=..InsAspAmt(APBID,GrpId,LocId,UserID)  ;生成损益数据
 //插入收费项,yunhaibao20160422
 /*
 s tar=##class(web.DHCST.INCLINKTAR).GetTarItmIdByInc(itmrowid,+$h)
 i tar'=""  d
 .s AdjRow=APBID
 .s HospID=$p(^DHCSTINAPB(APBID),"^",1)
 .s resultsp=$p(^DHCSTINAPB(APBID),"^",13)
 .s err=$$AdjINCIPrice^DHCSTJFPRICE(itmrowid,executeDate,resultsp,$g(UserID),AdjRow,"",HospID)  //zdm,2012-05-25,执行不成功，导致事务总是回滚，暂时注释掉
 */
 q RetCode
}

/// Descript：	调价生效时计算调价损益
/// Creater：	zhouyg
/// CreateDate：2013-08-07
/// Table:		DHC_ASPAmount,Dhc_AspAmountLB
/// Input：		APBID-批次调价记录ID,UserID-审核人ID
/// Return：	0-正确，其他-错误
ClassMethod InsAspAmt(APBID, GrpId, LocId, UserID)
{
 n (APBID,GrpId,LocId,UserID)
 q:APBID="" -201
 q:'$d(^DHCSTINAPB(APBID)) -202 
 s INCIB=$p(^DHCSTINAPB(APBID),"^",4)
 q:INCIB="" -203
 s INCI=$o(^INCI("LB_IB",INCIB,""))
 q:INCI="" 0
 s priorp=$p(^DHCSTINAPB(APBID),"^",10)
 s resurp=$p(^DHCSTINAPB(APBID),"^",11)
 s priosp=$p(^DHCSTINAPB(APBID),"^",12)
 s resusp=$p(^DHCSTINAPB(APBID),"^",13)
 s AspBatNo=$p(^DHCSTINAPB(APBID),"^",2)
 s retstr=##class(web.DHCST.Common.AppCommon).GetParamCommon(GrpId,LocId,UserID)
 s GroupFlag=$p(retstr,"^",7)
 s HospID=$p(^DHCSTINAPB(APBID),"^",1)
 
 s InciUomEquelFlag = ##class(PHA.IN.COM.Method).CompInciUomIfEqual(INCI)
 s DFlag=$S(InciUomEquelFlag="Y":1,1:2) 
 s herbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(INCI) 
 s resurp=##class(web.DHCST.Common.AppCommon).FormatRp(resurp, HospID, DFlag,..sssCode(), herbFlag)
 s resusp=##class(web.DHCST.Common.AppCommon).FormatSp(resusp, HospID, DFlag,..sssCode(), herbFlag)
 
 S priosp=##class(web.DHCST.Common.AppCommon).FormatSp(priosp,HospID,DFlag,..sssCode(), herbFlag)  
 S priorp=##class(web.DHCST.Common.AppCommon).FormatRp(priorp,HospID,DFlag,..sssCode(), herbFlag)
 s spminus=resusp-priosp
 s rpminus=resurp-priorp
 s ILSub=0,RetCode=0
 f  s ILSub=$o(^INCI("LB_IB",INCIB,INCI,ILSub)) q:(ILSub="")!(RetCode'=0)  d
 .q:'$d(^INCI(INCI,"IL",ILSub))
 .s LocID=$p(^INCI(INCI,"IL",ILSub),"^",1)
 .q:(GroupFlag=2)&(HospID'=$P($G(^CTLOC(+LocID)),"^",22))
 .s LBSub=""
 .f  s LBSub=$o(^INCI("LB_IB",INCIB,INCI,ILSub,LBSub)) q:(LBSub="")!(RetCode'=0)  d
 ..s INCLB=INCI_"||"_ILSub_"||"_LBSub
 ..q:'$d(^INCI(INCI,"IL",ILSub,"LB",LBSub))
 ..s Date=+$h
 ..s qty=##CLASS(web.DHCST.Common.DrugStkCommon).QtyINCLB(INCLB,Date)
 ..q:qty=0
 ..s spamt=qty*spminus
 ..s rpamt=qty*rpminus
 ..S spamt=+##class(web.DHCST.Common.AppCommon).FormatSpAmt(spamt,HospID)
 ..S rpamt=+##class(web.DHCST.Common.AppCommon).FormatRpAmt(rpamt,HospID)
 ..q:(spamt=0)&&(rpamt=0)
 ..k PLIST
 ..s aspaNo=AspBatNo	//单号
 ..s aspaCtlocDR=LocID
 ..s aspaAdjPrice=spminus
 ..s aspaInciDR =INCI
 ..s aspaStkQty=qty
 ..s aspaAmount=spamt
 ..s aspaDate=+$h
 ..s aspaTime=$p($h,",",2)
 ..s aspaSSUSRDR=UserID
 ..s aspaAdjRP=rpminus
 ..s aspaRPAmt=rpamt
 ..s aspaINAPBDr=APBID
 ..s aspaINCLBDr=INCLB
 ..&sql(insert DHC_ASPAmount
       (ASPA_No,ASPA_CTLOC_DR,ASPA_AdjPrice,ASPA_INCI_DR,ASPA_StkQty,ASPA_Amount,
         ASPA_Date,ASPA_Time,ASPA_SSUSR_DR,ASPA_AdjRP,ASPA_RPAmt,ASPA_INAPB_Dr,
         ASPA_INCLB_Dr) 
        values(:aspaNo,:aspaCtlocDR,:aspaAdjPrice,:aspaInciDR,:aspaStkQty,:aspaAmount,
               :aspaDate,:aspaTime,:aspaSSUSRDR,:aspaAdjRP,:aspaRPAmt,:aspaINAPBDr,
               :aspaINCLBDr) )
 ..s RetCode=SQLCODE
 ..//s RetCode=$$Insert^DHCSTMVBASPAMOUNT()
 ..i RetCode'=0 d
 ...d SqlErrorRecord^DHCSTERROR("Insert:DHC_ASPAmount^DHCSTADJPRICE",SQLCODE,RetCode)
 ..q:RetCode'=0 
 ..s ASPAID=$p(%ROWID,$c(1))
 ..k PLIST
 ..s aspalbAspaParref=ASPAID
 ..s aspalbChildsub=$o(^ASPA(ASPAID,"LB",""),-1)+1
 ..s aspalbINCLBDR=INCLB
 ..s aspalbQty=qty
 ..s aspalbAdjDiff=spminus
 ..s aspalbAdjAmt=spamt
 ..s aspalbAdjRP=rpminus
 ..s aspalbRPAmt=rpamt
 ..s aspalbPriorRP=priorp
 ..//s obj=##class(User.DHCASPAmountLB).%New(ASPAID) //ERROR-UNDEFINED%%Construct+1-User.DHCInIsTrfItm.1 *%d(0)
 ..;b ;13
 ..//d obj.ASPALBASPAParref(ASPAID)
 ..&sql(insert DHC_ASPAmountLB
        (ASPALB_ASPA_Parref,ASPALB_Childsub,ASPALB_INCLB_DR,ASPALB_Qty,
         ASPALB_AdjDiff,ASPALB_AdjAmt,ASPALB_AdjRP,ASPALB_RPAmt,
         ASPALB_PriorRP)
      values(:aspalbAspaParref,:aspalbChildsub,:aspalbINCLBDR,:aspalbQty,
         :aspalbAdjDiff,:aspalbAdjAmt,:aspalbAdjRP,:aspalbRPAmt,
         :aspalbPriorRP) )
 
 ..//s RetCode=$$Insert^DHCSTMVBASPAMOUNTLB()
 ..s RetCode=SQLCODE
 ..i RetCode'=0 d
 ...d SqlErrorRecord^DHCSTERROR("Insert:DHC_ASPAmountLB^DHCSTADJPRICE",SQLCODE,RetCode)
 ..q:RetCode'=0
 q:RetCode'=0 -209
 q 0
}

/// Creator:    wyx
/// CreateDate: 2014-03-21
/// Table:in_adjsaleprice
/// Input:批次调价表id串，取消人id
/// Output:     
/// Return：0，成功；
ClassMethod CancelAudit(StrAspBatId, User) As %Library.String
{
    n (StrAspBatId, User)
    q:StrAspBatId="" -11 
    ;q:User="" -21
    ;
    s Err=0
    s Len=$l(StrAspBatId,"^")
    f i=1:1:Len q:Err'=0  d
    .s AspBatId=$p(StrAspBatId,"^",i)
    .q:AspBatId=""
    .s Err=..CancelAuditAPB(AspBatId,User)
    .
    ;
    q Err
}

/// Descript：	取消审核
/// Creater：	zhouyg
/// CreateDate：2013-08-07
/// Input：		APBID-批次调价记录ID,UserID-审核人ID
/// Return：	0-正确，其他-错误
ClassMethod CancelAuditAPB(APBID, UserID)
{
 n (APBID,UserID,PLIST)
 q:APBID="" -1
 q:'$d(^DHCSTINAPB(APBID)) -1
 q:..LK(APBID)<0 -100
 s status=$p(^DHCSTINAPB(APBID),"^",3)
 i status'="A" d ..ULK(APBID)
 q:status'="A" -101
 s RetCode=..Select(APBID)
 i RetCode'=0 d ..ULK(APBID)
 q:RetCode'=0 -102
 tstart 
 s status="N"
 s auditUser=UserID
 s auditDate=$p($h,",",1)
 s auditTime=$p($h,",",2)
 //s RetCode=..Update()
 &sql(update in_adjpricebatch 
      set INAPB_AuditUser=:auditUser,
          INAPB_AuditDate=:auditDate,
          INAPB_AuditTime=:auditTime,
          INAPB_Status=:status
      where INAPB_RowID=:APBID)
 
 i RetCode'=0 d
 .trollback
 .d ..ULK(APBID)
 q:RetCode'=0 -201
 tcommit
 d ..ULK(APBID)
 q RetCode
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
 //l +^DHCSTINAPB(APBID):1 e  q -1
 //q 0

 q:APBID="" 0
 q ##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_APBID)
}

/// 解锁
ClassMethod ULK(APBID)
{
  n (APBID)
  //l -^DHCSTINAPB(APBID)
  //q 0
 d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_APBID)
 q
}

ClassMethod Select(APBID)
{
 q:APBID="" -1
 k PLIST
 &sql(Select * Into :PLIST() From IN_AdjPriceBatch Where INAPB_RowID=:APBID)
 q SQLCODE
}

/// Descript:更新调后进价和售价（调价单(批次)审核或生效后需修改价格）
/// Creater:    ZhangDongmei
/// CreateDate: 2013-01-08
/// Table:IN_AdjPriceBatch
/// Input:APBID^调后售价^调后进价,APBID^调后售价^调后进价
/// Output: 
/// Return:0：成功，
ClassMethod BatUpdatePriceAPB(listData As %String, Params As %String) As %Library.String
{
    n (listData,Params)
    //s ^zdm("BatUpdatePrice")=listData_"||"_Params
    s AppName=..%GetParameter("AppName")
    q:listData="" -1
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    s err=0
    s gGroupId=$p(Params,"^",1)
    s gLocId=$p(Params,"^",2)
    s gUserId=$p(Params,"^",3)
    
    s $ZT="Error^DHCSTERROR"
    f i=1:1:len  q:err'=0  d
    .s data=$p(listData,rowDelim,i)
    .s APBID=$p(data,"^",1)
    .q:APBID=""
    .s status=$p(^DHCSTINAPB(APBID),"^",3)
    .s exedate=$p(^DHCSTINAPB(APBID),"^",16)
    .q:(status="Y")&(exedate'=+$h)   ;只允许修改当天生效的调价记录
    .tstart
    .//s err=..UpdatePrice(data)
    .s resultRp=$p(data,"^",3)
    .s resultSp=$p(data,"^",2)
    .//s RetCode=..Update()
    .&sql(update in_adjpricebatch 
      set INAPB_ResultRpUom=:resultRp,
          INAPB_ResultSpUom=:resultSp
      where INAPB_RowID=:APBID)
    .s err=SQLCODE
    .i err'=0 trollback
    .q:err'=0
    .;
    .i status="Y"  d
    ..s $p(^DHCSTINAPB(APBID),"^",3)="A"  ;修改状态，否则不允许重复生效
    ..s err=..ExeAPB(APBID,gGroupId,gLocId,gUserId)
    .i err'=0 trollback
    .q:err'=0
    .tcommit
    .
    q err
}

/// w ##class(web.DHCST.INAdjPriceBatch).SetExe("134","142^395^13609")
ClassMethod SetExe(APBIDStr, Params)
{
    n (APBIDStr,Params)
    //s ^YSJTMP("SetExe")=$LB(APBIDStr,Params)
    q:APBIDStr="" -11 
    ;q:User="" -21
    ;
    s Err=0
    s Len=$l(APBIDStr,"^")
    f i=1:1:Len q:Err'=0  d
    .s APBID=$p(APBIDStr,"^",i)
    .q:APBID=""
    .s Err=..SetExeAPB(APBID,Params)
    .
    ;
    q Err
}

/// Descript：	立即对批次调价记录生效
/// Creater：	zhouyg
/// CreateDate：2013-08-07
/// Input：		APBID-批次调价记录ID,UserID-审核人ID
/// Return：	0-正确，其他-错误
ClassMethod SetExeAPB(APBID, Params)
{
 n (APBID,Params,PLIST)
 q:APBID="" -1
  
 s gGroupId=$p(Params,"^",1)
 s gLocId=$p(Params,"^",2)
 s gUserId=$p(Params,"^",3)
 q:'$d(^DHCSTINAPB(APBID)) -2
 q:..LK(APBID)<0 -100
 s status=$p(^DHCSTINAPB(APBID),"^",3)
 i status'="A" d ..ULK(APBID)
 q:status'="A" -101
 tstart
 s RetCode=..ExeAPB(APBID,gGroupId,gLocId,gUserId)
 i RetCode'=0 d
 .trollback
 .d ..ULK(APBID)
 q:RetCode'=0 -102
 tcommit
 d ..ULK(APBID)
 q RetCode
}

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
 ..s RetCode=..SetExeAPB(APBID,"")
 q RetCode
}

/// Descript:   查询一段时间内的调价单(批次)
/// Creater:    ZhangDongmei
/// CreateDate: 2012-02-08
/// Table:in_adjpricebatch
/// Input:开始行，一页显示记录条数,调价单号,调价单状态
/// Output:     
/// Return：调价单信息
ClassMethod QueryAspBatNo(Start As %Integer, Limit As %Integer, StartDate As %String, EndDate As %String, Others As %String) As %Library.String
{
    n (Start, Limit,StartDate,EndDate,Others)
    s AspBatNo=$p(Others,"^",1)
    s Status=$p(Others,"^",2)
    s ItmRowid=$p(Others,"^",3)
    s StkGrpId=$p(Others,"^",4)
    q:StartDate="" ""
    q:EndDate="" ""
    s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
    s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    s:AspBatNo'="" AspBatNo=$$ALPHAUP^SSUTIL4(AspBatNo)
    s End=Start+Limit
    s Pid=..NewPid()
    ;
    Set Json = ##class(Code.JsonObj).%New()
    s Num=0
    ;
    s TmpStatus=0
    f  s TmpStatus=$o(^DHCSTINAPB(0,"STATUSDATE",TmpStatus)) q:TmpStatus=""  d
    .q:(Status'="")&(TmpStatus'=Status)
    .f Date=StartDate:1:EndDate  d
    ..s Time=""
    ..f  s Time=$o(^DHCSTINAPB(0,"STATUSDATE",TmpStatus,Date,Time))  q:Time=""  d
    ...s AspBatId=""
    ...f  s AspBatId=$o(^DHCSTINAPB(0,"STATUSDATE",TmpStatus,Date,Time,AspBatId))  q:AspBatId=""  d
    ....s Incib=$p(^DHCSTINAPB(AspBatId),"^",4)
    ....s InciId=+Incib
    ....q:InciId=""
    ....q:(ItmRowid'="")&(InciId'=ItmRowid)
    ....s TmpAspBatNo=$p(^DHCSTINAPB(AspBatId),"^",2)
    ....q:(AspBatNo'="")&(TmpAspBatNo'=AspBatNo)
    ....s TmpGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
    ....s StkType=$p(TmpGrpInfo,"^",3)
    ....q:StkType'=..sssCode()
    ....s TmpStkGrpId=$p(TmpGrpInfo,"^",5)
    ....q:(StkGrpId'="")&(TmpStkGrpId'=StkGrpId)
    ....s AdjDate=$p(^DHCSTINAPB(AspBatId),"^",19)  
    ....s AdjUserId=$p(^DHCSTINAPB(AspBatId),"^",18)
    ....s HospId=$p(^DHCSTINAPB(AspBatId),"^",1)            ;医院id
    ....s AuditUserId=$p(^DHCSTINAPB(AspBatId),"^",21)  
    ....;b
    ....s:AdjDate'="" AdjDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AdjDate,"ST")
    ....s:AdjUserId'="" AdjUserName=$p(^SSU("SSUSR",AdjUserId),"^",2)
    ....s:AuditUserId'="" AuditUserName=$p(^SSU("SSUSR",AuditUserId),"^",2)
    ....;b
    ....i '$d(^TMPASP(Pid,"ASPBAT",TmpAspBatNo))  d
    .....s ^TMPASP(Pid,"ASPBAT",TmpAspBatNo)=AdjDate_"^"_$g(AdjUserName)
    ....e  d
    .....s TmpAdjDate=$p(^TMPASP(Pid,"ASPBAT",TmpAspBatNo),"^",1)
    .....;最后一次更新人和更新日期
    .....i AdjDate>TmpAdjDate  d
    ......s ^TMPASP(Pid,"ASPBAT",TmpAspBatNo)=AdjDate_"^"_$g(AdjUserName)
    .....
    ....
    ...
    ..
    d OutPut
    s DetailStr=Json.getJsonData("AspBatNo^AspDate^AspUser",Num)
    k Json 
    k ^TMPASP(Pid,"ASPBAT") 
    Quit DetailStr

OutPut
 s Num=0
 s AspBatNo=""
 f  s AspBatNo=$o(^TMPASP(Pid,"ASPBAT",AspBatNo)) q:AspBatNo=""  d
 .s Num=Num+1
 .q:(Start'="")&(Num<=Start)     ;只返回当前页需要显示的记录
 .q:(Limit'="")&(Num>End)
 .s Data=^TMPASP(Pid,"ASPBAT",AspBatNo)
 .s Data=AspBatNo_"^"_Data
 .d Json.InsertRowData(Data)
 .
 q
}

/// Descript:   查询某一调价单信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-02-08
/// Table:in_adjsaleprice
/// Input:开始行，一页显示记录条数,调价单号,调价单状态
/// Output:     
/// Return：调价单信息
ClassMethod Query(Start As %Integer, Limit As %Integer, AspBatNo As %String, Status As %String, StkGrpId As %String, IncId As %String) As %Library.String
{
    n (Start, Limit,AspBatNo,Status,StkGrpId,IncId)
    q:AspBatNo="" ""
    s AspBatNo=$$ALPHAUP^SSUTIL4(AspBatNo)
    s End=Start+Limit
    ;
    Set Json = ##class(Code.JsonObj).%New()
    s Num=0
    ;
    s AspBatId=""
    f  s AspBatId=$o(^DHCSTINAPB(0,"ASPNO",AspBatNo,AspBatId))  q:AspBatId=""  d
    .s TmpStatus=$p(^DHCSTINAPB(AspBatId),"^",3)
    .q:(Status'="")&(TmpStatus'=Status)
    .s AdjDate=$p(^DHCSTINAPB(AspBatId),"^",19)  
    .s ExecuteDate=$p(^DHCSTINAPB(AspBatId),"^",16)
    .s AdjUserId=$p(^DHCSTINAPB(AspBatId),"^",21)
    .s Incib=$p(^DHCSTINAPB(AspBatId),"^",4)
    .s InciId=+Incib
    .q:InciId=""
    .q:(IncId'="")&(InciId'=IncId)
    .s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
    .s TmpStkGrpId=$p(StkGrpInfo,"^",5)
    .q:(StkGrpId'="")&(TmpStkGrpId'=StkGrpId)
    .s PriorSp=$p(^DHCSTINAPB(AspBatId),"^",12)      ;基本单位对应的价格
    .s ResultSp=$p(^DHCSTINAPB(AspBatId),"^",13)      ;基本单位对应的价格
    .s StkCatId=$p(^INCI(InciId,2),"^",2)
    .s AspUomId=$p(^DHCSTINAPB(AspBatId),"^",5)
    .s ResultSpUom=$p(^DHCSTINAPB(AspBatId),"^",9)   ;调价单位对应的调后售价
    .s ResultRpUom=$p(^DHCSTINAPB(AspBatId),"^",7)       ;调价单位对应的调后进价
    .//s WarrentNo=$p(^DHCSTINAPB(AspBatId),"^",27)    ;物价文件号
    .s Info=$o(^DHCITMINFO(0,"INCI",InciId,0))
    .s WarrentNo=$p($g(^DHCITMINFO(Info)),"^",33)    ;物价文件号
    .s WnoDate=$p(^DHCITMINFO(Info),"^",34)     ;物价文件备案日期
    .//s WnoDate=$p(^DHCSTINAPB(AspBatId),"^",28)         
    .s Remark=$p(^DHCSTINAPB(AspBatId),"^",31)      ;目前存调价原因
    .s PriorRp=$p(^DHCSTINAPB(AspBatId),"^",10)     ;基本单位对应的调前进价
    .s ResultRp=$p(^DHCSTINAPB(AspBatId),"^",11) ;基本单位对应的调后进价
    .s PreExecuteDate=$p(^DHCSTINAPB(AspBatId),"^",14)  ;计划生效日期
    .s HospId=$p(^DHCSTINAPB(AspBatId),"^",1)           ;医院id
    .s AuditUserId=$p(^DHCSTINAPB(AspBatId),"^",21)  
    .s CreatUserId=$p(^DHCSTINAPB(AspBatId),"^",18)  
    .s AdjUserName="",CreatUserName=""
    .s:AdjDate'="" AdjDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AdjDate,"ST")
    .s:ExecuteDate'="" ExecuteDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExecuteDate,"ST")
    .s:AdjUserId'="" AdjUserName=$p(^SSU("SSUSR",AdjUserId),"^",2)
    .s:CreatUserId'="" CreatUserName=$p(^SSU("SSUSR",CreatUserId),"^",2)
    .s InciCode=$p(^INCI(InciId,1),"^",1)
    .s InciDesc=$p(^INCI(InciId,1),"^",2)
    .s BUomId=$p(^INCI(InciId,1),"^",10)
    .s PurUomId=$p(^INCI(InciId,3),"^",6)
    .s StkCatDesc="",AspUomDesc=""
    .s:StkCatId'="" StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
    .s:AspUomId'="" AspUomDesc=$p(^CT("UOM",AspUomId),"^",2)
    .s:WnoDate'="" WnoDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(WnoDate,"ST")
    .s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(AspUomId,BUomId)
    .s PriorRpUom=PriorRp*ConFac
    .s PriorSpUom=PriorSp*ConFac
    .i AspUomId=BUomId d
    ..s PriorSpUom=##class(web.DHCST.Common.AppCommon).FormatSp(PriorSpUom,HospId,2)
    ..s PriorRpUom=##class(web.DHCST.Common.AppCommon).FormatRp(PriorRpUom,HospId,2)
    .e  d
    ..s PriorSpUom=##class(web.DHCST.Common.AppCommon).FormatSp(PriorSpUom,HospId,1)
    ..s PriorRpUom=##class(web.DHCST.Common.AppCommon).FormatRp(PriorRpUom,HospId,1)
    .
    .s:PreExecuteDate'="" PreExecuteDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PreExecuteDate,"ST")
    .s:AuditUserId'="" AuditUserName=$p(^SSU("SSUSR",AuditUserId),"^",2)
    .s DiffSpUom=ResultSpUom-PriorSpUom
    .s DiffRpUom=ResultRpUom-PriorRpUom
    .
    .s InfoId=$o(^DHCITMINFO(0,"INCI",InciId,0))
    .i InfoId'=""  d
    ..s MarkTypeId=$p(^DHCITMINFO(InfoId),"^",15)
    ..s:MarkTypeId'="" MarkTypeDesc=$p(^DHCINMT(MarkTypeId),"^",2)
    ..;s PriceFileNo=$p(^DHCITMINFO(InfoId),"^",33)
    ..s MaxSp=$p(^DHCITMINFO(InfoId),"^",16)
    .s ConFacPur=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId) 
    .s AdjReasonId=$p(^DHCSTINAPB(AspBatId),"^",29)
    .s:AdjReasonId'="" AdjReason=$p(^DHCSTREASON("ASP",AdjReasonId),"^",2) 
    .s:TmpStatus="N" TmpStatus="未审核"
    .s:TmpStatus="A" TmpStatus="已审核未生效"
    .s:TmpStatus="Y" TmpStatus="已生效"
    .s Data1=AspBatId_"^"_AspBatNo_"^"_TmpStatus_"^"_AdjDate_"^"_ExecuteDate_"^"_$g(AdjUserName)_"^"_InciId_"^"_InciCode
    .s Data2=InciDesc_"^"_$g(StkCatDesc)_"^"_AspUomId_"^"_$g(AspUomDesc)_"^"_PriorSpUom_"^"_ResultSpUom_"^"_DiffSpUom
    .s Data3=PriorRpUom_"^"_ResultRpUom_"^"_DiffRpUom_"^"_WarrentNo_"^"_WnoDate_"^"_Remark_"^"_$g(AuditUserName)_"^"_$g(MarkTypeDesc)
    .s Data4=$g(MaxSp)_"^"_PreExecuteDate_"^"_BUomId_"^"_PurUomId_"^"_ConFacPur_"^"_AdjReasonId_"^"_$g(AdjReason)_"^"_TmpStatus_"^"_$g(CreatUserName)
    .
    .s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4
    .s Num=Num+1
    .q:(Start'="")&(Num<=Start)     ;只返回当前页需要显示的记录
    .q:(Limit'="")&(Num>End)
    .
    .d Json.InsertRowData(Data)
    .
    s Title1="AspBatId^AspBatNo^TmpStatus^AdjDate^ExecuteDate^AdjUserName^InciId^InciCode"
    s Title2="InciDesc^StkCatDesc^AspUomId^AspUomDesc^PriorSpUom^ResultSpUom^DiffSpUom"
    s Title3="PriorRpUom^ResultRpUom^DiffRpUom^WarrentNo^WnoDate^Remark^AuditUserName"
    s Title4="MarkType^MaxSp^PreExecuteDate^BUomId^PurUomId^ConFacPur^AdjReason^AdjReasonDesc^Status^CreatUserName"
    s Title=Title1_"^"_Title2_"^"_Title3_"^"_Title4
    s DetailStr=Json.getJsonData(Title,Num)
    k Json 
    Quit DetailStr
}

/// Descript:取调价界面参数配置属性
/// Creater:    ZhangDongmei
/// CreateDate: 2012-12-27
/// Table:
/// Input:安全组id,科室id,用户id
/// Output:     
/// Return：是否根据定价类型计算售价
ClassMethod GetParamProp(GroupId As %String, LocId As %String, UserId As %String) As %Library.String
{
    n (GroupId,LocId,UserId)
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=..%GetParameter("AppName")
    s DefaRp=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"DefaRp",Param)
    s CalSpByMarkType=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"CalSpByMarkType",Param)
    s DefaAspReason=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"DefaAspReason",Param)
    s DefaPreExeDate=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"DefaPreExeDate",Param)
    q CalSpByMarkType_"^"_DefaAspReason_"^"_DefaPreExeDate
}

/// Description:通过调价表id判断今日是否有已经有生效的调价记录
/// Creator:yangsj
/// CreateDate:2020-01-15
/// Input:
/// Output:
/// w ##class(web.DHCST.INAdjPriceBatch).CheckIfHavenAdjDay(22)
ClassMethod CheckIfHavenAdjDay(APBID)
{
	 s ret="N" 
	 
	 q:'$d(^DHCSTINAPB(APBID)) ret
	 s Incib=$P(^DHCSTINAPB(APBID),"^",4)
	 s HospId=$P(^DHCSTINAPB(APBID),"^",1)
	 s TodayFlag=..CheckItmAspBatToday(Incib,HospId)
	 i TodayFlag=1 s ret="Y"		;该药品存在当天生效的调价单，不能再次调价
	 
	 q ret
}

/// Decription:更新调价单计划生效日期为明日
/// Creator:yangsj
/// CreateDate:2020-06-16
/// Input:date
/// Output:0 更新成功， 其他:更新失败
/// Table:
/// Debugger: w ##class(web.DHCST.INAdjPriceBatch).UpDateAspPreDate("2859^2861")
ClassMethod UpDateAspPreDate(inaspbStr)
{
	s ret=0
	q:inaspbStr="" ret
	s len=$l(inaspbStr,"^")
	s tomorrow=+$h+1
	ts
	f i=1:1:len q:ret'=0  d
	.s aspb=$P(inaspbStr,"^",i)
	.&sql(UPDATE IN_AdjPriceBatch SET INAPB_PreExeDate=:tomorrow WHERE INAPB_RowID=:aspb )
	.i SQLCODE'=0 s ret=SQLCODE
	.q:ret'=0
	
	i ret'=0 tro
	q:ret'=0 ret
	
	b ;tc
	tc
	q ret
}

}
