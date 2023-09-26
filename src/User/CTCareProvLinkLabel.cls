/// 基础数据平台-李可凡
/// 2021-11-11
/// 医护人员关联标签表，一个人可以关联多个标签
Class User.CTCareProvLinkLabel Extends %Persistent [ SqlRowIdName = CPLL_RowId, SqlTableName = CT_CareProv_LinkLabel, StorageStrategy = NewStorage1 ]
{

Relationship CPLLParRef As CTCareProv [ Cardinality = parent, Inverse = ChildCTCareProvLinkLabel, Required, SqlFieldName = CPLL_ParRef ];

/// Childsub
Property CPLLChildsub As %Float [ InitialExpression = {$i(^CTPCP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"LinkLabel",0))}, SqlColumnNumber = 2, SqlFieldName = CPLL_Childsub ];

/// 指向标签表
Property CPLLLabelDR As CTLabel [ SqlColumnNumber = 3, SqlFieldName = CPLL_LabelDR ];

Index RowIDBasedIDKeyIndex On CPLLChildsub [ IdKey, PrimaryKey, Unique ];

Storage NewStorage1
{
<SQLMap name="DataMap">
<Data name="CPLL_LabelDR">
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
<Field>CPLL_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LinkLabel"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CPLL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="LabelIndex">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>CPLL_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LinkLabel"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Label"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CPLL_LabelDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CPLL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.CTCareProvLinkLabelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
