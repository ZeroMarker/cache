/// MR System Review(1081)
Class User.MRSystemReview Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_SystemReview, StorageStrategy = SQLStorage ]
{

/// Des Ref CTCP
Property SYSRCTCPDR As CTCareProv [ SqlColumnNumber = 8, SqlFieldName = SYSR_CTCP_DR ];

/// Childsub
Property SYSRChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SYSR",0))}, SqlColumnNumber = 2, SqlFieldName = SYSR_Childsub ];

/// Date
Property SYSRDate As %Date [ SqlColumnNumber = 6, SqlFieldName = SYSR_Date ];

/// Description
Property SYSRDesc As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = SYSR_Desc, SqlListType = SUBNODE ];

/// Des Ref MRCBodSysProbSub
Property SYSRMRCBodSysProbSub As MRCBodySystemProblemSubp [ SqlColumnNumber = 10, SqlFieldName = SYSR_MRCBodSysProbSub ];

/// Des Ref to MRCBodySys
Property SYSRMRCBodySysDR As MRCBodySystems [ SqlColumnNumber = 3, SqlFieldName = SYSR_MRCBodySys_DR ];

/// Des Ref to MRCBodySysPrStat
Property SYSRMRCBodySysPrStatDR As MRCBodySystemProbStatus [ SqlColumnNumber = 5, SqlFieldName = SYSR_MRCBodySysPrStat_DR ];

/// Des Ref to MRCBodySysProb
Property SYSRMRCBodySysProbDR As MRCBodySystemProblem [ SqlColumnNumber = 4, SqlFieldName = SYSR_MRCBodySysProb_DR ];

/// MR_Adm Parent Reference
Relationship SYSRParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRSystemReview, Required, SqlFieldName = SYSR_ParRef ];

/// Time
Property SYSRTime As %Time [ SqlColumnNumber = 7, SqlFieldName = SYSR_Time ];

/// UpdateDate
Property SYSRUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = SYSR_UpdateDate ];

/// Des Ref UpdateHospital
Property SYSRUpdateHospitalDR As CTHospital [ SqlColumnNumber = 14, SqlFieldName = SYSR_UpdateHospital_DR ];

/// UpdateTime
Property SYSRUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = SYSR_UpdateTime ];

/// Des Ref User
Property SYSRUpdateUserDR As SSUser [ SqlColumnNumber = 11, SqlFieldName = SYSR_UpdateUser_DR ];

Index RowIDBasedIDKeyIndex On SYSRChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 5;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRSystemReview).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSystemReview","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRSystemReview).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSystemReview","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRSystemReview).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSystemReview","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRSystemReview).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSystemReview","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRSystemReview).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSystemReview","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>5</ExtentSize>
<Property name="SYSRCTCPDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SYSRChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="SYSRDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="SYSRDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="SYSRMRCBodSysProbSub">
<Selectivity>1</Selectivity>
</Property>
<Property name="SYSRMRCBodySysDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SYSRMRCBodySysPrStatDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SYSRMRCBodySysProbDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SYSRParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="SYSRTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="SYSRUpdateDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="SYSRUpdateHospitalDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SYSRUpdateTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="SYSRUpdateUserDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="SYSR_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SYSR_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SYSR_Desc">
<Node>"REM"</Node>
</Data>
<Data name="SYSR_MRCBodSysProbSub">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SYSR_MRCBodySysPrStat_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SYSR_MRCBodySysProb_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SYSR_MRCBodySys_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SYSR_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SYSR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SYSR_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SYSR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SYSR_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SYSR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SYSR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SYSR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SYSR_RowId</SqlRowIdName>
<StreamLocation>^User.MRSystemReviewS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
