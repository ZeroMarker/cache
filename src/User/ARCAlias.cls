/// ARC Alias(search for orders)(1453)
Class User.ARCAlias Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_Alias, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM
Property ALIASARCIMDR As ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = ALIAS_ARCIM_DR ];

/// Des Ref ARCOS
Property ALIASARCOSDR As ARCOrdSets [ SqlColumnNumber = 3, SqlFieldName = ALIAS_ARCOS_DR ];

/// Text
Property ALIASText As %String(COLLATION = "AlphaUp", MAXLEN = 50, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = ALIAS_Text ];

/// Order Item/Set Description
Property ALIASDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ALIAS_Desc ];

/// Des Ref OrderSubCat
Property ALIASOrderSubCatDR As ARCItemCat [ SqlColumnNumber = 6, SqlFieldName = ALIAS_OrderSubCat_DR ];

/// Type(ARCIM,ARCOS)
Property ALIASType As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlComputeCode = { s {ALIAS_Type}=$$CO07^at1453({ALIAS_ARCIM_DR},{ALIAS_ARCOS_DR})
}, SqlComputed, SqlFieldName = ALIAS_Type, Transient ];

/// Row Calculated
Property ALIASRowCalc As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlComputeCode = { s {ALIAS_Row_Calc}=$$CO08^at1453({ALIAS_ARCIM_DR},{ALIAS_ARCOS_DR})
}, SqlComputed, SqlFieldName = ALIAS_Row_Calc, Transient ];

/// Order On Its Own
Property ALIASOrderOnItsOwn As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = ALIAS_OrderOnItsOwn ];

/// Service
Property ALIASService As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = ALIAS_Service ];

/// Des Ref ServiceSet
Property ALIASServiceSetDR As RBCServiceSet [ SqlColumnNumber = 11, SqlFieldName = ALIAS_ServiceSet_DR ];

/// Des Ref AuxInsType
Property ALIASAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 12, SqlFieldName = ALIAS_AuxInsType_DR ];

/// Des Ref InsType
Property ALIASInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 13, SqlFieldName = ALIAS_InsType_DR ];

/// Date From
Property ALIASDateFrom As %Date [ SqlColumnNumber = 14, SqlFieldName = ALIAS_DateFrom ];

/// Date To
Property ALIASDateTo As %Date [ SqlColumnNumber = 15, SqlFieldName = ALIAS_DateTo ];

