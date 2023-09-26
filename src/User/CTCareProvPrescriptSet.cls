/// 基础数据平台-李可凡
/// 2020年10月19日
/// 医护人员关联处方权表，一个人可以关联多个处方权
Class User.CTCareProvPrescriptSet Extends %Persistent [ SqlTableName = CT_CareProv_PrescriptSet, StorageStrategy = NewStorage1 ]
{

Relationship CPPSParRef As CTCareProv [ Cardinality = parent, Inverse = ChildCTCareProvPrescriptSet, Required, SqlFieldName = CPPS_ParRef ];

/// Childsub
Property CPPSChildsub As %Float [ InitialExpression = {$i(^CTPCP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CPPS",0))}, SqlColumnNumber = 2, SqlFieldName = CPPS_Childsub ];

/// 指向处方权表
Property CPPSPrescriptSetDR As DHCPrescriptSet [ SqlColumnNumber = 3, SqlFieldName = CPPS_PrescriptSetDR ];

Index RowIDBasedIDKeyIndex On CPPSChildsub [ IdKey, PrimaryKey, Unique ];

Storage NewStorage1
{
<SQLMap name="DataMap">
<Data name="CPPS_PrescriptSetDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CTPCP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CPPS_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"CPPS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CPPS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="PrescriptSetIndex">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>CPPS_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"CPPS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"PrescriptSet"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CPPS_PrescriptSetDR}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="6">
<Expression>{CPPS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CPPS_RowId</SqlRowIdName>
<StreamLocation>^User.CTCareProvPrescriptSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
