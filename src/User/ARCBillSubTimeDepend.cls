/// ARC Bill Sub Time Dependent(1193)
Class User.ARCBillSubTimeDepend Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_BillSubTimeDepend, StorageStrategy = SQLStorage ]
{

/// Childsub
Property TIMEChildsub As %Float [ InitialExpression = {$i(^ARCBG($p(%d(0),"||"),"SG",$p(%d(0),"||",2),"TIME",0))}, SqlColumnNumber = 2, SqlFieldName = TIME_Childsub ];

/// Day Of Week From
Property TIMEDOWFrom As CTDayOfWeek [ SqlColumnNumber = 7, SqlFieldName = TIME_DOWFrom ];

/// Day Of Week To
Property TIMEDOWTo As CTDayOfWeek [ SqlColumnNumber = 8, SqlFieldName = TIME_DOWTo ];

/// Date From
Property TIMEDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = TIME_DateFrom ];

/// Date To
Property TIMEDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = TIME_DateTo ];

/// Fixed Amt
Property TIMEFixedAmt As %Float [ SqlColumnNumber = 10, SqlFieldName = TIME_FixedAmt ];

/// ARC_BillSub Parent Reference
Relationship TIMEParRef As ARCBillSub [ Cardinality = parent, Inverse = ChildARCBillSubTimeDepend, Required, SqlFieldName = TIME_ParRef ];

/// % Charge
Property TIMEPerc As %Float [ SqlColumnNumber = 9, SqlFieldName = TIME_Perc ];

/// Time From
Property TIMETimeFrom As %Time [ SqlColumnNumber = 5, SqlFieldName = TIME_TimeFrom ];

/// Time To
Property TIMETimeTo As %Time [ SqlColumnNumber = 6, SqlFieldName = TIME_TimeTo ];

/// Visit Type
Property TIMEVisitType As %String(DISPLAYLIST = ",Normal,First Visit,Second and Other", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",N,F,S") [ SqlColumnNumber = 11, SqlFieldName = TIME_VisitType ];

Index RowIDBasedIDKeyIndex On TIMEChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCBillSubTimeDepend).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillSubTimeDepend","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCBillSubTimeDepend).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillSubTimeDepend","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCBillSubTimeDepend).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillSubTimeDepend","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCBillSubTimeDepend).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillSubTimeDepend","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCBillSubTimeDepend).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillSubTimeDepend","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="TIME_DOWFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TIME_DOWTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TIME_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TIME_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TIME_FixedAmt">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TIME_Perc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TIME_TimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TIME_TimeTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TIME_VisitType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^ARCBG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_BillGrp.ARCBG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ARC_BillSub.ARCSG_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>TIME_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_BillGrp.ARCBG_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARC_BillSub.ARCSG_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"TIME"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TIME_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>TIME_RowId</SqlRowIdName>
<StreamLocation>^User.ARCBillSubTimeDependS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
