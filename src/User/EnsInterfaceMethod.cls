Class User.EnsInterfaceMethod Extends (%Persistent, %XML.Adaptor) [ SqlTableName = Ens_InterfaceMethod ]
{

/// 方法代码
Property methodCode As %String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 2, SqlFieldName = method_Code ];

/// 方法描述
Property methodDesc As %String(MAXLEN = 200) [ SqlColumnNumber = 3, SqlFieldName = method_Desc ];

/// 状态(Yes：运行，No：停止)
Property methodStatus As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = method_Status ];

/// 所属产品组
Property methodProcuctionTerm As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 5, SqlFieldName = method_ProcuctionTerm ];

/// 方法所在类名称
Property methodClassName As %String(MAXLEN = 100) [ SqlColumnNumber = 6, SqlFieldName = method_ClassName ];

/// 方法名称
Property methodName As %String(MAXLEN = 50) [ SqlColumnNumber = 7, SqlFieldName = method_Name ];

/// 方法类型
Property methodType As %String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 8, SqlFieldName = method_Type ];

/// 方法所在类名称 （自动生成）
Property methodPublishClassName As %String(MAXLEN = 100) [ SqlColumnNumber = 9, SqlFieldName = method_PublishClassName ];

/// 方法名称 （自动生成）
Property methodPublishName As %String(MAXLEN = 50) [ SqlColumnNumber = 10, SqlFieldName = method_PublishName ];

/// 入参格式类型和说明，多个之间有逗号分隔
Property methodInput As %String(MAXLEN = 2000) [ SqlColumnNumber = 11, SqlFieldName = method_Input ];

/// 返回值类型和说明，多个之间有逗号分隔
Property methodOutput As %String(MAXLEN = 500) [ SqlColumnNumber = 12, SqlFieldName = method_Output ];

/// 备注
Property methodNote As %String(MAXLEN = 1000) [ SqlColumnNumber = 13, SqlFieldName = method_Note ];

/// 创建日期
Property insertDate As %Date(XMLPROJECTION = "NONE") [ InitialExpression = {$P($H,",")}, SqlColumnNumber = 14 ];

/// 创建时间
Property insertTime As %Time(XMLPROJECTION = "NONE") [ InitialExpression = {$P($H,",",2)}, SqlColumnNumber = 15 ];

/// 日志记录标识
Property EnsInterfaceFlag As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = EnsInterface_Flag ];

/// 总线同步标识
Property HsbSyncFlag As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = HsbSync_Flag ];

/// 接口消息实例
Property MessageInstance As %String(MAXLEN = "") [ SqlColumnNumber = 18, SqlFieldName = MessageInstance ];

Index MethodCode On (methodType, methodCode) [ Unique ];

Index MethodProcuctionTerm On (methodProcuctionTerm, methodStatus);

Relationship ChildEnsMethdItem As User.EnsInterfaceMethodItem [ Cardinality = children, Inverse = EnsMethdItemRef ];

// Relationship ChildEnsInterface As User.EnsInterfaceV8 [ Cardinality = children, Inverse = ensInterMethodRef ];

Storage Default
{
<CounterLocation>^User.EnsInterfaceMethodC</CounterLocation>
<Data name="EnsInterfaceMethodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>methodCode</Value>
</Value>
<Value name="3">
<Value>methodDesc</Value>
</Value>
<Value name="4">
<Value>methodStatus</Value>
</Value>
<Value name="5">
<Value>methodProcuctionTerm</Value>
</Value>
<Value name="6">
<Value>methodClassName</Value>
</Value>
<Value name="7">
<Value>methodName</Value>
</Value>
<Value name="8">
<Value>methodType</Value>
</Value>
<Value name="9">
<Value>methodPublishClassName</Value>
</Value>
<Value name="10">
<Value>methodPublishName</Value>
</Value>
<Value name="11">
<Value>methodInput</Value>
</Value>
<Value name="12">
<Value>methodOutput</Value>
</Value>
<Value name="13">
<Value>methodNote</Value>
</Value>
<Value name="14">
<Value>insertDate</Value>
</Value>
<Value name="15">
<Value>insertTime</Value>
</Value>
<Value name="16">
<Value>EnsInterfaceFlag</Value>
</Value>
<Value name="17">
<Value>HsbSyncFlag</Value>
</Value>
<Value name="18">
<Value>MessageInstance</Value>
</Value>
</Data>
<DataLocation>^User.EnsInterfaceMethodD</DataLocation>
<DefaultData>EnsInterfaceMethodDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.EnsInterfaceMethodD</IdLocation>
<IndexLocation>^User.EnsInterfaceMethodI</IndexLocation>
<StreamLocation>^User.EnsInterfaceMethodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
