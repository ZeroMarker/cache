Class User.DHCEQNormalCondition Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EV_RowID, SqlTableName = DHC_EQNormalCondition, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// EV_ElementDR
Property EVElementDR As User.DHCEQCElement [ SqlColumnNumber = 2, SqlFieldName = EV_ElementDR ];

/// EV_GroupNum
Property EVGroupNum As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EV_GroupNum ];

///  EV_Factor
Property EVFactor As User.DHCEQCFactor [ SqlColumnNumber = 4, SqlFieldName = EV_Factor ];

///  EV_MinValue
Property EVMinValue As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = EV_MinValue ];

///  EV_MaxValue
Property EVMaxValue As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = EV_MaxValue ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQNormalCondition("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EV_ElementDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EV_Factor">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EV_GroupNum">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EV_MaxValue">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EV_MinValue">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQNormalCondition</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{EV_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexElementDR">
<Global>^DHCEQNormalCondition</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ElementDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EV_ElementDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EV_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQNormalConditionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
