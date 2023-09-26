/// CT Excharge Rate        (CTEXC,577)
Class User.CTExChgRate Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_ExChgRate, StorageStrategy = SQLStorage ]
{

/// Des Ref to CTCUR
Relationship CTEXCCTCURParRef As CTCurrency [ Cardinality = parent, Inverse = ChildCTExChgRate, Required, SqlFieldName = CTEXC_CTCUR_ParRef ];

/// Not Used Des Ref to CTFP
Property CTEXCCTFPDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CTEXC_CTFP_DR ];

/// CTEXC ChildSub (New Key)
Property CTEXCChildSub As %Float [ InitialExpression = {$i(^CT("CUR",$p(%d(0),$c(1),1),"EXC",0))}, Required, SqlColumnNumber = 2, SqlFieldName = CTEXC_ChildSub ];

/// Effective Date
Property CTEXCDate As %Date [ Required, SqlColumnNumber = 5, SqlFieldName = CTEXC_Date ];

/// Exchange Rate
Property CTEXCRate As %Float(MAXVAL = 999999999.9999, MINVAL = 0) [ Required, SqlColumnNumber = 3, SqlFieldName = CTEXC_Rate ];

Index RowIDBasedIDKeyIndex On CTEXCChildSub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTExChgRate).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTExChgRate","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTExChgRate).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTExChgRate","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTExChgRate).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTExChgRate","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTExChgRate).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTExChgRate","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTExChgRate).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTExChgRate","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterCTEXC">
<Data name="CTEXC_CTFP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTEXC_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTEXC_Rate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_Currency.CTCUR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CTEXC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CUR"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CT_Currency.CTCUR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"EXC"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CTEXC_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTEXCCTFPDR">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_Currency.CTCUR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>CTEXC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CUR"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CT_Currency.CTCUR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"EXC"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>"FPDR"</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{CTEXC_CTFP_DR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{CTEXC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_Currency.CTCUR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>CTEXC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CUR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_Currency.CTCUR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTEXC_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CTEXC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTEXC_RowId</SqlRowIdName>
<StreamLocation>^User.CTExChgRateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
