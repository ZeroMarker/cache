Class User.DHCEQCRoleReqElement Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RRE_RowID, SqlTableName = DHC_EQCRoleReqElement, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RRE_ApproveFlowDR
Property RREApproveFlowDR As User.DHCEQCApproveFlow [ SqlColumnNumber = 2, SqlFieldName = RRE_ApproveFlowDR ];

/// RRE_ElementDR
Property RREElementDR As User.DHCEQCElement [ SqlColumnNumber = 3, SqlFieldName = RRE_ElementDR ];

///  RRE_MustFlag
Property RREMustFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = RRE_MustFlag ];

///  RRE_Hold1
Property RREHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = RRE_Hold1 ];

///  RRE_Hold2
Property RREHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = RRE_Hold2 ];

///  RRE_Hold3
Property RREHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = RRE_Hold3 ];

///  RRE_Hold4
Property RREHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = RRE_Hold4 ];

///  RRE_Hold5
Property RREHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = RRE_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCRoleReqElement",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RRE_ApproveFlowDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RRE_ElementDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RRE_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RRE_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RRE_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RRE_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RRE_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RRE_MustFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RRE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCRoleReqElement"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{RRE_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexElementFlow">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RRE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCRoleReqElement"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ElementFlow"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RRE_ElementDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RRE_ApproveFlowDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RRE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCRoleReqElementS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
