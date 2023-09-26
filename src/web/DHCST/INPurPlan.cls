Import sqluser

/// Descript:采购计划制单
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-18
Class web.DHCST.INPurPlan Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTPURPLANAUDIT";

/// Descript:   保存/更新采购计划单信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-18
/// Table:IN_Purplan,IN_PurplanItm
/// Input:计划单号,科室Id,操作人Id,类组Id,
/// 明细Id^库存项id^采购数量^单位Id^供应商Id^进价^厂商id^配送商id^请求科室,
/// 明细Id^库存项id^采购数量^单位Id^供应商Id^进价^厂商id^配送商id^请求科室
/// Output:     
/// Return：计划单id：成功，
/// -1:科室或人员为空
/// -99  ;加锁失败
/// -2   ;生成计划单号失败
/// -3   ;保存计划单失败
/// -4   ;未找到需更新的计划单
/// -5:保存计划单明细失败,不能生成计划单
/// -7^失败药品：部分明细保存不成功，提示不成功的药品
/// w ##class(web.DHCST.INPurPlan).Save(222,1,590,6,"^1^222^5^1^222^1^^1")
ClassMethod Save(PurNo As %String, LocId As %String, UserId As %String, StkGrpId As %String, ListData As %String) As %Library.String
{
    n (PurNo,LocId,UserId,StkGrpId,ListData)
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    i PurNo=""  d
    .s PurId=..Insert(LocId,UserId,StkGrpId)     ;保存采购计划主表
    e  d
    .s PurId=$o(^INPP(0,"NO",$$ALPHAUP^SSUTIL4(PurNo),0))
    .s:+PurId<0 PurId=-4   ;未找到需更新的计划单
    .q:PurId<0
    .i $p(^INPP(PurId),"^",8)="Y" s PurId=-8
    .q:PurId<0
    .i $p(^INPP(PurId),"^",10)="Y" s PurId=-9
    .q:PurId<0
    .s ret=..Update(PurId,LocId,UserId,StkGrpId)
    .i ret'>0 s PurId=-5
    ;b ;1
    i +PurId<=0 trollback
    q:+PurId<=0 PurId
    s Ret=0
    i ListData'="" d  
    .s Ret=##class(web.DHCST.INPurPlanItm).Save(PurId,ListData)
    ;b ;2
    i (+Ret=-6)!(+Ret=-5) trollback
    q:(+Ret=-6)!(+Ret=-5) -5 
    tcommit    ;只要有计划单明细保存成功，则提交事务
    q:+Ret'=0 Ret   ;存在保存失败的明细
    q PurId
}

/// Descript:   插入采购计划主信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-18
/// Table:IN_Purplan
/// Input:代码,描述
/// Output:     
/// Return：成功:rowid
/// -1:科室或人员为空
/// -99  ;加锁失败
/// -2   ;生成计划单号失败
/// -3   ;保存计划单失败
ClassMethod Insert(LocId As %String, UserId As %String, StkGrpId As %String) As %Library.String
{
    n (LocId,UserId,StkGrpId)
    q:LocId="" -1
    q:UserId="" -1
    ;
    s PurDate=+$h
    s PurTime=$p($h,",",2)
    s Type=..sssCode()
    s CompFlag="N"  
    s PoFlag="N"
    s resultString=0
    s AppName=##class(web.DHCST.INPurPlan).%GetParameter("AppName")
    ;
    s PurNo=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,StkGrpId,LocId)
    q:PurNo="" -2   ;生成计划单号失败
    ;
    s Err=0
    &sql(insert into IN_PurPlan(INPP_No,INPP_Date,INPP_SSUSR_DR,INPP_PoFlag,
    INPP_CTLOC_DR,INPP_Complete,INPP_Time,INPP_SCG_DR,INPP_StkType) 
    values (:PurNo,:PurDate,:UserId,:PoFlag,:LocId,:CompFlag,:PurTime,:StkGrpId,:Type))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:IN_PurPlan",PurNo,SQLCODE_":"_%msg)
    .s Err=-3
    .
    q:Err'=0 -3    ;保存计划单失败
    ;
    q $p($g(%ROWID),$c(1))
}

