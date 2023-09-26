Class EPRmeta.CentralizedPrint.CentralizedPrintItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 集中打印备选项目ID
Property CategoryID As %String(TRUNCATE = 1);

/// 集中打印备选项目描述
Property CategoryDesc As %String(TRUNCATE = 1);

/// 打印顺序
Property Sequence As %Integer;

/// ID索引
Index IdxCategoryID On CategoryID;

/// Sequence索引
Index IdxSequence On Sequence;

Storage Default
{
<Data name="CentralizedPrintItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryDesc</Value>
</Value>
<Value name="3">
<Value>CategoryID</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.CentralizedPrintItemD</DataLocation>
<DefaultData>CentralizedPrintItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.CentralizedPrintItemD</IdLocation>
<IndexLocation>^DHCEPRM.CentralizedPrintItemI</IndexLocation>
<StreamLocation>^DHCEPRM.CentralizedPrintItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
