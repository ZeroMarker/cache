Class User.DHCWMRVolLog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rowid, SqlTableName = DHC_WMR_VolLog, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_WMR_MainVolume Parent Reference
Relationship ParRef As User.DHCWMRMainVolume [ Cardinality = parent, Inverse = ChildDHCWMRVolLog, Required ];

/// Child subscript
Property ChildSub As %Library.Float [ InitialExpression = {$i(^DHCWMRVOL($p(%d(0),$c(1),1),"L",0))}, Required, SqlColumnNumber = 2 ];

/// Main_Dr
Property MainDr As User.DHCWMRMain [ SqlColumnNumber = 3, SqlFieldName = Main_Dr ];

/// User_Dr
Property UserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = User_Dr ];

/// UpdateDate
Property UpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5 ];

/// UpdateTime
Property UpdateTime As %Library.Time [ SqlColumnNumber = 6 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="Main_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCWMRVOL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WMR_MainVolume.Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_WMR_MainVolume.Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"L"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRVolLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
