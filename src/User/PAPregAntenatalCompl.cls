/// Antenatal Complications
Class User.PAPregAntenatalCompl Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PregAntenatalCompl, StorageStrategy = SQLStorage ]
{

/// Des Ref PA_Adm
Property PANCAdmDR As PAAdm [ SqlColumnNumber = 3, SqlFieldName = PANC_Adm_DR ];

/// Childsub
Property PANCChildsub As %Float [ InitialExpression = {$i(^PAPRG($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PANC",0))}, SqlColumnNumber = 2, SqlFieldName = PANC_Childsub ];

/// Des Ref PAC_PrenatalProblems
Property PANCComplicationDR As PACPrenatalProblems [ SqlColumnNumber = 4, SqlFieldName = PANC_Complication_DR ];

/// PA_Pregnancy Parent Reference
Relationship PANCParRef As PAPregnancy [ Cardinality = parent, Inverse = ChildPAPregAntenatalCompl, Required, SqlFieldName = PANC_ParRef ];

/// Sort Order
Property PANCSortOrder As %Float [ SqlColumnNumber = 5, SqlFieldName = PANC_SortOrder ];

Index RowIDBasedIDKeyIndex On PANCChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPrDelPlacAnomalies).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelPlacAnomalies","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPrDelPlacAnomalies).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelPlacAnomalies","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPrDelPlacAnomalies).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelPlacAnomalies","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPrDelPlacAnomalies).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelPlacAnomalies","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPrDelPlacAnomalies).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelPlacAnomalies","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterIndex">
<Data name="PANC_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PANC_Complication_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PANC_SortOrder">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAPRG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PANC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"PANC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PANC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmDR">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PANC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PANC_Adm_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PANC_Adm_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"PANC"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PANC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexComplication">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PANC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PANC_Complication_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PANC_Complication_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"PANC"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PANC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PANC_RowId</SqlRowIdName>
<StreamLocation>^User.PAPregAntenatalComplS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
