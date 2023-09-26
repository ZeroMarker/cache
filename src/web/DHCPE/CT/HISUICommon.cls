Class web.DHCPE.CT.HISUICommon Extends %RegisteredObject
{

/// Creator：      xy
/// CreatDate：    20220819
/// Description:  获取药品的附加信息
/// Input:        ID(医嘱项ID/预约项目ID/套餐ID^医嘱项ID),LocID(科室ID),Type(类型 ArcimID/PreItemID/ArcOrdSets)
/// Return：      药品附加信息
/// Debug:w ##class(web.DHCPE.CT.HISUICommon).GetDrugByID("98^1011||1","105","ArcOrdSets")
ClassMethod GetDrugByID(ID As %String = "", LocID As %String = "", Type As %String = "ArcimID")
{
     //s ^tempdhcpe("GetDrugByID")=$lb(ID,LocID,Type)
     q:(ID="")||(LocID="") "^^^^"
     s DoseQty="",UOM="",Frequence="",Duration="",Instruction=""
     
     if (Type="ArcimID"){
        s StatOrderDR=""
        s ArcimID=ID
        s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcimID,LocID)  
        i StatOrderDR'="" s StatOrdSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderDR,""))
        i StatOrdSetID'="" d
        .s DoseQty=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),37)     //单次剂量 
        .s UOM=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),38)         //单次剂量单位 
        .s Frequence=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),39)   //频次指针
        .s Instruction=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),40) //用法指针 
        .s Duration=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),41)    //疗程指针 
     }elseif (Type="PreItemID"){
        s PreOrdItemID=ID
        s DoseQty=$P($g(^DHCPEPreIADM(+PreOrdItemID,"ORDITEM",$P(PreOrdItemID,"||",2))),"^",28)     //单次剂量 
        s UOM=$P($g(^DHCPEPreIADM(+PreOrdItemID,"ORDITEM",$P(PreOrdItemID,"||",2))),"^",29)         //单次剂量单位
        s Frequence=$P($g(^DHCPEPreIADM(+PreOrdItemID,"ORDITEM",$P(PreOrdItemID,"||",2))),"^",30)   //频次指针
        s Duration=$P($g(^DHCPEPreIADM(+PreOrdItemID,"ORDITEM",$P(PreOrdItemID,"||",2))),"^",31)    //疗程指针
        s Instruction=$P($g(^DHCPEPreIADM(+PreOrdItemID,"ORDITEM",$P(PreOrdItemID,"||",2))),"^",32) //用法指针
     }elseif(Type="ArcOrdSets"){
         s SetId=$p(ID,"^",1)
         s ARCIMDR=$p(ID,"^",2)
        
         s dateChildId=""
         f  s dateChildId=$o(^ARCOS(SetId,"DATE",dateChildId)) q:dateChildId=""  d
         .s itemChildId="0"
         .f  s itemChildId=$o(^ARCOS(SetId,"DATE",dateChildId,"ITM",itemChildId)) q:itemChildId=""  d
         ..s strDataItm=$g(^ARCOS(SetId,"DATE",dateChildId,"ITM",itemChildId))
         ..s myItemId=$p(strDataItm,"^",1)
         ..q:myItemId'=ARCIMDR
         ..s DoseQty=$p(strDataItm,"^",13)    //单次剂量 
         ..s UOM=$p(strDataItm,"^",10)        //单次剂量单位
         ..s Frequence=$p(strDataItm,"^",8)   //频次指针
         ..s Duration=$p(strDataItm,"^",7)    //疗程指针
         ..s Instruction=$p(strDataItm,"^",9) //用法指针
     }
         
     
    q DoseQty_"^"_UOM_"^"_Frequence_"^"_Duration_"^"_Instruction
}

/// Creator：      xy
/// CreatDate：    20220119
/// Description:  卡号自动补0(多院区)
/// Input:        CardNo(卡号),CardTypeDR(卡类型),CTLocID(科室ID)
/// Return：      卡号
/// Debug:w ##class(web.DHCPE.CT.HISUICommon).CardNoMaskNew(44,1,152)
ClassMethod CardNoMaskNew(CardNo As %String = "", CardTypeDR As %String = "", CTLocID As %String = "")
{
    q:CardNo="" ""
    i CTLocID="" s CTLocID=%session.Get("LOGON.CTLOCID")
    i CTLocID'="" s HospID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetHospIDByLocID(CTLocID)
    q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_CardTypeDef",CardTypeDR,HospID) ""
    s CardLength=+$P($g(^DHCCARDTYPEDef(CardTypeDR)),"^",17)
    q:CardLength=0 CardNo
    s ZeroStr=$E("00000000000000000000000000",1,CardLength)
    s CardNo=$E(ZeroStr,1,CardLength-$l(CardNo))_CardNo
    q CardNo
}

/// Creator：      xy
/// CreatDate：    20211208
/// Description:  根据站点ID获取相应的站点类型
/// Input:        StationID(站点ID),LocID(科室ID)
/// Return：      return=站点类型
/// dubug: w ##class(web.DHCPE.CT.HISUICommon).GetStationTypeByID("3","152")
ClassMethod GetStationTypeByID(StationID As %String = "", LocID As %String = "")
{
    q:(StationID="")||(LocID="") ""
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))
    s RisStation="^"_$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))_"^"
    i StationID=LabStation q "LIS"
    i RisStation[("^"_StationID_"^") q "RIS"
    q "NOR"
}

