Class DHCDoc.DHCDocConfig.StopConfig Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query QueryNurOperatDocAuth(HospId As %String) As websys.Query(ROWSPEC = "OperatTypeCode,OperatTypeDesc,PriorIDs,Prior,OrderCatIDs,OrderCat,SpecialItemIDs,SpecialItem,BindSourceCodes,BindSource")
{
}

ClassMethod QueryNurOperatDocAuthExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.StopConfig","QueryNurOperatDocAuth",2)
	Set repid=$I(^CacheTemp)
    Set ind=1
    s NullDesc="未配置"
    //d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CodeTable","QueryDefineData","NURSEOPERATORDE","","")
    Set rset=##Class(%ResultSet).%New("DHCDoc.DHCDocConfig.CodeTable.QueryDefineData")
    Set Status=rset.Execute("","NURSEOPERATORDE","")
    If 'Status Quit
    Set columns = rset.GetColumnCount()
    While (rset.Next()) {
        ///SubRowID:SubCode:SubDesc:SubStDate:SubEndDate:RowId:
        s OperatTypeCode=rset.GetData(2)
        s OperatTypeDesc=rset.GetData(3)
        s StDate=rset.GetData(4)
        s EndDate=rset.GetData(5)
        s StDate=..%ZDH(StDate)
        s EndDate=..%ZDH(EndDate)
        continue:(StDate'="")&&(StDate>..%SysDate())
        continue:(EndDate'="")&&(EndDate<..%SysDate())
        //
        s (PriorIDs,OrderCatIDs,SpecialItemIDs,BindSourceCodes)=""
        s (Prior,OrderCat,SpecialItem,BindSource)=NullDesc
        &SQL(select * into :PLIST() from CF_DOC_Order.NurOperatDocAuth where OperatTypeCode=:OperatTypeCode and HospID=:HospId)
        if (SQLCODE'=0){
            d OutputRowNurOperatDocAuth
            continue
        }
        s PriorIDs=$G(PLIST(4))
        s Prior=..GetPriorDesc(PriorIDs)
        i Prior="" s Prior=NullDesc

        s OrderCatIDs=$G(PLIST(5))
        s OrderCat=..GetOrderCatDesc(OrderCatIDs)
        i OrderCat="" s OrderCat=NullDesc
        s SpecialItemIDs=$G(PLIST(6))
        s SpecialItem=..GetArcItemDesc(SpecialItemIDs)
        i SpecialItem="" s SpecialItem=NullDesc
        s BindSourceCodes=$G(PLIST(7))
        s BindSource=..GetBindSourceDesc(BindSourceCodes)
        i BindSource="" s BindSource=NullDesc
        
        d OutputRowNurOperatDocAuth

    }
	
	d rset.Close()
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowNurOperatDocAuth
	set Data=$lb(OperatTypeCode,OperatTypeDesc,PriorIDs,Prior,OrderCatIDs,OrderCat,SpecialItemIDs,SpecialItem,BindSourceCodes,BindSource)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// 获取医嘱优先级描述
ClassMethod GetPriorDesc(PriorIDs, LangID = "") As %String
{
    s Prior=""
     for i=1:1:$Length(PriorIDs,",") {
        s PriorID=$P(PriorIDs,",",i)
        continue:(PriorID="")
        s Desc=""
        &SQL(select OECPR_Desc into :Desc from SQLUser.OEC_Priority where OECPR_RowId= :PriorID)
        s Desc=##class(User.OECPriority).GetTranByDesc("OECPRDesc",Desc,LangID)
        if (SQLCODE=0){
            if (Prior=""){s Prior=Desc}
            else{s Prior=Prior_","_Desc}
        }
    }
    q Prior
}

/// 获取子类描述
ClassMethod GetOrderCatDesc(OrderCatIDs, LangID = "") As %String
{
    s OrderCat=""
    for i=1:1:$Length(OrderCatIDs,",") {
        s OrderCatID=$P(OrderCatIDs,",",i)
        continue:(OrderCatID="")
        s Desc=""
        &SQL(select ARCIC_Desc  into :Desc  from SQLUser.ARC_ItemCat  where ARCIC_RowId = :OrderCatID)
        s Desc=##class(User.ARCItemCat).GetTranByDesc("ARCICDesc",Desc,LangID)
        if (SQLCODE=0){
            if (OrderCat=""){s OrderCat=Desc}
            else{s OrderCat=OrderCat_","_Desc}
        }
    }
    q OrderCat
}

/// 获取医嘱项描述
ClassMethod GetArcItemDesc(SpecialItemIDs, LangID = "") As %String
{
    s SpecialItem=""
    for i=1:1:$Length(SpecialItemIDs,",") {
        s SpecialItemID=$P(SpecialItemIDs,",",i)
        continue:(SpecialItemID="")
        s Desc=""
        &SQL(SELECT ARCIM_Desc into :Desc from SQLUser.ARC_ItmMast where ARCIM_RowId  = :SpecialItemID)
        s Desc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",Desc,LangID)
        if (SQLCODE=0){
            if (SpecialItem=""){s SpecialItem=Desc}
            else{s SpecialItem=SpecialItem_","_Desc}
        }
    }
    q SpecialItem
}

/// 获取绑定项目描述
ClassMethod GetBindSourceDesc(BindSourceCodes, LangID = "") As %String
{
    s BindSource=""
    for i=1:1:$Length(BindSourceCodes,",") {
        s BindSourceCode=$P(BindSourceCodes,",",i)
        continue:(BindSourceCode="")
        s Desc=##class(web.DHCDocQryOEOrder).GetBindSourceDescByCode(BindSourceCode)
        if (Desc'=""){
						s Desc=..%Translate("ipdoc.patinfoview.csp",Desc,LangID)
            if (BindSource=""){s BindSource=Desc}
            else{s BindSource=BindSource_","_Desc}
        }
    }
    q BindSource
}

/***
  **Description      :修改或插入操作类型上的配置数据
  **Author           :tanjishan
  **Time             :2023/01/30
  **debugger         :w ##class(DHCDoc.DHCDocConfig.StopConfig).SetNurOperatDocAuthfig(2,"C","OrderCat","2,1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,172,173,174,175,176,178,179,180,181")
***/
ClassMethod SetNurOperatDocAuthfig(HospID, OperatTypeCode, ConfigType, IDs) As %String
{
    s ID=""
    ;处理下数据，防止有空ID
    s ConfigIDs=""
    k IDArr
    for i=1:1:$Length(IDs,",") {
        s ConfigID=$P(IDs,",",i)
        continue:(ConfigID="")
        s IDArr(+ConfigID,ConfigID)=""
    }
    s i=""
    for {
        s i=$O(IDArr(i))
        q:(i="")
        s j=""
        for {
            s j=$O(IDArr(i,j))
            q:(j="")
            if (ConfigIDs="") {s ConfigIDs=j}
            else {s ConfigIDs=ConfigIDs_","_j}
        }
    }
    TS
    &SQL(select ID into :ID from CF_DOC_Order.NurOperatDocAuth where OperatTypeCode=:OperatTypeCode and HospID=:HospID)
    if (ID="")||(SQLCODE'=0){
        &SQL(insert into CF_DOC_Order.NurOperatDocAuth (OperatTypeCode,HospID) Values(:OperatTypeCode,:HospID))
        s ID=%ROWID
    }
    if (ID=""){
        TRO
        q "-1^插入配置数据失败,错误代码:"_SQLCODE
    }
    if (ConfigType="Prior"){
        &SQL(Update CF_DOC_Order.NurOperatDocAuth Set PriorIDs=:ConfigIDs where ID=:ID)
    }elseif (ConfigType="OrderCat"){
        &SQL(Update CF_DOC_Order.NurOperatDocAuth Set OrderCatIDs=:ConfigIDs where ID=:ID)
    }elseif (ConfigType="SpecialItem"){
        &SQL(Update CF_DOC_Order.NurOperatDocAuth Set SpecialItemIDs=:ConfigIDs where ID=:ID)
    }elseif (ConfigType="BindSource"){
        &SQL(Update CF_DOC_Order.NurOperatDocAuth Set BindSourceCodes=:ConfigIDs where ID=:ID)
    }else{
        TRO
        q "-1^错误的配置代码:"_ConfigType
    }
    if (SQLCODE=0){
        TC
    }else{
        TRO
    }
    q SQLCODE
}

/***
  **Description      :验证是否有停医嘱权限
  **Author           :tanjishan
  **Time             :2023/01/30
  **debugger         :w ##class(DHCDoc.DHCDocConfig.StopConfig).CheckOperatAuth("217||194","C")
  **Parameter        :input
  **Returns          :Code^Msg;Code-1:有权限，0:无权限;Msg-错误信息
***/
ClassMethod CheckOperatAuth(OrderItemRowId As %String, OperatTypeCode As %String, LangID As %String = "") As %String
{
    q:(OrderItemRowId="")||(OperatTypeCode="") 0
    s EpisodeID=$p(^OEORD(+OrderItemRowId),"^",1)
    q:(EpisodeID="") 0
    s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
    Set rset=##Class(%ResultSet).%New("DHCDoc.DHCDocConfig.CodeTable.QueryDefineData")
    Set Status=rset.Execute("","NURSEOPERATORDE","")
    s OperatTypeDesc=""
    While (rset.Next()) {
        if (OperatTypeCode=rset.GetData(2)){
            s OperatTypeDesc=rset.GetData(3)
            Quit
        }
    }
    s ID=""
    &SQL(select ID into :ID from CF_DOC_Order.NurOperatDocAuth where OperatTypeCode=:OperatTypeCode and HospID=:AdmHospitalId)
    if (ID="")||(SQLCODE'=0){
        q "1^"_..%Translate("ipdoc.patinfoview.csp","未维护"_OperatTypeDesc_"相关权限",LangID)
    }
    &SQL(select * into :PLIST() from CF_DOC_Order.NurOperatDocAuth where ID=:ID)
    if (SQLCODE'=0){
        q "0^"_..%Translate("ipdoc.patinfoview.csp","获取"_OperatTypeDesc_"相关权限失败",LangID)
    }
    s PriorIDs=$G(PLIST(4))
    s Prior=..GetPriorDesc(PriorIDs,LangID)
    s OrderCatIDs=$G(PLIST(5))
    s OrderCat=..GetOrderCatDesc(OrderCatIDs,LangID)
    s SpecialItemIDs=$G(PLIST(6))
    s SpecialItem=..GetArcItemDesc(SpecialItemIDs,LangID)
    s BindSourceCodes=$G(PLIST(7))
    s BindSource=..GetBindSourceDesc(BindSourceCodes,LangID)
    s OperatTypeDesc=..%Translate("ipdoc.patinfoview.csp",OperatTypeDesc,LangID)
    if (PriorIDs_OrderCatIDs_SpecialItemIDs_BindSourceCodes)="" {
        q "0^"_..%Translate("ipdoc.patinfoview.csp","未维护"_OperatTypeDesc_"相关权限",LangID)
    }
    s PriorityDR = $p($G(^OEORD(+OrderItemRowId,"I",$P(OrderItemRowId,"||",2),1)),"^",8)
    s ItmMastDR = $p($G(^OEORD(+OrderItemRowId,"I",$P(OrderItemRowId,"||",2),1)),"^",2)
    if (+ItmMastDR=0){
        q "0^"_..%Translate("ipdoc.patinfoview.csp","无效的医嘱数据",LangID)
    }
    s ItemCatRowid=$p($g(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1)),"^",10)
    s OrderCatType=$P(^ARC("IC",ItemCatRowid),"^",7)
    s BindSource=$P($g(^OEORD(+OrderItemRowId,"I",$P(OrderItemRowId,"||",2),"DHC")),"^",41)
    if (PriorIDs'="")&&((","_PriorIDs_",")'[(","_PriorityDR_",")){
        &SQL(select OECPR_Desc into :Desc from SQLUser.OEC_Priority where OECPR_RowId= :PriorityDR)
        s Desc=##class(User.OECPriority).GetTranByDesc("OECPRDesc",Desc,LangID)
        q "0^"_..%Translate("ipdoc.patinfoview.csp","未授权的医嘱类型:",LangID)_Desc_..%Translate("ipdoc.patinfoview.csp",",您只能",LangID)_OperatTypeDesc_":"_Prior_..%Translate("ipdoc.patinfoview.csp","等医嘱类型。",LangID)
    }
    if (OrderCatIDs'="")&&((","_OrderCatIDs_",")[(","_ItemCatRowid_",")){
        q "1"
    }
    if (SpecialItemIDs'="")&&((","_SpecialItemIDs_",")[(","_ItmMastDR_",")){
        &SQL(SELECT ARCIM_Desc into :Desc from SQLUser.ARC_ItmMast where ARCIM_RowId  = :ItmMastDR)
       q "1"
    }
    if (BindSourceCodes'="")&&(BindSource'="")&&((","_BindSourceCodes_",")[(","_BindSource_",")){
        
        q "1"
    }
    s ErrMsg=""
    if (OrderCat'=""){
        s ErrMsg="("_OrderCat_")"_..%Translate("ipdoc.patinfoview.csp","子类",LangID)
    }
    if (SpecialItem'=""){
        i ErrMsg'="" s ErrMsg=ErrMsg_..%Translate("ipdoc.patinfoview.csp","或",LangID)
        s ErrMsg=ErrMsg_"("_SpecialItem_")"_..%Translate("ipdoc.patinfoview.csp","医嘱项",LangID)
    }
    if (BindSourceCodes'=""){
        i ErrMsg'="" s ErrMsg=ErrMsg_..%Translate("ipdoc.patinfoview.csp","或",LangID)
        s BindSourceDescs=..GetBindSourceDesc(BindSourceCodes,LangID)
        
        s ErrMsg=ErrMsg_"("_BindSourceDescs_")"_..%Translate("ipdoc.patinfoview.csp","绑定来源",LangID)
    }
    s ErrMsg=..%Translate("ipdoc.patinfoview.csp","校验权限未通过，您只能",LangID)_OperatTypeDesc_":"_ErrMsg_..%Translate("ipdoc.patinfoview.csp","相关的医嘱。",LangID)
    
    q "0^"_ErrMsg
}

}
