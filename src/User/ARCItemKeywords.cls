/// Item Keywords(2217)
Class User.ARCItemKeywords Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemKeywords, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM
Property KEYWARCIMDR As ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = KEYW_ARCIM_DR ];

/// Des Ref ARCOS
Property KEYWARCOSDR As ARCOrdSets [ SqlColumnNumber = 3, SqlFieldName = KEYW_ARCOS_DR ];

/// Keyword
Property KEYWKeyword As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = KEYW_Keyword ];

/// Description
Property KEYWDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = KEYW_Desc ];

/// Des Ref OrderSubCat
Property KEYWOrderSubCatDR As ARCItemCat [ SqlColumnNumber = 6, SqlFieldName = KEYW_OrderSubCat_DR ];

/// Des Ref OrderCateg
Property KEYWOrderCategDR As OECOrderCategory [ SqlColumnNumber = 7, SqlFieldName = KEYW_OrderCateg_DR ];

/// Des Ref BillSub
Property KEYWBillSubDR As ARCBillSub [ SqlColumnNumber = 8, SqlFieldName = KEYW_BillSub_DR ];

/// Des Ref BillGrp
Property KEYWBillGrpDR As ARCBillGrp [ SqlColumnNumber = 9, SqlFieldName = KEYW_BillGrp_DR ];

/// Des Ref Generic
Property KEYWGenericDR As PHCGeneric [ SqlColumnNumber = 10, SqlFieldName = KEYW_Generic_DR ];

/// GenKey
Property KEYWGenKey As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = KEYW_GenKey ];

/// Type
Property KEYWType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = KEYW_Type ];

/// Des Ref INCI
Property KEYWINCIDR As INCItm [ SqlColumnNumber = 13, SqlFieldName = KEYW_INCI_DR ];

/// Des Ref Vendor
Property KEYWVendorDR As APCVendor [ SqlColumnNumber = 14, SqlFieldName = KEYW_Vendor_DR ];

/// Region
Property KEYWRegion As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = KEYW_Region ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemKeywords).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemKeywords","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemKeywords).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemKeywords","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemKeywords).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemKeywords","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemKeywords).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemKeywords","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemKeywords).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemKeywords","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemKeywords","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>870438</ExtentSize>
<Property name="KEYWARCIMDR">
<Selectivity>0.0045%</Selectivity>
</Property>
<Property name="KEYWARCOSDR">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="KEYWBillGrpDR">
<Selectivity>49.9999%</Selectivity>
</Property>
<Property name="KEYWBillSubDR">
<Selectivity>49.9999%</Selectivity>
</Property>
<Property name="KEYWDesc">
<Selectivity>0.0041%</Selectivity>
</Property>
<Property name="KEYWGenKey">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="KEYWGenericDR">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="KEYWINCIDR">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="KEYWKeyword">
<Selectivity>0.1557%</Selectivity>
</Property>
<Property name="KEYWOrderCategDR">
<Selectivity>5.2632%</Selectivity>
</Property>
<Property name="KEYWOrderSubCatDR">
<Selectivity>0.4587%</Selectivity>
</Property>
<Property name="KEYWRegion">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="KEYWType">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="KEYWVendorDR">
<Selectivity>99.9995%</Selectivity>
</Property>
<SqlIdExpression>$i(^ARC("KEYW",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="KEYW_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="KEYW_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="KEYW_BillGrp_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="KEYW_BillSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="KEYW_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="KEYW_GenKey">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="KEYW_Generic_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="KEYW_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="KEYW_Keyword">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="KEYW_OrderCateg_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="KEYW_OrderSubCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="KEYW_Region">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="KEYW_Type">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="KEYW_Vendor_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{KEYW_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KEYW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCOS">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ARCOS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_ARCOS_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KEYW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCateg">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Keyw3"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_OrderCateg_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({KEYW_Keyword})</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({KEYW_Desc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{KEYW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGP1">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GP1"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({KEYW_GenKey})</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({KEYW_Desc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{KEYW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGP2">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GP2"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KEYW_OrderSubCat_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({KEYW_GenKey})</Expression>
</Subscript>
<Subscript name="7">
<Expression>$$ALPHAUP({KEYW_Desc})</Expression>
</Subscript>
<Subscript name="8">
<Expression>{KEYW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGP3">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GP3"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KEYW_OrderCateg_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({KEYW_GenKey})</Expression>
</Subscript>
<Subscript name="7">
<Expression>$$ALPHAUP({KEYW_Desc})</Expression>
</Subscript>
<Subscript name="8">
<Expression>{KEYW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGP3Reg">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L9}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GP3Reg"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_Region}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KEYW_Type}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{KEYW_OrderCateg_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>$$ALPHAUP({KEYW_GenKey})</Expression>
</Subscript>
<Subscript name="8">
<Expression>$$ALPHAUP({KEYW_Desc})</Expression>
</Subscript>
<Subscript name="9">
<Expression>{KEYW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGP4">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GP4"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KEYW_BillSub_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({KEYW_GenKey})</Expression>
</Subscript>
<Subscript name="7">
<Expression>$$ALPHAUP({KEYW_Desc})</Expression>
</Subscript>
<Subscript name="8">
<Expression>{KEYW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGP5">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GP5"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KEYW_BillGrp_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({KEYW_GenKey})</Expression>
</Subscript>
<Subscript name="7">
<Expression>$$ALPHAUP({KEYW_Desc})</Expression>
</Subscript>
<Subscript name="8">
<Expression>{KEYW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGenKeyw">
<Condition>{KEYW_Generic_DR}</Condition>
<ConditionFields>KEYW_Generic_DR,KEYW_Desc,KEYW_Keyword</ConditionFields>
<Global>^ARC</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GenKeyw"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({KEYW_GenKey})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({KEYW_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{KEYW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGenKeyw2">
<Condition>{KEYW_Generic_DR}</Condition>
<ConditionFields>KEYW_Generic_DR</ConditionFields>
<Global>^ARC</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GenKeyw2"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_OrderSubCat_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({KEYW_GenKey})</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({KEYW_Desc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{KEYW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGenKeyw3">
<Condition>{KEYW_Generic_DR}</Condition>
<ConditionFields>KEYW_Generic_DR</ConditionFields>
<Global>^ARC</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GenKeyw3"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_OrderCateg_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({KEYW_GenKey})</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({KEYW_Desc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{KEYW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGeneric">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Gener"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_Generic_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KEYW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_INCI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KEYW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexKeyw1">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Keyw1"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({KEYW_Keyword})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({KEYW_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{KEYW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexKeyw2">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Keyw2"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_OrderSubCat_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({KEYW_Keyword})</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({KEYW_Desc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{KEYW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexKeyw3Reg">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Keyw3Reg"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_Region}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KEYW_OrderCateg_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({KEYW_Keyword})</Expression>
</Subscript>
<Subscript name="7">
<Expression>$$ALPHAUP({KEYW_Desc})</Expression>
</Subscript>
<Subscript name="8">
<Expression>{KEYW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexKeyw4">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Keyw4"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_BillSub_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({KEYW_Keyword})</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({KEYW_Desc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{KEYW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexKeyw5">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Keyw5"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_BillGrp_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({KEYW_Keyword})</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({KEYW_Desc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{KEYW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVendor">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>KEYW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Vendor"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_Vendor_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KEYW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>KEYW_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemKeywordsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
