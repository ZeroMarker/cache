/// 穿刺体位
Class CT.AN.PuncturePosition Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = PuncturePosition ]
{

/// 穿刺体位代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 穿刺体位名称
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 穿刺体位代码唯一索引
Index ICode On Code [ Unique ];

Storage Default
{
<Data name="PuncturePositionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^CT.AN.PuncturePositionD</DataLocation>
<DefaultData>PuncturePositionDefaultData</DefaultData>
<IdLocation>^CT.AN.PuncturePositionD</IdLocation>
<IndexLocation>^CT.AN.PuncturePositionI</IndexLocation>
<StreamLocation>^CT.AN.PuncturePositionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
