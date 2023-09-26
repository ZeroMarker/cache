/// BLC Bill Sequence(1534)
Class User.BLCBillSequence Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_BillSequence, StorageStrategy = SQLStorage ]
{

/// Counter
Property SEQCounter As %Float [ SqlColumnNumber = 5, SqlFieldName = SEQ_Counter ];

/// Description
Property SEQDesc As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlComputeCode = { s {SEQ_Desc}=$$CO06^at1534({SEQ_Prefix},{SEQ_Suffix},{SEQ_Length},{SEQ_Counter})
}, SqlComputed, SqlFieldName = SEQ_Desc, Transient ];

/// Length
Property SEQLength As %Float [ Required, SqlColumnNumber = 4, SqlFieldName = SEQ_Length ];

/// Prefix
Property SEQPrefix As %String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SEQ_Prefix ];

/// Suffix
Property SEQSuffix As %String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SEQ_Suffix ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCBillSequence).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCBillSequence","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCBillSequence).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCBillSequence","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCBillSequence).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCBillSequence","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCBillSequence).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCBillSequence","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCBillSequence).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCBillSequence","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^BLC("BILLSEQ",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SEQ_Counter">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SEQ_Length">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SEQ_Prefix">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SEQ_Suffix">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^COUNT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SEQ_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BILLSEQ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SEQ_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SEQ_Rowid</SqlRowIdName>
<StreamLocation>^User.BLCBillSequenceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
