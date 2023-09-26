Import sqluser

/// Descript:虚拟入库相关
/// Creater: xuchao
/// CreateDate: 2013-05-31
Class web.DHCST.VirINGdRet Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTVIRIMPORT";

//虚拟入库单:对于医院上线之初初始化的库存,由于缺少具体的供应商进价等信息为完成

// 退货所需要的入库信息制作虚拟入库单,制单日期最好比较靠前

//

//该虚拟入库单不影响库存,台帐,实际上只是使dhc_ingdrec 和in_gdrec,dhc_ingdrecitm与in_gdrecitm做关联

//注意：InsRecItm和InsMaster在不同客户的区分。

ClassMethod SaveVirtualImp(mainData As %String, detailData As %String) As %Library.String
{
   ;保存虚拟入库单
  n (mainData,detailData)

  s User=$P(mainData,"^",1)
  s StkType=$P(mainData,"^",2)
  s Loc=$P(mainData,"^",3)
  s Vendor=$P(mainData,"^",4)
  s date=$P(mainData,"^",5)
  s:date'="" date=$zdh(date,3)
  s StkGrpType=$P(mainData,"^",6)
  q:User="" -1
  q:Loc="" -2
  q:Vendor="" -3
  q:date="" -4
  ts
  //s $ZT="Error^DHCSTERROR" 
  s main=..InsMaster(User,Loc,Vendor,date,StkGrpType)
  i main'>0 trollback  
  q:main'>0 -9
  s rowdelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim() 
  s cnt=$l(detailData,rowdelim)
  s ret=0
  f i=1:1:cnt d
  .s row=$p(detailData,rowdelim,i)
  .s ret=..InsRecItm(+main,row)
  .i ret<0 trollback
  .q:ret<0
  q:ret<0 -10
  tc
  ;s INGDNO=..GetGrNo(main)
  ;q INGDNO
  q main
}

ClassMethod InsMaster(user As %String, loc As %String, ven As %String, date As %String, StkGrpType As %String) As %Library.String
{
  ;保存主表  
  n (user,loc,ven,date,StkGrpType)
  s StkType=..sssCode()
  s AppName=..%GetParameter("AppName")
  s ret=##class(web.DHCST.Common.AppCommon).Lock("VIRIMPORTNO")  
  q:ret'=0 -99  ;加锁失败
  s IngrNo=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,StkGrpType,loc)
  i IngrNo="" d ##class(web.DHCST.Common.AppCommon).UnLock("VIRIMPORTNO")
  q:IngrNo="" -2   ;生成单号失败
    s VenId=ven
    s LocId=loc
    s CreateUser=user
    s CreateDate=date
    s CreateTime=$p($h,",",2)
    s PresentFlag="N"
    s ExchangeFlag="N"
    s IngrTypeId=""
    s PurUserId=""
    s StkGrpId=StkGrpType
    s PoId=""
    s Complete="Y"
    s AuditFlag="Y"
    s StkType=..sssCode()
    s Err=0
    //审核日期时间人员按制单信息保存
    &sql(insert into dhc_ingdrec(INGR_APCVM_DR,INGR_Completed,INGR_CTCUR_DR,
         INGR_ExRate,INGR_HandChg,INGR_No,INGR_Loc_Dr,INGR_CreateUser,
         INGR_CreateDate,INGR_CreateTime,INGR_AdjCheque,INGR_GiftFlag,INGR_Type,
         INGR_SSUSR_Purch_DR,INGR_SCG_DR,INGR_AuditFlag,INGR_StkType,INGR_INPO_DR,
         INGR_Date,INGR_Time,INGR_SSUSR_DR) 
         values (:VenId,:Complete,1,1,0,:IngrNo,:LocId,:CreateUser,:CreateDate,:CreateTime,
         :ExchangeFlag,:PresentFlag,:IngrTypeId,:PurUserId,:StkGrpId,:AuditFlag,:StkType,:PoId,
         :CreateDate,:CreateTime,:CreateUser))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:VIRingdrec",IngrNo,SQLCODE_":"_%msg)
    .s Err=-3
    d ##class(web.DHCST.Common.AppCommon).UnLock("VIRIMPORTNO")
    q:Err'=0 -3    ;保存入库单失败
    q $p($g(%ROWID),$c(1))
}

