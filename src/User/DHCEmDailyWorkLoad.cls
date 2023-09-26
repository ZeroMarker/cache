Class User.DHCEmDailyWorkLoad Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EM_RowID, SqlTableName = DHC_EmDailyWorkLoad, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCEmDAILYWORKLOADITEM As User.DHCEmDailyWorkLoadItem [ Cardinality = children, Inverse = EMParRefDr ];

/// 记录科室  EM_CrLoc_Dr
Property EMCrLocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = EM_CrLoc_Dr ];

/// 记录日期  EM_CrDate
Property EMCrDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = EM_CrDate ];

/// 记录时间  EM_CrTime
Property EMCrTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = EM_CrTime ];

/// 申请医生  EM_CrUser_Dr
Property EMCrUserDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = EM_CrUser_Dr ];

/// 班次  EM_Schedule
Property EMSchedule As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = EM_Schedule ];

/// 填写日期  EM_WrDate
Property EMWrDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = EM_WrDate ];

/// 类型代码  EM_Type
Property EMType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = EM_Type ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMDWL)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EM_CrDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EM_CrLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EM_CrTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EM_CrUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EM_Schedule">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EM_Type">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EM_WrDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEMDWL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EM_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCreateData">
<Global>^DHCEMDWL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EM_CrDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWriteData">
<Global>^DHCEMDWL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WriteDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EM_WrDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmDailyWorkLoadS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
