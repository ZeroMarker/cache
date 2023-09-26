Import SQLUser

/// 创建时间		：2010 
/// 创建人			：zhouli for 烟台团体费用统计
/// 
Class web.DHCPE.Report.FeeQuery Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 693;

/// d ##class(web.DHCPE.Report.FeeQuery).OutGroupNoPayToHTML("62018","")
ClassMethod OutGroupNoPayToHTML(DateFrom As %String = "", DateTo As %String = "", PayStatus As %String = "")
{

	q:(DateFrom="")&&(DateTo="") 
	d ..GetGroupNoPayInfo(DateFrom,DateTo,PayStatus)

	  s CatJob=$j

   

	//表格第一行 输出团体名字
	w !,"<table>"
	w !,"<tr>"
	w !,"<td width=600 > <input id='DateFrom' name='DateFrom' type='hidden' value='"_$G(%request.Data("StartDate",1))_"'></td>"
    w !," <input id='DateTo' name='DateTo' type='hidden'  value='"_$G(%request.Data("EndDate",1))_"'>"
    w !," <input id='PayStatus' name='PayStatus' type='hidden' value='"_$G(%request.Data("PayStatus",1))_"'>"
	w !," <td class='i-btn'; noWrap><a href='#' id='Export' name='Export' font='10'>导出数据</A></td>"
	//  <td><input type="text" name="name" value="" /></td>
	w !,"</tr>"
    w !,"</table>"
    w "<table class=tblList id=""tGroupNoPayInfo"" Name=""tGroupNoPayInfo"" CELLSPACING=1 width='100%'>",!
	w "<THEAD>",!
	w "<TH id=0>核算分类</TH>",!
	
	s GADMDR=0
	f  s GADMDR=$o(^DHCPENoPayCashier("GADM",CatJob,GADMDR)) Q:(""=GADMDR)  d
	.s GBaseInfo=$g(^DHCPENoPayCashier("GADM",CatJob,GADMDR))
	.w "<TH NOWRAP>"_GBaseInfo_"</TH>",!
	w "</THEAD>",!
	w "<tbody bgcolor='#E6E5FE' TEXT='#000000'>",!
	s RowType="RowOdd" 
	s TarECID=0
	f  s TarECID=$o(^DHCPENoPayCashier(CatJob,TarECID))  q:TarECID=""  d
	.s TarECDesc=$g(^DHCPENoPayCashier(CatJob,TarECID))
	.w "<tr class='"_RowType_"'>",!
	.w "<td class='CellCaption' >"_TarECDesc_"</td>",!
	.s j=0
	.s GADMDR=0
	.f  s GADMDR=$o(^DHCPENoPayCashier("GADMFee","AccountAmount",CatJob,GADMDR)) q:GADMDR=""  d
	..s FactAmount="",DisAmount="",AccountAmount="",AmountStr=""
    ..s DisAmount=0
	..s AccountAmount=$g(^DHCPENoPayCashier("GADMFee","AccountAmount",CatJob,GADMDR,TarECID))
	..s AccountAmount=$fn(AccountAmount,"",2)
	..s FactAmount=$g(^DHCPENoPayCashier("GADMFee","FactAmount",CatJob,GADMDR,TarECID))
	..s FactAmount=$fn(FactAmount,"",2)
	..s DisAmount=AccountAmount-FactAmount
	..i DisAmount'="0"   s DisAmount=$fn(DisAmount,"",2)
	..i FactAmount'="" s AmountStr="折扣金额:"_DisAmount_"   "_"应收金额:"_FactAmount
	..w !,"<td ><font color='red'>"_AmountStr_"</font></td>"
}

