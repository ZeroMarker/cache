/// 已注册方法参数
Class User.EnsRegisteredServiceSOAPParameter Extends %Persistent [ SqlTableName = Ens_RegisteredServiceSOAPParameter ]
{

/// DDL Primary Key Specification
Index PKParameterCode On (ServiceCode, MethodCode, ParameterCode) [ PrimaryKey, SqlName = PK_ParameterCode, Type = index, Unique ];

/// Foreign Key FKMethRefPara created via DDL
ForeignKey FKMethRefPara(ServiceCode,MethodCode) References User.EnsRegisteredServiceSOAPMethod(PKMethodCode) [ OnDelete = cascade, OnUpdate = cascade, SqlName = FK_Meth_Ref_Para ];

/// Foreign Key FKServRefPara created via DDL
ForeignKey FKServRefPara(ServiceCode) References User.EnsRegisteredService(PKServiceCode) [ OnDelete = cascade, OnUpdate = cascade, SqlName = FK_Serv_Ref_Para ];

/// 已注册服务主键
Property ServiceCode As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 2 ];

/// 方法代码
Property MethodCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 3 ];

/// 参数代码
Property ParameterCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

/// 参数类型
Property ParameterType As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 5 ];

/// 数据类型
Property DataType As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 6 ];

/// 参数名称
Property ParameterDesc As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 7 ];

/// 参数描述
Property ParameterNote As %Library.String(MAXLEN = 200) [ SqlColumnNumber = 8 ];

/// 更新日期
Property UpdateDate As %Library.Date [ InitialExpression = {$P($H,",")}, SqlColumnNumber = 9 ];

/// 更新时间 
Property UpdateTime As %Library.Time [ InitialExpression = {$P($H,",",2)}, SqlColumnNumber = 10 ];

/// 序号
/// XPATH路径
Storage Default
{
<CounterLocation>^Busi.ENS.RegisteredServiceSParC</CounterLocation>
<Data name="RegisteredServiceSOAPParameterDefaultData">
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
<Value>ParameterType</Value>
</Value>
<Value name="6">
<Value>DataType</Value>
</Value>
<Value name="7">
<Value>ParameterDesc</Value>
</Value>
<Value name="8">
<Value>ParameterNote</Value>
</Value>
<Value name="9">
<Value>UpdateDate</Value>
</Value>
<Value name="10">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^Busi.ENS.RegisteredServiceSParD</DataLocation>
<DefaultData>RegisteredServiceSOAPParameterDefaultData</DefaultData>
<Description>
<![CDATA[序号
XPATH路径]]></Description>
<ExtentSize>100000</ExtentSize>
<IdLocation>^Busi.ENS.RegisteredServiceSParD</IdLocation>
<IndexLocation>^Busi.ENS.RegisteredServiceSParI</IndexLocation>
<StreamLocation>^Busi.ENS.RegisteredServiceSParS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
