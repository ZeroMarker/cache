Class CSM.DEFMetaData Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
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

/// 对应接口元数据的ID
Property DEIntfaceMDataID As %Integer;

Storage Default
{
<Data name="DEFMetaDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CalcExpression</Value>
</Value>
<Value name="3">
<Value>ColCName</Value>
</Value>
<Value name="4">
<Value>ColDataType</Value>
</Value>
<Value name="5">
<Value>ColEName</Value>
</Value>
<Value name="6">
<Value>ColLength</Value>
</Value>
<Value name="7">
<Value>DEIntfaceMDataID</Value>
</Value>
<Value name="8">
<Value>FormID</Value>
</Value>
<Value name="9">
<Value>NormalScale</Value>
</Value>
</Data>
<DataLocation>^CSM.DEFMetaDataD</DataLocation>
<DefaultData>DEFMetaDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.DEFMetaDataD</IdLocation>
<IndexLocation>^CSM.DEFMetaDataI</IndexLocation>
<StreamLocation>^CSM.DEFMetaDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
