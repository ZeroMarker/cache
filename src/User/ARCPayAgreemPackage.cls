/// PayAgreemPackage(2671)
Class User.ARCPayAgreemPackage Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemPackage, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PKChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildARCPayAgreemPackageDet As ARCPayAgreemPackageDet [ Cardinality = children, Inverse = DETParRef ];

/// ARC_PaymentAgreement Parent Reference
Relationship PKParRef As ARCPaymentAgreement [ Cardinality = parent, Inverse = ChildARCPayAgreemPackage, Required, SqlFieldName = PK_ParRef ];

/// Childsub
Property PKChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PK",0))}, SqlColumnNumber = 2, SqlFieldName = PK_Childsub ];

/// DateFrom
Property PKDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = PK_DateFrom ];

/// DateTo
Property PKDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = PK_DateTo ];

/// FixedPrice
Property PKFixedPrice As %Float [ SqlColumnNumber = 5, SqlFieldName = PK_FixedPrice ];

/// NumberOfDays
Property PKNumberOfDays As %Float [ SqlColumnNumber = 6, SqlFieldName = PK_NumberOfDays ];

/// Repeat
Property PKRepeat As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PK_Repeat ];

/// NumberOfVisits
Property PKNumberOfVisits As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PK_NumberOfVisits ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemPackage).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemPackage","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemPackage).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemPackage","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemPackage).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemPackage","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemPackage).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemPackage","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemPackage","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemPackage).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemPackage","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="PK_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PK_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PK_FixedPrice">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PK_NumberOfDays">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PK_NumberOfVisits">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PK_Repeat">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PK_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PK"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PK_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PK_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemPackageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
