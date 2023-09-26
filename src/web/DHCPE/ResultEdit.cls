Import SQLUSER

Class web.DHCPE.ResultEdit Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

/// Debug:  w ##class(web.DHCPE.ResultEdit).CheckEpisodeID(63990,"12528||1")
/// Return: 0:the AdmPerson can input result;  1:can not input result.
ClassMethod CheckEpisodeID(EpisodeID As %String, OEORIRowId As %String) As %Status
{
    Quit:$g(EpisodeID)="" 1
    Quit:$g(OEORIRowId)="" 1
    s Ord=$p(OEORIRowId,"||",1)
    s OrdItem=$p(OEORIRowId,"||",2)
    
    s PEIAdmId=$o(^DHCPEIADM(0,"PAADM",EpisodeID,""))
    q:PEIAdmId="" 1
    s AdmAsCharged=$p($g(^DHCPEIADM(PEIAdmId)),"^",8)
    s AdmStatus=$p($g(^DHCPEIADM(PEIAdmId)),"^",9)
    s ResultableStatuses=^DHCPESetting("DHCPE","IAdmStatuses_Resultable")
    s Paid=$P($g(^OEORD(Ord,"I",OrdItem,3)),"^",5)
    i (AdmAsCharged="Y")&(ResultableStatuses[("^"_AdmStatus_"^"))  s Paid="P"
    q:Paid="P" 0
    s ItemStat=$P($g(^OEORD(Ord,"I",OrdItem,1)),"^",13)
    q:((ItemStat'=1)&(ItemStat'=6)) 0
    q 1
}

// ##class(web.DHCPE.ResultEdit).GetODTemplate("2||15||8")

ClassMethod CreatElement1(ItemID As %String, ItemColName As %String, ItemValue As %String) As %String
{
    Quit:$g(ItemColName)="" ""
    Quit:$g(ItemID)="" ""
    //
    set AddtionStr=""
    set ItemLabCode=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",10)
    if $g(ItemLabCode)'=""  s AddtionStr=" disabled=true "
    Set ItemType=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",2)
    If ItemType="N" Do TextBox Quit ""
    If ItemType="C" Do ComputeBox Quit ""
    If ItemType="T" Do
    .Set ValueId=0
    .Set ValueCount=0
    .For  Set ValueId=$O(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",ValueId)) Quit:ValueId=""  Do
    ..Set ValueCount=ValueCount+1
    .If ValueCount>0 Do SelectBox
    .Else  Do TextBox
    Quit ""
ComputeBox
    Write "<input disabled=true id='"_ItemColName_"' name='"_ItemColName_"' "
    Write " style='WIDTH: 104px; HEIGHT: 24px' value='"_ItemValue_"'>"
    Quit
TextBox
    Write "<input id='"_ItemColName_"' name='"_ItemColName_"' "
    Write " style='WIDTH: 104px; HEIGHT: 24px' value='"_ItemValue_"' "_AddtionStr_">"
    Quit
SelectBox
    Write "<select id='"_ItemColName_"' name='"_ItemColName_"' size=1 style='WIDTH: 104px; HEIGHT: 24px'"_AddtionStr_">"
    Write "<option  value=''></option>"
    Set Chl=0
    For  Set Chl=$O(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl)) Quit:Chl=""  Do
    .Set ListVal=$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl),"^",2)
    .If ListVal=ItemValue Write "<option value="_ListVal_" selected>"_ListVal_"</option>"
    .Else  Write "<option value="_ListVal_">"_ListVal_"</option>"
    Write "</select>"
    Quit
}

ClassMethod CreatElement(ItemID As %String, ItemColName As %String, ItemValue As %String) As %String
{
    Quit:$g(ItemColName)="" ""
    Quit:$g(ItemID)="" ""
    set AddtionStr=""
    set ItemLabCode=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",10)
    
    if $g(ItemLabCode)'=""  s AddtionStr=" readOnly=true "
    Set ItemType=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",2)
    If ItemType="N" Do NumBox Quit ""
    If ItemType="T" Do TextBox Quit ""
    If ItemType="C" Do ComputeBox Quit ""
    If ItemType="S" Do SelectBox Quit ""
     If ItemType="A"    Do TextAreaBox Quit ""
    //If ItemType="S"   Do TextBox Quit ""
    /*
    If ItemType="T" Do 
    .Set ValueId=0
    .Set ValueCount=0
    .For  Set ValueId=$O(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",ValueId)) Quit:ValueId=""  Do
    ..Set ValueCount=ValueCount+1
    .If ValueCount>0 Do SelectBox
    .Else  Do TextBox
    */
    Quit ""
ComputeBox
    Write "<input readOnly=true onkeydown='nextfocus(this);' id='"_ItemColName_"' name='"_ItemColName_"' "
    Write " style='WIDTH: 100%; HEIGHT: 24px' value='"_ItemValue_"'>"
    Quit
TextBox
    Write "<input onkeydown='nextfocus(this);' onclick='detailStandard(this);' id='"_ItemColName_"' name='"_ItemColName_"' "
    Write " style='WIDTH: 100%; HEIGHT: 24px' value='"_ItemValue_"' "_AddtionStr_">"
    Quit
TextAreaBox
    Write "<textarea onkeydown='nextfocus(this);' onclick='detailStandard(this);' id='"_ItemColName_"' name='"_ItemColName_"' "
    Write " style='WIDTH: 100%; HEIGHT: 48px' "_AddtionStr_">"_ItemValue_"</textarea>"
    Quit
NumBox
    Write "<input onkeydown='nextfocus(this);' id='"_ItemColName_"' name='"_ItemColName_"' "
    Write " style='WIDTH: 100%; HEIGHT: 24px' value='"_ItemValue_"' "_AddtionStr_">"
    Quit
SelectBox  //readOnly=true 
    Write "<input onkeydown='nextfocus(this);' onclick='detailStandard(this);' id='"_ItemColName_"' name='"_ItemColName_"' "
    Write " style='WIDTH: 100%; HEIGHT: 24px' value='"_ItemValue_"'>"
    Quit
    /*
    Write "<select id='"_ItemColName_"' name='"_ItemColName_"' size=1 style='WIDTH: 260px; HEIGHT: 24px'"_AddtionStr_">"
    Write "<option  value=''></option>"
    Set Chl=0
    For  Set Chl=$O(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl)) Quit:Chl=""  Do
    .Set ListVal=$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl),"^",2)
    .If ListVal=ItemValue Write "<option value="_ListVal_" selected>"_ListVal_"</option>"
    .Else  Write "<option value="_ListVal_">"_ListVal_"</option>"
    Write "</select>"
    Quit*/
}

ClassMethod CreateEDElement(ODID, OrdItemID, RLTID As %String = "")
{
    if RLTID'="" d
    .s ODID=$P(^DHCPERLT(RLTID),"^",3)
    .s OrdItemID=$P(^DHCPERLT(RLTID),"^",9)
    s ID="ED"_ODID_"^"_OrdItemID_"^"_RLTID ;
    Write "<input onclick='EDIdOnclik(this);' onkeydown='EDIdOnKey(this);' id='"_ID_"' name='"_ID_"' "
    Write " style='WIDTH:30px; HEIGHT: 24px' value=''>"
    Quit
}

ClassMethod CreateMKElement(ODID, OrdItemID, RLTID As %String = "")
{
    if RLTID'="" d
    .s ODID=$P(^DHCPERLT(RLTID),"^",3)
    .s OrdItemID=$P(^DHCPERLT(RLTID),"^",9)
    S ItemType=$P($g(^DHCPEST(+ODID,"OD",$P(ODID,"||",2))),"^",2)
    s ID="MK"_ODID_"^"_OrdItemID ;
    s ReadOnly=""
    s:ItemType'="T" ReadOnly="disabled=true"
    Write "<input "_ReadOnly_" id='"_ID_"' name='"_ID_"' "
    Write " style='WIDTH:60px; HEIGHT: 24px' value=''>"
    Quit
}

ClassMethod GetStationDesc(ID As %String) As %String
{
    Quit $P($g(^DHCPEST(ID)),"^",2)
}

ClassMethod LookupStationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookupStationExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

Query GetStationOrder(StationID As %String, EpisodeID As %String) As %Query(ROWSPEC = "PhyExamOrderID:%String,PhyExamOrderCode:%String,PhyExamOrder:%String, DietFlag:%String, DietWarning:%String,OEORIRowId:%String,OEORIStat:%String,TransDate:%String,AuditDate:%String")
{
}

