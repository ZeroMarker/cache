Import SQLUser

Class web.DHCPE.PreGADM Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 310;

/// d ##class(%ResultSet).RunQuery("web.DHCPE.PreGADM","SearchPreGADM")
Query SearchPreGADM(Code As %String = "", Name As %String = "", BookDateBegin As %String = "", BookDateEnd As %String = "", BookTime As %String = "", Status As %String = "", ChargeStatus As %String = "", ReportGroup As %String = "0", BeginDate As %String = "", EndDate As %String = "", RFind As %String = "0", RegDateFrom As %String = "", RegDateTo As %String = "", PersonNum As %String = "", ContractID As %String = "", PGBID As %String = "") As %Query(ROWSPEC = "PGADM_RowId:%String, PGADM_PGBI_DR:%String, PGADM_PGBI_DR_Code:%String, PGADM_PGBI_DR_Name:%String, PGADM_AsCharged:%String, PGADM_BookDateBegin:%String, PGADM_BookDateEnd:%String, PGADM_BookTime:%String, PGADM_Remark:%String, PGADM_ContractNo:%String, PGADM_Status:%String, PGADM_Status_Desc:%String, PGADM_AccountAmount:%String, PGADM_DiscountedAmount:%String, PGADM_FactAmount:%String, PGADM_AuditUser_DR:%String, PGADM_AuditUser_DR_Name:%String, PGADM_AuditDate:%String, PGADM_UpdateUser_DR:%String, PGADM_UpdateUser_DR_Name:%String, PGADM_UpdateDate:%String, PGADM_PEDeskClerk_DR:%String, PGADM_PEDeskClerk_DR_Name:%String, PGADM_SaleAmount:%String, PGADM_ChargedStatus:%String, PGADM_ChargedStatus_Desc:%String, PGADM_CheckedStatus:%String, PGADM_CheckedStatus_Desc:%String, PGADM_AddOrdItem:%String, PGADM_AddOrdItemLimit:%String, PGADM_AddOrdItemAmount:%String, PGADM_AddPhcItem:%String, PGADM_AddPhcItemLimit:%String, PGADM_AddPhcItemAmount:%String, PGADM_GReportSend:%String, PGADM_GReportSend_Name:%String, PGADM_IReportSend:%String, PGADM_IReportSend_Name:%String, PGADM_DisChargedMode:%String, PGADM_DisChargedMode_Name:%String,PGADMDelayDate:%String,TTotalPerson:%String,TGetReportDate:%String,TType:%String,TPayType:%String,TRegNo:%String,PGBI_Linkman1:%String,PGBI_Tel1:%String,PGADM_CompleteStatus:%String,TConfirmAddOrdItemPerson:%String,TGroupCode:%String,TContract:%String,THomeGroup:%String,TMark:%String,TPGADMHPCode:%String,TType:%String,GTotalAmont:%String,GIAmountTotal:%String,GGAmountTotal:%String")
{
}

ClassMethod SearchPreGADMExecute(ByRef qHandle As %Binary, Code As %String = "", Name As %String = "", BookDateBegin As %String = "", BookDateEnd As %String = "", BookTime As %String = "", Status As %String = "", ChargeStatus As %String = "", ReportGroup As %String = "0", BeginDate As %String = "", EndDate As %String = "", RFind As %String = "0", RegDateFrom As %String = "", RegDateTo As %String = "", PersonNum As %String = "", ContractID As %String = "", PGBID As %String = "") As %Status
{
    k ^gdy
    Set repid=$I(^CacheTemp)
    
    i BookDateBegin'="" s BookDateBegin=##class(websys.Conversions).DateHtmlToLogical(BookDateBegin)
    i BookDateEnd'="" s BookDateEnd=##class(websys.Conversions).DateHtmlToLogical(BookDateEnd)
    i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
    i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    i RegDateFrom'="" s RegDateFrom=##class(websys.Conversions).DateHtmlToLogical(RegDateFrom)
    i RegDateTo'="" s RegDateTo=##class(websys.Conversions).DateHtmlToLogical(RegDateTo)

    //i EndDate="" s EndDate=+$h
    s Name=##class(web.DHCPE.DHCPECommon).UnEscape(Name)
    //i RFind'=1 s BeginDate=+$H-10
    s LPerson=$P(PersonNum,"-",1)
    s:LPerson="" LPerson=-1
    s TPerson=$P(PersonNum,"-",2)
    s:TPerson="" TPerson=9999999999
    s ind=1

    if ContractID'="" d
    .s id=""
    .f  s id=$O(^DHCPEPreGADM(0,"Contract",ContractID,id)) q:id=""  d
    ..d PreGADMInfo
    else  if (RegDateFrom'="")||(RegDateTo'="")  d
    .i RegDateTo="" s RegDateTo=+$H
    .i RegDateFrom=""  s RegDateFrom=RegDateTo-90
    .s AdmDate=RegDateTo+1
    .f  s AdmDate=$o(^DHCPEGADM(0,"AdmDateTime",AdmDate),-1) q:(AdmDate<+RegDateFrom)||(AdmDate="")  d
    ..s Time=0
    ..f  s Time=$o(^DHCPEGADM(0,"AdmDateTime",AdmDate,Time)) q:Time=""  d
    ...s GADM=0
    ...f  s GADM=$o(^DHCPEGADM(0,"AdmDateTime",AdmDate,Time,GADM)) q:GADM=""  d
    ....s id=$p(^DHCPEGADM(GADM),"^",2)
    ....q:id=""
    ....d PreGADMInfo
    else  if (Name'="")  d
    .s NameIndex=$O(^DHCPEPreGBI(0,"Desc",Name),-1)
    .f  s NameIndex=$O(^DHCPEPreGBI(0,"Desc",NameIndex)) q:(NameIndex="")||(NameIndex'[Name)  d
    ..s PGBID=0
    ..f  s PGBID=$O(^DHCPEPreGBI(0,"Desc",NameIndex,PGBID)) q:(PGBID="")  d
    ...s id=""
    ...f  s id=$O(^DHCPEPreGADM(0,"PGBI",PGBID,id)) q:(id="")||(id=0)  d
    ....d PreGADMInfo
    else  if (PGBID'="") d
    .s id=""
    .f  s id=$O(^DHCPEPreGADM(0,"PGBI",PGBID,id)) q:(id="")||(id=0)  d
    ..d PreGADMInfo
    else  d
    .s id=""    
    .f  s id=$o(^DHCPEPreGADM(id),-1) q:(id="")||(id=0)  d
    ..d PreGADMInfo
    
    ;w "共有团体"_(ind-1)_"个"
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
PreGADMInfo
    s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PGADM",id)          //add 2009-07-07 
    q:LocFlag=1 
    s DateBegin=$p($g(^DHCPEPreGADM(id)),"^",2)             //Add
    s DateEnd=$p($g(^DHCPEPreGADM(id)),"^",3)               //Add
    
    q:((BeginDate'="")&(DateBegin<BeginDate))||((EndDate'="")&(DateEnd>EndDate))  //Add
    
    s (PGADMPGBIDR, PGADMPGBIDRCode, PGADMPGBIDRName, PGADMAsCharged, PGADMBookDateBegin, PGADMBookDateEnd, PGADMBookTime, PGADMRemark, PGADMContractNo, PGADMStatus, PGADMStatusDesc, PGADMAccountAmount, PGADMDiscountedAmount, PGADMFactAmount, PGADMAuditUserDR, PGADMAuditUserDRName, PGADMAuditDate, PGADMUpdateUserDR, PGADMUpdateUserDRName, PGADMUpdateDate, PGADMPEDeskClerkDR, PGADMPEDeskClerkDRName, PGADMSaleAmount, PGADMChargedStatus, PGADMChargedStatusName, PGADMCheckedStatus, PGADMCheckedStatusName, PGADMAddOrdItem, PGADMAddOrdItemLimit, PGADMAddOrdItemAmount, PGADMAddPhcItem, PGADMAddPhcItemLimit, PGADMAddPhcItemAmount, PGADMGReportSend, PGADMGReportSendName, PGADMIReportSend, PGADMIReportSendName, PGADMDisChargedMode, PGADMDisChargedModeName,PGADMDelayDate,GRegNo)=""
    s CurData=$g(^DHCPEPreGADM(id))
    

    Q:(""=CurData)
    // PGADM_Status 登记状态 7
    s PGADMStatus=$p(CurData,"^",6)
    
    s LocID=$p($G(^DHCPEPreGADM(id)),"^",23)
    //q:(($G(^DHCPESetting("DHCPE","HospitalCode"))="SYYD")&&(PGADMStatus="CANCELPE"))
    q:(($G(^DHCPESetting("DHCPE","HospitalCode",LocID))="SYYD")&&(PGADMStatus="CANCELPE"))

    Quit:((PGADMStatus="CANCELPREREG")||(PGADMStatus="CANCELPE"))&(Status="")
    
    Q:(""'=Status)&&(0=##class(web.DHCPE.PreAudit).StringIsInStrs(Status,PGADMStatus))
    
    s:(""'=PGADMStatus) PGADMStatusDesc=##Class(web.DHCPE.PreCommon).TransStatus(PGADMStatus)
    s:(""=PGADMStatus) PGADMStatusDesc=""
    s PESystemStartDate=##class(web.DHCPE.Public.Setting).GetPESystemStartDate()
    q:$P(CurData,"^",20)<PESystemStartDate
    s iLLoop=1
    // PGADM_PGBI_DR    预团体客户 RowId 1
    s PGADMPGBIDR=$p(CurData,"^",iLLoop)
    i ""'=PGADMPGBIDR d
    .// DHC_PE_PreGBaseInfo
    .s PGADMPGBIDRCode=$p($g(^DHCPEPreGBI(PGADMPGBIDR)),"^",1)
    .s PGADMPGBIDRName=$p($g(^DHCPEPreGBI(PGADMPGBIDR)),"^",2)
    .s PGBILinkman1=$p($g(^DHCPEPreGBI(PGADMPGBIDR)),"^",5)   //联系人       //Add
    .s PGBITel1=$p($g(^DHCPEPreGBI(PGADMPGBIDR)),"^",8)       //联系人电话   //Add
    .s GRegNo=$p($g(^DHCPEPreGBI(PGADMPGBIDR)),"^",13)
    e  d
    .s PGADMPGBIDRCode=""
    .s PGADMPGBIDRName=""
    Q:(""'=Code)&(Code'=PGADMPGBIDRCode)
    Q:(""'=Name)&('(PGADMPGBIDRName[Name))
    s iLLoop=iLLoop+1
    // PGADM_BookDateBegin  预约体检日期 3
    s PGADMBookDateBegin=$p(CurData,"^",iLLoop)
    
    Q:(""'=BookDateBegin)&(+BookDateBegin>+PGADMBookDateBegin)
    i ""'=PGADMBookDateBegin s PGADMBookDateBegin=##class(websys.Conversions).DateLogicalToHtml(PGADMBookDateBegin)
    s iLLoop=iLLoop+1
    // PGADM_BookDateEnd    28
    s PGADMBookDateEnd=$p(CurData,"^",iLLoop)
    Q:(""'=BookDateEnd)&(+BookDateEnd<+PGADMBookDateEnd)
    i ""'=PGADMBookDateEnd s PGADMBookDateEnd=##class(websys.Conversions).DateLogicalToHtml(PGADMBookDateEnd)
    s iLLoop=iLLoop+1
    // PGADM_BookTime   预约体检时间 4
    s PGADMBookTime=$p(CurData,"^",iLLoop)
    Q:(""'=BookTime)&(BookTime'=PGADMBookTime)
    i ""'=PGADMBookTime s PGADMBookTime=##class(websys.Conversions).TimeLogicalToHtml(PGADMBookTime)
    s iLLoop=iLLoop+1
    // PGADM_PEDeskClerk_DR 预约接待人员 15
    s PGADMPEDeskClerkDR=$p(CurData,"^",iLLoop)
    i ""'=PGADMPEDeskClerkDR d
    .s PGADMPEDeskClerkDRName=$p($g(^SSU("SSUSR",PGADMPEDeskClerkDR)),"^",2)
    e  d
    .s PGADMPEDeskClerkDRName=""
    s iLLoop=iLLoop+1

    s iLLoop=iLLoop+1
    // PGADM_AsCharged  视同收费 2
    s PGADMAsCharged=$p(CurData,"^",iLLoop)
    s iLLoop=iLLoop+1
    // PGADM_AddOrdItem 允许加项 19
    s PGADMAddOrdItem=$p(CurData,"^",iLLoop)
    s iLLoop=iLLoop+1
    // PGADM_AddOrdItemLimit    加项金额限制 20
    s PGADMAddOrdItemLimit=$p(CurData,"^",iLLoop)
    s iLLoop=iLLoop+1
    // PGADM_AddOrdItemAmount   允许加项金额 21
    s PGADMAddOrdItemAmount=$p(CurData,"^",iLLoop)
    s iLLoop=iLLoop+1
    // PGADM_AddPhcItem 允许加药 22
    s PGADMAddPhcItem=$p(CurData,"^",iLLoop)
    s iLLoop=iLLoop+1
    // PGADM_AddPhcItemLimit    加药金额限制 23
    s PGADMAddPhcItemLimit=$p(CurData,"^",iLLoop)
    s iLLoop=iLLoop+1
    // PGADM_AddPhcItemAmount   允许加药金额 24
    s PGADMAddPhcItemAmount=$p(CurData,"^",iLLoop)
    s iLLoop=iLLoop+1
    // PGADM_GReportSend    团体报告发送 25
    s PGADMGReportSend=$p(CurData,"^",iLLoop)
    s:(""'=PGADMGReportSend) PGADMGReportSendName =##Class(web.DHCPE.PreCommon).TransGReportSend(PGADMGReportSend)
    s:(""=PGADMGReportSend) PGADMGReportSendName = ""
    s iLLoop=iLLoop+1
    // PGADM_IReportSend    个人报告发送 26
    s PGADMIReportSend=$p(CurData,"^",iLLoop)
    s:(""'=PGADMIReportSend) PGADMIReportSendName =##Class(web.DHCPE.PreCommon).TransIReportSend(PGADMIReportSend)
    s:(""=PGADMIReportSend) PGADMIReportSendName = ""
    s iLLoop=iLLoop+1
    // PGADM_DisChargedMode 结算方式 27
    s PGADMDisChargedMode=$p(CurData,"^",iLLoop)
    s:(""'=PGADMDisChargedMode) PGADMDisChargedModeName =##Class(web.DHCPE.PreCommon).TransDisChargedMode(PGADMDisChargedMode)
    s:(""=PGADMDisChargedMode) PGADMDisChargedModeName = ""
    s iLLoop=iLLoop+1
    // PGADM_DelayDate  28
    s PGADMDelayDate=$p(CurData,"^",iLLoop)
    i ""'=PGADMDelayDate s PGADMDelayDate=##class(websys.Conversions).DateLogicalToHtml(PGADMDelayDate)
    s iLLoop=iLLoop+1
    // PPGADM_Remark    备注 5
    s PPGADMRemark=$p(CurData,"^",iLLoop)
    s iLLoop=iLLoop+1
    // PGADM_UpdateUser_DR 13
    s PGADMUpdateUserDR=$p(CurData,"^",iLLoop)
    i ""'=PGADMUpdateUserDR d
    .s PGADMUpdateUserDRName=$p($g(^SSU("SSUSR",PGADMUpdateUserDR)),"^",2)
    e  d
    .s PGADMUpdateUserDRName=""
    s iLLoop=iLLoop+1
    // PGADM_UpdateDate 14
    s PGADMUpdateDate=$p(CurData,"^",iLLoop)
    //Q:(""'=UpdateDate)&(UpdateDate'=PGADMUpdateDate)
    i ""'=PGADMUpdateDate s PGADMUpdateDate=##class(websys.Conversions).DateLogicalToHtml(PGADMUpdateDate)
    s iLLoop=iLLoop+1
    ////wrz0606liu
    s TTotalPerson=..GetTotalPersonByGroup(id)
    s TotalPerson=+$P(TTotalPerson,"共",2)
    q:TPerson<TotalPerson
    q:LPerson>TotalPerson
    ;s PGADMChargedStatusName=##class(web.DHCPE.PreIADM).GetChargedStatus("G", id)

    s PGADMChargedStatus=##class(web.DHCPE.PreIADM).GetChargedStatusNew("G", id)
    q:(ChargeStatus'="")&&(PGADMChargedStatus'=ChargeStatus)
    s PGADMChargedStatusName=##class(web.DHCPE.PreIADM).GetChargedStatusDesc(PGADMChargedStatus)

    s TGetReportDate=$G(^DHCPEDataEx("DHCPEPreGADM","GetReportDateTime","G",id))
    i TGetReportDate'="" d
    .s $P(TGetReportDate,"^",1)=##class(websys.Conversions).DateLogicalToHtml($P(TGetReportDate,"^",1))
    .s $P(TGetReportDate,"^",2)=##class(websys.Conversions).TimeLogicalToHtml($P(TGetReportDate,"^",2))
    s TGetReportDate=$P(TGetReportDate,"^",1)
    s TType=$G(^DHCPEDataEx("DHCPEPreGADM","ADMType",id))
    s TType=##class(web.DHCPE.PreCommon).GetPreTypeDesc(TType)
    s TPayType=$G(^DHCPEDataEx("DHCPEPreGADM","PayType",id))
    s TPayType=##class(web.DHCPE.PreCommon).GetPayTypeDesc(TPayType)
    s Percent=$G(^DHCPEDataEx("DHCPEPreGADM","Percent",id))
    s:Percent'="" Percent=" ("_Percent_"%)"
    s TPayType=TPayType_Percent
    s ReportStatus=..GetReportStatus(id, "G")
    //q:(ReportGroup'="1")&&((ReportStatus="P")||(ReportStatus="S"))
    s ReportStatusNew=""
    i ((ReportStatus="P")||(ReportStatus="S")) s ReportStatusNew="1"
    e  s ReportStatusNew="0"
    q:(ReportGroup'="0")&&(ReportGroup'=ReportStatusNew)

    s ReportStatusDesc="未审核"                    //add by zhouli
    s GADM=$o(^DHCPEGADM(0,"CRMGADM",id,0))
    i GADM'=""  d
    .s PAADM=$P(^DHCPEGADM(GADM),"^",3)
    .s ReportStatusDesc=##class(web.DHCPE.Report).GetStatusDesc(ReportStatus,PAADM)  //add by zhouli
    S CompleteStatus=$g(^DHCPEDataEx("DHCPEPreGADM","PEComplete",id))
    i CompleteStatus'=""  s CompleteStatus="已完成"
    else  s CompleteStatus="未完成"
    
    //s ConfirmAddOrdItemPerson=..GetConfirmItemPerson(id)
    s ConfirmAddOrdItemFlag=..GetConfirmItemPerson(id)
    i ConfirmAddOrdItemFlag="" s ConfirmAddOrdItemPerson="否"
    i ConfirmAddOrdItemFlag'="" s ConfirmAddOrdItemPerson="是"

    s TGroupCode=$p(CurData,"^",24)
    s TContract=$p(CurData,"^",25)
    i +TContract'=0 d
    .s PGADMContractNo=$LG(^User.DHCPEContractD(TContract),2)
    .s TContract=$LG(^User.DHCPEContractD(TContract),3)
    
    s HomeGroupFlag=##class(web.DHCPE.PreHome).GetHomeFlag(id,"G")
    s TMark=""
    s TMark=$g(^DHCPEDataEx("Mark","G",id))
    s TPGADMHPCode=$P(CurData,"^",24)
    
    s AllowToCharge=##class(web.DHCPE.AllowToCharge).GetToChargeFlag("Pre",id)
    i AllowToCharge="1" d
    .s AllowToCharge="是"
    e  s AllowToCharge=""
    
    s GTotalAmont=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Grp(id)
    s GTotalAmont=$p(GTotalAmont,"^",2)
    s IADMCRMADM="0",IAmountTotal=0
    f  s IADMCRMADM=$o(^DHCPEPreIADM(0,"PGADM",id,IADMCRMADM)) q:IADMCRMADM=""  d
    .// 应付金额^最终金额^公费金额^公费已付^公费未付^自费金额^自费已付^自费未付
    .s retvalue=##Class(web.DHCPE.InvPrt).GetAdmFee(IADMCRMADM)
    .Q:(""=retvalue)
    .//公费金额
    .S GAmount=+$P(retvalue,"^",3)
    .//自费金额
    .s IAmount=+$P(retvalue,"^",6)
    .s IAmountTotal=IAmountTotal+IAmount
    s GGAmountTotal=GTotalAmont-IAmountTotal
    S Amounts=..GetGroupFeeInfo(id)
    s AmountTotal=$p(Amounts,"^",1)
    s AmountChagerd=$p(Amounts,"^",2)
    s AmountUnChagerd=$p(Amounts,"^",3)
    s OldAmountTotal=$p(Amounts,"^",4)
    s RebateAmout=OldAmountTotal-AmountTotal
    s GTotalAmont="总金额："_$fn(AmountTotal,"",2)_"，已付："_$fn(AmountChagerd,"",2)_"，未付："_$fn(AmountUnChagerd,"",2)_"，折扣："_$fn(RebateAmout,"",2)

    d FindBuild
    q
FindBuild
    set Data=$lb($g(id), PGADMPGBIDR, PGADMPGBIDRCode, PGADMPGBIDRName, PGADMAsCharged, PGADMBookDateBegin, PGADMBookDateEnd, PGADMBookTime, PGADMRemark, PGADMContractNo, PGADMStatus, PGADMStatusDesc, PGADMAccountAmount, PGADMDiscountedAmount, PGADMFactAmount, PGADMAuditUserDR, PGADMAuditUserDRName, PGADMAuditDate, PGADMUpdateUserDR, PGADMUpdateUserDRName, PGADMUpdateDate, PGADMPEDeskClerkDR, PGADMPEDeskClerkDRName, PGADMSaleAmount, PGADMChargedStatus, PGADMChargedStatusName, PGADMCheckedStatus, ReportStatusDesc, PGADMAddOrdItem, PGADMAddOrdItemLimit, PGADMAddOrdItemAmount, PGADMAddPhcItem, PGADMAddPhcItemLimit, PGADMAddPhcItemAmount, PGADMGReportSend, PGADMGReportSendName, PGADMIReportSend, PGADMIReportSendName, PGADMDisChargedMode, PGADMDisChargedModeName,PGADMDelayDate,TTotalPerson,$G(TGetReportDate),TType,TPayType,GRegNo,PGBILinkman1,PGBITel1,CompleteStatus,ConfirmAddOrdItemPerson,TGroupCode,TContract,$g(HomeGroupFlag),TMark,TPGADMHPCode,AllowToCharge,GTotalAmont,$fn(IAmountTotal,"",2),$fn(GGAmountTotal,"",2))
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod GetGroupFeeInfo(id)
{
 s AmountTotal=0,AmountCharged=0,AmountUnCharged=0,TOldTAmount=0,TAmount=0
 s GADMID=$O(^DHCPEGADM(0,"CRMGADM",id,0))
 q:GADMID="" ""
 S PARowId=""   
 f  s PARowId=$o(^DHCPEPreA(0,"GIADM","G",GADMID,PARowId)) q:PARowId=""  d
 .s AInfo=$G(^DHCPEPreA(PARowId))
 .s PAStatus=$p(AInfo,"^",21)
 .q:PAStatus="NU"
 .s ChargedStatus=$p(AInfo,"^",14)
 .s TAmount=$p(AInfo,"^",6)
 .s TOldTAmount=TOldTAmount+TAmount
 .s Amount=$p(AInfo,"^",9)
 .s AmountTotal=AmountTotal+Amount
 .i ChargedStatus="CHARGED" s AmountCharged=AmountCharged+Amount
 .i ChargedStatus="UNCHARGED" s AmountUnCharged=AmountUnCharged+Amount
 q AmountTotal_"^"_AmountCharged_"^"_AmountUnCharged_"^"_TOldTAmount
}

/// w ##class(%ResultSet).RunQuery("web.DHCPE.PreGADM", "GetConfirmItemPerson",107)
Query GetConfirmItemPerson(PreGADM) As websys.Query(ROWSPEC = "RegNo:%String,Name:%String,Team:%String")
{
}

ClassMethod GetConfirmItemPersonExecute(ByRef qHandle As %Binary, PreGADM) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 

    s User=%session.Get("LOGON.USERID")
    K ^TMPDHCPEConfirmItemPerson("ConfirmItemPerson",User)
   
        s preAuditId=0 
        f  s preAuditId=$o(^DHCPEPreA(0,"CRMADM","G",PreGADM,preAuditId)) Q:preAuditId=""  d
       
        .s CanCashier=1
        .s preAdmId=0
        .f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId)) q:((preAdmId="")||(CanCashier=0))  d
        ..s Status=$p($G(^DHCPEPreIADM(preAdmId)),"^",8)
        ..q:(Status'="ARRIVED")&&(Status'="REGISTERED")
        ..s childsub=0
        ..f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId,childsub)) q:((childsub="")||(CanCashier=0))  d
        ...q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",16)'=1 //判断是否有效
        ...S PIOI=preAdmId_"||"_childsub
        ...S CRMO=$o(^DHCPECRMO(0,"CRMORI",PIOI,0))
        ...s PIBIID=$P(^DHCPEPreIADM(preAdmId),"^",1)
        ...Q:PIBIID=""
        ...s Name=$p(^DHCPEPreIBI(PIBIID),"^",2)
        ...S RegNo=$p(^DHCPEPreIBI(PIBIID),"^",1)
        ...s Team=""
        ...s PGTeamDR=$p($G(^DHCPEPreIADM(preAdmId)),"^",3)
        ...i PGTeamDR'="" s Team=$p($g(^DHCPEPreGADM($p(PGTeamDR,"||",1),"Team",$p(PGTeamDR,"||",2))),"^",1)
        ...I CRMO="" d
        ....s ^TMPDHCPEConfirmItemPerson("ConfirmItemPerson",User,RegNo)=Name_"^"_Team
        

        .s preAdmId=0
        .f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId)) q:((preAdmId="")||(CanCashier=0))  d
        ..s Status=$p($G(^DHCPEPreIADM(preAdmId)),"^",8)
        ..q:(Status'="ARRIVED")&&(Status'="REGISTERED")
        ..s childsub=0
        ..f  s childsub=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId,childsub)) q:((childsub="")||(CanCashier=0))  d
        ...q:$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",9)'=1 //判断是否有效
        ...Set PIOE=preAdmId_"||"_childsub
        ...s itemChildSub=0
        ...f  s itemChildSub=$o(^DHCPEPreIADM(0,"OrdEnt",PIOE,preAdmId,itemChildSub)) q:((itemChildSub="")||(CanCashier=0))  d
        ....q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",itemChildSub)),"^",16)'=1 //判断是否有效
        ....s PIOI=preAdmId_"||"_itemChildSub
        ....S CRMO=$o(^DHCPECRMO(0,"CRMORI",PIOI,0))
        ....s PIBIID=$P(^DHCPEPreIADM(preAdmId),"^",1)
        ....Q:PIBIID=""
        ....s Name=$p(^DHCPEPreIBI(PIBIID),"^",2)
        ....S RegNo=$p(^DHCPEPreIBI(PIBIID),"^",1)
        ....s Team=""
        ....s PGTeamDR=$p($G(^DHCPEPreIADM(preAdmId)),"^",3)
        ....i PGTeamDR'="" s Team=$p($g(^DHCPEPreGADM($p(PGTeamDR,"||",1),"Team",$p(PGTeamDR,"||",2))),"^",1)
        ....I CRMO="" d
        .....s ^TMPDHCPEConfirmItemPerson("ConfirmItemPerson",User,RegNo)=Name_"^"_Team
        
    s RegNoID=0
    f  s RegNoID=$o(^TMPDHCPEConfirmItemPerson("ConfirmItemPerson",User,RegNoID)) q:RegNoID=""  d
    .s Name=$p($g(^TMPDHCPEConfirmItemPerson("ConfirmItemPerson",User,RegNoID)),"^",1)
    .s Team=$p($g(^TMPDHCPEConfirmItemPerson("ConfirmItemPerson",User,RegNoID)),"^",2)
    .s ^CacheTemp(repid,ind)=$lb(RegNoID,Name,Team)
    .s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

// w ##class(web.DHCPE.PreGADM).GetConfirmItemPerson("97")

ClassMethod GetConfirmItemPerson(PreGADM)
{
      n (PreGADM)
        s preAuditId=0 ,NameStr=""
        f  s preAuditId=$o(^DHCPEPreA(0,"CRMADM","G",PreGADM,preAuditId))  Q:preAuditId=""  d
        .s CanCashier=1
        .s preAdmId=0
        .f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId)) q:((preAdmId="")||(CanCashier=0))  d
        ..s Status=$p($G(^DHCPEPreIADM(preAdmId)),"^",8)
        ..q:(Status'="ARRIVED")&&(Status'="REGISTERED")
        ..s childsub=0
        ..f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId,childsub)) q:((childsub="")||(CanCashier=0))  d
        ...q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",16)'=1   //判断是否有效
        ...Set PIOI=preAdmId_"||"_childsub
        ...Set CRMO=$o(^DHCPECRMO(0,"CRMORI",PIOI,0))
        ...s PIBIID=$P(^DHCPEPreIADM(preAdmId),"^",1)
        ...Q:PIBIID=""
        ...s Name=$p(^DHCPEPreIBI(PIBIID),"^",2)
        ...If CRMO="" d
        ....i NameStr'[Name s NameStr=NameStr_" "_Name

        .s preAdmId=0
        .f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId)) q:((preAdmId="")||(CanCashier=0))  d
        ..s Status=$p($G(^DHCPEPreIADM(preAdmId)),"^",8)
        ..q:(Status'="ARRIVED")&&(Status'="REGISTERED")
        ..s childsub=0
        ..f  s childsub=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId,childsub)) q:((childsub="")||(CanCashier=0))  d
        ...q:$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",9)'=1 //判断是否有效
        ...Set PIOE=preAdmId_"||"_childsub
        ...s itemChildSub=0
        ...f  s itemChildSub=$o(^DHCPEPreIADM(0,"OrdEnt",PIOE,preAdmId,itemChildSub)) q:((itemChildSub="")||(CanCashier=0))  d
        ....q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",itemChildSub)),"^",16)'=1  //判断是否有效
        ....s PIOI=preAdmId_"||"_itemChildSub
        ....Set CRMO=$o(^DHCPECRMO(0,"CRMORI",PIOI,0))
        ....s PIBIID=$P(^DHCPEPreIADM(preAdmId),"^",1)
        ....Q:PIBIID=""
        ....s Name=$p(^DHCPEPreIBI(PIBIID),"^",2)
        ....If CRMO="" d
        .....i NameStr'[Name s NameStr=NameStr_" "_Name
        
        
        q NameStr
}

