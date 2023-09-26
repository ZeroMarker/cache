/// Apgar scores
Class User.PAPrDelBabyApgarScore Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PrDelBabyApgarScore, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PDBASChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_PregDelBaby Parent Reference
Relationship PDBASParRef As PAPregDelBaby [ Cardinality = parent, Inverse = ChildPAPrDelBabyApgarScore, Required, SqlFieldName = PDBAS_ParRef ];

/// Childsub
Property PDBASChildsub As %Float [ InitialExpression = {$i(^PAPRG($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DEL",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"BABY",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"PDBAS",0))}, SqlColumnNumber = 2, SqlFieldName = PDBAS_Childsub ];

/// Apgar No
Property PDBASApgarNo As %Float [ SqlColumnNumber = 3, SqlFieldName = PDBAS_ApgarNo ];

/// Heart Rate
Property PDBASHeartRate As %Float [ SqlColumnNumber = 4, SqlFieldName = PDBAS_HeartRate ];

/// Respiration
Property PDBASRespiration As %Float [ SqlColumnNumber = 5, SqlFieldName = PDBAS_Respiration ];

/// Tone
Property PDBASTone As %Float [ SqlColumnNumber = 6, SqlFieldName = PDBAS_Tone ];

/// Reflex
Property PDBASReflex As %Float [ SqlColumnNumber = 7, SqlFieldName = PDBAS_Reflex ];

/// Colour
Property PDBASColour As %Float [ SqlColumnNumber = 8, SqlFieldName = PDBAS_Colour ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPrDelBabyApgarScore).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelBabyApgarScore","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPrDelBabyApgarScore).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelBabyApgarScore","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPrDelBabyApgarScore).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelBabyApgarScore","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPrDelBabyApgarScore).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelBabyApgarScore","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPrDelBabyApgarScore).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelBabyApgarScore","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="PDBAS_ApgarNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDBAS_Colour">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDBAS_HeartRate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDBAS_Reflex">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDBAS_Respiration">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDBAS_Tone">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PAPRG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PA_PregDelBaby.BABY_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>PDBAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PA_PregDelBaby.BABY_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"PDBAS"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{PDBAS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexApgarNo">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>PA_PregDelBaby.BABY_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L9}</Expression>
<Field>PDBAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PDBAS_ApgarNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDBAS_ApgarNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PA_PregDelBaby.BABY_Childsub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>"PDBAS"</Expression>
</Subscript>
<Subscript name="9">
<Expression>{PDBAS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDBAS_RowId</SqlRowIdName>
<StreamLocation>^User.PAPrDelBabyApgarScoreS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
