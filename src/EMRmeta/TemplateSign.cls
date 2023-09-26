/// 名称:EMRmeta.TemplateSign
/// 描述:模板签名配置表
/// 编写者：yejian
/// 编写日期: 2018-12-5
Class EMRmeta.TemplateSign Extends %Persistent
{

/// 模板ID
Property TemplateID As %String(TRUNCATE = 1);

/// 模板版本ID
Property TemplateVersion As %Integer;

/// 关联EMRmeta.SignRole表的ActionCode
Property ActionCode As %String;

/// 关联EMRmeta.SignRole表的Description
Property Description As %String;

/// 关联EMRmeta.Titles表的Code,唯一模板该值固定为"SINGLE"
Property TitleCode As %String;

/// 关联EMRmeta.Titles表的Description
Property TitleName As %String;

/// 医务人员待签：MEDICAL，患者待签：PATIENT
Property SignType As %String;

/// 签名级别（EMRmeta.SignRole表的RoleLevel字段）
Property Sequence As %Integer;

/// 规则编码（EMRmeta.RoleSignRuleList的RoleRuleCode以^分隔）
Property RoleRuleCode As %String;

/// 是否必签 
Property IsForce As %String(TRUNCATE = 1) [ InitialExpression = "Y" ];

Index IndexTIDVersion On (TemplateID, TemplateVersion);

Index IndexTIDVersionSeq On (TemplateID, TemplateVersion, Sequence);

Index IndexTIDVTCode On (TemplateID, TemplateVersion, TitleCode, ActionCode);

Index IdxTIDVTitleTypeAction On (TemplateID, TemplateVersion, TitleCode, SignType, ActionCode);

Index IdxTIDVTitleTypeSeqAction On (TemplateID, TemplateVersion, TitleCode, SignType, Sequence, ActionCode);

Index IdxTIDVTitleTypeForceAction On (TemplateID, TemplateVersion, TitleCode, SignType, IsForce, ActionCode);

Index IdxTIDVTitleTypeForceSeqAction On (TemplateID, TemplateVersion, TitleCode, SignType, IsForce, Sequence, ActionCode);

Storage Default
{
<Data name="TemplateSignDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemplateID</Value>
</Value>
<Value name="3">
<Value>VersionNumber</Value>
</Value>
<Value name="4">
<Value>ActionCode</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>TitleCode</Value>
</Value>
<Value name="7">
<Value>SignType</Value>
</Value>
<Value name="8">
<Value>TemplateVersion</Value>
</Value>
<Value name="9">
<Value>TitleName</Value>
</Value>
<Value name="10">
<Value>Sequence</Value>
</Value>
<Value name="11">
<Value>RuleCode</Value>
</Value>
<Value name="12">
<Value>RoleRuleCode</Value>
</Value>
<Value name="13">
<Value>IsForce</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TemplateSignD</DataLocation>
<DefaultData>TemplateSignDefaultData</DefaultData>
<IdLocation>^DHCEMRM.TemplateSignD</IdLocation>
<IndexLocation>^DHCEMRM.TemplateSignI</IndexLocation>
<StreamLocation>^DHCEMRM.TemplateSignS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
