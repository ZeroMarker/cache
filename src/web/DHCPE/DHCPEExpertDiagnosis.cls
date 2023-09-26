Import SQLUser

/// 专家诊断主表
/// DHC_PE_ExpertDiagnosis
Class web.DHCPE.DHCPEExpertDiagnosis Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

Query EDCondition(ParrefRowId As %Library.String = "") As %Query(ROWSPEC = "TChd:%String,TStation:%String,TOrderDetail:%String,TStandard:%String,TODSDR:%String,TEDCRowId:%String,TARDesc:%String")
{
}

ClassMethod EDConditionExecute(ByRef qHandle As %Binary, ParrefRowId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s Chd=0
    f  s Chd=$o(^DHCPEED(ParrefRowId,"EDC",Chd)) q:Chd=""  d
    .s CurData=$g(^DHCPEED(ParrefRowId,"EDC",Chd))
    .s ODS=$p(CurData,"^",1)
    .s ODRDR=$p(ODS,"||",1,2)
    .s ODRDR=$O(^DHCPEODR(0,"OD",ODRDR,0))
    .s ARDesc=""
    .i ODRDR'="" d
    ..s ARID=$p($G(^DHCPEODR(ODRDR)),"^",1)
    ..i ARID'="" s ARDesc=$p($G(^ARCIM(+ARID,$p(ARID,"||",2),1)),"^",2)
    
    .s Station=$p(^DHCPEST($p(ODS,"||",1)),"^",2)
    .s CurData=$G(^DHCPEST($p(ODS,"||",1),"OD",$p(ODS,"||",2)))
    .Q:(""=CurData)
    .s OrderDetail=$p(CurData,"^",1)
    .s CurData=$G(^DHCPEST($p(ODS,"||",1),"OD",$p(ODS,"||",2),"ODS",$p(ODS,"||",3)))
    .Q:(""=CurData)
    .s Standard=$p(CurData,"^",2)
    .s EDCRowId=ParrefRowId_"||"_Chd
    .d Build
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
Build
    set Data=$lb($g(Chd),Station,OrderDetail,Standard,ODS,EDCRowId,ARDesc)
    s ^lisatest("Data")=Data
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod EDConditionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EDConditionExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else{           
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod EDConditionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EDConditionExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod AddCondition(ParrefRowId As %Library.String = "", StandardRowId As %Library.String = "")
{
    //s EDRowId=$o(^DHCPEED(0,"CODE",ParrefCode,0))
    &sql(insert into DHC_PE_EDCondition(EDC_ParRef,EDC_ODS_DR)values(:ParrefRowId,:StandardRowId))
    Q SQLCODE
}

ClassMethod DelCondition1(EDCRowId As %Library.String = "")
{
    &sql(delete from DHC_PE_EDCondition where EDC_RowId=:EDCRowId)
    Q SQLCODE
}

ClassMethod UpdateED(EDRowId As %Library.String = "", Code As %Library.String = "", DiagnoseConclusion As %Library.String = "", Detail As %Library.String = "", Illness As %Library.String = "", CommonIllness As %Library.String = "", UserUpdate As %Library.String = "", StationID As %Library.String = "", Active As %Library.String = "", DiagnosisLevel As %Library.String = "", EDCRID As %Library.String = "", SexDR As %Library.String = "", HighRisk As %String = "N")
{
    s YGFlag=$P(HighRisk,"^",4)
    s StationLocID=$P(HighRisk,"^",3)
    s Sort=$P(HighRisk,"^",2)
    s HighRisk=$P(HighRisk,"^",1)
    s DateUpdate=+$h
    &sql(Update DHC_PE_ExpertDiagnosis 
        set ED_Code=:Code,ED_DiagnoseConclusion=:DiagnoseConclusion,
        ED_Detail=:Detail,ED_DateUpdate=:DateUpdate,
        ED_Illness=:Illness,ED_CommonIllness=:CommonIllness,ED_Station_DR=:StationID,
        ED_HighRisk=:HighRisk,ED_Sort=:Sort,ED_StationLocID=:StationLocID
        
        where ED_RowId=:EDRowId)
    i EDCRID'=""  d
    .&sql(Update DHC_PE_EDCRelate
        set EDCR_EDC_DR=:DiagnosisLevel where EDCR_RowId=:EDCRID)
    e   d
    .&sql(insert into DHC_PE_EDCRelate(EDCR_ED_DR, EDCR_EDC_DR) values (:EDRowId,:DiagnosisLevel))
    s ^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId)=Active
    
    s ^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Sex",EDRowId)=SexDR
    
    s ^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","YGCheck",EDRowId)=YGFlag
    
    ;i Active'="Y" d
    ;.k ^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId)  
    
    Q SQLCODE
}

ClassMethod InitED(EDRowId As %Library.String = "")
{
    i EDRowId=""{
        s Code=##class(web.DHCPE.DHCPEExpertDiagnosis).GetMaxCode()
        q "^^^^^"_Code_"^^^^^^^^^^^^^^^^^^^^^^^"
    }
    s EDStr=$g(^DHCPEED(EDRowId,1))_"^"_$g(^DHCPEED(EDRowId,"Detail"))
    s Station=$p(EDStr,"^",7)
    s StationName=""
    i Station'="" s StationName=$p($g(^DHCPEST(Station)),"^",2)
    s Active=$g(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId))
    s SexRowId=$g(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Sex",EDRowId))
    s YGFlag=$g(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","YGCheck",EDRowId))
    s EDCRID=""
    s EDDCID=""
    s EDCRID=$O(^DHCPEEDCR(0,"EDDR",EDRowId,0)) 
    i EDCRID'=""  s EDDCID=$P($G(^DHCPEEDCR(EDCRID)),"^",2)
    s StationLoc=$p(EDStr,"^",10)
    s StationLocDesc=""
    i $L(StationLoc,"||")>1 d
    .Q:'$D(^DHCPEST(+StationLoc,"STLOC",$P(StationLoc,"||",2)))
    .S StationLocDesc=$P(^DHCPEST(+StationLoc,"STLOC",$P(StationLoc,"||",2)),"^",1)
    //s:StationLoc'="" StationLocDesc=$P(^DHCPEST(+StationLoc,"STLOC",$P(StationLoc,"||",2)),"^",1)
    
    q EDStr_"^"_StationName_"^"_Active_"^"_EDDCID_"^"_EDCRID_"^"_SexRowId_"^"_StationLocDesc_"^"_YGFlag
}

ClassMethod DeleteED(EDRowId As %Library.String = "")
{
    TSTART
    &sql(Delete from DHC_PE_ExpertDiagnosis where ED_RowId=:EDRowId)
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    &sql(Delete from DHC_PE_EDCRelate where EDCR_ED_DR=:EDRowId)
    //i SQLCODE=100 s SQLCODE=0
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    &sql(Delete from DHC_PE_EDAlias where EDA_ED_DR=:EDRowId)
    i SQLCODE=100 s SQLCODE=0
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    &SQL(delete from DHC_PE_IDRelate where IDR_ED_DR=:EDRowId)
    i SQLCODE=100 s SQLCODE=0
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    i $d(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId)) d
    .k ^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId)
    TCOMMIT

    Q SQLCODE
}

