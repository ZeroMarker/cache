/// 数据初始化记录
Class CT.HRP.MAT.DataInitRecord Extends (%Persistent, User.Abstract) [ SqlTableName = DataInitRecord ]
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
<Data name="DataInitRecordDefaultData">
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
<DataLocation>^CT.HRP.MAT.DataInitRecordD</DataLocation>
<DefaultData>DataInitRecordDefaultData</DefaultData>
<IdLocation>^CT.HRP.MAT.DataInitRecordD</IdLocation>
<IndexLocation>^CT.HRP.MAT.DataInitRecordI</IndexLocation>
<StreamLocation>^CT.HRP.MAT.DataInitRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
