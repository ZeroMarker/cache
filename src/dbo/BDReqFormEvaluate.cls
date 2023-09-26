///     
Class dbo.BDReqFormEvaluate Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReqFormEvaluate, StorageStrategy = Default ]
{

/// Foreign Key FKBDRFEvalAddUser created via DDL
ForeignKey FKBDRFEvalAddUser(EvaluateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_RFEval_AddUser ];

/// Foreign Key FKBDRFEvalEvaluate created via DDL
ForeignKey FKBDRFEvalEvaluate(EvaluateIndDR) References dbo.BBEvaluateIndicators(PKBBEVALUATEINDICATORS) [ SqlName = FK_BD_RFEval_Evaluate ];

/// Foreign Key FKBDRFEvalReqForm created via DDL
ForeignKey FKBDRFEvalReqForm(ReqFormDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_BD_RFEval_ReqForm ];

Index IndexEvaluateDate On EvaluateDate [ SqlName = Index_EvaluateDate, Type = index ];

Index IndexEvaluateInd On (EvaluateIndDR, EvaluateDate) [ SqlName = Index_EvaluateInd, Type = index ];

Index IndexMaster On (ReqFormDR, EvaluateIndDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDREQFORMEVALUATE On RowID [ PrimaryKey, SqlName = PK_BD_REQFORMEVALUATE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property ReqFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property EvaluateIndDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property EvaluateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property EvaluateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property EvaluateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BDReqFormEvaluateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqFormDR</Value>
</Value>
<Value name="3">
<Value>EvaluateIndDR</Value>
</Value>
<Value name="4">
<Value>EvaluateDate</Value>
</Value>
<Value name="5">
<Value>EvaluateTime</Value>
</Value>
<Value name="6">
<Value>EvaluateUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReqFormEvaluateD</DataLocation>
<DefaultData>BDReqFormEvaluateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDReqFormEvaluateD</IdLocation>
<IndexLocation>^dbo.BDReqFormEvaluateI</IndexLocation>
<StreamLocation>^dbo.BDReqFormEvaluateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
