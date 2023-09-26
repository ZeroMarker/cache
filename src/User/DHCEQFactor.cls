Class User.DHCEQFactor Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = F_RowID, SqlTableName = DHC_EQFactor, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

///  F_SourceType
Property FSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = F_SourceType ];

///  F_SourceID
Property FSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = F_SourceID ];

///  F_FactorDR
Property FFactorDR As User.DHCEQCFactor [ SqlColumnNumber = 4, SqlFieldName = F_FactorDR ];

///  F_Value
Property FValue As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = F_Value ];

///  F_Unit
Property FUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = F_Unit ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQFactor("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="F_FactorDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="F_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="F_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="F_Unit">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="F_Value">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQFactor</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>F_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{F_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexFactorDR">
<Global>^DHCEQFactor</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>F_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FactorDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{F_FactorDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{F_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQFactorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
