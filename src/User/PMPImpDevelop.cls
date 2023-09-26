Class User.PMPImpDevelop Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PID_Rowid, SqlTableName = PMP_ImpDevelop, StorageStrategy = SQLStorage ]
{

/// PIDIPMLDR
Property PIDIPMLDR As PMPImprovementList [ SqlColumnNumber = 2, SqlFieldName = PID_IPML_DR ];

/// PIDDevelopDR
Property PIDDevelopDR As PMPDevelop [ SqlColumnNumber = 3, SqlFieldName = PID_Develop_DR ];

/// PIDDevelopDesc
Property PIDDevelopDesc As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PID_DevelopDesc ];

/// PIDFlag
Property PIDFlag As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PID_Flag ];

/// PID_CreatDate
Property PIDCreatDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PID_CreatDate ];

/// PID_CreatTime
Property PIDCreatTime As %Time [ SqlColumnNumber = 7, SqlFieldName = PID_CreatTime ];

/// PID_CreatUser_DR
Property PIDCreatUserDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PID_CreatUser_DR ];

/// PIDStandby1
Property PIDStandby1 As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PID_Standby1 ];

/// PIDStandby2
Property PIDStandby2 As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = PID_Standby2 ];

/// PIDStandby3
Property PIDStandby3 As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = PID_Standby3 ];

/// PIDStandby4
Property PIDStandby4 As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = PID_Standby4 ];

/// PIDStandby5
Property PIDStandby5 As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = PID_Standby5 ];

/// PIDStandby6
Property PIDStandby6 As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = PID_Standby6 ];

/// PID_UpdateDate
Property PIDUpdateDate As %Date [ SqlColumnNumber = 15, SqlFieldName = PID_UpdateDate ];

/// PID_UpdateTime
Property PIDUpdateTime As %Time [ SqlColumnNumber = 16, SqlFieldName = PID_UpdateTime ];

/// PID_UpdateUser_DR
Property PIDUpdateUserDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PID_UpdateUser_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPImpDevelop("0"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PID_CreatDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PID_CreatTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PID_CreatUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PID_DevelopDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PID_Develop_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PID_Flag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PID_IPML_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PID_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PID_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PID_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PID_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PID_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PID_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PID_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PID_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PID_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^PMPImpDevelop</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PID_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PID_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofDevelopDR">
<Global>^PMPImpDevelopi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"DevelopDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PID_Develop_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PID_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDevelopDesc">
<Global>^PMPImpDevelopi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"DevelopDesc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PID_DevelopDesc}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PID_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofIPML">
<Global>^PMPImpDevelopi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"IPML"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PID_IPML_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PID_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPImpDevelopS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
