/// PA SMR Extract Build(2012)
Class User.PASMRExtractBuild Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_SMRExtractBuild, StorageStrategy = SQLStorage ]
{

/// Start Date
Property SMREBStartDate As %Date [ SqlColumnNumber = 2, SqlFieldName = SMREB_StartDate ];

/// End Date
Property SMREBEndDate As %Date [ SqlColumnNumber = 3, SqlFieldName = SMREB_EndDate ];

/// Run Date
Property SMREBRunDate As %Date [ SqlColumnNumber = 4, SqlFieldName = SMREB_RunDate ];

/// Run Time
Property SMREBRunTime As %Time [ SqlColumnNumber = 5, SqlFieldName = SMREB_RunTime ];

/// Des Ref User
Property SMREBUserDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = SMREB_User_DR ];

/// Record Type
Property SMREBRecordType As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = SMREB_RecordType ];

/// Last Sent
Property SMREBLastSent As %Date [ SqlColumnNumber = 8, SqlFieldName = SMREB_LastSent ];

/// Des Ref User
Property SMREBSentByUserDR As SSUser [ SqlColumnNumber = 9, SqlFieldName = SMREB_SentByUser_DR ];

/// Batch Number
Property SMREBBatchNumber As %Float [ SqlColumnNumber = 10, SqlFieldName = SMREB_BatchNumber ];

/// Status
Property SMREBStatus As %String(DISPLAYLIST = ",Running,Complete,Abort,Accepted,Sent,Rejected", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",R,C,A,P,S,J") [ SqlColumnNumber = 11, SqlFieldName = SMREB_Status ];

/// Batch Count
Property SMREBBatchCount As %Float [ SqlColumnNumber = 12, SqlFieldName = SMREB_BatchCount ];

/// Extract Count
Property SMREBExtractCount As %Float [ SqlColumnNumber = 13, SqlFieldName = SMREB_ExtractCount ];

/// Des Ref AcceptRejectUser
Property SMREBAcceptRejectUserDR As SSUser [ SqlColumnNumber = 14, SqlFieldName = SMREB_AcceptRejectUser_DR ];

/// AcceptRejectDate
Property SMREBAcceptRejectDate As %Date [ SqlColumnNumber = 15, SqlFieldName = SMREB_AcceptRejectDate ];

/// AcceptRejectTime
Property SMREBAcceptRejectTime As %Time [ SqlColumnNumber = 16, SqlFieldName = SMREB_AcceptRejectTime ];

/// Des Ref AcceptRejectHospital_DR
Property SMREBAcceptRejectHospitalDR As CTHospital [ SqlColumnNumber = 17, SqlFieldName = SMREB_AcceptRejectHospital_DR ];

/// Des Ref LastUpdateUser
Property SMREBLastUpdateUserDR As SSUser [ SqlColumnNumber = 18, SqlFieldName = SMREB_LastUpdateUser_DR ];

/// Des Ref Hospital
Property SMREBHospitalDR As CTHospital [ SqlColumnNumber = 19, SqlFieldName = SMREB_Hospital_DR ];

/// Des Ref LastUserHospital
Property SMREBLastUserHospitalDR As CTHospital [ SqlColumnNumber = 20, SqlFieldName = SMREB_LastUserHospital_DR ];

/// Des Ref RunLocation
Property SMREBRunLocationDR As CTLoc [ SqlColumnNumber = 21, SqlFieldName = SMREB_RunLocation_DR ];

/// Des Ref PAExtract
Property SMREBPAExtractDR As PAExtract [ SqlColumnNumber = 22, SqlFieldName = SMREB_PAExtract_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PASMRExtractBuild).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRExtractBuild","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PASMRExtractBuild).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRExtractBuild","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PASMRExtractBuild).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRExtractBuild","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PASMRExtractBuild).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRExtractBuild","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRExtractBuild","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PASMRExtractBuild).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRExtractBuild","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PASMREB(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SMREB_AcceptRejectDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SMREB_AcceptRejectHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SMREB_AcceptRejectTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SMREB_AcceptRejectUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SMREB_BatchCount">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SMREB_BatchNumber">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SMREB_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SMREB_ExtractCount">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SMREB_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SMREB_LastSent">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SMREB_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SMREB_LastUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SMREB_PAExtract_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="SMREB_RecordType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SMREB_RunDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SMREB_RunLocation_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="SMREB_RunTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SMREB_SentByUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SMREB_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SMREB_Status">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SMREB_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PASMREB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SMREB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SMREB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBatchNumber">
<Global>^PASMEBi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SMREB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Batch"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SMREB_RecordType}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMREB_BatchNumber}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SMREB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHosp1">
<Global>^PASMEBi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>SMREB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Hosp1"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SMREB_Hospital_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMREB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospital">
<Global>^PASMEBi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SMREB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SMREB_Hospital_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMREB_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SMREB_EndDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SMREB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SMREB_RowId</SqlRowIdName>
<StreamLocation>^User.PASMRExtractBuildS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
