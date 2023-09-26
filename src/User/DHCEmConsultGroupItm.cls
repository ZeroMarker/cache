Class User.DHCEmConsultGroupItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EC_RowID, SqlTableName = DHC_EmConsultGroupItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ECChlidSub [ IdKey, PrimaryKey, Unique ];

/// DHC_EmConsultGroup Parent Reference EC_ParRef_Dr
Relationship ECParRefDr As User.DHCEmConsultGroup [ Cardinality = parent, Inverse = ChildDHCEMCONSULTGROUPITM, Required, SqlFieldName = EC_ParRef_Dr ];

/// EC_ChlidSub
Property ECChlidSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = EC_ChlidSub ];

/// 科室  EC_Loc_Dr 
Property ECLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = EC_Loc_Dr ];

/// 科室成员  EC_User_Dr 
Property ECUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = EC_User_Dr ];

/// 联络人标识  EC_ContactsFlag 
Property ECContactsFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = EC_ContactsFlag ];

/// 默认标识  EC_DefFlag 
Property ECDefFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = EC_DefFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="EC_ContactsFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EC_DefFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EC_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EC_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMCG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_EmConsultGroup.EC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>EC_ChlidSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_EmConsultGroup.EC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"G"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_ChlidSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEMCG</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_EmConsultGroup.EC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>EC_ChlidSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_EmConsultGroup.EC_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EC_ChlidSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCEMCG</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_EmConsultGroup.EC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>EC_ChlidSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_User_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_EmConsultGroup.EC_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EC_ChlidSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsultGroupItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
