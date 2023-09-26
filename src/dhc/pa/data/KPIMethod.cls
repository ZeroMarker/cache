/// 指标方法字典
Class dhc.pa.data.KPIMethod Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = KPIMethod_rowid, SqlTableName = KPIMethod ]
{

//方法名称

Property MethodName As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = KPIM_Name ];

//方法代码(["I",'区间法'],["C",'比较法'],["D",'扣分法'],["A",'加分法'],["M",'目标参照法'],["K",'实际值法'])

Property MethodCode As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = KPIM_Code ];

Storage Default
{
<Data name="KPIMethodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MethodCode</Value>
</Value>
<Value name="3">
<Value>MethodName</Value>
</Value>
</Data>
<DataLocation>^DHCCJXPAKPIMethodD</DataLocation>
<DefaultData>KPIMethodDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPAKPIMethodD</IdLocation>
<IndexLocation>^DHCCJXPAKPIMethodI</IndexLocation>
<StreamLocation>^DHCCJXPAKPIMethodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