ClassMethod InsRecItm(main As %String, datas As %String) As %Library.String
{
 n (main,datas)  
 s main=+main
 q:main="" ""
 s inclb=$p(datas,"^",1)
 s inci=+inclb
 s recqty=$p(datas,"^",2)
 s uom=$p(datas,"^",3)
 s stkdesc=$p(^INCI(inci,1),"^",2)
 s recloc=$p(^INCI(inci,"IL",$p(inclb,"||",2)),"^",1)
 Q:recloc="" -3
 s rp=$p(datas,"^",4)
 s sp=$p(datas,"^",5)
 &sql(select inclb_incib_dr->incib_no,inclb_incib_dr->incib_expdate into :batno,:expdate
   from inc_itmlcbt where inclb_rowid=:inclb)
    s IncId=+inclb
    s BatNo=batno
    s ExpDate=expdate
    s ManfId=""
    s UomId=uom
    s Qty=recqty
    s Rp=rp
    s NewSp=0
    s SxNo=""
    s InvNo=""
    s InvDate=""
    s PoItmId=""
    s Remark=""
    s Remarks=""
    s QualityNo=""
    s MtDr=""
    q:IncId="" ""
    q:+Qty=0 ""

    s IncDesc=$p(^INCI(IncId,1),"^",2)
    s BuomId=$p(^INCI(IncId,1),"^",10)
    q:BuomId="" ""   ;基本单位不能为空
    s Chl=1+$o(^DHCINGR(main,"GRI",""),-1)
    s LocId=$p(^DHCINGR(main),"^",13)
    s HospId=$p(^CTLOC(LocId),"^",22)
    //s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(IncId,+$h,UomId,HospId)  ;格式化后的售价
    s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclb,+$h,UomId,HospId,"G","")  ;格式化后的售价
    s:+NewSp=0 NewSp=Sp
    i UomId=BuomId d
    .s NewSp=##class(web.DHCST.Common.AppCommon).FormatSp(NewSp,HospId,2)
    .s Rp=##class(web.DHCST.Common.AppCommon).FormatRp(Rp,HospId,2)
    e  d
    .s NewSp=##class(web.DHCST.Common.AppCommon).FormatSp(NewSp,HospId,1)
    .s Rp=##class(web.DHCST.Common.AppCommon).FormatRp(Rp,HospId,1)
    ;
    s SpAmt=Sp*Qty
    s RpAmt=Rp*Qty
    s NewSpAmt=NewSp*Qty
    s SpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
    s NewSpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(NewSpAmt,HospId)
    s RpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
    s Margin=NewSp/Rp-1
    s InvAmt=RpAmt
    s Remarks=$lfs(Remarks)
    ;b ;21
    s Err=0
    &sql(INSERT INTO DHC_INGdRecItm(INGRI_INGR_ParRef,INGRI_ChildSub,INGRI_BatchNo,INGRI_CTLOC_DR, 
    INGRI_CTUOM_DR,INGRI_ExpDate,INGRI_INCLB_DR,INGRI_Margin,INGRI_RecQty, INGRI_StkDesc,initm_INCI_DR, initm_invmoney, 
    initm_invno, initm_phmnf_dr, initm_realprice,initm_realtotal, initm_saleprice, initm_invdate, 
    initm_BatPrice, initm_sxno,initm_newSp, initm_newSpAmt,initm_SpAmt,INGRI_INPOI_DR,initm_Remark,
    INGRI_Remarks,initm_QualityNo,initm_MT_Dr)
    VALUES(:main, :Chl, :BatNo, :LocId,:UomId,:ExpDate,:inclb,:Margin,:Qty, :IncDesc,
    :IncId, :InvAmt,:InvNo,:ManfId,:Rp,:RpAmt,:Sp,:InvDate,:Rp, :SxNo,:NewSp,
    :NewSpAmt,:SpAmt,:PoItmId,:Remark,:Remarks,:QualityNo,:MtDr))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_INGdRecItm",IncDesc,SQLCODE_":"_%msg)
    .s Err=-3
    .
    q:Err'=0 ""    ;保存入库明细失败
 s DHCINGRI=%ROWID
 s DHCINTR=..InsTrans(DHCINGRI)
 q:DHCINTR'>0 -5
 q $p($g(%ROWID),$c(1))
}

/// 查询入库单号
ClassMethod GetGrNo(main As %String) As %Library.String
{
  n (main)
  &sql(select ingr_no into :no from dhc_ingdrec where ingr_rowid=:main)
  q:SQLCODE ""
  q $g(no)
}