/// 获取此段时间内到达属于团体的体检者信息
/// d ##class(web.DHCPE.Report.FeeQuery).GetGroupNoPayInfo("62024","62024")
ClassMethod GetGroupNoPayInfo(DateFrom As %String = "", DateTo As %String = "", PayStatus As %String = "")
{
    k ^DHCPENoPayCashier
    i (""'=DateFrom)  s AdmDate=DateFrom-1
    i (""=DateFrom)   s AdmDate=0
    i (""=DateTo)     s DateTo=+$h 
   
	f  s AdmDate=$O(^DHCPEIADM(0, "AdmDateTime", AdmDate)) Q:(""=AdmDate)||((0'=+DateTo)&(AdmDate>DateTo))  d
	.s AdmTime=0
	.f  s AdmTime=$O(^DHCPEIADM(0, "AdmDateTime", AdmDate, AdmTime)) Q:(""=AdmTime)  d
	..s IAdmRowId=0
	..f  s IAdmRowId=$O(^DHCPEIADM(0, "AdmDateTime", AdmDate, AdmTime, IAdmRowId))  Q:(""=IAdmRowId)  d
 	...s GADMDR=$p(^DHCPEIADM(IAdmRowId),"^",2)
 	...q:GADMDR="" 
 	...s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	...Q:'("ARRIVED"=Status) 
 	...s GADMDR=$p(^DHCPEIADM(IAdmRowId),"^",2) 
 	...q:(GADMDR="")
 	...s PIADM=$p(^DHCPEIADM(IAdmRowId),"^",4)
 	...if (PayStatus="0") d
 	....d ..GetPatTarEMCCate(GADMDR,PIADM)
    ...else  if (PayStatus="2") d
    ....d ..GetExcutePatTarEMCCate(GADMDR,PIADM)


	Q 1
}

// d ##class(web.DHCPE.Report.FeeQuery).GetPatTarEMCCate("122","10892")

ClassMethod GetExcutePatTarEMCCate(GADMDR As %String = "", preAdmId As %String = "")
{
        K ^DHCPENoPayCashier("OrdEntDR")
        s ^tempdhcpe("PayStatus1")=PayStatus_"^"_GADMDR_"^"_preAdmId
        s GBaesID=$p($g(^DHCPEGADM(GADMDR)),"^",1) 
        q:GBaesID=""
        S GBaesInfo=$p(^DHCPEGBI(GBaesID),"^",2) 
        s CatJob=$j
	    s ChildSub=0
	    f  s ChildSub=$o(^DHCPEPreIADM(preAdmId,"ORDITEM", ChildSub)) q:ChildSub=""  d
	    .q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub)),"^",16)'=1 //判断是否有效
	    .s LocID=$P(^DHCPEPreIADM(preAdmId),"^",26)
	    .s OrdEntDR=$p(^DHCPEPreIADM(preAdmId,"ORDITEM", ChildSub),"^",2) 
	    .i OrdEntDR'=""  s ^DHCPENoPayCashier("OrdEntDR",OrdEntDR)=preAdmId
	    
	    .i OrdEntDR="" d 
	    ..s arcitmid=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub)),"^",1)
		..s Amount=+$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub)),"^",14)
		..s CurDate=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub)),"^",12)
		..s Flag=0
		..s CRMORowId=$o(^DHCPECRMO(0,"CRMORI",preAdmId_"||"_ChildSub,0))
		..q:CRMORowId=""
		..s OEORIDR=$p($g(^DHCPECRMO(CRMORowId)),"^",1)
		
		..s ItmMast=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),1)),"^",2)
		..q:ItmMast=""
		..s ItemStat=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),1)),"^",13)
		..;w !,"_$"_preAdmId_"||"_ChildSub_"SS"_OrdEntDR_"&"_ItemStat
		..q:ItemStat'="6"
		..;q:arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee"))
		..q:arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee",LocID))
		..s FSub=0
		..f  s FSub=$o(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub,"FEE",FSub)) q:FSub=""  d
		...S PAuditID=$P($G(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub,"FEE",FSub)),"^",5)
		...Q:PAuditID=""
		...q:$p($g(^DHCPEPreA(PAuditID)),"^",1)="I"           //团体自费加项退出
	    ...q:$p(^DHCPEPreA(PAuditID),"^",14)="CHARGED"   //已收费退出
	    ...s AuditStr=..GetPersonAuditAmount(preAdmId_"||"_ChildSub,"ORDITEM")
	    ...//w !,arcitmid_"%%"_preAdmId_"||"_ChildSub_"||"_FSub
		...s CurFact=+$p($G(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub,"FEE",FSub)),"^",2)
		...q:CurFact=0
		...s TarItem=0
		...f  s TarItem=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem)) q:TarItem=""  d
		....s StartDate=0
		....f  s StartDate=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate)) q:(StartDate="")||(StartDate>CurDate)  d
		.....s OLTID=0
		.....f  s OLTID=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate,OLTID)) q:OLTID=""  d
		......s EndDate=$p(^DHCOLT(OLTID),"^",5)
		......q:(EndDate'="")&&(EndDate<CurDate)
		......s qty=$p(^DHCOLT(OLTID),"^",3)
		......s ADMFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",preAdmId_"||"_ChildSub)) 
		......s CurPrice=+##class(web.UDHCJFPRICE).GetItmPrice(TarItem,CurDate,"",ADMFeeType,"") //得到当前计费项金额
		......//s PersonAuditStr=..GetPersonAuditAmount(preAdmId_"||"_ChildSub,"ORDITEM")
		......s AddbyTwoAuditAmount=$p(AuditStr,"^",1)
		......s AuditNum=$p(AuditStr,"^",2)
		......i (Amount'=0)&&(CurPrice'=0) d
		.......s CurCatFee=(CurPrice/Amount)*CurFact*qty
		.......i +AuditNum>1 s CurAccountAmount=((AddbyTwoAuditAmount)/Amount)*CurPrice*qty
		.......else  s CurAccountAmount=CurPrice*qty
		......e  d
		.......s CurCatFee=CurFact
		......s OneInfo=..GetTarEC(TarItem)
		......//s ^zl("GetTarEC",$p(OneInfo,"^",1))=$p(OneInfo,"^",2)_"%"_$p(OneInfo,"^",1)_"%"_arcitmid_"%"_CurCatFee_"%"_TarItem_"%"_(CurPrice*qty)
		......s ^DHCPENoPayCashier("GADM",CatJob,GADMDR)=GBaesInfo
		......s ^DHCPENoPayCashier(CatJob,$p(OneInfo,"^",1))=$p(OneInfo,"^",2)
		......s ^DHCPENoPayCashier("GADMFee","AccountAmount",CatJob,GADMDR,$p(OneInfo,"^",1))=+$g(^DHCPENoPayCashier("GADMFee","AccountAmount",CatJob,GADMDR,$p(OneInfo,"^",1)))+CurAccountAmount
		......s ^DHCPENoPayCashier("GADMFee","FactAmount",CatJob,GADMDR,$p(OneInfo,"^",1))=+$g(^DHCPENoPayCashier("GADMFee","FactAmount",CatJob,GADMDR,$p(OneInfo,"^",1)))+CurCatFee
		......s ^DHCPENoPayCashier(CatJob,100)="合计"
	    ......s ^DHCPENoPayCashier("GADMFee","AccountAmount",CatJob,GADMDR,100)=+$g(^DHCPENoPayCashier("GADMFee","AccountAmount",CatJob,GADMDR,100))+CurAccountAmount
		......s ^DHCPENoPayCashier("GADMFee","FactAmount",CatJob,GADMDR,100)=+$g(^DHCPENoPayCashier("GADMFee","FactAmount",CatJob,GADMDR,100))+CurCatFee
		
		
		s PIOIOrdEntDR=0
		f  s PIOIOrdEntDR=$o(^DHCPENoPayCashier("OrdEntDR",PIOIOrdEntDR)) q:PIOIOrdEntDR=""  d
		.s preAdmId=$p(PIOIOrdEntDR,"||",1)
		.s childsub=$p(PIOIOrdEntDR,"||",2)
		.q:$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",9)'=1 //判断是否有效
		.s Amount=+$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",7)
		.s CurDate=$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",4)
		.s FSub=0
		.f  s FSub=$o(^DHCPEPreIADM(preAdmId,"ORDENT",childsub,"FEE",FSub)) q:FSub=""  d 
		..s CurFact=+$p($G(^DHCPEPreIADM(preAdmId,"ORDENT",childsub,"FEE",FSub)),"^",2)
		..//w !,PIOIOrdEntDR_"^"_Amount_"^"_CurFact_"^"_preAdmId_"||"_childsub_"||"_FSub
		..S PAuditID=$P($G(^DHCPEPreIADM(preAdmId,"ORDENT",childsub,"FEE",FSub)),"^",5)
		..Q:PAuditID=""
	    ..s AuditStr=..GetPersonAuditAmount(preAdmId_"||"_childsub,"ORDENT")
	    ..Q:PAuditID=""
		..q:$p($g(^DHCPEPreA(PAuditID)),"^",1)="I"           //团体自费加项退出
	    ..q:$p(^DHCPEPreA(PAuditID),"^",14)="CHARGED"   //已收费退出
		..q:CurFact=0
		..s ItemSub=0
		..f  s ItemSub=$o(^DHCPEPreIADM(0,"OrdEnt",preAdmId_"||"_childsub,preAdmId,ItemSub)) q:ItemSub=""  d
		...s arcitmid=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ItemSub)),"^",1)
	    ...q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ItemSub)),"^",16)'=1 //判断是否有效
	    ...s CRMORowId=$o(^DHCPECRMO(0,"CRMORI",preAdmId_"||"_childsub,""))
		...q:CRMORowId=""
		...s OEORIDR=$p($g(^DHCPECRMO(CRMORowId)),"^",1)
		...s ItmMast=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),1) ),"^",2)
		...q:ItmMast=""
		...s ItemStat=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),1) ),"^",13)
		...q:ItemStat'="6"
		...s ItemAmount=+$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ItemSub)),"^",14)
		...q:ItemAmount=0
		...s TarItem=0
		...f  s TarItem=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem)) q:TarItem=""  d
		....s StartDate=0
		....f  s StartDate=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate)) q:(StartDate="")||(StartDate>CurDate)  d
		.....s OLTID=0
		.....f  s OLTID=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate,OLTID)) q:OLTID=""  d
		......s EndDate=$p(^DHCOLT(OLTID),"^",5)
		......q:(EndDate'="")&&(EndDate<CurDate)
		......s qty=$p(^DHCOLT(OLTID),"^",3)
		......s ADMFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",preAdmId_"||"_childsub))
		......s CurPrice=##class(web.UDHCJFPRICE).GetItmPrice(TarItem,CurDate,"",ADMFeeType,"") //得到当前计费项金额
		......s AddbyTwoAuditAmount=$p(AuditStr,"^",1)
		......s AuditNum=$p(AuditStr,"^",2)
		......i Amount'=0 d
		.......s CurCatFee=(CurPrice/Amount)*CurFact*qty
		.......i +AuditNum>1 s CurAccountAmount=((AddbyTwoAuditAmount)/Amount)*CurPrice*qty
		.......else  s CurAccountAmount=CurPrice*qty
		......e  d
		.......s CurCatFee=CurFact
		......s OneInfo=..GetTarEC(TarItem)
		......//W !,$p(OneInfo,"^",2)_"%"_$p(OneInfo,"^",1)_"%"_arcitmid_"%"_CurCatFee_"%"_TarItem_"%"_(CurPrice*qty)
		......s ^DHCPENoPayCashier("GADM",CatJob,GADMDR)=GBaesInfo
		......s ^DHCPENoPayCashier(CatJob,$p(OneInfo,"^",1))=$p(OneInfo,"^",2)
		......s ^DHCPENoPayCashier("GADMFee","AccountAmount",CatJob,GADMDR,$p(OneInfo,"^",1))=+$G(^DHCPENoPayCashier("GADMFee","AccountAmount",CatJob,GADMDR,$p(OneInfo,"^",1)))+CurAccountAmount
		......s ^DHCPENoPayCashier("GADMFee","FactAmount",CatJob,GADMDR,$p(OneInfo,"^",1))=+$G(^DHCPENoPayCashier("GADMFee","FactAmount",CatJob,GADMDR,$p(OneInfo,"^",1)))+CurCatFee
        ......s ^DHCPENoPayCashier(CatJob,100)="合计"
	    ......s ^DHCPENoPayCashier("GADMFee","AccountAmount",CatJob,GADMDR,100)=+$g(^DHCPENoPayCashier("GADMFee","AccountAmount",CatJob,GADMDR,100))+CurAccountAmount
		......s ^DHCPENoPayCashier("GADMFee","FactAmount",CatJob,GADMDR,100)=+$g(^DHCPENoPayCashier("GADMFee","FactAmount",CatJob,GADMDR,100))+CurCatFee
}

ClassMethod GetFactAmount(ordtype, preOrdId)
{
	new preAdmId1,childsub1,feesub1,subroot1
	
	s subroot1="ORDITEM"
	if ordtype=2  d
	.s subroot1="ORDENT"
	
	s preAdmId1=$p(preOrdId,"||",1)
	s childsub1=$p(preOrdId,"||",2)
	 
	s factAmount=0
	s feesub1=0
	f  s feesub1=$o(^DHCPEPreIADM(preAdmId1,subroot1,childsub1,"FEE",feesub1)) q:((feesub1=""))  d
	.s feeData=$g(^DHCPEPreIADM(preAdmId1,subroot1,childsub1,"FEE",feesub1))
	.q:$p(^DHCPEPreA($p(feeData,"^",5)),"^",1)="I"   //团体自费加项退出
	.q:$p(^DHCPEPreA($p(feeData,"^",5)),"^",14)="CHARGED"   //已收费退出
	.s factAmount=+$p(feeData,"^",2)+factAmount
	s factAmount=+factAmount
	s factAmount=$j(factAmount,3,2)
	q factAmount
}

