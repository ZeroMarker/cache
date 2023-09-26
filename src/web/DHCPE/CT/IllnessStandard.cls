Import SQLuser

/// 名称: 疾病维护-多院区
/// 编写者：yupeng
/// 编写日期: 2021-08-14
Class web.DHCPE.CT.IllnessStandard Extends %RegisteredObject [ Not ProcedureBlock ]
{

Query EDCondition(ParrefRowId As %Library.String = "", EDID As %Library.String = "", NoActiveFlag As %String = "N", tableName As %String, LocID As %String) As websys.Query(ROWSPEC = "TRowID:%String,TILLNessID:%String,TILLNessDesc:%String,TEDID:%String,TEDDesc:%String,TEDDetail:%String,TEDCode:%String,TEmpower:%String,TEffPowerFlag,TNoActive,TUpdateDate,TUpdateTime,TUserName")
{
}

ClassMethod EDConditionExecute(ByRef qHandle As %Binary, ParrefRowId As %String = "", EDID As %Library.String = "", NoActiveFlag As %String = "N", tableName As %String, LocID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    
    i ParrefRowId'="" d
    .s IDRID=0
    .f  s IDRID=$o(^DHCPEIDR(0,"ILLSDR",ParrefRowId,IDRID)) q:IDRID=""  d
    ..d GetOneDetail
    e  i EDID'="" d
    .s IDRID=0
    .f  s IDRID=$o(^DHCPEIDR(0,"EDDR",EDID,IDRID)) q:IDRID=""  d
    ..d GetOneDetail
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    q 
GetOneDetail
    s ILLDR=$p($g(^DHCPEIDR(IDRID)),"^",2)
    q:ILLDR=""
    s ILLDesc=$p($g(^DHCPEILLS(ILLDR)),"^",2)
    s EDDR=$p(^DHCPEIDR(IDRID),"^",1)
    q:'$d(^DHCPEED(EDDR))
    s EDDesc=$p($g(^DHCPEED(EDDR,1)),"^",1)
    s EDCode=$p($g(^DHCPEED(EDDR,1)),"^",6)
    s EDDetail=$p($g(^DHCPEED(EDDR,"Detail")),"^",1)
    
    s LocShowDFlag=##class(User.DHCPEIDRelate).GetLocShowDataFlag(IDRID,LocID)
    q:LocShowDFlag="N"
    s EmpowerStr=##class(User.DHCPEIDRelate).GetEmpowerFlag(IDRID,LocID)
    s Empower=$p(EmpowerStr,"^",2)
    s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    s NoActive=$p($g(^DHCPEIDR(IDRID)),"^",3)
    i NoActive="" s NoActive="N"
    ;q:(NoActiveFlag'=NoActive)
    
    s UpdateDate=$p($g(^DHCPEIDR(IDRID)),"^",4)
    i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    s UpdateTime=$p($g(^DHCPEIDR(IDRID)),"^",5)
    i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
    s UserDR=$p($g(^DHCPEIDR(IDRID)),"^",6)
    i UserDR'="" s UserName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
    
    d Build
    q
Build
	;d TranslateEDCondition
    set Data=$lb(IDRID,ILLDR,ILLDesc,EDDR,EDDesc,EDDetail,EDCode,Empower,EffPowerFlag,NoActive,UpdateDate,UpdateTime,UserName)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
TranslateEDCondition
	s ILLDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEIllnessStandard",ILLDesc,"ILLSDesc","cls")
	s EDDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEExpertDiagnosis",EDDesc,"EDDiagnoseConclusion","cls")
	s EDDetail=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEExpertDiagnosis",EDDetail,"EDDetail","cls")
	s UserName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",UserName,"SSUSRName","cls")
}

/// Dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.IllnessStandard","FindIllExplain","","","N","DHC_PE_EDKey","152")
Query FindIllExplain(ILLSRowID As %String, NoActiveFlag As %String = "N", tableName As %String, LocID As %String, Type As %String) As websys.Query(ROWSPEC = "TRowID:%String,IllID,Explain:%String,TEmpower:%String,TEffPowerFlag,TNoActive,TUpdateDate,TUpdateTime,TUserName")
{
}

ClassMethod FindIllExplainExecute(ByRef qHandle As %Binary, ILLSRowID As %String, NoActiveFlag As %String = "N", tableName As %String, LocID As %String, Type As %String) As %Status
{
    s ^tempdhcpe("FindIllExplain")=$lb(ILLSRowID,NoActiveFlag,tableName,LocID,Type)
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
   
    if (Type=1)
    {
    s id=0
    f  s id=$O(^CF.PE.ILLSExplainD(id)) q:id=""  d
    .s IllID=$lg(^CF.PE.ILLSExplainD(id),2)
    .q:ILLSRowID'=IllID
    .s Explain=$lg(^CF.PE.ILLSExplainD(id),3)
    .s LocShowDFlag=##class(User.DHCPEILLSExplain).GetLocShowDataFlag(id,LocID)
    .q:LocShowDFlag="N"
    .s EmpowerStr=##class(User.DHCPEILLSExplain).GetEmpowerFlag(id,LocID)
    .s Empower=$p(EmpowerStr,"^",2)
    .s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    .s NoActive=$lg(^CF.PE.ILLSExplainD(id),4)
    .i NoActive="" s NoActive="Y"
    .;q:(NoActiveFlag'=NoActive)
    .s UpdateDate=$lg(^CF.PE.ILLSExplainD(id),5)
    .i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    .s UpdateTime=$lg(^CF.PE.ILLSExplainD(id),6)
    .i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
    .s UserDR=$lg(^CF.PE.ILLSExplainD(id),7)
    .i UserDR'="" s UserName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
    .;d TranslateFindIllExplain
    .s ^CacheTemp(repid,ind)=$lb(id,IllID,Explain,Empower,EffPowerFlag,NoActive,UpdateDate,UpdateTime,UserName)
    .s ind=ind+1
    }
    if (Type=2)
    {
    s id=0
    f  s id=$O(^CF.PE.ILLSSportGuideD(id)) q:id=""  d
    .s IllID=$lg(^CF.PE.ILLSSportGuideD(id),2)
    .q:ILLSRowID'=IllID
    .s Explain=$lg(^CF.PE.ILLSSportGuideD(id),3)
    .s LocShowDFlag=##class(User.DHCPEILLSSportGuide).GetLocShowDataFlag(id,LocID)
    .q:LocShowDFlag="N"
    .s EmpowerStr=##class(User.DHCPEILLSSportGuide).GetEmpowerFlag(id,LocID)
    .s Empower=$p(EmpowerStr,"^",2)
    .s EmpowerLoc=$p(EmpowerStr,"^",3)
    .s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    .s NoActive=$lg(^CF.PE.ILLSSportGuideD(id),4)
    .i NoActive="" s NoActive="Y"
    .;q:(NoActiveFlag'=NoActive)
    .s UpdateDate=$lg(^CF.PE.ILLSSportGuideD(id),5)
    .i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    .s UpdateTime=$lg(^CF.PE.ILLSSportGuideD(id),6)
    .i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
    .s UserDR=$lg(^CF.PE.ILLSSportGuideD(id),7)
    .i UserDR'="" s UserName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
    .;d TranslateFindIllExplain
    .s ^CacheTemp(repid,ind)=$lb(id,IllID,Explain,Empower,EffPowerFlag,NoActive,UpdateDate,UpdateTime,UserName)
    .s ind=ind+1
    }
    if (Type=3)
    {
    s id=0
    f  s id=$O(^CF.PE.ILLSDietGuideD(id)) q:id=""  d
    .s IllID=$lg(^CF.PE.ILLSDietGuideD(id),2)
    .q:ILLSRowID'=IllID
    .s Explain=$lg(^CF.PE.ILLSDietGuideD(id),3)
    .s LocShowDFlag=##class(User.DHCPEILLSDietGuide).GetLocShowDataFlag(id,LocID)
    .q:LocShowDFlag="N"
    .s EmpowerStr=##class(User.DHCPEILLSDietGuide).GetEmpowerFlag(id,LocID)
    .s Empower=$p(EmpowerStr,"^",2)
    .s EmpowerLoc=$p(EmpowerStr,"^",3)
    .s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    .s NoActive=$lg(^CF.PE.ILLSDietGuideD(id),4)
    .i NoActive="" s NoActive="Y"
    .;q:(NoActiveFlag'=NoActive)
    .s UpdateDate=$lg(^CF.PE.ILLSDietGuideD(id),5)
    .i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    .s UpdateTime=$lg(^CF.PE.ILLSDietGuideD(id),6)
    .i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
    .s UserDR=$lg(^CF.PE.ILLSDietGuideD(id),7)
    .i UserDR'="" s UserName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
    .;d TranslateFindIllExplain
    .s ^CacheTemp(repid,ind)=$lb(id,IllID,Explain,Empower,EffPowerFlag,NoActive,UpdateDate,UpdateTime,UserName)
    .s ind=ind+1
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
TranslateFindIllExplain
	s:Type=1 Explain=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEILLSExplain",Explain,"IEIllExplain","cls")
	s:Type=2 Explain=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEILLSSportGuide",Explain,"ISGSportGuide","cls")
	s:Type=3 Explain=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEILLSDietGuide",Explain,"IDGDietGuide","cls")
	s UserName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",UserName,"SSUSRName","cls")
}

ClassMethod GetTypeDesc(Type)
{
    q:Type="1" "团体报告"
    q:Type="2" "妇科统计"
    q:Type="3" "阳性统计"
    
    q ""
}

/// function :通过疾病获取疾病别名
/// debug:d ##class(web.DHCPE.CT.IllnessStandard).GetAliasByEDID()
ClassMethod GetAliasByEDID(EDRowID As %Library.String = "")
{
    q:EDRowID="" ""
    s DescStr=""
    S id=""
    f  s id=$o(^DHCPEILLSA(id)) q:(id="")  d
    .S ILLSID=$P($G(^DHCPEILLSA(id)),"^",1)
    .Q:EDRowID'=ILLSID
    .s Desc=$P($G(^DHCPEILLSA(id)),"^",2)
    .;s Desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEILLSAlias",Desc,"ILLSAText","cls")
    .i DescStr="" s DescStr=Desc
    .e  s DescStr=DescStr_","_Desc
    q DescStr
}

/// / Creator：   xy 
/// CreatDate：  20211203
/// Description: 查询疾病(业务使用数据，只有授权的科室才显示)
/// Table：       疾病表 DHC_PE_IllnessStandard
/// Input:       Desc(疾病别名、描述),LocID (科室ID),NoActiveFlag(激活标记)
/// Dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.IllnessStandard","GetIllByAlias","","105")
Query GetIllByAlias(Desc As %Library.String = "", LocID As %Library.String = "", NoActiveFlag = "Y") As websys.Query(ROWSPEC = "HIDDEN:%String, Detail:%String:疾病名称, DiagnoseConclusion:%String:疾病建议, Code:%String:编码")
{
}

ClassMethod GetIllByAliasExecute(ByRef qHandle As %Binary, Desc As %String = "", LocID As %Library.String = "", NoActiveFlag = "Y") As %Status
{
    s ^tempdhcpe("GetIllByAlias")=$lb(Desc,LocID,NoActiveFlag)
    Set repid=$I(^CacheTemp)
    s Desc=$ZCVT(Desc,"U")
    s CurUser=%session.Get("LOGON.USERID")
    if $d(%session) {
        set langId=%session.Get("LOGON.LANGID")
    }
    else
    { s langId=""}
    s ind=1
    i Desc=""
    {
        s EDID=0
        f  s EDID=$o(^DHCPEILLS(EDID)) q:EDID=""  d
        .s RowId=EDID
        .s User=$p(^DHCPEILLS(EDID),"^",4)
        .;q:(User'="")&&(User'=CurUser)
        .d GetIllByAlias
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
        ..s User=$p($g(^DHCPEILLS(RowId)),"^",4)
        ..q:(User'="")&&(User'=CurUser)
        ..d GetIllByAlias
        
        s TextDesc=$O(^DHCPEILLS(0,"CODE",Desc),-1)
        f  s TextDesc=$O(^DHCPEILLS(0,"CODE",TextDesc)) Q:((""=TextDesc)||(TextDesc'[Desc))  d
        .s RowId=0
        .f  s RowId=$O(^DHCPEILLS(0,"CODE",TextDesc,RowId)) q:RowId=""  d
        ..q:RowId=""
        ..q:RowIds[("^"_RowId_"^")
        ..s RowIds=RowIds_RowId_"^"
        ..s User=$p($g(^DHCPEILLS(RowId)),"^",4)
        ..q:(User'="")&&(User'=CurUser)
        ..d GetIllByAlias
        
        s TextDesc=$O(^DHCPEILLS(0,"Desc",Desc),-1)
        f  s TextDesc=$O(^DHCPEILLS(0,"Desc",TextDesc)) Q:(""=TextDesc)||(TextDesc'[Desc)  d
        .s RowId=0
        .f  s RowId=$O(^DHCPEILLS(0,"Desc",TextDesc,RowId)) q:RowId=""  d
        ..q:RowId=""
        ..q:RowIds[("^"_RowId_"^")
        ..s RowIds=RowIds_RowId_"^"
        ..s User=$p($g(^DHCPEILLS(RowId)),"^",4)
        ..q:(User'="")&&(User'=CurUser)
        ..d GetIllByAlias
        
    }
   
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
GetIllByAlias
    s (Detail,DC,Code)=""
    q:RowId=""
    s Detail=$P($G(^DHCPEILLS(RowId)),"^",3)
    s NoActive=$P($G(^DHCPEILLS(RowId)),"^",12)
    i NoActive=""  s NoActive="Y"
    q:(NoActiveFlag'=NoActive)
    s LocShowDFlag=##class(User.DHCPEIllnessStandard).GetLocShowDataFlag(RowId,LocID)
    q:LocShowDFlag'="Y"  //过滤科室未授权的疾病
    s DC=$P($G(^DHCPEILLS(RowId)),"^",2)
    s DC=##class(User.DHCPEIllnessStandard).GetTranByDesc("ILLSDesc",DC,langId)
    
    s Code=$P($G(^DHCPEILLS(RowId)),"^",1)
    d SetDataILL
    q
    
SetDataILL
    set Data=$lb(RowId, DC, Detail, Code)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// Description: 查询疾病(维护数据，所有数据都显示)
/// Table：      疾病表 DHC_PE_IllnessStandard
/// Input:       Code(疾病编码), DiagnoseConclusion(疾病描述),Alias(疾病别名), NoActiveFlag(激活),LocID (科室ID)
/// Dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.IllnessStandard","QueryIll","","","","N","DHC_PE_IllnessStandard","152")
Query QueryIll(Code As %Library.String = "", DiagnoseConclusion As %Library.String = "", Alias As %Library.String = "", NoActiveFlag As %String = "N", tableName As %String, LocID As %String) As websys.Query(ROWSPEC = "ED_RowId:%String, ED_Detail:%String, ED_DiagnoseConclusion:%String, ED_Code:%String,ED_Illness:%String,ED_CommonIllness:%String,TToReport:%String,TSex:%String,TType:%String,AliasDesc:%String,Empower,EmpowerLoc,NoActive,UpdateDate,UpdateTime,UserName,Empower,TEffPowerFlag")
{
}

ClassMethod QueryIllExecute(ByRef qHandle As %Binary, Code As %Library.String = "", DiagnoseConclusion As %Library.String = "", Alias As %Library.String = "", NoActiveFlag As %String = "N", tableName As %String, LocID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s Code=$ZCVT(Code,"U")
    s DiagnoseConclusion=$ZCVT(DiagnoseConclusion,"U")
    s Alias=$ZCVT(Alias,"U")
    
    
    s ind=1
    i Alias=""
    {
        s EDID=0
        f  s EDID=$o(^DHCPEILLS(EDID)) q:EDID=""  d
        .s RowId=EDID
        .s User=$p(^DHCPEILLS(EDID),"^",4)
        .d SetDataQueryIll
    }
    else
    {
        s RowIds="^"
        s TextDesc=Alias
        s TextDesc=$O(^DHCPEILLSA(0,"Alias",Alias),-1)
        f  s TextDesc=$O(^DHCPEILLSA(0,"Alias",TextDesc)) Q:(""=TextDesc)||(TextDesc'[Alias)  d
        .s ARowId=0
        .f  s ARowId=$O(^DHCPEILLSA(0,"Alias",TextDesc,ARowId)) q:ARowId=""  d
        ..s RowId=$p($g(^DHCPEILLSA(ARowId)),"^",1)
        ..q:RowId=""
        ..q:RowIds[("^"_RowId_"^")
        ..s RowIds=RowIds_RowId_"^"
        ..d SetDataQueryIll
    }
   
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
SetDataQueryIll
    s (Detail,DC,UCode,Illness,CommonIllness,AliasDesc)=""
    q:RowId=""
    s EDAliaID=0
    s LocShowDFlag=##class(User.DHCPEIllnessStandard).GetLocShowDataFlag(RowId,LocID)
    q:LocShowDFlag="N"
    s EmpowerStr=##class(User.DHCPEIllnessStandard).GetEmpowerFlag(RowId,LocID)
    s Empower=$p(EmpowerStr,"^",2)
    //s EmpowerLoc=$p(EmpowerStr,"^",3)
    s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    s DC=$P($G(^DHCPEILLS(RowId)),"^",3)
    s Detail=$P($G(^DHCPEILLS(RowId)),"^",2)
    s UDC=$ZCVT(Detail,"U")
    q:UDC'[DiagnoseConclusion
    s CCode=$P($G(^DHCPEILLS(RowId)),"^",1)
    s UCode=$ZCVT(CCode,"U")
    q:UCode'[Code
    s Illness=$P($G(^DHCPEILLS(RowId)),"^",6)
    s CommonIllness=$P($G(^DHCPEILLS(RowId)),"^",7)
    i CommonIllness="Y" S CommonIllness="是"
    e  s CommonIllness="否"
    s ToReport=$P($G(^DHCPEILLS(RowId)),"^",8)
    s Sex=$P($G(^DHCPEILLS(RowId)),"^",9)
    s Sex=$S(Sex="F":"女",Sex="M":"男",Sex="N":"不限",Sex="":"")
    s Type=$P($G(^DHCPEILLS(RowId)),"^",11)
    s Type=..GetTypeDesc(Type)
    s AliasDesc=..GetAliasByEDID(RowId)
    s NoActive=$P($G(^DHCPEILLS(RowId)),"^",12)
    i NoActive="" s NoActive="Y"
    q:(NoActiveFlag'=NoActive)
    s UpdateDate=$P($G(^DHCPEILLS(RowId)),"^",5)
    i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    s UpdateTime=$P($G(^DHCPEILLS(RowId)),"^",13)
    i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
    s UserDR=$P($G(^DHCPEILLS(RowId)),"^",4)
    i UserDR'="" s UserName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
    d QueryIll
    q  
QueryIll    
	;d TranslateQueryIll
    set Data=$lb(RowId, DC, Detail, CCode,Illness,CommonIllness,ToReport,Sex,Type,AliasDesc,Empower,EmpowerLoc,NoActive,UpdateDate,UpdateTime,UserName,Empower,EffPowerFlag)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
TranslateQueryIll
	s Detail=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEIllnessStandard",Detail,"ILLSDesc","cls")
	s DC=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEIllnessStandard",DC,"ILLSDetail","cls")
	s UserName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",UserName,"SSUSRName","cls")
	
	s Type=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.illnessstandard.csp",Type)
	s CommonIllness=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.illnessstandard.csp",CommonIllness)
	s Sex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.illnessstandard.csp",Sex)
}

ClassMethod InitIll(EDRowId As %Library.String = "")
{
    s IllStr=$g(^DHCPEILLS(EDRowId))
    q IllStr
}

/// w ##class(web.DHCPE.CT.IllnessStandard).UpdateAlias("^30^gjy","0","DHC_PE_ILLSAlias","12187","152")
ClassMethod UpdateAlias(DataStr As %String, isDelete As %String, AliasTableName As %String, AliasUserID As %String, AliasLocID As %String)
{
    
    s ^tempdhcpeillalias("Update")=$lb(DataStr, isDelete, AliasTableName, AliasUserID, AliasLocID)
    s SQLCODE=0,result=0
    s $ZT="UpdateAliasErr"
    if (isDelete=1)
    {
        s RowId=$p(DataStr,"^",1)
        &SQL(delete from sqluser.DHC_PE_ILLSAlias where ILLSA_RowId=:RowId)
    }
    else
    {
        s RowId=$p(DataStr,"^",1)
        s PLIST(2)=$p(DataStr,"^",2)
        s PLIST(3)=$p(DataStr,"^",3)
        i RowId=""
        {
            &SQL(insert into sqluser.DHC_PE_ILLSAlias values :PLIST())
            s aliasid=%ROWID
            s ret=##class(User.DHCPEILLSAlias).SaveDataToPowerControl(aliasid,AliasLocID,AliasUserID,"N")
            //表记录授权插入数据失败
            If ($p(ret,"^",1)="-1")  
            { 
                s result="-1^插入疾病别名授权表失败"
                goto UpdateAliasErr
            }   
            
        }
        else
        {
            &SQL(update sqluser.DHC_PE_ILLSAlias values :PLIST() where ILLSA_RowId=:RowId)
        }
  
    }
    q SQLCODE
    
UpdateAliasErr
    s $zt=""
    q result_$ZE
}

/// Creator：    xueying
/// CreatDate：  20220423
/// Description: 判断科室组下是否有重复的疾病
/// Table：      疾病表 User.DHCPEIllnessStandard
/// Input:       Desc(疾病描述),LocID(科室下拉列表值),CurID：当前疾病的ID             
/// Return：     0/1(无/有)
/// Dubug： w ##class(web.DHCPE.CT.IllnessStandard).IsExsistILL("前列腺超声：前列腺结石",105,1)
ClassMethod IsExsistILL(CurILLDesc As %String, LocID As %String, CurID As %String)
{
   s flag=0
   s ILLID=0
   f  s ILLID=$o(^DHCPEILLS(ILLID)) q:(ILLID="")||(flag=1)  d
   .s LocShowDFlag=##class(User.DHCPEIllnessStandard).GetLocShowDataFlag(ILLID,LocID)
   .q:LocShowDFlag="N"
   .s ILLDesc=$P($G(^DHCPEILLS(ILLID)),"^",2)
   .s:(ILLDesc=CurILLDesc)&&(CurID="") flag=1
   .s:(ILLDesc=CurILLDesc)&&(CurID'=ILLID)&&(CurID'="") flag=1
   q flag
}

/// w ##class(web.DHCPE.CT.IllnessStandard).UpdateIll("24^00000016^肾功能异常^建议肾内科就诊^N^Y^12187^^^0^F^1^N","152")
/// w ##class(web.DHCPE.CT.IllnessStandard).UpdateIll("1^0050^前列腺超声：前列腺结石^前列腺结石的病因尚不十分明确，一般认为和前列腺液成分的改变，年龄老化和局部感染等因素有关。建议您去泌尿外科门诊复查或进一步检查。^N^N^18853^^^0^M^3^Y","105")
ClassMethod UpdateIll(InString As %String, LocID As %String)
{
    
    s ^tempdhcpeill("Update")=$lb(InString,LocID)
    
    s $ZT="UpdateErr"
    s IllId=$P(InString,"^",1)
    s ILLSCode=$P(InString,"^",2)
    s ILLSDesc=$P(InString,"^",3)
    s ILLSDetail=$P(InString,"^",4)
    s ILLSIllness=$P(InString,"^",5)
    s ILLSCommonIllness=$P(InString,"^",6)
    s ILLSUserUpdate=$P(InString,"^",7)
    s IllAlias=$P(InString,"^",9)
    s ILLSToReport=$P(InString,"^",10)
    s ILLSSex=$P(InString,"^",11)
    s ILLSType=$P(InString,"^",12)
    s ILLSNoActive=$P(InString,"^",13)
   	
   	s TypeNew=$p(InString,"^",14) //TypeNew
	s ILLSStation=$p(InString,"^",15) 
	s FatherIll=$p(InString,"^",16) 
	s note=$p(InString,"^",17) 
	s compare=$p(InString,"^",18) 
	
   
    s Empower="N"
    s DateUpdate=+$h
    s TimeUpdate=$p($h,",",2)  
    s SQLCODE=0
    
    TSTART
    i IllId="" d
    .s obj=##class(User.DHCPEIllnessStandard).%New()
    e  d
    .s obj=##class(User.DHCPEIllnessStandard).%OpenId(IllId)
    
    s obj.ILLSCode=ILLSCode
    s obj.ILLSDesc=ILLSDesc
    s obj.ILLSDetail=ILLSDetail
    s obj.ILLSUserUpdateDR=ILLSUserUpdate
    s obj.ILLSUpdateDate=DateUpdate
    s obj.ILLSIllness=ILLSIllness
    s obj.ILLSCommonIllness=ILLSCommonIllness
    s obj.ILLSToReport=ILLSToReport
    s obj.ILLSSex=ILLSSex
    s obj.ILLSType=ILLSType
    s obj.ILLSNoActive=ILLSNoActive
    s obj.ILLSTimeUpdate=TimeUpdate
    s obj.ILLSTypeNew=TypeNew
    s obj.ILLSStation=ILLSStation
    s obj.ILLSFatherIll=FatherIll
    s obj.ILLSNote=note
    s obj.ILLSIfCompare=compare
    
    s sc=obj.%Save()
    d obj.%Close()
    
    If ($System.Status.IsError(sc)) 
    {
        s result="-1^更新疾病失败:"_$System.Status.GetErrorText(sc)
        goto UpdateErr
    }
   
    else
    {
        s IllRowId=obj.%Id()
        if (IllId="")
        {
            s ret=##class(User.DHCPEIllnessStandard).SaveDataToPowerControl(IllRowId,LocID,ILLSUserUpdate,Empower)
            //表记录授权插入数据失败
            If ($p(ret,"^",1)="-1")  
            { 
                s result="-1^插入疾病授权表失败"
                goto UpdateErr
            }
        }
      
        
        i IllAlias'=""
        {
            s Strings="^"_IllRowId_"^"_IllAlias
            s SQLCODE=..UpdateAlias(Strings,"0","DHC_PE_ILLSAlias",ILLSUserUpdate,LocID)
            i SQLCODE
            {
                s result="-1^更新疾病别名失败"
                goto UpdateErr
            }
        }
        
     }
   
   TCommit
   
   s result="0^插入成功"
   q result  
   
UpdateErr
    s $zt=""
    TROLLBACK 
    q result_$ZE
}

/// w ##class(web.DHCPE.CT.IllnessStandard).UpdateIDR("154^1^29^Y","DHC_PE_IDRelate","12187","152","N")
ClassMethod UpdateIDR(InString As %String, TableName As %String, UserID As %String, LocID As %String, Empower As %String = "N")
{
    s ^tempdhcpeillrelate("Update")=$lb(InString,TableName,UserID,LocID,Empower)
    s SQLCODE=0,result=0
    s $ZT="UpdateRelateErr"
    s RowId=$p(InString,"^",1)
    s EDDR=$p(InString,"^",2)
    s ILLDR=$p(InString,"^",3)
    s NoActive=$p(InString,"^",4)
    s DateUpdate=+$h
    s TimeUpdate=$p($h,",",2) 
    
    
        i RowId="" d
        .s obj=##class(User.DHCPEIDRelate).%New()
        e  d
        .s obj=##class(User.DHCPEIDRelate).%OpenId(RowId)
        
        d obj.IDREDDRSetObjectId(EDDR)
        d obj.IDRILLSDRSetObjectId(ILLDR)
        s obj.IDRNoActive=NoActive
        s obj.IDRUpdateDate=DateUpdate
        s obj.IDRUpdateTime=TimeUpdate
        s obj.IDRUpdateUserDR=UserID
        
        s sc=obj.%Save()
        d obj.%Close()
    
        If ($System.Status.IsError(sc)) 
        {
            s result="-1^更新疾病关联失败:"_$System.Status.GetErrorText(sc)
            goto UpdateRelateErr
        }
   
        else
        {
            
            s RelateRowId=obj.%Id()
            
            s ret=##class(User.DHCPEIDRelate).SaveDataToPowerControl(RelateRowId,LocID,UserID,Empower)
            //表记录授权插入数据失败
            If ($p(ret,"^",1)="-1")  
            { 
                s result="-1^插入疾病关联授权表失败"
                goto UpdateRelateErr
            }
          
       
        }
        
        
        
   s result="0^插入成功"
   q result  
   
UpdateRelateErr
    s $zt=""
    q result_$ZE
}

/// w ##class(web.DHCPE.CT.IllnessStandard).UpdateExplain("^24^测试2^N","DHC_PE_ILLSExplain","12187","152","N")
ClassMethod UpdateExplain(DataStr As %String, TableName As %String, UserID As %String, LocID As %String, Empower As %String = "N", Type As %String = "1")
{
    
    s ^tempdhcpeillexplain("Update")=$lb(DataStr,TableName,UserID,LocID,Empower)
    s SQLCODE=0,result=0
    s $ZT="UpdateExplainErr"
    
        s RowId=$p(DataStr,"^",1)
        s ILLSDR=$p(DataStr,"^",2)
        s IllExplain=$p(DataStr,"^",3)
        s NoActive=$p(DataStr,"^",4)
        s DateUpdate=+$h
        s TimeUpdate=$p($h,",",2) 
        
        if (Type=1)
        {
        i RowId="" d
        .s obj=##class(User.DHCPEILLSExplain).%New()
        e  d
        .s obj=##class(User.DHCPEILLSExplain).%OpenId(RowId)
        
        d obj.IEILLSDRSetObjectId(ILLSDR)
        s obj.IEIllExplain=IllExplain
        s obj.IENoActive=NoActive
        s obj.IEUpdateDate=DateUpdate
        s obj.IEUpdateTime=TimeUpdate
        s obj.IEUpdateUserDR=UserID
        
        s sc=obj.%Save()
        d obj.%Close()
    
        If ($System.Status.IsError(sc)) 
        {
            s result="-1^更新疾病解释失败:"_$System.Status.GetErrorText(sc)
            goto UpdateExplainErr
        }
   
        else
        {
            
            s ExplainRowId=obj.%Id()
            
            s ret=##class(User.DHCPEILLSExplain).SaveDataToPowerControl(ExplainRowId,LocID,UserID,Empower)
            //表记录授权插入数据失败
            If ($p(ret,"^",1)="-1")  
            { 
                s result="-1^插入疾病解释授权表失败"
                goto UpdateExplainErr
            }
          
       
        }
        }
        
        
        
        
        if (Type=2)
        {
        i RowId="" d
        .s obj=##class(User.DHCPEILLSSportGuide).%New()
        e  d
        .s obj=##class(User.DHCPEILLSSportGuide).%OpenId(RowId)
        
        d obj.ISGILLSDRSetObjectId(ILLSDR)
        s obj.ISGSportGuide=IllExplain
        s obj.ISGNoActive=NoActive
        s obj.ISGUpdateDate=DateUpdate
        s obj.ISGUpdateTime=TimeUpdate
        s obj.ISGUpdateUserDR=UserID
        
        s sc=obj.%Save()
        d obj.%Close()
    
        If ($System.Status.IsError(sc)) 
        {
            s result="-1^更新运动指导失败:"_$System.Status.GetErrorText(sc)
            goto UpdateExplainErr
        }
   
        else
        {
            
            s ExplainRowId=obj.%Id()
            
            s ret=##class(User.DHCPEILLSSportGuide).SaveDataToPowerControl(ExplainRowId,LocID,UserID,Empower)
            //表记录授权插入数据失败
            If ($p(ret,"^",1)="-1")  
            { 
                s result="-1^插入运动指导授权表失败"
                goto UpdateExplainErr
            }
          
       
        }
        }
        
        if (Type=3)
        {
        i RowId="" d
        .s obj=##class(User.DHCPEILLSDietGuide).%New()
        e  d
        .s obj=##class(User.DHCPEILLSDietGuide).%OpenId(RowId)
        
        d obj.IDGILLSDRSetObjectId(ILLSDR)
        s obj.IDGDietGuide=IllExplain
        s obj.IDGNoActive=NoActive
        s obj.IDGUpdateDate=DateUpdate
        s obj.IDGUpdateTime=TimeUpdate
        s obj.IDGUpdateUserDR=UserID
        
        s sc=obj.%Save()
        d obj.%Close()
    
        If ($System.Status.IsError(sc)) 
        {
            s result="-1^更新饮食指导失败:"_$System.Status.GetErrorText(sc)
            goto UpdateExplainErr
        }
   
        else
        {
            
            s ExplainRowId=obj.%Id()
            
            s ret=##class(User.DHCPEILLSDietGuide).SaveDataToPowerControl(ExplainRowId,LocID,UserID,Empower)
            //表记录授权插入数据失败
            If ($p(ret,"^",1)="-1")  
            { 
                s result="-1^插入饮食指导授权表失败"
                goto UpdateExplainErr
            }
        }
        }
          
    s result="0^插入成功"
    q result 
    
UpdateExplainErr
    s $zt=""
    q result_$ZE
}

/// w ##class(web.DHCPE.CT.IllnessStandard).UpdateItem("^24^测试2^N","DHC_PE_ILLSExplain","12187","152","N")
ClassMethod UpdateItem(DataStr As %String, TableName As %String, UserID As %String, LocID As %String, Empower As %String = "N")
{
    
    s ^tempdhcpeillexplain("Update")=$lb(DataStr,TableName,UserID,LocID,Empower)
    s SQLCODE=0,result=0
    s $ZT="UpdateExplainErr"
    
        s RowId=$p(DataStr,"^",1)
        s ILLSDR=$p(DataStr,"^",2)
        s ItemDR=$p(DataStr,"^",3)
        s NoActive=$p(DataStr,"^",4)
        s DateUpdate=+$h
        s TimeUpdate=$p($h,",",2) 
        
        
        i RowId="" d
        .s obj=##class(User.DHCPEILLItem).%New()
        e  d
        .s obj=##class(User.DHCPEILLItem).%OpenId(RowId)
        
        d obj.IIILLSDRSetObjectId(ILLSDR)
        s obj.IIIllItem =ItemDR
        s obj.IINoActive=NoActive
        s obj.IIUpdateDate=DateUpdate
        s obj.IIUpdateTime=TimeUpdate
        s obj.IIUpdateUserDR=UserID
        
        s sc=obj.%Save()
        d obj.%Close()
    
        If ($System.Status.IsError(sc)) 
        {
            s result="-1^更新疾病解释失败:"_$System.Status.GetErrorText(sc)
            goto UpdateExplainErr
        }
   
        else
        {
            
            s RowID=obj.%Id()
            
            s ret=##class(User.DHCPEILLItem).SaveDataToPowerControl(RowID,LocID,UserID,Empower)
            //表记录授权插入数据失败
            If ($p(ret,"^",1)="-1")  
            { 
                s result="-1^插入疾病解释授权表失败"
                goto UpdateItemErr
            }
          
       
        }
        
        
          
    s result="0^插入成功"
    q result 
    
UpdateItemErr
    s $zt=""
    q result_$ZE
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.IllnessStandard","FindPISCodeNew")
Query FindIllAlias(ILLSRowID As %String = "", tableName As %String, LocID As %String) As websys.Query(ROWSPEC = "id:%String,desc:%String,TEmpower,TEffPowerFlag")
{
}

ClassMethod FindIllAliasExecute(ByRef qHandle As %Binary, ILLSRowID As %String = "", tableName As %String, LocID As %String) As %Status
{
    s ^tempdhcpe("FindIllAlias")=$lb(ILLSRowID,tableName,LocID)
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s id=0
    f  s id=$o(^DHCPEILLSA(id)) q:(id="")  d
    .S ILLSID=$P($G(^DHCPEILLSA(id)),"^",1)
    .Q:(ILLSRowID'=ILLSID)&(ILLSRowID'="")
    .s Desc=$P($G(^DHCPEILLSA(id)),"^",2)
    .s LocShowDFlag=##class(User.DHCPEILLSAlias).GetLocShowDataFlag(id,LocID)
    .q:LocShowDFlag="N"
    .s EmpowerStr=##class(User.DHCPEILLSAlias).GetEmpowerFlag(id,LocID)
    .s Empower=$p(EmpowerStr,"^",2)
    .s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    .s ^CacheTemp(repid,ind)=$lb(id,Desc,Empower,EffPowerFlag)
    .s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.IllnessStandard","FindIllItem","","Y","DHC_PE_ILLItem","105")
Query FindIllItem(ILLSRowID As %String, NoActiveFlag As %String = "N", tableName As %String, LocID As %String) As websys.Query(ROWSPEC = "TRowID:%String,IllID,Item:%String,TEmpower:%String,TEffPowerFlag,TNoActive,TUpdateDate,TUpdateTime,TUserName,ItemDesc")
{
}

ClassMethod FindIllItemExecute(ByRef qHandle As %Binary, ILLSRowID As %String, NoActiveFlag As %String = "N", tableName As %String, LocID As %String) As %Status
{
    s ^tempdhcpe("FindIllItem")=$lb(ILLSRowID,NoActiveFlag,tableName,LocID)
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
   
    
    s id=0
    f  s id=$O(^CF.PE.ILLItemD(id)) q:id=""  d
    .s IllID=$lg(^CF.PE.ILLItemD(id),2)
    .q:ILLSRowID'=IllID
    .s Item=$lg(^CF.PE.ILLItemD(id),3)
    .s ItemDesc=$p($g(^ARCIM(+Item,$p(Item,"||",2),1)),"^",2)
    .s LocShowDFlag=##class(User.DHCPEILLItem).GetLocShowDataFlag(id,LocID)
    .q:LocShowDFlag="N"
    .s EmpowerStr=##class(User.DHCPEILLItem).GetEmpowerFlag(id,LocID)
    .s Empower=$p(EmpowerStr,"^",2)
    .s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    .s NoActive=$lg(^CF.PE.ILLItemD(id),4)
    .i NoActive="" s NoActive="Y"
    .;q:(NoActiveFlag'=NoActive)
    .s UpdateDate=$lg(^CF.PE.ILLItemD(id),5)
    .i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    .s UpdateTime=$lg(^CF.PE.ILLItemD(id),6)
    .i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
    .s UserDR=$lg(^CF.PE.ILLItemD(id),7)
    .i UserDR'="" s UserName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
    .;d TranslateFindIllItem
    .s ^CacheTemp(repid,ind)=$lb(id,IllID,Item,Empower,EffPowerFlag,NoActive,UpdateDate,UpdateTime,UserName,ItemDesc)
    .s ind=ind+1
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
TranslateFindIllItem
	s ItemDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",ItemDesc,"ARCIMDesc","cls")
	s UserName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",UserName,"SSUSRName","cls")
}

}
