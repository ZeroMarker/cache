/// ARC Billing Group       (ARCBG,175)
Class User.ARCBillGrp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = ARC_BillGrp, StorageStrategy = SQLStorage ]
{

Relationship ChildARCBillSub As ARCBillSub [ Cardinality = children, Inverse = ARCSGARCBGParRef ];

Relationship ChildARCBillGrpDesc As ARCBillGrpDesc [ Cardinality = children, Inverse = DESParRef ];

/// Billing Group Code
Property ARCBGCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ARCBG_Code ];

/// Abbreviation
Property ARCBGAbbrev As %String(COLLATION = "AlphaUp", MAXLEN = 120, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ARCBG_Abbrev ];

/// Billing Group Description
Property ARCBGDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = ARCBG_Desc ];

/// Time Dependent Bill Group
Property ARCBGTimeDependent As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ARCBG_TimeDependent ];

/// Material Same Date
Property ARCBGMaterialSameDate As %String(DISPLAYLIST = ",None,Same Date,Same Date+UpToAge,Same Date+Qty", MAXLEN = 17, TRUNCATE = 1, VALUELIST = ",N,D,DA,DQ") [ SqlColumnNumber = 7, SqlFieldName = ARCBG_MaterialSameDate ];

/// Material Diff Date
Property ARCBGMaterialDiffDate As %String(DISPLAYLIST = ",None,Same Qty,Same Qty+UpToAge", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",N,Q,QA") [ SqlColumnNumber = 8, SqlFieldName = ARCBG_MaterialDiffDate ];

/// Service Same Date
Property ARCBGServiceSameDate As %String(DISPLAYLIST = ",None,Same Date+Qty,Same Date", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",N,DQ,D") [ SqlColumnNumber = 9, SqlFieldName = ARCBG_ServiceSameDate ];

/// Service Diff Date
Property ARCBGServiceDiffDate As %String(DISPLAYLIST = ",None,Same Qty", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",N,Q") [ SqlColumnNumber = 10, SqlFieldName = ARCBG_ServiceDiffDate ];

/// Display Zero Items
Property ARCBGDisplayZeroItems As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = ARCBG_DisplayZeroItems ];

/// Occurence Rule
Property ARCBGOccurenceRule As %String(DISPLAYLIST = ",Oral,Ointment,Visit Fee,Service Days,Service Times,Material Days,Material Times,None", MAXLEN = 14, TRUNCATE = 1, VALUELIST = ",ORAL,OINT,VISIT,SD,ST,MD,MT,NONE") [ SqlColumnNumber = 12, SqlFieldName = ARCBG_OccurenceRule ];

/// Consider Order Set
Property ARCBGConsiderOrderSet As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = ARCBG_ConsiderOrderSet ];

/// Quantity To Day
Property ARCBGQtyToDay As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = ARCBG_QtyToDay ];

/// Max Order No In Group Warning
Property ARCBGMaxOrderNoInGrpWarn As %Float [ SqlColumnNumber = 15, SqlFieldName = ARCBG_MaxOrderNoInGrpWarn ];

Index ARCBGCodeUnqIdx1 On ARCBGCode;

Index ARCBGDescUnqIdx2 On ARCBGDesc;

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCBillGrp).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCBillGrp","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCBillGrp).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCBillGrp","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCBillGrp).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCBillGrp","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCBillGrp).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCBillGrp","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCBillGrp","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCBillGrp).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCBillGrp","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^ARCBG(0))</SqlIdExpression>
<SQLMap name="DataMasterARCBG">
<Data name="ARCBG_Abbrev">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ARCBG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCBG_ConsiderOrderSet">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ARCBG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ARCBG_DisplayZeroItems">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ARCBG_MaterialDiffDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ARCBG_MaterialSameDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ARCBG_MaxOrderNoInGrpWarn">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ARCBG_OccurenceRule">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ARCBG_QtyToDay">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ARCBG_ServiceDiffDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ARCBG_ServiceSameDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ARCBG_TimeDependent">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^ARCBG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARCBG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ARCBG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAbbreviation">
<Global>^ARCBG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARCBG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Abbr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({ARCBG_Abbrev})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARCBG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ARCBG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARCBG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({ARCBG_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARCBG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ARCBG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARCBG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DESC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({ARCBG_Desc})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARCBG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ARCBG_RowId</SqlRowIdName>
<StreamLocation>^User.ARCBillGrpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
