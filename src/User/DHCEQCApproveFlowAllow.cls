Class User.DHCEQCApproveFlowAllow Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = AFA_RowID, SqlTableName = DHC_EQCApproveFlowAllow, StorageStrategy = SQLStorage ]
{

/// AFA_SourceFlowDR
Property AFASourceFlowDR As User.DHCEQCApproveFlow [ SqlColumnNumber = 2, SqlFieldName = AFA_SourceFlowDR ];

/// AFA_AllowFlowDR
Property AFAAllowFlowDR As User.DHCEQCApproveFlow [ SqlColumnNumber = 3, SqlFieldName = AFA_AllowFlowDR ];

/// AFA_Hold1
Property AFAHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AFA_Hold1 ];

/// AFA_Hold2
Property AFHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AFA_Hold2 ];

/// AFA_Hold3
Property AFHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AFA_Hold3 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCApproveFlowAllow",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AFA_AllowFlowDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AFA_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AFA_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AFA_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AFA_SourceFlowDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AFA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCApproveFlowAllow"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{AFA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSourceFlow">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>AFA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCApproveFlowAllow"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SourceFlow"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AFA_Hold1}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AFA_SourceFlowDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AFA_AllowFlowDR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{AFA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCApproveFlowAllowS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
