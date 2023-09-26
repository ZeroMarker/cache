Class User.DHCAppTestStatus Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = APS_RowID, SqlTableName = DHC_AppTestStatus, StorageStrategy = SQLStorage ]
{

/// 状态代码  APS_Code
Property APSCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = APS_Code ];

/// 状态描述  APS_Desc
Property APSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = APS_Desc ];

/// 集团化医院  APS_Hosp_Dr
Property APSHospDr As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = APS_Hosp_Dr ];

/// 是否可用  APS_ActiveFlag
Property APSActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = APS_ActiveFlag ];

/// 状态说明  APS_Notes
Property APSNotes As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = APS_Notes ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPTST)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCAPPTST</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>APS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({APS_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCAPPTST</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>APS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({APS_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="APS_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APS_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APS_Notes">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCAPPTST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>APS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{APS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppTestStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
