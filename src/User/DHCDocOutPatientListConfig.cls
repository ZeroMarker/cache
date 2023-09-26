Class User.DHCDocOutPatientListConfig Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowID, SqlTableName = DHCDocOutPatientListConfig, StorageStrategy = DHCDocOutPatientListConfig ]
{

/// 描述
Property DocPatientDesc As %Library.String [ SqlColumnNumber = 2, SqlFieldName = DocPatientDesc ];

/// 排队优先级
Property DocPatientPorio As %Library.String [ SqlColumnNumber = 3, SqlFieldName = DocPatientPorio ];

/// 连续数
Property DocPatientSeries As %Library.String [ SqlColumnNumber = 4, SqlFieldName = DocPatientSeries ];

/// 分诊区
Property DocPatientExaBorough As User.DHCExaBorough [ SqlColumnNumber = 5, SqlFieldName = DocPatientExaBorough ];

/// 医院
Property DocPatientHospDr As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = DocPatientHospDr ];

/// 表达式
Property DocPatientFunction As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DocPatientFunction ];

/// 状态优先级
Property DocPatientStatusPorio As %Library.String [ SqlColumnNumber = 8, SqlFieldName = DocPatientStatusPorio ];

Storage DHCDocOutPatientListConfig
{
<SqlIdExpression>$i(^DHCDocOutPatientListConfig)</SqlIdExpression>
<SQLMap name="IndexExb">
<Global>^DHCDocOutPatientListConfigi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DocPatientExaBorough</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Exabor"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DocPatientExaBorough}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospID">
<Global>^DHCDocOutPatientListConfigi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DocPatientHospDr</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HospID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DocPatientHospDr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DocPatientDesc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DocPatientExaBorough">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DocPatientFunction">
<Node>"Function"</Node>
</Data>
<Data name="DocPatientHospDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DocPatientPorio">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DocPatientSeries">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DocPatientStatusPorio">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCDocOutPatientListConfig</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocOutPa8D21S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
