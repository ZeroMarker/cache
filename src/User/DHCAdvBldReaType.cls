Class User.DHCAdvBldReaType Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BLDRT_RowID, SqlTableName = DHC_AdvBldReaType, StorageStrategy = NewStorage1 ]
{

Property BLDRTCode As %String [ SqlColumnNumber = 2, SqlFieldName = BLDRT_Code ];

Property BLDRTDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BLDRT_Desc ];

Property BLDRTActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = BLDRT_Active ];

Storage Default
{
<Data name="DHCAdvBldReaTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BLDRTCode</Value>
</Value>
<Value name="3">
<Value>BLDRTDesc</Value>
</Value>
<Value name="4">
<Value>BLDRTActive</Value>
</Value>
</Data>
<DataLocation>^User.DHCAdvBldReaTypeD</DataLocation>
<DefaultData>DHCAdvBldReaTypeDefaultData</DefaultData>
<IdLocation>^User.DHCAdvBldReaTypeD</IdLocation>
<IndexLocation>^User.DHCAdvBldReaTypeI</IndexLocation>
<SqlIdExpression>$i(^User.DHCAdvBldReaTypeD)</SqlIdExpression>
<StreamLocation>^User.DHCAdvBldReaTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Storage NewStorage1
{
<SQLMap name="IndexCode">
<Global>^DHCADVBLDREATYPE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BLDRT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({BLDRT_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLDRT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="BLDRT_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BLDRT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BLDRT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCADVBLDREATYPE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BLDRT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{BLDRT_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvBldReaTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
