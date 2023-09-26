Class User.DHCVISClinical Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = VIS_ClinicalId, SqlTableName = DHC_VIS_Clinical, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 诊区代码
Property VISClinicalCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = VIS_ClinicalCode ];

/// 诊区名称
Property VISClinicalName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = VIS_ClinicalName ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISClinical)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VIS_ClinicalCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VIS_ClinicalName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCVISClinical</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VIS_ClinicalId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{VIS_ClinicalId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFloorName">
<Global>^DHCVISClinicali</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VIS_ClinicalId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ClinicalName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_ClinicalName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_ClinicalId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCVISClinicalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
