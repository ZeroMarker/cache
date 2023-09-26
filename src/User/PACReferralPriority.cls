/// PAC Referral Priority(1961)
Class User.PACReferralPriority Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ReferralPriority, StorageStrategy = SQLStorage ]
{

/// Code
Property REFPRICode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = REFPRI_Code ];

/// Description
Property REFPRIDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = REFPRI_Desc ];

/// National Code
Property REFPRINationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = REFPRI_NationalCode ];

/// Icon Name
Property REFPRIIconName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = REFPRI_IconName ];

/// Icon Priority
Property REFPRIIconPriority As %Numeric(MAXVAL = 100, MINVAL = 1, SCALE = 0) [ SqlColumnNumber = 6, SqlFieldName = REFPRI_IconPriority ];

/// Max Days Wait for Appointment
Property REFPRIMaxDaysWaitAppt As %Float [ SqlColumnNumber = 7, SqlFieldName = REFPRI_MaxDaysWaitAppt ];

/// Admission Type
Property REFPRIAdmissionType As %String(DISPLAYLIST = ",OutPatient,InPatient,Emergency,HealthPromotion", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",O,I,E,H") [ SqlColumnNumber = 8, SqlFieldName = REFPRI_AdmissionType ];

/// Date From
Property REFPRIDateFrom As %Date [ SqlColumnNumber = 9, SqlFieldName = REFPRI_DateFrom ];

/// Date To
Property REFPRIDateTo As %Date [ SqlColumnNumber = 10, SqlFieldName = REFPRI_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACReferralPriority).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACReferralPriority","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACReferralPriority).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACReferralPriority","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACReferralPriority).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACReferralPriority","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACReferralPriority).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACReferralPriority","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACReferralPriority).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACReferralPriority","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("REFPRI",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="REFPRI_AdmissionType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="REFPRI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REFPRI_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="REFPRI_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="REFPRI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REFPRI_IconName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REFPRI_IconPriority">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="REFPRI_MaxDaysWaitAppt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="REFPRI_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>REFPRI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REFPRI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{REFPRI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>REFPRI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REFPRI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({REFPRI_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REFPRI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>REFPRI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REFPRI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({REFPRI_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REFPRI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>REFPRI_RowId</SqlRowIdName>
<StreamLocation>^User.PACReferralPriorityS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
