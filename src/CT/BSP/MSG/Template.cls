/// Creator:		cryze
/// CreatDate:		2020-12-23
/// Description:	消息内容模板数据
Class CT.BSP.MSG.Template Extends %Persistent
{

Property TMPLCode As %String [ SqlFieldName = TMPL_Code ];

Property TMPLDesc As %String [ SqlFieldName = TMPL_Desc ];

Property TMPLTemplate As %String(MAXLEN = 3000) [ SqlFieldName = TMPL_Template ];

Property TMPLNote As %String [ SqlFieldName = TMPL_Note ];

Property TMPLActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlFieldName = TMPL_Active ];

/// 标签 用于部分业务分类
Property TMPLTag As %String [ SqlFieldName = TMPL_Tag ];

/// 业务变量 模板中除了CF.BSP.SYS.Param之外的其它变量
Property TMPLBizVariables As %String(MAXLEN = 30000) [ SqlFieldName = TMPL_BizVariables ];

Index Code On TMPLCode [ Unique ];

Storage Default
{
<Data name="TemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TMPLCode</Value>
</Value>
<Value name="3">
<Value>TMPLDesc</Value>
</Value>
<Value name="4">
<Value>TMPLTemplate</Value>
</Value>
<Value name="5">
<Value>TMPLNote</Value>
</Value>
<Value name="6">
<Value>TMPLActive</Value>
</Value>
<Value name="7">
<Value>TMPLTag</Value>
</Value>
<Value name="8">
<Value>TMPLBizVariables</Value>
</Value>
</Data>
<DataLocation>^CT.BSP.MSG.TemplateD</DataLocation>
<DefaultData>TemplateDefaultData</DefaultData>
<IdLocation>^CT.BSP.MSG.TemplateD</IdLocation>
<IndexLocation>^CT.BSP.MSG.TemplateI</IndexLocation>
<StreamLocation>^CT.BSP.MSG.TemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
