/// Description：体检套餐与调查问卷关联表
/// Creator：wangguoying
Class User.DHCHMOrdSetsLink Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_OrdSetsLink ]
{

Parameter ClassName = "User.DHCHMOrdSetsLink";

Relationship OLDetail As User.DHCHMOrdSetsQDetail [ Cardinality = children, Inverse = OQDParRef ];

Property OLOrdSetsDR As User.ARCOrdSets [ Required, SqlColumnNumber = 2, SqlFieldName = OL_OrdSets_DR ];

/// 体检套餐关联表
Property OLOrdSetsExDR As User.DHCPEOrdSetsEx [ SqlColumnNumber = 11, SqlFieldName = OL_OrdSetsExDR ];

/// 科室调查问卷表
Property OLCQuestionDR As User.DHCHMCQuestionnaire [ SqlColumnNumber = 12, SqlFieldName = OL_CQuestionDR ];

/// 性别
Property OLSexDR As User.CTSex [ SqlColumnNumber = 3, SqlFieldName = OL_Sex_DR ];

/// 年龄最小值
Property OLMinAge As %Integer [ SqlColumnNumber = 4, SqlFieldName = OL_MinAge ];

/// 年龄最大值
Property OLMaxAge As %Integer [ SqlColumnNumber = 5, SqlFieldName = OL_MaxAge ];

/// 婚姻状况
Property OLMaritalDR As User.CTMarital [ SqlColumnNumber = 6, SqlFieldName = OL_Marital_DR ];

/// 更新人
Property OLUpdateUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = OL_UpdateUser_DR ];

/// 操作日期
Property OLUpdateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = OL_UpdateDate ];

/// 更新时间
Property OLUpdateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = OL_UpdateTime ];

/// 套餐类型 M:主套餐,ADD:加项包
Property OLOrdSetsType As %String(DISPLAYLIST = ",MAIN,ADD", MAXLEN = 4, VALUELIST = ",M,A") [ Required, SqlColumnNumber = 10, SqlFieldName = OL_OrdSetsType ];

Index OrdSetsIndex On OLOrdSetsDR [ Unique ];

Index IdxOrdSetsExDR On OLOrdSetsExDR;

Index IdxCQuestionDR On OLCQuestionDR;

Storage Default
{
<Data name="DHCHMOrdSetsLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OLOrdSetsDR</Value>
</Value>
<Value name="3">
<Value>OLSexDR</Value>
</Value>
<Value name="4">
<Value>OLMinAge</Value>
</Value>
<Value name="5">
<Value>OLMaxAge</Value>
</Value>
<Value name="6">
<Value>OLMarital</Value>
</Value>
<Value name="7">
<Value>OLUpdateUserDR</Value>
</Value>
<Value name="8">
<Value>OLUpdateDate</Value>
</Value>
<Value name="9">
<Value>OLUpdateTime</Value>
</Value>
<Value name="10">
<Value>OLMaritalDR</Value>
</Value>
<Value name="11">
<Value>OLOrdSetsType</Value>
</Value>
<Value name="12">
<Value>OLOrdSetsExDR</Value>
</Value>
<Value name="13">
<Value>OLCQuestionDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMOrdSetsLinkD</DataLocation>
<DefaultData>DHCHMOrdSetsLinkDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMOrdSetsLinkD</IdLocation>
<IndexLocation>^User.DHCHMOrdSetsLinkI</IndexLocation>
<StreamLocation>^User.DHCHMOrdSetsLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
