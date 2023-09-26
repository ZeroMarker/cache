Class User.DHCDocSysParamApp Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = DSPA_RowId, SqlTableName = DHC_DocSysParamApp, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCDocSysParamSet As DHCDocSysParamSet [ Cardinality = children, Inverse = DHCDocSysParamAppParRef ];

/// RowID
Property DSPARowId As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ InitialExpression = {$i(^DHCDocSYS("ParamSet",0))}, Required, SqlFieldName = DSPA_RowId ];

/// 应用程序代码
Property DSPACode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = DSPA_Code ];

/// 应用程序描述
Property DSPADesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = DSPA_Desc ];

Index RowIDBasedIDKeyIndex On DSPARowId [ IdKey, PrimaryKey, Unique ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DSPA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSPA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDocSYS</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DSPA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ParamSet"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSPA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DSPA_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocSysParamAppS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
