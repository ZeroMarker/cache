/// ARC Bill Sub Group      (ARCSG,215)
Class User.ARCBillSub Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = ARC_BillSub, StorageStrategy = SQLStorage ]
{

/// Des Ref to ARCBG
Relationship ARCSGARCBGParRef As ARCBillGrp [ Cardinality = parent, Inverse = ChildARCBillSub, Required, SqlFieldName = ARCSG_ARCBG_ParRef ];

/// Abbreviation
Property ARCSGAbbrev As %String(COLLATION = "AlphaUp", MAXLEN = 120, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ARCSG_Abbrev ];

/// ARCSG_ChildSub
Property ARCSGChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^ARCBG(+$s($d(initvalue):initvalue,1:%d(0)),"SG",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ARCSG_ChildSub ];

/// Billing Sub Group Code
Property ARCSGCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = ARCSG_Code ];

/// Consider Order Set
Property ARCSGConsiderOrderSet As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = ARCSG_ConsiderOrderSet ];

/// Billing Sub Group Description
Property ARCSGDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = ARCSG_Desc ];

/// Display Zero Items
Property ARCSGDisplayZeroItems As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = ARCSG_DisplayZeroItems ];

/// Material Diff Date
Property ARCSGMaterialDiffDate As %String(DISPLAYLIST = ",None,Same Qty,Same Qty+UpToAge", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",N,Q,QA") [ SqlColumnNumber = 9, SqlFieldName = ARCSG_MaterialDiffDate ];

/// Material Same Date
Property ARCSGMaterialSameDate As %String(DISPLAYLIST = ",None,Same Date,Same Date+UpToAge,Same Date+Qty", MAXLEN = 17, TRUNCATE = 1, VALUELIST = ",N,D,DA,DQ") [ SqlColumnNumber = 10, SqlFieldName = ARCSG_MaterialSameDate ];

/// Occurence Rule
Property ARCSGOccurenceRule As %String(DISPLAYLIST = ",Oral,Ointment,Visit Fee,Service Days,Service Times,Material Days,Material Times,None", MAXLEN = 14, TRUNCATE = 1, VALUELIST = ",ORAL,OINT,VISIT,SD,ST,MD,MT,NONE") [ SqlColumnNumber = 13, SqlFieldName = ARCSG_OccurenceRule ];

/// Quantity To Day
Property ARCSGQtyToDay As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = ARCSG_QtyToDay ];

/// Review Screen Order
Property ARCSGRevOrder As %Float(MINVAL = 1) [ SqlColumnNumber = 7, SqlFieldName = ARCSG_RevOrder ];

/// Service Diff Date
Property ARCSGServiceDiffDate As %String(DISPLAYLIST = ",None,Same Qty", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",N,Q") [ SqlColumnNumber = 11, SqlFieldName = ARCSG_ServiceDiffDate ];

/// Service Same Date
Property ARCSGServiceSameDate As %String(DISPLAYLIST = ",None,Same Date+Qty,Same Date", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",N,DQ,D") [ SqlColumnNumber = 12, SqlFieldName = ARCSG_ServiceSameDate ];

Relationship ChildARCBillSubAgeDepend As ARCBillSubAgeDepend [ Cardinality = children, Inverse = AGEParRef ];

Relationship ChildARCBillSubDesc As ARCBillSubDesc [ Cardinality = children, Inverse = DESParRef ];

Relationship ChildARCBillSubTimeDepend As ARCBillSubTimeDepend [ Cardinality = children, Inverse = TIMEParRef ];

Index ARCSGRevOrderUnqIdx1 On ARCSGRevOrder [ Unique ];

Index RowIDBasedIDKeyIndex On ARCSGChildSub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 43;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCBillSub).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillSub","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCBillSub).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillSub","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCBillSub).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillSub","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCBillSub).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillSub","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCBillSub).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillSub","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>43</ExtentSize>
<Property name="ARCSGARCBGParRef">
<Selectivity>4.7619%</Selectivity>
</Property>
<Property name="ARCSGAbbrev">
<Selectivity>3.8462%</Selectivity>
</Property>
<Property name="ARCSGChildSub">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="ARCSGCode">
<Selectivity>3.8462%</Selectivity>
</Property>
<Property name="ARCSGConsiderOrderSet">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARCSGDesc">
<Selectivity>3.8462%</Selectivity>
</Property>
<Property name="ARCSGDisplayZeroItems">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARCSGMaterialDiffDate">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ARCSGMaterialSameDate">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="ARCSGOccurenceRule">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="ARCSGQtyToDay">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARCSGRevOrder">
<Selectivity>1</Selectivity>
</Property>
<Property name="ARCSGServiceDiffDate">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARCSGServiceSameDate">
<Selectivity>25.0000%</Selectivity>
</Property>
<SQLMap name="DataMasterARCSG">
<Data name="ARCSG_Abbrev">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ARCSG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCSG_ConsiderOrderSet">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ARCSG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ARCSG_DisplayZeroItems">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ARCSG_MaterialDiffDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ARCSG_MaterialSameDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ARCSG_OccurenceRule">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ARCSG_QtyToDay">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ARCSG_RevOrder">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ARCSG_ServiceDiffDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ARCSG_ServiceSameDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^ARCBG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_BillGrp.ARCBG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ARCSG_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ARC_BillGrp.ARCBG_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SG"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ARCSG_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAbbreviation">
<Global>^ARCBG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ARC_BillGrp.ARCBG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARCSG_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SG_Abbr"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({ARCSG_Abbrev})</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ARC_BillGrp.ARCBG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARCSG_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ARCBG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ARC_BillGrp.ARCBG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARCSG_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SG_Code"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({ARCSG_Code})</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ARC_BillGrp.ARCBG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARCSG_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ARCBG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ARC_BillGrp.ARCBG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARCSG_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SG_Desc"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({ARCSG_Desc})</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ARC_BillGrp.ARCBG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARCSG_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ARCSG_RowId</SqlRowIdName>
<StreamLocation>^User.ARCBillSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
