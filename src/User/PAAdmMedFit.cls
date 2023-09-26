/// PA Adm Medic Fit(2017)
Class User.PAAdmMedFit Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmMedFit, StorageStrategy = SQLStorage ]
{

/// Childsub
Property MFChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"MF",0))}, SqlColumnNumber = 2, SqlFieldName = MF_Childsub ];

/// Date Med Fit
Property MFDateMedFit As %Date [ SqlColumnNumber = 3, SqlFieldName = MF_DateMedFit ];

/// Date Med Unfit
Property MFDateMedUnfit As %Date [ SqlColumnNumber = 5, SqlFieldName = MF_DateMedUnfit ];

/// PA_Adm Parent Reference
Relationship MFParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmMedFit, Required, SqlFieldName = MF_ParRef ];

/// Des Ref ReasonDelDisch_DR
Property MFReasonDelDischDR As PACReasonDelayDischarge [ SqlColumnNumber = 7, SqlFieldName = MF_ReasonDelDisch_DR ];

/// Time Med Fit
Property MFTimeMedFit As %Time [ SqlColumnNumber = 4, SqlFieldName = MF_TimeMedFit ];

/// Time Med Unfit
Property MFTimeMedUnfit As %Time [ SqlColumnNumber = 6, SqlFieldName = MF_TimeMedUnfit ];

/// UpdateDate
Property MFUpdateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = MF_UpdateDate ];

/// UpdateTime
Property MFUpdateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = MF_UpdateTime ];

/// Des Ref UpdateUser
Property MFUpdateUserDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = MF_UpdateUser_DR ];

/// Des Ref UpdateUserHospital
Property MFUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 11, SqlFieldName = MF_UpdateUserHospital_DR ];

Index RowIDBasedIDKeyIndex On MFChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 122;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmMedFit).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmMedFit","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmMedFit).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmMedFit","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmMedFit).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmMedFit","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmMedFit).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmMedFit","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmMedFit).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmMedFit","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>122</ExtentSize>
<Property name="MFChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="MFDateMedFit">
<Selectivity>1</Selectivity>
</Property>
<Property name="MFDateMedUnfit">
<Selectivity>1</Selectivity>
</Property>
<Property name="MFParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="MFReasonDelDischDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MFTimeMedFit">
<Selectivity>1</Selectivity>
</Property>
<Property name="MFTimeMedUnfit">
<Selectivity>1</Selectivity>
</Property>
<Property name="MFUpdateDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="MFUpdateTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="MFUpdateUserDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MFUpdateUserHospitalDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="MF_DateMedFit">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MF_DateMedUnfit">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MF_ReasonDelDisch_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MF_TimeMedFit">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MF_TimeMedUnfit">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MF_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MF_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MF_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MF_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MF_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MF_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MF_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmMedFitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
