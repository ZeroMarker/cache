/// Class User.DHCICUCGestationalAge Extends %Persistent
/// {
/// }
/// DHC_ICUC_GestationalAge
Class User.DHCICUCGestationalAge Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GestationalAge_RowId, SqlTableName = DHC_ICUC_GestationalAge, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// GestationalAge_ICUAId			重症监护记录号
Property GestationalAgeICUAId As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = GestationalAge_ICUAId ];

/// GestationalAge_ChuShengTL		出生胎龄
Property GestationalAgeChuShengTL As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = GestationalAge_ChuShengTL ];

/// GestationalAge_JiuZhengTL		纠正胎龄
Property GestationalAgeJiuZhengTL As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = GestationalAge_JiuZhengTL ];

/// GestationalAge_AddUserDr		新增用户
Property GestationalAgeAddUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = GestationalAge_AddUserDr ];

/// GestationalAge_AddDate		新增日期
Property GestationalAgeAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = GestationalAge_AddDate ];

/// GestationalAge_AddTime		新增时间
Property GestationalAgeAddTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = GestationalAge_AddTime ];

/// GestationalAge_UpdateUserDr		修改用户
Property GestationalAgeUpdateUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = GestationalAge_UpdateUserDr ];

/// GestationalAge_UpdateDate		修改日期
Property GestationalAgeUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = GestationalAge_UpdateDate ];

/// GestationalAge_UpdateTime		修改时间
Property GestationalAgeUpdateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = GestationalAge_UpdateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCICUCGestationalAge(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="GestationalAge_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GestationalAge_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GestationalAge_AddUserDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GestationalAge_ChuShengTL">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GestationalAge_ICUAId">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GestationalAge_JiuZhengTL">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GestationalAge_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="GestationalAge_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="GestationalAge_UpdateUserDr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCICUCGestationalAge</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GestationalAge_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{GestationalAge_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexICUAId">
<Global>^DHCICUCGestationalAge</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GestationalAge_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ICUAId"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GestationalAge_ICUAId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GestationalAge_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCICUCGestationalAgeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
