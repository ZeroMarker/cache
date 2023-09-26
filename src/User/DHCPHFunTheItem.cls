Class User.DHCPHFunTheItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHTHEI_RowID, SqlTableName = DHC_PHFunTheItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHTHEIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHFunTheme Parent Reference
Relationship PHTHEITHEParRef As User.DHCPHFunTheme [ Cardinality = parent, Inverse = ChildDHCPHFunTheItem, Required, SqlFieldName = PHTHEI_THE_ParRef ];

/// PHTHEI_ChildSub
Property PHTHEIChildSub As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PHTHEI_ChildSub ];

/// PHTHEI_Code
Property PHTHEICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHTHEI_Code ];

/// PHTHEI_Desc
Property PHTHEIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHTHEI_Desc ];

/// PHTHEI_ActiveFlag
Property PHTHEIActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PHTHEI_ActiveFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHTHEI_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHTHEI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHTHEI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHFUTHE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHFunTheme.PHTHE_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHTHEI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PHFunTheme.PHTHE_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHTHEI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHFunTheItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
