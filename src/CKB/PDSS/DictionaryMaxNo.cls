Class CKB.PDSS.DictionaryMaxNo Extends %Persistent [ SqlRowIdName = DMN_RowID, SqlTableName = DictionaryMaxNo ]
{

/// D ##class(CKB.PDSS.DictionaryMaxNo).%BuildIndices()
/// 类型(字典编码)	
Property DMNDicType As %String [ SqlColumnNumber = 2, SqlFieldName = DMN_DicType ];

/// 最大编号
Property DMNMaxNo As %String [ SqlColumnNumber = 3, SqlFieldName = DMN_MaxNo ];

/// 编码前缀		
Property DMNPrevCode As %String [ SqlColumnNumber = 4, SqlFieldName = DMN_PrevCode ];

Index Type On (DMNDicType As Exact, DMNMaxNo As Exact);

Storage Default
{
<Data name="DictionaryMaxNoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DMNDicType</Value>
</Value>
<Value name="3">
<Value>DMNMaxNo</Value>
</Value>
<Value name="4">
<Value>DMNPrevCode</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.DictionaryMaxNoD</DataLocation>
<DefaultData>DictionaryMaxNoDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.DictionaryMaxNoD</IdLocation>
<IndexLocation>^CKB.PDSS.DictionaryMaxNoI</IndexLocation>
<StreamLocation>^CKB.PDSS.DictionaryMaxNoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index PrevCode On DMNPrevCode As Exact;

}