ClassMethod InsertED(InString As %Library.String = "")
{
    s loc=%session.Get("LOGON.CTLOCID")
    //new PLIST,EDRowId
    s PLIST(2)=$p(InString,"^",2)
    s PLIST(3)=$p(InString,"^",3)
    s PLIST(4)=$p(InString,"^",6)
    s PLIST(5)=+$h
    s PLIST(6)=$p(InString,"^",4)
    s PLIST(7)=$p(InString,"^",5)
    s PLIST(8)=##class(web.DHCPE.DHCPEExpertDiagnosis).GetMaxCode()
    i $p(InString,"^",7)'="User" s PLIST(4)=""
    //s HospitalCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
    s HospitalCode=$G(^DHCPESetting("DHCPE","HospitalCode",loc))
    i HospitalCode="FX" s PLIST(4)="" //复兴
    s EDAlias=$p(InString,"^",8)
    s PLIST(9)=$p(InString,"^",9)
    //zl
    s Active=$p($g(InString),"^",10)
    s level=$p($g(InString),"^",11)
    s IllRowID=$p($g(InString),"^",12)
    s HighRisk=$p($g(InString),"^",13)
    
    s PLIST(10)=HighRisk
    
    s Sort=$p($g(InString),"^",14)
    s PLIST(11)=Sort
    
    s StationLocID=$p($g(InString),"^",15)
    s PLIST(12)=StationLocID
    
    s SexDR=$p($g(InString),"^",16)
    s YGFlag=$p($g(InString),"^",17)
    //
    TSTART
    &sql(Insert into sqluser.DHC_PE_ExpertDiagnosis
        values :PLIST())
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    s EDRowId=%ROWID
    i EDAlias'=""
    {
        s i=$l(EDAlias,";")
        s j=1
        while(j<=i)
        {
            s EDAlia=$p(EDAlias,";",j)
            s Strings="^"_EDRowId_"^"_EDAlia
            s SQLCODE=..UpdateAlias(Strings,"0")
            i SQLCODE
            {
                TROLLBACK
                q
            }
            s j=j+1
        }
        q:SQLCODE'=0 SQLCODE
    }
    s loc=%session.Get("LOGON.CTLOCID")
    &SQL(insert into DHC_PE_EDLoc (EDL_ParRef,EDL_Loc_DR) values (:EDRowId,:loc))
    i SQLCODE
        {
            TROLLBACK
            q SQLCODE
        }

      &sql(insert into DHC_PE_EDCRelate(EDCR_ED_DR, EDCR_EDC_DR)

         values (:EDRowId,:level))
    i SQLCODE
        {
            TROLLBACK
            q SQLCODE
        }
    s ^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId)=Active
    S ^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Sex",EDRowId)=SexDR
    S ^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","YGCheck",EDRowId)=YGFlag
    i Active="" d
    .k ^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId)
    s PLIST(2)=EDRowId
    s PLIST(3)=IllRowID
    if IllRowID'=""{
    &SQL(insert into sqluser.DHC_PE_IDRelate values :PLIST())
    }
    i SQLCODE
    {
            TROLLBACK
            q SQLCODE
    }
    TCOMMIT

    q SQLCODE_"^"_EDRowId
}

/// 显示专家诊断列表 疾病统计模块
/// d ##class(%ResultSet).RunQuery("web.DHCPE.DHCPEExpertDiagnosis","ExpertDiagnosisList","","ssq","","")
Query ExpertDiagnosisList(Desc As %Library.String = "", AliasText As %Library.String = "", Illness As %Library.String = "", CommonIllness As %Library.String = "") As %Query(ROWSPEC = "ED_RowId:%String, ED_Code:%String, ED_DiagnoseConclusion:%String")
{
}

