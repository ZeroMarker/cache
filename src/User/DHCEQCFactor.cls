Class User.DHCEQCFactor Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = F_RowID, SqlTableName = DHC_EQCFactor, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// F_Code
Property FCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = F_Code ];

/// F_Desc
Property FDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = F_Desc ];

/// F_Remark
Property FRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = F_Remark ];

/// F_InvalidFlag
Property FInvalidFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = F_InvalidFlag ];

/// F_Unit
Property FUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = F_Unit ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCFactor",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="F_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="F_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="F_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="F_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="F_Unit">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>F_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCFactor"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{F_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCFactorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
