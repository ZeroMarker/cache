Class CHSS.PubModelList Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = ModelRowId, SqlTableName = PubModelList ]
{

//Relationship ChildModelRowId As CHSSResource [ Cardinality = children, Inverse = ModelRowId ];

//父节点

Property ModelRowIdParref As %String(MAXLEN = 100, TRUNCATE = 1);

//编号

Property ModelCode As %String(MAXLEN = 20, TRUNCATE = 1);

//显示标题

Property Text As %String(MAXLEN = 60, TRUNCATE = 1);

//是否叶子节点

Property Leaf As %String(MAXLEN = 6, TRUNCATE = 1);

//图标样式

Property IconCls As %String(MAXLEN = 60, TRUNCATE = 1);

//排序

Property Sort As %Integer;

//Url

Property URL As %String(MAXLEN = 100, TRUNCATE = 1);

//ReportUrl

Property ReportUrl As %String(MAXLEN = 100, TRUNCATE = 1);

//状态

Property Status As %String(MAXLEN = 6, TRUNCATE = 1);

//是否字典

Property bDict As %String(MAXLEN = 6, TRUNCATE = 1);

//字典结构是否相同

Property bSame As %String(MAXLEN = 6, TRUNCATE = 1);

//加载前方法

Property MethodBefore As %String(MAXLEN = 30, TRUNCATE = 1);

//加载后方法

Property MethodAfter As %String(MAXLEN = 30, TRUNCATE = 1);

//对应NODE

Property Node As %String(MAXLEN = 30, TRUNCATE = 1);

//是否组件开发

Property bCacheApp As %String(MAXLEN = 6, TRUNCATE = 1);

//组件名称

Property CacheAppName As %String(MAXLEN = 60, TRUNCATE = 1);

Index ModelCodeIndex On ModelCode [ Unique ];

Index TextIndex On Text [ Unique ];

Storage Default
{
<Data name="PubModelListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IconCls</Value>
</Value>
<Value name="3">
<Value>Leaf</Value>
</Value>
<Value name="4">
<Value>MethodAfter</Value>
</Value>
<Value name="5">
<Value>MethodBefore</Value>
</Value>
<Value name="6">
<Value>ModelCode</Value>
</Value>
<Value name="7">
<Value>ModelRowIdParref</Value>
</Value>
<Value name="8">
<Value>Node</Value>
</Value>
<Value name="9">
<Value>Sort</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
<Value name="11">
<Value>Text</Value>
</Value>
<Value name="12">
<Value>URL</Value>
</Value>
<Value name="13">
<Value>bDict</Value>
</Value>
<Value name="14">
<Value>bSame</Value>
</Value>
<Value name="15">
<Value>ReportUrl</Value>
</Value>
<Value name="16">
<Value>CacheAppName</Value>
</Value>
<Value name="17">
<Value>bCacheApp</Value>
</Value>
</Data>
<DataLocation>^CHSS.PubModelListD</DataLocation>
<DefaultData>PubModelListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PubModelListD</IdLocation>
<IndexLocation>^CHSS.PubModelListI</IndexLocation>
<StreamLocation>^CHSS.PubModelListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
