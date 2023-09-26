/// 体检关联业务定义表
Class User.DHCPELnkAppConfig Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_LnkAppConfig ]
{

Parameter ClassName = "User.DHCPELnkAppConfig";

/// 业务代码
Property LACAppCode As %String [ Required, SqlFieldName = LAC_AppCode ];

/// 业务描述
Property LACAppDesc As %String [ Required, SqlFieldName = LAC_AppDesc ];

/// 备注说明
Property LACRemark As %String(MAXLEN = 500) [ SqlFieldName = LAC_Remark ];

/// 业务代码 索引
Index IdxOfCode On LACAppCode [ Unique ];

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LACAppCode</Value>
</Value>
<Value name="3">
<Value>LACAppDesc</Value>
</Value>
<Value name="4">
<Value>LACRemark</Value>
</Value>
</Data>
<DataLocation>^CT.PE.LnkAppConfigD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.PE.LnkAppConfigD</IdLocation>
<IndexLocation>^CT.PE.LnkAppConfigI</IndexLocation>
<StreamLocation>^User.DHCPELnkAppConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
