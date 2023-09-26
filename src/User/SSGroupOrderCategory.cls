/// SS Group Order Category(1340)
Class User.SSGroupOrderCategory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupOrderCategory, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 1830;

Index RowIDBasedIDKeyIndex On SSORDChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildSSGroupOrderCategoryItems As SSGroupOrderCategoryItems [ Cardinality = children, Inverse = ITMParRef ];

/// SS_Group Parent Reference
Relationship SSORDParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupOrderCategory, Required, SqlFieldName = SSORD_ParRef ];

/// Childsub
Property SSORDChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SSORD",0))}, SqlColumnNumber = 2, SqlFieldName = SSORD_Childsub ];

/// Des Ref to OrdCat
Property SSORDOrdCatDR As OECOrderCategory [ SqlColumnNumber = 3, SqlFieldName = SSORD_OrdCat_DR ];

/// Order On Discharge
Property SSORDOrderOnDischarge As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SSORD_OrderOnDischarge ];

/// Allow to Order Invisble Item
Property SSORDOrderInvisbleItem As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "No", SqlColumnNumber = 5, SqlFieldName = SSORD_OrderInvisbleItem ];

/// Allow to order Order Sets
Property SSORDOrderSets As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Yes", SqlColumnNumber = 6, SqlFieldName = SSORD_OrderSets ];

/// Order SubCategory des ref
Property SSORDOrdSubCategory As ARCItemCat [ SqlColumnNumber = 7, SqlFieldName = SSORD_OrdSubCategory ];

/// Include Exclude
Property SSORDIncludeExclude As %String(DISPLAYLIST = ",Include,Exclude", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",I,E") [ SqlColumnNumber = 8, SqlFieldName = SSORD_IncludeExclude ];

/// Require Authorisation
Property SSORDRequireAuthorisation As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = SSORD_RequireAuthorisation ];

/// OrderOnFinanceDisch
Property SSORDOrderOnFinanceDisch As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = SSORD_OrderOnFinanceDisch ];

/// BookingOnly
Property SSORDBookingOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = SSORD_BookingOnly ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSGroupOrderCategory).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupOrderCategory","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSGroupOrderCategory).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupOrderCategory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSGroupOrderCategory).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupOrderCategory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSGroupOrderCategory).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupOrderCategory","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSGroupOrderCategory).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupOrderCategory","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1830</ExtentSize>
<Property name="SSORDBookingOnly">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSORDChildsub">
<Selectivity>2.0129%</Selectivity>
</Property>
<Property name="SSORDIncludeExclude">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSORDOrdCatDR">
<Selectivity>2.0129%</Selectivity>
</Property>
<Property name="SSORDOrdSubCategory">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="SSORDOrderInvisbleItem">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSORDOrderOnDischarge">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSORDOrderOnFinanceDisch">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSORDOrderSets">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSORDParRef">
<Selectivity>1.7584%</Selectivity>
</Property>
<Property name="SSORDRequireAuthorisation">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="SSORD_BookingOnly">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SSORD_IncludeExclude">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SSORD_OrdCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SSORD_OrdSubCategory">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SSORD_OrderInvisbleItem">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SSORD_OrderOnDischarge">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SSORD_OrderOnFinanceDisch">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SSORD_OrderSets">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SSORD_RequireAuthorisation">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SSORD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SSORD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SSORD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SSORD_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupOrderCategoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
