/// 麻醉记录参数明细
Class CIS.AN.ParaItem Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = ParaItem ]
{

/// 麻醉记录表单
Property RecordSheet As CIS.AN.RecordSheet [ Required, SqlColumnNumber = 2 ];

/// 数据分类项目
Property CategoryItem As CT.AN.DataCateItem [ SqlColumnNumber = 3 ];

/// 代码
Property Code As %String(MAXLEN = 100) [ Required, SqlColumnNumber = 4 ];

/// 描述
Property Description As %String(MAXLEN = 100) [ Required, SqlColumnNumber = 5 ];

/// 数据分类
Property DataCategory As CT.AN.DataCategory [ Required, SqlColumnNumber = 6 ];

/// 排序号
Property Seq As %Integer [ SqlColumnNumber = 7 ];

/// 用户自定义项
Property UserDefinedItem As CF.AN.UserDefDataItem [ SqlColumnNumber = 8 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 9 ];

/// 麻醉记录表单外键约束
ForeignKey FKRecordSheet(RecordSheet) References CIS.AN.RecordSheet() [ OnDelete = cascade ];

/// 麻醉记录表单索引
Index ISheet On RecordSheet;

Storage Default
{
<Data name="ParaItemDefaultData">
<Value name="1">
<Value>RecordSheet</Value>
</Value>
<Value name="2">
<Value>CategoryItem</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>DataCategory</Value>
</Value>
<Value name="6">
<Value>Seq</Value>
</Value>
<Value name="7">
<Value>UserDefinedItem</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.ParaItemD</DataLocation>
<DefaultData>ParaItemDefaultData</DefaultData>
<IdLocation>^CIS.AN.ParaItemD</IdLocation>
<IndexLocation>^CIS.AN.ParaItemI</IndexLocation>
<StreamLocation>^CIS.AN.ParaItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
