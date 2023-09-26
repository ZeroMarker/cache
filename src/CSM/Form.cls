Class CSM.Form Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 中文名称
Property CName As %String(TRUNCATE = 1);

/// 创建日期时间
Property CreateDateTime As %String(MAXLEN = 20, TRUNCATE = 1);

/// 英文名称（即数据库表名）
Property EName As %String(TRUNCATE = 1) [ Required ];

/// 作者的用户ID
Property CreateUserID As %Integer;

/// 数据采集条件（只有数据采集表单才有）
Property DECondition As %String(MAXLEN = 500, TRUNCATE = 1);

/// 所属项目ID
Property ProjectID As %Integer [ Required ];

/// 本表单填写的病例数
Property DataCount As %Integer;

/// FormID（使用改良的GUID，以满足级联更新元数据表的需要）
Property FormID As %String(MAXLEN = 36, TRUNCATE = 1) [ Required ];

/// 最后修改日期时间
Property LastModifyDateTime As %String(MAXLEN = 20, TRUNCATE = 1);

/// 最后修改用户ID
Property LastModifyUserID As %Integer;

/// 类型：CRF，DE
Property Type As %String(MAXLEN = 10, TRUNCATE = 1);

/// 表单的分组信息
Property CatalogID As %Integer [ Required ];

//Index MainIndex On FormID [ IdKey, Unique ];

Storage Default
{
<Data name="FormDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CName</Value>
</Value>
<Value name="3">
<Value>CreateDateTime</Value>
</Value>
<Value name="4">
<Value>CreateUserID</Value>
</Value>
<Value name="5">
<Value>DECondition</Value>
</Value>
<Value name="6">
<Value>DataCount</Value>
</Value>
<Value name="7">
<Value>EName</Value>
</Value>
<Value name="8">
<Value>LastModifyDateTime</Value>
</Value>
<Value name="9">
<Value>LastModifyUserID</Value>
</Value>
<Value name="10">
<Value>ProjectID</Value>
</Value>
<Value name="11">
<Value>Type</Value>
</Value>
<Value name="12">
<Value>FormID</Value>
</Value>
<Value name="13">
<Value>CatalogID</Value>
</Value>
</Data>
<DataLocation>^CSM.FormD</DataLocation>
<DefaultData>FormDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.FormD</IdLocation>
<IndexLocation>^CSM.FormI</IndexLocation>
<StreamLocation>^CSM.FormS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
