Class User.DHCWMRExamEntry Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rowid, SqlTableName = DHC_WMR_ExamEntry, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_WMR_ExamSection Parent Reference
Relationship ParRef As User.DHCWMRExamSection [ Cardinality = parent, Inverse = ChildDHCWMRExamEntry, Required ];

/// Child subscript
Property ChildSub As %Library.Float [ InitialExpression = {$i(^DHCWMRER($p(%d(0),"||"),"S",$p(%d(0),"||",2),"E",0))}, Required, SqlColumnNumber = 2 ];

/// EntryDr
Property EntryDr As User.DHCWMREntryDic [ SqlColumnNumber = 3 ];

/// Score
Property Score As %Library.Float [ SqlColumnNumber = 4 ];

/// Pos
Property Pos As %Library.Float [ SqlColumnNumber = 5 ];

/// Money
Property Money As %Library.Float [ SqlColumnNumber = 6 ];

/// MultiErr
Property MultiErr As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7 ];

/// Veto
Property Veto As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8 ];

/// ParentDr
Property ParentDr As User.DHCWMRExamEntry [ SqlColumnNumber = 9 ];

/// Layer
Property Layer As %Library.Float [ SqlColumnNumber = 10 ];

/// RSbilityDr
Property RSbilityDr As User.DHCWMRDictionary [ SqlColumnNumber = 11 ];

/// IsActive
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12 ];

/// ResumeText
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

/// Expression
Property Expression As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 14 ];

Trigger DHCWMRExamEntrybeforedelete [ Event = DELETE, Order = 1 ]
{
 d DeleteIndex^DHCWMRExamRule({Rowid})
}

Trigger DHCWMRExamEntryafterinsert [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d InsertIndex^DHCWMRExamRule({Rowid},{Expression})
}

Trigger DHCWMRExamEntryafterupdate [ Event = UPDATE, Order = 1, Time = AFTER ]
{
 d DeleteIndex^DHCWMRExamRule({Rowid})
 d InsertIndex^DHCWMRExamRule({Rowid},{Expression})
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="EntryDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Expression">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IsActive">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Layer">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Money">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MultiErr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ParentDr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Pos">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RSbilityDr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ResumeText">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="Score">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Veto">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCWMRER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WMR_ExamRule.Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_WMR_ExamSection.ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_WMR_ExamRule.Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"S"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_WMR_ExamSection.ChildSub}</Expression>
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
<SQLMap name="IndexEntry">
<Global>^DHCWMRER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WMR_ExamRule.Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_WMR_ExamSection.ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_WMR_ExamRule.Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"S"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_WMR_ExamSection.ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"E"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"Entry"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{EntryDr}</Expression>
</Subscript>
<Subscript name="8">
<AccessType>sub</AccessType>
<Expression>{ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParPos">
<Global>^DHCWMRER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WMR_ExamRule.Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_WMR_ExamSection.ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L9}</Expression>
<Field>ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_WMR_ExamRule.Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"S"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_WMR_ExamSection.ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"E"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"ParPos"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{ParentDr}</Expression>
</Subscript>
<Subscript name="8">
<AccessType>sub</AccessType>
<Expression>{Pos}</Expression>
</Subscript>
<Subscript name="9">
<AccessType>sub</AccessType>
<Expression>{ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParentPos">
<Global>^DHCWMRER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_WMR_ExamRule.Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DHC_WMR_ExamSection.ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
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
<Expression>"EntryParPos"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ParentDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{Pos}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_WMR_ExamRule.Rowid}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{DHC_WMR_ExamSection.ChildSub}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRExamEntryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