/// 更新采购计划单主表
/// Author:zhwh
/// Date:2012-04-25
/// Arguments:
///      inpp  - rowid Of IN_Purplan
///      LocId  - Rowid Of CT_Loc
///      UserId  - RowId of SS_User
///      StkGrpId - RowId of DHC_StkCatGroup
/// Return Value:
///  >0 - rowid Of IN_Purplan
///  <0  - failure
///  
ClassMethod Update(inpp As %String, LocId As %String, UserId As %String, StkGrpId As %String) As %Library.String
{
    n (inpp,LocId,UserId,StkGrpId,SQLCODE)
    q:LocId="" -1
    q:UserId="" -1
    ;
    s PurDate=+$h
    s PurTime=$p($h,",",2)
    s obj=##class(User.INPurPlan).%OpenId(inpp)
    s PurNo=obj.INPPNo
    d obj.%Reload()
    d obj.INPPCTLOCDRSetObjectId(LocId)
    d obj.INPPSSUSRDRSetObjectId(UserId)
    d obj.INPPSCGDRSetObjectId(StkGrpId)
    s obj.INPPDate=PurDate
    s obj.INPPTime=PurTime
    s sc= obj.%Save()
    s Err=0 
    i $$$ISERR(sc)  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:IN_PurPlan",PurNo,sc_":")
    .s Err=-3
    .
    q:Err'=0 -3    ;更新计划单失败
    ;
    q obj.%Id()
}

/// Descript:   删除采购计划单信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-19
/// Table:IN_Purplan
/// Input:rowid
/// Output:     
/// Return：0,成功,
ClassMethod Delete(Rowid As %String) As %Library.String
{
    n (Rowid)
    ;
    ;不能为空项
    q:Rowid="" ""
    s CompFlag=$p(^INPP(Rowid),"^",8)
    s AuditFlag=$p(^INPP(Rowid),"^",10)
    q:CompFlag="Y" -1       ;订单已经完成，不能删除
    q:AuditFlag="Y" -2      ;订单已经审核，不能删除
    ;
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    s Err=0
    &sql(Delete From IN_PurPlan where INPP_Rowid=:Rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:IN_PurPlan",Rowid,SQLCODE_":"_%msg)
    .s Err=-3
    .
    i Err'=0 trollback
    q:Err'=0 -3   ;删除计划单主表失败
    s Ret=##class(web.DHCST.INPurPlanItm).DeleteAll(Rowid)
    i Ret'=0 trollback
    q:Ret'=0 -4  ;删除计划单明细失败
    tcommit
    q 0
}

/// Descript:   确认完成某采购计划单
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-20
/// Table:IN_Purplan
/// Input:rowid
/// Output:     
/// Return：0,成功,
/// -1      ;计划单已经完成
/// -3   ;操作失败
ClassMethod SetComplete(Rowid As %String) As %Library.String
{
    n (Rowid)
    ;
    ;不能为空项
    q:Rowid="" ""
    s CompFlag=$p(^INPP(Rowid),"^",8)
    q:CompFlag="Y" -1       ;计划单已经完成
    s Flag="Y"
    ;
    tstart
    s $ZT="Error^DHCSTERROR"
    s Err=0
    &sql(Update IN_PurPlan set INPP_Complete=:Flag where INPP_Rowid=:Rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("SetComplete:IN_PurPlan",Rowid,SQLCODE_":"_%msg)
    .s Err=-3   ;操作失败
    .
    i Err'=0 trollback  q Err
    s LocId=$p(^INPP(Rowid),"^",7)
    s UserId=$p(^INPP(Rowid),"^",3)
    s GroupId=$p(^SSU("SSUSR",UserId),"^",5)
    s HospId=$p(^CTLOC(LocId),"^",22)
    s Params=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
    s AutoAuditAfterCompleted=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.INPurPlan).%GetParameter("AppName"),"AutoAuditAfterCompleted",Params)
    i AutoAuditAfterCompleted="Y"  d   ;自动审批
    .s Ret=..Audit(Rowid,UserId)
    .b ;audit
    .s:Ret'=0 Err=-4
    .
    i Err'=0 trollback  q Err
    tcommit
    q 0
}

