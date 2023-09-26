/// 定义病人就诊状态图标显示主表表
Class User.DocCFTreatStatusMainInfo Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = TreatStatusConfigMainID ]
{

// CSP名称

Property CSPname As %Library.String(COLLATION = "Exact", MAXLEN = 124, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

// 详细描述

Property DefiDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

// 是否有效

Property IsActive As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property HospDr As User.CTHospital [ SqlColumnNumber = 5 ];

Index urlCSPname On CSPname;

Storage Default
{
<Data name="DocCFTreatStatusMainInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TreatStatusConfigMainCode</Value>
</Value>
<Value name="3">
<Value>CSPname</Value>
</Value>
<Value name="4">
<Value>DefiDesc</Value>
</Value>
<Value name="5">
<Value>IsActive</Value>
</Value>
<Value name="6">
<Value>HospDr</Value>
</Value>
</Data>
<DataLocation>^User.DocCFTreatStatusMainInfoD</DataLocation>
<DefaultData>DocCFTreatStatusMainInfoDefaultData</DefaultData>
<IdLocation>^User.DocCFTreatStatusMainInfoD</IdLocation>
<IndexLocation>^User.DocCFTreatStatusMainInfoI</IndexLocation>
<StreamLocation>^User.DocCFTreatStatusMainInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
