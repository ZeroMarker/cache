Class User.DHCEQCNormalValues Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EV_RowID, SqlTableName = DHC_EQCNormalValues, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// EV_ElementDR
Property EVElementDR As User.DHCEQCElementCat [ SqlColumnNumber = 2, SqlFieldName = EV_ElementDR ];

/// EV_GroupNum
Property EVGroupNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EV_GroupNum ];

/// EV_ValueType
Property EVValueType As %Library.String(DISPLAYLIST = ",绝对值,差值数值,差值百分比,指定值", MAXLEN = 6, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 4, SqlFieldName = EV_ValueType ];

/// EV_AllFlag
Property EVAllFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = EV_AllFlag ];

/// EV_MinValue
Property EVMinValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = EV_MinValue ];

/// EV_MaxValue
Property EVMaxValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = EV_MaxValue ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCNormalValues",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EV_AllFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EV_ElementDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EV_GroupNum">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EV_MaxValue">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EV_MinValue">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EV_ValueType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>EV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCNormalValues"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{EV_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexElementDR">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCNormalValues"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ElementDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EV_ElementDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EV_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCNormalValuesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