ClassMethod GetTarEC(TarItem)
{
    
	s TarECID=$p($G(^DHCTARI(TarItem)),"^",16)
	Q:TarECID=""
	s TarECDesc=$p($G(^DHCTarC("EC",TarECID)),"^",2)
	q TarECID_"^"_TarECDesc
}

ClassMethod GetOrdEntFaceAmount(PIOIOrdEntDR)
{
      
        s CurFactTotal=0
        s FSub=0
		f  s FSub=$o(^DHCPEPreIADM($p(PIOIOrdEntDR,"||",1),"ORDENT",$p(PIOIOrdEntDR,"||",2),"FEE",FSub)) q:FSub=""  d 
		.s CurFact=+$p($G(^DHCPEPreIADM($p(PIOIOrdEntDR,"||",1),"ORDENT",$p(PIOIOrdEntDR,"||",2),"FEE",FSub)),"^",2)
        .s CurFactTotal=CurFactTotal+CurFact
        q CurFactTotal
}

// d ##class(web.DHCPE.Report.FeeQuery).GetPatTarEMCCate("9","84")

ClassMethod GetPatTarEMCCate(GADMDR As %String = "", preAdmId As %String = "")
{
        K ^DHCPENoPayCashier("OrdEntDR")
        s GBaesID=$p($g(^DHCPEGADM(GADMDR)),"^",1) 
        q:GBaesID=""
        S GBaesInfo=$p(^DHCPEGBI(GBaesID),"^",2) 
        s CatJob=$j
	    s ChildSub=0
	    f  s ChildSub=$o(^DHCPEPreIADM(preAdmId,"ORDITEM", ChildSub))  q:ChildSub=""  d
	    .q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub)),"^",16)'=1 //判断是否有效
	    .s LocID=$P(^DHCPEPreIADM(preAdmId),"^",26)
	    .s OrdEntDR=$p(^DHCPEPreIADM(preAdmId,"ORDITEM", ChildSub),"^",2) 
	    .i OrdEntDR'=""  s ^DHCPENoPayCashier("OrdEntDR",OrdEntDR)=preAdmId
	    .//w !,preAdmId_"||"_ChildSub_"SS"_OrdEntDR
	    .i OrdEntDR="" d 
	    ..s arcitmid=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub)),"^",1)
		..s Amount=+$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub)),"^",14)
		..s CurDate=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub)),"^",12)
		..s Flag=0
		..;q:arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee"))
		..q:arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee",LocID))
		..s FSub=0
		..f  s FSub=$o(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub,"FEE",FSub))  q:FSub=""  d
		...S PAuditID=$P($G(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub,"FEE",FSub)),"^",5)
		...Q:PAuditID=""
		...q:$p(^DHCPEPreA(PAuditID),"^",1)="I"           //团体自费加项退出
	    ...q:$p(^DHCPEPreA(PAuditID),"^",14)="CHARGED"   //已收费退出
	    ...s AuditStr=..GetPersonAuditAmount(preAdmId_"||"_ChildSub,"ORDITEM")
	    ...//w !,arcitmid_"%%"_preAdmId_"||"_ChildSub_"||"_FSub
		...s CurFact=+$p($G(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub,"FEE",FSub)),"^",2)
		...q:CurFact=0
		...s TarItem=0
		...f  s TarItem=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem)) q:TarItem=""  d
		....s StartDate=0
		....f  s StartDate=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate)) q:(StartDate="")||(StartDate>CurDate)  d
		.....s OLTID=0
		.....f  s OLTID=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate,OLTID)) q:OLTID=""  d
		......s EndDate=$p(^DHCOLT(OLTID),"^",5)
		......q:(EndDate'="")&&(EndDate<CurDate)
		......s qty=$p(^DHCOLT(OLTID),"^",3)
		......s ADMFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",preAdmId_"||"_ChildSub)) 
		......s CurPrice=+##class(web.UDHCJFPRICE).GetItmPrice(TarItem,CurDate,"",ADMFeeType,"")  //得到当前计费项金额
		......//s PersonAuditStr=..GetPersonAuditAmount(preAdmId_"||"_ChildSub,"ORDITEM")
		......s AddbyTwoAuditAmount=$p(AuditStr,"^",1)
		......s AuditNum=$p(AuditStr,"^",2)
		......i (Amount'=0)&&(CurPrice'=0) d
		.......s CurCatFee=(CurPrice/Amount)*CurFact*qty
		.......i +AuditNum>1 s CurAccountAmount=((AddbyTwoAuditAmount)/Amount)*CurPrice*qty
		.......else  s CurAccountAmount=CurPrice*qty
		......e  d
		.......s CurCatFee=CurFact
		......s OneInfo=..GetTarEC(TarItem)
		......//s ^zl("GetTarEC",$p(OneInfo,"^",1))=$p(OneInfo,"^",2)_"%"_$p(OneInfo,"^",1)_"%"_arcitmid_"%"_CurCatFee_"%"_TarItem_"%"_(CurPrice*qty)
		......s ^DHCPENoPayCashier("GADM",CatJob,GADMDR)=GBaesInfo
		......s ^DHCPENoPayCashier(CatJob,$p(OneInfo,"^",1))=$p(OneInfo,"^",2)
		......s ^DHCPENoPayCashier("GADMFee","AccountAmount",CatJob,GADMDR,$p(OneInfo,"^",1))=+$g(^DHCPENoPayCashier("GADMFee","AccountAmount",CatJob,GADMDR,$p(OneInfo,"^",1)))+CurAccountAmount
		......s ^DHCPENoPayCashier("GADMFee","FactAmount",CatJob,GADMDR,$p(OneInfo,"^",1))=+$g(^DHCPENoPayCashier("GADMFee","FactAmount",CatJob,GADMDR,$p(OneInfo,"^",1)))+CurCatFee
		......s ^DHCPENoPayCashier(CatJob,100)="合计"
	    ......s ^DHCPENoPayCashier("GADMFee","AccountAmount",CatJob,GADMDR,100)=+$g(^DHCPENoPayCashier("GADMFee","AccountAmount",CatJob,GADMDR,100))+CurAccountAmount
		......s ^DHCPENoPayCashier("GADMFee","FactAmount",CatJob,GADMDR,100)=+$g(^DHCPENoPayCashier("GADMFee","FactAmount",CatJob,GADMDR,100))+CurCatFee
		
		
		s PIOIOrdEntDR=0
		f  s PIOIOrdEntDR=$o(^DHCPENoPayCashier("OrdEntDR",PIOIOrdEntDR))  q:PIOIOrdEntDR=""  d
		.s preAdmId=$p(PIOIOrdEntDR,"||",1)
		.s childsub=$p(PIOIOrdEntDR,"||",2)
		.q:$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",9)'=1	//判断是否有效
		.s Amount=+$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",7)
		.s CurDate=$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",4)
		.s FSub=0
		.f  s FSub=$o(^DHCPEPreIADM(preAdmId,"ORDENT",childsub,"FEE",FSub)) q:FSub=""  d 
		..s CurFact=+$p($G(^DHCPEPreIADM(preAdmId,"ORDENT",childsub,"FEE",FSub)),"^",2)
		..//w !,PIOIOrdEntDR_"^"_Amount_"^"_CurFact_"^"_preAdmId_"||"_childsub_"||"_FSub
		..S PAuditID=$P($G(^DHCPEPreIADM(preAdmId,"ORDENT",childsub,"FEE",FSub)),"^",5)
		..Q:PAuditID=""
	    ..s AuditStr=..GetPersonAuditAmount(preAdmId_"||"_childsub,"ORDENT")
		..q:$p(^DHCPEPreA(PAuditID),"^",1)="I"           //团体自费加项退出
	    ..q:$p(^DHCPEPreA(PAuditID),"^",14)="CHARGED"   //已收费退出
		..q:CurFact=0
		..s ItemSub=0
		..f  s ItemSub=$o(^DHCPEPreIADM(0,"OrdEnt",preAdmId_"||"_childsub,preAdmId,ItemSub)) q:ItemSub=""  d
		...s arcitmid=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ItemSub)),"^",1)
	    ...q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ItemSub)),"^",16)'=1 //判断是否有效
		...s ItemAmount=+$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ItemSub)),"^",14)
		...q:ItemAmount=0
		...s TarItem=0
		...f  s TarItem=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem)) q:TarItem=""  d
		....s StartDate=0
		....f  s StartDate=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate)) q:(StartDate="")||(StartDate>CurDate)  d
		.....s OLTID=0
		.....f  s OLTID=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate,OLTID)) q:OLTID=""  d
		......s EndDate=$p(^DHCOLT(OLTID),"^",5)
		......q:(EndDate'="")&&(EndDate<CurDate)
		......s qty=$p(^DHCOLT(OLTID),"^",3)
		......s ADMFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",preAdmId_"||"_childsub))
		......s CurPrice=##class(web.UDHCJFPRICE).GetItmPrice(TarItem,CurDate,"",ADMFeeType,"")   //得到当前计费项金额
		......s AddbyTwoAuditAmount=$p(AuditStr,"^",1)
		......s AuditNum=$p(AuditStr,"^",2)
		......i Amount'=0 d
		.......s CurCatFee=(CurPrice/Amount)*CurFact*qty
		.......i +AuditNum>1 s CurAccountAmount=((AddbyTwoAuditAmount)/Amount)*CurPrice*qty
		.......else  s CurAccountAmount=CurPrice*qty
		......e  d
		.......s CurCatFee=CurFact
		......s OneInfo=..GetTarEC(TarItem)
		......//W !,$p(OneInfo,"^",2)_"%"_$p(OneInfo,"^",1)_"%"_arcitmid_"%"_CurCatFee_"%"_TarItem_"%"_(CurPrice*qty)
		......s ^DHCPENoPayCashier("GADM",CatJob,GADMDR)=GBaesInfo
		......s ^DHCPENoPayCashier(CatJob,$p(OneInfo,"^",1))=$p(OneInfo,"^",2)
		......s ^DHCPENoPayCashier("GADMFee","AccountAmount",CatJob,GADMDR,$p(OneInfo,"^",1))=+$G(^DHCPENoPayCashier("GADMFee","AccountAmount",CatJob,GADMDR,$p(OneInfo,"^",1)))+CurAccountAmount
		......s ^DHCPENoPayCashier("GADMFee","FactAmount",CatJob,GADMDR,$p(OneInfo,"^",1))=+$G(^DHCPENoPayCashier("GADMFee","FactAmount",CatJob,GADMDR,$p(OneInfo,"^",1)))+CurCatFee
        ......s ^DHCPENoPayCashier(CatJob,100)="合计"
	    ......s ^DHCPENoPayCashier("GADMFee","AccountAmount",CatJob,GADMDR,100)=+$g(^DHCPENoPayCashier("GADMFee","AccountAmount",CatJob,GADMDR,100))+CurAccountAmount
		......s ^DHCPENoPayCashier("GADMFee","FactAmount",CatJob,GADMDR,100)=+$g(^DHCPENoPayCashier("GADMFee","FactAmount",CatJob,GADMDR,100))+CurCatFee
}

