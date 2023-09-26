/// 默认界面模板单元术语集
Class EPRmeta.GlossaryItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxGlossaryID On GlossaryID;

Index IdxComposite On (GlossaryID, TemplateID, ItemCode, ValueType) [ Unique ];

Index IdxLink On (TemplateID, ItemCode, ValueType, GlossaryID) [ Unique ];

Index IdxTemplateID On TemplateID;

/// 所属术语集
Property GlossaryID As %Integer;

/// 所属界面模板
Property TemplateID As %Integer;

/// 界面模板单元名称(冗余字段用于显示单元名称)
Property ItemName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 界面模板单元代码
Property ItemCode As %String(MAXLEN = 300, TRUNCATE = 1);

/// 界面模板标示(NEW：新版，OLD:旧版(空))
Property TemType As %String(TRUNCATE = 1);

/// 界面模板单元取值类型(V:值;C:代码;VC:值^代码;CV:代码^值)
Property ValueType As %String(TRUNCATE = 1);

/// 术语内部标识符
Property InternalID As %String(TRUNCATE = 1);

/// 模板编码
Property TemplateCode As %String(MAXLEN = 200, TRUNCATE = 1);

Query GetItemsByID(AGlossaryID) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,GlossaryID:%Integer,TemplateID:%Integer,ItemName:%String,ItemCode:%String,ValueType:%String,TemType:%String,InternalID:%String,TemplateCode:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_Glossary_GetItemsByID, SqlProc ]
{
	select ID,GlossaryID,TemplateID,ItemName,ItemCode,ValueType,TemType,InternalID,TemplateCode
	from EPRmeta.GlossaryItem
	where GlossaryID = :AGlossaryID
	order by ID
}

/// debug: w ##class(EPRmeta.GlossaryItem).GetGlossayID("154","S0001","V")
ClassMethod GetGlossayID(ATemplateID As %String, AItemCode As %String, AValueType As %String) As %String
{
	s glossaryID = ""	
	s glossaryID = $o(^DHCEPRM.GlossaryItemI("IdxLink", ATemplateID, " "_AItemCode, " "_AValueType, glossaryID))
	q glossaryID
}

Storage Default
{
<Data name="GlossaryItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GlossaryID</Value>
</Value>
<Value name="3">
<Value>TemplateID</Value>
</Value>
<Value name="4">
<Value>ItemName</Value>
</Value>
<Value name="5">
<Value>ItemCode</Value>
</Value>
<Value name="6">
<Value>ValueType</Value>
</Value>
<Value name="7">
<Value>TemType</Value>
</Value>
<Value name="8">
<Value>InternalID</Value>
</Value>
<Value name="9">
<Value>TemplateCode</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.GlossaryItemD</DataLocation>
<DefaultData>GlossaryItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.GlossaryItemD</IdLocation>
<IndexLocation>^DHCEPRM.GlossaryItemI</IndexLocation>
<StreamLocation>^DHCEPRM.GlossaryItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
