/// Creator:      刘铁英
/// CreatDate:    2011-1-24
/// Description:  用法对照表,作为用法的扩展表
Class User.DHCInstrucExternal Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IE_Rowid, SqlTableName = DHC_InstrucExternal, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IE_Local_Instruc_DR
Property IELocalInstrucDR As User.PHCInstruc [ SqlColumnNumber = 2, SqlFieldName = IE_Local_Instruc_DR ];

/// IE_Local_Desc
Property IELocalDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IE_Local_Desc ];

/// IE_Ext_Code
Property IEExtCode As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IE_Ext_Code ];

/// IE_Ext_Desc
Property IEExtDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IE_Ext_Desc ];

/// IE_Acitve
Property IEActive As %Library.String(DISPLAYLIST = ",Yes,NO", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = IE_Active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCIE)</SqlIdExpression>
<SQLMap name="DataMaster">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Data name="IE_Active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IE_Ext_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IE_Ext_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IE_Local_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IE_Local_Instruc_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCIE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IE_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{IE_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofExtCode">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCIE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IE_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExtCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IE_Ext_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofINSTRUC">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCIE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IE_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INSTRUC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IE_Local_Instruc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>IE_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCInstrucExternalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
