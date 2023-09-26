Class User.DHCMedAdrRepEventItm Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = MADREVI_RowID, SqlTableName = DHC_MedAdrRepEventItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On MADREVIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship MADREVIParref As User.DHCMedAdrRepEvent [ Cardinality = parent, Inverse = ChildDHCMedAdrRepEventItm, Required, SqlFieldName = MADREVI_Parref ];

Property MADREVIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = MADREVI_ChildSub ];

Property MADREVICode As %String [ SqlColumnNumber = 3, SqlFieldName = MADREVI_Code ];

Property MADREVIDesc As %String [ SqlColumnNumber = 4, SqlFieldName = MADREVI_Desc ];

Property MADREVIActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = MADREVI_ActiveFlag ];

Property MADREVILevel As %String [ SqlColumnNumber = 6, SqlFieldName = MADREVI_Level ];

Property MADREVILevelRowID As %String [ SqlColumnNumber = 7, SqlFieldName = MADREVI_LevelRowID ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="MADREVI_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MADREVI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MADREVI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MADREVI_Level">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MADREVI_LevelRowID">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCMEDADREVTI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedAdrRepEvent.MADREV_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MADREVI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_MedAdrRepEvent.MADREV_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MADREVI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MADREVI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexCode">
<Global>^DHCMEDADREVTI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_MedAdrRepEvent.MADREV_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MADREVI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ItmCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MADREVI_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MADREVI_Parref}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MADREVI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexLevelDr">
<Global>^DHCMEDADREVTI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_MedAdrRepEvent.MADREV_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MADREVI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ItmLevelDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MADREVI_LevelRowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MADREVI_Parref}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MADREVI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedAdrRepEventItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
