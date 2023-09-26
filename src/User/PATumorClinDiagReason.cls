/// TumorClinDiagReason(2229)
Class User.PATumorClinDiagReason Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_TumorClinDiagReason, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CDRChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Tumor Parent Reference
Relationship CDRParRef As PATumor [ Cardinality = parent, Inverse = ChildPATumorClinDiagReason, Required, SqlFieldName = CDR_ParRef ];

/// Childsub
Property CDRChildsub As %Float [ InitialExpression = {$i(^PATUM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CDR",0))}, SqlColumnNumber = 2, SqlFieldName = CDR_Childsub ];

/// Des Ref ClinDiagReason
Property CDRClinDiagReasonDR As MRCClinDiagnReason [ SqlColumnNumber = 3, SqlFieldName = CDR_ClinDiagReason_DR ];

/// Comment
Property CDRComment As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CDR_Comment ];

/// UpdateDate
Property CDRUpdateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = CDR_UpdateDate ];

/// UpdateTime
Property CDRUpdateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = CDR_UpdateTime ];

/// Des REf UpdateUser
Property CDRUpdateUserDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = CDR_UpdateUser_DR ];

/// Des Ref UpdateUserHospital
Property CDRUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 8, SqlFieldName = CDR_UpdateUserHospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PATumorClinDiagReason).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATumorClinDiagReason","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PATumorClinDiagReason).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATumorClinDiagReason","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PATumorClinDiagReason).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATumorClinDiagReason","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PATumorClinDiagReason).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATumorClinDiagReason","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PATumorClinDiagReason).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATumorClinDiagReason","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CDR_ClinDiagReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CDR_Comment">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CDR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CDR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CDR_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CDR_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PATUM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Tumor.TUM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CDR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Tumor.TUM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CDR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUpdDate">
<Global>^PATUM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_Tumor.TUM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>CDR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CDRUpdDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CDR_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_Tumor.TUM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CDR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CDR_RowId</SqlRowIdName>
<StreamLocation>^User.PATumorClinDiagReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
