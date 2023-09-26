/// Item Results(2166)
Class User.ARCItemResults Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemResults, StorageStrategy = SQLStorage ]
{

/// Childsub
Property RESChildsub As %Float [ InitialExpression = {$i(^ARCIM($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"RES",0))}, SqlColumnNumber = 2, SqlFieldName = RES_Childsub ];

/// ARC_ItmMast Parent Reference
Relationship RESParRef As ARCItmMast [ Cardinality = parent, Inverse = ChildARCItemResults, Required, SqlFieldName = RES_ParRef ];

/// Des Ref Test Code
Property RESTestCodeDR As CTTestCode [ SqlColumnNumber = 3, SqlFieldName = RES_TestCode_DR ];

Index RowIDBasedIDKeyIndex On RESChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 10;

Storage SQLStorage
{
<ExtentSize>10</ExtentSize>
<Property name="RESChildsub">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="RESParRef">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="RESTestCodeDR">
<Selectivity>11.1111%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="RES_TestCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^ARCIM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>RES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RES_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>RES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RES_TestCode_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RES_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemResultsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
