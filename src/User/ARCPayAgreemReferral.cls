/// PayAgreemReferral(2803)
Class User.ARCPayAgreemReferral Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemReferral, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On REFChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_PaymentAgreement Parent Reference
Relationship REFParRef As ARCPaymentAgreement [ Cardinality = parent, Inverse = ChildARCPayAgreemReferral, Required, SqlFieldName = REF_ParRef ];

/// Childsub
Property REFChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"REF",0))}, SqlColumnNumber = 2, SqlFieldName = REF_Childsub ];

/// DateFrom
Property REFDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = REF_DateFrom ];

/// DateTo
Property REFDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = REF_DateTo ];

/// Des Ref EpisSubType
Property REFEpisSubTypeDR As PACEpisodeSubType [ SqlColumnNumber = 5, SqlFieldName = REF_EpisSubType_DR ];

/// Des Ref Speciality
Property REFSpecialityDR As CTSpec [ SqlColumnNumber = 6, SqlFieldName = REF_Speciality_DR ];

/// Des Ref CTPCP
Property REFCTPCPDR As CTCareProv [ SqlColumnNumber = 7, SqlFieldName = REF_CTPCP_DR ];

/// Message
Property REFMessage As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = REF_Message, SqlListType = SUBNODE ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemReferral).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemReferral","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemReferral).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemReferral","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemReferral).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemReferral","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemReferral).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemReferral","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemReferral","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemReferral).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemReferral","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="REF_CTPCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="REF_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REF_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REF_EpisSubType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REF_Message">
<Node>"MSG"</Node>
</Data>
<Data name="REF_Speciality_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>REF_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"REF"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REF_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>REF_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemReferralS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
