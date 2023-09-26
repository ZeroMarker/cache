/// ARC Specialist Surcharge(1114)
Class User.ARCSpecialistSurcharge Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_SpecialistSurcharge, StorageStrategy = SQLStorage ]
{

/// Des Ref to CTCPType
Property SPSURCTCPTypDR As CTCarPrvTp [ SqlColumnNumber = 5, SqlFieldName = SPSUR_CTCPTyp_DR ];

/// Date From
Property SPSURDateFrom As %Date [ SqlColumnNumber = 2, SqlFieldName = SPSUR_DateFrom ];

/// Date To
Property SPSURDateTo As %Date [ SqlColumnNumber = 3, SqlFieldName = SPSUR_DateTo ];

/// Percentage
Property SPSURPerc As %Float [ SqlColumnNumber = 4, SqlFieldName = SPSUR_Perc ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCSpecialistSurcharge).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSpecialistSurcharge","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCSpecialistSurcharge).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSpecialistSurcharge","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCSpecialistSurcharge).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSpecialistSurcharge","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCSpecialistSurcharge).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSpecialistSurcharge","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCSpecialistSurcharge).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSpecialistSurcharge","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="SPSURCTCPTypDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SPSURDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SPSURDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SPSURPerc">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^ARC("SPSUR",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SPSUR_CTCPTyp_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SPSUR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SPSUR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SPSUR_Perc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SPSUR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SPSUR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SPSUR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SPSUR_RowId</SqlRowIdName>
<StreamLocation>^User.ARCSpecialistSurchargeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
