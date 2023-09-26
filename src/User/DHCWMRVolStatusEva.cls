Class User.DHCWMRVolStatusEva Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rowid, SqlTableName = DHC_WMR_VolStatusEva, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_WMR_VolStatus Parent Reference
Relationship Parref As User.DHCWMRVolStatus [ Cardinality = parent, Inverse = ChildDHCWMRVolStatusEva, Required ];

/// Child subscript
Property ChildSub As %Library.Float [ InitialExpression = {$i(^DHCWMRVOL($p(%d(0),"||"),"S",$p(%d(0),"||",2),"E",0))}, Required, SqlColumnNumber = 2 ];

/// Eva_Dr
Property EvaDr As User.DHCWMRWorkItemRule [ SqlColumnNumber = 3, SqlFieldName = Eva_Dr ];

/// User_Dr
Property UserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = User_Dr ];

/// EvaDate
Property EvaDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5 ];

/// EvaTime
Property EvaTime As %Library.Time [ SqlColumnNumber = 6 ];

/// ResumeText
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="EvaDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EvaTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Eva_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ResumeText">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
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
<Field>DHC_WMR_VolStatus.ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_WMR_MainVolume.Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"S"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_WMR_VolStatus.ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"E"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRVolStatusEvaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
