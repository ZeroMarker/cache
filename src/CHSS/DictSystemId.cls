/// 系统编号字典
Class CHSS.DictSystemId Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = DictSystemId ]
{

/// 系统ID
Property SystemId As %Integer;

/// 日期(格式：20090617 $zd($Horolog,8) )
Property DateOfLast As %String(TRUNCATE = 1);

/// 表名
Property TableName As %String(MAXLEN = 50, TRUNCATE = 1);

/// 社区编码
Property CommunityCode As %String(MAXLEN = 30, TRUNCATE = 1);

/// 是否有效
Property bValid As %String(MAXLEN = 5, TRUNCATE = 1);

Index CommunityCodeIndex On (CommunityCode, TableName);

Index CommunityCodeAndDateIndex On (CommunityCode, DateOfLast, TableName);

Storage Default
{
<Data name="DictSystemIdDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CommunityCode</Value>
</Value>
<Value name="3">
<Value>SystemId</Value>
</Value>
<Value name="4">
<Value>TableName</Value>
</Value>
<Value name="5">
<Value>bValid</Value>
</Value>
<Value name="6">
<Value>DateOfLast</Value>
</Value>
</Data>
<DataLocation>^CHSS.DictSystemIdD</DataLocation>
<DefaultData>DictSystemIdDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.DictSystemIdD</IdLocation>
<IndexLocation>^CHSS.DictSystemIdI</IndexLocation>
<StreamLocation>^CHSS.DictSystemIdS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
