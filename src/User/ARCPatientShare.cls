/// ARC Patient Share(1113)
Class User.ARCPatientShare Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PatientShare, StorageStrategy = SQLStorage ]
{

/// Des Ref to AuxInsType
Property PATSHAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 10, SqlFieldName = PATSH_AuxInsType_DR ];

/// Date From
Property PATSHDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = PATSH_DateFrom ];

/// Date To
Property PATSHDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = PATSH_DateTo ];

/// IP Govern %
Property PATSHIPGovernPerc As %Float [ SqlColumnNumber = 7, SqlFieldName = PATSH_IPGovernPerc ];

/// IP Patient %
Property PATSHIPPatPerc As %Float [ SqlColumnNumber = 11, SqlFieldName = PATSH_IPPatPerc ];

/// Des Ref to ARCInsTyp
Property PATSHInsTypDR As ARCInsuranceType [ SqlColumnNumber = 6, SqlFieldName = PATSH_InsTyp_DR ];

/// OP Government %
Property PATSHOPGovernPerc As %Float [ SqlColumnNumber = 8, SqlFieldName = PATSH_OPGovernPerc ];

/// OP Patient %
Property PATSHOPPatPerc As %Float [ SqlColumnNumber = 9, SqlFieldName = PATSH_OPPatPerc ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPatientShare).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPatientShare","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPatientShare).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPatientShare","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPatientShare).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPatientShare","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPatientShare).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPatientShare","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPatientShare).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPatientShare","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="PATSHAuxInsTypeDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PATSHDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PATSHDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PATSHIPGovernPerc">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PATSHIPPatPerc">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PATSHInsTypDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PATSHOPGovernPerc">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PATSHOPPatPerc">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^ARC("PATSH",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PATSH_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PATSH_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PATSH_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PATSH_IPGovernPerc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PATSH_IPPatPerc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PATSH_InsTyp_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PATSH_OPGovernPerc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PATSH_OPPatPerc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PATSH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PATSH"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PATSH_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PATSH_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPatientShareS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
