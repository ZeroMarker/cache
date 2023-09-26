Import sqluser

/// Descript:	批次调价
/// Creater:    liangjiaquan
/// CreateDate: 2018-11-07
Class web.DHCST.INAdjPriceAllBatch Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTADJSPBATCH";

/// Descript:   保存/更新调价单信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-04
/// Table:IN_AdjSalePrice
/// Input:调价单号,应用程序名称,rowid^计划生效日期^库存项id^调价单位id^调后售价^调后进价^操作人id^
/// 调价原因id^医院id^物价文件号^物价备案时间^备注^发票号^发票日期,rowid^计划生效日期^
/// 库存项id^调价单位id^调后售价^调后进价^操作人id^调价原因id^医院id
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
/// w ##class(web.DHCST.INAdjPriceAllBatch).Save("","",102,"^2015-12-23^858^69^21^21^590^1^2^^^^^^1^15")
ClassMethod Save(AdjNo As %String, GrpId As %String, LocId As %String, listData As %String) As %Library.String
{
    n (AdjNo,GrpId,LocId,listData)
    s AppName=..%GetParameter("AppName")
    s resultString=""
    i AdjNo=""  d
    .s AdjNo=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,GrpId,LocId)
    .s:+AdjNo<0 resultString=-3   
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    q:resultString'="" resultString
    s len=$l(listData,rowDelim)
    s err=0
    f i=1:1:len  q:err'=0  d
    .s data=$p(listData,rowDelim,i)
    .s rowid=$p(data,"^",1)
    .s inci=$p(data,"^",3)
    .s preexedate=$p(data,"^",2)
    .q:inci=""
    .q:preexedate=""
    .s:'$d(^INCI(inci)) err=-2
    .s incidesc=$p(^INCI(inci,1),"^",2)
    .q:err'=0
    .s data=$p(data,"^",2,$l(data,"^"))
    .
    .i rowid'=""  d
    ..s ret=..Update(rowid,data)
    ..s:ret'=0 err=ret
    .e  d
    ..s ret=..Insert(AdjNo,data)
    ..s:+ret<0 err=ret
    .
    q:err'=0 err_"^"_incidesc
    q AdjNo
}

