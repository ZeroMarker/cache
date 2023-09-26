Import sqluser

Class web.DHCST.ManuOrder Extends (%RegisteredObject, %XML.Adaptor, StkTypeG, PHA.COM.Base)
{

Parameter AppName [ Final ] = "DHCSTMANUORDER";

/// w ##class(web.DHCST.ManuOrder).GetParam("248",24,4)
ClassMethod GetParam(GroupId, LocId, UserId)
{
	s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=##class(web.DHCST.ManuOrder).%GetParameter("AppName")
    s AddCostType=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"AddCostType",Param)
    s DefaultRp=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"DefaultRp",Param)
    q AddCostType_"^"_DefaultRp
}

/// 	Creator		zzd
/// 	CreatDate	2018.9.28
/// 	Description	制剂建单获取附加费用
/// 	Input		制剂id，理论数量，单位id，科室id
/// 				w ##class(web.DHCST.ManuOrder).GetAddCost("1698||1",1,2,24)
ClassMethod GetAddCost(InRec, TheoryQty, Uomid, LocId)
{
	q:+LocId=0 ""
	q:+Uomid=0 ""
	q:+TheoryQty=0 ""
	s Inci=+InRec
	q:Inci=0 ""
	s $zt="ErrorGetAddCost"
	s ManuQty=TheoryQty
	s Hosp=$p(^CTLOC(LocId),"^",22)
	s chl=$p(InRec,"||",2)
	s UomDr=$p(^INCI(Inci,"REC",chl),"^",1)
	s Qty=$p(^INCI(Inci,"REC",chl),"^",2)
	s Rp=##class(web.DHCSTPRICE).GetRp(Inci,+$h,UomDr,Hosp,"")
	s RpAmt=Rp*Qty    //成品制剂金额
	
	s totalRpAmt=0
	s ing=0
	f  s ing=$o(^INCI(Inci,"REC",chl,"ING",ing)) q:ing=""  d
	.s data=^INCI(Inci,"REC",chl,"ING",ing)
	.s InRin=Inci_"||"_chl_"||"_ing
	.s InRinInci=$p(data,"^",1)    //库存
	.s Incidesc=$P($g(^INCI(InRinInci,1)),"^",2)
	.s Incicode=$P($g(^INCI(InRinInci,1)),"^",1)
	.s InRinUomdr=$p(data,"^",3)    
	.s InRinQty=$p(data,"^",2)      //数量
	.s InRinRp=##class(web.DHCSTPRICE).GetRp(InRinInci,+$h,InRinUomdr,Hosp,"")
	.s InRinRpAmt=InRinRp*InRinQty
	.s totalRpAmt=totalRpAmt+InRinRpAmt
	s diffRpAmt=RpAmt-totalRpAmt
	q:diffRpAmt<0 "" 
	
	s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(LocId)
    s CustID=$p(CustStr,"^",1)
    S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+Inci)
	S StkTypeDesc=$P(CatGrpStr,"^",4)
    S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
    
	s addCost=0
	i Uomid=UomDr d
	.s addCost=diffRpAmt*ManuQty/Qty
	e  d
	.s Buom=$p(^INCI(Inci,1),"^",10)
	.s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(Uomid,BUOM)
	.s fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(UomDr,BUOM)
	.s ManuQty=ManuQty*fac/(Qty*fac2)
	.s addCost=diffRpAm*ManuQty
	s addCost=##Class(web.DHCSTCOMMPARA).GetNumbFN(addCost,Perv,"FmtRA",1)
	q addCost

ErrorGetAddCost
	
	s errMsgInfo="##class(web.DHCST.ManuOrder).GetAddCost("_$lts($lb(InRec,TheoryQty,Uomid,LocId))_")"
	d ErrorRecord^DHCSTERROR("ManuOrder",errMsgInfo,$ze)	
	q ""
}

/// w ##class(web.DHCST.ManuOrder).GetRecItmList(0,20,"")
ClassMethod GetRecItmList(Start As %Integer, Limit As %Integer, RecItmDesc As %String)
{
	s result = ##class(%Library.ResultSet).%New()
    i RecItmDesc="" d 
    .s sqlStr="select INREC_RowId AS RowId,INREC_Desc As Descption from INC_ItmRcp"
    .s sqlStr=sqlStr_" where inrec_parref->inci_incsc_dr in" 
    .s sqlStr=sqlStr_" (select scgr_stkcat_dr from dhc_stkcatgrprelations"
    .s sqlStr=sqlStr_" where scgr_scg_parref->scg_type='G')"
    e  d
    .s RecItmDesc=$$ALPHAUP^SSUTIL4(RecItmDesc)
    .s sqlStr="select INREC_RowId AS RowId,INREC_Desc As Descption from SQLUSer.INC_ItmRcp" 
    .s sqlStr=sqlStr_" where inrec_parref in (select distinct(inca_inci_dr) AS RowId from inc_alias" 
    .s sqlStr=sqlStr_" Where %ALPHAUP(inca_text) %STARTSWITH  "_"'"_RecItmDesc_"'"
    .s sqlStr=sqlStr_" and inca_inci_dr->inci_incsc_dr in"
    .s sqlStr=sqlStr_" (select scgr_stkcat_dr from dhc_stkcatgrprelations "
    .s sqlStr=sqlStr_" where scgr_scg_parref->scg_type='G')) "
    
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s Description = ##class(web.DHCST.IncItmRcp).GetIncRcpDesc(Rowid)
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
}

/// Creator		zzd
/// CreatDate	2018-06-18  (端午节唉~~)
/// Description	存储制剂单据
/// Input		制剂主表id，主表信息
/// Other		w ##class(web.DHCST.ManuOrder).SaveManuOrder("","2018-07-22^427^2003||1^akdfl^2021-07-06^1^100^90^10^1^632^")
ClassMethod SaveManuOrder(InManu, MainData)
{
	s IncRec=$p(MainData,"^",3)
	s CompFlag=""
	i InManu'="" s CompFlag=$p(^DHCINMAN(InManu),"^",26)
	q:(CompFlag="Y") "-1"_"^"_..Get("单据已经完成！")
	
	s Ret=0
	tstart
	i InManu=""  d
	.s InManu=..InsertInManuOrder(MainData)     ;保存
	e  d
	.s InManu=..UpdInManuOrder(InManu,MainData)     ;保存
	
	i +InManu<=0 trollback
	q:+InManu<=0 InManu
	s InManu=+InManu
	i IncRec'=""  d
    .s Ret=##class(web.DHCST.ManuOrder).InsManuOrderBat(InManu,IncRec)
    i +Ret<0 trollback
    q:+Ret<0 Ret
    tcommit    ;只要有入库单明细
    q InManu
}

/// Creator		zzd
/// CreatDate	2018-06-18  (端午节唉~~)
/// Description	插入制剂主表
/// Input		
ClassMethod InsertInManuOrder(MainData)
{
	s ManuDate=$p(MainData,"^",1)
	s LocId=$p(MainData,"^",2)
	s Inrec=$p(MainData,"^",3)
	s Inci=+Inrec
	s BatNo=$p(MainData,"^",4)
	s ExpDate=$p(MainData,"^",5)
	s Uomdr=$p(MainData,"^",6)
	s TheoryQty=$p(MainData,"^",7)
	s FactQty=$p(MainData,"^",8)
	s AddCost=$p(MainData,"^",9)           //附加费用
	s ManuUser=$p(MainData,"^",10)
	s OperUser=$p(MainData,"^",11)
	s Status="10"
	s remarks=$p(MainData,"^",12)    ;remarks
 	s InRec=$p(MainData,"^",3)   ;inrec_rowid
	s ManuStartDate=$p(MainData,"^",14)		//制剂开始制作日期
	s Rp=$p(MainData,"^",15)
	s Sp=$p(MainData,"^",16)		
	
	s NotUse=$p(^INCI(Inci,2),"^",9)
	q:NotUse="Y" -1_"^"_..Get("制剂已经不可用")

	i ManuDate'="" s ManuDate= ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ManuDate)
	e  s ManuDate=+$h
	i ExpDate'="" s ExpDate= ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ExpDate)
	i ManuStartDate'="" s ManuStartDate= ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ManuStartDate)
	q:(ManuStartDate'="")&&(ManuStartDate>ManuDate) -1_"^"_..Get("生产日期需小于制剂日期")
	q:ManuDate>=ExpDate -1_"^"_..Get("有效期不能小于等于制剂日期")
	
	s ManuEndDate=ManuDate				//制剂结束制作日期 默认制剂日期
	i ManuStartDate="" s ManuStartDate=ManuEndDate		//制剂开始制作日期为空，默认当天开始

	
	s inccat=$p(^INCI(Inci,2),"^",2)
	s scg=$o(^DHCSCG("STKCAT",inccat,""))
	q:scg="" -1_"^"_..Get("库存项无类组")
	s StkGrpId=scg
	s StkType=..sssCode()
	s AppName=##class(web.DHCST.ManuOrder).%GetParameter("AppName")
    ;生成单号需加锁
    s ret=##class(web.DHCST.Common.AppCommon).Lock("ManuOrderNo")  
    q:ret'=0 -99_"^"_..Get("加锁失败")
    ;
    s ManuOrdNo=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,StkGrpId,LocId)
    i ManuOrdNo="" d ##class(web.DHCST.Common.AppCommon).UnLock("ManOrderNo")
    q:ManuOrdNo="" -2_"^"_..Get("生成单号失败")
    
    
    s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(LocId)
    s CustID=$p(CustStr,"^",1)
    S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+Inci)
	S StkTypeDesc=$P(CatGrpStr,"^",4)
    S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
    
    s bUom=$p(^INCI(Inci,1),"^",10)
	s pUom=$p(^INCI(Inci,3),"^",6)
	i bUom=Uomdr  d
	.s Rp=##Class(web.DHCSTCOMMPARA).GetNumbDec(Rp,Perv,"FmtRP",2)
	.s Sp=##Class(web.DHCSTCOMMPARA).GetNumbDec(Sp,Perv,"FmtSP",2)
	e  d
	.s Rp=##Class(web.DHCSTCOMMPARA).GetNumbDec(Rp,Perv,"FmtRP",1)
	.s Sp=##Class(web.DHCSTCOMMPARA).GetNumbDec(Sp,Perv,"FmtSP",1)
	s SpAmt=Sp*FactQty
    s SpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(SpAmt,Perv,"FmtSA",1)
    s RpAmt=Rp*FactQty
    s RpAmtRpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(RpAmt,Perv,"FmtRA",1)
    
     s Err=0
    &sql(insert into SQLUser.DHC_InManuOrder(INMAN_No,INMAN_Date,INMAN_Ctloc_Dr,
         INMAN_Inci_Dr,INMAN_Batch_No,INMAN_Expire_Date,INMAN_Uom_Dr,INMAN_Theory_Qty,
         INMAN_Fact_Qty,INMAN_ElseAmount1,INMAN_ManuUser_Dr,INMAN_OperUser_Dr,INMAN_CompStatus,
         INMAN_Remarks,INMAN_InRec_Dr,INMAN_Start_Date,INMAN_End_Date,INMAN_CostPrice,INMAN_CostAmount,
         INMAN_Sp,INMAN_SpAmt) 
         values (:ManuOrdNo,:ManuDate,:LocId,:Inci,:BatNo,:ExpDate,:Uomdr,:TheoryQty,:FactQty,:AddCost,
         :ManuUser,:OperUser,:Status,:remarks,:InRec,:ManuStartDate,:ManuEndDate,:Rp,:RpAmt,
         :Sp,:SpAmt))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_InManuOrder",ManuOrdNo,SQLCODE_":"_%msg)
    .s Err=-3
    d ##class(web.DHCST.Common.AppCommon).UnLock("ManuOrderNo")
    q:Err'=0 -3_"^"_..Get("保存制剂单失败")_","_Err
    ;
    q $p($g(%ROWID),$c(1))
}

