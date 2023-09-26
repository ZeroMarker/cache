Import sqluser

/// Descript:调价
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-04
Class web.DHCST.INAdjSalePrice Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTADJSP";

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
/// w ##class(web.DHCST.INAdjSalePrice).Save("XYASP20210128002","3","165","4569^29/01/2021^2080^4^56.224^56.222^13609^5^2^^^^^^56.222^56.22")
ClassMethod Save(AdjNo As %String, GrpId As %String, LocId As %String, listData As %String) As %Library.String
{
    n (AdjNo,GrpId,LocId,listData)
    //s ^YSJTMP("Save")=$LB(AdjNo,GrpId,LocId,listData)
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
    s GroupFlag=##Class(web.DHCSTCOMMPARA).GetGroupFlag() //yunhaibao20151222,集团化分管价格时按院区判断是否存在
    i GroupFlag'=2 d
    .s ExeDate=""
    .f  s ExeDate=$o(^INASP(0,"INCI",ItmRowid,ExeDate))  q:ExeDate=""  d
    ..s AspId=""
    ..f  s AspId=$o(^INASP(0,"INCI",ItmRowid,ExeDate,AspId)) q:AspId=""  d
    ...s Status=$p(^INASP(AspId),"^",9)
    ...q:Status="Yes"    ;已生效
    ...s Flag=1
    e  d
    .I HospId'="" D
    ..s ExeDate=""
    ..f  s ExeDate=$o(^INASP(0,"HOSPI",HospId,ItmRowid,ExeDate)) q:ExeDate=""  d
    ...s AspId=""
    ...f  s AspId=$o(^INASP(0,"HOSPI",HospId,ItmRowid,ExeDate,AspId)) q:AspId=""  d
    ....s Status=$p(^INASP(AspId),"^",9)
    ....q:Status="Yes"    ;已生效
    ....s Flag=1
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
    s GroupFlag=##Class(web.DHCSTCOMMPARA).GetGroupFlag()
    s ExeDate=+$h+1
    i GroupFlag'=2 d
    .f  s ExeDate=$o(^INASP(0,"INCI",ItmRowid,ExeDate),-1)  q:ExeDate=""  d
    ..i ExeDate=+$h d
    ...s Flag=1
    e  d
    .I HospId'="" D
    ..s ExeDate=""
    ..f  s ExeDate=$o(^INASP(0,"HOSPI",HospId,ItmRowid,ExeDate),-1) q:ExeDate=""  d
    ...i ExeDate=+$h d
    ....s Flag=1
    q Flag
}

