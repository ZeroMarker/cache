/// PersonInsurance(2457)
Class User.PAPersonInsurance Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PersonInsurance, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On INSChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Person Parent Reference
Relationship INSParRef As PAPerson [ Cardinality = parent, Inverse = ChildPAPersonInsurance, Required, SqlFieldName = INS_ParRef ];

/// Childsub
Property INSChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"INS",0))}, SqlColumnNumber = 2, SqlFieldName = INS_Childsub ];

/// Date From
Property INSDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = INS_DateFrom ];

/// Date To
Property INSDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = INS_DateTo ];

/// Des Ref InsType
Property INSInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 5, SqlFieldName = INS_InsType_DR ];

/// Update Date
Property INSUpdateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = INS_UpdateDate ];

/// Update Time
Property INSUpdateTime As %Time [ SqlColumnNumber = 7, SqlFieldName = INS_UpdateTime ];

/// Des Ref UpdateUser
Property INSUpdateUserDR As SSUser [ SqlColumnNumber = 8, SqlFieldName = INS_UpdateUser_DR ];

/// Des Ref UpdateHospital
Property INSUpdateHospitalDR As CTHospital [ SqlColumnNumber = 9, SqlFieldName = INS_UpdateHospital_DR ];

/// Des Ref AuxInsType
Property INSAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 10, SqlFieldName = INS_AuxInsType_DR ];

/// HealthFundNo
Property INSHealthFundNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = INS_HealthFundNo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPersonInsurance).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonInsurance","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPersonInsurance).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonInsurance","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPersonInsurance).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonInsurance","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPersonInsurance).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonInsurance","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPersonInsurance).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonInsurance","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="INS_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INS_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INS_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INS_HealthFundNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INS_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INS_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INS_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INS_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>INS_RowId</SqlRowIdName>
<StreamLocation>^User.PAPersonInsuranceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