/// Creator		zzd
/// CreatDate	2018-06-18  (端午节唉~~)
/// Description	插入制剂主表
/// Input
/// 	Other		w ##class(web.DHCST.ManuOrder).UpdInManuOrder("1","2018-07-22^427^2003||1^akdfl^2021-07-06^^100^90^12^^632^")
ClassMethod UpdInManuOrder(InManu, MainData)
{
	q:+InManu=0 "-1^"_..Get("单据不存在")
	s ManuDate=$p(MainData,"^",1)
	s LocId=$p(MainData,"^",2)
	s Inrec=$p(MainData,"^",3)
	s Inci=+Inrec
	s BatNo=$p(MainData,"^",4)
	s ExpDate=$p(MainData,"^",5)
	s Uomdr=$p(MainData,"^",6)
	s TheoryQty=$p(MainData,"^",7)
	s FactQty=$p(MainData,"^",8)
	s AddCost=$p(MainData,"^",9)           //附加费用
	s ManuUser=$p(MainData,"^",10)
	s OperUser=$p(MainData,"^",11)
	s Status="10"
	s remarks=$p(MainData,"^",12)    ;remarks
 	s InRec=$p(MainData,"^",3)   ;inrec_rowid
	s ManuNo=$p(^DHCINMAN(InManu),"^",1)
	s ManuStartDate=$p(MainData,"^",14)		//制剂开始制作日期
	s Rp=$p(MainData,"^",15)
	s Sp=$p(MainData,"^",16)		
	
	s NotUse=$p(^INCI(Inci,2),"^",9)
	q:NotUse="Y" -1_"^"_..Get("制剂已经不可用")
	
	i ManuDate'="" s ManuDate= ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ManuDate)
	e  s ManuDate=+$h
	i ExpDate'="" s ExpDate= ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ExpDate)
	i ManuStartDate'="" s ManuStartDate= ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ManuStartDate)
	
	s ManuEndDate=ManuDate				//制剂结束制作日期 默认制剂日期
	i ManuStartDate="" s ManuStartDate=ManuEndDate		//制剂开始制作日期为空，默认当天开始

	s SpAmt=Sp*FactQty
    s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(LocId)
    s CustID=$p(CustStr,"^",1)
    S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+Inci)
	S StkTypeDesc=$P(CatGrpStr,"^",4)
    S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
    s SpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(SpAmt,Perv,"FmtSA",1)
    s RpAmt=Rp*FactQty
    s RpAmtRpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(RpAmt,Perv,"FmtRA",1)

	s Err=0
    &sql(UPDATE SQLUser.DHC_InManuOrder SET INMAN_InRec_Dr=:Inrec
    	, INMAN_Date = :ManuDate
		, INMAN_Ctloc_Dr =:LocId
		, INMAN_Inci_Dr = :Inci
		, INMAN_Batch_No = :BatNo
		, INMAN_Expire_Date = :ExpDate
		, INMAN_Uom_Dr = :Uomdr
		, INMAN_Theory_Qty = :TheoryQty
		, INMAN_Fact_Qty = :FactQty
		, INMAN_ElseAmount1 = :AddCost
		, INMAN_ManuUser_Dr = :ManuUser
		, INMAN_Remarks =:remarks
		, INMAN_Start_Date=:ManuStartDate
		, INMAN_End_Date=:ManuEndDate 
		, INMAN_CostPrice=:Rp
		, INMAN_CostAmount=:RpAmt
		, INMAN_Sp=:Sp
		, INMAN_SpAmt=:SpAmt
		WHERE INMAN_RowID = :InManu) 
	
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_InManuOrder",ManuNo,SQLCODE_":"_%msg)
    .s Err=-3
    d ##class(web.DHCST.Common.AppCommon).UnLock("ManuOrderNo")
    q:Err'=0 -3_"^"_..Get("更新制剂单失败")
    ;
    q $p($g(%ROWID),$c(1))
}

ClassMethod InsManuOrderBat(InManu, InRec)
{
	q:InManu="" -1_"^"_..Get("制剂单不存在")
	q:InRec="" -2_"^"_..Get("制剂不存在")
	q:($d(^DHCINMAN(InManu))=0)!($d(^DHCINMAN(InManu))=10) -3_"^"_..Get("制剂单不存在")
	s Err=""
	i $d(^DHCINMAN(InManu,"BAT")) d
	.s ManuNo=$p(^DHCINMAN(InManu),"^",1)
	.&sql(delete from SQLUser.DHC_InManuOrder_Batch where MOBAT_ParRef=:InManu)
	.i SQLCODE'=0  d
	. .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_InManuOrder_Batch",ManuNo,SQLCODE_":"_%msg)
	. .s Err=-4
	q:Err'="" -4_"^"_..Get("更新制剂单明细失败")
	s Inci=$p(InRec,"||",1) q:Inci="" -5
	s RecSub=$p(InRec,"||",2) q:RecSub="" -6
	s TheoryQty=+$p(^DHCINMAN(InManu),"^",9) //制剂的理论数量
	s LocDr=$p(^DHCINMAN(InManu),"^",3)      //制剂科室
	s HospId=$p(^CTLOC(LocDr),"^",22)
	s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(LocDr)
	s CustID=$p(CustStr,"^",1)
	S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+Inci)
	S StkTypeDesc=$P(CatGrpStr,"^",4)
	S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"


	s buom=$p(^INCI(Inci,1),"^",10)
	s InRecUom=$p(^DHCINMAN(InManu),"^",8)
	s InRcpUom=$p(^INCI(Inci,"REC",RecSub),"^",1)
	s InRcpQty=$p(^INCI(Inci,"REC",RecSub),"^",2)
	s (confac1,confac)=1
	i InRecUom'=InRcpUom d               //转换成对应单位的数量
	.s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(InRcpUom,buom)
	.s confac1=##class(web.DHCST.Common.UtilCommon).UOMFac(InRecUom,buom)
	s TheoryQty=(TheoryQty*confac1)/ (InRcpQty*confac)          

	s batnum=0
	
	s rinsub=0
	f  s rinsub=$o(^INCI(Inci,"REC",RecSub,"ING",rinsub)) q:(rinsub="")||(Err'="")  d
	. s tmpstr=^INCI(Inci,"REC",RecSub,"ING",rinsub)
	. s rininci=$p(tmpstr,"^",1)
	. s rinqty=$p(tmpstr,"^",2)
	. s rinuom=$p(tmpstr,"^",3)
	. s rincicode=$p(^INCI(rininci,1),"^",1)
	. s rincidesc=$p(^INCI(rininci,1),"^",2)
	. s buom=$p(^INCI(rininci,1),"^",10)
	. s tmpTheoQty=0
	. i $d(^INCI(Inci,"REC",RecSub,"ING",rinsub,"REM")) D
	. . s id=$o(^INCI(Inci,"REC",RecSub,"ING",rinsub,"REM",""),-1)
	. . s remarks=^INCI(Inci,"REC",RecSub,"ING",rinsub,"REM",id)
	. . i remarks="M" d
	. . .s tmpTheoQty=+$p(^DHCINMAN(InManu),"^",10)  ;如果是原附材料,则按实际用量扣库存 
	. . .s tmpTheoQty=(tmpTheoQty*confac1)/ (InRcpQty*confac)           
	. s mobuom=rinuom
	. i tmpTheoQty=0 s mobqty=rinqty*TheoryQty    
	. e  s mobqty=rinqty*tmpTheoQty     
	. s mobfac=##class(web.DHCST.Common.UtilCommon).UOMFac(rinuom,buom)
	. s mobbqty=mobqty*mobfac       //理论数量(基本单位)
	. s il=$o(^INCI("IL_LOC",LocDr,rininci,""))
	. s incil=rininci_"||"_il
	. s pid=..GetInclbCounter(LocDr,LocDr)		//加锁 同时 获取pid
	. s cnt=##CLASS(web.DHCSTSTKQTY).GetInclbQty(rininci,mobbqty,LocDr,pid)
	. i cnt<=0 d
	. . s Err=-7_"^"_rininci_","_rincicode_","_rincidesc_","_..Get("库存不足")
	. . d UnLock
	. q:cnt<=0
	. s tmpqty=0
	. s newclb=""
	. f  s newclb=$o(^TMPGETINCLB(pid,newclb)) q:(newclb="")!(Err'="")  d
	. .s Inclb=$p(^TMPGETINCLB(pid,newclb),"^",2)
	. .s qty=$p(^TMPGETINCLB(pid,newclb),"^",1)
	. .s mobsp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inclb,+$h,buom,HospId,"G","")
	. .s mobrp=##class(web.DHCSTPRICE).GetRp(Inclb,+$h,buom,HospId,"")
	. .s spamt=mobsp*qty
	. .s rpamt=mobrp*qty
	. .s spamt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(spamt,HospId)
	. .s rpamt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(rpamt,HospId)
	. .s inmanubat=$o(^DHCINMAN(InManu,"BAT",""),-1)+1
	. .&sql(insert into SQLUser.DHC_InManuOrder_Batch(MOBAT_ParRef,MOBAT_Childsub,MOBAT_Inclb_Dr,MOBAT_CtUom_Dr,
		MOBAT_Qty,MOBAT_Sp,MOBAT_SpAmount,MOBAT_BuomQty,MOBAT_Rp,MOBAT_RpAmount) 
		values (:InManu,:inmanubat,:Inclb,:buom,:qty,:mobsp,:spamt,:qty,:mobrp,:rpamt))
	. .i SQLCODE'=0  d
	. . .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_InManuOrder_Batch",rincidesc,SQLCODE_":"_%msg)
	. . .s Err=-8
	. .e  d
	. . .s batnum=batnum+1
	. d UnLock
	i (batnum=0)&(Err="") s Err=-9_"^"_..Get("更新制剂单明细失败")
	q:Err'="" Err_"^"_..Get("更新制剂单明细失败")    ;
	;
	q $p($g(%ROWID),$c(1))
	
UnLock
	l -^DHCINCIL(LocDr,rininci)
    k ^TMPGETINCLB(pid)
	q
}

