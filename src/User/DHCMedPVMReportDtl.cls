Class User.DHCMedPVMReportDtl Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowId, SqlTableName = DHC_MedPVMReportDtl, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ChildSub [ IdKey, PrimaryKey, Unique ];

/// Parent Reference
Relationship Parref As User.DHCMedPVMReport [ Cardinality = parent, Inverse = ChildDHCMedPVMReportDtl, Required ];

/// Child subscript
Property ChildSub As %Library.Float [ InitialExpression = {$i(^mdata("DHCMEDPVMREPORTDTL"))}, Required, SqlColumnNumber = 2 ];

/// DescriptionDr
Property DescriptionDr As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// UserDr
Property UserDr As User.SSUser [ SqlColumnNumber = 4 ];

/// UpdateDate
Property UpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5 ];

/// UpdateTime
Property UpdateTime As %Library.Time [ SqlColumnNumber = 6 ];

/// Text1
Property Text1 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="DescriptionDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Text1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UserDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMedPVMRep</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedPVMReport.RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedPVMReport.RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"D"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedPVMReportDtlS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
