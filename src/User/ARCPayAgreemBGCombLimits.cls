/// ARC Pay Agreem BG Comb Limits(1861)
Class User.ARCPayAgreemBGCombLimits Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemBGCombLimits, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On COMChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildARCPayAgreemCombLimBG As ARCPayAgreemCombLimBG [ Cardinality = children, Inverse = BGParRef ];

/// ARC_PaymentAgreement Parent Reference
Relationship COMParRef As ARCPaymentAgreement [ Cardinality = parent, Inverse = ChildARCPayAgreemBGCombLimits, Required, SqlFieldName = COM_ParRef ];

/// Childsub
Property COMChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"COM",0))}, SqlColumnNumber = 2, SqlFieldName = COM_Childsub ];

/// Amount
Property COMAmt As %Float [ SqlColumnNumber = 3, SqlFieldName = COM_Amt ];

/// Type
Property COMType As %String(DISPLAYLIST = ",Episode,Daily,Yearly,Unit per Order Item,Monthly", MAXLEN = 19, TRUNCATE = 1, VALUELIST = ",E,D,Y,U,M") [ SqlColumnNumber = 4, SqlFieldName = COM_Type ];

/// Des Ref EpisSubType
Property COMEpisSubTypeDR As PACEpisodeSubType [ SqlColumnNumber = 5, SqlFieldName = COM_EpisSubType_DR ];

/// DateFrom
Property COMDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = COM_DateFrom ];

/// DateTo
Property COMDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = COM_DateTo ];

/// AnnualReset
Property COMAnnualReset As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = COM_AnnualReset ];

/// ApprovalLimit
Property COMApprovalLimit As %Float [ SqlColumnNumber = 9, SqlFieldName = COM_ApprovalLimit ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemBGCombLimits).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBGCombLimits","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemBGCombLimits).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBGCombLimits","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemBGCombLimits).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBGCombLimits","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemBGCombLimits).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBGCombLimits","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBGCombLimits","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemBGCombLimits).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBGCombLimits","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="COM_Amt">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="COM_AnnualReset">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="COM_ApprovalLimit">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="COM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="COM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="COM_EpisSubType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="COM_Type">
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
<Field>COM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"COM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{COM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>COM_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemBGCombLimitsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
