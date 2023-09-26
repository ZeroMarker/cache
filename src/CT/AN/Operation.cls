/// 手术名称
Class CT.AN.Operation Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Operation ]
{

/// 手术代码
Property Code As %String(MAXLEN = 100) [ SqlColumnNumber = 2 ];

/// 手术名称
Property Description As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 手术别名(多个别名以";"拼接)
Property Alias As %String(MAXLEN = 500) [ SqlColumnNumber = 4 ];

/// 手术ICD9编码
Property ICD9 As %String(MAXLEN = 20) [ SqlColumnNumber = 5 ];

/// 手术ICD10编码
Property ICD10 As %String(MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 手术的默认分级
Property OperClass As CT.AN.DictData [ SqlColumnNumber = 7 ];

/// 手术的默认部位
Property BodySite As CT.AN.DictData [ SqlColumnNumber = 8 ];

/// 手术的默认切口类型
Property BladeType As CT.AN.DictData [ SqlColumnNumber = 9 ];

/// 手术的默认体位
Property OperPosition As CT.AN.DictData [ SqlColumnNumber = 10 ];

/// 手术类型
Property OperType As %String(DISPLAYLIST = ",诊断性操作,治疗性操作,手术,介入治疗", MAXLEN = 10, VALUELIST = ",T,D,N,I") [ SqlColumnNumber = 11 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 12 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 13 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 14 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 15 ];

/// 开始年龄
Property AgeFrom As %String [ SqlColumnNumber = 16 ];

/// 结束年龄
Property AgeTo As %String [ SqlColumnNumber = 17 ];

/// 日间手术
Property DaySurgery As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 18 ];

/// 性别
Property Gender As %String [ SqlColumnNumber = 19 ];

/// 微创手术标志
Property MIS As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 20 ];

/// 手术代码唯一索引
Index ICode On Code [ Unique ];

/// 手术分级索引
Index IOperClass On OperClass;

/// 手术类型索引
Index IOperType On OperType;

/// ICD9索引
Index IICD9 On ICD9;

/// ICD10索引
Index IICD10 On ICD10;

/// 外部系统ID索引
Index IExt On ExternalID;

/// 日间手术标志索引
Index IDaySurgery On DaySurgery;

Storage Default
{
<Data name="OperationDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Alias</Value>
</Value>
<Value name="4">
<Value>ICD9</Value>
</Value>
<Value name="5">
<Value>ICD10</Value>
</Value>
<Value name="6">
<Value>OperClass</Value>
</Value>
<Value name="7">
<Value>BodySite</Value>
</Value>
<Value name="8">
<Value>BladeType</Value>
</Value>
<Value name="9">
<Value>OperPosition</Value>
</Value>
<Value name="10">
<Value>OperType</Value>
</Value>
<Value name="11">
<Value>ActiveDate</Value>
</Value>
<Value name="12">
<Value>ExpireDate</Value>
</Value>
<Value name="13">
<Value>ExternalID</Value>
</Value>
<Value name="14">
<Value>Active</Value>
</Value>
<Value name="15">
<Value>AgeFrom</Value>
</Value>
<Value name="16">
<Value>AgeTo</Value>
</Value>
<Value name="17">
<Value>DaySurgery</Value>
</Value>
<Value name="18">
<Value>Gender</Value>
</Value>
<Value name="19">
<Value>MIS</Value>
</Value>
</Data>
<DataLocation>^CT.AN.OperationD</DataLocation>
<DefaultData>OperationDefaultData</DefaultData>
<IdLocation>^CT.AN.OperationD</IdLocation>
<IndexLocation>^CT.AN.OperationI</IndexLocation>
<StreamLocation>^CT.AN.OperationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
