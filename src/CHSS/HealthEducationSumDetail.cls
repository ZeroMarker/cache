Class CHSS.HealthEducationSumDetail Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = DetailRowId, SqlTableName = HealthEducationSumDetail ]
{

/// 文件标题
Property FileTitle As %String(MAXLEN = 100, TRUNCATE = 1);

/// 文件内容
Property FileContent As %GlobalCharacterStream;

/// 图片内容
Property Image As %GlobalBinaryStream;

Storage Default
{
<Data name="HealthEducationSumDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FileContent</Value>
</Value>
<Value name="3">
<Value>FileTitle</Value>
</Value>
<Value name="4">
<Value>NewProperty1</Value>
</Value>
<Value name="5">
<Value>Image</Value>
</Value>
</Data>
<DataLocation>^CHSS.HealthEducationSumDetailD</DataLocation>
<DefaultData>HealthEducationSumDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.HealthEducationSumDetailD</IdLocation>
<IndexLocation>^CHSS.HealthEducationSumDetailI</IndexLocation>
<StreamLocation>^CHSS.HealthEducationSumDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
