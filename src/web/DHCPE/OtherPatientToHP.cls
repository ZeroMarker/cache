/// 其它类型的患者做体检
Class web.DHCPE.OtherPatientToHP Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description: 判断住院病人是否已设置为体检病人
/// Input:       PAADM（就诊ID）
/// debug: w ##class(web.DHCPE.OtherPatientToHP).IsOtherPatientToHP()
ClassMethod IsOtherPatientToHP(PAADM)
{
    s Flag=0
    s id=0
    f  s id=$o(^User.DHCPEOtherPatientToHPI("OTHPAADMDRIndex",PAADM,id)) q:id=""  d
    .s obj=##class(User.DHCPEOtherPatientToHP).%OpenId(id)
    .s status=obj.OTHStatus
    .q:status=0
    .s Flag=1
    q Flag
    Q:'$D(^User.DHCPEOtherPatientToHPI("OTHPAADMDRIndex",PAADM)) "-1"
    Q:$D(^User.DHCPEOtherPatientToHPI("OTHPAADMDRIndex",PAADM)) "1"
}

/// Description: 设置就诊记录为体检标识
/// Input:       PAADM（就诊ID）,UserID（操作人员ID）
/// debug： w ##class(web.DHCPE.OtherPatientToHP).Save("33","1")
ClassMethod Save(PAADM, UserID)
{
    q:PAADM="" ""
    s OldID=..GetOldID(PAADM)
    q:OldID'="" "2^"
    s obj=##class(User.DHCPEOtherPatientToHP).%New()
    d obj.OTHCreateUserDRSetObjectId(UserID)
    d obj.OTHPAADMDRSetObjectId(PAADM)
    s obj.OTHCreateDate=+$H
    s obj.OTHCreateTime=$P($H,",",2)
    s obj.OTHStatus="1"
    s sc=obj.%Save()
    d obj.%Close()
    If ($System.Status.IsError(sc)) 
    {
        q "-1^"_$System.Status.GetErrorText(sc)
    }else{
        q "0^"
    }
}

/// Description:  删除已设置记录，实际是更新删除信息
/// Input:        PAADM（就诊ID）,UserID（操作人员ID）
/// debug:  w ##class(web.DHCPE.OtherPatientToHP).Delete()
ClassMethod Delete(PAADM, UserID)
{
    q ..UpdateStatus(PAADM,"0",UserID)
}

/// Description:  更新住院病人的状态
/// Input:        PAADM（就诊ID）,Status（状态）,UserID（操作人员ID）
/// debug: d ##class(web.DHCPE.OtherPatientToHP).UpdateStatus()
ClassMethod UpdateStatus(PAADM, Status, UserID)
{
    q:PAADM="" ""
    s OldID=..GetOldID(PAADM)
    q:OldID="" ""
    s:(UserID="")&&($D(%session)) UserID=%session.Get("LOGON.USERID")
    s obj=##class(User.DHCPEOtherPatientToHP).%OpenId(OldID)
    i Status="0" d  ;删除
    .d obj.OTHDeleteUserDRSetObjectId(UserID)
    .s obj.OTHDeleteDate=+$H
    .s obj.OTHDeleteTime=$P($H,",",2)
    i Status="2" d  ;审核
    .d obj.OTHAuditUserDRSetObjectId(UserID)
    .s obj.OTHAuditDate=+$H
    .s obj.OTHAuditTime=$P($H,",",2)
    i Status="1" d  ;取消审核
    .d obj.OTHCancelAuditUserDRSetObjectId(UserID)
    .s obj.OTHCancelAuditDate=+$H
    .s obj.OTHCancelAuditTime=$P($H,",",2)
    i Status="3" d  ;打印
    .d obj.OTHPrintUserDRSetObjectId(UserID)
    .s obj.OTHPrintDate=+$H
    .s obj.OTHPrintTime=$P($H,",",2)
    
    
    s obj.OTHStatus=Status
    
    
    s sc=obj.%Save()
    d obj.%Close()
    If ($System.Status.IsError(sc)) 
    {
        q "-1^"_$System.Status.GetErrorText(sc)
    }else{
        q PAADM
    }
}

