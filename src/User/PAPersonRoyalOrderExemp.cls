/// PersonRoyalOrderExemp(2608)
Class User.PAPersonRoyalOrderExemp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PersonRoyalOrderExemp, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On EXEMPChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_PersonRoyalOrder Parent Reference
Relationship EXEMPParRef As PAPersonRoyalOrder [ Cardinality = parent, Inverse = ChildPAPersonRoyalOrderExemp, Required, SqlFieldName = EXEMP_ParRef ];

/// Childsub
Property EXEMPChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"RO",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"EX",0))}, SqlColumnNumber = 2, SqlFieldName = EXEMP_Childsub ];

/// Des Ref BillGrp
Property EXEMPBillGrpDR As ARCBillGrp [ SqlColumnNumber = 3, SqlFieldName = EXEMP_BillGrp_DR ];

/// Des Ref BillSub
Property EXEMPBillSubDR As ARCBillSub [ SqlColumnNumber = 4, SqlFieldName = EXEMP_BillSub_DR ];

/// Des Ref ARCIM
Property EXEMPARCIMDR As ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = EXEMP_ARCIM_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPersonRoyalOrderExemp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonRoyalOrderExemp","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPersonRoyalOrderExemp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonRoyalOrderExemp","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPersonRoyalOrderExemp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonRoyalOrderExemp","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPersonRoyalOrderExemp).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonRoyalOrderExemp","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPersonRoyalOrderExemp).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonRoyalOrderExemp","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="EXEMP_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EXEMP_BillGrp_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EXEMP_BillSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_PersonRoyalOrder.ROYAL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>EXEMP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_PersonRoyalOrder.ROYAL_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"EX"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EXEMP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>EXEMP_RowId</SqlRowIdName>
<StreamLocation>^User.PAPersonRoyalOrderExempS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
