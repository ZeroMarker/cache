Class dhc.qm.data.LocResultMain Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LocResultMain_rowid, SqlTableName = LocResultMain ]
{

/// LocResultMain_Plandr
Property LocResultMainPlandr As dhc.qm.data.Plan [ SqlColumnNumber = 2, SqlFieldName = LocResultMain_Plandr ];

/// LocResultMain_schemDr
Property LocResultMainschemDr As dhc.qm.data.QMSchem [ SqlColumnNumber = 3, SqlFieldName = LocResultMain_schemDr ];

/// LocResultMain_departDr
Property LocResultMaindepartDr As User.RBCDepartmentGroup [ SqlColumnNumber = 4, SqlFieldName = LocResultMain_departDr ];

/// LocResultMain_period
Property LocResultMainperiod As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = LocResultMain_period ];

/// LocResultMain_wardDr
Property LocResultMainwardDr As User.PACWard [ SqlColumnNumber = 6, SqlFieldName = LocResultMain_wardDr ];

/// LocResultMain_auditDr
Property LocResultMainauditDr As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = LocResultMain_auditDr ];

/// LocResultMain_auditDate
Property LocResultMainauditDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = LocResultMain_auditDate ];

/// LocResultMain_auditState 1：提交 0：未提交 2：取消提交
Property LocResultMainauditState As %Library.Integer [ SqlColumnNumber = 9, SqlFieldName = LocResultMain_auditState ];

/// LocResultMain_failNum
Property LocResultMainfailNum As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = LocResultMain_failNum ];

Index departDr On LocResultMaindepartDr;

Index QMSchemDr On LocResultMainschemDr;

Index period On LocResultMainperiod;

Index periodQMSchemDrDepartDr On (LocResultMainperiod, LocResultMainschemDr, LocResultMaindepartDr);

Index periodQMSchemDrDepartDrWard On (LocResultMainperiod, LocResultMainschemDr, LocResultMaindepartDr, LocResultMainwardDr);

Index periodQMSDWP On (LocResultMainPlandr, LocResultMainperiod, LocResultMainschemDr, LocResultMaindepartDr, LocResultMainwardDr);

Storage Default
{
<Data name="LocResultMainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LocResultMainPlandr</Value>
</Value>
<Value name="3">
<Value>LocResultMainschemDr</Value>
</Value>
<Value name="4">
<Value>LocResultMaindepartDr</Value>
</Value>
<Value name="5">
<Value>LocResultMainperiod</Value>
</Value>
<Value name="6">
<Value>LocResultMainwardDr</Value>
</Value>
<Value name="7">
<Value>LocResultMainauditDr</Value>
</Value>
<Value name="8">
<Value>LocResultMainauditDate</Value>
</Value>
<Value name="9">
<Value>LocResultMainauditState</Value>
</Value>
<Value name="10">
<Value>LocResultMainfailNum</Value>
</Value>
</Data>
<DataLocation>^DHCCJXQMLocResultMainD</DataLocation>
<DefaultData>LocResultMainDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXQMLocResultMainD</IdLocation>
<IndexLocation>^DHCCJXQMLocResultMainI</IndexLocation>
<StreamLocation>^DHCCJXQMLocResultMainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
