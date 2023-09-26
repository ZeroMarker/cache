Import SQLuser

/// 名称: 专家建议维护
/// 编写者：yupeng
/// 编写日期: 2021-08-04
Class web.DHCPE.CT.ExpertDiagnosis Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description: 判断科室组下某个站点是否有重复的建议
/// Table： 专家建议表 User.DHCPEExpertDiagnosis
/// Input: Advice(建议),EDConclusion(结论),Station(站点ID),LocID(科室ID) 
/// Return： 0/1(无/有)
/// Dubug： w ##class(web.DHCPE.CT.ExpertDiagnosis).IsExsistED("","腰围30","1","105")
ClassMethod IsExsistED(Advice As %String, EDConclusion As %String, Station, LocID As %String)
{
   s flag=0
	s EDRowID=0
    f  s EDRowID=$o(^DHCPEED(EDRowID)) q:(EDRowID="")||(flag=1)  d
    .q:'$D(^DHCPEED(EDRowID,1))
    .s LocShowDFlag=##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(EDRowID,LocID)
    .q:LocShowDFlag="N"
    .s EDDetail=$P($G(^DHCPEED(EDRowID,"1")),"^",1)
    .s EDAdvice=$P($G(^DHCPEED(EDRowID,"Detail")),"^",1)
    .s EDStation=$P($G(^DHCPEED(EDRowID,"1")),"^",7)
    .i (EDConclusion=EDDetail)&&(EDAdvice=Advice)&&(Station=EDStation) s flag=1
    q flag
}