ClassMethod GetStationOrderExecute(ByRef qHandle As %Binary, StationID As %String, EpisodeID As %String) As %Status
{
    s ^lisatest("0511","GetStationOrder1")=StationID_"^"_EpisodeID
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=0
    If $g(EpisodeID)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s LocID=$P($G(^PAADM(EpisodeID)),"^",4)
    s Job=$J
    k ^TempDHCPEStationOrder(Job)
    set HFStationIds=$g(^DHCPESetting("DHCPE","HealthFile_StationIds"))  //健康档案项目StationIDs
    set PEIAdmId=$o(^DHCPEIADM(0,"PAADM",EpisodeID,""))
    set PEIAdmDiet=$p(^DHCPEIADM(PEIAdmId),"^",15)
    //s StationID=
    set StationDr=StationID
    If $g(StationID)="" Do
    .Set Context=%request.Get("CONTEXT")
    .Set ^lisatest("0511","Context")=Context
    .Quit:((Context'["DHPE")&(Context'["DHPECat")&(Context'["DHPERis"))
    .s CTProfileID=$P(Context,"DHPECat",2)
    .i CTProfileID="" s CTProfileID=$P(Context,"DHPERis",2)
    .i CTProfileID="" s CTProfileID=$P(Context,"DHPE",2)
    .Quit:CTProfileID=""
    .Set Params=$LIST(^epr.CTProfileParamsD(CTProfileID),2)
    .Set StationDr=$P(Params,",",1)
    .Quit:StationDr=""
    .Quit:'$D(^DHCPEST(StationDr))
    s ^lisatest("0511","GetStationOrder2")=StationDr_"^"_EpisodeID
    s OEOrder=0
    f  s OEOrder=$O(^OEORD(0,"Adm",EpisodeID,OEOrder))  q:OEOrder=""  d
    .s OEOrdItem=0
    .f  s OEOrdItem=$O(^OEORD(OEOrder,"I",OEOrdItem))  q:OEOrdItem=""  d
    ..s OEORIRowId=OEOrder_"||"_OEOrdItem
    ..if StationID="" Quit:((HFStationIds'[("^"_StationDr_"^"))&..CheckEpisodeID(EpisodeID,OEORIRowId))
    ..////谢绝检查的标志
    ..s Flag="0"
    ..s:$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)) Flag="1"
    ..s CRMID=$O(^DHCPECRMO(0,"OEORI",OEORIRowId,0))
    ..q:CRMID=""
    ..s PaidFlag=$p(^DHCPECRMO(CRMID),"^",4)
    ..q:PaidFlag="NP"
    ..s ItemID=$p(^DHCPECRMO(CRMID),"^",2)
    ..q:ItemID=""
    ..s ItemStat=$p(^DHCPEPreIADM(+ItemID,"ORDITEM",$p(ItemID,"||",2)),"^",16)
    ..q:ItemStat'="1"
    ..s ARCIM=$p(^OEORD(OEOrder,"I",OEOrdItem,1),"^",2)
    ..s ORIStat=$p(^OEORD(OEOrder,"I",OEOrdItem,1),"^",13)
    ..s OEORIStat=""
    ..q:ORIStat=4
    ..i ORIStat=1  Do 
    ...Set OEORIStat="核实"
    ...If $p($g(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)),"^",1)=1 Set OEORIStat="谢绝检查"
    ..i ORIStat=6 s OEORIStat="执行"
    ..s ARCIMIn="N"
    ..s Chl=0   
    ..s Sort=""
    ..For  Set Chl=$O(^DHCPEST(StationDr,"O",Chl)) Quit:((Chl="")||(ARCIMIn="Y"))  Do
    ...Set STARCIM=$P(^DHCPEST(StationDr,"O",Chl),"^",1)
    ...Set Sort=$P(^DHCPEST(StationDr,"O",Chl),"^",7)
    ...i (STARCIM=ARCIM) d
    ....s ARCIMIn="Y"
    ....s STChl=Chl
    ..q:ARCIMIn="N"
    ..i Sort="" s Sort="9999999"
    ..Set ARCIMCode=$P(^ARCIM(+ARCIM,1,1),"^",1)
    ..Set ARCIMDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ARCIM)
    ..i Flag="1" s ARCIMDesc=ARCIMDesc_"(已谢绝检查)"
    ..set DietFlag=$P(^DHCPEST(StationDr,"O",STChl),"^",2)
    ..set DietWarning=""
    ..i ((DietFlag="PRE")&&(PEIAdmDiet="Y"))  s DietWarning="'"_ARCIMDesc_"'应在餐前做!"
    ..i ((DietFlag="POST")&&(PEIAdmDiet="N"))  s DietWarning="'"_ARCIMDesc_"'应在餐后做!"
    ..
    ..s OEORILabEpisodeNo=$p($G(^OEORD(OEOrder,"I",OEOrdItem,3)),"^",20)
    ..i OEORILabEpisodeNo'="" d
    ...s Station=$o(^DHCPEST(0,"STORD_ARCIM",ARCIM,0))
    ...q:Station=""
    ...s Sub=$o(^DHCPEST(0,"STORD_ARCIM",ARCIM,Station,0))
    ...q:Sub=""
    ...s ARCOS=$p(^DHCPEST(Station,"O",Sub),"^",3)
    ...s OEORIStat=##class(web.DHCPE.OEOrdItem).GetResultStatus(OEORILabEpisodeNo,ARCIM,ARCOS,OEORIRowId)
    ..s TranDate=""   //回传时间
    ..s TranDate=$G(^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",OEORIRowId))
    ..i TranDate'="" d
    ...s TranDate=$ZD($p(TranDate,",",1),3)_" "_$Zt($p(TranDate,",",2),3)
    ..s AuditDate="",AuditTime=""
    ..s GSRowID=$O(^DHCPEGS(0,"IADM",PEIAdmId,0))
    ..i GSRowID'=""  d
    ...s AuditDate=$p(^DHCPEGS(GSRowID,1),"^",6)
    ...s AuditTime=$p(^DHCPEGS(GSRowID,1),"^",7)
    ..i AuditDate'=""  s AuditDate=$zd(AuditDate,3)
    ..i AuditTime'=""  s AuditTime=$zt(AuditTime,3)
    ..s AuditDate=AuditDate_" "_AuditTime
    ..s Station=$o(^DHCPEST(0,"STORD_ARCIM",ARCIM,0))
    ..q:Station=""
    ..;s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
    ..s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))
    
    ..//i ("^"_RisStation_"^")[("^"_Station_"^")  d
    ..//.s OEORIStat=##class(web.DHCPE.OEOrdItem).GetRisResultStatus(ARCIM,OEORIRowId)
    ..Set ind=ind+1
    ..Set Data=$LB(ARCIM,ARCIMCode_"("_ARCIM_")",ARCIMDesc,DietFlag,DietWarning,OEORIRowId,OEORIStat,TranDate,AuditDate)
    
    ..s ^TempDHCPEStationOrder(Job,Sort,OEORIRowId)=Data
    ..;Set ^CacheTemp(repid,ind)=Data 
    s ind=1
    s Sort=""
    f  s Sort=$O(^TempDHCPEStationOrder(Job,Sort)) q:Sort=""  d
    .s OEORIRowId=""
    .f  s OEORIRowId=$O(^TempDHCPEStationOrder(Job,Sort,OEORIRowId)) q:OEORIRowId=""  d
    ..s Data=$G(^TempDHCPEStationOrder(Job,Sort,OEORIRowId))
    ..Set ^CacheTemp(repid,ind)=Data
    ..s ind=ind+1
    k ^TempDHCPEStationOrder(Job)
    
    d ##Class(web.DHCPE.RoomManager).UpdateOneRoomRecord(EpisodeID,"N^E")
    //
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

ClassMethod GetStationOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStationOrderExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 //
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

ClassMethod GetStationOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStationOrderExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod LookupStationExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    //If $g(Station)=""
    Set ind=0
    Set ID=0
    For  Set ID=$O(^DHCPEST(ID)) Quit:ID=""  Do
    .Set Code=$P($g(^DHCPEST(ID)),"^",1)
    .Set Desc=$P($g(^DHCPEST(ID)),"^",2)
    .Set ind=ind+1
    .Set Data=$LB(Desc,Code,ID)
    .Set ^CacheTemp(repid,ind)=Data 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

ClassMethod LookupStationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookupStationExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 //
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

Query LookupStation() As %Query(ROWSPEC = "Desc:%String,Code:%String,StationID:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.ResultEdit","OrderItemEdit","1040||2","1126")
Query OrderItemEdit(OEORIRowId As %String, EpisodeID As %String) As %Query(ROWSPEC = "ItemDesc:%String,ItemValue:%String,ItemID:%String,ItemCols:%String,ARCIM:%String,UOM:%String,NormalV:%String,ResultType:%String,ComputeExp:%String,ItemCode:%String,Required:%String,OEORIRowId:%String,Sequence:%String,TempDesc:%String,NormalFlag:%String,THighRisk:%String")
{
}

ClassMethod OrderItemEditExecute(ByRef qHandle As %Binary, OEORIRowId As %String, EpisodeID As %String) As %Status
{
    q:OEORIRowId=""
    s PaiedStatus=$p(^OEORD($P(OEORIRowId,"||",1),"I",$P(OEORIRowId,"||",2),3),"^",5)
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    if (PaiedStatus'="P")
    {
        w "<font color = red>项目未付费</font>"
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    s ARCIMID=$p(^OEORD($P(OEORIRowId,"||",1),"I",$P(OEORIRowId,"||",2),1),"^",2)
    
    Set myStr=..GetAgeSex(EpisodeID)
    Set myAge=$p(myStr,"^",1)
    Set mySex=$p(myStr,"^",2)
    Set ind=0
    s Job=$J
        
    s PersonID=$P(^PAADM(EpisodeID),"^",1)
    s locid=$P($G(^PAADM(EpisodeID)),"^",4)
    s PrevPAADM=$O(^PAPERdr(PersonID,"ADM","H",EpisodeID),-1)
    s episodeNo=$p(^OEORD($p(OEORIRowId,"||",1),"I",$p(OEORIRowId,"||",2),3),"^",20)
    Quit:$g(ARCIMID)=""
    i episodeNo'=""
    {
        
        s RLTId=0
        f  s RLTId=$O(^DHCPERLT(0,"OEORI",OEORIRowId,RLTId)) q:RLTId=""  d
        .s Item=$p($G(^DHCPERLT(RLTId)),"^",3)
        .q:$D(^TempDHPCEResultEdit(Job,"Result",OEORIRowId,Item))
        .s ^TempDHPCEResultEdit(Job,"Result",OEORIRowId,Item)=""
        .s PrevCode=""
        .i PrevPAADM'="" d
        ..s PrevRLTID=0
        ..f  s PrevRLTID=$O(^DHCPERLT(0,"PAADM_OD",PrevPAADM,Item,PrevRLTID)) q:PrevRLTID=""  d
        ...s ARCID=$P(^DHCPERLT(PrevRLTID),"^",2)
        ...q:ARCID'=ARCIMID
        ...s Flag=$P(^DHCPERLT(PrevRLTID),"^",7)
        ...s:Flag=0 PrevCode="***"
        .s ItemDesc=PrevCode_$P($g(^DHCPEST(+Item,"OD",$P(Item,"||",2))),"^",1)
        .s ItemData=$p($G(^DHCPERLT(RLTId)),"^",4)
        .s ItemUOM=$G(^DHCPEDataEx("DHCPEResult",RLTId,"Unit"))
        .s NormalStr=$G(^DHCPEDataEx("DHCPEResult",RLTId,"Ranges"))
        .s NormalFlag=$P(^DHCPERLT(RLTId),"^",7)
        .s HighRisk=$P(^DHCPERLT(RLTId),"^",12)
        .//s:HighRisk="Y" NormalFlag="2"
        .s Arrow=##class(web.DHCPE.TransResult).GetLabResultArrow(NormalStr,ItemData)
        .i (Arrow="1")&&(NormalFlag=0) s Arrow=3
        .s NormalFlag=Arrow
        .s ItemCode=$P($g(^DHCPEST(+Item,"OD",$P(Item,"||",2))),"^",11)
        .s (ResultType,ComputeExp,Required,Sequence,TempDesc)=""
        .Set ind=ind+1
        .Set ItemColName="ItemSelz"_ind
        .Set Data=$LB(ItemDesc,ItemData,Item,ItemColName,ARCIMID,ItemUOM,NormalStr,ResultType,ComputeExp,ItemCode,Required,OEORIRowId,Sequence,TempDesc,NormalFlag,$G(HighRisk))
        .Set ^CacheTemp(repid,ind)=Data
        k ^TempDHPCEResultEdit(Job,"Result",OEORIRowId)
    }
    else
    {
    
    s Sequence=""
    f  s Sequence=$O(^DHCPEODR(0,"Sequence",ARCIMID,Sequence)) q:Sequence=""  d
    .s RowId=""
    .f  s RowId=$O(^DHCPEODR(0,"Sequence",ARCIMID,Sequence,RowId)) q:RowId=""  d
    ..Set Item=$P($g(^DHCPEODR(RowId)),"^",2)
    ..Set Sequence=$P($g(^DHCPEODR(RowId)),"^",3)
    ..Quit:Item=""
    ..s PrevCode=""
    ..i PrevPAADM'="" d
    ...s PrevRLTID=0
    ...f  s PrevRLTID=$O(^DHCPERLT(0,"PAADM_OD",PrevPAADM,Item,PrevRLTID)) q:PrevRLTID=""  d
    ....s ARCID=$P(^DHCPERLT(PrevRLTID),"^",2)
    ....q:ARCID'=ARCIMID
    ....s Flag=$P(^DHCPERLT(PrevRLTID),"^",7)
    ....s:Flag=0 PrevCode="***"
    ..Set ItemDesc=PrevCode_$P($g(^DHCPEST(+Item,"OD",$P(Item,"||",2))),"^",1)
    ..Set ItemUOMDr=$P($g(^DHCPEST(+Item,"OD",$P(Item,"||",2))),"^",4)
    ..s ItemSex=$P($g(^DHCPEST(+Item,"OD",$P(Item,"||",2))),"^",9)
    ..q:(ItemSex'="N")&&(ItemSex'=mySex)
    ..Set ResultType=$P($g(^DHCPEST(+Item,"OD",$P(Item,"||",2))),"^",2)
    ..Set ComputeExp=$P($g(^DHCPEST(+Item,"OD",$P(Item,"||",2))),"^",3)
    ..Set ItemCode=$P($g(^DHCPEST(+Item,"OD",$P(Item,"||",2))),"^",11)
    ..;Set ComputeExp=$p(ComputeExp,";",2)
    ..Set ItemUOM=ItemUOMDr
    ..;If ItemUOMDr'="" Set ItemUOM=$P($G(^CT("UOM",ItemUOMDr)),"^",2)
    ..Set NormalStr=..GetNormal(Item, mySex, myAge)
    ..i $G(^DHCPESetting("DHCPE","AutoNormalResult",%session.Get("LOGON.CTLOCID")))="Y"  d
    ...i ResultType'="S"  S NormalStr1=""
    ...ELSE  S NormalStr1=NormalStr
    ..else  s NormalStr1=""
    ..////为了显示不正常结果添加
    ..s NormalFlag=""
    ..s Arrow=1
    ..///End
    ..S TempDesc=""
    ..s RLTId=$o(^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,Item,""))
    ..i $g(RLTId)'="" d
    ...s RLTId=0
    ...s ItemData=""
    ...s TempDesc=""
    ...s ItemDataStr="" s TempDescNew="" 
    ...For  Set RLTId=$O(^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,Item,RLTId)) Q:RLTId=""  Do   //modified by MLH
    ....////为了显示不正常结果添加
    ....s NormalFlag=$P(^DHCPERLT(RLTId),"^",7)
    ....s HighRisk=$P(^DHCPERLT(RLTId),"^",12)
    ....s Arrow=##class(web.DHCPE.TransResult).GetLabResultArrow(NormalStr,$P($g(^DHCPERLT(RLTId)),"^",4))
    ....i (Arrow="1")&&(NormalFlag=0) s Arrow=3
    ....s NormalFlag=Arrow
    ....;s HospitalCode=$G(^DHCPESetting("DHCPE","HospitalCode"))       //add by zl20100628 start  
    ....s HospitalCode=$G(^DHCPESetting("DHCPE","HospitalCode",locid))         
    ....s ItemDataNew=$P($g(^DHCPERLT(RLTId)),"^",4)
    ....s TempDescNew=$P($g(^DHCPERLT(RLTId)),"^",10)
    ....i TempDescNew'=""  s ItemDataNew=ItemDataNew_"("_TempDescNew_")"
    ....i ItemDataStr=""  s ItemDataStr=ItemDataNew
    ....else  s ItemDataStr=ItemDataStr_";"_ItemDataNew
    ....s ItemData=ItemDataStr                                         //add by zl20100628 end   
    ....i TempDesc="" d
    .....Set TempDesc=$P($g(^DHCPERLT(RLTId)),"^",10)
    ....e  d
    .....Set TempDesc=TempDesc_";"_$P(^DHCPERLT(RLTId),"^",10)
    ..Else  d
    ...s ItemData=""
    ...s ResultID=$o(^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,""))
    ...i ResultID=""  d
    ....Set ItemData=NormalStr1 Set TempDesc=""
    ..s Required=$P($g(^DHCPEODR(RowId)),"^",4)
    ..Set ind=ind+1
    ..Set ItemColName="ItemSelz"_ind
    ..Set Data=$LB(ItemDesc,ItemData,Item,ItemColName,ARCIMID,ItemUOM,NormalStr,ResultType,ComputeExp,ItemCode,Required,OEORIRowId,Sequence,TempDesc,NormalFlag,$G(HighRisk))
    ..Set ^CacheTemp(repid,ind)=Data 
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

ClassMethod OrderItemEditFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OrderItemEditExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 //
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

ClassMethod OrderItemEditClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OrderItemEditExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetRisDataExamDesc1(OEORIRowId As %String) As %Status
{
    Quit:$g(OEORIRowId)="" 1

    s RowId=$o(^DicomRpti("oeorditem",OEORIRowId,0))
    q:$g(RowId)="" ""

    s DicomRptStr=$g(^DicomRpt(RowId))
    q:DicomRptStr="" ""
    
    s DcmRptVerify=$P(DicomRptStr,"^",9)
    q:DcmRptVerify="" "" //"Error: the result is not Verify."   //未审核
    
    s ExamDesc=$p(DicomRptStr,"^",3)
    q ExamDesc
}

ClassMethod GetRisDataExamResult1(OEORIRowId As %String) As %Status
{
    Quit:$g(OEORIRowId)="" 1
    s RowId=$o(^DicomRpti("oeorditem",OEORIRowId,0))
    q:$g(RowId)="" ""
    
    s DicomRptStr=$g(^DicomRpt(RowId))
    q:DicomRptStr="" ""
    
    s DcmRptVerify=$P(DicomRptStr,"^",9)
    q:DcmRptVerify="" "" //"Error: the result is not Verify."   //未审核
    
    s ExamResult=$p(DicomRptStr,"^",4)
    q ExamResult
}

ClassMethod GetRisDataClinicInfo1(OEORIRowId As %String) As %Status
{
    Quit:$g(OEORIRowId)="" 1
    s RowId=$o(^DicomRpti("oeorditem",OEORIRowId,0))
    q:$g(RowId)="" ""
    s DicomRptStr=$g(^DicomRpt(RowId))
    q:DicomRptStr="" ""
    
    s DcmRptVerify=$P(DicomRptStr,"^",9)
    q:DcmRptVerify="" "" //"Error: the result is not Verify."   //未审核

    s ClinicInfo=$p(DicomRptStr,"^",17)
    q ClinicInfo
}

ClassMethod GetRisDataExamDesc(OEORIRowId As %String) As %Status
{
    Quit:$g(OEORIRowId)="" 1

    Set RARRowId=$o(^DHCPACRegInfoi("OEORI",OEORIRowId,0))
    Quit:$g(RARRowId)="" ""
    Set RisStudyNo=$p(^DHCPACRegInfo(RARRowId),"^",2)
    //Set DRPTRowId=$o(^DHCRBStudyi("Report","StudyNo",RisStudyNo,0))
    Set DRPTRowId=##class(web.DHCPE.TransResult).GetMaxRisReportID(RisStudyNo)
    
    Quit:($g(DRPTRowId)="") ""
        
    Set RisItemStatus=$P(^DHCRBStudy("Report",DRPTRowId),"^",4)
    Quit:(RisItemStatus'="5") "Error: 结果未发布" //the result is not Verify."   //未发布

    Set ExamDesc=^DHCRBStudy("Report",DRPTRowId,"ExamDescEx")  //3,检查所见

    Set ExamDesc=##class(web.DHCPE.ReportGetInfor).Replace(ExamDesc,"_$c(13,10)_","  ")
    Set ExamDesc=##class(web.DHCPE.ReportGetInfor).Replace(ExamDesc,"_$c_","  ")

    q ExamDesc
}

ClassMethod GetRisDataExamResult(OEORIRowId As %String) As %Status
{
    Quit:$g(OEORIRowId)="" 1
    Set RARRowId=$o(^DHCPACRegInfoi("OEORI",OEORIRowId,0))
    Quit:$g(RARRowId)="" ""
    Set RisStudyNo=$p(^DHCPACRegInfo(RARRowId),"^",2)
    //Set DRPTRowId=$o(^DHCRBStudyi("Report","StudyNo",RisStudyNo,0))
    Set DRPTRowId=##class(web.DHCPE.TransResult).GetMaxRisReportID(RisStudyNo)

    Quit:($g(DRPTRowId)="") ""
        
    Set RisItemStatus=$P(^DHCRBStudy("Report",DRPTRowId),"^",4)
    Quit:(RisItemStatus'="5") "Error: 结果未发布" //the result is not Verify."   //未发布

    Set ExamResult=^DHCRBStudy("Report",DRPTRowId,"ResultDescEx")  //4,诊断意见

    s ExamResult=##class(web.DHCPE.ReportGetInfor).Replace(ExamResult,"_$c(13,10)_","  ")
    s ExamResult=##class(web.DHCPE.ReportGetInfor).Replace(ExamResult,"_$c_","  ")
    
    q ExamResult
}

ClassMethod GetRisDataClinicInfo(OEORIRowId As %String) As %Status
{
    Quit:$g(OEORIRowId)="" 1
    Set RARRowId=$o(^DHCPACRegInfoi("OEORI",OEORIRowId,0))
    Quit:$g(RARRowId)="" ""
    Set RisStudyNo=$p(^DHCPACRegInfo(RARRowId),"^",2)
    //Set DRPTRowId=$o(^DHCRBStudyi("Report","StudyNo",RisStudyNo,0))
    Set DRPTRowId=##class(web.DHCPE.TransResult).GetMaxRisReportID(RisStudyNo)

    Quit:($g(DRPTRowId)="") ""
        
    Set RisItemStatus=$P(^DHCRBStudy("Report",DRPTRowId),"^",4)
    Quit:(RisItemStatus'="5") "Error: 结果未发布" //the result is not Verify."   //未发布

    Set ClinicInfo=""
    
    q ClinicInfo
}

Query OrderItemEditCat(OEORIRowId As %String, ParentDR As %String, EpisodeID As %String) As %Query(ROWSPEC = "ItemDesc:%String,ItemValue:%String,ItemID:%String,ItemCols:%String,ARCIM:%String,UOM:%String,NormalV:%String,ResultType:%String,ComputeExp:%String,ItemCode:%String,Required:%String,OEORIRowId:%String")
{
}

ClassMethod OrderItemEditCatExecute(ByRef qHandle As %Binary, OEORIRowId As %String, ParentDR As %String, EpisodeID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    q:$g(OEORIRowId)=""
    s locid=$P($G(^PAADM(EpisodeID)),"^",4)
    s tempAge=0, tempSex=1, myAge=0, mySex="M"
    &sql(select paadm_admdate - paadm_papmi_dr->papmi_Dob , paadm_papmi_dr->papmi_sex_dr  
            into :tempAge, :tempSex
            from SQLUSER.pa_adm where paadm_rowid=:EpisodeID)
    s myAge=tempAge/365
    i tempSex=2 s mySex="F"
    Set ind=0
    Quit:$g(ParentDR)=""
    s ARCIMID=$P(^DHCPEODR(ParentDR),"^",1)
    Set RowId=""
    Set ODRRowId=""
    For  Set ODRRowId=$O(^DHCPEODR(0,"ParentDR",ParentDR,ODRRowId)) Quit:ODRRowId=""  Do
    .Set Item=$P($g(^DHCPEODR(ODRRowId)),"^",2)
    .Quit:Item=""
    .Set ItemDesc=$P($g(^DHCPEST(+Item,"OD",$P(Item,"||",2))),"^",1)
    .Set ItemUOMDr=$P($g(^DHCPEST(+Item,"OD",$P(Item,"||",2))),"^",4)
    .Set ResultType=$P($g(^DHCPEST(+Item,"OD",$P(Item,"||",2))),"^",2)
    .Set ComputeExp=$P($g(^DHCPEST(+Item,"OD",$P(Item,"||",2))),"^",3)
    .Set ItemCode=$P($g(^DHCPEST(+Item,"OD",$P(Item,"||",2))),"^",11)
    .;Set HospitalCode=$g(^DHCPESetting("DHCPE","HospitalCode"))
    .Set HospitalCode=$g(^DHCPESetting("DHCPE","HospitalCode",locid))
    .If HospitalCode="NBMZ" Set ComputeExp=$p(ComputeExp,";",2)
    .Set ItemUOM=ItemUOMDr
    .;If ItemUOMDr'="" Set ItemUOM=$P($G(^CT("UOM",ItemUOMDr)),"^",2)
    .Set NormalStr=..GetNormal(Item, mySex, myAge)
    .//w !, NormalStr
    .If $D(^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,Item)) Do
    ..//Set RLTId=$O(^DHCPERLT(0,"ADMOD",EpisodeID,ARCIMID,Item,""))  //modified by MLH
    ..s RLTId=0
    ..s ItemData=""
    ..For  Set RLTId=$O(^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,Item,RLTId)) Q:RLTId=""  Do   //modified by MLH
    ...i ItemData="" d
    ....Set ItemData=$P(^DHCPERLT(RLTId),"^",4)
    ...e  d 
    ....Set ItemData=ItemData_";"_$P(^DHCPERLT(RLTId),"^",4)
    .Else  Set ItemData=""
    .s Required=$P($g(^DHCPEODR(ODRRowId)),"^",4)
    .Set ind=ind+1
    .Set ItemColName="ItemSelz"_ind
    .Set Data=$LB(ItemDesc,ItemData,Item,ItemColName,ARCIMID,ItemUOM,NormalStr,ResultType,ComputeExp,ItemCode,Required,OEORIRowId)
    .Set ^CacheTemp(repid,ind)=Data 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

ClassMethod OrderItemEditCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OrderItemEditCatExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 //
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

ClassMethod OrderItemEditCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OrderItemEditCatExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// test: w ##class(web.DHCPE.ResultEdit).GetNormal("17||39","F",17)
/// w ##class(web.DHCPE.ResultEdit).IsNormal("8||114","阴性")
/// w ##class(web.DHCPE.ResultEdit).IsNormal("2||10","ererrrrrrrr","F")
ClassMethod IsNormal(ItemID, ItemValue, sex, StationID As %String = "", Age As %String = "", LocID As %String = "") As %String
{
    i LocID="" d
    .s LocID=%session.Get("LOGON.CTLOCID")
    Quit:(($g(ItemID)="")||($g(ItemValue)="")) 1
    Set Normal=0
    Set ResultFormat=""
    s SumFlag=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",5)
    q:SumFlag="N" 1
    q:ItemValue[(">") 0
    q:ItemValue[("<") 0
    q:ItemValue[("≥") 0
    q:ItemValue[("≤") 0
    q:ItemValue[("阳性") 0
    q:ItemValue[("阴性") 1
    q:ItemValue[("+") 0
    
    //s HospCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
    s HospCode=$G(^DHCPESetting("DHCPE","HospitalCode",LocID))

    i (ItemValue="NEGATIVE")&&(HospCode="SHHS") s ItemValue="阴性"
    //Set namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
    //Set LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
    Set namespaceLab=^DHCPESetting("NAMESPACE","LABDATA",LocID)
    Set LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))

    Set CurStation=+ItemID
    s:StationID'="" CurStation=StationID
    Set NormalStr=..GetNormal(ItemID, sex,Age,StationID)
    If LabStation'=CurStation Do
    .Set ItemType=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",2)
    .If (ItemType="N")||(ItemType="C") Do
    ..Set Min=$p(NormalStr,"-",1)
    ..Set Max=$p(NormalStr,"-",2)
    ..If (ItemValue>=Min)&&(ItemValue<=Max) Set Normal=1
    .Else  Do
    ..If NormalStr[ItemValue Set Normal=1
    ..//If (ItemValue="未检")||(ItemValue="拒检") Set Normal=1
    ..b ;NormalStr
    ..s:NormalStr="" Normal=0
    ..;If ItemType="T" Set Normal=0
    Else  Do
    .Set CTTCCode=$p($G(^DHCPEST(+ItemID,"OD",$p(ItemID,"||",2))),"^",10)
    .Set ResultFormat=$p($g(^[namespaceLab]TTAB("TC",CTTCCode)),"\",3)
    .If ResultFormat="X" Do
    ..If NormalStr=ItemValue Set Normal=1
    ..///尿常规正常值临时等马
    ..If $o(^TTAB("TC",CTTCCode,4,""))'="" Do
    ...Set Min=$p(NormalStr,"-",1)
    ...Set Max=$p(NormalStr,"-",2)
    ...If (ItemValue>=Min)&&(ItemValue<=Max) Set Normal=1
    ..if (ItemValue)="-" Set Normal=1
    .If $e(ResultFormat,1)="N" Do
    ..//Modified
    ..i NormalStr["<" d
    ...s NormalStr=$p(NormalStr,"<",2)
    ...s EqualFlag=0
    ...i NormalStr["=" d
    ....s NormalStr=$p(NormalStr,"=",2)
    ....s EqualFlag=1
    ...s NormalStr=+NormalStr
    ...s:(EqualFlag=1)&&(ItemValue<=NormalStr) Normal=1
    ...s:(EqualFlag=0)&&(ItemValue<NormalStr) Normal=1
    ..e  i NormalStr[">" d
    ...s NormalStr=$p(NormalStr,">",2)
    ...s EqualFlag=0
    ...i NormalStr["=" d
    ....s NormalStr=$p(NormalStr,"=",2)
    ....s EqualFlag=1
    ...s NormalStr=+NormalStr
    ...s:(EqualFlag=1)&&(ItemValue>=NormalStr) Normal=1
    ...s:(EqualFlag=0)&&(ItemValue>NormalStr) Normal=1
    ..e  i NormalStr["大于" d
    ...s NormalStr=$p(NormalStr,"大于",2)
    ...s EqualFlag=0
    ...i NormalStr["=" d
    ....s NormalStr=$p(NormalStr,"=",2)
    ....s EqualFlag=1
    ...s NormalStr=+NormalStr
    ...s:(EqualFlag=1)&&(ItemValue>=NormalStr) Normal=1
    ...s:(EqualFlag=0)&&(ItemValue>NormalStr) Normal=1
    ..e  i NormalStr["小于" d
    ...s NormalStr=$p(NormalStr,"小于",2)
    ...s EqualFlag=0
    ...i NormalStr["=" d
    ....s NormalStr=$p(NormalStr,"=",2)
    ....s EqualFlag=1
    ...s NormalStr=+NormalStr
    ...s:(EqualFlag=1)&&(ItemValue<=NormalStr) Normal=1
    ...s:(EqualFlag=0)&&(ItemValue<NormalStr) Normal=1
    
    ..e  d
    ...Set Min=$p(NormalStr,"-",1)
    ...Set Max=$p(NormalStr,"-",2)
    ...If (ItemValue>=Min)&&(ItemValue<=Max) Set Normal=1
    ...if ItemValue[">"  d
    ....if $P($G(ItemValue),">",2)>Max set Normal=0
    .//End
    .If ResultFormat="S" Do
    ..Set CTTCTCode=""
    ..Set ResultDesc=""
    ..Set NotNormal=""
    ..For  Set CTTCTCode=$o(^[namespaceLab]TTAB("TC",CTTCCode,2,CTTCTCode)) Quit:((CTTCTCode="")||(Normal=1))  Do
    ...Set NotNormal=$p(^[namespaceLab]TTAB("TC",CTTCCode,2,CTTCTCode),"\",1)
    ...Set Format=$p(^[namespaceLab]TTAB("TC",CTTCCode,2,CTTCTCode),"\",3)
    ...Set ResultDesc=^[namespaceLab]TTAB("TC",CTTCCode,2,CTTCTCode,1)
    ...If (ResultDesc=ItemValue)&(NotNormal="A") Set Normal=0
    ...If ((ResultDesc=ItemValue)&(NotNormal'="A")) Set Normal=1

    ;Quit:(NormalStr="")&(ResultFormat="") 1

    Quit Normal
}

ClassMethod TransNormalStr(NormalStr)
{
    
    /*
    ..i $e(NormalStr,1)="<" d
    ...s NormalStr=$e(NormalStr,2,$l(NormalStr))
    ...i $e(NormalStr,1)="=" d
    ....s NormalStr=$e(NormalStr,2,$l(NormalStr))
    ...i ItemValue>+NormalStr s Normal=1
    ..i $e(NormalStr,1)=">" d
    ...s NormalStr=$e(NormalStr,2,$l(NormalStr))
    ...e  i $e(NormalStr,1)="=" d
    ....s NormalStr=$e(NormalStr,2,$l(NormalStr))
    ...i ItemValue<+NormalStr s Normal=1
    ..e  d
    ...Set Min=$p(NormalStr,"-",1)
    ...Set Max=$p(NormalStr,"-",2)
    ...If (ItemValue>=Min)&&(ItemValue<=Max) Set Normal=1
    

    */
    i NormalStr["<" d
    .s NormalStr=$p(NormalStr,"<",2)
    .i NormalStr["=" d
    ..s NormalStr=$p(NormalStr,"=",2)
    .s NormalStr="0-"_NormalStr
    i NormalStr[">" d
    .s NormalStr=$p(NormalStr,">",2)
    .i NormalStr["=" d
    ..s NormalStr=$p(NormalStr,"=",2)
    .s NormalStr=NormalStr_"-99999999999"
    q TransNormalStr
}

/// / Description: 获取细项正常值范围
/// dubug: w ##class(web.DHCPE.ResultEdit).GetNormal("7||499","M","17")
ClassMethod GetNormal(ItemID, sex, age, StationID As %String = "", LocID As %String = "") As %String
{
    //s ^tempdhcpe("GetNormal",ItemID)=$lb(ItemID,sex,age,StationID)
    i LocID = ""
    {
        //优先取sessionhu
        s:$D(%session) LocID = %session.Get("LOGON.CTLOCID")
        s:LocID="" LocID = 152 //先考虑从业务表中取就诊科室，没有就诊的再赋个默认值？
    }
   
    /*
    s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion"))
    Set Version=$g(^DHCPESetting("DHCPE","TrakVerison"))
    Set LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
    */
    s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion",LocID))
    s Version=$g(^DHCPESetting("DHCPE","TrakVerison",LocID))
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))

    q:($g(ItemID)="") ""
    s DefaultFlag=0
    s NormalStr=""
    s age=+age
    
    s CurNS=$ZNSPACE
    s CurStation=+ItemID
    i StationID'="" s CurStation=StationID
    //对于特殊格式的参考范围、设置后返回
    s ODCode=$p($g(^DHCPEST(+ItemID,"OD",$p(ItemID,"||",2))),"^",11)
    s Range=""
    s OrdDetSetID=$o(^CF.PE.OrderDetailSetI("IdxOfLocOrdDtl"," "_LocID,ItemID,""))
    i OrdDetSetID'="" s Range=$lg($g(^CF.PE.OrderDetailSetD(OrdDetSetID)),12)
    q:Range'="" Range
    /*
    i $D(^DHCPEDataEx("OrderDetail","Range",ItemID))
    {
        q $G(^DHCPEDataEx("OrderDetail","Range",ItemID))
    }
    */
    q:(LabStation=CurStation)&&(LisNewVersion="Y") ""
    i LabStation=CurStation d
    .;Set namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
    .s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA",LocID)
    .s CTTCCode=$p($G(^DHCPEST(+ItemID,"OD",$p(ItemID,"||",2))),"^",10)
    .q:CTTCCode=""
    .s LocShowDFlag=##class(User.DHCPEOrderDetail).GetLocShowDataFlag(ItemID,LocID)
    .q:LocShowDFlag'="Y" 
    .s ResultFormat=$p($g(^[namespaceLab]TTAB("TC",CTTCCode)),"\",3)
    .zn namespaceLab
    .i ((ResultFormat="X")!(ResultFormat="S")) d
    ..s CTTCTCode=""
    ..s NormalStr=""
    ..f  s CTTCTCode=$o(^TTAB("TC",CTTCCode,2,CTTCTCode)) q:(CTTCTCode="")!(NormalStr'="")  Do
    ...//q:($p(^TTAB("TC",CTTCCode,2,CTTCTCode),"\",22)'=sex)
    ...s IsNormal=$p(^TTAB("TC",CTTCCode,2,CTTCTCode),"\",1)
    ...s Format=$p(^TTAB("TC",CTTCCode,2,CTTCTCode),"\",3)
    ...i IsNormal="N" s NormalStr=^TTAB("TC",CTTCCode,2,CTTCTCode,1)
    ...i Format="Y" s NormalStr=^TTAB("TC",CTTCCode,2,CTTCTCode,1)
    ..i NormalStr="" d
    ...i Version="MedTrak" d
    ....s Ranges=$$ranges^LVBVIS1(CTTCCode,age,sex,"",0,"","")
    ...e  s Ranges=$$ranges^LVBVIS1(CTTCCode,age,sex,"",0,"","","","","")
    ...s NormalStr=$p(Ranges,$C(1),1)_"-"_$p(Ranges,$C(1),2)
    .i $e(ResultFormat,1)="N" d
    ..i Version="MedTrak" d
    ...s Ranges=$$ranges^LVBVIS1(CTTCCode,age,sex,"",0,"","")
    ..e  s Ranges=$$ranges^LVBVIS1(CTTCCode,age,sex,"",0,"","","","","")
    ..i Ranges="" d
    ...s NormalStr=$$GetMultiScope^CHDhcLabReport(CTTCCode,"aaa","")
    ..e  d
    ...s NormalStr=$p(Ranges,$C(1),1)_"-"_$p(Ranges,$C(1),2)
    .zn CurNS
    e  d
    .s ItemType=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",2)
    .s ItemUOMDr=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",4)
    .s LocShowDFlag=##class(User.DHCPEOrderDetail).GetLocShowDataFlag(ItemID,LocID)
    .q:LocShowDFlag'="Y"
    .s ItemUOM=""
    .i ItemUOMDr'="" s ItemUOM=$p($g(^CT("UOM",ItemUOMDr)),"^",2)
    .s Chl=0
    .s Normal="N"
    .f  s Chl=$O(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl)) q:(Chl="")  d 
    ..s ODSID=ItemID_"||"_Chl
    ..s myData=^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl)
    ..s tempNormal=$P(myData,"^",6)
    ..s tempSex=$P(myData,"^",1)
    ..s tempAgeMin=+$P(myData,"^",7)
    ..s tempAgeMax=+$P(myData,"^",8)
    ..q:tempNormal'="Y"
    ..q:(((tempAgeMin>age)||(tempAgeMax<age))&&((tempAgeMin'=0)&&(tempAgeMax'=0)))
    ..q:(tempSex'="N")&&(tempSex'=sex)
    ..s Normal="Y"
    ..i (ItemType="N")||(ItemType="C") d
    ...s Min=+$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl),"^",4)
    ...s Max=+$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl),"^",5)
    ...s Min=..GetNumber(Min)
    ...s Max=..GetNumber(Max)
    ...s NormalStr=Min_ItemUOM_"-"_Max_ItemUOM
    ..e  d
    ...s Default=""
    ...s Default=$p($g(^DHCPEST(+ItemID,"OD",$p(ItemID,"||",2),"ODS",Chl)),"^",14) //默认值
    ...i Default="Y" d
    ....i NormalStr="" s NormalStr=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl)),"^",2) 
    ....e  s NormalStr=NormalStr_";"_$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl)),"^",2)
    ....;w !,ODSID_"^"_NormalStr
    ....s DefaultFlag=1
    ...e  d
    ....q:DefaultFlag=1
    
    q NormalStr
}

ClassMethod GetNumber(val)
{
    if val="" q val
    if val=0 q val
    s val=+val
    if ((val>-1)&&(val<1))
    {
        s len=$l(val)-1
        s val=$j(val,3,len)     
    }
    q val
}

ClassMethod SavePEResult(EpisodeID As %String, OEORIRowId As %String, ResultStr As %String, DocStr As %String = "") As %Status
{
    
    s ResultStr=..UnEscape(ResultStr)
    Quit:$g(EpisodeID)="" 1
    Quit:$g(OEORIRowId)="" 1
    Quit:$g(ResultStr)="" 1
    Quit:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)) "RefuseItem" //谢绝检查
    s Status=..IsArrivedStatu(EpisodeID)
    q:Status=0 "NoArrived"
    s Return=..GeneralAdviceAudited(EpisodeID,"PAADM")
    q:Return "GeneralAdviceAudited"
    s DocID="",DocName=""                                          //add by zl 2010-11-29
    i $L(DocStr,"^")>1 d
    .s DocID=$p(DocStr,"^",2)                                      //add by zl 2010-11-29
    .S DocName=$p(DocStr,"^",1)
    e  d
    .s DocID=$p(DocStr,"$",2)                                      //add by zl 2010-11-29
    .S DocName=$p(DocStr,"$",1)
    
    s ^DHCPEDataEx("DHCPESSDocName",OEORIRowId)=DocName_"^"_DocID //华山既往史报告显示询问人、检验审核人 //add by zl 2010-11-29
    s ARCIM=$p(^OEORD($p(OEORIRowId,"||",1),"I",$p(OEORIRowId,"||",2),1),"^",2)
    
    s StationID=$o(^DHCPEST(0,"STORD_ARCIM",ARCIM,0))
    
    Set ItemCount=$L(ResultStr,$C(2))
    Set UserId=%session.Get("LOGON.USERID")
    //&SQL(Delete from SQLUser.DHC_PE_Result where RLT_OEORI_DR=:OEORIRowId)
    s ^DHCPEDataEx("ReportUser",OEORIRowId)=UserId                //报告录入者保存信息 //add by zl 2010-11-29
    s ^DHCPEDataEx("ReportDate",+$h,OEORIRowId)=UserId            //add by zl 2010-11-29
    s ^DHCPEDataEx("ReportDateUser",+$h,UserId,OEORIRowId)=1      //add by zl 2010-11-29
    //s sex="M"
    Set myStr=..GetAgeSex(EpisodeID)
    Set sex=$p(myStr,"^",2)
    //&sql(delete from dhc_pe_result where RLT_OEORI_DR=:OEORIRowId)
    For I=1:1:ItemCount Do
    .Set ItemStr=$P(ResultStr,$C(2),I)
    .Set ItemID=$P($g(ItemStr),$C(1),1)
    .Quit:ItemID=""
    .Set ItemValue=$P($g(ItemStr),$C(1),2)
    .q:$g(ItemValue)=""
    .Set Normal=..IsNormal(ItemID,ItemValue,sex,StationID)
    .If '$D(^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,ItemID)) Do
    ..KILL PLIST
    ..Set PLIST(2)=EpisodeID,PLIST(3)=ARCIM,PLIST(4)=ItemID
    ..//,PLIST(5)=ItemValue
    ..Set PLIST(6)=UserId,PLIST(7)=+$H,PLIST(11)=OEORIRowId,PLIST(8)=Normal
    ..i DocID'=""  s PLIST(6)=DocID                             //add by zl 2010-11-29
    ..Set PLIST(13)=$p($H,",",2)
    ..&SQL(INSERT INTO SQLUser.DHC_PE_Result VALUES PLIST())
    ..i SQLCODE="0"  d 
    ...s resultId=%ROWID
    ...s $p(^DHCPERLT(resultId),"^",4)=ItemValue
    ...s SQLCODE=##class(web.DHCPE.HighRisk).GetHighRiskFlag(resultId)    //add 
    .Else  Do
    ..///如果是选择更新就不操作了 ????为什么？？MLH2008-03-05
    ..//Set HospitalCode=$g(^DHCPESetting("DHCPE","HospitalCode"))
    ..//If HospitalCode="NBMZ" Do
    ..Set RLTId=$O(^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,ItemID,""))           //add by zl 2010-11-29
    ..s ComputeFlag=$p(^DHCPEST(+ItemID,"OD",$p(ItemID,"||",2)),"^",2)
    ..;q:ComputeFlag="S"  
    ..i DocID=""   s DocID=UserId                                                //add by zl 2010-11-29
    ..s $p(^DHCPERLT(RLTId),"^",5)=DocID                        //add by zl 2010-11-29 
                                         
    ..Set RLTId=$O(^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,ItemID,""))
    ..KILL PLIST
    ..Set PLIST(2)=EpisodeID,PLIST(3)=ARCIM,PLIST(4)=ItemID,PLIST(5)=ItemValue
    ..Set PLIST(7)=+$H,PLIST(11)=OEORIRowId,PLIST(8)=Normal
    ..;i DocID'=""  s PLIST(6)=DocID                                                  //add by zl 2010-11-29
    ..Set PLIST(13)=$p($H,",",2)
    ..&SQL(Update SQLUser.DHC_PE_Result VALUES PLIST() Where RLT_RowId= :RLTId)
    ..i SQLCODE="0"  d                          //add   
    ...s SQLCODE=##class(web.DHCPE.HighRisk).GetHighRiskFlag(RLTId)    //add 
    
    ///MLH20070515
    Set ItemRowId=0
    For  Set ItemRowId=$O(^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,ItemRowId))  Quit:ItemRowId=""  Do
    .Set RLTRowId=0
    .For  Set RLTRowId=$O(^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,ItemRowId,RLTRowId))  Quit:RLTRowId=""  Do
    ..Set MustDel=1
    ..For I=1:1:ItemCount Quit:MustDel=0  Do
    ...Set ItemStr=$P(ResultStr,$C(2),I)
    ...Set ItemID=$P($g(ItemStr),$C(1),1)
    ...Set ItemValue=$P($g(ItemStr),$C(1),2)
    ...If ((ItemID=ItemRowId)&(ItemValue'="")) Do
    ....Set MustDel=0
    ..If MustDel=1 Do
    ...&SQL(Delete from SQLUser.DHC_PE_Result where RLT_RowId=:RLTRowId)

    //MLH 判断必填项  //还需要改
    /*
    s ODRRowId=0
    f  s ODRRowId=$O(^DHCPEODR(0,"Required",ARCIM,"Y",ODRRowId))  q:((ODRRowId="")||(IsExecuted=0))  d
    .s ODRStr=$g(^DHCPEODR(ODRRowId))
    .s ODDR=$P(ODRStr,"^",2)
    .i $g(ODDR)="" s IsExecuted=0
    .q:IsExecuted=0    //0418 renzwang
    .s ^lisatest("0414111","ODRRowId",ODRRowId)=ODRRowId
    .s ^lisatest("0414aa","ODDR",ODDR)=ODDR
    .s RLTRowId=$O(^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,ODDR,0))
    .i $g(RLTRowId)="" s IsExecuted=0
    .q:$g(RLTRowId)=""
    .s RLTStr=$g(^DHCPERLT((RLTRowId)))
    .s RLTResult=$p(RLTStr,"^",4)
    .i RLTResult="" s IsExecuted=0
    */
    Set IsExecuted=..OrderIsExec(EpisodeID,OEORIRowId)
    d ..ChangeOrdItemStatus(EpisodeID, OEORIRowId, IsExecuted)
    
    s SQLCODE=$g(SQLCODE)
    Quit 'SQLCODE
}

// w ##class(web.DHCPE.ResultEdit).GetAgeSex("1")

ClassMethod GetAgeSex(EpisodeID As %String) As %Status
{
    Quit:EpisodeID="" ""
    Set tempAge=0, tempSex=1, myAge=0, mySex="M"
    
    Set PaPatID=$P(^PAADM(EpisodeID),"^",1)
    Set tempSex=$P(^PAPER(PaPatID,"ALL"),"^",7)
    Set tempAge=$P(^PAPER(PaPatID,"ALL"),"^",6)
    Set AdmDate=$P(^PAADM(EpisodeID),"^",6)
    s CurLoc=$P($G(^PAADM(EpisodeID)),"^",4)
    Set:tempAge'="" myAge=##class(web.DHCLCNUREXCUTE).CalAge(tempAge,AdmDate)
    set myAge=$P(myAge,"Y",1)
    //Set SetSex=$G(^DHCPESetting("DHCPE","DefPatientType"))
    Set SetSex=$G(^DHCPESetting("DHCPE","DefPatientType",CurLoc))
    i tempSex=$P(SetSex,"^",4) s mySex="F"
    //Quit myAge_"^"_mySex
    Quit myAge_"^"_mySex_"^"_tempSex
    
    /*
    &sql(select paadm_admdate - paadm_papmi_dr->papmi_Dob , paadm_papmi_dr->papmi_sex_dr  
            into :tempAge, :tempSex
            from SQLUSER.pa_adm where paadm_rowid=:EpisodeID)
    Set myAge=tempAge/365
    s myAge=$P(myAge,".",1)
    &sql(Select ctsex_desc into :ctsexdesc from CT_SEX where ctsex_rowid=:tempSex)
    If ctsexdesc="女" Set mySex="F"
    Quit myAge_"^"_mySex
    */
}

/// debug: w ##class(web.DHCPE.ResultEdit).OrderIsExec("534","497||255")
ClassMethod OrderIsExec(EpisodeID As %String, OEORIRowId As %String) As %Status
{
    s myStr=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
    s myAge=$p(myStr,"^",1)
    s mySex=$p(myStr,"^",2)

    s ARCIM=$p($g(^OEORD($p(OEORIRowId,"||",1),"I",$p(OEORIRowId,"||",2),1)),"^",2)
    s AdmLocID=$p($g(^PAADM(EpisodeID)),"^",4)
    s IsExecuted=1    //是否已执行
    s ODRRowId=0
    f  s ODRRowId=$O(^DHCPEODR(0,"Required",ARCIM,"Y",ODRRowId))  q:((ODRRowId="")||(IsExecuted=0))  d
    .s ODRStr=$g(^DHCPEODR(ODRRowId))
    .s ODDR=$P(ODRStr,"^",2)
    .s ODLocShowDFlag=##class(User.DHCPEOrderDetail).GetLocShowDataFlag(ODDR,AdmLocID)
    .q:ODLocShowDFlag'="Y"  
    .s ODSetID=$o(^CF.PE.OrderDetailSetI("IdxOfLocOrdDtl"," "_AdmLocID,ODDR,0))
    .q:ODSetID=""
    .s LocShowDFlag=##class(User.DHCPEOrderDetailSet).GetLocShowDataFlag(ODSetID,AdmLocID)
    .q:LocShowDFlag'="Y"
    .s Sex=$P($g(^DHCPEST(+ODDR,"OD",$P(ODDR,"||",2))),"^",9)
    .q:((Sex'="N")&&(Sex'=""))&&(Sex'=mySex)
    .i $g(ODDR)="" s IsExecuted=0
    .q:IsExecuted=0    
    .s RLTRowId=$O(^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,ODDR,0))
    .i $g(RLTRowId)="" s IsExecuted=0
    .q:$g(RLTRowId)=""
    .s RLTStr=$g(^DHCPERLT((RLTRowId)))
    .s RLTResult=$p(RLTStr,"^",4)
    .i RLTResult="" s IsExecuted=0
   
    i $o(^DHCPERLT(0,"OEORI",OEORIRowId,0))="" s IsExecuted=0
    q IsExecuted
}

/// Description: 改变医嘱项目的执行状态(当医嘱项中的明细结果没有一个有结果时，医嘱为核实;否则为执行。)
/// Input:       EpisodeID:就诊ID，OEORIRowId:医嘱ID，ToBeExecuted:体检结果表的状态（0:没结果，1:有结果）
/// Return：     0:成功；非0:失败
/// Notice:      之前更新医嘱表的执行状态修改对应global值的方式，这样导致相关执行状态的索引没更新,需要修改为sql更新
/// Debug:  d ##class(web.DHCPE.ResultEdit).ChangeOrdItemStatus("63991","12524||1",1)
ClassMethod ChangeOrdItemStatus(EpisodeID As %String, OEORIRowId As %String, ToBeExecuted)
{
     Set SQLCODE=0
    //ordIStatus: 1-核实 6-执行 4-停止
    Set ordIStatus=$p($g(^OEORD($p(OEORIRowId,"||",1),"I",$p(OEORIRowId,"||",2),1)),"^",13)
    If ((ordIStatus=6)&(ToBeExecuted=0)) Do
    .;Set $p(^OEORD($p(OEORIRowId,"||",1),"I",$p(OEORIRowId,"||",2),1),"^",13)=1 
    .&SQL(update sqluser.oe_orditem set oeori_itemstat_dr='1' where oeori_rowid=:OEORIRowId)
    
    If ((ordIStatus=1)&(ToBeExecuted=1)) Do
    .;Set $p(^OEORD($p(OEORIRowId,"||",1),"I",$p(OEORIRowId,"||",2),1),"^",13)=6 
    .&SQL(update sqluser.oe_orditem set oeori_itemstat_dr='6' where oeori_rowid=:OEORIRowId)
    
    Set:SQLCODE=100 SQLCODE=0
  
    Quit SQLCODE
}

ClassMethod SavePEStationSummary(EpisodeID As %String, ChartID As %String, SummaryStr As %String) As %Status
{
    Quit:$g(EpisodeID)="" 0
    Set StationID=..GetPEStation($g(ChartID))
    Quit:$g(StationID)="" 0
    
    s Return=..GeneralAdviceAudited(EpisodeID,"PAADM")
    q:Return "GeneralAdviceAudited"
    
    Set UserId=%session.Get("LOGON.USERID")
    //
    Set IAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,""))
    Quit:IAdm="" 0
    //
    Set StationSummaryDr=$O(^DHCPESS(0,"IADM",IAdm,StationID,""))
    If StationSummaryDr=""  Do
    .KILL PLIST
    .Set PLIST(2)=IAdm,PLIST(3)=StationID,PLIST(5)=+$H
    .Set PLIST(6)=UserId
    .&SQL(INSERT INTO SQLUser.DHC_PE_StationSummarize VALUES PLIST())
    .If 'SQLCODE Set SummDr=%ROWID Set $P(^DHCPESS(SummDr,"S"),"^",5)=$g(SummaryStr)
    Else  Do
    .KILL PLIST
    .Set PLIST(2)=IAdm,PLIST(3)=StationID,PLIST(5)=+$H
    .Set PLIST(6)=UserId
    .&SQL(Update SQLUser.DHC_PE_StationSummarize VALUES PLIST() Where SS_RowId= :StationSummaryDr)
    .if 'SQLCODE Set $P(^DHCPESS(StationSummaryDr,"S"),"^",5)=$g(SummaryStr)
    Quit 'SQLCODE
}

ClassMethod AuditPEStationSummary(EpisodeID As %String, ChartID As %String)
{
    Quit:$g(EpisodeID)="" 0
    Set StationID=..GetPEStation($g(ChartID))
    Quit:$g(StationID)="" 0
    Set UserId=%session.Get("LOGON.USERID")
    Set IAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,""))
    Quit:IAdm="" 0

    s today=+$h
    &SQL(
            update sqluser.dhc_pe_stationsummarize 
            set SS_Status='SA',SS_AduitUser_DR=:UserId, ss_aduitDate=:today
            where ss_iadm_dr=:IAdm and ss_st_dr=:StationID)
    quit 'SQLCODE
}

ClassMethod GetPEStationSummary(EpisodeID As %String, ChartID As %String) As %String
{
    Quit:$g(EpisodeID)="" ""
    //
    Set StationID=..GetPEStation($g(ChartID))   
    Quit:$g(StationID)="" ""    
    Set IAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,""))
    Quit:IAdm="" ""
    //
    Set StationSummaryDr=$O(^DHCPESS(0,"IADM",IAdm,StationID,""))
    Quit:StationSummaryDr="" ""
    Set Summary=$P($g(^DHCPESS(StationSummaryDr,"S")),"^",5)
    Quit Summary
}

/// w ##class(web.DHCPE.ResultEdit).GetPEStation(64)
ClassMethod GetPEStation(ChartID) As %String
{
    q:ChartID="NULL" ""
    q ChartID
    If ChartID="" s ChartID=%request.Get("ChartID")
    Quit:ChartID="" ""
    Set chart=##Class(epr.Chart).%OpenId(ChartID,0)
    Quit:$g(chart)="" ""
    s (itmLIST,params,parref)=""
    b //1-1
    s cs=chart.ChartSettings i cs d ##Class(epr.Chart).chartSettingsSelect(.itmLIST,.params,cs)
    b //1-2
    d chart.%Close()
    Set ItmDr=""
    Set ItemType=""
    Set I=""  For  Set I=$O(itmLIST(I))  Quit:((I="")!(ItemType="DHPE")!(ItemType="DHPECat")!(ItemType="DHPERis"))  Do
    .Set ItemID=$P(itmLIST(I),"^",1)
    .Set ItemType=$P(itmLIST(I),"^",2)
    .Set ItmDr=ItemID
    Quit:ItmDr="" ""
    s StationID=$P($g(params("DHPECat",ItmDr)),"^",1)
    i StationID="" s StationID=$P($g(params("DHPERis",ItmDr)),"^",1)
    i StationID="" s StationID=$P($g(params("DHPE",ItmDr)),"^",1)
    Quit StationID
}

/// Description: 判断医嘱项目是否已经全部执行
/// Return:      "0":没有医嘱项  "2":还有未检查的项目
/// Debug:   w ##class(web.DHCPE.ResultEdit).ItemHadApp(1,50645)
ClassMethod ItemHadApp(StationID As %String, EpisodeID As %String, DelayFlag As %String = "N")
{
    q:EpisodeID="" ""
    s LocID=$P($g(^PAADM(EpisodeID)),"^",4)
    s Flag=0
    s OEOrder=0
  
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))
    s OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other",LocID))
    s RisStations=$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))
    S MedicalStation=$g(^DHCPESetting("DHCPE","StationId_Medical",LocID))
    
    s Stations=""
    f  s OEOrder=$O(^OEORD(0,"Adm",EpisodeID,OEOrder)) q:(OEOrder="")||((Flag=2)&&(StationID'=""))  d
    .s OEOrdItem=0
    .f  s OEOrdItem=$O(^OEORD(OEOrder,"I",OEOrdItem)) q:(OEOrdItem="")||((Flag=2)&&(StationID'=""))  d
    ..s ItemMastId=$p($G(^OEORD(OEOrder,"I",OEOrdItem,1)),"^",2)
    ..q:ItemMastId=""
    ..s ORIStat=$p($G(^OEORD(OEOrder,"I",OEOrdItem,1)),"^",13)
    ..q:ORIStat=4
    ..s OEORIRowId=OEOrder_"||"_OEOrdItem
    ..q:$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)) //谢绝检查
    ..q:((DelayFlag="Y")&&($d(^User.DHCPEDelayRecordI("FlagADMOEORIIndex","Y",EpisodeID," "_OEORIRowId))))   //延期项目
    ..s Flag=1
    ..s StOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItemMastId,LocID)
    ..q:StOrderDR=""
    ..s Station=$p(StOrderDR,"||",1)
    ..q:(OtherStation=Station)||(MedicalStation=Station)   //过滤掉其他站点、药品站点
    ..q:(StationID'="")&&(StationID'=Station)             //过滤掉非本站点
    ..s AutoReturn="N"
    ..s StOrderSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StOrderDR,0)) 
    ..q:StOrderSetID=""
    ..i StOrderSetID'="" s AutoReturn=$lg($g(^CF.PE.StationOrderSetD(StOrderSetID)),7)
    ..;q:AutoReturn="N"  //站点项目组合扩展表——自动回传
    ..
    ..i (ORIStat'=6) d           //未执行
    ...i StationID'="" s Flag=2 //站点判断
    ...i StationID="" d         //总检判断增加返回站点名称
    ....s StationDesc=$p($g(^DHCPEST(Station)),"^",2)
    ....s StationDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",StationDesc,"STDesc","cls") //翻译
    ....i Stations="" d
    .....s Stations=StationDesc
    ....e  d
    .....q:(","_Stations_",")[(","_StationDesc_",")
    .....s Stations=Stations_","_StationDesc
    ..e  d
    ...i Station=LabStation d     //检验站点
    ....s ARCOS=$p($G(^OEORD(OEOrder,"I",OEOrdItem,3)),"^",10)
    ....s OEORILabEpisodeNo=$p($G(^OEORD(OEOrder,"I",OEOrdItem,3)),"^",20)
    ....s OEORIItmMastDR=$p($G(^OEORD(OEOrder,"I",OEOrdItem,1)),"^",2)
    ....s ResultStatus=##class(web.DHCPE.OEOrdItem).GetResultStatus(OEORILabEpisodeNo,OEORIItmMastDR,ARCOS,OEOrder_"||"_OEOrdItem)
    ....i (ResultStatus'="已发送")&&((ResultStatus'="已回传")) d  //检验项目还未发送的当做还未执行的项目
    .....i StationID'="" s Flag=2
    .....i StationID="" d
    ......s StationDesc=$p(^DHCPEST(Station),"^",2)
    ......s StationDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",StationDesc,"STDesc","cls") //翻译
    ......i Stations="" d
    .......s Stations=StationDesc
    ......e  d
    .......q:(","_Stations_",")[(","_StationDesc_",")
    .......s Stations=Stations_","_StationDesc
    ...e  i (("^"_RisStations_"^")[("^"_Station_"^")) d     //检查站点
    ....i (1=..RisHasReport(OEORIRowId)) d
    .....i StationID'="" s Flag=2
    .....i StationID="" d
    ......s StationDesc=$p($g(^DHCPEST(Station)),"^",2)
    ......s StationDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",StationDesc,"STDesc","cls") //翻译
    ......i Stations="" d
    .......s Stations=StationDesc
    ......e  d
    .......q:(","_Stations_",")[(","_StationDesc_",")
    .......s Stations=Stations_","_StationDesc
    
    /*
    ..s Station=0
    ..f s Station=$o(^DHCPEST(0,"STORD_ARCIM",ItemMastId,Station)) q:Station="" d
    ...//过滤掉材料
    ...q:(OtherStation=Station)||(MedicalStation=Station)
    ...//过滤掉非本站点数据
    ...q:(StationID'="")&&(StationID'=Station)
    ...s Sub=$o(^DHCPEST(0,"STORD_ARCIM",ItemMastId,Station,0))
    ...s AutoFlag=$p($G(^DHCPEST(Station,"O",Sub)),"^",6)
    ...q:AutoFlag="N"
    ...i (ORIStat'=6) d //未执行
    ....i StationID'="" s Flag=2 //站点判断
    ....i StationID="" d //总检判断增加返回站点名称
    .....s StationDesc=$p(^DHCPEST(Station),"^",2)
    .....i Stations="" d
    ......s Stations=StationDesc
    .....e d
    ......q:(","_Stations_",")[(","_StationDesc_",")
    ......s Stations=Stations_","_StationDesc
    ...e d
    ....i Station=LabStation d
    .....s ARCOS=$p($G(^OEORD(OEOrder,"I",OEOrdItem,3)),"^",10)
    .....s OEORILabEpisodeNo=$p($G(^OEORD(OEOrder,"I",OEOrdItem,3)),"^",20)
    .....s OEORIItmMastDR=$p($G(^OEORD(OEOrder,"I",OEOrdItem,1)),"^",2)
    .....s ResultStatus=##class(web.DHCPE.OEOrdItem).GetResultStatus(OEORILabEpisodeNo,OEORIItmMastDR,ARCOS,OEOrder_"||"_OEOrdItem)
    .....i (ResultStatus'="已发送")&&((ResultStatus'="已回传")) d //检验项目还未发送的当做还未执行的项目
    ......i StationID'="" s Flag=2
    ......i StationID="" d
    .......s StationDesc=$p(^DHCPEST(Station),"^",2)
    .......i Stations="" d
    ........s Stations=StationDesc
    .......e d
    ........q:(","_Stations_",")[(","_StationDesc_",")
    ........s Stations=Stations_","_StationDesc
    ....e i (("^"_RisStations_"^")[("^"_Station_"^")) d
    .....i (1=..RisHasReport(OEORIRowId)) d
    ......i StationID'="" s Flag=2
    ......i StationID="" d
    .......s StationDesc=$p(^DHCPEST(Station),"^",2)
    .......i Stations="" d
    ........s Stations=StationDesc
    .......e d
    ........q:(","_Stations_",")[(","_StationDesc_",")
    ........s Stations=Stations_","_StationDesc
     */


    i StationID'="" q Flag
    i Stations'=""  q "2"_"^"_Stations
    i Stations="" q Flag_"^"_Stations
}

ClassMethod GenStationSummary(EpisodeID As %String, ChartID As %String) As %String
{
    //Quit "this is a line"_$C(1)_"This is 2 lines"_$C(1)_"This is 3 lines!"
    Quit:$g(EpisodeID)="" ""
    Set StationID=..GetPEStation($g(ChartID))
    Quit:$g(StationID)="" ""
    Set UserId=%session.Get("LOGON.USERID")
    //Set UserId=1
    //
    s Flag=..ItemHadApp(StationID,EpisodeID)
    q:Flag'=1 Flag
    
    
    Set SummaryStr=""
    Set RLTDr=""
    For  Set RLTDr=$O(^DHCPERLT(0,"ADM",EpisodeID,RLTDr)) Quit:RLTDr=""  Do
    .Set ItemID=$P($g(^DHCPERLT(RLTDr)),"^",3)
    .Set RLTValue=$P($g(^DHCPERLT(RLTDr)),"^",4)
    .Quit:StationID'=+ItemID
    .Do ..CheckItemResult(ItemID, RLTValue, .SummaryStr)
    i SummaryStr="" s SummaryStr="未见异常"
    s ^lisatest("0425","SummaryStr")=SummaryStr
    Quit SummaryStr
}

ClassMethod CheckItemResult(ItemID As %String, RLTValue As %String, SummaryStr As %String) As %String
{
    q ""
    /*q:ItemID="" ""
    Set ItemType=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",2)
    Set ItemDesc=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",1)
    Set ItemUOMDr=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",4)
    Set ItemUOM=""
    If ItemUOMDr'="" Set ItemUOM=$P($G(^CT("UOM",ItemUOMDr)),"^",2)
    Set ItemSummary=""
    If ItemType="N" Do CheckNumResult
    If ItemType="C" Do CheckNumResult
    If ItemType="T" Do CheckTextResult
    If ItemType="S" Do CheckTextResult
    Quit ItemSummary
    //
CheckNumResult
    Set ItemSummary=""
    Set Seclect=0
    Set Chl=0
    For  Set Chl=$O(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl)) Quit:(Chl="")!(Seclect=1)  Do
    .Set Min=+$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl),"^",4)
    .Set Max=+$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl),"^",5)
    .Set Normal=$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl),"^",6)
    .Quit:+RLTValue<Min
    .Quit:+RLTValue>Max
    .Quit:Normal="Y"
    .Set Seclect=1
    .Set RLTText=$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl),"^",2)
    .Set ItemSummary=ItemID_"||"_Chl_"^"_ItemDesc_": "_RLTValue_ItemUOM_","_RLTText
    .If $g(SummaryStr)="" Set SummaryStr=ItemSummary
    .Else  Set SummaryStr=SummaryStr_$C(1)_ItemSummary
    Quit
CheckTextResult
    Set ItemSummary=""
    Set Seclect=0
    Set Chl=0
    For  Set Chl=$O(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl)) Quit:(Chl="")!(Seclect=1)  Do
    .Set RLTText=$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl),"^",2)
    .Set Normal=$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl),"^",6)
    .Quit:RLTValue'=RLTText
    .Quit:Normal="Y"
    .Set Seclect=1
    .Set ItemSummary=ItemID_"||"_Chl_"^"_ItemDesc_": "_RLTValue_ItemUOM
    .If $g(SummaryStr)="" Set SummaryStr=ItemSummary
    .Else  Set SummaryStr=SummaryStr_$C(1)_ItemSummary
    Quit*/
}

ClassMethod SaveAdmGeneralSummary(EpisodeID As %String, SummaryStr As %String) As %Status
{
    Quit:$g(EpisodeID)="" 0
    Set UserId=%session.Get("LOGON.USERID")
    
    s Return=..GeneralAdviceAudited(EpisodeID,"PAADM")
    q:Return "GeneralAdviceAudited"
    //
    Set IAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,""))
    Quit:IAdm="" 0
    //
    Set GeneralSummaryDr=$O(^DHCPEGS(0,"IADM",IAdm,""))
    If GeneralSummaryDr=""  Do
    .KILL PLIST
    .Set PLIST(2)=IAdm,PLIST(4)=+$H,PLIST(5)=UserId
    .&SQL(INSERT INTO SQLUser.DHC_PE_GeneralSummarize VALUES PLIST())
    .If 'SQLCODE Set SummDr=%ROWID Set $P(^DHCPEGS(SummDr,"S"),"^",1)=$g(SummaryStr)
    Else  Do
    .KILL PLIST
    .Set PLIST(2)=IAdm,PLIST(4)=+$H ,PLIST(5)=UserId
    .&SQL(Update SQLUser.DHC_PE_GeneralSummarize VALUES PLIST() Where GS_RowId= :GeneralSummaryDr)
    .if 'SQLCODE Set $P(^DHCPEGS(GeneralSummaryDr,"S"),"^",1)=$g(SummaryStr)
    Quit 'SQLCODE
}

ClassMethod GetAdmGeneralSummary(EpisodeID As %String) As %String
{
    Quit:$g(EpisodeID)="" ""
    //
    Set IAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,""))
    Quit:IAdm="" ""
    //
    Set GeneralSummaryDr=$O(^DHCPEGS(0,"IADM",IAdm,""))
    Quit:GeneralSummaryDr="" ""
    Set Summary=$P($g(^DHCPEGS(GeneralSummaryDr,"S")),"^",1)
    Quit Summary
}

ClassMethod SaveAdmGeneralRecommend(EpisodeID As %String, RecommendStr As %String) As %Status
{
    Quit:$g(EpisodeID)="" 0
    Set UserId=%session.Get("LOGON.USERID")
    //
    Set IAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,""))
    Quit:IAdm="" 0
    //
    Set GeneralRecommendDr=$O(^DHCPEGA(0,"IADM",IAdm,""))
    If GeneralRecommendDr=""  Do
    .KILL PLIST
    .Set PLIST(2)=IAdm,PLIST(4)=+$H ,PLIST(5)=UserId
    .&SQL(INSERT INTO SQLUser.DHC_PE_GeneralAdvice VALUES PLIST())
    .If 'SQLCODE Set RecommendDr=%ROWID Set $P(^DHCPEGA(RecommendDr,"A"),"^",1)=$g(RecommendStr)
    .//insert DHC_PE_GeneralAdviceDetail//////////////////////
    .s EDRowId=0
    .f  s EDRowId=$o(^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)) q:EDRowId=""  d
    ..q:^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)=0
    ..&sql(insert into DHC_PE_GeneralAdviceDetail(GAD_Parref,GAD_ED_DR) values(:RecommendDr,:EDRowId))
    ..///////////////////////////////////////////////////////
    Else  Do
    .KILL PLIST
    .Set PLIST(2)=IAdm,PLIST(4)=+$H ,PLIST(5)=UserId
    .&SQL(Update SQLUser.DHC_PE_GeneralAdvice VALUES PLIST() Where GA_RowId= :GeneralRecommendDr)
    .if 'SQLCODE d
    ..Set $P(^DHCPEGA(GeneralRecommendDr,"A"),"^",1)=$g(RecommendStr)
    ..//insert DHC_PE_GeneralAdviceDetail/////////////////
    ..i $o(^DHCPEGA(GeneralRecommendDr,"EDDetail",0))'="" d
    ...&sql(delete from DHC_PE_GeneralAdviceDetail where GAD_Parref=:GeneralRecommendDr)
    ..s EDRowId=0
    ..f  s EDRowId=$o(^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)) q:EDRowId=""  d
    ...q:^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)=0
    ...&sql(insert into DHC_PE_GeneralAdviceDetail(GAD_Parref,GAD_ED_DR) values(:GeneralRecommendDr,:EDRowId))
    ...///////////////////////////////////////////////////
    Quit 'SQLCODE
}

