Class dhc.ca.cache.data.InnerDeptControl Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InnerDeptControl_rowid, SqlTableName = InnerDeptControl, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// InnerDeptControl_oldDeptDr
Property InnerDeptControloldDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 2, SqlFieldName = InnerDeptControl_oldDeptDr ];

/// InnerDeptControl_newDeptDr
Property InnerDeptControlnewDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 3, SqlFieldName = InnerDeptControl_newDeptDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAINNERDEPTCONTROL(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="InnerDeptControl_newDeptDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="InnerDeptControl_oldDeptDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCAINNERDEPTCONTROL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InnerDeptControl_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InnerDeptControl_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOldDept">
<Global>^DHCCAINNERDEPTCONTROL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InnerDeptControl_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OldDept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InnerDeptControl_oldDeptDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InnerDeptControl_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InnerDeptControlS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