/// w ##class(web.DHCPE.CT.ExpertDiagnosis).InitED(1)
ClassMethod InitED(RowId As %Library.String = "", LocID As %Library.String = "")
{
    i RowId=""{
        s Code=##class(web.DHCPE.DHCPEExpertDiagnosis).GetMaxCode()
        q "^^^^^"_Code_"^^^^^^^^^^^^^^^^^^^^^^^"
    }
    
    //s EDStr=$g(^DHCPEED(RowId,1))_"^"_$g(^DHCPEED(RowId,"Detail"))
    s DiagnoseConclusion=$p($g(^DHCPEED(RowId,1)),"^",1) 	//结论
    s UpdateUser=$p($g(^DHCPEED(RowId,1)),"^",2)
    s UpdateDate=$p($g(^DHCPEED(RowId,1)),"^",3)
    s Illness=$p($g(^DHCPEED(RowId,1)),"^",4) 				//是否疾病
    s CommonIllness=$p($g(^DHCPEED(RowId,1)),"^",5)			//常见病
    s Code=$p($g(^DHCPEED(RowId,1)),"^",6)					//编码
    s StationDR=$p($g(^DHCPEED(RowId,1)),"^",7) 			//站点
    s StationName=""
    i StationDR'="" s StationName=$p($g(^DHCPEST(StationDR)),"^",2)
    s HighRisk=$p($g(^DHCPEED(RowId,1)),"^",8) 				//高危
    s Sort=$p($g(^DHCPEED(RowId,1)),"^",9) 					//顺序
    s StationLoc=$p($g(^DHCPEED(RowId,1)),"^",10) 			//分组
    s StationLocDesc=""
    i $L(StationLoc,"||")>1 d
    .q:'$d(^DHCPEST(+StationLoc,"STLOC",$P(StationLoc,"||",2)))
    .S StationLocDesc=$P(^DHCPEST(+StationLoc,"STLOC",$P(StationLoc,"||",2)),"^",1)
    
    s SexDR=$p($g(^DHCPEED(RowId,1)),"^",11) 				//性别
    s YGCheck=$p($g(^DHCPEED(RowId,1)),"^",12)  			//乙肝
    s Active=$p($g(^DHCPEED(RowId,1)),"^",13)   			//激活
    s UpdateTime=$p($g(^DHCPEED(RowId,1)),"^",14)   
    s KBXCode=$p($g(^DHCPEED(RowId,1)),"^",15)     			//知识库专家建议（外部码） 
    
    s EDStr=DiagnoseConclusion_"^"_UpdateUser_"^"_UpdateDate_"^"_Illness_"^"_CommonIllness_"^"_Code_"^"_StationDR_"^"_HighRisk_"^"_Sort_"^"_StationLoc_"^"_SexDR_"^"_YGCheck_"^"_Active_"^"_UpdateTime_"^"_KBXCode
    s EDStr=EDStr_"^"_$g(^DHCPEED(RowId,"Detail"))
    s EDCRID=""
    s EDDCID=""
    s EDCRID=$O(^DHCPEEDCR(0,"EDDR",RowId,0)) 
    i EDCRID'=""  s EDDCID=$P($G(^DHCPEEDCR(EDCRID)),"^",2)
    
    s EmpowerStr=##class(User.DHCPEExpertDiagnosis).GetEmpowerFlag(RowId,LocID)
    s Empower=$p(EmpowerStr,"^",2)

    
    q EDStr_"^"_StationName_"^"_EDDCID_"^"_EDCRID_"^"_StationLocDesc_"^"_Empower
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.ExpertDiagnosis", "QueryED","","","","","","","","","","")
Query QueryED(Code As %Library.String = "", DiagnoseConclusion As %Library.String = "", Alias As %Library.String = "", StationID As %Library.String = "", ChartID As %Library.String = "", HighRisk As %Library.String = "", ActiveFlag As %String = "", StationName As %String = "", tableName As %String, LocID As %String, Eff As %String = "N") As websys.Query(ROWSPEC = "ED_RowId:%String,ED_Detail:%String,ED_DiagnoseConclusion:%String,ED_Code:%String,ED_Illness:%String,ED_CommonIllness:%String,TStationID:%String,TStationName:%String,TActive:%String,TUserName:%String,TLevel:%String,TSex:%String,THighRisk:%String,TYGFlag:%String,TEmpower:%String,TEffPowerFlag:%String")
{
}

ClassMethod QueryEDExecute(ByRef qHandle As %Binary, Code As %Library.String = "", DiagnoseConclusion As %Library.String = "", Alias As %Library.String = "", StationID As %Library.String = "", ChartID As %Library.String = "", HighRisk As %Library.String = "", ActiveFlag As %String = "", StationName As %String = "", tableName As %String, LocID As %String, Eff As %String = "N") As %Status
{
    Set repid=$I(^CacheTemp)
    //s:ActiveFlag=1 ActiveFlag="Y"
    //s:ActiveFlag=0 ActiveFlag="N"
    
    s Code=$ZCVT(Code,"U")
    s DiagnoseConclusion=##class(web.DHCPE.DHCPECommon).UnEscape(DiagnoseConclusion)
    s DiagnoseConclusion=$ZCVT(DiagnoseConclusion,"U")
    s Alias=$ZCVT(Alias,"U")
    
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
    s LocShowDFlag=##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(RowId,LocID)
    q:(Eff="N")&&(LocShowDFlag="N")
    q:(Eff="Y")&&(LocShowDFlag'="Y")
    s EmpowerStr=##class(User.DHCPEExpertDiagnosis).GetEmpowerFlag(RowId,LocID)
    s Empower=$p(EmpowerStr,"^",2)
    s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    s EDAliaID=0
    s Active=$p(^DHCPEED(RowId,1),"^",13)
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
    s StatEffPowerFlag=##class(User.DHCPEStation).GetLocShowDataFlag(vStationID,LocID)
    s StatEffPowerFlag=$s(StatEffPowerFlag="Y":"Y",1:"N")
    q:StatEffPowerFlag'="Y"  //过滤未授权的站点
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
    s Sex=$p(^DHCPEED(RowId,1),"^",11)
    i Sex'=""  s SexDesc=$p($g(^CT("SEX",Sex)),"^",2) 
    S TYGFlag=$p(^DHCPEED(RowId,1),"^",12)
    s:TYGFlag="" TYGFlag="N"
    s UpdateDate=$p(^DHCPEED(RowId,1),"^",3)
    i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    s UpdateTime=$p(^DHCPEED(RowId,1),"^",14)
    i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
    s UserDR=$p(^DHCPEED(RowId,1),"^",2)
    i UserDR'="" s UserName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
    d QueryED
    q
    
QueryED      
    set Data=$lb(RowId,DC,Detail,CCode,Illness,CommonIllness,StationID,StationName,Active,UserName,EDCDesc,SexDesc,THighRisk,TYGFlag,Empower,EffPowerFlag)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod UpdateAlias(DataStr, isDelete)
{
    if (isDelete=1)
    {
        &SQL(delete from sqluser.DHC_PE_EDAlias where EDA_RowId=:DataStr)
    }
    else
    {
        s AliasRowId=$p(DataStr,"^",1)
        s PLIST(2)=$p(DataStr,"^",2)
        s PLIST(3)=$p(DataStr,"^",3)
        i RowId=""
        {
            &SQL(insert into sqluser.DHC_PE_EDAlias values :PLIST())
        }
        else
        {
            &SQL(update sqluser.DHC_PE_EDAlias values :PLIST() where EDA_RowId=:AliasRowId)
        }
    }
    q SQLCODE
}

/// w ##class(web.DHCPE.CT.ExpertDiagnosis).UpdateED()
ClassMethod UpdateED(RowId As %Library.String = "", Code As %Library.String = "", DiagnoseConclusion As %Library.String = "", Detail As %Library.String = "", Illness As %Library.String = "", CommonIllness As %Library.String = "", UserUpdate As %Library.String = "", StationID As %Library.String = "", Active As %Library.String = "", DiagnosisLevel As %Library.String = "", EDCRID As %Library.String = "", SexDR As %Library.String = "", HighRisk As %String)
{
    
    s ^tempdhcpediagnosis("Update")=$lb(RowId,Code,DiagnoseConclusion,Detail,Illness,CommonIllness,UserUpdate,StationID,Active,DiagnosisLevel,EDCRID,SexDR,HighRisk)
    s $ZT="UpdateErr"
    s Empower=$P(HighRisk,"^",7)
    s EDAlias=$P(HighRisk,"^",6)
    s LocID=$P(HighRisk,"^",5)
    s YGFlag=$P(HighRisk,"^",4)
    s StationLocID=$P(HighRisk,"^",3)
    s Sort=$P(HighRisk,"^",2)
    s HighRisk=$P(HighRisk,"^",1)
    i Code="" s Code=##class(web.DHCPE.DHCPEExpertDiagnosis).GetMaxCode()
    s DateUpdate=+$h
    s TimeUpdate=$p($h,",",2)  
    s SQLCODE=0
    
    TSTART
    i RowId="" d
    .s obj=##class(User.DHCPEExpertDiagnosis).%New()
    e  d
    .s obj=##class(User.DHCPEExpertDiagnosis).%OpenId(RowId)
    
    s obj.EDCode=Code
    s obj.EDDiagnoseConclusion=DiagnoseConclusion
    s obj.EDDetail=Detail
    s obj.EDIllness=Illness
    s obj.EDCommonIllness=CommonIllness
    s obj.EDHighRisk=HighRisk
    s obj.EDSort=Sort
    s obj.EDDateUpdate=DateUpdate
    s obj.EDTimeUpdate=TimeUpdate
    s obj.EDSexDR=SexDR
    s obj.EDYGCheck=YGFlag
    s obj.EDActive=Active
    d obj.EDUserUpdateDRSetObjectId(UserUpdate)
    d obj.EDStationDRSetObjectId(StationID)
    d obj.EDStationLocIDSetObjectId(StationLocID)
    
    
    s sc=obj.%Save()
    d obj.%Close()
    
    If ($System.Status.IsError(sc)) 
    {
        s result="-1^更新专家建议失败:"_$System.Status.GetErrorText(sc)
        goto UpdateErr
    }
    
    else
    {
        
        s EDRowId=obj.%Id()
        
        s ret=##class(User.DHCPEExpertDiagnosis).SaveDataToPowerControl(EDRowId,LocID,UserUpdate,Empower)
        //表记录授权插入数据失败
        If ($p(ret,"^",1)="-1")  
        { 
            s result="-1^插入记录授权表失败"
            goto UpdateErr
        }
      
          
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
                    s result="-1^更新建议别名失败"
                    goto UpdateErr
                }
                s j=j+1
            }
        }
        
        i EDCRID'=""  d
        .&sql(Update DHC_PE_EDCRelate set EDCR_EDC_DR=:DiagnosisLevel where EDCR_RowId=:EDCRID)
        e   d
        .&sql(insert into DHC_PE_EDCRelate(EDCR_ED_DR, EDCR_EDC_DR) values (:EDRowId,:DiagnosisLevel))
        i SQLCODE
        {
             s result="-1^更新建议级别失败"
             goto UpdateErr
        }
        
        
    }
   
   TCommit
   
   s result="0^插入成功"
   q result  
   
UpdateErr
    TROLLBACK 
    q result_$ZE
}