/// Description:  判断就诊记录是否已经设置体检标记
/// Input:        PAADM（就诊ID）
/// debug: w ##class(web.DHCPE.OtherPatientToHP).GetOldID("33")
ClassMethod GetOldID(PAADM)
{
    s ID=""
    s Ret=""
    f  s ID=$O(^User.DHCPEOtherPatientToHPI("OTHPAADMDRIndex",PAADM,ID)) q:(ID="")||(Ret'="")  d
    .s DeleteUser=$LG(^User.DHCPEOtherPatientToHPD(ID),6)
    .q:DeleteUser'=""
    .s Ret=ID
    q Ret
}

/// Description:  查询住院体检患者
/// debug: d ##class(%ResultSet).RunQuery("web.DHCPE.OtherPatientToHP", "FindPatientList","2015-01-01","2015-05-15")
Query FindPatientList(StartDate As %Library.String = "", EndDate As %Library.String = "", EpisodeID As %String = "", ShowDelete As %String = "", hospid As %Library.String = "", locid As %Library.String = "") As %Query(ROWSPEC = "TEpisodeID:%String,TRegNo:%String,TName:%String,TSex:%String,TAge:%String,TIDCard:%String,TInDate:%String,THPDate:%String,THStatusDesc:%String,TIDCardDesc") [ SqlProc ]
{
}

ClassMethod FindPatientListExecute(ByRef qHandle As %Binary, StartDate As %Library.String = "", EndDate As %Library.String = "", EpisodeID As %String = "", ShowDelete As %String = "", hospid As %Library.String = "", locid As %Library.String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    
    s ^temp("DHCPE","FindPatientList")=$lb(StartDate,EndDate,EpisodeID,ShowDelete,hospid,locid)
    
    i hospid="" d
    .s:$d(%session) hospid=%session.Get("LOGON.HOSPID")
    i locid="" d
    .s:$d(%session) locid=%session.Get("LOGON.CTLOCID")
    
    /***多语言 stsart***/
    if $d(%session) {
        set langId=%session.Get("LOGON.LANGID")
    }
    else
    { s langId=""}
     /***多语言 end***/
    
    s:StartDate="" StartDate=1
    s:EndDate="" EndDate=+$H
    
    s:StartDate'="" StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    s Date=StartDate-1
    f  s Date=$O(^User.DHCPEOtherPatientToHPI("OTHCreateDateIndex",Date)) q:(Date="")||(Date>EndDate)  d
    .s ID=0
    .f  s ID=$O(^User.DHCPEOtherPatientToHPI("OTHCreateDateIndex",Date,ID)) q:ID=""  d
    ..s DeleteUser=$LG(^User.DHCPEOtherPatientToHPD(ID),6)
    ..q:DeleteUser'=""
    ..s (TEpisodeID,TName,TSex,TAge,TIDCard,TInDate,THPDate)=""
    ..s TEpisodeID=$LG(^User.DHCPEOtherPatientToHPD(ID),2)
    ..s THStatus=$LG(^User.DHCPEOtherPatientToHPD(ID),12)
    ..s THStatusDesc=""
    ..//多语言 stsart
    ..i THStatus=0  s THStatusDesc=##class(websys.Translation).Get("dhcpeinpatientlist.hisui.csp","已删除",langId) 
    ..i THStatus=1  s THStatusDesc=##class(websys.Translation).Get("dhcpeinpatientlist.hisui.csp","未复检",langId) 
    ..i THStatus=2  s THStatusDesc=##class(websys.Translation).Get("dhcpeinpatientlist.hisui.csp","已复检",langId) 
    ..i THStatus=3  s THStatusDesc=##class(websys.Translation).Get("dhcpeinpatientlist.hisui.csp","已打印",langId)
    ..i THStatus=4  s THStatusDesc=##class(websys.Translation).Get("dhcpeinpatientlist.hisui.csp","已取",langId)
    ..//多语言 end
    ..s obj=##class(User.PAAdm).%OpenId(TEpisodeID)
    ..s TRegNo=obj.PAADMPAPMIDR.PAPMIIPNo
    ..s TName=obj.PAADMPAPMIDR.PAPMIName
    ..s TSex=obj.PAADMPAPMIDR.PAPMISexDR.CTSEXDesc
    ..s TSex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",TSex,langId) //多语言
    ..s PatientID=obj.PAADMPAPMIDRGetObjectId()
    ..;s TAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,TEpisodeID)
    ..s HospID=##class(web.UDHCHospitalGroup).GetHospitalByAdm(TEpisodeID) //获取当前客户所在院区
    ..q:(hospid'="")&&(hospid'=HospID)
    ..s LocID=$p($g(^PAADM(TEpisodeID)),"^",4)
    ..Q:(locid'="")&&(locid'=LocID)
    ..s TAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,TEpisodeID,HospID) //年龄
    ..s TIDCard=obj.PAADMPAPMIDR.PAPMIDVAnumber  //证件号
    ..s TIDCardDesc=obj.PAADMPAPMIDR.PAPMICardTypeDR.CARDDesc  //证件类型
    ..s TIDCardDesc=##class(User.DHCCredType).GetTranByDesc("CRTDesc",TIDCardDesc,langId) //多语言
    ..s TInDate=obj.PAADMAdmDate
    ..s:TInDate'="" TInDate=##class(websys.Conversions).DateLogicalToHtml(TInDate)
    ..s THPDate=##class(websys.Conversions).DateLogicalToHtml(Date)
    ..d FindBuild
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    q
FindBuild      
    set Data=$lb(TEpisodeID,TRegNo,TName,TSex,TAge,TIDCard,TInDate,THPDate,THStatusDesc,TIDCardDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod FindPatientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatientListExecute ]
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

