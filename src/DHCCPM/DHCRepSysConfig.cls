/// 系统参数配置
Class DHCCPM.DHCRepSysConfig Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlTableName = DHC_RepSysConfig ]
{

Property RSCCacheDType As %String(TRUNCATE = 1) [ Required, SqlFieldName = RSC_CacheDateType ];

Property RSCNetDateType As %String(TRUNCATE = 1) [ Required, SqlFieldName = RSC_NetDateType ];

/// 空白的Spread模板
Property RSCXMLData As %GlobalCharacterStream [ SqlFieldName = RSC_XMLData ];

Storage Default
{
<Data name="DHCRepSysConfigClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCRepSysConfigDefaultData">
<Value name="1">
<Value>RSCCacheDType</Value>
</Value>
<Value name="2">
<Value>RSCNetDateType</Value>
</Value>
<Value name="3">
<Value>RSCXMLData</Value>
</Value>
</Data>
<DataLocation>^DHCCPM.DHCRepSysConfigD</DataLocation>
<DefaultData>DHCRepSysConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCPM.DHCRepSysConfigD</IdLocation>
<IndexLocation>^DHCCPM.DHCRepSysConfigI</IndexLocation>
<StreamLocation>^DHCCPM.DHCRepSysConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
