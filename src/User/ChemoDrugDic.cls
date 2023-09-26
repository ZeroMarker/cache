/// CTOR: QP
/// DATE: 2020-12-17
/// DESC: 化疗药品终身剂量
Class User.ChemoDrugDic Extends %Persistent [ SqlTableName = Chemo_DrugDic, StorageStrategy = SQLStorage ]
{

/// 化疗药品
Property DArcimDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = D_ArcimDR ];

/// 显示顺序
Property DSeqno As %String [ SqlColumnNumber = 3, SqlFieldName = D_Seqno ];

/// 是否激活
Property DActive As %String [ SqlColumnNumber = 4, SqlFieldName = D_Active ];

/// 药品简写
Property DName As %String [ SqlColumnNumber = 5, SqlFieldName = D_Name ];

/// 院区
Property DHosp As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = D_Hosp ];

Storage SQLStorage
{
<SqlIdExpression>$i(^mdata("User.ChemoDrugDic"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="D_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="D_ArcimDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="D_Hosp">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="D_Name">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="D_Seqno">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CF.DOC.Chemo.DrugDicD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>D_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{D_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxArcim">
<Global>^CF.DOC.Chemo.DrugDicI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>D_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Arcim"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{D_ArcimDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{D_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospArcim">
<Global>^CF.DOC.Chemo.DrugDicI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>D_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HospArcim"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{D_Hosp}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{D_ArcimDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{D_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>D_ID</SqlRowIdName>
<StreamLocation>^User.ChemoDrugDicS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
