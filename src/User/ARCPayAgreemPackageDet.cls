/// PayAgreemPackageDet(2672)
Class User.ARCPayAgreemPackageDet Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemPackageDet, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DETChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_PayAgreemPackage Parent Reference
Relationship DETParRef As ARCPayAgreemPackage [ Cardinality = parent, Inverse = ChildARCPayAgreemPackageDet, Required, SqlFieldName = DET_ParRef ];

/// Childsub
Property DETChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"PK",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"DET",0))}, SqlColumnNumber = 2, SqlFieldName = DET_Childsub ];

/// Des Ref OrdCateg
Property DETOrdCategDR As OECOrderCategory [ SqlColumnNumber = 3, SqlFieldName = DET_OrdCateg_DR ];

/// Des Ref SubCateg
Property DETSubCategDR As ARCItemCat [ SqlColumnNumber = 4, SqlFieldName = DET_SubCateg_DR ];

/// Des Ref ARCIM
Property DETARCIMDR As ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = DET_ARCIM_DR ];

/// Des Ref ARCOS
Property DETARCOSDR As ARCOrdSets [ SqlColumnNumber = 6, SqlFieldName = DET_ARCOS_DR ];

/// LimitQty
Property DETLimitQty As %Float [ SqlColumnNumber = 7, SqlFieldName = DET_LimitQty ];

/// PriceUnderLimit
Property DETPriceUnderLimit As %Float [ SqlColumnNumber = 8, SqlFieldName = DET_PriceUnderLimit ];

/// PriceOverLimit
Property DETPriceOverLimit As %Float [ SqlColumnNumber = 9, SqlFieldName = DET_PriceOverLimit ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemPackageDet).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemPackageDet","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemPackageDet).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemPackageDet","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemPackageDet).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemPackageDet","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemPackageDet).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemPackageDet","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemPackageDet).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemPackageDet","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DET_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DET_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DET_LimitQty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DET_OrdCateg_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DET_PriceOverLimit">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DET_PriceUnderLimit">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DET_SubCateg_DR">
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
<Field>ARC_PayAgreemPackage.PK_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>DET_Childsub</Field>
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
<Expression>{ARC_PayAgreemPackage.PK_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DET_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemPackageDetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
