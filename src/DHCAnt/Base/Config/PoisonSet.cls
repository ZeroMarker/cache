/// CTOR: QP
/// DATE: 2020-04-15
/// DESC: 管制分类设置
Class DHCAnt.Base.Config.PoisonSet Extends %Persistent [ SqlTableName = PoisonSet, StorageStrategy = SQLStorage ]
{

/// PS_Hosp 院区
Property PSHosp As User.CTHospital [ SqlColumnNumber = 2, SqlFieldName = PS_Hosp ];

/// PS_PhpoDR 管制分类
Property PSPhpoDR As User.PHCPoison [ SqlColumnNumber = 3, SqlFieldName = PS_PhpoDR ];

/// PS_Active 是否管控
Property PSActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PS_Active ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CF.ANT("PoisonSet"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PS_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PS_Hosp">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PS_PhpoDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CF.ANT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PS_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PoisonSet"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PS_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxHospPhpo">
<Global>^CF.ANT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PS_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PoisonSet"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HospPhpo"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PS_Hosp}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PS_PhpoDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PS_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PS_ID</SqlRowIdName>
<StreamLocation>^DHCAnt.Base.Config.PoisonSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