/// Descript:   取消完成某采购计划单
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-20
/// Table:IN_Purplan
/// Input:rowid
/// Output:     
/// Return：0,成功,
/// -1  ;计划单尚未完成
/// -2  ;订单已经审核，不能取消完成
/// -3  ;操作失败
ClassMethod CancelComplete(Rowid As %String) As %Library.String
{
    n (Rowid)
    ;
    ;不能为空项
    q:Rowid="" ""
    s CompFlag=$p(^INPP(Rowid),"^",8)
    q:CompFlag'="Y" -1      ;计划单尚未完成
    s AuditFlag=$p(^INPP(Rowid),"^",10)
    q:AuditFlag="Y" -2      ;订单已经审核，不能取消完成
    s Flag="N"
    ;
    s Err=0
    &sql(Update IN_PurPlan set INPP_Complete=:Flag where INPP_Rowid=:Rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("SetComplete:IN_PurPlan",Rowid,SQLCODE_":"_%msg)
    .s Err=-3   ;操作失败
    .
    q Err
}

/// Descript:根据药品id取药品采购默认信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-19
/// Table:
/// Input:库存项id,安全组id^科室id^用户id
/// Output:     
/// Return：供应商id^供应商名称^产地id^产地名称^配送商id^配送商名称^入库单位id
/// ^入库单位^进价^售价^申购科室库存量^库存上限^库存下限^通用名^商品名^剂型^规格
/// w ##class(web.DHCST.INPurPlan).GetItmInfo(534,274)
ClassMethod GetItmInfo(IncId As %String, Params As %String) As %Library.String
{
    n (IncId,Params)
    s ^YSJTMP("GetItmInfo")=$LB(IncId,Params)
    s GroupId=$p(Params,"^",1)
    s LocId=$p(Params,"^",2)
    s UserId=$p(Params,"^",3)
    s PrvLocId=$p(Params,"^",4)
    s HospId=""
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s ParamStr=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
    s VenInfo=##class(web.DHCST.Common.DrugInfoCommon).GetConfigVendor(IncId,##class(web.DHCST.INPurPlan).%GetParameter("AppName"),ParamStr)
    s VenId=$p(VenInfo,"^",1)
    s VenDesc=$p(VenInfo,"^",2)
    ;
    s ManfInfo=##class(web.DHCST.Common.DrugInfoCommon).GetConfigManf(IncId,##class(web.DHCST.INPurPlan).%GetParameter("AppName"),ParamStr)
    s ManfId=$p(ManfInfo,"^",1)
    s ManfDesc=$p(ManfInfo,"^",2)
    ;
    s CarrierInfo=##class(web.DHCST.Common.DrugInfoCommon).GetConfigCarrier(IncId,##class(web.DHCST.INPurPlan).%GetParameter("AppName"),ParamStr)
    s CarrierId=$p(CarrierInfo,"^",1)
    s CarrierDesc=$p(CarrierInfo,"^",2)
    s BUomId=$p(^INCI(IncId,1),"^",10)
    s PurUomId=$p(^INCI(IncId,3),"^",6)
    s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
    s Confac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
    s Rp=##class(web.DHCST.Common.PriceCommon).GetConfigRp(IncId,PurUomId,##class(web.DHCST.INPurPlan).%GetParameter("AppName"),ParamStr)
    s Rp = ##Class(web.DHCST.Common.AppCommon).FormatRp(Rp,HospId,1,"G","",IncId)
    s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(IncId,+$h,PurUomId,HospId,"G","")
    s Sp = ##Class(web.DHCST.Common.AppCommon).FormatSp(Sp,HospId,1,"G","",IncId)
    s StkQty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(IncId,LocId,PurUomId,+$h)
    s PrvStkQty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(IncId,PrvLocId,PurUomId,+$h)
    s QtyInfo=##class(web.DHCST.Common.DrugStkCommon).GetItmLocMNRQtyUO(IncId,LocId,PurUomId)
    s MinQty=$p(QtyInfo,"^",1)
    s MaxQty=$p(QtyInfo,"^",2)
    s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",IncId)
    s GeneInfo=##class(web.DHCST.Common.DrugInfoCommon).GetGene(IncId)
    s Gene=$p(GeneInfo,"^",2)
    s GoodName=##class(web.DHCST.Common.DrugInfoCommon).GetGoodName(IncId)
    s FormInfo=##class(web.DHCST.Common.DrugInfoCommon).GetForm(IncId)
    s Form=$p(FormInfo,"^",1)
    s arcimDr=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(IncId)
    s freeDrugFlag=##class(web.DHCST.Common.DrugInfoCommon).CheckIfFreeDrug(arcimDr)
    
    ;w $L(Form),!
    s Data1=VenId_"^"_VenDesc_"^"_ManfId_"^"_ManfDesc_"^"_CarrierId_"^"_CarrierDesc_"^"_PurUomId_"^"_$g(PurUomDesc)
    s Data2=Rp_"^"_Sp_"^"_StkQty_"^"_MaxQty_"^"_MinQty_"^"_Gene_"^"_GoodName_"^"_Form_"^"_Spec_"^"_BUomId_"^"_Confac
    s Data3=PrvStkQty_"^"_freeDrugFlag
    q Data1_"^"_Data2_"^"_Data3
}

/// Descript:   查询计划单信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-19
/// Table:IN_Purplan
/// Input:开始行，一页显示记录数,排序字段,排序方向,
/// 科室id^开始日期^截止日期^计划单号^类组id^供应商id^药品id^完成标志^审核标志
/// Output:     
/// Return：rowid^单号^科室^制单日期^制作人^订单审批^订单完成^类组id^类组名称
/// w ##class(web.DHCST.INPurPlan).Query(0,22,"Rowid","desc","^2012-01-01^2012-06-25^^^^^^N")
ClassMethod Query(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, StrParam As %String) As %String
{
    n (StrParam,Start,Limit,Sort,Dir)
    ;s ^zdm("Query")=StrParam_","_Start_","_Limit_","_Sort_","_Dir
    s LocId=$p(StrParam,"^",1)
    s StartDate=$p(StrParam,"^",2)
    s EndDate=$p(StrParam,"^",3)
    q:StartDate="" ""
    q:EndDate="" ""
    s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
    s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    s PurNo=$p(StrParam,"^",4)
    s StkGrpId=$p(StrParam,"^",5)
    s VendorId=$p(StrParam,"^",6)
    s IncId=$p(StrParam,"^",7)
    s Complete=$p(StrParam,"^",8)
    s Audit=$p(StrParam,"^",9)
    ;
    s StrSql="select INPP_Rowid as Rowid,INPP_No,INPP_CTLOC_DR,INPP_CTLOC_DR->CTLOC_Desc as LocDesc,"_
    "INPP_Date,INPP_SSUSR_DR->SSUSR_Name as UserName,"_
    " INPP_PoFlag,INPP_Complete,INPP_AuditFlag,INPP_SCG_DR,INPP_StkType from IN_PurPlan where (INPP_Date between "_
    StartDate_" and "_EndDate_")"
    s OrderField="Rowid"
    i PurNo'=""  d
    .s StrSql=StrSql_" and INPP_No='"_PurNo_"'"
    i LocId'=""  d
    .s StrSql=StrSql_" and INPP_CTLOC_DR="_LocId
    i StkGrpId'=""  d
    .s StrSql=StrSql_" and INPP_SCG_DR="_StkGrpId
    ;
    s:Sort="PurNo" OrderField="INPP_No"
    s:Sort="Loc" OrderField="LocDesc"
    s:Sort="Date" OrderField="INPP_Date"
    s:Sort="User" OrderField="UserName"
    s:Sort="PoFlag" OrderField="INPP_PoFlag"
    s:Sort="CmpFlag" OrderField="INPP_Complete"
    ;
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i OrderField'=""  d
    .s StrSql=StrSql_" order by "_OrderField_" "_Dir
    ;s ^zdm("Query_sql")=StrSql
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
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    ;
    ;b ;1
    While(result.Next())
    {   
        s Rowid = result.Data("Rowid")
        i VendorId'="" CONTINUE:$$ChkVen(VendorId,Rowid)=0
        i IncId'=""  CONTINUE:$$ChkInci(IncId,Rowid)=0
        s PurNo = result.Data("INPP_No")
        s LocId = result.Data("INPP_CTLOC_DR")
        s Loc = result.Data("LocDesc")
        s Date = result.Data("INPP_Date")
        s:+Date'=0 Date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(Date,"ST")
        s User = result.Data("UserName")
        s PoFlag = result.Data("INPP_PoFlag")
        s CmpFlag = result.Data("INPP_Complete")
        s AuditFlag= result.Data("INPP_AuditFlag")
        s:AuditFlag="" AuditFlag="N"
        s StkGrpId=result.Data("INPP_SCG_DR")
        s:StkGrpId'="" StkGrp=$p(^DHCSCG(StkGrpId),"^",2)
        s StkGrpType=result.Data("INPP_StkType")
        CONTINUE:StkGrpType'=..sssCode()     ;非药品采购单
        i Complete'=""  CONTINUE:CmpFlag'=Complete
        i Audit'=""  CONTINUE:AuditFlag'=Audit
        ;b ;2
        ;
        s Data=Rowid_"^"_PurNo_"^"_LocId_"^"_Loc_"^"_Date_"^"_User_"^"_PoFlag_"^"_CmpFlag_"^"_StkGrpId_"^"_$g(StkGrp)_"^"_AuditFlag
        s count = count+1   
        CONTINUE:count<(Start+1)
        CONTINUE:count>end  
        d json.InsertRowData(Data)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^PurNo^LocId^Loc^Date^User^PoFlag^CmpFlag^StkGrpId^StkGrp^AuditFlag",count)
    k json
    Q resultString

ChkVen(venid,inpp)
 ;检查某采购单中是否包含某供应商
 ;return : 0 - 否 1 -是
 n (venid,inpp)
 s ch=0
 s ok=0
 f  s ch=$o(^INPP(inpp,"PPI",ch)) q:(ch="")!(ok>0)  d
 .i $p(^INPP(inpp,"PPI",ch),"^",1)=venid  s ok=1
 q ok
ChkInci(inci,inpp)
 ;检查某采购单中是否包含某库存项
 ;return : 0 - 否 1 -是
 ;
 n (inci,inpp)
 s ch=0
 s ok=0
 f  s ch=$o(^INPP(inpp,"PPI",ch)) q:(ch="")!(ok>0)  d
 .i $p(^INPP(inpp,"PPI",ch),"^",2)=inci  s ok=1
 q ok
}

/// Descript:   查询某计划单信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-25
/// Table:IN_Purplan
/// Input:采购计划单id
/// Output:     
/// Return：rowid^单号^科室^制单日期^制作人^订单审批^订单完成^类组id^类组名称
/// 
ClassMethod Select(PurId As %String) As %String
{
    n (PurId)
    q:+PurId=0 ""
    s PurNo = $p(^INPP(PurId),"^",1)
    s Date = $p(^INPP(PurId),"^",2)
    s:+Date'=0 Date=$zd(Date,3)
    s UserId = $p(^INPP(PurId),"^",3)
    s:UserId'="" UserName=$p(^SSU("SSUSR",UserId),"^",2)
    s AuditDate = $p(^INPP(PurId),"^",4)
    s:+AuditDate'=0 AuditDate=$zd(AuditDate,3)
    s AuditUserId = $p(^INPP(PurId),"^",5)
    s:AuditUserId'="" AuditUserName=$p(^SSU("SSUSR",AuditUserId),"^",2)
    s PoFlag = $p(^INPP(PurId),"^",6)
    s LocId = $p(^INPP(PurId),"^",7)
    s:LocId'="" LocDesc=$p(^CTLOC(LocId),"^",2) 
    s CmpFlag = $p(^INPP(PurId),"^",8)
    s Time = $p(^INPP(PurId),"^",9)
    s:+Time'=0 Time=$zt(Time,3)
    s AuditFlag=$p(^INPP(PurId),"^",10)
    s:AuditFlag="" AuditFlag="N"
    s AuditTime = $p(^INPP(PurId),"^",11)
    s:+AuditTime'=0 AuditTime=$zt(AuditTime,3)
    s StkGrpId= $p(^INPP(PurId),"^",12)
    s:StkGrpId'="" StkGrp=$p(^DHCSCG(StkGrpId),"^",2)
    s Data1=PurId_"^"_PurNo_"^"_LocId_"^"_$g(LocDesc)_"^"_Date_"^"_UserId_"^"_$g(UserName)
    s Data2=AuditDate_"^"_AuditUserId_"^"_$g(AuditUserName)_"^"_PoFlag_"^"_CmpFlag
    s Data3=Time_"^"_AuditFlag_"^"_AuditTime_"^"_StkGrpId_"^"_$g(StkGrp)
    s Data=Data1_"^"_Data2_"^"_Data3
    q Data
}

/// Descript:   审批某采购计划单
/// Creater:    ZhangDongmei
/// CreateDate: 2012-07-30
/// Table:IN_Purplan
/// Input:rowid，审批人
/// Output:     
/// Return：0,成功,
/// -2   ;更新计划单审批标志失败
/// -3     ;保存订单主表信息失败
/// -4  ;保存订单明细失败
/// -5  ;计划单已经审批
ClassMethod Audit(Rowid As %String, UserId As %String) As %Library.String
{
    n (Rowid,UserId)
    ;s ^zdm("Audit")=Rowid_"^"_UserId
    q:Rowid="" -1
    ;
    s Audit=$p(^INPP(Rowid),"^",10)
    q:Audit="Y" -5      ;计划单已经审批
    ;
    tstart
    s $ZT="Error^DHCSTERROR"    
    s Ret=..SetPurplanAudit(Rowid,UserId,"N")
    i Ret'=0 trollback  q -2   ;更新计划单审批标志失败
    s LocId=$p(^INPP(Rowid),"^",7)
    s GroupId=$p(^SSU("SSUSR",UserId),"^",5)
    s HospId=$p(^CTLOC(LocId),"^",22)
    s Params=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
    s AutoGeneratePO=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.INPurPlan).%GetParameter("AppName"),"AutoGeneratePO",Params)
    i AutoGeneratePO="Y"  d    ;需要自动生成订单的话自动生成订单
    .s Ret=..CreatePo(Rowid,UserId,Params)
    .
    i Ret'=0 trollback
    q:Ret'=0 Ret
    tcommit
    q 0
}

