Class CT.WS.GlossaryItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxGlossaryID On GlossaryID;

Index IdxComposite On (GlossaryID, TemplateID, ItemCode, ValueType) [ Unique ];

Index IdxLink On (TemplateID, ItemCode, ValueType, GlossaryID) [ Unique ];

/// 所属术语集
Property GlossaryID As %Integer;

/// 所属界面模板
Property TemplateID As %Integer;

/// 界面模板单元名称(冗余字段用于显示单元名称)
Property ItemName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 界面模板单元代码
Property ItemCode As %String(TRUNCATE = 1);

/// 界面模板单元取值类型(V:值;C:代码;VC:值^代码;CV:代码^值)
Property ValueType As %String(TRUNCATE = 1);

/// 元素类型(EMR/Order/Lis/Pacs)
Property Cate As %String(TRUNCATE = 1);

Query GetItemsByID(AGlossaryID) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,GlossaryID:%Integer,TemplateID:%Integer,ItemName:%String,ItemCode:%String,ValueType:%String,Cate:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_Glossary_GetItemsByID, SqlProc ]
{
	select ID,GlossaryID,TemplateID,ItemName,ItemCode,ValueType,Cate
	from CT_WS.GlossaryItem
	where GlossaryID = :AGlossaryID
	order by ID
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
<Value>Cate</Value>
</Value>
</Data>
<DataLocation>^DHCCTWS.GlossaryItemD</DataLocation>
<DefaultData>GlossaryItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCTWS.GlossaryItemD</IdLocation>
<IndexLocation>^DHCCTWS.GlossaryItemI</IndexLocation>
<StreamLocation>^DHCCTWS.GlossaryItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
