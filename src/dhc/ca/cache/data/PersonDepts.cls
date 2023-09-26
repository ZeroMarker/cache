Class dhc.ca.cache.data.PersonDepts Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PersonDepts_rowid, SqlTableName = PersonDepts, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PersonDeptschildSub [ IdKey, PrimaryKey, Unique ];

/// UnitPersons Parent Reference
Relationship PersonDeptsparRef As dhc.ca.cache.data.UnitPersons [ Cardinality = parent, Inverse = ChildPersonDepts, Required, SqlFieldName = PersonDepts_parRef ];

/// PersonDepts_childSub
Property PersonDeptschildSub As %Library.Float [ InitialExpression = {$i(^DHCCAUNITPERSONS($p(%d(0),$c(1),1),"PersonDept",0))}, SqlColumnNumber = 2, SqlFieldName = PersonDepts_childSub ];

/// PersonDepts_deptDr
Property PersonDeptsdeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 3, SqlFieldName = PersonDepts_deptDr ];

/// PersonDepts_rate
Property PersonDeptsrate As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PersonDepts_rate ];

/// PersonDepts_inputPersonDr
Property PersonDeptsinputPersonDr As dhc.ca.cache.data.UnitPersons [ SqlColumnNumber = 5, SqlFieldName = PersonDepts_inputPersonDr ];

/// PersonDepts_own
Property PersonDeptsown As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PersonDepts_own ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="PersonDepts_deptDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PersonDepts_inputPersonDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PersonDepts_own">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PersonDepts_rate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCAUNITPERSONS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UnitPersons.UnitPersons_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PersonDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{UnitPersons.UnitPersons_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PersonDepts"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PersonDepts_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDeptPersons">
<Global>^DHCCAUNITPERSONS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UnitPersons.UnitPersons_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PersonDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DeptPersons"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PersonDepts_deptDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitPersons.UnitPersons_rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PersonDepts_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.PersonDeptsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
