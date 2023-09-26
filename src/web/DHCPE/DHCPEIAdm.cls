Import SQLUser

/// Created by MLH 2006/4
/// Description:
/// -----------------------
/// Modified by SongDeBo 2006/5/25
/// Description: Add parameter "IncludeRegisterec" in GetDataFromCRM
///              add function "IAdmArrived()" 
/// -------------------------
/// modified by SongDeBo 2006/4/20
/// Description: Nofity CRMSystem when audit in function "AuditUpdate"
/// -----------------------------------
Class web.DHCPE.DHCPEIAdm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query IAdm(PAPMINo As %String = "", IADMName As %String = "", AuditDateBegin As %String = "", AuditDateEnd As %String = "", STatusIsCheched As %String = "", STatusIsCharged As %String = "") As %Query(ROWSPEC = "TRowId:%String,TPAADM:%String,TName:%String,TRegDate:%String,TAsCharged:%String,TStatus:%String,TAccountAmount:%String,TDiscountedAmount:%String,TFactAmount:%String,TAuditUser:%String,TAuditDate:%String,TPapmiNo:%String")
{
}

///                                                    登记号             姓名                          审核人姓名                       登记起始日期                          登记截止日期                  显示已审核的单位                    显示已结算
ClassMethod IAdmExecute(ByRef qHandle As %Binary, PAPMINo As %String = "", IADMName As %String = "", AuditDateBegin As %String = "", AuditDateEnd As %String = "", STatusIsCheched As %String = "", STatusIsCharged As %String = "") As %Status
{
    
    Set repid=$I(^CacheTemp)
    s ind=1
    s id=0
   
    
    i ("1" = STatusIsCheched)  d //显示已审核
    .s STatusList="REGISTERED"_"CHECKED"
    e  d 
    .s STatusList="REGISTERED"
    i ("1" = STatusIsCharged)  d //显示已结算
    .s STatusList=STatusList_"CHARGED"

    f  s id=$o(^DHCPEIADM(id)) q:id=""  d   //体检人员表ADM DHC_PE_IADM
    .s CurData=$g(^DHCPEIADM(id))
    .
    .s ADM=$p(CurData,"^",1)                //IADM_PAADM_DR Medtrak的ADM号
    .q:ADM=""
    .s PapmiNo=$p($g(^PAPER($p(^PAADM(ADM),"^",1),"PAT",1)),"^",1)
    .
    .s PapmiNo=$p($g(^PAADM(ADM)),"^",1)    //取患者信息
    .q:((PAPMINo'=PapmiNo)&(PAPMINo'=""))
    .
    .s Name=$p(^PAPER(PapmiNo,"ALL"),"^",1) //姓名
    .q:(('(Name[IADMName))&(IADMName'=""))
    .
    .s GADM=$p(CurData,"^",2)       
    .q:(""'=GADM)                           //不为空，则是团体患者
    .
    .s GTeam=$p(CurData,"^",3)              //
    .
    .s RegDate=$p(CurData,"^",5)            //登记日期 
    
    .q:(""'=AuditDateBegin)&(RegDate<AuditDateBegin)    
    .q:(""'=AuditDateEnd)&(RegDate>AuditDateEnd)
    .i (""'=RegDate) d
    ..s RegDate=$ZD(RegDate,3)
    .
    .s AsCharged=$p(CurData,"^",7)          //视同收费
    .i ("Y"=AsCharged)  d
    ..s AsCharged="是"
    .e  d
    ..s AsCharged="否"
    .
    .s Status=$p(CurData,"^",9)             //状态 PREREG 预挂号REGISTERED　登记(在HIS中) CHECKED 审批CHARGED　收费COMPLETED 完成(报告完成)
    .q:('(STatusList[Status)&(PAPMINo="")&(IADMName=""))
    .
    .s AccountAmount=$p(CurData,"^",10)     //应收金额
    .
    .s DiscountedAmount=$p(CurData,"^",11)  //打折后金额 
    .
    .s FactAmount=$p(CurData,"^",12)        //最终金额 
    .
    .s AuditDate=$p(CurData,"^",14) //审核日期
    .i (""'=AuditDate) d
    ..s AuditDate=$ZD(AuditDate,3)
    .
    .d IAdmBuild
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
IAdmBuild
    //                          姓名   登记日期  视同收费     状态     应收金额        打折后金额          最终金额      审核人      审核日期  
    //           TRowId  TPAADM TName TRegDate TAsCharged TStatus TAccountAmount TDiscountedAmount TFactAmount TAuditUser TAuditDate
    set Data=$lb( $g(id), ADM,   Name, RegDate, AsCharged, Status, AccountAmount, DisCountedAmount, FactAmount, AuditUser, AuditDate, PapmiNo)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod IAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IAdmExecute ]
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

ClassMethod IAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IAdmExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetGTeamByIADM(PreIADM)
{
    q:PreIADM["||" ""
    q:PreIADM="" ""
    s GTeam=$p($g(^DHCPEPreIADM(+PreIADM)),"^",3)
    q GTeam
}

// **************************************************************************

/// 患者列表 
Query PAADMList() As %Query(ROWSPEC = "TName:%String,TPAADM:%String,TRowId:%String")
{
}

ClassMethod PAADMListExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s id=0
    f  s id=$o(^DHCPEIADM(id)) q:id=""  d   //体检人员表ADM DHC_PE_IADM
    .s CurData=$g(^DHCPEIADM(id))
    .s ADM=$p(CurData,"^",1)                //IADM_PAADM_DR Medtrak的ADM号
    .q:(""=ADM)
    .s PapmiNo=$p($g(^PAADM(ADM)),"^",1)
    .s Name=$p(^PAPER(PapmiNo,"ALL"),"^",1) //
    .d PAADMListBuild
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
PAADMListBuild
    set Data=$lb( Name, ADM, $g(id) )
    
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod PAADMListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PAADMListExecute ]
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

ClassMethod PAADMListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PAADMListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 审批状态   Created by MLH
/// return: 0-正常 ,  else-有错
ClassMethod AuditUpdate(itmjs As %Library.String = "", itmjsex As %Library.String = "", IRowId As %Library.String = "", IStatus As %Library.String = "", AuditAmount As %Library.String = "", AuditUser As %Library.String = "")
{
    
    s AuditDate=+$h
    s crmAdmId=""
    &sql(select IADM_CRMADM  into :crmAdmId  from dhc_pe_iadm where IADM_RowId=:IRowId)
    q:crmAdmId="" -1
    
    s CurData=$g(^DHCPEIADM(IRowId))
    s AsCharged=$p(CurData,"^",7)
    //i AsCharged="Y"     //视同收费
    s PAADM=$p(CurData,"^",1)
    q:PAADM="" -1
    
    if IStatus="CHECKED"  d
    .//通过审核，处理视同收费(医嘱Billed状态TB->P,视同收费表插入,状态O)
    .i AsCharged="Y" d
    ..s OrdId=0
    ..f  s OrdId=$o(^OEORD(0,"Adm",PAADM,OrdId)) q:OrdId=""  d
    ...s OrdItem=0
    ...f  s OrdItem=$o(^OEORD(OrdId,"I",OrdItem)) q:OrdItem=""  d
    ....s OriData=$g(^OEORD(OrdId,"I",OrdItem,3))
    ....s BillFlag=$p(OriData,"^",5)
    ....i ((BillFlag="TB")!(BillFlag="B")) d
    .....s OriRowId=OrdId_"||"_OrdItem
    .....&sql(insert into DHC_PE_AsChargedOrder(ACO_PAADM_DR,ACO_OEORI_DR,ACO_BillStatus)values(:PAADM,:OriRowId,'O'))
    .....&sql(update OE_OrdItem set Oeori_Billed='P' where oeori_rowid=:OriRowId)
    .//
    .&sql(update DHC_PE_IAdm set IADM_Status=:IStatus where IADM_RowId=:IRowId)
    e  d
    .//取消审核，处理视同收费(已挂帐的核实医嘱Billed状态P->TB,视同收费表删除该记录)
    .i AsCharged="Y" d
    ..s AsChargeOrd=0
    ..f  s AsChargeOrd=$o(^DHCPEACO(0,"PAADM",PAADM,AsChargeOrd)) q:AsChargeOrd=""  d
    ...s AsChargeStatus=$p(^DHCPEACO(AsChargeOrd),"^",3)
    ...i AsChargeStatus="O" d //医嘱是挂帐
    ....s OrdRowId=$p(^DHCPEACO(AsChargeOrd),"^",2)
    ....s OrdId=$p(OrdRowId,"||",1)
    ....s OrdItem=$p(OrdRowId,"||",2)
    ....s OriData=$g(^OEORD(OrdId,"I",OrdItem,1))
    ....s OrdStat=$p(OriData,"^",13)
    ....i (OrdStat=1) d //医嘱状态是核实
    .....&sql(update OE_OrdItem set Oeori_Billed='TB' where oeori_rowid=:OrdRowId)
    .....&sql(delete from DHC_PE_AsChargedOrder where ACO_RowId=:AsChargeOrd)
    .//
    .&sql(update DHC_PE_IAdm set IADM_Status=:IStatus where IADM_RowId=:IRowId)
    
    s gatewayCRM=##class(web.DHCPE.CRM.Factory).GetGateway()
    s rtn=gatewayCRM.ExamStatusNotify("PERSON",crmAdmId,IStatus,"")
    
    q 0
}

/// 结算 Create by MLH
/// test w ##Class(web.DHCPE.DHCPEIAdm).IBilled
ClassMethod IBilled(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowId As %Library.String = "", PAADM As %Library.String = "", UserId As %Library.String = "", PaymodeType As %Library.String = "", ChequeNo As %Library.String = "", Instype As %Library.String = "", gloc As %Library.String = "", FactAmount As %Library.String = "", PayAmount As %Library.String = "", GDelegate As %Library.String = "", GRowId As %Library.String = "")
{
    //s ^Bob("temp","IBilled's param()")="itmjs="_itmjs_"; itmjsex="_itmjsex_"; RowId="_RowId_"; PAADM="_PAADM _"; UserId="_UserId _"; PaymodeType="_PaymodeType _"; ChequeNo="_ChequeNo _"; Instype="_Instype _"; gloc="_gloc _"; FactAmount="_ FactAmount
    //q 101
    s BilledDate=+$h
    s BilledTime=$p($H,",",2)
    s billret=1
    s qflag=0
    
    //是团体代表,取视同收费状态
    i GDelegate="Y" d 
    .i GRowId="" s qflag=1
    .s AsCharged=$p($g(^DHCPEGADM(GRowId)),"^",15)
    e  d
    .i RowId="" s qflag=1
    .s CurData=$g(^DHCPEIADM(RowId))
    .s AsCharged=$p(CurData,"^",7)

    q:qflag=1 -1
    
    q:PAADM="" -1
    //视同收费处理，医嘱Billed状态P->TB(真正收费时->P),视同收费表修改状态为O->P

    i AsCharged="Y" d    //视同收费
    .s AsChargeOrd=0
    .f  s AsChargeOrd=$o(^DHCPEACO(0,"PAADM",PAADM,AsChargeOrd)) q:AsChargeOrd=""  d
    ..s AsChargeStatus=$p(^DHCPEACO(AsChargeOrd),"^",3)
    ..i AsChargeStatus="O" d //医嘱是挂帐
    ...s OrdRowId=$p(^DHCPEACO(AsChargeOrd),"^",2)
    ...s OrdId=$p(OrdRowId,"||",1)
    ...s OrdItem=$p(OrdRowId,"||",2)
    ...s OriData=$g(^OEORD(OrdId,"I",OrdItem,3))
    ...s BillFlag=$p(OriData,"^",5)
    ...i ((BillFlag="P")) d //挂帐医嘱
    ....&sql(update OE_OrdItem set Oeori_Billed='TB' where oeori_rowid=:OrdRowId)
    ....&sql(update DHC_PE_AsChargedOrder set ACO_BillStatus='P' where ACO_RowId=:AsChargeOrd)
    //
    
    s ordId="", ordIChd="0",totalAmount=0
    s ordId=$o(^OEORD(0,"Adm",PAADM,ordId)) 
    q:ordId=""  
    s patType=$p(^PAADM(PAADM),"^",3)
    s Instype1=$p(^PAADM(PAADM,1),"^",7)    //PAADM_AdmReason_DR 
    
    f  s ordIChd=$o(^OEORD(ordId,"I",ordIChd)) q:ordIChd=""  d
    .s billFlag=$p(^OEORD(ordId,"I",ordIChd,3),"^",5)
    .s arcItm=$p(^OEORD(ordId,"I",ordIChd,1),"^",2)
    .s sstDate=$p(^OEORD(ordId,"I",ordIChd,1),"^",9)
    .i ((billFlag="TB")!(billFlag="B"))  d
    ..//s itmPrice=##class(web.UDHCJFPRICE).GetOrderPrice(patType,"",arcItm,sstDate,"",Instype1,"","") 
    ..s PIADM=$p(CurData,"^",4)
    ..s itmPrice=##class(web.DHCPE.PreItemList).GetOrderPrice(arcItm,PIADM)
    ..s totalAmount=totalAmount+(+itmPrice)
    
    s Paymode=PaymodeType_"^"_ChequeNo_"^"  
    //parameter:  Paadminfo,Userid,UnBillOrdStr,Instype,PatPaySum,Payinfo,gloc,SFlag,OldINVRID,InsPayCtl)
    //s ^lisatest(PAADM,"IBILLED-par")=RowId_"!"_PAADM_"!"_UserId_"!"_Instype_"!"_totalAmount_"!"_Paymode_"!"_gloc_"!"_PayAmount
    //                                 //197!64071!10137!2!1000!1^^!47!800 
    s ret=##class(web.DHCOPINVCons).OPBillCharge(PAADM,UserId,"",Instype,totalAmount,Paymode,gloc,"0","","0",PayAmount) 
    
    i ($p(ret,"^",1)=0) d
    .//&sql(update DHC_PE_IAdm set IADM_Status='CHARGED',IADM_DischargedAmount=:PayAmount where IADM_RowId=:RowId)
    .s billret=ret
    q billret
}

/// ////////////////////////////////////
/// Created by MLH 
/// Print Receipt
ClassMethod GetReceiptPrtDetail(JSFunName As %String, InvRowID As %String, UseID As %String, PayMode As %String) As %String
{
    
    Quit:$g(InvRowID)="" ""
    s SelectPrtDr=InvRowID
        
    Set PatDr=$p(^DHCINVPRT(SelectPrtDr),"^",15)
    Quit:$g(PatDr)="" ""
    
    Set PatName=$p(^PAPER(PatDr,"ALL"),"^",1)
    Set PatNo=$p(^PAPER(PatDr,"PAT",1),"^",2)
    Set Date=$p(^DHCINVPRT(SelectPrtDr),"^",5)
    s myInvNo=$p(^DHCINVPRT(SelectPrtDr),"^",14)
    Set DetailStr="PatName"_$C(2)_PatName_"^"_"RegNo"_$C(2)_PatNo_"^"_"Date"_$C(2)_$zd(Date,3)
    s DetailStr=DetailStr_"^"_"OpenID"_$c(2)_UseID
    s DetailStr=DetailStr_"^"_"PayMode"_$c(2)_PayMode
    s DetailStr=DetailStr_"^"_"InvNo"_$c(2)_myInvNo
    
    Kill ^TMP($ZN,$j)
    
    ;Add an Index for RecLoc
    s INVLinkDr=0
    For  Set INVLinkDr=$o(^DHCBCI(0,"INV",SelectPrtDr,INVLinkDr)) Quit:INVLinkDr=""  Do
    .Set Bill=$p(^DHCBCI(INVLinkDr),"^",2)
    .Quit:'$D(^DHCPB(Bill))
    .Set Ord=0 For  Set Ord=$o(^DHCPB(Bill,"O",Ord)) Quit:Ord=""  Do
    ..q:($d(^DHCPB(Bill,"O",Ord))=10)       
    ..s Prescno=""
    ..s OEIMDR=$p(^DHCPB(Bill,"O",Ord),"^",4)
    ..s Arcim=$p(^DHCPB(Bill,"O",Ord),"^",3) ;DHC_PatBillOrder->PBO_ARCIM_DR
    ..s ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
    ..s OrderType=$p(^ARC("IC",ARCCATRowid),"^",7)
    ..s myPresNo=$p(^OEORD(+OEIMDR,"I",$p(OEIMDR,"||",2),1),"^",14)
    ..s recdepDR=$p($g(^OEORD(+OEIMDR,"I",+$p(OEIMDR,"||",2),3)),"^",6) ;接收科室
    ..s loctype=$p(^CTLOC(recdepDR),"^",13)
    ..i loctype="" s loctype="Z"    ;放在最后?
    ..s ^TMP($ZN,$j,"PBID",loctype,recdepDR,Bill_"||"_Ord)=""       ;;;Index
    ..s ^TMP($ZN,$j,"PBO",Bill_"||"_Ord)=Bill_"^"_Ord_"^"_myPresNo_"^"_OrderType
    ;
    ;
    ;
    s myLocType=""
    f  s myLocType=$o(^TMP($ZN,$j,"PBID",myLocType)) q:myLocType=""  d
    .s myRecDR=""
    .f  s myRecDR=$o(^TMP($ZN,$j,"PBID",myLocType,myRecDR)) q:myRecDR=""  d
    ..s myPBORID=""
    ..f  s myPBORID=$o(^TMP($ZN,$j,"PBID",myLocType,myRecDR,myPBORID)) q:myPBORID=""  d
    ...s Bill=+myPBORID
    ...s Ord=$p(myPBORID,"||",2)
    ...s OEIMDR=$p(^DHCPB(Bill,"O",Ord),"^",4)
    ...s myPresNo=$p(^OEORD(+OEIMDR,"I",$p(OEIMDR,"||",2),1),"^",14)
    ...;
    ...d AddToDetails(Bill,Ord)
    
    s PatientShare=$p(^DHCINVPRT(SelectPrtDr),"^",16)
    d AddToPLIST(PatientShare)
    
    ;b  ;   
    s prtTxtInfo=$$GetTxtInfo()
    ;w prtTxtInfo,!
    ;b 
    s prtListInfo=$$GetDetails()
    ;w prtListInfo
    ;b
    s prtTxtInfo=DetailStr_"^"_prtTxtInfo
    s rtnval=JSFunName_"('"_$ZCVT($g(prtTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
    &javascript<#(rtnval)#>
    
    //KILL ^TMP($ZN,$j)
    Quit "0"
    ;
    ;
AddToPLIST(PatientShare)
    s OPCatCode="TJF"
    
    Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",1)="体检费"
    Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",2)=PatientShare
    Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",3)=PatientShare
    Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",4)=PatientShare
    Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",5)=PatientShare

    Quit
GetTxtInfo()
    s OPCSInfo=""
    s myTxtInfo=""
    s myPatientShare=0
    f  s OPCSInfo=$o(^TMP($ZN,$j,"CAT",OPCSInfo)) q:OPCSInfo=""  d
    .i myTxtInfo="" d
    ..s myTxtInfo=OPCSInfo_$C(2)_$fn($p($g(^TMP($ZN,$j,"CAT",OPCSInfo)),"^",4),"",2)
    .e  d
    ..s myTxtInfo=myTxtInfo_"^"_OPCSInfo_$C(2)_$fn($p($g(^TMP($ZN,$j,"CAT",OPCSInfo)),"^",4),"",2)
    .s myPatientShare=+myPatientShare+$p(^TMP($ZN,$j,"CAT",OPCSInfo),"^",4)
    
    s mypayinfo="PaySum"_$C(2)_""_$fn(myPatientShare,"",2)
    s myTxtInfo=myTxtInfo_"^"_mypayinfo
    s myRMB=##class(web.DHCOPINVCons).RMBConvert(myPatientShare)
    s mypayinfo="PaySumPY"_$C(2)_""_myRMB
    s myTxtInfo=myTxtInfo_"^"_mypayinfo
    
    ;b  ;GetTxtInfo
    q myTxtInfo
AddDWin(myPresNo)
    ;^DHCPHARi("PRT",{PHA_PRT_DR},{PHA_ROWID})
    ;b  ;;myPresNo
    s myWinDR=""
    s myCTLoc=""
    s UseFlag=0
    q:myPresNo=""
    Q:$d(^DHCPHARi("PRT",InvRowID))=0
    f  s myWinDR=$o(^DHCPHARi("PRT",InvRowID,myWinDR)) q:myWinDR=""  d
    .;b
    .q:myPresNo'=$p($g(^DHCPHARW(myWinDR)),"^",16)
    .q:UseFlag=1
    .s myphloc=$p($g(^DHCPHARW(myWinDR)),"^",3)
    .q:myphloc=""
    .s myCTLoc=$p(^DHCPHLOC(myphloc),"^",1)
    .s myCount=+$g(^TMP($ZN,$j,"WD"))
    .f i=1:1:myCount  d
    ..i $g(^TMP($ZN,$j,"WD",i))=myCTLoc  d
    ...s UseFlag=1
    .;^TMP($ZN,$j,"WD")
    
    q:UseFlag=1
    q:myCTLoc=""

    s ^TMP($ZN,$j,"WD")=$g(^TMP($ZN,$j,"WD"))+1
    s Idx=$g(^TMP($ZN,$j,"WD"))
    s ^TMP($ZN,$j,"WD",Idx)=myCTLoc
    
    s myrtn=##class(web.DHCMZYFXTYW02).GetCurrWin(myCTLoc)
    ;
    ;
    s ^TMP($ZN,$j,"D")=$g(^TMP($ZN,$j,"D"))+1
    s Idx=$g(^TMP($ZN,$j,"D"))

    s ^TMP($ZN,$j,"D",Idx)=$p(myrtn,"^",3)_"^^^^"
    quit
    ;
AddToDetails(myBill,myOrd)
    ;ArcimDesc_"^"_OEORI_"^"_recdepcode_"^"_recdepdesc_"^"_PBOrderRowid_"^"_OrderUnitPrice_"^"_OrderBillQty_"^"_OrderSum_"^"_OrderType_"^"_Prescno_"^"_ORCATDesc_"^"_ItemGroup_"^"_loctype_"^"_bill_"^"_OrdPatShare
    ;i PackQty="" s PackQty=1
    q:'$d(^DHCPB(myBill,"O",myOrd))
    
    s ArcimRowid=$p(^DHCPB(myBill,"O",myOrd),"^",3)
    s ArcimDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ArcimRowid) ;名称
    
    s ^TMP($ZN,$j,"D")=$g(^TMP($ZN,$j,"D"))+1
    s Idx=$g(^TMP($ZN,$j,"D"))
    
    s ^TMP($ZN,$j,"D",Idx)=$p($g(ArcimDesc),"-",1,19)
    quit
    
GetDetails()
    s myidx=""
    s myList=""
    f  s myidx=$o(^TMP($ZN,$j,"D",myidx)) q:myidx=""  d
    .i myList="" d
    ..s myList=^TMP($ZN,$j,"D",myidx)
    .e  d
    ..s myList=myList_""_$c(2)_^TMP($ZN,$j,"D",myidx)
    ;s myList=myList_""_$c(2)_"备注:   # 无自付;   & 有自付;   * 全自付;^^^^"
    q myList
}

/// ////////////////////////////////////
ClassMethod GetDataFromCRMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataFromCRMExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 实现按团体组查询患者项目
/// 传入参数:团体RowId 　获取当前团体组的列表
Query GTeamList(ParRef As %Library.String = "") As %SQLQuery(ROWSPEC = "GT_ParRef:%String, GT_RowId:%String, GT_ChildSub:%String, GT_Desc :%String, GT_CRMTeam :%String")
{
 select GT_ParRef ,GT_RowId, GT_ChildSub, GT_Desc, GT_CRMTeam 
 from DHC_PE_GTeam
 where  GT_ParRef=:ParRef
}

/// ----------------------------------------------------
/// 察看团体患者的检验项目信息   
/// sType:为空或"G" ParRef为团体号，查询团体所有的患者
/// sType:为"GT" ParRef为团体组号，查询当前团体组的患者
Query SreachIAdm(ParRef As %Library.String = "", sType As %Library.String = "") As %Query(ROWSPEC = "TRowId:%String,TPAADM:%String,TName:%String")
{
}

ClassMethod SreachIAdmExecute(ByRef qHandle As %Binary, ParRef As %Library.String = "", sType As %Library.String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s id=""
    i (""=sType) s sType="G"        //默认按团体查询
    i ("GT"'=sType) d
    .q:(""=ParRef)                  //查询团体的所有患者 ParRef:团体RowId
    .f  s id=$o(^DHCPEIADM(0,"GADM",ParRef,id)) q:id=""  d
    ..s CurData=$g(^DHCPEIADM(id))
    ..s ADM=$p(CurData,"^",1)
    ..q:(ADM="")
    ..s PapmiNo=$p($g(^PAADM(ADM)),"^",1)
    ..s Name=$p(^PAPER(PapmiNo,"ALL"),"^",1)
    ..d SreachIAdmBuild
    e  d
    .q:(""=ParRef)                  //按团体组查询            ParRef:团体组RowId
    .f  s id=$o(^DHCPEIADM(0,"GTeam",ParRef,id)) q:id=""  d
    ..s CurData=$g(^DHCPEIADM(id))  //
    ..s ADM=$p(CurData,"^",1)       //DHC_PE_IADM   :IADM_PAADM_DR
    ..q:(ADM="")
    ..s PapmiNo=$p($g(^PAADM(ADM)),"^",1)   //PA_ADM    :PAADM_PAPMI_DR
    ..s Name=$p($g(^PAPER(PapmiNo,"ALL")),"^",1)    //患者姓名          :
    ..d SreachIAdmBuild 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
SreachIAdmBuild
    set Data=$lb($g(id),ADM,Name)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod SreachIAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SreachIAdmExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod SreachIAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SreachIAdmExecute ]
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

/// d ##class(%ResultSet).RunQuery("web.DHCPE.DHCPEIAdm","GetDataFromCRM","HISCARDID","00000175","1","","")
/// PATNAME$$0$24$
Query GetDataFromCRM(queryType As %String, queryValue As %String, IncludeRegistered As %String = "", gadm As %String = "", gteam As %String = "", Depart As %String = "") As %Query(ROWSPEC = "TRegID:%String,TPatCardId:%String,TPatNAME:%String,TPreRegDate:%String,TRecordDate:%String,TIsAsCharged:%String,TStatus:%String,TCountAmount:%String,TDiscountAmount:%String,TFinalAmount:%String,TStatusDesc:%String,TGADM:%String,TGADMDesc:%String,TTeam:%String,TTeamDesc:%String,TSort:%String")
{
}

ClassMethod GetDataFromCRMExecute(ByRef qHandle As %Binary, queryType As %String, queryValue As %String, IncludeRegistered As %String = "", gadm As %String = "", gteam As %String = "", Depart As %String = "") As %Status
{
    //RegID^PatCardId^PreRegDate^RecordDate^IsAsCharged^Status^CountAmount^DiscountAmount^FinalAmount^PatNAME
    Set repid=$I(^CacheTemp)
    i (queryType="")&&(queryValue="")&&(IncludeRegistered="")&&(gadm="")&&(gteam="")
    {
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    s queryValue=##class(web.DHCPE.DHCPECommon).UnEscape(queryValue)
    s Depart=##class(web.DHCPE.DHCPECommon).UnEscape(Depart) 
    i queryType=""  d
    .s queryType="PATNAME"
    .s queryValue=""
    s flag="UNCOMPLETED"
    s StatusList=",PREREGED,REGISTERED,"
    if IncludeRegistered="1"  d
    .s flag="ALL"
    .s StatusList=",PREREGED,REGISTERED,ARRIVED,"
    s job=$j
    s Ret=##class(web.DHCPE.CRM.Gateway).GetRegIADM(queryType,queryValue,flag,job)
    //s Ret=""
    b //0606-1
    Set repid=$I(^CacheTemp)
    
    s ind=1
    s id=0
    ;Set ICount=$L(Ret,$C(1))
    ;For i=1:1:ICount Do
    ;.Set Item=$p(Ret,$c(1),i)
    s PreIADM=0
    f  s PreIADM=$o(^DHCPERegisterTempData(job,PreIADM)) q:PreIADM=""  d
    .s cDepart=$G(^DHCPEDataEx("DHCPEPreIADM","Position",PreIADM))
    .q:(Depart'="")&&(Depart'=cDepart)
    .Set Item=$G(^DHCPERegisterTempData(job,PreIADM))
    .Quit:Item=""
    .//s result=##class(web.DHCPE.CRM.Gateway).CheckPEDate(PreIADM,"I",+$H)
    .//q:(result'=0)
    .//preIAdmId_"^"_preIBId_"^"_PNo_"^"_PName_"^"_PSex_5"^"_PDOB_"^"_PGADMDR_"^"_PGTeamDR_"^"_BookDateBegin_"^"_BookDateEnd_10"^"_BookTime_"^"_PEDeskClerkDR_"^"_Status_"^"_AsCharged_"^"_AddOrdItem_15"^"_AddOrdItemLimit_"^"_AddOrdItemAmount_"^"_AddPhcItem_"^"_AddPhcItemLimit_"^"_AddPhcItemAmount_20"^"_IReportSend_"^"_DisChargedMode_"^"_Vip_"^"_DelayDate_"^"_Remark_25"^"_UpdateUserDR_"^"_UpdateDate
    .Set Status=$p(Item,"^",13)
    .quit:(StatusList'[(","_Status_","))
    .Set StatusDesc=##Class(web.DHCPE.Public.Common).strGetMatchVal("PREREG^PREREGED^MODIFIED^REGISTERED^ARRIVED^CHARGED^COMPLETED","预约^预约完成^修改^登记^到达^收费^完成",Status,"^")
    .Set RegId=$p(Item,"^",1)
    .Set PatCardId=$p(Item,"^",3)
    .Set PatNAME=$p(Item,"^",4)
    .//080917  by zhouli
    .Q:(queryValue'="")&(PatNAME'[queryValue)&(queryType="PATNAME") 
    .// 080917
    .Set PreRegDate=$p(Item,"^",9)
    .Set RecordDate=$p(Item,"^",27)
    .Set IsAsCharged=$p(Item,"^",14)
    .i IsAsCharged="N" s IsAsCharged="否" //N"
    .e  s IsAsCharged="是"   //Y"
    .Set CountAmount=""
    .Set DiscountAmount=""
    .Set FinalAmount=""
    .Set GADM=$p(Item,"^",7)
    .q:((gadm'="")&(gadm'=GADM))
    .s GADMDesc=""
    .i GADM'="" s GADMDesc=$p($g(^DHCPEPreGADM(GADM)),"^",1)
    .i GADMDesc'="" s GADMDesc=$p($g(^DHCPEPreGBI(GADMDesc)),"^",2)
    .s TTeam=$p(Item,"^",8)
    .q:((gteam'="")&(gteam'=TTeam))
    .s TTeamDesc=""
    .i TTeam'="" s TTeamDesc=$p($g(^DHCPEPreGADM(GADM,"Team",$p(TTeam,"||",2))),"^",1)
    .d GetDataFromCRMBuild
    
    k ^DHCPERegisterTempData(job)
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
GetDataFromCRMBuild
    set Data=$lb($g(RegId),$g(PatCardId),$g(PatNAME),$g(PreRegDate),$g(RecordDate),$g(IsAsCharged),$g(Status),$g(CountAmount),$g(DiscountAmount),$g(FinalAmount),$g(StatusDesc),$g(GADM),$g(GADMDesc),$g(TTeam),$g(TTeamDesc),$g(ind))
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod GetDataFromCRMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataFromCRMExecute ]
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

/// 就餐/取消就餐 Created by MLH
ClassMethod DietStatus(IADM As %Library.String = "") As %Status
{
    q:IADM=""
    s Diet=$p($g(^DHCPEIADM(IADM)),"^",17)
    i Diet="Y" d
    .s Diet="N"
    e  d
    .s Diet="Y"
    
    &sql(Update DHC_PE_IADM set IADM_Diet=:Diet where IADM_RowId=:IADM)
    
    quit SQLCODE
}

/// 通过 TRegID 取得 IADM_PAADM_DR 
/// 2006.03.28 xuwm
/// 组件 DHCPEIRegister 菜单 个人项目查询
ClassMethod GetIADMPAADMDR(RegID As %Library.String = "") As %Status
{
    s IADMPAADMDR=0
    &sql(select IADM_PAADM_DR into :IADMPAADMDR
        from DHC_PE_IADM 
        where IADM_CRMADM=:RegID
        )
    
    quit IADMPAADMDR
}

/// 传入参数:团体RowId 　获取当前团体的所有病人列表，以便察看患者的检验项目信息 被SreachIAdm替代　现未使用
Query GroupIAdm(ParRef As %Library.String = "") As %Query(ROWSPEC = "TRowId:%String,TPAADM:%String,TName:%String")
{
}

ClassMethod GroupIAdmExecute(ByRef qHandle As %Binary, ParRef As %Library.String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s id=""
    i (""=ParRef) d
    .w ParRef,!
    .f  s id=$o(^DHCPEIADM(id)) q:id=""  d
    ..s CurData=$g(^DHCPEIADM(id))
    ..s ADM=$p(CurData,"^",1)
    ..i (ADM'="") d
    ...s PapmiNo=$p($g(^PAADM(ADM)),"^",1)
    ...s Name=$p(^PAPER(PapmiNo,"ALL"),"^",1)
    ...s GADM=$p(CurData,"^",2)
    ...s GTeam=$p(CurData,"^",3)
    ...s RegDate=$p(CurData,"^",5)
    ...s AsCharged=$p(CurData,"^",8)
    ...s Status=$p(CurData,"^",9)
    ...s AccountAmount=$p(CurData,"^",10)
    ...s DiscountedAmount=$p(CurData,"^",11)
    ...d GroupIAdmBuild
    e  d
    .f  s id=$o(^DHCPEIADM(0,"GADM",ParRef,id)) q:id=""  d
    ..s CurData=$g(^DHCPEIADM(id))
    ..s ADM=$p(CurData,"^",1)
    ..i (ADM'="") d
    ...s PapmiNo=$p($g(^PAADM(ADM)),"^",1)
    ...s Name=$p(^PAPER(PapmiNo,"ALL"),"^",1)
    ...s GADM=$p(CurData,"^",2)
    ...s GTeam=$p(CurData,"^",3)
    ...s RegDate=$p(CurData,"^",5)
    ...s AsCharged=$p(CurData,"^",8)
    ...s Status=$p(CurData,"^",9)
    ...s AccountAmount=$p(CurData,"^",10)
    ...s DiscountedAmount=$p(CurData,"^",11)
    ...d GroupIAdmBuild
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
GroupIAdmBuild
    set Data=$lb($g(id),ADM,Name)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod GroupIAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GroupIAdmExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GroupIAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GroupIAdmExecute ]
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

/// Add By SongDeBo 2006/5/25
/// return: "0"-正常 ,  else-有错
/// test:   d ##class(web.DHCPE.DHCPEIAdm).IAdmArrived("203")
ClassMethod IAdmArrived(CrmAdmId As %String) As %String
{
   
    s result=##class(web.DHCPE.CRM.Gateway).CheckPEDate(CrmAdmId,"I",+$h)
    s LimitDate=$g(^DHCPESetting("DHCPE","BookDateLimit"))
    i LimitDate="Yes"
    {
        if result'=0
        {
            if result=-1 q "还没有到预约日期!"
            q "预约已经过期!"
        }
    }
    
    s result=##class(web.DHCPE.CRM.Gateway).CheckCanArrive(CrmAdmId,"I")
    if result'=0  q result
    s PIADMStatus=$p($g(^DHCPEPreIADM(CrmAdmId)),"^",8)
    quit:PIADMStatus'="REGISTERED" 0
    s objIAdm=##class(web.DHCPE.HandlerIAdm).GetAdmByCrmAdm(CrmAdmId)

    q:(objIAdm.%Id()="") "The crmIAdm is not exists in HIS System. CrmAdmId="_CrmAdmId
    
    i PIADMStatus'="ARRIVED"  d
    .s ret=..ArrivedUpdate(objIAdm.%Id(),"ARRIVED")
    ;s PAADM=$p($g(^DHCPEIADM(objIAdm.%Id())),"^",1)    //add by 20100308
    ;i PAADM'=""  d ##class(web.DHCPE.CRM.RisGateway).GetPAADM(PAADM,"ARRIVED") 
    ;d ##class(web.DHCPE.AdmRecordManager).Insert(CrmAdmId,"P","Arrived","","")

    if (ret=0)
    {
        s PAADM=$p($g(^DHCPEIADM(objIAdm.%Id())),"^",1)    //add by 20100308
        i PAADM'=""  d ##class(web.DHCPE.CRM.RisGateway).GetPAADM(PAADM,"ARRIVED") 
        //记录到达日期
        //d ##class(web.DHCPE.AdmRecordManager).Insert(CrmAdmId,"P","Arrived","","")
        //记录体检项目
        //d ##class(web.DHCPE.ItemDetailRecord).InsertByAdm(PAADM,"",0)
        //修改日期
        d ##class(web.DHCPE.TransAdmInfo).UpdateAdmDate(CrmAdmId,$ZD(+$H,4))
        
        s PGAdmID=$p($g(^DHCPEPreIADM(CrmAdmId)),"^",2)
        i $g(PGAdmID)="" q 0    //个人不需要处理
        set ret=##class(web.DHCPE.CRM.Gateway).ExamStatusNotify("GROUP", PGAdmID, "ARRIVED")
    }
    
    q ret
}

ClassMethod CheckResult(IADM)
{
    s PAADM=$p(^DHCPEIADM(IADM),"^",1)
    s RLID=$o(^DHCPERLT(0,"ADM",PAADM,0))
    i RLID="" q 0
    q 1
}

/// Description:   到达/取消到达
/// return:        0-正常 ,  else-有错
/// Debug: w ##class(web.DHCPE.DHCPEIAdm).ArrivedUpdate()
ClassMethod ArrivedUpdate(IRowId As %Library.String = "", IStatus As %Library.String = "")
{
    s AuditDate=+$h
    s AuditTime=$p($h,",",2)
    if IStatus="CANCELARRIVED"
    {
        s rtn= ##class(web.DHCPE.Cashier).CheckPayed("I",IRowId)
        if rtn=1  q "该客户已经有收费记录，不能取消到达!"
        
        s rtn=..CheckResult(IRowId)
        if rtn=1  q "该客户已经做过检查,不能取消到达!"
        
        //取消到达更新为登记状态  
        s IStatus="REGISTERED"
        s crmAdmId=$p($g(^DHCPEIADM(IRowId)),"^",4)
        q:crmAdmId="" "crmAdmId为空"
        &sql(update DHC_PE_IAdm set IADM_Status=:IStatus,IADM_AdmDate=:AuditDate,IADM_AdmTime=:AuditTime where IADM_RowId=:IRowId)
        if SQLCODE q "更新体检登记状态失败!"
        s CheckFlag=0  ;0不判断登记时的一些判断
        s SQLCODE=##class(web.DHCPE.PreIADM).CancelAdm("","",crmAdmId_"^"_IStatus_"^"_CheckFlag)
        if SQLCODE q "更新体检登记状态失败!"
        s PAADM=$p($g(^DHCPEIADM(IRowId)),"^",1)
        d ##class(web.DHCPE.ItemDetailRecord).InsertDByAdm(PAADM,"",0)
        //插入日志
        d ##class(web.DHCPE.AdmRecordManager).Insert(crmAdmId,"P","CancelArrived",%session.Get("LOGON.USERID"),"")
        q SQLCODE
        
    }

    s crmAdmId=$p($g(^DHCPEIADM(IRowId)),"^",4)
    q:crmAdmId="" "crmAdmId为空"
    s PAADM=$p($g(^DHCPEIADM(IRowId)),"^",1)
    s err= ##class(web.DHCPE.OEOrdItem).TransOrder(IRowId,IStatus)
    if err'="" q err
    &sql(update DHC_PE_IAdm set IADM_Status=:IStatus,IADM_AdmDate=:AuditDate,IADM_AdmTime=:AuditTime where IADM_RowId=:IRowId)
    if SQLCODE q "更新体检登记状态失败!"
    &sql(update PA_ADM set PAADM_AdmDate=:AuditDate,PAADM_AdmTime=:AuditTime where PAADM_RowID=:PAADM)
    if SQLCODE q "更新体检登记状态失败!"
    s IADMStatus=$p($g(^DHCPEIADM(IRowId)),"^",8)
    s PAADM=$p($g(^DHCPEIADM(IRowId)),"^",1)                
    i PAADM'=""  d ##class(web.DHCPE.CRM.RisGateway).GetPAADM(PAADM,IADMStatus) 
    s GADM=$p($g(^DHCPEIADM(IRowId)),"^",2)
    s GStatus=""
    i GADM'="" s GStatus=$p($g(^DHCPEGADM(GADM)),"^",6)
    s PGADM=$p($g(^DHCPEPreIADM(crmAdmId)),"^",2)
    i (GADM'="")&&(IStatus="ARRIVED")&&(GStatus="REGISTERED")&&(PGADM'=""){
        &sql(update DHC_PE_GADM set GADM_Status=:IStatus,GADM_AdmDate=:AuditDate,GADM_AdmTime=:AuditTime where GADM_RowId=:GADM)
        if SQLCODE q "更新团体状态失败!"    
        &sql(update DHC_PE_PreGADM set PGADM_Status=:IStatus where PGADM_RowId=:PGADM)
        if SQLCODE q "更新团体预约表状态失败!" 

    }
    //更新预约状态
    s CheckFlag=0  ;0不判断登记时的一些判断
    s SQLCODE=##class(web.DHCPE.PreIADM).CancelAdm("","",crmAdmId_"^"_IStatus_"^"_CheckFlag)
    if SQLCODE q "更新体检登记状态失败!"
 
    s rtn=##Class(web.DHCPE.CRM.Gateway).ExamStatusNotify("PERSON",crmAdmId,IStatus,"")
    d ##class(User.DHCPECurDateAdmInfo).Insert(PAADM)
    d ##class(web.DHCPE.ItemDetailRecord).InsertByAdm(PAADM,"",0)
    ;d ##Class(web.DHCPE.RoomManager).InsertRoomRecord(PAADM)
    //更新医嘱状态
    s UpdateStat=##class(web.DHCPE.OEOrdItem).UpdateOEStat(PAADM)
    i UpdateStat'=0 s rtn="更新医嘱状态错误"
    //更新dhc_pe_preiadm表的预约时间
    d ##class(web.DHCPE.TransAdmInfo).UpdateAdmDate(crmAdmId,+$H) 
    //插入日志
    d ##class(web.DHCPE.AdmRecordManager).Insert(crmAdmId,"P","Arrived",%session.Get("LOGON.USERID"),"")
    q rtn
}

/// Created by MLH
Query ICashier(PAPMINo As %String = "", IADMName As %String = "", AuditDateBegin As %String = "", AuditDateEnd As %String = "") As %Query(ROWSPEC = "TRowId:%String,TPAADM:%String,TName:%String,TRegDate:%String,TAsCharged:%String,TStatus:%String,TAccountAmount:%String,TDiscountedAmount:%String,TFactAmount:%String,TDischargedAmount:%String,TPayAmount:%String,TPapmiNo:%String,TGAdm:%String,TGAdmDesc:%String,TTeam:%String,TTeamDesc:%String,TRemark:%String,TNewHPNo:%String,TConfirmStatus:%String")
{
}

ClassMethod ICashierExecute(ByRef qHandle As %Binary, PAPMINo As %String = "", IADMName As %String = "", AuditDateBegin As %String = "", AuditDateEnd As %String = "") As %Status
{
    
    Set repid=$I(^CacheTemp)
    s ind=1
    i (PAPMINo="")&&(IADMName="")&&(AuditDateBegin="")&&(AuditDateEnd=""){
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    i PAPMINo'="" s PAPMINo=##class(web.DHCPE.DHCPECommon).RegNoMask(PAPMINo)
    //s IADMName=##class(web.DHCPE.DHCPECommon).UnEscape(IADMName)  
    
    i AuditDateBegin'=""  s AuditDateBegin=##class(websys.Conversions).DateHtmlToLogical(AuditDateBegin)
    i AuditDateEnd'="" s AuditDateEnd=##class(websys.Conversions).DateHtmlToLogical(AuditDateEnd)
    
    i AuditDateBegin=""  s AuditDateBegin=1
    i AuditDateEnd="" s AuditDateEnd=+$H
    i PAPMINo'="" d
    .s IBI=$O(^DHCPEPreIBI(0,"PAPMINo",PAPMINo,0))
    .q:IBI=""
    .s PreIADM=0
    .f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",IBI,PreIADM)) q:PreIADM=""  d
    ..s iAdmId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
    ..q:iAdmId=""
    ..d DoOneInfo
    e  i IADMName'=""  d
    .S IADMNameUC=$$ALPHAUP^SSUTIL4(IADMName)
    .s desc=$o(^DHCPEPreIBI(0,"Name",IADMNameUC),-1)
    .f  s desc=$o(^DHCPEPreIBI(0,"Name",desc)) q:(desc="")||(desc'[IADMNameUC)  d
    ..s IBI=0
    ..f  s IBI=$o(^DHCPEPreIBI(0,"Name",desc,IBI)) q:IBI=""  d
    ...s PreIADM=0
    ...f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",IBI,PreIADM)) q:PreIADM=""  d
    ....s iAdmId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
    ....q:iAdmId=""
    ....d DoOneInfo
    e  d
    .s Date=AuditDateBegin-1
    .f  s Date=$O(^DHCPEIADM(0,"AdmDateTime",Date)) q:(Date="")||(Date>AuditDateEnd)  d
    ..s Time=""
    ..f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:(Time="")  d
    ...s iAdmId=0
    ...f  s iAdmId=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time,iAdmId)) q:(iAdmId="")  d
    ....s PreIADM=$p($g(^DHCPEIADM(iAdmId)),"^",4)
    ....d DoOneInfo
    /*
    s iAdmId=0
    s IADMName=##class(web.DHCPE.DHCPECommon).UnEscape(IADMName)    
    f  s iAdmId=$o(^DHCPEIADM(iAdmId)) q:iAdmId=""  d
    .q:##class(web.DHCPE.DHCPEGAdm).HadUsedAudit("I","",iAdmId)
    .s hospCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
    .q:(0=+$G(^DHCPEDataEx("DHCPECharge","Person",iAdmId)))&&(hospCode="SHHS")
    .d ICashierSetData
    .q:hasData=0
    .d ICashierBuild
    */
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
DoOneInfo
    q:##class(web.DHCPE.DHCPEGAdm).HadUsedAudit("I","",iAdmId)
   s LocID=$P($G(^DHCPEPreGADM(PreIADM)),"^",23)
	//s hospCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
	s hospCode=$G(^DHCPESetting("DHCPE","HospitalCode",LocID))

    q:(0=+$G(^DHCPEDataEx("DHCPECharge","Person",iAdmId)))&&(hospCode="SHHS")
    s ConfirmStatus=##class(web.DHCPE.PreItemList).GetItemName(PreIADM,"PERSON")
    i ConfirmStatus["确认加项"  S ConfirmStatus="是"
    e  S ConfirmStatus="否"

    d ICashierSetData
    q:hasData=0
    d ICashierBuild
    q
ICashierBuild
    set Data=$lb( $g(iAdmId), ADM,    Name,  RegDate,  AsCharged,  Status,  AccountAmount,  DisCountedAmount,  FactAmount,    DischargedAmount,  PayAmount,RegNo,GADM,GADMDesc,GTeam,GTeamDesc,TRemark,NewHPNo,ConfirmStatus)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
    
ICashierSetData
    s hasData=0
    s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",iAdmId)
    q:LocFlag=1 
    s CurData=$g(^DHCPEIADM(iAdmId))
    s LocID=$P($G(^DHCPEPreGADM(PreIADM)),"^",23)
    s GADMDR=$p(CurData,"^",2)              //对应团体的ADM
    //q:(""'=GADMDR)                            //不为空，则是团体患者    
    //q:((PAPMINo="")&&(IADMName=""))&&($G(^DHCPESetting("DHCPE","HospitalCode"))="SYYD")
    //q:((PAPMINo="")&&(IADMName=""))&&($G(^DHCPESetting("DHCPE","HospitalCode",LocID))="SYYD")
    s ADM=$p(CurData,"^",1)
    q:(""=ADM)
    s PapmiNo=$p($g(^PAADM(ADM)),"^",1) //取患者信息
    q:PapmiNo=""
    s RegNo=$p(^PAPER($p(^PAADM(ADM),"^",1),"PAT",1),"^",1)
    //q:(RegNo'[PAPMINo)
    q:(PreID="")&(PAPMINo'="")&&(PAPMINo'=RegNo)
    s Name=$p($g(^PAPER(PapmiNo,"ALL")),"^",1)  //姓名
    q:(IADMName'="")&&('(Name[IADMName))
    s GADM=$p(CurData,"^",2)                
    s GTeam=$p(CurData,"^",3)               
    s RegDate=$p(CurData,"^",5)         //登记日期 
    i PAPMINo=""
    {
        q:(""'=AuditDateBegin)&(RegDate<AuditDateBegin) 
        q:(""'=AuditDateEnd)&(RegDate>AuditDateEnd)
    }
    i (""'=RegDate) d
    .s RegDate=##class(websys.Conversions).DateLogicalToHtml(RegDate)
    s AsCharged=$p(CurData,"^",7)           //视同收费 
    i (AsCharged="Y") s AsCharged="是"
    else  s AsCharged="否"
    s Status=$p(CurData,"^",8)              //状态 PREREG 预挂号REGISTERED　登记(在HIS中)CHECKED 审批CHARGED　收费COMPLETED 完成(报告完成)
    q:(Status'="ARRIVED")&&(Status'="REGISTERED")
    s AddOrdItem=$p(CurData,"^",9)
    s AddOrdItemLimit=$p(CurData,"^",10)
    s AddOrdItemAmount=$p(CurData,"^",11)
    s AddPhcItem=$p(CurData,"^",12)
    s AddPhcItemLimit=$p(CurData,"^",13)
    s AddPhcItemAmount=$p(CurData,"^",14)
    s IReportSend=$p(CurData,"^",15)
    s DisChargedMode=$p(CurData,"^",16)
    s Diet=$p(CurData,"^",17)
    s AccountAmount=""      //应收金额
    s DiscountedAmount=""   //打折后金额 
    s FactAmount=""     //最终金额
    s GTeamDesc="" 
    s GADMDesc=##Class(web.DHCPE.DHCPEGAdm).GetGAdmDesc(GADM)
    i GADM'="" s GTeamDesc=##Class(web.DHCPE.DHCPEGAdm).GetGTeamDesc(GTeam)
    s TRemark=""
    i GADM'=""  s TRemark=$p($g(^DHCPEGADM(GADM)),"^",17)
    s hasData=1 
    s PIADMRowId=$p(CurData,"^",4)
    s NewHPNo=$p($g(^DHCPEPreIADM(PIADMRowId)),"^",27) 
    
    q
}

ClassMethod ICashierFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ICashierExecute ]
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

ClassMethod ICashierClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ICashierExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod UpdateArriveDate(IRowId, Date)
{
    i Date="" s AuditDate=+$h
    i Date'="" s AuditDate=$zdh(Date,4)
    s crmAdmId=$p($g(^DHCPEIADM(IRowId)),"^",4)
    q:crmAdmId="" "crmAdmId为空"
    s PAADM=$p($g(^DHCPEIADM(IRowId)),"^",1)
    TSTART
    &sql(update DHC_PE_IAdm set IADM_AdmDate=:AuditDate where IADM_RowId=:IRowId)
    if SQLCODE{
        TROLLBACK
        q "更新体检登记状态失败!"
    }
    &sql(update PA_ADM set PAADM_AdmDate=:AuditDate where PAADM_RowID=:PAADM)
    if SQLCODE{
        TROLLBACK
        q "更新体检登记状态失败!"
    }
    s SQLCODE=..UpdateOEORIDate(PAADM,AuditDate)
    if SQLCODE{
        TROLLBACK
        q "医嘱时间失败!"
    }
    TCOMMIT
    q "0"
}

ClassMethod GetIADMbyPreIADM(PreIADM)
{
    q:PreIADM=""
    s IAdmId=""
    s IAdmId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,IAdmId))
    q IAdmId
}

ClassMethod GetPAADMbyPreIADM(PreIADM)
{
    q:PreIADM=""
    s IAdmId=""
    s IAdmId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,IAdmId)) 
    q:IAdmId=""
    s CurData=$g(^DHCPEIADM(IAdmId)) 
    s PAADMId=$p(CurData,"^",1)
    q PAADMId
}

ClassMethod UpdateOEORIDate(PAADM, curDate)
{
    s SQLCODE=0
    s OEORDID=$O(^OEORD(0,"Adm",PAADM,0))
    q:OEORDID="" SQLCODE
    s OrdItem=0
    f  s OrdItem=$o(^OEORD(OEORDID,"I",OrdItem)) q:((OrdItem="")||(SQLCODE'=0))  d
    .s OrdStat=$p($g(^OEORD(OEORDID,"I",OrdItem,1)),"^",13)
    .q:OrdStat'="1"
    .s OriRowId=OEORDID_"||"_OrdItem
    .&sql(update sqluser.OE_OrdItem set OEORI_SttDat=:curDate where oeori_rowid=:OriRowId)
    q SQLCODE
}

/// 0   已经收费或者视同收费
/// 1   存在未付部分
/// ##class(web.DHCPE.DHCPEIAdm).HaveNoPayedItem(IADM)
ClassMethod HaveNoPayedItem(IADM As %String = "")
{
    q:IADM=""
    s Flag=0
    s PIADM=$P($g(^DHCPEIADM(IADM)),"^",4)
    s LocID=$P($g(^DHCPEPreIADM(PIADM)),"^",26)
    q:$G(^DHCPESetting("DHCPE","AllowPrint",LocID))="Y" Flag
    
    s CRMOID=0
    f  s CRMOID=$o(^DHCPECRMO(0,"IADM",IADM,CRMOID)) q:(CRMOID="")||(Flag=1)  d
    .s PreItemID=$p($g(^DHCPECRMO(CRMOID)),"^",2)
    .s ItemStatus=$p($g(^DHCPEPreIADM(+PreItemID,"ORDITEM",$p(PreItemID,"||",2))),"^",16)
    .q:ItemStatus'="1"
    .s PayStatus=$p($g(^DHCPECRMO(CRMOID)),"^",4)
    .s:(PayStatus="NP") Flag=1 //未付费或者部分付费
    q Flag
}

// Type 1:预约完成  2：登记  3：到达

/*ClassMethod UpdateTeamInfo(TeamID, Type)
{
    ;d ##class(web.DHCPE.DHCPEIAdm).UpdateTeamInfo("111||1",2)
    s SQLCODE=0
    s i=0
    s ErrNum=0
    s PreIADMID=0
    f  s PreIADMID=$O(^DHCPEPreIADM(0,"PGTeam",TeamID,PreIADMID)) q:(PreIADMID="")||(i>20)  d
    .s Status=$P(^DHCPEPreIADM(PreIADMID),"^",8)
    .q:(Status'="PREREG")&&(Type="1")
    .q:(Status'="REGISTERED")&&(Type="3")
    .q:((Status'="PREREG")&&(Status'="PREREGED"))&&(Type="2")
    .;s ^wrzUpdateTeamInfo(PreIADMID,1)=$H
    .TSTART
    .s SQLCODE=..UpdateIADMInfo(PreIADMID, Type,0)
    .TCOMMIT:SQLCODE=0
    .TROLLBACK:SQLCODE'=0
    .s:SQLCODE'=0 ErrNum=ErrNum+1
    .;s:SQLCODE'=0 
    .s:SQLCODE=0 i=i+1
    .;s ^wrzUpdateTeamInfo(PreIADMID,2)=$H
    q SQLCODE_"^"_i_"^"_ErrNum
}
*/
ClassMethod UpdateTeamInfo(TeamID, Type, OneNum As %Integer = 19, CurUser As %String = "")
{
    ;d ##class(web.DHCPE.DHCPEIAdm).UpdateTeamInfo("111||1",2)
    s SQLCODE=0
    s:CurUser="" CurUser=%session.Get("LOGON.USERID")
    s i=0
    s ErrNum=0
    s PreIADMID=0
    f  s PreIADMID=$O(^DHCPEPreIADM(0,"PGTeam",TeamID,PreIADMID)) q:(PreIADMID="")||(i>OneNum)  d
    .s Status=$P(^DHCPEPreIADM(PreIADMID),"^",8)
    .q:(Status'="PREREG")&&(Type="1")
    .q:(Status'="REGISTERED")&&(Type="3")
    .q:((Status'="PREREG")&&(Status'="PREREGED"))&&(Type="2")
    .TSTART
    .;s SQLCODE=..UpdateIADMInfo(PreIADMID, Type,0)
    .s SQLCODE=..UpdateIADMInfo(PreIADMID, Type,0,CurUser,0)
    .TCOMMIT:SQLCODE=0
    .TROLLBACK:SQLCODE'=0
    .s:SQLCODE'=0 ErrNum=ErrNum+1
    .s:SQLCODE=0 i=i+1
    i PreIADMID="" d
    .d ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(+TeamID)
    //登记改为回调，所以日志不能在类里面写
    /*
    i SQLCODE=0 d
    .s:Type="2" GType="TeamRegister"
    .s:Type="3" GType="TeamArrived"
    .d ##class(web.DHCPE.GAdmRecordManager).Insert(+TeamID,"P",GType,CurUser,TeamID) 
    */
    q SQLCODE_"^"_i_"^"_ErrNum
}

// 

// d ##class(web.DHCPE.DHCPEIAdm).AutoArrivedByCardNo("00000365")

ClassMethod AutoArrivedByCardNo(RegNo)
{
 
    s:$d(%session) LocID=%session.Get("LOGON.CTLOCID")
    s:'$d(%session) LocID=572
    //S LocID="152"
    s ArriveFlag=$p(^DHCPESetting("DHCPE","AutoArrived",LocID),"^",3)
    q:ArriveFlag="N" "0"
    s ret="0"
    s:$d(%session) CurUser=%session.Get("LOGON.USERID")
    s:'$d(%session) CurUser=5918
    //S CurUser=1
    i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo) 
    s PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
    q:PIBI="" "无到达操作的记录!"
    s PIADM=0
    s PIADMStr=""
    s i=0
    f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM)) q:PIADM=""  d
    .s PIADMStutas=$P(^DHCPEPreIADM(PIADM),"^", 8)
    .q:(PIADMStutas'="REGISTERED")&&(PIADMStutas'="PREREGED")
    .s i=i+1
    .s PIADMStr=PIADMStr_"^"_PIADM
     q:i>1 "此人存在多条体检记录,预约请选择进行操作!"
     q:i<1 "无到达操作的记录!"
     s PIADM=$P(PIADMStr,"^",2) 
     s PIADMStutas=$P(^DHCPEPreIADM(PIADM),"^", 8)

     i PIADMStutas="REGISTERED"  d
     .s ret=..IAdmArrived(PIADM)


     i PIADMStutas="PREREGED"   d
     .s ret=##class(web.DHCPE.TransAdmInfo).main(PIADM,CurUser)
     .q:ret'=""  
     .s ret=..IAdmArrived(PIADM)
  
    
    q ret
}

/*
ClassMethod AutoArrivedByCardNo(RegNo)
{ 
    s:$d(%session) LocID=%session.Get("LOGON.CTLOCID")
    //S LocID="152"
    s ArriveFlag=$p(^DHCPESetting("DHCPE","AutoArrived",LocID),"^",3)
    q:ArriveFlag="N" "0"
    s ret="0"
    s:$d(%session) CurUser=%session.Get("LOGON.USERID")
    //S CurUser=1
    i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo) 
    s PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
    Q:PIBI="" "0"
    s PIADM=0
    s PIADMStr=""
    s i=0
    f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM)) q:PIADM=""  d
    .s PIADMStutas=$P(^DHCPEPreIADM(PIADM),"^", 8)
    .q:(PIADMStutas'="REGISTERED")&&(PIADMStutas'="PREREGED")
    .s i=i+1
    .s PIADMStr=PIADMStr_"^"_PIADM

    
   
    
    q i_"$"_PIADMStr
}
*/
ClassMethod UpdateIADMInfo(PreIADMID, Type, TransFlag As %String = 1, CurUser As %String = "", FeeFlag As %String = 1)
{
    
    q:PreIADMID="" 0
    s Status=$P(^DHCPEPreIADM(PreIADMID),"^",8)
    s ret=0
    i CurUser="" d
    .s:$d(%session) CurUser=%session.Get("LOGON.USERID")
    .s:'$d(%session) CurUser=5918
    //PREREG,PREREGED,REGISTERED,ARRIVED,CANCELARRIVED,CANCELPE
    
    i Type=1
    {
        q:Status'="PREREG" "此人已经预约完成过，状态为"_Status
        d PreOver
    }
    i Type=2
    {
        q:(Status'="PREREG")&&(Status'="PREREGED") "此人已经登记过，状态为"_Status
        i Status="PREREG" d PreOver
        i ret'=0 q ret
        d Register
        i ret'="" q ret
        ;s RecheckFlag=$P(^DHCPEPreIADM(PreIADMID),"^",28)
        ;i RecheckFlag="Y" d
        ;.s ret=..IAdmArrived(PreIADMID)
        q 0
    }
    i Type=3
    {
        q:(Status="ARRIVED")||(Status="CANCELPE") "此人已经到达过，状态为"_Status
        i (Status="PREREG")||(Status="PREREGED")
        {
            s ret=..UpdateIADMInfo(PreIADMID,2)
            q:ret'=0 ret
        }
        i Status="CANCELARRIVED"
        {
            s IADMID=$O(^DHCPEIADM(0,"CRMADM",PreIADMID,0))
            s ret=..ArrivedUpdate(IADMID,"ARRIVED")
        }
        else
        {
            s ret=..IAdmArrived(PreIADMID)
        }
        q ret
    }
    
PreOver
    s ret=##class(web.DHCPE.PreIADM).CancelAdm("","",PreIADMID_"^PREREGED^")
    q
Register
    ;s ret=##class(web.DHCPE.TransAdmInfo).main(PreIADMID,CurUser,TransFlag)
    s ret=##class(web.DHCPE.TransAdmInfo).main(PreIADMID,CurUser,TransFlag,FeeFlag)
    s:ret="" ret=0
    q
}

/// w ##class(web.DHCPE.DHCPEIAdm).SaveRecPaper(18005,"20/12/2012") 
/// add by xy 20180502
ClassMethod SaveRecPaper(PIADM, ReportDate, SendMethod)
{
    q:PIADM="" "不存在预约纪录"
    q:$d(^DHCPEDataEx("ConfirmRecPaper",PIADM)) "已经收表"
    s Time=$P($H,",",2)
    s ^DHCPEDataEx("ConfirmRecPaper",PIADM)=..IAdmRecived(Time) 
    s ^DHCPEDataEx("ConfirmRecPaper","Date",+$h,PIADM)=""
    s ^DHCPEDataEx("ConfirmRecPaper","DateTime",+$h,Time,PIADM)=""
    s ^DHCPEDataEx("ConfirmRecPaper","ReportDate",PIADM)=ReportDate
    s ^DHCPEDataEx("ConfirmRecPaper","SendReport",PIADM)=SendMethod
    q:ReportDate="" 0
    s ^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",PIADM)=ReportDate_"^"_Time
    s ^DHCPEDataExi("DHCPEPreIADM","GetReportDateTime","I",ReportDate,Time,PIADM)=""
    q 0
}

/// w ##class(web.DHCPE.DHCPEIAdm).GetRecPaper(18005,"20/12/2012") 
/// add by rxb 20121021
ClassMethod GetRecPaper(RegNo, ReportDate, SendMethod As %String = "")
{
    s:$d(%session) LocID=%session.Get("LOGON.CTLOCID")
    s:'$d(%session) LocID=572
    s:ReportDate'="" ReportDate=##class(websys.Conversions).DateHtmlToLogical(ReportDate)
    s:ReportDate="" ReportDate=+$h
    s PIADMInfo=..GetPIADMByRegNo(RegNo)
    s Flag=$P(PIADMInfo,"^",1)
    s PIADMStr=$P(PIADMInfo,"^",2)
    q:Flag'=0 PIADMStr
    q:PIADMStr="" "不存在预约纪录"
    s PIADM=PIADMStr
    q:$d(^DHCPEDataEx("ConfirmRecPaper",PIADM)) "已经收表"
    s Time=$P($H,",",2)
    s ^DHCPEDataEx("ConfirmRecPaper",PIADM)=..IAdmRecived(Time) 
    s ^DHCPEDataEx("ConfirmRecPaper","Date",+$h,PIADM)=""
    s ^DHCPEDataEx("ConfirmRecPaper","DateTime",+$h,Time,PIADM)=""
    s ^DHCPEDataEx("ConfirmRecPaper","ReportDate",PIADM)=ReportDate
    s ^DHCPEDataEx("ConfirmRecPaper","SendReport",PIADM)=SendMethod
    q:ReportDate="" 0
    s ^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",PIADM)=ReportDate_"^"_Time
    s ^DHCPEDataExi("DHCPEPreIADM","GetReportDateTime","I",ReportDate,Time,PIADM)=""
    //q:str'="" str
    q 0
}

ClassMethod GetRecPaperNew(PAADM, ReportDate, SendMethod As %String = "", Remark As %String = "")
{
	s:ReportDate'="" ReportDate=##class(websys.Conversions).DateHtmlToLogical(ReportDate)
    s:ReportDate="" ReportDate=+$h
    
    s LocID=$p($g(^PAADM(PAADM)),"^",4)
    S IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,""))
    q:IADM="" ""
    S PIADM=$P($G(^DHCPEIADM(IADM)),"^",4)
    q:$d(^DHCPEDataEx("ConfirmRecPaper",PIADM)) "已经收表"_"#"
    s Time=$P($H,",",2)
    s ^DHCPEDataEx("ConfirmRecPaper",PIADM)=..IAdmRecived(Time) 
    s ^DHCPEDataEx("ConfirmRecPaper","Date",+$h,PIADM)=""
    s ^DHCPEDataEx("ConfirmRecPaper","DateTime",+$h,Time,PIADM)=""
    s ^DHCPEDataEx("ConfirmRecPaper","ReportDate",PIADM)=ReportDate
    s ^DHCPEDataEx("ConfirmRecPaper","SendReport",PIADM)=SendMethod
    s ^DHCPEDataEx("ConfirmRecPaper","Remark",PIADM)=Remark
    q:ReportDate="" 0
    s ^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",PIADM)=ReportDate_"^"_Time
    s ^DHCPEDataExi("DHCPEPreIADM","GetReportDateTime","I",ReportDate,Time,PIADM)=""
    d ##class(web.DHCPE.AdmRecordManager).Insert(PIADM,"P","RecPaper","","")
    q 0_"#"_$g(^DHCPESetting("DHCPE","IsPGetReportPT",LocID))
}

// 收表后获取人员基本信息用于打印领取报告凭条

ClassMethod GetBaseInfo(PAADM, ReportDate)
{
    s IADM=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
    q:IADM="" ""
    s PreIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
    s Team=""
    s PIBI=$P($g(^DHCPEPreIADM(PreIADM)),"^",1) 
    s Team=$P($g(^DHCPEPreIADM(PreIADM)),"^",2)
    s OrderSetsDesc=##class(web.DHCPE.Query.IAdmItemStatus).GetArcSetDesc(PreIADM)
    s PEIADM=""
    s PEIADM=$o(^DHCPEIADM(0,"CRMADM",PreIADM,PEIADM))
    s PEdate=$p($g(^DHCPEIADM(PEIADM)),"^",5)
    S PEdate=##class(websys.Conversions).DateLogicalToHtml(PEdate)
    ;q:(Team'="") ""
    s RegNo=$P($g(^DHCPEPreIBI(PIBI)),"^",1)
    s Name=$P($g(^DHCPEPreIBI(PIBI)),"^",2)
    s Sex=$P($g(^DHCPEPreIBI(PIBI)),"^",3)
    i Sex'="" s Sex=$P($g(^CT("SEX",Sex)),"^",2)
  
    //s Age=$p($g(^DHCPEPreIBI(PIBI)),"^",4)
    //i Age'="" s Age=##class(web.DHCDocCommon).GetAgeDescNew($zd(Age,3),"")
    S Age=""
    S PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
    I PAPMIRowId'="" s Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIRowId,PAADM)

    s HpNo=$P(^DHCPEPreIADM(PreIADM),"^",27)
    
    q RegNo_"^"_Name_"^"_Sex_"^"_Age_"^"_ReportDate_"^"_OrderSetsDesc_"^"_PEdate_"^"_HpNo
}

/// w ##class(web.DHCPE.DHCPEIAdm).GetPAADMByPADM("49106")
ClassMethod GetPAADMByPADM(PADM)
{
    
    q:(PADM="") ""
    s IADM=$o(^DHCPEIADM(0,"CRMADM",PADM,0))
    q:(IADM="") ""
    s PAADM=""
    s PAADM=$p(^DHCPEIADM(IADM),"^")
    q PAADM
}

/// w ##class(web.DHCPE.DHCPEIAdm).GetPIADMByRegNo(RegNo)
ClassMethod GetPIADMByRegNo(RegNo)
{
    i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo) 
    q:('($L(RegNo)>0)) "-1^请输入正确的登记号"
    s PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
    q:PIBI="" "_1^无该人员的基本信息!"
    s PIADM=""
    s PIADMStr="" 
    s PIADMStutas=""
    f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM),-1) q:(PIADM="")||(PIADMStr'="")  d
    .s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM)         //Add by 090702
    .q:LocFlag=1  
    .s PIADMStutas=$P(^DHCPEPreIADM(PIADM),"^", 8)
    .q:"ARRIVED"'=PIADMStutas
    .s ReCheck=$P(^DHCPEPreIADM(PIADM),"^", 28)
    .q:ReCheck="Y"
    .s PIADMStr=PIADM
    q "0^"_PIADMStr
}

ClassMethod CancelRecPaper(PIADM)
{
     q:'$d(^DHCPEDataEx("ConfirmRecPaper",PIADM)) "-1"
     s KData=""
     s KTime=""
     s KData=$p(^DHCPEDataEx("ConfirmRecPaper",PIADM),"^",1)
     s KTime=$p(^DHCPEDataEx("ConfirmRecPaper",PIADM),"^",2)
     k ^DHCPEDataEx("ConfirmRecPaper","Date",KData,PIADM)
     k ^DHCPEDataEx("ConfirmRecPaper","DateTime",KData,KTime,PIADM)
     k ^DHCPEDataEx("ConfirmRecPaper","ReportDate",PIADM)
     k ^DHCPEDataEx("ConfirmRecPaper","Remark",PIADM)
     s KReportDate=""
     s KKTime=""
     s KReportDate=$p($G(^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",PIADM)),"^",1)
     s KKTime=$p($G(^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",PIADM)),"^",2)
     k:KReportDate'="" ^DHCPEDataExi("DHCPEPreIADM","GetReportDateTime","I",KReportDate,KKTime,PIADM)
     k ^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",PIADM)
     k ^DHCPEDataEx("ConfirmRecPaper",PIADM)
     q 0
}

/// add by rxb 20121021
ClassMethod IAdmRecived(Time)
{
    s:$d(%session) LocID=%session.Get("LOGON.CTLOCID")
    s:'$d(%session) LocID=572
    s:$d(%session) CurUser=%session.Get("LOGON.USERID")
    s:'$d(%session) CurUser=5918
    s CurDate=$p($h,",",1)  
    s CurTime=$p($h,",",2)
    s ret=CurDate_"^"_Time_"^"_CurUser_"^"_LocID
    //s ret=CurDate_"^"_CurTime
    q ret
}

ClassMethod GetNoPaidItems(PIADM)
{
    s IAdmId=0
    s str=""
    s IAdmId=$o(^DHCPEIADM(0,"CRMADM",PIADM,IAdmId))
    s PAADM=$p(^DHCPEIADM(IAdmId),"^",1)
    s OEORDRowId=0 
    s OEORDRowId=$O(^OEORD(0,"Adm",PAADM,OEORDRowId))  //oe_order表
    q:""=OEORDRowId
    s OEORIChildsub=0
    f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:(""=OEORIChildsub)  d
    .s OEORIRowId=OEORDRowId_"||"_OEORIChildsub  //oe_order表 ID
    .s BilledStatus=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",5)  //oe_orditem 付费状态
    .s:"P"'=BilledStatus str="收表成功，但存在未收费项目，请前台人员确认！"
    Q str
}

/// add by rxb 20121114
/// 查询个人套餐已收表名单
/// d ##class(%ResultSet).RunQuery("web.DHCPE.DHCPEIAdm","SearchPaperByRecDate",62838,62838)
Query SearchPaperByRecDate(RecBegDate As %String, RecEndDate As %String, txtRegNo As %String, ArrivedFlag As %String = "") As %Query(ROWSPEC = "TAdmNo:%String, TPatNAME:%String, TSex:%String,TAge:%String, TOrdSet:%String, TReceiver:%String, TReceivedDate:%String, TTel:%String,TReportDate:%String,PIADM:%String")
{
}

ClassMethod SearchPaperByRecDateExecute(ByRef qHandle As %Binary, RecBegDate As %String, RecEndDate As %String, txtRegNo As %String, ArrivedFlag As %String = "") As %Status
{
 
    k ^DHCPETMPRECPAPERData("RowData","I") 
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=2
    //add
    i ArrivedFlag="" s ArrivedFlag="N"
    else  s ArrivedFlag="Y"
    //
    s TotalPerson=0
    s:$d(%session) LocID=%session.Get("LOGON.CTLOCID")
    s:'$d(%session) LocID=572
    s:$d(%session) CurUser=%session.Get("LOGON.USERID")
    s:'$d(%session) CurUser=5918
    i RecBegDate="" s RecBegDate=+$h
    i RecEndDate="" s RecEndDate=+$h 
    s AdmDate=RecBegDate-1
    
    
    i (RecBegDate>RecEndDate)
    {
        Set qHandle=$lb(0,repid,0) 
        Quit $$$OK
    }
    
    //add
    
    i ""'=txtRegNo d
    .d Clear
    .s txtRegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(txtRegNo)
    .s PIBIDR=$o(^DHCPEPreIBI(0,"PAPMINo",txtRegNo,0))
    .Quit:PIBIDR=""
    .d GetPersonInfo
    .s PIADM=0
    .f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBIDR,PIADM))  Quit:PIADM=""  Do 
    ..q:(""'=$p(^DHCPEPreIADM(PIADM),"^",2))                      //非团体
    ..i ArrivedFlag="Y" d
    ...i $d(^DHCPEDataEx("ConfirmRecPaper",PIADM))=0 d
    ....d OutPut
    ..e  d
    ...i $d(^DHCPEDataEx("ConfirmRecPaper",PIADM)) d
    ....s RecievedDate=$zd($p(^DHCPEDataEx("ConfirmRecPaper",PIADM),"^",1),3)                //_" "_$zt($p(^DHCPEDataEx("ConfirmRecPaper",PIADM),"^",2),1)
    ....s RecieverID=$p(^DHCPEDataEx("ConfirmRecPaper",PIADM),"^",3)
    ....s:$d(^SSU("SSUSR",RecieverID)) RecieverName=$p(^SSU("SSUSR",RecieverID),"^",2) 
    ...i $d(^DHCPEDataEx("ConfirmRecPaper","ReportDate",PIADM)) d
    ....s TotalPerson=TotalPerson+1
    ....s ReportDate=$zd($p(^DHCPEDataEx("ConfirmRecPaper","ReportDate",PIADM),"^",1),3)
    ...q:""=RecieverName
    ...d OutPut  
    e  d
    .s PIADM=""
    .i ArrivedFlag="Y" d
    ..f  s AdmDate=$o(^DHCPEIADM(0,"AdmDateTime",AdmDate))  q:(AdmDate="")||(AdmDate>RecEndDate)  d
    ...s Date=$ZD(AdmDate,3)
    ...s AdmTime=0
    ...f  s AdmTime=$o(^DHCPEIADM(0,"AdmDateTime",AdmDate,AdmTime))  q:AdmTime=""  d
    ....s IADMRowID=0
    ....f  s IADMRowID=$o(^DHCPEIADM(0,"AdmDateTime",AdmDate,AdmTime,IADMRowID)) q:IADMRowID=""  d
    .....s Status=$P($g(^DHCPEIADM(IADMRowID)),"^",8)
    .....Q:"ARRIVED"'=Status
    .....s PIADM=$p(^DHCPEIADM(IADMRowID),"^",4)
    .....q:($d(^DHCPEDataEx("ConfirmRecPaper",PIADM))=1) 
    .....s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM)         //Add by 090702
    .....q:LocFlag=1  
    .....q:(""'=$p(^DHCPEPreIADM(PIADM),"^",2))
    .....d Clear 
    .....s PIBIDR=$p(^DHCPEPreIADM(PIADM),"^",1)
    .....q:PIBIDR=""
    .....d GetPersonInfo
    .....s TotalPerson=TotalPerson+1
    .....d OutPut
    .e  d
    ..s PIADM=""
    ..s RecDate=RecBegDate-1  
    ..f  s RecDate=$o(^DHCPEDataEx("ConfirmRecPaper","DateTime",RecDate)) q:(RecDate="")||(RecDate>RecEndDate)  d
    ...s Time=""
    ...f  s Time=$O(^DHCPEDataEx("ConfirmRecPaper","DateTime",RecDate,Time),-1) q:Time=""  d
    ....f  s PIADM=$o(^DHCPEDataEx("ConfirmRecPaper","DateTime",RecDate,Time,PIADM)) q:PIADM=""  d 
    .....s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM)         //Add by 090702
    .....q:LocFlag=1   
    .....q:(""'=$p(^DHCPEPreIADM(PIADM),"^",2)) 
    .....d Clear 
    .....s PIBIDR=$p(^DHCPEPreIADM(PIADM),"^",1)
    .....q:PIBIDR="" 
    .....d GetPersonInfo 
    .....i $d(^DHCPEDataEx("ConfirmRecPaper",PIADM)) d
    ......s TotalPerson=TotalPerson+1
    ......s RecievedDate=$zd($p(^DHCPEDataEx("ConfirmRecPaper",PIADM),"^",1),3)               //_" "_$zt($p(^DHCPEDataEx("ConfirmRecPaper",PIADM),"^",2),1)
    ......s RecieverID=$p(^DHCPEDataEx("ConfirmRecPaper",PIADM),"^",3) 
    ......s:$d(^SSU("SSUSR",RecieverID)) RecieverName=$p(^SSU("SSUSR",RecieverID),"^",2) 
    .....i $d(^DHCPEDataEx("ConfirmRecPaper","ReportDate",PIADM)) d
    ......s ReportDate=$zd($p(^DHCPEDataEx("ConfirmRecPaper","ReportDate",PIADM),"^",1),3)
    .....q:""=RecieverName 
    .....d OutPut  
    d Clear
    s ind=1
    s RegNo="总计："
    s PatName=TotalPerson_"人"
    d OutPut 
    Set qHandle=$lb(0,repid,0) 
    Quit $$$OK
GetPersonInfo
    s RegNo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",1)
    s PatName=$p($g(^DHCPEPreIBI(PIBIDR)),"^",2)
    s SexDR=$p($g(^DHCPEPreIBI(PIBIDR)),"^",3)
    s Sex=$p($g(^CT("SEX",SexDR)),"^",2)
    s Age=$p($g(^DHCPEPreIBI(PIBIDR)),"^",4) 
    s:Age'="" Age=$P(##class(web.DHCLCNUREXCUTE).CalAge(Age,+$H),"Y",1) 
    s TelNo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",6)
    s:TelNo="" TelNo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",7)
    s:TelNo="" TelNo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",8)
    q
Clear
    s (RegNo,PatName,Sex,Age,OrdSetDesc,RecieverName,RecievedDate,TelNo,ReportDate)=""
    q 
OutPut
    set Data=$lb(RegNo,PatName,Sex,Age,OrdSetDesc,RecieverName,RecievedDate,TelNo,ReportDate,PIADM)  
    set ^DHCPETMPRECPAPERData("RowData","I",ind)=RegNo_"^"_PatName_"^"_Sex_"^"_Age_"^"_OrdSetDesc_"^"_RecieverName_"^"_RecievedDate_"^"_TelNo_"^"_ReportDate
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod SearchPaperByRecDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPaperByRecDateExecute ]
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

ClassMethod SearchPaperByRecDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPaperByRecDateExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Description: 查询团体已收表名单
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCPE.DHCPEIAdm","SearchGPaperByRecDate",63128,63128,"","","^NOR^")
Query SearchGPaperByRecDate(RecBegDate As %String, RecEndDate As %String, txtRegNo As %String, ArrivedFlag As %String = "", VIPType As %String = "", VIPLevel As %String = "", ALLPerson As %String = "", ALLGroup As %String = "", HospID As %String = "") As %Query(ROWSPEC = "TSort:%String,TAdmNo:%String, TPatNAME:%String, TSex:%String,TAge:%String, TOrdSet:%String, TReceiver:%String, TReceivedDate:%String, TTel:%String, TGDesc:%String,TPosition:%String,TTeam:%String,TReportDate:%String,PIADM:%String,TVip:%String,TGroupTel1:%String,TSendMethod:%String,TAmount:%String,TRemark:%String")
{
}

ClassMethod SearchGPaperByRecDateExecute(ByRef qHandle As %Binary, RecBegDate As %String, RecEndDate As %String, txtRegNo As %String, ArrivedFlag As %String = "", VIPType As %String = "", VIPLevel As %String = "", ALLPerson As %String = "", ALLGroup As %String = "", HospID As %String = "") As %Status
{
   
    k ^DHCPETMPRECPAPERData("RowData","I") 
    
    Set repid=$I(^CacheTemp)
    s Job=$J
    If $g(ind)="" Set ind=1
     s TVip=""
    i VIPType="^VIP^"  s VIPType="2"
    i VIPType="^NOR^"  s VIPType="1"
    i VIPType="^VIP^NOR^"  s VIPType=""
    
    i ArrivedFlag="" s ArrivedFlag="N"
    else  s ArrivedFlag="Y"
    
    i ALLPerson="" s ALLPerson="N"
    else  s ALLPerson="Y"
    
    i ALLGroup="" s ALLGroup="N"
    else  s ALLGroup="Y"

    s TotalPerson=0
    s:$d(%session) LocID=%session.Get("LOGON.CTLOCID")
    s:'$d(%session) LocID=572
    s:$d(%session) CurUser=%session.Get("LOGON.USERID")
    s:'$d(%session) CurUser=5918
    i RecBegDate'="" s RecBegDate=##class(websys.Conversions).DateHtmlToLogical(RecBegDate) 
    i RecEndDate'="" s RecEndDate=##class(websys.Conversions).DateHtmlToLogical(RecEndDate) 
     
    i RecBegDate="" s RecBegDate=+$h
    i RecEndDate="" s RecEndDate=+$h 
    i (RecBegDate>RecEndDate)
    {
        Set qHandle=$lb(0,repid,0) 
        Quit $$$OK 
    }
    s sort=0,flag=0,RFlag=0
    i ""'=txtRegNo d
    .d Clear
    .//优先按照体检号进行查询，查不到数据按照登记号查询
    .s PreID=##class(web.DHCPE.HISUICommon).GetPreIDByHPNo(txtRegNo)
    .i PreID'=""  s PIBIDR=$P($g(^DHCPEPreIADM(PreID)),"^",1)
    .i PreID=""   s PIBIDR=$o(^DHCPEPreIBI(0,"PAPMINo",txtRegNo,0))
    .q:PIBIDR=""
    .s PAPMI=$o(^PAPERi("PAPMI_PatNo",txtRegNo,0))
    .s PAADM="" 
    .d GetPersonInfo
    .s PIADM=0
    .f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBIDR,PIADM))  Quit:PIADM=""  Do 
    ..;q:(0=$d(^DHCPEDataEx("ConfirmRecPaper",PIADM)))
    ..s RFlag=0
    ..i ArrivedFlag="N" d
    ...i (0=$d(^DHCPEDataEx("ConfirmRecPaper",PIADM))) s RFlag=1
    ..i ArrivedFlag="Y" d
    ...i (1=$d(^DHCPEDataEx("ConfirmRecPaper",PIADM))) s RFlag=1
    ..q:RFlag=1
    ..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM)         //Add by 090702
    ..q:LocFlag=1  
    ..s Amount=+##class(web.DHCPE.HandlerPreOrds).IGetAmount4Person(PIADM)
    ..i $p(Amount,".",1)="" s Amount=0_Amount
    ..s Amount=$fn(Amount,"",2)
    ..s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
    ..q:IADM=""
    ..S PAADM=$P($G(^DHCPEIADM(IADM)),"^",1)
    ..S PAPMI=$P($G(^PAADM(PAADM)),"^",1)

    ..s Depart=$G(^DHCPEDataEx("DHCPEPreIADM","Position",PIADM))
    ..s GroupDesc="",flag=0
    ..s TVip=$p(^DHCPEPreIADM(PIADM),"^",18)
    ..q:(VIPLevel'="")&&(VIPLevel'=TVip)
    ..s PGADMDR=$p(^DHCPEPreIADM(PIADM),"^",2)
    ..i PGADMDR'="" d
    ...s PGBIDR=$p(^DHCPEPreGADM(PGADMDR),"^",1)
    ...s GroupDesc=$p(^DHCPEPreGBI(PGBIDR),"^",2)
    ...s TGroupTel1=$p(^DHCPEPreGBI(PGBIDR),"^",8)
    ...s:TGroupTel1="" TGroupTel1=$p(^DHCPEPreGBI(PGBIDR),"^",9)
    ..i GroupDesc'="" s flag=1
    ..s OrdSetDesc=##class(web.DHCPE.Query.IAdmItemStatus).GetArcSetDesc(PIADM)
    ..;s OrdSetID=$G(^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",PIADM)) 
    ..;i OrdSetID'="" d
    ..;.s OrdSetID=$p(OrdSetID,"^",2)  
    ..;.s OrdSetDesc=$p($g(^ARCOS(OrdSetID)),"^",2)
    ..;.s OrdSetDesc=$p(OrdSetDesc,"-",2)
    ..;q:((OrdSetID'="")&&(0=$d(^DHCPEDataEx("DHCPEBaseData","PEARCOS",OrdSetID,"LOC",LocID))))
    ..s RecieverName="",RecievedDate="",SendMethod=""
    ..i $d(^DHCPEDataEx("ConfirmRecPaper",PIADM)) d
    ...;s TotalPerson=TotalPerson+1
    ...s RecievedDate=##class(websys.Conversions).DateLogicalToHtml($p(^DHCPEDataEx("ConfirmRecPaper",PIADM),"^",1))   //_" "_$zt($p(^DHCPEDataEx("ConfirmRecPaper",PIADM),"^",2),1)
    ...s RecieverID=$p(^DHCPEDataEx("ConfirmRecPaper",PIADM),"^",3)
    ...s:$d(^SSU("SSUSR",RecieverID)) RecieverName=$p(^SSU("SSUSR",RecieverID),"^",2) 
    ..i $d(^DHCPEDataEx("ConfirmRecPaper","ReportDate",PIADM)) d
    ...s ReportDate=##class(websys.Conversions).DateLogicalToHtml($p(^DHCPEDataEx("ConfirmRecPaper","ReportDate",PIADM),"^",1))
    ...s SendMethod=$g(^DHCPEDataEx("ConfirmRecPaper","SendReport",PIADM))
    ..s Remark=""
    ..s Remark=$g(^DHCPEDataEx("ConfirmRecPaper","Remark",PIADM))

    ..;q:""=RecieverName
    ..d OutPut
    ..i GroupDesc="" s GroupDesc="个人"
    ..s TotalPerson=TotalPerson+1
    ..s GTotal=+$G(^TempDHCPERecPaper(Job,GroupDesc))+1
    ..s ^TempDHCPERecPaper(Job,GroupDesc)=GTotal
    e  d 
    .s PIADM=""
    .s RecDate=RecBegDate-1
    .i ArrivedFlag="Y" d
    ..f  s RecDate=$o(^DHCPEIADM(0,"AdmDateTime",RecDate))  q:(RecDate="")||(RecDate>RecEndDate)  d
    ...s Date=##class(websys.Conversions).DateLogicalToHtml(RecDate)
    ...s AdmTime=0
    ...f  s AdmTime=$o(^DHCPEIADM(0,"AdmDateTime",RecDate,AdmTime))  q:AdmTime=""  d
    ....s IADMRowID=0
    ....f  s IADMRowID=$o(^DHCPEIADM(0,"AdmDateTime",RecDate,AdmTime,IADMRowID)) q:IADMRowID=""  d
    .....s Status=$P($g(^DHCPEIADM(IADMRowID)),"^",8)
    .....Q:"ARRIVED"'=Status
    .....
    .....s PIADM=$p(^DHCPEIADM(IADMRowID),"^",4)
    .....S PAADM=$P($G(^DHCPEIADM(IADMRowID)),"^",1)
    .....S PAPMI=$P($G(^PAADM(PAADM)),"^",1)
    .....q:($d(^DHCPEDataEx("ConfirmRecPaper",PIADM))=1) 
    .....s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM)         //Add by 090702
    .....q:LocFlag=1  
    .....;q:(""=$p(^DHCPEPreIADM(PIADM),"^",2))
    .....d Clear 
    .....s PIBIDR=$p(^DHCPEPreIADM(PIADM),"^",1)
    .....q:PIBIDR=""
    .....s Amount=+##class(web.DHCPE.HandlerPreOrds).IGetAmount4Person(PIADM)
    .....i $p(Amount,".",1)="" s Amount=0_Amount
    .....s Amount=$fn(Amount,"",2)
    .....s TVip=$p(^DHCPEPreIADM(PIADM),"^",18)
    .....q:(VIPLevel'="")&&(VIPLevel'=TVip)
    .....d GetPersonInfo
    .....s Depart=$G(^DHCPEDataEx("DHCPEPreIADM","Position",PIADM))
    .....s PGADMDR=$p(^DHCPEPreIADM(PIADM),"^",2)
    .....s GroupDesc="",flag=0
    .....i PGADMDR'="" d
    ......s PGBIDR=$p(^DHCPEPreGADM(PGADMDR),"^",1)
    ......s GroupDesc=$p(^DHCPEPreGBI(PGBIDR),"^",2)
    ......s TGroupTel1=$p(^DHCPEPreGBI(PGBIDR),"^",8)
    ......s:TGroupTel1="" TGroupTel1=$p(^DHCPEPreGBI(PGBIDR),"^",9)
    .....i GroupDesc'="" s flag=1
    .....d OutPut
    .....i GroupDesc="" s GroupDesc="个人"
    .....s TotalPerson=TotalPerson+1
    .....s GTotal=+$G(^TempDHCPERecPaper(Job,GroupDesc))+1
    .....s ^TempDHCPERecPaper(Job,GroupDesc)=GTotal
    .e  d
    ..f  s RecDate=$o(^DHCPEDataEx("ConfirmRecPaper","DateTime",RecDate)) q:(RecDate="")||(RecDate>RecEndDate)  d
    ...s Time=""
    ...f  s Time=$O(^DHCPEDataEx("ConfirmRecPaper","DateTime",RecDate,Time),-1) q:Time=""  d
    ....f  s PIADM=$o(^DHCPEDataEx("ConfirmRecPaper","DateTime",RecDate,Time,PIADM)) q:PIADM=""  d
    .....s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM)         //Add by 090702
    .....q:LocFlag=1  
    .....;q:(""=$p(^DHCPEPreIADM(PIADM),"^",2))
    .....d Clear 
    .....s PIBIDR=$p(^DHCPEPreIADM(PIADM),"^",1)
    .....q:PIBIDR=""
    .....s Amount=+##class(web.DHCPE.HandlerPreOrds).IGetAmount4Person(PIADM)
    .....i $p(Amount,".",1)="" s Amount=0_Amount
    .....s Amount=$fn(Amount,"",2)
    .....s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
    .....S PAADM=$P($G(^DHCPEIADM(IADM)),"^",1)
    .....S PAPMI=$P($G(^PAADM(PAADM)),"^",1)
    .....s TVip=$p(^DHCPEPreIADM(PIADM),"^",18)
    .....q:(VIPLevel'="")&&(VIPLevel'=TVip)
    .....d GetPersonInfo
    .....s Depart=$G(^DHCPEDataEx("DHCPEPreIADM","Position",PIADM))
    .....s PGADMDR=$p(^DHCPEPreIADM(PIADM),"^",2)
    .....s GroupDesc="",flag=0
    .....i PGADMDR'="" d
    ......s PGBIDR=$p(^DHCPEPreGADM(PGADMDR),"^",1)
    ......s GroupDesc=$p(^DHCPEPreGBI(PGBIDR),"^",2)
    ......s TGroupTel1=$p(^DHCPEPreGBI(PGBIDR),"^",8)
    ......s:TGroupTel1="" TGroupTel1=$p(^DHCPEPreGBI(PGBIDR),"^",9)
    .....i GroupDesc'="" s flag=1
    .....s OrdSetDesc=##class(web.DHCPE.Query.IAdmItemStatus).GetArcSetDesc(PIADM)
    .....;s OrdSetID=$G(^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",PIADM)) 
    .....;i OrdSetID'="" d
    .....;.s OrdSetID=$p(OrdSetID,"^",2)  
    .....;.s OrdSetDesc=$p($g(^ARCOS(OrdSetID)),"^",2)
    .....;.s OrdSetDesc=$p(OrdSetDesc,"-",2)
    .....;q:((OrdSetID'="")&&(0=$d(^DHCPEDataEx("DHCPEBaseData","PEARCOS",OrdSetID,"LOC",LocID))))
    .....i $d(^DHCPEDataEx("ConfirmRecPaper",PIADM)) d
    ......s RecievedDate=##class(websys.Conversions).DateLogicalToHtml($p(^DHCPEDataEx("ConfirmRecPaper",PIADM),"^",1))             //_" "_$zt($p(^DHCPEDataEx("ConfirmRecPaper",PIADM),"^",2),1)
    ......s RecieverID=$p(^DHCPEDataEx("ConfirmRecPaper",PIADM),"^",3)
    ......s:$d(^SSU("SSUSR",RecieverID)) RecieverName=$p(^SSU("SSUSR",RecieverID),"^",2) 
    .....i $d(^DHCPEDataEx("ConfirmRecPaper","ReportDate",PIADM)) d
    ......s ReportDate=##class(websys.Conversions).DateLogicalToHtml($p(^DHCPEDataEx("ConfirmRecPaper","ReportDate",PIADM),"^",1))
    ......s SendMethod=$g(^DHCPEDataEx("ConfirmRecPaper","SendReport",PIADM))
    .....s Remark=""
    .....s Remark=$g(^DHCPEDataEx("ConfirmRecPaper","Remark",PIADM))

    .....q:""=RecieverName
    
    .....d OutPut
    .....i GroupDesc="" s GroupDesc="个人"
    .....s TotalPerson=TotalPerson+1
    .....s GTotal=+$G(^TempDHCPERecPaper(Job,GroupDesc))+1
    .....s ^TempDHCPERecPaper(Job,GroupDesc)=GTotal
    .....;d OutPut  
    d Clear
    ;s ind=1
    i ALLGroup="Y" s flag=1
    I ALLPerson="Y" s flag=0
    S ITotal=0,GTotal=0
    s GroupDesc2=""
    f  s GroupDesc2=$O(^TempDHCPERecPaper(Job,GroupDesc2)) q:GroupDesc2=""  d
    .i GroupDesc2="个人" s ITotal=$G(^TempDHCPERecPaper(Job,GroupDesc2))
    S GTotal=TotalPerson-ITotal
    I ALLGroup="Y" S TotalPerson=GTotal
    I ALLPerson="Y" S TotalPerson=ITotal
    s sort=""
    s RegNo="总计："
    s PatName=TotalPerson_"人"
    d OutPut
    ;s ind=2
    s GroupDesc2=""
    f  s GroupDesc2=$O(^TempDHCPERecPaper(Job,GroupDesc2)) q:GroupDesc2=""  d
    .d Clear
    .s RegNo=GroupDesc2
    .s PatName=$G(^TempDHCPERecPaper(Job,GroupDesc2))_"人"
    .q:(ALLPerson="Y")&&(GroupDesc2'="个人")
    .q:(ALLGroup="Y")&&(GroupDesc2="个人")
    .d OutPut
    k ^TempDHCPERecPaper(Job)
    
    Set qHandle=$lb(0,repid,0) 
    Quit $$$OK
GetPersonInfo
    s RegNo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",1)
    s PatName=$p($g(^DHCPEPreIBI(PIBIDR)),"^",2)
    s SexDR=$p($g(^DHCPEPreIBI(PIBIDR)),"^",3)
    s Sex=$p($g(^CT("SEX",SexDR)),"^",2)
    ;s Age=$p($g(^DHCPEPreIBI(PIBIDR)),"^",4) 
    ;s:Age'="" Age=$P(##class(web.DHCLCNUREXCUTE).CalAge(Age,+$H),"Y",1) 
    ;s Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMI,PAADM)
     s Age=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PAPMI,HospID)
    s TelNo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",6)
    s:TelNo="" TelNo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",7)
    s:TelNo="" TelNo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",8)
    q
Clear
    s (RegNo,PatName,Sex,Age,OrdSetDesc,RecieverName,RecievedDate,TelNo,GroupDesc,Depart,Team,ReportDate,TVip,TGroupTel1,SendMethod,Amount,Remark)=""
    q 
OutPut
    //I TVip'="" S TVip=##class(web.DHCPE.VIPLevel).GetVIPDescByID(TVip)
    i TVip'="" s TVip=##class(web.DHCPE.CT.HISUICommon).GetVIPDescByID(TVip)
    //s:(TVip=1) TVip="普通"
    //s:(TVip=2) TVip="VIP"
    i SendMethod="ZQ" s SendMethod="自取"
    i SendMethod="TQ" s SendMethod="统取"
    i SendMethod="KD" s SendMethod="快递"
    i SendMethod="DZB" s SendMethod="电子版"
    q:(ALLPerson="Y")&&(flag="1")
    q:(ALLGroup="Y")&&(flag'="1")
    s sort=sort+1
    i Sex="" s sort=""
    
    /***翻译 start***/
	s Sex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",Sex,"CTSEXDesc","cls")
    s TVip=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEVIPLevel",TVip,"VLDesc","cls")
    s SendMethod=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcperecpaper.hisui.csp",SendMethod)
    /***翻译 end***/

    set Data=$lb(sort,RegNo,PatName,Sex,Age,OrdSetDesc,RecieverName,RecievedDate,TelNo,GroupDesc,Depart,Team,ReportDate,PIADM,TVip,TGroupTel1,SendMethod,Amount,Remark)  
    set ^DHCPETMPRECPAPERData("RowData","I",ind)=RegNo_"^"_PatName_"^"_Sex_"^"_Age_"^"_OrdSetDesc_"^"_RecieverName_"^"_RecievedDate_"^"_TelNo_"^"_ReportDate_"^"_SendMethod_"^"_Amount
    
    //set ^DHCPETMPRECPAPERData("RowData","G",ind)=RegNo_"^"_PatName_"^"_Sex_"^"_Age_"^"_OrdSetDesc_"^"_RecieverName_"^"_RecievedDate_"^"_TelNo_"^"_GroupDesc_"^"_Depart_"^"_Team_"^"_ReportDate
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod SearchGPaperByRecDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchGPaperByRecDateExecute ]
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

ClassMethod SearchGPaperByRecDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchGPaperByRecDateExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetRowData(rownum)
{
    s DataStr=$g(^DHCPETMPRECPAPERData("RowData","I",rownum))
    q DataStr
}

ClassMethod GetRowLength()
{
    s ind=""
    s ind=$o(^DHCPETMPRECPAPERData("RowData","I",ind),-1)
    q ind
}

/// w ##class(web.DHCPE.DHCPEIAdm).GetReportDate(PAADM)
ClassMethod GetReportDate(PAADM)
{
    q:""=PAADM ""
    s IADM=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
    q:IADM="" ""  // FL 暂时保护 20121128
    s PIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
    q:""=PIADM ""
    q:'$d(^DHCPEDataEx("ConfirmRecPaper","ReportDate",PIADM)) ""
    s ReportDate=$zd($p(^DHCPEDataEx("ConfirmRecPaper","ReportDate",PIADM),"^",1),3)
    q ReportDate
}

ClassMethod GetNameByRegNo(RegNo)
{
    q:RegNo="" ""
    s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
    s BaseID=$O(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
    q:BaseID="" ""
    q $P(^DHCPEPreIBI(BaseID),"^",2)
}

ClassMethod GetNoCheckDateByRegNo(RegNo)
{
    ;##class(web.DHCPE.DHCPEIAdm).GetNoCheckDateByRegNo()
    s PIADMInfo=..GetPIADMByRegNo(RegNo)
    s Flag=$P(PIADMInfo,"^",1)
    s PIADMStr=$P(PIADMInfo,"^",2)
    q:Flag'=0 PIADMStr
    q:PIADMStr="" "不存在预约纪录"
    s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADMStr,0))
    s EpisodeID=$P(^DHCPEIADM(IADM),"^",1)
    s unAppItems=##class(web.DHCPE.ResultEdit).GetUnAppedItems("",EpisodeID)
    s unAppItems=$P(unAppItems,"^",2)
    q unAppItems
}

ClassMethod OutNoCheckItemByPAADMNew(EpisodeID, SendButton As %String = "1", TableWidth As %String = 300, Cols As %String = 2, RecLabFlag As %String = "0")
{
    q:EpisodeID="" ""
    s str=""
    s unAppItems=##class(web.DHCPE.ResultEdit).GetUnAppedItems("",EpisodeID,RecLabFlag,"1")
    s unAppItemIDs=$P(unAppItems,"^",1)
    s unAppItems=$P(unAppItems,"^",2)
    s i=$L(unAppItems,",")
    i unAppItems'=""
    {
        i str="" s str="未检项目:"_unAppItems_"<br>"
        
    }
    s Flag=##class(web.DHCPE.ResultDiagnosis).StationSHadSubmit(EpisodeID)
    s Station=$P(Flag,"^",2)
    i Station'="" s str=str_"未提交站点:"_Station_"<br>"
    s RefuseItem=##class(web.DHCPE.ResultEdit).GetRefuseItems(EpisodeID)
    i RefuseItem'=";" s str=str_"谢绝检查的项目:"_RefuseItem_"<br>"
    q str
}

ClassMethod OutNoCheckItemByPAADM(EpisodeID, SendButton As %String = "1", TableWidth As %String = 300, Cols As %String = 2, RecLabFlag As %String = "0")
{
    q:EpisodeID="" ""
    s unAppItems=##class(web.DHCPE.ResultEdit).GetUnAppedItems("",EpisodeID,RecLabFlag,"1")
    s unAppItemIDs=$P(unAppItems,"^",1)
    s unAppItems=$P(unAppItems,"^",2)
    s i=$L(unAppItems,",")
    w:('$D(^User.DHCPESendAuditI("AdmIndex",EpisodeID)))&&(SendButton="1") "<input type='button' value='粘贴' onclick=SendAudit() id="_EpisodeID_">"
    w:($D(^User.DHCPESendAuditI("AdmIndex",EpisodeID)))&&(SendButton="1") "<input type='button' value='取消粘贴' onclick=CacleSendAudit() id="_EpisodeID_">"
    
    i unAppItems'=""
    {
        w "未检项目(<font color=red>点击项目,放弃检查</font>)",!
        s Rows=i/Cols
        i $L(Rows,".")>1 d
        .s Rows=i\Cols+1
        w "<table width="_TableWidth_" border=1>"
        for j=1:1:Rows
        {
            w "<TR>"
            for k=1:1:Cols d
            .w "<TD onclick=RefuseItem(this) id="_$P(unAppItemIDs,",",(j-1)*Cols+k)_">"_$P(unAppItems,",",(j-1)*Cols+k)_"</TD>"
            w "</TR>"
        }
        w "</table>"
    }
    s Flag=##class(web.DHCPE.ResultDiagnosis).StationSHadSubmit(EpisodeID)
    s Station=$P(Flag,"^",2)
    i Station'="" w "<b>未提交站点:</b>"_Station,!
    s RefuseItem=##class(web.DHCPE.ResultEdit).GetRefuseItems(EpisodeID)
    i RefuseItem'=";" w "<b>谢绝检查的项目:</b>"_RefuseItem,!
    w ""
}

ClassMethod OutNoCheckItem(RegNo, RecLabFlag As %String = "0")
{
    ;##class(web.DHCPE.DHCPEIAdm).GetNoCheckDateByRegNo()
    s PIADMInfo=..GetPIADMByRegNo(RegNo)
    s Flag=$P(PIADMInfo,"^",1)
    s PIADMStr=$P(PIADMInfo,"^",2)
    q:Flag'=0 PIADMStr
    q:PIADMStr="" "不存在预约纪录"
    s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADMStr,0))
    s EpisodeID=$P(^DHCPEIADM(IADM),"^",1)
    s obj=##class(User.PAAdm).%OpenId(EpisodeID)
    w "<b>当前姓名："_obj.PAADMPAPMIDR.PAPMIName_"</b><br>"
    
    
    d ..OutNoCheckItemByPAADM(EpisodeID, "0",700,4,RecLabFlag)
    s VIPInfo=##class(web.DHCPE.PreCommon).GetVIPLevel("PAADM",EpisodeID)
    q:$P(VIPInfo,"^",2)'[("VIP")
    //得到一般检查项目的结果
    Set myStr=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
    Set myAge=$p(myStr,"^",1)
    Set mySex=$p(myStr,"^",2)
    s OEORD=$O(^OEORD(0,"Adm",EpisodeID,0))
    s ARCIM="23441||1"
    q:OEORD="" ""
    s UseSub=""
    s stt=""
    f  s stt=$O(^OEORDi(0,"ARCIM",OEORD,ARCIM,stt)) q:(stt="")||(UseSub'="")  d
    .s Sub=0
    .f  s Sub=$O(^OEORDi(0,"ARCIM",OEORD,ARCIM,stt,Sub)) q:(Sub="")||(UseSub'="")  d
    ..s Stat=$P(^OEORD(OEORD,"I",Sub,1),"^",13)
    ..q:Stat="4"
    ..s PaiedStatus=$p(^OEORD(OEORD,"I",Sub,3),"^",5)
    ..q:PaiedStatus'="P"
    ..s UseSub=Sub
    q:UseSub="" ""
    w "<table border=1 width=700>",!
    w "<TR><TD width=175>项目</TD><TD width=175>结果</TD><TD width=175>单位</TD><TD>参考值</TD></TR>"
    s Sequence=""
    f  s Sequence=$O(^DHCPEODR(0,"Sequence",ARCIM,Sequence)) q:Sequence=""  d
    .s RowId=""
    .f  s RowId=$O(^DHCPEODR(0,"Sequence",ARCIM,Sequence,RowId)) q:RowId=""  d
    ..Set Item=$P($g(^DHCPEODR(RowId)),"^",2)
    ..Q:Item=""
    ..s ODDesc=$P($g(^DHCPEST(+Item,"OD",$P(Item,"||",2))),"^",1)
    ..Set ItemUOMDr=$P($g(^DHCPEST(+Item,"OD",$P(Item,"||",2))),"^",4)
    ..s:ItemUOMDr="" ItemUOMDr="&nbsp;"
    ..Set NormalStr=##class(web.DHCPE.ResultEdit).GetNormal(Item, mySex, myAge)
    ..s:NormalStr="" NormalStr="&nbsp;"
    ..s RLTId=$o(^DHCPERLT(0,"ADMOD",EpisodeID,OEORD_"||"_UseSub,Item,""))
    ..i RLTId="" d
    ...s Result=""
    ...s ID=OEORD_"||"_UseSub_"^"_Item
    ..e  d
    ...s Result=$P($g(^DHCPERLT(RLTId)),"^",4)
    ...s ID=RLTId
    .w "<TR>"
    .w "<TD>"_ODDesc_"</TD>"
    .
    .w "<TD><input name='result' id="_ID_" value="_Result_"></input></TD>"
    .w "<TD>"_ItemUOMDr_"</TD>"
    .w "<TD>"_NormalStr_"</TD>"
    .w "</TR>"
    w "<TR><TD colspan=4><button id='BSaveResult'>保存结果</button></TD></TR>"
    w "</table>",!
    w ""
}

ClassMethod OutNoCheckItemNew(EpisodeID, RecLabFlag As %String = "0")
{
    
    s obj=##class(User.PAAdm).%OpenId(EpisodeID)
    w "<b>当前姓名："_obj.PAADMPAPMIDR.PAPMIName_"</b><br>"
    d ..OutNoCheckItemByPAADM(EpisodeID, "0",700,4,RecLabFlag)
    s VIPInfo=##class(web.DHCPE.PreCommon).GetVIPLevel("PAADM",EpisodeID)
    q:$P(VIPInfo,"^",2)'[("VIP")
    //得到一般检查项目的结果
    Set myStr=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
    Set myAge=$p(myStr,"^",1)
    Set mySex=$p(myStr,"^",2)
    s OEORD=$O(^OEORD(0,"Adm",EpisodeID,0))
    s ARCIM="23441||1"
    q:OEORD="" ""
    s UseSub=""
    s stt=""
    f  s stt=$O(^OEORDi(0,"ARCIM",OEORD,ARCIM,stt)) q:(stt="")||(UseSub'="")  d
    .s Sub=0
    .f  s Sub=$O(^OEORDi(0,"ARCIM",OEORD,ARCIM,stt,Sub)) q:(Sub="")||(UseSub'="")  d
    ..s Stat=$P(^OEORD(OEORD,"I",Sub,1),"^",13)
    ..q:Stat="4"
    ..s PaiedStatus=$p(^OEORD(OEORD,"I",Sub,3),"^",5)
    ..q:PaiedStatus'="P"
    ..s UseSub=Sub
    q:UseSub="" ""
    w "<table border=1 width=700>",!
    w "<TR><TD width=175>项目</TD><TD width=175>结果</TD><TD width=175>单位</TD><TD>参考值</TD></TR>"
    s Sequence=""
    f  s Sequence=$O(^DHCPEODR(0,"Sequence",ARCIM,Sequence)) q:Sequence=""  d
    .s RowId=""
    .f  s RowId=$O(^DHCPEODR(0,"Sequence",ARCIM,Sequence,RowId)) q:RowId=""  d
    ..Set Item=$P($g(^DHCPEODR(RowId)),"^",2)
    ..Q:Item=""
    ..s ODDesc=$P($g(^DHCPEST(+Item,"OD",$P(Item,"||",2))),"^",1)
    ..Set ItemUOMDr=$P($g(^DHCPEST(+Item,"OD",$P(Item,"||",2))),"^",4)
    ..s:ItemUOMDr="" ItemUOMDr="&nbsp;"
    ..Set NormalStr=##class(web.DHCPE.ResultEdit).GetNormal(Item, mySex, myAge)
    ..s:NormalStr="" NormalStr="&nbsp;"
    ..s RLTId=$o(^DHCPERLT(0,"ADMOD",EpisodeID,OEORD_"||"_UseSub,Item,""))
    ..i RLTId="" d
    ...s Result=""
    ...s ID=OEORD_"||"_UseSub_"^"_Item
    ..e  d
    ...s Result=$P($g(^DHCPERLT(RLTId)),"^",4)
    ...s ID=RLTId
    .w "<TR>"
    .w "<TD>"_ODDesc_"</TD>"
    .
    .w "<TD><input name='result' id="_ID_" value="_Result_"></input></TD>"
    .w "<TD>"_ItemUOMDr_"</TD>"
    .w "<TD>"_NormalStr_"</TD>"
    .w "</TR>"
    w "<TR><TD colspan=4><button id='BSaveResult'>保存结果</button></TD></TR>"
    w "</table>",!
    w ""
}

ClassMethod SaveResult(ResultStr)
{
    s ResultStr=##class(web.DHCPE.DHCPEIAdm).ChangeResultStr(ResultStr)
    s Date=+$H
    s Time=$P(Date,",",2)
    s UserID=%session.Get("LOGON.USERID")
    s ODLength=$L(ResultStr,"%")
    s SQLCODE=0
    f i=1:1:ODLength
    {
        s OneResult=$P(ResultStr,"%",i)
        s ID=$P(OneResult,"#",1)
        s OneResult=$P(OneResult,"#",2)
        i $L(ID,"^")>1 d
        .s OEID=$P(ID,"^",1)
        .s ItemID=$P(ID,"^",2)
        .s PAADM=$P(^OEORD(+OEID),"^",1)
        .s myStr=##class(web.DHCPE.ResultEdit).GetAgeSex(PAADM)
        .s sex=$p(myStr,"^",2) 
        .s ArcIM=$P(^OEORD(+OEID,"I",$P(OEID,"||",2),1),"^",2)
        .s Normal=##class(web.DHCPE.ResultEdit).IsNormal(ItemID,OneResult,sex)
        .k PLIST
        .s PLIST(2)=PAADM
        .s PLIST(3)=ArcIM
        .s PLIST(4)=ItemID
        .s PLIST(5)=OneResult
        .s PLIST(6)=UserID
        .s PLIST(7)=Date
        .s PLIST(13)=Time
        .s PLIST(8)=Normal
        .s PLIST(11)=OEID
        .&SQL(INSERT INTO SQLUser.DHC_PE_Result VALUES PLIST())
        e  d
        .&sql(update sqluser.DHC_PE_Result set RLT_Result=:OneResult where RLT_RowID=:ID)
    }
    q SQLCODE
}

ClassMethod ChangeResultStr(ResultStr)
{
    ;w ##class(web.DHCPE.DHCPEIAdm).ChangeResultStr("57151#126.3%57152#85.5%57153#%57154#104%57155#129%57156#84")
    s ResultLength=$L(ResultStr,"%")
    b ;ResultLength
    s Job=$J
    k ^TempDHCPEChangeReult(Job)
    f i=1:1:ResultLength
    {
        s OneResult=$P(ResultStr,"%",i)
        s ID=$P(OneResult,"#",1)
        i $L(ID,"^")>1 d
        .s OrderItemID=$P(ID,"^",1)
        .s ODID=$P(ID,"^",2)
        e  d
        .s ODID=$P(^DHCPERLT(ID),"^",3)
        .b ;ODID
        continue:+ODID=0
        s Value=$P(OneResult,"#",2)
        s Type=$P(^DHCPEST(+ODID,"OD",$P(ODID,"||",2)),"^",2)
        s ODCode=$P(^DHCPEST(+ODID,"OD",$P(ODID,"||",2)),"^",11)
        i Type="C" d
        .s Express=$P(^DHCPEST(+ODID,"OD",$P(ODID,"||",2)),"^",3)
        .s ^TempDHCPEChangeReult(Job,"C",ODCode,i)=Express
        s ^TempDHCPEChangeReult(Job,"R",ODCode,i)=OneResult
    }
    ;i '$D(^TempDHCPEChangeReult(Job,"C")) q ResultStr
    s ODCode=""
    f  s ODCode=$O(^TempDHCPEChangeReult(Job,"C",ODCode)) q:ODCode=""  d
    .s i=0
    .f  s i=$O(^TempDHCPEChangeReult(Job,"C",ODCode,i)) q:i=""  d
    ..s Express=$G(^TempDHCPEChangeReult(Job,"C",ODCode,i))
    ..s Length=$L(Express,"[")
    ..f k=1:1:Length  d
    ...s OneInfo=$P(Express,"[",k)
    ...s OneCode=$P(OneInfo,"]",1)
    ...q:OneCode=""
    ...s j=$O(^TempDHCPEChangeReult(Job,"R",OneCode,0))
    ...q:j=""
    ...i j>0 d
    ....s value=$P($G(^TempDHCPEChangeReult(Job,"R",OneCode,j)),"#",2)
    ...e  d
    ....s value=""
    ...s Express=##class(web.DHCPE.Public.Setting).Replace(Express,"["_OneCode_"]",value)
    ..s value=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(Express)
    ..s value=$FN(value,"",2)
    ..s $P(^TempDHCPEChangeReult(Job,"R",ODCode,i),"#",2)=value
    ..s value=$G(^TempDHCPEChangeReult(Job,"R",ODCode,i))
    ..s $P(ResultStr,"%",i)=value
    q ResultStr
}

ClassMethod RisHasCheck(OEORIRowId)
{
    q:OEORIRowId="" 0
    ///Add by wrz  xdt
    s ARCIMDR=$P($G(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",2)
    Q:(""=ARCIMDR) 0
    s STRowId=0
    s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMDR, STRowId))
    Q:(""=STRowId) 0
    s STORDChildSub=0
    s STORDChildSub=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMDR, STRowId, STORDChildSub))
    Q:(""=STORDChildSub) 0
    s ReportFormat=$P(^DHCPEST(STRowId,"O",STORDChildSub),"^",4)
    i ReportFormat["EKG"
    {
        s rltId=$o(^DHCPERLT(0,"OEORI",OEORIRowId,0))
        q:rltId'="" 0
    }
    
    ///Add End
    Set RARRowId=$o(^DHCPACRegInfoi("OEORI",OEORIRowId,0))
    i RARRowId=""
    {
        //只要有结果就当作已经检查了
        s RLTID=$o(^DHCPERLT(0,"OEORI",OEORIRowId,0))
        q:RLTID'="" 0
        q 1
    }
    q 0  ;登记就算已检
}

/// 判断预约记录是否存在问卷
ClassMethod GetQuestionFlag(PreIADM)
{
    ;w ##class(web.DHCPE.DHCPEIAdm).GetQuestionFlag(80636)
    s VIPLevel=##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PreIADM)
    q:VIPLevel[("VIP") "1" ;VIP不填写问卷
    s Flag=0
    s ID=""
    f  s ID=$O(^User.DHCPENetPreRecordI("NPRPreIADMIndex"," "_PreIADM,ID)) q:(ID="")||(Flag=1)  d
    .s QuestID=$LG(^User.DHCPENetPreRecordD(ID),14)
    .s:QuestID'="" Flag=1
    q Flag
}

// 判断是否存在未总检记录

// w ##class(web.DHCPE.DHCPEIAdm).HadNoGenRecord(180042)

ClassMethod HadNoGenRecord(PreIADM)
{
    s Ret=""
    s AdmId=$O(^DHCPEIADM(0,"CRMADM",PreIADM,0))
    q:AdmId="" ""
    s Flag=##class(web.DHCPE.DHCPEIAdm).HaveNoPayedItem(AdmId)
    q:(Flag="1") "存在未付费的项目、不能到达"
    s ReCheck=$P(^DHCPEPreIADM(PreIADM),"^",28)
    q:ReCheck="Y" Ret
    s PIBIID=$P(^DHCPEPreIADM(PreIADM),"^",1)
    s PIADM=""
    f  s PIADM=$O(^DHCPEPreIADM(0,"PIBI",PIBIID,PIADM),-1) q:(PIADM="")||(Ret'="")  d
    .q:PIADM=PreIADM
    .b ;PIADM
    .s ReCheck=$P(^DHCPEPreIADM(PIADM),"^",28)
    .q:ReCheck="Y"
    .s Status=$P(^DHCPEPreIADM(PIADM),"^",8)
    .b ;Status
    .q:Status'="ARRIVED"
    .s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
    .q:IADM=""
    .s PAADM=$P(^DHCPEIADM(IADM),"^",1)
    .s AdmDate=$P(^DHCPEIADM(IADM),"^",5)
    .;s AdmDate=$ZD(AdmDate,3)
    .i AdmDate'=""  s AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
    .s GSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
    .i GSID="" d
    ..s Ret=AdmDate_"到达记录还未总检，其它记录不能到达"
    .e  d
    ..s GenUser=$P(^DHCPEGS(GSID,1),"^",5)
    ..i GenUser="" d
    ...s Ret=AdmDate_"到达记录还未总检，其它记录不能到达"
    .b ;GSID
    q Ret
}

ClassMethod GetIAdmIdByPaadm(paadm)
{
    q:paadm="" ""
    s IADMRowId=$o(^DHCPEIADM(0,"PAADM",paadm,0))
    q IADMRowId
}

ClassMethod OutSendReportToHTML(ContrlWidth As %String = "") As %String
{
    s:(""=ContrlWidth) ContrlWidth="155"
    //下拉列表
    ;w "<select name='SendMethod' id='SendMethod' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>",!
    w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("SendMethod","")
    w "<option value='ZQ'>自取</option>",!
    w "<option value='TQ'>统取</option>",!
    w "<option value='KD'>快递</option>",!
    w "<option value='DZB'>电子版</option>",!
    w "</select>",!
    Quit $$$OK
}

ClassMethod GetTeamIADM(TeamID, Flag As %Library.String = "")
{
    s PreIADMID=0,ret=""
    f  s PreIADMID=$O(^DHCPEPreIADM(0,"PGTeam",TeamID,PreIADMID)) q:(PreIADMID="")  d
    .s Status=$P(^DHCPEPreIADM(PreIADMID),"^",8)
    .q:(Status'="REGISTERED")
    .s IADM=$o(^DHCPEIADM(0,"CRMADM",PreIADMID,0))
    .q:(IADM="")
    .s PAADM=$p(^DHCPEIADM(IADM),"^",1)
    .s PrintFlag=$G(^DHCPEPatItemPrintFlag("PatItem","PrintFlag",PAADM))
    .q:(Flag=1)&&(PrintFlag="Y")
    .s:(ret'="") ret=ret_"^"_PAADM
    .s:(ret="") ret=PAADM
    
    q ret
}

ClassMethod GetPIADMStatus(PIADM, AdmType)
{
    q:AdmType'="PERSON" ""
    q:PIADM="" ""
    q $P($G(^DHCPEPreIADM(+PIADM)),"^",8)
}

/// Debug: d ##class(%ResultSet).RunQuery("web.DHCPE.DHCPEIAdm", "CashierForHISUI","","","2016-01-01","2018-01-01")
Query CashierForHISUI(PAPMINo As %String = "", IADMName As %String = "", AuditDateBegin As %String = "", AuditDateEnd As %String = "", LocID As %String = "") As %Query(ROWSPEC = "PreADM,TRowId:%String,TPAADM:%String,TName:%String,TRegDate:%String,TAsCharged:%String,TStatus:%String,TAccountAmount:%String,TDiscountedAmount:%String,TFactAmount:%String,TDischargedAmount:%String,TPayAmount:%String,TPapmiNo:%String,TGAdm:%String,TGAdmDesc:%String,TTeam:%String,TTeamDesc:%String,TRemark:%String,TNewHPNo:%String,TConfirmStatus:%String,TAdmType:%String,TPGBIID")
{
}

ClassMethod CashierForHISUIExecute(ByRef qHandle As %Binary, PAPMINo As %String = "", IADMName As %String = "", AuditDateBegin As %String = "", AuditDateEnd As %String = "", LocID As %String = "") As %Status
{
    
    Set repid=$I(^CacheTemp)
    s ind=1
    s ^tempddhcpe("CashierForHISUI")=$lb(PAPMINo,IADMName,AuditDateBegin, AuditDateEnd,LocID)
    
    i (PAPMINo="")&&(IADMName="")&&(AuditDateBegin="")&&(AuditDateEnd=""){
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    
    i AuditDateBegin'=""  s AuditDateBegin=##class(websys.Conversions).DateHtmlToLogical(AuditDateBegin)
    i AuditDateEnd'="" s AuditDateEnd=##class(websys.Conversions).DateHtmlToLogical(AuditDateEnd)
    
    i AuditDateBegin=""  s AuditDateBegin=1
    i AuditDateEnd="" s AuditDateEnd=+$H
    
    s IsFeeLocFlag=$g(^DHCPESetting("DHCPE","IsFeeLocFlag",LocID))
    s PreID="",PreADM=""
    i PAPMINo'="" d
    .//优先按照体检号进行查询，查不到数据按照登记号查询
    .s PreID=##class(web.DHCPE.HISUICommon).GetPreIDByHPNo(PAPMINo)
    .i PreID'=""  s IBI=$P($g(^DHCPEPreIADM(PreID)),"^",1)
    .i PreID=""   s IBI=$O(^DHCPEPreIBI(0,"PAPMINo",PAPMINo,0))
    .q:IBI=""
    .s PreIADM=0
    .f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",IBI,PreIADM)) q:PreIADM=""  d
    ..q:((PreID'="")&&(PreID'=PreIADM)) //体检号
    ..s iAdmId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
    ..S PreADM=PreIADM
    ..q:iAdmId=""
    ..d DoOneInfo
    e  i IADMName'=""  d
    .S IADMNameUC=$$ALPHAUP^SSUTIL4(IADMName)
    .s desc=$o(^DHCPEPreIBI(0,"Name",IADMNameUC),-1)
    .f  s desc=$o(^DHCPEPreIBI(0,"Name",desc)) q:(desc="")||(desc'[IADMNameUC)  d
    ..s IBI=0
    ..f  s IBI=$o(^DHCPEPreIBI(0,"Name",desc,IBI)) q:IBI=""  d
    ...s PreIADM=0
    ...f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",IBI,PreIADM)) q:PreIADM=""  d
    ....S PreADM=PreIADM
    ....s iAdmId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
    ....q:iAdmId=""
    ....d DoOneInfo
    e  d
    .s Date=AuditDateBegin-1
    .
    .f  s Date=$O(^DHCPEIADM(0,"AdmDateTime",Date)) q:(Date="")||(Date>AuditDateEnd)  d
    ..s Time=""
    ..f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:(Time="")  d
    ...s iAdmId=0
    ...f  s iAdmId=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time,iAdmId)) q:(iAdmId="")  d
    ....s PreIADM=$p($g(^DHCPEIADM(iAdmId)),"^",4)
    ....S PreADM=PreIADM
    ....d DoOneInfo
    
 
    
    //团体
    s (PreADM,iAdmId,ADM,Name,RegDate,AsCharged,Status,AccountAmount,DisCountedAmount,FactAmount,DischargedAmount,PayAmount,RegNo,GADM,GADMDesc,GTeam,GTeamDesc,TRemark,NewHPNo,ConfirmStatus,AdmType)=""
    s GBIDesc=##class(web.DHCPE.DHCPECommon).UnEscape(IADMName)
    s STatusList="ARRIVED"                  //允许显示状态列表
    s id=""
    f  s id=$o(^DHCPEGADM(id),-1) q:(id="")||(id=0)  d
    .q:..HadUsedAudit("G","",id)
    .s iAdmId=id
    .;s hospCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
    .s hospCode=$G(^DHCPESetting("DHCPE","HospitalCode",LocID))
    .s CRMADM=$P($g(^DHCPEGADM(id)),"^",2)
    .S PreADM=CRMADM
    .q:(0=+$G(^DHCPEDataEx("DHCPECharge","Group",id)))&&($G(^DHCPESetting("DHCPE","AllowCharge",LocID))=1)
    .s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("GADM",id,LocID,IsFeeLocFlag)
    .q:LocFlag=1
    .s CurData=$g(^DHCPEGADM(id))           //团体客户ADM表 DHC_PE_GADM
    .
    .//GADM_GBI_DR
    .s GBIDR=$p(CurData,"^",1)
    .
    .//团体客户基本信息登记表DHC_PE_GBaseInfo
    .i GBIDR'="" s GDesc=$p($g(^DHCPEGBI(GBIDR)),"^",2)     //团体名称
    .q:((""'=IADMName)&('(GDesc[IADMName))) 
    .s Name=GDesc
    .s GAdmDate=$p(CurData,"^",4)               //体检日期
    .q:(""'=AuditDateBegin)&(GAdmDate<AuditDateBegin)&(GADM="")
    .q:(""'=AuditDateEnd)&(GAdmDate>AuditDateEnd)&(GADM="")
    .i (""'=GAdmDate) d
    ..s RegDate=##class(websys.Conversions).DateLogicalToHtml(GAdmDate)
    .//GADM_Status
    .s GStatus=$p(CurData,"^",6)
    .;q:GStatus'=STatusList
    .q:(GStatus'="ARRIVED")&&(GStatus'="REGISTERED")
    .s Status=##class(web.DHCPE.PreAudit).GetADMStatus(GStatus)
    .//GADM_AccountAmount
    .s AccountAmount=""
    .//GADM_DiscountedAmo
    .s DiscountedAmount=""
    .//GADM_FactAmount
    .s FactAmount=""
    .
    .//GADM_AuditDate
    .s AuditDate=$p(CurData,"^",13)     //审核[到达]日期
    .i (""'=AuditDate) d
    ..s AuditDate=##class(websys.Conversions).DateLogicalToHtml(AuditDate)
    .
    .s DischargedAmount=$p(CurData,"^",16)
    .i DischargedAmount="" s DischargedAmount=0
    .s PayAmount=FactAmount-DischargedAmount
    .s CRMADM=$p(CurData,"^",2)
    .s TGADM=$p(CurData,"^",3)
    .s PGBIID=$p($G(^DHCPEPreGADM(CRMADM)),"^",1)
    .s TGADM=$p($G(^DHCPEPreGBI(PGBIID)),"^",13)
    .q:(PAPMINo'="")&&(PAPMINo'=TGADM)
    .s RegNo=TGADM
    .s TAsCharged=$p(CurData,"^",7)
    .i TAsCharged="Y" s AsCharged="是"
    .i TAsCharged="N" s AsCharged="否"
    .s TDisChargedMode=$p(CurData,"^",16)
    .s TDisChargedMode=##class(web.DHCPE.PreAudit).GetDisChargedMode(TDisChargedMode)
    .s TGReportSend=$p(CurData,"^",14)
    .s TGReportSend=##class(web.DHCPE.PreAudit).GetGReportSend(TGReportSend)
    .
    .S PGTSub="",ConfirmStatus="否"
    .F  S PGTSub=$O(^DHCPEPreGADM(CRMADM,"Team",PGTSub)) Q:(PGTSub="")||(ConfirmStatus="是")  D
    ..s ConfirmStatus=##class(web.DHCPE.PreItemList).GetItemName(CRMADM_"||"_PGTSub,"Team")
    ..i ConfirmStatus["确认加项"  S ConfirmStatus="是"
    ..e  S ConfirmStatus="否"
    .s AdmType="G"
    .s NewHPNo="团体"
    .d ICashierBuild
    
    
    
    
    
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
DoOneInfo
    q:##class(web.DHCPE.DHCPEGAdm).HadUsedAudit("I","",iAdmId)
    //s hospCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
    s hospCode=$G(^DHCPESetting("DHCPE","HospitalCode",LocID))
    s ConfirmStatus=##class(web.DHCPE.PreItemList).GetItemName(PreIADM,"PERSON")
    i ConfirmStatus["确认加项"  S ConfirmStatus="是"
    e  S ConfirmStatus="否"
    
    d ICashierSetData
    q:hasData=0
    d ICashierBuild
    q
ICashierBuild
    /***翻译 start***/
    s Status=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpecashier.hisui.csp",Status)
    s ConfirmStatus=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpecashier.hisui.csp",ConfirmStatus)
     s AsCharged=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpecashier.hisui.csp",AsCharged)
    /***翻译 end***/
    set Data=$lb(PreADM,$g(iAdmId),ADM,Name,RegDate,AsCharged,Status,AccountAmount,DisCountedAmount,FactAmount,DischargedAmount,PayAmount,RegNo,GADM,GADMDesc,GTeam,GTeamDesc,TRemark,NewHPNo,ConfirmStatus,AdmType,PGBIID)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
    
ICashierSetData
    s PGBIID=""
    s AdmType="I"
    s hasData=0
    s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",iAdmId,LocID,IsFeeLocFlag)
    q:LocFlag=1 
    s CurData=$g(^DHCPEIADM(iAdmId))
    s GADMDR=$p(CurData,"^",2)              //对应团体的ADM
    
    s ADM=$p(CurData,"^",1)
    q:(""=ADM)
    s PapmiNo=$p($g(^PAADM(ADM)),"^",1) //取患者信息
    q:PapmiNo=""
    s RegNo=$p(^PAPER($p(^PAADM(ADM),"^",1),"PAT",1),"^",1)
    //q:(RegNo'[PAPMINo)
    q:(PreID="")&(PAPMINo'="")&&(PAPMINo'=RegNo)
    s Name=$p($g(^PAPER(PapmiNo,"ALL")),"^",1)  //姓名
    q:(IADMName'="")&&('(Name[IADMName))
    s GADM=$p(CurData,"^",2)                
    s GTeam=$p(CurData,"^",3)               
    s RegDate=$p(CurData,"^",5)         //登记日期 
    i PAPMINo=""
    {
        q:(""'=AuditDateBegin)&(RegDate<AuditDateBegin) 
        q:(""'=AuditDateEnd)&(RegDate>AuditDateEnd)
    }
    i (""'=RegDate) d
    .s RegDate=##class(websys.Conversions).DateLogicalToHtml(RegDate)
    s AsCharged=$p(CurData,"^",7)           //视同收费 
    i (AsCharged="Y") s AsCharged="是"
    else  s AsCharged="否"
    s Status=$p(CurData,"^",8)              //状态 PREREG 预挂号REGISTERED　登记(在HIS中)CHECKED 审批CHARGED　收费COMPLETED 完成(报告完成)
    q:(Status'="ARRIVED")&&(Status'="REGISTERED")
    s:(Status="ARRIVED") Status="到达"
    s:(Status="REGISTERED") Status="登记"
    s AddOrdItem=$p(CurData,"^",9)
    s AddOrdItemLimit=$p(CurData,"^",10)
    s AddOrdItemAmount=$p(CurData,"^",11)
    s AddPhcItem=$p(CurData,"^",12)
    s AddPhcItemLimit=$p(CurData,"^",13)
    s AddPhcItemAmount=$p(CurData,"^",14)
    s IReportSend=$p(CurData,"^",15)
    s DisChargedMode=$p(CurData,"^",16)
    s Diet=$p(CurData,"^",17)
    s AccountAmount=""      //应收金额
    s DiscountedAmount=""   //打折后金额 
    s FactAmount=""     //最终金额
    s GTeamDesc="" 
    s GADMDesc=##Class(web.DHCPE.DHCPEGAdm).GetGAdmDesc(GADM)
    i GADM'="" s GTeamDesc=##Class(web.DHCPE.DHCPEGAdm).GetGTeamDesc(GTeam)
    s TRemark=""
    i GADM'=""  s TRemark=$p($g(^DHCPEGADM(GADM)),"^",17)
    s hasData=1 
    s PIADMRowId=$p(CurData,"^",4)
    s NewHPNo=$p($g(^DHCPEPreIADM(PIADMRowId)),"^",27) 
    
    q
}

ClassMethod CashierForHISUIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CashierForHISUIExecute ]
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

ClassMethod CashierForHISUIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CashierForHISUIExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// ##class(web.DHCPE.DHCPEGAdm).HadUsedAudit(Type, CRMADM, GIADM)
/// Type "G":团体,"I":个人  CRMADM  预约ID  GIADM  到达后ID
/// 判断是否有可用来收费的审核纪录  1 没有  0有
ClassMethod HadUsedAudit(Type, CRMADM, GIADM)
{
    s Flag=1
    s ArgType=""
    s ChargedFlag="N",TeamFlag=""
    s (PreADM,ADM)=""
    s id=0
    i Type="G"
    {
        i CRMADM'=""
        {
            s PreADM=CRMADM
            s ADM=$o(^DHCPEGADM(0,"CRMADM",CRMADM,0))
        }
        elseif GIADM'=""
        {
            s ADM=GIADM
            s PreADM=$p($G(^DHCPEGADM(GIADM)),"^",2)
         

        }
    }
    i Type="I"
    {
        i CRMADM'=""
        {
            s PreADM=CRMADM
            s ADM=$o(^DHCPEIADM(0,"CRMADM",CRMADM,0))
        }
        elseif GIADM'=""
        {
            s ADM=GIADM
            s PreADM=$p($G(^DHCPEIADM(GIADM)),"^",4)
            s TeamFlag=$p($G(^DHCPEIADM(GIADM)),"^",2)
            s ChargedFlag=$p($G(^DHCPEIADM(GIADM)),"^",7)
        }
    }
    i CRMADM'="" s ArgType="CRM"
    i ADM'=""
    {
        f  s id=$o(^DHCPEPreA(0,"GIADM",Type,ADM,id)) q:(id="")||(Flag=0)  d
        .s CRM=$p($G(^DHCPEPreA(id)),"^",2)
        .q:((ArgType="CRM")&&(CRM'=""))
        .s Status=$p($G(^DHCPEPreA(id)),"^",14)
        .q:Status="CHARGED"
        .s Amount=$p($G(^DHCPEPreA(id)),"^",9)
        .i Amount="" s Amount=0
        .;q:Amount=0
        .s Flag=0
        i ((ChargedFlag="N")&&(TeamFlag'="")) s Flag=0
    }
    s id=0
    i PreADM'=""
    {
        f  s id=$o(^DHCPEPreA(0,"CRMADM",Type,PreADM,id)) q:(id="")||(Flag=0)  d
        .s CRM=$p($G(^DHCPEPreA(id)),"^",3)
        .q:((ArgType="")&&(CRM'=""))
        .s Status=$p($G(^DHCPEPreA(id)),"^",14)
        .q:Status="CHARGED"
        .s Amount=$p($G(^DHCPEPreA(id)),"^",9)
        .i Amount="" s Amount=0
        .;q:Amount=0
        .s Flag=0
    }
    q Flag
}

/*
/// function:判断团体是否存在预约状态人员
/// w ##class(web.DHCPE.DHCPEIAdm).IsExsistPre(14)
ClassMethod IsExsistPre(GADM, Type)
{
	q:GADM="" "" 
	q:Type'="G" 0
    s GNum=1
    s flag=0
    while(GNum<=$l(GNum,",")){
	    s GADMi=$p(GADM,",",GNum)
	    s PreGADM=$P($g(^DHCPEGADM(GADMi)),"^",2)
	    continue:PreGADM=""
	    S PIADM=""
    	f  S PIADM=$o(^DHCPEPreIADM(0,"PGADM",PreGADM,PIADM)) q:(PIADM="")||(flag=1)  d
   		.s Status=$p($g(^DHCPEPreIADM(PIADM)),"^",8)
    	.i Status="PREREG"  s flag=1 
        q:flag=1 
    	s GNum=GNum+1
	    
    }
   
    q flag
}

/// function:给团体中预约状态的人员自动登记
/// w ##class(web.DHCPE.DHCPEIAdm).UpdateGIADMInfo(14)
ClassMethod UpdateGIADMInfo(GADM, Type)
{
	q:(Type'="G")||(GADM="") ""
	s GADMNum=1
    while(GADMNum<=$l(GADMNum,",")){
	    s GADMi=$p(GADM,",",GADMNum)
	    s PreGADM=$P($g(^DHCPEGADM(GADMi)),"^",2)
	    continue:PreGADM=""
	    S PIADM=""
    	f  S PIADM=$o(^DHCPEPreIADM(0,"PGADM",PreGADM,PIADM)) q:(PIADM="")  d
    	.s Status=$p($g(^DHCPEPreIADM(PIADM)),"^",8)
    	.q:Status'="PREREG" 
    	.s ret=##class(web.DHCPE.DHCPEIAdm).UpdateIADMInfo(PIADM,"2") 
    	 s GNum=GNum+1
    }
   
    q ret
}
*/
/// Creator：    xy 
/// CreatDate：  20220630
/// Description: 判断是否存在预约的人员
/// Input:       preAuditIds:待结算的审核记录
/// Return：     0/1：无/有
/// debug: d ##class(web.DHCPE.DHCPEIAdm).IsExsistPreNew()
ClassMethod IsExsistPreNew(preAuditIds)
{
	s ^tempddhcpe("IsExsistPreNew")=preAuditIds
	s flag="0"
	q:preAuditIds="" flag
	
	i preAuditIds'["," d	
	.s preAuditId=preAuditIds 
	.q:preAuditId="" 
	.s preAdmId=0
	.f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId)) q:(preAdmId="")||(flag=1)  d
	..s Status=$p($g(^DHCPEPreIADM(preAdmId)),"^",8)
   	..i ((Status="PREREG")&&($D(^DHCPEPreIADM(preAdmId,"ORDITEM"))))  s flag=1
   	e  d
   	.s Len=$L(preAuditIds,",")
   	.f i=1:1:Len d
   	..s preAuditId=$P(preAuditIds,",",i)
   	..q:flag="1"
   	..s preAdmId=0
	..f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId)) q:(preAdmId="")||(flag=1)  d
	...s Status=$p($g(^DHCPEPreIADM(preAdmId)),"^",8)
	...;q:(Status="ARRIVED")||(Status="REGISTERED")
	...q:Status'="PREREG"
	...s flag=1
   	...;i ((Status="PREREG")&&($D(^DHCPEPreIADM(preAdmId,"ORDITEM"))))  s flag=1
	
	q flag
}

/// Creator：    xy 
/// CreatDate：  20220630
/// Description: 给团体中预约状态人员自动登记
/// Input:       preAuditIds:待结算的审核记录
/// Return：    
/// debug:  w ##class(web.DHCPE.DHCPEIAdm).UpdateGIADMInfo(14)
ClassMethod UpdateGIADMInfo(preAuditIds)
{
   	s Len=$L(preAuditIds,",")
   	f i=1:1:Len d
   	.s preAuditId=$P(preAuditIds,",",i)
   	.s preAdmId=0
	.f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId)) q:(preAdmId="")  d
	..s Status=$p($g(^DHCPEPreIADM(preAdmId)),"^",8)
	..q:(Status="ARRIVED")||(Status="REGISTERED")
	..i Status="PREREG" d
	...s ret=##class(web.DHCPE.DHCPEIAdm).UpdateIADMInfo(preAdmId,"2")
    q ret
}

/// Creator：    xueying
/// CreatDate：  20220610
/// Description: 根据就诊ID判断客户是否存在未收费的项目
/// Input:       EpisodeID(就诊ID)
/// Return：     0:存在,1:不存在
/// Dubug:w ##class(web.DHCPE.DHCPEIAdm).GetOEItemNoPay("")
ClassMethod GetOEItemNoPay(EpisodeID)
{
	
	s Flag="1"
	s LocID=$p($g(^PAADM(EpisodeID)),"^",4)
	//s OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other",LocID))
	
	s PEIAdmId=$o(^DHCPEIADM(0,"PAADM",EpisodeID,""))
	q:PEIAdmId="" ""
   
    s OEOrder=$O(^OEORD(0,"Adm",EpisodeID,0))
	q:OEOrder="" ""

	s OEOrdItemSub=0
	f  s OEOrdItemSub=$O(^OEORD(OEOrder,"I",OEOrdItemSub))  q:(OEOrdItemSub="")||(Flag="0")  d
	.s ORIStat=$p($g(^OEORD(OEOrder,"I",OEOrdItemSub,1)),"^",13)
	.q:(ORIStat="4")||(ORIStat="6")
	.s PaiedStatus=$p($g(^OEORD(OEOrder,"I",OEOrdItemSub,3)),"^",5)
	.i PaiedStatus="TB" s Flag=0
	
	q Flag
}

/// Creator：    xueying
/// CreatDate：  20220613
/// Description: 根据就诊ID获取收表的条件
/// Input:       EpisodeID(就诊ID)
/// Return：     0:可以收表,1:不是到达状态.2:已经收表,3:有未检项目
/// Dubug:w ##class(web.DHCPE.DHCPEIAdm).GetRecpaperFlag(1171)
ClassMethod GetRecpaperFlag(EpisodeID)
{
	s ^tempdhcpe("GetRecpaperFlag")=EpisodeID
	s RecFlag=0
	s IADMRowId=$o(^DHCPEIADM(0,"PAADM",EpisodeID,0))
	s PIADM=$p($g(^DHCPEIADM(IADMRowId)),"^",4)
	s PIADMStutas=$P($g(^DHCPEPreIADM(PIADM)),"^", 8)
	i "ARRIVED"'=PIADMStutas s RecFlag=1
	q:RecFlag=1 RecFlag
	i $d(^DHCPEDataEx("ConfirmRecPaper",PIADM)) s RecFlag=2
	q:RecFlag=2 RecFlag
	s DelayFlag="Y"
	s AppFlag=##class(web.DHCPE.ResultEdit).ItemHadApp("",EpisodeID,DelayFlag)
	i +AppFlag=2 s RecFlag=3
	q:RecFlag=3 RecFlag
	q RecFlag
}

/// Creator：    xueying
/// CreatDate：  20220610
/// Description: 置已检状态/撤销已检状态
/// Input:       PAADM(就诊ID)，OrdIDS(医嘱串，多个医嘱之间使用^分割),DoType(0:置已检，1:撤销已检)
/// Return：     0
/// Dubug:d ##class(web.DHCPE.DHCPEIAdm).SetSubStatus(pAADM,医嘱id) 
ClassMethod SetSubStatus(PAADM, OrdIDS As %String = "", DoType As %String = "0", UserID)
{
	
	s LocID=$p($g(^PAADM(PAADM)),"^",4)
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,""))
	q:IADM="" ""
	s PIADM=$P($g(^DHCPEIADM(IADM)),"^",4)
	s Time=$P($H,",",2)

	if (OrdIDS'=""){
		s OrdLength=$L(OrdIDS,"^")
		f i=1:1:OrdLength d
		.s OneOrdID=$P(OrdIDS,"^",i)
		.s LabSpecNo=$p($g(^OEORD(+OneOrdID,"I",$P(OneOrdID,"||",2),3)),"^",20)
		.//非检验类
		.i LabSpecNo="" d
		..i DoType=0 d
		...s ^DHCPEDataEx("DHCPEPreIOrdItem","SubStatus",OneOrdID)=UserID_"^"_$H
		...d ##class(web.DHCPE.ItemDetailRecord).Insert(OneOrdID,"A","1",+$H)
		...d ##class(web.DHCPE.AdmRecordManager).Insert(PAADM,"A","SubStatus",UserID,OneOrdID) //已检-插入日志
		..e  d
		...k ^DHCPEDataEx("DHCPEPreIOrdItem","SubStatus",OneOrdID)
		...d ##class(web.DHCPE.ItemDetailRecord).Insert(OneOrdID,"D","1",+$H)
		...d ##class(web.DHCPE.AdmRecordManager).Insert(PAADM,"A","CancelSubStatus",UserID,OneOrdID) //撤销已检-插入日志
		.//检验类
		.e  d
		..s OEpisNoid=0
		..f  s OEpisNoid=$O(^OEORD(0,"EpisNo",LabSpecNo,+OneOrdID,OEpisNoid)) Q:(""=OEpisNoid)  d
		...s Stat=$p($g(^OEORD(+OneOrdID,"I",OEpisNoid,1)),"^",13)
		...q:Stat="4"
		...s NewOrdItemID=+OneOrdID_"||"_OEpisNoid
		...i DoType=0 d
		....s ^DHCPEDataEx("DHCPEPreIOrdItem","SubStatus",NewOrdItemID)=UserID_"^"_$H
		....d ##class(web.DHCPE.ItemDetailRecord).Insert(NewOrdItemID,"A","1",+$H)
		....d ##class(web.DHCPE.AdmRecordManager).Insert(PAADM,"A","SubStatus",UserID,NewOrdItemID) //已检-插入日志
		...e  d
		....k ^DHCPEDataEx("DHCPEPreIOrdItem","SubStatus",NewOrdItemID)
		....d ##class(web.DHCPE.ItemDetailRecord).Insert(NewOrdItemID,"D","1",+$H)
		....d ##class(web.DHCPE.AdmRecordManager).Insert(PAADM,"A","CancelSubStatus",UserID,NewOrdItemID) //已检-插入日志
	}
	q 0
}

/// Creator：    xueying
/// CreatDate：  20220613
/// Description: 根据预约id获取报告约期、领取方法、备注
/// Input:       PIADM(预约ID)
/// Return：     备注^报告约期^发送方式
/// Dubug:w ##class(web.DHCPE.DHCPEIAdm).GetSendReportCode("60393")
ClassMethod GetSendReportCode(PIADM)
{
	q:PIADM="" ""
    s SendCode="DZB",ReMark="",ReportDate=+$H
    s ReportDate=ReportDate+10
    i $D(^DHCPEDataEx("ConfirmRecPaper","ReportDate",PIADM)) d
    .s ReportDate=$G(^DHCPEDataEx("ConfirmRecPaper","ReportDate",PIADM))
    i $D(^DHCPEDataEx("ConfirmRecPaper","SendReport",PIADM)) d
    .s SendCode=$G(^DHCPEDataEx("ConfirmRecPaper","SendReport",PIADM))
    i $D(^DHCPEDataEx("ConfirmRecPaper","Remark",PIADM)) d
    .s ReMark=$G(^DHCPEDataEx("ConfirmRecPaper","Remark",PIADM))
    i ReportDate'="" s ReportDate=$ZD(ReportDate,3)
    q ReMark_"^"_ReportDate_"^"_SendCode
}

}
