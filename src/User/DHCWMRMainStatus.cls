Class User.DHCWMRMainStatus Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rowid, SqlTableName = DHC_WMR_MainStatus, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCWMRMainStatusDtl As User.DHCWMRMainStatusDtl [ Cardinality = children, Inverse = Parref ];

/// DHC_WMR_Main Parent Reference
Relationship Parref As User.DHCWMRMain [ Cardinality = parent, Inverse = ChildDHCWMRMainStatus, Required ];

/// Child subscript
Property ChildSub As %Library.Float [ InitialExpression = {$i(^DHCWMRMAIN($p(%d(0),$c(1),1),"S",0))}, Required, SqlColumnNumber = 2 ];

/// Status
Property StatusDr As User.DHCWMRWorkItem [ SqlColumnNumber = 3, SqlFieldName = Status_Dr ];

/// UserFromDr
Property UserFromDr As User.SSUser [ SqlColumnNumber = 4 ];

/// CurrDate
Property CurrDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5 ];

/// CurrTime
Property CurrTime As %Library.Time [ SqlColumnNumber = 6 ];

/// UserToDr
Property UserToDr As User.SSUser [ SqlColumnNumber = 7 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="CurrDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CurrTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Status_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UserFromDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UserToDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCWMRMAIN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WMR_Main.Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_WMR_Main.Rowid}</Expression>
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
<SQLMap name="IndexDateStatus">
<Global>^DHCWMRMAIN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_WMR_Main.Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SDateStatus"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CurrDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{Status_Dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_WMR_Main.Rowid}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"S"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCWMRMAIN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WMR_Main.Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_WMR_Main.Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{Status_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRMainStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
