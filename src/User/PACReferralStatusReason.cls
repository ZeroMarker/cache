/// Referral Status Reason(2453)
Class User.PACReferralStatusReason Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ReferralStatusReason, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On REAChildsub [ IdKey, PrimaryKey, Unique ];

/// PAC_ReferralStatus Parent Reference
Relationship REAParRef As PACReferralStatus [ Cardinality = parent, Inverse = ChildPACReferralStatusReason, Required, SqlFieldName = REA_ParRef ];

/// Childsub
Property REAChildsub As %Float [ InitialExpression = {$i(^PAC("RST",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"REA",0))}, SqlColumnNumber = 2, SqlFieldName = REA_Childsub ];

/// Des Ref Reason
Property REAReasonDR As PACRefStatusReason [ SqlColumnNumber = 3, SqlFieldName = REA_Reason_DR ];

/// Date From
Property READateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = REA_DateFrom ];

/// Date To
Property READateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = REA_DateTo ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACReferralStatusReason).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACReferralStatusReason","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACReferralStatusReason).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACReferralStatusReason","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACReferralStatusReason).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACReferralStatusReason","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACReferralStatusReason).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACReferralStatusReason","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACReferralStatusReason).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACReferralStatusReason","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACReferralStatusReason","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="REA_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REA_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REA_Reason_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_ReferralStatus.RST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>REA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_ReferralStatus.RST_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"REA"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REA_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexReason">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_ReferralStatus.RST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>REA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_ReferralStatus.RST_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"REA"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Reason"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{REA_Reason_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{REA_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>REA_RowId</SqlRowIdName>
<StreamLocation>^User.PACReferralStatusReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
