/// Admission Priority(1483)
Class User.PAAdmPriority Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmPriority, StorageStrategy = SQLStorage ]
{

/// Childsub
Property PRIChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PRI",0))}, SqlColumnNumber = 2, SqlFieldName = PRI_Childsub ];

/// Date
Property PRIDate As %Date [ SqlColumnNumber = 3, SqlFieldName = PRI_Date ];

/// PA_Adm Parent Reference
Relationship PRIParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmPriority, Required, SqlFieldName = PRI_ParRef ];

/// Des Ref Priority
Property PRIPriorityDR As CTAcuity [ SqlColumnNumber = 5, SqlFieldName = PRI_Priority_DR ];

/// Time
Property PRITime As %Time [ SqlColumnNumber = 4, SqlFieldName = PRI_Time ];

/// Des Ref User
Property PRIUserDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = PRI_User_DR ];

Index RowIDBasedIDKeyIndex On PRIChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 578;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmPriority).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmPriority","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmPriority).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmPriority","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmPriority).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmPriority","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmPriority).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmPriority","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmPriority).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmPriority","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>578</ExtentSize>
<Property name="PRIChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="PRIDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="PRIParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="PRIPriorityDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PRITime">
<Selectivity>1</Selectivity>
</Property>
<Property name="PRIUserDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="PRI_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PRI_Priority_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PRI_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PRI_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PRI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PRI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PRI_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmPriorityS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
