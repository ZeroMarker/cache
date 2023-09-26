Class CHSS.WhNewBorn Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = NewBornRowId, SqlTableName = WhNewBorn ]
{

/// WomanRowId
Property WomanRowId As CHSS.WomenBaseInfo;

/// 出生体重
Property BirthWeight As %Float;

/// 性别
Property Sex As %String(MAXLEN = 10, TRUNCATE = 1);

/// 姓名
Property Name As %String(MAXLEN = 50, TRUNCATE = 1);

/// 出生顺序
Property BirthSort As %Integer;

Storage Default
{
<Data name="WhNewBornDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BirthSort</Value>
</Value>
<Value name="3">
<Value>BirthWeight</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>Sex</Value>
</Value>
<Value name="6">
<Value>WomanRowId</Value>
</Value>
</Data>
<DataLocation>^CHSS.WhNewBornD</DataLocation>
<DefaultData>WhNewBornDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.WhNewBornD</IdLocation>
<IndexLocation>^CHSS.WhNewBornI</IndexLocation>
<StreamLocation>^CHSS.WhNewBornS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