ClassMethod FindPatientListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatientListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

// -1：不允许向下执行

// -2：提示是否继续向下执行

// 其他：继续执行

// w ##class(web.DHCPE.OtherPatientToHP).InsertConOrder()

ClassMethod InsertConOrder(PAADM, StationID, DocUserID, CurUserID, CurLocID)
{
    ;s NurAuditFlag=##class(User.DHCNurIpFeeAudit).IsNurAudit(PAADM)
    ;q:($p(NurAuditFlag,"^")="Y") "0"
    s NurAuditFlag=..IsNurAudit(PAADM)
    q:($p(NurAuditFlag,"^")="Y") "0"
    s:(DocUserID="")&&($D(%session)) DocUserID=%session.Get("LOGON.USERID")
    s AdmType=$P(^PAADM(PAADM),"^",2)
    q:AdmType="H" "1^体检人员不需要插入会诊费"
    s AdmReason=$P(^PAADM(PAADM),"^",10)  ;费别
    s LocID=$P(^PAADM(PAADM),"^",4)  ;就诊科室（开医嘱科室）
    i StationID'=""
    {
        q:$D(^DHCPEOtherPatientToHPBase("InDoc",LocID,DocUserID)) "-1^住院医生身份,不允许录入科室结果"
        q:'$D(^DHCPEOtherPatientToHPBase("ConRecLoc",LocID,StationID)) "1^站点不需要插入会诊费"
        i CurLocID=LocID d  ;就诊科室和登陆科室一致，说明是住院科室补提交，接受科室取设置科室
        .s RecLocID=$G(^DHCPEOtherPatientToHPBase("ConRecLoc",LocID,StationID))
        .s DefaultDoc=$P(RecLocID,"^",2)
        .s:DefaultDoc'="" DocUserID=DefaultDoc
        .s RecLocID=$P(RecLocID,"^",1)
        e  d ;不一致，取当前科室为接受科室
        .s RecLocID=CurLocID
        .s DefaultDoc=$P($G(^DHCPEOtherPatientToHPBase("ConRecLoc",LocID,StationID)),"^",2)
        .s:DefaultDoc'="" DocUserID=DefaultDoc
        
    }
    else
    {
        ;q "1^总检不需要插会诊费"
        i $D(^DHCPEOtherPatientToHPBase("GenConUser",LocID)){
            s DocUserID=$G(^DHCPEOtherPatientToHPBase("GenConUser",LocID))
            s RecLocID=LocID
        }else{
            q "1^总检没有设置会诊费"
        }
    }
    s CTCareProv=$p($g(^SSU("SSUSR",DocUserID)),"^",14)
    q:(CTCareProv="") "-2^医生没有定义职称，不能插入会诊费"
    s CTCarPrvTp=$p($g(^CTPCP(CTCareProv,1)),"^",4)
    q:(CTCarPrvTp="") "-2^医生没有定义职称，不能插入会诊费"
    s ItemID=$G(^DHCPEOtherPatientToHPBase("CarPrvTpConOrder",LocID,CTCarPrvTp))
    i ItemID="" d
    .s ItemID=$G(^DHCPEOtherPatientToHPBase("ConOrderDefault",LocID))
    q:ItemID="" "-2^没有设置会诊费，不自动插入会诊费"
    //判断此医生是否已经存在对应的会诊费医嘱
    //s ConItemHadExist=..ConItemHadExist(PAADM,ItemID,DocUserID)
    //q:ConItemHadExist="1" "2^此医生已经存在相同的会诊费"
    if StationID'=2  d //内科去维护的下医嘱医生
    .s OldDocUser=..GetDocUser(PAADM,StationID)
    .s:OldDocUser'="" CurUserID=OldDocUser
    ;PAADM_Epissubtype_DR   控制特需价格，还是普通价格的
    s FeeTypeID=$P(^PAADM(PAADM),"^",59)
    s Price=##class(web.UDHCJFPRICE).GetOrderPrice(FeeTypeID,"",ItemID,+$H,"","","","")
    s Price=$P(Price,"^",4)
    
    ;Adm:就诊Rowid,OrdItemStr:需插入医嘱串,User:录入用户,Loc:开医嘱科室,DocUserId:下医嘱医生用户ID
    ;ArcimRowid(医嘱项Rowid)^PackQty(医嘱数量)^RecLoc(接收科室)^OEPrice(医嘱价格)^specimen(标本/)^AdmReason(费别/)^SttDat(医嘱开始日期/)^OSRID(医嘱套Rowid)
    
    //s OrdItemStr=ItemID_"^"_1_"^"_RecLocID_"^"_Price_"^"_"^"_AdmReason_"^"_"^"
    //s OrderRet=##class(web.DHCDocService).InsertOrderItem(PAADM,OrdItemStr,CurUserID,LocID,DocUserID)
    s hisItem=ItemID_"^"_1_"^"_RecLocID_"^"_Price_"^"_""_"^^"_""_"^"_+$H_"^"_""_"^"_""_"^"_""_"^"_""
    s OrderRet=##class(web.DHCPE.PEApp).InsertOrdItem(PAADM, hisItem, CurUserID,LocID, DocUserID)
    
    //记录是否为自动插入的医嘱，自动插入的医嘱取消提交时自动停医嘱
    i +OrderRet=0 d
    .s OrdItemID=$P(OrderRet,"^",2)
    .s OrdItemID=$P(OrdItemID,"*",1)
    .s StationDesc=""
    .i StationID'=""  s StationDesc=$P(^DHCPEST(StationID),"^",2)
    .;&SQL(update sqluser.OE_OrdItem set OEORI_ItemStat_DR='6' where oeori_rowid=:OrdItemID)
    .s ^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),"DEP",1) =StationDesc_"体检" 
    
    .i StationID'="" d
    ..;s LinkOrderID=..GetStationOrder(PAADM,StationID)
    ..;i LinkOrderID'="" d
    ..;.&SQL(update sqluser.OE_OrdItem set oeori_oeori_dr=:LinkOrderID,OEORI_ItemStat_DR='6' where oeori_rowid=:OrdItemID)
    ..s ^DHCPEOtherPatientToHP("InsertConItem",PAADM,StationID)=OrdItemID
    .e  d
    ..s ^DHCPEOtherPatientToHP("InsertConItem",PAADM)=OrdItemID
    q OrderRet
}