ClassMethod GetInclbCounter(recloc, inci) As %String
{
	 l +^DHCINCIL(recloc,inci):10  e  q -1   ;加锁
     s pid=##Class(web.DHCSTCOMMO).NewPidOEInclb()
     q pid
}

/// w ##class(web.DHCST.ManuOrder).DateChange(0)
ClassMethod DateChange(t = "")
{
	s t=+t
	s curdate=+$h
	s date=curdate+t
	s date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date,"ST")
	q date
}

/// w ##class(web.DHCST.ManuOrder).DateChangeFormat(0)
ClassMethod DateChangeFormat(t = "")
{
	s t=+t
	s curdate=+$h
	s date=curdate+t
	s date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date,"ST")
	q date
}

ClassMethod DelManuOrder(InManu)
{
	s Status=$p(^DHCINMAN(InManu),"^",27)
	q:Status="21" "-1"_"^"_..Get("已经审核")
	&sql(delete from SQLUser.DHC_InManuOrder where INMAN_RowID=:InManu)
	q SQLCODE
}

/// Creator		zzd
/// CreatDate	2018-07-22
/// Description	获取制剂单  的主信息
/// Input		制剂单id
/// Output
/// Other		w ##class(web.DHCST.ManuOrder).GetInManOrdMInfo(1)
ClassMethod GetInManOrdMInfo(InManu)
{
	s ManuNo=$p(^DHCINMAN(InManu),"^",1)
	s ManuDate=$p(^DHCINMAN(InManu),"^",2)
	i ManuDate'="" s ManuDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ManuDate,"ST")
	s LocDr=$p(^DHCINMAN(InManu),"^",3)
	s LocDesc=##class(PHA.COM.Data.Base).LocDesc(LocDr) 
	s Inci=$p(^DHCINMAN(InManu),"^",4)
	s BatNo=$p(^DHCINMAN(InManu),"^",5)
	s ExpDate=$p(^DHCINMAN(InManu),"^",6)
	i ExpDate'="" s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
	s Uomdr=$p(^DHCINMAN(InManu),"^",8)
	s UomDesc=##class(PHA.COM.Data.Base).UomDesc(Uomdr)	
	s TheoryQty=$p(^DHCINMAN(InManu),"^",9)
	s FactQty=$p(^DHCINMAN(InManu),"^",10)
	s CostPrice=$p(^DHCINMAN(InManu),"^",12)
	s ManuStartDate=$p(^DHCINMAN(InManu),"^",16)
	i ManuStartDate'="" s ManuStartDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ManuStartDate,"ST")
	s Complate=$p(^DHCINMAN(InManu),"^",26)
	 
	s ManuUser=$p(^DHCINMAN(InManu),"^",23)
	s UserName=##class(PHA.COM.Data.Base).UserName(ManuUser)
	
	
	s InRec=$p(^DHCINMAN(InManu),"^",28)
	s InRecDesc=##class(web.DHCST.IncItmRcp).GetIncRcpDesc(InRec)
	s Remarks=$p(^DHCINMAN(InManu),"^",29)
	s Chkuser=$p(^DHCINMAN(InManu),"^",24)
	i Chkuser'="" s Audited="Y"
	e  s Audited="N"
	s TheoryQty=..ChangVal(TheoryQty,"Qty")
	s FactQty=..ChangVal(FactQty,"Qty")
	s Rp=$p(^DHCINMAN(InManu),"^",11)
	s Sp=$p(^DHCINMAN(InManu),"^",31)
	s CostPrice=..ChangVal(CostPrice,"Qty")
	s Rp=..ChangVal(Rp,"Qty")
	s Sp=..ChangVal(Sp,"Qty")
	s data=LocDr_"^"_LocDesc_"^"_ManuDate_"^"_ManuNo_"^"_BatNo_"^"_ExpDate_"^"_Uomdr_"^"_UomDesc_"^"_TheoryQty_"^"_FactQty_"^"_CostPrice_"^"_Complate_"^"_ManuUser_"^"_UserName_"^"_InRec_"^"_InRecDesc_"^"_Remarks_"^"_Audited_"^"_ManuStartDate_"^"_Rp_"^"_Sp
	s title="LocDr^LocDesc^ManuDate^ManuNo^BatNo^ExpDate^Uomdr^UomDesc^TheoryQty^FactQty^CostPrice^Complate^ManuUser^UserName^InRec^InRecDesc^Remarks^Audited^ManuStartDate^Rp^Sp"
	q ##class(web.DHCSTJQUERYCOMMON).getJsonData(title,data)
}

