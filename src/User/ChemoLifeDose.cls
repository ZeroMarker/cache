/// CTOR: QP
/// DATE: 2020-06-24
/// DESC: 化疗药品终身剂量
Class User.ChemoLifeDose Extends %Persistent [ SqlTableName = Chemo_LifeDose, StorageStrategy = SQLStorage ]
{

/// 化疗药品
Property LDArcimDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = LD_ArcimDR ];

/// 终身剂量
Property LDDosage As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = LD_Dosage ];

/// 剂量单位
Property LDUomDR As %String [ SqlColumnNumber = 4, SqlFieldName = LD_UomDR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^BS.DOC.Chemo.Count("User.ChemoLifeDose"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LD_ArcimDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LD_Dosage">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LD_UomDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CF.DOC.Chemo.LifeDoseD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LD_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{LD_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxArcim">
<Global>^CF.DOC.Chemo.LifeDoseI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>LD_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Arcim"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{LD_ArcimDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LD_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LD_ID</SqlRowIdName>
<StreamLocation>^User.ChemoLifeDoseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
