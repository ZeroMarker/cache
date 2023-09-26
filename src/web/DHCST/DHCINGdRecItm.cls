Import sqluser

/// Descript:入库明细表相关
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-26
Class web.DHCST.DHCINGdRecItm Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   保存/更新入库明细信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-26
/// Table:DHC_InGdRecItm
/// Input:主表id,
/// 明细id^库存项RowId^批号^效期^厂商RowId^入库单位RowId^入库数量^进价^New售价^随行单号^发票号^发票日期^订单明细id,
/// 明细id^库存项RowId^批号^效期^厂商RowId^入库单位RowId^入库数量^进价^New售价^随行单号^发票号^发票日期^订单明细id,
/// Output:     
/// Return：0：成功，
/// -5:主表id或明细不能为空
/// -6:所有明细保存均失败
/// -7其它：部分明细保存不成功，提示不成功的药品
ClassMethod Save(IngrId As %String, ListData As %String) As %Library.String
{
    n (IngrId,ListData,MainInfo) 
    q:IngrId="" -5
    q:ListData="" -5
    s Len=$l(ListData,$c(1))
    s Count=0
    s Err=""
    f i=1:1:Len  d
    .s Data=$p(ListData,$c(1),i)
    .s Rowid=$p(Data,"^",1)
    .s IncId=$p(Data,"^",2)
    .q:IncId=""
    .s IncDesc=$p(^INCI(IncId,1),"^",2)
    .s Detail=$p(Data,"^",2,$l(Data,"^"))
    .;b ;11
    .i Rowid'=""  d
    ..s Ret=..Update(Rowid,Detail)
    ..s Ingri=Rowid
    ..i Ret'=0  d
    ...s Err=Err_","_IncDesc
    ..e  d
    ...s Count=Count+1
    .e  d
    ..s Ret=..Insert(IngrId,Detail)
    ..;b ;22
    ..s Ingri=Ret
    ..i Ret=""  d
    ...s Err=Err_","_IncDesc
    ..e  d
    ...s Count=Count+1
    .

    q:Count=0 -6  ;所有明细保存均失败
    q:Err'="" -7 //_"^"_Err  ;保存失败的药品
    q 0
}

