/// Per Diem Rates(2387)
Class User.ARCPayAgreemDRGDetPDRates Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemDRGDetPDRates, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PDRChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_PayAgreemDRGDetails Parent Reference
Relationship PDRParRef As ARCPayAgreemDRGDetails [ Cardinality = parent, Inverse = ChildARCPayAgreemDRGDetPDRates, Required, SqlFieldName = PDR_ParRef ];

/// Childsub
Property PDRChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DRG",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"DET",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"PDR",0))}, SqlColumnNumber = 2, SqlFieldName = PDR_Childsub ];

/// Day From
Property PDRDayFrom As %Float [ SqlColumnNumber = 3, SqlFieldName = PDR_DayFrom ];

/// Day To
Property PDRDayTo As %Float [ SqlColumnNumber = 4, SqlFieldName = PDR_DayTo ];

/// Rate
Property PDRRate As %Float [ SqlColumnNumber = 5, SqlFieldName = PDR_Rate ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemDRGDetPDRates).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemDRGDetPDRates","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemDRGDetPDRates).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemDRGDetPDRates","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemDRGDetPDRates).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemDRGDetPDRates","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemDRGDetPDRates).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemDRGDetPDRates","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemDRGDetPDRates).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemDRGDetPDRates","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PDR_DayFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDR_DayTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDR_Rate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARC_PayAgreemDRG.DRG_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ARC_PayAgreemDRGDetails.DET_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>PDR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DRG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARC_PayAgreemDRG.DRG_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ARC_PayAgreemDRGDetails.DET_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"PDR"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{PDR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PDR_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemDRGDetPDRatesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
