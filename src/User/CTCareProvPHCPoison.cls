/// 基础数据平台-李可凡
/// 2020年3月23日
/// 医护人员关联管制药品分类表，一个人可以关联多个药理学分类
Class User.CTCareProvPHCPoison Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = CT_CareProv_PHCPoison, StorageStrategy = SQLStorage ]
{

Relationship CPPParRef As CTCareProv [ Cardinality = parent, Inverse = ChildCTCareProvPHCPoison, Required, SqlFieldName = CPP_ParRef ];

/// Childsub
Property CPPChildsub As %Float [ InitialExpression = {$i(^CTPCP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CPP",0))}, SqlColumnNumber = 2, SqlFieldName = CPP_Childsub ];

/// 指向管制药品分类
Property CPPPHCPoisonDR As PHCPoison [ SqlColumnNumber = 3, SqlFieldName = CPP_PHCPoisonDR ];

Index RowIDBasedIDKeyIndex On CPPChildsub [ IdKey, PrimaryKey, Unique ];

Storage SQLStorage
{
<SQLMap name="DataMap">
<Data name="CPP_PHCPoisonDR">
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
<Field>CPP_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"CPP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CPP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPoison">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>CPP_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CPP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Poison"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CPP_PHCPoisonDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CPP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CPP_RowId</SqlRowIdName>
<StreamLocation>^User.CTCareProvPHCPoisonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