/// Descript:   插入入库明细信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-26
/// Table:DHC_InGdRecItm
/// Input:主表id,
/// 库存项RowId^批号^效期^厂商RowId^入库单位RowId^入库数量^进价^New售价^随行单号^发票号^发票日期^发票金额
/// Output:     
/// Return：成功:rowid，"",失败
ClassMethod Insert(Parref As %String, ListData As %String) As %Library.String
{
    n (Parref,ListData)
    s IncId=$p(ListData,"^",1)
    s BatNo=$p(ListData,"^",2)
    s ExpDate=$p(ListData,"^",3)
    s:ExpDate'="" ExpDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ExpDate)
    s ManfId=$p(ListData,"^",4)
    s UomId=$p(ListData,"^",5)
    s Qty=$p(ListData,"^",6)
    s Rp=$p(ListData,"^",7)
    s NewSp=$p(ListData,"^",8)
    s SxNo=$p(ListData,"^",9)
    s InvNo=$p(ListData,"^",10)
    s InvDate=$p(ListData,"^",11)
    s:InvDate'="" InvDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(InvDate)
    s PoItmId=$p(ListData,"^",12)
    s Remark=$p(ListData,"^",13)
    s Remarks=$p(ListData,"^",14)
    s QualityNo=$p(ListData,"^",15)
    s MtDr=$p(ListData,"^",16)
    s OriginId=$p(ListData,"^",17)
    s Info=$o(^DHCITMINFO(0,"INCI",IncId,0))
    i MtDr="" s MtDr=$p(^DHCITMINFO(Info),"^",15)
    q:IncId="" ""
    q:+Qty=0 ""
    q:Parref="" ""
    ;
    
    s IncDesc=$p(^INCI(IncId,1),"^",2)
    s BuomId=$p(^INCI(IncId,1),"^",10)
    q:BuomId=""""   ;基本单位不能为空
    s Chl=1+$o(^DHCINGR(Parref,"GRI",""),-1)
    s LocId=$p(^DHCINGR(Parref),"^",13)
    s HospId=$p(^CTLOC(LocId),"^",22)
    //s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(IncId,+$h,UomId,HospId)  ;格式化后的售价 20140211zhouyg注释掉,因为如执行批次售价，入库售价与当前售价可能不一致
    //s:+NewSp=0 NewSp=Sp
    s NewSp=##class(web.DHCST.Common.AppCommon).FormatInciSp(NewSp,HospId,IncId,UomId)
    s Rp=##class(web.DHCST.Common.AppCommon).FormatInciRp(Rp,HospId,IncId,UomId)
    s Sp=NewSp
    ;
    s SpAmt=Sp*Qty
    s RpAmt=Rp*Qty
    s NewSpAmt=NewSp*Qty
    s SpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
    s NewSpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(NewSpAmt,HospId)
    s RpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
    s Margin=""
    i +Rp'=0  s Margin=NewSp/Rp-1
    s InvAmt=RpAmt
    s Remarks=$LFS(Remarks)
    s Err=0
    &sql(INSERT INTO DHC_INGdRecItm(INGRI_INGR_ParRef,INGRI_ChildSub,INGRI_BatchNo,INGRI_CTLOC_DR, 
    INGRI_CTUOM_DR,INGRI_ExpDate,INGRI_Margin,INGRI_RecQty, INGRI_StkDesc,initm_INCI_DR, initm_invmoney, 
    initm_invno, initm_phmnf_dr, initm_realprice,initm_realtotal, initm_saleprice, initm_invdate, 
    initm_BatPrice, initm_sxno,initm_newSp, initm_newSpAmt,initm_SpAmt,INGRI_INPOI_DR,initm_Remark,
    INGRI_Remarks,initm_QualityNo,initm_MT_Dr,INITM_Orig_DR)
    VALUES(:Parref, :Chl, :BatNo, :LocId,:UomId,:ExpDate,:Margin,:Qty, :IncDesc,
    :IncId, :InvAmt,:InvNo,:ManfId,:Rp,:RpAmt,:Sp,:InvDate,:Rp, :SxNo,:NewSp,:NewSpAmt,:SpAmt,:PoItmId,:Remark,
    :Remarks,:QualityNo,:MtDr,:OriginId))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_INGdRecItm",IncDesc,SQLCODE_":"_%msg)
    .s Err=-3
    .
    q:Err'=0 ""    ;保存入库明细失败
    ;
    q $p($g(%ROWID),$c(1))
}

/// Descript:更新入库明细信息
/// Creater:ZhangDongmei
/// CreateDate: 2012-06-26
/// Table:DHC_InGdRecItm
/// Input:rowid,库存项RowId^批号^效期^厂商RowId^入库单位RowId^入库数量^进价^New售价^随行单号^发票号^发票日期^发票金额
/// Output:     
/// Return：成功:0，其它,失败
ClassMethod Update(Rowid As %String, ListData As %String) As %Library.String [ Private ]
{
    n (Rowid,ListData)
    s inclb=$p(^DHCINGR(+Rowid,"GRI",$p(Rowid,"||",2)),"^",1)
    q:inclb'="" -1
    s IncId=$p(ListData,"^",1)
    s BatNo=$p(ListData,"^",2)
    s ExpDate=$p(ListData,"^",3)
    s:ExpDate'="" ExpDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ExpDate)
    s ManfId=$p(ListData,"^",4)
    s UomId=$p(ListData,"^",5)
    s Qty=$p(ListData,"^",6)
    s Rp=$p(ListData,"^",7)
    s NewSp=$p(ListData,"^",8)
    s SxNo=$p(ListData,"^",9)
    s InvNo=$p(ListData,"^",10)
    s InvDate=$p(ListData,"^",11)
    s:InvDate'="" InvDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(InvDate)
    s Remark=$p(ListData,"^",13)
    s Remarks=$p(ListData,"^",14)
    s Remarks=$lfs(Remarks)
    s QualityNo=$p(ListData,"^",15)
    s MtDr=$p(ListData,"^",16)
    s OriginId=$p(ListData,"^",17)
    s Info=$o(^DHCITMINFO(0,"INCI",IncId,0))
    i MtDr="" s MtDr=$p(^DHCITMINFO(Info),"^",15)    
    q:IncId="" -1
    q:+Qty=0 -1
    q:Rowid="" -1
    s Parref=+Rowid
    ;
    s IncDesc=$p(^INCI(IncId,1),"^",2)
    s BuomId=$p(^INCI(IncId,1),"^",10)
    q:BuomId="" -1      ;基本单位不能为空
    s Chl=1+$o(^DHCINGR(Parref,"GRI",0))
    s LocId=$p(^DHCINGR(Parref),"^",13)
    s HospId=$p(^CTLOC(LocId),"^",22)
    //s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(IncId,+$h,UomId,HospId)  ;格式化后的售价 20140211zhouyg注释掉,因为如执行批次售价，入库售价与当前售价可能不一致
    //s:+NewSp=0 NewSp=Sp
    s NewSp=##class(web.DHCST.Common.AppCommon).FormatInciSp(NewSp,HospId,IncId,UomId)
    s Rp=##class(web.DHCST.Common.AppCommon).FormatInciRp(Rp,HospId,IncId,UomId)
    s Sp=NewSp
    ;
    s SpAmt=Sp*Qty
    s RpAmt=Rp*Qty
    s NewSpAmt=NewSp*Qty
    s InvAmt=RpAmt
  
    s SpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
    s NewSpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(NewSpAmt,HospId) 
    s RpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
    s Margin=""
    i +Rp'=0  s Margin=NewSp/Rp-1
    ;
    s Err=0
    &sql(Update DHC_INGdRecItm set INGRI_BatchNo=:BatNo,INGRI_CTUOM_DR=:UomId,INGRI_ExpDate=:ExpDate,
    INGRI_Margin=:Margin,INGRI_RecQty=:Qty,INGRI_StkDesc=:IncDesc,initm_INCI_DR=:IncId, 
    initm_invmoney=:InvAmt,initm_invno=:InvNo, initm_phmnf_dr=:ManfId,initm_realprice=:Rp,
    initm_realtotal=:RpAmt, initm_saleprice=:Sp, initm_invdate=:InvDate,initm_BatPrice=:Rp, 
    initm_sxno=:SxNo,initm_newSp=:NewSp, initm_newSpAmt=:NewSpAmt,initm_Remark=:Remark,
    INGRI_Remarks=:Remarks,initm_QualityNo=:QualityNo,initm_SpAmt=:SpAmt,initm_MT_Dr=:MtDr,
    INITM_Orig_DR=:OriginId
    where INGRI_Rowid=:Rowid) 
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_INGdRecItm",Rowid,SQLCODE_":"_%msg)
    .s Err=-3
    .
    q:Err'=0 -11    ;更新入库明细失败
    ;
    q 0
}

/// Descript:   删除某入库明细信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-26
/// Table:DHC_InGdRecItm
/// Input:rowid
/// Output:     
/// Return：成功:0，
/// -1  ;入库单已经完成，不能删除
/// -2  ;入库单已经审核，不能删除
/// -3  ;删除入库明细失败
/// -4  ;明细已经审核
ClassMethod Delete(Rowid As %String) As %Library.String
{
    n (Rowid)
    ;
    q:Rowid="" ""
    s CompFlag=$p(^DHCINGR(+Rowid),"^",12)
    s AuditFlag=$p(^DHCINGR(+Rowid),"^",29)
    q:CompFlag="Y" -1       ;入库单已经完成，不能删除
    q:AuditFlag="Y" -2      ;入库单已经审核，不能删除
    
    s inclb=$p(^DHCINGR(+Rowid,"GRI",$p(Rowid,"||",2)),"^",1)
    q:inclb'="" -4
    ;
    s Err=0
    &sql(Delete From DHC_InGdRecItm  where INGRI_Rowid=:Rowid) 
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_InGdRecItm",Rowid,SQLCODE_":"_%msg)
    .s Err=-3
    .
    q:Err'=0 -3   ;删除计划明细失败
    ;
    q 0
}

/// Descript:   删除某入库单所有明细信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-26
/// Table:DHC_InGdRecItm
/// Input:入库主表id
/// Output:     
/// Return：成功:0，
/// -1      ;订单已经完成，不能删除
/// -2      ;订单已经审核，不能删除
/// -3   ;删除计划明细失败
ClassMethod DeleteAll(Parref As %String) As %Library.String
{
    n (Parref)
    ;
    q:Parref="" ""
    q:'$d(^DHCINGR(Parref)) 0   ;已经删除
    s CompFlag=$p(^DHCINGR(Parref),"^",23)
    s AuditFlag=$p(^DHCINGR(Parref),"^",29)
    q:CompFlag="Y" -1       ;入库单已经完成，不能删除
    q:AuditFlag="Y" -2      ;入库单已经审核，不能删除
    ;
    s Err=0
    &sql(Delete From DHC_InGdRecItm  where INGRI_INGR_ParRef=:Parref) 
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("DeleteAll:DHC_InGdRecItm",Parref,SQLCODE_":"_%msg)
    .s Err=-3
    .
    q:Err'=0 -3   ;删除入库明细失败
    ;
    q 0
}

/// Descript:   根据入库单RowId取得入库单明细信息
/// Creater:zhangdongmei
/// CreateDate:2012-06-26
/// Input:开始行,一页显示记录数,排序字段,排序方向,入库主表id
/// Output:     
/// Return：入库子表id^批号^入库单位Id^入库单位^效期^批次id^订单子表id^加成^入库数量^备注^库存项id^库存项代码
/// ^库存项名称^发票金额^发票号^付款单号^厂商Id^厂商^进价^进价金额^售价^售价金额^发票日期^批次进价
/// ^质检单号^随行单号^摘要^入库售价^入库售价金额^定价类型id^定价类型^招标轮次id^招标轮次^基本单位Id^包装单位和基本单位转换率"
/// ^检测口岸^检测报告^报告日期^注册证号^注册证有效期^包装合格
/// w ##class(web.DHCST.DHCINGdRecItm).Query(0,30,"","",8170)
ClassMethod Query(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, Parref As %String) As %String
{
    n (Parref,Start,Limit,Sort,Dir,%session)
    s HospId=""
 	i $d(%session) s HospId=$g(%session.Data("LOGON.HOSPID"))
    k QueryDATA
    q:Parref="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s Title1="Ingri^BatchNo^IngrUomId^IngrUom^ExpDate^Inclb^Inpoi^Margin^RecQty^Remarks^IncId^IncCode"
    s Title2="IncDesc^InvMoney^InvNo^PayNo^ManfId^Manf^Rp^RpAmt^Sp^SpAmt^InvDate^BatRp"
    s Title3="QualityNo^SxNo^Remark^NewSp^NewSpAmt^MtDr^MtDesc^PubBL^PubDesc^BUomId^ConFacPur"
    s Title4="CheckPort^CheckRepNo^CheckRepDate^AdmNo^AdmExpdate^CheckPack^Spec^InfoRemark"
    s Title=Title1_"^"_Title2_"^"_Title3_"^"_Title4
    s StrSql = "SELECT INGRI_Rowid as Rowid, INGRI_BatchNo, INGRI_CTUOM_DR, INGRI_ExpDate,"
            _"INGRI_INCLB_DR, INGRI_INPOI_DR, INGRI_Margin, INGRI_RecQty,INGRI_Remarks, "
            _"initm_INCI_DR,initm_INCI_DR->INCI_Code as IncCode,initm_INCI_DR->INCI_Desc as IncDesc,"
            _"initm_invmoney, initm_invno, initm_payno, initm_phmnf_dr,initm_phmnf_dr->PHMNF_Name as Manf,"
            _"initm_realprice,initm_realtotal,initm_saleprice, initm_SpAmt, initm_invdate, initm_BatPrice,"
            _"initm_QualityNo,initm_sxno,initm_Remark,initm_newSp,initm_newSpAmt,initm_MT_Dr,initm_PubBL, "
            _"initm_CheckPort,initm_CheckRepNo,initm_CheckRepDate,initm_AdmNo,initm_AdmExpdate,initm_CheckPack "
            _"FROM DHC_INGdRecItm WHERE INGRI_INGR_ParRef= "_Parref

    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(StrSql)
    s sc=result.Execute()
    i $$$ISERR(sc) q ##class(web.DHCSTEXTCOMMON).GetNoJson()
    // 排序
	s sortNum=$lf($lfs(Title,"^"),Sort)
	s sortAsNum=""
	i (Sort["Qty")||(Sort["Amt")||(Sort["Sp")||(Sort["Rp") s sortAsNum="Y"
    s count = 0
    While(result.Next())
    {
        s Ingri = result.Data("Rowid")
        s BatchNo = result.Data("INGRI_BatchNo")  
        s IngrUomId = result.Data("INGRI_CTUOM_DR")
        s IngrUom=""
        s:IngrUomId'="" IngrUom=$p(^CT("UOM",IngrUomId),"^",2)
        s ExpDate=result.Data("INGRI_ExpDate")
        s:+ExpDate'=0 ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
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
        
        s Rp=##Class(web.DHCST.Common.AppCommon).FormatRp(Rp,HospId,1,"G","",IncId)
		s Sp=##Class(web.DHCST.Common.AppCommon).FormatSp(Sp,HospId,1,"G","",IncId)
		s RpAmt=##Class(web.DHCST.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
		s SpAmt=##Class(web.DHCST.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
        
        s Margin=SpAmt-RpAmt
        s InvDate = result.Data("initm_invdate")
        s:+InvDate'=0 InvDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(InvDate,"ST")
        s BatRp = result.Data("initm_BatPrice")
        s QualityNo = result.Data("initm_QualityNo")
        s SxNo = result.Data("initm_sxno")
        s Remark = result.Data("initm_Remark")     ;摘要
        s NewSp = result.Data("initm_newSp")
        s NewSpAmt = result.Data("initm_newSpAmt")
        s MtDesc=""
        s MtDr = result.Data("initm_MT_Dr")      ;定价类型
        s:MtDr'="" MtDesc=$p($g(^DHCINMT(MtDr)),"^",2)
        s PubBL = result.Data("initm_PubBL")            ;招标轮次
        s CheckPort=result.Data("initm_CheckPort")      ;检测口岸
        s CheckRepNo=result.Data("initm_CheckRepNo")    ;检测报告
        s CheckRepDate=result.Data("initm_CheckRepDate")    ;报告日期
        s:CheckRepDate'="" CheckRepDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(CheckRepDate,"ST")
        s AdmNo=result.Data("initm_AdmNo")                  ;注册证号
        s AdmExpdate=result.Data("initm_AdmExpdate")        ;注册证有效期
        s:AdmExpdate'="" AdmExpdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AdmExpdate,"ST")
        s CheckPack=result.Data("initm_CheckPack")          ;包装合格
        s:PubBL'="" PubDesc=$p($g(^DHCPBLIST(PubBL)),"^",2)
        s BUomId=$p(^INCI(IncId,1),"^",10)
        s PurUomId=$p(^INCI(IncId,3),"^",6)
        s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
        s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",IncId) 
        s Info=$o(^DHCITMINFO(0,"INCI",IncId,0))
        s InfoRemark=""
        i Info'="" s InfoRemark=$p($g(^DHCITMINFO(Info)),"^",10)
        
        ;
        s Data1=Ingri_"^"_BatchNo_"^"_IngrUomId_"^"_$g(IngrUom)_"^"_ExpDate_"^"_Inclb_"^"_Inpoi 
        s Data2=Margin_"^"_RecQty_"^"_Remarks_"^"_IncId_"^"_IncCode_"^"_IncDesc_"^"_InvMoney_"^"_InvNo 
        s Data3=PayNo_"^"_ManfId_"^"_Manf_"^"_Rp_"^"_RpAmt_"^"_Sp_"^"_SpAmt_"^"_InvDate_"^"_BatRp_"^"_QualityNo_"^"_SxNo 
        s Data4=Remark_"^"_NewSp_"^"_NewSpAmt_"^"_MtDr_"^"_$g(MtDesc)_"^"_PubBL_"^"_$g(PubDesc)_"^"_BUomId_"^"_ConFac
        s Data5=CheckPort_"^"_CheckRepNo_"^"_CheckRepDate_"^"_AdmNo_"^"_AdmExpdate_"^"_CheckPack_"^"_Spec_"^"_InfoRemark
        s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5
        s count = count+1   
	 	i +sortNum=0 s index="1" 
	 	e  d
	 	.s index=$p(Data,"^",sortNum)
	 	.i sortAsNum="Y" s index=+index
	 	.i index="" s index="ZZZZZZ"
		s QueryDATA(index,count)=Data	
    }
    q:'$d(QueryDATA) ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s endRow = Start+Limit 	// 结束行
	s startRow=Start+1  	// 开始行
    s dirOrder=1
    i $zcvt(Dir,"U")="DESC" s dirOrder=-1
	s sortIndex="",countRecords=0
	f  s sortIndex=$o(QueryDATA(sortIndex),dirOrder) q:sortIndex=""  d
	.s indexCnt=""
	.f  s indexCnt=$o(QueryDATA(sortIndex,indexCnt),dirOrder) q:indexCnt=""  d
	..s tmpData=QueryDATA(sortIndex,indexCnt)
	..s countRecords = countRecords+1
	..q:countRecords<startRow
	..q:countRecords>endRow
	..i countRecords=startRow d
	...w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(count)
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(tmpData,Title)
	...w retstring
	..e  d
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(tmpData,Title)
	...w ","_retstring
	w "]}"
	k QueryDATA
	q ""
}

/// Descript:   根据入库单RowId取得入库单明细信息
/// 			用于 不分页 时数据显示
/// Creater:wangjiabin
/// CreateDate:2013-06-28
/// Input:开始行,一页显示记录数,排序字段,排序方向,入库主表id
/// Output:     
/// Return：入库子表id^批号^入库单位Id^入库单位^效期^批次id^订单子表id^加成^入库数量^备注^库存项id^库存项代码
/// ^库存项名称^发票金额^发票号^付款单号^厂商Id^厂商^进价^进价金额^售价^售价金额^发票日期^批次进价
/// ^质检单号^随行单号^摘要^入库售价^入库售价金额^定价类型id^定价类型^招标轮次id^招标轮次^基本单位Id^包装单位和基本单位转换率"
/// ^检测口岸^检测报告^报告日期^注册证号^注册证有效期^包装合格
/// w ##class(web.DHCST.DHCINGdRecItm).QueryIngrDetail(0,30,"","",186)
ClassMethod QueryIngrDetail(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, Parref As %String) As %String
{
    n (Parref,Start,Limit,Sort,Dir)
    q:Parref="" "" 
    s loc = $P(^DHCINGR(Parref), "^", 13)
    s hospId = $P(^CTLOC(loc), "^", 22)
    s result = ##class(%Library.ResultSet).%New()
    s StrSql = "SELECT INGRI_Rowid as Rowid, INGRI_BatchNo, INGRI_CTUOM_DR, INGRI_ExpDate,"
            _"INGRI_INCLB_DR, INGRI_INPOI_DR, INGRI_Margin, INGRI_RecQty,INGRI_Remarks, "
            _"initm_INCI_DR,initm_INCI_DR->INCI_Code as IncCode,initm_INCI_DR->INCI_Desc as IncDesc,"
            _"initm_invmoney, initm_invno, initm_payno, initm_phmnf_dr,initm_phmnf_dr->PHMNF_Name as Manf,"
            _"initm_realprice,initm_realtotal,initm_saleprice, initm_SpAmt, initm_invdate, initm_BatPrice,"
            _"initm_QualityNo,initm_sxno,initm_Remark,initm_newSp,initm_newSpAmt,initm_MT_Dr,initm_PubBL, "
            _"initm_CheckPort,initm_CheckRepNo,initm_CheckRepDate,initm_AdmNo,initm_AdmExpdate,initm_CheckPack,INGRI_ChildSub, "
            _"INITM_Orig_DR,INITM_Orig_DR->Orig_Name as OriginDesc "
            _"FROM DHC_INGdRecItm WHERE INGRI_INGR_ParRef= "_Parref
    s OrderField="INGRI_ChildSub"
    s:Sort="IncCode" OrderField="IncCode"
    s:Sort="IncDesc" OrderField="IncDesc"
    s:Sort="Manf" OrderField="Manf"
    s:Sort="Qty" OrderField="INGRI_RecQty"
    s:Sort="Rp" OrderField="initm_realprice"
    s:Sort="Sp" OrderField="initm_saleprice"
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="ASC"
    i OrderField'=""  d
    .s StrSql=StrSql_" order by "_OrderField_" "_Dir
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(StrSql)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    If err  q ""
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s Title1="Ingri^BatchNo^IngrUomId^IngrUom^ExpDate^Inclb^Inpoi^Margin^RecQty^Remarks^IncId^IncCode"
    s Title2="IncDesc^InvMoney^InvNo^PayNo^ManfId^Manf^Rp^RpAmt^Sp^SpAmt^InvDate^BatRp"
    s Title3="QualityNo^SxNo^Remark^NewSp^NewSpAmt^MtDr^MtDesc^PubBL^PubDesc^BUomId^ConFacPur"
    s Title4="CheckPort^CheckRepNo^CheckRepDate^AdmNo^AdmExpdate^CheckPack^Spec^Marginnow^InfoRemark"
    s Title5="OriginId^OriginDesc^FreeDrugFlag^InsuCode^InsuDesc"
    s Title=Title1_"^"_Title2_"^"_Title3_"^"_Title4_"^"_Title5
    While(result.Next())
    {
        s Ingri = result.Data("Rowid")
        s BatchNo = result.Data("INGRI_BatchNo")  
        s IngrUomId = result.Data("INGRI_CTUOM_DR")
        s IngrUom=""
        s:IngrUomId'="" IngrUom=$p(^CT("UOM",IngrUomId),"^",2)
        s ExpDate=result.Data("INGRI_ExpDate")
        i ExpDate'="" s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
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
        i InvDate'="" s InvDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(InvDate,"ST")
        s BatRp = result.Data("initm_BatPrice")
        s QualityNo = result.Data("initm_QualityNo")
        s SxNo = result.Data("initm_sxno")
        s Remark = result.Data("initm_Remark")     ;摘要
        s NewSp = result.Data("initm_newSp")
        s NewSpAmt = result.Data("initm_newSpAmt")
        s MtDesc=""
        s MtDr = result.Data("initm_MT_Dr")      ;定价类型
        s:MtDr'="" MtDesc=$p($g(^DHCINMT(MtDr)),"^",2)
        s Info=$o(^DHCITMINFO(0,"INCI",IncId,0))
        s PubBL=$p(^DHCITMINFO(Info),"^",23) 
        //s PubBL = result.Data("initm_PubBL")            ;招标轮次
        s CheckPort=result.Data("initm_CheckPort")      ;检测口岸
        s CheckRepNo=result.Data("initm_CheckRepNo")    ;检测报告
        s CheckRepDate=result.Data("initm_CheckRepDate")    ;报告日期
        s:CheckRepDate'="" CheckRepDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(CheckRepDate,"ST")
        s AdmNo=result.Data("initm_AdmNo")                  ;注册证号
        s AdmExpdate=result.Data("initm_AdmExpdate")        ;注册证有效期
        s:AdmExpdate'="" AdmExpdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AdmExpdate,"ST")
        s CheckPack=result.Data("initm_CheckPack")          ;包装合格
        i PubBL'="" s PubDesc=$p($g(^DHCPBLIST(PubBL)),"^",2)
        e  s PubDesc=""
        s BUomId=$p(^INCI(IncId,1),"^",10)
        s PurUomId=$p(^INCI(IncId,3),"^",6)
        s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
        s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",IncId) 
        s Marginnow=""
        i +Rp'=0 s Marginnow= Sp/Rp
        s Marginnow=$fn(Marginnow,"",3) 
        s Info=$o(^DHCITMINFO(0,"INCI",IncId,0))
        s InfoRemark=""
        i Info'="" s InfoRemark=$p(^DHCITMINFO(Info),"^",10)
        s OriginId=result.Data("INITM_Orig_DR") 
        s OriginDesc=result.Data("OriginDesc") 
		s arcimDr=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(IncId)
		s freeDrugFlag=##class(web.DHCST.Common.DrugInfoCommon).CheckIfFreeDrug(arcimDr)
		s InsuCode = ##class(PHA.COM.Drug).GetInsuCode(IncId, hospId)
		s InsuDesc = ##class(PHA.COM.Drug).GetInsuDesc(IncId, hospId)
		
        s Data1=Ingri_"^"_BatchNo_"^"_IngrUomId_"^"_$g(IngrUom)_"^"_ExpDate_"^"_Inclb_"^"_Inpoi 
        s Data2=Margin_"^"_RecQty_"^"_Remarks_"^"_IncId_"^"_IncCode_"^"_IncDesc_"^"_InvMoney_"^"_InvNo 
        s Data3=PayNo_"^"_ManfId_"^"_Manf_"^"_Rp_"^"_RpAmt_"^"_Sp_"^"_SpAmt_"^"_InvDate_"^"_BatRp_"^"_QualityNo_"^"_SxNo 
        s Data4=Remark_"^"_NewSp_"^"_NewSpAmt_"^"_MtDr_"^"_$g(MtDesc)_"^"_PubBL_"^"_$g(PubDesc)_"^"_BUomId_"^"_ConFac
        s Data5=CheckPort_"^"_CheckRepNo_"^"_CheckRepDate_"^"_AdmNo_"^"_AdmExpdate_"^"_CheckPack_"^"_Spec_"^"_Marginnow_"^"_InfoRemark
        s Data6=OriginId_"^"_OriginDesc_"^"_$g(freeDrugFlag)_"^"_InsuCode_"^"_InsuDesc
        s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5_"^"_Data6
        s count = count+1   
        CONTINUE:count<(Start+1)
        CONTINUE:count>end  
		i count=1 d
		.w "{results:0,rows:["
		.w ##class(web.DHCST.Common.UtilCommon).GetJsonStr(Data,Title)
		e  d
		.w ","_##class(web.DHCST.Common.UtilCommon).GetJsonStr(Data,Title)
    }
    i count=0  w ##class(web.DHCSTEXTCOMMON).GetNoJson() q ""
    w "]}"
    q ""
}

/// Creator:zdm
/// CreatDate:2009-09-07
/// Description:更新入库子表的批次信息
/// InPut：入库子表rowid,科室库存项批次rowid
/// Table:dhc_ingdrecitm
/// OutPut:
/// Return:0,成功；
/// -1，失败
ClassMethod UpdateDhcRecItm(ingri, inclb) As %Library.String
{
    
    n (ingri,inclb)
    q:ingri="" ""
    q:inclb="" ""
    ;
    s Err=0
    &sql(update dhc_ingdrecitm set ingri_INCLB_DR=:inclb
    where ingri_Rowid=:ingri)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("UpdateDhcRecItm:dhc_ingdrecitm","dhcingri:"_ingri,SQLCODE_":"_%msg)
    .s Err=-1  ;更新失败
    q Err
}

/// Descript:   保存/更新入库验收信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-07-18
/// Table:DHC_InGdRecItm
/// Input:明细id^检测口岸^检测报告^报告日期^注册证号^注册证有效期^摘要
/// Output:     
/// Return：0：成功，
/// -5:明细不能为空
/// -6:所有明细保存均失败
/// -7其它：部分明细保存不成功，提示不成功的药品
ClassMethod SaveAcceptInfo(ListData As %String) As %Library.String
{
    n (ListData)
    q:ListData="" -5
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s Len=$l(ListData,rowDelim)
    s Count=0
    s Err=""
    f i=1:1:Len  d
    .s Data=$p(ListData,rowDelim,i)
    .s Rowid=$p(Data,"^",1)
    .s Chl=$p(Rowid,"||",2)
    .;b ;11
    .s IncId=+$p(^DHCINGR(+Rowid,"GRI",Chl),"^",25)
    .;b ;12
    .q:IncId=0
    .s IncDesc=$p(^INCI(IncId,1),"^",2)
    .s Detail=$p(Data,"^",2,$l(Data,"^"))
    .;b ;11 
    .s Ret=..UpdateAcceptInfo(Rowid,Detail)
    .i Ret'=0  d
    ..s Err=Err_","_IncDesc
    .e  d
    ..s Count=Count+1
    .
    q:Count=0 -6  ;所有明细保存均失败
    q:Err'="" -7_"^"_Err  ;保存失败的药品
    q 0
}

/// Creator:zdm
/// CreatDate:2009-09-07
/// Description:更新入库子表的验收信息
/// InPut：入库子表rowid,检测口岸^检测报告^报告日期^注册证号^注册证有效期^摘要
/// Table:dhc_ingdrecitm
/// OutPut:
/// Return:0,成功；
/// -1，失败
ClassMethod UpdateAcceptInfo(Ingri As %String, Detail As %String) As %Library.String
{
    
    n (Ingri,Detail)
    q:Ingri="" ""
    q:Detail="" ""
    s CheckPort=$p(Detail,"^",1)
    s CheckReport=$p(Detail,"^",2)
    s CheckRepDate=$p(Detail,"^",3)
    s:CheckRepDate'="" CheckRepDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CheckRepDate)
    s AdmNo=$p(Detail,"^",4)
    s AdmExpDate=$p(Detail,"^",5)
    s:AdmExpDate'="" AdmExpDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(AdmExpDate)
    s Remark=$p(Detail,"^",6)
    ;
    s Err=0
    &sql(update dhc_ingdrecitm set initm_CheckPort=:CheckPort,initm_CheckRepNo=:CheckReport,
    initm_CheckRepDate=:CheckRepDate,initm_AdmNo=:AdmNo,initm_AdmExpdate=:AdmExpDate,initm_Remark=:Remark
    where ingri_Rowid=:Ingri)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("UpdateAcceptInfo:dhc_ingdrecitm","dhcingri:"_Ingri,SQLCODE_":"_%msg)
    .s Err=-1  ;更新失败
    q Err
}

/// Descript:根据订单RowId取得订单明细信息(根据订单入库用)
/// Creater:zhangdongmei
/// CreateDate:2012-07-31
/// Input:订单主表id
/// Output:     
/// Return：订单明细Id^库存项Id^库存项代码^库存项名称^订购单位Id^订购单位^订购数量^进价^产地Id^产地
/// ^售价^批号^效期^基本单位Id^转化率
/// w ##class(web.DHCST.DHCINGdRecItm).QueryPoItmForRec(0,30,"","",1917)
ClassMethod QueryPoItmForRec(Start, Limit, Sort, Dir, Parref As %String) As %String
{
    n (Start,Limit,Sort,Dir,Parref)
    s endpage=Start+Limit  //结束行
    s stpage=Start+1 //开始行
    s pid=..NewPid()
    Set $ZT="ERRORQueryPoItmForRec"
    q:Limit=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    q:Parref="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s DhcPoId=$o(^DHCINPO(0,"INPO",Parref,0))
    s PoLoc =$p(^DHCINPO(DhcPoId),"^",2)
    s result = ##class(%Library.ResultSet).%New()
    s StrSql = "SELECT IN_POItm as Rowid, INPOI_INCI_DR, INPOI_CTUOM_DR, INPOI_UnitCost,"
            _"INPOI_Pur_Qty "
            _"FROM IN_PoItm WHERE IN_PO= "_Parref
    s json = ##class(Code.JsonObj).%New()
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(StrSql)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    If err w ##class(web.DHCSTEXTCOMMON).GetNoJson()
    q:err ""
    s count = 0
    s resultString = ""
    While(result.Next())
    {
        s PoItmId = result.Data("Rowid")
        s IncId = result.Data("INPOI_INCI_DR")
        continue:IncId=""
        s PurUomId = result.Data("INPOI_CTUOM_DR")
        s:PurUomId'="" PurUom=$p(^CT("UOM",PurUomId),"^",2)
        s Rp=result.Data("INPOI_UnitCost")
        s PurQty =+ result.Data("INPOI_Pur_Qty")
        s ImpQty=+##class(web.DHCST.INPOItm).GetImpQty(PoItmId,PurUomId)
        s AvaQty=PurQty-ImpQty    ;还可以入库的数量
        continue:AvaQty<=0
        s IncCode=$p(^INCI(IncId,1),"^",1)
        s IncDesc=$p(^INCI(IncId,1),"^",2)
        s Param="^"_PoLoc_"^"
        s ItmDefaultInfo=##class(web.DHCST.DHCINGdRec).GetItmInfo(IncId,Param)
        s ManfId=$p(ItmDefaultInfo,"^",1) 
        s Manf=$p(ItmDefaultInfo,"^",2)
        s Sp=$p(ItmDefaultInfo,"^",6)
        s BatNo=$p(ItmDefaultInfo,"^",7)
        s ExpDate=$p(ItmDefaultInfo,"^",8)
        s BUomId=$p(ItmDefaultInfo,"^",11)
        s ConFac=$p(ItmDefaultInfo,"^",12)
        s arcimDr=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(IncId)
		s freeDrugFlag=##class(web.DHCST.Common.DrugInfoCommon).CheckIfFreeDrug(arcimDr)  
        s Data1=PoItmId_"^"_IncId_"^"_IncCode_"^"_IncDesc_"^"_PurUomId_"^"_$g(PurUom)_"^"_AvaQty_"^"_Rp_"^"_ManfId_"^"_Manf
        s Data2=Sp_"^"_BatNo_"^"_ExpDate_"^"_BUomId_"^"_ConFac_"^"_PurQty_"^"_ImpQty_"^"_$g(freeDrugFlag) 
        s Data=Data1_"^"_Data2
        s count = count+1  
        s index="Sort^"_PoItmId_"^"_count
        s ^TMP("web","DHCST","DHCINGdRecItm","QueryPoItmForRec",pid,index)=Data
    }
    q:count=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    q:Limit=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=count
    i endpage>maxrow s endpage=maxrow
    i Dir="DESC"  d
    .d OutRowDesc(pid,stpage,endpage,maxrow,Dir)
    e  d
    .d OutRowAsc(pid,stpage,endpage,maxrow)
    
    k ^TMP("web","DHCST","DHCINGdRecItm","QueryPoItmForRec",pid)

    q ""
    
    
OutRowAsc(pid,stpage,endpage,maxrow)
	n (pid,stpage,endpage,maxrow)
	s subflag=""
	s count=0
	f  s subflag=$o(^TMP("web","DHCST","DHCINGdRecItm","QueryPoItmForRec",pid,subflag))  q:subflag=""  d
       .s RowData=^TMP("web","DHCST","DHCINGdRecItm","QueryPoItmForRec",pid,subflag)
	.s count=count+1
	.d ..OutRowDetail(RowData,stpage,endpage,maxrow,count)
	.
	
OutRowDesc(pid,stpage,endpage,maxrow,Dir)
	n (pid,stpage,endpage,maxrow,Dir)
	q:Dir'="DESC"
	s count=0
	s subflag=""
	f  s subflag=$o(^TMP("web","DHCST","DHCINGdRecItm","QueryPoItmForRec",pid,subflag),-1)  q:subflag=""  d
       .s RowData=^TMP("web","DHCST","DHCINGdRecItm","QueryPoItmForRec",pid,subflag)
       .s count=count+1
	.d ..OutRowDetail(RowData,stpage,endpage,maxrow,count)
	.
    
ERRORQueryPoItmForRec
       //遇报错,则先kill TMP
    Set Method= "##class(web.DHCST.DHCINGdRecItm).QueryPoItmForRec"
	Set ErrorMsg=Method_"("_Start_","_Limit_","_Parref_")"_","_$ZE
	k ^TMP("web","DHCST","DHCINGdRecItm","QueryPoItmForRec",pid)
    q ""
}

ClassMethod NewPid()
{
	
	q $I(^DHCSTPID("DHCINGdRec"))
}

ClassMethod OutRowDetail(RowData, stpage, endpage, maxrow, count)
{
	n (RowData,stpage,endpage,maxrow,count)
    //s Title1="PoItmId^IncId^IncCode^IncDesc^PurUomId^PurUom^AvaQty^Rp^ManfId^Manf"
    //s Title2="Sp^BatNo^ExpDate^BUomId^ConFac^PurQty^ImpQty"
	s PoItmId=$p(RowData,"^",1)
	s IncId=$p(RowData,"^",2)
	s IncCode=$p(RowData,"^",3)
	s IncDesc=$p(RowData,"^",4)
	s PurUomId=$p(RowData,"^",5)
	s PurUom=$p(RowData,"^",6)
	s AvaQty=$p(RowData,"^",7)
	s Rp=$p(RowData,"^",8)
	s ManfId=$p(RowData,"^",9)
	s Manf=$p(RowData,"^",10)
	s Sp=$p(RowData,"^",11)
	s BatNo=$p(RowData,"^",12)
	s ExpDate=$p(RowData,"^",13)
	s BUomId=$p(RowData,"^",14)
	s ConFac=$p(RowData,"^",15)
	s PurQty=$p(RowData,"^",16)
	s ImpQty=$p(RowData,"^",17)
	s freeDrugFlag=$p(RowData,"^",18)
	q:count<stpage
	q:count>endpage
	s PoItmId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PoItmId",PoItmId)
	s IncId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("IncId",IncId)
	s IncCode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("IncCode",IncCode)
	s IncDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("IncDesc",IncDesc)
	s PurUomId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PurUomId",PurUomId)
	s PurUom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PurUom",PurUom)
	s AvaQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("AvaQty",AvaQty)
	s Rp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Rp",Rp)
	s ManfId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ManfId",ManfId)
	s Manf=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Manf",Manf)
	s Sp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Sp",Sp)
	s BatNo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("BatNo",BatNo)
	s ExpDate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ExpDate",ExpDate)
	s BUomId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("BUomId",BUomId)
	s ConFac=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ConFac",ConFac)
	s PurQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PurQty",PurQty)
	s ImpQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ImpQty",ImpQty)
	s FreeDrugFlag=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("FreeDrugFlag",freeDrugFlag)
	;
	s tmpstr=PoItmId_IncId_IncCode_IncDesc_PurUomId_PurUom_AvaQty_Rp_ManfId_Manf_Sp_BatNo_ExpDate_BUomId_ConFac_PurQty_ImpQty_FreeDrugFlag
	s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
	s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
	s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	i count=stpage w startString
	i count<endpage w firstrow
	i count=endpage w lastrow
}

/// Descript:检查本次入库明细的发票号是否存在于别的入库单
/// Creater:    ZhangDongmei
/// CreateDate: 2012-09-19
/// Table:DHC_InGdRecItm
/// Input:入库子表id,发票号
/// Output:     
/// Return：1:存在;0:不存在
ClassMethod CheckInvnoExist(Ingr As %String, Invno As %String) As %Library.String
{
    n (Ingr,Invno)
    s Flag=0
    q:Invno="" 0
    s Invno=$$ALPHAUP^SSUTIL4(Invno)
    s OldIngr=0
    f  s OldIngr=$o(^DHCINGR(0,"INVNO",Invno,OldIngr)) q:OldIngr=""  d
    .i +Ingr=0 d
    ..s Flag=1                      ;新增项目的发票号存在于其它入库单
    .e  i Ingr'=OldIngr  d
    ..s Flag=1                      ;更新项目的发票号存在于其它入库单
    .               
    q Flag
}

/// Descript:   根据入库单RowId取得入库单明细信息
/// Creater:zhangdongmei
/// CreateDate:2012-11-22
/// Input:入库主表id
/// Output:     
/// Return：入库子表id^批号^入库单位Id^入库单位^效期^批次id^订单子表id^加成^入库数量^备注^库存项id^库存项代码
/// ^库存项名称^发票金额^发票号^付款单号^厂商Id^厂商^进价^进价金额^售价^售价金额^发票日期^批次进价
/// ^质检单号^随行单号^摘要^入库售价^入库售价金额^定价类型id^定价类型^招标轮次id^招标轮次^基本单位Id^包装单位和基本单位转换率"
/// d ##class(%ResultSet).RunQuery("web.DHCST.DHCINGdRecItm","QueryDetail",308,1)
Query QueryDetail(Parref As %String, VendorIO As %String = "", IngrLocIO As %String = "", CreateUserIO As %String = "", PurUserIO As %String = "", HospDescIO As %String = "", AcceptUserIO As %String = "") As %Query(ROWSPEC = "Ingri:%String,BatchNo:%String,IngrUomId:%String,IngrUom:%String,ExpDate:%String,Inclb:%String,Inpoi:%String,Margin:%String,RecQty:%String,Remarks:%String,IncId:%String,IncCode:%String,IncDesc:%String,InvMoney:%String,InvNo:%String,PayNo:%String,ManfId:%String,Manf:%String,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,InvDate:%String,BatRp:%Float,QualityNo:%String,SxNo:%String,NewSp:%Float,NewSpAmt:%Float,MtDr:%String,MtDesc:%String,PubBL:%String,PubDesc:%String,BUomId:%String,ConFacPur:%String,Spec:%String,stkbin:%String,goodName:%String,CheckRepDate:%String,VendorIO,IngrLocIO,CreateUserIO,PurUserIO,HospDescIO,AcceptUserIO") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, Parref As %String, VendorIO As %String = "", IngrLocIO As %String = "", CreateUserIO As %String = "", PurUserIO As %String = "", HospDescIO As %String = "", AcceptUserIO As %String = "") As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s qHandle=$lb(0,repid,0)
    q:Parref="" $$$OK
    
    
    //因为润乾参数不能传汉字，改为再query中输出 VendorIO,IngrLocIO,CreateUserIO,PurUserIO
    s VendorIO=$P(^DHCINGR(Parref),"^",3)
    s VendorIO=$p(^APC("APCVM",VendorIO),"^",3)
    s:IngrLocIO'="" IngrLocIO=$p(^CTLOC(IngrLocIO),"^",2)
    s:CreateUserIO'="" CreateUserIO=$p(^SSU("SSUSR",CreateUserIO),"^",2)
    s:PurUserIO'="" PurUserIO=$p(^SSU("SSUSR",PurUserIO),"^",2)
    s:HospDescIO'="" HospDescIO=$P(^CT("HOSP",HospDescIO),"^",2)
    s:AcceptUserIO'="" AcceptUserIO=$p(^SSU("SSUSR",AcceptUserIO),"^",2)
    
    s result = ##class(%Library.ResultSet).%New()
    s StrSql = "SELECT INGRI_Rowid as Rowid, INGRI_BatchNo, INGRI_CTUOM_DR, INGRI_ExpDate,"
            _"INGRI_INCLB_DR, INGRI_INPOI_DR, INGRI_Margin, INGRI_RecQty,INGRI_Remarks,INGRI_CTLOC_DR, "
            _"initm_INCI_DR,initm_INCI_DR->INCI_Code as IncCode,initm_INCI_DR->INCI_Desc as IncDesc,"
            _"initm_invmoney, initm_invno, initm_payno, initm_phmnf_dr,initm_phmnf_dr->PHMNF_Name as Manf,"
            _"initm_realprice,initm_realtotal,initm_saleprice, initm_SpAmt, initm_invdate, initm_BatPrice,"
            _"initm_QualityNo,initm_sxno,initm_Remark,initm_newSp,initm_newSpAmt,initm_MT_Dr,initm_PubBL, "
            _"initm_CheckPort,initm_CheckRepNo,initm_CheckRepDate,initm_AdmNo,initm_AdmExpdate,initm_CheckPack "
            _"FROM DHC_INGdRecItm WHERE INGRI_INGR_ParRef= "_Parref
    ;
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(StrSql)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    ;b ;1
    If err  q $$$OK
    s count = 0
    
    While(result.Next())
    {
        s Ingri = result.Data("Rowid")
        s BatchNo = result.Data("INGRI_BatchNo") //批号
        s IngrUomId = result.Data("INGRI_CTUOM_DR")
        s:IngrUomId'="" IngrUom=$p(^CT("UOM",IngrUomId),"^",2)
        s ExpDate=result.Data("INGRI_ExpDate")
        i ExpDate["-" s ExpDate=$zdh(ExpDate,3)
        i ExpDate'=""  s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
        s Inclb=result.Data("INGRI_INCLB_DR")
        s Inpoi=result.Data("INGRI_INPOI_DR")
        s Margin = result.Data("INGRI_Margin")
        s RecQty = result.Data("INGRI_RecQty")
        s Remarks = result.Data("INGRI_Remarks")
        s IncId = result.Data("initm_INCI_DR")
        s IncCode = result.Data("IncCode")
        s IncDesc = result.Data("IncDesc")
        //s:$f(IncDesc,"-") IncDesc=$p(IncDesc,"-",2)
        s InvMoney = result.Data("initm_invmoney")
        s InvNo = result.Data("initm_invno")   //发票号
        s PayNo = result.Data("initm_payno")
        s ManfId = result.Data("initm_phmnf_dr")
        s Manf = result.Data("Manf")
        s:$f(Manf,"-") Manf=$p(Manf,"-",2)
        s Rp = result.Data("initm_realprice")
        s RpAmt = result.Data("initm_realtotal")
        s Sp = result.Data("initm_saleprice")
        s SpAmt = result.Data("initm_SpAmt")
        s InvDate = result.Data("initm_invdate")
        i InvDate["-" s InvDate=$zdh(InvDate,3)
        s:+InvDate'=0 InvDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(InvDate,"ST")
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
		i CheckRepDate'="" s CheckRepDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(CheckRepDate,"ST")
        s AdmNo=result.Data("initm_AdmNo")                  ;注册证号
        s AdmExpdate=result.Data("initm_AdmExpdate")        ;注册证有效期
        i AdmExpdate["-" s AdmExpdate=$zdh(AdmExpdate,3)
        i AdmExpdate'="" s AdmExpdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AdmExpdate,"ST")
        s CheckPack=result.Data("initm_CheckPack")          ;包装合格
        s:PubBL'="" PubDesc=$p(^DHCPBLIST(PubBL),"^",2)
        s BUomId=$p(^INCI(IncId,1),"^",10)
        s PurUomId=$p(^INCI(IncId,3),"^",6)
        s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
        s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",IncId)
        ;
        //20130623添加
        s ctloc=result.Data("INGRI_CTLOC_DR")
        s stkbin=##class(web.DHCST.Common.DrugStkCommon).GetStkBin(ctloc,IncId)
        s stkbin=$p(stkbin,"^",1)                      ;库位码
        s goodName=##class(web.DHCST.Common.DrugInfoCommon).GetGoodName(IncId)	;商品名
        
        d OutPutRow
 } 

 Quit $$$OK

OutPutRow
 s Data=$lb(Ingri,BatchNo,IngrUomId,IngrUom,ExpDate,Inclb,Inpoi,Margin,RecQty,Remarks,IncId,IncCode,IncDesc,InvMoney,InvNo,PayNo,ManfId,Manf,Rp,RpAmt,Sp,SpAmt,InvDate,BatRp,QualityNo,SxNo,NewSp,NewSpAmt,MtDr,$g(MtDesc),PubBL,$g(PubDesc),BUomId,ConFac,Spec,stkbin,goodName,CheckRepDate,VendorIO,IngrLocIO,CreateUserIO,PurUserIO,HospDescIO,AcceptUserIO)
 //w Data,!   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod QueryDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDetailExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
    }
    Else {          
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Descrition:js中获取hrefstr = window.location.href;时汉字会显示为乱码，暂时通过后台取科室描述和药品描述
/// Creator:yangsj
/// CreateDate:2020-03-13
/// Input:loc^inci
/// Output:locDesc^inciDesc
/// Other:
/// w ##class(web.DHCST.DHCINGdRecItm)GetDescByLocAndInci()
ClassMethod GetDescByLocAndInci(Str)
{
	s locDesc="",inciDesc=""
	s loc=$P(Str,"^",1)
	s inci=$P(Str,"^",2)
	s:loc'="" locDesc=$P(^CTLOC(loc),"^",2)
	s:inci'="" inciDesc=$P(^INCI(inci,1),"^",2)
	q locDesc_"^"_inciDesc
}

}
