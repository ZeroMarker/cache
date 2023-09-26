/// CareProvORPref(2668)
Class User.CTCareProvORPref Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_CareProvORPref, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ORPChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildCTCareProvORPrefEq As CTCareProvORPrefEq [ Cardinality = children, Inverse = EQParRef ];

/// CT_CareProv Parent Reference
Relationship ORPParRef As CTCareProv [ Cardinality = parent, Inverse = ChildCTCareProvORPref, Required, SqlFieldName = ORP_ParRef ];

/// Childsub
Property ORPChildsub As %Float [ InitialExpression = {$i(^CTPCP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ORP",0))}, SqlColumnNumber = 2, SqlFieldName = ORP_Childsub ];

/// Des Ref Operation
Property ORPOperationDR As ORCOperation [ SqlColumnNumber = 3, SqlFieldName = ORP_Operation_DR ];

/// Des Ref StatePPP
Property ORPStatePPPDR As PACStatePPP [ SqlColumnNumber = 4, SqlFieldName = ORP_StatePPP_DR ];

/// Text1
Property ORPText1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ORP_Text1 ];

/// Turnaround Time
Property ORPTurnaroundTime As %Float [ SqlColumnNumber = 6, SqlFieldName = ORP_TurnaroundTime ];

/// ExpectedLOS
Property ORPExpectedLOS As %Float [ SqlColumnNumber = 7, SqlFieldName = ORP_ExpectedLOS ];

/// AverageProcTime
Property ORPAverageProcTime As %Float [ SqlColumnNumber = 8, SqlFieldName = ORP_AverageProcTime ];

/// CalcAvgPrevDetails
Property ORPCalcAvgPrevDetails As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = ORP_CalcAvgPrevDetails ];

/// Des Ref AnaestMethod
Property ORPAnaestMethodDR As ORCAnaestMethod [ SqlColumnNumber = 10, SqlFieldName = ORP_AnaestMethod_DR ];

/// Des Ref RecovOperation
Property ORPRecovOperationDR As ORCOperation [ SqlColumnNumber = 11, SqlFieldName = ORP_RecovOperation_DR ];

/// Des Ref RecovStatePPP
Property ORPRecovStatePPPDR As PACStatePPP [ SqlColumnNumber = 12, SqlFieldName = ORP_RecovStatePPP_DR ];

/// RecovText
Property ORPRecovText As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = ORP_RecovText ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTCareProvORPref).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProvORPref","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTCareProvORPref).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProvORPref","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTCareProvORPref).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProvORPref","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTCareProvORPref).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProvORPref","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTCareProvORPref).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProvORPref","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="ORP_AnaestMethod_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ORP_AverageProcTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ORP_CalcAvgPrevDetails">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ORP_ExpectedLOS">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ORP_Operation_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ORP_RecovOperation_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ORP_RecovStatePPP_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ORP_RecovText">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ORP_StatePPP_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ORP_Text1">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ORP_TurnaroundTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^CTPCP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ORP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAnMeth">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ORP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"AnMeth"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ORP_AnaestMethod_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ORP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOper">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ORP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Oper"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ORP_Operation_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ORP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecovOper">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ORP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"RecovOper"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ORP_RecovOperation_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ORP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecovSPPP">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ORP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"RecovSPPP"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ORP_RecovStatePPP_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ORP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSPPP">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ORP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"SPPP"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ORP_StatePPP_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ORP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ORP_RowId</SqlRowIdName>
<StreamLocation>^User.CTCareProvORPrefS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
