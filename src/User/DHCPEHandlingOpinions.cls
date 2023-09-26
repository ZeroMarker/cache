/// 职业健康处理意见
Class User.DHCPEHandlingOpinions Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract, User.Abstract) [ SqlTableName = DHC_PE_HandlingOpinions ]
{

Parameter ClassName = "User.DHCPEHandlingOpinions";

/// 代码
Property HOCode As %String(MAXLEN = 100) [ Required, SqlColumnNumber = 2, SqlFieldName = HO_Code ];

/// 职业病检查种类
Property HOOMETypeDR As User.DHCPEOMEType [ SqlColumnNumber = 3, SqlFieldName = HO_OMEType_DR ];

/// 职业病结论分类
Property HOConclusionDR As User.DHCPEConclusion [ Required, SqlColumnNumber = 4, SqlFieldName = HO_Conclusion_DR ];

/// 处理意见
Property HODesc As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ Required, SqlColumnNumber = 5, SqlFieldName = HO_Desc ];

/// 顺序
Property HOSort As %Integer [ Required, SqlColumnNumber = 6, SqlFieldName = HO_Sort ];

/// 激活，Y，N 
Property HOActive As %String(DISPLAYLIST = ",Y,N", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = HO_Active ];

/// 备注
Property HORemark As %String(MAXLEN = 500) [ SqlColumnNumber = 8, SqlFieldName = HO_Remark ];

/// 更新日期
Property HOUpdateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = HO_UpdateDate ];

/// 更新时间
Property HOUpdateTime As %Time [ SqlColumnNumber = 10, SqlFieldName = HO_UpdateTime ];

/// 更新人 指向SS_User
Property HOUpdateUserDR As %String [ SqlColumnNumber = 11, SqlFieldName = HO_UpdateUserDR ];

/// 代码索引
Index HOCodeIndex On HOCode;

/// 检查种类索引
Index HOOMETypeIndex On HOOMETypeDR As AlphaUp;

/// 检查结论索引
Index HOConclusionIndex On HOConclusionDR As AlphaUp;

Storage Default
{
<Data name="DHCPEHandlingOpinionsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HOCode</Value>
</Value>
<Value name="3">
<Value>HOOMETypeDR</Value>
</Value>
<Value name="4">
<Value>HOConclusionDR</Value>
</Value>
<Value name="5">
<Value>HODesc</Value>
</Value>
<Value name="6">
<Value>HOSort</Value>
</Value>
<Value name="7">
<Value>HOActive</Value>
</Value>
<Value name="8">
<Value>HORemark</Value>
</Value>
<Value name="9">
<Value>HOUpdateDate</Value>
</Value>
<Value name="10">
<Value>HOUpdateTime</Value>
</Value>
<Value name="11">
<Value>HOUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEHandlingOpinionsD</DataLocation>
<DefaultData>DHCPEHandlingOpinionsDefaultData</DefaultData>
<IdLocation>^User.DHCPEHandlingOpinionsD</IdLocation>
<IndexLocation>^User.DHCPEHandlingOpinionsI</IndexLocation>
<StreamLocation>^User.DHCPEHandlingOpinionsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
