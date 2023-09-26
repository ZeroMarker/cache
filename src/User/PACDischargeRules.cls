/// PAC Discharge Rules(1473)
Class User.PACDischargeRules Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_DischargeRules, StorageStrategy = SQLStorage ]
{

/// Diagnosis Rank
Property RULDiagnosisRank As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = RUL_DiagnosisRank ];

/// Age
Property RULAge As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = RUL_Age ];

/// Des Ref Sex
Property RULSexDR As CTSex [ SqlColumnNumber = 4, SqlFieldName = RUL_Sex_DR ];

/// DepartmentRank
Property RULDepartmentRank As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = RUL_DepartmentRank ];

/// Trauma
Property RULTrauma As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = RUL_Trauma ];

/// Operation Rank
Property RULOperationRank As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = RUL_OperationRank ];

/// Des Ref Employee Funct
Property RULEmployeFunctDR As CTEmpFunc [ SqlColumnNumber = 8, SqlFieldName = RUL_EmployeFunct_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACDischargeRules).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDischargeRules","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACDischargeRules).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDischargeRules","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACDischargeRules).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDischargeRules","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACDischargeRules).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDischargeRules","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACDischargeRules).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDischargeRules","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDischargeRules","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("RUL",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RUL_Age">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RUL_DepartmentRank">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RUL_DiagnosisRank">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RUL_EmployeFunct_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RUL_OperationRank">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RUL_Sex_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RUL_Trauma">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RUL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RUL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RUL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RUL_RowId</SqlRowIdName>
<StreamLocation>^User.PACDischargeRulesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