ClassMethod GetAdmGeneralRecommend(EpisodeID As %String) As %String
{
    Quit:$g(EpisodeID)="" ""
    //
    Set IAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,""))
    Quit:IAdm="" ""
    //
    Set GeneralRecommendDr=$O(^DHCPEGA(0,"IADM",IAdm,""))
    Quit:GeneralRecommendDr="" ""
    Set Recommend=$P($g(^DHCPEGA(GeneralRecommendDr,"A")),"^",1)
    Quit Recommend
}

ClassMethod GenAdmGeneralSummary(EpisodeID As %String) As %String
{
    Quit:$g(EpisodeID)="" ""
    Set UserId=%session.Get("LOGON.USERID")
    //
    Set SummaryStr=""
    Set RLTDr=""
    For  Set RLTDr=$O(^DHCPERLT(0,"ADM",EpisodeID,RLTDr)) Quit:RLTDr=""  Do
    .Set ItemID=$P($g(^DHCPERLT(RLTDr)),"^",3)
    .Set RLTValue=$P($g(^DHCPERLT(RLTDr)),"^",4)
    .Do ..CheckItemResult(ItemID, RLTValue, .SummaryStr)
    Quit SummaryStr
}

/// Debug: d ##class(web.DHCPE.ResultEdit).GenAdmGeneralRecomm(2466,71)
ClassMethod GenAdmGeneralRecomm1(EpisodeID As %String) As %String
{
    Quit:$g(EpisodeID)="" ""
    Set UserId=%session.Get("LOGON.USERID")
    
    Set SummaryStr=""
    Set RecommendationStr=""
    Set RLTDr=""
    For  Set RLTDr=$O(^DHCPERLT(0,"ADM",EpisodeID,RLTDr)) Quit:RLTDr=""  Do
    .Set ItemID=$P($g(^DHCPERLT(RLTDr)),"^",3)
    .Set RLTValue=$P($g(^DHCPERLT(RLTDr)),"^",4)
    .Set ItmResultStr=..CheckItemResult(ItemID, RLTValue, .SummaryStr)  //取得非正常标准
    .Quit:$g(ItmResultStr)=""
    .Set ItmStandard=$P($g(ItmResultStr),"^",1)
    .Quit:$g(ItmStandard)=""
    .Set RecommChl=$O(^DHCPEST(0,"ODA_ODS",ItmStandard,+ItemID,$p(ItemID,"||",2),""))
    .Quit:RecommChl=""
    .Set RecCommDr=ItemID_"||"_RecommChl
    .Set RecComm=$P($G(^DHCPEST(+ItemID,"OD",$p(ItemID,"||",2),"ODA",RecommChl,2)),"^",1) //取得该标准的建议
    .Quit:RecComm=""
    .Set ReCommStr=ItmResultStr_"^"_RecComm
    .If $g(RecommendationStr)="" Set RecommendationStr=ReCommStr
    .Else  Set RecommendationStr=RecommendationStr_$C(1)_ReCommStr
    Quit RecommendationStr
}

/// Debug: w ##class(web.DHCPE.ResultEdit).GetEDByDesc("疾病1","9")
ClassMethod GetEDByDesc(Desc, StationID)
{
    
    s ret=""
    s EDID=""
    f  s EDID=$O(^DHCPEED(0,"Conclusion",Desc,EDID)) q:(EDID="")||(ret'="")  d
    .s CurStation=$P($g(^DHCPEED(EDID,1)),"^",7)
    .q:CurStation'=StationID
    .s activeFlag=$p($g(^DHCPEED(EDID,"1")),"^",13)  //激活
    .q:activeFlag'="Y"
    .;q:$g(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDID))'="Y"
    .;s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("ED",EDID)  
    .;q:LocFlag=1 
    .s ret=EDID
    q ret
}

/// Description: 总检自动带出建议
/// Input:       EpisodeID(就诊ID),GSRowId（总检ID）
/// Debug: d ##class(web.DHCPE.ResultEdit).GenAdmGeneralRecomm("4124995","1704")
ClassMethod GenAdmGeneralRecomm(EpisodeID As %String, GSRowId As %String) As %String
{

    q:$g(EpisodeID)="" ""
    s UserId=%session.Get("LOGON.USERID")
    s IAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,""))
    q:IAdm="" 0
    k ^DHCPEGenED("GetSummarize",EpisodeID)
    k ^DHCPEDataEx("AutoSummarizeRecomm",EpisodeID)
    k ^DHCPEGenED("GetSummarizeBBED",EpisodeID)
    k ^DHCPEDataEx("AutoSummarizeRecomm","NoRelate",EpisodeID)
    k ^DHCPEDataEx("AutoSummarizeRecommSort",EpisodeID)
    
    s loc=##class(web.DHCPE.DHCPECommon).GetEDloc()
    s ADMLocID=$P($g(^PAADM(EpisodeID)),"^",4)
    //s risStationStr="^"_$G(^DHCPESetting("DHCPE","StationId_Ris"))_"^"
    //s labStation=$G(^DHCPESetting("DHCPE","StationId_Lab"))
    s risStationStr="^"_$g(^DHCPESetting("DHCPE","StationId_Ris",ADMLocID))_"^"
    s labStation=$g(^DHCPESetting("DHCPE","StationId_Lab",ADMLocID))
    s RisMerge=$G(^DHCPESetting("DHCPE","RisReportMerge",ADMLocID))
    s risStationStr=risStationStr_labStation_"^"
    s ageSexStr=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
    s sexStr=$P(ageSexStr,"^",2)
    s ageStr=$P(ageSexStr,"^",1)
    s EDRowId=0
    s Job=$J
    k ^TempDHCPE("Sort",Job)
    k ^TempDHCPE(Job,"EDRelateItem")
    d ..GetEDSort(EpisodeID,Job)
    //f  s EDRowId=$o(^DHCPEED(0,"EDLOC",loc,EDRowId)) q:EDRowId=""  d
    f  s EDRowId=$o(^DHCPEED(EDRowId)) q:EDRowId=""  d
    .q:'$d(^DHCPEED(EDRowId))
    .s LocShowDFlag=##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(EDRowId,ADMLocID)
    .q:LocShowDFlag'="Y" 
    .q:$d(^DHCPEGenED("GetSummarize",EpisodeID,EDRowId))
    .;s activeFlag=$G(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId))
    .s activeFlag=$p($g(^DHCPEED(EDRowId,"1")),"^",13)  //激活
    .q:activeFlag'="Y"
    .s HighRisk=$p($g(^DHCPEED(EDRowId,"1")),"^",8)
    .q:HighRisk="Y"
    .s ExpressID=$o(^User.DHCPEExpressI("SourceIDIndex","ED",EDRowId,0))
    .s TMPSTIDS="" /// 判断条件的时候记录当前诊断满足了哪个条件而跳出的 用于诊断显示在哪个站点下 
    .i ExpressID'=""  d
    ..s RLTIDNew=""   ///新标记id
    ..s ShowSort=""
    ..;b ;ExpressID
    ..s Express=""
    ..s QuitFlag=0
    ..s ExpressID=0
    ..f  s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","ED",EDRowId,ExpressID)) q:(ExpressID="")||(QuitFlag=1)  d
    ...s obj=##class(User.DHCPEExpress).%OpenId(ExpressID)
    ...;判断年龄范围
    ...s AgeRange=obj.EAgeRange
    ...s MinAge=$P(AgeRange,"-",1)
    ...s:MinAge="" MinAge=0 
    ...s MaxAge=$P(AgeRange,"-",2)
    ...s:MaxAge="" MaxAge=120
    ...;q:(ageStr<MinAge)||(ageStr>MaxAge)
    ...;年龄End
    ...s Express=Express_obj.EPreBracket
    ...s ItemID=obj.EItemDRGetObjectId()
    ...s NoBloodFlag=obj.ENoBloodFlag
    ...s ExCode=obj.EKBItemDtlCode
    ...//****************************************************************************
    ...//ExCode对应多个ItemID,加了一层循环 update by zf 20121210
    ...s ItemIDStr=..GetUseItemID(EpisodeID,ItemID_"^"_ExCode,EDRowId,NoBloodFlag)
    ...i ItemIDStr="" s ItemIDStr="a||b"
    ...s IsResult=0
    ...f indItem=1:1:$l(ItemIDStr,",") d
    ....s ItemID=$p(ItemIDStr,",",indItem)
    ....//
    ....i $D(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID)) d  ;;逐个判断此细项是否满足
    .....s ItemType=obj.EItemDR.ODType
    .....s Reference=obj.EReference
    .....i Reference="" s Reference=obj.EODStandardDR.ODSTextVal
    .....s Operator=obj.EOperator
    .....//s IsResult=0
    .....s RLTID=0
    .....f  s RLTID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID,RLTID)) q:(RLTID="")||(IsResult=1)  d
    ......s Result=$P(^DHCPERLT(RLTID),"^",4)
    ......s RLTIDNew=RLTID
    
    ......//
    ......i (Reference="低值")||(Reference="高值") d
    .......s Reference=..GetRealReference(RLTID,Reference)
    .......s ^temp("Reference",RLTID)=Reference
    .......//
    ......s OldResult=Result
    ......s EDID=$P(^DHCPERLT(RLTID),"^",9)
    ......i (Operator="[")||(Operator="'[") d
    .......s Result=""""_Result_""""
    .......s Reference=""""_Reference_""""
    ......e  d
    .......s:Result[("≥") Result=$P(Result,"≥",2)
    .......s:Result[("≤") Result=$P(Result,"≤",2)
    .......s:Result[("＞") Result=$P(Result,"＞",2)
    .......s:Result[("＜") Result=$P(Result,"＜",2)
    .......s:Result[(">") Result=$P(Result,">",2)
    .......s:Result[("<") Result=$P(Result,"<",2)
    ......s OneExpress=Result_Operator_Reference
    ......//如果是数值型的，并且判断包含的直接当做不符合条件
    ......i (+OldResult=OldResult)&&((Operator="[")||(Operator="'[")) d
    .......//s IsResult=0
    ......e  d
    .......s tIsResult=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(OneExpress)
    .......i tIsResult=1 d
    ........s IsResult=1
    ........s CurTMPST="^"_(+ItemID)_"^"
    ........s:(TMPSTIDS'[CurTMPST) TMPSTIDS=TMPSTIDS_CurTMPST /// 判断条件的时候记录当前诊断满足了哪个条件而跳出的 用于诊断显示在哪个站点下 
    ......s ^TempDHCPERecomm(Job,EDRowId,RLTID)=""
    ....e  d  ;;没有结果设置为0
    .....//s IsResult=0
    ...//ExCode对应多个ItemID,加了一层循环 update by zf 20121210
    ...//************************************end*************************************
    ...i ((ageStr<MinAge)||(ageStr>MaxAge)) s IsResult=0
    ...;b ;IsResult
    ...s ExpressSex=obj.ESex
    ...;性别不符设置为0
    ...i ExpressSex="" s ExpressSex="N"
    ...s:(ExpressSex'="N")&&(ExpressSex'=sexStr) IsResult=0
    ...s Express=Express_IsResult_obj.EAfterBracket_obj.ERelation
    ...s:obj.ERelation="" QuitFlag=1
    ..s rStr=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(Express)
    ..;b ;rStr
    ..i rStr d
    ...s ShowSort=$P(^DHCPERLT(RLTIDNew),"^",14)
    ...s:ShowSort="" ShowSort="9999999"
    ...s ResultOrd=$P(^DHCPERLT(RLTIDNew),"^",9) //医嘱号
    ...//检查的按检查号走
    ...s RisStudyNo=##class(web.DHCPE.HISUICommon).GetStudyNoByOEORI(ResultOrd)
    ...i (RisMerge="Y")&&(RisStudyNo'="") d
    ....s ResultOrd=RisStudyNo
    ....s ShowSort=RisStudyNo
    ....s RLTIDNew=RisStudyNo
    ...s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)="1"
    ...s EDSort=$p($g(^DHCPEED(EDRowId,"1")),"^",9)
    ...i EDSort="" s EDSort="999999"
    ...s ^DHCPEDataEx("AutoSummarizeRecommSort",EpisodeID,ResultOrd,ShowSort,RLTIDNew,EDSort,EDRowId)=""  ///add  新的结果顺序
    ...s BBSub=0
    ...f  s BBSub=$O(^DHCPEED(EDRowId,"EDBB",BBSub)) q:BBSub=""   d
    ....s BBEDID=$P(^DHCPEED(EDRowId,"EDBB",BBSub),"^",1)
    ....s ^DHCPEGenED("GetSummarizeBBED",EpisodeID,BBEDID)=""
    ...s Sort=$G(^TempDHCPE("Sort",Job,EDID))
    ...i Sort="" s Sort=1
    ...s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"Sort")=Sort
    ...s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"TmpSTID")=TMPSTIDS
    ...d ..AutoRecommFlag(EpisodeID,EDRowId)
    .e  d
    ..s conditionFlag=$g(^DHCPEDataEx("DHCPEExpertDiagnosis","ConditionFlag",EDRowId))
    ..s EDCRowId=0
    ..s AllFlag=1 //是否满足所有条件
    ..s PDFlag=0 //看是否设置了诊断条件0：没设置
    ..f  s EDCRowId=$o(^DHCPEED(EDRowId,"EDC",EDCRowId)) q:(EDCRowId="")  d
    ...s orderDetailStandardID=$P(^DHCPEED(EDRowId,"EDC",EDCRowId),"^",1)
    ...q:'$D(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)))
    ...s Normal=$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",6)
    ...q:Normal="Y"
    ...s orderDetailID=$P(orderDetailStandardID,"||",1,2)
    ...q:orderDetailID=""
    ...s ItemType=$P($g(^DHCPEST(+orderDetailID,"OD",$P(orderDetailID,"||",2))),"^",2)
    ...s curSex=$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",1)
    ...//s curSex=$P($g(^DHCPEST(+orderDetailID,"OD",$P(orderDetailID,"||",2))),"^",9)
    ...q:(curSex'="N")&&(curSex'=sexStr)
    ...;s PDFlag=1  //有设置条件
    ...s risFlag=0
    ...s:risStationStr[("^"_+orderDetailStandardID_"^") risFlag=1
    ...d GetAllSummarize
    ..i (PDFlag=1)&&(AllFlag=1) d
    ...s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)="1"
    ...s BBSub=0
    ...f  s BBSub=$O(^DHCPEED(EDRowId,"EDBB",BBSub)) q:BBSub=""   d
    ....s BBEDID=$P(^DHCPEED(EDRowId,"EDBB",BBSub),"^",1)
    ....s ^DHCPEGenED("GetSummarizeBBED",EpisodeID,BBEDID)=""
    ...s Sort=$G(^TempDHCPE("Sort",Job,EDID))
    ...i Sort="" s Sort=1
    ...s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"Sort")=Sort
    ...d ..AutoRecommFlag(EpisodeID,EDRowId)
    
    s Flag=..AddSpecicalED(EpisodeID)
    i Flag=0 d
    .s LocID=$P($g(^PAADM(EpisodeID)),"^",4)
    .;s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)="1"
    .;s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"Sort")=100
    
    
    
    k ^TempDHCPE("Sort",Job)
    
    s SQLCODE=0
    i $O(^DHCPEGS(GSRowId,"Diagnosis",0))'="" d
    .&sql(delete from DHC_PE_GSDiagnosis where GSD_ParRef=:GSRowId and GSD_GenType='S')
    .i SQLCODE=100 s SQLCODE=0
    
    k ^DHCPEGenED("HadED",EpisodeID)
    s EDSub=0
    f  s EDSub=$O(^DHCPEGS(GSRowId,"Diagnosis",EDSub)) q:EDSub=""  d
    .s Status=$P($g(^DHCPEGS(GSRowId,"Diagnosis",EDSub)),"^",11)
    .q:Status="2"
    .s EDID=$P($g(^DHCPEGS(GSRowId,"Diagnosis",EDSub)),"^",1)
    .s ^DHCPEGenED("HadED",EpisodeID,EDID)=""
    
    
    s Sort1=50
    s ResultOrd="" 
    f  s ResultOrd=$O(^DHCPEDataEx("AutoSummarizeRecommSort",EpisodeID,ResultOrd)) q:ResultOrd=""  d
    .s ShowSort=""
    .f  s ShowSort=$O(^DHCPEDataEx("AutoSummarizeRecommSort",EpisodeID,ResultOrd,ShowSort)) q:ShowSort=""  d
    ..s EDID=""
    ..f  s EDID=$o(^DHCPEDataEx("AutoSummarizeRecommSort",EpisodeID,ResultOrd,ShowSort,EDID)) q:EDID=""  d
    ...s EDSort=""
    ...f  s EDSort=$o(^DHCPEDataEx("AutoSummarizeRecommSort",EpisodeID,ResultOrd,ShowSort,EDID,EDSort)) q:EDSort=""  d
    ....s EDRowId=""
    ....f  s EDRowId=$o(^DHCPEDataEx("AutoSummarizeRecommSort",EpisodeID,ResultOrd,ShowSort,EDID,EDSort,EDRowId)) q:EDRowId=""  d
    .....s Sort1=Sort1+1
    .....
    .....s UpdateDate=+$H
    .....s UpdateTime=$p($H,",",2) 
    .....//s EDRowId=0
    .....//f  s EDRowId=$o(^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)) q:EDRowId=""  d
    .....q:^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)=0
    .....q:$D(^DHCPEGenED("GetSummarizeBBED",EpisodeID,EDRowId)) ;被排斥的退出
    .....q:$D(^DHCPEGenED("HadED",EpisodeID,EDRowId)) ;已经有的建议退出
    .....s Advice=$p($g(^DHCPEED(EDRowId,"Detail")),"^",1)
    .....s Advice=##class(web.DHCPE.DHCPEExpertDiagnosis).GetKeyReplaceStr(EpisodeID,EDRowId)
    .....s DisplayDesc=$p($g(^DHCPEED(EDRowId,"1")),"^",1)
    .....s DisplayDesc=##class(web.DHCPE.DHCPEExpertDiagnosis).ReplactApp(EpisodeID,DisplayDesc)
    .....s Sort=+$G(^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"Sort"))
    .....
    .....s STDR=$p($g(^DHCPEED(EDRowId,"1")),"^",7)
    .....
    ...../// 判断这个人是否有该站点下的医嘱 没有就取这个人的最后一个站点
    .....s ConditionSTIDS=$G(^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"TmpSTID")) // 满足哪些站点的条件
    .....//s:(EDRowId=10335) ^DHCPERecord("GetEDStation")=EpisodeID_"&"_STDR_"&"_ConditionSTIDS
    .....s STDR=..GetEDStation(EpisodeID,STDR,ConditionSTIDS)
    .....q:STDR=""
    .....
    .....s STLocDR=$p($g(^DHCPEED(EDRowId,"1")),"^",10)
    .....s DisplayDesc=##class(web.DHCPE.DHCPEExpertDiagnosis).ReplactApp(EpisodeID,DisplayDesc)
    .....s Sort=+$G(^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"Sort"))
    .....&sql(insert into DHC_PE_GSDiagnosis(GSD_ParRef,GSD_ED_DR,
           GSD_UpdateUser_DR,GSD_UpdateDate,GSD_UpdateTime,GSD_GenType,GSD_Advice,GSD_Sort,GSD_Status,GSD_ST_DR,GSD_STloc_DR)
           values(:GSRowId,:EDRowId,:UserId,:UpdateDate,:UpdateTime,'S',:Advice,:Sort1,'0',:STDR,:STLocDR))
    .....
    .....
    .....
    .....i SQLCODE=0 d
    ......s Sort=$I(^DHCPEED(EDRowId,"UseCount"))
    ......s GSDRowId=%ROWID
    ......s ResultInfo=##class(web.DHCPE.ReportGetInfor).GetAdviceResult(EDRowId,EpisodeID)
    ......s DisplayDesc="["_DisplayDesc_"]"
    ......i ResultInfo'="" s DisplayDesc=DisplayDesc_ResultInfo
    ......s ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId)=DisplayDesc  //Add 20080728
    ......;i $g(DisplayDesc)="" s DisplayDesc="空"
    ......;s ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",DisplayDesc,GSDRowId)=$h   //Add 20080728
    ......d UpdateGSEDC
    
    
    i $g(^DHCPESetting("DHCPE","PosAdvice",ADMLocID))=1
    {
    s ItemID=""
    f  s ItemID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID)) q:(ItemID="")  d
    .q:$d(^TempDHCPE(Job,"EDRelateItem",ItemID)) //细项已经使用
    .s RLTID=0
    .f  s RLTID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID,RLTID)) q:(RLTID="")  d
    ..s Result=$P($g(^DHCPERLT(RLTID)),"^",4)
    ..s IsNormal=$P($g(^DHCPERLT(RLTID)),"^",7)
    ..
    ..q:IsNormal=1  //只使用阳性体征
    ..s OEORD=$P($g(^DHCPERLT(RLTID)),"^",9)
    ..
    ..i Result["诊断意见" d
    ...s Result=..SplitRisResult(Result,3)
    ..s ARCIM=$P($g(^DHCPERLT(RLTID)),"^",2)
    ..s ARCIMDesc=$P($g(^ARCIM(+ARCIM,1,1)),"^",2)
    ..//根据医嘱项获取站点分类ID
    ..s STLocId=""
    ..s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIM,ADMLocID)
    ..q:StatOrderID="" 
    ..s STLocId=##class(web.DHCPE.CT.HISUICommon).GetStatCatIDBySTOrderID(StatOrderID,ADMLocID)
    ..;s STOrdCatSortID=$o(^CF.PE.StationOrdSortI("ORD","IdxOfOrderDR",StatOrderID,0))
    ..;i STOrdCatSortID'="" d
    ..;.s STLocId=$lg(^CF.PE.StationOrdSortD(STOrdCatSortID),2)
    ..
    ..i Result[$c(10) s LoopStr=$c(10)
    ..e  d
    ...s LoopStr="；"
    ...i Result[";" s LoopStr=";"
    ..for iLoop=1:1:$l(Result,LoopStr) d //拆分检查意见
    ...s oneResult=$p(Result,LoopStr,iLoop)
    ...q:oneResult=""
    ...
    ...i labStation=+ItemID d
    ....s Ranges=$G(^DHCPEDataEx("DHCPEResult",RLTID,"Ranges"))
    ....s Unit=$G(^DHCPEDataEx("DHCPEResult",RLTID,"Unit"))
    ....s:Ranges'="" Ranges=Unit_" ("_Ranges_")"
    ....s TSInfo=oneResult
    ....s SInfo=##class(web.DHCPE.TransResult).GetLabResultArrowNew(RLTID)
    ....s:SInfo="2" TSInfo="升高" //TSInfo="↑"
    ....s:SInfo="0" TSInfo="降低" //TSInfo="↓"
    ....i oneResult["阳性" s TSInfo="阳性"
    ....s ODDesc=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",1)
    ....s oneResult=ODDesc_TSInfo //ARCIMDesc_" "_ODDesc_"："_Result_" "_TSInfo_" "_Ranges
    ...e  d
    ....s ODDesc=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",1)
    
    ....Set Chl=0,TSInfo=""
    ....For  Set Chl=$O(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl)) Quit:(Chl="")  Do
    .....set myData=^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl)
    .....set tempMin=+$P(myData,"^",4)
    .....set tempMax=+$P(myData,"^",5)
    .....i (Result>=tempMin)&&(Result<tempMax) s TSInfo=$P(myData,"^",2)
    ....i TSInfo'="" s oneResult=TSInfo
    ....e  s oneResult=ODDesc_oneResult
    ....
    ....i ODDesc["-检查结果" d
    .....s oneResult=$p(Result,LoopStr,iLoop)
    .....s oneResult=##class(web.DHCPE.ReportGetInfor).Replace(oneResult,"1、","")
    .....s oneResult=##class(web.DHCPE.ReportGetInfor).Replace(oneResult,"2、","")
    .....s oneResult=##class(web.DHCPE.ReportGetInfor).Replace(oneResult,"3、","")
    .....s oneResult=##class(web.DHCPE.ReportGetInfor).Replace(oneResult,"4、","")
    .....s oneResult=##class(web.DHCPE.ReportGetInfor).Replace(oneResult,"5、","")
    .....s oneResult=##class(web.DHCPE.ReportGetInfor).Replace(oneResult,"6、","")
    .....s oneResult=##class(web.DHCPE.ReportGetInfor).Replace(oneResult,"。","")
    ....
    ...s DisplayDesc=oneResult
    ...s EDRowId=..GetEDByDesc(DisplayDesc,+ItemID)
    ...i EDRowId="" s EDRowId=##class(web.DHCPE.ResultNew).GetDefaultEDByStation(+ItemID,STLocId)
    
    ...;i EDRowId="" d  //找不到建议，插入1条默认
    ....;s DefaultCode=##class(web.DHCPE.DHCPEExpertDiagnosis).GetMaxCode()
    ....;s DefaultInstring=DefaultCode_"^"_"默认"_"^"_"默认"_"^N^N^"_UserId_"^^"_"MR"_"^"_+ItemID_"^Y^^^N^^"
    
    ....;s DefaultInfo=##class(web.DHCPE.DHCPEExpertDiagnosis).InsertED(DefaultInstring)
    ....;s EDRowId=$p(DefaultInfo,"^",2)
    
    ...
    ...q:EDRowId=""
    
    
    ...s Advice=$p($g(^DHCPEED(EDRowId,"Detail")),"^",1)
    ...
    ...s Advice=##class(web.DHCPE.DHCPEExpertDiagnosis).GetKeyReplaceStr(EpisodeID,EDRowId)
    ...s EDID=0  //找到结论对应的建议
    ...f  s EDID=$O(^DHCPEED(0,"Conclusion",DisplayDesc,EDID)) q:EDID=""  d
    ....s LocShowDFlag=##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(EDID,ADMLocID)
    ....q:LocShowDFlag'="Y"
    ....;s activeFlag=$G(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDID))
    ....s activeFlag=$p($g(^DHCPEED(EDID,"1")),"^",13)  //激活
    ....q:activeFlag'="Y"
    ....;q:LocID=""
    ....;q:'$D(^DHCPEED(0,"EDLOC",LocID,EDID))
    ....s CurStation=$P($g(^DHCPEED(EDID,1)),"^",7)
    ....q:CurStation'=+ItemID
    ....s Advice=$P($g(^DHCPEED(EDID,"Detail")),"^",1)
    ...i Advice="默认" s Advice=""
    ...s Sort=$G(^TempDHCPE("Sort",Job,OEORD))
    ...i Sort="" s Sort=1
    ...q:oneResult["未见明显异常"  
    ...q:oneResult["未见异常"
    ...q:oneResult["窦性心率"
    ...s STDR=+ItemID
    ...s STLocDR=$p($g(^DHCPEED(EDRowId,"1")),"^",10)
    ...&sql(insert into DHC_PE_GSDiagnosis(GSD_ParRef,GSD_ED_DR,
           GSD_UpdateUser_DR,GSD_UpdateDate,GSD_UpdateTime,GSD_GenType,GSD_Advice,GSD_Sort,GSD_Status,GSD_ST_DR,GSD_STloc_DR)
           values(:GSRowId,:EDRowId,:UserId,:UpdateDate,:UpdateTime,'S',:Advice,:Sort,'0',:STDR,:STLocDR))
    ...i SQLCODE=0 d
    ....s GSDRowId=%ROWID
    ....s DisplayDesc="["_DisplayDesc_"]"
    ....s ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId)=DisplayDesc
    ....d UpdateGSEDC
    
    }
    
    k ^DHCPEGenED("GetSummarize",EpisodeID)
    k ^DHCPEGenED("GetSummarizeBBED",EpisodeID)
    k ^DHCPEGenED("HadED",EpisodeID)
    q SQLCODE

GetAllSummarize
    s:'$D(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID)) Flag=0,AllFlag=0
    If ItemType="N" Do CheckNumResult
    If ItemType="C" Do CheckNumResult
    If ItemType="T" Do CheckTextResult
    If ItemType="S" Do CheckTextResult
    q
    
CheckNumResult
    s Min=+$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",4)
    s Max=+$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",5)
    s rltID=0
    f  s rltID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID,rltID)) q:rltID=""  d
    .s Flag=1
    .s PDFlag=1
    .s rltValue=$P($g(^DHCPERLT(rltID)),"^",4)
    .s:+rltValue<Min Flag=0,AllFlag=0
    .s:+rltValue>Max Flag=0,AllFlag=0
    .q:Flag=0
    .s EDID=$P(^DHCPERLT(rltID),"^",9)
    .i conditionFlag'="1" d
    ..s Sort=$G(^TempDHCPE("Sort",Job,EDID))
    ..i Sort="" s Sort=1
    ..s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"Sort")=Sort
    ..s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)=1
    ..s ^DHCPEDataEx("AutoSummarizeRecomm",EpisodeID,rltID)="Y"

    
    q