/// Creator：      xueying
/// CreatDate：    20211222
/// Description:  根据StatOrderDR（站点和项目组合ID）找到对应的站点分类ID
/// Input:        StatOrderDR(站点和项目组合ID),LocID(科室ID)
/// Return：      return=站点分类ID
/// dubug: w ##class(web.DHCPE.CT.HISUICommon).GetStatCatIDBySTOrderID("","152")
ClassMethod GetStatCatIDBySTOrderID(StatOrderDR As %String = "", LocID As %String = "")
{
    q:StatOrderDR="" ""
    s StationCatID=""
    s SOCSID=""
    f  s SOCSID=$o(^CF.PE.StationOrdSortI("ORD","IdxOfOrderDR",StatOrderDR,SOCSID)) q:(SOCSID="")||(StationCatID'="")  d
    .s sub=0
    .f  s sub=$o(^CF.PE.StationOrdSortI("ORD","IdxOfOrderDR",StatOrderDR,SOCSID,sub)) q:sub=""  d
    ..s SOSID=SOCSID_"||"_sub
    ..s LocShowDFlag=##class(User.DHCPEStationOrderSort).GetLocShowDataFlag(SOSID,LocID)
    ..q:LocShowDFlag'="Y"
    ..s StationCatID=$lg($g(^CF.PE.StationOrdSortD(SOCSID)),2) 
    q StationCatID
}

/// Creator：      xy
/// CreatDate：    20210824
/// Description:  根据医嘱项ID查找对应OrderDR（站点和项目组合ID）
/// Input:        ArcimID(医嘱项ID),LocID(科室ID)
/// Return：      return=站点和项目组合ID
/// dubug: w ##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM("3650||1","152")
ClassMethod GetStatOrderIDByARCIM(ArcimID As %String = "", LocID As %String = "")
{
   
    S tableName="DHC_PE_StationOrder"
    q:ArcimID="" ""
    s OrderDR=""
    s StationDR=""
    f  s StationDR=$o(^DHCPEST(0,"STORD_ARCIM",ArcimID,StationDR))  q:(StationDR="")||(OrderDR'="")  d
    .s Sub=""
    .f  s Sub=$o(^DHCPEST(0,"STORD_ARCIM",ArcimID,StationDR,Sub))  q:(Sub="")||(OrderDR'="")  d
    ..s DataID=StationDR_"||"_Sub
    ..s LocShowDFlag=##class(User.DHCPEStationOrder).GetLocShowDataFlag(DataID,LocID)
    ..i LocShowDFlag="Y" s OrderDR=DataID
    q OrderDR
}

/// Creator：      xy
/// CreatDate：    20210822
/// Description:  查询导诊单类别
/// Table：       科室导诊单项目分类  DHC_PE_UsherItemCat
/// Input:        LocID(科室ID)
/// Return：
/// dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HISUICommon","FindPatItem","152")
Query FindPatItem(LocID As %String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindPatItemExecute(ByRef qHandle As %Binary, LocID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    if (LocID=""){
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    s Category=""
    f  s Category=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID,Category))  q:Category=""   d
    .s ID=""
    .f  s ID=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID,Category,ID))  q:ID=""   d
    ..s Active=$lg($g(^CF.PE.UsherItemCatD(ID)),8)
    ..q:Active'="Y"
    ..s Desc=$lg($g(^CF.PE.UsherItemCatD(ID)),3)
    ..s Desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEUsherItemCat",Desc,"PICategory","cls")
    ..s ^CacheTemp(repid,ind)=$lb(ID,Desc)
    ..s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Creator：      xy
/// CreatDate：    20210822
/// Description:  查询科室站点
/// Table：       站点字典表 DHC_PE_Station,科室站点详情表  DHC_PE_StationSet
/// Input:        LocID(科室ID)
/// Return：
/// dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HISUICommon","FindStationBase","152")
Query FindStationBase(LocID As %String = "", Type As %String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindStationBaseExecute(ByRef qHandle As %Binary, LocID As %String = "", Type As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s ^tempdhcpe("FindStationBase")=$lb(LocID)
    if (LocID=""){
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    
    s MedicalStation=$g(^DHCPESetting("DHCPE","StationId_Medical",LocID))
    s OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other",LocID))
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))
    
    s StationDR=0
    f  s StationDR=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,StationDR))  q:StationDR=""   d
    .s LocPowerFlg = ##class(User.DHCPEStation).GetLocShowDataFlag(StationDR,LocID)
    .q:LocPowerFlg'="Y" 
    . s id=0
    .f  s id=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,StationDR,id))  q:id=""  d
    ..s Active=$lg($g(^CF.PE.StationSetD(id)),11)
    ..q:Active'="Y" 
    ..q:(Type="JC")&&((MedicalStation=StationDR)||(OtherStation=StationDR)||(LabStation=StationDR))
    ..s desc=$p($g(^DHCPEST(StationDR)),"^",2)
    ..s ^CacheTemp(repid,ind)=$lb(StationDR,desc)
    ..s ind=ind+1
  
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Creator：      xy
/// CreatDate：    20211116
/// Description:  查询科室站点通过类型
/// Table：       站点字典表 DHC_PE_Station,科室站点详情表  DHC_PE_StationSet
/// Input:        LocID(科室ID),Type("" 询所有站点,L 检验站点 ,N 常规检查站点 ,X 接口检查站点,R 药品 ,O 其他 ,需要查询多个可以拼接 如 LNX 查询非药品和非其他的站点)
/// Return：
/// dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HISUICommon","FindStationByType",152,"")
Query FindStationByType(LocID As %String = "", Type As %String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindStationByTypeExecute(ByRef qHandle As %Binary, LocID As %String = "", Type As %String = "") As %Status
{
    
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s ^tempdhcpe("FindStationByType")=$lb(LocID,Type)
    if (LocID=""){
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
   
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))
    s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))
    s MedStation=$g(^DHCPESetting("DHCPE","StationId_Medical",LocID))
    s OthStation=$g(^DHCPESetting("DHCPE","StationId_Other",LocID))
    
    s StationDR=0
    f  s StationDR=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,StationDR))  q:StationDR=""   d
    .s LocPowerFlg = ##class(User.DHCPEStation).GetLocShowDataFlag(StationDR,LocID)
    .q:LocPowerFlg'="Y" 
    .s id=0
    .f  s id=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,StationDR,id))  q:id=""  d
    ..s Active=$lg($g(^CF.PE.StationSetD(id)),11)
    ..q:Active'="Y" 
    ..q:((Type'="")&&(Type'["L")&&(("^"_LabStation_"^")[("^"_StationDR_"^")))
    ..q:((Type'="")&&(Type'["X")&&(("^"_RisStation_"^")[("^"_StationDR_"^")))
    ..q:((Type'="")&&(Type'["R")&&(("^"_MedStation_"^")[("^"_StationDR_"^")))
    ..q:((Type'="")&&(Type'["O")&&(("^"_OthStation_"^")[("^"_StationDR_"^")))
    ..q:((Type'="")&&(Type'["N")&&(("^"_LabStation_"^"_RisStation_"^"_MedStation_"^"_OthStation_"^")'[("^"_StationDR_"^")))
    ..s desc=$p($g(^DHCPEST(StationDR)),"^",2)
    ..s desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",desc,"STDesc","cls")
    ..s ^CacheTemp(repid,ind)=$lb(StationDR,desc)
    ..s ind=ind+1
  
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Creator：      xy
/// CreatDate：    20211116
/// Description:  判断医嘱项是不是属于该站点
/// Debug：d ##class(web.DHCPE.CT.HISUICommon).GetStationFlag()
ClassMethod GetStationFlag(Station, ItemID, LocID)
{
    s Flag=0
    q:(Station="")||(ItemID="")||(LocID="") Flag
    s StationOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItemID,LocID)
    q:StationOrderID="" Flag
    s StationID=$p(StationOrderID,"||",1)
    i StationID=Station s Flag=1
    q Flag
}

/// Creator：      sxt 
/// CreatDate：    20210808
/// Description: 查询科室VIP等级详情
/// Table：      科室VIP等级表 DHC_PE_LocVIPLevel
/// Input:       LocID(科室ID),Desc(vip描述)
/// Return：
/// dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HISUICommon","FindVIP","152")
Query FindVIP(LocID As %String = "", Desc As %String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String") [ SqlProc ]
{
}

ClassMethod FindVIPExecute(ByRef qHandle As %Binary, LocID As %String = "", Desc As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s ^tempdhcpe("FindVIP")=$lb(LocID)
    if (LocID=""){
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    s VIPLevelID=0 
    f  s VIPLevelID=$O(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,VIPLevelID)) q:VIPLevelID=""  d
    .s ID=$o(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,VIPLevelID,0)) // 1个科室不能存在相同VIP
    .s LocDR=$lg($g(^CF.PE.LocVIPLevelD(ID)),2)
    .s LocActive=$lg($g(^CF.PE.LocVIPLevelD(ID)),15)
    .q:LocActive'="Y"
    .s VIPLevelDR=$lg($g(^CF.PE.LocVIPLevelD(ID)),3)
    .s Active=$lg($g(^CT.PE.VIPLevelD(VIPLevelDR)),4)
    .q:Active'="Y"
    .s desc=$lg($g(^CT.PE.VIPLevelD(VIPLevelDR)),3)
    .q:(Desc'="")&&(Desc'=desc)
    .s:desc'="" desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEVIPLevel",desc,"VLDesc","cls")
    .s ^CacheTemp(repid,ind)=$lb(VIPLevelID,desc)
    .s ind=ind+1
       
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Creator：      XY
/// CreatDate：    20220303
/// Description:  获取VIP描述
/// Table：       科室VIP等级表 DHC_PE_LocVIPLevel
/// Input:        VIPID(VIPID)
/// Return：      VIP描述
/// dubug: d ##class(web.DHCPE.CT.HISUICommon).GetVIPDescByID()
ClassMethod GetVIPDescByID(VIPID)
{
    q:VIPID="" ""
    s VIPDesc=""
    s VIPDesc=$lg($g(^CT.PE.VIPLevelD(VIPID)),3)
    q VIPDesc
}

/// Creator：    xy 
/// CreatDate：  20220310
/// Description: 根据VIP等级描述获取VIPID
/// Table：      科室VIP等级维护表  DHC_PE_LocVIPLevel 
/// Input:       LocID:科室ID,VIPDesc:VIP等级描述
/// Return：     return=VIPID
/// debug: w ##class(web.DHCPE.CT.HISUICommon).GetVIPIDByDesc("普通")
ClassMethod GetVIPIDByDesc(VIPDesc As %String = "")
{
    s ret=""
    s VIPID=""
    f  s VIPID=$O(^CT.PE.VIPLevelD(VIPID)) q:(VIPID="")||(ret'="")  d
    .s Desc=$lg($g(^CT.PE.VIPLevelD(VIPID)),3)
    .s:Desc=VIPDesc ret=VIPID
    q ret
}

/// Creator：      XY
/// CreatDate：    20220303
/// Description:  查询检查种类
/// Table：       职业健康检查种类DHC_PE_OMEType      
/// dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HISUICommon","FindCategory")
Query FindCategory() As websys.Query(ROWSPEC = "id:%String,Category:%String")
{
}

ClassMethod FindCategoryExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$O(^User.DHCPEOMETypeD(id)) q:id=""  d
    .s Active=$LG(^User.DHCPEOMETypeD(id),4)
    .q:Active'="Y"
    .s VipLevel=$LG(^User.DHCPEOMETypeD(id),5)
    .s VIPDesc=""
    .i VipLevel'="" s VIPDesc=##class(web.DHCPE.CT.HISUICommon).GetVIPDescByID(VipLevel)
    .q:VIPDesc'["职业病"
    .s Category=$LG(^User.DHCPEOMETypeD(id),3)
    .s ^CacheTemp(repid,ind)=$lb(id,Category)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Creator：      XY
/// CreatDate：    20220303
/// Description:  获取危害因素
/// Table：       危害因素表   DHC_PE_EndangerType
/// Input:        LocID(科室ID)
/// Return：      危害因素json串
/// dubug: d ##class(web.DHCPE.CT.HISUICommon).GetHarmInfo()
ClassMethod GetHarmInfo(LocID)
{
    s VIPLevel=""
    s VIPLevelID=0 
    f  s VIPLevelID=$O(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,VIPLevelID)) q:VIPLevelID=""  d
    .s ID=$o(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,VIPLevelID,0)) // 1个科室不能存在相同VIP
    .s LocActive=$lg($g(^CF.PE.LocVIPLevelD(ID)),15)
    .q:LocActive'="Y"
    .s VIPLevelDR=$lg($g(^CF.PE.LocVIPLevelD(ID)),3)
    .s Active=$lg($g(^CT.PE.VIPLevelD(VIPLevelDR)),4)
    .q:Active'="Y"
    .s VIPDesc=$lg($g(^CT.PE.VIPLevelD(VIPLevelDR)),3)
    .s:VIPDesc="职业病" VIPLevel=VIPLevelDR

    q:VIPLevel="" ""
    
    s ETRowId=0,str=""
    f  s ETRowId=$o(^User.DHCPEEndangerTypeI("VIPLevelIndex",VIPLevel,ETRowId)) q:ETRowId=""  d
    .s ETDesc=$LG(^User.DHCPEEndangerTypeD(ETRowId),3)
    .s ETActive=$LG(^User.DHCPEEndangerTypeD(ETRowId),4)
    .Q:ETActive'="Y"
    .s children=""
    .s EDRowId=0
    .f  s EDRowId=$o(^User.DHCPEEndangerI("EDTypeIndex",ETRowId,EDRowId)) q:EDRowId=""  d
    ..s EDDesc=$LG(^User.DHCPEEndangerD(EDRowId),3)
    ..s Active=$LG(^User.DHCPEEndangerD(EDRowId),4)
    ..q:Active'="Y"
    ..i children="" s children="{"_"""id"":"""_EDRowId_""","_"""text"":"""_EDDesc_"""}"
    ..e  s children=children_",{"_"""id"":"""_EDRowId_""","_"""text"":"""_EDDesc_"""}"
    .q:children=""
    .s:children'="" children="["_children_"]"
    .i str="" s str="{"_"""id"":""P"_ETRowId_""","_"""text"":"""_ETDesc_""","_"""children"":"_children_"}"
    .e  s str=str_","_"{"_"""id"":""P"_ETRowId_""","_"""text"":"""_ETDesc_""","_"""children"":"_children_"}"
    s str="["_str_"]"
    q str
}

/// Description: 查询检验标本类型
/// Input:       LocID(科室ID)
/// Debug:  d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HISUICommon","GetSpecimen",152)
/// 注意： 标本类型 dbo.BT_Specimen关联dbo.bt_hospital，dbo.bt_hospital再关联CT_Hospital
///       （dbo.bt_hospital中的医院code和门诊院区表CT_Hospital的医院code进行对照）
Query GetSpecimen(LocID As %String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod GetSpecimenExecute(ByRef qHandle As %Binary, LocID As %String = "") As %Status
{
    //s ^tempdhcpe("GetSpecimen",LocID)=$lb(LocID)
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion",LocID))
    s HosID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetHospIDByLocID(LocID)
    
    i LisNewVersion="Y" D
    .S specid=0
    .f  s specid=$o(^dbo.BTSpecimenD(specid)) q:specid=""  d
    ..s id=$LG(^dbo.BTSpecimenD(specid),2)
    ..s Desc=$LG(^dbo.BTSpecimenD(specid),3)
    ..q:Desc'["血"
    ..s btHosDR=$LG($G(^dbo.BTSpecimenD(specid)),6)
    ..s HosDR=""
    ..i btHosDR'="" d
    ...s HosCode=$LG($G(^dbo.BTHospitalD(btHosDR)),2)
    ...S HosCode=$$ALPHAUP^SSUTIL4(HosCode)
    ...s HosDR=$O(^CT("HOSP",0,"Code",HosCode,""))
    ..q:(HosDR'="")&&(HosDR'=HosID)
    ..s ^CacheTemp(repid,ind)=$lb(id,Desc)
    ..s ind=ind+1 
    e  d
    .s id=0
    .f  s id=$O(^TTAB("SPEC",id)) q:id=""  d
    ..s Desc=$P($G(^TTAB("SPEC",id)),"\",1)
    ..q:Desc'["血"
    ..s ^CacheTemp(repid,ind)=$lb(id,Desc)
    ..s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Description: 查询诊室位置
/// Input:       LocID(科室ID)
/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HISUICommon","GetRoomPlace",539)
Query GetRoomPlace(LocID As %String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod GetRoomPlaceExecute(ByRef qHandle As %Binary, LocID As %String = "") As %Status
{

    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    if (LocID=""){
        s LocID=%session.Get("LOGON.CTLOCID")
    }
    
   
    s ID=0
    f  s ID=$O(^CF.PE.RoomPlaceD(ID)) q:ID=""  d
    .//w ##class(User.DHCPERoomPlace).GetLocShowDataFlag(ID,LocID)
    .q:$lg(^CF.PE.RoomPlaceD(ID),7)'=LocID
    .s TCode=$lg(^CF.PE.RoomPlaceD(ID),2)
    .s TDesc=$lg(^CF.PE.RoomPlaceD(ID),3)
    .s:TDesc'="" TDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPERoomPlace",TDesc,"RPDesc","cls")
    
    .s TVIPLevelID=$lg(^CF.PE.RoomPlaceD(ID),4)
    .s TVIPLevelDesc=""
    .s:TVIPLevelID'="" TVIPLevelDesc=$lg($g(^CT.PE.VIPLevelD(TVIPLevelID)),3)
    .s TGIType=$lg(^CF.PE.RoomPlaceD(ID),5)
    .s:TGIType="N" TGITypeDesc="不限"
    .s:TGIType="I" TGITypeDesc="个人"
    .s:TGIType="G" TGITypeDesc="团体"
    .s TNoPrintBlood=$lg(^CF.PE.RoomPlaceD(ID),6)
    .q:($li(^CF.PE.RoomPlaceD(ID),8)'="Y")
    .s ^CacheTemp(repid,ind)=$lb(ID,TDesc)
    .s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

ClassMethod GetRoomPlaceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRoomPlaceExecute ]
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

ClassMethod GetRoomPlaceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRoomPlaceExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetRoom() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod GetRoomExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s Parref=0
    f  s Parref=$O(^User.DHCPEAreaD(Parref)) q:Parref=""  d
    .s id=0
    .f  s id=$o(^User.DHCPEAreaD(Parref,"ChildRoom",id)) q:id=""  d
    ..s Str=##class(web.DHCPE.RoomManager).GetOneRoomInfo(Parref_"||"_id)
    ..s RoomDesc=$P(Str,"^",2)
    ..q:RoomDesc[("B")
    ..s RoomID=Parref_"||"_id
    ..s ^CacheTemp(repid,ind)=$lb(RoomID,RoomDesc)
    ..s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Creator：      sxt
/// CreatDate：    20210829
/// Description:  诊室位置
/// Table：       诊室位置字典表  DHC_PE_RoomPlace
/// Input:        VIPLevel(VIPID),LocID(科室ID),GIType(团体/个人)
/// dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HISUICommon","FindRoomPlace","152")
Query FindRoomPlace(VIPLevel As %String = "", GIType As %String = "", LocID As %String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindRoomPlaceExecute(ByRef qHandle As %Binary, VIPLevel As %String = "", GIType As %String = "", LocID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
    s id=0
    f  s id=$o(^CF.PE.RoomPlaceD(id)) q:(id="")  d
    .s desc=$lg(^CF.PE.RoomPlaceD(id),3)
    .s locid=$lg(^CF.PE.RoomPlaceD(id),7)
    .q:(locid'=LocID)&&(LocID'="")
    .s Active=$lg(^CF.PE.RoomPlaceD(id),8)
    .q:Active'="Y"
    .s TVIPLevelID=$lg(^CF.PE.RoomPlaceD(id),4)
    .q:(VIPLevel'="")&&(VIPLevel'=TVIPLevelID)
    .s TGIType=$lg(^CF.PE.RoomPlaceD(id),5)
    .q:(GIType'="")&&(TGIType'="N")&&(TGIType'="")&&(TGIType'=GIType)
    .s desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPERoomPlace",desc,"RPDesc","cls")
    .s ^CacheTemp(repid,ind)=$lb(id,desc)
    .s ind=ind+1
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Creator：      xueying
/// CreatDate：    20211029
/// Description:  建议级别
/// Table：       建议级别表 DHC_PE_EDClass 
/// Input:        LocID(科室ID)
/// Return：
/// dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HISUICommon","DiagnosisLevel","152")
Query DiagnosisLevel(LocID As %String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod DiagnosisLevelExecute(ByRef qHandle As %Binary, LocID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s EDCRowId="0"
    f  s EDCRowId=$o(^DHCPEEDC(EDCRowId)) q:EDCRowId=""  d  
    .s Desc=$P($g(^DHCPEEDC(EDCRowId)),"^",2)
    .s LocShowDFlag=##class(User.DHCPEEDClass).GetLocShowDataFlag(EDCRowId,LocID)
    .q:LocShowDFlag'="Y"
    .s ^CacheTemp(repid,ind)=$lb(EDCRowId,Desc)
    .s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Creator：      xy
/// CreatDate：    20211115
/// Description:  查询特殊项目      
/// Input:        LocID(科室ID),StationID(站点ID),Item(项目描述)
/// dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HISUICommon",FindSpecialItem","","","")
Query FindSpecialItem(LocID As %String = "", StationID As %String = "", Item As %String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindSpecialItemExecute(ByRef qHandle As %Binary, LocID As %String = "", StationID As %String = "", Item As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    //s ^tempdhcpe("FindSpecialItem")=$lb(LocID,StationID,Item)
    if (LocID=""){
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    
    s ItemID=""
    f  s ItemID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,ItemID)) q:(ItemID="")  d
    .s ARCIMDR=$p($g(^DHCPEST($p(ItemID,"||",1),"O",$p(ItemID,"||",2))),"^",1)
    .s ArcDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ARCIMDR,"A",LocID)
    .q:(ArcDesc'[Item)&&(Item'="")
    .s OrdExID=0
    .f  s OrdExID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,ItemID,OrdExID)) q:(OrdExID="")  d
    ..s SpecialFlag=$lg($g(^CF.PE.StationOrderSetD(OrdExID)),20)
    ..q:SpecialFlag'="Y" //特殊检查
    ..// 根据医嘱项ID查找对应OrderDR（站点和项目组合ID）
    ..s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIMDR,LocID)
    ..s STRowId=$p(StatOrderID,"||",1)
    ..q:STRowId=""
    ..q:(StationID'="")&&(StationID'=STRowId)
    ..s Childsub=$p(StatOrderID,"||",2)
    ..q:""=Childsub
    ..d OutPutSpecialItem
    Set qHandle=$lb(0,repid,0) 
    Quit $$$OK
OutPutSpecialItem
    
    set Data=$lb(ARCIMDR,ArcDesc)  
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// Creator：      xy
/// CreatDate：    20211116
/// Description:  查询站点项目      
/// Input:       Station(站点ID),Desc(项目描述),LocID(科室ID), hospId(院区ID)
/// dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HISUICommon","FindStationOrder","","","F","152","2")
Query FindStationOrder(Station As %String = "", Desc As %String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As websys.Query(ROWSPEC = "id:%String,Code:%String,desc:%String")
{
}

ClassMethod FindStationOrderExecute(ByRef qHandle As %Binary, Station As %String = "", Desc As %String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s ^tempdhcpe("FindStationOrder1")=$lb(Station,Desc,Type,LocID,hospId)
    s STID=""
    s:Station'="" STID=$o(^DHCPEST(Station),-1)
    f  s STID=$o(^DHCPEST(STID)) q:STID=""  d
    .s STSub=0
    .f  s STSub=$o(^DHCPEST(STID,"O",STSub)) q:((STSub="")||((Station'="")&&(STID'=Station)))  d
    ..s TActive=$p($g(^DHCPEST(STID,"O",STSub)),"^",9)
    ..i TActive="" s TActive="Y"
    ..q:TActive'="Y"
    ..s ARCIMID=$p($g(^DHCPEST(STID,"O",STSub)),"^",1)
    ..s Itemdesc=$p($g(^ARCIM($p(ARCIMID,"||",1),$p(ARCIMID,"||",2),1)),"^",2)
    ..q:(Desc'="")&&(Itemdesc'[Desc)
    ..s Code=$p(^ARCIM($p(ARCIMID,"||",1),$p(ARCIMID,"||",2),1),"^",1)
    ..s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("ARC_ItmMast",ARCIMID,Type,LocID)
    ..q:DateShowFlag="Y"
    ..s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",ARCIMID,hospId)
    ..q:(HOSPshowFlag="N")
    ..s LocShowDFlag=##class(User.DHCPEStationOrder).GetLocShowDataFlag(STID_"||"_STSub,LocID)
    ..q:LocShowDFlag="N"
    ..s Itemdesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",Itemdesc,"ARCIMDesc","cls")
    ..s ^CacheTemp(repid,ind)=$lb(ARCIMID,Code,Itemdesc)
    ..s ind=ind+1
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Creator：      xy
/// CreatDate：    20211122
/// Description:  查询所有细项（科室下授权的）
/// Table：       细项表 DHC_PE_OrderDetail
/// Input:        LocID(科室ID)
/// Return：
/// Dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HISUICommon","FindOrderDetail","","152")
Query FindOrderDetail(Desc As %String = "", LocID As %String = "") As websys.Query(ROWSPEC = "TODID,TStationName,TODDesc,TODCode,TODTypeDR,TODType,TODDescNew")
{
}

ClassMethod FindOrderDetailExecute(ByRef qHandle As %Binary, Desc As %String = "", LocID As %String = "") As %Status
{
    s ^tempdhcpe("FindOrderDetail",LocID)=$lb(Desc,LocID)
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 

    
    s Desc=##class(web.DHCPE.DHCPECommon).UnEscape(Desc)

   
    s StationDR=0
    f  s StationDR=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,StationDR))  q:StationDR=""   d
    .s LocPowerFlg = ##class(User.DHCPEStation).GetLocShowDataFlag(StationDR,LocID)
    .q:LocPowerFlg'="Y" 
    .s id=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,StationDR,0))  
    .s Active=$lg($g(^CF.PE.StationSetD(id)),11)
    .q:Active'="Y"

    .s ODChildSub=0  //不能使用空字符串开始 s id="" ,否则会取到 0
    .f  s ODChildSub=$o(^DHCPEST(StationDR,"OD",ODChildSub))   q:ODChildSub=""  d
    ..s ODRowID=StationDR_"||"_ODChildSub
    ..s StationName=$p($g(^DHCPEST(StationDR)),"^",2)
    ..s ODDesc=$p($g(^DHCPEST(StationDR,"OD",ODChildSub)),"^",1)
    ..q:(ODDesc'[Desc)&&(Desc'="")
    ..s ODCode=$p($g(^DHCPEST(StationDR,"OD",ODChildSub)),"^",11)
    ..s ODTypeDR=$p($g(^DHCPEST(StationDR,"OD",ODChildSub)),"^",2)
    ..s ODType=""
    ..i ODTypeDR'="" s ODType=##class(web.DHCPE.CT.StatOrderDetail).GetODType(ODTypeDR)
    ..s LocShowDFlag=##class(User.DHCPEOrderDetail).GetLocShowDataFlag(ODRowID,LocID)
    ..q:LocShowDFlag'="Y"
    ..s ODDescNew=ODDesc_"("_ODCode_","_StationName_")"
    ..s ^CacheTemp(repid,ind)=$lb(ODRowID,StationName,ODDesc,ODCode,ODTypeDR,ODType,ODDescNew)
    ..s ind=ind+1
     
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Creator：      xy
/// CreatDate：    20211123
/// Description:  查询所有疾病（科室下授权的）
/// Table：       疾病表 DHC_PE_IllnessStandard
/// Input:        Desc(别名/编码/描述),LocID(科室ID)
/// Dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HISUICommon","FindILLByAlias","","152")
Query FindILLByAlias(Desc As %String = "", LocID As %String = "") As websys.Query(ROWSPEC = "HIDDEN:%String, Detail:%String:疾病名称, DiagnoseConclusion:%String:疾病建议, Code:%String:编码")
{
}

ClassMethod FindILLByAliasExecute(ByRef qHandle As %Binary, Desc As %String = "", LocID As %String = "") As %Status
{
    s ^tempdhcpe("FindILLByAlias")=$lb(Desc,LocID)
    Set repid=$I(^CacheTemp)
    i Desc'="" s Desc=$ZCVT(Desc,"U")
    s CurUser=%session.Get("LOGON.USERID")
    s ind=1
    i Desc=""
    {
        s EDID=0
        f  s EDID=$o(^DHCPEILLS(EDID)) q:EDID=""  d
        .s RowId=EDID
        .s User=$p($g(^DHCPEILLS(EDID)),"^",4)
        .q:(User'="")&&(User'=CurUser)
        .d SetDataILLByAlias
        
    }
    else
    {
        //别名
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
        ..d SetDataILLByAlias
        
        //编码
        s TextDesc=$O(^DHCPEILLS(0,"CODE",Desc),-1)
        f  s TextDesc=$O(^DHCPEILLS(0,"CODE",TextDesc)) Q:((""=TextDesc)||(TextDesc'[Desc))  d
        .s RowId=0
        .f  s RowId=$O(^DHCPEILLS(0,"CODE",TextDesc,RowId)) q:RowId=""  d
        ..q:RowId=""
        ..q:RowIds[("^"_RowId_"^")
        ..s RowIds=RowIds_RowId_"^"
        ..s User=$p($g(^DHCPEILLS(RowId)),"^",4)
        ..q:(User'="")&&(User'=CurUser)
        ..d SetDataILLByAlias
        
        //描述
        s TextDesc=$O(^DHCPEILLS(0,"Desc",Desc),-1)
        f  s TextDesc=$O(^DHCPEILLS(0,"Desc",TextDesc)) Q:(""=TextDesc)||(TextDesc'[Desc)  d
        .s RowId=0
        .f  s RowId=$O(^DHCPEILLS(0,"Desc",TextDesc,RowId)) q:RowId=""  d
        ..q:RowId=""
        ..q:RowIds[("^"_RowId_"^")
        ..s RowIds=RowIds_RowId_"^"
        ..s User=$p($g(^DHCPEILLS(RowId)),"^",4)
        ..q:(User'="")&&(User'=CurUser)
        ..d SetDataILLByAlias
     
    }
   
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
SetDataILLByAlias
    s (Detail,DC,Code)=""
    q:RowId=""
    s Detail=$P($G(^DHCPEILLS(RowId)),"^",3)
    s DC=$P($G(^DHCPEILLS(RowId)),"^",2)
    s Code=$P($G(^DHCPEILLS(RowId)),"^",1)
    s LocShowDFlag=##class(User.DHCPEIllnessStandard).GetLocShowDataFlag(RowId,LocID)
    q:LocShowDFlag'="Y"
    d GetILLByAlias
    q
    
GetILLByAlias  
    set Data=$lb(RowId, DC, Detail, Code)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// Creator：      xy
/// CreatDate：    20211126
/// Description:  查询问卷级别（科室下授权的）
/// Table：       问卷级别表 User.DHCHMCServiceClass
/// Input:        LocID(科室ID)
/// Dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HISUICommon","FindHMService",152)
Query FindHMService(LocID) As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindHMServiceExecute(ByRef qHandle As %Binary, LocID) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s id=0
    f  s id=$o(^User.DHCHMCServiceClassD(id)) q:(id="")  d
    .s powerFlg = ##class(User.DHCHMCServiceClass).GetLocShowDataFlag(id,LocID)
    .q:powerFlg'="Y"
    .s Code=$lg(^User.DHCHMCServiceClassD(id),3)
    .s Desc=$lg(^User.DHCHMCServiceClassD(id),4)
    .s Active=$lg(^User.DHCHMCServiceClassD(id),2)
    .q:Active="N"
    .s ^CacheTemp(repid,ind)=$lb(id,Desc)
    .s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Creator：    xy
/// CreatDate：  20220328
/// Description: 查询高危信息
/// Table： 
/// Input:      OrderItemID(医嘱ID),PAADM(就诊ID)
/// Dubug: w ##class(%ResultSet).RunQuery("web.DHCPE.CT.HISUICommon","FindAdviceByOrder","1025||1","1095")
Query FindAdviceByOrder(OrderItemID As %Library.String = "", PAADM As %Library.String = "") As websys.Query(ROWSPEC = "AdviceInfo:%String")
{
}

ClassMethod FindAdviceByOrderExecute(ByRef qHandle As %Binary, OrderItemID As %Library.String = "", PAADM As %Library.String = "") As %Status
{
    //s ^tempdhcpe("FindAdviceByOrder")=$lb(OrderItemID,PAADM)
    Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    q:(OrderItemID="")&&(PAADM="") $$$OK
    i OrderItemID'=""
    {
        s PAADM=$P($g(^OEORD(+OrderItemID)),"^",1)
        s LocID=$P($g(^PAADM(PAADM)),"^",4)
        s ArcimID=$P($g(^OEORD(+OrderItemID,"I",$P(OrderItemID,"||",2),1)),"^",2)
        s STID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
        s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcimID,LocID)
        q:StatOrderDR="" $$$OK
        s STID=$p(StatOrderDR,"||",1)
        q:STID="" $$$OK
        s SSID=##class(web.DHCPE.ResultEdit).GetSSId(PAADM, STID)
        q:SSID="" $$$OK
        s Sub=""
        f  s Sub=$O(^DHCPESS(SSID,"Diagnosis",Sub)) q:Sub=""  d
        .s SDID=SSID_"||"_Sub
        .s DisplayDesc=$G(^DHCPEDataEx("DHCPESSDiagnosis","DisplayDesc",SDID))
        .s Advice=$P($g(^DHCPESS(SSID,"Diagnosis",Sub)),"^",7)
        .q:(DisplayDesc="")&&(Advice="")
        .s OneInfo=DisplayDesc_":"_Advice
        .d FindAdviceByOrder
    }
    else
    {
        s LocID=$P($g(^PAADM(PAADM)),"^",4)
        s SSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
        q:SSID="" $$$OK
        s Sub=""
        f  s Sub=$O(^DHCPEGS(SSID,"Diagnosis",Sub)) q:Sub=""  d
        .s SDID=SSID_"||"_Sub
        .s Status=$P($g(^DHCPEGS(SSID,"Diagnosis",Sub)),"^",11)
        .q:Status'="0"
        .s DisplayDesc=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",SDID))
        .s Advice=$P($g(^DHCPEGS(SSID,"Diagnosis",Sub)),"^",9)
        .q:(DisplayDesc="")&&(Advice="")
        .s OneInfo=DisplayDesc_":"_Advice
        .d FindAdviceByOrder
    }
    q $$$OK

FindAdviceByOrder
    set Data=$lb(OneInfo)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// Creator：    xy
/// CreatDate：  20221010
/// Description: 获取体检退费支付方式
/// Input:       LocID(科室ID),PayModeID(收费支付方式ID)
/// Dubug:  w ##class(%ResultSet).RunQuery("web.DHCPE.CT.HISUICommon","FindRefundPayMode","105","1")
Query FindRefundPayMode(LocID As %String = "", PayModeID As %String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindRefundPayModeExecute(ByRef qHandle As %Binary, LocID As %String = "", PayModeID As %String = "") As %Status
{
    s ^TMP("DHCPE","FindRefundPayMode")=$lb(LocID,PayModeID)
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    if (LocID=""){
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    if (PayModeID=""){ 
        s CTPMRowId=0
        f  s CTPMRowId=$o(^CT("CTPM",CTPMRowId))  q:CTPMRowId=""  d
        .s CTPMDesc=$p(^CT("CTPM",CTPMRowId),"^",2)
        .s CTPMCode=$p(^CT("CTPM",CTPMRowId),"^",1)
        .q:$g(^DHCPESetting("DHCPE","CashierMode",LocID,CTPMRowId))'="Y"
        .s CTPMCode=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTPayMode",CTPMCode,"CTPMDesc","cls")
        .d FindRefundPayModeBuild 
        
    }else{
        s CTPMRowId=0
        f  s CTPMRowId=$o(^CT("CTPM",CTPMRowId))  q:CTPMRowId=""  d
        .s CTPMDesc=$p(^CT("CTPM",CTPMRowId),"^",2)
        .s CTPMCode=$p(^CT("CTPM",CTPMRowId),"^",1)
        .q:(PayModeID'=CTPMRowId)&&(CTPMDesc'="现金")
        .s CTPMCode=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTPayMode",CTPMCode,"CTPMDesc","cls")
        .d FindRefundPayModeBuild 
    }
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
FindRefundPayModeBuild 
    s ^CacheTemp(repid,ind)=$lb(CTPMRowId,CTPMDesc)
    s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Creator：    xy
/// CreatDate：  20221010
/// Description: 获取体检收费支付方式
/// Input:       LocID(科室ID)
/// Dubug:  w ##class(%ResultSet).RunQuery("web.DHCPE.CT.HISUICommon","FindTJPayMode","105")
Query FindTJPayMode(LocID As %String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindTJPayModeExecute(ByRef qHandle As %Binary, LocID As %String = "") As %Status
{
    s ^TMP("DHCPE","FindTJPayMode")=$lb(LocID)
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s CTPMRowId=0
    f  s CTPMRowId=$o(^CT("CTPM",CTPMRowId))  q:CTPMRowId=""  d
    .s CTPMDesc=$p(^CT("CTPM",CTPMRowId),"^",2)
    .s CTPMCode=$p(^CT("CTPM",CTPMRowId),"^",1)
    .s CTPMCode=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTPayMode",CTPMCode,"CTPMDesc","cls")
    .d FindTJPayModeBuild 
    
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
FindTJPayModeBuild
    s ^CacheTemp(repid,ind)=$lb(CTPMRowId,CTPMDesc)
    s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Creator：    xy 
/// CreatDate：  20230310
/// Description: 根据应用程序、参数获取相对应的参数值（体检参数配置）
/// Table：      参数配置：应用程序表:DHC_PE_SettingsApp，参数:DHC_PE_SettingsParam，参数值:DHC_PE_SettingsValue
/// Input:       appcode:应用程序参数，Paramcode：参数，ValueType：类型
/// Return：     获取某一个应用程序下某个类型下的参数值
/// debug: w ##class(web.DHCPE.CT.HISUICommon).GetValueByCode("GSKeyWord","FKeyWord","C")
ClassMethod GetValueByCode(appcode As %String = "", Paramcode As %String = "", ValueType As %String = "")
{
	q:(appcode="")||(Paramcode="")||(ValueType="") ""
	s ParamValueStr=""
	
	s appId=$o(^DHCPESettingsApp(0,"Code",appcode,0))
	q:appId="" ""
	
	s SPDR=$o(^DHCPESettingsParam(0,"APPCode",appId,Paramcode,0))
	q:SPDR="" ""
	
	s ValueCode=""
	f  s ValueCode=$o(^DHCPESettingsValue(0,"ParamTV",SPDR,"Type",ValueType,ValueCode))  q:ValueCode=""  d
	.s ValueID=""
	.f  s ValueID=$o(^DHCPESettingsValue(0,"ParamTV",SPDR,"Type",ValueType,ValueCode,ValueID))  q:ValueID=""  d
	..s ParamValue=$p(^DHCPESettingsValue(ValueID),"^",4)
	..i ParamValueStr="" s ParamValueStr=ParamValue
	..e  s ParamValueStr=ParamValueStr_"^"_ParamValue
	
	q ParamValueStr
}

/// Description：获取客户端拍照参数
/// Input:   		
/// Return:		
/// 			{}
/// Creator:	wangguoying
/// CreateDate:	2023-03-13
/// Debug: w ##class(web.DHCPE.CT.HISUICommon).GetCameramParam("PREIADM")
ClassMethod GetCameramParam(ParamVal)
{
	s paramJson = {}
	s cutObj = {}
	s rs=##class(%ResultSet).%New("web.DHCPE.Settings.Value:QueryValue") 
	d rs.Execute("CameraParam",ParamVal,"C")
	s flag = 0
	while(rs.Next()){
		s:flag=0 flag = 1
		s key = rs.Get("SVTypeValue")
		s val = rs.Get("SVParamValue")
		if ($P(key,"-",1)="cut"){
			d cutObj.%Set($P(key,"-",2),val)
		}else{
			d paramJson.%Set(key,val)
		}
	}
	do:flag=1 paramJson.%Set("cutConfig",cutObj)
	q paramJson.%ToJSON()
}

}
