/// 职业病结论分类
Class User.DHCPEConclusion Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract, User.Abstract) [ SqlTableName = DHC_PE_Conclusion ]
{

Parameter ClassName = "User.DHCPEConclusion";

/// 分类代码
Property CCode As %String(MAXLEN = 100) [ Required, SqlFieldName = C_Code ];

/// 分类描述
Property CDesc As %String(MAXLEN = 200) [ Required, SqlFieldName = C_Desc ];

/// 激活，Y，N 
Property CActive As %String(DISPLAYLIST = ",Y,N", VALUELIST = ",Y,N") [ SqlFieldName = C_Active ];

/// 【作废】VIP等级
Property CVIPLevel As %Integer [ SqlFieldName = C_VIPLevel ];

/// 扩展信息
Property CExpInfo As %String(MAXLEN = 200) [ SqlFieldName = C_ExpInfo ];

/// 严重级别
Property CSeverity As %Integer [ SqlFieldName = C_Severity ];

/// 备注
Property CRemark As %String(MAXLEN = 500) [ SqlFieldName = C_Remark ];

/// 【加】更新日期
Property CUpdateDate As %Date [ SqlFieldName = C_UpdateDate ];

/// 【加】更新时间
Property CUpdateTime As %Time [ SqlFieldName = C_UpdateTime ];

/// 【加】更新人 指向SS_User
Property CUpdateUserDR As %String [ SqlFieldName = C_UpdateUserDR ];

/// 代码索引
Index CCodeIndex On CCode [ Unique ];

/// 描述索引
Index CDescIndex On CDesc;

/// VIP等级索引
Index VIPLevelIndex On CVIPLevel As AlphaUp;

Storage Default
{
<Data name="DHCPEConclusionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CCode</Value>
</Value>
<Value name="3">
<Value>CDesc</Value>
</Value>
<Value name="4">
<Value>CActive</Value>
</Value>
<Value name="5">
<Value>CVIPLevel</Value>
</Value>
<Value name="6">
<Value>CExpInfo</Value>
</Value>
<Value name="7">
<Value>CSeverity</Value>
</Value>
<Value name="8">
<Value>CRemark</Value>
</Value>
<Value name="9">
<Value>CUpdateDate</Value>
</Value>
<Value name="10">
<Value>CUpdateTime</Value>
</Value>
<Value name="11">
<Value>CUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEConclusionD</DataLocation>
<DefaultData>DHCPEConclusionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEConclusionD</IdLocation>
<IndexLocation>^User.DHCPEConclusionI</IndexLocation>
<StreamLocation>^User.DHCPEConclusionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
