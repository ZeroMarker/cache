Class User.DHCPECompDispose Extends %Persistent [ SqlTableName = DHC_PE_CompDispose ]
{

/// 投诉主表ID	
Property CDCompDR As User.DHCPEComplain [ SqlFieldName = CD_CompDR ];

/// 处理方式
Property CDMode As %String [ SqlFieldName = CD_Mode ];

/// 处理详情
Property CDDetail As %String(MAXLEN = 500) [ SqlFieldName = CD_Detail ];

/// 处理人
Property CDUpdateUser As User.SSUser [ SqlFieldName = CD_UpdateUser ];

/// 处理日期
Property CDUpdateDate As %Date [ SqlFieldName = CD_UpdateDate ];

/// 处理时间
Property CDUpdateTime As %Time [ SqlFieldName = CD_UpdateTime ];

/// 备注
Property CDRemark As %String [ SqlFieldName = CD_Remark ];

Index CDCompDRIndex On CDCompDR As AlphaUp;

Storage Default
{
<Data name="DHCPECompDisposeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CDCompDR</Value>
</Value>
<Value name="3">
<Value>CDMode</Value>
</Value>
<Value name="4">
<Value>CDDetail</Value>
</Value>
<Value name="5">
<Value>CDUpdateUser</Value>
</Value>
<Value name="6">
<Value>CDUpdateDate</Value>
</Value>
<Value name="7">
<Value>CDUpdateTime</Value>
</Value>
<Value name="8">
<Value>CDRemark</Value>
</Value>
</Data>
<DataLocation>^User.DHCPECompDisposeD</DataLocation>
<DefaultData>DHCPECompDisposeDefaultData</DefaultData>
<IdLocation>^User.DHCPECompDisposeD</IdLocation>
<IndexLocation>^User.DHCPECompDisposeI</IndexLocation>
<StreamLocation>^User.DHCPECompDisposeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
