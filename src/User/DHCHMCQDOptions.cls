Class User.DHCHMCQDOptions Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CQDOptions ]
{

Parameter ClassName = "User.DHCHMCQDOptions";

Relationship QDOParRef As User.DHCHMCQuestionsDetail [ Cardinality = parent, Inverse = QDOptions ];

/// 用来和问卷内容关联的子表
Relationship QDOChild As User.DHCHMCQDOLinkDetail [ Cardinality = children, Inverse = QDOLParRef ];

/// 关联套餐  add by wgy
Relationship QDOLinkOrdSets As User.DHCHMCQDOLinkOrdSets [ Cardinality = children, Inverse = QDOLSParRef ];

/// 选项代码（新加）
Property QDOCode As %String [ Required, SqlFieldName = QDO_Code ];

/// 选项描述
Property QDODesc As %String [ Required, SqlFieldName = QDO_Desc ];

/// 顺序号
Property QDOOrder As %Integer [ SqlFieldName = QDO_Order ];

/// 选项评分（级别改为选项评分）
Property QDOClass As %String [ SqlFieldName = QDO_Class ];

/// 性别限定
Property QDOSex As %String [ SqlFieldName = QDO_Sex ];

/// 激活
Property QDOActive As %String [ SqlFieldName = QDO_Active ];

/// 默认值
Property QDODefault As %String [ SqlFieldName = QDO_Default ];

/// 备注
Property QDONote As %String [ SqlFieldName = QDO_Note ];

/// 更新日期
Property QDOUpdateDate As %Date [ SqlFieldName = QDO_UpdateDate ];

/// 更新时间
Property QDOUpdateTime As %Time [ SqlFieldName = QDO_UpdateTime ];

/// 更信人 指向SS_User
Property QDOUpdateUserDR As %String [ SqlFieldName = QDO_UpdateUserDR ];

Index QDOOrderIndex On (QDOParRef, QDOOrder);

/// 描述索引
Index QDODescIndex On QDODesc;

/// 代码索引
Index IdxOfParRefCode On (QDOParRef, QDOCode) [ Unique ];

Storage Default
{
<Data name="DHCHMCQDOptionsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QDOActive</Value>
</Value>
<Value name="3">
<Value>QDOClass</Value>
</Value>
<Value name="4">
<Value>QDODefault</Value>
</Value>
<Value name="5">
<Value>QDODesc</Value>
</Value>
<Value name="6">
<Value>QDONote</Value>
</Value>
<Value name="7">
<Value>QDOOrder</Value>
</Value>
<Value name="8">
<Value>QDOSex</Value>
</Value>
<Value name="9">
<Value>QDOUpdateDate</Value>
</Value>
<Value name="10">
<Value>QDOUpdateTime</Value>
</Value>
<Value name="11">
<Value>QDOUpdateUserDR</Value>
</Value>
<Value name="12">
<Value>QDOCode</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("QDOptions")</DataLocation>
<DefaultData>DHCHMCQDOptionsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCQuestionsDetailC("QDOptions")</IdLocation>
<IndexLocation>^User.DHCHMCQDOptionsI</IndexLocation>
<StreamLocation>^User.DHCHMCQDOptionsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
