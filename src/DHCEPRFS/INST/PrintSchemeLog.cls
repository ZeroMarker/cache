Class DHCEPRFS.INST.PrintSchemeLog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 修改人ID
Property ActUserID As %String(TRUNCATE = 1);

/// 修改人姓名
Property Modifier As %String(TRUNCATE = 1);

/// 方案ID
Property SchemeID As %String(TRUNCATE = 1);

/// 方案类型
Property SchemeType As %String(TRUNCATE = 1);

/// 修改后方案内容
Property SchemeContent As %String(TRUNCATE = 1);

/// 修改日期
Property ActDate As %Date;

/// 修改时间
Property ActTime As %Time;

/// 修改人登录IP
Property IP As %String(TRUNCATE = 1);

Storage Default
{
<Data name="PrintSchemeLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActUserID</Value>
</Value>
<Value name="3">
<Value>Modifier</Value>
</Value>
<Value name="4">
<Value>SchemeID</Value>
</Value>
<Value name="5">
<Value>SchemeType</Value>
</Value>
<Value name="6">
<Value>ActDate</Value>
</Value>
<Value name="7">
<Value>ActTime</Value>
</Value>
<Value name="8">
<Value>IP</Value>
</Value>
<Value name="9">
<Value>SchemeContent</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.PrintSchemeLogD</DataLocation>
<DefaultData>PrintSchemeLogDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.PrintSchemeLogD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.PrintSchemeLogI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.PrintSchemeLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
