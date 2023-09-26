Class User.DHCPESrvLogDetail Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_SrvLogDetail ]
{

/// 业务数据ID
Property SLDBusiID As %String [ SqlFieldName = SLD_BusiID ];

/// 父表
Relationship SLDParRef As User.DHCPESrvLog [ Cardinality = parent, Inverse = SLDetailChild ];

/// 日志类型
Property SLDType As %String;

Index TypeBusiIndex On (SLDType As AlphaUp, SLDBusiID);

Storage Default
{
<Data name="DHCPESrvLogDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SLDBusiID</Value>
</Value>
<Value name="3">
<Value>SLDType</Value>
</Value>
</Data>
<DataLocation>^User.DHCPESrvLogDetailD</DataLocation>
<DefaultData>DHCPESrvLogDetailDefaultData</DefaultData>
<IdLocation>^User.DHCPESrvLogDetailD</IdLocation>
<IndexLocation>^User.DHCPESrvLogDetailI</IndexLocation>
<StreamLocation>^User.DHCPESrvLogDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
