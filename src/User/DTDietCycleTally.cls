/// Diet Cycle Tally(2224)
Class User.DTDietCycleTally Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DT_DietCycleTally, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM
Property TALLYARCIMDR As ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = TALLY_ARCIM_DR ];

/// Date
Property TALLYDate As %Date [ SqlColumnNumber = 3, SqlFieldName = TALLY_Date ];

/// Time
Property TALLYTime As %Time [ SqlColumnNumber = 4, SqlFieldName = TALLY_Time ];

/// Tally
Property TALLYTally As %Float [ SqlColumnNumber = 5, SqlFieldName = TALLY_Tally ];

/// Des Ref DTC DietCycle
Property TALLYDietCycleDR As DTCDietCycle [ SqlColumnNumber = 6, SqlFieldName = TALLY_DietCycle_DR ];

/// Des Ref Hospital
Property TALLYHospitalDR As CTHospital [ SqlColumnNumber = 7, SqlFieldName = TALLY_Hospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.DTDietCycleTally).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DTDietCycleTally","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.DTDietCycleTally).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DTDietCycleTally","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.DTDietCycleTally).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DTDietCycleTally","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.DTDietCycleTally).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DTDietCycleTally","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.DTDietCycleTally).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DTDietCycleTally","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DT("TALLY",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="TALLY_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TALLY_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TALLY_DietCycle_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TALLY_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TALLY_Tally">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TALLY_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TALLY_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TALLY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TALLY_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TALLY_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TALLY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TALLY_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TALLY_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TALLY_RowId</SqlRowIdName>
<StreamLocation>^User.DTDietCycleTallyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
