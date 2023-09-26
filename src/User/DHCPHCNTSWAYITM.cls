Class User.DHCPHCNTSWAYITM Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PWAYI_RowID, SqlTableName = DHC_PHCNTSWAYITM, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PWAYIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PWAYIParref As User.DHCPHCNTSWAY [ Cardinality = parent, Inverse = ChildDHCPHCNTSWAYITM, SqlFieldName = PWAYI_Parref ];

/// PWAYI_ChildSub
Property PWAYIChildSub As %Float [ SqlColumnNumber = 2, SqlFieldName = PWAYI_ChildSub ];

/// PWAYI_UserGroup_Dr
Property PWAYIUserGroupDr As User.SSGroup [ SqlColumnNumber = 3, SqlFieldName = PWAYI_UserGroup_Dr ];

/// PWAYI_UpdateFlag
Property PWAYIUpdateFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PWAYI_UpdateFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="MasterData">
<Data name="PWAYI_UpdateFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PWAYI_UserGroup_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPCWAY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHCNTSWAY.PWAY_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PWAYI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_PHCNTSWAY.PWAY_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PWAYI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHCNTSWAYITMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
