/// 知识点扩展属性表： TKB_TremExtendCat(子)
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-4-20
Class User.TKBTremExtendCat Extends %Persistent [ SqlRowIdName = TKBTEC_RowId, SqlTableName = TKB_TremExtendCat, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On TKBTECChildsub [ IdKey, PrimaryKey, Unique ];

Relationship TKBTECParDr As User.TKBTremExtend [ Cardinality = parent, Inverse = ChildTKBTremExtendCat, Required, SqlFieldName = TKBTEC_Par_Dr ];

/// Childsub
Property TKBTECChildsub As %Float [ InitialExpression = {$i(^TKBTREEXT($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"Cat",0))}, SqlColumnNumber = 2, SqlFieldName = TKBTEC_Childsub ];

Property TKBTECName As %String [ SqlColumnNumber = 3, SqlFieldName = TKBTEC_Name ];

Property TKBTECType As %String(DISPLAYLIST = ",文本,数据来源,上传文档,单选框,复选框,下拉框,多行文本框,引用诊断", VALUELIST = ",T,S,U,R,CB,C,TA,SD") [ SqlColumnNumber = 4, SqlFieldName = TKBTEC_Type ];

Property TKBTECConfig As %String [ SqlColumnNumber = 5, SqlFieldName = TKBTEC_Config ];

Storage SQLStorage
{
<SQLMap name="MasterData">
<Data name="TKBTEC_Config">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TKBTEC_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TKBTEC_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^TKBTREEXT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TKB_TremExtend.TKBTE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>TKBTEC_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TKB_TremExtend.TKBTE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"Cat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTEC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="NameIndex">
<Global>^TKBTREEXT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TKB_TremExtend.TKBTE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>TKBTEC_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Cat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({TKBTEC_Name})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKB_TremExtend.TKBTE_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBTEC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.TKBTremExtendCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
