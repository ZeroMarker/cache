/// ARC Bill Sub Age Dependent(1194)
Class User.ARCBillSubAgeDepend Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_BillSubAgeDepend, StorageStrategy = SQLStorage ]
{

/// Age From
Property AGEAgeFrom As %Float [ SqlColumnNumber = 5, SqlFieldName = AGE_AgeFrom ];

/// Age To
Property AGEAgeTo As %Float [ SqlColumnNumber = 6, SqlFieldName = AGE_AgeTo ];

/// Childsub
Property AGEChildsub As %Float [ InitialExpression = {$i(^ARCBG($p(%d(0),"||"),"SG",$p(%d(0),"||",2),"AGE",0))}, SqlColumnNumber = 2, SqlFieldName = AGE_Childsub ];

/// Date From
Property AGEDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = AGE_DateFrom ];

/// Date To
Property AGEDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = AGE_DateTo ];

/// Fixed Amt
Property AGEFixedAmt As %Float [ SqlColumnNumber = 8, SqlFieldName = AGE_FixedAmt ];

/// Injection
Property AGEInjection As %String(DISPLAYLIST = ",Normal,IV,Non IV", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",N,I,NI") [ SqlColumnNumber = 10, SqlFieldName = AGE_Injection ];

/// ARC_BillSub Parent Reference
Relationship AGEParRef As ARCBillSub [ Cardinality = parent, Inverse = ChildARCBillSubAgeDepend, Required, SqlFieldName = AGE_ParRef ];

/// % Charge
Property AGEPerc As %Float [ SqlColumnNumber = 7, SqlFieldName = AGE_Perc ];

/// Visit Type
Property AGEVisitType As %String(DISPLAYLIST = ",Normal,First Visit,Second and Other", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",N,F,S") [ SqlColumnNumber = 9, SqlFieldName = AGE_VisitType ];

Index RowIDBasedIDKeyIndex On AGEChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCBillSubAgeDepend).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillSubAgeDepend","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCBillSubAgeDepend).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillSubAgeDepend","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCBillSubAgeDepend).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillSubAgeDepend","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCBillSubAgeDepend).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillSubAgeDepend","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCBillSubAgeDepend).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillSubAgeDepend","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AGE_AgeFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AGE_AgeTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AGE_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AGE_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AGE_FixedAmt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AGE_Injection">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AGE_Perc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AGE_VisitType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
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
<Field>AGE_Childsub</Field>
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
<Expression>"AGE"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AGE_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>AGE_RowId</SqlRowIdName>
<StreamLocation>^User.ARCBillSubAgeDependS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
