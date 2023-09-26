Class User.DHCDocSSGroupConfig Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowId, SqlTableName = DHC_DocSSGroupConfig, StorageStrategy = SQLStorge ]
{

Property DocSSGroupUserDR As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = DocSSGroup_UserDR ];

Property DocSSGroupDefLoc As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = DocSSGroup_DefLoc ];

Property DocSSGroupDeGroupDR As User.SSGroup [ SqlColumnNumber = 4, SqlFieldName = DocSSGroup_DeGroupDR ];

Property DocSSGroupStartDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = DocSSGroup_StartDate ];

Property DocSSGroupEndDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = DocSSGroup_EndDate ];

Property DocSSGroupInsertUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DocSSGroup_InsertUserDR ];

Property DocSSGroupInsertDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = DocSSGroup_InsertDate ];

Property DocSSGroupInsertTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = DocSSGroup_InsertTime ];

Property DocSSGroupCancleUserDR As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = DocSSGroup_CancleUserDR ];

Property DocSSGroupCancleDate As %Library.Date [ SqlColumnNumber = 11, SqlFieldName = DocSSGroup_CancleDate ];

Property DocSSGroupCancleTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = DocSSGroup_CancleTime ];

Property DocSSGroupRBResouceID As User.RBResource [ SqlColumnNumber = 13, SqlFieldName = DocSSGroup_RBResouceID ];

Storage SQLStorge
{
<SqlIdExpression>$i(^DHCDocSSGroupConfig(0))</SqlIdExpression>
<SQLMap name="IndexDefLoc">
<Global>^DHCDocSSGroupConfig</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DocSSGroup_DefLoc</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Defloc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DocSSGroup_DefLoc}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEnddate">
<Global>^DHCDocSSGroupConfig</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DocSSGroup_EndDate</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"EndDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DocSSGroup_EndDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRBResouce">
<Global>^DHCDocSSGroupConfig</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DocSSGroup_RBResouceID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RBResouce"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DocSSGroup_RBResouceID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexuserLoc">
<Global>^DHCDocSSGroupConfig</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DocSSGroup_UserDR</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DocSSGroup_DefLoc</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UserLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DocSSGroup_UserDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DocSSGroup_DefLoc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DocSSGroup_CancleDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DocSSGroup_CancleTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DocSSGroup_CancleUserDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DocSSGroup_DeGroupDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DocSSGroup_DefLoc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DocSSGroup_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DocSSGroup_InsertDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DocSSGroup_InsertTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DocSSGroup_InsertUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DocSSGroup_RBResouceID">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DocSSGroup_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DocSSGroup_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCDocSSGroupConfig</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocSSGroupConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
