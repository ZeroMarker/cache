Class User.DHCCLCTemplate Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = TMPL_RowId, SqlTableName = DHC_CLC_Template, StorageStrategy = CacheStorage ]
{

Property TMPLCode As %String [ SqlFieldName = TMPL_Code ];

Property TMPLDesc As %String [ SqlFieldName = TMPL_Desc ];

Property TMPLTMPLCDr As DHCCLCTemplateCat [ SqlFieldName = TMPL_TMPLC_Dr ];

Property TMPLAdditionalCode As %String [ SqlFieldName = TMPL_AdditionalCode ];

Property TMPLData As %Stream.GlobalCharacter [ SqlFieldName = TMPL_Data ];

Property TMPLAvailable As %Boolean [ SqlFieldName = TMPL_Available ];

Property TMPLSeqMode As %String [ SqlFieldName = TMPL_SeqMode ];

Property TMPLSeqNo As %String [ SqlFieldName = TMPL_SeqNo ];

Property TMPLNote As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlFieldName = TMPL_Note ];

Property TMPLUpdateUserDr As %String [ SqlFieldName = TMPL_UpdateUser_Dr ];

Property TMPLUpdateDate As %Date [ SqlFieldName = TMPL_UpdateDate ];

Property TMPLUpdateTime As %Time [ SqlFieldName = TMPL_UpdateTime ];

Storage CacheStorage
{
<Data name="DHCCLCTemplateDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="Data">
<Value name="1">
<Value>TMPLCode</Value>
</Value>
<Value name="2">
<Value>TMPLDesc</Value>
</Value>
<Value name="3">
<Value>TMPLTMPLCDr</Value>
</Value>
<Value name="4">
<Value>TMPLAdditionalCode</Value>
</Value>
<Value name="5">
<Value>TMPLData</Value>
</Value>
<Value name="6">
<Value>TMPLAvailable</Value>
</Value>
<Value name="7">
<Value>TMPLSeqMode</Value>
</Value>
<Value name="8">
<Value>TMPLSeqNo</Value>
</Value>
<Value name="9">
<Value>TMPLNote</Value>
</Value>
<Value name="10">
<Value>TMPLUpdateUserDr</Value>
</Value>
<Value name="11">
<Value>TMPLUpdateDate</Value>
</Value>
<Value name="12">
<Value>TMPLUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCCLC("Template")</DataLocation>
<DefaultData>DHCCLCTemplateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLC("Template")</IdLocation>
<IndexLocation>^DHCCLC("Template")</IndexLocation>
<SqlRowIdName>TMPL_RowId</SqlRowIdName>
<StreamLocation>^DHCCLCTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="TMPL_AdditionalCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TMPL_Available">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TMPL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TMPL_Data">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TMPL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TMPL_Note">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TMPL_SeqMode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TMPL_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TMPL_TMPLC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TMPL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TMPL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TMPL_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCCLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TMPL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TMPL_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<Type>%Storage.SQL</Type>
}

}
