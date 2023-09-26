Class web.DHCPE.AdmRecordManager Extends %Persistent
{

ClassMethod Insert(PreADM, AdmType, Type, User, Remark)
{
    ;d ##class(web.DHCPE.AdmRecordManager).Insert(78,"P","PRE","1","备注")
    ;AdmType  P;DHCPEPreIADM  I;DHCPEIADM  A:PAADM
    i User = ""
    {
        s User = ##class(HS.BL.PECommon).GetDftSessionParam("USERID")
    }
    s obj=##class(User.DHCPEAdmRecordManager).%New()
    i AdmType="I" d
    .s PreADM=$P(^DHCPEIADM(PreADM),"^",4)
    i AdmType="A" d
    .s PreADM=$O(^DHCPEIADM(0,"PAADM",PreADM,0))
    .q:PreADM=""
    .s PreADM=$P(^DHCPEIADM(PreADM),"^",4)
    q:PreADM=""
    d obj.ARMADMDRSetObjectId(PreADM)
    s CurStatus=$P(^DHCPEPreIADM(PreADM),"^",8)
    
    i ("Cashier"=Type)&&(CurStatus'="ARRIVED") d ##class(web.DHCPE.NetPre.GetPreInfo).UpdateChargedStatus(PreADM,"4")
    i ("DropInvPrt"=Type)&&(CurStatus'="ARRIVED") d ##class(web.DHCPE.NetPre.GetPreInfo).UpdateChargedStatus(PreADM,"1","1")
    i ("CancelArrived"=Type) d ##class(web.DHCPE.NetPre.GetPreInfo).UpdateChargedStatus(PreADM,"1","2")
    i Type="Arrived" d 
    .d ##class(web.DHCPE.NetPre.GetPreInfo).UpdateChargedStatus(PreADM,"5")
    .;d ##class(web.DHCPE.ItemDetailRecord).InsertByAdm(PreADM,User)
    i Type="CANCELPE" d ##class(web.DHCPE.NetPre.GetPreInfo).UpdateChargedStatus(PreADM,"6")



    s obj.ARMUser=User
    s obj.ARMDate=+$H
    s obj.ARMTime=$P($H,",",2)
    s obj.ARMType=Type
    s obj.ARMRemark=Remark
    s sc=obj.%Save()
    d obj.%Close()
    If ($System.Status.IsError(sc)) 
    {
        q "-1^"_$System.Status.GetErrorText(sc)
    }else{
        s LocID=$P(^DHCPEPreIADM(PreADM),"^",26)
        i Type="PrintDJD" d
        .s ArriveFlag=$p(^DHCPESetting("DHCPE","AutoArrived",LocID),"^",4)
        .i ArriveFlag="Y" d
        ..d ##class(web.DHCPE.DHCPEIAdm).IAdmArrived(PreADM)
        
        s IADM=$O(^DHCPEIADM(0,"CRMADM",PreADM,0))
        s PAADM=""
        i IADM'="" d
        .s PAADM=$P(^DHCPEIADM(IADM),"^",1)
        s MainDoctorGroup=$G(^DHCPESetting("DHCPE","MainDoctorGroup",LocID))
        i MainDoctorGroup="Y" d  //使用复检
        .i Type="GMainAuditStationS" d  //复检提交
        ..d:PAADM'="" ##class(web.DHCPE.ReportExportPDF).AuditReport(PAADM)
        .i Type="CaccelGMainAuditStationS" d
        ..d:PAADM'="" ##class(web.DHCPE.ReportExportPDF).CancelReport(PAADM)
        e  d
        .i Type="GAuditStationS" d
        ..d:PAADM'="" ##class(web.DHCPE.ReportExportPDF).AuditReport(PAADM)
        .i Type="CaccelGAuditStationS" d
        ..d:PAADM'="" ##class(web.DHCPE.ReportExportPDF).CancelReport(PAADM)
        q obj.%Id()
    }
}

ClassMethod GetAdmRecordReMarkInfo(AdmId As %String = "", CSPName As %String = "")
{

    s Info=""
    s NoAppInfo=##class(web.DHCPE.ResultEdit).GetUnAppedItems("",AdmId)
    s NoAppInfo=$P(NoAppInfo,"^",2)
    i NoAppInfo="" s NoAppInfo=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"无")
    i NoAppInfo'="" s Info=Info_##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"未执行项目:")_NoAppInfo
    s RefuseInfo=##class(web.DHCPE.ResultEdit).GetRefuseItems(AdmId)
    i RefuseInfo="" s RefuseInfo=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"无")
    i RefuseInfo'="" s Info=Info_$C(13)_##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"谢绝检查项目:")_RefuseInfo
    //i RefuseInfo'="" s Info=Info_"<br>谢绝检查项目:"_RefuseInfo
    s CurRoomInfo=##class(web.DHCPE.RoomManager).GetAdmCurRoom(AdmId,"ADM","Desc")
    s Person=$P(CurRoomInfo,"^",2)
    s Name=$P(CurRoomInfo,"^",3)
    s CurRoomInfo=$P(CurRoomInfo,"^",1)
    s CurRoomInfo="'"_Name_##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"'在'")_CurRoomInfo_##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"'处候诊,是第'")_Person_##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"'位")
    //i CurRoomInfo'="" s Info=Info_"<br>当前排队诊室:"_CurRoomInfo
    i CurRoomInfo'="" s Info=Info_$C(13)_##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"当前排队诊室:")_CurRoomInfo
    //s Info=Info_"<font>"
    q Info
}

Query FindAdmRecord(AdmId As %String = "", CSPName As %String = "") As %Query(ROWSPEC = "TID:%String,TDate:%String,TTime:%String,TType:%String,TRemark:%String,TUser:%String")
{
}

ClassMethod FindAdmRecordExecute(ByRef qHandle As %Binary, AdmId As %String = "", CSPName As %String = "") As %Status
{
    
    ;d ##class(%ResultSet).RunQuery("web.DHCPE.AdmRecordManager", "FindAdmRecord",552)
    Set repid=$I(^CacheTemp)
    s ind=1
    if (AdmId=""){
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }

    s PreADM=$O(^DHCPEIADM(0,"PAADM",AdmId,0))
    s PreADM=$P(^DHCPEIADM(PreADM),"^",4)
    s id=0
    f  s id=$o(^User.DHCPEAdmRecordManagerI("AdmIndex",PreADM,id)) q:id=""  d
    .s Date=$LG(^User.DHCPEAdmRecordManagerD(id),3)
    .s TDate=##class(websys.Conversions).DateLogicalToHtml(Date)
    .s Time=$LG(^User.DHCPEAdmRecordManagerD(id),5)
    .s TTime=##class(websys.Conversions).TimeLogicalToHtml(Time)
    .s Type=$LG(^User.DHCPEAdmRecordManagerD(id),6)
    .s Remark=$LG(^User.DHCPEAdmRecordManagerD(id),4)
    .s TType=..GetRecordTypeDesc(Type,CSPName)
    .s TRemark=..GetRemarkDesc(Type,Remark,CSPName)
    .s User=$LG(^User.DHCPEAdmRecordManagerD(id),7)
    .s TUser=$P(^SSU("SSUSR",User),"^",2)
    .d FindAdmRecordBuild   
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
FindAdmRecordBuild   
       
    set Data=$lb(id,TDate,TTime,TType,TRemark,TUser)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod FindAdmRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdmRecordExecute ]
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

ClassMethod FindAdmRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmRecordExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetBaseInfo(IADM)
{
    
    ;##class(web.DHCPE.AdmRecordManager).GetBaseInfo()
    s PapmiId=+^PAADM(IADM)
    s HIADM=$O(^DHCPEIADM(0,"PAADM",IADM,0))
    i HIADM'="" d
    .s PIADM=$P(^DHCPEIADM(HIADM),"^",4)
    .s GIADM=$P(^DHCPEPreIADM(PIADM),"^",2)
    .i GIADM'="" d
    ..s GBID=$P(^DHCPEPreGADM(GIADM),"^",1)
    ..s Group=$P(^DHCPEPreGBI(GBID),"^",2)
    .e  d
    ..s Group=""
    e  d
    .s Group=""
    .s PIADM=""
    // 登记号 PA_PatMas.{PAPMI_IPNo}
    s RegNo=$p($g(^PAPER(PapmiId,"PAT",1)),"^",1)
    
    // 患者姓名 PA_PatMas.{PAPMI_Name}
    s PatName=$p($g(^PAPER(PapmiId,"ALL")),"^",1)
    
    
    // 性别 PA_PatMas.{PAPMI_Sex_DR}(CT_Sex)
    s Sex=$p($g(^PAPER(PapmiId,"ALL")),"^",7)
    s:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
   
    //年龄 PA_PatMas.{PAPMI_DOB}
    s Birth=$p($g(^PAPER(PapmiId,"ALL")),"^",6)
    S:Birth'="" Birth=##class(websys.Conversions).DateLogicalToHtml(Birth)

    S PACCardDesc="",IDCard=""
    S PACCardTypeDR=$P($G(^PAPER(PapmiId,"PAT",3)),"^",7)
    I PACCardTypeDR'=""  S PACCardDesc=$p($g(^PAC("CARD",PACCardTypeDR)),"^",2)
    s IDCard=$p($g(^PAPER(PapmiId,"PAT",3)),"^",6)

    s DocTel=""
    s Tel=""
    i DocTel="" d
    .i PIADM'="" d
    ..s Tel=##class(web.DHCPE.PreCommon).GetTelNo("PIADM",PIADM)
    .e  d
    ..s Tel=$p($g(^PAPER(PapmiId,"PER",1)),"^",11)
    e  d
    .s Tel=DocTel
    
    /***翻译 start***/
    s Sex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",Sex,"CTSEXDesc","cls")
    s PACCardDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCCredType",PACCardDesc,"CRTDesc","cls")
    /***翻译 end***/
    q PatName_"^"_Sex_"^"_Birth_"^"_IDCard_"^"_RegNo_"^"_Tel_"^"_Group_"^"_PapmiId_"^"_PACCardDesc
}

ClassMethod GetRecordTypeDesc(Type, CSPName As %String = "")
{
    ;w ##class(web.DHCPE.AdmRecordManager).GetRecordTypeDesc("Cashier")
    s:(Type="PREInsert")||(Type="APREINSERT") TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"预约")
    s:(Type="Register")||(Type="BREGISTER") TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"登记")
    s:(Type="PrintDJD")||(Type="EPRINTDJD") TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"打印导检单")
    s:(Type="PrintBar")||(Type="FPRINTBAR") TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"打印条码")
    s:(Type="SpecCollect")||(Type="GSPECCOLLECT") TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"采集标本")
    s:(Type="Arrived")||(Type="CARRIVED") TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"到达")
    s:Type="CancelArrived" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"取消到达")
    s:Type="ADDItem" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"加项目")
    s:Type="ADDSet" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"加套餐")
    s:Type="DeleteItem" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"删除项目")
    s:Type="Discount" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"打折")
    s:Type="Cashier" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"收费")
    s:Type="CancleDiscount" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"无优惠")
    s:Type="DropInvPrt" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"退费")
    s:Type="AuditStationS" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"科室提交")
    s:Type="CaccelAuditStationS" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"科室取消提交")
    s:(Type="GAuditStationS")||(Type="JGAUDITSTATIONS") TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"总检提交")
    s:Type="CaccelGAuditStationS" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"总检取消提交")
    s:(Type="GMainAuditStationS")||(Type="KGMAINAUDITSTATIONS") TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"复检提交")
    s:Type="CaccelGMainAuditStationS" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"复检取消提交")
    s:(Type="ReportStatus")||(Type="LREPORTSTATUS") TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"修改报告状态")
    s:(Type="RecPaper")||(Type="HRECPAPER") TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"收表")
    s:(Type="FetchReport")||(Type="NFETCHREPORT") TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"取报告")
    s:(Type="SendAudit")||(Type="ISENDAUDIT") TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName, "送总检")
    s:(Type="Complete")||(Type="MCOMPLETE") TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"报告完成")
    s:Type="RC" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"完成检查")
    s:Type="CacleSendAudit" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"取消完成检查")
    s:Type="CRefuseCheck" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"取消放弃检查")
    s:Type="RefuseCheck" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"放弃检查")
    s:(Type="CANCELPE")||(Type="DCANCELPE") TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"取消体检")
    s:(Type="UNCANCELPE") TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"撤消取消体检")
    s:Type="PEResult" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"保存结果")
    s:Type="CANCELPREREG" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"取消预约")
    s:Type="DrugApply" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"退药申请")
    s:Type="CancelDrugApply" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"取消退药申请")
    s:Type="UpdateEpisodeNo" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"更新标本号")
    s:Type="SubStatus" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"置已检")
    s:Type="CancelSubStatus" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"撤销置已检")
    s:Type="DelayItem" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"项目延期")
    s:Type="CancelDelayItem" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"撤销项目延期")
    s:Type="AsCharged" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"定额卡支付")
	s:Type="DeleteAsCharged" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"撤销定额卡支付")
	s:Type="AllRefund" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"全退申请")
	s:Type="CancelAllRefund" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"撤销全退申请")
	s:Type="UpdateDate" TypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"改期")
    q TypeDesc
}

