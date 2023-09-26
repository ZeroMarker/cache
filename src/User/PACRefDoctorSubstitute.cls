/// PAC Refer Doctor Substitute(1589)
Class User.PACRefDoctorSubstitute Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_RefDoctorSubstitute, StorageStrategy = SQLStorage ]
{

/// Childsub
Property SUBSChildsub As %Float [ InitialExpression = {$i(^PAC("REFD",$p(%d(0),$c(1)),"SUBS",0))}, SqlColumnNumber = 2, SqlFieldName = SUBS_Childsub ];

/// Date From
Property SUBSDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = SUBS_DateFrom ];

/// Date To
Property SUBSDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = SUBS_DateTo ];

/// PAC_RefDoctor Parent Reference
Relationship SUBSParRef As PACRefDoctor [ Cardinality = parent, Inverse = ChildPACRefDoctorSubstitute, Required, SqlFieldName = SUBS_ParRef ];

/// Des Ref RefDoctor
Property SUBSRefDoctorDR As PACRefDoctor [ SqlColumnNumber = 5, SqlFieldName = SUBS_RefDoctor_DR ];

Index RowIDBasedIDKeyIndex On SUBSChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 2;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACRefDoctorSubstitute).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACRefDoctorSubstitute","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACRefDoctorSubstitute).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACRefDoctorSubstitute","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACRefDoctorSubstitute).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACRefDoctorSubstitute","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACRefDoctorSubstitute).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACRefDoctorSubstitute","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACRefDoctorSubstitute).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACRefDoctorSubstitute","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="SUBSChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="SUBSDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="SUBSDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="SUBSParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="SUBSRefDoctorDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="SUBS_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SUBS_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SUBS_RefDoctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_RefDoctor.REFD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SUBS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REFD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_RefDoctor.REFD_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SUBS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SUBS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_RefDoctor.REFD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>SUBS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REFD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_RefDoctor.REFD_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SUBS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SUBS_DateFrom}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SUBS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SUBS_RowId</SqlRowIdName>
<StreamLocation>^User.PACRefDoctorSubstituteS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
