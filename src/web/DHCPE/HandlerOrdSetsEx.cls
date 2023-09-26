/// Created by SongDeBo 2006/6/6
/// Description: 对有关DHC_PE_OrdSetsEx的简单处理,如查询
Class web.DHCPE.HandlerOrdSetsEx Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

/// 功能：查询套餐子项
/// parameter:  
///             AdmType: "TEAM"/"PERSON"
/// d ##class(%ResultSet).RunQuery("web.DHCPE.HandlerOrdSetsEx","queryOrdSet","","ItemSet")
Query queryOrdSet(Set As %String = "", Type As %String = "", AdmId As %String = "", TargetFrame As %String = "", OrdSetSDesc As %String = "", BType As %String = "", LocID As %String = "", hospId As %String = "", UserID As %String = "", VIPType As %String = "") As %Query(ROWSPEC = "OrderSetId:%String:ID,OrderSetDesc:%String:名称,IsBreakable:%String:是否拆分,OrderSetPrice:%String:价格")
{
}

ClassMethod queryOrdSetExecute(ByRef qHandle As %Binary, Set As %String = "", Type As %String = "", AdmId As %String = "", TargetFrame As %String = "", OrdSetSDesc As %String = "", BType As %String = "", LocID As %String = "", hospId As %String = "", UserID As %String = "", VIPType As %String = "") As %Status
{
        s ^tempdhcpe("param")=$lb(Set,Type,AdmId,TargetFrame,OrdSetSDesc,BType,LocID,hospId,UserID,VIPType)
    
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    if ((Set="")&&(Type="")&&(AdmId="")&&(TargetFrame="")){
     Set qHandle=$lb(0,repid,0)
    Quit $$$OK  
    }
    s vPatFeeType=""
    s orderSetDesc=##class(web.DHCPE.DHCPECommon).UnEscape(Set)
    s orderSetDesc=$ZCVT(orderSetDesc,"U")
    
    //s PELabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
    s PELabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))
    s PECodePrefix=^DHCPESetting("DHCPE","PEItemCodePrefix")
    s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
    
    //s vVIPID=$G(^DHCPEVIPLevel("VIPapprove"))
    //s vPatFeeType=##class(web.DHCPE.VIPLevel).GetPatFeeType(vVIPID)
    
    //获取科室默认的VIP等级
    s vVIPID=##class(web.DHCPE.PreIBIUpdate).GetVIPLevel(LocID)
    
    //获取客户VIP等级对应的病人类型
    s vPatFeeType=##class(web.DHCPE.VIPLevel).GetPatFeeType(vVIPID,LocID)
    
    s AdmId=$P(AdmId,"^",1)
    i AdmId'="" d
    .i $L(AdmId,"||")>1 d
    ..s vVIPID=^DHCPECBVIPLevel("PGT",AdmId)
    ..i vVIPID'="" d
    ..s vPatFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",AdmId))
    ..
    ..s AdmSex=$p($g(^DHCPEPreGADM(+AdmId,"Team",$p(AdmId,"||",2))),"^",12) // 分组对应性别
    ..s:AdmSex="M" AdmSex=1
    ..s:AdmSex="F" AdmSex=2
    ..
    ..s AdmPreGBI=$p($g(^DHCPEPreGADM(+AdmId)),"^",1) 
    ..s IOG="G"
    .e  d
    ..s vVIPID=##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",AdmId)
    ..s vVIPID=$P(vVIPID,"^",1)
    ..i vVIPID'="" d
    ..s vPatFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",AdmId))
    ..s AdmSex=$p($g(^DHCPEPreIBI(+$g(^DHCPEPreIADM(AdmId)))),"^",3) // 性别
    ..s PreGAdm=$p($g(^DHCPEPreIADM(AdmId)),"^",2)
    ..s AdmPreGBI=""
    ..i PreGAdm'="" s AdmPreGBI=$p($g(^DHCPEPreGADM(PreGAdm)),"^",1) 
    ..s IOG="I"
    e  d
    .s vVIPID=""
    .i VIPType'="" s vVIPID=VIPType
    .s vPatFeeType=""
    .s AdmSex=""
    .s AdmPreGBI=""
    .s IOG=""

    //s AdmSex=##class(web.DHCPE.PreItemList).JustAdmSex(AdmId)
    s Sort=""
    f  s Sort=$o(^DHCPEItemSort("Set",Sort)) q:Sort=""  d
    .s Sub=0
    .f  s Sub=$o(^DHCPEItemSort("Set",Sort,Sub)) q:Sub=""  d
    ..s Flag=0
    ..s SetId=$G(^DHCPEItemSort("Set",Sort,Sub))
    ..s ST=$O(^DHCPEST(0,"STORD_ARCOS",SetId,0))
    ..i ST=PELabStation s Flag=1
    ..q:(ST=PELabStation)&&(Type'="Lab")&&(Type'="")
    ..q:(ST'=PELabStation)&&(Type="Lab")&&(Type'="")
    ..d GetOneInfo
    
    i PELabStation'="" d
    .s Sub=0
    .f  s Sub=$o(^DHCPEST(PELabStation,"O",Sub)) q:(Sub="")||(TrakVerison'="MedTrak")||((Type'="")&&(Type="ItemSet"))  d
    ..s Flag=1
    ..s iARCIMDR=$p($g(^DHCPEST(PELabStation,"O",Sub)),"^",1)
    ..s SetId=$p($g(^DHCPEST(PELabStation,"O",Sub)),"^",3)
    ..s CurSort=$G(^DHCPEItemSort("Sort","Set",SetId))
    ..q:CurSort'=""
    ..d GetOneInfo
    
    //修改体检子类下套餐
    s ItemCatId=$o(^ARC("IC",0,"Desc","体检医嘱套",0))
    i ItemCatId'=""
    {
    s SetId="0"
    f  s SetId=$o(^ARCOS(0,"ItemCat",ItemCatId,SetId)) q:(SetId="")||((Type'="")&&(Type="Lab"))  d
    .
    .s Flag=0
    .s CurSort=$G(^DHCPEItemSort("Sort","Set",SetId))
    .q:CurSort'=""
    .//DHC_UserFavItems 
    .s TJFavRowId=$O(^DHCFavItems(0,"ItemRowid",SetId,"")) 
    .s TJFavUserDr=""
    .i TJFavRowId'="" s TJFavUserDr=$p($g(^DHCFavItems(TJFavRowId)),"^",2)
    .q:(TJFavUserDr'="")&&(TJFavUserDr'=UserID)
    .s TJFavHospDr="",TJFavDepDr="",TJFavUseHospDr=""
    .i TJFavRowId'="" d 
    ..s TJFavHospDr=$p($g(^DHCFavItems(TJFavRowId)),"^",9)
    ..s TJFavDepDr=$p($g(^DHCFavItems(TJFavRowId)),"^",4)
    ..s TJFavUseHospDr=$p($g(^DHCFavItems(TJFavRowId)),"^",11)
    .;q:(TJFavUserDr="")&&(TJFavDepDr="")&&(TJFavHospDr'=hospId)
    .q:TJFavHospDr'=""
    .q:(TJFavHospDr="")&&(TJFavUserDr="")&&(TJFavDepDr="")
    .d GetOneInfo
    }
    else
    {
    s SetId="0"
    f  s SetId=$o(^ARCOS(SetId)) q:(SetId="")||((Type'="")&&(Type="Lab"))  d
    .s Flag=0
    .s CurSort=$G(^DHCPEItemSort("Sort","Set",SetId))
    .q:CurSort'=""
    .//DHC_UserFavItems 
    .s TJFavRowId=$O(^DHCFavItems(0,"ItemRowid",SetId,"")) 
    .s TJFavUserDr=""
    .i TJFavRowId'="" s TJFavUserDr=$p($g(^DHCFavItems(TJFavRowId)),"^",2)
    .q:(TJFavUserDr'="")&&(TJFavUserDr'=UserID)
    .s TJFavHospDr="",TJFavDepDr="",TJFavUseHospDr=""
    .i TJFavRowId'="" d 
    ..s TJFavHospDr=$p($g(^DHCFavItems(TJFavRowId)),"^",9)
    ..s TJFavDepDr=$p($g(^DHCFavItems(TJFavRowId)),"^",4)
    ..s TJFavUseHospDr=$p($g(^DHCFavItems(TJFavRowId)),"^",11)
    .;q:(TJFavUserDr="")&&(TJFavDepDr="")&&(TJFavHospDr'=hospId)
    .q:TJFavHospDr'=""
    .q:(TJFavHospDr="")&&(TJFavUserDr="")&&(TJFavDepDr="")
    .d GetOneInfo
     }
    s sort=""
    f {
        s sort=$o(tempShowOrdSets(sort))
        q:sort=""
    
        s freq=""
        f {
            s freq=$o(tempShowOrdSets(sort,freq))
            q:freq=""
            
            s osid=""
            f {
                s osid=$o(tempShowOrdSets(sort,freq,osid))
                q:osid=""
                
                s rowData=$g(tempShowOrdSets(sort,freq,osid))
                do OutputRow1
            }
        }
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
GetOneInfo
    s myStr=$g(^ARCOS(SetId))
    Q:(""=myStr)
    
    // ARC_OrdSets 判断医嘱套有效期
    s datefrom=$p(myStr,"^",15)
    q:((datefrom'="")&&(+datefrom>+$h))
    s dateto=$p(myStr,"^",16)
    q:((dateto'="")&&(+dateto<+$h))
    
    s OSEID=$o(^DHCPEOSE(0,"OrdSets",SetId,"")) // 体检医嘱套扩展表
    q:(""=OSEID)
    
    s Disable=$p($g(^DHCPEOSE(OSEID)),"^",16) //套餐启用/禁用判断
    q:Disable="Y"   

    s SetSexDr=$p($g(^DHCPEOSE(OSEID)),"^",3)
    q:((AdmSex'="")&&(SetSexDr'="")&&(AdmSex'=SetSexDr)) // 性别判断
    s SetVIP=$p($g(^DHCPEOSE(OSEID)),"^",6)
    
    q:((vVIPID'="")&&(SetVIP'="")&&((","_SetVIP_",")'[(","_vVIPID_","))) // VIP等级判断
    s SetPGBI=$p($g(^DHCPEOSE(OSEID)),"^",10) 
    q:((IOG="G")&&(SetPGBI'="UN")&&(SetPGBI'="")&&(AdmPreGBI'=SetPGBI)) // 可用团体判断 团体分组
    q:((IOG="I")&&(SetPGBI'="UN")&&(SetPGBI'="")&&((AdmPreGBI="")||((AdmPreGBI'="")&&(AdmPreGBI'=SetPGBI)))) // 可用团体判断 个人
    
    // DHC_PE_OrdSetsEx 判断有效期
    s DateBeg=$p($g(^DHCPEOSE(OSEID)),"^",8)
    q:((DateBeg'="")&&(+DateBeg>+$h))
    s DateEnd=$p($g(^DHCPEOSE(OSEID)),"^",9)
    q:((DateEnd'="")&&(+DateEnd<+$h))
    
    s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_OrdSets",SetId,hospId)
    q:(HOSPshowFlag="N")
    
    s OSExData=##class(web.DHCPE.CT.OrderSets).GetARCOSData(SetId)
    s OSExObj={}.%FromJSON(OSExData)    
    q:OSExObj.LocId'=LocID  //按照套餐科室过滤
    
    i Flag=0 {
        s LocFlag=0
        i (TJFavDepDr'="")&&(TJFavDepDr'=LocID) s LocFlag=1 //按照套餐维护的科室过滤 可用科室功能去掉
        //s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("ORDSET",OSEID)
        //s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("ORDSET",SetId)
    } else {
        s StationID=0
        s StationID=$O(^DHCPEST(0,"STORD_ARCOS",SetId,0))
        q:StationID=""
        s ItemChildSub=$O(^DHCPEST(0,"STORD_ARCOS",SetId,StationID,0))
        s ItemID=StationID_"||"_ItemChildSub
        s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("ITEM",ItemID)
    }
    q:LocFlag=1  
    
    If $d(^DHCPESetting("DHCPEBaseData","PEARCOS",SetId))=1 Set Flag=1
    
    
    s myCode="", myDesc="",myDescU="",myBreakable="", mySetId=""
    s myCode=$p(myStr,"^",1)
    s myDesc=$p(myStr,"^",2)
    i myDesc'="" s myDescU=$ZCVT(myDesc,"U")
    S OrdSubCatDR=$p(myStr,"^",9)
    q:(orderSetDesc'="")&&(myDescU'[orderSetDesc)
    S ARCICDesc=""
    S:OrdSubCatDR'="" ARCICDesc=$p($g(^ARC("IC",OrdSubCatDR)),"^",2)
    q:ARCICDesc'["体检医嘱套"
    
    /*
    s SetSexDesc=""
    S SetSexID=$g(^DHCPEDataEx("DHCPEBaseData","Sex",SetId))
    i SetSexID'="" s SetSexDesc=$P($G(^CT("SEX",SetSexID)),"^",2)

    q:(myCode'[vVIPID)&&(vVIPID'="")
    //q:(myCode["IP")&&(vVIPID'["IP")&&(vVIPID'="")
    q:(AdmSex'=SetSexDesc)&&(SetSexDesc'="")&&(AdmId'="")
    
    */
    //q:($extract(myCode,1,$l(PECodePrefix))'=PECodePrefix)&&(Flag=0)
    
    
    s ALIASRowId="0"
    s Flag=0
    f  s ALIASRowId=$O(^ARC("ALIAS",0,"ARCOS",SetId,ALIASRowId)) q:ALIASRowId=""  d
    .// ARC_Alias.ALIAS_Text
    .s ALIAS=""
    .s:(""'=ALIASRowId) ALIAS=$P($G(^ARC("ALIAS",ALIASRowId)),"^",6)
    .s ALIAS=$ZCVT(ALIAS,"U")
    .s:((""'=orderSetDesc)&(ALIAS[orderSetDesc)) Flag=1 
    s:((""'=orderSetDesc)&(myDescU[orderSetDesc)) Flag=1 
    i orderSetDesc="" s Flag=1
    q:Flag=0
    
    s mySetId=SetId
    ;q:'$D(^DHCPEDataEx("DHCPEBaseData","taritem",mySetId))
    
    s mySetExId=$o(^DHCPEOSE(0,"OrdSets",mySetId,"0"))
    i mySetExId'="" s myBreakable=$p($g(^DHCPEOSE(mySetExId)),"^",2)
    i $G(myBreakable)=""  s myBreakable="Y"
    
    //s:(""'=iARCIMDR)&&(Flag=1) ItemSetPrice=##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(iARCIMDR)
    //s:(""'=SetId)&&(Flag=0) ItemSetPrice=##class(web.DHCPE.Handle.ARCOrdSets).GetPrice(SetId)
    //s:""'=SetId ItemSetPrice=##class(web.DHCPE.Handle.ARCOrdSets).GetPrice(SetId)
    s:""'=SetId ItemSetPrice=##class(web.DHCPE.Handle.ARCOrdSets).GetPrice(SetId,"","","",BType,LocID,hospId)
    i ItemSetPrice="" s ItemSetPrice=0
    
    // 显示顺序
    s Sort=$p($g(^DHCPEOSE(OSEID)),"^",14)
    s:Sort="" Sort="z"
    // 使用频次
    s Frequency=$p($g(^DHCPEOSE(OSEID)),"^",15)
    s:Frequency="" Frequency="z"
    
    s tempShowOrdSets(Sort,Frequency,mySetId)=$lb(mySetId, myDesc, myBreakable, $j(ItemSetPrice,"",2))
    q
    
OutputRow1
    set Data=rowData
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod queryOrdSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = queryOrdSetExecute ]
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

ClassMethod queryOrdSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = queryOrdSetExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