CheckTextResult
    s standardText=$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",2)
    s StrFlag=0
    s rltID=0
    f  s rltID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID,rltID)) q:rltID=""  d
    .s Flag=1
    .s PDFlag=1
    .s rltValue=$P($g(^DHCPERLT(rltID)),"^",4) 
    .// 对于选择类型： 如果一个细项对应多个选择项结果，则没有与诊断关联的选择项，不标记
    .//s:(rltValue'=standardText)&&(risFlag=0) Flag=0 ,^DHCPEDataEx("AutoSummarizeRecomm","NoRelate",EpisodeID,rltID)=1 //,AllFlag=0  
    .//s:(rltValue'[standardText)&&(risFlag=1) Flag=0 ,^DHCPEDataEx("AutoSummarizeRecomm","NoRelate",EpisodeID,rltID)=1 //,AllFlag=0
    .s:(rltValue'=standardText)&&(ItemType="S") Flag=0 ,^DHCPEDataEx("AutoSummarizeRecomm","NoRelate",EpisodeID,rltID)=1 //,AllFlag=0  
    .s:(rltValue'[standardText)&&(ItemType="T") Flag=0 ,^DHCPEDataEx("AutoSummarizeRecomm","NoRelate",EpisodeID,rltID)=1 //,AllFlag=0
    
    .q:Flag=0
    .s StrFlag=1
    .s EDID=$P(^DHCPERLT(rltID),"^",9)
    .i conditionFlag'="1" d
    ..s Sort=$G(^TempDHCPE("Sort",Job,EDID))
    ..i Sort="" s Sort=1
    ..s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"Sort")=Sort
    ..s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)=1
    ..s ^DHCPEDataEx("AutoSummarizeRecomm",EpisodeID,rltID)="Y"
    s:StrFlag=0 AllFlag=0
    q
GetAllExpressSummarize
    q:'$D(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID))
    If ItemType="N" Do CheckExpressNumResult
    If ItemType="C" Do CheckExpressNumResult
    If ItemType="T" Do CheckExpressTextResult
    If ItemType="S" Do CheckExpressTextResult
    q
    
CheckExpressNumResult
    s Min=+$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",4)
    s Max=+$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",5)
    s rltID=0
    f  s rltID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID,rltID)) q:rltID=""  d
    .s Flag=1
    .s PDFlag=1
    .s EDID=$P(^DHCPERLT(rltID),"^",9)
    .s rltValue=$P($g(^DHCPERLT(rltID)),"^",4)
    .s:+rltValue<Min Flag=0
    .s:+rltValue>Max Flag=0
    .q:Flag=0
    .s OneFlag=1  ;满足
    q
CheckExpressTextResult
    s standardText=$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",2)
    s rltID=0
    f  s rltID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID,rltID)) q:rltID=""  d
    .s Flag=1
    .s PDFlag=1
    .s rltValue=$P($g(^DHCPERLT(rltID)),"^",4)
    .s EDID=$P(^DHCPERLT(rltID),"^",9) 
    .// 对于选择类型： 如果一个细项对应多个选择项结果，则没有与诊断关联的选择项，不标记
    .s:(rltValue'=standardText)&&(ItemType="S") Flag=0  
    .s:(rltValue'[standardText)&&(ItemType="T") Flag=0
    .q:Flag=0
    .s OneFlag=1  ;满足
    
    q
UpdateGSEDC
    s DelEDCRowId=$g(^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",GSDRowId))
    q:DelEDCRowId'=""
    s EDCRelate=$o(^DHCPEEDCR(0,"EDDR",EDRowId,0))
    q:EDCRelate=""
    s EDCRowID=$P($g(^DHCPEEDCR(EDCRelate)),"^",2)
    q:EDCRowID=""
    Set ^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",GSDRowId)=EDCRowID
    Set ^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",0,"EDCDR",+GSDRowId,EDCRowID,GSDRowId)=""

    q
}

ClassMethod GenAdmGeneralRecommBak(EpisodeID As %String, GSRowId As %String) As %String
{

    q:$g(EpisodeID)="" ""
    s UserId=%session.Get("LOGON.USERID")
    s IAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,""))
    q:IAdm="" 0
    k ^DHCPEGenED("GetSummarize",EpisodeID)
    k ^DHCPEDataEx("AutoSummarizeRecomm",EpisodeID)
    k ^DHCPEGenED("GetSummarizeBBED",EpisodeID)
    k ^DHCPEDataEx("AutoSummarizeRecomm","NoRelate",EpisodeID)
   
    s loc=##class(web.DHCPE.DHCPECommon).GetEDloc()
    s ADMLocID=$P($g(^PAADM(EpisodeID)),"^",4)
    //s risStationStr="^"_$G(^DHCPESetting("DHCPE","StationId_Ris"))_"^"
    //s labStation=$G(^DHCPESetting("DHCPE","StationId_Lab"))
    s risStationStr="^"_$g(^DHCPESetting("DHCPE","StationId_Ris",ADMLocID))_"^"
    s labStation=$g(^DHCPESetting("DHCPE","StationId_Lab",ADMLocID))

    s risStationStr=risStationStr_labStation_"^"
    s ageSexStr=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
    s sexStr=$P(ageSexStr,"^",2)
    s ageStr=$P(ageSexStr,"^",1)
    s EDRowId=0
    s Job=$J
    k ^TempDHCPE("Sort",Job)
    k ^TempDHCPE(Job,"EDRelateItem")
    d ..GetEDSort(EpisodeID,Job)
    //f  s EDRowId=$o(^DHCPEED(0,"EDLOC",loc,EDRowId)) q:EDRowId=""  d
    f  s EDRowId=$o(^DHCPEED(EDRowId)) q:EDRowId=""  d
    .q:'$d(^DHCPEED(EDRowId))
    .s LocShowDFlag=##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(EDRowId,ADMLocID)
    .q:LocShowDFlag'="Y" 
    .q:$d(^DHCPEGenED("GetSummarize",EpisodeID,EDRowId))
    .;s activeFlag=$G(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId))
    .s activeFlag=$p($g(^DHCPEED(EDRowId,"1")),"^",13)  //激活
    .q:activeFlag'="Y"
    .s HighRisk=$p($g(^DHCPEED(EDRowId,"1")),"^",8)
    .q:HighRisk="Y"
    .s ExpressID=$o(^User.DHCPEExpressI("SourceIDIndex","ED",EDRowId,0))
    .s TMPSTIDS="" /// 判断条件的时候记录当前诊断满足了哪个条件而跳出的 用于诊断显示在哪个站点下 
    .i ExpressID'=""  d
    ..;b ;ExpressID
    ..s Express=""
    ..s QuitFlag=0
    ..s ExpressID=0
    ..f  s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","ED",EDRowId,ExpressID)) q:(ExpressID="")||(QuitFlag=1)  d
    ...s obj=##class(User.DHCPEExpress).%OpenId(ExpressID)
    ...;判断年龄范围
    ...s AgeRange=obj.EAgeRange
    ...s MinAge=$P(AgeRange,"-",1)
    ...s:MinAge="" MinAge=0 
    ...s MaxAge=$P(AgeRange,"-",2)
    ...s:MaxAge="" MaxAge=120
    ...;q:(ageStr<MinAge)||(ageStr>MaxAge)
    ...;年龄End
    ...s Express=Express_obj.EPreBracket
    ...s ItemID=obj.EItemDRGetObjectId()
    ...s NoBloodFlag=obj.ENoBloodFlag
    ...s ExCode=obj.EKBItemDtlCode
    ...//****************************************************************************
    ...//ExCode对应多个ItemID,加了一层循环 update by zf 20121210
    ...s ItemIDStr=..GetUseItemID(EpisodeID,ItemID_"^"_ExCode,EDRowId,NoBloodFlag)
    ...i ItemIDStr="" s ItemIDStr="a||b"
    ...s IsResult=0
    ...f indItem=1:1:$l(ItemIDStr,",") d
    ....s ItemID=$p(ItemIDStr,",",indItem)
    ....//
    ....i $D(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID)) d  ;;逐个判断此细项是否满足
    .....s ItemType=obj.EItemDR.ODType
    .....s Reference=obj.EReference
    .....i Reference="" s Reference=obj.EODStandardDR.ODSTextVal
    .....s Operator=obj.EOperator
    .....//s IsResult=0
    .....s RLTID=0
    .....f  s RLTID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID,RLTID)) q:(RLTID="")||(IsResult=1)  d
    ......s Result=$P(^DHCPERLT(RLTID),"^",4)
    ......//
    ......i (Reference="低值")||(Reference="高值") d
    .......s Reference=..GetRealReference(RLTID,Reference)
    .......s ^temp("Reference",RLTID)=Reference
    .......//
    ......s OldResult=Result
    ......s EDID=$P(^DHCPERLT(RLTID),"^",9)
    ......i (Operator="[")||(Operator="'[") d
    .......s Result=""""_Result_""""
    .......s Reference=""""_Reference_""""
    ......e  d
    .......s:Result[("≥") Result=$P(Result,"≥",2)
    .......s:Result[("≤") Result=$P(Result,"≤",2)
    .......s:Result[("＞") Result=$P(Result,"＞",2)
    .......s:Result[("＜") Result=$P(Result,"＜",2)
    .......s:Result[(">") Result=$P(Result,">",2)
    .......s:Result[("<") Result=$P(Result,"<",2)
    ......s OneExpress=Result_Operator_Reference
    ......//如果是数值型的，并且判断包含的直接当做不符合条件
    ......i (+OldResult=OldResult)&&((Operator="[")||(Operator="'[")) d
    .......//s IsResult=0
    ......e  d
    .......s tIsResult=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(OneExpress)
    .......i tIsResult=1 d
    ........s IsResult=1
    ........s CurTMPST="^"_(+ItemID)_"^"
    ........s:(TMPSTIDS'[CurTMPST) TMPSTIDS=TMPSTIDS_CurTMPST /// 判断条件的时候记录当前诊断满足了哪个条件而跳出的 用于诊断显示在哪个站点下 
    ......s ^TempDHCPERecomm(Job,EDRowId,RLTID)=""
    ....e  d  ;;没有结果设置为0
    .....//s IsResult=0
    ...//ExCode对应多个ItemID,加了一层循环 update by zf 20121210
    ...//************************************end*************************************
    ...i ((ageStr<MinAge)||(ageStr>MaxAge)) s IsResult=0
    ...;b ;IsResult
    ...s ExpressSex=obj.ESex
    ...;性别不符设置为0
    ...i ExpressSex="" s ExpressSex="N"
    ...s:(ExpressSex'="N")&&(ExpressSex'=sexStr) IsResult=0
    ...s Express=Express_IsResult_obj.EAfterBracket_obj.ERelation
    ...s:obj.ERelation="" QuitFlag=1
    ..s rStr=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(Express)
    ..;b ;rStr
    ..i rStr d
    ...s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)="1"
    ...s BBSub=0
    ...f  s BBSub=$O(^DHCPEED(EDRowId,"EDBB",BBSub)) q:BBSub=""   d
    ....s BBEDID=$P(^DHCPEED(EDRowId,"EDBB",BBSub),"^",1)
    ....s ^DHCPEGenED("GetSummarizeBBED",EpisodeID,BBEDID)=""
    ...s Sort=$G(^TempDHCPE("Sort",Job,EDID))
    ...i Sort="" s Sort=1
    ...s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"Sort")=Sort
    ...s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"TmpSTID")=TMPSTIDS
    ...d ..AutoRecommFlag(EpisodeID,EDRowId)
    .e  d
    ..s conditionFlag=$g(^DHCPEDataEx("DHCPEExpertDiagnosis","ConditionFlag",EDRowId))
    ..s EDCRowId=0
    ..s AllFlag=1 //是否满足所有条件
    ..s PDFlag=0 //看是否设置了诊断条件0：没设置
    ..f  s EDCRowId=$o(^DHCPEED(EDRowId,"EDC",EDCRowId)) q:(EDCRowId="")  d
    ...s orderDetailStandardID=$P(^DHCPEED(EDRowId,"EDC",EDCRowId),"^",1)
    ...q:'$D(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)))
    ...s Normal=$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",6)
    ...q:Normal="Y"
    ...s orderDetailID=$P(orderDetailStandardID,"||",1,2)
    ...q:orderDetailID=""
    ...s ItemType=$P($g(^DHCPEST(+orderDetailID,"OD",$P(orderDetailID,"||",2))),"^",2)
    ...s curSex=$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",1)
    ...//s curSex=$P($g(^DHCPEST(+orderDetailID,"OD",$P(orderDetailID,"||",2))),"^",9)
    ...q:(curSex'="N")&&(curSex'=sexStr)
    ...;s PDFlag=1  //有设置条件
    ...s risFlag=0
    ...s:risStationStr[("^"_+orderDetailStandardID_"^") risFlag=1
    ...d GetAllSummarize
    ..i (PDFlag=1)&&(AllFlag=1) d
    ...s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)="1"
    ...s BBSub=0
    ...f  s BBSub=$O(^DHCPEED(EDRowId,"EDBB",BBSub)) q:BBSub=""   d
    ....s BBEDID=$P(^DHCPEED(EDRowId,"EDBB",BBSub),"^",1)
    ....s ^DHCPEGenED("GetSummarizeBBED",EpisodeID,BBEDID)=""
    ...s Sort=$G(^TempDHCPE("Sort",Job,EDID))
    ...i Sort="" s Sort=1
    ...s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"Sort")=Sort
    ...d ..AutoRecommFlag(EpisodeID,EDRowId)
    
    s Flag=..AddSpecicalED(EpisodeID)
    i Flag=0 d
    .s LocID=$P($g(^PAADM(EpisodeID)),"^",4)
    .;s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)="1"
    .;s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"Sort")=100
    
    
    
    k ^TempDHCPE("Sort",Job)
    
    s SQLCODE=0
    i $O(^DHCPEGS(GSRowId,"Diagnosis",0))'="" d
    .&sql(delete from DHC_PE_GSDiagnosis where GSD_ParRef=:GSRowId and GSD_GenType='S')
    .i SQLCODE=100 s SQLCODE=0
    
    k ^DHCPEGenED("HadED",EpisodeID)
    s EDSub=0
    f  s EDSub=$O(^DHCPEGS(GSRowId,"Diagnosis",EDSub)) q:EDSub=""  d
    .s Status=$P($g(^DHCPEGS(GSRowId,"Diagnosis",EDSub)),"^",11)
    .q:Status="2"
    .s EDID=$P($g(^DHCPEGS(GSRowId,"Diagnosis",EDSub)),"^",1)
    .s ^DHCPEGenED("HadED",EpisodeID,EDID)=""
    
    s EDRowId=0
    s UpdateDate=+$H
    s UpdateTime=$p($H,",",2) 
    f  s EDRowId=$o(^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)) q:EDRowId=""  d
    .q:^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)=0
    .q:$D(^DHCPEGenED("GetSummarizeBBED",EpisodeID,EDRowId)) ;被排斥的退出
    .q:$D(^DHCPEGenED("HadED",EpisodeID,EDRowId)) ;已经有的建议退出
    .s Advice=$p($g(^DHCPEED(EDRowId,"Detail")),"^",1)
    .s Advice=##class(web.DHCPE.DHCPEExpertDiagnosis).GetKeyReplaceStr(EpisodeID,EDRowId)
    .s DisplayDesc=$p($g(^DHCPEED(EDRowId,"1")),"^",1)
    .s DisplayDesc=##class(web.DHCPE.DHCPEExpertDiagnosis).ReplactApp(EpisodeID,DisplayDesc)
    .s Sort=+$G(^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"Sort"))
    .
    .s STDR=$p($g(^DHCPEED(EDRowId,"1")),"^",7)
    .
    ./// 判断这个人是否有该站点下的医嘱 没有就取这个人的最后一个站点
    .s ConditionSTIDS=$G(^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"TmpSTID")) // 满足哪些站点的条件
    .//s:(EDRowId=10335) ^DHCPERecord("GetEDStation")=EpisodeID_"&"_STDR_"&"_ConditionSTIDS
    .s STDR=..GetEDStation(EpisodeID,STDR,ConditionSTIDS)
    .q:STDR=""
    .
    .s STLocDR=$p($g(^DHCPEED(EDRowId,"1")),"^",10)
    .s DisplayDesc=##class(web.DHCPE.DHCPEExpertDiagnosis).ReplactApp(EpisodeID,DisplayDesc)
    .s Sort=+$G(^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"Sort"))
    .&sql(insert into DHC_PE_GSDiagnosis(GSD_ParRef,GSD_ED_DR,
           GSD_UpdateUser_DR,GSD_UpdateDate,GSD_UpdateTime,GSD_GenType,GSD_Advice,GSD_Sort,GSD_Status,GSD_ST_DR,GSD_STloc_DR)
           values(:GSRowId,:EDRowId,:UserId,:UpdateDate,:UpdateTime,'S',:Advice,:Sort,'0',:STDR,:STLocDR))
    .
    .
    .
    .i SQLCODE=0 d
    ..s Sort=$I(^DHCPEED(EDRowId,"UseCount"))
    ..s GSDRowId=%ROWID
    ..s ResultInfo=##class(web.DHCPE.ReportGetInfor).GetAdviceResult(EDRowId,EpisodeID)
    ..s DisplayDesc="["_DisplayDesc_"]"
    ..i ResultInfo'="" s DisplayDesc=DisplayDesc_ResultInfo
    ..s ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId)=DisplayDesc  //Add 20080728
    ..;i $g(DisplayDesc)="" s DisplayDesc="空"
    ..;s ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",DisplayDesc,GSDRowId)=$h   //Add 20080728
    ..d UpdateGSEDC
    
    
    i $g(^DHCPESetting("DHCPE","PosAdvice",ADMLocID))=1
    {
    s ItemID=""
    f  s ItemID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID)) q:(ItemID="")  d
    .q:$d(^TempDHCPE(Job,"EDRelateItem",ItemID)) //细项已经使用
    .s RLTID=0
    .f  s RLTID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID,RLTID)) q:(RLTID="")  d
    ..s Result=$P($g(^DHCPERLT(RLTID)),"^",4)
    ..s IsNormal=$P($g(^DHCPERLT(RLTID)),"^",7)
    ..
    ..q:IsNormal=1  //只使用阳性体征
    ..s OEORD=$P($g(^DHCPERLT(RLTID)),"^",9)
    ..
    ..i Result["诊断意见" d
    ...s Result=..SplitRisResult(Result,3)
    ..s ARCIM=$P($g(^DHCPERLT(RLTID)),"^",2)
    ..s ARCIMDesc=$P($g(^ARCIM(+ARCIM,1,1)),"^",2)
    ..//根据医嘱项获取站点分类ID
    ..s STLocId=""
    ..s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIM,ADMLocID)
    ..q:StatOrderID="" 
    ..s STLocId=##class(web.DHCPE.CT.HISUICommon).GetStatCatIDBySTOrderID(StatOrderID,ADMLocID)
    ..;s STOrdCatSortID=$o(^CF.PE.StationOrdSortI("ORD","IdxOfOrderDR",StatOrderID,0))
    ..;i STOrdCatSortID'="" d
    ..;.s STLocId=$lg(^CF.PE.StationOrdSortD(STOrdCatSortID),2)
    ..
    ..i Result[$c(10) s LoopStr=$c(10)
    ..e  d
    ...s LoopStr="；"
    ...i Result[";" s LoopStr=";"
    ..for iLoop=1:1:$l(Result,LoopStr) d //拆分检查意见
    ...s oneResult=$p(Result,LoopStr,iLoop)
    ...q:oneResult=""
    ...
    ...i labStation=+ItemID d
    ....s Ranges=$G(^DHCPEDataEx("DHCPEResult",RLTID,"Ranges"))
    ....s Unit=$G(^DHCPEDataEx("DHCPEResult",RLTID,"Unit"))
    ....s:Ranges'="" Ranges=Unit_" ("_Ranges_")"
    ....s TSInfo=oneResult
    ....s SInfo=##class(web.DHCPE.TransResult).GetLabResultArrowNew(RLTID)
    ....s:SInfo="2" TSInfo="升高" //TSInfo="↑"
    ....s:SInfo="0" TSInfo="降低" //TSInfo="↓"
    ....i oneResult["阳性" s TSInfo="阳性"
    ....s ODDesc=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",1)
    ....s oneResult=ODDesc_TSInfo //ARCIMDesc_" "_ODDesc_"："_Result_" "_TSInfo_" "_Ranges
    ...e  d
    ....s ODDesc=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",1)
    
    ....Set Chl=0,TSInfo=""
    ....For  Set Chl=$O(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl)) Quit:(Chl="")  Do
    .....set myData=^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl)
    .....set tempMin=+$P(myData,"^",4)
    .....set tempMax=+$P(myData,"^",5)
    .....i (Result>=tempMin)&&(Result<tempMax) s TSInfo=$P(myData,"^",2)
    ....i TSInfo'="" s oneResult=TSInfo
    ....e  s oneResult=ODDesc_oneResult
    ....
    ....i ODDesc["-检查结果" d
    .....s oneResult=$p(Result,LoopStr,iLoop)
    .....s oneResult=##class(web.DHCPE.ReportGetInfor).Replace(oneResult,"1、","")
    .....s oneResult=##class(web.DHCPE.ReportGetInfor).Replace(oneResult,"2、","")
    .....s oneResult=##class(web.DHCPE.ReportGetInfor).Replace(oneResult,"3、","")
    .....s oneResult=##class(web.DHCPE.ReportGetInfor).Replace(oneResult,"4、","")
    .....s oneResult=##class(web.DHCPE.ReportGetInfor).Replace(oneResult,"5、","")
    .....s oneResult=##class(web.DHCPE.ReportGetInfor).Replace(oneResult,"6、","")
    .....s oneResult=##class(web.DHCPE.ReportGetInfor).Replace(oneResult,"。","")
    ....
    ...s DisplayDesc=oneResult
    ...s EDRowId=..GetEDByDesc(DisplayDesc,+ItemID)
    ...i EDRowId="" s EDRowId=##class(web.DHCPE.ResultNew).GetDefaultEDByStation(+ItemID,STLocId)
    
    ...;i EDRowId="" d  //找不到建议，插入1条默认
    ....;s DefaultCode=##class(web.DHCPE.DHCPEExpertDiagnosis).GetMaxCode()
    ....;s DefaultInstring=DefaultCode_"^"_"默认"_"^"_"默认"_"^N^N^"_UserId_"^^"_"MR"_"^"_+ItemID_"^Y^^^N^^"
    
    ....;s DefaultInfo=##class(web.DHCPE.DHCPEExpertDiagnosis).InsertED(DefaultInstring)
    ....;s EDRowId=$p(DefaultInfo,"^",2)
    
    ...
    ...q:EDRowId=""
    
    
    ...s Advice=$p($g(^DHCPEED(EDRowId,"Detail")),"^",1)
    ...
    ...s Advice=##class(web.DHCPE.DHCPEExpertDiagnosis).GetKeyReplaceStr(EpisodeID,EDRowId)
    ...s EDID=0  //找到结论对应的建议
    ...f  s EDID=$O(^DHCPEED(0,"Conclusion",DisplayDesc,EDID)) q:EDID=""  d
    ....s LocShowDFlag=##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(EDID,ADMLocID)
    ....q:LocShowDFlag'="Y"
    ....;s activeFlag=$G(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDID))
    ....s activeFlag=$p($g(^DHCPEED(EDID,"1")),"^",13)  //激活
    ....q:activeFlag'="Y"
    ....;q:LocID=""
    ....;q:'$D(^DHCPEED(0,"EDLOC",LocID,EDID))
    ....s CurStation=$P($g(^DHCPEED(EDID,1)),"^",7)
    ....q:CurStation'=+ItemID
    ....s Advice=$P($g(^DHCPEED(EDID,"Detail")),"^",1)
    ...i Advice="默认" s Advice=""
    ...s Sort=$G(^TempDHCPE("Sort",Job,OEORD))
    ...i Sort="" s Sort=1
    ...q:oneResult["未见明显异常"  
    ...q:oneResult["未见异常"
    ...q:oneResult["窦性心率"
    ...s STDR=+ItemID
    ...s STLocDR=$p($g(^DHCPEED(EDRowId,"1")),"^",10)
    ...&sql(insert into DHC_PE_GSDiagnosis(GSD_ParRef,GSD_ED_DR,
           GSD_UpdateUser_DR,GSD_UpdateDate,GSD_UpdateTime,GSD_GenType,GSD_Advice,GSD_Sort,GSD_Status,GSD_ST_DR,GSD_STloc_DR)
           values(:GSRowId,:EDRowId,:UserId,:UpdateDate,:UpdateTime,'S',:Advice,:Sort,'0',:STDR,:STLocDR))
    ...i SQLCODE=0 d
    ....s GSDRowId=%ROWID
    ....s DisplayDesc="["_DisplayDesc_"]"
    ....s ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId)=DisplayDesc
    ....d UpdateGSEDC
    
    }
    
    k ^DHCPEGenED("GetSummarize",EpisodeID)
    k ^DHCPEGenED("GetSummarizeBBED",EpisodeID)
    k ^DHCPEGenED("HadED",EpisodeID)
    q SQLCODE

GetAllSummarize
    s:'$D(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID)) Flag=0,AllFlag=0
    If ItemType="N" Do CheckNumResult
    If ItemType="C" Do CheckNumResult
    If ItemType="T" Do CheckTextResult
    If ItemType="S" Do CheckTextResult
    q
    
CheckNumResult
    s Min=+$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",4)
    s Max=+$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",5)
    s rltID=0
    f  s rltID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID,rltID)) q:rltID=""  d
    .s Flag=1
    .s PDFlag=1
    .s rltValue=$P($g(^DHCPERLT(rltID)),"^",4)
    .s:+rltValue<Min Flag=0,AllFlag=0
    .s:+rltValue>Max Flag=0,AllFlag=0
    .q:Flag=0
    .s EDID=$P(^DHCPERLT(rltID),"^",9)
    .i conditionFlag'="1" d
    ..s Sort=$G(^TempDHCPE("Sort",Job,EDID))
    ..i Sort="" s Sort=1
    ..s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"Sort")=Sort
    ..s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)=1
    ..s ^DHCPEDataEx("AutoSummarizeRecomm",EpisodeID,rltID)="Y"

    
    q
