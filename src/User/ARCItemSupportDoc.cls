/// ARCIM Support Docum(1116)
Class User.ARCItemSupportDoc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemSupportDoc, StorageStrategy = SQLStorage ]
{

/// Des Ref to ArcSupDoc
Property SUPDArcSupDocDR As ARCSupportDocument [ Required, SqlColumnNumber = 3, SqlFieldName = SUPD_ArcSupDoc_DR ];

/// Des Ref CTLOC
Property SUPDCTLOCDR As CTLoc [ SqlColumnNumber = 7, SqlFieldName = SUPD_CTLOC_DR ];

/// Childsub
Property SUPDChildsub As %Float [ InitialExpression = {$i(^ARCIM($p(%d(0),"||"),$p(%d(0),"||",2),"SUPD",0))}, SqlColumnNumber = 2, SqlFieldName = SUPD_Childsub ];

/// Eff. Date From
Property SUPDDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = SUPD_DateFrom ];

/// Eff. Date To
Property SUPDDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = SUPD_DateTo ];

/// Des Ref to ARCInsType
Property SUPDInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 4, SqlFieldName = SUPD_InsType_DR ];

/// ARC_ItmMast Parent Reference
Relationship SUPDParRef As ARCItmMast [ Cardinality = parent, Inverse = ChildARCItemSupportDoc, Required, SqlFieldName = SUPD_ParRef ];

Index RowIDBasedIDKeyIndex On SUPDChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemSupportDoc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemSupportDoc","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemSupportDoc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemSupportDoc","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemSupportDoc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemSupportDoc","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemSupportDoc).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemSupportDoc","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemSupportDoc).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemSupportDoc","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="SUPDArcSupDocDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SUPDCTLOCDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SUPDChildsub">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SUPDDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SUPDDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SUPDInsTypeDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SUPDParRef">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="SUPD_ArcSupDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SUPD_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SUPD_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SUPD_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SUPD_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
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
<Field>SUPD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SUPD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SUPD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SUPD_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemSupportDocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
