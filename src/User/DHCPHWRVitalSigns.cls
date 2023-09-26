Class User.DHCPHWRVitalSigns Extends %Persistent [ ClassType = persistent, SqlRowIdName = VS_RowID, SqlTableName = DHC_PHWRVitalSigns, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On VSChildSub [ IdKey, PrimaryKey, Unique ];

Relationship VSParref As User.DHCPHWardRound [ Cardinality = parent, Inverse = ChildPHWRVitalSigns, Required, SqlFieldName = VS_Parref ];

/// VS_ChildSub
Property VSChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = VS_ChildSub ];

/// 生命体征ID
Property VSOBSDR As User.MRObservations [ SqlColumnNumber = 3, SqlFieldName = VS_OBS_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="VS_OBS_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHWR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHWardRound.PHWR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>VS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHWardRound.PHWR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^BS.PHA.PCCP.PHWRVitalSignsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
