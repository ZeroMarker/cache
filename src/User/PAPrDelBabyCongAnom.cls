/// PrDelBabyCongAnom(2249)
Class User.PAPrDelBabyCongAnom Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PrDelBabyCongAnom, StorageStrategy = SQLStorage ]
{

/// Childsub
Property CAChildsub As %Float [ InitialExpression = {$i(^PAPRG($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DEL",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"BABY",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"CA",0))}, SqlColumnNumber = 2, SqlFieldName = CA_Childsub ];

/// Des Ref PAC_CongenitalAnomalies
Property CACongAnomDR As PACCongenitalAnomalies [ SqlColumnNumber = 3, SqlFieldName = CA_CongAnom_DR ];

/// PA_PregDelBaby Parent Reference
Relationship CAParRef As PAPregDelBaby [ Cardinality = parent, Inverse = ChildPAPrDelBabyCongAnom, Required, SqlFieldName = CA_ParRef ];

/// Sort Order
Property CASortOrder As %Float [ SqlColumnNumber = 4, SqlFieldName = CA_SortOrder ];

Index RowIDBasedIDKeyIndex On CAChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 4;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPrDelBabyCongAnom).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelBabyCongAnom","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPrDelBabyCongAnom).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelBabyCongAnom","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPrDelBabyCongAnom).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelBabyCongAnom","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPrDelBabyCongAnom).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelBabyCongAnom","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPrDelBabyCongAnom).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelBabyCongAnom","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="CAChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="CACongAnomDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CAParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="CASortOrder">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMasterMap">
<Data name="CA_CongAnom_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CA_SortOrder">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
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
<Field>CA_Childsub</Field>
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
<Expression>"CA"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{CA_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAnomaly">
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
<Field>CA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CA_CongAnom_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CA_CongAnom_DR}</Expression>
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
<Expression>"CA"</Expression>
</Subscript>
<Subscript name="9">
<Expression>{CA_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CA_RowId</SqlRowIdName>
<StreamLocation>^User.PAPrDelBabyCongAnomS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
