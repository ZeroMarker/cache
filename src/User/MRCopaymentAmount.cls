/// CopaymentAmount(2326)
Class User.MRCopaymentAmount Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_CopaymentAmount, StorageStrategy = SQLStorage ]
{

/// Amount
Property COPAmount As %Float [ SqlColumnNumber = 5, SqlFieldName = COP_Amount ];

/// Childsub
Property COPChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"COP",0))}, SqlColumnNumber = 2, SqlFieldName = COP_Childsub ];

/// Des Ref DRGClass1
Property COPDRGClass1DR As BLCDRGClass1 [ SqlColumnNumber = 3, SqlFieldName = COP_DRGClass1_DR ];

/// Des Ref DRGClass2
Property COPDRGClass2DR As BLCDRGClass2 [ SqlColumnNumber = 4, SqlFieldName = COP_DRGClass2_DR ];

/// MR_Adm Parent Reference
Relationship COPParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRCopaymentAmount, Required, SqlFieldName = COP_ParRef ];

Index RowIDBasedIDKeyIndex On COPChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCopaymentAmount).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCopaymentAmount","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCopaymentAmount).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCopaymentAmount","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCopaymentAmount).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCopaymentAmount","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCopaymentAmount).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCopaymentAmount","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCopaymentAmount).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCopaymentAmount","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="COP_Amount">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="COP_DRGClass1_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="COP_DRGClass2_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>COP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"COP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{COP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>COP_RowId</SqlRowIdName>
<StreamLocation>^User.MRCopaymentAmountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
