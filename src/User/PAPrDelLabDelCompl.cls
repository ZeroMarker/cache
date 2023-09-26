/// Labour & Del Complications(2268)
Class User.PAPrDelLabDelCompl Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PrDelLabDelCompl, StorageStrategy = SQLStorage ]
{

/// Childsub
Property PDLDCChildsub As %Float [ InitialExpression = {$i(^PAPRG($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DEL",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"PDLDC",0))}, SqlColumnNumber = 2, SqlFieldName = PDLDC_Childsub ];

/// Des ref Pac_LabDelComplications
Property PDLDCComplicationDR As PACLabDelComplications [ SqlColumnNumber = 3, SqlFieldName = PDLDC_Complication_DR ];

/// PA_PregDelivery Parent Reference
Relationship PDLDCParRef As PAPregDelivery [ Cardinality = parent, Inverse = ChildPAPrDelLabDelCompl, Required, SqlFieldName = PDLDC_ParRef ];

/// Sort order
Property PDLDCSortOrder As %Float [ SqlColumnNumber = 4, SqlFieldName = PDLDC_SortOrder ];

Index RowIDBasedIDKeyIndex On PDLDCChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 3;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPrDelLabDelCompl).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelLabDelCompl","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPrDelLabDelCompl).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelLabDelCompl","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPrDelLabDelCompl).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelLabDelCompl","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPrDelLabDelCompl).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelLabDelCompl","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPrDelLabDelCompl).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelLabDelCompl","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="PDLDCChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="PDLDCComplicationDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PDLDCParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="PDLDCSortOrder">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMasterMap">
<Data name="PDLDC_Complication_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDLDC_SortOrder">
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
<Field>PDLDC_Childsub</Field>
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
<Expression>"PDLDC"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PDLDC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
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
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>PDLDC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PDLDC_Complication_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDLDC_Complication_DR}</Expression>
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
<Expression>"PDLDC"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PDLDC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDLDC_RowId</SqlRowIdName>
<StreamLocation>^User.PAPrDelLabDelComplS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
