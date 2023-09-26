Class EPRmeta.PrintTemplate Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Index PrintTplGuidIdx On GUID [ Unique ];

Property BindTemplateID As %String(TRUNCATE = 1);

Property BindTemplateName As %String(TRUNCATE = 1);

Property ChartItemType As %String(TRUNCATE = 1);

Property ContinuePrint As %Boolean;

Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

Property GUID As %String(MAXLEN = 36, TRUNCATE = 1);

/// 最后保存版本
Property LastVersion As %Integer;

Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

Property NewPage As %Boolean;

Property PrintTemplateCategoryID As %String(TRUNCATE = 1);

Property PrintTemplateFormat As %String(TRUNCATE = 1);

/// 发布版本
Property PublishVersion As %Integer;

/// 唯一模板中是否在后面的空白部分打印格线
Property UnderLine As %Boolean;

/// 添加空白行时是否复制文本行格式
Property BlankRowWithBorder As %Boolean;

ClassMethod SELECTBYGUID(AGUID As %String) As %String
{
 new Result	 
 &sql(SELECT ID
 into :Result 
 FROM EPRmeta.PrintTemplate
 WHERE GUID = :AGUID)
 QUIT Result
}

Query SELECTBYCATEID(CATEID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,GUID:%String,Name:%String,PrintTemplateCategoryID:%String,Description:%String,PublishVersion:%Integer,LastVersion:%Integer,ChartItemType:%String,ContinuePrint:%Boolean,NewPage:%Boolean,BindTemplateID:%String,BindTemplateName:%String,PrintTemplateFormat:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_PrintTemplate_SELECTBYCATEID, SqlProc ]
{
 SELECT ID, GUID, Name, PrintTemplateCategoryID, Description,PublishVersion,LastVersion,ChartItemType,ContinuePrint,NewPage,BindTemplateID,BindTemplateName,PrintTemplateFormat
 FROM EPRmeta.PrintTemplate
 WHERE PrintTemplateCategoryID = :CATEID
 ORDER BY ID
}

Storage Default
{
<Data name="PrintTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>PrintTemplateCategoryID</Value>
</Value>
<Value name="5">
<Value>PublishVersion</Value>
</Value>
<Value name="6">
<Value>GUID</Value>
</Value>
<Value name="7">
<Value>LastVersion</Value>
</Value>
<Value name="8">
<Value>BindTemplateID</Value>
</Value>
<Value name="9">
<Value>ChartItemType</Value>
</Value>
<Value name="10">
<Value>ContinuePrint</Value>
</Value>
<Value name="11">
<Value>NewPage</Value>
</Value>
<Value name="12">
<Value>BindTemplateName</Value>
</Value>
<Value name="13">
<Value>PrintTemplateFormat</Value>
</Value>
<Value name="14">
<Value>UnderLine</Value>
</Value>
<Value name="15">
<Value>BlankRowWithBorder</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.PrintTemplateD</DataLocation>
<DefaultData>PrintTemplateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.PrintTemplateD</IdLocation>
<IndexLocation>^DHCEPRM.PrintTemplateI</IndexLocation>
<StreamLocation>^DHCEPRM.PrintTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
