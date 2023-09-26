/// AR PatientBill Billing Group(1284)
Class User.ARPatBillGroup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_PatBillGroup, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On BGRPChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildARPatBillGroupCharges As ARPatBillGroupCharges [ Cardinality = children, Inverse = ITMParRef ];

/// AR_PatientBill Parent Reference
Relationship BGRPParRef As ARPatientBill [ Cardinality = parent, Inverse = ChildARPatBillGroup, Required, SqlFieldName = BGRP_ParRef ];

/// Des Ref to BillSubGroup
Property BGRPBillGroupDR As ARCBillSub [ Required, SqlColumnNumber = 2, SqlFieldName = BGRP_BillGroup_DR ];

/// Author Allowed Total
Property BGRPAATotal As %Float [ SqlColumnNumber = 3, SqlFieldName = BGRP_AATotal ];

/// Author Disallowed Total
Property BGRPADTotal As %Float [ SqlColumnNumber = 4, SqlFieldName = BGRP_ADTotal ];

/// Specialist Surcharge
Property BGRPSpecSurcharge As %Float [ SqlColumnNumber = 5, SqlFieldName = BGRP_SpecSurcharge ];

/// Childsub
Property BGRPChildsub As %Float [ InitialExpression = {$i(^ARPBL($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"BGRP",0))}, SqlColumnNumber = 6, SqlFieldName = BGRP_Childsub ];

/// Authorised Allowed Service Total
Property BGRPAAServiceTotal As %Float [ SqlColumnNumber = 7, SqlFieldName = BGRP_AAServiceTotal ];

/// Authorised Disalllowed Service Total
Property BGRPADServiceTotal As %Float [ SqlColumnNumber = 8, SqlFieldName = BGRP_ADServiceTotal ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARPatBillGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillGroup","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARPatBillGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillGroup","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARPatBillGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillGroup","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARPatBillGroup).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillGroup","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARPatBillGroup).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillGroup","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="BGRP_AAServiceTotal">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BGRP_AATotal">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BGRP_ADServiceTotal">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BGRP_ADTotal">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BGRP_BillGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BGRP_SpecSurcharge">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ARPBL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>BGRP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BGRP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BGRP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>BGRP_RowId</SqlRowIdName>
<StreamLocation>^User.ARPatBillGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
