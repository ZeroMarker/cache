Class User.DHCPEWorkType Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_WorkType ]
{

Parameter ClassName = "User.DHCPEWorkType";

/// 工种代码
Property WTCode As %String(MAXLEN = 20) [ Required, SqlFieldName = WT_Code ];

///  工种描述
Property WTDesc As %String(MAXLEN = 20) [ Required, SqlFieldName = WT_Desc ];

///  激活，Y，N
Property WTActive As %String(MAXLEN = 1) [ SqlFieldName = WT_Active ];

///  工种扩展信息
Property WTExpInfo As %String(MAXLEN = 10) [ SqlFieldName = WT_ExpInfo ];

///  备注
Property WTRemark As %String(MAXLEN = 200) [ SqlFieldName = WT_Remark ];

/// 代码索引
Index WTCodeIndex On WTCode [ Unique ];

/// 描述索引
Index WTDescIndex On WTDesc [ Unique ];

Storage Default
{
<Data name="DHCPEWorkTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WTCode</Value>
</Value>
<Value name="3">
<Value>WTDesc</Value>
</Value>
<Value name="4">
<Value>WTActive</Value>
</Value>
<Value name="5">
<Value>WTExpInfo</Value>
</Value>
<Value name="6">
<Value>WTRemark</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEWorkTypeD</DataLocation>
<DefaultData>DHCPEWorkTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEWorkTypeD</IdLocation>
<IndexLocation>^User.DHCPEWorkTypeI</IndexLocation>
<StreamLocation>^User.DHCPEWorkTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
