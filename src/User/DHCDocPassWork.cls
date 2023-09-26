Class User.DHCDocPassWork Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHC_DocPassWork, StorageStrategy = SQLStorage ]
{

Relationship ChildDetail As User.DHCDocPassWorkDetail [ Cardinality = children, Inverse = DetailParref ];

Index RowIDBasedIDKeyIndex On DDPWRowId [ IdKey, PrimaryKey, Unique ];

/// RowId
Property DDPWRowId As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DDPW(0))}, Required, SqlFieldName = DDPW_RowId ];

/// LocDr	科室
Property DDPWLocDR As CTLoc [ Required, SqlColumnNumber = 2, SqlFieldName = DDPW_Loc_DR ];

/// CareDate	交班日期
Property DDPWCareDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 3, SqlFieldName = DDPW_CareDate ];

/// CareUserDR	交班人
Property DDPWCareUserDR As SSUser [ SqlColumnNumber = 4, SqlFieldName = DDPW_CareUser_DR ];

/// WorkType	白班/夜班(D/N)
Property DDPWWorkType As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DDPW_WorkType ];

/// DDPW_XML 
Property DDPWXML As %String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DDPW_XML ];

/// InsertDate		插入日期
Property DDPWInsertDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 7, SqlFieldName = DDPW_InsertDate ];

/// InsertTime		插入时间
Property DDPWInsertTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 8, SqlFieldName = DDPW_InsertTime ];

/// DDPW_Note
Property DDPWNote As %String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = DDPW_Note ];

/// DDPW_UpdateDate		更新日期
Property DDPWUpdateDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 10, SqlFieldName = DDPW_UpdateDate ];

/// DDPW_UpdateTime		更新时间
Property DDPWUpdateTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 11, SqlFieldName = DDPW_UpdateTime ];

/// DDPW_UpdateUserDR	更新人
Property DDPWUpdateUserDR As SSUser [ SqlColumnNumber = 12, SqlFieldName = DDPW_UpdateUserDR ];

/// DDPW_BCName	班次名称
Property DDPWBCName As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = DDPW_BCName ];

/// DDPW_BCSTime 班次开始时间
Property DDPWBCSTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 14, SqlFieldName = DDPW_BCSTime ];

/// DDPW_BCETime 班次结束时间
Property DDPWBCETime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 15, SqlFieldName = DDPW_BCETime ];

/// DDPW_BCIsNextDay 班次是否跨日
Property DDPWBCIsNextDay As %String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = DDPW_BCIsNextDay ];

/// DDPW_BCSeqno 第几班次
Property DDPWBCSeqno As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = DDPW_BCSeqno ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DDPW(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DDPW_BCETime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DDPW_BCIsNextDay">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DDPW_BCName">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DDPW_BCSTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DDPW_BCSeqno">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DDPW_CareDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDPW_CareUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DDPW_InsertDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DDPW_InsertTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DDPW_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DDPW_Note">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DDPW_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DDPW_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DDPW_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DDPW_WorkType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DDPW_XML">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DDPW</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DDPW_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DDPW_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBCType">
<Global>^DDPW</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DDPW_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BCType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDPW_WorkType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDPW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDate">
<Global>^DDPW</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DDPW_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDPW_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDPW_CareDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DDPW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDateType">
<Global>^DDPW</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DDPW_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocDateType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDPW_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDPW_CareDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DDPW_WorkType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DDPW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DDPW_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocPassWorkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
