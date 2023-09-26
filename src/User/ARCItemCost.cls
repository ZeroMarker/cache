/// ARC Item Cost(1407)
Class User.ARCItemCost Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemCost, StorageStrategy = SQLStorage ]
{

/// Childsub
Property ITCOSTChildsub As %Float [ InitialExpression = {$i(^ARCIM($p(%d(0),"||"),$p(%d(0),"||",2),"ITCOST",0))}, SqlColumnNumber = 2, SqlFieldName = ITCOST_Childsub ];

/// Cost
Property ITCOSTCost As %Float [ Required, SqlColumnNumber = 5, SqlFieldName = ITCOST_Cost ];

/// Date From
Property ITCOSTDateFrom As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = ITCOST_DateFrom ];

/// Date To
Property ITCOSTDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = ITCOST_DateTo ];

/// Doctor %
Property ITCOSTDoctorPerc As %Float [ SqlColumnNumber = 6, SqlFieldName = ITCOST_DoctorPerc ];

/// ARC_ItmMast Parent Reference
Relationship ITCOSTParRef As ARCItmMast [ Cardinality = parent, Inverse = ChildARCItemCost, Required, SqlFieldName = ITCOST_ParRef ];

Index RowIDBasedIDKeyIndex On ITCOSTChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 6;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemCost).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemCost","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemCost).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemCost","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemCost).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemCost","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemCost).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemCost","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemCost).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemCost","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>6</ExtentSize>
<Property name="ITCOSTChildsub">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ITCOSTCost">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ITCOSTDateFrom">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="ITCOSTDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ITCOSTDoctorPerc">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ITCOSTParRef">
<Selectivity>16.6667%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ITCOST_Cost">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ITCOST_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ITCOST_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ITCOST_DoctorPerc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
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
<Field>ITCOST_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ITCOST"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ITCOST_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ITCOST_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemCostS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
