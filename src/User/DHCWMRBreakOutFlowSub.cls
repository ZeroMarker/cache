Class User.DHCWMRBreakOutFlowSub Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rowid, SqlTableName = DHC_WMR_BreakOutFlowSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_WMR_BreakOutFlow Parent Reference
Relationship Parref As User.DHCWMRBreakOutFlow [ Cardinality = parent, Inverse = ChildDHCWMRBreakOutFlowSub, Required ];

/// Child subscript
Property ChildSub As %Library.Float [ InitialExpression = {$i(^DHCWMRBOFLOW($p(%d(0),$c(1),1),"S",0))}, Required, SqlColumnNumber = 2 ];

/// IndexNo
Property IndexNo As %Library.Float [ SqlColumnNumber = 3 ];

/// Item_Dr
Property ItemDr As User.DHCWMRWorkItem [ SqlColumnNumber = 4, SqlFieldName = Item_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="IndexNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Item_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCWMRBOFLOW</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WMR_BreakOutFlow.Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_WMR_BreakOutFlow.Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"S"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexItemDr">
<Global>^DHCWMRBOFLOW</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WMR_BreakOutFlow.Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_WMR_BreakOutFlow.Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"S"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"ItemDr"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{Item_Dr}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRBreakOutFlowSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
