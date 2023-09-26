/// Anaesthesia Agent(1011)
Class User.ORAnaestAgent Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OR_Anaest_Agent, StorageStrategy = SQLStorage ]
{

/// Agent Des Ref to ORCANAGN
Property ANAGNAgentDR As ORCAnaestAgent [ Required, SqlColumnNumber = 3, SqlFieldName = ANAGN_Agent_DR ];

/// Bill Flag1
Property ANAGNBillFlag1 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ANAGN_BillFlag1 ];

/// Bill Flag2
Property ANAGNBillFlag2 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ANAGN_BillFlag2 ];

/// ChildSub
Property ANAGNChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^OR($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"ANA",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"AGN",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ANAGN_ChildSub ];

/// Des Ref Method
Property ANAGNMethodDR As ORCAnaestMethod [ SqlColumnNumber = 4, SqlFieldName = ANAGN_Method_DR ];

/// OR_Anaesthesia Parent Reference
Relationship ANAParRef As ORAnaesthesia [ Cardinality = parent, Inverse = ChildORAnaestAgent, Required, SqlFieldName = ANA_Par_Ref ];

Index RowIDBasedIDKeyIndex On ANAGNChildSub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 10;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ORAnaestAgent).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaestAgent","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ORAnaestAgent).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaestAgent","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ORAnaestAgent).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaestAgent","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ORAnaestAgent).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaestAgent","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ORAnaestAgent).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaestAgent","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>10</ExtentSize>
<Property name="ANAGNAgentDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANAGNBillFlag1">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ANAGNBillFlag2">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ANAGNChildSub">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANAGNMethodDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANAParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ANAGN_Agent_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANAGN_BillFlag1">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANAGN_BillFlag2">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ANAGN_Method_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^OR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OR_Anaesthesia.ANA_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ANAGN_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ANA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OR_Anaesthesia.ANA_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"AGN"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANAGN_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ANAGN_RowId</SqlRowIdName>
<StreamLocation>^User.ORAnaestAgentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