/// Descript:   保存调价信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-02-06
/// Table:in_adjsaleprice
/// Input:调价单号，rowid^计划生效日期^库存项id^调价单位id^调后售价^调后进价^操作人id^
/// 调价原因id^医院id^物价文件号^物价备案时间^备注^发票号^发票日期
/// Output:     
/// Return：调价表rowid
ClassMethod Insert(AdjSpNo As %String, ListData As %String, ingdFlag As %String = "") As %Library.String
{
    n (AdjSpNo,ListData,ingdFlag)       
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
    s Remark=$p(ListData,"^",11)
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
    //q:Flag=1 -5              ;该药品存在未生效的调价单，不能新建调价单
    q:(ingdFlag'="Y")&&(Flag=1) -5  ;入库自动调价时不判断是否有未生效的调价单 2020-12-18 yangsj
    
    // 保存数据调价信息时只判断是否计划生效日期大于今日，不判断今日是否有已生效的调价单  yangsj 2019-12-19
    // 如果是入库制单自动调价则不判断计划生效日期 
    q:(ingdFlag'="Y")&&(PreExecuteDate<=+$H) -9
    
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
    s Remark=$p(ListData,"^",11)
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
    //s PriorSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(ItmRowid,+$h,AdjUomId,HospId)
    s BuomId=$p(^INCI(ItmRowid,1),"^",10)
    q:BuomId="" -5      ;基本单位不能为空
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
    //调后进售价不做处理，多少位就保留多少位
    /*
    i AdjUomId=BuomId d
    .s ResultSp=##class(web.DHCST.Common.AppCommon).FormatSp(ResultSp,HospId,2)
    .s ResultRp=##class(web.DHCST.Common.AppCommon).FormatRp(ResultRp,HospId,2)
    e  d
    .s ResultSp=##class(web.DHCST.Common.AppCommon).FormatSp(ResultSp,HospId,1)
    .s ResultRp=##class(web.DHCST.Common.AppCommon).FormatRp(ResultRp,HospId,1)
    .*/
    
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
    ;
    q:AspRowid="" -1            ;rowid不能为空
    s Status=$p(^INASP(AspRowid),"^",9)
    q:Status'="No" -2    ;调价单已审核或已生效，不能删除
    ;
    ;
    ;删除调价记录
    s Err=0
    &sql(delete from in_adjsaleprice where inasp_rowid=:AspRowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("DeleteAspItm:in_adjsaleprice",AspRowid,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 -3    ;更新调价表失败
    q 0
}

/// Descript:   查询某一调价单信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-02-08
/// Table:in_adjsaleprice
/// Input:开始行，一页显示记录条数,调价单号,调价单状态
/// Output:     
/// Return：调价单信息
ClassMethod Query(Start As %Integer, Limit As %Integer, AspNo As %String, Status As %String, StkGrpId As %String, IncId As %String, Sort As %String = "", Dir As %String = "") As %Library.String
{
    n (Start, Limit,AspNo,Status,StkGrpId,IncId,Sort,Dir)
    q:AspNo="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s AspNo=$$ALPHAUP^SSUTIL4(AspNo)
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="ASC"
    s End=Start+Limit
    s Start=Start+1
    s CountRecords=0
    s Pid=..NewPid()
    s $zt="ErrorQuery"
    s AspId=""
    f  s AspId=$o(^INASP(0,"ASPNO",AspNo,AspId))  q:AspId=""  d
    .s TmpStatus=$p(^INASP(AspId),"^",9)
    .q:(Status'="")&(TmpStatus'=Status)
    .s AdjDate=$p(^INASP(AspId),"^",1)  
    .s ExecuteDate=$p(^INASP(AspId),"^",2)
    .s AdjUserId=$p(^INASP(AspId),"^",3)
    .s InciId=$p(^INASP(AspId),"^",4)
    .q:InciId=""
    .q:(IncId'="")&(InciId'=IncId)
    .s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
    .s TmpStkGrpId=$p(StkGrpInfo,"^",5)
    .q:(StkGrpId'="")&(TmpStkGrpId'=StkGrpId)
    .s PriorSp=$p(^INASP(AspId),"^",6)      ;基本单位对应的价格
    .s ResultSp=$p(^INASP(AspId),"^",7)     ;基本单位对应的价格
    .s StkCatId=$p(^INCI(InciId,2),"^",2)
    .s AspUomId=$p(^INASP(AspId),"^",10)
    .s ResultSpUom=$p(^INASP(AspId),"^",11)   ;调价单位对应的调后售价
    .s ResultRpUom=$p(^INASP(AspId),"^",14)       ;调价单位对应的调后进价
    .s WarrentNo=$p(^INASP(AspId),"^",12)    ;物价文件号
    .s WnoDate=$p(^INASP(AspId),"^",22)         ;物价文件备案日期
    .s Remark=$p(^INASP(AspId),"^",13)      ;目前存调价原因
    .s PriorRp=$p(^INASP(AspId),"^",15)     ;基本单位对应的调前进价
    .s ResultRp=$p(^INASP(AspId),"^",16)    ;基本单位对应的调后进价
    .s PreExecuteDate=$p(^INASP(AspId),"^",17)  ;计划生效日期
    .s HospId=$p(^INASP(AspId),"^",20)          ;医院id
    .s AuditUserId=$p(^INASP(AspId),"^",21)  //审核人
    .s CreatUserId=$p(^INASP(AspId),"^",3)   //建单人
    .s StartUserId=$p(^INASP(AspId),"^",30) //生效人
    .s:AdjDate'="" AdjDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AdjDate,"ST")
    .s:ExecuteDate'="" ExecuteDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExecuteDate,"ST")
    .s:AdjUserId'="" AdjUserName=$p(^SSU("SSUSR",AdjUserId),"^",2)
    .s:CreatUserId'="" CreatUserName=$p(^SSU("SSUSR",CreatUserId),"^",2)
    .s:StartUserId'="" StartUserName=$p(^SSU("SSUSR",StartUserId),"^",2)
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
    .s:PreExecuteDate'="" PreExecuteDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PreExecuteDate,"ST")
    .s:AuditUserId'="" AuditUserName=$p(^SSU("SSUSR",AuditUserId),"^",2)
    .s DiffSpUom=$fn(ResultSpUom-PriorSpUom, "N")
    .s DiffRpUom=$fn(ResultRpUom-PriorRpUom, "N")
    .s InfoId=$o(^DHCITMINFO(0,"INCI",InciId,0))
    .i InfoId'=""  d
    ..s MarkTypeId=$p(^DHCITMINFO(InfoId),"^",15)
    ..s:MarkTypeId'="" MarkTypeDesc=$p($g(^DHCINMT(MarkTypeId)),"^",2)
    ..;s PriceFileNo=$p(^DHCITMINFO(InfoId),"^",33)
    ..s MaxSp=$p(^DHCITMINFO(InfoId),"^",16)
    .s ConFacPur=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
    .s InvNo=$p(^INASP(AspId),"^",18) 
    .s InvDate=$p(^INASP(AspId),"^",19)
    .s AdjReasonId=$p(^INASP(AspId),"^",28)
    .s:AdjReasonId'="" AdjReason=$p($g(^DHCSTREASON("ASP",AdjReasonId)),"^",2) 
    .s:TmpStatus="No" TmpStatus="未审核"
    .s:TmpStatus="Audit" TmpStatus="已审核未生效"
    .s:TmpStatus="Yes" TmpStatus="已生效"
    .s Data1=AspId_"^"_AspNo_"^"_TmpStatus_"^"_AdjDate_"^"_ExecuteDate_"^"_$g(AdjUserName)_"^"_InciId_"^"_InciCode
    .s Data2=InciDesc_"^"_$g(StkCatDesc)_"^"_AspUomId_"^"_$g(AspUomDesc)_"^"_PriorSpUom_"^"_ResultSpUom_"^"_DiffSpUom
    .s Data3=PriorRpUom_"^"_ResultRpUom_"^"_DiffRpUom_"^"_WarrentNo_"^"_WnoDate_"^"_Remark_"^"_$g(AuditUserName)_"^"_$g(MarkTypeDesc)
    .s Data4=$g(MaxSp)_"^"_PreExecuteDate_"^"_BUomId_"^"_PurUomId_"^"_ConFacPur_"^"_InvNo_"^"_InvDate_"^"_AdjReasonId_"^"_$g(AdjReason)_"^"_TmpStatus_"^"_CreatUserName
    .s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4
    .s CountRecords=CountRecords+1
    .s Index=1
    .i Sort="TmpStatus" s Index=TmpStatus
    .e  i Sort="AdjUserName" s Index=AdjUserName
    .e  i Sort="InciDesc" s Index=InciDesc
    .e  i Sort="StkCatDesc" s Index=StkCatDesc
    .e  i Sort="PriorSpUom" s Index=PriorSpUom
    .e  i Sort="ResultSpUom" s Index=ResultSpUom
    .e  i Sort="DiffSpUom" s Index=DiffSpUom
    .e  i Sort="PriorRpUom" s Index=PriorRpUom
    .e  i Sort="ResultRpUom" s Index=ResultRpUom
    .e  i Sort="DiffRpUom" s Index=DiffRpUom
    .e  i Sort="AdjReasonId" s Index=AdjReasonId
    .e  i Sort="Remark" s Index=Remark
    .i Index="" s Index=1
    .s ^TMP("DHCST","INAdjSalePrice","Query",Pid,Index,CountRecords)=Data
    s Title1="AspId^AspNo^TmpStatus^AdjDate^ExecuteDate^AdjUserName^InciId^InciCode"
    s Title2="InciDesc^StkCatDesc^AspUomId^AspUomDesc^PriorSpUom^ResultSpUom^DiffSpUom"
    s Title3="PriorRpUom^ResultRpUom^DiffRpUom^WarrentNo^WnoDate^Remark^AuditUserName^MarkType"
    s Title4="MaxSp^PreExecuteDate^BUomId^PurUomId^ConFacPur^InvoNo^InvoDate^AdjReason^AdjReasonDesc^Status^CreatUserName"
    s Title=Title1_"^"_Title2_"^"_Title3_"^"_Title4
    i Dir="DESC" s orderflag="-1"
    e  s orderflag="1"
    i End>CountRecords s End=CountRecords
    s count=0
    s outputi=""
    f  s outputi=$o(^TMP("DHCST","INAdjSalePrice","Query",Pid,outputi),orderflag) q:outputi=""  d 
    .s outputj=""
    .f  s outputj=$o(^TMP("DHCST","INAdjSalePrice","Query",Pid,outputi,outputj),orderflag) q:outputj=""  d 
    ..s count=count+1
    ..q:count<Start
    ..q:count>End
    ..s outputdata=^TMP("DHCST","INAdjSalePrice","Query",Pid,outputi,outputj)
    ..i count=Start d
    ...w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(CountRecords)
    ...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
    ...w retstring
    ..e  d
    ...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
    ...w ","_retstring
    i count=0 w ##class(web.DHCSTEXTCOMMON).GetNoJson()
    q:count=0 ""
    w "]}"
    k ^TMP("DHCST","INAdjSalePrice","Query",Pid)
    Quit ""
ErrorQuery
    k ^TMP("DHCST","INAdjSalePrice","Query",Pid)
    q $ze
}

/// Descript:   保存三大项新增项目的价格信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-20
/// Table:in_adjsaleprice
/// Input:库存项id,售价,操作人id,入库单位id,进价,医院id,模块名字，单号前缀
/// 物价文件号^物价备案时间^物价生效日期
/// Output:     
/// Return：调价表rowid
ClassMethod CreateAdjspFromNewitm1(ItmRowid, Sp, UserId, PurUomId, Rp, AppName, HospID = "", WarrentInfo = "") As %Library.String
{
     n (ItmRowid,Sp,UserId,PurUomId,Rp,AppName,HospID,WarrentInfo)  
    
     ;s ^zdm("zdm")=WarrentInfo   
     s AdjDate=$p($h,",",1)         ;调价日期
     q:ItmRowid="" -1           ;库存项不能为空
     q:'$d(^INCI(ItmRowid)) -2      ;无效的库存项
     q:PurUomId="" -3           ;单位不能为空
     q:'$d(^CT("UOM",PurUomId)) -4  ;无效的单位
     ;
     s resultString=""
     s StkCatId=$p(^INCI(ItmRowid,2),"^",2)
     s PriorSp=0
     s PriorRp=0
     s BuomId=$p(^INCI(ItmRowid,1),"^",10)
     q:BuomId="" -5     ;基本单位不能为空
     s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BuomId)
     s ResultSp=+Sp/ConFac
     s ResultRp=+Rp/ConFac
     s Status="No"
     s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(ItmRowid)
     s StkGrpId=$p(StkGrpInfo,"^",5)
     ;
     ;生成调价单号    
     s tmpLoc = $o(^CTLOC(0,"Hosp",HospID,""))
     s BillNo=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,StkGrpId,tmpLoc)
     q:BillNo="" -7   ;生成调价单号失败
     ;
     ;
     s WarrentNo=$p(WarrentInfo,"^",1)
     s WarNoDate=$p(WarrentInfo,"^",2)
     s PreExDate=$p(WarrentInfo,"^",3)
     i WarNoDate'=""  s WarNoDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(WarNoDate)
     i PreExDate'=""  s PreExDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(PreExDate)
     i (PreExDate="")||(PreExDate<+$h)  d
     .s PreExDate=+$h           //zdm,2011-05-26,计划生效日期为空的话默认为当天
     s ExecuteDate=$zdh("9999-12-31",3)
     ;插入调价记录
     tstart
     s $ZT="Error^DHCSTERROR"                       ;增加错误处理
     &sql(insert into in_adjsaleprice(inasp_date,inasp_inci_dr,inasp_incsc_dr,inasp_priorsp,
     inasp_resultsp,inasp_ssusr_dr,inasp_status,inasp_no,inasp_ctuom_dr,inasp_ctuom_price,
     INASP_PriorRP,INASP_ResultRP,INASP_CTUOM_Rp,INASP_Hospital_Dr,INASP_WarrentNO,INASP_WNODate,
     INASP_PreExeDate,INASP_ExecuteDate) 
      values(:AdjDate,:ItmRowid,:StkCatId,:PriorSp,:ResultSp,:UserId,:Status,:BillNo,
      :PurUomId,:Sp,:PriorRp,:ResultRp,:Rp,:HospID,:WarrentNo,:WarNoDate,:PreExDate,:ExecuteDate) )
     i SQLCODE'=0  d
     .trollback
     .s rett=$$ErrorRecord^DHCSTERROR("CreateAdjspFromNewitm1:in_adjsaleprice",ItmRowid,SQLCODE_":"_%msg)
     .s resultString= -8   ;插入调价表失败
     .
     q:resultString'="" resultString
     s AspId=$p(%ROWID,$c(1))
     ;自动审核调价单
     b ;111
     s ret=..SetAudit(AspId,UserId)   //$$Audit(%ROWID) zdm，2011-05-26,改为同调价审核调用一样，原调用有问题(没考虑调价生效日期)
     b ;112
     i ret'=0  d
     .trollback
     .s resultString=-9  ;执行审核操作失败
     q:ret'=0 resultString
     tcommit
     q AspId
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
    n (StrAspId, AuditUserId)
    q:StrAspId="" -11 
    q:AuditUserId="" -21
    ;
    s Err=0
    s Len=$l(StrAspId,"^")
    f i=1:1:Len q:Err'=0  d
    .s AspId=$p(StrAspId,"^",i)
    .q:AspId=""
    .s Err=..SetAudit(AspId,AuditUserId)
    .
    ;
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
    n (asp,audituser)
    ;
    s asp=+asp
    s status=$p(^INASP(asp),"^",9)
    ;b ;222
    q:status'="No" -1  ;调价单已审核或已生效
    s preexedate=$p(^INASP(asp),"^",17)
    q:preexedate="" -2   ;计划生效日期不能为空
    q:preexedate<+$h -3  ;调价单已经过了计划生效日期，不能再审核   
    s ret=..LK(asp)
    q:ret<0 -100
    s auditflag="Audit"
    ;
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
    ;b ;exe1
    i preexedate=+$h d    ;计划生效日期为today时,自动生效。
    .s ret1=..Exe(asp)
    .;b ;exe2
    i ret1'=0 trollback  d ..ULK(asp)
    q:ret1'=0 -5    ;调价单生效失败
    ;
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

/// Descript:调价单生效（立即生效）
/// Creater:    ZhangDongmei
/// CreateDate: 2013-01-07
/// Table:in_adjsaleprice
/// Input:调价表id1^调价表id2^调价表id3...
/// Output:     
/// Return：0，成功；
ClassMethod SetExe(StrAspId) As %Library.String
{
    n (StrAspId)
    q:StrAspId="" -11 
    ;
    s Err=0
    s Len=$l(StrAspId,"^")
    f i=1:1:Len q:Err'=0  d
    .s AspId=$p(StrAspId,"^",i)
    .q:AspId=""
    .s Err=..Exe(AspId)
    .
    q Err
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
 n (asp)
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
 //更新调前进售价格为最新价格
 s AdjUomId=$p($g(^INASP(asp)),"^",10)
 s HospId=$p($g(^INASP(asp)),"^",20)
 s BuomId=$p(^INCI(itmrowid,1),"^",10)
 q:BuomId="" -6      ;基本单位不能为空
 s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(AdjUomId,BuomId)
 
 s BPriorSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(itmrowid,+$h,BuomId,HospId,"G","")  //insert 和update 保持一致都更新调前进售价
 s BPriorRp=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(itmrowid,+$h,BuomId,HospId,"G","") 
 
 ;更新调价单状态为已生效 
 &sql(update in_adjsaleprice set inasp_status=:yes,inasp_executedate=:exedate,INASP_PriorRP=:BPriorRp,INASP_PriorSP=:BPriorSp
   where inasp_rowid =:asp and inasp_status=:audit)
 i SQLCODE'=0  d
 .trollback
 .s ret=$$ErrorRecord^DHCSTERROR(appcode,asp,SQLCODE_":"_%msg)
 .s Err=-4
 q:Err'=0 Err
 s user=$p(^INASP(asp),"^",3)   ;user
 s resultsp=$p(^INASP(asp),"^",7)       ;result sp
 s adjno=$p(^INASP(asp),"^",5)
 S HospID=$p(^INASP(asp),"^",20)
 s ret=..InsertAspAmount(asp)  ;生成损益数据
 i ret'=0 trollback
 q:ret'=0 ret
 s ret=..InsAspDetAfterExe(asp)  ;插入dhc_inasp_detail
 i ret="" trollback
 q:ret="" -6
 tcommit
 ; handle the taritem price
 /*
 s tar=##class(web.DHCST.INCLINKTAR).GetTarItmIdByInc(itmrowid,+$h)
 i tar'=""  d
 .s AdjRow=asp
 .s err=$$AdjINCIPrice^DHCSTJFPRICE(itmrowid,exedate,resultsp,$g(user),AdjRow,"",HospID)  //zdm,2012-05-25,执行不成功，导致事务总是回滚，暂时注释掉"
 */
 //全部成功后更新附加表物价文件号,价格执行日期,yunhaibao20151209
 s prcfile=$p(^INASP(asp),"^",12)  //INASP_WarrentNO
 s prcfiledate=$p(^INASP(asp),"^",22)  //INASP_WNODate
 i $d(^DHCITMINFO(0,"INCI",itmrowid)) d
 .s itmaddrowid=$o(^DHCITMINFO(0,"INCI",itmrowid,""))
 .&SQL(UPDATE DHC_ItmAddionInfo SET INFO_PrcFile=:prcfile,INFO_PrcFileD=:prcfiledate WHERE INFO_RowId=:itmaddrowid)
 e  d
 .&SQL(insert into DHC_ItmAddionInfo(INFO_INCI_DR,INFO_PrcFile,INFO_PrcFileD)values(:itmrowid,:prcfile,:prcfiledate))
 q 0
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
    ;q:User="" -21
    ;
    s Err=0
    s Len=$l(StrAspId,"^")
    f i=1:1:Len q:Err'=0  d
    .s AspId=$p(StrAspId,"^",i)
    .q:AspId=""
    .s Err=..SetCancelAudit(AspId,User)
    .
    ;
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
    ;
    s asp=+asp
    s status=$p(^INASP(asp),"^",9)
    ;b ;222
    q:status'="Audit" -1  ;调价单不是已审核状态 
    s ret=..LK(asp)
    q:ret<0 -100
    s auditflag="No"
    ;
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理 
    ;更新调价单状态为未审核
    &sql(update in_adjsaleprice set inasp_status=:auditflag,INASP_AuditUser=null,INASP_AuditDate=null,INASP_Audittime=null
    where inasp_rowid=:asp)
    s err=SQLCODE
    i err'=0 d
    .s rett=$$ErrorRecord^DHCSTERROR(..%GetParameter("AppName"),asp,SQLCODE_":"_%msg)
    i err'=0  trollback  d ..ULK(asp)
    q:err'=0 -2    ;更新调价单状态失败
    tcommit
    d ..ULK(asp)
    q 0
}

/// Descript:生成调价损益数据
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-20
/// Table:dhc_aspamount
/// Input:调价表id
/// Output:     
/// Return：0，成功；
ClassMethod InsertAspAmount(Rowid) As %Library.String
{
    n (Rowid)
    q:Rowid="" -1
    s CurDate=$p($h,",",1)
    s CurTime=$p($h,",",2)
    s AspNo=$p(^INASP(Rowid),"^",5)
    s InciId=$p(^INASP(Rowid),"^",4)
    s PriorSp=$p(^INASP(Rowid),"^",6)       ;基本单位对应的调前价格
    s ResultSp=$p(^INASP(Rowid),"^",7)      ;基本单位对应的调后价格
    s PriorRp=$p(^INASP(Rowid),"^",15)      ;基本单位对应的调前进价
    s ResultRp=$p(^INASP(Rowid),"^",16)     ;基本单位对应的调后进价
    s AdjUserId=$p(^INASP(Rowid),"^",3)
    s HospId=$p(^INASP(Rowid),"^",20)       ;医院id
    
    s InciUomEquelFlag = ##class(PHA.IN.COM.Method).CompInciUomIfEqual(InciId)
    s DFlag=$S(InciUomEquelFlag="Y":1,1:2) 
    s herbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(InciId) 
    s ResultRp=##class(web.DHCST.Common.AppCommon).FormatRp(ResultRp, HospId, DFlag,..sssCode(), herbFlag)
    s ResultSp=##class(web.DHCST.Common.AppCommon).FormatSp(ResultSp, HospId, DFlag,..sssCode(), herbFlag)
    
    s DiffSp=ResultSp-PriorSp
    s DiffRp=ResultRp-PriorRp
    s GroupFlag=##Class(web.DHCSTCOMMPARA).GetGroupFlag() //yunhaibao20151222,仅当各院区分管价格时按院区生成损益
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理  
    s ret=0
    s ch=0
    f  s ch=$o(^INCI(InciId,"IL",ch))  q:(ch="")!(ret'=0)  d
    .s LocId=$p(^INCI(InciId,"IL",ch),"^",1)
    .q:LocId=""
    .s TmpHospId=$P($g(^CTLOC(+LocId)),"^",22)
    .q:(GroupFlag=2)&&(HospId'="")&(TmpHospId'=HospId)
    .s Qty=##class(web.DHCST.Common.DrugStkCommon).IL(InciId,LocId,+$h)  ;  get the qty in DHC_LocDailyTotal
    .q:+Qty=0
  
    .s SpAmt=(+Qty)*DiffSp
    .s RpAmt=(+Qty)*DiffRp
    .S SpAmt=+##class(web.DHCST.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
    .S RpAmt=+##class(web.DHCST.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
    .q:(SpAmt=0)&&(RpAmt=0)
    .&sql(insert into dhc_aspamount(aspa_no,aspa_ctloc_dr,aspa_adjprice,aspa_inasp_dr,
      aspa_inci_dr,aspa_stkqty,aspa_amount,aspa_date,aspa_time,aspa_ssusr_dr,ASPA_AdjRP,ASPA_RPAmt)
      values(:AspNo,:LocId,:DiffSp,:Rowid,:InciId,:Qty,:SpAmt,:CurDate,:CurTime,:AdjUserId,:DiffRp,:RpAmt))                     
    .
    .i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR(..%GetParameter("AppName"),adjno_":"_InciId,SQLCODE_":"_%msg)
    ..s ret=SQLCODE
    .q:ret'=0
    .s AspaId=$p(%ROWID,$c(1))  
    .                        
    .s ret=..InserAspAmtLB(AspaId)      
    .   
    i ret'=0 trollback
    q:ret'=0 ret 
    tcommit     
    q 0
}

/// Descript:保存批次损益数据
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-20
/// Table:dhc_aspamountlb
/// Input:损益表（dhc_aspamount）id
/// Output:     
/// Return：0，成功；其它：失败
/// 只在InsertAspAmount中调用，不能单独运行（单独运行需加事务处理）
ClassMethod InserAspAmtLB(Aspa) As %Library.String
{
    n (Aspa)
    q:Aspa="" 0
    s Aspa=+Aspa                                    ;
    s Inci=$p(^ASPA(Aspa),"^",1)
    s Loc=$p(^ASPA(Aspa),"^",2)
    s DiffSp=$p(^ASPA(Aspa),"^",3)      ;基本单位差价（售价）
    s DiffRp=$p(^ASPA(Aspa),"^",11)     ;基本单位差价（进价）
    s AspId=$p(^ASPA(Aspa),"^",10)
    q:AspId="" -2
    S ExeDate=$P(^INASP(AspId),"^",2)    ;生效日期
    S HospId=$P(^INASP(AspId),"^",20)
    s PrioRp=$P(^INASP(AspId),"^",15)    ;调前进价
    s AppCode=..%GetParameter("AppName")
    s ch=$o(^INCI("IL_LOC",Loc,Inci,0)) 
    q:ch="" 0
    s lbch=0
    ;zdm,2013-01-07,减少事务嵌套
    ;tstart
    ;s $ZT="Error^DHCSTERROR"                       ;增加错误处理    
    s Result=0
    f  s lbch=$o(^INCI(Inci,"IL",ch,"LB",lbch)) q:(lbch="")!(Result'=0)  d 
    .s Inclb=Inci_"||"_ch_"||"_lbch
    .s InclbQty=##class(web.DHCST.Common.DrugStkCommon).QtyINCLB(Inclb,+$h)  ;
    .s SpAmt=DiffSp*InclbQty
    .s RpAmt=DiffRp*InclbQty
    .S SpAmt=+##class(web.DHCST.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
    .S RpAmt=+##class(web.DHCST.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
    .s AspalbCh=1+$o(^ASPA(Aspa,"LB",""),-1)
    .&sql(insert into Dhc_AspAmountLB (aspalb_aspa_parref,aspalb_childsub,aspalb_inclb_dr,
        aspalb_qty,aspalb_adjdiff,aspalb_adjamt,ASPALB_AdjRP,ASPALB_RPAmt,ASPALB_PriorRP)
        values(:Aspa,:AspalbCh,:Inclb,:InclbQty,:DiffSp,:SpAmt,:DiffRp,:RpAmt,:PrioRp) )
    .i SQLCODE'=0  d
    ..s Result=-1
    ..s ret=$$ErrorRecord^DHCSTERROR("AppCode",aspa,SQLCODE_":"_%msg)
    .
    ;i Result'=0 trollback
    ;q:Result'=0 Result
    ;tcommit
    q Result
}

/// Descript:生效以后的处理dhc_inasp_detail
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-21
/// Table:dhc_inasp_detail
/// Input:调价表id，操作人id
/// Output:     
/// Return：dhc_inasp_detail表rowid
ClassMethod InsAspDetAfterExe(inasp, user = "") As %Library.String
{
    n (inasp,user)
 ;
 s ret=0
 s resultspuom=$p(^INASP(inasp),"^",11)
 s uom=$p(^INASP(inasp),"^",10)
 s resultsp=$p(^INASP(inasp),"^",7)
 s dd=+$h  ; execute date
 s tt=$p($h,",",2)
 &sql(insert into dhc_inasp_detail(ASPD_Date,ASPD_Time,ASPD_SSUSR_DR,ASPD_ResultSP_Uom,
 ASPD_AdjUom_DR,ASPD_ResultSP,ASPD_INASP_DR) values(:dd,:tt,:user,:resultspuom,:uom,
 :resultsp,:inasp))
 i SQLCODE'=0  d
 .s rett=$$ErrorRecord^DHCSTERROR("InsAspDetAfterExe:dhc_inasp_detail",inasp,SQLCODE_":"_%msg)
 .s ret=-1
 q:ret'=0 ""
 q +%ROWID
}

/// Descript:   删除某一药品的调价信息(删除药品时调用)
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-28
/// Table:in_adjsaleprice
/// Input:库存项id
/// Output:     
/// Return：0：成功;
ClassMethod DeleteAdjPrice(InciRowid, HospId = "") As %Library.String
{
    n (InciRowid,HospId)
    q:HospId="" 0
    q:InciRowid="" 0
    ;q:'$d(^INASP(0,"INCI",InciRowid)) 0
    ;删除调价信息
    s Err=0
    s exedate=$o(^INASP(0,"HOSPI",HospId,InciRowid, ""))
    q:exedate="" 0
    &sql(Delete From IN_AdjSalePrice Where INASP_Hospital_Dr=:HospId and INASP_INCI_DR=:InciRowid)
    i (SQLCODE'=0)&(SQLCODE'=100) d
    .s rett=$$ErrorRecord^DHCSTERROR("DeleteAdjPrice:IN_AdjSalePrice",InciRowid,SQLCODE_":"_%msg)
    .s Err=-1
    q Err
}

/// Descript:   查询一段时间内的调价单
/// Creater:    ZhangDongmei
/// CreateDate: 2012-02-08
/// Table:in_adjsaleprice
/// Input:开始行，一页显示记录条数,调价单号,调价单状态
/// Output:     
/// Return：调价单信息
ClassMethod QueryAdjSpNo(Start As %Integer, Limit As %Integer, StartDate As %String, EndDate As %String, Others As %String) As %Library.String
{
    n (Start, Limit,StartDate,EndDate,Others)
    //s ^YSJTMP("QueryAdjSpNo")=$LB(Start, Limit,StartDate,EndDate,Others)
    s AspNo=$p(Others,"^",1)
    s Status=$p(Others,"^",2)
    s ItmRowid=$p(Others,"^",3)
    s StkGrpId=$p(Others,"^",4)
    s hospid=$p(Others,"^",5)
    q:StartDate="" ""
    q:EndDate="" ""
    s GroupFlag=##Class(web.DHCSTCOMMPARA).GetGroupFlag()   //集团化标志
    s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
    s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    s:AspNo'="" AspNo=$$ALPHAUP^SSUTIL4(AspNo)
    s End=Start+Limit
    s Pid=..NewPid()
    ;
    Set Json = ##class(Code.JsonObj).%New()
    s Num=0
    ;
    s TmpStatus=0
    f  s TmpStatus=$o(^INASP(0,"DATESTATUS",TmpStatus)) q:TmpStatus=""  d
    .q:(Status'="")&(TmpStatus'=Status)
    .f Date=StartDate:1:EndDate  d
    ..s AspId=""
    ..f  s AspId=$o(^INASP(0,"DATESTATUS",TmpStatus,Date,AspId))  q:AspId=""  d
    ...s InciId=$p(^INASP(AspId),"^",4)
    ...q:InciId=""
    ...q:(ItmRowid'="")&(InciId'=ItmRowid)
    ...s TmpAspNo=$p(^INASP(AspId),"^",5)
    ...q:(AspNo'="")&(TmpAspNo'=AspNo)
    ...s TmpGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
    ...s StkType=$p(TmpGrpInfo,"^",3)
    ...q:StkType'=..sssCode()
    ...s TmpStkGrpId=$p(TmpGrpInfo,"^",5)
    ...q:(StkGrpId'="")&(TmpStkGrpId'=StkGrpId)
    ...s AdjDate=$p(^INASP(AspId),"^",1)  
    ...s AdjUserId=$p(^INASP(AspId),"^",3)
    ...s HospId=$p(^INASP(AspId),"^",20)            ;医院id
    ...q:(GroupFlag=2)&&(HospId'=hospid)&&(hospid'="")   //如果集团化标志为2时，则不能看到分院的调价数据 2020-02-05 yangsj
    ...s AuditUserId=$p(^INASP(AspId),"^",21)  
    ...;b
    ...s:AdjDate'="" AdjDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AdjDate,"ST")
    ...s:AdjUserId'="" AdjUserName=$p(^SSU("SSUSR",AdjUserId),"^",2)
    ...s:AuditUserId'="" AuditUserName=$p(^SSU("SSUSR",AuditUserId),"^",2)
    ...;b
    ...i '$d(^TMPASP(Pid,"ASP",TmpAspNo))  d
    ....s ^TMPASP(Pid,"ASP",TmpAspNo)=AdjDate_"^"_$g(AdjUserName)
    ...e  d
    ....s TmpAdjDate=$p(^TMPASP(Pid,"ASP",TmpAspNo),"^",1)
    ....;最后一次更新人和更新日期
    ....i AdjDate>TmpAdjDate  d
    .....s ^TMPASP(Pid,"ASP",TmpAspNo)=AdjDate_"^"_$g(AdjUserName)
    ....
    ...
    ..
    .
    d OutPut
    s DetailStr=Json.getJsonData("AspNo^AspDate^AspUser",Num)
    k Json 
    k ^TMPASP(Pid,"ASP") 
    Quit DetailStr

OutPut
 s Num=0
 s AspNo=""
 f  s AspNo=$o(^TMPASP(Pid,"ASP",AspNo)) q:AspNo=""  d
 .s Num=Num+1
 .q:(Start'="")&(Num<=Start)     ;只返回当前页需要显示的记录
 .q:(Limit'="")&(Num>End)
 .s Data=^TMPASP(Pid,"ASP",AspNo)
 .s Data=AspNo_"^"_Data
 .d Json.InsertRowData(Data)
 .
 q
}

/// Descript:   查询一段时间内的调价信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-02-13
/// Table:in_adjsaleprice
/// Input:开始行,一页显示记录条数,开始日期,截止日期,调价单号^调价单状态^库存项id^类组id^
/// Output:     
/// Return：调价单信息
/// w ##class(web.DHCST.INAdjSalePrice).QueryAspInfo("0","30","25/01/2021","26/01/2021","^Audit^^")
ClassMethod QueryAspInfo(Start As %Integer, Limit As %Integer, StartDate As %String, EndDate As %String, Others As %String) As %Library.String
{
    n (Start, Limit,StartDate,EndDate,Others)
    //s ^YSJTMP("QueryAspInfo")=$LB(Start, Limit,StartDate,EndDate,Others)
    s AspNo=$p(Others,"^",1)
    s Status=$p(Others,"^",2)
    s ItmRowid=$p(Others,"^",3)
    s StkGrpId=$p(Others,"^",4)
    
    q:StartDate="" ""
    q:EndDate="" ""
    s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
    s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    s:AspNo'="" AspNo=$$ALPHAUP^SSUTIL4(AspNo)
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
    q:Remark="统一调所有批次价格"
    s PriorRp=$p(^INASP(Rowid),"^",15)     ;基本单位对应的调前进价
    s ResultRp=$p(^INASP(Rowid),"^",16) ;基本单位对应的调后进价
    s PreExecuteDate=$p(^INASP(Rowid),"^",17)  ;计划生效日期
    s HospId=$p(^INASP(Rowid),"^",20)           ;医院id
    s AuditUserId=$p(^INASP(Rowid),"^",21)  
    ;
    s:AdjDate'="" AdjDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AdjDate,"ST")
    s:ExecuteDate'="" ExecuteDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExecuteDate,"ST")
    s (AdjUserNames,StkCatDesc,AspUomDesc)=""
    s:AdjUserId'="" AdjUserName=$p($g(^SSU("SSUSR",AdjUserId)),"^",2)
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
    s:PreExecuteDate'="" PreExecuteDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PreExecuteDate,"ST")
    s:AuditUserId'="" AuditUserName=$p(^SSU("SSUSR",AuditUserId),"^",2)
    s DiffSpUom=ResultSpUom-PriorSpUom
    s DiffRpUom=ResultRpUom-PriorRpUom
    ;
    s InfoId=$o(^DHCITMINFO(0,"INCI",InciId,0))
    s MarkTypeDesc=""
    i InfoId'=""  d
    .s MarkTypeId=$p(^DHCITMINFO(InfoId),"^",15)
    .s:MarkTypeId'="" MarkTypeDesc=$p($g(^DHCINMT(MarkTypeId)),"^",2)
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
    ;s:InvDate'="" InvDate=$zd(InvDate,3)   ;目前INASP_INVODATE存的就是Y-m-d格式
    s AdjReasonId=$p(^INASP(Rowid),"^",28)
    s AdjReason=""
    s:AdjReasonId'="" AdjReason=$p($g(^DHCSTREASON("ASP",AdjReasonId)),"^",2)
    s arcimDr=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(InciId)
    s freeDrugFlag=##class(web.DHCST.Common.DrugInfoCommon).CheckIfFreeDrug(arcimDr) 
    ;
    s DiffRpUom=$fn(DiffRpUom,"N")
    s DiffSpUom=$fn(DiffSpUom,"N")
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
    .s:MarkTypeId'="" MarkTypeDesc=$p($g(^DHCINMT(MarkTypeId)),"^",2)
    .s PriceFileNo=$p(^DHCITMINFO(InfoId),"^",33)
    .s MaxSp=$p(^DHCITMINFO(InfoId),"^",16)
    .
    s BUomId=$p(^INCI(ItmRowid,1),"^",10)
    s PurUomId=$p(^INCI(ItmRowid,3),"^",6)
    s:BUomId'="" BUomDesc=$p(^CT("UOM",BUomId),"^",2)
    s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
    s PurSp=##class(web.DHCSTPRICE).GetSp(ItmRowid,+$h,PurUomId,HospId,"")
    s PurRp=##class(web.DHCSTPRICE).GetRp(ItmRowid,+$h,PurUomId,HospId,"")  //20141203 zhouyg
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
    ;s ^zdm("GetParamProp")=GroupId_"^"_LocId_"^"_UserId
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=..%GetParameter("AppName")
    s CalSpByMarkType=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"CalSpByMarkType",Param)
    s DefaAspReason=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"DefaAspReason",Param)
    s DefaPreExeDate=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"DefaPreExeDate",Param)
    ;
    q CalSpByMarkType_"^"_DefaAspReason_"^"_DefaPreExeDate
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

ClassMethod LK(asp) As %Library.String
{
    n (asp)
    l +^DHCSTADJSP("ASPITM",asp):1 e  q -1
    q 0
}

ClassMethod ULK(asp) As %Library.String
{
    l -^DHCSTADJSP("ASPITM",asp)
    q
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("AdjPrice"))
}

/// Description:查询某调价单明细信息
/// Creator:Xiaohe
/// CreatDate：20140926
/// Input:调价单号
/// OutPut:
/// LastUpdate:yunhaibao20151201
/// d ##class(%ResultSet).RunQuery("web.DHCST.INAdjSalePrice","QueryAspDetail","XYASP20151113008")
Query QueryAspDetail(AspNo As %String, HospDescIO As %String = "") As websys.Query(ROWSPEC = "AdjSalePriceNo:%String,ExecuteDate:%String,InciId:%String,InciCode:%String,InciDesc:%String,Spec:%String,AspUomDesc:%String,ManfDesc:%String,PriorRpUom:%String,ResultRpUom:%String,PriorSpUom:%String,ResultSpUom:%String,WarrentNo:%String,AdjUserName:%String,CreatUserName:%String,StartUserName:%String,AdjReason:%String,AuditUserName:%String,HospDescIO") [ SqlProc ]
{
}

ClassMethod QueryAspDetailExecute(ByRef qHandle As %Binary, AspNo As %String, HospDescIO As %String = "") As %Status
{
    n (qHandle,AspNo,Phloc,HospDescIO)
    s repid=$I(^CacheTemp)
    s ind=1
    s qHandle=$lb(0,repid,0)   
    q:AspNo="" $$$OK
    s:HospDescIO'="" HospDescIO=$P(^CT("HOSP",HospDescIO),"^",2)
    s AspNo=$$ALPHAUP^SSUTIL4(AspNo)
    s AspId=""
    f  s AspId=$o(^INASP(0,"ASPNO",AspNo,AspId))  q:AspId=""  d
    .s AdjDate=$p(^INASP(AspId),"^",1)  
    .s ExecuteDate=$p(^INASP(AspId),"^",2)
    .s AdjUserId=$p(^INASP(AspId),"^",3)
    .s InciId=$p(^INASP(AspId),"^",4)
    .q:InciId=""
    .s PriorSp=$p(^INASP(AspId),"^",6)      ;基本单位对应的价格
    .s ResultSp=$p(^INASP(AspId),"^",7)     ;基本单位对应的价格
    .s StkCatId=$p(^INCI(InciId,2),"^",2)
    .s AspUomId=$p(^INASP(AspId),"^",10)
    .s ResultSpUom=$p(^INASP(AspId),"^",11)   ;调价单位对应的调后售价
    .s ResultRpUom=$p(^INASP(AspId),"^",14)       ;调价单位对应的调后进价
    .s WarrentNo=$p(^INASP(AspId),"^",12)    ;物价文件号
    .s WnoDate=$p(^INASP(AspId),"^",22)         ;物价文件备案日期
    .s Remark=$p(^INASP(AspId),"^",13)      ;目前存调价原因
    .s PriorRp=$p(^INASP(AspId),"^",15)     ;基本单位对应的调前进价
    .s ResultRp=$p(^INASP(AspId),"^",16)    ;基本单位对应的调后进价
    .s PreExecuteDate=$p(^INASP(AspId),"^",17)  ;计划生效日期
    .s HospId=$p(^INASP(AspId),"^",20)          ;医院id
    .s AuditUserId=$p(^INASP(AspId),"^",21)  //审核人
    .s CreatUserId=$p(^INASP(AspId),"^",3)   //建单人
    .s StartUserId=$p(^INASP(AspId),"^",30) //生效人
    .s:AdjUserId'="" AdjUserName=$p(^SSU("SSUSR",AdjUserId),"^",2)
    .s:CreatUserId'="" CreatUserName=$p(^SSU("SSUSR",CreatUserId),"^",2)
    .s:StartUserId'="" StartUserName=$p(^SSU("SSUSR",StartUserId),"^",2)
    .s InciCode=$p(^INCI(InciId,1),"^",1)
    .s InciDesc=$p(^INCI(InciId,1),"^",2)
    .s BUomId=$p(^INCI(InciId,1),"^",10)
    .s PurUomId=$p(^INCI(InciId,3),"^",6)
    .s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",InciId)
    .s ManfInfo=##class(web.DHCST.Common.DrugInfoCommon).GetManf(InciId)
    .s ManfDr=$p(ManfInfo,"^",1)
    .s ManfDesc=$p(ManfInfo,"^",3)
    .i ManfDesc["-" s ManfDesc=$P(ManfDesc,"-",2)      //厂家
    .s StkCatDesc="",AspUomDesc=""
    .s:StkCatId'="" StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
    .s:AspUomId'="" AspUomDesc=$p(^CT("UOM",AspUomId),"^",2)     //调价单位
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
    .s:PreExecuteDate'="" PreExecuteDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PreExecuteDate,"ST")
    .s:AuditUserId'="" AuditUserName=$p(^SSU("SSUSR",AuditUserId),"^",2)
    .s DiffSpUom=ResultSpUom-PriorSpUom
    .s DiffRpUom=ResultRpUom-PriorRpUom
    .s InfoId=$o(^DHCITMINFO(0,"INCI",InciId,0))
    .i InfoId'=""  d
    ..s MarkTypeId=$p(^DHCITMINFO(InfoId),"^",15)
    ..s:MarkTypeId'="" MarkTypeDesc=$p($g(^DHCINMT(MarkTypeId)),"^",2)
    ..s MaxSp=$p(^DHCITMINFO(InfoId),"^",16)
    .s ConFacPur=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
    .s InvNo=$p(^INASP(AspId),"^",18) 
    .s InvDate=$p(^INASP(AspId),"^",19)
    .s AdjReasonId=$p(^INASP(AspId),"^",28)
    .s:AdjReasonId'="" AdjReason=$p($g(^DHCSTREASON("ASP",AdjReasonId)),"^",2) 
    .s AdjSalePriceNo=$P(AspNo,"P",2)
    .s:AdjDate'="" AdjDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AdjDate,"ST")
    .s:ExecuteDate'="" ExecuteDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExecuteDate,"ST")
    .d OutPutRow
 
    Quit $$$OK
OutPutRow 
 s Data=$lb(AdjSalePriceNo,ExecuteDate,InciId,InciCode,InciDesc,Spec,AspUomDesc,ManfDesc,PriorRpUom,ResultRpUom,PriorSpUom,ResultSpUom,WarrentNo,AdjUserName,CreatUserName,StartUserName,AdjReason,AuditUserName,HospDescIO)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Description:调价任务运行方法
/// Creator:    hulihua
/// CreateDate: 2018-10-12
/// Table:      in_adjsaleprice、IN_AdjPriceBatch
/// Input:      
/// Output:     
/// Return： 0，成功    
/// Others:
/// Debug:      d ##class(web.DHCST.INAdjSalePrice).NightRunAdjAsp()
ClassMethod NightRunAdjAsp() As %Library.String
{
    s HospId=0
    f  s HospId=$o(^CT("HOSP",HospId))  q:HospId=""   d
    .s HospDateFrom=$p(^CT("HOSP",HospId),"^",9)
    .q:(HospDateFrom'="")&&(HospDateFrom>+$h)
    .s HospDateTo=$p(^CT("HOSP",HospId),"^",10)
    .q:(HospDateTo'="")&&(HospDateTo<+$h)
    .s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospId)
    .i RuleFlag="3"  d
    ..d ##class(web.DHCST.INAdjPriceBatch).NightRunAspAmount()
    ..d ##class(web.DHCST.INAdjPriceAllBatch).NightRunAspAmount() //按品种生效所有批次价格 add by liangjiaquan 2018-11-16
    .e  d
    ..d ..NightRunAspAmount()
    q 0
}

/// Description:通过调价表id判断今日是否有已经有生效的调价记录
/// Creator:yangsj
/// CreateDate:2020-01-14
/// Input:
/// Output:
/// w ##class(web.DHCST.INAdjSalePrice).CheckIfHavenAdjDay(AspIdStr)
ClassMethod CheckIfHavenAdjDay(asp)
{
     s ret="N" 
     q:'$d(^INASP(asp)) ret
     s HospID=$p(^INASP(asp),"^",20)
     s inci=$p(^INASP(asp),"^",4)
     s TodayFlag=..CheckItmAspToday(inci,HospID)
     i TodayFlag=1 s ret="Y"        ;该药品存在当天生效的调价单，不能再次调价
     
     q ret
}

/// Decription:判断日期是否小于等于当日
/// Creator:yangsj
/// CreateDate:2020-06-16
/// Input:date
/// Output:1 大于当日 0 小于等于当日
/// Table:
/// Debugger: w ##class(web.DHCST.INAdjSalePrice).CheckDateAndCur("2020-03-02")
ClassMethod CheckDateAndCur(date)
{
    s ret=0
    q:date="" ""
    s date=+##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(date)
    q:+$h<date 1
    q ret
}

/// Decription:更新调价单计划生效日期为明日
/// Creator:yangsj
/// CreateDate:2020-06-16
/// Input:date
/// Output:0 更新成功， 其他:更新失败
/// Table:
/// Debugger: w ##class(web.DHCST.INAdjSalePrice).UpDateAspPreDate("2859^2861")
ClassMethod UpDateAspPreDate(inaspStr)
{
    s ret=0
    q:inaspStr="" ret
    s len=$l(inaspStr,"^")
    s tomorrow=+$h+1
    ts
    f i=1:1:len q:ret'=0  d
    .s asp=$P(inaspStr,"^",i)
    .&sql(UPDATE IN_AdjSalePrice SET INASP_PreExeDate=:tomorrow WHERE ID=:asp )
    .i SQLCODE'=0 s ret=SQLCODE
    .q:ret'=0
    
    i ret'=0 tro
    q:ret'=0 ret
    
    b ;tc
    tc
    q ret
}

}
