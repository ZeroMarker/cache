/// INC Item Batch          (INCIB,434)
Class User.INCItmBat Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = INC_ItmBat, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On INCIBChildSub [ IdKey, PrimaryKey, Unique ];

/// INCI Par Ref
Relationship INCIBINCIParRef As INCItm [ Cardinality = parent, Inverse = ChildINCItmBat, Required, SqlFieldName = INCIB_INCI_ParRef ];

/// INCIB ChildSub (New Key)
Property INCIBChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^INCI($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"IB",0))}, SqlColumnNumber = 2, SqlFieldName = INCIB_ChildSub ];

/// Manufactory Batch No
Property INCIBNo As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = INCIB_No ];

/// Recall Flag
Property INCIBRecallFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 5, SqlFieldName = INCIB_RecallFlag ];

/// Remarks
Property INCIBRemarks As list Of %String(COLLATION = "AlphaUp", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = INCIB_Remarks, SqlListType = SUBNODE ];

/// Expiry Date
Property INCIBExpDate As %Date [ SqlColumnNumber = 9, SqlFieldName = INCIB_ExpDate ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INCItmBat).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmBat","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INCItmBat).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmBat","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INCItmBat).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmBat","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INCItmBat).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmBat","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmBat","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INCItmBat).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmBat","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterINCIB">
<Data name="INCIB_ExpDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INCIB_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCIB_RecallFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INCIB_Remarks">
<Node>"REM"</Node>
</Data>
<Global>^INCI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INCIB_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INC_Itm.INCI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"IB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INCIB_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBatchNo">
<Condition>{INCIB_No}'=""</Condition>
<ConditionFields>INCIB_No,INCIB_ExpDate</ConditionFields>
<Global>^INCI</Global>
<PopulationPct>5</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>INCIB_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"IB_NO"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INCIB_No})</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INCIB_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExp">
<Condition>{INCIB_ExpDate}'=""</Condition>
<ConditionFields>INCIB_ExpDate</ConditionFields>
<Global>^INCI</Global>
<PopulationPct>30</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>INCIB_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"IB_EX"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{INCIB_ExpDate}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INCIB_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNoExpDate">
<Condition>{INCIB_No}'="",{INCIB_ExpDate}'=""</Condition>
<ConditionFields>INCIB_ExpDate,INCIB_No</ConditionFields>
<Global>^INCI</Global>
<PopulationPct>90</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INCIB_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"IB_NoX"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{INCIB_ExpDate}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INCIB_No}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INCIB_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INCIB_RowId</SqlRowIdName>
<StreamLocation>^User.INCItmBatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