/// Creator		zzd
/// CreatDate	2018-07-22
/// Input		制剂单id
/// Output
/// Other		w ##class(web.DHCST.ManuOrder).GetManuOrdDetail(1)
ClassMethod GetManuOrdDetail(InManu)
{
	s InRec=$p(^DHCINMAN(InManu),"^",28)
	s TheoryQty=$p(^DHCINMAN(InManu),"^",9)
	s InRecUom=$p(^DHCINMAN(InManu),"^",8)
	
	s Inci=+InRec
	s chl=$p(InRec,"||",2)
	s total=$o(^INCI(Inci,"REC",chl,"ING",""),-1)
	i +total=0 w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()

	s buom=$p(^INCI(Inci,1),"^",10)
	s InRcpUom=$p(^INCI(Inci,"REC",chl),"^",1)
	s InRcpQty=$p(^INCI(Inci,"REC",chl),"^",2)
	s (confac1,confac)=1
	i InRecUom'=InRcpUom d
	.s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(InRcpUom,buom)
	.s confac1=##class(web.DHCST.Common.UtilCommon).UOMFac(InRecUom,buom)
	s TheoryQty=(TheoryQty*confac1)/ (InRcpQty*confac)
	 
	s title="Inci^InciCode^InciDesc^RcpUom^NeedQty"
	s count=0
	s ing=0
	f  s ing=$o(^INCI(Inci,"REC",chl,"ING",ing)) q:ing=""  d
	.s data=^INCI(Inci,"REC",chl,"ING",ing)
	.s InRin=Inci_"||"_chl_"||"_ing
	.s InRinInci=$p(data,"^",1)    //库存项
	.s Incidesc=##class(PHA.COM.Data.Base).InciDesc(InRinInci)
	.s Incicode=##class(PHA.COM.Data.Base).InciCode(InRinInci) 
	.s uomdr=$p(data,"^",3)    
	.s uomdesc=##class(PHA.COM.Data.Base).UomDesc(uomdr)
	. s tmpTheoQty=0
	. i $d(^INCI(Inci,"REC",chl,"ING",ing,"REM")) D
	. . s id=$o(^INCI(Inci,"REC",chl,"ING",ing,"REM",""),-1)
	. . s remarks=^INCI(Inci,"REC",chl,"ING",ing,"REM",id)
	. . i remarks="M" d
	. . .s tmpTheoQty=+$p(^DHCINMAN(InManu),"^",10)  ;如果是原附材料,则按实际用量扣库存 
	. . .s tmpTheoQty=(tmpTheoQty*confac1)/ (InRcpQty*confac) 
	.s qty=$p(data,"^",2)      //数量
	.i tmpTheoQty=0 s needqty=qty*TheoryQty 
	.e  s needqty=qty*tmpTheoQty
	.s qty=..ChangVal(qty,"Qty")
	.s needqty=..ChangVal(needqty,"Qty")
	.s outputData=Inci_"^"_Incicode_"^"_Incidesc_"^"_uomdesc_"^"_needqty
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(total)
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(title,outputData,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(title,outputData,"^")
	w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	q ""
}

/// Creator		zzd
/// CreatDate	2018-07-22
/// Input		制剂单id
/// Output
/// Other		w ##class(web.DHCST.ManuOrder).GetManuOrdBat(1)
ClassMethod GetManuOrdBat(InManu)
{
	q:'$d(^DHCINMAN(InManu)) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s InRec=$p(^DHCINMAN(InManu),"^",28)
	s TheoryQty=$p(^DHCINMAN(InManu),"^",9)
	s InRecUom=$p(^DHCINMAN(InManu),"^",8)
	s Date=+$h
	
	s total=$o(^DHCINMAN(InManu,"BAT",""),-1) 
	q:+total=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s title="Inclb^InciCode^InciDesc^ExpDate^BatNo^Uom^Qty^PQty^PurUom^StkQTy^Manf"
	s count=0
	
	s chl=0
	f  s chl=$o(^DHCINMAN(InManu,"BAT",chl)) q:chl=""  d
	.s Data=^DHCINMAN(InManu,"BAT",chl)
	.s Inclb=$p(Data,"^",1)
	.s UomDr=$p(Data,"^",2)
	.s Qty=$p(Data,"^",3)
	.s Inci=+Inclb
	.s IL=$p(Inclb,"||",2)
	.s LB=$p(Inclb,"||",3)
	.s Incidesc=##class(PHA.COM.Data.Base).InciDesc(Inci)
	.s Incicode=##class(PHA.COM.Data.Base).InciCode(Inci)
	.s UomDesc=##class(PHA.COM.Data.Base).UomDesc(UomDr)
	.s PurUom=$P(^INCI(Inci,3),"^",6)
	.s BaseUom=$P(^INCI(Inci,1),"^",10)
	.s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUom,BaseUom)
	.s PQty=""
	.i BaseUom=UomDr d
	..s PQty=Qty/confac
	.e  d
	..s confac1=##class(web.DHCST.Common.UtilCommon).UOMFac(UomDr,BaseUom)
	..s PQty=Qty*confac1/confac
	.s PUomDesc=##class(PHA.COM.Data.Base).UomDesc(PurUom)
	.s Incib=$P(^INCI(Inci,"IL",IL,"LB",LB),"^",1)
    .s Chl=$p(Incib,"||",2)
    .s IncQty=##CLASS(web.DHCST.Common.DrugStkCommon).QtyINCLBU(Inclb,Date,PurUom)
    .s BatNo=$p(^INCI(Inci,"IB",Chl),"^",1)
 	.s ExpDate=+$p(^INCI(Inci,"IB",Chl),"^",2)
 	.i ExpDate'=0  d
 	..s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
 	.e  d
 	..s ExpDate=""
 	.s Qty=..ChangVal(Qty,"Qty")
 	.s PQty=..ChangVal(PQty,"Qty")
	.s ManfId=##class(PHA.COM.Data.INCLB).%New(Inclb).ManfId()
	.s Manf=##class(PHA.COM.Data.Base).ManfName(ManfId)
 	.i Manf["-" s Manf=$p(Manf,"-",2)
	.s outputData=Inclb_"^"_Incicode_"^"_Incidesc_"^"_ExpDate_"^"_BatNo_"^"_UomDesc_"^"_Qty_"^"_PQty_"^"_PUomDesc_"^"_IncQty_"^"_Manf
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(total)
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(title,outputData,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(title,outputData,"^")
	w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	q ""
}

/// Creator		zzd
/// CreatDate	2018-07-22
/// Input		制剂单id
/// Output
/// Other		w ##class(web.DHCST.ManuOrder).GetManuOrdList(1,30,"2018-07-15^2018-07-15^")
ClassMethod GetManuOrdList(Start, Limit, Params)
{
	s StartDate=$p(Params,"^",1)
	s EndDate=$p(Params,"^",2)
	s Loc=$p(Params,"^",3)
	s Status=$p(Params,"^",4)
	s Inci=$p(Params,"^",5)
	q:StartDate="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	
	s pid=..NewPid()
	
	s num=0
	f Date=StartDate:1:EndDate d
	.s InManu=""
	.f  s InManu=$o(^DHCINMAN(0,"DATE",Date,InManu)) q:InManu=""  d
	..s Stat=$p(^DHCINMAN(InManu),"^",27)
	..q:(Stat'=Status)&(Status'="")
	..i Stat="10" s Stat="保存"
	..i Stat="15" s Stat="完成"
	..i Stat="21" s Stat="审核"
	..s Stat=..Get(Stat)
	..s LocDr=$p(^DHCINMAN(InManu),"^",3)
	..q:(LocDr'=Loc)&(Loc'="")
	..s ManuNo=$p(^DHCINMAN(InManu),"^",1)
	..s InRec=$p(^DHCINMAN(InManu),"^",28)
	..s InciDr=+InRec
	..q:(Inci'="")&&(Inci'=InciDr)
	..s InRecDesc=##class(web.DHCST.IncItmRcp).GetIncRcpDesc(InRec)
	..s ManuDate=$p(^DHCINMAN(InManu),"^",2)
	..i ManuDate'="" s ManuDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ManuDate,"ST")
	..s ManuUser=$p(^DHCINMAN(InManu),"^",23)
	..s UserName=##class(PHA.COM.Data.Base).UserName(ManuUser)
	..s Uomdr=$p(^DHCINMAN(InManu),"^",8)
	..s UomDesc=##class(PHA.COM.Data.Base).UomDesc(Uomdr)
	..s TheoryQty=$p(^DHCINMAN(InManu),"^",9)
	..s TheoryQty=..ChangVal(TheoryQty,"Qty")
	..s FactQty=$p(^DHCINMAN(InManu),"^",10)
	..s FactQty=..ChangVal(FactQty,"Qty")
	..s BatNo=$p(^DHCINMAN(InManu),"^",5)
	..s ExpDate=$p(^DHCINMAN(InManu),"^",6)
	..i ExpDate'="" s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
	..s CostPrice=$p(^DHCINMAN(InManu),"^",12)
	..s CostPrice=..ChangVal(CostPrice,"FmtRA")
	..s InManuRp=$p(^DHCINMAN(InManu),"^",11)   		//进价
	..s InManuRpAmt=$p(^DHCINMAN(InManu),"^",15)		//进价金额
	..s InManuRp=..ChangVal(InManuRp,"FmtRP")
	..s InManuRpAmt=..ChangVal(InManuRpAmt,"FmtRA")
	..s CreatorUser=$p(^DHCINMAN(InManu),"^",25)		//建单人
	..s CreatorUser=##class(PHA.COM.Data.Base).UserName(CreatorUser)
	..s AuditUser=$p(^DHCINMAN(InManu),"^",24)			//审核人
	..s AuditUser=##class(PHA.COM.Data.Base).UserName(AuditUser)
	..s AuditDate=$p(^DHCINMAN(InManu),"^",30)			//审核日期
	..i AuditDate'="" s AuditDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AuditDate,"ST")
	..s InManuSp=$p(^DHCINMAN(InManu),"^",31)			//售价
	..s InManuSpAmt=$p(^DHCINMAN(InManu),"^",32)		//售价金额	
	..s InManuSp=..ChangVal(InManuSp,"FmtSP")
	..s InManuSpAmt=..ChangVal(InManuSpAmt,"FmtSA")
	..s num=num+1
	..s Data1=InManu_"^"_ManuNo_"^"_InRecDesc_"^"_TheoryQty_"^"_FactQty
	..s Data2=UomDesc_"^"_ManuDate_"^"_UserName_"^"_Stat_"^"_BatNo
	..s Data3=ExpDate_"^"_CostPrice_"^"_InManuRp_"^"_InManuRpAmt_"^"_CreatorUser
	..s Data4=AuditUser_"^"_AuditDate_"^"_InManuSp_"^"_InManuSpAmt
	..s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4
	..s ^TMP("DHCST","web.DHCST.ManuOrder","GetManuOrdList",pid,num)=Data
	
	s total=num
    s title1="InManuId^InManuNo^InManuDesc^InManuTQty^InManuFQty"
    s title2="InManuUomDesc^InManuDate^InManuUser^Status^InManuBatNo"
    s title3="InManuExpDate^InManuAddCost^InManuRp^InManuRpAmt^CreatorUser"
    s title4="AuditUser^AuditDate^InManuSp^InManuSpAmt"
    s title=title1_"^"_title2_"^"_title3_"^"_title4
    s count=0
	s outputI=""
	f  s outputI=$o(^TMP("DHCST","web.DHCST.ManuOrder","GetManuOrdList",pid,outputI)) q:outputI=""  d
	.s outputData=^TMP("DHCST","web.DHCST.ManuOrder","GetManuOrdList",pid,outputI)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(total)
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(title,outputData,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(title,outputData,"^")
	i count>0   w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	k ^TMP("DHCST","web.DHCST.ManuOrder","GetManuOrdList",pid)
	q ""
}

ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($this,"DHCST")
}

/// Creator		zzd
/// CreatDate	2018-07-22
/// Description	制剂单完成
/// Input		制剂单id
/// Output
/// Other		w ##class(web.DHCST.ManuOrder).ComplateInManu(1,1)
ClassMethod ComplateInManu(InManu, User)
{
	s AppName=##class(web.DHCST.ManuOrder).%GetParameter("AppName")
	s Stat=$p(^DHCINMAN(InManu),"^",27)
	q:Stat="21" "-1"_"^"_..Get("单据状态不符")
	q:$p(^DHCINMAN(InManu),"^",26)="Y" 0
	s ManuQty=$p(^DHCINMAN(InManu),"^",10)  //实际数量
	s ManuUom=$p(^DHCINMAN(InManu),"^",8)
	
	s LocId=$p(^DHCINMAN(InManu),"^",3)
    s HospId=$p(^CTLOC(LocId),"^",22)
    s Inci=$p(^DHCINMAN(InManu),"^",4)
    /*
    s CurSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inci,+$h,ManuUom,HospId,"G","")
    
    s LastReailPrice=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(Inci,+$h,ManuUom,HospId,"G","")
    s SpAmt=CurSp*ManuQty
    
    s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(LocId)
    s CustID=$p(CustStr,"^",1)
    S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+Inci)
	S StkTypeDesc=$P(CatGrpStr,"^",4)
    S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
    s SpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(SpAmt,Perv,"FmtSA",1)
    */
    s Status="15"
    s Comp="Y"
    s InRec=$p(^DHCINMAN(InManu),"^",28)
    s RecNum=..GetRecNum(InRec)
    /*
    s cpr=..GetItmCpr(InRec)
    s incirp=CurSp/cpr
    s DefaultRp=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"DefaultRp",Perv)  //根据维护的进价取法 取进价
    i DefaultRp=2  d
    .s incirp=LastReailPrice         
 	s incirpamt=incirp*ManuQty
	s incirpamt=##Class(web.DHCSTCOMMPARA).GetNumbDec(incirpamt,Perv,"FmtRA",1)
	s incirp=##Class(web.DHCSTCOMMPARA).GetNumbDec(incirp,Perv,"FmtRP",1)
	*/
	/*
    &sql(update DHC_InManuOrder set INMAN_CostPrice=:incirp,INMAN_CostAmount=:incirpamt,INMAN_CompStatus=:Status,
    	INMAN_UserCompleted=:Comp,INMAN_RecNumber=:RecNum,INMAN_Sp=:CurSp,INMAN_SpAmt=:SpAmt 
    	where INMAN_RowId=:InManu)
    	*/
    &sql(update SQLUser.DHC_InManuOrder set INMAN_CompStatus=:Status,
    	INMAN_UserCompleted=:Comp,INMAN_RecNumber=:RecNum
    	where INMAN_RowId=:InManu)
 	s ret=0
 	s Err=""
 	i SQLCODE'=0 d
 	.s Err=-2_"^"_..Get("更新失败")_","_SQLCODE
 	.s ret=-2
 	q:ret'=0 Err
 	q 0
}

/// 取制剂定价成本系数 LiangQiang
/// w ##class(web.DHCST.ManuOrder).GetItmCpr(InRec)
ClassMethod GetItmCpr(InRec)
{
	s cpr="0.05" 
	s dhcinrec=""
	f  s dhcinrec=$o(^DHCINREC(0,"INREC",InRec,dhcinrec)) q:+dhcinrec=0  d
	.s cpr=$p(^DHCINREC(dhcinrec),"^",2)
	s cpr=cpr+1
	q cpr
}

ClassMethod GetRecNum(InRec)
{
	q:InRec="" ""
	s RecNum=0
	s Inci=+InRec
	s Itm=$p(InRec,"||",2)
	s chl=""
	f  s chl=$o(^INCI(Inci,"REC",Itm,"ING",chl)) q:chl=""  d
	.s RecNum=RecNum+1
	q RecNum
}

/// Creator		zzd
/// CreatDate	2018-07-22
/// Description	制剂单完成
/// Input		制剂单id
/// Output
/// Other		w ##class(web.DHCST.ManuOrder).AuditInManu(12,18946)
ClassMethod AuditInManu(InManu, User)
{
	s Stat=$p(^DHCINMAN(InManu),"^",27)
	q:Stat'="15" -101_"^"_..Get("单据状态不符")
	s ManuNo=$p(^DHCINMAN(InManu),"^",1)
	s Uom=$p(^DHCINMAN(InManu),"^",8)
	s LocId=$p(^DHCINMAN(InManu),"^",3)
	s Inci=$p(^DHCINMAN(InManu),"^",4)
	s BatNo=$p(^DHCINMAN(InManu),"^",5)
	s ExpDate=$p(^DHCINMAN(InManu),"^",6)
	s ManuQty=$p(^DHCINMAN(InManu),"^",10)  //实际数量
	s Sp=$p(^DHCINMAN(InManu),"^",31)		//INMAN_Sp		售价
	s SpAmt=$p(^DHCINMAN(InManu),"^",32)	//INMAN_SpAmt	售价金额
    s HospId=$p(^CTLOC(LocId),"^",22)
	
	s NotUse=$p(^INCI(Inci,2),"^",9)
	q:NotUse="Y" -1_"^"_..Get("制剂已经不可用")

	s Group=""
	s StrParam=Group_"^"_LocId_"^"_User
	
	s LockName=..%GetParameter("AppName")_InManu
	;对目标库存加锁
	s ret=##class(web.DHCST.Common.AppCommon).Lock(LockName)  
	q:ret'=0 -53_"^"_"加锁失败"
	s configret=##class(web.DHCST.Common.AppCommon).GetParamCommon("",LocId,User) //取公共进价规则标志 
    s RpRule=$p(configret,"^",8)
	tstart
	//s $ZT="Error^DHCSTERROR"	
	s $ZT="ThrowJsGetBatUpdateDetail"			
	s Rp=$p(^DHCINMAN(InManu),"^",11)       //INMAN_CostPrice  	进价
	s RpAmt=$p(^DHCINMAN(InManu),"^",15)	//INMAN_CostAmount	进价金额
	s Manf=""
	s Vendor=""
	s Incib=##class(web.DHCST.DHCINGdRec).GetBatNo(Inci,BatNo,ExpDate,Rp,Uom,Manf,Vendor,Sp)	
	i Incib="" d
	.trollback
	.d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
	q:Incib="" -111_"^"_..Get("生成批次信息失败")
	
    s Ret=..InsertDhcItmBat(Incib,InManu)
    i Ret'=0 d
	.trollback
    .d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
    q:Ret'=0 -112_"^"_..Get("保存批次附加信息失败")
 
	s Buom=$p(^INCI(Inci,1),"^",10)
	s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(Uom,Buom)
	s BQty=ManuQty*Fac 

	s Inclb=""
	s Ret=##class(web.DHCST.Common.StockHandle).UpdateStockForImp(Inci,LocId,Incib,BQty)
	i +Ret>0  d
	.s Inclb=Ret
	i Inclb=""  d
	.trollback
	.d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
	q:Inclb="" -113_"^"_..Get("处理库存失败")

	s Type="M"

	s ListData=Type_"^"_ManuNo_"^"_Inclb_"^"_ManuQty_"^"_Uom_"^"_Sp_"^"_User_"^"_InManu_"^"_Rp_"^"_RpAmt_"^"_SpAmt
	s Ret=##class(web.DHCST.Common.StockHandle).IntoTrans(ListData)
	i +Ret'>0  d
	.trollback
	.d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
	q:+Ret'>0 -114_"^"_..Get("保存台帐失败")
	
	s CurDate=+$h
	s CurTime=$p($h,",",2)
	s Status="21"
	&sql(update SQLUser.DHC_InManuOrder set INMAN_Inclb_Dr=:Inclb,INMAN_CompStatus=:Status,INMAN_ChkDate=:CurDate,INMAN_Chk_User_Dr=:User where INMAN_RowId=:InManu)
	i SQLCODE'=0 d
	.trollback
	.d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
 	.s Ret=-2
 	q:+Ret'>0 -2_"^"_..Get("更新失败")_","_SQLCODE
	b 
	i RpRule="3" d     //批次价格
    .s Ret=..HandleAspBatch(InManu,StrParam)
    e  d
    .s Ret=..CreateInManuAspA(InManu,StrParam,RpRule)    ;生成入库损益
	i +Ret'=0 
	. d  trollback
	. d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
    q:+Ret'=0 -3_"^"_..Get("生成调价或损益失败")_Ret

    b ;3
	s tip=""
	s Flag=0
	s Sub=""
	f  s Sub=$o(^DHCINMAN(InManu,"BAT",Sub)) q:(Sub="")||(Sub=0)||(Flag=-1)  d
	. s MOBat=InManu_"||"_Sub
	. s Inclb=$p(^DHCINMAN(InManu,"BAT",Sub),"^",1)
	. s tip=$p(^INCI(+Inclb,1),"^",2)
	. s Qty=$p(^DHCINMAN(InManu,"BAT",Sub),"^",3)
	. s Uom=$p(^DHCINMAN(InManu,"BAT",Sub),"^",2)
	. s CurSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inclb,+$h,Uom,HospId,"G","")
    . s CurRp=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(Inclb,+$h,Uom,HospId,"G","")
	. s Rp=$p(^DHCINMAN(InManu,"BAT",Sub),"^",7)
	. s Sp=$p(^DHCINMAN(InManu,"BAT",Sub),"^",4)
	. i Sp'=CurSp d 
	. .s $p(^DHCINMAN(InManu,"BAT",Sub),"^",4)=CurSp
	. .s $p(^DHCINMAN(InManu,"BAT",Sub),"^",5)=CurSp*Qty
	. i Rp'=CurRp d
	. .s $p(^DHCINMAN(InManu,"BAT",Sub),"^",7)=CurRp
	. .s $p(^DHCINMAN(InManu,"BAT",Sub),"^",8)=CurRp*Qty
	. s Qty=-Qty
	. s RpAmt=-$p(^DHCINMAN(InManu,"BAT",Sub),"^",8)
	. s SpAmt=-$p(^DHCINMAN(InManu,"BAT",Sub),"^",5)
	. 
	. s BQty=-$p(^DHCINMAN(InManu,"BAT",Sub),"^",6)  //基本单位
	. s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	. s Ret=##class(web.DHCST.Common.StockHandle).UpdateStockForImp(+Inclb,LocId,Incib,BQty)
	. i +Ret'>0 s Flag=-1
	. q:+Ret'>0
	. s Type="X"
	. s ListData=Type_"^"_ManuNo_"^"_Inclb_"^"_Qty_"^"_Uom_"^"_Sp_"^"_User_"^"_MOBat_"^"_Rp_"^"_RpAmt_"^"_SpAmt
	. s Ret=##class(web.DHCST.Common.StockHandle).IntoTrans(ListData)
	. i +Ret'>0 s Flag=-1
	. q:+Ret'>0
	i +Ret'>0  d
	.trollback
	.d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
	q:+Ret'>0 -114_"^"_..Get("明细减库失败")_","_tip
	tcommit

	q 0
 
ThrowJsGetBatUpdateDetail
	
	d ULock
	d Error^DHCSTERROR()
	q $ze
ULock
 	trollback
	d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
    q
}

/// Description		-1~1 之间的补0
/// w ##class(web.DHCST.ManuOrder).ChangVal(0.1)
ClassMethod ChangVal(val, Type = "")
{
	i Type="" s Type="FmtRP"
	s hospId=""
	s ret=+##class(web.DHCST.Common.AppCommon).DecLenByFmtType(Type,hospId)
	s len=$l($p(val,".",2))
	q:val=0 val
	q:(len>ret)||(Type="Qty") $fn(val,"",len)
	q $fn(val,"",ret)
}

/// 制剂查询界面导出制剂单列表
Query ExportInManuList(Params As %String) As %Query(ROWSPEC = "制剂单号,制剂名称,理论数量,实际数量,单位,批号,效期,附加费,成本,总金额,建单人,制剂日期,制剂人,审核日期,审核人,售价,售价金额,状态") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCST.ManuOrder","ExportInManuList", "2018-08-15^2018-09-15")
ClassMethod ExportInManuListExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
	s StartDate=$p(Params,"^",1)
	s EndDate=$p(Params,"^",2)
	s Loc=$p(Params,"^",3)
	s Status=$p(Params,"^",4)
	s Inci=$p(Params,"^",5)
	q:StartDate="" $$$OK
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	
	
	s num=0
	f Date=StartDate:1:EndDate d
	.s InManu=""
	.f  s InManu=$o(^DHCINMAN(0,"DATE",Date,InManu)) q:InManu=""  d
	..s Stat=$p(^DHCINMAN(InManu),"^",27)
	..q:(Stat'=Status)&(Status'="")
	..i Stat="10" s Stat="保存"
	..i Stat="15" s Stat="完成"
	..i Stat="21" s Stat="审核"
	..s Stat=..Get(Stat)
	..s LocDr=$p(^DHCINMAN(InManu),"^",3)
	..q:(LocDr'=Loc)&(Loc'="")
	..s ManuNo=$p(^DHCINMAN(InManu),"^",1)
	..s InRec=$p(^DHCINMAN(InManu),"^",28)
	..s InciDr=+InRec
	..q:(Inci'="")&&(Inci'=InciDr)
	..s InRecDesc=##class(web.DHCST.IncItmRcp).GetIncRcpDesc(InRec)
	..s ManuDate=$p(^DHCINMAN(InManu),"^",2)
	..i ManuDate'="" s ManuDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ManuDate,"ST")
	..s ManuUser=$p(^DHCINMAN(InManu),"^",23)
	..s UserName=##class(PHA.COM.Data.Base).UserName(ManuUser)	
	..s Uomdr=$p(^DHCINMAN(InManu),"^",8)
	..s UomDesc=##class(PHA.COM.Data.Base).UomDesc(Uomdr)
	..s TheoryQty=$p(^DHCINMAN(InManu),"^",9)
	..s FactQty=$p(^DHCINMAN(InManu),"^",10)
	..s BatNo=$p(^DHCINMAN(InManu),"^",5)
	..s ExpDate=$p(^DHCINMAN(InManu),"^",6)
	..i ExpDate'="" s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
	..s CostPrice=$p(^DHCINMAN(InManu),"^",12)
	..s InManuRp=$p(^DHCINMAN(InManu),"^",11)   		//进价
	..s InManuRpAmt=$p(^DHCINMAN(InManu),"^",15)		//进价金额
	..s CreatorUser=$p(^DHCINMAN(InManu),"^",25)		//建单人
	..s CreatorUser=##class(PHA.COM.Data.Base).UserName(CreatorUser)
	..s AuditUser=$p(^DHCINMAN(InManu),"^",24)			//审核人
	..s AuditUser=##class(PHA.COM.Data.Base).UserName(AuditUser)
	..s AuditDate=$p(^DHCINMAN(InManu),"^",30)			//审核日期
	..i AuditDate'="" s AuditDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AuditDate,"ST")
	..s InManuSp=$p(^DHCINMAN(InManu),"^",31)			//售价
	..s InManuSpAmt=$p(^DHCINMAN(InManu),"^",32)		//售价金额	
	..s num=num+1
	..d OutPutExportInManuList
	set qHandle = $lb(0,repid,0)
	Quit $$$OK
OutPutExportInManuList
	//制剂单号,制剂名称,理论数量,实际数量,        单位,批号,        效期,   附加费,   成本,     总金额,   建单人,   制剂日期,制剂人 ,  审核日期,审核人,售价,售价金额,状态
	Set Data=$lb(ManuNo,InRecDesc,TheoryQty,FactQty, UomDesc,BatNo,ExpDate,CostPrice,InManuRp,InManuRpAmt,CreatorUser,ManuDate,UserName,AuditDate,AuditUser,InManuSp,InManuSpAmt,Stat)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod ExportInManuListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ExportInManuListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ExportInManuListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ExportInManuListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 制剂查询界面导出制剂明细单列表
/// d ##class(%ResultSet).RunQuery("web.DHCST.ManuOrder","ExportInManuDetail", "38")
Query ExportInManuDetail(InManu As %String) As %Query(ROWSPEC = "药品代码,药品名称,效期,批号,数量,单位,库存数量,入库单位,厂商") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCST.ManuOrder","ExportInManuDetail", "2018-08-15^2018-09-15")
ClassMethod ExportInManuDetailExecute(ByRef qHandle As %Binary, InManu As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
	q:'$d(^DHCINMAN(InManu)) $$$OK
	s InRec=$p(^DHCINMAN(InManu),"^",28)
	s TheoryQty=$p(^DHCINMAN(InManu),"^",9)
	s InRecUom=$p(^DHCINMAN(InManu),"^",8)
	s Date=+$h
	
	s total=$o(^DHCINMAN(InManu,"BAT",""),-1) 
	q:+total=0 $$$OK
	s count=0
	
	s chl=""
	f  s chl=$o(^DHCINMAN(InManu,"BAT",chl)) q:chl=""  d
	.s Data=^DHCINMAN(InManu,"BAT",chl)
	.s Inclb=$p(Data,"^",1)
	.s UomDr=$p(Data,"^",2)
	.s Qty=$p(Data,"^",3)
	.s Inci=+Inclb
	.s IL=$p(Inclb,"||",2)
	.s LB=$p(Inclb,"||",3)
	.s Incidesc=##class(PHA.COM.Data.Base).InciDesc(Inci)
	.s Incicode=##class(PHA.COM.Data.Base).InciCode(Inci)
	.s UomDesc=##class(PHA.COM.Data.Base).UomDesc(UomDr)
	.s PurUom=$P(^INCI(Inci,3),"^",6)
	.s BaseUom=$P(^INCI(Inci,1),"^",10)
	.s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUom,BaseUom)
	.s PQty=""
	.i BaseUom=UomDr d
	..s PQty=Qty/confac
	.e  d
	..s confac1=##class(web.DHCST.Common.UtilCommon).UOMFac(UomDr,BaseUom)
	..s PQty=Qty*confac1/confac
	.s PUomDesc=##class(PHA.COM.Data.Base).UomDesc(PurUom)
	.s Incib=$P(^INCI(Inci,"IL",IL,"LB",LB),"^",1)
    .s Chl=$p(Incib,"||",2)
    .s IncQty=##CLASS(web.DHCST.Common.DrugStkCommon).QtyINCLBU(Inclb,Date,PurUom)
    .s BatNo=$p(^INCI(Inci,"IB",Chl),"^",1)
 	.s ExpDate=+$p(^INCI(Inci,"IB",Chl),"^",2)
 	.i ExpDate'=0  d
 	..s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
 	.e  d
 	..s ExpDate=""
 	.s Qty=..ChangVal(Qty,"Qty")
 	.s PQty=..ChangVal(PQty,"Qty")
	.d OutPutExportInManuDetail
	.s ManfId=##class(PHA.COM.Data.INCLB).%New(Inclb).ManfId()
	.s Manf=##class(PHA.COM.Data.Base).ManfName(ManfId)
 	.i Manf["-" s Manf=$p(Manf,"-",2)
	set qHandle = $lb(0,repid,0)
	Quit $$$OK
OutPutExportInManuDetail
	//药品代码,药品名称,效期,批号,数量,单位,库存数量,入库单位
	Set Data=$lb(Incicode,Incidesc,ExpDate,BatNo,Qty,UomDesc,IncQty,PUomDesc,Manf)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod ExportInManuDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ExportInManuDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ExportInManuDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ExportInManuDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 制剂单打印
/// d ##class(%ResultSet).RunQuery("web.DHCST.ManuOrder","PrintInManuOrd", "6")
Query PrintInManuOrd(InManu As %String) As %Query(ROWSPEC = "HospName,ManuLocDr,ManuLocDesc,ManuDate,ManuNo,ManuBatNo,ManuExpDate,ManuUomdr,ManuUomDesc,ManuTheoryQty:%Double,ManuFactQty:%Double,ManuCostPrice:%Double,Complate,ManuUser,ManuUserName,ManuInRec,ManuDesc,Manuspec,ManuRemarks,ManuStartDate,ManuRp:%Double,ManuRpAmt:%Double,ManuSp:%Double,ManuSpAmt:%Double,num,Incicode,Incidesc,Spec,ExpDate,BatNo,Qty:%Double,UomDesc,PQty:%Double,PUomDesc,Manf,Sp:%Double,SpAmt:%Double,Rp:%Double,RpAmt:%Double,prtDateTime") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCST.ManuOrder","PrintInManuOrd", "")
ClassMethod PrintInManuOrdExecute(ByRef qHandle As %Binary, InManu As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
	q:'$d(^DHCINMAN(InManu)) $$$OK
	s curDate=+$h
	s curDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(curDate,"ST")
	s curTime=$p($h,",",2)
	s curTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(curTime,"ST")
	s prtDateTime=curDate_" "_curTime
	s ManuNo=$p(^DHCINMAN(InManu),"^",1)
	s ManuDate=$p(^DHCINMAN(InManu),"^",2)
	i ManuDate'="" s ManuDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ManuDate,"ST")
	s ManuLocDr=$p(^DHCINMAN(InManu),"^",3)
	s ManuLocDesc=##class(PHA.COM.Data.Base).LocDesc(ManuLocDr)	
	s ManuBatNo=$p(^DHCINMAN(InManu),"^",5)
	s ManuExpDate=$p(^DHCINMAN(InManu),"^",6)
	i ManuExpDate'="" s ManuExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ManuExpDate,"ST")
	s ManuUomdr=$p(^DHCINMAN(InManu),"^",8)
	s ManuUomDesc=##class(PHA.COM.Data.Base).UomDesc(ManuUomdr)
	s ManuTheoryQty=$p(^DHCINMAN(InManu),"^",9)
	s ManuTheoryQty=..ChangVal(ManuTheoryQty,"Qty")
	s ManuFactQty=$p(^DHCINMAN(InManu),"^",10)
	s ManuFactQty=..ChangVal(ManuFactQty,"Qty")
	s ManuCostPrice=$p(^DHCINMAN(InManu),"^",12)
	s ManuCostPrice=..ChangVal(ManuCostPrice,"FmtRP")
	s ManuStartDate=$p(^DHCINMAN(InManu),"^",16)
	i ManuStartDate'="" s ManuStartDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ManuStartDate,"ST")
	s Complate=$p(^DHCINMAN(InManu),"^",26)
	 
	s ManuUser=$p(^DHCINMAN(InManu),"^",23)
	s ManuUserName=##class(PHA.COM.Data.Base).UserName(ManuUser)
	
	s ManuInRec=$p(^DHCINMAN(InManu),"^",28)
	s ManuDesc=$p(^INCI(+ManuInRec,"REC",$p(ManuInRec,"||",2)),"^",12)
	s ManuRemarks=$p(^DHCINMAN(InManu),"^",29)
	s ManuChkuser=$p(^DHCINMAN(InManu),"^",24)
 	s Hosp=$p(^CTLOC(ManuLocDr),"^",22)
 	s Hosp=##class(PHA.COM.Data.Base).HospDesc(Hosp)
 	s Manuspec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",+ManuInRec)
 	s ManuRp=$p(^DHCINMAN(InManu),"^",11)
 	s ManuRp=..ChangVal(ManuRp,"FmtRP")
 	s ManuRpAmt=$p(^DHCINMAN(InManu),"^",15)
 	s ManuRpAmt=..ChangVal(ManuRpAmt,"FmtRA")
 	s ManuSp=$p(^DHCINMAN(InManu),"^",31)
 	s ManuSp=..ChangVal(ManuSp,"FmtSP")
	s ManuSpAmt=$p(^DHCINMAN(InManu),"^",32)
	s ManuSpAmt=..ChangVal(ManuSpAmt,"FmtSA")
	s chl=""
	f  s chl=$o(^DHCINMAN(InManu,"BAT",chl)) q:chl=""  d
	.s Data=^DHCINMAN(InManu,"BAT",chl)
	.s Inclb=$p(Data,"^",1)
	.s UomDr=$p(Data,"^",2)
	.s Qty=$p(Data,"^",3)
	.s Inci=+Inclb
	.s IL=$p(Inclb,"||",2)
	.s LB=$p(Inclb,"||",3)
	.s Incidesc=##class(PHA.COM.Data.Base).InciDesc(Inci)
	.s Incicode=##class(PHA.COM.Data.Base).InciCode(Inci)
	.s UomDesc=##class(PHA.COM.Data.Base).UomDesc(UomDr)
	.s PurUom=$P(^INCI(Inci,3),"^",6)
	.s BaseUom=$P(^INCI(Inci,1),"^",10)
	.s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUom,BaseUom)
	.s PQty=""
	.i BaseUom=UomDr d
	..s PQty=Qty/confac
	.e  d
	..s confac1=##class(web.DHCST.Common.UtilCommon).UOMFac(UomDr,BaseUom)
	..s PQty=Qty*confac1/confac
	.s PQty=..ChangVal(PQty,"Qty")
	.s Qty=..ChangVal(Qty,"Qty")
	.s PUomDesc=##class(PHA.COM.Data.Base).UomDesc(PurUom)
	.s Incib=$P(^INCI(Inci,"IL",IL,"LB",LB),"^",1)
    .s Chl=$p(Incib,"||",2)
    .s BatNo=$p(^INCI(Inci,"IB",Chl),"^",1)
 	.s ExpDate=+$p(^INCI(Inci,"IB",Chl),"^",2)
 	.i ExpDate'=0  d
 	..s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
 	.e  d
 	..s ExpDate=""
	.s ManfId=##class(PHA.COM.Data.INCLB).%New(Inclb).ManfId()
	.s Manf=##class(PHA.COM.Data.Base).ManfName(ManfId)
 	.s Sp=$p(Data,"^",4)
 	.s SpAmt=$p(Data,"^",5)
 	.s Rp=$p(Data,"^",7)
 	.s RpAmt=$p(Data,"^",8)
 	.s Sp=..ChangVal(Sp,"FmtSP")
 	.s SpAmt=..ChangVal(SpAmt,"FmtSA")
 	.s Rp=..ChangVal(Rp,"FmtRP")
 	.s RpAmt=..ChangVal(RpAmt,"FmtRA")
 	.s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",+Inci)
	.d OutPutPrintInManuOrd
	set qHandle = $lb(0,repid,0)
	Quit $$$OK
OutPutPrintInManuOrd
	Set Data=$lb(Hosp,ManuLocDr,ManuLocDesc,ManuDate,ManuNo,ManuBatNo,ManuExpDate,ManuUomdr,ManuUomDesc,ManuTheoryQty,ManuFactQty,ManuCostPrice,Complate,ManuUser,ManuUserName,ManuInRec,ManuDesc,Manuspec,ManuRemarks,ManuStartDate,ManuRp,ManuRpAmt,ManuSp,ManuSpAmt,chl,Incicode,Incidesc,Spec,ExpDate,BatNo,Qty,UomDesc,PQty,PUomDesc,Manf,Sp,SpAmt,Rp,RpAmt,prtDateTime)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod PrintInManuOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrintInManuOrdExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod PrintInManuOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrintInManuOrdExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod HandleAspBatch(InManu, StrParam)
{
    s Ret=0
    s gGroupId=$p(StrParam,"^",1)
    s gLocId=$p(StrParam,"^",2)
    s gUserId=$p(StrParam,"^",3)
    s HospId=""
    i gLocId'="" s HospId=$p(^CTLOC(gLocId),"^",22)
	
    s IncId=$p(^DHCINMAN(InManu),"^",4)
    s NewSp=$p(^DHCINMAN(InManu),"^",31)		//INMAN_Sp		售价
    s Rp=$p(^DHCINMAN(InManu),"^",11)       //INMAN_CostPrice  	进价
    
    s StkGrpType="G"
    S IncDesc=##class(PHA.COM.Data.Base).InciDesc(IncId)
    s Inclb=$p(^DHCINMAN(InManu),"^",7)       //INMAN_Inclb_Dr
    s Incib=$$CIBrow^at299(Inclb)
    q:Incib="" -1
    s UomId=$p(^DHCINMAN(InManu),"^",8)
    s pricestr=##class(web.DHCSTPRICE).GetPriceByIncib(Incib,+$h,UomId,HospId,"")
    s PriorRp=$p(pricestr,"^",1)
    s PriorSp=$p(pricestr,"^",2)
    i (+PriorRp'=+Rp)||(+PriorSp'=+NewSp) d
    .s pricedata = IncId_"^"_UomId_"^"_NewSp_"^"_Rp_"^"_gUserId_"^"_PriorRp_"^"_PriorSp_"^"_StkGrpType_"^"_gLocId_"^"_IncDesc
    .s pricedata=pricedata_"^"_Incib_"^"_HospId
    .s Ret=..CreateAdjPriceBatch(pricedata)
    .
    q Ret
}

ClassMethod CreateAdjPriceBatch(StrParam As %String) As %String
{
	s resultString=0
	s GrpId=$p(StrParam,"^",8)
	s LocId=$p(StrParam,"^",9)
    s AppName=##class(web.DHCST.INAdjPriceBatch).%GetParameter("AppName")
	s AdjBatNo=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,GrpId,LocId)
    s:AdjBatNo="" resultString=-12   ;生成单号失败
	s:+AdjBatNo<0 resultString=-13 
	s preexedate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(+$h,"ST")
	s ItmRowid=$p(StrParam,"^",1)
	s AdjUomId=$p(StrParam,"^",2)
	s ResultSp=$p(StrParam,"^",3)
	s ResultRp=$p(StrParam,"^",4)
	s AdjUserId=$p(StrParam,"^",5)
	s PriorRp=$p(StrParam,"^",6)
	s PriorSp=$p(StrParam,"^",7)
	s Incib=$p(StrParam,"^",11)
	s HospId=$p(StrParam,"^",12)
	i Incib="" s resultString=-16   ;获取batid失败
	q:resultString<0 resultString
	s AdjReasonId=""
    tstart
    s data=Incib_"^"_preexedate_"^"_ItmRowid_"^"_AdjUomId_"^"_ResultSp_"^"_ResultRp_"^"_AdjUserId_"^"_AdjReasonId_"^"_HospId_"^^"_"^"_"入库生成^"_PriorRp_"^"_PriorSp
    s AspBatId=##class(web.DHCST.INAdjPriceBatch).Insert(AdjBatNo,data,"Y")
	i AspBatId<=0 s resultString=-14_","_AspBatId
	i AspBatId<=0  trollback 1
	q:AspBatId<=0 resultString
	s Params=GrpId_"^"_LocId
	s ret=##class(web.DHCST.INAdjPriceBatch).Audit(AspBatId,AdjUserId,Params)
	i ret<0 s resultString=-15
	i ret<0  trollback 1 
	tcommit
	q resultString
}

ClassMethod CreateInManuAspA(InManu, StrParam, RpRule)
{
	q:InManu="" 0
	s gGroupId=$p(StrParam,"^",1)
    s gLocId=$p(StrParam,"^",2)
    s gUserId=$p(StrParam,"^",3)
    s HospId=""
    i gLocId'="" s HospId=$p(^CTLOC(gLocId),"^",22)

    s Sp=$p(^DHCINMAN(InManu),"^",31)		//INMAN_Sp		售价
    s Rp=$p(^DHCINMAN(InManu),"^",11)       //INMAN_CostPrice  	进价
    s Uom=$p(^DHCINMAN(InManu),"^",8)      	//uom 
    s Inclb=$p(^DHCINMAN(InManu),"^",7)   	//INMAN_Inclb_Dr
    s Inci=+Inclb
    b  ;33
    s CurSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inclb,+$h,Uom,HospId,"G","")
    s inciID=$p(Inclb,"||",1)
    s dateh=+$h
    s CurRp=##class(web.DHCSTPRICE).GetRp(Inclb,+$h,Uom,HospId,"") 		//当前售价
    i $d(^DHCRETA(0,"TypePointer","M",InManu)) d
    .s retarowid=$o(^DHCRETA(0,"TypePointer","M",InManu,""))
    .&SQL(delete from DHC_RetAspAmount WHERE RETA_RowId=:retarowid)
    q:(RpRule=2)&(Rp=CurRp)&(Sp=CurSp) 0  ;不需要调价
    q:(RpRule=1)&(Sp=CurSp) 0   
    s ret=0
    s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(gLocId)
    s CustID=$p(CustStr,"^",1)
    S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+Inclb)
	S StkTypeDesc=$P(CatGrpStr,"^",4)
    S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
    s sQty=$p(^DHCINMAN(InManu),"^",10)  //实际数量
    s SpAmt=Sp*sQty
    s SpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(SpAmt,Perv,"FmtSA",1)
    s RpAmt=Rp*sQty
    s RpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(RpAmt,Perv,"FmtRA",1)
    s sType="M"
    s DataStr=Inclb_"^"_Inci_"^"_gLocId_"^"_Sp_"^"_+sQty_"^"_+SpAmt_"^"_gUserId_"^"_InManu_"^"_sType_"^"_Rp_"^"_RpAmt_"^"_HospId_"^"_Uom_"^"_CustID
    s ret=..InsertRetA(DataStr)
    q:ret<0 -1
    q 0
}

