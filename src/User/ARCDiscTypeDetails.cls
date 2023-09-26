/// ARC Discount Type Details(1309)
Class User.ARCDiscTypeDetails Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_DiscTypeDetails, StorageStrategy = SQLStorage ]
{

/// Childsub
Property DETChildsub As %Float [ InitialExpression = {$i(^ARC("ARCDI",$p(%d(0),$c(1)),"DET",0))}, SqlColumnNumber = 2, SqlFieldName = DET_Childsub ];

/// Date From
Property DETDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = DET_DateFrom ];

/// Date To
Property DETDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = DET_DateTo ];

/// Discount Type
Property DETDiscType As %String(DISPLAYLIST = ",Doctor Fee,Specialist Fee", MAXLEN = 14, TRUNCATE = 1, VALUELIST = ",D,S") [ SqlColumnNumber = 8, SqlFieldName = DET_DiscType ];

/// Fixed Amt
Property DETFixedAmt As %Float [ SqlColumnNumber = 6, SqlFieldName = DET_FixedAmt ];

/// Des Ref InsCoverSta
Property DETInsCoverDR As ARCInsurCoverStatus [ SqlColumnNumber = 9, SqlFieldName = DET_InsCover_DR ];

/// ARC_DiscType Parent Reference
Relationship DETParRef As ARCDiscType [ Cardinality = parent, Inverse = ChildARCDiscTypeDetails, Required, SqlFieldName = DET_ParRef ];

/// Patient Type
Property DETPatientType As %String(DISPLAYLIST = ",InPatient,OutPatient", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",I,O") [ SqlColumnNumber = 5, SqlFieldName = DET_PatientType ];

/// % Charge
Property DETPerc As %Float [ SqlColumnNumber = 7, SqlFieldName = DET_Perc ];

Index RowIDBasedIDKeyIndex On DETChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCDiscTypeDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCDiscTypeDetails","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCDiscTypeDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCDiscTypeDetails","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCDiscTypeDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCDiscTypeDetails","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCDiscTypeDetails).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCDiscTypeDetails","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCDiscTypeDetails).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCDiscTypeDetails","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DET_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DET_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DET_DiscType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DET_FixedAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DET_InsCover_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DET_PatientType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DET_Perc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_DiscType.ARCDI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ARCDI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_DiscType.ARCDI_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DET_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DET_RowId</SqlRowIdName>
<StreamLocation>^User.ARCDiscTypeDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
