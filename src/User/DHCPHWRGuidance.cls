Class User.DHCPHWRGuidance Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHWRG_RowID, SqlTableName = DHC_PHWRGuidance, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHWRGChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHWardRound Parent Reference PHWRG_PHWR_Parref
Relationship PHWRGPHWRParref As User.DHCPHWardRound [ Cardinality = parent, Inverse = ChildDHCPHWRGUIDANCE, Required, SqlFieldName = PHWRG_PHWR_Parref ];

/// PHWRG_ChildSub
Property PHWRGChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHWRG_ChildSub ];

/// PHWRG_Code  代码
Property PHWRGCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHWRG_Code ];

/// PHWRG_Desc  描述
Property PHWRGDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHWRG_Desc ];

Property PHWRGGuiScopeDR As DHCPHGuiScope [ SqlColumnNumber = 5, SqlFieldName = PHWRG_GuiScope_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHWRG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHWRG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHWRG_GuiScope_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPHWR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHWardRound.PHWR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHWRG_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHWardRound.PHWR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"G"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHWRG_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHWRGuidanceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