ClassMethod InsertRetA(DataStr As %String) As %String
{
 s inclb=$p(DataStr,"^",1)
 s inci=$p(DataStr,"^",2)
 s locdr=$p(DataStr,"^",3)
 s retSp=$p(DataStr,"^",4)
 s qty=$p(DataStr,"^",5)
 s retSpAmt=$p(DataStr,"^",6)
 s userdr=$p(DataStr,"^",7)
 s rowid=$p(DataStr,"^",8)
 s rettype=$p(DataStr,"^",9)
 s retRp=$p(DataStr,"^",10)
 s retRpAmt=$p(DataStr,"^",11)
 s HospID=$p(DataStr,"^",12)
 s Uom=$p(DataStr,"^",13)
 s CustID=$p(DataStr,"^",14)
 s CurSp=+##Class(web.DHCSTPRICE).GetCurSp(inclb,Uom,HospID)
 s CurRp=+##Class(web.DHCSTPRICE).GetCurRp(inclb,Uom,HospID)
 s buom=$p(^INCI(inci,1),"^",10)
 q:(retSp=CurSp)&(retRp=CurRp) 0
 s adjSp=CurSp-retSp    ;损益价格
 s adjRp=CurRp-retRp
 s CurSpAmt=CurSp*qty
 s CurRpAmt=CurRp*qty
 s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inclb)
 s StkTypeDesc=$P(CatGrpStr,"^",4)
 s Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
 s CurSpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(CurSpAmt,Perv,"FmtSA",1)
 s CurRpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(CurRpAmt,Perv,"FmtRA",1)
 s AdjSpAmt=CurSpAmt-retSpAmt
 s AdjRpAmt=CurRpAmt-retRpAmt
 s date=+$h               ;date is the current date
 s time=$p($h,",",2)      ;time is the current time
 i $d(^DHCRETA(0,"TypePointer","M",rowid)) d
 .s retarowid=$o(^DHCRETA(0,"TypePointer","M",rowid,""))
 .&SQL(UPDATE SQLUser.DHC_RetAspAmount SET RETA_RpDiff=:adjRp,RETA_RpAmt=:AdjRpAmt WHERE RETA_RowId=:retarowid)
 e  d
 .&sql(insert into  SQLUser.DHC_RetAspAmount(RETA_INCI_DR,RETA_CTLOC_DR,RETA_AdjPrice,RETA_Qty,
 RETA_Amount,RETA_SSUSR_DR,RETA_Date,RETA_Time,RETA_Pointer,RETA_Type,RETA_RpDiff,RETA_RpAmt,RETA_Uom_Dr,RETA_INCLB_DR) 
  values (:inci,:locdr,:adjSp,:qty,:AdjSpAmt,:userdr,:date,:time,:rowid,:rettype,:adjRp,:AdjRpAmt,:Uom,:inclb))
 i SQLCODE'=0  d
 .s ret=$$SqlErrorRecord^DHCSTERROR("InsertRetA:DHC_RetAspAmount",rowid,SQLCODE_":"_$g(%msg))
 q:SQLCODE'=0 -2
 q 0
}

