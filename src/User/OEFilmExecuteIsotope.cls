/// FilmExecuteIsotope(2094)
Class User.OEFilmExecuteIsotope Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_FilmExecuteIsotope, StorageStrategy = SQLStorage ]
{

/// Childsub
Property ISChildsub As %Float [ InitialExpression = {$i(^OEFE($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"IS",0))}, SqlColumnNumber = 2, SqlFieldName = IS_Childsub ];

/// Isotope Dose
Property ISIsotopeDose As %Float [ SqlColumnNumber = 3, SqlFieldName = IS_IsotopeDose ];

/// OE_FilmExecute Parent Reference
Relationship ISParRef As OEFilmExecute [ Cardinality = parent, Inverse = ChildOEFilmExecuteIsotope, Required, SqlFieldName = IS_ParRef ];

/// Des Ref Radio Pharmaceutical
Property ISRadioPharmaceuticalDR As OECRadioPharmaceutical [ SqlColumnNumber = 4, SqlFieldName = IS_RadioPharmaceutical_DR ];

Index RowIDBasedIDKeyIndex On ISChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 5;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEFilmExecuteIsotope).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEFilmExecuteIsotope","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEFilmExecuteIsotope).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEFilmExecuteIsotope","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEFilmExecuteIsotope).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEFilmExecuteIsotope","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEFilmExecuteIsotope).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEFilmExecuteIsotope","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEFilmExecuteIsotope).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEFilmExecuteIsotope","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>5</ExtentSize>
<Property name="ISChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="ISIsotopeDose">
<Selectivity>1</Selectivity>
</Property>
<Property name="ISParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="ISRadioPharmaceuticalDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="IS_IsotopeDose">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IS_RadioPharmaceutical_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^OEFE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_FilmExecute.OEFE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>IS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OE_FilmExecute.OEFE_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>IS_RowId</SqlRowIdName>
<StreamLocation>^User.OEFilmExecuteIsotopeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
