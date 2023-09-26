Class User.DHCCLCTemplateCat Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = TMPLC_RowId, SqlTableName = DHC_CLC_TemplateCat, StorageStrategy = CacheStorage ]
{

Property TMPLCCode As %String [ SqlFieldName = TMPLC_Code ];

Property TMPLCDesc As %String [ SqlFieldName = TMPLC_Desc ];

Property TMPLCCtlocDr As %String [ SqlFieldName = TMPLC_Ctloc_Dr ];

Property TMPLCGroupDr As %String [ SqlFieldName = TMPLC_Group_Dr ];

Property TMPLCUserDr As %String [ SqlFieldName = TMPLC_User_Dr ];

Property TMPLCModule As %String [ SqlFieldName = TMPLC_Module ];

Storage CacheStorage
{
<Data name="DHCCLCTemplateCatDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TMPLCModule</Value>
</Value>
</Data>
<Data name="Data">
<Value name="1">
<Value>TMPLCCode</Value>
</Value>
<Value name="2">
<Value>TMPLCDesc</Value>
</Value>
<Value name="3">
<Value>TMPLCCtlocDr</Value>
</Value>
<Value name="4">
<Value>TMPLCGroupDr</Value>
</Value>
<Value name="5">
<Value>TMPLCUserDr</Value>
</Value>
<Value name="6">
<Value>TMPLCModule</Value>
</Value>
</Data>
<DataLocation>^DHCCLC("TemplCat")</DataLocation>
<DefaultData>DHCCLCTemplateCatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLC("TemplCat")</IdLocation>
<IndexLocation>^DHCCLC("TemplCatI")</IndexLocation>
<SqlRowIdName>TMPLC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCCLCTemplateCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="TMPLC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TMPLC_Ctloc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TMPLC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TMPLC_Group_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TMPLC_Module">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TMPLC_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCCLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TMPLC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TMPLC_RowId }</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<Type>%Storage.SQL</Type>
}

}
