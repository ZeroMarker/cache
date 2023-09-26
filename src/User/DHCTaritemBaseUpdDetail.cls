Class User.DHCTaritemBaseUpdDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UBD_RowID, SqlTableName = DHC_TaritemBaseUpdDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On UBDChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_TaritemBaseUpdInfo Parent Reference
Relationship UBDUBIParRef As User.DHCTaritemBaseUpdInfo [ Cardinality = parent, Inverse = ChildDHCTaritemBaseUpdDetail, Required, SqlFieldName = UBD_UBI_ParRef ];

/// UBD_ChildSub
Property UBDChildSub As %Library.Float [ InitialExpression = {$i(^DHCTARIUBI($p(%d(0),$c(1),1),"D",0))}, Required, SqlColumnNumber = 2, SqlFieldName = UBD_ChildSub ];

/// UBD_ItemCode_Dr
Property UBDItemCodeDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = UBD_ItemCode_Dr ];

/// UBD_OldInfo
Property UBDOldInfo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = UBD_OldInfo ];

/// UBD_NewInfo
Property UBDNewInfo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = UBD_NewInfo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="datamaster">
<Data name="UBD_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UBD_ItemCode_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UBD_NewInfo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UBD_OldInfo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UBD_UBI_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCTARIUBI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_TaritemBaseUpdInfo.UBI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>UBD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_TaritemBaseUpdInfo.UBI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"D"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{UBD_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCTaritemBaseUpdDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
