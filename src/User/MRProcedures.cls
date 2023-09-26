/// MR Procedures(1669)
Class User.MRProcedures Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_Procedures, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 4553;

Index RowIDBasedIDKeyIndex On PROCChildsub [ IdKey, PrimaryKey, Unique ];

/// MR_Adm Parent Reference
Relationship PROCParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRProcedures, Required, SqlFieldName = PROC_ParRef ];

/// Childsub
Property PROCChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PROC",0))}, SqlColumnNumber = 2, SqlFieldName = PROC_Childsub ];

/// Des Ref Operation
Property PROCOperationDR As ORCOperation [ SqlColumnNumber = 3, SqlFieldName = PROC_Operation_DR ];

/// Des Ref OperCategory
Property PROCOperCategoryDR As ORCOperationCategory [ SqlColumnNumber = 4, SqlFieldName = PROC_OperCategory_DR ];

/// DRG Rank
Property PROCDRGRank As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PROC_DRGRank ];

/// Date
Property PROCDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PROC_Date ];

/// Time
Property PROCTime As %Time [ SqlColumnNumber = 7, SqlFieldName = PROC_Time ];

/// Des Ref User
Property PROCUserDR As SSUser [ SqlColumnNumber = 8, SqlFieldName = PROC_User_DR ];

/// Des Ref Appoint
Property PROCAppointDR As RBAppointment [ SqlColumnNumber = 9, SqlFieldName = PROC_Appoint_DR ];

/// Des Ref Transact
Property PROCTransactDR As PAAdmTransaction [ SqlColumnNumber = 10, SqlFieldName = PROC_Transact_DR ];

/// Proc Date
Property PROCProcDate As %Date [ SqlColumnNumber = 11, SqlFieldName = PROC_ProcDate ];

/// Des Ref CTCP
Property PROCCTCPDR As CTCareProv [ SqlColumnNumber = 12, SqlFieldName = PROC_CTCP_DR ];

/// Prim Second
Property PROCPrimSecond As %String(DISPLAYLIST = ",Primary,Secondary", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",P,S") [ SqlColumnNumber = 13, SqlFieldName = PROC_PrimSecond ];

/// FirstInset
Property PROCFirstInset As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = PROC_FirstInset ];

/// Des Ref MappedProc
Property PROCMappedProcDR As ORCOperation [ SqlColumnNumber = 15, SqlFieldName = PROC_MappedProc_DR ];

/// Des Ref ContractFlag
Property PROCContractFlagDR As MRCContractFlag [ SqlColumnNumber = 16, SqlFieldName = PROC_ContractFlag_DR ];

/// Des Ref UpdateHospital
Property PROCUpdateHospitalDR As CTHospital [ SqlColumnNumber = 17, SqlFieldName = PROC_UpdateHospital_DR ];

/// TimeStart
Property PROCTimeStart As %Time [ SqlColumnNumber = 18, SqlFieldName = PROC_TimeStart ];

/// TimeEnd
Property PROCTimeEnd As %Time [ SqlColumnNumber = 19, SqlFieldName = PROC_TimeEnd ];

/// AliasDiagText
Property PROCAliasDiagText As %String(COLLATION = "Exact", MAXLEN = 70, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = PROC_AliasDiagText ];

/// Des Ref Anaesthetist
Property PROCAnaesthetistDR As CTCareProv [ SqlColumnNumber = 21, SqlFieldName = PROC_Anaesthetist_DR ];

/// DSReportFlag
Property PROCDSReportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = PROC_DSReportFlag ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRProcedures).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRProcedures","OnAfterDelete")
 d Table^HL7Outbound("MRProcedures",%old(1),"Delete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRProcedures).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRProcedures","OnAfterInsert")
 d Table^HL7Outbound("MRProcedures",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRProcedures).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRProcedures","OnAfterUpdate")
 d Table^HL7Outbound("MRProcedures",%d(1),"Update")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRProcedures).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRProcedures","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRProcedures).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRProcedures","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4553</ExtentSize>
<Property name="PROCAliasDiagText">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="PROCAnaesthetistDR">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="PROCAppointDR">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="PROCCTCPDR">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="PROCChildsub">
<Selectivity>5.8823%</Selectivity>
</Property>
<Property name="PROCContractFlagDR">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="PROCDRGRank">
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="PROCDSReportFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PROCDate">
<Selectivity>0.9337%</Selectivity>
</Property>
<Property name="PROCFirstInset">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PROCMappedProcDR">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="PROCOperCategoryDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PROCOperationDR">
<Selectivity>0.9337%</Selectivity>
</Property>
<Property name="PROCParRef">
<Selectivity>0.0703%</Selectivity>
</Property>
<Property name="PROCPrimSecond">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PROCProcDate">
<Selectivity>7.1429%</Selectivity>
</Property>
<Property name="PROCTime">
<Selectivity>1.5727%</Selectivity>
</Property>
<Property name="PROCTimeEnd">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="PROCTimeStart">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="PROCTransactDR">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="PROCUpdateHospitalDR">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="PROCUserDR">
<Selectivity>14.2857%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="PROC_AliasDiagText">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PROC_Anaesthetist_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PROC_Appoint_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PROC_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PROC_ContractFlag_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PROC_DRGRank">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PROC_DSReportFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PROC_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PROC_FirstInset">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PROC_MappedProc_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PROC_OperCategory_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PROC_Operation_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PROC_PrimSecond">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PROC_ProcDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PROC_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PROC_TimeEnd">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PROC_TimeStart">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PROC_Transact_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PROC_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PROC_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PROC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PROC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PROC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAppoint">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PROC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PROCAPPT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PROC_Appoint_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PROC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTransact">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PROC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PROCTRANS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PROC_Transact_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PROC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PROC_RowId</SqlRowIdName>
<StreamLocation>^User.MRProceduresS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