CheckTextResult
    s standardText=$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",2)
    s StrFlag=0
    s rltID=0
    f  s rltID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID,rltID)) q:rltID=""  d
    .s Flag=1
    .s PDFlag=1
    .s rltValue=$P($g(^DHCPERLT(rltID)),"^",4) 
    .// 对于选择类型： 如果一个细项对应多个选择项结果，则没有与诊断关联的选择项，不标记
    .//s:(rltValue'=standardText)&&(risFlag=0) Flag=0 ,^DHCPEDataEx("AutoSummarizeRecomm","NoRelate",EpisodeID,rltID)=1 //,AllFlag=0  
    .//s:(rltValue'[standardText)&&(risFlag=1) Flag=0 ,^DHCPEDataEx("AutoSummarizeRecomm","NoRelate",EpisodeID,rltID)=1 //,AllFlag=0
    .s:(rltValue'=standardText)&&(ItemType="S") Flag=0 ,^DHCPEDataEx("AutoSummarizeRecomm","NoRelate",EpisodeID,rltID)=1 //,AllFlag=0  
    .s:(rltValue'[standardText)&&(ItemType="T") Flag=0 ,^DHCPEDataEx("AutoSummarizeRecomm","NoRelate",EpisodeID,rltID)=1 //,AllFlag=0
    
    .q:Flag=0
    .s StrFlag=1
    .s EDID=$P(^DHCPERLT(rltID),"^",9)
    .i conditionFlag'="1" d
    ..s Sort=$G(^TempDHCPE("Sort",Job,EDID))
    ..i Sort="" s Sort=1
    ..s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"Sort")=Sort
    ..s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)=1
    ..s ^DHCPEDataEx("AutoSummarizeRecomm",EpisodeID,rltID)="Y"
    s:StrFlag=0 AllFlag=0
    q
GetAllExpressSummarize
    q:'$D(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID))
    If ItemType="N" Do CheckExpressNumResult
    If ItemType="C" Do CheckExpressNumResult
    If ItemType="T" Do CheckExpressTextResult
    If ItemType="S" Do CheckExpressTextResult
    q
    
CheckExpressNumResult
    s Min=+$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",4)
    s Max=+$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",5)
    s rltID=0
    f  s rltID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID,rltID)) q:rltID=""  d
    .s Flag=1
    .s PDFlag=1
    .s EDID=$P(^DHCPERLT(rltID),"^",9)
    .s rltValue=$P($g(^DHCPERLT(rltID)),"^",4)
    .s:+rltValue<Min Flag=0
    .s:+rltValue>Max Flag=0
    .q:Flag=0
    .s OneFlag=1  ;满足
    q
CheckExpressTextResult
    s standardText=$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",2)
    s rltID=0
    f  s rltID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID,rltID)) q:rltID=""  d
    .s Flag=1
    .s PDFlag=1
    .s rltValue=$P($g(^DHCPERLT(rltID)),"^",4)
    .s EDID=$P(^DHCPERLT(rltID),"^",9) 
    .// 对于选择类型： 如果一个细项对应多个选择项结果，则没有与诊断关联的选择项，不标记
    .s:(rltValue'=standardText)&&(ItemType="S") Flag=0  
    .s:(rltValue'[standardText)&&(ItemType="T") Flag=0
    .q:Flag=0
    .s OneFlag=1  ;满足
    
    q
UpdateGSEDC
    s DelEDCRowId=$g(^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",GSDRowId))
    q:DelEDCRowId'=""
    s EDCRelate=$o(^DHCPEEDCR(0,"EDDR",EDRowId,0))
    q:EDCRelate=""
    s EDCRowID=$P($g(^DHCPEEDCR(EDCRelate)),"^",2)
    q:EDCRowID=""
    Set ^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",GSDRowId)=EDCRowID
    Set ^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",0,"EDCDR",+GSDRowId,EDCRowID,GSDRowId)=""

    q
}

/// Creator: sunxintao
/// CreateDate: 2021-02-19
/// Descript: 根据就诊 诊断站点 和满足条件的站点取当前诊断的归属站点
/// INPUT:PAADM：就诊号 STID：诊断的站点 ConditionSTIDS：自动跳出的诊断的诊断满足条件的站点
/// DEBUG:w ##Class(web.DHCPE.ResultEdit).GetEDStation(10055178,13)
ClassMethod GetEDStation(PAADM, STID, ConditionSTIDS As %String = "")
{
    s OEOrder=$o(^OEORD(0,"Adm",PAADM,0))
    i PAADM'="" s LocID=$p($g(^PAADM(PAADM)),"^",4)
    s Sub=0
    s OEITemQFlag=0,CurST=""
    f  s Sub=$o(^OEORD(OEOrder,"I",Sub)) q:(Sub="")||(OEITemQFlag=1)  d
    .q:($g(^OEORD(OEOrder,"I",Sub,1))="")
    .s OEItemStatus=$p(^OEORD(OEOrder,"I",Sub,1),"^",13)
    .q:(OEItemStatus=4)
    .s ArcItmDR=$p(^OEORD(OEOrder,"I",Sub,1),"^",2)
    .;s CurSTTMP=$o(^DHCPEST(0,"STORD_ARCIM",ArcItmDR,0))
    .s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcItmDR,LocID)
    .s CurSTTMP=$p(StatOrderDR,"||",1) 
    .q:(CurSTTMP="")
    .q:(ConditionSTIDS'[("^"_CurSTTMP_"^")) /// 不是满足条件的站点先退出
    .s CurST=CurSTTMP
    .s:(CurST=STID) OEITemQFlag=1
    q:(CurST'="") CurST
    
    s Sub=0
    s OEITemQFlag=0,CurST=""
    f  s Sub=$o(^OEORD(OEOrder,"I",Sub)) q:(Sub="")||(OEITemQFlag=1)  d
    .q:($g(^OEORD(OEOrder,"I",Sub,1))="")
    .s OEItemStatus=$p(^OEORD(OEOrder,"I",Sub,1),"^",13)
    .q:(OEItemStatus=4)
    .s ArcItmDR=$p(^OEORD(OEOrder,"I",Sub,1),"^",2)
    .s CurSTTMP=$o(^DHCPEST(0,"STORD_ARCIM",ArcItmDR,0))
    .q:(CurSTTMP="")
    .s CurST=CurSTTMP
    .s:(CurST=STID) OEITemQFlag=1
    q CurST
}

/*
ClassMethod GetUseItemID(PAADM, ItemID, EDID)
{
    //q:$D(^DHCPERLT(0,"PAADM_OD",PAADM,ItemID)) ItemID
    s STID=$P(^DHCPEED(EDID,1),"^",7)
    s LabStation=$G(^DHCPESetting("DHCPE","StationId_Lab"))
    s STLocID=$P(^DHCPEED(EDID,1),"^",10)
    s ret=""
    s ODDesc=$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2)),"^",1)
    s ODDesc=$$ALPHAUP^SSUTIL4(ODDesc)
    s CSTID=""
    f  s CSTID=$O(^DHCPEST(0,"OD_Desc",ODDesc,CSTID)) q:(CSTID="")||(ret'="")  d
    .q:(STID'="")&&(CSTID'=STID)&&((STID=LabStation)||(ODDesc="既往史"))
    .s ODSub=0
    .f  s ODSub=$O(^DHCPEST(0,"OD_Desc",ODDesc,CSTID,ODSub)) q:(ODSub="")||(ret'="")  d
    ..s CurItemID=CSTID_"||"_ODSub
    ..s RltID=0
    ..f  s RltID=$O(^DHCPERLT(0,"PAADM_OD",PAADM,CurItemID,RltID)) q:(RltID="")||(ret'="")  d
    ...s ArcimID=$P(^DHCPERLT(RltID),"^",2)
    ...s CurLoc=$G(^DHCPEStationOrder("Loc",ArcimID))
    ...s CurLocID=$P(CurLoc,"^",1)
    ...q:(STLocID'="")&&(CurLocID'=STLocID)
    ...s CurSTID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
    ...q:(CurSTID'=STID)&&(STID'="")&&((STID=LabStation)||(ODDesc="既往史"))
    ...s ret=CurItemID
    q ret
}
*/
/// w ##class(web.DHCPE.ResultEdit).GetUseItemID("6390","^U000135","8896","Y")
ClassMethod GetUseItemID(PAADM, ItemID, EDID, NoBloodFlag As %String = "")
{
  
    s ExCode=$P(ItemID,"^",2)
    s ItemID=$P(ItemID,"^",1)
    q:(ItemID="")&&(ExCode="") ""
    i (ItemID="")&&(ExCode'=""){
        s RetItemID=""
        s ExCode=$ZCVT(ExCode,"U")
        s RelateSTID=""
        f  s RelateSTID=$O(^DHCPEST(0,"OD","KBXCode",ExCode,RelateSTID)) q:(RelateSTID="")||(RetItemID'="")  d
        .s RelateODSub=""
        .f  s RelateODSub=$O(^DHCPEST(0,"OD","KBXCode",ExCode,RelateSTID,RelateODSub)) q:(RelateODSub="")||(RetItemID'="")  d
        ..s tRetItemID=..GetUseItemID(PAADM, RelateSTID_"||"_RelateODSub, EDID, NoBloodFlag)
        ..s:tRetItemID'="" RetItemID=RetItemID_","_tRetItemID
        s:RetItemID'="" RetItemID=$e(RetItemID,2,*)
        q RetItemID
    }
    s STID=$P($g(^DHCPEED(EDID,1)),"^",7)
    
    s LocID=$P($g(^PAADM(PAADM)),"^",4)
    s LabStation=$G(^DHCPESetting("DHCPE","StationId_Lab",LocID))
   
    q:+ItemID'=LabStation ItemID
    s STLocID=$P($g(^DHCPEED(EDID,1)),"^",10)
    s ret=""
    s ODDesc=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",1)
    s ODDesc=$$ALPHAUP^SSUTIL4(ODDesc)
    s CSTID=""
    f  s CSTID=$O(^DHCPEST(0,"OD_Desc",ODDesc,CSTID)) q:(CSTID="")||(ret'="")  d
    .q:(STID'="")&&(CSTID'=STID)&&((STID=LabStation)||(ODDesc="既往史"))
    .s ODSub=0
    .f  s ODSub=$O(^DHCPEST(0,"OD_Desc",ODDesc,CSTID,ODSub)) q:(ODSub="")||(ret'="")  d
    ..s CurItemID=CSTID_"||"_ODSub
    ..s LocShowDFlag=##class(User.DHCPEOrderDetail).GetLocShowDataFlag(CurItemID,LocID)
    ..q:LocShowDFlag'="Y"  //细项（无效授权的退出）
    ..s RltID=0
    ..f  s RltID=$O(^DHCPERLT(0,"PAADM_OD",PAADM,CurItemID,RltID)) q:(RltID="")||(ret'="")  d
    ...s ArcimID=$P($g(^DHCPERLT(RltID)),"^",2)
    .../*获取站点分类ID（多院区） start*/
    ...s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcimID,LocID)
    ...s CurLoc=##class(web.DHCPE.CT.HISUICommon).GetStatCatIDBySTOrderID(StatOrderDR,LocID)
    .../*获取站点分类ID（多院区） end*/
    ...q:(STLocID'="")&&(CurLocID'=STLocID)
    ...s OEORIRowId=$P($g(^DHCPERLT(RltID)),"^",9)
    ...s SpecimenType=##class(web.DHCPE.BarPrint).GetSpecName(OEORIRowId)
    ...q:(SpecimenType'="")&&(SpecimenType'[("血"))&&(NoBloodFlag="N")
    ...q:(SpecimenType'="")&&(SpecimenType[("血"))&&(NoBloodFlag="Y")
    ...s CurSTID=+StatOrderDR //获取站点ID（多院区） 
    ...q:(CurSTID'=STID)&&(STID'="")&&((STID=LabStation)||(ODDesc="既往史"))
    ...s ret=CurItemID
    q ret
}

ClassMethod GetEDSort(EpisodeID, Job)
{
  
    
    s ADMLocID=$P($g(^PAADM(EpisodeID)),"^",4)
    s OEID=""
    f  s OEID=$O(^DHCPERLT(0,"ADMOD",EpisodeID,OEID)) q:OEID=""  d
    .s ArcIMID=$P($g(^OEORD(+OEID,"I",$P(OEID,"||",2),1)),"^",2)
    .//s StationID=$O(^DHCPEST(0,"STORD_ARCIM",ArcIMID,0))
    .s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcIMID,ADMLocID)
    .q:StatOrderID=""
    .s StationID=+StatOrderID //站点ID
    .q:StationID="" 
    .s StatSetID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_ADMLocID,StationID,""))
    .q:StatSetID="" 
    .;s STSequence=$p($g(^DHCPEST(StationID)),"^",4)
    .s STSequence=""
    .s STSequence=$lg($g(^CF.PE.StationSetD(StatSetID)),5) //站点顺序
    .s STSequence=100+STSequence
    .s ARCSequence=""
    .s ARCSequence=$g(^DHCPECTDataEx("DHCPEStationOrder","Sequence",ArcIMID)) //医嘱项顺序（停用）
    .s:ARCSequence'="" ARCSequence=100000000+ARCSequence
    .i ARCSequence="" s ARCSequence="999999999"
    .s Sort=$O(^TempDHCPE(EpisodeID,STSequence,ARCSequence,""),-1)
    .s Sort=+Sort+1
    .s ^TempDHCPE(EpisodeID,STSequence,ARCSequence,Sort)=OEID
    s i=0
    s STSequence=0
    f  s STSequence=$O(^TempDHCPE(EpisodeID,STSequence)) q:STSequence=""  d
    .s ARCSequence=0
    .f  s ARCSequence=$O(^TempDHCPE(EpisodeID,STSequence,ARCSequence)) q:ARCSequence=""  d
    ..s Sort=0
    ..f  s Sort=$O(^TempDHCPE(EpisodeID,STSequence,ARCSequence,Sort)) q:Sort=""  d
    ...s OEID=$G(^TempDHCPE(EpisodeID,STSequence,ARCSequence,Sort))
    ...s i=i+1
    ...s ^TempDHCPE("Sort",Job,OEID)=i
    k ^TempDHCPE(EpisodeID)
}

ClassMethod GeneralAudit(EpisodeID As %String) As %String
{
    Quit:$g(EpisodeID)="" 0
    
    s Flag=..ItemHadApp("",EpisodeID)
    q:Flag=0 1
    q:Flag=2 2
    
    Set UserId=%session.Get("LOGON.USERID")
    //Set UserId=10166
    Set IAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,""))
    //b
    Quit:IAdm="" 0
    s AduitDate=+$h
    s STRowId=0
    For  Set STRowId=$O(^DHCPESS(0,"IADM",IAdm,STRowId)) Quit:STRowId=""  Do
    .s SSRowId=0
    .F  s SSRowId=$O(^DHCPESS(0,"IADM",IAdm,STRowId,SSRowId)) Quit:SSRowId=""  Do
    ..&sql(update DHC_PE_StationSummarize set SS_Status='GA' where SS_RowId=:SSRowId)
    
    s GARowId=$o(^DHCPEGA(0,"IADM",IAdm,""))
    i GARowId'="" d
    .&sql(update DHC_PE_GeneralAdvice set GA_AduitUser_DR=:UserId,GA_AduitDate=:AduitDate where GA_IADM_DR=:IAdm)
    s RptRowId=$o(^DHCPERPT(0,"IADM",IAdm,""))
    i RptRowId'="" d
    .//&sql(update DHC_PE_Report set RPT_Status="A",RPT_AduitUser_DR=:UserId,RPT_AduitDate=:AduitDate where (RPT_IADM_DR=:IAdm)and(RPT_Status="NoAudit"))
    .&sql(update DHC_PE_Report set RPT_Status='A',RPT_AduitUser_DR=:UserId,RPT_AduitDate=:AduitDate where ((RPT_IADM_DR=:IAdm)and(RPT_Status='NA')))
    q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.ResultEdit","GetItemResult","2||8","3621638","3324579||7")
/// Created by MLH
Query GetItemResult(ItemID As %String, EpisodeID As %String, OEORIRowId As %String) As %Query(ROWSPEC = "TRowId:%String,TSelect:%String,TTextVal:%String,TNatureValue:%String,TShowTempBtn:%String,TTemplateDetail:%String")
{
}

ClassMethod GetItemResultExecute(ByRef qHandle As %Binary, ItemID As %String, EpisodeID As %String, OEORIRowId As %String) As %Status
{
    
    s ^lisatest("0331")=ItemID_"^"_EpisodeID_"^"_OEORIRowId
    Set repid=$I(^CacheTemp)
    s ind=1
    s ValueId=0
    k ^DHCPETemp("ItemResult",$j)
    For  Set ValueId=$O(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",ValueId)) Quit:ValueId=""  Do
    .s RowId=ItemID_"||"_ValueId
    .s StrData=^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",ValueId)
    .s Template=$p(StrData,"^",9)
    .i Template="" s Template="999999999"
    .s ^DHCPETemp("ItemResult",$j,Template,RowId)=StrData
    s Sort=""
    f  s Sort=$o(^DHCPETemp("ItemResult",$j,Sort)) q:Sort=""  d
    .s RowID=""
    .f  s RowID=$o(^DHCPETemp("ItemResult",$j,Sort,RowID)) q:RowID=""  d
    ..s StrData=$G(^DHCPETemp("ItemResult",$j,Sort,RowID))
    ..s TextVal=$p(StrData,"^",2)
    ..s NatureValue=$p(StrData,"^",6)
    ..i NatureValue="Y" d
    ...s NatureValue=1
    ..e  s NatureValue=0
    ..s RltRowId=0
    ..s Sele=0  //^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,Item)
    ..s TTemplateDetail=""
    ..f  s RltRowId=$o(^DHCPERLT(0,"ADM",EpisodeID,RltRowId)) q:(RltRowId="")!(Sele=1)  d
    ...i (($p(^DHCPERLT(RltRowId),"^",4)=TextVal)&($p(^DHCPERLT(RltRowId),"^",3)=ItemID)) d
    ....s Sele=1 
    ....s TTemplateDetail=$p(^DHCPERLT(RltRowId),"^",10)
    ..Set Temp=$o(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",RowId,0))
    ..i $g(Temp)="" d
    ...s TShowTempBtn=0
    ..e  s TShowTempBtn=1
    ..d ItemResultBuild
    k ^DHCPETemp("ItemResult",$j)
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
ItemResultBuild
    set Data=$lb( RowId, Sele, TextVal, NatureValue,TShowTempBtn,$g(TTemplateDetail))
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
    Quit $$$OK
}

ClassMethod GetItemResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemResultExecute ]
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

ClassMethod GetItemResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemResultExecute ]
{
    
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod UpdateItemResultList(ODRowId As %String, ResultStr As %String, EpisodeID As %String, OEORIRowId As %String) As %String
{
    Quit:$g(EpisodeID)="" 0
    q:$g(OEORIRowId)="" 0
    Quit:$g(ODRowId)="" 0
    Quit:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)) "已谢绝检查,不能录入结果" //谢绝检查
    Set UserId=%session.Get("LOGON.USERID")
    s UpdateDate=+$h
    s UpdateTime=$p($H,",",2)
    s ARCIMID=$p(^OEORD($p(OEORIRowId,"||",1),"I",$p(OEORIRowId,"||",2),1),"^",2)
    Quit:$g(ARCIMID)="" 0
    s Status=..IsArrivedStatu(EpisodeID)
    q:Status=0 "NoArrived"
    s SubmitStatus=..GetSubmitStatus(EpisodeID,ARCIMID)
    q:SubmitStatus=1 "科室已提交,不能修改"
    q:SubmitStatus=2 "总检已提交,不能修改"
    ;&sql(delete from DHC_PE_Result where (RLT_ADM_DR=:EpisodeID and RLT_OD_DR=:ODRowId and RLT_OEORI_DR=:OEORIRowId))
    s SQLCODE=0
    s RLTRowID=0
    f  s RLTRowID=$o(^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,ODRowId,RLTRowID))  Q:RLTRowID=""  D
    .&sql(delete from DHC_PE_Result where RLT_RowId=:RLTRowID)
    i ((SQLCODE=0)!(SQLCODE=100)) d
    .s RltCount=$L(ResultStr,"^")
    .For I=1:1:RltCount Do
    ..//s Result=$p(ResultStr,"^",I)
    ..s ResultT=$p(ResultStr,"^",I)
    ..s Result=$p(ResultT,$c(1),1)
    ..s TempDesc=$p(ResultT,$c(1),2)
    ..s Normal=$p(ResultT,$c(1),3)
    ..s ^lisatest("0428","kooododod",I)=Result_"@"_TempDesc_"@"_Normal
    ..d InsertResult
             
    Set IsExecuted=..OrderIsExec(EpisodeID,OEORIRowId)

    d ..ChangeOrdItemStatus(EpisodeID, OEORIRowId, IsExecuted)
    q 0
InsertResult // //,RLT_OEORI_DR
    &sql(insert into DHC_PE_Result(RLT_ADM_DR,RLT_ARCIM_DR,RLT_OD_DR,RLT_Result,RLT_User_DR,RLT_UpdateDate,RLT_UpdateTime,RLT_Normal,RLT_OEORI_DR,RLT_TemplateDesc)  
         values(:EpisodeID,:ARCIMID,:ODRowId,:Result,:UserId,:UpdateDate,:UpdateTime,:Normal,:OEORIRowId,:TempDesc))
    i SQLCODE=0  d
    .s RLTID=%ROWID
    .s SQLCODE=##class(web.DHCPE.HighRisk).GetHighRiskFlag(RLTID)    //add 
    q
}

Query GetItemCat(OEORIRowId As %String, EpisodeID As %String) As %Query(ROWSPEC = "ItemDesc:%String,ItemValue:%String,ItemID:%String,ItemCols:%String,ARCIM:%String,ItemCode:%String,RowID:%String,OEORIRowId:%String")
{
}

ClassMethod GetItemCatExecute(ByRef qHandle As %Binary, OEORIRowId As %String, EpisodeID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    q:$g(OEORIRowId)=""
    s ARCIMID=$p(^OEORD($P(OEORIRowId,"||",1),"I",$P(OEORIRowId,"||",2),1),"^",2)
    Set ind=0
    Quit:$g(ARCIMID)=""
    Set RowID=""
    //得到Cat
    For  Set RowID=$O(^DHCPEODR(0,"Cascade",ARCIMID,1,RowID)) Quit:(RowID="")  Do
    .Set Item=$P($g(^DHCPEODR(RowID)),"^",2)
    .Quit:Item=""
    .Set ItemDesc=$P($g(^DHCPEST(+Item,"OD",$P(Item,"||",2))),"^",1)
    .Set ItemCode=$P($g(^DHCPEST(+Item,"OD",$P(Item,"||",2))),"^",11)
    .If $D(^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,Item)) Do
    ..s RLTId=0
    ..s ItemData=""
    ..For  Set RLTId=$O(^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,Item,RLTId)) Q:RLTId=""  Do   //modified by MLH
    ...i ItemData="" d
    ....Set ItemData=$P(^DHCPERLT(RLTId),"^",4)
    ...e  d 
    ....Set ItemData=ItemData_";"_$P(^DHCPERLT(RLTId),"^",4)
    .Else  Set ItemData=""
    .Set ind=ind+1
    .Set ItemColName="ItemSelz"_ind
    .//Set Data=$LB(ItemDesc,ItemData,Item,ItemColName,ARCIMID,ItemUOM,NormalStr,ResultType,ComputeExp,ItemCode)
    .Set Data=$LB(ItemDesc,ItemData,Item,ItemColName,ARCIMID,ItemCode,RowID,OEORIRowId)
    .Set ^CacheTemp(repid,ind)=Data 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

ClassMethod GetItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemCatExecute ]
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

ClassMethod GetItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemCatExecute ]
{
    
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetTemplate(ODSID As %String) As %String
{
    Quit:$g(ODSID)="" 0
    &sql(select ODS_Template into :ODSTemplate from SQLUSER.DHC_PE_ODStandard where (ODS_RowId=:ODSID))
    q ODSTemplate
}

/// iAdm  个人ADM
/// Type "CRM":预约ID   "PAADM":His里面的ID   "":到达后ID
/// return  "1":已审核  "0":未审核
/// ##class(web.DHCPE.ResultEdit).GeneralAdviceAudited(PEAdm,"")
ClassMethod GeneralAdviceAudited(iAdm, Type)
{
    s flag=0
    q:iAdm="" flag
    i Type="PAADM" s iAdm=$o(^DHCPEIADM(0,"PAADM",iAdm,0))
    i Type="CRM" s iAdm=$o(^DHCPEIADM(0,"CRMADM",iAdm,0))
    q:iAdm="" flag
    s gAId=$o(^DHCPEGS(0,"IADM",iAdm,0))
    //s gAId=$o(^DHCPEGA(0,"IADM",iAdm,0))
    q:gAId="" flag
    s gAUserId=$p($g(^DHCPEGS(gAId,1)),"^",5)
    //s gAUserId=$p(^DHCPEGA(gAId,"1"),"^",4)
    q:gAUserId="" flag
    q 1
}

/// 根据PAADM、ChartID得到科室小结ID
ClassMethod GetSSId(EpisodeID, ChartID)
{
    Quit:$g(EpisodeID)="" ""
    //
    Set StationID=..GetPEStation($g(ChartID))   
    Quit:$g(StationID)="" ""    
    Set IAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,0))
    i IAdm'="" d
    .Set StationSummaryDr=$O(^DHCPESS(0,"IADM",IAdm,StationID,0))
    e  d
    .Set StationSummaryDr=$O(^DHCPESS(0,"PAADM",EpisodeID,StationID,0))
    q StationSummaryDr
}

/// Modified by MLH 20080318
/// d ##class(web.DHCPE.ResultEdit).AuditStationS("433356","54","Cancel")
ClassMethod AuditStationS(EpisodeID, ChartID, Type, UserID As %String = "")
{
    s ^wrz=EpisodeID_","_ChartID_","_Type_","_UserID
    k PLIST
    s LocID=$P($G(^PAADM(EpisodeID)),"^",4)
    s iAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,0))
    s StationID=..GetPEStation($g(ChartID))
    ;s AddItemStation="24"  //协和特殊写死的加项超声算到站点里面
    ;s CSStation="9"  //超声站点
    ;i StationID=AddItemStation s StationID=CSStation
    ;s SSID=$O(^DHCPESS(0,"IADM",iAdm,StationID,0))
    s SSID=..GetSSId(EpisodeID,ChartID)
    if Type'="Cancel"{
        s Flag=..ItemHadApp(StationID,EpisodeID)
        q:Flag=0 "NoItem"
        q:Flag=2 "NoApp"
    }
    i $g(SSID)=""
    {
        s SQLCODE=..UpdateStationS(EpisodeID,StationID,"")
        i SQLCODE'=0 q SQLCODE
    }
    s SSID=..GetSSId(EpisodeID,ChartID)
    Quit:$g(SSID)="" 0
    //s RisStation=$G(^DHCPESetting("DHCPE","StationId_Ris"))
    s RisStation=$G(^DHCPESetting("DHCPE","StationId_Ris",LocID))
    if Type'="Cancel"{
        s sub=$O(^DHCPESS(SSID,"Diagnosis",0))
        //q:(sub="")&&(("^"_RisStation_"^")'[("^"_StationID_"^")) "NoDiagnosis"
    }
    //s Flag=..GetStationResultFlag(SSID)
    //q:Flag=1 "NoHadResult"

    s SQLCODE=..UpdateSSResult(EpisodeID,StationID,"")
    i SQLCODE'=0 q SQLCODE

    s:UserID="" UserID=%session.Get("LOGON.USERID")
    
    s DocUserID=""
    s LocID=$P(^PAADM(EpisodeID),"^",4) ;就诊科室（开医嘱科室）
    if $d(^DHCPEOtherPatientToHPBase("ConRecLoc",LocID,StationID)) d
    .s DefaultDoc=$P($g(^DHCPEOtherPatientToHPBase("ConRecLoc",LocID,StationID)),"^",2)
    .s:DefaultDoc'="" DocUserID=DefaultDoc
    e  s DocUserID=UserID

    s PLIST(7)=UserID
    s PLIST(8)=+$H
    s PLIST(9)="SA"
    i Type="Cancel" s PLIST(9)="NA"
    s Status=$p($g(^DHCPESS(SSID,1)),"^",7)
    q:(Status'="NA")&&(Type="Submit") "HadAudit"
    q:(Status="NA")&&(Type="Cancel") "NoAudit"
    i Type="Cancel"
    {
        s OldUserID=$p($g(^DHCPESS(SSID,1)),"^",5)
        ;s LocID=%session.Get("LOGON.CTLOCID")
        s LocID=$P(^PAADM(EpisodeID),"^",4)
        s AutoAuditUser=$G(^DHCPESetting("DHCPE","AutoAuditUser",LocID))
        i OldUserID'=AutoAuditUser
        {
            ;i (OldUserID'=PLIST(7))&&(("^"_RisStation_"^")'[("^"_StationID_"^")) q "DocNotSame"
        }
        ;s gSSID=$o(^DHCPEGS(0,"IADM",iAdm,0))
        s gSSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(EpisodeID)
        i gSSID'=""
        {
            s User=$p($g(^DHCPEGS(gSSID,1)),"^",5)
            i User'="" q "GHadAudit"
        }
    }
    &SQL(update sqluser.DHC_PE_StationSummarize values :PLIST() where SS_RowId=:SSID)
    i (SQLCODE=0)&&(Type="Submit") d
    .d ##Class(web.DHCPE.RoomManager).UpdateOneRoomRecord(EpisodeID,"O")
    .d ##class(web.DHCPE.AdmRecordManager).Insert(EpisodeID,"A","AuditStationS",UserID,StationID)
    i (SQLCODE=0)&&(Type="Cancel") d
    .d ##class(web.DHCPE.AdmRecordManager).Insert(EpisodeID,"A","CaccelAuditStationS",UserID,StationID)
    .d ##class(web.DHCPE.OtherPatientToHP).StopConOrder(EpisodeID, StationID, DocUserID)
    q SQLCODE
}

/// Modified by MLH 20080318
/// d ##class(web.DHCPE.ResultEdit).UpdateStationS("433339","3","")
ClassMethod UpdateStationS(EpisodeID, StationID, Remark)
{
    s ^lisatest("20080311","UpdateStationS")=EpisodeID_"^"_StationID_"^"_Remark
    s iAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,0))
    s Flag=..ItemHadApp(StationID,EpisodeID)
    q:Flag=0 "NoItem"
    ;s SSID=$O(^DHCPESS(0,"IADM",iAdm,StationID,0))
    s SSID=..GetSSId(EpisodeID, StationID)
    s PLIST(2)=iAdm
    s PLIST(3)=StationID
    s User=%session.Get("LOGON.USERID")
    //s User="2873"
    s Date=+$H
    s Time=$p($H,",",2)
    s PLIST(6)=User
    s PLIST(5)=Date
    s PLIST(9)="NA"
    s PLIST(4)=Remark
    s PLIST(10)=EpisodeID
    TSTART
    i SSID=""
    {
        &SQL(insert into sqluser.DHC_PE_StationSummarize values :PLIST())
    }
    else
    {
        s Status=$p($g(^DHCPESS(SSID,1)),"^",7)
        q:Status'="NA" "HadAudit"
        &SQL(update sqluser.DHC_PE_StationSummarize values :PLIST() where SS_RowId=:SSID)
    }
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    TCOMMIT
    q SQLCODE
}

