/// 东华表结构名称与中文对照表
/// 2015-01-23 zhaocz
/// 父表
Class User.BDPTableList Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_TableList ]
{

///  ParRef
Relationship ChildField As User.BDPTableField [ Cardinality = children, Inverse = ParRef ];

/// 例外医院子表
Relationship ChildExceptionHosp As User.BDPExceptionHosp [ Cardinality = children, Inverse = ExceptionHospParRef ];

/// 类名称(User.ARCItemCat)
Property TableName As %String(MAXLEN = "") [ Required ];

/// 中文名称
Property TableDesc As %String(MAXLEN = "") [ Required ];

/// 获取 这个表中的中文描述字段值 
/// 使用X执行
Property XCode As %String(MAXLEN = 99999);

Property Type As %String;

/// 获取 这个表中的代码字段值 
Property XCode2 As %String(MAXLEN = 9999);

/// 是否父表,是否BI数据来源
Property Sources As %String(MAXLEN = "");

/// 表名称(ARC_ItemCat)
Property ClassName As %String(MAXLEN = "");

/// Global
Property TableGlobal As %String(MAXLEN = "");

/// 共有私有类型 公有G,私有S,管控C,绝对私有A
Property DataType As %String(MAXLEN = "");

/// 是否区分版本 2019年12月19日
Property VersionFlag As %String(MAXLEN = "");

/// 是否使用公共私有数据关联表 2020年3月26日 Y/N
Property MappingHospFlag As %String(MAXLEN = "");

/// 是否特别 2020年4月29日--去掉了不用了。
Property SpecialFlag As %String(MAXLEN = "");

/// 属性 基础数据/配置数据	2020年5月7日
Property Attribute As %String(MAXLEN = "");

/// 描述在表里的字段名（翻译，排序，日志，基础数据授权等都会用到） ARCICDesc
Property DescPropertyName As %String(MAXLEN = 50);

/// 代码在表里的字段名  ARCICCode
Property CodePropertyName As %String(MAXLEN = 50);

/// 标准数据类型 国标/行标/省标/企标
Property StandardDataType As %String(MAXLEN = 50);

/// 标准数据版本
Property StandardDataVersion As %String(MAXLEN = 50);

/// 增删改管控权限	2021-09-05
Property AUDControlRights As %String(MAXLEN = "");

/***************增删改管控权限窗口勾选***2021-09-05**************/
/// 禁止新增
Property BanAdd As %String(MAXLEN = "");

/// 禁止修改
Property BanUpdate As %String(MAXLEN = "");

/// 禁止删除
Property BanDelete As %String(MAXLEN = "");

Index UqIndex On TableName;

Index NameIndex On ClassName;

Index DataTypeRef On DataType As Exact;

Index TableNameDataTypeRef On (TableName As Exact, DataType As Exact);

Index ClassNameDataTypeRef On (ClassName As Exact, DataType As Exact);

Index SubProDescIndex On (TableName As Exact, DescPropertyName As Exact);

Storage Default
{
<Data name="BDPTableListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TableName</Value>
</Value>
<Value name="3">
<Value>TableDesc</Value>
</Value>
<Value name="4">
<Value>XCode</Value>
</Value>
<Value name="5">
<Value>Type</Value>
</Value>
<Value name="6">
<Value>XCode2</Value>
</Value>
<Value name="7">
<Value>Sources</Value>
</Value>
<Value name="8">
<Value>ClassName</Value>
</Value>
<Value name="9">
<Value>TableGlobal</Value>
</Value>
<Value name="10">
<Value>DataType</Value>
</Value>
<Value name="11">
<Value>VersionFlag</Value>
</Value>
<Value name="12">
<Value>MappingHospFlag</Value>
</Value>
<Value name="13">
<Value>SpecialFlag</Value>
</Value>
<Value name="14">
<Value>Attribute</Value>
</Value>
<Value name="15">
<Value>DescPropertyName</Value>
</Value>
<Value name="16">
<Value>CodePropertyName</Value>
</Value>
<Value name="17">
<Value>StandardDataType</Value>
</Value>
<Value name="18">
<Value>StandardDataVersion</Value>
</Value>
<Value name="19">
<Value>AUDControlRights</Value>
</Value>
<Value name="20">
<Value>BanAdd</Value>
</Value>
<Value name="21">
<Value>BanUpdate</Value>
</Value>
<Value name="22">
<Value>BanDelete</Value>
</Value>
</Data>
<DataLocation>^User.BDPTableListD</DataLocation>
<DefaultData>BDPTableListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPTableListD</IdLocation>
<IndexLocation>^User.BDPTableListI</IndexLocation>
<StreamLocation>^User.BDPTableListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
