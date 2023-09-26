Import SQLUser

/// 体检综合查询
Class web.DHCPE.Report.PEPersonStatistic Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right ]
{

Parameter BUILD = 601;

/// 应收金额	:	体检费用 - 客户体检项目的总金额
/// 优惠金额	:	抹零金额 - 收费时对客户进行优惠产生的金额
/// 实际金额	:	实际金额 - 总金额减去抹零金额最后收 客户的钱数
/// 已收金额	:	
/// 未收金额	:	
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.PEPersonStatistic","PEPersonStatistic","","","","2","","","^NA^NoAudit^UNCHECKED^","","")
Query PEPersonStatistic(RegNo As %Library.String = "", Name As %Library.String = "", PEBeginDate As %Library.String = "", PEEndDate As %Library.String = "", GDR As %Library.String = "", GDesc As %Library.String = "", SalerDR As %Library.String = "", Status As %Library.String = "", FactAmountBegin As %Library.String = "", FactAmountEnd As %Library.String = "", TeamDR As %Library.String = "", DepName As %Library.String = "", SexDR As %Library.String = "", VIPLevel As %String = "", ReCheck As %String = "", IFSTSF As %String = "", SessionStr As %String = "") As %Query(ROWSPEC = "PA_ADMDR:%String, PA_RegNo:%String, PA_Name:%String, PA_ADMNo:%String, PA_AdmDate:%String, PA_Status:%String, PA_AccountAmount:%String, PA_DiscountedAmount:%String, PA_FinalAmount:%String, PA_Payed:%String, PA_UnPayed:%String, PA_Company:%String, PA_GDesc:%String, PA_Saler:%String,PA_PartName:%String,PA_TeamName:%String,PA_Sex:%String,TIND:%String,TVIPLevel:%String,PIADM_RowId:%String,PIADM_ItemList:%String,PGBI_Tel1:%String,TIFSTSF:%String,TPEID:%String,TPrtFlag:%String,TBLPrtFlag:%String,TRoundFee:%String,TAge:%String,GAmount:%String,IAmount:%String,TCardDesc:%String,TIDCard:%String")
{
}

ClassMethod PEPersonStatisticExecute(ByRef qHandle As %Binary, RegNo As %Library.String = "", Name As %Library.String = "", PEBeginDate As %Library.String = "", PEEndDate As %Library.String = "", GDR As %Library.String = "", GDesc As %Library.String = "", SalerDR As %Library.String = "", Status As %Library.String = "", FactAmountBegin As %Library.String = "", FactAmountEnd As %Library.String = "", TeamDR As %Library.String = "", DepName As %Library.String = "", SexDR As %Library.String = "", VIPLevel As %String = "", ReCheck As %String = "", IFSTSF As %String = "", SessionStr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	if ((""=RegNo)&(""=Name)&(""=PEBeginDate)&(""=PEEndDate)&(""=GDR)&(""=GDesc)&(""=SalerDR)&(""=Status)&(""=FactAmountBegin)&(""=FactAmountEnd)&(""=DepName)){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s ^TMP("DHCPE","PEPersonStatistic")=$lb(RegNo,Name,PEBeginDate,PEEndDate,GDR,GDesc,SalerDR,Status,FactAmountBegin,FactAmountEnd,TeamDR,DepName,SexDR,VIPLevel,ReCheck,IFSTSF,SessionStr)
 	
 	i PEBeginDate'="" s PEBeginDate=##class(websys.Conversions).DateHtmlToLogical(PEBeginDate)
 	i PEEndDate'=""   s PEEndDate=##class(websys.Conversions).DateHtmlToLogical(PEEndDate)
 	
 	s User=$p(SessionStr,"^",1)
    s HospID=$p(SessionStr,"^",3)
 	
 	k ^DHCPETMPPA(User)
 
	s ind=2
	s ordentdesc="",telno="",paadmId=""
 	s TBLPrtFlag="N"
 	
 	s AsType=$P(IFSTSF,"^",2)
 	s IFSTSF=$P(IFSTSF,"^",1)
 	
	s ChargeStatus=$P(ReCheck,"^",2)
	s ReCheck=$P(ReCheck,"^",1)
	
	i Name'="" s Name=$$ALPHAUP^SSUTIL4(Name)
	
	if RegNo'=""
	{
		s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
		s BaseInfo=$O(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
		i BaseInfo'=""
		{
			s PIADM=""
			f  s PIADM=$O(^DHCPEPreIADM(0,"PIBI",BaseInfo,PIADM)) q:PIADM=""  d
			.s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
			.q:IADM=""
			.s id=IADM
			.d OneInfo
		}
	}
	elseif Name'=""
	{
		
		s PreName=$O(^DHCPEPreIBI(0,"Name",Name),-1)
		f  s PreName=$O(^DHCPEPreIBI(0,"Name",PreName)) q:(PreName="")||(PreName'[Name)  d
		.s BaseInfo=0
		.f  s BaseInfo=$O(^DHCPEPreIBI(0,"Name",PreName,BaseInfo)) q:(BaseInfo="")  d
		..s PIADM=""
		..f  s PIADM=$O(^DHCPEPreIADM(0,"PIBI",BaseInfo,PIADM)) q:PIADM=""  d
		...s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
		...q:IADM=""
		...s id=IADM
		...d OneInfo
	}
	elseif (+GDR'=0) 
	{
		
		s TeamID=""
		f  s TeamID=$O(^DHCPEIADM(0,"GADM",GDR,TeamID)) q:TeamID=""  d
		.s IADM=""
		.f  s IADM=$O(^DHCPEIADM(0,"GADM",GDR,TeamID,IADM)) q:IADM=""  d
		..s id=IADM
		..d OneInfo
	}
	else
	{
		i PEBeginDate="" s PEBeginDate=1
		i PEEndDate="" s PEEndDate=+$H
		s AdmDate=PEBeginDate-1
		f  s AdmDate=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate)) q:(AdmDate="")||(AdmDate>PEEndDate)  d
		.s Time=""
		.f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate,Time)) q:(Time="")  d
		..s IADM=0
		..f  s IADM=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate,Time,IADM)) q:(IADM="")  d
		...s id=IADM
		...d OneInfo
	}
	s ind=1   
	//s paadmId=0
	s paadmId=""
	s PIBIPAPMINo=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepersonstatistic.hisui.csp","合计：")_(+$G(^DHCPETMPPA(User,"PEPersonStatistic","Person","Total")))_"人"
	s PIADMPIBIDRName=""
	s SexName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepersonstatistic.hisui.csp","女")_(+$G(^DHCPETMPPA(User,"PEPersonStatistic","Person","Sex",2)))_##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepersonstatistic.hisui.csp","人；男")_(+$G(^DHCPETMPPA(User,"PEPersonStatistic","Person","Sex",1)))_##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepersonstatistic.hisui.csp","人")
	s PAADMNo=""
	s IADMAdmDate=""
	s IADMStatusDesc=""
	s AccountAmount=+$G(^DHCPETMPPA(User,"PEPersonStatistic","AccountAmount","Total"))
	s FactAmount=+$G(^DHCPETMPPA(User,"PEPersonStatistic","FactAmount","Total"))
	s FinalAmount=+$G(^DHCPETMPPA(User,"PEPersonStatistic","FinalAmount","Total"))
	s Payed=+$G(^DHCPETMPPA(User,"PEPersonStatistic","Payed","Total"))
	s UnPayed=+$G(^DHCPETMPPA(User,"PEPersonStatistic","UnPayed","Total"))
	s GAmount=+$g(^DHCPETMPPA(User,"PEPersonStatistic","GAmount","Total"))
	s IAmount=+$g(^DHCPETMPPA(User,"PEPersonStatistic","IAmount","Total"))

	
	s ^DHCPETMPPA(User,"PEPersonStatistic","total")=PIBIPAPMINo_"^"_PIADMPIBIDRName_"^"_" "_"^"_" "_"^"_" "_"^"_" "_"^"_" "_"^"_" "_"^"_$FN(AccountAmount,"",2)_"^"_$FN(FactAmount,"",2)_"^"_$FN(FinalAmount,"",2)_"^"_$FN(GAmount,"",2)_"^"_$FN(IAmount,"",2)_"^"_$FN(Payed,"",2)_"^"_$FN(UnPayed,"",2)_"^"_" "_"^"_" "_"^"_" "_"^"_" "
	s PIBICompany=""
	s GName=""
	s PIADMSalesName=""
	s Position=""
	s TeamName=""
	s TAge=""
    s RoundInfoFee=$fn($G(^DHCPETMPPA(User,"PEPersonStatistic","RoundFee","Total")),"",2)
	s TVIPLevel=""
	s TBLPrtFlag="N"
	s (ordentdesc,telno,TIFSTSF,TPEID,IADMCRMADM,TPrtFlag,PACCardDesc,PIBIIDCard)=""
    d PEPersonStatisticOut
    
 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OneInfo
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",id)
	q:LocFlag="1"
	s CurData=$g(^DHCPEIADM(id))
	s IADMCRMADM=$p(CurData,"^",4)  // DHC_PE_PREIADM
	Q:(""=IADMCRMADM)
	s PAADM=$p(CurData,"^",1)
	s ADMLocID=$P($g(^DHCPEPreIADM(IADMCRMADM)),"^",26) //就诊科室ID
	s TPrtFlag="N"
	s TPrtFlag=$D(^DHCPESpecialReportPrintRecord(PAADM, "DHCPEPISRequest"))
	s:TPrtFlag'=0 TPrtFlag="Y"
	s ordentdesc=##class(web.DHCPE.Query.IAdmItemStatus).GetArcSetDesc(IADMCRMADM)  ;获取套餐名
	s ReCheckFlag=$P(^DHCPEPreIADM(IADMCRMADM),"^",28)
	i ReCheckFlag="Y" s ReCheckFlag="1"
	e  s ReCheckFlag="0"
	q:(ReCheck'="")&&(ReCheckFlag'=ReCheck)
	s PIADMPIBIDR=""
	i IADMCRMADM'=""  s PIADMPIBIDR=$p($g(^DHCPEPreIADM(IADMCRMADM)),"^",1)
	s TPEID=$p($g(^DHCPEPreIADM(IADMCRMADM)),"^",27)
	s TIFSTSF=$p($g(^DHCPEPreIADM(IADMCRMADM)),"^",9)
	s AsTypeInfo=$G(^DHCPEDataEx("AsCharged","I",IADMCRMADM))
	s CAsType=$P(AsTypeInfo,"^",1)
	q:((IFSTSF="0")&&(TIFSTSF'="N"))
	q:((IFSTSF="1")&&((TIFSTSF'="Y")||((AsType'="")&&(AsType'=CAsType))))
	i TIFSTSF="Y" s TIFSTSF="是"
	e  s TIFSTSF="否"
	s GBINFO=$g(^DHCPEPreIBI(PIADMPIBIDR))
	s telno=""
	s:($p($g(GBINFO),"^",7)'="") telno=$p($g(GBINFO),"^",7)
	s:($p($g(GBINFO),"^",6)'="") telno=$p($g(GBINFO),"^",6)
	s:($p($g(GBINFO),"^",8)'="") telno=$p($g(GBINFO),"^",8)
	s telno=##class(web.DHCPE.PreCommon).GetTelNo("PIBI",PIADMPIBIDR)
	s PIBIPAPMINo=""	                   //防止取到空数据
	i ""'=PIADMPIBIDR  s PIBIPAPMINo=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",1)   // PIBI_PAPMINo 登记号 DHC_PE_PreIBaseInfo 1.1    
    i ""'=RegNo  s RegNo=$Extract("00000000",1,8-$LENGTH(RegNo))_RegNo
    Q:(""'=RegNo)&(RegNo'=PIBIPAPMINo) //数据过滤
    i PIADMPIBIDR'=""  s PIBICompany=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",12) 
    
	s PIADMPIBIDRName="",PIADMPIBIDRNameU=""
	s Position="",SexName=""
	i ""'=PIADMPIBIDR  d
	.s PIADMPIBIDRName=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",2)
	.s Position=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",11)          //部门
	.s SexID=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",3)
    .i SexID'=""   s SexName=$p(^CT("SEX",SexID),"^",2)
    
    s PIADMPIBIDRNameU=$$ALPHAUP^SSUTIL4(PIADMPIBIDRName)
	Q:(""'=Name)&('(PIADMPIBIDRNameU[Name))
    Q:(""'=SexDR)&(SexID'=SexDR)
    s TAge=##class(web.DHCPE.DHCPECommon).GetPapmiAge($O(^PAPERi("PAPMI_PatNo",PIBIPAPMINo,0)),HospID)
    
    //证件类型 证件号
    s PIBIIDCard="",PACCardDesc="",PACCardTypeDR=""
	S PACCardTypeDR=$P($G(^PAPER($o(^PAPERi("PAPMI_PatNo",PIBIPAPMINo,0)),"PAT",3)),"^",7)
	I PACCardTypeDR'=""  S PACCardDesc=$p($g(^PAC("CARD",PACCardTypeDR)),"^",2)
	s PIBIIDCard=$P($G(^PAPER($o(^PAPERi("PAPMI_PatNo",PIBIPAPMINo,0)),"PAT",3)),"^",6)

    // 按业务员查询
    s PIADMSalesName=""
    s CurSalerDR=""
	i IADMCRMADM'=""  s CurSalerDR=$p($g(^DHCPEPreIADM(IADMCRMADM)),"^",24)
	Q:(""'=SalerDR)&(SalerDR'=CurSalerDR)
	i (""'=CurSalerDR) s PIADMSalesName=$P($G(^SSU("SSUSR",CurSalerDR)),"^",2)
    s TVIPLevel=$p($g(^DHCPEPreIADM(IADMCRMADM)),"^",18)
    ;s:TVIPLevel="" TVIPLevel=$G(^DHCPEVIPLevel("VIPapprove"))
    s:TVIPLevel="" TVIPLevel=##class(web.DHCPE.CT.VIPLevel).GetDefaultVIP(ADMLocID)
    q:(VIPLevel'="")&&(VIPLevel'=TVIPLevel)
    ;s TVIPLevel=$P($G(^DHCPEVIPLevel("VIP",TVIPLevel)),"^",2)
    s TVIPLevel=$lg($g(^CT.PE.VIPLevelD(TVIPLevel)),3)
    s PGADMDR="",PTADMDR="",PGADMPGBIDR=""
    s GName="",TeamName=""
    s PGADMDR=$p(CurData,"^",2)  //对应团体的ADM
    s PTADMDR=$p(CurData,"^",3)   //对应组的ADM
    i ""'=PGADMDR      s PGADMPGBIDR=$p($g(^DHCPEGADM(PGADMDR)),"^",1)   //
    i ""'=PGADMPGBIDR  s GName=$p($g(^DHCPEGBI(PGADMPGBIDR)),"^",2)    
    i PTADMDR'="" s TeamName=##Class(web.DHCPE.DHCPEGAdm).GetGTeamDesc(PTADMDR)
    
    q:("0"'=+GDR)&(GDR'=PGADMDR) 
    q:("ALLI"=GDR)&(""'=PGADMDR)
    q:("ALLG"=GDR)&(""=PGADMDR)
    q:(DepName'="")&(Position'[DepName)
    q:(GDR'="")&(TeamDR'="")&(TeamDR'=PTADMDR)
    //q:(GDesc'="")&(GName'[GDesc)
    // IADM_AdmDate	体检日期 4
	s IADMAdmDate=$p(CurData,"^",5)
	Q:(""'=PEBeginDate)&(+PEBeginDate>+IADMAdmDate)
	Q:(""'=PEEndDate)&(+PEEndDate<+IADMAdmDate)
	Q:(IADMAdmDate<60823)
	i ""'=IADMAdmDate  s IADMAdmDate=##class(websys.Conversions).DateLogicalToHtml(IADMAdmDate)
	//登记状态
	s IADMStatus=$p(CurData,"^",8)
	Q:((IADMStatus="CANCELPE")||(IADMStatus="CANCELARRIVED"))
	
	Q:(""'=Status)&(Status'[("^"_IADMStatus_"^"))
	s IADMStatusDesc=##Class(web.DHCPE.PreCommon).TransStatus(IADMStatus)
    
    s paadmId=$p(CurData,"^",1)   //体检号
	q:(paadmId="")
	s patMatId=$p(^PAADM(paadmId),"^",1)
	s PAADMNo=$p(^PAADM(paadmId),"^",81)   
	// 应付金额^最终金额^公费金额^公费已付^公费未付^自费金额^自费已付^自费未付
	s retvalue=##Class(web.DHCPE.InvPrt).GetAdmFee(IADMCRMADM)
	Q:(""=retvalue)
	//公费金额
	S GAmount=+$P(retvalue,"^",3)
	//自费金额
	s IAmount=+$P(retvalue,"^",6)

	// 作废金额^个人终止金额^公费金额金额
	s AbortFees="0^0^0^" //##Class(web.DHCPE.InvPrt).GetAdmAbortFee(IADMCRMADM)
	// 实际金额
	s FinalAmount=+$P(retvalue,"^",2)-$P(AbortFees,"^",1)
	// 优惠金额:	凑整费/协议调整费
	//s FactAmount=..GetRoundingFee(IADMCRMADM)
	s FactAmount=+$P(retvalue,"^",1)-FinalAmount
	Q:(""'=FactAmountBegin)&(+FactAmount<+FactAmountBegin)
	Q:(""'=FactAmountEnd)&(+FactAmount>+FactAmountEnd)
	
	// 应收金额
	//s AccountAmount=FinalAmount-FactAmount-$P(AbortFees,"^",1)
	s AccountAmount=+$P(retvalue,"^",1)
	// 已收金额(终止的金额应该是已收的金额)
	//s Payed=+$P(retvalue,"^",4)-$P(AbortFees,"^",3)+$P(retvalue,"^",7)-$P(AbortFees,"^",2)
	i GName'="" d
	.s GPayed=+$P(retvalue,"^",4)-$P(AbortFees,"^",3)
	.s IPayed=+$P(retvalue,"^",7)-$P(AbortFees,"^",2)
	.s Payed="公费："_$fn(GPayed,"",2)_"，自费："_$fn(IPayed,"",2)
	e  d
	.s Payed=+$P(retvalue,"^",4)-$P(AbortFees,"^",3)+$P(retvalue,"^",7)-$P(AbortFees,"^",2)
	.s Payed=$fn(Payed,"",2)
	// 未收金额
	s UnPayed=+$P(retvalue,"^",5)+$P(retvalue,"^",8)
	
	s TBLPrtFlag=$D(^DHCPESpecialReportPrintRecord(paadmId, "DHCPEPISRequest"))
	s:TBLPrtFlag'=0 TBLPrtFlag="Y"
	s RoundFee=##class(web.DHCPE.PreItemListEx).GetRoundFee(IADMCRMADM)
	s RoundInfoFee=0
	s RoundFeeLength=$L(RoundFee,"$$")
	f i=1:1:RoundFeeLength  d
	.s OneInfo=$P(RoundFee,"$$",i)
	.s OneFee=+$P(RoundFee,"^",3)
	.s RoundInfoFee=RoundInfoFee+OneFee

	s PIADMChargedStatusDesc=##class(web.DHCPE.HandlerPreOrds).GetPaiedFlag(IADMCRMADM)
	q:(ChargeStatus'="")&&(ChargeStatus'=PIADMChargedStatusDesc)
	
	
	d PEPersonStatisticOut
	q	

PEPersonStatisticOut
    
	/***翻译 start***/
	s SexName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",SexName,"CTSEXDesc","cls")
	s PACCardDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCCredType",PACCardDesc,"CRTDesc","cls")
    s TVIPLevel=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEVIPLevel",TVIPLevel,"VLDesc","cls")
    s IADMStatusDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepersonstatistic.hisui.csp",IADMStatusDesc)
    s TIFSTSF=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepersonstatistic.hisui.csp",TIFSTSF)
    /***翻译 end***/
    
    s Data=$LB(paadmId, PIBIPAPMINo,PIADMPIBIDRName, PAADMNo, IADMAdmDate, IADMStatusDesc, $FN(AccountAmount,"",2), $FN(FactAmount,"",2), $FN(FinalAmount,"",2), Payed, $FN(UnPayed,"",2), PIBICompany, GName, PIADMSalesName,Position,TeamName,SexName,ind-1,TVIPLevel,$G(IADMCRMADM),ordentdesc,telno,TIFSTSF,TPEID,TPrtFlag,TBLPrtFlag,$j(RoundInfoFee,3,2),TAge,$FN(GAmount,"",2),$FN(IAmount,"",2),PACCardDesc,PIBIIDCard)
 	
 	i ""'=paadmId d
 	.s ^DHCPETMPPA(User,"PEPersonStatistic","Person","Total")=1+$G(^DHCPETMPPA(User,"PEPersonStatistic","Person","Total"))
 	.s ^DHCPETMPPA(User,"PEPersonStatistic","Person","Sex",SexID)=1+$G(^DHCPETMPPA(User,"PEPersonStatistic","Person","Sex",SexID))
 	.s ^DHCPETMPPA(User,"PEPersonStatistic","AccountAmount","Total")=AccountAmount+$G(^DHCPETMPPA(User,"PEPersonStatistic","AccountAmount","Total"))
 	.s ^DHCPETMPPA(User,"PEPersonStatistic","FactAmount","Total")=FactAmount+$G(^DHCPETMPPA(User,"PEPersonStatistic","FactAmount","Total"))
 	.s ^DHCPETMPPA(User,"PEPersonStatistic","FinalAmount","Total")=FinalAmount+$G(^DHCPETMPPA(User,"PEPersonStatistic","FinalAmount","Total"))
 	.s ^DHCPETMPPA(User,"PEPersonStatistic","Payed","Total")=Payed+$G(^DHCPETMPPA(User,"PEPersonStatistic","Payed","Total"))
 	.s ^DHCPETMPPA(User,"PEPersonStatistic","UnPayed","Total")=UnPayed+$G(^DHCPETMPPA(User,"PEPersonStatistic","UnPayed","Total"))
    .s ^DHCPETMPPA(User,"PEPersonStatistic","GAmount","Total")=GAmount+$G(^DHCPETMPPA(User,"PEPersonStatistic","GAmount","Total"))
 	.s ^DHCPETMPPA(User,"PEPersonStatistic","IAmount","Total")=IAmount+$G(^DHCPETMPPA(User,"PEPersonStatistic","IAmount","Total"))
    .;s ^DHCPETMPPA(User,"PEPersonStatistic","Person","List", TPEID)=PIBIPAPMINo_"^"_TPEID_"^"_PIADMPIBIDRName_"^"_$P(SexName,"(",1)_"^"_+$P(SexName,"(",2)_"^"_telno_"^"_IADMAdmDate_"^"_GName_"^"_$FN(AccountAmount,"",2)_"^"_$FN(FactAmount,"",2)_"^"_$FN(FinalAmount,"",2)_"^"_$FN(Payed,"",2)_"^"_$FN(UnPayed,"",2)_"^"_PAADMNo_"^"_PIBICompany_"^"_PIADMSalesName_"^"_Position
	.s ^DHCPETMPPA(User,"PEPersonStatistic","Person","List", ind)=PIBIPAPMINo_"^"_TPEID_"^"_PIADMPIBIDRName_"^"_SexName_"^"_TAge_"^"_telno_"^"_IADMAdmDate_"^"_GName_"^"_$FN(AccountAmount,"",2)_"^"_$FN(FactAmount,"",2)_"^"_$FN(FinalAmount,"",2)_"^"_$FN(GAmount,"",2)_"^"_$FN(IAmount,"",2)_"^"_$FN(Payed,"",2)_"^"_$FN(UnPayed,"",2)_"^"_PACCardDesc_"^"_PIBIIDCard_"^"_Position
	.s RoundFeeLength=$L(RoundFee,"$$")	
	.f i=1:1:RoundFeeLength  d
	..s OneInfo=$P(RoundFee,"$$",i)
	..s OneFee=+$P(OneInfo,"^",3)
	..s ^DHCPETMPPA(User,"PEPersonStatistic","RoundFee","Total")=+$G(^DHCPETMPPA(User,"PEPersonStatistic","RoundFee","Total"))+OneFee
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1 	
 	q
}

ClassMethod PEPersonStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PEPersonStatisticExecute ]
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

ClassMethod PEPersonStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PEPersonStatisticExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 根据preiadmid获取个人的凑整费/协议调整费信息
/// w ##Class(web.DHCPE.Report.PEPersonStatistic).GetRoundingFee(73632)
ClassMethod GetRoundingFee(preiadmid)
{
	
	s LocID=$P(^DHCPEPreIADM(preiadmid),"^",26)	
	//s RoundingFeeID=$g(^DHCPESetting("DHCPE","RoundingFee")) //凑整费对应的医嘱项
	s RoundingFeeID=$g(^DHCPESetting("DHCPE","RoundingFee",LocID)) //凑整费对应的医嘱项

	;w RoundingFeeID,!
	s RoundingFee=0
	// DHC_PE_PreIOrdItem.{ PIOI_ItmMast_DR }
	s PIOIItmMastDR=$O(^DHCPEPreIADM(0, "ItmMast", RoundingFeeID), -1)
	f  s PIOIItmMastDR=$O(^DHCPEPreIADM(0,"ItmMast",PIOIItmMastDR)) Q:(""=PIOIItmMastDR)||(PIOIItmMastDR'=RoundingFeeID)  d
	.s PIADMRowId=$O(^DHCPEPreIADM(0,"ItmMast",PIOIItmMastDR, preiadmid), -1)
	.f  s PIADMRowId=$O(^DHCPEPreIADM(0,"ItmMast",PIOIItmMastDR, PIADMRowId)) Q:(""=PIADMRowId)||(PIADMRowId'=preiadmid)  d
	..s PIOIChildSub=0
	..f  s PIOIChildSub=$O(^DHCPEPreIADM(0,"ItmMast",PIOIItmMastDR, PIADMRowId, PIOIChildSub)) Q:(""=PIOIChildSub)  d
	...s PIOIItemStat=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub)),"^",16)
	...Q:(1'=PIOIItemStat)
	...s FeeSub=$O(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub,"FEE",0))
	...q:FeeSub=""
	...s AudtiID=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub,"FEE",FeeSub)),"^",5)
	...q:AudtiID=""
	...s Status=$P(^DHCPEPreA(AudtiID),"^",21)
	...q:Status="NU"
	...
	...s AccountSum=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub)),"^",14)
	...s RoundingFee=RoundingFee+AccountSum
	
	Q RoundingFee
}

/// 导出体检综合查询数据, 使用最近一次查询出来的数据
/// d ##class(web.DHCPE.Report.PEPersonStatistic).PEPersonStatisticImport("","","")
ClassMethod PEPersonStatisticImport(itmjs As %Library.String = "", itmjsex As %Library.String = "", Instring As %Library.String = "") As %Status
{
   // s ^DHCPETMPPA("PEPersonStatistic","Person","List",^DHCPETMPPA("PEPersonStatistic","Person","Total"))=^DHCPETMPPA("PEPersonStatistic","Person","List",(^DHCPETMPPA("PEPersonStatistic","Person","Total")+1))
 	s User=%session.Get("LOGON.USERID")
 	s iLLoop=0 
 	f  s iLLoop=$O(^DHCPETMPPA(User,"PEPersonStatistic","Person","List", iLLoop)) Q:(""=iLLoop)  d
 	.s Data=$G(^DHCPETMPPA(User,"PEPersonStatistic","Person","List", iLLoop))
 	.;i iLLoop=(+$G(^DHCPETMPPA("PEPersonStatistic","Person","Total"))) 
 	.;s Data=$G(^DHCPETMPPA("PEPersonStatistic","total"))
    .
 	.i ""'=itmjs d
	..s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	..&javascript<#(retval)#>
	s Data=$G(^DHCPETMPPA(User,"PEPersonStatistic","total"))
	i ""'=itmjs d
	s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	&javascript<#(retval)#>

	Q 0
}

ClassMethod GetPEPersonStatisticImportRows(User)
{
 
 s iLLoop=0 ,Rows=0
 f  s iLLoop=$O(^DHCPETMPPA(User,"PEPersonStatistic","Person","List", iLLoop)) Q:(""=iLLoop)  d
 .s Rows=Rows+1
 q Rows_"&"_$G(^DHCPETMPPA(User,"PEPersonStatistic","total"))
}

ClassMethod GetPEPersonStatisticImportData(User, i)
{
	
	q:'$d(^DHCPETMPPA(User,"PEPersonStatistic","Person","List",i)) ""
	q $g(^DHCPETMPPA(User,"PEPersonStatistic","Person","List",i))
}

/// 查看客户的各种支付方式的支付的金额
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.PEPersonStatistic","FinalAmountPayList","381018")
Query FinalAmountPayList(ADMID As %Library.String = "") As %Query(ROWSPEC = "FAP_PayMode:%String, FAP_Amount:%String")
{
}

ClassMethod FinalAmountPayListExecute(ByRef qHandle As %Binary, ADMID As %Library.String = "") As %Status
{

 	s ind=1
 	s id=0	
	Set repid=$I(^CacheTemp)
	k ^DHCPETMP("FinalAmountPayList")
	i (0=ADMID)||(""=ADMID){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	/*
 	// DHC_PE_INVPRT.{ PRT_ROWID }
	s PRTROWID=0
	f  s PRTROWID=$O(^DHCPEINVPRT(0,"ADM",ADMID,PRTROWID)) Q:(""=PRTROWID)  d
	.//w !,PRTROWID
	.s PayModeInfo=##class(web.DHCPE.Cashier).GetPayModeInfo(PRTROWID)
	.s paymodedesc=$P(PayModeInfo,"^",2)
	.Q:(""=paymodedesc)
	.s payamount=$P(PayModeInfo,"^",3)
	.s ^DHCPETMP("FinalAmountPayList",paymodedesc)=payamount+$G(^DHCPETMP("FinalAmountPayList",paymodedesc))
	.*/
	
	s PRTROWID=0
	f  s PRTROWID=$O(^DHCPEINVPRT(0,"ADM",ADMID,PRTROWID)) Q:(""=PRTROWID)  d
	.s PayModeInfo=##class(web.DHCPE.Cashier).GetPayModeInfo(PRTROWID)
	.s paymodedescStr=$P(PayModeInfo,"%%",1)
	.s paymodeLen=$l(paymodedescStr,"&")
	.f i=1:1:paymodeLen d
	..s PayModeInfo=$P(paymodedescStr,"&",i)
	..s paymodedesc=$P(PayModeInfo,"^",2)
	..Q:(""=paymodedesc)
	..s payamount=$P(PayModeInfo,"^",3)
	..s ^DHCPETMP("FinalAmountPayList",paymodedesc)=payamount+$G(^DHCPETMP("FinalAmountPayList",paymodedesc))

	s paymode=0
	f  s paymode=$O(^DHCPETMP("FinalAmountPayList",paymode)) Q:(""=paymode)  d
	.s Data=$LB(paymode,$fn($G(^DHCPETMP("FinalAmountPayList",paymode)),"",2))
	.d FinalAmountPayListOut

 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
FinalAmountPayListOut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FinalAmountPayListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FinalAmountPayListExecute ]
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

ClassMethod FinalAmountPayListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FinalAmountPayListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod test()
{

	s GADMRowId=0
	f  s GADMRowId=$O(^DHCPEIADM(0, "GADM", GADMRowId)) q:(""=GADMRowId)  d
	.s GTeamDR=0
	.f  s GTeamDR=$O(^DHCPEIADM(0, "GADM", GADMRowId, GTeamDR)) q:(""=GTeamDR)  d
	..
	..s IADMRowId=0
	..f  s IADMRowId=$O(^DHCPEIADM(0, "GADM", GADMRowId, GTeamDR,IADMRowId)) q:(""=IADMRowId)  d
	...
	...
	...
}

///  added by xy 20131014  end  套餐表统计
/// d  w ##class(%ResultSet).RunQuery("web.DHCPE.Report.PEPersonStatistic","SearchARCOSStatic","62000","63109")
Query SearchARCOSStatic(PEBeginDate As %Library.String = "", PEEndDate As %Library.String = "", VIPLevel As %String) As %Query(ROWSPEC = "TOrdSets:%String,TTotalPerson:%String")
{
}

ClassMethod SearchARCOSStaticExecute(ByRef qHandle As %Binary, PEBeginDate As %Library.String = "", PEEndDate As %Library.String = "", VIPLevel As %String) As %Status
{
	k ^DHCPETEMPArcCosStatic
	Set repid=$I(^CacheTemp)
	s ind=2000
 	if ( (""=PEBeginDate)&(""=PEEndDate)){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	//i PEBeginDate=""  s PEBeginDate=$p($h,",",1)-30
 	//i PEEndDate=""    s PEEndDate=$p($h,",",1)
 	s totalnum=0
    f AdmDate=PEBeginDate:1:PEEndDate  d
    .s AdmTime=0
 	.f  s AdmTime=$o(^DHCPEIADM(0,"AdmDateTime",AdmDate,AdmTime)) q:AdmTime=""  d
 	..s id=0  //不能使用空字符串开始 s id="" ,否则会取到 0
 	..f  s id=$o(^DHCPEIADM(0,"AdmDateTime",AdmDate,AdmTime,id)) q:id=""  d
	...s CurData=$g(^DHCPEIADM(id))
    ...s IADMStatus=$p(CurData,"^",8)
	...Q:(IADMStatus'="ARRIVED") //体检状态过滤
	...s IADMCRMADM=$p(CurData,"^",4) // DHC_PE_PreIADM
	...
	...s PIADMVIP = ##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",IADMCRMADM)
	...s TVIPlevel=$P(PIADMVIP,"^",1)
	...q:(VIPLevel'="")&&(VIPLevel'=TVIPlevel)
	...s PIADMVIP=$P(PIADMVIP,"^",2)
	...
    ...s PIOESub=0
    ...f  s PIOESub=$o(^DHCPEPreIADM(IADMCRMADM,"ORDENT", PIOESub))  q:PIOESub=""  d
    ....s OrderSetsDR=$p($g(^DHCPEPreIADM(IADMCRMADM,"ORDENT", PIOESub)),"^",1)
    ....s OEItemStat=$p($g(^DHCPEPreIADM(IADMCRMADM,"ORDENT", PIOESub)),"^",9)
    ....Q:OEItemStat'=1 //医嘱套状态过滤
    ....S ARCOSDesc=$P($g(^ARCOS(OrderSetsDR)),"^",2)
    ....;b ;222
    ....s ^DHCPETEMPArcCosStatic("ArcCosStatic", ARCOSDesc)=ARCOSDesc
    ....s num=0
    ....s totalnum=totalnum+1
    ....i $d(^DHCPETEMPArcCosStatic("ArcCosStatic", ARCOSDesc))  d
    .....;s num=num+1
    .....s num=$g(^DHCPETEMPArcCosStatic("ArcCosStatic", ARCOSDesc,"Total"))
    .....s num=num+1
    .....s ^DHCPETEMPArcCosStatic("ArcCosStatic", ARCOSDesc,"Total")= num
    ....e  s ^DHCPETEMPArcCosStatic("ArcCosStatic", ARCOSDesc,"Total")=1
	....s ^DHCPETEMPArcCosStatic("Total")=totalnum
	
    s ARCOSDesc=0
    f  s ARCOSDesc=$O(^DHCPETEMPArcCosStatic("ArcCosStatic", ARCOSDesc))  Q:ARCOSDesc=""  d
    .S ARCOSDesc=$g(^DHCPETEMPArcCosStatic("ArcCosStatic", ARCOSDesc))
    .s TotalPerson=$g(^DHCPETEMPArcCosStatic("ArcCosStatic", ARCOSDesc,"Total"))
    .;b ;ddd
    .d GetArcCosStaticOut
     s ind=1
    s ARCOSDesc="共计:"
    s TotalPerson=$G(^DHCPETEMPArcCosStatic("Total"))
    d GetArcCosStaticOut
    
    Set qHandle=$lb(0,repid,0)
    q $$$OK
    
GetArcCosStaticOut
   s Data=$LB(ARCOSDesc,TotalPerson_"人")
   Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1

 q
}

ClassMethod SearchARCOSStaticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchARCOSStaticExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {			
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchARCOSStaticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchARCOSStaticExecute ]
{
   Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OutPrivewButton(PID)
{
	;d ##class(web.DHCPE.Report.PEPersonStatistic).OutPrivewButton(PID)
	i PID="" q ""
	s PID=$O(^DHCPEIADM(0,"CRMADM",PID,0))
	i PID="" q ""
	s PAADM=$P(^DHCPEIADM(PID),"^",1)
	;q:PAADM="" ""
	i PAADM="" q ""
	w "<button id='"_PAADM_"' onclick = PatItemPrintXH(this)>指引单预览</button>"
}

}
