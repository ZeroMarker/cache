/// Referral Doctor Clinic Sess(1595)
Class User.PACRefDoctorClinicSession Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_RefDoctorClinicSession, StorageStrategy = SQLStorage ]
{

/// Childsub
Property SESSChildsub As %Float [ InitialExpression = {$i(^PAC("REFD",$p(%d(0),"||"),"CLN",$p(%d(0),"||",2),"SESS",0))}, SqlColumnNumber = 2, SqlFieldName = SESS_Childsub ];

/// Des Ref DOW
Property SESSDOWDR As CTDayOfWeek [ SqlColumnNumber = 3, SqlFieldName = SESS_DOW_DR ];

/// Date From
Property SESSDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = SESS_DateFrom ];

/// Date To
Property SESSDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = SESS_DateTo ];

/// SESSion No
Property SESSNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SESS_No ];

/// PAC_RefDoctorClinic Parent Reference
Relationship SESSParRef As PACRefDoctorClinic [ Cardinality = parent, Inverse = ChildPACRefDoctorClinicSession, Required, SqlFieldName = SESS_ParRef ];

/// Time From
Property SESSTimeFrom As %Time [ SqlColumnNumber = 7, SqlFieldName = SESS_TimeFrom ];

/// Time To
Property SESSTimeTo As %Time [ SqlColumnNumber = 8, SqlFieldName = SESS_TimeTo ];

Index RowIDBasedIDKeyIndex On SESSChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACRefDoctorClinicSession).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACRefDoctorClinicSession","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACRefDoctorClinicSession).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACRefDoctorClinicSession","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACRefDoctorClinicSession).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACRefDoctorClinicSession","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACRefDoctorClinicSession).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACRefDoctorClinicSession","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACRefDoctorClinicSession).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACRefDoctorClinicSession","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SESS_DOW_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SESS_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SESS_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SESS_No">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SESS_TimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SESS_TimeTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_RefDoctor.REFD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PAC_RefDoctorClinic.CLN_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>SESS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REFD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_RefDoctor.REFD_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CLN"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAC_RefDoctorClinic.CLN_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SESS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SESS_RowId</SqlRowIdName>
<StreamLocation>^User.PACRefDoctorClinicSessionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
