/// 申请单类型
Class dbo.BBReqType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_ReqType, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBREQTYPE On RowID [ PrimaryKey, SqlName = PK_BB_REQTYPE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

Property ReqType As %Library.SmallInt [ Required, SqlColumnNumber = 5 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Property Color As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 8 ];

Property IsPrompt As %Library.Boolean [ SqlColumnNumber = 9 ];

Property PromptContent As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 10 ];

Property IsUrgent As %Library.Boolean [ SqlColumnNumber = 11 ];

Property IsReqRule As %Library.Boolean [ SqlColumnNumber = 12 ];

Property IsXMatchProduct As %Library.Boolean [ SqlColumnNumber = 13 ];

Property IssHours As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property SubjectRuleDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 15 ];

Property BackgroundImage As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 16 ];

Property IsReqAssess As %Library.Boolean [ SqlColumnNumber = 17 ];

/// 申请单类型指向页面类型 10:常规 20手术30急救 50自体回输 60 血液治疗
Property FormType As %Library.SmallInt [ SqlColumnNumber = 18 ];

/// 输血类型 10手术用血 20非手术用血
Property TransfusionType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 19 ];

Storage Default
{
<Data name="BBReqTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>ReqType</Value>
</Value>
<Value name="5">
<Value>SeqNum</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>Color</Value>
</Value>
<Value name="8">
<Value>IsPrompt</Value>
</Value>
<Value name="9">
<Value>PromptContent</Value>
</Value>
<Value name="10">
<Value>IsUrgent</Value>
</Value>
<Value name="11">
<Value>IsReqRule</Value>
</Value>
<Value name="12">
<Value>IsXMatchProduct</Value>
</Value>
<Value name="13">
<Value>IssHours</Value>
</Value>
<Value name="14">
<Value>SubjectRuleDesc</Value>
</Value>
<Value name="15">
<Value>BackgroundImage</Value>
</Value>
<Value name="16">
<Value>IsReqAssess</Value>
</Value>
<Value name="17">
<Value>FormType</Value>
</Value>
<Value name="18">
<Value>TransfusionType</Value>
</Value>
</Data>
<DataLocation>^dbo.BBReqTypeD</DataLocation>
<DefaultData>BBReqTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBReqTypeD</IdLocation>
<IndexLocation>^dbo.BBReqTypeI</IndexLocation>
<StreamLocation>^dbo.BBReqTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
