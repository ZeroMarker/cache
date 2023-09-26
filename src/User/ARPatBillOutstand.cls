/// AR Pat Bill Outstand(1757)
Class User.ARPatBillOutstand Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_PatBillOutstand, StorageStrategy = SQLStorage ]
{

/// Childsub
Property OUTSChildsub As %Float [ InitialExpression = {$i(^ARPBL($p(%d(0),$c(1)),"OUTS",0))}, SqlColumnNumber = 2, SqlFieldName = OUTS_Childsub ];

/// Comment Outstanding
Property OUTSCommentOuts As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = OUTS_CommentOuts ];

/// Department Outstanding
Property OUTSDepartOuts As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = OUTS_DepartOuts ];

/// es Ref DiscretOutsType_DR
Property OUTSDiscretOutsTypeDR As ARCDisretOutstType [ SqlColumnNumber = 4, SqlFieldName = OUTS_DiscretOutsType_DR ];

/// Empl Name Outstanding
Property OUTSEmplNameOuts As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = OUTS_EmplNameOuts ];

/// ExpectedPayDate
Property OUTSExpectedPayDate As %Date [ SqlColumnNumber = 8, SqlFieldName = OUTS_ExpectedPayDate ];

/// Outstand Amt
Property OUTSOutstandAmt As %Float [ SqlColumnNumber = 3, SqlFieldName = OUTS_OutstandAmt ];

/// AR_PatientBill Parent Reference
Relationship OUTSParRef As ARPatientBill [ Cardinality = parent, Inverse = ChildARPatBillOutstand, Required, SqlFieldName = OUTS_ParRef ];

Index RowIDBasedIDKeyIndex On OUTSChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 3;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARPatBillOutstand).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillOutstand","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARPatBillOutstand).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillOutstand","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARPatBillOutstand).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillOutstand","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARPatBillOutstand).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillOutstand","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARPatBillOutstand).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillOutstand","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="OUTSChildsub">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="OUTSCommentOuts">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="OUTSDepartOuts">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="OUTSDiscretOutsTypeDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="OUTSEmplNameOuts">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="OUTSExpectedPayDate">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="OUTSOutstandAmt">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="OUTSParRef">
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="OUTS_CommentOuts">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OUTS_DepartOuts">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OUTS_DiscretOutsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OUTS_EmplNameOuts">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OUTS_ExpectedPayDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OUTS_OutstandAmt">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^ARPBL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OUTS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OUTS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OUTS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OUTS_RowId</SqlRowIdName>
<StreamLocation>^User.ARPatBillOutstandS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
