Class User.DHCWMRExamRDtl Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rowid, SqlTableName = DHC_WMR_ExamRDtl, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCWMRExamRDtlPeople As User.DHCWMRExamRDtlPeople [ Cardinality = children, Inverse = ParRef ];

/// DHC_WMR_ExamResult Parent Reference
Relationship ParRef As User.DHCWMRExamResult [ Cardinality = parent, Inverse = ChildDHCWMRExamRDtl, Required ];

/// Child subscript
Property ChildSub As %Library.Float [ InitialExpression = {$i(^DHCWMRERST($p(%d(0),$c(1),1),"D",0))}, Required, SqlColumnNumber = 2 ];

/// EntryDr
Property EntryDr As User.DHCWMRExamEntry [ SqlColumnNumber = 3 ];

/// iNumber
Property iNumber As %Library.Float [ SqlColumnNumber = 4 ];

/// Score
Property Score As %Library.Float [ SqlColumnNumber = 5 ];

/// Money
Property Money As %Library.Float [ SqlColumnNumber = 6 ];

/// TriggerDate
Property TriggerDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7 ];

/// ErrType
Property ErrType As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

/// IsActive
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9 ];

/// ResumeText
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="EntryDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ErrType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IsActive">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Money">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ResumeText">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Score">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TriggerDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="iNumber">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCWMRERST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WMR_ExamResult.Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_WMR_ExamResult.Rowid}</Expression>
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
<StreamLocation>^User.DHCWMRExamRDtlS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
