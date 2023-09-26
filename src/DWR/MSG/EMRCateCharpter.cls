Class DWR.MSG.EMRCateCharpter Extends (%Persistent, %XML.Adaptor)
{

Parameter XMLNAME = "CateCharpter";

/// 目录ID
Property categoryId As %String(MAXLEN = 50, TRUNCATE = 1);

/// 章节(页签)ID
Property cateCharpterId As %String(MAXLEN = 50, TRUNCATE = 1);

/// 章节(页签)名称
Property cateCharpterName As %String(MAXLEN = 50, TRUNCATE = 1);

/// 本章节的页数
Property pages As %String(MAXLEN = 50, TRUNCATE = 1);

/// 页文件地址列表
Property pageFileList As list Of DWR.MSG.EMRPageFile(XMLNAME = "PageFileList");

Storage Default
{
<Data name="EMRCateCharpterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>categoryID</Value>
</Value>
<Value name="3">
<Value>cateCharpterID</Value>
</Value>
<Value name="4">
<Value>cateCharpterName</Value>
</Value>
<Value name="5">
<Value>pages</Value>
</Value>
<Value name="6">
<Value>pageFileList</Value>
</Value>
<Value name="7">
<Value>categoryId</Value>
</Value>
<Value name="8">
<Value>cateCharpterId</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.EMRCateCharpterD</DataLocation>
<DefaultData>EMRCateCharpterDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.EMRCateCharpterD</IdLocation>
<IndexLocation>^DWR.MSG.EMRCateCharpterI</IndexLocation>
<StreamLocation>^DWR.MSG.EMRCateCharpterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