/// Creator		zzd
/// CreatDate	2019-02-13
/// Description	制剂单取消审核
/// Input		制剂单id
/// Output
/// Other		w ##class(web.DHCST.ManuOrder).CancleAuditInManu(1)
ClassMethod CancleAuditInManu(InManu)
{
	s Stat=$p(^DHCINMAN(InManu),"^",27)
	q:Stat'="21" -11_"^"_..Get("单据状态不符")
	s Ret=..IfAllowCancleAudit(InManu)
	q:+Ret'=0 Ret
	s LockName=..%GetParameter("AppName")_InManu
	;对目标库存加锁
	s Ret=##class(web.DHCST.Common.AppCommon).Lock(LockName)  
	q:Ret<0 -10_"^"_..Get("加锁失败!")
	s Inci=$p(^DHCINMAN(InManu),"^",4)
	s InciDesc=$p(^INCI(Inci,1),"^",2)
	tstart
 	s Ret=##class(web.DHCST.Common.StockHandle).DelIntrs("M",InManu)
	i Ret'=0 d
	.trollback
	.d UnLockInManu
	q:Ret'=0 Ret_"^"_..Get("删除台账失败：")_InciDesc
	s Sub=0
 	f  s Sub=$o(^DHCINMAN(InManu,"BAT",Sub)) q:(Sub="")||(Sub=0)||(Ret'=0)  d
	. s MOBat=InManu_"||"_Sub
	. s Inci=+$p(^DHCINMAN(InManu,"BAT",Sub),"^",1)
	. s Ret=##class(web.DHCST.Common.StockHandle).DelIntrs("X",MOBat)
	. i Ret'=0 d
	..trollback
	..d UnLockInManu
	.q:Ret'=0
	q:Ret'=0 Ret_"^"_..Get("删除台账失败：")_InciDesc
	s Status="10"
	s Comp="N"
	&sql(update SQLUser.DHC_InManuOrder set INMAN_UserCompleted=:Comp,INMAN_Inclb_Dr=:null,INMAN_CompStatus=:Status,INMAN_ChkDate=null,INMAN_Chk_User_Dr=null where INMAN_RowId=:InManu)
	i SQLCODE trollback
	q:SQLCODE -12_"^"_..Get("更新主信息状态失败!")

 	tcommit
 	q 0
UnLockInManu
	d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_InManu)
	q
}

