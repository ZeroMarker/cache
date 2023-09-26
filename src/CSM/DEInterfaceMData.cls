/// 接口字典定义表
Class CSM.DEInterfaceMData Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 字段类型：医嘱O/检验L/检查E/病历R/自动计算C
Property DEType As %String(MAXLEN = 10, TRUNCATE = 1) [ Required ];

/// 明细
Property Detail As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目
Property Item As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 大类
Property MainCategory As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 明细项目对应于Trak字典表的RowID
Property RowID As %String(MAXLEN = 20, TRUNCATE = 1);

/// 子类
Property SubCategory As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

Storage Default
{
<Data name="DEInterfaceMDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DEType</Value>
</Value>
<Value name="3">
<Value>Detail</Value>
</Value>
<Value name="4">
<Value>Item</Value>
</Value>
<Value name="5">
<Value>MainCategory</Value>
</Value>
<Value name="6">
<Value>RowID</Value>
</Value>
<Value name="7">
<Value>SubCategory</Value>
</Value>
</Data>
<DataLocation>^CSM.DEInterfaceMDataD</DataLocation>
<DefaultData>DEInterfaceMDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.DEInterfaceMDataD</IdLocation>
<IndexLocation>^CSM.DEInterfaceMDataI</IndexLocation>
<StreamLocation>^CSM.DEInterfaceMDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
