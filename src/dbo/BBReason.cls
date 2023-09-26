Class dbo.BBReason Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_Reason, StorageStrategy = Default ]
{

/// Foreign Key FKBBRUReqRuleAType created via DDL
ForeignKey FKBBReasonLocationClass(LocationClassDR) References dbo.BBRULocationClass(PKBBRULOCATIONCLASS) [ SqlName = FK_BB_Reason_LocationClass ];

/// Foreign Key FKBBRUReqRuleAType created via DDL
ForeignKey FKBBReasonHospital(LocationClassDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_Reason_Hospital ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexLocationClass On (LocationClassDR, BloodComp, SeqNum) [ SqlName = Index_LocationClass, Type = index ];

/// DDL Primary Key Specification
Index PKBBREASON On RowID [ PrimaryKey, SqlName = PK_BB_REASON, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 中文名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

/// RC红细胞,PLT血小板…
Property BloodComp As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 5 ];

/// 输血知识库科室类别
Property LocationClassDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 合理用血类型 0：合理，1：不合理  
Property UseType As %Library.SmallInt [ SqlColumnNumber = 7 ];

/// 规则表达式  
Property RuleFormula As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

/// 是否强制填理由{1:true,0:false}
Property IsMandatory As %Library.Boolean [ SqlColumnNumber = 9 ];

/// 是否需要审批
Property IsApproved As %Library.Boolean [ SqlColumnNumber = 10 ];

/// 医院
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 11 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="BBReasonDefaultData">
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
<Value>BloodComp</Value>
</Value>
<Value name="5">
<Value>LocationClassDR</Value>
</Value>
<Value name="6">
<Value>UseType</Value>
</Value>
<Value name="7">
<Value>RuleFormula</Value>
</Value>
<Value name="8">
<Value>IsMandatory</Value>
</Value>
<Value name="9">
<Value>IsApproved</Value>
</Value>
<Value name="10">
<Value>HospitalDR</Value>
</Value>
<Value name="11">
<Value>SeqNum</Value>
</Value>
<Value name="12">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBReasonD</DataLocation>
<DefaultData>BBReasonDefaultData</DefaultData>
<IdLocation>^dbo.BBReasonD</IdLocation>
<IndexLocation>^dbo.BBReasonI</IndexLocation>
<StreamLocation>^dbo.BBReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
