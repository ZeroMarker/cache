/// Korean ARPat Bill DateBillGrp(1439)
Class User.ARPatBillDateBillGrp Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_PatBillDateBillGrp, StorageStrategy = SQLStorage ]
{

/// Author Allowed Service Total
Property BGRPAAServiceTotal As %Float [ SqlColumnNumber = 3, SqlFieldName = BGRP_AAServiceTotal ];

/// Auth Allow Total
Property BGRPAATotal As %Float [ SqlColumnNumber = 4, SqlFieldName = BGRP_AATotal ];

/// Author Disallow Service Total
Property BGRPADServiceTotal As %Float [ SqlColumnNumber = 5, SqlFieldName = BGRP_ADServiceTotal ];

/// Author Disallow Total
Property BGRPADTotal As %Float [ SqlColumnNumber = 6, SqlFieldName = BGRP_ADTotal ];

/// Childsub
Property BGRPChildsub As %Float [ SqlColumnNumber = 2, SqlFieldName = BGRP_Childsub ];

/// AR_PatBillDate Parent Reference
Relationship BGRPParRef As ARPatBillDate [ Cardinality = parent, Inverse = ChildARPatBillDateBillGrp, Required, SqlFieldName = BGRP_ParRef ];

/// Specialist Surcharge
Property BGRPSpecSurcharge As %Float [ SqlColumnNumber = 7, SqlFieldName = BGRP_SpecSurcharge ];

Relationship ChildARPatBillDateBillGrpCharge As ARPatBillDateBillGrpCharges [ Cardinality = children, Inverse = ITMParRef ];

Index RowIDBasedIDKeyIndex On BGRPChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARPatBillDateBillGrp).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillDateBillGrp","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARPatBillDateBillGrp).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillDateBillGrp","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARPatBillDateBillGrp).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillDateBillGrp","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARPatBillDateBillGrp).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillDateBillGrp","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARPatBillDateBillGrp).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillDateBillGrp","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="BGRP_AAServiceTotal">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BGRP_AATotal">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BGRP_ADServiceTotal">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BGRP_ADTotal">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BGRP_SpecSurcharge">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^ARPBL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>AR_PatBillDate.DATE_Date</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>BGRP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_PatBillDate.DATE_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"BGRP"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BGRP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>BGRP_RowId</SqlRowIdName>
<StreamLocation>^User.ARPatBillDateBillGrpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