/// Descript:根据采购计划单自动生成订单
/// Creater:    ZhangDongmei
/// CreateDate: 2012-09-27
/// Table:IN_Purplan
/// Input:rowid，审批人
/// Output:     
/// Return：0,成功,
/// -2   ;更新计划单审批标志失败
/// -3     ;保存订单主表信息失败
/// -4  ;保存订单明细失败
/// -5  ;计划单已经审批
/// -6  ;更新in_purplanitm中inppi_inpoi_dr字段失败
ClassMethod CreatePo(Rowid As %String, UserId As %String, Params As %String) As %Library.String
{
    n (Rowid,UserId,Params)
    q:Rowid="" -1
    s CmpFlag="Y"
    s AuditFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.INPurPlan).%GetParameter("AppName"),"SetPPPODefaStatus",Params)
    i AuditFlag=1 s AuditFlag="Y"
    e  s AuditFlag=""
    s PoFlag="Y"
    &sql(update IN_PURPLAN set INPP_PoFlag=:PoFlag where INPP_Rowid=:Rowid)
    s PurLocId=$p(^INPP(Rowid),"^",7)
    s StkGrpId=$p(^INPP(Rowid),"^",12)
    s Pid=..NewPid()
    k ^TMPPURINFO(Pid)
    s rett=$$CollectData()
    q:rett'=0 rett
    s Err=0
    s VenId=0
    f  s VenId=$o(^TMPPURINFO(Pid,VenId)) q:(VenId="")!(Err'=0)  d
    .s MainInfo=VenId_"^"_PurLocId_"^"_UserId_"^"_StkGrpId_"^"_CmpFlag_"^"_"由采购计划生成"_"^"_"^"_AuditFlag
    .s Ret=##class(web.DHCST.INPO).Insert(MainInfo)
    .i +Ret<=0  d
    ..s Err=-3     ;保存订单主表信息失败
    .e  d
    ..s PoId=Ret
    .q:Err'=0
    .;s Sub=0
    .s Inppi=""
    .f  s Inppi=$o(^TMPPURINFO(Pid,VenId,Inppi)) q:(Inppi="")!(Err'=0)  d
    ..s Data=^TMPPURINFO(Pid,VenId,Inppi)
    ..s IncId=$p(Data,"^",1)
    ..s UomId=$p(Data,"^",2)
    ..s Rp=$p(Data,"^",3)
    ..s Qty=$p(Data,"^",4)
    ..s ReqQty=0
    ..s Detail=IncId_"^"_UomId_"^"_Rp_"^"_Qty_"^"_ReqQty
    ..
    ..s Ret=##class(web.DHCST.INPOItm).Insert(PoId,Detail)
    ..i +Ret<=0  d
    ...s Err=-4  ;保存订单明细失败
    ..e  d
    ...s PoItmId=Ret
    ..q:Err'=0
    ..
    ..&sql(update in_purplanitm set inppi_inpoi_dr=:PoItmId where inppi_rowid=:Inppi)
    ..i SQLCODE'=0 d
    ...s Err=-6
    ..
    .
    k ^TMPPURINFO(Pid)
    q:Err'=0 Err
    q 0
    
CollectData()
 s Chl=0
 s Ret=0
 f  s Chl=$o(^INPP(Rowid,"PPI",Chl)) q:(Chl="")!(Ret'=0)  d
 .s VendorId=$p(^INPP(Rowid,"PPI",Chl),"^",1)
 .s:VendorId="" Ret=-10
 .q:VendorId=""
 .s IncId=$p(^INPP(Rowid,"PPI",Chl),"^",2)
 .s Qty=$p(^INPP(Rowid,"PPI",Chl),"^",3)
 .s UomId=$p(^INPP(Rowid,"PPI",Chl),"^",4)
 .s Rp=$p(^INPP(Rowid,"PPI",Chl),"^",5)
 .s BUomId=$p(^INCI(IncId,1),"^",10)
 .s PurUomId=$p(^INCI(IncId,3),"^",6)
 .s Fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(UomId,BUomId)
 .s Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
 .s PurQty=Qty*Fac1/Fac2
 .s PurRp=Rp/Fac1*Fac2
 .
 .s Inppi=Rowid_"||"_Chl
 .s ^TMPPURINFO(Pid,VendorId,Inppi)=IncId_"^"_PurUomId_"^"_PurRp_"^"_PurQty
 .
 .;s SubStr=IncId_"^"_Rp
 .;i '$d(^TMPPURINFO(Pid,VendorId,SubStr))  d
 .;.s ^TMPPURINFO(Pid,VendorId,SubStr)=IncId_"^"_PurUomId_"^"_PurRp_"^"_PurQty
 .;e  d
 .;.s $p(^TMPPURINFO(Pid,VendorId,SubStr),"^",4)=PurQty+$p(^TMPPURINFO(Pid,VendorId,SubStr),"^",4)
 .
 .
 q Ret
}

/// Descript:更新某采购计划单审批标志
/// Creater:    ZhangDongmei
/// CreateDate: 2012-07-30
/// Table:IN_Purplan
/// Input:rowid，审批人id,是否已生成订单标志
/// Output:     
/// Return：0,成功,
/// -1      ;计划单已经完成
/// -3   ;操作失败
ClassMethod SetPurplanAudit(Rowid As %String, User As %String, PoFlag As %String) As %Library.String
{
    n (Rowid,PoFlag,User)
    ;
    ;不能为空项
    q:Rowid="" -1
    s AuditFlag=$p(^INPP(Rowid),"^",10)
    q:AuditFlag="Y" -2      ;计划单已经审批
    s Flag="Y"
    s Date=+$h
    s Time=$p($h,",",2)
    ;
    s Err=0
    ;更新采购计划审批标志
    &sql(update IN_PURPLAN set INPP_AuditDate=:Date,INPP_AuditSSUSR_DR=:User,
    INPP_PoFlag=:PoFlag,INPP_AuditTime=:Time,INPP_AuditFlag=:Flag where INPP_Rowid=:Rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("SetPurplanAudit:IN_PurPlan",Rowid,SQLCODE_":"_%msg)
    .s Err=-3   ;操作失败
    .
    q Err
}

/// Descript:取采购计划界面参数配置属性
/// Creater:    ZhangDongmei
/// CreateDate: 2012-09-27
/// Table:
/// Input:安全组id,科室id,用户id
/// Output:     
/// Return：进价是否可以为空^是否自动审批^默认查找起始日期^默认查找截止日期
/// w ##class(web.DHCST.INPurPlan).GetParamProp(142,102,590)
ClassMethod GetParamProp(GroupId As %String, LocId As %String, UserId As %String) As %Library.String
{
    n (GroupId,LocId,UserId)
    s ^zdm("GetParamProp")=GroupId_"^"_LocId_"^"_UserId
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=##class(web.DHCST.INPurPlan).%GetParameter("AppName")
    s RpNotNull=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RpNotNull",Param)
    s AutoAuditAfterCompleted=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"AutoAuditAfterCompleted",Param)
    s DefaStartDate=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"DefaStartDate",Param)
    s DefaEndDate=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"DefaEndDate",Param)
    ;
    s Data=RpNotNull_"^"_AutoAuditAfterCompleted_"^"_DefaStartDate_"^"_DefaEndDate
    q Data
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("PurInfo"))
}