/// Creator		zzd
/// CreatDate	2019-02-13
/// Description	制剂单是否允许取消
/// Input		制剂单id
/// Output
/// Other		w ##class(web.DHCST.ManuOrder).IfAllowCancleAudit(1)
ClassMethod IfAllowCancleAudit(InManu)
{
	s AuditDate=$p(^DHCINMAN(InManu),"^",30)		//审核日期
	s AuditTime=$p(^DHCINMAN(InManu),"^",33)		//审核日期
	s Loc=$p(^DHCINMAN(InManu),"^",3)		//科室
	&sql(select DHCSM_Rowid from SQLUser.DHC_StkMon where DHCSM_CTLOC_DR=:Loc and DHCSM_ToDate>=:AuditDate)
	q:'SQLCODE -1_"^"_..Get("已经月报，不可取消审核")
	s inclb=$p(^DHCINMAN(InManu),"^",7)		//批次
	s LastDate=$o(^DHCINTR(0,"INCLB",inclb,AuditDate))
	q:LastDate'="" -2_"^"_..Get("已经发生业务，不可取消审核")
	s ret=##class(web.DHCST.DHCRetAspAmount).CheckIfHaveAdjPrice(inclb,AuditDate,AuditTime,"")
	q:ret>0 -3_"^"_..Get("已经发生调价，不可取消审核")
	q 0
}