ClassMethod OutGroupPayedToHTML(DateFrom As %String = "", DateTo As %String = "")
{

	q:(DateFrom="")&&(DateTo="") 
	d ..GetGroupPayedInfo(DateFrom, DateTo)

	  s CatJob=$j

	//表格第一行 输出团体名字
	w !,"<table>"
	w !,"<tr>"
	w !,"<td width=600 > <input id='DateFrom' name='DateFrom' type='hidden' value='"_$G(%request.Data("StartDate",1))_"'></td>"
    w !," <input id='DateTo' name='DateTo' type='hidden'  value='"_$G(%request.Data("EndDate",1))_"'>"
     w !," <input id='PayStatus' name='PayStatus' type='hidden'  value='"_$G(%request.Data("PayStatus",1))_"'>"
	w !," <td class='i-btn'; noWrap><a href='#' id='Export' name='Export' font='10'>导出数据</A></td>"
	//  <td><input type="text" name="name" value="" /></td>
	w !,"</tr>"
    w !,"</table>"
    w "<table class=tblList id=""tGroupNoPayInfo"" Name=""tGroupNoPayInfo"" CELLSPACING=1 width='100%'>",!
	w "<THEAD>",!
	w "<TH NOWRAP>团体名称</TH>",!
	w "<TH NOWRAP>到达人次</TH>",!
	w "<TH NOWRAP>折扣率</TH>",!
	w "<TH NOWRAP>折扣金额</TH>",!
	w "<TH NOWRAP>实收金额</TH>",!
	w "<TH NOWRAP>合计</TH>",!
	w "<TH NOWRAP>结算时间</TH>",!
	w "<TH NOWRAP>发票号</TH>",!

	
	s PGADMDR=0
	f  s PGADMDR=$o(^DHCPEPayedCashier("PGADMPayedInfo",PGADMDR)) Q:(""=PGADMDR)  d
	.s GDesc="",Person="",Person="",DisAmount="",FaceAmount="",AccountAmount=""
	.s Info=$g(^DHCPEPayedCashier("PGADMPayedInfo",PGADMDR))
	.s GDesc=$p(Info,"^",1)
	.s Person=$p(Info,"^",2)
	.s DisAmount=$p(Info,"^",3)
	.s FaceAmount=$p(Info,"^",4)
	.s AccountAmount=$p(Info,"^",5)
	.s RLTDate=$p(Info,"^",7)
	.s Invno=$p(Info,"^",6)
	.s DisRate=""
	.i (AccountAmount'="")&&(AccountAmount'=FaceAmount)  s DisRate=$fn((FaceAmount/AccountAmount)*100,"",2)_"%"
	.w !,"<tr>"
	.w !,"<td >"_GDesc_"</td>"
	.w !,"<td >"_Person_"</td>"
	.w !,"<td >"_DisRate_"</td>"
	.w !,"<td >"_DisAmount_"</td>"
	.w !,"<td >"_FaceAmount_"</td>"
	.w !,"<td >"_AccountAmount_"</td>"
	.w !,"<td >"_RLTDate_"</td>"
	.w !,"<td >"_Invno_"</td>"
	.w !,"</tr>"
}

// d ##class(web.DHCPE.Report.FeeQuery).GetGroupPayedInfo("62024","")

