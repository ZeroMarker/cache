Class CT.STER.CSSD.DataInitRecord Extends %Persistent [ SqlTableName = DataInitRecord ]
{

/// 类型
Property DIRType As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = DIR_Type ];

/// 操作日期
Property DIRDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = DIR_Date ];

/// 操作时间
Property DIRTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = DIR_Time ];

/// 操作人
Property DIRUser As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = DIR_User ];

/// 院区
Property DIRHosp As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = DIR_Hosp ];

Index Type On DIRType As Exact;

Index TypeHosp On (DIRType As Exact, DIRHosp As Exact);

Storage Default
{
<Data name="DataInitRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DIRType</Value>
</Value>
<Value name="3">
<Value>DIRDate</Value>
</Value>
<Value name="4">
<Value>DIRTime</Value>
</Value>
<Value name="5">
<Value>DIRUser</Value>
</Value>
<Value name="6">
<Value>DIRHosp</Value>
</Value>
</Data>
<DataLocation>^CT.STER.CSSD.DataInitRecordD</DataLocation>
<DefaultData>DataInitRecordDefaultData</DefaultData>
<IdLocation>^CT.STER.CSSD.DataInitRecordD</IdLocation>
<IndexLocation>^CT.STER.CSSD.DataInitRecordI</IndexLocation>
<StreamLocation>^CT.STER.CSSD.DataInitRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
