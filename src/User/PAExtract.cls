/// Extract(2384)
Class User.PAExtract Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Extract, StorageStrategy = SQLStorage ]
{

Relationship ChildPAExtractDetails As PAExtractDetails [ Cardinality = children, Inverse = DETParRef ];

/// Des Ref Hospital
Property EXTRHospitalDR As CTHospital [ SqlColumnNumber = 2, SqlFieldName = EXTR_Hospital_DR ];

/// ESIS Lastextract MMYY
Property EXTRESISLastMMYY As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = EXTR_ESISLastMMYY ];

/// PRS2 Last Batch StartDate
Property EXTRPRS2LastBatchStartDate As %Date [ SqlColumnNumber = 4, SqlFieldName = EXTR_PRS2LastBatchStartDate ];

/// PRS2 Last Batch Closing Date
Property EXTRPRS2LastBatchClosingDat As %Date [ SqlColumnNumber = 5, SqlFieldName = EXTR_PRS2LastBatchClosingDat ];

/// Des Ref SignifFacility
Property EXTRSignifFacilityDR As CTSignificantFacility [ SqlColumnNumber = 6, SqlFieldName = EXTR_SignifFacility_DR ];

/// BatchNumber
Property EXTRBatchNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = EXTR_BatchNumber ];

/// FileName
Property EXTRFileName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = EXTR_FileName ];

/// Des Ref RollBackUser
Property EXTRRollBackUserDR As SSUser [ SqlColumnNumber = 9, SqlFieldName = EXTR_RollBackUser_DR ];

/// RollBackDate
Property EXTRRollBackDate As %Date [ SqlColumnNumber = 10, SqlFieldName = EXTR_RollBackDate ];

/// RollBackTime
Property EXTRRollBackTime As %Time [ SqlColumnNumber = 11, SqlFieldName = EXTR_RollBackTime ];

/// ESISDateFrom
Property EXTRESISDateFrom As %Date [ SqlColumnNumber = 12, SqlFieldName = EXTR_ESISDateFrom ];

/// ESISDateTo
Property EXTRESISDateTo As %Date [ SqlColumnNumber = 13, SqlFieldName = EXTR_ESISDateTo ];

/// ESIS DateRun
Property EXTRESISDateRun As %Date [ SqlColumnNumber = 14, SqlFieldName = EXTR_ESISDateRun ];

/// ESIS Time Run
Property EXTRESISTimeRun As %Time [ SqlColumnNumber = 15, SqlFieldName = EXTR_ESISTimeRun ];

/// ESIS Internal Number
Property EXTRESISInternalNumber As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = EXTR_ESISInternalNumber ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAExtract).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAExtract","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAExtract).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAExtract","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAExtract).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAExtract","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAExtract).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAExtract","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAExtract","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAExtract).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAExtract","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PA("EXTR",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="EXTR_BatchNumber">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EXTR_ESISDateFrom">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EXTR_ESISDateRun">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EXTR_ESISDateTo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EXTR_ESISInternalNumber">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="EXTR_ESISLastMMYY">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EXTR_ESISTimeRun">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="EXTR_FileName">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EXTR_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EXTR_PRS2LastBatchClosingDat">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EXTR_PRS2LastBatchStartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EXTR_RollBackDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EXTR_RollBackTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EXTR_RollBackUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EXTR_SignifFacility_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PA</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>EXTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EXTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{EXTR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBatchNo">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EXTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EXTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"No"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({EXTR_BatchNumber})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EXTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospESISDate">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>EXTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EXTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HospDate"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EXTR_Hospital_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EXTR_ESISDateTo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EXTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospital">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EXTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EXTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EXTR_Hospital_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EXTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInternalNumber">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EXTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EXTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"IntNo"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({EXTR_ESISInternalNumber})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EXTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSignFacil">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EXTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EXTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SignFacil"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EXTR_SignifFacility_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EXTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSignFacilDate">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>EXTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EXTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SignFacilDate"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EXTR_SignifFacility_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EXTR_PRS2LastBatchClosingDat}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EXTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EXTR_RowId</SqlRowIdName>
<StreamLocation>^User.PAExtractS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