/// Descript:   保存调价信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-02-06
/// Table:in_adjsaleprice
/// Input:调价单号，rowid^计划生效日期^库存项id^调价单位id^调后售价^调后进价^操作人id^
/// 调价原因id^医院id^物价文件号^物价备案时间^备注^发票号^发票日期
/// Output:     
/// Return：调价表rowid
ClassMethod Insert(AdjSpNo As %String, ListData As %String) As %Library.String
{
    n (AdjSpNo,ListData)       
    s AdjDate=+$h                           ;制单日期
    s ExecuteDate=$zdh("9999-12-31",3)
    s PreExecuteDate=$p(ListData,"^",1)     ;计划生效日期
    s:PreExecuteDate'="" PreExecuteDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(PreExecuteDate)
    s ItmRowid=$p(ListData,"^",2)
    s AdjUomId=$p(ListData,"^",3)
    s ResultSp=$p(ListData,"^",4)
    s ResultRp=$p(ListData,"^",5)
    s AdjUserId=$p(ListData,"^",6)
    s AdjReasonId=$p(ListData,"^",7)
    s HospId=$p(ListData,"^",8)
    s PriceFileNo=$p(ListData,"^",9)
    s WarNoDate=$p(ListData,"^",10)
    s:WarNoDate'="" WarNoDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(WarNoDate)
    s Remark="统一调所有批次价格" //$p(ListData,"^",11)
    s InvoNo=$p(ListData,"^",12)
    s InvoDate=$p(ListData,"^",13)
    s:InvoDate'="" InvoDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(InvoDate)
    //s:InvoNo'="" InvoNo=$tr(InvoNo,",","||")
    //s:InvoDate'="" InvoDate=$tr(InvoDate,",","||")
    s Status="No"      ;未审核
    s StkCatId=$p(^INCI(ItmRowid,2),"^",2)
    s resultString=""
    ;
    s Flag=..CheckItmAdjSp(ItmRowid,HospId)
    q:Flag=1 -5              ;该药品存在未生效的调价单，不能新建调价单
    // 保存数据调价信息时只判断是否计划生效日期大于今日，不判断今日是否有已生效的调价单  yangsj 2019-12-19
    q:PreExecuteDate<=+$H -9
    
    s BuomId=$p(^INCI(ItmRowid,1),"^",10)
    q:BuomId="" -6      ;基本单位不能为空
    s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(AdjUomId,BuomId)
    
    //调前进售价重新取值
    s PriorSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(ItmRowid,+$h,AdjUomId,HospId,"G","")  //insert 和update 保持一致都更新调前进售价
    s PriorRp=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(ItmRowid,+$h,AdjUomId,HospId,"G","")
    s BPriorSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(ItmRowid,+$h,BuomId,HospId,"G","")
    s BPriorRp=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(ItmRowid,+$h,BuomId,HospId,"G","")
    
    //调后进售价按8位截取
    s ResultSp=+$fn(ResultSp,"",8)
    s ResultRp=+$fn(ResultRp,"",8)
    s BResultSp=+ResultSp/ConFac
    s BResultRp=+ResultRp/ConFac
    s BResultSp=+$fn(BResultSp,"",8)
    s BResultRp=+$fn(BResultRp,"",8)
    
    ;插入调价记录
    &sql(insert into in_adjsaleprice(inasp_date,inasp_inci_dr,inasp_incsc_dr,inasp_priorsp,
    inasp_resultsp,inasp_ssusr_dr,inasp_status,inasp_no,INASP_ExecuteDate,inasp_ctuom_dr,inasp_ctuom_price,
    INASP_PriorRP,INASP_ResultRP,INASP_CTUOM_Rp,INASP_Hospital_Dr,INASP_WarrentNO,INASP_WNODate,
    INASP_PreExeDate,INASP_Remark,INASP_INVOICE,INASP_INVODATE,INASP_REASON_DR) 
    values(:AdjDate,:ItmRowid,:StkCatId,:BPriorSp,:BResultSp,:AdjUserId,:Status,:AdjSpNo,:ExecuteDate,
    :AdjUomId,:ResultSp,:BPriorRp,:BResultRp,:ResultRp,:HospId,:PriceFileNo,:WarNoDate,:PreExecuteDate,
    :Remark,:InvoNo,:InvoDate,:AdjReasonId) )
    s Err=0
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("InsertAsp:in_adjsaleprice",ItmRowid,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 -8    ;插入调价表失败
    s AspId=$p(%ROWID,$c(1))
    q AspId
}

/// Descript:   更新调价信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-04
/// Table:in_adjsaleprice
/// Input:明细id,计划生效日期^库存项id^调价单位id^调后售价^调后进价^操作人id^
/// 调价原因id^医院id^物价文件号^物价备案时间^备注
/// Output:     
/// Return：0:成功；错误代码
ClassMethod Update(AspRowid As %String, ListData As %String) As %Library.String
{
    n (AspRowid,ListData)       
    s AdjDate=+$h                           ;制单日期
    ;
    s PreExecuteDate=$p(ListData,"^",1)     ;计划生效日期
    s:PreExecuteDate'="" PreExecuteDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(PreExecuteDate)
    s AdjUomId=$p(ListData,"^",3)
    s ResultSp=$p(ListData,"^",4)
    s ResultRp=$p(ListData,"^",5)
    s AdjUserId=$p(ListData,"^",6)
    s AdjReasonId=$p(ListData,"^",7)
    s HospId=$p(ListData,"^",8)
    s PriceFileNo=$p(ListData,"^",9)
    s WarNoDate=$p(ListData,"^",10)
    s:WarNoDate'="" WarNoDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(WarNoDate)
    s Remark="统一调所有批次价格" //$p(ListData,"^",11)
    s InvoNo=$p(ListData,"^",12)
    s InvoDate=$p(ListData,"^",13)
    s:InvoDate'="" InvoDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(InvoDate)
    ;s:InvoNo'="" InvoNo=$tr(InvoNo,",","||")
    ;s:InvoDate'="" InvoDate=$tr(InvoDate,",","||")
    s resultString=""
    ;
    s Status=$p(^INASP(AspRowid),"^",9)
    q:Status'="No" -1   ;调价单已审核或已生效，不能修改
    ;
    s ItmRowid=$p(^INASP(AspRowid),"^",4)
    s BuomId=$p(^INCI(ItmRowid,1),"^",10)
    q:BuomId="" -5      ;基本单位不能为空
    s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(AdjUomId,BuomId)
    ;
    //调前进售价重新取值
    s PriorSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(ItmRowid,+$h,AdjUomId,HospId,"G","")  //insert 和update 保持一致都更新调前进售价
    s PriorRp=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(ItmRowid,+$h,AdjUomId,HospId,"G","")
    s BPriorSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(ItmRowid,+$h,BuomId,HospId,"G","")
    s BPriorRp=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(ItmRowid,+$h,BuomId,HospId,"G","")
    
    //调后进售价按8位截取
    s ResultSp=+$fn(ResultSp,"",8)
    s ResultRp=+$fn(ResultRp,"",8)
    s BResultSp=+ResultSp/ConFac
    s BResultRp=+ResultRp/ConFac
    s BResultSp=+$fn(BResultSp,"",8)
    s BResultRp=+$fn(BResultRp,"",8)
    ;
    ;更新调价记录
    &sql(update in_adjsaleprice set inasp_date=:AdjDate,inasp_priorsp=:BPriorSp,inasp_resultsp=:BResultSp,
    inasp_ssusr_dr=:AdjUserId,inasp_ctuom_dr=:AdjUomId,inasp_ctuom_price=:ResultSp,
    INASP_PriorRP=:BPriorRp,INASP_ResultRP=:BResultRp,INASP_CTUOM_Rp=:ResultRp,
    INASP_WarrentNO=:PriceFileNo,INASP_WNODate=:WarNoDate,INASP_PreExeDate=:PreExecuteDate,
    INASP_Remark=:Remark,INASP_INVOICE=:InvoNo,INASP_INVODATE=:InvoDate,INASP_REASON_DR=:AdjReasonId  
    where inasp_rowid=:AspRowid)
    s Err=0
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("UpdateAsp:in_adjsaleprice",AspRowid,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 Err    ;更新调价表失败
    q 0
}

/// Descript:   检查是否存在某库存项对应的未生效的调价单
/// Creater:    ZhangDongmei
/// CreateDate: 2012-02-06
/// Table:in_adjsaleprice
/// Input:库存项id
/// Output:     
/// Return：1：存在；0：不存在
ClassMethod CheckItmAdjSp(ItmRowid As %String, HospId As %String) As %Library.String
{
    n (ItmRowid,HospId)
    q:ItmRowid="" 0 
    s Flag=0
    s Flag=##class(web.DHCST.INAdjSalePrice).CheckItmAdjSp(ItmRowid,HospId)
    q:Flag=1 Flag
	s IB=0
	f  s IB=$o(^INCI(ItmRowid,"IB",IB)) q:(IB="")!(Flag=1)  d
	.s Incib=ItmRowid_"||"_IB
	.s Flag=##class(web.DHCST.INAdjPriceBatch).CheckItmAdjBatSp(Incib,HospId)
    q Flag
}

/// Descript:   检查是否存在某库存项对应的当天调价记录
/// Creater:    wangjiabin
/// CreateDate: 2013-06-25
/// Table:in_adjsaleprice
/// Input:库存项id
/// Output:     
/// Return：1：存在；0：不存在
ClassMethod CheckItmAspToday(ItmRowid As %String, HospId As %String) As %Library.String
{
    n (ItmRowid,HospId)
    q:ItmRowid="" 0 
    s Flag=0
    s Flag=##class(web.DHCST.INAdjSalePrice).CheckItmAspToday(ItmRowid,HospId)
    q:Flag=1 Flag
	s IB=0
	f  s IB=$o(^INCI(ItmRowid,"IB",IB)) q:(IB="")!(Flag=1)  d
	.s Incib=ItmRowid_"||"_IB
	.s Flag=##class(web.DHCST.INAdjPriceBatch).CheckItmAspBatToday(Incib,HospId)
    q Flag
}

/// Descript:   删除调价信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-04
/// Table:in_adjsaleprice
/// Input:明细id
/// Output:     
/// Return：0:成功；错误代码
ClassMethod Delete(AspRowid As %String) As %Library.String
{
    n (AspRowid)       
    q:AspRowid="" -1            ;rowid不能为空
    s Status=$p(^INASP(AspRowid),"^",9)
    q:Status'="No" -2    ;调价单已审核或已生效，不能删除
    ;删除调价记录
    s Err=0
    &sql(delete from in_adjsaleprice where inasp_rowid=:AspRowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("DeleteAspItm:in_adjsaleprice",AspRowid,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 -3    ;更新调价表失败
    q 0
}

/// Descript:   查询一段时间内的调价信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-02-13
/// Table:in_adjsaleprice
/// Input:开始行,一页显示记录条数,开始日期,截止日期,调价单号^调价单状态^库存项id^类组id^
/// Output:     
/// Return：调价单信息
/// w ##class(web.DHCST.INAdjPriceAllBatch).QueryAspInfo("0","999","2022-05-31","2022-06-01","XYK[KQ]KQXY01ASPBAT20220601001^No^^8^3")
ClassMethod QueryAspInfo(Start As %Integer, Limit As %Integer, StartDate As %String, EndDate As %String, Others As %String) As %Library.String
{
    n (Start, Limit,StartDate,EndDate,Others)
    //s ^PHATMP("MYQ",$this,"QueryAspInfo")=$lb(Start, Limit,StartDate,EndDate,Others)
    s AspNo=$p(Others,"^",1)
    s Status=$p(Others,"^",2)
    s ItmRowid=$p(Others,"^",3)
    s StkGrpId=$p(Others,"^",4)
    s hospid=$p(Others,"^",5)
    
    q:StartDate="" ""
    q:EndDate="" ""
    s GroupFlag=##Class(web.DHCSTCOMMPARA).GetGroupFlag()	//集团化标志
    s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
    s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    //s:AspNo'="" AspNo=$$ALPHAUP^SSUTIL4(AspNo)
    s End=Start+Limit
    //s:Status="" Status=0
    s Pid=..NewPid()
    ;
    Set Json = ##class(Code.JsonObj).%New()
    s Num=0
    ;
    i Status'=""  d
    .f Date=StartDate:1:EndDate  d
    ..s AspId=""
    ..f  s AspId=$o(^INASP(0,"DATESTATUS",Status,Date,AspId))  q:AspId=""  d
    ...d GetDetail(AspId)
    e  d
    .f  s Status=$o(^INASP(0,"DATESTATUS",Status)) q:Status=""  d
    ..f Date=StartDate:1:EndDate  d
    ...;b ;s
    ...s AspId=""
    ...f  s AspId=$o(^INASP(0,"DATESTATUS",Status,Date,AspId))  q:AspId=""  d
    ....d GetDetail(AspId)
    .
    ;
    s Title1="AspId^AspNo^Status^AdjDate^ExecuteDate^AdjUserName^InciId^InciCode"
    s Title2="InciDesc^StkCatDesc^AspUomId^AspUomDesc^PriorSpUom^ResultSpUom^DiffSpUom"
    s Title3="PriorRpUom^ResultRpUom^DiffRpUom^WarrentNo^WnoDate^Remark^AuditUserName"
    s Title4="MarkType^PriceFileNo^MaxSp^PreExecuteDate^BUomId^PurUomId^ConFacPur^AdjReasonId^AdjReason^InvNo"
    s Title5="InvDate^FreeDrugFlag"
    s Title=Title1_"^"_Title2_"^"_Title3_"^"_Title4_"^"_Title5
    s DetailStr=Json.getJsonData(Title,Num)
    k Json 
    Quit DetailStr

GetDetail(Rowid)
    s TmpStatus=$p(^INASP(Rowid),"^",9)
    s AdjDate=$p(^INASP(Rowid),"^",1)  
    s ExecuteDate=$p(^INASP(Rowid),"^",2)
    s AdjUserId=$p(^INASP(Rowid),"^",3)
    s InciId=$p(^INASP(Rowid),"^",4)
    q:InciId=""
    q:(ItmRowid'="")&(InciId'=ItmRowid)
    s TmpAspNo=$p(^INASP(Rowid),"^",5)
    q:(AspNo'="")&(TmpAspNo'=AspNo)
    s TmpGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
    s scgtype=$p(TmpGrpInfo,"^",3)
    q:scgtype'=..sssCode()
    s TmpStkGrpId=$p(TmpGrpInfo,"^",5)
    q:(StkGrpId'="")&(TmpStkGrpId'=StkGrpId)
    ;
    s PriorSp=$p(^INASP(Rowid),"^",6)      ;基本单位对应的价格
    s ResultSp=$p(^INASP(Rowid),"^",7)      ;基本单位对应的价格
    s StkCatId=$p(^INCI(InciId,2),"^",2)
    s AspUomId=$p(^INASP(Rowid),"^",10)
    s ResultSpUom=$p(^INASP(Rowid),"^",11)   ;调价单位对应的调后售价
    s ResultRpUom=$p(^INASP(Rowid),"^",14)       ;调价单位对应的调后进价
    s WarrentNo=$p(^INASP(Rowid),"^",12)    ;物价文件号
    s WnoDate=$p(^INASP(Rowid),"^",22)          ;物价文件备案日期
    s Remark=$p(^INASP(Rowid),"^",13)      ;目前存调价原因
    s PriorRp=$p(^INASP(Rowid),"^",15)     ;基本单位对应的调前进价
    s ResultRp=$p(^INASP(Rowid),"^",16) ;基本单位对应的调后进价
    s PreExecuteDate=$p(^INASP(Rowid),"^",17)  ;计划生效日期
    s HospId=$p(^INASP(Rowid),"^",20)           ;医院id
    q:(GroupFlag=2)&&(HospId'=hospid)&&(hospid'="")   //如果集团化标志为2时，则不能看到它院的调价数据 2020-02-05 yangsj
    s AuditUserId=$p(^INASP(Rowid),"^",21)  
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
    i TmpStatus="No" d
    .s TmpStatus="未审核"
    e  i TmpStatus="Audit"  d
    .s TmpStatus="已审核"
    e  i TmpStatus="Yes"  d
    .s TmpStatus="已生效"
    ;
    s InvNo=$p(^INASP(Rowid),"^",18) 
    s InvDate=$p(^INASP(Rowid),"^",19)
    s:InvDate'="" InvDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(InvDate,"ST")
    ;s:InvDate'="" InvDate=$zd(InvDate,3)	;目前INASP_INVODATE存的就是Y-m-d格式
    s AdjReasonId=$p(^INASP(Rowid),"^",28)
    s AdjReason=""
    s:AdjReasonId'="" AdjReason=$p(^DHCSTREASON("ASP",AdjReasonId),"^",2) 
    s arcimDr=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(InciId)
    s freeDrugFlag=##class(web.DHCST.Common.DrugInfoCommon).CheckIfFreeDrug(arcimDr)
    ;
    s DiffRpUom = $fn(DiffRpUom,"N")
    s DiffSpUom = $fn(DiffSpUom,"N")
    s Data1=Rowid_"^"_TmpAspNo_"^"_TmpStatus_"^"_AdjDate_"^"_ExecuteDate_"^"_$g(AdjUserName)_"^"_InciId_"^"_InciCode
    s Data2=InciDesc_"^"_$g(StkCatDesc)_"^"_AspUomId_"^"_$g(AspUomDesc)_"^"_PriorSpUom_"^"_ResultSpUom_"^"_DiffSpUom
    s Data3=PriorRpUom_"^"_ResultRpUom_"^"_DiffRpUom_"^"_WarrentNo_"^"_WnoDate_"^"_Remark_"^"_$g(AuditUserName)_"^"_$g(MarkTypeDesc)
    s Data4=$g(PriceFileNo)_"^"_$g(MaxSp)_"^"_PreExecuteDate_"^"_BUomId_"^"_PurUomId_"^"_ConFacPur_"^"_AdjReasonId_"^"_$g(AdjReason)_"^"_InvNo
    s Data5=InvDate_"^"_freeDrugFlag
    ;
    s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5
    s Num=Num+1
    q:(Start'="")&(Num<=Start)     ;只返回当前页需要显示的记录
    q:(Limit'="")&(Num>End)
    ;
    d Json.InsertRowData(Data)
    ;
    q
}

/// creator:zhangdongmei
/// date:2012-02-07
/// description:取药品相关信息
/// input: 库存项rowid,医院id
/// output:
/// others:调用界面：调价建单，
ClassMethod GetItmInfo(ItmRowid As %String, StrParam As %String) As %String
{
    n (ItmRowid,StrParam)
    q:ItmRowid="" ""
    q:'$d(^INCI(ItmRowid)) ""
    s GroupId=$p(StrParam,"^",1)
    s LocId=$p(StrParam,"^",2)
    s UserId=$p(StrParam,"^",3)
    s HospId=""
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Params=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
    s AppName=..%GetParameter("AppName")
    s StkCatId=$p(^INCI(ItmRowid,2),"^",2)
    s:StkCatId'="" StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
    s InciCode=$p(^INCI(ItmRowid,1),"^",1)
    s InciDesc=$p(^INCI(ItmRowid,1),"^",2)
    s InfoId=$o(^DHCITMINFO(0,"INCI",ItmRowid,0))
    i InfoId'=""  d
    .s MarkTypeId=$p(^DHCITMINFO(InfoId),"^",15)
    .s:MarkTypeId'="" MarkTypeDesc=$p(^DHCINMT(MarkTypeId),"^",2)
    .s PriceFileNo=$p(^DHCITMINFO(InfoId),"^",33)
    .s MaxSp=$p(^DHCITMINFO(InfoId),"^",16)
    .
    s BUomId=$p(^INCI(ItmRowid,1),"^",10)
    s PurUomId=$p(^INCI(ItmRowid,3),"^",6)
    s:BUomId'="" BUomDesc=$p(^CT("UOM",BUomId),"^",2)
    s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
    s PurSp=##class(web.DHCSTPRICE).GetSp(ItmRowid,+$h,PurUomId,HospId,"")
    s PurRp=##class(web.DHCSTPRICE).GetRp(ItmRowid,+$h,PurUomId,HospId,"")	//20141203 zhouyg
    //s PurRp=##class(web.DHCST.Common.PriceCommon).GetConfigRp(ItmRowid,PurUomId,AppName,Params)
    s ConFacPur=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
    ;
    s INFORowId=""
    s INFORowId=$o(^DHCITMINFO(0,"INCI",ItmRowid,INFORowId))
    s PrcFile=$p(^DHCITMINFO(INFORowId),"^",33)
    s PrcFileDate=$p(^DHCITMINFO(INFORowId),"^",34)
    s:PrcFileDate'="" PrcFileDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PrcFileDate)
    s arcimDr=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(ItmRowid)
    s freeDrugFlag=##class(web.DHCST.Common.DrugInfoCommon).CheckIfFreeDrug(arcimDr)
    s Data1=InciCode_"^"_InciDesc_"^"_StkCatId_"^"_$g(StkCatDesc)_"^"_$g(MarkTypeId)
    s Data2=$g(MarkTypeDesc)_"^"_BUomId_"^"_$g(BUomDesc)_"^"_PurUomId_"^"_$g(PurUomDesc)
    s Data3=$g(PriceFileNo)_"^"_PurSp_"^"_PurRp_"^"_$g(MaxSp)_"^"_ConFacPur
    s Data4=PrcFile_"^"_PrcFileDate_"^"_freeDrugFlag
    s resultString =Data1_"^"_Data2_"^"_Data3_"^"_Data4
    ;
    q "{""success"":""true"",""info"":"""_resultString_"""}"
}

/// Descript:	查询某一库存项的所有批次信息
/// Creater:	liangjiaquan
/// CreateDate:	2018-11-07
/// Input:		库存id^单位id^进价^售价
/// Others:w ##class(web.DHCST.INAdjPriceAllBatch).Batch(0,30,"","","")
ClassMethod Batch(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, StrParam As %String) As %String
{
	n (Start,Limit,Sort,Dir,StrParam)
	s ^ljq("Batch")=$lb(Start,Limit,Sort,Dir,StrParam)
	s InciDr=$p(StrParam,"^",1)
	s UomDr=$p(StrParam,"^",2)
	s ResultRp=$p(StrParam,"^",3)
	s ResultSp=$p(StrParam,"^",4)
	s UomDesc=$p(^CT("UOM",UomDr),"^",2)
	s count = 0
	s resultString = ""
	s end=Start+Limit
	s json = ##class(Code.JsonObj).%New()
	s IB=0
	f  s IB=$o(^INCI(InciDr,"IB",IB)) q:(IB="")!(IB=0)  d
	.s Incib=InciDr_"||"_IB
	.s IL=$o(^INCI("LB_IB",Incib,InciDr,0))
	.q:IL=""
	.s LB=$o(^INCI("LB_IB",Incib,InciDr,IL,0))
	.q:LB=""
	.s BatNo=$p(^INCI(InciDr,"IB",IB),"^",1)
 	.s ExpDate=+$p(^INCI(InciDr,"IB",IB),"^",2)
 	.i ExpDate'=0  d
 	..s Expire=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
 	.e  d
 	..s Expire=""
	.s Inclb=InciDr_"||"_IL_"||"_LB
	.s LocDr=$p(^INCI(InciDr,"IL",IL),"^",1)
	.s HospId=$p(^CTLOC(LocDr),"^",22)
	.s PriorRp=##class(web.DHCST.Common.PriceCommon).GetClbRp(Inclb,UomDr,HospId,"G",+$h,"")
	.s PriorSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inclb,+$h,UomDr,HospId,"G","")
	.s DifRp=ResultRp-PriorRp
	.s DifSp=ResultSp-PriorSp
	.s VendManf=##class(web.DHCST.Common.DrugStkCommon).VendManfByIncIb(Incib) //查找批次供应商及厂家
	.s PVenDesc=$p(VendManf,"^",2)
	.s PManf=$p(VendManf,"^",4)
	.s Data=Incib_"^"_BatNo_"^"_Expire_"^"_UomDesc_"^"_PriorRp_"^"_ResultRp_"^"_DifRp_"^"_PriorSp_"^"_ResultSp_"^"_DifSp_"^"_PManf_"^"_PVenDesc
	.s count = count+1
	.i (count>Start)&(count<=end) d
	..d json.InsertRowData(Data)
	s resultString = json.getJsonData("Incib^BatNo^ExpDate^UomDesc^PriorRp^ResultRp^DifRp^PriorSp^ResultSp^DifSp^PManf^PVenDesc",count)
	k json
	q resultString
}

/// Descript:调价单审核
/// Creater:    ZhangDongmei
/// CreateDate: 2012-02-13
/// Table:in_adjsaleprice
/// Input:调价表id1^调价表id2^调价表id3...,操作人id
/// Output:     
/// Return：0，成功；
ClassMethod Audit(StrAspId, AuditUserId) As %Library.String
{
    n (StrAspId,AuditUserId,%session)
    q:StrAspId="" -11 
    q:AuditUserId="" -21
    s Err=0
    s Len=$l(StrAspId,"^")
    f i=1:1:Len q:Err'=0  d
    .s AspId=$p(StrAspId,"^",i)
    .q:AspId=""
    .s Err=..SetAudit(AspId,AuditUserId)
    .
    q Err
}

/// Descript:调价单审核
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-20
/// Table:in_adjsaleprice
/// Input:调价表id,操作人id
/// Output:     
/// Return：0，成功；
/// -1  ;调价单已审核或已生效
/// -2   ;计划生效日期不能为空
/// -3  ;调价单已经过了计划生效日期，不能再审核
/// -4    ;更新调价单状态失败
/// -5    ;调价单生效失败
ClassMethod SetAudit(asp, audituser) As %Library.String
{
    n (asp,audituser,%session)
    s asp=+asp
    s status=$p(^INASP(asp),"^",9)
    q:status'="No" -1  ;调价单已审核或已生效
    s preexedate=$p(^INASP(asp),"^",17)
    q:preexedate="" -2   ;计划生效日期不能为空
    q:preexedate<+$h -3  ;调价单已经过了计划生效日期，不能再审核   
    s ret=..LK(asp)
    q:ret<0 -100
    s auditflag="Audit"
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理 
    ;更新调价单状态为已审核
    s auddate=+$h
    s audtime=$p($h,",",2)
    &sql(update in_adjsaleprice set inasp_status=:auditflag,INASP_AuditUser=:audituser,INASP_AuditDate=:auddate,INASP_Audittime=:audtime
    where inasp_rowid=:asp)
    s err=SQLCODE
    i err'=0 d
    .s rett=$$ErrorRecord^DHCSTERROR(..%GetParameter("AppName"),asp,SQLCODE_":"_%msg)
    i err'=0  trollback  d ..ULK(asp)
    q:err'=0 -4    ;更新调价单状态失败
    s ret1=0,ret2=0
    i preexedate=+$h d    ;计划生效日期为today时,自动生效。
    .s ret1=..Exe(asp)
    i ret1'=0 trollback  d ..ULK(asp)
	q:ret1'=0 -5    ;调价单生效失败
	tcommit
	d ..ULK(asp)
	q 0
}

/// Descript:调价单生效
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-20
/// Table:in_adjsaleprice
/// Input:调价表id
/// Output:     
/// Return：0，成功；
ClassMethod Exe(asp) As %Library.String
{
	;调价单生效
	n (asp,%session)
	s exedate=+$h
	s asp=+asp q:asp=0 -1
	;过滤非药品数据
	s itmrowid=$p($g(^INASP(asp)),"^",4)
	q:$p(##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(itmrowid),"^",3)'="G" -10
	s yes="Yes",no="No",audit="Audit"
	s status=$p($g(^INASP(asp)),"^",9)
	q:(status="") -2  ;状态为空
	q:(status=yes) -3  ;已经生效
	s appcode=..%GetParameter("AppName")
	tstart
	s $ZT="Error^DHCSTERROR"                       ;增加错误处理 
	s Err=0
	;更新调价单状态为已生效 
	&sql(update in_adjsaleprice set inasp_status=:yes,inasp_executedate=:exedate
	where inasp_rowid =:asp and inasp_status=:audit)
	i SQLCODE'=0  d
	.trollback
	.s ret=$$ErrorRecord^DHCSTERROR(appcode,asp,SQLCODE_":"_%msg)
	.s Err=-4
	q:Err'=0 Err
	s Ret=..InsertBatchByAsp(asp)   //生成批次调价记录
	i Ret'=0 trollback
	q:Ret'=0 -6
	tcommit
	q 0
}

/// 根据药品调价记录生成各批次调价记录
ClassMethod InsertBatchByAsp(Asp)
{
	n (Asp,%session)
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	s IncRowid=$p(^INASP(Asp),"^",4)  
	s PreExecuteDate=$p(^INASP(Asp),"^",17)
	i PreExecuteDate<+$h  s PreExecuteDate=+$H  //如果预生效日期小于今日，则默认为今日生效  2020-03-19 yangsj
	s AdjSpUomId=$p(^INASP(Asp),"^",10)
	s ResultSp=$p(^INASP(Asp),"^",11)
	s ResultRp=$p(^INASP(Asp),"^",14) 
	s userId=$p(^INASP(Asp),"^",3) 
	s AdjSpReasonId=$p(^INASP(Asp),"^",28)
	s HospId=$p(^INASP(Asp),"^",20)  
	s PriceFileNo=$p(^INASP(Asp),"^",12) 
	s PriceFileDate=$p(^INASP(Asp),"^",22) 
	s Remark=$p(^INASP(Asp),"^",13)
	s InputStr=""
	s IB=0
	f  s IB=$o(^INCI(IncRowid,"IB",IB)) q:IB=""  d
	.s Incib=IncRowid_"||"_IB
	.s IL=$o(^INCI("LB_IB",Incib,IncRowid,0))
	.q:IL=""
	.s LB=$o(^INCI("LB_IB",Incib,IncRowid,IL,0))
	.q:LB=""
	.s Inclb=IncRowid_"||"_IL_"||"_LB
	.s PriorRp=##class(web.DHCST.Common.PriceCommon).GetClbRp(Inclb,AdjSpUomId,HospId,"G",+$h,"")
	.s PriorSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inclb,+$h,AdjSpUomId,HospId,"G","")
	.s Str=""_"^"_Incib_"^"_PreExecuteDate_"^"_IncRowid_"^"_AdjSpUomId _"^"_ResultSp_"^"_ResultRp_"^"_userId_"^"_AdjSpReasonId_"^"_HospId_"^"_PriceFileNo_"^"_PriceFileDate_"^"_Remark_"^"_PriorRp_"^"_PriorSp
	.i InputStr=""  d
	..s InputStr=Str
	.e  d
	..s InputStr=InputStr_rowDelim_Str
	q:InputStr="" -101
	s LoginGrpID="",LoginLoc=""
	i $d(%session)  d
	.s LoginGrpID=%session.Data("LOGON.GROUPID")
	.s LoginLoc=%session.Data("LOGON.CTLOCID")
	s AdjBatchNo = ""
	i LoginLoc="" s AdjBatchNo=$p(^INASP(Asp),"^",5) //夜间任务， 登陆科室为空，无法生成单号
	s ret=##class(web.DHCST.INAdjPriceBatch).Save(AdjBatchNo,LoginGrpID,LoginLoc,InputStr,"Y")  
	i $l(ret,"^")>1  d
	.s err=-102
	e  i ret<0  d
	.s err=-103
	e  d
	.s err=0
	q:err'=0 err
	s AspNo=$$ALPHAUP^SSUTIL4(ret)
	s AspId="",AspIdStr=""
	f  s AspId=$o(^DHCSTINAPB(0,"ASPNO",AspNo,AspId)) q:AspId=""  d
	.i AspIdStr=""  d
	..s AspIdStr=AspId
	.e  d 
	..s AspIdStr=AspIdStr_"^"_AspId
	q:AspIdStr="" -104
	s Params=LoginGrpID_"^"_LoginLoc
	s ret=##class(web.DHCST.INAdjPriceBatch).Audit(AspIdStr,userId,Params)
	q:ret'=0 -105
	i PreExecuteDate>+$h d
	.s Params=LoginGrpID_"^"_LoginLoc_"^"_userId
	.s ret=##class(web.DHCST.INAdjPriceBatch).SetExe(AspIdStr,Params)
	q:ret'=0 -106
	q err
}

/// Creator:    wangjiabin
/// CreateDate: 2013-07-24
/// Table:in_adjsaleprice
/// Input:调价表id1^调价表id2^调价表id3...,操作人id
/// Output:     
/// Return：0，成功；
ClassMethod CancelAudit(StrAspId, User) As %Library.String
{
    n (StrAspId, User)
    q:StrAspId="" -11 
    s Err=0
    s Len=$l(StrAspId,"^")
    f i=1:1:Len q:Err'=0  d
    .s AspId=$p(StrAspId,"^",i)
    .q:AspId=""
    .s Err=..SetCancelAudit(AspId,User)
    .
    q Err
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
ClassMethod SetCancelAudit(asp, user) As %Library.String
{
    n (asp,user)
    s asp=+asp
    s status=$p(^INASP(asp),"^",9)
    q:status'="Audit" -1  ;调价单不是已审核状态 
    s ret=..LK(asp)
    q:ret<0 -100
    s auditflag="No"
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理 
    ;更新调价单状态为未审核
    &sql(update in_adjsaleprice set inasp_status=:auditflag,INASP_AuditUser=null,INASP_AuditDate=null,INASP_Audittime=null
    where inasp_rowid=:asp)
    s err=SQLCODE
    i err'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR(..%GetParameter("AppName"),asp,SQLCODE_":"_%msg)
    i err'=0  trollback  d ..ULK(asp)
    q:err'=0 -2    ;更新调价单状态失败
    tcommit
    d ..ULK(asp)
    q 0
}

/// Descript:调价单生效（立即生效）
/// Creater:    ZhangDongmei
/// CreateDate: 2013-01-07
/// Table:in_adjsaleprice
/// Input:调价表id1^调价表id2^调价表id3...
/// Output:     
/// Return：0，成功；
/// w ##class(web.DHCST.INAdjPriceAllBatch).SetExe("2810")
ClassMethod SetExe(StrAspId) As %Library.String
{
	//s ^YSJTMP("SetExe")=StrAspId
    n (StrAspId,%session)
    q:StrAspId="" -11 
    s Err=0
    s Len=$l(StrAspId,"^")
    f i=1:1:Len q:Err'=0  d
    .s AspId=$p(StrAspId,"^",i)
    .q:AspId=""
    .s Err=..Exe(AspId)
    .
    q Err
}

/// Descript:更新调后进价和售价（调价单审核或生效后需修改价格）
/// Creater:    ZhangDongmei
/// CreateDate: 2013-01-08
/// Table:IN_AdjSalePrice
/// Input:rowid^调后售价^调后进价,rowid^调后售价^调后进价
/// Output: 
/// Return:0：成功，
ClassMethod BatUpdatePrice(listData As %String) As %Library.String
{
    n (listData)
    ;s ^zdm("BatUpdatePrice")=listData
    s AppName=..%GetParameter("AppName")
    q:listData="" -1
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    s err=0
    s $ZT="Error^DHCSTERROR"
    f i=1:1:len  q:err'=0  d
    .s data=$p(listData,rowDelim,i)
    .s rowid=$p(data,"^",1)
    .q:rowid=""
    .s status=$p(^INASP(rowid),"^",9)
    .s exedate=$p(^INASP(rowid),"^",2)
    .q:status="Yes"   ;只允许修改未生效的调价记录
    .q:(status="Yes")&(exedate'=+$h)   ;只允许修改当天生效的调价记录
    .tstart
    .s err=..UpdatePrice(data)
    .;b ;err
    .i err'=0 trollback
    .q:err'=0
    .;
    .i status="Yes"  d
    ..s $p(^INASP(rowid),"^",9)="Audit"  ;修改状态，否则不允许重复生效
    ..s err=..Exe(rowid)
    .i err'=0 trollback
    .q:err'=0
    .tcommit
    .
    q err
}

/// Descript:   更新调后价格（调价审核或生效后需要修改价格）
/// Creater:    ZhangDongmei
/// CreateDate: 2013-01-08
/// Table:in_adjsaleprice
/// Input:明细id^调后售价^调后进价
/// Output:     
/// Return：0:成功；错误代码
ClassMethod UpdatePrice(ListData As %String) As %Library.String
{
    n (ListData)       
    s AdjDate=+$h                           ;制单日期
    s Rowid=$p(ListData,"^",1)
    s ResultSp=$p(ListData,"^",2)
    s ResultRp=$p(ListData,"^",3)
    q:Rowid="" -1
    ;
    s InciId=$p(^INASP(Rowid),"^",4)
    q:InciId="" -1
    s AdjUomId=$p(^INASP(Rowid),"^",10)
    s BuomId=$p(^INCI(InciId,1),"^",10)
    q:BuomId="" -5      ;基本单位不能为空
    s HospId=$p(^INASP(Rowid),"^",20)           ;医院id
    i AdjUomId=BuomId d
    .s ResultSp=##class(web.DHCST.Common.AppCommon).FormatSp(ResultSp,HospId,2)
    .s ResultRp=##class(web.DHCST.Common.AppCommon).FormatRp(ResultRp,HospId,2)
    e  d
    .s ResultSp=##class(web.DHCST.Common.AppCommon).FormatSp(ResultSp,HospId,1)
    .s ResultRp=##class(web.DHCST.Common.AppCommon).FormatRp(ResultRp,HospId,1)
    .
    s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(AdjUomId,BuomId)
    s BResultSp=+ResultSp/ConFac
    s BResultRp=+ResultRp/ConFac
    s BResultSp=##class(web.DHCST.Common.AppCommon).FormatSp(BResultSp,HospId,2)
    s BResultRp=##class(web.DHCST.Common.AppCommon).FormatRp(BResultRp,HospId,2)
    ;
    ;更新调价记录
    &sql(update in_adjsaleprice set inasp_resultsp=:BResultSp,inasp_ctuom_price=:ResultSp,
    INASP_ResultRP=:BResultRp,INASP_CTUOM_Rp=:ResultRp    
     where inasp_rowid=:Rowid)
    s Err=0
    ;b ;0
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR(..%GetParameter("AppName"),Rowid,SQLCODE_":"_$g(%msg))
    .s Err=-1
    q:Err'=0 Err    ;更新调价表失败
    q 0
}

/// Descript:调价单生效
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-20
/// Table:in_adjsaleprice
/// Input:调价表id
/// Output:     
/// Return：0，成功；
ClassMethod NightRunAspAmount() As %Library.String
{
	;create the asp amount at night-run where the time is after 0:00
	;此routine只能在0点之后执行
	;
	s today=+$h ;生效日期为今天
	s auditflag="Audit"
	&sql(declare curnightasp cursor for 
	select inasp_rowid From  in_adjsaleprice where INASP_PreExeDate=:today
	and inasp_status=:auditflag)  ;已经审核
	&sql(open curnightasp)
	s result=0
	f  &sql(fetch curnightasp into :inasprowid) q:SQLCODE  d
	.s result=0
	.s result=..Exe(+inasprowid)
	.
	.q:result'=0
	.;i $$InsertAspAmount^DHCSTASP(inasprowid)<0  s result=-1  q
	&sql(close curnightasp)
	q
}

ClassMethod LK(asp) As %Library.String
{
    n (asp)
    q:asp="" 0
 	q ##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_asp)
}

ClassMethod ULK(asp) As %Library.String
{
    d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_asp)
 	q
}

ClassMethod NewPid() As %String
{
	q $I(^DHCSTPID("AdjPriceAllBatch"))
}

/// Description:通过调价表id判断今日是否有已经有生效的调价记录
/// Creator:yangsj
/// CreateDate:2020-01-14
/// Input:
/// Output:
/// w ##class(web.DHCST.INAdjPriceAllBatch).CheckIfHavenAdjDay(AspIdStr)
ClassMethod CheckIfHavenAdjDay(asp)
{
	 s ret="N" 
	 q:'$d(^INASP(asp)) ret
	 s HospID=$p(^INASP(asp),"^",20)
	 s inci=$p(^INASP(asp),"^",4)
	 s TodayFlag=..CheckItmAspToday(inci,HospID)
     i TodayFlag=1  s ret="Y"				;该药品存在当天生效的调价单，不能再次调价
	 
	 q ret
}

}