/// Type 是否重新汇总原来的已经统计过的  1是
/// Modified by MLH 20080311
/// d ##class(web.DHCPE.ResultEdit).UpdateSSResult("803785","4","")
ClassMethod UpdateSSResult(EpisodeID, StationID, Remark, Type As %String = "0")
{
    s ^lisatest("20080311","UpdateStationS")=EpisodeID_"^"_StationID_"^"_Remark
    s iAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,0))
    s Flag=..ItemHadApp(StationID,EpisodeID)
    q:Flag=0 "NoItem"
    ;s SSID=$O(^DHCPESS(0,"IADM",iAdm,StationID,0))
    s SSID=..GetSSId(EpisodeID,StationID)
    Quit:$g(SSID)="" 0
    s ODDR=0
    TSTART
    &SQL(delete from sqluser.DHC_PE_SSResult where SSR_ParRef=:SSID)
    i SQLCODE=100 s SQLCODE=0
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    i SQLCODE=100 s SQLCODE=0
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    For  Set ODDR=$o(^DHCPERLT(0,"PAADM_OD",EpisodeID,ODDR)) Quit:(ODDR="")||(SQLCODE'=0)  Do
    .Set RID=0
    .Quit:(StationID'="")&&(StationID'=+ODDR)
    .For  Set RID=$o(^DHCPERLT(0,"PAADM_OD",EpisodeID,ODDR,RID)) Quit:(RID="")||(SQLCODE'=0)  Do
    ..Set Normal=$p(^DHCPERLT(RID),"^",7)
    ..Quit:Normal="1"
    ..Set ODSummary=$p($g(^DHCPEST(+ODDR,"OD",$p(ODDR,"||",2))),"^",5)
    ..Quit:(ODSummary="N")  //不进入小结
    ..Set RLTResult=$p(^DHCPERLT(RID),"^",4)
    ..Set ODSChd=0
    ..Set ODSSum="Y"
    ..For  Set ODSChd=$o(^DHCPEST(+ODDR,"OD",$p(ODDR,"||",2),"ODS",ODSChd)) Quit:(ODSChd="")||(ODSSum="N")  Do
    ...Set ODSText=$p($g(^DHCPEST(+ODDR,"OD",$p(ODDR,"||",2),"ODS",ODSChd)),"^",2)
    ...Set ODSRowId=ODDR_"||"_ODSChd
    ...Quit:$g(ODSRowId)=""
    ...Set ODSSummary=$g(^DHCPECTDataEx("BaseData","ODStandard","ODS_Summary",ODSRowId))
    ...If (ODSText=RLTResult)&(ODSSummary="N") Set ODSSum="N"
    ..b //5
    ..Quit:(ODSSum="N")   //不进入小结
    ..Set HadSum=$o(^DHCPESS(0,"RLT",RID,0))
    ..b //8
    ..Quit:(HadSum'="")&&(Type'="1")
    ..&SQL(insert into sqluser.DHC_PE_SSResult (SSR_ParRef,SSR_RLT_DR,SSR_UpdateUser_DR,SSR_UpdateDate,SSR_UpdateTime) values (:SSID,:RID,:User,:Date,:Time))
    If SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    TCOMMIT
    q SQLCODE
}

ClassMethod GetSSRemark(PAADM, ChartID)
{
    s SSID=..GetSSId(PAADM,ChartID)
    q:SSID="" ""
    
    s Remark=$p($g(^DHCPESS(SSID,"S")),"^",1)
    q Remark
}

Query GetSSResult(EpisodeID As %String = "", ChartID As %String = "") As %Query(ROWSPEC = "SSRId:%String, RLID:%String, User:%String, ItemDesc:%String, Date:%String, Remark:%String,RIDDesc:%String,TemplateDesc:%String")
{
}

ClassMethod GetSSResultExecute(ByRef qHandle As %Binary, EpisodeID, ChartID) As %Status
{

    Set repid=$I(^CacheTemp)
    s ind=1
    s id="0"
    q:EpisodeID="" $$$OK
    q:ChartID="" $$$OK
    s LocID=$P($g(^PAADM(EpisodeID)),"^",4)
    //s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))

    Set myStr=..GetAgeSex(EpisodeID)
    Set myAge=$p(myStr,"^",1)
    Set mySex=$p(myStr,"^",2)
    s SSID=..GetSSId(EpisodeID,ChartID)
    s StationID=..GetPEStation($g(ChartID))
    s Sub=0
    i SSID'=""{
    f  s Sub=$o(^DHCPESS(SSID,"Result",Sub)) q:Sub=""  d
    .s SSRId=SSID_"||"_Sub
    .s RLID=$p(^DHCPESS(SSID,"Result",Sub),"^",1)
    .q:RLID=""
    .s RIDDesc=$p($g(^DHCPERLT(RLID)),"^",4)
    .s TempDesc=$p($g(^DHCPERLT(RLID)),"^",10)
    .s OrderDetailID=$p($g(^DHCPERLT(RLID)),"^",3)
    .q:OrderDetailID=""
    .s User=$p($g(^DHCPERLT(RLID)),"^",5)
    .s TNormalResult=##class(web.DHCPE.ResultEdit).GetNormal(OrderDetailID,mySex,myAge,StationID)
    .i OrderDetailID'="" d
    ..//.s LabDetailCode=$p(^DHCPEST(+OrderDetailID,"OD",$p(OrderDetailID,"||",2)),"^",10)
    ..i +OrderDetailID=LabStation d
    ...;s namespaceLab=$G(^DHCPESetting("NAMESPACE","LABDATA"))
    ...s namespaceLab=$G(^DHCPESetting("NAMESPACE","LABDATA",LocID))
    ...i User'="" s User=$p($g(^[namespaceLab]SSU("SSUSR",1,User)),"^",2)
    ..e  d
    ...i User'="" s User=$p($g(^SSU("SSUSR",User)),"^",2)
    .//..s RIDDesc=##class(web.DHCPE.TransResult).trans(LabDetailCode,RIDDesc) //$p(..,$C(1),2)
    .//..i $l(RIDDesc,$C(1))>1 d
    .//...s RIDDesc=$p(RIDDesc,$C(1),2)
    .
    .s ARCIM=$p($g(^DHCPERLT(RLID)),"^",3)
    .i ARCIM'="" d
    ..s ItemDesc=$p($g(^DHCPEST(+ARCIM,"OD",$p(ARCIM,"||",2))),"^",1)
    ..s ItemUOMDr=$P($g(^DHCPEST(+ARCIM,"OD",$P(ARCIM,"||",2))),"^",4)
    .e  d
    ..s ItemDesc=""
    ..s ItemUOMDr=""
    .s RIDDesc=RIDDesc_" "_ItemUOMDr
    .s Date=$p($g(^DHCPERLT(RLID)),"^",6)
    .i Date'="" s Date=$ZD(Date,3)
    .s Time=$p($g(^DHCPERLT(RLID)),"^",11)
    .i Time'="" s Time=$ZT(Time,3)
    .s Date=Date_" "_Time
    .s Remark=$p(^DHCPESS(SSID,"Result",Sub),"^",2)
    .d Build    
    }
    
 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
Build
   
    //          PGT_ParRef, PGT_RowId, PGT_ChildSub, PGT_ParRef_Name, PGT_Desc, PGT_Sex, PGT_UpperLimit, PGT_LowerLimit, PGT_Married, PGT_Married_Desc ,PGT_UpdateUser_DR, PGT_UpdateUser_DR_Name, PGT_UpdateDate
    set Data=$lb(SSRId, RLID, User, ItemDesc, Date, Remark,RIDDesc,TempDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod GetSSResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSSResultExecute ]
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

ClassMethod GetSSResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSSResultExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod UpdateStationSRemark(Strings)
{
    s j=$l(Strings,"^")
    s SQLCODE=0
    s SSID=+Strings
    s Status=$p($g(^DHCPESS(SSID,1)),"^",7)
    q:Status'="NA" "HadAudit"
    TSTART
    f i=1:1:j
    {
        s String=$p(Strings,"^",i)
        s ID=$p(String,"&&",1)
        s Remark=$p(String,"&&",2)
        
        &SQL(update sqluser.DHC_PE_SSResult set SSR_Remark=:Remark where SSR_RowId=:ID)
        q:SQLCODE
    }
    
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    
    TCOMMIT
    q SQLCODE
}

Query GetSSDiagnosis(EpisodeID As %String = "", ChartID As %String = "") As %Query(ROWSPEC = "SSRId:%String, RLID:%String, User:%String, ItemDesc:%String, Date:%String, Remark:%String,RIDDesc:%String,EDCDesc:%String,DisplayDesc:%String,TItemColName:%String,EDCDR:%String")
{
}

ClassMethod GetSSDiagnosisExecute(ByRef qHandle As %Binary, EpisodeID, ChartID) As %Status
{

    Set repid=$I(^CacheTemp)

    s ind=1
    s id="0"
    q:EpisodeID="" $$$OK
    q:ChartID="" $$$OK
    s SSID=..GetSSId(EpisodeID,ChartID)
 
    s Sub=0
    i SSID'=""{
    f  s Sub=$o(^DHCPESS(SSID,"Diagnosis",Sub)) q:Sub=""  d
    .s SSRId=SSID_"||"_Sub
    .s RLID=$p(^DHCPESS(SSID,"Diagnosis",Sub),"^",1)
    .q:RLID=""
    .s RIDDesc=$p(^DHCPESS(SSID,"Diagnosis",Sub),"^",7)
    .//$p($g(^DHCPEED(RLID,"Detail")),"^",1)
    .s ItemDesc=$p($g(^DHCPEED(RLID,"1")),"^",1)
    .s User=$p($g(^DHCPEED(RLID,1)),"^",4)
    .i User'="" s User=$p($g(^SSU("SSUSR",User)),"^",2)
    .s (Date)=""
    .s Remark=$p(^DHCPESS(SSID,"Diagnosis",Sub),"^",2)
    .s EDCDesc="",EDCDR="",ItemColName=""
    .Set EDCDR=$g(^DHCPEDataEx("DHCPESSDiagnosis","EDCDR",SSID_"||"_Sub))
    .If EDCDR'="" Set EDCDesc=$p($g(^DHCPEEDC(EDCDR)),"^",2)
    .s ItemColName="EDCDescz"_ind
    .s DisplayDesc=$g(^DHCPEDataEx("DHCPESSDiagnosis","DisplayDesc",SSRId))  //Add 20080728
    .d Build    
    }
    i ind=1 s ItemColName="EDCDescz1"  d Build
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
Build
   
    set Data=$lb(SSRId, RLID, User, ItemDesc, Date, Remark,RIDDesc,$G(EDCDesc),DisplayDesc,$G(ItemColName),$G(EDCDR))
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod GetSSDiagnosisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSSDiagnosisExecute ]
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

ClassMethod GetSSDiagnosisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSSDiagnosisExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// w ##class(web.DHCPE.ResultEdit).UpdateSSDiagnosis("","3476",0)
ClassMethod UpdateSSDiagnosis(SSID = "", SDID = "", isDel = "", ChartID = "", EpisodeID = "")
{
    s User=%session.Get("LOGON.USERID")
    s Date=+$H
    s Time=$P($H,",",2)
    
    If SSID="" Do
    .s StationID=..GetPEStation($g(ChartID))
    .s:StationID="" StationID=2
    .s ret=..UpdateStationS(EpisodeID, StationID, "")
    .s SSID=..GetSSId(EpisodeID,ChartID)
    q:SSID="" 0
    s Status=$p($g(^DHCPESS(SSID,1)),"^",7)
    q:Status'="NA" "HadAudit"
    i isDel=1
    {
        s EDID=$P(^DHCPESS(+SDID,"Diagnosis",$P(SDID,"||",2)),"^",1)
        &SQL(delete from sqluser.DHC_PE_SSDiagnosis where SSD_RowId=:SDID)
        i $D(^DHCPEED(EDID,"UseCount")) d
        .s Sort=$G(^DHCPEED(EDID,"UseCount"))-1
        .i Sort=0 d
        ..k ^DHCPEED(EDID,"UseCount")
        .e  d
        ..s ^DHCPEED(EDID,"UseCount")=Sort
        q SQLCODE
    }
    Set DisplayDesc=$p(^DHCPEED(SDID,1),"^",1)
    if DisplayDesc'="默认"
    {
        &SQL(select SSD_ED_DR from sqluser.DHC_PE_SSDiagnosis where SSD_ParRef=:SSID and SSD_ED_DR=:SDID)
    
        q:SQLCODE=0 "HadDiagnosis"
    }
    s Advice=$p(^DHCPEED(SDID,"Detail"),"^",1)
    ;s Advice=##class(web.DHCPE.DHCPEExpertDiagnosis).GetKeyReplaceStr(EpisodeID,SDID)
    ;s TableStr=" "_$ZCVT("User.DHCPEExpertDiagnosis","U")
    ;s FieldStr=" "_$ZCVT("EDDetail","U")
    ;s tansid=$o(^User.BDPTranslationI("TransIndex",TableStr,FieldStr," EN",Advice,0))
    ;i tansid'="" s Advice=$lg(^User.BDPTranslationD(tansid),6)
    s Advice=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEExpertDiagnosis",Advice,"EDDetail","cls")
    s Advice=##class(web.DHCPE.DHCPEExpertDiagnosis).ReplactApp(EpisodeID,Advice)
    &SQL(insert into sqluser.DHC_PE_SSDiagnosis (SSD_ParRef,SSD_ED_DR,SSD_UpdateUser_DR,SSD_UpdateDate,SSD_UpdateTime,SSD_Submit,SSD_Advice) values (:SSID,:SDID,:User,:Date,:Time,'N',:Advice))
    If 'SQLCODE Do
    .s Sort=$I(^DHCPEED(SDID,"UseCount"))
    .Set SSDRowId=%ROWID
    .;s TableStr=" "_$ZCVT("User.DHCPEExpertDiagnosis","U")
    .;s FieldStr=" "_$ZCVT("EDDiagnoseConclusion","U")
    .;s tansid=$o(^User.BDPTranslationI("TransIndex",TableStr,FieldStr," EN",DisplayDesc,0))
    .;i tansid'="" s DisplayDesc=$lg(^User.BDPTranslationD(tansid),6)
    .s DisplayDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEExpertDiagnosis",DisplayDesc,"EDDiagnoseConclusion","cls")
    .s DisplayDesc=##class(web.DHCPE.DHCPEExpertDiagnosis).ReplactApp(EpisodeID,DisplayDesc)
    .;s DisplayDesc="["_DisplayDesc_"]"
    .s LocID=$P($G(^PAADM(EpisodeID)),"^",4)
    .;i $g(^DHCPESetting("DHCPE","ShowEDDiagnosisSign"))="Y" s DisplayDesc="["_DisplayDesc_"]"
    .i $g(^DHCPESetting("DHCPE","ShowEDDiagnosisSign",LocID))="Y" s DisplayDesc="["_DisplayDesc_"]"

    .s ResultInfo=##class(web.DHCPE.ReportGetInfor).GetAdviceResult(SDID,EpisodeID)
    .s DisplayDesc=DisplayDesc_ResultInfo
    .Set ^DHCPEDataEx("DHCPESSDiagnosis","DisplayDesc",SSDRowId)=DisplayDesc
    .Set:DisplayDesc'="" ^DHCPEDataEx("DHCPESSDiagnosis","DisplayDesc",DisplayDesc,SSDRowId)=$H
    .Set EDCDR=..GetEDCDR(SDID)
    .If EDCDR'="" Do 
    ..Set ^DHCPEDataEx("DHCPESSDiagnosis","EDCDR",SSDRowId)=EDCDR
    ..Set ^DHCPEDataEx("DHCPESSDiagnosis","EDCDR",0,"EDCDR",SSID,EDCDR,SSDRowId)=""
    q SQLCODE_"^"_$G(DisplayDesc)
}

/// Add by MLH 2008-05-14 
ClassMethod GetEDCDR(EDDR)
{
    Quit:EDDR="" ""
    Set EDCRDR=$o(^DHCPEEDCR(0,"EDDR",EDDR,0))
    If $g(EDCRDR)'="" Set EDCDR=$P($G(^DHCPEEDCR(EDCRDR)),"^",2)
    q $g(EDCDR)
}

ClassMethod UpdateStationDRemark(Strings)
{
    s GroupID=%session.Get("LOGON.GROUPID")
    s LocID=%session.Get("LOGON.CTLOCID")
    s SuperFlag=0
    //s:$G(^DHCPESetting("DHCPE","SuperGroup"))=GroupID SuperFlag="1"
    s:$G(^DHCPESetting("DHCPE","SuperGroup",LocID))=GroupID SuperFlag="1"
    s j=$l(Strings,"^")
    s SSID=+Strings
    s Status=$p($g(^DHCPESS(SSID,1)),"^",7)
    q:(Status'="NA")&&(SuperFlag=0) "HadAudit"
    
    s SQLCODE=0
    TSTART
    f i=1:1:j
    {
        s String=$p(Strings,"^",i)
        s ID=$p(String,"&&",1)
        s Remark=$p(String,"&&",2)
        s Advice=$p(String,"&&",3)
        s OEItemID=$p(String,"&&",4)
        s DisplayDesc=$p(String,"&&",5)
        s EDCRowId=$p(String,"&&",6)  //Add 20110901
        
        &SQL(update sqluser.DHC_PE_SSDiagnosis set SSD_DiagnoseConclusion=:Remark where SSD_RowId=:ID) //,SSD_Advice=:Advice
        Set OldDisplay=$g(^DHCPEDataEx("DHCPESSDiagnosis","DisplayDesc",ID))   //Add 20080728
        If OldDisplay'="" Do
        .If '$D(^DHCPEDataEx("DHCPESSDiagnosis","DisplayDesc",OldDisplay,ID)) Kill ^DHCPEDataEx("DHCPESSDiagnosis","DisplayDesc",OldDisplay,ID)  //Add 20080728
        Set ^DHCPEDataEx("DHCPESSDiagnosis","DisplayDesc",ID)=DisplayDesc //Add 20080728
        If DisplayDesc'="" Set ^DHCPEDataEx("DHCPESSDiagnosis","DisplayDesc",DisplayDesc,ID)="" //Add 20080728
        q:SQLCODE
        s $p(^DHCPESS(+ID,"Diagnosis",$p(ID,"||",2)),"^",7)=Advice
        i OEItemID="" d
        .k ^DHCPEDataEx("SDiaginosis",ID)
        e  d
        .s ^DHCPEDataEx("SDiaginosis",ID)=OEItemID
        do UpdateSSEDC   //Add 20110901

        
    }
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    TCOMMIT
    q SQLCODE
UpdateSSEDC
 
    Set DelEDCRowId=$g(^DHCPEDataEx("DHCPESSDiagnosis","EDCDR",ID)) 
    If DelEDCRowId'="" Do
    .k ^DHCPEDataEx("DHCPESSDiagnosis","EDCDR",0,"EDCDR",+ID,DelEDCRowId,ID)
    If EDCRowId'="" Do
    .Set ^DHCPEDataEx("DHCPESSDiagnosis","EDCDR",ID)=EDCRowId
    .Set ^DHCPEDataEx("DHCPESSDiagnosis","EDCDR",0,"EDCDR",+ID,EDCRowId,ID)=""  
    Else  Do
    .If DelEDCRowId'="" Do
    ..k ^DHCPEDataEx("DHCPESSDiagnosis","EDCDR",ID)
    q
}

/// w ##class(web.DHCPE.ResultEdit).IsArrivedStatu(28992)
ClassMethod IsArrivedStatu(EpisodeID)
{
    s PEIAdmId=$o(^DHCPEIADM(0,"PAADM",EpisodeID,""))
    i PEIAdmId="" q 0
    s PreIADM=$p($G(^DHCPEIADM(PEIAdmId)),"^",4)
    s Status=$p($G(^DHCPEPreIADM(PreIADM)),"^",8)
    q:Status'="ARRIVED" 0
    q 1
}

ClassMethod GetLabArrow(NormalResult, ResultValue)
{
    s ArrowName="../images/dhcpe/NoArrow.gif"
    i ResultValue="" q ArrowName
    s Arrow=##class(web.DHCPE.TransResult).GetLabResultArrow(NormalResult, ResultValue)
    i Arrow="0" s ArrowName="../images/dhcpe/DownArrow.gif"
    i Arrow="2" s ArrowName="../images/dhcpe/UpArrow.gif"
    q ArrowName
}

ClassMethod GetODDisplay(OEORIRowId, ItemID)
{
    Set ^lisatest("1109","GetODDisplay")=OEORIRowId_"^"_ItemID
    Quit:((OEORIRowId="")||(ItemID=""))
    Set ARCIMRowId=$p(^OEORD($p(OEORIRowId,"||",1),"I",$P(OEORIRowId,"||",2),1),"^",2)
    B //3
    Set ARCIMDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ARCIMRowId)
    //b //4
    Set ItemDesc=$p(^DHCPEST($P(ItemID,"||",1),"OD",$P(ItemID,"||",2)),"^",1)
    Set DisplayInfo=ARCIMDesc_"("_ItemDesc_")"
    Quit DisplayInfo
}

ClassMethod RegNoDoItem(OEORIRowId As %String) As %String
{
    Quit:$g(OEORIRowId)="" ""
    s Reason=$p(OEORIRowId,"^",2)
    s OEORIRowId=$p(OEORIRowId,"^",1)
    
    Set UserId=%session.Get("LOGON.USERID")
    Set OrdItemStat=$p(^OEORD($P(OEORIRowId,"||",1),"I",$p(OEORIRowId,"||",2),1),"^",13)
    //q:OrdItemStat'="6" "项目还未执行,不允许执行此操作"
    s RLTID=$o(^DHCPERLT(0,"OEORI",OEORIRowId,0))
    //q:RLTID'="" "项目已有结果不允许执行此操作"
    i $D(^DHCPEDataEx("DHCPEPreIOrdItem","RegNoDo",OEORIRowId)) d
    .k ^DHCPEDataEx("DHCPEPreIOrdItem","RegNoDo",OEORIRowId)
    e  d
    .Set RefuseDate=+$h
    .Set RefuseTime=$p($h,",",2)
    .s ^DHCPEDataEx("DHCPEPreIOrdItem","RegNoDo",OEORIRowId)=1_"^"_UserId_"^"_RefuseDate_"^"_RefuseTime_"^"_Reason
    q 0
}

/// Creator：    xueying
/// CreatDate：  20220610
/// Description: 批量放弃检查操作
/// Input:       OEORIRowIds（医嘱串，多个医嘱之间使用^分割）,UserID:操作人ID
/// Return：     0
/// Dubug:w ##class(web.DHCPE.ResultEdit).BatchRefuseCheck("233||3^233||4") 
ClassMethod BatchRefuseCheck(OEORIRowIds, UserID)
{
    s Job=$J
    k ^TempDHCPEBatchRefuseCheck(Job)
    q:$g(OEORIRowIds)="" ""
    s Length=$L(OEORIRowIds,"^")
    
    f OEItemi=1:1:Length{
        s OEORIRowId=$P(OEORIRowIds,"^",OEItemi)
        s OEORIRowId=$P(OEORIRowId,";",1)
        
        s LabSpecNo=$p($g(^OEORD(+OEORIRowId,"I",$P(OEORIRowId,"||",2),3)),"^",20)
        i LabSpecNo'=""{
            continue:$d(^TempDHCPEBatchRefuseCheck(Job,LabSpecNo))
            s ^TempDHCPEBatchRefuseCheck(Job,LabSpecNo)=""
        }
        d ..RefuseCheck(OEORIRowId,"",UserID)
    }
    k ^TempDHCPEBatchRefuseCheck(Job)
    q 0
}

/// Description: 谢绝检查/撤销谢绝检查
/// Input:       OEORIRowId:医嘱ID^谢绝原因, Type:类型（"RegNoDo",默认医嘱）,UserID:操作人ID
/// Debug: w ##class(web.DHCPE.ResultEdit).RefuseCheck("1150||1^","","18853")
ClassMethod RefuseCheck(OEORIRowId As %String, Type As %String = "", UserId As %String = "") As %String
{
    s ^tempdhcpe("RefuseCheck")=$lb(OEORIRowId,Type,UserId)
    q:$g(OEORIRowId)="" ""
    i Type="RegNoDo" q ..RegNoDoItem(OEORIRowId)
    s Reason=$p(OEORIRowId,"^",2) //谢绝原因
    s OEORIRowId=$p(OEORIRowId,"^",1)   //医嘱ID
 
    s PAADM=$P($g(^OEORD(+OEORIRowId)),"^",1)
    s LocID=$P($g(^PAADM(PAADM)),"^",4)
    
    s ARCIM=$P($g(^OEORD($P(OEORIRowId,"||",1),"I",$p(OEORIRowId,"||",2),1)),"^",2)
    q:ARCIM="" "-1^医嘱项为空"
    s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIM,LocID)
    s STID=$p(StatOrderDR,"||",1)            //站点ID
    q:STID="" "-1^站点为空"
  
    S OrdItemStat=$p($g(^OEORD($P(OEORIRowId,"||",1),"I",$p(OEORIRowId,"||",2)),1),"^",13)
    q:(OrdItemStat=6)&&('$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId))) "-1^已执行项目不能再进行操作"
   
    s RefuseDate=+$h  //谢绝日期
    s RefuseTime=$p($h,",",2)  //谢绝时间
    
    s rtn=0
    s GAAuditedFlag=##class(web.DHCPE.ResultEdit).GeneralAdviceAudited(PAADM,"PAADM")
    
    i $D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)) d  //撤销谢绝检查
    .k ^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)
    .d ##class(web.DHCPE.AdmRecordManager).Insert(PAADM,"A","CRefuseCheck",UserId,OEORIRowId)  //撤销谢绝检查操作日志
    .//判断科室是否提交，如果已提交，撤销谢绝检查时取消科室提交
    .s AuditInfo=##class(web.DHCPE.ResultNew).GetAuditInfo(PAADM,STID)
    .S StationAuditFlag=$p(AuditInfo,"^",3)
    .i (StationAuditFlag="1") d
    ..d ##class(web.DHCPE.ResultEdit).AuditStationS(PAADM,STID,"Cancel",UserId)
    .i GAAuditedFlag=1 d
    ..s rtn="-3^总检已初审,不能撤销谢绝检查!"
    e  d   //谢绝检查
    .s ^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)=1_"^"_UserId_"^"_RefuseDate_"^"_RefuseTime_"^"_Reason  //1-谢绝检查
    .d ##class(web.DHCPE.AdmRecordManager).Insert(PAADM,"A","RefuseCheck",UserId,OEORIRowId)   //谢绝检查操作日志
    .d ##class(web.DHCPE.OrderPostPoned).CancelDelay(OEORIRowId)
    .d ##class(web.DHCPE.ResultNew).AutoAudit(OEORIRowId)  //科室自动提交
    .i GAAuditedFlag=1 d
    ..s rtn="-4^总检已初审,不能谢绝检查!"
    q rtn
}

Query ODSTemplate(ODSRowId As %Library.String = "") As %Query(ROWSPEC = "TTemplateDesc:%String")
{
}

ClassMethod ODSTemplateExecute(ByRef qHandle As %Binary, ODSRowId As %Library.String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    Quit:(""=ODSRowId) $$$OK

    Set ret=""
    Set iLLoop=1
    Set TemplateSub=0
    For  Set TemplateSub=$O(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",ODSRowId,TemplateSub)) Q:(""=TemplateSub)  d
    .s TemplateDesc=^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",ODSRowId,TemplateSub)
    .d OutOItemStatusForAdm
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutOItemStatusForAdm
    set Data=$lb(TemplateDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod ODSTemplateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ODSTemplateExecute ]
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

ClassMethod ODSTemplateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ODSTemplateExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 取出尚未执行的医嘱json串
/// d ##class(web.DHCPE.ResultEdit).GetUnAppedItemsHisui("","")
ClassMethod GetUnAppedItemsHisui(StationID As %String, EpisodeID As %String, LabRecFlag As %String = "0", OEFlag As %String = "0")
{
    
    q:EpisodeID="" "[]"
    s ret=""
    s unAppItems=""
    s unAppItemIDs=""
    s Flag=0
    s OEOrder=0
    s LocID=$P($g(^PAADM(EpisodeID)),"^",4)
  
    s MedStation=$g(^DHCPESetting("DHCPE","StationId_Medical",LocID))
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))
    s RisStations=$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))
    s OtherStation= $g(^DHCPESetting("DHCPE","StationId_Other",LocID))

    s PEIAdmId=$o(^DHCPEIADM(0,"PAADM",EpisodeID,""))
    s Stations=""
    f  s OEOrder=$O(^OEORD(0,"Adm",EpisodeID,OEOrder))  q:(OEOrder="")||((Flag=2)&&(StationID'=""))  d
    .s OEOrdItem=0
    .f  s OEOrdItem=$O(^OEORD(OEOrder,"I",OEOrdItem))  q:(OEOrdItem="")||((Flag=2)&&(StationID'=""))  d
    ..s ORIStat=$p($G(^OEORD(OEOrder,"I",OEOrdItem,1)),"^",13)
    ..q:(ORIStat="4")||(ORIStat="6")
    ..s OEORIRowId=OEOrder_"||"_OEOrdItem
    ..q:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)) //谢绝检查
    ..q:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RegNoDo",OEORIRowId))
    ..s CRMOId=$o(^DHCPECRMO(0,"OEORI",OEORIRowId,0))  
    ..q:CRMOId=""
    ..s CRMOrI=$p($g(^DHCPECRMO(CRMOId)),"^",2)
    ..q:CRMOrI=""
    ..s ItemMastId=$p($G(^DHCPEPreIADM($p(CRMOrI,"||",1),"ORDITEM",$p(CRMOrI,"||",2))),"^",1)
    ..q:ItemMastId=""
    ..s Flag=1
    ..s StOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItemMastId,LocID)
    ..q:StOrderDR=""
    ..s Station=$p(StOrderDR,"||",1)
    ..q:(OtherStation=Station)||(MedStation=Station) //过滤掉其他站点、药品站点
    ..s AutoFlag="N"
    ..s StOrderSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StOrderDR,0)) 
    ..i StOrderSetID'="" s AutoFlag=$lg($g(^CF.PE.StationOrderSetD(StOrderSetID)),7)
    ..;q:AutoFlag="N" //站点项目组合扩展表——自动回传
    ..s OEORILabEpisodeNo=$p($G(^OEORD(OEOrder,"I",OEOrdItem,3)),"^",20)
    ..q:(LabRecFlag="1")&&(OEORILabEpisodeNo'="")&&($D(^DHCPETempLabEpisodeScan(OEORILabEpisodeNo)))
    ..d AddItem
    /*
    ..s Station=0
    ..f  s Station=$o(^DHCPEST(0,"STORD_ARCIM",ItemMastId,Station)) q:Station=""  d
    ...q:Station=MedStation
    ...q:(StationID'="")&&(StationID'=Station)
    ...q:OtherStation=Station
    ...s Sub=$o(^DHCPEST(0,"STORD_ARCIM",ItemMastId,Station,0))
    ...s AutoFlag=$p($G(^DHCPEST(Station,"O",Sub)),"^",6)
    ...q:AutoFlag="N"
    ...s OEORILabEpisodeNo=$p($G(^OEORD(OEOrder,"I",OEOrdItem,3)),"^",20)
    ...q:(LabRecFlag="1")&&(OEORILabEpisodeNo'="")&&($D(^DHCPETempLabEpisodeScan(OEORILabEpisodeNo)))
    ...d AddItem
    
    */
    
    i ret'="" s ret=ret
    q "["_ret_"]"
    
AddItem

    s:OEFlag=0 unAppItemIDs=ItemMastId
    s:OEFlag=1 unAppItemIDs=OEORIRowId
    s unAppItemSub=$p(ItemMastId,"||",1)    //ARCIM_Desc 医嘱名称 Arc_ItmMast
    s unAppItemVer=$p(ItemMastId,"||",2)
    s unAppItemDesc=$p($g(^ARCIM(unAppItemSub,unAppItemVer,1)),"^",2)
    s TreeObj=##class(web.DHCPE.HM.Entity.TreeRoot).%New()
    s TreeObj.id=$p(OEORIRowId,"||",1)_"-"_$p(OEORIRowId,"||",2)
    s TreeObj.text=unAppItemDesc
    s RetJson=##class(ext.util.JsonObject).ObjToJson(TreeObj)
    s:ret'="" ret=ret_","_RetJson
    s:ret="" ret=RetJson
    
    q
}

