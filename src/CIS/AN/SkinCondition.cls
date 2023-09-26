/// 皮肤情况
Class CIS.AN.SkinCondition Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = SkinCondition ]
{

/// 手麻记录表单
Property RecordSheet As CIS.AN.RecordSheet [ Required, SqlColumnNumber = 2 ];

/// 压疮部位
Property BodySite As CT.AN.DataOptions [ SqlColumnNumber = 3 ];

/// 面积
Property Area As %String [ SqlColumnNumber = 4 ];

/// 分期
Property Period As %String [ SqlColumnNumber = 5 ];

/// 更新用户
Property UpdateUser As %String [ SqlColumnNumber = 6 ];

/// 更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 7 ];

/// 更新时间
Property UpdateTime As %Time [ SqlColumnNumber = 8 ];

/// 元素ID
Property ElementID As %String [ SqlColumnNumber = 9 ];

/// 压疮部位名称(可能手工输入)
Property BodySiteMark As %String [ SqlColumnNumber = 10 ];

/// 手术麻醉记录表单索引
Index IRecordSheet On RecordSheet;

/// 手术麻醉记录表单外键约束
ForeignKey FKRecordSheet(RecordSheet) References CIS.AN.RecordSheet() [ OnDelete = cascade ];

Storage Default
{
<Data name="SkinConditionDefaultData">
<Value name="1">
<Value>RecordSheet</Value>
</Value>
<Value name="2">
<Value>BodySite</Value>
</Value>
<Value name="3">
<Value>Area</Value>
</Value>
<Value name="4">
<Value>Period</Value>
</Value>
<Value name="5">
<Value>UpdateUser</Value>
</Value>
<Value name="6">
<Value>UpdateDate</Value>
</Value>
<Value name="7">
<Value>UpdateTime</Value>
</Value>
<Value name="8">
<Value>ElementID</Value>
</Value>
<Value name="9">
<Value>BodySiteMark</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.SkinConditionD</DataLocation>
<DefaultData>SkinConditionDefaultData</DefaultData>
<IdLocation>^CIS.AN.SkinConditionD</IdLocation>
<IndexLocation>^CIS.AN.SkinConditionI</IndexLocation>
<StreamLocation>^CIS.AN.SkinConditionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
