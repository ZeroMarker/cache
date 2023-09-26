Class User.DHCAdvAutLoc Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = AUTL_RowID, SqlTableName = DHC_AdvAutLoc, StorageStrategy = SQLStorage ]
{

/// 代码
Property AUTLCode As %String [ SqlColumnNumber = 2, SqlFieldName = AUTL_Code ];

/// 	描述
Property AUTLDesc As %String [ SqlColumnNumber = 3, SqlFieldName = AUTL_Desc ];

/// 	父级rowid
Property AUTLParentDr As %String [ SqlColumnNumber = 4, SqlFieldName = AUTL_ParentDr ];

/// 	启动标志
Property AUTLActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = AUTL_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVAUTLOC)</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCADVAUTLOC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AUTL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AUTL_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AUTL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="AUTL_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AUTL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AUTL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AUTL_ParentDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCADVAUTLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AUTL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AUTL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="ParentIndex">
<Global>^DHCADVAUTLOC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AUTL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParentDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AUTL_ParentDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AUTL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvAutLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
