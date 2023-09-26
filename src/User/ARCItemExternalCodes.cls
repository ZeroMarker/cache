/// ARC Item External Codes(1421)
Class User.ARCItemExternalCodes Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemExternalCodes, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On EXTChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_ItmMast Parent Reference
Relationship EXTParRef As ARCItmMast [ Cardinality = parent, Inverse = ChildARCItemExternalCodes, Required, SqlFieldName = EXT_ParRef ];

/// Childsub
Property EXTChildsub As %Float [ InitialExpression = {$i(^ARCIM($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"EXT",0))}, SqlColumnNumber = 2, SqlFieldName = EXT_Childsub ];

/// Date From
Property EXTDateFrom As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = EXT_DateFrom ];

/// Date To
Property EXTDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = EXT_DateTo ];

/// Des Ref InsType
Property EXTInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 5, SqlFieldName = EXT_InsType_DR ];

/// Code
Property EXTCode As %String(COLLATION = "Exact", MAXLEN = 64, TRUNCATE = 1) [ Required, SqlColumnNumber = 6, SqlFieldName = EXT_Code ];

/// Des Ref AuxInsType
Property EXTAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 7, SqlFieldName = EXT_AuxInsType_DR ];

/// Description
Property EXTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = EXT_Desc ];

/// Des Ref Bill Sub
Property EXTBillSubDR As ARCBillSub [ SqlColumnNumber = 9, SqlFieldName = EXT_BillSub_DR ];

/// Des Ref CTLOC_DR
Property EXTCTLOCDR As CTLoc [ SqlColumnNumber = 10, SqlFieldName = EXT_CTLOC_DR ];

/// Default Send
Property EXTDEfaultSend As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = EXT_DEfaultSend ];

/// Default Receive
Property EXTDefaultReceive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = EXT_DefaultReceive ];

/// HL7SendingApp
Property EXTHL7SendingApp As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = EXT_HL7SendingApp ];

/// HL7SendingFacility
Property EXTHL7SendingFacility As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = EXT_HL7SendingFacility ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemExternalCodes).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemExternalCodes","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemExternalCodes).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemExternalCodes","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemExternalCodes).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemExternalCodes","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemExternalCodes).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemExternalCodes","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemExternalCodes).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemExternalCodes","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="EXT_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EXT_BillSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EXT_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EXT_Code">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EXT_DEfaultSend">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EXT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EXT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EXT_DefaultReceive">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EXT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EXT_HL7SendingApp">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EXT_HL7SendingFacility">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EXT_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ARCIM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>EXT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EXT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EXT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTLOC">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>EXT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EXT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EXT_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{EXT_DateFrom}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{EXT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExtCode">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>EXT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExtCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({EXT_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EXT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsType">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>EXT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EXT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"InsType"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EXT_InsType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{EXT_DateFrom}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{EXT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EXT_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemExternalCodesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