/// d ##class(web.DHCPE.PreGADM).GetTotalPersonByGroup(79)
ClassMethod GetTotalPersonByGroup(id)
{
  
    new j,l,k,Str
    s j=0
    s l=0
    s k=0
    s n=0
    s Str="",CancelPEStr=""
    s Sub=0
    f  s Sub=$o(^DHCPEPreGADM(id,"Team",Sub)) q:Sub=""  d
    .s Person=##class(web.DHCPE.PreGTeam).GetTotalPersonByItem(id_"||"_Sub)
    .s j=j+(+Person)
    .s l=l+($p(Person,"^",2))
    .s k=k+($p(Person,"^",3))
    .s n=n+($p(Person,"^",4))
    i k'=0 s Str=",取消"_k_"人"
    i n'=0  s CancelPEStr=",取消体检"_n_"人"
    q "共"_j_"人,已检"_l_"人"_Str_CancelPEStr
}

// ************************************************************************

ClassMethod SearchPreGADMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPreGADMExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod SearchPreGADMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPreGADMExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 删除函数
ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", Rowid As %Library.String = "")
{
    &sql(delete from DHC_PE_PreGADM where PGADM_RowId=:Rowid)
    q SQLCODE
}

/// w ##Class(web.DHCPE.PreGADM).GetPreGADM("3")
ClassMethod GetPreGADM(id As %Library.String = "")
{
    q:id="" ""
    s CurData=$G(^DHCPEPreGADM(id))
    s Data=$G(id)
    i ""'=CurData  d
    .s iLLoop=1
    .// PGADM_PGBI_DR   预团体客户 RowId 1
    .s PGADMPGBIDR=$p(CurData,"^",iLLoop)
    .s Data=Data_"^"_PGADMPGBIDR
    .i ""'=PGADMPGBIDR d
    ..// DHC_PE_PreGBaseInfo
    ..s PGADMPGBIDRCode=$p($g(^DHCPEPreGBI(PGADMPGBIDR)),"^",1)
    ..s PGADMPGBIDRName=$p($g(^DHCPEPreGBI(PGADMPGBIDR)),"^",2)
    .e  d
    ..s PGADMPGBIDRCode=""
    ..s PGADMPGBIDRName=""
    .s iLLoop=iLLoop+1
    .s Data=Data_"^"_PGADMPGBIDRCode
    .s Data=Data_"^"_PGADMPGBIDRName
    .// PGADM_BookDateBegin 预约体检日期 3
    .s PGADMBookDateBegin=$p(CurData,"^",iLLoop)
    .i ""'=PGADMBookDateBegin s PGADMBookDateBegin=##class(websys.Conversions).DateLogicalToHtml(PGADMBookDateBegin)
    .s Data=Data_"^"_PGADMBookDateBegin
    .s iLLoop=iLLoop+1
    .// PGADM_BookDateEnd   28
    .s PGADMBookDateEnd=$p(CurData,"^",iLLoop)
    .i ""'=PGADMBookDateEnd s PGADMBookDateEnd=##class(websys.Conversions).DateLogicalToHtml(PGADMBookDateEnd)
    .s Data=Data_"^"_PGADMBookDateEnd
    .s iLLoop=iLLoop+1
    .// PGADM_BookTime  预约体检时间 4
    .s PGADMBookTime=$p(CurData,"^",iLLoop)
    .i ""'=PGADMBookTime s PGADMBookTime=$ZT(PGADMBookTime,2)
    .s Data=Data_"^"_PGADMBookTime
    .s iLLoop=iLLoop+1
    .// PGADM_PEDeskClerk_DR    预约接待人员 15
    .s PGADMPEDeskClerkDR=$p(CurData,"^",iLLoop)
    .i ""'=PGADMPEDeskClerkDR d
    ..s PGADMPEDeskClerkDRName=$p($g(^SSU("SSUSR",PGADMPEDeskClerkDR)),"^",2)
    .e  d
    ..s PGADMPEDeskClerkDRName=""
    .s Data=Data_"^"_PGADMPEDeskClerkDR
    .s Data=Data_"^"_PGADMPEDeskClerkDRName
    .s iLLoop=iLLoop+1
    .// PGADM_Status 登记状态 7
    .s PGADMStatus=$p(CurData,"^",iLLoop)
    .q:PGADMStatus="CANCELPE"
    .//Q:(""'=Status)&(Status'[PGADMStatus)
    .s:(""'=PGADMStatus) PGADMStatusDesc=##Class(web.DHCPE.PreCommon).TransStatus(PGADMStatus)
    .s:(""=PGADMStatus) PGADMStatusDesc=""
    .s Data=Data_"^"_PGADMStatus
    .s iLLoop=iLLoop+1
    .// PGADM_AsCharged 视同收费 2
    .s PGADMAsCharged=$p(CurData,"^",iLLoop)
    .s Data=Data_"^"_PGADMAsCharged
    .s iLLoop=iLLoop+1
    .// PGADM_AddOrdItem    允许加项 19
    .s PGADMAddOrdItem=$p(CurData,"^",iLLoop)
    .s Data=Data_"^"_PGADMAddOrdItem
    .s iLLoop=iLLoop+1
    .// PGADM_AddOrdItemLimit   加项金额限制 20
    .s PGADMAddOrdItemLimit=$p(CurData,"^",iLLoop)
    .s Data=Data_"^"_PGADMAddOrdItemLimit
    .s iLLoop=iLLoop+1
    .// PGADM_AddOrdItemAmount  允许加项金额 21
    .s PGADMAddOrdItemAmount=$p(CurData,"^",iLLoop)
    
    .i (PGADMAddOrdItemAmount'="")&&($p(PGADMAddOrdItemAmount,".",1)="") s PGADMAddOrdItemAmount=0_PGADMAddOrdItemAmount
    .s Data=Data_"^"_PGADMAddOrdItemAmount
    .s iLLoop=iLLoop+1
    .// PGADM_AddPhcItem    允许加药 22
    .s PGADMAddPhcItem=$p(CurData,"^",iLLoop)
    .s Data=Data_"^"_PGADMAddPhcItem
    .s iLLoop=iLLoop+1
    .// PGADM_AddPhcItemLimit   加药金额限制 23
    .s PGADMAddPhcItemLimit=$p(CurData,"^",iLLoop)
    .s Data=Data_"^"_PGADMAddPhcItemLimit
    .s iLLoop=iLLoop+1
    .// PGADM_AddPhcItemAmount  允许加药金额 24
    .s PGADMAddPhcItemAmount=$p(CurData,"^",iLLoop)
    .s Data=Data_"^"_PGADMAddPhcItemAmount
    .s iLLoop=iLLoop+1
    .// PGADM_GReportSend   团体报告发送 25
    .s PGADMGReportSend=$p(CurData,"^",iLLoop)
    .s Data=Data_"^"_PGADMGReportSend
    .s iLLoop=iLLoop+1
    .// PGADM_IReportSend   个人报告发送 26
    .s PGADMIReportSend=$p(CurData,"^",iLLoop)
    .s Data=Data_"^"_PGADMIReportSend
    .s iLLoop=iLLoop+1
    .// PGADM_DisChargedMode    结算方式 27
    .s PGADMDisChargedMode=$p(CurData,"^",iLLoop)
    .s Data=Data_"^"_PGADMDisChargedMode
    .s iLLoop=iLLoop+1
    .// PGADM_DelayDate 28
    .s PGADMDelayDate=$p(CurData,"^",iLLoop)
    
    .i ""'=PGADMDelayDate s PGADMDelayDate=##class(websys.Conversions).DateLogicalToHtml(PGADMDelayDate)
    .s Data=Data_"^"_PGADMDelayDate
    .s iLLoop=iLLoop+1
    .// PPGADM_Remark   备注 5
    .s PPGADMRemark=$p(CurData,"^",iLLoop)
    .s Data=Data_"^"_PPGADMRemark
    .s iLLoop=iLLoop+1
    .// PGADM_UpdateUser_DR 13
    .s PGADMUpdateUserDR=$p(CurData,"^",iLLoop)
    .i ""'=PGADMUpdateUserDR d
    ..s PGADMUpdateUserDRName=$p($g(^SSU("SSUSR",PGADMUpdateUserDR)),"^",2)
    .e  d
    ..s PGADMUpdateUserDRName=""
    .s Data=Data_"^"_PGADMUpdateUserDR
    .s Data=Data_"^"_PGADMUpdateUserDRName
    .s iLLoop=iLLoop+1
    .// PGADM_UpdateDate 14
    .s PGADMUpdateDate=$p(CurData,"^",iLLoop)
    .i ""'=PGADMUpdateDate s PGADMUpdateDate=##class(websys.Conversions).DateLogicalToHtml(PGADMUpdateDate) 
    .s Data=Data_"^"_PGADMUpdateDate
    .s iLLoop=iLLoop+1
    .s iLLoop=iLLoop+1
    .///业务员
    .s Sales=$p(CurData,"^",iLLoop)
    .s Data=Data_"^"_Sales
    .i Sales'="" d 
    ..s Sales=$p($g(^SSU("SSUSR",Sales)),"^",2)
    .s Data=Data_"^"_Sales
    .s Type=$G(^DHCPEDataEx("DHCPEPreGADM","ADMType",id))
    .s Data=Data_"^"_Type
    .s ReportDate=$G(^DHCPEDataEx("DHCPEPreGADM","GetReportDateTime","G",id))
    .i ReportDate'="" d
    ..s $P(ReportDate,"^",1)=##class(websys.Conversions).DateLogicalToHtml($P(ReportDate,"^",1))
    ..s $P(ReportDate,"^",2)=$ZT($P(ReportDate,"^",2))
    .i ReportDate="" s ReportDate="^"
    .s Data=Data_"^"_ReportDate
    .s PayType=$G(^DHCPEDataEx("DHCPEPreGADM","PayType",id))
    .s Data=Data_"^"_PayType
    .s Percent=$G(^DHCPEDataEx("DHCPEPreGADM","Percent",id))
    .s Data=Data_"^"_Percent
    .s ADMFeeType=""
    .s ADMFeeType=$G(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",id))
    .s Data=Data_"^"_ADMFeeType
    .s (ContractID,ContractDesc)=""
    .s ContractID=$p(CurData,"^",25)
    .s:+ContractID'=0 ContractDesc=$LG(^User.DHCPEContractD(ContractID),3)
    .s Data=Data_"^"_ContractID_"^"_ContractDesc
    q Data
}

/// 提供给团体分组，团体的预约信息
/// w ##Class(web.DHCPE.PreGADM).GetPreGADMInfor("3")
ClassMethod GetPreGADMInfor(id As %Library.String = "")
{
    Q:(""=id) ""
    s CurData=$G(^DHCPEPreGADM(id))
    
    s Data=""
    
    i ""'=CurData  d
    .
    .// PGADM_PGBI_DR   预团体客户RowId  1
    .s PGADMPGBIDR = $p(CurData,"^",1)
    .i ""'=PGADMPGBIDR d   
    ..//团体编码 1.1
    ..s PGADMPGBIDRCode=$p($g(^DHCPEPreGBI(PGADMPGBIDR)),"^",1)
    ..//团体名称 1.2
    ..s PGADMPGBIDRName=$p($g(^DHCPEPreGBI(PGADMPGBIDR)),"^",2)
    .e  d
    ..s PGADMPGBIDRCode=""
    ..s PGADMPGBIDRName=""
    .
    .// PGADM_BookDateBegin 预约日期 3
    .s PGADMBookDateBegin = $p(CurData,"^",3)
    .i (""'=PGADMBookDateBegin) s PGADMBookDateBegin=$ZD(PGADMBookDateBegin,4)
    .
    .// PGADM_BookTime 预约时间 4
    .s PGADMBookTime = $p(CurData,"^",4)
    .i (""'=PGADMBookTime) s PGADMBookTime=$ZT(PGADMBookTime,2)
    .
    .// PGADM_PEDeskClerk_DR 预约接待人员 15
    .s PEDeskClerkDR = $p(CurData,"^",15)
    .i (""'=PEDeskClerkDR)  d // 15.1
    ..s PEDeskClerkDRName=$p($g(^SSU("SSUSR",PEDeskClerkDR)),"^",2)
    .e  d           
    ..s PEDeskClerkDRName=""
    .
    .// PGADM_AddOrdItem    允许加项 19
    .s PGADMAddOrdItem=$p(CurData,"^",19)
    .
    .// PGADM_AddOrdItemLimit   加项金额限制 20
    .s PGADMAddOrdItemLimit=$p(CurData,"^",20)
    .
    .// PGADM_AddOrdItemAmount  允许加项金额 21
    .s PGADMAddOrdItemAmount=$p(CurData,"^",21)
    .
    .// PGADM_AddPhcItem    允许加药 22
    .s PGADMAddPhcItem=$p(CurData,"^",22)
    .
    .// PGADM_AddPhcItemLimit   加药金额限制 23
    .s PGADMAddPhcItemLimit=$p(CurData,"^",23)
    .
    .// PGADM_AddPhcItemAmount  允许加药金额 24
    .s PGADMAddPhcItemAmount=$p(CurData,"^",24)
    .
    .// PGADM_GReportSend   团体报告发送 25
    .s PGADMGReportSend=$p(CurData,"^",25)
    .s:(""'=PGADMGReportSend) PGADMGReportSendName =##Class(web.DHCPE.PreCommon).TransGReportSend(PGADMGReportSend)
    .s:(""=PGADMGReportSend) PGADMGReportSendName = ""
    .
    .// PGADM_IReportSend   个人报告发送 26
    .s PGADMIReportSend=$p(CurData,"^",26)
    .s:(""'=PGADMIReportSend) PGADMIReportSendName =##Class(web.DHCPE.PreCommon).TransIReportSend(PGADMIReportSend)
    .s:(""=PGADMIReportSend) PGADMIReportSendName = ""
    .
    .// PGADM_DisChargedMode    结算方式 27
    .s PGADMDisChargedMode=$p(CurData,"^",27)
    .s:(""'=PGADMDisChargedMode) PGADMDisChargedModeName =##Class(web.DHCPE.PreCommon).TransDisChargedMode(PGADMDisChargedMode)
    .s:(""=PGADMDisChargedMode) PGADMDisChargedModeName = ""
    .
    .// PGADM_BookDateEnd 28
    .s PGADMBookDateEnd = $p(CurData,"^",28)
    .i (""'=PGADMBookDateEnd) s PGADMBookDateEnd=$ZD(PGADMBookDateEnd,4)
    .
    .//     0           1                   2                   3                       4                       5               6                   6.1                     7               8                           9                           10                  11                      12                  13                  13.1                        14                  14.1                            15                  15.1                            16                      16.1    
    .s Data=$G(id)_"^"_PGADMPGBIDRCode_"^"_PGADMPGBIDRName_"^"_PGADMBookDateBegin_"^"_PGADMBookDateEnd_"^"_PGADMBookTime_"^"_PEDeskClerkDR_"^"_PEDeskClerkDRName_"^"_PGADMAddOrdItem_"^"_PGADMAddOrdItemLimit_"^"_PGADMAddOrdItemAmount_"^"_PGADMAddPhcItem_"^"_PGADMAddPhcItemLimit_"^"_PGADMAddPhcItemAmount_"^"_PGADMGReportSend_"^"_PGADMGReportSendName_"^"_PGADMIReportSend_"^"_PGADMIReportSendName_"^"_PGADMDisChargedMode_"^"_PGADMDisChargedModeName
    .
    q Data
}

/// 获取团体信息
/// 
/// 如果通过 "预约号 PGADM_RowId" 查找，则获取 "预约信息" 和 "团体信息"
/// 如果辀?过 "团体编码" 查找，则只获取 "团体信息"
/// IsShowAlert 是否在页面显示警告信息(已登记) 
/// w ##class(web.DHCPE.PreGADM).DocListBroker("","","127^")
ClassMethod DocListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
    //PGADM_RowId(DHC_PE_PreGADM)+PGBI_Code(DHC_PE_PreGBaseInfo)
    s id=$p($g(InString),"^",1) 
    s Code=$p($g(InString),"^",2) 
    
    i ""'=id d  
    .
    .// 通过 "预约号 PGADM_RowId" 获取信息 
    .
    .//获取登记信息
    .s Data=..GetPreGADM(id)
    .i ""'=Data d
    ..s PreGADMData=Data
    .e  d
    ..s PreGADMData="0^"
    .
    .//获取团体信息
    .s PGADMPGBIDR=$p($g(Data),"^",2)
    .s Data=##class(web.DHCPE.PreGBaseInfo).GetPreGBaseInfo(PGADMPGBIDR_"^")
    .i (""'=Data)  d
    ..s GBaseInfoData=Data
    .e  d
    ..s GBaseInfoData="0"_"^"_PGADMPGBIDR_"^"_"未找到团体信息"
    ..s PreGADMData="0^"
    .s IsShowAlert="N"
    .
    e  d
    .
    .//通过登记号 
    .s PreGADMData="0^"
    .
    .//获取团体信息
    .s Data=##class(web.DHCPE.PreGBaseInfo).GetPreGBaseInfo("^"_Code)
    .s GBaseInfoData=Data
    .
    .//查看团体是否已登记
    .s IsShowAlert="N"
    .s PGBIDR=$p(Data,"^",1)
    .i "0"'=PGBIDR d
    ..s IsShowAlert=..GetGID(PGBIDR)
    ..i ""'=IsShowAlert s IsShowAlert="Y"
    
    s Data=GBaseInfoData_";"_PreGADMData_";"_IsShowAlert
    i ""'=itmjs d
    .s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
    .&javascript<#(retval)#>
    q Data
}

/// 预约审核
/// IAdmId 个人预约的ID
/// GAdmId 审核团体的预约成员，不能与IAdmId同时不为空
/// test w ##class(web.DHCPE.PreGADM).AuditAdm()
ClassMethod AuditAdm(GAdmId As %Library.String = "", FactAmount As %Library.String = "", AuditUserId As %Library.String = "")
{
    Q:(""=GAdmId) 0
    
    s Status="CHECKED"
    s AuditDate=+$H
    
    TStart
        /*0329
        &sql(update DHC_PE_PreGADM
            set PGADM_Status = :Status
            ,PGADM_FactAmount = :FactAmount
            ,PGADM_AuditUser_DR = :AuditUserId
            ,PGADM_AuditDate = :AuditDate
        where PGADM_RowId = :GAdmId
        )*/
        
        i ((SQLCODE'=0)&&(SQLCODE'=100)) d
        .s retVal="AuditAdm dhc_pe_PreGAdm wrong, SQLCODE="_SQLCODE
        .goto AuditErr
        

        s retVal=##class(web.DHCPE.PreIADM).AuditAdm("",GAdmId,FactAmount,AuditUserId)
        i ""'=retVal goto AuditErr
    TCOMMIT
        Q retVal
AuditErr
    TRollBack
    Q retVal
}

/// 设置团体的 应收金额、打折金额、审核金额 
/// w ##class(web.DHCPE.PreGADM).SaveAmount("","","1^100")
ClassMethod SaveAmount(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{

    s id=$p(InString,"^",1)
    Q:(""=id) "Err A01" 
    
    s CurData=$G(^DHCPEPreGADM(id))
    Q:(""=CurData) "Err A02" 
    s RowId=id
    
    // PGADM_AccountAmount 应收金额 10
    s AccountAmount=$p(InString,"^",2)
    i ""=AccountAmount d
    .s AccountAmount = $p(CurData,"^",8)
    
    // PGADM_DiscountedAmount 打折后金额 11
    s DiscountedAmount=$p(InString,"^",3)
    i ""=DiscountedAmount d
    .s DiscountedAmount = $p(CurData,"^",9)
    
    // PGADM_FactAmount 最终金额 12
    s FactAmount=$p(InString,"^",4)
    i ""=FactAmount d
    .s FactAmount = $p(CurData,"^",10)
    //0329
    /*&sql(update DHC_PE_PreGADM
        set  PGADM_AccountAmount = :AccountAmount
            ,PGADM_DiscountedAmount = :DiscountedAmount
            ,PGADM_FactAmount = :FactAmount
         where PGADM_RowId = :RowId
        )*/
    q SQLCODE
}

/// 更新金额 
/// 使用  web.DHCPE.PreItemList.UpdateAmount  当更改团体组的项目时，更新其金额)
/// 设置团体的 应收金额
/// w ##class(web.DHCPE.PreGADM).SaveAccountAmount("","","3")
ClassMethod SaveAccountAmount(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
    s RowId=$p(InString,"^",1)
    s AccountAmount=$p(InString,"^",2)
    Q:(""=RowId) "Err G01"
    s ret=""
    /*0329
    &sql(update DHC_PE_PreGADM
        set  PGADM_AccountAmount = :AccountAmount
         where PGADM_RowId = :RowId
        )*/
    i ((SQLCODE'=0)&&(SQLCODE'=100)) s ret=SQLCODE
    q ret
}

/// 设置个人 的打折金额
/// w ##class(web.DHCPE.PreIADM).DiscountedAmount("","","1^100")
ClassMethod SaveDiscountedAmount(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{

    s RowId=$p(InString,"^",1)
    s DiscountedAmount=$p(InString,"^",2)
    Q:(""=RowId) "Err A01"
    s ret=""
    /*0329
    &sql(update DHC_PE_PreGADM
        set  PGADM_DiscountedAmount = :DiscountedAmount
         where PGADM_RowId = :RowId
        )*/
    i ((SQLCODE'=0)&&(SQLCODE'=100)) s ret=SQLCODE
    q ret
}

/// d ##class(web.DHCPE.PreGADM).OutputGTList("60501",1)
ClassMethod OutputGTList(XmlId As %String = "")
{
    
    s LineEnd=""
    s ret="<tree>"
    // 根节点
    s ret=ret_" <Node>"_LineEnd
    s ret=ret_"  <ID>Itree</ID>"_LineEnd
    s ret=ret_"  <Name>Ntree</Name>"_LineEnd
    s ret=ret_"  <depth>0</depth>"_LineEnd
    s ret=ret_"  <Text>"_"当日预约"_"("_+$G(^xwmtest("GTList",$J))_")"_"</Text>"_LineEnd
    s ret=ret_"  <URL>"_"^"_"</URL>"_LineEnd
    s Gid=""
    
    f  s Gid=$O(^xwmtest("GTList",$J,Gid)) Q:(""=Gid)  d
    .s ret=ret_" <Node>"_LineEnd
    .s ret=ret_"  <ID>I"_Gid_"</ID>"_LineEnd
    .s ret=ret_"  <Name>N"_Gid_"</Name>"_LineEnd
    .s ret=ret_"  <depth>"_1_"</depth>"_LineEnd
    .s Text=$P($G(^xwmtest("GTList",$J,Gid)),"^",1)_"("_$P($G(^xwmtest("GTList",$J,Gid)),"^",2)_")"
    .s ret=ret_"  <Text>"_Text_"</Text>"_LineEnd
    .s ret=ret_"  <URL>"_Gid_"^G"_"</URL>"_LineEnd
    .s Tid=0
    .f  s Tid=$O(^xwmtest("GTList",$J,Gid,Tid)) Q:(""=Tid)  d
    ..s ret=ret_"   <Node>"_LineEnd
    ..s ret=ret_"   <ID>I"_Tid_"</ID>"_LineEnd
    ..s ret=ret_"   <ID>I"_Tid_"</ID>"_LineEnd
    ..s ret=ret_"   <depth>"_2_"</depth>"_LineEnd
    ..s Text=$P($G(^xwmtest("GTList",$J,Gid,Tid)),"^",1)_"("_$P($G(^xwmtest("GTList",$J,Gid,Tid)),"^",2)_")"
    ..
    ..s ret=ret_"   <Text>"_Text_"</Text>"_LineEnd
    ..s ret=ret_"   <URL>"_Tid_"^T"_"</URL>"_LineEnd
    ..s ret=ret_"   </Node>"_LineEnd
    .s ret=ret_" </Node>"_LineEnd

    
    s ret=ret_"</Node>"_LineEnd
    s ret=ret_"</tree>"_LineEnd

    Q ret
}

/// 体检排期，查看指定日期的检验团体
/// w ##class(web.DHCPE.PreGADM).SearchGTList("01/09/2006")
ClassMethod SearchGTList(BookingDate As %String = "")
{
    
    k ^xwmtest("GTList",$J)
    s TotalCount=+0
    s ^xwmtest("GTList",$J)=+TotalCount
    
    i ""'=BookingDate d
    .s BookingDate=$ZDH(BookingDate,4)
    .//0329
    .// 散客
    .//&SQL(select count(*) into :PCount
        //from DHC_PE_PreIADM
        //where ((PIADM_PGTeam_DR is null)or(PIADM_PGTeam_DR=""))
        //and(PIADM_PEDateBegin=:BookingDate)
        //)
    .s ^xwmtest("GTList",$J,"I")="散客"_"^"_PCount_"^"_0
    .s TotalCount=+TotalCount+PCount
    .
    .s Gid="0"
    .f  s Gid=$O(^DHCPEPreGADM(Gid)) Q:(""=Gid)  d
    ..s CurData=$G(^DHCPEPreGADM(Gid))
    ..Q:((BookingDate'="")&(BookingDate'=$P(CurData,"^",3)))
    ..
    ..s id=Gid
    ..&SQL(select count(*) into :PCount from DHC_PE_PreIADM where PIADM_PGADM_DR=:id)
    ..//i BookingDate=$P(CurData,"^",3) b //ddddddd
    ..s PGADMPGBIDR=$P(CurData, "^", 1)
    ..// DHC_PE_PreGBaseInfo 团体客户基本信息表
    ..s GCode=$P($G(^DHCPEPreGBI(PGADMPGBIDR)),"^",1)
    ..s GDesc=$P($G(^DHCPEPreGBI(PGADMPGBIDR)),"^",2)
    ..s ^xwmtest("GTList",$J,Gid) = GDesc_"^"_PCount_"^"_GCode
    ..s TotalCount=+TotalCount+PCount
    ..s tid="0"
    ..
    ..// DHC_PE_PreGTeam 团体分组表
    ..f  s tid=$O(^DHCPEPreGADM(Gid, "Team", tid)) Q:(""=tid)  d
    ...
    ...s CurData=$G(^DHCPEPreGADM(Gid, "Team", tid))
    ...
    ...s PGTDesc=$P(CurData,"^",1)
    ...s id=Gid_"||"_tid
    ...&SQL(select count(*) into :PCount from DHC_PE_PreIADM where PIADM_PGTeam_DR=:id)
    ...s ^xwmtest("GTList",$J,Gid,id)=PGTDesc_"^"_PCount
    ...
    ..
    ..
    .s ^xwmtest("GTList",$J)=TotalCount

 


    Q ..OutputGTList()
}

/// 判断记录是否可以更改 Status 为 PREREG 预登记 可以更改
ClassMethod IsPREREG(id As %String = "")
{
    Q:(""=id) "1"
    s GStatus=$p($G(^DHCPEPreGADM(id)),"^",7)
    Q:(("PREREG"=GStatus)||(""=GStatus)) "1"
    Q "0"
}

/*ClassMethod GetGID(PGBID As %String = "")
{
    s id=0
    s id=$O(^DHCPEPreGADM(0,"PGBI",PGBID,id))
    Q id
}*/
ClassMethod GetGID(PGBID As %String = "")
{
    Q:(""=PGBID) ""
    s IsExist=""
    s id=0
    f  s id=$O(^DHCPEPreGADM(0,"PGBI",PGBID,id)) Q:(""=id)  d
    .s Status=$P($G(^DHCPEPreGADM(id)),"^",6)
    .q:Status="CANCELPE"
    .s:("PREREG"=Status)||("PREREGED"=Status)||("REGISTERED"=Status) IsExist=id
    .s date=$P($G(^DHCPEPreGADM(id)),"^",20)
    .i (("ARRIVED"=Status)&&(+$h<=date)) s IsExist=id
    Q IsExist
}

/// 更新函数  
/// w ##class(web.DHCPE.PreGADM).Save2("","","^6^Y^12/03/2007^^^^^^^^^^3565^^^^^^N^N^^N^N^^AsCharged^GSend^GDischarged^12/03/2007^N^N^^N^N^")
ClassMethod Save2(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
    new User,Date,Time,StartDate,EndDate
    s:$d(%session) User=%session.Get("LOGON.USERID")
    s:'$d(%session) User=5918
    s Date=+$H
    s Time=$p($H,",",2)
    
    
    s iLLoop=1
    // PGADM_RowId  1
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(1)=value
    
    s iLLoop=iLLoop+1
    // PGADM_PGBI_DR    预团体客户RowId 2
    s value=$p(InString,"^",iLLoop)
    s PLIST(2)=value
    
    // PGADM_BookDateBegin  开始日期 3
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    i value'="" s value=##class(websys.Conversions).DateHtmlToLogical(value)
    s StartDate=value
    s PLIST(3)=value
    
    // PGADM_BookDateEnd 结束日期    4
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    i value'="" s value=##class(websys.Conversions).DateHtmlToLogical(value)
    s EndDate=value
    s PLIST(4)=value


    i StartDate="" s StartDate=0
    i EndDate="" s EndDate=0
    i EndDate<StartDate q "Err Date"
    
    //检查主场设置
    s HomeEndDate=""
    i $p(InString,"^",1)'="" d
    .s HomeEndDate=$O(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",$p(InString,"^",1),""),-1)
    q:(HomeEndDate'="")&&(HomeEndDate>EndDate) "Err HomeDate"


    // PGADM_BookTime   预约时间 5
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    i value'="" s value=$ZTH(value)
    i value="" s value=$p($H,",",2)
    s PLIST(5)=value
    
    // PGADM_PEDeskClerk_DR 预约接待人
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(6)=value

    // 状态 PGADM_Status    7
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    i value="" s value="PREREG"
    s PLIST(7)=value
        
    // 视同收费 PGADM_AsCharged 8
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(8)=value

    //公费加项 PGADM_AddOrdItem 9
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(9)=value
    
    //加项限制 PGADM_AddOrdItemLimit    10
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(10)=value
    
    //加项限制金额 PGADM_AddOrdItemAmount 11
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(11)=value
    
    //公费加药 PGADM_AddPhcItem 12
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(12)=value

    //加药限制 PGADM_AddPhcItemLimit    13
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(13)=value

    //加药限制金额 PGADM_AddPhcItemAmount     14
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(14)=value

    //团体报告发送 PGADM_GReportSend          15
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(15)=value

    // 个人报告发送 PGADM_IReportSend     16
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(16)=value

    // 结算方式 PGADM_DisChargedMode        17
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(17)=value

    // 延期日期 PGADM_DelayDate     18
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    i value'="" s value=##class(websys.Conversions).DateHtmlToLogical(value)
    s PLIST(18)=value
    
    //
    // 备注 PGADM_Remark      19
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(19)=value
    s iLLoop=iLLoop+1
    s Sales=$p(InString,"^",iLLoop)
    
    s iLLoop=iLLoop+1
    s ADMType=$p(InString,"^",iLLoop)
   
    s iLLoop=iLLoop+1
    s GetReportDate=$p(InString,"^",iLLoop)
    i GetReportDate'="" s GetReportDate=##class(websys.Conversions).DateHtmlToLogical(GetReportDate)
    q:(GetReportDate'="")&&(GetReportDate<+$h) "Err GetReportDate"
    
    s iLLoop=iLLoop+1
    s GetReportTime=$p(InString,"^",iLLoop)
    i GetReportTime'="" s GetReportTime=$ZTH(GetReportTime)
    i GetReportTime="" s GetReportTime=$p($H,",",2)
    
    s iLLoop=iLLoop+1
    s PayType=$p(InString,"^",iLLoop)
    
    s iLLoop=iLLoop+1
    s Percent=$p(InString,"^",iLLoop)
    s iLLoop=iLLoop+1
    s DietFlag=$p(InString,"^",iLLoop)
    s iLLoop=iLLoop+1
    s GiftFlag=$p(InString,"^",iLLoop)
    s iLLoop=iLLoop+1
    s ADMFeeType=$p(InString,"^",iLLoop)
    s iLLoop=iLLoop+1
    s Contract=$p(InString,"^",iLLoop)
    
    s PLIST(20)=User
    s PLIST(21)=Date
    s PLIST(22)=Time
    s PLIST(23)=Sales
    s:$d(%session) DepLoc=%session.Get("LOGON.CTLOCID")         //add 2009-07-02
    s:'$d(%session) DepLoc=572
    ;s DepLoc=572
    s PLIST(24)=DepLoc 
    s PLIST(26)=Contract   
    s ret=..ISave2()
    
    q ret
}

/// 保存数据
ClassMethod ISave2()
{
    s ReturnFlag=""
    i 0=$D(PLIST(1)) d
    .s ReturnFlag=..Insert2()
    e  d
    .s ReturnFlag=..Update2()
    q ReturnFlag
}

ClassMethod Insert2()
{
    ;b //insert2
    k PLIST(1)          // PGADM_RowId
    s GroupCode=##class(web.DHCPE.PreIADMEx).GetNewGroupCode(PLIST(24))
    s PLIST(25)=GroupCode
    &SQL(Insert Into SQLUSER.DHC_PE_PreGADM Values :PLIST())
    i SQLCODE q SQLCODE_"^"_0
    s RowID=%ROWID
    d ##class(web.DHCPE.GAdmRecordManager).Insert(RowID,"P","PREInsert",PLIST(20),"")
    s ^DHCPEDataEx("DHCPEPreGADM","ADMType",RowID)=ADMType
    s ^DHCPEDataEx("DHCPEPreGADM","PayType",RowID)=PayType
    s ^DHCPEDataEx("DHCPEPreGADM","Percent",RowID)=Percent
    s ^DHCPEDataEx("DHCPEPreGADM","DietFlag",RowID)=DietFlag
    s ^DHCPEDataEx("DHCPEPreGADM","GiftFlag",RowID)=GiftFlag
    s ^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",RowID)=ADMFeeType   //就诊费用类型，用于取价格

    i GetReportDate'=""
    {
        s ^DHCPEDataEx("DHCPEPreGADM","GetReportDateTime","G",RowID)=GetReportDate_"^"_GetReportTime
        s ^DHCPEDataExi("DHCPEPreGADM","GetReportDateTime","G",GetReportDate,GetReportTime,RowID)=""
    }
    
    s SQLCODE=##class(web.DHCPE.PreIADM).InsertPreAudit(RowID,2)
    q SQLCODE_"^"_RowID
}

///  
/// 预约更新 
/// 不能更新 应收金额   PIADM_AccountAmount、PIADM_DiscountedAmount
/// 不能更新 审核人和审核日期   PIADM_AuditUser_DR、PIADM_AuditDate
ClassMethod Update2()
{
    new RowId,gOldInfo,OldAsCharged,OldLimitFee,iAdm
    s RowId=PLIST(1)
    s gOldInfo=$g(^DHCPEPreGADM(RowId))
    s OldAsCharged=$p(gOldInfo,"^",7)
    s OldLimitFee=$p(gOldInfo,"^",10)
    s OldAddOrdItem=$p(gOldInfo,"^",8)
    s OldChargedMode=$p(gOldInfo,"^",16)   //add
    K PLIST(1)
    //如果团体已收费，就诊类型跟上次类型不同，则不允许修改
    s ADMTypeChangeFlag=""
    s ADMTypeChangeFlag=..GetADMTypeChargedFlag(RowId,ADMFeeType,"G")
    Q:ADMTypeChangeFlag'="" ADMTypeChangeFlag
        
    TStart
    s SQLCODE=0
    i OldAsCharged'=PLIST(8)
    {
        s SQLCODE=##class(web.DHCPE.PreIADM).UpdateItemAsCharged(RowId,PLIST(8),"G")
    }

    i SQLCODE=100 s SQLCODE=0
    i SQLCODE goto UpdateErr
    &SQL(Update SQLUSER.DHC_PE_PreGADM Values :PLIST() 
        where PGADM_RowId = :RowId)
    i SQLCODE goto UpdateErr

    s OldGADMFeeType=$G(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",RowId))
    s ^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",RowId)=ADMFeeType  
    s SQLCODE=..GADMUpdateDate(RowId,gOldInfo)
    i SQLCODE goto UpdateErr
    //更新支付方式
    i OldChargedMode'=PLIST(17) 
    {   
        s SQLCODE=..UpdateChargedMode(RowId,PLIST(17))  //add
        
        i SQLCODE s SQLCODE=SQLCODE_"Charged"_FeeId goto UpdateErr
    }
            
    s ^DHCPEDataEx("DHCPEPreGADM","ADMType",RowId)=ADMType
    s ^DHCPEDataEx("DHCPEPreGADM","PayType",RowId)=PayType
    s ^DHCPEDataEx("DHCPEPreGADM","Percent",RowId)=Percent
    s ^DHCPEDataEx("DHCPEPreGADM","DietFlag",RowId)=DietFlag
    s ^DHCPEDataEx("DHCPEPreGADM","GiftFlag",RowId)=GiftFlag

    s ReportDate=$G(^DHCPEDataEx("DHCPEPreGADM","GetReportDateTime","G",RowId))
    i ReportDate'=""
    {
        k ^DHCPEDataEx("DHCPEPreGADM","GetReportDateTime","G",RowId)
        k ^DHCPEDataExi("DHCPEPreGADM","GetReportDateTime","G",+ReportDate,$P(ReportDate,"^",2),RowId)
    }
    i GetReportDate'=""
    {
        s ^DHCPEDataEx("DHCPEPreGADM","GetReportDateTime","G",RowId)=GetReportDate_"^"_GetReportTime
        s ^DHCPEDataExi("DHCPEPreGADM","GetReportDateTime","G",GetReportDate,GetReportTime,RowId)=""
    }
    
    
    
    i (OldAddOrdItem'=PLIST(9))||(OldLimitFee'=PLIST(11)) d  //修改公费加项设置
    .s iAdm=0
    .f  s iAdm=$o(^DHCPEPreIADM(0,"PGADM",RowId,iAdm)) q:(iAdm="")||(SQLCODE'=0)  d
    ..s SQLCODE=##class(web.DHCPE.PreAudit).UpdateFeeRecord(iAdm,"LimitFee")
    .q:SQLCODE
    .s SQLCODE=##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(RowId)
    i SQLCODE goto UpdateErr
    //修改就诊类型处理个人和团体费用
    //修改个人体检者项目或套餐对应的就诊类型
    i OldGADMFeeType'=ADMFeeType  d
    .s SQLCODE=##class(web.DHCPE.PreIADM).UpdateItemFeeType(RowId,"GROUP",ADMFeeType)
    TCOMMIT
    Q 0
UpdateErr
    TROLLBACK
    Q SQLCODE
}

/// 当团体组更改预约时间，更新其下所有成员的预约时间
ClassMethod GADMUpdateDate(RowID, gOldInfo)
{
 
    new Date,Time,User
    new iADM,iInfo,iDelayDate,iEndDate,iPEDeskClerk,iPLIST,iSales
    new tSub,tADM,tEndDate,tPEDeskClerk,tInfo,tPLIST
    new gInfo,gEndDate,gOldEndDate,gDelayDate,gOldDelayDate,gPEDeskClerk,gOldPEDeskClerk,gSales
    new EndDate,DelayDate,PEDeskClerk,Sales   
    s ADMFeeType=$G(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",RowId))
    s (EndDate,DelayDate,PEDeskClerk)=0
    s Date=+$H
    s Time=$p($h,",",2)
    s User=%session.Get("LOGON.USERID")
    s iADM=0
    s tSub=0
    s gInfo=$g(^DHCPEPreGADM(RowID))
    s gEndDate=..GetInfoByOrder(gInfo,3)
    i gEndDate="" s gEndDate=0
    s gOldEndDate=..GetInfoByOrder(gOldInfo,3)
    i gOldEndDate="" s gOldEndDate=0
    i gEndDate'=gOldEndDate s EndDate=1 
    
    s gDelayDate=..GetInfoByOrder(gInfo,17)
    i gDelayDate="" s gDelayDate=0
    s gOldDelayDate=..GetInfoByOrder(gOldInfo,17)
    i gOldDelayDate="" s gOldDelayDate=0
    i gDelayDate'=gOldDelayDate s DelayDate=1 
    
    s gOldType=$G(^DHCPEDataEx("DHCPEPreGADM","ADMType",RowID))
    s gOldGetDate=$G(^DHCPEDataEx("DHCPEPreGADM","GetReportDateTime","G",RowID))
    
    s gPEDeskClerk=..GetInfoByOrder(gInfo,5)
    s gOldPEDeskClerk=..GetInfoByOrder(gOldInfo,5)
    i gPEDeskClerk'=gOldPEDeskClerk s PEDeskClerk=1
    s gSales=..GetInfoByOrder(gInfo,22)
    s gOldSales=..GetInfoByOrder(gOldInfo,22)
    s SQLCODE=0
    f  s tSub=$o(^DHCPEPreGADM(RowID,"Team",tSub)) q:(tSub=""||SQLCODE'=0)  d
    .s tADM=RowID_"||"_tSub
    .k tPLIST
    .s tInfo=$G(^DHCPEPreGADM(RowID,"Team",tSub))
    .s tEndDate=..GetInfoByOrder(tInfo,5)
    .i tEndDate="" s tEndDate=0
    .i ((tEndDate<gEndDate)&&(1=EndDate)) s tPLIST(6)=gEndDate
    .s tPEDeskClerk=..GetInfoByOrder(tInfo,5)
    .i (gPEDeskClerk'=tPEDeskClerk)&&(1=PEDeskClerk) s tPLIST(7)=gPEDeskClerk
    .s AddOrdItem=$p(gOldInfo,"^",8)
    .if (OldLimitFee'=..GetInfoByOrder(gInfo,10)||(AddOrdItem'=..GetInfoByOrder(gInfo,8)))  d
    ..s tPLIST(8)=..GetInfoByOrder(gInfo,8)
    ..s tPLIST(9)=..GetInfoByOrder(gInfo,9)
    ..s tPLIST(10)=..GetInfoByOrder(gInfo,10)
    .s tPLIST(11)=..GetInfoByOrder(gInfo,11)
    .s tPLIST(12)=..GetInfoByOrder(gInfo,12)
    .s tPLIST(13)=..GetInfoByOrder(gInfo,13)
    .s tPLIST(18)=User
    .s tPLIST(19)=Date
    .s tPLIST(20)=Time
    .&SQL(update sqluser.DHC_PE_PreGTeam values :tPLIST() where PGT_RowId=:tADM)
    .q:SQLCODE'=0
    .;s ^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",tADM)=ADMFeeType
    .s iADM=0
    .f  s iADM=$o(^DHCPEPreIADM(0,"PGTeam",tADM,iADM)) q:(iADM=""||SQLCODE'=0)  d
    ..//取报告时间修改
    ..s ReportDate=$G(^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",iADM))
    ..i ReportDate=gOldGetDate d
    ...i ReportDate'="" d
    ....k ^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",iADM)
    ....k ^DHCPEDataExi("DHCPEPreIADM","GetReportDateTime","I",+ReportDate,$P(ReportDate,"^",2),iADM)
    ...i GetReportDate'="" d
    ....s ^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",iADM)=GetReportDate_"^"_GetReportTime
    ....s ^DHCPEDataExi("DHCPEPreIADM","GetReportDateTime","I",GetReportDate,GetReportTime,iADM)=""
    ..k iPLIST
    ..s iInfo=$g(^DHCPEPreIADM(iADM))
    ..s iDelayDate=..GetInfoByOrder(iInfo,19)
    ..i iDelayDate="" s iDelayDate=0
    ..i (iDelayDate<gDelayDate)&&(1=DelayDate) s iPLIST(20)=gDelayDate
    ..s iEndDate=..GetInfoByOrder(iInfo,5)
    ..i iEndDate="" s iEndDate=0
    ..i (iEndDate<gEndDate)&&(1=EndDate) s iPLIST(6)=gEndDate
    ..s iPEDeskClerk=..GetInfoByOrder(iInfo,7)
    ..i (gPEDeskClerk'=iPEDeskClerk)&&(1=PEDeskClerk) s iPLIST(8)=gPEDeskClerk
    ..s iSales=..GetInfoByOrder(iInfo,24)
    ..i (gOldSales'=gSales)&&(iSales=gOldSales) s iPLIST(25)=gSales
    ..//类型修改
    ..s iType=..GetInfoByOrder(iInfo,25)
    ..i (iType=gOldType) s iPLIST(26)=ADMType
    ..s iPLIST(10)=..GetInfoByOrder(gInfo,7)
    ..if (OldLimitFee'=..GetInfoByOrder(gInfo,10)||(AddOrdItem'=..GetInfoByOrder(gInfo,8)))  d
    ...s iPLIST(11)=..GetInfoByOrder(gInfo,8)
    ...s iPLIST(12)=..GetInfoByOrder(gInfo,9)
    ...s iPLIST(13)=..GetInfoByOrder(gInfo,10)
    ..s iPLIST(14)=..GetInfoByOrder(gInfo,11)
    ..s iPLIST(15)=..GetInfoByOrder(gInfo,12)
    ..s iPLIST(16)=..GetInfoByOrder(gInfo,13)
    ..s iPLIST(17)=..GetInfoByOrder(gInfo,15)
    ..s iPLIST(18)=..GetInfoByOrder(gInfo,16)
    ..
    ..s iPLIST(23)=Date
    ..s iPLIST(22)=User
    ..s iPLIST(24)=Time
    ..&SQL(update sqluser.DHC_PE_PreIADM values :iPLIST() where PIADM_RowId=:iADM)
    ..i SQLCODE=0 d
    ...;s ^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",iADM)=ADMFeeType

    q SQLCODE
    
    
    /*s ReportDate=$G(^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",RowId))
    i ReportDate'=""
    {
        k ^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",RowId)
        k ^DHCPEDataExi("DHCPEPreIADM","GetReportDateTime","I",+ReportDate,$P(ReportDate,"^",2),RowId)
    }
    i GetReportDate'=""
    {
        s ^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",RowId)=GetReportDate_"^"_GetReportTime
        s ^DHCPEDataExi("DHCPEPreIADM","GetReportDateTime","I",GetReportDate,GetReportTime,RowId)=""
    }*/
}

ClassMethod UpdateTeamInfoByGADM(gOldInfo, GADM)
{
    new gInfo,gDelayDate,gEndDate
    new gAddOrdItem,gAddOrdItemLimit,gAddOrdItemAmount
    new gAddPhcItem,gAddPhcItemLimit,gAddPhcItemAmount
    new tSub,tADM,tInfo,tPLIST
    s tSub=0
    
    //s gDelayDate=..GetInfoByOrder(gInfo,17)
    //i gDelayDate="" s gDelayDate=0
    s gEndDate=..GetInfoByOrder(gInfo,3)
    i gEndDate="" s gEndDate=0
    s gAddOrdItem=..GetInfoByOrder(gInfo,8)
    s gAddOrdItemLimit=..GetInfoByOrder(gInfo,9)
    s gAddOrdItemAmount=..GetInfoByOrder(gInfo,10)
    s gAddPhcItem=..GetInfoByOrder(gInfo,11)
    s gAddPhcItemLimit=..GetInfoByOrder(gInfo,12)
    s gAddPhcItemAmount=..GetInfoByOrder(gInfo,13)
    //s gAsCharged=..GetInfoByOrder(gInfo,7)
    f  s tSub=$o(^DHCPEPreGADM(GADM,"Team",tSub)) q:(tSub=""||SQLCODE'=0)  d
    .s tADM=GADM_"||"_tSub
    .k tPLIST
    .s tInfo=$G(^DHCPEPreGADM(RowID,"Team",tSub))
    .//s tDelayDate=..GetInfoByOrder(tInfo,19)
    .//i tDelayDate="" s tDelayDate=0
    .//i ((gDelayDate'=PLIST(18))&&(tDelayDate<gDelayDate)) s tPLIST(20)=gDelayDate
    .s tEndDate=..GetInfoByOrder(tInfo,5)
    .i tEndDate="" s tEndDate=0
    .i ((gEndDate'=PLIST(4))&&(tEndDate<gEndDate)) s tPLIST(6)=gEndDate
    .
}

ClassMethod GetInfoByOrder(Info, Order)
{
    i Info="" q ""
    q $p(Info,"^",Order)
}

ClassMethod Save2Old(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
    
    s ^xwmTemp("Save2")=InString
    
    s iLLoop=1
    // PGADM_RowId  1
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(1)=value
    
    s iLLoop=iLLoop+1
    // PGADM_PGBI_DR    预团体客户RowId 2
    s value=$p(InString,"^",iLLoop)
    s PLIST(2)=value
    
    // PGADM_AsCharged  视同收费 3
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(3)=value
    
    // PGADM_BookDateBegin  预约日期 4
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    i (""'=value) s value=$ZDATEH(value,4)
    s PLIST(4)=value

    // PGADM_BookTime   预约时间 5
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    i (""'=value) s value=$ZTH(value,2)
    s PLIST(5)=value
    
    // PGADM_Remark 备注 6
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(6)=value

    // PGADM_ContractNo 合同编号  7
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(7)=value
        
    // PGADM_Status 状态 8
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(8)=value

    //应收金额 PGADM_AccountAmount  9
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(9)=value
    
    //打折后金额 PGADM_DiscountedAmount  10
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(10)=value
    
    //最终金额 PGADM_FactAmount 11
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(11)=value
    
    //审核人 PGADM_AuditUserDR 12
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(12)=value

    //审核日期 PGADM_AuditDate  13
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(13)=value

    //更改人 PGADM_UpdateUserDR        14
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(14)=value

    //更改日期 PGADM_UpdateDate         15
    s iLLoop=iLLoop+1
    //s value=$p(InString,"^",iLLoop)
    s PLIST(15)=+$H

    // 预约接待人员 PGADM_PEDeskClerk_DR      16
    s PEDeskClerkDR=$p(InString,"^",iLLoop)
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(16)=value

    // 销售金额 PGADM_SaleAmount        17
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(17)=value

    // 收费状态 PGADM_ChargedStatus     18
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(18)=value
    
    // 审核状态 PGADM_CheckedStatus     19
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(19)=value
    
    // 允许加项 PGADM_AddOrdItem        20
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(20)=value
    
    // 加项金额限制 PGADM_AddOrdItemLimit     21
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(21)=value
    
    // 允许加项金额 PGADM_AddOrdItemAmount        22
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(22)=value
    
    // 允许加药 PGADM_AddPhcItem        23
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(23)=value
    
    // 加药金额限制 PGADM_AddPhcItemLimit     24
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(24)=value
    
    // 允许加药金额  PGADM_AddPhcItemAmount       25
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(25)=value
    
    // 团体报告发送 PGADM_GReportSend     26
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(26)=value
    
    // 个人报告发送 PGADM_IReportSend     27
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(27)=value
    
    // 结算方式 PGADM_DisChargedMode        28
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    s PLIST(28)=value
    
    // PGADM_BookDateEnd        29
    s iLLoop=iLLoop+1
    s value=$p(InString,"^",iLLoop)
    i (""'=value) s value=$ZDATEH(value,4)
    s PLIST(29)=value

    s ret=..ISave2()
    s ^xwmTemp("Save2 ret")=ret
    q ret
}

ClassMethod Insert2Old()
{
    k PLIST(1)          // PGADM_RowId
    s PLIST(8)="PREREG"     // PGADM_Status 状态状态-预登记
    s PLIST(18)="UNCHARGED" // PGADM_ChargedStatus  收费状态-未收费
    s PLIST(19)="UNCHECKED" // PGADM_CheckedStatus  审核状态-未审核
    k PLIST(12)         // PGADM_AuditUser_DR   审核人
    k PLIST(13)         // PGADM_AuditDate  审核日期
    k PLIST(9)          // PGADM_AccountAmount 应收金额
    k PLIST(10)         // PGADM_DiscountedAmount 打折后金额
    k PLIST(17)         // PGADM_SaleAmount 销售金额
    
    &SQL(Insert Into SQLUSER.DHC_PE_PreGADM Values :PLIST())
    q SQLCODE_"^"_%ROWID
}

ClassMethod Update2Old()
{
    s RowId=PLIST(1)
    TStart
    s ret=..GADMUpdateDate()
    i '(("0"=ret)||("100"=ret)) goto UpdateErrOld   
    k PLIST(1)          // PGADM_RowId
    k PLIST(12)         // PGADM_AuditUser_DR   审核人
    k PLIST(13)         // PGADM_AuditDate  审核日期
    
    &SQL(Update SQLUSER.DHC_PE_PreGADM Values :PLIST() 
        where PGADM_RowId = :RowId)
    
    i '(("0"=ret)||("100"=ret)) goto UpdateErrOld
    TCOMMIT
    Q 0
UpdateErrOld
    TROLLBACK
    Q ret
}

ClassMethod GADMUpdateDateOld()
{
    
    s CurData=$G(^DHCPEPreGADM(PLIST(1)))
    s OBookDate=$p(CurData,"^",3)
    s OBookTime=$p(CurData,"^",4)
    
    s ret="0"
    /*0329
    i OBookDate'=PLIST(4) d
    .&sql(update DHC_PE_PreIADM
        set PIADM_PEDateBegin = :PLIST(4)
        where PIADM_PGADM_DR = :RowId
        )*/
    .s ret=SQLCODE
    Q:('(("0"=ret)||("100"=ret))) ret
    /*
    s ret="0"
    i OBookDate'=PLIST(4) d
    .&sql(update DHC_PE_PreGTeam
        set PGT_BookDate = :PLIST(4)
        where PGT_ParRef = :RowId
        )
    .s ret=SQLCODE
    
    Q:('(("0"=ret)||("100"=ret))) ret
    
    s ret="0"
    i OBookTime'=PLIST(5) d
    .&sql(update DHC_PE_PreIADM
        set PIADM_PETime = :PLIST(5)
        where PIADM_PGADM_DR = :RowId
        )
    .s ret=SQLCODE
    Q:('(("0"=ret)||("100"=ret))) ret   
    
    s ret="0"
    i OBookTime'=PLIST(5) d
    .&sql(update DHC_PE_PreGTeam
        set PGT_BookTime = :PLIST(5)
        where PGT_ParRef = :RowId
        )
    .s ret=SQLCODE
    */
    Q ret
}

Query GAdmBookList(Desc As %String) As %SQLQuery(ROWSPEC = "PGBI_Desc:%String, PGBI_Code:%String,PGADM_BookDateBegin:%Date, PGADM_BookDateEnd:%Date,PGBI_BookTime:%Time, PGBI_RowId:%String")
{
    select PGADM_PGBI_DR->PGBI_Desc,PGADM_PGBI_DR->PGBI_Code,
           PGADM_BookDateBegin,PGADM_BookDateEnd,PGADM_BookTime,PGADM_RowId  
    From DHC_PE_PreGADM
    where PGADM_Status='PREREG'
}

/// 生成一个页面元素　显示当前的团体组列表 使用组件 DHCPEPreIADM.Team
/// d ##class(web.DHCPE.PreGADM).OutVocationToHTML()
ClassMethod OutVocationToHTML() As %String
{
    //下拉列表
    w "<select name='Vocation' id='Vocation' style='width:"_"119"_"' HEIGHT=0>",!
    w "<option value=''>  </option>",!
    
    w "<option value='商务人员'>商务人员</option>",!
    w "<option value='职员,公务员'>职员,公务员</option>",!
    w "<option value='离退休人员'>离退休人员</option>",!
    w "<option value='干部'>干部</option>",!
    w "<option value='其他'>其他</option>",!
        
    w "</select>",!
    Quit $$$OK
}

ClassMethod GetOldDate(ID, Type)
{
    new OldDate,DelayDate
    i ID="" q ""
    i Type="Pre"
    {
        s OldDate=$P($G(^DHCPEPreIADM(ID)),"^",5)
        s DelayDate=$P($G(^DHCPEPreIADM(ID)),"^",19)
    }
    i Type="Item"
    {
        s OldDate=$P($G(^DHCPEPreGADM(ID)),"^",3)
        s DelayDate=$P($G(^DHCPEPreGADM(ID)),"^",17)
    }
    i DelayDate'="" s OldDate=DelayDate
    i OldDate'="" s OldDate=##class(websys.Conversions).DateLogicalToHtml(OldDate)
    q OldDate
}

/// 修改团体预约的状态
ClassMethod UpdateStatus(ID, Status)
{
    TSTART
    &SQL(update sqluser.DHC_PE_PreGADM set PGADM_Status=:Status where PGADM_RowId=:ID)
    s User=%session.Get("LOGON.USERID")
    d:Status="PREREG" ##class(web.DHCPE.GAdmRecordManager).Insert(ID,"P","PREInsert",User,"")
    d:Status="CANCELPREREG" ##class(web.DHCPE.GAdmRecordManager).Insert(ID,"P","CANCELPREREG",User,"")
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    &SQL(update sqluser.DHC_PE_PreIADM set PIADM_Status=:Status where PIADM_PGADM_DR=:ID)
    s User=%session.Get("LOGON.USERID")
    s PIADM=""
    f  s PIADM=$o(^DHCPEPreIADM(0,"PGADM",ID,PIADM)) q:PIADM=""  d
    .d ##class(web.DHCPE.AdmRecordManager).Insert(PIADM,"P","CANCELPREREG",User,"")
    i SQLCODE=100 s SQLCODE=0
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    
    TCOMMIT

    q SQLCODE
}

/// 根据ID得到状态
ClassMethod GetStatus(ID)
{
    i ID="" q ""
    q $p($G(^DHCPEPreGADM(ID)),"^",6)
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.PreGADM","SearchPreGADMShort","","1","dhcpepreiadmfind.hisui.csp")
Query SearchPreGADMShort(Code As %String = "", ShowPersonGroup As %String = "0", CSPName As %String = "") As %Query(ROWSPEC = "Name:%String:团体名称,Hidden:%String,Code:%String:编码,Begin:%String:预约开始日期,End:%String:预约截止日期,DelayDate:%String:状态")
{
}

ClassMethod SearchPreGADMShortExecute(ByRef qHandle As %Binary, Code As %String = "", ShowPersonGroup As %String = "0", CSPName As %String = "") As %Status
{
    s ^tempdhcpe("SearchPreGADMShort")=$lb(Code,ShowPersonGroup,CSPName)
    Set repid=$I(^CacheTemp)
    s ind=1
    s Code=##class(web.DHCPE.DHCPECommon).UnEscape(Code)
    s:Code'="" Code=$ZCVT(Code,"U")
    
    i ShowPersonGroup="1" d
    .s (PGADMPGBIDRName, id,PGADMPGBIDRCode,PGADMBookDateBegin, PGADMBookDateEnd,PGADMDelayDate,PGADMStatusDesc)=""
    .s id="ALLI"
    .s PGADMPGBIDRName="所有个人"
    .d FindBuildSearchPreGADMShortExecute
    .s id="ALLG"
    .s PGADMPGBIDRName="所有团体"
    .d FindBuildSearchPreGADMShortExecute
 
    s id="" //不能使用空字符串开始 s id="" ,否则会取到 0
    f  s id=$o(^DHCPEPreGADM(id),-1) q:(id="")||(id=0)  d
    .s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PGADM",id)   //add 2009-07-07 
    .q:LocFlag=1 
    .s (PGADMPGBIDR, PGADMPGBIDRCode, PGADMPGBIDRName, PGADMAsCharged, PGADMBookDateBegin, PGADMBookDateEnd, PGADMBookTime, PGADMRemark, PGADMContractNo, PGADMStatus, PGADMStatusDesc, PGADMAccountAmount, PGADMDiscountedAmount, PGADMFactAmount, PGADMAuditUserDR, PGADMAuditUserDRName, PGADMAuditDate, PGADMUpdateUserDR, PGADMUpdateUserDRName, PGADMUpdateDate, PGADMPEDeskClerkDR, PGADMPEDeskClerkDRName, PGADMSaleAmount, PGADMChargedStatus, PGADMChargedStatusName, PGADMCheckedStatus, PGADMCheckedStatusName, PGADMAddOrdItem, PGADMAddOrdItemLimit, PGADMAddOrdItemAmount, PGADMAddPhcItem, PGADMAddPhcItemLimit, PGADMAddPhcItemAmount, PGADMGReportSend, PGADMGReportSendName, PGADMIReportSend, PGADMIReportSendName, PGADMDisChargedMode, PGADMDisChargedModeName,PGADMDelayDate)=""
    .s CurData=$g(^DHCPEPreGADM(id))
    .Q:(""=CurData)
    .s iLLoop=1
    .// PGADM_PGBI_DR   预团体客户 RowId 1
    .s PGADMPGBIDR=$p(CurData,"^",iLLoop)
    .i ""'=PGADMPGBIDR d
    ..// DHC_PE_PreGBaseInfo
    ..s PGADMPGBIDRCode=$p($g(^DHCPEPreGBI(PGADMPGBIDR)),"^",1)
    ..s PGADMPGBIDRName=$p($g(^DHCPEPreGBI(PGADMPGBIDR)),"^",2)
    .e  d
    ..s PGADMPGBIDRCode=""
    ..s PGADMPGBIDRName=""
    .;Q:(""'=Code)&(PGADMPGBIDRCode'[Code)&(PGADMPGBIDRName'[Code)
    .s TNamePY=##class(web.DHCINSUPort).GetCNCODE(PGADMPGBIDRName,4,"")
    .i (""'=Code) d
    ..s ParaTNamePY=##class(web.DHCINSUPort).GetCNCODE(Code,4,"")
    .e  d
    ..s ParaTNamePY=""
    .q:(""'=ParaTNamePY)&('(TNamePY[ParaTNamePY))
    .;q:((""'=Code)&('(($ZCVT(Code,"U")[PGADMPGBIDRName)||(TNamePY[Code))))
    .s iLLoop=iLLoop+1
    .// PGADM_BookDateBegin 预约体检日期 3
    .s PGADMBookDateBegin=$p(CurData,"^",iLLoop)
    .i ""'=PGADMBookDateBegin s PGADMBookDateBegin=##class(websys.Conversions).DateLogicalToHtml(PGADMBookDateBegin)
    .s iLLoop=iLLoop+1
    .// PGADM_BookDateEnd   28
    .s PGADMBookDateEnd=$p(CurData,"^",iLLoop)
    .i ""'=PGADMBookDateEnd s PGADMBookDateEnd=##class(websys.Conversions).DateLogicalToHtml(PGADMBookDateEnd)
    .s iLLoop=iLLoop+1
    .// PGADM_BookTime  预约体检时间 4
    .s PGADMBookTime=$p(CurData,"^",iLLoop)
    .i ""'=PGADMBookTime s PGADMBookTime=$ZT(PGADMBookTime,2)
    .s iLLoop=iLLoop+1
    .// PGADM_PEDeskClerk_DR    预约接待人员 15
    .s PGADMPEDeskClerkDR=$p(CurData,"^",iLLoop)
    .i ""'=PGADMPEDeskClerkDR d
    ..s PGADMPEDeskClerkDRName=$p($g(^SSU("SSUSR",PGADMPEDeskClerkDR)),"^",2)
    .e  d
    ..s PGADMPEDeskClerkDRName=""
    .s iLLoop=iLLoop+1
    .// PGADM_Status 登记状态 7
    .s PGADMStatus=$p(CurData,"^",iLLoop)
    .s PGADMDelayDate=PGADMStatus
    .q:PGADMStatus="CANCELPE"
    .q:PGADMStatus="CANCELPREREG"
    .s:(""'=PGADMStatus) PGADMStatusDesc=##Class(web.DHCPE.PreCommon).TransStatus(PGADMStatus)
    .s:(""=PGADMStatus) PGADMStatusDesc=""
    .s iLLoop=iLLoop+1
    .// PGADM_AsCharged 视同收费 2
    .s PGADMAsCharged=$p(CurData,"^",iLLoop)
    .s iLLoop=iLLoop+1
    .// PGADM_AddOrdItem    允许加项 19
    .s PGADMAddOrdItem=$p(CurData,"^",iLLoop)
    .s iLLoop=iLLoop+1
    .// PGADM_AddOrdItemLimit   加项金额限制 20
    .s PGADMAddOrdItemLimit=$p(CurData,"^",iLLoop)
    .s iLLoop=iLLoop+1
    .// PGADM_AddOrdItemAmount  允许加项金额 21
    .s PGADMAddOrdItemAmount=$p(CurData,"^",iLLoop)
    .s iLLoop=iLLoop+1
    .// PGADM_AddPhcItem    允许加药 22
    .s PGADMAddPhcItem=$p(CurData,"^",iLLoop)
    .s iLLoop=iLLoop+1
    .// PGADM_AddPhcItemLimit   加药金额限制 23
    .s PGADMAddPhcItemLimit=$p(CurData,"^",iLLoop)
    .s iLLoop=iLLoop+1
    .// PGADM_AddPhcItemAmount  允许加药金额 24
    .s PGADMAddPhcItemAmount=$p(CurData,"^",iLLoop)
    .s iLLoop=iLLoop+1
    .// PGADM_GReportSend   团体报告发送 25
    .s PGADMGReportSend=$p(CurData,"^",iLLoop)
    .s:(""'=PGADMGReportSend) PGADMGReportSendName =##Class(web.DHCPE.PreCommon).TransGReportSend(PGADMGReportSend)
    .s:(""=PGADMGReportSend) PGADMGReportSendName = ""
    .s iLLoop=iLLoop+1
    .// PGADM_IReportSend   个人报告发送 26
    .s PGADMIReportSend=$p(CurData,"^",iLLoop)
    .s:(""'=PGADMIReportSend) PGADMIReportSendName =##Class(web.DHCPE.PreCommon).TransIReportSend(PGADMIReportSend)
    .s:(""=PGADMIReportSend) PGADMIReportSendName = ""
    .s iLLoop=iLLoop+1
    .// PGADM_DisChargedMode    结算方式 27
    .s PGADMDisChargedMode=$p(CurData,"^",iLLoop)
    .s:(""'=PGADMDisChargedMode) PGADMDisChargedModeName =##Class(web.DHCPE.PreCommon).TransDisChargedMode(PGADMDisChargedMode)
    .s:(""=PGADMDisChargedMode) PGADMDisChargedModeName = ""
    .s iLLoop=iLLoop+1
    .// PGADM_DelayDate 28
    .//s PGADMDelayDate=$p(CurData,"^",iLLoop)
    .//i ""'=PGADMDelayDate s PGADMDelayDate=$ZD(PGADMDelayDate,4)
    .s iLLoop=iLLoop+1
    .// PPGADM_Remark   备注 5
    .s PPGADMRemark=$p(CurData,"^",iLLoop)
    .s iLLoop=iLLoop+1
    .// PGADM_UpdateUser_DR 13
    .s PGADMUpdateUserDR=$p(CurData,"^",iLLoop)
    .i ""'=PGADMUpdateUserDR d
    ..s PGADMUpdateUserDRName=$p($g(^SSU("SSUSR",PGADMUpdateUserDR)),"^",2)
    .e  d
    ..s PGADMUpdateUserDRName=""
    .s iLLoop=iLLoop+1
    .// PGADM_UpdateDate 14
    .s PGADMUpdateDate=$p(CurData,"^",iLLoop)
    .i ""'=PGADMUpdateDate s PGADMUpdateDate=##class(websys.Conversions).DateLogicalToHtml(PGADMUpdateDate)
    .
    .s iLLoop=iLLoop+1
    .d FindBuildSearchPreGADMShortExecute
        
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
FindBuildSearchPreGADMShortExecute
   if ((PGADMPGBIDRName="所有个人")||(PGADMPGBIDRName="所有团体")){
        s PGADMPGBIDRName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,PGADMPGBIDRName)
    }else{
        //s:PGADMPGBIDRName'="" PGADMPGBIDRName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEPreGBaseInfo",PGADMPGBIDRName,"PGBIDesc","cls") 
    }
    i PGADMStatusDesc'="" s PGADMStatusDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,PGADMStatusDesc)
    set Data=$lb(PGADMPGBIDRName, $g(id),PGADMPGBIDRCode ,  PGADMBookDateBegin, PGADMBookDateEnd,PGADMStatusDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
    //
}

ClassMethod SearchPreGADMShortFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPreGADMShortExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod SearchPreGADMShortClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPreGADMShortExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Description: 取消/视同收费
/// Input:       RowID:个人或团体预约ID, Type:I/G, UserID：操作人ID
/// Return：
/// debug: d ##class(web.DHCPE.PreGADM).UpdateAsCharged("367^^","I","")
ClassMethod UpdateAsCharged(RowID, Type, UserID As %String = "")
{
    //S ^tempdhcpe("UpdateAsCharged")=$LB(RowID, Type, UserID)
    s AsType=$P(RowID,"^",2)
    s AsRemark=$P(RowID,"^",3)
    s RowID=$P(RowID,"^",1)
    i Type="G"
    {
        s Status=$p($g(^DHCPEPreGADM(RowID)),"^",6)
        s OldAsCharged=$p($g(^DHCPEPreGADM(RowID)),"^",7)
        s AsCharged="Y"
        i OldAsCharged="Y" s AsCharged="N"
    }
    elseif Type="I"
    {
        s Status=$p($g(^DHCPEPreIADM(RowID)),"^",8)
        s OldAsCharged=$p($g(^DHCPEPreIADM(RowID)),"^",9)
        s AsCharged="Y"
        i OldAsCharged="Y" s AsCharged="N"
    }
    q:(Status="CANCELPE") "StatusErr"  
    
    s ExcuteFlag=0
    i AsCharged="N" d
    .s ExcuteFlag=##class(web.DHCPE.PreIADM).IsExcuteByAsCharged(Type,RowID)
    q:ExcuteFlag=1 "ExcuteErr"
    
    s DispensMedFlag=0
    
    i AsCharged="N" d
    .s DispensMedFlag=##class(web.DHCPE.ItemFeeList).IsMedicalDispensing(Type,RowID)
    q:DispensMedFlag=1 "MedErr"

    TSTART
    if Type="G"
    {
        &SQL(Update sqluser.DHC_PE_PreGADM set PGADM_AsCharged=:AsCharged where PGADM_RowId=:RowID)
        Goto:SQLCODE'=0 Err
        &SQL(Update sqluser.DHC_PE_GADM set GADM_AsCharged=:AsCharged where GADM_CRMGADM=:RowID)
        s:SQLCODE=100 SQLCODE=0
        Goto:SQLCODE<0 Err
        s SQLCODE=##class(web.DHCPE.PreIADM).UpdateItemAsCharged(RowID,AsCharged,"G")
        S:SQLCODE=100 SQLCODE=0
    }
    elseif Type="I"
    {
        s SQLCODE=##class(web.DHCPE.PreIADM).UpdateItemAsCharged(RowID,AsCharged,"I")
        S:SQLCODE=100 SQLCODE=0
    }
    Goto:SQLCODE'=0 Err
    i AsCharged="N" d
    .k ^DHCPEDataEx("AsCharged",Type,RowID)
    e  d
    .s ^DHCPEDataEx("AsCharged",Type,RowID)=AsType_"^"_AsRemark_"^"_UserID_"^"_$H
    TCOMMIT
    q SQLCODE
    
Err
    TROLLBACK
    q "SQLErr"
}

/// w ##class(web.DHCPE.PreGADM).GetAdmList("21","G")
ClassMethod GetAdmList(ID, Type, VIPLevel As %String = "")
{
    q:ID="" ""
    s job=$j
    k ^DHCPESortTemp(job)
    s List=""
    i Type="G"
    {
        q ##class(web.DHCPE.PrintGroupPerson).GetPreGPerson(ID,"Y","",VIPLevel)
    }
    i Type="G" d
    .s id=0
    .f  s id=$O(^DHCPEPreGADM(ID,"Team",id)) q:id=""  d
    ..s TeamID=ID_"||"_id
    ..d GetAdmListByTeam
    e  d
    .s TeamID=ID
    .d GetAdmListByTeam
    
    /*s curRegNo=0
    f  s curRegNo=$o(^DHCPESortTemp(job,curRegNo)) q:curRegNo=""  d
    .s curAdm=0
    .f  s curAdm=$o(^DHCPESortTemp(job,curRegNo,curAdm)) q:curAdm=""  d
    ..s str=$G(^DHCPESortTemp(job,curRegNo,curAdm))
    ..i List="" d
    ...s List=str
    ..e  d
    ...s List=List_"^"_str
    k ^DHCPESortTemp(job)*/
    q List
GetAdmListByTeam
    s Iid=0
    f  s Iid=$o(^DHCPEPreIADM(0,"PGTeam",TeamID,Iid)) q:Iid=""  d
    .s Status=$P($G(^DHCPEPreIADM(Iid)),"^",8)
    .q:Status="CANCELPREREG"
    .q:Status="CANCELPE"
    .s CurVIPLevel=$P($G(^DHCPEPreIADM(Iid)),"^",18)
    .q:(VIPLevel'="")&&(CurVIPLevel'=VIPLevel)
    .i List="" d
    ..s List=Iid
    .e  d
    ..s List=List_"^"_Iid
    /*.s BaseId=$p(^DHCPEPreIADM(Iid),"^",1)
    .s RegNo=$P($g(^DHCPEPreIBI(BaseId)),"^",1)
    .s ^DHCPESortTemp(job,RegNo,Iid)=Iid
    */
    ;w !,List
    q
}

/// Adm预约RowId
ClassMethod GetReportStatus(Adm, Type)
{
    new RPId,RType,Status
    s Status="NA"
    i Type="G" d
    .s Adm=$o(^DHCPEGADM(0,"CRMGADM",Adm,0))
    e  d
    .s Adm=$o(^DHCPEIADM(0,"CRMADM",Adm,0))
    q:Adm="" Status
    s RType="IADM"
    i Type="G" s RType="GADM"
    s RPId=$o(^DHCPERPT(0,RType,Adm,0))
    q:RPId="" Status
    s Status=$p(^DHCPERPT(RPId),"^",2)
    q Status
}

/// get a customer's amount
ClassMethod GetDetailForGPerson(GInfor, AdmInfor, FeeType)
{
    ;For one PE;TotalAmount,GShareAmount,IShareAmount,
    s admType=%request.Get("AdmType"),admId=%request.Get("AdmId")  s str=##class(web.DHCPE.PreItemList).IGetOrdAmount(admId,admType) s val="应收金额:"_$P(str,"优惠金额",2)
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.PreGADM","HadCheckedList")
Query HadCheckedList(CheckItemStatus As %String = "", ChargeStatus As %String = "", GroupID As %String = "", HadCheckType As %String = "Y", DateFrom As %String = "", DateTo As %String = "", DepartName As %String = "", RegNo As %String = "", Name As %String = "", SessionStr, TeamID As %String = "") As %Query(ROWSPEC = "TSort:%String,TGroupName:%String, TTeamName:%String,TRegNo:%String,TName:%String,TSex:%String,TAge:%String,TDepName:%String,TAmount:%String,TApAmount:%String,TIAmt:%String,FItemAmt:%String,FEntAmt:%String,TTel:%String,TArrivedDate:%String,TCardDesc:%String,TIDCard:%String,TReportStatus:%String,TPAADM:%String,HPNo:%String")
{
}

ClassMethod HadCheckedListExecute(ByRef qHandle As %Binary, CheckItemStatus As %String = "", ChargeStatus As %String = "", GroupID As %String = "", HadCheckType As %String = "Y", DateFrom As %String = "", DateTo As %String = "", DepartName As %String = "", RegNo As %String = "", Name As %String = "", SessionStr, TeamID As %String = "") As %Status
{
    s ^tempdhcpe("HadCheck")=$lb(CheckItemStatus,ChargeStatus,GroupID,HadCheckType,DateFrom,DateTo,DepartName,RegNo,Name,SessionStr,TeamID) 
    Set repid=$I(^CacheTemp)
    s ind=1
    s TotalAmount=0,TotalIAmt=0,TotalApAmount=0,TotalEntAmt=0
    
    s i=0
    
    s CurUserID=$p(SessionStr,"^",1)
    s HospID=$p(SessionStr,"^",4)
    s LocID=$p(SessionStr,"^",3)
 
    k ^DHCPETmpHadCheck(CurUserID)
    i DateFrom'="" s DateFrom=##class(websys.Conversions).DateHtmlToLogical(DateFrom)
    i DateTo'="" s DateTo=##class(websys.Conversions).DateHtmlToLogical(DateTo)
    s CurData=$g(^DHCPEPreGADM(+GroupID))
    s GroupDesc=""

    i ""'=CurData  d
    .s PGADMPGBIDR = $p(CurData,"^",1)
    .i ""'=PGADMPGBIDR d   
    ..s GroupDesc=$p($g(^DHCPEPreGBI(PGADMPGBIDR)),"^",2) //团体名称
    i TeamID'="" d
    .d TeamHadChecked(TeamID)
    e  d
    .s Sub=0
    .f  s Sub=$O(^DHCPEPreGADM(GroupID,"Team",Sub)) q:Sub=""  d
    ..d TeamHadChecked(GroupID_"||"_Sub)
    
    s (TeamDesc,IRegNo,IName,ISexDRName,IAge,IDepName,OneAmount,TApAmount,FEntAmt,PIBITel,ArriveDate,PACCardDesc,PIBIIDCard,ReportStatus,PAADM,HPNo)=""
    s GroupDesc="合计"
    s FItemAmt=TotalAmount
    s IAmt=TotalIAmt
    s TApAmount=TotalApAmount
    s FEntAmt=TotalEntAmt
    d HadCheckedListExecute
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
TeamHadChecked(TeamID)
    S RegDate=""
    s iAdm=0
    s TeamDesc=$p($G(^DHCPEPreGADM(+TeamID,"Team",$p(TeamID,"||",2))),"^",1)
    f  s iAdm=$o(^DHCPEPreIADM(0,"PGTeam",TeamID,iAdm)) q:iAdm=""  d
    .s Status=$p($g(^DHCPEPreIADM(iAdm)),"^",8)
    .q:Status="CANCELPREREG"
    .;q:Status="CANCELPE"
    .s PEIADM=$o(^DHCPEIADM(0,"CRMADM",iAdm,0))
    .i HadCheckType'="C" d
    ..q:PEIADM=""
    ..s ShowFlag="Y"
    ..s PreChargeStatus=""
    ..s PreChargeStatus=##class(web.DHCPE.HandlerPreOrds).GetPaiedFlag(iAdm)
    ..i (PreChargeStatus="3")||(PreChargeStatus="5") s PreChargeStatus="0"
    ..i PreChargeStatus="4" s PreChargeStatus="2"
    ..q:((PreChargeStatus'="")&&(ChargeStatus'="")&&(ChargeStatus'=PreChargeStatus))
    ..s PAADM=$p($G(^DHCPEIADM(PEIADM)),"^",1)
    ..s UnAppedItemsFlag=""
    ..s UnAppedItemsFlag=##class(web.DHCPE.ResultEdit).GetUnAppedItems("",PAADM,"N","1")
    ..i UnAppedItemsFlag'="" s UnAppedItemsFlag="1"
    ..e  s UnAppedItemsFlag="2"
    ..q:(CheckItemStatus'="")&&(UnAppedItemsFlag'=CheckItemStatus)
    
    ..i HadCheckType="Y" d
    ...i PEIADM=""  s ShowFlag="N"
    ...q:PEIADM=""
    ...s PAADM=$p($G(^DHCPEIADM(PEIADM)),"^",1)
    ...S RegDate=$p($G(^DHCPEIADM(PEIADM)),"^",5)
    ...i (DateFrom'="")&&(DateFrom>RegDate) s ShowFlag="N"
    ...i (DateTo'="")&&(DateTo<RegDate)  s ShowFlag="N"
    ...q:PAADM=""
    ...q:ShowFlag="N"
    ...;i (##class(web.DHCPE.PreGTeam).OrderIsExecByPAAdm(PAADM)=0) s ShowFlag="N"
    ...;s:'$D(^DHCPERLT(0,"ADM",PAADM)) ShowFlag="N"
    ...//按照"团体已检规则"配置判断
    ...s ShowFlag=##class(web.DHCPE.PreGADM).IsOrderExecuted(PAADM)
    ...d GetBaseInfo
    ..e  i HadCheckType="N" d
    
    ...i PEIADM=""  s ShowFlag="Y"
    ...i Status="CANCELPE" s ShowFlag="N"
    ...q:PEIADM=""
    ...s PAADM=$p($G(^DHCPEIADM(PEIADM)),"^",1)
    ...S RegDate=$p($G(^DHCPEIADM(PEIADM)),"^",5)
    ...i (DateFrom'="")&&(DateFrom>RegDate) s ShowFlag="N"
    ...i (DateTo'="")&&(DateTo<RegDate) s ShowFlag="N"
    ...q:PAADM=""
    ...q:ShowFlag="N"
    ...s:$D(^DHCPERLT(0,"ADM",PAADM)) ShowFlag="N"
    ...d GetBaseInfo
    
    .e  i HadCheckType="C" d
    ..i Status="CANCELPE"  s ShowFlag="Y"
    ..e  s ShowFlag="N"
    ..q:ShowFlag="N"
    ..S RegDate=""
    ..i PEIADM'="" d
    ...S RegDate=$p($G(^DHCPEIADM(PEIADM)),"^",5)
    ..q:(DateFrom'="")&&(RegDate'="")&&(DateFrom>RegDate) 
    ..q:(DateTo'="")&&(RegDate'="")&&(DateTo<RegDate)
    ..s PAADM=""
    ..d GetBaseInfo
    
GetBaseInfo
    q:ShowFlag="N"
    Q:iAdm=""
    s i=i+1
    s PreIBaseId=$p($G(^DHCPEPreIADM(iAdm)),"^",1)
    s HPNo=$p($G(^DHCPEPreIADM(iAdm)),"^",27)
    s IName=$p($G(^DHCPEPreIBI(PreIBaseId)),"^",2)
    q:(Name'="")&(IName'[Name)
    s IRegNo=$p($G(^DHCPEPreIBI(PreIBaseId)),"^",1)
    q:(RegNo'="")&(RegNo'=IRegNo)
    s PaPatID=$O(^PAPERi("PAPMI_PatNo",IRegNo,""))
    //联系电话 
    s PIBITel=""
    s PIBITel1=$p($g(^DHCPEPreIBI(PreIBaseId)),"^",8) 
    s PIBITel2=$p($g(^DHCPEPreIBI(PreIBaseId)),"^",6)
    s PIBITel3=$p($g(^DHCPEPreIBI(PreIBaseId)),"^",7)
    i PIBITel1'=""  s PIBITel=PIBITel1
    e  i PIBITel2'="" d
    .s PIBITel=PIBITel2
    . i PIBITel3'="" d
    ..e  s PIBITel=PIBITel3

    s ISexDR=$p($G(^DHCPEPreIBI(PreIBaseId)),"^",3)  //add by zhouli Start
    s ISexDRName="",IAge=""
    If (""'=ISexDR)  Do         
    .Set ISexDRName=$p($G(^CT("SEX",ISexDR)),"^",2)
    
    s IAge=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PaPatID,HospID,LocID)
    s IDepName=$g(^DHCPEDataEx("DHCPEPreIADM","Position",iAdm))   
    i IDepName="" s IDepName=$p($g(^DHCPEPreIBI(PreIBaseId)),"^",11)
    q:(DepartName'="")&&(IDepName'[DepartName)
    i IDepName=""  s IDepName="无部门"
    s ItemAmt=##class(web.DHCPE.HandlerPreOrds).GetAmount4POrdItm(iAdm)
    s FItemAmt=$p(ItemAmt,"^",2)
    i $p(FItemAmt,".",1)="" s FItemAmt=0_FItemAmt
    s FItemAmt=$fn(FItemAmt,"",2)
    s EntAmt=##class(web.DHCPE.HandlerPreOrds).GetAmount4POrdEnt(iAdm)
    s FEntAmt=$p(EntAmt,"^",2)
    s OneAmountStr=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Person(iAdm)
    i $p(FEntAmt,".",1)="" s FEntAmtt=0_FEntAmt
    s FEntAmt=$fn(FEntAmt,"",2)  //套餐金额
    s OneAmount=$fn((FItemAmt+FEntAmt),"",2)
    
    s TApAmount=$p(OneAmountStr,"^",1) ;应收金额
    s IAmt=##class(web.DHCPE.HandlerPreOrds).GetIFee(iAdm)
    i $p(IAmt,".",1)="" s IAmt=0_IAmt
    s IAmt=$fn(IAmt,"",2)  //自费金额
    s OneAmount=$fn((OneAmount-IAmt),"",2)
    s FItemAmt=$fn((FItemAmt-IAmt),"",2)  //公费项目金额
    s TotalAmount=$fn((TotalAmount+FItemAmt),"",2)
    s TotalIAmt=$fn((TotalIAmt+IAmt),"",2)
    s TotalApAmount=$fn((TotalApAmount+TApAmount),"",2)
    s TotalEntAmt=$fn((TotalEntAmt+FEntAmt),"",2)
    s ArriveDate=""
    i (RegDate'="")&(Status="ARRIVED") s ArriveDate=##class(websys.Conversions).DateLogicalToHtml(RegDate)
    //证件类型 证件号
    s PIBIIDCard="",PACCardDesc="",PACCardTypeDR=""
    S PACCardTypeDR=$P($G(^PAPER($o(^PAPERi("PAPMI_PatNo",IRegNo,0)),"PAT",3)),"^",7)
    I PACCardTypeDR'=""  S PACCardDesc=$p($g(^PAC("CARD",PACCardTypeDR)),"^",2)
    s PIBIIDCard=$P($G(^PAPER($o(^PAPERi("PAPMI_PatNo",IRegNo,0)),"PAT",3)),"^",6)
    //报告状态
    s ReportStatus="未初检"  
    i PEIADM'=""  d 
    .s RPId=$o(^DHCPERPT(0,"IADM",PEIADM,0))
    .s PAADM=$p(^DHCPEIADM(PEIADM),"^",1)
    .q:PAADM=""
    .s ReportStatus=$p(^DHCPERPT(RPId),"^",2)
    .s ReportStatus=##class(web.DHCPE.Report).GetStatusDesc(ReportStatus,PAADM,LocID)  

    s ^DHCPETmpHadCheck(CurUserID,"HadCheck",IDepName,iAdm)=GroupDesc_"^"_TeamDesc_"^"_IRegNo_"^"_IName_"^"_ISexDRName_"^"_IAge_"^"_IDepName_"^"_HadCheckType_"^"_DateFrom_"^"_DateTo_"^"_TApAmount_"^"_IAmt_"^"_FItemAmt_"^"_FEntAmt_"^"_PIBITel_"^"_ArriveDate_"^"_PACCardDesc_"^"_PIBIIDCard_"^"_ReportStatus
    d HadCheckedListExecute
    q
    
HadCheckedListExecute
    set Data=$lb(i,GroupDesc, TeamDesc,IRegNo,IName,ISexDRName,IAge,IDepName,OneAmount,TApAmount,IAmt,FItemAmt,FEntAmt,PIBITel,ArriveDate,PACCardDesc,PIBIIDCard,ReportStatus,PAADM,HPNo)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod HadCheckedListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HadCheckedListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod HadCheckedListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HadCheckedListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：    xueying
/// CreatDate：  2022-08-31
/// Description: 判断团体人员执行状态
/// Input：      PAADM:就诊ID
/// Return：     Y/N(执行/未执行)
/// Debug:  w ##class(web.DHCPE.PreGADM).IsOrderExecuted()
ClassMethod IsOrderExecuted(PAADM)
{
    s ret="Y"
    s LocID=$p($g(^PAADM(PAADM)),"^",4)
    s GCheckedFlag=$g(^DHCPESetting("DHCPE","GCheckedFlag",LocID))
    if (GCheckedFlag="E"){
        s:(##class(web.DHCPE.PreGTeam).OrderIsExecByPAAdm(PAADM)=0) ret="N" 
    }elseif(GCheckedFlag="R"){
        s:'$D(^DHCPERLT(0,"ADM",PAADM)) ret="N"
    }elseif(GCheckedFlag="A"){
         s IADMRowId=$o(^DHCPEIADM(0,"PAADM",PAADM,0)) 
         s Status=$p($g(^DHCPEIADM(IADMRowId)),"^",8)
         s:Status'="ARRIVED" ret="N"
        
    }
    q ret
}

ClassMethod Getgroupinfo()
{
    s id=0
    s ret="" 
    f  s id=$o(^gdy("DYgroup",id)) q:id=""  d
    .s PGADMPGBIDRCode=$p($g(^gdy("DYgroup",id)),"^",1)
    .s BeginDate=$p($g(^gdy("DYgroup",id)),"^",2) 
    .i (""'=BeginDate) d
    ..s BeginDate=$ZD(BeginDate,3)
    .s EndDate=$p($g(^gdy("DYgroup",id)),"^",3) 
    .i (""'=EndDate) d
    ..s EndDate=$ZD(EndDate,3)
    .s PGADMPGBIDRName=$p($g(^gdy("DYgroup",id)),"^",4) 
    .s PGBILinkman1=$p($g(^gdy("DYgroup",id)),"^",5)   //联系人
    .s PGBITel1=$p($g(^gdy("DYgroup",id)),"^",6)       //联系电话
    .s TTotalPerson=$p($g(^gdy("DYgroup",id)),"^",7)
    .i ret=""  s ret=PGADMPGBIDRCode_"^"_BeginDate_"^"_EndDate_"^"_PGADMPGBIDRName_"^"_PGBILinkman1_"^"_PGBITel1_"^"_TTotalPerson
    .e  s ret=ret_";"_PGADMPGBIDRCode_"^"_BeginDate_"^"_EndDate_"^"_PGADMPGBIDRName_"^"_PGBILinkman1_"^"_PGBITel1_"^"_TTotalPerson

    q ret
}

ClassMethod UpdateChargedMode(RowId, ChargedMode, GTID As %String = "")
{
    s SQLCODE=0
    q:(RowId="")||(ChargedMode="") SQLCODE
    //团体组
    s PGTChildSub=0
    f  s PGTChildSub=$o(^DHCPEPreGADM(RowId,"Team",PGTChildSub)) q:(PGTChildSub="")||(SQLCODE'=0)  d
    .s PGTRowId=RowId_"||"_PGTChildSub
    .q:(GTID'="")&&(GTID'=PGTRowId)
    .s PGTOldChargedMode=$P(^DHCPEPreGADM(RowId,"Team",PGTChildSub),"^",19)
    .b ;PGTOldChargedMode
    .q:(PGTOldChargedMode=ChargedMode)
    .b ;1
    .&SQL(Update SQLUser.DHC_PE_PreGTeam set PGT_DisChargedMode=:ChargedMode where PGT_RowID=:PGTRowId)
    .q:SQLCODE'=0
    .//团体人员
    .s PIADMRowId=0
    .f  s PIADMRowId=$o(^DHCPEPreIADM(0,"PGTeam",PGTRowId,PIADMRowId)) q:(PIADMRowId="")||(SQLCODE'=0)  d
    ..//审核表中对应整个团体的PRE类型的审核记录
    ..s GPAID=0,NGPAID=""
    ..f  s GPAID=$o(^DHCPEPreA(0,"CRMADM","G",RowId,GPAID)) q:(GPAID="")||(SQLCODE'=0)  d
    ...s GPAType=$p(^DHCPEPreA(GPAID),"^",20)
    ...q:GPAType="ADD"
    ...s GTeam=$p(^DHCPEPreA(GPAID),"^",22)
    ...q:(GTeam'=PGTRowId)
    ...s NGPAID=GPAID
    ..//修改视同收费
    ..i ChargedMode="GD" d
    ...s GAsCharged=$P(^DHCPEPreGADM(RowId),"^",7)
    ...i GAsCharged="Y" d
    ....s SQLCODE=##class(web.DHCPE.PreIADM).UpdateItemAsCharged(PIADMRowId,"Y","I")
    ..e  d
    ...s SQLCODE=##class(web.DHCPE.PreIADM).UpdateItemAsCharged(PIADMRowId,"N","I")
    ...s:SQLCODE=100 SQLCODE=0
    ..q:SQLCODE'=0
    ..//团体人员的项目
    ..s PIOIChildSub=0
    ..f  s PIOIChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub)) q:(PIOIChildSub="")||(SQLCODE'=0)  d
    ...s PIOIType=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub)),"^",15)
    ...//审核表中对应这个项目类型的审核记录
    ...s IPAID=0,NIPAID=""
    ...f  s IPAID=$o(^DHCPEPreA(0,"CRMADM","I",PIADMRowId,IPAID)) q:(IPAID="")||(SQLCODE'=0)  d
    ....s IPAType=$p(^DHCPEPreA(IPAID),"^",20)
    ....s ChargedStatus=$p(^DHCPEPreA(IPAID),"^",14)
    ....q:ChargedStatus="CHARGED"
    ....s Status=$p(^DHCPEPreA(IPAID),"^",21)
    ....q:Status="NU"
    ....q:IPAType'=PIOIType
    ....s NIPAID=IPAID
    ...//项目的收费记录
    ...s PIOIFChildSub=0
    ...f  s PIOIFChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub,"FEE",PIOIFChildSub)) q:(PIOIFChildSub="")||(SQLCODE'=0)  d
    ....s PAID=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub,"FEE",PIOIFChildSub)),"^",5)
    ....q:PAID=""
    ....s ChargedStatus=$p(^DHCPEPreA(PAID),"^",14)
    ....q:ChargedStatus="CHARGED"
    ....s Status=$p(^DHCPEPreA(PAID),"^",21)
    ....q:Status="NU"
    ....//由统结变自结,对应审核记录类型为"I"的不变
    ....i ChargedMode="ID" d
    .....s ADMType=$p(^DHCPEPreA(PAID),"^",1)
    .....q:ADMType="I"
    .....s FeeId=PIADMRowId_"||"_PIOIChildSub_"||"_PIOIFChildSub
    .....I NIPAID="" d
    ......s NIPAID=##class(web.DHCPE.PreItemList).GetPARowId("I",PIADMRowId,"PRE")
    .....d UpdateItemFeeAudit(FeeId,NIPAID)
    .....//s $p(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub,"FEE",PIOIFChildSub),"^",5)=NIPAID
    ....//由自结变统结,对应审核记录类型为"ADD"的不变
    ....i ChargedMode="GD" d
    .....s PAType=$p(^DHCPEPreA(PAID),"^",20)
    .....q:PAType="ADD"
    .....s FeeId=PIADMRowId_"||"_PIOIChildSub_"||"_PIOIFChildSub
    .....I NGPAID="" d
    ......s NGPAID=##class(web.DHCPE.PreItemList).GetPARowId("G",PGTRowId,"PRE")
    .....d UpdateItemFeeAudit(FeeId,NGPAID)
    
    .....//s $p(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub,"FEE",PIOIFChildSub),"^",5)=NGPAID
    ..q:SQLCODE'=0
    ..//套餐部分
    ..s PIOEChildSub=0
    ..f  s PIOEChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub)) q:(PIOEChildSub="")||(SQLCODE'=0)  d
    ...s PIOEType=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub)),"^",8)
    ...
    ...s IPAID=0,NIPAID=""
    ...f  s IPAID=$o(^DHCPEPreA(0,"CRMADM","I",PIADMRowId,IPAID)) q:IPAID=""  d
    ....s ChargedStatus=$p(^DHCPEPreA(IPAID),"^",14)
    ....q:ChargedStatus="CHARGED"
    ....s Status=$p(^DHCPEPreA(IPAID),"^",21)
    ....q:Status="NU"

    ....s IPAType=$p(^DHCPEPreA(IPAID),"^",20)
    ....q:IPAType'=PIOEType
    ....s NIPAID=IPAID
    ...
    ...s PIOEFChildSub=0
    ...f  s PIOEFChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub,"FEE",PIOEFChildSub)) q:(PIOEFChildSub="")||(SQLCODE'=0)  d
    ....s PAID=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub,"FEE",PIOEFChildSub)),"^",5)
    ....q:PAID=""
    ....s ChargedStatus=$p(^DHCPEPreA(PAID),"^",14)
    ....q:ChargedStatus="CHARGED"
    ....s Status=$p(^DHCPEPreA(PAID),"^",21)
    ....q:Status="NU"
    ....i ChargedMode="ID" d
    .....s ADMType=$p(^DHCPEPreA(PAID),"^",1)
    .....q:ADMType="I"
    .....s FeeId=PIADMRowId_"||"_PIOEChildSub_"||"_PIOEFChildSub
    .....d UpdateSetFeeAudit(FeeId,NIPAID)
    .....//s $p(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub,"FEE",PIOEFChildSub),"^",5)=NIPAID
    ....i ChargedMode="GD" d
    .....s PAType=$p(^DHCPEPreA(PAID),"^",20)
    .....q:PAType="ADD"
    .....s FeeId=PIADMRowId_"||"_PIOEChildSub_"||"_PIOEFChildSub
    .....d UpdateSetFeeAudit(FeeId,NGPAID)
    .....//s $p(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub,"FEE",PIOEFChildSub),"^",5)=NGPAID
    q:SQLCODE'=0 SQLCODE
    S SQLCODE=##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(RowId)
    q SQLCODE
UpdateItemFeeAudit(FeeId,AuditId)
    &SQL(update DHC_PE_PreIOrdItemFee set PIOIF_PAudit_DR=:AuditId where PIOIF_RowId=:FeeId)
    q SQLCODE
UpdateSetFeeAudit(FeeId,AuditId)
    &SQL(update DHC_PE_PreIOrdEntFee set PIOEF_PAudit_DR=:AuditId where PIOEF_RowId=:FeeId)
    q SQLCODE
}

// w ##class(web.DHCPE.PreGADM).GetTeamItem("51||1")

ClassMethod GetTeamItem(GTRowId)
{
  
    s ret="" ,ARCIMName="",GTeamName=""
    s PGBIDR=$P($G(^DHCPEPreGADM($p(GTRowId,"||",1))),"^",1) 
    s PGName=$p($g(^DHCPEPreGBI(PGBIDR)),"^",2)
    s GTeamName=$p(^DHCPEPreGADM($p(GTRowId,"||",1),"Team",$p(GTRowId,"||",2)),"^",1)
    s ChildSub=0
    f  s ChildSub=$o(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2) ,"ORDITEM",ChildSub))  q:ChildSub=""  d
    .s ItmMastDR=$p(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2) ,"ORDITEM",ChildSub),"^",1)
    .s PGTOIItemStat=$p(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2) ,"ORDITEM",ChildSub),"^",13)
    .q:PGTOIItemStat'=1
    .i ItmMastDR'=""  d
    ..s ARCIMSubscript=$p(ItmMastDR,"||",1)
    ..s ARCIMVersion=$p(ItmMastDR,"||",2)
    ..s ARCIMName=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",2)
    ..if ret=""  s ret=ARCIMName
    ..else  s ret=ret_"^"_ARCIMName
    
    s ret=ret_"$$"_PGName_"$$"_GTeamName
    q ret
}

ClassMethod GetTeamRowID(GID)
{
    q:GID="" ""
    s PGName=""
    s PGBIDR=$P($G(^DHCPEPreGADM(GID)),"^",1)
    s PGADMStatus=$P($G(^DHCPEPreGADM(GID)),"^",6)
    q:PGADMStatus="CANCELPREREG"
    q:PGADMStatus="CANCELPE"
    s PGName=$p($g(^DHCPEPreGBI(PGBIDR)),"^",2)
    s TeamIDStr=""
    s Sub=0
    f  s Sub=$O(^DHCPEPreGADM(GID,"Team",Sub)) q:Sub=""  d
    .s TeamID=GID_"||"_Sub
    .i TeamIDStr=""  s TeamIDStr=TeamID
    .else  s TeamIDStr=TeamIDStr_"^"_TeamID
    q TeamIDStr_"!"_PGName
}

ClassMethod UpdatePEComplete(GID)
{
    q:GID="" ""
    
    i $g(^DHCPEDataEx("DHCPEPreGADM","PEComplete",GID))=""  d
    .s ^DHCPEDataEx("DHCPEPreGADM","PEComplete",GID)="Y"
    else   d 
    .k ^DHCPEDataEx("DHCPEPreGADM","PEComplete",GID)
    Q ""
}

// 只要体检者有收费记录就不让修改

ClassMethod GetADMTypeChargedFlag(PADM, ADMFeeType, ADMType)
{
    s QuitFlag="",StatusStr=""
    i ADMType'="I"   d
    .s OldADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",PADM))
    .i ADMType="G"  s Type="PGADM"
    .i ADMType="T"  s Type="PGTeam"
    .s PIADMRowId=0
    .f  s PIADMRowId=$o(^DHCPEPreIADM(0,Type,PADM,PIADMRowId)) q:PIADMRowId=""  d
    ..s FeeFlag="0"
    ..s FeeFlag=..GetPIADMChargStatus(PIADMRowId)
    ..s StatusStr=StatusStr_"^"_FeeFlag
    else   d
    .s OldADMFeeType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",PADM))
    .s StatusStr=..GetPIADMChargStatus(PADM)
  
    i StatusStr["1" d
    .i OldADMFeeType'=ADMFeeType  s QuitFlag="已结算,不允许修改体检类型!"
    q QuitFlag
}

ClassMethod GetPIADMChargStatus(PIADM)
{
  
  s ChildSub=0,FeeFlag="0"
  f  s ChildSub=$o(^DHCPEPreIADM(PIADM,"ORDITEM",ChildSub)) q:ChildSub=""  d
  .s FeeChildSub=0
  .f  s FeeChildSub=$o(^DHCPEPreIADM(PIADM,"ORDITEM", ChildSub,"FEE",FeeChildSub))  q:FeeChildSub=""  d
  ..s AuditID=$P(^DHCPEPreIADM(PIADM,"ORDITEM", ChildSub,"FEE",FeeChildSub),"^",5)
  ..q:AuditID=""
  ..s ChargedStatus=$p(^DHCPEPreA(AuditID),"^",14) 
  ..i ChargedStatus="CHARGED"  s FeeFlag=1
  
  q FeeFlag
}

ClassMethod GetPersonNum()
{
  s StrNum=""
  s HadCheckType=""
  s DateFrom=""      //Add by MLH 20101029
  s DateTo=""       //Add by MLH 20101029
  s num=0
  f  s num=$o(^DHCPETmp("HadCheck",num))  q:num=""  d
  .s HadCheckType=$p($g(^DHCPETmp("HadCheck",num)),"^",8)
  .s DateFrom=$p($g(^DHCPETmp("HadCheck",num)),"^",9)
  .s DateTo=$p($g(^DHCPETmp("HadCheck",num)),"^",10)
  .i DateFrom'="" s DateFrom=$zd(DateFrom,3)
  .i DateTo'="" s DateTo=$zd(DateTo,3)
  .i DateTo=""  s DateTo=$zd(+$h,3)
  .i StrNum=""  s StrNum=num
  .else  s StrNum=StrNum_"^"_num
  s StrNum=StrNum_"!"_$G(HadCheckType)_"!"_$G(DateFrom)_"!"_$G(DateTo)
  q StrNum
}

ClassMethod GetHadCheckedList(num)
{
    /*
    s i=0
    s CurUserID=%session.Get("LOGON.USERID")    
    s Postion=0
    s DataStr=""
    f  s Postion=$o(^DHCPETmpHadCheck(CurUserID,"HadCheck",Postion))  q:Postion=""  d
    .s PIADM=0
    .f  s PIADM=$o(^DHCPETmpHadCheck(CurUserID,"HadCheck",Postion,PIADM)) q:PIADM=""  d
    ..
    ..i DataStr'=""  d
    ...s DataStr=DataStr_"@@"_$G(^DHCPETmpHadCheck(CurUserID,"HadCheck",Postion,PIADM))
    ..e  s DataStr=$G(^DHCPETmpHadCheck(CurUserID,"HadCheck",Postion,PIADM))
    ..s i=i+1
    ..s ^DHCPETmpHadCheck(CurUserID,"HadCheckList",i)=Postion_"^"_DataStr
    q DataStr
    */
    
    
    s DataStr=""
    s CurUserID=%session.Get("LOGON.USERID")
    s DataStr=$G(^DHCPETmpHadCheck(CurUserID,"HadCheckList",num))
    q DataStr
}

ClassMethod GetGRegInfo(DateFrom, DateTo)
{
 
  q:((DateFrom="")&&(DateTo="")) ""
  i DateFrom=""  s DateFrom=0
  else  s DateFrom=$zdh(DateFrom,4)
  i DateTo=""    s DateTo=+$H
  else  s DateTo=$zdh(DateTo,4)
  s ReturnStr=""
  s (PGBIDesc,PGBINo,LinkMan,LinkTel1,PGADMBookDateBegin,PGADMBookDateEnd,PGADMDisChargedMode,PGADMAddOrdItem,PGADMAddOrdItem)=""
  s (PGADMAddOrdItemAmt,PGADMRemark,TTotalPerson,PARebateStr)=""
  s BookDateBegin=DateFrom-1
  f  s BookDateBegin=$o(^DHCPEPreGADM(0,"BookDateTime",BookDateBegin))   q:(BookDateBegin="")||(BookDateBegin>DateTo)  d
  .s BookDateEnd=0
  .f  s BookDateEnd=$o(^DHCPEPreGADM(0,"BookDateTime",BookDateBegin,BookDateEnd))  q:BookDateEnd=""  d
  ..s BookTime=0
  ..f  s BookTime=$o(^DHCPEPreGADM(0,"BookDateTime",BookDateBegin,BookDateEnd,BookTime))  q:BookTime=""  d
  ...s PGADMRowId=0
  ...f  s PGADMRowId=$o(^DHCPEPreGADM(0,"BookDateTime",BookDateBegin,BookDateEnd,BookTime,PGADMRowId))  q:PGADMRowId=""  d
  ....//w !,PGADMRowId
  ....s PGBIDR=$P(^DHCPEPreGADM(PGADMRowId),"^",1)
  ....q:PGBIDR=""  //团体基本信息
  ....s PGBIDesc=$p(^DHCPEPreGBI(PGBIDR),"^",2)
  ....s PGBINo=$p(^DHCPEPreGBI(PGBIDR),"^",13)
  ....s LinkMan=$p(^DHCPEPreGBI(PGBIDR),"^",5)
  ....s LinkTel1=$p(^DHCPEPreGBI(PGBIDR),"^",8)
  ....//团体预约信息
  ....s PGADMBookDateBegin=$P(^DHCPEPreGADM(PGADMRowId),"^",2)
  ....i PGADMBookDateBegin'=""  s PGADMBookDateBegin=$zd(PGADMBookDateBegin,3)
  ....s PGADMBookDateEnd=$P(^DHCPEPreGADM(PGADMRowId),"^",3)
  ....i PGADMBookDateEnd'=""  s PGADMBookDateEnd=$zd(PGADMBookDateEnd,3)
  ....s PGADMAsCharged=$P(^DHCPEPreGADM(PGADMRowId),"^",7)
  ....i PGADMAsCharged="Y"  s PGADMAsCharged="是"
  ....else  s PGADMAsCharged="否"
  ....s PGADMDisChargedMode=$P(^DHCPEPreGADM(PGADMRowId),"^",16)
  ....i PGADMDisChargedMode="GD" S PGADMDisChargedMode="统结"
  ....else  S PGADMDisChargedMode="自结"
  ....s PGADMAddOrdItem=$P(^DHCPEPreGADM(PGADMRowId),"^",8)
  ....i PGADMAddOrdItem="Y" s PGADMAddOrdItem="是"
  ....else  s PGADMAddOrdItem="否"
  ....s PGADMAddOrdItemLim=$P(^DHCPEPreGADM(PGADMRowId),"^",9)
  ....i PGADMAddOrdItemLim="Y" s PGADMAddOrdItemLim="是"
  ....else  s PGADMAddOrdItemLim="否"
  ....s PGADMAddOrdItemAmt=$P(^DHCPEPreGADM(PGADMRowId),"^",10)
  ....s PGADMRemark=$P(^DHCPEPreGADM(PGADMRowId),"^",18)
  ....s TTotalPerson=..GetPersonInfoByGroup(PGADMRowId)
  ....s PARowId=0,GFactAmount=0,PARebateStr="" //团体折扣信息
  ....f  s PARowId=$o(^DHCPEPreA(0,"CRMADM","G",PGADMRowId,PARowId))  Q:PARowId=""  d
  .....s PAFactAmount=$p(^DHCPEPreA(PARowId),"^",9)
  .....s PAStatus=$p(^DHCPEPreA(PARowId),"^",21)
  .....q:PAStatus="NU"
  .....s GFactAmount=GFactAmount+PAFactAmount
  .....s PARebate=$p(^DHCPEPreA(PARowId),"^",5)
  .....i PARebate=""  s PARebate="无折扣"
  .....s PAType=$p(^DHCPEPreA(PARowId),"^",20)
  .....i PAType="PRE" s PAType="预约"
  .....else  s PAType="加项"
  .....s PARebate=PAType_":"_PARebate
  .....i PARebateStr=""  s PARebateStr=PARebate
  .....else  s PARebateStr=PARebateStr_","_PARebate
  ....s Return=PGBIDesc_"^"_PGBINo_"^"_LinkMan_"^"_LinkTel1_"^"_PGADMBookDateBegin_"^"_PGADMBookDateEnd_"^"_PGADMDisChargedMode_"^"_PGADMAsCharged_"^"_PGADMAddOrdItem_"^"_PGADMAddOrdItem_"^"_PGADMAddOrdItemAmt_"^"_PGADMRemark_"^"_TTotalPerson_"^"_PARebateStr_"^"_GFactAmount
  ....i ReturnStr=""  s ReturnStr=Return
  ....else  s ReturnStr=ReturnStr_"&&"_Return
  //w !,ReturnStr
  q ReturnStr
}

ClassMethod GetPersonInfoByGroup(id)
{
  
    s j=0
    s l=0
    s i=0
    s PersonInfo=""
    s Sub=0
    f  s Sub=$o(^DHCPEPreGADM(id,"Team",Sub)) q:Sub=""  d
    .s iAdm=0
    .f  s iAdm=$o(^DHCPEPreIADM(0,"PGTeam",id_"||"_Sub,iAdm)) q:iAdm=""  d
    ..s Status=$p(^DHCPEPreIADM(iAdm),"^",8)
    ..q:Status="CANCELPE"
    ..q:Status="CANCELPREREG"
    ..s PIBIDR=$p(^DHCPEPreIADM(iAdm),"^",1)
    ..q:PIBIDR=""
    ..s CTSEXDesc="未知"
    ..s SexDR=$P(^DHCPEPreIBI(PIBIDR),"^",3)
    ..i SexDR'=""  s CTSEXDesc=$p(^CT("SEX",SexDR),"^",2)
    ..s i=i+1
    ..s PEIADM=$o(^DHCPEIADM(0,"CRMADM",iAdm,0))
    ..q:PEIADM=""
    ..s PAADM=$p($G(^DHCPEIADM(PEIADM)),"^",1)
    ..q:PAADM=""
    ..q:##class(web.DHCPE.PreGTeam).OrderIsExecByPAAdm(PAADM)=0 //存在已执行项目即算是已检
    ..s l=l+1
    ..s ^TMPDHCPE("SexTotal",CTSEXDesc)=+$g(^TMPDHCPE("SexTotal",CTSEXDesc))+1
    
    s SexDesc=0,SexDescStr=""
    f  s SexDesc=$o(^TMPDHCPE("SexTotal",SexDesc))  q:SexDesc=""  d
    .s Num=$G(^TMPDHCPE("SexTotal",SexDesc))
    .i SexDescStr=""  s SexDescStr=SexDesc_":"_ Num_"人"
    .else  s SexDescStr=SexDescStr_"  "_SexDesc_":"_ Num_"人"
    i SexDescStr'="" s SexDescStr=",其中"_SexDescStr
    s PersonInfo="共预约"_i_"人,已检"_l_"人"
    q PersonInfo
}

ClassMethod GetPostionNum()
{
    s i=0
    s CurUserID=%session.Get("LOGON.USERID")    
    s Postion=""
    f  s Postion=$o(^DHCPETmpHadCheck(CurUserID,"HadCheck",Postion))  q:Postion=""  d
    .s PIADM=0
    .f  s PIADM=$o(^DHCPETmpHadCheck(CurUserID,"HadCheck",Postion,PIADM)) q:PIADM=""  d
    ..s DataStr=$G(^DHCPETmpHadCheck(CurUserID,"HadCheck",Postion,PIADM))
    ..s i=i+1
    ..s ^DHCPETmpHadCheck(CurUserID,"HadCheckList",i)=DataStr
 
    q i
}

// w ##class(web.DHCPE.PreGADM).GetDefaultDate()

ClassMethod GetDefaultDate()
{
    s CurDate=+$H
    //s WeekNum=$ZD(CurDate,10)
    //s CurDate=CurDate-WeekNum
    q ##class(websys.Conversions).DateLogicalToHtml(CurDate)
}

ClassMethod UpDateGMark(PGADM, Mark)
{
    s ^DHCPEDataEx("Mark","G",PGADM)=Mark
    q $g(^DHCPEDataEx("Mark","G",PGADM))
}

/// w ##class(web.DHCPE.PreGADM).IsRegister("190||2")
/// function:判断分组人员是否有项目
ClassMethod IsRegister(PGTeam)
{
    s flag=0
    s PIADM=""
    f  s PIADM=$o(^DHCPEPreIADM(0,"PGTeam",PGTeam,PIADM)) q:((PIADM="")||(flag=1))  d
    .b ;1
    .;i PIADM'="" s flag=1
    .s PIOI=""  
    .f  s PIOI=$o(^DHCPEPreIADM(PIADM,"ORDITEM",PIOI)) q:((PIOI="")||(flag=1))  d
    ..i PIOI'="" s flag=1
    .s PIOE=""  
    .f  s PIOI=$o(^DHCPEPreIADM(PIADM,"ORDENT",PIOE)) q:((PIOE="")||(flag=1))  d
    ..i PIOE'="" s flag=1
   q flag
}

/// Description: 判断分组是否有有效人员
/// Debug: w ##class(web.DHCPE.PreGADM).IsExsitIADMByTeam("190||1")
ClassMethod IsExsitIADMByTeam(PGTeam)
{
    s flag=0
    s PIADM=""
    f  s PIADM=$o(^DHCPEPreIADM(0,"PGTeam",PGTeam,PIADM)) q:((PIADM="")||(flag=1))  d
   .S status=$p($g(^DHCPEPreIADM(PIADM)),"^",8)
   .q:status="CANCELPE"
   .S flag=1
   q flag
}

/// Description:  判断团体是否有有效人员
/// Debug:  w ##class(web.DHCPE.PreGADM).IsExsitIADMByGroup("")
ClassMethod IsExsitIADMByGroup(GroupID)
{
    s flag=0
    s Sub=0
    f  s Sub=$o(^DHCPEPreGADM(GroupID,"Team",Sub)) q:(Sub="")||(flag=1)  d
    .s PIADM=0
    .f  s PIADM=$o(^DHCPEPreIADM(0,"PGTeam",GroupID_"||"_Sub,PIADM)) q:(PIADM="")||(flag=1)  d
    ..S status=$p($g(^DHCPEPreIADM(PIADM)),"^",8)
    ..q:status="CANCELPE"
    ..S flag=1
     q flag
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.PreGADM","SearchOldGADMInfo","32","81","导入测试","0")
Query SearchOldGADMInfo(GroupDR As %String = "", NewGID As %String = "", NewGDesc As %String = "", AllowCF As %String = "") As websys.Query(ROWSPEC = "TRegNo:%String, TName:%String, TIDCard:%String, TSex:%String, TAge:%String, TDob:%String, TMarried:%String, TMobile:%String, TTel1:%String, TStatus:%Float, TTipMsg:%String")
{
}

ClassMethod SearchOldGADMInfoExecute(ByRef qHandle As %Binary, GroupDR As %String = "", NewGID As %String = "", NewGDesc As %String = "", AllowCF As %String = "") As %Status
{
    s ind=1
    Set repid=$I(^CacheTemp)
    if ((""=GroupDR)&&(""=NewGID)){
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    s ^TempDHCPEGADMInfo("OldInfo")=$LB(GroupDR,NewGID,NewGDesc,AllowCF)
    s Job=%session.Get("LOGON.USERID")
    d ##class(web.DHCPE.ImportGInfo).KillImportGlobal(Job)
    s GTeamDR=""
    f  s GTeamDR=$o(^DHCPEIADM(0,"GADM",GroupDR,GTeamDR)) q:GTeamDR=""  d
    .s PEIADM=""
    .f  s PEIADM=$o(^DHCPEIADM(0,"GADM",GroupDR,GTeamDR,PEIADM)) q:PEIADM=""  d
    ..d PreIBaseInfo
    
 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
PreIBaseInfo
    s Status=$p($G(^DHCPEIADM(PEIADM)),"^",8)
    q:Status'="ARRIVED"
    s PreIADM=$p($G(^DHCPEIADM(PEIADM)),"^",4)
    s PIBI=$p($G(^DHCPEPreIADM(PreIADM)),"^",1)
    s PIBIData=$G(^DHCPEPreIBI(PIBI))
    s PAPMINo=$p(PIBIData,"^",1)
    s Name=$p(PIBIData,"^",2)
    s IDCard=$p(PIBIData,"^",9)
    s PatSex=$p(PIBIData,"^",3)
    i PatSex'="" s PatSex=$p(^CT("SEX",PatSex),"^",2)
    S PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",PAPMINo,0))
    s PatLoc=$P($G(^DHCPEPreIADM(PreIADM)),"^",26)
    s HospID=$p(^CTLOC(PatLoc),"^",22)
    s Age=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PAPMIRowId,HospID,PatLoc)
    s Dob=$p(PIBIData,"^",4)
    i Dob'="" s Dob=##class(websys.Conversions).DateLogicalToHtml(Dob)
    s Married=$p(PIBIData,"^",17)
    i Married'="" s Married=$p(^CT("MAR",Married),"^",2)
    s Mobile=$p(PIBIData,"^",8) 
    s Tel1=$p(PIBIData,"^",6)
    
    s InString="^"_PAPMINo_"^"_Name_"^"_IDCard_"^"_PatSex_"^"_+Age_"^"_Dob_"^"_Married_"^"_Mobile_"^"_Tel1_"^^^^^^^^^^^^^^^^^^^^^^^^^^"_ind
    s ^TempDHCPE("20221011",1,Name)=$LB(NewGID,InString,Job,NewGDesc,AllowCF)
    s ErrInfo=##class(web.DHCPE.ImportGInfo).GetGPersonInfo(NewGID,InString,"Check",Job,NewGDesc,AllowCF)
    i ErrInfo'=0 d
    .s TStatus="-1"
    .s TTipMsg=ErrInfo
    e  d
    .s TStatus=1
    .s TTipMsg=""
    d OutOneInfo
    
    q
OutOneInfo
    set Data=$lb(PAPMINo, Name, IDCard, PatSex, Age, Dob, Married, Mobile, Tel1, TStatus, TTipMsg)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

}
