/// 科室分类组物资品种
Class User.DHCLocClaGrpInci Extends (%Persistent, User.Abstract) [ SqlRowIdName = LCGI_RowId, SqlTableName = DHC_LocCLaGrpInci, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On LCGIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship LCGIParref As User.DHCLocClaGrp [ Cardinality = parent, Inverse = ChildDHCLocClaGrpInci, Required, SqlFieldName = LCGI_Parref ];

Property LCGIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = LCGI_ChildSub ];

Property LCGIInciDR As User.INCItm [ SqlColumnNumber = 3, SqlFieldName = LCGI_Inci_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexInci">
<Global>^DHCLCG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_LocClaGrp.LCG_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>LCGI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LCGI_Inci_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_LocClaGrp.LCG_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LCGI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="LCGI_Inci_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCLCG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_LocClaGrp.LCG_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>LCGI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_LocClaGrp.LCG_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{LCGI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>LCGI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCLocClaGrpInciS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
