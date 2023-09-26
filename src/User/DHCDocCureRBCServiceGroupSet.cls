Class User.DHCDocCureRBCServiceGroupSet Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DDCSGS_Rowid, SqlTableName = DHC_DocCureRBCServiceGroupSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCDocCureRBCServiceGroupSet As User.DHCDocCureTriageResource [ Cardinality = children, Inverse = DDCTRParRef ];

/// DDCSGS_Code  代码
Property DDCSGSCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DDCSGS_Code ];

/// DDCSGS_Desc  描述
Property DDCSGSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DDCSGS_Desc ];

/// DDCSGS_DataFrom  开始日期
Property DDCSGSDataFrom As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = DDCSGS_DataFrom ];

/// DDCSGS_DataTo   截止日期
Property DDCSGSDataTo As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = DDCSGS_DataTo ];

/// DDCSGS_RelateAssTemp  关联的评估模板
Property DDCSGSRelateAssTemp As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DDCSGS_RelateAssTemp ];

/// DDCSGS_RelateRecordTemp  关联的记录模板
Property DDCSGSRelateRecordTemp As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DDCSGS_RelateRecordTemp ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDocCureRBCServiceGroupSet)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCDocCureRBCServiceGroupSet</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DDCSGS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCSGS_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCSGS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DDCSGS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DDCSGS_DataFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DDCSGS_DataTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DDCSGS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDCSGS_RelateAssTemp">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DDCSGS_RelateRecordTemp">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCDocCureRBCServiceGroupSet</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DDCSGS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DDCSGS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCTimePeriodSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
