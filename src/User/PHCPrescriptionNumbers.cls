/// Prescription Numbers
Class User.PHCPrescriptionNumbers Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PHC_PrescriptionNumbers, StorageStrategy = SQLStorage ]
{

/// Rowid
Property PRESCDate As %Date [ InitialExpression = {$i(^mdata(1384))}, Required, SqlFieldName = PRESC_Date ];

/// The Prescription number counter for the day
Property PRESCNumber As %Float [ SqlColumnNumber = 2, SqlFieldName = PRESC_Number ];

Index RowIDBasedIDKeyIndex On PRESCDate [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 305;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCPrescriptionNumbers).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCPrescriptionNumbers","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCPrescriptionNumbers).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCPrescriptionNumbers","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCPrescriptionNumbers).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCPrescriptionNumbers","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCPrescriptionNumbers).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCPrescriptionNumbers","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCPrescriptionNumbers).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCPrescriptionNumbers","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>305</ExtentSize>
<Property name="PRESCDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="PRESCNumber">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PRESC)</SqlIdExpression>
<SQLMap name="master">
<Data name="PRESC_Number">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PRESC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PRESC_Date</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PRESC_Date}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PRESC_Date</SqlRowIdName>
<StreamLocation>^User.PHCPrescriptionNumbersS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