ClassMethod GetRemarkDesc(Type, Remark, CSPName As %String = "")
{
    ;w ##class(web.DHCPE.AdmRecordManager).GetRemarkDesc("Cashier","285")
    q:Remark="" ""
    i Type="SpecCollect" d
    .s Remark=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"标本号:")_Remark
    e  i (Type="ADDItem") d
    .s ArcIMID=$P(^DHCPEPreIADM(+Remark,"ORDITEM",$P(Remark,"||",2)),"^",1)
    .s ItemDesc=$P(^ARCIM(+ArcIMID,$P(ArcIMID,"||",2),1),"^",2)
    .s ItemDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",ItemDesc,"ARCIMDesc","cls") //翻译
    .s Remark=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"项目:")_ItemDesc
    e  i (Type="DeleteItem") d
    .s Len=$l(Remark,"(")
    .i Len=1 d
    ..s ArcIMID=$P(^DHCPEPreIADM(+Remark,"ORDITEM",$P(Remark,"||",2)),"^",1)
    ..s ItemDesc=$P(^ARCIM(+ArcIMID,$P(ArcIMID,"||",2),1),"^",2)
    ..s ItemDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",ItemDesc,"ARCIMDesc","cls") //翻译
    ..s Remark=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"项目:")_ItemDesc
    .e  d
    ..s EntDR=$p($p(Remark,"(",2),")",1)
    ..s ItemDR=$p(Remark,"(",1)
    ..s ArcIMID=$P(^DHCPEPreIADM(+ItemDR,"ORDITEM",$P(ItemDR,"||",2)),"^",1)
    ..s ItemDesc=$P(^ARCIM(+ArcIMID,$P(ArcIMID,"||",2),1),"^",2)
    ..s ItemDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",ItemDesc,"ARCIMDesc","cls") //翻译
    ..s SetDR=$p(^DHCPEPreIADM(+EntDR,"ORDENT",$p(EntDR,"||",2)),"^",1)
    ..s SetDesc=$p(^ARCOS(SetDR),"^",2)
    ..s Remark=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"项目:")_ItemDesc_"("_SetDesc_")"
    e  i Type="Cashier" d
    .s Remark=$P(^DHCPEINVPRT(Remark),"^",1)
    .s Remark=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"发票号:")_Remark
    e  i Type="DropInvPrt" d
    .s Remark=$P(^DHCPEINVPRT(Remark),"^",1)
    .s Remark=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"发票号:")_Remark
    e  i Type="AuditStationS" d
    .s Remark=$P(^DHCPEST(Remark),"^",2)
    e  i Type="CaccelAuditStationS" d
    .s Remark=$P(^DHCPEST(Remark),"^",2)
    e  i Type="ReportStatus" d
    .i Remark="S" d
    ..s Remark=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"发送")
    .e  i Remark="A" d
    ..s Remark=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"审核")
    .e  i Remark="P" d
    ..s Remark=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"打印")
    e  i Type="RC" d  //科室确认
    .i Remark'="" s Remark=$LG(^User.DHCPEAreaD(+Remark,"ChildRoom",$P(Remark,"||",2)),3)
    .s Remark=Remark_##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"科室确认")
    e  i (Type="CRefuseCheck")||(Type="RefuseCheck") d  //放弃检查
    .i Remark'="" d
    ..s Remark=$p(^OEORD($P(Remark,"||",1),"I",$p(Remark,"||",2),1),"^",2)
    ..s:Remark'="" Remark=##class(web.DHCPE.DHCPECommon).GetArcDesc(Remark)
    .s Remark=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"项目:")_Remark
    e  i Type="PEResult" d
    .i Remark'="" d
    ..s Remark=$p(^OEORD($P(Remark,"||",1),"I",$p(Remark,"||",2),1),"^",2)
    ..s:Remark'="" Remark=##class(web.DHCPE.DHCPECommon).GetArcDesc(Remark)
    .s Remark=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"项目:")_Remark
    e  i Type="Discount" d
    .s PrivilegeMode=##class(web.DHCPE.PreAudit).GetPrivilegeMode($p(Remark,"^",2))
	.s Remark=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"优惠方式:")_PrivilegeMode_"，"_##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"折扣率：")_$p(Remark,"^",1)_"%，"_##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"审核ID：")_$p(Remark,"^",3)
    e  i Type="ADDSet" d
    .s SetDR=$p(^DHCPEPreIADM(+Remark,"ORDENT",$p(Remark,"||",2)),"^",1)
    .s SetDesc=$p(^ARCOS(SetDR),"^",2)
    .s Remark=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"套餐:")_SetDesc
    e  i ((Type="DrugApply")||(Type="CancelDrugApply")||(Type="DelayItem")||(Type="CancelDelayItem")||(Type="SubStatus")||(Type="CancelSubStatus")) d
    .
    .i Remark'="" d
    ..s Remark=$p(^OEORD($P(Remark,"||",1),"I",$p(Remark,"||",2),1),"^",2)
    ..s:Remark'="" Remark=##class(web.DHCPE.DHCPECommon).GetArcDesc(Remark)
    .s Remark=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"项目:")_Remark
    e  i ((Type="AsCharged")||(Type="DeleteAsCharged")) d
	.i Remark'="" s Remark=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"审核ID: ")_Remark
	e  i ((Type="AllRefund")||(Type="CancelAllRefund")) d
	.i Remark'="" s Remark=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"发票ID: ")_Remark

    q Remark
}

Storage Default
{
<Data name="AdmRecordManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.AdmRecordManagerD</DataLocation>
<DefaultData>AdmRecordManagerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.AdmRecordManagerD</IdLocation>
<IndexLocation>^web.DHCPE.AdmRecordManagerI</IndexLocation>
<StreamLocation>^web.DHCPE.AdmRecordManagerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
