Import sqluser

Class web.DHCST.DHCINIsTrfAuxByRec Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   查询入库单
/// Creater:zhangdongmei
/// CreateDate:2012-07-27
/// Input:开始行,一页显示记录数,排序字段,排序方向,
/// 开始日期^截止日期^入库单号^供应商id^科室id^包含已出库
/// Output:     
/// Return：入库主表id^入库单号^供应商^入库科室^请求科室^订单号^制单人^制单日期^出库状态
/// w ##class(web.DHCST.DHCINIsTrfAuxByRec).QueryImportForTrans("0","30","","","2022-06-14^2022-07-14^^^187^0",18659)
ClassMethod QueryImportForTrans(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, StrParam As %String, User As %String) As %String
{
    n (StrParam,Start,Limit,Sort,Dir,User,%session)
    s ^YSJTMP("web.DHCST.DHCINGdRec.Query")=$lb(Start , Limit , Sort , Dir , StrParam , User)
    q:StrParam="" ""
    s StartDate=$p(StrParam,"^",1)
    s EndDate=$p(StrParam,"^",2) 
    s No=$p(StrParam,"^",3)
    s VendorId=$p(StrParam,"^",4)
    s RecLocId=$p(StrParam,"^",5)
    s TranFlag=$p(StrParam,"^",6)
    //s StkGrp=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStrNew(User,..sssCode())  //若类组为空，则传递User类组串
    q:StartDate="" ""
    q:EndDate="" ""
    q:RecLocId="" ""
    s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
    s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    ;
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select INGR_RowId as Rowid,INGR_No,INGR_APCVM_DR,INGR_APCVM_DR->APCVM_Name as Vendor,"_
    "INGR_Loc_Dr->CTLOC_Desc as RecLoc,INGR_INPO_DR->INPO_No as PoNo, "_
    "INGR_CreateUser->SSUSR_NAME AS CreateUser, INGR_CreateDate,"_
    "INGR_Completed,INGR_AuditFlag,INGR_SCG_DR,INGR_SCG_DR->SCG_Desc as StkGrp "_
    "from DHC_INGdRec where (INGR_CreateDate between "_StartDate_" and "_EndDate_") and INGR_Loc_Dr="_RecLocId
    ; 
    s OrderField="Rowid"
    ;
    s:Sort="IngrNo" OrderField="INGR_No"
    s:Sort="Vendor" OrderField="Vendor"
    s:Sort="PoNo" OrderField="PoNo"
    s:Sort="CreateUser" OrderField="CreateUser"
    s:Sort="CreateDate" OrderField="INGR_CreateDate"
    s:Sort="Complete" OrderField="INGR_Completed"
    ;
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i OrderField'=""  d
    .s sqlStr=sqlStr_" order by "_OrderField_" "_Dir
    ;s ^zdm("Query_sql")=StrSql
    s json = ##class(Code.JsonObj).%New()
    ;b ;1
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(sqlStr)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    ;
    If err  q ""
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {   s ReqLoc=""
        s IngrId = result.Data("Rowid")
        s IngrNo = result.Data("INGR_No")
        s Vendor = result.Data("Vendor")
        s VenId=result.Data("INGR_APCVM_DR")
        s RecLoc = result.Data("RecLoc")
        s PoNo = result.Data("PoNo")
        s CreateUser = result.Data("CreateUser")
        s CreateDate = result.Data("INGR_CreateDate")
        s Complete = result.Data("INGR_Completed")
        continue:Complete'="Y"    ;未完成的入库单不能出库
        &sql(select INIT_ToLoc_DR->CTLOC_Desc  into :ReqLoc from DHC_InIsTrf  where INIT_INGR_Dr=:IngrId)
        s ReqLoc=$g(ReqLoc)
        s Audit=result.Data("INGR_AuditFlag")
        continue:Audit'="Y"   ;未审核的入库单不能出库
        ;
        CONTINUE:(No'="")&(IngrNo'=No)
        CONTINUE:(VendorId'="")&(VenId'=VendorId)
        s StkGrpId=result.Data("INGR_SCG_DR")
        s StkGrpDesc=result.Data("StkGrp")
        //CONTINUE:(StkGrp'="")&(("^"_StkGrp_"^")'[("^"_StkGrpId_"^"))  //此处不过滤类组信息
        s:CreateDate'="" CreateDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(CreateDate,"ST")
        s Init=$o(^DHCINIT(0,"INGR",IngrId,0))
        i Init=""  d
        .s Status="未转移"
        e  d
        .s Status="已转移"
        .
        continue:(TranFlag'=1)&(Status="已转移")
        ;
        s Data1=IngrId_"^"_IngrNo_"^"_Vendor_"^"_RecLoc_"^"_PoNo_"^"_CreateUser 
        s Data2=CreateDate_"^"_ReqLoc_"^"_Status_"^"_StkGrpId_"^"_StkGrpDesc
        s Data=Data1_"^"_Data2
        s count = count+1   
        CONTINUE:count<(Start+1)
        CONTINUE:count>end  
        d json.InsertRowData(Data)
    }
    s Title1="IngrId^IngrNo^Vendor^RecLoc^PoNo^CreateUser"
    s Title2="CreateDate^ReqLoc^Status^StkGrpId^StkGrpDesc"
    s Title=Title1_"^"_Title2
    s resultString = json.getJsonData(Title,count)
    k json
    q resultString
}

/// Descript:   根据入库单RowId取得入库单明细信息
/// Creater:zhangdongmei
/// CreateDate:2012-07-27
/// Input:开始行,一页显示记录数,排序字段,排序方向,入库主表id
/// Output:     
/// Return：入库子表id^批号^入库单位Id^入库单位^效期^批次id^入库数量(或转移数量)^库存项id^库存项代码
/// ^库存项名称^厂商^进价^进价金额^售价^售价金额^批次库存量^占用数量^可用数量^基本单位Id
/// ^包装单位和基本单位转换率
ClassMethod QueryInportDetailForTrans(Parref As %String) As %String
{
    n (Parref)
    q:Parref="" ""
    s Init=$o(^DHCINIT(0,"INGR",Parref,0))
    ;
    s result = ##class(%Library.ResultSet).%New()
    s StrSql = "SELECT INGRI_Rowid as Rowid, INGRI_BatchNo, INGRI_CTUOM_DR, INGRI_ExpDate,"
            _"INGRI_INCLB_DR, INGRI_RecQty,initm_INCI_DR,initm_INCI_DR->INCI_Code as IncCode, "
            _"initm_INCI_DR->INCI_Desc as IncDesc,initm_phmnf_dr->PHMNF_Name as Manf,"
            _"initm_realprice,initm_realtotal,initm_saleprice, initm_SpAmt "
            _"FROM DHC_INGdRecItm WHERE INGRI_INGR_ParRef= "_Parref
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(StrSql)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    If err  q ""
    s Title1="Ingri^BatchNo^TrUomId^TrUom^ExpDate^Inclb^TrQty^IncId^IncCode"
    s Title2="IncDesc^Manf^Rp^RpAmt^Sp^SpAmt^BUomId^ConFacPur^StkQty^DirtyQty^AvaQty^BatExp"
    s Title=Title1_"^"_Title2
    s count = 0,countrecords=0
    s resultString = ""
    While(result.Next())
    {
        s Ingri = result.Data("Rowid")
        s BatchNo = result.Data("INGRI_BatchNo")
        s IngrUomId = result.Data("INGRI_CTUOM_DR")
        s:IngrUomId'="" IngrUom=$p(^CT("UOM",IngrUomId),"^",2)
        s ExpDate=result.Data("INGRI_ExpDate")
        s:+ExpDate'=0 ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
        s BatExp=BatchNo_"~"_ExpDate
        s Inclb=result.Data("INGRI_INCLB_DR")
        s RecQty = result.Data("INGRI_RecQty")
        s IncId = result.Data("initm_INCI_DR")
        s IncCode = result.Data("IncCode")
        s IncDesc = result.Data("IncDesc")
        s Manf = result.Data("Manf")
        s Rp = result.Data("initm_realprice")
        s RpAmt = result.Data("initm_realtotal")
        s Sp = result.Data("initm_saleprice")
        s SpAmt = result.Data("initm_SpAmt")
        s BUomId=$p(^INCI(IncId,1),"^",10)
        s PurUomId=$p(^INCI(IncId,3),"^",6)
        s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
        s StkQty=##class(web.DHCST.Common.DrugStkCommon).CurQtyINCLBURid(Inclb,IngrUomId)
        s DirtyQty=##class(web.DHCST.Common.DrugStkCommon).CurInclbResQty(Inclb,IngrUomId)
        s AvaQty=##class(web.DHCST.Common.DrugStkCommon).CurInclbAvaQty(Inclb,IngrUomId)
        
        i Init'="" d
        .s InitCh=$o(^DHCINIT(0,"OutsINCI",+Inclb,Init,0))
        .q:InitCh=""
        .s RecQty=$p(^DHCINIT(Init,"ITI",InitCh),"^",1)         ;如已转移,显示转移数量
        ;
        s Data1=Ingri_"^"_BatchNo_"^"_IngrUomId_"^"_$g(IngrUom)_"^"_ExpDate_"^"_Inclb
        s Data2=RecQty_"^"_IncId_"^"_IncCode_"^"_IncDesc_"^"_Manf_"^"_Rp_"^"_RpAmt 
        s Data3=Sp_"^"_SpAmt_"^"_BUomId_"^"_ConFac_"^"_StkQty_"^"_DirtyQty_"^"_AvaQty_"^"_BatExp
        s Data=Data1_"^"_Data2_"^"_Data3
        s count = count+1   
        i count=1 d
        .w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(999)
		.s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(Data,Title)
		.w retstring
		e  d
		.s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(Data,Title)
		.w ","_retstring
    }
    q:+count=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    w "]}"
    q ""
}

/// 根据入库单生成库存转移单
/// Author:zhwh
/// Date:2012-07-20
/// Argu:
///  ingr - 入库主表rowid
///  ToLoc - 请求科室RowId 
/// Return:
///  >0  - 库存转移单主表rowid
///  <0  : 失败
/// Note:
///   库存转移的供应科室使用入库单中的入库科室
ClassMethod CreateTransferByRec(Ingr As %String, ToLoc As %String, User As %String) As %String
{
  
  //构建库存转移主表    
  q:Ingr="" -1
  q:$d(^DHCINGR(Ingr))'=11 -2
  s Loc="",scg="",stkType=""
  &sql(select ingr_loc_dr,ingr_scg_dr,ingr_stktype into :Loc,:scg,:stkType
      from dhc_ingdrec where %ID=:Ingr    )
  q:SQLCODE'=0 -3
  ts
  s data=Loc   //供应科室RowId
  s data=data_"^"_ToLoc  //请求科室RowId
  s data=data_"^"_""
  s data=data_"^"_""
  s data=data_"^"_""
  s data=data_"^"_"10"
  s data=data_"^"_User
  s data=data_"^"_scg
  s data=data_"^"_stkType
  s data=data_"^"_""
  w data,!
  s init=##class(web.DHCST.DHCINIsTrf).Update("",data)
  q:init<0 -4
  s err=0
  s ch=0
  f  s ch=$o(^DHCINGR(Ingr,"GRI",ch)) q:(ch="")!(err<0)  d
  .s ingri=Ingr_"||"_ch
  .s initCh=$o(^DHCINIT(init,"ITI",""),-1)+1
  .
  .&sql(insert into dhc_inistrfitm(
       initi_init_parref,initi_childsub,    
       initi_inclb_dr,initi_qty,initi_ctuom_dr,
       dhciti_realprice,
       dhciti_rpamount,
       dhciti_saleprice,
       dhciti_spamount,
       dhciti_purprice,
       dhciti_ppamount,
       dhciti_newsp,
       dhciti_newspamt )
      select :init,:initCh,
       ingri_inclb_dr,ingri_recqty,ingri_ctuom_dr,
        initm_realprice,
        initm_realtotal,
       initm_saleprice,
       initm_spamt,
       initm_batprice,
       initm_batprice*ingri_recqty,
        initm_newsp,
        initm_newspamt
      from dhc_ingdrecitm
      where %ID=:ingri)
    .i SQLCODE'=0 tro  s err=-15 q 
    .
   q:err<0 err
   i err=0 tc
   i init>0 q init
   q -16
}

}
