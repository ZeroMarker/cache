/// EPRmeta.CT.MRCICDDx
/// 描述:门诊病历首页系统就诊原因代码表RFV1.0
/// 编写者:
/// 编写日期:
Class EPRmeta.CT.MRCICDDx Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// ICD Diagnosis Code
Property MRCIDCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1);

/// Description
Property MRCIDDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1);

/// Date Active From
Property MRCIDDateActiveFrom As %Date;

/// Date Active To
Property MRCIDDateActiveTo As %Date;

Index IdxMRCIDCode On MRCIDCode;

Storage Default
{
<Data name="MRCICDDxDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MRCIDCode</Value>
</Value>
<Value name="3">
<Value>MRCIDDateActiveFrom</Value>
</Value>
<Value name="4">
<Value>MRCIDDateActiveTo</Value>
</Value>
<Value name="5">
<Value>MRCIDDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.CT.MRCICDDxD</DataLocation>
<DefaultData>MRCICDDxDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.CT.MRCICDDxD</IdLocation>
<IndexLocation>^DHCEPRM.CT.MRCICDDxI</IndexLocation>
<StreamLocation>^DHCEPRM.CT.MRCICDDxS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
