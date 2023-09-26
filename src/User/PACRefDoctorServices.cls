/// PAC Ref Doctor Services(1593)
Class User.PACRefDoctorServices Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_RefDoctorServices, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM
Property SERARCIMDR As ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = SER_ARCIM_DR ];

/// Des Ref ARCOS
Property SERARCOSDR As ARCOrdSets [ SqlColumnNumber = 6, SqlFieldName = SER_ARCOS_DR ];

/// Childsub
Property SERChildsub As %Float [ InitialExpression = {$i(^PAC("REFD",$p(%d(0),$c(1)),"SER",0))}, SqlColumnNumber = 2, SqlFieldName = SER_Childsub ];

/// Date From
Property SERDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = SER_DateFrom ];

/// Date To
Property SERDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = SER_DateTo ];

/// Des Ref InsType
Property SERInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 7, SqlFieldName = SER_InsType_DR ];

/// Limit
Property SERLimit As %Float [ SqlColumnNumber = 8, SqlFieldName = SER_Limit ];

/// PAC_RefDoctor Parent Reference
Relationship SERParRef As PACRefDoctor [ Cardinality = parent, Inverse = ChildPACRefDoctorServices, Required, SqlFieldName = SER_ParRef ];

/// Perc
Property SERPerc As %Float [ SqlColumnNumber = 9, SqlFieldName = SER_Perc ];

Index RowIDBasedIDKeyIndex On SERChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACRefDoctorServices).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACRefDoctorServices","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACRefDoctorServices).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACRefDoctorServices","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACRefDoctorServices).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACRefDoctorServices","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACRefDoctorServices).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACRefDoctorServices","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACRefDoctorServices).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACRefDoctorServices","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SER_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SER_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SER_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SER_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SER_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SER_Limit">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SER_Perc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_RefDoctor.REFD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SER_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REFD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_RefDoctor.REFD_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SER_RowId</SqlRowIdName>
<StreamLocation>^User.PACRefDoctorServicesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