/// Creator：    xy
/// CreatDate：  20230324
/// Description: 删除建议和疾病
/// Input:       locid:科室ID           
/// Return：     0/1(删除成功/删除失败)
/// Debug:w ##class(web.DHCPE.CT.ExpertDiagnosis).DeleteExpertDiagnosis(105)
ClassMethod DeleteExpertDiagnosis(locid As %String)
{

    s flag=0
    s LocGrpID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetLocGrpByLocID(locid)
    i LocGrpID'=""  s LocListID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetLocIDByLocGrp(locid)
    s $ZT="DeleteEDILLErr"
    
    TSTART
    s length=$l(LocListID,"^")
    f LocNum=1:1:length d
    .s LocID=$p(LocListID,"^",LocNum)
    .s EDID=0
    .f  s EDID=$o(^DHCPEED(EDID)) q:EDID=""  d
    ..s LocShowDFlag=##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(EDID,LocID)
    ..q:LocShowDFlag="N"
    ..
    ..s ExpressID=""
    ..f  s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","ED",EDID,ExpressID)) q:ExpressID=""  d
    ...&SQL(delete from sqluser.DHC_PE_Express where ID=:ExpressID)  //删除建议表达式表
    ...i (SQLCODE'=0) d
    ....s flag="-1^删除建议表达式表失败"
    ....goto DeleteEDILLErr
    ..
    ..s EDAlias=""
    ..f  s EDAlias=$o(^DHCPEEDA(0,"EDAlias",EDID,EDAlias))  q:EDAlias=""  d
    ...s EDAText=""
    ...f  s EDAText=$o(^DHCPEEDA(0,"EDAlias",EDID,EDAlias,EDAText))  q:EDAText=""  d
    ....s EDAID=""
    ....f  s EDAID=$o(^DHCPEEDA(0,"EDAlias",EDID,EDAlias,EDAText,EDAID))  q:EDAID=""  d
    .....&SQL(delete from sqluser.DHC_PE_EDAlias where EDA_RowId=:EDAID)  //删除建议别名表
    .....i (SQLCODE'=0) d
    ......s flag="-1^删除建议别名表失败"
    ......goto DeleteEDILLErr
    ..
    ..&sql(Delete from DHC_PE_EDCRelate where EDCR_ED_DR=:EDID) //删除建议级别关联表
    ..i (SQLCODE'=0) d
    ...s flag="-1^删除建议级别关联表失败"
    ...goto DeleteEDILLErr
    ..
    ..&SQL(delete from DHC_PE_IDRelate where IDR_ED_DR=:EDID) //删除疾病和诊断关联表
    ..i (SQLCODE'=0) d
    ...s flag="-1^删除疾病和诊断关联表失败"
    ...goto DeleteEDILLErr
    ..
    ..s ret=##class(web.DHCPE.CT.DHCPEMappingLoc).DeletePowerControl("User.DHCPEExpertDiagnosis",EDID,LocID)
    ..i (ret'=0) d
    ...s flag="-1^删除专家建议表记录授权表数据失败"
    ...goto DeleteEDILLErr
    ..
    ..&sql(Delete from DHC_PE_ExpertDiagnosis where ED_RowId=:EDID)  //删除建议表
    ..i (ret'=0) d
    ...s flag="-1^删除建议表失败"
    ...goto DeleteEDILLErr
   
    .s ILLSID=0
    .f  s ILLSID=$o(^DHCPEILLS(ILLSID)) q:ILLSID=""  d
    ..s LocShowDFlag=##class(User.DHCPEIllnessStandard).GetLocShowDataFlag(ILLSID,LocID)
    ..q:LocShowDFlag="N"
    ..&sql(Delete from DHC_PE_IllnessStandard where ILLS_RowId=:ILLSID)  //删除疾病表
    ..i (ret'=0) d
    ...s flag="-1^删除疾病表失败"
    ...goto DeleteEDILLErr
   TCommit
    s flag="0^删除成功"
    q flag
    
DeleteEDILLErr
    TROLLBACK 
    q flag
}

}
