/// 人员分类
Class web.DHCPE.Conclusion Extends %Persistent
{

/// w ##class(web.DHCPE.Conclusion).UpdateConclusion("","")
ClassMethod UpdateConclusion(ID, InfoStr)
{
    S Code=$P(InfoStr,"^",1)
    S Desc=$P(InfoStr,"^",2)
    s ConCode="",ConDesc=""

    if ID="" d
    .s obj=##class(User.DHCPEConclusion).%New()
    e  d
    .s obj=##class(User.DHCPEConclusion).%OpenId(ID)
    .s ConCode=$LG(^User.DHCPEConclusionD(ID),2)
    .S ConDesc=$LG(^User.DHCPEConclusionD(ID),3)
    q:(ConCode'=Code)&&($d(^User.DHCPEConclusionI("CCodeIndex"," "_Code))) "0^代码重复!"
    q:(ConDesc'=Desc)&&($d(^User.DHCPEConclusionI("CDescIndex"," "_Desc))) "0^描述重复!"

    s obj.CCode=$P(InfoStr,"^",1)
    s obj.CDesc=$P(InfoStr,"^",2)
    s obj.CActive=$P(InfoStr,"^",3)
    s obj.CVIPLevel=$P(InfoStr,"^",4)
    s obj.CExpInfo=$P(InfoStr,"^",5)
    s obj.CSeverity=$P(InfoStr,"^",6)
    s obj.CRemark=$P(InfoStr,"^",7)
    s sc=obj.%Save()
    d obj.%Close()
    if ($System.Status.IsError(sc)) {
        q "-1^"_$System.Status.GetErrorText(sc)
    } else {
        q obj.%Id()
    }
}

ClassMethod DeleteConclusion(ID)
{
    ;w ##class(web.DHCPE.Conclusion).DeleteConclusion("","")
    q:$d(^User.DHCPEOMEIllnessI("ConclusionIndex",ID)) "-1^该结论分类被目标疾病使用,需要将其关联关系解除"
    s obj=##class(User.DHCPEConclusion).%New()
    s sc=obj.%DeleteId(ID)
    d obj.%Close()
    If ($System.Status.IsError(sc)) 
    {
        q "-1^"_$System.Status.GetErrorText(sc)
    }else{
        q obj.%Id()
    }
}

ClassMethod GetOneConclusionInfo(ID)
{
    q:ID="" "^^^^^^^^^^^"
    s ID=$P(ID,"$",1)
    s obj=##class(User.DHCPEConclusion).%OpenId(ID)
    s Code=obj.CCode
    s Desc=obj.CDesc
    s PEType=obj.CVIPLevel
    s Active=obj.CActive
    s ExpInfo=obj.CExpInfo
    s Severity=obj.CSeverity
    s Remark=obj.CRemark
    q Code_"^"_Desc_"^"_Active_"^"_PEType_"^"_ExpInfo_"^"_Severity_"^"_Remark
}

ClassMethod OutConclusion(ElementName, VIPLevel, DefaultValue As %String = "")
{
    w "<select name='"_ElementName_"' id='"_ElementName_"' style='width:100%' HEIGHT=0>",!
    w "<option value=''>  </option>",!
    s id=0
    f  s id=$O(^User.DHCPEConclusionI("VIPLevelIndex",VIPLevel,id)) q:id=""  d
    .s Active=$LG(^User.DHCPEConclusionD(id),4)
    .q:Active'="Y"
    .s selected=""
    .i DefaultValue="" d
    ..s CurLevel=$LG(^User.DHCPEConclusionD(id),7)
    ..s:CurLevel=0 selected="selected"
    .s:DefaultValue=id selected="selected"
    .s desc=$LG(^User.DHCPEConclusionD(id),3) ;_"   "_use
    .w "<option value='"_id_"' "_selected_">"_desc_"</option>",!
    w "</select>",!
    
    
    Quit $$$OK
    d ##class(User.DHCPEEDItemDetail).%BuildIndices()
}

/// 体检人员分类
Query FindConclusion(Active As %String = "", VIPLevel As %String = "") As %Query(ROWSPEC = "TRowId:%String,TCode:%String,TDesc:%String,TActive:%String,TVIPLevel:%String,TVIPLevelDR:%String,TExpInfo:%String,TSeverity:%String,TRemark:%String")
{
}

ClassMethod FindConclusionExecute(ByRef qHandle As %Binary, Active As %String = "", VIPLevel As %String = "") As %Status
{
    ;d ##class(%ResultSet).RunQuery("web.DHCPE.Conclusion","FindConclusion")
    Set repid=$I(^CacheTemp)
    s ind=1
    s ID=""
    f  s ID=$O(^User.DHCPEConclusionD(ID)) q:ID=""  d
    .d Clear
    .s TCode=$LG(^User.DHCPEConclusionD(ID),2)
    .s TDesc=$LG(^User.DHCPEConclusionD(ID),3)
    .s TDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEConclusion",TDesc,"CDesc","cls")
    .s TActive=$LG(^User.DHCPEConclusionD(ID),4)
    .q:((Active'="")&&(Active'=TActive))
    .i TActive="Y" S TActive="是"
    .e  S TActive="否"
    .s TVIPLevelDR=$LG(^User.DHCPEConclusionD(ID),5)
    .s:TVIPLevelDR'="" TVIPLevel=$P($G(^DHCPEVIPLevel("VIP",TVIPLevelDR)),"^",2)
    .q:(VIPLevel'="")&&(TVIPLevelDR'="")&&(VIPLevel'=TVIPLevelDR)
    .s TExpInfo=$LG(^User.DHCPEConclusionD(ID),6)
    .s TSeverity=$LG(^User.DHCPEConclusionD(ID),7)
    .s TRemark=$LG(^User.DHCPEConclusionD(ID),8)
    .d FindBuild
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
Clear
    s (TCode,TDesc,TActive,TVIPLevel,TExpInfo,TSeverity,TRemark,TVIPLevelDR)=""
    q 
FindBuild      
    set Data=$lb(ID,TCode,TDesc,TActive,TVIPLevel,TVIPLevelDR,TExpInfo,TSeverity,TRemark)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod FindConclusionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindConclusionExecute ]
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

ClassMethod FindConclusionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindConclusionExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod IsUseConclusion(ID)
{
    ;w ##class(web.DHCPE.Conclusion).IsUseConclusion("")
    s flag=0
    if ($d(^User.DHCPEOMEIllnessI("ConclusionIndex",ID))) d
    .s flag=1
    q flag
}

Storage Default
{
<Data name="ConclusionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.ConclusionD</DataLocation>
<DefaultData>ConclusionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.ConclusionD</IdLocation>
<IndexLocation>^web.DHCPE.ConclusionI</IndexLocation>
<StreamLocation>^web.DHCPE.ConclusionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
