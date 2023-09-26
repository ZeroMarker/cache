/// MRC DRG Type(1471)
Class User.MRCDRGType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_DRGType, StorageStrategy = SQLStorage ]
{

/// Code
Property DRGTYPCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = DRGTYP_Code ];

/// Description
Property DRGTYPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DRGTYP_Desc ];

/// LongDescription
Property DRGTYPLongDescription As %String(COLLATION = "Exact", MAXLEN = 230, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DRGTYP_LongDescription ];

/// DRG Version DR
Property DRGTYPDRGVersion As MRCDRGVersion [ SqlColumnNumber = 5, SqlFieldName = DRGTYP_DRGVersion ];

/// Cost Weight Edition DR
Property DRGTYPCostWeightEditDR As MRCCostWeightEdition [ SqlColumnNumber = 6, SqlFieldName = DRGTYP_CostWeightEditDR ];

Index DRGTYPCodeUnqIdx1 On DRGTYPCode [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCDRGType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCDRGType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCDRGType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCDRGType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCDRGType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^MRC("DRGTYP",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DRGTYP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRGTYP_CostWeightEditDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRGTYP_DRGVersion">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRGTYP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRGTYP_LongDescription">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DRGTYP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRGTYP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRGTYP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DRGTYP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRGTYP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DRGTYP_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRGTYP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DRGTYP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRGTYP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DRGTYP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRGTYP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DRGTYP_RowId</SqlRowIdName>
<StreamLocation>^User.MRCDRGTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