ClassMethod GetGroupPayedInfo(DateFrom As %String = "", DateTo As %String = "")
{
    k ^DHCPEPayedCashier
    i (""'=DateFrom)  s PRTDate=DateFrom-1
    i (""=DateFrom)   s PRTDate=0
    i (""=DateTo)     s DateTo=+$h 
    f  s PRTDate=$o(^DHCPEINVPRT(0,"DATE",PRTDate))  q:(PRTDate="")||((0'=+DateTo)&(PRTDate>DateTo))  d
    .s PRTRowID=0
    .f  s PRTRowID=$o(^DHCPEINVPRT(0,"DATE",PRTDate,PRTRowID))  q:PRTRowID=""  d
	..S PBDR=$P(^DHCPEINVPRT(PRTRowID),"^",3 )
	..s PRTAcount=$P(^DHCPEINVPRT(PRTRowID),"^",7 )
    ..s PAADMDR=$P(^DHCPEINVPRT(PRTRowID),"^",2 )
    ..S INVNO=$P(^DHCPEINVPRT(PRTRowID),"^",1 )
	..q:$o(^DHCPEIADM(0,"PAADM",PAADMDR,0))'=""
	..s GADM=$o(^DHCPEGADM(0,"DelegateADM",PAADMDR,0))
	..q:GADM=""
	..s PACRMADM=$P(^DHCPEGADM(GADM),"^",2)
	..s PGBI=$p($g(^DHCPEPreGADM(PACRMADM)),"^",1)
	..s PGDesc=$p($g(^DHCPEPreGBI(PGBI)),"^",2)
	..s ^DHCPEPayedCashier("PGADM",PACRMADM)=PGDesc
	..s ^DHCPEPayedCashier("FactAmount",PACRMADM)=+$g(^DHCPEPayedCashier("FactAmount",PACRMADM))+PRTAcount
	..s ^DHCPEPayedCashier("SexStr",PACRMADM,PBDR)=1
	..s ^DHCPEPayedCashier("INVNOStr",PACRMADM)=INVNO_" "_$g(^DHCPEPayedCashier("INVNOStr",PACRMADM))
	..s ^DHCPEPayedCashier("PRTDateStr",PACRMADM)=##class(websys.Conversions).DateLogicalToHtml(PRTDate)_" "_$g(^DHCPEPayedCashier("PRTDateStr",PACRMADM))

	s PACRMADM=0
	f  s PACRMADM=$o(^DHCPEPayedCashier("PGADM",PACRMADM))  q:PACRMADM=""  d
	.s GDesc=$g(^DHCPEPayedCashier("PGADM",PACRMADM))
	.s FactAmount=$g(^DHCPEPayedCashier("FactAmount",PACRMADM))
	.s TotalPerson=..GetGPerson(PACRMADM)
	.s AccountAmount=..GetGAccountAmount(PACRMADM)
	.s DisAmount=AccountAmount-FactAmount
	.s INVNOStr=$g(^DHCPEPayedCashier("INVNOStr",PACRMADM))
	.s PRTDate=$g(^DHCPEPayedCashier("PRTDateStr",PACRMADM))
	.s ^DHCPEPayedCashier("PGADMPayedInfo",PACRMADM)=GDesc_"^"_TotalPerson_"^"_DisAmount_"^"_FactAmount_"^"_AccountAmount_"^"_INVNOStr_"^"_PRTDate
    .s PBDR=0
    .f  s PBDR=$o(^DHCPEPayedCashier("SexStr",PACRMADM,PBDR))  q:PBDR=""  d
    ..d ..GetSexPerson(PACRMADM,PBDR)

    
     s PGADM=0
     f  s PGADM=$o(^DHCPEPayedCashier("SexDesc",PGADM))  q:PGADM=""  d
     .s Sex=0 ,Return="",SexPerson=""
     .f  S Sex=$o(^DHCPEPayedCashier("SexDesc",PGADM,Sex))  q:Sex=""  d
     ..s SexPerson=$g(^DHCPEPayedCashier("SexDesc",PGADM,Sex))
     ..i Return="" s Return=Sex_":"_SexPerson_"人"
     ..else  s Return=Return_" "_Sex_":"_SexPerson_"人"
     .s PutOutStr=$g(^DHCPEPayedCashier("PGADMPayedInfo",PGADM))
     .s ^DHCPEPayedCashier("PGADMPayedInfo",PGADM)=$p(PutOutStr,"^",1)_"^"_Return_"^"_$p(PutOutStr,"^",3,7)
}

ClassMethod GetGPerson(PGADM)
{
  
    s PIADMRowId=0
    s i=0
    f  s PIADMRowId=$o(^DHCPEPreIADM(0,"PGADM",PGADM,PIADMRowId))  q:PIADMRowId=""  d 
	.s Status=$p(^DHCPEPreIADM(PIADMRowId),"^",8)
	.q:Status'="ARRIVED"
	.s i=i+1
    q i
}

ClassMethod GetSexPerson(PGADM, PBDR)
{
    n (PGADM,PBDR)
  
    s PAPBRowId=0
    f  s PAPBRowId=$o(^DHCPEPAPBR(0,"PBDR",PBDR,PAPBRowId))  q:PAPBRowId=""  d
    .s PADR=$P(^DHCPEPAPBR(PAPBRowId),"^",1)
    .s PIADM=0
    .f  s PIADM=$o(^DHCPEPreIADM(0,"PAORDITEM",PADR,PIADM))  q:PIADM=""  d
    ..s PIBIDR=$P(^DHCPEPreIADM(PIADM),"^",1)
    ..S Sex=$p(^DHCPEPreIBI(PIBIDR),"^",3)
    ..i Sex'="" s SexDesc=$p(^CT("SEX",Sex),"^",2)
    ..//w !,PGADM_"##"_PBDR_"$$"_$g(^DHCPEPayedCashier("PIADMStr",PGADM))
    ..q:("^"_($g(^DHCPEPayedCashier("PIADMStr",PGADM)))_"^")[("^"_PIADM_"^")
    ..s ^DHCPEPayedCashier("SexDesc",PGADM,SexDesc)=+$g(^DHCPEPayedCashier("SexDesc",PGADM,SexDesc))+1
    ..s ^DHCPEPayedCashier("PIADMStr",PGADM)=$g(^DHCPEPayedCashier("PIADMStr",PGADM))_"^"_PIADM
}

// d ##class(web.DHCPE.Report.FeeQuery).GetPersonAuditAmount("213||12","ORDITEM")

ClassMethod GetPersonAuditAmount(PIOIDR, Type)
{
   n (PIOIDR, Type,PAuditID)
   s PIADMRowId=$P(PIOIDR,"||",1)
   s PIADMAddOrdItem=$p(^DHCPEPreIADM(PIADMRowId),"^",10)
   s AddOrdItemLimit=$p(^DHCPEPreIADM(PIADMRowId),"^",11)
   s AddOrdItemAmount=$p(^DHCPEPreIADM(PIADMRowId),"^",12)
   if Type="ORDITEM"{
    s PIOIChildSub=0,ADDAmount=0,ADDAmountbyTwoAuditID=0
    f  s PIOIChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub))  q:PIOIChildSub=""  d
    .s PIOIOrdEntDR=$p(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub),"^",2)
    .s PIOIItemStat=$p(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub),"^",16)
    .q:PIOIItemStat'=1
    .s AccountAmount=$p(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub),"^",14)
    .s FChildSub=0,num=0
    .f  s FChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub,"FEE",FChildSub))  q:FChildSub=""  d
    ..S PAuditID=$P($G(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub,"FEE",FChildSub)),"^",5)
    ..Q:PAuditID=""
    ..s num=num+1
    ..s AuditType=$p(^DHCPEPreA(PAuditID),"^",1)
    ..s PAType=$p(^DHCPEPreA(PAuditID),"^",20)
    .i (num=1)&&(AuditType="G")  d 
    ..i PAType="ADD"  S ADDAmount=ADDAmount+AccountAmount
    
    i AddOrdItemLimit="Y"  S ADDAmountbyTwoAuditID=AddOrdItemAmount-ADDAmount
    
    s FChildSub=0,i=0
    f  s FChildSub=$o(^DHCPEPreIADM($P(PIOIDR,"||",1),"ORDITEM",$P(PIOIDR,"||",2),"FEE",FChildSub))  q:FChildSub=""  d
	.S PAuditID=$P($G(^DHCPEPreIADM($P(PIOIDR,"||",1),"ORDITEM",$P(PIOIDR,"||",2),"FEE",FChildSub)),"^",5)
	.Q:PAuditID=""
	.s i=i+1
	
	q ADDAmountbyTwoAuditID_"^"_i
   }
   
	if Type="ORDENT"{
		
	s PIOEChildSub=0,ADDAmount=0,ADDAmountbyTwoAuditID=0
    f  s PIOEChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub))  q:PIOEChildSub=""  d
    .s PIOIOrdEntDR=$p(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub),"^",2)
    .s AccountAmount=$p(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub),"^",14)
    .s FChildSub=0,num=0
    .f  s FChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOEChildSub,"FEE",FChildSub))  q:FChildSub=""  d
    ..S PAuditID=$P($G(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOEChildSub,"FEE",FChildSub)),"^",5)
    ..Q:PAuditID=""
    ..s num=num+1
    ..s AuditType=$p(^DHCPEPreA(PAuditID),"^",1)
    ..s PAType=$p(^DHCPEPreA(PAuditID),"^",20)
    .i (num=1)&&(AuditType="G")  d 
    ..i PAType="ADD"  S ADDAmount=ADDAmount+AccountAmount
    
    i AddOrdItemLimit="Y"  S ADDAmountbyTwoAuditID=AddOrdItemAmount-ADDAmount	
    s FChildSub=0,i=0
    s feesub1=0
	f  s feesub1=$o(^DHCPEPreIADM($P(PIOIDR,"||",1),"ORDENT",$P(PIOIDR,"||",2),"FEE",feesub1)) q:((feesub1=""))  d
	.s feeData=$g(^DHCPEPreIADM($P(PIOIDR,"||",1),"ORDENT",$P(PIOIDR,"||",2),"FEE",feesub1))
	.s PIOEFPAuditDR=$p(feeData,"^",5)
	.Q:PAuditID=""
	.s i=i+1
	
	q ADDAmountbyTwoAuditID_"^"_i
	}
}

// d ##class(web.DHCPE.Report.FeeQuery).GetGAccountAmount("39")

