/// Payment Agreem Theatre Band(1738)
Class User.ARCPayAgreemTheatreBand Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemTheatreBand, StorageStrategy = SQLStorage ]
{

/// Des Ref AssocClassif
Property TBAssocClassifDR As ARCInsuranceCategory [ SqlColumnNumber = 3, SqlFieldName = TB_AssocClassif_DR ];

/// Childsub
Property TBChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p(%d(0),$c(1)),"TB",0))}, SqlColumnNumber = 2, SqlFieldName = TB_Childsub ];

/// Fee
Property TBFee As %Float [ SqlColumnNumber = 4, SqlFieldName = TB_Fee ];

/// ARC_PaymentAgreement Parent Reference
Relationship TBParRef As ARCPaymentAgreement [ Cardinality = parent, Inverse = ChildARCPayAgreemTheatreBand, Required, SqlFieldName = TB_ParRef ];

Index RowIDBasedIDKeyIndex On TBChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 62;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemTheatreBand).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTheatreBand","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemTheatreBand).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTheatreBand","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemTheatreBand).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTheatreBand","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemTheatreBand).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTheatreBand","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemTheatreBand).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTheatreBand","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>62</ExtentSize>
<Property name="TBAssocClassifDR">
<Selectivity>6.6667%</Selectivity>
</Property>
<Property name="TBChildsub">
<Selectivity>6.6667%</Selectivity>
</Property>
<Property name="TBFee">
<Selectivity>2.6316%</Selectivity>
</Property>
<Property name="TBParRef">
<Selectivity>20.0000%</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="TB_AssocClassif_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TB_Fee">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>TB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TB"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TB_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAssoc">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>TB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TB"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Assoc"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TB_AssocClassif_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{TB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TB_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemTheatreBandS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
