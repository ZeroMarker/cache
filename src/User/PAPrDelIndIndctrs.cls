/// Delivery Induction Indicators
Class User.PAPrDelIndIndctrs Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PrDelIndIndctrs, StorageStrategy = SQLStorage ]
{

/// Childsub
Property PDIIChildsub As %Float [ InitialExpression = {$i(^PAPRG($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DEL",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"PDII",0))}, SqlColumnNumber = 2, SqlFieldName = PDII_Childsub ];

/// Des ref PAC_InductionIndicators
Property PDIIIndIndctrDR As PACInductionIndicators [ SqlColumnNumber = 3, SqlFieldName = PDII_IndIndctr_DR ];

/// PA_PregDelivery Parent Reference
Relationship PDIIParRef As PAPregDelivery [ Cardinality = parent, Inverse = ChildPAPrDelIndIndctrs, Required, SqlFieldName = PDII_ParRef ];

/// Sort order
Property PDIISortOrder As %Float [ SqlColumnNumber = 4, SqlFieldName = PDII_SortOrder ];

Index RowIDBasedIDKeyIndex On PDIIChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 4;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPrDelIndIndctrs).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelIndIndctrs","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPrDelIndIndctrs).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelIndIndctrs","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPrDelIndIndctrs).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelIndIndctrs","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPrDelIndIndctrs).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelIndIndctrs","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPrDelIndIndctrs).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelIndIndctrs","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="PDIIChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="PDIIIndIndctrDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PDIIParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="PDIISortOrder">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMasterMap">
<Data name="PDII_IndIndctr_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDII_SortOrder">
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
<Field>PDII_Childsub</Field>
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
<Expression>"PDII"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PDII_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInductionIndicatr">
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
<Field>PDII_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PDII_IndIndctr_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDII_IndIndctr_DR}</Expression>
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
<Expression>"PDII"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PDII_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDII_RowId</SqlRowIdName>
<StreamLocation>^User.PAPrDelIndIndctrsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
