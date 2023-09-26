Class web.DHCPE.DiagnosticCriteria Extends %Persistent
{

ClassMethod OutDiagnosticCriteria(ElementName, DefaultValue As %String = "")
{
    w "<select name='"_ElementName_"' id='"_ElementName_"' style='width:100%' HEIGHT=0>",!
    w "<option value=''>  </option>",!
    s id=0
    f  s id=$O(^User.DHCPEDiagnosticCriteriaD(id)) q:id=""  d
    .s Active=$LG(^User.DHCPEDiagnosticCriteriaD(id),4)
    .q:Active'="Y"
    .s selected=""
    .s:DefaultValue=id selected="selected"
    .s desc=$LG(^User.DHCPEDiagnosticCriteriaD(id),3) ;_"   "_use
    .w "<option value='"_id_"' "_selected_">"_desc_"</option>",!
    w "</select>",!
    Quit $$$OK
    d ##class(User.DHCPEConclusion).%BuildIndices()
}

ClassMethod UpdateDiagnosticCriteria(ID, InfoStr)
{
    ;w ##class(web.DHCPE.DiagnosticCriteria).UpdateDiagnosticCriteria("","")
    S Code=$P(InfoStr,"^",1)
    S Desc=$P(InfoStr,"^",2)
    s DiaCCode="",DiaCDesc=""

    if ID="" d
    .s obj=##class(User.DHCPEDiagnosticCriteria).%New()
    e  d
    .s obj=##class(User.DHCPEDiagnosticCriteria).%OpenId(ID)
    .s DiaCCode=$LG(^User.DHCPEDiagnosticCriteriaD(ID),2)
    .S DiaCDesc=$LG(^User.DHCPEDiagnosticCriteriaD(ID),3)
    q:(DiaCCode'=Code)&&($d(^User.DHCPEDiagnosticCriteriaI("DCCodeIndex"," "_Code))) "0^代码重复!"
    q:(DiaCDesc'=Desc)&&($d(^User.DHCPEDiagnosticCriteriaI("DCDescIndex"," "_Desc))) "0^描述重复!"

    s obj.DCCode=$P(InfoStr,"^",1)
    s obj.DCDesc=$P(InfoStr,"^",2)
    s obj.DCActive=$P(InfoStr,"^",3)
    s obj.DCExpInfo=$P(InfoStr,"^",4)
    s obj.DCRemark=$P(InfoStr,"^",5)
    s sc=obj.%Save()
    d obj.%Close()
    If ($System.Status.IsError(sc)) 
    {
        q "-1^"_$System.Status.GetErrorText(sc)
    }else{
        q obj.%Id()
    }
}

ClassMethod GetOneDiagnosticCriteriaInfo(ID)
{
    q:ID="" "^^^^^^^^^^^"
    s ID=$P(ID,"$",1)
    s obj=##class(User.DHCPEDiagnosticCriteria).%OpenId(ID)
    s Code=obj.DCCode
    s Desc=obj.DCDesc
    s Active=obj.DCActive
    s ExpInfo=obj.DCExpInfo
    s Remark=obj.DCRemark
    q Code_"^"_Desc_"^"_Active_"^"_ExpInfo_"^"_Remark
}

/// 诊断标准维护
Query SearchDiagnosticCriteria() As %Query(ROWSPEC = "TID:%String,TCode:%String,TDesc:%String,TActive:%String,TExpInfo:%String,TRemark:%String")
{
}

ClassMethod SearchDiagnosticCriteriaExecute(ByRef qHandle As %Binary) As %Status
{
    ;d ##class(%ResultSet).RunQuery("web.DHCPE.DiagnosticCriteria", "SearchDiagnosticCriteria")
    Set repid=$I(^CacheTemp)
    s ind=1
    if $d(%session) {
        set langId=%session.Get("LOGON.LANGID")
    }
    else
    { s langId=""}
    s ID=""
    f  s ID=$O(^User.DHCPEDiagnosticCriteriaD(ID)) q:ID=""  d
    .s TCode=$LG(^User.DHCPEDiagnosticCriteriaD(ID),2)
    .s TDesc=$LG(^User.DHCPEDiagnosticCriteriaD(ID),3)
    .s TDesc=##class(User.DHCPEDiagnosticCriteria).GetTranByDesc("DCDesc",TDesc,langId)
    .s TActive=$LG(^User.DHCPEDiagnosticCriteriaD(ID),4)
    .i TActive="Y" S TActive="是"
    .e  S TActive="否"
    .s TExpInfo=$LG(^User.DHCPEDiagnosticCriteriaD(ID),5)
    .s TRemark=$LG(^User.DHCPEDiagnosticCriteriaD(ID),6)
    .d FindBuild
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
FindBuild      
    set Data=$lb(ID,TCode,TDesc,TActive,TExpInfo,TRemark)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod SearchDiagnosticCriteriaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchDiagnosticCriteriaExecute ]
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

ClassMethod SearchDiagnosticCriteriaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchDiagnosticCriteriaExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod DeleteDiagnosticCriteria(ID)
{
    ;w ##class(web.DHCPE.DiagnosticCriteria).DeleteDiagnosticCriteria("","")
    s obj=##class(User.DHCPEDiagnosticCriteria).%New()
    s sc=obj.%DeleteId(ID)
    d obj.%Close()
    If ($System.Status.IsError(sc)) 
    {
        q "-1^"_$System.Status.GetErrorText(sc)
    }else{
        q obj.%Id()
    }
}

ClassMethod OutDiagnosticCriteriaHISUI(ElementName, DefaultValue As %String = "", width)
{
    w "<select name='"_ElementName_"' id='"_ElementName_"' class='hisui-combobox' style='width:"_width_"' HEIGHT=0>",!
    w "<option value=''>  </option>",!
    s id=0
    f  s id=$O(^User.DHCPEDiagnosticCriteriaD(id)) q:id=""  d
    .s Active=$LG(^User.DHCPEDiagnosticCriteriaD(id),4)
    .q:Active'="Y"
    .s selected=""
    .s:DefaultValue=id selected="selected"
    .s desc=$LG(^User.DHCPEDiagnosticCriteriaD(id),3) ;_"   "_use
    .w "<option value='"_id_"' "_selected_">"_desc_"</option>",!
    w "</select>",!
    Quit $$$OK
    d ##class(User.DHCPEConclusion).%BuildIndices()
}

Storage Default
{
<Data name="DiagnosticCriteriaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.DiagnosticCriteriaD</DataLocation>
<DefaultData>DiagnosticCriteriaDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.DiagnosticCriteriaD</IdLocation>
<IndexLocation>^web.DHCPE.DiagnosticCriteriaI</IndexLocation>
<StreamLocation>^web.DHCPE.DiagnosticCriteriaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