/// 取出尚未执行的医嘱
/// w ##class(web.DHCPE.ResultEdit).GetUnAppedItems("",6688003,1)
ClassMethod GetUnAppedItems(StationID As %String, EpisodeID As %String, LabRecFlag As %String = "0", OEFlag As %String = "0")
{
    
   q:EpisodeID="" ""
    
    s unAppItems=""
    s unAppItemIDs=""
    s Flag=0
    s OEOrder=0
    s LocID=$P($g(^PAADM(EpisodeID)),"^",4)
   
    s MedStation=$g(^DHCPESetting("DHCPE","StationId_Medical",LocID))
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))
    s RisStations=$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))
    s OtherStation= $g(^DHCPESetting("DHCPE","StationId_Other",LocID))

    s PEIAdmId=$o(^DHCPEIADM(0,"PAADM",EpisodeID,""))
    s Stations=""
    f  s OEOrder=$O(^OEORD(0,"Adm",EpisodeID,OEOrder))  q:(OEOrder="")||((Flag=2)&&(StationID'=""))  d
    .s OEOrdItem=0
    .f  s OEOrdItem=$O(^OEORD(OEOrder,"I",OEOrdItem))  q:(OEOrdItem="")||((Flag=2)&&(StationID'=""))  d
    ..s ORIStat=$p($G(^OEORD(OEOrder,"I",OEOrdItem,1)),"^",13)
    ..q:(ORIStat="4")||(ORIStat="6")
    ..s OEORIRowId=OEOrder_"||"_OEOrdItem
    ..q:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId))
    ..q:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RegNoDo",OEORIRowId))
    ..s CRMOId=$o(^DHCPECRMO(0,"OEORI",OEORIRowId,0))   
    ..q:CRMOId=""
    ..s CRMOrI=$p($g(^DHCPECRMO(CRMOId)),"^",2)
    ..q:CRMOrI=""
    ..s ItemMastId=$p($G(^DHCPEPreIADM($p(CRMOrI,"||",1),"ORDITEM",$p(CRMOrI,"||",2))),"^",1)
    ..q:ItemMastId=""
    ..s Flag=1
    ..s Station=0
    ..s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItemMastId,LocID) 
    ..q:StatOrderID=""
    ..s Station=$p(StatOrderID,"||",1)
    ..q:Station=""
    ..q:(StationID'="")&&(StationID'=Station)
    ..q:OtherStation=Station    //过滤其他站点
    ..q:MedStation=Station     //过滤药品站点
    ..s OEORILabEpisodeNo=$p($G(^OEORD(OEOrder,"I",OEOrdItem,3)),"^",20)
    ..q:(LabRecFlag="1")&&(OEORILabEpisodeNo'="")&&($D(^DHCPETempLabEpisodeScan(OEORILabEpisodeNo)))
    ..i (ORIStat'=6) d     //未执行
    ...d AddItem
    ..e  d
    ...i Station=LabStation d
    ....s ARCOS=$p($G(^OEORD(OEOrder,"I",OEOrdItem,3)),"^",10)
    ....s OEORIItmMastDR=$p($G(^OEORD(OEOrder,"I",OEOrdItem,1)),"^",2)
    ....s ResultStatus=##class(web.DHCPE.OEOrdItem).GetResultStatus(OEORILabEpisodeNo,OEORIItmMastDR,ARCOS,OEOrder_"||"_OEOrdItem)
    ....;i ((ResultStatus'="已发送")&&(ResultStatus'="已回传")&&((LabRecFlag="0")))||((LabRecFlag="1")&&((ResultStatus="未打印")||(ResultStatus="未采"))) d  //检验项目还未发送的当做还未执行的项目
    ....i (ResultStatus'="已发送")&&(ResultStatus'="已回传") d
    .....d AddItem
    ...e  i (("^"_RisStations_"^")[("^"_Station_"^")) d
    ....i (1=..RisHasReport(OEORIRowId))  d
    .....d AddItem
    
    /*
    ..f  s Station=$o(^DHCPEST(0,"STORD_ARCIM",ItemMastId,Station)) q:Station=""  d
    ...q:Station=MedStation
    ...q:(StationID'="")&&(StationID'=Station)
    ...q:OtherStation=Station
    ...s Sub=$o(^DHCPEST(0,"STORD_ARCIM",ItemMastId,Station,0))
    ...s AutoFlag=$p($G(^DHCPEST(Station,"O",Sub)),"^",6)
    ...q:AutoFlag="N"
    ...s OEORILabEpisodeNo=$p($G(^OEORD(OEOrder,"I",OEOrdItem,3)),"^",20)
    ...q:(LabRecFlag="1")&&(OEORILabEpisodeNo'="")&&($D(^DHCPETempLabEpisodeScan(OEORILabEpisodeNo)))
    ...i (ORIStat'=6) d     //未执行
    ....d AddItem
    ...e  d
    ....i Station=LabStation d
    .....s ARCOS=$p($G(^OEORD(OEOrder,"I",OEOrdItem,3)),"^",10)
    .....s OEORIItmMastDR=$p($G(^OEORD(OEOrder,"I",OEOrdItem,1)),"^",2)
    .....s ResultStatus=##class(web.DHCPE.OEOrdItem).GetResultStatus(OEORILabEpisodeNo,OEORIItmMastDR,ARCOS,OEOrder_"||"_OEOrdItem)
    .....;i ((ResultStatus'="已发送")&&(ResultStatus'="已回传")&&((LabRecFlag="0")))||((LabRecFlag="1")&&((ResultStatus="未打印")||(ResultStatus="未采"))) d  //检验项目还未发送的当做还未执行的项目
    .....i (ResultStatus'="已发送")&&(ResultStatus'="已回传") d
    ......d AddItem
    ....e  i (("^"_RisStations_"^")[("^"_Station_"^")) d
    .....i (1=..RisHasReport(OEORIRowId))  d
    ......d AddItem
    */
    if unAppItemIDs'="" q unAppItemIDs_"^"_unAppItems
    b ;unAppItems
    q ""
    
AddItem
    if unAppItemIDs'="" s unAppItemIDs=unAppItemIDs_","
    if unAppItems'="" s unAppItems=unAppItems_","   
    
    s:OEFlag=0 unAppItemIDs=unAppItemIDs_ItemMastId
    s:OEFlag=1 unAppItemIDs=unAppItemIDs_OEORIRowId
    s unAppItemSub=$p(ItemMastId,"||",1)    //ARCIM_Desc 医嘱名称 Arc_ItmMast
    s unAppItemVer=$p(ItemMastId,"||",2)
    s unAppItemDesc=$p($g(^ARCIM(unAppItemSub,unAppItemVer,1)),"^",2)
    s unAppItemDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",unAppItemDesc,"ARCIMDesc","cls") //翻译
    s unAppItems=unAppItems_unAppItemDesc
    q
}

ClassMethod RisHasReport(OEORIRowId)
{
    q:OEORIRowId="" 0
    s ARCIMDR=$P($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",2)
    q:(""=ARCIMDR) 0
    
    s EpisodeID=$P($g(^OEORD(+OEORIRowId)),"^",1)
    s LocID=$P($G(^PAADM(EpisodeID)),"^",4)
    
    s STRowId=0
    s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIMDR,LocID) 
    q:StatOrderID="" 0
    s STRowId=$p(StatOrderID,"||",1)
    q:(""=STRowId) 0
    
 
    //报告格式
    s StatOrdSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderID,""))
    q:StatOrdSetID="" 0
    s ReportFormat=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),5)
    i ReportFormat["EKG"
    {
        s rltId=$o(^DHCPERLT(0,"OEORI",OEORIRowId,0))
        q:rltId'="" 0
    }
    
    Set RARRowId=$o(^DHCPACRegInfoi("OEORI",OEORIRowId,0))
    i RARRowId=""
    {
        //如果手工录入结果，录入后也不显示
        s StatFlag=$p($G(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",13)
        i StatFlag=6 q 0
        q 1
    }
    
    //只要有结果就当作已经执行了
    s RLTID=$o(^DHCPERLT(0,"OEORI",OEORIRowId,0))
    q:RLTID'="" 0
    q 1
    
    s RisStudyNo=$p(^DHCPACRegInfo(RARRowId),"^",2)
    s DRPTRowId=##class(web.DHCPE.TransResult).GetMaxRisReportID(RisStudyNo)
    q:($g(DRPTRowId)="") 1
    s RisItemStatus=$P(^DHCRBStudy("Report",DRPTRowId),"^",4)
    i RisItemStatus'="" s RisItemStatus=$p($G(^DHCRBCStatus("ReportStatus",RisItemStatus)),"^",1)
    q:(RisItemStatus'="S") 1 //未发布
    //判断是否已经回传结果  
    s RLTID=$o(^DHCPERLT(0,"OEORI",OEORIRowId,0))
    q:(RisItemStatus="S")&(RLTID="") 0 //未回传
    
    q 0
}

/*
ClassMethod RisHasReport(OEORIRowId)
{
    q:OEORIRowId="" 0
    
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
        ////如果手工录入结果，录入后也不显示
        s StatFlag=$p($G(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",13)
        i StatFlag=6 q 0
        q 1
    }
    
    //只要有结果就当作已经执行了
    s RLTID=$o(^DHCPERLT(0,"OEORI",OEORIRowId,0))
    q:RLTID'="" 0
    q 1
    
    
    Set RisStudyNo=$p(^DHCPACRegInfo(RARRowId),"^",2)
    Set DRPTRowId=##class(web.DHCPE.TransResult).GetMaxRisReportID(RisStudyNo)
    Quit:($g(DRPTRowId)="") 1
    Set RisItemStatus=$P(^DHCRBStudy("Report",DRPTRowId),"^",4)
    i RisItemStatus'="" s RisItemStatus=$p($G(^DHCRBCStatus("ReportStatus",RisItemStatus)),"^",1)
    Quit:(RisItemStatus'="S") 1 //未发布
    //判断是否已经回传结果  
    s RLTID=$o(^DHCPERLT(0,"OEORI",OEORIRowId,0))
    q:(RisItemStatus="S")&(RLTID="") 0 //未回传
    
    Quit 0
}
*/
ClassMethod GetIcon(Arrow)
{
    i Arrow="1" q "dhcpe/NoArrow.gif"
    i Arrow="0" q "dhcpe/DownArrow.gif"
    i Arrow="2" q "dhcpe/UpArrow.gif"
    i Arrow="3" q "dhcpe/Star.gif"
    q ""
}

ClassMethod UpdateRisResult(EpisodeID, OEOrdItemID, Str, user)
{
    s SQLCODE=0
    s curUser=%session.Get("LOGON.USERID")
    
    i $p(user,"^",1)'="" d
    .i $p(user,"^",2)="" d
    ..s $p(user,"^",2)=$p(user,"^",1)
    e  d
    .i $p(user,"^",2)'="" d
    ..s $p(user,"^",1)=$p(user,"^",2)
    
    
    s date=+$h
    s time=$p($h,",",2)
    s PLIST(2)=EpisodeID
    s ARCIM=$p($g(^OEORD(+OEOrdItemID,"I",$p(OEOrdItemID,"||",2),1)),"^",2)
    ;s HandFlag=$G(^DHCPESetting("DHCPE","RisHand"))  //是否手工录入Ris等结果  Y 是   N 不是
    ;q:HandFlag="N"
    s PLIST(3)=ARCIM
    s ODDR=$o(^DHCPEODR(0,"ARCIM",ARCIM,0))
    i ODDR'="" d
    .s ODDR=$p(^DHCPEODR(ODDR),"^",2)
    s PLIST(4)=ODDR
    s PLIST(5)="" //Str
    s PLIST(6)=$P(user,"^",1)
    i PLIST(6)="" s PLIST(6)=curUser
    s ReportUserID=$P(user,"^",2)
    i ReportUserID="" s ReportUserID=curUser
    s PLIST(7)=date
    s Flag=0
    s ExamResult=..SplitRisResult(Str,3)
    ;i ExamResult["未见异常" s Flag=1
    s PLIST(8)=Flag
    s PLIST(11)=OEOrdItemID
    s PLIST(13)=time
    s RLTID=$o(^DHCPERLT(0,"OEORI",OEOrdItemID,0))
    i RLTID="" d
    .;q:Str="临床诊断:;检查所见:;诊断意见:"
    .&SQL(insert into sqluser.DHC_PE_Result values :PLIST() )
    .q:SQLCODE'=0
    .s RLTID=%ROWID
    .&SQL(update OE_ORDItem set OEORI_ItemStat_DR='6' where OEORI_RowID=:OEOrdItemID)
    .q:SQLCODE'=0
    .s $p(^DHCPERLT(RLTID),"^",4)=Str
    .s SQLCODE=##class(web.DHCPE.HighRisk).GetHighRiskFlag(RLTID)           //add
    .q:SQLCODE'=0                               //add
    .s ^DHCPEData("DHCPEResult","RIS","ReportUser",OEOrdItemID)=ReportUserID
    .// s ^DHCPEData("DHCPEResult","RIS","ReportUser",OEOrdItemID)=curUser
    .s ^DHCPEData("DHCPEResult","RIS","AuditUser",OEOrdItemID)=user
    e  d
    .s stat="6"
    .i Str="临床诊断:;检查所见:;诊断意见:" d
    ..s stat="1"
    ..s Str=""
    ..&SQL(delete from sqluser.DHC_PE_Result where RLT_RowId=:RLTID)
    ..k ^DHCPEData("DHCPEResult","RIS","ReportUser",OEOrdItemID)
    ..k ^DHCPEData("DHCPEResult","RIS","AuditUser",OEOrdItemID)
    .e  d
    ..&SQL(update sqluser.DHC_PE_Result values :PLIST() where RLT_RowId=:RLTID)
    ..s RLTID=%ROWID
    ..s $p(^DHCPERLT(RLTID),"^",4)=Str
    ..s ^DHCPEData("DHCPEResult","RIS","ReportUser",OEOrdItemID)=ReportUserID
    ..// s ^DHCPEData("DHCPEResult","RIS","ReportUser",OEOrdItemID)=curUser
    ..s SQLCODE=##class(web.DHCPE.HighRisk).GetHighRiskFlag(RLTID)      //add
    ..q:SQLCODE'=0                              //add
    ..s ^DHCPEData("DHCPEResult","RIS","AuditUser",OEOrdItemID)=user
    .&SQL(update OE_ORDItem set OEORI_ItemStat_DR=:stat where OEORI_RowID=:OEOrdItemID)
    .q:SQLCODE'=0
    q SQLCODE
}

/// d ##class(web.DHCPE.ResultEdit).GetRisResult("2975765||1",1)
/// d ##class(web.DHCPE.ResultEdit).GetRisResult("2975765||1",1)
ClassMethod GetRisResult(OEORIRowId, Type)
{
    s RLTID=$o(^DHCPERLT(0,"OEORI",OEORIRowId,0))
    q:RLTID="" ""
    s ResultStr=""
    s ClinicInfo=""
    s ExamDesc=""
    s ExamResult=""
    i Type>3{
        s User=$p(^DHCPERLT(RLTID),"^",5)
        i Type=5 q User
        i User'="" s User=$P($G(^SSU("SSUSR",User)),"^",2)
        i Type=4 q User
        s User=$G(^DHCPEData("DHCPEResult","RIS","ReportUser",OEORIRowId))
        //s User=$g(^DHCPEData("DHCPEResult","RIS","AuditUser",OEORIRowId))
        i Type=6 q User
        i User'="" s User=$P($G(^SSU("SSUSR",User)),"^",2)
        i Type=7 q User
    }
    i RLTID'="" d
    .s ResultStr=$p(^DHCPERLT(RLTID),"^",4)
    .s:ResultStr="" ResultStr=$g(^DHCPETempResult(OEORIRowId))
    .i ResultStr="" d
    ..s ResultStr=$g(^DHCPETempResult(OEORIRowId))
    ..s ResultStr=$tr(ResultStr,"_$c_","  ")
    q ..SplitRisResult(ResultStr,Type)
}

ClassMethod SplitRisResult(ResultStr, Type)
{
    s ExamResult=$p(ResultStr,";诊断意见:",2)
    s OtherStr=$p(ResultStr,";诊断意见:",1)
    s ExamDesc=$p(OtherStr,";检查所见:",2)
    s OtherStr=$p(OtherStr,";检查所见:",1)
    s ClinicInfo=$p(OtherStr,"临床诊断:",2)
    i Type=1 q ClinicInfo
    i Type=2 q ExamDesc
    i Type=3 q ExamResult
    q ""
}

ClassMethod GetTemp(TempStr)
{
    /*s TempStr=""
    s ARCIM=$p($g(^OEORD(+OEOrdItemID,"I",$p(OEOrdItemID,"||",2),1)),"^",2)
    s PLIST(3)=ARCIM
    s ODDR=$o(^DHCPEODR(0,"ARCIM",ARCIM,0))
    i ODDR'="" d
    .s ODDR=$p(^DHCPEODR(ODDR),"^",2)
    .s ODSSub=$o(^DHCPEST(+ODDR,"OD",$p(ODDR,"||",2),"ODS",0))
    .i ODSSub'="" d
    ..s ODSDR=ODDR_"||"_ODSSub
    ..s Sub=$o(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",ODSDR,0))
    ..q:Sub=""
    ..s TempStr=$G(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",ODSDR,Sub))
    */
    s ClinicInfo=..SplitRisResult(TempStr,1)
    s ExamDesc=..SplitRisResult(TempStr,2)
    s ExamResult=..SplitRisResult(TempStr,3)
    q ClinicInfo_"^"_ExamDesc_"^"_ExamResult
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.ResultEdit","ODSRisTemplate","","")

Query ODSRisTemplate(OEOrdItemID As %Library.String = "", TemplateAlias As %Library.String = "") As %Query(ROWSPEC = "临床诊断:%String,检查所见:%String,诊断意见:%String")
{
}

ClassMethod ODSRisTemplateExecute(ByRef qHandle As %Binary, OEOrdItemID As %Library.String = "", TemplateAlias As %Library.String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    Quit:(""=OEOrdItemID) $$$OK
    Set TemplateAlias=$$ALPHAUP^SSUTIL4(TemplateAlias)
    if TemplateAlias="" 
    {
    
    s ARCIM=$p($g(^OEORD(+OEOrdItemID,"I",$p(OEOrdItemID,"||",2),1)),"^",2)
    s ODDR=$o(^DHCPEODR(0,"ARCIM",ARCIM,0))
    i ODDR'="" d
    .Set ODDR=$p(^DHCPEODR(ODDR),"^",2)
    .Set ODSSub=0
    .For  Set ODSSub=$o(^DHCPEST(+ODDR,"OD",$p(ODDR,"||",2),"ODS",ODSSub))  q:ODSSub=""  d
    ..Set ODSRowId=ODDR_"||"_ODSSub
    ..Set ret=""
    ..Set iLLoop=1
    ..Set TemplateSub=0
    ..For  Set TemplateSub=$O(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",ODSRowId,TemplateSub)) Q:(""=TemplateSub)  d
    ...Set TemplateDesc=^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",ODSRowId,TemplateSub)
    ...Set ClinicInfo="",ExamDesc="",ExamResult=""
    ...Set Part1=$p(TemplateDesc,";检查所见:",1)
    ...Set ClinicInfo=$p(Part1,"临床诊断:",2)
    ...Set Part2=$p(TemplateDesc,";检查所见:",2)
    ...Set ExamDesc=$p(Part2,";诊断意见:",1)  //检查所见
    ...Set ExamResult=$p(Part2,";诊断意见:",2) //诊断意见
    ...do OutOItemStatusForAdm
    }
    else 
    { 
    
    s ARCIM=$p($g(^OEORD(+OEOrdItemID,"I",$p(OEOrdItemID,"||",2),1)),"^",2)
    s ODDR=$o(^DHCPEODR(0,"ARCIM",ARCIM,0))
    s ODSRowIdStr=""
    i ODDR'="" d
    .Set ODDR=$p(^DHCPEODR(ODDR),"^",2)
    .Set ODSSub=0
    .For  Set ODSSub=$o(^DHCPEST(+ODDR,"OD",$p(ODDR,"||",2),"ODS",ODSSub))  q:ODSSub=""  d
    ..Set ODSRowId=ODDR_"||"_ODSSub
    ..i ODSRowIdStr=""  s ODSRowIdStr=ODSRowId
    ..else  s ODSRowIdStr=ODSRowIdStr_"^"_ODSRowId
    Set TextDesc=$O(^DHCPEDataEx("DHCPEODStandard","TemplateAlias",TemplateAlias),-1)
    For  Set TextDesc=$o(^DHCPEDataEx("DHCPEODStandard","TemplateAlias",TextDesc))  q:(TextDesc="")||(TextDesc'[TemplateAlias)  d
    .Set RowId=""
    .For  Set RowId=$o(^DHCPEDataEx("DHCPEODStandard","TemplateAlias",TextDesc,RowId))  q:RowId=""  d
    ..q:(("^"_ODSRowIdStr_"^")'[("^"_RowId_"^"))
    ..Set TemplateSub=0
    ..For  Set TemplateSub=$O(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",RowId,TemplateSub)) Q:(""=TemplateSub)  d
    ...s TemplateDesc=^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",RowId,TemplateSub)
    ...Set ClinicInfo="",ExamDesc="",ExamResult=""
    ...Set Part1=$p(TemplateDesc,";检查所见:",1)
    ...Set ClinicInfo=$p(Part1,"临床诊断:",2)
    ...Set Part2=$p(TemplateDesc,";检查所见:",2)
    ...Set ExamDesc=$p(Part2,";诊断意见:",1)  //检查所见
    ...Set ExamResult=$p(Part2,";诊断意见:",2) //诊断意见
    ...d OutOItemStatusForAdm
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutOItemStatusForAdm
    set Data=$lb(ClinicInfo,ExamDesc,ExamResult)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod ODSRisTemplateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ODSRisTemplateExecute ]
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

ClassMethod ODSRisTemplateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ODSRisTemplateExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// add by rxb 20121210
Query ODSRisTemplateNew(OEORIRowId As %Library.String = "", TemplateAlias As %Library.String = "") As %Query(ROWSPEC = "TClinicInfo:%String,TExamDesc:%String,TExamResult:%String,TODSID:%String,TTemplateSub:%String")
{
}

ClassMethod ODSRisTemplateNewExecute(ByRef qHandle As %Binary, OEORIRowId As %Library.String = "", TemplateAlias As %Library.String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1 
    Set OEOrdItemID=OEORIRowId
    Quit:(""=OEOrdItemID) $$$OK
    Set TemplateAlias=$$ALPHAUP^SSUTIL4(TemplateAlias)
    
    if TemplateAlias="" 
    {
    
    s ARCIM=$p($g(^OEORD(+OEOrdItemID,"I",$p(OEOrdItemID,"||",2),1)),"^",2)
    s ODDR=$o(^DHCPEODR(0,"ARCIM",ARCIM,0))
    i ODDR'="" d
    .Set ODDR=$p(^DHCPEODR(ODDR),"^",2)
    .Set ODSSub=0
    .For  Set ODSSub=$o(^DHCPEST(+ODDR,"OD",$p(ODDR,"||",2),"ODS",ODSSub))  q:ODSSub=""  d
    ..Set ODSRowId=ODDR_"||"_ODSSub
    ..Set ret=""
    ..Set iLLoop=1
    ..Set TemplateSub=0
    ..For  Set TemplateSub=$O(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",ODSRowId,TemplateSub)) Q:(""=TemplateSub)  d
    ...Set TemplateDesc=^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",ODSRowId,TemplateSub)
    ...Set ClinicInfo="",ExamDesc="",ExamResult=""
    ...Set Part1=$p(TemplateDesc,";检查所见:",1)
    ...Set ClinicInfo=$p(Part1,"临床诊断:",2)
    ...Set Part2=$p(TemplateDesc,";检查所见:",2)
    ...Set ExamDesc=$p(Part2,";诊断意见:",1)  //检查所见
    ...Set ExamResult=$p(Part2,";诊断意见:",2) //诊断意见
    ...do OutOItemStatusForAdm
    }
    else 
    { 
    
    s ARCIM=$p($g(^OEORD(+OEOrdItemID,"I",$p(OEOrdItemID,"||",2),1)),"^",2)
    s ODDR=$o(^DHCPEODR(0,"ARCIM",ARCIM,0))
    s ODSRowIdStr=""
    i ODDR'="" d
    .Set ODDR=$p(^DHCPEODR(ODDR),"^",2)
    .Set ODSSub=0
    .For  Set ODSSub=$o(^DHCPEST(+ODDR,"OD",$p(ODDR,"||",2),"ODS",ODSSub))  q:ODSSub=""  d
    ..Set ODSRowId=ODDR_"||"_ODSSub
    ..i ODSRowIdStr=""  s ODSRowIdStr=ODSRowId
    ..else  s ODSRowIdStr=ODSRowIdStr_"^"_ODSRowId
    Set TextDesc=$O(^DHCPEDataEx("DHCPEODStandard","TemplateAlias",TemplateAlias),-1)
    For  Set TextDesc=$o(^DHCPEDataEx("DHCPEODStandard","TemplateAlias",TextDesc))  q:(TextDesc="")||(TextDesc'[TemplateAlias)  d
    .Set RowId=""
    .For  Set RowId=$o(^DHCPEDataEx("DHCPEODStandard","TemplateAlias",TextDesc,RowId))  q:RowId=""  d
    ..q:(("^"_ODSRowIdStr_"^")'[("^"_RowId_"^"))
    ..Set TemplateSub=0
    ..For  Set TemplateSub=$O(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",RowId,TemplateSub)) Q:(""=TemplateSub)  d
    ...s TemplateDesc=^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",RowId,TemplateSub)
    ...Set ClinicInfo="",ExamDesc="",ExamResult=""
    ...Set Part1=$p(TemplateDesc,";检查所见:",1)
    ...Set ClinicInfo=$p(Part1,"临床诊断:",2)
    ...Set Part2=$p(TemplateDesc,";检查所见:",2)
    ...Set ExamDesc=$p(Part2,";诊断意见:",1)  //检查所见
    ...Set ExamResult=$p(Part2,";诊断意见:",2) //诊断意见
    ...d OutOItemStatusForAdm
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutOItemStatusForAdm
    set Data=$lb(ClinicInfo,ExamDesc,ExamResult,ODSRowId,TemplateSub)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod ODSRisTemplateNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ODSRisTemplateNewExecute ]
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

ClassMethod ODSRisTemplateNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ODSRisTemplateNewExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetODSRisTemplate(OEOrdItemID As %Library.String = "") As %Query(ROWSPEC = "TExamResult:%String,TExamDesc:%String")
{
}

ClassMethod GetODSRisTemplateExecute(ByRef qHandle As %Binary, OEOrdItemID As %Library.String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    Quit:(""=OEOrdItemID) $$$OK
    s ARCIM=$p($g(^OEORD(+OEOrdItemID,"I",$p(OEOrdItemID,"||",2),1)),"^",2)
    s ODDR=$o(^DHCPEODR(0,"ARCIM",ARCIM,0))
    i ODDR'="" d
    .s ODDR=$p(^DHCPEODR(ODDR),"^",2)
    .s ODSSub=$o(^DHCPEST(+ODDR,"OD",$p(ODDR,"||",2),"ODS",0))
    .i ODSSub'="" d
    ..s ODSRowId=ODDR_"||"_ODSSub
    Quit:(""=$G(ODSRowId)) $$$OK
    Set ret=""
    Set iLLoop=1
    Set TemplateSub=0
    For  Set TemplateSub=$O(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",ODSRowId,TemplateSub)) Q:(""=TemplateSub)  d
    .s TemplateDesc=^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",ODSRowId,TemplateSub)
    .//S TExamResult=TemplateDesc
    .d OutOItemStatusForAdm
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutOItemStatusForAdm
    set Data=$lb(TemplateDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod GetODSRisTemplateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ODSRisTemplateExecute ]
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

ClassMethod GetODSRisTemplateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ODSRisTemplateExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetStationResultFlag(SSID)
{
    s Flag=0
    s ResultSub=$o(^DHCPESS(SSID,"Result",0))
    i ResultSub'="" d
    .s DiagnosisSub=$o(^DHCPESS(SSID,"Diagnosis",0))
    .i DiagnosisSub="" s Flag=1
    q Flag
}

/// d ##class(web.DHCPE.ResultEdit).IsLabChart("67")
ClassMethod IsLabChart(CharId)
{

    s Station=##class(web.DHCPE.ResultEdit).GetPEStation(CharId)
    s LocID=%session.Get("LOGON.CTLOCID")
    //s LabStation=$G(^DHCPESetting("DHCPE","StationId_Lab"))
    s LabStation=$G(^DHCPESetting("DHCPE","StationId_Lab",LocID))
    q:Station=LabStation 1
    q 0
}

/// author:wangfujian
/// creatDate:2009-03-10
/// description:取出所有谢绝检查的项目
/// input:EpisodeID
/// ouput:refuseItems
/// tables:
ClassMethod GetRefuseItems(EpisodeID As %String)
{
    s refuseItems=""
    s RegNoDoItems=""
    s OEOrder=0
    f  s OEOrder=$O(^OEORD(0,"Adm",EpisodeID,OEOrder))  q:(OEOrder="")  d
    .s OEOrdItem=0
    .f  s OEOrdItem=$O(^OEORD(OEOrder,"I",OEOrdItem))  q:(OEOrdItem="")  d
    ..i $d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEOrder_"||"_OEOrdItem)) d
    ...//如果该项目有谢绝检查，把项目的名称返回
    ...s Reason=$p($G(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEOrder_"||"_OEOrdItem)),"^",5)
    ...s ItemMastId=$p(^OEORD(OEOrder,"I",OEOrdItem,1),"^",2)
    ...s unAppItemSub=$p(ItemMastId,"||",1) //ARCIM_Desc 医嘱名称 Arc_ItmMast
    ...s unAppItemVer=$p(ItemMastId,"||",2)
    ...s unAppItemDesc=$p($g(^ARCIM(unAppItemSub,unAppItemVer,1)),"^",2)
    ...i Reason'="" s unAppItemDesc=unAppItemDesc_"("_Reason_")"
    ...i refuseItems="" d
    ....s refuseItems=unAppItemDesc
    ...e  d
    ....s refuseItems=refuseItems_","_unAppItemDesc
    ..i $d(^DHCPEDataEx("DHCPEPreIOrdItem","RegNo",OEOrder_"||"_OEOrdItem)) d
    ...//如果该项目有谢绝检查，把项目的名称返回
    ...s Reason=$p($G(^DHCPEDataEx("DHCPEPreIOrdItem","RegNo",OEOrder_"||"_OEOrdItem)),"^",5)
    ...s ItemMastId=$p(^OEORD(OEOrder,"I",OEOrdItem,1),"^",2)
    ...s unAppItemSub=$p(ItemMastId,"||",1) //ARCIM_Desc 医嘱名称 Arc_ItmMast
    ...s unAppItemVer=$p(ItemMastId,"||",2)
    ...s unAppItemDesc=$p($g(^ARCIM(unAppItemSub,unAppItemVer,1)),"^",2)
    ...i Reason'="" s unAppItemDesc=unAppItemDesc_"("_Reason_")"
    ...i RegNoDoItems="" d
    ....s RegNoDoItems="登记未做:"_unAppItemDesc
    ...e  d
    ....s RegNoDoItems=RegNoDoItems_","_unAppItemDesc
    
    i RegNoDoItems'="" s RegNoDoItems=";"_RegNoDoItems
    q refuseItems_RegNoDoItems
}

// d ##class(web.DHCPE.ResultEdit).GetItemResultStr("3||18^994^919||3")

/// 作者：汪福建
/// 创建时间：2009-02-17
/// 功能描述：查处结果并以一个字符窜到形式返回过去
ClassMethod GetItemResultStr(InStr As %String) As %String
{
   
 
    s ValueId=0
    s EpisodeID=$P(InStr,"^",2)
    s LocID=$P($G(^PAADM(EpisodeID)),"^",4)
    S ItemID=$P(InStr,"^",1)
    s Type=$p($G(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",2)
    //s RisStations=$g(^DHCPESetting("DHCPE","StationId_Ris"))          //add by zl 20101209
    s RisStations=$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))          //add by zl 20101209
    q:(("^"_RisStations_"^")'[(+ItemID))&&(Type'="S") ""
    
    Set myStr=..GetAgeSex(EpisodeID)
    Set myAge=$p(myStr,"^",1)
    Set mySex=$p(myStr,"^",2)
    s OEORIRowId=$P(InStr,"^",3)
    s data=""
    k ^DHCPETemp("ItemResult",$j)
    For  Set ValueId=$O(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",ValueId)) Quit:ValueId=""  Do
    .s RowId=ItemID_"||"_ValueId
    .s StrData=$G(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",ValueId))
    .s ODSSex=$p(StrData,"^",1)
    .q:(ODSSex'="N")&&(ODSSex'=mySex)
    .s Template=$p(StrData,"^",9)
    .i Template="" s Template="999999999"
    .s ^DHCPETemp("ItemResult",$j,Template,RowId)=StrData
    s Sort=""
    f  s Sort=$o(^DHCPETemp("ItemResult",$j,Sort)) q:Sort=""  d
    .s RowID=""
    .f  s RowID=$o(^DHCPETemp("ItemResult",$j,Sort,RowID)) q:RowID=""  d
    ..s StrData=$G(^DHCPETemp("ItemResult",$j,Sort,RowID))
    ..s HighRisk=$G(^DHCPEDataEx("DHCPEODStandard","HighRiskFlag",RowID))
    ..s TextVal=$p(StrData,"^",2)
    ..s NatureValue=$p(StrData,"^",6)
    ..i NatureValue="Y" d
    ...s NatureValue=1
    ..e  s NatureValue=0
    ..s RltRowId=0
    ..s Sele=0  //^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,Item)
    ..s TTemplateDetail=""
    ..f  s RltRowId=$o(^DHCPERLT(0,"ADM",EpisodeID,RltRowId)) q:(RltRowId="")!(Sele=1)  d
    ...//w !,$p(^DHCPERLT(RltRowId),"^",4)_"%%%"_TextVal
    ...i (($p(^DHCPERLT(RltRowId),"^",4)=TextVal)&($p(^DHCPERLT(RltRowId),"^",3)=ItemID)) d
    ....s Sele=1 
    ....s TTemplateDetail=$p(^DHCPERLT(RltRowId),"^",10)
    ..Set Temp=$o(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",RowID,0))
    ..i $g(Temp)="" d
    ...s TShowTempBtn=0
    ..e  d
    ...s TShowTempBtn=1
    ..s data=data_";"_RowID_"^"_Sele_"^"_TextVal_"^"_NatureValue_"^"_TShowTempBtn_"^"_$g(TTemplateDetail)_"^"_HighRisk
    //w !,data
    k ^DHCPETemp("ItemResult",$j)
    Q data
}

ClassMethod GetODTemplate(ODSRowId As %Library.String = "") As %String
{
    s Data=""
    Set TemplateSub=0
    For  Set TemplateSub=$O(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",ODSRowId,TemplateSub)) Q:(""=TemplateSub)  d
    .s TemplateDesc=^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",ODSRowId,TemplateSub)
    .s Data=Data_TemplateDesc_"^"
    q Data
}

ClassMethod OutOrderToHTML(ChartID, EpisodeID, SSID)
{
    
    s ContrlWidth="155"
    
    s val=$G(^DHCPEDataEx("SDiaginosis",SSID))
    //下拉列表
    w "<select name='LinkOrder' id='LinkOrder"_SSID_"' style='width:"_ContrlWidth_"' HEIGHT=0>",!
    w "<option value=''>  </option>",!
    
    s curStation=##class(web.DHCPE.ResultEdit).GetPEStation(ChartID)
    s OEORDRowId=$O(^OEORD(0,"Adm",EpisodeID,0))
    s OEORIChildsub=0
    f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:(""=OEORIChildsub)  d
    .s OEORIRowId=OEORDRowId_"||"_OEORIChildsub
    .s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
    .q:OEORIItemStatDR'=6
    .s OEORIItmMastDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
    .s Station=$O(^DHCPEST(0,"STORD_ARCIM",OEORIItmMastDR,0))
    .q:(curStation'="")&&(curStation'=Station)
    .s ARCIMSubscript=$P(OEORIItmMastDR,"||",1)
    .s ARCIMVersion=$P(OEORIItmMastDR,"||",2)
    .s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
    .i val=OEORIRowId d
    ..w "<option value="_OEORIRowId_" selected>"_ARCIMDesc_"</option>",!
    .e  d
    ..w "<option value='"_OEORIRowId_"'>"_ARCIMDesc_"</option>",!
    w "</select>",!
    Quit $$$OK
}

// 判断已往检查结果是否存在不正常的细项

// 0 不存在  1存在

// w ##class(web.DHCPE.ResultEdit).HadNotNormal(184,"7337||1","1||18")

ClassMethod HadNotNormal(PAADM, ARCIMID, ODID)
{
    s Flag=0
    s ItemCat=$P(^ARCIM(+ARCIMID,1,1),"^",10)
    s CatType=$p(^ARC("IC",ItemCat),"^",7)
    q:CatType="L" Flag
    s PAPMI=$p(^PAADM(PAADM),"^",1)
    s ADM=PAADM
    f  s ADM=$o(^PAPERdr(PAPMI,"ADM","H",ADM),-1) q:(ADM="")||(Flag=1)  d
    .q:##class(web.DHCPE.ResultPermission).GetReportStatus(ADM)'="Audited"
    .s RLTID=0
    .f  s RLTID=$o(^DHCPERLT(0,"PAADM_OD",ADM,ODID,RLTID)) q:(RLTID="")||(Flag=1)  d
    ..s ARCID=$p(^DHCPERLT(RLTID),"^",2)
    ..q:ARCID'=ARCIMID
    ..s NormalFlag=$p(^DHCPERLT(RLTID),"^",7)
    ..s:NormalFlag=0 Flag=1
    q Flag
}

/// Creator:zhaoym
/// CreatDate:2008-10-14
/// Description: 解密JS加密字符串
/// Input:  需解密字符串
/// Return: 解密后的字符串
/// Others: 为了解决P8版本汉字模糊查询翻页后无法正常显示的问题
/// 在在组件使用该类方法得到值及Query中执行查询前进行该转换  
/// InStr：入参  
ClassMethod UnEscape(InStr As %String) As %String
{
    ;n (InStr)
    s num=1,retStr="",tmpNum=1  
    f num=1:1:$l(InStr,"%") d
    .s char=$p(InStr,"%",num) 
    .i num=1 d
    ..s retStr=$e(char,1,$l(char))
    .e  d
    ..i $e(char,1,1)'="u" d
    ...s retStr=retStr_$char($zhex($e(char,1,2)))_$e(char,3,$l(char))
    ..e  d
    ...s retStr=retStr_$char($zhex($e(char,2,5)))_$e(char,6,$l(char))
    q retStr
}

ClassMethod SaveResufeResult(EpisodeID As %String, OEORIRowId As %String, ResultStr As %String, DocName As %String = "") As %Status
{
   
    s ResultStr=..UnEscape(ResultStr)
    Quit:$g(EpisodeID)="" 1
    Quit:$g(OEORIRowId)="" 1
    Quit:$g(ResultStr)="" 1
    s Status=..IsArrivedStatu(EpisodeID)
    q:Status=0 "NoArrived"
    s Return=..GeneralAdviceAudited(EpisodeID,"PAADM")
    q:Return "GeneralAdviceAudited"
    s ^DHCPEDataEx("DHCPESSDocName",OEORIRowId)=DocName   //华山既往史报告显示询问人、检验审核人
    s ARCIM=$p(^OEORD($p(OEORIRowId,"||",1),"I",$p(OEORIRowId,"||",2),1),"^",2)
    
    s StationID=$o(^DHCPEST(0,"STORD_ARCIM",ARCIM,0))
    
    Set ItemCount=$L(ResultStr,$C(2))
    Set UserId=%session.Get("LOGON.USERID")

    //s sex="M"
    Set myStr=..GetAgeSex(EpisodeID)
    Set sex=$p(myStr,"^",2)
    For I=1:1:ItemCount Do
    .Set ItemStr=$P(ResultStr,$C(2),I)
    .Set ItemID=$P($g(ItemStr),$C(1),1)
    .Quit:ItemID=""
    .Set ItemValue=$P($g(ItemStr),$C(1),2)
    .q:$g(ItemValue)=""
    .Set Normal=..IsNormal(ItemID,ItemValue,sex,StationID)
    .If '$D(^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,ItemID)) Do
    ..KILL PLIST
    ..Set PLIST(2)=EpisodeID,PLIST(3)=ARCIM,PLIST(4)=ItemID
    ..Set PLIST(6)=UserId,PLIST(7)=+$H,PLIST(11)=OEORIRowId,PLIST(8)=Normal
    ..Set PLIST(13)=$p($H,",",2)
    ..&SQL(INSERT INTO SQLUser.DHC_PE_Result VALUES PLIST())
    ..i SQLCODE="0"  d                          //add 
    ...s resultId=%ROWID
    ...s $p(^DHCPERLT(resultId),"^",4)=ItemValue

    .Else  Do
    ..s ComputeFlag=$p(^DHCPEST(+ItemID,"OD",$p(ItemID,"||",2)),"^",2)
    ..q:ComputeFlag="S"
    ..Set RLTId=$O(^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,ItemID,""))
    ..KILL PLIST
    ..Set PLIST(2)=EpisodeID,PLIST(3)=ARCIM,PLIST(4)=ItemID,PLIST(5)=ItemValue
    ..Set PLIST(6)=UserId,PLIST(7)=+$H,PLIST(11)=OEORIRowId,PLIST(8)=Normal
    ..Set PLIST(13)=$p($H,",",2)
    ..&SQL(Update SQLUser.DHC_PE_Result VALUES PLIST() Where RLT_RowId= :RLTId)

    ///MLH20070515
    
    Set ItemRowId=0
    For  Set ItemRowId=$O(^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,ItemRowId))  Quit:ItemRowId=""  Do
    .Set RLTRowId=0
    .For  Set RLTRowId=$O(^DHCPERLT(0,"ADMOD",EpisodeID,OEORIRowId,ItemRowId,RLTRowId))  Quit:RLTRowId=""  Do
    ..Set MustDel=1
    ..For I=1:1:ItemCount Quit:MustDel=0  Do
    ...Set ItemStr=$P(ResultStr,$C(2),I)
    ...Set ItemID=$P($g(ItemStr),$C(1),1)
    ...Set ItemValue=$P($g(ItemStr),$C(1),2)
    ...If ((ItemID=ItemRowId)&(ItemValue'="")) Do
    ....Set MustDel=0
    ..If MustDel=1 Do
    ...&SQL(Delete from SQLUser.DHC_PE_Result where RLT_RowId=:RLTRowId)
      
    //Set IsExecuted=..OrderIsExec(EpisodeID,OEORIRowId)
    //d ..ChangeOrdItemStatus(EpisodeID, OEORIRowId, IsExecuted)
    s SQLCODE=$g(SQLCODE)
    Quit 'SQLCODE
}

ClassMethod GetRefuseInfo(ItemID As %String) As %Status
{
   
    q:ItemID="" "0"
    s ReturnFlag=0
    s ODSTextValStr=""
    s ODSChildSub=0
    f  s ODSChildSub=$o(^DHCPEST($p(ItemID,"||",1),"OD", $p(ItemID,"||",2),"ODS",ODSChildSub))  q:ODSChildSub=""  d
    .s ODSTextVal=$p($g(^DHCPEST($p(ItemID,"||",1),"OD", $p(ItemID,"||",2),"ODS",ODSChildSub)),"^",2)
    .i ODSTextValStr=""  s ODSTextValStr=ODSTextVal
    .else  s ODSTextValStr=ODSTextValStr_"^"_ODSTextVal
    i ODSTextValStr["谢绝检查"  s ReturnFlag=1


    Quit ReturnFlag
}

ClassMethod GetOrderDetailID(OEOrdItemID As %String) As %Status
{
   
    q:OEOrdItemID="" "0"
    s ARCIM=$p(^OEORD($p(OEOrdItemID,"||",1),"I",$p(OEOrdItemID,"||",2),1),"^",2)
    //s StationID=$o(^DHCPEST(0,"STORD_ARCIM",ARCIM,0))
    S ODRID=""
    S ODRID=$O(^DHCPEODR(0,"ARCIM",ARCIM,0))
    Q:ODRID=""
    S ODDR=$P($G(^DHCPEODR(ODRID)),"^",2)

    Quit ODDR
}

ClassMethod GetEDInfo(ID, ChartID, EpisodeID) As %String
{
    q:EpisodeID="" 
    q:ChartID="" 
    s SSID=..GetSSId(EpisodeID,ChartID)
    s Flag=0
    s Sub=""
    i SSID'=""{
    f  s Sub=$o(^DHCPESS(SSID,"Diagnosis",Sub),-1) q:(Sub="")||(Sub=0)||(Flag=1)  d
    .s SSRId=SSID_"||"_Sub
    .s RLID=$p(^DHCPESS(SSID,"Diagnosis",Sub),"^",1)
    .q:RLID=""
    .q:ID'=RLID
    .s Flag=1
    .s RIDDesc=$p(^DHCPESS(SSID,"Diagnosis",Sub),"^",7)
    .s ItemDesc=$p($g(^DHCPEED(RLID,"1")),"^",1)
    .s User=$p($g(^DHCPEED(RLID,1)),"^",4)
    .i User'="" s User=$p($g(^SSU("SSUSR",User)),"^",2)
    .s (Date)=""
    .s Remark=$p(^DHCPESS(SSID,"Diagnosis",Sub),"^",2)
    .s EDCDesc=""
    .Set EDCDR=$g(^DHCPEDataEx("DHCPESSDiagnosis","EDCDR",SSID_"||"_Sub))
    .If EDCDR'="" Set EDCDesc=$p($g(^DHCPEEDC(EDCDR)),"^",2)
    //s ^zl("20110901")=SSRId_"^"_RLID_"^"_User_"^"_ItemDesc_"^"_Date_"^"_Remark_"^"_RIDDesc_"^"_EDCDesc_"^"_EDCDR
    }

    s ReturnStr=SSRId_"^"_RLID_"^"_User_"^"_ItemDesc_"^"_Date_"^"_Remark_"^"_RIDDesc_"^"_EDCDesc_"^"_EDCDR
    q ReturnStr
}

ClassMethod GetSubmitStatus(PAADM, ARCIMID)
{
   
    s SubmitFlag=0
    s StationID=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,0))
    s IADMDR=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
    s SSRowId=0
    f  s SSRowId=$o(^DHCPESS(0,"IADM",IADMDR,StationID,SSRowId))  q:SSRowId=""  d
    .s SSStatus=$p(^DHCPESS(SSRowId,1),"^",7)
    .i SSStatus="SA"   s SubmitFlag=1
  
    s GSRowId=0
    f  s GSRowId=$o(^DHCPEGS(0,"IADM",IADMDR,GSRowId))  q:GSRowId=""  d  
    .s AuditUserDR=$p(^DHCPEGS(GSRowId,1),"^",5)
    .i AuditUserDR'=""  s SubmitFlag=2
    Quit SubmitFlag
}

/// create by ypp at 2009-12
/// d ##class(web.DHCPE.ResultEdit).GetItemResultStr2("1||1")
ClassMethod GetItemResultStr2(InStr As %String)
{
    q:InStr=""
    i InStr="*"
    {
        s data=InStr_"^"_"R"_"^"_"总检结论"
        q data
    }
    s ValueId=0
    S ItemID=InStr
    s Type=$p($G(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",2)
    s data=""
    i Type="S"  //选择型
    {
    k ^DHCPETemp("ItemResult",$j)
    For  Set ValueId=$O(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",ValueId)) Quit:ValueId=""  Do
    .s RowId=ItemID_"||"_ValueId
    .s StrData=^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",ValueId)
    .s Template=$p(StrData,"^",9)
    .i Template="" s Template="999999999"
    .s ^DHCPETemp("ItemResult",$j,Template,RowId)=StrData
    s Sort=""
    f  s Sort=$o(^DHCPETemp("ItemResult",$j,Sort)) q:Sort=""  d
    .s RowID=""
    .f  s RowID=$o(^DHCPETemp("ItemResult",$j,Sort,RowID)) q:RowID=""  d
    ..s StrData=$G(^DHCPETemp("ItemResult",$j,Sort,RowID))
    ..s TextVal=$p(StrData,"^",2)
    ..s NatureValue=$p(StrData,"^",6)
    ..i NatureValue="Y" d
    ...s NatureValue=1
    ..e  s NatureValue=0
    ..s Sele=0
    ..s TTemplateDetail=""
    ..Set Temp=$o(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",RowID,0))
    ..i $g(Temp)="" d
    ...s TShowTempBtn=0
    ..e  d
    ...s TShowTempBtn=1
    ..s data=data_";"_RowID_"^"_Sele_"^"_TextVal_"^"_NatureValue_"^"_TShowTempBtn_"^"_$g(TTemplateDetail)
    k ^DHCPETemp("ItemResult",$j)
    }
    i Type="T"  //说明型
    {
    s ODDesc=$p($G(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",1)
    s data=ItemID_"^"_"T"_"^"_ODDesc
    }
    i (Type="N")||(Type="C")  //数值型
    {
    s ODDesc=$p($G(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",1)
    s ODUnit=$p($G(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",4)
    s data=ItemID_"^"_"N"_"^"_ODDesc_"^"_ODUnit
    }
    Q data
}

ClassMethod AutoRecommFlag(EpisodeID, EDRowID)
{
  
     s EDCRowId=0
     f  s EDCRowId=$o(^DHCPEED(EDRowID,"EDC",EDCRowId)) q:(EDCRowId="")  d
    .s orderDetailStandardID=$P(^DHCPEED(EDRowID,"EDC",EDCRowId),"^",1)
    .s orderDetailID=$P(orderDetailStandardID,"||",1,2)
    .q:orderDetailID=""
    .s rltID=0
    .f  s rltID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID,rltID)) q:rltID=""  d
    ..i '$D(^DHCPEDataEx("AutoSummarizeRecomm","NoRelate",EpisodeID,rltID))  d
    ...s ^DHCPEDataEx("AutoSummarizeRecomm",EpisodeID,rltID)="Y" 
     q ""
}

ClassMethod GetDocNameByItem(OEORDItemID)
{
    ;w ##class(web.DHCPE.ResultEdit).GetDocNameByItem("9072||2")
    s DocUserID=""
    s AuditUserID=""
    s RLTID=$o(^DHCPERLT(0,"OEORI",OEORDItemID,0))
    i RLTID'="" d
    .s DocUserID=$P($G(^DHCPERLT(RLTID)),"^",5)
    .s:DocUserID'="" DocUserID=$P($g(^SSU("SSUSR",DocUserID)),"^",2)
    
    s PAADM=$P($g(^OEORD(+OEORDItemID)),"^",1)
    s ADMLocID=$P($g(^PAADM(PAADM)),"^",4)
    s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    s ArcID=$P($g(^OEORD(+OEORDItemID,"I",$P(OEORDItemID,"||",2),1)),"^",2)
    q:ArcID=""
    //s StationID=$o(^DHCPEST(0,"STORD_ARCIM",ArcID,0))
    s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcID,ADMLocID)
    q:StatOrderID=""
    s StationID=+StatOrderID
    q:StationID="" DocUserID_"^"_AuditUserID
    s SSID=$o(^DHCPESS(0,"IADM",IADM,StationID,0))
    q:SSID="" DocUserID_"^"_AuditUserID
    s AuditUserID=$p($g(^DHCPESS(SSID,1)),"^",5)
    s:AuditUserID'="" AuditUserID=$P($G(^SSU("SSUSR",AuditUserID)),"^",2)
    
    q DocUserID_"$"_AuditUserID
}

// ##class(web.DHCPE.ResultEdit).GetOrderName(OEORIID)

ClassMethod GetOrderName(OEORIID)
{
    q:OEORIID="" ""
    s obj=##class(User.OEOrdItem).%OpenId(OEORIID)
    q obj.OEORIItmMastDR.ARCIMDesc
    q OEORIID_"^"_obj.OEORIItmMastDR.ARCIMDesc_"^"_obj.OEORIItmMastDR.ARCIMCode
}

ClassMethod GetSSDiagnosisName(SSRID)
{
    q:SSRID="" ""
    s Sub=$P(SSRID,"||",2)
    s SSID=+SSRID
    s RLID=$p(^DHCPESS(SSID,"Diagnosis",Sub),"^",1)
    q:RLID="" ""
    s RIDDesc=$p(^DHCPESS(SSID,"Diagnosis",Sub),"^",7)
    s ItemDesc=$p($g(^DHCPEED(RLID,"1")),"^",1)
    s DisplayDesc=$g(^DHCPEDataEx("DHCPESSDiagnosis","DisplayDesc",SSRID))  //Add 20080728
    q:DisplayDesc'="" DisplayDesc
    q ItemDesc
}

ClassMethod GetSSDiagnosisAdvice(SSRID)
{
    q:SSRID="" ""
    s Sub=$P(SSRID,"||",2)
    s SSID=+SSRID
    s RIDDesc=$p(^DHCPESS(SSID,"Diagnosis",Sub),"^",7)
    q RIDDesc
}

ClassMethod AddSpecicalED(PAADM)
{
    s COrderID=$O(^OEORD(0,"Adm",PAADM,0))
    s LocID=$P($G(^PAADM(PAADM)),"^",4)
    s Flag=1
    q:COrderID=""
    s COrderSub="0"
    f  s COrderSub=$O(^OEORD(COrderID,"I",COrderSub)) q:COrderSub=""  d
    .s Stat=$P($g(^OEORD(COrderID,"I",COrderSub,1)),"^",13)
    .q:Stat="4"
    .s PayedFlag=$P($g(^OEORD(COrderID,"I",COrderSub,3)),"^",5)
    .q:PayedFlag'="P"
    .s ARCIMDR=$P($G(^OEORD(COrderID,"I",COrderSub,1)),"^",2)
    .Q:(""=ARCIMDR)
    .s STRowId=0
    .s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMDR, STRowId))
    .Q:(""=STRowId)
    .;Q:STRowId=$G(^DHCPESetting("DHCPE","StationId_Other"))
    .Q:STRowId=$G(^DHCPESetting("DHCPE","StationId_Other",LocID))
    .q:STRowId'="8"
    .s OrderID=COrderID_"||"_COrderSub
    .i '$D(^DHCPERLT(0,"OEORI",OrderID)) d
    ..s Flag=0
    q Flag
}

/// Description: 跳出建议
/// Input:       EpisodeID(就诊ID),StationID（站点ID）
/// Debug: w ##class(web.DHCPE.ResultEdit).GenAdmGeneralRecommLR("1445094",2)
ClassMethod GenAdmGeneralRecommLR(EpisodeID As %String, StationID As %String) As %String
{
    q:$g(EpisodeID)="" 0
    s ADMLocID=$P($G(^PAADM(EpisodeID)),"^",4)
    s UserId=%session.Get("LOGON.USERID")
    ;s IAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,""))
    ;q:IAdm="" 0
    k ^DHCPEGenED("GetSummarize",EpisodeID)
    k ^DHCPEDataEx("AutoSummarizeRecomm",EpisodeID)
    k ^DHCPEGenED("GetSummarizeBBED",EpisodeID)
    k ^DHCPEDataEx("AutoSummarizeRecomm","NoRelate",EpisodeID)
    
    s loc=##class(web.DHCPE.DHCPECommon).GetEDloc()
    s ageSexStr=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
    s sexStr=$P(ageSexStr,"^",2)
    s ageStr=$P(ageSexStr,"^",1)

    s EDRowId=0
    s Job=$J
    k ^TempDHCPE("Sort",Job)
    d ..GetEDSort(EpisodeID,Job)
   
    //f  s EDRowId=$o(^DHCPEED(0,"EDLOC",loc,EDRowId)) q:EDRowId=""  d
    f  s EDRowId=$o(^DHCPEED(EDRowId)) q:EDRowId=""  d
    .q:$D(^DHCPEGenED("GetSummarize",EpisodeID,EDRowId))
    .q:'$d(^DHCPEED(EDRowId))
    .s LocShowDFlag=##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(EDRowId,ADMLocID)
    .q:LocShowDFlag'="Y" 
    .;s activeFlag=$G(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId))
    .s activeFlag=$p($g(^DHCPEED(EDRowId,"1")),"^",13)  //激活
    .q:activeFlag'="Y"
    .s HighRisk=$P($g(^DHCPEED(EDRowId,"1")),"^",8)
    .q:HighRisk="Y"
    .s StationDR=$P($g(^DHCPEED(EDRowId,"1")),"^",7)
    .q:StationID'=StationDR
    .s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","ED",EDRowId,0))
    .s TMPSTIDS=""  // 判断条件的时候记录当前诊断满足了哪个条件而跳出的 用于诊断显示在哪个站点下 
    .i ExpressID'=""  d
    ..;b ;ExpressID
    ..s Express=""
    ..s QuitFlag=0
    ..s ExpressID=0
    ..f  s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","ED",EDRowId,ExpressID)) q:(ExpressID="")||(QuitFlag=1)  d
    ...s obj=##class(User.DHCPEExpress).%OpenId(ExpressID)
    ...;判断年龄范围
    ...s AgeRange=obj.EAgeRange
    ...s MinAge=$P(AgeRange,"-",1)
    ...s:MinAge="" MinAge=0 
    ...s MaxAge=$P(AgeRange,"-",2)
    ...s:MaxAge="" MaxAge=120
    ...;q:(ageStr<MinAge)||(ageStr>MaxAge)
    ...;年龄End
    ...s Express=Express_obj.EPreBracket
    ...s ItemID=obj.EItemDRGetObjectId()
    ...s NoBloodFlag=obj.ENoBloodFlag
    ...s ExCode=obj.EKBItemDtlCode
    ...//****************************************************************************
    ...//ExCode对应多个ItemID,加了一层循环 update by zf 20121210
    ...s ItemIDStr=..GetUseItemID(EpisodeID,ItemID_"^"_ExCode,EDRowId,NoBloodFlag)
    ...i ItemIDStr="" s ItemIDStr="a||b"
    ...s IsResult=0
    ...f indItem=1:1:$l(ItemIDStr,",") d
    ....s ItemID=$p(ItemIDStr,",",indItem)
    ....//
    ....i $D(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID)) d  ;;逐个判断此细项是否满足
    .....s ItemType=obj.EItemDR.ODType
    .....s Reference=obj.EReference
    .....i Reference="" s Reference=obj.EODStandardDR.ODSTextVal
    .....s Operator=obj.EOperator
    .....//s IsResult=0
    .....s RLTID=0
    .....f  s RLTID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID,RLTID)) q:(RLTID="")||(IsResult=1)  d
    ......s Result=$P($g(^DHCPERLT(RLTID)),"^",4)
    ......//
    ......i (Reference="低值")||(Reference="高值") d
    .......s Reference=..GetRealReference(RLTID,Reference)
    ......s OldResult=Result
    ......s EDID=$P($g(^DHCPERLT(RLTID)),"^",9)
    ......i (Operator="[")||(Operator="'[") d
    .......s Result=""""_Result_""""
    .......s Reference=""""_Reference_""""
    ......e  d
    .......s:Result[("≥") Result=$P(Result,"≥",2)
    .......s:Result[("≤") Result=$P(Result,"≤",2)
    .......s:Result[("＞") Result=$P(Result,"＞",2)
    .......s:Result[("＜") Result=$P(Result,"＜",2)
    .......s:Result[(">") Result=$P(Result,">",2)
    .......s:Result[("<") Result=$P(Result,"<",2)
    ......s OneExpress=Result_Operator_Reference
    ......//如果是数值型的，并且判断包含的直接当做不符合条件
    ......i (+OldResult=OldResult)&&((Operator="[")||(Operator="'[")) d
    .......//s IsResult=0
    ......e  d
    .......s tIsResult=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(OneExpress)
    .......i tIsResult=1 d
    ........s IsResult=1
    ........s CurTMPST="^"_(+ItemID)_"^"
    ........s:(TMPSTIDS'[CurTMPST) TMPSTIDS=TMPSTIDS_CurTMPST // 判断条件的时候记录当前诊断满足了哪个条件而跳出的 用于诊断显示在哪个站点下 
    ......s ^TempDHCPERecomm(Job,EDRowId,RLTID)=""
    ....e  d  ;没有结果设置为0
    .....//s IsResult=0
    ...//ExCode对应多个ItemID,加了一层循环 update by zf 20121210
    ...//**********************************end***************************************
    ...i ((ageStr<MinAge)||(ageStr>MaxAge)) s IsResult=0
    ...;b ;IsResult
    ...s ExpressSex=obj.ESex
    ...;性别不符设置为0
    ...i ExpressSex="" s ExpressSex="N"
    ...s:(ExpressSex'="N")&&(ExpressSex'=sexStr) IsResult=0
    ...s Express=Express_IsResult_obj.EAfterBracket_obj.ERelation
    ...s:obj.ERelation="" QuitFlag=1
    ..s rStr=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(Express)
    ..;b ;rStr
    ..i rStr d
    ...s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)="1"
    ...s BBSub=0
    ...f  s BBSub=$O(^DHCPEED(EDRowId,"EDBB",BBSub)) q:BBSub=""   d
    ....s BBEDID=$P(^DHCPEED(EDRowId,"EDBB",BBSub),"^",1)
    ....s ^DHCPEGenED("GetSummarizeBBED",EpisodeID,BBEDID)=""
    ...s Sort=$G(^TempDHCPE("Sort",Job,EDID))
    ...i Sort="" s Sort=1
    ...s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"Sort")=Sort
    ...d ..AutoRecommFlag(EpisodeID,EDRowId)
    
    
    k ^TempDHCPE("Sort",Job)
    s Str=""
    
    s EDRowId=0
    s UpdateDate=+$H
    s UpdateTime=$p($H,",",2) 
    f  s EDRowId=$o(^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)) q:EDRowId=""  d
    .q:^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)=0
    .q:$D(^DHCPEGenED("GetSummarizeBBED",EpisodeID,EDRowId)) ;被排斥的退出
    .s Str=Str_"^"_EDRowId
    k ^DHCPEGenED("GetSummarize",EpisodeID)
    k ^DHCPEGenED("GetSummarizeBBED",EpisodeID)
    q Str
}

// w ##class(web.DHCPE.ResultEdit).GetRealReference("86141","高值")

ClassMethod GetRealReference(RLTID, Reference)
{
    s Normal=$G(^DHCPEDataEx("DHCPEResult",RLTID,"Ranges"))
    
    i Normal["≥" d
    .s Low=$P(Normal,"≥",2)
    .s High=99999999999
    .s Normal=Low_"-"_High
    i Normal["大于" d
    .s Low=$P(Normal,"大于",2)
    .s High=99999999999
    .s Normal=Low_"-"_High
    
    i Normal[">=" d
    .s Low=$P(Normal,">=",2)
    .s High=99999999999
    .s Normal=Low_"-"_High
    
    i Normal[">" d
    .s Low=$P(Normal,">",2)
    .s High=99999999999
    .s Normal=Low_"-"_High
    
    i Normal["≤" d
    .s Low=0
    .s High=$P(Normal,"≤",2)
    .s Normal=Low_"-"_High
    i Normal["<=" d
    .s High=$P(Normal,"<=",2)
    .s Low=0
    .s Normal=Low_"-"_High
    
    i Normal["<" d
    .s High=$P(Normal,"<",2)
    .s Low=0
    .s Normal=Low_"-"_High
    
    i Normal["小于" d
    .s High=$P(Normal,"小于",2)
    .s Low=0
    .s Normal=Low_"-"_High
    q:$L(Normal,"-")'=2 Reference
    
    i Reference="低值" d
    .s Reference=$P(Normal,"-",1)
    i Reference="高值" d
    .s Reference=$P(Normal,"-",2)
    q Reference
}

/// Creator: sunxintao
/// CreateDate: 2021-01-18
/// Descript: 获取提交状态
/// Debugger: d ##class(web.DHCPE.ResultEdit).GetStationSubmitStatus(PAADM, StationID)
ClassMethod GetStationSubmitStatus(PAADM, StationID)
{
   
    s SubmitFlag=0

    s SSRowId=0
    f  s SSRowId=$o(^DHCPESS(0,"PAADM",PAADM,StationID,SSRowId)) q:SSRowId=""  d
    .s SSStatus=$p($g(^DHCPESS(SSRowId,1)),"^",7)
    .i SSStatus="SA"   s SubmitFlag=1
    
    s GSRowId=0
    f  s GSRowId=$o(^DHCPEGS(0,"PAADM",PAADM,GSRowId)) q:GSRowId=""  d  
    .s AuditUserDR=$p($g(^DHCPEGS(GSRowId,1)),"^",5)
    .i AuditUserDR'=""  s SubmitFlag=2
    Quit SubmitFlag
}

}
