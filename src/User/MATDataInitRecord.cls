/// 数据初始化记录
Class User.MATDataInitRecord Extends (%Persistent, User.Abstract) [ SqlTableName = MAT_DataInitRecord ]
{

/// 类型
Property MATDIRType As %Library.String [ SqlColumnNumber = 2, SqlFieldName = MATDIR_Type ];

/// 操作日期
Property MATDIRDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = MATDIR_Date ];

/// 操作时间
Property MATDIRTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = MATDIR_Time ];

/// 操作人
Property MATDIRUser As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = MATDIR_User ];

/// 院区
Property MATDIRHosp As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = MATDIR_Hosp ];

Index Type On MATDIRType As Exact;

Storage Default
{
<Data name="MATDataInitRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MATDIRType</Value>
</Value>
<Value name="3">
<Value>MATDIRDate</Value>
</Value>
<Value name="4">
<Value>MATDIRTime</Value>
</Value>
<Value name="5">
<Value>MATDIRUser</Value>
</Value>
<Value name="6">
<Value>MATDIRHosp</Value>
</Value>
</Data>
<DataLocation>^User.MATDataInitRecordD</DataLocation>
<DefaultData>MATDataInitRecordDefaultData</DefaultData>
<IdLocation>^User.MATDataInitRecordD</IdLocation>
<IndexLocation>^User.MATDataInitRecordI</IndexLocation>
<SqlRowIdName>MAT_DataInitRecord</SqlRowIdName>
<StreamLocation>^User.MATDataInitRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
