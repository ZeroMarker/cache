/// Result Escalation(2476)
Class User.OECResultEscalation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OEC_ResultEscalation, StorageStrategy = SQLStorage ]
{

/// Code
Property ESCCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ESC_Code ];

/// Description
Property ESCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ESC_Desc ];

/// Des Ref CTLOC
Property ESCCTLOCDR As CTLoc [ SqlColumnNumber = 4, SqlFieldName = ESC_CTLOC_DR ];

/// Des Ref Hospital
Property ESCHospitalDR As CTHospital [ SqlColumnNumber = 5, SqlFieldName = ESC_Hospital_DR ];

/// Main CP Days
Property ESCMainCPDays As %Float [ SqlColumnNumber = 6, SqlFieldName = ESC_MainCPDays ];

/// Head of Dep Days
Property ESCHeadDepDays As %Float [ SqlColumnNumber = 7, SqlFieldName = ESC_HeadDepDays ];

/// Head of Div Days
Property ESCHeadDivDays As %Float [ SqlColumnNumber = 8, SqlFieldName = ESC_HeadDivDays ];

/// Med Superint Days
Property ESCMedSuperintDays As %Float [ SqlColumnNumber = 9, SqlFieldName = ESC_MedSuperintDays ];

/// SP Days
Property ESCSPDays As %Float [ SqlColumnNumber = 10, SqlFieldName = ESC_SPDays ];

/// Head of Dep Grp Days
Property ESCHeadDepGrpDays As %Float [ SqlColumnNumber = 11, SqlFieldName = ESC_HeadDepGrpDays ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OECResultEscalation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECResultEscalation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OECResultEscalation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECResultEscalation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OECResultEscalation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECResultEscalation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OECResultEscalation).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECResultEscalation","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OECResultEscalation).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECResultEscalation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^OEC("RESESC",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="ESC_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ESC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ESC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ESC_HeadDepDays">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ESC_HeadDepGrpDays">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ESC_HeadDivDays">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ESC_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ESC_MainCPDays">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ESC_MedSuperintDays">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ESC_SPDays">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ESC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RESESC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ESC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ESC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RESESC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ESC_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ESC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ESC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RESESC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ESC_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ESC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ESC_RowId</SqlRowIdName>
<StreamLocation>^User.OECResultEscalationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
