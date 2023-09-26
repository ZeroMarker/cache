Class User.DHCEQMCMaintGroup Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQMCMaintGroup, StorageStrategy = SQLStorage ]
{

/// MG_Code
Property MGCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MG_Code ];

/// MG_Desc
Property MGDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MG_Desc ];

/// MG_FromDate
Property MGFromDate As %Date [ SqlColumnNumber = 7, SqlFieldName = MG_FromDate ];

/// MG_GroupType
Property MGGroupType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MG_GroupType ];

/// MG_Hold1
Property MGHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MG_Hold1 ];

/// MG_Hold2
Property MGHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MG_Hold2 ];

/// MG_Hold3
Property MGHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MG_Hold3 ];

/// MG_InvalidFlag
Property MGInvalidFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MG_InvalidFlag ];

/// MG_LeaderUserDR
Property MGLeaderUserDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = MG_LeaderUserDR ];

/// MG_ManageLocDR
Property MGManageLocDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MG_ManageLocDR ];

/// MG_Remark
Property MGRemark As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MG_Remark ];

/// MG_ToDate
Property MGToDate As %Date [ SqlColumnNumber = 8, SqlFieldName = MG_ToDate ];

/// MG_Hold4
Property MGHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MG_Hold4 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQCCode("DHCEQMCMaintGroup",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MG_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MG_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MG_GroupType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MG_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MG_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MG_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MG_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MG_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MG_LeaderUserDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MG_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MG_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MG_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQMCMaintGroup"</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{MG_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLeader">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"DHCEQMCMaintGroup"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Leader"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MG_GroupType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MG_LeaderUserDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MG_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQMCMaintGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
