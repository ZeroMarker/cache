Class User.PIVAEqManage Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EQ_RowId, SqlTableName = PIVA_EqManage, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// EQ_Code
Property EQCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = EQ_Code ];

/// EQ_Desc
Property EQDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EQ_Desc ];

/// EQ_Ip
Property EQIp As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = EQ_Ip ];

/// EQ_Com
Property EQCom As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = EQ_Com ];

/// EQ_State
Property EQState As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = EQ_State ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PIVAEM)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EQ_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EQ_Com">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EQ_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EQ_Ip">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EQ_State">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PIVAEM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{EQ_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PIVAEqManageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
