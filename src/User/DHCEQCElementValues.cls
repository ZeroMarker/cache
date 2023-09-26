Class User.DHCEQCElementValues Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EV_RowID, SqlTableName = DHC_EQCElementValues, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// EV_ElementDR
Property EVElementDR As User.DHCEQCElement [ SqlColumnNumber = 2, SqlFieldName = EV_ElementDR ];

/// EV_Value
Property EVValue As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EV_Value ];

/// EV_Desc
Property EVDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = EV_Desc ];

/// EV_NormalFlag
Property EVNormalFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = EV_NormalFlag ];

/// EV_InvalidFlag
Property EVInvalidFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = EV_InvalidFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCElementValues",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EV_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EV_ElementDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EV_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EV_NormalFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EV_Value">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>EV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCElementValues"</Expression>
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
<Expression>"DHCEQCElementValues"</Expression>
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
<StreamLocation>^User.DHCEQCElementValuesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