ClassMethod GetGAccountAmount(PGAM)
{
  
   
   S PIADMRowId=0,GAmountAmount=0
   f   s PIADMRowId=$o(^DHCPEPreIADM(0,"PGADM",PGAM,PIADMRowId))  q:PIADMRowId=""  d
   .s PIADMAddOrdItem=$p(^DHCPEPreIADM(PIADMRowId),"^",10)
   .s AddOrdItemLimit=$p(^DHCPEPreIADM(PIADMRowId),"^",11)
   .s AddOrdItemAmount=$p(^DHCPEPreIADM(PIADMRowId),"^",12)
   .s PIOIChildSub=0,ADDAmount=0
   .f  s PIOIChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub))  q:PIOIChildSub=""  d
   ..q:""=$G(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub))
   ..s PIOIOrdEntDR=$p(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub),"^",2)
   ..s PIOIItemStat=$p(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub),"^",16)
   ..q:PIOIItemStat'=1
   ..s AccountAmount=$p(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub),"^",14)
   ..if PIOIOrdEntDR=""  d
   ...s FChildSub=0,num=0
   ...f  s FChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub,"FEE",FChildSub))  q:FChildSub=""  d
   ....S PAuditID=$P($G(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub,"FEE",FChildSub)),"^",5)
   ....Q:PAuditID=""
   ....s num=num+1
   ....s AuditType=$p(^DHCPEPreA(PAuditID),"^",1)
   ....s PAType=$p(^DHCPEPreA(PAuditID),"^",20)
   ...i (num=1)&&(AuditType="G")  d 
   .... S GAmountAmount=GAmountAmount+AccountAmount
   .... i PAType="ADD"  S ADDAmount=ADDAmount+AccountAmount
   ...i num>1   d 
   ....i AddOrdItemLimit="Y" S GAmountAmount=GAmountAmount+AddOrdItemAmount-ADDAmount
   ....ELSE  S GAmountAmount=GAmountAmount+AccountAmount
   ..if PIOIOrdEntDR'=""  d
   ...s num=0
   ...s feesub1=0,ADDAmount=0
   ...f  s feesub1=$o(^DHCPEPreIADM($P(PIOIOrdEntDR,"||",1),"ORDENT",$P(PIOIOrdEntDR,"||",2),"FEE",feesub1)) q:((feesub1=""))  d
   ....s feeData=$g(^DHCPEPreIADM($P(PIOIOrdEntDR,"||",1),"ORDENT",$P(PIOIOrdEntDR,"||",2),"FEE",feesub1))
   ....s PIOEFPAuditDR=$p(feeData,"^",5)
   ....Q:PIOEFPAuditDR=""
   ....s num=num+1
   ....s AuditType=$p(^DHCPEPreA(PIOEFPAuditDR),"^",1) 
   ....s PAType=$p(^DHCPEPreA(PIOEFPAuditDR),"^",20)
   ...i (num=1)&&(AuditType="G")  d
   ....S GAmountAmount=GAmountAmount+AccountAmount
   ....i PAType="ADD"  S ADDAmount=ADDAmount+AccountAmount
   ...i num>1   d
   ....i AddOrdItemLimit="Y" S GAmountAmount=GAmountAmount+AddOrdItemAmount-ADDAmount
   ....ELSE  S GAmountAmount=GAmountAmount+AccountAmount

  Q GAmountAmount
}

// for 烟台 打印个人费用明细

ClassMethod GetIADMItemDetail(PIADMRowId, InvID As %String = "")
{
	s ARCIMStr=""
	i PIADMRowId'="" d
	.S PIBIDR=$P(^DHCPEPreIADM(PIADMRowId),"^",1)
    .s PatName=""
    .s PatName=$p($G(^DHCPEPreIBI(PIBIDR)),"^",2)
    .s SetSub=""
    .f  s SetSub=$O(^DHCPEPreIADM(PIADMRowId,"ORDENT",SetSub)) q:SetSub=""  d
    ..s Flag=$P(^DHCPEPreIADM(PIADMRowId,"ORDENT",SetSub),"^",9)
    ..q:Flag'="1"
    ..s SetID=$P(^DHCPEPreIADM(PIADMRowId,"ORDENT",SetSub),"^",1)
    ..s ARCIMDesc=$P(^ARCOS(SetID),"^",2)
    ..s ARCIMNum=1
    ..s ARCIMAmount=##class(web.DHCPE.Report.GOEFeeDetail).GFactAmountByOrd(PIADMRowId_"||"_SetSub,"I","ORDENT")
    ..i ARCIMStr=""  d
    ...S ARCIMStr=ARCIMDesc_"^"_ARCIMNum_"^"_ARCIMAmount
    ..else  d
    ...s ARCIMStr=ARCIMStr_"$"_ARCIMDesc_"^"_ARCIMNum_"^"_ARCIMAmount
	.s ItemSub=""
	.f  s ItemSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDITEM",ItemSub)) q:ItemSub=""  d
	..s Flag=$P(^DHCPEPreIADM(PIADMRowId,"ORDITEM",ItemSub),"^",16)
	..q:Flag'="1"
	..s SetID=$P(^DHCPEPreIADM(PIADMRowId,"ORDITEM",ItemSub),"^",2)
	..q:SetID'=""
	..s ItmMastDR=$P(^DHCPEPreIADM(PIADMRowId,"ORDITEM",ItemSub),"^",1)
	..s ARCIMDesc=$p(^ARCIM($p(ItmMastDR,"||",1),$p(ItmMastDR,"||",2),1),"^",2)
	..s ARCIMNum=1
	..s ARCIMAmount=##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(PIADMRowId_"||"_ItemSub,"I","")
    ..i ARCIMStr=""  d
    ...S ARCIMStr=ARCIMDesc_"^"_ARCIMNum_"^"_ARCIMAmount
    ..else  d
    ...s ARCIMStr=ARCIMStr_"$"_ARCIMDesc_"^"_ARCIMNum_"^"_ARCIMAmount
	e  d
    .
	s PatName=PatName_"#"_"医嘱^数量^金额"
    i ARCIMStr'=""  S Str=PatName_"$"_ARCIMStr
    q Str

    k ^DHCPETMP("IADMItemList")
    Q:PIADMRowId="" ""
    S PIBIDR=$P(^DHCPEPreIADM(PIADMRowId),"^",1)
    s PatName=""
    s PatName=$p($G(^DHCPEPreIBI(PIBIDR)),"^",2)
    S PIOIChildSub=0
    f  s PIOIChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub))  q:PIOIChildSub=""  d
    .s CurDate=$g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub))
    .s PIOIDR=PIADMRowId_"||"_PIOIChildSub
    .s ItmMastDR=$p(CurDate,"^",1)
    .s ItemStat=$p(CurDate,"^",16)
    .q:ItemStat'=1
    .s PIOEDR=$p(CurDate,"^",2)
	.If PIOEDR'="" Do
	..d ##class(web.DHCPE.OrdSetsPrice).SplitOrdSetPrice(PIOEDR)
	..s EntFactAmountStr=##class(web.DHCPE.Report.GOEFeeDetail).GFactAmountByOrd(PIOEDR,"I","ORDENT")
	..s EntFactTotalAmount=$p(EntFactAmountStr,"^",1)
	..s FactAmount=$p(EntFactAmountStr,"^",2)
	..s PayedAmount=$p(EntFactAmountStr,"^",3)
	.Else  Do
	..s ItemGFactAmount=+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(PIOIDR,"I","")
	..s ItemFactAmountStr=##class(web.DHCPE.Report.GOEFeeDetail).GFactAmountByOrd(PIOIDR,"I","ORDITEM")
	..s PayedAmount=$p(ItemFactAmountStr,"^",3)
    .i PayedAmount'=0  d
    ..s ^DHCPETMP("IADMItemList",ItmMastDR,"PayedARCIM")=+$g(^DHCPETMP("IADMItemList",ItmMastDR,"PayedARCIM"))+1
    ..s ^DHCPETMP("IADMItemList",ItmMastDR,"PayedARCIMAmount")=+$g(^DHCPETMP("IADMItemList",ItmMastDR,"PayedARCIMAmount"))+PayedAmount

    s ARCID=0,ARCIMStr="",ARCIMDesc="",Str=""
    f  s ARCID=$o(^DHCPETMP("IADMItemList",ARCID))  q:ARCID=""  d
    .s ARCIMNum=""
    .s ARCIMDesc=$p(^ARCIM($p(ARCID,"||",1),$p(ARCID,"||",2),1),"^",2)
    .s ARCIMNum=$G(^DHCPETMP("IADMItemList",ARCID,"PayedARCIM"))
    .s ARCIMAmount=$G(^DHCPETMP("IADMItemList",ARCID,"PayedARCIMAmount"))
    .i ARCIMStr=""  S ARCIMStr=ARCIMDesc_"^"_ARCIMNum_"^"_ARCIMAmount
    .else  s ARCIMStr=ARCIMStr_"$"_ARCIMDesc_"^"_ARCIMNum_"^"_ARCIMAmount

    s PatName=PatName_"#"_"医嘱^数量^金额"
    i ARCIMStr'=""  S Str=PatName_"$"_ARCIMStr
    q Str
}

