Class CSM.CRFMetaData Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 字段中文名称
Property ColCName As %String(TRUNCATE = 1) [ Required ];

/// 字段数据类型
Property ColDataType As %String(MAXLEN = 10, TRUNCATE = 1) [ Required ];

/// 关联的FormID
Property FormID As %String(MAXLEN = 36, TRUNCATE = 1) [ Required ];

/// 字段英文名称，即最终导出表的字段名称
Property ColEName As %String(TRUNCATE = 1) [ Required ];

/// 字段长度
Property ColLength As %Integer [ Required ];

/// 计算字段表达式
Property CalcExpression As %String(MAXLEN = 200, TRUNCATE = 1);

/// 正常值范围
Property NormalScale As %String(MAXLEN = 200, TRUNCATE = 1);

Storage Default
{
<Data name="CRFMetaDataDefaultData">
<Subscript>"CRFMetaData"</Subscript>
<Value name="1">
<Value>CalcExpression</Value>
</Value>
<Value name="2">
<Value>NormalScale</Value>
</Value>
<Value name="3">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="4">
<Value>ColCName</Value>
</Value>
<Value name="5">
<Value>ColDataType</Value>
</Value>
<Value name="6">
<Value>ColEName</Value>
</Value>
<Value name="7">
<Value>ColLength</Value>
</Value>
<Value name="8">
<Value>FormID</Value>
</Value>
</Data>
<DataLocation>^CSM.CRFMetaDataD</DataLocation>
<DefaultData>CRFMetaDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.CRFMetaDataD</IdLocation>
<IndexLocation>^CSM.CRFMetaDataI</IndexLocation>
<StreamLocation>^CSM.CRFMetaDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
