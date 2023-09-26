/// 自定义字典
/// (1)全院通用模板权限 数据插入
///   INSERT INTO EPRmeta.CustomDictionary(CtmDictAlias, CtmDictCode, CtmDictDesc, CtmDictID, CtmDictStatus,CtmDictType)
///   VALUES ('通用模板权限', 'PrivAll', '通用模板权限', 'P0101', 'Y','DHCEPRVPatPriv')
Class EPRmeta.CustomDictionary Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxCtmDictType On CtmDictType;

Index IdxCtmDictCode On CtmDictCode;

Index IdxCtmDictDesc On CtmDictDesc;

Index IdxCtmTypeCode On (CtmDictType, CtmDictCode);

/// 	字段标识号
Property CtmDictID As %String(TRUNCATE = 1);

///   	字典代码列
Property CtmDictCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 	字典描述列
Property CtmDictDesc As %String(TRUNCATE = 1);

/// 	字典别名列
Property CtmDictAlias As %String(TRUNCATE = 1);

/// 	数据状态	Y启用	N停止
Property CtmDictStatus As %String(TRUNCATE = 1);

/// 	视图类型	TPrivPatType	(多科室多套模板) 
/// 				TPrivPatPriv	(全院通用|科室通用|病区通用)
Property CtmDictType As %String(TRUNCATE = 1);

/// 字段名称
Property CtmDictName As %String(TRUNCATE = 1);

/// 对照代码
Property CtmDictLinkCode As %String(TRUNCATE = 1);

/// 字段备注
Property CtmDictComment As %String(TRUNCATE = 1);

/// 其他
Property CtmDictOther As %String(MAXLEN = 500, TRUNCATE = 1);

/// 关联
Property CtmDictRef As %String(MAXLEN = 32767, TRUNCATE = 1);

/// 对照
Property CtmDictLink As %String(TRUNCATE = 1);

ClassMethod GetCtmDictLinkByCode(parCtmDictCode As %String) As %String
{
 &sql(SELECT CtmDictLink
 into :Result
 FROM EPRmeta.CustomDictionary
 WHERE CtmDictCode = :parCtmDictCode)
 
 s:(SQLCODE'=0) Result=""
 
 QUIT Result
}

Storage Default
{
<Data name="CustomDictionaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CtmDictAlias</Value>
</Value>
<Value name="3">
<Value>CtmDictCode</Value>
</Value>
<Value name="4">
<Value>CtmDictDesc</Value>
</Value>
<Value name="5">
<Value>CtmDictID</Value>
</Value>
<Value name="6">
<Value>CtmDictStatus</Value>
</Value>
<Value name="7">
<Value>CtmDictType</Value>
</Value>
<Value name="8">
<Value>CtmDictComment</Value>
</Value>
<Value name="9">
<Value>CtmDictName</Value>
</Value>
<Value name="10">
<Value>CtmDictLinkCode</Value>
</Value>
<Value name="11">
<Value>CtmDictOther</Value>
</Value>
<Value name="12">
<Value>CtmDictLink</Value>
</Value>
<Value name="13">
<Value>CtmDictRef</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.CustomDictionaryD</DataLocation>
<DefaultData>CustomDictionaryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.CustomDictionaryD</IdLocation>
<IndexLocation>^DHCEPRM.CustomDictionaryI</IndexLocation>
<StreamLocation>^DHCEPRM.CustomDictionaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
