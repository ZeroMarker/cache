/// 知识库单元术语集
Class EPRmeta.GlossaryKBItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxGlossaryID On GlossaryID;

Index IdxComposite On (GlossaryID, KBNodeID, KBPartNo, ItemCode, ValueType) [ Unique ];

Index IdxLink On (KBNodeID, KBPartNo, ItemCode, ValueType, GlossaryID) [ Unique ];

Index IdxKBType On (GlossaryID, KBType);

/// 所属术语
Property GlossaryID As %Integer;

/// 上下文术语(如主诉、现病史等)
Property ContextGlossaryID As %Integer;

/// 所属知识库
Property KBNodeID As %Integer;

/// 所属知识库部分
Property KBPartNo As %Integer;

/// 知识库单元名称
Property ItemName As %String(TRUNCATE = 1);

/// 知识库单元代码
Property ItemCode As %String(MAXLEN = 300, TRUNCATE = 1);

/// 知识库单元取值类型(V:值;C:代码;VC:值^代码;CV:代码^值)
Property ValueType As %String(TRUNCATE = 1);

/// 知识库标示(NEW：新版，OLD:旧版(空))
Property KBType As %String(TRUNCATE = 1);

Query GetKBItemsByID(AGlossaryID) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,GlossaryID:%Integer,ContextGlossaryID:%Integer,KBNodeID:%Integer,KBPartNo:%Integer,ItemName:%String,ItemCode:%String,ValueType:%String,KBType:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_Glossary_GetKBItemsByID, SqlProc ]
{
	select ID,GlossaryID,ContextGlossaryID,KBNodeID,KBPartNo,ItemName,ItemCode,ValueType,KBType
	from EPRmeta.GlossaryKBItem
	where GlossaryID=:AGlossaryID
	order by ID
}

Storage Default
{
<Data name="GlossaryKBItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GlossaryID</Value>
</Value>
<Value name="3">
<Value>ContextGlossaryID</Value>
</Value>
<Value name="4">
<Value>KBNodeID</Value>
</Value>
<Value name="5">
<Value>KBPartNo</Value>
</Value>
<Value name="6">
<Value>ItemName</Value>
</Value>
<Value name="7">
<Value>ItemCode</Value>
</Value>
<Value name="8">
<Value>ValueType</Value>
</Value>
<Value name="9">
<Value>KBType</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.GlossaryKBItemD</DataLocation>
<DefaultData>GlossaryKBItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.GlossaryKBItemD</IdLocation>
<IndexLocation>^DHCEPRM.GlossaryKBItemI</IndexLocation>
<StreamLocation>^DHCEPRM.GlossaryKBItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
