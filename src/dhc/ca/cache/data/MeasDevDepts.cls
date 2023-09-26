Class dhc.ca.cache.data.MeasDevDepts Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MeasDevDepts_rowid, SqlTableName = MeasDevDepts, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MeasDevDeptschildSub [ IdKey, PrimaryKey, Unique ];

/// UnitMeasDev Parent Reference
Relationship MeasDevDeptsparRef As dhc.ca.cache.data.UnitMeasDev [ Cardinality = parent, Inverse = ChildMeasDevDepts, Required, SqlFieldName = MeasDevDepts_parRef ];

/// MeasDevDepts_childSub
Property MeasDevDeptschildSub As %Library.Float [ InitialExpression = {$i(^DHCCAUNITMEASDEV($p(%d(0),$c(1),1),"Devdepts",0))}, SqlColumnNumber = 2, SqlFieldName = MeasDevDepts_childSub ];

/// MeasDevDepts_deptDr
Property MeasDevDeptsdeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 3, SqlFieldName = MeasDevDepts_deptDr ];

/// MeasDevDepts_rate
Property MeasDevDeptsrate As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = MeasDevDepts_rate ];

/// MeasDevDepts_inputPersonDr
Property MeasDevDeptsinputPersonDr As dhc.ca.cache.data.UnitPersons [ SqlColumnNumber = 5, SqlFieldName = MeasDevDepts_inputPersonDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="MeasDevDepts_deptDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MeasDevDepts_inputPersonDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MeasDevDepts_rate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCAUNITMEASDEV</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UnitMeasDev.UnitMeasDev_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MeasDevDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{UnitMeasDev.UnitMeasDev_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Devdepts"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MeasDevDepts_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDeptDevs">
<Global>^DHCCAUNITMEASDEV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UnitMeasDev.UnitMeasDev_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MeasDevDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DeptDevs"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MeasDevDepts_deptDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitMeasDev.UnitMeasDev_rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MeasDevDepts_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.MeasDevDeptsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
