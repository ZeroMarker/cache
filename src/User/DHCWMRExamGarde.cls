Class User.DHCWMRExamGarde Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rowid, SqlTableName = DHC_WMR_ExamGarde, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_WMR_ExamRule Parent Reference
Relationship ParRef As User.DHCWMRExamRule [ Cardinality = parent, Inverse = ChildDHCWMRExamGarde, Required ];

/// Child subscript
Property ChildSub As %Library.Float [ InitialExpression = {$i(^DHCWMRER($p(%d(0),$c(1),1),"G",0))}, Required, SqlColumnNumber = 2 ];

/// Title
Property Title As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// MinScore
Property MinScore As %Library.Float [ SqlColumnNumber = 4 ];

/// IsActive
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5 ];

/// ResumeText
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// Money
Property Money As %Library.Float [ SqlColumnNumber = 7 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="IsActive">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MinScore">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Money">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ResumeText">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Title">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCWMRER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WMR_ExamRule.Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_WMR_ExamRule.Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"G"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexScore">
<Global>^DHCWMRER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WMR_ExamRule.Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_WMR_ExamRule.Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"G"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"Score"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MinScore}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRExamGardeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
