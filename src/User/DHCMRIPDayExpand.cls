/// d ##class(User.DHCMRIPDayExpand).%BuildIndices()
Class User.DHCMRIPDayExpand Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, StorageStrategy = SQLStorage ]
{

/// MRIPExpand_MRIPDayDr
Property MRIPExpMRIPDayDr As DHCMRIPDay [ SqlColumnNumber = 2, SqlFieldName = MRIPExp_MRIPDayDr ];

/// MRIPExpand_Code
Property MRIPExpCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MRIPExp_Code ];

/// MRIPExpand_Desc
Property MRIPExpDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MRIPExp_Desc ];

/// MRIPExpand_Value
Property MRIPExpValue As %Float [ SqlColumnNumber = 5, SqlFieldName = MRIPExp_Value ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^MRIPdailyExp)</SqlIdExpression>
<SQLMap name="INDEXMRIPCODE">
<Global>^MRIPdailyExp</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{MRIPExp_Ro</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"MRIPDayDRCODE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRIPExp_MRIPDayDr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MRIPExp_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRIPExp_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXMRIPDayDR">
<Global>^MRIPdailyExp</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>{MRIPExp_Ro</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MRIPDayDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRIPExp_MRIPDayDr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MRIPExp_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MASTERDHCMRIPDayExpand">
<Data name="MRIPExp_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MRIPExp_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MRIPExp_MRIPDayDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRIPExp_Value">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^MRIPdailyExp</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MRIPExp_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MRIPExp_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MRIPExp_RowID</SqlRowIdName>
<StreamLocation>^User.DHCMRIPDayExpandS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
