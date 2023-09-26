/// 用户快捷数据自动同步记录
Class CIS.AN.UserPreferedDataAutoLog Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = UserPreferedDataAutoLog ]
{

/// 手术麻醉记录表单
Property RecordSheet As CIS.AN.RecordSheet [ Required, SqlColumnNumber = 2 ];

/// 用户快捷数据
Property UserPreferedData As CF.AN.UserPreferedData [ Required, SqlColumnNumber = 3 ];

/// 麻醉监护数据
Property AnaData As CIS.AN.AnaData [ Required, SqlColumnNumber = 4 ];

/// 用户快捷数据索引
Index IData On (RecordSheet, UserPreferedData);

/// 手术麻醉记录表单外键约束
ForeignKey FKRecordSheet(RecordSheet) References CIS.AN.RecordSheet() [ OnDelete = cascade ];

/// 用户快捷数据外键约束
ForeignKey FKUserPreferedData(UserPreferedData) References CF.AN.UserPreferedData() [ OnDelete = cascade ];

Storage Default
{
<Data name="UserPreferedDataAutoLogDefaultData">
<Value name="1">
<Value>RecordSheet</Value>
</Value>
<Value name="2">
<Value>UserPreferedData</Value>
</Value>
<Value name="3">
<Value>AnaData</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.UserPrefere8A05D</DataLocation>
<DefaultData>UserPreferedDataAutoLogDefaultData</DefaultData>
<IdLocation>^CIS.AN.UserPrefere8A05D</IdLocation>
<IndexLocation>^CIS.AN.UserPrefere8A05I</IndexLocation>
<StreamLocation>^CIS.AN.UserPrefere8A05S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
