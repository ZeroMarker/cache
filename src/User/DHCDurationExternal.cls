/// Creator:      刘铁英
/// CreatDate:    2011-1-24
/// Description:  频次对照表,作为频次的扩展表
Class User.DHCDurationExternal Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DE_Rowid, SqlTableName = DHC_DurationExternal, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DE_Local_Duration_DR
Property DELocalDurationDR As User.PHCDuration [ SqlColumnNumber = 2, SqlFieldName = DE_Local_Duration_DR ];

/// DE_Local_Desc
Property DELocalDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DE_Local_Desc ];

/// DE_Ext_Code
Property DEExtCode As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DE_Ext_Code ];

/// DE_Ext_Desc
Property DEExtDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DE_Ext_Desc ];

/// DE_Active
Property DEActive As %Library.String(DISPLAYLIST = ",Yes,NO", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DE_Active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DE_Active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DE_Ext_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DE_Ext_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DE_Local_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DE_Local_Duration_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCDE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DE_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DE_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofDExtCode">
<Global>^DHCDE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DE_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExtCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DE_Ext_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDURATION">
<Global>^DHCDE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DE_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DURATION"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DE_Local_Duration_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DE_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCDurationExternalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
