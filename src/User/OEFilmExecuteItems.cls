/// FilmExecuteItems(2092)
Class User.OEFilmExecuteItems Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_FilmExecuteItems, StorageStrategy = SQLStorage ]
{

/// Childsub
Property ITMChildsub As %Float [ InitialExpression = {$i(^OEFE($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ITM",0))}, SqlColumnNumber = 2, SqlFieldName = ITM_Childsub ];

/// Des Ref OEFilmRejected
Property ITMOEFilmRejectedDR As OEFilmExecuteFilmsUsed [ SqlColumnNumber = 5, SqlFieldName = ITM_OEFilmRejected_DR ];

/// Des Ref OEFilmUse
Property ITMOEFilmUseDR As OEFilmExecuteFilmsUsed [ SqlColumnNumber = 4, SqlFieldName = ITM_OEFilmUse_DR ];

/// Des Ref OEORI
Property ITMOEORIDR As OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = ITM_OEORI_DR ];

/// OE_FilmExecute Parent Reference
Relationship ITMParRef As OEFilmExecute [ Cardinality = parent, Inverse = ChildOEFilmExecuteItems, Required, SqlFieldName = ITM_ParRef ];

Index RowIDBasedIDKeyIndex On ITMChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1139;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEFilmExecuteItems).OnTrigger($g(%d(1)))
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEFilmExecuteItems).OnTrigger($g(%d(1)))
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEFilmExecuteItems).OnTrigger($g(%d(1)))
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEFilmExecuteItems).getOld($g(%d(1)))
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEFilmExecuteItems).getOld($g(%d(1)))
}

Storage SQLStorage
{
<ExtentSize>1139</ExtentSize>
<Property name="ITMChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="ITMOEFilmRejectedDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ITMOEFilmUseDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ITMOEORIDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ITMParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ITM_OEFilmRejected_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ITM_OEFilmUse_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ITM_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^OEFE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_FilmExecute.OEFE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OE_FilmExecute.OEFE_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ITM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^OEFE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_FilmExecute.OEFE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ITM_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_FilmExecute.OEFE_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ITM_RowId</SqlRowIdName>
<StreamLocation>^User.OEFilmExecuteItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
