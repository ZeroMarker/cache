/// OE Dispensing             (DSP,649)
Class User.OEDispensing Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_Dispensing, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DSPChildSub [ IdKey, PrimaryKey, Unique ];

/// Des Ref to OEORE
Relationship DSPOEOREParRef As OEOrdExec [ Cardinality = parent, Inverse = ChildOEDispensing, Required, SqlFieldName = DSP_OEORE_ParRef ];

/// Des Ref to INCLB
Property DSPINCLBDR As INCItmLcBt [ SqlColumnNumber = 2, SqlFieldName = DSP_INCLB_DR ];

/// DSP Child Sub (New Key)
Property DSPChildSub As %Numeric(MINVAL = 1, SCALE = 0) [ InitialExpression = {$i(^OEORD(+$s($d(initvalue):initvalue,1:%d(0)),"I",$p($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"||",2),"X",$p($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"||",3),"D",0))}, SqlColumnNumber = 3, SqlFieldName = DSP_ChildSub ];

/// Quantity
Property DSPQty As %Float(MAXVAL = 999999999, MINVAL = 0) [ Required, SqlColumnNumber = 4, SqlFieldName = DSP_Qty ];

/// Des Ref to OECHG
Property DSPOECHGDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DSP_OECHG_DR ];

/// Dispensing Date
Property DSPDate As %Date [ SqlColumnNumber = 6, SqlFieldName = DSP_Date ];

/// Dispensing Time
Property DSPTime As %Time [ SqlColumnNumber = 7, SqlFieldName = DSP_Time ];

/// Des Ref SSUSR
Property DSPSSUSRDR As SSUser [ InitialExpression = {$g(XCONF("DPUSR",3))}, SqlColumnNumber = 8, SqlFieldName = DSP_SSUSR_DR ];

/// Status
Property DSPStatus As %String(DISPLAYLIST = ",Packed,Collected,Check,Uncollected", MAXLEN = 11, TRUNCATE = 1, VALUELIST = ",P,C,K,N") [ SqlColumnNumber = 10, SqlFieldName = DSP_Status ];

/// Return Qty
Property DSPReturnQty As %Float [ SqlColumnNumber = 11, SqlFieldName = DSP_ReturnQty ];

/// Des Ref ReturnLoc
Property DSPReturnLocDR As CTLoc [ SqlColumnNumber = 12, SqlFieldName = DSP_ReturnLoc_DR ];

/// Des Ref CollectedUser_DR
Property DSPCollectedUserDR As SSUser [ SqlColumnNumber = 13, SqlFieldName = DSP_CollectedUser_DR ];

/// Collected Date
Property DSPCollectedDate As %Date [ SqlColumnNumber = 14, SqlFieldName = DSP_CollectedDate ];

/// Collected Time
Property DSPCollectedTime As %Time [ SqlColumnNumber = 15, SqlFieldName = DSP_CollectedTime ];

/// CollectedPatientRep
Property DSPCollectedPatientRep As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = DSP_CollectedPatientRep ];

/// TotalReturnedQty
Property DSPTotalReturnedQty As %Float [ SqlColumnNumber = 17, SqlFieldName = DSP_TotalReturnedQty ];

/// Des Ref CheckedBy
Property DSPCheckedByDR As SSUser [ SqlColumnNumber = 18, SqlFieldName = DSP_CheckedBy_DR ];

/// CheckedDate
Property DSPCheckedDate As %Date [ SqlColumnNumber = 19, SqlFieldName = DSP_CheckedDate ];

/// CheckedTime
Property DSPCheckedTime As %Time [ SqlColumnNumber = 20, SqlFieldName = DSP_CheckedTime ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.OEDispensing).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEDispensing","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.OEDispensing).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEDispensing","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.OEDispensing).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEDispensing","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.OEDispensing).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEDispensing","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.OEDispensing).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEDispensing","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEDispensing","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>4043</ExtentSize>
<Property name="DSPCheckedByDR">
<Selectivity>49.9999%</Selectivity>
</Property>
<Property name="DSPCheckedDate">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DSPCheckedTime">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DSPChildSub">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="DSPCollectedDate">
<Selectivity>2.9308%</Selectivity>
</Property>
<Property name="DSPCollectedPatientRep">
<Selectivity>49.9999%</Selectivity>
</Property>
<Property name="DSPCollectedTime">
<Selectivity>1.0767%</Selectivity>
</Property>
<Property name="DSPCollectedUserDR">
<Selectivity>49.9999%</Selectivity>
</Property>
<Property name="DSPDate">
<Selectivity>1.5261%</Selectivity>
</Property>
<Property name="DSPINCLBDR">
<Selectivity>3.1174%</Selectivity>
</Property>
<Property name="DSPOECHGDR">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="DSPOEOREParRef">
<Selectivity>0.0276%</Selectivity>
</Property>
<Property name="DSPQty">
<Selectivity>5.5554%</Selectivity>
</Property>
<Property name="DSPReturnLocDR">
<Selectivity>49.9999%</Selectivity>
</Property>
<Property name="DSPReturnQty">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="DSPSSUSRDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DSPStatus">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="DSPTime">
<Selectivity>0.5506%</Selectivity>
</Property>
<Property name="DSPTotalReturnedQty">
<Selectivity>16.6667%</Selectivity>
</Property>
<SQLMap name="DataMasterDSP">
<Data name="DSP_CheckedBy_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DSP_CheckedDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DSP_CheckedTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DSP_CollectedDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DSP_CollectedPatientRep">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DSP_CollectedTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DSP_CollectedUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DSP_Date">
<Delimiter>"^",","</Delimiter>
<Piece>4,1</Piece>
</Data>
<Data name="DSP_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DSP_OECHG_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DSP_Qty">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSP_ReturnLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DSP_ReturnQty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DSP_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DSP_Status">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DSP_Time">
<Delimiter>"^",","</Delimiter>
<Piece>4,2</Piece>
</Data>
<Data name="DSP_TotalReturnedQty">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>OE_OrdExec.OEORE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>DSP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"X"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{OE_OrdExec.OEORE_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"D"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{DSP_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DSP_RowId</SqlRowIdName>
<StreamLocation>^User.OEDispensingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
