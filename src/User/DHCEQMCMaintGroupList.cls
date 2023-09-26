Class User.DHCEQMCMaintGroupList Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQMCMaintGroupList, StorageStrategy = SQLStorage ]
{

/// MGL_FromDate
Property MGLFromDate As %Date [ SqlColumnNumber = 4, SqlFieldName = MGL_FromDate ];

/// MGL_Hold1
Property MGLHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MGL_Hold1 ];

/// MGL_Hold2
Property MGLHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MGL_Hold2 ];

/// MGL_Hold3
Property MGLHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MGL_Hold3 ];

/// MGL_InvalidFlag
Property MGLInvalidFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MGL_InvalidFlag ];

/// MGL_MaintGroupDR
Property MGLMaintGroupDR As DHCEQMCMaintGroup [ SqlColumnNumber = 2, SqlFieldName = MGL_MaintGroupDR ];

/// MGL_ManagerFlag
Property MGLManagerFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MGL_ManagerFlag ];

/// MGL_MemberUserDR
Property MGLMemberUserDR As SSUser [ SqlColumnNumber = 3, SqlFieldName = MGL_MemberUserDR ];

/// MGL_ToDate
Property MGLToDate As %Date [ SqlColumnNumber = 5, SqlFieldName = MGL_ToDate ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQCCode("DHCEQMCMaintGroupList",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MGL_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MGL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MGL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MGL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MGL_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MGL_MaintGroupDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MGL_ManagerFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MGL_MemberUserDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MGL_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MGL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQMCMaintGroupList"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{MGL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMaintGroup">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"DHCEQMCMaintGroupList"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MaintGroup"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MGL_MaintGroupDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MGL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMaintMember">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"DHCEQMCMaintGroupList"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MaintMember"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MGL_InvalidFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MGL_MemberUserDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MGL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MGL_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQMCMaintGroupListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
