/// MRC DRGCoding(2147)
Class User.MRCDRGCoding Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_DRGCoding, StorageStrategy = SQLStorage ]
{

Relationship ChildMRCDRGCodingProcedures As MRCDRGCodingProcedures [ Cardinality = children, Inverse = PROCParRef ];

Relationship ChildMRCDRGCodingICD As MRCDRGCodingICD [ Cardinality = children, Inverse = ICDParRef ];

Relationship ChildMRCDRGCodingEdition As MRCDRGCodingEdition [ Cardinality = children, Inverse = EDParRef ];

/// Des Ref CTLOC
Property DRGCODCTLOCDR As CTLoc [ SqlColumnNumber = 2, SqlFieldName = DRGCOD_CTLOC_DR ];

/// Des Ref DRG
Property DRGCODDRGDR As MRCDRGCodes [ SqlColumnNumber = 3, SqlFieldName = DRGCOD_DRG_DR ];

/// On Off
Property DRGCODOnOff As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DRGCOD_OnOff ];

/// Code
Property DRGCODCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DRGCOD_Code ];

/// Description
Property DRGCODDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DRGCOD_Desc ];

/// Date From
Property DRGCODDateFrom As %Date [ SqlColumnNumber = 7, SqlFieldName = DRGCOD_DateFrom ];

/// Date To
Property DRGCODDateTo As %Date [ SqlColumnNumber = 8, SqlFieldName = DRGCOD_DateTo ];

/// Hospital CT des ref
Property DRGCODHospitalCTDR As CTHospital [ SqlColumnNumber = 9, SqlFieldName = DRGCOD_HospitalCT_DR ];

/// Follow Up Reason DR
Property DRGCODFollowUpReasonDR As PACFollowUpReason [ SqlColumnNumber = 10, SqlFieldName = DRGCOD_FollowUpReasonDR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCDRGCoding).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCoding","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCDRGCoding).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCoding","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCDRGCoding).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCoding","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCDRGCoding).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCoding","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCDRGCoding).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCoding","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^MRC("DRGCOD",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DRGCOD_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRGCOD_Code">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRGCOD_DRG_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRGCOD_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DRGCOD_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DRGCOD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRGCOD_FollowUpReasonDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DRGCOD_HospitalCT_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DRGCOD_OnOff">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DRGCOD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRGCOD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRGCOD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTLOC">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DRGCOD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRGCOD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRGCOD_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRGCOD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DRGCOD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRGCOD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DRGCOD_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRGCOD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDRG">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DRGCOD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRGCOD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DRG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRGCOD_DRG_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRGCOD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DRGCOD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRGCOD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DRGCOD_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRGCOD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDRG">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DRGCOD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRGCOD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LocDRG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRGCOD_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRGCOD_DRG_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DRGCOD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DRGCOD_RowId</SqlRowIdName>
<StreamLocation>^User.MRCDRGCodingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
