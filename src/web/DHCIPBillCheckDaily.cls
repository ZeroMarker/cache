Import SQLUser

Class web.DHCIPBillCheckDaily Extends BILL.COM.Abstract
{

/// Creator: yyx
/// CreateDate: 2014-07-31
/// Description: 业务数据检查,错误数据存在^DHCIPBILLCHECKERR("DHCIPBillCheckDaily")中
///              当三个dhc_patbillorder与dhc_patbilldetails数据不平时，查找错误数据
/// Input: 登记号（或住院号）
/// Output: 账单主表总额，账单order表总额，账单details表总额，错误医嘱名称，医嘱金额，医嘱对应明细金额，dhc_patbillorder的rowid(pbo_rowid),就诊rowid，就诊日期
ClassMethod GetBillOrdAndDetErr(PatNo, MedicareNo)
{
	s PapmiRowID=""
	i (PatNo'="") d
	.s PatNo=##class(web.UDHCJFBaseCommon).regnocon(PatNo)
	.s PapmiRowID=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
	i (MedicareNo'="") d
	.s PapmiRowID=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(MedicareNo, "I")
	i (PapmiRowID'="") d
	.s AdmType=""
    .f  s AdmType=$o(^PAPERdr(PapmiRowID,"ADM",AdmType)) q:(AdmType="")  d
	..s Adm=""
	..f  s Adm=$o(^PAPERdr(PapmiRowID,"ADM",AdmType,Adm)) q:(Adm="")  d
	...s AdmDate=$p(^PAADM(Adm),"^",6)
	...s AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
	...s AdmDepDr=$p(^PAADM(Adm),"^",4)
	...s AdmDepDesc=$p($p(^CTLOC(AdmDepDr),"^",2),"-",2)
	...s PBRowID="",PBSum=0,PBOSum=0,PBDSum=0
	...f  s PBRowID=$o(^DHCPB(0,"ADM",Adm,PBRowID)) q:(PBRowID="")  d
	....s PBSum=$p(^DHCPB(PBRowID),"^",12)   //自付金额
	....s OrdSub="0"
	....f  s OrdSub=$o(^DHCPB(PBRowID,"O",OrdSub)) q:(OrdSub="")  d
	.....q:($d(^DHCPB(PBRowID,"O",OrdSub))=10)
	.....s PBORowID=PBRowID_"||"_OrdSub
	.....s OrdAmt=$p(^DHCPB(PBRowID,"O",OrdSub),"^",11)
	.....s PBOSum=PBOSum+OrdAmt
	.....s ArcimRowID=$p(^DHCPB(PBRowID,"O",OrdSub),"^",3)
	.....s ArcimDesc=$p(^ARCIM(+ArcimRowID,1,1),"^",2)	
	.....s DetAmtSum=0
	.....s DetSub=0
	.....f  s DetSub=$o(^DHCPB(PBRowID,"O",OrdSub,"D",DetSub))  q:DetSub=""  d
	......s DetAmt=$p(^DHCPB(PBRowID,"O",OrdSub,"D",DetSub),"^",7)
	......s PBDSum=PBDSum+DetAmt
	......s DetAmtSum=DetAmtSum+DetAmt
	.....i (OrdAmt'=DetAmtSum) d
	......w !,ArcimDesc_"^"_OrdAmt_"^"_DetAmtSum_"^"_PBORowID_"^"_Adm_"^"_AdmDepDesc
    w !,PBSum_"^"_PBOSum_"^"_PBDSum
}

/// Creator:yyx,liangqiang
/// CreateDate:2014-08-02
/// Function:检查一段时间内药房发药与计费数量不一致的药品医嘱
/// Input:开始日期，结束日期,版本
/// output:医嘱名称，医嘱开始日期，计费数量，发药数量，医嘱rowid
/// 一条医嘱多次发药 ,数据存于  ^TMP(node,pid,"data",oeori)
/// w ##class(web.DHCIPBillCheckDaily).GetCollectPriceDs("13/10/2017", "13/10/2017")
ClassMethod GetCollectPriceDs(stdate, enddate, hospId) As %String
{
	s StDate1=##class(websys.Conversions).DateLogicalToHtml(stdate)
	s EndDate1=##class(websys.Conversions).DateLogicalToHtml(enddate)
    k ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","DRUGQTY",hospId)
    s node="DHCST,DHCSTPHCHECKDATA,GetCollectPriceDs"
	s pid=##class(web.DHCSTPCHCOLLS).NewPid()
	
    s phalocdr=""
    f phalocdr=$o(^DHCPHAC(0,"PHA",phalocdr)) q:(phalocdr="")  d
    .f date=stdate:1:enddate d
    ..s ord=""
    ..f   s ord=$o(^OEORDi(0,"LocStDtArr",phalocdr,0,date,ord)) q:(ord="")  d
    ...s chl=""
    ...f   s chl=$o(^OEORDi(0,"LocStDtArr",phalocdr,0,date,ord,chl)) q:(chl="")  d
    ....s oeori=ord_"||"_chl
    ....s AdmDr=$p($g(^OEORD(ord)),"^",1)
    ....s HospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
	....q:(hospId'=HospDr)
    ....q:'$d(^DHCPHAC(0,"PHADSP",oeori))
	....s dsp=0
	....f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,dsp)) q:(dsp="")  d
	.....s dspdate=+$p(^DHCOEDISQTY(dsp),"^",8)
	.....s dsptime=+$p(^DHCOEDISQTY(dsp),"^",9)
	.....i '$d(^TMP(node,pid,"oeori",oeori,dspdate,dsptime)) d
	......s ^TMP(node,pid,"data",oeori)=..GetDspQty(oeori)
	.....s ^TMP(node,pid,"oeori",oeori,dspdate,dsptime)=""
	
	s dspinfo=""
	s oeori=""
	f  s oeori=$o(^TMP(node,pid,"data",oeori)) q:oeori=""  d
	.s dspqty=+$g(^TMP(node,pid,"data",oeori))
	.s pbqtystr=$$GetBillOrdQty(oeori)
	.s pbqty=$p(pbqtystr,"^",1)
	.s pb=$p(pbqtystr,"^",2)
	.s PAPERNo="",PAPERName=""
	.s OEORDRowid=$p(oeori,"||",1)
	.i (OEORDRowid'="")  d
	..s AdmDr=$p(^OEORD(OEORDRowid),"^",1)
	..i (AdmDr'="")  d
	...s PAPERDr=$p(^PAADM(AdmDr),"^",1)
	...i (PAPERDr'="")  d
	....s PAPERNo=$p(^PAPER(PAPERDr,"PAT",1),"^",1)
	....s PAPERName=$p(^PAPER(PAPERDr,"ALL"),"^",1)  
	.i (+dspqty'=+pbqty) d
	..s ArcimDr=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",2)
	..s ArcimCode="",ArcimDesc=""
	..i (ArcimDr'="")  d
	...s ArcimCode=$p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1),"^",1) 
	...s ArcimDesc=$p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1),"^",2)
	..s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","DRUGQTY",hospId,oeori)="发药数量与计费数量不一致,统计日期:("_StDate1_" --- "_EndDate1_"),登记号: "_PAPERNo_"  姓名: "_PAPERName_"  账单号: "_pb_"^"_ArcimCode_"^"_ArcimDesc_"^"_dspqty_"^"_pbqty    ;发药数量_"^"_计费数量
    
    s OEItmRowID="",DrugNum=0
    f  s OEItmRowID=$o(^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","DRUGQTY",hospId,OEItmRowID)) q:OEItmRowID=""  d
    .s DrugNum=DrugNum+1

    k ^TMP(node,pid,"oeori")
	q "药品数量条数:"_DrugNum
	
GetBillOrdQty(oeori)
    s pb="",pbstr="",pbqty=0
    f  s pb=$o(^DHCPBi(0,"OEORI",oeori,pb)) q:pb=""  d
    .s ordsub=""
    .f  s ordsub=$o(^DHCPBi(0,"OEORI",oeori,pb,ordsub))  q:ordsub=""  d
    ..s billqty=$p(^DHCPB(pb,"O",ordsub),"^",5)
    ..s refqty=$p(^DHCPB(pb,"O",ordsub),"^",6)
    ..s pbqty=pbqty+(+billqty)+(+refqty)
    .s pbstr=pb
 	q pbqty_"^"_pbstr
}

/// 检查一段时间重新生成账单的数量
/// w ##class(web.DHCIPBillCheckDaily).GetRebillNum("","2022-04-02",2)
/// 检查2014-08-01-2014-08-31重新生成账单数量，将执行结果粘到excel，按医院重新生成账单的数量多少
ClassMethod GetRebillNum(StDate, EndDate, hospId)
{
	k ^DHCIPBILLCHECKERR("DHCIPBILL","RebillErr",hospId)
	s StDate1=##class(websys.Conversions).DateLogicalToHtml(StDate)
	s EndDate1=##class(websys.Conversions).DateLogicalToHtml(EndDate)
	s RebillNum=0, NotDelNum=0
	f RebillDate=StDate:1:EndDate d
	.s Rebill=""
	.f  s Rebill=$o(^DHCBILLDEL(RebillDate,Rebill)) q:(Rebill="")  d
	..s RebillAdm=$p(^DHCBILLDEL(RebillDate,Rebill),"^",1)
	..s HospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(RebillAdm)
	..q:(hospId'=HospDr)
	..s AdmType=$p(^PAADM(RebillAdm),"^",2)
	..i (AdmType="I") d
	...s RebillNum=RebillNum+1
	...i $d(^DHCPB(Rebill)) d
	....s NotDelNum=NotDelNum+1
	....s AdmDr=$p(^DHCPB(Rebill),"^",1)
	....s PAPERNo="",PAPERName="",ADMLoc=""
	....i (AdmDr'="")  d
	.....s PAPERDR=$p(^PAADM(AdmDr),"^",1)
	.....s ADMLocDR=$p(^PAADM(AdmDr),"^",4)
	.....i (PAPERDR'="")  d
	......s PAPERNo=$p(^PAPER(PAPERDR,"PAT",1),"^",1)  
	......s PAPERName=$p(^PAPER(PAPERDR,"ALL"),"^",1) 
	.....i (ADMLocDR'="")  d
	......s ADMLoc=$p(^CTLOC(ADMLocDR),"^",2)
	....s ^DHCIPBILLCHECKERR("DHCIPBILL","RebillErr",hospId,Rebill)="登记号: "_PAPERNo_"  姓名: "_PAPERName_"  就诊科室: "_ADMLoc_" 患者重新生成账单后原账单未被删除("_Rebill_"),统计日期:("_StDate1_" --- "_EndDate1_")"
	
	q StDate_"至"_EndDate_"数量:"_RebillNum_";"_"未被删除数量:"_NotDelNum
}

/// 检查住院医嘱是否产生正常的医嘱执行记录（仅适用于7.0以后版本）
/// 没有执行记录或者执行记录的数量为0的数据为错误数据
/// 仅检查两天的数据即可
/// w ##class(web.DHCIPBillCheckDaily).GetOEExecNull()
ClassMethod GetOEExecNull(hospId)
{
	k ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","GetOEExecNull",hospId)
	s StDate=+$h-10
	s EndDate=+$h
	s StDate1=##class(websys.Conversions).DateLogicalToHtml(StDate)
	s EndDate1=##class(websys.Conversions).DateLogicalToHtml(EndDate)

	s OEExcNullNum=0,OEExcQtyNullNum=0,NFirstExecNum=0
	f OEStDate=StDate:1:EndDate d
	.s OERowID=""
	.f  s OERowID=$o(^OEORDi(0,"StDt",OEStDate,OERowID)) q:(OERowID="")  d
	..s Adm=$p(^OEORD(OERowID),"^",1)
	..s AdmType=$p(^PAADM(Adm),"^",2)
	..q:(AdmType'="I")
	..s AdmHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
	..q:(hospId'=AdmHospDR)
	..s OESub=0
	..f  s OESub=$o(^OEORD(OERowID,"I",OESub)) q:(OESub="")  d
	...q:('$d(^OEORD(OERowID,"I",OESub,1)))
	...s OEItmRowID=OERowID_"||"_OESub
	...s ArcimDr=$p(^OEORD(OERowID,"I",OESub,1),"^",2)
	...q:(ArcimDr="")||('$d(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2))))
	...s ArcimDesc=$p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1),"^",2)
	...s ArcimCode=$p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1),"^",1)
	...s ItemCatDr=$p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1),"^",10)
	...k missExecAry
	...s missFlag=##class(web.DHCDocMain).CheckExecValidity(OEItmRowID, .missExecAry)
	...i (missFlag=1) d
	....s OEExcNullNum=OEExcNullNum+$g(missExecAry("MissCount"))
	....s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","GetOEExecNull",hospId,"EXCNull",OEItmRowID)="医嘱未找到执行记录, 统计日期:("_StDate1_" --- "_EndDate1_")"_"^"_ArcimCode_"^"_ArcimDesc

	s OutStr="医嘱无执行记录:"_OEExcNullNum

	q OutStr
}

/// Creator: yyx
/// CreateDate: 2014-08-02
/// Description: 基础数据错误检查
/// Table: dhc_taritem(收费项目基础数据表),dhc_taritemprice(收费项目价格表)
/// Function: 计费组收费项目核查
///         基础dhc_taritemprice数据错误检查,开始日期为空，费别为空，医院id为0，数据均为不正常数据
/// input: 空
/// output: 记录收费项目rowid到global中
/// 此方法增加为后台任务
/// w ##class(web.DHCIPBillCheckDaily).GetTaritemErr()
ClassMethod GetTaritemErr(hospId)
{
	k ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","TARIPRICE",hospId)
	s tari="",HospStr="",HospNum=0
	k TMPHOSP
	s StDateStr="",PatTypeStr=""
	f  s tari=$o(^DHCTARI(tari)) q:tari=""  d
	.q:$l(tari,"||")>1
	.s ShowFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarItem", tari, hospId)
	.q:ShowFlag="N"
	.s tp="0"
	.f  s tp=$o(^DHCTARI(tari,"P",tp)) q:tp=""  d
	..s StDate=$p(^DHCTARI(tari,"P",tp),"^",3)
	..s HospID=$p(^DHCTARI(tari,"P",tp),"^",16)
	..s PatType=$p(^DHCTARI(tari,"P",tp),"^",13)
	..i HospID'="" s TMPHOSP(HospID)=""
	..e  d
	...s HospNull="HospNull"
	...s TMPHOSP(HospNull)=""
	..s TPRowID=tari_"||"_tp
	..s TPCode=$p(^DHCTARI(tari),"^",1)
	..s TPDesc=$p(^DHCTARI(tari),"^",2)
	..i +PatType="0" d
	...s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","TARIPRICE",1,TPRowID)="费别为空"_"^"_$H_"^"_TPCode_"^"_TPDesc
	..i +StDate=0 d
   	...s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","TARIPRICE",2,TPRowID)="日期为空"_"^"_$H_"^"_TPCode_"^"_TPDesc
	..i HospID=0 d
   	...s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","TARIPRICE",3,TPRowID)="医院指针为0"_"^"_$H_"^"_TPCode_"^"_TPDesc
	
	s Type="",Num=0
	f  s Type=$o(^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","TARIPRICE",hospId,Type)) q:Type=""  d
	.s TPRowID=""
	.f  s TPRowID=$o(^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","TARIPRICE",hospId,Type,TPRowID)) q:TPRowID=""  d
	..s Num=Num+1

	s HospID="",HospIDStr=""
	f  s HospID=$o(TMPHOSP(HospID)) q:HospID=""  d
	.s HospNum=HospNum+1
	.i HospIDStr="" s HospIDStr=HospID
	.e  s HospIDStr=HospIDStr_"^"_HospID
	
	q "基础错误:"_Num_";"_"价格表的医院数量:"_HospNum_";"_"医院:"_HospIDStr
}

/// Creator:yyx,liangqiang
/// CreateDate:2014-08-02
/// Table:dhc_taritemprice，药品价格表
/// Function: 检查计费组收费项目价格与药房的价格是否一致
/// input:空
/// output:记录收费项目rowid到global中
/// 此方法增加为后台任务
/// d ##class(web.DHCIPBillCheckDaily).GetItmPriceDs()
ClassMethod GetItmPriceDs(hospId) As %String
{
	k ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","TARIDRUGPRICE",hospId)
	s outpriceinfo=""
	s node="DHCST,DHCSTPHCHECKDATA,GetItmPriceDs"
	s pid=##class(web.DHCSTPCHCOLLS).NewPid()
	s inci=0
	f  s inci=$o(^INCI(inci)) q:(inci="")  d
	.s code=$p($g(^INCI(inci,1)),"^",1)
	.q:(code="")
	.s price=##class(web.DHCSTCOMMONSRV).GetPriceElse(inci,+$h,"",hospId)
	.s code=$$ALPHAUP^SSUTIL4(code)
	.q:'$d(^ARCIM(0,"Code",code))
	.s arcim=$o(^ARCIM(0,"Code",code,""))
	.s version=$o(^ARCIM(0,"Code",code,arcim,""))
	.s arcimrowid=arcim_"||"_version
	.s ShowFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast", arcimrowid, hospId)
	.q:ShowFlag="N"
	.s ordpriceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", "", arcimrowid, +$h, "", "", "", "",hospId)
	.s ordprice=$j($p(ordpriceinfo,"^",1),7,6)
	.i (code="JICS1230") d
	.s price=$j($p(price,"^",1),3,6)
	.s ArcimCode=$p(^ARCIM(arcim,version,1),"^",1)
	.s ArcimDesc=$p(^ARCIM(arcim,version,1),"^",2)
	.i (+price'=+ordprice) d
	..s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","TARIDRUGPRICE",hospId,arcimrowid)="医嘱项价格与药房调价表价格不一致(arc_itmmast,arcim_rowid)"_"^"_price_"^"_ordprice_"^"_(price-ordprice)_"^"_ArcimCode_"^"_ArcimDesc     ;药房价格_"^"_收费项目价格
	q 0
}

/// d ##class(web.DHCIPBillCheckDaily).GetBillOrdQty()
ClassMethod GetBillOrdQty(oeori)
{
    s pb="",pbstr="",pbqty=0
    f  s pb=$o(^DHCPBi(0,"OEORI",oeori,pb)) q:pb=""  d
    .s ordsub=""
    .f  s ordsub=$o(^DHCPBi(0,"OEORI",oeori,pb,ordsub))  q:ordsub=""  d
    ..s billqty=$p(^DHCPB(pb,"O",ordsub),"^",5)
    ..s refqty=$p(^DHCPB(pb,"O",ordsub),"^",6)
    ..s pbqty=pbqty++billqty+(+refqty)
    ..s pbstr=pbstr_"@"_pb
	q pbqty_"^"_pbstr
}

/// Creator:yyx
/// CreateDate:2014-08-02
/// Table:dhc_orderlinktar
/// Function: 检查计费组医嘱项与收费项目关联关系表
/// input:空
/// output:记录收费项目rowid到global中
/// 此方法增加为后台任务
/// w ##class(web.DHCIPBillCheckDaily).GetOrdLinkNull()
ClassMethod GetOrdLinkNull(hospId)
{
	k ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","ORDLINKTAR",hospId)
	s Arcim=""
	f  s Arcim=$o(^ARCIM(Arcim)) q:Arcim=""  d
	.s Version=""
	.f  s Version=$o(^ARCIM(Arcim,Version)) q:Version=""  d
	..s LinkTarNum=0
	..s ArcimRowID=Arcim_"||"_Version
	..s ShowFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast", ArcimRowID, hospId)
	..q:ShowFlag="N"
	..s Tariff=""
	..f  s Tariff=$o(^DHCOLT(0,"ARTTA",ArcimRowID,Tariff)) q:Tariff=""  d
	...s StDate=""
	...f  s StDate=$o(^DHCOLT(0,"ARTTA",ArcimRowID,Tariff,StDate)) q:StDate=""  d
	....s OltRowID=""
	....f  s OltRowID=$o(^DHCOLT(0,"ARTTA",ArcimRowID,Tariff,StDate,OltRowID)) q:OltRowID=""  d
	.....s EndDate=$p(^DHCOLT(OltRowID),"^",5)
	.....i +EndDate=0 d
	......s LinkTarNum=LinkTarNum+1
	..s ArcimCode="",ArcimDesc=""
	..i (+Arcim'=0)  d
	...s ArcimCode=$p(^ARCIM(Arcim,Version,1),"^",1)
	...s ArcimDesc=$p(^ARCIM(Arcim,Version,1),"^",2)
	..i (LinkTarNum=0) d
	...s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","ORDLINKTAR",hospId,ArcimRowID)="无有效对应关系"_"^"_$h_"^"_ArcimCode_"^"_ArcimDesc
	
	s arcim="",Num=0
	f  s arcim=$o(^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","ORDLINKTAR",hospId)) q:arcim=""  d
	.s Num=Num+1
	
	q "无有效对应关系:"_Num
}

/// 获取某个医嘱项的数据
ClassMethod GetOERowIDByArcim(ArcimRowID)
{
	s PBRowID=0
	f  s PBRowID=$o(^DHCPBi(0,"ARCIM",ArcimRowID,PBRowID)) q:PBRowID=""  d
	.s PayFlag=$p(^DHCPB(PBRowID),"^",16)
	.q:PayFlag="P"
	.s PBOSub=0
	.f  s PBOSub=$o(^DHCPBi(0,"ARCIM",ArcimRowID,PBRowID,PBOSub)) q:PBOSub=""  d
	..s OERowID=$p(^DHCPB(PBRowID,"O",PBOSub),"^",4)
	..&sql(UPDATE OE_OrdItem SET OEORI_Billed='TB' WHERE %ID = :OERowID)
}

/// Creator: zhl 
/// Description: 核查医嘱收费项目关联关系
/// Debug: w ##class(web.DHCIPBillCheckDaily).CheckLinkData(3)
ClassMethod CheckLinkData(hospId As %String)
{
	k ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckLinkData",hospId)
	s olt=0
	f  s olt=$o(^DHCOLT(olt))  q:(olt="")  d
	.s arcim=$p(^DHCOLT(olt),"^",1)
	.s tari=$p(^DHCOLT(olt),"^",2)
	.//tangzf 2020-6-3 add start
	.s showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarItem", tari, hospId)
	.q:(showFlag="N")
	.s showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast", arcim, hospId)
	.q:(showFlag="N")  //和本院区无关的数据
	.//tangzf 2020-6-3 add end
	.s qty=$p(^DHCOLT(olt),"^",3)
	.s stdate=$p(^DHCOLT(olt),"^",4)
	.s enddate=$p(^DHCOLT(olt),"^",5)
	.s ErrMessage=""
	.i (arcim'["||")&&(+tari'=0)  d
	..s TarCode=$p($g(^DHCTARI(tari)),"^",1)  
	..s TarDesc=$p($g(^DHCTARI(tari)),"^",2)
	..s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckLinkData",hospId,"LinkDataErr",olt)="医嘱项为空,有收费项目(dhc_orderlinktar,olt_rowid)^"_"^"_TarCode_"^"_TarDesc  
	.i (arcim["||")||(+tari=0)||(+qty=0)||(stdate="")  d
	..s ArcimCode=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",1)
	..s ArcimDesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)
	..s CatID=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)
	..i (CatID'="") s CatIDDesc=$p(^ARC("IC",CatID),"^",2)
	..i $d(^ARCIM(+arcim,$p(arcim,"||",2),1))=0  d
	...s ErrMessage="医嘱项未找到"
	..i (+tari=0)  d
	...i (ErrMessage="")  d
	....s ErrMessage="收费项为空,有医嘱项"
	...e  d
	....s ErrMessage=ErrMessage_"; 收费项为空,有医嘱项"
	..e  d
	...i $d(^DHCTARI(tari))=0  d
	....i (ErrMessage="")  d
	.....s ErrMessage="收费项未找到"
	....e  d
	.....s ErrMessage=ErrMessage_"; 收费项未找到"
	..i (+qty=0) d
	...i (ErrMessage'="")  d
	....s ErrMessage=ErrMessage_"; 医嘱与收费项目对应数量为0" 
	...e  d
	....s ErrMessage="医嘱与收费项目对应数量为0"  
	..i (stdate="")  d
	...i (ErrMessage'="")  d
	....s ErrMessage=ErrMessage_"; 医嘱与收费项目对应开始日期为空" 
	...e  d
	....s ErrMessage="医嘱与收费项目对应开始日期为空"
	..i (ErrMessage'="")  d
	...s ErrMessage=ErrMessage_" (dhc_orderlinktar,olt_rowid)"
	...s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckLinkData",hospId,"LinkDataErr",olt)=ErrMessage_"^"_ArcimCode_"^"_ArcimDesc_"^"_CatIDDesc
	.i (enddate'="")  d
	..s Tariff="",LinkTarNum=0
	..f  s Tariff=$o(^DHCOLT(0,"ARTTA",arcim,Tariff)) q:(Tariff="")  d
	...s Date=""
	...f  s Date=$o(^DHCOLT(0,"ARTTA",arcim,Tariff,Date)) q:(Date="")  d
	....s OltRowID=""
	....f  s OltRowID=$o(^DHCOLT(0,"ARTTA",arcim,Tariff,Date,OltRowID)) q:OltRowID=""  d
	.....s OEndDate=$p(^DHCOLT(OltRowID),"^",5)
	.....i (+OEndDate=0) d
	......s LinkTarNum=LinkTarNum+1
	..i (LinkTarNum=0) d
	...s arcendd=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),7)),"^",1)
	...q:(+arcendd<+$h)&&(arcendd'="")
	...s ArcimCode=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",1)
	...s ArcimDesc=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",2)
	...s CatID=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)
	...i (CatID'="") s CatIDDesc=$p(^ARC("IC",CatID),"^",2)
	...i (ErrMessage="")  d
	....s ErrMessage="医嘱项无有效对应关系"
	...e  d
	....s ErrMessage=ErrMessage_"; 医嘱项无有效对应关系"
	...i (ErrMessage'="")  d
	....s ErrMessage=ErrMessage_"(dhc_orderlinktar,olt_rowid)"
	....s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckLinkData",hospId,"OrderLinkErr",olt)=ErrMessage_"^"_ArcimCode_"^"_ArcimDesc_"^"_CatIDDesc
 
    s Arcim=0
	f  s Arcim=$o(^ARCIM(Arcim)) q:(Arcim="")  d
	.s Version=0
	.f  s Version=$o(^ARCIM(Arcim,Version)) q:(Version="")  d
	..s arcendd=$p($g(^ARCIM(+Arcim,Version,7)),"^",1)
	..q:+(arcendd<+$h)&&(arcendd'="")
	..s LinkTarNum=0
	..s ArcimRowID=Arcim_"||"_Version
	..q:'$d(^ARCIM(Arcim,Version,1))
	..s showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast", ArcimRowID, hospId)
	..q:(showFlag="N")  //和本院区无关的数据
	..s ArcimCode=$p(^ARCIM(Arcim,Version,1),"^",1)
	..s ArcimDesc=$p(^ARCIM(Arcim,Version,1),"^",2)
	..s arcGrp=$p(^ARCIM(Arcim,Version,1),"^",10)
	..s ordCateType=$p($g(^ARC("IC",arcGrp)),"^",7)
	..q:(ordCateType="R")   //药品不按DHC_OrderLinkTar对照
	..s ErrMessage=""
	..s Tariff=""
	..f  s Tariff=$o(^DHCOLT(0,"ARTTA",ArcimRowID,Tariff)) q:(Tariff="")  d
	...s StDate=""
	...f  s StDate=$o(^DHCOLT(0,"ARTTA",ArcimRowID,Tariff,StDate)) q:(StDate="")  d
	....s OltRowID=""
	....f  s OltRowID=$o(^DHCOLT(0,"ARTTA",ArcimRowID,Tariff,StDate,OltRowID)) q:(OltRowID="")  d
	.....s EndDate=$p(^DHCOLT(OltRowID),"^",5)
	.....i (+EndDate=0) d
	......s LinkTarNum=LinkTarNum+1
	..i (LinkTarNum=0) d
	...i (ErrMessage="")  d
	....s ErrMessage="医嘱项无有效对应关系(arc_itmmast,arcim_rowid)"
	...e  d
	....s ErrMessage=ErrMessage_"医嘱项无有效对应关系(arc_itmmast,arcim_rowid)"
	...s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckLinkData",hospId,"OrderLinkNull",ArcimRowID)=ErrMessage_"^"_ArcimCode_"^"_ArcimDesc
    ..i (LinkTarNum>1)  d
    ...s inci=$o(^INCI(0,"ARCIM_DR",+ArcimRowID,""))
    ...s ArcimCode=$p(^ARCIM(+ArcimRowID,$p(ArcimRowID,"||",2),1),"^",1)
	...s ArcimDesc=$p(^ARCIM(+ArcimRowID,$p(ArcimRowID,"||",2),1),"^",2)
	...i (inci'="")  d
	....i (ErrMessage="")  d
	.....s ErrMessage="库存项不能有多条对应关系(arc_itmmast,arcim_rowid)"
	....e  d
	.....s ErrMessage=ErrMessage_"; 库存项不能有多条对应关系(arc_itmmast,arcim_rowid)"
	....s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckLinkData",hospId,"DrugErr",ArcimRowID)=ErrMessage_"^"_ArcimCode_"^"_ArcimDesc

    q 0
}

/// w ##class(web.DHCIPBillCheckDaily).CheckPriceData()
ClassMethod CheckPriceData(hospId)
{
	k ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckPriceData",hospId)
	k ^TMP("DHCBill","CheckTarEndDateErr")
	s tari=0,hospflag=0,Uhospflag=0
	f  s tari=$o(^DHCTARI(tari))  q:tari=""  d
	.q:(tari="")||('$d(^DHCOLT(0,"TAR",tari)))
	.s showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarItem", tari, hospId)
	.q:(showFlag="N")
	.s tp=0,tpnum=0,lastendd="",enddate=""
	.s TariDesc=$P(^DHCTARI(tari),"^",2)
	.s TariCode=$P(^DHCTARI(tari),"^",1)
	.s ErrMessage=""
	.s SubCateDr=$p(^DHCTARI(tari),"^",4)
	.s AcctCateDr=$p(^DHCTARI(tari),"^",5)
	.s MRCateDr=$p(^DHCTARI(tari),"^",6)
	.s InpatCateDr=$p(^DHCTARI(tari),"^",14)
	.s OutpatCateDr=$p(^DHCTARI(tari),"^",15)
	.s EMCCateDr=$p(^DHCTARI(tari),"^",16)
	.s NewMRCCateDr=$p(^DHCTARI(tari),"^",30)
	.i TariCode=""  d
	..s ErrMessage="收费项目代码为空"
	.i TariDesc=""  d
	..i ErrMessage=""  d
	...s ErrMessage="收费项目名称为空"
	..e  d 
	...s ErrMessage=ErrMessage_"; 收费项目名称为空"    
	.i SubCateDr=""  d
	..i ErrMessage=""  d
	...s ErrMessage="收费项目收费子类为空"
	..e  d 
	...s ErrMessage=ErrMessage_"; 收费项目收费子类为空"
	.i InpatCateDr=""  d
	..i ErrMessage=""  d
	...s ErrMessage="收费项目住院费用子类为空"
	..e  d 
	...s ErrMessage=ErrMessage_"; 收费项目住院费用子类为空"
	.i OutpatCateDr=""  d
	..i ErrMessage=""  d
	...s ErrMessage="收费项目门诊费用子类为空"
	..e  d 
	...s ErrMessage=ErrMessage_"; 收费项目门诊费用子类为空"
	.i EMCCateDr=""  d
	..i ErrMessage=""  d
	...s ErrMessage="收费项目核算费用子类为空"
	..e  d 
	...s ErrMessage=ErrMessage_"; 收费项目核算费用子类为空"
	.i AcctCateDr=""  d
	..i ErrMessage=""  d
	...s ErrMessage="收费项目会计费用子类为空"
	..e  d 
	...s ErrMessage=ErrMessage_"; 收费项目会计费用子类为空"
	.i MRCateDr=""  d
	..i ErrMessage=""  d
	...s ErrMessage="收费项目病历首页费用子类为空"
	..e  d 
	...s ErrMessage=ErrMessage_"; 收费项目病历首页费用子类为空"
	.i NewMRCCateDr=""  d
	..i ErrMessage=""  d
	...s ErrMessage="收费项目新病历首页费用子类为空"
	..e  d 
	...s ErrMessage=ErrMessage_"; 收费项目新病历首页费用子类为空"
	.i ErrMessage'=""  d
	..s ErrMessage=ErrMessage_" (dhc_taritem,tar_rowid)"_"^"_TariCode_"^"_TariDesc
	..s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckPriceData",hospId,"TarDataErr",tari)=ErrMessage_"^"_TariCode_"^"_TariDesc 
	.k ^TMP("DHCBill","CheckTarEndDateErr",tari)
	.f  s tp=$o(^DHCTARI(tari,"P",tp))  q:tp=""   d
	..s enddate=$p(^DHCTARI(tari,"P",tp),"^",4)
	..s stdate=$p(^DHCTARI(tari,"P",tp),"^",3)
	..s price=$p(^DHCTARI(tari,"P",tp),"^",5)
	..s instype=$p(^DHCTARI(tari,"P",tp),"^",13)
	..s hosp=$p(^DHCTARI(tari,"P",tp),"^",16)
	..//q:enddate=stdate	
	..s ErrMessage=""
	..i (stdate="")||(instype="")||(price="")   d
	...i stdate=""  d
	....i ErrMessage=""  d
	.....s ErrMessage="收费项目数据不完整,开始日期为空"
	....e  d
	.....s ErrMessage=ErrMessage_"; 收费项目数据不完整,开始日期为空"
	...i instype=""  d
	....i ErrMessage=""  d
	.....s ErrMessage="收费项目数据不完整,收费类别为空"
	....e  d
	.....s ErrMessage=ErrMessage_"; 收费项目数据不完整,收费类别为空"
	...i price=""  d
	....i ErrMessage=""  d
	.....s ErrMessage="收费项目数据不完整,价格为空"
	....e  d
	.....s ErrMessage=ErrMessage_"; 收费项目数据不完整,价格为空"
	...i ErrMessage'=""  d
	....s ErrMessage=ErrMessage_"(dhc_taritemprice,tp_rowid)"
	...s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckPriceData",hospId,"DataErr",tari_"||"_tp)=ErrMessage_"^"_TariCode_"^"_TariDesc
	..q:(stdate="")||(instype="")
	..s hosp2=+hosp
	..s LastTp=$o(^TMP("DHCBill","CheckTarEndDateErr",hospId,tari,hosp2,instype,""),-1)
	..s ^TMP("DHCBill","CheckTarEndDateErr",hospId,tari,hosp2,instype,tp)=enddate
	..//i (lastendd'="")&(stdate'=(lastendd+1))  d
	..s LastEndDate2=""
	..i (+LastTp'=0)  d
	...s LastEndDate2=$g(^TMP("DHCBill","CheckTarEndDateErr",hospId,tari,hosp2,instype,LastTp)) 
	..i (LastTp'=tp)&&(stdate'=(LastEndDate2+1))&&(+LastEndDate2'=0)  d
	...s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckPriceData",hospId,"PriceDateErr",tari_"||"_tp)="收费项价格日期不衔接(dhc_taritemprice,tp_rowid)"_"^"_TariCode_"^"_TariDesc
	..i (enddate="") s tpnum=tpnum+1
	..i (hosp'="") s hospflag=1
	..i (hosp="") s Uhospflag=1
	..s lastendd=enddate
	.s lasttp=$o(^DHCTARI(tari,"P",""),-1)
	.i (+lasttp=0) d
	..s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckPriceData",hospId,"EmptPrice",tari)="有收费项目,但价格表没有记录(dhc_taritemprice,tari_rowid)"_"^"_TariCode_"^"_TariDesc
	.q:(+lasttp=0)
	.i (tpnum=0) d
	..i enddate'=""  d
	...s enddate1=##class(websys.Conversions).DateLogicalToHtml(enddate)
	..s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckPriceData",hospId,"PriceEnd",tari)="收费项目于 "_$g(enddate1)_" 日停止后就没有维护新价格(dhc_taritemprice,tari_rowid)^"_TariCode_"^"_TariDesc
    
    i (hospflag=1)&&(Uhospflag=1)   d
    .s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckPriceData",hospId,"HospErr")="收费项目价格表医院指针不对,不是所有收费项价格都维护了医院(dhc_taritemprice)" 
	//k ^TMP("DHCBill","CheckTarEndDateErr")
	q 0
}

/// creat wangshen
ClassMethod GetDspQty(oeori) As %String
{
	s dispqty=0
	s oedspdate=""
	f  s oedspdate=$o(^DHCPHAC(0,"PHADSP",oeori,oedspdate)) q:oedspdate=""   d
	.s pha=""
	.f  s pha=$o(^DHCPHAC(0,"PHADSP",oeori,oedspdate,pha)) q:pha=""   d
	..s chl=""
	..f  s chl=$o(^DHCPHAC(0,"PHADSP",oeori,oedspdate,pha,chl)) q:chl=""  d
	...q:'$d(^DHCPHAC(pha,"I",chl))
	...s qty=$p(^DHCPHAC(pha,"I",chl),"^",6)
	...s dispqty=dispqty+qty
	
	s retqty=0
	s oeretdate=""
	f  s oeretdate=$o(^PHARET(0,"OEDIS",oeori,oeretdate) ) q:oeretdate=""  d
	.s phar=""
	.f  s phar=$o(^PHARET(0,"OEDIS",oeori,oeretdate,phar) ) q:phar=""  d
	..s chl=""
	..f  s chl=$o(^PHARET(0,"OEDIS",oeori,oeretdate,phar,chl) ) q:chl=""  d
	...s qty=$p(^PHARET(phar,"I",chl),"^",2)
	...s retqty=retqty+qty
		
	q dispqty-retqty
}

/// Creator: chenxi
/// CreateDate: 2014-11-07
/// Table: dhc_taritemprice，药品价格表
/// Description: 检查计费组收费项目价格与药房的价格是否一致(集团化医院根据医院对比)
/// Input: 空
/// Return: 记录收费项目rowid到global中
/// 此方法增加为后台任务
/// Debug: d ##class(web.DHCIPBillCheckDaily).GetItmPriceDsHosp()
ClassMethod GetItmPriceDsHosp(hospId) As %String
{
	k ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","TARIDRUGPRICE")
	s outpriceinfo=""
	s node="DHCST,DHCSTPHCHECKDATA,GetItmPriceDs"
	s pid=##class(web.DHCSTPCHCOLLS).NewPid()
	s inci=0
	f  s inci=$o(^INCI(inci)) q:(inci="")  d
	.s code=$p($g(^INCI(inci,1)),"^",1)
	.q:(code="")
	.s code=$$ALPHAUP^SSUTIL4(code)
	.q:'$d(^ARCIM(0,"Code",code))
	.s arcim=$o(^ARCIM(0,"Code",code,""))
	.s version=$o(^ARCIM(0,"Code",code,arcim,""))
	.s arcimrowid=arcim_"||"_version
	.s HOSPRowId="0"
	.f  s HOSPRowId=$o(^CT("HOSP",HOSPRowId))  q:(HOSPRowId="")  d
	..s HospDesc=$p(^CT("HOSP",HOSPRowId),"^",2) 
	..s price=##class(web.DHCSTCOMMONSRV).GetPriceElse(inci, +$h, "", HOSPRowId)	
	..s ordpriceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", "", arcimrowid, +$h, "", "", "", HOSPRowId, "")
	..s ordprice=$fn($p(ordpriceinfo,"^",1),"",6)
	..s price=$fn($p(price,"^",1),"",6)
	..s ArcimCode=$p(^ARCIM(arcim,version,1),"^",1)
	..s ArcimDesc=$p(^ARCIM(arcim,version,1),"^",2)
	..i (+price'=+ordprice) d
	...s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","TARIDRUGPRICE",arcimrowid)="医嘱项价格与药房调价表价格不一致(arc_itmmast,arcim_rowid)"_"^"_price_"^"_ordprice_"^"_(price-ordprice)_"^"_ArcimCode_"^"_ArcimDesc_"^"_HospDesc     ;药房价格_"^"_收费项目价格
	
	q 0
}

Query CheckClassMethod() As websys.Query(ROWSPEC = "CheckDesc:%String,CheckMethod:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCIPBillDetail","FindBillDetail1","148")
ClassMethod CheckClassMethodExecute(ByRef qHandle As %Binary) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
  
	set CheckDesc="核查医嘱收费项目关联关系", CheckMethod="CheckLinkData"
	do OutputClassMethod
 
	set CheckDesc="核查收费项目价格表", CheckMethod="CheckPriceData"
	do OutputClassMethod
  
	set CheckDesc="核查收费项价格与药房调价表不一致(非集团化医院)", CheckMethod="GetItmPriceDs"
	do OutputClassMethod
  
	//set CheckDesc="核查收费项价格与药房调价表不一致(集团化医院)", CheckMethod="GetItmPriceDsHosp"
	//do OutputClassMethod
  
	set CheckDesc="核查重新生成账单数据", CheckMethod="GetRebillNum"
	do OutputClassMethod
    
	set CheckDesc="核查住院分次发药", CheckMethod="GetCollectPriceDs"
	do OutputClassMethod
  
	set CheckDesc="核查医嘱没有执行记录", CheckMethod="GetOEExecNull"
	do OutputClassMethod
  
 	quit $$$OK
OutputClassMethod
	set Data=$lb(CheckDesc,CheckMethod)
 	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
 	quit
}

ClassMethod CheckDateNum(StDate, EndDate)
{
   q:(StDate="") "StDateNull"
   q:(EndDate="") "EndDateNull"
   
   s StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
   s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
   
   s DateNum=EndDate-StDate
   s CurNum=+$h-EndDate
   
   q DateNum_"^"_CurNum
}

/// d ##class(%ResultSet).RunQuery("web.DHCIPBillDetail","FindBillDetail1","148")
Query FindCheckDaily(StDate, EndDate, CheckFunction, HospId) As websys.Query(ROWSPEC = "TMemoDesc:%String:备注,TArcimDesc:%String:医嘱/收费项目,TArcimCode:%String:代码,TRowid:%String,TOrderPrice:%Float:药品价格/计费数量,TDrugPrice:%Float:药房调价价格/发药数量")
{
}

ClassMethod FindCheckDailyExecute(ByRef qHandle As %Binary, StDate, EndDate, CheckFunction, HospId) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set (TMemoDesc, TArcimDesc, TArcimCode, TRowid, TOrderPrice, TDrugPrice)=""
	if (CheckFunction="CheckLinkData")  do
	.set ArcimFlag=""
	.for  set ArcimFlag=$o(^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckLinkData",HospId,ArcimFlag))  quit:(ArcimFlag="")  do
	..//quit:(ArcimFlag'="OrderLinkErr")
	..set TRowid=""
	..for  set TRowid=$o(^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckLinkData",HospId,ArcimFlag,TRowid))  quit:(TRowid="")  do
	...set myData=$g(^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckLinkData",HospId,ArcimFlag,TRowid))
	...set TMemoDesc=$p(myData,"^",1)
	...set TArcimCode=$p(myData,"^",2)
	...set TArcimDesc=$p(myData,"^",3)
	...do OutputCheckDaily
	
	if (CheckFunction="CheckPriceData")  do
	.set ArcimFlag=""
	.for  set ArcimFlag=$o(^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckPriceData",HospId,ArcimFlag))  quit:(ArcimFlag="")  do
	..if (ArcimFlag'="HospErr")  do
	...set TRowid=""
	...for  set TRowid=$o(^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckPriceData",HospId,ArcimFlag,TRowid))  quit:(TRowid="")  do
	....set myData=$g(^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckPriceData",HospId,ArcimFlag,TRowid))
	....set TMemoDesc=$p(myData,"^",1)
	....set TArcimCode=$p(myData,"^",2)
	....set TArcimDesc=$p(myData,"^",3)
	....do OutputCheckDaily
	..else  do
	...set TMemoDesc=$g(^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckPriceData",HospId,ArcimFlag))
	...set TArcimCode=""
	...set TArcimDesc=""
	...do OutputCheckDaily
  
	if (CheckFunction="GetItmPriceDs")||(CheckFunction="GetItmPriceDsHosp")  do
	.set TRowid=""
	.for  set TRowid=$o(^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","TARIDRUGPRICE",HospId,TRowid))  quit:(TRowid="")  do
	..set myData=$g(^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","TARIDRUGPRICE",HospId,TRowid))
	..set TMemoDesc=$p(myData,"^",1)
	..set TArcimCode=$p(myData,"^",5)
	..set TArcimDesc=$p(myData,"^",6)
	..set TOrderPrice=$p(myData,"^",3)
	..set TDrugPrice=$p(myData,"^",2) 
	..do OutputCheckDaily
  
	if (CheckFunction="GetRebillNum") do
	.set TRowid=""
	.for  set TRowid=$o(^DHCIPBILLCHECKERR("DHCIPBILL","RebillErr",HospId,TRowid))  quit:(TRowid="")  do
	..set myData=$g(^DHCIPBILLCHECKERR("DHCIPBILL","RebillErr",HospId,TRowid))
	..set TMemoDesc=$p(myData,"^",1)
	..set TArcimCode=""
	..set TArcimDesc=""
	..set TOrderPrice=""
	..set TDrugPrice=""
	..do OutputCheckDaily
  
	if (CheckFunction="GetOEExecNull") do
	.set TRowid=""
	.for  set TRowid=$o(^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","GetOEExecNull",HospId,"EXCNull",TRowid))  quit:(TRowid="")  do
	..set myData=$g(^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","GetOEExecNull",HospId,"EXCNull",TRowid))
	..set TMemoDesc=$p(myData,"^",1)
	..set TArcimCode=$p(myData,"^",2)
	..set TArcimDesc=$p(myData,"^",3)
	..set TOrderPrice=""
	..set TDrugPrice=""
	..do OutputCheckDaily
  
	if (CheckFunction="GetCollectPriceDs")  do
	.set TRowid=""
	.for  set TRowid=$o(^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","DRUGQTY",HospId,TRowid))  quit:(TRowid="")  do
	..set myData=$g(^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","DRUGQTY",HospId,TRowid))
	..set TMemoDesc=$p(myData,"^",1)
	..set TArcimCode=$p(myData,"^",2)
	..set TArcimDesc=$p(myData,"^",3)
	..set TOrderPrice=$p(myData,"^",5)
	..set TDrugPrice=$p(myData,"^",4) 
	..do OutputCheckDaily
  
	quit $$$OK
OutputCheckDaily
	set Data=$lb(TMemoDesc,TArcimDesc,TArcimCode,TRowid,TOrderPrice,TDrugPrice)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

}
