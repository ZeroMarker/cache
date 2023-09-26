/// PAC WL Type of list criteria(1571
Class User.PACWLTypeOfListCriteria Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_WLTypeOfListCriteria, StorageStrategy = SQLStorage ]
{

/// Childsub
Property CRITChildsub As %Float [ InitialExpression = {$i(^PAC("WLT",$p(%d(0),$c(1)),"CRIT",0))}, SqlColumnNumber = 2, SqlFieldName = CRIT_Childsub ];

/// Eff Date
Property CRITEffDate As %Date [ SqlColumnNumber = 3, SqlFieldName = CRIT_EffDate ];

/// Of List Criteria
Property CRITOfListCriteria As %String(DISPLAYLIST = ",On Discharge,On Registration,On Operation Entry", MAXLEN = 18, TRUNCATE = 1, VALUELIST = ",D,R,E") [ SqlColumnNumber = 4, SqlFieldName = CRIT_OfListCriteria ];

/// PAC_WaitingListType Parent Reference
Relationship CRITParREf As PACWaitingListType [ Cardinality = parent, Inverse = ChildPACWLTypeOfListCriteria, Required, SqlFieldName = CRIT_ParREf ];

Index RowIDBasedIDKeyIndex On CRITChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 10;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACWLTypeOfListCriteria).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWLTypeOfListCriteria","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACWLTypeOfListCriteria).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWLTypeOfListCriteria","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACWLTypeOfListCriteria).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWLTypeOfListCriteria","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACWLTypeOfListCriteria).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWLTypeOfListCriteria","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACWLTypeOfListCriteria).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWLTypeOfListCriteria","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>10</ExtentSize>
<Property name="CRITChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="CRITEffDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="CRITOfListCriteria">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="CRITParREf">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="CRIT_EffDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CRIT_OfListCriteria">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_WaitingListType.WLT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CRIT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_WaitingListType.WLT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CRIT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CRIT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_WaitingListType.WLT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>CRIT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_WaitingListType.WLT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CRIT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CRIT_EffDate}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{CRIT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CRIT_RowId</SqlRowIdName>
<StreamLocation>^User.PACWLTypeOfListCriteriaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
