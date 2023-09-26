Class User.DHCPEPositiveRecord Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_PositiveRecord ]
{

Parameter ClassName = "User.DHCPEPositiveRecord";

Index PCodeUnqIdx1 On PCode [ Unique ];

/// 代码
Property PCode As %String [ SqlFieldName = P_Code ];

/// 描述
Property PName As %String [ SqlFieldName = P_Name ];

/// 男性排序
Property PMSequence As %String [ SqlFieldName = P_MSequence ];

/// 女性排序
Property PFSequence As %String [ SqlFieldName = P_FSequence ];

/// 数据类型  P  阳性记录统计  Q  数据统计
Property PRType As %String [ SqlFieldName = PR_Type ];

/// 创建人
Property PRUserDR As User.SSUser [ SqlFieldName = PR_User_DR ];

/// 使用范围  S：系统  U：个人
Property PRUseRange As %String [ SqlFieldName = PR_UseRange ];

Index TypeIndex On PRType As AlphaUp;

Storage Default
{
<Data name="DHCPEPositiveRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PCode</Value>
</Value>
<Value name="3">
<Value>PName</Value>
</Value>
<Value name="4">
<Value>PMSequence</Value>
</Value>
<Value name="5">
<Value>PFSequence</Value>
</Value>
<Value name="6">
<Value>PRType</Value>
</Value>
<Value name="7">
<Value>PRUserDR</Value>
</Value>
<Value name="8">
<Value>PRUseRange</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEPositiveRecordD</DataLocation>
<DefaultData>DHCPEPositiveRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEPositiveRecordD</IdLocation>
<IndexLocation>^User.DHCPEPositiveRecordI</IndexLocation>
<StreamLocation>^User.DHCPEPositiveRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
