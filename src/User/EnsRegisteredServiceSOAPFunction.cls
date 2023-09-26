Class User.EnsRegisteredServiceSOAPFunction Extends %Persistent [ SqlTableName = Ens_RegisteredServiceSOAPFunction ]
{

/// DDL Primary Key Specification
Index PKFunctionCode On (ServiceCode, MethodCode, ParameterCode, FunctionCode) [ PrimaryKey, SqlName = PK_FunctionCode, Type = index, Unique ];

/// Foreign Key FKMethRefFunc created via DDL
ForeignKey FKMethRefFunc(ServiceCode,MethodCode) References User.EnsRegisteredServiceSOAPMethod(PKMethodCode) [ OnDelete = cascade, OnUpdate = cascade, SqlName = FK_Meth_Ref_Func ];

/// Foreign Key FKParaRefFunc created via DDL
ForeignKey FKParaRefFunc(ServiceCode,MethodCode,ParameterCode) References User.EnsRegisteredServiceSOAPParameter(PKParameterCode) [ OnDelete = cascade, OnUpdate = cascade, SqlName = FK_Para_Ref_Func ];

/// Foreign Key FKServRefFunc created via DDL
ForeignKey FKServRefFunc(ServiceCode) References User.EnsRegisteredService(PKServiceCode) [ OnDelete = cascade, OnUpdate = cascade, SqlName = FK_Serv_Ref_Func ];

/// 服务代码
Property ServiceCode As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 2 ];

/// 方法代码
Property MethodCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 3 ];

/// 参数代码
Property ParameterCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 4 ];

/// 功能代码
Property FunctionCode As %Library.String(COLLATION = "EXACT", MAXLEN = 200) [ Required, SqlColumnNumber = 5 ];

/// 功能描述
Property FunctionDesc As %Library.String(MAXLEN = 200) [ SqlColumnNumber = 6 ];

/// 更新日期
Property UpdateDate As %Library.Date [ InitialExpression = {$P($H,",")}, SqlColumnNumber = 7 ];

/// 更新时间
Property UpdateTime As %Library.Time [ InitialExpression = {$P($H,",",2)}, SqlColumnNumber = 8 ];

/// 参数XML格式
Property XMLFormat As %Library.GlobalCharacterStream [ SqlColumnNumber = 9 ];

/// 返回值规则
Property RtnRule As %Library.GlobalCharacterStream [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="RegisteredServiceSOAPFunctionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ServiceCode</Value>
</Value>
<Value name="3">
<Value>MethodCode</Value>
</Value>
<Value name="4">
<Value>ParameterCode</Value>
</Value>
<Value name="5">
<Value>FunctionCode</Value>
</Value>
<Value name="6">
<Value>FunctionDesc</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>UpdateTime</Value>
</Value>
<Value name="9">
<Value>XMLFormat</Value>
</Value>
<Value name="10">
<Value>RtnRule</Value>
</Value>
</Data>
<DataLocation>^Busi.ENS.RegisteredServiceSFunD</DataLocation>
<DefaultData>RegisteredServiceSOAPFunctionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^Busi.ENS.RegisteredServiceSFunD</IdLocation>
<IndexLocation>^Busi.ENS.RegisteredServiceSFunI</IndexLocation>
<StreamLocation>^Busi.ENS.RegisteredServiceSFunS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
