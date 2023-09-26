/// PersonConsultSetConsR(2730)
Class User.PAPersonConsultSetConsR Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PersonConsultSetConsR, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CONSRChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_PersonConsultSetCons Parent Reference
Relationship CONSRParRef As PAPersonConsultSetCons [ Cardinality = parent, Inverse = ChildPAPersonConsultSetConsR, Required, SqlFieldName = CONSR_ParRef ];

/// Childsub
Property CONSRChildsub As %Float [ InitialExpression = {$i(^PA("CONS",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"CONSET",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"CONS",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"R",0))}, SqlColumnNumber = 2, SqlFieldName = CONSR_Childsub ];

/// Des Ref Order
Property CONSROrderDR As OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = CONSR_Order_DR ];

/// Des Ref DischSum
Property CONSRDischSumDR As PAAdm2DischargeSummary [ SqlColumnNumber = 4, SqlFieldName = CONSR_DischSum_DR ];

/// CreateDate
Property CONSRCreateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = CONSR_CreateDate ];

/// CreateTime
Property CONSRCreateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = CONSR_CreateTime ];

/// Des Ref CreateUser
Property CONSRCreateUserDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = CONSR_CreateUser_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAPersonConsultSetConsR).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonConsultSetConsR","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAPersonConsultSetConsR).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonConsultSetConsR","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAPersonConsultSetConsR).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonConsultSetConsR","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAPersonConsultSetConsR).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonConsultSetConsR","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonConsultSetConsR","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAPersonConsultSetConsR).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonConsultSetConsR","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CONSR_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CONSR_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CONSR_CreateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CONSR_DischSum_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CONSR_Order_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PA</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_Consult.CONS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PA_PersonConsultSet.CONSET_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>PA_PersonConsultSetCons.CONS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>CONSR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_Consult.CONS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CONSET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_PersonConsultSet.CONSET_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PA_PersonConsultSetCons.CONS_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"R"</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="8">
<Expression>{CONSR_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CONSR_RowId</SqlRowIdName>
<StreamLocation>^User.PAPersonConsultSetConsRS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
