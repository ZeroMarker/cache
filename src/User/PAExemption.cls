/// PA Exemption(1591)
Class User.PAExemption Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Exemption, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On EXChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildPAExemptionItems As PAExemptionItems [ Cardinality = children, Inverse = ITMParRef ];

/// PA_PatMas Parent Reference
Relationship EXParRef As PAPatMas [ Cardinality = parent, Inverse = ChildPAExemption, Required, SqlFieldName = EX_ParRef ];

/// Childsub
Property EXChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"EX",0))}, SqlColumnNumber = 2, SqlFieldName = EX_Childsub ];

/// Date From
Property EXDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = EX_DateFrom ];

/// Date To
Property EXDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = EX_DateTo ];

/// Des Ref Reason
Property EXReason As PACExemptionReason [ SqlColumnNumber = 5, SqlFieldName = EX_Reason ];

/// Number
Property EXNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = EX_Number ];

/// Des Ref Location
Property EXLocationDR As CTLoc [ SqlColumnNumber = 7, SqlFieldName = EX_Location_DR ];

/// Remarks
Property EXRemarks As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = EX_Remarks, SqlListType = subnode ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAExemption).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAExemption","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAExemption).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAExemption","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAExemption).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAExemption","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAExemption).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAExemption","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAExemption","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAExemption).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAExemption","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="EX_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EX_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EX_Location_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EX_Number">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EX_Reason">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EX_Remarks">
<Node>"REM"</Node>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>EX_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EX"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EX_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^PAPER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>EX_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EX"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EX_DateFrom}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EX_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EX_RowId</SqlRowIdName>
<StreamLocation>^User.PAExemptionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