// 通过记录第一次总检日期，来统计收入

// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.FeeQuery","GetIncomeByGeneralAudit","62170","")

Query GetIncomeByGeneralAudit(DateFrom As %Library.String = "", DateTo As %Library.String = "") As %Query(ROWSPEC = "TarECDesc:%String, FaceAmount:%String")
{
}

ClassMethod GetIncomeByGeneralAuditExecute(ByRef qHandle As %Binary, DateFrom As %Library.String = "", DateTo As %Library.String = "") As %Status
{
 Set repid=$I(^CacheTemp)
 i (""=DateFrom)&&(DateTo="") {
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 }
  Set UserID=%session.Get("LOGON.USERID")
  k ^DHCPETemp("IncomeByGeneral",UserID)
  k ^DHCPEGetIncomeByIADM("OrdEntDR",UserID)

 Set repid=$I(^CacheTemp)
 s ind=1
 i DateFrom=""  s DateFrom=0
 i DateTo=""    s DateTo=+$H
 s j=0
 s Date=DateFrom-1
 f  s Date=$o(^DHCPEDataEx("DHCPEGeneralAuditDate",Date))  q:(Date="")||((DateTo'="")&&(DateTo<Date))  d 
 .s Time=0
 .f  s Time=$o(^DHCPEDataEx("DHCPEGeneralAuditDate",Date,Time))  q:Time=""  d
 ..s j=j+1  
 ..i j=1  s ^DHCPETemp("IncomeByGeneral",UserID,"FirstTime")=Date_"^"_Time
 ..s ^DHCPETemp("IncomeByGeneral",UserID,"LastTime")=Date_"^"_Time
 ..s IADMRowID=0
 ..f  s IADMRowID=$o(^DHCPEDataEx("DHCPEGeneralAuditDate",Date,Time,IADMRowID))  q:IADMRowID=""  d
 ...//q:IADMRowID="535"
 ...d ..GetIncomeByIADM(IADMRowID)


 s CatJob=$j
 s TarECID=0,num=0
 f  s TarECID=$o(^DHCPETemp("IncomeByGeneral",UserID,"FactAmount",CatJob,TarECID))  q:TarECID=""  d
 .s num=1
 .S TarECDesc=$p($G(^DHCTarC("EC",TarECID)),"^",2)
 .s FaceAmount=$g(^DHCPETemp("IncomeByGeneral",UserID,"FactAmount",CatJob,TarECID))
 .i TarECID="100"  s TarECDesc="凑整费"
 .d QueryOut   
  s FaceAmount=$G(^DHCPETemp("IncomeByGeneral",UserID,CatJob,100))
  s TarECDesc="合计："
  i num'=0 d QueryOut
  s FaceAmount=$G(^DHCPETemp("IncomeByGeneral",UserID,"IFactAmount",CatJob))
  s TarECDesc="个人:"
  i num'=0 d QueryOut
  s GADM=0
  F  S GADM=$o(^DHCPETemp("IncomeByGeneral",UserID,"GADM",CatJob,GADM))  Q:GADM=""  d
  .s PGIBI=$g(^DHCPETemp("IncomeByGeneral",UserID,"GADM",CatJob,GADM))
  .s GDesc=""
  .S GDesc=$p($g(^DHCPEGBI(PGIBI)),"^",2)
  .s TarECDesc=GDesc
  .s FaceAmount=$G(^DHCPETemp("IncomeByGeneral",UserID,"GFactAmount",CatJob,GADM))
  .d QueryOut
  
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
QueryOut      
	set Data=$lb(TarECDesc,FaceAmount)
	//s ^DHCPETemp("IncomeByGeneral",UserID,"Export",ind)=TarECDesc_"^"_FaceAmount
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetIncomeByGeneralAuditFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIncomeByGeneralAuditExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {			
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetIncomeByGeneralAuditClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIncomeByGeneralAuditExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// d ##class(web.DHCPE.Report.FeeQuery).GetIncomeByIADM("537")

ClassMethod GetIncomeByIADM(IADM)
{
    Set UserID=%session.Get("LOGON.USERID")
    s preAdmId=$P(^DHCPEIADM(IADM),"^",4)
    S GADMDR=$P(^DHCPEIADM(IADM),"^" ,2)
    i GADMDR'="" s GBaesInfo=$p($g(^DHCPEGADM(GADMDR)),"^",1)
    s CatJob=$j
    k ^DHCPEGetIncomeByIADM("OrdEntDR")
	s ChildSub=0
	f  s ChildSub=$o(^DHCPEPreIADM(preAdmId,"ORDITEM", ChildSub))  q:ChildSub=""  d
	.q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub)),"^",16)'=1 //判断是否有效
	.s LocID=$P(^DHCPEPreIADM(preAdmId),"^",26)
	.s OrdEntDR=$p(^DHCPEPreIADM(preAdmId,"ORDITEM", ChildSub),"^",2) 
	.i OrdEntDR'=""  s ^DHCPEGetIncomeByIADM("OrdEntDR",UserID,OrdEntDR)=preAdmId
	.i OrdEntDR="" d 
	..s arcitmid=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub)),"^",1)
	..s Amount=+$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub)),"^",14)
	..s CurDate=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub)),"^",12)
	..s Flag=0 
	..//q:arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee"))
	..s FSub=0
	..f  s FSub=$o(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub,"FEE",FSub))  q:FSub=""  d
	...S PAuditID=$P($G(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub,"FEE",FSub)),"^",5)
	...Q:PAuditID=""
	...s AuditType=$p(^DHCPEPreA(PAuditID),"^",1) 
	...s AuditStr=..GetPersonAuditAmount(preAdmId_"||"_ChildSub,"ORDITEM")
	...s CurFact=+$p($G(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub,"FEE",FSub)),"^",2)
	...q:CurFact=0
	...;i arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee"))  d
	...i arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee",LocID))  d
	....s ^DHCPETemp("IncomeByGeneral",UserID,"FactAmount",CatJob,"100")=+$G( ^DHCPETemp("IncomeByGeneral",UserID,"FactAmount",CatJob,"100"))+CurFact
	....i (GADMDR'="")&&(AuditType="G") d
	.....s ^DHCPETemp("IncomeByGeneral",UserID,"GFactAmount",CatJob,GADMDR)=+$g(^DHCPETemp("IncomeByGeneral",UserID,"GFactAmount",CatJob,GADMDR))+CurFact
    ....else  d
	.....s ^DHCPETemp("IncomeByGeneral",UserID,"IFactAmount",CatJob)=+$g(^DHCPETemp("IncomeByGeneral",UserID,"IFactAmount",CatJob))+CurFact
    ....s ^DHCPETemp("IncomeByGeneral",UserID,CatJob,100)=+$g(^DHCPETemp("IncomeByGeneral",UserID,CatJob,100))+CurFact 
	...q:arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee"))
	...q:arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee",LocID))
	
	...s TarItem=0
	...f  s TarItem=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem)) q:TarItem=""  d
	....s StartDate=0
	....f  s StartDate=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate)) q:(StartDate="")||(StartDate>CurDate)  d
	.....s OLTID=0
	.....f  s OLTID=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate,OLTID)) q:OLTID=""  d
	......s EndDate=$p(^DHCOLT(OLTID),"^",5)
	......q:(EndDate'="")&&(EndDate<CurDate)
	......s qty=$p(^DHCOLT(OLTID),"^",3)
	......s CurPrice=+##class(web.UDHCJFPRICE).GetItmPrice(TarItem,CurDate,"","","")  //得到当前计费项金额
	......s AddbyTwoAuditAmount=$p(AuditStr,"^",1)
	......s AuditNum=$p(AuditStr,"^",2)
	......i (Amount'=0)&&(CurPrice'=0) d
	.......s CurCatFee=(CurPrice/Amount)*CurFact*qty
	.......i +AuditNum>1 s CurAccountAmount=((AddbyTwoAuditAmount)/Amount)*CurPrice*qty
	.......else  s CurAccountAmount=CurPrice*qty
	......e  d
	.......s CurCatFee=CurFact
	......//w !,arcitmid_"^"_TarItem_"^"_CurCatFee
	......s OneInfo=..GetTarEC(TarItem)
	......//w !,arcitmid_"^"_TarItem_"^"_CurCatFee_"^"_OneInfo
	......s ^DHCPETemp("IncomeByGeneral",UserID,"FactAmount",CatJob,$p(OneInfo,"^",1))=+$g(^DHCPETemp("IncomeByGeneral",UserID,"FactAmount",CatJob,$p(OneInfo,"^",1)))+CurCatFee
	......//s ^zl("IncomeByGeneral","FactAmount",CatJob,$p(OneInfo,"^",1))=+$g(^zl("IncomeByGeneral","FactAmount",CatJob,$p(OneInfo,"^",1)))+CurCatFee
	......s ^DHCPETemp("IncomeByGeneral",UserID,CatJob,100)=+$g(^DHCPETemp("IncomeByGeneral",UserID,CatJob,100))+CurCatFee        
	......i (GADMDR'="")&&(AuditType="G") d
	.......s ^DHCPETemp("IncomeByGeneral",UserID,"GADM",CatJob,GADMDR)=GBaesInfo
	.......s ^DHCPETemp("IncomeByGeneral",UserID,"GFactAmount",CatJob,GADMDR)=+$g(^DHCPETemp("IncomeByGeneral",UserID,"GFactAmount",CatJob,GADMDR))+CurCatFee
    ......else  d
	.......s ^DHCPETemp("IncomeByGeneral",UserID,"IFactAmount",CatJob)=+$g(^DHCPETemp("IncomeByGeneral",UserID,"IFactAmount",CatJob))+CurCatFee
	..;q:arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee"))
	..q:arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee",LocID))
		
		s PIOIOrdEntDR=0
		f  s PIOIOrdEntDR=$o(^DHCPEGetIncomeByIADM("OrdEntDR",UserID,PIOIOrdEntDR))  q:PIOIOrdEntDR=""  d
		.s preAdmId=$p(PIOIOrdEntDR,"||",1)
		.s childsub=$p(PIOIOrdEntDR,"||",2)
		.s LocID=$P(^DHCPEPreIADM(preAdmId),"^",26)
		.q:$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",9)'=1	//判断是否有效
		.s Amount=+$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",7)
		.s CurDate=$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",4)
		.s EFSub=0
		.f  s EFSub=$o(^DHCPEPreIADM(preAdmId,"ORDENT",childsub,"FEE",EFSub)) q:EFSub=""  d 
		..s CurFact=+$p($G(^DHCPEPreIADM(preAdmId,"ORDENT",childsub,"FEE",EFSub)),"^",2)
		..S PAuditID=$P($G(^DHCPEPreIADM(preAdmId,"ORDENT",childsub,"FEE",EFSub)),"^",5)
		..Q:PAuditID=""
		..s AuditType=$p(^DHCPEPreA(PAuditID),"^",1)
	    ..s AuditStr=..GetPersonAuditAmount(PIOIOrdEntDR,"ORDENT")
		..q:CurFact=0
		..s ItemSub=0
		..f  s ItemSub=$o(^DHCPEPreIADM(0,"OrdEnt",preAdmId_"||"_childsub,preAdmId,ItemSub)) q:ItemSub=""  d
		...s arcitmid=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ItemSub)),"^",1)
	    ...q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ItemSub)),"^",16)'=1 //判断是否有效
		...s ItemAmount=+$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ItemSub)),"^",14)
		...q:ItemAmount=0
		...;i arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee"))  d
		...i arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee",LocID)) d
	    ....s ^DHCPETemp("IncomeByGeneral",UserID,"FactAmount",CatJob,"100")=+$G( ^DHCPETemp("IncomeByGeneral",UserID,"FactAmount",CatJob,"100"))+ItemAmount
	    ....i (GADMDR'="")&&(AuditType="G") d
	    .....s ^DHCPETemp("IncomeByGeneral",UserID,"GFactAmount",CatJob,GADMDR)=+$g(^DHCPETemp("IncomeByGeneral",UserID,"GFactAmount",CatJob,GADMDR))+ItemAmount
        ....else  d
	    .....s ^DHCPETemp("IncomeByGeneral",UserID,"IFactAmount",CatJob)=+$g(^DHCPETemp("IncomeByGeneral",UserID,"IFactAmount",CatJob))+ItemAmount
	    ....s ^DHCPETemp("IncomeByGeneral",UserID,CatJob,100)=+$g(^DHCPETemp("IncomeByGeneral",UserID,CatJob,100))+ItemAmount 
	    ...;q:arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee"))
	    ...q:arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee",LocID))
		...s TarItem=0
		...f  s TarItem=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem)) q:TarItem=""  d
		....s StartDate=0
		....f  s StartDate=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate)) q:(StartDate="")||(StartDate>CurDate)  d
		.....s OLTID=0
		.....f  s OLTID=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate,OLTID)) q:OLTID=""  d
		......s EndDate=$p(^DHCOLT(OLTID),"^",5)
		......q:(EndDate'="")&&(EndDate<CurDate)
		......s qty=$p(^DHCOLT(OLTID),"^",3)
		......s CurPrice=##class(web.UDHCJFPRICE).GetItmPrice(TarItem,CurDate,"","","")   //得到当前计费项金额
		......s AddbyTwoAuditAmount=$p(AuditStr,"^",1)
		......s AuditNum=$p(AuditStr,"^",2)
		......i Amount'=0 d
		.......s CurCatFee=(CurPrice/Amount)*CurFact*qty
		.......i +AuditNum>1 s CurAccountAmount=((AddbyTwoAuditAmount)/Amount)*CurPrice*qty
		.......else  s CurAccountAmount=CurPrice*qty
		......e  d
	    .......s CurCatFee=CurFact
	    ......s OneInfo=..GetTarEC(TarItem)
	    ......s ^DHCPETemp("IncomeByGeneral",UserID,CatJob,$p(OneInfo,"^",1))=$p(OneInfo,"^",2)
	    ......s ^DHCPETemp("IncomeByGeneral",UserID,"FactAmount",CatJob,$p(OneInfo,"^",1))=+$g(^DHCPETemp("IncomeByGeneral",UserID,"FactAmount",CatJob,$p(OneInfo,"^",1)))+CurCatFee
	    ......s ^DHCPETemp("IncomeByGeneral",UserID,CatJob,100)=+$g(^DHCPETemp("IncomeByGeneral",UserID,CatJob,100))+CurCatFee 
	    ......i (GADMDR'="")&&(AuditType="G") d
	    .......s ^DHCPETemp("IncomeByGeneral",UserID,"GADM",CatJob,GADMDR)=GBaesInfo
	    .......s ^DHCPETemp("IncomeByGeneral",UserID,"GFactAmount",CatJob,GADMDR)=+$g(^DHCPETemp("IncomeByGeneral",UserID,"GFactAmount",CatJob,GADMDR))+CurCatFee
        ......else  d
	    .......s ^DHCPETemp("IncomeByGeneral",UserID,"IFactAmount",CatJob)=+$g(^DHCPETemp("IncomeByGeneral",UserID,"IFactAmount",CatJob))+CurCatFee
}

ClassMethod ExportInfo() As %Status
{
	s LastTime="",FirstTime=""
	s UserID=%session.Get("LOGON.USERID")
 	s LastTime=$p($g(^DHCPETemp("IncomeByGeneral",UserID,"LastTime")),"^",2)
 	i LastTime'=""  s LastTime=$zt(LastTime)
 	s FirstTime=$p($g(^DHCPETemp("IncomeByGeneral",UserID,"FirstTime")),"^",2)
 	i FirstTime'=""  s FirstTime=$zt(FirstTime)
	Q FirstTime_"^"_LastTime
}

// d ##class(web.DHCPE.Report.FeeQuery).SetGeneralFirstDate()

ClassMethod SetGeneralFirstDate() As %Status
{
	s GSRowId=0
	f  s GSRowId=$o(^DHCPEGS(GSRowId))  q:GSRowId=""  d
	.s GSAuditDate=$p($G(^DHCPEGS(GSRowId,1)),"^",6)
	.s IAdm=$p($G(^DHCPEGS(GSRowId,1)),"^",1)
	.s GSAuditTime=$p($G(^DHCPEGS(GSRowId,1)),"^",1)
	.s GSAuditUserDR=$p($G(^DHCPEGS(GSRowId,1)),"^",5)
	.i GSAuditDate'=""  d
	..s ^DHCPEDataEx("DHCPEGeneralAuditIADM",IAdm)=1
	..s ^DHCPEDataEx("DHCPEGeneralAuditDate",GSAuditDate,GSAuditTime,IAdm)=GSAuditUserDR
}

}
