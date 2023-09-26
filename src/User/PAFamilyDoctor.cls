/// PA Family Doctor(1667)
Class User.PAFamilyDoctor Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_FamilyDoctor, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On FAMDChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_PatMas Parent Reference
Relationship FAMDParRef As PAPatMas [ Cardinality = parent, Inverse = ChildPAFamilyDoctor, Required, SqlFieldName = FAMD_ParRef ];

/// Childsub
Property FAMDChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"FAMD",0))}, SqlColumnNumber = 2, SqlFieldName = FAMD_Childsub ];

/// DateFrom
Property FAMDDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = FAMD_DateFrom ];

/// DateTo
Property FAMDDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = FAMD_DateTo ];

/// Des Ref FamDoc
Property FAMDFamDocDR As PACRefDoctor [ SqlColumnNumber = 5, SqlFieldName = FAMD_FamDoc_DR ];

/// Des Ref RefDocClinc
Property FAMDRefDocClincDR As PACRefDoctorClinic [ SqlColumnNumber = 6, SqlFieldName = FAMD_RefDocClinc_DR ];

/// Update Date
Property FAMDUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = FAMD_UpdateDate ];

/// Update Time
Property FAMDUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = FAMD_UpdateTime ];

/// Des Ref UpdateUser
Property FAMDUpdateUserDR As SSUser [ SqlColumnNumber = 9, SqlFieldName = FAMD_UpdateUser_DR ];

/// Des Ref UpdateHospital
Property FAMDUpdateHospitalDR As CTHospital [ SqlColumnNumber = 10, SqlFieldName = FAMD_UpdateHospital_DR ];

/// Involvement
Property FAMDInvolvement As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = FAMD_Involvement ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAFamilyDoctor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAFamilyDoctor","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAFamilyDoctor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAFamilyDoctor","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAFamilyDoctor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAFamilyDoctor","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAFamilyDoctor).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAFamilyDoctor","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAFamilyDoctor).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAFamilyDoctor","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="FAMD_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FAMD_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FAMD_FamDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FAMD_Involvement">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="FAMD_RefDocClinc_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FAMD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FAMD_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="FAMD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="FAMD_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>FAMD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FAMD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FAMD_Childsub}</Expression>
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
<Field>FAMD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FAMD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{FAMD_DateFrom}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{FAMD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>FAMD_RowId</SqlRowIdName>
<StreamLocation>^User.PAFamilyDoctorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
