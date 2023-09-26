/// Creator:      刘铁英
/// CreatDate:    2011-1-24
/// Description:  频次对照表,作为频次的扩展表
Class User.DHCFreqExternal Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = FE_Rowid, SqlTableName = DHC_FreqExternal, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// FE_Local_Freq_DR
Property FELocalFreqDR As PHCFreq [ SqlColumnNumber = 2, SqlFieldName = FE_Local_Freq_DR ];

/// FE_Local_Desc
Property FELocalDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = FE_Local_Desc ];

/// FE_Ext_Code
Property FEExtCode As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = FE_Ext_Code ];

/// FE_Ext_Desc
Property FEExtDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = FE_Ext_Desc ];

/// FE_Active
Property FEActive As %Library.String(DISPLAYLIST = ",Yes,NO", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = FE_Active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCFE)</SqlIdExpression>
<SQLMap name="DataMaster">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Data name="FE_Active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FE_Ext_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FE_Ext_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FE_Local_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FE_Local_Freq_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCFE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{FE_Rowid}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{FE_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofFExtCode">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCFE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FE_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExtCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FE_Ext_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofFREQ">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCFE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FE_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FREQ"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FE_Local_Freq_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>FE_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCFreqExternalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
