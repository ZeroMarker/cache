/// 基础数据平台-临床知识库-病症与诊断关联
Class User.DHCPHDiseaseItmList Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHDISLI_RowId, SqlTableName = DHC_PHDiseaseItmList, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PHDISLIChildsub [ IdKey, PrimaryKey, Unique ];

Relationship PHDISLIDisDr As DHCPHDiseaseList [ Cardinality = parent, Inverse = ChildDHCPHDiseaseItmList, Required, SqlFieldName = PHDISLI_Dis_Dr ];

/// Childsub
Property PHDISLIChildsub As %Float [ InitialExpression = {$i(^DHCPHDISL($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PHDISLI",0))}, SqlColumnNumber = 2, SqlFieldName = PHDISLI_Childsub ];

Property PHDISLIICDDr As User.DHCExtIcdFeild [ SqlColumnNumber = 3, SqlFieldName = PHDISLI_ICD_Dr ];

Property PHDISLIType As %String [ SqlColumnNumber = 4, SqlFieldName = PHDISLI_Type ];

Property PHDISLISysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PHDISLI_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHDISLI_ICD_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHDISLI_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHDISLI_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHDISL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHDiseaseList.PHDISL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHDISLI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHDiseaseList.PHDISL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"ICD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDISLI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="ICDIndex">
<Global>^DHCPHDISL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHDiseaseList.PHDISL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PHDISLI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ICD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDISLI_ICD_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHDiseaseList.PHDISL_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHDISLI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHDISLI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDiseaseItmListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