ClassMethod StopConOrder(PAADM, StationID, CurUserID)
{
    ;s NurAuditFlag=##class(User.DHCNurIpFeeAudit).IsNurAudit(PAADM)
    ;q:($p(NurAuditFlag,"^")="Y") "0"
    s NurAuditFlag=..IsNurAudit(PAADM)
    q:($p(NurAuditFlag,"^")="Y") "0"
    i StationID'="" d
    .s OrdItemID=$G(^DHCPEOtherPatientToHP("InsertConItem",PAADM,StationID))
    e  d
    .s OrdItemID=$G(^DHCPEOtherPatientToHP("InsertConItem",PAADM))
    q:OrdItemID="" "0"
    //q ##class(web.DHCDocService).StopOrderItem(OrdItemID, CurUserID)
    q ##class(appcom.OEOrdItem).UnUseMulti(OrdItemID, CurUserID,"","N")
}

// 得到站点下的第一天医嘱信息

// w ##class(web.DHCPE.OtherPatientToHP).GetStationOrder("11142321",2)

ClassMethod GetStationOrder(EpisodeID, StationID)
{
    q:(StationID="")||(EpisodeID="") ""
    s ret=""
    s OEOrder=0
    f  s OEOrder=$O(^OEORD(0,"Adm",EpisodeID,OEOrder))  q:(OEOrder="")||(ret'="")  d
    .s OEOrdItem=0
    .f  s OEOrdItem=$O(^OEORD(OEOrder,"I",OEOrdItem))  q:(OEOrdItem="")||(ret'="")  d
    ..s CurData=$G(^OEORD(OEOrder,"I",OEOrdItem,1))
    ..Q:(""=CurData)
    ..s ORIStat=$p(CurData,"^",13)
    ..q:ORIStat=4
    ..s OEORIRowId=OEOrder_"||"_OEOrdItem
    ..s ItemMastId=$p(CurData,"^",2)
    ..Q:$g(ItemMastId)=""
    ..s Station=$o(^DHCPEST(0,"STORD_ARCIM",ItemMastId,0))
    ..q:Station'=StationID
    ..s ret=OEORIRowId
    q ret
}

// 0:不存在

// 1:存在

// -1:

ClassMethod ConItemHadExist(PAADM, ItemID, DocUserID)
{
    s Ret=0
    s OrderID=$O(^OEORD(0,"Adm",PAADM,0))
    q:OrderID="" Ret
    s SttDate=""
    f  s SttDate=$O(^OEORD(0,"ARCIM",OrderID,ItemID,SttDate)) q:(SttDate="")||(Ret'=0)  d
    .s OrderSub=0
    .f  s OrderSub=$O(^OEORD(0,"ARCIM",OrderID,ItemID,SttDate,OrderSub)) q:(OrderSub="")||(Ret'=0)  d
    ..s Stat=$P(^OEORD(OrderID,"I",OrderSub,1),"^",13)
    ..q:Stat="4"
    ..s Ret=1
    q Ret
}

/// debug: d ##class(%ResultSet).RunQuery("web.DHCPE.OtherPatientToHP", "FindReportList","2015-01-01","2015-05-15")
Query FindReportList(StartDate As %Library.String = "", EndDate As %Library.String = "", AuditStartDate As %Library.String = "", AuditEndDate As %Library.String = "", PrintStartDate As %Library.String = "", PrintEndDate As %Library.String = "", RegNo As %String = "", Name As %String = "", Status As %String = "", hospid As %Library.String = "", locid As %Library.String = "") As %Query(ROWSPEC = "TEpisodeID:%String,TRegNo:%String,TName:%String,TSex:%String,TAge:%String,TIDCard:%String,TInDate:%String,THPDate:%String,TAuditDate:%String,TPrintDate:%String,TStatus:%String,TIDCardDesc") [ SqlProc ]
{
}

ClassMethod FindReportListExecute(ByRef qHandle As %Binary, StartDate As %Library.String = "", EndDate As %Library.String = "", AuditStartDate As %Library.String = "", AuditEndDate As %Library.String = "", PrintStartDate As %Library.String = "", PrintEndDate As %Library.String = "", RegNo As %String = "", Name As %String = "", Status As %String = "", hospid As %Library.String = "", locid As %Library.String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    
    /***多语言 start***/
    if $d(%session) {
        set langId=%session.Get("LOGON.LANGID")
    }
    else
    { s langId=""}
    /***多语言 end***/
    
    i hospid="" d
    .s:$d(%session) hospid=%session.Get("LOGON.HOSPID")
    i locid="" d
    .s:$d(%session) locid=%session.Get("LOGON.CTLOCID")

    ;s:StartDate="" StartDate=1
    ;s:EndDate="" EndDate=+$H
    
    s:StartDate'="" StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    ;s:AuditStartDate="" AuditStartDate=1
    ;s:AuditEndDate="" AuditEndDate=+$H

    s:AuditStartDate'="" AuditStartDate=##class(websys.Conversions).DateHtmlToLogical(AuditStartDate)
    s:AuditEndDate'="" AuditEndDate=##class(websys.Conversions).DateHtmlToLogical(AuditEndDate)
    ;s:PrintStartDate="" PrintStartDate=1
    ;s:PrintEndDate="" PrintEndDate=+$H

    s:PrintStartDate'="" PrintStartDate=##class(websys.Conversions).DateHtmlToLogical(PrintStartDate)
    s:PrintEndDate'="" PrintEndDate=##class(websys.Conversions).DateHtmlToLogical(PrintEndDate)
    
    
    i RegNo'=""  d
    .s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo,locid)
    .s RegNoIndex=RegNo
    .s RegNoIndex=$ZCVT(RegNoIndex,"U")
    .s PaPatID=$O(^PAPERi("PAPMI_PatNo",RegNoIndex,0))
    .q:PaPatID=""
    .s ADMType=""
    .f  s ADMType=$O(^PAPERdr(PaPatID,"ADM",ADMType)) q:ADMType=""  d
    ..s PaadmID=""
    ..f  s PaadmID=$O(^PAPERdr(PaPatID,"ADM",ADMType,PaadmID),-1) q:PaadmID=""  d
    ...s ID=..GetOldID(PaadmID)
    ...q:ID=""
    ...d GetOneInfo
    e  i Name'=""  d
    .s NameIndex=$ZCVT(Name,"U")
    .s NameDesc=$o(^PAPERi("PAPER_PatName",NameIndex),-1)
    .f  s NameDesc=$O(^PAPERi("PAPER_PatName",NameDesc)) q:(NameDesc="")||(NameDesc'[NameIndex)  d
    ..s PaPatID=""
    ..f  s PaPatID=$O(^PAPERi("PAPER_PatName",NameDesc,PaPatID)) q:(PaPatID="")  d
    ...s ADMType=""
    ...f  s ADMType=$O(^PAPERdr(PaPatID,"ADM",ADMType)) q:ADMType=""  d
    ....s PaadmID=""
    ....f  s PaadmID=$O(^PAPERdr(PaPatID,"ADM",ADMType,PaadmID),-1) q:PaadmID=""  d
    .....s ID=..GetOldID(PaadmID)
    .....q:ID=""
    .....d GetOneInfo
    e  i (StartDate'="")||(EndDate'="")  d
    .s:StartDate="" StartDate=1
    .s:EndDate="" EndDate=+$H
    .s Date=StartDate-1
    .f  s Date=$O(^User.DHCPEOtherPatientToHPI("OTHCreateDateIndex",Date)) q:(Date="")||(Date>EndDate)  d
    ..s ID=0
    ..f  s ID=$O(^User.DHCPEOtherPatientToHPI("OTHCreateDateIndex",Date,ID)) q:ID=""  d
    ...d GetOneInfo
    e  i (AuditStartDate'="")||(AuditEndDate'="")  d
    .s:AuditStartDate="" AuditStartDate=1
    .s:AuditEndDate="" AuditEndDate=+$H
    .s Date=AuditStartDate-1
    .f  s Date=$O(^User.DHCPEOtherPatientToHPI("AuditDateIndex",Date)) q:(Date="")||(Date>AuditEndDate)  d
    ..s ID=0
    ..f  s ID=$O(^User.DHCPEOtherPatientToHPI("AuditDateIndex",Date,ID)) q:ID=""  d
    ...d GetOneInfo
    e  i (PrintStartDate'="")||(PrintEndDate'="")  d
    .s:PrintStartDate="" PrintStartDate=1
    .s:PrintEndDate="" PrintEndDate=+$H
    .s Date=PrintStartDate-1
    .f  s Date=$O(^User.DHCPEOtherPatientToHPI("PrintDateIndex",Date)) q:(Date="")||(Date>PrintEndDate)  d
    ..s ID=0
    ..f  s ID=$O(^User.DHCPEOtherPatientToHPI("PrintDateIndex",Date,ID)) q:ID=""  d
    ...d GetOneInfo
    e  d
    .s ID=0
    .f  s ID=$O(^User.DHCPEOtherPatientToHPD(ID)) q:ID=""  d
    ..d GetOneInfo
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
GetOneInfo
    s TStatusCode=$LG(^User.DHCPEOtherPatientToHPD(ID),12)
    q:TStatusCode=0
    d ClearInfo
    s TEpisodeID=$LG(^User.DHCPEOtherPatientToHPD(ID),2)
    s obj=##class(User.PAAdm).%OpenId(TEpisodeID)
    s PAPMIDR=$p(^PAADM(TEpisodeID),"^",1)
    s TRegNo=obj.PAADMPAPMIDR.PAPMIIPNo
    s TName=obj.PAADMPAPMIDR.PAPMIName
    s TSex=obj.PAADMPAPMIDR.PAPMISexDR.CTSEXDesc
    s TSex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",TSex,langId) //多语言
	
    s TAge=##class(web.DHCBillInterface).GetPapmiAge(PAPMIDR,TEpisodeID)
    
    s HospID=##class(web.UDHCHospitalGroup).GetHospitalByAdm(TEpisodeID) //获取当前客户所在院区
    q:(hospid'="")&&(hospid'=HospID)
    s LocID=$p($g(^PAADM(TEpisodeID)),"^",4)
    q:(locid'="")&&(locid'=LocID)
    
    s TIDCard=obj.PAADMPAPMIDR.PAPMIDVAnumber
    s TIDCardDesc=obj.PAADMPAPMIDR.PAPMICardTypeDR.CARDDesc
    s TIDCardDesc=##class(User.DHCCredType).GetTranByDesc("CRTDesc",TIDCardDesc,langId) //多语言
    s TInDate=obj.PAADMAdmDate
    s:TInDate'="" TInDate=##class(websys.Conversions).DateLogicalToHtml(TInDate)
    s THPDate=$LG(^User.DHCPEOtherPatientToHPD(ID),4)
    s:THPDate'="" THPDate=##class(websys.Conversions).DateLogicalToHtml(THPDate)
    s TAuditDate=$LG(^User.DHCPEOtherPatientToHPD(ID),14)
    s:TAuditDate'="" TAuditDate=##class(websys.Conversions).DateLogicalToHtml(TAuditDate)
    s TPrintDate=$LG(^User.DHCPEOtherPatientToHPD(ID),10)
    s:TPrintDate'="" TPrintDate=##class(websys.Conversions).DateLogicalToHtml(TPrintDate)
    q:(Status'="")&&(Status'=TStatusCode)
    s TStatus=..GetStatusDesc(TStatusCode)
    d FindBuild
    q
ClearInfo
    s (TEpisodeID,TRegNo,TName,TSex,TAge,TIDCard,TInDate,THPDate,TAuditDate,TPrintDate,TStatus,TIDCardDesc)=""
    q
FindBuild      
    set Data=$lb(TEpisodeID,TRegNo,TName,TSex,TAge,TIDCard,TInDate,THPDate,TAuditDate,TPrintDate,TStatus,TIDCardDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod FindReportListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindReportListExecute ]
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

ClassMethod FindReportListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindReportListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetStatusDesc(Status)
{
   /*
    q:Status="0" "已删除"
    q:Status="1" "未审核"
    q:Status="2" "已审核"
    q:Status="3" "已打印"
    q:Status="4" "已取"
    q ""
    */
    //多语言
    if $d(%session) {
        set langId=%session.Get("LOGON.LANGID")
    }
    else
    { s langId=""}
    
	q:Status="0" ##class(websys.Translation).Get("dhcpeinpatient.reportprint.csp","已删除",langId)
	q:Status="1" ##class(websys.Translation).Get("dhcpeinpatient.reportprint.csp","未审核",langId)
	q:Status="2" ##class(websys.Translation).Get("dhcpeinpatient.reportprint.csp","已审核",langId)
	q:Status="3" ##class(websys.Translation).Get("dhcpeinpatient.reportprint.csp","已打印",langId)
	q:Status="4" ##class(websys.Translation).Get("dhcpeinpatient.reportprint.csp","已取",langId)
	q ""
}

/// 输出状态
ClassMethod OutStatusHTML(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
    s:(""=ContrlWidth) ContrlWidth="155"
    s (NoAudit,Audit,Print)=""
    s:DefaultValue="1" NoAudit=" selected"
    s:DefaultValue="2" Audit=" selected"
    s:DefaultValue="3" Print=" selected"
    
    //下拉列表
    //w "<select name='Status' id='Status' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>",!
    w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("Status","")
    w "<option value=''>"_..GetStatusDesc("")_"</option>",!
    w "<option value='1'"_NoAudit_">"_..GetStatusDesc(1)_"</option>",!
    w "<option value='2'"_Audit_">"_..GetStatusDesc(2)_"</option>",!
    w "<option value='3'"_Print_">"_..GetStatusDesc(3)_"</option>",!
    w "</select>",!
    Quit $$$OK
}

/// 得到站点下的下医嘱人id
/// w ##class(web.DHCPE.OtherPatientToHP).GetDocUser(11084344,2)
ClassMethod GetDocUser(PAADM, StationID)
{
    s Ret=""
    s OrderID=$O(^OEORD(0,"Adm",PAADM,0))
    q:OrderID="" Ret
    s ItemID=""
    f  s ItemID=$O(^OEORDi(0,"ARCIM",OrderID,ItemID)) q:ItemID=""  d
    .s SttDate=""
    .f  s SttDate=$O(^OEORDi(0,"ARCIM",OrderID,ItemID,SttDate)) q:(SttDate="")||(Ret'="")  d
    ..s OrderSub=0
    ..f  s OrderSub=$O(^OEORDi(0,"ARCIM",OrderID,ItemID,SttDate,OrderSub)) q:(OrderSub="")||(Ret'="")  d
    ...s Stat=$P($g(^OEORD(OrderID,"I",OrderSub,1)),"^",13)
    ...q:Stat="4"
    ...s ArcimID=$P($g(^OEORD(OrderID,"I",OrderSub,1)),"^",2)
    ...s CurStationID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
    ...q:CurStationID'=StationID
    ...s Ret=$P($g(^OEORD(OrderID,"I",OrderSub,7)),"^",1)
    ;i Ret'="" d
    ;.s Ret=$O(^SSU("SSUSR",0,"CTPCP",Ret,""))
    q Ret
}

ClassMethod IsNurAudit(PAADM)
{
    s $ZT="NurAuditErr"
    s NurAuditFlag=##class(User.DHCNurIpFeeAudit).IsNurAudit(PAADM)
    q $p(NurAuditFlag,"^",1)
NurAuditErr
    q "N"
}

}