/// Des Ref Generic
Property ALIASGenericDR As PHCGeneric [ SqlColumnNumber = 16, SqlFieldName = ALIAS_Generic_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCAlias).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCAlias","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCAlias).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCAlias","OnAfterInsert")
 
 d POFILINS^at1453
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCAlias).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCAlias","OnAfterUpdate")
 
 d POFILUPD^at1453
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCAlias).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCAlias","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
	d VALINS^at1453
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCAlias).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCAlias","OnBeforeUpdate")
 
 d VALUPD^at1453
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^ARC("ALIAS",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ALIAS_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALIAS_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ALIAS_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ALIAS_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ALIAS_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ALIAS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ALIAS_Generic_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ALIAS_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ALIAS_OrderOnItsOwn">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ALIAS_OrderSubCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ALIAS_Service">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ALIAS_ServiceSet_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ALIAS_Text">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ALIAS_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ALIAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ALIAS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ALIAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALIAS_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ALIAS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCOS">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ALIAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ARCOS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALIAS_ARCOS_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ALIAS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAuxInsType">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ALIAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"AuxInsType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALIAS_AuxInsType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ALIAS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Condition>{ALIAS_ARCIM_DR}'=""!({ALIAS_ARCOS_DR}'="")</Condition>
<ConditionFields>ALIAS_Desc</ConditionFields>
<Data name="ALIAS_Row_Calc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALIAS_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ALIAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ALIAS_Text})_" "</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ALIAS_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ALIAS_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>1</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDescItems">
<Condition>{ALIAS_ARCIM_DR}'=""</Condition>
<ConditionFields>ALIAS_Desc,ALIAS_Text</ConditionFields>
<Data name="ALIAS_Row_Calc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALIAS_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ALIAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DescI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ALIAS_Text})_" "</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ALIAS_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ALIAS_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>1</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDescVisItemOS">
<Condition>$$vios^at1453({ALIAS_ARCIM_DR},{ALIAS_ARCOS_DR},{ALIAS_OrderOnItsOwn})=1</Condition>
<ConditionFields>ALIAS_Text,ALIAS_Desc</ConditionFields>
<Data name="ALIAS_Row_Calc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALIAS_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ALIAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DescVIOS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ALIAS_Text})_" "</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ALIAS_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ALIAS_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>1</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDescVisItems">
<Condition>{ALIAS_ARCIM_DR}'="",$$visible^at115({ALIAS_OrderOnItsOwn})="Y"</Condition>
<ConditionFields>ALIAS_Desc,ALIAS_Text</ConditionFields>
<Data name="ALIAS_Row_Calc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALIAS_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ALIAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DescVI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ALIAS_Text})_" "</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ALIAS_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ALIAS_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>1</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGener">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ALIAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Gener"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALIAS_Generic_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ALIAS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsType">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>ALIAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"InsType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALIAS_InsType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ALIAS_Text})</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({ALIAS_Desc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ALIAS_AuxInsType_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ALIAS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdCatDescOSVisIt">
<Condition>$$vios^at1453({ALIAS_ARCIM_DR},{ALIAS_ARCOS_DR},{ALIAS_OrderOnItsOwn})=1</Condition>
<ConditionFields>ALIAS_OrderSubCat_DR,ALIAS_Text,ALIAS_Desc</ConditionFields>
<Data name="ALIAS_Row_Calc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALIAS_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ALIAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OrderCat-DescVIOS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALIAS_OrderSubCat_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ALIAS_Text})_" "</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({ALIAS_Desc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ALIAS_RowId}</Expression>
</Subscript>
<Subscript name="8">
<Expression>1</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdCatDescVisItem">
<Condition>{ALIAS_ARCIM_DR}'="",$$visible^at115({ALIAS_OrderOnItsOwn})="Y"</Condition>
<ConditionFields>ALIAS_OrderSubCat_DR,ALIAS_Desc,ALIAS_Text</ConditionFields>
<Data name="ALIAS_Row_Calc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALIAS_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ALIAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OrderCat-DescVI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALIAS_OrderSubCat_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ALIAS_Text})_" "</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({ALIAS_Desc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ALIAS_RowId}</Expression>
</Subscript>
<Subscript name="8">
<Expression>1</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServSetDesc">
<Condition>1</Condition>
<Global>^ARC</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ALIAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SerSetDesc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ALIAS_Text})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ALIAS_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ALIAS_ServiceSet_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ALIAS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexService">
<Condition>1</Condition>
<Global>^ARC</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ALIAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ALIAS_Text})_" "</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ALIAS_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ALIAS_Service}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ALIAS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServiceSet">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ALIAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SERSET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALIAS_ServiceSet_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ALIAS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSubCatDescItems">
<Condition>{ALIAS_ARCIM_DR}'=""</Condition>
<ConditionFields>ALIAS_OrderSubCat_DR,ALIAS_Desc,ALIAS_Text</ConditionFields>
<Data name="ALIAS_Row_Calc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALIAS_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ALIAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OrderCat-DescI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALIAS_OrderSubCat_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ALIAS_Text})_" "</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({ALIAS_Desc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ALIAS_RowId}</Expression>
</Subscript>
<Subscript name="8">
<Expression>1</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSubcatDesc">
<Data name="ALIAS_Row_Calc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALIAS_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ALIAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OrderCat-Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALIAS_OrderSubCat_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ALIAS_Text})_" "</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({ALIAS_Desc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ALIAS_RowId}</Expression>
</Subscript>
<Subscript name="8">
<Expression>1</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ALIAS_RowId</SqlRowIdName>
<StreamLocation>^User.ARCAliasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
