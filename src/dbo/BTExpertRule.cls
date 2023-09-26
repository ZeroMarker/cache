/// 专家规则
Class dbo.BTExpertRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_ExpertRule, StorageStrategy = Default ]
{

/// Foreign Key FKExpertRuleHosp created via DDL
ForeignKey FKExpertRuleHosp(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_ExpertRuleHosp ];

Index IndexCode On (Code, HospitalDR) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (Sequence, HospitalDR) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTEXPERTRULE On RowID [ PrimaryKey, SqlName = PK_BT_EXPERTRULE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 800) [ SqlColumnNumber = 4 ];

/// 英文名称  
Property EName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 是否激活  {1:True,0:False}
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTExpertRuleDefaultData">
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
<Value>EName</Value>
</Value>
<Value name="5">
<Value>HospitalDR</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTExpertRuleD</DataLocation>
<DefaultData>BTExpertRuleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTExpertRuleD</IdLocation>
<IndexLocation>^dbo.BTExpertRuleI</IndexLocation>
<StreamLocation>^dbo.BTExpertRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
