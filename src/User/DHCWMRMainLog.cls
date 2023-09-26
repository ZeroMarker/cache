/// DHC_WMR_MainLog
Class User.DHCWMRMainLog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rowid, SqlTableName = DHC_WMR_MainLog, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_WMR_Main Parent Reference
Relationship Parref As User.DHCWMRMain [ Cardinality = parent, Inverse = ChildDHCWMRMainLog, Required ];

/// Child subscript
Property ChildSub As %Library.Float [ InitialExpression = {$i(^DHCWMRMAIN($p(%d(0),$c(1),1),"L",0))}, Required, SqlColumnNumber = 2 ];

/// MrNo
Property MrNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// Papmi
Property Papmi As User.PAPatMas [ SqlColumnNumber = 4 ];

/// User_Dr
Property UserDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = User_Dr ];

/// UpdateDate
Property UpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6 ];

/// UpdateTime
Property UpdateTime As %Library.Time [ SqlColumnNumber = 7 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MrNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Papmi">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
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
<Expression>"L"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRMainLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
