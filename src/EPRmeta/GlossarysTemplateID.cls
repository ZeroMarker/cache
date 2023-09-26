/// 术语目录和模板的ID关系
/// Creator:   yejian
/// CreateDate:2014-3-28
Class EPRmeta.GlossarysTemplateID Extends %Persistent
{

/// 术语集目录内部标示符
Property InternalID As %String(TRUNCATE = 1);

/// 绑定界面模板ID
Property TemplateID As %String(TRUNCATE = 1);

Index IdxInternalID On InternalID;

Index IdxInteIDTemID On (InternalID, TemplateID);

Storage Default
{
<Data name="GlossarysTemplateIDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InternalID</Value>
</Value>
<Value name="3">
<Value>TemplateID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.GlossarysTemplateIDD</DataLocation>
<DefaultData>GlossarysTemplateIDDefaultData</DefaultData>
<IdLocation>^DHCEPRM.GlossarysTemplateIDD</IdLocation>
<IndexLocation>^DHCEPRM.GlossarysTemplateIDI</IndexLocation>
<StreamLocation>^DHCEPRM.GlossarysTemplateIDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