ClassMethod ExpertDiagnosisListExecute(ByRef qHandle As %Binary, Desc As %Library.String = "", AliasText As %Library.String = "", Illness As %Library.String = "", CommonIllness As %Library.String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s AliasText=$ZCVT(AliasText,"U")
    s:(""=Illness) Illness="Y"
    s:(""=CommonIllness) CommonIllness="Y"
    // DHC_PE_ExpertDiagnosis 专家诊断主表
    i ""'=AliasText d
    .s Alias=$O(^DHCPEEDA(0,"Alias",AliasText))
    .f  s Alias=$O(^DHCPEEDA(0,"Alias",Alias)) q:(Alias="")||(Alias'[AliasText)  d
    ..// DHC_PE_EDAlias.{ EDA_RowId }
    ..s EDARowId=0
    ..f  s EDARowId=$O(^DHCPEEDA(0,"Alias",Alias,EDARowId)) q:(EDARowId="")  d
    ...S EDRowId=$P($G(^DHCPEEDA(EDARowId)),"^",1)
    ...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("ED",EDRowId)         //Add by 090702
    ...q:LocFlag=1 
    ...s CurData=$G(^DHCPEED(EDRowId,1))
    ...// ED_DiagnoseConclus 诊断结论
    ...s EDDiagnoseConclus=$P($G(CurData),"^",1)
    ...Q:(""'=Desc)&(EDDiagnoseConclus'[Desc)
    ...// ED_Code 编号
    ...s EDCode=$P($G(CurData),"^",6)
    ...// ED_Illness 是否疾病
    ...s EDIllness=$P($G(CurData),"^",4)
    ...Q:(""'=Illness)&(Illness'=EDIllness)
    ...// ED_CommonIllness 是否常见病
    ...s EDCommonIllness=$P($G(CurData),"^",5)
    ...Q:(""'=CommonIllness)&(CommonIllness'=EDCommonIllness)
    ...
    ...d ExpertDiagnosisListOut
    ..
    .
    .
    e  d
    .s EDRowId=0
    .f  s EDRowId=$O(^DHCPEED(EDRowId)) q:EDRowId=""  d
    ..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("ED",EDRowId)         //Add by 090702
    ..q:LocFlag=1 
    ..s CurData=$G(^DHCPEED(EDRowId,1))
    ..
    ..// ED_DiagnoseConclus 诊断结论
    ..s EDDiagnoseConclus=$P($G(CurData),"^",1)
    ..Q:(""'=Desc)&(EDDiagnoseConclus'[Desc)
    ..// ED_Code 编号
    ..s EDCode=$P($G(CurData),"^",6)
    ..// ED_Illness 是否疾病
    ..s EDIllness=$P($G(CurData),"^",4)
    ..Q:(""'=Illness)&("Y"'=EDIllness)
    ..// ED_CommonIllness 是否常见病
    ..s EDCommonIllness=$P($G(CurData),"^",5)
    ..Q:(""'=CommonIllness)&("Y"'=EDCommonIllness)
    ..d ExpertDiagnosisListOut
    ..
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
ExpertDiagnosisListOut
    set Data=$lb(EDRowId, EDCode, EDDiagnoseConclus)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod ExpertDiagnosisListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ExpertDiagnosisListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else{           
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod ExpertDiagnosisListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ExpertDiagnosisListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod UpdateAlias(DataStr, isDelete)
{
    //new PLIST
    if (isDelete=1)
    {
        &SQL(delete from sqluser.DHC_PE_EDAlias where EDA_RowId=:DataStr)
    }
    else
    {
        s RowId=$p(DataStr,"^",1)
        s PLIST(2)=$p(DataStr,"^",2)
        s PLIST(3)=$p(DataStr,"^",3)
        i RowId=""
        {
            &SQL(insert into sqluser.DHC_PE_EDAlias values :PLIST())
        }
        else
        {
            &SQL(update sqluser.DHC_PE_EDAlias values :PLIST() where EDA_RowId=:RowId)
        }
    }
    q SQLCODE
}

ClassMethod GetEDName(EDId)
{
    i EDId="" q ""
    q $P(^DHCPEED(EDId,"1"),"^",1)
}

/// 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.DHCPEExpertDiagnosis","GetEDiagnosisByAlias","肺部","52")
Query GetEDiagnosisByAlias(AddDiagnosis As %Library.String = "", ChartID As %Library.String = "", EpisodeID As %Library.String = "") As %Query(ROWSPEC = "ID:%String, Detail:%String:结论, DiagnoseConclusion:%String:建议, Code:%String:编码")
{
}

ClassMethod GetEDiagnosisByAliasExecute(ByRef qHandle As %Binary, AddDiagnosis As %String = "", ChartID As %Library.String = "", EpisodeID As %Library.String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s Desc=$ZCVT(AddDiagnosis,"U")
    s CurUser=%session.Get("LOGON.USERID")
    s NormalED=$G(^DHCPESetting("DHCPE","NoIncludeDiagnosis"))
    
    s LocID=%session.Get("LOGON.CTLOCID")
    i EpisodeID'="" s LocID=$P($G(^PAADM(EpisodeID)),"^",4)

    //S HospitalCode=$g(^DHCPESetting("DHCPE","HospitalCode"))
    S HospitalCode=$g(^DHCPESetting("DHCPE","HospitalCode",LocID))

    s vStationID=""
    If ChartID'="" s vStationID=##class(web.DHCPE.ResultEdit).GetPEStation($g(ChartID))
    s Job=$J
    i Desc=""
    {
        s EDID=0
        f  s EDID=$o(^DHCPEED(EDID)) q:EDID=""  d
        .s RowId=EDID
        .q:'$D(^DHCPEED(EDID,1))
        .s User=$p(^DHCPEED(EDID,1),"^",2)
        .//q:(User'="")&&(User'=CurUser)
        .d SetDataGetEDiagnosisByAlias
        .//d GetEDiagnosisByAlias
    }
    else
    {
        s RowIds="^"
        s TextDesc=$O(^DHCPEEDA(0,"Alias",Desc),-1)
        f  s TextDesc=$O(^DHCPEEDA(0,"Alias",TextDesc)) Q:(""=TextDesc)||(TextDesc'[Desc)  d
        .s ARowId=0
        .f  s ARowId=$O(^DHCPEEDA(0,"Alias",TextDesc,ARowId)) q:ARowId=""  d
        ..s RowId=$p($g(^DHCPEEDA(ARowId)),"^",1)
        ..q:RowId=""
        ..q:RowIds[("^"_RowId_"^")
        ..s RowIds=RowIds_RowId_"^"
        ..s User=$p($g(^DHCPEED(RowId,1)),"^",2)
        ..d SetDataGetEDiagnosisByAlias
    
        s TextDesc=$O(^DHCPEED(0,"CODE",Desc),-1)
        f  s TextDesc=$O(^DHCPEED(0,"CODE",TextDesc)) Q:((""=TextDesc)||(TextDesc'[Desc))  d
        .s RowId=0
        .f  s RowId=$O(^DHCPEED(0,"CODE",TextDesc,RowId)) q:RowId=""  d
        ..q:RowId=""
        ..q:RowIds[("^"_RowId_"^")
        ..s RowIds=RowIds_RowId_"^"
        ..s User=$p(^DHCPEED(RowId,1),"^",2)
        ..//q:(User'="")&&(User'=CurUser)
        ..d SetDataGetEDiagnosisByAlias
        ..//d GetEDiagnosisByAlias
        s TextDesc=$O(^DHCPEED(0,"Conclusion",Desc),-1)
        f  s TextDesc=$O(^DHCPEED(0,"Conclusion",TextDesc)) Q:(""=TextDesc)||(TextDesc'[Desc)  d
        .s RowId=0
        .f  s RowId=$O(^DHCPEED(0,"Conclusion",TextDesc,RowId)) q:RowId=""  d
        ..q:RowId=""
        ..q:RowIds[("^"_RowId_"^")
        ..s RowIds=RowIds_RowId_"^"
        ..s User=$p(^DHCPEED(RowId,1),"^",2)
        ..//q:(User'="")&&(User'=CurUser)
        ..d SetDataGetEDiagnosisByAlias
        ..//d GetEDiagnosisByAlias
    }
    d OutPut
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
SetDataGetEDiagnosisByAlias

    s (Detail,DC,Code)=""
    Set Cancle=0
    q:RowId=""
    s:$g(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",RowId))'="Y" Cancle=1
    s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("ED",RowId)         //Add by 090702
    q:LocFlag=1 
    s Str=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
    s SexID=""
    s SexCode=$p(Str,"^",2)
    i SexCode'=""  s SexID=$o(^CT("SEX",0,"Code",SexCode,0))
    s Sex=$g(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Sex",RowId))
    Quit:(Sex'="")&&(Sex'=SexID)
    s Detail=$P($G(^DHCPEED(RowId,"Detail")),"^",1)
    s DC=$P($G(^DHCPEED(RowId,"1")),"^",1)
    s Code=$P($G(^DHCPEED(RowId,"1")),"^",6)
    s StationID=$P($G(^DHCPEED(RowId,"1")),"^",7)
    s User=$p(^DHCPEED(RowId,1),"^",2)   //Add
    i (vStationID'="")&&(vStationID'=StationID)&&(StationID'="") s Cancle=1 ;&&(("^"_NormalED_"^")'[("^"_RowId_"^"))
    Quit:(Cancle=1)
    s StationName=""
    i $g(StationID)'="" s StationName=$p($g(^DHCPEST(StationID)),"^",2)
    s Sort=+$G(^DHCPEED(RowId,"UseCount"))
    s OneInfo=$lb(RowId, DC, Detail, Code)
    s ^TempDHCPEEDInfo(Job,Sort,RowId)=OneInfo
    q
OutPut
    s ind=1
    s Sort=""
    f  s Sort=$O(^TempDHCPEEDInfo(Job,Sort),-1) q:Sort=""  d
    .s RowID=""
    .f  s RowID=$O(^TempDHCPEEDInfo(Job,Sort,RowID)) q:RowID=""  d
    ..s OneInfo=$G(^TempDHCPEEDInfo(Job,Sort,RowID))
    ..d GetEDiagnosisByAlias
    k ^TempDHCPEEDInfo(Job)
    q
    
GetEDiagnosisByAlias      
    set Data=OneInfo
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod GetEDiagnosisByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEDiagnosisByAliasExecute ]
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

ClassMethod GetEDiagnosisByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEDiagnosisByAliasExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.DHCPEExpertDiagnosis","GetEDiagnosisByAliasICD","F","2")
Query GetEDiagnosisByAliasICD(AddDiagnosis As %Library.String = "", ChartID As %Library.String = "") As %Query(ROWSPEC = "HIDDEN:%String, ILLDesc:%String,Detail:%String, DiagnoseConclusion:%String, Code:%String,EDDR:%String")
{
}

ClassMethod GetEDiagnosisByAliasICDExecute(ByRef qHandle As %Binary, AddDiagnosis As %String = "", ChartID As %Library.String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s Desc=$ZCVT(AddDiagnosis,"U")
    //s CurUser=%session.Get("LOGON.USERID")
    
    s vStationID=##class(web.DHCPE.ResultEdit).GetPEStation($g(ChartID))
    s ind=1
    i Desc=""
    {
        s ILLSID=0
        f  s ILLSID=$o(^DHCPEILLS(ILLSID)) q:ILLSID=""  d
        .s RowId=ILLSID
        .d SetDataGetEDiagnosisByAliasICD
    }
    else
    {
        s RowIds="^"
        s TextDesc=$O(^DHCPEILLSA(0,"Alias",Desc),-1)
        f  s TextDesc=$O(^DHCPEILLSA(0,"Alias",TextDesc)) Q:(""=TextDesc)||(TextDesc'[Desc)  d
        .s ARowId=0
        .f  s ARowId=$O(^DHCPEILLSA(0,"Alias",TextDesc,ARowId)) q:ARowId=""  d
        ..s RowId=$p($g(^DHCPEILLSA(ARowId)),"^",1)
        ..q:RowId=""
        ..q:RowIds[("^"_RowId_"^")
        ..s RowIds=RowIds_RowId_"^"
        ..
        ..//s User=$p($g(^DHCPEED(RowId,1)),"^",2)
        ..//q:(User'="")&&(User'=CurUser)
        ..d SetDataGetEDiagnosisByAliasICD
        ..//d GetEDiagnosisByAlias
        ///?????
        /*
        s TextDesc=$O(^DHCPEILLS(0,"CODE",Desc),-1)
        f  s TextDesc=$O(^DHCPEILLS(0,"CODE",TextDesc)) Q:((""=TextDesc)||(TextDesc'[Desc))  d
        .s RowId=0
        .f  s RowId=$O(^DHCPEILLS(0,"CODE",TextDesc,RowId)) q:RowId=""  d
        ..q:RowId=""
        ..q:RowIds[("^"_RowId_"^")
        ..s RowIds=RowIds_RowId_"^"
        ..//s User=$p(^DHCPEED(RowId,1),"^",2)
        ..//q:(User'="")&&(User'=CurUser)
        ..d SetDataGetEDiagnosisByAliasICD
        ..//d GetEDiagnosisByAlias
        ///?????
        s TextDesc=$O(^DHCPEED(0,"Conclusion",Desc),-1)
        f  s TextDesc=$O(^DHCPEED(0,"Conclusion",TextDesc)) Q:(""=TextDesc)||(TextDesc'[Desc)  d
        .s RowId=0
        .f  s RowId=$O(^DHCPEED(0,"Conclusion",TextDesc,RowId)) q:RowId=""  d
        ..q:RowId=""
        ..q:RowIds[("^"_RowId_"^")
        ..s RowIds=RowIds_RowId_"^"
        ..s User=$p(^DHCPEED(RowId,1),"^",2)
        ..//q:(User'="")&&(User'=CurUser)
        ..d SetDataGetEDiagnosisByAliasICD
        ..//d GetEDiagnosisByAlias
        */
    }
   
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
SetDataGetEDiagnosisByAliasICD
    s (Detail,DC,Code)=""
    q:RowId=""
    Set IDRRowId=0
    For  Set IDRRowId=$o(^DHCPEIDR(0,"ILLSDR",RowId,IDRRowId)) Quit:IDRRowId=""  Do
    .Set EDDR=$p(^DHCPEIDR(IDRRowId),"^",1)
    .Quit:$g(EDDR)=""
    .Set Detail=$P($G(^DHCPEED(EDDR,"Detail")),"^",1)
    .Set ILLDesc=$p($g(^DHCPEILLS(RowId)),"^",2)
    .Set DC=$P($G(^DHCPEED(EDDR,"1")),"^",1)
    .Set Code=$P($G(^DHCPEED(EDDR,"1")),"^",6)
    .Set StationID=$P($G(^DHCPEED(EDDR,"1")),"^",7)
    .q:(vStationID'="")&&(StationID'="")&&(vStationID'=StationID)
    .s StationName=""
    .i StationID'="" s StationName=$p(^DHCPEST(StationID),"^",2)
    .d GetEDiagnosisByAliasICD
    q
    
GetEDiagnosisByAliasICD      
    set Data=$lb(RowId, ILLDesc,DC, Detail, Code,EDDR)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod GetEDiagnosisByAliasICDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEDiagnosisByAliasICDExecute ]
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

ClassMethod GetEDiagnosisByAliasICDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEDiagnosisByAliasICDExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// w ##class(web.DHCPE.DHCPEExpertDiagnosis).GetMaxCode()
ClassMethod GetMaxCode()
{
    s Code=0
    //&SQL(select max(ed_code) into :Code from sqluser.DHC_PE_ExpertDiagnosis)
    //防止建议编码重复
    &SQL(select max(cast(ed_code AS int)) into :Code from sqluser.DHC_PE_ExpertDiagnosis)
    i Code="" s Code=0
    s Code=+Code+1
    s Code=$E("00000000",1,8-$l(Code))_Code
    q Code
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.DHCPEExpertDiagnosis", "QueryED","","","","","")
Query QueryED(Code As %Library.String = "", DiagnoseConclusion As %Library.String = "", Alias As %Library.String = "", StationID As %Library.String = "", ChartID As %Library.String = "", HighRisk As %Library.String = "", ActiveFlag As %String = "", StationName As %String = "") As %Query(ROWSPEC = "RecordSum:%String,ED_RowId:%String, ED_Detail:%String, ED_DiagnoseConclusion:%String, ED_Code:%String,ED_Illness:%String,ED_CommonIllness:%String,TStationID:%String,TStationName:%String,TActive:%String,TUserName:%String,TLevel:%String,TSex:%String,THighRisk:%String,TYGFlag:%String")
{
}

ClassMethod QueryEDExecute(ByRef qHandle As %Binary, Code As %Library.String = "", DiagnoseConclusion As %Library.String = "", Alias As %Library.String = "", StationID As %Library.String = "", ChartID As %Library.String = "", HighRisk As %Library.String = "", ActiveFlag As %String = "", StationName As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    //s:ActiveFlag=1 ActiveFlag="Y"
    //s:ActiveFlag=0 ActiveFlag="N"
    
    s Code=$ZCVT(Code,"U")
    s DiagnoseConclusion=##class(web.DHCPE.DHCPECommon).UnEscape(DiagnoseConclusion)
    s DiagnoseConclusion=$ZCVT(DiagnoseConclusion,"U")
    s Alias=$ZCVT(Alias,"U")
    s CurUser=%session.Get("LOGON.USERID")
    //s CurUser=2873
    if (ChartID'="")&(StationID="") s StationID=##class(web.DHCPE.ResultEdit).GetPEStation($g(ChartID))
    s ind=1
    i Alias=""
    {
    s EDID=0

    f  s EDID=$o(^DHCPEED(EDID)) q:EDID=""  d
    .s RowId=EDID
    .q:'$D(^DHCPEED(EDID,1))
    .s User=$p(^DHCPEED(EDID,1),"^",2)
    .If User'="" s UserName=$p($g(^SSU("SSUSR",User)),"^",2)
    .else  Do 
    ..s UserName=User
    .d SetDataQueryED
    }
    else
    {
        s RowIds="^"
        s TextDesc=Alias
        s TextDesc=$O(^DHCPEEDA(0,"Alias",Alias),-1)
        //s ^renzwangTest(2)=TextDesc
        f  s TextDesc=$O(^DHCPEEDA(0,"Alias",TextDesc)) Q:(""=TextDesc)||(TextDesc'[Alias)  d
        .s ARowId=0
        .f  s ARowId=$O(^DHCPEEDA(0,"Alias",TextDesc,ARowId)) q:ARowId=""  d
        ..s RowId=$p($g(^DHCPEEDA(ARowId)),"^",1)
        ..q:RowId=""
        ..q:RowIds[("^"_RowId_"^")
        ..s RowIds=RowIds_RowId_"^"
        ..d SetDataQueryED
    }
   
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
SetDataQueryED
    s (Detail,DC,UCode,Illness,CommonIllness,Active,SexDesc)=""
    q:RowId=""
    s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("ED",RowId)         //Add by 090702
    q:LocFlag=1 
    s EDAliaID=0
    s Active=$g(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",RowId))
    s:Active="" Active="Y"
    
    ;q:($g(Active)="N")&(StationID'="")
    q:(ActiveFlag'="")&&(Active'=ActiveFlag)
    s DC=$P($G(^DHCPEED(RowId,"Detail")),"^",1)
    s Detail=$P($G(^DHCPEED(RowId,"1")),"^",1)
    s UDC=$ZCVT(Detail,"U")
    q:UDC'[DiagnoseConclusion
    
    s CCode=$P($G(^DHCPEED(RowId,"1")),"^",6)
    s UCode=$ZCVT(CCode,"U")
    q:UCode'[Code
    s Illness=$P($G(^DHCPEED(RowId,"1")),"^",4)
    s CommonIllness=$P($G(^DHCPEED(RowId,"1")),"^",5)
    
    s vStationID=$P($G(^DHCPEED(RowId,"1")),"^",7)
    q:((StationID'="")&&(StationID'=vStationID))
    s StationName=""
    i $g(vStationID)'="" s StationName=$p($g(^DHCPEST(vStationID)),"^",2)
    s EDCRID=""
    s EDDCID=""
    s EDCDesc=""
    s EDCRID=$O(^DHCPEEDCR(0,"EDDR",RowId,0)) 
    i EDCRID'="" s EDDCID=$P($G(^DHCPEEDCR(EDCRID)),"^",2)
    i EDDCID'="" s EDCDesc=$p($G(^DHCPEEDC(EDDCID)),"^",2)
    s THighRisk=$P($G(^DHCPEED(RowId,"1")),"^",8)
    q:(HighRisk'="")&&(THighRisk'="Y")
    //QUIT:$G(StationName)=""
    s Sex=$g(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Sex",RowId))
    i Sex'=""  s SexDesc=$p($g(^CT("SEX",Sex)),"^",2)
    
    S TYGFlag=$g(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","YGCheck",RowId))
    s:TYGFlag="" TYGFlag="N"
    
    d QueryED
    q
    
QueryED      
    set Data=$lb(0,RowId, DC, Detail, CCode,Illness,CommonIllness,StationID,StationName,Active,UserName,EDCDesc,SexDesc,THighRisk,TYGFlag)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod QueryEDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEDExecute ]
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
        s RecordSum=$o(^CacheTemp(repid,""),-1)
        s $List(^CacheTemp(repid,ind),1)=RecordSum
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod QueryEDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEDExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(web.DHCPE.DHCPEExpertDiagnosis).SetActive()
/// 激活所有诊断
ClassMethod SetActive()
{
 s EDRowId=0
 f  s EDRowId =$o(^DHCPEED(EDRowId))  q:EDRowId=""  d
 .s ^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId)="Y"
}

ClassMethod test()
{
 
    s EDRowId=0
    f  s EDRowId=$o(^DHCPECTDataEx("BaseData","EffDateTime",EDRowId)) q:EDRowId=""  d
    .s ^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId)=^DHCPECTDataEx("BaseData","EffDateTime",EDRowId)
    .k ^DHCPECTDataEx("BaseData","EffDateTime",EDRowId)
}

// d ##class(web.DHCPE.DHCPEExpertDiagnosis).Conversion()

ClassMethod Conversion()
{
    s EDRowId=0,detail=""
    f  s EDRowId =$o(^DHCPEED(EDRowId))  q:(EDRowId="")  d
    .s detail=$p($g(^DHCPEED(EDRowId,"Detail")),"^",1)
    .s DiagnoseConclus=$p($g(^DHCPEED(EDRowId,1)),"^",1)
    .//w !,detail
    .s detail= ##class(web.DHCPE.DHCPECommon).Replace(detail,"@","。")
    .//w !,"1"_detail
    .s detail= ##class(web.DHCPE.DHCPECommon).Replace(detail,"#","、")
    .s detail= ##class(web.DHCPE.DHCPECommon).Replace(detail,"$",",")
    .s DiagnoseConclus= ##class(web.DHCPE.DHCPECommon).Replace(DiagnoseConclus,"@","。")
    .s DiagnoseConclus= ##class(web.DHCPE.DHCPECommon).Replace(DiagnoseConclus,"#","、")
    .s DiagnoseConclus= ##class(web.DHCPE.DHCPECommon).Replace(DiagnoseConclus,"$",",")
    .s $p(^DHCPEED(EDRowId,"Detail"),"^",1)=detail
    .s $p(^DHCPEED(EDRowId,1),"^",1)=DiagnoseConclus
}

// d ##class(web.DHCPE.DHCPEExpertDiagnosis).Conversion1()

ClassMethod Conversion1()
{

    
    s EDRowId=0,detail=""
    f  s EDRowId =$o(^DHCPEED(EDRowId))  q:(EDRowId="")  d
    .s detail=$p($g(^DHCPEED(EDRowId,"Detail")),"^",1)
    .s DiagnoseConclus=$p($g(^DHCPEED(EDRowId,1)),"^",1)
    .s detail= ##class(web.DHCPE.DHCPECommon).Replace(detail,"(1)","①")
    .s detail= ##class(web.DHCPE.DHCPECommon).Replace(detail,"(2)","②")
    .s detail= ##class(web.DHCPE.DHCPECommon).Replace(detail,"(3)","③")
    .s detail= ##class(web.DHCPE.DHCPECommon).Replace(detail,"(4)","④")
    .s detail= ##class(web.DHCPE.DHCPECommon).Replace(detail,"(5)","⑤")
    .s detail= ##class(web.DHCPE.DHCPECommon).Replace(detail,"(6)","⑥")
    .s $p(^DHCPEED(EDRowId,"Detail"),"^",1)=detail
}

// d ##class(web.DHCPE.DHCPEExpertDiagnosis).HideDiagnosis()

ClassMethod HideDiagnosis()
{
    s EDRowId=0,detail=""
    f  s EDRowId =$o(^DHCPEED(EDRowId))  q:(EDRowId="")  d
    .s detail=$p($g(^DHCPEED(EDRowId,"Detail")),"^",1)
    .s DiagnoseConclus=$p($g(^DHCPEED(EDRowId,1)),"^",1)
    .//w !,DiagnoseConclus
    .//i ((DiagnoseConclus'["y")&&(DiagnoseConclus'["Y"))     d
    .//.K ^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId)
    .s ^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId)="Y"
}

// select EDA_RowId,EDA_ED_DR,EDA_Text from sqluser.DHC_PE_EDAlias where EDA_ED_DR=:EDId

Query EDAliasList(EDId As %String) As %SQLQuery(ROWSPEC = "EDA_RowId:%String,EDA_ED_DR:%String,EDA_Text:%String")
{
    select EDA_RowId,EDA_ED_DR,EDA_Text from sqluser.DHC_PE_EDAlias where EDA_ED_DR=:EDId
}

ClassMethod SetConditionFlag(EDID, Flag)
{
    s ^DHCPEDataEx("DHCPEExpertDiagnosis","ConditionFlag",EDID)=Flag
    q 0
}

// d ##class(web.DHCPE.DHCPEExpertDiagnosis).SetEDLoc()

ClassMethod SetEDLoc()
{
  
   s EDRowId=0,loc="152"
   f  s EDRowId =$o(^DHCPEED(EDRowId))  q:EDRowId=""  d
   .Q:$g(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId))'="Y"
   .&SQL(insert into DHC_PE_EDLoc (EDL_ParRef,EDL_Loc_DR) values (:EDRowId,:loc))
}

ClassMethod UpdateEDKey(Instring, Type)
{
 
  s CurUser=%session.Get("LOGON.USERID")
  s EDRowID=$P(Instring,"^",1)
  s Code=$P(Instring,"^",2)
  s DetailID=$P(Instring,"^",3)
  s Return=""
  if Type="0"  d  //更新操作
  .i $D(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","EDKey",EDRowID,Code))  s Return="CodeExist"
  .q:Return'=""
  .s ^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","EDKey",EDRowID,Code,DetailID)=$h_"^"_CurUser
  else  d
  .k ^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","EDKey",EDRowID,Code)
  
  q Return
}

Query EDKey(EDID As %Library.String = "") As %Query(ROWSPEC = "Code:%String,Detail:%String,DetailID:%String,EDRowID:%String,StationName:%String,StationID:%String")
{
}

ClassMethod EDKeyExecute(ByRef qHandle As %Binary, EDID As %String = "") As %Status
{
    
    Set repid=$I(^CacheTemp)
     i ""=EDID {    
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    s ind=1
    s Code="",StationDesc=""
    f  s Code=$o(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","EDKey",EDID,Code)) q:Code=""  d 
    .s DetailID=0
    .f  s DetailID=$o(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","EDKey",EDID,Code,DetailID)) q:DetailID=""  d
    ..s Station=$p(DetailID,"||",1)
    ..i Station'=""  s StationDesc=$p(^DHCPEST(Station),"^",2)
    ..s DetailDesc=$p($G(^DHCPEST($p(DetailID,"||",1),"OD",$p(DetailID,"||",2))),"^",1)
    ..d Output
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
Output
    set Data=$lb(Code,DetailDesc,DetailID,EDID,StationDesc,Station)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod EDKeyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EDKeyExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else{           
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod EDKeyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EDKeyExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

// d ##class(web.DHCPE.DHCPEExpertDiagnosis).GetKeyReplaceStr("248","2")

ClassMethod GetKeyReplaceStr1(PAADM, EDRowID)
{
 
    //替换关键字
    s Advice=$p($g(^DHCPEED(EDRowID,"Detail")),"^",1)
    s KeyCode=""
    f  s KeyCode=$o(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","EDKey",EDRowID,KeyCode)) q:KeyCode=""  d 
    .s DetailID=0
    .f  s DetailID=$o(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","EDKey",EDRowID,KeyCode,DetailID)) q:DetailID=""  d
    ..s KeyStr="&"_KeyCode_"&"
    ..q:Advice'[KeyStr  
    ..s RLTRowId=0,ResultStr=""
    ..f  s RLTRowId=$o(^DHCPERLT(0,"PAADM_OD",PAADM,DetailID,RLTRowId))  q:RLTRowId=""  d
    ...s Result=$p($g(^DHCPERLT(RLTRowId)),"^",4)
    ...i ResultStr=""  s ResultStr=Result
    ...else  s ResultStr=ResultStr_","_Result
    ..s Advice=##class(web.DHCPE.Public.Setting).Replace(Advice,KeyStr,ResultStr)
    
  q Advice
}

/// debug: d ##class(web.DHCPE.DHCPEExpertDiagnosis).GetKeyReplaceStr("92","2")
ClassMethod GetKeyReplaceStr(PAADM, EDRowID)
{
    //替换关键字
    s Advice=$p($g(^DHCPEED(EDRowID,"Detail")),"^",1)
    q ..ReplactApp(PAADM,Advice)
}

ClassMethod ReplactApp(PAADM, OldInfo)
{
    s Advice=OldInfo
    s Length=$l(Advice,"##")
    s AdviceOld=Advice
    q:Length<2 Advice
    for i=1:1:Length
    { 
    
     s Str=$p(AdviceOld,"##",i)
     s CodeStr=$l(Str,"$$")
     s ResultStr=""
     Continue:CodeStr<2  
     s DetailCode=$p(Str,"$$",1)
     s KeyStr="##"_DetailCode_"$$"
     s STRowId=0
     f  s STRowId=$o(^DHCPEST(0,"OD_Code",DetailCode, STRowId))  q:STRowId=""  d
     .s ODChildSub=0
     .f  s ODChildSub=$o(^DHCPEST(0,"OD_Code",DetailCode, STRowId,ODChildSub))  q:ODChildSub=""  d
     ..s DetailID=STRowId_"||"_ODChildSub
     ..s RLTRowId=0
     ..f  s RLTRowId=$o(^DHCPERLT(0,"PAADM_OD",PAADM,DetailID,RLTRowId))  q:RLTRowId=""  d
     ...s Result=$p(^DHCPERLT(RLTRowId),"^",4)
     ...i ResultStr=""  s ResultStr=Result
     ...else  s ResultStr=ResultStr_","_Result
     i ResultStr'="" d
     .s Advice=##class(web.DHCPE.Public.Setting).Replace(Advice,KeyStr,ResultStr)
     
     }
   
  q Advice
}

ClassMethod GetEDInfo(OEOrdItemID, PAADM, ODStandardID, ChartID, OtherDesc As %String = "")
{
    ;w ##class(web.DHCPE.DHCPEExpertDiagnosis).GetEDInfo("256080||39","273153","1||19","111","gx")
    s Job=$J
    s ArcimID=$P(^OEORD(+OEOrdItemID,"I",$P(OEOrdItemID,"||",2),1),"^",2)
    s CurLoc=$P($G(^PAADM(PAADM)),"^",4)
    s ItemStation=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
    //s RisStation=$G(^DHCPESetting("DHCPE","StationId_Ris"))
    //s LabStation=$G(^DHCPESetting("DHCPE","StationId_Lab"))
    s RisStation=$G(^DHCPESetting("DHCPE","StationId_Ris",CurLoc))
    s LabStation=$G(^DHCPESetting("DHCPE","StationId_Lab",CurLoc))

    s Stations="^"_RisStation_"^"_LabStation_"^"
    i Stations[("^"_ItemStation_"^") d
    .s ODDesc=$P(^ARCIM(+ArcimID,1,1),"^",1)
    e  d
    .s ODDesc=$P(^DHCPEST(+ODStandardID,"OD",$P(ODStandardID,"||",2)),"^",1)
    .s:$L(ODStandardID,"||")>2 ODDesc=$P(^DHCPEST(+ODStandardID,"OD",$P(ODStandardID,"||",2),"ODS",$P(ODStandardID,"||",3)),"^",2)
    
    
    i OtherDesc="" s OtherDesc=ODDesc
    
    //s HospitalCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
    s HospitalCode=$G(^DHCPESetting("DHCPE","HospitalCode",CurLoc))
    s vStationID=""
    If ChartID'="" s vStationID=##class(web.DHCPE.ResultEdit).GetPEStation($g(ChartID))
    i vStationID="" d
    .s vStationID=ItemStation
    s CurUser=%session.Get("LOGON.USERID")
    s str=""
    s EDID=0
    i OtherDesc=""{
        f  s EDID=$o(^DHCPEED(EDID)) q:EDID=""  d
        .d GetOneInfo
    }else{
        s Desc=$ZCVT(OtherDesc,"U")
        b ;Desc
        s RowIds="^"
        s TextDesc=$O(^DHCPEEDA(0,"Alias",Desc),-1)
        f  s TextDesc=$O(^DHCPEEDA(0,"Alias",TextDesc)) Q:(""=TextDesc)||(TextDesc'[Desc)  d
        .s ARowId=0
        .f  s ARowId=$O(^DHCPEEDA(0,"Alias",TextDesc,ARowId)) q:ARowId=""  d
        ..s EDID=$p($g(^DHCPEEDA(ARowId)),"^",1)
        ..q:EDID=""
        ..q:RowIds[("^"_EDID_"^")
        ..s RowIds=RowIds_EDID_"^"
        ..d GetOneInfo
        s TextDesc=$O(^DHCPEED(0,"CODE",Desc),-1)
        f  s TextDesc=$O(^DHCPEED(0,"CODE",TextDesc)) Q:((""=TextDesc)||(TextDesc'[Desc))  d
        .s EDID=0
        .f  s EDID=$O(^DHCPEED(0,"CODE",TextDesc,EDID)) q:EDID=""  d
        ..q:EDID=""
        ..q:RowIds[("^"_EDID_"^")
        ..s RowIds=RowIds_EDID_"^"
        ..d GetOneInfo
        s TextDesc=$O(^DHCPEED(0,"Conclusion",Desc),-1)
        f  s TextDesc=$O(^DHCPEED(0,"Conclusion",TextDesc)) Q:(""=TextDesc)||(TextDesc'[Desc)  d
        .s EDID=0
        .f  s EDID=$O(^DHCPEED(0,"Conclusion",TextDesc,EDID)) q:EDID=""  d
        ..q:EDID=""
        ..q:RowIds[("^"_EDID_"^")
        ..s RowIds=RowIds_EDID_"^"
        ..d GetOneInfo
    }
    d GetStrs
    
    q str
    
GetOneInfo  
    s (Detail,DC,Code)=""
    Set Cancle=0
    s RowId=EDID
    q:RowId=""
    s:$g(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",RowId))'="Y" Cancle=1
    //s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("ED",RowId)         //Add by 090702
    //q:LocFlag=1 
    s Str=##class(web.DHCPE.ResultEdit).GetAgeSex(PAADM)
    s SexID=""
    s SexCode=$p(Str,"^",2)
    i SexCode'=""  s SexID=$o(^CT("SEX",0,"Code",SexCode,0))
    s Sex=$g(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Sex",RowId))
    Quit:(Sex'="")&&(Sex'=SexID)
    s Detail=$P($G(^DHCPEED(RowId,"Detail")),"^",1)
    s DC=$P($G(^DHCPEED(RowId,"1")),"^",1)
    s Code=$P($G(^DHCPEED(RowId,"1")),"^",6)
    s StationID=$P($G(^DHCPEED(RowId,"1")),"^",7)
    s User=$p(^DHCPEED(RowId,1),"^",2)   //Add
    i (vStationID'="")&&(vStationID'=StationID)&&(StationID'="") s Cancle=1 ;&&(("^"_NormalED_"^")'[("^"_RowId_"^"))
    ;b ;Cancle2
    Quit:(Cancle=1)
    s Sort=DC //+$G(^DHCPEED(RowId,"UseCount"))
    s OneInfo=RowId_"^"_Detail_"^"_DC_"^"_Code
    s ^TempDHCPEEDInfo(Job,Sort,RowId)=OneInfo
    q
GetStrs
    s Sort=""
    f  s Sort=$O(^TempDHCPEEDInfo(Job,Sort),-1) q:Sort=""  d
    .s RowID=""
    .f  s RowID=$O(^TempDHCPEEDInfo(Job,Sort,RowID)) q:RowID=""  d
    ..s OneInfo=$G(^TempDHCPEEDInfo(Job,Sort,RowID))
    ..i str="" d
    ...s str=OneInfo
    ..e  d
    ...s str=str_$c(1)_OneInfo
    
    k ^TempDHCPEEDInfo(Job)
    q
}

ClassMethod AutoInsertCondition(EDID, OrdItemID, ODID, OtherDesc As %String = "", RLTID As %String = "")
{
 
    s CurGroup=%session.Get("LOGON.GROUPID")
    s LocID=$p($G(^OEORD(+OrdItemID,"I",$p(OrdItemID,"||",2),1)),"^",3)
    
    //s AuditGroup=$G(^DHCPESetting("DHCPE","SSGroup_SummarizeAudit")) 
    s AuditGroup=$G(^DHCPESetting("DHCPE","SSGroup_SummarizeAudit",LocID)) 
 
    q:AuditGroup'[(","_CurGroup_",") 0 ;"不是总检医生不自动关联" 
    s ODSID=""
    i $L(ODID,"||")=2
    {
        s PAADM=$P(^OEORD(+OrdItemID),"^",1)
        i RLTID="" d
        .s RLTID1=$O(^DHCPERLT(0,"ADMOD",PAADM,OrdItemID,ODID,0))
        .s RLTID2=$O(^DHCPERLT(0,"ADMOD",PAADM,OrdItemID,ODID,""),-1)
        e  d
        .s RLTID1=RLTID
        .s RLTID2=RLTID 
        i (RLTID1'="")&&(RLTID1=RLTID2){
            s RltDesc=$P(^DHCPERLT(RLTID1),"^",4)
            s RltFlag=$P(^DHCPERLT(RLTID1),"^",7) 
            i RltFlag=0{
                s ODType=$P(^DHCPEST(+ODID,"OD",$P(ODID,"||",2)),"^",2) 
                i ODType="S"{ 
                    &SQL(Select ODS_RowId Into :ODSID from DHC_PE_ODStandard Where ODS_Parref=:ODID and ODS_TextVal=:RltDesc)
                    q:ODSID="" 0
                }
                i (ODType="T")&&(OtherDesc'=""){  
                    &SQL(Select ODS_RowId Into :ODSID from DHC_PE_ODStandard Where ODS_Parref=:ODID and ODS_TextVal=:OtherDesc)
                    i ODSID=""{
                        s InString=ODID_"^"_""_"^"_""_"^"_OtherDesc_"^"_""_"^"_"N"_"^"_""_"^"_""_"^"_""_"^"_"N"_"^"_""_"^"_""_"^"_""_"^"_""
                        ;          ODID     RowID   Sub     TextValue  Unit    Sex     Min    Max           Nature  AgeMin  AgeMax  MB
                        s Ret=##class(web.DHCPE.ODStandard).Save("","",InString)
                        s ODSID=%ROWID
                    }
                }
                i (ODType="N")||(ODType="C"){
                    s Range=""
                    //i +ODID=$G(^DHCPESetting("DHCPE","StationId_Lab")){
                    i +ODID=$G(^DHCPESetting("DHCPE","StationId_Lab",LocID)){
                        i $D(^DHCPEDataEx("DHCPEResult",RLTID1,"Ranges")) d
                        .s Range=$G(^DHCPEDataEx("DHCPEResult",RLTID1,"Ranges"))
                    }
                    i Range="" d
                    .Set myStr=##class(web.DHCPE.ResultEdit).GetAgeSex(PAADM)
                    .Set sex=$p(myStr,"^",2)
                    .Set Age=$p(myStr,"^",1)
                    .s Range=##class(web.DHCPE.ResultEdit).GetNormal(ODID,sex,Age)
                    q:Range="" 0
                    s Flag=##class(web.DHCPE.TransResult).GetLabResultArrow(Range, RltDesc)
                    q:Flag=1 0
                    s RangeInfo=..GetRangeInfo(Flag,Range)
                    q:RangeInfo="" 0
                    s TextDesc="偏高"
                    s:Flag=0 TextDesc="偏低"
                    s Min=$P(RangeInfo,"-",1)
                    s Max=$P(RangeInfo,"-",2)
                    &SQL(Select ODS_RowId Into :ODSID from DHC_PE_ODStandard Where ODS_Parref=:ODID and ODS_TextVal=:TextDesc)
                    s Sub="" 
                    s:ODSID'="" Sub=$P(ODSID,"||",3)
                    s InString=ODID_"^"_""_"^"_Sub_"^"_TextDesc_"^"_""_"^"_"N"_"^"_+Min_"^"_+Max_""_"^"_"^"_"N"_"^"_""_"^"_""_"^"_""_"^"_""
                    ;          ODID     RowID   Sub     TextValue  Unit    Sex     Min    Max              Nature  AgeMin  AgeMax  MB
                     
                    s Ret=##class(web.DHCPE.ODStandard).Save("","",InString)
                    s ODSID=%ROWID 
                }
            }
        }
    }
    else
    {
        s ODSID=ODID
    }
    q:ODSID="" 0
    q:$D(^DHCPEED(0,"EDRowId",EDID,ODSID)) 0
    d ..AddCondition(EDID,ODSID)
    q 0
}

ClassMethod GetRangeInfo(Flag, Range)
{
    s RangeInfo=""
    s Range=##class(web.DHCPE.Public.Setting).Replace(Range,"大于等于",">=")
    s Range=##class(web.DHCPE.Public.Setting).Replace(Range,"大于",">")
    s Range=##class(web.DHCPE.Public.Setting).Replace(Range,"≥",">=")
    s Range=##class(web.DHCPE.Public.Setting).Replace(Range,"小于等于","<=")
    s Range=##class(web.DHCPE.Public.Setting).Replace(Range,"小于","<")
    s Range=##class(web.DHCPE.Public.Setting).Replace(Range,"≤","<=")
    i Flag=0 d
    .i $L(Range,">=")>1 d
    ..s RangeInfo=0_"-"_$P(Range,">=",2)
    .e  i $L(Range,">")>1 d
    ..s RangeInfo=0_"-"_$P(Range,">",2)
    .e  i $L(Range,"-")>1 d
    ..s RangeInfo=0_"-"_$P(Range,"-",1)
    i Flag=2 d
    .i $L(Range,"<=")>1 d
    ..s RangeInfo=$P(Range,"<=",2)_"-"_"999999999999"
    .e  i $L(Range,"<")>1 d
    ..s RangeInfo=$P(Range,"<",2)_"-"_"999999999999"
    .e  i $L(Range,"-")>1 d
    ..s RangeInfo=$P(Range,"-",2)_"-"_"999999999999"
    q RangeInfo
}

// ;w ##class(web.DHCPE.DHCPEExpertDiagnosis).UpdateDefaultEDInfo("","","")

ClassMethod UpdateDefaultEDInfo(DefaultEDInfo, DisplayDesc, Result)
{
    s User=%session.Get("LOGON.USERID")
    s Date=+$H
    s Time=$P($H,",",2)
    TSTART
    &sql(Update Sqluser.DHC_PE_ExpertDiagnosis set ED_DiagnoseConclusion=:DisplayDesc,
        ED_Detail=:Result where ED_RowID=:DefaultEDInfo)
    i SQLCODE'=0{
        TROLLBACK
        q SQLCODE
    }
    s obj=##class(User.DHCPETempExpertDiagnosis).%New()
    s obj.TEDDisplayName=DisplayDesc
    s obj.TEDResult=Result
    d obj.TEDAddUserDRSetObjectId(User)
    s obj.TEDAddDate=Date
    s obj.TEDAddTime=Time
    s sc=obj.%Save()
    d obj.%Close()
    If ($System.Status.IsError(sc)) 
    {
        TROLLBACK
        q $System.Status.GetErrorText(sc)
    }
    TCOMMIT
    q 0
}

/// Debug:d ##class(web.DHCPE.DHCPEExpertDiagnosis).GetEDInfoByDesc()
ClassMethod GetEDInfoByDesc(StationID, Desc, OEOrdID As %String = "", StLocID As %String = "")
{
    s ^tempdhcpe("GetEDInfoByDesc")=$lb(StationID, Desc, OEOrdID,StLocID)
    s Job=$J
    k ^TempDHCPEEX(Job)
    if $d(%session) {
        set langId=%session.Get("LOGON.LANGID")
    }
    else
    { s langId=""}
    s AdmLoc=""
    i OEOrdID'="" d
    .i $L(OEOrdID,"||")=2 d
    ..s PAADM=$P($g(^OEORD(+OEOrdID)),"^",1)
    ..s AdmLoc=$P($g(^PAADM(PAADM)),"^",4)
    ..s ArcimID=$P($g(^OEORD(+OEOrdID,"I",$P(OEOrdID,"||",2),1)),"^",2)
    ..;s LocInfo=$g(^DHCPEStationOrder("Loc",ArcimID))
    ..;i LocInfo'="" d
    ..;.s StLocID=$P(LocInfo,"^",1)
    ..s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcimID,AdmLoc)
    ..s StLocID=##class(web.DHCPE.CT.HISUICommon).GetStatCatIDBySTOrderID(StatOrderDR,AdmLoc)
    .e  d
    ..s PAADM=OEOrdID
    ..s AdmLoc=$P($g(^PAADM(PAADM)),"^",4)
    s LocID=##class(web.DHCPE.DHCPECommon).GetEDloc(AdmLoc)
    
    s ret=""
    /*
    s EDID=0
    f  s EDID=$O(^DHCPEED(0,"Conclusion",Desc,EDID)) q:EDID=""  d
    .s activeFlag=$G(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDID))
    .q:activeFlag'="Y"
    .q:'$D(^DHCPEED(0,"EDLOC",LocID,EDID))
    .s CurStation=$P(^DHCPEED(EDID,1),"^",7)
    .//q:CurStation'=StationID
    .s CurStLoc=$P(^DHCPEED(EDID,1),"^",10)
    .q:(StLocID'="")&&(CurStLoc'=StLocID)&&(StLocID'="99999999")
    .s Detail=$P(^DHCPEED(EDID,"Detail"),"^",1)
    .s OneInfo=EDID_"^"_StationID_$C(1)_Detail
    .s Sort=$p(^DHCPEED(EDID,1),"^",9) //+$G(^DHCPEED(RowId,"UseCount"))
    .i Sort="" s Sort="999999999"
    .s ^TempDHCPEEX(Job,Sort,EDID)=OneInfo
    */
    s EDID=0
    f  s EDID=$O(^DHCPEED(0,"Conclusion",Desc,EDID)) q:EDID=""  d
    .q:'$D(^DHCPEED(EDID,1))
    .s LocShowDFlag=##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(EDID,AdmLoc)
    .q:LocShowDFlag'="Y" //过滤不是本科室的建议
    .s EDEffPowerFlag=##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(EDID,AdmLoc)
    .s EDEffPowerFlag=$s(EDEffPowerFlag="Y":"Y",1:"N")
    .q:EDEffPowerFlag'="Y"  //过滤本科室未授权的建议
    .s activeFlag=$p($g(^DHCPEED(EDID,1)),"^",13)
    .s:activeFlag="" activeFlag="Y"
    .q:activeFlag'="Y" //过滤未激活的建议
    .s CurStation=$P($g(^DHCPEED(EDID,1)),"^",7) //站点
    .//q:CurStation'=StationID
    .s CurStLoc=$P($g(^DHCPEED(EDID,1)),"^",10) //分组
    .;q:(StLocID'="")&&(CurStLoc'=StLocID)&&(StLocID'="99999999")
    .s Detail=$P($g(^DHCPEED(EDID,"Detail")),"^",1)
    .s Detail=##class(User.DHCPEExpertDiagnosis).GetTranByDesc("EDDetail",Detail,langId)
    .;s OneInfo=EDID_"^"_StationID_$C(1)_Detail
    .s OneInfo=EDID_"^"_StationID_"^"_StLocID_$C(1)_Detail
    .s Sort=$p($g(^DHCPEED(EDID,1)),"^",9)     //顺序
    .i Sort="" s Sort="999999999"
    .s ^TempDHCPEEX(Job,Sort,EDID)=OneInfo
    s Sort=""
    f  s Sort=$O(^TempDHCPEEX(Job,Sort)) q:Sort=""  d
    .s EDID=""
    .f  s EDID=$O(^TempDHCPEEX(Job,Sort,EDID)) q:EDID=""  d
    ..s OneInfo=$G(^TempDHCPEEX(Job,Sort,EDID))
    ..i ret="" d
    ...s ret=OneInfo
    ..e  d
    ...s ret=ret_$C(2)_OneInfo
    k ^TempDHCPEEX(Job)
    q ret
}

ClassMethod ShowEDInfo(ShowInfo)
{
    s ^DHCPEShowEDInfo(%session.Get("LOGON.USERID"))=ShowInfo
    q 0
}

ClassMethod OutEDInfo(RLTID, OEOrdItemID As %String = "")
{
    i RLTID'="" d
    .s OEOrdItemID=$P(^DHCPERLT(RLTID),"^",9)
    s ArcimID=$P(^OEORD(+OEOrdItemID,"I",$P(OEOrdItemID,"||",2),1),"^",2)
    s ItemStation=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
    s LocInfo=$G(^DHCPEStationOrder("Loc",ArcimID))
    s LocID=$P(LocInfo,"^",1)
    s PAADM=$P(^OEORD(+OEOrdItemID),"^",1)
    d ##class(web.DHCPE.DocPatientFind).OutEDInfo(ItemStation,LocID, PAADM,0)
    q
}

/*
/// w ##class(web.DHCPE.DHCPEExpertDiagnosis).OutEDInfoHISUI("","3240||1")
ClassMethod OutEDInfoHISUI(RLTID, OEOrdItemID As %String = "")
{
    i RLTID'="" d
    .s OEOrdItemID=$P(^DHCPERLT(RLTID),"^",9)
    s ArcimID=$P(^OEORD(+OEOrdItemID,"I",$P(OEOrdItemID,"||",2),1),"^",2)
    s ItemStation=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
    s LocInfo=$G(^DHCPEStationOrder("Loc",ArcimID))
    s LocID=$P(LocInfo,"^",1)
    s PAADM=$P(^OEORD(+OEOrdItemID),"^",1)
    s ret=##class(web.DHCPE.DocPatientFind).OutEDInfoHISUI(ItemStation,LocID, PAADM,0)
    q ret
}
*/
/// Description: 获取站点或分类建议（多院区）
/// Debug:  w ##class(web.DHCPE.DHCPEExpertDiagnosis).OutEDInfoHISUI("","3240||1")
ClassMethod OutEDInfoHISUI(RLTID, OEOrdItemID As %String = "")
{
    s ^tempdhcpe("OutEDInfoHISUI")=$lb(RLTID,OEOrdItemID)
    
    i RLTID'="" s OEOrdItemID=$P($g(^DHCPERLT(RLTID)),"^",9)
    i OEOrdItemID'="" s ADMLocID=$p($g(^OEORD(+OEOrdItemID,"I",$p(OEOrdItemID,"||",2),1)),"^",3)
    s ArcimID=$P($g(^OEORD(+OEOrdItemID,"I",$P(OEOrdItemID,"||",2),1)),"^",2)
    s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcimID,ADMLocID)
    s ItemStation=$p(StatOrderDR,"||",1)      //站点ID
    s LocID=##class(web.DHCPE.CT.HISUICommon).GetStatCatIDBySTOrderID(StatOrderDR,ADMLocID) //获取站点分类ID
    s PAADM=$P($g(^OEORD(+OEOrdItemID)),"^",1)
    s ret=##class(web.DHCPE.DocPatientFind).OutEDInfoHISUI(ItemStation,LocID,PAADM,0)
    q ret
}

ClassMethod OutEDInfobyPrefix(RLTID, OEOrdItemID As %String = "", Prefix As %String = "")
{
    i RLTID'="" d
    .s OEOrdItemID=$P(^DHCPERLT(RLTID),"^",9)
    s ArcimID=$P(^OEORD(+OEOrdItemID,"I",$P(OEOrdItemID,"||",2),1),"^",2)
    s ItemStation=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
    s LocInfo=$G(^DHCPEStationOrder("Loc",ArcimID))
    s LocID=$P(LocInfo,"^",1)
    s PAADM=$P(^OEORD(+OEOrdItemID),"^",1)
    s ret= ##class(web.DHCPE.DocPatientFind).OutEDInfobyPrefix(ItemStation,LocID, PAADM,0,Prefix)  //见录入文档
    q ret
}

}
