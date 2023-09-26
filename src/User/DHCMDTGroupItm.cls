Class User.DHCMDTGroupItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MD_RowID, SqlTableName = DHC_MDTGroupItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MDChlidSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MDTGroup Parent Reference MD_ParRef_Dr
Relationship MDParRefDr As User.DHCMDTGroup [ Cardinality = parent, Inverse = ChildDHCMDTGROUPITM, Required, SqlFieldName = MD_ParRef_Dr ];

/// MD_ChlidSub
Property MDChlidSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = MD_ChlidSub ];

/// 成员科室  MD_Loc_Dr 
Property MDLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = MD_Loc_Dr ];

/// 科室人员  MD_User_Dr 
Property MDUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = MD_User_Dr ];

/// 联络人标识  MD_ContactsFlag 
Property MDContactsFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = MD_ContactsFlag ];

/// 会诊医生职称  EC_PrvTp_Dr 
Property MDPrvTpDr As User.CTCarPrvTp [ SqlColumnNumber = 6, SqlFieldName = MD_PrvTp_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="MD_ContactsFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MD_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MD_PrvTp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MD_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMDTG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MDTGroup.MD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MD_ChlidSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_MDTGroup.MD_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MD_ChlidSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCMDTG</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_MDTGroup.MD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MD_ChlidSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MD_User_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_MDTGroup.MD_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MD_ChlidSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMDTGroupItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
