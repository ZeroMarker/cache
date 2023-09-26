Class User.DHCAdvMedUseLinkItm Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MUL_ItmRowID, SqlTableName = DHC_AdvMedUseLinkItm, StorageStrategy = NewStorage1 ]
{

Index RowIDBasedIDKeyIndex On MULItmChildSub [ IdKey, PrimaryKey, Unique ];

Relationship MULIMULParref As User.DHCAdvMedUseLink [ Cardinality = parent, Inverse = ChildDHCAdvMedUseLinkItm, Required, SqlFieldName = MULI_MUL_Parref ];

Property MULItmChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = MUL_ItmChildSub ];

Property MULItmCode As %String [ SqlColumnNumber = 3, SqlFieldName = MUL_ItmCode ];

Property MULItmDesc As %String [ SqlColumnNumber = 4, SqlFieldName = MUL_ItmDesc ];

Property MULItmActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = MUL_ItmActive ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="IndexItmCode">
<Global>^DHCADVMUSELK</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_AdvMedUseLink.MUL_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MUL_ItmChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ItmCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MUL_ItmCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_AdvMedUseLink.MUL_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MUL_ItmChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="MUL_ItmActive">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MUL_ItmCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MUL_ItmDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCADVMUSELK</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AdvMedUseLink.MUL_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MUL_ItmChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AdvMedUseLink.MUL_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MULI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MUL_ItmChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvMedUseLinkItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
