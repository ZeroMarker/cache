/// Description:工作量分配类型
/// Creator:wangguoying
Class User.DHCPEWorkDistributeType Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract, User.Abstract) [ SqlTableName = DHC_PE_WorkDistributeType ]
{

Parameter ClassName = "User.DHCPEWorkDistributeType";

/// 代码
Property WDTCode As %String(COLLATION = "AlphaUp") [ Required, SqlColumnNumber = 2, SqlFieldName = WDT_Code ];

/// 描述
Property WDTDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = WDT_Desc ];

/// 顺序
Property WDTSort As %Integer [ Required, SqlColumnNumber = 4, SqlFieldName = WDT_Sort ];

/// 启用
Property WDTActive As %String(VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 5, SqlFieldName = WDT_Active ];

/// 系统内置节点  不允许删除
Property WDTSysFlag As %String(VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 6, SqlFieldName = WDT_SysFlag ];

/// 医生 
Relationship WDTDoctor As User.DHCPEWorkDoctor [ Cardinality = children, Inverse = WDParRef ];

/// 链接CSP
Relationship WDTWUrl As User.DHCPEWorkLinkUrl [ Cardinality = children, Inverse = WLUParRef ];

Index CodeIndex On WDTCode [ Unique ];

Index SortIndex On WDTSort [ Unique ];

Storage Default
{
<Data name="DHCPEWorkDistributeTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WDTCode</Value>
</Value>
<Value name="3">
<Value>WDTDesc</Value>
</Value>
<Value name="4">
<Value>WDTSort</Value>
</Value>
<Value name="5">
<Value>WDTActive</Value>
</Value>
<Value name="6">
<Value>WDTSysFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEWorkDistributeTypeD</DataLocation>
<DefaultData>DHCPEWorkDistributeTypeDefaultData</DefaultData>
<IdLocation>^User.DHCPEWorkDistributeTypeD</IdLocation>
<IndexLocation>^User.DHCPEWorkDistributeTypeI</IndexLocation>
<StreamLocation>^User.DHCPEWorkDistributeTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
