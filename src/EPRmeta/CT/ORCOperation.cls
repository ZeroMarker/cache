/// EPRmeta.CT.ORCOperation
/// 描述:门诊病历首页系统手术和操作代码表
/// 编写者:
/// 编写日期:
Class EPRmeta.CT.ORCOperation Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// ICD Code
Property OPERCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1);

/// Operation Description
Property OPERDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1);

/// Date Active From
Property OPERDateActiveFrom As %Date;

/// Date Active To
Property OPERDateActiveTo As %Date;

/// ICD Code 手术：Operation  操作:Procedure
Property OPERTYPE As %String(TRUNCATE = 1);

/// Procedure 类型 诊断性操作:D 治疗性操作:T
Property PROCEDURETYPE As %String(TRUNCATE = 1);

Index IdxOPERCode On OPERCode;

Storage Default
{
<Data name="ORCOperationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OPERCode</Value>
</Value>
<Value name="3">
<Value>OPERDateActiveFrom</Value>
</Value>
<Value name="4">
<Value>OPERDateActiveTo</Value>
</Value>
<Value name="5">
<Value>OPERDesc</Value>
</Value>
<Value name="6">
<Value>OPERTYPE</Value>
</Value>
<Value name="7">
<Value>PROCEDURETYPE</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.CT.ORCOperationD</DataLocation>
<DefaultData>ORCOperationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.CT.ORCOperationD</IdLocation>
<IndexLocation>^DHCEPRM.CT.ORCOperationI</IndexLocation>
<StreamLocation>^DHCEPRM.CT.ORCOperationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
