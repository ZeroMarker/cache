/// TreatmentProgress(2766)
Class User.PATreatmentProgress Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_TreatmentProgress, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On TRPRChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_PatMas Parent Reference
Relationship TRPRParRef As PAPatMas [ Cardinality = parent, Inverse = ChildPATreatmentProgress, Required, SqlFieldName = TRPR_ParRef ];

/// Childsub
Property TRPRChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"TRPR",0))}, SqlColumnNumber = 2, SqlFieldName = TRPR_Childsub ];

/// RefDate
Property TRPRRefDate As %Date [ SqlColumnNumber = 3, SqlFieldName = TRPR_RefDate ];

/// TreatmentDate
Property TRPRTreatmentDate As %Date [ SqlColumnNumber = 4, SqlFieldName = TRPR_TreatmentDate ];

/// Text1
Property TRPRText1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = TRPR_Text1 ];

/// Text2
Property TRPRText2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = TRPR_Text2 ];

/// Des Ref TreatReason
Property TRPRTreatReasonDR As PACTreatmentReason [ SqlColumnNumber = 7, SqlFieldName = TRPR_TreatReason_DR ];

/// UpdateDate
Property TRPRUpdateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = TRPR_UpdateDate ];

/// UpdateTime
Property TRPRUpdateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = TRPR_UpdateTime ];

/// Des Ref UpdateUser
Property TRPRUpdateUserDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = TRPR_UpdateUser_DR ];

/// Des Ref UpdateHospital
Property TRPRUpdateHospitalDR As CTHospital [ SqlColumnNumber = 11, SqlFieldName = TRPR_UpdateHospital_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PATreatmentProgress).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATreatmentProgress","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PATreatmentProgress).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATreatmentProgress","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PATreatmentProgress).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATreatmentProgress","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PATreatmentProgress).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATreatmentProgress","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATreatmentProgress","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PATreatmentProgress).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATreatmentProgress","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="TRPR_RefDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TRPR_Text1">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TRPR_Text2">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TRPR_TreatReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TRPR_TreatmentDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TRPR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TRPR_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TRPR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TRPR_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>TRPR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TRPR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRPR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>TRPR_RowId</SqlRowIdName>
<StreamLocation>^User.PATreatmentProgressS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
