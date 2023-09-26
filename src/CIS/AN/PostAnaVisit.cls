/// 麻醉后访视
Class CIS.AN.PostAnaVisit Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = PostAnaVisit ]
{

/// 手术麻醉记录表单
Property RecordSheet As CIS.AN.RecordSheet [ Required, SqlColumnNumber = 2 ];

/// 镇痛泵类型
Property PCAType As %String [ SqlColumnNumber = 3 ];

/// 手术麻醉记录表单索引
Index ISheet On RecordSheet;

/// 手术麻醉记录表单外键约束
ForeignKey FKRecordSheet(RecordSheet) References CIS.AN.RecordSheet() [ OnDelete = cascade ];

/// 镇痛泵类型索引
Index IPCAType On PCAType;

Storage Default
{
<Data name="PostAnaVisitDefaultData">
<Value name="1">
<Value>RecordSheet</Value>
</Value>
<Value name="2">
<Value>PCAType</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.PostAnaVisitD</DataLocation>
<DefaultData>PostAnaVisitDefaultData</DefaultData>
<IdLocation>^CIS.AN.PostAnaVisitD</IdLocation>
<IndexLocation>^CIS.AN.PostAnaVisitI</IndexLocation>
<StreamLocation>^CIS.AN.PostAnaVisitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
