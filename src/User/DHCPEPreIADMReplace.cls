/// 已经预约人员替换
Class User.DHCPEPreIADMReplace Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_PreIADMReplace ]
{

Parameter ClassName = "User.DHCPEPreIADMReplace";

/// DHC_PE_PreIADM的ID
Property PRPreIADMDR As User.DHCPEPreIADM [ Required, SqlFieldName = PR_PreIADM_DR ];

Index PRPreIADMDRIndex On PRPreIADMDR;

/// 原DHC_PE_PreIBaseInfo的ID
Property PROldIBIDR As User.DHCPEPreIBaseInfo [ Required, SqlFieldName = PR_OldIBI_DR ];

/// 新DHC_PE_PreIBaseInfo的ID
Property PRNewIBIDR As User.DHCPEPreIBaseInfo [ Required, SqlFieldName = PR_NewIBI_DR ];

/// 备注
Property PRRemark As %String(MAXLEN = 150) [ SqlFieldName = PR_Remark ];

/// 替换操作人
Property PRUserDR As User.SSUser [ Required, SqlFieldName = PR_User_DR ];

/// 替换操作时间
Property PRUpdateDate As %Date [ Required, SqlFieldName = PR_UpdateDate ];

Index PRUpdateDateIndex On PRUpdateDate;

/// 替换操作时间
Property PRUpdateTime As %Time [ SqlFieldName = PR_UpdateTime ];

Storage Default
{
<Data name="DHCPEPreIADMReplaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PRPreIADMDR</Value>
</Value>
<Value name="3">
<Value>PROldIBIDR</Value>
</Value>
<Value name="4">
<Value>PRNewIBIDR</Value>
</Value>
<Value name="5">
<Value>PRRemark</Value>
</Value>
<Value name="6">
<Value>PRUserDR</Value>
</Value>
<Value name="7">
<Value>PRUpdateDate</Value>
</Value>
<Value name="8">
<Value>PRUpdateTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEPreIADMReplaceD</DataLocation>
<DefaultData>DHCPEPreIADMReplaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEPreIADMReplaceD</IdLocation>
<IndexLocation>^User.DHCPEPreIADMReplaceI</IndexLocation>
<StreamLocation>^User.DHCPEPreIADMReplaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
