/// ARC Item Specimen(1888)
Class User.ARCItemSpecimen Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemSpecimen, StorageStrategy = SQLStorage ]
{

/// Childsub
Property SPECChildsub As %Float [ InitialExpression = {$i(^ARCIM($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"SPEC",0))}, SqlColumnNumber = 2, SqlFieldName = SPEC_Childsub ];

/// Default
Property SPECDefault As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SPEC_Default ];

/// ARC_ItmMast Parent Reference
Relationship SPECParRef As ARCItmMast [ Cardinality = parent, Inverse = ChildARCItemSpecimen, Required, SqlFieldName = SPEC_ParRef ];

/// Des Ref Specimen
Property SPECSpecimenDR As CTSpecimen [ SqlColumnNumber = 3, SqlFieldName = SPEC_Specimen_DR ];

Index RowIDBasedIDKeyIndex On SPECChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 79;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemSpecimen).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemSpecimen","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemSpecimen).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemSpecimen","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemSpecimen).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemSpecimen","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemSpecimen).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemSpecimen","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemSpecimen).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemSpecimen","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>79</ExtentSize>
<Property name="SPECChildsub">
<Selectivity>7.1429%</Selectivity>
</Property>
<Property name="SPECDefault">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SPECParRef">
<Selectivity>1.8519%</Selectivity>
</Property>
<Property name="SPECSpecimenDR">
<Selectivity>4.1667%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="SPEC_Default">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SPEC_Specimen_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
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
<Field>SPEC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SPEC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SPEC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SPEC_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemSpecimenS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
