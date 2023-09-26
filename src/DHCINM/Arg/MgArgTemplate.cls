/// Creater:wangpf
/// Descriptions:班次模板
/// Date:2021-09-23
Class DHCINM.Arg.MgArgTemplate Extends %Persistent
{

/// 关联人员
Property TemplatePerson As CF.DHCINM.HR.Persons [ SqlColumnNumber = 2, SqlFieldName = Template_Person ];

/// 开始日期
Property TemplateStDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Template_StDate ];

/// 结束日期
Property TemplateEndDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Template_EndDate ];

/// 周期
Property TemplateCycle As %Integer [ SqlColumnNumber = 5, SqlFieldName = Template_Cycle ];

/// 班次
Property TemplatePost As list Of %String [ SqlColumnNumber = 6, SqlFieldName = Template_Post ];

/// 病区 
Property TemplateWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 7, SqlFieldName = Template_Ward ];

/// 创建人
Property TemplateCreator As %String [ SqlColumnNumber = 8, SqlFieldName = Template_Creator ];

/// 创建日期
Property TemplateCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = Template_CreateDate ];

/// 创建时间
Property TemplateCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = Template_CreateTime ];

Index WardPerson On (TemplateWard, TemplatePerson, TemplateStDate);

Storage Default
{
<Data name="MgArgTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemplatePerson</Value>
</Value>
<Value name="3">
<Value>TemplateStDate</Value>
</Value>
<Value name="4">
<Value>TemplateEndDate</Value>
</Value>
<Value name="5">
<Value>TemplateCycle</Value>
</Value>
<Value name="6">
<Value>TemplatePost</Value>
</Value>
<Value name="7">
<Value>TemplateWard</Value>
</Value>
<Value name="8">
<Value>TemplateCreator</Value>
</Value>
<Value name="9">
<Value>TemplateCreateDate</Value>
</Value>
<Value name="10">
<Value>TemplateCreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Arg.MgArgTemplateD</DataLocation>
<DefaultData>MgArgTemplateDefaultData</DefaultData>
<IdLocation>^DHCINM.Arg.MgArgTemplateD</IdLocation>
<IndexLocation>^DHCINM.Arg.MgArgTemplateI</IndexLocation>
<StreamLocation>^DHCINM.Arg.MgArgTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