///  
ClassMethod InsertDhcItmBat(Incib As %String, InManuDr As %String) As %Library.String
{

    q:Incib="" -1    ;批次id不能为空
    s DhcIncib=$o(^DHCINCIB(0,"INCIB",Incib,0))
    q:DhcIncib'="" 0                        ;不需要插入
    s BuomDr=$p(^INCI(+Incib,1),"^",10)
    s PuruomDr=$p(^INCI(+Incib,3),"^",6)
    s Rp=$p(^DHCINMAN(InManuDr),"^",11)
 	s Sp=$p(^DHCINMAN(InManuDr),"^",31)
	s uomDr=$p(^DHCINMAN(InManuDr),"^",8)

    s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(PuruomDr,BuomDr)
    i uomDr=BuomDr  d
    .s BRp=Rp
    .s PurRp=Rp*Fac
    .s BSp=Sp
    .s PurSp=Sp*Fac
    e  i uomDr=PuruomDr  d
    .s BRp=Rp/Fac
    .s PurRp=Rp
    .s BSp=Sp/Fac
    .s PurSp=Sp
    e  d
    .s Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(uomDr,BuomDr)
    .s BRp=Rp/Fac2
    .s PurRp=Rp*(Fac/Fac2)
    .s BSp=Sp/Fac2
    .s PurSp=Sp*(Fac/Fac2)
    s Date=+$h
    s Time=$p($h,",",2)
    
    s Mnf=""
    s Vendor=""
    s Dhcingri=""
    s Err=0
    &sql(insert into SQLUser.dhc_incitmbat(INCIB_INCIB_Dr,INCIB_ProduceDate,INCIB_Rp,INCIB_RpPuruom,INCIB_Sp,
    INCIB_SpPuruom,INCIB_PHMNF_Dr,INCIB_APCVM_Dr,INCIB_INGRI_Dr,INCIB_DateAdd,INCIB_TimeAdd) 
    values (:Incib,:Date,:BRp,:PurRp,:BSp,:PurSp,:Mnf,:Vendor,:Dhcingri,:Date,:Time))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("InsertDhcItmBat:dhc_incitmbat","incib:"_Incib,SQLCODE_":"_%msg)
    .s Err=-11  ;保存失败
    q Err
}

}
