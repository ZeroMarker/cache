Class DWR.MSG.EMRBrowseLocation Extends (%Persistent, %XML.Adaptor)
{

/// 浏览类型(FTP/HTTP/ONEURL)
Property browseType As %String(MAXLEN = 50, TRUNCATE = 1);

/// 浏览类型为ONEURL的浏览地址
Property oneURL As %String(MAXLEN = 500, TRUNCATE = 1);

/// FTP或HTTP服务器的主地址
Property fileServerLocation As %String(MAXLEN = 500, TRUNCATE = 1);

/// 章节(页签)数
Property cateCharpters As %String(MAXLEN = 50, TRUNCATE = 1);

/// 章节(页签)列表
Property cateCharpterList As list Of DWR.MSG.EMRCateCharpter(XMLNAME = "CateCharpterList");

Storage Default
{
<Data name="EMRBrowseLocationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>browseType</Value>
</Value>
<Value name="3">
<Value>ONEURL</Value>
</Value>
<Value name="4">
<Value>fileServerLocation</Value>
</Value>
<Value name="5">
<Value>cateCharpters</Value>
</Value>
<Value name="6">
<Value>cateCharpterList</Value>
</Value>
<Value name="7">
<Value>oneURL</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.EMRBrowseLocationD</DataLocation>
<DefaultData>EMRBrowseLocationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.EMRBrowseLocationD</IdLocation>
<IndexLocation>^DWR.MSG.EMRBrowseLocationI</IndexLocation>
<StreamLocation>^DWR.MSG.EMRBrowseLocationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
