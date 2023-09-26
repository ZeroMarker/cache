/// Patient Employee (1058)
Class User.PAEmployee Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Employee, StorageStrategy = SQLStorage ]
{

/// Childsub
Property EPEChildsub As %Float [ InitialExpression = {$i(^PAPER($p(%d(0),$c(1)),"EPE",0))}, Required, SqlColumnNumber = 2, SqlFieldName = EPE_Childsub ];

/// Date of Discount From
Property EPEDateFrom As %Date [ SqlColumnNumber = 8, SqlFieldName = EPE_DateFrom ];

/// Date of Discount To
Property EPEDateTo As %Date [ SqlColumnNumber = 9, SqlFieldName = EPE_DateTo ];

/// Des Ref to Discount Type
Property EPEDiscTypeDR As ARCDiscType [ SqlColumnNumber = 10, SqlFieldName = EPE_DiscType_DR ];

/// Employee Number
Property EPEEmplNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = EPE_EmplNo ];

/// Des Ref to Employee Type
Property EPEEmplTypeDR As PACEmployeeType [ SqlColumnNumber = 4, SqlFieldName = EPE_EmplType_DR ];

/// Not Used (Department) Des Ref to CTEML
Property EPELocDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = EPE_Loc_DR ];

/// Des Ref to PAPER
Property EPEPAPERDR As PAPerson [ SqlColumnNumber = 3, SqlFieldName = EPE_PAPER_DR ];

/// PA_PatMas Parent Reference
Relationship EPEParRef As PAPatMas [ Cardinality = parent, Inverse = ChildPAEmployee, Required, SqlFieldName = EPE_ParRef ];

/// Des Ref to CTRelation
Property EPERelationDR As CTRelation [ SqlColumnNumber = 5, SqlFieldName = EPE_Relation_DR ];

Index RowIDBasedIDKeyIndex On EPEChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAEmployee).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAEmployee","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAEmployee).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAEmployee","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAEmployee).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAEmployee","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAEmployee).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAEmployee","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAEmployee).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAEmployee","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="EPE_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EPE_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EPE_DiscType_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EPE_EmplNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EPE_EmplType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EPE_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EPE_PAPER_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EPE_Relation_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>EPE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EPE_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>EPE_RowId</SqlRowIdName>
<StreamLocation>^User.PAEmployeeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