/// creator:yunhaibao
/// createdate:20150609
/// description:复制采购计划
ClassMethod Copy(planid, userid)
{
	n (planid,userid)
	i userid="" s suerid=1
	q:planid="" -1
	q:'$d(^INPP(planid)) -2
	s locdr=$p(^INPP(planid),"^",7)
	s catgrpdr=$p(^INPP(planid),"^",12)  //类组
	s listdata=""
	s planitm=""
	f  s planitm=$o(^INPP(planid,"PPI",planitm)) q:planitm=""  d
	.q:+planitm=0
	.s INPPPPI=$g(^INPP(planid,"PPI",planitm))
	.s inci=$p(INPPPPI,"^",2) 
	.s qty=$p(INPPPPI,"^",3)
	.s uomid=$p(INPPPPI,"^",4)
	.s rp=$p(INPPPPI,"^",5) //当前进价
	.s manf=$p(INPPPPI,"^",6)
	.s vendor=$p(INPPPPI,"^",1)
	.s carrier=$p(INPPPPI,"^",8)
	.s reqloc=$p(INPPPPI,"^",10)
	.s propurqty=qty
	.s detail=""_"^"_inci_"^"_qty_"^"_uomid_"^"_vendor_"^"_rp_"^"_manf_"^"_carrier_"^"_reqloc_"^"_propurqty
	.i listdata="" d
	..s listdata=detail
	.e  d
	..s listdata=listdata_$c(1)_detail
	s ret=..Save("",locdr,userid,catgrpdr,listdata)
	q ret
}

}
