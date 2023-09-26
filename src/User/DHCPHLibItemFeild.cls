Class User.DHCPHLibItemFeild Extends (%Persistent, User.Abstract) [ SqlRowIdName = PLIF_RowId, SqlTableName = DHC_PHLibItemFeild, StorageStrategy = NewStorage1 ]
{

Property PLIFCode As %String [ SqlColumnNumber = 2, SqlFieldName = PLIF_Code ];

Property PLIFDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PLIF_Desc ];

Property PLIFFunDr As User.DHCPHLibFuntions [ SqlColumnNumber = 4, SqlFieldName = PLIF_Fun_Dr ];

Property PLIFRemark As %String [ SqlColumnNumber = 5, SqlFieldName = PLIF_Remark ];

Property PLIFActiveFlag As %String [ SqlColumnNumber = 6, SqlFieldName = PLIF_ActiveFlag ];

Property PLIFCatDr As User.DHCPHFunCatFeild [ SqlColumnNumber = 7, SqlFieldName = PLIF_CatDr ];

Property PLIFParentId As %String [ SqlColumnNumber = 8, SqlFieldName = PLIF_ParentId ];

Property PLIFArguments As %String [ SqlColumnNumber = 9, SqlFieldName = PLIF_Arguments ];

Property PLIFVal As %String [ SqlColumnNumber = 10, SqlFieldName = PLIF_Val ];

Property PLIFRelation As %String [ SqlColumnNumber = 11, SqlFieldName = PLIF_Relation ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCLIBITMF)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCLIBITMF</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PLIF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PLIF_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PLIF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PLIF_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PLIF_Arguments">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PLIF_CatDr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PLIF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PLIF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PLIF_Fun_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PLIF_ParentId">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PLIF_Relation">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PLIF_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PLIF_Val">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCLIBITMF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PLIF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PLIF_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHLibItemFeildS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