/// 生成台帐记录
/// -114 保存台帐失败; -115 更新台帐时间失败
ClassMethod InsTrans(dhcingri As %String) As %Library.String
{
 //虚拟入库记录生成数据到dhc_intrans,为了退货查询
 n (dhcingri)
 q:dhcingri="" -1
 //
 s DHCINGR=$p(dhcingri,"||",1)
 s CH=$p(dhcingri,"||",2)
 //
 s type="G"
 s grno=$p(^DHCINGR(DHCINGR),"^",1)
 s inclb=$p(^DHCINGR(DHCINGR,"GRI",CH),"^",1)
 s recqty=$p(^DHCINGR(DHCINGR,"GRI",CH),"^",4)
 s recuom=$p(^DHCINGR(DHCINGR,"GRI",CH),"^",10)
 s inci=$p(^DHCINGR(DHCINGR,"GRI",CH),"^",25)
 s incicode=$P(^INCI(inci,1),"^",1)
 s sprice=$p(^DHCINGR(DHCINGR,"GRI",CH),"^",32)
 s auditUser=$p(^DHCINGR(DHCINGR),"^",8)
 s detRowid=dhcingri
 s transData=type_"^"_grno_"^"_inclb_"^"_recqty_"^"_recuom_"^"_sprice_"^"_auditUser_"^"_detRowid_"^"_"0"_"^"_"0"_"^"_"0"
 s Ret=##class(web.DHCST.Common.StockHandle).IntoTrans(transData)
 q:Ret<0 -114  ;保存台帐失败
 //由于上述函数的日期使用的是当前日期,以下修改为入库日期
 //s ingrdate=$P(^DHCINGR(DHCINGR),"^",4)
 s ingrdate=21550 //1900-01-01
 s err=0
 i (ingrdate'="")&(Ret>0) d
 . &sql(update dhc_intrans set intr_date=:ingrdate where intr_rowid=:Ret)
 . i SQLCODE<0 s err=-115
 q:err'=0 err
 
 q Ret
}

ClassMethod Select(Ingr As %String) As %String
{
    n (Ingr)
    q:+Ingr=0 ""
    S InGrNo =$p(^DHCINGR(Ingr),"^",1)
    S ApcvmDr =$p(^DHCINGR(Ingr),"^",3)
    s:ApcvmDr'="" Vendor=$p(^APC("APCVM",ApcvmDr),"^",3)
    s AuditDate=$p(^DHCINGR(Ingr),"^",4)
    s:+AuditDate'=0 AuditDate=$zd(AuditDate,3)
    s AuditUserId=$p(^DHCINGR(Ingr),"^",8)
    s:AuditUserId'="" AuditUser=$p(^SSU("SSUSR",AuditUserId),"^",2)
    s AuditTime=$p(^DHCINGR(Ingr),"^",9)
    s:+AuditTime'=0 AuditTime=$zt(AuditTime,3)
    s PoId=$p(^DHCINGR(Ingr),"^",11)
    s:PoId'="" PoNo=$p(^INPO(PoId),"^",1)
    s Complete=$p(^DHCINGR(Ingr),"^",12)
    s LocId=$p(^DHCINGR(Ingr),"^",13)
    s:LocId'="" LocDesc=$p(^CTLOC(LocId),"^",2)
    s CreateDate=$p(^DHCINGR(Ingr),"^",14)
    s:+CreateDate'=0 CreateDate=$zd(CreateDate,3)
    s CreateTime=$p(^DHCINGR(Ingr),"^",15)
    s:+CreateTime'=0 CreateTime=$zd(CreateTime,3)
    s CreateUserId=$p(^DHCINGR(Ingr),"^",16)
    s:CreateUserId'="" CreateUser=$p(^SSU("SSUSR",CreateUserId),"^",2)
    s PayAllowed=$p(^DHCINGR(Ingr),"^",22)   ;是否允许付款
    s IngrTypeId=$p(^DHCINGR(Ingr),"^",23)
    s:IngrTypeId'="" IngrType=$p(^DHCOPTYPE(IngrTypeId),"^",2)
    s PurUserId=$p(^DHCINGR(Ingr),"^",24)
    s:PurUserId'="" PurUser=$p(^SSU("SSUSR",PurUserId),"^",2)
    s ReqLocId=$p(^DHCINGR(Ingr),"^",25)
    s:ReqLocId'="" ReqLoc=$p(^CTLOC(ReqLocId),"^",2)
    s AcceptUserId=$p(^DHCINGR(Ingr),"^",26)
    s:AcceptUserId'="" AcceptUser=$p(^SSU("SSUSR",AcceptUserId),"^",2)
    s TreasureUserId=$p(^DHCINGR(Ingr),"^",27)
    s:TreasureUserId'="" TreasureUser=$p(^SSU("SSUSR",TreasureUserId),"^",2)
    s StkGrpId=$p(^DHCINGR(Ingr),"^",28)
    s:StkGrpId'="" StkGrp=$p(^DHCSCG(StkGrpId),"^",2)
    s AuditFlag=$p(^DHCINGR(Ingr),"^",29)
    s StkType=$p(^DHCINGR(Ingr),"^",30)
    q:StkType'=..sssCode() ""
    s GiftFlag=$p(^DHCINGR(Ingr),"^",31)
    s AdjCheque=$p(^DHCINGR(Ingr),"^",32)
    ;
    s Data1=InGrNo_"^"_ApcvmDr_"^"_$g(Vendor)_"^"_AuditDate_"^"_AuditUserId_"^"_$g(AuditUser)
    s Data2=AuditTime_"^"_PoId_"^"_$g(PoNo)_"^"_Complete_"^"_LocId_"^"_$g(LocDesc)
    s Data3=CreateDate_"^"_CreateTime_"^"_CreateUserId_"^"_$g(CreateUser)_"^"_PayAllowed_"^"_IngrTypeId
    s Data4=$g(IngrType)_"^"_PurUserId_"^"_$g(PurUser)_"^"_ReqLocId_"^"_$g(ReqLoc)_"^"_AcceptUserId
    s Data5=$g(AcceptUser)_"^"_TreasureUserId_"^"_$g(TreasureUser)_"^"_StkGrpId_"^"_$g(StkGrp)_"^"_AuditFlag
    s Data6=GiftFlag_"^"_AdjCheque
    s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5_"^"_Data6
    q Data
}

ClassMethod Query(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, Parref As %String) As %String
{
    n (Parref,Start,Limit,Sort,Dir)
    ;s ^zdm("Query")=Parref_","_Start_","_Limit_","_Sort_","_Dir
    q:Parref="" "" 
    ;
    s result = ##class(%Library.ResultSet).%New()
    s StrSql = "SELECT INGRI_Rowid as Rowid, INGRI_BatchNo, INGRI_CTUOM_DR, INGRI_ExpDate,"
            _"INGRI_INCLB_DR, INGRI_INPOI_DR, INGRI_Margin, INGRI_RecQty,INGRI_Remarks, "
            _"initm_INCI_DR,initm_INCI_DR->INCI_Code as IncCode,initm_INCI_DR->INCI_Desc as IncDesc,"
            _"initm_invmoney, initm_invno, initm_payno, initm_phmnf_dr,initm_phmnf_dr->PHMNF_Name as Manf,"
            _"initm_realprice,initm_realtotal,initm_saleprice, initm_SpAmt, initm_invdate, initm_BatPrice,"
            _"initm_QualityNo,initm_sxno,initm_Remark,initm_newSp,initm_newSpAmt,initm_MT_Dr,initm_PubBL, "
            _"initm_CheckPort,initm_CheckRepNo,initm_CheckRepDate,initm_AdmNo,initm_AdmExpdate,initm_CheckPack "
            _"FROM DHC_INGdRecItm WHERE INGRI_INGR_ParRef= "_Parref
    s OrderField="Rowid"
    ;
    s:Sort="IncCode" OrderField="IncCode"
    s:Sort="IncDesc" OrderField="IncDesc"
    s:Sort="Manf" OrderField="Manf"
    s:Sort="Qty" OrderField="INGRI_RecQty"
    s:Sort="Rp" OrderField="initm_realprice"
    s:Sort="Sp" OrderField="initm_saleprice"
    ;
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i OrderField'=""  d
    .s StrSql=StrSql_" order by "_OrderField_" "_Dir
    ;s ^zdm("Query_sql")=StrSql
    ;
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(StrSql)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    ;b ;1
    If err  q ""
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
        s Ingri = result.Data("Rowid")
        s BatchNo = result.Data("INGRI_BatchNo")
        s IngrUomId = result.Data("INGRI_CTUOM_DR")
        s IngrUom=""
        s:IngrUomId'="" IngrUom=$p(^CT("UOM",IngrUomId),"^",2)
        s ExpDate=result.Data("INGRI_ExpDate")
        s:+ExpDate'=0 ExpDate=$zd(ExpDate,3)
        s Inclb=result.Data("INGRI_INCLB_DR")
        s Inpoi=result.Data("INGRI_INPOI_DR")
        s RecQty = result.Data("INGRI_RecQty")
        s Remarks = result.Data("INGRI_Remarks")
        s Remarks=$LTS(Remarks)
        s IncId = result.Data("initm_INCI_DR")
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
        s:+InvDate'=0 InvDate=$zd(InvDate,3)
        s BatRp = result.Data("initm_BatPrice")
        s QualityNo = result.Data("initm_QualityNo")
        s SxNo = result.Data("initm_sxno")
        s Remark = result.Data("initm_Remark")     ;摘要
        s NewSp = result.Data("initm_newSp")
        s NewSpAmt = result.Data("initm_newSpAmt")
        s MtDr = result.Data("initm_MT_Dr")      ;定价类型
        s:MtDr'="" MtDesc=$p(^DHCINMT(MtDr),"^",2)
        s PubBL = result.Data("initm_PubBL")            ;招标轮次
        s CheckPort=result.Data("initm_CheckPort")      ;检测口岸
        s CheckRepNo=result.Data("initm_CheckRepNo")    ;检测报告
        s CheckRepDate=result.Data("initm_CheckRepDate")    ;报告日期
        s:CheckRepDate'="" CheckRepDate=$zd(CheckRepDate,3)
        s AdmNo=result.Data("initm_AdmNo")                  ;注册证号
        s AdmExpdate=result.Data("initm_AdmExpdate")        ;注册证有效期
        s:AdmExpdate'="" AdmExpdate=$zd(AdmExpdate,3)
        s CheckPack=result.Data("initm_CheckPack")          ;包装合格
        s:PubBL'="" PubDesc=$p(^DHCPBLIST(PubBL),"^",2)
        s BUomId=$p(^INCI(IncId,1),"^",10)
        s PurUomId=$p(^INCI(IncId,3),"^",6)
        s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
        s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",IncId)  
        s BatchNo=BatchNo_"~"_ExpDate
        ;
        s Data1=Ingri_"^"_BatchNo_"^"_IngrUomId_"^"_$g(IngrUom)_"^"_ExpDate_"^"_Inclb_"^"_Inpoi 
        s Data2=Margin_"^"_RecQty_"^"_Remarks_"^"_IncId_"^"_IncCode_"^"_IncDesc_"^"_InvMoney_"^"_InvNo 
        s Data3=PayNo_"^"_ManfId_"^"_Manf_"^"_Rp_"^"_RpAmt_"^"_Sp_"^"_SpAmt_"^"_InvDate_"^"_BatRp_"^"_QualityNo_"^"_SxNo 
        s Data4=Remark_"^"_NewSp_"^"_NewSpAmt_"^"_MtDr_"^"_$g(MtDesc)_"^"_PubBL_"^"_$g(PubDesc)_"^"_BUomId_"^"_ConFac
        s Data5=CheckPort_"^"_CheckRepNo_"^"_CheckRepDate_"^"_AdmNo_"^"_AdmExpdate_"^"_CheckPack_"^"_Spec
        s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5
        s count = count+1   
        CONTINUE:count<(Start+1)
        CONTINUE:count>end  
        d json.InsertRowData(Data)
    }
    s Title1="Ingri^BatchNo^IngrUomId^IngrUom^ExpDate^Inclb^Inpoi^Margin^RecQty^Remarks^IncId^IncCode"
    s Title2="IncDesc^InvMoney^InvNo^PayNo^ManfId^Manf^Rp^RpAmt^Sp^SpAmt^InvDate^BatRp"
    s Title3="QualityNo^SxNo^Remark^NewSp^NewSpAmt^MtDr^MtDesc^PubBL^PubDesc^BUomId^ConFacPur"
    s Title4="CheckPort^CheckRepNo^CheckRepDate^AdmNo^AdmExpdate^CheckPack^Spec"
    s Title=Title1_"^"_Title2_"^"_Title3_"^"_Title4
    s resultString = json.getJsonData(Title,count)
    k json
    q resultString
}

}
